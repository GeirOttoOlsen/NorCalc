
/*------------------------------------------------------------------------
    File        : dbFormFldsToVar.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : brynj
    Created     : Wed Jun 26 14:33:05 CEST 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

{jukebox/tt_field.i NEW}
DEF VAR h_fieldBuf    AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttFieldDef
    FIELD cDb         AS CHAR
    FIELD cTable      AS CHAR
    FIELD cField      AS CHAR
    FIELD cNewField   AS CHAR
    FIELD cDefVar     AS CHAR
    FIELD iTableSeq   AS INT
    FIELD iSeq        AS INT
    FIELD cHelp       AS CHAR
    FIELD cTooltip    AS CHAR
    FIELD bTaken      AS LOG 
    INDEX idxField IS PRIMARY cField 
    .
DEF VAR httFieldDef AS HANDLE NO-UNDO.
httFieldDef = BUFFER ttFieldDef:HANDLE.

FUNCTION creFillInDefFromDb RETURNS CHARACTER
  ( INPUT icFieldList AS CHAR ) FORWARD.

FUNCTION creViewAsPhrase RETURNS CHARACTER
  ( INPUT icDataType AS CHAR ) FORWARD.

FUNCTION fixFieldFormat RETURNS CHARACTER
  ( INPUT ihFieldBuf AS HANDLE ) FORWARD.

FUNCTION creInitValueForLogical RETURNS CHARACTER
  (INPUT icFormat    AS CHAR,
   INPUT icInitValue AS CHAR ) FORWARD.

DEF VAR cFormFlds     AS CHAR.
DEF VAR ix            AS INT  NO-UNDO.
DEF VAR iy            AS INT  NO-UNDO.
DEF VAR cLine         AS CHAR NO-UNDO.
DEF VAR cLineEntry    AS CHAR NO-UNDO.
DEF VAR cNewLine      AS CHAR NO-UNDO.
DEF VAR cNewForm      AS CHAR NO-UNDO.
DEF VAR cNewLineEntry AS CHAR NO-UNDO.
DEF VAR iNum          AS INT  NO-UNDO.
DEF VAR cVarList      AS CHAR NO-UNDO.
DEF VAR cVarDef       AS CHAR NO-UNDO.
DEF VAR cWin          AS CHAR NO-UNDO INIT "DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.".
DEF VAR cFieldLevW    AS CHAR NO-UNDO INIT "Definitions of the field level widgets".
DEF VAR bFieldLevW    AS LOG  NO-UNDO.
DEF VAR cNoVarList    AS CHAR NO-UNDO. // wasn't variable..


cFormFlds = CLIPBOARD:VALUE.


DO ix = 1 TO NUM-ENTRIES(cFormFlds,CHR(10)):
  cLine = ENTRY(ix,cFormFlds,CHR(10)).
  cNewLine = "".
  IF cLine NE "" THEN DO iy = 1 TO NUM-ENTRIES(cLine," ").
    cLineEntry = ENTRY(iy,cLine," ").
    IF NUM-ENTRIES(cLineEntry,".") = 2 
       AND SUBSTR(cLineEntry,LENGTH(cLineEntry)) NE "." 
       AND SUBSTR(cLineEntry,LENGTH(cLineEntry) - 1) NE ":U" 
       AND NOT CAN-DO("w,p,ico,bmp,png,jpg,gif",ENTRY(2,cLineEntry,"."))
       THEN DO:
      iNum = INT(ENTRY(1,cLineEntry,".")) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:

        RUN getBttField ("",ENTRY(1,cLineEntry,"."),ENTRY(2,cLineEntry,"."),OUTPUT h_fieldBuf).
    
        IF VALID-HANDLE(h_fieldBuf) AND h_fieldBuf:AVAIL THEN DO:
          cNewLineEntry = ENTRY(2,cLineEntry,".").
          IF NOT CAN-DO(cVarList,cLineEntry) THEN
            cVarList = cVarList + (IF cVarList NE "" THEN "," ELSE "") + cLineEntry.
        END.    
        ELSE
          cNewLineEntry = cLineEntry.
      END.         
      ELSE
        cNewLineEntry = cLineEntry.
    END.  
    ELSE cNewLineEntry = cLineEntry.
        
    cNewLine = cNewLine + " " + cNewLineEntry.
  END.
  ELSE cNewLine = cLine.
  
  IF cNewLine MATCHES "*" + cFieldLevW + "*" THEN
    ASSIGN bFieldLevW = YES
           cNewLine   = cNewLine + CHR(10) + "putvariableshere" + CHR(10).
               
  cNewForm = cNewForm + (IF cNewForm NE "" THEN CHR(10) ELSE "") + TRIM(cNewLine).
END.

DO ix = 1 TO NUM-ENTRIES(cVarList):
  cFormFlds = REPLACE(cFormFlds,ENTRY(ix,cVarList),ENTRY(2,ENTRY(ix,cVarList),".")).
END.

cVarDef = creFillInDefFromDb (cVarList).

IF bFieldLevW THEN
  cNewForm = REPLACE(cNewForm,"putvariableshere",cVarDef).
  
//DO ix = 1 TO   

CLIPBOARD:VALUE = cNewForm.

IF NUM-ENTRIES(cVarList) > 0 THEN
  MESSAGE "Clipboard was modified: " NUM-ENTRIES(cVarList) " db-field references was replaced with variables"
  VIEW-AS ALERT-BOX INFORMATION.
ELSE
  MESSAGE "No db-field references was found in clipboard content"
          VIEW-AS ALERT-BOX INFORMATION.

FUNCTION creFillInDefFromDb RETURNS CHARACTER
  ( INPUT icFieldList AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR ocFieldDef  AS CHAR NO-UNDO.

DEF VAR ix            AS INT    NO-UNDO.
DEF VAR hQuery        AS HANDLE NO-UNDO.
DEF VAR cCurrDb       AS CHAR   NO-UNDO.
DEF VAR cNewField     AS CHAR   NO-UNDO.
DEF VAR h_fileBuf     AS HANDLE NO-UNDO.
DEF VAR cDelim        AS CHAR   NO-UNDO.
DEF VAR cClipList     AS CHAR   NO-UNDO.
DEF VAR iDuplCnt      AS INT    NO-UNDO.
DEF VAR cCurrTable    AS CHAR   NO-UNDO.
DEF VAR iTabSeq       AS INT    NO-UNDO.
DEF VAR cPriIdxFlds   AS CHAR   NO-UNDO.
DEF VAR cPriKeyFlds   AS CHAR   NO-UNDO.
DEF VAR cUpdFlds      AS CHAR   NO-UNDO.
DEF VAR cDispFlds     AS CHAR   NO-UNDO.
DEF VAR cPrimaryTable AS CHAR   NO-UNDO.
DEF VAR cFieldMap     AS CHAR   NO-UNDO.
DEF VAR cFileName     AS CHAR   NO-UNDO.      
DEF VAR cCode1        AS CHAR   NO-UNDO.
DEF VAR cCode2        AS CHAR   NO-UNDO.
DEF VAR cInitProc     AS CHAR   NO-UNDO.
DEF VAR cFieldPrefix  AS CHAR   NO-UNDO.
DEF VAR cFieldHelp    AS CHAR   NO-UNDO INIT "fh_t".

DEF BUFFER bttFieldDef FOR ttFieldDef.

FOR EACH ttFieldDef: DELETE ttFieldDef. END.

/*
IF (cDbFieldUsage = "" OR cDbFieldUsage = "ABdefault") AND cClipBoardFormat = "" THEN RETURN "".

CASE cClipBoardFormat:
  WHEN "comma"     THEN cDelim = ",".
  WHEN "space"     THEN cDelim = " ".
  WHEN "semicolon" THEN cDelim = ";".
  WHEN "other"     THEN cDelim = cClipBoardDelimiter.
END CASE.
*/

