/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ffqdlg.p

Description:
    Freeform Query dialog to set up freeform querys from the 
    query builder.  This "extra" call is necessary because the
    query builder doesn't have access to _query-u-rec (The
    recid of the current _U.

Input Parameters:
   <none>
   
Input-Output Parameters:
   ok-cancel - Character field that is either "Freeform" or "Cancel".

Output Parameters:
   oqcode     - Character field containing the open query statement

Author: D. Ross Hunter

Date Created: 1995

Modified for JukeBox 05.11.13 by brynjar@chemistry.no
Changes for JukeBox moved forward 10.sep.14 to ver 11.4 by Brynjar
08.nov.17 by brynjar for JukeBox
    capable to add query definition just to clipboard and return "exit" which i 
    captured by adeshar\qurytrig.i
apr 2020 by Brynjar
    - Only support for clipboard-copy of fields
    - Added option to position fields    
---------------------------------------------------------------------------- */

DEF INPUT        PARAMETER _4GLQury  AS CHARACTER                      NO-UNDO.
DEF INPUT        PARAMETER TblLIst   AS CHARACTER                      NO-UNDO.
DEF INPUT-OUTPUT PARAMETER ok-cancel AS CHARACTER                      NO-UNDO.

{adeuib/uniwidg.i}
{adeuib/brwscols.i}
{adeuib/triggers.i}
{adeuib/sharvars.i}
{adeuib/uibhlp.i}
{adecomm/oeideservice.i}

DEF VAR never-again          AS LOGICAL                                NO-UNDO.

/* Added definitions for JukeBox: */
DEF VAR ix                   AS INT  NO-UNDO.
DEF VAR cPrimaryTable        AS CHAR NO-UNDO.
DEF VAR cDisplayFieldDef     AS CHAR NO-UNDO.
DEF VAR cTableFieldDef       AS CHAR NO-UNDO.
DEF VAR cNewDisplayFields    AS CHAR NO-UNDO.
DEF VAR p_fld_label          AS CHAR 		NO-UNDO.
DEF VAR p_fld_label_sa       AS CHAR 		NO-UNDO.
DEF VAR p_fld_format         AS CHAR 		NO-UNDO.
DEF VAR p_fld_format_sa      AS CHAR 		NO-UNDO.
DEF VAR p_fld_type           AS CHAR 		NO-UNDO.
DEF VAR p_fld_help           AS CHAR 		NO-UNDO.
DEF VAR p_fld_help_sa        AS CHAR 		NO-UNDO.
DEF VAR p_fld_extent         AS INTEGER     NO-UNDO.
DEF VAR p_fld_initial        AS CHAR        NO-UNDO.
DEF VAR p_fld_description    AS CHAR        NO-UNDO.
DEF VAR p_fld_valexp         AS CHAR        NO-UNDO.
DEF VAR p_fld_valmsg         AS CHAR        NO-UNDO.
DEF VAR p_fld_valmsg_sa      AS CHAR        NO-UNDO.
DEF VAR p_fld_mandatory      AS LOGICAL     NO-UNDO.
DEF VAR cTtFieldDef          AS CHAR        NO-UNDO.
DEF VAR cField               AS CHAR        NO-UNDO.
DEF VAR cTable               AS CHAR        NO-UNDO.
DEF VAR cFieldList           AS CHAR        NO-UNDO.
DEF VAR cTableList           AS CHAR        NO-UNDO.
DEF VAR cQueryJoin           AS CHAR        NO-UNDO.
DEF VAR cEnableFld           AS CHAR        NO-UNDO.
DEF VAR cTtExt               AS CHAR        NO-UNDO.
DEF VAR cDbExt               AS CHAR        NO-UNDO.
DEF VAR cRowIdentIndex       AS CHAR        NO-UNDO.
DEF VAR cTips                AS CHAR        NO-UNDO.
DEF VAR cFileName            AS CHAR        NO-UNDO.
DEF VAR bOutputToFile        AS LOG         NO-UNDO INIT YES.
DEF VAR iExt                 AS INT         NO-UNDO.
DEF VAR iy                   AS INT         NO-UNDO.
DEF VAR cInitObjCode         AS CHAR        NO-UNDO.
DEF VAR cCode1               AS CHAR NO-UNDO.
DEF VAR cCode2               AS CHAR NO-UNDO.
DEF VAR cProcList            AS CHAR NO-UNDO.
DEF VAR rOpenQuery           AS ROWID NO-UNDO.
DEF VAR rDisplay             AS ROWID NO-UNDO.

DEF STREAM JBoxStream.

DEF TEMP-TABLE ttTableFlds
    FIELD cTable        AS CHAR
    FIELD cTtFld        AS CHAR
    FIELD cDbFld        AS CHAR
    FIELD cTtExtent     AS CHAR
    FIELD cDbExtent     AS CHAR
    FIELD cLabel        AS CHAR
    FIELD cFormat       AS CHAR
    FIELD fWidthChars   AS DECIMAL
    FIELD cDataType     AS CHAR
    FIELD cDisplayDef   AS CHAR
    FIELD iSeq          AS INT
    FIELD iDesignSeq    AS INT
    FIELD bAccum        AS LOG
    FIELD bDistinct     AS LOG
    FIELD bCalc         AS LOG
    FIELD bMandatory    AS LOG
    FIELD cCalcIPcall   AS CHAR
    FIELD cCalcProcCont AS CHAR
    .

