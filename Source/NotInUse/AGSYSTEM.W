&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME Aggregatsystem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Aggregatsystem 
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
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER returAggregat AS LOGICAL.
DEFINE SHARED VARIABLE anleggsnrParam LIKE NPAGANLG.anleggsnr.
DEFINE NEW SHARED VARIABLE Current-Rec as ROWID.
DEFINE NEW SHARED VARIABLE tilluftsRec AS ROWID.
DEFINE NEW SHARED VARIABLE fraluftsRec AS ROWID.
DEFINE NEW SHARED VARIABLE systemnrParam LIKE NPAGSYST.systemnr.
DEFINE NEW SHARED VARIABLE delnrParam AS INTEGER.
DEFINE VAR syst# LIKE NPAGSYST.systemnr.

DEFINE VAR Detail-Handle AS HANDLE.
DEFINE VARIABLE stat AS LOGICAL.      /* Status return from methods */
DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL.  
DEFINE VAR systemRow AS LOGICAL.
DEFINE TEMP-TABLE TEMP_FRALUFT LIKE NPAGFRALUFT.
DEFINE  VAR nyRecord AS LOGICAL INITIAL FALSE.

/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN
    THIS-PROCEDURE:PRIVATE-DATA = appdata.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME SYSTEM-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPAGTILLUFT NPAGFRALUFT NPAGSYST

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NPAGTILLUFT.aggregattype ~
NPAGTILLUFT.aktuell_kapasitet NPAGTILLUFT.del_nr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NPAGTILLUFT NO-LOCK ~
    BY NPAGTILLUFT.tilluftsdel_nr.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NPAGTILLUFT
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NPAGTILLUFT


/* Definitions for BROWSE BROWSE-2                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-2 NPAGFRALUFT.aggregattype ~
NPAGFRALUFT.aktuell_kapasitet NPAGFRALUFT.del_nr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-2 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-2
&Scoped-define OPEN-QUERY-BROWSE-2 OPEN QUERY BROWSE-2 FOR EACH NPAGFRALUFT NO-LOCK ~
    BY NPAGFRALUFT.fraluftsdel_nr.
&Scoped-define TABLES-IN-QUERY-BROWSE-2 NPAGFRALUFT
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-2 NPAGFRALUFT


/* Definitions for BROWSE System-Browse                                 */
&Scoped-define FIELDS-IN-QUERY-System-Browse NPAGSYST.systembetegnelse ~
NPAGSYST.standardpris NPAGSYST.systemvekt NPAGSYST.systemnr ~
NPAGSYST.anleggsnr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-System-Browse 
&Scoped-define FIELD-PAIRS-IN-QUERY-System-Browse
&Scoped-define OPEN-QUERY-System-Browse OPEN QUERY System-Browse FOR EACH NPAGSYST NO-LOCK ~
    BY NPAGSYST.systemnr.
&Scoped-define TABLES-IN-QUERY-System-Browse NPAGSYST
&Scoped-define FIRST-TABLE-IN-QUERY-System-Browse NPAGSYST


/* Definitions for FRAME SYSTEM-FRAME                                   */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGSYST.anmerkninger 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES NPAGSYST
&Scoped-define FIRST-ENABLED-TABLE NPAGSYST
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-4 System-Browse BROWSE-1 ~
BROWSE-2 BUTTON-ny-tilluft BUTTON-endre-tilluft BUTTON-slette-tilluft ~
BUTTON-ny-fraluft BUTTON-endre-fraluft BUTTON-slette-fraluft BUTTON-kopier 
&Scoped-Define DISPLAYED-FIELDS NPAGSYST.anmerkninger 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR Aggregatsystem AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_System 
       MENU-ITEM m_Nytt         LABEL "&Nytt..."       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre..."      ACCELERATOR "CTRL-E"
       MENU-ITEM m_Kopiere      LABEL "&Kopiere..."    ACCELERATOR "CTRL-K"
       MENU-ITEM m_Slette       LABEL "&Slette..."     ACCELERATOR "CTRL-S".

DEFINE SUB-MENU m_Generelt 
       MENU-ITEM m_Tilluft      LABEL "&Tilluft..."   
       MENU-ITEM m_Fraluft      LABEL "&Fraluft..."   
       MENU-ITEM m_Trykkfall    LABEL "Tr&ykkfall..." 
       MENU-ITEM m_Diverse      LABEL "&Diverse..."   .

DEFINE SUB-MENU m_Filter 
       MENU-ITEM m_Forfilter    LABEL "&Forfilter"    
       MENU-ITEM m_Etterfilter  LABEL "&Etterfilter"  .

