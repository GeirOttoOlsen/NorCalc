&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME System-Window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS System-Window 
/*---------------------------------------------
  File: NAVREADI.W 
  Description: Simple template with button
     images for a Read-only navigation 
     window containing fields from one or more 
     tables and/or a field browser.
 
 
  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Created: 02/19/94 -  1:00 pm

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
/*DEFINE INPUT PARAMETER appdata AS CHARACTER.                  */
/*DEFINE SHARED VARIABLE anleggsnrParam LIKE NPSHANLG.anleggsnr.*/
/*DEFINE NEW SHARED VARIABLE Current-Rec as ROWID.              */
/* DEFINE NEW SHARED VAR nyRecord AS LOGICAL INITIAL FALSE.     */
/*DEFINE NEW SHARED VAR Current-Syst-Rec AS ROWID.              */
/*DEFINE NEW SHARED VARIABLE systemnrParam LIKE NPSHSYST.systemnr.*/
/*DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.    */
/*DEFINE INPUT-OUTPUT PARAMETER returShunt AS LOGICAL.*/

def var current-rec as rowid.
def var nyRecord as log.
DEFINE VAR editModus AS INTEGER.

def var anleggsnrParam like npshanlg.anleggsnr.
def var systemnrParam like npshsyst.systemnr.
def var anleggsnavnparam like npshanlg.anlegg.
def var hParent as handle no-undo.

DEFINE VAR valgtKobling AS CHAR.
/*DEFINE VARIABLE dimm_verdi LIKE NPSHFMGR.storrelse.*/
DEFINE VARIABLE dimm_verdi as char no-undo.
DEFINE VAR tegningBmp AS CHAR. 
DEFINE VAR tegningOK AS LOGICAL.
DEFINE VAR syst# LIKE NPSHSYST.systemnr.
DEFINE VAR c_anvendelse AS CHARACTER.
c_anvendelse = 'VK'.

DEFINE VAR Detail-Handle AS HANDLE.
 DEFINE VARIABLE stat AS LOGICAL.      /* Status return from methods */
 DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL.  
DEFINE VAR systemRow AS LOGICAL.
/*DEFINE NEW SHARED TEMP-TABLE tempSystem LIKE NPSHSYST.*/
def temp-table tempSystem like npshsyst.

/* Local Variable Definitions ---                                       */

   DEFINE VARIABLE dbop-supported AS LOGICAL.
   DEFINE VARIABLE dbop-db-name AS CHARACTER.
   DEFINE VARIABLE dbop-tbl-name AS CHARACTER.
   DEFINE VARIABLE nav-stat AS LOGICAL.
   DEFINE VARIABLE browser-handle AS HANDLE.

def var hMainMenu as handle no-undo. /*dummy handle*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Browser-Frame
&Scoped-define BROWSE-NAME System-Browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHSYST NPSHKOBL

/* Definitions for BROWSE System-Browse                                 */
&Scoped-define FIELDS-IN-QUERY-System-Browse NPSHSYST.systembetegnelse ~
NPSHSYST.koblings_alternativ NPSHKOBL.betegnelse NPSHSYST.standardpris ~
NPSHSYST.systemnr NPSHSYST.med_i_ordre NPSHSYST.sek_hastighet ~
NPSHSYST.prim_hastighet 
&Scoped-define ENABLED-FIELDS-IN-QUERY-System-Browse NPSHSYST.systemnr ~
NPSHSYST.med_i_ordre 
&Scoped-define ENABLED-TABLES-IN-QUERY-System-Browse NPSHSYST
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-System-Browse NPSHSYST
&Scoped-define QUERY-STRING-System-Browse FOR EACH NPSHSYST ~
      WHERE NPSHSYST.anleggsnr = anleggsnrParam NO-LOCK, ~
      EACH NPSHKOBL WHERE NPSHKOBL.koblingsalternativ = NPSHSYST.koblings_alternativ NO-LOCK ~
    BY NPSHSYST.anleggsnr ~
       BY NPSHSYST.systemnr
&Scoped-define OPEN-QUERY-System-Browse OPEN QUERY System-Browse FOR EACH NPSHSYST ~
      WHERE NPSHSYST.anleggsnr = anleggsnrParam NO-LOCK, ~
      EACH NPSHKOBL WHERE NPSHKOBL.koblingsalternativ = NPSHSYST.koblings_alternativ NO-LOCK ~
    BY NPSHSYST.anleggsnr ~
       BY NPSHSYST.systemnr.
&Scoped-define TABLES-IN-QUERY-System-Browse NPSHSYST NPSHKOBL
&Scoped-define FIRST-TABLE-IN-QUERY-System-Browse NPSHSYST
&Scoped-define SECOND-TABLE-IN-QUERY-System-Browse NPSHKOBL


/* Definitions for FRAME Browser-Frame                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Browser-Frame ~
    ~{&OPEN-QUERY-System-Browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS System-Browse 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRec System-Window 
FUNCTION getCurrentRec RETURNS ROWID
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEditModus System-Window 
FUNCTION getEditModus RETURNS integer
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNyRecord System-Window 
FUNCTION getNyRecord RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentRec System-Window 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR System-Window AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_System 
       MENU-ITEM m_Nytt         LABEL "&Nytt..."       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre..."      ACCELERATOR "CTRL-E"
       MENU-ITEM m_Slette       LABEL "&Slette..."     ACCELERATOR "CTRL-S"
       MENU-ITEM m_Kopiere      LABEL "Kopiere"       
       MENU-ITEM m_Shuntpris    LABEL "Shunt&pris..." .

DEFINE SUB-MENU m_Utskrifter 
       MENU-ITEM m_Utskrift_saksmappe LABEL "&Utskrift til Saksmappe"
       MENU-ITEM m_etiketter_fullt_ark LABEL "Etiketter - &fullt ark"
       MENU-ITEM m_Etiketter_-_start_2_rad LABEL "Etiketter - start &2. rad"
       MENU-ITEM m_Etiketter_-_start_3_rad LABEL "Etiketter - start &3. rad"
       MENU-ITEM m_Etiketter_-_start_4_rad LABEL "Etiketter - start &4. rad".

DEFINE MENU MENU-BAR-System-Window MENUBAR
       SUB-MENU  m_System       LABEL "&System"       
       MENU-ITEM m_Beregninger  LABEL "&Beregninger"  
       MENU-ITEM m_Tilbehr      LABEL "Tilbe&hør"     
       SUB-MENU  m_Utskrifter   LABEL "&Utskrifter"   
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE lblType AS CHARACTER FORMAT "X(256)":U INITIAL "Ventil:" 
      VIEW-AS TEXT 
     SIZE 10 BY .62 NO-UNDO.

DEFINE IMAGE SHUNTTEGNING
     FILENAME "bmp\kobling1":U
     SIZE 29 BY 9.95.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 51.6 BY 6.38.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 32 BY 10.24.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY System-Browse FOR 
      NPSHSYST, 
      NPSHKOBL SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE System-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS System-Browse System-Window _STRUCTURED
  QUERY System-Browse NO-LOCK DISPLAY
      NPSHSYST.systembetegnelse FORMAT "X(35)":U
      NPSHSYST.koblings_alternativ FORMAT "X(2)":U
      NPSHKOBL.betegnelse FORMAT "X(25)":U
      NPSHSYST.standardpris FORMAT ">>,>>>,>>9.99":U
      NPSHSYST.systemnr FORMAT ">>>>>9":U
      NPSHSYST.med_i_ordre COLUMN-LABEL "Til Ordre" FORMAT "ja/nei":U
            COLUMN-FGCOLOR 2 LABEL-FGCOLOR 2
      NPSHSYST.sek_hastighet FORMAT ">>9.999999":U
      NPSHSYST.prim_hastighet FORMAT ">>9.999999":U
  ENABLE
      NPSHSYST.systemnr
      NPSHSYST.med_i_ordre
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 126 BY 4.52
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Detalj-Frame
     NPSHSYST.beregnet_anvendelse AT ROW 1.62 COL 57.4 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Varme", "Varme":U,
"Lavtemperatur", "Lavtemperatur":U,
"Lavtemp/Kaldt medium", "Lavtemp/Kaldt medium":U,
"Kjøle", "Kjøle":U,
"Fryse", "Fryse":U,
"Varmegjenvinning", "Varmegjenvinning":U
          SIZE 33.6 BY 6.38
     NPSHSYST.prim_effekt AT ROW 2 COL 16.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.sek_effekt AT ROW 2 COL 31.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.prim_temp_inn AT ROW 3.33 COL 16.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.sek_temp_inn AT ROW 3.33 COL 31.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.prim_temp_ut AT ROW 4.71 COL 16.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.sek_temp_ut AT ROW 4.71 COL 31.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 11.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.prim_kapasitet AT ROW 6.05 COL 16.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.sek_kapasitet AT ROW 6.05 COL 31.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 12.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.type AT ROW 8.38 COL 24 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "FM", "FM":U,
"MS", "MS":U
          SIZE 30.8 BY 1.24
          BGCOLOR 8 FGCOLOR 0 
     NPSHSYST.system_kode AT ROW 11.95 COL 2 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 128 BY 3.57
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHSYST.shunt_dimmensjon AT ROW 8.67 COL 77.2 COLON-ALIGNED
          LABEL "Shuntdimmensjon"
           VIEW-AS TEXT 
          SIZE 10.6 BY .76
          BGCOLOR 8 FGCOLOR 1 FONT 2
     lblType AT ROW 8.71 COL 9.4 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     NPSHSYST.ms_ventiltype AT ROW 10.05 COL 21 COLON-ALIGNED
          LABEL "MS-Ventiltype"
           VIEW-AS TEXT 
          SIZE 30 BY .76
          FGCOLOR 1 FONT 2
     "°C" VIEW-AS TEXT
          SIZE 3.6 BY .81 AT ROW 3.57 COL 47.8
     "l/s" VIEW-AS TEXT
          SIZE 5.6 BY .76 AT ROW 6.43 COL 47.6
     " Primær" VIEW-AS TEXT
          SIZE 11.2 BY .81 AT ROW 1.48 COL 19.2
     "°C" VIEW-AS TEXT
          SIZE 3.6 BY .81 AT ROW 5.1 COL 47.4
     " Sekundær" VIEW-AS TEXT
          SIZE 14.2 BY .81 AT ROW 1.48 COL 34.2
     "W" VIEW-AS TEXT
          SIZE 4 BY .81 AT ROW 2.33 COL 47.8
     SHUNTTEGNING AT ROW 1.71 COL 94
     RECT-19 AT ROW 1 COL 3
     RECT-21 AT ROW 1.48 COL 93
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 6.33
         SIZE 130.2 BY 14.86
         FONT 2.

DEFINE FRAME Browser-Frame
     System-Browse AT ROW 1.24 COL 2.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 130.2 BY 4.95.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW System-Window ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 20.19
         WIDTH              = 130.2
         MAX-HEIGHT         = 22.48
         MAX-WIDTH          = 130.2
         VIRTUAL-HEIGHT     = 22.48
         VIRTUAL-WIDTH      = 130.2
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-System-Window:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT System-Window:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT System-Window:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW System-Window
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME Browser-Frame
   FRAME-NAME UNDERLINE                                                 */