DEF VAR hbttTableFlds AS HANDLE NO-UNDO.
hbttTableFlds = BUFFER ttTableFlds:HANDLE.

DEFINE QUERY qDb FOR DICTDB._db   FIELDS(), 
                     DICTDB._file FIELDS(_file-name), 
                     DICTDB._field. 

/* End JukeBox definitions */

if OEIDE_CanLaunchDialog() THEN DO:
  IF NOT DYNAMIC-FUNCTION("getNewJukeBoxObject") THEN    
   RUN adeuib/ide/_dialog_advisor.p (
  /* TEXT */    INPUT "Freeform queries are edited using the Section Editor." +
                      "  This is an advanced feature, press 'Help' for details.",
  /* OPTIONS */ INPUT "Freeform.  Allow freeform editing of query.,Freeform," +
/*                       "JukeBox freeform query definition (temp-table definition added to clipboard),JukeBox," + /* Added JukeBox option */ */
                      "Cancel.  Use Query Builder.,Cancel",
                INPUT FALSE,
                INPUT "AB",
                INPUT {&Free_Form_Query_Dlg_Box},
                INPUT-OUTPUT ok-cancel,
                OUTPUT never-again).
  ELSE OK-CANCEL = "JukeBox".
END.
else
     RUN adeuib/_advisor.w (
     /* TEXT */    INPUT "Freeform queries are edited using the Section Editor." +
                      "  This is an advanced feature, press 'Help' for details.",
    /* OPTIONS */ INPUT "Freeform.  Allow freeform editing of query.,Freeform," +
                        "JukeBox freeform query definition (temp-table definition added to clipboard),JukeBox," + /* Added JukeBox option */
                        "Cancel.  Use Query Builder.,Cancel",
                   INPUT FALSE,
                   INPUT "AB",
                   INPUT {&Free_Form_Query_Dlg_Box},
                   INPUT-OUTPUT ok-cancel,
                   OUTPUT never-again).

/* Brynjar: Since this procedure is executed multiple times an exit-strategy is needed.. */
IF DYNAMIC-FUNCTION("doubleAction") THEN OK-CANCEL = "freeform". // "exit".

