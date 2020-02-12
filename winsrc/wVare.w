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


/*** Start instance property definitions for JBoxBrowse object oBrwNPVare ***/
DEF VAR oBrwNPVare AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPVare
    FIELD iNPVareId AS integer
    FIELD Varenr AS integer
    FIELD Varenavn AS character
    FIELD iNPVaregruppeId AS integer
    FIELD VaregruppeNavn AS character
    FIELD iNPVareTypeId AS integer
    FIELD VareTypeNavn AS character
    FIELD NRFnr AS integer
    FIELD VareDimmensjon AS decimal
    FIELD VareEnhetspris AS decimal
    FIELD VareKapasitet AS decimal
    FIELD VareKVverdi AS decimal
    FIELD VareMaxtemperatur AS integer
    FIELD VareMaxtrykk AS integer
    FIELD VarePipeDimm AS decimal
    FIELD VareVannkapasitet AS decimal
    FIELD VareVeggtykkelse AS decimal
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
     + ';Varenavn'
     + ';iNPVaregruppeId'
     + ';iNPVareTypeId'
     + ';NRFnr'
     + ';VareDimmensjon'
     + ';VareEnhetspris'
     + ';VareKapasitet'
     + ';VareKVverdi'
     + ';VareMaxtemperatur'
     + ';VareMaxtrykk'
     + ';VarePipeDimm'
     + ';VareVannkapasitet'
     + ';VareVeggtykkelse'
  + ',NPVareType'
     + ';VareTypeNavn'
  + ',NPVaregruppe'
     + ';VaregruppeNavn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPVare RETURNS CHARACTER():
  RETURN 'EACH NPVareType OF NPVare NO-LOCK,EACH NPVaregruppe OF NPVare NO-LOCK'.
END FUNCTION.
DEF VAR oTabNPVareDetalj AS JBoxMsTabs NO-UNDO.
DEF VAR otbNPVare AS JBoxToolbar NO-UNDO.

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
NPVare.Varenavn NPVare.iNPVaregruppeId NPVare.VaregruppeNavn ~
NPVare.iNPVareTypeId NPVare.VareTypeNavn NPVare.NRFnr NPVare.VareDimmensjon ~
NPVare.VareEnhetspris NPVare.VareKapasitet NPVare.VareKVverdi ~
NPVare.VareMaxtemperatur NPVare.VareMaxtrykk NPVare.VarePipeDimm ~
NPVare.VareVannkapasitet NPVare.VareVeggtykkelse 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPVare NPVare.iNPVareId 
&Scoped-define QUERY-STRING-BrwNPVare FOR EACH NPVare NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPVare OPEN QUERY BrwNPVare FOR EACH NPVare NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPVare NPVare
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPVare NPVare


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TabNPVareDetalj tbNPVare refresh_tbNPVare ~
filter_tbNPVare browseconfig_tbNPVare excel_tbNPVare BrwNPVare 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPVare 
     IMAGE-UP FILE "img/ico/table.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/table_disabled.gif":U
     LABEL "Column setup" 
     SIZE 7.8 BY 1.95 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON excel_tbNPVare 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPVare 
     IMAGE-UP FILE "img/ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPVare 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE TabNPVareDetalj
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 142 BY 14.52.

