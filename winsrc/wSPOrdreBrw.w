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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSPORD ***/
DEF VAR oBrwNPSPORD AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPORD
    FIELD anleggsnr AS integer
    FIELD faktura_kundeid AS character
    FIELD fakt_adresse1 AS character
    FIELD fakt_adresse2 AS character
    FIELD fakt_kundenavn AS character
    FIELD fakt_land AS character
    FIELD fakt_postnr AS character
    FIELD fakt_poststed AS character
    FIELD fritekst AS character
    FIELD id AS integer
    FIELD leveringsdato AS date
    FIELD leveringsmaate AS character
    FIELD lev_adresse_fritekst AS character
    FIELD lev_adresse_lik_kunde AS logical
    FIELD ordreid AS integer
    FIELD ordre_dato AS date
    FIELD overfoert AS logical
    FIELD referanse AS character
    FIELD tilbudsid AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSPORD FOR TEMP-TABLE NPSPORD.


FUNCTION getBuffersAndFieldsBrwNPSPORD RETURNS CHARACTER():
  RETURN
    'NPSPORD'
     + ';anleggsnr'
     + ';faktura_kundeid'
     + ';fakt_adresse1'
     + ';fakt_adresse2'
     + ';fakt_kundenavn'
     + ';fakt_land'
     + ';fakt_postnr'
     + ';fakt_poststed'
     + ';fritekst'
     + ';id'
     + ';leveringsdato'
     + ';leveringsmaate'
     + ';lev_adresse_fritekst'
     + ';lev_adresse_lik_kunde'
     + ';ordreid'
     + ';ordre_dato'
     + ';overfoert'
     + ';referanse'
     + ';tilbudsid'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPORD RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbNPSPTILBUD AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define WIDGETID-FILE-NAME 

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSPORD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPORD

/* Definitions for BROWSE BrwNPSPORD                                    */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPORD NPSPORD.anleggsnr ~
NPSPORD.faktura_kundeid NPSPORD.fakt_adresse1 NPSPORD.fakt_adresse2 ~
NPSPORD.fakt_kundenavn NPSPORD.fakt_land NPSPORD.fakt_postnr ~
NPSPORD.fakt_poststed NPSPORD.fritekst NPSPORD.id NPSPORD.leveringsdato ~
NPSPORD.leveringsmaate NPSPORD.lev_adresse_fritekst ~
NPSPORD.lev_adresse_lik_kunde NPSPORD.ordreid NPSPORD.ordre_dato ~
NPSPORD.overfoert NPSPORD.referanse NPSPORD.tilbudsid 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPORD NPSPORD.anleggsnr 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSPORD NPSPORD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSPORD NPSPORD
&Scoped-define QUERY-STRING-BrwNPSPORD FOR EACH NPSPORD NO-LOCK, INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPORD OPEN QUERY BrwNPSPORD FOR EACH NPSPORD NO-LOCK, INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPORD NPSPORD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPORD NPSPORD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPTILBUD refresh_tbNPSPTILBUD ~
excel_tbNPSPTILBUD BrwNPSPORD 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbNPSPTILBUD 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON refresh_tbNPSPTILBUD 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSPTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 152.2 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPORD FOR 
      NPSPORD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPORD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPORD C-Win _STRUCTURED
  QUERY BrwNPSPORD NO-LOCK DISPLAY
      NPSPORD.anleggsnr FORMAT ">>>>>9":U
      NPSPORD.faktura_kundeid FORMAT "X(8)":U
      NPSPORD.fakt_adresse1 FORMAT "X(30)":U
      NPSPORD.fakt_adresse2 FORMAT "X(30)":U
      NPSPORD.fakt_kundenavn FORMAT "X(30)":U
      NPSPORD.fakt_land FORMAT "X(20)":U
      NPSPORD.fakt_postnr FORMAT "X(8)":U
      NPSPORD.fakt_poststed FORMAT "X(22)":U
      NPSPORD.fritekst FORMAT "X(256)":U
      NPSPORD.id FORMAT ">>>>>>":U
      NPSPORD.leveringsdato FORMAT "99.99.9999":U
      NPSPORD.leveringsmaate FORMAT "X(20)":U
      NPSPORD.lev_adresse_fritekst FORMAT "X(256)":U
      NPSPORD.lev_adresse_lik_kunde FORMAT "yes/no":U
      NPSPORD.ordreid FORMAT ">>>>>>>9":U
      NPSPORD.ordre_dato FORMAT "99.99.9999":U
      NPSPORD.overfoert FORMAT "ja/nei":U
      NPSPORD.referanse FORMAT "X(40)":U
      NPSPORD.tilbudsid FORMAT ">>>>>>":U
  ENABLE
      NPSPORD.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 152.2 BY 12.86 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSPTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 4
     excel_tbNPSPTILBUD AT ROW 1.1 COL 9 WIDGET-ID 6
     BrwNPSPORD AT ROW 3.14 COL 2 WIDGET-ID 200
     tbNPSPTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 153.2 BY 15 WIDGET-ID 100.


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
         HEIGHT             = 15
         WIDTH              = 153.2
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 153.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 153.2
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
/* BROWSE-TAB BrwNPSPORD excel_tbNPSPTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 15
       FRAME DEFAULT-FRAME:WIDTH            = 153.2.

ASSIGN 
       tbNPSPTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPORD
/* Query rebuild information for BROWSE BrwNPSPORD
     _TblList          = "norcalc.NPSPORD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSPORD.anleggsnr
"NPSPORD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSPORD.faktura_kundeid
"NPSPORD.faktura_kundeid" "Fakt.adr." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSPORD.fakt_adresse1
"NPSPORD.fakt_adresse1" "fakt_adresse1" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSPORD.fakt_adresse2
"NPSPORD.fakt_adresse2" "fakt_adresse2" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSPORD.fakt_kundenavn
"NPSPORD.fakt_kundenavn" "fakt_kundenavn" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSPORD.fakt_land
"NPSPORD.fakt_land" "fakt_land" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSPORD.fakt_postnr
"NPSPORD.fakt_postnr" "fakt_postnr" "X(8)" "character" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSPORD.fakt_poststed
"NPSPORD.fakt_poststed" "fakt_poststed" "X(22)" "character" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSPORD.fritekst
"NPSPORD.fritekst" "fritekst" "X(256)" "character" ? ? ? ? ? ? no "" no no "256" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSPORD.id
"NPSPORD.id" "Tilbudsid" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSPORD.leveringsdato
"NPSPORD.leveringsdato" "Leveringsdato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "13.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSPORD.leveringsmaate
"NPSPORD.leveringsmaate" "Lev. måte" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSPORD.lev_adresse_fritekst
"NPSPORD.lev_adresse_fritekst" "Lev.adr." "X(256)" "character" ? ? ? ? ? ? no "" no no "256" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSPORD.lev_adresse_lik_kunde
"NPSPORD.lev_adresse_lik_kunde" "lev_adresse_lik_kunde" "yes/no" "logical" ? ? ? ? ? ? no "" no no "21.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSPORD.ordreid
"NPSPORD.ordreid" "ordreid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSPORD.ordre_dato
"NPSPORD.ordre_dato" "Ordredato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSPORD.overfoert
"NPSPORD.overfoert" "Overført" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSPORD.referanse
"NPSPORD.referanse" "Ref" "X(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSPORD.tilbudsid
"NPSPORD.tilbudsid" "Tilbudsid" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPORD */
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


&Scoped-define BROWSE-NAME BrwNPSPORD
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
{incl/conttrigg.i oBrwNPSPORD:BROWSE-HANDLE}

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
  ENABLE tbNPSPTILBUD refresh_tbNPSPTILBUD excel_tbNPSPTILBUD BrwNPSPORD 
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

  oBrwNPSPORD = NEW JBoxBrowse(brwNPSPORD:HANDLE).

  otbNPSPTILBUD = NEW JBoxToolbar(tbNPSPTILBUD:HANDLE).

  oBrwNPSPORD:TOOLBAR-OBJECT = otbNPSPTILBUD.
END.
oBrwNPSPORD:OpenQuery().


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