/* BROWSE-TAB System-Browse 1 Browser-Frame */
/* SETTINGS FOR FRAME Detalj-Frame
                                                                        */
/* SETTINGS FOR RADIO-SET NPSHSYST.beregnet_anvendelse IN FRAME Detalj-Frame
   NO-ENABLE                                                            */
ASSIGN 
       lblType:READ-ONLY IN FRAME Detalj-Frame        = TRUE
       lblType:PRIVATE-DATA IN FRAME Detalj-Frame     = 
                "Ventil:".

/* SETTINGS FOR FILL-IN NPSHSYST.ms_ventiltype IN FRAME Detalj-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.prim_effekt IN FRAME Detalj-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.prim_kapasitet IN FRAME Detalj-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.prim_temp_inn IN FRAME Detalj-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.prim_temp_ut IN FRAME Detalj-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_effekt IN FRAME Detalj-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_kapasitet IN FRAME Detalj-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_inn IN FRAME Detalj-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR FILL-IN NPSHSYST.sek_temp_ut IN FRAME Detalj-Frame
   NO-ENABLE EXP-LABEL                                                  */
/* SETTINGS FOR IMAGE SHUNTTEGNING IN FRAME Detalj-Frame
   NO-ENABLE                                                            */
ASSIGN 
       SHUNTTEGNING:SELECTABLE IN FRAME Detalj-Frame       = TRUE.

/* SETTINGS FOR FILL-IN NPSHSYST.shunt_dimmensjon IN FRAME Detalj-Frame
   NO-ENABLE EXP-LABEL                                                  */
ASSIGN 
       NPSHSYST.system_kode:READ-ONLY IN FRAME Detalj-Frame        = TRUE.

/* SETTINGS FOR RADIO-SET NPSHSYST.type IN FRAME Detalj-Frame
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(System-Window)
THEN System-Window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE System-Browse
/* Query rebuild information for BROWSE System-Browse
     _TblList          = "norcalc.NPSHSYST,norcalc.NPSHKOBL WHERE norcalc.NPSHSYST ..."
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPSHSYST.anleggsnr|yes,norcalc.NPSHSYST.systemnr|yes"
     _Where[1]         = "NPSHSYST.anleggsnr = anleggsnrParam"
     _JoinCode[2]      = "NPSHKOBL.koblingsalternativ = NPSHSYST.koblings_alternativ"
     _FldNameList[1]   > norcalc.NPSHSYST.systembetegnelse
"NPSHSYST.systembetegnelse" ? "X(35)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   = norcalc.NPSHSYST.koblings_alternativ
     _FldNameList[3]   = norcalc.NPSHKOBL.betegnelse
     _FldNameList[4]   = norcalc.NPSHSYST.standardpris
     _FldNameList[5]   > norcalc.NPSHSYST.systemnr
"NPSHSYST.systemnr" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > norcalc.NPSHSYST.med_i_ordre
"NPSHSYST.med_i_ordre" "Til Ordre" ? "logical" ? 2 ? ? 2 ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   = norcalc.NPSHSYST.sek_hastighet
     _FldNameList[8]   = norcalc.NPSHSYST.prim_hastighet
     _Query            is OPENED
*/  /* BROWSE System-Browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME System-Window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Window System-Window
ON HELP OF System-Window
DO:
  MESSAGE "This basic navigation window can be used to browse through " +
      "record in one or more tables. Lay out database fields onto " +
      "the frame. You may also add a browser for a table which is " +
      "joinable to the first." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt System-Window
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:  
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Beregninger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Beregninger System-Window
ON CHOOSE OF MENU-ITEM m_Beregninger /* Beregninger */
DO:
  /* Ingen endringer kan gj›res dersom det er gitt tilbud */
    /* Er endringsl†s opphevet */
    DEFINE VAR laast AS LOGICAL.
        
    SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        editModus = 0.
     ELSE
        editModus = 1.
/*    JBoxRelation:instance:addParameter(this-procedure, 'editModus', string(editModus)).*/
    /* Fyr av rett beregningsvindu */
    SESSION:SET-WAIT-STATE("GENERAL").
    valgtKobling = NPSHSYST.koblings_alternativ.
    systemnrParam = NPSHSYST.systemnr.
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA + "," + STRING(NPSHSYST.anleggsnr).
   CASE valgtKobling:
        WHEN '1' THEN
            RUN SHUBERK1.W.
        WHEN '2' THEN
            RUN SHUBERK2.W. 
        WHEN '3' THEN
            RUN SHUBERK3.W. 
        WHEN '4' THEN
            RUN SHUBERK4.W.
        WHEN '5' THEN
            RUN SHUBERK5.W.
        WHEN '6' THEN
            RUN SHUBERK6.W.
        WHEN '7' THEN
           RUN SHUBERK7.W.
        WHEN '7A' THEN
            RUN SHUBER7A.W. 
    END CASE.        
     APPLY 'VALUE-CHANGED' TO System-Browse IN FRAME BROWSER-FRAME.
    RUN visSystemKode. 

    APPLY "GO" TO FRAME Browser-Frame.
   MENU-ITEM m_Tilbehr:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre System-Window
ON CHOOSE OF MENU-ITEM m_Endre /* Endre... */
DO:
      
    SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data + "," + STRING(anleggsnrParam).
    Current-Rec = ROWID(NPSHSYST).
    RUN SHENDSYS.W.
    RUN prc_referanse.
    {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
    REPOSITION System-Browse TO ROWID(Current-Rec).
     APPLY 'VALUE-CHANGED' TO System-Browse
           IN FRAME BROWSER-FRAME.
    APPLY "GO" TO FRAME Browser-Frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Etiketter_-_start_2_rad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Etiketter_-_start_2_rad System-Window
ON CHOOSE OF MENU-ITEM m_Etiketter_-_start_2_rad /* Etiketter - start 2. rad */
DO:
    /* Skriv shuntetiketter */
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shuntetiketter-2",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSHSYST.anleggsnr = " + string(anleggsnrParam),
        "",
        "",
        "?",
        "",
        "",
        0,
        0,
        0,
        no,
        "Shuntetiketter",
        yes,
        yes,
        no,
        "").        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Etiketter_-_start_3_rad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Etiketter_-_start_3_rad System-Window
ON CHOOSE OF MENU-ITEM m_Etiketter_-_start_3_rad /* Etiketter - start 3. rad */
DO:
    /* Skriv shuntetiketter */
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shuntetiketter-3",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSHSYST.anleggsnr = " + string(anleggsnrParam),
        "",
        "",
        "?",
        "",
        "",
        0,
        0,
        0,
        no,
        "Shuntetiketter",
        yes,
        yes,
        no,
        "").        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Etiketter_-_start_4_rad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Etiketter_-_start_4_rad System-Window
ON CHOOSE OF MENU-ITEM m_Etiketter_-_start_4_rad /* Etiketter - start 4. rad */
DO:
    /* Skriv shuntetiketter */
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shuntetiketter-4",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSHSYST.anleggsnr = " + string(anleggsnrParam),
        "",
        "",
        "?",
        "",
        "",
        0,
        0,
        0,
        no,
        "Shuntetiketter",
        yes,
        yes,
        no,
        "").        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_etiketter_fullt_ark
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_etiketter_fullt_ark System-Window
ON CHOOSE OF MENU-ITEM m_etiketter_fullt_ark /* Etiketter - fullt ark */
DO:
    /* Skriv shuntetiketter */
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shuntetiketter",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSHSYST.anleggsnr = " + string(anleggsnrParam),
        "",
         "",
        ?,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shuntetiketter",
        yes,
        yes,
        no,
        "").        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kopiere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kopiere System-Window
ON CHOOSE OF MENU-ITEM m_Kopiere /* Kopiere */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal det ikke kunne legges inn nye system */
 FIND FIRST NPSHTILBUD WHERE NPSHTILBUD.anleggsnr = anleggsnrParam NO-ERROR.
 IF AVAILABLE NPSHTILBUD THEN
    DO:
        MESSAGE 'Det er gitt tilbud på dette anlegget. Nye system kan ikke registreres!'  VIEW-AS ALERT-BOX TITLE 'FEIL'.
        RETURN NO-APPLY.
    END.
