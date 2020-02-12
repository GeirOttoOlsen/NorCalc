&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Ordre-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Ordre-Frame 
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

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER skrevetUt AS LOGICAL.
DEFINE INPUT PARAMETER cKunde LIKE NPKUNDE.kundenavn.
DEFINE INPUT PARAMETER tilbudsnrParam LIKE npagTILBUD.tilbudsnr.
DEFINE SHARED VAR tilbudsidParam LIKE npagTILBUD.id.


/* Local Variable Definitions ---                                       */
DEFINE VAR iNextId AS INTEGER.
DEFINE VAR levkundenrParam AS CHAR.
DEFINE VAR levkundenvnParam AS CHAR.
DEFINE VAR faktkundenrParam AS CHAR.
DEFINE VAR faktkundenvnParam AS CHAR.
DEFINE VAR kundenrParam AS CHAR.
DEFINE VAR kundenvnParam AS CHAR.
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR rabattParam AS DECIMAL.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Ordre-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES npagORD

/* Definitions for DIALOG-BOX Ordre-Frame                               */
&Scoped-define FIELDS-IN-QUERY-Ordre-Frame NPAGORD.ordre_dato ~
NPAGORD.referanse NPAGORD.leveringsmaate NPAGORD.leveringsdato ~
NPAGORD.lev_adresse_lik_kunde NPAGORD.lev_adresse_fritekst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Ordre-Frame NPAGORD.ordre_dato ~
NPAGORD.referanse NPAGORD.leveringsmaate NPAGORD.leveringsdato ~
NPAGORD.lev_adresse_lik_kunde NPAGORD.lev_adresse_fritekst 
&Scoped-define ENABLED-TABLES-IN-QUERY-Ordre-Frame NPAGORD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Ordre-Frame NPAGORD

&Scoped-define FIELD-PAIRS-IN-QUERY-Ordre-Frame~
 ~{&FP1}ordre_dato ~{&FP2}ordre_dato ~{&FP3}~
 ~{&FP1}referanse ~{&FP2}referanse ~{&FP3}~
 ~{&FP1}leveringsdato ~{&FP2}leveringsdato ~{&FP3}
&Scoped-define OPEN-QUERY-Ordre-Frame OPEN QUERY Ordre-Frame FOR EACH npagORD SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Ordre-Frame npagORD
&Scoped-define FIRST-TABLE-IN-QUERY-Ordre-Frame npagORD


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGORD.ordre_dato NPAGORD.referanse ~
NPAGORD.leveringsmaate NPAGORD.leveringsdato NPAGORD.lev_adresse_lik_kunde ~
NPAGORD.lev_adresse_fritekst 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}ordre_dato ~{&FP2}ordre_dato ~{&FP3}~
 ~{&FP1}referanse ~{&FP2}referanse ~{&FP3}~
 ~{&FP1}leveringsdato ~{&FP2}leveringsdato ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGORD
&Scoped-define FIRST-ENABLED-TABLE NPAGORD
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-SPINN-FAKTURA ~
FILL-IN-FAKT_ADRESSE Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGORD.ordre_dato NPAGORD.referanse ~
NPAGORD.leveringsmaate NPAGORD.leveringsdato NPAGORD.lev_adresse_lik_kunde ~
NPAGORD.lev_adresse_fritekst 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FAKT_ADRESSE VIS-Tilbudsnr ~
VIS-Kundenavn 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 9 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 9 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 9 BY 1.1
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-FAKT_ADRESSE AS CHARACTER FORMAT "X(30)":U 
     LABEL "Fakturaadresse" 
     VIEW-AS FILL-IN 
     SIZE 41 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE VIS-Kundenavn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Kundenavn" 
      VIEW-AS TEXT 
     SIZE 45 BY .62
     FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE VIS-Tilbudsnr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tilbudsnr" 
      VIEW-AS TEXT 
     SIZE 14 BY .62
     FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN-FAKTURA
     FILENAME "BMP\spinn":U
     SIZE 4 BY 1.38.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.6 BY 11.86.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Ordre-Frame FOR 
      npagORD SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Ordre-Frame
     NPAGORD.ordre_dato AT ROW 1.86 COL 59.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
          FONT 2
     NPAGORD.referanse AT ROW 4 COL 22.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.4 BY 1
          FONT 2
     NPAGORD.leveringsmaate AT ROW 5.33 COL 51.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Post","Bil-stykkgods","Bil-spesial u/lift","Bil-spesial m/lift","Bil-spesial u/kran","Bil-spesial m/kran","Buss","Bane","B†t","Fly","Hentes" 
          SIZE 24.2 BY 1
          FONT 2
     NPAGORD.leveringsdato AT ROW 5.38 COL 22.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
          FONT 2
     NPAGORD.lev_adresse_lik_kunde AT ROW 6.71 COL 24.6
          LABEL "Lik kundeadresse"
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .76
     NPAGORD.lev_adresse_fritekst AT ROW 7.52 COL 24.6 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200
          SIZE 34 BY 3.52
          FONT 2
     FILL-IN-FAKT_ADRESSE AT ROW 11.29 COL 22.6 COLON-ALIGNED
     Btn_OK AT ROW 13.86 COL 26.4
     Btn_Cancel AT ROW 13.86 COL 38.4
     Btn_Help AT ROW 13.86 COL 50.4
     VIS-Tilbudsnr AT ROW 1.86 COL 22.6 COLON-ALIGNED
     VIS-Kundenavn AT ROW 2.91 COL 22.6 COLON-ALIGNED
     RECT-1 AT ROW 1.29 COL 2
     "Leveringsadresse:" VIEW-AS TEXT
          SIZE 18 BY .62 AT ROW 6.67 COL 4
     COMBO-SPINN-FAKTURA AT ROW 11.33 COL 66
     SPACE(14.19) SKIP(3.33)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Endre/Se på Aggregat - Ordre"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Ordre-Frame
                                                                        */