icFieldList = REPLACE(icFieldList,"Temp-Tables.","").
icFieldList = TRIM(icFieldList,".").

DO ix = 1 TO NUM-ENTRIES(icFieldList):
  CREATE ttFieldDef.
  
  IF NUM-ENTRIES(ENTRY(ix,icFieldList),".") = 3 THEN
    ASSIGN ttFieldDef.cDb     = ENTRY(1,ENTRY(ix,icFieldList),".")
           ttFieldDef.cTable  = ENTRY(2,ENTRY(ix,icFieldList),".")
           ttFieldDef.cField  = ENTRY(3,ENTRY(ix,icFieldList),".")
           .
  ELSE 
    ASSIGN ttFieldDef.cTable  = ENTRY(1,ENTRY(ix,icFieldList),".")
           ttFieldDef.cField  = ENTRY(2,ENTRY(ix,icFieldList),".")
           .
  iDuplCnt = 0.
  FOR EACH bttFieldDef
      WHERE bttFieldDef.cField = ttFieldDef.cField
        AND bttFieldDef.cTable NE ttFieldDef.cTable:
    iDuplCnt = iDuplCnt + 1.
  END.

  IF ttFieldDef.cTable NE cCurrTable THEN
    iTabSeq = iTabSeq + 1.
  ASSIGN ttFieldDef.cNewField = cFieldPrefix + ttFieldDef.cField
         ttFieldDef.iSeq      = ix
         ttFieldDef.iTableSeq = iTabSeq
         cCurrTable           = ttFieldDef.cTable
         .
                                                                                               
 IF iDuplCnt > 0 THEN                                                   
   ttFieldDef.cNewField = ttFieldDef.cNewField + "-" + STRING(iDuplCnt + 1). 
