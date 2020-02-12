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
DEFINE INPUT-OUTPUT  PARAMETER  nyRecord AS LOGICAL.
DEFINE OUTPUT PARAMETER nyId AS INTEGER INITIAL 0.
DEFINE SHARED VAR Current-Tilbuds-Rec AS ROWID.
DEFINE SHARED VAR anleggsnrParam LIKE NPSPANLG.anleggsnr.

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
&Scoped-define INTERNAL-TABLES NPSPTILBUD

/* Definitions for DIALOG-BOX TILBUD                                    */
&Scoped-define FIELDS-IN-QUERY-TILBUD NPSPTILBUD.anleggsnr ~
NPSPTILBUD.tilbudsnr NPSPTILBUD.tilbudsdato NPSPTILBUD.rabatt% ~
NPSPTILBUD.deres_ref NPSPTILBUD.vaar_ref NPSPTILBUD.lev_bet ~
NPSPTILBUD.bet_bet NPSPTILBUD.gyldighetstid NPSPTILBUD.opplysninger 
&Scoped-define ENABLED-FIELDS-IN-QUERY-TILBUD NPSPTILBUD.anleggsnr ~
NPSPTILBUD.tilbudsnr NPSPTILBUD.tilbudsdato NPSPTILBUD.rabatt% ~
NPSPTILBUD.deres_ref NPSPTILBUD.vaar_ref NPSPTILBUD.lev_bet ~
NPSPTILBUD.bet_bet NPSPTILBUD.gyldighetstid NPSPTILBUD.opplysninger 
&Scoped-define ENABLED-TABLES-IN-QUERY-TILBUD NPSPTILBUD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-TILBUD NPSPTILBUD

&Scoped-define FIELD-PAIRS-IN-QUERY-TILBUD~
 ~{&FP1}anleggsnr ~{&FP2}anleggsnr ~{&FP3}~
 ~{&FP1}tilbudsnr ~{&FP2}tilbudsnr ~{&FP3}~
 ~{&FP1}tilbudsdato ~{&FP2}tilbudsdato ~{&FP3}~
 ~{&FP1}rabatt% ~{&FP2}rabatt% ~{&FP3}~
 ~{&FP1}deres_ref ~{&FP2}deres_ref ~{&FP3}~
 ~{&FP1}gyldighetstid ~{&FP2}gyldighetstid ~{&FP3}
&Scoped-define OPEN-QUERY-TILBUD OPEN QUERY TILBUD FOR EACH NPSPTILBUD SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-TILBUD NPSPTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-TILBUD NPSPTILBUD


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSPTILBUD.anleggsnr NPSPTILBUD.tilbudsnr ~
NPSPTILBUD.tilbudsdato NPSPTILBUD.rabatt% NPSPTILBUD.deres_ref ~
NPSPTILBUD.vaar_ref NPSPTILBUD.lev_bet NPSPTILBUD.bet_bet ~
NPSPTILBUD.gyldighetstid NPSPTILBUD.opplysninger 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}anleggsnr ~{&FP2}anleggsnr ~{&FP3}~
 ~{&FP1}tilbudsnr ~{&FP2}tilbudsnr ~{&FP3}~
 ~{&FP1}tilbudsdato ~{&FP2}tilbudsdato ~{&FP3}~
 ~{&FP1}rabatt% ~{&FP2}rabatt% ~{&FP3}~
 ~{&FP1}deres_ref ~{&FP2}deres_ref ~{&FP3}~
 ~{&FP1}gyldighetstid ~{&FP2}gyldighetstid ~{&FP3}
