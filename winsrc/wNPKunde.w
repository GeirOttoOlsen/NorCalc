&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS Procedure
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
    FIELD fylke AS character
    FIELD kundedistriktNr AS integer
    FIELD kundedistrikt AS character
    FIELD land AS character
    FIELD avtale AS character
    FIELD aktiv AS logical
    FIELD avdeling AS character
    FIELD kundedistriktnavn AS character
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
     + ';fylke'
     + ';kundedistriktNr'
     + ';kundedistrikt'
     + ';land'
     + ';avtale'
     + ';aktiv'
     + ';avdeling'
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
     + ';konsulentnr|konsulentnr'
     + ';kontaktperson_np'
     + ';kontaktperson_nt'
     + ';kontor_type'
     + ';kundenr_de|kundenr dataease'
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
  RETURN 'EACH NPkundedistrikt OF NPKUNDE OUTER-JOIN NO-LOCK'.
END FUNCTION.
DEF VAR otbNPKUNDE AS JBoxToolbar NO-UNDO.
DEF VAR oTabNPKUNDE AS JBoxMsTabs NO-UNDO.


DEF VAR opopupNPKUNDE AS JBoxPopupMenu NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 12/04/20 -  2:53 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
NPKUNDE.fylke NPKUNDE.kundedistriktNr NPKUNDE.kundedistrikt NPKUNDE.land ~
NPKUNDE.avtale NPKUNDE.aktiv NPKUNDE.avdeling NPKUNDE.kundedistriktnavn ~
NPKUNDE.mobil NPKUNDE.telefon NPKUNDE.fax NPKUNDE.organisasjon ~
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
&Scoped-define QUERY-STRING-BrwNPKUNDE FOR EACH NPKUNDE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPKUNDE OPEN QUERY BrwNPKUNDE FOR EACH NPKUNDE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPKUNDE NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPKUNDE NPKUNDE


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPKUNDE TabNPKUNDE refresh_tbNPKUNDE ~
filter_tbNPKUNDE excel_tbNPKUNDE btnSearch btnClear fiSearch Prosjekt ~
Tilbudsnr BrwNPKUNDE 
&Scoped-Define DISPLAYED-OBJECTS fiSearch Prosjekt Tilbudsnr 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnClear 
     LABEL "Blank" 
     SIZE 7 BY 1.14 TOOLTIP "Nullstill sï¿½k".

DEFINE BUTTON btnSearch 
     LABEL "Søk" 
     SIZE 7 BY 1.14 TOOLTIP "Sï¿½k".

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

