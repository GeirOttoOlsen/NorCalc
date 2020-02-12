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


/*** Start instance property definitions for JBoxBrowse object oBrwNPVare ***/
DEF VAR oBrwNPVare AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPVare
    FIELD iNPVareId AS integer
    FIELD Varenr AS integer
    FIELD NRFnr AS integer
    FIELD VaregruppeNavn AS character
    FIELD Varenavn AS character
    FIELD VareTypeNavn AS character
    FIELD VareDimmensjon AS decimal
    FIELD VareEnhetspris AS decimal
    FIELD VareKapasitet AS decimal
    FIELD VareKVverdi AS decimal
    FIELD VareMaxtemperatur AS integer
    FIELD VareMaxtrykk AS integer
    FIELD VarePipeDimm AS decimal
    FIELD VareVannkapasitet AS decimal
    FIELD VareVeggtykkelse AS decimal
    FIELD iNPVaregruppeId AS integer
    FIELD iNPVareTypeId AS integer
    FIELD Varebeskrivelse AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEF BUFFER v_NPVare FOR TEMP-TABLE NPVare.


FUNCTION getBuffersAndFieldsBrwNPVare RETURNS CHARACTER():
  RETURN
    'NPVare'
     + ';iNPVareId'
     + ';Varenr'
     + ';NRFnr'
     + ';Varenavn'
     + ';VareDimmensjon'
     + ';VareEnhetspris'
     + ';VareKapasitet'
     + ';VareKVverdi'
     + ';VareMaxtemperatur'
     + ';VareMaxtrykk'
     + ';VarePipeDimm'
     + ';VareVannkapasitet'
     + ';VareVeggtykkelse'
     + ';iNPVaregruppeId'
     + ';iNPVareTypeId'
     + ';Varebeskrivelse'
  + ',NPVaregruppe'
     + ';VaregruppeNavn'
  + ',NPVareType'
     + ';VareTypeNavn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPVare RETURNS CHARACTER():
  RETURN 'FIRST NPVaregruppe OF NPVare OUTER-JOIN NO-LOCK,FIRST NPVareType OF NPVare OUTER-JOIN NO-LOCK'.
END FUNCTION.
DEF VAR oFmNPVare AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPVare AS JBoxToolbar NO-UNDO.


DEF VAR opopupNPVare AS JBoxPopupMenu NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPVare

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPVare

/* Definitions for BROWSE BrwNPVare                                     */
&Scoped-define FIELDS-IN-QUERY-BrwNPVare NPVare.iNPVareId NPVare.Varenr ~
NPVare.NRFnr NPVare.VaregruppeNavn NPVare.Varenavn NPVare.VareTypeNavn ~
NPVare.VareDimmensjon NPVare.VareEnhetspris NPVare.VareKapasitet ~
NPVare.VareKVverdi NPVare.VareMaxtemperatur NPVare.VareMaxtrykk ~
NPVare.VarePipeDimm NPVare.VareVannkapasitet NPVare.VareVeggtykkelse ~
NPVare.iNPVaregruppeId NPVare.iNPVareTypeId NPVare.Varebeskrivelse 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPVare NPVare.iNPVareId 
&Scoped-define QUERY-STRING-BrwNPVare FOR EACH NPVare NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPVare OPEN QUERY BrwNPVare FOR EACH NPVare NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPVare NPVare
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPVare NPVare


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPVare new_tbNPVare copy_tbNPVare ~
undo_tbNPVare save_tbNPVare delete_tbNPVare refresh_tbNPVare ~
filter_tbNPVare BrwNPVare iNPVareId Varenr NRFnr Varenavn iNPVaregruppeId ~
iNPVareTypeId VareEnhetspris VarePipeDimm VareDimmensjon VareVeggtykkelse ~
VareKapasitet VareMaxtemperatur VareVannkapasitet VareMaxtrykk VareKVverdi ~
Varebeskrivelse 
&Scoped-Define DISPLAYED-OBJECTS iNPVareId Varenr NRFnr Varenavn ~
iNPVaregruppeId iNPVareTypeId VareEnhetspris VarePipeDimm VareDimmensjon ~
VareVeggtykkelse VareKapasitet VareMaxtemperatur VareVannkapasitet ~
VareMaxtrykk VareKVverdi Varebeskrivelse lblVarebeskrivelse 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPVare 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPVare 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON filter_tbNPVare 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPVare 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPVare 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPVare 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPVare 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE iNPVaregruppeId AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Varegruppe" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1",1
     DROP-DOWN-LIST
     SIZE 62 BY 1.

