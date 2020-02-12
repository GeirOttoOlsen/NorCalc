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


/* Code for Definitions: */

/*** Start instance property definitions for JBoxQuery object oQryPerson ***/
DEF VAR oQryPerson AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE Person
    FIELD bAktiv AS logical
    FIELD cCreatedBy AS character
    FIELD cEpost AS character
    FIELD cInitialer AS character
    FIELD cKontonr AS character
    FIELD cLand AS character
    FIELD cMerknad AS character
    FIELD cMob AS character
    FIELD cModifiedBy AS character
    FIELD cNavn AS character
    FIELD cPostAdresse AS character
    FIELD cPostPnr AS character
    FIELD cPostSted AS character
    FIELD cRolle AS character
    FIELD cStilling AS character
    FIELD cTittel AS character
    FIELD cTlf AS character
    FIELD cVarenr AS character
    FIELD dCreated AS date
    FIELD dModified AS date
    FIELD iAnsattnr AS integer
    FIELD iAvdelingNr AS integer
    FIELD iJBoxCompanyId AS integer
    FIELD iPersonId AS integer
    FIELD iVareId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1
    .
DEFINE BUFFER v_Person FOR Person.

FUNCTION getTableHandleQryPerson RETURNS HANDLE().
  RETURN BUFFER Person:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryPerson RETURNS CHARACTER().
  RETURN 
      'Person'.
END FUNCTION.
FUNCTION getQueryJoinQryPerson RETURNS CHARACTER().
  RETURN ''.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryPerson ***/

DEF VAR oFmPerson AS JBoxFieldMap NO-UNDO.
DEF VAR otbPerson AS JBoxToolbar NO-UNDO.


/*** Start instance property definitions for JBoxBrowse object oBrwPersonGruppe ***/
DEF VAR oBrwPersonGruppe AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE PersonGruppe
    FIELD GruppeNavn AS character
    FIELD cCreatedBy AS character
    FIELD cModifiedBy AS character
    FIELD dCreated AS date
    FIELD dModified AS date
    FIELD iGruppeId AS integer
    FIELD iJBoxCompanyId AS integer
    FIELD iPersonGruppeId AS integer
    FIELD iPersonId AS integer
    FIELD cCreatedBy2 AS character
    FIELD cModifiedBy2 AS character
    FIELD dCreated2 AS date
    FIELD dModified2 AS date
    FIELD iGruppeId2 AS integer
    FIELD iJBoxCompanyId2 AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_PersonGruppe FOR TEMP-TABLE PersonGruppe.


FUNCTION getBuffersAndFieldsBrwPersonGruppe RETURNS CHARACTER():
  RETURN
    'PersonGruppe'
     + ';cCreatedBy'
     + ';cModifiedBy'
     + ';dCreated'
     + ';dModified'
     + ';iGruppeId'
     + ';iJBoxCompanyId'
     + ';iPersonGruppeId'
     + ';iPersonId'
  + ',Gruppe'
     + ';GruppeNavn'
     + ';cCreatedBy'
     + ';cModifiedBy'
     + ';dCreated'
     + ';dModified'
     + ';iGruppeId'
     + ';iJBoxCompanyId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwPersonGruppe RETURNS CHARACTER():
  RETURN 'EACH Gruppe OF PersonGruppe NO-LOCK'.
END FUNCTION.


DEF VAR otbPersonGruppe AS JBoxToolbar NO-UNDO.


DEF VAR oFmPersonGruppe AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwPersonGruppe
&Scoped-define QUERY-NAME QUERY-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES PersonGruppe Person

/* Definitions for BROWSE BrwPersonGruppe                               */
&Scoped-define FIELDS-IN-QUERY-BrwPersonGruppe PersonGruppe.GruppeNavn ~
PersonGruppe.cCreatedBy PersonGruppe.cModifiedBy PersonGruppe.dCreated ~
PersonGruppe.dModified PersonGruppe.iGruppeId PersonGruppe.iJBoxCompanyId ~
PersonGruppe.iPersonGruppeId PersonGruppe.iPersonId ~
PersonGruppe.cCreatedBy2 PersonGruppe.cModifiedBy2 PersonGruppe.dCreated2 ~
PersonGruppe.dModified2 PersonGruppe.iGruppeId2 ~
PersonGruppe.iJBoxCompanyId2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwPersonGruppe ~
PersonGruppe.GruppeNavn 
&Scoped-define QUERY-STRING-BrwPersonGruppe FOR EACH PersonGruppe NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwPersonGruppe OPEN QUERY BrwPersonGruppe FOR EACH PersonGruppe NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwPersonGruppe PersonGruppe
&Scoped-define FIRST-TABLE-IN-QUERY-BrwPersonGruppe PersonGruppe


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define SELF-NAME QUERY-2
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH Person NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY {&SELF-NAME} FOR EACH Person NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-QUERY-2 Person
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 Person


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS AddPersonGruppe_tbPerson new_tbPerson ~
undo_tbPerson save_tbPerson delete_tbPerson iPersonId cInitialer bAktiv ~
cNavn cStilling cMob cEpost BrwPersonGruppe lblGruppe tbPerson 
&Scoped-Define DISPLAYED-OBJECTS iPersonId cInitialer bAktiv cNavn ~
cStilling cMob cEpost lblGruppe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON AddPersonGruppe_tbPerson 
     LABEL "Gruppe" 
     SIZE 10.6 BY 1.52 TOOLTIP "Vedlikehold gruppetilhørighet".