DEFINE SUB-MENU m_Gjenvinner 
       MENU-ITEM m_Batteri2     LABEL "&Batteri"      
       MENU-ITEM m_Kryss        LABEL "&Kryss"        
       MENU-ITEM m_Roterende    LABEL "&Roterende"    .

DEFINE SUB-MENU m_Batteri 
       MENU-ITEM m_Kjle-Isvann  LABEL "Kjøle-&Isvann" 
       MENU-ITEM m_Kjle-DX      LABEL "Kjøle-&DX"     
       RULE
       MENU-ITEM m_Varme-El     LABEL "Varme-&El"     
       MENU-ITEM m_Varme-Vann   LABEL "Varme-&Vann"   
       MENU-ITEM m_Varme-Damp   LABEL "Varme-&Damp"   
       MENU-ITEM m_Varme-Hetolje LABEL "Varme-&Hetolje".

DEFINE SUB-MENU m_Utstyr 
       SUB-MENU  m_Filter       LABEL "&Filter"       
       MENU-ITEM m_Spjeld       LABEL "&Spjeld"       
       SUB-MENU  m_Gjenvinner   LABEL "&Gjenvinner"   
       SUB-MENU  m_Batteri      LABEL "&Batteri"      .

DEFINE MENU MAIN-MENU MENUBAR
       SUB-MENU  m_System       LABEL "&System"       
       SUB-MENU  m_Generelt     LABEL "&Generelt"     
       MENU-ITEM m_Kabinett     LABEL "&Kabinett"     
       SUB-MENU  m_Utstyr       LABEL "Utst&yr"       
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-endre-fraluft 
     LABEL "E&ndre" 
     SIZE 8.6 BY .91.

DEFINE BUTTON BUTTON-endre-tilluft 
     LABEL "&Endre" 
     SIZE 8.6 BY .91.

DEFINE BUTTON BUTTON-kopier 
     LABEL "&Kopier >>" 
     SIZE 13 BY .81.

DEFINE BUTTON BUTTON-ny-fraluft 
     LABEL "N&y" 
     SIZE 8.6 BY .91.

DEFINE BUTTON BUTTON-ny-tilluft 
     LABEL "&Ny" 
     SIZE 8.6 BY .91.

DEFINE BUTTON BUTTON-slette-fraluft 
     LABEL "Slette" 
     SIZE 8.6 BY .91.

DEFINE BUTTON BUTTON-slette-tilluft 
     LABEL "Slette" 
     SIZE 8.6 BY .91.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55.8 BY 7.05.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 55.8 BY 7.05.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 123.2 BY 6.62.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      NPAGTILLUFT SCROLLING.

DEFINE QUERY BROWSE-2 FOR 
      NPAGFRALUFT SCROLLING.

DEFINE QUERY System-Browse FOR 
      NPAGSYST SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 Aggregatsystem _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      NPAGTILLUFT.aggregattype
      NPAGTILLUFT.aktuell_kapasitet
      NPAGTILLUFT.del_nr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 52.8 BY 4.52
         FONT 2.

DEFINE BROWSE BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-2 Aggregatsystem _STRUCTURED
  QUERY BROWSE-2 NO-LOCK DISPLAY
      NPAGFRALUFT.aggregattype
      NPAGFRALUFT.aktuell_kapasitet
      NPAGFRALUFT.del_nr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 52.8 BY 4.52
         FONT 2.

