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
def var hParent     as handle no-undo.
def var iAnleggsNr   as int no-undo.

def var nyRecord as log no-undo.
def var current-rec as rowid no-undo.

/*** Start instance property definitions for JBoxBrowse object oBrwNPSPSYST ***/
DEF VAR oBrwNPSPSYST AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPSYST
    FIELD anleggsnr AS integer
    FIELD systemnr AS integer
    FIELD systembetegnelse AS character
    FIELD varenr AS integer
    FIELD produktnavn AS character
    FIELD produkttype AS character
    FIELD antall AS integer
    FIELD nrf_nr AS integer
    FIELD listepris AS decimal
    FIELD anbefalt_max_kap AS decimal
    FIELD anb_max_innl_hast AS character
    FIELD anslutning AS character
    FIELD avstand_flotor AS integer
    FIELD beregnet_anvendelse AS character
    FIELD dimmensjon AS character
    FIELD faktor AS decimal
    FIELD glykoltype AS character
    FIELD innl_hastighet AS decimal
    FIELD innmat AS character
    FIELD isolasjon AS character
    FIELD konsentrasjon AS character
    FIELD kuleventil_ja_nei AS logical
    FIELD kuleventil_verdi AS character
    FIELD materialkvaliteter AS character
    FIELD max_temp AS integer
    FIELD max_trykk AS decimal
    FIELD medietemperatur AS character
    FIELD motflenser AS logical
    FIELD refill AS logical
    FIELD ror_dim AS decimal
    FIELD spiroventkapasitet AS decimal
    FIELD trykkfall AS decimal
    FIELD utv_gjengeventil AS logical
    FIELD vegg_tykkelse AS decimal
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSPSYST FOR TEMP-TABLE NPSPSYST.


FUNCTION getBuffersAndFieldsBrwNPSPSYST RETURNS CHARACTER():
  RETURN
    'NPSPSYST'
     + ';anleggsnr'
     + ';systemnr'
     + ';systembetegnelse'
     + ';varenr'
     + ';produktnavn'
     + ';produkttype'
     + ';antall'
     + ';nrf_nr'
     + ';listepris'
     + ';anbefalt_max_kap'
     + ';anb_max_innl_hast'
     + ';anslutning'
     + ';avstand_flotor'
     + ';beregnet_anvendelse'
     + ';dimmensjon'
     + ';faktor'
     + ';glykoltype'
     + ';innl_hastighet'
     + ';innmat'
     + ';isolasjon'
     + ';konsentrasjon'
     + ';kuleventil_ja_nei'
     + ';kuleventil_verdi'
     + ';materialkvaliteter'
     + ';max_temp'
     + ';max_trykk'
     + ';medietemperatur'
     + ';motflenser'
     + ';refill'
     + ';ror_dim'
     + ';spiroventkapasitet'
     + ';trykkfall'
     + ';utv_gjengeventil'
     + ';vegg_tykkelse'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPSYST RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.


DEF VAR otbNPSPSYST AS JBoxToolbar NO-UNDO.
DEF VAR oFmNPSPSYST AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSPSYST

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPSYST

/* Definitions for BROWSE BrwNPSPSYST                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPSYST NPSPSYST.anleggsnr ~
NPSPSYST.systemnr NPSPSYST.systembetegnelse NPSPSYST.varenr ~
NPSPSYST.produktnavn NPSPSYST.produkttype NPSPSYST.antall NPSPSYST.nrf_nr ~
NPSPSYST.listepris NPSPSYST.anbefalt_max_kap NPSPSYST.anb_max_innl_hast ~
NPSPSYST.anslutning NPSPSYST.avstand_flotor NPSPSYST.beregnet_anvendelse ~
NPSPSYST.dimmensjon NPSPSYST.faktor NPSPSYST.glykoltype ~
NPSPSYST.innl_hastighet NPSPSYST.innmat NPSPSYST.isolasjon ~
NPSPSYST.konsentrasjon NPSPSYST.kuleventil_ja_nei NPSPSYST.kuleventil_verdi ~
NPSPSYST.materialkvaliteter NPSPSYST.max_temp NPSPSYST.max_trykk ~
NPSPSYST.medietemperatur NPSPSYST.motflenser NPSPSYST.refill ~
NPSPSYST.ror_dim NPSPSYST.spiroventkapasitet NPSPSYST.trykkfall ~
NPSPSYST.utv_gjengeventil NPSPSYST.vegg_tykkelse 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPSYST NPSPSYST.anleggsnr ~
NPSPSYST.systemnr 
&Scoped-define QUERY-STRING-BrwNPSPSYST FOR EACH NPSPSYST NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPSYST OPEN QUERY BrwNPSPSYST FOR EACH NPSPSYST NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPSYST NPSPSYST
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPSYST NPSPSYST


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPSYST new_tbNPSPSYST edit_tbNPSPSYST ~
copy_tbNPSPSYST save_tbNPSPSYST undo_tbNPSPSYST delete_tbNPSPSYST ~
refresh_tbNPSPSYST excel_tbNPSPSYST UtskriftSaksmappe_tbNPSPSYST ~
BrwNPSPSYST systemnr anleggsnr systembetegnelse produktnavn ~
beregnet_anvendelse anslutning isolasjon max_trykk materialkvaliteter ~
max_temp medietemperatur kuleventil_ja_nei utv_gjengeventil refill ~
motflenser glykoltype konsentrasjon spiroventkapasitet dimmensjon ~
innl_hastighet listepris antall SYSTEMPRIS 
&Scoped-Define DISPLAYED-OBJECTS systemnr anleggsnr systembetegnelse ~
produktnavn beregnet_anvendelse anslutning isolasjon max_trykk ~
materialkvaliteter max_temp medietemperatur kuleventil_ja_nei ~
utv_gjengeventil refill motflenser glykoltype konsentrasjon ~
spiroventkapasitet dimmensjon innl_hastighet listepris antall SYSTEMPRIS 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRec C-Win 
FUNCTION getCurrentRec RETURNS ROWID
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNyRecord C-Win 
FUNCTION getNyRecord RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentRec C-Win 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentHandle C-Win 
FUNCTION setParentHandle RETURNS LOGICAL
  ( INPUT ipHandle AS handle )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/documents.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/documents_disabled.gif":U
     LABEL "Kopier" 
     SIZE 7.8 BY 1.95 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/document_delete.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_delete_disabled.gif":U
     LABEL "Delete" 
     SIZE 7.8 BY 1.95 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON edit_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/document_edit.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_edit_disabled.gif":U
     LABEL "Edit" 
     SIZE 7.8 BY 1.95 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON new_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/document_add.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_add_disabled.gif":U
     LABEL "New" 
     SIZE 7.8 BY 1.95 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/floppy_disk_disabled.gif":U
     LABEL "Lagre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPSPSYST 
     IMAGE-UP FILE "img/ico/undo.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/undo_disabled.gif":U
     LABEL "Angre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Angre (CTRL-Z)".

DEFINE BUTTON UtskriftSaksmappe_tbNPSPSYST 
     IMAGE-UP FILE "ico\print_layout_single.ico":U
     LABEL "Saksmappe" 
     SIZE 7.8 BY 1.95 TOOLTIP "Utskrift til saksmappe".

DEFINE VARIABLE anslutning AS CHARACTER FORMAT "X(18)" 
     LABEL "Anslutning" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Gjenget","Gjenget",
                     "Union","Union",
                     "Klemkopling","Klemkopling",
                     "Sveisestuss","Sveisestuss",
                     "Flens DIN2632","Flens DIN2632",
                     "Flens DIN2633","Flens DIN2633"
     DROP-DOWN-LIST
     SIZE 31 BY 1.

DEFINE VARIABLE beregnet_anvendelse AS CHARACTER FORMAT "X(18)" INITIAL "Ukjent" 
     LABEL "Anv.omr." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Varme","Varme",
                     "Lavtemperatur","Lavtemperatur",
                     "Kjøle","Kjøle",
                     "Fryse","Fryse",
                     "Varmegjenvinning","Varmegjenvinning",
                     "Ukjent","Ukjent"
     DROP-DOWN-LIST
     SIZE 31 BY 1.

DEFINE VARIABLE glykoltype AS CHARACTER FORMAT "X(20)" INITIAL "Ingen" 
     LABEL "Glykoltype" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEM-PAIRS "Ingen","Ingen",
                     "Monoetylenglykol","Monoetylenglykol",
                     "Monopropylenglykol","Monopropylenglykol",
                     "Ukjent","Ukjent"
     DROP-DOWN-LIST
     SIZE 33.8 BY 1
     FGCOLOR 1 .

DEFINE VARIABLE isolasjon AS CHARACTER FORMAT "X(18)" 
     LABEL "Mantel/Isol." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Mineralull","Mineralull",
                     "Cellegummi 13mm","Cellegummi 13mm",
                     "Cellegummi 19mm","Cellegummi 19mm",
                     "Cellegummi 24mm","Cellegummi 24mm"
     DROP-DOWN-LIST
     SIZE 31 BY 1.

DEFINE VARIABLE konsentrasjon AS CHARACTER FORMAT "X(8)" INITIAL "0" 
     LABEL "Konsentrasjon" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0","0",
                     "5","5",
                     "10","10",
                     "15","15",
                     "20","20",
                     "25","25",
                     "30","30",
                     "35","35",
                     "40","40",
                     "45","45",
                     "50","50",
                     "Ukjent","Ukjent"
     DROP-DOWN-LIST
     SIZE 17 BY 1.

DEFINE VARIABLE materialkvaliteter AS CHARACTER FORMAT "X(25)" 
     LABEL "Materialkvaliteter" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "Standard ihht brosjyre","ST.37.2","MESSING","AISI 304","AISI 316","Spesial" 
     DROP-DOWN-LIST
     SIZE 40.8 BY 1.

DEFINE VARIABLE anleggsnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Anleggsnr" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1 NO-UNDO.

DEFINE VARIABLE antall AS INTEGER FORMAT ">>9" INITIAL 1 
     LABEL "Antall" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 6.8 BY 1.24.

DEFINE VARIABLE dimmensjon AS CHARACTER FORMAT "X(45)" 
     LABEL "Dimmensjon" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 73.2 BY 1.24.

DEFINE VARIABLE innl_hastighet AS DECIMAL FORMAT "9.99" INITIAL 0 
     LABEL "Innl.hast." 
     VIEW-AS FILL-IN NATIVE 
     SIZE 7.6 BY 1.24.

DEFINE VARIABLE listepris AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Listepris" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 18 BY 1.24.

DEFINE VARIABLE max_temp AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Max temp." 
     VIEW-AS FILL-IN NATIVE 
     SIZE 6.2 BY 1.24.

DEFINE VARIABLE max_trykk AS DECIMAL FORMAT ">>>9.9<" INITIAL 0 
     LABEL "Max trykk" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 6.2 BY 1.24.

DEFINE VARIABLE medietemperatur AS CHARACTER FORMAT "X(5)" 
     LABEL "Medietemperatur" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 13.2 BY 1.24.

DEFINE VARIABLE produktnavn AS CHARACTER FORMAT "X(60)":U 
     LABEL "Produktnavn" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 48.4 BY 1.24 NO-UNDO.

DEFINE VARIABLE spiroventkapasitet AS DECIMAL FORMAT "->>9.999" INITIAL 0 
     LABEL "Kapasitet" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 14.8 BY 1.24.

DEFINE VARIABLE systembetegnelse AS CHARACTER FORMAT "X(40)" 
     LABEL "Systembetegnelse" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 58 BY 1.24.

DEFINE VARIABLE systemnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Systemnr" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1.

DEFINE VARIABLE SYSTEMPRIS AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Systempris" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19.6 BY 1.24 NO-UNDO.

DEFINE RECTANGLE tbNPSPSYST
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 141 BY 2.14.

DEFINE VARIABLE kuleventil_ja_nei AS LOGICAL INITIAL no 
     LABEL "Kuleventil" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.6 BY .95.

DEFINE VARIABLE motflenser AS LOGICAL INITIAL no 
     LABEL "Motflenser" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .95.

DEFINE VARIABLE refill AS LOGICAL INITIAL no 
     LABEL "Refill" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.2 BY .95.

DEFINE VARIABLE utv_gjengeventil AS LOGICAL INITIAL no 
     LABEL "Utv. gjenget lufteventil" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .95.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPSYST FOR 
      NPSPSYST SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPSYST
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPSYST C-Win _STRUCTURED
  QUERY BrwNPSPSYST NO-LOCK DISPLAY
      NPSPSYST.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPSYST.systemnr COLUMN-LABEL "Systemnr" FORMAT ">>>>>9":U
      NPSPSYST.systembetegnelse COLUMN-LABEL "Syst.bet." FORMAT "X(40)":U
            WIDTH 40.6
      NPSPSYST.varenr COLUMN-LABEL "Varenr" FORMAT "9999999":U
      NPSPSYST.produktnavn COLUMN-LABEL "Produktnavn" FORMAT "X(45)":U
      NPSPSYST.produkttype COLUMN-LABEL "Produkttype" FORMAT "X(45)":U
      NPSPSYST.antall COLUMN-LABEL "Antall" FORMAT ">>9":U
      NPSPSYST.nrf_nr COLUMN-LABEL "NRF" FORMAT "9999999":U
      NPSPSYST.listepris COLUMN-LABEL "Listepris" FORMAT ">>,>>>,>>9.99":U
      NPSPSYST.anbefalt_max_kap COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSPSYST.anb_max_innl_hast COLUMN-LABEL "Anb. max innl. hast." FORMAT "X(5)":U
      NPSPSYST.anslutning COLUMN-LABEL "Anslutning" FORMAT "X(18)":U
      NPSPSYST.avstand_flotor COLUMN-LABEL "Avstand flotør" FORMAT ">>9":U
      NPSPSYST.beregnet_anvendelse COLUMN-LABEL "Anvendelse" FORMAT "X(18)":U
      NPSPSYST.dimmensjon COLUMN-LABEL "Dimm." FORMAT "X(45)":U
      NPSPSYST.faktor COLUMN-LABEL "Faktor" FORMAT "9.999":U
      NPSPSYST.glykoltype COLUMN-LABEL "Glyk.type" FORMAT "X(20)":U
      NPSPSYST.innl_hastighet COLUMN-LABEL "Innl.hast." FORMAT "9.99":U
      NPSPSYST.innmat COLUMN-LABEL "Innmat" FORMAT "X(25)":U
      NPSPSYST.isolasjon COLUMN-LABEL "Mantel/Isolasjon" FORMAT "X(18)":U
      NPSPSYST.konsentrasjon COLUMN-LABEL "Kons." FORMAT "X(8)":U
      NPSPSYST.kuleventil_ja_nei COLUMN-LABEL "Kuleventil" FORMAT "ja/nei":U
      NPSPSYST.kuleventil_verdi COLUMN-LABEL "Kuleventil" FORMAT "X(5)":U
      NPSPSYST.materialkvaliteter COLUMN-LABEL "Materialkval." FORMAT "X(25)":U
      NPSPSYST.max_temp COLUMN-LABEL "Max temp." FORMAT ">>9":U
      NPSPSYST.max_trykk COLUMN-LABEL "Max trykk" FORMAT ">>>9.9<":U
      NPSPSYST.medietemperatur COLUMN-LABEL "Med. temp" FORMAT "X(5)":U
      NPSPSYST.motflenser COLUMN-LABEL "Motflenser" FORMAT "ja/nei":U
      NPSPSYST.refill COLUMN-LABEL "Refill" FORMAT "ja/nei":U
      NPSPSYST.ror_dim COLUMN-LABEL "Rørdim." FORMAT ">>9.99":U
      NPSPSYST.spiroventkapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSPSYST.trykkfall COLUMN-LABEL "Trykkfall" FORMAT ">,>>9.99":U
      NPSPSYST.utv_gjengeventil COLUMN-LABEL "Utv. gjenget lufteventil" FORMAT "ja/nei":U
      NPSPSYST.vegg_tykkelse COLUMN-LABEL "Veggtykkelse" FORMAT ">>9.99":U
  ENABLE
      NPSPSYST.anleggsnr
      NPSPSYST.systemnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 141 BY 5.24 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSPSYST AT ROW 1.1 COL 1.2 WIDGET-ID 4
     edit_tbNPSPSYST AT ROW 1.1 COL 9.2 WIDGET-ID 12
     copy_tbNPSPSYST AT ROW 1.1 COL 17 WIDGET-ID 62
     save_tbNPSPSYST AT ROW 1.1 COL 24.8 WIDGET-ID 66
     undo_tbNPSPSYST AT ROW 1.1 COL 32.6 WIDGET-ID 64
     delete_tbNPSPSYST AT ROW 1.1 COL 40.4 WIDGET-ID 6
     refresh_tbNPSPSYST AT ROW 1.1 COL 48.2 WIDGET-ID 8
     excel_tbNPSPSYST AT ROW 1.1 COL 56 WIDGET-ID 10
     UtskriftSaksmappe_tbNPSPSYST AT ROW 1.1 COL 63.8 WIDGET-ID 68
     BrwNPSPSYST AT ROW 3.62 COL 1 WIDGET-ID 200
     systemnr AT ROW 9.81 COL 48 COLON-ALIGNED
     anleggsnr AT ROW 9.86 COL 26 COLON-ALIGNED
     systembetegnelse AT ROW 11 COL 26 COLON-ALIGNED
     produktnavn AT ROW 12.43 COL 26 COLON-ALIGNED
     beregnet_anvendelse AT ROW 12.43 COL 90 COLON-ALIGNED WIDGET-ID 18
     anslutning AT ROW 13.76 COL 26 COLON-ALIGNED WIDGET-ID 60
     isolasjon AT ROW 13.76 COL 90 COLON-ALIGNED WIDGET-ID 28
     max_trykk AT ROW 15.05 COL 115 COLON-ALIGNED
     materialkvaliteter AT ROW 15.14 COL 26.2 COLON-ALIGNED WIDGET-ID 36
     max_temp AT ROW 15.14 COL 85.2 COLON-ALIGNED
     medietemperatur AT ROW 16.52 COL 26 COLON-ALIGNED
     kuleventil_ja_nei AT ROW 16.76 COL 43.4 WIDGET-ID 32
     utv_gjengeventil AT ROW 16.76 COL 59.6 WIDGET-ID 58
     refill AT ROW 16.76 COL 90 WIDGET-ID 46
     motflenser AT ROW 16.76 COL 102.6 WIDGET-ID 44
     glykoltype AT ROW 17.95 COL 26 COLON-ALIGNED WIDGET-ID 24
     konsentrasjon AT ROW 17.95 COL 90 COLON-ALIGNED WIDGET-ID 30
     spiroventkapasitet AT ROW 19.33 COL 26 COLON-ALIGNED
     dimmensjon AT ROW 20.71 COL 26 COLON-ALIGNED
     innl_hastighet AT ROW 20.76 COL 113 COLON-ALIGNED
     listepris AT ROW 22.19 COL 26 COLON-ALIGNED
     antall AT ROW 22.19 COL 57 COLON-ALIGNED
     SYSTEMPRIS AT ROW 22.19 COL 80 COLON-ALIGNED
     "l/sek." VIEW-AS TEXT
          SIZE 7.8 BY .76 AT ROW 19.71 COL 44.8 WIDGET-ID 56
     tbNPSPSYST AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 141.6 BY 23.76 WIDGET-ID 100.


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
         HEIGHT             = 23.76
         WIDTH              = 141.6
         MAX-HEIGHT         = 23.76
         MAX-WIDTH          = 141.6
         VIRTUAL-HEIGHT     = 23.76
         VIRTUAL-WIDTH      = 141.6
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
/* BROWSE-TAB BrwNPSPSYST UtskriftSaksmappe_tbNPSPSYST DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 23.76
       FRAME DEFAULT-FRAME:WIDTH            = 141.6.

ASSIGN 
       tbNPSPSYST:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,edit;Edit,copy;Kopier,save;Lagre,undo;Angre,delete;Delete,refresh;Refresh,excel;Excel,UtskriftSaksmappe;Saksmappemaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPSYST
/* Query rebuild information for BROWSE BrwNPSPSYST
     _TblList          = "norcalc.NPSPSYST"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSPSYST.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSPSYST.systemnr" "Systemnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "8.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSPSYST.systembetegnelse" "Syst.bet." "X(40)" "character" ? ? ? ? ? ? no "" no no "40.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSPSYST.varenr" "Varenr" "9999999" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSPSYST.produktnavn" "Produktnavn" "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSPSYST.produkttype" "Produkttype" "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSPSYST.antall" "Antall" ">>9" "integer" ? ? ? ? ? ? no "" no no "5.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSPSYST.nrf_nr" "NRF" "9999999" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSPSYST.listepris" "Listepris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSPSYST.anbefalt_max_kap" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSPSYST.anb_max_innl_hast" "Anb. max innl. hast." "X(5)" "character" ? ? ? ? ? ? no "" no no "18.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSPSYST.anslutning" "Anslutning" "X(18)" "character" ? ? ? ? ? ? no "" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSPSYST.avstand_flotor" "Avstand flotør" ">>9" "integer" ? ? ? ? ? ? no "" no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSPSYST.beregnet_anvendelse" "Anvendelse" "X(18)" "character" ? ? ? ? ? ? no "Velg anvendelsesområde" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSPSYST.dimmensjon" "Dimm." "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSPSYST.faktor" "Faktor" "9.999" "decimal" ? ? ? ? ? ? no "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSPSYST.glykoltype" "Glyk.type" "X(20)" "character" ? ? ? ? ? ? no "Velg glykoltype" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPSPSYST.innl_hastighet" "Innl.hast." "9.99" "decimal" ? ? ? ? ? ? no "" no no "8.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPSPSYST.innmat" "Innmat" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPSPSYST.isolasjon" "Mantel/Isolasjon" "X(18)" "character" ? ? ? ? ? ? no "" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"NPSPSYST.konsentrasjon" "Kons." "X(8)" "character" ? ? ? ? ? ? no "Oppgi glykoltype konsentrasjon" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"NPSPSYST.kuleventil_ja_nei" "Kuleventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"NPSPSYST.kuleventil_verdi" "Kuleventil" "X(5)" "character" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"NPSPSYST.materialkvaliteter" "Materialkval." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"NPSPSYST.max_temp" "Max temp." ">>9" "integer" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"NPSPSYST.max_trykk" "Max trykk" ">>>9.9<" "decimal" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > "_<CALC>"
"NPSPSYST.medietemperatur" "Med. temp" "X(5)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > "_<CALC>"
"NPSPSYST.motflenser" "Motflenser" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"NPSPSYST.refill" "Refill" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > "_<CALC>"
"NPSPSYST.ror_dim" "Rørdim." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > "_<CALC>"
"NPSPSYST.spiroventkapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > "_<CALC>"
"NPSPSYST.trykkfall" "Trykkfall" ">,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > "_<CALC>"
"NPSPSYST.utv_gjengeventil" "Utv. gjenget lufteventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "21.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > "_<CALC>"
"NPSPSYST.vegg_tykkelse" "Veggtykkelse" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPSYST */
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


