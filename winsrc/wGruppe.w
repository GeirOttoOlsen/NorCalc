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

DEFINE VARIABLE oToolbar AS JBoxToolbar NO-UNDO.
DEFINE VARIABLE oContainer AS JBoxContainer NO-UNDO.
DEFINE VARIABLE oFieldMap AS JBoxFieldMap NO-UNDO.

/*** Start instance property definitions for JBoxBrowse object oBrwGruppe ***/
DEF VAR oBrwGruppe AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE Gruppe
    FIELD iGruppeId AS integer
    FIELD GruppeNavn AS character
    FIELD cCreatedBy AS character
    FIELD cModifiedBy AS character
    FIELD dCreated AS date
    FIELD dModified AS date
    FIELD iJBoxCompanyId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_Gruppe FOR TEMP-TABLE Gruppe.


FUNCTION getBuffersAndFieldsBrwGruppe RETURNS CHARACTER():
  RETURN
    'Gruppe'
     + ';iGruppeId'
     + ';GruppeNavn'
     + ';cCreatedBy'
     + ';cModifiedBy'
     + ';dCreated'
     + ';dModified'
     + ';iJBoxCompanyId'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwGruppe RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwGruppe

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES Gruppe

/* Definitions for BROWSE BrwGruppe                                     */
&Scoped-define FIELDS-IN-QUERY-BrwGruppe Gruppe.iGruppeId Gruppe.GruppeNavn ~
Gruppe.cCreatedBy Gruppe.cModifiedBy Gruppe.dCreated Gruppe.dModified ~
Gruppe.iJBoxCompanyId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwGruppe Gruppe.iGruppeId 
&Scoped-define QUERY-STRING-BrwGruppe FOR EACH Gruppe NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwGruppe OPEN QUERY BrwGruppe FOR EACH Gruppe NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwGruppe Gruppe
&Scoped-define FIRST-TABLE-IN-QUERY-BrwGruppe Gruppe


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS new_tbPerson copy_tbPerson undo_tbPerson ~
save_tbPerson delete_tbPerson refresh_tbPerson filter_tbPerson tbPerson ~
excel_tbPerson Person_tbPerson BrwGruppe iGruppeId GruppeNavn 
&Scoped-Define DISPLAYED-OBJECTS iGruppeId GruppeNavn 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbPerson 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbPerson 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbPerson 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbPerson 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbPerson 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON Person_tbPerson 
     IMAGE-UP FILE "ico\businesspeople.ico":U
     LABEL "Person" 
     SIZE 6 BY 1.52 TOOLTIP "Velg personer til gruppen".

DEFINE BUTTON refresh_tbPerson 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbPerson 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbPerson 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE GruppeNavn AS CHARACTER FORMAT "x(50)" 
     LABEL "Gruppe" 
     VIEW-AS FILL-IN 
     SIZE 30 BY 1.

DEFINE VARIABLE iGruppeId AS INTEGER FORMAT ">>>>>>>9" INITIAL 0 
     LABEL "Gruppe id" 
     VIEW-AS FILL-IN 
     SIZE 13.2 BY 1.

DEFINE RECTANGLE tbPerson
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 96 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwGruppe FOR 
      Gruppe SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwGruppe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwGruppe C-Win _STRUCTURED
  QUERY BrwGruppe NO-LOCK DISPLAY
      Gruppe.iGruppeId COLUMN-LABEL "Gruppe id" FORMAT ">>>>>>>9":U
            WIDTH 10.2
      Gruppe.GruppeNavn COLUMN-LABEL "Gruppe" FORMAT "x(50)":U
      Gruppe.cCreatedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      Gruppe.cModifiedBy COLUMN-LABEL "Av" FORMAT "x(8)":U
      Gruppe.dCreated COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
      Gruppe.dModified COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
      Gruppe.iJBoxCompanyId COLUMN-LABEL "CompanyId" FORMAT "->,>>>,>>9":U
  ENABLE
      Gruppe.iGruppeId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 48 BY 8.1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbPerson AT ROW 1.1 COL 1.2 WIDGET-ID 8
     copy_tbPerson AT ROW 1.1 COL 7.4 WIDGET-ID 10
     undo_tbPerson AT ROW 1.1 COL 13.4 WIDGET-ID 12
     save_tbPerson AT ROW 1.1 COL 19.4 WIDGET-ID 14
     delete_tbPerson AT ROW 1.1 COL 25.4 WIDGET-ID 16
     refresh_tbPerson AT ROW 1.1 COL 31.4 WIDGET-ID 18
     filter_tbPerson AT ROW 1.1 COL 37.4 WIDGET-ID 20
     excel_tbPerson AT ROW 1.1 COL 43.4 WIDGET-ID 22
     Person_tbPerson AT ROW 1.1 COL 49.4 WIDGET-ID 24
     BrwGruppe AT ROW 3.86 COL 1.8 WIDGET-ID 200
     iGruppeId AT ROW 4 COL 60 COLON-ALIGNED
     GruppeNavn AT ROW 5.19 COL 60 COLON-ALIGNED
     tbPerson AT ROW 1 COL 1 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 96.25 BY 11.34 WIDGET-ID 100.


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
         HEIGHT             = 11.33
         WIDTH              = 96.2
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
/* BROWSE-TAB BrwGruppe Person_tbPerson DEFAULT-FRAME */
ASSIGN 
       Gruppe.cCreatedBy:VISIBLE IN BROWSE BrwGruppe = FALSE
       Gruppe.cModifiedBy:VISIBLE IN BROWSE BrwGruppe = FALSE
       Gruppe.dCreated:VISIBLE IN BROWSE BrwGruppe = FALSE
       Gruppe.dModified:VISIBLE IN BROWSE BrwGruppe = FALSE
       Gruppe.iJBoxCompanyId:VISIBLE IN BROWSE BrwGruppe = FALSE.

