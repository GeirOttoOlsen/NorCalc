&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME MainWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS MainWindow 
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

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VAR p-handle AS HANDLE NO-UNDO.
DEFINE VAR pointer AS LOGICAL NO-UNDO.
DEFINE VAR Current-Rec AS RECID NO-UNDO.
DEFINE VAR slettetParam AS LOGICAL NO-UNDO.
def var h as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 NORCALC RECT-6 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR MainWindow AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Kunder 
       MENU-ITEM m_Kunderegister LABEL "&Kunderegister"
       RULE
       MENU-ITEM m_Utskrift_konsulenter LABEL "&Utskrift konsulenter".

DEFINE SUB-MENU m_Grupper 
       MENU-ITEM m_FMGrupper    LABEL "&FM"           
       MENU-ITEM m_MSGrupper    LABEL "&MS"           .

DEFINE SUB-MENU m_Kvs 
       MENU-ITEM m_FMKvs        LABEL "&FM"           
       MENU-ITEM m_MSKvs        LABEL "&MS"           .

DEFINE SUB-MENU m_Beregningsdata 
       SUB-MENU  m_Grupper      LABEL "&Grupper"      
              DISABLED
       SUB-MENU  m_Kvs          LABEL "&Kvs"          
              DISABLED
       MENU-ITEM m_Ventiltyper_-_MS LABEL "&Ventiltyper - MS"
              DISABLED.

DEFINE SUB-MENU m_Aggregater 
       MENU-ITEM m_Typedefinisjon LABEL "&Typedefinisjon..."
       MENU-ITEM m_Kabinettml   LABEL "&Kabinettmål..."
       MENU-ITEM m_Batteriml    LABEL "&Batterimål..."
       MENU-ITEM m_Vifter       LABEL "&Vifter..."    .

DEFINE SUB-MENU m_Div_oppretting 
       MENU-ITEM m_Tilbudsnr_shunter LABEL "Tilbudsnr shunter"
              DISABLED
       MENU-ITEM m_Tilbudsnr_spiro LABEL "Tilbudsnr spiro"
              DISABLED
       MENU-ITEM m_Tilbudsnr_aggregater LABEL "Tilbudsnr aggregater"
              DISABLED.

DEFINE SUB-MENU m_Admin 
       SUB-MENU  m_Beregningsdata LABEL "&Beregningsdata"
              DISABLED
       MENU-ITEM m_Kontaktpersoner LABEL "&Kontaktpersoner..."
              DISABLED
       MENU-ITEM m_Forstillingsorgan LABEL "&Forstillingsorgan..."
              DISABLED
       MENU-ITEM m_Vareliste    LABEL "&Vareliste..." 
              DISABLED
       MENU-ITEM m_Plukkliste   LABEL "&Plukkliste..."
              DISABLED
       MENU-ITEM m_Rapporter    LABEL "&Rapporter"    
              DISABLED
       MENU-ITEM m_Spirovent    LABEL "&Spirovent..." 
              DISABLED
       SUB-MENU  m_Aggregater   LABEL "&Aggregater"   
              DISABLED
       SUB-MENU  m_Div_oppretting LABEL "Div. oppretting"
              DISABLED
       RULE
       MENU-ITEM m_Vis_printeroppsett LABEL "Vis printeroppsett"
              DISABLED TOGGLE-BOX.

DEFINE MENU MENU-BAR-C-Win MENUBAR
       MENU-ITEM m_Prosjekter   LABEL "&Prosjekt"     
       SUB-MENU  m_Kunder       LABEL "K&under"       
       SUB-MENU  m_Admin        LABEL "A&dmin"        
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
DEFINE IMAGE IMAGE-1
     FILENAME "bmp/admin.bmp":U
     SIZE 12.8 BY 3.1.

