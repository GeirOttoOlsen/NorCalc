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


/*** Start instance property definitions for JBoxBrowse object oBrwLand ***/
DEF VAR oBrwLand AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE Land
    FIELD cLandKode AS character
    FIELD cLand AS character
    FIELD iCountryNum AS integer
    FIELD cCountry AS character
    FIELD cCreatedBy AS character
    FIELD cIso3Char AS character
    FIELD cValKode AS character
    FIELD dCreated AS date
    FIELD iSortering AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_Land FOR TEMP-TABLE Land.


FUNCTION getBuffersAndFieldsBrwLand RETURNS CHARACTER():
  RETURN
    'Land'
     + ';cLandKode'
     + ';cLand'
     + ';iCountryNum'
     + ';cCountry'
     + ';cCreatedBy'
     + ';cIso3Char'
     + ';cValKode'
     + ';dCreated'
     + ';iSortering'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwLand RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmLand AS JBoxFieldMap NO-UNDO.
DEF VAR otbPostNummer AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define WIDGETID-FILE-NAME 

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwLand

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Land

/* Definitions for BROWSE BrwLand                                       */
&Scoped-define FIELDS-IN-QUERY-BrwLand Land.cLandKode Land.cLand ~
Land.iCountryNum Land.cCountry Land.cCreatedBy Land.cIso3Char Land.cValKode ~
Land.dCreated Land.iSortering 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwLand Land.cLandKode 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwLand Land
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwLand Land
&Scoped-define QUERY-STRING-BrwLand FOR EACH Land NO-LOCK, INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwLand OPEN QUERY BrwLand FOR EACH Land NO-LOCK, INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwLand Land
&Scoped-define FIRST-TABLE-IN-QUERY-BrwLand Land


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbPostNummer new_tbPostNummer ~
copy_tbPostNummer undo_tbPostNummer save_tbPostNummer delete_tbPostNummer ~
refresh_tbPostNummer filter_tbPostNummer excel_tbPostNummer BrwLand ~
cLandKode iSortering cLand cCountry cIso3Char cValKode iCountryNum 
&Scoped-Define DISPLAYED-OBJECTS cLandKode iSortering cLand cCountry ~
cIso3Char cValKode iCountryNum 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbPostNummer 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbPostNummer 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbPostNummer 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbPostNummer 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbPostNummer 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbPostNummer 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbPostNummer 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbPostNummer 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE cCountry AS CHARACTER FORMAT "x(40)" 
     LABEL "Country" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1.

DEFINE VARIABLE cIso3Char AS CHARACTER FORMAT "xxx" 
     LABEL "3-char iso" 
     VIEW-AS FILL-IN 
     SIZE 8.6 BY 1.

DEFINE VARIABLE cLand AS CHARACTER FORMAT "x(40)" 
     LABEL "Land" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1.

DEFINE VARIABLE cLandKode AS CHARACTER FORMAT "xx" 
     LABEL "Landkode" 
     VIEW-AS FILL-IN 
     SIZE 6.4 BY 1.

DEFINE VARIABLE cValKode AS CHARACTER FORMAT "x(3)" 
     LABEL "Valutakode" 
     VIEW-AS FILL-IN 
     SIZE 8.6 BY 1.

DEFINE VARIABLE iCountryNum AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Country num" 
     VIEW-AS FILL-IN 
     SIZE 6.2 BY 1.

DEFINE VARIABLE iSortering AS INTEGER FORMAT "->>9" INITIAL 0 
     LABEL "Sortering" 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1.

