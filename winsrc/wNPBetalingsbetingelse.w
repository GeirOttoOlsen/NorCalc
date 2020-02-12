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


/*** Start instance property definitions for JBoxBrowse object oBrwNPBetalingsbetingelse ***/
DEF VAR oBrwNPBetalingsbetingelse AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPBetalingsbetingelse
    FIELD iNPBetalingsbetingelseId AS integer
    FIELD BetalingsbetingelseAktiv AS log
    FIELD BetalingsbetingelseKortnavn AS character
    FIELD Betalingsbetingelse AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPBetalingsbetingelse FOR TEMP-TABLE NPBetalingsbetingelse.


FUNCTION getBuffersAndFieldsBrwNPBetalingsbetingelse RETURNS CHARACTER():
  RETURN
    'NPBetalingsbetingelse'
     + ';iNPBetalingsbetingelseId'
     + ';BetalingsbetingelseAktiv'
     + ';BetalingsbetingelseKortnavn'
     + ';Betalingsbetingelse'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPBetalingsbetingelse RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPBetalingsbetingelse AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPBetalingsbetingelse AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPBetalingsbetingelse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPBetalingsbetingelse

/* Definitions for BROWSE BrwNPBetalingsbetingelse                      */
&Scoped-define FIELDS-IN-QUERY-BrwNPBetalingsbetingelse ~
NPBetalingsbetingelse.iNPBetalingsbetingelseId ~
NPBetalingsbetingelse.BetalingsbetingelseKortnavn ~
NPBetalingsbetingelse.Betalingsbetingelse 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPBetalingsbetingelse ~
NPBetalingsbetingelse.iNPBetalingsbetingelseId 
&Scoped-define QUERY-STRING-BrwNPBetalingsbetingelse FOR EACH NPBetalingsbetingelse NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPBetalingsbetingelse OPEN QUERY BrwNPBetalingsbetingelse FOR EACH NPBetalingsbetingelse NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPBetalingsbetingelse ~
NPBetalingsbetingelse
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPBetalingsbetingelse NPBetalingsbetingelse


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS new_tbNPBetalingsbetingelse ~
tbNPBetalingsbetingelse copy_tbNPBetalingsbetingelse ~
undo_tbNPBetalingsbetingelse save_tbNPBetalingsbetingelse ~
delete_tbNPBetalingsbetingelse refresh_tbNPBetalingsbetingelse ~
BrwNPBetalingsbetingelse iNPBetalingsbetingelseId BetalingsbetingelseAktiv ~
BetalingsbetingelseKortnavn Betalingsbetingelse 
&Scoped-Define DISPLAYED-OBJECTS iNPBetalingsbetingelseId ~
BetalingsbetingelseAktiv BetalingsbetingelseKortnavn Betalingsbetingelse 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPBetalingsbetingelse 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPBetalingsbetingelse 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON new_tbNPBetalingsbetingelse 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPBetalingsbetingelse 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPBetalingsbetingelse 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPBetalingsbetingelse 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE Betalingsbetingelse AS CHARACTER FORMAT "x(100)" 
     LABEL "Bet.betingelse" 
     VIEW-AS FILL-IN 
     SIZE 36 BY 1.

DEFINE VARIABLE BetalingsbetingelseKortnavn AS CHARACTER FORMAT "x(10)" 
     LABEL "Kortnavn" 
     VIEW-AS FILL-IN 
     SIZE 15.6 BY 1.

DEFINE VARIABLE iNPBetalingsbetingelseId AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Bet.bet.Id" 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1.

DEFINE RECTANGLE tbNPBetalingsbetingelse
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 113.8 BY 1.71.

