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



/* Code for Definitions: */

/*** Start instance property definitions for JBoxQuery object oQryNPKUNDE ***/
DEF VAR oQryNPKUNDE AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE NPKUNDE
    FIELD adresse1 AS character
    FIELD adresse2 AS character
    FIELD aktiv AS logical
    FIELD avdeling AS character
    FIELD avtale AS character
    FIELD dm_kode AS character
    FIELD er_konsulent AS logical
    FIELD fax AS character
    FIELD Distriktnavn AS character
    FIELD Kommunenavn AS character
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
    FIELD kundedistriktnr AS integer
    FIELD kundedistrikt AS character
    FIELD kundekategori AS character
    FIELD kundenavn AS character
    FIELD kundenr AS character
    FIELD kundenr_de AS character
    FIELD kundenr_i AS integer
    FIELD kundenr_sp AS character
    FIELD land AS character
    FIELD cland AS character
    FIELD mobil AS character
    FIELD organisasjon AS character
    FIELD postnr AS character
    FIELD poststed AS character
    FIELD rabatt%_1 AS decimal
    FIELD rabatt%_2 AS decimal
    FIELD sist_oppdatert AS date
    FIELD telefon AS character
    FIELD tilbudsmottager AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1
    .
DEFINE BUFFER v_NPKUNDE FOR NPKUNDE.

FUNCTION getTableHandleQryNPKUNDE RETURNS HANDLE().
  RETURN BUFFER NPKUNDE:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPKUNDE RETURNS CHARACTER().
  RETURN 
        'NPKunde,Postnummer,Kommune,Distrikt,Land'.
/*      'NPKUNDE,NPKontakt'.*/
END FUNCTION.
FUNCTION getQueryJoinQryNPKUNDE RETURNS CHARACTER().
  RETURN ' first Postnummer where cPostnr = NPKunde.PostNr outer-join, first kommune of Postnummer outer-join, first Distrikt of kommune outer-join, first Land outer-join where Land.cLandKode = NPKunde.land'.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryNPKUNDE ***/

DEF VAR oFmNPKUNDE AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPKUNDE AS JBoxToolbar NO-UNDO.

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
&Scoped-define INTERNAL-TABLES NPKUNDE

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define SELF-NAME QUERY-2
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH NPKUNDE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY {&SELF-NAME} FOR EACH NPKUNDE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-QUERY-2 NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 NPKUNDE


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS er_konsulent Tilbudsmottager rabatt%_1 ~
rabatt%_2 lblOrganisasjon organisasjon kundenr konsulentnr kundenavn ~
adresse1 adresse2 postnr Land kundedistriktnr new_tbNPKUNDE undo_tbNPKUNDE ~
save_tbNPKUNDE delete_tbNPKUNDE kontor_type kundekategori poststed ~
btnPostnummer telefon KommuneNavn mobil DistriktNavn fax cLand ~
sist_oppdatert btnLand tbNPKUNDE 
&Scoped-Define DISPLAYED-OBJECTS er_konsulent Tilbudsmottager rabatt%_1 ~
rabatt%_2 lblOrganisasjon organisasjon kundenr konsulentnr kundenavn ~
adresse1 adresse2 postnr Land kundedistriktnr kontor_type kundekategori ~
poststed telefon KommuneNavn mobil DistriktNavn fax cLand sist_oppdatert 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnLand 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btnPostnummer 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON delete_tbNPKUNDE 
     IMAGE-UP FILE "img/ico/document_delete.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_delete_disabled.gif":U
     LABEL "Slett" 
     SIZE 7.8 BY 1.95 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON new_tbNPKUNDE 
     IMAGE-UP FILE "img/ico/document_add.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_add_disabled.gif":U
     LABEL "Ny" 
     SIZE 7.8 BY 1.95 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbNPKUNDE 
     IMAGE-UP FILE "img/ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/floppy_disk_disabled.gif":U
     LABEL "Lagre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPKUNDE 
     IMAGE-UP FILE "img/ico/undo.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/undo_disabled.gif":U
     LABEL "Angre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE kontor_type AS CHARACTER FORMAT "X(15)" INITIAL "Hovedkontor" 
     LABEL "Kontortype" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 24 BY 1.

DEFINE VARIABLE kundedistriktnr AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Distrikt" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1",0
     DROP-DOWN-LIST
     SIZE 49 BY 1.

