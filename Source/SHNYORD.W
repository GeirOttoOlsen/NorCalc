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
def var appdata as char no-undo. /*setter den via JboxSession:AppTitle*/
appdata = JBoxSession:Instance:AppTitle.
def var hParent as handle no-undo.
def var current-rec as rowid no-undo.

/*DEFINE var cKunde LIKE NPKUNDE.kundenavn.            */
/*DEFINE var tilbudsnrParam LIKE NPSHTILBUD.tilbudsnr. */
/*DEFINE  VAR tilbudsidParam LIKE NPSHTILBUD.id.       */
/*DEFINE  VAR anleggsnrParam LIKE NPSHTILBUD.anleggsnr.*/

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
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Ordre-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHORD

/* Definitions for DIALOG-BOX Ordre-Frame                               */
&Scoped-define FIELDS-IN-QUERY-Ordre-Frame NPSHORD.ordre_dato ~
NPSHORD.referanse NPSHORD.leveringsdato NPSHORD.leveringsmaate ~
NPSHORD.lev_adresse_lik_kunde NPSHORD.lev_adresse_fritekst 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Ordre-Frame NPSHORD.ordre_dato ~
NPSHORD.referanse NPSHORD.leveringsdato NPSHORD.leveringsmaate ~
NPSHORD.lev_adresse_lik_kunde NPSHORD.lev_adresse_fritekst 
&Scoped-define ENABLED-TABLES-IN-QUERY-Ordre-Frame NPSHORD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Ordre-Frame NPSHORD
&Scoped-define OPEN-QUERY-Ordre-Frame OPEN QUERY Ordre-Frame FOR EACH NPSHORD SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Ordre-Frame NPSHORD
&Scoped-define FIRST-TABLE-IN-QUERY-Ordre-Frame NPSHORD


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHORD.ordre_dato NPSHORD.referanse ~
NPSHORD.leveringsdato NPSHORD.leveringsmaate NPSHORD.lev_adresse_lik_kunde ~
NPSHORD.lev_adresse_fritekst 
&Scoped-define ENABLED-TABLES NPSHORD
&Scoped-define FIRST-ENABLED-TABLE NPSHORD
&Scoped-define DISPLAYED-TABLES NPSHORD
&Scoped-define FIRST-DISPLAYED-TABLE NPSHORD
&Scoped-Define ENABLED-OBJECTS FILL-IN-FAKT_ADRESSE FILL-IN-prod_nr Btn_OK ~
Btn_Cancel Btn_Help COMBO-SPINN-FAKTURA RECT-1 
&Scoped-Define DISPLAYED-FIELDS NPSHORD.ordre_dato NPSHORD.referanse ~
NPSHORD.leveringsdato NPSHORD.leveringsmaate NPSHORD.lev_adresse_lik_kunde ~
NPSHORD.lev_adresse_fritekst 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-FAKT_ADRESSE FILL-IN-prod_nr ~
VIS-Tilbudsnr VIS-Kundenavn FILL-IN-prod_nr_prefix 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12.6 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 12.6 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12.6 BY 1.38
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN-FAKT_ADRESSE AS CHARACTER FORMAT "X(30)":U 
     LABEL "Fakturaadresse" 
     VIEW-AS FILL-IN 
     SIZE 57.4 BY 1.24
     BGCOLOR 15 FGCOLOR 0 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-prod_nr AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19.6 BY 1 NO-UNDO.

