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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHTILBUD ***/
DEF VAR oBrwNPSHTILBUD AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHTILBUD
    FIELD id AS integer
    FIELD anleggsnr AS integer
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD kundenr AS character
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD pris AS decimal
    FIELD pris_shuntgrupper AS decimal
    FIELD pris_tillegg AS decimal
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
DEF BUFFER v_NPSHTILBUD FOR TEMP-TABLE NPSHTILBUD.


FUNCTION getBuffersAndFieldsBrwNPSHTILBUD RETURNS CHARACTER():
  RETURN
    'NPSHTILBUD'
     + ';id'
     + ';anleggsnr'
     + ';avgittpris'
     + ';bet_bet'
     + ';deres_ref'
     + ';gyldighetstid'
     + ';kundenr'
     + ';lev_bet'
     + ';opplysninger'
     + ';pris'
     + ';pris_shuntgrupper'
     + ';pris_tillegg'
     + ';rabatt%'
     + ';tilbudsdato'
     + ';tilbudsid'
     + ';tilbudsnr'
     + ';vaar_ref'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHTILBUD RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
function freezeWindow returns logical(ibFreeze as log, ibRecursive as log):
  def var hWindow as handle no-undo.
  if not ibRecursive then this-procedure:current-window.
  else
  do:
    hWindow = session:first-child.
    do while valid-object(hWindow) and hWindow:type = 'window':
      hWindow:SENSITIVE = not ibFreeze.
      hWindow = hWindow:next-sibling.
    end.
  end.
  return true.
end.
DEF VAR otbNPSHTILBUD AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHTILBUD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTILBUD

/* Definitions for BROWSE BrwNPSHTILBUD                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD.id ~
NPSHTILBUD.anleggsnr NPSHTILBUD.avgittpris NPSHTILBUD.bet_bet ~
NPSHTILBUD.deres_ref NPSHTILBUD.gyldighetstid NPSHTILBUD.kundenr ~
NPSHTILBUD.lev_bet NPSHTILBUD.opplysninger NPSHTILBUD.pris ~
NPSHTILBUD.pris_shuntgrupper NPSHTILBUD.pris_tillegg NPSHTILBUD.rabatt% ~
NPSHTILBUD.tilbudsdato NPSHTILBUD.tilbudsid NPSHTILBUD.tilbudsnr ~
NPSHTILBUD.vaar_ref 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD.id 
&Scoped-define QUERY-STRING-BrwNPSHTILBUD FOR EACH NPSHTILBUD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHTILBUD OPEN QUERY BrwNPSHTILBUD FOR EACH NPSHTILBUD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHTILBUD new_tbNPSHTILBUD ~
edit_tbNPSHTILBUD copy_tbNPSHTILBUD delete_tbNPSHTILBUD ~
refresh_tbNPSHTILBUD filter_tbNPSHTILBUD browseconfig_tbNPSHTILBUD ~
excel_tbNPSHTILBUD BrwNPSHTILBUD 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPSHTILBUD 
     IMAGE-UP FILE "ico/table.ico":U
     IMAGE-INSENSITIVE FILE "gif/table_disabled.gif":U
     LABEL "Column setup" 
     SIZE 7.8 BY 1.95 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON copy_tbNPSHTILBUD 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 7.8 BY 1.95 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSHTILBUD 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 7.8 BY 1.95 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON edit_tbNPSHTILBUD 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 7.8 BY 1.95 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbNPSHTILBUD 
     IMAGE-UP FILE "ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSHTILBUD 
     IMAGE-UP FILE "ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSHTILBUD 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 7.8 BY 1.95 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHTILBUD 
     IMAGE-UP FILE "ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSHTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 137 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHTILBUD FOR 
      NPSHTILBUD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHTILBUD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHTILBUD C-Win _STRUCTURED
  QUERY BrwNPSHTILBUD NO-LOCK DISPLAY
      NPSHTILBUD.id COLUMN-LABEL "Id" FORMAT ">>>>>>":U
      NPSHTILBUD.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHTILBUD.avgittpris COLUMN-LABEL "Avgitt pris" FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.bet_bet COLUMN-LABEL "Bet. bet." FORMAT "X(20)":U
      NPSHTILBUD.deres_ref COLUMN-LABEL "Deres ref." FORMAT "X(30)":U
      NPSHTILBUD.gyldighetstid COLUMN-LABEL "Gyldighetstid" FORMAT ">99":U
      NPSHTILBUD.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSHTILBUD.lev_bet COLUMN-LABEL "Lev. bet." FORMAT "X(8)":U
      NPSHTILBUD.opplysninger COLUMN-LABEL "Opplysninger" FORMAT "X(1024)":U
      NPSHTILBUD.pris COLUMN-LABEL "Pris" FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.pris_shuntgrupper COLUMN-LABEL "Shunt" FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.pris_tillegg COLUMN-LABEL "Tillegg" FORMAT ">>>,>>9":U
      NPSHTILBUD.rabatt% COLUMN-LABEL "Rabatt%" FORMAT "->>9.99":U
      NPSHTILBUD.tilbudsdato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSHTILBUD.tilbudsid COLUMN-LABEL "tilbudsid" FORMAT "9999":U
      NPSHTILBUD.tilbudsnr COLUMN-LABEL "Tilbudsnr." FORMAT "X(20)":U
      NPSHTILBUD.vaar_ref COLUMN-LABEL "Vår ref." FORMAT "X(25)":U
  ENABLE
      NPSHTILBUD.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 137.6 BY 8.1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHTILBUD AT ROW 1.1 COL 1 WIDGET-ID 12
     edit_tbNPSHTILBUD AT ROW 1.1 COL 9 WIDGET-ID 14
     copy_tbNPSHTILBUD AT ROW 1.1 COL 16.8 WIDGET-ID 16
     delete_tbNPSHTILBUD AT ROW 1.1 COL 24.6 WIDGET-ID 18
     refresh_tbNPSHTILBUD AT ROW 1.1 COL 32.4 WIDGET-ID 4
     filter_tbNPSHTILBUD AT ROW 1.1 COL 40.2 WIDGET-ID 6
     browseconfig_tbNPSHTILBUD AT ROW 1.1 COL 48 WIDGET-ID 8
     excel_tbNPSHTILBUD AT ROW 1.1 COL 55.8 WIDGET-ID 10
     BrwNPSHTILBUD AT ROW 3.14 COL 1 WIDGET-ID 300
     tbNPSHTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 137.6 BY 21.57 WIDGET-ID 100.


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
         HEIGHT             = 21.57
         WIDTH              = 137.6
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 137.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 137.6
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
/* BROWSE-TAB BrwNPSHTILBUD excel_tbNPSHTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 21.57
       FRAME DEFAULT-FRAME:WIDTH            = 137.6.

ASSIGN 
       tbNPSHTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,edit;Edit,copy;Copy,delete;Delete,refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHTILBUD
/* Query rebuild information for BROWSE BrwNPSHTILBUD
     _TblList          = "norcalc.NPSHTILBUD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHTILBUD.id" "Id" ">>>>>>" "integer" ? ? ? ? ? ? yes "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHTILBUD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHTILBUD.avgittpris" "Avgitt pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHTILBUD.bet_bet" "Bet. bet." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHTILBUD.deres_ref" "Deres ref." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHTILBUD.gyldighetstid" "Gyldighetstid" ">99" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHTILBUD.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHTILBUD.lev_bet" "Lev. bet." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSHTILBUD.opplysninger" "Opplysninger" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSHTILBUD.pris" "Pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSHTILBUD.pris_shuntgrupper" "Shunt" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSHTILBUD.pris_tillegg" "Tillegg" ">>>,>>9" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSHTILBUD.rabatt%" "Rabatt%" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSHTILBUD.tilbudsdato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSHTILBUD.tilbudsid" "tilbudsid" "9999" "integer" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSHTILBUD.tilbudsnr" "Tilbudsnr." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSHTILBUD.vaar_ref" "Vår ref." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHTILBUD */
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


