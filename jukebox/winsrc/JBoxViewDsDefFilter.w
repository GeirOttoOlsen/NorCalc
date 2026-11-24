&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
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
DEF VAR hParent     AS HANDLE NO-UNDO.

{incl/tt_viewds.i}

DEF VAR oBrwJboxUserSetting AS JBoxBrowse NO-UNDO.
DEF VAR oBrwJBoxUserSettingMnu AS JBoxPopupMenu NO-UNDO.

DEF VAR otbUseSetting AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brwJBoxUserSetting tbUseSetting ~
ScheduleQuery_tbUseSetting API_tbUseSetting activate_tbUseSetting 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RefreshBrowseRow C-Win
FUNCTION RefreshBrowseRow RETURNS LOGICAL 
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  ( INPUT ihParent AS HANDLE ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON activate_tbUseSetting 
     IMAGE-UP FILE "gif/active.gif":U
     LABEL "Activate" 
     SIZE 4.6 BY 1.1 TOOLTIP "Activate (ALT-A)".

DEFINE BUTTON API_tbUseSetting 
     IMAGE-UP FILE "newbmp\congloerate.bmp":U
     LABEL "API" 
     SIZE 4.6 BY 1.1 TOOLTIP "Generate api-parameters".

DEFINE BUTTON ScheduleQuery_tbUseSetting 
     IMAGE-UP FILE "gif/sessionconfig16.gif":U
     LABEL "Schedule" 
     SIZE 4.6 BY 1.1 TOOLTIP "Create script to start query".

DEFINE RECTANGLE brwJBoxUserSetting
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 8.81.

DEFINE RECTANGLE tbUseSetting
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 60.8 BY 1.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     ScheduleQuery_tbUseSetting AT ROW 1.33 COL 2.2 WIDGET-ID 8
     API_tbUseSetting AT ROW 1.33 COL 7 WIDGET-ID 10
     activate_tbUseSetting AT ROW 1.33 COL 11.6 WIDGET-ID 6
     brwJBoxUserSetting AT ROW 2.62 COL 2 WIDGET-ID 2
     tbUseSetting AT ROW 1.24 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 62.8 BY 10.67 WIDGET-ID 100.


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
         HEIGHT             = 10.71
         WIDTH              = 63.4
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
ASSIGN 
       tbUseSetting:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "ScheduleQuery;Schedule,API;API,activate;Activatehide".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
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
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateNewWinRecord C-Win
PROCEDURE activateNewWinRecord:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

IF NOT RefreshBrowseRow() THEN RETURN.

DYNAMIC-FUNCTION("activateNewWinWithFilter" IN hParent,oBrwJboxUserSetting:BUFFER-HANDLE::cSettingName).

END PROCEDURE.
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateRecord C-Win 
PROCEDURE activateRecord :

IF NOT RefreshBrowseRow() THEN RETURN.

DYNAMIC-FUNCTION("activateWithFilter" IN hParent,oBrwJboxUserSetting:BUFFER-HANDLE::cSettingName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE APIRecord C-Win 
PROCEDURE APIRecord :

IF NOT RefreshBrowseRow() THEN RETURN.

DYNAMIC-FUNCTION("getApiParams" IN oContainer:PARENT-CONTAINER-OBJECT:TABFOLDER-OBJECT:getPageHandle(1),oBrwJboxUserSetting:BUFFER-HANDLE::cSettingName,YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DefaultActionBrowse C-Win 
PROCEDURE DefaultActionBrowse :
IF NOT CAN-DO(otbUseSetting:disabledTools,"activate") THEN
  RUN activateRecord.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
otbUseSetting:disabledTools = 
          IF VALID-OBJECT(oBrwJboxUserSetting:PARENT-BROWSE-OBJECT) 
             AND oBrwJboxUserSetting:PARENT-BROWSE-OBJECT:BUFFER-HANDLE:AVAIL 
             AND oBrwJboxUserSetting:PARENT-BROWSE-OBJECT:BUFFER-HANDLE::ConnectionInfo NE "Connected" THEN 
            "activate,scheduleQuery"
          ELSE "".   
  RUN SUPER.
  IF oBrwJboxUserSetting:isCurrent THEN  DO WITH FRAME {&FRAME-NAME}:
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
  ENABLE brwJBoxUserSetting tbUseSetting ScheduleQuery_tbUseSetting 
         API_tbUseSetting activate_tbUseSetting 
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

DEF VAR hDsView AS HANDLE NO-UNDO.

hDsView = DYNAMIC-FUNCTION("getViewDsHandle" IN hParent).

DO WITH FRAME {&FRAME-NAME}:
  oBrwJBoxUserSetting = NEW JBoxBrowse(brwJBoxUserSetting:HANDLE,      /* handle to place-holder rectangle */
                        YES,                       /* multiple-select? */ 
                        "",                       /* title */
                        NO,                       /* row-markers (if multiple) */
                        hDsView:GET-BUFFER-HANDLE (4)).    /* The BUFFER ttCust.. parameter tells the browse that it is a local temp-table */

  brwJBoxUserSetting:HIDDEN = YES.

  oBrwJBoxUserSetting:buffersAndFields = "ttJBoxUserSetting;cSetting|Filter".
  oBrwJBoxUserSetting:setQuerySort("cSettingName").
  oBrwJboxUserSetting:setFilter("cObjectName = 'userquery'").
  otbUseSetting = NEW JBoxToolbar(tbUseSetting:HANDLE).

  oBrwJboxUserSetting:TOOLBAR-OBJECT = otbUseSetting.
  
  oBrwJBoxUserSettingMnu = NEW JBoxPopupMenu().
  oBrwJBoxUserSettingMnu:addTool("activateNewWin", "Activate (run) in separate window"). 

  oBrwJboxUserSetting:POPUP-MENU-OBJECT = oBrwJBoxUserSettingMnu.
  
END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ScheduleQueryRecord C-Win 
PROCEDURE ScheduleQueryRecord :

IF NOT RefreshBrowseRow() THEN RETURN.

ASSIGN oBrwJboxUserSetting:BUFFER-HANDLE::ScriptFilterName = oBrwJboxUserSetting:BUFFER-HANDLE::cSetting
       oBrwJboxUserSetting:BUFFER-HANDLE::ScriptFilterID = oBrwJboxUserSetting:BUFFER-HANDLE::cSettingName.
  
DYNAMIC-FUNCTION("scheduleWithFilter" IN hParent).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RefreshBrowseRow C-Win
FUNCTION RefreshBrowseRow RETURNS LOGICAL 
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cSetting AS CHAR NO-UNDO.

IF NOT oBrwJboxUserSetting:BUFFER-HANDLE:AVAIL THEN DO:
  cSetting = oBrwJboxUserSetting:BROWSE-HANDLE:GET-BROWSE-COLUMN(1):SCREEN-VALUE.
  oBrwJboxUserSetting:OpenQuery().
  oBrwJboxUserSetting:BUFFER-HANDLE:FIND-FIRST("WHERE cSetting = '" + cSetting + "'") NO-ERROR.
  IF oBrwJboxUserSetting:BUFFER-HANDLE:AVAIL THEN 
    oBrwJboxUserSetting:QUERY-HANDLE:REPOSITION-TO-ROWID (oBrwJboxUserSetting:BUFFER-HANDLE:ROWID).
  ELSE RETURN NO.
END.
RETURN YES.

END FUNCTION.
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  ( INPUT ihParent AS HANDLE ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  hParent = ihParent.

  RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