DEFINE VARIABLE iNPVareTypeId AS INTEGER FORMAT ">>>>>>>9" INITIAL 0 
     LABEL "VaretypeId" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1",1
     DROP-DOWN-LIST
     SIZE 62 BY 1.

DEFINE VARIABLE Varebeskrivelse AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 68 BY 3.57.

DEFINE VARIABLE iNPVareId AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Id" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1.

DEFINE VARIABLE lblVarebeskrivelse AS CHARACTER FORMAT "X(256)":U INITIAL "Beskrivelse:" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE NRFnr AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "NRFnr" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1.

DEFINE VARIABLE VareDimmensjon AS DECIMAL FORMAT "->>>>>>>9.99" INITIAL 0 
     LABEL "Dimm. (mm)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareEnhetspris AS DECIMAL FORMAT "->,>>>,>>9.99" INITIAL 0 
     LABEL "Enhetspris" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1.

DEFINE VARIABLE VareKapasitet AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "Volum (m3)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareKVverdi AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "KVverdi" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareMaxtemperatur AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Maks temp (C)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1.

DEFINE VARIABLE VareMaxtrykk AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Makstrykk (bar)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1.

DEFINE VARIABLE Varenavn AS CHARACTER FORMAT "x(100)" 
     LABEL "Varenavn" 
     VIEW-AS FILL-IN 
     SIZE 68 BY 1.

DEFINE VARIABLE Varenr AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Varenr" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1.

