&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
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
DEFINE SHARED VAR Current-Oppf-Rec AS ROWID.
DEFINE SHARED VAR nyRecord AS LOGICAL.
DEFINE SHARED VAR kundenrParam LIKE NPKUNDE.kundenr.
DEFINE SHARED VAR oppfidParam LIKE NPKUNDEOPPF.oppf_id.
/* Local Variable Definitions ---                                       */
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR kundeoppfId AS INTEGER.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKUNDEOPPF

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NPKUNDEOPPF.kontakt_dato ~
NPKUNDEOPPF.kontaktet_av NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.oppf_ok ~
NPKUNDEOPPF.rapport NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet ~
NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.mini_brev NPKUNDEOPPF.deres_ref ~
NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.til_godkjennelse NPKUNDEOPPF.nor_firma ~
NPKUNDEOPPF.bes_returnert NPKUNDEOPPF.takk_for_laanet NPKUNDEOPPF.vedlegg ~
NPKUNDEOPPF.haster NPKUNDEOPPF.til_orientering NPKUNDEOPPF.vennligst_ring ~
NPKUNDEOPPF.svar_imotesees 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
NPKUNDEOPPF.kontakt_dato NPKUNDEOPPF.kontaktet_av NPKUNDEOPPF.kontaktet_pr ~
NPKUNDEOPPF.oppf_ok NPKUNDEOPPF.rapport NPKUNDEOPPF.neste_kontakt_av ~
NPKUNDEOPPF.aktivitet NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.mini_brev ~
NPKUNDEOPPF.deres_ref NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.til_godkjennelse ~
NPKUNDEOPPF.nor_firma NPKUNDEOPPF.bes_returnert NPKUNDEOPPF.takk_for_laanet ~
NPKUNDEOPPF.vedlegg NPKUNDEOPPF.haster NPKUNDEOPPF.til_orientering ~
NPKUNDEOPPF.vennligst_ring NPKUNDEOPPF.svar_imotesees 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NPKUNDEOPPF
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NPKUNDEOPPF
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH NPKUNDEOPPF SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPKUNDEOPPF SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPKUNDEOPPF
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPKUNDEOPPF


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPKUNDEOPPF.kontakt_dato ~
NPKUNDEOPPF.kontaktet_av NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.oppf_ok ~
NPKUNDEOPPF.rapport NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet ~
NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.mini_brev NPKUNDEOPPF.deres_ref ~
NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.til_godkjennelse NPKUNDEOPPF.nor_firma ~
NPKUNDEOPPF.bes_returnert NPKUNDEOPPF.takk_for_laanet NPKUNDEOPPF.vedlegg ~
NPKUNDEOPPF.haster NPKUNDEOPPF.til_orientering NPKUNDEOPPF.vennligst_ring ~
NPKUNDEOPPF.svar_imotesees 
&Scoped-define ENABLED-TABLES NPKUNDEOPPF
&Scoped-define FIRST-ENABLED-TABLE NPKUNDEOPPF
&Scoped-Define ENABLED-OBJECTS RECT-31 RECT-32 Btn_OK Btn_Cancel Btn_Help ~
BUTTON-hilsen 
&Scoped-Define DISPLAYED-FIELDS NPKUNDEOPPF.kontakt_dato ~
NPKUNDEOPPF.kontaktet_av NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.oppf_ok ~
NPKUNDEOPPF.rapport NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet ~
NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.mini_brev NPKUNDEOPPF.deres_ref ~
NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.til_godkjennelse NPKUNDEOPPF.nor_firma ~
NPKUNDEOPPF.bes_returnert NPKUNDEOPPF.takk_for_laanet NPKUNDEOPPF.vedlegg ~
NPKUNDEOPPF.haster NPKUNDEOPPF.til_orientering NPKUNDEOPPF.vennligst_ring ~
NPKUNDEOPPF.svar_imotesees 
&Scoped-define DISPLAYED-TABLES NPKUNDEOPPF
&Scoped-define FIRST-DISPLAYED-TABLE NPKUNDEOPPF


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10.6 BY .95
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 8 BY .95
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY .95
     BGCOLOR 8 .

