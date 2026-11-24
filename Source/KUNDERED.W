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
DEFINE SHARED VAR Current-Kunde-Rec AS ROWID.
DEFINE SHARED VAR nyRecord AS LOGICAL.

/* Local Variable Definitions ---                                       */
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR cKnavn LIKE NPKUNDE.kundenavn.
DEFINE VAR cKnr LIKE NPKUNDE.kundenr.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKUNDE

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NPKUNDE.kundenavn ~
NPKUNDE.kundenr NPKUNDE.kundekategori NPKUNDE.adresse1 NPKUNDE.adresse2 ~
NPKUNDE.avtale NPKUNDE.sist_oppdatert NPKUNDE.avdeling NPKUNDE.postnr ~
NPKUNDE.poststed NPKUNDE.land NPKUNDE.kundedistriktNr NPKUNDE.telefon ~
NPKUNDE.fax NPKUNDE.dm_kode NPKUNDE.kontor_type NPKUNDE.aktiv ~
NPKUNDE.er_konsulent NPKUNDE.tilbudsmottager NPKUNDE.katalog_np_dato ~
NPKUNDE.katalog_np_antall NPKUNDE.katalog_np_type NPKUNDE.kontaktperson_np ~
NPKUNDE.katalog_np_oppdatert NPKUNDE.katalog_nt_type ~
NPKUNDE.katalog_nt_dato NPKUNDE.katalog_nt_antall ~
NPKUNDE.katalog_nt_oppdatert NPKUNDE.kontaktperson_nt NPKUNDE.organisasjon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame NPKUNDE.kundenavn ~
NPKUNDE.kundenr NPKUNDE.kundekategori NPKUNDE.adresse1 NPKUNDE.adresse2 ~
NPKUNDE.avtale NPKUNDE.sist_oppdatert NPKUNDE.avdeling NPKUNDE.postnr ~
NPKUNDE.poststed NPKUNDE.land NPKUNDE.kundedistriktNr NPKUNDE.telefon ~
NPKUNDE.fax NPKUNDE.dm_kode NPKUNDE.kontor_type NPKUNDE.aktiv ~
NPKUNDE.er_konsulent NPKUNDE.tilbudsmottager NPKUNDE.katalog_np_dato ~
NPKUNDE.katalog_np_antall NPKUNDE.katalog_np_type NPKUNDE.kontaktperson_np ~
NPKUNDE.katalog_np_oppdatert NPKUNDE.katalog_nt_type ~
NPKUNDE.katalog_nt_dato NPKUNDE.katalog_nt_antall ~
NPKUNDE.katalog_nt_oppdatert NPKUNDE.kontaktperson_nt NPKUNDE.organisasjon 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NPKUNDE
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NPKUNDE
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH NPKUNDE SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPKUNDE SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPKUNDE


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPKUNDE.kundenavn NPKUNDE.kundenr ~
NPKUNDE.kundekategori NPKUNDE.adresse1 NPKUNDE.adresse2 NPKUNDE.avtale ~
NPKUNDE.sist_oppdatert NPKUNDE.avdeling NPKUNDE.postnr NPKUNDE.poststed ~
NPKUNDE.land NPKUNDE.kundedistriktNr NPKUNDE.telefon NPKUNDE.fax ~
NPKUNDE.dm_kode NPKUNDE.kontor_type NPKUNDE.aktiv NPKUNDE.er_konsulent ~
NPKUNDE.tilbudsmottager NPKUNDE.katalog_np_dato NPKUNDE.katalog_np_antall ~
NPKUNDE.katalog_np_type NPKUNDE.kontaktperson_np ~
NPKUNDE.katalog_np_oppdatert NPKUNDE.katalog_nt_type ~
NPKUNDE.katalog_nt_dato NPKUNDE.katalog_nt_antall ~
NPKUNDE.katalog_nt_oppdatert NPKUNDE.kontaktperson_nt NPKUNDE.organisasjon 
&Scoped-define ENABLED-TABLES NPKUNDE
&Scoped-define FIRST-ENABLED-TABLE NPKUNDE
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Help RECT-1 RECT-2 ~
RECT-3 
&Scoped-Define DISPLAYED-FIELDS NPKUNDE.kundenavn NPKUNDE.kundenr ~
NPKUNDE.kundekategori NPKUNDE.adresse1 NPKUNDE.adresse2 NPKUNDE.avtale ~
NPKUNDE.sist_oppdatert NPKUNDE.avdeling NPKUNDE.postnr NPKUNDE.poststed ~
NPKUNDE.land NPKUNDE.kundedistriktNr NPKUNDE.telefon NPKUNDE.fax ~
NPKUNDE.dm_kode NPKUNDE.kontor_type NPKUNDE.aktiv NPKUNDE.er_konsulent ~
NPKUNDE.tilbudsmottager NPKUNDE.katalog_np_dato NPKUNDE.katalog_np_antall ~
NPKUNDE.katalog_np_type NPKUNDE.kontaktperson_np ~
NPKUNDE.katalog_np_oppdatert NPKUNDE.katalog_nt_type ~
NPKUNDE.katalog_nt_dato NPKUNDE.katalog_nt_antall ~
NPKUNDE.katalog_nt_oppdatert NPKUNDE.kontaktperson_nt NPKUNDE.organisasjon 
&Scoped-define DISPLAYED-TABLES NPKUNDE
&Scoped-define FIRST-DISPLAYED-TABLE NPKUNDE


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10 BY .95
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 8 BY .95
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY .95
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124 BY 10.52.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124 BY 2.71.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124 BY 3.67.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     NPKUNDE.kundenavn AT ROW 2.14 COL 16.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 43.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.kundenr AT ROW 1.95 COL 110 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 12.4 BY 1
          BGCOLOR 15 FGCOLOR 12 FONT 2
     NPKUNDE.kundekategori AT ROW 2.14 COL 73.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "dummy"," "
          DROP-DOWN-LIST
          SIZE 22.8 BY 1.05
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.adresse1 AT ROW 3.24 COL 16.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 43.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.adresse2 AT ROW 4.43 COL 16.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 43.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.avtale AT ROW 3.24 COL 73.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "NRE","Egen","Ingen" 
          DROP-DOWN-LIST
          SIZE 17.8 BY 1
     NPKUNDE.sist_oppdatert AT ROW 3.14 COL 108 COLON-ALIGNED
          LABEL "Sist oppd."
          VIEW-AS FILL-IN NATIVE 
          SIZE 14.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.avdeling AT ROW 4.43 COL 73.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 31.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.postnr AT ROW 5.57 COL 16.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 12.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.poststed AT ROW 5.57 COL 73.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 23.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.land AT ROW 6.67 COL 16.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 21.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.kundedistriktNr AT ROW 6.67 COL 73.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "",0
          DROP-DOWN-LIST
          SIZE 34.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.telefon AT ROW 7.91 COL 16.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21 BY 1
     NPKUNDE.fax AT ROW 7.91 COL 73.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.4 BY 1
     NPKUNDE.dm_kode AT ROW 10.52 COL 91 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "1 Personlig","2 Meget god","3 God","4 Bearbeides","5 Når de må","6 Negativ" 
          DROP-DOWN-LIST
          SIZE 30.2 BY 1
     NPKUNDE.kontor_type AT ROW 9.19 COL 18.8 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Hovedkontor", "Hovedkontor":U,
