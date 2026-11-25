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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHMKVS ***/
DEF VAR oBrwNPSHMKVS AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHMKVS
    FIELD kvs_id AS integer
    FIELD kvs_verdi AS decimal
    FIELD nedre_sek_kapasitet AS decimal
    FIELD ovre_sek_kapasitet AS decimal
    FIELD shunt_dimmensjon AS character
    FIELD sorteringsDimmensjon AS integer
    FIELD ventiltype AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHMKVS FOR TEMP-TABLE NPSHMKVS.


FUNCTION getBuffersAndFieldsBrwNPSHMKVS RETURNS CHARACTER():
  RETURN
    'NPSHMKVS'
     + ';kvs_id'
     + ';kvs_verdi'
     + ';nedre_sek_kapasitet'
     + ';ovre_sek_kapasitet'
     + ';shunt_dimmensjon'
     + ';sorteringsDimmensjon'
     + ';ventiltype'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHMKVS RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPSHMKVS AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPSHMKVS AS JBoxToolbar NO-UNDO.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHMKVS

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHMKVS

/* Definitions for BROWSE BrwNPSHMKVS                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHMKVS NPSHMKVS.kvs_id ~
NPSHMKVS.kvs_verdi NPSHMKVS.nedre_sek_kapasitet NPSHMKVS.ovre_sek_kapasitet ~
NPSHMKVS.shunt_dimmensjon NPSHMKVS.sorteringsDimmensjon NPSHMKVS.ventiltype 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHMKVS NPSHMKVS.kvs_id 
&Scoped-define QUERY-STRING-BrwNPSHMKVS FOR EACH NPSHMKVS NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHMKVS OPEN QUERY BrwNPSHMKVS FOR EACH NPSHMKVS NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHMKVS NPSHMKVS
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHMKVS NPSHMKVS


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHMKVS new_tbNPSHMKVS copy_tbNPSHMKVS ~
undo_tbNPSHMKVS save_tbNPSHMKVS delete_tbNPSHMKVS refresh_tbNPSHMKVS ~
filter_tbNPSHMKVS excel_tbNPSHMKVS fiSearch BrwNPSHMKVS kvs_id ventiltype ~
kvs_verdi nedre_sek_kapasitet ovre_sek_kapasitet shunt_dimmensjon ~
sorteringsDimmensjon 
&Scoped-Define DISPLAYED-OBJECTS fiSearch kvs_id ventiltype kvs_verdi ~
nedre_sek_kapasitet ovre_sek_kapasitet shunt_dimmensjon ~
sorteringsDimmensjon 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSHMKVS 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPSHMKVS 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbNPSHMKVS 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSHMKVS 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSHMKVS 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHMKVS 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSHMKVS 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPSHMKVS 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE ventiltype AS CHARACTER FORMAT "X(20)" 
     LABEL "Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 40 BY 1.

DEFINE VARIABLE fiSearch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE kvs_id AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Id" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1.

DEFINE VARIABLE kvs_verdi AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Verdi" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE nedre_sek_kapasitet AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Nedre sek. kap." 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE ovre_sek_kapasitet AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Øvre sek. kap." 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE shunt_dimmensjon AS CHARACTER FORMAT "X(3)" 
     LABEL "Dimmensjon" 
     VIEW-AS FILL-IN 
     SIZE 8.6 BY 1.

DEFINE VARIABLE sorteringsDimmensjon AS INTEGER FORMAT ">>>>>>>9" INITIAL 0 
     LABEL "Sorterings dimm." 
     VIEW-AS FILL-IN 
     SIZE 13.2 BY 1.

DEFINE RECTANGLE tbNPSHMKVS
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 132.4 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHMKVS FOR 
      NPSHMKVS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHMKVS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHMKVS C-Win _STRUCTURED
  QUERY BrwNPSHMKVS NO-LOCK DISPLAY
      NPSHMKVS.kvs_id COLUMN-LABEL "kvs_id" FORMAT ">>>>>9":U
      NPSHMKVS.kvs_verdi COLUMN-LABEL "kvs_verdi" FORMAT "->>,>>9.99":U
      NPSHMKVS.nedre_sek_kapasitet COLUMN-LABEL "nedre_sek_kapasitet" FORMAT "->>,>>9.99":U
      NPSHMKVS.ovre_sek_kapasitet COLUMN-LABEL "ovre_sek_kapasitet" FORMAT "->>,>>9.99":U
      NPSHMKVS.shunt_dimmensjon COLUMN-LABEL "Shunt-dimm." FORMAT "X(3)":U
      NPSHMKVS.sorteringsDimmensjon COLUMN-LABEL "sorteringsDimmensjon" FORMAT ">>>>>>>9":U
      NPSHMKVS.ventiltype COLUMN-LABEL "Ventiltype" FORMAT "X(20)":U
  ENABLE
      NPSHMKVS.kvs_id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 65 BY 11.24 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHMKVS AT ROW 1.1 COL 2.2 WIDGET-ID 20
     copy_tbNPSHMKVS AT ROW 1.1 COL 8.2 WIDGET-ID 22
     undo_tbNPSHMKVS AT ROW 1.1 COL 14.4 WIDGET-ID 24
     save_tbNPSHMKVS AT ROW 1.1 COL 20.4 WIDGET-ID 26
     delete_tbNPSHMKVS AT ROW 1.1 COL 26.6 WIDGET-ID 28
     refresh_tbNPSHMKVS AT ROW 1.1 COL 32.6 WIDGET-ID 30
     filter_tbNPSHMKVS AT ROW 1.1 COL 38.8 WIDGET-ID 32
     excel_tbNPSHMKVS AT ROW 1.1 COL 44.8 WIDGET-ID 34
     fiSearch AT ROW 3.14 COL 2 NO-LABEL WIDGET-ID 36
     BrwNPSHMKVS AT ROW 4.1 COL 2 WIDGET-ID 200
     kvs_id AT ROW 4.57 COL 88 COLON-ALIGNED
     ventiltype AT ROW 5.52 COL 88 COLON-ALIGNED WIDGET-ID 16
     kvs_verdi AT ROW 6.52 COL 88 COLON-ALIGNED
     nedre_sek_kapasitet AT ROW 7.52 COL 88 COLON-ALIGNED
     ovre_sek_kapasitet AT ROW 8.52 COL 88 COLON-ALIGNED
     shunt_dimmensjon AT ROW 9.52 COL 88 COLON-ALIGNED
     sorteringsDimmensjon AT ROW 10.52 COL 88 COLON-ALIGNED
     tbNPSHMKVS AT ROW 1 COL 1 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 132.4 BY 14.33 WIDGET-ID 100.


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
         WIDTH              = 132.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 154.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 154.4
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
/* BROWSE-TAB BrwNPSHMKVS fiSearch DEFAULT-FRAME */
/* SETTINGS FOR FILL-IN fiSearch IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbNPSHMKVS:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHMKVS
/* Query rebuild information for BROWSE BrwNPSHMKVS
     _TblList          = "norcalc.NPSHMKVS"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHMKVS.kvs_id" "kvs_id" ">>>>>9" "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHMKVS.kvs_verdi" "kvs_verdi" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHMKVS.nedre_sek_kapasitet" "nedre_sek_kapasitet" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHMKVS.ovre_sek_kapasitet" "ovre_sek_kapasitet" "->>,>>9.99" "decimal" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHMKVS.shunt_dimmensjon" "Shunt-dimm." "X(3)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHMKVS.sorteringsDimmensjon" "sorteringsDimmensjon" ">>>>>>>9" "integer" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHMKVS.ventiltype" "Ventiltype" "X(20)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHMKVS */
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


