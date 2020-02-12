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


/*** Start instance property definitions for JBoxBrowse object oBrwKommune ***/
DEF VAR oBrwKommune AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE Kommune
    FIELD Kommunekode AS character
    FIELD KommuneNavn AS character
    FIELD DistriktKode AS character
    FIELD DistriktKode2 AS character
    FIELD DistriktNavn AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_Kommune FOR TEMP-TABLE Kommune.


FUNCTION getBuffersAndFieldsBrwKommune RETURNS CHARACTER():
  RETURN
    'Kommune'
     + ';Kommunekode'
     + ';KommuneNavn'
     + ';DistriktKode'
  + ',Distrikt'
     + ';DistriktKode'
     + ';DistriktNavn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwKommune RETURNS CHARACTER():
  RETURN 'FIRST Distrikt OF Kommune NO-LOCK'.
END FUNCTION.
DEF VAR oFmKommune AS JBoxFieldMap NO-UNDO.
DEF VAR otbKommune AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwKommune

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Kommune

/* Definitions for BROWSE BrwKommune                                    */
&Scoped-define FIELDS-IN-QUERY-BrwKommune Kommune.Kommunekode ~
Kommune.KommuneNavn Kommune.DistriktKode Kommune.DistriktKode ~
Kommune.DistriktNavn 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwKommune Kommune.Kommunekode 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwKommune Kommune
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwKommune Kommune
&Scoped-define QUERY-STRING-BrwKommune FOR EACH Kommune NO-LOCK, ~
    FIRST Distrikt OF Kommune NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwKommune OPEN QUERY BrwKommune FOR EACH Kommune NO-LOCK, ~
    FIRST Distrikt OF Kommune NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwKommune Kommune
&Scoped-define FIRST-TABLE-IN-QUERY-BrwKommune Kommune


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbKommune new_tbKommune copy_tbKommune ~
undo_tbKommune save_tbKommune delete_tbKommune refresh_tbKommune ~
filter_tbKommune excel_tbKommune BrwKommune Kommunekode KommuneNavn ~
DistriktKode 
&Scoped-Define DISPLAYED-OBJECTS Kommunekode KommuneNavn DistriktKode 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbKommune 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbKommune 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbKommune 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbKommune 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbKommune 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbKommune 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbKommune 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbKommune 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE DistriktKode AS CHARACTER FORMAT "X(8)" 
     LABEL "Distrikt kode" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 35 BY 1.

DEFINE VARIABLE Kommunekode AS CHARACTER FORMAT "x(5)" 
     LABEL "Kode" 
     VIEW-AS FILL-IN 
     SIZE 18.8 BY 1.

DEFINE VARIABLE KommuneNavn AS CHARACTER FORMAT "x(40)" 
     LABEL "Kommune" 
     VIEW-AS FILL-IN 
     SIZE 35.2 BY 1.

DEFINE RECTANGLE tbKommune
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 116.6 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwKommune FOR 
      Kommune SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwKommune
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwKommune C-Win _STRUCTURED
  QUERY BrwKommune NO-LOCK DISPLAY
      Kommune.Kommunekode COLUMN-LABEL "Kommunekode" FORMAT "x(5)":U
      Kommune.KommuneNavn COLUMN-LABEL "Kommune" FORMAT "x(40)":U
      Kommune.DistriktKode COLUMN-LABEL "Distrikt kode" FORMAT "X(8)":U
      Kommune.DistriktKode COLUMN-LABEL "Distrikt kode" FORMAT "X(8)":U
      Kommune.DistriktNavn COLUMN-LABEL "Distrikt" FORMAT "x(80)":U
  ENABLE
      Kommune.Kommunekode
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 57 BY 12.29 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbKommune AT ROW 1.1 COL 1.2 WIDGET-ID 10
     copy_tbKommune AT ROW 1.1 COL 7.2 WIDGET-ID 12
     undo_tbKommune AT ROW 1.1 COL 13.4 WIDGET-ID 14
     save_tbKommune AT ROW 1.1 COL 19.4 WIDGET-ID 16
     delete_tbKommune AT ROW 1.1 COL 25.6 WIDGET-ID 18
     refresh_tbKommune AT ROW 1.1 COL 31.6 WIDGET-ID 20
     filter_tbKommune AT ROW 1.1 COL 37.8 WIDGET-ID 22
     excel_tbKommune AT ROW 1.1 COL 43.8 WIDGET-ID 24
     BrwKommune AT ROW 2.91 COL 2 WIDGET-ID 200
     Kommunekode AT ROW 3.38 COL 77 COLON-ALIGNED
     KommuneNavn AT ROW 4.38 COL 77 COLON-ALIGNED
     DistriktKode AT ROW 5.38 COL 77 COLON-ALIGNED WIDGET-ID 26
     tbKommune AT ROW 1 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 117.6 BY 14.19 WIDGET-ID 100.


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
         HEIGHT             = 14.19
         WIDTH              = 117.6
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 117.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 117.6
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
/* BROWSE-TAB BrwKommune excel_tbKommune DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 14.19
       FRAME DEFAULT-FRAME:WIDTH            = 117.6.

ASSIGN 
       Kommune.DistriktKode:VISIBLE IN BROWSE BrwKommune = FALSE.

ASSIGN 
       tbKommune:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwKommune
/* Query rebuild information for BROWSE BrwKommune
     _TblList          = "norcalc.Kommune"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST"
     _FldNameList[1]   > Kommune.Kommunekode
"Kommune.Kommunekode" "Kommunekode" "x(5)" "character" ? ? ? ? ? ? yes "" no no "14.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Kommune.KommuneNavn
"Kommune.KommuneNavn" "Kommune" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Kommune.DistriktKode
"Kommune.DistriktKode" "Distrikt kode" "X(8)" "character" ? ? ? ? ? ? no "" no no "11.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Kommune.DistriktKode
"Kommune.DistriktKode" "Distrikt kode" "X(8)" "character" ? ? ? ? ? ? no "" no no "11.8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Kommune.DistriktNavn
"Kommune.DistriktNavn" "Distrikt" "x(80)" "character" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwKommune */
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


&Scoped-define BROWSE-NAME BrwKommune
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
{incl/conttrigg.i oBrwKommune:BROWSE-HANDLE}

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
  DISPLAY Kommunekode KommuneNavn DistriktKode 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbKommune new_tbKommune copy_tbKommune undo_tbKommune save_tbKommune 
         delete_tbKommune refresh_tbKommune filter_tbKommune excel_tbKommune 
         BrwKommune Kommunekode KommuneNavn DistriktKode 
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

  oBrwKommune = NEW JBoxBrowse(brwKommune:HANDLE).

  oFmKommune = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmKommune:updateFields = 'Kommunekode,KommuneNavn,DistriktKode'.
  oFmKommune:primaryKeyFields = 'Kommunekode'.

  oFmKommune:BROWSE-OBJECT = oBrwKommune.
  otbKommune = NEW JBoxToolbar(tbKommune:HANDLE).

  oBrwKommune:TOOLBAR-OBJECT = otbKommune.
  oFmKommune:TOOLBAR-OBJECT = otbKommune.
  assign 
    DistriktKode:DELIMITER = '|'
    DistriktKode:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('Distrikt;DistriktNavn;DistriktKode','where true')
    .
END.
oBrwKommune:OpenQuery().


oContainer:initResize(300,200).

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

