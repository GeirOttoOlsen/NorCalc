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
/*DEFINE INPUT  PARAMETER appdata AS CHARACTER.                           */
/*DEFINE INPUT PARAMETER prosjektNavnParam LIKE NORPROSJEKT.prosjekt_navn.*/
/*DEFINE INPUT PARAMETER prosjektHandle AS HANDLE.*/
/*DEFINE VAR spiroRetur AS LOGICAL INITIAL FALSE.*/ /*Trolig ikke i bruk*/
DEFINE VAR sokeStreng AS CHAR.
DEFINE VAR sortStreng AS CHAR.
def var hChild as handle no-undo.
/*DEFINE NEW SHARED VAR anleggsnrParam LIKE NPSPANLG.anleggsnr.*/
/*DEFINE SHARED VAR prosjektidParam LIKE NORPROSJEKT.prosjektid.*/
/*DEFINE OUTPUT PARAMETER merkSisteParam AS LOGICAL.*/
def var anleggsnrParam like npspanlg.anleggsnr.
def var prosjektidparam like norprosjekt.prosjektid.
def var prosjektNavnparam like norprosjekt.prosjekt_navn.
def var Current-rec as rowid.
def var nyRecord as log.

/*def var merkSisteParam as log.*/
def var hParent as handle no-undo.

/* Local Variable Definitions ---                                       */
/* DEFINE NEW SHARED VAR Current-Rec AS  ROWID.            */
/* DEFINE NEW SHARED VAR nyRecord AS LOGICAL INITIAL FALSE.*/
DEFINE VAR pointer AS LOGICAL. 
/*DEFINE VAR anleggsRow AS LOGICAL.*/
DEFINE VAR Detail-Handle AS HANDLE.
/*DEFINE VAR anleggsNavnParam AS CHAR.*/
DEFINE TEMP-TABLE tempAnlegg LIKE NPSPANLG.
DEFINE TEMP-TABLE tempSystem LIKE NPSPSYST.
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

DEFINE QUERY Nytt-Sok FOR NPSPANLG, NPKUNDE SCROLLING.

def var hMainMenu as handle no-undo. /*dummy handle*/
hMainMenu = session:first-procedure.

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
&Scoped-define INTERNAL-TABLES NPSPANLG NPKUNDE

/* Definitions for BROWSE Anleggs-Browse                                */
&Scoped-define FIELDS-IN-QUERY-Anleggs-Browse NPSPANLG.anlegg NPSPANLG.dato ~
NPKUNDE.kundenavn NPSPANLG.oppf_uke NPSPANLG.anleggsnr NPSPANLG.entreprise ~
NPSPANLG.beskrevet NPSPANLG.salgsdistrikt NPSPANLG.standardpris ~
NPSPANLG.leveringsdato NPSPANLG.anbudsfrist NPSPANLG.endrings_laas ~
NPSPANLG.aktivt NPSPANLG.sikker 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Anleggs-Browse 
&Scoped-define QUERY-STRING-Anleggs-Browse FOR EACH NPSPANLG ~
      WHERE NPSPANLG.prosjektid = prosjektIdParam  NO-LOCK, ~
      EACH NPKUNDE OF NPSPANLG NO-LOCK ~
    BY NPSPANLG.dato DESCENDING
&Scoped-define OPEN-QUERY-Anleggs-Browse OPEN QUERY Anleggs-Browse FOR EACH NPSPANLG ~
      WHERE NPSPANLG.prosjektid = prosjektIdParam  NO-LOCK, ~
      EACH NPKUNDE OF NPSPANLG NO-LOCK ~
    BY NPSPANLG.dato DESCENDING.
