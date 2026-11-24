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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHVENTILTYPE ***/
DEF VAR oBrwNPSHVENTILTYPE AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHVENTILTYPE
    FIELD id AS integer
    FIELD fabrikat AS character
    FIELD ventiltype AS character
    FIELD VentiltypeAktiv AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHVENTILTYPE FOR TEMP-TABLE NPSHVENTILTYPE.


FUNCTION getBuffersAndFieldsBrwNPSHVENTILTYPE RETURNS CHARACTER():
  RETURN
    'NPSHVENTILTYPE'
     + ';id'
     + ';fabrikat'
     + ';ventiltype'
     + ';VentiltypeAktiv'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHVENTILTYPE RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPSHVENTILTYPE AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPSHVENTILTYPE AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHVENTILTYPE

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHVENTILTYPE

/* Definitions for BROWSE BrwNPSHVENTILTYPE                             */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHVENTILTYPE NPSHVENTILTYPE.id ~
NPSHVENTILTYPE.fabrikat NPSHVENTILTYPE.ventiltype ~
NPSHVENTILTYPE.VentiltypeAktiv 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHVENTILTYPE NPSHVENTILTYPE.id 
&Scoped-define QUERY-STRING-BrwNPSHVENTILTYPE FOR EACH NPSHVENTILTYPE NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHVENTILTYPE OPEN QUERY BrwNPSHVENTILTYPE FOR EACH NPSHVENTILTYPE NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHVENTILTYPE NPSHVENTILTYPE
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHVENTILTYPE NPSHVENTILTYPE


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHVENTILTYPE new_tbNPSHVENTILTYPE ~
copy_tbNPSHVENTILTYPE undo_tbNPSHVENTILTYPE save_tbNPSHVENTILTYPE ~
delete_tbNPSHVENTILTYPE refresh_tbNPSHVENTILTYPE filter_tbNPSHVENTILTYPE ~
excel_tbNPSHVENTILTYPE fiSearch BrwNPSHVENTILTYPE VentiltypeAktiv id ~
fabrikat ventiltype 
&Scoped-Define DISPLAYED-OBJECTS fiSearch VentiltypeAktiv id fabrikat ~
ventiltype 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.53 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.53 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.53 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.53 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.53 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.53 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.53 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPSHVENTILTYPE 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.53 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE fabrikat AS CHARACTER FORMAT "X(15)" 
     LABEL "Fabrikat" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 30 BY 1.

DEFINE VARIABLE fiSearch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE id AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Ventil id" 
     VIEW-AS FILL-IN 
     SIZE 11.75 BY 1.

DEFINE VARIABLE ventiltype AS CHARACTER FORMAT "X(20)" 
     LABEL "Ventiltype" 
     VIEW-AS FILL-IN 
     SIZE 57 BY 1.

DEFINE RECTANGLE tbNPSHVENTILTYPE
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 135 BY 1.72.

