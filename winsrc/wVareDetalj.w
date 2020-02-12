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

/*** Start instance property definitions for JBoxQuery object oQryNPVare ***/
DEF VAR oQryNPVare AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE NPVare
    FIELD iNPVaregruppeId AS integer
    FIELD iNPVareId AS integer
    FIELD iNPVareTypeId AS integer
    FIELD NRFnr AS integer
    FIELD Varebeskrivelse AS character
    FIELD VareDimmensjon AS decimal
    FIELD VareEnhetspris AS decimal
    FIELD VareKapasitet AS decimal
    FIELD VareKVverdi AS decimal
    FIELD VareMaxtemperatur AS integer
    FIELD VareMaxtrykk AS integer
    FIELD Varenavn AS character
    FIELD Varenr AS integer
    FIELD VarePipeDimm AS decimal
    FIELD VareVannkapasitet AS decimal
    FIELD VareVeggtykkelse AS decimal
    FIELD iNPVareTypeId2 AS integer
    FIELD VareTypeNavn AS character
    FIELD iNPVaregruppeId3 AS integer
    FIELD VaregruppeAktiv AS logical
    FIELD VaregruppeNavn AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEFINE BUFFER v_NPVare FOR NPVare.

FUNCTION getTableHandleQryNPVare RETURNS HANDLE().
  RETURN BUFFER NPVare:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPVare RETURNS CHARACTER().
  RETURN 
      'NPVare'
    + ',NPVareType'
    + ',NPVaregruppe'.
END FUNCTION.
FUNCTION getQueryJoinQryNPVare RETURNS CHARACTER().
  RETURN 'EACH NPVareType OF NPVare NO-LOCK,EACH NPVaregruppe OF NPVare NO-LOCK'.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryNPVare ***/

DEF VAR oFmNPVare AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPVare AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define QUERY-NAME QUERY-2

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPVare

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define SELF-NAME QUERY-2
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH NPVare NO-LOCK
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY {&SELF-NAME} FOR EACH NPVare NO-LOCK.
&Scoped-define TABLES-IN-QUERY-QUERY-2 NPVare
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 NPVare


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPVare new_tbNPVare edit_tbNPVare ~
copy_tbNPVare undo_tbNPVare save_tbNPVare delete_tbNPVare iNPVareId Varenr ~
NRFnr VareEnhetspris Varenavn VarePipeDimm iNPVaregruppeId VareDimmensjon ~
iNPVareTypeId VareVeggtykkelse VareKapasitet VareMaxtemperatur ~
VareVannkapasitet Varebeskrivelse VareMaxtrykk VareKVverdi 
&Scoped-Define DISPLAYED-OBJECTS iNPVareId Varenr NRFnr VareEnhetspris ~
Varenavn VarePipeDimm iNPVaregruppeId VareDimmensjon iNPVareTypeId ~
VareVeggtykkelse VareKapasitet VareMaxtemperatur VareVannkapasitet ~
Varebeskrivelse VareMaxtrykk VareKVverdi lblVarebeskrivelse 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPVare 
     IMAGE-UP FILE "img/ico/documents.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/documents_disabled.gif":U
     LABEL "Copy" 
     SIZE 7.8 BY 1.95 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPVare 
     IMAGE-UP FILE "img/ico/document_delete.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_delete_disabled.gif":U
     LABEL "Delete" 
     SIZE 7.8 BY 1.95 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON edit_tbNPVare 
     IMAGE-UP FILE "img/ico/document_edit.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_edit_disabled.gif":U
     LABEL "Edit" 
     SIZE 7.8 BY 1.95 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON new_tbNPVare 
     IMAGE-UP FILE "img/ico/document_add.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_add_disabled.gif":U
     LABEL "New" 
     SIZE 7.8 BY 1.95 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON save_tbNPVare 
     IMAGE-UP FILE "img/ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/floppy_disk_disabled.gif":U
     LABEL "Save" 
     SIZE 7.8 BY 1.95 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPVare 
     IMAGE-UP FILE "img/ico/undo.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/undo_disabled.gif":U
     LABEL "Undo" 
     SIZE 7.8 BY 1.95 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE iNPVaregruppeId AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "Varegruppe" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1",1
     DROP-DOWN-LIST
     SIZE 54 BY 1.