&Scoped-define SELF-NAME anslutning
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL anslutning C-Win
ON ENTRY OF anslutning IN FRAME DEFAULT-FRAME /* Anslutning */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME antall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL antall C-Win
ON ENTRY OF antall IN FRAME DEFAULT-FRAME /* Antall */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME beregnet_anvendelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL beregnet_anvendelse C-Win
ON ENTRY OF beregnet_anvendelse IN FRAME DEFAULT-FRAME /* Anv.omr. */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dimmensjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dimmensjon C-Win
ON ENTRY OF dimmensjon IN FRAME DEFAULT-FRAME /* Dimmensjon */
DO:
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME glykoltype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL glykoltype C-Win
ON ENTRY OF glykoltype IN FRAME DEFAULT-FRAME /* Glykoltype */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME innl_hastighet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL innl_hastighet C-Win
ON ENTRY OF innl_hastighet IN FRAME DEFAULT-FRAME /* Innl.hast. */
DO:
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME isolasjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL isolasjon C-Win
ON ENTRY OF isolasjon IN FRAME DEFAULT-FRAME /* Mantel/Isol. */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME konsentrasjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL konsentrasjon C-Win
ON ENTRY OF konsentrasjon IN FRAME DEFAULT-FRAME /* Konsentrasjon */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME kuleventil_ja_nei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL kuleventil_ja_nei C-Win
ON ENTRY OF kuleventil_ja_nei IN FRAME DEFAULT-FRAME /* Kuleventil */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME listepris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL listepris C-Win
ON ENTRY OF listepris IN FRAME DEFAULT-FRAME /* Listepris */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME materialkvaliteter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL materialkvaliteter C-Win
ON ENTRY OF materialkvaliteter IN FRAME DEFAULT-FRAME /* Materialkvaliteter */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME max_temp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL max_temp C-Win
ON ENTRY OF max_temp IN FRAME DEFAULT-FRAME /* Max temp. */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME max_trykk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL max_trykk C-Win
ON ENTRY OF max_trykk IN FRAME DEFAULT-FRAME /* Max trykk */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME medietemperatur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL medietemperatur C-Win
ON ENTRY OF medietemperatur IN FRAME DEFAULT-FRAME /* Medietemperatur */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME motflenser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL motflenser C-Win
ON ENTRY OF motflenser IN FRAME DEFAULT-FRAME /* Motflenser */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME produktnavn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL produktnavn C-Win
ON ENTRY OF produktnavn IN FRAME DEFAULT-FRAME /* Produktnavn */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME refill
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL refill C-Win
ON ENTRY OF refill IN FRAME DEFAULT-FRAME /* Refill */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME spiroventkapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL spiroventkapasitet C-Win
ON ENTRY OF spiroventkapasitet IN FRAME DEFAULT-FRAME /* Kapasitet */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME systembetegnelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL systembetegnelse C-Win
ON ENTRY OF systembetegnelse IN FRAME DEFAULT-FRAME /* Systembetegnelse */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SYSTEMPRIS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SYSTEMPRIS C-Win
ON ENTRY OF SYSTEMPRIS IN FRAME DEFAULT-FRAME /* Systempris */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME utv_gjengeventil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL utv_gjengeventil C-Win
ON ENTRY OF utv_gjengeventil IN FRAME DEFAULT-FRAME /* Utv. gjenget lufteventil */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSPSYST
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
  hParent = source-procedure.
  
  RUN disable_UI.
