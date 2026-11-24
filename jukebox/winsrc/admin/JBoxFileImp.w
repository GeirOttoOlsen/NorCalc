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
&SCOPED-DEFINE AdvGuiWin 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

DEF VAR cMenuCatParam AS CHAR NO-UNDO.

/*** Start instance property definitions for JBoxBrowse object oBrwJBoxFileImportHeader ***/
DEF VAR oBrwJBoxFileImportHeader AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE JBoxFileImportHeader
    FIELD cDescription AS character
    FIELD cImportProg AS character
    FIELD cTargetDBtable AS character
    FIELD cImportType AS character
    FIELD cMenuCategory AS character
    FIELD dCreated AS date
    FIELD cCreatedBy AS character
    FIELD dModified AS date
    FIELD cModifiedBy AS character
    FIELD iJBoxFileImportHeaderId AS integer
    FIELD iJBoxCompanyId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_JBoxFileImportHeader FOR TEMP-TABLE JBoxFileImportHeader.


FUNCTION getBuffersAndFieldsBrwJBoxFileImportHeader RETURNS CHARACTER():
  RETURN
    'JBoxFileImportHeader'
     + ';cDescription'
     + ';cImportProg'
     + ';cTargetDBtable'
     + ';cImportType'
     + ';cMenuCategory'
     + ';dCreated'
     + ';cCreatedBy'
     + ';dModified'
     + ';cModifiedBy'
     + ';iJBoxFileImportHeaderId'
     + ';iJBoxCompanyId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwJBoxFileImportHeader RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbJBoxFileImportHeader AS JBoxToolbar NO-UNDO.
DEF VAR oTabJBoxFileImportHeader AS JBoxMsTabs NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwJBoxFileImportHeader

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES JBoxFileImportHeader

/* Definitions for BROWSE BrwJBoxFileImportHeader                       */
&Scoped-define FIELDS-IN-QUERY-BrwJBoxFileImportHeader ~
JBoxFileImportHeader.cDescription JBoxFileImportHeader.cImportProg ~
JBoxFileImportHeader.cTargetDBtable JBoxFileImportHeader.cImportType ~
JBoxFileImportHeader.cMenuCategory JBoxFileImportHeader.dCreated ~
JBoxFileImportHeader.cCreatedBy JBoxFileImportHeader.dModified ~
JBoxFileImportHeader.cModifiedBy ~
JBoxFileImportHeader.iJBoxFileImportHeaderId ~
JBoxFileImportHeader.iJBoxCompanyId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwJBoxFileImportHeader ~
JBoxFileImportHeader.cDescription 
&Scoped-define QUERY-STRING-BrwJBoxFileImportHeader FOR EACH JBoxFileImportHeader NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwJBoxFileImportHeader OPEN QUERY BrwJBoxFileImportHeader FOR EACH JBoxFileImportHeader NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwJBoxFileImportHeader JBoxFileImportHeader
&Scoped-define FIRST-TABLE-IN-QUERY-BrwJBoxFileImportHeader JBoxFileImportHeader


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbJBoxFileImportHeader ~
searchJBoxFileImportHeader TabJBoxFileImportHeader ~
filter_tbJBoxFileImportHeader excel_tbJBoxFileImportHeader ~
BrwJBoxFileImportHeader 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMenuCatParameter C-Win 
FUNCTION getMenuCatParameter RETURNS CHARACTER()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbJBoxFileImportHeader 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.52 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbJBoxFileImportHeader 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE RECTANGLE searchJBoxFileImportHeader
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 22 BY 1.19.

DEFINE RECTANGLE TabJBoxFileImportHeader
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123 BY 23.33.

DEFINE RECTANGLE tbJBoxFileImportHeader
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 171 BY 1.71.