ASSIGN 
       FRAME Ordre-Frame:SCROLLABLE       = FALSE
       FRAME Ordre-Frame:HIDDEN           = TRUE.

ASSIGN 
       NPAGORD.lev_adresse_fritekst:RETURN-INSERTED IN FRAME Ordre-Frame  = TRUE.

/* SETTINGS FOR TOGGLE-BOX NPAGORD.lev_adresse_lik_kunde IN FRAME Ordre-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN VIS-Kundenavn IN FRAME Ordre-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN VIS-Tilbudsnr IN FRAME Ordre-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Ordre-Frame
/* Query rebuild information for DIALOG-BOX Ordre-Frame
     _TblList          = "norcalc.npagORD"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Ordre-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Ordre-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Ordre-Frame Ordre-Frame
ON WINDOW-CLOSE OF FRAME Ordre-Frame /* Endre/Se på Aggregat - Ordre */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Ordre-Frame
ON CHOOSE OF Btn_Help IN FRAME Ordre-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Ordre-Frame
ON CHOOSE OF Btn_OK IN FRAME Ordre-Frame /* OK */
DO:
    IF npagORD.lev_adresse_fritekst  = "" OR
         FILL-IN-FAKT_ADRESSE = "" THEN    /* Ok trykket uten at kunde eller leveringadresse
             er valgt -- ulovlig! */
        APPLY 'CHOOSE' TO Btn_Cancel.
    ELSE
        DO:
            /* Set status på oppfølging til 'ORDRE' */
            FIND LAST npagTOPP WHERE npagTOPP.id = tilbudsIdParam EXCLUSIVE-LOCK 
                NO-WAIT NO-ERROR.
            IF AVAILABLE NPAGTOPP THEN
                    ASSIGN NPAGTOPP.oppf_status = 'ORDRE' 
                                      NPAGTOPP.oppf_dato = TODAY.
        END.          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-SPINN-FAKTURA
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-SPINN-FAKTURA Ordre-Frame
ON MOUSE-SELECT-CLICK OF COMBO-SPINN-FAKTURA IN FRAME Ordre-Frame
DO:
    APPLY "LEAVE"  TO FILL-IN-FAKT_ADRESSE.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-FAKT_ADRESSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-FAKT_ADRESSE Ordre-Frame
ON LEAVE OF FILL-IN-FAKT_ADRESSE IN FRAME Ordre-Frame /* Fakturaadresse */
DO:
   FIND NPKUNDE WHERE NPKUNDE.kundenavn = FILL-IN-FAKT_ADRESSE:SCREEN-VALUE NO-ERROR.
   IF NOT AVAILABLE(NPKUNDE) THEN
       DO:
           faktkundenrParam = "".
           faktkundenvnParam = "".
           RUN VELGKUND.W (INPUT-OUTPUT faktkundenrParam, INPUT-OUTPUT faktkundenvnParam,
               OUTPUT rabattParam) NO-ERROR.
    
           IF faktkundenrParam = "" THEN
               DO:
                    MESSAGE "Knytt ordren til en fakturaadresse, eller avslutt registrering" VIEW-AS ALERT-BOX 
                        TITLE "Feilregistrering".
                    APPLY "ENTRY" TO FILL-IN-FAKT_ADRESSE.
                    RETURN NO-APPLY.
               END.
           ELSE 
               DO:
                    /* Kunderecord må finnes for å hente adresse etc. */
                    FIND NPKUNDE WHERE kundenr = faktKundenrParam NO-ERROR.
                    IF AVAILABLE NPKUNDE THEN
                        DO:
                            FILL-IN-FAKT_ADRESSE = NPKUNDE.kundenavn.
                            npagORD.faktura_kundeid = NPKUNDE.kundenr.
                            npagORD.fakt_kundenavn = NPKUNDE.kundenavn.
                            npagORD.fakt_adresse1 = NPKUNDE.adresse1.
                            npagORD.fakt_adresse2 = NPKUNDE.adresse2.
                            npagORD.fakt_postnr = NPKUNDE.postnr.
                            npagORD.fakt_poststed = NPKUNDE.poststed.
                            npagORD.fakt_land = NPKUNDE.land.
                           DISPLAY FILL-IN-FAKT_ADRESSE 
                            WITH FRAME  {&FRAME-NAME}.
                       END.
                   ELSE
                        DO:
                            MESSAGE 'Mistet kontakt med databasen' VIEW-AS ALERT-BOX TITLE 'Databasefeil'.
                            RETURN NO-APPLY.
                         END.
              END.
        END.
   ELSE
       DO:
           FILL-IN-FAKT_ADRESSE = NPKUNDE.kundenavn.
           npagORD.faktura_kundeid = NPKUNDE.kundenr.
           npagORD.fakt_kundenavn = NPKUNDE.kundenavn.
           npagORD.fakt_adresse1 = NPKUNDE.adresse1.
           npagORD.fakt_adresse2 = NPKUNDE.adresse2.
           npagORD.fakt_postnr = NPKUNDE.postnr.
           npagORD.fakt_poststed = NPKUNDE.poststed.
           npagORD.fakt_land = NPKUNDE.land.
           DISPLAY FILL-IN-FAKT_ADRESSE 
                WITH FRAME  {&FRAME-NAME}.
       END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGORD.lev_adresse_lik_kunde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGORD.lev_adresse_lik_kunde Ordre-Frame
