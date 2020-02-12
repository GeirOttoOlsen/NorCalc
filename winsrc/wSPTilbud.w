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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSPTilbud ***/
DEF VAR oBrwNPSPTilbud AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPTILBUD
    FIELD tilbudsnr AS character
    FIELD anleggsnr AS integer
    FIELD kundenr AS character
    FIELD kundenavn AS character
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD id AS integer
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD pris AS decimal
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD tilbudsid AS integer
    FIELD vaar_ref AS character
    FIELD aktivt AS logical
    FIELD anbudsfrist AS date
    FIELD anleggsnr2 AS integer
    FIELD anlegg AS character
    FIELD arkivnr AS character
    FIELD beskrevet AS character
    FIELD byggestart AS date
    FIELD dato AS date
    FIELD endrings_laas AS logical
    FIELD entreprise AS character
    FIELD konsulentens_saksbeh AS character
    FIELD konsulentid AS integer
    FIELD kundenr2 AS character
    FIELD leveringsdato AS date
    FIELD leveringstid AS character
    FIELD oppf_aar AS integer
    FIELD oppf_uke AS integer
    FIELD opplysninger2 AS character
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
    FIELD kundenr3 AS character
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
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEF BUFFER v_NPSPTilbud FOR TEMP-TABLE NPSPTilbud.


FUNCTION getBuffersAndFieldsBrwNPSPTilbud RETURNS CHARACTER():
  RETURN
    'NPSPTILBUD'
     + ';tilbudsnr'
     + ';anleggsnr'
     + ';kundenr'
     + ';avgittpris'
     + ';bet_bet'
     + ';deres_ref'
     + ';gyldighetstid'
     + ';id'
     + ';lev_bet'
     + ';opplysninger'
     + ';pris'
     + ';rabatt%'
     + ';tilbudsdato'
     + ';tilbudsid'
     + ';vaar_ref'
  + ',NPSPANLG'
     + ';aktivt'
     + ';anbudsfrist'
     + ';anleggsnr'
     + ';anlegg'
     + ';arkivnr'
     + ';beskrevet'
     + ';byggestart'
     + ';dato'
     + ';endrings_laas'
     + ';entreprise'
     + ';konsulentens_saksbeh'
     + ';konsulentid'
     + ';kundenr'
     + ';leveringsdato'
     + ';leveringstid'
     + ';oppf_aar'
     + ';oppf_uke'
     + ';opplysninger'
     + ';ordre'
     + ';prosjektid'
     + ';referanse_tekst'
     + ';saksbehandler'
     + ';salgsdistrikt'
     + ';selger'
     + ';sikker'
     + ';standardpris'
  + ',NPKUNDE'
     + ';kundenavn'
     + ';adresse1'
     + ';adresse2'
     + ';aktiv'
     + ';avdeling'
     + ';avtale'
     + ';dm_kode'
     + ';er_konsulent'
     + ';fax'
     + ';fylke'
     + ';katalog_np_antall'
     + ';katalog_np_dato'
     + ';katalog_np_oppdatert'
     + ';katalog_np_type'
     + ';katalog_nt_antall'
     + ';katalog_nt_dato'
     + ';katalog_nt_oppdatert'
     + ';katalog_nt_type'
     + ';kilde'
     + ';konsulentnr'
     + ';kontaktperson_np'
     + ';kontaktperson_nt'
     + ';kontor_type'
     + ';kundedistrikt'
     + ';kundekategori'
     + ';kundenr'
     + ';kundenr_de'
     + ';kundenr_i'
     + ';kundenr_sp'
     + ';land'
     + ';mobil'
     + ';organisasjon'
     + ';postnr'
     + ';poststed'
     + ';rabatt%_1'
     + ';rabatt%_2'
     + ';sist_oppdatert'
     + ';telefon'
     + ';tilbudsmottager'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPTilbud RETURNS CHARACTER():
  RETURN 'EACH NPSPANLG OF NPSPTILBUD NO-LOCK,EACH NPKUNDE OF NPSPTILBUD NO-LOCK'.
END FUNCTION.
DEF VAR otbNPSPTILBUD AS JBoxToolbar NO-UNDO.
DEF VAR oTab AS JBoxMsTabs NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSPTilbud

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPTILBUD

