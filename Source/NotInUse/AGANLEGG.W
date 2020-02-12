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
DEFINE INPUT  PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER prosjektNavnParam LIKE NORPROSJEKT.prosjekt_navn.
/*DEFINE INPUT PARAMETER prosjektVindu AS HANDLE.*/
DEFINE VAR aggregatRetur AS LOGICAL INITIAL FALSE.
DEFINE NEW SHARED VAR anleggsnrParam LIKE NPAGANLG.anleggsnr.
DEFINE VAR sokeStreng AS CHAR.
DEFINE VAR sortStreng AS CHAR.
DEFINE SHARED VAR prosjektidParam LIKE NORPROSJEKT.prosjektid.

/* Local Variable Definitions ---                                       */
 DEFINE NEW SHARED VAR Current-Rec AS  ROWID.
 DEFINE VAR nyRecord AS LOGICAL.
 DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR anleggsRow AS LOGICAL.
DEFINE VAR Detail-Handle AS HANDLE.
DEFINE VAR anleggsNavnParam AS CHAR.
DEFINE NEW SHARED TEMP-TABLE tempAnlegg LIKE NPAGANLG.
DEFINE NEW SHARED TEMP-TABLE tempSystem LIKE NPSHSYST.
DEFINE NEW SHARED TEMP-TABLE tempTillegg LIKE NPSHTILLEGG.
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

DEFINE QUERY Nytt-Sok FOR NPAGANLG, NPKUNDE SCROLLING.

def var h as handle no-undo. /*dummy handle*/
h = session:first-procedure.

 
/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN
    THIS-PROCEDURE:PRIVATE-DATA = appdata.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Anlegg-Frame
&Scoped-define BROWSE-NAME Anleggs-Browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPAGANLG NPKUNDE

/* Definitions for BROWSE Anleggs-Browse                                */
&Scoped-define FIELDS-IN-QUERY-Anleggs-Browse NPAGANLG.anlegg NPAGANLG.dato ~
NPKUNDE.kundenavn NPAGANLG.oppf_uke NPAGANLG.anleggsnr NPAGANLG.entreprise ~
NPAGANLG.beskrevet NPAGANLG.salgsdistrikt NPAGANLG.standardpris ~
NPAGANLG.leveringsdato NPAGANLG.anbudsfrist NPAGANLG.endrings_laas ~
NPAGANLG.aktivt NPAGANLG.sikker 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Anleggs-Browse 
&Scoped-define OPEN-QUERY-Anleggs-Browse OPEN QUERY Anleggs-Browse FOR EACH NPAGANLG ~
      WHERE NPAGANLG.prosjektid = prosjektIdParam  NO-LOCK, ~
      EACH NPKUNDE OF NPAGANLG NO-LOCK ~
    BY NPAGANLG.dato DESCENDING.