ELSE
    DO:
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
         RUN kopiere_system_til_temp.
        RUN kopiere_system_fra_temp. 
         /* Åpne browser og reset row pointer */
         {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
           REPOSITION System-Browse TO ROWID(Current-Rec).
          APPLY 'VALUE-CHANGED' TO System-Browse
              IN FRAME BROWSER-FRAME.
        pointer =  SESSION:SET-WAIT-STATE("").
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt System-Window
ON CHOOSE OF MENU-ITEM m_Nytt /* Nytt... */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal det ikke kunne legges inn nye system */
  /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN DO:
      MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
      RETURN NO-APPLY.
    END.
   ELSE DO:
    current-rec = ?.
    nyRecord = true.
    dynamic-function('setAttribute',this-procedure,'anleggsnrParam',anleggsNrParam).
    dynamic-function('setAttribute',this-procedure,'anleggsnavnParam',anleggsNavnParam).
    SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA + "," + STRING(anleggsnrParam).
    RUN SHNYTSYS.w.
    IF current-rec ne ? THEN DO:
        RUN prc_referanse.
        {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
        REPOSITION System-Browse TO ROWID(Current-Rec).
        APPLY 'VALUE-CHANGED' TO System-Browse IN FRAME BROWSER-FRAME.
        MENU-ITEM m_Beregninger:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = YES.
        MENU-ITEM m_Endre:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = YES.
        MENU-ITEM m_Slette:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = YES.
    END.
    APPLY "GO" TO FRAME Browser-Frame.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Shuntpris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Shuntpris System-Window
ON CHOOSE OF MENU-ITEM m_Shuntpris /* Shuntpris... */
DO:
   Current-Rec = ROWID(NPSHSYST).
   RUN shupris.w.
    {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
    REPOSITION System-Browse TO ROWID(Current-Rec).
     APPLY 'VALUE-CHANGED' TO System-Browse
           IN FRAME BROWSER-FRAME.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette System-Window
ON CHOOSE OF MENU-ITEM m_Slette /* Slette... */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal ikke enkeltsystem kunne slettes */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.

ELSE
    DO:
    DEFINE VAR cur_rec AS ROWID.
    
      MESSAGE "Vil du slette dette systemet?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = ROWID(NPSHSYST).
                FIND NPSHSYST WHERE ROWID(NPSHSYST)  = cur_rec  EXCLUSIVE-LOCK NO-WAIT
                    NO-ERROR.
                IF AVAILABLE(NPSHSYST) THEN
                    DELETE NPSHSYST.
                STATUS DEFAULT.
                pointer = SESSION:SET-WAIT-STATE("").
                RUN enable_UI.
                {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
                GET FIRST System-Browse.   
                IF AVAILABLE NPSHSYST THEN 
                    DO:
                        systemRow =  System-Browse:SELECT-ROW(1) IN FRAME Browser-Frame.
                        APPLY 'VALUE-CHANGED' TO System-Browse.
                    END.
                ELSE
                    DO:
                        MENU-ITEM m_Beregninger:SENSITIVE IN MENU 
                            MENU-BAR-SYSTEM-WINDOW = NO.
                        MENU-ITEM m_Tilbehr:SENSITIVE IN MENU 
                            MENU-BAR-SYSTEM-WINDOW = NO.
                        MENU-ITEM m_Endre:SENSITIVE IN MENU 
                            MENU-BAR-SYSTEM-WINDOW = NO.
                        MENU-ITEM m_Slette:SENSITIVE IN MENU 
                            MENU-BAR-SYSTEM-WINDOW = NO.
                   END.             
          END.
         WHEN FALSE THEN /* No */
          DO:
             MESSAGE "Sletting avbrutt."
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             RETURN NO-APPLY.
          END.
         END CASE.
    END.

/*        MENU-ITEM m_System:SENSITIVE IN MENU MENU-BAR-ANLEGGSBROWSER = NO.
        MENU-ITEM m_Forkalkyle:SENSITIVE IN MENU MENU-BAR-ANLEGGSBROWSER = NO.
        MENU-ITEM m_Etterkalkyle:SENSITIVE IN MENU MENU-BAR-ANLEGGSBROWSER = NO.
*/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbehr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbehr System-Window
ON CHOOSE OF MENU-ITEM m_Tilbehr /* Tilbehør */
DO:
  /* Ingen endringer kan gjøres dersom det er gitt tilbud */
    DEFINE VAR laast AS LOGICAL.
        
    SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        editModus = 0.
     ELSE
        editModus = 1.
    
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    systemnrParam = NPSHSYST.systemnr.
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA + "," + STRING(anleggsnrParam).
    RUN SHUTILLG.W .
    IF editModus = 1 THEN
        DO:     
            RUN visSystemKode.
            APPLY "GO" TO FRAME Browser-Frame.
        END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Utskrift_saksmappe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Utskrift_saksmappe System-Window
ON CHOOSE OF MENU-ITEM m_Utskrift_saksmappe /* Utskrift til Saksmappe */
DO:
    FIND NPSHANLG WHERE anleggsnr = anleggsnrParam NO-ERROR.
    IF NOT AVAILABLE NPSHANLG THEN
        MESSAGE 'Får ikke kontakt med anleggstabellen' VIEW-AS ALERT-BOX TITLE 'FEIL'.
    ELSE
    /* Skriv teknisk spesifikasjon */
    RUN aderb/_printrb.p
        ("report\norshtek.prl",
        "Tekn. spes. saksmappe",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSHANLG.anleggsnr = " + string(anleggsnrParam),
        "",
        "",
        hMainMenu:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Teknisk spesifikasjon til saksmappe",
        yes,
        yes,
        no,
        "").        
END.

/*   /* Skriv shuntetiketter */
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shuntetiketter",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSHSYST.anleggsnr = " + string(anleggsnrParam),
        "",
         "",
         hMainMenu:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shuntetiketter",
        yes,
        yes,
        no,
        "").        
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME System-Browse
&Scoped-define SELF-NAME System-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse System-Window
ON LEFT-MOUSE-CLICK OF System-Browse IN FRAME Browser-Frame
DO:
    APPLY 'VALUE-CHANGED' TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse System-Window
ON LEFT-MOUSE-DBLCLICK OF System-Browse IN FRAME Browser-Frame
DO:
  APPLY 'CHOOSE' TO MENU-ITEM m_Endre IN MENU MENU-BAR-System-Window.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse System-Window
ON VALUE-CHANGED OF System-Browse IN FRAME Browser-Frame
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal system ikke kunne endres */
    /* Er endringslås opphevet */
/*    Endret 21/8-97 slik at man kan se på system for låste anlegg */
    DEFINE VAR laast AS LOGICAL.  
    SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = NPSHSYST.anleggsnr.
    dynamic-function('setAttribute',this-procedure,'AnleggLaast',string(laast)).
      
    /* Vis systemdetaljer */
    IF AVAILABLE NPSHSYST THEN DO:
    Current-Rec = ROWID(NPSHSYST).
    
    AnleggsnrParam = NPSHSYST.anleggsnr.
    systemnrParam = NPSHSYST.systemnr.
    dynamic-function('setAttribute',this-procedure,'AnleggsNrParam',string(anleggsNrParam)).
    dynamic-function('setAttribute',this-procedure,'systemNrParam',string(systemNrParam)).
    DISPLAY 
        norcalc.NPSHSYST.prim_effekt norcalc.NPSHSYST.sek_effekt 
        norcalc.NPSHSYST.beregnet_anvendelse norcalc.NPSHSYST.prim_temp_inn 
        norcalc.NPSHSYST.sek_temp_inn norcalc.NPSHSYST.prim_temp_ut 
        norcalc.NPSHSYST.sek_temp_ut norcalc.NPSHSYST.prim_kapasitet 
        norcalc.NPSHSYST.sek_kapasitet norcalc.NPSHSYST.type 
        norcalc.NPSHSYST.ms_ventiltype
        norcalc.NPSHSYST.shunt_dimmensjon norcalc.NPSHSYST.system_kode 
      WITH FRAME Detalj-Frame IN WINDOW System-Window.

    /* Vis riktig tegning */
    CASE NPSHSYST.koblings_alternativ:
        WHEN '1' THEN
            tegningBmp = 'kobling1.bmp'.
        WHEN '2' THEN
            tegningBmp = 'kobling2.bmp'.
        WHEN '3' THEN
            tegningBmp = 'kobling3.bmp'.
        WHEN '4' THEN
            tegningBmp = 'kobling4.bmp'.
        WHEN '5' THEN
            tegningBmp = 'kobling5.bmp'.
        WHEN '6' THEN
            tegningBmp = 'kobling6.bmp'.
        WHEN '7' THEN
            tegningBmp = 'kobling7.bmp'.
        WHEN '7A' THEN
            tegningBmp = 'koblin7A.bmp'.
        WHEN 'xx' THEN
            tegningBmp = 'koblingx.bmp'.
    END CASE.
   tegningOK = SHUNTTEGNING:LOAD-IMAGE (tegningBmp,0,0,140,202).
   DISPLAY SHUNTTEGNING WITH FRAME Detalj-Frame.

/* Dersom beregninger er foretatt - gi tilbang til tilbehør, ellers ikke */

   MENU-ITEM m_Tilbehr:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NPSHSYST.kvs_hovedport > 0.

  /* Dersom det er gitt tilbud på dette anlegget skal systemene ikke kunne endres
      grå ut beregninger i menyen */
/* Utsettes inntil videre */
/* FIND FIRST NPSHTILBUD WHERE NPSHTILBUD.anleggsnr = anleggsnrParam NO-ERROR.
 IF AVAILABLE NPSHTILBUD THEN
    DO:
     MENU-ITEM m_Beregninger:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NO.
     MENU-ITEM m_Tilbehr:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NO.
    END.
ELSE 
    DO:
     MENU-ITEM m_Beregninger:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = YES.
     MENU-ITEM m_Tilbehr:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = YES.
    END.*/
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK System-Window 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  /* Clean up related Detail or Child windows if present. */
  IF VALID-HANDLE(Detail-Handle) THEN
    APPLY "CLOSE" TO Detail-Handle.
  RUN anleggsPris.
  RUN disable_UI.
END.

/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
  JBoxRelation:instance:Invalidate(this-procedure).
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.
ON ENDKEY, END-ERROR OF {&WINDOW-NAME} ANYWHERE DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

&IF "{&TABLES-IN-QUERY-{&FRAME-NAME}}" NE "" &THEN      /* Add table name to title */
  {&WINDOW-NAME}:TITLE = {&WINDOW-NAME}:TITLE + " for " +
    "{&TABLES-IN-QUERY-{&FRAME-NAME}}".
&ENDIF

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.
   pointer = SESSION:SET-WAIT-STATE("").

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  THIS-PROCEDURE:CURRENT-WINDOW:X = JBoxSession:Instance:WindowX + 30.
  THIS-PROCEDURE:CURRENT-WINDOW:Y = JBoxSession:Instance:WindowY + 30.
  DYNAMIC-FUNCTION("DoLockWindow",this-procedure:CURRENT-WINDOW).
  hParent = source-procedure.
  JBoxRelation:instance:addInvalidate(hParent,this-procedure).
  
  anleggsnrparam = int(dynamic-function('getAttribute',hParent,'anleggsnrParam')).
  anleggsnavnparam = dynamic-function('getAttribute',hParent,'anleggsnavnParam').
  System-Window:TITLE = 'Shuntsystem for anlegg: ' + anleggsNavnParam.
  RUN MoveToTop.
  APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
  SESSION:SET-WAIT-STATE("").

   RUN enable_UI.
   assign 
     NPSHSYST.type:RADIO-BUTTONS = replace(JBoxServerAPI:Instance:FieldList('NPSHGruppeType;NPSHGruppeTypeNavn;NPSHGruppeTypeNavn','where true'),'|',',')
     NPSHSYST.beregnet_anvendelse:delimiter = '|'
     NPSHSYST.beregnet_anvendelse:list-item-pairs = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropAnvendelse' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
     .
   hMainMenu = session:first-procedure.
   
   GET FIRST System-Browse.   
   IF AVAILABLE norcalc.NPSHSYST THEN 
       DO:
           systemRow =  System-Browse:SELECT-ROW(1) IN FRAME Browser-Frame.
           APPLY 'VALUE-CHANGED' TO System-Browse.
        END.   
   ELSE
        DO:
            MENU-ITEM m_Beregninger:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NO.
            MENU-ITEM m_Tilbehr:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NO.
            MENU-ITEM m_Endre:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NO.
            MENU-ITEM m_Slette:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NO.
        END.  

  /* Next line added to template to make sure fields are disabled in this
     read only template. */
  DISABLE {&FIELDS-IN-QUERY-{&FRAME-NAME}} WITH FRAME {&FRAME-NAME}.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anleggsPris System-Window 
PROCEDURE anleggsPris :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DEFINE VAR sumAnlegg AS DECIMAL.

  sumAnlegg = 0.
  FOR EACH NPSHSYST WHERE NPSHSYST.anleggsnr = anleggsnrParam NO-LOCK:
        sumAnlegg = sumAnlegg +  NPSHSYST.standardpris.
  END.
  FIND NPSHANLG WHERE NPSHANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK 
    NO-WAIT NO-ERROR.
  IF AVAILABLE NPSHANLG THEN
      ASSIGN NPSHANLG.standardpris = sumAnlegg.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent System-Window 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "ENTRY" TO NPSHSYST.system_kode IN FRAME Detalj-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI System-Window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(System-Window)
  THEN DELETE WIDGET System-Window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI System-Window  _DEFAULT-ENABLE
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
  ENABLE System-Browse 
      WITH FRAME Browser-Frame IN WINDOW System-Window.
  {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
  DISPLAY lblType 
      WITH FRAME Detalj-Frame IN WINDOW System-Window.
  IF AVAILABLE NPSHSYST THEN 
    DISPLAY NPSHSYST.beregnet_anvendelse NPSHSYST.prim_effekt NPSHSYST.sek_effekt 
          NPSHSYST.prim_temp_inn NPSHSYST.sek_temp_inn NPSHSYST.prim_temp_ut 
          NPSHSYST.sek_temp_ut NPSHSYST.prim_kapasitet NPSHSYST.sek_kapasitet 
          NPSHSYST.type NPSHSYST.system_kode NPSHSYST.shunt_dimmensjon 
          NPSHSYST.ms_ventiltype 
      WITH FRAME Detalj-Frame IN WINDOW System-Window.
  ENABLE RECT-19 RECT-21 NPSHSYST.system_kode lblType 
      WITH FRAME Detalj-Frame IN WINDOW System-Window.
  {&OPEN-BROWSERS-IN-QUERY-Detalj-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Hide_Win System-Window 
PROCEDURE Hide_Win :
/* -----------------------------------------------------------
  Purpose:     Hide current window 
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  {&WINDOW-NAME}:HIDDEN = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiereEttSystem System-Window 
PROCEDURE kopiereEttSystem :
/* -----------------------------------------------------------
  Purpose:     kopiere ett shuntsystem for dette anlegget
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DEFINE VAR kopiertSystem AS ROWID.
DEFINE VAR nesteSystemnr AS INTEGER.

   pointer =  SESSION:SET-WAIT-STATE("GENERAL").

    /* Kopier alle system - om det finnes  */
    kopiertSystem = ROWID(NPSHSYST).       
    /* Finn sist brukte systemnr */
    FIND LAST NPSHSYST WHERE anleggsnr = anleggsnrParam USE-INDEX ndx_anleggsnr_systemnr
        NO-LOCK NO-WAIT NO-ERROR.
    nesteSystemnr = NPSHSYST.systemnr + 1.
    CREATE tempSystem.
    FIND NPSHSYST WHERE ROWID(NPSHSYST) = kopiertSystem NO-WAIT NO-ERROR.
        ASSIGN
                  tempSystem.anleggsnr = anleggsnrParam
                  tempSystem.autoritet = NPSHSYST.autoritet 
                  tempSystem.beregnet_anvendelse = NPSHSYST.beregnet_anvendelse 
                  tempSystem.fabrikat = NPSHSYST.fabrikat 
                  tempSystem.forhaands_struping = NPSHSYST.forhaands_struping 
                  tempSystem.forhaands_struping_prim = NPSHSYST.forhaands_struping_prim 
                  tempSystem.forhaands_struping_sek = NPSHSYST.forhaands_struping_sek 
                  tempSystem.glykol = NPSHSYST.glykol 
                  tempSystem.inngaende_trykk = NPSHSYST.inngaende_trykk 
                  tempSystem.koblings_alternativ = NPSHSYST.koblings_alternativ 
                  tempSystem.konsentrasjon = NPSHSYST.konsentrasjon 
                  tempSystem.kvs_hovedport = NPSHSYST.kvs_hovedport 
                  tempSystem.kvs_shuntport = NPSHSYST.kvs_shuntport 
                  tempSystem.minste_pumpetrykk = NPSHSYST.minste_pumpetrykk 
                  tempSystem.motstand_objekt = NPSHSYST.motstand_objekt 
                  tempSystem.motstand_objekt_avtrekk = NPSHSYST.motstand_objekt_avtrekk 
                  tempSystem.motstand_objekt_innblaasning = NPSHSYST.motstand_objekt_innblaasning 
                  tempSystem.motstand_prim_krets = NPSHSYST.motstand_prim_krets 
                  tempSystem.motstand_ror_bend = NPSHSYST.motstand_ror_bend.
            ASSIGN
                  tempSystem.motstand_ror_bend_avtrekk = NPSHSYST.motstand_ror_bend_avtrekk 
                  tempSystem.motstand_ror_bend_innblaasning = NPSHSYST.motstand_ror_bend_innblaasning 
                  tempSystem.motstand_ror_bend_prim = NPSHSYST.motstand_ror_bend_prim 
                  tempSystem.motstand_ror_bend_sek = NPSHSYST.motstand_ror_bend_sek 
                  tempSystem.motstand_sek_krets = NPSHSYST.motstand_sek_krets 
                  tempSystem.motstand_strupeventil = NPSHSYST.motstand_strupeventil 
                  tempSystem.motstand_strupeventil_prim = NPSHSYST.motstand_strupeventil_prim 
                  tempSystem.motstand_strupeventil_sek = NPSHSYST.motstand_strupeventil_sek 
                  tempSystem.prim_effekt = NPSHSYST.prim_effekt 
                  tempSystem.prim_kapasitet = NPSHSYST.prim_kapasitet 
                  tempSystem.prim_temp_inn = NPSHSYST.prim_temp_inn 
                  tempSystem.prim_temp_ut = NPSHSYST.prim_temp_ut 
                  tempSystem.sek_effekt = NPSHSYST.sek_effekt 
                  tempSystem.sek_kapasitet = NPSHSYST.sek_kapasitet 
                  tempSystem.sek_temp_inn = NPSHSYST.sek_temp_inn 
                  tempSystem.sek_temp_ut = NPSHSYST.sek_temp_ut 
                  tempSystem.shunt_dimmensjon = NPSHSYST.shunt_dimmensjon 
                  tempSystem.sikkerhet = NPSHSYST.sikkerhet 
                  tempSystem.standardpris = NPSHSYST.standardpris 
                  tempSystem.strupe_dimmensjon_prim = NPSHSYST.strupe_dimmensjon_prim 
                  tempSystem.strupe_dimmensjon_sek = NPSHSYST.strupe_dimmensjon_sek 
                  tempSystem.systembetegnelse = NPSHSYST.systembetegnelse 
                  tempSystem.systemnr = nesteSystemnr.
            ASSIGN
                  tempSystem.system_kode = NPSHSYST.system_kode 
                  tempSystem.tegning_bmp = NPSHSYST.tegning_bmp 
/*                  tempSystem.tillegg = NPSHSYST.tillegg */
                  tempSystem.tillegg_ekspansjonskar = NPSHSYST.tillegg_ekspansjonskar
                  tempSystem.tillegg_el_amp = NPSHSYST.tillegg_el_amp
                  tempSystem.tillegg_el_hz = NPSHSYST.tillegg_el_hz
                  tempSystem.tillegg_el_volt = NPSHSYST.tillegg_el_volt 
                  tempSystem.tillegg_ferdigkoblet_prim = NPSHSYST.tillegg_ferdigkoblet_prim
                  tempSystem.tillegg_ferdigkoblet_sek = NPSHSYST.tillegg_ferdigkoblet_sek
                  tempSystem.tillegg_forstilling = NPSHSYST.tillegg_forstilling 
                  tempSystem.tillegg_gulvstativ = NPSHSYST.tillegg_gulvstativ 
                  tempSystem.tillegg_kapsling = NPSHSYST.tillegg_kapsling 
                  tempSystem.tillegg_fm_brakett_overgang = NPSHSYST.tillegg_fm_brakett_overgang
                  tempSystem.tillegg_ms_brakett_overgang = NPSHSYST.tillegg_ms_brakett_overgang
                  tempSystem.tillegg_kuleventil_fabrikat_prim = NPSHSYST.tillegg_kuleventil_fabrikat_prim 
                  tempSystem.tillegg_kuleventil_fabrikat_prim = NPSHSYST.tillegg_kuleventil_fabrikat_sek 
                  tempSystem.tillegg_kuleventil_prim = NPSHSYST.tillegg_kuleventil_prim 
                  tempSystem.tillegg_kuleventil_sek = NPSHSYST.tillegg_kuleventil_sek 
                  tempSystem.tillegg_kuleventil_vnr_prim = NPSHSYST.tillegg_kuleventil_vnr_prim 
                  tempSystem.tillegg_kuleventil_vnr_sek = NPSHSYST.tillegg_kuleventil_vnr_sek 
                  tempSystem.tillegg_montasje = NPSHSYST.tillegg_montasje 
                  tempSystem.tillegg_pumpetype = NPSHSYST.tillegg_pumpetype 
                  tempSystem.tillegg_pumpe_betegnelse = NPSHSYST.tillegg_pumpe_betegnelse 
                  tempSystem.tillegg_pumpe_fabrikat = NPSHSYST.tillegg_pumpe_fabrikat 
                  tempSystem.tillegg_pumpe_type = NPSHSYST.tillegg_pumpe_type 
                  tempSystem.tillegg_spjeldventil_fabrikat_pr = NPSHSYST.tillegg_spjeldventil_fabrikat_pr 
                  tempSystem.tillegg_spjeldventil_fabrikat_se = NPSHSYST.tillegg_spjeldventil_fabrikat_se 
                  tempSystem.tillegg_spjeldventil_prim = NPSHSYST.tillegg_spjeldventil_prim 
                  tempSystem.tillegg_spjeldventil_sek = NPSHSYST.tillegg_spjeldventil_sek 
                  tempSystem.tillegg_spjeldventil_vnr_prim = NPSHSYST.tillegg_spjeldventil_vnr_prim 
                  tempSystem.tillegg_spjeldventil_vnr_sek = NPSHSYST.tillegg_spjeldventil_vnr_sek 
                  tempSystem.tillegg_stengeventil = NPSHSYST.tillegg_stengeventil 
                  tempSystem.tillegg_stengeventil_type_prim = NPSHSYST.tillegg_stengeventil_type_prim 
                  tempSystem.tillegg_stengeventil_type_sek = NPSHSYST.tillegg_stengeventil_type_sek 
                  tempSystem.tillegg_strupe = NPSHSYST.tillegg_strupe 
                  tempSystem.trykk_for_shunt_ventil = NPSHSYST.trykk_for_shunt_ventil 
                  tempSystem.type = NPSHSYST.type.
             ASSIGN
                  tempSystem.ventilmotstand = NPSHSYST.ventilmotstand 
                  tempSystem.ventilmotstand_port_2-1_prim = NPSHSYST.ventilmotstand_port_2-1_prim 
                  tempSystem.ventilmotstand_port_2-1_sek = NPSHSYST.ventilmotstand_port_2-1_sek 
                  tempSystem.ventilmotstand_port_3-1_prim = NPSHSYST.ventilmotstand_port_3-1_prim 
                  tempSystem.ventilmotstand_port_3-1_sek = NPSHSYST.ventilmotstand_port_3-1_sek 
                  tempSystem.ventil_karakteristikk_hoved = NPSHSYST.ventil_karakteristikk_hoved 
                  tempSystem.ventil_karakteristikk_shunt = NPSHSYST.ventil_karakteristikk_shunt 
                  tempSystem.ventil_type = NPSHSYST.ventil_type.

        /* Kopier ny record */
               CREATE NPSHSYST.
               Current-Rec = ROWID(NPSHSYST).
               ASSIGN
                  NPSHSYST.anleggsnr = tempSystem.anleggsnr
                  NPSHSYST.autoritet = tempSystem.autoritet 
                  NPSHSYST.beregnet_anvendelse = tempSystem.beregnet_anvendelse 
                  NPSHSYST.fabrikat = tempSystem.fabrikat 
                  NPSHSYST.forhaands_struping = tempSystem.forhaands_struping 
                  NPSHSYST.forhaands_struping_prim = tempSystem.forhaands_struping_prim 
                  NPSHSYST.forhaands_struping_sek = tempSystem.forhaands_struping_sek 
                  NPSHSYST.glykol = tempSystem.glykol 
                  NPSHSYST.inngaende_trykk = tempSystem.inngaende_trykk 
                  NPSHSYST.koblings_alternativ = tempSystem.koblings_alternativ 
                  NPSHSYST.konsentrasjon = tempSystem.konsentrasjon.
           ASSIGN
                  NPSHSYST.kvs_hovedport = tempSystem.kvs_hovedport 
                  NPSHSYST.kvs_shuntport = tempSystem.kvs_shuntport 
                  NPSHSYST.minste_pumpetrykk = tempSystem.minste_pumpetrykk 
                  NPSHSYST.motstand_objekt = tempSystem.motstand_objekt 
                  NPSHSYST.motstand_objekt_avtrekk = tempSystem.motstand_objekt_avtrekk 
                  NPSHSYST.motstand_objekt_innblaasning = tempSystem.motstand_objekt_innblaasning 
                  NPSHSYST.motstand_prim_krets = tempSystem.motstand_prim_krets 
                  NPSHSYST.motstand_ror_bend = tempSystem.motstand_ror_bend.
            ASSIGN
                  NPSHSYST.motstand_ror_bend_avtrekk = tempSystem.motstand_ror_bend_avtrekk 
                  NPSHSYST.motstand_ror_bend_innblaasning = tempSystem.motstand_ror_bend_innblaasning 
                  NPSHSYST.motstand_ror_bend_prim = tempSystem.motstand_ror_bend_prim 
                  NPSHSYST.motstand_ror_bend_sek = tempSystem.motstand_ror_bend_sek 
                  NPSHSYST.motstand_sek_krets = tempSystem.motstand_sek_krets 
                  NPSHSYST.motstand_strupeventil = tempSystem.motstand_strupeventil 
                  NPSHSYST.motstand_strupeventil_prim = tempSystem.motstand_strupeventil_prim 
                  NPSHSYST.motstand_strupeventil_sek = tempSystem.motstand_strupeventil_sek 
                  NPSHSYST.prim_effekt = tempSystem.prim_effekt 
                  NPSHSYST.prim_kapasitet = tempSystem.prim_kapasitet 
                  NPSHSYST.prim_temp_inn = tempSystem.prim_temp_inn 
                  NPSHSYST.prim_temp_ut = tempSystem.prim_temp_ut 
                  NPSHSYST.sek_effekt = tempSystem.sek_effekt 
                  NPSHSYST.sek_kapasitet = tempSystem.sek_kapasitet.
            ASSIGN
                  NPSHSYST.sek_temp_inn = tempSystem.sek_temp_inn 
                  NPSHSYST.sek_temp_ut = tempSystem.sek_temp_ut 
                  NPSHSYST.shunt_dimmensjon = tempSystem.shunt_dimmensjon 
                  NPSHSYST.sikkerhet = tempSystem.sikkerhet 
                  NPSHSYST.standardpris = tempSystem.standardpris 
                  NPSHSYST.strupe_dimmensjon_prim = tempSystem.strupe_dimmensjon_prim 
                  NPSHSYST.strupe_dimmensjon_sek = tempSystem.strupe_dimmensjon_sek 
                  NPSHSYST.systembetegnelse = tempSystem.systembetegnelse 
                  NPSHSYST.systemnr = tempSystem.systemnr.
            ASSIGN
                  NPSHSYST.system_kode = tempSystem.system_kode 
                  NPSHSYST.tegning_bmp = tempSystem.tegning_bmp 
/*                  NPSHSYST.tillegg = tempSystem.tillegg */
                  NPSHSYST.tillegg_ekspansjonskar = tempSystem.tillegg_ekspansjonskar 
                  NPSHSYST.tillegg_el_amp = tempSystem.tillegg_el_amp 
                  NPSHSYST.tillegg_el_hz = tempSystem.tillegg_el_hz 
                  NPSHSYST.tillegg_el_volt = tempSystem.tillegg_el_volt 
                  NPSHSYST.tillegg_ferdigkoblet_prim = tempSystem.tillegg_ferdigkoblet_prim 
                  NPSHSYST.tillegg_ferdigkoblet_sek = tempSystem.tillegg_ferdigkoblet_sek 
                  NPSHSYST.tillegg_forstilling = tempSystem.tillegg_forstilling 
                  NPSHSYST.tillegg_gulvstativ =  tempSystem.tillegg_gulvstativ 
                  NPSHSYST.tillegg_kapsling = tempSystem.tillegg_kapsling 
                  NPSHSYST.tillegg_fm_brakett_overgang = tempSystem.tillegg_fm_brakett_overgang
                  NPSHSYST.tillegg_ms_brakett_overgang = tempSystem.tillegg_ms_brakett_overgang
                  NPSHSYST.tillegg_kuleventil_fabrikat_prim = tempSystem.tillegg_kuleventil_fabrikat_prim 
                  NPSHSYST.tillegg_kuleventil_fabrikat_sek = tempSystem.tillegg_kuleventil_fabrikat_prim 
                  NPSHSYST.tillegg_kuleventil_prim = tempSystem.tillegg_kuleventil_prim 
                  NPSHSYST.tillegg_kuleventil_sek = tempSystem.tillegg_kuleventil_sek 
                  NPSHSYST.tillegg_kuleventil_vnr_prim = tempSystem.tillegg_kuleventil_vnr_prim 
                  NPSHSYST.tillegg_kuleventil_vnr_sek = tempSystem.tillegg_kuleventil_vnr_sek 
                  NPSHSYST.tillegg_montasje = tempSystem.tillegg_montasje.
           ASSIGN
                  NPSHSYST.tillegg_pumpetype = tempSystem.tillegg_pumpetype 
                  NPSHSYST.tillegg_pumpe_betegnelse = tempSystem.tillegg_pumpe_betegnelse 
                  NPSHSYST.tillegg_pumpe_fabrikat = tempSystem.tillegg_pumpe_fabrikat 
                  NPSHSYST.tillegg_pumpe_type = tempSystem.tillegg_pumpe_type 
                  NPSHSYST.tillegg_spjeldventil_fabrikat_pr = tempSystem.tillegg_spjeldventil_fabrikat_pr 
                  NPSHSYST.tillegg_spjeldventil_fabrikat_se = tempSystem.tillegg_spjeldventil_fabrikat_se 
                  NPSHSYST.tillegg_spjeldventil_prim = tempSystem.tillegg_spjeldventil_prim 
                  NPSHSYST.tillegg_spjeldventil_sek = tempSystem.tillegg_spjeldventil_sek 
                  NPSHSYST.tillegg_spjeldventil_vnr_prim = tempSystem.tillegg_spjeldventil_vnr_prim 
                  NPSHSYST.tillegg_spjeldventil_vnr_sek = tempSystem.tillegg_spjeldventil_vnr_sek 
                  NPSHSYST.tillegg_stengeventil = tempSystem.tillegg_stengeventil 
                  NPSHSYST.tillegg_stengeventil_type_prim = tempSystem.tillegg_stengeventil_type_prim 
                  NPSHSYST.tillegg_stengeventil_type_sek = tempSystem.tillegg_stengeventil_type_sek
                  NPSHSYST.tillegg_strupe = tempSystem.tillegg_strupe 
                  NPSHSYST.trykk_for_shunt_ventil = tempSystem.trykk_for_shunt_ventil 
                  NPSHSYST.type = tempSystem.type.
             ASSIGN
                  NPSHSYST.ventilmotstand = tempSystem.ventilmotstand 
                  NPSHSYST.ventilmotstand_port_2-1_prim = tempSystem.ventilmotstand_port_2-1_prim 
                  NPSHSYST.ventilmotstand_port_2-1_sek =tempSystem.ventilmotstand_port_2-1_sek 
                  NPSHSYST.ventilmotstand_port_3-1_prim = tempSystem.ventilmotstand_port_3-1_prim 
                  NPSHSYST.ventilmotstand_port_3-1_sek = tempSystem.ventilmotstand_port_3-1_sek 
                  NPSHSYST.ventil_karakteristikk_hoved = tempSystem.ventil_karakteristikk_hoved 
                  NPSHSYST.ventil_karakteristikk_shunt = tempSystem.ventil_karakteristikk_shunt 
                  NPSHSYST.ventil_type = tempSystem.ventil_type.
       pointer =  SESSION:SET-WAIT-STATE("").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_system_fra_temp System-Window 
PROCEDURE kopiere_system_fra_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        /* Kopier ny record */
               CREATE NPSHSYST.
               Current-Rec = ROWID(NPSHSYST).
               ASSIGN
                  NPSHSYST.anleggsnr = tempSystem.anleggsnr
                  NPSHSYST.autoritet = tempSystem.autoritet 
                  NPSHSYST.beregnet_anvendelse = tempSystem.beregnet_anvendelse 
                  NPSHSYST.fabrikat = tempSystem.fabrikat 
                  NPSHSYST.forhaands_struping = tempSystem.forhaands_struping 
                  NPSHSYST.forhaands_struping_prim = tempSystem.forhaands_struping_prim 
                  NPSHSYST.forhaands_struping_sek = tempSystem.forhaands_struping_sek 
                  NPSHSYST.glykol = tempSystem.glykol 
                  NPSHSYST.inngaende_trykk = tempSystem.inngaende_trykk 
                  NPSHSYST.koblings_alternativ = tempSystem.koblings_alternativ 
                  NPSHSYST.konsentrasjon = tempSystem.konsentrasjon.
           ASSIGN
                  NPSHSYST.kvs_hovedport = tempSystem.kvs_hovedport 
                  NPSHSYST.kvs_shuntport = tempSystem.kvs_shuntport 
                  NPSHSYST.minste_pumpetrykk = tempSystem.minste_pumpetrykk 
                  NPSHSYST.motstand_objekt = tempSystem.motstand_objekt 
                  NPSHSYST.motstand_objekt_avtrekk = tempSystem.motstand_objekt_avtrekk 
                  NPSHSYST.motstand_objekt_innblaasning = tempSystem.motstand_objekt_innblaasning 
                  NPSHSYST.motstand_prim_krets = tempSystem.motstand_prim_krets 
                  NPSHSYST.motstand_ror_bend = tempSystem.motstand_ror_bend.
            ASSIGN
                  NPSHSYST.motstand_ror_bend_avtrekk = tempSystem.motstand_ror_bend_avtrekk 
                  NPSHSYST.motstand_ror_bend_innblaasning = tempSystem.motstand_ror_bend_innblaasning 
                  NPSHSYST.motstand_ror_bend_prim = tempSystem.motstand_ror_bend_prim 
                  NPSHSYST.motstand_ror_bend_sek = tempSystem.motstand_ror_bend_sek 
                  NPSHSYST.motstand_sek_krets = tempSystem.motstand_sek_krets 
                  NPSHSYST.motstand_strupeventil = tempSystem.motstand_strupeventil 
                  NPSHSYST.motstand_strupeventil_prim = tempSystem.motstand_strupeventil_prim 
                  NPSHSYST.motstand_strupeventil_sek = tempSystem.motstand_strupeventil_sek 
                  NPSHSYST.prim_effekt = tempSystem.prim_effekt 
                  NPSHSYST.prim_kapasitet = tempSystem.prim_kapasitet 
                  NPSHSYST.prim_temp_inn = tempSystem.prim_temp_inn 
                  NPSHSYST.prim_temp_ut = tempSystem.prim_temp_ut 
                  NPSHSYST.sek_effekt = tempSystem.sek_effekt 
                  NPSHSYST.sek_kapasitet = tempSystem.sek_kapasitet.
            ASSIGN
                  NPSHSYST.sek_temp_inn = tempSystem.sek_temp_inn 
                  NPSHSYST.sek_temp_ut = tempSystem.sek_temp_ut 
                  NPSHSYST.shunt_dimmensjon = tempSystem.shunt_dimmensjon 
                  NPSHSYST.sikkerhet = tempSystem.sikkerhet 
                  NPSHSYST.standardpris = tempSystem.standardpris 
                  NPSHSYST.strupe_dimmensjon_prim = tempSystem.strupe_dimmensjon_prim 
                  NPSHSYST.strupe_dimmensjon_sek = tempSystem.strupe_dimmensjon_sek 
                  NPSHSYST.systembetegnelse = tempSystem.systembetegnelse 
                  NPSHSYST.systemnr = tempSystem.systemnr.
            ASSIGN
                  NPSHSYST.system_kode = tempSystem.system_kode 
                  NPSHSYST.tegning_bmp = tempSystem.tegning_bmp 
/*                  NPSHSYST.tillegg = tempSystem.tillegg */
                  NPSHSYST.tillegg_ekspansjonskar = tempSystem.tillegg_ekspansjonskar 
                  NPSHSYST.tillegg_el_amp = tempSystem.tillegg_el_amp 
                  NPSHSYST.tillegg_el_hz = tempSystem.tillegg_el_hz 
                  NPSHSYST.tillegg_el_volt = tempSystem.tillegg_el_volt 
                  NPSHSYST.tillegg_ferdigkoblet_prim = tempSystem.tillegg_ferdigkoblet_prim 
                  NPSHSYST.tillegg_ferdigkoblet_sek = tempSystem.tillegg_ferdigkoblet_sek 
                  NPSHSYST.tillegg_forstilling = tempSystem.tillegg_forstilling 
                  NPSHSYST.tillegg_gulvstativ =  tempSystem.tillegg_gulvstativ 
                  NPSHSYST.tillegg_kapsling = tempSystem.tillegg_kapsling 
                  NPSHSYST.tillegg_fm_brakett_overgang = tempSystem.tillegg_fm_brakett_overgang
                  NPSHSYST.tillegg_ms_brakett_overgang = tempSystem.tillegg_ms_brakett_overgang
                  NPSHSYST.tillegg_kuleventil_fabrikat_prim = tempSystem.tillegg_kuleventil_fabrikat_prim 
                  NPSHSYST.tillegg_kuleventil_fabrikat_sek = tempSystem.tillegg_kuleventil_fabrikat_prim 
                  NPSHSYST.tillegg_kuleventil_prim = tempSystem.tillegg_kuleventil_prim 
                  NPSHSYST.tillegg_kuleventil_sek = tempSystem.tillegg_kuleventil_sek 
                  NPSHSYST.tillegg_kuleventil_vnr_prim = tempSystem.tillegg_kuleventil_vnr_prim 
                  NPSHSYST.tillegg_kuleventil_vnr_sek = tempSystem.tillegg_kuleventil_vnr_sek 
                  NPSHSYST.tillegg_montasje = tempSystem.tillegg_montasje.
           ASSIGN
                  NPSHSYST.tillegg_pumpetype = tempSystem.tillegg_pumpetype 
                  NPSHSYST.tillegg_pumpe_betegnelse = tempSystem.tillegg_pumpe_betegnelse 
                  NPSHSYST.tillegg_pumpe_fabrikat = tempSystem.tillegg_pumpe_fabrikat 
                  NPSHSYST.tillegg_pumpe_type = tempSystem.tillegg_pumpe_type 
                  NPSHSYST.tillegg_spjeldventil_fabrikat_pr = tempSystem.tillegg_spjeldventil_fabrikat_pr 
                  NPSHSYST.tillegg_spjeldventil_fabrikat_se = tempSystem.tillegg_spjeldventil_fabrikat_se 
                  NPSHSYST.tillegg_spjeldventil_prim = tempSystem.tillegg_spjeldventil_prim 
                  NPSHSYST.tillegg_spjeldventil_sek = tempSystem.tillegg_spjeldventil_sek 
                  NPSHSYST.tillegg_spjeldventil_vnr_prim = tempSystem.tillegg_spjeldventil_vnr_prim 
                  NPSHSYST.tillegg_spjeldventil_vnr_sek = tempSystem.tillegg_spjeldventil_vnr_sek 
                  NPSHSYST.tillegg_stengeventil = tempSystem.tillegg_stengeventil 
                  NPSHSYST.tillegg_stengeventil_type_prim = tempSystem.tillegg_stengeventil_type_prim 
                  NPSHSYST.tillegg_stengeventil_type_sek = tempSystem.tillegg_stengeventil_type_sek
                  NPSHSYST.tillegg_strupe = tempSystem.tillegg_strupe 
                  NPSHSYST.trykk_for_shunt_ventil = tempSystem.trykk_for_shunt_ventil 
                  NPSHSYST.type = tempSystem.type.
             ASSIGN
                  NPSHSYST.ventilmotstand = tempSystem.ventilmotstand 
                  NPSHSYST.ventilmotstand_port_2-1_prim = tempSystem.ventilmotstand_port_2-1_prim 
                  NPSHSYST.ventilmotstand_port_2-1_sek =tempSystem.ventilmotstand_port_2-1_sek 
                  NPSHSYST.ventilmotstand_port_3-1_prim = tempSystem.ventilmotstand_port_3-1_prim 
                  NPSHSYST.ventilmotstand_port_3-1_sek = tempSystem.ventilmotstand_port_3-1_sek 
                  NPSHSYST.ventil_karakteristikk_hoved = tempSystem.ventil_karakteristikk_hoved 
                  NPSHSYST.ventil_karakteristikk_shunt = tempSystem.ventil_karakteristikk_shunt 
                  NPSHSYST.ventil_type = tempSystem.ventil_type.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_system_til_temp System-Window 
PROCEDURE kopiere_system_til_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR kopiertSystem AS ROWID.
DEFINE VAR nesteSystemnr AS INTEGER.

    /* Kopier alle system - om det finnes  */
    kopiertSystem = ROWID(NPSHSYST).       
    /* Finn sist brukte systemnr */
    FIND LAST NPSHSYST WHERE anleggsnr = anleggsnrParam USE-INDEX ndx_anleggsnr_systemnr
        NO-WAIT NO-ERROR.
    nesteSystemnr = NPSHSYST.systemnr + 1.
    CREATE tempSystem.
    FIND NPSHSYST WHERE ROWID(NPSHSYST) = kopiertSystem NO-WAIT NO-ERROR.
        ASSIGN
                  tempSystem.anleggsnr = anleggsnrParam
                  tempSystem.autoritet = NPSHSYST.autoritet 
                  tempSystem.beregnet_anvendelse = NPSHSYST.beregnet_anvendelse 
                  tempSystem.fabrikat = NPSHSYST.fabrikat 
                  tempSystem.forhaands_struping = NPSHSYST.forhaands_struping 
                  tempSystem.forhaands_struping_prim = NPSHSYST.forhaands_struping_prim 
                  tempSystem.forhaands_struping_sek = NPSHSYST.forhaands_struping_sek 
                  tempSystem.glykol = NPSHSYST.glykol 
                  tempSystem.inngaende_trykk = NPSHSYST.inngaende_trykk 
                  tempSystem.koblings_alternativ = NPSHSYST.koblings_alternativ 
                  tempSystem.konsentrasjon = NPSHSYST.konsentrasjon 
                  tempSystem.kvs_hovedport = NPSHSYST.kvs_hovedport 
                  tempSystem.kvs_shuntport = NPSHSYST.kvs_shuntport 
                  tempSystem.minste_pumpetrykk = NPSHSYST.minste_pumpetrykk 
                  tempSystem.motstand_objekt = NPSHSYST.motstand_objekt 
                  tempSystem.motstand_objekt_avtrekk = NPSHSYST.motstand_objekt_avtrekk 
                  tempSystem.motstand_objekt_innblaasning = NPSHSYST.motstand_objekt_innblaasning 
                  tempSystem.motstand_prim_krets = NPSHSYST.motstand_prim_krets 
                  tempSystem.motstand_ror_bend = NPSHSYST.motstand_ror_bend.
            ASSIGN
                  tempSystem.motstand_ror_bend_avtrekk = NPSHSYST.motstand_ror_bend_avtrekk 
                  tempSystem.motstand_ror_bend_innblaasning = NPSHSYST.motstand_ror_bend_innblaasning 
                  tempSystem.motstand_ror_bend_prim = NPSHSYST.motstand_ror_bend_prim 
                  tempSystem.motstand_ror_bend_sek = NPSHSYST.motstand_ror_bend_sek 
                  tempSystem.motstand_sek_krets = NPSHSYST.motstand_sek_krets 
                  tempSystem.motstand_strupeventil = NPSHSYST.motstand_strupeventil 
                  tempSystem.motstand_strupeventil_prim = NPSHSYST.motstand_strupeventil_prim 
                  tempSystem.motstand_strupeventil_sek = NPSHSYST.motstand_strupeventil_sek 
                  tempSystem.prim_effekt = NPSHSYST.prim_effekt 
                  tempSystem.prim_kapasitet = NPSHSYST.prim_kapasitet 
                  tempSystem.prim_temp_inn = NPSHSYST.prim_temp_inn 
                  tempSystem.prim_temp_ut = NPSHSYST.prim_temp_ut 
                  tempSystem.sek_effekt = NPSHSYST.sek_effekt 
                  tempSystem.sek_kapasitet = NPSHSYST.sek_kapasitet 
                  tempSystem.sek_temp_inn = NPSHSYST.sek_temp_inn 
                  tempSystem.sek_temp_ut = NPSHSYST.sek_temp_ut 
                  tempSystem.shunt_dimmensjon = NPSHSYST.shunt_dimmensjon 
                  tempSystem.sikkerhet = NPSHSYST.sikkerhet 
                  tempSystem.standardpris = NPSHSYST.standardpris 
                  tempSystem.strupe_dimmensjon_prim = NPSHSYST.strupe_dimmensjon_prim 
                  tempSystem.strupe_dimmensjon_sek = NPSHSYST.strupe_dimmensjon_sek 
                  tempSystem.systembetegnelse = NPSHSYST.systembetegnelse 
                  tempSystem.systemnr = nesteSystemnr.
            ASSIGN
                  tempSystem.system_kode = NPSHSYST.system_kode 
                  tempSystem.tegning_bmp = NPSHSYST.tegning_bmp 
/*                  tempSystem.tillegg = NPSHSYST.tillegg */
                  tempSystem.tillegg_ekspansjonskar = NPSHSYST.tillegg_ekspansjonskar
                  tempSystem.tillegg_el_amp = NPSHSYST.tillegg_el_amp
                  tempSystem.tillegg_el_hz = NPSHSYST.tillegg_el_hz
                  tempSystem.tillegg_el_volt = NPSHSYST.tillegg_el_volt 
                  tempSystem.tillegg_ferdigkoblet_prim = NPSHSYST.tillegg_ferdigkoblet_prim
                  tempSystem.tillegg_ferdigkoblet_sek = NPSHSYST.tillegg_ferdigkoblet_sek
                  tempSystem.tillegg_forstilling = NPSHSYST.tillegg_forstilling 
                  tempSystem.tillegg_gulvstativ = NPSHSYST.tillegg_gulvstativ 
                  tempSystem.tillegg_kapsling = NPSHSYST.tillegg_kapsling 
                  tempSystem.tillegg_fm_brakett_overgang = NPSHSYST.tillegg_fm_brakett_overgang
                  tempSystem.tillegg_ms_brakett_overgang = NPSHSYST.tillegg_ms_brakett_overgang
                  tempSystem.tillegg_kuleventil_fabrikat_prim = NPSHSYST.tillegg_kuleventil_fabrikat_prim 
                  tempSystem.tillegg_kuleventil_fabrikat_prim = NPSHSYST.tillegg_kuleventil_fabrikat_sek 
                  tempSystem.tillegg_kuleventil_prim = NPSHSYST.tillegg_kuleventil_prim 
                  tempSystem.tillegg_kuleventil_sek = NPSHSYST.tillegg_kuleventil_sek 
                  tempSystem.tillegg_kuleventil_vnr_prim = NPSHSYST.tillegg_kuleventil_vnr_prim 
                  tempSystem.tillegg_kuleventil_vnr_sek = NPSHSYST.tillegg_kuleventil_vnr_sek 
                  tempSystem.tillegg_montasje = NPSHSYST.tillegg_montasje 
                  tempSystem.tillegg_pumpetype = NPSHSYST.tillegg_pumpetype 
                  tempSystem.tillegg_pumpe_betegnelse = NPSHSYST.tillegg_pumpe_betegnelse 
                  tempSystem.tillegg_pumpe_fabrikat = NPSHSYST.tillegg_pumpe_fabrikat 
                  tempSystem.tillegg_pumpe_type = NPSHSYST.tillegg_pumpe_type 
                  tempSystem.tillegg_spjeldventil_fabrikat_pr = NPSHSYST.tillegg_spjeldventil_fabrikat_pr 
                  tempSystem.tillegg_spjeldventil_fabrikat_se = NPSHSYST.tillegg_spjeldventil_fabrikat_se 
                  tempSystem.tillegg_spjeldventil_prim = NPSHSYST.tillegg_spjeldventil_prim 
                  tempSystem.tillegg_spjeldventil_sek = NPSHSYST.tillegg_spjeldventil_sek 
                  tempSystem.tillegg_spjeldventil_vnr_prim = NPSHSYST.tillegg_spjeldventil_vnr_prim 
                  tempSystem.tillegg_spjeldventil_vnr_sek = NPSHSYST.tillegg_spjeldventil_vnr_sek 
                  tempSystem.tillegg_stengeventil = NPSHSYST.tillegg_stengeventil 
                  tempSystem.tillegg_stengeventil_type_prim = NPSHSYST.tillegg_stengeventil_type_prim 
                  tempSystem.tillegg_stengeventil_type_sek = NPSHSYST.tillegg_stengeventil_type_sek 
                  tempSystem.tillegg_strupe = NPSHSYST.tillegg_strupe 
                  tempSystem.trykk_for_shunt_ventil = NPSHSYST.trykk_for_shunt_ventil 
                  tempSystem.type = NPSHSYST.type.
             ASSIGN
                  tempSystem.ventilmotstand = NPSHSYST.ventilmotstand 
                  tempSystem.ventilmotstand_port_2-1_prim = NPSHSYST.ventilmotstand_port_2-1_prim 
                  tempSystem.ventilmotstand_port_2-1_sek = NPSHSYST.ventilmotstand_port_2-1_sek 
                  tempSystem.ventilmotstand_port_3-1_prim = NPSHSYST.ventilmotstand_port_3-1_prim 
                  tempSystem.ventilmotstand_port_3-1_sek = NPSHSYST.ventilmotstand_port_3-1_sek 
                  tempSystem.ventil_karakteristikk_hoved = NPSHSYST.ventil_karakteristikk_hoved 
                  tempSystem.ventil_karakteristikk_shunt = NPSHSYST.ventil_karakteristikk_shunt 
                  tempSystem.ventil_type = NPSHSYST.ventil_type.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop System-Window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_referanse System-Window 
PROCEDURE prc_referanse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR tekst_type AS CHAR.
DEFINE VAR tekst_dimm AS CHAR.
DEFINE VAR teller AS INTEGER.
DEFINE VAR ref_tekst AS CHAR INITIAL "".
FIND FIRST NPSHSYST WHERE anleggsnr = anleggsnrParam USE-INDEX ndx_type_dimm.
tekst_type = NPSHSYST.type.                                  
tekst_dimm = NPSHSYST.shunt_dimmensjon.
teller = 1.

REPEAT:
        FIND NEXT NPSHSYST WHERE anleggsnr = anleggsnrParam USE-INDEX ndx_type_dimm NO-ERROR.
        IF NOT AVAILABLE NPSHSYST THEN 
            DO:
            IF ref_tekst = '' THEN 
                ref_tekst = STRING(teller) + 'x' + tekst_type + tekst_dimm.
            ELSE
                ref_tekst = ref_tekst + ', ' + STRING(teller) + 'x' + tekst_type + tekst_dimm.
                UPDATE NPSHANLG SET referanse_tekst = ref_tekst  WHERE anleggsnr = anleggsnrParam.
                RETURN.
             END.

        IF NPSHSYST.type = tekst_type AND NPSHSYST.shunt_dimmensjon = tekst_dimm THEN
            teller = teller + 1.
        ELSE
        DO:
            IF ref_tekst = '' THEN 
                ref_tekst = STRING(teller) + 'x' + tekst_type + tekst_dimm.
            ELSE 
                ref_tekst = ref_tekst + ', ' + STRING(teller) + 'x' + tekst_type + tekst_dimm.

                tekst_type = NPSHSYST.type.
                tekst_dimm = NPSHSYST.shunt_dimmensjon.
                teller = 1.
        END.
END.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE View_Win System-Window 
PROCEDURE View_Win :
/* -----------------------------------------------------------
  Purpose:   View (after hiding) the current window  
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  {&WINDOW-NAME}:HIDDEN = FALSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visSystemKode System-Window 
PROCEDURE visSystemKode :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
/* Fyll ut de felt som har data - resten med ?? */
DEFINE VAR c_kode AS CHAR.
/* Type */
IF  NPSHSYST.type <> "" THEN
    c_kode = NPSHSYST.type.
ELSE
    c_kode = '??'.
/* Dimm */
IF  NPSHSYST.shunt_dimmensjon <> "" THEN
    c_kode = c_kode  + TRIM(NPSHSYST.shunt_dimmensjon).
ELSE
    c_kode = c_kode + '??'.
/* Legg til ventiltype ved MS */
IF NPSHSYST.type = 'MS' THEN
    c_kode = c_kode + '/' + NPSHSYST.ms_ventiltype.   
/* KVS Hovedport (2-1)  og ventilkarakteristikk */
IF  NPSHSYST.kvs_hovedport > 0 THEN
    DO:
        c_kode = c_kode + '-Kvs' + STRING(NPSHSYST.kvs_hovedport).
        c_kode = c_kode + ' ' + NPSHSYST.ventil_karakteristikk_hoved.
    END.        
ELSE
    c_kode = TRIM(c_kode) + '- Kvs' + '??-??'.
IF NPSHSYST.type = 'FM' THEN
DO:
/* KVS Shuntport (3-1) og ventilkarakteristikk */
IF  NPSHSYST.kvs_shuntport > 0 THEN
    DO:
        c_kode = c_kode + '/Kvs' + STRING(NPSHSYST.kvs_shuntport).
        c_kode = c_kode + ' ' + NPSHSYST.ventil_karakteristikk_shunt.
    END.        
END.
/* Koblingsalternativ */
c_kode = c_kode + '-' + STRING(NPSHSYST.koblings_alternativ).
/* Beregnet anvendelse */
CASE NPSHSYST.beregnet_anvendelse:
    WHEN 'Varme' THEN
        c_kode = c_kode + '-V'.
    WHEN 'Lavtemperatur' THEN
        c_kode = c_kode + '-L'.
    WHEN 'Kj›le' THEN
        c_kode = c_kode + '-K'.
    WHEN 'Fryse' THEN
        c_kode = c_kode + '-F'.
    WHEN 'Varmegjenvinning' THEN
        c_kode = c_kode + '-VG'.
     WHEN "Lavtemp/Kaldt medium" THEN 
        c_kode = c_kode + '-L/K'.
END CASE.
/* Reguleringsmotor */
IF NPSHSYST.tillegg_forstilling = 'Ingen' THEN
    c_kode = c_kode + '-0'.
ELSE
    c_kode = c_kode + '-<' + NPSHSYST.tillegg_forstilling + '>'.

/* Strupeventil type og dimmensjon */
IF NPSHSYST.tillegg_strupe THEN
    DO:
    CASE NPSHSYST.koblings_alternativ:
        WHEN '1' OR WHEN '7A' THEN
            /* prim‘r og sekund‘r er like */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_sek <> "" THEN
                    c_kode = c_kode + '-' + NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek + '/' +  
                        NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '- 0/0'.
            END.
        WHEN '2' OR WHEN '3' OR WHEN '6' THEN
            /* kun sekund‘rside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_sek <> "" THEN
                    c_kode = c_kode + '-KUL' + NPSHSYST.strupe_dimmensjon_sek + '/' + NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '-0/0'.
            END.
        WHEN '4' THEN
            /* kun prim‘rside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_prim <> "" THEN
                    c_kode = c_kode + '-' +  NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_prim + '/KUL' + NPSHSYST.strupe_dimmensjon_prim.
                ELSE
                    c_kode = c_kode + '-0/0'.
            END.
        WHEN '5' OR WHEN '7' THEN
            /* b†de prim‘rside or sekund‘rside */
            DO:
                IF  NPSHSYST.strupe_dimmensjon_prim <> "" THEN
                    c_kode = c_kode + '- ' +  NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_prim + '/' +
                        NPSHSYST.fabrikat + NPSHSYST.strupe_dimmensjon_sek.
                ELSE
                    c_kode = c_kode + '0/0'.
            END.
        END CASE.
    END.
ELSE
    c_kode = c_kode + '-0/0'.

    /* Stengeventil type og dimmensjon */
    /* Koblingsalternativ uaktuelt - styres ved registrering av tillegg */
    CASE NPSHSYST.koblings_alternativ:
        WHEN '5' OR WHEN '7 '  THEN
        DO:
            IF NPSHSYST.tillegg_stengeventil_type_prim = 'Kule' THEN
                DO:
                    IF NPSHSYST.tillegg_kuleventil_prim THEN
                      c_kode = c_kode + '-KUL' + NPSHSYST.strupe_dimmensjon_prim + '/'.
                    ELSE
                      c_kode = c_kode + '-0/'.            
                END.
            ELSE IF NPSHSYST.tillegg_stengeventil_type_prim = 'Spjeld' THEN
                DO:
                    IF NPSHSYST.tillegg_spjeldventil_prim THEN
                      c_kode = c_kode + '-SPJ' + NPSHSYST.strupe_dimmensjon_prim + '/'.
                    ELSE
                      c_kode = c_kode + '-0/'.            
                END.
            IF NPSHSYST.tillegg_stengeventil_type_sek = 'Kule' THEN
                DO:                
                    IF NPSHSYST.tillegg_kuleventil_sek THEN
                      c_kode = c_kode + 'KUL' + NPSHSYST.strupe_dimmensjon_sek.
                    ELSE
                      c_kode = c_kode + '0'.
               END.
            ELSE IF NPSHSYST.tillegg_stengeventil_type_sek = 'Spjeld' THEN
                DO:
                    IF NPSHSYST.tillegg_spjeldventil_sek THEN
                      c_kode = c_kode + '-SPJ' + NPSHSYST.strupe_dimmensjon_sek.
                    ELSE
                      c_kode = c_kode + '0'.            
               END.
        END.
    OTHERWISE
        DO:
           IF NPSHSYST.tillegg_kuleventil_sek THEN
             c_kode = c_kode + '-KUL' + NPSHSYST.strupe_dimmensjon_prim + '/' +  
              'KUL' + NPSHSYST.strupe_dimmensjon_sek.
           ELSE IF NPSHSYST.tillegg_spjeldventil_sek THEN
              c_kode = c_kode + '-SPJ' + NPSHSYST.strupe_dimmensjon_prim + '/' +  
               'SPJ' + NPSHSYST.strupe_dimmensjon_sek.
           ELSE
              c_kode = c_kode + '-0/0'.
        END.
    END CASE.
        
/* Pumpe */
IF  NPSHSYST.tillegg_pumpe_fabrikat = "Ingen" THEN
    c_kode = c_kode + '-0'.
ELSE
    c_kode = c_kode + '-P'.
     
/* Montasje */
IF  NPSHSYST.tillegg_montasje <> "" THEN
    c_kode = c_kode + '-' + SUBSTRING(NPSHSYST.tillegg_montasje, 1, 1).
ELSE
    c_kode = c_kode + '- ??'.

/*  Kapsling */
IF  NPSHSYST.tillegg_kapsling <> "Kapsling, Ingen" THEN
    c_kode = c_kode + '-' + SUBSTRING(NPSHSYST.tillegg_kapsling, 10, 11).

FIND NPSHSYST WHERE ROWID(NPSHSYST)  = Current-Rec EXCLUSIVE-LOCK 
    NO-WAIT NO-ERROR.
IF AVAILABLE NPSHSYST THEN
    DO:
        ASSIGN NPSHSYST.system_kode = c_kode.
        DISPLAY NPSHSYST.system_kode WITH FRAME Detalj-Frame IN WINDOW SYSTEM-WINDOW.
    END.
ELSE
    MESSAGE 'Får ikke satt oppdatert kode på dette systemet. Kjør beregning/Registrer tillegg igjen senere'
        VIEW-AS ALERT-BOX TITLE 'Oppdateringsfeil'.
        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRec System-Window 
FUNCTION getCurrentRec RETURNS ROWID
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    RETURN current-rec.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEditModus System-Window 
FUNCTION getEditModus RETURNS integer
  ():
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    return EditModus.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNyRecord System-Window 
FUNCTION getNyRecord RETURNS LOGICAL
  ():
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    return nyRecord.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentRec System-Window 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    current-rec = ipRowid.
    return true.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