&Scoped-define TABLES-IN-QUERY-Anleggs-Browse NPSPANLG NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-Anleggs-Browse NPSPANLG
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
DEFINE VAR ANLEGGSBROWSER AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Anlegg 
       MENU-ITEM m_Nytt         LABEL "&Nytt..."       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre"         ACCELERATOR "CTRL-E"
       MENU-ITEM m_Slette       LABEL "S&lette..."    
       MENU-ITEM m_Kopiere      LABEL "&Kopiere"      
       MENU-ITEM m_Flytte       LABEL "&Flytte"       .

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
      NPSPANLG, 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Anleggs-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Anleggs-Browse ANLEGGSBROWSER _STRUCTURED
  QUERY Anleggs-Browse NO-LOCK DISPLAY
      NPSPANLG.anlegg FORMAT "X(45)":U
      NPSPANLG.dato FORMAT "99.99.9999":U
      NPKUNDE.kundenavn COLUMN-LABEL "Konsulent" FORMAT "X(30)":U
      NPSPANLG.oppf_uke FORMAT "99":U
      NPSPANLG.anleggsnr FORMAT ">>>>>9":U
      NPSPANLG.entreprise FORMAT "X(6)":U
      NPSPANLG.beskrevet FORMAT "X(15)":U
      NPSPANLG.salgsdistrikt FORMAT "X(30)":U
      NPSPANLG.standardpris FORMAT ">>,>>>,>>9.99":U
      NPSPANLG.leveringsdato FORMAT "99.99.9999":U
      NPSPANLG.anbudsfrist FORMAT "99.99.9999":U COLUMN-FONT 2
      NPSPANLG.endrings_laas FORMAT "ja/nei":U
      NPSPANLG.aktivt FORMAT "ja/nei":U
      NPSPANLG.sikker FORMAT "ja/nei":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 137 BY 4.86
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Anlegg-Frame
     Anleggs-Browse AT ROW 1 COL 1
     NPSPANLG.anleggsnr AT ROW 6.24 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.dato AT ROW 6.24 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.standardpris AT ROW 6.24 COL 118.6 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.2 BY 1
          BGCOLOR 8 FGCOLOR 2 
     NPSPANLG.aktivt AT ROW 6.48 COL 59
          VIEW-AS TOGGLE-BOX
          SIZE 11 BY .76
          BGCOLOR 8 FGCOLOR 0 
     NPSPANLG.endrings_laas AT ROW 6.48 COL 71.6
          LABEL "Låst for endring"
          VIEW-AS TOGGLE-BOX
          SIZE 29.4 BY .76
          BGCOLOR 8 FGCOLOR 12 
     NPSPANLG.anlegg AT ROW 7.43 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 53.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.sikker AT ROW 7.43 COL 119 COLON-ALIGNED
          LABEL "Sikker?"
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.4 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.konsulentens_saksbeh AT ROW 8.62 COL 71 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 26.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPKUNDE.kundenavn AT ROW 8.67 COL 23 COLON-ALIGNED
          LABEL "Konsulent"
          VIEW-AS FILL-IN NATIVE 
          SIZE 31.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPSPANLG.kundedistriktNr AT ROW 9.81 COL 23 COLON-ALIGNED
          LABEL "Salgsdistrikt"
          VIEW-AS COMBO-BOX INNER-LINES 8
          LIST-ITEM-PAIRS "",1
          DROP-DOWN-LIST
          SIZE 34.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.selger AT ROW 9.86 COL 71 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Håkon A. Pedersen","Arne Svensson","Ronny Svensson","Arne Terkelsen","Steinar Aune","Kjetil Sørensen" 
          DROP-DOWN-LIST
          SIZE 35 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.saksbehandler AT ROW 11 COL 23 COLON-ALIGNED
          LABEL "Saksbeh."
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "","1"
          DROP-DOWN-LIST
          SIZE 24.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.anbudsfrist AT ROW 11.24 COL 71 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.entreprise AT ROW 12.43 COL 8.2
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "","",
                     "RØR ","RØR ",
                     "VENT ","VENT ",
                     "AUTO ","AUTO ",
                     "SKIP ","SKIP ",
                     "KULDE","KULDE",
                     "FORPRO","FORPRO",
                     "ELEKTRO","ELEKTRO",
                     "TOTAL","TOTAL"
          DROP-DOWN-LIST
          SIZE 15.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.beskrevet AT ROW 12.43 COL 71.2 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEM-PAIRS "     ","     ",
                     "Spirotop","Spirotop",
                     "Air","Air",
                     "Air & Dirt","Air & Dirt",
                     "Air Sup","Air Sup",
                     "Air & Dirt Dem","Air & Dirt Dem",
                     "Dirt Sep","Dirt Sep",
                     "Dirt Sep Dem","Dirt Sep Dem",
                     "Luft","Luft",
                     "Mikr","Mikr",
                     "Mikr/Smuss","Mikr/Smuss",
                     "Smuss","Smuss",
                     "Ajevent","Ajevent",
                     "Flamco","Flamco",
                     "Nonair","Nonair",
                     "Andre","Andre",
                     "Fritt","Fritt"
          DROP-DOWN-LIST
          SIZE 26.6 BY 1
          BGCOLOR 8 FGCOLOR 1 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 137.6 BY 18.24
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Anlegg-Frame
     NPSPANLG.byggestart AT ROW 13.86 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.oppf_uke AT ROW 13.95 COL 71 COLON-ALIGNED
          LABEL "Oppfølgingsuke"
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.leveringstid AT ROW 14 COL 106.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 24.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPANLG.opplysninger AT ROW 15.1 COL 25 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
          SIZE 111 BY 3.86
          BGCOLOR 8 FGCOLOR 1 FONT 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 137.6 BY 18.24
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
         TITLE              = "Spiroventanlegg"
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 18.24
         WIDTH              = 137.6
         MAX-HEIGHT         = 20
         MAX-WIDTH          = 137.6
         VIRTUAL-HEIGHT     = 20
         VIRTUAL-WIDTH      = 137.6
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW ANLEGGSBROWSER
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Anlegg-Frame
   FRAME-NAME UNDERLINE                                                 */