DEFINE VARIABLE iNPVareTypeId AS INTEGER FORMAT ">>>>>>>9" INITIAL 0 
     LABEL "VaretypeId" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1",1
     DROP-DOWN-LIST
     SIZE 54 BY 1.

DEFINE VARIABLE Varebeskrivelse AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 55 BY 8.33.

DEFINE VARIABLE iNPVareId AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Id" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1.

DEFINE VARIABLE lblVarebeskrivelse AS CHARACTER FORMAT "X(256)":U INITIAL "Beskrivelse:" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE NRFnr AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "NRFnr" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1.

DEFINE VARIABLE VareDimmensjon AS DECIMAL FORMAT "->>>>>>>9.99" INITIAL 0 
     LABEL "Dimm. (mm)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareEnhetspris AS DECIMAL FORMAT "->,>>>,>>9.99" INITIAL 0 
     LABEL "Enhetspris" 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1.

DEFINE VARIABLE VareKapasitet AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "Volum (m3)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareKVverdi AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "KVverdi" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareMaxtemperatur AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Maks temp (C)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1.

DEFINE VARIABLE VareMaxtrykk AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Makstrykk (bar)" 
     VIEW-AS FILL-IN 
     SIZE 11 BY 1.

DEFINE VARIABLE Varenavn AS CHARACTER FORMAT "x(100)" 
     LABEL "Varenavn" 
     VIEW-AS FILL-IN 
     SIZE 54 BY 1.

DEFINE VARIABLE Varenr AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Varenr" 
     VIEW-AS FILL-IN 
     SIZE 14.6 BY 1.

DEFINE VARIABLE VarePipeDimm AS DECIMAL FORMAT ">>>>>>9.99<" INITIAL 0 
     LABEL "Rørdimm.(mm)" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE VareVannkapasitet AS DECIMAL FORMAT "->>>>>>>9.9999" INITIAL 0 
     LABEL "Vannkap.(m3/h)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE VareVeggtykkelse AS DECIMAL FORMAT ">>>>>9.99<<" INITIAL 0 
     LABEL "Veggtykk.(mm)" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE RECTANGLE tbNPVare
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 106.6 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      NPVare SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPVare AT ROW 1.1 COL 1.2 WIDGET-ID 18
     edit_tbNPVare AT ROW 1.1 COL 9 WIDGET-ID 20
     copy_tbNPVare AT ROW 1.1 COL 17 WIDGET-ID 22
     undo_tbNPVare AT ROW 1.1 COL 24.8 WIDGET-ID 24
     save_tbNPVare AT ROW 1.1 COL 32.8 WIDGET-ID 26
     delete_tbNPVare AT ROW 1.1 COL 40.6 WIDGET-ID 28
     iNPVareId AT ROW 3.38 COL 16 COLON-ALIGNED
     Varenr AT ROW 4.38 COL 16 COLON-ALIGNED
     NRFnr AT ROW 5.38 COL 16 COLON-ALIGNED
     VareEnhetspris AT ROW 6.24 COL 95 COLON-ALIGNED WIDGET-ID 66
     Varenavn AT ROW 6.38 COL 7.6
     VarePipeDimm AT ROW 7.62 COL 134 COLON-ALIGNED WIDGET-ID 76
     iNPVaregruppeId AT ROW 7.67 COL 16 COLON-ALIGNED WIDGET-ID 58
     VareDimmensjon AT ROW 7.67 COL 95 COLON-ALIGNED WIDGET-ID 64
     iNPVareTypeId AT ROW 8.62 COL 16 COLON-ALIGNED WIDGET-ID 60
     VareVeggtykkelse AT ROW 8.62 COL 134 COLON-ALIGNED WIDGET-ID 80
     VareKapasitet AT ROW 8.67 COL 95 COLON-ALIGNED WIDGET-ID 68
     VareMaxtemperatur AT ROW 9.62 COL 134 COLON-ALIGNED WIDGET-ID 72
     VareVannkapasitet AT ROW 9.67 COL 95 COLON-ALIGNED WIDGET-ID 78
     Varebeskrivelse AT ROW 9.81 COL 18 NO-LABEL WIDGET-ID 62
     VareMaxtrykk AT ROW 10.62 COL 134 COLON-ALIGNED WIDGET-ID 74
     VareKVverdi AT ROW 10.67 COL 95 COLON-ALIGNED WIDGET-ID 70
     lblVarebeskrivelse AT ROW 9.81 COL 4 COLON-ALIGNED NO-LABEL
     tbNPVare AT ROW 1 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 155.4 BY 17.71 WIDGET-ID 100.


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
         HEIGHT             = 17.71
         WIDTH              = 155.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 155.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 155.4
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
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 17.71
       FRAME DEFAULT-FRAME:WIDTH            = 155.4.

