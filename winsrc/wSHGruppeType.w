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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHGruppeType ***/
DEF VAR oBrwNPSHGruppeType AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHGruppeType
    FIELD iNPSHGruppeTypeId AS integer
    FIELD NPSHGruppeTypeNavn AS character
    FIELD NPSHGruppeTypeBeskrivelse AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHGruppeType FOR TEMP-TABLE NPSHGruppeType.


FUNCTION getBuffersAndFieldsBrwNPSHGruppeType RETURNS CHARACTER():
  RETURN
    'NPSHGruppeType'
     + ';iNPSHGruppeTypeId'
     + ';NPSHGruppeTypeNavn'
     + ';NPSHGruppeTypeBeskrivelse'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHGruppeType RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPSHGruppeType AS JBoxFieldMap NO-UNDO.


DEF VAR otbNPSHGruppe AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHGruppeType

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHGruppeType

/* Definitions for BROWSE BrwNPSHGruppeType                             */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHGruppeType ~
NPSHGruppeType.iNPSHGruppeTypeId NPSHGruppeType.NPSHGruppeTypeNavn ~
NPSHGruppeType.NPSHGruppeTypeBeskrivelse 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHGruppeType ~
NPSHGruppeType.iNPSHGruppeTypeId 
&Scoped-define QUERY-STRING-BrwNPSHGruppeType FOR EACH NPSHGruppeType NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHGruppeType OPEN QUERY BrwNPSHGruppeType FOR EACH NPSHGruppeType NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHGruppeType NPSHGruppeType
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHGruppeType NPSHGruppeType


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHGruppe new_tbNPSHGruppe ~
copy_tbNPSHGruppe undo_tbNPSHGruppe save_tbNPSHGruppe delete_tbNPSHGruppe ~
refresh_tbNPSHGruppe excel_tbNPSHGruppe iNPSHGruppeTypeId BrwNPSHGruppeType ~
NPSHGruppeTypeNavn NPSHGruppeTypeBeskrivelse 
&Scoped-Define DISPLAYED-OBJECTS iNPSHGruppeTypeId NPSHGruppeTypeNavn ~
NPSHGruppeTypeBeskrivelse lblEditor 

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

DEFINE VARIABLE NPSHGruppeTypeBeskrivelse AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 26 BY 4.05 NO-UNDO.

DEFINE VARIABLE iNPSHGruppeTypeId AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "GruppeTypeId" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1.

DEFINE VARIABLE lblEditor AS CHARACTER FORMAT "X(256)":U INITIAL "Beskrivelse:" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE NPSHGruppeTypeNavn AS CHARACTER FORMAT "X(3)" 
     LABEL "GruppeType" 
     VIEW-AS FILL-IN 
     SIZE 8 BY 1.