DEFINE BUTTON BUTTON-hilsen 
     LABEL "&Hilsen" 
     SIZE 10.8 BY .95.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124.6 BY 6.33.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124 BY 12.19.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPKUNDEOPPF SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     NPKUNDEOPPF.kontakt_dato AT ROW 1.76 COL 17.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDEOPPF.kontaktet_av AT ROW 1.76 COL 51.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          DROP-DOWN-LIST
          SIZE 30.8 BY 1.05
     NPKUNDEOPPF.kontaktet_pr AT ROW 1.76 COL 89 COLON-ALIGNED
          LABEL "Pr."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Tlf.","Besøk","Fax","Brev","Annet" 
          DROP-DOWN-LIST
          SIZE 14.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDEOPPF.oppf_ok AT ROW 2.05 COL 109.4
          VIEW-AS TOGGLE-BOX
          SIZE 9 BY .76
          FGCOLOR 12 
     NPKUNDEOPPF.rapport AT ROW 3.43 COL 4.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 119.2 BY 2.71
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDEOPPF.neste_kontakt_av AT ROW 6.38 COL 42.6 COLON-ALIGNED
          LABEL "v/"
          VIEW-AS COMBO-BOX 
          DROP-DOWN-LIST
          SIZE 29.2 BY 1
     NPKUNDEOPPF.aktivitet AT ROW 6.43 COL 93.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Besøkes","Kontaktes","Pleies" 
          DROP-DOWN-LIST
          SIZE 20.4 BY 1
     NPKUNDEOPPF.neste_kontakt AT ROW 6.52 COL 20.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 16.6 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDEOPPF.mini_brev AT ROW 9.52 COL 2.6 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 1800 SCROLLBAR-VERTICAL
          SIZE 121.4 BY 5.86
     NPKUNDEOPPF.deres_ref AT ROW 16.24 COL 38 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.8 BY 1
     NPKUNDEOPPF.iflg_avtale AT ROW 16.24 COL 74
          VIEW-AS TOGGLE-BOX
          SIZE 18.8 BY .76
     NPKUNDEOPPF.til_godkjennelse AT ROW 16.24 COL 95
          LABEL "Til godkjennelse"
          VIEW-AS TOGGLE-BOX
          SIZE 24.4 BY .76
     NPKUNDEOPPF.nor_firma AT ROW 16.48 COL 7 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "NP", "NP":U,