DEFINE RECTANGLE tbNPVare
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 142 BY 2.14.

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
      NPVare.Varenavn COLUMN-LABEL "Varenavn" FORMAT "x(50)":U
      NPVare.iNPVaregruppeId COLUMN-LABEL "VaregruppeId" FORMAT ">>>>>>9":U
      NPVare.VaregruppeNavn COLUMN-LABEL "Varegruppe" FORMAT "x(50)":U
      NPVare.iNPVareTypeId COLUMN-LABEL "VaretypeId" FORMAT ">>>>>>>9":U
      NPVare.VareTypeNavn COLUMN-LABEL "Varetype navn" FORMAT "x(50)":U
      NPVare.NRFnr COLUMN-LABEL "NRFnr" FORMAT ">>>>>>>>9":U
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
  ENABLE
      NPVare.iNPVareId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 142 BY 5.71 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPVare AT ROW 1.1 COL 1.2 WIDGET-ID 6
     filter_tbNPVare AT ROW 1.1 COL 9.2 WIDGET-ID 8
     browseconfig_tbNPVare AT ROW 1.1 COL 17 WIDGET-ID 10
     excel_tbNPVare AT ROW 1.1 COL 24.8 WIDGET-ID 12
     BrwNPVare AT ROW 3.14 COL 1 WIDGET-ID 300
     TabNPVareDetalj AT ROW 9.81 COL 1 WIDGET-ID 2
     tbNPVare AT ROW 1 COL 1 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 142.4 BY 23.33 WIDGET-ID 100.


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
         HEIGHT             = 23.33
         WIDTH              = 142.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 142.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 142.4
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
/* BROWSE-TAB BrwNPVare excel_tbNPVare DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 23.33
       FRAME DEFAULT-FRAME:WIDTH            = 142.4.

ASSIGN 
       tbNPVare:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPVare
/* Query rebuild information for BROWSE BrwNPVare
     _TblList          = "norcalc.NPVare"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPVare.iNPVareId" "Id" ">>>>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPVare.Varenr" "Varenr" ">>>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPVare.Varenavn" "Varenavn" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPVare.iNPVaregruppeId" "VaregruppeId" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPVare.VaregruppeNavn" "Varegruppe" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPVare.iNPVareTypeId" "VaretypeId" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPVare.VareTypeNavn" "Varetype navn" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPVare.NRFnr" "NRFnr" ">>>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPVare.VareDimmensjon" "Dimmensjon" "->>>>>>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPVare.VareEnhetspris" "Enhetspris" "->,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPVare.VareKapasitet" "Kapasitet" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPVare.VareKVverdi" "KVverdi" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPVare.VareMaxtemperatur" "Maks temp" ">>>>9" "integer" ? ? ? ? ? ? no "" no no "10.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPVare.VareMaxtrykk" "Makstrykk" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPVare.VarePipeDimm" "Rørdimm." ">>>>>>9.99<" "decimal" ? ? ? ? ? ? no "" no no "12.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPVare.VareVannkapasitet" "Vannkapasitet" "->>>>>>>9.9<<<" "decimal" ? ? ? ? ? ? no "" no no "15.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPVare.VareVeggtykkelse" "Veggtykkelse" ">>>>>9.99<<" "decimal" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPVare */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  //if oTabNPVareDetalj:getPageTabNum() = 3 then do:
  if avail NPVare then oTabNPVareDetalj:getPageBrowseObject(3):parentLink = "WHERE cContext = 'NPVare' and cEntityId = '" + string(NPVare.iNPVareId) + "'".
  
  run super.
 
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
  ENABLE TabNPVareDetalj tbNPVare refresh_tbNPVare filter_tbNPVare 
         browseconfig_tbNPVare excel_tbNPVare BrwNPVare 
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

  oTabNPVareDetalj = NEW JBoxMSTabs(TabNPVareDetalj:HANDLE,oBrwNPVare,"img/ico/paperclip.ico").
  oTabNPVareDetalj:pageOneType = "oneToOne".
  oTabNPVareDetalj:setLinkFields("iNPVareId").
  oTabNPVareDetalj:setLinkFields("iNPVareId",2).
  oTabNPVareDetalj:setLinkFields("parentlink",3). /*Settes i kallende program*/
  oTabNPVareDetalj:AddPage("Detljer","wVaredetalj.w","").
  oTabNPVareDetalj:AddPage("Varekobling","wVarekobling.w","").
  oTabNPVareDetalj:AddPage("Varedokument","wVaredokument.w","img/ico/paperclip.ico").
  otbNPVare = NEW JBoxToolbar(tbNPVare:HANDLE).

  oBrwNPVare:TOOLBAR-OBJECT = otbNPVare.
END.
oBrwNPVare:OpenQuery().


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

