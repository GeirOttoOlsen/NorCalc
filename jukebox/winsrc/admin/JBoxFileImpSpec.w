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

DEF VAR oDropDataType AS JBoxBrowseDropDown NO-UNDO.
DEF VAR oDropTable    AS JBoxBrowseDropDown NO-UNDO.

/*** Start instance property definitions for JBoxBrowse object oBrwJBoxFileImportSpec ***/
DEF VAR oBrwJBoxFileImportSpec AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE JBoxFileImportSpec
    FIELD iSeq AS integer
    FIELD cAlphaSeq AS CHARACTER
    FIELD cFieldName AS character
    FIELD cDataType AS character
    FIELD cDBfieldName AS character
    FIELD iJBoxFileImportHeaderId AS integer
    FIELD iJBoxFileImportSpecId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_JBoxFileImportSpec FOR TEMP-TABLE JBoxFileImportSpec.


FUNCTION getBuffersAndFieldsBrwJBoxFileImportSpec RETURNS CHARACTER():
  RETURN
    'JBoxFileImportSpec'
     + ';iSeq'
     + ';cFieldName'
     + ';cDataType'
     + ';cDBfieldName'
     + ';iJBoxFileImportHeaderId'
     + ';iJBoxFileImportSpecId'
     + ';+cAlphaSeq|CHARACTER||jbserv_seqno_to_alpha.p(iSeq)|Alpha'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwJBoxFileImportSpec RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
/*
FUNCTION getCalcFieldProcBrwJBoxFileImportSpec RETURNS CHARACTER():
  RETURN 
     'jbserv_seqno_to_alpha.p' /* cAlphaSeq(ROWID) */
     .
END FUNCTION.
*/
DEF VAR otbJBoxFileImportSpec AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwJBoxFileImportSpec

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES JBoxFileImportSpec

/* Definitions for BROWSE BrwJBoxFileImportSpec                         */
&Scoped-define FIELDS-IN-QUERY-BrwJBoxFileImportSpec ~
JBoxFileImportSpec.iSeq JBoxFileImportSpec.cAlphaSeq ~
JBoxFileImportSpec.cFieldName JBoxFileImportSpec.cDataType ~
JBoxFileImportSpec.cDBfieldName JBoxFileImportSpec.iJBoxFileImportHeaderId ~
JBoxFileImportSpec.iJBoxFileImportSpecId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwJBoxFileImportSpec ~
JBoxFileImportSpec.iSeq 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwJBoxFileImportSpec ~
JBoxFileImportSpec
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwJBoxFileImportSpec JBoxFileImportSpec
&Scoped-define QUERY-STRING-BrwJBoxFileImportSpec FOR EACH JBoxFileImportSpec NO-LOCK, INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwJBoxFileImportSpec OPEN QUERY BrwJBoxFileImportSpec FOR EACH JBoxFileImportSpec NO-LOCK, INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwJBoxFileImportSpec JBoxFileImportSpec
&Scoped-define FIRST-TABLE-IN-QUERY-BrwJBoxFileImportSpec JBoxFileImportSpec


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbJBoxFileImportSpec ~
new_tbJBoxFileImportSpec copy_tbJBoxFileImportSpec ~
delete_tbJBoxFileImportSpec refresh_tbJBoxFileImportSpec ~
excel_tbJBoxFileImportSpec BrwJBoxFileImportSpec 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DoMyPublish C-Win 
FUNCTION DoMyPublish RETURNS LOGICAL ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbJBoxFileImportSpec 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 4.6 BY 1.1 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbJBoxFileImportSpec 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 4.6 BY 1.1 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON excel_tbJBoxFileImportSpec 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 4.6 BY 1.1 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON new_tbJBoxFileImportSpec 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 4.6 BY 1.1 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON refresh_tbJBoxFileImportSpec 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 4.6 BY 1.1 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbJBoxFileImportSpec
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 81.6 BY 1.29.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwJBoxFileImportSpec FOR 
      JBoxFileImportSpec SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwJBoxFileImportSpec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwJBoxFileImportSpec C-Win _STRUCTURED
  QUERY BrwJBoxFileImportSpec NO-LOCK DISPLAY
      JBoxFileImportSpec.iSeq COLUMN-LABEL "Seq" FORMAT ">>9":U
      JBoxFileImportSpec.cAlphaSeq COLUMN-LABEL "Alpha" FORMAT "X(8)":U
      JBoxFileImportSpec.cFieldName COLUMN-LABEL "Fieldname" FORMAT "x(40)":U
      JBoxFileImportSpec.cDataType COLUMN-LABEL "DataType" FORMAT "x(16)":U
      JBoxFileImportSpec.cDBfieldName COLUMN-LABEL "DB field name" FORMAT "x(40)":U
      JBoxFileImportSpec.iJBoxFileImportHeaderId COLUMN-LABEL "File import header" FORMAT "->,>>>,>>9":U
      JBoxFileImportSpec.iJBoxFileImportSpecId COLUMN-LABEL "File imp spec id" FORMAT "->,>>>,>>9":U
  ENABLE
      JBoxFileImportSpec.iSeq
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 81 BY 11.67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbJBoxFileImportSpec AT ROW 1.33 COL 2.2 WIDGET-ID 4
     copy_tbJBoxFileImportSpec AT ROW 1.33 COL 6.8 WIDGET-ID 6
     delete_tbJBoxFileImportSpec AT ROW 1.33 COL 11.6 WIDGET-ID 8
     refresh_tbJBoxFileImportSpec AT ROW 1.33 COL 16.2 WIDGET-ID 10
     excel_tbJBoxFileImportSpec AT ROW 1.33 COL 21 WIDGET-ID 12
     BrwJBoxFileImportSpec AT ROW 2.71 COL 2 WIDGET-ID 200
     tbJBoxFileImportSpec AT ROW 1.24 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 83.6 BY 13.71 WIDGET-ID 100.


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
         HEIGHT             = 13.71
         WIDTH              = 83.6
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
/* BROWSE-TAB BrwJBoxFileImportSpec excel_tbJBoxFileImportSpec DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 13.71
       FRAME DEFAULT-FRAME:WIDTH            = 83.6.

ASSIGN 
       JBoxFileImportSpec.iJBoxFileImportHeaderId:VISIBLE IN BROWSE BrwJBoxFileImportSpec = FALSE
       JBoxFileImportSpec.iJBoxFileImportHeaderId:AUTO-RESIZE IN BROWSE BrwJBoxFileImportSpec = TRUE
       JBoxFileImportSpec.iJBoxFileImportSpecId:VISIBLE IN BROWSE BrwJBoxFileImportSpec = FALSE.

ASSIGN 
       tbJBoxFileImportSpec:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,copy;Kopier,delete;Slett,refresh;Refresh,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwJBoxFileImportSpec
/* Query rebuild information for BROWSE BrwJBoxFileImportSpec
     _TblList          = "Sports12.JBoxFileImportSpec"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > JBoxFileImportSpec.iSeq
"JBoxFileImportSpec.iSeq" "Seq" ">>9" "integer" ? ? ? ? ? ? yes "" no no "3.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"JBoxFileImportSpec.cAlphaSeq" "Alpha" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > JBoxFileImportSpec.cFieldName
"JBoxFileImportSpec.cFieldName" "Fieldname" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > JBoxFileImportSpec.cDataType
"JBoxFileImportSpec.cDataType" "DataType" "x(16)" "character" ? ? ? ? ? ? no "" no no "16" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > JBoxFileImportSpec.cDBfieldName
"JBoxFileImportSpec.cDBfieldName" "DB field name" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > JBoxFileImportSpec.iJBoxFileImportHeaderId
"JBoxFileImportSpec.iJBoxFileImportHeaderId" "File import header" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "16.6" no yes no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > JBoxFileImportSpec.iJBoxFileImportSpecId
"JBoxFileImportSpec.iJBoxFileImportSpecId" "File imp spec id" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "14.4" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwJBoxFileImportSpec */
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