"NT", "NT":U,
"NS", "NS":U
          SIZE 10 BY 2.62 TOOLTIP "Underskriftslternativ"
     NPKUNDEOPPF.bes_returnert AT ROW 17.14 COL 74
          LABEL "Bes returnert"
          VIEW-AS TOGGLE-BOX
          SIZE 19.2 BY .76
     NPKUNDEOPPF.takk_for_laanet AT ROW 17.14 COL 95
          LABEL "Takk for lånet"
          VIEW-AS TOGGLE-BOX
          SIZE 20.6 BY .76
     NPKUNDEOPPF.vedlegg AT ROW 17.67 COL 33 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 90 SCROLLBAR-VERTICAL
          SIZE 33.8 BY 1.67
     NPKUNDEOPPF.haster AT ROW 18 COL 74
          LABEL "HASTER"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .76
     NPKUNDEOPPF.til_orientering AT ROW 18 COL 95
          LABEL "Til orientering"
          VIEW-AS TOGGLE-BOX
          SIZE 19.8 BY .76
     NPKUNDEOPPF.vennligst_ring AT ROW 18.86 COL 74.2
          LABEL "Vennligst ring"
          VIEW-AS TOGGLE-BOX
          SIZE 20.4 BY .76
     NPKUNDEOPPF.svar_imotesees AT ROW 18.86 COL 95.2
          LABEL "Svar imøtesees"
          VIEW-AS TOGGLE-BOX
          SIZE 22.6 BY .76
     Btn_OK AT ROW 21 COL 44
     Btn_Cancel AT ROW 21 COL 52.4
     Btn_Help AT ROW 21 COL 63.4
     BUTTON-hilsen AT ROW 21 COL 73
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         CANCEL-BUTTON Btn_Cancel.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     "Oppfølging" VIEW-AS TEXT
          SIZE 14.2 BY .95 AT ROW 1.1 COL 3.8
     "Minibrev" VIEW-AS TEXT
          SIZE 11.6 BY .62 AT ROW 7.91 COL 3
     "Vedlegg:" VIEW-AS TEXT
          SIZE 11.6 BY 1.1 AT ROW 17.43 COL 21
     "Tekst:" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 8.81 COL 2.6
     "Rapport:" VIEW-AS TEXT
          SIZE 11.8 BY .62 AT ROW 2.76 COL 4.8
     RECT-31 AT ROW 1.48 COL 1.4
     RECT-32 AT ROW 8.1 COL 1.4
     SPACE(1.19) SKIP(2.89)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Kundeoppfølging"
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX NPKUNDEOPPF.bes_returnert IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPKUNDEOPPF.haster IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPKUNDEOPPF.kontaktet_pr IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPKUNDEOPPF.neste_kontakt_av IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPKUNDEOPPF.svar_imotesees IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPKUNDEOPPF.takk_for_laanet IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPKUNDEOPPF.til_godkjennelse IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPKUNDEOPPF.til_orientering IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX NPKUNDEOPPF.vennligst_ring IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NPKUNDEOPPF"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Kundeoppfølging */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    IF NPKUNDEOPPF.kontaktet_av:SCREEN-VALUE = ? THEN
        DO:
            MESSAGE 'Vår kontakt MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
      Current-Oppf-Rec = ROWID(NPKUNDEOPPF).
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BUTTON-hilsen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-hilsen Dialog-Frame
ON CHOOSE OF BUTTON-hilsen IN FRAME Dialog-Frame /* Hilsen */
DO:
    /* Set avslutningshilsen */  
    DEFINE VAR hilsen LIKE NPKUNDEOPPF.mini_brev.
    
    IF NPKUNDEOPPF.kontaktet_av:SCREEN-VALUE = ""  OR
        NPKUNDEOPPF.kontaktet_av:SCREEN-VALUE = ?THEN
        DO:
            MESSAGE "Du må velge 'Vår Kontakt' før hilsen kan settes på brevet" 
                VIEW-AS ALERT-BOX TITLE 'Registreringsfeil'.
             RETURN NO-APPLY.
        END.

    hilsen = NPKUNDEOPPF.mini_brev:SCREEN-VALUE +  CHR(13) 
        + 'Med vennlig hilsen'.
    CASE NPKUNDEOPPF.nor_firma:SCREEN-VALUE:
        WHEN 'NP' THEN
          hilsen = hilsen + CHR(13) +  'Nor - Produkter as' + CHR(10) + CHR(13)
          + CHR(10) + CHR(13) +  NPKUNDEOPPF.kontaktet_av:SCREEN-VALUE.
        WHEN  'NT' THEN
            hilsen = hilsen +  CHR(13) +  'Nor - Term as' + CHR(10) + CHR(13) 
          + CHR(10) + CHR(13) +  NPKUNDEOPPF.kontaktet_av:SCREEN-VALUE.
        WHEN 'NS' THEN
          hilsen = hilsen +  CHR(13) +  'Nor - Shunt as' + CHR(10) + CHR(13) 
          + CHR(10) + CHR(13) +  NPKUNDEOPPF.kontaktet_av:SCREEN-VALUE.
    END.
    ASSIGN NPKUNDEOPPF.mini_brev = hilsen.
    DISPLAY NPKUNDEOPPF.mini_brev WITH FRAME {&FRAME-NAME}.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPKUNDEOPPF.kontaktet_av
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPKUNDEOPPF.kontaktet_av Dialog-Frame
ON ANY-PRINTABLE OF NPKUNDEOPPF.kontaktet_av IN FRAME Dialog-Frame /* Vår kontakt */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPKUNDEOPPF.kontaktet_av Dialog-Frame
ON CURSOR-DOWN OF NPKUNDEOPPF.kontaktet_av IN FRAME Dialog-Frame /* Vår kontakt */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPKUNDEOPPF.kontaktet_av Dialog-Frame
ON CURSOR-UP OF NPKUNDEOPPF.kontaktet_av IN FRAME Dialog-Frame /* Vår kontakt */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPKUNDEOPPF.neste_kontakt_av
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPKUNDEOPPF.neste_kontakt_av Dialog-Frame
ON ANY-PRINTABLE OF NPKUNDEOPPF.neste_kontakt_av IN FRAME Dialog-Frame /* v/ */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPKUNDEOPPF.neste_kontakt_av Dialog-Frame
ON CURSOR-DOWN OF NPKUNDEOPPF.neste_kontakt_av IN FRAME Dialog-Frame /* v/ */
DO:
i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPKUNDEOPPF.neste_kontakt_av Dialog-Frame
ON CURSOR-UP OF NPKUNDEOPPF.neste_kontakt_av IN FRAME Dialog-Frame /* v/ */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


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
   RUN fyll_combo.
  IF nyRecord THEN
      RUN nyKundeOppf.
  ELSE
      RUN endreKundeOppf.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  IF AVAILABLE NPKUNDEOPPF THEN 
    DISPLAY NPKUNDEOPPF.kontakt_dato NPKUNDEOPPF.kontaktet_av 
          NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.oppf_ok NPKUNDEOPPF.rapport 
          NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet 
          NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.mini_brev NPKUNDEOPPF.deres_ref 
          NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.til_godkjennelse 
          NPKUNDEOPPF.nor_firma NPKUNDEOPPF.bes_returnert 
          NPKUNDEOPPF.takk_for_laanet NPKUNDEOPPF.vedlegg NPKUNDEOPPF.haster 
          NPKUNDEOPPF.til_orientering NPKUNDEOPPF.vennligst_ring 
          NPKUNDEOPPF.svar_imotesees 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-31 RECT-32 NPKUNDEOPPF.kontakt_dato NPKUNDEOPPF.kontaktet_av 
         NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.oppf_ok NPKUNDEOPPF.rapport 
         NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet 
         NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.mini_brev NPKUNDEOPPF.deres_ref 
         NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.til_godkjennelse 
         NPKUNDEOPPF.nor_firma NPKUNDEOPPF.bes_returnert 
         NPKUNDEOPPF.takk_for_laanet NPKUNDEOPPF.vedlegg NPKUNDEOPPF.haster 
         NPKUNDEOPPF.til_orientering NPKUNDEOPPF.vennligst_ring 
         NPKUNDEOPPF.svar_imotesees Btn_OK Btn_Cancel Btn_Help BUTTON-hilsen 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreKundeOppf Dialog-Frame 