/* Definitions for BROWSE BrwNPSPTilbud                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPTilbud NPSPTILBUD.tilbudsnr ~
NPSPTILBUD.anleggsnr NPSPTILBUD.kundenr NPSPTILBUD.kundenavn ~
NPSPTILBUD.avgittpris NPSPTILBUD.bet_bet NPSPTILBUD.deres_ref ~
NPSPTILBUD.gyldighetstid NPSPTILBUD.id NPSPTILBUD.lev_bet ~
NPSPTILBUD.opplysninger NPSPTILBUD.pris NPSPTILBUD.rabatt% ~
NPSPTILBUD.tilbudsdato NPSPTILBUD.tilbudsid NPSPTILBUD.vaar_ref ~
NPSPTILBUD.aktivt NPSPTILBUD.anbudsfrist NPSPTILBUD.anleggsnr2 ~
NPSPTILBUD.anlegg NPSPTILBUD.arkivnr NPSPTILBUD.beskrevet ~
NPSPTILBUD.byggestart NPSPTILBUD.dato NPSPTILBUD.endrings_laas ~
NPSPTILBUD.entreprise NPSPTILBUD.konsulentens_saksbeh ~
NPSPTILBUD.konsulentid NPSPTILBUD.kundenr2 NPSPTILBUD.leveringsdato ~
NPSPTILBUD.leveringstid NPSPTILBUD.oppf_aar NPSPTILBUD.oppf_uke ~
NPSPTILBUD.opplysninger2 NPSPTILBUD.ordre NPSPTILBUD.prosjektid ~
NPSPTILBUD.referanse_tekst NPSPTILBUD.saksbehandler ~
NPSPTILBUD.salgsdistrikt NPSPTILBUD.selger NPSPTILBUD.sikker ~
NPSPTILBUD.standardpris NPSPTILBUD.adresse1 NPSPTILBUD.adresse2 ~
NPSPTILBUD.aktiv NPSPTILBUD.avdeling NPSPTILBUD.avtale NPSPTILBUD.dm_kode ~
NPSPTILBUD.er_konsulent NPSPTILBUD.fax NPSPTILBUD.fylke ~
NPSPTILBUD.katalog_np_antall NPSPTILBUD.katalog_np_dato ~
NPSPTILBUD.katalog_np_oppdatert NPSPTILBUD.katalog_np_type ~
NPSPTILBUD.katalog_nt_antall NPSPTILBUD.katalog_nt_dato ~
NPSPTILBUD.katalog_nt_oppdatert NPSPTILBUD.katalog_nt_type NPSPTILBUD.kilde ~
NPSPTILBUD.konsulentnr NPSPTILBUD.kontaktperson_np ~
NPSPTILBUD.kontaktperson_nt NPSPTILBUD.kontor_type NPSPTILBUD.kundedistrikt ~
NPSPTILBUD.kundekategori NPSPTILBUD.kundenr3 NPSPTILBUD.kundenr_de ~
NPSPTILBUD.kundenr_i NPSPTILBUD.kundenr_sp NPSPTILBUD.land NPSPTILBUD.mobil ~
NPSPTILBUD.organisasjon NPSPTILBUD.postnr NPSPTILBUD.poststed ~
NPSPTILBUD.rabatt%_1 NPSPTILBUD.rabatt%_2 NPSPTILBUD.sist_oppdatert ~
NPSPTILBUD.telefon NPSPTILBUD.tilbudsmottager 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPTilbud NPSPTILBUD.tilbudsnr 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSPTilbud NPSPTILBUD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSPTilbud NPSPTILBUD
&Scoped-define QUERY-STRING-BrwNPSPTilbud FOR EACH NPSPTILBUD NO-LOCK, ~
    EACH NPSPANLG OF NPSPTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSPTILBUD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPTilbud OPEN QUERY BrwNPSPTilbud FOR EACH NPSPTILBUD NO-LOCK, ~
    EACH NPSPANLG OF NPSPTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSPTILBUD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPTilbud NPSPTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPTilbud NPSPTILBUD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPTILBUD Tab refresh_tbNPSPTILBUD ~
filter_tbNPSPTILBUD excel_tbNPSPTILBUD BrwNPSPTilbud 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE Tab
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 172 BY 13.81.

DEFINE RECTANGLE tbNPSPTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 172 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPTilbud FOR 
      NPSPTILBUD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPTilbud
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPTilbud C-Win _STRUCTURED
  QUERY BrwNPSPTilbud NO-LOCK DISPLAY
      NPSPTILBUD.tilbudsnr COLUMN-LABEL "Tilbudsnr." FORMAT "X(20)":U
      NPSPTILBUD.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPTILBUD.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSPTILBUD.kundenavn COLUMN-LABEL "Kundenavn" FORMAT "X(30)":U
      NPSPTILBUD.avgittpris COLUMN-LABEL "Avgitt pris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.bet_bet COLUMN-LABEL "Bet. bet." FORMAT "X(20)":U
      NPSPTILBUD.deres_ref COLUMN-LABEL "Deres ref." FORMAT "X(30)":U
      NPSPTILBUD.gyldighetstid COLUMN-LABEL "Gyldighetstid" FORMAT ">99":U
      NPSPTILBUD.id COLUMN-LABEL "Id" FORMAT ">>>>>>":U
      NPSPTILBUD.lev_bet COLUMN-LABEL "Lev. bet." FORMAT "X(8)":U
      NPSPTILBUD.opplysninger COLUMN-LABEL "Opplysninger" FORMAT "X(1024)":U
      NPSPTILBUD.pris COLUMN-LABEL "Pris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.rabatt% COLUMN-LABEL "Rabatt%" FORMAT "->>9.99":U
      NPSPTILBUD.tilbudsdato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSPTILBUD.tilbudsid COLUMN-LABEL "tilbudsid" FORMAT "9999":U
      NPSPTILBUD.vaar_ref COLUMN-LABEL "Vår ref." FORMAT "X(25)":U
      NPSPTILBUD.aktivt COLUMN-LABEL "Aktivt" FORMAT "ja/nei":U
      NPSPTILBUD.anbudsfrist COLUMN-LABEL "Anbudsfrist" FORMAT "99.99.9999":U
      NPSPTILBUD.anleggsnr2 COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPTILBUD.anlegg COLUMN-LABEL "Anlegg" FORMAT "X(45)":U
      NPSPTILBUD.arkivnr COLUMN-LABEL "Arkivnr" FORMAT "X(10)":U
      NPSPTILBUD.beskrevet COLUMN-LABEL "Beskrevet" FORMAT "X(15)":U
      NPSPTILBUD.byggestart COLUMN-LABEL "Byggestart" FORMAT "99.99.9999":U
      NPSPTILBUD.dato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSPTILBUD.endrings_laas COLUMN-LABEL "Låst" FORMAT "ja/nei":U
      NPSPTILBUD.entreprise COLUMN-LABEL "Entreprise" FORMAT "X(6)":U
      NPSPTILBUD.konsulentens_saksbeh COLUMN-LABEL "v/" FORMAT "X(25)":U
      NPSPTILBUD.konsulentid COLUMN-LABEL "Konsulent" FORMAT ">>>9":U
      NPSPTILBUD.kundenr2 COLUMN-LABEL "kundenr" FORMAT "X(8)":U
      NPSPTILBUD.leveringsdato COLUMN-LABEL "Leveringsdato" FORMAT "99.99.9999":U
      NPSPTILBUD.leveringstid COLUMN-LABEL "Leveringstid" FORMAT "X(15)":U
      NPSPTILBUD.oppf_aar COLUMN-LABEL "Oppf. år" FORMAT "9999":U
      NPSPTILBUD.oppf_uke COLUMN-LABEL "Oppf. uke" FORMAT "99":U
      NPSPTILBUD.opplysninger2 COLUMN-LABEL "Opplysninger" FORMAT "X(3072)":U
      NPSPTILBUD.ordre COLUMN-LABEL "ordre" FORMAT "ja/nei":U
      NPSPTILBUD.prosjektid COLUMN-LABEL "prosjektid" FORMAT ">>>>>>>9":U
      NPSPTILBUD.referanse_tekst COLUMN-LABEL "referanse_tekst" FORMAT "X(80)":U
      NPSPTILBUD.saksbehandler COLUMN-LABEL "Saksbehandler" FORMAT "X(25)":U
      NPSPTILBUD.salgsdistrikt COLUMN-LABEL "Salgsdistrikt" FORMAT "X(30)":U
      NPSPTILBUD.selger COLUMN-LABEL "Selger" FORMAT "X(25)":U
      NPSPTILBUD.sikker COLUMN-LABEL "sikker" FORMAT "ja/nei":U
      NPSPTILBUD.standardpris COLUMN-LABEL "Standardpris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.adresse1 COLUMN-LABEL "Adresse 1" FORMAT "X(30)":U
      NPSPTILBUD.adresse2 COLUMN-LABEL "Adresse 2" FORMAT "X(30)":U
      NPSPTILBUD.aktiv COLUMN-LABEL "Aktiv" FORMAT "ja/nei":U
      NPSPTILBUD.avdeling COLUMN-LABEL "Avd." FORMAT "X(30)":U
      NPSPTILBUD.avtale COLUMN-LABEL "Avtale" FORMAT "X(6)":U
      NPSPTILBUD.dm_kode COLUMN-LABEL "DM kode" FORMAT "X(15)":U
      NPSPTILBUD.er_konsulent COLUMN-LABEL "Konsulent" FORMAT "yes/no":U
      NPSPTILBUD.fax COLUMN-LABEL "Fax" FORMAT "X(15)":U
      NPSPTILBUD.fylke COLUMN-LABEL "Fylke" FORMAT "X(18)":U
      NPSPTILBUD.katalog_np_antall COLUMN-LABEL "antall" FORMAT ">9":U
      NPSPTILBUD.katalog_np_dato COLUMN-LABEL "Katalog NP" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_np_oppdatert COLUMN-LABEL "oppdatert" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_np_type COLUMN-LABEL "type" FORMAT "X(4)":U
      NPSPTILBUD.katalog_nt_antall COLUMN-LABEL "antall" FORMAT ">9":U
      NPSPTILBUD.katalog_nt_dato COLUMN-LABEL "Katalog NP" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_nt_oppdatert COLUMN-LABEL "oppdatert" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_nt_type COLUMN-LABEL "type" FORMAT "X(4)":U
      NPSPTILBUD.kilde COLUMN-LABEL "Kilde" FORMAT "X(10)":U
      NPSPTILBUD.konsulentnr COLUMN-LABEL "konsulentnr" FORMAT ">>>>>>>9":U
      NPSPTILBUD.kontaktperson_np COLUMN-LABEL "Kontaktperson - NP" FORMAT "X(25)":U
      NPSPTILBUD.kontaktperson_nt COLUMN-LABEL "Kontaktperson - NT" FORMAT "X(25)":U
      NPSPTILBUD.kontor_type COLUMN-LABEL "Kontortype" FORMAT "X(15)":U
      NPSPTILBUD.kundedistrikt COLUMN-LABEL "Distrikt" FORMAT "X(30)":U
      NPSPTILBUD.kundekategori COLUMN-LABEL "Kategori" FORMAT "X(6)":U
      NPSPTILBUD.kundenr3 COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSPTILBUD.kundenr_de COLUMN-LABEL "Knr. d.ease" FORMAT "X(8)":U
      NPSPTILBUD.kundenr_i COLUMN-LABEL "Kundenr" FORMAT ">>>>>>9":U
      NPSPTILBUD.kundenr_sp COLUMN-LABEL "Knr. spektra" FORMAT "X(8)":U
      NPSPTILBUD.land COLUMN-LABEL "Land" FORMAT "X(20)":U
      NPSPTILBUD.mobil COLUMN-LABEL "Mobil" FORMAT "x(15)":U
      NPSPTILBUD.organisasjon COLUMN-LABEL "Organisasjon" FORMAT "X(1024)":U
      NPSPTILBUD.postnr COLUMN-LABEL "Postnr." FORMAT "X(8)":U
      NPSPTILBUD.poststed COLUMN-LABEL "Poststed" FORMAT "X(22)":U
      NPSPTILBUD.rabatt%_1 COLUMN-LABEL "Rabatt 1" FORMAT ">>9.99":U
      NPSPTILBUD.rabatt%_2 COLUMN-LABEL "Rabatt 2" FORMAT ">>9.99":U
      NPSPTILBUD.sist_oppdatert COLUMN-LABEL "Sist oppd." FORMAT "99.99.9999":U
      NPSPTILBUD.telefon COLUMN-LABEL "Telefon" FORMAT "X(15)":U
      NPSPTILBUD.tilbudsmottager COLUMN-LABEL "Tilbud" FORMAT "ja/nei":U
  ENABLE
      NPSPTILBUD.tilbudsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 171 BY 6.67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSPTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 16
     filter_tbNPSPTILBUD AT ROW 1.1 COL 9.2 WIDGET-ID 18
     excel_tbNPSPTILBUD AT ROW 1.1 COL 17 WIDGET-ID 20
     BrwNPSPTilbud AT ROW 3.14 COL 2 WIDGET-ID 300
     tbNPSPTILBUD AT ROW 1 COL 1 WIDGET-ID 2
     Tab AT ROW 10.05 COL 2 WIDGET-ID 24
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 173.2 BY 24.1 WIDGET-ID 100.


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
         HEIGHT             = 24.1
         WIDTH              = 173.2
         MAX-HEIGHT         = 24.1
         MAX-WIDTH          = 173.2
         VIRTUAL-HEIGHT     = 24.1
         VIRTUAL-WIDTH      = 173.2
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
/* BROWSE-TAB BrwNPSPTilbud excel_tbNPSPTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 24.1
       FRAME DEFAULT-FRAME:WIDTH            = 173.2.

ASSIGN 
       tbNPSPTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPTilbud
/* Query rebuild information for BROWSE BrwNPSPTilbud
     _TblList          = "norcalc.NPSPTILBUD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSPTILBUD.tilbudsnr
"NPSPTILBUD.tilbudsnr" "Tilbudsnr." "X(20)" "character" ? ? ? ? ? ? yes "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSPTILBUD.anleggsnr
"NPSPTILBUD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSPTILBUD.kundenr
"NPSPTILBUD.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSPTILBUD.kundenavn
"NPSPTILBUD.kundenavn" "Kundenavn" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSPTILBUD.avgittpris
"NPSPTILBUD.avgittpris" "Avgitt pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSPTILBUD.bet_bet
"NPSPTILBUD.bet_bet" "Bet. bet." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSPTILBUD.deres_ref
"NPSPTILBUD.deres_ref" "Deres ref." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSPTILBUD.gyldighetstid
"NPSPTILBUD.gyldighetstid" "Gyldighetstid" ">99" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSPTILBUD.id
"NPSPTILBUD.id" "Id" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSPTILBUD.lev_bet
"NPSPTILBUD.lev_bet" "Lev. bet." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSPTILBUD.opplysninger
"NPSPTILBUD.opplysninger" "Opplysninger" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSPTILBUD.pris
"NPSPTILBUD.pris" "Pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSPTILBUD.rabatt%
"NPSPTILBUD.rabatt%" "Rabatt%" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSPTILBUD.tilbudsdato
"NPSPTILBUD.tilbudsdato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSPTILBUD.tilbudsid
"NPSPTILBUD.tilbudsid" "tilbudsid" "9999" "integer" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSPTILBUD.vaar_ref
"NPSPTILBUD.vaar_ref" "Vår ref." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSPTILBUD.aktivt
"NPSPTILBUD.aktivt" "Aktivt" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSPTILBUD.anbudsfrist
"NPSPTILBUD.anbudsfrist" "Anbudsfrist" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSPTILBUD.anleggsnr2
"NPSPTILBUD.anleggsnr2" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSPTILBUD.anlegg
"NPSPTILBUD.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSPTILBUD.arkivnr
"NPSPTILBUD.arkivnr" "Arkivnr" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSPTILBUD.beskrevet
"NPSPTILBUD.beskrevet" "Beskrevet" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSPTILBUD.byggestart
"NPSPTILBUD.byggestart" "Byggestart" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSPTILBUD.dato
"NPSPTILBUD.dato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSPTILBUD.endrings_laas
"NPSPTILBUD.endrings_laas" "Låst" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSPTILBUD.entreprise
"NPSPTILBUD.entreprise" "Entreprise" "X(6)" "character" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSPTILBUD.konsulentens_saksbeh
"NPSPTILBUD.konsulentens_saksbeh" "v/" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSPTILBUD.konsulentid
"NPSPTILBUD.konsulentid" "Konsulent" ">>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > NPSPTILBUD.kundenr2
"NPSPTILBUD.kundenr2" "kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > NPSPTILBUD.leveringsdato
"NPSPTILBUD.leveringsdato" "Leveringsdato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "13.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > NPSPTILBUD.leveringstid
"NPSPTILBUD.leveringstid" "Leveringstid" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > NPSPTILBUD.oppf_aar
"NPSPTILBUD.oppf_aar" "Oppf. år" "9999" "integer" ? ? ? ? ? ? no "Oppgi år for neste oppfølging" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > NPSPTILBUD.oppf_uke
"NPSPTILBUD.oppf_uke" "Oppf. uke" "99" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > NPSPTILBUD.opplysninger2
"NPSPTILBUD.opplysninger2" "Opplysninger" "X(3072)" "character" ? ? ? ? ? ? no "" no no "3072" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > NPSPTILBUD.ordre
"NPSPTILBUD.ordre" "ordre" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > NPSPTILBUD.prosjektid
"NPSPTILBUD.prosjektid" "prosjektid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > NPSPTILBUD.referanse_tekst
"NPSPTILBUD.referanse_tekst" "referanse_tekst" "X(80)" "character" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > NPSPTILBUD.saksbehandler
"NPSPTILBUD.saksbehandler" "Saksbehandler" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > NPSPTILBUD.salgsdistrikt
"NPSPTILBUD.salgsdistrikt" "Salgsdistrikt" "X(30)" "character" ? ? ? ? ? ? no "Velg distrikt" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > NPSPTILBUD.selger
"NPSPTILBUD.selger" "Selger" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[41]   > NPSPTILBUD.sikker
"NPSPTILBUD.sikker" "sikker" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[42]   > NPSPTILBUD.standardpris
"NPSPTILBUD.standardpris" "Standardpris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[43]   > NPSPTILBUD.adresse1
"NPSPTILBUD.adresse1" "Adresse 1" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[44]   > NPSPTILBUD.adresse2
"NPSPTILBUD.adresse2" "Adresse 2" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[45]   > NPSPTILBUD.aktiv
"NPSPTILBUD.aktiv" "Aktiv" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[46]   > NPSPTILBUD.avdeling
"NPSPTILBUD.avdeling" "Avd." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[47]   > NPSPTILBUD.avtale
"NPSPTILBUD.avtale" "Avtale" "X(6)" "character" ? ? ? ? ? ? no "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[48]   > NPSPTILBUD.dm_kode
"NPSPTILBUD.dm_kode" "DM kode" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[49]   > NPSPTILBUD.er_konsulent
"NPSPTILBUD.er_konsulent" "Konsulent" "yes/no" "logical" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[50]   > NPSPTILBUD.fax
"NPSPTILBUD.fax" "Fax" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[51]   > NPSPTILBUD.fylke
"NPSPTILBUD.fylke" "Fylke" "X(18)" "character" ? ? ? ? ? ? no "Velg fylke" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[52]   > NPSPTILBUD.katalog_np_antall
"NPSPTILBUD.katalog_np_antall" "antall" ">9" "integer" ? ? ? ? ? ? no "" no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[53]   > NPSPTILBUD.katalog_np_dato
"NPSPTILBUD.katalog_np_dato" "Katalog NP" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[54]   > NPSPTILBUD.katalog_np_oppdatert
"NPSPTILBUD.katalog_np_oppdatert" "oppdatert" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[55]   > NPSPTILBUD.katalog_np_type
"NPSPTILBUD.katalog_np_type" "type" "X(4)" "character" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[56]   > NPSPTILBUD.katalog_nt_antall
"NPSPTILBUD.katalog_nt_antall" "antall" ">9" "integer" ? ? ? ? ? ? no "" no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[57]   > NPSPTILBUD.katalog_nt_dato
"NPSPTILBUD.katalog_nt_dato" "Katalog NP" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[58]   > NPSPTILBUD.katalog_nt_oppdatert
"NPSPTILBUD.katalog_nt_oppdatert" "oppdatert" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[59]   > NPSPTILBUD.katalog_nt_type
"NPSPTILBUD.katalog_nt_type" "type" "X(4)" "character" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[60]   > NPSPTILBUD.kilde
"NPSPTILBUD.kilde" "Kilde" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[61]   > NPSPTILBUD.konsulentnr
"NPSPTILBUD.konsulentnr" "konsulentnr" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[62]   > NPSPTILBUD.kontaktperson_np
"NPSPTILBUD.kontaktperson_np" "Kontaktperson - NP" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[63]   > NPSPTILBUD.kontaktperson_nt
"NPSPTILBUD.kontaktperson_nt" "Kontaktperson - NT" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[64]   > NPSPTILBUD.kontor_type
"NPSPTILBUD.kontor_type" "Kontortype" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[65]   > NPSPTILBUD.kundedistrikt
"NPSPTILBUD.kundedistrikt" "Distrikt" "X(30)" "character" ? ? ? ? ? ? no "Velg distrikt" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[66]   > NPSPTILBUD.kundekategori
"NPSPTILBUD.kundekategori" "Kategori" "X(6)" "character" ? ? ? ? ? ? no "Velg kundekategori" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[67]   > NPSPTILBUD.kundenr3
"NPSPTILBUD.kundenr3" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[68]   > NPSPTILBUD.kundenr_de
"NPSPTILBUD.kundenr_de" "Knr. d.ease" "X(8)" "character" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[69]   > NPSPTILBUD.kundenr_i
"NPSPTILBUD.kundenr_i" "Kundenr" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[70]   > NPSPTILBUD.kundenr_sp
"NPSPTILBUD.kundenr_sp" "Knr. spektra" "X(8)" "character" ? ? ? ? ? ? no "" no no "11.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[71]   > NPSPTILBUD.land
"NPSPTILBUD.land" "Land" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[72]   > NPSPTILBUD.mobil
"NPSPTILBUD.mobil" "Mobil" "x(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[73]   > NPSPTILBUD.organisasjon
"NPSPTILBUD.organisasjon" "Organisasjon" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[74]   > NPSPTILBUD.postnr
"NPSPTILBUD.postnr" "Postnr." "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[75]   > NPSPTILBUD.poststed
"NPSPTILBUD.poststed" "Poststed" "X(22)" "character" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[76]   > NPSPTILBUD.rabatt%_1
"NPSPTILBUD.rabatt%_1" "Rabatt 1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[77]   > NPSPTILBUD.rabatt%_2
"NPSPTILBUD.rabatt%_2" "Rabatt 2" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[78]   > NPSPTILBUD.sist_oppdatert
"NPSPTILBUD.sist_oppdatert" "Sist oppd." "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[79]   > NPSPTILBUD.telefon
"NPSPTILBUD.telefon" "Telefon" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[80]   > NPSPTILBUD.tilbudsmottager
"NPSPTILBUD.tilbudsmottager" "Tilbud" "ja/nei" "logical" ? ? ? ? ? ? no "Denne kunden kan motta tilbud (J/N)" no no "5.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPTilbud */
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


