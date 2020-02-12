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

def var current-rec as rowid.
def var nyRecord as log.
def var prosjektidparam like norprosjekt.prosjektid.
def var prosjektNavnParam like norprosjekt.prosjekt_navn.
def var hParent as handle no-undo.

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
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DLGOKCAN

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHANLG.dato NPSHANLG.aktivt ~
NPSHANLG.endrings_laas NPSHANLG.anlegg NPSHANLG.konsulentens_saksbeh ~
NPSHANLG.kundedistriktNr NPSHANLG.saksbehandler NPSHANLG.selger ~
NPSHANLG.entreprise NPSHANLG.beskrevet NPSHANLG.anbudsfrist ~
NPSHANLG.byggestart NPSHANLG.oppf_uke NPSHANLG.oppf_aar ~
NPSHANLG.leveringstid NPSHANLG.opplysninger 
&Scoped-define ENABLED-TABLES NPSHANLG
&Scoped-define FIRST-ENABLED-TABLE NPSHANLG
&Scoped-Define ENABLED-OBJECTS COMBO-SPINN RECT-30 Konsulent Btn_OK ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSHANLG.dato NPSHANLG.aktivt ~
NPSHANLG.endrings_laas NPSHANLG.konsulentens_saksbeh ~
NPSHANLG.kundedistriktNr NPSHANLG.saksbehandler NPSHANLG.selger ~
NPSHANLG.anbudsfrist NPSHANLG.byggestart NPSHANLG.oppf_aar ~
NPSHANLG.opplysninger 
&Scoped-define DISPLAYED-TABLES NPSHANLG
&Scoped-define FIRST-DISPLAYED-TABLE NPSHANLG


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "&Cancel":L 
     SIZE 12 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 12 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "&OK":L 
     SIZE 12 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE Konsulent AS CHARACTER FORMAT "X(40)":U 
     LABEL "Konsulent" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 39.8 BY 1
     FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN
     FILENAME "bmp\spinn":U
     SIZE 3.6 BY 1.14.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 129.8 BY 17.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGOKCAN
     NPSHANLG.anleggsnr AT ROW 1.71 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.dato AT ROW 1.71 COL 46 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPSHANLG.aktivt AT ROW 1.95 COL 68
          VIEW-AS TOGGLE-BOX
          SIZE 11.8 BY .76
     NPSHANLG.endrings_laas AT ROW 1.95 COL 84
          VIEW-AS TOGGLE-BOX
          SIZE 43 BY .76
          FGCOLOR 12 
     NPSHANLG.anlegg AT ROW 2.91 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 53.8 BY 1
          FONT 2
     Konsulent AT ROW 4.1 COL 26 COLON-ALIGNED
     NPSHANLG.konsulentens_saksbeh AT ROW 4.1 COL 77 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 40.4 BY 1
     NPSHANLG.kundedistriktNr AT ROW 5.29 COL 26 COLON-ALIGNED
          LABEL "Salgsdistrikt"
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEM-PAIRS "",0
          DROP-DOWN-LIST
          SIZE 39 BY 1
          FONT 2
     NPSHANLG.saksbehandler AT ROW 6.48 COL 26 COLON-ALIGNED
          LABEL "Saksbeh."
          VIEW-AS COMBO-BOX 
          DROP-DOWN-LIST
          SIZE 29.2 BY 1
     NPSHANLG.selger AT ROW 6.57 COL 69 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 40 BY 1
     NPSHANLG.entreprise AT ROW 7.91 COL 26 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 16.6 BY 1
          FONT 2
     NPSHANLG.beskrevet AT ROW 7.91 COL 59.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 24.8 BY 1
          FONT 2
     NPSHANLG.anbudsfrist AT ROW 7.91 COL 109 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPSHANLG.byggestart AT ROW 9.33 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          FONT 2
     NPSHANLG.oppf_uke AT ROW 9.33 COL 57 COLON-ALIGNED
          LABEL "Oppf. uke"
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.8 BY 1
          FONT 2
     NPSHANLG.oppf_aar AT ROW 9.29 COL 77.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.2 BY 1
     NPSHANLG.leveringstid AT ROW 9.24 COL 109.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 16.2 BY 1
          FONT 2
     NPSHANLG.opplysninger AT ROW 11.81 COL 6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 122 BY 6.14
          FONT 2
     Btn_OK AT ROW 19.33 COL 43.6
     Btn_Cancel AT ROW 19.33 COL 58.6
     Btn_Help AT ROW 19.38 COL 74.2
     "Opplysninger:" VIEW-AS TEXT
          SIZE 16.8 BY 1 AT ROW 10.76 COL 6
     COMBO-SPINN AT ROW 4.14 COL 68.4
     RECT-30 AT ROW 1.24 COL 2
     SPACE(2.59) SKIP(2.51)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Shuntanlegg":L
         CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGOKCAN
   NOT-VISIBLE FRAME-NAME UNDERLINE Custom                              */
