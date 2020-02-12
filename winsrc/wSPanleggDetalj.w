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


DEF VAR oFmNPSPANLG AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPSPANLG AS JBoxToolbar NO-UNDO.
def var oDato as JBoxDevExDateEdit no-undo.
def var oByggestart as JBoxDevExDateEdit no-undo.
def var oAnbudsfrist as JBoxDevExDateEdit no-undo.

/* Code for Definitions: */

/*** Start instance property definitions for JBoxQuery object oQryNPSPANLG ***/
DEF VAR oQryNPSPANLG AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE NPSPANLG
    FIELD aktivt AS logical
    FIELD anbudsfrist AS date
    FIELD anlegg AS character
    FIELD anleggsnr AS integer
    FIELD arkivnr AS character
    FIELD beskrevet AS character
    FIELD byggestart AS date
    FIELD dato AS date
    FIELD endrings_laas AS logical
    FIELD entreprise AS character
    FIELD konsulentens_saksbeh AS character
    FIELD konsulentid AS integer
    FIELD kundenr AS character
    FIELD leveringsdato AS date
    FIELD leveringstid AS character
    FIELD oppf_aar AS integer
    FIELD oppf_uke AS integer
    FIELD opplysninger AS character
    FIELD ordre AS logical
    FIELD prosjektid AS integer
    FIELD referanse_tekst AS character
    FIELD saksbehandler AS character
    FIELD salgsdistrikt AS character
    FIELD selger AS character
    FIELD sikker AS logical
    FIELD standardpris AS decimal
    FIELD adresse1 AS character
    FIELD adresse2 AS character
    FIELD aktiv AS logical
    FIELD avdeling AS character
    FIELD avtale AS character
    FIELD dm_kode AS character
    FIELD er_konsulent AS logical
    FIELD fax AS character
    FIELD fylke AS character
    FIELD katalog_np_antall AS integer
    FIELD katalog_np_dato AS date
    FIELD katalog_np_oppdatert AS date
    FIELD katalog_np_type AS character
    FIELD katalog_nt_antall AS integer
    FIELD katalog_nt_dato AS date
    FIELD katalog_nt_oppdatert AS date
    FIELD katalog_nt_type AS character
    FIELD kilde AS character
    FIELD konsulentnr AS integer
    FIELD kontaktperson_np AS character
    FIELD kontaktperson_nt AS character
    FIELD kontor_type AS character
    FIELD kundedistrikt AS character
    FIELD kundekategori AS character
    FIELD kundenavn AS character
    FIELD kundenr2 AS character
    FIELD kundenr_de AS character
    FIELD kundenr_i AS integer
    FIELD kundenr_sp AS character
    FIELD land AS character
    FIELD mobil AS character
    FIELD organisasjon AS character
    FIELD postnr AS character
    FIELD poststed AS character
    FIELD rabatt%_1 AS decimal
    FIELD rabatt%_2 AS decimal
    FIELD sist_oppdatert AS date
    FIELD telefon AS character
    FIELD tilbudsmottager AS logical
    FIELD Prosjekt_Navn as char 
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEFINE BUFFER v_NPSPANLG FOR NPSPANLG.

FUNCTION getTableHandleQryNPSPANLG RETURNS HANDLE().
  RETURN BUFFER NPSPANLG:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPSPANLG RETURNS CHARACTER().
  RETURN 
      'NPSPANLG'
    + ',NorProsjekt'
    + ',NPKUNDE'.
END FUNCTION.
FUNCTION getQueryJoinQryNPSPANLG RETURNS CHARACTER().
  RETURN ', FIRST NorProsjekt of NPSPAnlg OUTER-JOIN no-lock, FIRST NPKUNDE OUTER-JOIN OF NPSPANLG NO-LOCK'.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryNPSPANLG ***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define QUERY-NAME QUERY-3

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPANLG

/* Definitions for QUERY QUERY-3                                        */
&Scoped-define SELF-NAME QUERY-3
&Scoped-define QUERY-STRING-QUERY-3 FOR EACH NPSPANLG NO-LOCK
&Scoped-define OPEN-QUERY-QUERY-3 OPEN QUERY {&SELF-NAME} FOR EACH NPSPANLG NO-LOCK.
&Scoped-define TABLES-IN-QUERY-QUERY-3 NPSPANLG
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-3 NPSPANLG


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPANLG new_tbNPSPANLG copy_tbNPSPANLG ~
undo_tbNPSPANLG save_tbNPSPANLG delete_tbNPSPANLG ProsjektId Prosjekt_navn ~
anleggsnr dato endrings_laas Aktivt anlegg sikker btnkundenr Konsulent ~
konsulentens_saksbeh salgsdistrikt selger saksbehandler beskrevet ~
entreprise leveringstid standardpris byggestart anbudsfrist oppf_uke ~
oppf_aar 
&Scoped-Define DISPLAYED-OBJECTS ProsjektId Prosjekt_navn anleggsnr dato ~
endrings_laas Aktivt anlegg sikker Konsulent konsulentens_saksbeh ~
salgsdistrikt selger saksbehandler beskrevet entreprise leveringstid ~
standardpris byggestart anbudsfrist oppf_uke oppf_aar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnkundenr 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON copy_tbNPSPANLG 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 6 BY 1.52 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbNPSPANLG 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 6 BY 1.52 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON new_tbNPSPANLG 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 6 BY 1.52 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbNPSPANLG 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 6 BY 1.52 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPSPANLG 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 6 BY 1.52 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE beskrevet AS CHARACTER FORMAT "X(10)" 
     LABEL "Beskrevet" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 35 BY 1.

DEFINE VARIABLE entreprise AS CHARACTER FORMAT "X(8)" 
     LABEL "Entreprise" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 34 BY 1.

DEFINE VARIABLE saksbehandler AS CHARACTER FORMAT "X(25)" 
     LABEL "Saksbehandler" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 34 BY 1.

DEFINE VARIABLE salgsdistrikt AS CHARACTER FORMAT "X(30)" 
     LABEL "Salgsdistrikt" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 40 BY 1.

DEFINE VARIABLE selger AS CHARACTER FORMAT "X(25)" 
     LABEL "Selger" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 34 BY 1.

DEFINE VARIABLE anbudsfrist AS DATE FORMAT "99.99.9999" 
     LABEL "Anbudsfrist" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE anlegg AS CHARACTER FORMAT "X(45)" 
     LABEL "Anlegg" 
     VIEW-AS FILL-IN 
     SIZE 83 BY 1.

DEFINE VARIABLE anleggsnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Anleggsnr" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1.

DEFINE VARIABLE byggestart AS DATE FORMAT "99.99.9999" 
     LABEL "Byggestart" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE dato AS DATE FORMAT "99.99.9999" 
     LABEL "Dato" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE Konsulent AS CHARACTER FORMAT "X(256)":U 
     LABEL "Konsulent" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE konsulentens_saksbeh AS CHARACTER FORMAT "X(25)" 
     LABEL "v/" 
     VIEW-AS FILL-IN 
     SIZE 34 BY 1.

DEFINE VARIABLE kundenr AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Kundenr" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE leveringstid AS CHARACTER FORMAT "X(15)" 
     LABEL "Leveringstid" 
     VIEW-AS FILL-IN 
     SIZE 29 BY 1.

DEFINE VARIABLE oppf_aar AS INTEGER FORMAT "9999" INITIAL 0 
     LABEL "Oppf. år" 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1.

DEFINE VARIABLE oppf_uke AS INTEGER FORMAT "99" INITIAL 0 
     LABEL "Oppf.uke" 
     VIEW-AS FILL-IN 
     SIZE 4.8 BY 1.

DEFINE VARIABLE ProsjektId AS INTEGER FORMAT ">>>>>>9":U INITIAL 0 
     LABEL "Prosjekt ID" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE Prosjekt_navn AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY 1 NO-UNDO.

DEFINE VARIABLE standardpris AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Standardpris" 
     VIEW-AS FILL-IN 
     SIZE 20.2 BY 1 NO-UNDO.

DEFINE RECTANGLE tbNPSPANLG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 140 BY 1.71.

DEFINE VARIABLE Aktivt AS LOGICAL INITIAL no 
     LABEL "Aktivt" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE endrings_laas AS LOGICAL INITIAL no 
     LABEL "Låst for endring" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .81 NO-UNDO.

