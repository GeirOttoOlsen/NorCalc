&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          sports12         PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description:        Container for a JukeBox window program

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            brynjar@chemistry.no

  Created:           18.oct.2006

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   
/* Uncomment to enable use of .Net components: */
/* &SCOPED-DEFINE AdvGuiWin */ 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

DEF VAR cInitSort   AS CHAR NO-UNDO.
DEF STREAM strLogFile.

/*** Start instance property definitions for JBoxBrowse object oBrwJBoxFileImportLog ***/
DEF VAR oBrwJBoxFileImportLog AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE JBoxFileImportLog
    FIELD dCreated AS date
    FIELD iCreTime_time AS CHARACTER
    FIELD cCreatedBy AS character
    FIELD cFileName AS character
    FIELD dFileCreateDate AS date
    FIELD cErrorMessage AS character
    FIELD cFirstKeyString AS character
    FIELD cLastKeyString AS character
    FIELD cTargetDBtable AS character
    FIELD iJBoxDocumentId AS integer
    FIELD cEntityId AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_JBoxFileImportLog FOR TEMP-TABLE JBoxFileImportLog.


FUNCTION getBuffersAndFieldsBrwJBoxFileImportLog RETURNS CHARACTER():
  RETURN
    'JBoxFileImportLog'
     + ';dCreated'
     + ';cCreatedBy'
     + ';cFileName'
     + ';dFileCreateDate'
     + ';cErrorMessage'
     + ';cFirstKeyString'
     + ';cLastKeyString'
     + ';cTargetDBtable'
     + ';+iCreTime_time|CHARACTER||jb_hhmm(iCreTime)|Time'
  + ',JBoxDocRel'
     + ';iJBoxDocumentId'
     + ';cEntityId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwJBoxFileImportLog RETURNS CHARACTER():
  RETURN 'EACH JBoxDocRel  WHERE JBoxDocRel.cContext = "JBoxFileImportLog" AND cEntityId = STRING(iJBoxFileImportLogId) NO-LOCK OUTER-JOIN'.
END FUNCTION.


DEF VAR opopupJBoxFileImportLog AS JBoxPopupMenu NO-UNDO.


/*** Start instance property definitions for JBoxBrowse object oBrwJBoxFileImportLogFileHeader ***/
DEF VAR oBrwJBoxFileImportLogFileHeader AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE JBoxFileImportLogFileHeader
    FIELD cImportLogFileType AS character
    FIELD cImportLogFileName AS character
    FIELD cImportLogFileDesc AS character
    FIELD iJBoxFileImportHeaderId AS integer
    FIELD iJBoxFileImportLogFileHeaderId AS integer
    FIELD iJBoxFileImportLogId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_JBoxFileImportLogFileHeader FOR TEMP-TABLE JBoxFileImportLogFileHeader.


FUNCTION getBuffersAndFieldsBrwJBoxFileImportLogFileHeader RETURNS CHARACTER():
  RETURN
    'JBoxFileImportLogFileHeader'
     + ';cImportLogFileType'
     + ';cImportLogFileName'
     + ';cImportLogFileDesc'
     + ';iJBoxFileImportHeaderId'
     + ';iJBoxFileImportLogFileHeaderId'
     + ';iJBoxFileImportLogId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwJBoxFileImportLogFileHeader RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR opopupJBoxFileImportHeaderLog AS JBoxPopupMenu NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwJBoxFileImportLog

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES JBoxFileImportLog ~
JBoxFileImportLogFileHeader

