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
&SCOPED-DEFINE AdvGuiWin

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR hFieldMap   AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHFORSTILLING ***/
DEF VAR oBrwNPSHFORSTILLING AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHFORSTILLING
    FIELD id AS integer
    FIELD forstillingsorgan AS character
    FIELD shForstillingAktiv AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHFORSTILLING FOR TEMP-TABLE NPSHFORSTILLING.


FUNCTION getBuffersAndFieldsBrwNPSHFORSTILLING RETURNS CHARACTER():
  RETURN
    'NPSHFORSTILLING'
     + ';id'
     + ';forstillingsorgan'
     + ';shForstillingAktiv'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHFORSTILLING RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPSHFORSTILLING AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHFORSTILLING

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHFORSTILLING

/* Definitions for BROWSE BrwNPSHFORSTILLING                            */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHFORSTILLING NPSHFORSTILLING.id ~
NPSHFORSTILLING.forstillingsorgan NPSHFORSTILLING.shForstillingAktiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHFORSTILLING ~
NPSHFORSTILLING.id 
&Scoped-define QUERY-STRING-BrwNPSHFORSTILLING FOR EACH NPSHFORSTILLING NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHFORSTILLING OPEN QUERY BrwNPSHFORSTILLING FOR EACH NPSHFORSTILLING NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHFORSTILLING NPSHFORSTILLING
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHFORSTILLING NPSHFORSTILLING


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHFORSTILLING new_tbNPSHFORSTILLING ~
copy_tbNPSHFORSTILLING undo_tbNPSHFORSTILLING save_tbNPSHFORSTILLING ~
delete_tbNPSHFORSTILLING refresh_tbNPSHFORSTILLING filter_tbNPSHFORSTILLING ~
excel_tbNPSHFORSTILLING fcSearch BrwNPSHFORSTILLING shForstillingAktiv id ~
forstillingsorgan 
&Scoped-Define DISPLAYED-OBJECTS fcSearch shForstillingAktiv id ~
forstillingsorgan 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/documents.ico":U
     IMAGE-INSENSITIVE FILE "gif/documents_disabled.gif":U
     LABEL "Copy" 
     SIZE 7.8 BY 1.95 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/document_delete.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_delete_disabled.gif":U
     LABEL "Delete" 
     SIZE 7.8 BY 1.95 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/document_add.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_add_disabled.gif":U
     LABEL "New" 
     SIZE 7.8 BY 1.95 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "gif/floppy_disk_disabled.gif":U
     LABEL "Save" 
     SIZE 7.8 BY 1.95 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPSHFORSTILLING 
     IMAGE-UP FILE "ico/undo.ico":U
     IMAGE-INSENSITIVE FILE "gif/undo_disabled.gif":U
     LABEL "Undo" 
     SIZE 7.8 BY 1.95 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE fcSearch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE forstillingsorgan AS CHARACTER FORMAT "X(30)" 
     LABEL "Forstillingsorgan" 
     VIEW-AS FILL-IN 
     SIZE 64 BY 1.

DEFINE VARIABLE id AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Id" 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1.

DEFINE RECTANGLE tbNPSHFORSTILLING
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 161 BY 2.14.