&Scoped-define BROWSE-NAME BrwNPSHTILBUD
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
{incl/conttrigg.i oBrwNPSHTILBUD:BROWSE-HANDLE}

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
  ENABLE tbNPSHTILBUD new_tbNPSHTILBUD edit_tbNPSHTILBUD copy_tbNPSHTILBUD 
         delete_tbNPSHTILBUD refresh_tbNPSHTILBUD filter_tbNPSHTILBUD 
         browseconfig_tbNPSHTILBUD excel_tbNPSHTILBUD BrwNPSHTILBUD 
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

  oBrwNPSHTILBUD = NEW JBoxBrowse(brwNPSHTILBUD:HANDLE).

  otbNPSHTILBUD = NEW JBoxToolbar(tbNPSHTILBUD:HANDLE).

  oBrwNPSHTILBUD:TOOLBAR-OBJECT = otbNPSHTILBUD.
END.
oBrwNPSHTILBUD:OpenQuery().


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
  freezeWindow(true,true).
  hChild = JBoxMainMenu:Instance:StartChildWindow("wSHTilbudDetalj.w","Tilbud",THIS-PROCEDURE,yes).
  
/*  hChild = JBoxMainMenu:Instance:StartNewWindow("wSHanlegg.w","Shunt anlegg",THIS-PROCEDURE,yes,no).*/
/*  dynamic-function('setParentBrowse' in hChild ,input oBrwNORPROSJEKT).*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
  def var hChild as handle no-undo.
  freezeWindow(true,true).
  hChild = JBoxMainMenu:Instance:StartChildWindow("wSHTilbudDetalj.w","Tilbud",THIS-PROCEDURE,yes).
  
/*  hChild = JBoxMainMenu:Instance:StartNewWindow("wSHanlegg.w","Shunt anlegg",THIS-PROCEDURE,yes,no).*/
  dynamic-function('setParentBrowse' in hChild ,input oBrwNPSHTILBUD).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