ON VALUE-CHANGED OF NPAGORD.lev_adresse_lik_kunde IN FRAME Ordre-Frame /* Lik kundeadresse */
DO:   
  ASSIGN npagORD.lev_adresse_lik_kunde.
  IF npagORD.lev_adresse_lik_kunde = TRUE THEN
    HIDE npagORD.lev_adresse_fritekst.
  ELSE
    ENABLE npagORD.lev_adresse_fritekst WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Ordre-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  pointer = SESSION:SET-WAIT-STATE("").   
  RUN endreOrdre.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Ordre-Frame _DEFAULT-DISABLE
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
  HIDE FRAME Ordre-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Ordre-Frame _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Ordre-Frame}
  GET FIRST Ordre-Frame.
  DISPLAY FILL-IN-FAKT_ADRESSE VIS-Tilbudsnr VIS-Kundenavn 
      WITH FRAME Ordre-Frame.
  IF AVAILABLE NPAGORD THEN 
    DISPLAY NPAGORD.ordre_dato NPAGORD.referanse NPAGORD.leveringsmaate 
          NPAGORD.leveringsdato NPAGORD.lev_adresse_lik_kunde 
          NPAGORD.lev_adresse_fritekst 
      WITH FRAME Ordre-Frame.
  ENABLE RECT-1 COMBO-SPINN-FAKTURA NPAGORD.ordre_dato NPAGORD.referanse 
         NPAGORD.leveringsmaate NPAGORD.leveringsdato 
         NPAGORD.lev_adresse_lik_kunde NPAGORD.lev_adresse_fritekst 
         FILL-IN-FAKT_ADRESSE Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Ordre-Frame.
  VIEW FRAME Ordre-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Ordre-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreOrdre Ordre-Frame 
PROCEDURE endreOrdre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FIND  npagORD  WHERE npagORD.tilbudsId = tilbudsIdParam NO-WAIT NO-ERROR.
  IF AVAILABLE(npagORD) THEN
    DO:   
     VIS-Kundenavn = cKunde.
     VIS-Tilbudsnr = tilbudsnrParam.
     
    DISPLAY VIS-Tilbudsnr VIS-Kundenavn
          WITH FRAME Ordre-Frame.
        /* Vis faktura adresse info */
        FILL-IN-FAKT_ADRESSE = npagORD.fakt_kundenavn.           
        /* Dersom ordregrunnlag er overført - ingen ting skal oppdateres*/
        IF overfoert  THEN
            DO:
                DISPLAY
                    npagORD.ordre_dato npagORD.referanse npagORD.leveringsdato
                    npagORD.leveringsmaate npagORD.lev_adresse_lik_kunde 
                    npagORD.lev_adresse_fritekst
                    FILL-IN-FAKT_ADRESSE 
                    WITH FRAME Ordre-Frame.
                HIDE COMBO-SPINN-FAKTURA.
                UPDATE
                   Btn_Cancel 
                 WITH FRAME Ordre-Frame.
             END.
        ELSE
        /* Ordregrunnlag er ikke overført - endringer mulig */
             UPDATE 
               npagORD.ordre_dato npagORD.referanse npagORD.leveringsdato
               npagORD.leveringsmaate npagORD.lev_adresse_lik_kunde
               npagORD.lev_adresse_fritekst
               FILL-IN-FAKT_ADRESSE COMBO-SPINN-FAKTURA
           Btn_OK Btn_Cancel Btn_Help 
              WITH FRAME Ordre-Frame.             
    END.
    ELSE
        DO:
            MESSAGE 'Det er allerede avgitt ordre på dette tilbudet.' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN.
        END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