END.

/*  
FOR EACH ttFieldDef
    BY ttFieldDef.iTableSeq:
  cPrimaryTable = ttFieldDef.cTable.
  cPriIdxFlds = getPrimaryKeyFields(ttFieldDef.cTable).
  LEAVE.
END.
*/
FOR EACH ttFieldDef
    BREAK BY ttFieldDef.cDb
          BY ttFieldDef.iTableSeq
          BY ttFieldDef.iSeq:


  IF FIRST-OF(ttFieldDef.cDb) THEN DO:
    cCurrDb = ttFieldDef.cDb + (IF ttFieldDef.cDb NE "" THEN "." ELSE "").

/*     CREATE BUFFER h_fieldBuf FOR TABLE cCurrDb + "_field". */
/*     CREATE BUFFER h_fileBuf  FOR TABLE cCurrDb + "_file".  */
/*     CREATE QUERY hQuery.                                   */
/*     hQuery:SET-BUFFERS(h_fieldBuf,h_fileBuf).              */
  END.
/*  IF cClipBoardFormat = "jukebox" THEN DO:                                                                   */
/*    IF FIRST-OF(ttFieldDef.iTableSeq) THEN                                                                   */
/*      cClipList = cClipList + (IF cClipList NE "" THEN '  + ",' ELSE "") + ttFieldDef.cTable + '"' + CHR(10).*/
/*    cClipList = cClipList + '    + ";' + ttFieldDef.cField + '"' + CHR(10).                                  */
/*  END.                                                                                                       */

/*   hQuery:QUERY-PREPARE("FOR EACH _field WHERE _field-name = '"                                                                */
/*                      + (IF INDEX(ttFieldDef.cField,"[") > 0 THEN SUBSTR(ttFieldDef.cField,1,INDEX(ttFieldDef.cField,"[") - 1) */
/*                         ELSE ttFieldDef.cField) + "' NO-LOCK"                                                                 */
/*                      + ",FIRST _file OF _field WHERE _file-name = '" + ttFieldDef.cTable + "' NO-LOCK").                      */
/*   hQuery:QUERY-OPEN().                                                                                                        */
/*   hQuery:GET-FIRST().                                                                                                         */
/*                                                                                                                               */
/*   IF NOT h_fieldbuf:AVAILABLE THEN                                                                                            */
    RUN getBttField (cCurrDb,ttFieldDef.cTable,ttFieldDef.cField,OUTPUT h_fieldBuf).

  IF VALID-HANDLE(h_fieldBuf) AND h_fieldBuf:AVAIL THEN DO:

    IF h_fieldBuf:BUFFER-FIELD("_extent"):BUFFER-VALUE > 0 THEN 
      ttFieldDef.cNewField = REPLACE(REPLACE(ttFieldDef.cNewField,"[","_"),"]","").

    IF ttFieldDef.iTableSeq = 1 THEN DO:
      cUpdFlds = cUpdFlds + (IF cUpdFlds NE "" THEN "," ELSE "") +  ttFieldDef.cNewField.
      IF CAN-DO(cPriIdxFlds,ttFieldDef.cNewField) THEN
        cPriKeyFlds = cPriKeyFlds + (IF cPriKeyFlds NE "" THEN "," ELSE "") + ttFieldDef.cNewField.
    END.
    ELSE 
      cDispFlds = cDispFlds + (IF cDispFlds NE "" THEN "," ELSE "") + ttFieldDef.cNewField.

    ttFieldDef.cDefVar = 'DEFINE VARIABLE ' + ttFieldDef.cNewField 
                       + ' AS ' + h_fieldBuf:BUFFER-FIELD("_data-type"):BUFFER-VALUE + CHR(10)
                       + ' LABEL "' + (IF h_fieldBuf:BUFFER-FIELD("_label"):BUFFER-VALUE NE ? THEN h_fieldBuf:BUFFER-FIELD("_label"):BUFFER-VALUE ELSE "") + '"'
                       + ' FORMAT "' + fixFieldFormat(h_fieldBuf) + '"'
