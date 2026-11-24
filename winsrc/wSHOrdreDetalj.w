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


/* Code for Definitions: */

/*** Start instance property definitions for JBoxQuery object oQryNPSHORD ***/
DEF VAR oQryNPSHORD AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE NPSHORD
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
    FIELD prod_nr AS character
    FIELD referanse AS character
    FIELD tilbudsid AS integer
    FIELD aktivt AS logical
    FIELD anbudsfrist AS date
    FIELD anlegg AS character
    FIELD anleggsnr2 AS integer
    FIELD anleggstype AS character
    FIELD arkivnr AS character
    FIELD beskrevet AS character
    FIELD byggestart AS date
    FIELD dato AS date
    FIELD endrings_laas AS logical
    FIELD entreprise AS character
    FIELD faktura# AS integer
    FIELD konsulentens_saksbeh AS character
    FIELD konsulentid AS integer
    FIELD konsulentnr AS character
    FIELD kundenr AS character
    FIELD leveringstid AS character
    FIELD oppf_aar AS integer
    FIELD oppf_uke AS integer
    FIELD opplysninger AS character
    FIELD prosjektid AS integer
    FIELD referanse_tekst AS character
    FIELD saksbehandler AS character
    FIELD salgsdistrikt AS character
    FIELD selger AS character
    FIELD sikker AS logical
    FIELD standardpris AS decimal
    FIELD anleggsnr3 AS integer
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD id3 AS integer
    FIELD kundenr3 AS character
    FIELD lev_bet AS character
    FIELD opplysninger3 AS character
    FIELD pris AS decimal
    FIELD pris_shuntgrupper AS decimal
    FIELD pris_tillegg AS decimal
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD tilbudsid3 AS integer
    FIELD tilbudsnr AS character
    FIELD vaar_ref AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEFINE BUFFER v_NPSHORD FOR temp-table NPSHORD.

FUNCTION getTableHandleQryNPSHORD RETURNS HANDLE().
  RETURN BUFFER NPSHORD:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPSHORD RETURNS CHARACTER().
  RETURN 
      'NPSHORD'
    + ',NPSHANLG'
    + ',NPSHTILBUD'.
END FUNCTION.
FUNCTION getQueryJoinQryNPSHORD RETURNS CHARACTER().
  RETURN 'EACH NPSHANLG OF NPSHORD NO-LOCK,EACH NPSHTILBUD OF NPSHORD NO-LOCK'.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryNPSHORD ***/

DEF VAR oFmNPSHORD AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPSHORD AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define QUERY-NAME QUERY-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHORD

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define SELF-NAME QUERY-2
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH NPSHORD NO-LOCK
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY {&SELF-NAME} FOR EACH NPSHORD NO-LOCK.
&Scoped-define TABLES-IN-QUERY-QUERY-2 NPSHORD
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 NPSHORD


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHORD new_tbNPSHORD edit_tbNPSHORD ~
copy_tbNPSHORD undo_tbNPSHORD save_tbNPSHORD delete_tbNPSHORD tilbudsid ~
ordre_dato faktura_kundeid leveringsdato referanse prod_nr leveringsmaate ~
lev_adresse_lik_kunde lev_adresse_fritekst 
&Scoped-Define DISPLAYED-OBJECTS tilbudsid ordre_dato faktura_kundeid ~
leveringsdato referanse prod_nr leveringsmaate lev_adresse_lik_kunde ~
lev_adresse_fritekst 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSHORD 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 7.8 BY 1.95 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSHORD 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 7.8 BY 1.95 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON edit_tbNPSHORD 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 7.8 BY 1.95 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON new_tbNPSHORD 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 7.8 BY 1.95 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON save_tbNPSHORD 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 7.8 BY 1.95 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPSHORD 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 7.8 BY 1.95 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE leveringsmaate AS CHARACTER FORMAT "X(20)" 
     LABEL "Lev. måte" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 43 BY 1.

DEFINE VARIABLE lev_adresse_fritekst AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 65 BY 6.19 NO-UNDO.

DEFINE VARIABLE faktura_kundeid AS CHARACTER FORMAT "X(8)" 
     LABEL "Fakturakunde" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE leveringsdato AS DATE FORMAT "99.99.9999" 
     LABEL "Leveringsdato" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE ordre_dato AS DATE FORMAT "99.99.9999" 
     LABEL "Ordredato" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE prod_nr AS CHARACTER FORMAT "X(20)" 
     LABEL "Prod. nr." 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1.

