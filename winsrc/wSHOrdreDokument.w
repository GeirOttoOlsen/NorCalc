&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
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
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR hFieldMap   AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

DEFINE TEMP-TABLE ttDoc NO-UNDO
  FIELD iFileNum        AS INTEGER
  FIELD cFileName       AS CHARACTER
  FIELD cFullPathName   AS CHARACTER
  FIELD cFileType       AS CHARACTER
  FIELD cDescription    AS CHARACTER
  FIELD iDocSize        AS INTEGER
  FIELD blDocument      AS BLOB
  FIELD dFileCreateDate AS DATE
  FIELD iFileCreateTime AS INTEGER
  FIELD dFileModDate    AS DATE
  FIELD iFileModTime    AS INTEGER
  FIELD cCreatedBy      AS CHARACTER
  FIELD dCreated        AS DATE
  FIELD cContext        AS CHARACTER
  FIELD cEntityId       AS CHARACTER
  FIELD iSeq            AS INTEGER
  INDEX iFileNum IS PRIMARY UNIQUE iFileNum 
  .
/*** Start instance property definitions for JBoxBrowse object oBrwJBoxDocRel ***/
DEF VAR oBrwJBoxDocRel AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE JBoxDocRel
    FIELD iJBoxDocRelId AS integer
    FIELD cEntityId AS character
    FIELD cContext AS character
    FIELD iJBoxDocumentId AS integer
    FIELD cFileName AS character
    FIELD cFileType AS character
    FIELD iDocSize AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_JBoxDocRel FOR TEMP-TABLE JBoxDocRel.


FUNCTION getBuffersAndFieldsBrwJBoxDocRel RETURNS CHARACTER():
  RETURN
    'JBoxDocRel'
     + ';iJBoxDocRelId'
     + ';cEntityId'
     + ';cContext'
     + ';iJBoxDocumentId'
  + ',JBoxDocument'
     + ';cFileName'
     + ';cFileType'
     + ';iDocSize'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwJBoxDocRel RETURNS CHARACTER():
  RETURN 'EACH JBoxDocument OF JBoxDocRel NO-LOCK'.
END FUNCTION.
DEF VAR otbNPJBoxDocRel AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwJBoxDocRel

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES JBoxDocRel

/* Definitions for BROWSE BrwJBoxDocRel                                 */
&Scoped-define FIELDS-IN-QUERY-BrwJBoxDocRel JBoxDocRel.iJBoxDocRelId ~
JBoxDocRel.cEntityId JBoxDocRel.cContext JBoxDocRel.iJBoxDocumentId ~
JBoxDocRel.cFileName JBoxDocRel.cFileType JBoxDocRel.iDocSize 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwJBoxDocRel ~
JBoxDocRel.iJBoxDocRelId 
&Scoped-define QUERY-STRING-BrwJBoxDocRel FOR EACH JBoxDocRel NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwJBoxDocRel OPEN QUERY BrwJBoxDocRel FOR EACH JBoxDocRel NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwJBoxDocRel JBoxDocRel
&Scoped-define FIRST-TABLE-IN-QUERY-BrwJBoxDocRel JBoxDocRel


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPJBoxDocRel delete_tbNPJBoxDocRel ~
refresh_tbNPJBoxDocRel filter_tbNPJBoxDocRel browseconfig_tbNPJBoxDocRel ~
excel_tbNPJBoxDocRel BrwJBoxDocRel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPJBoxDocRel 
     IMAGE-UP FILE "img/ico/table.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/table_disabled.gif":U
     LABEL "Column setup" 
     SIZE 7.8 BY 1.95 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON delete_tbNPJBoxDocRel 
     IMAGE-UP FILE "img/ico/document_delete.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_delete_disabled.gif":U
     LABEL "Delete" 
     SIZE 7.8 BY 1.95 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbNPJBoxDocRel 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPJBoxDocRel 
     IMAGE-UP FILE "img/ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPJBoxDocRel 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPJBoxDocRel
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 119 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwJBoxDocRel FOR 
      JBoxDocRel SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwJBoxDocRel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwJBoxDocRel C-Win _STRUCTURED
  QUERY BrwJBoxDocRel NO-LOCK DISPLAY
      JBoxDocRel.iJBoxDocRelId COLUMN-LABEL "DocRel id" FORMAT "->,>>>,>>9":U
      JBoxDocRel.cEntityId COLUMN-LABEL "Entity id" FORMAT "x(20)":U
      JBoxDocRel.cContext COLUMN-LABEL "Context" FORMAT "x(30)":U
      JBoxDocRel.iJBoxDocumentId COLUMN-LABEL "Document id" FORMAT "->,>>>,>>9":U
      JBoxDocRel.cFileName COLUMN-LABEL "Filnavn" FORMAT "X(60)":U
      JBoxDocRel.cFileType COLUMN-LABEL "Type" FORMAT "X(8)":U
      JBoxDocRel.iDocSize COLUMN-LABEL "Filstørrelse" FORMAT "->>>,>>>,>>9":U
  ENABLE
      JBoxDocRel.iJBoxDocRelId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS DROP-TARGET SIZE 120 BY 16.19 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     delete_tbNPJBoxDocRel AT ROW 1.1 COL 1.2 WIDGET-ID 12
     refresh_tbNPJBoxDocRel AT ROW 1.1 COL 9.2 WIDGET-ID 4
     filter_tbNPJBoxDocRel AT ROW 1.1 COL 17 WIDGET-ID 6
     browseconfig_tbNPJBoxDocRel AT ROW 1.1 COL 24.8 WIDGET-ID 8
     excel_tbNPJBoxDocRel AT ROW 1.1 COL 32.6 WIDGET-ID 10
     BrwJBoxDocRel AT ROW 3.38 COL 1 WIDGET-ID 200
     tbNPJBoxDocRel AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 120 BY 18.57 WIDGET-ID 100.


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
         HEIGHT             = 18.57
         WIDTH              = 120
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 120
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 120
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
/* BROWSE-TAB BrwJBoxDocRel excel_tbNPJBoxDocRel DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 18.57
       FRAME DEFAULT-FRAME:WIDTH            = 120.

ASSIGN 
       tbNPJBoxDocRel:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "delete;Delete,refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwJBoxDocRel
/* Query rebuild information for BROWSE BrwJBoxDocRel
     _TblList          = "norcalc.JBoxDocRel"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"JBoxDocRel.iJBoxDocRelId" "DocRel id" "->,>>>,>>9" "integer" ? ? ? ? ? ? yes "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"JBoxDocRel.cEntityId" "Entity id" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"JBoxDocRel.cContext" "Context" "x(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"JBoxDocRel.iJBoxDocumentId" "Document id" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"JBoxDocRel.cFileName" "Filnavn" "X(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"JBoxDocRel.cFileType" "Type" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"JBoxDocRel.iDocSize" "Filstørrelse" "->>>,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "12.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwJBoxDocRel */
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


