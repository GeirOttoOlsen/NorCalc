&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER appdata AS CHARACTER.

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VAR Current-Rec AS  RECID.
DEFINE NEW SHARED VAR nyRecord AS LOGICAL INITIAL FALSE.
DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR Detail-Handle AS HANDLE.
DEFINE VAR p-handle AS HANDLE.

/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN
    THIS-PROCEDURE:PRIVATE-DATA = appdata.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPAGKABMAAL

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NPAGKABMAAL.aggregattype ~
NPAGKABMAAL.isolasjon NPAGKABMAAL.hoyde NPAGKABMAAL.bredde ~
NPAGKABMAAL.fratrekksmaal NPAGKABMAAL.hoydereduksjon ~
NPAGKABMAAL.fundament_hoyde NPAGKABMAAL.innv_hoyde_litenh ~
NPAGKABMAAL.innv_hoyde_storH NPAGKABMAAL.standard_vifte 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NPAGKABMAAL NO-LOCK ~
    BY NPAGKABMAAL.aggregattype ~
       BY NPAGKABMAAL.isolasjon.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NPAGKABMAAL
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NPAGKABMAAL


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGKABMAAL.hoyde 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}hoyde ~{&FP2}hoyde ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGKABMAAL
&Scoped-define FIRST-ENABLED-TABLE NPAGKABMAAL
&Scoped-Define ENABLED-OBJECTS RECT-34 BROWSE-1 
&Scoped-Define DISPLAYED-FIELDS NPAGKABMAAL.hoyde 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Kabinett 
       MENU-ITEM m_Nye          LABEL "&Nye..."        ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre..."      ACCELERATOR "CTRL-E"
       MENU-ITEM m_Slette       LABEL "&Slette..."    .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_Kabinett     LABEL "&Kabinett"     
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      .


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78.2 BY 12.05.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      NPAGKABMAAL SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      NPAGKABMAAL.aggregattype
      NPAGKABMAAL.isolasjon
      NPAGKABMAAL.hoyde
      NPAGKABMAAL.bredde
      NPAGKABMAAL.fratrekksmaal
      NPAGKABMAAL.hoydereduksjon
      NPAGKABMAAL.fundament_hoyde
      NPAGKABMAAL.innv_hoyde_litenh
      NPAGKABMAAL.innv_hoyde_storH
      NPAGKABMAAL.standard_vifte
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 75.2 BY 10.67
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BROWSE-1 AT ROW 2.38 COL 3.8
     NPAGKABMAAL.hoyde AT ROW 13.57 COL 49.2 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1.2 BY 1
     "Definerte Kabinettmål" VIEW-AS TEXT
          SIZE 27 BY .62 AT ROW 1.33 COL 4.4
     RECT-34 AT ROW 1.67 COL 2.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 80 BY 16
         FONT 2.


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
         TITLE              = "Aggregater - Kabinettmål"
         COLUMN             = 22.4
         ROW                = 3.1
         HEIGHT             = 13.86
         WIDTH              = 80.2
         MAX-HEIGHT         = 18.48
         MAX-WIDTH          = 91.4
         VIRTUAL-HEIGHT     = 18.48
         VIRTUAL-WIDTH      = 91.4
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.

IF NOT C-Win:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.

IF NOT C-Win:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-1 RECT-34 DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "norcalc.NPAGKABMAAL"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPAGKABMAAL.aggregattype|yes,norcalc.NPAGKABMAAL.isolasjon|yes"
     _FldNameList[1]   = norcalc.NPAGKABMAAL.aggregattype
     _FldNameList[2]   = norcalc.NPAGKABMAAL.isolasjon
     _FldNameList[3]   = norcalc.NPAGKABMAAL.hoyde
     _FldNameList[4]   = norcalc.NPAGKABMAAL.bredde
     _FldNameList[5]   = norcalc.NPAGKABMAAL.fratrekksmaal
     _FldNameList[6]   = norcalc.NPAGKABMAAL.hoydereduksjon
     _FldNameList[7]   = norcalc.NPAGKABMAAL.fundament_hoyde
     _FldNameList[8]   = norcalc.NPAGKABMAAL.innv_hoyde_litenh
     _FldNameList[9]   = norcalc.NPAGKABMAAL.innv_hoyde_storH
     _FldNameList[10]   = norcalc.NPAGKABMAAL.standard_vifte
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Aggregater - Kabinettmål */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Aggregater - Kabinettmål */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt C-Win
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY 'CLOSE' TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre C-Win
ON CHOOSE OF MENU-ITEM m_Endre /* Endre... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata.
    Current-Rec = RECID(NPAGKABMAAL).
    RUN AGENKMAL.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
    {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
     REPOSITION BROWSE-1 TO RECID(Current-Rec).
     APPLY 'VALUE-CHANGED' TO BROWSE-1
           IN FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nye
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nye C-Win
ON CHOOSE OF MENU-ITEM m_Nye /* Nye... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").   
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata.
    RUN AGNYKMAL.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
    IF nyRecord THEN
        DO:
            {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
            REPOSITION BROWSE-1 TO RECID(Current-Rec).
            APPLY 'VALUE-CHANGED' TO BROWSE-1
                IN FRAME {&FRAME-NAME}.
            
        END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette C-Win
ON CHOOSE OF MENU-ITEM m_Slette /* Slette... */
DO:
    DEFINE VAR cur_rec AS ROWID.
    DEFINE VAR forrige AS ROWID.
            
      MESSAGE "Vil du slette dette batterimålet?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      IF  choice THEN
          DO:
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                cur_rec = ROWID(NPAGKABMAAL). 
                GET PREV BROWSE-1 NO-LOCK.
                forrige = ROWID(NPAGKABMAAL).
                DO TRANSACTION:
                    FIND NPAGKABMAAL WHERE ROWID(NPAGKABMAAL)  = cur_rec  EXCLUSIVE-LOCK
                        NO-ERROR NO-WAIT.
                     IF AVAILABLE(NPAGKABMAAL) THEN
                             DO:
                                 DELETE NPAGKABMAAL.
                                  pointer = SESSION:SET-WAIT-STATE("").
                                 {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}                                
                                REPOSITION BROWSE-1 TO ROWID(forrige).
                                IF ERROR-STATUS:ERROR THEN
                                    REPOSITION BROWSE-1 TO RECID(Current-Rec).
                            END.
                    ELSE
                          RETURN.
                END.
           END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  /* Clean up related Detail or Child windows if present. */
  IF VALID-HANDLE(Detail-Handle) THEN
    APPLY "CLOSE" TO Detail-Handle.
  RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
    pointer = SESSION:SET-WAIT-STATE("").   

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent C-Win 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "ENTRY" TO NPAGKABMAAL.hoyde IN FRAME {&frame-name}.
    DISABLE hoyde WITH FRAME {&frame-name}.
    HIDE hoyde.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win _DEFAULT-ENABLE
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
  IF AVAILABLE NPAGKABMAAL THEN 
    DISPLAY NPAGKABMAAL.hoyde 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-34 BROWSE-1 NPAGKABMAAL.hoyde 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