ASSIGN 
       tbPerson:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excel,Person;Personmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwGruppe
/* Query rebuild information for BROWSE BrwGruppe
     _TblList          = "norcalc.Gruppe"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"Gruppe.iGruppeId" "Gruppe id" ">>>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"Gruppe.GruppeNavn" "Gruppe" "x(50)" "character" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"Gruppe.cCreatedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"Gruppe.cModifiedBy" "Av" "x(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"Gruppe.dCreated" "Opprettet" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"Gruppe.dModified" "Endret" "99/99/9999" "date" ? ? ? ? ? ? no "" no no "11.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"Gruppe.iJBoxCompanyId" "CompanyId" "->,>>>,>>9" "integer" ? ? ? ? ? ? no "" no no "10.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwGruppe */
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


&Scoped-define BROWSE-NAME BrwGruppe
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
{incl/conttrigg.i oBrwGruppe:BROWSE-HANDLE}

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
  DISPLAY iGruppeId GruppeNavn 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE new_tbPerson copy_tbPerson undo_tbPerson save_tbPerson delete_tbPerson 
         refresh_tbPerson filter_tbPerson tbPerson excel_tbPerson 
         Person_tbPerson BrwGruppe iGruppeId GruppeNavn 
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
  IF VALID-OBJECT(oToolbar) THEN RETURN.

  RUN enable_UI.
  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
  
  DO WITH FRAME {&FRAME-NAME}:
    oBrwGruppe = NEW JBoxBrowse(BrwGruppe:HANDLE).
    oBrwGruppe:createGridFilter('').
    oFieldMap = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
    oFieldMap:UpdateFields = "GruppeNavn".
    oFieldMap:DisplayFields = "iGruppeId".
    oFieldMap:BROWSE-OBJECT = oBrwGruppe.
    oToolbar = NEW JBoxToolbar(tbPerson:HANDLE).
    oBrwGruppe:TOOLBAR-OBJECT = oToolbar.
    oFieldMap:TOOLBAR-OBJECT = oToolbar.
  END.

  oBrwGruppe:OpenQuery().
  oContainer:initResize(290,300).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PersonRecord C-Win 
PROCEDURE PersonRecord :
  DEFINE VARIABLE iGroupId AS INTEGER NO-UNDO.
  DEFINE VARIABLE hWindow AS HANDLE NO-UNDO.
  DEFINE VARIABLE lWasSensitive AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lAccepted AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRowIds AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPersonIds AS CHARACTER NO-UNDO.

  IF NOT AVAILABLE Gruppe OR NOT VALID-OBJECT(oBrwGruppe) THEN RETURN.

  iGroupId = Gruppe.iGruppeId.
  cRowIds = JBoxServerAPI:Instance:getRowIdList(
    "PersonGruppe,Person", "",
    "WHERE iGruppeId = " + STRING(iGroupId) + ",FIRST Person OF PersonGruppe NO-LOCK").

  ASSIGN
    hWindow = THIS-PROCEDURE:CURRENT-WINDOW
    lWasSensitive = hWindow:SENSITIVE
    hWindow:SENSITIVE = FALSE.

  DO ON ERROR UNDO, THROW:
    RUN JBoxSelector.w (THIS-PROCEDURE, 0, "Person;iPersonId;cNavn", "where true",
      INPUT-OUTPUT cRowIds, "cNavn,iPersonId", INPUT-OUTPUT cPersonIds,
      "", "", OUTPUT lAccepted).
    FINALLY:
      IF VALID-HANDLE(hWindow) THEN
        hWindow:SENSITIVE = lWasSensitive.
    END FINALLY.
  END.

  IF lAccepted THEN DO:
    IF JBoxServerAPI:Instance:CallServerProc(
      "update_gruppeperson.p", STRING(iGroupId) + "|" + REPLACE(cRowIds, ",", "|")) THEN
      oBrwGruppe:Refresh().
    ELSE
      JBoxServerAPI:Instance:ViewCallMessage().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