DEFINE RECTANGLE tbPostNummer
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 128 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwLand FOR 
      Land SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwLand
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwLand C-Win _STRUCTURED
  QUERY BrwLand NO-LOCK DISPLAY
      Land.cLandKode FORMAT "xx":U
      Land.cLand FORMAT "x(40)":U
      Land.iCountryNum FORMAT ">>9":U
      Land.cCountry FORMAT "x(40)":U
      Land.cCreatedBy FORMAT "x(8)":U
      Land.cIso3Char FORMAT "xxx":U
      Land.cValKode FORMAT "x(3)":U
      Land.dCreated FORMAT "99/99/9999":U
      Land.iSortering FORMAT "->>9":U
  ENABLE
      Land.cLandKode
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63 BY 12.33 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbPostNummer AT ROW 1.1 COL 1.2 WIDGET-ID 18
     copy_tbPostNummer AT ROW 1.1 COL 7.2 WIDGET-ID 20
     undo_tbPostNummer AT ROW 1.1 COL 13.4 WIDGET-ID 22
     save_tbPostNummer AT ROW 1.1 COL 19.4 WIDGET-ID 24
     delete_tbPostNummer AT ROW 1.1 COL 25.6 WIDGET-ID 26
     refresh_tbPostNummer AT ROW 1.1 COL 31.6 WIDGET-ID 28
     filter_tbPostNummer AT ROW 1.1 COL 37.8 WIDGET-ID 30
     excel_tbPostNummer AT ROW 1.1 COL 43.8 WIDGET-ID 32
     BrwLand AT ROW 2.91 COL 1 WIDGET-ID 200
     cLandKode AT ROW 3.1 COL 81 COLON-ALIGNED WIDGET-ID 8
     iSortering AT ROW 3.1 COL 98 COLON-ALIGNED WIDGET-ID 14
     cLand AT ROW 4.1 COL 81 COLON-ALIGNED WIDGET-ID 6
     cCountry AT ROW 5.1 COL 81 COLON-ALIGNED WIDGET-ID 2
     cIso3Char AT ROW 6.1 COL 81 COLON-ALIGNED WIDGET-ID 4
     cValKode AT ROW 7.1 COL 81 COLON-ALIGNED WIDGET-ID 10
     iCountryNum AT ROW 8.1 COL 81 COLON-ALIGNED WIDGET-ID 12
     tbPostNummer AT ROW 1 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 129 BY 14.24 WIDGET-ID 100.


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
         HEIGHT             = 14.24
         WIDTH              = 129
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 129
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 129
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
/* BROWSE-TAB BrwLand excel_tbPostNummer DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 14.24
       FRAME DEFAULT-FRAME:WIDTH            = 129.

ASSIGN 
       tbPostNummer:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwLand
/* Query rebuild information for BROWSE BrwLand
     _TblList          = "norcalc.Land"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > Land.cLandKode
"Land.cLandKode" "Landkode" "xx" "character" ? ? ? ? ? ? yes "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > Land.cLand
"Land.cLand" "Land" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > Land.iCountryNum
"Land.iCountryNum" "Country num" ">>9" "integer" ? ? ? ? ? ? no "" no no "11.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > Land.cCountry
"Land.cCountry" "Country" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > Land.cCreatedBy
"Land.cCreatedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > Land.cIso3Char
"Land.cIso3Char" "3-char iso" "xxx" "character" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > Land.cValKode
"Land.cValKode" "Valutakode" "x(3)" "character" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > Land.dCreated
"Land.dCreated" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > Land.iSortering
"Land.iSortering" "Sortering" "->>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwLand */
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


&Scoped-define BROWSE-NAME BrwLand
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
{incl/conttrigg.i oBrwLand:BROWSE-HANDLE}

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
  DISPLAY cLandKode iSortering cLand cCountry cIso3Char cValKode iCountryNum 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbPostNummer new_tbPostNummer copy_tbPostNummer undo_tbPostNummer 
         save_tbPostNummer delete_tbPostNummer refresh_tbPostNummer 
         filter_tbPostNummer excel_tbPostNummer BrwLand cLandKode iSortering 
         cLand cCountry cIso3Char cValKode iCountryNum 
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

  iDetailMoveX = brwLand:X + brwLand:WIDTH-PIXELS.
  oBrwLand = NEW JBoxBrowse(brwLand:HANDLE).
  oBrwLand:CreateGridFilter("").

  oFmLand = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmLand:updateFields = 'cLandKode,cLand,cCountry,cIso3Char,cValKode,iCountryNum,iSortering'.
  oFmLand:primaryKeyFields = 'cLandKode'.

  oFmLand:BROWSE-OBJECT = oBrwLand.
  otbPostNummer = NEW JBoxToolbar(tbPostNummer:HANDLE).
  oBrwLand:TOOLBAR-OBJECT = otbPostNummer.
  oFmLand:TOOLBAR-OBJECT = otbPostNummer.
END.
oBrwLand:OpenQuery().


oContainer:initResize(iDetailMoveX, 200).

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