DEFINE RECTANGLE tbNPSHGruppe
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 100.8 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHGruppeType FOR 
      NPSHGruppeType SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHGruppeType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHGruppeType C-Win _STRUCTURED
  QUERY BrwNPSHGruppeType NO-LOCK DISPLAY
      NPSHGruppeType.iNPSHGruppeTypeId COLUMN-LABEL "GruppeTypeId" FORMAT ">>>>>>>>9":U
      NPSHGruppeType.NPSHGruppeTypeNavn COLUMN-LABEL "GruppeType" FORMAT "X(3)":U
      NPSHGruppeType.NPSHGruppeTypeBeskrivelse COLUMN-LABEL "Beskrivelse" FORMAT "x(255)":U
            WIDTH 255
  ENABLE
      NPSHGruppeType.iNPSHGruppeTypeId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 57 BY 10.19 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHGruppe AT ROW 1.1 COL 1.2 WIDGET-ID 4
     copy_tbNPSHGruppe AT ROW 1.1 COL 7.2 WIDGET-ID 6
     undo_tbNPSHGruppe AT ROW 1.1 COL 13.4 WIDGET-ID 8
     save_tbNPSHGruppe AT ROW 1.1 COL 19.4 WIDGET-ID 10
     delete_tbNPSHGruppe AT ROW 1.1 COL 25.6 WIDGET-ID 12
     refresh_tbNPSHGruppe AT ROW 1.1 COL 31.6 WIDGET-ID 14
     excel_tbNPSHGruppe AT ROW 1.1 COL 37.8 WIDGET-ID 16
     iNPSHGruppeTypeId AT ROW 3 COL 73 COLON-ALIGNED
     BrwNPSHGruppeType AT ROW 3.14 COL 2 WIDGET-ID 200
     NPSHGruppeTypeNavn AT ROW 4 COL 73 COLON-ALIGNED
     NPSHGruppeTypeBeskrivelse AT ROW 5.05 COL 75 NO-LABEL WIDGET-ID 22
     lblEditor AT ROW 5.05 COL 61 COLON-ALIGNED NO-LABEL
     tbNPSHGruppe AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 101.8 BY 12.33 WIDGET-ID 100.


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
         TITLE              = "Vedlikehold gruppetype"
         HEIGHT             = 12.33
         WIDTH              = 101.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 114.2
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
/* BROWSE-TAB BrwNPSHGruppeType iNPSHGruppeTypeId DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 12.33
       FRAME DEFAULT-FRAME:WIDTH            = 101.8.

/* SETTINGS FOR FILL-IN lblEditor IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       lblEditor:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Beskrivelse:".

ASSIGN 
       tbNPSHGruppe:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHGruppeType
/* Query rebuild information for BROWSE BrwNPSHGruppeType
     _TblList          = "norcalc.NPSHGruppeType"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHGruppeType.iNPSHGruppeTypeId" "GruppeTypeId" ">>>>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "13.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHGruppeType.NPSHGruppeTypeNavn" "GruppeType" "X(3)" "character" ? ? ? ? ? ? no "" no no "11.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHGruppeType.NPSHGruppeTypeBeskrivelse" "Beskrivelse" "x(255)" "character" ? ? ? ? ? ? no "" no no "255" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHGruppeType */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Vedlikehold gruppetype */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Vedlikehold gruppetype */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHGruppeType
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
{incl/conttrigg.i oBrwNPSHGruppeType:BROWSE-HANDLE}

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
  DISPLAY iNPSHGruppeTypeId NPSHGruppeTypeNavn NPSHGruppeTypeBeskrivelse 
          lblEditor 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHGruppe new_tbNPSHGruppe copy_tbNPSHGruppe undo_tbNPSHGruppe 
         save_tbNPSHGruppe delete_tbNPSHGruppe refresh_tbNPSHGruppe 
         excel_tbNPSHGruppe iNPSHGruppeTypeId BrwNPSHGruppeType 
         NPSHGruppeTypeNavn NPSHGruppeTypeBeskrivelse 
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

  oBrwNPSHGruppeType = NEW JBoxBrowse(brwNPSHGruppeType:HANDLE).

  oFmNPSHGruppeType = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHGruppeType:updateFields = 'NPSHGruppeTypeNavn,NPSHGruppeTypeBeskrivelse'.
  oFmNPSHGruppeType:displayFields = 'iNPSHGruppeTypeId'.
  oFmNPSHGruppeType:BROWSE-OBJECT = oBrwNPSHGruppeType.
  
  otbNPSHGruppe = NEW JBoxToolbar(tbNPSHGruppe:HANDLE).

  oBrwNPSHGruppeType:TOOLBAR-OBJECT = otbNPSHGruppe.
  oFmNPSHGruppeType:TOOLBAR-OBJECT = otbNPSHGruppe.
END.
oBrwNPSHGruppeType:OpenQuery().
oContainer:setNoResizeX('NPSHGruppeTypeBeskrivelse').

oContainer:initResize(200,400).

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

