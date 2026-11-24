&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Start a utility built with JukeBox */               


DEF VAR hUtil           AS HANDLE NO-UNDO.
DEF VAR cSessfile       AS CHAR   NO-UNDO.
DEF VAR cLine           AS CHAR   NO-UNDO.
DEF VAR cSessId         AS CHAR   NO-UNDO.
DEF VAR cAppFarmFile    AS CHAR   NO-UNDO.
DEF VAR cAppFarmConnect AS CHAR   NO-UNDO INIT "-H 192.168.105.11 -S 13456 -AppService Appfarm -DirectConnect".
DEF VAR hAppFarm        AS HANDLE NO-UNDO.
DEF VAR bNoLogin        AS LOG    NO-UNDO.
DEF VAR hChildProcDev AS HANDLE NO-UNDO EXTENT 20.
DEF VAR cChildProcDev AS CHAR   NO-UNDO EXTENT 20.
DEF VAR hMenu         AS HANDLE NO-UNDO.

{tt_schema.i "NEW SHARED"}

RUN JBoxLoadLib.p ("JBoxUIlib.p,JBoxASlib.p,ResizeLib.p"
                   + (IF PROVERSION BEGINS "1" THEN ",JBoxFUlib.p" ELSE "")).

JBoxSession:Instance:setJBoxAttribute("queryStopAfter","30").

cSessfile = SEARCH("incl/custdevmode.i").
IF cSessfile NE ? THEN DO:
  INPUT FROM VALUE(cSessfile).
  REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine MATCHES '*setSessionId*' THEN
      cSessId = REPLACE(REPLACE(REPLACE(ENTRY(NUM-ENTRIES(cLine),cLine),'"',""),".",""),")","").
  END.
  INPUT CLOSE.
END.
IF cSessId = "" OR cSessId = "ocSessionId" THEN cSessId = "validsession".

cAppFarmFile = SEARCH("appFarmConnect.txt").
IF cAppFarmFile NE ? THEN DO:
  INPUT FROM VALUE(cAppFarmFile).
  REPEAT:
    IMPORT UNFORMATTED cLine.
    IF NOT TRIM(cLine) BEGINS '#' THEN
      cAppFarmConnect = cLine.
  END.
  INPUT CLOSE.
END.

DEF VAR bok AS LOG NO-UNDO.

IF NOT CAN-DO("nologin",SOURCE-PROCEDURE:INTERNAL-ENTRIES) THEN DO:

  RUN JBoxLogin.w (output bOk) NO-ERROR.
  IF ERROR-STATUS:GET-NUMBER (1) = 3230 THEN
    RUN JBoxLogin.w (OS-GETENV("username"), output bOk) NO-ERROR.
        
END.    
ELSE bNoLogin = YES.
  
IF SOURCE-PROCEDURE:FILE-NAME = "startToolSel.p" THEN DO:
  IF NOT bOk THEN QUIT.  
//  DYNAMIC-FUNCTION("setSessionId",cSessId).
  DYNAMIC-FUNCTION("setLanguageCode","EN").
END.    

DYNAMIC-FUNCTION("setAppTitle","AppComp").
DYNAMIC-FUNCTION("setBehaviour",
                  "DefaultSortFont|6," +   
                  "DefaultSortColor|15," + 
                  "BrowseSearchDefault|goto," +
                  "TabOnReturn|yes," +       
                  "SetSortLabel|yes"
                  ).

DEF TEMP-TABLE ttHandles
    FIELD hUtil     AS HANDLE
    FIELD cProgram  AS CHAR
    FIELD hDataBrw  AS HANDLE
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnRun cmbTool btnExec fiRun btnfiRun ~
tbAlwaysOnTop cLdb1 
&Scoped-Define DISPLAYED-OBJECTS cmbTool fiRun tbAlwaysOnTop cLdb1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnExec 
     IMAGE-UP FILE "bmp/active16.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Activate" 
     SIZE 4.8 BY 1.14.

DEFINE BUTTON btnfiRun 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btnRun 
     IMAGE-UP FILE "bmp/active16.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Run" 
     SIZE 4.8 BY 1.14.

