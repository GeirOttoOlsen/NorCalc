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
def var hParent     as handle no-undo.

/* Code for Definitions: */

/*** Start instance property definitions for JBoxQuery object oQryNPSHTILBUD ***/
DEF VAR oQryNPSHTILBUD AS JBoxQuery NO-UNDO.
def var oBrwNPSHTilbud as JBoxBrowse NO-UNDO.
def var oTilbudsdato as JBoxDevExDateEdit no-undo.

DEF TEMP-TABLE NPSHTILBUD
    FIELD anleggsnr AS integer
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD id AS integer
    FIELD kundenr AS character
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD pris AS decimal
    FIELD pris_shuntgrupper AS decimal
    FIELD pris_tillegg AS decimal
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD tilbudsid AS integer
    FIELD tilbudsnr AS character
    FIELD vaar_ref AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1
    .
DEFINE BUFFER v_NPSHTILBUD FOR NPSHTILBUD.

FUNCTION getTableHandleQryNPSHTILBUD RETURNS HANDLE().
  RETURN BUFFER NPSHTILBUD:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPSHTILBUD RETURNS CHARACTER().
  RETURN 
      'NPSHTILBUD'.
END FUNCTION.
FUNCTION getQueryJoinQryNPSHTILBUD RETURNS CHARACTER().
  RETURN ''.
END FUNCTION.
FUNCTION setParent RETURNS logical(input ihParent as handle).
  hParent = ihParent.
  RETURN true.
END FUNCTION.

/*** End instance property settings for JBoxQuery object oQryNPSHTILBUD ***/

DEF VAR oFmNPSHTILBUD AS JBoxFieldMap NO-UNDO.


DEF VAR otbNPSHANLG AS JBoxToolbar NO-UNDO.

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
&Scoped-define INTERNAL-TABLES NPSHTILBUD

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define SELF-NAME QUERY-2
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH NPSHTILBUD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY {&SELF-NAME} FOR EACH NPSHTILBUD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-QUERY-2 NPSHTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 NPSHTILBUD


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHANLG id anleggsnr tilbudsid tilbudsnr ~
kundenr avgittpris vaar_ref pris_shuntgrupper deres_ref pris bet_bet ~
pris_tillegg tilbudsdato rabatt% gyldighetstid save_tbNPSHANLG ~
close_tbNPSHANLG 
&Scoped-Define DISPLAYED-OBJECTS id anleggsnr tilbudsid tilbudsnr kundenr ~
avgittpris vaar_ref pris_shuntgrupper deres_ref pris bet_bet pris_tillegg ~
tilbudsdato rabatt% gyldighetstid 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentBrowse C-Win 
FUNCTION setParentBrowse RETURNS LOGICAL
  (input oParentObject as class JBoxBrowse  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON close_tbNPSHANLG 
     IMAGE-UP FILE "bmp/e-exit.bmp":U
     LABEL "Close" 
     SIZE 7.8 BY 1.95 TOOLTIP "Close (ALT-C)".

DEFINE BUTTON save_tbNPSHANLG 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Lagre (CTRL-S)".

DEFINE VARIABLE bet_bet AS CHARACTER FORMAT "X(20)" INITIAL "Netto pr. 30 dager" 
     LABEL "Betalings bet." 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 22 BY 1.

DEFINE VARIABLE vaar_ref AS CHARACTER FORMAT "X(25)" 
     LABEL "Vår ref." 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","1"
     DROP-DOWN-LIST
     SIZE 27 BY 1.

DEFINE VARIABLE anleggsnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Anleggsnr" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1.

DEFINE VARIABLE avgittpris AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Avgitt pris" 
     VIEW-AS FILL-IN 
     SIZE 20.2 BY 1.

DEFINE VARIABLE deres_ref AS CHARACTER FORMAT "X(30)" 
     LABEL "Deres ref." 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1.

DEFINE VARIABLE gyldighetstid AS INTEGER FORMAT ">99" INITIAL 60 
     LABEL "Gyldighetstid" 
     VIEW-AS FILL-IN 
     SIZE 6.2 BY 1.

DEFINE VARIABLE id AS INTEGER FORMAT ">>>>>>9" INITIAL 0 
     LABEL "ID" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1.

DEFINE VARIABLE kundenr AS CHARACTER FORMAT "X(8)" 
     LABEL "Kundenr" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE pris AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Pris" 
     VIEW-AS FILL-IN 
     SIZE 20.2 BY 1.

DEFINE VARIABLE pris_shuntgrupper AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Pris shuntgruppe" 
     VIEW-AS FILL-IN 
     SIZE 20.2 BY 1.

DEFINE VARIABLE pris_tillegg AS DECIMAL FORMAT ">>>,>>9" INITIAL 0 
     LABEL "Tillegg" 
     VIEW-AS FILL-IN 
     SIZE 11.8 BY 1.

DEFINE VARIABLE rabatt% AS DECIMAL FORMAT "->>9.9" INITIAL 0 
     LABEL "Rabatt%" 
     VIEW-AS FILL-IN 
     SIZE 11.8 BY 1.

DEFINE VARIABLE tilbudsdato AS DATE FORMAT "99/99/9999":U 
     LABEL "Tilbudsdato" 
     VIEW-AS FILL-IN 
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE tilbudsid AS INTEGER FORMAT "9999" INITIAL 0 
     LABEL "Tilbudsid" 
     VIEW-AS FILL-IN 
     SIZE 7.6 BY 1.

DEFINE VARIABLE tilbudsnr AS CHARACTER FORMAT "X(20)" 
     LABEL "Tilbudsnr." 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1.

DEFINE RECTANGLE tbNPSHANLG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 18 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      NPSHTILBUD SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     id AT ROW 1.71 COL 17 COLON-ALIGNED
     anleggsnr AT ROW 2.67 COL 17 COLON-ALIGNED
     tilbudsid AT ROW 3.86 COL 17 COLON-ALIGNED
     tilbudsnr AT ROW 3.86 COL 35 COLON-ALIGNED
     kundenr AT ROW 5.05 COL 17 COLON-ALIGNED
     avgittpris AT ROW 5.76 COL 68 COLON-ALIGNED
     vaar_ref AT ROW 6.24 COL 17 COLON-ALIGNED WIDGET-ID 10
     pris_shuntgrupper AT ROW 6.95 COL 68 COLON-ALIGNED
     deres_ref AT ROW 7.43 COL 17 COLON-ALIGNED
     pris AT ROW 8.14 COL 68 COLON-ALIGNED
     bet_bet AT ROW 8.62 COL 17 COLON-ALIGNED WIDGET-ID 12
     pris_tillegg AT ROW 9.1 COL 68 COLON-ALIGNED
     tilbudsdato AT ROW 9.62 COL 17 COLON-ALIGNED
     rabatt% AT ROW 10.29 COL 68 COLON-ALIGNED
     gyldighetstid AT ROW 10.76 COL 17 COLON-ALIGNED
     save_tbNPSHANLG AT ROW 16.71 COL 90 WIDGET-ID 4
     close_tbNPSHANLG AT ROW 16.71 COL 98 WIDGET-ID 8
     tbNPSHANLG AT ROW 16.48 COL 89 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 110.6 BY 18.1 WIDGET-ID 100.


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
         HEIGHT             = 18.1
         WIDTH              = 110.6
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
       FRAME DEFAULT-FRAME:HEIGHT           = 18.1
       FRAME DEFAULT-FRAME:WIDTH            = 110.6.

ASSIGN 
       tbNPSHANLG:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "save;Lagre,close;Closehide".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH NPSHTILBUD NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 3.62 , 82 )
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
  if valid-handle(hParent) then dynamic-function('freezeWindow' in hParent,false,true).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE closeRecord C-Win 