&Scoped-define TABLES-IN-QUERY-Anleggs-Browse NPAGANLG NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-Anleggs-Browse NPAGANLG
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
      NPAGANLG, 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE Anleggs-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Anleggs-Browse ANLEGGSBROWSER _STRUCTURED
  QUERY Anleggs-Browse NO-LOCK DISPLAY
      NPAGANLG.anlegg FORMAT "X(45)":U
      NPAGANLG.dato FORMAT "99.99.9999":U
      NPKUNDE.kundenavn COLUMN-LABEL "Konsulent" FORMAT "X(30)":U
      NPAGANLG.oppf_uke FORMAT "99":U
      NPAGANLG.anleggsnr FORMAT ">>>>>9":U
      NPAGANLG.entreprise FORMAT "X(8)":U
      NPAGANLG.beskrevet FORMAT "X(8)":U
      NPAGANLG.salgsdistrikt FORMAT "X(30)":U
      NPAGANLG.standardpris FORMAT ">>,>>>,>>9.99":U
      NPAGANLG.leveringsdato FORMAT "99.99.9999":U
      NPAGANLG.anbudsfrist FORMAT "99.99.9999":U COLUMN-FONT 2
      NPAGANLG.endrings_laas FORMAT "ja/nei":U
      NPAGANLG.aktivt FORMAT "ja/nei":U
      NPAGANLG.sikker FORMAT "ja/nei":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 125 BY 4.86
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Anlegg-Frame
     Anleggs-Browse AT ROW 1 COL 1
     NPAGANLG.anleggsnr AT ROW 6 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.dato AT ROW 6 COL 44 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.standardpris AT ROW 6 COL 106 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.2 BY 1
          BGCOLOR 8 FGCOLOR 2 
     NPAGANLG.aktivt AT ROW 6.24 COL 64
          VIEW-AS TOGGLE-BOX
          SIZE 11.4 BY .76
          BGCOLOR 8 FGCOLOR 0 
     NPAGANLG.endrings_laas AT ROW 6.24 COL 78
          LABEL "Låst"
          VIEW-AS TOGGLE-BOX
          SIZE 9.8 BY .76
          BGCOLOR 8 FGCOLOR 12 
     NPAGANLG.anlegg AT ROW 7.19 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 53.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.sikker AT ROW 7.24 COL 80.4 COLON-ALIGNED
          LABEL "Sikker?"
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.4 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.salgsdistrikt AT ROW 8.33 COL 16 COLON-ALIGNED
          LABEL "Salgsdistr."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "10-Østfold","20-Oslo/Akershus","30-Hedmark/Oppland","40-Buskerud/Vestfold/Telemark","50-Aust og Vest-Agder/Rogaland","60-Hordaland/Sogn og Fjordane","70-Møre og Romsdal","80-Sør og Nord-Trøndelag","90-Nordland","100-Troms/Finnmark","110-Svalbard","200-Sverige","300-Finnland","400-Danmark","500-Tyskland","700-England","800-Spania" 
          DROP-DOWN-LIST
          SIZE 34.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.bruksomraade AT ROW 8.38 COL 80.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Standard Utendørs","Standard Innendørs","Skip","Offshore" 
          DROP-DOWN-LIST
          SIZE 24.2 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPKUNDE.kundenavn AT ROW 9.62 COL 16 COLON-ALIGNED
          LABEL "Konsulent"
          VIEW-AS FILL-IN NATIVE 
          SIZE 31.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGANLG.konsulentens_saksbeh AT ROW 9.62 COL 58.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 26.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGANLG.saksbehandler AT ROW 10.76 COL 16 COLON-ALIGNED
          LABEL "Saksbeh."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Arne Svensson","Arne Terkelsen","Kari Paulsen","Håkon A. Pedersen","Ronny Svensson","Arne Kristian Svensson","Erik Johnsen" 
          DROP-DOWN-LIST
          SIZE 24.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.selger AT ROW 10.76 COL 58.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Håkon A. Pedersen","Arne Svensson","Ronny Svensson","Arne Terkelsen","Steinar Aune","Erik Johnsen" 
          DROP-DOWN-LIST
          SIZE 24.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.batteri_oppvarming AT ROW 10.76 COL 105 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","El","Vann" 
          DROP-DOWN-LIST
          SIZE 16.8 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGANLG.entreprise AT ROW 12.05 COL 4.6
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","RØR ","VENT ","AUTO ","SKIP ","KULDE","FORPRO","ELEKTRO","TOTAL" 
          DROP-DOWN-LIST
          SIZE 15.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME Anlegg-Frame
     NPAGANLG.beskrevet AT ROW 12.05 COL 51.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","FRITT","KONK.","NOR","NVP","NOVEMA","COVENT","ABB","PM","WOLF","DANVENT","NOVENCO" 
          DROP-DOWN-LIST
          SIZE 12.2 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGANLG.batteri_kjoling AT ROW 12.05 COL 105 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ingen","DX","Vann" 
          DROP-DOWN-LIST
          SIZE 16.8 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGANLG.anbudsfrist AT ROW 12.19 COL 80.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.byggestart AT ROW 13.29 COL 16 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.oppf_uke AT ROW 13.29 COL 52 COLON-ALIGNED
          LABEL "Oppfølgingsuke"
          VIEW-AS FILL-IN NATIVE 
          SIZE 3.4 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.leveringstid AT ROW 13.33 COL 80.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 16.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPAGANLG.opplysninger AT ROW 14.43 COL 18 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL LARGE
          SIZE 94 BY 3.52
          BGCOLOR 8 FGCOLOR 1 FONT 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 126.6 BY 18.19
         FONT 2.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WINDOW
   Compile into: 
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW ANLEGGSBROWSER ASSIGN
         HIDDEN             = YES
         TITLE              = "Aggregatanlegg"
         COLUMN             = 41.4
         ROW                = 8.67
         HEIGHT             = 18.19
         WIDTH              = 126.8
         MAX-HEIGHT         = 20.71
         MAX-WIDTH          = 126.8
         VIRTUAL-HEIGHT     = 20.71
         VIRTUAL-WIDTH      = 126.8
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
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
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Anlegg-Frame
   UNDERLINE                                                            */