&Scoped-define ENABLED-TABLES NPSPTILBUD
&Scoped-define FIRST-ENABLED-TABLE NPSPTILBUD
&Scoped-Define ENABLED-OBJECTS COMBO-SPINN RECT-31 Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSPTILBUD.anleggsnr NPSPTILBUD.tilbudsnr ~
NPSPTILBUD.tilbudsdato NPSPTILBUD.rabatt% NPSPTILBUD.deres_ref ~
NPSPTILBUD.vaar_ref NPSPTILBUD.lev_bet NPSPTILBUD.bet_bet ~
NPSPTILBUD.gyldighetstid NPSPTILBUD.opplysninger 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancel":L 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&OK":L 
     SIZE 11.2 BY 1.24
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-KUNDENAVN AS CHARACTER FORMAT "X(30)":U 
     LABEL "Kundenavn" 
     VIEW-AS FILL-IN 
     SIZE 57.4 BY 1.24
     FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN
     FILENAME "bmp\spinn":U
     SIZE 3.6 BY 1.1.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 123.2 BY 14.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY TILBUD FOR 
      NPSPTILBUD SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME TILBUD
     NPSPTILBUD.anleggsnr AT ROW 2.43 COL 18.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.4 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPTILBUD.tilbudsnr AT ROW 2.43 COL 49.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 30 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPTILBUD.tilbudsdato AT ROW 2.38 COL 98.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     FILL-IN-KUNDENAVN AT ROW 4.14 COL 18.4 COLON-ALIGNED
     NPSPTILBUD.rabatt% AT ROW 5.67 COL 18.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.2 BY 1.24
          FONT 2
     NPSPTILBUD.deres_ref AT ROW 5.67 COL 46.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 33.8 BY 1.24
          FONT 2
     NPSPTILBUD.vaar_ref AT ROW 5.57 COL 91.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","" 
          SIZE 30.8 BY 1
     NPSPTILBUD.lev_bet AT ROW 7.19 COL 18.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "AB LAGER","FOB","CIF MM" 
          SIZE 22.6 BY 1
          FONT 2
     NPSPTILBUD.bet_bet AT ROW 7.14 COL 53 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Netto pr. 30 dager","Frimnd. + 30 dager","Netto pr. 45 dager","Netto pr. 60 dager","Netto pr. 15 dager","Netto pr. 10 dager","Kontant","Oppkrav" 
          SIZE 33.8 BY 1
          FONT 2
     NPSPTILBUD.gyldighetstid AT ROW 7.19 COL 105.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.2 BY 1.24
     NPSPTILBUD.opplysninger AT ROW 9.67 COL 8.8 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-VERTICAL
          SIZE 102.8 BY 5.57
          FONT 2
     Btn_OK AT ROW 16.67 COL 45.8
     Btn_Cancel AT ROW 16.67 COL 58.2
     Btn_Help AT ROW 16.67 COL 70.2
     COMBO-SPINN AT ROW 4.24 COL 78.6
     RECT-31 AT ROW 1.43 COL 2.4
     "dager" VIEW-AS TEXT
          SIZE 9 BY .76 AT ROW 7.48 COL 114.2
     "Opplysninger:" VIEW-AS TEXT
          SIZE 18.4 BY .81 AT ROW 8.81 COL 3.6
     SPACE(103.99) SKIP(8.85)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Tilbud på spiroventanlegg":L
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
   NOT-VISIBLE UNDERLINE Custom                                         */
ASSIGN 
       FRAME TILBUD:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN FILL-IN-KUNDENAVN IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX TILBUD
/* Query rebuild information for DIALOG-BOX TILBUD
     _TblList          = "norcalc.NPSPTILBUD"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX TILBUD */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

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

                cp_tabell_navn  = 'npsptilbud'.
                 run neste_id.p (input cp_tabell_navn, output ip_neste_id).
                 ASSIGN NPSPTILBUD.id = ip_neste_id
                    nyId = ip_neste_id.
                Current-Tilbuds-Rec = ROWID(NPSPTILBUD).
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
                    NPSPTILBUD.kundenr = kundenrParam.
                    NPSPTILBUD.rabatt% = rabattParam.
                   DISPLAY FILL-IN-KUNDENAVN  NPSPTILBUD.rabatt%
                   WITH FRAME  {&FRAME-NAME}.
              END.
        END.
   ELSE
       DO:
          NPSPTILBUD.kundenr = NPKUNDE.kundenr.
          NPSPTILBUD.rabatt% = NPKUNDE.rabatt%_1.
           DISPLAY FILL-IN-KUNDENAVN NPSPTILBUD.rabatt%
           WITH FRAME  {&FRAME-NAME}.
       END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPTILBUD.vaar_ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTILBUD.vaar_ref TILBUD
