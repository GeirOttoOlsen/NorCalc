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


/*** Start instance property definitions for JBoxBrowse object oBrwNPLeveringsbetingelse ***/
DEF VAR oBrwNPLeveringsbetingelse AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPLeveringsbetingelse
    FIELD iNPLeveringsbetingelseId AS integer
    FIELD LeveringsBetingelseKortnavn AS character
    FIELD Leveringsbetingelse AS character
    FIELD LeveringsBetingelseAktiv AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPLeveringsbetingelse FOR TEMP-TABLE NPLeveringsbetingelse.


FUNCTION getBuffersAndFieldsBrwNPLeveringsbetingelse RETURNS CHARACTER():
  RETURN
    'NPLeveringsbetingelse'
     + ';iNPLeveringsbetingelseId'
     + ';LeveringsBetingelseKortnavn'
     + ';Leveringsbetingelse'
     + ';LeveringsBetingelseAktiv'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPLeveringsbetingelse RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPLeveringsbetingelse AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPLeveringsbetingelse AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPLeveringsbetingelse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPLeveringsbetingelse

/* Definitions for BROWSE BrwNPLeveringsbetingelse                      */
&Scoped-define FIELDS-IN-QUERY-BrwNPLeveringsbetingelse ~
NPLeveringsbetingelse.iNPLeveringsbetingelseId ~
NPLeveringsbetingelse.LeveringsBetingelseKortnavn ~
NPLeveringsbetingelse.Leveringsbetingelse ~
NPLeveringsbetingelse.LeveringsBetingelseAktiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPLeveringsbetingelse ~
NPLeveringsbetingelse.iNPLeveringsbetingelseId 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPLeveringsbetingelse ~
NPLeveringsbetingelse
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPLeveringsbetingelse NPLeveringsbetingelse
&Scoped-define QUERY-STRING-BrwNPLeveringsbetingelse FOR EACH NPLeveringsbetingelse NO-LOCK, INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPLeveringsbetingelse OPEN QUERY BrwNPLeveringsbetingelse FOR EACH NPLeveringsbetingelse NO-LOCK, INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPLeveringsbetingelse ~
NPLeveringsbetingelse
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPLeveringsbetingelse NPLeveringsbetingelse


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPLeveringsbetingelse ~
new_tbNPLeveringsbetingelse copy_tbNPLeveringsbetingelse ~
undo_tbNPLeveringsbetingelse save_tbNPLeveringsbetingelse ~
delete_tbNPLeveringsbetingelse refresh_tbNPLeveringsbetingelse ~
BrwNPLeveringsbetingelse iNPLeveringsbetingelseId LeveringsBetingelseAktiv ~
LeveringsBetingelseKortnavn Leveringsbetingelse 
&Scoped-Define DISPLAYED-OBJECTS iNPLeveringsbetingelseId ~
LeveringsBetingelseAktiv LeveringsBetingelseKortnavn Leveringsbetingelse 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPLeveringsbetingelse 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPLeveringsbetingelse 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON new_tbNPLeveringsbetingelse 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPLeveringsbetingelse 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPLeveringsbetingelse 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPLeveringsbetingelse 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE iNPLeveringsbetingelseId AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Lev.bet.Id" 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1.

DEFINE VARIABLE Leveringsbetingelse AS CHARACTER FORMAT "x(100)" 
     LABEL "Lev.betingelse" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1.

DEFINE VARIABLE LeveringsBetingelseKortnavn AS CHARACTER FORMAT "x(10)" 
     LABEL "Kortnavn" 
     VIEW-AS FILL-IN 
     SIZE 15.6 BY 1.

DEFINE RECTANGLE tbNPLeveringsbetingelse
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 131 BY 1.71.

