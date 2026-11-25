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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHTILLEGG ***/
DEF VAR oBrwNPSHTILLEGG AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHTILLEGG
    FIELD id AS integer
    FIELD artikkelnr AS character
    FIELD artikkelnavn AS character
    FIELD antall AS integer
    FIELD kostpris AS decimal
    FIELD pris AS decimal
    FIELD paaslag_faktor AS decimal
    FIELD med_i_ordre AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHTILLEGG FOR TEMP-TABLE NPSHTILLEGG.


FUNCTION getBuffersAndFieldsBrwNPSHTILLEGG RETURNS CHARACTER():
  RETURN
    'NPSHTILLEGG'
     + ';id'
     + ';artikkelnr'
     + ';artikkelnavn'
     + ';antall'
     + ';kostpris'
     + ';pris'
     + ';paaslag_faktor'
     + ';med_i_ordre'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHTILLEGG RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPSHTILLEGG AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHTILLEGG

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTILLEGG

/* Definitions for BROWSE BrwNPSHTILLEGG                                */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHTILLEGG NPSHTILLEGG.id ~
NPSHTILLEGG.artikkelnr NPSHTILLEGG.artikkelnavn NPSHTILLEGG.antall ~
NPSHTILLEGG.kostpris NPSHTILLEGG.pris NPSHTILLEGG.paaslag_faktor ~
NPSHTILLEGG.med_i_ordre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHTILLEGG NPSHTILLEGG.id 
&Scoped-define QUERY-STRING-BrwNPSHTILLEGG FOR EACH NPSHTILLEGG NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHTILLEGG OPEN QUERY BrwNPSHTILLEGG FOR EACH NPSHTILLEGG NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHTILLEGG NPSHTILLEGG
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHTILLEGG NPSHTILLEGG


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHTILLEGG new_tbNPSHTILLEGG ~
undo_tbNPSHTILLEGG save_tbNPSHTILLEGG delete_tbNPSHTILLEGG BrwNPSHTILLEGG ~
artikkelnr btnartikkelnr med_i_ordre artikkelnavn antall kostpris ~
paaslag_faktor pris 
&Scoped-Define DISPLAYED-OBJECTS artikkelnr med_i_ordre artikkelnavn antall ~
kostpris paaslag_faktor pris 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnartikkelnr 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON delete_tbNPSHTILLEGG 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 7.75 BY 1.94 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON new_tbNPSHTILLEGG 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 7.75 BY 1.94 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON save_tbNPSHTILLEGG 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 7.75 BY 1.94 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPSHTILLEGG 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 7.75 BY 1.94 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE antall AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Antall" 
     VIEW-AS FILL-IN 
     SIZE 6.25 BY 1.

DEFINE VARIABLE artikkelnavn AS CHARACTER FORMAT "X(30)" 
     LABEL "Artikkelnavn" 
     VIEW-AS FILL-IN 
     SIZE 49 BY 1.

DEFINE VARIABLE artikkelnr AS CHARACTER FORMAT "X(8)" 
     LABEL "Artikkelnr" 
     VIEW-AS FILL-IN 
     SIZE 13.63 BY 1.

DEFINE VARIABLE kostpris AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "Kostpris" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE paaslag_faktor AS DECIMAL FORMAT "9.99" INITIAL 0 
     LABEL "Påslag" 
     VIEW-AS FILL-IN 
     SIZE 7.63 BY 1.

DEFINE VARIABLE pris AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     LABEL "Pris" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE RECTANGLE tbNPSHTILLEGG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 132 BY 2.13.

