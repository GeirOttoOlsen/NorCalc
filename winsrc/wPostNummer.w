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


/*** Start instance property definitions for JBoxBrowse object oBrwPostNummer ***/
DEF VAR oBrwPostNummer AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE PostNummer
    FIELD cPostnr AS character
    FIELD cPoststed AS character
    FIELD cLandKode AS character
    FIELD PostnummerKategoriKode AS character
    FIELD PostnummerKategori AS character
    FIELD Kommunekode AS character
    FIELD KommuneNavn AS character
    FIELD DistriktNavn AS character
    FIELD cLand AS character
    FIELD Latitude AS character
    FIELD Longitude AS character
    FIELD bActive AS logical
    FIELD cValKode AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowIdent4 AS CHARACTER 
    FIELD RowIdent5 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3 RowIdent4 RowIdent5
    .
DEF BUFFER v_PostNummer FOR TEMP-TABLE PostNummer.


FUNCTION getBuffersAndFieldsBrwPostNummer RETURNS CHARACTER():
  RETURN
    'PostNummer'
     + ';cPostnr'
     + ';cPoststed'
     + ';cLandKode'
     + ';PostnummerKategoriKode'
     + ';Kommunekode'
     + ';Latitude'
     + ';Longitude'
     + ';bActive'
  + ',PostnummerKategori'
     + ';PostnummerKategori'
  + ',Land'
     + ';cLand'
     + ';cValKode'
  + ',Kommune'
     + ';KommuneNavn'
  + ',Distrikt'
     + ';DistriktNavn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwPostNummer RETURNS CHARACTER():
  RETURN 'FIRST PostnummerKategori OF PostNummer OUTER-JOIN NO-LOCK,FIRST Land OF PostNummer OUTER-JOIN NO-LOCK,FIRST Kommune OF PostNummer OUTER-JOIN NO-LOCK,FIRST Distrikt OF Kommune OUTER-JOIN NO-LOCK'.
END FUNCTION.
DEF VAR oFmPostNummer AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwPostNummer

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PostNummer

/* Definitions for BROWSE BrwPostNummer                                 */
&Scoped-define FIELDS-IN-QUERY-BrwPostNummer PostNummer.cPostnr ~
PostNummer.cPoststed PostNummer.cLandKode PostNummer.PostnummerKategoriKode ~
PostNummer.PostnummerKategori PostNummer.Kommunekode PostNummer.KommuneNavn ~
PostNummer.DistriktNavn PostNummer.cLand PostNummer.Latitude ~
PostNummer.Longitude PostNummer.bActive PostNummer.cValKode 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwPostNummer PostNummer.cPostnr 
&Scoped-define QUERY-STRING-BrwPostNummer FOR EACH PostNummer NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwPostNummer OPEN QUERY BrwPostNummer FOR EACH PostNummer NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwPostNummer PostNummer
&Scoped-define FIRST-TABLE-IN-QUERY-BrwPostNummer PostNummer


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbPostNummer new_tbPostNummer ~
copy_tbPostNummer undo_tbPostNummer save_tbPostNummer delete_tbPostNummer ~
refresh_tbPostNummer filter_tbPostNummer excel_tbPostNummer BrwPostNummer ~
cPostnr bActive cPoststed Kommunekode btnKommunekode Kommunenavn ~
DistriktNavn PostnummerKategoriKode cLandKode 
&Scoped-Define DISPLAYED-OBJECTS cPostnr bActive cPoststed Kommunekode ~
Kommunenavn DistriktNavn PostnummerKategoriKode cLandKode 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnKommunekode 
     LABEL "..." 
     SIZE 4 BY 1.

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

DEFINE VARIABLE cLandKode AS CHARACTER FORMAT "xx" 
     LABEL "Land" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE PostnummerKategoriKode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Kategori" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE cPostnr AS CHARACTER FORMAT "x(8)" 
     LABEL "Postnr." 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE cPoststed AS CHARACTER FORMAT "x(35)" 
     LABEL "Poststed" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1.

DEFINE VARIABLE DistriktNavn AS CHARACTER FORMAT "x(80)" 
     LABEL "Fylke" 
     VIEW-AS FILL-IN 
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE Kommunekode AS CHARACTER FORMAT "X(256)":U 
     LABEL "Kommune" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE Kommunenavn AS CHARACTER FORMAT "x(100)":U 
     VIEW-AS FILL-IN 
     SIZE 25 BY 1 NO-UNDO.

DEFINE RECTANGLE tbPostNummer
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 139 BY 1.71.

