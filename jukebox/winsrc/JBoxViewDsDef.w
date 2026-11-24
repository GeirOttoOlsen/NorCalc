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
 &SCOPED-DEFINE AdvGuiWin
DYNAMIC-FUNCTION("setAttribute",SESSION,"UseAdvGui","yes") NO-ERROR.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer  AS JBoxContainer NO-UNDO.
    
DEF VAR oBrwViewDs AS JBoxBrowse NO-UNDO.
DEF VAR oFmViews  AS JBoxFieldMap NO-UNDO.

DEF VAR otbViews AS JBoxToolbar NO-UNDO.

DEF VAR oJBoxMsTreeView     AS uc.JBoxMsTreeView NO-UNDO.
DEF VAR cFirstTable         AS CHAR NO-UNDO.
DEF VAR cViewJsonFile       AS CHAR NO-UNDO.
DEF VAR iFakeBaseTableId    AS INT NO-UNDO INIT 9999.
DEF VAR iOrgFrameWidth      AS INT NO-UNDO. // needed to resize fiFileName correctly since it is a text widget..
DEF VAR iOrgFiFileNameWidth AS INT NO-UNDO. // needed to resize fiFileName correctly since it is a text widget..
DEF VAR bStoreViewDefInDb   AS LOG NO-UNDO.
DEF VAR cRunQueryId         AS CHAR NO-UNDO. // used to activate a stored query filter
DEF VAR hScriptDefView      AS HANDLE NO-UNDO.
DEF VAR hScriptDefFilter    AS HANDLE NO-UNDO.
DEF VAR hProgBar            AS HANDLE NO-UNDO.
DEF VAR bInit               AS LOG NO-UNDO.
DEF VAR iInitCnt            AS INT NO-UNDO.

&IF DEFINED(UIB_is_Running) NE 0 &THEN
  {tt_schema.i "NEW SHARED"}
&ELSE
  {tt_schema.i SHARED}
&ENDIF
  
hdsSchema = DATASET dsSchema:HANDLE.

{incl/tt_viewds.i}
hdsViewDs = DATASET dsViewDs:HANDLE.

DEF VAR httViewDs AS HANDLE NO-UNDO.
httViewDs = BUFFER ttViewDs:HANDLE.