DEFINE BROWSE System-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS System-Browse Aggregatsystem _STRUCTURED
  QUERY System-Browse NO-LOCK DISPLAY
      NPAGSYST.systembetegnelse
      NPAGSYST.standardpris
      NPAGSYST.systemvekt
      NPAGSYST.systemnr
      NPAGSYST.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 120 BY 5.91
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME SYSTEM-FRAME
     System-Browse AT ROW 1.67 COL 4.2
     BROWSE-1 AT ROW 8.86 COL 4.6
     BROWSE-2 AT ROW 8.91 COL 71
     BUTTON-ny-tilluft AT ROW 13.91 COL 16
     BUTTON-endre-tilluft AT ROW 13.91 COL 26.2
     BUTTON-slette-tilluft AT ROW 13.91 COL 36.4
     BUTTON-ny-fraluft AT ROW 14.05 COL 83.4
     BUTTON-endre-fraluft AT ROW 14.05 COL 93.6
     BUTTON-slette-fraluft AT ROW 14.05 COL 104
     BUTTON-kopier AT ROW 16 COL 57.8
     NPAGSYST.anmerkninger AT ROW 16.38 COL 74.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
          SIZE 2.4 BY .86
     RECT-2 AT ROW 8.29 COL 2.8
     RECT-3 AT ROW 8.33 COL 69.8
     " Systemoversikt" VIEW-AS TEXT
          SIZE 20.4 BY .62 AT ROW 1 COL 5
     " Tilluft" VIEW-AS TEXT
          SIZE 8.2 BY .62 AT ROW 8.05 COL 4.8
     RECT-4 AT ROW 1.33 COL 2.6
     " Fraluft" VIEW-AS TEXT
          SIZE 9.6 BY .62 AT ROW 8.05 COL 72.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126 BY 18.48
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
  CREATE WINDOW Aggregatsystem ASSIGN
         HIDDEN             = YES
         TITLE              = "Aggregat system"
         HEIGHT             = 18.48
         WIDTH              = 126
         MAX-HEIGHT         = 18.52
         MAX-WIDTH          = 127
         VIRTUAL-HEIGHT     = 18.52
         VIRTUAL-WIDTH      = 127
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MAIN-MENU:HANDLE.

IF NOT Aggregatsystem:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.

IF NOT Aggregatsystem:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Aggregatsystem
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME SYSTEM-FRAME
                                                                        */
/* BROWSE-TAB System-Browse TEXT-1 SYSTEM-FRAME */
/* BROWSE-TAB BROWSE-1 System-Browse SYSTEM-FRAME */
/* BROWSE-TAB BROWSE-2 BROWSE-1 SYSTEM-FRAME */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Aggregatsystem)
THEN Aggregatsystem:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "norcalc.NPAGTILLUFT"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPAGTILLUFT.tilluftsdel_nr|yes"
     _FldNameList[1]   = norcalc.NPAGTILLUFT.aggregattype
     _FldNameList[2]   = norcalc.NPAGTILLUFT.aktuell_kapasitet
     _FldNameList[3]   = norcalc.NPAGTILLUFT.del_nr
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-2
/* Query rebuild information for BROWSE BROWSE-2
     _TblList          = "norcalc.NPAGFRALUFT"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPAGFRALUFT.fraluftsdel_nr|yes"
     _FldNameList[1]   = norcalc.NPAGFRALUFT.aggregattype
     _FldNameList[2]   = norcalc.NPAGFRALUFT.aktuell_kapasitet
     _FldNameList[3]   = norcalc.NPAGFRALUFT.del_nr
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE System-Browse
/* Query rebuild information for BROWSE System-Browse
     _TblList          = "norcalc.NPAGSYST"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPAGSYST.systemnr|yes"
     _FldNameList[1]   = norcalc.NPAGSYST.systembetegnelse
     _FldNameList[2]   = norcalc.NPAGSYST.standardpris
     _FldNameList[3]   = norcalc.NPAGSYST.systemvekt
     _FldNameList[4]   = norcalc.NPAGSYST.systemnr
     _FldNameList[5]   = norcalc.NPAGSYST.anleggsnr
     _Query            is NOT OPENED
*/  /* BROWSE System-Browse */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Aggregatsystem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Aggregatsystem Aggregatsystem
ON END-ERROR OF Aggregatsystem /* Aggregat system */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Aggregatsystem Aggregatsystem
ON WINDOW-CLOSE OF Aggregatsystem /* Aggregat system */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 Aggregatsystem
ON VALUE-CHANGED OF BROWSE-1 IN FRAME SYSTEM-FRAME
DO:
  tilluftsrec = ROWID(NPAGTILLUFT).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-2
&Scoped-define SELF-NAME BROWSE-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-2 Aggregatsystem
ON VALUE-CHANGED OF BROWSE-2 IN FRAME SYSTEM-FRAME
DO:
  fraluftsRec = ROWID(NPAGFRALUFT).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-endre-fraluft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-endre-fraluft Aggregatsystem
ON CHOOSE OF BUTTON-endre-fraluft IN FRAME SYSTEM-FRAME /* Endre */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal system ikke kunne endres */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
    ELSE
    DO:
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
        nyRecord = FALSE.
        fraluftsRec = ROWID(NPAGFRALUFT).
        delnrParam = NPAGFRALUFT.del_nr.
        IF THIS-PROCEDURE:PERSISTENT THEN
             THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
        RUN AGFRALUF.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT anleggsNavnParam, 
            INPUT nyRecord)  NO-ERROR.
       OPEN QUERY BROWSE2 FOR EACH NPAGFRALUFT 
            WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam
            AND NPAGFRALUFT.systemnr = systemnrParam NO-LOCK.       
       REPOSITION BROWSE-2 TO ROWID(fraluftsRec).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-endre-tilluft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-endre-tilluft Aggregatsystem
