&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DLGOKCAN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DLGOKCAN 
/*------------------------------------------------------------------------

  File: dlgokcan.w

  Description: General use dialog box
    template witth OK, Cancel, and
    Help buttons

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/03/94 -  5:03 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER prosjektNavnParam LIKE NORPROSJEKT.prosjekt_navn.
DEFINE INPUT-OUTPUT PARAMETER nyRecord AS LOGICAL.
DEFINE SHARED VAR Current-Rec AS ROWID.
DEFINE SHARED VAR prosjektIdParam LIKE NORPROSJEKT.prosjektid.

/* Local Variable Definitions ---                                       */
DEFINE VAR iNextAnleggsnr AS INTEGER.
DEFINE VAR konsulentnrParam AS CHAR.
DEFINE VAR konsulentnvnParam AS CHAR.
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGOKCAN

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGANLG.dato NPAGANLG.aktivt ~
NPAGANLG.endrings_laas NPAGANLG.batteri_kjoling NPAGANLG.anlegg ~
NPAGANLG.batteri_oppvarming NPAGANLG.bruksomraade ~
NPAGANLG.konsulentens_saksbeh NPAGANLG.salgsdistrikt NPAGANLG.saksbehandler ~
NPAGANLG.selger NPAGANLG.entreprise NPAGANLG.beskrevet NPAGANLG.anbudsfrist ~
NPAGANLG.byggestart NPAGANLG.oppf_uke NPAGANLG.oppf_aar ~
NPAGANLG.leveringstid NPAGANLG.opplysninger 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dato ~{&FP2}dato ~{&FP3}~
 ~{&FP1}anlegg ~{&FP2}anlegg ~{&FP3}~
 ~{&FP1}konsulentens_saksbeh ~{&FP2}konsulentens_saksbeh ~{&FP3}~
 ~{&FP1}anbudsfrist ~{&FP2}anbudsfrist ~{&FP3}~
 ~{&FP1}byggestart ~{&FP2}byggestart ~{&FP3}~
 ~{&FP1}oppf_uke ~{&FP2}oppf_uke ~{&FP3}~
 ~{&FP1}oppf_aar ~{&FP2}oppf_aar ~{&FP3}~
 ~{&FP1}leveringstid ~{&FP2}leveringstid ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGANLG
&Scoped-define FIRST-ENABLED-TABLE NPAGANLG
&Scoped-Define ENABLED-OBJECTS RECT-31 RECT-30 COMBO-SPINN Konsulent Btn_OK ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGANLG.dato NPAGANLG.aktivt ~
NPAGANLG.endrings_laas NPAGANLG.batteri_kjoling NPAGANLG.batteri_oppvarming ~
NPAGANLG.bruksomraade NPAGANLG.konsulentens_saksbeh NPAGANLG.salgsdistrikt ~
NPAGANLG.saksbehandler NPAGANLG.selger NPAGANLG.beskrevet ~
NPAGANLG.anbudsfrist NPAGANLG.byggestart NPAGANLG.oppf_aar ~
NPAGANLG.opplysninger 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancel":L 
     SIZE 9.8 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&OK":L 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE Konsulent AS CHARACTER FORMAT "X(40)":U 
     LABEL "Konsulent" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 54.4 BY 1
     FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN
     FILENAME "bmp\spinn":U
     SIZE 4.2 BY 1.33.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 131.6 BY 16.1.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 37.4 BY 2.95.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGOKCAN
     NPAGANLG.anleggsnr AT ROW 1.95 COL 18.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.dato AT ROW 1.95 COL 36.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPAGANLG.aktivt AT ROW 2.19 COL 55
          VIEW-AS TOGGLE-BOX
          SIZE 11.8 BY .76
     NPAGANLG.endrings_laas AT ROW 2.19 COL 67.6
          LABEL "Låst for endringer"
          VIEW-AS TOGGLE-BOX
          SIZE 25.8 BY .76
          FGCOLOR 12 FONT 2
     NPAGANLG.batteri_kjoling AT ROW 2.67 COL 109.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","DX","Vann" 
          SIZE 16.8 BY 1
     NPAGANLG.anlegg AT ROW 3.1 COL 18.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 53.8 BY 1
          FONT 2
     NPAGANLG.batteri_oppvarming AT ROW 4 COL 109.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","El","Vann" 
          SIZE 16.8 BY 1
     NPAGANLG.bruksomraade AT ROW 4.24 COL 18.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Standard Utendørs","Standard Innendørs","Skip","Offshore" 
          SIZE 31.4 BY 1
     Konsulent AT ROW 5.57 COL 18.8 COLON-ALIGNED
     NPAGANLG.konsulentens_saksbeh AT ROW 5.57 COL 81.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.4 BY 1
     NPAGANLG.salgsdistrikt AT ROW 6.71 COL 18.8 COLON-ALIGNED
          LABEL "Salgsdistr."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "10-Østfold","20-Oslo/Akershus","30-Hedmark/Oppland","40-Buskerud/Vestfold/Telemark","50-Aust og Vest-Agder/Rogaland","60-Hordaland/Sogn og Fjordane","70-Møre og Romsdal","80-Sør og Nord-Trøndelag","90-Nordland","100-Troms/Finnmark","110-Svalbard","200-Sverige","300-Finnland","400-Danmark","500-Tyskland","700-England","800-Spania" 
          SIZE 34.2 BY 1
          FONT 2
     NPAGANLG.saksbehandler AT ROW 8.05 COL 18.8 COLON-ALIGNED
          LABEL "Saksbeh."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","" 
          SIZE 29.2 BY 1
     NPAGANLG.selger AT ROW 8.19 COL 88.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","" 
          SIZE 29.2 BY 1
     NPAGANLG.entreprise AT ROW 9.38 COL 18.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "RØR ","VENT ","AUTO ","SKIP ","KULDE","FORPRO","ELEKTRO","TOTAL" 
          SIZE 13 BY 1
          FONT 2
     NPAGANLG.beskrevet AT ROW 9.38 COL 49.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","FRITT","KONK.","NOR","NVP","NOVEMA","COVENT","ABB","PM","WOLF","DANVENT","NOVENCO" 
          SIZE 12.2 BY 1
     NPAGANLG.anbudsfrist AT ROW 9.52 COL 88.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPAGANLG.byggestart AT ROW 10.71 COL 18.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPAGANLG.oppf_uke AT ROW 10.71 COL 49.8 COLON-ALIGNED
          LABEL "Oppf.uke."
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.8 BY 1
          FONT 2
     NPAGANLG.oppf_aar AT ROW 10.71 COL 65.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY 1
     NPAGANLG.leveringstid AT ROW 10.71 COL 88.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 16.2 BY 1
          FONT 2
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME DLGOKCAN
     NPAGANLG.opplysninger AT ROW 12.05 COL 21 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 83.8 BY 4.48
          FONT 2
     Btn_OK AT ROW 18.29 COL 56.2
     Btn_Cancel AT ROW 18.29 COL 64.8
     Btn_Help AT ROW 18.29 COL 75.4
     RECT-31 AT ROW 2.43 COL 94.4
     " Batteri" VIEW-AS TEXT
          SIZE 9.4 BY .76 AT ROW 2.1 COL 96.4
     "Opplysninger" VIEW-AS TEXT
          SIZE 16.2 BY .81 AT ROW 11.86 COL 4.4
     RECT-30 AT ROW 1.29 COL 2.2
     COMBO-SPINN AT ROW 5.48 COL 75.6
     SPACE(55.59) SKIP(13.32)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Aggregatanlegg":L
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGOKCAN
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME DLGOKCAN:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPAGANLG.anlegg IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPAGANLG.anleggsnr IN FRAME DLGOKCAN
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX NPAGANLG.endrings_laas IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPAGANLG.entreprise IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN Konsulent IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPAGANLG.leveringstid IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPAGANLG.oppf_uke IN FRAME DLGOKCAN
   NO-DISPLAY EXP-LABEL                                                 */
/* SETTINGS FOR COMBO-BOX NPAGANLG.saksbehandler IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPAGANLG.salgsdistrikt IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DLGOKCAN
/* Query rebuild information for DIALOG-BOX DLGOKCAN
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX DLGOKCAN */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel DLGOKCAN
ON CHOOSE OF Btn_Cancel IN FRAME DLGOKCAN /* Cancel */
DO:
            nyRecord = FALSE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help DLGOKCAN
