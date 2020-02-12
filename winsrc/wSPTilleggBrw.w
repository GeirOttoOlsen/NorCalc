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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSPVARELISTE ***/
DEF VAR oBrwNPSPVARELISTE AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPVARELISTE
    FIELD anslutning AS character
    FIELD avstand_flotor AS integer
    FIELD avt_plugg AS character
    FIELD bredde AS integer
    FIELD df_diameter AS integer
    FIELD diameter AS decimal
    FIELD dimmensjon AS character
    FIELD dybde AS integer
    FIELD fast_tekst AS character
    FIELD H AS integer
    FIELD H1 AS integer
    FIELD H2 AS integer
    FIELD hoyde AS integer
    FIELD hurtigventil AS logical
    FIELD h_0 AS integer
    FIELD h_1 AS integer
    FIELD h_2 AS integer
    FIELD innmat AS character
    FIELD iNPVaregruppeId AS integer
    FIELD kapasitet AS decimal
    FIELD kuleventil AS character
    FIELD kv_verdi AS decimal
    FIELD L AS integer
    FIELD LF AS integer
    FIELD l_lufteventil AS integer
    FIELD materialkvaliteter AS character
    FIELD max_temp AS integer
    FIELD max_trykk AS decimal
    FIELD nrf_nr AS integer
    FIELD pris AS decimal
    FIELD produktnavn AS character
    FIELD ror_dim AS decimal
    FIELD service_plass_over AS integer
    FIELD service_plass_under AS integer
    FIELD tegnings_ref AS character
    FIELD utv_volum AS decimal
    FIELD varenr AS integer
    FIELD vegg_tykkelse AS decimal
    FIELD vekt AS decimal
    FIELD volum AS decimal
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSPVARELISTE FOR TEMP-TABLE NPSPVARELISTE.


FUNCTION getBuffersAndFieldsBrwNPSPVARELISTE RETURNS CHARACTER():
  RETURN
    'NPSPVARELISTE'
     + ';anslutning'
     + ';avstand_flotor'
     + ';avt_plugg'
     + ';bredde'
     + ';df_diameter'
     + ';diameter'
     + ';dimmensjon'
     + ';dybde'
     + ';fast_tekst'
     + ';H'
     + ';H1'
     + ';H2'
     + ';hoyde'
     + ';hurtigventil'
     + ';h_0'
     + ';h_1'
     + ';h_2'
     + ';innmat'
     + ';iNPVaregruppeId'
     + ';kapasitet'
     + ';kuleventil'
     + ';kv_verdi'
     + ';L'
     + ';LF'
     + ';l_lufteventil'
     + ';materialkvaliteter'
     + ';max_temp'
     + ';max_trykk'
     + ';nrf_nr'
     + ';pris'
     + ';produktnavn'
     + ';ror_dim'
     + ';service_plass_over'
     + ';service_plass_under'
     + ';tegnings_ref'
     + ';utv_volum'
     + ';varenr'
     + ';vegg_tykkelse'
     + ';vekt'
     + ';volum'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPVARELISTE RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbNPSPTILBUD AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSPVARELISTE

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPVARELISTE

/* Definitions for BROWSE BrwNPSPVARELISTE                              */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPVARELISTE NPSPVARELISTE.anslutning ~
NPSPVARELISTE.avstand_flotor NPSPVARELISTE.avt_plugg NPSPVARELISTE.bredde ~
NPSPVARELISTE.df_diameter NPSPVARELISTE.diameter NPSPVARELISTE.dimmensjon ~
NPSPVARELISTE.dybde NPSPVARELISTE.fast_tekst NPSPVARELISTE.H ~
NPSPVARELISTE.H1 NPSPVARELISTE.H2 NPSPVARELISTE.hoyde ~
NPSPVARELISTE.hurtigventil NPSPVARELISTE.h_0 NPSPVARELISTE.h_1 ~
NPSPVARELISTE.h_2 NPSPVARELISTE.innmat NPSPVARELISTE.iNPVaregruppeId ~
NPSPVARELISTE.kapasitet NPSPVARELISTE.kuleventil NPSPVARELISTE.kv_verdi ~
NPSPVARELISTE.L NPSPVARELISTE.LF NPSPVARELISTE.l_lufteventil ~
NPSPVARELISTE.materialkvaliteter NPSPVARELISTE.max_temp ~
NPSPVARELISTE.max_trykk NPSPVARELISTE.nrf_nr NPSPVARELISTE.pris ~
NPSPVARELISTE.produktnavn NPSPVARELISTE.ror_dim ~
NPSPVARELISTE.service_plass_over NPSPVARELISTE.service_plass_under ~
NPSPVARELISTE.tegnings_ref NPSPVARELISTE.utv_volum NPSPVARELISTE.varenr ~
NPSPVARELISTE.vegg_tykkelse NPSPVARELISTE.vekt NPSPVARELISTE.volum 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPVARELISTE ~
NPSPVARELISTE.anslutning 
&Scoped-define QUERY-STRING-BrwNPSPVARELISTE FOR EACH NPSPVARELISTE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPVARELISTE OPEN QUERY BrwNPSPVARELISTE FOR EACH NPSPVARELISTE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPVARELISTE NPSPVARELISTE
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPVARELISTE NPSPVARELISTE


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPTILBUD refresh_tbNPSPTILBUD ~
excel_tbNPSPTILBUD BrwNPSPVARELISTE 

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
     SIZE 106.2 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPVARELISTE FOR 
      NPSPVARELISTE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPVARELISTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPVARELISTE C-Win _STRUCTURED
  QUERY BrwNPSPVARELISTE NO-LOCK DISPLAY
      NPSPVARELISTE.anslutning COLUMN-LABEL "Anslutning" FORMAT "X(14)":U
      NPSPVARELISTE.avstand_flotor COLUMN-LABEL "Avstand flotør" FORMAT ">>9":U
      NPSPVARELISTE.avt_plugg COLUMN-LABEL "Avt.plugg" FORMAT "X(8)":U
      NPSPVARELISTE.bredde COLUMN-LABEL "Bredde" FORMAT ">>>9":U
      NPSPVARELISTE.df_diameter COLUMN-LABEL "DFØ" FORMAT ">>>9":U
      NPSPVARELISTE.diameter COLUMN-LABEL "DØ" FORMAT ">>9.9":U
      NPSPVARELISTE.dimmensjon COLUMN-LABEL "Dimm." FORMAT "X(45)":U
      NPSPVARELISTE.dybde COLUMN-LABEL "Dybde" FORMAT ">>>9":U
      NPSPVARELISTE.fast_tekst COLUMN-LABEL "Fast Tekst" FORMAT "A(255)":U
      NPSPVARELISTE.H COLUMN-LABEL "H" FORMAT ">>>9":U
      NPSPVARELISTE.H1 COLUMN-LABEL "H1" FORMAT ">>>9":U
      NPSPVARELISTE.H2 COLUMN-LABEL "H2" FORMAT ">>>9":U
      NPSPVARELISTE.hoyde COLUMN-LABEL "Høyde" FORMAT ">>>9":U
      NPSPVARELISTE.hurtigventil COLUMN-LABEL "Hurtigventil" FORMAT "ja/nei":U
      NPSPVARELISTE.h_0 COLUMN-LABEL "h" FORMAT ">>>9":U
      NPSPVARELISTE.h_1 COLUMN-LABEL "h1" FORMAT ">>>9":U
      NPSPVARELISTE.h_2 COLUMN-LABEL "h2" FORMAT ">>>9":U
      NPSPVARELISTE.innmat COLUMN-LABEL "Innmat" FORMAT "X(25)":U
      NPSPVARELISTE.iNPVaregruppeId COLUMN-LABEL "VaregruppeId" FORMAT ">>>>>>9":U
      NPSPVARELISTE.kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSPVARELISTE.kuleventil COLUMN-LABEL "Kuleventil" FORMAT "X(5)":U
      NPSPVARELISTE.kv_verdi COLUMN-LABEL "KV-verdi" FORMAT ">,>>9.99":U
      NPSPVARELISTE.L COLUMN-LABEL "L" FORMAT ">>9":U
      NPSPVARELISTE.LF COLUMN-LABEL "LF" FORMAT ">>>9":U
      NPSPVARELISTE.l_lufteventil COLUMN-LABEL "L lufteventil" FORMAT ">9":U
      NPSPVARELISTE.materialkvaliteter COLUMN-LABEL "Materialkval." FORMAT "X(25)":U
      NPSPVARELISTE.max_temp COLUMN-LABEL "Max temp." FORMAT ">>9":U
      NPSPVARELISTE.max_trykk COLUMN-LABEL "Max trykk" FORMAT ">>9.9<":U
      NPSPVARELISTE.nrf_nr COLUMN-LABEL "NRF" FORMAT "9999999":U
      NPSPVARELISTE.pris COLUMN-LABEL "Pris" FORMAT ">>>,>>9.99":U
      NPSPVARELISTE.produktnavn COLUMN-LABEL "Produktnavn" FORMAT "X(45)":U
      NPSPVARELISTE.ror_dim COLUMN-LABEL "Rørdim." FORMAT ">>9.99":U
      NPSPVARELISTE.service_plass_over COLUMN-LABEL "Serv.sp.over" FORMAT ">>>9":U
      NPSPVARELISTE.service_plass_under COLUMN-LABEL "Serv.sp.under" FORMAT ">>>9":U
      NPSPVARELISTE.tegnings_ref COLUMN-LABEL "Tegning" FORMAT "X(60)":U
      NPSPVARELISTE.utv_volum COLUMN-LABEL "Utv. volum" FORMAT ">>9.99":U
      NPSPVARELISTE.varenr COLUMN-LABEL "Varenr" FORMAT "9999999":U
      NPSPVARELISTE.vegg_tykkelse COLUMN-LABEL "Veggtykkelse" FORMAT ">9.99":U
      NPSPVARELISTE.vekt COLUMN-LABEL "Vekt" FORMAT ">,>>9.99":U
      NPSPVARELISTE.volum COLUMN-LABEL "Volum" FORMAT ">>>9.99":U
  ENABLE
      NPSPVARELISTE.anslutning
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 106.2 BY 11.91 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSPTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 4
     excel_tbNPSPTILBUD AT ROW 1.1 COL 9 WIDGET-ID 6
     BrwNPSPVARELISTE AT ROW 3.14 COL 2 WIDGET-ID 200
     tbNPSPTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 107.2 BY 14.33 WIDGET-ID 100.


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
         HEIGHT             = 14.33
         WIDTH              = 107.2
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
/* BROWSE-TAB BrwNPSPVARELISTE excel_tbNPSPTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 14.33
       FRAME DEFAULT-FRAME:WIDTH            = 107.2.

ASSIGN 
       tbNPSPTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPVARELISTE
/* Query rebuild information for BROWSE BrwNPSPVARELISTE
     _TblList          = "norcalc.NPSPVARELISTE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSPVARELISTE.anslutning" "Anslutning" "X(14)" "character" ? ? ? ? ? ? yes "" no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSPVARELISTE.avstand_flotor" "Avstand flotør" ">>9" "integer" ? ? ? ? ? ? no "" no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSPVARELISTE.avt_plugg" "Avt.plugg" "X(8)" "character" ? ? ? ? ? ? no "" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSPVARELISTE.bredde" "Bredde" ">>>9" "integer" ? ? ? ? ? ? no "" no no "6.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSPVARELISTE.df_diameter" "DFØ" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSPVARELISTE.diameter" "DØ" ">>9.9" "decimal" ? ? ? ? ? ? no "" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSPVARELISTE.dimmensjon" "Dimm." "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSPVARELISTE.dybde" "Dybde" ">>>9" "integer" ? ? ? ? ? ? no "" no no "6.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSPVARELISTE.fast_tekst" "Fast Tekst" "A(255)" "character" ? ? ? ? ? ? no "" no no "255" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSPVARELISTE.H" "H" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSPVARELISTE.H1" "H1" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSPVARELISTE.H2" "H2" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSPVARELISTE.hoyde" "Høyde" ">>>9" "integer" ? ? ? ? ? ? no "" no no "6.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSPVARELISTE.hurtigventil" "Hurtigventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSPVARELISTE.h_0" "h" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSPVARELISTE.h_1" "h1" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSPVARELISTE.h_2" "h2" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPSPVARELISTE.innmat" "Innmat" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPSPVARELISTE.iNPVaregruppeId" "VaregruppeId" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPSPVARELISTE.kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"NPSPVARELISTE.kuleventil" "Kuleventil" "X(5)" "character" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"NPSPVARELISTE.kv_verdi" "KV-verdi" ">,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"NPSPVARELISTE.L" "L" ">>9" "integer" ? ? ? ? ? ? no "" no no "3.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"NPSPVARELISTE.LF" "LF" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"NPSPVARELISTE.l_lufteventil" "L lufteventil" ">9" "integer" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"NPSPVARELISTE.materialkvaliteter" "Materialkval." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > "_<CALC>"
"NPSPVARELISTE.max_temp" "Max temp." ">>9" "integer" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > "_<CALC>"
"NPSPVARELISTE.max_trykk" "Max trykk" ">>9.9<" "decimal" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"NPSPVARELISTE.nrf_nr" "NRF" "9999999" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > "_<CALC>"
"NPSPVARELISTE.pris" "Pris" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > "_<CALC>"
"NPSPVARELISTE.produktnavn" "Produktnavn" "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > "_<CALC>"
"NPSPVARELISTE.ror_dim" "Rørdim." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > "_<CALC>"
"NPSPVARELISTE.service_plass_over" "Serv.sp.over" ">>>9" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > "_<CALC>"
"NPSPVARELISTE.service_plass_under" "Serv.sp.under" ">>>9" "integer" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > "_<CALC>"
"NPSPVARELISTE.tegnings_ref" "Tegning" "X(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > "_<CALC>"
"NPSPVARELISTE.utv_volum" "Utv. volum" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > "_<CALC>"
"NPSPVARELISTE.varenr" "Varenr" "9999999" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > "_<CALC>"
"NPSPVARELISTE.vegg_tykkelse" "Veggtykkelse" ">9.99" "decimal" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > "_<CALC>"
"NPSPVARELISTE.vekt" "Vekt" ">,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > "_<CALC>"
"NPSPVARELISTE.volum" "Volum" ">>>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPVARELISTE */
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


&Scoped-define BROWSE-NAME BrwNPSPVARELISTE
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
{incl/conttrigg.i oBrwNPSPVARELISTE:BROWSE-HANDLE}

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
  ENABLE tbNPSPTILBUD refresh_tbNPSPTILBUD excel_tbNPSPTILBUD BrwNPSPVARELISTE 
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

  oBrwNPSPVARELISTE = NEW JBoxBrowse(brwNPSPVARELISTE:HANDLE).

  otbNPSPTILBUD = NEW JBoxToolbar(tbNPSPTILBUD:HANDLE).

  oBrwNPSPVARELISTE:TOOLBAR-OBJECT = otbNPSPTILBUD.
END.
oBrwNPSPVARELISTE:OpenQuery().


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