ASSIGN 
       FRAME DLGOKCAN:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPSHANLG.anlegg IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHANLG.anleggsnr IN FRAME DLGOKCAN
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSHANLG.beskrevet IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX NPSHANLG.entreprise IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN Konsulent IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX NPSHANLG.kundedistriktNr IN FRAME DLGOKCAN
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHANLG.leveringstid IN FRAME DLGOKCAN
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHANLG.oppf_uke IN FRAME DLGOKCAN
   NO-DISPLAY EXP-LABEL                                                 */
/* SETTINGS FOR COMBO-BOX NPSHANLG.saksbehandler IN FRAME DLGOKCAN
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
    IF INTEGER(NPSHANLG.oppf_uke:SCREEN-VALUE) = 0 OR 
        INTEGER(NPSHANLG.oppf_aar:SCREEN-VALUE) = 0 THEN
        DO:
            MESSAGE 'Neste oppfølgingsuke og år MÅ fylles ut' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.

    IF konsulentnrParam = '0' THEN    /* Ok trykket uten at konsulent er valgt -- ulovlig! */
        APPLY 'CHOOSE' TO Btn_Cancel.
    ELSE DO:
      find first npkundedistrikt where NPkundedistrikt.kundedistriktNr = int(npshanlg.kundedistriktnr:screen-value) no-lock no-error.
      if avail npkundedistrikt then NPSHANLG.salgsdistrikt = string(npkundedistrikt.kundedistriktnr) + ' / ' + NPkundedistrikt.kundedistriktnavn.
      IF nyRecord THEN DO:
        define var ip_neste_id as integer.

        run neste_id.p ('npshanlg', output ip_neste_id).
        ASSIGN  
          NPSHANLG.kundenr = konsulentnrParam
          NPSHANLG.anleggsnr = ip_neste_id
          NPSHANLG.prosjektid = prosjektIdParam.
        Current-Rec = ROWID(NPSHANLG).
        dynamic-function('setCurrentRec' in hParent,current-rec).
/*        nyRecord = TRUE.*/
        /* Ved nytt anlegg, skal prosjektet v‘re aktivt uansett */
        UPDATE NORPROSJEKT SET NORPROSJEKT.aktivt = TRUE
        WHERE NORPROSJEKT.prosjektid = prosjektidParam.
      END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-SPINN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-SPINN DLGOKCAN
ON MOUSE-SELECT-CLICK OF COMBO-SPINN IN FRAME DLGOKCAN
DO:
    APPLY "LEAVE"  TO konsulent.      
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
                    NPSHANLG.kundenr = konsulentnrParam.
                   DISPLAY konsulent WITH FRAME  {&FRAME-NAME}.
                    APPLY "ENTRY" TO NPSHANLG.entreprise.
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


&Scoped-define SELF-NAME NPSHANLG.kundedistriktNr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.kundedistriktNr DLGOKCAN
ON VALUE-CHANGED OF NPSHANLG.kundedistriktNr IN FRAME DLGOKCAN /* Salgsdistrikt */
DO:
/*    WHEN '90-Nordland' OR WHEN '100-Troms/Finnmark' OR WHEN '110-Svalbard' THEN*/
  CASE SELF:SCREEN-VALUE:
    WHEN '90' OR WHEN '100' OR WHEN '110' THEN
        DO:
            NPSHANLG.selger = 'Steinar Aune'.
            DISPLAY NPSHANLG.selger WITH FRAME {&FRAME-NAME}.
          END.
    OTHERWISE
        DO:
            NPSHANLG.selger = "Arne Svensson".
            DISPLAY NPSHANLG.selger WITH FRAME {&FRAME-NAME}.
          END.           
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.saksbehandler
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.saksbehandler DLGOKCAN
ON ANY-PRINTABLE OF NPSHANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.saksbehandler DLGOKCAN
ON CURSOR-DOWN OF NPSHANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
DO:
    i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.saksbehandler DLGOKCAN