DEFINE BUTTON delete_tbPerson 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON new_tbPerson 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON save_tbPerson 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbPerson 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE cEpost AS CHARACTER FORMAT "x(50)" 
     LABEL "Epost" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1.

DEFINE VARIABLE cInitialer AS CHARACTER FORMAT "x(4)" 
     LABEL "Initialer" 
     VIEW-AS FILL-IN 
     SIZE 9.6 BY 1 NO-UNDO.

DEFINE VARIABLE cMob AS CHARACTER FORMAT "x(12)" 
     LABEL "Mob" 
     VIEW-AS FILL-IN 
     SIZE 17.6 BY 1.

DEFINE VARIABLE cNavn AS CHARACTER FORMAT "x(40)" 
     LABEL "Navn" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1.

DEFINE VARIABLE cStilling AS CHARACTER FORMAT "x(50)" 
     LABEL "Stilling" 
     VIEW-AS FILL-IN 
     SIZE 52 BY 1.

DEFINE VARIABLE iPersonId AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Person id" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE lblGruppe AS CHARACTER FORMAT "X(256)":U INITIAL "Gruppe tilhørighet:" 
      VIEW-AS TEXT 
     SIZE 17.6 BY .62 NO-UNDO.

DEFINE RECTANGLE tbPerson
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 76.8 BY 1.71.

DEFINE VARIABLE bAktiv AS LOGICAL INITIAL no 
     LABEL "Aktiv" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.4 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwPersonGruppe FOR 
      PersonGruppe SCROLLING.

DEFINE QUERY QUERY-2 FOR 
      Person SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwPersonGruppe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwPersonGruppe C-Win _STRUCTURED
  QUERY BrwPersonGruppe NO-LOCK DISPLAY
      PersonGruppe.GruppeNavn COLUMN-LABEL "Gruppe" FORMAT "x(50)":U
      PersonGruppe.cCreatedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      PersonGruppe.cModifiedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      PersonGruppe.dCreated COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
      PersonGruppe.dModified COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
      PersonGruppe.iGruppeId COLUMN-LABEL "Gruppe id" FORMAT ">>>>>>>9":U
      PersonGruppe.iJBoxCompanyId COLUMN-LABEL "CompanyId" FORMAT "->,>>>,>>9":U
      PersonGruppe.iPersonGruppeId COLUMN-LABEL "Id" FORMAT ">>>>>>>>9":U
      PersonGruppe.iPersonId COLUMN-LABEL "Person id" FORMAT "->,>>>,>>9":U
      PersonGruppe.cCreatedBy2 COLUMN-LABEL "Av" FORMAT "x(8)":U
      PersonGruppe.cModifiedBy2 COLUMN-LABEL "Av" FORMAT "x(8)":U
      PersonGruppe.dCreated2 COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
      PersonGruppe.dModified2 COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
      PersonGruppe.iGruppeId2 COLUMN-LABEL "Gruppe id" FORMAT ">>>>>>>9":U
      PersonGruppe.iJBoxCompanyId2 COLUMN-LABEL "CompanyId" FORMAT "->,>>>,>>9":U
  ENABLE
      PersonGruppe.GruppeNavn
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 52 BY 5.24 ROW-HEIGHT-CHARS .57 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     AddPersonGruppe_tbPerson AT ROW 1.1 COL 25.4 WIDGET-ID 34
     new_tbPerson AT ROW 1.1 COL 1.2 WIDGET-ID 16
     undo_tbPerson AT ROW 1.1 COL 7.4 WIDGET-ID 18
     save_tbPerson AT ROW 1.1 COL 13.4 WIDGET-ID 20
     delete_tbPerson AT ROW 1.1 COL 19.4 WIDGET-ID 24
     iPersonId AT ROW 3 COL 10 COLON-ALIGNED
     cInitialer AT ROW 2.91 COL 35 COLON-ALIGNED
     bAktiv AT ROW 2.91 COL 50 WIDGET-ID 12
     cNavn AT ROW 4 COL 10 COLON-ALIGNED
     cStilling AT ROW 5 COL 10 COLON-ALIGNED
     cMob AT ROW 6 COL 10 COLON-ALIGNED
     cEpost AT ROW 7 COL 10 COLON-ALIGNED
     BrwPersonGruppe AT ROW 9.1 COL 12 WIDGET-ID 200
     lblGruppe AT ROW 8.38 COL 10 COLON-ALIGNED NO-LABEL
     tbPerson AT ROW 1 COL 1 WIDGET-ID 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 76.8 BY 13.52 WIDGET-ID 100.


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
         HEIGHT             = 13.52
         WIDTH              = 76.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 118.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 118.2
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
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB BrwPersonGruppe cEpost DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 13.52
       FRAME DEFAULT-FRAME:WIDTH            = 76.8.

