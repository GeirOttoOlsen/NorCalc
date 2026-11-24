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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHORD ***/
DEF VAR oBrwNPSHORD AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHORD
    FIELD id AS integer
    FIELD ordreid AS integer
    FIELD anleggsnr AS integer
    FIELD tilbudsid AS integer
    FIELD prod_nr AS character
    FIELD faktura_kundeid AS character
    FIELD fakt_adresse1 AS character
    FIELD fakt_adresse2 AS character
    FIELD fakt_kundenavn AS character
    FIELD fakt_land AS character
    FIELD fakt_postnr AS character
    FIELD fakt_poststed AS character
    FIELD fritekst AS character
    FIELD leveringsdato AS date
    FIELD leveringsmaate AS character
    FIELD lev_adresse_fritekst AS character
    FIELD lev_adresse_lik_kunde AS logical
    FIELD ordre_dato AS date
    FIELD overfoert AS logical
    FIELD referanse AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHORD FOR TEMP-TABLE NPSHORD.


FUNCTION getBuffersAndFieldsBrwNPSHORD RETURNS CHARACTER():
  RETURN
    'NPSHORD'
     + ';id'
     + ';ordreid'
     + ';anleggsnr'
     + ';tilbudsid'
     + ';prod_nr'
     + ';faktura_kundeid'
     + ';fakt_adresse1'
     + ';fakt_adresse2'
     + ';fakt_kundenavn'
     + ';fakt_land'
     + ';fakt_postnr'
     + ';fakt_poststed'
     + ';fritekst'
     + ';leveringsdato'
     + ';leveringsmaate'
     + ';lev_adresse_fritekst'
     + ';lev_adresse_lik_kunde'
     + ';ordre_dato'
     + ';overfoert'
     + ';referanse'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHORD RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbNPSHORD AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHORD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHORD

/* Definitions for BROWSE BrwNPSHORD                                    */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHORD NPSHORD.id NPSHORD.ordreid ~
NPSHORD.anleggsnr NPSHORD.tilbudsid NPSHORD.prod_nr NPSHORD.faktura_kundeid ~
NPSHORD.fakt_adresse1 NPSHORD.fakt_adresse2 NPSHORD.fakt_kundenavn ~
NPSHORD.fakt_land NPSHORD.fakt_postnr NPSHORD.fakt_poststed ~
NPSHORD.fritekst NPSHORD.leveringsdato NPSHORD.leveringsmaate ~
NPSHORD.lev_adresse_fritekst NPSHORD.lev_adresse_lik_kunde ~
NPSHORD.ordre_dato NPSHORD.overfoert NPSHORD.referanse 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHORD NPSHORD.id 
&Scoped-define QUERY-STRING-BrwNPSHORD FOR EACH NPSHORD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHORD OPEN QUERY BrwNPSHORD FOR EACH NPSHORD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHORD NPSHORD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHORD NPSHORD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHORD edit_tbNPSHORD BrwNPSHORD 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON edit_tbNPSHORD 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 6 BY 1.52 TOOLTIP "Edit (CTRL-E)".