DEFINE VARIABLE cmbTool AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tool" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Dictionary Viewer;DictView.w;","Clipboard Converter;ClipboardConversion.w" 
     DROP-DOWN-LIST
     SIZE 28.6 BY 1 NO-UNDO.

DEFINE VARIABLE cLdb1 AS CHARACTER FORMAT "X(256)":U 
     LABEL "DB" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE fiRun AS CHARACTER FORMAT "X(256)":U 
     LABEL "Run" 
     VIEW-AS FILL-IN 
     SIZE 24.6 BY 1 NO-UNDO.

DEFINE VARIABLE tbAlwaysOnTop AS LOGICAL INITIAL yes 
     LABEL "Always on top" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 TOOLTIP "Keep clipboard conversion always on top" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnRun AT ROW 2.38 COL 36.2 WIDGET-ID 10
     cmbTool AT ROW 1.38 COL 5.4 COLON-ALIGNED WIDGET-ID 2
     btnExec AT ROW 1.29 COL 36.2 WIDGET-ID 6
     fiRun AT ROW 2.43 COL 5.4 COLON-ALIGNED
     btnfiRun AT ROW 2.43 COL 32 WIDGET-ID 12 NO-TAB-STOP 
     tbAlwaysOnTop AT ROW 3.52 COL 7.2 WIDGET-ID 4
     cLdb1 AT ROW 3.62 COL 27 COLON-ALIGNED
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 53 BY 3.33 WIDGET-ID 100.


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
         TITLE              = "JukeBox Tool Selector"
         HEIGHT             = 3.33
         WIDTH              = 40.2
         MAX-HEIGHT         = 16
         MAX-WIDTH          = 80.4
         VIRTUAL-HEIGHT     = 16
         VIRTUAL-WIDTH      = 80.4
         MIN-BUTTON         = no
         MAX-BUTTON         = no
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 3.33
       FRAME DEFAULT-FRAME:WIDTH            = 53.

ASSIGN 
       cLdb1:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* JukeBox Tool Selector */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* JukeBox Tool Selector */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnExec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnExec C-Win
ON CHOOSE OF btnExec IN FRAME DEFAULT-FRAME /* Activate */
DO:
  DEF VAR cSelectedTool AS CHAR NO-UNDO.
  
  cSelectedTool = ENTRY(1,cmbTool:SCREEN-VALUE,"|").
  
  IF SEARCH(cSelectedTool) NE ? OR SEARCH(ENTRY(1,cSelectedTool,".") + ".r") NE ? THEN DO:
    IF cSelectedTool MATCHES "*w" THEN DO:
      IF cSelectedTool = "JBoxMessageMaint.w" AND 
         DYNAMIC-FUNCTION("getFieldValues","_file","WHERE _file-name = 'JBoxMessage'","_file-name") = ? THEN DO:
        DYNAMIC-FUNCTION("DoMessage",0,0,"JBoxMessage table not installed","","").
        RETURN NO-APPLY.
      END.
      ELSE IF cSelectedTool = "JBoxGenCode.w" AND
           DYNAMIC-FUNCTION("getFieldValues","_file","WHERE _file-name = 'JBoxGenCode'","_file-name") = ? THEN DO:
        DYNAMIC-FUNCTION("DoMessage",0,0,"JBoxGenCode / JBoxGenCodeType table not installed","","").
        RETURN NO-APPLY. 
      END.
      ELSE IF cSelectedTool = "JBoxSysParam.w" AND
           DYNAMIC-FUNCTION("getFieldValues","_file","WHERE _file-name = 'JBoxSysParam'","_file-name") = ? THEN DO:
        DYNAMIC-FUNCTION("DoMessage",0,0,"JBoxSysParam table not installed","","").
        RETURN NO-APPLY. 
      END.
      ELSE IF cSelectedTool = "JBoxPackage.w" THEN DO:
        IF NOT VALID-HANDLE(hAppFarm) THEN DO:
          CREATE SERVER hAppFarm.
          hAppFarm:CONNECT(cAppFarmConnect) NO-ERROR.
        END.
      END.

      FIND FIRST ttHandles 
           WHERE ttHandles.cProgram = cSelectedTool
           NO-ERROR.
      IF NOT AVAIL ttHandles OR NOT VALID-HANDLE(ttHandles.hUtil) THEN DO:
        IF NOT AVAIL ttHandles THEN DO:
          CREATE ttHandles.
          ttHandles.cProgram = cSelectedTool.
        END.
        SESSION:SET-WAIT-STATE ("general").
        RUN VALUE(cSelectedTool) PERSIST SET ttHandles.hUtil.
        IF CAN-DO(ttHandles.hUtil:INTERNAL-ENTRIES,"InitializeObject") THEN
          RUN InitializeObject IN ttHandles.hUtil.
        IF CAN-DO(ttHandles.hUtil:INTERNAL-ENTRIES,"MoveToTop") THEN
          RUN MoveToTop IN ttHandles.hUtil.
        IF CAN-DO(ttHandles.hUtil:INTERNAL-ENTRIES,"PostInitialize") THEN
          RUN PostInitialize IN ttHandles.hUtil.
        SESSION:SET-WAIT-STATE("").
      END.
      ELSE DO:
        IF CAN-DO(ttHandles.hUtil:INTERNAL-ENTRIES,"MoveToTop") THEN
          RUN MoveToTop IN ttHandles.hUtil.
        ELSE
          ttHandles.hUtil:CURRENT-WINDOW:MOVE-TO-TOP() NO-ERROR.
      END.
    END.
    ELSE RUN VALUE(cSelectedTool).
  END.
  ELSE RUN VALUE(cSelectedTool).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnfiRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnfiRun C-Win
