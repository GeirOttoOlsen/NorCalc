&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

/* Local Variable Definitions ---                                       */
DEFINE VAR konsulentnrParam AS INTEGER.
DEFINE VAR konsulentnvnParam AS CHAR.
DEFINE VAR pointer AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES NPSHANLG
&Scoped-define FIRST-EXTERNAL-TABLE NPSHANLG


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR NPSHANLG.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHANLG.dato NPSHANLG.aktivt ~
NPSHANLG.endrings_laas NPSHANLG.anlegg NPSHANLG.kundedistriktNr ~
NPSHANLG.saksbehandler NPSHANLG.selger NPSHANLG.entreprise ~
NPSHANLG.beskrevet NPSHANLG.anbudsfrist NPSHANLG.byggestart ~
NPSHANLG.oppf_uke NPSHANLG.leveringstid NPSHANLG.opplysninger 
&Scoped-define ENABLED-TABLES NPSHANLG
&Scoped-define FIRST-ENABLED-TABLE NPSHANLG
&Scoped-Define ENABLED-OBJECTS COMBO-SPINN Konsulent 
&Scoped-Define DISPLAYED-FIELDS NPSHANLG.aktivt NPSHANLG.endrings_laas ~
NPSHANLG.kundedistriktNr NPSHANLG.saksbehandler NPSHANLG.selger ~
NPSHANLG.opplysninger 
&Scoped-define DISPLAYED-TABLES NPSHANLG
&Scoped-define FIRST-DISPLAYED-TABLE NPSHANLG


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE Konsulent AS CHARACTER FORMAT "X(40)":U 
     LABEL "Konsulent" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 55.8 BY 1.24
     FONT 2 NO-UNDO.

DEFINE IMAGE COMBO-SPINN
     FILENAME "spinn":U
     SIZE 3.6 BY 1.24.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     NPSHANLG.anleggsnr AT ROW 1.38 COL 19.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.dato AT ROW 1.38 COL 40.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     NPSHANLG.aktivt AT ROW 1.38 COL 64.6
          VIEW-AS TOGGLE-BOX
          SIZE 12.4 BY .95
     NPSHANLG.endrings_laas AT ROW 1.38 COL 85.6
          LABEL "Lå†st for endringer"
          VIEW-AS TOGGLE-BOX
          SIZE 26.4 BY .95
          FGCOLOR 12 FONT 2
     NPSHANLG.anlegg AT ROW 2.81 COL 19.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 75.4 BY 1.24
          FONT 2
     Konsulent AT ROW 4.24 COL 19.4 COLON-ALIGNED
     NPSHANLG.kundedistriktNr AT ROW 5.52 COL 19.2 COLON-ALIGNED
          LABEL "Salgsdistrikt"
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEM-PAIRS "",1
          DROP-DOWN-LIST
          SIZE 47.8 BY 1
          FONT 2
     NPSHANLG.saksbehandler AT ROW 6.81 COL 19.2 COLON-ALIGNED
          LABEL "Saksbeh."
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 33.8 BY 6.81
          FONT 2
     NPSHANLG.selger AT ROW 6.81 COL 75.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 33.8 BY 6.81
          FONT 2
     NPSHANLG.entreprise AT ROW 8.33 COL 19.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 16.8 BY 8.33
          FONT 2
     NPSHANLG.beskrevet AT ROW 8.33 COL 57 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 14.2 BY 8.33
          FONT 2
     NPSHANLG.anbudsfrist AT ROW 8.33 COL 90.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14.2 BY 1.24
          FONT 2
     NPSHANLG.byggestart AT ROW 9.67 COL 19.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14.2 BY 1.24
          FONT 2
     NPSHANLG.oppf_uke AT ROW 9.67 COL 57 COLON-ALIGNED
          LABEL "Oppf›lgingsuke"
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.8 BY 1.24
          FONT 2
     NPSHANLG.leveringstid AT ROW 9.67 COL 82.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 22.6 BY 1.24
          FONT 2
     NPSHANLG.opplysninger AT ROW 11.33 COL 5.2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
          SIZE 117.4 BY 5.67
          FONT 2
     COMBO-SPINN AT ROW 4.24 COL 77.4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: norcalc.NPSHANLG
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 16.33
         WIDTH              = 123.8.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPSHANLG.anbudsfrist IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHANLG.anlegg IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHANLG.anleggsnr IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSHANLG.beskrevet IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHANLG.byggestart IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHANLG.dato IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR TOGGLE-BOX NPSHANLG.endrings_laas IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPSHANLG.entreprise IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN Konsulent IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR COMBO-BOX NPSHANLG.kundedistriktNr IN FRAME F-Main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSHANLG.leveringstid IN FRAME F-Main
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHANLG.oppf_uke IN FRAME F-Main
   NO-DISPLAY EXP-LABEL                                                 */
