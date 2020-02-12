&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME TILBUD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS TILBUD 
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
DEFINE INPUT-OUTPUT PARAMETER nyRecord AS LOGICAL.
DEFINE OUTPUT PARAMETER nyId AS INTEGER INITIAL 0.
DEFINE SHARED VAR Current-Tilbuds-Rec AS ROWID.
DEFINE SHARED VAR anleggsnrParam LIKE npagANLG.anleggsnr.

/* Local Variable Definitions ---                                       */
DEFINE VAR iNextTilbudsnr AS INTEGER.
DEFINE VAR iNextId AS INTEGER.
DEFINE VAR kundenrParam AS CHAR.
DEFINE VAR kundenvnParam AS CHAR.
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR rabattParam AS DECIMAL.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME TILBUD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES npagTILBUD

/* Definitions for DIALOG-BOX TILBUD                                    */
&Scoped-define FIELDS-IN-QUERY-TILBUD NPAGTILBUD.tilbudsdato ~
NPAGTILBUD.tilbudsnr NPAGTILBUD.anleggsnr NPAGTILBUD.rabatt% ~
NPAGTILBUD.vaar_ref NPAGTILBUD.deres_ref NPAGTILBUD.lev_bet ~
NPAGTILBUD.bet_bet NPAGTILBUD.gyldighetstid NPAGTILBUD.opplysninger 
&Scoped-define ENABLED-FIELDS-IN-QUERY-TILBUD NPAGTILBUD.tilbudsdato ~
NPAGTILBUD.tilbudsnr NPAGTILBUD.anleggsnr NPAGTILBUD.rabatt% ~
NPAGTILBUD.vaar_ref NPAGTILBUD.deres_ref NPAGTILBUD.lev_bet ~
NPAGTILBUD.bet_bet NPAGTILBUD.gyldighetstid NPAGTILBUD.opplysninger 
&Scoped-define ENABLED-TABLES-IN-QUERY-TILBUD NPAGTILBUD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-TILBUD NPAGTILBUD

&Scoped-define FIELD-PAIRS-IN-QUERY-TILBUD~
 ~{&FP1}tilbudsdato ~{&FP2}tilbudsdato ~{&FP3}~
 ~{&FP1}tilbudsnr ~{&FP2}tilbudsnr ~{&FP3}~
 ~{&FP1}anleggsnr ~{&FP2}anleggsnr ~{&FP3}~
 ~{&FP1}rabatt% ~{&FP2}rabatt% ~{&FP3}~
 ~{&FP1}deres_ref ~{&FP2}deres_ref ~{&FP3}~
 ~{&FP1}gyldighetstid ~{&FP2}gyldighetstid ~{&FP3}
&Scoped-define OPEN-QUERY-TILBUD OPEN QUERY TILBUD FOR EACH npagTILBUD SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-TILBUD npagTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-TILBUD npagTILBUD


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGTILBUD.tilbudsdato NPAGTILBUD.tilbudsnr ~
NPAGTILBUD.anleggsnr NPAGTILBUD.rabatt% NPAGTILBUD.vaar_ref ~
NPAGTILBUD.deres_ref NPAGTILBUD.lev_bet NPAGTILBUD.bet_bet ~
NPAGTILBUD.gyldighetstid NPAGTILBUD.opplysninger 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}tilbudsdato ~{&FP2}tilbudsdato ~{&FP3}~
 ~{&FP1}tilbudsnr ~{&FP2}tilbudsnr ~{&FP3}~
 ~{&FP1}anleggsnr ~{&FP2}anleggsnr ~{&FP3}~
 ~{&FP1}rabatt% ~{&FP2}rabatt% ~{&FP3}~
 ~{&FP1}deres_ref ~{&FP2}deres_ref ~{&FP3}~
 ~{&FP1}gyldighetstid ~{&FP2}gyldighetstid ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGTILBUD
