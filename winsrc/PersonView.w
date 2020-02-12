&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description:        JukeBox suppressed window template
                      This template is for use with a tabfolder or viewer object
                      to parent the suppressed window

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            brynjar@chemistry.no

  Created:           30.march.2008

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
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

DEF VAR bOk                 AS LOG    NO-UNDO.
DEF VAR ix                  AS INT    NO-UNDO.
DEF VAR hQuery              AS HANDLE NO-UNDO.
DEF VAR hFieldMap           AS HANDLE NO-UNDO.
DEF VAR hToolbar            AS HANDLE NO-UNDO.
DEF VAR hParent             AS HANDLE NO-UNDO.
DEF VAR hParentQueryObject  AS HANDLE NO-UNDO.
DEF VAR cVareId             AS CHAR   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME frmPerson

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cInitialer iAnsattnr bAktiv cTittel cNavn ~
cPostAdresse cPostPnr cPostSted cTlf cMob btnPostnr cEpost iAvdelingNr ~
cMerknad cKontonr cPostAdrLabel cMerknadLabel cVarenr btncVarenr cVareTekst ~
fPrisEnhet TbPerson 
&Scoped-Define DISPLAYED-OBJECTS cInitialer iAnsattnr bAktiv cTittel cNavn ~
cPostAdresse cPostPnr cPostSted cTlf cMob cEpost iAvdelingNr cMerknad ~
cKontonr cPostAdrLabel cMerknadLabel cVarenr cVareTekst fPrisEnhet 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameHandle C-Win 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD InitializeResize C-Win 
FUNCTION InitializeResize RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  ( INPUT ihParent AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQuery C-Win 
FUNCTION setQuery RETURNS LOGICAL
  ( INPUT ihParentQueryObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btncVarenr 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btnPostnr 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE VARIABLE iAvdelingNr AS INTEGER FORMAT "->>>>9" INITIAL 0 
     LABEL "Avdeling" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 61.2 BY 1.

DEFINE VARIABLE cMerknad AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 61.2 BY 1.95.

DEFINE VARIABLE cPostAdresse AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 61.2 BY 1.62 TOOLTIP "Postadresse / faktura-adresse".

DEFINE VARIABLE cEpost AS CHARACTER FORMAT "x(50)" 
     LABEL "Epost" 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1.

DEFINE VARIABLE cInitialer AS CHARACTER FORMAT "x(7)" 
     LABEL "Initialer" 
     VIEW-AS FILL-IN 
     SIZE 9.6 BY 1.

DEFINE VARIABLE cKontonr AS CHARACTER FORMAT "x(13)" 
     LABEL "Kontonr" 
     VIEW-AS FILL-IN 
     SIZE 18 BY 1.

DEFINE VARIABLE cMerknadLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Merknad:" 
      VIEW-AS TEXT 
     SIZE 9.6 BY .62 NO-UNDO.

DEFINE VARIABLE cMob AS CHARACTER FORMAT "x(12)" 
     LABEL "Mob" 
     VIEW-AS FILL-IN 
     SIZE 17.6 BY 1.

DEFINE VARIABLE cNavn AS CHARACTER FORMAT "X(50)" 
     LABEL "Navn" 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1.

DEFINE VARIABLE cPostAdrLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Postadresse:" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE cPostPnr AS CHARACTER FORMAT "x(8)" 
     LABEL "Postnr" 
     VIEW-AS FILL-IN 
     SIZE 12 BY 1.

DEFINE VARIABLE cPostSted AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 44.8 BY 1.

DEFINE VARIABLE cTittel AS CHARACTER FORMAT "x(50)" 
     LABEL "Tittel" 
     VIEW-AS FILL-IN 
     SIZE 61 BY 1.

DEFINE VARIABLE cTlf AS CHARACTER FORMAT "x(12)" 
     LABEL "Tlf" 
     VIEW-AS FILL-IN 
     SIZE 17.6 BY 1.

DEFINE VARIABLE cVarenr AS CHARACTER FORMAT "x(13)" 
     LABEL "Varenr" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1.

DEFINE VARIABLE cVareTekst AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.4 BY 1.

DEFINE VARIABLE fPrisEnhet AS DECIMAL FORMAT "->>>,>>>,>>9.99" INITIAL 0 
     LABEL "Timepris" 
     VIEW-AS FILL-IN 
     SIZE 17.6 BY 1.

DEFINE VARIABLE iAnsattnr AS INTEGER FORMAT "->>>>>>9" INITIAL 0 
     LABEL "Ansattnr" 
     VIEW-AS FILL-IN 
     SIZE 8.6 BY 1.

DEFINE RECTANGLE TbPerson
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 1.9.

DEFINE VARIABLE bAktiv AS LOGICAL INITIAL yes 
     LABEL "Aktiv" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.8 BY .81 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME frmPerson
     cInitialer AT ROW 3.38 COL 13.4 COLON-ALIGNED
     iAnsattnr AT ROW 3.38 COL 33 COLON-ALIGNED
     bAktiv AT ROW 3.48 COL 64
     cTittel AT ROW 4.48 COL 13.4 COLON-ALIGNED
     cNavn AT ROW 5.57 COL 13.4 COLON-ALIGNED
     cPostAdresse AT ROW 6.67 COL 15.4 HELP
          "Postadresse / faktura-adresse" NO-LABEL
     cPostPnr AT ROW 8.38 COL 13.4 COLON-ALIGNED HELP
          "Please enter standard state abbreviation."
     cPostSted AT ROW 8.38 COL 29.8 COLON-ALIGNED HELP
          "Please enter the full state name." NO-LABEL
     cTlf AT ROW 9.62 COL 13.4 COLON-ALIGNED
     cMob AT ROW 9.67 COL 39.8 COLON-ALIGNED
     btnPostnr AT ROW 8.38 COL 27.8 NO-TAB-STOP 
     cEpost AT ROW 10.67 COL 13.4 COLON-ALIGNED
     iAvdelingNr AT ROW 11.76 COL 13.4 COLON-ALIGNED
     cMerknad AT ROW 14.1 COL 15.4 NO-LABEL
     cKontonr AT ROW 4.48 COL 89 COLON-ALIGNED
     cPostAdrLabel AT ROW 6.71 COL 1 COLON-ALIGNED NO-LABEL
     cMerknadLabel AT ROW 14.14 COL 3.8 COLON-ALIGNED NO-LABEL
     cVarenr AT ROW 12.91 COL 13.4 COLON-ALIGNED HELP
          "Varenr for standard utleiepris ved allokering til prosjekt"
     btncVarenr AT ROW 12.91 COL 30.6 NO-TAB-STOP 
     cVareTekst AT ROW 12.91 COL 32.6 COLON-ALIGNED NO-LABEL
     fPrisEnhet AT ROW 12.91 COL 89 COLON-ALIGNED
     TbPerson AT ROW 1.24 COL 1.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 108.8 BY 15.19.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* SUPPRESS Window definition (used by the UIB) 
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "JukeSox plain suppressed window"
         HEIGHT             = 15.19
         WIDTH              = 109
         MAX-HEIGHT         = 28.57
         MAX-WIDTH          = 160
         VIRTUAL-HEIGHT     = 28.57
         VIRTUAL-WIDTH      = 160
         SHOW-IN-TASKBAR    = no
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
                                                                        */
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME
ASSIGN C-Win = CURRENT-WINDOW.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{incl/devmode.i}
{incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME frmPerson
   FRAME-NAME Custom                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* JukeSox plain suppressed window */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* JukeSox plain suppressed window */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btncVarenr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btncVarenr C-Win
ON CHOOSE OF btncVarenr IN FRAME frmPerson /* ... */
DO:
  DEF VAR cReturnValues   AS CHAR NO-UNDO.
  DEF VAR bOk             AS LOG  NO-UNDO.

  THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = FALSE.
  RUN JBoxLookup.w (THIS-PROCEDURE,200,
                    "Vare"
                    + ";cVareTekst"
                    + ";cVarenr"
                    + ";fPrisEnhet"
                    + ";bActive"
                  + ",VareGruppe"
                    + ";cVareGruppeTekst"
                    + ";bTimer"
                   ,"WHERE false"
                  + ",FIRST VareGruppe NO-LOCK WHERE VareGruppe.iVareGruppeId = Vare.iVareGruppeID"
                    ,""                                                  
                    ,"cVarenr",   /* <- return values for these fields */
                    OUTPUT cReturnValues,
                    OUTPUT bOK).
  THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = TRUE.

  IF bOk AND cReturnValues NE "" THEN DO:
    ASSIGN cVarenr:SCREEN-VALUE = ENTRY(1,cReturnValues,"|")
           .

    APPLY "any-printable" TO cVarenr.
    APPLY "tab" TO cVarenr.
  END.
  THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnPostnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnPostnr C-Win
ON CHOOSE OF btnPostnr IN FRAME frmPerson /* ... */
DO:
  DEF VAR cPostNummerFieldList    AS CHAR NO-UNDO.

  THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = FALSE.
  RUN JBoxLookup.w (THIS-PROCEDURE,50,
                    "PostNummer"
                     + ";cPostSted"
                     + ";cPostNr"
                    ,"where false(Codemaster)"
                    ,""
                    ,"cPostNr,cPostSted",
                    OUTPUT cPostNummerFieldList,
                    OUTPUT bOK).
  THIS-PROCEDURE:CURRENT-WINDOW:SENSITIVE = TRUE.

  IF bOk AND cPostNummerFieldList NE "" THEN DO:
    ASSIGN 
       cPostPnr:SCREEN-VALUE   = ENTRY(1,cPostNummerFieldList,"|")
       cPostSted:SCREEN-VALUE  = ENTRY(2,cPostNummerFieldList,"|")
       .
    APPLY "any-printable" TO cPostPnr.
  END.
  THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cInitialer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cInitialer C-Win
ON BACK-TAB OF cInitialer IN FRAME frmPerson /* Initialer */
DO:
  IF hParentQueryObject:TYPE = "browse" THEN
    APPLY "entry" TO hParentQueryObject.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cPostPnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cPostPnr C-Win
ON F3 OF cPostPnr IN FRAME frmPerson /* Postnr */
DO:
  APPLY "choose" TO btnPostnr.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  /* The viewer or tabfolder object will see to that the Disable_UI is run
     and the container will make sure that all dynamic objects + resize settings are deleted
     also for the suppressed windows */
  PUBLISH "InvalidateHandle".
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
    RUN InitializeObject.
  &ENDIF

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

{incl/supptrigg.i hQuery}  /* <- To be able to capture keys (insert, delete..) on the browse */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  HIDE FRAME frmPerson.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN SUPER.
ASSIGN cInitialer:READ-ONLY IN FRAME {&FRAME-NAME} = YES
       cVareId = IF hFieldMap:AVAIL THEN STRING(hFieldMap:BUFFER-FIELD("iVareId"):BUFFER-VALUE) ELSE "0"
       .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  DISPLAY cInitialer iAnsattnr bAktiv cTittel cNavn cPostAdresse cPostPnr 
          cPostSted cTlf cMob cEpost iAvdelingNr cMerknad cKontonr cPostAdrLabel 
          cMerknadLabel cVarenr cVareTekst fPrisEnhet 
      WITH FRAME frmPerson.
  ENABLE cInitialer iAnsattnr bAktiv cTittel cNavn cPostAdresse cPostPnr 
         cPostSted cTlf cMob btnPostnr cEpost iAvdelingNr cMerknad cKontonr 
         cPostAdrLabel cMerknadLabel cVarenr btncVarenr cVareTekst fPrisEnhet 
         TbPerson 
      WITH FRAME frmPerson.
  {&OPEN-BROWSERS-IN-QUERY-frmPerson}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Create any dynamic objects, initialize drop-down lists etc
  Parameters:  <none>
  Notes:       The dynamic query object must be linked to the THIS-PROCEDURE
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  DYNAMIC-FUNCTION("NewObject",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE,"procedure").

  ASSIGN iAvdelingNr:DELIMITER = "|"
         iAvdelingNr:LIST-ITEM-PAIRS = RIGHT-TRIM("|0|"
                                                + DYNAMIC-FUNCTION("getFieldList","Avdeling;cAvdeling|iAvdelingNr;iAvdelingNr",
                                                                   "WHERE iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany"))
                                                  ,"|")
         .

  hQuery = DYNAMIC-FUNCTION("NewQuery"
        ,100
        ,""
        ,"Person"
       + ",Vare"
        + ";cVareTekst"
        + ";fPrisEnhet"
        ,"WHERE false"
       + ",FIRST Vare NO-LOCK WHERE Vare.iVareId = Person.iVareId OUTER-JOIN"
        ,"").

  DYNAMIC-FUNCTION("CreateObjectLink",hQuery,THIS-PROCEDURE).
  DYNAMIC-FUNCTION("setAttribute",hQuery,"viewRecordCount","no").

  hFieldMap = DYNAMIC-FUNCTION("NewFieldMap",
                    hQuery,
                    FRAME {&FRAME-NAME}:HANDLE,
                    "cInitialer,iAnsattnr,iAvdelingNr,cKontoNr,bAktiv,cNavn,cEpost,cTittel,cPostAdresse,cPostPnr,cPostSted,cMerknad,cMob,cTlf,cVarenr","",
                    "cVareTekst,fPrisEnhet","",
                    "btncVarenr").
  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"customDeleteValProc","=del_person.p").
  DYNAMIC-FUNCTION("CreateObjectLink",hQuery,hFieldMap).

  DYNAMIC-FUNCTION("setAttribute",hFieldMap,"BufferExtraFields","iJBoxCompanyId,iVareId").

  hToolbar = DYNAMIC-FUNCTION("NewToolBar",
                    TbPerson:HANDLE,
                    "Fil",
                    "new;Ny,undo;Angre,delete;Slett,save;Lagre",
                    "maxborder").

  DYNAMIC-FUNCTION("CreateObjectLink",hQuery,hToolbar).
  DYNAMIC-FUNCTION("CreateObjectLink",hFieldMap,hToolbar).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihField AS HANDLE NO-UNDO.

DEF VAR cReturn AS CHAR NO-UNDO.

IF ihField:MODIFIED THEN DO WITH FRAME {&FRAME-NAME}:
  CASE ihField:NAME:
    WHEN "cPostPnr" THEN
      cPostSted:SCREEN-VALUE = DYNAMIC-FUNCTION("getFieldValues","PostNummer","WHERE cPostNr = '" + ihField:SCREEN-VALUE + "'(Codemaster)","cPostSted").
    WHEN "cVarenr" THEN DO:
      cReturn = DYNAMIC-FUNCTION("getFieldValues","Vare",
                                                  "WHERE cVarenr = '" + ihField:SCREEN-VALUE + "' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany"),
                                                  "cVareTekst,iVareId,fPrisEnhet").
      IF cReturn NE ? THEN 
        ASSIGN cVareTekst:SCREEN-VALUE = ENTRY(1,cReturn,"|")
               cVareId = ENTRY(2,cReturn,"|")
               fPrisEnhet:SCREEN-VALUE = ENTRY(3,cReturn,"|")
               .
      ELSE 
        ASSIGN cVareTekst:SCREEN-VALUE = ""
               cVareId = ""
               fPrisEnhet:SCREEN-VALUE = ""
               .
    END.
  END CASE.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop C-Win 
