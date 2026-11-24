&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME ANLEGGSBROWSER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ANLEGGSBROWSER 
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
def var appdata as char no-undo. /*setter den via JboxSession:AppTitle*/
appdata = JBoxSession:Instance:AppTitle.
def var hParent as handle no-undo.
DEFINE VAR shuntRetur AS LOGICAL INITIAL FALSE.
DEFINE VAR sokeStreng AS CHAR.
DEFINE VAR sortStreng AS CHAR.

def var prosjektidparam like norprosjekt.prosjektid no-undo. /*Benyttes i browsescope..*/
/* Local Variable Definitions ---                                       */
def var current-rec as rowid.
def var nyRecord as log init false.
DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR anleggsRow AS LOGICAL.
DEFINE VAR Detail-Handle AS HANDLE.
DEFINE VAR anleggsNavnParam AS CHAR.
DEFINE TEMP-TABLE tempAnlegg LIKE NPSHANLG.
DEFINE TEMP-TABLE tempSystem LIKE NPSHSYST.
DEFINE TEMP-TABLE tempTillegg LIKE NPSHTILLEGG.
DEFINE VAR iNextAnleggsnr AS INTEGER.
DEFINE VAR iCurAnleggsnr AS INTEGER.
DEFINE VAR iNextSystem AS INTEGER.
DEFINE VAR p-handle AS HANDLE.
DEFINE VAR nyttProsjektIdParam LIKE NORPROSJEKT.prosjektid.
DEFINE VARIABLE dbop-supported AS LOGICAL.
DEFINE VARIABLE dbop-db-name AS CHARACTER.
DEFINE VARIABLE dbop-tbl-name AS CHARACTER.
DEFINE VARIABLE nav-stat AS LOGICAL.
DEFINE VARIABLE browser-handle AS HANDLE.
DEFINE VAR bareAktive AS LOGICAL INITIAL TRUE.
DEFINE VAR ip_neste_id AS INTEGER.

DEFINE QUERY Nytt-Sok FOR NPSHANLG, NPKUNDE SCROLLING.

def buffer bProsjekt for norprosjekt.

def var hMainMenu as handle no-undo. /*dummy handle*/
hMainMenu = session:first-procedure.
 
/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN
    THIS-PROCEDURE:PRIVATE-DATA = JBoxSession:Instance:AppTitle.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Anlegg-Frame
&Scoped-define BROWSE-NAME Anleggs-Browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHANLG NPKUNDE

/* Definitions for BROWSE Anleggs-Browse                                */
&Scoped-define FIELDS-IN-QUERY-Anleggs-Browse NPSHANLG.anlegg NPSHANLG.dato ~
NPKUNDE.kundenavn NPSHANLG.oppf_uke NPSHANLG.anleggsnr NPSHANLG.entreprise ~
NPSHANLG.beskrevet NPSHANLG.salgsdistrikt NPSHANLG.standardpris ~
NPSHANLG.leveringstid NPSHANLG.anbudsfrist NPSHANLG.endrings_laas ~
NPSHANLG.aktivt NPSHANLG.sikker NPSHANLG.referanse_tekst ~
NPSHANLG.kundedistriktNr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Anleggs-Browse 
&Scoped-define QUERY-STRING-Anleggs-Browse FOR EACH NPSHANLG ~
      WHERE NPSHANLG.prosjektid = prosjektIdParam  NO-LOCK, ~
      EACH NPKUNDE OF NPSHANLG OUTER-JOIN NO-LOCK ~
    BY NPSHANLG.anleggsnr DESCENDING
&Scoped-define OPEN-QUERY-Anleggs-Browse OPEN QUERY Anleggs-Browse FOR EACH NPSHANLG ~
      WHERE NPSHANLG.prosjektid = prosjektIdParam  NO-LOCK, ~
      EACH NPKUNDE OF NPSHANLG OUTER-JOIN NO-LOCK ~
    BY NPSHANLG.anleggsnr DESCENDING.
&Scoped-define TABLES-IN-QUERY-Anleggs-Browse NPSHANLG NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-Anleggs-Browse NPSHANLG
&Scoped-define SECOND-TABLE-IN-QUERY-Anleggs-Browse NPKUNDE