DEF VAR oTabViews AS JBoxMsTabs NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brwViewDs btnSplitBarY tbViews ~
TreeViewBaseTable TabViews LoadViews_tbViews SaveViews_tbViews new_tbViews ~
edit_tbViews undo_tbViews save_tbViews delete_tbViews scheduleQuery_tbViews ~
API_tbViews activate_tbViews tbAutoSave ViewDsName BaseTableId ViewDsDesc ~
fiFileName 
&Scoped-Define DISPLAYED-OBJECTS tbAutoSave ViewDsName BaseTableId ~
ViewDsDesc fiFileName 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD activateNewWinWithFilter C-Win 
FUNCTION activateNewWinWithFilter RETURNS LOGICAL
  ( INPUT icQueryId AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD activateWithFilter C-Win 
FUNCTION activateWithFilter RETURNS LOGICAL
  ( INPUT icQueryId AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD applySelectedTreeNode C-Win 
FUNCTION applySelectedTreeNode RETURNS LOGICAL
  ( INPUT icNodeName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CreTestData C-Win 
FUNCTION CreTestData RETURNS LOGICAL() FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FillTreeDropDown C-Win 
FUNCTION FillTreeDropDown RETURNS LOGICAL ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSchemaStatus C-Win 
FUNCTION getSchemaStatus RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewDsHandle C-Win 
FUNCTION getViewDsHandle RETURNS HANDLE
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD scheduleWithFilter C-Win 
FUNCTION scheduleWithFilter RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoSave C-Win 
FUNCTION setAutoSave RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBaseTableId C-Win 
FUNCTION setBaseTableId RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ViewTree C-Win 
FUNCTION ViewTree RETURNS LOGICAL ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON activate_tbViews 
     IMAGE-UP FILE "gif/active.gif":U
     LABEL "Activate" 
     SIZE 4.6 BY 1.1 TOOLTIP "Activate".

DEFINE BUTTON API_tbViews 
     IMAGE-UP FILE "newbmp\congloerate.bmp":U
     LABEL "API" 
     SIZE 4.6 BY 1.1 TOOLTIP "Generate API parameters".

DEFINE BUTTON btnSplitBarY  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 136.8 BY .43.

DEFINE BUTTON delete_tbViews 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 4.6 BY 1.1 TOOLTIP "Delete".

DEFINE BUTTON edit_tbViews 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 4.6 BY 1.1 TOOLTIP "Edit".

DEFINE BUTTON LoadViews_tbViews 
     IMAGE-UP FILE "gif\folderopen.gif":U
     LABEL "Load view definitions" 
     SIZE 4.6 BY 1.1 TOOLTIP "Load view definitions from json file".

DEFINE BUTTON new_tbViews 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 4.6 BY 1.1 TOOLTIP "New".

DEFINE BUTTON SaveViews_tbViews 
     IMAGE-UP FILE "gif\folder.gif":U
     LABEL "Save view definitions" 
     SIZE 4.6 BY 1.1.

DEFINE BUTTON save_tbViews 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 4.6 BY 1.1 TOOLTIP "Save".

DEFINE BUTTON scheduleQuery_tbViews 
     IMAGE-UP FILE "gif\sessionconfig16.gif":U
     LABEL "Schedule" 
     SIZE 4.6 BY 1.1 TOOLTIP "Create script for scheduler".

DEFINE BUTTON undo_tbViews 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 4.6 BY 1.1 TOOLTIP "Undo".

DEFINE VARIABLE BaseTableId AS CHARACTER 
     LABEL "Base table" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN
     SIZE 45 BY 1.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 71 BY .62 NO-UNDO.

DEFINE VARIABLE ViewDsDesc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Desc" 
     VIEW-AS FILL-IN 
     SIZE 36.2 BY 1 NO-UNDO.

DEFINE VARIABLE ViewDsName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Name" 
     VIEW-AS FILL-IN 
     SIZE 26 BY 1 NO-UNDO.

DEFINE RECTANGLE brwViewDs
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 135 BY 6.86.

DEFINE RECTANGLE TabViews
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 135 BY 12.

DEFINE RECTANGLE tbViews
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 134.8 BY 1.29.

DEFINE RECTANGLE TreeViewBaseTable
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 10.33.

DEFINE VARIABLE tbAutoSave AS LOGICAL INITIAL no 
     LABEL "Auto-save" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 TOOLTIP "Replaces view-definition file after major changes (new tables..)" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnSplitBarY AT ROW 9.71 COL 1 WIDGET-ID 6
     LoadViews_tbViews AT ROW 1.38 COL 2.2 WIDGET-ID 26
     SaveViews_tbViews AT ROW 1.38 COL 7 WIDGET-ID 44
     new_tbViews AT ROW 1.38 COL 11.6 WIDGET-ID 8
     edit_tbViews AT ROW 1.38 COL 16.2 WIDGET-ID 10
     undo_tbViews AT ROW 1.38 COL 20.8 WIDGET-ID 14
     save_tbViews AT ROW 1.38 COL 25.4 WIDGET-ID 16
     delete_tbViews AT ROW 1.38 COL 30 WIDGET-ID 18
     scheduleQuery_tbViews AT ROW 1.38 COL 34.6 WIDGET-ID 46
     API_tbViews AT ROW 1.38 COL 39.2 WIDGET-ID 50
     activate_tbViews AT ROW 1.38 COL 43.8 WIDGET-ID 24
     tbAutoSave AT ROW 1.48 COL 122 WIDGET-ID 48
     ViewDsName AT ROW 10.38 COL 7.4 COLON-ALIGNED
     BaseTableId AT ROW 10.38 COL 45.4 COLON-ALIGNED WIDGET-ID 38
     ViewDsDesc AT ROW 10.38 COL 98.8 COLON-ALIGNED
     fiFileName AT ROW 1.62 COL 47.6 COLON-ALIGNED NO-LABEL
     brwViewDs AT ROW 2.71 COL 2 WIDGET-ID 2
     tbViews AT ROW 1.29 COL 2 WIDGET-ID 4
     TreeViewBaseTable AT ROW 11.38 COL 47.4 WIDGET-ID 40
     TabViews AT ROW 11.62 COL 2 WIDGET-ID 42
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 136.8 BY 22.86 WIDGET-ID 100.


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
         TITLE              = "View definitions"
         HEIGHT             = 22.86
         WIDTH              = 136.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 136.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 136.8
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
       FRAME DEFAULT-FRAME:HEIGHT           = 22.86
       FRAME DEFAULT-FRAME:WIDTH            = 136.8.

ASSIGN 
       btnSplitBarY:MOVABLE IN FRAME DEFAULT-FRAME          = TRUE.

ASSIGN 
       tbViews:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "LoadViews|File;Load view definitions¤enable,SaveViews|File;Save view definitions,SaveViewsAs|File;Save view definitions as..¤menu,new|File;New,edit|File;Edit,undo|File;Undo,save|File;Save,delete|File;Delete,scheduleQuery|File;Schedule,API|File;API,activate|File;Activate,connectDataSource|File;Connect data source¤menuenableFilehide".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* View definitions */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* View definitions */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BaseTableId
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BaseTableId C-Win
ON CURSOR-DOWN OF BaseTableId IN FRAME DEFAULT-FRAME /* Base table */
DO:
  ViewTree().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BaseTableId C-Win
ON MOUSE-SELECT-DOWN OF BaseTableId IN FRAME DEFAULT-FRAME /* Base table */
DO:
  ViewTree().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSplitBarY
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarY C-Win
ON END-MOVE OF btnSplitBarY IN FRAME DEFAULT-FRAME
DO:
  JBoxSession:Instance:setJBoxAttribute("userkeepswindowlocked","yes").
  DYNAMIC-FUNCTION("setSplitBarY",THIS-PROCEDURE:CURRENT-WINDOW,btnSplitBarY:HANDLE IN FRAME {&FRAME-NAME},NO).
  BaseTableId:CLEAR-SELECTION() IN FRAME {&FRAME-NAME}.
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

ON "WINDOW-RESIZED" OF {&WINDOW-NAME} DO:
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",THIS-PROCEDURE:CURRENT-WINDOW) NO-ERROR.
  DYNAMIC-FUNCTION("setWidgetResize",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE:CURRENT-WINDOW,"resize","").
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",?) NO-ERROR.
  BaseTableId:CLEAR-SELECTION() IN FRAME {&FRAME-NAME}.
  fiFileName:WIDTH-PIXELS = iOrgFiFileNameWidth + FRAME {&FRAME-NAME}:WIDTH-PIXELS - iOrgFrameWidth.
END.


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
//    creTestData().
//    JBoxSession:Instance:setJBoxAttribute("SqlDbList","VismaSQL|TESTMedlemsregnskapGLOBALData|mssql,RapportSQL|Rapport|ProgressSql").
//    JBoxSession:Instance:setJBoxAttribute("SqlDbList","RapportSQL|Rapport|ProgressSql").
  
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
PROCEDURE activateNewWinRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF BUFFER bttViewDs FOR ttViewDs.
DEF VAR ix AS INT NO-UNDO.

FOR EACH bttViewDs BREAK BY bttViewDs.SourceName:
  IF FIRST-OF(bttViewDs.SourceName) THEN ix = ix + 1.
END.

oBrwViewDs:BROWSE-HANDLE:SELECT-FOCUSED-ROW().
  
oContainer:StartChildWindow("JboxDataBrw.w",
                                          (IF ix > 1 THEN ttViewDs.SourceName + ", " ELSE "") + ttViewDs.ViewDsName
                                          ,YES).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE activateRecord C-Win 
PROCEDURE activateRecord :
DEF VAR hStartDataBrw AS HANDLE NO-UNDO.

DEF BUFFER bttViewDs FOR ttViewDs.
DEF VAR ix AS INT NO-UNDO.

FOR EACH bttViewDs BREAK BY bttViewDs.SourceName:
  IF FIRST-OF(bttViewDs.SourceName) THEN ix = ix + 1.
END.

oBrwViewDs:BROWSE-HANDLE:SELECT-FOCUSED-ROW().
  
hStartDataBrw = oContainer:StartTabWindow("JboxDataBrw.w",
                                          (IF ix > 1 THEN ttViewDs.SourceName + ", " ELSE "") + ttViewDs.ViewDsName
                                          ,YES,NO).
/* Initialization in procedure myDatabrowseObject */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE APIRecord C-Win 
PROCEDURE APIRecord :
DYNAMIC-FUNCTION("getApiParams" IN oTabViews:getPageHandle(1),"",YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectDataSourceRecord C-Win 
PROCEDURE connectDataSourceRecord :
DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  SYSTEM-DIALOG GET-FILE cUseFileName FILTERS "json" "*.json", "All files" "*.*" USE-FILENAME UPDATE bOk.
  IF bOk THEN DO:
    IF JBoxSchemaCache:Instance:getDbSchema(?,cUseFileName) THEN DO:
      getSchemaStatus().
      FillTreeDropDown().
//      RUN "RefreshSchemaDataSet" IN oTabViews:getPageHandle(1) (hDsSchema).
      oBrwViewDs:openQuery(). 
    END.  
    ELSE MESSAGE JBoxSchemaCache:Instance:SchemaMessage
         VIEW-AS ALERT-BOX.
  END.  
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DefaultActionBrowse C-Win 
PROCEDURE DefaultActionBrowse :
IF NOT CAN-DO(otbViews:disabledTools,"activate") THEN
  RUN activateRecord.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteRecord C-Win 
PROCEDURE DeleteRecord :
DEF VAR cViewId AS CHAR NO-UNDO.
  cViewId = ttViewDs.ViewDsId.  
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
    RUN DeleteView IN oTabViews:getPageHandle(1) (cViewId).
    getSchemaStatus().
  END.

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
DEF VAR cDisableRun AS CHAR NO-UNDO.
  DEF VAR cDisableNew AS CHAR NO-UNDO.
  IF oBrwViewDs:isCurrent THEN DO WITH FRAME {&FRAME-NAME}:
    cDisableRun = IF AVAIL ttViewDs AND ttViewDs.ConnectionInfo NE "Connected" THEN "Activate,scheduleQuery" ELSE "".
//    cDisableNew = IF NUM-ENTRIES(fiFileName:SCREEN-VALUE) > 1 THEN "new" ELSE "". 
    otbViews:disabledTools = TRIM(cDisableRun + "," + cDisableNew,",").
    IF AVAIL ttViewDs AND LOOKUP(ttViewDs.BaseTableId,BaseTableId:LIST-ITEM-PAIRS,"|") = 0 THEN 
      BaseTableId:ADD-LAST (ttViewDs.BaseTable,ttViewDs.BaseTableId).
  END.
  RUN SUPER.
  IF oBrwViewDs:isCurrent THEN  DO WITH FRAME {&FRAME-NAME}:
    oFmViews:disabledFields = "".
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DropFileNotifyBrowse C-Win 
PROCEDURE DropFileNotifyBrowse :
DEF VAR ix AS INT NO-UNDO.
  DEF VAR oParser AS JBoxJsonParser NO-UNDO.
  DEF VAR lcFile AS LONGCHAR NO-UNDO.
  DEF VAR hDsView AS HANDLE NO-UNDO.
  DEF VAR cExistList AS CHAR NO-UNDO.
  DEF VAR cFileExistList AS CHAR NO-UNDO.

  FIX-CODEPAGE(lcFile) = "utf-8".
  
  COPY-LOB FROM FILE oBrwViewDs:BROWSE-HANDLE:GET-DROPPED-FILE(1) TO lcFile.
  
  oParser = NEW JBoxJsonParser().
  IF oParser:createSchema(lcFile,"test") THEN DO:
    IF oParser:getResultFirstFieldValue("JBoxDataSource","SourceHost") NE ? THEN DO: 
      DO ix = 1 TO oBrwViewDs:BROWSE-HANDLE:NUM-DROPPED-FILES:
        IF JBoxSchemaCache:Instance:getDbSchema(hDsSchema,oBrwViewDs:BROWSE-HANDLE:GET-DROPPED-FILE(ix)) THEN 
          getSchemaStatus().
      END.
      FillTreeDropDown().
//      RUN "RefreshSchemaDataSet" IN oTabViews:getPageHandle(1) (hDsSchema).
      oBrwViewDs:openQuery().
    END.
    ELSE IF oParser:getResultFirstFieldValue("ttViewDs","ViewDsName") NE ? THEN DO: 
      hDsView = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).
      hDsView:EMPTY-DATASET().
      EMPTY TEMP-TABLE ttViewDs.
      DO ix = 1 TO oBrwViewDs:BROWSE-HANDLE:NUM-DROPPED-FILES:
        hDsView:READ-JSON ("file",oBrwViewDs:BROWSE-HANDLE:GET-DROPPED-FILE(ix)).
        cExistList = "".                        
        FOR EACH ttViewDs:
          ASSIGN cExistList = cExistList + (IF cExistList NE "" THEN "," ELSE "") + ttViewDs.ViewDsId
                 cFileExistList = cFileExistList + (IF cFileExistList NE "" THEN "," ELSE "") + ttViewDs.ViewFileName.
        END.   
        EMPTY TEMP-TABLE ttViewDs.
        BUFFER ttViewDs:COPY-TEMP-TABLE(hDsView:GET-BUFFER-HANDLE (1),NO,NO,YES).
        FOR EACH ttViewDs: 
          IF CAN-DO(cExistList,ttViewDs.ViewDsId) THEN
            ttViewDs.ViewFileName = ENTRY(LOOKUP(ttViewDs.ViewDsId,cExistList),cFileExistList).
          ELSE 
            ttViewDs.ViewFileName = oBrwViewDs:BROWSE-HANDLE:GET-DROPPED-FILE(ix).
          FOR EACH ttViewDsTable
              WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
                AND ttViewDsTable.SourceName = ""
              :
            ASSIGN ttViewDsTable.SourceName = ttViewDs.SourceName
                   ttViewDsTable.SourceType = ttViewDs.SourceType
                   .    
          END.        
        END.
      END.
      getSchemaStatus().
      setBaseTableId().
      oBrwViewDs:openQuery().
    END.
    ELSE MESSAGE "Invalid file type (must be either connection file or view-definitions)"
                 VIEW-AS ALERT-BOX.
  END.                 
  ELSE MESSAGE "Invalid file type (must be a json file - either connection file or view-definitions)"
                VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
oFmViews:disabledFields = "BaseTableId".
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
  DISPLAY tbAutoSave ViewDsName BaseTableId ViewDsDesc fiFileName 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE brwViewDs btnSplitBarY tbViews TreeViewBaseTable TabViews 
         LoadViews_tbViews SaveViews_tbViews new_tbViews edit_tbViews 
         undo_tbViews save_tbViews delete_tbViews scheduleQuery_tbViews 
         API_tbViews activate_tbViews tbAutoSave ViewDsName BaseTableId 
         ViewDsDesc fiFileName 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genApiParams C-Win 
PROCEDURE genApiParams :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icObjectName AS CHAR NO-UNDO. // query id
DEF INPUT PARAM ibView       AS LOG  NO-UNDO.

/*
DEF VAR cQuerySort    AS CHAR NO-UNDO.
DEF VAR cFilterFields AS CHAR NO-UNDO.
DEF VAR cGroupDef     AS CHAR NO-UNDO.
DEF VAR iGroupCnt     AS INT  NO-UNDO.
DEF VAR iSubSeqCnt    AS INT  NO-UNDO.

DEF BUFFER bttSetting FOR ttJBoxUserSetting.

EMPTY TEMP-TABLE ttAPIparams.
EMPTY TEMP-TABLE ttAPIfieldGroup.

CREATE ttAPIparams.
ASSIGN ttAPIparams.buffersAndFields = DYNAMIC-FUNCTION("getBuffersAndFields" IN oTabViews:getPageHandle(1))
       ttAPIparams.queryJoin        = DYNAMIC-FUNCTION("getQueryJoin" IN oTabViews:getPageHandle(1),"","")
       .

run toexcelviafile.p (hdsViewDs:GET-BUFFER-HANDLE (4),-2).
MESSAGE 
VIEW-AS ALERT-BOX.
FOR EACH ttJBoxUserSetting
    WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
      AND ttJBoxUserSetting.cObjectName = icObjectName
      AND ttJBoxUserSetting.cSetting NE "" 
      AND ttJBoxUserSetting.cSetting NE ?
    BY ttJBoxUserSetting.cSettingName   
    :
  CASE ttJBoxUserSetting.cSettingName:
    WHEN "1stSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting. 
    WHEN "1stSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
    WHEN "2ndSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + "," + ttJBoxUserSetting.cSetting. 
    WHEN "2ndSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
    WHEN "3rdSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + "," + ttJBoxUserSetting.cSetting. 
    WHEN "3rdSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
    WHEN "4thSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + "," + ttJBoxUserSetting.cSetting. 
    WHEN "4thSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
  END.
  IF NUM-ENTRIES(ttJBoxUserSetting.cObjectName,"_") > 1 THEN 
    CASE SUBSTR(ttJBoxUserSetting.cObjectName,1,11):
      WHEN "FieldGroup_" THEN DO:
        CREATE ttAPIfieldGroup.
        ASSIGN ttAPIfieldGroup.fieldGroup = cSetting
               ttAPIfieldGroup.groupField = SUBSTR(ttJBoxUserSetting.cObjectName,12)
               ttAPIfieldGroup.fieldName  = IF CAN-DO("1,2,3,4,5,6,7,8,9",SUBSTR(ttAPIfieldGroup.groupField,1,1))
                                               AND SUBSTR(ttAPIfieldGroup.groupField,2,1) = "_" THEN
                                              SUBSTR(ttAPIfieldGroup.groupField,3)
                                            ELSE ttAPIfieldGroup.groupField.  
               .  
      END.  
    END CASE.
END.

ttAPIparams.querySort = cQuerySort.

FOR EACH ttAPIfieldGroup:
  FIND FIRST ttJBoxUserSetting
       WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
         AND ttJBoxUserSetting.cObjectName = icObjectName
         AND ttJBoxUserSetting.cSettingName = "FieldOperator_" + ttAPIfieldGroup.groupField // AND / OR
         .
  iSubSeqCnt = iSubSeqCnt + 1.
         
  ASSIGN ttAPIfieldGroup.groupFieldOper = ttJBoxUserSetting.cSetting
         ttAPIfieldGroup.iSeq = 1
         ttAPIfieldGroup.iSubSeq = iSubSeqCnt.                 

  FIND FIRST ttJBoxUserSetting
       WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
         AND ttJBoxUserSetting.cObjectName = icObjectName
         AND ttJBoxUserSetting.cSettingName = "OperatorInUse_" + ttAPIfieldGroup.groupField // = / <>..
         NO-ERROR.
  IF AVAIL ttJBoxUserSetting THEN       
    ASSIGN ttAPIfieldGroup.groupFieldOperInUse = ttJBoxUserSetting.cSetting
           ttAPIfieldGroup.iSeq = 2
           ttAPIfieldGroup.iSubSeq = iSubSeqCnt.                 

  FIND FIRST ttJBoxUserSetting
       WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
         AND ttJBoxUserSetting.cObjectName = icObjectName
         AND ttJBoxUserSetting.cSettingName = "filtervalue_" + ttAPIfieldGroup.groupField
         NO-ERROR.
  IF AVAIL ttJBoxUserSetting THEN       
    ASSIGN ttAPIfieldGroup.groupFieldValue = ttJBoxUserSetting.cSetting
           ttAPIfieldGroup.iSeq = 3
           ttAPIfieldGroup.iSubSeq = iSubSeqCnt.                 
END.

DO iGroupCnt = 1 TO 9:
  cGroupDef = "".
  FOR EACH ttAPIfieldGroup
      WHERE ttAPIfieldGroup.fieldGroup = STRING(iGroupCnt)
        AND ttAPIfieldGroup.iSeq = 1 // field names with field operators (and/or)
      BY ttAPIfieldGroup.iSubSeq:
    IF cGroupDef = "" THEN DO:
      FIND FIRST ttJBoxUserSetting
           WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
             AND ttJBoxUserSetting.cObjectName = icObjectName
             AND ttJBoxUserSetting.cSettingName = "FieldGroup_" + ttAPIfieldGroup.fieldName
           .
      cGroupDef = ttJBoxUserSetting.cSetting + "(" + ttAPIfieldGroup.fieldName.     
    END.
    ELSE
      cGroupDef = cGroupDef + "," + ttAPIfieldGroup.groupFieldOper + " " + ttAPIfieldGroup.fieldName.
  END.          
  cGroupDef = cGroupDef + ";".
  FOR EACH ttAPIfieldGroup
      WHERE ttAPIfieldGroup.fieldGroup = STRING(iGroupCnt)
        AND ttAPIfieldGroup.iSeq = 2 // operators in use (=,<>..
      BY ttAPIfieldGroup.iSubSeq:
    cGroupDef = cGroupDef + ";" + ttAPIfieldGroup.groupFieldOperInUse.
  END.          
  cGroupDef = cGroupDef + ";".
  FOR EACH ttAPIfieldGroup
      WHERE ttAPIfieldGroup.fieldGroup = STRING(iGroupCnt)
        AND ttAPIfieldGroup.iSeq = 3 // filter values
      BY ttAPIfieldGroup.iSubSeq:
    cGroupDef = cGroupDef + "|" + ttAPIfieldGroup.groupFieldValue.
  END.          
  IF cGroupDef NE "" THEN
    BUFFER ttAPIparams:BUFFER-FIELD("queryFilterGroup" + STRING(iGroupCnt)):BUFFER-VALUE = cGroupDef.
  ELSE  
    BUFFER ttAPIparams:BUFFER-FIELD("queryFilterGroup" + STRING(iGroupCnt)):SERIALIZE-HIDDEN = YES.
END.

BUFFER ttAPIparams:WRITE-JSON ("file","c:\temp\apiparam.json",yes).
os-command no-wait value("notepad c:\temp\apiparam.json").

/*
  cGroupList = mgetAttribute(ihQueryObject,"filterGroup_operator").
  DO ix = 1 TO NUM-ENTRIES(cGroupList):
    cGroup = ENTRY(1,ENTRY(ix,cGroupList),"|").
    cGroupDef = cGroupDef + (IF cGroupDef NE "" THEN "¤" ELSE "") + ENTRY(2,ENTRY(ix,cGroupList),"|").
              
    cFieldsInGroup = mgetAttribute(ihQueryObject,"filterGroup_" + cGroup + "_FieldName").
    DO iy = 1 TO NUM-ENTRIES(cFieldsInGroup):
      iFieldInstCnt = INT(getAttribute(ihQueryObject, "filterGroup_" + cGroup + "_FieldCnt_" + ENTRY(iy,cFieldsInGroup))).
      DO iz = 1 TO MAX(1,iFieldInstCnt):
        cGroupDef = cGroupDef
                  + "|" + getAttribute(ihQueryObject,"filterGroup_" + cGroup + "_FieldOperator_" + ENTRY(iy,cFieldsInGroup) + "_" + STRING(iz))
                  + "|" + ENTRY(iy,cFieldsInGroup) 
                  + "|" + getAttribute(ihQueryObject,"filterGroup_" + cGroup + "_Operator_" + ENTRY(iy,cFieldsInGroup) + "_" + STRING(iz)) 
                  + "|" + getAttribute(ihQueryObject,"filterGroup_" + cGroup + "_Value_" + ENTRY(iy,cFieldsInGroup) + "_" + STRING(iz))
                  .
      END.             
    END.            
  END.             
*/    
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Refer to the <jukebox>\wingsrc\samples for working examples for Sports2000
------------------------------------------------------------------------------*/
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DEF VAR cSqlDbList AS CHAR NO-UNDO.
DEF VAR ix         AS INT  NO-UNDO.
DEF VAR oBrwViewDsMnu AS JBoxPopupMenu NO-UNDO.    

SUBSCRIBE TO "replaceViewDs" ANYWHERE.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN iOrgFrameWidth = FRAME {&FRAME-NAME}:WIDTH-PIXELS
         iOrgFiFileNameWidth = fiFileName:WIDTH-PIXELS
         bStoreViewDefInDb = JBoxSession:Instance:getJBoxAttribute("StoreViewDefInDb") = "yes"
         tbAutoSave:SENSITIVE = NO
         .
  
  oBrwViewDs = NEW JBoxBrowse(brwViewDs:HANDLE,      /* handle to place-holder rectangle */
                         NO,                       /* multiple-select? */ 
                         "",                       /* title */
                         NO,                       /* row-markers (if multiple) */
                         BUFFER ttViewDs:HANDLE).    /* The BUFFER ttCust.. parameter tells the browse that it is a local temp-table */
  
  oBrwViewDs:buffersAndFields = "ttView;ViewDsName;SourceName;BaseDb;BaseTable;ConnectionInfo;ViewDsDesc;ViewFileName".
  oBrwViewDs:BROWSE-HANDLE:GET-BROWSE-COLUMN(7):VISIBLE = NO.
  oBrwViewDs:setQuerySort("ViewDsName").
  IF NOT bStoreViewDefInDb THEN DO:
    oBrwViewDs:BROWSE-HANDLE:DROP-TARGET = YES.
    oBrwViewDs:BROWSE-HANDLE:TOOLTIP = "Drop (multiple) connection file(s) or view definition file(s) here".
  END.  
  
  oFmViews = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmViews:updateFields = 'ViewDsName,BaseTableId,ViewDsDesc'.
  oFmViews:BROWSE-OBJECT = oBrwViewDs.
  
  otbViews = NEW JBoxToolbar(tbViews:HANDLE).

  oBrwViewDs:TOOLBAR-OBJECT = otbViews.
  oFmViews:TOOLBAR-OBJECT = otbViews.
  
  oBrwViewDsMnu = NEW JBoxPopupMenu().
  oBrwViewDsMnu:addTool("activateNewWin", "Activate (run) in separate window"). 

  oBrwViewDs:POPUP-MENU-OBJECT = oBrwViewDsMnu.
  
  oJBoxMsTreeView = NEW uc.JBoxMsTreeView(THIS-PROCEDURE,TreeViewBaseTable:HANDLE,"tvpics\Fold.bmp,tvpics\FoldOpen.bmp").
  oJBoxMsTreeView:RegisterWithJukeBox(NO).
  TreeViewBaseTable:HIDDEN = YES.

  BaseTableId:DELIMITER = "|".

  bInit = YES.

/*  IF NOT JBoxSchemaCache:Instance:ProgressSchemaFetched AND JBoxServerAPI:Instance:CallServerProc("jbserv_getnumdbconnected.p","") THEN DO:     */
/*    ix = INT(JBoxServerAPI:Instance:getCallReturnParam()).                                                                                      */
/*    IF ix > 0 THEN DO:                                                                                                                          */
/*      RUN JBoxProgressBar.w PERSISTENT SET hProgBar.                                                                                            */
/*      DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar,10,"Building Progress schema cache..").                                                 */
/*    END.                                                                                                                                        */
/*  END.                                                                                                                                          */
/*                                                                                                                                                */
//  JBoxSchemaCache:Instance:getDbSchema(hdsSchema).
  JBoxSchemaCache:Instance:getDbSchema(?).
  
  /*
  // Pick up schemas for any sql connections defined on the appserver that hasn't already been loaded:
  cSqlDbList = JBoxSession:Instance:getJboxAttribute("SqlDbList").
  DO ix = 1 TO NUM-ENTRIES(cSqlDbList):
/*    IF NOT JBoxSchemaCache:Instance:SqlSchemaFetched AND NOT VALID-HANDLE(hProgBar) THEN*/
/*      RUN JBoxProgressBar.w PERSISTENT SET hProgBar.                                    */
    IF NOT CAN-FIND(FIRST tt_db WHERE tt_db.cSourceName = ENTRY(1,ENTRY(ix,cSqlDbList),"|")) THEN DO:
      IF VALID-HANDLE(hProgBar) THEN
        DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar,MIN(30 * ix,100),"Building " + ENTRY(1,ENTRY(ix,cSqlDbList),"|") + " schema cache..").
      IF NOT JBoxSchemaCache:Instance:getSqlDbSchema(hDsSchema,
                                 ENTRY(1,ENTRY(ix,cSqlDbList),"|"), // db name
                                 ENTRY(2,ENTRY(ix,cSqlDbList),"|"), // data source name
                                 ENTRY(3,ENTRY(ix,cSqlDbList),"|"), // db type (mssql,progresssql..)
                                 JBoxSession:Instance:AppServerHandle) THEN // db type
        MESSAGE JBoxSchemaCache:Instance:SchemaMessage
                VIEW-AS ALERT-BOX.
    END.
  END.
  */  
  oJBoxMsTreeView:setVisible(no).
  
  oContainer:setNoResizeX("TreeViewBaseTable").
  oContainer:setNoResizeY("brwViewDs," + oBrwViewDs:BROWSE-HANDLE:NAME).
  oContainer:setAddResizeX("ViewDsDesc").
  
  oTabViews = NEW JBoxMsTabs(TabViews:HANDLE,oBrwViewDs,"newbmp\account.bmp,gif\filter-off.gif").
  oTabViews:pageOneType = "child". // The default "oneToOne" will cause a refresh from page 1 after update

  oTabViews:setLinkFields("ViewDsId").
  oTabViews:AddPage("Tables","JBoxViewDsDefTable.w","account.bmp").
  oTabViews:AddPage("Filters","JBoxViewDsDefFilter.w","filter-off.gif").

  oTabViews:getPageQueryObject(1):setParentBrowseObject(oBrwViewDs,"ViewDsId").

  FillTreeDropDown().

//  RUN "RefreshSchemaDataSet" IN oTabViews:getPageHandle(1) (hDsSchema). 

  oContainer:setSplitBarY(btnSplitBarY:HANDLE).
  oContainer:setSplitBarYlimits(btnSplitBarY:HANDLE,120,270). /* 200 pixels from the top, 300 pixels from the bottom */
  oContainer:setFollowSplitBarY(STRING(brwViewDs:HANDLE) + "," + STRING(oBrwViewDs:BROWSE-HANDLE)
                             + "," + STRING(TreeViewBaseTable:HANDLE) + "," + STRING(TabViews:HANDLE)
                             + "," + STRING(BaseTableID:HANDLE) + "," + STRING(ViewDsDesc:HANDLE) + "," + STRING(ViewDsName:HANDLE)).
  oContainer:setNoResizeY("brwViewDs," + oBrwViewDs:BROWSE-HANDLE:Name).
END.

oBrwViewDs:openQuery().


&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize(500,100).
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveUserControl C-Win 
PROCEDURE LeaveUserControl :
/*------------------------------------------------------------------------------
  Purpose:     Invoked when the leave-event is triggered from the UC
  Parameters:  Handle for place-holder (editor, rectangle..)
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihPlaceHolder AS HANDLE NO-UNDO.

IF ihPlaceHolder = TreeViewBaseTable:HANDLE IN FRAME {&FRAME-NAME} THEN DO:
  oJBoxMsTreeView:setVisible(NO).
  oJBoxMsTreeView:SendToBack().
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadViewsRecord C-Win 
PROCEDURE LoadViewsRecord :
DEF VAR hDsView     AS HANDLE NO-UNDO.

hDsView = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).
IF VALID-HANDLE(hDsView) THEN DO:
  SYSTEM-DIALOG GET-FILE cViewJsonFile 
                FILTERS "Json files" "*.json"
                MUST-EXIST
                UPDATE bOK.
  IF bOk THEN DO:
    hDsView:EMPTY-DATASET().
    hDsView:READ-JSON ("file",cViewJsonFile).
    EMPTY TEMP-TABLE ttViewDs.
    BUFFER ttViewDs:COPY-TEMP-TABLE(hDsView:GET-BUFFER-HANDLE (1),NO,NO,YES).
    FOR EACH ttViewDs:
      ttViewDs.ViewFileName = cViewJsonFile.
      FOR EACH ttViewDsTable
          WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
            AND ttViewDsTable.SourceName = ""
          :
        ASSIGN ttViewDsTable.SourceName = ttViewDs.SourceName
               ttViewDsTable.SourceType = ttViewDs.SourceType
               .    
      END.        
      FOR EACH ttViewDsField
          WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
            AND ttViewDsField.SourceName = ""
          :
        ASSIGN ttViewDsField.SourceName = ttViewDs.SourceName
               ttViewDsField.SourceType = ttViewDs.SourceType
               .    
      END.        
    END.
    getSchemaStatus().
    setBaseTableId().
    oBrwViewDs:openQuery().
  END.              
END.


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

/*IF VALID-HANDLE(hProgBar) THEN                               */
/*  DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 100,"").*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myDatabrowseObject C-Win 
PROCEDURE myDatabrowseObject :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ioDynDataBrowse AS JBoxDynDataBrowse NO-UNDO.

DEF VAR cSqlDb            AS CHAR NO-UNDO.
DEF VAR hDsView           AS HANDLE NO-UNDO.
DEF VAR cJboxPrescan      AS CHAR NO-UNDO.
DEF VAR cPrescanTableList AS CHAR NO-UNDO.
DEF VAR ix                AS INT NO-UNDO.

cSqlDb = DYNAMIC-FUNCTION("getSqlDb" IN oTabViews:getPageHandle(1)).
IF cSqlDb = ? THEN RETURN.

// must be set prior to initialization:
ioDynDataBrowse:ViewDsId = ttViewDs.ViewDsId.
ioDynDataBrowse:EnableSaveQuery = YES.
ioDynDataBrowse:userSettingContext = "JBoxViewDsDef.w".
ioDynDataBrowse:QueryCanBeScheduled = NO. 
ioDynDataBrowse:QueryCanBeShared = NO.

hDsView = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).
ioDynDataBrowse:hViewDsUserSetting = hDsView:GET-BUFFER-HANDLE (4). 

IF cSqlDb = "" THEN DO:
  DYNAMIC-FUNCTION("setActiveASconnection",ttViewDs.SourceName).  

  ioDynDataBrowse:InitializeQuery(
      DYNAMIC-FUNCTION("getBuffersAndFields" IN oTabViews:getPageHandle(1),YES)
     ,DYNAMIC-FUNCTION("getQueryJoin" IN oTabViews:getPageHandle(1),"","")
     ,DYNAMIC-FUNCTION("getSortColumn" IN oTabViews:getPageHandle(1))  
     ,FALSE /* <- do record count */
     ).
END.     
ELSE DO:     
  JBoxSchemaCache:Instance:setUseDefaultConnection().
  ioDynDataBrowse:InitializeQuery(
      DYNAMIC-FUNCTION("getBuffersAndFields" IN oTabViews:getPageHandle(1),YES)
     ,DYNAMIC-FUNCTION("getQueryJoin" IN oTabViews:getPageHandle(1),"","")
     ,DYNAMIC-FUNCTION("getSortColumn" IN oTabViews:getPageHandle(1))  
     ,ttViewDs.SourceType NE "ProgressSql" /* <- do record count */
     ,ttViewDs.SourceName + "." + cSqlDb /* reference to sql database, ie parameter for jbserv_get_sql_data.p */     
      ).
END.     

DYNAMIC-FUNCTION("setDropDownDefinitions" IN oTabViews:getPageHandle(1),ioDynDataBrowse:BROWSE-OBJECT).
DYNAMIC-FUNCTION("setLookupDefinitions" IN oTabViews:getPageHandle(1),ioDynDataBrowse:BROWSE-OBJECT).
//ioDynDataBrowse:calcFieldProc = "customer_browsecalc.p".

ioDynDataBrowse:setViewDsUserQueryMenu().

ioDynDataBrowse:BROWSE-OBJECT:setJBoxAttribute("DataSourceName",ttViewDs.SourceName).
  
ioDynDataBrowse:BROWSE-OBJECT:baseQuery = DYNAMIC-FUNCTION("getBaseQuery" IN oTabViews:getPageHandle(1)).

IF cSqlDb = "" THEN DO:
  DYNAMIC-FUNCTION("setActiveASconnection",ttViewDs.SourceName).
  cJboxPrescan = DYNAMIC-FUNCTION("getPrescanQueries" IN oTabViews:getPageHandle(1),ttViewDs.SourceName).
  IF cJboxPrescan NE "" THEN DO:
    ASSIGN cPrescanTableList = ENTRY(1,cJboxPrescan,"¤")
           cJboxPrescan = ENTRY(2,cJboxPrescan,"¤"). 
    DO ix = 1 TO NUM-ENTRIES(cPrescanTableList):
      ioDynDataBrowse:BROWSE-OBJECT:setPreScanQuery(ENTRY(ix,cPrescanTableList),ENTRY(ix,cJboxPrescan,"|")).
    END.
    ioDynDataBrowse:BROWSE-OBJECT:altPrimaryBufferList = DYNAMIC-FUNCTION("getAltPrimaryBuffers" IN oTabViews:getPageHandle(1)).
  END.  
  ioDynDataBrowse:BROWSE-OBJECT:queryStopAfter = 30.
END.    
ELSE DO:
  ioDynDataBrowse:BROWSE-OBJECT:queryStopAfter = 10.
  ioDynDataBrowse:BROWSE-OBJECT:prescanBaseQuery = DYNAMIC-FUNCTION("getSqlSubQueries" IN oTabViews:getPageHandle(1),"","").
END.  

ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addSubMenu("Export").
ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addTool("ToCsv","To Csv file","Export").
ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addTool("ToJson","To Json file","Export").
ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addTool("ToXml","To XML file","Export").

IF cRunQueryId = "" THEN
  ioDynDataBrowse:BROWSE-OBJECT:openQuery().
ELSE  // run a stored filter via activateWithFilter
  ioDynDataBrowse:startViewDsUserQuery(cRunQueryId).
cRunQueryId = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
  RUN SUPER.
  DYNAMIC-FUNCTION("closeTableQuery" IN oTabViews:getPageHandle(1)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NodeDoubleClickRecord C-Win 
PROCEDURE NodeDoubleClickRecord :
/*------------------------------------------------------------------------------
  Purpose:     Invoked on double-click of Ms tree-view
  Parameters:  Node-name
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNodeName AS CHARACTER NO-UNDO.

IF LOOKUP(icNodeName,BaseTableId:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},"|") = 0 THEN 
  BaseTableId:ADD-LAST (oJBoxMsTreeView:getNodeText(icNodeName),icNodeName).

IF LOOKUP(icNodeName,BaseTableId:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},"|") > 0 THEN
  ASSIGN BaseTableId:SCREEN-VALUE IN FRAME {&FRAME-NAME} = icNodeName. // oJBoxMsTreeView:getNodeText(icNodeName)
         .

APPLY "entry" TO BaseTableID.
oJBoxMsTreeView:setVisible(NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostInitialize C-Win 
PROCEDURE PostInitialize :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cSqlDbList AS CHAR NO-UNDO.
DEF VAR ix         AS INT  NO-UNDO.
/*
IF NOT JBoxSchemaCache:Instance:ProgressSchemaFetched AND JBoxServerAPI:Instance:CallServerProc("jbserv_getnumdbconnected.p","") THEN DO:
  ix = INT(JBoxServerAPI:Instance:getCallReturnParam()).
  IF ix > 0 THEN 
    oContainer:statusBar:HelpText = "Building Progress schema cache..".
END.  
  
JBoxSchemaCache:Instance:getDbSchema(hdsSchema).
  
// Pick up schemas for any sql connections defined on the appserver that hasn't already been loaded:
cSqlDbList = JBoxSession:Instance:getJboxAttribute("SqlDbList").
DO ix = 1 TO NUM-ENTRIES(cSqlDbList):
  IF NOT CAN-FIND(FIRST tt_db WHERE tt_db.cSourceName = ENTRY(1,ENTRY(ix,cSqlDbList),"|")) THEN DO:
    IF VALID-HANDLE(hProgBar) THEN
      oContainer:statusBar:HelpText = "Building " + ENTRY(1,ENTRY(ix,cSqlDbList),"|") + " schema cache..".
    IF NOT JBoxSchemaCache:Instance:getSqlDbSchema(hDsSchema,
                               ENTRY(1,ENTRY(ix,cSqlDbList),"|"), // db name
                               ENTRY(2,ENTRY(ix,cSqlDbList),"|"), // data source name
                               ENTRY(3,ENTRY(ix,cSqlDbList),"|"), // db type (mssql,progresssql..) 
                               JBoxSession:Instance:AppServerHandle) THEN // db type
      MESSAGE JBoxSchemaCache:Instance:SchemaMessage
              VIEW-AS ALERT-BOX.                          
  END.  
END. 

FillTreeDropDown().
oBrwViewDs:openQuery().
*/
oContainer:statusBar:HelpText = "".  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RefreshSchema C-Win 
PROCEDURE RefreshSchema :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihDsSchema AS HANDLE NO-UNDO.

DEF VAR ix AS INT NO-UNDO.

hdsSchema:EMPTY-DATASET ().
hdsSchema:COPY-DATASET(ihDsSchema).

//RUN "RefreshSchemaDataSet" IN oTabViews:getPageHandle(1) (ihDsSchema). 

FillTreeDropDown().

oBrwViewDs:openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE replaceViewDs C-Win 
PROCEDURE replaceViewDs :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR ix            AS INT NO-UNDO.
DEF VAR ii            AS INT NO-UNDO.
DEF VAR hDsMaster     AS HANDLE NO-UNDO.
DEF VAR hDsViewSave   AS HANDLE NO-UNDO.
DEF VAR cViewDsIdList AS CHAR NO-UNDO.
DEF VAR hDsQryBuff    AS HANDLE NO-UNDO.

IF fiFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE "" AND tbAutoSave:CHECKED THEN DO:
  hDsMaster = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).
  DO ii = 1 TO NUM-ENTRIES(fiFileName:SCREEN-VALUE):
    CREATE DATASET hDsViewSave.
    hDsViewSave:CREATE-LIKE (hDsMaster).
    hDsViewSave:COPY-DATASET (hDsMaster).
    cViewDsIdList = "".
    IF NUM-ENTRIES(fiFileName:SCREEN-VALUE) > 1 THEN
      FOR EACH ttViewDs
          WHERE ttViewDs.ViewFileName = ENTRY(ii,fiFileName:SCREEN-VALUE):
        cViewDsIdList = cViewDsIdList + (IF cViewDsIdList NE "" THEN "," ELSE "") + ttViewDs.ViewDsId.
      END.
    ELSE     
      FOR EACH ttViewDs:
        cViewDsIdList = cViewDsIdList + (IF cViewDsIdList NE "" THEN "," ELSE "") + ttViewDs.ViewDsId.
      END.  
    DO ix = 1 TO hDsViewSave:NUM-BUFFERS:
      CREATE QUERY hDsQryBuff.
      hDsQryBuff:SET-BUFFERS (hDsViewSave:GET-BUFFER-HANDLE (ix)).
      hDsQryBuff:QUERY-PREPARE ("FOR EACH " + hDsViewSave:GET-BUFFER-HANDLE (ix):NAME + " WHERE NOT CAN-DO('" + cViewDsIdList + "',ViewDsId)").
      hDsQryBuff:QUERY-OPEN ().
      REPEAT WHILE hDsQryBuff:GET-NEXT ():
        hDsViewSave:GET-BUFFER-HANDLE (ix):BUFFER-DELETE ().
      END.   
      DELETE OBJECT hDsQryBuff. 
    END.
    hDsViewSave:WRITE-JSON("file",ENTRY(ii,fiFileName:SCREEN-VALUE),YES).
    DELETE OBJECT hDsViewSave.
  END.                
  oBrwViewDs:BROWSE-HANDLE:GET-BROWSE-COLUMN(7):VISIBLE = NUM-ENTRIES(fiFileName:SCREEN-VALUE) > 1.
END.

FINALLY:
  DELETE OBJECT hDsViewSave NO-ERROR.
END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReturnOfTreeNode C-Win 
PROCEDURE ReturnOfTreeNode :
/*------------------------------------------------------------------------------
  Purpose:     Invoked on return of Ms tree-view
  Parameters:  Node-name
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNodeName AS CHARACTER NO-UNDO.

IF LOOKUP(icNodeName,BaseTableId:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},"|") = 0 THEN 
  BaseTableId:ADD-LAST (oJBoxMsTreeView:getNodeText(icNodeName),icNodeName).

IF LOOKUP(icNodeName,BaseTableId:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},"|") > 0 THEN
  ASSIGN BaseTableId:SCREEN-VALUE = icNodeName
         .
APPLY "entry" TO BaseTableID.
oJBoxMsTreeView:setVisible(NO).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
DO WITH FRAME {&FRAME-NAME}:
  DEF VAR bNew AS LOG NO-UNDO.
  DEF VAR iFileNum AS INT NO-UNDO.
  DEF VAR cFileName AS CHAR NO-UNDO.
  DEF VAR rRepos    AS ROWID NO-UNDO.
  
  bNew = otbViews:objectState = "new".
    
  IF bNew THEN DO:
    iFileNum = INT(BaseTableId:SCREEN-VALUE) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE "Base table not selected"
      VIEW-AS ALERT-BOX.
      RETURN.
    END.
    FOR EACH tt_file
        WHERE tt_file.iFileNum = iFileNum
       ,FIRST tt_db
              WHERE tt_db.iDbNum = tt_file.iDbNum
        :
      LEAVE.       
    END. 
    IF NOT AVAIL tt_file THEN DO:
      MESSAGE "You must select a base table"
      VIEW-AS ALERT-BOX.
      RETURN.
    END.
    IF fiFileName:SCREEN-VALUE NE "" THEN DO:
      IF NUM-ENTRIES(fiFileName:SCREEN-VALUE) > 1 THEN DO:
        JBoxSession:Instance:SimpleSelectList(fiFileName:SCREEN-VALUE,",").
        IF JBoxSession:Instance:SelectListOk THEN
          cFileName = JBoxSession:Instance:SelectListValue.
        ELSE RETURN.  
      END.
      ELSE cFileName = fiFileName:SCREEN-VALUE.
      
      ASSIGN oFmViews:bufferExtraFields = "SourceName,SourceType,BaseDb,BaseTable,ViewDsId,ViewFileName"
             oFmViews:bufferExtraValues = tt_db.cSourceName + "|" + tt_db.cSourceType + "|" + tt_file.cLDBname + "|" + tt_file.cFile-Name + "|" + GUID + "|" + cFileName.
    END.         
    ELSE
      ASSIGN oFmViews:bufferExtraFields = "SourceName,SourceType,BaseDb,BaseTable,ViewDsId"
             oFmViews:bufferExtraValues = tt_db.cSourceName + "|" + tt_db.cSourceType + "|" + tt_file.cLDBname + "|" + tt_file.cFile-Name + "|" + GUID.
  END.         
  
  RUN SUPER.

  IF bNew THEN DO:
    rRepos = ROWID(ttViewDs).
    RUN "RefreshViewTempTable" IN oTabViews:getPageHandle(1) (httViewDs,ttViewDs.ViewDsId,bNew).   
    getSchemaStatus().
    oBrwViewDs:openQuery().
    oBrwViewDs:QUERY-HANDLE:REPOSITION-TO-ROWID(rRepos).
    oBrwViewDs:displayRecord().
  END.  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveViewsAsRecord C-Win 
PROCEDURE SaveViewsAsRecord :
DEF VAR hDsMaster       AS HANDLE NO-UNDO.

oBrwViewDs:BROWSE-HANDLE:SELECT-FOCUSED-ROW().

hDsMaster = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).
IF VALID-HANDLE(hDsMaster) THEN DO WITH FRAME {&FRAME-NAME}:

  SYSTEM-DIALOG GET-FILE cViewJsonFile 
                FILTERS "Json files" "*.json"
                UPDATE bOK.
  IF NOT bOk THEN RETURN.
  IF NOT cViewJsonFile MATCHES "*.json" THEN cViewJsonFile = cViewJsonFile + ".json".
  ttViewDs.ViewFileName = cViewJsonFile.
  IF fiFileName:SCREEN-VALUE = "" 
     AND SEARCH(cViewJsonFile) NE ? 
     AND NOT JBoxSession:Instance:ViewQuestionOkCancel("Replace " + cViewJsonFile) THEN RETURN.
  hDsMaster:GET-BUFFER-HANDLE(1)::ViewFileName = cViewJsonFile.
  fiFileName:SCREEN-VALUE = cViewJsonFile.
  hDsMaster:WRITE-JSON("file",cViewJsonFile,YES).
  setAutoSave().
  oBrwViewDs:openQuery().

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveViewsRecord C-Win 
PROCEDURE SaveViewsRecord :
DEF VAR hDsMaster     AS HANDLE NO-UNDO.
DEF VAR bReplace      AS LOG NO-UNDO.

oBrwViewDs:BROWSE-HANDLE:SELECT-FOCUSED-ROW().

hDsMaster = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).
IF VALID-HANDLE(hDsMaster) THEN DO WITH FRAME {&FRAME-NAME}:
  IF fiFileName:SCREEN-VALUE NE "" THEN 
    bReplace = JBoxSession:Instance:ViewQuestionYesNo("Replace "
                                                     + (IF NUM-ENTRIES(fiFileName:SCREEN-VALUE) > 1 THEN " files " ELSE "")
                                                     + fiFileName:SCREEN-VALUE + "?").
  IF NOT bReplace THEN DO:
    SYSTEM-DIALOG GET-FILE cViewJsonFile 
                  FILTERS "Json files" "*.json"
                  UPDATE bOK.
    IF NOT bOk THEN RETURN.
    IF NOT cViewJsonFile MATCHES "*.json" THEN cViewJsonFile = cViewJsonFile + ".json".
    ttViewDs.ViewFileName = cViewJsonFile.
    IF fiFileName:SCREEN-VALUE = "" 
       AND SEARCH(cViewJsonFile) NE ? 
       AND NOT JBoxSession:Instance:ViewQuestionOkCancel("Replace " + cViewJsonFile) THEN RETURN.
    hDsMaster:GET-BUFFER-HANDLE(1)::ViewFileName = cViewJsonFile.
    fiFileName:SCREEN-VALUE = cViewJsonFile.
    hDsMaster:WRITE-JSON("file",cViewJsonFile,YES).
    setAutoSave().
  END.  
  ELSE DO:
    bReplace = tbAutoSave:CHECKED.
    tbAutoSave:CHECKED = YES.
    RUN replaceViewDs.
    tbAutoSave:CHECKED = bReplace.
  END.
  oBrwViewDs:openQuery().
END.

CATCH eErr AS Progress.Lang.Error :
  MESSAGE eErr:GetMessage(1)
          VIEW-AS ALERT-BOX.  
END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE scheduleQueryRecord C-Win 
PROCEDURE scheduleQueryRecord :
DEF VAR hDsMaster  AS HANDLE NO-UNDO. 

  IF VALID-HANDLE(hScriptDefView) THEN DO:
    RUN MoveToTop IN hScriptDefView.
    RETURN.
  END.  

  oBrwViewDs:BROWSE-HANDLE:SELECT-FOCUSED-ROW().

  FIND FIRST tt_db
       WHERE tt_db.cSourceName = ttViewDs.SourceName
         AND tt_db.cLDBname    = ttViewDs.BaseDb
       NO-ERROR.
  IF NOT AVAIL tt_db THEN DO:
    MESSAGE "Connection info not available"
    VIEW-AS ALERT-BOX.     
    RETURN.
  END.  
  hScriptDefView = oContainer:StartChildWindow("JboxViewDsScript.w","Define script for " + ttViewDs.SourceName + "." + ttViewDs.ViewDsName, NO).

  hDsMaster = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).

  RUN SetParameters IN hScriptDefView (BUFFER tt_db,hdsMaster:GET-BUFFER-HANDLE (1),?,oTabViews:getPageHandle(1)).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION activateNewWinWithFilter C-Win 
FUNCTION activateNewWinWithFilter RETURNS LOGICAL
  ( INPUT icQueryId AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

cRunQueryId = icQueryId.

RUN activateNewWinRecord.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION activateWithFilter C-Win 
FUNCTION activateWithFilter RETURNS LOGICAL
  ( INPUT icQueryId AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
cRunQueryId = icQueryId.

RUN activateRecord.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION applySelectedTreeNode C-Win 
FUNCTION applySelectedTreeNode RETURNS LOGICAL
  ( INPUT icNodeName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  IF LOOKUP(icNodeName,BaseTableID:LIST-ITEM-PAIRS,"|") = 0 THEN RETURN NO.
  
  ASSIGN BaseTableID:SCREEN-VALUE IN FRAME {&FRAME-NAME} = icNodeName
         .
  APPLY "entry" TO BaseTableId.
  oJBoxMsTreeView:setVisible(NO).
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CreTestData C-Win 
FUNCTION CreTestData RETURNS LOGICAL():
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  CREATE tt_db.
  ASSIGN tt_db.cLDBname = "Sports".
  CREATE tt_file.
  ASSIGN tt_file.cLDBname = "Sports"
         tt_file.cFile-Name = "Customer"
         tt_file.iFileNum   = 1
         tt_file.cTbl-Type = "T"
         .
  CREATE tt_file.
  ASSIGN tt_file.cLDBname = "Sports"
         tt_file.cFile-Name = "Order"
         tt_file.iFileNum   = 2
         tt_file.cTbl-Type = "T"
         .
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FillTreeDropDown C-Win 
FUNCTION FillTreeDropDown RETURNS LOGICAL ( ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR cId AS CHAR NO-UNDO.
DEF VAR cListPairs AS CHAR NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  oJBoxMsTreeView:clearNodes().
  FOR EACH tt_db
      BREAK BY tt_db.cSourceName
            BY tt_db.cLDBname
      :
    IF FIRST-OF(tt_db.cLdbName) THEN DO:
      oJBoxMsTreeView:AddNode("",tt_db.cSourceName + "." + tt_db.cLDBname,tt_db.cSourceName + "." + tt_db.cLDBname,"Database",0,1).
      FOR EACH tt_file NO-LOCK
          WHERE tt_file.iDbNum = tt_db.iDbNum
            AND tt_file.cTbl-Type = "T"
          :
//        cId = tt_db.cSourceName + "." + tt_file.cLDBname + "." + tt_file.cFile-Name.    
        cId = STRING(tt_file.iFileNum).    
        oJBoxMsTreeView:AddNode(tt_db.cSourceName + "." + tt_db.cLDBname,cId,tt_file.cFile-Name,"Tables",0,1).    
//        cListPairs = cListPairs + (IF cListPairs NE "" THEN "|" ELSE "") + tt_file.cFile-Name + "|" + cId.
        IF cFirstTable = "" THEN cFirstTable = cId.
      END.
    END.
  END.    
  IF cListPairs = "" THEN cListPairs = "|".
  BaseTableId:LIST-ITEM-PAIRS = cListPairs.
END.

setBaseTableId().

RUN RefreshSchemaDataSet IN oTabViews:getPageHandle(1) (hdsSchema).

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSchemaStatus C-Win 
FUNCTION getSchemaStatus RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR rttViewDs AS ROWID NO-UNDO.
DEF VAR bRepos    AS LOG NO-UNDO.
DEF VAR cFileNameList AS CHAR NO-UNDO.

IF AVAIL ttViewDs THEN
  ASSIGN rttViewDs = ROWID(ttViewDs)
         bRepos    = YES.

FOR EACH ttViewDs:
  ttViewDs.ConnectionInfo = IF JBoxSchemaCache:Instance:getIsDbConnected(ttViewDs.SourceName,ttViewDs.SourceType,ttViewDs.BaseDb) THEN
                              "Connected" 
                            ELSE (IF ttViewDs.SourceType MATCHES "*sql*" THEN "SQL not connected"
                                  ELSE IF ttViewDs.SourceType MATCHES "*apsv" THEN "APSV not connected"
                                  ELSE "DB not connected").

  IF ttViewDs.ViewFileName NE "" AND NOT CAN-DO(cFileNameList,ttViewDs.ViewFileName) THEN
    cFileNameList = cFileNameList + (IF cFileNameList NE "" THEN "," ELSE "") + ttViewDs.ViewFileName. 
END.

fiFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cFileNameList.

oBrwViewDs:BROWSE-HANDLE:GET-BROWSE-COLUMN(7):VISIBLE = NUM-ENTRIES(cFileNameList) > 1.

setAutoSave().

IF bRepos AND oBrwViewDs:QUERY-HANDLE:IS-OPEN THEN
  oBrwViewDs:QUERY-HANDLE:REPOSITION-TO-ROWID(rttViewDs) NO-ERROR.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewDsHandle C-Win 
FUNCTION getViewDsHandle RETURNS HANDLE
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

  RETURN DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION scheduleWithFilter C-Win 
FUNCTION scheduleWithFilter RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR hDsMaster  AS HANDLE NO-UNDO. 
  DEF VAR hScriptDef AS HANDLE NO-UNDO.

  IF VALID-HANDLE(hScriptDefFilter) THEN DO:
    RUN MoveToTop IN hScriptDefFilter.
    RETURN YES.
  END.  

  oBrwViewDs:BROWSE-HANDLE:SELECT-FOCUSED-ROW().

  FIND FIRST tt_db
       WHERE tt_db.cSourceName = ttViewDs.SourceName
         AND tt_db.cLDBname    = ttViewDs.BaseDb
       NO-ERROR.
  IF NOT AVAIL tt_db THEN DO:
    MESSAGE "Connection info not available"
    VIEW-AS ALERT-BOX.     
    RETURN NO.
  END.  
  hDsMaster = DYNAMIC-FUNCTION("getViewDsHandle" IN oTabViews:getPageHandle(1)).

  hScriptDefFilter = oContainer:StartChildWindow("JboxViewDsScript.w"
                         ,"Define script for " + ttViewDs.SourceName + "." + ttViewDs.ViewDsName
                                               + ", Filter: " + hDsMaster:GET-BUFFER-HANDLE(4)::ScriptFilterName 
                         , NO).


  RUN SetParameters IN hScriptDefFilter (BUFFER tt_db,hdsMaster:GET-BUFFER-HANDLE (1),hdsMaster:GET-BUFFER-HANDLE (4),oTabViews:getPageHandle(1)).

  RETURN YES.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoSave C-Win 
FUNCTION setAutoSave RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  IF fiFileName:SCREEN-VALUE NE "" THEN DO:
    IF NOT tbAutoSave:SENSITIVE THEN
      ASSIGN tbAutoSave:CHECKED = YES
             tbAutoSave:SENSITIVE = YES. 
  END.
  ELSE ASSIGN tbAutoSave:CHECKED = NO
              tbAutoSave:SENSITIVE = NO.  
END.
RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBaseTableId C-Win 
FUNCTION setBaseTableId RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose: Set base table id's according to schema connect status
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR bIdOk         AS LOG NO-UNDO.
  DEF VAR iLookupName   AS INT NO-UNDO.

  FOR EACH ttViewDs:
    bIdOk = NO.
    IF ttViewDs.ConnectionInfo = "Connected" THEN DO:
      FOR EACH tt_file
          WHERE tt_file.iFileNum   = INT(ttViewDs.BaseTableId)
            AND tt_file.cFile-Name = ttViewDs.BaseTable
            AND tt_file.cLDBname   = ttViewDs.BaseDb
         ,FIRST tt_db
                WHERE tt_db.iDbNum = tt_file.iDbNum
                  AND tt_db.cSourceName = ttViewDs.SourceName
        : 
        bIdOk = YES.         
      END.          
      IF NOT bIdOk THEN 
        FOR EACH tt_db 
            WHERE tt_db.cSourceName = ttViewDs.SourceName
              AND tt_db.cLDBname    = ttViewDs.BaseDb
           ,EACH tt_file
                 WHERE tt_file.iDbNum = tt_db.iDbNum
                   AND tt_file.cFile-Name = ttViewDs.BaseTable
           :
          ttViewDs.BaseTableId = STRING(tt_file.iFileNum).
        END.                  
    END.
    ELSE DO WITH FRAME {&FRAME-NAME}:
      iLookupName = LOOKUP(ttViewDs.BaseTable,BaseTableId:LIST-ITEM-PAIRS,"|").
      bIdOk = iLookupName > 0 AND LOOKUP(ttViewDs.BaseTableId,BaseTableId:LIST-ITEM-PAIRS,"|") = iLookupName + 1.
      IF NOT bIdOk THEN DO:
        iFakeBaseTableId = iFakeBaseTableId + 1.
        ttViewDs.BaseTableId = STRING(iFakeBaseTableId).
        BaseTableId:ADD-LAST(ttViewDs.BaseTable,STRING(iFakeBaseTableId)).
      END.  
    END.  
  END.  
  RUN "RefreshViewTempTable" IN oTabViews:getPageHandle(1) (httViewDs,"xxx",NO).

  RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ViewTree C-Win 
FUNCTION ViewTree RETURNS LOGICAL () :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR iScreenValue AS INT NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  oJBoxMsTreeView:setVisible(yes).
  oJBoxMsTreeView:BringToFront().
  IF BaseTableID:SCREEN-VALUE NE "" AND BaseTableID:SCREEN-VALUE NE ? THEN DO:
    iScreenValue = INT(BaseTableId:SCREEN-VALUE) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      FIND FIRST tt_file
           WHERE tt_file.cFile-Name BEGINS BaseTableId:SCREEN-VALUE
           NO-ERROR.
      IF AVAIL tt_file THEN     
        oJBoxMsTreeView:SelectNode(STRING(tt_file.iFileNum)).
    END.
    ELSE
      oJBoxMsTreeView:SelectNode(BaseTableID:SCREEN-VALUE).
  END.  
  ELSE DO:
    oJBoxMsTreeView:ExpandNodes("").
    oJBoxMsTreeView:SelectNode(cFirstTable).
  END.  
      
  oJBoxMsTreeView:dotNetFocus().

END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

