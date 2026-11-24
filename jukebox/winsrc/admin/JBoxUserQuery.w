&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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


/*** Start instance property definitions for JBoxBrowse object oBrwJBoxUserSetting ***/
DEF VAR oBrwJBoxUserSetting AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE JBoxUserSetting
    FIELD cJBoxUserId AS character
    FIELD cUserName AS character
    FIELD cSetting AS character
    FIELD dCreated AS date
    FIELD QuerySchedule AS CHARACTER
    FIELD cMenuLabel AS character
    FIELD cContext AS character
    FIELD cSettingName AS character
    FIELD cObjectName AS character
    FIELD cSourceFile AS character
    FIELD iJBoxUserSettingId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEF BUFFER v_JBoxUserSetting FOR TEMP-TABLE JBoxUserSetting.


FUNCTION getBuffersAndFieldsBrwJBoxUserSetting RETURNS CHARACTER():
  RETURN
    'JBoxUserSetting'
     + ';cJBoxUserId'
     + ';cSetting'
     + ';dCreated'
     + ';cContext'
     + ';cSettingName'
     + ';cObjectName'
     + ';cSourceFile'
     + ';iJBoxUserSettingId'
     + ';+QuerySchedule|CHARACTER||QuerySchedule|Schedule'
  + ',JBoxUser'
     + ';cUserName'
  + ',JBoxMenu'
     + ';cMenuLabel'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwJBoxUserSetting RETURNS CHARACTER():
  RETURN 'EACH JBoxUser OF JBoxUserSetting NO-LOCK,EACH JBoxMenu  WHERE JBoxMenu.cLaunch = JBoxUserSetting.cContext OUTER-JOIN NO-LOCK'.
END FUNCTION.
FUNCTION getCalcFieldProcBrwJBoxUserSetting RETURNS CHARACTER():
  RETURN 
     'jbadmin_userquery_schedule.p' /* QuerySchedule */
     .
END FUNCTION.


DEF VAR otbJBoxUserSetting AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwJBoxUserSetting

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES JBoxUserSetting

/* Definitions for BROWSE BrwJBoxUserSetting                            */
&Scoped-define FIELDS-IN-QUERY-BrwJBoxUserSetting ~
JBoxUserSetting.cJBoxUserId JBoxUserSetting.cUserName ~
JBoxUserSetting.cSetting JBoxUserSetting.dCreated ~
JBoxUserSetting.QuerySchedule JBoxUserSetting.cMenuLabel ~
JBoxUserSetting.cContext JBoxUserSetting.cSettingName ~
JBoxUserSetting.cObjectName JBoxUserSetting.cSourceFile ~
JBoxUserSetting.iJBoxUserSettingId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwJBoxUserSetting ~
JBoxUserSetting.cJBoxUserId 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwJBoxUserSetting JBoxUserSetting
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwJBoxUserSetting JBoxUserSetting
&Scoped-define QUERY-STRING-BrwJBoxUserSetting FOR EACH JBoxUserSetting NO-LOCK, ~
    EACH JBoxUser OF JBoxUserSetting NO-LOCK, ~
    EACH JBoxMenu WHERE JBoxMenu.cLaunch = JBoxUserSetting.cContext OUTER-JOIN NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwJBoxUserSetting OPEN QUERY BrwJBoxUserSetting FOR EACH JBoxUserSetting NO-LOCK, ~
    EACH JBoxUser OF JBoxUserSetting NO-LOCK, ~
    EACH JBoxMenu WHERE JBoxMenu.cLaunch = JBoxUserSetting.cContext OUTER-JOIN NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwJBoxUserSetting JBoxUserSetting
&Scoped-define FIRST-TABLE-IN-QUERY-BrwJBoxUserSetting JBoxUserSetting


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbJBoxUserSetting filter_tbJBoxUserSetting ~
excel_tbJBoxUserSetting OpenProg_tbJBoxUserSetting BrwJBoxUserSetting 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbJBoxUserSetting 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.52 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbJBoxUserSetting 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON OpenProg_tbJBoxUserSetting 
     IMAGE-UP FILE "bmp\bullet_triangle_blue.bmp":U
     LABEL "Open program" 
     SIZE 6 BY 1.52 TOOLTIP "Open query program".

