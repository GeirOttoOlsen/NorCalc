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


/*** Start instance property definitions for JBoxBrowse object oBrwJBoxContact ***/
DEF VAR oBrwJBoxContact AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE JBoxContact
    FIELD iJBoxContactId AS integer
    FIELD cContactName AS character
    FIELD cFirstContactName AS character
    FIELD cLastContactName AS character
    FIELD cEmail AS character
    FIELD cTlfMob AS character
    FIELD cTlfWrk AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_JBoxContact FOR TEMP-TABLE JBoxContact.


FUNCTION getBuffersAndFieldsBrwJBoxContact RETURNS CHARACTER():
  RETURN
    'JBoxContact'
     + ';iJBoxContactId'
     + ';cContactName'
     + ';cFirstContactName'
     + ';cLastContactName'
     + ';cEmail'
     + ';cTlfMob'
     + ';cTlfWrk'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwJBoxContact RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmJBoxContact AS JBoxFieldMap NO-UNDO.
DEF VAR otbJBoxContact AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwJBoxContact

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES JBoxContact

/* Definitions for BROWSE BrwJBoxContact                                */
&Scoped-define FIELDS-IN-QUERY-BrwJBoxContact JBoxContact.iJBoxContactId ~
JBoxContact.cContactName JBoxContact.cFirstContactName ~
JBoxContact.cLastContactName JBoxContact.cEmail JBoxContact.cTlfMob ~
JBoxContact.cTlfWrk 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwJBoxContact ~
JBoxContact.iJBoxContactId 
&Scoped-define QUERY-STRING-BrwJBoxContact FOR EACH JBoxContact NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwJBoxContact OPEN QUERY BrwJBoxContact FOR EACH JBoxContact NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwJBoxContact JBoxContact
&Scoped-define FIRST-TABLE-IN-QUERY-BrwJBoxContact JBoxContact


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbJBoxContact new_tbJBoxContact ~
copy_tbJBoxContact undo_tbJBoxContact save_tbJBoxContact ~
delete_tbJBoxContact refresh_tbJBoxContact filter_tbJBoxContact ~
excel_tbJBoxContact BrwJBoxContact iJBoxContactId cContactName ~
cFirstContactName cLastContactName cEmail cTlfMob cTlfWrk 
&Scoped-Define DISPLAYED-OBJECTS iJBoxContactId cContactName ~
cFirstContactName cLastContactName cEmail cTlfMob cTlfWrk 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbJBoxContact 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 6 BY 1.52 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbJBoxContact 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 6 BY 1.52 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbJBoxContact 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 6 BY 1.52 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbJBoxContact 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbJBoxContact 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 6 BY 1.52 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON refresh_tbJBoxContact 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbJBoxContact 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 6 BY 1.52 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbJBoxContact 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 6 BY 1.52 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE cContactName AS CHARACTER FORMAT "x(40)" 
     LABEL "Navn" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1.

DEFINE VARIABLE cEmail AS CHARACTER FORMAT "x(60)" 
     LABEL "Epost" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1.

DEFINE VARIABLE cFirstContactName AS CHARACTER FORMAT "x(40)" 
     LABEL "Fornavn" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1.

DEFINE VARIABLE cLastContactName AS CHARACTER FORMAT "x(40)" 
     LABEL "Etternavn" 
     VIEW-AS FILL-IN 
     SIZE 42 BY 1.

DEFINE VARIABLE cTlfMob AS CHARACTER FORMAT "x(15)" 
     LABEL "Mobil" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE VARIABLE cTlfWrk AS CHARACTER FORMAT "x(15)" 
     LABEL "Tlf.jobb" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1.