PROCEDURE MoveToTop :
/*------------------------------------------------------------------------------
  Purpose:     Mak
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FRAME {&FRAME-NAME}:MOVE-TO-TOP().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DYNAMIC-FUNCTION("setAttribute",hFieldMap,"BufferExtraValues",DYNAMIC-FUNCTION("getCompanyId") + "|" + cVareId).

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setLookupAttributes C-Win 
PROCEDURE setLookupAttributes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihBrowse AS HANDLE NO-UNDO.
DEF INPUT PARAM ihTBrect  AS HANDLE NO-UNDO.
DEF INPUT PARAM ihOther   AS HANDLE NO-UNDO.

DEF VAR httBuffer AS HANDLE NO-UNDO.
DEF VAR ix        AS INT    NO-UNDO.
DEF VAR hTbLookup AS HANDLE NO-UNDO.
DEF VAR cTable    AS CHAR   NO-UNDO.

cTable = ihBrowse:QUERY:GET-BUFFER-HANDLE(1):NAME.

IF CAN-DO("Vare",cTable) THEN DO:
  hTBlookup = DYNAMIC-FUNCTION("NewToolbar",ihTBrect,"Fil",
                   "Filter"
                   ,"enable").
  DYNAMIC-FUNCTION("CreateObjectLink",ihBrowse,hTBlookup).

  DYNAMIC-FUNCTION("setAttribute",ihBrowse,"preScanBaseQuery","VareGruppe WHERE bTimer AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + ",EACH Vare WHERE Vare.iVareGruppeId = VareGruppe.iVareGruppeId").
  DYNAMIC-FUNCTION("setAttribute",ihBrowse,"baseQuery","WHERE iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany")).
  DYNAMIC-FUNCTION("setAttribute",ihBrowse,"preScanQueryVareGruppe","EACH Vare WHERE Vare.iVareGruppeId = VareGruppe.iVareGruppeId").
  DYNAMIC-FUNCTION("InitDynFilter",ihBrowse,"bActive","=","yes","try").

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrameHandle C-Win 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Make the frame of the child procedure known to the tabfolder or viewer object
    Notes: The procedure is mandatory
------------------------------------------------------------------------------*/

  RETURN FRAME {&FRAME-NAME}:HANDLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION InitializeResize C-Win 
FUNCTION InitializeResize RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: This function is invoked automatically from the viewer or tabfolder object before
           InitializeObject and also before the suppressed window is resized to fit the size of the 
           graphics placeholder.
  Notes:   Note that if the suppressed window contains a searchfield or toolbar object
           the placeholders for these must have resize settings here since the objects themselves have not been 
           initialized. (When a searchfield or tabfolder is created the resize is automatically taken care of).
           
           This function is not mandatory but is called if it exists
------------------------------------------------------------------------------*/

DYNAMIC-FUNCTION("setNoResizeY", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE,"frmPerson,cMerknad,cPostAdresse").
  
RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  ( INPUT ihParent AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Set the handle to the parent procedure for the suppressed window
    Notes: This function is not mandatory but is called if it exists
------------------------------------------------------------------------------*/
hParent = ihParent.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQuery C-Win 
FUNCTION setQuery RETURNS LOGICAL
  ( INPUT ihParentQueryObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Set the handle of the parent (or oneToOne navigation query/browse) so
           it is available for the child object 
    Notes: This function is not mandatory but is called if it exists 
------------------------------------------------------------------------------*/
hParentQueryObject = ihParentQueryObject.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