&Scoped-define BROWSE-NAME BrwNPSHMKVS
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
{incl/conttrigg.i oBrwNPSHMKVS:BROWSE-HANDLE}

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
  DISPLAY fiSearch kvs_id ventiltype kvs_verdi nedre_sek_kapasitet 
          ovre_sek_kapasitet shunt_dimmensjon sorteringsDimmensjon 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHMKVS new_tbNPSHMKVS copy_tbNPSHMKVS undo_tbNPSHMKVS 
         save_tbNPSHMKVS delete_tbNPSHMKVS refresh_tbNPSHMKVS filter_tbNPSHMKVS 
         excel_tbNPSHMKVS fiSearch BrwNPSHMKVS kvs_id ventiltype kvs_verdi 
         nedre_sek_kapasitet ovre_sek_kapasitet shunt_dimmensjon 
         sorteringsDimmensjon 
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

  iDetailMoveX = brwNPSHMKVS:X + brwNPSHMKVS:WIDTH-PIXELS.
  oBrwNPSHMKVS = NEW JBoxBrowse(brwNPSHMKVS:HANDLE).
  oBrwNPSHMKVS:setSearchField(fiSearch:handle).

  oFmNPSHMKVS = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHMKVS:updateFields = 'kvs_verdi,nedre_sek_kapasitet,ovre_sek_kapasitet,shunt_dimmensjon,sorteringsDimmensjon,ventiltype'.
  oFmNPSHMKVS:displayfields = 'kvs_id'.
  oFmNPSHMKVS:BROWSE-OBJECT = oBrwNPSHMKVS.
  
  assign 
    ventiltype:DELIMITER = '|' 
    ventiltype:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('NPSHVentiltype;ventiltype;ventiltype','where VentiltypeAktiv by ventiltype')
    .

  otbNPSHMKVS = NEW JBoxToolbar(tbNPSHMKVS:HANDLE).
  oBrwNPSHMKVS:TOOLBAR-OBJECT = otbNPSHMKVS.
  oFmNPSHMKVS:TOOLBAR-OBJECT = otbNPSHMKVS.
END.
oBrwNPSHMKVS:OpenQuery().


oContainer:InitResize(iDetailMoveX, 200).

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