IF CAN-DO("JukeBox",ok-cancel) THEN DO:

  FIND _U WHERE RECID(_U) = _query-u-rec.
  FIND _C WHERE RECID(_C) = _U._x-recid.
  FIND _Q WHERE RECID(_Q) = _C._q-recid. 
  
  FIND _P WHERE _P._window-handle = _U._window-handle.

  ASSIGN _Q._4GLQury = _4GLQury
         _Q._TblList = TblList.

  /* Get the OPEN-QUERY statement that is going to be output into the preprocessor
     section. Note that this will have lines that end with tilde. Remove these
     tilde's. */
     
  RUN adeshar/_coddflt.p (INPUT "_OPEN-QUERY", INPUT _query-u-rec, OUTPUT _4GLQury).
  /* the previous code replaced all ":" with ".* messing with query values  (datetime-tz)
     this assumption is that this is to replace the colon at end as this will not compile (11.4).
     not sure if it is always there so also remove period to avoid double period   
  */
   
  ASSIGN  _4GLQury = RIGHT-TRIM(_4GLQury,":.":U) + ".":U  
          _4GLQury = REPLACE(_4GLQury," ~~":U + CHR(10) , CHR(10)).

  IF _4GLQury NE "." THEN DO:
    ASSIGN cPrimaryTable    = (IF _4GLQury BEGINS "FOR " THEN ENTRY(3,_4GLQury," ") ELSE ENTRY(NUM-ENTRIES(ENTRY(2,_4GLQury," "),"."),"."))
           cQueryJoin       = (IF NUM-ENTRIES(_4GLQury,CHR(10)) > 1 THEN SUBSTR(_4GLQury,INDEX(_4GLQury,CHR(10))) ELSE "")
           .
    REPEAT WHILE INDEX(cQueryJoin,"  ") > 0:
      cQueryJoin = REPLACE(cQueryJoin,"  "," ").
    END.
    ASSIGN
           cQueryJoin       = REPLACE(cQueryJoin,CHR(10),"")
           cQueryJoin       = REPLACE(cQueryJoin,",      EACH",",EACH")
           cQueryJoin       = REPLACE(cQueryJoin,",      FIRST",",FIRST")
           cQueryJoin       = REPLACE(cQueryJoin,",      LAST",",LAST")
           cQueryJoin       = REPLACE(cQueryJoin,"INDEXED-REPOSITION.","")
           cQueryJoin       = TRIM(cQueryJoin)
           cQueryJoin       = DYNAMIC-FUNCTION("FixQueryOperators",cQueryJoin)
           cQueryJoin       = DYNAMIC-FUNCTION("FixQueryJoin",cQueryJoin)
           _4GLQury         = ENTRY(1,_4GLQury)
           .

    cTableList = cPrimaryTable.
    DO ix = 1 TO NUM-ENTRIES(cQueryJoin):
      IF CAN-DO("EACH,FIRST,LAST",ENTRY(1,ENTRY(ix,cQueryJoin)," ")) THEN
        cTableList = cTableList + "," + ENTRY(2,ENTRY(ix,cQueryJoin)," ").
    END.
  END.
  ELSE DO:
    MESSAGE "No tables are selected" VIEW-AS ALERT-BOX WARNING.
    ok-cancel = "cancel". // "freeform".
    DYNAMIC-FUNCTION("doubleAction").
    RETURN.
  END.

  IF _U._TYPE = "BROWSE":U THEN DO:
    DEF VAR bOk           AS LOG NO-UNDO.
    DEF VAR cCalcProcs    AS CHAR NO-UNDO.
    DEF VAR cTbl          AS CHAR NO-UNDO.
    DEF VAR cCalcFld      AS CHAR NO-UNDO.
    DEF VAR cCalcProcFlds AS CHAR NO-UNDO.
    DEF VAR cExtCalcProc  AS CHAR NO-UNDO.
    DEF VAR cMandatory    AS CHAR NO-UNDO.

    DO ix = 1 TO NUM-ENTRIES(cTableList):
      cTbl = ENTRY(NUM-ENTRIES(ENTRY(1,ENTRY(ix,cTableList)," "),"."),ENTRY(1,ENTRY(ix,cTableList)," "),".").
      FOR EACH _BC 
          WHERE _BC._x-recid = RECID(_U)
            AND _BC._TABLE   = cTbl
          BY _BC._SEQUENCE:
    
        CREATE ttTableFlds.
        ASSIGN iy = iy + 1
               ttTableFlds.cTable      = cTbl
               ttTableFlds.cTtFld      = _BC._NAME
               ttTableFlds.cDbFld      = _BC._NAME
               ttTableFlds.cLabel      = (IF _BC._LABEL NE ? THEN REPLACE(_BC._LABEL,"!"," ") ELSE "")
               ttTableFlds.cFormat     = (IF _BC._FORMAT NE ? THEN REPLACE(_BC._FORMAT,",","<") ELSE "")
               ttTableFlds.cDataType   = _BC._DATA-TYPE
               ttTableFlds.iDesignSeq  = _BC._SEQUENCE
               ttTableFlds.ISeq        = iy
               ttTableFlds.bDistinct   = _BC._DISABLE-AUTO-ZAP
               ttTableFlds.bAccum      = _BC._COLUMN-READ-ONLY
               ttTableFlds.fWidthChars = (IF _BC._WIDTH NE ? AND _BC._WIDTH NE 0 THEN _BC._WIDTH ELSE _BC._DEF-WIDTH)
               ttTableFlds.cDisplayDef = "     + ';+" 
                                       + (IF _BC._DISABLE-AUTO-ZAP THEN "distinct " 
                                          ELSE IF _BC._COLUMN-READ-ONLY THEN "accum " 
                                          ELSE "") 
                                       + _BC._NAME 
                                       + "|" + (IF _BC._LABEL NE ? THEN REPLACE(_BC._LABEL,"!"," ") ELSE "")
                                       + "|" + (IF _BC._FORMAT NE ? THEN REPLACE(_BC._FORMAT,",","<") ELSE "") 
                                    /* + (IF iy NE _BC._SEQUENCE THEN "@" + STRING(_BC._SEQUENCE) ELSE "") */
                                    /* + "'" */
               .        
    
      END.
      FOR EACH _BC 
          WHERE _BC._x-recid = RECID(_U)
            AND _BC._TABLE   = ?
            AND _BC._DBNAME  = "_<CALC>" 
            AND ENTRY(1,_BC._DISP-NAME,".") = cTbl
            AND _BC._DEF-VALEXP NE ""
          BY _BC._SEQUENCE:
        cCalcFld = _BC._DEF-VALEXP.
        cMandatory = "".
        cExtCalcProc = "".
    
        IF ENTRY(NUM-ENTRIES(cCalcFld,"|"),cCalcFld,"|") = "mandatory" THEN
          ASSIGN cMandatory = "|" + ENTRY(NUM-ENTRIES(cCalcFld,"|"),cCalcFld,"|")
                 cCalcFld = SUBSTR(cCalcFld,1,R-INDEX(cCalcFld,"|") - 1)
                 .
    
        IF NUM-ENTRIES(cCalcFld,"|") > 1 AND ENTRY(1,cCalcFld,"|") NE "" THEN DO:
          IF NOT CAN-DO(cCalcProcs,ENTRY(1,cCalcFld,"|")) THEN
            ASSIGN cCalcProcs    = cCalcProcs + (IF cCalcProcs NE "" THEN "," ELSE "") + ENTRY(1,cCalcFld,"|")
                   cExtCalcProc  = ENTRY(1,cCalcFld,"|")
                   cCalcProcFlds = cCalcProcFlds + (IF cCalcProcFlds NE "" THEN ";" ELSE "") + cCalcFld
                   .
          ELSE cCalcProcFlds = cCalcProcFlds + (IF cCalcProcFlds NE "" THEN "," ELSE "") + ENTRY(2,cCalcFld,"|").
        END.
        cCalcFld = ENTRY(NUM-ENTRIES(cCalcFld,"|"),cCalcFld,"|").
    
        CREATE ttTableFlds.
        ASSIGN iy = iy + 1
               ttTableFlds.cTable       = cTbl
               ttTableFlds.cTtFld       = ENTRY(NUM-ENTRIES(ENTRY(1,_BC._DISP-NAME),"."),ENTRY(1,_BC._DISP-NAME," "),".")
               ttTableFlds.cDbFld       = _BC._NAME
               ttTableFlds.cLabel       = (IF _BC._LABEL NE ? THEN REPLACE(_BC._LABEL,"!"," ") ELSE "")
               ttTableFlds.cFormat      = (IF _BC._FORMAT NE ? THEN REPLACE(_BC._FORMAT,",","<") ELSE "")
               ttTableFlds.cDataType    = _BC._DATA-TYPE
               ttTableFlds.iDesignSeq   = _BC._SEQUENCE
               ttTableFlds.ISeq         = iy
               ttTableFlds.bDistinct    = _BC._DISABLE-AUTO-ZAP
               ttTableFlds.bAccum       = _BC._COLUMN-READ-ONLY
               ttTableFlds.bCalc        = YES
               ttTableFlds.bMandatory   = cMandatory NE ""
               ttTableFlds.cCalcIPcall  = cCalcFld
               ttTableFlds.cCalcProcCont = cExtCalcProc
               ttTableFlds.cDisplayDef = "     + ';+" 
                 + (IF _BC._DISABLE-AUTO-ZAP THEN "distinct " 
                    ELSE IF _BC._COLUMN-READ-ONLY THEN "accum "
                    ELSE "")
                 + ENTRY(NUM-ENTRIES(ENTRY(1,_BC._DISP-NAME),"."),ENTRY(1,_BC._DISP-NAME," "),".")
                 + "|" + (IF _BC._DATA-TYPE NE ? THEN _BC._DATA-TYPE ELSE "CHARACTER")
                 + "|" + (IF _BC._FORMAT NE ? THEN REPLACE(_BC._FORMAT,",","<") ELSE "") 
                 + "|" + cCalcFld + "|" + _BC._LABEL + cMandatory 
                 /* + (IF iy NE _BC._SEQUENCE THEN "@" + STRING(_BC._SEQUENCE) ELSE "") */
                 /* + "'" */
               .        
      END.
    END.
    
    RUN ffDlgOptions.w (hbttTableFlds,cQueryJoin + CHR(1) + cCalcProcFlds,OUTPUT bOk).
    IF bOK THEN DO:
      FOR EACH _BC 
          WHERE _BC._x-recid   = RECID(_U)
          :         
        DELETE _BC.
      END.
      DELETE _U.
      DELETE _Q.
      OK-CANCEL = "exit".
    END.
    ELSE 
      OK-CANCEL = "cancel". // "cancel".
      
    DYNAMIC-FUNCTION("doubleAction").
    RETURN.
  END.
  ELSE DO:

    DO ix = 1 TO NUM-ENTRIES(cTableList):

      OPEN QUERY qDB FOR 
           EACH DICTDB._db  
           WHERE DICTDB._db._db-name = ? 
           NO-LOCK,
           EACH DICTDB._file OF DICTDB._db 
                WHERE DICTDB._file._file-name = ENTRY(ix,cTableList)
                AND   LOOKUP(DICTDB._FILE._OWNER,"PUB,_FOREIGN":U) > 0 
                NO-LOCK,
           EACH DICTDB._field OF DICTDB._file 
                NO-LOCK.

      GET FIRST qDB.

      REPEAT WHILE NOT QUERY qDB:QUERY-OFF-END:

        ASSIGN cTable = DICTDB._file._file-name
               cField = DICTDB._field._field-name
               iy     = iy + 1
               .

        IF DICTDB._field._Extent > 0 THEN
          DO iExt = 1 TO DICTDB._field._Extent:
            CREATE ttTableFlds.
            ASSIGN ttTableFlds.cTable     = cTable
                   ttTableFlds.cTtFld     = cField
                   ttTableFlds.cDbFld     = cField
                   ttTableFlds.cDbExtent  = "[" + STRING(iExt) + "]"
                   ttTableFlds.cTtExtent  = "_" + STRING(iExt)
                   ttTableFlds.cDataType  = DICTDB._field._data-type
                   ttTableFlds.iSeq       = iy
                   iy = iy + 1
                   .
          END.
        ELSE DO:
          CREATE ttTableFlds.
          ASSIGN ttTableFlds.cTable     = cTable
                 ttTableFlds.cTtFld     = cField
                 ttTableFlds.cDbFld     = cField
                 ttTableFlds.cDataType  = DICTDB._field._data-type
                 ttTableFlds.iSeq       = iy
                 .
        END.

        IF CAN-DO(cFieldList,cField) AND LOOKUP(cTable,cTableList) > 1 AND DICTDB._field._Extent = 0 THEN
          ttTableFlds.cTtFld = ttTableFlds.cTtFld + STRING(LOOKUP(cTable,cTableList)).

        cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + cField.
        GET NEXT qDB.
      END.
    END.
    
    cTtFieldDef  = "/* Code for Definitions: */" + CHR(10) + CHR(10)
                 + "/*** Start instance property definitions for JBoxQuery object oQry" + cPrimaryTable + " ***/" + CHR(10)
                 + "DEF VAR oQry" + cPrimaryTable + " AS JBoxQuery NO-UNDO." + CHR(10) + CHR(10) 
                 + "DEF TEMP-TABLE " + cPrimaryTable + CHR(10)
                 .
    
    RUN BuildTtAndQueryDefintion("Query").

    IF cFileName = "" OR cFileName = ? THEN
      cFileName = SESSION:TEMP-DIR + cPrimaryTable + "_JukeBox_QueryDef.txt".

    IF SEARCH(cFileName) NE ? THEN
      cFileName = REPLACE(cFileName,"_JukeBox_QueryDef.txt","_JukeBox_QueryDef" + STRING(TIME) + ".txt").

      /*
    MESSAGE "Code for additional definitions for JukeBox static query was created successfully" SKIP(1)
            "Open textfile containing the code and tips for extensions?" SKIP(1)
            "(No: Add code to Definitions/InitializeObject)" SKIP(1)
            "Note: A JukeBox query is always freeform and must be maintained by editing the source code"
            VIEW-AS ALERT-BOX INFO BUTTONS YES-NO UPDATE bOutputToFile.
            */
    bOutputToFile = NO.
            
    DYNAMIC-FUNCTION("doubleAction").

    IF bOutputToFile THEN DO:
      OUTPUT STREAM JBoxStream TO VALUE(cFileName).
      PUT STREAM JBoxStream UNFORMATTED 
                 cTips + CHR(10) cTtFieldDef + CHR(10)
               + "/* End Definitions */" + CHR(10) + CHR(10)
               + "/* Code for InitializeObject (in DO WITH FRAME.. block): */" + CHR(10)
  	     + cInitObjCode
  	     .
      OUTPUT STREAM JBoxStream CLOSE.
      OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
      DELETE _Q.
    END.

    ELSE DO:
      /* Insert the code for Definitions */
      FIND FIRST _TRG
           WHERE _TRG._tSECTION = "_CUSTOM":U
             AND _TRG._pRECID   = RECID(_P)
             AND _TRG._tEVENT   = "_DEFINITIONS":U
           NO-ERROR.
      IF AVAIL _TRG THEN 
        _TRG._tCODE = _TRG._tCODE + CHR(10) + cTtFieldDef.        	
    
      /* Insert the code for InitializeObject */
      FIND FIRST _TRG
           WHERE _TRG._tSECTION = "_PROCEDURE":U
             AND _TRG._pRECID   = RECID(_P)
             AND _TRG._tEVENT   = "InitializeObject":U
           NO-ERROR.
    
      IF NOT AVAIL _TRG THEN DO:
        FOR EACH _TRG 
            WHERE _TRG._tSECTION = "_PROCEDURE":U
              AND _TRG._pRECID   = RECID(_P):
          cProcList = cProcList + (IF cProcList NE "" THEN "|" ELSE "") + _TRG._tEvent.
        END.
        IF cProcList NE "" THEN DO:
          MESSAGE "Procedure InitializeObject is missing from the container" SKIP 
                  "Select procedure to insert code for initialization of object"
                  VIEW-AS ALERT-BOX INFO BUTTONS OK.
          JBoxSession:Instance:SimpleSelectList(cProcList).
          IF JBoxSession:Instance:SelectListOk THEN
            FIND FIRST _TRG
                 WHERE _TRG._tSECTION = "_PROCEDURE":U
                   AND _TRG._pRECID   = RECID(_P)
                   AND _TRG._tEVENT   = JBoxSession:Instance:SelectListValue
                 NO-ERROR.
        END.
      END.
      IF AVAIL _TRG THEN DO:
        IF _TRG._tCODE MATCHES "*END.*" AND INDEX(_TRG._tCODE,"END.") = R-INDEX(_TRG._tCODE,"END.") THEN 
          _TRG._tCODE = REPLACE(_TRG._tCODE,"END.",cInitObjCode + CHR(10) + "END.").              
        ELSE IF _TRG._tCODE MATCHES "*END.*" THEN 
          ASSIGN cCode1 = SUBSTR(_TRG._tCODE,1,R-INDEX(_TRG._tCODE,"END.") - 1)  
                 cCode2 = SUBSTR(_TRG._tCODE,R-INDEX(_TRG._tCODE,"END."))
                 cCode2 = REPLACE(cCode2,"END.",cInitObjCode + CHR(10) + "END." + CHR(10))
                 _TRG._tCODE = cCode1 + cCode2
                 .
        ELSE 
          _TRG._tCODE = _TRG._tCODE + CHR(10) + cInitObjCode.         
      END.
    END.
  END.
  ok-cancel = "Freeform". /* Set back to "Freeform" for AppBuilder compliance */