/* Definitions for FRAME Anlegg-Frame                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Anlegg-Frame ~
    ~{&OPEN-QUERY-Anleggs-Browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Anleggs-Browse 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRec ANLEGGSBROWSER 
FUNCTION getCurrentRec RETURNS ROWID
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNyRecord ANLEGGSBROWSER 
FUNCTION getNyRecord RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentRec ANLEGGSBROWSER 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE ANLEGGSBROWSER AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Anlegg 
       MENU-ITEM m_Nytt         LABEL "&Nytt..."       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre"         ACCELERATOR "CTRL-E"
       MENU-ITEM m_Slette       LABEL "S&lette..."    
       MENU-ITEM m_Kopiere      LABEL "&Kopiere"      
       MENU-ITEM m_Flytte       LABEL "&Flytte..."    .

DEFINE SUB-MENU m_Utskrift 
       MENU-ITEM m_Oppf_dette_anlegget LABEL "&Oppf. dette anlegget".

DEFINE SUB-MENU m_Statistikk 
       MENU-ITEM m_Tilbudsstatistikk LABEL "&Tilbud..."    .

DEFINE MENU MAIN-MENU MENUBAR
       SUB-MENU  m_Anlegg       LABEL "&Anlegg"       
       MENU-ITEM m_System       LABEL "&System"       
       MENU-ITEM m_Tilbud       LABEL "Til&bud"       
       SUB-MENU  m_Utskrift     LABEL "&Utskrift"     
       SUB-MENU  m_Statistikk   LABEL "Statisti&kk"   
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Anleggs-Browse FOR 
      NPSHANLG, 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Anleggs-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Anleggs-Browse ANLEGGSBROWSER _STRUCTURED
  QUERY Anleggs-Browse NO-LOCK DISPLAY
      NPSHANLG.anlegg FORMAT "X(45)":U
      NPSHANLG.dato FORMAT "99.99.9999":U
      NPKUNDE.kundenavn COLUMN-LABEL "Konsulent" FORMAT "X(30)":U
      NPSHANLG.oppf_uke FORMAT "99":U
      NPSHANLG.anleggsnr FORMAT ">>>>>9":U
      NPSHANLG.entreprise FORMAT "X(8)":U
      NPSHANLG.beskrevet FORMAT "X(10)":U
      NPSHANLG.salgsdistrikt FORMAT "X(30)":U
      NPSHANLG.standardpris FORMAT ">>,>>>,>>9.99":U
      NPSHANLG.leveringstid FORMAT "X(15)":U
      NPSHANLG.anbudsfrist FORMAT "99.99.9999":U
      NPSHANLG.endrings_laas FORMAT "ja/nei":U
      NPSHANLG.aktivt FORMAT "ja/nei":U
      NPSHANLG.sikker FORMAT "ja/nei":U
      NPSHANLG.referanse_tekst FORMAT "X(80)":U
      NPSHANLG.kundedistriktNr FORMAT ">>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 125.38 BY 4.84
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Anlegg-Frame
     Anleggs-Browse AT ROW 1 COL 1
     NPSHANLG.anleggsnr AT ROW 6.22 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.dato AT ROW 6.22 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.sikker AT ROW 6.22 COL 115 COLON-ALIGNED
          LABEL "Sikker?"
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.38 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.aktivt AT ROW 6.47 COL 58
          VIEW-AS TOGGLE-BOX
          SIZE 11 BY .78
          BGCOLOR 8 FGCOLOR 0 
     NPSHANLG.endrings_laas AT ROW 6.47 COL 72
          LABEL "Låst for endringer"
          VIEW-AS TOGGLE-BOX
          SIZE 28.63 BY .78
          BGCOLOR 8 FGCOLOR 12 
     NPSHANLG.anlegg AT ROW 7.41 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 53.88 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPKUNDE.kundenavn AT ROW 8.63 COL 20 COLON-ALIGNED
          LABEL "Konsulent"
          VIEW-AS FILL-IN NATIVE 
          SIZE 31.38 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPSHANLG.konsulentens_saksbeh AT ROW 8.63 COL 62.13 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 26.38 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPSHANLG.selger AT ROW 9.81 COL 78 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "Håkon A. Pedersen","Håkon A. Pedersen",
                     "Arne Svensson","Arne Svensson",
                     "Ronny Svensson","Ronny Svensson",
                     "Arne Terkelsen","Arne Terkelsen",
                     "Steinar Aune","Steinar Aune",
                     "Kjetil Sørensen","Kjetil Sørensen"
          DROP-DOWN-LIST
          SIZE 36 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.kundedistriktNr AT ROW 9.84 COL 20 COLON-ALIGNED
          LABEL "Salgsdistrikt"
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEM-PAIRS "         ",1
          DROP-DOWN-LIST
          SIZE 40.13 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.beskrevet AT ROW 11.16 COL 78 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "","",
                     "FM","FM",
                     "MS","MS",
                     "ABS","ABS",
                     "L&G","L&G",
                     "TTM","TTM",
                     "ANDRE","ANDRE",
                     "FRITT","FRITT",
                     "PLASSBYGD","PLASSBYGD",
                     "TA","TA"
          DROP-DOWN-LIST
          SIZE 36 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.saksbehandler AT ROW 11.22 COL 20 COLON-ALIGNED
          LABEL "Saksbeh."
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "Arne Svensson","Arne Svensson",
                     "Arne Terkelsen","Arne Terkelsen",
                     "Kari Paulsen","Kari Paulsen",
                     "Håkon A. Pedersen","Håkon A. Pedersen",
                     "Ronny Svensson","Ronny Svensson",
                     "Arne Kristian Svensson","Arne Kristian Svensson",
                     "Kjetil Sørensen","Kjetil Sørensen"
          DROP-DOWN-LIST
          SIZE 24.13 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 125.8 BY 18.29
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Anlegg-Frame
     NPSHANLG.entreprise AT ROW 12.41 COL 11.38
          VIEW-AS COMBO-BOX INNER-LINES 8
          DROP-DOWN-LIST
          SIZE 26 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.oppf_uke AT ROW 12.41 COL 64 COLON-ALIGNED
          LABEL "Oppfølgingsuke"
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.88 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.anbudsfrist AT ROW 12.66 COL 87 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.byggestart AT ROW 13.63 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.leveringstid AT ROW 13.84 COL 87 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 16.13 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHANLG.opplysninger AT ROW 15.03 COL 17.88 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
          SIZE 106 BY 3.59
          BGCOLOR 8 FGCOLOR 1 FONT 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 125.8 BY 18.29
         FONT 2.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW ANLEGGSBROWSER ASSIGN
         HIDDEN             = YES
         TITLE              = "Shuntanlegg"
         COLUMN             = 2.25
         ROW                = 1.31
         HEIGHT             = 18.31
         WIDTH              = 125.88
         MAX-HEIGHT         = 20
         MAX-WIDTH          = 126.63
         VIRTUAL-HEIGHT     = 20
         VIRTUAL-WIDTH      = 126.63
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MAIN-MENU:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT ANLEGGSBROWSER:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT ANLEGGSBROWSER:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW ANLEGGSBROWSER
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME Anlegg-Frame
   FRAME-NAME UNDERLINE                                                 */