DEFINE VARIABLE VarePipeDimm AS DECIMAL FORMAT ">>>>>>9.99<" INITIAL 0 
     LABEL "Rørdimm.(mm)" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE VareVannkapasitet AS DECIMAL FORMAT "->>>>>>>9.9999" INITIAL 0 
     LABEL "Vannkap.(m3/h)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareVeggtykkelse AS DECIMAL FORMAT ">>>>>9.99<<" INITIAL 0 
     LABEL "Veggtykk.(mm)" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE RECTANGLE tbNPVare
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 147 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPVare FOR 
      NPVare SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPVare
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPVare C-Win _STRUCTURED
  QUERY BrwNPVare NO-LOCK DISPLAY
      NPVare.iNPVareId COLUMN-LABEL "Id" FORMAT ">>>>>>>>9":U
      NPVare.Varenr COLUMN-LABEL "Varenr" FORMAT ">>>>>>>>9":U
      NPVare.NRFnr COLUMN-LABEL "NRFnr" FORMAT ">>>>>>>>9":U
      NPVare.VaregruppeNavn COLUMN-LABEL "Varegruppe" FORMAT "x(50)":U
      NPVare.Varenavn COLUMN-LABEL "Varenavn" FORMAT "x(100)":U
            WIDTH 30
      NPVare.VareTypeNavn COLUMN-LABEL "Varetype" FORMAT "x(50)":U
      NPVare.VareDimmensjon COLUMN-LABEL "Dimmensjon" FORMAT "->>>>>>>9.99":U
      NPVare.VareEnhetspris COLUMN-LABEL "Enhetspris" FORMAT "->,>>>,>>9.99":U
      NPVare.VareKapasitet COLUMN-LABEL "Kapasitet" FORMAT ">>>,>>9.99":U
      NPVare.VareKVverdi COLUMN-LABEL "KVverdi" FORMAT ">>>,>>9.99":U
      NPVare.VareMaxtemperatur COLUMN-LABEL "Maks temp" FORMAT ">>>>9":U
      NPVare.VareMaxtrykk COLUMN-LABEL "Makstrykk" FORMAT ">>>>>9":U
      NPVare.VarePipeDimm COLUMN-LABEL "Rørdimm." FORMAT ">>>>>>9.99<":U
            WIDTH 12.6
      NPVare.VareVannkapasitet COLUMN-LABEL "Vannkapasitet" FORMAT "->>>>>>>9.9<<<":U
            WIDTH 15.6
      NPVare.VareVeggtykkelse COLUMN-LABEL "Veggtykkelse" FORMAT ">>>>>9.99<<":U
      NPVare.iNPVaregruppeId COLUMN-LABEL "VaregruppeId" FORMAT ">>>>>>9":U
      NPVare.iNPVareTypeId COLUMN-LABEL "VaretypeId" FORMAT ">>>>>>>9":U
      NPVare.Varebeskrivelse COLUMN-LABEL "Varebeskrivelse" FORMAT "x(255)":U
  ENABLE
      NPVare.iNPVareId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 62 BY 15 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPVare AT ROW 1.1 COL 1.2 WIDGET-ID 40
     copy_tbNPVare AT ROW 1.1 COL 7.4 WIDGET-ID 42
     undo_tbNPVare AT ROW 1.1 COL 13.4 WIDGET-ID 44
     save_tbNPVare AT ROW 1.1 COL 19.4 WIDGET-ID 46
     delete_tbNPVare AT ROW 1.1 COL 25.4 WIDGET-ID 48
     refresh_tbNPVare AT ROW 1.1 COL 31.4 WIDGET-ID 50
     filter_tbNPVare AT ROW 1.1 COL 37.4 WIDGET-ID 52
     BrwNPVare AT ROW 2.91 COL 1 WIDGET-ID 200
     iNPVareId AT ROW 3.38 COL 78 COLON-ALIGNED
     Varenr AT ROW 4.33 COL 78 COLON-ALIGNED
     NRFnr AT ROW 4.33 COL 101 COLON-ALIGNED
     Varenavn AT ROW 5.29 COL 78 COLON-ALIGNED
     iNPVaregruppeId AT ROW 6.48 COL 78 COLON-ALIGNED WIDGET-ID 58
     iNPVareTypeId AT ROW 7.48 COL 78 COLON-ALIGNED WIDGET-ID 60
     VareEnhetspris AT ROW 8.52 COL 78 COLON-ALIGNED
     VarePipeDimm AT ROW 9.91 COL 117 COLON-ALIGNED
     VareDimmensjon AT ROW 9.95 COL 78 COLON-ALIGNED
     VareVeggtykkelse AT ROW 10.91 COL 117 COLON-ALIGNED
     VareKapasitet AT ROW 10.95 COL 78 COLON-ALIGNED
     VareMaxtemperatur AT ROW 11.91 COL 117 COLON-ALIGNED
     VareVannkapasitet AT ROW 11.95 COL 78 COLON-ALIGNED
     VareMaxtrykk AT ROW 12.91 COL 117 COLON-ALIGNED
     VareKVverdi AT ROW 12.95 COL 78 COLON-ALIGNED
     Varebeskrivelse AT ROW 14.1 COL 80 NO-LABEL WIDGET-ID 62
     lblVarebeskrivelse AT ROW 14.1 COL 66 COLON-ALIGNED NO-LABEL
     tbNPVare AT ROW 1 COL 1 WIDGET-ID 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 147.8 BY 16.91 WIDGET-ID 100.


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
         TITLE              = "Vedlikehold vareregister"
         HEIGHT             = 16.91
         WIDTH              = 147.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 147.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 147.8
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
/* BROWSE-TAB BrwNPVare filter_tbNPVare DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 16.91
       FRAME DEFAULT-FRAME:WIDTH            = 147.8.

ASSIGN 
       BrwNPVare:PRIVATE-DATA IN FRAME DEFAULT-FRAME           = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excel,multiSortBrowse;Sorter på flere kolonner,copyBrowseRows;Kopier rad(er)".

ASSIGN 
       NPVare.Varebeskrivelse:VISIBLE IN BROWSE BrwNPVare = FALSE.

/* SETTINGS FOR FILL-IN lblVarebeskrivelse IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       lblVarebeskrivelse:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Beskrivelse:".

ASSIGN 
       tbNPVare:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filtermaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPVare
/* Query rebuild information for BROWSE BrwNPVare
     _TblList          = "norcalc.NPVare"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER"
     _FldNameList[1]   > "_<CALC>"
"NPVare.iNPVareId" "Id" ">>>>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPVare.Varenr" "Varenr" ">>>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPVare.NRFnr" "NRFnr" ">>>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPVare.VaregruppeNavn" "Varegruppe" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPVare.Varenavn" "Varenavn" "x(100)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPVare.VareTypeNavn" "Varetype" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPVare.VareDimmensjon" "Dimmensjon" "->>>>>>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPVare.VareEnhetspris" "Enhetspris" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPVare.VareKapasitet" "Kapasitet" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPVare.VareKVverdi" "KVverdi" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPVare.VareMaxtemperatur" "Maks temp" ">>>>9" "integer" ? ? ? ? ? ? no "" no no "10.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPVare.VareMaxtrykk" "Makstrykk" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPVare.VarePipeDimm" "Rørdimm." ">>>>>>9.99<" "decimal" ? ? ? ? ? ? no "" no no "12.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPVare.VareVannkapasitet" "Vannkapasitet" "->>>>>>>9.9<<<" "decimal" ? ? ? ? ? ? no "" no no "15.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPVare.VareVeggtykkelse" "Veggtykkelse" ">>>>>9.99<<" "decimal" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPVare.iNPVaregruppeId" "VaregruppeId" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPVare.iNPVareTypeId" "VaretypeId" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPVare.Varebeskrivelse" "Varebeskrivelse" "x(255)" "character" ? ? ? ? ? ? no "" no no "255" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPVare */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Vedlikehold vareregister */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Vedlikehold vareregister */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPVare
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
{incl/conttrigg.i oBrwNPVare:BROWSE-HANDLE}

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
  DISPLAY iNPVareId Varenr NRFnr Varenavn iNPVaregruppeId iNPVareTypeId 
          VareEnhetspris VarePipeDimm VareDimmensjon VareVeggtykkelse 
          VareKapasitet VareMaxtemperatur VareVannkapasitet VareMaxtrykk 
          VareKVverdi Varebeskrivelse lblVarebeskrivelse 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPVare new_tbNPVare copy_tbNPVare undo_tbNPVare save_tbNPVare 
         delete_tbNPVare refresh_tbNPVare filter_tbNPVare BrwNPVare iNPVareId 
         Varenr NRFnr Varenavn iNPVaregruppeId iNPVareTypeId VareEnhetspris 
         VarePipeDimm VareDimmensjon VareVeggtykkelse VareKapasitet 
         VareMaxtemperatur VareVannkapasitet VareMaxtrykk VareKVverdi 
         Varebeskrivelse 
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

  oBrwNPVare = NEW JBoxBrowse(brwNPVare:HANDLE).
  //oBrwNPVare:MSWinMultiSelect = true.
  oFmNPVare = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPVare:updateFields = 'Varenr,NRFnr,Varenavn,Varebeskrivelse,iNPVaregruppeId,iNPVareTypeId,VareDimmensjon,VareEnhetspris,VareKapasitet,VareKVverdi,VareMaxtemperatur,VareMaxtrykk,VarePipeDimm,VareVannkapasitet,VareVeggtykkelse'.
  oFmNPVare:DisplayFields = 'iNPVareId'.

  oFmNPVare:BROWSE-OBJECT = oBrwNPVare.
  otbNPVare = NEW JBoxToolbar(tbNPVare:HANDLE).

  oBrwNPVare:TOOLBAR-OBJECT = otbNPVare.
  oFmNPVare:TOOLBAR-OBJECT = otbNPVare.

  assign 
    iNPVaregruppeId:DELIMITER = '|'
    iNPVaregruppeId:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('NPVareGruppe;VareGruppeNavn;iNPVareGruppeId','where VareGruppeAktiv = true')
    iNPVareTypeId:DELIMITER = '|'
    iNPVareTypeId:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('NPVareType;VareTypeNavn;iNPVareTypeId','where true')
    .
  opopupNPVare = NEW JBoxPopupMenu().
  opopupNPVare:AddToolGroup('refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excel,multiSortBrowse;Sorter på flere kolonner,copyBrowseRows;Kopier rad(er)').

  oBrwNPVare:POPUP-MENU-OBJECT = opopupNPVare.
END.
oBrwNPVare:OpenQuery().

oContainer:setNoResizeX('VareBeskrivelse').
oContainer:initResize(320,800).

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