DEFINE IMAGE NORCALC
     FILENAME "bmp/norcalc.bmp":U
     SIZE 40 BY 2
     BGCOLOR 9 FGCOLOR 9 .

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 4 GRAPHIC-EDGE    
     SIZE 61.4 BY 10.29
     BGCOLOR 9 FGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     "System for tekniske beregninger" VIEW-AS TEXT
          SIZE 31.2 BY .67 AT ROW 8.24 COL 48.2
          BGCOLOR 9 FGCOLOR 8 
     "og tilbudsadministrasjon" VIEW-AS TEXT
          SIZE 23.2 BY .67 AT ROW 9.05 COL 52
          BGCOLOR 9 FGCOLOR 8 
     "Copyright:Nor - Produkter AS, Tvedestrand" VIEW-AS TEXT
          SIZE 51.6 BY .95 AT ROW 13.29 COL 38
          BGCOLOR 9 FGCOLOR 8 FONT 2
     "Ver. 2.0" VIEW-AS TEXT
          SIZE 8.2 BY .62 AT ROW 14.14 COL 59.4
          BGCOLOR 9 FGCOLOR 8 
     IMAGE-1 AT ROW 10 COL 57
     NORCALC AT ROW 6.14 COL 44
     RECT-6 AT ROW 5.29 COL 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126.6 BY 18.29.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW MainWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "NORCALC - Nor-Produkter AS"
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 18.19
         WIDTH              = 126.6
         MAX-HEIGHT         = 20.57
         MAX-WIDTH          = 127.2
         VIRTUAL-HEIGHT     = 20.57
         VIRTUAL-WIDTH      = 127.2
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT MainWindow:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT MainWindow:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW MainWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       FRAME DEFAULT-FRAME:PRIVATE-DATA     = 
                "Main-Frame".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(MainWindow)
THEN MainWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME MainWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MainWindow MainWindow
ON END-ERROR OF MainWindow /* NORCALC - Nor-Produkter AS */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MainWindow MainWindow
ON WINDOW-CLOSE OF MainWindow /* NORCALC - Nor-Produkter AS */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt MainWindow
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
     RUN exit_procedure.
    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Batteriml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Batteriml MainWindow
ON CHOOSE OF MENU-ITEM m_Batteriml /* Batterimål... */
DO:
  pointer = SESSION:SET-WAIT-STATE("GENERAL").
  RUN AGBATMAL.W  PERSISTENT  SET p-handle
    (INPUT MainWindow:TITLE ) NO-ERROR.
  RUN appl_ent IN p-handle.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_FMGrupper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_FMGrupper MainWindow
ON CHOOSE OF MENU-ITEM m_FMGrupper /* FM */
DO:
  pointer =  SESSION:SET-WAIT-STATE("GENERAL").
  RUN SHFMGR.W.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_FMKvs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_FMKvs MainWindow
ON CHOOSE OF MENU-ITEM m_FMKvs /* FM */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN SHFMKVS.W.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Forstillingsorgan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Forstillingsorgan MainWindow
ON CHOOSE OF MENU-ITEM m_Forstillingsorgan /* Forstillingsorgan... */
DO:
  pointer =  SESSION:SET-WAIT-STATE("GENERAL").
  RUN SHFORST.W.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kabinettml
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kabinettml MainWindow
ON CHOOSE OF MENU-ITEM m_Kabinettml /* Kabinettmål... */
DO:
  pointer = SESSION:SET-WAIT-STATE("GENERAL").
  RUN AGKABMAL.W  PERSISTENT  SET p-handle
    (INPUT MainWindow:TITLE ) NO-ERROR.
  RUN appl_ent IN p-handle.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kontaktpersoner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kontaktpersoner MainWindow
ON CHOOSE OF MENU-ITEM m_Kontaktpersoner /* Kontaktpersoner... */
DO:
  pointer =  SESSION:SET-WAIT-STATE("GENERAL").
  RUN KONTAKT.W.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kunderegister
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kunderegister MainWindow
ON CHOOSE OF MENU-ITEM m_Kunderegister /* Kunderegister */
DO:
  pointer = SESSION:SET-WAIT-STATE("GENERAL").
  RUN KUNDEKRT.W  PERSISTENT  SET p-handle
    (INPUT MainWindow:TITLE ) NO-ERROR.
  RUN appl_ent IN p-handle.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_MSGrupper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_MSGrupper MainWindow
ON CHOOSE OF MENU-ITEM m_MSGrupper /* MS */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN SHMSGR.W.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_MSKvs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_MSKvs MainWindow
ON CHOOSE OF MENU-ITEM m_MSKvs /* MS */
DO:
  pointer = SESSION:SET-WAIT-STATE("GENERAL").
  RUN SHMSKVS.W  PERSISTENT  SET p-handle
    (INPUT MainWindow:TITLE ) NO-ERROR.
  RUN appl_ent IN p-handle.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Plukkliste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Plukkliste MainWindow