DEFINE VARIABLE iJBoxContactId AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Id" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE RECTANGLE tbJBoxContact
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 117.8 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwJBoxContact FOR 
      JBoxContact SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwJBoxContact
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwJBoxContact C-Win _STRUCTURED
  QUERY BrwJBoxContact NO-LOCK DISPLAY
      JBoxContact.iJBoxContactId COLUMN-LABEL "Id" FORMAT "->,>>>,>>9":U
      JBoxContact.cContactName COLUMN-LABEL "Kontakt" FORMAT "x(40)":U
      JBoxContact.cFirstContactName COLUMN-LABEL "Fornavn" FORMAT "x(40)":U
      JBoxContact.cLastContactName COLUMN-LABEL "Etternavn" FORMAT "x(40)":U
      JBoxContact.cEmail COLUMN-LABEL "Epost" FORMAT "x(60)":U
      JBoxContact.cTlfMob COLUMN-LABEL "Mobil" FORMAT "x(15)":U
      JBoxContact.cTlfWrk COLUMN-LABEL "Tlf.jobb" FORMAT "x(15)":U
  ENABLE
      JBoxContact.iJBoxContactId
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 56 BY 11.1 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbJBoxContact AT ROW 1.1 COL 1.2 WIDGET-ID 18
     copy_tbJBoxContact AT ROW 1.1 COL 7.2 WIDGET-ID 20
     undo_tbJBoxContact AT ROW 1.1 COL 13.4 WIDGET-ID 22
     save_tbJBoxContact AT ROW 1.1 COL 19.4 WIDGET-ID 24
     delete_tbJBoxContact AT ROW 1.1 COL 25.6 WIDGET-ID 26
     refresh_tbJBoxContact AT ROW 1.1 COL 31.6 WIDGET-ID 28
     filter_tbJBoxContact AT ROW 1.1 COL 37.8 WIDGET-ID 30
     excel_tbJBoxContact AT ROW 1.1 COL 43.8 WIDGET-ID 32
     BrwJBoxContact AT ROW 2.67 COL 1 WIDGET-ID 200
     iJBoxContactId AT ROW 3.1 COL 69 COLON-ALIGNED
     cContactName AT ROW 4.1 COL 69 COLON-ALIGNED
     cFirstContactName AT ROW 5.1 COL 69 COLON-ALIGNED
     cLastContactName AT ROW 6.1 COL 69 COLON-ALIGNED
     cEmail AT ROW 7.14 COL 69 COLON-ALIGNED
     cTlfMob AT ROW 8.14 COL 69 COLON-ALIGNED
     cTlfWrk AT ROW 9.19 COL 69 COLON-ALIGNED
     tbJBoxContact AT ROW 1 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 118.8 BY 12.76 WIDGET-ID 100.


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
         TITLE              = "Vedlikehold kontakt"
         HEIGHT             = 12.76
         WIDTH              = 118.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 118.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 118.8
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
/* BROWSE-TAB BrwJBoxContact excel_tbJBoxContact DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 12.76
       FRAME DEFAULT-FRAME:WIDTH            = 118.8.

ASSIGN 
       tbJBoxContact:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,refresh;Refresh,filter;Filter,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwJBoxContact
/* Query rebuild information for BROWSE BrwJBoxContact
     _TblList          = "norcalc.JBoxContact"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"JBoxContact.iJBoxContactId" "Id" "->,>>>,>>9" "integer" ? ? ? ? ? ? yes "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"JBoxContact.cContactName" "Kontakt" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"JBoxContact.cFirstContactName" "Fornavn" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"JBoxContact.cLastContactName" "Etternavn" "x(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"JBoxContact.cEmail" "Epost" "x(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"JBoxContact.cTlfMob" "Mobil" "x(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"JBoxContact.cTlfWrk" "Tlf.jobb" "x(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwJBoxContact */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Vedlikehold kontakt */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Vedlikehold kontakt */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwJBoxContact
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
{incl/conttrigg.i oBrwJBoxContact:BROWSE-HANDLE}

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
  DISPLAY iJBoxContactId cContactName cFirstContactName cLastContactName cEmail 
          cTlfMob cTlfWrk 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbJBoxContact new_tbJBoxContact copy_tbJBoxContact undo_tbJBoxContact 
         save_tbJBoxContact delete_tbJBoxContact refresh_tbJBoxContact 
         filter_tbJBoxContact excel_tbJBoxContact BrwJBoxContact iJBoxContactId 
         cContactName cFirstContactName cLastContactName cEmail cTlfMob cTlfWrk 
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

  oBrwJBoxContact = NEW JBoxBrowse(brwJBoxContact:HANDLE).
  oBrwJBoxContact:baseQuery = 'where iJBoxCompanyId = ' + dynamic-function('getCompanyId').
  
  oFmJBoxContact = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmJBoxContact:updateFields = 'iJBoxContactId,cContactName,cFirstContactName,cLastContactName,cEmail,cTlfMob,cTlfWrk'.
  oFmJBoxContact:primaryKeyFields = 'iJBoxContactId'.
  oFmJBoxContact:bufferExtraFields = 'iJBoxCompanyId'.
  oFmJBoxContact:bufferExtraValues = dynamic-function('getCompanyId').
  oFmJBoxContact:BROWSE-OBJECT = oBrwJBoxContact.
  otbJBoxContact = NEW JBoxToolbar(tbJBoxContact:HANDLE).
  oBrwJBoxContact:TOOLBAR-OBJECT = otbJBoxContact.
  oFmJBoxContact:TOOLBAR-OBJECT = otbJBoxContact.
END.
oBrwJBoxContact:OpenQuery().


oContainer:initResize(400,200).

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