DEFINE VARIABLE FILL-IN-prod_nr_prefix AS CHARACTER FORMAT "X(4)":U 
     LABEL "Produksjonsnr" 
      VIEW-AS TEXT 
     SIZE 6.8 BY .76
     FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE VIS-Kundenavn AS CHARACTER FORMAT "X(256)":U 
     LABEL "Kundenavn" 
      VIEW-AS TEXT 
     SIZE 63 BY .76
     FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE VIS-Tilbudsnr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tilbudsnr" 
      VIEW-AS TEXT 
     SIZE 19.6 BY .76
     FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN-FAKTURA
     FILENAME "BMP\spinn":U
     SIZE 3.6 BY 1.24.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 98 BY 16.1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Ordre-Frame FOR 
      NPSHORD SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Ordre-Frame
     NPSHORD.ordre_dato AT ROW 2 COL 78.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHORD.referanse AT ROW 4.67 COL 28.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 58 BY 1.24
          FONT 2
     NPSHORD.leveringsdato AT ROW 6.38 COL 28.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.8 BY 1.24
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHORD.leveringsmaate AT ROW 6.38 COL 59.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Post","Bil-stykkgods","Bil-spesial u/lift","Bil-spesial m/lift","Bil-spesial u/kran","Bil-spesial m/kran","Buss","Bane","Båt","Fly","Hentes" 
          DROP-DOWN-LIST
          SIZE 33.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPSHORD.lev_adresse_lik_kunde AT ROW 8 COL 30.4
          LABEL "Lik kundeadresse"
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .95
     NPSHORD.lev_adresse_fritekst AT ROW 9.33 COL 30.4 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 200
          SIZE 47.6 BY 4.38
          FONT 2
     FILL-IN-FAKT_ADRESSE AT ROW 14 COL 28.4 COLON-ALIGNED
     FILL-IN-prod_nr AT ROW 15.48 COL 37.4 COLON-ALIGNED NO-LABEL
     Btn_OK AT ROW 17.95 COL 30.4
     Btn_Cancel AT ROW 17.95 COL 47.2
     Btn_Help AT ROW 17.95 COL 64
     VIS-Tilbudsnr AT ROW 2 COL 28.4 COLON-ALIGNED
     VIS-Kundenavn AT ROW 3.29 COL 28.4 COLON-ALIGNED
     FILL-IN-prod_nr_prefix AT ROW 15.67 COL 28.4 COLON-ALIGNED
     COMBO-SPINN-FAKTURA AT ROW 14.1 COL 88.6
     RECT-1 AT ROW 1.38 COL 2.4
     "-" VIEW-AS TEXT
          SIZE 1.6 BY .76 AT ROW 15.62 COL 37.6
     "Leveringsadresse:" VIEW-AS TEXT
          SIZE 17.8 BY .76 AT ROW 8.05 COL 12.6
     SPACE(71.39) SKIP(10.90)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Ny Ordre"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Ordre-Frame
                                                                        */
ASSIGN 
       FRAME Ordre-Frame:SCROLLABLE       = FALSE
       FRAME Ordre-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN FILL-IN-prod_nr_prefix IN FRAME Ordre-Frame
   NO-ENABLE                                                            */
ASSIGN 
       NPSHORD.lev_adresse_fritekst:RETURN-INSERTED IN FRAME Ordre-Frame  = TRUE.