ON CHOOSE OF MENU-ITEM m_Plukkliste /* Plukkliste... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN PLUKKLST.W PERSISTENT (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Prosjekter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Prosjekter MainWindow
ON CHOOSE OF MENU-ITEM m_Prosjekter /* Prosjekt */
DO:
   pointer = SESSION:SET-WAIT-STATE("GENERAL").
/*  RUN SHUANLEG.W  PERSISTENT  SET p-handle
    (INPUT MainWindow:TITLE ) NO-ERROR.*/
  JBoxSession:Instance:AppTitle = MainWindow:TITLE.
  RUN PROSJEKT.W  PERSISTENT  SET p-handle NO-ERROR.
  RUN appl_ent IN p-handle.
      /* Sjekk om shunt-systemer allerede er startet */
/* RUN check-redundant.
    IF NOT lanlegg-redundant THEN
        DO:
            RUN SHUMENY.W PERSISTENT SET p-handle (INPUT MainWindow:TITLE)  NO-ERROR.
            RUN appl_ent IN p-handle.
        END.
    ELSE DO:
        BELL.
        MESSAGE 'Shuntsystemer er allerede startet.'  VIEW-AS ALERT-BOX TITLE 'Oppstartfeil'. 
    END.
   */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Rapporter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Rapporter MainWindow
ON CHOOSE OF MENU-ITEM m_Rapporter /* Rapporter */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN RAPPORT.W.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Spirovent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Spirovent MainWindow
ON CHOOSE OF MENU-ITEM m_Spirovent /* Spirovent... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN SPVARE.W. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbudsnr_aggregater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbudsnr_aggregater MainWindow
ON CHOOSE OF MENU-ITEM m_Tilbudsnr_aggregater /* Tilbudsnr aggregater */
DO:
  RUN FIXAGID.W.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbudsnr_shunter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbudsnr_shunter MainWindow
ON CHOOSE OF MENU-ITEM m_Tilbudsnr_shunter /* Tilbudsnr shunter */
DO:
  RUN FIXSHID.W.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbudsnr_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbudsnr_spiro MainWindow
ON CHOOSE OF MENU-ITEM m_Tilbudsnr_spiro /* Tilbudsnr spiro */
DO:
  RUN FIXSPID.W.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Typedefinisjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Typedefinisjon MainWindow
ON CHOOSE OF MENU-ITEM m_Typedefinisjon /* Typedefinisjon... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN AGTYPE.W. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Utskrift_konsulenter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Utskrift_konsulenter MainWindow
ON CHOOSE OF MENU-ITEM m_Utskrift_konsulenter /* Utskrift konsulenter */
DO:
   def var hTmp as handle no-undo.
    MESSAGE 'Denne utskriften er disablet intil videre' VIEW-AS ALERT-BOX TITLE 'Stopp'.
    
/*    run wNPSPTilbud.w persistent set hTmp.                                      */
/*    run initializeObject in hTmp.                                               */
/*                                                                                */
/*    dynamic-function('setBaseQuery' in hTmp,'WHERE tilbudsnr = "16.11.4842.1"').*/
/*                                                                                */
/*    run printPDFreport in hTmp.                                                 */
/*                                                                                */
/*    apply 'close' to hTmp.                                                      */
    RETURN NO-APPLY.

/*    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    
    MESSAGE 'Vil du ha utskrift av konsulenter?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Konsulentliste'  UPDATE svar.
    IF svar THEN
            RUN aderb/_printrb.p
           ("report\norshunt.prl",
             "Konsulenter",
            "-db norcalc -H 10.11.0.22 -S 4000 -U norcalc -P norcalc123",              
            "O", 
            "",
            "",
             "",
            "",
             "",
            "",
             1,
            1,
             9999,
            no,
             "Konsulentliste",
            yes,
             yes,
            no,
             "").        
*/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Vareliste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Vareliste MainWindow
ON CHOOSE OF MENU-ITEM m_Vareliste /* Vareliste... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN RAAVARERB.W PERSISTENT (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ventiltyper_-_MS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ventiltyper_-_MS MainWindow
ON CHOOSE OF MENU-ITEM m_Ventiltyper_-_MS /* Ventiltyper - MS */
DO:
  pointer =  SESSION:SET-WAIT-STATE("GENERAL").
  RUN SHVTYPE.W.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Vifter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Vifter MainWindow