DEFINE VARIABLE LeveringsBetingelseAktiv AS LOGICAL INITIAL no 
     LABEL "Aktiv" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPLeveringsbetingelse FOR 
      NPLeveringsbetingelse SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPLeveringsbetingelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPLeveringsbetingelse C-Win _STRUCTURED
  QUERY BrwNPLeveringsbetingelse NO-LOCK DISPLAY
      NPLeveringsbetingelse.iNPLeveringsbetingelseId COLUMN-LABEL "Lev.bet.Id" FORMAT ">>>9":U
      NPLeveringsbetingelse.LeveringsBetingelseKortnavn COLUMN-LABEL "Kortnavn" FORMAT "x(10)":U
      NPLeveringsbetingelse.Leveringsbetingelse COLUMN-LABEL "Lev.betingelse" FORMAT "x(100)":U
            WIDTH 100
      NPLeveringsbetingelse.LeveringsBetingelseAktiv COLUMN-LABEL "Aktiv" FORMAT "yes/no":U
  ENABLE
      NPLeveringsbetingelse.iNPLeveringsbetingelseId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 61 BY 9.48 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPLeveringsbetingelse AT ROW 1.1 COL 1.2 WIDGET-ID 10
     copy_tbNPLeveringsbetingelse AT ROW 1.1 COL 7.2 WIDGET-ID 12
     undo_tbNPLeveringsbetingelse AT ROW 1.1 COL 13.4 WIDGET-ID 14
     save_tbNPLeveringsbetingelse AT ROW 1.1 COL 19.4 WIDGET-ID 16
     delete_tbNPLeveringsbetingelse AT ROW 1.1 COL 25.6 WIDGET-ID 18
     refresh_tbNPLeveringsbetingelse AT ROW 1.1 COL 31.6 WIDGET-ID 20
     BrwNPLeveringsbetingelse AT ROW 2.91 COL 1 WIDGET-ID 200
     iNPLeveringsbetingelseId AT ROW 3 COL 77 COLON-ALIGNED
     LeveringsBetingelseAktiv AT ROW 3 COL 95 WIDGET-ID 22
     LeveringsBetingelseKortnavn AT ROW 4 COL 77 COLON-ALIGNED
     Leveringsbetingelse AT ROW 5.05 COL 77 COLON-ALIGNED
     tbNPLeveringsbetingelse AT ROW 1 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 131.6 BY 11.38 WIDGET-ID 100.


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
         HEIGHT             = 11.33
         WIDTH              = 131.6
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 131.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 131.6
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
/* BROWSE-TAB BrwNPLeveringsbetingelse refresh_tbNPLeveringsbetingelse DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 11.38
       FRAME DEFAULT-FRAME:WIDTH            = 131.6.

ASSIGN 
       tbNPLeveringsbetingelse:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refreshmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPLeveringsbetingelse
/* Query rebuild information for BROWSE BrwNPLeveringsbetingelse
     _TblList          = "norcalc.NPLeveringsbetingelse"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPLeveringsbetingelse.iNPLeveringsbetingelseId
"NPLeveringsbetingelse.iNPLeveringsbetingelseId" "Lev.bet.Id" ">>>9" "integer" ? ? ? ? ? ? yes "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPLeveringsbetingelse.LeveringsBetingelseKortnavn
"NPLeveringsbetingelse.LeveringsBetingelseKortnavn" "Kortnavn" "x(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPLeveringsbetingelse.Leveringsbetingelse
"NPLeveringsbetingelse.Leveringsbetingelse" "Lev.betingelse" "x(100)" "character" ? ? ? ? ? ? no "" no no "100" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPLeveringsbetingelse.LeveringsBetingelseAktiv
"NPLeveringsbetingelse.LeveringsBetingelseAktiv" "Aktiv" "yes/no" "logical" ? ? ? ? ? ? no "" no no "23.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPLeveringsbetingelse */
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


&Scoped-define BROWSE-NAME BrwNPLeveringsbetingelse
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
{incl/conttrigg.i oBrwNPLeveringsbetingelse:BROWSE-HANDLE}

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
  DISPLAY iNPLeveringsbetingelseId LeveringsBetingelseAktiv 
          LeveringsBetingelseKortnavn Leveringsbetingelse 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPLeveringsbetingelse new_tbNPLeveringsbetingelse 
         copy_tbNPLeveringsbetingelse undo_tbNPLeveringsbetingelse 
         save_tbNPLeveringsbetingelse delete_tbNPLeveringsbetingelse 
         refresh_tbNPLeveringsbetingelse BrwNPLeveringsbetingelse 
         iNPLeveringsbetingelseId LeveringsBetingelseAktiv 
         LeveringsBetingelseKortnavn Leveringsbetingelse 
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

  iDetailMoveX = brwNPLeveringsbetingelse:X + brwNPLeveringsbetingelse:WIDTH-PIXELS.
  oBrwNPLeveringsbetingelse = NEW JBoxBrowse(brwNPLeveringsbetingelse:HANDLE).
  oBrwNPLeveringsbetingelse:CreateGridFilter("").
  oBrwNPLeveringsbetingelse:setQuerySort("iNPLeveringsbetingelseId").
  
  oFmNPLeveringsbetingelse = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPLeveringsbetingelse:updateFields = 'LeveringsBetingelseKortnavn,Leveringsbetingelse,LeveringsbetingelseAktiv'.
  oFmNPLeveringsbetingelse:DisplayFields = 'iNPLeveringsbetingelseId'.
  
  oFmNPLeveringsbetingelse:BROWSE-OBJECT = oBrwNPLeveringsbetingelse.
  otbNPLeveringsbetingelse = NEW JBoxToolbar(tbNPLeveringsbetingelse:HANDLE).
  oBrwNPLeveringsbetingelse:TOOLBAR-OBJECT = otbNPLeveringsbetingelse.
  oFmNPLeveringsbetingelse:TOOLBAR-OBJECT = otbNPLeveringsbetingelse.
END.
oBrwNPLeveringsbetingelse:OpenQuery().


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