DEFINE VARIABLE VentiltypeAktiv AS LOGICAL INITIAL no 
     LABEL "Aktiv" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.38 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHVENTILTYPE FOR 
      NPSHVENTILTYPE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHVENTILTYPE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHVENTILTYPE C-Win _STRUCTURED
  QUERY BrwNPSHVENTILTYPE NO-LOCK DISPLAY
      NPSHVENTILTYPE.id COLUMN-LABEL "id" FORMAT ">>>>>>9":U WIDTH 8.4
      NPSHVENTILTYPE.fabrikat COLUMN-LABEL "Fabrikat" FORMAT "X(15)":U
      NPSHVENTILTYPE.ventiltype COLUMN-LABEL "Ventiltype" FORMAT "X(20)":U
            WIDTH 33.4
      NPSHVENTILTYPE.VentiltypeAktiv COLUMN-LABEL "VentiltypeAktiv" FORMAT "yes/no":U
            WIDTH 14
  ENABLE
      NPSHVENTILTYPE.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63 BY 10.28 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHVENTILTYPE AT ROW 1.09 COL 1.25 WIDGET-ID 10
     copy_tbNPSHVENTILTYPE AT ROW 1.09 COL 7.25 WIDGET-ID 12
     undo_tbNPSHVENTILTYPE AT ROW 1.09 COL 13.38 WIDGET-ID 14
     save_tbNPSHVENTILTYPE AT ROW 1.09 COL 19.38 WIDGET-ID 16
     delete_tbNPSHVENTILTYPE AT ROW 1.09 COL 25.63 WIDGET-ID 18
     refresh_tbNPSHVENTILTYPE AT ROW 1.09 COL 31.63 WIDGET-ID 20
     filter_tbNPSHVENTILTYPE AT ROW 1.09 COL 37.75 WIDGET-ID 22
     excel_tbNPSHVENTILTYPE AT ROW 1.09 COL 43.75 WIDGET-ID 24
     fiSearch AT ROW 3.34 COL 2 NO-LABEL
     BrwNPSHVENTILTYPE AT ROW 4.34 COL 2 WIDGET-ID 200
     VentiltypeAktiv AT ROW 4.44 COL 76 WIDGET-ID 28
     id AT ROW 5.28 COL 74 COLON-ALIGNED
     fabrikat AT ROW 6.28 COL 74 COLON-ALIGNED WIDGET-ID 26
     ventiltype AT ROW 7.28 COL 74 COLON-ALIGNED
     tbNPSHVENTILTYPE AT ROW 1 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 135.25 BY 13.63 WIDGET-ID 100.


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
         TITLE              = "Vedlikehold Ventiltype"
         HEIGHT             = 13.63
         WIDTH              = 135.25
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 135.25
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 135.25
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
/* BROWSE-TAB BrwNPSHVENTILTYPE fiSearch DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 13.62
       FRAME DEFAULT-FRAME:WIDTH            = 135.2.

/* SETTINGS FOR FILL-IN fiSearch IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbNPSHVENTILTYPE:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHVENTILTYPE
/* Query rebuild information for BROWSE BrwNPSHVENTILTYPE
     _TblList          = "norcalc.NPSHVENTILTYPE"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHVENTILTYPE.id" "id" ">>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "8.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHVENTILTYPE.fabrikat" "Fabrikat" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHVENTILTYPE.ventiltype" "Ventiltype" "X(20)" "character" ? ? ? ? ? ? no "" no no "33.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHVENTILTYPE.VentiltypeAktiv" "VentiltypeAktiv" "yes/no" "logical" ? ? ? ? ? ? no "" no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHVENTILTYPE */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Vedlikehold Ventiltype */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Vedlikehold Ventiltype */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHVENTILTYPE
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
{incl/conttrigg.i oBrwNPSHVENTILTYPE:BROWSE-HANDLE}

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
  DISPLAY fiSearch VentiltypeAktiv id fabrikat ventiltype 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHVENTILTYPE new_tbNPSHVENTILTYPE copy_tbNPSHVENTILTYPE 
         undo_tbNPSHVENTILTYPE save_tbNPSHVENTILTYPE delete_tbNPSHVENTILTYPE 
         refresh_tbNPSHVENTILTYPE filter_tbNPSHVENTILTYPE 
         excel_tbNPSHVENTILTYPE fiSearch BrwNPSHVENTILTYPE VentiltypeAktiv id 
         fabrikat ventiltype 
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

  oBrwNPSHVENTILTYPE = NEW JBoxBrowse(brwNPSHVENTILTYPE:HANDLE).
  oBrwNPSHVENTILTYPE:setSearchField(fiSearch:handle).
  oFmNPSHVENTILTYPE = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHVENTILTYPE:updateFields = 'VentiltypeAktiv,fabrikat,ventiltype'.
  oFmNPSHVENTILTYPE:displayFields = 'id'.
  oFmNPSHVENTILTYPE:BROWSE-OBJECT = oBrwNPSHVENTILTYPE.
  otbNPSHVENTILTYPE = NEW JBoxToolbar(tbNPSHVENTILTYPE:HANDLE).

  oBrwNPSHVENTILTYPE:TOOLBAR-OBJECT = otbNPSHVENTILTYPE.
  oFmNPSHVENTILTYPE:TOOLBAR-OBJECT = otbNPSHVENTILTYPE.
  assign
    fabrikat:DELIMITER = '|'
    fabrikat:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('NPFabrikat;NPFabrikatnavn;NPFabrikatKortnavn','Where true')
    .
END.
oBrwNPSHVENTILTYPE:OpenQuery().


oContainer:initResize(550,500).

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