ON CHOOSE OF BUTTON-endre-tilluft IN FRAME SYSTEM-FRAME /* Endre */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal system ikke kunne endres */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
    ELSE
    DO:
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
        nyRecord = FALSE.
        tilluftsRec = ROWID(NPAGTILLUFT).
        delnrParam = NPAGTILLUFT.del_nr.
        IF THIS-PROCEDURE:PERSISTENT THEN
             THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
        RUN AGTILLUF.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT anleggsNavnParam, 
            INPUT nyRecord)  NO-ERROR.
       OPEN QUERY BROWSE-1 FOR EACH NPAGTILLUFT 
            WHERE NPAGTILLUFT.anleggsnr = anleggsnrParam
            AND NPAGTILLUFT.systemnr = systemnrParam NO-LOCK.       
       REPOSITION BROWSE-1 TO ROWID(tilluftsRec) NO-ERROR.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-kopier
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-kopier Aggregatsystem
ON CHOOSE OF BUTTON-kopier IN FRAME SYSTEM-FRAME /* Kopier >> */
DO:
  APPLY 'VALUE-CHANGED' TO BROWSE-1.
  RUN kopierTilFraluft.
  OPEN QUERY BROWSE-2 FOR EACH NPAGFRALUFT 
        WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam
         AND NPAGFRALUFT.systemnr = systemnrParam NO-LOCK.
  IF AVAILABLE NPAGFRALUFT THEN
      DO:
           REPOSITION BROWSE-2 TO ROWID(fraluftsRec) NO-ERROR.
           ENABLE BUTTON-endre-fraluft WITH FRAME {&FRAME-NAME}.
           ENABLE BUTTON-slette-fraluft WITH FRAME {&FRAME-NAME}.
      END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ny-fraluft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ny-fraluft Aggregatsystem
ON CHOOSE OF BUTTON-ny-fraluft IN FRAME SYSTEM-FRAME /* Ny */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal system ikke kunne endres */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
    ELSE
    DO:
        /* Dersom tilluft er registrert, kopier til fraluft  */
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
        nyRecord = TRUE.
        IF THIS-PROCEDURE:PERSISTENT THEN
             THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
        RUN AGFRALUF.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT anleggsNavnParam, 
            INPUT nyRecord)  NO-ERROR.
             OPEN QUERY BROWSE-2 FOR EACH NPAGFRALUFT 
                WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam
                AND NPAGFRALUFT.systemnr = systemnrParam NO-LOCK.
            IF AVAILABLE NPAGFRALUFT THEN
                DO:
                    REPOSITION BROWSE-2 TO ROWID(fraluftsRec) NO-ERROR.
                    ENABLE BUTTON-endre-fraluft WITH FRAME {&FRAME-NAME}.
                END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-ny-tilluft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-ny-tilluft Aggregatsystem
ON CHOOSE OF BUTTON-ny-tilluft IN FRAME SYSTEM-FRAME /* Ny */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal system ikke kunne endres */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
    ELSE
    DO:
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
        nyRecord = TRUE.
        IF THIS-PROCEDURE:PERSISTENT THEN
             THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
        RUN AGTILLUF.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT anleggsNavnParam, 
            INPUT nyRecord)  NO-ERROR.
        DO:
             OPEN QUERY BROWSE-1 FOR EACH NPAGTILLUFT 
                WHERE NPAGTILLUFT.anleggsnr = anleggsnrParam
                AND NPAGTILLUFT.systemnr = systemnrParam NO-LOCK.
            IF AVAILABLE NPAGTILLUFT THEN
                DO:
                    REPOSITION BROWSE-1 TO ROWID(tilluftsRec) NO-ERROR.
                    ENABLE BUTTON-endre-tilluft BUTTON-slette-tilluft BUTTON-kopier 
                        WITH FRAME {&FRAME-NAME}.
                END.
        END.
 END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-slette-fraluft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-slette-fraluft Aggregatsystem