/* SETTINGS FOR COMBO-BOX NPSHANLG.saksbehandler IN FRAME F-Main
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME COMBO-SPINN
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-SPINN V-table-Win
ON MOUSE-SELECT-CLICK OF COMBO-SPINN IN FRAME F-Main
DO:
    APPLY "LEAVE"  TO konsulent.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Konsulent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Konsulent V-table-Win
ON LEAVE OF Konsulent IN FRAME F-Main /* Konsulent */
DO:
/*   FIND NPKONSULENT WHERE NPKONSULENT.konsulentnavn = Konsulent:SCREEN-VALUE NO-ERROR.
   IF NOT AVAILABLE(NPKONSULENT) THEN
       DO:*/
           konsulentnrParam = 0.
           konsulentnvnParam = "".
           RUN VELGKONS.W (INPUT-OUTPUT konsulentnrParam, INPUT-OUTPUT konsulentnvnParam) NO-ERROR.
           IF konsulentnrParam = 0 THEN DO:
               MESSAGE 'Det m† knyttes en konsulent til anlegget'  VIEW-AS ALERT-BOX TITLE 'Feil'.
               RETURN NO-APPLY.
               END.
           ELSE 
               DO:
                    Konsulent = konsulentnvnParam.
                   NPSHANLG.konsulentid = konsulentnrParam.
                   DISPLAY konsulent WITH FRAME  {&FRAME-NAME}.
                    APPLY "ENTRY" TO entreprise.
               END.
/*        END.
   ELSE
       DO:
           Konsulent = NPKONSULENT.konsulentnavn.
           konsulentnrParam = NPKONSULENT.konsulentid.
           NPSHANLG.konsulentid = konsulentnrParam.
           DISPLAY konsulent WITH FRAME  {&FRAME-NAME}.
           APPLY "ENTRY" TO entreprise.
       END.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.kundedistriktNr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.kundedistriktNr V-table-Win
ON VALUE-CHANGED OF NPSHANLG.kundedistriktNr IN FRAME F-Main /* Salgsdistrikt */
DO:
  CASE SELF:SCREEN-VALUE:
    WHEN '90-Nordland' OR WHEN '100-Troms/Finnmark' OR WHEN '110-Svalbard' THEN
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "NPSHANLG"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "NPSHANLG"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  DO WITH FRAME {&FRAME-NAME}:
    def var iGruppeId_saksbehandler as int no-undo.
    def var iGruppeId_selger as int no-undo.
    
    ASSIGN
      iGruppeId_saksbehandler       = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Saksbehandler"','iGruppeId')) 
      iGruppeId_selger              = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Selger"','iGruppeId'))
      npshanlg.Entreprise:DELIMITER          = '|'
      npshanlg.Entreprise:LIST-ITEM-PAIRS    = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListEntreprise' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      npshanlg.beskrevet:DELIMITER           = '|'
      npshanlg.beskrevet:LIST-ITEM-PAIRS     = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListBeskrevet' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
      npshanlg.selger:DELIMITER              = '|'
      npshanlg.selger:LIST-ITEM-PAIRS        = JBoxServerAPI:Instance:FieldList("Persongruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      /*    anleggstype:DELIMITER = '|'                                                                                                                                                                                                                                                            */
      /*    anleggstype:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPanleggstype,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")*/
      npshanlg.saksbehandler:DELIMITER       = '|'
      npshanlg.saksbehandler:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("PersonGruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_saksbehandler) + ", First Person of PersonGruppe where bAktiv and person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
      npshanlg.kundedistriktnr:DELIMITER       = '|'
      npshanlg.kundedistriktnr:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPkundedistrikt;Kundedistriktnr|KundeDistriktNavn;KundeDistriktNr","WHERE true" + ' BY KundedistriktNr')
      .
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "NPSHANLG"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