END.

PROCEDURE genViewDef:
  DEF INPUT PARAM ibReposFlds  AS LOG NO-UNDO.
  DEF INPUT PARAM ibPreview    AS LOG NO-UNDO.
  DEF OUTPUT PARAM ocDynQuery  AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ohJboxSuper AS HANDLE NO-UNDO.
  
  DEF VAR cDisplTrg         AS CHAR NO-UNDO.
  DEF VAR cTtFieldDef       AS CHAR NO-UNDO.
  DEF VAR cViewDef          AS CHAR NO-UNDO.
  DEF VAR cTblList          AS CHAR NO-UNDO.
  DEF VAR ix                AS INT  NO-UNDO.
  DEF VAR iy                AS INT  NO-UNDO.
  DEF VAR cRowIdentIdx      AS CHAR NO-UNDO.
  DEF VAR cCurrDb           AS CHAR NO-UNDO.
  DEF VAR cSortFld          AS CHAR NO-UNDO. 
  DEF VAR cTbl              AS CHAR NO-UNDO.
  DEF VAR cCalcProcs        AS CHAR NO-UNDO.
  DEF VAR cCalcFld          AS CHAR NO-UNDO.
  DEF VAR cCalcProcFlds     AS CHAR NO-UNDO.
  DEF VAR cCalcProcFunc     AS CHAR NO-UNDO.
  DEF VAR hJboxSuper        AS HANDLE NO-UNDO.
  
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.
  FIND _U WHERE RECID(_U) = _query-u-rec NO-ERROR.
  FIND _C WHERE RECID(_C) = _U._x-recid NO-ERROR.
  FIND _Q WHERE RECID(_Q) = _C._q-recid NO-ERROR.
  
  IF NOT AVAIL _P OR NOT AVAIL _U OR NOT AVAIL _C OR NOT AVAIL _Q THEN RETURN.
  
  cCurrDb = IF _db_name NE "" THEN _db_name ELSE LDBNAME("DICTDB").
    
  RUN adeshar/_coddflt.p (INPUT "_DISPLAY-FIELDS", INPUT _query-u-rec, OUTPUT cDisplTrg).

  cTblList = cTableList.
  DO ix = 1 TO NUM-ENTRIES(cTblList):
    cTbl = ENTRY(NUM-ENTRIES(ENTRY(1,ENTRY(ix,cTblList)," "),"."),ENTRY(1,ENTRY(ix,cTblList)," "),".").
    cViewDef = cViewDef + CHR(10) + "  " + (IF ix = 1 THEN "  '" ELSE "+ ',") + cTbl + "'".
    FOR EACH _BC 
        WHERE _BC._x-recid = RECID(_U)
          AND _BC._TABLE   = cTbl
        BY _BC._SEQUENCE:
  
      iy = iy + 1.
      IF cSortFld = "" THEN cSortFld = _BC._NAME.
  
      cViewDef = cViewDef + CHR(10) + "     + ';" 
               + (IF _BC._DISABLE-AUTO-ZAP THEN "distinct " 
                  ELSE IF _BC._COLUMN-READ-ONLY THEN "accum " 
                  ELSE "") 
               + _BC._NAME 
               + "|" + (IF _BC._LABEL NE ? THEN REPLACE(_BC._LABEL,"!"," ") ELSE "")
               + "|" + (IF _BC._FORMAT NE ? THEN REPLACE(_BC._FORMAT,",","<") ELSE "") 
               + (IF cDisplTrg NE "" AND iy NE _BC._SEQUENCE AND ibReposFlds THEN "@" + STRING(_BC._SEQUENCE) ELSE "")
               + "'". 
    END.
    FOR EACH _BC 
        WHERE _BC._x-recid = RECID(_U)
          AND _BC._TABLE   = ?
          AND _BC._DBNAME  = "_<CALC>" 
          AND ENTRY(1,_BC._DISP-NAME,".") = cTbl
          AND _BC._DEF-VALEXP NE ""
        BY _BC._SEQUENCE:
      cCalcFld = _BC._DEF-VALEXP.
      cMandatory = "".
      IF cSortFld = "" THEN cSortFld = _BC._NAME.

      IF ENTRY(NUM-ENTRIES(cCalcFld,"|"),cCalcFld,"|") = "mandatory" THEN
        ASSIGN cMandatory = "|" + ENTRY(NUM-ENTRIES(cCalcFld,"|"),cCalcFld,"|")
               cCalcFld = SUBSTR(cCalcFld,1,R-INDEX(cCalcFld,"|") - 1)
               .
  
      IF NUM-ENTRIES(cCalcFld,"|") > 1 AND ENTRY(1,cCalcFld,"|") NE "" THEN DO:
        IF NOT CAN-DO(cCalcProcs,ENTRY(1,cCalcFld,"|")) THEN
          ASSIGN cCalcProcs    = cCalcProcs + (IF cCalcProcs NE "" THEN "," ELSE "") + ENTRY(1,cCalcFld,"|")
                 cCalcProcFlds = cCalcProcFlds + (IF cCalcProcFlds NE "" THEN ";" ELSE "") + cCalcFld
                 .
        ELSE cCalcProcFlds = cCalcProcFlds + (IF cCalcProcFlds NE "" THEN "," ELSE "") + ENTRY(2,cCalcFld,"|").
      END.
      cCalcFld = ENTRY(NUM-ENTRIES(cCalcFld,"|"),cCalcFld,"|").
  
      iy = iy + 1.
  
      cViewDef = cViewDef + CHR(10) + "     + ';+" 
               + (IF _BC._DISABLE-AUTO-ZAP THEN "distinct " 
                  ELSE IF _BC._COLUMN-READ-ONLY THEN "accum "
                  ELSE "")
               + ENTRY(NUM-ENTRIES(ENTRY(1,_BC._DISP-NAME),"."),ENTRY(1,_BC._DISP-NAME," "),".")
               + "|" + (IF _BC._DATA-TYPE NE ? THEN _BC._DATA-TYPE ELSE "CHARACTER")
               + "|" + (IF _BC._FORMAT NE ? THEN REPLACE(_BC._FORMAT,",","<") ELSE "") 
               + "|" + cCalcFld + "|" + _BC._LABEL + cMandatory 
               + (IF cDisplTrg NE "" AND iy NE _BC._SEQUENCE THEN "@" + STRING(_BC._SEQUENCE) ELSE "")
               + "'"
               . 
  
    END.
  END.
  
