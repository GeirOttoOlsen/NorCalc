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
/*DEFINE INPUT PARAMETER appdata AS CHARACTER.      */
/*DEFINE INPUT-OUTPUT PARAMETER nyRecord AS LOGICAL.*/
/*DEFINE OUTPUT PARAMETER nyId AS INTEGER INITIAL 0.*/
def var appdata as char no-undo. /*setter den via JboxSession:AppTitle*/
appdata = JBoxSession:Instance:AppTitle.
def var hParent as handle no-undo.

DEFINE VAR Current-Rec AS ROWID.
DEFINE VAR anleggsnrParam LIKE NPSHANLG.anleggsnr.
def var nyRecord as logical no-undo.
def var ip_nest_id as int no-undo.
def var Nyid as int no-undo.
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
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME TILBUD

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHTILBUD.vaar_ref NPSHTILBUD.gyldighetstid ~
NPSHTILBUD.opplysninger 
&Scoped-define ENABLED-TABLES NPSHTILBUD
&Scoped-define FIRST-ENABLED-TABLE NPSHTILBUD
&Scoped-Define ENABLED-OBJECTS COMBO-SPINN RECT-31 Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSHTILBUD.vaar_ref ~
NPSHTILBUD.gyldighetstid NPSHTILBUD.opplysninger 
&Scoped-define DISPLAYED-TABLES NPSHTILBUD
&Scoped-define FIRST-DISPLAYED-TABLE NPSHTILBUD


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
     SIZE 3.6 BY 1.24.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 123.2 BY 16.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME TILBUD
     NPSHTILBUD.anleggsnr AT ROW 1.95 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHTILBUD.tilbudsnr AT ROW 1.95 COL 48 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.6 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHTILBUD.tilbudsdato AT ROW 1.95 COL 96 COLON-ALIGNED
          LABEL "Dato"
          VIEW-AS FILL-IN NATIVE 
          SIZE 14.2 BY 1.24
          FONT 2
     FILL-IN-KUNDENAVN AT ROW 4.14 COL 18.4 COLON-ALIGNED
     NPSHTILBUD.deres_ref AT ROW 5.76 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 35.2 BY 1.24
          FONT 2
     NPSHTILBUD.vaar_ref AT ROW 5.76 COL 72 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          DROP-DOWN-LIST
          SIZE 32.4 BY 1
     NPSHTILBUD.rabatt% AT ROW 7.43 COL 37 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 11.2 BY 1.24
          FONT 2
     NPSHTILBUD.lev_bet AT ROW 8.86 COL 37 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "AB LAGER","FOB","CIF" 
          DROP-DOWN-LIST
          SIZE 18.4 BY 1
          FONT 2
     NPSHTILBUD.bet_bet AT ROW 10.05 COL 37 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Netto pr. 30 dager","Frimnd. + 30 dager","Netto pr. 45 dager","Netto pr. 60 dager","Netto pr. 15 dager","Netto pr. 10 dager","Kontant","Oppkrav" 
          DROP-DOWN-LIST
          SIZE 33.8 BY 1
          FONT 2
     NPSHTILBUD.gyldighetstid AT ROW 10.05 COL 94 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.2 BY 1.24
     NPSHTILBUD.opplysninger AT ROW 11.71 COL 4 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 119.4 BY 4.52
          FONT 2
     Btn_OK AT ROW 16.48 COL 84
     Btn_Cancel AT ROW 16.48 COL 98
     Btn_Help AT ROW 16.48 COL 110.8
     "Opplysning:" VIEW-AS TEXT
          SIZE 16.4 BY .81 AT ROW 10.76 COL 4
     "dager" VIEW-AS TEXT
          SIZE 11.2 BY .76 AT ROW 10.33 COL 103
     COMBO-SPINN AT ROW 4.29 COL 78.4
     RECT-31 AT ROW 1.43 COL 2.4
     SPACE(0.40) SKIP(0.33)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Tilbud på shuntanlegg":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX TILBUD
   NOT-VISIBLE FRAME-NAME UNDERLINE                                     */
ASSIGN 
       FRAME TILBUD:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPSHTILBUD.anleggsnr IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSHTILBUD.bet_bet IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHTILBUD.deres_ref IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-KUNDENAVN IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSHTILBUD.lev_bet IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHTILBUD.rabatt% IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHTILBUD.tilbudsdato IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPSHTILBUD.tilbudsnr IN FRAME TILBUD
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX TILBUD
/* Query rebuild information for DIALOG-BOX TILBUD
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
        IF nyRecord THEN DO:
            define var cp_tabell_navn as char.
            define var ip_neste_id as integer.

            cp_tabell_navn  = 'npshtilbud'.
            run neste_id.p (input cp_tabell_navn, output ip_neste_id).
            ASSIGN NPSHTILBUD.id = ip_neste_id
                nyId = ip_neste_id.
            current-rec = ROWID(NPSHTILBUD).
        END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel TILBUD
ON CHOOSE OF Btn_Cancel IN FRAME TILBUD /* Cancel */
DO:
  dynamic-function('setCurrentRec' in hParent,?).
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
                    NPSHTILBUD.kundenr = kundenrParam.
                    NPSHTILBUD.rabatt% = rabattParam.
                   DISPLAY FILL-IN-KUNDENAVN  NPSHTILBUD.rabatt%
                   WITH FRAME  {&FRAME-NAME}.
              END.
        END.
   ELSE
       DO:
          NPSHTILBUD.kundenr = NPKUNDE.kundenr.
          NPSHTILBUD.rabatt% = NPKUNDE.rabatt%_1.
           DISPLAY FILL-IN-KUNDENAVN NPSHTILBUD.rabatt%
           WITH FRAME  {&FRAME-NAME}.
       END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTILBUD.vaar_ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILBUD.vaar_ref TILBUD