DEFINE BUTTON btnSplitBarX 
     IMAGE-UP FILE "bmp/tabright.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE .8 BY 23
     BGCOLOR 12 FGCOLOR 12 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwJBoxFileImportHeader FOR 
      JBoxFileImportHeader SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwJBoxFileImportHeader
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwJBoxFileImportHeader C-Win _STRUCTURED
  QUERY BrwJBoxFileImportHeader NO-LOCK DISPLAY
      JBoxFileImportHeader.cDescription COLUMN-LABEL "Description" FORMAT "x(50)":U
      JBoxFileImportHeader.cImportProg COLUMN-LABEL "Import program" FORMAT "x(40)":U
      JBoxFileImportHeader.cTargetDBtable COLUMN-LABEL "Import to db-table" FORMAT "x(40)":U
      JBoxFileImportHeader.cImportType COLUMN-LABEL "ImportType" FORMAT "x(8)":U
      JBoxFileImportHeader.cMenuCategory COLUMN-LABEL "Menu cat" FORMAT "x(20)":U
      JBoxFileImportHeader.dCreated COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
      JBoxFileImportHeader.cCreatedBy COLUMN-LABEL "Av" FORMAT "X(8)":U
      JBoxFileImportHeader.dModified COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
      JBoxFileImportHeader.cModifiedBy COLUMN-LABEL "Av" FORMAT "X(8)":U
      JBoxFileImportHeader.iJBoxFileImportHeaderId COLUMN-LABEL "File import header" FORMAT "->,>>>,>>9":U
      JBoxFileImportHeader.iJBoxCompanyId COLUMN-LABEL "CompanyId" FORMAT "->,>>>,>>9":U
  ENABLE
      JBoxFileImportHeader.cDescription
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 45 BY 23.33 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     filter_tbJBoxFileImportHeader AT ROW 1.33 COL 27.2 WIDGET-ID 4
     excel_tbJBoxFileImportHeader AT ROW 1.33 COL 33.2 WIDGET-ID 6
     BrwJBoxFileImportHeader AT ROW 3.14 COL 3 WIDGET-ID 200
     tbJBoxFileImportHeader AT ROW 1.24 COL 3 WIDGET-ID 2
     searchJBoxFileImportHeader AT ROW 1.48 COL 4 WIDGET-ID 8
     TabJBoxFileImportHeader AT ROW 3.14 COL 51.2 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 174 BY 25.76 WIDGET-ID 100.

DEFINE FRAME frSplitBarX
     btnSplitBarX AT ROW 1.1 COL 20.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 28.8 ROW 3.14
         SIZE 47 BY 23.33 WIDGET-ID 300.


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
         HEIGHT             = 25.81
         WIDTH              = 174
         MAX-HEIGHT         = 26
         MAX-WIDTH          = 174
         VIRTUAL-HEIGHT     = 26
         VIRTUAL-WIDTH      = 174
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
/* REPARENT FRAME */
ASSIGN FRAME frSplitBarX:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BrwJBoxFileImportHeader excel_tbJBoxFileImportHeader DEFAULT-FRAME */
ASSIGN 
       tbJBoxFileImportHeader:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "filter;Filter,excel;Eksporter til E&xcelmaxborder".

/* SETTINGS FOR FRAME frSplitBarX
                                                                        */
ASSIGN 
       btnSplitBarX:MOVABLE IN FRAME frSplitBarX          = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwJBoxFileImportHeader
/* Query rebuild information for BROWSE BrwJBoxFileImportHeader
     _TblList          = "Sports12.JBoxFileImportHeader"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"JBoxFileImportHeader.cDescription" "Description" "x(50)" "character" ? ? ? ? ? ? yes "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"JBoxFileImportHeader.cImportProg" "Import program" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"JBoxFileImportHeader.cTargetDBtable" "Import to db-table" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"JBoxFileImportHeader.cImportType" "ImportType" "x(8)" "character" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"JBoxFileImportHeader.cMenuCategory" "Menu cat" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"JBoxFileImportHeader.dCreated" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"JBoxFileImportHeader.cCreatedBy" "Av" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"JBoxFileImportHeader.dModified" "Endret" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"JBoxFileImportHeader.cModifiedBy" "Av" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"JBoxFileImportHeader.iJBoxFileImportHeaderId" "File import header" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "16.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"JBoxFileImportHeader.iJBoxCompanyId" "CompanyId" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwJBoxFileImportHeader */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frSplitBarX