DEFINE VARIABLE kundekategori AS CHARACTER FORMAT "X(6)" 
     LABEL "Kategori" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 24 BY 1.

DEFINE VARIABLE organisasjon AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 27 BY 8.81 NO-UNDO.

DEFINE VARIABLE adresse1 AS CHARACTER FORMAT "X(30)" 
     LABEL "Adresse 1" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1.

DEFINE VARIABLE adresse2 AS CHARACTER FORMAT "X(30)" 
     LABEL "Adresse 2" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1.

DEFINE VARIABLE cLand AS CHARACTER FORMAT "X(20)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.

DEFINE VARIABLE DistriktNavn AS CHARACTER FORMAT "X(18)" 
     LABEL "Fylke" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.

DEFINE VARIABLE fax AS CHARACTER FORMAT "X(15)" 
     LABEL "Fax" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE VARIABLE KommuneNavn AS CHARACTER FORMAT "X(18)" 
     LABEL "Kommune" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.

DEFINE VARIABLE konsulentnr AS INTEGER FORMAT ">>>>>>>9" INITIAL 0 
     LABEL "Konsulentnr" 
     VIEW-AS FILL-IN 
     SIZE 13.2 BY 1.

DEFINE VARIABLE kundenavn AS CHARACTER FORMAT "X(30)" 
     LABEL "Kundenavn" 
     VIEW-AS FILL-IN 
     SIZE 45 BY 1.

DEFINE VARIABLE kundenr AS CHARACTER FORMAT "X(8)" 
     LABEL "Kundenr" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE Land AS CHARACTER FORMAT "X(2)" 
     LABEL "Land" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE lblOrganisasjon AS CHARACTER FORMAT "X(256)":U INITIAL "Organisasjon:" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE mobil AS CHARACTER FORMAT "x(15)" 
     LABEL "Mobil" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE VARIABLE postnr AS CHARACTER FORMAT "X(8)" 
     LABEL "Postnr." 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE poststed AS CHARACTER FORMAT "X(22)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.

DEFINE VARIABLE rabatt%_1 AS DECIMAL FORMAT ">>9.9 %":U INITIAL 0 
     LABEL "Rabatt 1" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE rabatt%_2 AS DECIMAL FORMAT ">>9.9 %":U INITIAL 0 
     LABEL "Rabatt 2" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1 NO-UNDO.

DEFINE VARIABLE sist_oppdatert AS DATE FORMAT "99.99.9999" 
     LABEL "Oppdatert" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE telefon AS CHARACTER FORMAT "X(15)" 
     LABEL "Telefon" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE RECTANGLE tbNPKUNDE
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 148 BY 2.14.

DEFINE VARIABLE er_konsulent AS LOGICAL INITIAL no 
     LABEL "Konsulent" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

DEFINE VARIABLE Tilbudsmottager AS LOGICAL INITIAL no 
     LABEL "Tilbud" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     er_konsulent AT ROW 9.33 COL 107 WIDGET-ID 54
     Tilbudsmottager AT ROW 10.05 COL 107 WIDGET-ID 56
     rabatt%_1 AT ROW 7.19 COL 105 COLON-ALIGNED
     rabatt%_2 AT ROW 8.14 COL 105 COLON-ALIGNED
     lblOrganisasjon AT ROW 3.14 COL 121 NO-LABEL
     organisasjon AT ROW 3.86 COL 121 NO-LABEL WIDGET-ID 52
     kundenr AT ROW 3.14 COL 13 COLON-ALIGNED
     konsulentnr AT ROW 3.14 COL 45 COLON-ALIGNED
     kundenavn AT ROW 4.1 COL 13 COLON-ALIGNED
     adresse1 AT ROW 5.05 COL 13 COLON-ALIGNED
     adresse2 AT ROW 6 COL 13 COLON-ALIGNED
     postnr AT ROW 6.95 COL 13 COLON-ALIGNED
     Land AT ROW 10 COL 13 COLON-ALIGNED
     kundedistriktnr AT ROW 11.43 COL 13 COLON-ALIGNED WIDGET-ID 48
     new_tbNPKUNDE AT ROW 1.1 COL 1.2 WIDGET-ID 36
     undo_tbNPKUNDE AT ROW 1.1 COL 17 WIDGET-ID 38
     save_tbNPKUNDE AT ROW 1.1 COL 9.2 WIDGET-ID 40
     delete_tbNPKUNDE AT ROW 1.1 COL 24.8 WIDGET-ID 42
     kontor_type AT ROW 3.86 COL 75 COLON-ALIGNED WIDGET-ID 44
     kundekategori AT ROW 4.91 COL 75 COLON-ALIGNED WIDGET-ID 46
     poststed AT ROW 7 COL 32 COLON-ALIGNED NO-LABEL
     btnPostnummer AT ROW 7 COL 28.6 WIDGET-ID 32 NO-TAB-STOP 
     telefon AT ROW 7.19 COL 75 COLON-ALIGNED
     KommuneNavn AT ROW 8 COL 32 COLON-ALIGNED
     mobil AT ROW 8.14 COL 75 COLON-ALIGNED
     DistriktNavn AT ROW 9 COL 32 COLON-ALIGNED
     fax AT ROW 9.1 COL 75 COLON-ALIGNED
     cLand AT ROW 10 COL 32 COLON-ALIGNED NO-LABEL
     sist_oppdatert AT ROW 11.48 COL 75 COLON-ALIGNED
     btnLand AT ROW 10 COL 28.6 WIDGET-ID 50 NO-TAB-STOP 
     tbNPKUNDE AT ROW 1 COL 1 WIDGET-ID 34
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 148 BY 12.19 WIDGET-ID 100.


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
         HEIGHT             = 12.1
         WIDTH              = 148
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 148
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 148
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
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 12.19
       FRAME DEFAULT-FRAME:WIDTH            = 148.