DEFINE RECTANGLE tbJBoxUserSetting
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 126 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwJBoxUserSetting FOR 
      JBoxUserSetting SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwJBoxUserSetting
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwJBoxUserSetting C-Win _STRUCTURED
  QUERY BrwJBoxUserSetting NO-LOCK DISPLAY
      JBoxUserSetting.cJBoxUserId COLUMN-LABEL "User id" FORMAT "x(30)":U
      JBoxUserSetting.cUserName COLUMN-LABEL "User name" FORMAT "X(40)":U
            WIDTH 20
      JBoxUserSetting.cSetting COLUMN-LABEL "Query name" FORMAT "x(50)":U
            WIDTH 30
      JBoxUserSetting.dCreated COLUMN-LABEL "Created" FORMAT "99/99/9999":U
      JBoxUserSetting.QuerySchedule COLUMN-LABEL "Schedule" FORMAT "X(80)":U
      JBoxUserSetting.cMenuLabel COLUMN-LABEL "Query program" FORMAT "x(40)":U
            WIDTH 20
      JBoxUserSetting.cContext COLUMN-LABEL "Query prog name" FORMAT "x(30)":U
      JBoxUserSetting.cSettingName COLUMN-LABEL "Setting name" FORMAT "x(30)":U
      JBoxUserSetting.cObjectName COLUMN-LABEL "Object name" FORMAT "x(30)":U
      JBoxUserSetting.cSourceFile COLUMN-LABEL "Source file" FORMAT "x(30)":U
      JBoxUserSetting.iJBoxUserSettingId COLUMN-LABEL "User setting id" FORMAT "->,>>>,>>9":U
  ENABLE
      JBoxUserSetting.cJBoxUserId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 124 BY 11.67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     filter_tbJBoxUserSetting AT ROW 1.33 COL 2.2 WIDGET-ID 4
     excel_tbJBoxUserSetting AT ROW 1.33 COL 8.2 WIDGET-ID 6
     OpenProg_tbJBoxUserSetting AT ROW 1.33 COL 14.4 WIDGET-ID 8
     BrwJBoxUserSetting AT ROW 3.14 COL 3 WIDGET-ID 200
     tbJBoxUserSetting AT ROW 1.24 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 128 BY 18.67 WIDGET-ID 100.


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
         HEIGHT             = 18.67
         WIDTH              = 128
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 128
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 128
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
/* BROWSE-TAB BrwJBoxUserSetting OpenProg_tbJBoxUserSetting DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 18.67
       FRAME DEFAULT-FRAME:WIDTH            = 128.

ASSIGN 
       JBoxUserSetting.cSettingName:VISIBLE IN BROWSE BrwJBoxUserSetting = FALSE.

ASSIGN 
       tbJBoxUserSetting:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "filter;Filter,excel;Eksporter til E&xcel,OpenProg;Open programmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwJBoxUserSetting
/* Query rebuild information for BROWSE BrwJBoxUserSetting
     _TblList          = "kif.JBoxUserSetting"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ",, OUTER"
     _FldNameList[1]   > JBoxUserSetting.cJBoxUserId
"JBoxUserSetting.cJBoxUserId" "User id" "x(30)" "character" ? ? ? ? ? ? yes "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > JBoxUserSetting.cUserName
"JBoxUserSetting.cUserName" "User name" "X(40)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > JBoxUserSetting.cSetting
"JBoxUserSetting.cSetting" "Query name" "x(50)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > JBoxUserSetting.dCreated
"JBoxUserSetting.dCreated" "Created" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"JBoxUserSetting.QuerySchedule" "Schedule" "X(80)" "CHARACTER" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > JBoxUserSetting.cMenuLabel
"JBoxUserSetting.cMenuLabel" "Query program" "x(40)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > JBoxUserSetting.cContext
"JBoxUserSetting.cContext" "Query prog name" "x(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > JBoxUserSetting.cSettingName
"JBoxUserSetting.cSettingName" "Setting name" "x(30)" "character" ? ? ? ? ? ? no "" no no "30" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > JBoxUserSetting.cObjectName
"JBoxUserSetting.cObjectName" "Object name" "x(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > JBoxUserSetting.cSourceFile
"JBoxUserSetting.cSourceFile" "Source file" "x(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > JBoxUserSetting.iJBoxUserSettingId
"JBoxUserSetting.iJBoxUserSettingId" "User setting id" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "13.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwJBoxUserSetting */
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


&Scoped-define BROWSE-NAME BrwJBoxUserSetting
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
{incl/conttrigg.i oBrwJBoxUserSetting:BROWSE-HANDLE}
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
  ENABLE tbJBoxUserSetting filter_tbJBoxUserSetting excel_tbJBoxUserSetting 
         OpenProg_tbJBoxUserSetting BrwJBoxUserSetting 
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

  oBrwJBoxUserSetting = NEW JBoxBrowse(brwJBoxUserSetting:HANDLE).

  oBrwJBoxUserSetting:baseQuery = "WHERE cJBoxUserId = cCreatedBy AND cObjectName = 'userquery'".
  otbJBoxUserSetting = NEW JBoxToolbar(tbJBoxUserSetting:HANDLE).

  oBrwJBoxUserSetting:TOOLBAR-OBJECT = otbJBoxUserSetting.
END.
oBrwJBoxUserSetting:OpenQuery().

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenProgRecord C-Win 
PROCEDURE OpenProgRecord :
  
DEF VAR hDataBrw AS HANDLE NO-UNDO.
   
hDataBrw = JBoxMainMenu:Instance:StartTabWindow(JBoxUserSetting.cContext,JBoxUserSetting.cMenuLabel, NO, YES).

DYNAMIC-FUNCTION("setBatchQueryId" IN hDataBrw,STRING(JBoxUserSetting.iJBoxUserSettingId)).

RUN StartUserQuery IN hDataBrw.

DYNAMIC-FUNCTION("setBatchQueryId" IN hDataBrw,"").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

