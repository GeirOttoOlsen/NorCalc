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


/*** Start instance property definitions for JBoxBrowse object oBrwKundeKontakt ***/
DEF VAR oBrwKundeKontakt AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE KundeKontakt
    FIELD iKundeKontaktId AS integer
    FIELD cKontaktNavn AS character
    FIELD cRolle AS character
    FIELD cStilling AS character
    FIELD cEmail AS character
    FIELD cMob AS character
    FIELD cTlf AS character
    FIELD cMerknad AS character
    FIELD cPostPnr AS character
    FIELD cPostSted AS character
    FIELD cPostAdresse AS character
    FIELD cLand AS character
    FIELD bActive AS logical
    FIELD cCreatedBy AS character
    FIELD cModifiedBy AS character
    FIELD dCreated AS date
    FIELD dModified AS date
    FIELD iKundeId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_KundeKontakt FOR TEMP-TABLE KundeKontakt.


FUNCTION getBuffersAndFieldsBrwKundeKontakt RETURNS CHARACTER():
  RETURN
    'KundeKontakt'
     + ';iKundeKontaktId'
     + ';cKontaktNavn'
     + ';cRolle'
     + ';cStilling'
     + ';cEmail'
     + ';cMob'
     + ';cTlf'
     + ';cMerknad'
     + ';cPostPnr'
     + ';cPostSted'
     + ';cPostAdresse'
     + ';cLand'
     + ';bActive'
     + ';cCreatedBy'
     + ';cModifiedBy'
     + ';dCreated'
     + ';dModified'
     + ';iKundeId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwKundeKontakt RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmKundeKontakt AS JBoxFieldMap NO-UNDO.
DEF VAR otbKundeKontakt AS JBoxToolbar NO-UNDO.



/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwKundeKontakt

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES KundeKontakt

/* Definitions for BROWSE BrwKundeKontakt                               */
&Scoped-define FIELDS-IN-QUERY-BrwKundeKontakt KundeKontakt.iKundeKontaktId ~
KundeKontakt.cKontaktNavn KundeKontakt.cRolle KundeKontakt.cStilling ~
KundeKontakt.cEmail KundeKontakt.cMob KundeKontakt.cTlf ~
KundeKontakt.cMerknad KundeKontakt.cPostPnr KundeKontakt.cPostSted ~
KundeKontakt.cPostAdresse KundeKontakt.cLand KundeKontakt.bActive ~
KundeKontakt.cCreatedBy KundeKontakt.cModifiedBy KundeKontakt.dCreated ~
KundeKontakt.dModified KundeKontakt.iKundeId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwKundeKontakt ~
KundeKontakt.iKundeKontaktId 
&Scoped-define QUERY-STRING-BrwKundeKontakt FOR EACH KundeKontakt NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwKundeKontakt OPEN QUERY BrwKundeKontakt FOR EACH KundeKontakt NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwKundeKontakt KundeKontakt
&Scoped-define FIRST-TABLE-IN-QUERY-BrwKundeKontakt KundeKontakt


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS new_tbKundeKontakt copy_tbKundeKontakt ~
undo_tbKundeKontakt save_tbKundeKontakt delete_tbKundeKontakt ~
tbKundeKontakt refresh_tbKundeKontakt filter_tbKundeKontakt ~
excel_tbKundeKontakt BrwKundeKontakt iKundeKontaktId cKontaktNavn cRolle ~
cStilling cTlf cMob cEmail cMerknad lblMerknad 
&Scoped-Define DISPLAYED-OBJECTS iKundeKontaktId cKontaktNavn cRolle ~
cStilling cTlf cMob cEmail cMerknad lblMerknad 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbKundeKontakt 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.53 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbKundeKontakt 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.53 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbKundeKontakt 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.53 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbKundeKontakt 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.53 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbKundeKontakt 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.53 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbKundeKontakt 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.53 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbKundeKontakt 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.53 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbKundeKontakt 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.53 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE cMerknad AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 37 BY 2.13 NO-UNDO.

DEFINE VARIABLE cEmail AS CHARACTER FORMAT "x(40)" 
     LABEL "Epost" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1.

DEFINE VARIABLE cKontaktNavn AS CHARACTER FORMAT "x(40)" 
     LABEL "Kontaktnavn" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1.

DEFINE VARIABLE cMob AS CHARACTER FORMAT "x(12)" 
     LABEL "Mob" 
     VIEW-AS FILL-IN 
     SIZE 17.63 BY 1.

DEFINE VARIABLE cRolle AS CHARACTER FORMAT "x(20)" 
     LABEL "Rolle" 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1.