DEFINE VARIABLE bActive AS LOGICAL INITIAL no 
     LABEL "Aktiv" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwPostNummer FOR 
      PostNummer SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwPostNummer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwPostNummer C-Win _STRUCTURED
  QUERY BrwPostNummer NO-LOCK DISPLAY
      PostNummer.cPostnr COLUMN-LABEL "Postnr." FORMAT "x(8)":U
      PostNummer.cPoststed COLUMN-LABEL "Poststed" FORMAT "x(35)":U
      PostNummer.cLandKode COLUMN-LABEL "Landkode" FORMAT "xx":U
      PostNummer.PostnummerKategoriKode COLUMN-LABEL "Kategori kode" FORMAT "X":U
      PostNummer.PostnummerKategori COLUMN-LABEL "Kategori" FORMAT "x(80)":U
      PostNummer.Kommunekode COLUMN-LABEL "Kommunekode" FORMAT "x(5)":U
      PostNummer.KommuneNavn COLUMN-LABEL "Kommune" FORMAT "x(40)":U
      PostNummer.DistriktNavn COLUMN-LABEL "Distrikt" FORMAT "x(80)":U
      PostNummer.cLand COLUMN-LABEL "Land" FORMAT "x(40)":U
      PostNummer.Latitude COLUMN-LABEL "Latitude" FORMAT "x(20)":U
      PostNummer.Longitude COLUMN-LABEL "Longitude" FORMAT "x(20)":U
      PostNummer.bActive COLUMN-LABEL "Aktiv" FORMAT "ja/nei":U
      PostNummer.cValKode COLUMN-LABEL "Valutakode" FORMAT "x(3)":U
  ENABLE
      PostNummer.cPostnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 64 BY 12.38 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbPostNummer AT ROW 1.1 COL 1.2 WIDGET-ID 12
     copy_tbPostNummer AT ROW 1.1 COL 7.2 WIDGET-ID 14
     undo_tbPostNummer AT ROW 1.1 COL 13.4 WIDGET-ID 16
     save_tbPostNummer AT ROW 1.1 COL 19.4 WIDGET-ID 18
     delete_tbPostNummer AT ROW 1.1 COL 25.6 WIDGET-ID 20
     refresh_tbPostNummer AT ROW 1.1 COL 31.6 WIDGET-ID 22
     filter_tbPostNummer AT ROW 1.1 COL 37.8 WIDGET-ID 24
     excel_tbPostNummer AT ROW 1.1 COL 43.8 WIDGET-ID 26
     BrwPostNummer AT ROW 2.67 COL 1 WIDGET-ID 200
     cPostnr AT ROW 2.91 COL 93 COLON-ALIGNED
     bActive AT ROW 2.91 COL 113 WIDGET-ID 40
     cPoststed AT ROW 3.91 COL 93 COLON-ALIGNED
     Kommunekode AT ROW 4.91 COL 93 COLON-ALIGNED
     btnKommunekode AT ROW 4.91 COL 109 WIDGET-ID 32 NO-TAB-STOP 
     Kommunenavn AT ROW 4.91 COL 111 COLON-ALIGNED NO-LABEL
     DistriktNavn AT ROW 5.91 COL 93 COLON-ALIGNED
     PostnummerKategoriKode AT ROW 6.95 COL 93 COLON-ALIGNED WIDGET-ID 36
     cLandKode AT ROW 8.05 COL 93 COLON-ALIGNED WIDGET-ID 30
     tbPostNummer AT ROW 1 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 139.4 BY 14.05 WIDGET-ID 100.


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
         HEIGHT             = 14.05
         WIDTH              = 139.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 139.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 139.4
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
/* BROWSE-TAB BrwPostNummer excel_tbPostNummer DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 14.05
       FRAME DEFAULT-FRAME:WIDTH            = 139.4.

ASSIGN 
       PostNummer.Latitude:VISIBLE IN BROWSE BrwPostNummer = FALSE
       PostNummer.Longitude:VISIBLE IN BROWSE BrwPostNummer = FALSE
       PostNummer.bActive:VISIBLE IN BROWSE BrwPostNummer = FALSE.

ASSIGN 
       tbPostNummer:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwPostNummer
/* Query rebuild information for BROWSE BrwPostNummer
     _TblList          = "norcalc.PostNummer"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER, FIRST OUTER, FIRST OUTER, FIRST OUTER"
     _FldNameList[1]   > "_<CALC>"
"PostNummer.cPostnr" "Postnr." "x(8)" "character" ? ? ? ? ? ? yes "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"PostNummer.cPoststed" "Poststed" "x(35)" "character" ? ? ? ? ? ? no "" no no "35" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"PostNummer.cLandKode" "Landkode" "xx" "character" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"PostNummer.PostnummerKategoriKode" "Kategori kode" "X" "character" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"PostNummer.PostnummerKategori" "Kategori" "x(80)" "character" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"PostNummer.Kommunekode" "Kommunekode" "x(5)" "character" ? ? ? ? ? ? no "" no no "14.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"PostNummer.KommuneNavn" "Kommune" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"PostNummer.DistriktNavn" "Distrikt" "x(80)" "character" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"PostNummer.cLand" "Land" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"PostNummer.Latitude" "Latitude" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"PostNummer.Longitude" "Longitude" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"PostNummer.bActive" "Aktiv" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"PostNummer.cValKode" "Valutakode" "x(3)" "character" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwPostNummer */
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