/* SETTINGS FOR FILL-IN lblOrganisasjon IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       lblOrganisasjon:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Organisasjon:".

ASSIGN 
       tbNPKUNDE:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,save;Lagre,undo;Angre,delete;Slettmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH NPKUNDE NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 3.38 , 99 )
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


&Scoped-define SELF-NAME btnLand
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnLand C-Win
ON CHOOSE OF btnLand IN FRAME DEFAULT-FRAME /* ... */
DO:
  /* To manipulate the lookup query object add the callback procedure hook "myLookupObject" 
     (probably use "WHERE false" as the initial query in this case) */
  
  JBoxServerAPI:Instance:Lookup("Land"
                    + ";cLandkode"
                    + ";cLand"
                   ,"WHERE true"
                   ,"cLandkode,cLand"   /* <- return values for these fields */
                    ).

  IF JBoxServerAPI:Instance:LookupOk THEN DO:
    ASSIGN 
      Land:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("cLandKode")
      cLand:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("cLand")
      .
    APPLY "any-printable" TO Land.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnPostnummer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnPostnummer C-Win
ON CHOOSE OF btnPostnummer IN FRAME DEFAULT-FRAME /* ... */
DO:
  /* To manipulate the lookup query object add the callback procedure hook "myLookupObject" 
     (probably use "WHERE false" as the initial query in this case) */
  JBoxServerAPI:Instance:Lookup("Postnummer"
                    + ";cPostnr"
                    + ";cPoststed"
                    + ",Kommune;!kommunekode;!KommuneNavn"
                    + ",distrikt;!distriktkode;!DistriktNavn"
                   ,"WHERE true, first kommune of Postnummer, first distrikt of kommune,"
                   ,"cPostnr,cPoststed,Kommunenavn,Distriktnavn"   /* <- return values for these fields */
                    ).

  IF JBoxServerAPI:Instance:LookupOk THEN DO:
    ASSIGN 
      Postnr:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("cPostnr")
      poststed:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("cPostSted")
      Kommunenavn:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("Kommunenavn")
      distriktnavn:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("Distriktnavn")
      .
      if distriktnavn:screen-value ne '' then 
        assign 
          Land:screen-value = 'NO'
          cLand:screen-value = 'Norge'.
    APPLY "any-printable" TO Postnr.
  END.
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
  DISPLAY er_konsulent Tilbudsmottager rabatt%_1 rabatt%_2 lblOrganisasjon 
          organisasjon kundenr konsulentnr kundenavn adresse1 adresse2 postnr 
          Land kundedistriktnr kontor_type kundekategori poststed telefon 
          KommuneNavn mobil DistriktNavn fax cLand sist_oppdatert 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE er_konsulent Tilbudsmottager rabatt%_1 rabatt%_2 lblOrganisasjon 
         organisasjon kundenr konsulentnr kundenavn adresse1 adresse2 postnr 
         Land kundedistriktnr new_tbNPKUNDE undo_tbNPKUNDE save_tbNPKUNDE 
         delete_tbNPKUNDE kontor_type kundekategori poststed btnPostnummer 
         telefon KommuneNavn mobil DistriktNavn fax cLand sist_oppdatert 
         btnLand tbNPKUNDE 
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

   oQryNPKUNDE = NEW JBoxQuery('NPKUNDE').

  oFmNPKUNDE = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPKUNDE:updateFields = 'Kundenr,kundenavn,adresse1,adresse2,fax,konsulentnr,kontor_type,kundedistriktnr,kundekategori,mobil,postnr,telefon,land,Organisasjon,rabatt%_1,rabatt%_2,er_konsulent,tilbudsmottager'.
  oFmNPKUNDE:DisplayFields = 'sist_oppdatert,poststed,Distriktnavn,cLand,kommunenavn'.

  oFmNPKUNDE:QUERY-OBJECT = oQryNPKUNDE.
  otbNPKUNDE = NEW JBoxToolbar(tbNPKUNDE:HANDLE).

  oQryNPKUNDE:TOOLBAR-OBJECT = otbNPKUNDE.
  oFmNPKUNDE:TOOLBAR-OBJECT = otbNPKUNDE.
  assign 
    kundekategori:DELIMITER = '|' 
    kundekategori:LIST-ITEMS = JBoxServerAPI:Instance:FieldList('NPKundekategori;KundekategoriId','where true') 
    kundedistriktnr:DELIMITER = '|' 
    kundedistriktnr:LIST-ITEM-PAIRS = '|0|' + JBoxServerAPI:Instance:FieldList('NPKundedistrikt;KundeDistriktNr|KundeDistriktNavn;kundedistriktnr','where true')
    kontor_type:DELIMITER = '|' 
    kontor_type:LIST-ITEMS =  JBoxServerAPI:Instance:FieldList('JBoxGenCode;cCodeValue','where cCodeType = "DropListKontortype"')
  .
