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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHGruppe ***/
DEF VAR oBrwNPSHGruppe AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHGruppe
    FIELD iNPSHGruppeId AS integer
    FIELD NPSHGruppeTypeNavn AS character
    FIELD gruppe# AS integer
    FIELD grunnlag AS character
    FIELD nedre AS decimal
    FIELD ovre AS decimal
    FIELD storrelse AS character
    FIELD iNPSHGruppeTypeId AS integer
    FIELD NPSHGruppeTypeBeskrivelse AS character
    FIELD iNPSHGruppeTypeId2 AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_NPSHGruppe FOR TEMP-TABLE NPSHGruppe.


FUNCTION getBuffersAndFieldsBrwNPSHGruppe RETURNS CHARACTER():
  RETURN
    'NPSHGruppe'
     + ';iNPSHGruppeId'
     + ';gruppe#'
     + ';grunnlag'
     + ';nedre'
     + ';ovre'
     + ';storrelse'
     + ';iNPSHGruppeTypeId'
  + ',NPSHGruppeType'
     + ';NPSHGruppeTypeNavn'
     + ';NPSHGruppeTypeBeskrivelse'
     + ';iNPSHGruppeTypeId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHGruppe RETURNS CHARACTER():
  RETURN 'FIRST NPSHGruppeType  WHERE NPSHGruppeType.iNPSHGruppeTypeId = NPSHGruppe.iNPSHGruppeTypeId OUTER-JOIN NO-LOCK'.
END FUNCTION.
DEF VAR oFmNPSHGruppe AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPSHGruppe AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHGruppe

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHGruppe

/* Definitions for BROWSE BrwNPSHGruppe                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHGruppe NPSHGruppe.iNPSHGruppeId ~
NPSHGruppe.NPSHGruppeTypeNavn NPSHGruppe.gruppe# NPSHGruppe.grunnlag ~
NPSHGruppe.nedre NPSHGruppe.ovre NPSHGruppe.storrelse ~
NPSHGruppe.iNPSHGruppeTypeId NPSHGruppe.NPSHGruppeTypeBeskrivelse ~
NPSHGruppe.iNPSHGruppeTypeId2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHGruppe ~
NPSHGruppe.iNPSHGruppeId 
&Scoped-define QUERY-STRING-BrwNPSHGruppe FOR EACH NPSHGruppe NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHGruppe OPEN QUERY BrwNPSHGruppe FOR EACH NPSHGruppe NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHGruppe NPSHGruppe
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHGruppe NPSHGruppe


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHGruppe new_tbNPSHGruppe ~
copy_tbNPSHGruppe undo_tbNPSHGruppe save_tbNPSHGruppe delete_tbNPSHGruppe ~
refresh_tbNPSHGruppe excel_tbNPSHGruppe filter_tbNPSHGruppe BrwNPSHGruppe ~
iNPSHGruppeId iNPSHGruppeTypeId grunnlag gruppe# ovre storrelse nedre 
&Scoped-Define DISPLAYED-OBJECTS iNPSHGruppeId iNPSHGruppeTypeId grunnlag ~
gruppe# ovre storrelse nedre 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSHGruppe 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSHGruppe 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbNPSHGruppe 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSHGruppe 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSHGruppe 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHGruppe 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSHGruppe 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPSHGruppe 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE iNPSHGruppeTypeId AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "GruppeTypeId" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1",1
     DROP-DOWN-LIST
     SIZE 16 BY 1.

DEFINE VARIABLE grunnlag AS CHARACTER FORMAT "x(14)" 
     LABEL "Grunnlag" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.

DEFINE VARIABLE gruppe# AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Gruppe#" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1.

DEFINE VARIABLE iNPSHGruppeId AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "GruppeId" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1 NO-UNDO.

DEFINE VARIABLE nedre AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Nedre" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE ovre AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Øvre" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE storrelse AS CHARACTER FORMAT "X(5)" 
     LABEL "Størrelse" 
     VIEW-AS FILL-IN 
     SIZE 6.4 BY 1.

DEFINE RECTANGLE tbNPSHGruppe
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 144 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHGruppe FOR 
      NPSHGruppe SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHGruppe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHGruppe C-Win _STRUCTURED
  QUERY BrwNPSHGruppe NO-LOCK DISPLAY
      NPSHGruppe.iNPSHGruppeId COLUMN-LABEL "NPSHGruppeId" FORMAT ">>>>>>>>9":U
      NPSHGruppe.NPSHGruppeTypeNavn COLUMN-LABEL "GruppeType" FORMAT "X(3)":U
      NPSHGruppe.gruppe# COLUMN-LABEL "Gruppe#" FORMAT ">>>>>9":U
      NPSHGruppe.grunnlag COLUMN-LABEL "Grunnlag" FORMAT "x(14)":U
      NPSHGruppe.nedre COLUMN-LABEL "Nedre" FORMAT "->>,>>9.99":U
      NPSHGruppe.ovre COLUMN-LABEL "Øvre" FORMAT "->>,>>9.99":U
      NPSHGruppe.storrelse COLUMN-LABEL "Størrelse" FORMAT "X(5)":U
      NPSHGruppe.iNPSHGruppeTypeId COLUMN-LABEL "GruppeTypeId" FORMAT ">>>>>>>>9":U
      NPSHGruppe.NPSHGruppeTypeBeskrivelse COLUMN-LABEL "Beskrivelse" FORMAT "x(255)":U
            WIDTH 50
      NPSHGruppe.iNPSHGruppeTypeId2 COLUMN-LABEL "GruppeTypeId" FORMAT ">>>>>>>>9":U
  ENABLE
      NPSHGruppe.iNPSHGruppeId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 13.1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHGruppe AT ROW 1.1 COL 1.2 WIDGET-ID 16
     copy_tbNPSHGruppe AT ROW 1.1 COL 7.4 WIDGET-ID 18
     undo_tbNPSHGruppe AT ROW 1.1 COL 13.4 WIDGET-ID 20
     save_tbNPSHGruppe AT ROW 1.1 COL 19.4 WIDGET-ID 22
     delete_tbNPSHGruppe AT ROW 1.1 COL 25.4 WIDGET-ID 24
     refresh_tbNPSHGruppe AT ROW 1.1 COL 31.4 WIDGET-ID 32
     excel_tbNPSHGruppe AT ROW 1.1 COL 37.4 WIDGET-ID 26
     filter_tbNPSHGruppe AT ROW 1.1 COL 43.4 WIDGET-ID 28
     BrwNPSHGruppe AT ROW 2.91 COL 2 WIDGET-ID 200
     iNPSHGruppeId AT ROW 3.86 COL 105 COLON-ALIGNED
     iNPSHGruppeTypeId AT ROW 4.81 COL 105 COLON-ALIGNED WIDGET-ID 30
     grunnlag AT ROW 5.81 COL 105 COLON-ALIGNED
     gruppe# AT ROW 6.81 COL 105 COLON-ALIGNED
     ovre AT ROW 7.81 COL 105 COLON-ALIGNED
     storrelse AT ROW 8.81 COL 105 COLON-ALIGNED
     nedre AT ROW 9.81 COL 105 COLON-ALIGNED
     tbNPSHGruppe AT ROW 1 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 144.8 BY 15 WIDGET-ID 100.


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
         TITLE              = "Vedlikehold grupper"
         HEIGHT             = 15
         WIDTH              = 144.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 144.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 144.8
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
/* BROWSE-TAB BrwNPSHGruppe filter_tbNPSHGruppe DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 15
       FRAME DEFAULT-FRAME:WIDTH            = 144.8.


ASSIGN 
       tbNPSHGruppe:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,excel;Excel,filter;Filtermaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHGruppe
/* Query rebuild information for BROWSE BrwNPSHGruppe
     _TblList          = "norcalc.NPSHGruppe"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _FldNameList[1]   > "_<CALC>"
"NPSHGruppe.iNPSHGruppeId" "NPSHGruppeId" ">>>>>>>>9" "integer" ? ? ? ? ? ? yes ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHGruppe.NPSHGruppeTypeNavn" "GruppeType" "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHGruppe.gruppe#" "Gruppe#" ">>>>>9" "integer" ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHGruppe.grunnlag" "Grunnlag" "x(14)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHGruppe.nedre" "Nedre" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHGruppe.ovre" "Øvre" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHGruppe.storrelse" "Størrelse" "X(5)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHGruppe.iNPSHGruppeTypeId" "GruppeTypeId" ">>>>>>>>9" "integer" ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSHGruppe.NPSHGruppeTypeBeskrivelse" "Beskrivelse" "x(255)" "character" ? ? ? ? ? ? no ? no no "50" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSHGruppe.iNPSHGruppeTypeId2" "GruppeTypeId" ">>>>>>>>9" "integer" ? ? ? ? ? ? no ? no no ? no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHGruppe */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Vedlikehold grupper */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Vedlikehold grupper */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHGruppe
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
{incl/conttrigg.i oBrwNPSHGruppe:BROWSE-HANDLE}

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
  DISPLAY iNPSHGruppeId iNPSHGruppeTypeId grunnlag gruppe# ovre storrelse nedre 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHGruppe new_tbNPSHGruppe copy_tbNPSHGruppe undo_tbNPSHGruppe 
         save_tbNPSHGruppe delete_tbNPSHGruppe refresh_tbNPSHGruppe 
         excel_tbNPSHGruppe filter_tbNPSHGruppe BrwNPSHGruppe iNPSHGruppeId 
         iNPSHGruppeTypeId grunnlag gruppe# ovre storrelse nedre 
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
DEFINE VARIABLE iDetailMoveX AS INTEGER NO-UNDO.

RUN enable_UI.

oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

DO WITH FRAME {&FRAME-NAME}:

  iDetailMoveX = brwNPSHGruppe:X + brwNPSHGruppe:WIDTH-PIXELS.
  oBrwNPSHGruppe = NEW JBoxBrowse(brwNPSHGruppe:HANDLE).
  oBrwNPSHGruppe:CreateGridFilter("").

  oFmNPSHGruppe = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHGruppe:updateFields = 'iNPSHGruppeTypeId,grunnlag,gruppe#,ovre,storrelse,nedre'.
  oFmNPSHGruppe:displayFields = 'iNPSHGruppeId'.
  oFmNPSHGruppe:BROWSE-OBJECT = oBrwNPSHGruppe.
  otbNPSHGruppe = NEW JBoxToolbar(tbNPSHGruppe:HANDLE).
  oBrwNPSHGruppe:TOOLBAR-OBJECT = otbNPSHGruppe.
  oFmNPSHGruppe:TOOLBAR-OBJECT  = otbNPSHGruppe.
  assign
    iNPSHGruppeTypeId:DELIMITER = '|'
    iNPSHGruppeTypeId:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPSHGruppeType;NPSHGruppeTypeNavn;iNPSHGruppeTypeId","Where true")  
  .
END.
oBrwNPSHGruppe:OpenQuery().


oContainer:initResize(iDetailMoveX, 300).

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