PROCEDURE closeRecord :
RUN SUPER.


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
  DISPLAY id anleggsnr tilbudsid tilbudsnr kundenr avgittpris vaar_ref 
          pris_shuntgrupper deres_ref pris bet_bet pris_tillegg tilbudsdato 
          rabatt% gyldighetstid 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHANLG id anleggsnr tilbudsid tilbudsnr kundenr avgittpris 
         vaar_ref pris_shuntgrupper deres_ref pris bet_bet pris_tillegg 
         tilbudsdato rabatt% gyldighetstid save_tbNPSHANLG close_tbNPSHANLG 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeComponents C-Win 
PROCEDURE InitializeComponents :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      &IF DEFINED(AdvGuiWin) &THEN
        oTilbudsDato = NEW JBoxDevExDateEdit(THIS-PROCEDURE,Tilbudsdato:HANDLE).
        oTilbudsDato:RegisterWithJukeBox(yes).
        oTilbudsDato:CreateDisplayLink(oFmNPSHTILBUD:BUFFER-HANDLE,"TilbudsDato").
      &Endif
  END.

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
def var iGruppeId_saksbehandler as int no-undo.
RUN enable_UI.
/*
THIS-PROCEDURE:CURRENT-WINDOW:X = JBoxSession:Instance:WindowX.
THIS-PROCEDURE:CURRENT-WINDOW:Y = JBoxSession:Instance:WindowY.
*/ 
this-procedure:current-window:ALWAYS-ON-TOP = true.
oContainer = NEW JBoxContainer().
/*oContainer:addStatusBar().*/

DO WITH FRAME {&FRAME-NAME}:

  oQryNPSHTILBUD = NEW JBoxQuery('NPSHTILBUD').

  oFmNPSHTILBUD = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHTILBUD:updateFields  = 'vaar_ref,deres_ref,bet_bet,kundenr,tilbudsdato,pris,avgittpris,gyldighetstid,pris_tillegg,rabatt%,pris_shuntgrupper'.
  oFmNPSHTILBUD:DisplayFields = 'tilbudsid,id,tilbudsnr,anleggsnr'.

  oFmNPSHTILBUD:QUERY-OBJECT = oQryNPSHTILBUD.
  otbNPSHANLG = NEW JBoxToolbar(tbNPSHANLG:HANDLE).

  oQryNPSHTILBUD:TOOLBAR-OBJECT = otbNPSHANLG.
  oFmNPSHTILBUD:TOOLBAR-OBJECT = otbNPSHANLG.
  assign 
    iGruppeId_saksbehandler       = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Saksbehandler"','iGruppeId')) 
     
    vaar_ref:DELIMITER       = '|'
    vaar_ref:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("PersonGruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_saksbehandler) + ", First Person of PersonGruppe where bAktiv and person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
    bet_bet:DELIMITER       = '|'
    bet_bet:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPBetalingsbetingelse;BetalingsbetingelseKortnavn;iNPBetalingsbetingelseId","WHERE BetalingsbetingelseAktiv BY NPBetalingsbetingelse.BetalingsbetingelseKortnavn")
    .
  RUN InitializeComponents.

END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UndoRecord C-Win 
PROCEDURE UndoRecord :
DO WITH FRAME {&FRAME-NAME}:
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentBrowse C-Win 
FUNCTION setParentBrowse RETURNS LOGICAL
  (input oParentObject as class JBoxBrowse  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    oBrwNPSHTilbud = oParentObject.
    oQryNPSHTILBUD:setParentBrowseObject(oBrwNPSHTilbud,'Id').
    oBrwNPSHTilbud:displayRecord().
    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

