/* Get db schema

   Created: 29/03/22 by Brynjar

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihDataSet   AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

{tt_schema.i}
hdsSchema = DATASET dsSchema:HANDLE.

DEF VAR ix AS INT NO-UNDO.
DEF VAR ixFileNum  AS INT NO-UNDO.
DEF VAR ixFieldNum AS INT NO-UNDO.
DEF VAR ixIdxNum   AS INT NO-UNDO.
DEF VAR ixDbNum    AS INT NO-UNDO.

DEF VAR cCurrDb     AS CHAR NO-UNDO.
DEF VAR iFileCnt    AS INT NO-UNDO.
DEF VAR iUsrFileCnt AS INT NO-UNDO.
DEF VAR hQueryDb    AS HANDLE NO-UNDO.
DEF VAR hQueryFile  AS HANDLE NO-UNDO.

IF icParam = "" THEN DO:
  CREATE QUERY hQueryDb.
  hQueryDb:SET-BUFFERS (ihDataSet:GET-BUFFER-HANDLE (1)).
  hQueryDb:QUERY-PREPARE ("FOR EACH tt_db BY iDbNum DESC").
  hQueryDb:QUERY-OPEN ().
  hQueryDb:GET-FIRST ().
  IF hQueryDb:GET-BUFFER-HANDLE (1):AVAIL THEN ixDbNum = hQueryDb:GET-BUFFER-HANDLE (1)::iDbNum.
  DELETE OBJECT hQueryDb.

  CREATE QUERY hQueryFile.
  hQueryFile:SET-BUFFERS (ihDataSet:GET-BUFFER-HANDLE (2)).
  hQueryFile:QUERY-PREPARE ("FOR EACH tt_file BY iFileNum DESC").
  hQueryFile:QUERY-OPEN ().
  hQueryFile:GET-FIRST ().
  IF hQueryFile:GET-BUFFER-HANDLE (1):AVAIL THEN ixFileNum = hQueryFile:GET-BUFFER-HANDLE (1)::iFileNum.
  DELETE OBJECT hQueryFile.
  
  REPEAT ix = 1 TO NUM-DBS:
    DELETE ALIAS dictdb.
    CREATE ALIAS dictdb FOR DATABASE VALUE (LDBNAME(ix)).
    JBoxServerSide:Instance:DataSetReplace = NO.
    IF JBoxServerSide:Instance:CallServerProc("jbserv_getschema.p",LDBNAME(ix) + "," + STRING(ixFileNum) + "," + STRING(ixDbNum + ix), hdsSchema) THEN
      ixFileNum = ixFileNum + INT(JBoxServerSide:Instance:getCallReturnParam()).
    ELSE DO:
      ocReturn = JBoxServerSide:Instance:getCallMessage().
      RETURN.
    END.
  END.
  IF ix > 1 THEN DO:
    DELETE ALIAS dictdb.
    CREATE ALIAS dictdb FOR DATABASE VALUE (LDBNAME(1)).
  END.  
END.
ELSE DO:
  
  CREATE tt_db.
  ASSIGN cCurrDb           = ENTRY(1,icParam)
         ixDbNum           = INT(ENTRY(3,icParam))
         tt_db.cLDBname    = cCurrDb
         tt_db.iDbNum      = ixDbNum
         tt_db.cDbType     = "Progress"
         ixFileNum      = INT(ENTRY(2,icParam)).
         
        
/*  FOR EACH dictdb._db-detail NO-LOCK:                        */
/*    IF _db-detail._Db-description MATCHES "*sql*" THEN       */
/*      tt_db.cDbType = _db-detail._Db-description.            */
/*    IF _db-detail._Db-custom-detail MATCHES "*sql*" THEN     */
/*      tt_db.cConnection = ENTRY(1,_Db-custom-detail,CHR(10)).*/
/*  END.                                                       */
    
  FOR EACH dictdb._file NO-LOCK:
    CREATE tt_file.
    ASSIGN tt_file.cLDBname   = cCurrDb
           ixFileNum          = ixFileNum + 1
           tt_file.iFileNum   = ixFileNum
           tt_file.cFile-Name = _file._file-name
           tt_file.cTbl-Type  = _file._Tbl-type
           tt_file.cType      = IF _file._Tbl-type = "T" AND _file._hidden THEN "VIEW" ELSE "TABLE" 
           tt_file.iDbNum     = ixDbNum
           iFileCnt           = iFileCnt + 1
           iUsrFileCnt        = iUsrFileCnt + (IF _file._Tbl-Type = "T" THEN  1 ELSE 0) 
           .
    
    FOR EACH dictdb._field OF dictdb._file NO-LOCK:
      CREATE tt_field.
      ASSIGN tt_field.iFileNum     = ixFileNum
             ixFieldNum            = ixFieldNum + 1
             tt_field.iFieldNum    = ixFieldNum
             tt_field.cData-Type   = _field._data-type
             tt_field.cField-Name  = _field._field-name
             tt_field.cFormat      = _field._format
             tt_field.cLabel       = _field._label
             tt_field.iOrder       = _field._order
             tt_field.iExtent      = _field._extent
             tt_field.iDbNum       = ixDbNum
             .
    END.
    FOR EACH dictdb._index OF dictdb._file NO-LOCK
        BY dictdb._index._index-name:
        
      CREATE tt_index.
      ASSIGN tt_index.iFileNum    = ixFileNum
             ixIdxNum             = ixIdxNum + 1
             tt_index.iIdxNum     = ixIdxNum
             tt_index.cCode       = (IF RECID(dictdb._index) = dictdb._file._prime-index THEN "P" 
                                     ELSE " ")
                                  + (IF dictdb._index._UNIQUE THEN "U" ELSE "")
             tt_index.bActive     = _index._active
             tt_index.bUnique     = _index._unique
             tt_index.cIndex-name = _index._index-name
             .
      
      FOR EACH dictdb._index-field OF dictdb._index NO-LOCK,
          EACH dictdb._field OF dictdb._index-field NO-LOCK:
        CREATE tt_index-field.
        ASSIGN tt_index-field.iFileNum   = ixFileNum
               tt_index-field.iIdxNum    = ixIdxNum
               tt_index-field.cFieldName = dictdb._field._field-name
               tt_index-field.iIdxSeq    = _index-field._index-seq
               .
        FOR FIRST tt_field 
            WHERE tt_field.iFileNum = ixFileNum 
              AND tt_field.cField-name = dictdb._field._field-name NO-LOCK:
          tt_index-field.iFieldNum = tt_field.iFieldNum.
        END.
      END.
    END.
  END.
  tt_db.iTableCnt    = iFileCnt.
  tt_db.iUsrTableCnt = iUsrFileCnt.
  
  FOR EACH dictdb._Sequence NO-LOCK:
    CREATE tt_sequence.
    ASSIGN tt_sequence.cLDBname  = cCurrDb
           tt_sequence.cSeq-name = _sequence._seq-name
           tt_sequence.iDbNum    = ixDbNum
           .
  END.   
END.  
  
FINALLY:
  obOk = ocReturn = "".
  IF obOk THEN DO: 
    ihDataSet:COPY-DATASET (hdsSchema,YES).
    IF icParam NE "" THEN 
      ocReturn = STRING(iFileCnt).
  END.  
END FINALLY.