ON CHOOSE OF BUTTON-slette-fraluft IN FRAME SYSTEM-FRAME /* Slette */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal ikke noe kunne slettes */
 /* Er endringslås opphevet */
 DEFINE VAR laast AS LOGICAL.
 DEFINE VAR slettetOk AS LOGICAL.
 DEFINE VAR currentRow AS ROWID.
      
 SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
 IF laast THEN
     DO:
          MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
          RETURN NO-APPLY.
     END.
 ELSE
     DO:  
          MESSAGE "Vil du slette denne fraluftsdelen?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
         IF choice THEN
                  DO:
                    currentRow = ROWID(NPAGFRALUFT).
                    slettetOk = BROWSE-2:DELETE-CURRENT-ROW().
                    FIND NPAGFRALUFT WHERE ROWID(NPAGFRALUFT) = currentRow.
                    DELETE NPAGFRALUFT.

                    GET FIRST BROWSE-2.
                    IF NOT AVAILABLE NPAGFRALUFT THEN
                        DO:
                            DISABLE BUTTON-endre-fraluft WITH FRAME {&FRAME-NAME}.
                            DISABLE BUTTON-slette-fraluft WITH FRAME {&FRAME-NAME}.
                        END.
                  END.
     END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-slette-tilluft
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-slette-tilluft Aggregatsystem
ON CHOOSE OF BUTTON-slette-tilluft IN FRAME SYSTEM-FRAME /* Slette */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal ikke noe kunne slettes */
 /* Er endringslås opphevet */
 DEFINE VAR laast AS LOGICAL.
 DEFINE VAR slettetOk AS LOGICAL.
 DEFINE VAR currentRow AS ROWID.
      
 SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
 IF laast THEN
     DO:
          MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
          RETURN NO-APPLY.
     END.
 ELSE
     DO:  
          MESSAGE "Vil du slette denne tilluftsdelen?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
         IF choice THEN
                  DO:
                    currentRow = ROWID(NPAGTILLUFT).
                    slettetOk = BROWSE-1:DELETE-CURRENT-ROW().
                    FIND NPAGTILLUFT WHERE ROWID(NPAGTILLUFT) = currentRow.
                    DELETE NPAGTILLUFT.

                    GET FIRST BROWSE-1.
                    IF NOT AVAILABLE NPAGTILLUFT THEN
                            DISABLE BUTTON-endre-tilluft BUTTON-slette-tilluft BUTTON-kopier
                                WITH FRAME {&FRAME-NAME}.
                  END.
     END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt Aggregatsystem
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY 'WINDOW-CLOSE' TO {&WINDOW-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre Aggregatsystem
ON CHOOSE OF MENU-ITEM m_Endre /* Endre... */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal system ikke kunne endres */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
    ELSE
    DO:
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
        nyRecord = FALSE.
        IF THIS-PROCEDURE:PERSISTENT THEN
             THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
        RUN AGSYSRED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT anleggsNavnParam, 
            INPUT nyRecord)   NO-ERROR.
      OPEN QUERY System-Browse   FOR EACH NPAGSYST 
              WHERE NPAGSYST.anleggsnr = anleggsnrParam NO-LOCK  BY NPAGSYST.systemnr.
       REPOSITION System-Browse TO ROWID(Current-Rec).
       APPLY 'VALUE-CHANGED' TO System-Browse  IN FRAME System-FRAME.

 END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kopiere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kopiere Aggregatsystem
ON CHOOSE OF MENU-ITEM m_Kopiere /* Kopiere... */
DO:
 MESSAGE 'Kopiering av aggregatsystem er ikke ferdig ennå' view-as alert-box title 'Stopp'.
 RETURN NO-APPLY.
  /* Dersom det er gitt tilbud på dette anlegget skal det ikke kunne legges inn nye system */
/* FIND FIRST NPSPTILBUD WHERE NPSPTILBUD.anleggsnr = anleggsnrParam NO-ERROR.
 IF AVAILABLE NPSPTILBUD THEN
    DO:
        MESSAGE 'Det er gitt tilbud på dette anlegget. Nye system kan ikke registreres!'  VIEW-AS ALERT-BOX TITLE 'FEIL'.
        RETURN NO-APPLY.
    END.
ELSE
    DO:
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
         RUN kopiere_system_til_temp.
        RUN kopiere_system_fra_temp. 
         /* Åpne browser og reset row pointer */
         {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
           REPOSITION System-Browse TO ROWID(Current-Rec).
          APPLY 'VALUE-CHANGED' TO System-Browse
              IN FRAME System-FRAME.
        pointer =  SESSION:SET-WAIT-STATE("").
    END.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt Aggregatsystem
ON CHOOSE OF MENU-ITEM m_Nytt /* Nytt... */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal det ikke kunne legges inn nye system */
  /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
  ELSE
    DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = TRUE.
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN AGSYSRED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT anleggsNavnParam, 
        INPUT nyRecord)  NO-ERROR.
      OPEN QUERY System-Browse   FOR EACH NPAGSYST 
              WHERE NPAGSYST.anleggsnr = anleggsnrParam NO-LOCK  BY NPAGSYST.systemnr.
      FIND NPAGSYST WHERE ROWID(NPAGSYST) = Current-Rec NO-LOCK  NO-ERROR NO-WAIT.
      IF AVAILABLE NPAGSYST THEN
        DO:
            REPOSITION System-Browse TO ROWID(Current-Rec).
            APPLY 'VALUE-CHANGED' TO System-Browse IN FRAME System-FRAME.
            Run menuEnable.
            ENABLE BUTTON-ny-fraluft  BUTTON-ny-tilluft WITH FRAME {&FRAME-NAME}.                           
        END.
 END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette Aggregatsystem