"Avdelingskontor", "Avdelingskontor":U,
"Hentelager", "Hentelager":U
          SIZE 66 BY .76
     NPKUNDE.aktiv AT ROW 10.33 COL 18.8
          VIEW-AS TOGGLE-BOX
          SIZE 10.2 BY .76
     NPKUNDE.er_konsulent AT ROW 10.33 COL 30.4
          VIEW-AS TOGGLE-BOX
          SIZE 16.4 BY .76
     NPKUNDE.tilbudsmottager AT ROW 10.33 COL 47.6
          VIEW-AS TOGGLE-BOX
          SIZE 12.2 BY .76
     NPKUNDE.katalog_np_dato AT ROW 12.62 COL 17 COLON-ALIGNED
          LABEL "NP"
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Dialog-Frame
     NPKUNDE.katalog_np_antall AT ROW 12.62 COL 39 COLON-ALIGNED
          LABEL "Ant."
          VIEW-AS FILL-IN NATIVE 
          SIZE 3.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.katalog_np_type AT ROW 12.62 COL 51.6 COLON-ALIGNED
          LABEL "Type"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "R ","RS","RV","RVS" 
          DROP-DOWN-LIST
          SIZE 10.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.kontaktperson_np AT ROW 12.62 COL 93.8 COLON-ALIGNED
          LABEL "Kont."
          VIEW-AS FILL-IN NATIVE 
          SIZE 26.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.katalog_np_oppdatert AT ROW 12.71 COL 72.4 COLON-ALIGNED
          LABEL "Oppd."
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.katalog_nt_type AT ROW 13.76 COL 51.6 COLON-ALIGNED
          LABEL "Type"
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "R ","RS","RV","RVS" 
          DROP-DOWN-LIST
          SIZE 10.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.katalog_nt_dato AT ROW 13.91 COL 17 COLON-ALIGNED
          LABEL "NT"
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.katalog_nt_antall AT ROW 13.91 COL 39 COLON-ALIGNED
          LABEL "Ant."
          VIEW-AS FILL-IN NATIVE 
          SIZE 3.8 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.katalog_nt_oppdatert AT ROW 13.91 COL 72.4 COLON-ALIGNED
          LABEL "Oppd."
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NPKUNDE.kontaktperson_nt AT ROW 13.91 COL 93.8 COLON-ALIGNED
          LABEL "Kont."
          VIEW-AS FILL-IN 
          SIZE 26.4 BY 1
     NPKUNDE.organisasjon AT ROW 16.14 COL 19.2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
          SIZE 103.2 BY 2.91
          BGCOLOR 15 FGCOLOR 0 FONT 2
     Btn_OK AT ROW 19.71 COL 53.4
     Btn_Cancel AT ROW 19.71 COL 64
     Btn_Help AT ROW 19.71 COL 76
     " Generelt" VIEW-AS TEXT
          SIZE 12.4 BY .62 AT ROW 1.14 COL 4.8
     "Kataloger etc." VIEW-AS TEXT
          SIZE 12.4 BY .62 AT ROW 12.1 COL 5
     " Organisasjon" VIEW-AS TEXT
          SIZE 17.6 BY .62 AT ROW 15.38 COL 4.6
     RECT-1 AT ROW 1.52 COL 1.8
     RECT-2 AT ROW 12.38 COL 1.8
     RECT-3 AT ROW 15.62 COL 1.8
     SPACE(0.79) SKIP(1.80)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Kunderegister"
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE
       FRAME Dialog-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR FILL-IN NPKUNDE.katalog_np_antall IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.katalog_np_dato IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.katalog_np_oppdatert IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPKUNDE.katalog_np_type IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.katalog_nt_antall IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.katalog_nt_dato IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.katalog_nt_oppdatert IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPKUNDE.katalog_nt_type IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.kontaktperson_np IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.kontaktperson_nt IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPKUNDE.sist_oppdatert IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NPKUNDE"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Kunderegister */
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
    /* kundenr og kundenavn må fylles ut */
    cKnavn = NPKUNDE.kundenavn:SCREEN-VALUE.
    cKnr = NPKUNDE.kundenr:SCREEN-VALUE.
    IF cKnavn = "" OR cKnr = "" THEN
        DO:
            MESSAGE 'Kundenr og Kundenavn Må fylles ut!' VIEW-AS ALERT-BOX.
            RETURN NO-APPLY.
       END.
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
  assign 
    kundedistriktnr:DELIMITER = '|' 
    kundedistriktnr:LIST-ITEM-PAIRS = '|0|' + JBoxServerAPI:Instance:FieldList('NPKundedistrikt;KundeDistriktNr|KundeDistriktNavn;kundedistriktnr','where true')
    kundekategori:DELIMITER = '|' 
    kundekategori:LIST-ITEM-PAIRS = '||' + JBoxServerAPI:Instance:FieldList('NPKundekategori;KundeKategoriID|KundeKategoriBeskrivelse;kundekategoriID','where true')
    .
  
    IF nyRecord THEN
        RUN nyKunde.
    ELSE
        RUN endreKunde.

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
  IF AVAILABLE NPKUNDE THEN 
    DISPLAY NPKUNDE.kundenavn NPKUNDE.kundenr NPKUNDE.kundekategori 
          NPKUNDE.adresse1 NPKUNDE.adresse2 NPKUNDE.avtale 
          NPKUNDE.sist_oppdatert NPKUNDE.avdeling NPKUNDE.postnr 
          NPKUNDE.poststed NPKUNDE.land NPKUNDE.kundedistriktNr NPKUNDE.telefon 
          NPKUNDE.fax NPKUNDE.dm_kode NPKUNDE.kontor_type NPKUNDE.aktiv 
          NPKUNDE.er_konsulent NPKUNDE.tilbudsmottager NPKUNDE.katalog_np_dato 
          NPKUNDE.katalog_np_antall NPKUNDE.katalog_np_type 
          NPKUNDE.kontaktperson_np NPKUNDE.katalog_np_oppdatert 
          NPKUNDE.katalog_nt_type NPKUNDE.katalog_nt_dato 
          NPKUNDE.katalog_nt_antall NPKUNDE.katalog_nt_oppdatert 
          NPKUNDE.kontaktperson_nt NPKUNDE.organisasjon 
      WITH FRAME Dialog-Frame.
  ENABLE NPKUNDE.kundenavn NPKUNDE.kundenr NPKUNDE.kundekategori 
         NPKUNDE.adresse1 NPKUNDE.adresse2 NPKUNDE.avtale 
         NPKUNDE.sist_oppdatert NPKUNDE.avdeling NPKUNDE.postnr 
         NPKUNDE.poststed NPKUNDE.land NPKUNDE.kundedistriktNr NPKUNDE.telefon 
         NPKUNDE.fax NPKUNDE.dm_kode NPKUNDE.kontor_type NPKUNDE.aktiv 
         NPKUNDE.er_konsulent NPKUNDE.tilbudsmottager NPKUNDE.katalog_np_dato 
         NPKUNDE.katalog_np_antall NPKUNDE.katalog_np_type 
         NPKUNDE.kontaktperson_np NPKUNDE.katalog_np_oppdatert 
         NPKUNDE.katalog_nt_type NPKUNDE.katalog_nt_dato 
         NPKUNDE.katalog_nt_antall NPKUNDE.katalog_nt_oppdatert 
         NPKUNDE.kontaktperson_nt NPKUNDE.organisasjon Btn_OK Btn_Cancel 
         Btn_Help RECT-1 RECT-2 RECT-3 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreKunde Dialog-Frame 