/* BROWSE-TAB Anleggs-Browse 1 Anlegg-Frame */
ASSIGN 
       FRAME Anlegg-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR TOGGLE-BOX NPSHANLG.aktivt IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHANLG.anbudsfrist IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHANLG.anlegg IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHANLG.anleggsnr IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSHANLG.beskrevet IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHANLG.byggestart IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHANLG.dato IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX NPSHANLG.endrings_laas IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR COMBO-BOX NPSHANLG.entreprise IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN NPSHANLG.konsulentens_saksbeh IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSHANLG.kundedistriktNr IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPKUNDE.kundenavn IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPSHANLG.leveringstid IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHANLG.oppf_uke IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR EDITOR NPSHANLG.opplysninger IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSHANLG.saksbehandler IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR COMBO-BOX NPSHANLG.selger IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHANLG.sikker IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ANLEGGSBROWSER)
THEN ANLEGGSBROWSER:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Anleggs-Browse
/* Query rebuild information for BROWSE Anleggs-Browse
     _TblList          = "norcalc.NPSHANLG,norcalc.NPKUNDE OF norcalc.NPSHANLG"
     _Options          = "NO-LOCK"
     _TblOptList       = ", OUTER"
     _OrdList          = "norcalc.NPSHANLG.anleggsnr|no"
     _Where[1]         = "NPSHANLG.prosjektid = prosjektIdParam "
     _FldNameList[1]   = norcalc.NPSHANLG.anlegg
     _FldNameList[2]   = norcalc.NPSHANLG.dato
     _FldNameList[3]   > norcalc.NPKUNDE.kundenavn
"NPKUNDE.kundenavn" "Konsulent" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = norcalc.NPSHANLG.oppf_uke
     _FldNameList[5]   = norcalc.NPSHANLG.anleggsnr
     _FldNameList[6]   = norcalc.NPSHANLG.entreprise
     _FldNameList[7]   = norcalc.NPSHANLG.beskrevet
     _FldNameList[8]   = norcalc.NPSHANLG.salgsdistrikt
     _FldNameList[9]   = norcalc.NPSHANLG.standardpris
     _FldNameList[10]   = norcalc.NPSHANLG.leveringstid
     _FldNameList[11]   = norcalc.NPSHANLG.anbudsfrist
     _FldNameList[12]   = norcalc.NPSHANLG.endrings_laas
     _FldNameList[13]   = norcalc.NPSHANLG.aktivt
     _FldNameList[14]   = norcalc.NPSHANLG.sikker
     _FldNameList[15]   = norcalc.NPSHANLG.referanse_tekst
     _FldNameList[16]   = norcalc.NPSHANLG.kundedistriktNr
     _Query            is OPENED
*/  /* BROWSE Anleggs-Browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ANLEGGSBROWSER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ANLEGGSBROWSER ANLEGGSBROWSER
ON HELP OF ANLEGGSBROWSER /* Shuntanlegg */
DO:
  MESSAGE "This basic navigation window can be used to browse through " +
      "record in one or more tables. Lay out database fields onto " +
      "the frame. You may also add a browser for a table which is " +
      "joinable to the first." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.aktivt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.aktivt ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.aktivt IN FRAME Anlegg-Frame /* Aktivt */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.aktivt ANLEGGSBROWSER