/* BROWSE-TAB Anleggs-Browse 1 Anlegg-Frame */
ASSIGN 
       FRAME Anlegg-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR TOGGLE-BOX NPSPANLG.aktivt IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSPANLG.anbudsfrist IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSPANLG.anlegg IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSPANLG.anleggsnr IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSPANLG.beskrevet IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSPANLG.byggestart IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSPANLG.dato IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX NPSPANLG.endrings_laas IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR COMBO-BOX NPSPANLG.entreprise IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN NPSPANLG.konsulentens_saksbeh IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSPANLG.kundedistriktNr IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPKUNDE.kundenavn IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPSPANLG.leveringstid IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSPANLG.oppf_uke IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR EDITOR NPSPANLG.opplysninger IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPSPANLG.saksbehandler IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR COMBO-BOX NPSPANLG.selger IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSPANLG.sikker IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPSPANLG.standardpris IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ANLEGGSBROWSER)
THEN ANLEGGSBROWSER:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Anleggs-Browse
/* Query rebuild information for BROWSE Anleggs-Browse
     _TblList          = "norcalc.NPSPANLG,norcalc.NPKUNDE OF norcalc.NPSPANLG"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPSPANLG.dato|no"
     _Where[1]         = "NPSPANLG.prosjektid = prosjektIdParam "
     _FldNameList[1]   = norcalc.NPSPANLG.anlegg
     _FldNameList[2]   = norcalc.NPSPANLG.dato
     _FldNameList[3]   > norcalc.NPKUNDE.kundenavn
"NPKUNDE.kundenavn" "Konsulent" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = norcalc.NPSPANLG.oppf_uke
     _FldNameList[5]   = norcalc.NPSPANLG.anleggsnr
     _FldNameList[6]   = norcalc.NPSPANLG.entreprise
     _FldNameList[7]   = norcalc.NPSPANLG.beskrevet
     _FldNameList[8]   = norcalc.NPSPANLG.salgsdistrikt
     _FldNameList[9]   = norcalc.NPSPANLG.standardpris
     _FldNameList[10]   = norcalc.NPSPANLG.leveringsdato
     _FldNameList[11]   > norcalc.NPSPANLG.anbudsfrist
"NPSPANLG.anbudsfrist" ? ? "date" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   = norcalc.NPSPANLG.endrings_laas
     _FldNameList[13]   = norcalc.NPSPANLG.aktivt
     _FldNameList[14]   = norcalc.NPSPANLG.sikker
     _Query            is OPENED
*/  /* BROWSE Anleggs-Browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ANLEGGSBROWSER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ANLEGGSBROWSER ANLEGGSBROWSER
ON HELP OF ANLEGGSBROWSER /* Spiroventanlegg */
DO:
  MESSAGE "This basic navigation window can be used to browse through " +
      "record in one or more tables. Lay out database fields onto " +
      "the frame. You may also add a browser for a table which is " +
      "joinable to the first." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.aktivt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.aktivt ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.aktivt IN FRAME Anlegg-Frame /* Aktivt */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.aktivt ANLEGGSBROWSER
ON VALUE-CHANGED OF NPSPANLG.aktivt IN FRAME Anlegg-Frame /* Aktivt */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.anbudsfrist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.anbudsfrist ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.anbudsfrist IN FRAME Anlegg-Frame /* Anbudsfrist */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.anlegg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.anlegg ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.anlegg IN FRAME Anlegg-Frame /* Anlegg */
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
          Current-Rec =  ROWID(NPSPANLG). 
          RUN visDetaljer.          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.anleggsnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.anleggsnr ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.anleggsnr IN FRAME Anlegg-Frame /* Anleggsnr */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.beskrevet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.beskrevet ANLEGGSBROWSER
ON VALUE-CHANGED OF NPSPANLG.beskrevet IN FRAME Anlegg-Frame /* Beskrevet */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.byggestart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.byggestart ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.byggestart IN FRAME Anlegg-Frame /* Byggestart */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.dato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.dato ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.dato IN FRAME Anlegg-Frame /* Dato */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.endrings_laas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.endrings_laas ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.endrings_laas IN FRAME Anlegg-Frame /* Låst for endring */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.entreprise
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.entreprise ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.entreprise IN FRAME Anlegg-Frame /* Entreprise */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.konsulentens_saksbeh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.konsulentens_saksbeh ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.konsulentens_saksbeh IN FRAME Anlegg-Frame /* v/ */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.kundedistriktNr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.kundedistriktNr ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.kundedistriktNr IN FRAME Anlegg-Frame /* Salgsdistrikt */
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