/*   FOR EACH _BC                                                                                              */
/*       WHERE _BC._x-recid   = RECID(_U)                                                                      */
/*          BY _BC._SEQUENCE:                                                                                  */
/*                                                                                                             */
/*     IF _BC._DEF-VALEXP NE "" AND SUBSTR(_BC._DEF-VALEXP,LENGTH(_BC._DEF-VALEXP)) = "]" THEN                 */
/*       ASSIGN cDbExt    = SUBSTR(_BC._DEF-VALEXP,INDEX(_BC._DEF-VALEXP,"["))                                 */
/*              cTtExt    = "_" + REPLACE(SUBSTR(cDbExt,2),"]","")                                             */
/*              cFldName  = SUBSTR(_BC._DEF-VALEXP,1,INDEX(_BC._DEF-VALEXP,"[") - 1)                           */
/*             .                                                                                               */
/*     ELSE IF _BC._DEF-VALEXP = "" OR (_BC._TABLE = ? AND _BC._DBNAME = "_<CALC>") THEN DO:                   */
/*       ASSIGN cFldName = ENTRY(NUM-ENTRIES(ENTRY(1,_BC._DISP-NAME," "),"."),ENTRY(1,_BC._DISP-NAME," "),".") */
/*              cDbExt   = ""                                                                                  */
/*              cTtExt   = ""                                                                                  */
/*              .                                                                                              */
/*     END.                                                                                                    */
/*     ELSE                                                                                                    */
/*       ASSIGN cFldName = _BC._DEF-VALEXP                                                                     */
/*              cDbExt   = ""                                                                                  */
/*              cTtExt   = ""                                                                                  */
/*              .                                                                                              */
/*     DELETE _BC. */
/*   END.          */
  
  cQueryJoin  = REPLACE(cQueryJoin,cCurrDb + ".","").
  IF TRIM(cQueryJoin) NE "" THEN cQueryJoin = "," + cQueryJoin.
  
  ocDynQuery = cViewDef + CHR(10) + "     ,'" + cQueryJoin + "'".

  IF NOT ibPreview THEN DO:
    FIND FIRST _TRG
         WHERE _TRG._tSECTION = "_PROCEDURE":U
           AND _TRG._pRECID   = RECID(_P)
           AND _TRG._tEVENT   = "InitializeObject":U
         NO-ERROR.
    IF AVAIL _TRG AND _TRG._tCode MATCHES "*InitializeQuery*<buffersAndFields>*" THEN 
      ohJboxSuper = DYNAMIC-FUNCTION('setQueryWrapperInitValues',cViewDef,cQueryJoin,cSortFld,cCalcProcs,RECID(_P)).
  END.