/*                        + ' FORMAT "' + h_fieldBuf:BUFFER-FIELD("_format"):BUFFER-VALUE + '"' */
                       + creViewASPhrase(h_fieldBuf:BUFFER-FIELD("_data-type"):BUFFER-VALUE)
                       + (IF h_fieldBuf:BUFFER-FIELD("_initial"):BUFFER-VALUE NE "" AND h_fieldBuf:BUFFER-FIELD("_initial"):BUFFER-VALUE NE ? THEN
                            (' INITIAL ' + (IF h_fieldBuf:BUFFER-FIELD("_data-type"):BUFFER-VALUE = "CHARACTER" THEN '"' ELSE "")
                            + (IF h_fieldBuf:BUFFER-FIELD("_data-type"):BUFFER-VALUE = "LOGICAL" THEN 
                                 creInitValueForLogical(h_fieldBuf::_format,h_fieldBuf::_initial) 
                               ELSE 
                                 h_fieldBuf:BUFFER-FIELD("_initial"):BUFFER-VALUE)
                            + (IF h_fieldBuf:BUFFER-FIELD("_data-type"):BUFFER-VALUE = "CHARACTER" THEN '"' ELSE ""))
                          ELSE "")
/*                          + ' LABEL "' + (IF h_fieldBuf:BUFFER-FIELD("_label"):BUFFER-VALUE NE ? THEN h_fieldBuf:BUFFER-FIELD("_label"):BUFFER-VALUE ELSE "") + '"' */
                       .
  
    ttFieldDef.cDefVar = ttFieldDef.cDefVar + ".".
  
    CASE cFieldHelp:
      WHEN "fh_t"      THEN ttFieldDef.cToolTip = h_fieldBuf:BUFFER-FIELD("_help"):BUFFER-VALUE.
      WHEN "fh_h"      THEN ttFieldDef.cHelp = h_fieldBuf:BUFFER-FIELD("_help"):BUFFER-VALUE.
      WHEN "fh_ht"     THEN ASSIGN ttFieldDef.cHelp = h_fieldBuf:BUFFER-FIELD("_help"):BUFFER-VALUE
                                   ttFieldDef.cTooltip = cHelp.
      WHEN "fh_h-de_t" THEN ASSIGN ttFieldDef.cHelp = h_fieldBuf:BUFFER-FIELD("_help"):BUFFER-VALUE
                                   ttFieldDef.cTooltip = h_fieldBuf:BUFFER-FIELD("_desc"):BUFFER-VALUE.
    END CASE.
  END.
  ELSE 
    cNoVarList = cNoVarList + (IF cNoVarList NE "" THEN "," ELSE "") + ttFieldDef.cTable + "." + ttFieldDef.cField.