PROCEDURE endreKundeOppf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPKUNDEOPPF  WHERE ROWID(NPKUNDEOPPF) = Current-Oppf-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NPKUNDEOPPF THEN
  UPDATE  NPKUNDEOPPF.kontakt_dato NPKUNDEOPPF.kontaktet_av
    NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.oppf_ok NPKUNDEOPPF.rapport 
         NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet 
         NPKUNDEOPPF.mini_brev  NPKUNDEOPPF.nor_firma  
         NPKUNDEOPPF.deres_ref 
         NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.bes_returnert 
         NPKUNDEOPPF.til_godkjennelse NPKUNDEOPPF.takk_for_laanet 
         NPKUNDEOPPF.svar_imotesees NPKUNDEOPPF.vennligst_ring 
         NPKUNDEOPPF.til_orientering NPKUNDEOPPF.haster 
         NPKUNDEOPPF.vedlegg 
          Btn_OK Btn_Cancel Btn_Help BUTTON-hilsen
      WITH FRAME Dialog-Frame.
 END. /* TRANSACTION */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_combo Dialog-Frame 
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

    ASSIGN NPKUNDEOPPF.kontaktet_av:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.
    ASSIGN NPKUNDEOPPF.neste_kontakt_av:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyKundeOppf Dialog-Frame 
PROCEDURE nyKundeOppf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND LAST NPKUNDEOPPF WHERE NPKUNDEOPPF.kundenr = kundenrParam NO-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE(NPKUNDEOPPF) THEN
      /* Det er opprettet oppfølging for denne kunden tidligere */
          kundeoppfId = NPKUNDEOPPF.oppf_id  + 1.
  ELSE
    DO:
      IF LOCKED NPKUNDEOPPF THEN
         DO:
            /* Andre registrerer oppfølging på denne kunden nå */
             MESSAGE 'Andre registrerer oppfølging på denne kunden nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
                 TITLE 'STOPP'.
            RETURN.
         END.
    ELSE            
      kundeoppfId = 1.  
    END.
  CREATE NPKUNDEOPPF.
  NPKUNDEOPPF.kundenr  = kundenrParam.
  NPKUNDEOPPF.oppf_id = kundeoppfId.
  NPKUNDEOPPF.kontakt_dato = TODAY.
  DISPLAY NPKUNDEOPPF.kontakt_dato  WITH FRAME {&FRAME-NAME}.

  UPDATE  NPKUNDEOPPF.kontakt_dato NPKUNDEOPPF.kontaktet_av 
    NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.oppf_ok NPKUNDEOPPF.rapport 
         NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet 
         NPKUNDEOPPF.mini_brev  NPKUNDEOPPF.nor_firma  
         NPKUNDEOPPF.deres_ref 
         NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.bes_returnert 
         NPKUNDEOPPF.til_godkjennelse NPKUNDEOPPF.takk_for_laanet 
         NPKUNDEOPPF.svar_imotesees NPKUNDEOPPF.vennligst_ring 
         NPKUNDEOPPF.til_orientering NPKUNDEOPPF.haster 
         NPKUNDEOPPF.vedlegg 
         Btn_OK Btn_Cancel Btn_Help BUTTON-hilsen
      WITH FRAME Dialog-Frame.
 END. /* TRANSACTION */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

