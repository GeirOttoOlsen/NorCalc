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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHTILBUD ***/
DEF VAR oBrwNPSHTILBUD AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHTILBUD
    FIELD tilbudsnr AS character
    FIELD anleggsnr AS integer
    FIELD anlegg AS character
    FIELD dato AS date
    FIELD konsulentnr AS character
    FIELD kundenr AS character
    FIELD prosjektid AS integer
    FIELD prosjekt_navn AS character
    FIELD reg_dato AS date
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEF BUFFER v_NPSHTILBUD FOR TEMP-TABLE NPSHTILBUD.


FUNCTION getBuffersAndFieldsBrwNPSHTILBUD RETURNS CHARACTER():
  RETURN
    'NPSHTILBUD'
     + ';tilbudsnr'
  + ',NPSHANLG'
     + ';anleggsnr'
     + ';anlegg'
     + ';dato'
     + ';konsulentnr'
     + ';kundenr'
     + ';prosjektid'
  + ',NORPROSJEKT'
     + ';prosjekt_navn'
     + ';reg_dato'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHTILBUD RETURNS CHARACTER():
  RETURN 'EACH NPSHANLG OF NPSHTILBUD NO-LOCK,EACH NORPROSJEKT OF NPSHANLG NO-LOCK'.
END FUNCTION.
DEF VAR otbNPSHTILBUD AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define WIDGETID-FILE-NAME 

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHTILBUD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTILBUD

/* Definitions for BROWSE BrwNPSHTILBUD                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD.tilbudsnr ~
NPSHTILBUD.anleggsnr NPSHTILBUD.anlegg NPSHTILBUD.dato ~
NPSHTILBUD.konsulentnr NPSHTILBUD.kundenr NPSHTILBUD.prosjektid ~
NPSHTILBUD.prosjekt_navn NPSHTILBUD.reg_dato 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD.tilbudsnr 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD
&Scoped-define QUERY-STRING-BrwNPSHTILBUD FOR EACH NPSHTILBUD NO-LOCK, ~
    EACH NPSHANLG OF NPSHTILBUD NO-LOCK, ~
    EACH NORPROSJEKT OF NPSHANLG NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHTILBUD OPEN QUERY BrwNPSHTILBUD FOR EACH NPSHTILBUD NO-LOCK, ~
    EACH NPSHANLG OF NPSHTILBUD NO-LOCK, ~
    EACH NORPROSJEKT OF NPSHANLG NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHTILBUD refresh_tbNPSHTILBUD ~
excel_tbNPSHTILBUD BrwNPSHTILBUD 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbNPSHTILBUD 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.52 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON refresh_tbNPSHTILBUD 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSHTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 106.6 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHTILBUD FOR 
      NPSHTILBUD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHTILBUD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHTILBUD C-Win _STRUCTURED
  QUERY BrwNPSHTILBUD NO-LOCK DISPLAY
      NPSHTILBUD.tilbudsnr FORMAT "X(20)":U
      NPSHTILBUD.anleggsnr FORMAT ">>>>>9":U
      NPSHTILBUD.anlegg FORMAT "X(45)":U
      NPSHTILBUD.dato FORMAT "99.99.9999":U
      NPSHTILBUD.konsulentnr FORMAT "X(8)":U
      NPSHTILBUD.kundenr FORMAT "X(8)":U
      NPSHTILBUD.prosjektid FORMAT ">>>>>>>9":U
      NPSHTILBUD.prosjekt_navn FORMAT "X(45)":U
      NPSHTILBUD.reg_dato FORMAT "99.99.9999":U
  ENABLE
      NPSHTILBUD.tilbudsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106.6 BY 13.05 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSHTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 4
     excel_tbNPSHTILBUD AT ROW 1.1 COL 7.2 WIDGET-ID 6
     BrwNPSHTILBUD AT ROW 3.14 COL 2 WIDGET-ID 200
     tbNPSHTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 107.6 BY 15.19 WIDGET-ID 100.


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
         HEIGHT             = 15.19
         WIDTH              = 107.6
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
/* BROWSE-TAB BrwNPSHTILBUD excel_tbNPSHTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 15.19
       FRAME DEFAULT-FRAME:WIDTH            = 107.6.

ASSIGN 
       tbNPSHTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHTILBUD
/* Query rebuild information for BROWSE BrwNPSHTILBUD
     _TblList          = "norcalc.NPSHTILBUD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSHTILBUD.tilbudsnr
"NPSHTILBUD.tilbudsnr" "Tilbudsnr." "X(20)" "character" ? ? ? ? ? ? yes "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSHTILBUD.anleggsnr
"NPSHTILBUD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSHTILBUD.anlegg
"NPSHTILBUD.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn (oppdragssted)" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSHTILBUD.dato
"NPSHTILBUD.dato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSHTILBUD.konsulentnr
"NPSHTILBUD.konsulentnr" "konsulentnr" "X(8)" "character" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSHTILBUD.kundenr
"NPSHTILBUD.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSHTILBUD.prosjektid
"NPSHTILBUD.prosjektid" "prosjektid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSHTILBUD.prosjekt_navn
"NPSHTILBUD.prosjekt_navn" "Prosjektnavn" "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSHTILBUD.reg_dato
"NPSHTILBUD.reg_dato" "Reg.dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHTILBUD */
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


&Scoped-define BROWSE-NAME BrwNPSHTILBUD
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
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPSHTILBUD:BROWSE-HANDLE}
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
  ENABLE tbNPSHTILBUD refresh_tbNPSHTILBUD excel_tbNPSHTILBUD BrwNPSHTILBUD 
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

  oBrwNPSHTILBUD = NEW JBoxBrowse(brwNPSHTILBUD:HANDLE).

  otbNPSHTILBUD = NEW JBoxToolbar(tbNPSHTILBUD:HANDLE).

  oBrwNPSHTILBUD:TOOLBAR-OBJECT = otbNPSHTILBUD.
END.
oBrwNPSHTILBUD:OpenQuery().

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