ON ANY-PRINTABLE OF NPSHTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILBUD.vaar_ref TILBUD
ON CURSOR-DOWN OF NPSHTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILBUD.vaar_ref TILBUD
ON CURSOR-UP OF NPSHTILBUD.vaar_ref IN FRAME TILBUD /* Vår ref. */
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
   SESSION:SET-WAIT-STATE("").   
  hParent = source-procedure.
  current-rec = dynamic-function('getCurrentRec' in hParent).
  nyRecord    = logical(dynamic-function('getNyRecord' in hParent)).
  anleggsnrParam = int(dynamic-function("getAttribute",hParent,'AnleggsnrParam')).
   RUN fyll_combo.
   IF nyRecord THEN   
        RUN nyttTilbud.
   ELSE
        DO:
           SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = anleggsnrParam.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI TILBUD  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI TILBUD  _DEFAULT-ENABLE
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
  IF AVAILABLE NPSHTILBUD THEN 
    DISPLAY NPSHTILBUD.vaar_ref NPSHTILBUD.gyldighetstid NPSHTILBUD.opplysninger 
      WITH FRAME TILBUD.
  ENABLE COMBO-SPINN RECT-31 NPSHTILBUD.vaar_ref NPSHTILBUD.gyldighetstid 
         NPSHTILBUD.opplysninger Btn_OK Btn_Cancel Btn_Help 
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
  FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD) = current-rec EXCLUSIVE-LOCK 
    NO-WAIT NO-ERROR.
  IF AVAILABLE NPSHTILBUD THEN
  DO:
      DISPLAY NPSHTILBUD.anleggsnr   
           NPSHTILBUD.tilbudsnr WITH FRAME TILBUD.
      FIND NPKUNDE WHERE NPKUNDE.kundenr = NPSHTILBUD.kundenr NO-LOCK
        NO-WAIT NO-ERROR.
      IF AVAILABLE NPKUNDE THEN  FILL-IN-KUNDENAVN = NPKUNDE.kundenavn.  
  
       UPDATE 
        NPSHTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPSHTILBUD.rabatt% NPSHTILBUD.deres_ref NPSHTILBUD.vaar_ref
        NPSHTILBUD.lev_bet NPSHTILBUD.bet_bet NPSHTILBUD.gyldighetstid
        NPSHTILBUD.opplysninger
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

    ASSIGN NPSHTILBUD.vaar_ref:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

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
  FIND LAST NPSHTILBUD  WHERE NPSHTILBUD.anleggsnr = anleggsnrParam 
  USE-INDEX ndx_siste_tilbud  NO-LOCK NO-WAIT NO-ERROR.
  /* Dersom det er gitt tilbud på dette anlegget tidligere - øk teller */
  IF AVAILABLE(NPSHTILBUD) THEN
     iNextTilbudsnr = NPSHTILBUD.tilbudsid + 1.
  ELSE
    /* Andre gir tilbud på dette anlegget nå */
    DO:
      IF LOCKED NPSHTILBUD THEN
         DO:
             MESSAGE 'Andre gir tilbud på dette anlegget nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
                 TITLE 'STOPP'.
            RETURN.
         END.
    ELSE            
      /* Dette er første tilbud på dette anlegget */
      iNextTilbudsnr = 1.
  END.

     create npshtilbud.
     NPSHTILBUD.tilbudsdato = TODAY.
     NPSHTILBUD.anleggsnr = anleggsnrParam.
     NPSHTILBUD.id = iNextId.
     NPSHTILBUD.tilbudsid = iNextTilbudsnr.
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
     NPSHTILBUD.tilbudsnr = SUBSTRING(STRING(YEAR(Today)),3,2) + '.' +  '01.' + 
         cAnleggsnr + '.' + STRING(iNextTilbudsnr).
     DISPLAY NPSHTILBUD.anleggsnr 
         NPSHTILBUD.tilbudsnr NPSHTILBUD.tilbudsdato 
     WITH FRAME  {&FRAME-NAME}.

 UPDATE 
        NPSHTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPSHTILBUD.rabatt%
        NPSHTILBUD.deres_ref NPSHTILBUD.vaar_ref 
        NPSHTILBUD.lev_bet NPSHTILBUD.bet_bet NPSHTILBUD.gyldighetstid
        NPSHTILBUD.opplysninger
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME TILBUD.
       Current-Rec = ROWID(npshtilbud).
       dynamic-function('setCurrentRec' in hParent,current-rec).
 
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
  FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD) = current-rec NO-LOCK  NO-WAIT NO-ERROR.
  IF AVAILABLE NPSHTILBUD THEN
  DO WITH FRAME TILBUD:
      FIND NPKUNDE WHERE NPKUNDE.kundenr = NPSHTILBUD.kundenr NO-LOCK
        NO-WAIT NO-ERROR.
      IF AVAILABLE NPKUNDE THEN  FILL-IN-KUNDENAVN = NPKUNDE.kundenavn.  

      DISPLAY NPSHTILBUD.anleggsnr   
           NPSHTILBUD.tilbudsnr 
        NPSHTILBUD.tilbudsdato  FILL-IN-KUNDENAVN COMBO-SPINN 
        NPSHTILBUD.rabatt% NPSHTILBUD.deres_ref NPSHTILBUD.vaar_ref
        NPSHTILBUD.lev_bet NPSHTILBUD.bet_bet NPSHTILBUD.gyldighetstid
        NPSHTILBUD.opplysninger Btn_OK.
        
     UPDATE  Btn_Cancel Btn_Help.
     
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