&Scoped-define BROWSE-NAME BrwJBoxDocRel
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
END.

{incl/wintrigg.i}
{incl/conttrigg.i oBrwJBoxDocRel:BROWSE-HANDLE}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DropFileNotifyBrowse C-Win 
PROCEDURE DropFileNotifyBrowse :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def var i as int no-undo.
def var cFilename as char no-undo.

do i = 1 to oBrwJBoxDocRel:BROWSE-HANDLE:Num-dropped-files:
   cFilename           = oBrwJBoxDocRel:BROWSE-HANDLE:get-dropped-file(i).
   file-info:file-name = cFilename.
   create ttDoc.
   Assign 
     ix              = ix + 1
     ttDoc.iSeq      = ix
     ttDoc.iFileNum  = ix
     ttDoc.cContext  = oBrwJBoxDocRel:PARENT-BUFFER-HANDLE:name
     ttDoc.cEntityId = oBrwJBoxDocRel:PARENT-BUFFER-HANDLE::ordreid
     ttDoc.cFileName = substring(cFilename,r-index(cFilename,'\') + 1)
     ttDoc.cFileType = entry(2,ttDoc.cFilename,'.')
     ttDoc.iDocSize  = file-info:FILE-SIZE
     ttDoc.cFullPathName = cFilename
     
   .
   MESSAGE ttDoc.cContext skip ttDoc.cEntityId
   VIEW-AS ALERT-BOX.
   copy-lob file cFilename to object ttDoc.blDocument. 
end.
if not JBoxServerAPI:Instance:CallServerProc('add_document.p','validsession',buffer ttDoc:handle) then JBoxServerAPI:Instance:viewCallMessage().
empty temp-table ttDoc.
oBrwJBoxDocRel:refresh().
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
  ENABLE tbNPJBoxDocRel delete_tbNPJBoxDocRel refresh_tbNPJBoxDocRel 
         filter_tbNPJBoxDocRel browseconfig_tbNPJBoxDocRel excel_tbNPJBoxDocRel 
         BrwJBoxDocRel 
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
RUN enable_UI.

oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

DO WITH FRAME {&FRAME-NAME}:

  oBrwJBoxDocRel = NEW JBoxBrowse(brwJBoxDocRel:HANDLE).

  otbNPJBoxDocRel = NEW JBoxToolbar(tbNPJBoxDocRel:HANDLE).

  oBrwJBoxDocRel:TOOLBAR-OBJECT = otbNPJBoxDocRel.
END.
oBrwJBoxDocRel:OpenQuery().


oContainer:initResize().

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