/* BROWSE-TAB Anleggs-Browse 1 Anlegg-Frame */
ASSIGN 
       FRAME Anlegg-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR TOGGLE-BOX NPAGANLG.aktivt IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPAGANLG.anbudsfrist IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPAGANLG.anlegg IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPAGANLG.anleggsnr IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPAGANLG.batteri_kjoling IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPAGANLG.batteri_oppvarming IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPAGANLG.beskrevet IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPAGANLG.bruksomraade IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPAGANLG.byggestart IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPAGANLG.dato IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX NPAGANLG.endrings_laas IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR COMBO-BOX NPAGANLG.entreprise IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR FILL-IN NPAGANLG.konsulentens_saksbeh IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPKUNDE.kundenavn IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPAGANLG.leveringstid IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPAGANLG.oppf_uke IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR EDITOR NPAGANLG.opplysninger IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR COMBO-BOX NPAGANLG.saksbehandler IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR COMBO-BOX NPAGANLG.salgsdistrikt IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR COMBO-BOX NPAGANLG.selger IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPAGANLG.sikker IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE EXP-LABEL                                       */
/* SETTINGS FOR FILL-IN NPAGANLG.standardpris IN FRAME Anlegg-Frame
   NO-DISPLAY NO-ENABLE                                                 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ANLEGGSBROWSER)
THEN ANLEGGSBROWSER:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Anleggs-Browse
/* Query rebuild information for BROWSE Anleggs-Browse
     _TblList          = "norcalc.NPAGANLG,norcalc.NPKUNDE OF norcalc.NPAGANLG"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPAGANLG.dato|no"
     _Where[1]         = "NPAGANLG.prosjektid = prosjektIdParam "
     _FldNameList[1]   = norcalc.NPAGANLG.anlegg
     _FldNameList[2]   = norcalc.NPAGANLG.dato
     _FldNameList[3]   > norcalc.NPKUNDE.kundenavn
"NPKUNDE.kundenavn" "Konsulent" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = norcalc.NPAGANLG.oppf_uke
     _FldNameList[5]   = norcalc.NPAGANLG.anleggsnr
     _FldNameList[6]   = norcalc.NPAGANLG.entreprise
     _FldNameList[7]   = norcalc.NPAGANLG.beskrevet
     _FldNameList[8]   = norcalc.NPAGANLG.salgsdistrikt
     _FldNameList[9]   = norcalc.NPAGANLG.standardpris
     _FldNameList[10]   = norcalc.NPAGANLG.leveringsdato
     _FldNameList[11]   > norcalc.NPAGANLG.anbudsfrist
"NPAGANLG.anbudsfrist" ? ? "date" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[12]   = norcalc.NPAGANLG.endrings_laas
     _FldNameList[13]   = norcalc.NPAGANLG.aktivt
     _FldNameList[14]   = norcalc.NPAGANLG.sikker
     _Query            is OPENED
*/  /* BROWSE Anleggs-Browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ANLEGGSBROWSER
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ANLEGGSBROWSER ANLEGGSBROWSER
ON HELP OF ANLEGGSBROWSER /* Aggregatanlegg */
DO:
  MESSAGE "This basic navigation window can be used to browse through " +
      "record in one or more tables. Lay out database fields onto " +
      "the frame. You may also add a browser for a table which is " +
      "joinable to the first." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.aktivt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.aktivt ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.aktivt IN FRAME Anlegg-Frame /* Aktivt */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.aktivt ANLEGGSBROWSER
