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

DEF VAR oQryViewDs  AS JBoxQuery NO-UNDO.
DEF VAR oFmViewDs   AS JBoxFieldMap NO-UNDO.

{tt_schema.i}

{incl/tt_viewds.i}

DEF VAR hbSourceTtView   AS HANDLE NO-UNDO.
DEF VAR hbSourceTtFilter AS HANDLE NO-UNDO.
DEF VAR hTab1            AS HANDLE NO-UNDO.

DEF VAR otbScript AS JBoxToolbar NO-UNDO.
DEF VAR cWebRestHost AS CHAR NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnScriptName tbScript save_tbScript ~
undo_tbScript ViewScript_tbScript SourceName cSourceHost ViewDsName ~
ViewDsDesc ViewFileName ConnectionFile ScriptFilterName ScriptType ~
btnScriptOutputDir ScriptName ScriptOutputDir ScriptOutputType 
&Scoped-Define DISPLAYED-OBJECTS SourceName cSourceHost ViewDsName ~
ViewDsDesc ViewFileName ConnectionFile ScriptFilterName ScriptType ~
ScriptName ScriptOutputDir ScriptOutputType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnScriptName 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btnScriptOutputDir 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON save_tbScript 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbScript 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Angre (CTRL-Z)".

DEFINE BUTTON ViewScript_tbScript 
     LABEL "View script" 
     SIZE 12 BY 1.1 TOOLTIP "View script".

DEFINE VARIABLE ScriptOutputType AS CHARACTER FORMAT "X(256)":U INITIAL "TxtT" 
     LABEL "Output type" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Csv (semicolon-sep)","Csv",
                     "Csv (pipe-separator)","CsvP",
                     "Json","Json",
                     "Txt (tab-separator)","TxtT",
                     "Txt (pipe-separator)","TxtP",
                     "XML","XML"
     DROP-DOWN-LIST
     SIZE 24.4 BY 1 TOOLTIP "Csv uses iso-date (yyyy-mm-dd) and represents unknown date values as NULL" NO-UNDO.

DEFINE VARIABLE ScriptType AS CHARACTER FORMAT "X(256)":U INITIAL "Bat" 
     LABEL "Script type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Bat","Curl" 
     DROP-DOWN-LIST
     SIZE 24.4 BY 1 NO-UNDO.

DEFINE VARIABLE ConnectionFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Connection file" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 TOOLTIP "The connection file can be omitted for batch scripts if connect on startup" NO-UNDO.

DEFINE VARIABLE cSourceHost AS CHARACTER FORMAT "X(256)":U 
     LABEL "Host" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE ScriptFilterName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Filter setting" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE ScriptName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Script" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE ScriptOutputDir AS CHARACTER FORMAT "X(256)":U 
     LABEL "Output to" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 TOOLTIP "Output directory or file for result-set" NO-UNDO.

DEFINE VARIABLE SourceName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Data source" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE ViewDsDesc AS CHARACTER FORMAT "X(256)":U 
     LABEL "Description" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE ViewDsName AS CHARACTER FORMAT "X(256)":U 
     LABEL "View name" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 NO-UNDO.

DEFINE VARIABLE ViewFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "View definition file" 
     VIEW-AS FILL-IN 
     SIZE 60 BY 1 TOOLTIP "The view-definition file is mandatory for batch scripts" NO-UNDO.

DEFINE RECTANGLE tbScript
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 82.6 BY 1.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnScriptName AT ROW 12.24 COL 80 WIDGET-ID 14 NO-TAB-STOP 
     save_tbScript AT ROW 1.33 COL 2.6 WIDGET-ID 4
     undo_tbScript AT ROW 1.33 COL 7.4 WIDGET-ID 6
     ViewScript_tbScript AT ROW 1.33 COL 12 WIDGET-ID 18
     SourceName AT ROW 2.91 COL 18 COLON-ALIGNED
     cSourceHost AT ROW 3.95 COL 18 COLON-ALIGNED
     ViewDsName AT ROW 5 COL 18 COLON-ALIGNED
     ViewDsDesc AT ROW 6.05 COL 18 COLON-ALIGNED
     ViewFileName AT ROW 7.1 COL 18 COLON-ALIGNED
     ConnectionFile AT ROW 8.14 COL 18 COLON-ALIGNED
     ScriptFilterName AT ROW 9.62 COL 18 COLON-ALIGNED
     ScriptType AT ROW 11.19 COL 18 COLON-ALIGNED WIDGET-ID 12
     btnScriptOutputDir AT ROW 13.29 COL 80 WIDGET-ID 16 NO-TAB-STOP 
     ScriptName AT ROW 12.24 COL 18 COLON-ALIGNED
     ScriptOutputDir AT ROW 13.29 COL 18 COLON-ALIGNED
     ScriptOutputType AT ROW 14.33 COL 18 COLON-ALIGNED WIDGET-ID 8
     tbScript AT ROW 1.24 COL 2.4 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 85.6 BY 14.76 WIDGET-ID 100.


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
         HEIGHT             = 14.76
         WIDTH              = 85.6
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
       FRAME DEFAULT-FRAME:HEIGHT           = 14.76
       FRAME DEFAULT-FRAME:WIDTH            = 85.6.

