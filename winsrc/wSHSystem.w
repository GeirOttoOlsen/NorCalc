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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHSYST ***/
DEF VAR oBrwNPSHSYST AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHSYST
    FIELD anleggsnr AS integer
    FIELD systemnr AS integer
    FIELD systembetegnelse AS character
    FIELD system_kode AS character
    FIELD koblings_alternativ AS character
    FIELD standardpris AS decimal
    FIELD med_i_ordre AS logical
    FIELD prim_hastighet AS decimal
    FIELD sek_hastighet AS decimal
    FIELD autoritet AS decimal
    FIELD beregnet_anvendelse AS character
    FIELD fabrikat AS character
    FIELD forhaands_struping AS decimal
    FIELD forhaands_struping_prim AS decimal
    FIELD forhaands_struping_sek AS decimal
    FIELD glykol AS character
    FIELD inngaende_trykk AS decimal
    FIELD konsentrasjon AS character
    FIELD kvs_hovedport AS decimal
    FIELD kvs_shuntport AS decimal
    FIELD ledig_drivtrykk_prim AS decimal
    FIELD maks_pumpetrykk AS decimal
    FIELD minste_pumpetrykk AS decimal
    FIELD minste_pumpetrykk_prim AS decimal
    FIELD ms_automatikk_fabrikat AS character
    FIELD ms_shuntventil_i_leveranse AS logical
    FIELD ms_ventiltype AS character
    FIELD prim_effekt AS integer
    FIELD prim_kapasitet AS decimal
    FIELD prim_temp_inn AS decimal
    FIELD prim_temp_ut AS decimal
    FIELD prod_nr AS character
    FIELD sek_effekt AS integer
    FIELD sek_kapasitet AS decimal
    FIELD sek_temp_inn AS decimal
    FIELD sek_temp_ut AS decimal
    FIELD shunthus_varenr AS character
    FIELD shuntkvs_varenr AS character
    FIELD shunt_dimmensjon AS character
    FIELD shunt_dimmensjon_num AS integer
    FIELD sikkerhet AS decimal
    FIELD strupe_dimmensjon_prim AS character
    FIELD strupe_dimmensjon_sek AS character
    FIELD tegning_bmp AS character
    FIELD trykk_for_shunt_ventil AS decimal
    FIELD type AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHSYST FOR TEMP-TABLE NPSHSYST.


FUNCTION getBuffersAndFieldsBrwNPSHSYST RETURNS CHARACTER():
  RETURN
    'NPSHSYST'
     + ';anleggsnr'
     + ';systemnr'
     + ';systembetegnelse'
     + ';system_kode'
     + ';koblings_alternativ'
     + ';standardpris'
     + ';med_i_ordre'
     + ';prim_hastighet'
     + ';sek_hastighet'
     + ';autoritet'
     + ';beregnet_anvendelse'
     + ';fabrikat'
     + ';forhaands_struping'
     + ';forhaands_struping_prim'
     + ';forhaands_struping_sek'
     + ';glykol'
     + ';inngaende_trykk'
     + ';konsentrasjon'
     + ';kvs_hovedport'
     + ';kvs_shuntport'
     + ';ledig_drivtrykk_prim'
     + ';maks_pumpetrykk'
     + ';minste_pumpetrykk'
     + ';minste_pumpetrykk_prim'
     + ';ms_automatikk_fabrikat'
     + ';ms_shuntventil_i_leveranse'
     + ';ms_ventiltype'
     + ';prim_effekt'
     + ';prim_kapasitet'
     + ';prim_temp_inn'
     + ';prim_temp_ut'
     + ';prod_nr'
     + ';sek_effekt'
     + ';sek_kapasitet'
     + ';sek_temp_inn'
     + ';sek_temp_ut'
     + ';shunthus_varenr'
     + ';shuntkvs_varenr'
     + ';shunt_dimmensjon'
     + ';shunt_dimmensjon_num'
     + ';sikkerhet'
     + ';strupe_dimmensjon_prim'
     + ';strupe_dimmensjon_sek'
     + ';tegning_bmp'
     + ';trykk_for_shunt_ventil'
     + ';type'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHSYST RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbNPSHSYST AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHSYST

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHSYST

/* Definitions for BROWSE BrwNPSHSYST                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHSYST NPSHSYST.anleggsnr ~
NPSHSYST.systemnr NPSHSYST.systembetegnelse NPSHSYST.system_kode ~
NPSHSYST.koblings_alternativ NPSHSYST.standardpris NPSHSYST.med_i_ordre ~
NPSHSYST.prim_hastighet NPSHSYST.sek_hastighet NPSHSYST.autoritet ~
NPSHSYST.beregnet_anvendelse NPSHSYST.fabrikat NPSHSYST.forhaands_struping ~
NPSHSYST.forhaands_struping_prim NPSHSYST.forhaands_struping_sek ~
NPSHSYST.glykol NPSHSYST.inngaende_trykk NPSHSYST.konsentrasjon ~
NPSHSYST.kvs_hovedport NPSHSYST.kvs_shuntport NPSHSYST.ledig_drivtrykk_prim ~
NPSHSYST.maks_pumpetrykk NPSHSYST.minste_pumpetrykk ~
NPSHSYST.minste_pumpetrykk_prim NPSHSYST.ms_automatikk_fabrikat ~
NPSHSYST.ms_shuntventil_i_leveranse NPSHSYST.ms_ventiltype ~
NPSHSYST.prim_effekt NPSHSYST.prim_kapasitet NPSHSYST.prim_temp_inn ~
NPSHSYST.prim_temp_ut NPSHSYST.prod_nr NPSHSYST.sek_effekt ~
NPSHSYST.sek_kapasitet NPSHSYST.sek_temp_inn NPSHSYST.sek_temp_ut ~
NPSHSYST.shunthus_varenr NPSHSYST.shuntkvs_varenr NPSHSYST.shunt_dimmensjon ~
NPSHSYST.shunt_dimmensjon_num NPSHSYST.sikkerhet ~
NPSHSYST.strupe_dimmensjon_prim NPSHSYST.strupe_dimmensjon_sek ~
NPSHSYST.tegning_bmp NPSHSYST.trykk_for_shunt_ventil NPSHSYST.type 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHSYST NPSHSYST.anleggsnr ~
NPSHSYST.systemnr 
&Scoped-define QUERY-STRING-BrwNPSHSYST FOR EACH NPSHSYST NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHSYST OPEN QUERY BrwNPSHSYST FOR EACH NPSHSYST NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHSYST NPSHSYST
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHSYST NPSHSYST


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHSYST new_tbNPSHSYST edit_tbNPSHSYST ~
refresh_tbNPSHSYST excel_tbNPSHSYST BrwNPSHSYST 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON edit_tbNPSHSYST 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 7.8 BY 1.95 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbNPSHSYST 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON new_tbNPSHSYST 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 7.8 BY 1.95 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHSYST 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSHSYST
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 148 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHSYST FOR 
      NPSHSYST SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHSYST
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHSYST C-Win _STRUCTURED
  QUERY BrwNPSHSYST NO-LOCK DISPLAY
      NPSHSYST.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHSYST.systemnr COLUMN-LABEL "Systemnr" FORMAT ">>>>>9":U
      NPSHSYST.systembetegnelse COLUMN-LABEL "Syst.bet." FORMAT "X(30)":U
            WIDTH 20
      NPSHSYST.system_kode COLUMN-LABEL "Kode" FORMAT "X(60)":U
      NPSHSYST.koblings_alternativ COLUMN-LABEL "Kobl.alt." FORMAT "X(2)":U
      NPSHSYST.standardpris COLUMN-LABEL "Standardpris" FORMAT ">>,>>>,>>9.99":U
      NPSHSYST.med_i_ordre COLUMN-LABEL "Ordre" FORMAT "ja/nei":U
      NPSHSYST.prim_hastighet COLUMN-LABEL "prim_hastighet" FORMAT ">>9.999999":U
      NPSHSYST.sek_hastighet COLUMN-LABEL "sek_hastighet" FORMAT ">>9.999999":U
      NPSHSYST.autoritet COLUMN-LABEL "Autoritet" FORMAT ">.9999":U
      NPSHSYST.beregnet_anvendelse COLUMN-LABEL "Anvendelse" FORMAT "X(18)":U
      NPSHSYST.fabrikat COLUMN-LABEL "fabrikat" FORMAT "X(2)":U
      NPSHSYST.forhaands_struping COLUMN-LABEL "Struping" FORMAT ">>9.99":U
      NPSHSYST.forhaands_struping_prim COLUMN-LABEL "Struping" FORMAT ">>9.99":U
      NPSHSYST.forhaands_struping_sek COLUMN-LABEL "Struping" FORMAT ">>9.99":U
      NPSHSYST.glykol COLUMN-LABEL "Glykol" FORMAT "X(10)":U
      NPSHSYST.inngaende_trykk COLUMN-LABEL "Inng. trykk" FORMAT ">>9.99":U
      NPSHSYST.konsentrasjon COLUMN-LABEL "Kons." FORMAT "X(2)":U
      NPSHSYST.kvs_hovedport COLUMN-LABEL "KVS Hovedport" FORMAT ">>9.99":U
      NPSHSYST.kvs_shuntport COLUMN-LABEL "KVS Shuntport" FORMAT ">>9.99":U
      NPSHSYST.ledig_drivtrykk_prim COLUMN-LABEL "Ledig drivtrykk" FORMAT ">>9.99":U
      NPSHSYST.maks_pumpetrykk COLUMN-LABEL "Maks trykk" FORMAT ">>9.99":U
      NPSHSYST.minste_pumpetrykk COLUMN-LABEL "Min. pump." FORMAT ">>9.99":U
      NPSHSYST.minste_pumpetrykk_prim COLUMN-LABEL "Min. pump." FORMAT ">>9.99":U
      NPSHSYST.ms_automatikk_fabrikat COLUMN-LABEL "Aut.fabr." FORMAT "X(3)":U
      NPSHSYST.ms_shuntventil_i_leveranse COLUMN-LABEL "Shuntventil med" FORMAT "ja/nei":U
      NPSHSYST.ms_ventiltype COLUMN-LABEL "Ventiltype" FORMAT "X(20)":U
      NPSHSYST.prim_effekt COLUMN-LABEL "Effekt" FORMAT ">>>>>>9":U
      NPSHSYST.prim_kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSHSYST.prim_temp_inn COLUMN-LABEL "Temp. inn" FORMAT "->>9.99":U
      NPSHSYST.prim_temp_ut COLUMN-LABEL "Temp. ut" FORMAT "->>9.99":U
      NPSHSYST.prod_nr COLUMN-LABEL "Prod.nr." FORMAT "X(18)":U
      NPSHSYST.sek_effekt COLUMN-LABEL "Effekt" FORMAT ">>>>>>9":U
      NPSHSYST.sek_kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSHSYST.sek_temp_inn COLUMN-LABEL "Temp. inn" FORMAT "->>9.99":U
      NPSHSYST.sek_temp_ut COLUMN-LABEL "Temp. ut" FORMAT "->>9.99":U
      NPSHSYST.shunthus_varenr COLUMN-LABEL "Vnr.shunthus" FORMAT "X(8)":U
      NPSHSYST.shuntkvs_varenr COLUMN-LABEL "Vnr.shuntkvs" FORMAT "X(8)":U
      NPSHSYST.shunt_dimmensjon COLUMN-LABEL "Shunt-dimm." FORMAT "X(3)":U
      NPSHSYST.shunt_dimmensjon_num COLUMN-LABEL "shunt_dimmensjon_num" FORMAT ">99":U
      NPSHSYST.sikkerhet COLUMN-LABEL "Sikkerhet" FORMAT ">>9.99":U
      NPSHSYST.strupe_dimmensjon_prim COLUMN-LABEL "strupe_dimmensjon_prim" FORMAT "X(8)":U
      NPSHSYST.strupe_dimmensjon_sek COLUMN-LABEL "strupe_dimmensjon_sek" FORMAT "X(8)":U
      NPSHSYST.tegning_bmp COLUMN-LABEL "tegning_bmp" FORMAT "X(30)":U
      NPSHSYST.trykk_for_shunt_ventil COLUMN-LABEL "Trykk før shuntventil" FORMAT ">>9.99":U
      NPSHSYST.type COLUMN-LABEL "Type" FORMAT "X(2)":U
  ENABLE
      NPSHSYST.anleggsnr
      NPSHSYST.systemnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 149 BY 15.67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHSYST AT ROW 1.1 COL 1.2 WIDGET-ID 12
     edit_tbNPSHSYST AT ROW 1.1 COL 9.2 WIDGET-ID 14
     refresh_tbNPSHSYST AT ROW 1.1 COL 17 WIDGET-ID 4
     excel_tbNPSHSYST AT ROW 1.1 COL 24.8 WIDGET-ID 10
     BrwNPSHSYST AT ROW 3.14 COL 1 WIDGET-ID 200
     tbNPSHSYST AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 149 BY 17.81 WIDGET-ID 100.


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
         HEIGHT             = 17.81
         WIDTH              = 149
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 149
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 149
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
/* BROWSE-TAB BrwNPSHSYST excel_tbNPSHSYST DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 17.81
       FRAME DEFAULT-FRAME:WIDTH            = 149.

ASSIGN 
       NPSHSYST.anleggsnr:VISIBLE IN BROWSE BrwNPSHSYST = FALSE.

ASSIGN 
       tbNPSHSYST:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,refresh;Refresh,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHSYST
/* Query rebuild information for BROWSE BrwNPSHSYST
     _TblList          = "norcalc.NPSHSYST"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHSYST.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.4" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHSYST.systemnr" "Systemnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "8.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHSYST.systembetegnelse" "Syst.bet." "X(30)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHSYST.system_kode" "Kode" "X(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHSYST.koblings_alternativ" "Kobl.alt." "X(2)" "character" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHSYST.standardpris" "Standardpris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHSYST.med_i_ordre" "Ordre" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHSYST.prim_hastighet" "prim_hastighet" ">>9.999999" "decimal" ? ? ? ? ? ? no "" no no "13.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSHSYST.sek_hastighet" "sek_hastighet" ">>9.999999" "decimal" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSHSYST.autoritet" "Autoritet" ">.9999" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSHSYST.beregnet_anvendelse" "Anvendelse" "X(18)" "character" ? ? ? ? ? ? no "Velg anvendelsesområde" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSHSYST.fabrikat" "fabrikat" "X(2)" "character" ? ? ? ? ? ? no "" no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSHSYST.forhaands_struping" "Struping" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSHSYST.forhaands_struping_prim" "Struping" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSHSYST.forhaands_struping_sek" "Struping" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSHSYST.glykol" "Glykol" "X(10)" "character" ? ? ? ? ? ? no "Velg glykoltype" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSHSYST.inngaende_trykk" "Inng. trykk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPSHSYST.konsentrasjon" "Kons." "X(2)" "character" ? ? ? ? ? ? no "Oppgi glykol konsentrasjon" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPSHSYST.kvs_hovedport" "KVS Hovedport" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "14.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPSHSYST.kvs_shuntport" "KVS Shuntport" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"NPSHSYST.ledig_drivtrykk_prim" "Ledig drivtrykk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"NPSHSYST.maks_pumpetrykk" "Maks trykk" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"NPSHSYST.minste_pumpetrykk" "Min. pump." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"NPSHSYST.minste_pumpetrykk_prim" "Min. pump." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"NPSHSYST.ms_automatikk_fabrikat" "Aut.fabr." "X(3)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > "_<CALC>"
"NPSHSYST.ms_shuntventil_i_leveranse" "Shuntventil med" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "15.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > "_<CALC>"
"NPSHSYST.ms_ventiltype" "Ventiltype" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > "_<CALC>"
"NPSHSYST.prim_effekt" "Effekt" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > "_<CALC>"
"NPSHSYST.prim_kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > "_<CALC>"
"NPSHSYST.prim_temp_inn" "Temp. inn" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > "_<CALC>"
"NPSHSYST.prim_temp_ut" "Temp. ut" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > "_<CALC>"
"NPSHSYST.prod_nr" "Prod.nr." "X(18)" "character" ? ? ? ? ? ? no "" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > "_<CALC>"
"NPSHSYST.sek_effekt" "Effekt" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > "_<CALC>"
"NPSHSYST.sek_kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > "_<CALC>"
"NPSHSYST.sek_temp_inn" "Temp. inn" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > "_<CALC>"
"NPSHSYST.sek_temp_ut" "Temp. ut" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > "_<CALC>"
"NPSHSYST.shunthus_varenr" "Vnr.shunthus" "X(8)" "character" ? ? ? ? ? ? no "" no no "12.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > "_<CALC>"
"NPSHSYST.shuntkvs_varenr" "Vnr.shuntkvs" "X(8)" "character" ? ? ? ? ? ? no "" no no "12.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > "_<CALC>"
"NPSHSYST.shunt_dimmensjon" "Shunt-dimm." "X(3)" "character" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > "_<CALC>"
"NPSHSYST.shunt_dimmensjon_num" "shunt_dimmensjon_num" ">99" "integer" ? ? ? ? ? ? no "" no no "22.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[41]   > "_<CALC>"
"NPSHSYST.sikkerhet" "Sikkerhet" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[42]   > "_<CALC>"
"NPSHSYST.strupe_dimmensjon_prim" "strupe_dimmensjon_prim" "X(8)" "character" ? ? ? ? ? ? no "" no no "23" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[43]   > "_<CALC>"
"NPSHSYST.strupe_dimmensjon_sek" "strupe_dimmensjon_sek" "X(8)" "character" ? ? ? ? ? ? no "" no no "22.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[44]   > "_<CALC>"
"NPSHSYST.tegning_bmp" "tegning_bmp" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[45]   > "_<CALC>"
"NPSHSYST.trykk_for_shunt_ventil" "Trykk før shuntventil" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "19.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[46]   > "_<CALC>"
"NPSHSYST.type" "Type" "X(2)" "character" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHSYST */
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


&Scoped-define BROWSE-NAME BrwNPSHSYST
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
{incl/conttrigg.i oBrwNPSHSYST:BROWSE-HANDLE}

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
  ENABLE tbNPSHSYST new_tbNPSHSYST edit_tbNPSHSYST refresh_tbNPSHSYST 
         excel_tbNPSHSYST BrwNPSHSYST 
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

  oBrwNPSHSYST = NEW JBoxBrowse(brwNPSHSYST:HANDLE).
  dynamic-function('setAttribute',oBrwNPSHSYST:BROWSE-HANDLE,'ExcelColumToText','trykk_for_shunt_ventil').
  otbNPSHSYST = NEW JBoxToolbar(tbNPSHSYST:HANDLE).

  oBrwNPSHSYST:TOOLBAR-OBJECT = otbNPSHSYST.
END.
oBrwNPSHSYST:OpenQuery().


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
  def var hChild as handle no-undo.
  hChild = JBoxMainMenu:Instance:StartChildWindow("shendsys.w",'Nytt system',yes).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