ON CHOOSE OF MENU-ITEM m_Vifter /* Vifter... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    RUN AGVIFTER.W. 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Vis_printeroppsett
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Vis_printeroppsett MainWindow
ON VALUE-CHANGED OF MENU-ITEM m_Vis_printeroppsett /* Vis printeroppsett */
DO:
  /*Benyttes for å få fram utskrifts box når en velger vis-printeroppsett
    Sjekk utskrifts valgene*/

  h = session:first-procedure.
  h:private-data = if self:checked then '?' else ''.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK MainWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
   RUN disable_UI.
//   quit.
 END.
/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
 
   DYNAMIC-FUNCTION("DoLockWindow",this-procedure:CURRENT-WINDOW).

   THIS-PROCEDURE:CURRENT-WINDOW:X = JBoxSession:Instance:WindowX.
   THIS-PROCEDURE:CURRENT-WINDOW:Y = JBoxSession:Instance:WindowY.
  
   RUN MoveToTop.
   APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
   SESSION:SET-WAIT-STATE("").
     
   RUN enable_UI.
   if JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1') = '' then
    MESSAGE 'JBoxGenCode tabellen må ha en verdi for ConnectRB ["ProdDB","Misc1 - verdi"]'
    VIEW-AS ALERT-BOX.
  
  RUN dummy.p PERSISTENT SET h.
  h = session:first-procedure.
  h:private-data =''.

  /*Blanker privat-data da ? benyttes for å vise utskriftsbox*/
  