DEFINE VARIABLE cStilling AS CHARACTER FORMAT "x(50)" 
     LABEL "Stilling" 
     VIEW-AS FILL-IN 
     SIZE 37 BY 1.

DEFINE VARIABLE cTlf AS CHARACTER FORMAT "x(12)" 
     LABEL "Tlf" 
     VIEW-AS FILL-IN 
     SIZE 17.63 BY 1.

DEFINE VARIABLE iKundeKontaktId AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Kundekontakt id" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE lblMerknad AS CHARACTER FORMAT "X(256)":U INITIAL "Merknad:" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE tbKundeKontakt
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 100 BY 1.72.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwKundeKontakt FOR 
      KundeKontakt SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwKundeKontakt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwKundeKontakt C-Win _STRUCTURED
  QUERY BrwKundeKontakt NO-LOCK DISPLAY
      KundeKontakt.iKundeKontaktId COLUMN-LABEL "Kundekontakt id" FORMAT "->,>>>,>>9":U
            WIDTH 15.6
      KundeKontakt.cKontaktNavn COLUMN-LABEL "Kontaktnavn" FORMAT "x(40)":U
      KundeKontakt.cRolle COLUMN-LABEL "Rolle" FORMAT "x(20)":U
      KundeKontakt.cStilling COLUMN-LABEL "Stilling" FORMAT "x(50)":U
      KundeKontakt.cEmail COLUMN-LABEL "Epost" FORMAT "x(40)":U
      KundeKontakt.cMob COLUMN-LABEL "Mob" FORMAT "x(12)":U
      KundeKontakt.cTlf COLUMN-LABEL "Tlf" FORMAT "x(12)":U
      KundeKontakt.cMerknad COLUMN-LABEL "Merknad" FORMAT "x(50)":U
      KundeKontakt.cPostPnr COLUMN-LABEL "Postnummer" FORMAT "x(8)":U
            WIDTH 11.6
      KundeKontakt.cPostSted COLUMN-LABEL "Poststed" FORMAT "x(40)":U
      KundeKontakt.cPostAdresse FORMAT "x(40)":U
      KundeKontakt.cLand COLUMN-LABEL "Land" FORMAT "x(20)":U
      KundeKontakt.bActive COLUMN-LABEL "Aktiv" FORMAT "ja/nei":U
            WIDTH 4.8
      KundeKontakt.cCreatedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      KundeKontakt.cModifiedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      KundeKontakt.dCreated COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
            WIDTH 11.6
      KundeKontakt.dModified COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
            WIDTH 11.6
      KundeKontakt.iKundeId COLUMN-LABEL "KundeId" FORMAT "->,>>>,>>9":U
            WIDTH 10.2
  ENABLE
      KundeKontakt.iKundeKontaktId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 50 BY 10.72 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbKundeKontakt AT ROW 1.09 COL 1.25 WIDGET-ID 20
     copy_tbKundeKontakt AT ROW 1.09 COL 7.25 WIDGET-ID 22
     undo_tbKundeKontakt AT ROW 1.09 COL 13.38 WIDGET-ID 24
     save_tbKundeKontakt AT ROW 1.09 COL 19.38 WIDGET-ID 26
     delete_tbKundeKontakt AT ROW 1.09 COL 25.63 WIDGET-ID 28
     refresh_tbKundeKontakt AT ROW 1.09 COL 31.63 WIDGET-ID 30
     filter_tbKundeKontakt AT ROW 1.09 COL 37.75 WIDGET-ID 32
     excel_tbKundeKontakt AT ROW 1.09 COL 43.75 WIDGET-ID 34
     BrwKundeKontakt AT ROW 2.91 COL 1 WIDGET-ID 200
     iKundeKontaktId AT ROW 3.25 COL 67 COLON-ALIGNED
     cKontaktNavn AT ROW 4.25 COL 67 COLON-ALIGNED
     cRolle AT ROW 5.25 COL 67 COLON-ALIGNED
     cStilling AT ROW 6.25 COL 67 COLON-ALIGNED
     cTlf AT ROW 7.25 COL 67 COLON-ALIGNED
     cMob AT ROW 8.25 COL 67 COLON-ALIGNED
     cEmail AT ROW 9.25 COL 67 COLON-ALIGNED
     cMerknad AT ROW 11.13 COL 69 NO-LABEL WIDGET-ID 16
     lblMerknad AT ROW 10.41 COL 67 COLON-ALIGNED NO-LABEL
     tbKundeKontakt AT ROW 1 COL 1 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 108.13 BY 12.66 WIDGET-ID 100.


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
         HEIGHT             = 12.66
         WIDTH              = 108.13
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 139.25
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 139.25
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
/* BROWSE-TAB BrwKundeKontakt excel_tbKundeKontakt DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 12.66
       FRAME DEFAULT-FRAME:WIDTH            = 108.13.

ASSIGN 
       KundeKontakt.iKundeKontaktId:VISIBLE IN BROWSE BrwKundeKontakt = FALSE
       KundeKontakt.cCreatedBy:VISIBLE IN BROWSE BrwKundeKontakt = FALSE
       KundeKontakt.cModifiedBy:VISIBLE IN BROWSE BrwKundeKontakt = FALSE
       KundeKontakt.dCreated:VISIBLE IN BROWSE BrwKundeKontakt = FALSE
       KundeKontakt.dModified:VISIBLE IN BROWSE BrwKundeKontakt = FALSE
       KundeKontakt.iKundeId:VISIBLE IN BROWSE BrwKundeKontakt = FALSE.

ASSIGN 
       lblMerknad:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Merknad:".

ASSIGN 
       tbKundeKontakt:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwKundeKontakt
/* Query rebuild information for BROWSE BrwKundeKontakt
     _TblList          = "norcalc.KundeKontakt"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"KundeKontakt.iKundeKontaktId" "Kundekontakt id" "->,>>>,>>9" "integer" ? ? ? ? ? ? yes "" no no "15.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"KundeKontakt.cKontaktNavn" "Kontaktnavn" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"KundeKontakt.cRolle" "Rolle" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"KundeKontakt.cStilling" "Stilling" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"KundeKontakt.cEmail" "Epost" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"KundeKontakt.cMob" "Mob" "x(12)" "character" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"KundeKontakt.cTlf" "Tlf" "x(12)" "character" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"KundeKontakt.cMerknad" "Merknad" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"KundeKontakt.cPostPnr" "Postnummer" "x(8)" "character" ? ? ? ? ? ? no "" no no "11.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"KundeKontakt.cPostSted" "Poststed" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"KundeKontakt.cPostAdresse" "" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"KundeKontakt.cLand" "Land" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"KundeKontakt.bActive" "Aktiv" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"KundeKontakt.cCreatedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"KundeKontakt.cModifiedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"KundeKontakt.dCreated" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"KundeKontakt.dModified" "Endret" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"KundeKontakt.iKundeId" "KundeId" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwKundeKontakt */
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


