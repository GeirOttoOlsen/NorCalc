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
    FIELD varenr AS integer
    FIELD produktnavn AS character
    FIELD fast_tekst AS character
    FIELD pris AS decimal
    FIELD kapasitet AS decimal
    FIELD materialkvaliteter AS character
    FIELD ror_dim AS decimal
    FIELD vegg_tykkelse AS decimal
    FIELD kv_verdi AS decimal
    FIELD df_diameter AS integer
    FIELD tegnings_ref AS character
    FIELD max_temp AS integer
    FIELD max_trykk AS decimal
    FIELD nrf_nr AS integer
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
     + ';varenr'
     + ';produktnavn'
     + ';fast_tekst'
     + ';pris'
     + ';kapasitet'
     + ';materialkvaliteter'
     + ';ror_dim'
     + ';vegg_tykkelse'
     + ';kv_verdi'
     + ';df_diameter'
     + ';tegnings_ref'
     + ';max_temp'
     + ';max_trykk'
     + ';nrf_nr'
     + ';volum'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPVARELISTE RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPSPVARELISTE AS JBoxFieldMap NO-UNDO.


DEF VAR otbNPSPVARELISTE AS JBoxToolbar NO-UNDO.

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
&Scoped-define FIELDS-IN-QUERY-BrwNPSPVARELISTE NPSPVARELISTE.varenr ~
NPSPVARELISTE.produktnavn NPSPVARELISTE.fast_tekst NPSPVARELISTE.pris ~
NPSPVARELISTE.kapasitet NPSPVARELISTE.materialkvaliteter ~
NPSPVARELISTE.ror_dim NPSPVARELISTE.vegg_tykkelse NPSPVARELISTE.kv_verdi ~
NPSPVARELISTE.df_diameter NPSPVARELISTE.tegnings_ref NPSPVARELISTE.max_temp ~
NPSPVARELISTE.max_trykk NPSPVARELISTE.nrf_nr NPSPVARELISTE.volum 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPVARELISTE ~
NPSPVARELISTE.varenr 
&Scoped-define QUERY-STRING-BrwNPSPVARELISTE FOR EACH NPSPVARELISTE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPVARELISTE OPEN QUERY BrwNPSPVARELISTE FOR EACH NPSPVARELISTE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPVARELISTE NPSPVARELISTE
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPVARELISTE NPSPVARELISTE


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPVARELISTE new_tbNPSPVARELISTE ~
copy_tbNPSPVARELISTE undo_tbNPSPVARELISTE save_tbNPSPVARELISTE ~
delete_tbNPSPVARELISTE refresh_tbNPSPVARELISTE filter_tbNPSPVARELISTE ~
excel_tbNPSPVARELISTE fiSearch BrwNPSPVARELISTE varenr nrf_nr ror_dim ~
max_temp produktnavn materialkvaliteter max_trykk pris volum kapasitet ~
fast_tekst lblFast_tekst 
&Scoped-Define DISPLAYED-OBJECTS fiSearch varenr nrf_nr ror_dim max_temp ~
produktnavn materialkvaliteter max_trykk pris volum kapasitet fast_tekst ~
lblFast_tekst 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSPVARELISTE 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSPVARELISTE 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbNPSPVARELISTE 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSPVARELISTE 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSPVARELISTE 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPSPVARELISTE 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSPVARELISTE 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPSPVARELISTE 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE fast_tekst AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 95 BY 3.33 NO-UNDO.

DEFINE VARIABLE fiSearch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE kapasitet AS DECIMAL FORMAT "->>9.999" INITIAL 0 
     LABEL "Kapasitet (m3/h)" 
     VIEW-AS FILL-IN 
     SIZE 13.2 BY 1.

DEFINE VARIABLE lblFast_tekst AS CHARACTER FORMAT "X(256)":U INITIAL "Fast tekst:" 
      VIEW-AS TEXT 
     SIZE 10 BY .62 NO-UNDO.

DEFINE VARIABLE materialkvaliteter AS CHARACTER FORMAT "X(50)" 
     LABEL "Materialkval." 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1.

DEFINE VARIABLE max_temp AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Max temp (C)" 
     VIEW-AS FILL-IN 
     SIZE 6.2 BY 1.