DEFINE VARIABLE med_i_ordre AS LOGICAL INITIAL no 
     LABEL "Med i ordre" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHTILLEGG FOR 
      NPSHTILLEGG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHTILLEGG
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHTILLEGG C-Win _STRUCTURED
  QUERY BrwNPSHTILLEGG NO-LOCK DISPLAY
      NPSHTILLEGG.id COLUMN-LABEL "Tilbudsnr" FORMAT ">>>>>>":U
            WIDTH 8.63
      NPSHTILLEGG.artikkelnr COLUMN-LABEL "Artikkelnr" FORMAT "X(8)":U
            WIDTH 8.75
      NPSHTILLEGG.artikkelnavn COLUMN-LABEL "Artikkelnavn" FORMAT "X(30)":U
      NPSHTILLEGG.antall COLUMN-LABEL "Antall" FORMAT ">>9":U WIDTH 5.25
      NPSHTILLEGG.kostpris COLUMN-LABEL "Kostpris" FORMAT ">>>,>>9.99":U
            WIDTH 10.75
      NPSHTILLEGG.pris COLUMN-LABEL "Pris" FORMAT ">>>,>>9.99":U
            WIDTH 10.75
      NPSHTILLEGG.paaslag_faktor COLUMN-LABEL "Påslag" FORMAT "9.99":U
            WIDTH 6.38
      NPSHTILLEGG.med_i_ordre COLUMN-LABEL "Ordre" FORMAT "ja/nei":U
            WIDTH 36.25
  ENABLE
      NPSHTILLEGG.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 63 BY 8.13 ROW-HEIGHT-CHARS .57 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHTILLEGG AT ROW 1.09 COL 1.25 WIDGET-ID 18
     undo_tbNPSHTILLEGG AT ROW 1.09 COL 9 WIDGET-ID 20
     save_tbNPSHTILLEGG AT ROW 1.09 COL 17 WIDGET-ID 22
     delete_tbNPSHTILLEGG AT ROW 1.09 COL 24.75 WIDGET-ID 24
     BrwNPSHTILLEGG AT ROW 3.38 COL 1 WIDGET-ID 200
     artikkelnr AT ROW 3.75 COL 75 COLON-ALIGNED
     btnartikkelnr AT ROW 3.75 COL 90.63 WIDGET-ID 28 NO-TAB-STOP 
     med_i_ordre AT ROW 3.88 COL 111 WIDGET-ID 26
     artikkelnavn AT ROW 4.88 COL 75 COLON-ALIGNED
     antall AT ROW 6.13 COL 75 COLON-ALIGNED
     kostpris AT ROW 7.38 COL 75 COLON-ALIGNED
     paaslag_faktor AT ROW 8.53 COL 75 COLON-ALIGNED
     pris AT ROW 9.63 COL 75 COLON-ALIGNED
     tbNPSHTILLEGG AT ROW 1 COL 1 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 132.13 BY 10.53 WIDGET-ID 100.


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
         HEIGHT             = 10.63
         WIDTH              = 132.25
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 169.5
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 169.5
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
/* BROWSE-TAB BrwNPSHTILLEGG delete_tbNPSHTILLEGG DEFAULT-FRAME */
ASSIGN 
       tbNPSHTILLEGG:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,undo;Angre,save;Lagre,delete;Slettmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHTILLEGG
/* Query rebuild information for BROWSE BrwNPSHTILLEGG
     _TblList          = "norcalc.NPSHTILLEGG"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHTILLEGG.id" "Tilbudsnr" ">>>>>>" "integer" ? ? ? ? ? ? yes "" no no "8.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHTILLEGG.artikkelnr" "Artikkelnr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHTILLEGG.artikkelnavn" "Artikkelnavn" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHTILLEGG.antall" "Antall" ">>9" "integer" ? ? ? ? ? ? no "" no no "5.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHTILLEGG.kostpris" "Kostpris" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHTILLEGG.pris" "Pris" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHTILLEGG.paaslag_faktor" "Påslag" "9.99" "decimal" ? ? ? ? ? ? no "" no no "6.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHTILLEGG.med_i_ordre" "Ordre" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "36.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHTILLEGG */
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


&Scoped-define SELF-NAME btnartikkelnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnartikkelnr C-Win
ON CHOOSE OF btnartikkelnr IN FRAME DEFAULT-FRAME /* ... */
DO:
  /* To manipulate the lookup query object add the callback procedure hook "myLookupObject" 
     (probably use "WHERE false" as the initial query in this case) */
  
  JBoxServerAPI:Instance:Lookup("NPagart"
                    + ";artikkelnr"
                    + ";artikkelnavn"
                   ,"WHERE true"
                   ,"artikkelnr,artikkelnavn"   /* <- return values for these fields */
                    ).

  IF JBoxServerAPI:Instance:LookupOk THEN DO:
    ASSIGN 
      artikkelnr:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("NPagart.artikkelnr")
      artikkelnavn:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("NPagart.artikkelnavn")      
      .

    APPLY "any-printable" TO artikkelnr.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHTILLEGG
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
{incl/conttrigg.i oBrwNPSHTILLEGG:BROWSE-HANDLE}

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
  DISPLAY artikkelnr med_i_ordre artikkelnavn antall kostpris paaslag_faktor 
          pris 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHTILLEGG new_tbNPSHTILLEGG undo_tbNPSHTILLEGG save_tbNPSHTILLEGG 
         delete_tbNPSHTILLEGG BrwNPSHTILLEGG artikkelnr btnartikkelnr 
         med_i_ordre artikkelnavn antall kostpris paaslag_faktor pris 
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

  oBrwNPSHTILLEGG = NEW JBoxBrowse(brwNPSHTILLEGG:HANDLE).

  oFmNPSHTILLEGG = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHTILLEGG:updateFields = 'artikkelnavn,antall,kostpris,med_i_ordre,paaslag_faktor,pris'.
  oFmNPSHTILLEGG:displayFields = 'artikkelnr'.
  oFmNPSHTILLEGG:bufferExtraFields = 'id,artikkenr'.
  oFmNPSHTILLEGG:BROWSE-OBJECT = oBrwNPSHTILLEGG.
  NorcalcBrowseWindow:ConnectToolbar(THIS-PROCEDURE, tbNPSHTILLEGG:HANDLE, oBrwNPSHTILLEGG, oFmNPSHTILLEGG).
END.
oBrwNPSHTILLEGG:OpenQuery().


oContainer:initResize(300,300).

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
    WHEN "artikkelnr" THEN artikkelnavn:SCREEN-VALUE = JBoxServerAPI:Instance:FieldValues("NPagart","WHERE artikkelnr = '" + ihField:SCREEN-VALUE + "'","artikkelnavn").
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

