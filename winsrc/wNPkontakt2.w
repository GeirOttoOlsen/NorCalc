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


/*** Start instance property definitions for JBoxBrowse object oBrwNPKONTAKT ***/
DEF VAR oBrwNPKONTAKT AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPKONTAKT
    FIELD id AS integer
    FIELD kontaktperson AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPKONTAKT FOR TEMP-TABLE NPKONTAKT.


FUNCTION getBuffersAndFieldsBrwNPKONTAKT RETURNS CHARACTER():
  RETURN
    'NPKONTAKT'
     + ';id'
     + ';kontaktperson'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPKONTAKT RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPKONTAKT AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPKONTAKT

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKONTAKT

/* Definitions for BROWSE BrwNPKONTAKT                                  */
&Scoped-define FIELDS-IN-QUERY-BrwNPKONTAKT NPKONTAKT.id ~
NPKONTAKT.kontaktperson 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPKONTAKT NPKONTAKT.id 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPKONTAKT NPKONTAKT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPKONTAKT NPKONTAKT
&Scoped-define QUERY-STRING-BrwNPKONTAKT FOR EACH NPKONTAKT NO-LOCK, INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPKONTAKT OPEN QUERY BrwNPKONTAKT FOR EACH NPKONTAKT NO-LOCK, INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPKONTAKT NPKONTAKT
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPKONTAKT NPKONTAKT


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPKONTAKT new_tbNPKONTAKT copy_tbNPKONTAKT ~
undo_tbNPKONTAKT save_tbNPKONTAKT delete_tbNPKONTAKT refresh_tbNPKONTAKT ~
filter_tbNPKONTAKT browseconfig_tbNPKONTAKT excel_tbNPKONTAKT BrwNPKONTAKT ~
Id kontaktnavn 
&Scoped-Define DISPLAYED-OBJECTS Id kontaktnavn 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/table.bmp":U
     LABEL "Column setup" 
     SIZE 6 BY 1.53 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON copy_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 6 BY 1.53 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 6 BY 1.53 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON excel_tbNPKONTAKT 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.53 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNPKONTAKT 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.53 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 6 BY 1.53 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON refresh_tbNPKONTAKT 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.53 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 6 BY 1.53 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPKONTAKT 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 6 BY 1.53 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE Id AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "KontaktId" 
     VIEW-AS FILL-IN 
     SIZE 7.75 BY 1.

DEFINE VARIABLE kontaktnavn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Kontakt" 
     VIEW-AS FILL-IN 
     SIZE 35 BY 1 NO-UNDO.

DEFINE RECTANGLE tbNPKONTAKT
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 117.38 BY 1.72.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPKONTAKT FOR 
      NPKONTAKT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPKONTAKT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPKONTAKT C-Win _STRUCTURED
  QUERY BrwNPKONTAKT NO-LOCK DISPLAY
      NPKONTAKT.id FORMAT ">>>9":U
      NPKONTAKT.kontaktperson FORMAT "X(25)":U
  ENABLE
      NPKONTAKT.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 42 BY 11.63 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPKONTAKT AT ROW 1.09 COL 2.13 WIDGET-ID 32
     copy_tbNPKONTAKT AT ROW 1.09 COL 8.25 WIDGET-ID 34
     undo_tbNPKONTAKT AT ROW 1.09 COL 14.25 WIDGET-ID 36
     save_tbNPKONTAKT AT ROW 1.09 COL 20.38 WIDGET-ID 38
     delete_tbNPKONTAKT AT ROW 1.09 COL 26.5 WIDGET-ID 40
     refresh_tbNPKONTAKT AT ROW 1.09 COL 32.63 WIDGET-ID 42
     filter_tbNPKONTAKT AT ROW 1.09 COL 38.75 WIDGET-ID 44
     browseconfig_tbNPKONTAKT AT ROW 1.09 COL 44.75 WIDGET-ID 46
     excel_tbNPKONTAKT AT ROW 1.09 COL 50.88 WIDGET-ID 48
     BrwNPKONTAKT AT ROW 3.25 COL 1 WIDGET-ID 200
     Id AT ROW 3.25 COL 61 COLON-ALIGNED
     kontaktnavn AT ROW 4.25 COL 61 COLON-ALIGNED WIDGET-ID 50
     tbNPKONTAKT AT ROW 1 COL 2 WIDGET-ID 30
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 119.5 BY 14.22 WIDGET-ID 100.


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
         HEIGHT             = 14.22
         WIDTH              = 119.5
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 119.5
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 119.5
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
&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
  IF C-Win = ? THEN
    CREATE FRAME C-Win
           ASSIGN HIDDEN = YES.
&ENDIF

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
/* BROWSE-TAB BrwNPKONTAKT excel_tbNPKONTAKT DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 14.22
       FRAME DEFAULT-FRAME:WIDTH            = 119.5.

ASSIGN 
       tbNPKONTAKT:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,copy;Kopier,undo;Angre,save;Lagre,delete;Slett,refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPKONTAKT
/* Query rebuild information for BROWSE BrwNPKONTAKT
     _TblList          = "norcalc.NPKONTAKT"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPKONTAKT.id
"NPKONTAKT.id" "id" ">>>9" "integer" ? ? ? ? ? ? yes "" no no "4.5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPKONTAKT.kontaktperson
"NPKONTAKT.kontaktperson" "kontaktperson" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPKONTAKT */
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


&Scoped-define BROWSE-NAME BrwNPKONTAKT
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
&ENDIF

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPKONTAKT:BROWSE-HANDLE}
&ENDIF

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
  DISPLAY Id kontaktnavn 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPKONTAKT new_tbNPKONTAKT copy_tbNPKONTAKT undo_tbNPKONTAKT 
         save_tbNPKONTAKT delete_tbNPKONTAKT refresh_tbNPKONTAKT 
         filter_tbNPKONTAKT browseconfig_tbNPKONTAKT excel_tbNPKONTAKT 
         BrwNPKONTAKT Id kontaktnavn 
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
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
  oBrwNPKONTAKT = NEW JBoxBrowse(brwNPKONTAKT:HANDLE).

  oFmNPKONTAKT = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPKONTAKT:updateFields = 'Id,kontaktnavn'.

  oFmNPKONTAKT:BROWSE-OBJECT = oBrwNPKONTAKT.
  NorcalcBrowseWindow:ConnectToolbar(THIS-PROCEDURE, tbNPKONTAKT:HANDLE, oBrwNPKONTAKT, oFmNPKONTAKT).
END.
oBrwNPKONTAKT:OpenQuery().

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize(460,500).
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

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