/*
    MESSAGE PROGRAM-NAME(1) SKIP
            "Field " ttFieldDef.cField " was not found in data dictionary"
            VIEW-AS ALERT-BOX INFORMATION.
*/
/*   IF LAST-OF(ttFieldDef.cDb) THEN DO: */
/*     DELETE OBJECT hQuery NO-ERROR. */
/*     DELETE OBJECT h_fieldBuf. */
/*     DELETE OBJECT h_fileBuf.  */
/*   END. */
END.
/* RUN toexcelviafile.p (httFieldDef,0). */
         
/*
IF cClipBoardFormat = "JBoxFieldMap" THEN 
  cFieldMap = "/* Code for Definitions: */" + CHR(10) + CHR(10)
            + "DEF VAR " + cFieldMapName + " AS JBoxFieldMap NO-UNDO." + CHR(10) + CHR(10) 
            + "/* Code for InitializeObject (first update-field gets focus on new/edit): */" + CHR(10)
            + "  " + cFieldMapName + " = NEW JBoxFieldMap(FRAME FRAME-NAME:HANDLE). /* <- curly brackets and & missing */" + CHR(10)
            + (IF cUpdFlds NE "" THEN
                "  " + cFieldMapName + ":updateFields = '" + cUpdFlds + "'." + CHR(10)
               ELSE "")
            + (IF cDispFlds NE "" THEN
                "  " + cFieldMapName + ":displayFields = '" + cDispFlds + "'." + CHR(10)
               ELSE "")
            + (IF cPriKeyFlds NE "" THEN
                "  " + cFieldMapName + ":primaryKeyFields = '" + cPriKeyFlds + "'." + CHR(10)
               ELSE "")
            + CHR(10) + CHR(10)
            + "/* Assuming a corresponding query exists (could be a BROWSE-OBJECT): */" + CHR(10)
            + "  " + cFieldMapName + ":QUERY-OBJECT = oQry" + cPrimaryTable + "." + CHR(10) + CHR(10)
            + "  Assuming you have placed a rectangle placeholder called tb" + cPrimaryTable + " on the frame and" + CHR(10)
            + "  want to create a toolbar with corresponding window menu items ('File' f.ex) and associate it with your FieldMap and Query: " + CHR(10) + CHR(10)
            + "  /* Code for Definitions: */" + CHR(10)
            + "DEF VAR oTb" + cPrimaryTable + " AS JBoxToolbar NO-UNDO." + CHR(10) + CHR(10) 
            + "/* Code for InitializeObject: */" + CHR(10)
            + "  oTb" + cPrimaryTable + " = NEW JBoxToolbar(tb" + cPrimaryTable + ":HANDLE,'File')." + CHR(10)
            + "  oTb" + cPrimaryTable + ":AddTool('New')." + CHR(10)
            + "  oTb" + cPrimaryTable + ":AddToolGroup('Filter,Excel')." + CHR(10) + CHR(10)
            + "  oQry" + cPrimaryTable + ":TOOLBAR-OBJECT = oTb" + cPrimaryTable + "." + CHR(10)
            + "  " + cFieldMapName + ":TOOLBAR-OBJECT = oTb" + cPrimaryTable + "." + CHR(10)
            .
ASSIGN cFieldMapName = ""
       cQryForFieldMap = "".
*/

FOR EACH ttFieldDef 
    BY ttFieldDef.iSeq:
  ocFieldDef = ocFieldDef + ttFieldDef.cDefVar + CHR(10) + CHR(10).
/*  IF NOT CAN-DO("jukebox,JBoxFieldMap",cClipBoardFormat) AND cClipBoardFormat NE "" THEN    */
/*    cClipList = cClipList + (IF cClipList NE "" THEN cDelim ELSE "") + ttFieldDef.cNewField.*/
//  cVariablesFromDbList = cVariablesFromDbList + (IF cVariablesFromDbList NE "" THEN "," ELSE "") + ttFieldDef.cNewField.
END.
//IF cClipBoardFormat = "JBoxFieldMap" THEN cClipList = cFieldMap.

ocFieldDef = ocFieldDef + CHR(10).

IF cClipList NE "" THEN
  CLIPBOARD:VALUE = cClipList.

RETURN ocFieldDef.

END FUNCTION.