&Scoped-define BROWSE-NAME BrwKundeKontakt
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
{incl/conttrigg.i oBrwKundeKontakt:BROWSE-HANDLE}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

run super.

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
  DISPLAY iKundeKontaktId cKontaktNavn cRolle cStilling cTlf cMob cEmail 
          cMerknad lblMerknad 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE new_tbKundeKontakt copy_tbKundeKontakt undo_tbKundeKontakt 
         save_tbKundeKontakt delete_tbKundeKontakt tbKundeKontakt 
         refresh_tbKundeKontakt filter_tbKundeKontakt excel_tbKundeKontakt 
         BrwKundeKontakt iKundeKontaktId cKontaktNavn cRolle cStilling cTlf 
         cMob cEmail cMerknad lblMerknad 
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

  oBrwKundeKontakt = NEW JBoxBrowse(brwKundeKontakt:HANDLE).

  oFmKundeKontakt = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmKundeKontakt:updateFields      = 'cKontaktNavn,cRolle,cStilling,cTlf,cMob,cEmail,cMerknad'.
  oFmKundeKontakt:DisplayFields     = 'iKundeKontaktId'.
  oFmKundeKontakt:bufferExtraFields = 'iKundeId'.
  oFmKundeKontakt:customCreateProc = 'crt_kundekontakt.p'.
  oFmKundeKontakt:customUpdateValProc = 'ignore'.
  oFmKundeKontakt:BROWSE-OBJECT = oBrwKundeKontakt.
  otbKundeKontakt = NEW JBoxToolbar(tbKundeKontakt:HANDLE).
  oBrwKundeKontakt:TOOLBAR-OBJECT = otbKundeKontakt.
  oFmKundeKontakt:TOOLBAR-OBJECT = otbKundeKontakt.
END.
oBrwKundeKontakt:OpenQuery().

oContainer:setNoResizeX('cMerknad').
oContainer:setAddMoveX("iKundeKontaktId,cKontaktNavn,cRolle,cStilling,cTlf,cMob,cEmail,cMerknad,lblMerknad").
oContainer:initResize(520,300).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
oFmKundeKontakt:bufferExtraValues = string(oBrwKundeKontakt:PARENT-BUFFER-HANDLE::kundenr).
run super.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