DEFINE VARIABLE Prosjekt AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prosjekt" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE VARIABLE Tilbudsnr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tilbudsnr" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE RECTANGLE TabNPKUNDE
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 157 BY 10.48.

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
      NPKUNDE.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(15)":U
      NPKUNDE.kundenavn COLUMN-LABEL "Kundenavn" FORMAT "X(30)":U
      NPKUNDE.adresse1 COLUMN-LABEL "Adresse 1" FORMAT "X(30)":U
      NPKUNDE.adresse2 COLUMN-LABEL "Adresse 2" FORMAT "X(30)":U
      NPKUNDE.postnr COLUMN-LABEL "Postnr." FORMAT "X(8)":U
      NPKUNDE.poststed COLUMN-LABEL "Poststed" FORMAT "X(22)":U
      NPKUNDE.fylke COLUMN-LABEL "Fylke" FORMAT "X(18)":U
      NPKUNDE.kundedistriktNr COLUMN-LABEL "Dist.nr" FORMAT ">>9":U
      NPKUNDE.kundedistrikt COLUMN-LABEL "Distrikt" FORMAT "X(30)":U
      NPKUNDE.land COLUMN-LABEL "Land" FORMAT "X(20)":U
      NPKUNDE.avtale COLUMN-LABEL "Avtale" FORMAT "X(6)":U
      NPKUNDE.aktiv COLUMN-LABEL "Aktiv" FORMAT "ja/nei":U
      NPKUNDE.avdeling COLUMN-LABEL "Avd." FORMAT "X(30)":U
      NPKUNDE.kundedistriktnavn COLUMN-LABEL "Distrikt" FORMAT "x(100)":U
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
      NPKUNDE.kundenr_de COLUMN-LABEL "Knr. d.ease" FORMAT "X(15)":U
      NPKUNDE.kundenr_i COLUMN-LABEL "Kundenr" FORMAT ">>>>>>>9":U
      NPKUNDE.kundenr_sp COLUMN-LABEL "Knr. spektra" FORMAT "X(8)":U
      NPKUNDE.rabatt%_1 COLUMN-LABEL "Rabatt 1" FORMAT ">>9.99":U
      NPKUNDE.rabatt%_2 COLUMN-LABEL "Rabatt 2" FORMAT ">>9.99":U
      NPKUNDE.tilbudsmottager COLUMN-LABEL "Tilbud" FORMAT "ja/nei":U
  ENABLE
      NPKUNDE.kundenr
      NPKUNDE.adresse1
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 157 BY 8.33 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPKUNDE AT ROW 1.1 COL 1.2 WIDGET-ID 16
     filter_tbNPKUNDE AT ROW 1.1 COL 7.4 WIDGET-ID 22
     excel_tbNPKUNDE AT ROW 1.1 COL 13.4 WIDGET-ID 18
     btnSearch AT ROW 2.52 COL 114 WIDGET-ID 28
     btnClear AT ROW 2.52 COL 121 WIDGET-ID 30
     fiSearch AT ROW 2.67 COL 1 NO-LABEL
     Prosjekt AT ROW 2.67 COL 26 COLON-ALIGNED
     Tilbudsnr AT ROW 2.67 COL 75 COLON-ALIGNED
     BrwNPKUNDE AT ROW 3.86 COL 1 WIDGET-ID 200
     tbNPKUNDE AT ROW 1 COL 1 WIDGET-ID 2
     TabNPKUNDE AT ROW 12.67 COL 1 WIDGET-ID 20
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
/* BROWSE-TAB BrwNPKUNDE Tilbudsnr DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 22.19
       FRAME DEFAULT-FRAME:WIDTH            = 158.

ASSIGN 
       NPKUNDE.kundedistriktNr:VISIBLE IN BROWSE BrwNPKUNDE = FALSE
       NPKUNDE.kundedistrikt:VISIBLE IN BROWSE BrwNPKUNDE = FALSE.

ASSIGN 
       excel_tbNPKUNDE:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excel,multiSortBrowse;Sorter pï¿½ flere kolonner,copyBrowseRows;Kopier rad(er)".

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
     _TblOptList       = ", OUTER, OUTER, OUTER, OUTER"
     _FldNameList[1]   > "_<CALC>"
"NPKUNDE.kundenr" "Kundenr" "X(15)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPKUNDE.kundenavn" "Kundenavn" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPKUNDE.adresse1" "Adresse 1" "X(30)" "character" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPKUNDE.adresse2" "Adresse 2" "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPKUNDE.postnr" "Postnr." "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPKUNDE.poststed" "Poststed" "X(22)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPKUNDE.fylke" "Fylke" "X(18)" "character" ? ? ? ? ? ? no "Velg fylke" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPKUNDE.kundedistriktNr" "Dist.nr" ">>9" "integer" ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPKUNDE.kundedistrikt" "Distrikt" "X(30)" "character" ? ? ? ? ? ? no "Velg distrikt" no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPKUNDE.land" "Land" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPKUNDE.avtale" "Avtale" "X(6)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPKUNDE.aktiv" "Aktiv" "ja/nei" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPKUNDE.avdeling" "Avd." "X(30)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPKUNDE.kundedistriktnavn" "Distrikt" "x(100)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPKUNDE.mobil" "Mobil" "x(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPKUNDE.telefon" "Telefon" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPKUNDE.fax" "Fax" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPKUNDE.organisasjon" "Organisasjon" "X(1024)" "character" ? ? ? ? ? ? no ? no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPKUNDE.sist_oppdatert" "Sist oppd." "99.99.9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPKUNDE.kundekategori" "Kategori" "X(6)" "character" ? ? ? ? ? ? no "Velg kundekategori" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"NPKUNDE.dm_kode" "DM kode" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"NPKUNDE.katalog_np_antall" "antall" ">9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"NPKUNDE.katalog_np_dato" "Katalog NP" "99.99.9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"NPKUNDE.katalog_np_oppdatert" "oppdatert" "99.99.9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"NPKUNDE.katalog_np_type" "type" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"NPKUNDE.katalog_nt_antall" "antall" ">9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > "_<CALC>"
"NPKUNDE.katalog_nt_dato" "Katalog NP" "99.99.9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > "_<CALC>"
"NPKUNDE.katalog_nt_oppdatert" "oppdatert" "99.99.9999" "date" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"NPKUNDE.katalog_nt_type" "type" "X(4)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > "_<CALC>"
"NPKUNDE.kilde" "Kilde" "X(10)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > "_<CALC>"
"NPKUNDE.er_konsulent" "Konsulent" "yes/no" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > "_<CALC>"
"NPKUNDE.konsulentnr" "konsulentnr" ">>>>>>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > "_<CALC>"
"NPKUNDE.kontaktperson_np" "Kontaktperson - NP" "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > "_<CALC>"
"NPKUNDE.kontaktperson_nt" "Kontaktperson - NT" "X(25)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > "_<CALC>"
"NPKUNDE.kontor_type" "Kontortype" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > "_<CALC>"
"NPKUNDE.kundenr_de" "Knr. d.ease" "X(15)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > "_<CALC>"
"NPKUNDE.kundenr_i" "Kundenr" ">>>>>>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > "_<CALC>"
"NPKUNDE.kundenr_sp" "Knr. spektra" "X(8)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > "_<CALC>"
"NPKUNDE.rabatt%_1" "Rabatt 1" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > "_<CALC>"
"NPKUNDE.rabatt%_2" "Rabatt 2" ">>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[41]   > "_<CALC>"
"NPKUNDE.tilbudsmottager" "Tilbud" "ja/nei" "logical" ? ? ? ? ? ? no "Denne kunden kan motta tilbud (J/N)" no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define SELF-NAME btnClear
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnClear C-Win
ON CHOOSE OF btnClear IN FRAME DEFAULT-FRAME /* Blank */
DO:
 /*  oBrwNPKUNDE:setFilter(icFieldList, icOperList, icValueList)*/
  Prosjekt:screen-value = ''.
  Tilbudsnr:screen-value = ''. 
  oBrwNPKUNDE:preScanBaseQuery = ''.
  oBrwNPKUNDE:openQuery().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSearch C-Win
