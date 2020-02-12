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


/*** Start instance property definitions for JBoxBrowse object oBrwPerson ***/
DEF VAR oBrwPerson AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE Person
    FIELD iPersonId AS integer
    FIELD cNavn AS character
    FIELD iAnsattnr AS integer
    FIELD iAvdelingNr AS integer
    FIELD cMob AS character
    FIELD cEpost AS character
    FIELD bAktiv AS logical
    FIELD cInitialer AS character
    FIELD cKontonr AS character
    FIELD cLand AS character
    FIELD cMerknad AS character
    FIELD cPostAdresse AS character
    FIELD cPostPnr AS character
    FIELD cPostSted AS character
    FIELD cRolle AS character
    FIELD cStilling AS character
    FIELD cTittel AS character
    FIELD cTlf AS character
    FIELD cVarenr AS character
    FIELD dCreated AS date
    FIELD cCreatedBy AS character
    FIELD cModifiedBy AS character
    FIELD dModified AS date
    FIELD iJBoxCompanyId AS integer
    FIELD iVareId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_Person FOR TEMP-TABLE Person.


FUNCTION getBuffersAndFieldsBrwPerson RETURNS CHARACTER():
  RETURN
    'Person'
     + ';iPersonId'
     + ';cNavn'
     + ';iAnsattnr'
     + ';iAvdelingNr'
     + ';cMob'
     + ';cEpost'
     + ';bAktiv'
     + ';cInitialer'
     + ';cKontonr'
     + ';cLand'
     + ';cMerknad'
     + ';cPostAdresse'
     + ';cPostPnr'
     + ';cPostSted'
     + ';cRolle'
     + ';cStilling'
     + ';cTittel'
     + ';cTlf'
     + ';cVarenr'
     + ';dCreated'
     + ';cCreatedBy'
     + ';cModifiedBy'
     + ';dModified'
     + ';iJBoxCompanyId'
     + ';iVareId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwPerson RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbPerson AS JBoxToolbar NO-UNDO.
DEF VAR oTabPerson AS JBoxMsTabs NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwPerson

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Person

/* Definitions for BROWSE BrwPerson                                     */
&Scoped-define FIELDS-IN-QUERY-BrwPerson Person.iPersonId Person.cNavn ~
Person.iAnsattnr Person.iAvdelingNr Person.cMob Person.cEpost Person.bAktiv ~
Person.cInitialer Person.cKontonr Person.cLand Person.cMerknad ~
Person.cPostAdresse Person.cPostPnr Person.cPostSted Person.cRolle ~
Person.cStilling Person.cTittel Person.cTlf Person.cVarenr Person.dCreated ~
Person.cCreatedBy Person.cModifiedBy Person.dModified Person.iJBoxCompanyId ~
Person.iVareId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwPerson Person.iPersonId 
&Scoped-define QUERY-STRING-BrwPerson FOR EACH Person NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwPerson OPEN QUERY BrwPerson FOR EACH Person NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwPerson Person
&Scoped-define FIRST-TABLE-IN-QUERY-BrwPerson Person


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbPerson TabPerson refresh_tbPerson ~
filter_tbPerson excel_tbPerson BrwPerson 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbPerson 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbPerson 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbPerson 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE TabPerson
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 114 BY 11.