END PROCEDURE.

PROCEDURE BuildTtAndQueryDefintion:
    DEF INPUT PARAM icType AS CHAR NO-UNDO.

    FOR EACH ttTableFlds BY ttTableFlds.iSeq:
      ASSIGN cDisplayFieldDef  = cPrimaryTable + "." + ttTableFlds.cTtFld + ttTableFlds.cTtExtent + ttTableFlds.cDisplayDef
             cTtFieldDef       = cTtFieldDef + "    FIELD " + ttTableFlds.cTtFld + ttTableFlds.cTtExtent + " AS " + ttTableFlds.cDataType + CHR(10)
             cNewDisplayFields = cNewDisplayFields + (IF cNewDisplayFields NE "" THEN CHR(10) ELSE "") + cDisplayFieldDef
             .
      IF ttTableFlds.cTtExtent NE "" THEN
        cTtFieldDef  = cTtFieldDef + "    FIELD jbextent" + ttTableFlds.cTtExtent + "_" + ttTableFlds.cTtFld + " AS " + ttTableFlds.cDataType + " /* placeholder for calculation */" + CHR(10).
    
      IF cEnableFld = "" THEN cEnableFld = "ENABLE " + cPrimaryTable + "." + ttTableFlds.cTtFld + ttTableFlds.cTtExtent. 
    END.
    DO ix = 1 TO NUM-ENTRIES(cTableList):
      cTableFieldDef = cTableFieldDef + (IF cTableFieldDef NE "" THEN CHR(10) + "    + '," ELSE CHR(10) + "      '") + ENTRY(ix,cTableList) + "'".
      IF icType = "browse" THEN
        FOR EACH ttTableFlds
            WHERE ttTableFlds.cTable = ENTRY(ix,cTableList)
            BY iSeq:
          cTableFieldDef = cTableFieldDef + CHR(10) + "      + ';" + ttTableFlds.cDbFld + ttTableFlds.cDbExtent + "'".
        END.
      cTtFieldDef  = cTtFieldDef + "    FIELD RowIdent" + STRING(ix) + " AS CHARACTER " + CHR(10).
      cRowIdentIndex = cRowIdentIndex + " RowIdent" + STRING(ix).  
    END.

