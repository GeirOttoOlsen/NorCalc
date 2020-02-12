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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSPTILBUD ***/
DEF VAR oBrwNPSPTILBUD AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPTILBUD
    FIELD anleggsnr AS integer
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD id AS integer
    FIELD kundenr AS character
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD pris AS decimal
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD tilbudsid AS integer
    FIELD tilbudsnr AS character
    FIELD vaar_ref AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSPTILBUD FOR TEMP-TABLE NPSPTILBUD.


FUNCTION getBuffersAndFieldsBrwNPSPTILBUD RETURNS CHARACTER():
  RETURN
    'NPSPTILBUD'
     + ';anleggsnr'
     + ';avgittpris'
     + ';bet_bet'
     + ';deres_ref'
     + ';gyldighetstid'
     + ';id'
     + ';kundenr'
     + ';lev_bet'
     + ';opplysninger'
     + ';pris'
     + ';rabatt%'
     + ';tilbudsdato'
     + ';tilbudsid'
     + ';tilbudsnr'
     + ';vaar_ref'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPTILBUD RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
/*** Start instance property definitions for JBoxBrowse object oBrwNPSPSyst ***/
DEF VAR oBrwNPSPSyst AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPSyst
    FIELD anbefalt_max_kap AS decimal
    FIELD anb_max_innl_hast AS character
    FIELD anleggsnr AS integer
    FIELD anslutning AS character
    FIELD antall AS integer
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
    FIELD listepris AS decimal
    FIELD materialkvaliteter AS character
    FIELD max_temp AS integer
    FIELD max_trykk AS decimal
    FIELD medietemperatur AS character
    FIELD motflenser AS logical
    FIELD nrf_nr AS integer
    FIELD produktnavn AS character
    FIELD produkttype AS character
    FIELD refill AS logical
    FIELD ror_dim AS decimal
    FIELD spiroventkapasitet AS decimal
    FIELD systembetegnelse AS character
    FIELD systemnr AS integer
    FIELD trykkfall AS decimal
    FIELD utv_gjengeventil AS logical
    FIELD varenr AS integer
    FIELD vegg_tykkelse AS decimal
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSPSyst FOR TEMP-TABLE NPSPSyst.


FUNCTION getBuffersAndFieldsBrwNPSPSyst RETURNS CHARACTER():
  RETURN
    'NPSPSYST'
     + ';anbefalt_max_kap'
     + ';anb_max_innl_hast'
     + ';anleggsnr'
     + ';anslutning'
     + ';antall'
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
     + ';listepris'
     + ';materialkvaliteter'
     + ';max_temp'
     + ';max_trykk'
     + ';medietemperatur'
     + ';motflenser'
     + ';nrf_nr'
     + ';produktnavn'
     + ';produkttype'
     + ';refill'
     + ';ror_dim'
     + ';spiroventkapasitet'
     + ';systembetegnelse'
     + ';systemnr'
     + ';trykkfall'
     + ';utv_gjengeventil'
     + ';varenr'
     + ';vegg_tykkelse'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPSyst RETURNS CHARACTER():
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
&Scoped-define BROWSE-NAME BrwNPSPTILBUD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPTILBUD

/* Definitions for BROWSE BrwNPSPTILBUD                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD.anleggsnr ~
NPSPTILBUD.avgittpris NPSPTILBUD.bet_bet NPSPTILBUD.deres_ref ~
NPSPTILBUD.gyldighetstid NPSPTILBUD.id NPSPTILBUD.kundenr ~
NPSPTILBUD.lev_bet NPSPTILBUD.opplysninger NPSPTILBUD.pris ~
NPSPTILBUD.rabatt% NPSPTILBUD.tilbudsdato NPSPTILBUD.tilbudsid ~
NPSPTILBUD.tilbudsnr NPSPTILBUD.vaar_ref 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD.anleggsnr 
&Scoped-define QUERY-STRING-BrwNPSPTILBUD FOR EACH NPSPTILBUD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPTILBUD OPEN QUERY BrwNPSPTILBUD FOR EACH NPSPTILBUD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPTILBUD refresh_tbNPSPTILBUD ~
filter_tbNPSPTILBUD browseconfig_tbNPSPTILBUD excel_tbNPSPTILBUD ~
BrwNPSPTILBUD 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPSPTILBUD 
     IMAGE-UP FILE "bmp/table.bmp":U
     LABEL "Column setup" 
     SIZE 7.8 BY 1.95 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON excel_tbNPSPTILBUD 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSPTILBUD 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPSPTILBUD 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSPTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 151 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPTILBUD FOR 
      NPSPTILBUD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPTILBUD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPTILBUD C-Win _STRUCTURED
  QUERY BrwNPSPTILBUD NO-LOCK DISPLAY
      NPSPTILBUD.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPTILBUD.avgittpris COLUMN-LABEL "Avgitt pris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.bet_bet COLUMN-LABEL "Bet. bet." FORMAT "X(20)":U
      NPSPTILBUD.deres_ref COLUMN-LABEL "Deres ref." FORMAT "X(30)":U
      NPSPTILBUD.gyldighetstid COLUMN-LABEL "Gyldighetstid" FORMAT ">99":U
      NPSPTILBUD.id COLUMN-LABEL "Id" FORMAT ">>>>>>":U
      NPSPTILBUD.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSPTILBUD.lev_bet COLUMN-LABEL "Lev. bet." FORMAT "X(8)":U
      NPSPTILBUD.opplysninger COLUMN-LABEL "Opplysninger" FORMAT "X(1024)":U
      NPSPTILBUD.pris COLUMN-LABEL "Pris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.rabatt% COLUMN-LABEL "Rabatt%" FORMAT "->>9.99":U
      NPSPTILBUD.tilbudsdato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSPTILBUD.tilbudsid COLUMN-LABEL "tilbudsid" FORMAT "9999":U
      NPSPTILBUD.tilbudsnr COLUMN-LABEL "Tilbudsnr." FORMAT "X(20)":U
      NPSPTILBUD.vaar_ref COLUMN-LABEL "Vår ref." FORMAT "X(25)":U
  ENABLE
      NPSPTILBUD.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 151 BY 15.48 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSPTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 4
     filter_tbNPSPTILBUD AT ROW 1.1 COL 9 WIDGET-ID 6
     browseconfig_tbNPSPTILBUD AT ROW 1.1 COL 17 WIDGET-ID 8
     excel_tbNPSPTILBUD AT ROW 1.1 COL 24.8 WIDGET-ID 10
     BrwNPSPTILBUD AT ROW 3.14 COL 2 WIDGET-ID 200
     tbNPSPTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 152 BY 17.71 WIDGET-ID 100.


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
         HEIGHT             = 17.71
         WIDTH              = 152
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 152
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 152
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
/* BROWSE-TAB BrwNPSPTILBUD excel_tbNPSPTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 17.71
       FRAME DEFAULT-FRAME:WIDTH            = 152.

ASSIGN 
       tbNPSPTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPTILBUD
/* Query rebuild information for BROWSE BrwNPSPTILBUD
     _TblList          = "norcalc.NPSPTILBUD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSPTILBUD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSPTILBUD.avgittpris" "Avgitt pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSPTILBUD.bet_bet" "Bet. bet." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSPTILBUD.deres_ref" "Deres ref." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSPTILBUD.gyldighetstid" "Gyldighetstid" ">99" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSPTILBUD.id" "Id" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSPTILBUD.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSPTILBUD.lev_bet" "Lev. bet." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSPTILBUD.opplysninger" "Opplysninger" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSPTILBUD.pris" "Pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSPTILBUD.rabatt%" "Rabatt%" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSPTILBUD.tilbudsdato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSPTILBUD.tilbudsid" "tilbudsid" "9999" "integer" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSPTILBUD.tilbudsnr" "Tilbudsnr." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSPTILBUD.vaar_ref" "Vår ref." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPTILBUD */
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


&Scoped-define BROWSE-NAME BrwNPSPTILBUD
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
{incl/conttrigg.i oBrwNPSPTILBUD:BROWSE-HANDLE}

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
  ENABLE tbNPSPTILBUD refresh_tbNPSPTILBUD filter_tbNPSPTILBUD 
         browseconfig_tbNPSPTILBUD excel_tbNPSPTILBUD BrwNPSPTILBUD 
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

  oBrwNPSPTILBUD = NEW JBoxBrowse(brwNPSPTILBUD:HANDLE).

  otbNPSPTILBUD = NEW JBoxToolbar(tbNPSPTILBUD:HANDLE).

  oBrwNPSPTILBUD:TOOLBAR-OBJECT = otbNPSPTILBUD.
END.
oBrwNPSPTILBUD:OpenQuery().


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

