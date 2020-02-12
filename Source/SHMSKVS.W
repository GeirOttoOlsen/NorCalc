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
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHMKVS

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NPSHMKVS.ventiltype ~
NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi NPSHMKVS.sorteringsDimmensjon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define QUERY-STRING-BROWSE-1 FOR EACH NPSHMKVS NO-LOCK ~
    BY NPSHMKVS.ventiltype ~
       BY NPSHMKVS.sorteringsDimmensjon ~
        BY NPSHMKVS.kvs_verdi
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NPSHMKVS NO-LOCK ~
    BY NPSHMKVS.ventiltype ~
       BY NPSHMKVS.sorteringsDimmensjon ~
        BY NPSHMKVS.kvs_verdi.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NPSHMKVS
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NPSHMKVS


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-34 COMBO-BOX-VENTILTYPE BROWSE-1 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-VENTILTYPE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Ventiler 
       MENU-ITEM m_Nye          LABEL "&Nye..."       
       MENU-ITEM m_Endre        LABEL "&Endre..."     
       MENU-ITEM m_Slette       LABEL "&Slette..."    .

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  m_Ventiler     LABEL "&Ventiler"     
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-VENTILTYPE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vis verdier for ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 21 BY 1
     FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-34
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 91.6 BY 12.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      NPSHMKVS SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 C-Win _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      NPSHMKVS.ventiltype FORMAT "X(20)":U COLUMN-FONT 2
      NPSHMKVS.shunt_dimmensjon FORMAT "X(3)":U COLUMN-FONT 2
      NPSHMKVS.kvs_verdi FORMAT "->>,>>9.99":U COLUMN-FONT 2
      NPSHMKVS.sorteringsDimmensjon FORMAT ">>>>>>>9":U COLUMN-FONT 2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82.8 BY 11.05
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     COMBO-BOX-VENTILTYPE AT ROW 1.81 COL 38.2 COLON-ALIGNED
     BROWSE-1 AT ROW 3.95 COL 8
     " KVS-Verdier for valgt ventiltype" VIEW-AS TEXT
          SIZE 39.4 BY .91 AT ROW 3.05 COL 8.2
     RECT-34 AT ROW 3.43 COL 3.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 95.8 BY 16
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
         TITLE              = "KVS-Verdier for MS-Ventiler"
         HEIGHT             = 15.62
         WIDTH              = 95.8
         MAX-HEIGHT         = 18.48
         MAX-WIDTH          = 95.8
         VIRTUAL-HEIGHT     = 18.48
         VIRTUAL-WIDTH      = 95.8
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT C-Win:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-1 COMBO-BOX-VENTILTYPE DEFAULT-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "norcalc.NPSHMKVS"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPSHMKVS.ventiltype|yes,norcalc.NPSHMKVS.sorteringsDimmensjon|yes,norcalc.NPSHMKVS.kvs_verdi|yes"
     _FldNameList[1]   > norcalc.NPSHMKVS.ventiltype
"NPSHMKVS.ventiltype" ? ? "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > norcalc.NPSHMKVS.shunt_dimmensjon
"NPSHMKVS.shunt_dimmensjon" ? ? "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > norcalc.NPSHMKVS.kvs_verdi
"NPSHMKVS.kvs_verdi" ? ? "decimal" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > norcalc.NPSHMKVS.sorteringsDimmensjon
"NPSHMKVS.sorteringsDimmensjon" ? ? "integer" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* KVS-Verdier for MS-Ventiler */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* KVS-Verdier for MS-Ventiler */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-VENTILTYPE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE C-Win
ON ANY-PRINTABLE OF COMBO-BOX-VENTILTYPE IN FRAME DEFAULT-FRAME /* Vis verdier for ventiltype */
DO:
  seek-item:
  DO i = 1 TO SELF:NUM-ITEMS:
    IF SELF:ENTRY(i) BEGINS LAST-EVENT:FUNCTION
    THEN DO:
        SELF:SCREEN-VALUE = SELF:ENTRY(i).
        LEAVE seek-item.
    END.
  END.
  IF i > SELF:NUM-ITEMS
  THEN BELL.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE C-Win
ON CURSOR-DOWN OF COMBO-BOX-VENTILTYPE IN FRAME DEFAULT-FRAME /* Vis verdier for ventiltype */
DO:
  i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE C-Win
ON CURSOR-UP OF COMBO-BOX-VENTILTYPE IN FRAME DEFAULT-FRAME /* Vis verdier for ventiltype */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE C-Win
ON VALUE-CHANGED OF COMBO-BOX-VENTILTYPE IN FRAME DEFAULT-FRAME /* Vis verdier for ventiltype */
DO:
   OPEN QUERY BROWSE-1 FOR EACH NPSHMKVS NO-LOCK
          WHERE NPSHMKVS.ventiltype =  SELF:SCREEN-VALUE 
                BY NPSHMKVS.ventiltype
                    BY NPSHMKVS.sorteringsDimmensjon
                        BY NPSHMKVS.kvs_verdi.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt C-Win
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY 'WINDOW-CLOSE' TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre C-Win
ON CHOOSE OF MENU-ITEM m_Endre /* Endre... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    Current-Rec = RECID(NPSHMKVS).
    RUN SHENMKVS.W (INPUT current-rec) NO-ERROR.
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
    RUN SHNYMKVS.W (INPUT current-rec) NO-ERROR.
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
            
      MESSAGE "Vil du slette denne ventilen?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      IF  choice THEN
          DO:
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                cur_rec = ROWID(NPSHMKVS). 
                GET PREV BROWSE-1 NO-LOCK.
                forrige = ROWID(NPSHMKVS).
                DO TRANSACTION:
                    FIND NPSHMKVS WHERE ROWID(NPSHMKVS)  = cur_rec  EXCLUSIVE-LOCK
                        NO-ERROR NO-WAIT.
                     IF AVAILABLE(NPSHMKVS) THEN
                             DO:
                                 DELETE NPSHMKVS.
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
  RUN fyll_ventiltype_combo.
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
    APPLY "ENTRY" TO COMBO-BOX-VENTILTYPE IN FRAME {&frame-name}.

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
  DISPLAY COMBO-BOX-VENTILTYPE 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-34 COMBO-BOX-VENTILTYPE BROWSE-1 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_ventiltype_combo C-Win 
PROCEDURE fyll_ventiltype_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    temp-string = "".
    FOR EACH NPSHVENTILTYPE:
         IF temp-string = ""
        THEN temp-string = NPSHVENTILTYPE.ventiltype.
        ELSE temp-string = temp-string + "," + NPSHVENTILTYPE.ventiltype.
    END.

    ASSIGN COMBO-BOX-VENTILTYPE:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

