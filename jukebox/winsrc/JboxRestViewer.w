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
DEF VAR bOk          AS LOG    NO-UNDO.
DEF VAR hBrowse      AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer   AS JBoxContainer NO-UNDO.


{incl/tt_cloudapp.i}
hdsCloudApp = DATASET dsCloudApp:HANDLE.

DEF VAR hJsonViewer  AS HANDLE NO-UNDO.

DEF VAR oBrwCloudApp AS JBoxBrowse   NO-UNDO.
DEF VAR oFmCloudApp  AS JBoxFieldMap NO-UNDO.


DEF VAR otbCloudApp AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnbaseEndpoint brwCloudApp tbCloudApp ~
new_tbCloudApp edit_tbCloudApp copy_tbCloudApp undo_tbCloudApp ~
save_tbCloudApp delete_tbCloudApp tbAutoSave appName baseEndpoint baseTable 
&Scoped-Define DISPLAYED-OBJECTS tbAutoSave appName baseEndpoint baseTable 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD unWrapEndpoint C-Win 
FUNCTION unWrapEndpoint RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnbaseEndpoint 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON copy_tbCloudApp 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 4.6 BY 1.1 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbCloudApp 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 4.6 BY 1.1 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON edit_tbCloudApp 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 4.6 BY 1.1 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON new_tbCloudApp 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 4.6 BY 1.1 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbCloudApp 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbCloudApp 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE baseTable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Base table" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 34.8 BY 1 NO-UNDO.

DEFINE VARIABLE appName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Name" 
     VIEW-AS FILL-IN 
     SIZE 20.4 BY 1 NO-UNDO.

DEFINE VARIABLE baseEndpoint AS CHARACTER FORMAT "X(256)":U 
     LABEL "Endpoint" 
     VIEW-AS FILL-IN 
     SIZE 44.8 BY 1 TOOLTIP "Endpoint definition file" NO-UNDO.

DEFINE RECTANGLE brwCloudApp
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 132.8 BY 5.91.

DEFINE RECTANGLE tbCloudApp
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 132.8 BY 1.29.

DEFINE VARIABLE tbAutoSave AS LOGICAL INITIAL no 
     LABEL "Auto-save" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 TOOLTIP "Replaces app-definition file after major changes (new tables..)" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnbaseEndpoint AT ROW 8.86 COL 84 WIDGET-ID 54 NO-TAB-STOP 
     new_tbCloudApp AT ROW 1.33 COL 2.4 WIDGET-ID 60
     edit_tbCloudApp AT ROW 1.33 COL 7 WIDGET-ID 62
     copy_tbCloudApp AT ROW 1.33 COL 11.8 WIDGET-ID 64
     undo_tbCloudApp AT ROW 1.33 COL 16.4 WIDGET-ID 66
     save_tbCloudApp AT ROW 1.33 COL 21.2 WIDGET-ID 68
     delete_tbCloudApp AT ROW 1.33 COL 25.8 WIDGET-ID 70
     tbAutoSave AT ROW 1.48 COL 120.4 WIDGET-ID 48
     appName AT ROW 8.86 COL 6.8 COLON-ALIGNED
     baseEndpoint AT ROW 8.86 COL 37.2 COLON-ALIGNED
     baseTable AT ROW 8.86 COL 97.6 COLON-ALIGNED WIDGET-ID 56
     brwCloudApp AT ROW 2.71 COL 1.8 WIDGET-ID 2
     tbCloudApp AT ROW 1.24 COL 2.2 WIDGET-ID 58
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 134.6 BY 20.19 WIDGET-ID 100.


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
         HEIGHT             = 20.19
         WIDTH              = 134.6
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 134.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 134.6
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
       FRAME DEFAULT-FRAME:HEIGHT           = 20.19
       FRAME DEFAULT-FRAME:WIDTH            = 134.6.

ASSIGN 
       tbCloudApp:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,copy;Kopier,undo;Angre,save;Lagre,delete;Slettmaxborder".

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


&Scoped-define SELF-NAME btnbaseEndpoint
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnbaseEndpoint C-Win
ON CHOOSE OF btnbaseEndpoint IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = baseEndpoint:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cUseFileName USE-FILENAME UPDATE bOk.
  IF bOk THEN DO:
    baseEndpoint:SCREEN-VALUE = cUseFileName.
    unWrapEndpoint().
  END.    

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
  APPLY "close" TO hJsonViewer.
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
  DISPLAY tbAutoSave appName baseEndpoint baseTable 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnbaseEndpoint brwCloudApp tbCloudApp new_tbCloudApp edit_tbCloudApp 
         copy_tbCloudApp undo_tbCloudApp save_tbCloudApp delete_tbCloudApp 
         tbAutoSave appName baseEndpoint baseTable 
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
  RUN JBoxJsonViewer.w PERSIST SET hJsonViewer.
  
  oBrwCloudApp = NEW JBoxBrowse(brwCloudApp:HANDLE,      /* handle to place-holder rectangle */
                         NO,                       /* multiple-select? */ 
                         "",                       /* title */
                         NO,                       /* row-markers (if multiple) */
                         BUFFER ttCloudApp:HANDLE).    /* The BUFFER ttCust.. parameter tells the browse that it is a local temp-table */
  
  oBrwCloudApp:buffersAndFields = "ttCloudApp;appName;baseEndpoint;baseTable;tokenEndpoint;ConnectionInfo;appDescription;cloudAppFileName".
  oBrwCloudApp:BROWSE-HANDLE:GET-BROWSE-COLUMN(7):VISIBLE = NO.
  oBrwCloudApp:setQuerySort("appName").
    
  oFmCloudApp = NEW JBoxFieldMap (FRAME {&FRAME-NAME}:HANDLE).
  oFmCloudApp:updateFields = "appName,baseEndpoint,baseTable".
  
  oFmCloudApp:BROWSE-OBJECT = oBrwCloudApp.
    
  otbCloudApp = NEW JBoxToolbar(tbCloudApp:HANDLE).

  oBrwCloudApp:TOOLBAR-OBJECT = otbCloudApp.
  oFmCloudApp:TOOLBAR-OBJECT = otbCloudApp.
  
  oBrwCloudApp:openQuery().
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize(400,100).
  oContainer:setAddResizeX("baseEndpoint").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION unWrapEndpoint C-Win 
FUNCTION unWrapEndpoint RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR oEndPointParser AS JBoxJsonParser NO-UNDO.
DEF VAR lcFile AS LONGCHAR NO-UNDO.

FIX-CODEPAGE(lcFile) = "UTF-8".

DO WITH FRAME {&FRAME-NAME}:
  IF SEARCH(baseEndpoint:SCREEN-VALUE) NE ? THEN DO:
    COPY-LOB FROM file SEARCH(baseEndpoint:SCREEN-VALUE) TO lcFile.
    oEndPointParser = NEW JBoxJsonParser().
    oEndPointParser:createSchema(lcFile,"baseEndpoint").
    baseTable:LIST-ITEMS = oEndPointParser:getTableList().
  END.  
  ELSE RETURN NO.
  RETURN YES.
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

