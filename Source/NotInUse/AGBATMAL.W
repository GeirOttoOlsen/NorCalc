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
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

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
&Scoped-define INTERNAL-TABLES NPAGBATMAAL

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NPAGBATMAAL.aggregattype ~
NPAGBATMAAL.batteritype NPAGBATMAAL.hoyde_t NPAGBATMAAL.bredde_a ~
NPAGBATMAAL.VBb1 NPAGBATMAAL.VBb2 NPAGBATMAAL.KBb1 NPAGBATMAAL.KBb2 ~
NPAGBATMAAL.hoyde_h NPAGBATMAAL.lengde_l NPAGBATMAAL.a NPAGBATMAAL.diam_max 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NPAGBATMAAL NO-LOCK ~
    BY NPAGBATMAAL.aggregattype.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NPAGBATMAAL
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NPAGBATMAAL


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS COMBO-BOX-Batteritype RECT-34 BROWSE-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-Batteritype 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Ventiler 
       MENU-ITEM m_Ny           LABEL "&Ny..."         ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre..."      ACCELERATOR "CTRL-E"
       MENU-ITEM m_Slette       LABEL "&Slette..."    .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_Ventiler     LABEL "&Batteri"      
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-Batteritype AS CHARACTER FORMAT "X(6)":U 
     LABEL "Velg batteritype" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "P3012","P60","Alle" 
     SIZE 18.2 BY 1.24 NO-UNDO.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 107.8 BY 15.03.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      NPAGBATMAAL SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      NPAGBATMAAL.aggregattype
      NPAGBATMAAL.batteritype
      NPAGBATMAAL.hoyde_t
      NPAGBATMAAL.bredde_a
      NPAGBATMAAL.VBb1
      NPAGBATMAAL.VBb2
      NPAGBATMAAL.KBb1
      NPAGBATMAAL.KBb2
      NPAGBATMAAL.hoyde_h
      NPAGBATMAAL.lengde_l
      NPAGBATMAAL.a
      NPAGBATMAAL.diam_max
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 100.24 BY 13.21
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     COMBO-BOX-Batteritype AT ROW 1.94 COL 27.84 COLON-ALIGNED
     BROWSE-1 AT ROW 5.07 COL 6.6
     " Definerte Batterimål" VIEW-AS TEXT
          SIZE 35.28 BY .77 AT ROW 3.65 COL 5.2
     RECT-34 AT ROW 4.01 COL 2.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 112 BY 19.81
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
         TITLE              = "Aggregater - Batterimål"
         HEIGHT             = 18.74
         WIDTH              = 111.72
         MAX-HEIGHT         = 22.88
         MAX-WIDTH          = 127.96
         VIRTUAL-HEIGHT     = 22.88
         VIRTUAL-WIDTH      = 127.96
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
     _TblList          = "norcalc.NPAGBATMAAL"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPAGBATMAAL.aggregattype|yes"
     _FldNameList[1]   = norcalc.NPAGBATMAAL.aggregattype
     _FldNameList[2]   = norcalc.NPAGBATMAAL.batteritype
     _FldNameList[3]   = norcalc.NPAGBATMAAL.hoyde_t
     _FldNameList[4]   = norcalc.NPAGBATMAAL.bredde_a
     _FldNameList[5]   = norcalc.NPAGBATMAAL.VBb1
     _FldNameList[6]   = norcalc.NPAGBATMAAL.VBb2
     _FldNameList[7]   = norcalc.NPAGBATMAAL.KBb1
     _FldNameList[8]   = norcalc.NPAGBATMAAL.KBb2
     _FldNameList[9]   = norcalc.NPAGBATMAAL.hoyde_h
     _FldNameList[10]   = norcalc.NPAGBATMAAL.lengde_l
     _FldNameList[11]   = norcalc.NPAGBATMAAL.a
     _FldNameList[12]   = norcalc.NPAGBATMAAL.diam_max
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Aggregater - Batterimål */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Aggregater - Batterimål */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-Batteritype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-Batteritype C-Win
ON VALUE-CHANGED OF COMBO-BOX-Batteritype IN FRAME DEFAULT-FRAME /* Velg batteritype */
DO:
    IF SELF:SCREEN-VALUE = 'Alle' THEN
     OPEN QUERY BROWSE-1 FOR EACH NPAGBATMAAL NO-LOCK
                BY NPAGBATMAAL.aggregattype.
    ELSE  
     OPEN QUERY BROWSE-1 FOR EACH NPAGBATMAAL NO-LOCK
          WHERE NPAGBATMAAL.batteritype BEGINS  SELF:SCREEN-VALUE
                BY NPAGBATMAAL.aggregattype.
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
    Current-Rec = RECID(NPAGBATMAAL).
    RUN AGENBMAL.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
    {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
     REPOSITION BROWSE-1 TO RECID(Current-Rec).
     APPLY 'VALUE-CHANGED' TO BROWSE-1
           IN FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ny C-Win
ON CHOOSE OF MENU-ITEM m_Ny /* Ny... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").   
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata.
    RUN AGNYBMAL.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
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
                cur_rec = ROWID(NPAGBATMAAL). 
                GET PREV BROWSE-1 NO-LOCK.
                forrige = ROWID(NPAGBATMAAL).
                DO TRANSACTION:
                    FIND NPAGBATMAAL WHERE ROWID(NPAGBATMAAL)  = cur_rec  EXCLUSIVE-LOCK
                        NO-ERROR NO-WAIT.
                     IF AVAILABLE(NPAGBATMAAL) THEN
                             DO:
                                 DELETE NPAGBATMAAL.
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
    APPLY "ENTRY" TO COMBO-BOX-BATTERITYPE IN FRAME {&frame-name}.

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
  DISPLAY COMBO-BOX-Batteritype 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE COMBO-BOX-Batteritype RECT-34 BROWSE-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