/* SETTINGS FOR FILL-IN lblVarebeskrivelse IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       lblVarebeskrivelse:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Beskrivelse:".

ASSIGN 
       tbNPVare:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,edit;Edit,copy;Copy,undo;Undo,save;Save,delete;Deletemaxborder".

/* SETTINGS FOR FILL-IN Varenavn IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH NPVare NO-LOCK
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 2.43 , 89 )
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
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */

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
  DISPLAY iNPVareId Varenr NRFnr VareEnhetspris Varenavn VarePipeDimm 
          iNPVaregruppeId VareDimmensjon iNPVareTypeId VareVeggtykkelse 
          VareKapasitet VareMaxtemperatur VareVannkapasitet Varebeskrivelse 
          VareMaxtrykk VareKVverdi lblVarebeskrivelse 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPVare new_tbNPVare edit_tbNPVare copy_tbNPVare undo_tbNPVare 
         save_tbNPVare delete_tbNPVare iNPVareId Varenr NRFnr VareEnhetspris 
         Varenavn VarePipeDimm iNPVaregruppeId VareDimmensjon iNPVareTypeId 
         VareVeggtykkelse VareKapasitet VareMaxtemperatur VareVannkapasitet 
         Varebeskrivelse VareMaxtrykk VareKVverdi 
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

  oQryNPVare = NEW JBoxQuery('NPVare').

  oFmNPVare = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPVare:updateFields  = 'Varenr,NRFnr,Varenavn,Varebeskrivelse,iNPVaregruppeId,iNPVareTypeId,VareDimmensjon,VareEnhetspris,VareKapasitet,VareKVverdi,VareMaxtemperatur,VareMaxtrykk,VarePipeDimm,VareVannkapasitet,VareVeggtykkelse'.
  oFmNPVare:DisplayFields = 'iNPVareId'.
  oFmNPVare:customUpdateValProc = '='. /*Hopper over dynamisk validation*/
  oFmNPVare:QUERY-OBJECT = oQryNPVare.
  otbNPVare = NEW JBoxToolbar(tbNPVare:HANDLE).

  oQryNPVare:TOOLBAR-OBJECT = otbNPVare.
  oFmNPVare:TOOLBAR-OBJECT = otbNPVare.
  
  assign 
    iNPVaregruppeId:DELIMITER = '|'
    iNPVaregruppeId:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('NPVareGruppe;VareGruppeNavn;iNPVareGruppeId','where VareGruppeAktiv = true')
    iNPVareTypeId:DELIMITER = '|'
    iNPVareTypeId:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList('NPVareType;VareTypeNavn;iNPVareTypeId','where true')
    .
  
END.


oContainer:initResize().
oContainer:setNoResizeX('Varebeskrivelse').
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