&Scoped-define SELF-NAME btnKommunekode
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnKommunekode C-Win
ON CHOOSE OF btnKommunekode IN FRAME DEFAULT-FRAME /* ... */
DO:
  /* To manipulate the lookup query object add the callback procedure hook "myLookupObject" 
     (probably use "WHERE false" as the initial query in this case) */
  
  JBoxServerAPI:Instance:Lookup("Kommune"
                    + ";Kommunekode"
                    + ";Kommunenavn"
                   ,"WHERE true"
                   ,"Kommunekode,Kommunenavn"   /* <- return values for these fields */
                    ).

  IF JBoxServerAPI:Instance:LookupOk THEN DO:
    ASSIGN 
      Kommunekode:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("Kommunekode")
      Kommunenavn:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("Kommunenavn")
      .
    APPLY "any-printable" TO Kommunekode.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwPostNummer
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
{incl/conttrigg.i oBrwPostNummer:BROWSE-HANDLE}

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
  DISPLAY cPostnr bActive cPoststed Kommunekode Kommunenavn DistriktNavn 
          PostnummerKategoriKode cLandKode 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbPostNummer new_tbPostNummer copy_tbPostNummer undo_tbPostNummer 
         save_tbPostNummer delete_tbPostNummer refresh_tbPostNummer 
         filter_tbPostNummer excel_tbPostNummer BrwPostNummer cPostnr bActive 
         cPoststed Kommunekode btnKommunekode Kommunenavn DistriktNavn 
         PostnummerKategoriKode cLandKode 
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

  iDetailMoveX = brwPostNummer:X + brwPostNummer:WIDTH-PIXELS.
  oBrwPostNummer = NEW JBoxBrowse(brwPostNummer:HANDLE).
  oBrwPostNummer:CreateGridFilter("").

  oFmPostNummer = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmPostNummer:updateFields = 'cPostnr,cPoststed,Kommunekode,bActive'.
  oFmPostNummer:displayFields = 'cLandKode,kommunenavn,DistriktNavn,PostnummerKategoriKode'.
  oFmPostNummer:primaryKeyFields = 'cPostnr'.

  oFmPostNummer:BROWSE-OBJECT = oBrwPostNummer.
  NorcalcBrowseWindow:ConnectToolbar(THIS-PROCEDURE, tbPostNummer:HANDLE, oBrwPostNummer, oFmPostNummer).
  assign 
    cLandKode:DELIMITER = '|'
    cLandKode:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('Land;cLand;cLandKode','where true')
    PostnummerKategoriKode:DELIMITER = '|'
    PostNummerKategoriKode:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('Postnummerkategori;PostnummerKategori;PostnummerKategoriKode','where true')
  .  
END.
oBrwPostNummer:OpenQuery().

oContainer:initResize(iDetailMoveX, 200).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
/*------------------------------------------------------------------------------
  Purpose:     Retrieve lookup values when a foreign key field is modified
  Parameters:  Handle to foreign key field
  Notes:       The FieldValues method is a short version of Find
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihField AS HANDLE NO-UNDO.

IF ihField:MODIFIED THEN DO WITH FRAME {&FRAME-NAME}:
  CASE ihField:NAME:
    WHEN "Kommunekode" THEN assign 
                             kommuneKode:SCREEN-VALUE = JBoxServerAPI:Instance:FieldValues("Kommune","WHERE Kommunekode = '" + ihField:SCREEN-VALUE + "'","KommuneKode")
                             DistriktNavn:Screen-value = JBoxServerAPI:Instance:FieldValues("Distrikt","WHERE Kommunekode = '" + ihField:SCREEN-VALUE + "'","DistriktNavn")
                             .
  END CASE.

END.

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