DEFINE RECTANGLE tbPerson
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 113 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwPerson FOR 
      Person SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwPerson
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwPerson C-Win _STRUCTURED
  QUERY BrwPerson NO-LOCK DISPLAY
      Person.iPersonId COLUMN-LABEL "Person id" FORMAT "->,>>>,>>9":U
      Person.cNavn COLUMN-LABEL "Navn" FORMAT "x(40)":U
      Person.iAnsattnr COLUMN-LABEL "Ansattnr" FORMAT "->>>>>>9":U
      Person.iAvdelingNr COLUMN-LABEL "Avdelingsnr" FORMAT "->>>>9":U
      Person.cMob COLUMN-LABEL "Mob" FORMAT "x(12)":U
      Person.cEpost COLUMN-LABEL "Epost" FORMAT "x(50)":U
      Person.bAktiv COLUMN-LABEL "Aktiv" FORMAT "ja/nei":U
      Person.cInitialer COLUMN-LABEL "Initialer" FORMAT "x(4)":U
      Person.cKontonr COLUMN-LABEL "Kontonr" FORMAT "x(13)":U
      Person.cLand COLUMN-LABEL "Land" FORMAT "x(20)":U
      Person.cMerknad COLUMN-LABEL "Merknad" FORMAT "x(50)":U
      Person.cPostAdresse FORMAT "x(40)":U
      Person.cPostPnr COLUMN-LABEL "Postnummer" FORMAT "x(8)":U
      Person.cPostSted COLUMN-LABEL "Poststed" FORMAT "x(40)":U
      Person.cRolle COLUMN-LABEL "Rolle" FORMAT "x(20)":U
      Person.cStilling COLUMN-LABEL "Stilling" FORMAT "x(50)":U
      Person.cTittel COLUMN-LABEL "Tittel" FORMAT "x(25)":U
      Person.cTlf COLUMN-LABEL "Tlf" FORMAT "x(12)":U
      Person.cVarenr COLUMN-LABEL "Varenr" FORMAT "x(13)":U
      Person.dCreated COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
      Person.cCreatedBy COLUMN-LABEL "Av" FORMAT "X(8)":U
      Person.cModifiedBy COLUMN-LABEL "Av" FORMAT "X(8)":U
      Person.dModified COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
      Person.iJBoxCompanyId COLUMN-LABEL "CompanyId" FORMAT "->,>>>,>>9":U
      Person.iVareId COLUMN-LABEL "VareId" FORMAT "->,>>>,>>9":U
  ENABLE
      Person.iPersonId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 113 BY 5.24 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbPerson AT ROW 1.1 COL 2.2 WIDGET-ID 14
     filter_tbPerson AT ROW 1.1 COL 8.4 WIDGET-ID 16
     excel_tbPerson AT ROW 1.1 COL 14.4 WIDGET-ID 18
     BrwPerson AT ROW 2.67 COL 2 WIDGET-ID 300
     tbPerson AT ROW 1 COL 2 WIDGET-ID 2
     TabPerson AT ROW 8.38 COL 1 WIDGET-ID 20
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 114 BY 18.38 WIDGET-ID 100.


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
         HEIGHT             = 18.38
         WIDTH              = 114
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
/* BROWSE-TAB BrwPerson excel_tbPerson DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 18.38
       FRAME DEFAULT-FRAME:WIDTH            = 114.

ASSIGN 
       Person.cVarenr:VISIBLE IN BROWSE BrwPerson = FALSE
       Person.dCreated:VISIBLE IN BROWSE BrwPerson = FALSE
       Person.cCreatedBy:VISIBLE IN BROWSE BrwPerson = FALSE
       Person.cModifiedBy:VISIBLE IN BROWSE BrwPerson = FALSE
       Person.dModified:VISIBLE IN BROWSE BrwPerson = FALSE
       Person.iJBoxCompanyId:VISIBLE IN BROWSE BrwPerson = FALSE
       Person.iVareId:VISIBLE IN BROWSE BrwPerson = FALSE.

ASSIGN 
       tbPerson:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwPerson
/* Query rebuild information for BROWSE BrwPerson
     _TblList          = "norcalc.Person"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"Person.iPersonId" "Person id" "->,>>>,>>9" "integer" ? ? ? ? ? ? yes "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"Person.cNavn" "Navn" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"Person.iAnsattnr" "Ansattnr" "->>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"Person.iAvdelingNr" "Avdelingsnr" "->>>>9" "integer" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"Person.cMob" "Mob" "x(12)" "character" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"Person.cEpost" "Epost" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"Person.bAktiv" "Aktiv" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"Person.cInitialer" "Initialer" "x(4)" "character" ? ? ? ? ? ? no "" no no "6.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"Person.cKontonr" "Kontonr" "x(13)" "character" ? ? ? ? ? ? no "" no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"Person.cLand" "Land" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"Person.cMerknad" "Merknad" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"Person.cPostAdresse" "" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"Person.cPostPnr" "Postnummer" "x(8)" "character" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"Person.cPostSted" "Poststed" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"Person.cRolle" "Rolle" "x(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"Person.cStilling" "Stilling" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"Person.cTittel" "Tittel" "x(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"Person.cTlf" "Tlf" "x(12)" "character" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"Person.cVarenr" "Varenr" "x(13)" "character" ? ? ? ? ? ? no "" no no "13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"Person.dCreated" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"Person.cCreatedBy" "Av" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"Person.cModifiedBy" "Av" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"Person.dModified" "Endret" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"Person.iJBoxCompanyId" "CompanyId" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > "_<CALC>"
"Person.iVareId" "VareId" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.2" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwPerson */
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


&Scoped-define BROWSE-NAME BrwPerson
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
{incl/conttrigg.i oBrwPerson:BROWSE-HANDLE}

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
  ENABLE tbPerson TabPerson refresh_tbPerson filter_tbPerson excel_tbPerson 
         BrwPerson 
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

  oBrwPerson = NEW JBoxBrowse(brwPerson:HANDLE).
  oBrwPerson:setNoResizeY().
  otbPerson = NEW JBoxToolbar(tbPerson:HANDLE).
  
  oBrwPerson:TOOLBAR-OBJECT = otbPerson.
  oTabPerson = NEW JBoxMSTabs(TabPerson:HANDLE,oBrwPerson,"img\ico\id_card.ico").
  oTabPerson:pageOneType = "oneToOne".

  oTabPerson:setLinkFields("iPersonId").
  oTabPerson:AddPage("Person detalj","wPersonDetalj.w","id_card.ico").
END.
oBrwPerson:OpenQuery().


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