ASSIGN 
       ConnectionFile:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

ASSIGN 
       ScriptOutputType:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "TxtT".

ASSIGN 
       ScriptType:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Bat".

ASSIGN 
       tbScript:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "save;Lagre,undo;Angre,ViewScript;View scripthide".

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


&Scoped-define SELF-NAME btnScriptName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnScriptName C-Win
ON CHOOSE OF btnScriptName IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = ScriptName:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cUseFileName
         FILTERS "batch files" "*.bat"
         USE-FILENAME UPDATE bOk.
  IF bOk THEN DO: 
    ScriptName:SCREEN-VALUE = cUseFileName + (IF NOT cUseFileName MATCHES "*.bat" THEN ".bat" ELSE "").  
    APPLY "any-printable" TO ScriptName.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnScriptOutputDir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnScriptOutputDir C-Win
ON CHOOSE OF btnScriptOutputDir IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = ScriptOutputDir:SCREEN-VALUE.

  SYSTEM-DIALOG GET-DIR cUseFileName UPDATE bOk.
  IF bOk THEN DO:
    ScriptOutputDir:SCREEN-VALUE = cUseFileName.
    APPLY "any-printable" TO ScriptOutputDir.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
otbScript:disabledTools = IF AVAIL ttViewDs AND ttViewDs.ScriptName = "" THEN "viewScript,runScript" ELSE "".
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
  DISPLAY SourceName cSourceHost ViewDsName ViewDsDesc ViewFileName 
          ConnectionFile ScriptFilterName ScriptType ScriptName ScriptOutputDir 
          ScriptOutputType 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnScriptName tbScript save_tbScript undo_tbScript ViewScript_tbScript 
         SourceName cSourceHost ViewDsName ViewDsDesc ViewFileName 
         ConnectionFile ScriptFilterName ScriptType btnScriptOutputDir 
         ScriptName ScriptOutputDir ScriptOutputType 
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
  oQryViewDs = NEW JBoxQuery(BUFFER ttViewDs:HANDLE).
  oQryViewDs:useLocalData = yes.

  oFmViewDs = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmViewDs:QUERY-OBJECT = oQryViewDs.
  oFmViewDs:updateFields = "ScriptType,ScriptName,ScriptOutputDir,ScriptOutputType".
  oFmViewDs:displayFields = "SourceName,ViewDsName,ViewDsDesc,ViewFileName,ScriptFilterName,cSourceHost".

  otbScript = NEW JBoxToolbar(tbScript:HANDLE).

  oQryViewDs:TOOLBAR-OBJECT = otbScript.
  oFmViewDs:TOOLBAR-OBJECT = otbScript.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:setAddResizeX("ConnectionFile,cSettingName,ScriptName,ScriptOutputDir,SourceName,ViewDsDesc,ViewDsName,ViewFileName,ScriptFilterName,cSourceHost").
  oContainer:initResize(100,1000).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE runScriptRecord C-Win 
PROCEDURE runScriptRecord :
IF SEARCH(ttViewDs.ScriptName) NE ? THEN  
  OS-COMMAND NO-WAIT VALUE(ttViewDs.scriptname).
ELSE
  MESSAGE "Script file not available"
          VIEW-AS ALERT-BOX.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
DEF VAR cSqlConnections AS CHAR NO-UNDO.
  DEF VAR cUseSqlConn     AS CHAR NO-UNDO.
  DEF VAR ix              AS INT  NO-UNDO.

  IF ViewFileName:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" AND ScriptType:SCREEN-VALUE = "bat" THEN DO:
    MESSAGE "View definition must be saved to file (that can be referenced by the batch script)"
    VIEW-AS ALERT-BOX.
    RETURN.
  END.
  
  RUN SUPER.

  DO WITH FRAME {&FRAME-NAME}:
    cSqlConnections = JBoxSession:Instance:getJBoxAttribute("SqlDbList").
    DO ix = 1 TO NUM-ENTRIES(cSqlConnections):
      IF ENTRY(1,ENTRY(ix,cSqlConnections),"|") = ttViewDs.SourceName THEN
        cUseSqlConn = ENTRY(ix,cSqlConnections).
    END.  
    
    IF ttViewDs.ScriptName NE "" THEN DO:
      OUTPUT TO VALUE(ttViewDs.ScriptName).
      IF ScriptType:SCREEN-VALUE = "bat" THEN
        PUT UNFORMATTED 
            ENTRY(1,System.Environment:CurrentDirectory,":") ":" SKIP
            "cd " System.Environment:CurrentDirectory SKIP
            DYNAMIC-FUNCTION("getMyCommandLine") 
            " -p jbox_run_viewds_script.p"
            ' -param "'
            ttViewDs.ViewFileName "^"
            ttViewDs.ViewDsId "^"
            ConnectionFile:SCREEN-VALUE "^"
            ttViewDs.ScriptFilterId "^"
            ENTRY(1,SESSION:PARAM,";") "^"
            cUseSqlConn 
            '"' 
            SKIP.
      ELSE     
        PUT UNFORMATTED
            'curl -X POST -URL "'
            TRIM(REPLACE(REPLACE(cSourceHost:SCREEN-VALUE,"apsv","web"),"-URL","")) '/jboxrest.p" '
            '-H "Content-Type: application/json" '
            '-d "@' REPLACE(ttViewDs.ScriptName,".bat",".txt") '" '
            '> ' TRIM(ScriptOutputDir:SCREEN-VALUE,"\/") + "\" + ttViewDs.ViewDsName + ".json"
            SKIP. 
      OUTPUT CLOSE.
      
      IF ScriptType:SCREEN-VALUE = "curl" THEN DO:
        OUTPUT TO VALUE(REPLACE(ttViewDs.ScriptName,".bat",".txt")).  
        PUT UNFORMATTED DYNAMIC-FUNCTION("getApiParams" IN hTab1,ttViewDs.ScriptFilterId,NO).
        OUTPUT CLOSE.
      END.        
    END.    
  END.
  
  IF VALID-HANDLE(hbSourceTtFilter) THEN
    hbSourceTtFilter:BUFFER-COPY(BUFFER ttViewDs:HANDLE).
  ELSE
    hbSourceTtView:BUFFER-COPY(BUFFER ttViewDs:HANDLE).
  
  PUBLISH "replaceViewDs".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetParameters C-Win 
