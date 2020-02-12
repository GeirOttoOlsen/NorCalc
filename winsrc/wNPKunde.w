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


/*** Start instance property definitions for JBoxBrowse object oBrwNPKUNDE ***/
DEF VAR oBrwNPKUNDE AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPKUNDE
    FIELD kundenr AS character
    FIELD kundenavn AS character
    FIELD adresse1 AS character
    FIELD adresse2 AS character
    FIELD postnr AS character
    FIELD poststed AS character
    FIELD avdeling AS character
    FIELD avtale AS character
    FIELD aktiv AS logical
    FIELD fylke AS character
    FIELD kundedistrikt AS character
    FIELD kundedistriktNr AS integer
    FIELD kundedistriktnavn AS character
    FIELD land AS character
    FIELD mobil AS character
    FIELD telefon AS character
    FIELD fax AS character
    FIELD organisasjon AS character
    FIELD sist_oppdatert AS date
    FIELD kundekategori AS character
    FIELD dm_kode AS character
    FIELD katalog_np_antall AS integer
    FIELD katalog_np_dato AS date
    FIELD katalog_np_oppdatert AS date
    FIELD katalog_np_type AS character
    FIELD katalog_nt_antall AS integer
    FIELD katalog_nt_dato AS date
    FIELD katalog_nt_oppdatert AS date
    FIELD katalog_nt_type AS character
    FIELD kilde AS character
    FIELD er_konsulent AS logical
    FIELD konsulentnr AS integer
    FIELD kontaktperson_np AS character
    FIELD kontaktperson_nt AS character
    FIELD kontor_type AS character
    FIELD kundenr_de AS character
    FIELD kundenr_i AS integer
    FIELD kundenr_sp AS character
    FIELD rabatt%_1 AS decimal
    FIELD rabatt%_2 AS decimal
    FIELD tilbudsmottager AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_NPKUNDE FOR TEMP-TABLE NPKUNDE.


FUNCTION getBuffersAndFieldsBrwNPKUNDE RETURNS CHARACTER():
  RETURN
    'NPKUNDE'
     + ';kundenr'
     + ';kundenavn'
     + ';adresse1'
     + ';adresse2'
     + ';postnr'
     + ';poststed'
     + ';avdeling'
     + ';avtale'
     + ';aktiv'
     + ';fylke'
     + ';kundedistrikt'
     + ';kundedistriktNr'
     + ';land'
     + ';mobil'
     + ';telefon'
     + ';fax'
     + ';organisasjon'
     + ';sist_oppdatert'
     + ';kundekategori'
     + ';dm_kode'
     + ';katalog_np_antall'
     + ';katalog_np_dato'
     + ';katalog_np_oppdatert'
     + ';katalog_np_type'
     + ';katalog_nt_antall'
     + ';katalog_nt_dato'
     + ';katalog_nt_oppdatert'
     + ';katalog_nt_type'
     + ';kilde'
     + ';er_konsulent'
     + ';konsulentnr'
     + ';kontaktperson_np'
     + ';kontaktperson_nt'
     + ';kontor_type'
     + ';kundenr_de'
     + ';kundenr_i'
     + ';kundenr_sp'
     + ';rabatt%_1'
     + ';rabatt%_2'
     + ';tilbudsmottager'
  + ',NPkundedistrikt'
     + ';kundedistriktnavn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPKUNDE RETURNS CHARACTER():
  RETURN 'EACH NPkundedistrikt OF NPKUNDE NO-LOCK'.
END FUNCTION.
DEF VAR otbNPKUNDE AS JBoxToolbar NO-UNDO.
DEF VAR oTabNPKUNDE AS JBoxMsTabs NO-UNDO.


DEF VAR opopupNPKUNDE AS JBoxPopupMenu NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPKUNDE

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKUNDE

/* Definitions for BROWSE BrwNPKUNDE                                    */
&Scoped-define FIELDS-IN-QUERY-BrwNPKUNDE NPKUNDE.kundenr NPKUNDE.kundenavn ~
NPKUNDE.adresse1 NPKUNDE.adresse2 NPKUNDE.postnr NPKUNDE.poststed ~
NPKUNDE.avdeling NPKUNDE.avtale NPKUNDE.aktiv NPKUNDE.fylke ~
NPKUNDE.kundedistrikt NPKUNDE.kundedistriktNr NPKUNDE.kundedistriktnavn ~
NPKUNDE.land NPKUNDE.mobil NPKUNDE.telefon NPKUNDE.fax NPKUNDE.organisasjon ~
NPKUNDE.sist_oppdatert NPKUNDE.kundekategori NPKUNDE.dm_kode ~
NPKUNDE.katalog_np_antall NPKUNDE.katalog_np_dato ~
NPKUNDE.katalog_np_oppdatert NPKUNDE.katalog_np_type ~
NPKUNDE.katalog_nt_antall NPKUNDE.katalog_nt_dato ~
NPKUNDE.katalog_nt_oppdatert NPKUNDE.katalog_nt_type NPKUNDE.kilde ~
NPKUNDE.er_konsulent NPKUNDE.konsulentnr NPKUNDE.kontaktperson_np ~
NPKUNDE.kontaktperson_nt NPKUNDE.kontor_type NPKUNDE.kundenr_de ~
NPKUNDE.kundenr_i NPKUNDE.kundenr_sp NPKUNDE.rabatt%_1 NPKUNDE.rabatt%_2 ~
NPKUNDE.tilbudsmottager 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPKUNDE NPKUNDE.kundenr ~
NPKUNDE.adresse1 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPKUNDE NPKUNDE
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPKUNDE NPKUNDE
&Scoped-define QUERY-STRING-BrwNPKUNDE FOR EACH NPKUNDE NO-LOCK, ~
    EACH NPkundedistrikt OF NPKUNDE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPKUNDE OPEN QUERY BrwNPKUNDE FOR EACH NPKUNDE NO-LOCK, ~
    EACH NPkundedistrikt OF NPKUNDE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPKUNDE NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPKUNDE NPKUNDE


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPKUNDE TabNPKUNDE refresh_tbNPKUNDE ~
filter_tbNPKUNDE excel_tbNPKUNDE fiSearch BrwNPKUNDE 
&Scoped-Define DISPLAYED-OBJECTS fiSearch 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbNPKUNDE 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.52 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNPKUNDE 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPKUNDE 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE VARIABLE fiSearch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE TabNPKUNDE
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 157 BY 12.14.