/*  //RUN JBoxLoadLib.p ("ResizeLib.p,JBoxASlib.p,JBoxUIlib.p,JBoxFUlib.p" + (IF SEARCH("controls.dll") NE ? THEN ",controls.p" ELSE "")).*/
/*                                                                                                                                        */
/*  /*** Direkte innlogging */                                                                                                            */
/*  def var hAppService as handle no-undo.                                                                                                */
/*  def var icLanguages as char no-undo.                                                                                                  */
/*  def var icAppTitle as char no-undo.                                                                                                   */
/*  def var icBaseLanguage as char no-undo.                                                                                               */
/*  def var cUserID     as char init "norcalc" no-undo.                                                                                   */
/*  def var ocSessionId as char no-undo.                                                                                                  */
/*  def var ocASusername as char no-undo.                                                                                                 */
/*  def var oiCompanyId  as int no-undo.                                                                                                  */
/*  def var bOKUser as log no-undo.                                                                                                       */
/*                                                                                                                                        */
/*  DYNAMIC-FUNCTION("setLanguages",icLanguages).                                                                                         */
/*  DYNAMIC-FUNCTION("setAppTitle",icAppTitle).                                                                                           */
/*  DYNAMIC-FUNCTION("setBaseLanguageCode",icBaseLanguage).                                                                               */
/*                                                                                                                                        */
/*  DYNAMIC-FUNCTION("NewObject",SESSION,SESSION,"session").                                                                              */
/*/*  hAppservice = DYNAMIC-FUNCTION("getAppserviceHandle").*/                                                                            */
/*/*  IF VALID-HANDLE(hAppservice) THEN                     */                                                                            */
/*                                                                                                                                        */
/*  RUN jbserv_validateuser.p (cUserID,CHR(3),                                                                                            */
/*                               SESSION:DATE-FORMAT,                                                                                     */
/*                               SESSION:NUMERIC-FORMAT,                                                                                  */
/*                               OUTPUT ocSessionId,                                                                                      */
/*                               OUTPUT ocASuserName,                                                                                     */
/*                               OUTPUT oiCompanyId,                                                                                      */
/*                               OUTPUT bOkUser).                                                                                         */
/*                                                                                                                                        */
/*  DYNAMIC-FUNCTION("setSessionId",ocSessionId).                                                                                         */
/*  DYNAMIC-FUNCTION("setASUserId",cUserID,ocASuserName).                                                                                 */
/*  DYNAMIC-FUNCTION("setLanguageCode","NO").                                                                                             */
/*                                                                                                                                        */
/*  IF oiCompanyId NE 0 THEN                                                                                                              */
/*    DYNAMIC-FUNCTION("setCompanyId",oiCompanyId).                                                                                       */
/*  ELSE                                                                                                                                  */
/*    DYNAMIC-FUNCTION("getFunctionRestrictions").                                                                                        */
/*                                                                                                                                        */
/*/*** Direkte innlogging slutt */                                                                                                        */
/*                                                                                                                                        */
/*/*Sjekk devmode.i og custdevmode.i*/                                                                                                    */
/*  DYNAMIC-FUNCTION("setBehaviour",                                                                                                      */
/*                    "DefaultSortFont|6," +                                                                                              */
/*                    "DefaultSortColor|15," +                                                                                            */
/*                    "BrowseSearchDefault|goto," +   /* alt: match */                                                                    */
/*                    "TabOnReturn|yes," +                                                                                                */
/*                    "SetSortLabel|yes"                                                                                                  */
/*                    ).                                                                                                                  */
/*                                                                                                                                        */
/*  DYNAMIC-FUNCTION("NewObject",SESSION,SESSION,"session").                                                                              */
/*                                                                                                                                        */
/*  DYNAMIC-FUNCTION("setAttribute",SESSION,"useAdvGui","yes").                                                                           */
/*  DYNAMIC-FUNCTION("setAttribute",SESSION,"btnGroupEditDetails","new,edit,copy,undo,save,delete").                                      */
/*  DYNAMIC-FUNCTION("setAttribute",SESSION,"tbEditBrowse","new,copy,delete").                                                            */
/*  DYNAMIC-FUNCTION("setAttribute",SESSION,"btnGroupNavBrowse","filter,browseconfig,excel").                                             */
/*                                                                                                                                        */
/*  DYNAMIC-FUNCTION("getSessionData").                                                                                                   */
/*                                                                                                                                        */
/*  /* Reserved color name for shading browse rows: */                                                                                    */
/*  DYNAMIC-FUNCTION("AddColor","RowShade",240,240,240).                                                                                  */
/*  /* Other colors added this way are available as session attributes: "Color_"<your name> */                                            */
/*                                                                                                                                        */
/*  DYNAMIC-FUNCTION("setAttribute",SESSION,"shadedRows","yes").                                                                          */
/*  DYNAMIC-FUNCTION("setAttribute",SESSION,"btnPanelHeight","small").                                                                    */
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR System.Windows.Forms.Application:Run().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE check-redundant MainWindow 
PROCEDURE check-redundant :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*DEFINE VARIABLE phand AS WIDGET-HANDLE.                          */
/*DEFINE VARIABLE nhand AS WIDGET-HANDLE.                          */
/*                                                                 */
/*phand = SESSION:FIRST-PROCEDURE.                                 */
/*DO WHILE VALID-HANDLE(phand):                                    */
/*    nhand = phand:NEXT-SIBLING.                                  */
/*    IF LOOKUP(MainWindow:TITLE, phand:PRIVATE-DATA) > 0  THEN DO:*/
/*        lanlegg-redundant = TRUE.                                */
/*        RETURN.                                                  */
/*    END.                                                         */
/*    phand = nhand.                                               */
/*END.                                                             */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI MainWindow  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(MainWindow)
  THEN DELETE WIDGET MainWindow.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI MainWindow  _DEFAULT-ENABLE
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
  ENABLE IMAGE-1 NORCALC RECT-6 
      WITH FRAME DEFAULT-FRAME IN WINDOW MainWindow.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE exit_procedure MainWindow 
PROCEDURE exit_procedure :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE phand AS HANDLE.
  DEFINE VARIABLE nhand AS HANDLE.
  
  phand = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(phand):
      nhand = phand:NEXT-SIBLING.
      IF LOOKUP(MainWindow:TITLE, phand:PRIVATE-DATA) > 0 THEN 
              RUN destroy_window IN phand NO-ERROR.
          phand = nhand.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop MainWindow 
PROCEDURE MoveToTop :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  THIS-PROCEDURE:CURRENT-WINDOW:HIDDEN = NO.
  IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
    RUN ShowForm("").
  THIS-PROCEDURE:CURRENT-WINDOW:WINDOW-STATE = 3.
  THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
  DYNAMIC-FUNCTION("DoLockWindow",?).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

