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

/*** Start instance property definitions for JBoxQuery object oQryNPSPTILBUD ***/
DEF VAR oQryNPSPTILBUD AS JBoxQuery NO-UNDO.

DEF TEMP-TABLE NPSPTILBUD
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
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD tilbudsid AS integer
    FIELD tilbudsnr AS character
    FIELD vaar_ref AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    INDEX idxRowids  RowIdent1
    .
DEFINE BUFFER v_NPSPTILBUD FOR NPSPTILBUD.

FUNCTION getTableHandleQryNPSPTILBUD RETURNS HANDLE().
  RETURN BUFFER NPSPTILBUD:HANDLE:TABLE-HANDLE.
END FUNCTION.
FUNCTION getBuffersAndFieldsQryNPSPTILBUD RETURNS CHARACTER().
  RETURN 
      'NPSPTILBUD'.
END FUNCTION.
FUNCTION getQueryJoinQryNPSPTILBUD RETURNS CHARACTER().
  RETURN ''.
END FUNCTION.
/*** End instance property settings for JBoxQuery object oQryNPSPTILBUD ***/

DEF VAR otbNPSPTILBUD AS JBoxToolbar NO-UNDO.
DEF VAR oFmNPSPTILBUD AS JBoxFieldMap NO-UNDO.

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
&Scoped-define INTERNAL-TABLES NPSPTILBUD

/* Definitions for QUERY QUERY-2                                        */
&Scoped-define SELF-NAME QUERY-2
&Scoped-define QUERY-STRING-QUERY-2 FOR EACH NPSPTILBUD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-QUERY-2 OPEN QUERY {&SELF-NAME} FOR EACH NPSPTILBUD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-QUERY-2 NPSPTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-QUERY-2 NPSPTILBUD


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPTILBUD new_tbNPSPTILBUD ~
edit_tbNPSPTILBUD copy_tbNPSPTILBUD undo_tbNPSPTILBUD save_tbNPSPTILBUD ~
anleggsnr kundenr pris bet_bet tilbudsdato rabatt% gyldighetstid deres_ref ~
avgittpris lev_bet vaar_ref opplysninger 
&Scoped-Define DISPLAYED-OBJECTS anleggsnr kundenr pris bet_bet tilbudsdato ~
rabatt% gyldighetstid deres_ref avgittpris lev_bet vaar_ref opplysninger 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPSPTILBUD 
     IMAGE-UP FILE "img\ico\documents.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/documents_disabled.gif":U
     LABEL "Kopier" 
     SIZE 7.8 BY 1.95 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON edit_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_edit.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_edit_disabled.gif":U
     LABEL "Edit" 
     SIZE 7.8 BY 1.95 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON new_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_add.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_add_disabled.gif":U
     LABEL "Ny" 
     SIZE 7.8 BY 1.95 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/floppy_disk_disabled.gif":U
     LABEL "Lagre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Angre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE opplysninger AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 126 BY 1.91 NO-UNDO.

DEFINE VARIABLE anleggsnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Anleggsnr" 
     VIEW-AS FILL-IN 
     SIZE 10.4 BY 1 NO-UNDO.

DEFINE VARIABLE avgittpris AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Avgitt pris" 
     VIEW-AS FILL-IN 
     SIZE 20.2 BY 1.

DEFINE VARIABLE bet_bet AS CHARACTER FORMAT "X(20)" INITIAL "Netto pr. 30 dager" 
     LABEL "Bet. bet." 
     VIEW-AS FILL-IN 
     SIZE 22 BY 1.

DEFINE VARIABLE deres_ref AS CHARACTER FORMAT "X(30)" 
     LABEL "Deres ref." 
     VIEW-AS FILL-IN 
     SIZE 32 BY 1.

DEFINE VARIABLE gyldighetstid AS INTEGER FORMAT ">99" INITIAL 60 
     LABEL "Gyldighetstid" 
     VIEW-AS FILL-IN 
     SIZE 6.2 BY 1.

DEFINE VARIABLE kundenr AS CHARACTER FORMAT "X(8)" 
     LABEL "Kundenr" 
     VIEW-AS FILL-IN 
     SIZE 13.6 BY 1.

DEFINE VARIABLE lev_bet AS CHARACTER FORMAT "X(8)" INITIAL "AB LAGER" 
     LABEL "Lev. bet." 
     VIEW-AS FILL-IN 
     SIZE 23 BY 1.