ON VALUE-CHANGED OF NPAGANLG.aktivt IN FRAME Anlegg-Frame /* Aktivt */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.anbudsfrist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.anbudsfrist ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.anbudsfrist IN FRAME Anlegg-Frame /* Anbudsfrist */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.anlegg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.anlegg ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.anlegg IN FRAME Anlegg-Frame /* Anlegg */
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
          Current-Rec =  ROWID(NPAGANLG). 
          RUN visDetaljer.          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.anleggsnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.anleggsnr ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.anleggsnr IN FRAME Anlegg-Frame /* Anleggsnr */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.batteri_kjoling
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.batteri_kjoling ANLEGGSBROWSER
ON VALUE-CHANGED OF NPAGANLG.batteri_kjoling IN FRAME Anlegg-Frame /* Kjøling */
DO:
    RETURN NO-APPLY.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.batteri_oppvarming
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.batteri_oppvarming ANLEGGSBROWSER
ON VALUE-CHANGED OF NPAGANLG.batteri_oppvarming IN FRAME Anlegg-Frame /* Oppvarming */
DO:
    RETURN NO-APPLY.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.beskrevet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.beskrevet ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.beskrevet IN FRAME Anlegg-Frame /* Beskrevet */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.bruksomraade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.bruksomraade ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.bruksomraade IN FRAME Anlegg-Frame /* Bruksområde */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.byggestart
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.byggestart ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.byggestart IN FRAME Anlegg-Frame /* Byggestart */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.dato
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.dato ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.dato IN FRAME Anlegg-Frame /* Dato */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.endrings_laas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.endrings_laas ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.endrings_laas IN FRAME Anlegg-Frame /* Låst */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.entreprise
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.entreprise ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.entreprise IN FRAME Anlegg-Frame /* Entreprise */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.konsulentens_saksbeh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.konsulentens_saksbeh ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.konsulentens_saksbeh IN FRAME Anlegg-Frame /* v/ */
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