ON CHOOSE OF MENU-ITEM m_Slette /* Slette... */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal ikke enkeltsystem kunne slettes */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    DEFINE VAR slettetOk AS LOGICAL.
         
    SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.

    ELSE
         DO:  
             MESSAGE "Vil du slette dette systemet?"
                 VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
              IF  choice THEN DO WITH FRAME {&FRAME-NAME}:                   
                    slettetOk = System-Browse:DELETE-CURRENT-ROW().
                    FIND NPAGSYST  WHERE NPAGSYST.anleggsnr = anleggsnrParam
                      AND NPAGSYST.systemnr = systemnrParam NO-WAIT.
                     IF AVAILABLE NPAGSYST THEN 
                         DO:
                               DELETE NPAGSYST.
                               GET FIRST System-browse.
                                 systemRow =  System-Browse:SELECT-ROW(1) IN FRAME System-Frame.
                                APPLY 'VALUE-CHANGED' TO System-Browse.
                         END.
                     ELSE
                         DO:
                            MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
                            MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
                            MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
                            DISABLE BUTTON-ny-fraluft  BUTTON-ny-tilluft BUTTON-endre-fraluft  
                                BUTTON-endre-tilluft BUTTON-slette-fraluft  BUTTON-slette-tilluft   
                                WITH FRAME {&FRAME-NAME}.                           
                         END.             
                  END.
          END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME System-Browse
&Scoped-define SELF-NAME System-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse Aggregatsystem
ON LEFT-MOUSE-CLICK OF System-Browse IN FRAME SYSTEM-FRAME
DO:
    APPLY 'VALUE-CHANGED' TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse Aggregatsystem
ON VALUE-CHANGED OF System-Browse IN FRAME SYSTEM-FRAME
DO:
    IF AVAILABLE NPAGSYST THEN 
    DO:
        Current-Rec = ROWID(NPAGSYST).
        systemnrParam = NPAGSYST.systemnr.
        RUN  anleggsPris.

         /* Oppdater fraluft og tilluft-browsers og oppdater knapper */
         OPEN QUERY BROWSE-1 FOR EACH NPAGTILLUFT 
              WHERE NPAGTILLUFT.anleggsnr = anleggsnrParam
               AND NPAGTILLUFT.systemnr = systemnrParam  NO-LOCK  BY NPAGTILLUFT.del_nr.
        IF AVAILABLE NPAGTILLUFT THEN
                ENABLE BUTTON-endre-tilluft  BUTTON-slette-tilluft  BUTTON-kopier 
                    WITH FRAME {&FRAME-NAME}.
        ELSE
                DISABLE BUTTON-endre-tilluft BUTTON-slette-tilluft BUTTON-kopier
                    WITH FRAME {&FRAME-NAME}.
            
        OPEN QUERY BROWSE-2 FOR EACH NPAGFRALUFT 
             WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam
             AND NPAGFRALUFT.systemnr = systemnrParam  NO-LOCK  BY NPAGFRALUFT.del_nr.
        IF AVAILABLE NPAGFRALUFT THEN
               ENABLE BUTTON-endre-fraluft  BUTTON-slette-fraluft WITH FRAME {&FRAME-NAME}.
        ELSE
                DISABLE BUTTON-endre-fraluft  BUTTON-slette-fraluft WITH FRAME {&FRAME-NAME}.
    END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Aggregatsystem 


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
/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
    pointer = SESSION:SET-WAIT-STATE("").   

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    Aggregatsystem:TITLE = 'Aggregatsystem for anlegg: ' + anleggsNavnParam.  
  RUN enable_UI.
    DISABLE NPAGSYST.anmerkninger WITH FRAME SYSTEM-FRAME.
    HIDE NPAGSYST.anmerkninger IN FRAME SYSTEM-FRAME.
  OPEN QUERY System-Browse   FOR EACH NPAGSYST 
      WHERE NPAGSYST.anleggsnr = anleggsnrParam NO-LOCK 
    BY NPAGSYST.systemnr.
    IF AVAILABLE NPAGSYST THEN 
          APPLY 'VALUE-CHANGED' TO System-Browse.
    ELSE
         RUN menuDisable.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anleggsPris Aggregatsystem 