&Scoped-define FIRST-ENABLED-TABLE NPAGTILBUD
&Scoped-Define ENABLED-OBJECTS RECT-31 COMBO-SPINN Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGTILBUD.tilbudsdato NPAGTILBUD.tilbudsnr ~
NPAGTILBUD.anleggsnr NPAGTILBUD.rabatt% NPAGTILBUD.vaar_ref ~
NPAGTILBUD.deres_ref NPAGTILBUD.lev_bet NPAGTILBUD.bet_bet ~
NPAGTILBUD.gyldighetstid NPAGTILBUD.opplysninger 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancel":L 
     SIZE 10.4 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&OK":L 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-KUNDENAVN AS CHARACTER FORMAT "X(30)":U 
     LABEL "Kundenavn" 
     VIEW-AS FILL-IN 
     SIZE 41 BY 1
     FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN
     FILENAME "bmp\spinn":U
     SIZE 4 BY 1.05.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 117 BY 11.57.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY TILBUD FOR 
      npagTILBUD SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME TILBUD
     NPAGTILBUD.tilbudsdato AT ROW 1.86 COL 92 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPAGTILBUD.tilbudsnr AT ROW 1.91 COL 53.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.4 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGTILBUD.anleggsnr AT ROW 2 COL 21.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     FILL-IN-KUNDENAVN AT ROW 3.19 COL 21.8 COLON-ALIGNED
     NPAGTILBUD.rabatt% AT ROW 4.24 COL 21.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.4 BY 1
          FONT 2
     NPAGTILBUD.vaar_ref AT ROW 4.24 COL 92 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","" 
          SIZE 22.2 BY 1
     NPAGTILBUD.deres_ref AT ROW 4.33 COL 53.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 24.2 BY 1
          FONT 2
     NPAGTILBUD.lev_bet AT ROW 5.43 COL 21.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "AB LAGER","FOB","CIF MM" 
          SIZE 20.2 BY 1
          FONT 2
     NPAGTILBUD.bet_bet AT ROW 5.48 COL 53.6 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Netto pr. 30 dager","Frimnd. + 30 dager","Netto pr. 45 dager","Netto pr. 60 dager","Netto pr. 15 dager","Netto pr. 10 dager","Kontant","Oppkrav" 
          SIZE 26.8 BY 1
          FONT 2
     NPAGTILBUD.gyldighetstid AT ROW 6.71 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.4 BY 1
     NPAGTILBUD.opplysninger AT ROW 8.14 COL 24 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 91.6 BY 4.48
          FONT 2
     Btn_OK AT ROW 13.48 COL 47
     Btn_Cancel AT ROW 13.48 COL 55.8
     Btn_Help AT ROW 13.48 COL 67.2
     "dager" VIEW-AS TEXT
          SIZE 9.8 BY .91 AT ROW 7 COL 29.6
     "Opplysninger:" VIEW-AS TEXT
          SIZE 16.4 BY .91 AT ROW 7.81 COL 7.4
     RECT-31 AT ROW 1.33 COL 2
     COMBO-SPINN AT ROW 3.24 COL 65.2
     SPACE(50.59) SKIP(10.56)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Tilbud på Aggregatanlegg":L
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX TILBUD
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       FRAME TILBUD:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN FILL-IN-KUNDENAVN IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX TILBUD
/* Query rebuild information for DIALOG-BOX TILBUD
     _TblList          = "norcalc.npagTILBUD"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX TILBUD */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel TILBUD
ON CHOOSE OF Btn_Cancel IN FRAME TILBUD /* Cancel */
DO:
  nyRecord = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help TILBUD
ON CHOOSE OF Btn_Help IN FRAME TILBUD /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK TILBUD
ON CHOOSE OF Btn_OK IN FRAME TILBUD /* OK */
DO:
    IF FILL-IN-KUNDENAVN = "" THEN    /* Ok trykket uten at kundenavn er valgt -- ulovlig! */
        APPLY 'CHOOSE' TO Btn_Cancel.
    ELSE    
        IF nyRecord THEN
            DO:
                define var cp_tabell_navn as char.
                define var ip_neste_id as integer.
                cp_tabell_navn  = 'npagtilbud'.
                run neste_id.p (input cp_tabell_navn, output ip_neste_id).
                ASSIGN NPAGTILBUD.id = ip_neste_id
                    nyId = ip_neste_id.
                        
            END. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-SPINN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-SPINN TILBUD
ON MOUSE-SELECT-CLICK OF COMBO-SPINN IN FRAME TILBUD
DO:
    APPLY "LEAVE"  TO FILL-IN-KUNDENAVN.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-KUNDENAVN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-KUNDENAVN TILBUD