PROCEDURE endreKunde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPKUNDE WHERE ROWID(NPKUNDE) = Current-Kunde-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NPKUNDE THEN
    DO:
        NPKUNDE.sist_oppdatert = TODAY.
        DISPLAY NPKUNDE.sist_oppdatert  WITH FRAME {&FRAME-NAME}. 
 UPDATE   NPKUNDE.kundenavn NPKUNDE.kundekategori NPKUNDE.kundenr
         NPKUNDE.adresse1  NPKUNDE.avtale NPKUNDE.sist_oppdatert 
         NPKUNDE.adresse2 NPKUNDE.avdeling
         NPKUNDE.postnr NPKUNDE.poststed
         NPKUNDE.land NPKUNDE.Kundedistriktnr NPKUNDE.telefon NPKUNDE.fax  NPKUNDE.dm_kode
         NPKUNDE.kontor_type NPKUNDE.aktiv NPKUNDE.er_konsulent   NPKUNDE.tilbudsmottager 
         NPKUNDE.katalog_np_dato NPKUNDE.katalog_np_antall 
         NPKUNDE.katalog_np_type NPKUNDE.katalog_np_oppdatert NPKUNDE.kontaktperson_np 
         NPKUNDE.katalog_nt_dato NPKUNDE.katalog_nt_antall 
         NPKUNDE.katalog_nt_type NPKUNDE.katalog_nt_oppdatert  NPKUNDE.kontaktperson_nt
         NPKUNDE.organisasjon 
         
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyKunde Dialog-Frame 
PROCEDURE nyKunde :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  do transaction:
    CREATE NPKUNDE.
    Current-Kunde-Rec = ROWID(NPKUNDE).
    NPKUNDE.aktiv = YES.
    NPKUNDE.sist_oppdatert  = TODAY.
    DISPLAY NPKUNDE.aktiv NPKUNDE.sist_oppdatert WITH FRAME Dialog-Frame.
     UPDATE   NPKUNDE.kundenavn NPKUNDE.kundekategori NPKUNDE.kundenr 
             NPKUNDE.adresse1  NPKUNDE.avtale NPKUNDE.sist_oppdatert
             NPKUNDE.adresse2 NPKUNDE.avdeling
             NPKUNDE.postnr NPKUNDE.poststed
             NPKUNDE.land NPKUNDE.kundedistriktnr NPKUNDE.telefon NPKUNDE.fax   NPKUNDE.dm_kode
             NPKUNDE.kontor_type NPKUNDE.aktiv  NPKUNDE.er_konsulent   NPKUNDE.tilbudsmottager 
             NPKUNDE.katalog_np_dato NPKUNDE.katalog_np_antall 
             NPKUNDE.katalog_np_type NPKUNDE.katalog_np_oppdatert NPKUNDE.kontaktperson_np 
             NPKUNDE.katalog_nt_dato NPKUNDE.katalog_nt_antall 
             NPKUNDE.katalog_nt_type NPKUNDE.katalog_nt_oppdatert  NPKUNDE.kontaktperson_nt
             NPKUNDE.organisasjon 
             
             Btn_OK Btn_Cancel Btn_Help 
          WITH FRAME Dialog-Frame.
  end.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