/* SETTINGS FOR TOGGLE-BOX NPSHORD.lev_adresse_lik_kunde IN FRAME Ordre-Frame
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
     _TblList          = "norcalc.NPSHORD"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Ordre-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Ordre-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Ordre-Frame Ordre-Frame
ON WINDOW-CLOSE OF FRAME Ordre-Frame /* Ny Ordre */
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
    IF (NPSHORD.lev_adresse_fritekst:SCREEN-VALUE  = "" AND 
            NPSHORD.lev_adresse_lik_kunde:SCREEN-VALUE = 'FALSE') OR    
        FILL-IN-FAKT_ADRESSE:SCREEN-VALUE = "" THEN    
        DO:
          MESSAGE 'Leverings adresse og Faktura adresse MÅ fylles ut' VIEW-AS ALERT-BOX
            TITLE 'Registreringsfeil'.
            RETURN NO-APPLY.
       END.
    ELSE IF NPSHORD.leveringsdato:SCREEN-VALUE = ? OR 
        FILL-IN-prod_nr:SCREEN-VALUE = "" THEN DO:
          MESSAGE 'Leveringsdato or produksjonsnr MÅ fylles ut' VIEW-AS ALERT-BOX
            TITLE 'Registreringsfeil'.
            RETURN NO-APPLY.
       END.
    ELSE
        DO:
            /* Sett id */
            define var cp_tabell_navn as char.
            define var ip_neste_id as integer.

            cp_tabell_navn  = 'npshord'.
            run neste_id.p (input cp_tabell_navn, output ip_neste_id).
            ASSIGN NPSHORD.ordreid = ip_neste_id.
            /* Set status på oppfølging til 'ORDRE' */
            FIND LAST NPSHTOPP WHERE NPSHTOPP.id = NPSHTILBUD.id EXCLUSIVE-LOCK 
                NO-WAIT NO-ERROR.
            IF AVAILABLE NPSHTOPP THEN
                    ASSIGN NPSHTOPP.oppf_status = 'ORDRE'  
                                     NPSHTOPP.oppf_dato = TODAY.
                    
            ELSE
                    DO:
                        MESSAGE 'Kunne ikke oppdatere Oppfølgingsstatus. Gjør dette manuelt' 
                            VIEW-AS ALERT-BOX TITLE 'Info'.
                    END.
          /* Sett dette anlegget til ikke aktivt  */
          FIND NPSHANLG WHERE NPSHANLG.anleggsnr = NPSHTILBUD.anleggsnr 
            EXCLUSIVE-LOCK NO-ERROR  NO-WAIT.
          IF AVAILABLE NPSHANLG THEN
                ASSIGN aktivt = FALSE.

        /* Set sammen produksjonsordre */
        ASSIGN NPSHORD.prod_nr = TRIM(FILL-IN-prod_nr_prefix:SCREEN-VALUE) + '-' + 
            TRIM(FILL-IN-prod_nr:SCREEN-VALUE).

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
                            NPSHORD.faktura_kundeid = NPKUNDE.kundenr.
                            NPSHORD.fakt_kundenavn = NPKUNDE.kundenavn.
                            NPSHORD.fakt_adresse1 = NPKUNDE.adresse1.
                            NPSHORD.fakt_adresse2 = NPKUNDE.adresse2.
                            NPSHORD.fakt_postnr = NPKUNDE.postnr.
                            NPSHORD.fakt_poststed = NPKUNDE.poststed.
                            NPSHORD.fakt_land = NPKUNDE.land.
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
           NPSHORD.faktura_kundeid = NPKUNDE.kundenr.
           NPSHORD.fakt_kundenavn = NPKUNDE.kundenavn.
           NPSHORD.fakt_adresse1 = NPKUNDE.adresse1.
           NPSHORD.fakt_adresse2 = NPKUNDE.adresse2.
           NPSHORD.fakt_postnr = NPKUNDE.postnr.
           NPSHORD.fakt_poststed = NPKUNDE.poststed.
           NPSHORD.fakt_land = NPKUNDE.land.
           DISPLAY FILL-IN-FAKT_ADRESSE 
                WITH FRAME  {&FRAME-NAME}.
       END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-prod_nr_prefix
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-prod_nr_prefix Ordre-Frame
ON ENTRY OF FILL-IN-prod_nr_prefix IN FRAME Ordre-Frame /* Produksjonsnr */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHORD.leveringsdato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHORD.leveringsdato Ordre-Frame
ON LEAVE OF NPSHORD.leveringsdato IN FRAME Ordre-Frame /* Leveringsdato */
DO:
  IF SELF:SCREEN-VALUE <> ? THEN DO:  
    DEFINE VAR mndNum AS INTEGER.
    mndNum = MONTH(DATE(SELF:SCREEN-VALUE)).
      FILL-IN-prod_nr_prefix = SUBSTRING(STRING(YEAR(DATE(SELF:SCREEN-VALUE))), 3, 2).
      IF mndNum <= 9 THEN 
        FILL-IN-prod_nr_prefix = FILL-IN-prod_nr_prefix + '0' + STRING(mndNum).
       ELSE FILL-IN-prod_nr_prefix = FILL-IN-prod_nr_prefix +  STRING(mndNum).
      DISPLAY FILL-IN-prod_nr_prefix  WITH FRAME {&frame-name}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHORD.lev_adresse_lik_kunde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHORD.lev_adresse_lik_kunde Ordre-Frame