//    CLIPBOARD:VALUE = cTableFieldDef.

    cTtFieldDef = cTtFieldDef 
                + "    FIELD RowCount AS INTEGER" + CHR(10)
                + (IF icType = "browse" THEN
                    "    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1" + CHR(10)
                  + "    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'" + CHR(10)
                   ELSE "")
                + "    INDEX idxRowids " + cRowIdentIndex + CHR(10)
                + "    ." + CHR(10) 
		+ "DEFINE BUFFER v_" + cPrimaryTable + " FOR TEMP-TABLE " + cPrimaryTable + "." + CHR(10) + CHR(10)
                + (IF icType = "query" THEN
                    "FUNCTION getTableHandleQry" + cPrimaryTable + " RETURNS HANDLE()." + CHR(10)
                  + "  RETURN BUFFER " + cPrimaryTable + ":HANDLE:TABLE-HANDLE." + CHR(10)
                  + "END FUNCTION." + CHR(10)
                   ELSE "")
                + "FUNCTION getBuffersAndFields"
                  + (IF icType = "browse" THEN "Brw" ELSE "Qry") 
                  + cPrimaryTable + " RETURNS CHARACTER()." + CHR(10)
                + "  RETURN " + TRIM(cTableFieldDef,",") + "." + CHR(10)
                + "END FUNCTION." + CHR(10)
                + "FUNCTION getQueryJoin" 
                  + (IF icType = "browse" THEN "Brw" ELSE "Qry") 
                  + cPrimaryTable + " RETURNS CHARACTER()." + CHR(10)
                + "  RETURN '" + cQueryJoin + "'." + CHR(10)
                + "END FUNCTION." + CHR(10)
                + "/*** End instance property settings for JBox" + icType + " object " + (IF icType = "query" THEN "oQry" ELSE "oBrw") + cPrimaryTable + " ***/" + CHR(10)
		.
    cInitObjCode =
                  (IF icType = "browse" THEN
                    "  oBrw" + cPrimaryTable + " = NEW JBoxBrowse(brw" + cPrimaryTable + ":HANDLE)." + CHR(10)
                   ELSE
                    "  oQry" + cPrimaryTable + " = NEW JBoxQuery('" + cPrimaryTable + "')." + CHR(10)
                   )
                  .

    IF icType = "browse" THEN
      cTips     = "/********************************************************************"  + CHR(10)
                + "This code is generated to support a static browse with primary table " + cPrimaryTable + CHR(10)
                + "in a JukeBox browse class. The first section should be copied to Definitions" + CHR(10)
                .
    ELSE
      cTips     = "/********************************************************************"  + CHR(10)
                + "This code is generated to support a static query with primary table " + cPrimaryTable + CHR(10)
                + "in a JukeBox query class. The first section should be copied to Definitions" + CHR(10)
                .
    cTips = cTips 
                + "You may edit the code:" + CHR(10)
                + "  - To add support for multiple joins to the same table" + CHR(10)
                + "    add 'buf[1-9]_<table name>' with corresponding fields to the getBuffersAndFields function" + CHR(10)
                + "    and also the 'buf[1-9]_<table name>' to getQueryJoin" + CHR(10)
                + "    Fields from the new table must also be added to the temp-table definition and browse display trigger:" + CHR(10)
                + "    - If the field is duplicate it must get the suffix representing the sequence of the added" + CHR(10)
                + "      table in the table-sequence, f,ex RepName4 if the BuffersAndFields looks like this: " + CHR(10)
                + "      Customer;CustNum;SalesRep,SalesRep;Repname,Order;OrderNum;SalesRep,buf1_SalesRep;RepName" + CHR(10)
                + "      (note: The suffix must not be added in the list of BuffersAndFields!)" + CHR(10)
                + "    FIELD RepName4 AS CHAR" + CHR(10) + CHR(10)
                + "  - To add a calculated field: " + CHR(10)
                + "    Add your new field to the temp-table definition" + (IF icType = "browse" THEN " (and display-trigger)." ELSE ".") + CHR(10)
                + "    Add it also to BuffersAndFields after the buffer-name from where it should " + CHR(10)
                + "    get it's ROWID parameter and/or field value parameter." + CHR(10)
                + "    (You can also set the parameter as a constant using the CalcFieldParam property.)" + CHR(10) + CHR(10)
                + "    Sample field def:" + CHR(10)
                + "      + ';+CustOrderTotal|DECIMAL||CustOrderTotal(CustNum)'" + CHR(10)
                + "    Assign the name of the .p procedure that contains CustOrderTotal to the browse/query object:" + CHR(10)
                + '      oBrwCustomer:calcFieldProc = "customer_browsecalc.p."' + CHR(10)
                + "*********************************************************************/" + CHR(10) + CHR(10)
                . 

END PROCEDURE.