DEFINE VARIABLE referanse AS CHARACTER FORMAT "X(40)" 
     LABEL "Referanse" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1.

DEFINE VARIABLE tilbudsid AS INTEGER FORMAT ">>>>>>" INITIAL 0 
     LABEL "Tilbudsid" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1.

DEFINE RECTANGLE tbNPSHORD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 113.6 BY 2.14.

DEFINE VARIABLE lev_adresse_lik_kunde AS LOGICAL INITIAL no 
     LABEL "Leveringsadresse lik kunde" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      NPSHORD SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHORD AT ROW 1.1 COL 1.2 WIDGET-ID 22
     edit_tbNPSHORD AT ROW 1.1 COL 9 WIDGET-ID 24
     copy_tbNPSHORD AT ROW 1.1 COL 17 WIDGET-ID 26
     undo_tbNPSHORD AT ROW 1.1 COL 24.8 WIDGET-ID 28
     save_tbNPSHORD AT ROW 1.1 COL 32.8 WIDGET-ID 30
     delete_tbNPSHORD AT ROW 1.1 COL 40.6 WIDGET-ID 32
     tilbudsid AT ROW 3.86 COL 22 COLON-ALIGNED
     ordre_dato AT ROW 3.86 COL 79 COLON-ALIGNED
     faktura_kundeid AT ROW 4.81 COL 22 COLON-ALIGNED
     leveringsdato AT ROW 4.81 COL 79 COLON-ALIGNED
     referanse AT ROW 5.76 COL 22 COLON-ALIGNED
     prod_nr AT ROW 7.19 COL 82 COLON-ALIGNED
     leveringsmaate AT ROW 7.43 COL 22 COLON-ALIGNED WIDGET-ID 34
     lev_adresse_lik_kunde AT ROW 9.1 COL 81 WIDGET-ID 36
     lev_adresse_fritekst AT ROW 11.24 COL 24 NO-LABEL WIDGET-ID 40
     tbNPSHORD AT ROW 1 COL 1 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 114.6 BY 17.1 WIDGET-ID 100.


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
         HEIGHT             = 17.1
         WIDTH              = 114.6
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 114.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 114.6
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
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 17.1
       FRAME DEFAULT-FRAME:WIDTH            = 114.6.

ASSIGN 
       tbNPSHORD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,edit;Edit,copy;Copy,undo;Undo,save;Save,delete;Deletemaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH NPSHORD NO-LOCK
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 3.62 , 107 )
*/  /* QUERY QUERY-2 */
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


&Scoped-define SELF-NAME QUERY-2
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
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */

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
  DISPLAY tilbudsid ordre_dato faktura_kundeid leveringsdato referanse prod_nr 
          leveringsmaate lev_adresse_lik_kunde lev_adresse_fritekst 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHORD new_tbNPSHORD edit_tbNPSHORD copy_tbNPSHORD undo_tbNPSHORD 
         save_tbNPSHORD delete_tbNPSHORD tilbudsid ordre_dato faktura_kundeid 
         leveringsdato referanse prod_nr leveringsmaate lev_adresse_lik_kunde 
         lev_adresse_fritekst 
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

  oQryNPSHORD = NEW JBoxQuery('NPSHORD').

  oFmNPSHORD = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHORD:updateFields = 'tilbudsid,ordre_dato,faktura_kundeid,referanse,leveringsdato,leveringsmaate,lev_adresse_lik_kunde,lev_adresse_fritekst,prod_nr'.

  oFmNPSHORD:QUERY-OBJECT = oQryNPSHORD.
  otbNPSHORD = NEW JBoxToolbar(tbNPSHORD:HANDLE).

  oQryNPSHORD:TOOLBAR-OBJECT = otbNPSHORD.
  oFmNPSHORD:TOOLBAR-OBJECT = otbNPSHORD.
  
  assign 
    leveringsmaate:DELIMITER = '|'
    leveringsmaate:list-item-pairs = JBoxServerAPI:Instance:FieldList("NPleveringsmaate;Leveringsmaatenavn;leveringsmaatenavn","WHERE true" + ' BY leveringsmaatenavn')
    .
 END.


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