&Scoped-define SELF-NAME NPSPANLG.leveringstid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.leveringstid ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.leveringstid IN FRAME Anlegg-Frame /* Leveringstid */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME MAIN-MENU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MAIN-MENU ANLEGGSBROWSER
ON CHOOSE OF MENU MAIN-MENU
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
/*    anleggsnrParam = NPSPANLG.anleggsnr.*/
/*    anleggsNavnParam = NPSPANLG.anlegg. */
    Current-Rec = ROWID(NPSPANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data + "," + STRING(npspanlg.anleggsnr).
    RUN SPUSYST.W NO-ERROR.
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
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = FALSE. 
    IF AVAILABLE NPSPANLG THEN
    DO:
        anleggsnrParam = NPSPANLG.anleggsnr.
        Current-Rec = ROWID(NPSPANLG).
        IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data + "," + STRING(npspanlg.anleggsnr).
        RUN SPANLRED.W NO-ERROR.
        {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
         REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
          APPLY 'VALUE-CHANGED' TO Anleggs-Browse
           IN FRAME ANLEGG-FRAME.
          RUN visDetaljer.
            /* Set aktivtflagg på prosjektnivå */
            RUN SETAKTIV.P (INPUT prosjektidParam).
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Flytte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Flytte ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Flytte /* Flytte */
DO:
    DEFINE VAR detteAnlegg AS ROWID.
    DEFINE VAR detteProsjektet LIKE NORPROSJEKT.prosjektid.
    DEFINE VAR antall AS INTEGER.
        
    detteAnlegg = ROWID(NPSPANLG).
    detteProsjektet = NPSPANLG.prosjektId.
        
  /* La brukeren velge prosjektet som det skal kopieres til */
  RUN VELGPROS.W (OUTPUT nyttProsjektIdParam, INPUT 'Spiro').
  IF nyttProsjektIdParam = ? OR nyttProsjektIdParam = 0 THEN
    DO:
        MESSAGE 'Prosjekt ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
        RETURN NO-APPLY.
    END.

   /* Oppdater dette anlegget med ny prosjektid */
    FIND  NPSPANLG WHERE ROWID(NPSPANLG) = detteAnlegg NO-WAIT NO-ERROR.
    IF AVAILABLE NPSPANLG THEN DO:
        ASSIGN NPSPANLG.prosjektid = nyttProsjektIdParam. 

  /* Slå på spirovent flagg i dette prosjektet */
  UPDATE NORPROSJEKT SET spirovent = "Ja"  WHERE prosjektid = nyttProsjektIdParam.

  /* Dersom dette prosjektet ikke har flere spiroventanlegg, slå av spiroventflagg */
    SELECT COUNT(*) INTO antall FROM NPSPANLG  WHERE prosjektId = detteProsjektet.
    IF antall = 0 THEN
        UPDATE NORPROSJEKT SET spirovent = "Nei" WHERE prosjektid = detteProsjektet.

   /* Refresh browser */
    {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
/*    APPLY 'VALUE-CHANGED' TO Anleggs-Browse  IN FRAME ANLEGG-FRAME.
    RUN visDetaljer.
 */   
    END.   
    ELSE
        MESSAGE 'Anlegget lot seg ikke kopiere' VIEW-AS ALERT-BOX TITLE 'Feil'.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kopiere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kopiere ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Kopiere /* Kopiere */
DO:
    pointer = SESSION:SET-WAIT-STATE("GENERAL").      
    RUN kopiere_anlegg_til_temp. 
    RUN kopiere_anlegg_fra_temp.
    RUN kopiere_system_til_temp.
    RUN kopiere_system_fra_temp.    
    /* Åpne browser og reset row pointer */
     {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
      REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
      APPLY 'VALUE-CHANGED' TO Anleggs-Browse
         IN FRAME ANLEGG-FRAME.
    pointer =  SESSION:SET-WAIT-STATE("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Nytt /* Nytt... */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = TRUE. 
    
/*    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data + "," + STRING(prosjektidParam).*/
    RUN SPANLRED.W.
    FIND NPSPANLG WHERE ROWID(NPSPANLG) = Current-Rec NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE NPSPANLG THEN DO:
      {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
      REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
      APPLY 'VALUE-CHANGED' TO Anleggs-Browse IN FRAME ANLEGG-FRAME.
      
      RUN visDetaljer.           
      
      MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = YES.
      MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = YES.
      MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
      MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
      MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
      /* Sørg for at 'spirovent' på prosjektet settes til 'ja' */
      FIND NORPROSJEKT WHERE NORPROSJEKT.prosjektid = prosjektIdParam.
      IF AVAILABLE NORPROSJEKT THEN ASSIGN NORPROSJEKT.spirovent = 'Ja'.
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
      
    anleggsnrParam = NPSPANLG.anleggsnr.
    MESSAGE 'Vil du skrive ut oppfølgingsliste for dette anlegget?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Oppfølgingsliste'  UPDATE svar.
    IF svar THEN
   DO:
        /* Test om data finnes */
        SELECT COUNT(*) INTO funnet FROM  NPSPANLG, NPSPTILBUD, NPSPTOPP
        WHERE NPSPANLG.anleggsnr =  anleggsnrParam
              AND NPSPANLG.aktivt = TRUE 
              AND NOT NPSPTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPSPTOPP.oppf_status BEGINS 'ORDRE' 
              AND NPSPTILBUD.anleggsnr = NPSPANLG.anleggsnr
              AND NPSPTILBUD.id = NPSPTOPP.id .
        IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
        RUN aderb/_printrb.p
        ("report\norvent.prl",
        "Spirovent - oppf - ett anlegg",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPSPANLG.anleggsnr = " + string(anleggsnrParam) +
         " AND NPSPANLG.aktivt = TRUE 
         AND NOT NPSPTOPP.oppf_status BEGINS 'Tapt' 
         AND NOT NPSPTOPP.oppf_status BEGINS 'ORDRE'",
        "",
        "",
        hMainMenu:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Spiroventtilbud",
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
    DEFINE VAR cur_rec AS RECID.
    
      MESSAGE "Vil du slette dette anlegget med alle tilhørende system?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
           END.
         END CASE.
    /*  Dersom dette var siste anlegg - disable menyvalg */
    FIND FIRST NPSPANLG WHERE NPSPANLG.prosjektid = prosjektidParam NO-ERROR.
    IF NOT AVAILABLE NPSPANLG THEN
    DO:
          MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
          
        /* Sørg for at 'Aggregater' på prosjektet settes til 'nei' - goo (ikke i bruk)*/
/*        ASSIGN merkSisteParam = TRUE.*/
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_System
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_System ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_System /* System */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
/*    Current-Rec = ROWID(NPSPANLG).*/
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA + "," + STRING(npspanlg.anleggsnr).
    
    MENU-ITEM m_Nytt:SENSITIVE IN MENU MAIN-MENU = NO.  
    MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.  
    MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.  
    MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.  
    
    RUN SPSYSTEM.W  PERSISTENT SET p-handle.
    RUN appl_ent IN p-handle.
    
/*    hChild = JBoxMainMenu:Instance:StartChildWindow('wSPSystem.w',hParent:private-data,yes).*/
/*    if valid-handle(hChild) then do:                                                        */
/*      subscribe to 'InvalidateHandle' in hChild.                                            */
/*      dynamic-function('setParentHandle' in hChild,this-procedure).                         */
/*    end.                                                                                    */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbud
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbud ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Tilbud /* Tilbud */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
/*    anleggsnrParam = NPSPANLG.anleggsnr.*/
/*    anleggsNavnParam = NPSPANLG.anlegg. */
    Current-Rec = ROWID(NPSPANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data + "," + STRING(NPSPANLG.anleggsnr).
    RUN SPTILBUD.W  PERSISTENT SET p-handle.
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
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    Current-Rec = ROWID(NPSPANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data + "," + STRING(anleggsnrParam).
    RUN SHUSTAT1.W  PERSISTENT SET p-handle.
    RUN appl_ent IN p-handle.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.oppf_uke
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.oppf_uke ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.oppf_uke IN FRAME Anlegg-Frame /* Oppfølgingsuke */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.opplysninger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.opplysninger ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.opplysninger IN FRAME Anlegg-Frame /* Opplysninger */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.saksbehandler
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.saksbehandler ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.saksbehandler IN FRAME Anlegg-Frame /* Saksbeh. */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.selger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.selger ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.selger IN FRAME Anlegg-Frame /* Selger */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.selger ANLEGGSBROWSER
ON VALUE-CHANGED OF NPSPANLG.selger IN FRAME Anlegg-Frame /* Selger */
DO:
  RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.sikker
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.sikker ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.sikker IN FRAME Anlegg-Frame /* Sikker? */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.sikker ANLEGGSBROWSER
ON LEAVE OF NPSPANLG.sikker IN FRAME Anlegg-Frame /* Sikker? */
DO:
  RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPANLG.standardpris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPANLG.standardpris ANLEGGSBROWSER
ON ENTRY OF NPSPANLG.standardpris IN FRAME Anlegg-Frame /* Standardpris */
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
    
    /* Disse styrer MDI - simulering */
    /*05.11.2017 - tror ikke det er i bruk*/
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data.
    
    prosjektidparam = int(JBoxSession:Instance:getJBoxAttribute('ProsjektIdParam')).
    prosjektNavnParam = JBoxSession:Instance:getJBoxAttribute('ProsjektNavnParam').
    
    ANLEGGSBROWSER:TITLE = 'Spiroventanlegg for prosjekt: ' + prosjektNavnParam.  
  
    RUN MoveToTop.
    APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
    SESSION:SET-WAIT-STATE("").
    RUN enable_UI.
  
    DO WITH FRAME {&FRAME-NAME}:
      def var iGruppeId_saksbehandler as int no-undo.
      def var iGruppeId_selger as int no-undo.
      
      ASSIGN
        iGruppeId_saksbehandler       = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Saksbehandler"','iGruppeId')) 
        iGruppeId_selger              = int(JBoxServerAPI:Instance:FieldValues('Gruppe','Where GruppeNavn="Selger"','iGruppeId'))
        npspanlg.Entreprise:DELIMITER          = '|'
        npspanlg.Entreprise:LIST-ITEM-PAIRS    = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListEntreprise' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
        npspanlg.beskrevet:DELIMITER           = '|'
        npspanlg.beskrevet:LIST-ITEM-PAIRS     = JBoxServerAPI:Instance:FieldList("JBoxGenCode;cCodeValue;cCodeValue","WHERE cCodeType = 'DropListBeskrevet' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
        npspanlg.selger:DELIMITER              = '|'
        npspanlg.selger:LIST-ITEM-PAIRS        = JBoxServerAPI:Instance:FieldList("Persongruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
        /*    anleggstype:DELIMITER = '|'                                                                                                                                                                                                                                                            */
        /*    anleggstype:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPanleggstype,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_selger) + ", First Person of PersonGruppe where bAktiv AND person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")*/
        npspanlg.saksbehandler:DELIMITER       = '|'
        npspanlg.saksbehandler:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("PersonGruppe,person;cNavn;cNavn","WHERE iGruppeId = " + string(iGruppeId_saksbehandler) + ", First Person of PersonGruppe where bAktiv and person.iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") + " BY Person.cNavn")
        npspanlg.kundedistriktnr:DELIMITER       = '|'
        npspanlg.kundedistriktnr:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPkundedistrikt;Kundedistriktnr|KundeDistriktNavn;KundeDistriktNr","WHERE true" + ' BY KundedistriktNr')
        .
  
    OPEN QUERY ANLEGGSBROWSE   FOR EACH NPSPANLG 
            WHERE NPSPANLG.prosjektid = prosjektIdParam  NO-LOCK,
              EACH NPKUNDE OF NPSPANLG NO-LOCK
                BY norcalc.NPSPANLG.anleggsnr DESCENDING.
     IF AVAILABLE NPSPANLG THEN 
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
    APPLY "ENTRY" TO NPSPANLG.anleggsnr IN FRAME {&frame-name}.

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
  VIEW ANLEGGSBROWSER.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InvalidateHandle ANLEGGSBROWSER 
PROCEDURE InvalidateHandle :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  def input param ipHandle as handle no-undo.
  DO WITH FRAME {&FRAME-NAME}:
    MENU-ITEM m_Nytt:SENSITIVE IN MENU MAIN-MENU = YES.
    MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = YES.
    MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = YES.
    MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = YES.
    {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
    APPLY "VALUE-CHANGED" TO ANLEGGS-BROWSE IN FRAME ANLEGG-FRAME.
  END.

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
      define var cp_tabell_navn as char.

      cp_tabell_navn  = 'NPSPANLG'.
      run neste_id.p (input cp_tabell_navn, output ip_neste_id).

      icurAnleggsnr = NPSPANLG.anleggsnr.
    /* Ny record med kopierte verdier */
    create NPSPANLG.
    Current-Rec = ROWID(NPSPANLG).
    ASSIGN NPSPANLG.dato = TODAY
                     NPSPANLG.anleggsnr = ip_neste_id
                     NPSPANLG.prosjektId = tempAnlegg.prosjektId
                     NPSPANLG.anlegg = tempAnlegg.anlegg 
                     NPSPANLG.beskrevet = tempAnlegg.beskrevet
                     NPSPANLG.byggestart = tempAnlegg.byggestart
                     NPSPANLG.anbudsfrist = tempAnlegg.anbudsfrist
                     NPSPANLG.dato = tempAnlegg.dato
                     NPSPANLG.entreprise = tempAnlegg.entreprise
                     NPSPANLG.kundenr = tempAnlegg.kundenr
                     NPSPANLG.leveringsdato = tempAnlegg.leveringsdato
                     NPSPANLG.leveringstid = tempAnlegg.leveringstid
                     NPSPANLG.oppf_uke = tempAnlegg.oppf_uke
                     NPSPANLG.opplysninger = tempAnlegg.opplysninger
                     NPSPANLG.standardpris = tempAnlegg.standardpris
                    NPSPANLG.aktivt = tempAnlegg.aktivt 
                    NPSPANLG.arkivnr = tempAnlegg.arkivnr
                    NPSPANLG.konsulentens_saksbeh = tempAnlegg.konsulentens_saksbeh
                    NPSPANLG.konsulentid = tempAnlegg.konsulentid
                    NPSPANLG.oppf_aar = tempAnlegg.oppf_aar
                    NPSPANLG.referanse_tekst = tempAnlegg.referanse_tekst
                    NPSPANLG.saksbehandler = tempAnlegg.saksbehandler
                    NPSPANLG.salgsdistrikt = tempAnlegg.salgsdistrikt
                    npspanlg.kundedistriktnr = tempAnlegg.kundedistriktnr
                    NPSPANLG.selger = tempAnlegg.selger.
            
    pointer =  SESSION:SET-WAIT-STATE("").

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
    FIND FIRST tempAnlegg NO-WAIT NO-ERROR.
    IF NOT AVAILABLE tempAnlegg THEN RETURN.

    ASSIGN 
         tempAnlegg.anlegg = NPSPANLG.anlegg 
         tempAnlegg.prosjektId = NPSPANLG.prosjektId
         tempAnlegg.beskrevet = NPSPANLG.beskrevet 
         tempAnlegg.byggestart = NPSPANLG.byggestart 
         tempAnlegg.anbudsfrist =NPSPANLG.anbudsfrist 
         tempAnlegg.dato = NPSPANLG.dato 
         tempAnlegg.entreprise =NPSPANLG.entreprise 
         tempAnlegg.kundenr = NPSPANLG.kundenr
         tempAnlegg.leveringsdato = NPSPANLG.leveringsdato 
         tempAnlegg.leveringstid = NPSPANLG.leveringstid 
         tempAnlegg.oppf_uke = NPSPANLG.oppf_uke 
         tempAnlegg.opplysninger = NPSPANLG.opplysninger 
         tempAnlegg.standardpris = NPSPANLG.standardpris
         tempAnlegg.aktivt = NPSPANLG.aktivt 
         tempAnlegg.arkivnr = NPSPANLG.arkivnr
         tempAnlegg.konsulentens_saksbeh = NPSPANLG.konsulentens_saksbeh 
         tempAnlegg.konsulentid = NPSPANLG.konsulentid 
         tempAnlegg.oppf_aar = NPSPANLG.oppf_aar
         tempAnlegg.referanse_tekst = NPSPANLG.referanse_tekst 
         tempAnlegg.saksbehandler = NPSPANLG.saksbehandler 
         tempAnlegg.salgsdistrikt = NPSPANLG.salgsdistrikt 
         tempAnlegg.kundedistriktnr = NPSPANLG.kundedistriktnr 
         tempAnlegg.selger = NPSPANLG.selger.

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
               CREATE NPSPSYST.
        ASSIGN
                NPSPSYST.anleggsnr = tempSystem.anleggsnr 
                NPSPSYST.systemnr = tempSystem.systemnr
                NPSPSYST.anbefalt_max_kap = tempSystem.anbefalt_max_kap 
                NPSPSYST.anb_max_innl_hast = tempSystem.anb_max_innl_hast 
                NPSPSYST.anslutning = tempSystem.anslutning 
                NPSPSYST.antall = tempSystem.antall
                NPSPSYST.avstand_flotor = tempSystem.avstand_flotor 
                NPSPSYST.beregnet_anvendelse = tempSystem.beregnet_anvendelse 
                NPSPSYST.dimmensjon = tempSystem.dimmensjon 
                NPSPSYST.faktor = tempSystem.faktor 
                NPSPSYST.glykoltype = tempSystem.glykoltype.
         ASSIGN
                 NPSPSYST.innl_hastighet = tempSystem.innl_hastighet  
                 NPSPSYST.innmat = tempSystem.innmat
                 NPSPSYST.isolasjon = tempSystem.isolasjon 
                 NPSPSYST.konsentrasjon  = tempSystem.konsentrasjon 
                 NPSPSYST.kuleventil_ja_nei = tempSystem.kuleventil_ja_nei 
                 NPSPSYST.kuleventil_verdi = tempSystem.kuleventil_verdi 
                 NPSPSYST.listepris = tempSystem.listepris  
                 NPSPSYST.materialkvaliteter = tempSystem.materialkvaliteter 
                 NPSPSYST.max_temp = tempSystem.max_temp 
                 NPSPSYST.max_trykk = tempSystem.max_trykk 
                 NPSPSYST.medietemperatur = tempSystem.medietemperatur 
                 NPSPSYST.motflenser = tempSystem.motflenser 
                 NPSPSYST.nrf_nr = tempSystem.nrf_nr 
                 NPSPSYST.produktnavn = tempSystem.produktnavn 
                 NPSPSYST.produkttype = tempSystem.produkttype 
                 NPSPSYST.refill = tempSystem.refill 
                 NPSPSYST.ror_dim = tempSystem.ror_dim 
                 NPSPSYST.spiroventkapasitet = tempSystem.spiroventkapasitet.
    ASSIGN
                 NPSPSYST.systembetegnelse = tempSystem.systembetegnelse 
                 NPSPSYST.trykkfall = tempSystem.trykkfall 
                 NPSPSYST.utv_gjengeventil = tempSystem.utv_gjengeventil 
                 NPSPSYST.varenr = tempSystem.varenr 
                 NPSPSYST.vegg_tykkelse = tempSystem.vegg_tykkelse.
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
   FOR EACH NPSPSYST WHERE  NPSPSYST.anleggsnr = iCurAnleggsnr:    
                iNextSystem = iNextSystem + 1.
                CREATE tempSystem.
        ASSIGN
                tempSystem.anleggsnr = ip_Neste_Id                 
                tempSystem.systemnr = iNextSystem
                tempSystem.anbefalt_max_kap = NPSPSYST.anbefalt_max_kap 
                tempSystem.anb_max_innl_hast = NPSPSYST.anb_max_innl_hast 
                tempSystem.anslutning = NPSPSYST.anslutning 
                tempSystem.antall = NPSPSYST.antall 
                tempSystem.avstand_flotor = NPSPSYST.avstand_flotor 
                tempSystem.beregnet_anvendelse = NPSPSYST.beregnet_anvendelse 
                tempSystem.dimmensjon = NPSPSYST.dimmensjon 
                tempSystem.faktor = NPSPSYST.faktor 
                tempSystem.glykoltype = NPSPSYST.glykoltype.
         ASSIGN
                tempSystem.innl_hastighet  = NPSPSYST.innl_hastighet 
                tempSystem.innmat = NPSPSYST.innmat 
                tempSystem.isolasjon = NPSPSYST.isolasjon 
                tempSystem.konsentrasjon = NPSPSYST.konsentrasjon 
                tempSystem.kuleventil_ja_nei = NPSPSYST.kuleventil_ja_nei 
                tempSystem.kuleventil_verdi = NPSPSYST.kuleventil_verdi 
                tempSystem.listepris = NPSPSYST.listepris 
                tempSystem.materialkvaliteter = NPSPSYST.materialkvaliteter 
                tempSystem.max_temp = NPSPSYST.max_temp 
                tempSystem.max_trykk = NPSPSYST.max_trykk 
                tempSystem.medietemperatur = NPSPSYST.medietemperatur 
                tempSystem.motflenser = NPSPSYST.motflenser 
                tempSystem.nrf_nr = NPSPSYST.nrf_nr 
                tempSystem.produktnavn = NPSPSYST.produktnavn 
                tempSystem.produkttype = NPSPSYST.produkttype 
                tempSystem.refill = NPSPSYST.refill 
                tempSystem.ror_dim = NPSPSYST.ror_dim 
                tempSystem.spiroventkapasitet = NPSPSYST.spiroventkapasitet.
    ASSIGN
                tempSystem.systembetegnelse = NPSPSYST.systembetegnelse 
                tempSystem.trykkfall = NPSPSYST.trykkfall 
                tempSystem.utv_gjengeventil = NPSPSYST.utv_gjengeventil 
                tempSystem.varenr = NPSPSYST.varenr 
                tempSystem.vegg_tykkelse = NPSPSYST.vegg_tykkelse.
                
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE slettSPAnlegg ANLEGGSBROWSER 
PROCEDURE slettSPAnlegg :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
  pointer = SESSION:SET-WAIT-STATE("GENERAL").
  STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
  current-rec = rowid(NPSPANLG).
  DO TRANSACTION:
    FIND NPSPANLG WHERE rowid(NPSPANLG)  = current-rec EXCLUSIVE-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE(NPSPANLG) THEN DO:
      DELETE NPSPANLG.
    END.
    ELSE
      DO:
         MESSAGE 'Tabellen for spiroventanlegg er i bruk. Prøv igjen om en stund' 
             VIEW-AS ALERT-BOX TITLE 'Sletting'.
              RETURN.
         END.
  END.
  STATUS DEFAULT "                                                             ".
  pointer = SESSION:SET-WAIT-STATE("").
  {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
  GET FIRST Anleggs-Browse.
  IF AVAILABLE NPSPANLG THEN DO:
    current-rec =  Anleggs-Browse:get-buffer-handle(1):rowid IN FRAME Anlegg-Frame.
    APPLY 'VALUE-CHANGED' TO Anleggs-Browse.
  END.
  
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

FIND NPSPANLG WHERE  ROWID(NPSPANLG) = Current-Rec.
IF AVAILABLE NPSPANLG THEN
DO:
    dynamic-function('setAttribute',this-procedure,'anleggsnrParam',string(npspanlg.anleggsnr)).
    dynamic-function('setAttribute',this-procedure,'anleggsnavnParam',string(npspanlg.anlegg)).
    cKundenr = NPSPANLG.kundenr.    
    DISPLAY 
        NPSPANLG.anleggsnr  NPSPANLG.dato NPSPANLG.aktivt NPSPANLG.endrings_laas
        NPSPANLG.standardpris NPSPANLG.sikker
        NPSPANLG.anlegg NPSPANLG.kundedistriktnr NPSPANLG.saksbehandler
        NPSPANLG.konsulentens_saksbeh
        NPSPANLG.selger  NPSPANLG.entreprise NPSPANLG.beskrevet 
        NPSPANLG.anbudsfrist    NPSPANLG.byggestart  NPSPANLG.oppf_uke 
        NPSPANLG.leveringstid NPSPANLG.opplysninger        
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