&Scoped-define BROWSE-NAME BrwNPSPTilbud
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
{incl/conttrigg.i oBrwNPSPTilbud:BROWSE-HANDLE}

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
  ENABLE tbNPSPTILBUD Tab refresh_tbNPSPTILBUD filter_tbNPSPTILBUD 
         excel_tbNPSPTILBUD BrwNPSPTilbud 
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

  oBrwNPSPTilbud = NEW JBoxBrowse(brwNPSPTilbud:HANDLE).
  oBrwNPSPTilbud:setNoResizeY().

  otbNPSPTILBUD = NEW JBoxToolbar(tbNPSPTILBUD:HANDLE).
  oBrwNPSPTILBUD:TOOLBAR-OBJECT = otbNPSPTILBUD.
  
  oTab = NEW JBoxMSTabs(Tab:HANDLE,oBrwNPSPTilbud,"ico\bullet_ball_glass_green.ico,gif\afinternet.gif").
  oTab:pageOneType = "OneToOne".
  oTab:setLinkFields("id",1).
  oTab:AddPage('Detaljer',"wSPTilbudDetalj.w","bullet_ball_glass_green.ico").

  oTab:setLinkFields("id",2).
  oTab:AddPage('Oppfølging',"wSPTilbudoppf.w","afinternet.gif").
END.
oBrwNPSPTilbud:OpenQuery().


oContainer:initResize(200,400).

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