DEFINE VARIABLE BetalingsbetingelseAktiv AS LOGICAL INITIAL no 
     LABEL "Aktiv" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPBetalingsbetingelse FOR 
      NPBetalingsbetingelse SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPBetalingsbetingelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPBetalingsbetingelse C-Win _STRUCTURED
  QUERY BrwNPBetalingsbetingelse NO-LOCK DISPLAY
      NPBetalingsbetingelse.iNPBetalingsbetingelseId COLUMN-LABEL "Id" FORMAT ">>>9":U
            WIDTH 9.2
      NPBetalingsbetingelse.BetalingsbetingelseKortnavn COLUMN-LABEL "Kortnavn" FORMAT "x(10)":U
      NPBetalingsbetingelse.Betalingsbetingelse COLUMN-LABEL "Bet.betingelse" FORMAT "x(100)":U
  ENABLE
      NPBetalingsbetingelse.iNPBetalingsbetingelseId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 59 BY 12.38 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPBetalingsbetingelse AT ROW 1.1 COL 1.2 WIDGET-ID 10
     copy_tbNPBetalingsbetingelse AT ROW 1.1 COL 7.2 WIDGET-ID 12
     undo_tbNPBetalingsbetingelse AT ROW 1.1 COL 13.4 WIDGET-ID 14
     save_tbNPBetalingsbetingelse AT ROW 1.1 COL 19.4 WIDGET-ID 16
     delete_tbNPBetalingsbetingelse AT ROW 1.1 COL 25.6 WIDGET-ID 18
     refresh_tbNPBetalingsbetingelse AT ROW 1.1 COL 31.6 WIDGET-ID 20
     BrwNPBetalingsbetingelse AT ROW 2.91 COL 1 WIDGET-ID 200
     iNPBetalingsbetingelseId AT ROW 3.57 COL 76 COLON-ALIGNED
     BetalingsbetingelseAktiv AT ROW 3.62 COL 89 WIDGET-ID 22
     BetalingsbetingelseKortnavn AT ROW 4.57 COL 76 COLON-ALIGNED
     Betalingsbetingelse AT ROW 5.57 COL 63.4
     tbNPBetalingsbetingelse AT ROW 1 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 114.8 BY 14.33 WIDGET-ID 100.


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
         HEIGHT             = 14.33
         WIDTH              = 114.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 114.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 114.8
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BrwNPBetalingsbetingelse refresh_tbNPBetalingsbetingelse DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 14.33
       FRAME DEFAULT-FRAME:WIDTH            = 114.8.

/* SETTINGS FOR FILL-IN Betalingsbetingelse IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbNPBetalingsbetingelse:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refreshmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPBetalingsbetingelse
/* Query rebuild information for BROWSE BrwNPBetalingsbetingelse
     _TblList          = "norcalc.NPBetalingsbetingelse"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPBetalingsbetingelse.iNPBetalingsbetingelseId" "Id" ">>>9" "integer" ? ? ? ? ? ? yes "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPBetalingsbetingelse.BetalingsbetingelseKortnavn" "Kortnavn" "x(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPBetalingsbetingelse.Betalingsbetingelse" "Bet.betingelse" "x(100)" "character" ? ? ? ? ? ? no "" no no "33.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPBetalingsbetingelse */
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


&Scoped-define BROWSE-NAME BrwNPBetalingsbetingelse
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
{incl/conttrigg.i oBrwNPBetalingsbetingelse:BROWSE-HANDLE}

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
  DISPLAY iNPBetalingsbetingelseId BetalingsbetingelseAktiv 
          BetalingsbetingelseKortnavn Betalingsbetingelse 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE new_tbNPBetalingsbetingelse tbNPBetalingsbetingelse 
         copy_tbNPBetalingsbetingelse undo_tbNPBetalingsbetingelse 
         save_tbNPBetalingsbetingelse delete_tbNPBetalingsbetingelse 
         refresh_tbNPBetalingsbetingelse BrwNPBetalingsbetingelse 
         iNPBetalingsbetingelseId BetalingsbetingelseAktiv 
         BetalingsbetingelseKortnavn Betalingsbetingelse 
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

  oBrwNPBetalingsbetingelse = NEW JBoxBrowse(brwNPBetalingsbetingelse:HANDLE).
  oBrwNPBetalingsbetingelse:setQuerySort("iNPBetalingsbetingelseId").

  oFmNPBetalingsbetingelse = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPBetalingsbetingelse:updateFields = 'BetalingsbetingelseAktiv,BetalingsbetingelseKortnavn,Betalingsbetingelse'.
  oFmNPBetalingsbetingelse:DisplayFields = 'iNPBetalingsbetingelseId'.

  oFmNPBetalingsbetingelse:BROWSE-OBJECT = oBrwNPBetalingsbetingelse.
  otbNPBetalingsbetingelse = NEW JBoxToolbar(tbNPBetalingsbetingelse:HANDLE).

  oBrwNPBetalingsbetingelse:TOOLBAR-OBJECT = otbNPBetalingsbetingelse.
  oFmNPBetalingsbetingelse:TOOLBAR-OBJECT = otbNPBetalingsbetingelse.
END.
oBrwNPBetalingsbetingelse:OpenQuery().


oContainer:initResize(300,200).

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