ON VALUE-CHANGED OF NPSHANLG.aktivt IN FRAME Anlegg-Frame /* Aktivt */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.anbudsfrist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.anbudsfrist ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.anbudsfrist IN FRAME Anlegg-Frame /* Anbudsfrist */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.anlegg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.anlegg ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.anlegg IN FRAME Anlegg-Frame /* Anlegg */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Anleggs-Browse
&Scoped-define SELF-NAME Anleggs-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Anleggs-Browse ANLEGGSBROWSER
ON LEFT-MOUSE-CLICK OF Anleggs-Browse IN FRAME Anlegg-Frame
DO:
  APPLY 'VALUE-CHANGED' TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Anleggs-Browse ANLEGGSBROWSER
ON LEFT-MOUSE-DBLCLICK OF Anleggs-Browse IN FRAME Anlegg-Frame
DO:
 APPLY 'CHOOSE' TO MENU-ITEM m_endre IN MENU MAIN-MENU.
 RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Anleggs-Browse ANLEGGSBROWSER
ON RETURN OF Anleggs-Browse IN FRAME Anlegg-Frame
DO:
    APPLY 'CHOOSE' TO MENU-ITEM m_endre IN MENU MAIN-MENU.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Anleggs-Browse ANLEGGSBROWSER
ON VALUE-CHANGED OF Anleggs-Browse IN FRAME Anlegg-Frame
DO:
          Current-Rec =  ROWID(NPSHANLG). 
          RUN visDetaljer.          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.anleggsnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.anleggsnr ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.anleggsnr IN FRAME Anlegg-Frame /* Anleggsnr */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.beskrevet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.beskrevet ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.beskrevet IN FRAME Anlegg-Frame /* Beskrevet */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.byggestart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.byggestart ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.byggestart IN FRAME Anlegg-Frame /* Byggestart */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.dato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.dato ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.dato IN FRAME Anlegg-Frame /* Dato */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.endrings_laas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.endrings_laas ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.endrings_laas IN FRAME Anlegg-Frame /* Låst for endringer */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.entreprise
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.entreprise ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.entreprise IN FRAME Anlegg-Frame /* Entreprise */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.konsulentens_saksbeh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.konsulentens_saksbeh ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.konsulentens_saksbeh IN FRAME Anlegg-Frame /* v/ */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.kundedistriktNr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.kundedistriktNr ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.kundedistriktNr IN FRAME Anlegg-Frame /* Salgsdistrikt */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPKUNDE.kundenavn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPKUNDE.kundenavn ANLEGGSBROWSER
ON ENTRY OF NPKUNDE.kundenavn IN FRAME Anlegg-Frame /* Konsulent */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.leveringstid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.leveringstid ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.leveringstid IN FRAME Anlegg-Frame /* Leveringstid */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME MAIN-MENU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MAIN-MENU ANLEGGSBROWSER
ON CHOOSE OF MENU MAIN-MENU
DO:
     SESSION:SET-WAIT-STATE("GENERAL").