ON CHOOSE OF btnSearch IN FRAME DEFAULT-FRAME /* Sï¿½k */
DO:
  if prosjekt:SCREEN-VALUE ne '' and Tilbudsnr:screen-value ne '' then undo, throw new Progress.Lang.AppError('Kan ikke sï¿½ke pï¿½ bï¿½de begge feltene',1).
  if prosjekt:screen-value = '' and Tilbudsnr:screen-value = '' then return no-apply.  
  if prosjekt:screen-value ne '' then 
    oBrwNPKUNDE:preScanBaseQuery = 'norprosjekt where prosjekt_navn' + (if index(prosjekt:screen-value,'*') gt 0 then ' matches ' else ' begins ') + quoter(Prosjekt:screen-value) + ',each npshanlg of norprosjekt, each npshtilbud of npshanlg, each npkunde of npshtilbud'.
  else 
    oBrwNPKUNDE:preScanBaseQuery = 'npshtilbud where tilbudsnr' + (if index(tilbudsnr:screen-value,'*') gt 0 then ' matches ' else ' begins ') + quoter(tilbudsnr:screen-value) + ', each npkunde of npshtilbud'.
  oBrwNPKUNDE:openQuery().
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
  DISPLAY fiSearch Prosjekt Tilbudsnr 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPKUNDE TabNPKUNDE refresh_tbNPKUNDE filter_tbNPKUNDE 
         excel_tbNPKUNDE btnSearch btnClear fiSearch Prosjekt Tilbudsnr 
         BrwNPKUNDE 
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
  
  oTabNPKUNDE:setLinkFields("id;kundenr",2).
  oTabNPKUNDE:AddPage("Kontakter","wNPkontakt2.w","businesspeople.ico").

  oTabNPKUNDE:setLinkFields("Kundenr",3).
  oTabNPKUNDE:AddPage("Oppfølging","wNPKundeoppfolging.w","phone_recall.ico").

  oTabNPKUNDE:setLinkFields("Kundenr",4).
  oTabNPKUNDE:AddPage("Tilbud","wSHTilbudBrw.w","folder2.ico").

  oTabNPKUNDE:setLinkFields("Kundenr",5).
  oTabNPKUNDE:AddPage("Tilbud oppfølging","wSHTilbudBrw2.w","folder2.ico").

  oTabNPKUNDE:setLinkFields("Kundenr",6).
  oTabNPKUNDE:AddPage("Shunt anlegg","wSHanleggBrw.w","folder2.ico").

  oTabNPKUNDE:setLinkFields("Kundenr",7).
  oTabNPKUNDE:AddPage("Anlegg via tilbud","wSHanleggBrw3.w","folder2.ico").

/*  oTabNPKUNDE:setLinkFields("kundenr",5).                                */
/*  oTabNPKUNDE:AddPage("Spirovent anlegg","wSPanleggBrw.w","folder2.ico").*/

  opopupNPKUNDE = NEW JBoxPopupMenu().
  opopupNPKUNDE:AddToolGroup('refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excel,multiSortBrowse;Sorter pï¿½ flere kolonner').

  oBrwNPKUNDE:POPUP-MENU-OBJECT = opopupNPKUNDE.
END.
oBrwNPKUNDE:OpenQuery().


oContainer:initResize(400,500).

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