END.

{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPSPSYST:BROWSE-HANDLE}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddSystem C-Win 
PROCEDURE AddSystem :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  def input param piNPVareId as int no-undo.
  
  JBoxServerAPI:Instance:CallServerProc('crt_npspsystem.p',string(NPSPSYST.anleggsnr) + '|' + string(piNPVareId),?).  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CopyRecord C-Win 
PROCEDURE CopyRecord :
def buffer bSystem for NPSPSYST.
  def var iNesteSystemnr as int no-undo.
  
  DO WITH FRAME {&FRAME-NAME}:
    /* Dersom det er gitt tilbud på dette anlegget skal det ikke kunne legges inn nye system */
    FIND FIRST NPSPTILBUD WHERE NPSPTILBUD.anleggsnr = int(JBoxSession:Instance:getJBoxAttribute('SPAnleggsNr')) NO-ERROR.
    IF AVAILABLE NPSPTILBUD THEN DO:
      MESSAGE 'Det er gitt tilbud på dette anlegget. Nye system kan ikke registreres!'  VIEW-AS ALERT-BOX TITLE 'FEIL'.
      RETURN NO-APPLY.
    END.
    ELSE DO:
      SESSION:SET-WAIT-STATE("GENERAL").
      do transaction:
        for last bSystem no-lock where bSystem.anleggsnr = NPSPSYST.anleggsnr and bSystem.systemnr gt 0 by systemnr  : leave. end.
        iNesteSystemnr = if avail bSystem then bSystem.systemnr + 1 else 1.
        create bSystem.
        buffer-copy NPSPSYST except Systemnr to bSystem.
        assign bSystem.systemnr = iNesteSystemNr.
      end.  