PROCEDURE SetParameters :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF PARAMETER BUFFER tt_db FOR TEMP-TABLE tt_db.
DEF INPUT PARAM ihbViewDs  AS HANDLE NO-UNDO.
DEF INPUT PARAM ihbFilter  AS HANDLE NO-UNDO. // i.e user settings
DEF INPUT PARAM ihTab1     AS HANDLE NO-UNDO.

EMPTY TEMP-TABLE ttViewDs.
CREATE ttViewDs.
BUFFER ttViewDs:BUFFER-COPY(ihbViewDs).
IF VALID-HANDLE(ihbFilter) THEN
  BUFFER ttViewDs:BUFFER-COPY(ihbFilter).

hbSourceTtView = ihbViewDs.
hbSourceTtFilter = ihbFilter.
hTab1 = ihTab1.

ASSIGN ConnectionFile:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt_db.cConnection
       cSourceHost = tt_db.cSourceHost
       cSourceHost:SCREEN-VALUE = tt_db.cSourceHost. 
IF tt_db.cConnection = "" THEN
  ConnectionFile:SCREEN-VALUE = "<startup>".

 cWebRestHost = JBoxSession:Instance:getJBoxAttribute("JBrestHost").
 IF cWebRestHost = "" THEN
   cWebRestHost = REPLACE(tt_db.cSourceHost,"apsv","web").

IF ttViewDs.SourceType = "ProgressApsv" OR cWebRestHost NE "" THEN
  ScriptType:LIST-ITEMS = "bat,curl".
ELSE
  ScriptType:LIST-ITEMS = "bat".

ScriptType:SCREEN-VALUE = "bat".

oQryViewDs:openQuery().

IF ScriptType:SCREEN-VALUE = "curl" AND cWebRestHost NE "" THEN
  cSourceHost:SCREEN-VALUE = cWebRestHost.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValueChangedField C-Win 
PROCEDURE ValueChangedField :
DEF INPUT PARAM icFieldName   AS CHAR NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  CASE icFieldName:
    WHEN "ScriptType" THEN DO:
      IF ScriptType:SCREEN-VALUE = "curl" THEN DO:
        ASSIGN ScriptOutputType:SCREEN-VALUE = "json"
               ScriptOutputType:SENSITIVE = NO.
        IF cWebRestHost NE "" THEN
          cSourceHost:SCREEN-VALUE = cWebRestHost.
        ELSE 
          cSourceHost:SCREEN-VALUE = cSourceHost.       
      END.         
      ELSE 
        ASSIGN ScriptOutputType:SENSITIVE = YES
               cSourceHost:SCREEN-VALUE = cSourceHost.       
    END.
  END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewScriptRecord C-Win 
PROCEDURE ViewScriptRecord :
DEF VAR oCmd AS JBoxCmd NO-UNDO.  
IF SEARCH(ttViewDs.ScriptName) NE ? THEN DO:
  oCmd = NEW JBoxCmd("notepad.exe",ttViewDs.scriptname). 
//  OS-COMMAND NO-WAIT VALUE("notepad " + ttViewDs.scriptname).
  IF SEARCH(REPLACE(ttViewDs.ScriptName,".bat",".txt")) NE ? THEN
    oCmd = NEW JBoxCmd("notepad.exe",REPLACE(ttViewDs.ScriptName,".bat",".txt")). 
END.  
ELSE
  MESSAGE "Script file not available"
          VIEW-AS ALERT-BOX.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