PROCEDURE anleggsPris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR sumAnlegg AS DECIMAL.

  sumAnlegg = 0.
  FOR EACH NPAGSYST WHERE NPAGSYST.anleggsnr = anleggsnrParam NO-LOCK:
        sumAnlegg = sumAnlegg +  NPAGSYST.standardpris.
  END.
  FIND NPAGANLG WHERE NPAGANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK 
    NO-WAIT NO-ERROR.
  IF AVAILABLE NPAGANLG THEN
      ASSIGN NPAGANLG.standardpris = sumAnlegg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent Aggregatsystem 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "ENTRY" TO NPAGSYST.anmerkninger IN FRAME SYSTEM-FRAME.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Aggregatsystem _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Aggregatsystem)
  THEN DELETE WIDGET Aggregatsystem.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Aggregatsystem _DEFAULT-ENABLE
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
  IF AVAILABLE NPAGSYST THEN 
    DISPLAY NPAGSYST.anmerkninger 
      WITH FRAME SYSTEM-FRAME IN WINDOW Aggregatsystem.
  ENABLE RECT-2 RECT-3 RECT-4 System-Browse BROWSE-1 BROWSE-2 BUTTON-ny-tilluft 
         BUTTON-endre-tilluft BUTTON-slette-tilluft BUTTON-ny-fraluft 
         BUTTON-endre-fraluft BUTTON-slette-fraluft BUTTON-kopier 
         NPAGSYST.anmerkninger 
      WITH FRAME SYSTEM-FRAME IN WINDOW Aggregatsystem.
  {&OPEN-BROWSERS-IN-QUERY-SYSTEM-FRAME}
  VIEW Aggregatsystem.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopierTilFraluft Aggregatsystem 