ON VALUE-CHANGED OF NPSHORD.lev_adresse_lik_kunde IN FRAME Ordre-Frame /* Lik kundeadresse */
DO:   
  ASSIGN NPSHORD.lev_adresse_lik_kunde.
  IF NPSHORD.lev_adresse_lik_kunde = TRUE THEN
    HIDE NPSHORD.lev_adresse_fritekst.
  ELSE
    ENABLE NPSHORD.lev_adresse_fritekst WITH FRAME {&FRAME-NAME}.
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
  hParent = source-procedure.
  JBoxRelation:instance:addInvalidate(hParent,this-procedure).
  current-rec = dynamic-function('getCurrentRec' in hParent).
  SESSION:SET-WAIT-STATE("").   
  find first npshtilbud where rowid(npshtilbud) = current-rec no-lock no-error.
  if avail npshtilbud then do:
    find first npkunde where NPKUNDE.kundenr = NPSHTILBUD.kundenr no-lock no-error.
    RUN nyOrdre.
  end.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Ordre-Frame  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Ordre-Frame  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-FAKT_ADRESSE FILL-IN-prod_nr VIS-Tilbudsnr VIS-Kundenavn 
          FILL-IN-prod_nr_prefix 
      WITH FRAME Ordre-Frame.
  IF AVAILABLE NPSHORD THEN 
    DISPLAY NPSHORD.ordre_dato NPSHORD.referanse NPSHORD.leveringsdato 
          NPSHORD.leveringsmaate NPSHORD.lev_adresse_lik_kunde 
          NPSHORD.lev_adresse_fritekst 
      WITH FRAME Ordre-Frame.
  ENABLE NPSHORD.ordre_dato NPSHORD.referanse NPSHORD.leveringsdato 
         NPSHORD.leveringsmaate NPSHORD.lev_adresse_lik_kunde 
         NPSHORD.lev_adresse_fritekst FILL-IN-FAKT_ADRESSE FILL-IN-prod_nr 
         Btn_OK Btn_Cancel Btn_Help COMBO-SPINN-FAKTURA RECT-1 
      WITH FRAME Ordre-Frame.
  VIEW FRAME Ordre-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Ordre-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyOrdre Ordre-Frame 
PROCEDURE nyOrdre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR cAnleggsnr AS CHAR.
/* Først må neste id settes */
      iNextId = 0.
     create npshord.
     NPSHORD.ordre_dato = TODAY.
     NPSHORD.ordreid = iNextId.
     NPSHORD.tilbudsid = npshtilbud.id.
     NPSHORD.anleggsnr = NPSHTILBUD.anleggsnr.
     VIS-Kundenavn = NPKUNDE.kundenavn.
     VIS-Tilbudsnr = NPSHTILBUD.tilbudsnr.

DISPLAY VIS-Tilbudsnr VIS-Kundenavn 
     WITH FRAME Ordre-Frame.

 UPDATE 
   NPSHORD.ordre_dato NPSHORD.referanse NPSHORD.leveringsdato
   NPSHORD.leveringsmaate NPSHORD.lev_adresse_lik_kunde 
   NPSHORD.lev_adresse_fritekst 
   FILL-IN-FAKT_ADRESSE COMBO-SPINN-FAKTURA
   FILL-IN-prod_nr
   Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Ordre-Frame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