DEFINE RECTANGLE tbNPKUNDE
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 157 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPKUNDE FOR 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPKUNDE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPKUNDE C-Win _STRUCTURED
  QUERY BrwNPKUNDE NO-LOCK DISPLAY
      NPKUNDE.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPKUNDE.kundenavn COLUMN-LABEL "Kundenavn" FORMAT "X(30)":U
      NPKUNDE.adresse1 COLUMN-LABEL "Adresse 1" FORMAT "X(30)":U
      NPKUNDE.adresse2 COLUMN-LABEL "Adresse 2" FORMAT "X(30)":U
      NPKUNDE.postnr COLUMN-LABEL "Postnr." FORMAT "X(8)":U
      NPKUNDE.poststed COLUMN-LABEL "Poststed" FORMAT "X(22)":U
      NPKUNDE.avdeling COLUMN-LABEL "Avd." FORMAT "X(30)":U
      NPKUNDE.avtale COLUMN-LABEL "Avtale" FORMAT "X(6)":U
      NPKUNDE.aktiv COLUMN-LABEL "Aktiv" FORMAT "ja/nei":U
      NPKUNDE.fylke COLUMN-LABEL "Fylke" FORMAT "X(18)":U
      NPKUNDE.kundedistrikt COLUMN-LABEL "Distrikt" FORMAT "X(30)":U
      NPKUNDE.kundedistriktNr COLUMN-LABEL "Dist.nr" FORMAT ">>9":U
      NPKUNDE.kundedistriktnavn COLUMN-LABEL "Distrikt" FORMAT "x(100)":U
      NPKUNDE.land COLUMN-LABEL "Land" FORMAT "X(20)":U
      NPKUNDE.mobil COLUMN-LABEL "Mobil" FORMAT "x(15)":U
      NPKUNDE.telefon COLUMN-LABEL "Telefon" FORMAT "X(15)":U
      NPKUNDE.fax COLUMN-LABEL "Fax" FORMAT "X(15)":U
      NPKUNDE.organisasjon COLUMN-LABEL "Organisasjon" FORMAT "X(1024)":U
            WIDTH 50
      NPKUNDE.sist_oppdatert COLUMN-LABEL "Sist oppd." FORMAT "99.99.9999":U
      NPKUNDE.kundekategori COLUMN-LABEL "Kategori" FORMAT "X(6)":U
      NPKUNDE.dm_kode COLUMN-LABEL "DM kode" FORMAT "X(15)":U
      NPKUNDE.katalog_np_antall COLUMN-LABEL "antall" FORMAT ">9":U
      NPKUNDE.katalog_np_dato COLUMN-LABEL "Katalog NP" FORMAT "99.99.9999":U
      NPKUNDE.katalog_np_oppdatert COLUMN-LABEL "oppdatert" FORMAT "99.99.9999":U
      NPKUNDE.katalog_np_type COLUMN-LABEL "type" FORMAT "X(4)":U
      NPKUNDE.katalog_nt_antall COLUMN-LABEL "antall" FORMAT ">9":U
      NPKUNDE.katalog_nt_dato COLUMN-LABEL "Katalog NP" FORMAT "99.99.9999":U
      NPKUNDE.katalog_nt_oppdatert COLUMN-LABEL "oppdatert" FORMAT "99.99.9999":U
      NPKUNDE.katalog_nt_type COLUMN-LABEL "type" FORMAT "X(4)":U
      NPKUNDE.kilde COLUMN-LABEL "Kilde" FORMAT "X(10)":U
      NPKUNDE.er_konsulent COLUMN-LABEL "Konsulent" FORMAT "yes/no":U
      NPKUNDE.konsulentnr COLUMN-LABEL "konsulentnr" FORMAT ">>>>>>>9":U
      NPKUNDE.kontaktperson_np COLUMN-LABEL "Kontaktperson - NP" FORMAT "X(25)":U
      NPKUNDE.kontaktperson_nt COLUMN-LABEL "Kontaktperson - NT" FORMAT "X(25)":U
      NPKUNDE.kontor_type COLUMN-LABEL "Kontortype" FORMAT "X(15)":U
      NPKUNDE.kundenr_de COLUMN-LABEL "Knr. d.ease" FORMAT "X(8)":U
      NPKUNDE.kundenr_i COLUMN-LABEL "Kundenr" FORMAT ">>>>>>9":U
      NPKUNDE.kundenr_sp COLUMN-LABEL "Knr. spektra" FORMAT "X(8)":U
      NPKUNDE.rabatt%_1 COLUMN-LABEL "Rabatt 1" FORMAT ">>9.99":U
      NPKUNDE.rabatt%_2 COLUMN-LABEL "Rabatt 2" FORMAT ">>9.99":U
      NPKUNDE.tilbudsmottager COLUMN-LABEL "Tilbud" FORMAT "ja/nei":U
  ENABLE
      NPKUNDE.kundenr
      NPKUNDE.adresse1
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 157 BY 6.91 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPKUNDE AT ROW 1.1 COL 1.2 WIDGET-ID 16
     filter_tbNPKUNDE AT ROW 1.1 COL 7.4 WIDGET-ID 22
     excel_tbNPKUNDE AT ROW 1.1 COL 13.4 WIDGET-ID 18
     fiSearch AT ROW 2.67 COL 1 NO-LABEL
     BrwNPKUNDE AT ROW 3.86 COL 1 WIDGET-ID 200
     tbNPKUNDE AT ROW 1 COL 1 WIDGET-ID 2
     TabNPKUNDE AT ROW 11 COL 1 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 158 BY 22.19 WIDGET-ID 100.


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
         TITLE              = "Kunde oppdatering"
         HEIGHT             = 22.19
         WIDTH              = 158
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 159.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 159.8
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
/* BROWSE-TAB BrwNPKUNDE fiSearch DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 22.19
       FRAME DEFAULT-FRAME:WIDTH            = 158.

ASSIGN 
       NPKUNDE.kundedistrikt:VISIBLE IN BROWSE BrwNPKUNDE = FALSE
       NPKUNDE.kundedistriktNr:VISIBLE IN BROWSE BrwNPKUNDE = FALSE.

ASSIGN 
       excel_tbNPKUNDE:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excel,multiSortBrowse;Sorter på flere kolonner,copyBrowseRows;Kopier rad(er)".

/* SETTINGS FOR FILL-IN fiSearch IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbNPKUNDE:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPKUNDE
/* Query rebuild information for BROWSE BrwNPKUNDE
     _TblList          = "norcalc.NPKUNDE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPKUNDE.kundenr
"NPKUNDE.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? yes "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPKUNDE.kundenavn
"NPKUNDE.kundenavn" "Kundenavn" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPKUNDE.adresse1
"NPKUNDE.adresse1" "Adresse 1" "X(30)" "character" ? ? ? ? ? ? yes "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPKUNDE.adresse2
"NPKUNDE.adresse2" "Adresse 2" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPKUNDE.postnr
"NPKUNDE.postnr" "Postnr." "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPKUNDE.poststed
"NPKUNDE.poststed" "Poststed" "X(22)" "character" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPKUNDE.avdeling
"NPKUNDE.avdeling" "Avd." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPKUNDE.avtale
"NPKUNDE.avtale" "Avtale" "X(6)" "character" ? ? ? ? ? ? no "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPKUNDE.aktiv
"NPKUNDE.aktiv" "Aktiv" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPKUNDE.fylke
"NPKUNDE.fylke" "Fylke" "X(18)" "character" ? ? ? ? ? ? no "Velg fylke" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPKUNDE.kundedistrikt
"NPKUNDE.kundedistrikt" "Distrikt" "X(30)" "character" ? ? ? ? ? ? no "Velg distrikt" no no "30" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPKUNDE.kundedistriktNr
"NPKUNDE.kundedistriktNr" "Dist.nr" ">>9" "integer" ? ? ? ? ? ? no "" no no "6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPKUNDE.kundedistriktnavn
"NPKUNDE.kundedistriktnavn" "Distrikt" "x(100)" "character" ? ? ? ? ? ? no "" no no "100" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPKUNDE.land
"NPKUNDE.land" "Land" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPKUNDE.mobil
"NPKUNDE.mobil" "Mobil" "x(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPKUNDE.telefon
"NPKUNDE.telefon" "Telefon" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPKUNDE.fax
"NPKUNDE.fax" "Fax" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPKUNDE.organisasjon
"NPKUNDE.organisasjon" "Organisasjon" "X(1024)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPKUNDE.sist_oppdatert
"NPKUNDE.sist_oppdatert" "Sist oppd." "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPKUNDE.kundekategori
"NPKUNDE.kundekategori" "Kategori" "X(6)" "character" ? ? ? ? ? ? no "Velg kundekategori" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPKUNDE.dm_kode
"NPKUNDE.dm_kode" "DM kode" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPKUNDE.katalog_np_antall
"NPKUNDE.katalog_np_antall" "antall" ">9" "integer" ? ? ? ? ? ? no "" no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPKUNDE.katalog_np_dato
"NPKUNDE.katalog_np_dato" "Katalog NP" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPKUNDE.katalog_np_oppdatert
"NPKUNDE.katalog_np_oppdatert" "oppdatert" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPKUNDE.katalog_np_type
"NPKUNDE.katalog_np_type" "type" "X(4)" "character" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPKUNDE.katalog_nt_antall
"NPKUNDE.katalog_nt_antall" "antall" ">9" "integer" ? ? ? ? ? ? no "" no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPKUNDE.katalog_nt_dato
"NPKUNDE.katalog_nt_dato" "Katalog NP" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPKUNDE.katalog_nt_oppdatert
"NPKUNDE.katalog_nt_oppdatert" "oppdatert" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > NPKUNDE.katalog_nt_type
"NPKUNDE.katalog_nt_type" "type" "X(4)" "character" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > NPKUNDE.kilde
"NPKUNDE.kilde" "Kilde" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > NPKUNDE.er_konsulent
"NPKUNDE.er_konsulent" "Konsulent" "yes/no" "logical" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > NPKUNDE.konsulentnr
"NPKUNDE.konsulentnr" "konsulentnr" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > NPKUNDE.kontaktperson_np
"NPKUNDE.kontaktperson_np" "Kontaktperson - NP" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > NPKUNDE.kontaktperson_nt
"NPKUNDE.kontaktperson_nt" "Kontaktperson - NT" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > NPKUNDE.kontor_type
"NPKUNDE.kontor_type" "Kontortype" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > NPKUNDE.kundenr_de
"NPKUNDE.kundenr_de" "Knr. d.ease" "X(8)" "character" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > NPKUNDE.kundenr_i
"NPKUNDE.kundenr_i" "Kundenr" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > NPKUNDE.kundenr_sp
"NPKUNDE.kundenr_sp" "Knr. spektra" "X(8)" "character" ? ? ? ? ? ? no "" no no "11.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > NPKUNDE.rabatt%_1
"NPKUNDE.rabatt%_1" "Rabatt 1" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > NPKUNDE.rabatt%_2
"NPKUNDE.rabatt%_2" "Rabatt 2" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[41]   > NPKUNDE.tilbudsmottager
"NPKUNDE.tilbudsmottager" "Tilbud" "ja/nei" "logical" ? ? ? ? ? ? no "Denne kunden kan motta tilbud (J/N)" no no "5.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPKUNDE */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Kunde oppdatering */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Kunde oppdatering */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPKUNDE
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
{incl/conttrigg.i oBrwNPKUNDE:BROWSE-HANDLE}

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
  DISPLAY fiSearch 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPKUNDE TabNPKUNDE refresh_tbNPKUNDE filter_tbNPKUNDE 
         excel_tbNPKUNDE fiSearch BrwNPKUNDE 
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

  oBrwNPKUNDE = NEW JBoxBrowse(brwNPKUNDE:HANDLE).
  oBrwNPKUNDE:setSearchField(fiSearch:handle).
  oBrwNPKUNDE:setNoResizeY().
  otbNPKUNDE = NEW JBoxToolbar(tbNPKUNDE:HANDLE).

  oBrwNPKUNDE:TOOLBAR-OBJECT = otbNPKUNDE.
  oTabNPKUNDE = NEW JBoxMSTabs(TabNPKUNDE:HANDLE,oBrwNPKUNDE,"img/ico/id_card.ico,img/ico/phone_recall.ico,img/ico/folder2.ico,img/ico/businesspeople.ico").
  oTabNPKUNDE:pageOneType = "oneToOne".
  oTabNPKUNDE:setLinkFields("kundenr").
  oTabNPKUNDE:AddPage("Kunde detaljer","wNPKundedetalj.w","id_card.ico").
  
  oTabNPKUNDE:setLinkFields("iKundeId;Kundenr",2).
  oTabNPKUNDE:AddPage("Kontakter","wKundekontakt.w","businesspeople.ico").

  oTabNPKUNDE:setLinkFields("Kundenr",3).
  oTabNPKUNDE:AddPage("Oppfølging","wNPKundeoppfølging.w","phone_recall.ico").

  oTabNPKUNDE:setLinkFields("Kundenr",4).
  oTabNPKUNDE:AddPage("Shunt anlegg","wSHanleggBrw.w","folder2.ico").

  oTabNPKUNDE:setLinkFields("kundenr",5).
  oTabNPKUNDE:AddPage("Spirovent anlegg","wSPanleggBrw.w","folder2.ico").

  opopupNPKUNDE = NEW JBoxPopupMenu().
  opopupNPKUNDE:AddToolGroup('refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excel,multiSortBrowse;Sorter på flere kolonner').

  oBrwNPKUNDE:POPUP-MENU-OBJECT = opopupNPKUNDE.
END.
oBrwNPKUNDE:OpenQuery().


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE multiSortBrowseRecord C-Win 
PROCEDURE multiSortBrowseRecord :
RUN SUPER.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