END.


oContainer:initResize(600,300).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ihField AS HANDLE NO-UNDO.
  def var cKkode as char no-undo.
  def var cDkode as char no-undo.
  def var cLandkode as char no-undo.
  
  IF ihField:MODIFIED THEN DO WITH FRAME {&FRAME-NAME}:
    CASE ihField:NAME:
      WHEN "postnr" THEN
      do: 
        assign 
          postnr:SCREEN-VALUE = JBoxServerAPI:Instance:FieldValues("PostNummer","WHERE cPostnr = '" + ihField:SCREEN-VALUE + "'","cPostNr")
          Poststed:Screen-value = JBoxServerAPI:Instance:FieldValues("PostNummer","WHERE cPostnr = '" + ihField:SCREEN-VALUE + "'","cPoststed")
          cKKode = JBoxServerAPI:Instance:FieldValues("PostNummer","WHERE cPostnr = '" + ihField:SCREEN-VALUE + "'","Kommunekode")
          cDKode = JBoxServerAPI:Instance:FieldValues("kommune","WHERE kommunekode = '" + cKKode + "'","Distriktkode")
          Kommunenavn:Screen-value = JBoxServerAPI:Instance:FieldValues("kommune","WHERE kommunekode = '" + cKKode + "'","KommuneNavn")
          Distriktnavn:Screen-value = JBoxServerAPI:Instance:FieldValues("Distrikt","WHERE Distriktkode = '" + cDKode + "'","DistriktNavn")
          .
        if distriktnavn:screen-value ne '' then 
        assign 
          Land:screen-value = 'NO'
          cLand:Screen-value = JBoxServerAPI:Instance:FieldValues("Land","WHERE cLandKode = '" + "NO" + "'","cLand")
        .
          
      end.
      WHEN "land" THEN 
        assign 
          land:SCREEN-VALUE = JBoxServerAPI:Instance:FieldValues("Land","WHERE clandkode = '" + ihField:SCREEN-VALUE + "'","cLandkode")
          cLand:Screen-value = JBoxServerAPI:Instance:FieldValues("Land","WHERE cLandKode = '" + ihField:SCREEN-VALUE + "'","cLand")
          .
    END CASE.
    if ihField:screen-value = ? then return no-apply.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
if avail NPKUNDE and (NPKUNDE.kundenr = '' or NPKUNDE.kundenavn = '') then 
do:
  MESSAGE 'Kundenr og kundenavn må ha verdi'
  VIEW-AS ALERT-BOX.
  undo, return.
end.
run super.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