DEFINE VARIABLE sikker AS LOGICAL INITIAL no 
     LABEL "Sikker" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-3 FOR 
      NPSPANLG SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSPANLG AT ROW 1.1 COL 1.2 WIDGET-ID 50
     copy_tbNPSPANLG AT ROW 1.1 COL 7.2 WIDGET-ID 52
     undo_tbNPSPANLG AT ROW 1.1 COL 13.4 WIDGET-ID 54
     save_tbNPSPANLG AT ROW 1.1 COL 19.4 WIDGET-ID 56
     delete_tbNPSPANLG AT ROW 1.1 COL 25.6 WIDGET-ID 58
     ProsjektId AT ROW 2.91 COL 16 COLON-ALIGNED
     Prosjekt_navn AT ROW 2.91 COL 31 COLON-ALIGNED NO-LABEL
     anleggsnr AT ROW 4.1 COL 16 COLON-ALIGNED
     dato AT ROW 4.1 COL 38 COLON-ALIGNED
     kundenr AT ROW 4.1 COL 84 COLON-ALIGNED
     endrings_laas AT ROW 4.33 COL 106 WIDGET-ID 64
     Aktivt AT ROW 5.05 COL 106 WIDGET-ID 66
     anlegg AT ROW 5.19 COL 16 COLON-ALIGNED
     sikker AT ROW 5.76 COL 106 WIDGET-ID 68
     btnkundenr AT ROW 6.24 COL 58.6 WIDGET-ID 40 NO-TAB-STOP 
     Konsulent AT ROW 6.29 COL 16 COLON-ALIGNED
     konsulentens_saksbeh AT ROW 6.29 COL 65 COLON-ALIGNED
     salgsdistrikt AT ROW 7.33 COL 16 COLON-ALIGNED WIDGET-ID 34
     selger AT ROW 7.43 COL 65 COLON-ALIGNED WIDGET-ID 30
     saksbehandler AT ROW 8.38 COL 16 COLON-ALIGNED WIDGET-ID 32
     beskrevet AT ROW 8.62 COL 65 COLON-ALIGNED WIDGET-ID 46
     entreprise AT ROW 9.43 COL 16 COLON-ALIGNED WIDGET-ID 44
     leveringstid AT ROW 9.81 COL 65 COLON-ALIGNED
     standardpris AT ROW 9.81 COL 109 COLON-ALIGNED
     byggestart AT ROW 10.76 COL 16 COLON-ALIGNED
     anbudsfrist AT ROW 11.95 COL 16 COLON-ALIGNED
     oppf_uke AT ROW 11.95 COL 43 COLON-ALIGNED
     oppf_aar AT ROW 11.95 COL 58 COLON-ALIGNED
     tbNPSPANLG AT ROW 1 COL 1 WIDGET-ID 48
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 140 BY 14.19 WIDGET-ID 100.


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
         HEIGHT             = 14.14
         WIDTH              = 140
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 140
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 140
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
       FRAME DEFAULT-FRAME:HEIGHT           = 14.19
       FRAME DEFAULT-FRAME:WIDTH            = 140.

/* SETTINGS FOR FILL-IN kundenr IN FRAME DEFAULT-FRAME
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       kundenr:HIDDEN IN FRAME DEFAULT-FRAME           = TRUE.

ASSIGN 
       tbNPSPANLG:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,copy;Kopier,undo;Angre,save;Lagre,delete;Slettmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-3
/* Query rebuild information for QUERY QUERY-3
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH NPSPANLG NO-LOCK
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 1.48 , 133 )
*/  /* QUERY QUERY-3 */
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


&Scoped-define SELF-NAME btnkundenr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnkundenr C-Win
ON CHOOSE OF btnkundenr IN FRAME DEFAULT-FRAME /* ... */
DO:
  /* To manipulate the lookup query object add the callback procedure hook "myLookupObject" 
     (probably use "WHERE false" as the initial query in this case) */
  
  JBoxServerAPI:Instance:Lookup("NPKUNDE"
                    + ";kundenr"
                    + ";kundenavn"
                   ,"WHERE er_konsulent"
                   ,"kundenr,kundenavn"   /* <- return values for these fields */
                    ).

  IF JBoxServerAPI:Instance:LookupOk THEN DO:

    ASSIGN 
      konsulent:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("kundenavn").

    APPLY "any-printable" TO kundenr.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME QUERY-3
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
run super.