DEFINE VARIABLE pris AS DECIMAL FORMAT ">>,>>>,>>9.99" INITIAL 0 
     LABEL "Pris" 
     VIEW-AS FILL-IN 
     SIZE 20.2 BY 1.

DEFINE VARIABLE rabatt% AS DECIMAL FORMAT "->>9.99" INITIAL 0 
     LABEL "Rabatt%" 
     VIEW-AS FILL-IN 
     SIZE 11.8 BY 1.

DEFINE VARIABLE tilbudsdato AS DATE FORMAT "99.99.9999" 
     LABEL "Tilbudsdato" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE vaar_ref AS CHARACTER FORMAT "X(25)" 
     LABEL "Vår ref." 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1.

DEFINE RECTANGLE tbNPSPTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 135 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY QUERY-2 FOR 
      NPSPTILBUD SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSPTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 4
     edit_tbNPSPTILBUD AT ROW 1.1 COL 9.2 WIDGET-ID 6
     copy_tbNPSPTILBUD AT ROW 1.1 COL 17 WIDGET-ID 8
     undo_tbNPSPTILBUD AT ROW 1.1 COL 24.8 WIDGET-ID 10
     save_tbNPSPTILBUD AT ROW 1.1 COL 32.6 WIDGET-ID 12
     anleggsnr AT ROW 4.1 COL 16 COLON-ALIGNED
     kundenr AT ROW 4.1 COL 50 COLON-ALIGNED
     pris AT ROW 5.29 COL 16 COLON-ALIGNED
     bet_bet AT ROW 5.29 COL 43
     tilbudsdato AT ROW 5.29 COL 89 COLON-ALIGNED
     rabatt% AT ROW 6.33 COL 16 COLON-ALIGNED
     gyldighetstid AT ROW 6.33 COL 50.2 COLON-ALIGNED
     deres_ref AT ROW 6.33 COL 89 COLON-ALIGNED
     avgittpris AT ROW 7.33 COL 16 COLON-ALIGNED
     lev_bet AT ROW 7.33 COL 50.2 COLON-ALIGNED
     vaar_ref AT ROW 7.33 COL 89 COLON-ALIGNED
     opplysninger AT ROW 9.1 COL 4 NO-LABEL WIDGET-ID 14
     tbNPSPTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 135.2 BY 10.95 WIDGET-ID 100.


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
         HEIGHT             = 10.95
         WIDTH              = 135.2
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 135.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 135.2
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
       FRAME DEFAULT-FRAME:HEIGHT           = 10.95
       FRAME DEFAULT-FRAME:WIDTH            = 135.2.

/* SETTINGS FOR FILL-IN bet_bet IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbNPSPTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,copy;Kopier,undo;Angre,save;Lagremaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK QUERY QUERY-2
/* Query rebuild information for QUERY QUERY-2
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH NPSPTILBUD NO-LOCK INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Design-Parent    is FRAME DEFAULT-FRAME @ ( 5.29 , 114 )
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
  DISPLAY anleggsnr kundenr pris bet_bet tilbudsdato rabatt% gyldighetstid 
          deres_ref avgittpris lev_bet vaar_ref opplysninger 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSPTILBUD new_tbNPSPTILBUD edit_tbNPSPTILBUD copy_tbNPSPTILBUD 
         undo_tbNPSPTILBUD save_tbNPSPTILBUD anleggsnr kundenr pris bet_bet 
         tilbudsdato rabatt% gyldighetstid deres_ref avgittpris lev_bet 
         vaar_ref opplysninger 
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

  oQryNPSPTILBUD = NEW JBoxQuery('NPSPTILBUD').

  otbNPSPTILBUD = NEW JBoxToolbar(tbNPSPTILBUD:HANDLE).

  oQryNPSPTILBUD:TOOLBAR-OBJECT = otbNPSPTILBUD.
  oFmNPSPTILBUD = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSPTILBUD:updateFields = 'anleggsnr,kundenr,avgittpris,bet_bet,deres_ref,gyldighetstid,lev_bet,pris,rabatt%,tilbudsdato,vaar_ref,opplysninger'.
/*  oFmNPSPTILBUD:primaryKeyFields = 'id'.*/

  oFmNPSPTILBUD:QUERY-OBJECT = oQryNPSPTILBUD.
  otbNPSPTILBUD:FIELDMAP-OBJECT = oFmNPSPTILBUD.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  run super.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