&Scoped-define SELF-NAME NPAGANLG.leveringstid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.leveringstid ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.leveringstid IN FRAME Anlegg-Frame /* Leveringstid */
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
    anleggsnrParam = NPAGANLG.anleggsnr.
    anleggsNavnParam = NPAGANLG.anlegg.
    Current-Rec = ROWID(NPAGANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN SHUSYST.W  (INPUT THIS-PROCEDURE:PRIVATE-DATA,  INPUT anleggsNavnParam) NO-ERROR.
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
    anleggsnrParam = NPAGANLG.anleggsnr.
    Current-Rec =  ROWID(NPAGANLG). 
     IF THIS-PROCEDURE:PERSISTENT THEN
         THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN AGANLRED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT prosjektNavnParam,
             INPUT-OUTPUT nyRecord) NO-ERROR.
        {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
     REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
     APPLY 'VALUE-CHANGED' TO Anleggs-Browse  IN FRAME ANLEGG-FRAME.
     RUN visDetaljer.
      /* Set aktivtflagg på prosjektnivå */
      RUN SETAKTIV.P (INPUT prosjektidParam).

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

    detteAnlegg = ROWID(NPAGANLG).
    detteProsjektet = NPAGANLG.prosjektId.
    
  /* La brukeren velge prosjektet som det skal kopieres til */
  RUN VELGPROS.W (OUTPUT nyttProsjektIdParam, INPUT 'Aggregat').
  IF nyttProsjektIdParam = ? OR nyttProsjektIdParam = 0 THEN
    DO:
        MESSAGE 'Prosjekt ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
        RETURN NO-APPLY.
    END.

   /* Oppdater dette anlegget med ny prosjektid */
    FIND  NPAGANLG WHERE ROWID(NPAGANLG) = detteAnlegg NO-WAIT NO-ERROR.
    IF AVAILABLE NPAGANLG THEN DO:
        ASSIGN NPAGANLG.prosjektid = nyttProsjektIdParam. 
  /* Slå på aggregat flagg i dette prosjektet */
  UPDATE NORPROSJEKT SET aggregater = "Ja"  WHERE prosjektid = nyttProsjektIdParam.

  /* Dersom dette prosjektet ikke har flere aggregatanlegg, slå av aggregatflagg */
    SELECT COUNT(*) INTO antall FROM NPAGANLG  WHERE prosjektId = detteProsjektet.
    IF antall = 0 THEN
        UPDATE NORPROSJEKT SET aggregater = "Nei" WHERE prosjektid = detteProsjektet.

   /* Refresh browser */
    {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
/*    APPLY 'VALUE-CHANGED' TO Anleggs-Browse  IN FRAME ANLEGG-FRAME.
    RUN visDetaljer.
    APPLY 'VALUE-CHANGED' TO Browse-Prosjekt  IN WINDOW PROSJEKTOVERSIKT.
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
 MESSAGE 'Kopiering av spirvoventanlegg er ikke ferdig ennå' view-as alert-box title 'Stopp'.
 RETURN NO-APPLY.
 /* 
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
*/         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Nytt /* Nytt... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = TRUE. 
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(prosjektidParam).
    RUN AGANLRED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT prosjektNavnParam,
        INPUT-OUTPUT nyRecord) NO-ERROR.
    FIND NPAGANLG WHERE ROWID(NPAGANLG) = Current-Rec NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE NPAGANLG THEN DO:
          {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
            REPOSITION Anleggs-Browse TO ROWID(Current-Rec).
            APPLY 'VALUE-CHANGED' TO Anleggs-Browse
                IN FRAME ANLEGG-FRAME.
          RUN visDetaljer.           
          MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = YES.
          MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
          /* Sørg for at 'agregater' på prosjektet settes til 'ja' */
          FIND NORPROSJEKT WHERE NORPROSJEKT.prosjektid = prosjektIdParam.
          IF AVAILABLE NORPROSJEKT THEN
            ASSIGN NORPROSJEKT.aggregater = 'Ja'.

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
      
    anleggsnrParam = NPAGANLG.anleggsnr.
    MESSAGE 'Vil du skrive ut oppfølgingsliste for dette anlegget?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Oppfølgingsliste'  UPDATE svar.
    IF svar THEN
   DO:
        /* Test om data finnes */
        SELECT COUNT(*) INTO funnet FROM  NPAGANLG, NPAGTILBUD, NPAGTOPP
        WHERE NPAGANLG.anleggsnr =  anleggsnrParam
              AND NPAGANLG.aktivt = TRUE 
              AND NOT NPAGTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPAGTOPP.oppf_status BEGINS 'ORDRE' 
              AND NPAGTILBUD.anleggsnr = NPAGANLG.anleggsnr
              AND NPAGTILBUD.id = NPAGTOPP.id .
        IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
        RUN aderb/_prntrb2.p
        ("report\noragg.prl",
        "Aggregat - oppf - ett anlegg",
        "-db norcalc -H 10.11.0.22 -S 4000 -U norcalc -P norcalc123",              
        "O", 
        "NPAGANLG.anleggsnr = " + string(anleggsnrParam) +
         " AND NPAGANLG.aktivt = TRUE 
         AND NOT NPAGTOPP.oppf_status BEGINS 'Tapt' 
         AND NOT NPAGTOPP.oppf_status BEGINS 'ORDRE'",
        "",
        "",
        h:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Aggregattilbud",
        yes,
        yes,
        no,
        "",
        "status.out").        
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
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = RECID(NPAGANLG).
                DO TRANSACTION:
                    FIND NPAGANLG WHERE RECID(NPAGANLG)  = cur_rec  EXCLUSIVE-LOCK
                        NO-ERROR NO-WAIT.
                     IF AVAILABLE(NPAGANLG) THEN
                             DO:
                                 DELETE NPAGANLG.
                                  pointer = SESSION:SET-WAIT-STATE("").
                                 {&OPEN-BROWSERS-IN-QUERY-Anlegg-Frame}
                               GET FIRST Anleggs-Browse.
                                  IF AVAILABLE NPAGANLG THEN 
                                      DO:
                                          anleggsRow =  Anleggs-Browse:SELECT-ROW(1) IN FRAME Anlegg-Frame.
                                          APPLY 'VALUE-CHANGED' TO Anleggs-Browse.
                                     END.
                             END.
                    ELSE
                      DO:
                         MESSAGE 'Tabellen for aggregatanlegg er i bruk. Prøv igjen om en stund' 
                             VIEW-AS ALERT-BOX TITLE 'Sletting'.
                          RETURN.
                     END.
                END.
           STATUS DEFAULT "                                                             ".
           END.
         END CASE.
    /*  Dersom dette var siste anlegg - disable menyvalg */
    FIND NPAGANLG WHERE NPAGANLG.prosjektid = prosjektidParam NO-ERROR.
    IF NOT AVAILABLE NPAGANLG THEN
    DO:
          MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
          MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
        /* Sørg for at 'Aggregater' på prosjektet settes til 'nei' */
        UPDATE  NORPROSJEKT SET aggregater = 'Nei'  WHERE NORPROSJEKT.prosjektid = prosjektIdParam.
    END.
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_System
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_System ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_System /* System */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    anleggsnrParam = NPAGANLG.anleggsnr.
    anleggsNavnParam = NPAGANLG.anlegg.
    Current-Rec = ROWID(NPAGANLG).
    RUN AGSYSTEM.W   (INPUT THIS-PROCEDURE:PRIVATE-DATA,  
        INPUT anleggsNavnParam, INPUT-OUTPUT aggregatRetur) NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbud
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbud ANLEGGSBROWSER
ON CHOOSE OF MENU-ITEM m_Tilbud /* Tilbud */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    anleggsnrParam = NPAGANLG.anleggsnr.
    anleggsNavnParam = NPAGANLG.anlegg.
    Current-Rec = ROWID(NPAGANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN AGTILBUD.W  PERSISTENT SET p-handle
        (INPUT THIS-PROCEDURE:PRIVATE-DATA,  INPUT anleggsNavnParam) NO-ERROR.
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
    Current-Rec = ROWID(NPAGANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN SHUSTAT1.W  PERSISTENT SET p-handle (INPUT THIS-PROCEDURE:PRIVATE-DATA ) NO-ERROR.
    RUN appl_ent IN p-handle.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.oppf_uke
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.oppf_uke ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.oppf_uke IN FRAME Anlegg-Frame /* Oppfølgingsuke */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.opplysninger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.opplysninger ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.opplysninger IN FRAME Anlegg-Frame /* Opplysninger */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.saksbehandler
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.saksbehandler ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.saksbehandler IN FRAME Anlegg-Frame /* Saksbeh. */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.salgsdistrikt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.salgsdistrikt ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.salgsdistrikt IN FRAME Anlegg-Frame /* Salgsdistr. */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.selger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.selger ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.selger IN FRAME Anlegg-Frame /* Selger */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.selger ANLEGGSBROWSER
ON VALUE-CHANGED OF NPAGANLG.selger IN FRAME Anlegg-Frame /* Selger */
DO:
  RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.sikker
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.sikker ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.sikker IN FRAME Anlegg-Frame /* Sikker? */
DO:
  RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.sikker ANLEGGSBROWSER
ON LEAVE OF NPAGANLG.sikker IN FRAME Anlegg-Frame /* Sikker? */
DO:
  RETURN NO-APPLY.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGANLG.standardpris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGANLG.standardpris ANLEGGSBROWSER
ON ENTRY OF NPAGANLG.standardpris IN FRAME Anlegg-Frame /* Standardpris */
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
    pointer = SESSION:SET-WAIT-STATE("").   

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    ANLEGGSBROWSER:TITLE = 'Aggregattanlegg for prosjekt: ' + prosjektNavnParam.  
  RUN enable_UI.
  OPEN QUERY ANLEGGSBROWSE   FOR EACH NPAGANLG 
          WHERE NPAGANLG.prosjektid = prosjektIdParam  NO-LOCK,
            EACH NPKUNDE OF NPAGANLG NO-LOCK
              BY norcalc.NPAGANLG.anleggsnr DESCENDING.
   IF AVAILABLE NPAGANLG THEN 
         APPLY 'VALUE-CHANGED' TO Anleggs-Browse.
    ELSE
    DO:
        MENU-ITEM m_System:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Tilbud:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
        MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = NO.
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
DEFINE VAR dOk AS LOGICAL.

/*APPLY "ENTRY" TO NPAGANLG.anleggsnr IN FRAME Anlegg-Frame.*/
IF {&WINDOW-NAME}:WINDOW-STATE = WINDOW-MINIMIZED THEN
    {&WINDOW-NAME}:WINDOW-STATE = WINDOW-NORMAL.

dOk =  {&WINDOW-NAME}:MOVE-TO-TOP().

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_anlegg_fra_temp ANLEGGSBROWSER 
PROCEDURE kopiere_anlegg_fra_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Nytt anleggsnr */
      define var cp_tabell_navn as char.

      cp_tabell_navn  = 'NPAGANLG'.
      run neste_id.p (input cp_tabell_navn, output ip_neste_id).

      icurAnleggsnr = NPAGANLG.anleggsnr.
    /* Ny record med kopierte verdier */
    create NPAGANLG.
    Current-Rec = ROWID(NPAGANLG).
    ASSIGN NPAGANLG.dato = TODAY
                     NPAGANLG.anleggsnr = ip_neste_id
                     NPAGANLG.prosjektId = tempAnlegg.prosjektId
                     NPAGANLG.anlegg = tempAnlegg.anlegg 
                     NPAGANLG.beskrevet = tempAnlegg.beskrevet
                     NPAGANLG.byggestart = tempAnlegg.byggestart
                     NPAGANLG.anbudsfrist = tempAnlegg.anbudsfrist
                     NPAGANLG.dato = tempAnlegg.dato
                     NPAGANLG.entreprise = tempAnlegg.entreprise
                     NPAGANLG.kundenr = tempAnlegg.kundenr
                     NPAGANLG.leveringsdato = tempAnlegg.leveringsdato
                     NPAGANLG.leveringstid = tempAnlegg.leveringstid
                     NPAGANLG.oppf_uke = tempAnlegg.oppf_uke
                     NPAGANLG.opplysninger = tempAnlegg.opplysninger
                     NPAGANLG.standardpris = tempAnlegg.standardpris.
            
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
 /* Legg verdier fra valgt anlegg inn i tempor‘rtabell - slett f›rt ev. poster */
    FOR EACH tempAnlegg:
       delete tempAnlegg.
    end.
    CREATE tempAnlegg.
    FIND FIRST tempAnlegg NO-WAIT NO-ERROR.
    IF NOT AVAILABLE tempAnlegg THEN RETURN.

    ASSIGN 
         tempAnlegg.anlegg = NPAGANLG.anlegg 
         tempAnlegg.prosjektId = NPAGANLG.prosjektId
         tempAnlegg.beskrevet = NPAGANLG.beskrevet 
         tempAnlegg.byggestart = NPAGANLG.byggestart 
         tempAnlegg.anbudsfrist =NPAGANLG.anbudsfrist 
         tempAnlegg.dato = NPAGANLG.dato 
         tempAnlegg.entreprise =NPAGANLG.entreprise 
         tempAnlegg.kundenr = NPAGANLG.kundenr
         tempAnlegg.leveringsdato = NPAGANLG.leveringsdato 
         tempAnlegg.leveringstid = NPAGANLG.leveringstid 
         tempAnlegg.oppf_uke = NPAGANLG.oppf_uke 
         tempAnlegg.opplysninger = NPAGANLG.opplysninger 
         tempAnlegg.standardpris = NPAGANLG.standardpris.

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
    /* T›m ev. temp. tabell */
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
DEFINE VAR cKundeNr LIKE NPKUNDE.kundenr.

FIND NPAGANLG WHERE  ROWID(NPAGANLG) = Current-Rec.
IF AVAILABLE NPAGANLG THEN
DO:
    cKundeNr = NPAGANLG.kundenr.    
    DISPLAY 
        NPAGANLG.anleggsnr  NPAGANLG.dato NPAGANLG.aktivt NPAGANLG.endrings_laas
        NPAGANLG.standardpris NPAGANLG.sikker
        NPAGANLG.anlegg NPAGANLG.salgsdistrikt  NPAGANLG.bruksomraade
        NPAGANLG.konsulentens_saksbeh
        NPAGANLG.selger  NPAGANLG.entreprise NPAGANLG.beskrevet 
        NPAGANLG.anbudsfrist    NPAGANLG.byggestart  NPAGANLG.oppf_uke 
        NPAGANLG.leveringstid NPAGANLG.opplysninger  NPAGANLG.batteri_oppvarming NPAGANLG.batteri_kjoling       
    WITH FRAM {&FRAME-NAME}.    
    FIND NPKUNDE WHERE NPKUNDE.kundenr = cKundeNr.
    IF AVAILABLE NPKUNDE THEN
        DISPLAY NPKUNDE.kundenavn  WITH FRAME {&FRAME-NAME}.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