ON CURSOR-UP OF NPSHANLG.saksbehandler IN FRAME DLGOKCAN /* Saksbeh. */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.selger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.selger DLGOKCAN
ON ANY-PRINTABLE OF NPSHANLG.selger IN FRAME DLGOKCAN /* Selger */
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.selger DLGOKCAN
ON CURSOR-DOWN OF NPSHANLG.selger IN FRAME DLGOKCAN /* Selger */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.selger DLGOKCAN
ON CURSOR-UP OF NPSHANLG.selger IN FRAME DLGOKCAN /* Selger */
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
  SESSION:SET-WAIT-STATE("").
  hParent = source-procedure.
  current-rec = dynamic-function('getCurrentRec' in hParent).
  nyRecord    = logical(dynamic-function('getNyRecord' in hParent)).
  prosjektidparam = int(jboxSession:Instance:getJBoxAttribute('ProsjektId')).
  prosjektNavnparam = jboxSession:Instance:getJBoxAttribute('ProsjektNavn').
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGOKCAN  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGOKCAN  _DEFAULT-ENABLE
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
  IF AVAILABLE NPSHANLG THEN 
    DISPLAY NPSHANLG.dato NPSHANLG.aktivt NPSHANLG.endrings_laas 
          NPSHANLG.konsulentens_saksbeh NPSHANLG.kundedistriktNr 
          NPSHANLG.saksbehandler NPSHANLG.selger NPSHANLG.anbudsfrist 
          NPSHANLG.byggestart NPSHANLG.oppf_aar NPSHANLG.opplysninger 
      WITH FRAME DLGOKCAN.
  ENABLE COMBO-SPINN NPSHANLG.dato NPSHANLG.aktivt RECT-30 
         NPSHANLG.endrings_laas NPSHANLG.anlegg Konsulent 
         NPSHANLG.konsulentens_saksbeh NPSHANLG.kundedistriktNr 
         NPSHANLG.saksbehandler NPSHANLG.selger NPSHANLG.entreprise 
         NPSHANLG.beskrevet NPSHANLG.anbudsfrist NPSHANLG.byggestart 
         NPSHANLG.oppf_uke NPSHANLG.oppf_aar NPSHANLG.leveringstid 
         NPSHANLG.opplysninger Btn_OK Btn_Cancel Btn_Help 
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
  FIND NPSHANLG WHERE ROWID(NPSHANLG) = Current-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NPSHANLG THEN DO with frame {&Frame-name}:
          DISPLAY NPSHANLG.anleggsnr   WITH FRAME DLGOKCAN.
          FIND NPKUNDE WHERE NPKUNDE.kundenr = NPSHANLG.kundenr
            NO-LOCK NO-WAIT NO-ERROR.
          IF AVAILABLE NPKUNDE THEN  konsulent = NPKUNDE.kundenavn.
          ELSE
            RETURN.
             
      UPDATE 
        norcalc.NPSHANLG.dato NPSHANLG.aktivt NPSHANLG.endrings_laas 
        norcalc.NPSHANLG.anlegg Konsulent NPSHANLG.konsulentens_saksbeh
        NPSHANLG.kundedistriktnr NPSHANLG.saksbehandler  NPSHANLG.selger 
        norcalc.NPSHANLG.entreprise norcalc.NPSHANLG.beskrevet 
        norcalc.NPSHANLG.anbudsfrist norcalc.NPSHANLG.byggestart
        norcalc.NPSHANLG.oppf_uke NPSHANLG.oppf_aar NPSHANLG.leveringstid 
        NPSHANLG.opplysninger
         Btn_OK Btn_Cancel Btn_Help
      WITH FRAME DLGOKCAN.
      
 END.
ELSE
    DO:
    MESSAGE 'Tabellen for Shuntanlegg er opptatt. Prøv igjen om en liten stund' VIEW-AS ALERT-BOX
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
def var iGruppeId_saksbehandler as int no-undo.
def var iGruppeId_selger as int no-undo.
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN
      iGruppeId_saksbehandler       = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Saksbehandler"','iGruppeId')) 
      iGruppeId_selger              = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Selger"','iGruppeId'))
      npshanlg.Entreprise:DELIMITER          = '|'
      npshanlg.Entreprise:LIST-ITEM-PAIRS    = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListEntreprise' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      npshanlg.beskrevet:DELIMITER           = '|'
      npshanlg.beskrevet:LIST-ITEM-PAIRS     = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListBeskrevet' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      npshanlg.selger:DELIMITER              = '|'
      npshanlg.selger:LIST-ITEM-PAIRS        = JBoxServerAPI:Instance:FieldList("Persongruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      npshanlg.saksbehandler:DELIMITER       = '|'
      npshanlg.saksbehandler:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("PersonGruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_saksbehandler) + ", First Person of PersonGruppe where bAktiv and person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      npshanlg.kundedistriktnr:DELIMITER       = '|'
      npshanlg.kundedistriktnr:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPkundedistrikt;Kundedistriktnr|KundeDistriktNavn;KundeDistriktNr","WHERE true" + ' BY KundedistriktNr')
    .
  end.

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
     create npshanlg.
     NPSHANLG.dato = TODAY.
     NPSHANLG.oppf_aar = YEAR(TODAY).
     NPSHANLG.anlegg = prosjektNavnParam.
     NPSHANLG.anleggsnr = iNextAnleggsnr.
     DISPLAY NPSHANLG.anleggsnr  NPSHANLG.anlegg NPSHANLG.dato WITH FRAME  {&FRAME-NAME}.
  ENABLE  COMBO-SPINN WITH FRAME DLGOKCAN.
 UPDATE 
        RECT-30 norcalc.NPSHANLG.dato norcalc.NPSHANLG.anlegg Konsulent 
        NPSHANLG.konsulentens_saksbeh
        NPSHANLG.saksbehandler NPSHANLG.kundedistriktnr NPSHANLG.selger 
        norcalc.NPSHANLG.entreprise norcalc.NPSHANLG.beskrevet 
        norcalc.NPSHANLG.anbudsfrist norcalc.NPSHANLG.byggestart
        norcalc.NPSHANLG.oppf_uke NPSHANLG.oppf_aar NPSHANLG.leveringstid 
        NPSHANLG.opplysninger
         Btn_OK Btn_Cancel Btn_Help
      WITH FRAME DLGOKCAN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