/*      RUN kopiere_system_fra_temp.*/
       /* Åpne browser og reset row pointer */
      oBrwNPSPSYST:refresh().
/*         REPOSITION System-Browse TO ROWID(Current-Syst-Rec).*/
/*        APPLY 'VALUE-CHANGED' TO System-Browse*/
/*            IN FRAME System-FRAME.            */
      SESSION:SET-WAIT-STATE("").
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteRecord C-Win 
PROCEDURE DeleteRecord :
DO WITH FRAME {&FRAME-NAME}:
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
    if avail npspsyst then do: 
      Current-Rec = ROWID(NPSPSYST).
    /*  systemnrParam = NPSPSYST.systemnr.*/
      ASSIGN SYSTEMPRIS:screen-value = string(NPSPSYST.antall * NPSPSYST.listepris).
      produktnavn:screen-value = NPSPSYST.produktnavn.
    end.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
def var hChild as handle no-undo.
  
  DO WITH FRAME {&FRAME-NAME}:
    current-rec = to-rowid(NPSPSYST.RowIdent1).
    nyRecord    = false.

    run spsysred.w persistent set hChild.
    oBrwNPSPSYST:refresh().
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
  DISPLAY systemnr anleggsnr systembetegnelse produktnavn beregnet_anvendelse 
          anslutning isolasjon max_trykk materialkvaliteter max_temp 
          medietemperatur kuleventil_ja_nei utv_gjengeventil refill motflenser 
          glykoltype konsentrasjon spiroventkapasitet dimmensjon innl_hastighet 
          listepris antall SYSTEMPRIS 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSPSYST new_tbNPSPSYST edit_tbNPSPSYST copy_tbNPSPSYST 
         save_tbNPSPSYST undo_tbNPSPSYST delete_tbNPSPSYST refresh_tbNPSPSYST 
         excel_tbNPSPSYST UtskriftSaksmappe_tbNPSPSYST BrwNPSPSYST systemnr 
         anleggsnr systembetegnelse produktnavn beregnet_anvendelse anslutning 
         isolasjon max_trykk materialkvaliteter max_temp medietemperatur 
         kuleventil_ja_nei utv_gjengeventil refill motflenser glykoltype 
         konsentrasjon spiroventkapasitet dimmensjon innl_hastighet listepris 
         antall SYSTEMPRIS 
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
  Notes:      