/*    anleggsnrParam = NPSHANLG.anleggsnr.*/
/*    anleggsNavnParam = NPSHANLG.anlegg. */
    Current-Rec = ROWID(NPSHANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = JBoxSession:Instance:AppTitle + "," + STRING(npshanlg.anleggsnr).
    RUN SHUSYST.W.
    APPLY "VALUE-CHANGED" TO ANLEGGS-BROWSE IN FRAME ANLEGG-FRAME.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Endre /* Endre */
DO:
     SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = FALSE.
/*    anleggsnrParam = NPSHANLG.anleggsnr.*/
    Current-Rec = ROWID(NPSHANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = JBoxSession:Instance:AppTitle + "," + STRING(npshanlg.anleggsnr).
    RUN SHANLRED.W.
    {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
    REPOSITION Anleggs-Browse TO ROWID(Current-Rec) no-error.
    APPLY 'VALUE-CHANGED' TO Anleggs-Browse  IN FRAME ANLEGG-FRAME.
    RUN visDetaljer.
     /* Set aktivtflagg på prosjektnivå */
     RUN SETAKTIV.P (INPUT npshanlg.anleggsnr).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Flytte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Flytte ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Flytte /* Flytte... */
DO:
    DEFINE VAR detteAnlegg AS ROWID.
    DEFINE VAR detteProsjektet LIKE NORPROSJEKT.prosjektid.
    DEFINE VAR antall AS INTEGER.
    
    detteAnlegg = ROWID(NPSHANLG).
    detteProsjektet = NPSHANLG.prosjektId.
        
  /* La brukeren velge prosjektet som det skal flyttes til */
  RUN VELGPROS.W (OUTPUT nyttProsjektIdParam, INPUT 'Shunt').
  IF nyttProsjektIdParam = ? OR nyttProsjektIdParam = 0 THEN DO:
        MESSAGE 'Prosjekt ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
        RETURN NO-APPLY.
    END.

   /* Oppdater dette anlegget med ny prosjektid */
    FIND  NPSHANLG WHERE ROWID(NPSHANLG) = detteAnlegg NO-WAIT NO-ERROR.
    IF AVAILABLE NPSHANLG THEN DO:
        ASSIGN NPSHANLG.prosjektid = nyttProsjektIdParam. 
  /* Slå på shunt flagg i dette prosjektet */
  UPDATE NORPROSJEKT SET shuntgrupper = "Ja"  WHERE prosjektid = nyttProsjektIdParam.

  /* Dersom dette prosjektet ikke har flere shunttanlegg, slå av shuntflagg */
    SELECT COUNT(*) INTO antall FROM NPSHANLG  WHERE prosjektId = detteProsjektet.
    IF antall = 0 THEN
        UPDATE NORPROSJEKT SET spirovent = "Nei" WHERE prosjektid = detteProsjektet.

   /* Refresh browser */
    {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
/*    APPLY 'VALUE-CHANGED' TO Anleggs-Browse  IN FRAME ANLEGG-FRAME.
    RUN visDetaljer.
*/
    END.   
    ELSE
        MESSAGE 'Anlegget lot seg ikke flytte' VIEW-AS ALERT-BOX TITLE 'Feil'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kopiere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kopiere ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Kopiere /* Kopiere */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").   
    current-rec = rowid(npshanlg).   
    
    RUN kopiere_anlegg_til_temp.
    RUN kopiere_anlegg_fra_temp.
    RUN kopiere_system_til_temp.
    RUN kopiere_system_fra_temp.
    /* Åpne browser og reset row pointer */
     {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
      REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
      APPLY 'VALUE-CHANGED' TO Anleggs-Browse   IN FRAME ANLEGG-FRAME.
      RUN visDetaljer.           
     SESSION:SET-WAIT-STATE("").
         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Nytt /* Nytt... */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = TRUE.
    
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA + "," + STRING(prosjektidParam).
    RUN SHANLRED.W.
    FIND NPSHANLG WHERE ROWID(NPSHANLG) = Current-Rec NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE NPSHANLG THEN DO:
          {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
            REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
            APPLY 'VALUE-CHANGED' TO Anleggs-Browse
                IN FRAME ANLEGG-FRAME.
          RUN visDetaljer.           
          MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = YES.

          /* Sørg for at 'shuntgrupper' på prosjektet settes til 'ja' */
          FIND NORPROSJEKT WHERE NORPROSJEKT.prosjektid = prosjektIdParam.
          IF AVAILABLE NORPROSJEKT THEN
            ASSIGN NORPROSJEKT.shuntgrupper = 'Ja'.
            
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Oppf_dette_anlegget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Oppf_dette_anlegget ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Oppf_dette_anlegget /* Oppf. dette anlegget */
DO:
      DEFINE VAR svar AS LOGICAL INITIAL TRUE.
      DEFINE VAR funnet AS INTEGER.
      def var iAnlgnr as int no-undo.
      iAnlgnr = npshanlg.anleggsnr.
/*    anleggsnrParam = NPSHANLG.anleggsnr.*/
    MESSAGE 'Vil du skrive ut oppfølgingsliste for dette anlegget?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Oppfølgingsliste'  UPDATE svar.
    IF svar THEN
   DO:
        /* Test om data finnes */
        SELECT COUNT(*) INTO funnet FROM  NPSHANLG, NPSHTILBUD, NPSHTOPP
        WHERE NPSHANLG.anleggsnr =  iAnlgnr
              AND NPSHANLG.aktivt = TRUE 
              AND NOT NPSHTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPSHTOPP.oppf_status BEGINS 'ORDRE' 
              AND NPSHTILBUD.anleggsnr = NPSHANLG.anleggsnr
              AND NPSHTILBUD.id = NPSHTOPP.id .
        IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
        RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shunttilbud - oppf - ett anlegg",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSHANLG.anleggsnr = " + string(iAnlgnr) +
         " AND NPSHANLG.aktivt = TRUE 
         AND NOT NPSHTOPP.oppf_status BEGINS 'Tapt' 
         AND NOT NPSHTOPP.oppf_status BEGINS 'ORDRE'",
        "",
        "",
        hMainMenu:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud",
        yes,
        yes,
        no,
        "").        
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Slette /* Slette... */
DO:
      MESSAGE "Vil du slette dette anlegget med alle tilhørende system?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      if Choice then run slettSHanlegg.
    
    /*  Dersom dette var siste anlegg - disable menyvalg */
    FIND NPSHANLG WHERE NPSHANLG.prosjektid = prosjektidParam NO-ERROR.
    IF NOT AVAILABLE NPSHANLG THEN
    DO:
      MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = NO.
      MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = NO.
      MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
      MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
      MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
      /* Sørg for at 'shuntgrupper' på prosjektet settes til 'Nei' */
      UPDATE  NORPROSJEKT SET aggregater = 'Nei'  WHERE NORPROSJEKT.prosjektid = prosjektIdParam.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_System
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_System ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_System /* System */
DO:
     SESSION:SET-WAIT-STATE("GENERAL").
/*    anleggsnrParam = NPSHANLG.anleggsnr.*/
/*    anleggsNavnParam = NPSHANLG.anlegg. */
/*    dynamic-function('setAttribute',this-procedure,'anleggsnrParam',string(npshanlg.anleggsnr)).*/
/*    dynamic-function('setAttribute',this-procedure,'anleggsnavnParam',string(npshanlg.anlegg)). */
    Current-Rec = ROWID(NPSHANLG).
/*    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(NPSHANLG.anleggsnr).*/
    MENU-ITEM m_Nytt:SENSITIVE IN MENU MAIN-MENU = NO.  
    MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.  
    MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.  
    MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.  
    
    RUN SHUSYST.W  PERSISTENT SET p-handle.
    JBoxRelation:instance:addInvalidate(this-procedure,p-handle).
    RUN appl_ent IN p-handle.

        MENU-ITEM m_Nytt:SENSITIVE IN MENU MAIN-MENU = YES.  
        MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = YES.  
        MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = YES.  
        MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = YES.  

    {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
    REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
    APPLY "VALUE-CHANGED" TO ANLEGGS-BROWSE IN FRAME ANLEGG-FRAME.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbud
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbud ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Tilbud /* Tilbud */
DO:
     SESSION:SET-WAIT-STATE("GENERAL").
/*    anleggsnrParam = NPSHANLG.anleggsnr.*/
/*    anleggsNavnParam = NPSHANLG.anlegg. */
    Current-Rec = ROWID(NPSHANLG).
/*    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(NPSHANLG.anleggsnr).*/
    RUN SHTILBUD.W PERSISTENT SET p-handle.
    RUN appl_ent IN p-handle.
    APPLY "VALUE-CHANGED" TO ANLEGGS-BROWSE IN FRAME ANLEGG-FRAME.
    RUN visDetaljer.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbudsstatistikk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbudsstatistikk ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Tilbudsstatistikk /* Tilbud... */
DO:
     SESSION:SET-WAIT-STATE("GENERAL").
    Current-Rec = ROWID(NPSHANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(npshanlg.anleggsnr).
    RUN SHUSTAT1.W  PERSISTENT SET p-handle NO-ERROR.
    RUN appl_ent IN p-handle.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.oppf_uke
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.oppf_uke ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.oppf_uke IN FRAME Anlegg-Frame /* Oppfølgingsuke */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.opplysninger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.opplysninger ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.opplysninger IN FRAME Anlegg-Frame /* Opplysninger */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.saksbehandler
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.saksbehandler ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.saksbehandler IN FRAME Anlegg-Frame /* Saksbeh. */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.selger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.selger ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.selger IN FRAME Anlegg-Frame /* Selger */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.selger ANLEGGSBROWSER
ON VALUE-CHANGED OF NPSHANLG.selger IN FRAME Anlegg-Frame /* Selger */
DO:
  RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHANLG.sikker
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.sikker ANLEGGSBROWSER
ON ENTRY OF NPSHANLG.sikker IN FRAME Anlegg-Frame /* Sikker? */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHANLG.sikker ANLEGGSBROWSER
ON LEAVE OF NPSHANLG.sikker IN FRAME Anlegg-Frame /* Sikker? */
DO:
  RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ANLEGGSBROWSER 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  /* Clean up related Detail or Child windows if present. */
  JBoxRelation:instance:Invalidate(this-procedure).
  IF VALID-HANDLE(Detail-Handle) THEN
    APPLY "CLOSE" TO Detail-Handle.
  RUN disable_UI.
END.
/* These events will close the window and terminate the procedure.      */
/* (NOTE: this will override any user-defined triggers previously       */
/*  defined on the window.)                                             */
ON WINDOW-CLOSE OF {&WINDOW-NAME} DO:
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
    SESSION:SET-WAIT-STATE("").   

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
  prosjektidparam = int(JBoxSession:Instance:getJBoxAttribute('ProsjektIdParam')).
  ANLEGGSBROWSER:TITLE = 'Shuntanlegg for prosjekt: ' + JBoxSession:Instance:getJBoxAttribute('ProsjektNavnParam').  

  RUN enable_UI.
  RUN MoveToTop.
  APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
  SESSION:SET-WAIT-STATE("").
     
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

  OPEN QUERY ANLEGGSBROWSE   FOR EACH NPSHANLG 
          WHERE NPSHANLG.prosjektid = prosjektIdParam  NO-LOCK,
            EACH NPKUNDE OF NPSHANLG NO-LOCK
              BY norcalc.NPSHANLG.anleggsnr DESCENDING.
   IF AVAILABLE NPSHANLG THEN 
          APPLY 'VALUE-CHANGED' TO Anleggs-Browse.
    ELSE
    DO:
        MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
    END.
  END.  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent ANLEGGSBROWSER 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "ENTRY" TO NPSHANLG.anleggsnr IN FRAME {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ANLEGGSBROWSER  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ANLEGGSBROWSER)
  THEN DELETE WIDGET ANLEGGSBROWSER.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ANLEGGSBROWSER  _DEFAULT-ENABLE
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
  ENABLE Anleggs-Browse 
      WITH FRAME Anlegg-Frame IN WINDOW ANLEGGSBROWSER.
  {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Hide_Win ANLEGGSBROWSER 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_anlegg_fra_temp ANLEGGSBROWSER 
PROCEDURE kopiere_anlegg_fra_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /* Nytt anleggsnr */
   run neste_id.p (input 'NPSHANLG', output ip_neste_id).
   icurAnleggsnr = NPSHANLG.anleggsnr.
    /* Ny record med kopierte verdier */
   MESSAGE 'ip_neste_id:' ip_neste_id skip 'icurAnleggsnr:' icurAnleggsnr
   VIEW-AS ALERT-BOX.
   create npshanlg.
   Current-Rec = ROWID(NPSHANLG).
   ASSIGN 
     NPSHANLG.dato = TODAY
     NPSHANLG.anleggsnr = ip_neste_id
     NPSHANLG.prosjektId = tempAnlegg.prosjektid
     NPSHANLG.anlegg = tempAnlegg.anlegg 
     NPSHANLG.beskrevet = tempAnlegg.beskrevet
     NPSHANLG.byggestart = tempAnlegg.byggestart
     NPSHANLG.anbudsfrist = tempAnlegg.anbudsfrist
     NPSHANLG.dato = tempAnlegg.dato
     NPSHANLG.entreprise = tempAnlegg.entreprise
     NPSHANLG.kundenr = tempAnlegg.kundenr
     NPSHANLG.leveringstid = tempAnlegg.leveringstid
     NPSHANLG.oppf_uke = tempAnlegg.oppf_uke
     NPSHANLG.opplysninger = tempAnlegg.opplysninger
     NPSHANLG.standardpris = tempAnlegg.standardpris
     npshanlg.kundedistriktnr = tempAnlegg.kundedistriktnr                 
     npshanlg.salgsdistrikt = tempAnlegg.salgsdistrikt                 
    .
                     
            
     SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_anlegg_til_temp ANLEGGSBROWSER 
PROCEDURE kopiere_anlegg_til_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 /* Legg verdier fra valgt anlegg inn i temporærtabell - slett først ev. poster */
    FOR EACH tempAnlegg:
       delete tempAnlegg.
    end.
    CREATE tempAnlegg.
    ASSIGN 
         tempAnlegg.anlegg = NPSHANLG.anlegg 
         tempAnlegg.prosjektid = NPSHANLG.prosjektId
         tempAnlegg.beskrevet = NPSHANLG.beskrevet 
         tempAnlegg.byggestart = NPSHANLG.byggestart 
         tempAnlegg.anbudsfrist =NPSHANLG.anbudsfrist 
         tempAnlegg.dato = NPSHANLG.dato 
         tempAnlegg.entreprise =NPSHANLG.entreprise 
         tempAnlegg.kundenr = NPSHANLG.kundenr
         tempAnlegg.leveringstid = NPSHANLG.leveringstid 
         tempAnlegg.oppf_uke = NPSHANLG.oppf_uke 
         tempAnlegg.opplysninger = NPSHANLG.opplysninger 
         tempAnlegg.standardpris = NPSHANLG.standardpris
         tempAnlegg.kundedistriktnr = npshanlg.kundedistriktnr
         tempAnlegg.salgsdistrikt   = npshanlg.salgsdistrikt                 
     .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_system_fra_temp ANLEGGSBROWSER 
PROCEDURE kopiere_system_fra_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        /* Kopier nye records */
        FOR EACH tempSystem:
               CREATE NPSHSYST.
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
       END.             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_system_til_temp ANLEGGSBROWSER 
PROCEDURE kopiere_system_til_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Tøm ev. temp. tabell */
    FOR EACH tempSystem:
       delete tempSystem.
    end.

    /* Kopier alle system - om det finnes  */
    iNextSystem = 0.
    FOR EACH NPSHSYST WHERE  NPSHSYST.anleggsnr = iCurAnleggsnr:    
                iNextSystem = iNextSystem + 1.
                CREATE tempSystem.
        ASSIGN
                  tempSystem.anleggsnr = ip_neste_id
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
                  tempSystem.systemnr = iNextSystem.
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
          END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop ANLEGGSBROWSER 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE slettSHAnlegg ANLEGGSBROWSER 
PROCEDURE slettSHAnlegg :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    SESSION:SET-WAIT-STATE("GENERAL").
    STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
    current-rec = rowid(NPSHANLG).
    DO TRANSACTION:
      FIND NPSHANLG WHERE rowid(NPSHANLG)  = current-rec  EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE(NPSHANLG) THEN DO:
        DELETE NPSHANLG.
      END.
      ELSE
      DO:
        MESSAGE 'Tabellen for shuntanlegg er i bruk. Prøv igjen om en stund' 
           VIEW-AS ALERT-BOX TITLE 'Sletting'.
        RETURN.
      END.
    END.
    STATUS DEFAULT "                                                             ".
  END.
  SESSION:SET-WAIT-STATE("").
  {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
  GET FIRST Anleggs-Browse.   
  IF AVAILABLE NPSHANLG THEN DO:
    anleggsRow =  Anleggs-Browse:SELECT-ROW(1) IN FRAME Anlegg-Frame.
    APPLY 'VALUE-CHANGED' TO Anleggs-Browse.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE View_Win ANLEGGSBROWSER 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visDetaljer ANLEGGSBROWSER 
PROCEDURE visDetaljer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR cKundenr LIKE NPKUNDE.kundenr.

FIND NPSHANLG WHERE  ROWID(NPSHANLG) = Current-Rec.

IF AVAILABLE NPSHANLG THEN
DO:
    dynamic-function('setAttribute',this-procedure,'anleggsnrParam',string(npshanlg.anleggsnr)).
    dynamic-function('setAttribute',this-procedure,'anleggsnavnParam',string(npshanlg.anlegg)).
    cKundenr = NPSHANLG.kundenr.    
    DISPLAY 
        NPSHANLG.anleggsnr  NPSHANLG.dato NPSHANLG.aktivt NPSHANLG.endrings_laas
        NPSHANLG.sikker
        NPSHANLG.anlegg NPSHANLG.konsulentens_saksbeh NPSHANLG.kundedistriktnr 
        NPSHANLG.saksbehandler    NPSHANLG.selger  NPSHANLG.entreprise 
        NPSHANLG.beskrevet 
        NPSHANLG.anbudsfrist    NPSHANLG.byggestart  NPSHANLG.oppf_uke 
        NPSHANLG.leveringstid NPSHANLG.opplysninger        
    WITH FRAM {&FRAME-NAME}.    
    FIND NPKUNDE WHERE NPKUNDE.kundenr = cKundenr.
    IF AVAILABLE NPKUNDE THEN
         DISPLAY NPKUNDE.kundenavn 
        WITH FRAME {&FRAME-NAME}.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRec ANLEGGSBROWSER 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNyRecord ANLEGGSBROWSER 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentRec ANLEGGSBROWSER 
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

