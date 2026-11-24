/* (Try to) find record description from table name and value of primary key
         
   Created:  13.01.12 by Brynjar Hasle 
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOk        AS LOG NO-UNDO.

DEF VAR cTable     AS CHAR   NO-UNDO.
DEF VAR hBuffer    AS HANDLE NO-UNDO.
DEF VAR hPkFlds    AS HANDLE NO-UNDO EXTENT 10.
DEF VAR ix         AS INT    NO-UNDO.
DEF VAR iy         AS INT    NO-UNDO.
DEF VAR cPkFlds    AS CHAR   NO-UNDO.
DEF VAR cWhere     AS CHAR   NO-UNDO INIT "WHERE ".
DEF VAR cPKvalue   AS CHAR   NO-UNDO.
DEF VAR cPKvalList AS CHAR   NO-UNDO.
DEF VAR bOk        AS LOG    NO-UNDO.
DEF VAR cCharField AS CHAR   NO-UNDO.

{incl/validatecaller.i}

ASSIGN cTable     = ENTRY(1,icParam,"¤")
       cPKvalList = ENTRY(2,icParam,"¤")
       .

DEF VAR hb_file        AS HANDLE NO-UNDO.
DEF VAR hb_index       AS HANDLE NO-UNDO.
DEF VAR hb_index-field AS HANDLE NO-UNDO.
DEF VAR hb_field       AS HANDLE NO-UNDO.
DEF VAR hqIdxFld       AS HANDLE NO-UNDO.
DEF VAR hqFld          AS HANDLE NO-UNDO.
DEF VAR bFound         AS LOG    NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("_file",OUTPUT hb_file) THEN RETURN.
       
CREATE BUFFER hb_index       FOR TABLE "_index".       
CREATE BUFFER hb_index-field FOR TABLE "_index-field".       
CREATE BUFFER hb_field       FOR TABLE "_field".       

bFound = hb_file:FIND-FIRST("WHERE _File._File-Name = '" + cTable + "'",NO-LOCK) NO-ERROR.
     
IF bFound THEN DO:
  CREATE QUERY hqIdxFld.
  hqIdxFld:SET-BUFFERS (hb_index,hb_index-field,hb_field).
  hqIdxFld:QUERY-PREPARE("FOR EACH _Index NO-LOCK WHERE _index._file-recid = " + STRING(hb_file:RECID)
                       + " AND _Index._Unique"
                       + " AND _Index._Active"
                       + ",EACH _Index-Field NO-LOCK OF _Index"
                       + ",FIRST _Field NO-LOCK OF _Index-Field"
                       + " BREAK BY _Index._Index-Name").
  hqIdxFld:QUERY-OPEN ().
  REPEAT WHILE hqIdxFld:GET-NEXT():                     
    ASSIGN ix      = ix + 1
           cPkFlds = cPkFlds + (IF cPkFlds NE "" THEN "," ELSE "") 
                   + hb_Field::_Field-Name
           .
    IF ix > 10 THEN DO:
      cPkFlds = "".
      LEAVE.
    END.
    IF hqIdxFld:LAST-OF(1) THEN DO:
      IF ix = NUM-ENTRIES(cPKvalList,"|") THEN 
        LEAVE.
      ASSIGN ix      = 0
             cPkFlds = "".
    END.
  END.

  IF cPkFlds NE "" THEN DO:
    CREATE BUFFER hBuffer FOR TABLE cTable.
    DO iy = 1 TO ix:
      ASSIGN hPkFlds[iy] = hBuffer:BUFFER-FIELD(ENTRY(iy,cPkFlds))
             cPkValue    = ENTRY(iy,cPKvalList).

      IF hPkFlds[iy]:DATA-TYPE = "CHARACTER" THEN
        cPKvalue = QUOTER(cPKvalue).
      ELSE IF hPkFlds[iy]:DATA-TYPE = "DECIMAL" THEN
        cPKvalue = 'DEC("' + cPKvalue + '")'.
      ELSE IF hPkFlds[iy]:DATA-TYPE = "DATE" THEN
        cPKvalue = 'DATE("' + cPKvalue + '")'.

      cWhere = cWhere + hPkFlds[iy]:NAME + " = " + cPKvalue + " AND ".
    END.
    cWhere = TRIM(cWhere," AND ").
    bOk = hBuffer:FIND-UNIQUE(cWhere,NO-LOCK) NO-ERROR.
  
    IF bOk THEN DO:
      bFound = hb_Field:FIND-FIRST("WHERE _field._file-recid = " + STRING(hb_file:RECID)
                                 + " AND _Field._Data-Type = 'CHARACTER'"
                                 + " AND (_Field._Field-Name MATCHES '*navn*' OR _Field._Field-Name MATCHES '*name*')",NO-LOCK)
               NO-ERROR.
      IF NOT bFound THEN
        bFound = hb_Field:FIND-FIRST("WHERE _field._file-recid = " + STRING(hb_file:RECID)
                                   + " AND _Field._Data-Type = 'CHARACTER'"
                                   + " AND (_Field._Field-Name MATCHES '*besk*' OR _Field._Field-Name MATCHES '*desc*')",NO-LOCK)
                 NO-ERROR.
      IF NOT bFound THEN
        bFound = hb_Field:FIND-FIRST("WHERE _field._file-recid = " + STRING(hb_file:RECID)
                                   + " AND _Field._Data-Type = 'CHARACTER'"
                                   + " AND (_Field._Field-Name MATCHES '*tekst*' OR _Field._Field-Name MATCHES '*text*')",NO-LOCK)
                 NO-ERROR.
      IF NOT bFound THEN
        bFound = hb_Field:FIND-FIRST("WHERE _field._file-recid = " + STRING(hb_file:RECID)
                                   + " AND _Field._Data-Type = 'CHARACTER'"
                                   + " AND (_Field._Field-Name MATCHES '*" + cTable + "*'",NO-LOCK)
                 NO-ERROR.
      IF NOT bFound THEN DO:
        CREATE QUERY hqFld.
        hqFld:SET-BUFFERS(hb_field).
        hqFld:QUERY-PREPARE ("FOR EACH _field NO-LOCK WHERE _field._file-recid = " + STRING(hb_file:RECID)
                           + " AND _Field._Data-Type = 'CHARACTER'"
                           + " BY _field._order").
        hqFld:QUERY-OPEN().
        REPEAT WHILE hqFld:GET-NEXT().
          cCharField = hb_Field::_Field-Name.
          LEAVE.
        END.
      END.  
      ELSE cCharField = hb_Field::_Field-Name.

      IF cCharField NE "" THEN
        ocReturn = (IF hb_File::_File-Label NE ? THEN hb_File::_File-Label ELSE hb_File::_File-Name) + ", " 
                 + hBuffer:BUFFER-FIELD(cCharField):LABEL + ": "
                 + hBuffer:BUFFER-FIELD(cCharField):BUFFER-VALUE.
    END.
  END.
END.

FINALLY:
  DELETE OBJECT hBuffer  NO-ERROR.
  DELETE OBJECT hqIdxFld NO-ERROR.
  DELETE OBJECT hqFld    NO-ERROR.
  DELETE OBJECT hb_file  NO-ERROR.
  DELETE OBJECT hb_index NO-ERROR.
  DELETE OBJECT hb_index-field NO-ERROR.

  obOk = ocReturn NE "".
END FINALLY.