/* Definitions for BROWSE BrwJBoxFileImportLog                          */
&Scoped-define FIELDS-IN-QUERY-BrwJBoxFileImportLog ~
JBoxFileImportLog.dCreated JBoxFileImportLog.iCreTime_time ~
JBoxFileImportLog.cCreatedBy JBoxFileImportLog.cFileName ~
JBoxFileImportLog.dFileCreateDate JBoxFileImportLog.cErrorMessage ~
JBoxFileImportLog.cFirstKeyString JBoxFileImportLog.cLastKeyString ~
JBoxFileImportLog.cTargetDBtable JBoxFileImportLog.iJBoxDocumentId ~
JBoxFileImportLog.cEntityId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwJBoxFileImportLog ~
JBoxFileImportLog.dCreated 
&Scoped-define QUERY-STRING-BrwJBoxFileImportLog FOR EACH JBoxFileImportLog NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwJBoxFileImportLog OPEN QUERY BrwJBoxFileImportLog FOR EACH JBoxFileImportLog NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwJBoxFileImportLog JBoxFileImportLog
&Scoped-define FIRST-TABLE-IN-QUERY-BrwJBoxFileImportLog JBoxFileImportLog


/* Definitions for BROWSE BrwJBoxFileImportLogFileHeader                */
&Scoped-define FIELDS-IN-QUERY-BrwJBoxFileImportLogFileHeader ~
JBoxFileImportLogFileHeader.cImportLogFileType ~
JBoxFileImportLogFileHeader.cImportLogFileName ~
JBoxFileImportLogFileHeader.cImportLogFileDesc ~
JBoxFileImportLogFileHeader.iJBoxFileImportHeaderId ~
JBoxFileImportLogFileHeader.iJBoxFileImportLogFileHeaderId ~
JBoxFileImportLogFileHeader.iJBoxFileImportLogId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwJBoxFileImportLogFileHeader ~
JBoxFileImportLogFileHeader.cImportLogFileType 
&Scoped-define QUERY-STRING-BrwJBoxFileImportLogFileHeader FOR EACH JBoxFileImportLogFileHeader NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwJBoxFileImportLogFileHeader OPEN QUERY BrwJBoxFileImportLogFileHeader FOR EACH JBoxFileImportLogFileHeader NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwJBoxFileImportLogFileHeader ~
JBoxFileImportLogFileHeader
&Scoped-define FIRST-TABLE-IN-QUERY-BrwJBoxFileImportLogFileHeader JBoxFileImportLogFileHeader


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BrwJBoxFileImportLog ~
BrwJBoxFileImportLogFileHeader btnSplitBarY 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInitSort C-Win 
FUNCTION getInitSort RETURNS CHARACTER ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryString C-Win 
FUNCTION getQueryString RETURNS CHARACTER
  ( INPUT icTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnSplitBarY 
     IMAGE-UP FILE "bmp/tabup.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 1" 
     SIZE 83.8 BY .43.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwJBoxFileImportLog FOR 
      JBoxFileImportLog SCROLLING.

DEFINE QUERY BrwJBoxFileImportLogFileHeader FOR 
      JBoxFileImportLogFileHeader SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwJBoxFileImportLog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwJBoxFileImportLog C-Win _STRUCTURED
  QUERY BrwJBoxFileImportLog NO-LOCK DISPLAY
      JBoxFileImportLog.dCreated COLUMN-LABEL "Created" FORMAT "99/99/9999":U
      JBoxFileImportLog.iCreTime_time COLUMN-LABEL "Time" FORMAT "x(6)":U
      JBoxFileImportLog.cCreatedBy COLUMN-LABEL "By" FORMAT "X(8)":U
      JBoxFileImportLog.cFileName COLUMN-LABEL "File name" FORMAT "x(60)":U
      JBoxFileImportLog.dFileCreateDate COLUMN-LABEL "File created" FORMAT "99/99/9999":U
      JBoxFileImportLog.cErrorMessage COLUMN-LABEL "Error message" FORMAT "x(80)":U
      JBoxFileImportLog.cFirstKeyString COLUMN-LABEL "First imported key" FORMAT "x(60)":U
      JBoxFileImportLog.cLastKeyString COLUMN-LABEL "Last imported key" FORMAT "x(60)":U
      JBoxFileImportLog.cTargetDBtable COLUMN-LABEL "Import to db-table" FORMAT "x(40)":U
      JBoxFileImportLog.iJBoxDocumentId COLUMN-LABEL "Document id" FORMAT "->,>>>,>>9":U
      JBoxFileImportLog.cEntityId COLUMN-LABEL "Entity id" FORMAT "x(20)":U
  ENABLE
      JBoxFileImportLog.dCreated
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.38 FIT-LAST-COLUMN.

DEFINE BROWSE BrwJBoxFileImportLogFileHeader
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwJBoxFileImportLogFileHeader C-Win _STRUCTURED
  QUERY BrwJBoxFileImportLogFileHeader NO-LOCK DISPLAY
      JBoxFileImportLogFileHeader.cImportLogFileType COLUMN-LABEL "Import log file type" FORMAT "x(15)":U
      JBoxFileImportLogFileHeader.cImportLogFileName COLUMN-LABEL "Log file name" FORMAT "x(40)":U
      JBoxFileImportLogFileHeader.cImportLogFileDesc COLUMN-LABEL "Log file description" FORMAT "x(50)":U
      JBoxFileImportLogFileHeader.iJBoxFileImportHeaderId COLUMN-LABEL "File import header" FORMAT "->,>>>,>>9":U
      JBoxFileImportLogFileHeader.iJBoxFileImportLogFileHeaderId COLUMN-LABEL "Import log details id" FORMAT "->,>>>,>>9":U
      JBoxFileImportLogFileHeader.iJBoxFileImportLogId COLUMN-LABEL "File import log id" FORMAT "->,>>>,>>9":U
  ENABLE
      JBoxFileImportLogFileHeader.cImportLogFileType
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 4.52 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BrwJBoxFileImportLog AT ROW 1.48 COL 2 WIDGET-ID 200
     BrwJBoxFileImportLogFileHeader AT ROW 9.48 COL 2 WIDGET-ID 300
     btnSplitBarY AT ROW 8.95 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 83.8 BY 13.19 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<Insert window title>"
         HEIGHT             = 13.19
         WIDTH              = 83.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 114.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */
&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
  IF C-Win = ? THEN
    CREATE FRAME C-Win
           ASSIGN HIDDEN = YES.
&ENDIF

{incl/devmode.i}
{incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BrwJBoxFileImportLog 1 DEFAULT-FRAME */
/* BROWSE-TAB BrwJBoxFileImportLogFileHeader BrwJBoxFileImportLog DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 13.19
       FRAME DEFAULT-FRAME:WIDTH            = 83.8.

ASSIGN 
       BrwJBoxFileImportLog:PRIVATE-DATA IN FRAME DEFAULT-FRAME           = 
                "multiSortBrowse;Sorter på flere kolonner,ViewImported;View imported data,ViewDocument;View imported file".

ASSIGN 
       JBoxFileImportLogFileHeader.iJBoxFileImportHeaderId:VISIBLE IN BROWSE BrwJBoxFileImportLogFileHeader = FALSE
       JBoxFileImportLogFileHeader.iJBoxFileImportLogFileHeaderId:VISIBLE IN BROWSE BrwJBoxFileImportLogFileHeader = FALSE
       JBoxFileImportLogFileHeader.iJBoxFileImportLogId:VISIBLE IN BROWSE BrwJBoxFileImportLogFileHeader = FALSE.

ASSIGN 
       btnSplitBarY:MOVABLE IN FRAME DEFAULT-FRAME          = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwJBoxFileImportLog
/* Query rebuild information for BROWSE BrwJBoxFileImportLog
     _TblList          = "Sports12.JBoxFileImportLog"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"JBoxFileImportLog.dCreated" "Created" "99/99/9999" "date" ? ? ? ? ? ? yes "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"JBoxFileImportLog.iCreTime_time" "Time" "x(6)" "CHARACTER" ? ? ? ? ? ? no "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"JBoxFileImportLog.cCreatedBy" "By" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"JBoxFileImportLog.cFileName" "File name" "x(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"JBoxFileImportLog.dFileCreateDate" "File created" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"JBoxFileImportLog.cErrorMessage" "Error message" "x(80)" "character" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"JBoxFileImportLog.cFirstKeyString" "First imported key" "x(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"JBoxFileImportLog.cLastKeyString" "Last imported key" "x(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"JBoxFileImportLog.cTargetDBtable" "Import to db-table" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"JBoxFileImportLog.iJBoxDocumentId" "Document id" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"JBoxFileImportLog.cEntityId" "Entity id" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwJBoxFileImportLog */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwJBoxFileImportLogFileHeader
/* Query rebuild information for BROWSE BrwJBoxFileImportLogFileHeader
     _TblList          = "Sports12.JBoxFileImportLogFileHeader"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"JBoxFileImportLogFileHeader.cImportLogFileType" "Import log file type" "x(15)" "character" ? ? ? ? ? ? yes "" no no "17" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"JBoxFileImportLogFileHeader.cImportLogFileName" "Log file name" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"JBoxFileImportLogFileHeader.cImportLogFileDesc" "Log file description" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"JBoxFileImportLogFileHeader.iJBoxFileImportHeaderId" "File import header" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "16.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"JBoxFileImportLogFileHeader.iJBoxFileImportLogFileHeaderId" "Import log details id" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "18" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"JBoxFileImportLogFileHeader.iJBoxFileImportLogId" "File import log id" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "15" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwJBoxFileImportLogFileHeader */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <Insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <Insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSplitBarY
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarY C-Win
ON END-MOVE OF btnSplitBarY IN FRAME DEFAULT-FRAME /* Button 1 */
DO:
  DYNAMIC-FUNCTION("setSplitBarY",THIS-PROCEDURE:CURRENT-WINDOW,btnSplitBarY:HANDLE IN FRAME {&FRAME-NAME},NO).
/*  apply "window-resized" to {&window-name}.*/
/*   RUN MoveToTop. */
/*   DYNAMIC-FUNCTION("MoveTabToTop" IN hTabFolder,OrderFolder:HANDLE). */
/*   RUN MoveToTop IN hCurrTabProc NO-ERROR.                            */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwJBoxFileImportLog
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
&ENDIF

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    DELETE OBJECT oContainer NO-ERROR.
  &ENDIF
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
{incl/conttrigg.i oBrwJBoxFileImportLog:BROWSE-HANDLE}
&ENDIF

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
  &ENDIF

  IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
    &IF DEFINED(UIB_is_Running) = 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
    SESSION:SET-WAIT-STATE("").
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
    ELSE 
    &ENDIF
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :

DEF VAR cDisabledMenuItems AS CHAR NO-UNDO.

IF oBrwJBoxFileImportLog:isCurrent THEN DO WITH FRAME {&FRAME-NAME}:

  IF AVAIL JBoxFileImportLog THEN DO:
    IF JBoxFileImportLog.iJBoxDocumentId = 0 THEN
      cDisabledMenuItems = "ViewDocument".
    IF JBoxFileImportLog.cFirstKeyString = "" THEN
      cDisabledMenuItems = cDisabledMenuItems + ",ViewImported".
  END.

  oBrwJBoxFileImportLog:disabledTools = TRIM(cDisabledMenuItems,",").

END.

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE BrwJBoxFileImportLog BrwJBoxFileImportLogFileHeader btnSplitBarY 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Refer to the <jukebox>\winsrc\samples for working examples for Sports2000
------------------------------------------------------------------------------*/
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DO WITH FRAME {&FRAME-NAME}:

  oBrwJBoxFileImportLog = NEW JBoxBrowse(brwJBoxFileImportLog:HANDLE).

  opopupJBoxFileImportLog = NEW JBoxPopupMenu().
  opopupJBoxFileImportLog:AddToolGroup('multiSortBrowse;Sorter på flere kolonner,ViewImported;View imported data,ViewDocument;View imported file').

  oBrwJBoxFileImportLog:POPUP-MENU-OBJECT = opopupJBoxFileImportLog.
  oBrwJBoxFileImportLogFileHeader = NEW JBoxBrowse(brwJBoxFileImportLogFileHeader:HANDLE).
  
  oBrwJBoxFileImportLogFileHeader:setParentBrowseObject(oBrwJBoxFileImportLog,"iJBoxFileImportLogId").

  opopupJBoxFileImportHeaderLog = NEW JBoxPopupMenu().
  opopupJBoxFileImportHeaderLog:AddToolGroup('OpenLogFile;Open logfile').

  oBrwJBoxFileImportLogFileHeader:POPUP-MENU-OBJECT = opopupJBoxFileImportHeaderLog.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:setSplitBarY(btnSplitBarY:HANDLE).
  oContainer:setSplitBarYlimits(btnSplitBarY:HANDLE,100,80). /* 200 pixels from the top, 300 pixels from the bottom */
  oContainer:setFollowSplitBarY(STRING(BrwJBoxFileImportLog:HANDLE) + "," + STRING(BrwJBoxFileImportLogFileHeader:HANDLE)).
  oContainer:setNoResizeY("BrwJBoxFileImportLog").
  oContainer:initResize().
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop C-Win 
PROCEDURE MoveToTop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
THIS-PROCEDURE:CURRENT-WINDOW:HIDDEN = NO.
IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
  RUN ShowForm("").
THIS-PROCEDURE:CURRENT-WINDOW:WINDOW-STATE = 3.
THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
DYNAMIC-FUNCTION("DoLockWindow",?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenLogFileRecord C-Win 
PROCEDURE OpenLogFileRecord :
DEF VAR hTempTable  AS HANDLE NO-UNDO.
DEF VAR hTTbuffer   AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR cFileType   AS CHAR   NO-UNDO.
DEF VAR cFileName   AS CHAR   NO-UNDO.
DEF VAR bSourceData AS LOG    NO-UNDO.
DEF VAR cDelimiter  AS CHAR   NO-UNDO INIT "~t".

IF JBoxFileImportLogFileHeader.cImportLogFileType = "sourcedata" THEN DO:
  bSourceData = YES.
  IF NUM-ENTRIES(JBoxFileImportLog.cFileName,".") > 1 THEN
    cFileType = SUBSTR(JBoxFileImportLog.cFileName,R-INDEX(JBoxFileImportLog.cFileName,".")).
  ELSE cFileType = ".txt".
END.
ELSE DO:
  IF NUM-ENTRIES(JBoxFileImportLog.cFileName,".") > 1 THEN
    ASSIGN cFileType  = SUBSTR(JBoxFileImportLog.cFileName,R-INDEX(JBoxFileImportLog.cFileName,"."))
           cDelimiter = oContainer:PARENT-CONTAINER-OBJECT:BUFFER-HANDLE:BUFFER-FIELD("cDelimiter"):BUFFER-VALUE.
  ELSE cFileType = ".txt".
END. 
     
cFileName = SESSION:TEMP-DIRECTORY + JBoxFileImportLogFileHeader.cImportLogFileName 
          + "_" + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY)) + STRING(DAY(TODAY)) + "_" + STRING(TIME) + cFileType.

OUTPUT STREAM strLogFile TO VALUE(cFileName).

hTempTable = DYNAMIC-FUNCTION("getTempTable",""
            ,"JBoxFileImportLogFile|WHERE iJBoxFileImportLogFileHeaderId = " 
             + STRING(JBoxFileImportLogFileHeader.iJBoxFileImportLogFileHeaderId),?).

hTTbuffer = hTempTable:DEFAULT-BUFFER-HANDLE.
CREATE QUERY hQuery.
hQuery:SET-BUFFERS(hTTbuffer).
hQuery:QUERY-PREPARE("FOR EACH " + hTTbuffer:NAME + " BY iImportLogLineNum").
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  IF bSourceData THEN
    PUT STREAM strLogFile UNFORMATTED hTTbuffer:BUFFER-FIELD("cImportLogText"):BUFFER-VALUE SKIP.
  ELSE
    PUT STREAM strLogFile UNFORMATTED hTTbuffer:BUFFER-FIELD("iImportLogLineNum"):BUFFER-VALUE cDelimiter
                    hTTbuffer:BUFFER-FIELD("cImportLogText"):BUFFER-VALUE SKIP.
  hQuery:GET-NEXT().
END.

OUTPUT STREAM strLogFile CLOSE.

DELETE OBJECT hQuery.
DELETE OBJECT hTempTable NO-ERROR.

DYNAMIC-FUNCTION("setWebDoc","",cFileName).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewDocumentRecord C-Win 
PROCEDURE ViewDocumentRecord :
DYNAMIC-FUNCTION("ViewDocs",
                    oBrwJBoxFileImportLog:BUFFER-HANDLE:NAME,
                    STRING(JBoxFileImportLog.cEntityId),
                    TRUE,"").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewImportedRecord C-Win 
PROCEDURE ViewImportedRecord :
DEF VAR hFileImportData   AS HANDLE NO-UNDO.
DEF VAR hBrwData          AS HANDLE NO-UNDO.

IF JBoxFileImportLog.cTargetDBtable = "" THEN RETURN.

RUN JBoxDataBrw.w PERSIST SET hFileImportData.

RUN InitializeObject IN hFileImportData (JBoxFileImportLog.cTargetDBtable,
                                         getQueryString(JBoxFileImportLog.cTargetDBtable),
                                         getInitSort(),
                                         TRUE).

hFileImportData:CURRENT-WINDOW:TITLE = JBoxFileImportLog.cTargetDBtable
                                     + " [importert " + STRING(JBoxFileImportLog.dCreated) + "]"
                                       .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInitSort C-Win 
FUNCTION getInitSort RETURNS CHARACTER () :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:

END.

RETURN cInitSort.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryString C-Win 
FUNCTION getQueryString RETURNS CHARACTER
  ( INPUT icTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF VAR htTarget          AS HANDLE NO-UNDO.
DEF VAR hbTarget          AS HANDLE NO-UNDO.
DEF VAR cQueryString      AS CHAR   NO-UNDO INIT "WHERE ".
DEF VAR cKeyString        AS CHAR   NO-UNDO.
DEF VAR ix                AS INT    NO-UNDO.

htTarget = DYNAMIC-FUNCTION("getTempTable","jbserv_gettemptable.p",
                             icTable + "|where false",
                             ?).
hbTarget = htTarget:DEFAULT-BUFFER-HANDLE.                             

cKeyString = JBoxFileImportLog.cFirstKeyString.
DO ix = 1 TO NUM-ENTRIES(cKeyString,"|") BY 2:   
  IF ix > 1 THEN cQueryString = cQueryString + " AND ".    
  ELSE cInitSort = ENTRY(ix,cKeyString,"|").
  CASE hbTarget:BUFFER-FIELD(ENTRY(ix,cKeyString,"|")):DATA-TYPE:
    WHEN "character" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " GE '" + ENTRY(ix + 1,cKeyString,"|") + "'".
    WHEN "date" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " GE DATE('" + ENTRY(ix + 1,cKeyString,"|") + "')".
    WHEN "decimal" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " GE DEC('" + ENTRY(ix + 1,cKeyString,"|") + "')".
    WHEN "integer" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " GE INT('" + ENTRY(ix + 1,cKeyString,"|") + "')".
    WHEN "logical" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " = LOGICAL('" + ENTRY(ix + 1,cKeyString,"|") + "')".
  END CASE.
END.
cKeyString = JBoxFileImportLog.cLastKeyString.
DO ix = 1 TO NUM-ENTRIES(cKeyString,"|") BY 2:   
  cQueryString = cQueryString + " AND ".    
  CASE hbTarget:BUFFER-FIELD(ENTRY(ix,cKeyString,"|")):DATA-TYPE:
    WHEN "character" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " LE '" + ENTRY(ix + 1,cKeyString,"|") + "'".
    WHEN "date" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " LE DATE('" + ENTRY(ix + 1,cKeyString,"|") + "')".
    WHEN "decimal" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " LE DEC('" + ENTRY(ix + 1,cKeyString,"|") + "')".
    WHEN "integer" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " LE INT('" + ENTRY(ix + 1,cKeyString,"|") + "')".
    WHEN "logical" THEN 
      cQueryString = cQueryString + ENTRY(ix,cKeyString,"|") + " = LOGICAL('" + ENTRY(ix + 1,cKeyString,"|") + "')".
  END CASE.
END.

DELETE OBJECT htTarget.
RETURN cQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