FUNCTION fixFieldFormat RETURNS CHARACTER
  ( INPUT ihFieldBuf AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cFormat   AS CHAR NO-UNDO.
DEF VAR iFormat   AS INT  NO-UNDO.
DEF VAR cDataType AS CHAR NO-UNDO.

cDataType = ihFieldBuf::_DATA-TYPE.

CASE cDataType:
  WHEN "CHARACTER" THEN DO:
    IF ihFieldBuf::_FORMAT BEGINS "x(" THEN DO:
      cFormat = SUBSTR(ihFieldBuf::_FORMAT,3,LENGTH(ihFieldBuf::_FORMAT) - 3).
      iFormat = INT(cFormat) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR AND iFormat > 256 THEN 
        cFormat = "x(256)".
      ELSE cFormat = ihFieldBuf::_FORMAT.
    END.
    ELSE cFormat = ihFieldBuf::_FORMAT.
  END.
  OTHERWISE cFormat = ihFieldBuf::_FORMAT.
END CASE.


RETURN cFormat. 

END FUNCTION.

FUNCTION creViewAsPhrase RETURNS CHARACTER
  ( INPUT icDataType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cViewAS AS CHAR NO-UNDO.

DEF VAR cType         AS CHAR   NO-UNDO.
DEF VAR cSubType      AS CHAR   NO-UNDO.
DEF VAR cCreFieldViewAS AS CHAR NO-UNDO.

IF cCreFieldViewAS NE "" THEN DO:
  cType           = ENTRY(1,cCreFieldViewAs," ").
  IF NUM-ENTRIES(cCreFieldViewAs," ") > 1 THEN
    cSubType        = ENTRY(2,cCreFieldViewAs," ").
  cCreFieldViewAS = "". 
END.
ELSE RETURN "".

CASE cType:
  WHEN "combo-box" THEN
    cViewAs = cViewAs + "    VIEW-AS COMBO-BOX INNER-LINES 25".
  WHEN "editor" THEN
    cViewAs = cViewAs + "     VIEW-AS EDITOR SCROLLBAR-VERTICAL SIZE 20 BY 3".
  WHEN "radio-set" THEN
    cViewAs = cViewAs + "     VIEW-AS RADIO-SET HORIZONTAL".
  WHEN "toggle-box" THEN
    cViewAs = cViewAs + "     VIEW-AS TOGGLE-BOX".
  WHEN "fill-in" THEN DO:
    IF cSubType = "TEXT" THEN
      cViewAs = cViewAs + "     VIEW-AS TEXT".          
    ELSE
      cViewAs = cViewAs + "     VIEW-AS FILL-IN".          
  END.
END CASE.

IF CAN-DO("combo-box,radio-set",cType) THEN DO:        
  CASE cSubType:
    WHEN "list-item-pairs" THEN
      cViewAs = cViewAs + '     LIST-ITEM-PAIRS "Item 1","1"'.
    WHEN "list-items" THEN
      cViewAs = cViewAs + '     LIST-ITEMS "Item 1"'.
    OTHERWISE  /* radio-set */
      cViewAs = cViewAs + '     RADIO-BUTTONS'.
  END CASE.

  CASE cSubType:
    WHEN "list-item-pairs" OR WHEN "LIST-ITEMS" THEN
      cViewAs = cViewAs + '     DROP-DOWN-LIST'.
    OTHERWISE DO: /* radio-set */
      CASE icDataType:
        WHEN "integer" OR WHEN "decimal" THEN
          cViewAs = cViewAs + '          "Item 1", 1,'.
        OTHERWISE
          cViewAs = cViewAs + '          "Item 1", "1",'.
      END CASE.
    END.
  END CASE.

  IF cType = "radio-set" THEN DO:
    CASE icDataType:
      WHEN "integer" OR WHEN "decimal" THEN
        cViewAs = cViewAs + '          "Item 1", 1,'.
      OTHERWISE
        cViewAs = cViewAs + '          "Item 2", "1"'.
    END CASE.
  END.

END.

cViewAS = cViewAS + " NO-UNDO".

RETURN cViewAS.

END FUNCTION.

FUNCTION creInitValueForLogical RETURNS CHARACTER
  (INPUT icFormat    AS CHAR,
   INPUT icInitValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cInit AS CHAR NO-UNDO.

IF NUM-ENTRIES(icFormat,"/") = 2 THEN
  cInit = IF icInitValue = ENTRY(1,icFormat,"/") THEN "yes"
          ELSE IF icInitValue = ENTRY(2,icFormat,"/") THEN "no"
          ELSE icInitValue.
ELSE
  cInit = icInitValue.

RETURN cInit.   /* Function return value. */

END FUNCTION.

PROCEDURE getBttField :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       called from adeuib\_fldinfo.p
------------------------------------------------------------------------------*/
DEF INPUT PARAM p_db_name   AS CHAR NO-UNDO.
DEF INPUT PARAM p_tbl_name  AS CHAR NO-UNDO.
DEF INPUT PARAM p_fld_name  AS CHAR NO-UNDO.
DEF OUTPUT PARAM ohtt_field AS HANDLE NO-UNDO.

DEFINE QUERY qDb FOR DICTDB._db   FIELDS(), 
                     DICTDB._file FIELDS(), 
                     DICTDB._field. 

p_fld_name = ENTRY(1,p_fld_name,"[").

IF p_db_name NE ? AND p_db_name NE "" THEN
  FIND FIRST tt_field 
       WHERE tt_field.cDbName = p_db_name
         AND tt_field.cTableName = p_tbl_name
         AND tt_field._field-name = p_fld_name
       NO-ERROR.
ELSE 
  FIND FIRST tt_field 
       WHERE tt_field.cTableName = p_tbl_name
         AND tt_field._field-name = p_fld_name
       NO-ERROR.

IF NOT AVAIL tt_field AND NUM-DBS > 1 THEN DO:    
  SESSION:SET-WAIT-STATE("general").
  RUN jukebox\fillTt_field.p("").
  SESSION:SET-WAIT-STATE("").

  IF p_db_name NE ? AND p_db_name NE "" THEN
    FIND FIRST tt_field 
         WHERE tt_field.cDbName = p_db_name
           AND tt_field.cTableName = p_tbl_name
           AND tt_field._field-name = p_fld_name
         NO-ERROR.
  ELSE 
    FIND FIRST tt_field 
         WHERE tt_field.cTableName = p_tbl_name
           AND tt_field._field-name = p_fld_name
         NO-ERROR.
END. /* Build cache */

IF NOT AVAILABLE tt_field THEN DO:

  OPEN QUERY qDB FOR 
      EACH DICTDB._db  
           WHERE DICTDB._db._db-name = (IF p_db_name = ldbname("DICTDB":U) OR p_db_name = "" THEN ?                                         
                                        ELSE p_db_name) 
           NO-LOCK,
      EACH DICTDB._file OF DICTDB._db 
           WHERE DICTDB._file._file-name = p_tbl_name 
           AND   LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 
           NO-LOCK,
      EACH DICTDB._field OF DICTDB._file 
           WHERE _field._field-name = p_fld_name          
           NO-LOCK.

  GET NEXT qDB.
  IF AVAIL DICTDB._field THEN DO:
    CREATE tt_field.
/*    BUFFER-COPY DICTDB._field TO tt_field. */
    ASSIGN tt_field._Data-type  = DICTDB._field._Data-Type
           tt_field._Field-Name = DICTDB._field._Field-Name
           tt_field._Initial    = DICTDB._field._Initial
           tt_field._Label      = DICTDB._field._Label
           tt_field._Help       = DICTDB._field._Help
           tt_field._Extent     = DICTDB._field._Extent
           tt_field._Desc       = DICTDB._Field._Desc
           tt_field._Format     = DICTDB._field._Format
           tt_field._Col-Label  = DICTDB._field._Col-label
           tt_field.cDbName     = p_db_name
           tt_field.cTableName  = p_tbl_name
           .
  END.    
END.
IF AVAIL tt_field THEN 
  ohtt_field = htt_field.
  /*
ELSE MESSAGE "Could not find field info for" SKIP
             "p_db_name" p_db_name SKIP
             "p_tbl_name" p_tbl_name SKIP
             "p_fld_name" p_fld_name SKIP(1)
             "Callstack: " SKIP 
             PROGRAM-NAME(2) SKIP
             PROGRAM-NAME(3)
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
*/
END PROCEDURE.
