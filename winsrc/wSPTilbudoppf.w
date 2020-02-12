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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSPTOPP ***/
DEF VAR oBrwNPSPTOPP AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPTOPP
    FIELD id AS integer
    FIELD kriterium_1 AS character
    FIELD kriterium_2 AS character
    FIELD neste_oppf AS date
    FIELD neste_oppf_aar AS integer
    FIELD neste_oppf_uke AS integer
    FIELD notater AS character
    FIELD oppf_dato AS date
    FIELD oppf_nr AS integer
    FIELD oppf_status AS character
    FIELD oppf_uke AS integer
    FIELD tiltak AS character
    FIELD vaar_kontakt AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSPTOPP FOR TEMP-TABLE NPSPTOPP.


FUNCTION getBuffersAndFieldsBrwNPSPTOPP RETURNS CHARACTER():
  RETURN
    'NPSPTOPP'
     + ';id'
     + ';kriterium_1'
     + ';kriterium_2'
     + ';neste_oppf'
     + ';neste_oppf_aar'
     + ';neste_oppf_uke'
     + ';notater'
     + ';oppf_dato'
     + ';oppf_nr'
     + ';oppf_status'
     + ';oppf_uke'
     + ';tiltak'
     + ';vaar_kontakt'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPTOPP RETURNS CHARACTER():
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
&Scoped-define BROWSE-NAME BrwNPSPTOPP

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPTOPP

/* Definitions for BROWSE BrwNPSPTOPP                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPTOPP NPSPTOPP.id NPSPTOPP.kriterium_1 ~
NPSPTOPP.kriterium_2 NPSPTOPP.neste_oppf NPSPTOPP.neste_oppf_aar ~
NPSPTOPP.neste_oppf_uke NPSPTOPP.notater NPSPTOPP.oppf_dato ~
NPSPTOPP.oppf_nr NPSPTOPP.oppf_status NPSPTOPP.oppf_uke NPSPTOPP.tiltak ~
NPSPTOPP.vaar_kontakt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPTOPP NPSPTOPP.id 
&Scoped-define QUERY-STRING-BrwNPSPTOPP FOR EACH NPSPTOPP NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPTOPP OPEN QUERY BrwNPSPTOPP FOR EACH NPSPTOPP NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPTOPP NPSPTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPTOPP NPSPTOPP


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPTILBUD new_tbNPSPTILBUD ~
copy_tbNPSPTILBUD undo_tbNPSPTILBUD save_tbNPSPTILBUD BrwNPSPTOPP 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/documents.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/documents_disabled.gif":U
     LABEL "Kopier" 
     SIZE 7.8 BY 1.95 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON new_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_add.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_add_disabled.gif":U
     LABEL "Ny" 
     SIZE 7.8 BY 1.95 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/floppy_disk_disabled.gif":U
     LABEL "Lagre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Angre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Angre (CTRL-Z)".

DEFINE RECTANGLE tbNPSPTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 142 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPTOPP FOR 
      NPSPTOPP SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPTOPP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPTOPP C-Win _STRUCTURED
  QUERY BrwNPSPTOPP NO-LOCK DISPLAY
      NPSPTOPP.id COLUMN-LABEL "id" FORMAT ">>>>9":U
      NPSPTOPP.kriterium_1 COLUMN-LABEL "Kriterium 1" FORMAT "X(25)":U
      NPSPTOPP.kriterium_2 COLUMN-LABEL "Kriterium 2" FORMAT "X(25)":U
      NPSPTOPP.neste_oppf COLUMN-LABEL "Neste oppf." FORMAT "99.99.9999":U
      NPSPTOPP.neste_oppf_aar COLUMN-LABEL "Oppf. år" FORMAT "9999":U
      NPSPTOPP.neste_oppf_uke COLUMN-LABEL "Neste oppf.uke" FORMAT ">9":U
      NPSPTOPP.notater COLUMN-LABEL "Notater" FORMAT "X(1024)":U
      NPSPTOPP.oppf_dato COLUMN-LABEL "Oppf.dato" FORMAT "99.99.9999":U
      NPSPTOPP.oppf_nr COLUMN-LABEL "Oppf.nr." FORMAT ">>>>>>9":U
      NPSPTOPP.oppf_status COLUMN-LABEL "Status" FORMAT "X(15)":U
      NPSPTOPP.oppf_uke COLUMN-LABEL "Oppf.uke" FORMAT ">9":U
      NPSPTOPP.tiltak COLUMN-LABEL "Tiltak" FORMAT "X(15)":U
      NPSPTOPP.vaar_kontakt COLUMN-LABEL "Vår kontakt" FORMAT "X(25)":U
  ENABLE
      NPSPTOPP.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 134 BY 6.67 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSPTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 4
     copy_tbNPSPTILBUD AT ROW 1.1 COL 9.2 WIDGET-ID 6
     undo_tbNPSPTILBUD AT ROW 1.1 COL 17 WIDGET-ID 8
     save_tbNPSPTILBUD AT ROW 1.1 COL 24.8 WIDGET-ID 10
     BrwNPSPTOPP AT ROW 3.38 COL 3 WIDGET-ID 200
     tbNPSPTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 142 BY 9.71 WIDGET-ID 100.


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
         HEIGHT             = 9.71
         WIDTH              = 142
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 142
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 142
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
/* BROWSE-TAB BrwNPSPTOPP save_tbNPSPTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 9.71
       FRAME DEFAULT-FRAME:WIDTH            = 142.

ASSIGN 
       tbNPSPTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,copy;Kopier,undo;Angre,save;Lagremaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPTOPP
/* Query rebuild information for BROWSE BrwNPSPTOPP
     _TblList          = "norcalc.NPSPTOPP"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSPTOPP.id" "id" ">>>>9" "integer" ? ? ? ? ? ? yes "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSPTOPP.kriterium_1" "Kriterium 1" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSPTOPP.kriterium_2" "Kriterium 2" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSPTOPP.neste_oppf" "Neste oppf." "99.99.9999" "date" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSPTOPP.neste_oppf_aar" "Oppf. år" "9999" "integer" ? ? ? ? ? ? no "Oppgi år for neste oppfølging" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSPTOPP.neste_oppf_uke" "Neste oppf.uke" ">9" "integer" ? ? ? ? ? ? no "" no no "14.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSPTOPP.notater" "Notater" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSPTOPP.oppf_dato" "Oppf.dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSPTOPP.oppf_nr" "Oppf.nr." ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSPTOPP.oppf_status" "Status" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSPTOPP.oppf_uke" "Oppf.uke" ">9" "integer" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSPTOPP.tiltak" "Tiltak" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSPTOPP.vaar_kontakt" "Vår kontakt" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPTOPP */
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


&Scoped-define BROWSE-NAME BrwNPSPTOPP
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
{incl/conttrigg.i oBrwNPSPTOPP:BROWSE-HANDLE}

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
  ENABLE tbNPSPTILBUD new_tbNPSPTILBUD copy_tbNPSPTILBUD undo_tbNPSPTILBUD 
         save_tbNPSPTILBUD BrwNPSPTOPP 
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

  oBrwNPSPTOPP = NEW JBoxBrowse(brwNPSPTOPP:HANDLE).

  otbNPSPTILBUD = NEW JBoxToolbar(tbNPSPTILBUD:HANDLE).

  oBrwNPSPTOPP:TOOLBAR-OBJECT = otbNPSPTILBUD.
END.
oBrwNPSPTOPP:OpenQuery().


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