DEFINE RECTANGLE tbNPSHORD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 107.4 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHORD FOR 
      NPSHORD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHORD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHORD C-Win _STRUCTURED
  QUERY BrwNPSHORD NO-LOCK DISPLAY
      NPSHORD.id COLUMN-LABEL "Tilbudsid" FORMAT ">>>>>>":U
      NPSHORD.ordreid COLUMN-LABEL "ordreid" FORMAT ">>>>>>>9":U
      NPSHORD.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHORD.tilbudsid COLUMN-LABEL "Tilbudsid" FORMAT ">>>>>>":U
      NPSHORD.prod_nr COLUMN-LABEL "Prod. nr." FORMAT "X(20)":U
      NPSHORD.faktura_kundeid COLUMN-LABEL "Fakt.adr." FORMAT "X(8)":U
      NPSHORD.fakt_adresse1 COLUMN-LABEL "fakt_adresse1" FORMAT "X(30)":U
      NPSHORD.fakt_adresse2 COLUMN-LABEL "fakt_adresse2" FORMAT "X(30)":U
      NPSHORD.fakt_kundenavn COLUMN-LABEL "fakt_kundenavn" FORMAT "X(30)":U
      NPSHORD.fakt_land COLUMN-LABEL "fakt_land" FORMAT "X(20)":U
      NPSHORD.fakt_postnr COLUMN-LABEL "fakt_postnr" FORMAT "X(8)":U
      NPSHORD.fakt_poststed COLUMN-LABEL "fakt_poststed" FORMAT "X(22)":U
      NPSHORD.fritekst COLUMN-LABEL "fritekst" FORMAT "X(256)":U
      NPSHORD.leveringsdato COLUMN-LABEL "Leveringsdato" FORMAT "99.99.9999":U
      NPSHORD.leveringsmaate COLUMN-LABEL "Lev. måte" FORMAT "X(20)":U
      NPSHORD.lev_adresse_fritekst COLUMN-LABEL "Lev.adr." FORMAT "X(256)":U
      NPSHORD.lev_adresse_lik_kunde COLUMN-LABEL "lev_adresse_lik_kunde" FORMAT "yes/no":U
      NPSHORD.ordre_dato COLUMN-LABEL "Ordredato" FORMAT "99.99.9999":U
      NPSHORD.overfoert COLUMN-LABEL "Overført" FORMAT "ja/nei":U
      NPSHORD.referanse COLUMN-LABEL "Ref" FORMAT "X(40)":U
  ENABLE
      NPSHORD.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 108.4 BY 9.33 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     edit_tbNPSHORD AT ROW 1.33 COL 2.2 WIDGET-ID 4
     BrwNPSHORD AT ROW 3.14 COL 2 WIDGET-ID 200
     tbNPSHORD AT ROW 1.24 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 109.4 BY 11.48 WIDGET-ID 100.


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
         TITLE              = "Ordrebehandling"
         HEIGHT             = 11.48
         WIDTH              = 109.4
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
/* BROWSE-TAB BrwNPSHORD edit_tbNPSHORD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 11.48
       FRAME DEFAULT-FRAME:WIDTH            = 109.4.

ASSIGN 
       tbNPSHORD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "edit;Editmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHORD
/* Query rebuild information for BROWSE BrwNPSHORD
     _TblList          = "norcalc.NPSHORD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHORD.id" "Tilbudsid" ">>>>>>" "integer" ? ? ? ? ? ? yes "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHORD.ordreid" "ordreid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHORD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHORD.tilbudsid" "Tilbudsid" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHORD.prod_nr" "Prod. nr." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHORD.faktura_kundeid" "Fakt.adr." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHORD.fakt_adresse1" "fakt_adresse1" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHORD.fakt_adresse2" "fakt_adresse2" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSHORD.fakt_kundenavn" "fakt_kundenavn" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSHORD.fakt_land" "fakt_land" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSHORD.fakt_postnr" "fakt_postnr" "X(8)" "character" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSHORD.fakt_poststed" "fakt_poststed" "X(22)" "character" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSHORD.fritekst" "fritekst" "X(256)" "character" ? ? ? ? ? ? no "" no no "256" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSHORD.leveringsdato" "Leveringsdato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "13.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSHORD.leveringsmaate" "Lev. måte" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSHORD.lev_adresse_fritekst" "Lev.adr." "X(256)" "character" ? ? ? ? ? ? no "" no no "256" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSHORD.lev_adresse_lik_kunde" "lev_adresse_lik_kunde" "yes/no" "logical" ? ? ? ? ? ? no "" no no "21.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPSHORD.ordre_dato" "Ordredato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPSHORD.overfoert" "Overført" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPSHORD.referanse" "Ref" "X(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHORD */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Ordrebehandling */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Ordrebehandling */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHORD
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
{incl/conttrigg.i oBrwNPSHORD:BROWSE-HANDLE}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
  def var hChild as handle no-undo.
  
  hChild = oContainer:StartChildWindow('wSHOrdre.w','Ordrebehandling', no).
  dynamic-function('setParentBrowse' in hChild, oBrwNPSHORD).
  
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
  ENABLE tbNPSHORD edit_tbNPSHORD BrwNPSHORD 
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

  oBrwNPSHORD = NEW JBoxBrowse(brwNPSHORD:HANDLE).

  otbNPSHORD = NEW JBoxToolbar(tbNPSHORD:HANDLE).

  oBrwNPSHORD:TOOLBAR-OBJECT = otbNPSHORD.
END.
oBrwNPSHORD:OpenQuery().

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