ON LEAVE OF FILL-IN-KUNDENAVN IN FRAME TILBUD /* Kundenavn */
DO:
   FIND NPKUNDE WHERE NPKUNDE.kundenavn = FILL-IN-KUNDENAVN:SCREEN-VALUE NO-ERROR.
   IF NOT AVAILABLE(NPKUNDE) THEN
       DO:
           kundenrParam = "".
           kundenvnParam = "".
           RUN VELGKUND.W (INPUT-OUTPUT kundenrParam, INPUT-OUTPUT kundenvnParam,
               OUTPUT rabattParam) NO-ERROR.
           IF kundenrParam = "" THEN
               DO:
                    MESSAGE "Knytt tilbudet til en kunde, eller avslutt registrering" VIEW-AS ALERT-BOX 
                        TITLE "Feilregistrering".
                    APPLY "ENTRY" TO FILL-IN-KUNDENAVN.
                    RETURN NO-APPLY.
               END.
           ELSE 
               DO:
                    FILL-IN-KUNDENAVN = kundenvnParam.
                    npagTILBUD.kundenr = kundenrParam.
                    npagTILBUD.rabatt% = rabattParam.
                   DISPLAY FILL-IN-KUNDENAVN  npagTILBUD.rabatt%
                   WITH FRAME  {&FRAME-NAME}.
              END.
        END.
   ELSE
       DO:
          npagTILBUD.kundenr = NPKUNDE.kundenr.
          npagTILBUD.rabatt% = NPKUNDE.rabatt%_1.
           DISPLAY FILL-IN-KUNDENAVN npagTILBUD.rabatt%
           WITH FRAME  {&FRAME-NAME}.
       END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGTILBUD.vaar_ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTILBUD.vaar_ref TILBUD
ON ANY-PRINTABLE OF NPAGTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTILBUD.vaar_ref TILBUD
ON CURSOR-DOWN OF NPAGTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGTILBUD.vaar_ref TILBUD
ON CURSOR-UP OF NPAGTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK TILBUD 


/* ***************************  Main Block  *************************** */
DEF VAR laast AS LOGICAL NO-UNDO.

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
       RUN nyttTilbud.
   ELSE
    DO:
      SELECT endrings_laas INTO laast FROM NPAGANLG WHERE anleggsnr = anleggsnrParam.
       IF laast THEN
            RUN visTilbud.
       ELSE   
            RUN endreTilbud.  
     END.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI TILBUD _DEFAULT-DISABLE
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
  HIDE FRAME TILBUD.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI TILBUD _DEFAULT-ENABLE
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
  IF AVAILABLE NPAGTILBUD THEN 
    DISPLAY NPAGTILBUD.tilbudsdato NPAGTILBUD.tilbudsnr NPAGTILBUD.anleggsnr 
          NPAGTILBUD.rabatt% NPAGTILBUD.vaar_ref NPAGTILBUD.deres_ref 
          NPAGTILBUD.lev_bet NPAGTILBUD.bet_bet NPAGTILBUD.gyldighetstid 
          NPAGTILBUD.opplysninger 
      WITH FRAME TILBUD.
  ENABLE RECT-31 COMBO-SPINN NPAGTILBUD.tilbudsdato NPAGTILBUD.tilbudsnr 
         NPAGTILBUD.anleggsnr NPAGTILBUD.rabatt% NPAGTILBUD.vaar_ref 
         NPAGTILBUD.deres_ref NPAGTILBUD.lev_bet NPAGTILBUD.bet_bet 
         NPAGTILBUD.gyldighetstid NPAGTILBUD.opplysninger Btn_OK Btn_Cancel 
         Btn_Help 
      WITH FRAME TILBUD.
  {&OPEN-BROWSERS-IN-QUERY-TILBUD}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreTilbud TILBUD 
PROCEDURE endreTilbud :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND NPAGTILBUD WHERE ROWID(NPAGTILBUD) = Current-Tilbuds-Rec EXCLUSIVE-LOCK 
    NO-WAIT NO-ERROR.
  IF AVAILABLE NPAGTILBUD THEN
  DO:
      DISPLAY NPAGTILBUD.anleggsnr   
           NPAGTILBUD.tilbudsnr WITH FRAME TILBUD.
      FIND NPKUNDE WHERE NPKUNDE.kundenr = NPAGTILBUD.kundenr NO-LOCK
        NO-WAIT NO-ERROR.
      IF AVAILABLE NPKUNDE THEN  FILL-IN-KUNDENAVN = NPKUNDE.kundenavn.  
  
       UPDATE 
        NPAGTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPAGTILBUD.rabatt% NPAGTILBUD.deres_ref NPAGTILBUD.vaar_ref
        NPAGTILBUD.lev_bet NPAGTILBUD.bet_bet NPAGTILBUD.gyldighetstid
        NPAGTILBUD.opplysninger
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME TILBUD.
  END.
  ELSE
    DO:
        MESSAGE 'Tabellen er opptatt. Prøv senere.' VIEW-AS ALERT-BOX TITLE 'STOPP'.
        RETURN.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo TILBUD 
PROCEDURE fyll_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    temp-string = "".
    FOR EACH NPKONTAKT:
         IF temp-string = ""
        THEN temp-string = NPKONTAKT.kontaktperson.
        ELSE temp-string = temp-string + "," + NPKONTAKT.kontaktperson.
    END.
    /* Legg til en blank post */
    temp-string = temp-string + "," + " ".

    ASSIGN NPAGTILBUD.vaar_ref:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttTilbud TILBUD 
