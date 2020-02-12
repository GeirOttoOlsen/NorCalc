&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
/*DEFINE INPUT  PARAMETER appdata AS CHARACTER.*/
DEFINE var appdata AS CHARACTER.

/* Local Variable Definitions ---                                       */
 DEFINE VAR pointer AS LOGICAL. 
DEFINE VARIABLE rowi  AS INTEGER.
DEFINE VARIABLE sys   AS INTEGER.
DEFINE VARIABLE sheet AS INTEGER.
DEFINE VARIABLE itemn AS CHARACTER.
DEFINE VARIABLE sty   AS CHARACTER.
DEFINE VARIABLE excelon AS LOGICAL INITIAL FALSE.
DEFINE VAR sum AS DECIMAL.
DEFINE VAR snitt AS DECIMAL.
DEFINE VAR antall AS DECIMAL INITIAL 0.
DEFINE VAR fraDato AS DATE.
DEFINE VAR tilDato AS DATE.

/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN
    THIS-PROCEDURE:PRIVATE-DATA = appdata.

/* System prosedyre */
PROCEDURE WinExec EXTERNAL "krnl386.exe": /* Run Windows application */
    DEFINE INPUT PARAMETER prog_name AS CHARACTER. 
    DEFINE INPUT PARAMETER prog_style AS SHORT. 
END PROCEDURE.

/* Temporary table */
DEFINE NEW SHARED TEMP-TABLE tempStatistikk
    FIELD tt_totalfelt AS CHAR
    FIELD tt_verdi AS DECIMAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-32 RADIO-SET-OMFANG RADIO-SET-VERDI ~
RADIO-SET-TOTALER FILL-IN-FRA FILL-IN-TIL BUTTON-Start-Excel BUTTON-LUKK 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-OMFANG RADIO-SET-VERDI ~
RADIO-SET-TOTALER FILL-IN-FRA FILL-IN-TIL 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BUTTON-LUKK 
     LABEL "Lukk" 
     SIZE 16.8 BY 1.36.

DEFINE BUTTON BUTTON-Start-Excel 
     LABEL "Start Excel" 
     SIZE 16.8 BY 1.36.

DEFINE BUTTON BUTTON-STATISTIKK AUTO-GO 
     LABEL "Produser Statistikk" 
     SIZE 28 BY 1.36.

DEFINE BUTTON BUTTON-Stopp-Excel 
     LABEL "Stopp Excel" 
     SIZE 18.2 BY 1.36.

DEFINE VARIABLE FILL-IN-FRA AS DATE FORMAT "99-99-9999":U 
     VIEW-AS FILL-IN 
     SIZE 14.84 BY 1.13
     FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-TIL AS DATE FORMAT "99-99-9999":U 
     VIEW-AS FILL-IN 
     SIZE 14.84 BY 1.13
     FONT 2 NO-UNDO.

DEFINE VARIABLE RADIO-SET-OMFANG AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Aktive Tilbud", "Aktive Tilbud",
"Alle &Tilbud", "Alle Tilbud"
     SIZE 22.4 BY 2.01 NO-UNDO.