ON CHOOSE OF btnfiRun IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.
  DEF VAR ix           AS INT  NO-UNDO.
  DEF VAR cProc        AS CHAR NO-UNDO.

  cUseFileName = fiRun:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cUseFileName USE-FILENAME UPDATE bOk.
  IF bOk THEN DO:
    DO ix = NUM-ENTRIES(cUseFileName,"\") TO 1 BY -1:
      cProc = ENTRY(ix,cUseFileName,"\") + (IF cProc NE "" THEN "\" ELSE "") + cProc.
      IF SEARCH(cProc) NE ? THEN DO:  
        fiRun:SCREEN-VALUE = cProc.
        LEAVE.
      END.   
    END.      
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnRun C-Win
ON CHOOSE OF btnRun IN FRAME DEFAULT-FRAME /* Run */
DO:
//  DEF VAR hDataBrw AS HANDLE NO-UNDO.
  ASSIGN fiRun.
  IF SEARCH(fiRun) NE ? OR SEARCH(ENTRY(1,fiRun,".") + ".r") NE ? THEN DO:
    IF NOT fiRun MATCHES "*p" THEN DO:
      FIND FIRST ttHandles 
           WHERE ttHandles.cProgram = fiRun
           NO-ERROR.
      IF NOT AVAIL ttHandles OR NOT VALID-HANDLE(ttHandles.hUtil) THEN DO:
        IF NOT AVAIL ttHandles THEN DO:
          CREATE ttHandles.
          ttHandles.cProgram = fiRun.
        END.
        SESSION:SET-WAIT-STATE ("general").
        RUN VALUE(fiRun) PERSIST SET ttHandles.hUtil NO-ERROR.
        IF ERROR-STATUS:GET-NUMBER(1) = 3234 THEN DO:
          RUN JBoxDataBrw.w PERSIST SET ttHandles.hDataBrw.
          RUN VALUE(fiRun) PERSIST SET ttHandles.hUtil (ttHandles.hDataBrw).
          DYNAMIC-FUNCTION("setParent" IN ttHandles.hDataBrw, ttHandles.hUtil).
          SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "InvalidateHandle" IN ttHandles.hDataBrw.
        END.
        IF CAN-DO(ttHandles.hUtil:INTERNAL-ENTRIES,"InitializeObject") THEN
          RUN InitializeObject IN ttHandles.hUtil.
        IF CAN-DO(ttHandles.hUtil:INTERNAL-ENTRIES,"MoveToTop") THEN
          RUN MoveToTop IN ttHandles.hUtil.
        SESSION:SET-WAIT-STATE("").
      END.
      ELSE DO:
        IF CAN-DO(ttHandles.hUtil:INTERNAL-ENTRIES,"MoveToTop") THEN
          RUN MoveToTop IN ttHandles.hUtil.
        ELSE
          ttHandles.hUtil:CURRENT-WINDOW:MOVE-TO-TOP() NO-ERROR.
      END.
    END.
    ELSE RUN VALUE(fiRun).
  END.
//  ELSE RUN VALUE(fiRun).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiRun
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiRun C-Win
ON RETURN OF fiRun IN FRAME DEFAULT-FRAME /* Run */
DO:
  IF SELF:SCREEN-VALUE NE "" THEN DO:
    IF SEARCH(SELF:SCREEN-VALUE) NE ? THEN APPLY "choose" TO btnRun.
    ELSE MESSAGE "Not found"
         VIEW-AS ALERT-BOX.
  END.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME tbAlwaysOnTop
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbAlwaysOnTop C-Win
ON VALUE-CHANGED OF tbAlwaysOnTop IN FRAME DEFAULT-FRAME /* Always on top */
DO:
  THIS-PROCEDURE:CURRENT-WINDOW:ALWAYS-ON-TOP = tbAlwaysOnTop:CHECKED.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  RUN disable_UI.
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).  
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  cmbTool:DELIMITER = ";".
  IF bNoLogin THEN
    cmbTool:LIST-ITEM-PAIRS =
            "Data sources;CreateDataSourceDefinition.w"
          + ";Database Explorer;JBoxDbViewer.w"
          + ";File/API Explorer;JBoxJsonViewer.w"
          + ";Explore TEMP-DIR;ExploreTempDir.p"
          .
  ELSE DO:
    cmbTool:LIST-ITEM-PAIRS =
            "Application compiler;AppComp.w"
/*               + ";Application Client compiler;clientComp.p" */
          + ";Clipboard converter;ClipboardConversion.w"
          + ";Server proc. templates;selectServerTemplate.w"
          + ";Database Explorer;JBoxDbViewer.w"
          + ";Database Views;JBoxViewDsDef.w"
          + ";File/API Explorer;JBoxJsonViewer.w"
          + ";Data sources;CreateDataSourceDefinition.w"
          + ";Explore TEMP-DIR;ExploreTempDir.p"
          + ";Dictionary Viewer;DictView.w"
          + ";Start Viper Designer;startViper"
          + ";Extract images;findImages.w"
//               + ";Find in files;Extractfromfiles.w"
          + ";General code maintenance;JBoxGenCode.w"
          + ";JukeBox Help;startJukeBoxhelp.p"
          + ";Message maintenance;JBoxMessageMaint.w"
          + ";System parameters;JBoxSysParam.w"
//               + ";AB Hack (Sebastien L);protools\abhack\abhackwin.w"
/*               + (IF cAppFarmConnect NE "" THEN*/
/*                  ";AppFarm;JBoxPackage.w"     */
/*                  ELSE "")                     */
/*                + ";"  */
           .

    JBoxSession:Instance:setJBoxAttribute("DbViewerCanUpdate","yes").     
  END.
                 
  cLdb1:SCREEN-VALUE = LDBNAME(1).   

  
  DYNAMIC-FUNCTION("setAttribute",SESSION,"UseAdvGui","yes").                 
  DYNAMIC-FUNCTION("setAttribute",SESSION,"DbViewerCanUpdate","yes").                 
  SUBSCRIBE TO "StartChildWindow" ANYWHERE.
  SUBSCRIBE TO "StartTabWindow"   ANYWHERE.
  SUBSCRIBE TO "StartChildTab"    ANYWHERE.
/*  RUN JBoxRibbonMenu.p PERSIST SET hMenu.                  */
/*  SUBSCRIBE PROCEDURE hMenu TO "StartChildWindow" ANYWHERE.*/
/*  SUBSCRIBE PROCEDURE hMenu TO "StartTabWindow"   ANYWHERE.*/
/*  SUBSCRIBE PROCEDURE hMenu TO "StartChildTab"    ANYWHERE.*/
                 
  APPLY "value-changed" TO tbAlwaysOnTop.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN  
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
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
  DISPLAY cmbTool fiRun tbAlwaysOnTop cLdb1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnRun cmbTool btnExec fiRun btnfiRun tbAlwaysOnTop cLdb1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InvalidateHandle C-Win 
PROCEDURE InvalidateHandle :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihProc AS HANDLE NO-UNDO.

FIND FIRST ttHandles
     WHERE ttHandles.hDataBrw = ihProc
     NO-ERROR.
IF AVAIL ttHandles THEN DO:
  DELETE PROCEDURE ttHandles.hUtil NO-ERROR.
  DELETE ttHandles.
END.  
ELSE DO:
  FIND FIRST ttHandles
       WHERE ttHandles.hUtil = ihProc
       NO-ERROR.
  IF AVAIL ttHandles THEN DO:
    DELETE PROCEDURE ttHandles.hUtil NO-ERROR.
    DELETE ttHandles.
  END.  
END.  

DELETE PROCEDURE hMenu NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartChildTab C-Win 
PROCEDURE StartChildTab :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM icProcName     AS CHAR   NO-UNDO.
DEF INPUT  PARAM icWinTitle     AS CHAR   NO-UNDO.
DEF INPUT  PARAM ihParent       AS HANDLE NO-UNDO.
DEF INPUT  PARAM ibNew          AS LOG    NO-UNDO.
DEF INPUT  PARAM ibCloseTab     AS LOG    NO-UNDO.
DEF INPUT  PARAM icDirection    AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ohWinHandle    AS HANDLE NO-UNDO.

RUN StartChildWindow (icProcName,icWinTitle,ihParent,ibNew,OUTPUT ohWinHandle).        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartChildWindow C-Win 
PROCEDURE StartChildWindow :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEF INPUT  PARAM icProcName      AS CHAR   NO-UNDO.
    DEF INPUT  PARAM icWinTitle     AS CHAR   NO-UNDO.
    DEF INPUT  PARAM ihParent       AS HANDLE NO-UNDO.
    DEF INPUT  PARAM ibNew          AS LOG    NO-UNDO.
    DEF OUTPUT PARAM ohWinHandle    AS HANDLE NO-UNDO.

    DEF VAR ix               AS INT    NO-UNDO.
    DEF VAR hChildProc       AS HANDLE NO-UNDO.
    DEF VAR oParentContainer AS JBoxContainer NO-UNDO.
    DEF VAR oChildContainer  AS JBoxContainer NO-UNDO.
    DEF VAR oObj             AS Progress.Lang.Object NO-UNDO.

    IF SEARCH(icProcName) = ? AND SEARCH(SUBSTR(icProcName,1,LENGTH(icProcName) - 1) + "r") = ? THEN
      RETURN.

    DO ix = 1 TO 20:
      IF cChildProcDev[ix] = icProcName THEN DO:
        hChildProc = hChildProcDev[ix].
        LEAVE.
      END.
    END.

    IF NOT VALID-HANDLE(hChildProc) OR ibNew THEN DO:
      IF ix = 21 THEN
        DO ix = 1 TO 20:
          IF NOT VALID-HANDLE(hChildProcDev[ix]) THEN LEAVE.
        END.

      RUN VALUE(icProcName) PERSIST SET hChildProc.

      IF CAN-DO(hChildProc:INTERNAL-ENTRIES,"setParent") THEN 
        DYNAMIC-FUNCTION("setParent" IN hChildProc,ihParent).

      IF CAN-DO(hChildProc:INTERNAL-ENTRIES,"InitializeObject") THEN DO:
        oObj = SESSION:LAST-OBJECT.
        DO WHILE VALID-OBJECT(oObj):
          IF TYPE-OF(oObj,JBoxContainer) THEN DO:
            oParentContainer = CAST(oObj,JBoxContainer).
            IF oParentContainer:CONTAINER-HANDLE = ihParent THEN LEAVE.
          END.  
          oObj = oObj:PREV-SIBLING.
        END.
        
        IF VALID-HANDLE(ihParent) AND CAN-DO(ihParent:INTERNAL-ENTRIES,"InitializeChild") THEN
          RUN InitializeChild IN ihParent (hChildProc).
        RUN InitializeObject IN hChildProc NO-ERROR.

        IF VALID-OBJECT(oParentContainer) THEN DO:        
          oObj = SESSION:LAST-OBJECT.
          DO WHILE VALID-OBJECT(oObj):
            IF TYPE-OF(oObj,JBoxContainer) THEN DO:
              oChildContainer = CAST(oObj,JBoxContainer).
              IF oChildContainer:CONTAINER-HANDLE = hChildProc THEN DO:
                oChildContainer:PARENT-CONTAINER-OBJECT = oParentContainer.
                oParentContainer:AddSubContainer(oChildContainer).
                SUBSCRIBE PROCEDURE oChildContainer:CONTAINER-HELPER-HANDLE TO "InvalidateHandle" IN oParentContainer:CONTAINER-HANDLE.
                LEAVE.
              END.  
            END.  
            oObj = oObj:PREV-SIBLING.
          END.
        END.
      END. 

      IF CAN-DO(hChildProc:INTERNAL-ENTRIES,"ChangeCompany") THEN
        DYNAMIC-FUNCTION("setCompanyHeader",hChildProc:CURRENT-WINDOW).
      ELSE IF CAN-DO(hChildProc:INTERNAL-ENTRIES,"setWinTitle") THEN
        DYNAMIC-FUNCTION("setWinTitle" IN hChildProc,icWinTitle).
      ELSE
        hChildProc:CURRENT-WINDOW:TITLE = IF icWinTitle NE "" THEN icWinTitle ELSE hChildProc:CURRENT-WINDOW:TITLE.
    END.
    ELSE 
      hChildProc:CURRENT-WINDOW:TITLE = IF icWinTitle NE "" THEN icWinTitle ELSE hChildProc:CURRENT-WINDOW:TITLE.

    IF CAN-DO(hChildProc:INTERNAL-ENTRIES,"MoveToTop") THEN 
      RUN MoveToTop IN hChildProc.
    ELSE DO:
      hChildProc:CURRENT-WINDOW:WINDOW-STATE = 3.
      hChildProc:CURRENT-WINDOW:MOVE-TO-TOP().
    END.

    ohWinHandle = hChildProc.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartTabWindow C-Win 
PROCEDURE StartTabWindow :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM icProcName      AS CHAR   NO-UNDO.
DEF INPUT  PARAM icWinTitle     AS CHAR   NO-UNDO.
DEF INPUT  PARAM ihParent       AS HANDLE NO-UNDO.
DEF INPUT  PARAM ibNew          AS LOG    NO-UNDO.
DEF INPUT  PARAM ibCloseTab     AS LOG    NO-UNDO.
DEF OUTPUT PARAM ohWinHandle    AS HANDLE NO-UNDO.

RUN StartChildWindow (icProcName,icWinTitle,ihParent,ibNew,OUTPUT ohWinHandle).        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startViper C-Win 
PROCEDURE startViper :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR cProwc      AS CHAR NO-UNDO.
  DEF VAR cWorkDir    AS CHAR NO-UNDO.
  DEF VAR oStartInfo  AS System.Diagnostics.ProcessStartInfo NO-UNDO.
  DEF VAR oProcess    AS System.Diagnostics.Process NO-UNDO.
  DEF VAR bOk         AS LOG NO-UNDO.

  IF SEARCH("vfd.pf") = ? THEN DO:
    MESSAGE "Viper designer programs missing from PROPATH" SKIP
      VIEW-AS ALERT-BOX WARNING BUTTONS OK.
    RETURN.
  END.

  FILE-INFO:FILE-NAME = IF SEARCH("prowin32.exe") NE ? THEN SEARCH("prowin32.exe") ELSE SEARCH("prowin.exe"). 
  cProwc = '"' + FILE-INFO:FULL-PATHNAME + '"'.  
  FILE-INFO:FILENAME = SEARCH("vfd.pf").
  cWorkDir = SUBSTR(FILE-INFO:FULL-PATHNAME,1,R-INDEX(FILE-INFO:FULL-PATHNAME,"\")).

  oStartInfo = NEW System.Diagnostics.ProcessStartInfo().
  oStartInfo:FileName = cProwc.
  oStartInfo:Arguments = '-pf vfd.pf -noincrwarn -debugalert -wy -T ' + SESSION:TEMP-DIR.
  oStartInfo:WorkingDirectory = cWorkDir.
  /* optionally obtain access to stdout of the process */
  oStartInfo:UseShellExecute = NO.
  oStartInfo:RedirectStandardOutput = YES.

  oProcess = System.Diagnostics.Process:Start (oStartInfo).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