PROCEDURE nyttTilbud :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DEFINE VAR cAnleggsnr AS CHAR.

   iNextId = 0.

/* Tilbudsnr må settes */
  FIND LAST NPAGTILBUD  WHERE NPAGTILBUD.anleggsnr = anleggsnrParam 
  USE-INDEX ndx_siste_tilbud NO-LOCK NO-WAIT NO-ERROR.
  /* Dersom det er gitt tilbud på dette anlegget tidligere - øk teller */
  IF AVAILABLE NPAGTILBUD THEN
     iNextTilbudsnr = NPAGTILBUD.tilbudsid + 1.
  ELSE
    /* Andre gir tilbud på dette anlegget nå */
    DO:
      IF LOCKED NPAGTILBUD THEN
         DO:
             MESSAGE 'Andre gir tilbud på dette anlegget nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
                 TITLE 'STOPP'.
            RETURN.
         END.
    ELSE            
      /* Dette er første tilbud på dette anlegget */
      iNextTilbudsnr = 1.
  END.

     create NPAGTILBUD.
     Current-Tilbuds-Rec = ROWID(NPAGTILBUD).
     NPAGTILBUD.tilbudsdato = TODAY.
     NPAGTILBUD.anleggsnr = anleggsnrParam.
     NPAGTILBUD.id = iNextId.
     NPAGTILBUD.tilbudsid = iNextTilbudsnr.
    /* Tilbudsnr har dette format: år Varegruppe Anleggsnr Tilbudsid */
     /* Legg anleggsnr på riktig format */
     cAnleggsnr = String(anleggsnrParam).
     CASE LENGTH(cAnleggsnr):
        WHEN 1 THEN
            cAnleggsnr = '000' + cAnleggsnr.
        WHEN 2 THEN
            cAnleggsnr = '00' + cAnleggsnr.
        WHEN 3 THEN
            cAnleggsnr = '0' + cAnleggsnr.
      END CASE.
    /* Finn ut varegruppe */
    DEFINE VAR c_varegruppe AS CHAR INITIAL '??.'.
    FIND NPAGANLG WHERE NPAGANLG.anleggsnr = anleggsnrParam.
    IF AVAILABLE NPAGANLG THEN
    DO:
        IF   NPAGANLG.bruksomraade BEGINS 'Standard'  THEN
                c_varegruppe = '06.'.       
        ELSE IF  NPAGANLG.bruksomraade BEGINS 'Skip' THEN
                c_varegruppe = '07.'.
        ELSE IF NPAGANLG.bruksomraade BEGINS 'Offshore' THEN
                c_varegruppe = '08.'.
    END.   
     NPAGTILBUD.tilbudsnr = SUBSTRING(STRING(YEAR(Today)),3,2) + '.' + c_varegruppe   + 
         cAnleggsnr + '.' + STRING(iNextTilbudsnr).
     DISPLAY NPAGTILBUD.anleggsnr 
         NPAGTILBUD.tilbudsnr npagTILBUD.tilbudsdato 
     WITH FRAME  TILBUD.

 UPDATE 
        NPAGTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPAGTILBUD.rabatt%
        NPAGTILBUD.deres_ref npagTILBUD.vaar_ref 
        NPAGTILBUD.lev_bet npagTILBUD.bet_bet NPAGTILBUD.gyldighetstid
        NPAGTILBUD.opplysninger
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME TILBUD.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visTilbud TILBUD 
PROCEDURE visTilbud :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FIND NPAGTILBUD WHERE ROWID(NPAGTILBUD) = Current-Tilbuds-Rec NO-LOCK NO-WAIT NO-ERROR.
  IF AVAILABLE NPAGTILBUD THEN
  DO WITH FRAME TILBUD:
      FIND NPKUNDE WHERE NPKUNDE.kundenr = NPAGTILBUD.kundenr NO-LOCK
        NO-WAIT NO-ERROR.
      IF AVAILABLE NPKUNDE THEN  FILL-IN-KUNDENAVN = NPKUNDE.kundenavn.  

      DISPLAY NPAGTILBUD.anleggsnr   NPAGTILBUD.tilbudsnr 
        NPAGTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPAGTILBUD.rabatt% NPAGTILBUD.deres_ref NPAGTILBUD.vaar_ref
        NPAGTILBUD.lev_bet NPAGTILBUD.bet_bet NPAGTILBUD.gyldighetstid
        NPAGTILBUD.opplysninger
        Btn_OK. 
      UPDATE
        Btn_Cancel Btn_Help.  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