DEFINE VARIABLE RADIO-SET-TOTALER AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Entreprise", "Entreprise",
"&Beskrevet", "Beskrevet",
"Stat&us", "Status",
"Kriterium &1", "Kriterium 1",
"Kriterium &2", "Kriterium 2"
     SIZE 22.12 BY 5.66
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE RADIO-SET-VERDI AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Snittpris", "Snittpris",
"A&ntall avgitte tilbud", "Antall avgitte tilbud"
     SIZE 29.4 BY 2.01 NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 94.92 BY 16.22.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     RADIO-SET-OMFANG AT ROW 2.3 COL 47.76 NO-LABEL
     RADIO-SET-VERDI AT ROW 5.31 COL 47.76 NO-LABEL
     RADIO-SET-TOTALER AT ROW 8.9 COL 47.76 NO-LABEL
     FILL-IN-FRA AT ROW 15.86 COL 56.68 COLON-ALIGNED NO-LABEL
     FILL-IN-TIL AT ROW 15.86 COL 77.68 COLON-ALIGNED NO-LABEL
     BUTTON-Start-Excel AT ROW 18.33 COL 9.4
     BUTTON-Stopp-Excel AT ROW 18.33 COL 27.6
     BUTTON-STATISTIKK AT ROW 18.33 COL 47.2
     BUTTON-LUKK AT ROW 18.33 COL 76.6
     RECT-32 AT ROW 1.64 COL 4.08
     "Statistikken skal omfatte:" VIEW-AS TEXT
          SIZE 33.6 BY .77 AT ROW 2.36 COL 13.6
     "Statistikken skal vise:" VIEW-AS TEXT
          SIZE 29.4 BY .77 AT ROW 5.36 COL 17.8
     "Totaler skal vises pr.:" VIEW-AS TEXT
          SIZE 29.4 BY .77 AT ROW 9.02 COL 17.8
     "til:" VIEW-AS TEXT
          SIZE 3.08 BY .77 AT ROW 15.98 COL 76.32
     "Statistikken skal gjelde for perioden fra:" VIEW-AS TEXT
          SIZE 51.8 BY .77 AT ROW 16.03 COL 6.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 102 BY 19.81
         DEFAULT-BUTTON BUTTON-STATISTIKK CANCEL-BUTTON BUTTON-LUKK.


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
         TITLE              = "Tilbudsstatistikk"
         HEIGHT             = 19.81
         WIDTH              = 101.92
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR BUTTON BUTTON-STATISTIKK IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON BUTTON-Stopp-Excel IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Tilbudsstatistikk */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Tilbudsstatistikk */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-LUKK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-LUKK C-Win
ON CHOOSE OF BUTTON-LUKK IN FRAME DEFAULT-FRAME /* Lukk */
DO:
      APPLY "WINDOW-CLOSE" TO {&WINDOW-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Start-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Start-Excel C-Win
ON CHOOSE OF BUTTON-Start-Excel IN FRAME DEFAULT-FRAME /* Start Excel */
DO:
      /* Start Excel */
   IF  excelon THEN
        RETURN.
   ELSE
       DO:
           RUN WinExec (INPUT "W:\MSOFFICE\Excel /e", INPUT 2).  /* 1=normal 2=minimized */
           excelon = TRUE.
        
           DDE INITIATE sys FRAME FRAME {&frame-name}:HANDLE 
              APPLICATION "Excel" TOPIC "System". 
           IF sys = 0 THEN
               DO:
                  MESSAGE "Excel er ikke tilgjengelig".
                  RETURN.
               END.
        /* Initiate transfer */
       DDE EXECUTE sys COMMAND "[new(1)]". 
       DDE INITIATE sheet FRAME FRAME {&frame-name}:HANDLE 
          APPLICATION "Excel" TOPIC "Ark1".
        ENABLE  BUTTON-STATISTIKK WITH FRAME {&FRAME-NAME}.
        ENABLE BUTTON-Stopp-Excel WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-STATISTIKK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-STATISTIKK C-Win
ON CHOOSE OF BUTTON-STATISTIKK IN FRAME DEFAULT-FRAME /* Produser Statistikk */
DO:
    DEFINE VAR verdiLabel AS CHAR INITIAL 'Verdi'.
    DEFINE VAR totalerLabel AS CHAR INITIAL 'Totaler p†'.
    DEFINE VAR iDay AS INTEGER.
    DEFINE VAR iMonth AS INTEGER.
    DEFINE VAR iYear AS INTEGER.

    pointer = SESSION:SET-WAIT-STATE("GENERAL").   
    
    /* T›m temp tabell - i tilfelle */
    FOR EACH tempStatistikk:
        DELETE tempStatistikk.
    END.
    /* Process user input, generate work table data. */
    iDay = INTEGER(SUBSTR(FILL-IN-FRA:SCREEN-VALUE,1,2)).
    iMonth = INTEGER(SUBSTR(FILL-IN-FRA:SCREEN-VALUE,4,2)).
    iYear = INTEGER(SUBSTR(FILL-IN-FRA:SCREEN-VALUE,7,4)).
    fraDato = DATE(iMonth, iDay, iYear).    

    iDay = INTEGER(SUBSTR(FILL-IN-TIL:SCREEN-VALUE,1,2)).
    iMonth = INTEGER(SUBSTR(FILL-IN-TIL:SCREEN-VALUE,4,2)).
    iYear = INTEGER(SUBSTR(FILL-IN-TIL:SCREEN-VALUE,7,4)).
    tilDato = DATE(iMonth, iDay, iYear).    

    CASE RADIO-SET-TOTALER:SCREEN-VALUE:
        /* For entreprise */
        WHEN 'Entreprise' THEN
        DO:
            totalerLabel = "Entreprise".
            /* Snittpris */  
            IF RADIO-SET-VERDI:SCREEN-VALUE = 'Snittpris' THEN 
            DO:
                CASE RADIO-SET-OMFANG:SCREEN-VALUE:
                    /* Aktive Tilbud*/  
                    WHEN 'Aktive Tilbud' THEN 
                        DO:
                            verdiLabel = "Snittpris - Aktive Tilbud".
                             RUN dataEntrepriseSnittAktive.
                        END.
                    /* Alle Tilbud*/  
                    WHEN 'Alle Tilbud' THEN
                        DO:
                            verdiLabel = "Snittpris - Alle Tilbud".
                             RUN dataEntrepriseSnittAlle.
                        END.
                END CASE.
            END.
            /* Antall */  
            ELSE
            DO:
                verdiLabel = "Antall".
                CASE RADIO-SET-OMFANG:SCREEN-VALUE:
                    /* Aktive Tilbud*/  
                    WHEN 'Aktive Tilbud' THEN
                        RUN dataEntrepriseAntallAktive.
                    WHEN 'Alle Tilbud' THEN
                        RUN dataEntrepriseAntallAlle.
                END CASE. 
            END.
        END.
         /* For beskrevet */
        WHEN 'Beskrevet' THEN 
        DO:
            totalerLabel = "Beskrevet".
            /* Snittpris */  
            IF RADIO-SET-VERDI:SCREEN-VALUE = 'Snittpris' THEN 
            DO:
                verdiLabel = "Snittpris".
                CASE RADIO-SET-OMFANG:SCREEN-VALUE:
                    /* Aktive Tilbud*/  
                    WHEN 'Aktive Tilbud' THEN
                        RUN dataBeskrevetSnittAktive.
                    /* Alle Tilbud*/  
                    WHEN 'Alle Tilbud' THEN
                        RUN dataBeskrevetSnittAlle.
                END CASE.
            END.
            /* Antall */  
            ELSE 
            DO:
                verdiLabel = "Antall".
                CASE RADIO-SET-OMFANG:SCREEN-VALUE:
                    /* Aktive Tilbud*/  
                    WHEN 'Aktive Tilbud' THEN
                        RUN dataBeskrevetAntallAktive.
                    WHEN 'Alle Tilbud' THEN
                        RUN dataBeskrevetAntallAlle.
                END CASE.
            END.
         END.
        END CASE.

    pointer = SESSION:SET-WAIT-STATE("").   

   
   DDE SEND sheet SOURCE '"' + totalerLabel + '"' ITEM "r1c1". 
   DDE SEND sheet SOURCE '"' + verdiLabel + '"' ITEM "r1c2". 

    /* Transfer data fro temp table to Excel */
   rowi = 2.  
   FOR EACH tempStatistikk:
          itemn = "R" + STRING(rowi) + "C1".
          DDE SEND sheet SOURCE tempStatistikk.tt_totalfelt ITEM itemn. 
          itemn = "R" + STRING(rowi) + "C2".
          DDE SEND sheet SOURCE STRING(tempStatistikk.tt_verdi) ITEM itemn. 
          rowi = rowi + 1.
  END.

  /* Build presentation in Excel */
   DDE EXECUTE sheet COMMAND "[select(~"R1C1:R" + string(rowi - 1) + "C2~")]". 
   DDE EXECUTE sys COMMAND "[new(2,1,1)]". 
   DDE EXECUTE sys COMMAND "[activate(~"diagr1~")]". 
/*   DDE EXECUTE sys COMMAND "[gallery.3d.pie(3)]". */
   DDE EXECUTE sys COMMAND "[gallery.3d.column(4)]". 
   DDE EXECUTE sys COMMAND "[app.restore()]". 
   DDE EXECUTE sys COMMAND "[arrange.all()]". 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-Stopp-Excel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-Stopp-Excel C-Win
ON CHOOSE OF BUTTON-Stopp-Excel IN FRAME DEFAULT-FRAME /* Stopp Excel */
DO:
       IF (excelon = FALSE) THEN 
            RETURN.
     ELSE
        DO:
          /* Terminate the DDE session */
           DDE TERMINATE sheet. 
           DDE EXECUTE sys COMMAND "[activate(~"Ark1~")]". 
           DDE EXECUTE sys COMMAND "[close(0)]". 
           DDE EXECUTE sys COMMAND "[activate(~"Diagr1~")]". 
           DDE EXECUTE sys COMMAND "[close(0)]". 
           DDE EXECUTE sys COMMAND "[error(0)]". 
           DDE EXECUTE sys COMMAND "[quit()]".  
           excelon = FALSE.

        DISABLE  BUTTON-STATISTIKK WITH FRAME {&FRAME-NAME}.
        DISABLE BUTTON-Stopp-Excel WITH FRAME {&FRAME-NAME}.

        END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
pointer = SESSION:SET-WAIT-STATE("").   

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.
/* Set default dates */
FILL-IN-FRA = TODAY.
FILL-IN-TIL = TODAY.
DISPLAY FILL-IN-FRA FILL-IN-TIL WITH FRAME {&FRAME-NAME}.
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
    APPLY "ENTRY" TO RADIO-SET-OMFANG IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataBeskrevetAntallAktive C-Win 
PROCEDURE dataBeskrevetAntallAktive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH NPSHANLG WHERE aktivt NO-LOCK,
        EACH NPSHTILBUD   OF NPSHANLG  NO-LOCK
            WHERE  (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY beskrevet:
              antall = antall + 1.
              IF LAST-OF  (beskrevet) THEN
                  DO:
                      CREATE tempStatistikk.                                        
                      ASSIGN tt_totalfelt = beskrevet.
                      ASSIGN tt_verdi = antall.                                         
                      antall = 0.
                 END.
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataBeskrevetAntallAlle C-Win 
PROCEDURE dataBeskrevetAntallAlle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH NPSHANLG NO-LOCK,
        EACH NPSHTILBUD OF NPSHANLG  NO-LOCK
            WHERE (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY beskrevet:
              antall = antall + 1.
              IF LAST-OF  (beskrevet) THEN
                  DO:
                      CREATE tempStatistikk.                                        
                      ASSIGN tt_totalfelt = beskrevet.
                      ASSIGN tt_verdi = antall.                                         
                      antall = 0.
                 END.
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataBeskrevetSnittAktive C-Win 
PROCEDURE dataBeskrevetSnittAktive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH NPSHANLG WHERE aktivt  NO-LOCK,
         EACH NPSHTILBUD  OF NPSHANLG  NO-LOCK
            WHERE (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY beskrevet:
             antall = antall + 1.
             ACCUMULATE avgittpris (SUB-TOTAL BY  beskrevet).
            IF LAST-OF  ( beskrevet) THEN
              DO:
             CREATE tempStatistikk.                                        
             sum = ACCUM SUB-TOTAL BY  beskrevet (avgittpris).
             snitt = sum /  antall.
             ASSIGN tt_totalfelt =  beskrevet.
             ASSIGN tt_verdi = snitt.                                         
             antall = 0.
          END.                                                                            
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataBeskrevetSnittAlle C-Win 
PROCEDURE dataBeskrevetSnittAlle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH NPSHANLG NO-LOCK,
         EACH NPSHTILBUD OF NPSHANLG  NO-LOCK
            WHERE (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY beskrevet:
             antall = antall + 1.
             ACCUMULATE avgittpris (SUB-TOTAL BY  beskrevet).
            IF LAST-OF  ( beskrevet) THEN
              DO:
             CREATE tempStatistikk.                                        
             sum = ACCUM SUB-TOTAL BY  beskrevet (avgittpris).
             snitt = sum /  antall.
             ASSIGN tt_totalfelt =  beskrevet.
             ASSIGN tt_verdi = snitt.                                         
             antall = 0.
          END.                                                                            
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataEntrepriseAntallAktive C-Win 
PROCEDURE dataEntrepriseAntallAktive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH NPSHANLG WHERE aktivt  NO-LOCK,
        EACH NPSHTILBUD  OF NPSHANLG  NO-LOCK
            WHERE (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY entreprise:
              antall = antall + 1.
              IF LAST-OF  (entreprise) THEN
                  DO:
                      CREATE tempStatistikk.                                        
                      ASSIGN tt_totalfelt = entreprise.
                      ASSIGN tt_verdi = antall.                                         
                      antall = 0.
                 END.
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataEntrepriseAntallAlle C-Win 
PROCEDURE dataEntrepriseAntallAlle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH NPSHANLG NO-LOCK,
        EACH NPSHTILBUD OF NPSHANLG  NO-LOCK
            WHERE (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY entreprise:
              antall = antall + 1.
              IF LAST-OF  (entreprise) THEN
                  DO:
                      CREATE tempStatistikk.                                        
                      ASSIGN tt_totalfelt = entreprise.
                      ASSIGN tt_verdi = antall.                                         
                      antall = 0.
                 END.
    END. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataEntrepriseSnittAktive C-Win 
PROCEDURE dataEntrepriseSnittAktive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    FOR EACH NPSHANLG WHERE aktivt  NO-LOCK,
         EACH NPSHTILBUD OF NPSHANLG NO-LOCK
            WHERE (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY entreprise:
             antall = antall + 1.
             ACCUMULATE avgittpris (SUB-TOTAL BY entreprise).
            IF LAST-OF  (entreprise) THEN
              DO:           
             CREATE tempStatistikk.                                        
             sum = ACCUM SUB-TOTAL BY entreprise (avgittpris).
             snitt = sum /  antall.
             ASSIGN tt_totalfelt = entreprise.
             ASSIGN tt_verdi = snitt.                                         
             antall = 0.
          END.                                                                            
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataEntrepriseSnittAlle C-Win 
PROCEDURE dataEntrepriseSnittAlle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH NPSHANLG NO-LOCK,
         EACH NPSHTILBUD OF NPSHANLG NO-LOCK 
            WHERE (tilbudsdato >= fraDato AND tilbudsdato <= tilDato) BREAK BY entreprise:
             antall = antall + 1.
             ACCUMULATE avgittpris (SUB-TOTAL BY entreprise).
            IF LAST-OF  (entreprise) THEN
              DO:
             CREATE tempStatistikk.                                        
             sum = ACCUM SUB-TOTAL BY entreprise (avgittpris).
             snitt = sum /  antall.
             ASSIGN tt_totalfelt = entreprise.
             ASSIGN tt_verdi = snitt.                                         
             antall = 0.
          END.                                                                            
    END. 

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
  DISPLAY RADIO-SET-OMFANG RADIO-SET-VERDI RADIO-SET-TOTALER FILL-IN-FRA 
          FILL-IN-TIL 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE RECT-32 RADIO-SET-OMFANG RADIO-SET-VERDI RADIO-SET-TOTALER FILL-IN-FRA 
         FILL-IN-TIL BUTTON-Start-Excel BUTTON-LUKK 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