ON CHOOSE OF Btn_Help IN FRAME DLGOKCAN /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK DLGOKCAN
ON CHOOSE OF Btn_OK IN FRAME DLGOKCAN /* OK */
DO:
    /* Dersom oppf. uke og år ikke er fylt ut, stopp registrering */
    IF INTEGER(NPAGANLG.oppf_uke:SCREEN-VALUE) = 0 OR 
        INTEGER(NPAGANLG.oppf_aar:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Neste oppfølgingsuke og år MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.

    IF konsulentnrParam = '0' THEN    /* Ok trykket uten at konsulent er valgt -- ulovlig! */
        APPLY 'CHOOSE' TO Btn_Cancel.
    ELSE
        DO:
            IF nyRecord THEN
            DO:
            define var cp_tabell_navn as char.
            define var ip_neste_id as integer.

            cp_tabell_navn  = 'NPAGANLG'.
            run neste_id.p (input cp_tabell_navn, output ip_neste_id).
            ASSIGN  NPAGANLG.kundenr = konsulentnrParam
                               NPAGANLG.anleggsnr = ip_neste_id
                               NPAGANLG.prosjektid = prosjektIdParam.            
            Current-Rec = ROWID(NPAGANLG).
            /* Ved nytt anlegg, skal prosjektet v‘re aktivt uansett */
            UPDATE NORPROSJEKT SET NORPROSJEKT.aktivt = TRUE
            WHERE NORPROSJEKT.prosjektid = prosjektidParam.
            END.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Konsulent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Konsulent DLGOKCAN
ON LEAVE OF Konsulent IN FRAME DLGOKCAN /* Konsulent */
DO:
   FIND NPKUNDE WHERE NPKUNDE.kundenavn = Konsulent:SCREEN-VALUE NO-ERROR.
   IF NOT AVAILABLE(NPKUNDE) THEN
       DO:
           konsulentnrParam = '0'.
           konsulentnvnParam = "".
           RUN VELGKONS.W (INPUT-OUTPUT konsulentnrParam, INPUT-OUTPUT konsulentnvnParam) NO-ERROR.
           IF konsulentnrParam = '0' THEN
               RETURN.
           ELSE 
               DO:
                    Konsulent = konsulentnvnParam.
                    NPAGANLG.kundenr = konsulentnrParam.
                   DISPLAY konsulent WITH FRAME  {&FRAME-NAME}.
                    APPLY "ENTRY" TO npagANLG.entreprise.
               END.
        END.
   ELSE
       DO:
           Konsulent = NPKUNDE.kundenavn.
           konsulentnrParam = NPKUNDE.kundenr.
           DISPLAY konsulent WITH FRAME  {&FRAME-NAME}.
           APPLY "ENTRY" TO entreprise.
       END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.saksbehandler
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.saksbehandler DLGOKCAN
ON ANY-PRINTABLE OF NPAGANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.saksbehandler DLGOKCAN
ON CURSOR-DOWN OF NPAGANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.saksbehandler DLGOKCAN
ON CURSOR-UP OF NPAGANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.salgsdistrikt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.salgsdistrikt DLGOKCAN
ON VALUE-CHANGED OF NPAGANLG.salgsdistrikt IN FRAME DLGOKCAN /* Salgsdistr. */
DO:
  CASE SELF:SCREEN-VALUE:
    WHEN '90-Nordland' OR WHEN '100-Troms/Finnmark' OR WHEN '110-Svalbard' THEN
        DO:
            npagANLG.selger = 'Steinar Aune'.
            DISPLAY npagANLG.selger WITH FRAME {&FRAME-NAME}.
          END.
    OTHERWISE
        DO:
            npagANLG.selger = "Arne Svensson".
            DISPLAY npagANLG.selger WITH FRAME {&FRAME-NAME}.
          END.           
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.selger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.selger DLGOKCAN
ON ANY-PRINTABLE OF NPAGANLG.selger IN FRAME DLGOKCAN /* Selger */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.selger DLGOKCAN
ON CURSOR-DOWN OF NPAGANLG.selger IN FRAME DLGOKCAN /* Selger */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.selger DLGOKCAN
ON CURSOR-UP OF NPAGANLG.selger IN FRAME DLGOKCAN /* Selger */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DLGOKCAN 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  pointer = SESSION:SET-WAIT-STATE("").
  RUN fyll_combo.
  IF nyRecord THEN
      RUN nyttAnlegg.
  ELSE
      RUN endreAnlegg.

END.    
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGOKCAN _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME DLGOKCAN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGOKCAN _DEFAULT-ENABLE
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
  IF AVAILABLE NPAGANLG THEN 
    DISPLAY NPAGANLG.dato NPAGANLG.aktivt NPAGANLG.endrings_laas 
          NPAGANLG.batteri_kjoling NPAGANLG.batteri_oppvarming 
          NPAGANLG.bruksomraade NPAGANLG.konsulentens_saksbeh 
          NPAGANLG.salgsdistrikt NPAGANLG.saksbehandler NPAGANLG.selger 
          NPAGANLG.beskrevet NPAGANLG.anbudsfrist NPAGANLG.byggestart 
          NPAGANLG.oppf_aar NPAGANLG.opplysninger 
      WITH FRAME DLGOKCAN.
  ENABLE RECT-31 RECT-30 COMBO-SPINN NPAGANLG.dato NPAGANLG.aktivt 
         NPAGANLG.endrings_laas NPAGANLG.batteri_kjoling NPAGANLG.anlegg 
         NPAGANLG.batteri_oppvarming NPAGANLG.bruksomraade Konsulent 
         NPAGANLG.konsulentens_saksbeh NPAGANLG.salgsdistrikt 
         NPAGANLG.saksbehandler NPAGANLG.selger NPAGANLG.entreprise 
         NPAGANLG.beskrevet NPAGANLG.anbudsfrist NPAGANLG.byggestart 
         NPAGANLG.oppf_uke NPAGANLG.oppf_aar NPAGANLG.leveringstid 
         NPAGANLG.opplysninger Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME DLGOKCAN.
  {&OPEN-BROWSERS-IN-QUERY-DLGOKCAN}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreAnlegg DLGOKCAN 
PROCEDURE endreAnlegg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPAGANLG WHERE ROWID(NPAGANLG) = Current-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NPAGANLG THEN
      DO:
          DISPLAY NPAGANLG.anleggsnr   WITH FRAME DLGOKCAN.
          FIND NPKUNDE WHERE NPKUNDE.kundenr = NPAGANLG.kundenr
            NO-LOCK NO-WAIT NO-ERROR.
          IF AVAILABLE NPKUNDE THEN  konsulent = NPKUNDE.kundenavn.
          ELSE
            RETURN.
             
      UPDATE 
        norcalc.NPAGANLG.dato NPAGANLG.aktivt NPAGANLG.endrings_laas 
        norcalc.NPAGANLG.anlegg NPAGANLG.bruksomraade
        Konsulent NPAGANLG.konsulentens_saksbeh
        NPAGANLG.salgsdistrikt NPAGANLG.saksbehandler  NPAGANLG.selger 
        norcalc.NPAGANLG.entreprise norcalc.NPAGANLG.beskrevet 
        norcalc.NPAGANLG.anbudsfrist norcalc.NPAGANLG.byggestart
        norcalc.NPAGANLG.oppf_uke NPAGANLG.oppf_aar NPAGANLG.leveringstid 
        NPAGANLG.opplysninger NPAGANLG.batteri_kjoling NPAGANLG.batteri_oppvarming
         Btn_OK Btn_Cancel Btn_Help
      WITH FRAME DLGOKCAN.
 END.
ELSE
    DO:
    MESSAGE 'Tabellen for Spiroventtanlegg er opptatt. Prøv igjen om en liten stund' VIEW-AS ALERT-BOX
        TITLE 'STOPP'.
    RETURN.
    END.
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo DLGOKCAN 
PROCEDURE fyll_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    temp-string = "".
    FOR EACH NPKONTAKT BY id:
         IF temp-string = ""
        THEN temp-string = NPKONTAKT.kontaktperson.
        ELSE temp-string = temp-string + "," + NPKONTAKT.kontaktperson.
    END.
    /* Legg til en blank post */
    temp-string = temp-string + "," + " ".

    ASSIGN NPAGANLG.saksbehandler:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.
    ASSIGN NPAGANLG.selger:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttAnlegg DLGOKCAN 
PROCEDURE nyttAnlegg :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
     iNextAnleggsnr = 0.
     create npagANLG.
     npagANLG.dato = TODAY.
     NPAGANLG.oppf_aar = YEAR(TODAY).
     npagANLG.anleggsnr = iNextAnleggsnr.
     npagANLG.anlegg = prosjektNavnParam.
     DISPLAY npagANLG.anleggsnr  npagANLG.anlegg npagANLG.dato 
        WITH FRAME  {&FRAME-NAME}.
  ENABLE  COMBO-SPINN WITH FRAME DLGOKCAN.
 UPDATE 
        RECT-30 norcalc.npagANLG.dato norcalc.npagANLG.anlegg NPAGANLG.bruksomraade
         Konsulent 
        npagANLG.konsulentens_saksbeh
        npagANLG.saksbehandler npagANLG.salgsdistrikt npagANLG.selger 
        norcalc.npagANLG.entreprise norcalc.npagANLG.beskrevet 
        norcalc.npagANLG.anbudsfrist norcalc.npagANLG.byggestart
        norcalc.npagANLG.oppf_uke NPAGANLG.oppf_aar npagANLG.leveringstid 
        npagANLG.opplysninger NPAGANLG.batteri_kjoling NPAGANLG.batteri_oppvarming
         Btn_OK Btn_Cancel Btn_Help
      WITH FRAME DLGOKCAN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