ON ANY-PRINTABLE OF NPSPTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTILBUD.vaar_ref TILBUD
ON CURSOR-DOWN OF NPSPTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPTILBUD.vaar_ref TILBUD
ON CURSOR-UP OF NPSPTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
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
DEFINE VAR laast AS LOGICAL NO-UNDO.

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
        SELECT endrings_laas INTO laast FROM NPSPANLG WHERE anleggsnr = anleggsnrParam.
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
  IF AVAILABLE NPSPTILBUD THEN 
    DISPLAY NPSPTILBUD.anleggsnr NPSPTILBUD.tilbudsnr NPSPTILBUD.tilbudsdato 
          NPSPTILBUD.rabatt% NPSPTILBUD.deres_ref NPSPTILBUD.vaar_ref 
          NPSPTILBUD.lev_bet NPSPTILBUD.bet_bet NPSPTILBUD.gyldighetstid 
          NPSPTILBUD.opplysninger 
      WITH FRAME TILBUD.
  ENABLE COMBO-SPINN RECT-31 NPSPTILBUD.anleggsnr NPSPTILBUD.tilbudsnr 
         NPSPTILBUD.tilbudsdato NPSPTILBUD.rabatt% NPSPTILBUD.deres_ref 
         NPSPTILBUD.vaar_ref NPSPTILBUD.lev_bet NPSPTILBUD.bet_bet 
         NPSPTILBUD.gyldighetstid NPSPTILBUD.opplysninger Btn_OK Btn_Cancel 
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
  FIND NPSPTILBUD WHERE ROWID(NPSPTILBUD) = Current-Tilbuds-Rec EXCLUSIVE-LOCK 
    NO-WAIT NO-ERROR.
  IF AVAILABLE NPSPTILBUD THEN
  DO:
      DISPLAY NPSPTILBUD.anleggsnr   
           NPSPTILBUD.tilbudsnr WITH FRAME TILBUD.
      FIND NPKUNDE WHERE NPKUNDE.kundenr = NPSPTILBUD.kundenr NO-LOCK
        NO-WAIT NO-ERROR.
      IF AVAILABLE NPKUNDE THEN  FILL-IN-KUNDENAVN = NPKUNDE.kundenavn.  
  
       UPDATE 
        NPSPTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPSPTILBUD.rabatt% NPSPTILBUD.deres_ref NPSPTILBUD.vaar_ref
        NPSPTILBUD.lev_bet NPSPTILBUD.bet_bet NPSPTILBUD.gyldighetstid
        NPSPTILBUD.opplysninger
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

    ASSIGN NPSPTILBUD.vaar_ref:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

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
  FIND LAST NPSPTILBUD  WHERE NPSPTILBUD.anleggsnr = anleggsnrParam 
  USE-INDEX ndx_siste_tilbud NO-LOCK NO-WAIT NO-ERROR.
  /* Dersom det er gitt tilbud på dette anlegget tidligere - øk teller */
  IF AVAILABLE(NPSPTILBUD) THEN
     iNextTilbudsnr = NPSPTILBUD.tilbudsid + 1.
  ELSE
    /* Andre gir tilbud på dette anlegget nå */
    DO:
      IF LOCKED NPSPTILBUD THEN
         DO:
             MESSAGE 'Andre gir tilbud på dette anlegget nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
                 TITLE 'STOPP'.
            RETURN.
         END.
    ELSE            
      /* Dette er første tilbud på dette anlegget */
      iNextTilbudsnr = 1.
  END.

     create NPSPTILBUD.
     NPSPTILBUD.tilbudsdato = TODAY.
     NPSPTILBUD.anleggsnr = anleggsnrParam.
     NPSPTILBUD.id = iNextId.
     NPSPTILBUD.tilbudsid = iNextTilbudsnr.
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
     NPSPTILBUD.tilbudsnr = SUBSTRING(STRING(YEAR(Today)),3,2) + '.' +  '11.' + 
         cAnleggsnr + '.' + STRING(iNextTilbudsnr).
     DISPLAY NPSPTILBUD.anleggsnr 
         NPSPTILBUD.tilbudsnr NPSPTILBUD.tilbudsdato 
     WITH FRAME  TILBUD.

 UPDATE 
        NPSPTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPSPTILBUD.rabatt%
        NPSPTILBUD.deres_ref NPSPTILBUD.vaar_ref 
        NPSPTILBUD.lev_bet NPSPTILBUD.bet_bet NPSPTILBUD.gyldighetstid
        NPSPTILBUD.opplysninger
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
  FIND NPSPTILBUD WHERE ROWID(NPSPTILBUD) = Current-Tilbuds-Rec NO-LOCK   NO-WAIT NO-ERROR.
  IF AVAILABLE NPSPTILBUD THEN
  DO WITH FRAME TILBUD:
      FIND NPKUNDE WHERE NPKUNDE.kundenr = NPSPTILBUD.kundenr NO-LOCK
        NO-WAIT NO-ERROR.
      IF AVAILABLE NPKUNDE THEN  FILL-IN-KUNDENAVN = NPKUNDE.kundenavn.  
  
      DISPLAY NPSPTILBUD.anleggsnr   
        NPSPTILBUD.tilbudsnr         
        NPSPTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPSPTILBUD.rabatt% NPSPTILBUD.deres_ref NPSPTILBUD.vaar_ref
        NPSPTILBUD.lev_bet NPSPTILBUD.bet_bet NPSPTILBUD.gyldighetstid
        NPSPTILBUD.opplysninger.

    UPDATE    Btn_Cancel Btn_Help.
  END.
  ELSE
    DO:
        MESSAGE 'Tabellen er opptatt. Prøv senere.' VIEW-AS ALERT-BOX TITLE 'STOPP'.
        RETURN.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