ASSIGN 
       PersonGruppe.cCreatedBy:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.cModifiedBy:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.dCreated:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.dModified:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.iGruppeId:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.iJBoxCompanyId:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.iPersonGruppeId:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.iPersonId:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.cCreatedBy2:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.cModifiedBy2:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.dCreated2:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.dModified2:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.iGruppeId2:VISIBLE IN BROWSE BrwPersonGruppe = FALSE
       PersonGruppe.iJBoxCompanyId2:VISIBLE IN BROWSE BrwPersonGruppe = FALSE.

ASSIGN 
       lblGruppe:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Gruppe tilhørighet:".

ASSIGN 
       tbPerson:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,undo;Undo,save;Save,delete;Delete,AddPersonGruppe;Legg til gruppemaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwPersonGruppe
/* Query rebuild information for BROWSE BrwPersonGruppe
     _TblList          = "norcalc.PersonGruppe"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"PersonGruppe.GruppeNavn" "Gruppe" "x(50)" "character" ? ? ? ? ? ? yes "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"PersonGruppe.cCreatedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"PersonGruppe.cModifiedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"PersonGruppe.dCreated" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"PersonGruppe.dModified" "Endret" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"PersonGruppe.iGruppeId" "Gruppe id" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"PersonGruppe.iJBoxCompanyId" "CompanyId" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"PersonGruppe.iPersonGruppeId" "Id" ">>>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "10.8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"PersonGruppe.iPersonId" "Person id" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.2" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"PersonGruppe.cCreatedBy2" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"PersonGruppe.cModifiedBy2" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"PersonGruppe.dCreated2" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"PersonGruppe.dModified2" "Endret" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"PersonGruppe.iGruppeId2" "Gruppe id" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"PersonGruppe.iJBoxCompanyId2" "CompanyId" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwPersonGruppe */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH Person NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 2.91 , 69 )
*/  /* QUERY QUERY-2 */
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


&Scoped-define SELF-NAME QUERY-2
&Scoped-define BROWSE-NAME BrwPersonGruppe
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
{incl/conttrigg.i oQryPerson:query-handle}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addPersonGruppeRecord C-Win 
PROCEDURE addPersonGruppeRecord :
DEF VAR cRowIdList AS CHAR NO-UNDO.
  DEF VAR cIdList    AS CHAR NO-UNDO.
  
  THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = FALSE.
  if not avail Person then leave.
  
  cRowIdList = JBoxServerAPI:Instance:getRowIdList("PersonGruppe,Gruppe","","WHERE iPersonId = " + string(Person.iPersonId) + ",FIRST Gruppe OF PersonGruppe NO-LOCK").
  
  RUN JBoxSelector.w (THIS-PROCEDURE,0,
                      "Gruppe;iGruppeId;GruppeNavn"
                     ,"where true",
                      INPUT-OUTPUT cRowIdList,
                      "GruppeNavn,iGruppeId",
                      INPUT-OUTPUT cIdList,
                      "","",
                      OUTPUT bOK).
  
  THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = TRUE.
  IF bOk THEN 
  DO:
    cRowIdList = replace(cRowIdList,',','|').
    if not JBoxServerAPI:Instance:CallServerProc('update_persongruppe.p',if avail Person then string(Person.iPersonId) + '|' + cRowidList else '') THEN JBoxServerAPI:Instance:viewCallMessage().
    else oBrwPersonGruppe:refresh().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  DISPLAY iPersonId cInitialer bAktiv cNavn cStilling cMob cEpost lblGruppe 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE AddPersonGruppe_tbPerson new_tbPerson undo_tbPerson save_tbPerson 
         delete_tbPerson iPersonId cInitialer bAktiv cNavn cStilling cMob 
         cEpost BrwPersonGruppe lblGruppe tbPerson 
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
//DEBUGGER:INITIATE ().
//DEBUGGER:SET-BREAK ().

DO WITH FRAME {&FRAME-NAME}:

  oQryPerson = NEW JBoxQuery('Person').

  oFmPerson = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmPerson:updateFields = 'cInitialer,bAktiv,cNavn,cStilling,cMob,cEpost'.
  oFmPerson:DisplayFields = 'iPersonId'.
  oFmPerson:bufferExtraFields = 'iJBoxCompanyId'.
  oFmPerson:bufferExtraValues = dynamic-function('getCompanyId').
  //oFmPerson:customUpdateValProc = 'ignore'.
  oFmPerson:QUERY-OBJECT = oQryPerson.
  
  otbPerson = NEW JBoxToolbar(tbPerson:HANDLE).
  
  oQryPerson:TOOLBAR-OBJECT = otbPerson.
  oFmPerson:TOOLBAR-OBJECT = otbPerson.

  oBrwPersonGruppe = NEW JBoxBrowse(brwPersonGruppe:HANDLE).
  oBrwPersonGruppe:setParentQueryObject(oQryPerson,'iPersonId').
  oBrwPersonGruppe:setNoResizeX().
  oBrwPersonGruppe:setNoResizeY().
END.
oQryPerson:OpenQuery().

oContainer:initResize(300,500).

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