DEFINE VARIABLE shForstillingAktiv AS LOGICAL INITIAL no 
     LABEL "Aktiv" 
     VIEW-AS TOGGLE-BOX
     SIZE 8.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHFORSTILLING FOR 
      NPSHFORSTILLING SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHFORSTILLING
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHFORSTILLING C-Win _STRUCTURED
  QUERY BrwNPSHFORSTILLING NO-LOCK DISPLAY
      NPSHFORSTILLING.id COLUMN-LABEL "id" FORMAT ">>>9":U
      NPSHFORSTILLING.forstillingsorgan COLUMN-LABEL "Forst. org" FORMAT "X(30)":U
            WIDTH 54.8
      NPSHFORSTILLING.shForstillingAktiv COLUMN-LABEL "shForstillingAktiv" FORMAT "yes/no":U
            WIDTH 15.6
  ENABLE
      NPSHFORSTILLING.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 65 BY 8.1 ROW-HEIGHT-CHARS .71 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHFORSTILLING AT ROW 1.1 COL 1.2 WIDGET-ID 8
     copy_tbNPSHFORSTILLING AT ROW 1.1 COL 9.2 WIDGET-ID 10
     undo_tbNPSHFORSTILLING AT ROW 1.1 COL 17 WIDGET-ID 12
     save_tbNPSHFORSTILLING AT ROW 1.1 COL 24.8 WIDGET-ID 14
     delete_tbNPSHFORSTILLING AT ROW 1.1 COL 32.6 WIDGET-ID 16
     refresh_tbNPSHFORSTILLING AT ROW 1.1 COL 40.4 WIDGET-ID 18
     filter_tbNPSHFORSTILLING AT ROW 1.1 COL 48.2 WIDGET-ID 22
     excel_tbNPSHFORSTILLING AT ROW 1.1 COL 56 WIDGET-ID 20
     fcSearch AT ROW 3.38 COL 2 NO-LABEL
     BrwNPSHFORSTILLING AT ROW 4.57 COL 1 WIDGET-ID 200
     shForstillingAktiv AT ROW 4.81 COL 85 WIDGET-ID 24
     id AT ROW 5.76 COL 83 COLON-ALIGNED
     forstillingsorgan AT ROW 6.76 COL 83 COLON-ALIGNED
     tbNPSHFORSTILLING AT ROW 1 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 161 BY 11.76 WIDGET-ID 100.


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
         HEIGHT             = 11.76
         WIDTH              = 161
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 161
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 161
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
/* BROWSE-TAB BrwNPSHFORSTILLING fcSearch DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 11.76
       FRAME DEFAULT-FRAME:WIDTH            = 161.

/* SETTINGS FOR FILL-IN fcSearch IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbNPSHFORSTILLING:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHFORSTILLING
/* Query rebuild information for BROWSE BrwNPSHFORSTILLING
     _TblList          = "norcalc.NPSHFORSTILLING"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHFORSTILLING.id" "id" ">>>9" "integer" ? ? ? ? ? ? yes "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHFORSTILLING.forstillingsorgan" "Forst. org" "X(30)" "character" ? ? ? ? ? ? no "" no no "54.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHFORSTILLING.shForstillingAktiv" "shForstillingAktiv" "yes/no" "logical" ? ? ? ? ? ? no "" no no "15.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHFORSTILLING */
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


&Scoped-define BROWSE-NAME BrwNPSHFORSTILLING
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
{incl/conttrigg.i oBrwNPSHFORSTILLING:BROWSE-HANDLE}

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
  DISPLAY fcSearch shForstillingAktiv id forstillingsorgan 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHFORSTILLING new_tbNPSHFORSTILLING copy_tbNPSHFORSTILLING 
         undo_tbNPSHFORSTILLING save_tbNPSHFORSTILLING delete_tbNPSHFORSTILLING 
         refresh_tbNPSHFORSTILLING filter_tbNPSHFORSTILLING 
         excel_tbNPSHFORSTILLING fcSearch BrwNPSHFORSTILLING shForstillingAktiv 
         id forstillingsorgan 
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
DEFINE VARIABLE iDetailMoveX AS INTEGER NO-UNDO.

RUN enable_UI.

oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

DO WITH FRAME {&FRAME-NAME}:

  iDetailMoveX = brwNPSHFORSTILLING:X + brwNPSHFORSTILLING:WIDTH-PIXELS.
  oBrwNPSHFORSTILLING = NEW JBoxBrowse(brwNPSHFORSTILLING:HANDLE).
  oBrwNPSHFORSTILLING:customDeleteValProc = 'ignore'.
  oBrwNPSHFORSTILLING:setSearchField(fcSearch:handle).
  
  oFmNPSHFORSTILLING = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHFORSTILLING:updateFields = 'shForstillingAktiv,forstillingsorgan'.
  oFmNPSHFORSTILLING:displayFields = 'id'.
  
  oFmNPSHFORSTILLING:BROWSE-OBJECT = oBrwNPSHFORSTILLING.
  NorcalcBrowseWindow:ConnectToolbar(THIS-PROCEDURE, tbNPSHFORSTILLING:HANDLE, oBrwNPSHFORSTILLING, oFmNPSHFORSTILLING).
END.
oBrwNPSHFORSTILLING:OpenQuery().


oContainer:initResize(iDetailMoveX, 200).

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