/* Query rebuild information for FRAME frSplitBarX
     _Query            is NOT OPENED
*/  /* FRAME frSplitBarX */
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


&Scoped-define FRAME-NAME frSplitBarX
&Scoped-define SELF-NAME btnSplitBarX
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarX C-Win
ON END-MOVE OF btnSplitBarX IN FRAME frSplitBarX
DO:
  DYNAMIC-FUNCTION("setSplitBarX" , THIS-PROCEDURE:CURRENT-WINDOW, btnSplitBarX:HANDLE IN FRAME frSplitBarX,NO).
/*  RUN MoveToTop IN hCurrTabProc NO-ERROR.*/

  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarX C-Win
ON START-MOVE OF btnSplitBarX IN FRAME frSplitBarX
DO:
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",THIS-PROCEDURE:CURRENT-WINDOW).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwJBoxFileImportHeader
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
{incl/conttrigg.i oBrwJBoxFileImportHeader:BROWSE-HANDLE}
&ENDIF

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  cMenuCatParam = DYNAMIC-FUNCTION("getParameter" IN SOURCE-PROCEDURE) NO-ERROR.

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
  RUN SUPER.
  IF oBrwJBoxFileImportHeader:isCurrent THEN  DO WITH FRAME {&FRAME-NAME}:
    DYNAMIC-FUNCTION("DoMyPublish" IN oTabJBoxFileImportHeader:getPageHandle(1)).
  END.

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
  ENABLE tbJBoxFileImportHeader searchJBoxFileImportHeader 
         TabJBoxFileImportHeader filter_tbJBoxFileImportHeader 
         excel_tbJBoxFileImportHeader BrwJBoxFileImportHeader 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE btnSplitBarX 
      WITH FRAME frSplitBarX IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frSplitBarX}
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

  oBrwJBoxFileImportHeader = NEW JBoxBrowse(brwJBoxFileImportHeader:HANDLE).

  otbJBoxFileImportHeader = NEW JBoxToolbar(tbJBoxFileImportHeader:HANDLE).

  oBrwJBoxFileImportHeader:TOOLBAR-OBJECT = otbJBoxFileImportHeader.
  oBrwJBoxFileImportHeader:setSearchField(searchJBoxFileImportHeader:HANDLE,"cDescription").
  oTabJBoxFileImportHeader = NEW JBoxMsTabs(TabJBoxFileImportHeader:HANDLE,oBrwJBoxFileImportHeader,"ico\bullet_triangle_green.ico,ico\bullet_ball_blue.ico,ico\bullet_ball_yellow.ico").
  oTabJBoxFileImportHeader:pageOneType = "oneToOne".

  oTabJBoxFileImportHeader:setLinkFields("iJBoxFileImportHeaderId").
  oTabJBoxFileImportHeader:AddPage("Import header","JBoxFileImpView.w","bullet_triangle_green.ico").
  oTabJBoxFileImportHeader:AddPage("Import spec","JBoxFileImpSpec.w","bullet_ball_blue.ico").
  oTabJBoxFileImportHeader:AddPage("Import spec","JBoxFileImpLogBrw.w","bullet_ball_yellow.ico").
  
  oContainer:setSplitBarX(btnSplitBarX:HANDLE IN FRAME frSplitBarX).
  oContainer:setFollowSplitBarX(STRING(BrwJBoxFileImportHeader:HANDLE) + "," + STRING(TabJBoxFileImportHeader:HANDLE)).
  oContainer:setNoResizeX("BrwJBoxFileImportHeader").
END.
oBrwJBoxFileImportHeader:OpenQuery().

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMenuCatParameter C-Win 
FUNCTION getMenuCatParameter RETURNS CHARACTER() :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

RETURN cMenuCatParam.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