&Scoped-define BROWSE-NAME BrwJBoxFileImportSpec
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
{incl/conttrigg.i oBrwJBoxFileImportSpec:BROWSE-HANDLE}
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
  ENABLE tbJBoxFileImportSpec new_tbJBoxFileImportSpec 
         copy_tbJBoxFileImportSpec delete_tbJBoxFileImportSpec 
         refresh_tbJBoxFileImportSpec excel_tbJBoxFileImportSpec 
         BrwJBoxFileImportSpec 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FileImportToTable C-Win 
PROCEDURE FileImportToTable :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icDatabase  AS CHAR NO-UNDO.
DEF INPUT PARAM icDBtable   AS CHAR NO-UNDO.

IF icDBtable NE ? AND icDBtable NE "" THEN
  oDropTable:DropDownHandle:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid(
                                                icDatabase
                                              + "_file," + icDatabase + "_field;_field-name;_field-name",
                                                "WHERE _file-name = '" + icDBtable + "'"
                                              + ",EACH _field OF _file NO-LOCK").
ELSE
  oDropTable:DropDownHandle:LIST-ITEM-PAIRS = "|".

oBrwJBoxFileImportSpec:DisplayRecord().

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

SUBSCRIBE TO "FileImportToTable" ANYWHERE.

DO WITH FRAME {&FRAME-NAME}:

  oBrwJBoxFileImportSpec = NEW JBoxBrowse(brwJBoxFileImportSpec:HANDLE).
  oBrwJBoxFileImportSpec:enableOnDblClick = YES.
  oBrwJBoxFileImportSpec:enabledColumns = "iSeq,cFieldName".

  oDropDataType = NEW JBoxBrowseDropDown(oBrwJBoxFileImportSpec,"cDataType","||CHARACTER|CHARACTER|DATE|DATE|DECIMAL|DECIMAL|INTEGER|INTEGER|LOGICAL|LOGICAL").
  oDropTable = NEW JBoxBrowseDropDown(oBrwJBoxFileImportSpec,"cDBfieldName","|").

  otbJBoxFileImportSpec = NEW JBoxToolbar(tbJBoxFileImportSpec:HANDLE).

  oBrwJBoxFileImportSpec:TOOLBAR-OBJECT = otbJBoxFileImportSpec.
END.
oBrwJBoxFileImportSpec:OpenQuery().

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DoMyPublish C-Win 
FUNCTION DoMyPublish RETURNS LOGICAL () :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  MESSAGE 
  VIEW-AS ALERT-BOX.
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