PROCEDURE kopierTilFraluft :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR kopierTilluft AS ROWID.
DEFINE VAR nesteDelnr AS INTEGER.

    kopierTilluft = ROWID(NPAGTILLUFT).       
    /* Finn sist brukte delnr */
    FIND LAST NPAGFRALUFT WHERE NPAGFRALUFT.anleggsnr = anleggsnrParam 
        AND NPAGFRALUFT.systemnr = systemnrParam  USE-INDEX ndx_anl_sys_del
        NO-WAIT NO-ERROR.
    IF AVAILABLE NPAGFRALUFT THEN
        nesteDelnr = NPAGFRALUFT.del_nr + 1.
    ELSE
        nesteDelnr = 1.    
    FIND NPAGTILLUFT WHERE ROWID(NPAGTILLUFT) = kopierTilluft NO-WAIT NO-ERROR.
    IF AVAILABLE NPAGTILLUFT THEN
    DO WITH FRAME {&FRAME-NAME}:
        CREATE TEMP_FRALUFT.
        ASSIGN
            TEMP_FRALUFT.anleggsnr = NPAGTILLUFT.anleggsnr
            TEMP_FRALUFT.systemnr = NPAGTILLUFT.systemnr 
            TEMP_FRALUFT.del_nr = nesteDelnr
            TEMP_FRALUFT.aggregattype =  NPAGTILLUFT.aggregattype
            TEMP_FRALUFT.spes_vekt = NPAGTILLUFT.spes_vekt
            TEMP_FRALUFT.rf = NPAGTILLUFT.rf
            TEMP_FRALUFT.nom_temp = NPAGTILLUFT.nom_temp
            TEMP_FRALUFT.nom_kapasitet = NPAGTILLUFT.nom_kapasitet
            TEMP_FRALUFT.materialkvalitet = NPAGTILLUFT.materialkvalitet
            TEMP_FRALUFT.kabinettype = NPAGTILLUFT.kabinettype
            TEMP_FRALUFT.kabinett_delinger = NPAGTILLUFT.kabinett_delinger
            TEMP_FRALUFT.isolasjon = NPAGTILLUFT.isolasjon
            TEMP_FRALUFT.inspeksjon = NPAGTILLUFT.inspeksjon
            TEMP_FRALUFT.fronthast_kabinett = NPAGTILLUFT.fronthast_kabinett
            TEMP_FRALUFT.fronthast_batt_flate = NPAGTILLUFT.fronthast_batt_flate
            TEMP_FRALUFT.aktuell_kapasitet = NPAGTILLUFT.aktuell_kapasitet
            TEMP_FRALUFT.utv_hoyde = NPAGTILLUFT.utv_hoyde
            TEMP_FRALUFT.utv_bredde = NPAGTILLUFT.utv_bredde
            TEMP_FRALUFT.utv_lengde = NPAGTILLUFT.utv_lengde
            TEMP_FRALUFT.vann_batteri =  NPAGTILLUFT.vann_batteri
            TEMP_FRALUFT.el_batteri = NPAGTILLUFT.el_batteri
            TEMP_FRALUFT.fundament_type = NPAGTILLUFT.fundament_type
            TEMP_FRALUFT.fundament_maal = NPAGTILLUFT.fundament_maal.
            IF  NPAGTILLUFT.batteri_stand_utb = "batteri_standard" THEN
                 ASSIGN TEMP_FRALUFT.batteri_stand_utb = "batteri_standard".
            ELSE
                ASSIGN TEMP_FRALUFT.batteri_stand_utb = "batteri_utbygd".

            CREATE NPAGFRALUFT.
     ASSIGN
            NPAGFRALUFT.anleggsnr = TEMP_FRALUFT.anleggsnr
            NPAGFRALUFT.systemnr = TEMP_FRALUFT.systemnr
            NPAGFRALUFT.del_nr = TEMP_FRALUFT.del_nr
            NPAGFRALUFT.aggregattype = TEMP_FRALUFT.aggregattype 
            NPAGFRALUFT.spes_vekt  = TEMP_FRALUFT.spes_vekt 
            NPAGFRALUFT.rf = TEMP_FRALUFT.rf 
            NPAGFRALUFT.nom_temp = TEMP_FRALUFT.nom_temp 
            NPAGFRALUFT.nom_kapasitet = TEMP_FRALUFT.nom_kapasitet 
            NPAGFRALUFT.materialkvalitet = TEMP_FRALUFT.materialkvalitet 
            NPAGFRALUFT.kabinettype = TEMP_FRALUFT.kabinettype 
            NPAGFRALUFT.kabinett_delinger = TEMP_FRALUFT.kabinett_delinger 
            NPAGFRALUFT.isolasjon = TEMP_FRALUFT.isolasjon 
            NPAGFRALUFT.inspeksjon = TEMP_FRALUFT.inspeksjon 
            NPAGFRALUFT.fronthast_kabinett = TEMP_FRALUFT.fronthast_kabinett 
            NPAGFRALUFT.fronthast_batt_flate = TEMP_FRALUFT.fronthast_batt_flate 
            NPAGFRALUFT.aktuell_kapasitet = TEMP_FRALUFT.aktuell_kapasitet 
            NPAGFRALUFT.utv_hoyde = TEMP_FRALUFT.utv_hoyde 
            NPAGFRALUFT.utv_bredde = TEMP_FRALUFT.utv_bredde 
            NPAGFRALUFT.utv_lengde = TEMP_FRALUFT.utv_lengde 
            NPAGFRALUFT.vann_batteri = TEMP_FRALUFT.vann_batteri 
            NPAGFRALUFT.el_batteri = TEMP_FRALUFT.el_batteri
            NPAGFRALUFT.batteri_stand_utb = TEMP_FRALUFT.batteri_stand_utb
            NPAGFRALUFT.fundament_type = TEMP_FRALUFT.fundament_type
            NPAGFRALUFT.fundament_maal = TEMP_FRALUFT.fundament_maal.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuDisable Aggregatsystem 
PROCEDURE menuDisable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Kabinett:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Tilluft:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Fraluft:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Trykkfall:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Diverse:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Forfilter:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Etterfilter:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Spjeld:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Batteri2:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Kryss:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Roterende:SENSITIVE IN MENU MAIN-MENU = NO.

        DISABLE BUTTON-ny-fraluft  BUTTON-ny-tilluft BUTTON-endre-fraluft  
          BUTTON-endre-tilluft BUTTON-slette-fraluft  BUTTON-slette-tilluft   BUTTON-kopier 
            WITH FRAME {&FRAME-NAME}.                           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE menuEnable Aggregatsystem 
PROCEDURE menuEnable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Kabinett:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Tilluft:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Fraluft:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Trykkfall:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Diverse:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Forfilter:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Etterfilter:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Spjeld:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Batteri2:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Kryss:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Roterende:SENSITIVE IN MENU MAIN-MENU = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