DO WITH FRAME {&FRAME-NAME}:
END.
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
  DISPLAY ProsjektId Prosjekt_navn anleggsnr dato endrings_laas Aktivt anlegg 
          sikker Konsulent konsulentens_saksbeh salgsdistrikt selger 
          saksbehandler beskrevet entreprise leveringstid standardpris 
          byggestart anbudsfrist oppf_uke oppf_aar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSPANLG new_tbNPSPANLG copy_tbNPSPANLG undo_tbNPSPANLG 
         save_tbNPSPANLG delete_tbNPSPANLG ProsjektId Prosjekt_navn anleggsnr 
         dato endrings_laas Aktivt anlegg sikker btnkundenr Konsulent 
         konsulentens_saksbeh salgsdistrikt selger saksbehandler beskrevet 
         entreprise leveringstid standardpris byggestart anbudsfrist oppf_uke 
         oppf_aar 
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
def var iGruppeId_saksbehandler as int no-undo.
def var iGruppeId_selger        as int no-undo.

RUN enable_UI.

oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

DO WITH FRAME {&FRAME-NAME}:

  oQryNPSPANLG = NEW JBoxQuery('NPSPANLG').

  oFmNPSPANLG = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSPANLG:updateFields = 'dato,anlegg,kundenr,entreprise,byggestart,beskrevet,salgsdistrikt,selger,oppf_uke,oppf_aar,leveringstid,anbudsfrist,konsulentens_saksbeh,saksbehandler,endrings_laas,sikker,aktivt,standardpris'.
  oFmNPSPANLG:DisplayFields = 'anleggsnr,ProsjektId,Prosjekt_Navn'.

  oFmNPSPANLG:QUERY-OBJECT = oQryNPSPANLG.
  otbNPSPANLG = NEW JBoxToolbar(tbNPSPANLG:HANDLE).

  oQryNPSPANLG:TOOLBAR-OBJECT = otbNPSPANLG.
  oFmNPSPANLG:TOOLBAR-OBJECT = otbNPSPANLG.

  ASSIGN
    iGruppeId_saksbehandler = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Saksbehandler"','iGruppeId')) 
    iGruppeId_selger = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Selger"','iGruppeId'))
    Entreprise:DELIMITER = '|'
    Entreprise:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListEntreprise' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    beskrevet:DELIMITER = '|'
    beskrevet:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListSPBeskrevet' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    selger:DELIMITER = '|'
    selger:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("Persongruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
    saksbehandler:DELIMITER = '|'
    saksbehandler:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("PersonGruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_saksbehandler) + ", First Person of PersonGruppe where bAktiv and person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
    salgsdistrikt:DELIMITER = '|'
    salgsdistrikt:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPkundedistrikt;Kundedistriktnr|KundeDistriktNavn;KundeDistriktNr","WHERE true" + ' BY kundedistriktnavn')
    .
  &IF DEFINED(AdvGuiWin) &THEN
    oDato = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Dato:HANDLE).
    oDato:RegisterWithJukeBox(NO).
    oDato:CreateDisplayLink(oFmNPSPANLG:BUFFER-HANDLE,"Dato").

    oAnbudsfrist = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Anbudsfrist:HANDLE).
    oAnbudsfrist:RegisterWithJukeBox(NO).
    oAnbudsfrist:CreateDisplayLink(oFmNPSPANLG:BUFFER-HANDLE,"Anbudsfrist").
    
    oByggestart = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Byggestart:HANDLE).
    oByggestart:RegisterWithJukeBox(NO).
    oByggestart:CreateDisplayLink(oFmNPSPANLG:BUFFER-HANDLE,"Byggestart").
  &ENDIF
END.
oContainer:initResize().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
/*------------------------------------------------------------------------------
  Purpose:     Retrieve lookup values when a foreign key field is modified
  Parameters:  Handle to foreign key field
  Notes:       The FieldValues method is a short version of Find
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihField AS HANDLE NO-UNDO.

IF ihField:MODIFIED THEN DO WITH FRAME {&FRAME-NAME}:
  CASE ihField:NAME:
    WHEN "Konsulent" THEN 
    assign 
      kundenr:screen-value =   JBoxServerAPI:Instance:FieldValues("NPKUNDE","WHERE kundenavn = '" + ihField:SCREEN-VALUE + "'","kundenr")
      konsulent:SCREEN-VALUE = JBoxServerAPI:Instance:FieldValues("NPKUNDE","WHERE kundenavn = '" + ihField:SCREEN-VALUE + "'","kundenavn")
      .
  END CASE.

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ProsjektID:screen-value = string(ProsjektID).
  END.

  run super.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
/*    oFmNPSPANLG:bufferextravalues = string(oPar:PARENT-BROWSE-OBJECT:QUERY-HANDLE:get-buffer-handle(1):buffer-field('ProsjektID'):buffer-value).*/
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