vegg_tykkelse,varenr,,trykkfall,,,,ror_dim,,produkttype,,nrf_nr,,,,,,kuleventil_verdi,,,,innmat,,,faktor,,,avstand_flotor,,anslutning,anleggsnr,anb_max_innl_hast,anbefalt_max_kap    
------------------------------------------------------------------------------*/
THIS-PROCEDURE:CURRENT-WINDOW:X = JBoxSession:Instance:WindowX.
THIS-PROCEDURE:CURRENT-WINDOW:Y = JBoxSession:Instance:WindowY.

RUN enable_UI.

this-procedure:current-window:ALWAYS-ON-TOP = true.
oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

DO WITH FRAME {&FRAME-NAME}:
  
  oBrwNPSPSYST = NEW JBoxBrowse(brwNPSPSYST:HANDLE).
  dynamic-function('setAttribute',oBrwNPSPSYST:BROWSE-HANDLE,'ExcelColumnToText','anb_max_innl_hast').  
  otbNPSPSYST = NEW JBoxToolbar(tbNPSPSYST:HANDLE).
  oBrwNPSPSYST:setNoResizeY().
  
  oBrwNPSPSYST:TOOLBAR-OBJECT = otbNPSPSYST.
  oFmNPSPSYST = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSPSYST:updateFields = 'systembetegnelse,produktnavn,beregnet_anvendelse,anslutning,isolasjon,materialkvaliteter,max_trykk,max_temp,medietemperatur,kuleventil_ja_nei,utv_gjengeventil,refill,motflenser,glykoltype,konsentrasjon,spiroventkapasitet,dimmensjon,innl_hastighet,antall,listepris,systempris'.
  oFmNPSPSYST:DisplayFields = 'systemnr,anleggsnr'.
  oFmNPSPSYST:BROWSE-OBJECT = oBrwNPSPSYST.
  oFmNPSPSYST:TOOLBAR-OBJECT = otbNPSPSYST.
  
  assign 
    beregnet_anvendelse:DELIMITER = '|'
    beregnet_anvendelse:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DroppAnvendelse' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    anslutning:DELIMITER = '|'
    anslutning:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DroppAnslutning' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    materialkvaliteter:DELIMITER = '|'
    materialkvaliteter:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DroppMaterialkvalitet' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    glykoltype:DELIMITER = '|'
    glykoltype:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DroppGlykolType' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    isolasjon:DELIMITER = '|'
    isolasjon:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DroppIsolasjon' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    konsentrasjon:DELIMITER = '|'
    konsentrasjon:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DroppKonsentrasjon' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  def var hChild as handle no-undo.
  
  DO WITH FRAME {&FRAME-NAME}:
/*    def var hProc as handle no-undo.      */
/*    run wNPVareBrw.w persistent set hProc.*/
/*    if valid-handle(hProc) then           */
/*    do:                                   */
/*      run initializeObject in hProc.      */
/*      subscribe to 'AddSystem' in hProc.  */
/*      run MoveToTop in hProc.             */
/*                                          */
/*    end.                                  */
    nyRecord    = true.

    run spsysred.w persistent set hChild.
    oBrwNPSPSYST:refresh().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UtskriftSaksmappeRecord C-Win 
PROCEDURE UtskriftSaksmappeRecord :
DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DO: 
      MESSAGE 'Utskrift av  teknisk spesifikasjon til saksmappe?' VIEW-AS ALERT-BOX QUESTION 
          BUTTONS YES-NO TITLE 'Teknisk Spesifikasjon - Spirovent'  UPDATE svar.
      IF svar THEN do:
        SESSION:SET-WAIT-STATE("GENERAL").
      /* Skriv teknisk spesifikasjon */
        RUN aderb/_printrb.p
          ("report\norvent.prl",
         "Tekn. spes. saksmappe",
         JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),
          "O", 
         "NPSPANLG.anleggsnr = " + string(NPSPSYST.anleggsnr),
          "",
          "",
          session:first-procedure:private-data,
          "",
          "",
          1,
          1,
          9999,
          no,
          "Teknisk spesifikasjon til saksmappe-Spirovent",
          yes,
          yes,
          no,
          "").        
        SESSION:SET-WAIT-STATE("").
      end.
    END.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRec C-Win 
FUNCTION getCurrentRec RETURNS ROWID
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    RETURN current-rec.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNyRecord C-Win 
FUNCTION getNyRecord RETURNS LOGICAL
  ():
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    return nyRecord.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentRec C-Win 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    current-rec = ipRowid.
    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentHandle C-Win 
FUNCTION setParentHandle RETURNS LOGICAL
  ( INPUT ipHandle AS handle ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  hParent = ipHandle.
  iAnleggsNr   = int(JBoxSession:Instance:getJBoxAttribute('SPAnleggsNr')).
  THIS-PROCEDURE:CURRENT-WINDOW:Title = hParent:current-window:title + ' anleggsnr: ' + string(iAnleggsNr).
  oBrwNPSPSYST:baseQuery = 'where anleggsnr = ' + string(iAnleggsNr).
  oBrwNPSPSYST:OpenQuery().
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