DEFINE VARIABLE max_trykk AS DECIMAL FORMAT ">>9.9<" INITIAL 0 
     LABEL "Max trykk (bar)" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1.

DEFINE VARIABLE nrf_nr AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "NRF" 
     VIEW-AS FILL-IN 
     SIZE 11.8 BY 1 NO-UNDO.

DEFINE VARIABLE pris AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "Pris" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE produktnavn AS CHARACTER FORMAT "X(45)" 
     LABEL "Produktnavn" 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1.

DEFINE VARIABLE ror_dim AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Rørdim (mm)" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1.

DEFINE VARIABLE varenr AS INTEGER FORMAT "9999999" INITIAL 0 
     LABEL "Varenr" 
     VIEW-AS FILL-IN 
     SIZE 11.8 BY 1.

DEFINE VARIABLE volum AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "Volum (m3)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE RECTANGLE tbNPSPVARELISTE
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 195.6 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPVARELISTE FOR 
      NPSPVARELISTE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPVARELISTE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPVARELISTE C-Win _STRUCTURED
  QUERY BrwNPSPVARELISTE NO-LOCK DISPLAY
      NPSPVARELISTE.varenr COLUMN-LABEL "Varenr" FORMAT "9999999":U
      NPSPVARELISTE.produktnavn COLUMN-LABEL "Produktnavn" FORMAT "X(45)":U
      NPSPVARELISTE.fast_tekst COLUMN-LABEL "Fast Tekst" FORMAT "A(255)":U
      NPSPVARELISTE.pris COLUMN-LABEL "Pris" FORMAT ">>>,>>9.99":U
      NPSPVARELISTE.kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSPVARELISTE.materialkvaliteter COLUMN-LABEL "Materialkval." FORMAT "X(25)":U
      NPSPVARELISTE.ror_dim COLUMN-LABEL "Rørdim." FORMAT ">>9.99":U
      NPSPVARELISTE.vegg_tykkelse COLUMN-LABEL "Veggtykkelse" FORMAT ">9.99":U
      NPSPVARELISTE.kv_verdi COLUMN-LABEL "KV-verdi" FORMAT ">,>>9.99":U
      NPSPVARELISTE.df_diameter COLUMN-LABEL "DFØ" FORMAT ">>>9":U
      NPSPVARELISTE.tegnings_ref COLUMN-LABEL "Tegning" FORMAT "X(60)":U
      NPSPVARELISTE.max_temp COLUMN-LABEL "Max temp." FORMAT ">>9":U
      NPSPVARELISTE.max_trykk COLUMN-LABEL "Max trykk" FORMAT ">>9.9<":U
      NPSPVARELISTE.nrf_nr COLUMN-LABEL "NRF" FORMAT "9999999":U
      NPSPVARELISTE.volum COLUMN-LABEL "Volum" FORMAT ">>>9.99":U
  ENABLE
      NPSPVARELISTE.varenr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 77 BY 11.43 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSPVARELISTE AT ROW 1.1 COL 1.2 WIDGET-ID 20
     copy_tbNPSPVARELISTE AT ROW 1.1 COL 7.2 WIDGET-ID 22
     undo_tbNPSPVARELISTE AT ROW 1.1 COL 13.4 WIDGET-ID 24
     save_tbNPSPVARELISTE AT ROW 1.1 COL 19.4 WIDGET-ID 26
     delete_tbNPSPVARELISTE AT ROW 1.1 COL 25.6 WIDGET-ID 28
     refresh_tbNPSPVARELISTE AT ROW 1.1 COL 31.6 WIDGET-ID 30
     filter_tbNPSPVARELISTE AT ROW 1.1 COL 37.8 WIDGET-ID 32
     excel_tbNPSPVARELISTE AT ROW 1.1 COL 43.8 WIDGET-ID 34
     fiSearch AT ROW 2.91 COL 1 NO-LABEL
     BrwNPSPVARELISTE AT ROW 4.1 COL 1 WIDGET-ID 200
     varenr AT ROW 4.33 COL 99 COLON-ALIGNED
     nrf_nr AT ROW 4.33 COL 134 COLON-ALIGNED
     ror_dim AT ROW 4.33 COL 169 COLON-ALIGNED
     max_temp AT ROW 5.29 COL 169 COLON-ALIGNED
     produktnavn AT ROW 5.33 COL 99 COLON-ALIGNED
     materialkvaliteter AT ROW 6.29 COL 99 COLON-ALIGNED
     max_trykk AT ROW 6.29 COL 169 COLON-ALIGNED
     pris AT ROW 7.29 COL 99 COLON-ALIGNED
     volum AT ROW 7.29 COL 169 COLON-ALIGNED
     kapasitet AT ROW 8.29 COL 169 COLON-ALIGNED
     fast_tekst AT ROW 11.95 COL 101 NO-LABEL WIDGET-ID 16
     lblFast_tekst AT ROW 11.95 COL 89 COLON-ALIGNED NO-LABEL
     tbNPSPVARELISTE AT ROW 1 COL 1 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 196.6 BY 14.52 WIDGET-ID 100.


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
         TITLE              = "Spirovent vareliste"
         HEIGHT             = 14.52
         WIDTH              = 196.6
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 196.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 196.6
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
/* BROWSE-TAB BrwNPSPVARELISTE fiSearch DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 14.52
       FRAME DEFAULT-FRAME:WIDTH            = 196.6.

/* SETTINGS FOR FILL-IN fiSearch IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       lblFast_tekst:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Fast tekst:".

ASSIGN 
       tbNPSPVARELISTE:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

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
"NPSPVARELISTE.varenr" "Varenr" "9999999" "integer" ? ? ? ? ? ? yes "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSPVARELISTE.produktnavn" "Produktnavn" "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSPVARELISTE.fast_tekst" "Fast Tekst" "A(255)" "character" ? ? ? ? ? ? no "" no no "255" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSPVARELISTE.pris" "Pris" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSPVARELISTE.kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSPVARELISTE.materialkvaliteter" "Materialkval." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSPVARELISTE.ror_dim" "Rørdim." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSPVARELISTE.vegg_tykkelse" "Veggtykkelse" ">9.99" "decimal" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSPVARELISTE.kv_verdi" "KV-verdi" ">,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSPVARELISTE.df_diameter" "DFØ" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSPVARELISTE.tegnings_ref" "Tegning" "X(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSPVARELISTE.max_temp" "Max temp." ">>9" "integer" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSPVARELISTE.max_trykk" "Max trykk" ">>9.9<" "decimal" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSPVARELISTE.nrf_nr" "NRF" "9999999" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSPVARELISTE.volum" "Volum" ">>>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPVARELISTE */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Spirovent vareliste */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Spirovent vareliste */
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
  DISPLAY fiSearch varenr nrf_nr ror_dim max_temp produktnavn materialkvaliteter 
          max_trykk pris volum kapasitet fast_tekst lblFast_tekst 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSPVARELISTE new_tbNPSPVARELISTE copy_tbNPSPVARELISTE 
         undo_tbNPSPVARELISTE save_tbNPSPVARELISTE delete_tbNPSPVARELISTE 
         refresh_tbNPSPVARELISTE filter_tbNPSPVARELISTE excel_tbNPSPVARELISTE 
         fiSearch BrwNPSPVARELISTE varenr nrf_nr ror_dim max_temp produktnavn 
         materialkvaliteter max_trykk pris volum kapasitet fast_tekst 
         lblFast_tekst 
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
  oBrwNPSPVARELISTE:setSearchField(fiSearch:HANDLE).
  //oBrwNPSPVARELISTE:setNoResizeX().
  oFmNPSPVARELISTE = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSPVARELISTE:updateFields = 'varenr,nrf_nr,produktnavn,materialkvaliteter,fast_tekst,pris,kapasitet,ror_dim,max_temp,max_trykk,volum'.
  oFmNPSPVARELISTE:primaryKeyFields = 'varenr'.
  
  oFmNPSPVARELISTE:BROWSE-OBJECT = oBrwNPSPVARELISTE.
  otbNPSPVARELISTE = NEW JBoxToolbar(tbNPSPVARELISTE:HANDLE).

  oBrwNPSPVARELISTE:TOOLBAR-OBJECT = otbNPSPVARELISTE.
  oFmNPSPVARELISTE:TOOLBAR-OBJECT = otbNPSPVARELISTE.
END.
oBrwNPSPVARELISTE:OpenQuery().


oContainer:initResize(300,500).
oContainer:setNoResizeX('fast_tekst').
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

