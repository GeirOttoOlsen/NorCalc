&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME Spiroventbrowser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Spiroventbrowser 
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
/*DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.    */
/*DEFINE INPUT-OUTPUT PARAMETER returSpiro AS LOGICAL.*/

/*DEFINE SHARED VARIABLE anleggsnrParam LIKE NPSHANLG.anleggsnr.*/
/*DEFINE NEW SHARED VARIABLE Current-Rec as ROWID.              */
/*DEFINE NEW SHARED VARIABLE systemnrParam LIKE NPSPSYST.systemnr.*/
def var anleggsNrParam like npspanlg.anleggsnr.
def var anleggsNavnParam like npspanlg.anlegg.

def var systemnrparam like NPSPSYST.systemnr.
def var current-rec as rowid.
def var hParent as handle no-undo.
DEFINE VAR nyRecord AS LOGICAL INITIAL FALSE.
DEFINE VAR tegningBmp AS CHAR. 
DEFINE VAR tegningOK AS LOGICAL.
DEFINE VAR syst# LIKE NPSPSYST.systemnr.
DEFINE VAR c_anvendelse AS CHARACTER.
c_anvendelse = 'VK'.

DEFINE VAR Detail-Handle AS HANDLE.
DEFINE VARIABLE stat AS LOGICAL.      /* Status return from methods */
DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL.  
DEFINE VAR systemRow AS LOGICAL.
DEFINE TEMP-TABLE tempSystem LIKE NPSPSYST.
DEFINE VAR tilleggUpdate AS LOGICAL INITIAL FALSE.
DEFINE VAR Current-Syst-Rec AS ROWID.

def var hMainMenu as handle no-undo. /*dummy handle*/
hMainMenu = session:first-procedure.

/* Local Variable Definitions ---                                       */

   DEFINE VARIABLE dbop-supported AS LOGICAL.
   DEFINE VARIABLE dbop-db-name AS CHARACTER.
   DEFINE VARIABLE dbop-tbl-name AS CHARACTER.
   DEFINE VARIABLE nav-stat AS LOGICAL.
   DEFINE VARIABLE browser-handle AS HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME System-Frame
&Scoped-define BROWSE-NAME System-Browse

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPSYST

/* Definitions for BROWSE System-Browse                                 */
&Scoped-define FIELDS-IN-QUERY-System-Browse NPSPSYST.produktnavn ~
NPSPSYST.systembetegnelse NPSPSYST.systemnr NPSPSYST.varenr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-System-Browse NPSPSYST.systemnr ~
NPSPSYST.varenr 
&Scoped-define ENABLED-TABLES-IN-QUERY-System-Browse NPSPSYST
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-System-Browse NPSPSYST
&Scoped-define QUERY-STRING-System-Browse FOR EACH NPSPSYST ~
      WHERE NPSPSYST.anleggsnr = anleggsnrParam NO-LOCK ~
    BY NPSPSYST.systemnr
&Scoped-define OPEN-QUERY-System-Browse OPEN QUERY System-Browse FOR EACH NPSPSYST ~
      WHERE NPSPSYST.anleggsnr = anleggsnrParam NO-LOCK ~
    BY NPSPSYST.systemnr.
&Scoped-define TABLES-IN-QUERY-System-Browse NPSPSYST
&Scoped-define FIRST-TABLE-IN-QUERY-System-Browse NPSPSYST


/* Definitions for FRAME System-Frame                                   */
&Scoped-define OPEN-BROWSERS-IN-QUERY-System-Frame ~
    ~{&OPEN-QUERY-System-Browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSPSYST.systemnr NPSPSYST.systembetegnelse ~
NPSPSYST.beregnet_anvendelse NPSPSYST.anslutning NPSPSYST.isolasjon ~
NPSPSYST.materialkvaliteter NPSPSYST.max_temp NPSPSYST.max_trykk ~
NPSPSYST.medietemperatur NPSPSYST.kuleventil_ja_nei ~
NPSPSYST.utv_gjengeventil NPSPSYST.refill NPSPSYST.motflenser ~
NPSPSYST.glykoltype NPSPSYST.konsentrasjon NPSPSYST.spiroventkapasitet ~
NPSPSYST.dimmensjon NPSPSYST.innl_hastighet NPSPSYST.antall ~
NPSPSYST.listepris 
&Scoped-define ENABLED-TABLES NPSPSYST
&Scoped-define FIRST-ENABLED-TABLE NPSPSYST
&Scoped-Define ENABLED-OBJECTS System-Browse FILL-IN-produktnavn SYSTEMPRIS 
&Scoped-Define DISPLAYED-FIELDS NPSPSYST.systembetegnelse ~
NPSPSYST.beregnet_anvendelse NPSPSYST.anslutning NPSPSYST.isolasjon ~
NPSPSYST.materialkvaliteter NPSPSYST.max_temp NPSPSYST.max_trykk ~
NPSPSYST.medietemperatur NPSPSYST.kuleventil_ja_nei ~
NPSPSYST.utv_gjengeventil NPSPSYST.refill NPSPSYST.motflenser ~
NPSPSYST.glykoltype NPSPSYST.konsentrasjon NPSPSYST.spiroventkapasitet ~
NPSPSYST.dimmensjon NPSPSYST.innl_hastighet NPSPSYST.antall ~
NPSPSYST.listepris 
&Scoped-define DISPLAYED-TABLES NPSPSYST
&Scoped-define FIRST-DISPLAYED-TABLE NPSPSYST
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-produktnavn SYSTEMPRIS 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRec Spiroventbrowser 
FUNCTION getCurrentRec RETURNS ROWID
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNyRecord Spiroventbrowser 
FUNCTION getNyRecord RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentRec Spiroventbrowser 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR Spiroventbrowser AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_System 
       MENU-ITEM m_Nytt         LABEL "&Nytt..."       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre"         ACCELERATOR "CTRL-E"
       MENU-ITEM m_Slette       LABEL "S&lette..."    
       MENU-ITEM m_Kopiere      LABEL "&Kopiere"      .

DEFINE SUB-MENU m_Utskrift 
       MENU-ITEM m_Utskrift_til_saksmappe LABEL "&Utskrift til saksmappe".

DEFINE MENU MAIN-MENU MENUBAR
       SUB-MENU  m_System       LABEL "&System"       
       SUB-MENU  m_Utskrift     LABEL "Utskr&ift"     
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-produktnavn AS CHARACTER FORMAT "X(60)":U 
     LABEL "Produktnavn" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 48.4 BY 1.24
     BGCOLOR 8 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE SYSTEMPRIS AS INTEGER FORMAT ">>>,>>9.99":U INITIAL 0 
     LABEL "Systempris" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 19.6 BY 1.24
     BGCOLOR 8 FGCOLOR 1 FONT 2 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY System-Browse FOR 
      NPSPSYST SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE System-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS System-Browse Spiroventbrowser _STRUCTURED
  QUERY System-Browse NO-LOCK DISPLAY
      NPSPSYST.produktnavn FORMAT "X(45)":U
      NPSPSYST.systembetegnelse FORMAT "X(40)":U
      NPSPSYST.systemnr FORMAT ">>>>>9":U
      NPSPSYST.varenr FORMAT "9999999":U
  ENABLE
      NPSPSYST.systemnr
      NPSPSYST.varenr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 124 BY 7.14
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME System-Frame
     System-Browse AT ROW 1.14 COL 2
     NPSPSYST.systemnr AT ROW 8.62 COL 96 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2.8 BY 1.24
     NPSPSYST.systembetegnelse AT ROW 8.67 COL 26.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 58 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     FILL-IN-produktnavn AT ROW 10.1 COL 26.8 COLON-ALIGNED
     NPSPSYST.beregnet_anvendelse AT ROW 10.1 COL 90.8 COLON-ALIGNED
          LABEL "Anv.omr."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Varme","Lavtemperatur","Kjøle","Fryse","Varmegjenvinning","Ukjent" 
          DROP-DOWN-LIST
          SIZE 31 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.anslutning AT ROW 11.43 COL 26.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Gjenget","Union","Klemkopling","Sveisestuss","Flens DIN2632","Flens DIN2633" 
          DROP-DOWN-LIST
          SIZE 31 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.isolasjon AT ROW 11.43 COL 90.8 COLON-ALIGNED
          LABEL "Mantel/Isol."
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Mineralull","Cellegummi 13mm","Cellegummi 19mm","Cellegummi 24mm" 
          DROP-DOWN-LIST
          SIZE 31 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.materialkvaliteter AT ROW 12.81 COL 27 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Standard ihht brosjyre","ST.37.2","MESSING","AISI 304","AISI 316","Spesial" 
          DROP-DOWN-LIST
          SIZE 40.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.max_temp AT ROW 12.81 COL 86 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.max_trykk AT ROW 12.81 COL 113.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.medietemperatur AT ROW 14.19 COL 26.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.2 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.kuleventil_ja_nei AT ROW 14.43 COL 44.2
          VIEW-AS TOGGLE-BOX
          SIZE 15.6 BY .95
     NPSPSYST.utv_gjengeventil AT ROW 14.43 COL 60.4
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .95
     NPSPSYST.refill AT ROW 14.43 COL 90.8
          VIEW-AS TOGGLE-BOX
          SIZE 11.2 BY .95
     NPSPSYST.motflenser AT ROW 14.43 COL 103.4
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .95
     NPSPSYST.glykoltype AT ROW 15.62 COL 26.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 4
          LIST-ITEMS "Ingen","Monoetylenglykol","Monopropylenglykol","Ukjent" 
          DROP-DOWN-LIST
          SIZE 33.8 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.konsentrasjon AT ROW 15.62 COL 90.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEMS "0","5","10","15","20","25","30","35","40","45","50","Ukjent" 
          DROP-DOWN-LIST
          SIZE 17 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.spiroventkapasitet AT ROW 17 COL 26.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.dimmensjon AT ROW 18.38 COL 26.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 65 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 125.61 BY 20.53
         FONT 2.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME System-Frame
     NPSPSYST.innl_hastighet AT ROW 18.38 COL 109.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.6 BY 1.24
          BGCOLOR 8 FGCOLOR 1 
     NPSPSYST.antall AT ROW 19.81 COL 26.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.8 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSPSYST.listepris AT ROW 19.81 COL 51 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          BGCOLOR 8 FGCOLOR 1 FONT 2
     SYSTEMPRIS AT ROW 20 COL 90.8 COLON-ALIGNED
     "l/sek." VIEW-AS TEXT
          SIZE 7.8 BY .76 AT ROW 17.38 COL 45.6
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 125.61 BY 20.53
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
  CREATE WINDOW Spiroventbrowser ASSIGN
         HIDDEN             = YES
         TITLE              = "Spiroventsystem"
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 20.52
         WIDTH              = 126
         MAX-HEIGHT         = 24.76
         MAX-WIDTH          = 128
         VIRTUAL-HEIGHT     = 24.76
         VIRTUAL-WIDTH      = 128
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MAIN-MENU:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Spiroventbrowser
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME System-Frame
   UNDERLINE                                                            */
/* BROWSE-TAB System-Browse TEXT-1 System-Frame */
ASSIGN 
       FRAME System-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR COMBO-BOX NPSPSYST.beregnet_anvendelse IN FRAME System-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR COMBO-BOX NPSPSYST.isolasjon IN FRAME System-Frame
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN NPSPSYST.systemnr IN FRAME System-Frame
   NO-DISPLAY                                                           */
ASSIGN 
       NPSPSYST.systemnr:HIDDEN IN FRAME System-Frame           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Spiroventbrowser)
THEN Spiroventbrowser:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE System-Browse
/* Query rebuild information for BROWSE System-Browse
     _TblList          = "norcalc.NPSPSYST"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPSPSYST.systemnr|yes"
     _Where[1]         = "NPSPSYST.anleggsnr = anleggsnrParam"
     _FldNameList[1]   = norcalc.NPSPSYST.produktnavn
     _FldNameList[2]   = norcalc.NPSPSYST.systembetegnelse
     _FldNameList[3]   > norcalc.NPSPSYST.systemnr
"NPSPSYST.systemnr" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > norcalc.NPSPSYST.varenr
"NPSPSYST.varenr" ? ? "integer" ? ? ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE System-Browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Spiroventbrowser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Spiroventbrowser Spiroventbrowser
ON HELP OF Spiroventbrowser /* Spiroventsystem */
DO:
  MESSAGE "This basic navigation window can be used to browse through " +
      "record in one or more tables. Lay out database fields onto " +
      "the frame. You may also add a browser for a table which is " +
      "joinable to the first." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.anslutning
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.anslutning Spiroventbrowser
ON ENTRY OF NPSPSYST.anslutning IN FRAME System-Frame /* Anslutning */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.antall
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.antall Spiroventbrowser
ON ENTRY OF NPSPSYST.antall IN FRAME System-Frame /* Antall */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.beregnet_anvendelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.beregnet_anvendelse Spiroventbrowser
ON ENTRY OF NPSPSYST.beregnet_anvendelse IN FRAME System-Frame /* Anv.omr. */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.dimmensjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.dimmensjon Spiroventbrowser
ON ENTRY OF NPSPSYST.dimmensjon IN FRAME System-Frame /* Dimmensjon */
DO:
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-produktnavn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-produktnavn Spiroventbrowser
ON ENTRY OF FILL-IN-produktnavn IN FRAME System-Frame /* Produktnavn */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.glykoltype
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.glykoltype Spiroventbrowser
ON ENTRY OF NPSPSYST.glykoltype IN FRAME System-Frame /* Glykoltype */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.innl_hastighet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.innl_hastighet Spiroventbrowser
ON ENTRY OF NPSPSYST.innl_hastighet IN FRAME System-Frame /* Innl.hast. */
DO:
      RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.isolasjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.isolasjon Spiroventbrowser
ON ENTRY OF NPSPSYST.isolasjon IN FRAME System-Frame /* Mantel/Isol. */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.konsentrasjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.konsentrasjon Spiroventbrowser
ON ENTRY OF NPSPSYST.konsentrasjon IN FRAME System-Frame /* Konsentrasjon */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.kuleventil_ja_nei
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.kuleventil_ja_nei Spiroventbrowser
ON ENTRY OF NPSPSYST.kuleventil_ja_nei IN FRAME System-Frame /* Kuleventil */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.listepris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.listepris Spiroventbrowser
ON ENTRY OF NPSPSYST.listepris IN FRAME System-Frame /* Listepris */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.materialkvaliteter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.materialkvaliteter Spiroventbrowser
ON ENTRY OF NPSPSYST.materialkvaliteter IN FRAME System-Frame /* Materialkvaliteter */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.max_temp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.max_temp Spiroventbrowser
ON ENTRY OF NPSPSYST.max_temp IN FRAME System-Frame /* Max temp. */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.max_trykk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.max_trykk Spiroventbrowser
ON ENTRY OF NPSPSYST.max_trykk IN FRAME System-Frame /* Max trykk */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.medietemperatur
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.medietemperatur Spiroventbrowser
ON ENTRY OF NPSPSYST.medietemperatur IN FRAME System-Frame /* Medietemperatur */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.motflenser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.motflenser Spiroventbrowser
ON ENTRY OF NPSPSYST.motflenser IN FRAME System-Frame /* Motflenser */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt Spiroventbrowser
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre Spiroventbrowser
ON CHOOSE OF MENU-ITEM m_Endre /* Endre */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal system ikke kunne endres */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPSPANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
ELSE
    DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = FALSE.
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:PRIVATE-DATA + "," + STRING(npspanlg.anleggsnr).
    RUN SPSYSRED.W.
    {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
    REPOSITION System-Browse TO ROWID(Current-Rec).
    browse {&browse-name}:refresh().
     APPLY 'VALUE-CHANGED' TO System-Browse IN FRAME System-FRAME.
    APPLY "GO" TO FRAME System-Frame.
 END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kopiere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kopiere Spiroventbrowser
ON CHOOSE OF MENU-ITEM m_Kopiere /* Kopiere */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal det ikke kunne legges inn nye system */
 FIND FIRST NPSPTILBUD WHERE NPSPTILBUD.anleggsnr = anleggsnrParam NO-ERROR.
 IF AVAILABLE NPSPTILBUD THEN
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
         {&OPEN-BROWSERS-IN-QUERY-System-Frame}
           REPOSITION System-Browse TO ROWID(Current-Syst-Rec).
          APPLY 'VALUE-CHANGED' TO System-Browse
              IN FRAME System-FRAME.
        pointer =  SESSION:SET-WAIT-STATE("").
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt Spiroventbrowser
ON CHOOSE OF MENU-ITEM m_Nytt /* Nytt... */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal det ikke kunne legges inn nye system */
  /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPSPANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
    END.
    ELSE DO:
      pointer =  SESSION:SET-WAIT-STATE("GENERAL").
      nyRecord = TRUE.
      dynamic-function('setAttribute',this-procedure,'AnleggsNr',anleggsNrParam).
      dynamic-function('setAttribute',this-procedure,'AnleggsNavn',anleggsNavnParam).
      IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data + "," + STRING(NPSPANLG.anleggsnr).
      RUN SPSYSRED.W.
      OPEN QUERY System-Browse   FOR EACH NPSPSYST WHERE NPSPSYST.anleggsnr = anleggsnrParam NO-LOCK  BY NPSPSYST.systemnr.
      FIND NPSPSYST WHERE ROWID(NPSPSYST) = Current-Rec NO-LOCK NO-ERROR NO-WAIT.
      IF AVAILABLE NPSPSYST THEN DO:
        REPOSITION System-Browse TO ROWID(Current-Rec).
        APPLY 'VALUE-CHANGED' TO System-Browse  IN FRAME System-FRAME.
        RUN visDetaljer.           
        MENU-ITEM m_Utskrift_til_saksmappe:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = YES.
        MENU-ITEM m_Kopiere:SENSITIVE IN MENU MAIN-MENU = YES.
      END.
      APPLY "GO" TO FRAME System-Frame.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette Spiroventbrowser
ON CHOOSE OF MENU-ITEM m_Slette /* Slette... */
DO:
  /* Dersom det er gitt tilbud på dette anlegget skal ikke enkeltsystem kunne slettes */
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPSPANLG WHERE anleggsnr = anleggsnrParam.
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
                cur_rec = ROWID(NPSPSYST).
                FIND NPSPSYST WHERE ROWID(NPSPSYST)  = cur_rec  EXCLUSIVE-LOCK NO-WAIT
                    NO-ERROR.
                IF AVAILABLE(NPSPSYST) THEN
                    DELETE NPSPSYST.
                STATUS DEFAULT.
                pointer = SESSION:SET-WAIT-STATE("").
                RUN enable_UI.
                {&OPEN-BROWSERS-IN-QUERY-Browser-Frame}
                GET FIRST System-Browse.   
                IF AVAILABLE NPSPSYST THEN 
                    DO:
                        systemRow =  System-Browse:SELECT-ROW(1) IN FRAME System-Frame.
                        APPLY 'VALUE-CHANGED' TO System-Browse.
                    END.
                ELSE
                    DO:
                        MENU-ITEM m_Endre:SENSITIVE IN MENU MAIN-MENU = NO.
                        MENU-ITEM m_Slette:SENSITIVE IN MENU MAIN-MENU = NO.
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Utskrift_til_saksmappe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Utskrift_til_saksmappe Spiroventbrowser
ON CHOOSE OF MENU-ITEM m_Utskrift_til_saksmappe /* Utskrift til saksmappe */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    FIND NPSPANLG WHERE anleggsnr = anleggsnrParam NO-ERROR.
    IF NOT AVAILABLE NPSPANLG THEN
        MESSAGE 'Får ikke kontakt med anleggstabellen' VIEW-AS ALERT-BOX TITLE 'FEIL'.
    ELSE
    DO:    
    MESSAGE 'Utskrift av  teknisk spesifikasjon til saksmappe?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Teknisk Spesifikasjon - Spirovent'  UPDATE svar.
    IF svar THEN do:
        pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    /* Skriv teknisk spesifikasjon */
    RUN aderb/_printrb.p
        ("report\norvent.prl",
       "Tekn. spes. saksmappe",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
       "NPSPANLG.anleggsnr = " + string(anleggsnrParam),
        "",
        "",
        hMainMenu:private-data,
        "",
        "",
        1,
        1,
        9999,
        no,
        "Teknisk spesifikasjon til saksmappe-Spirovent",
        yes,
        yes,
        no,
        "").        
            pointer =  SESSION:SET-WAIT-STATE("").
end.
    END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.refill
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.refill Spiroventbrowser
ON ENTRY OF NPSPSYST.refill IN FRAME System-Frame /* Refill */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.spiroventkapasitet
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.spiroventkapasitet Spiroventbrowser
ON ENTRY OF NPSPSYST.spiroventkapasitet IN FRAME System-Frame /* Kapasitet */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME System-Browse
&Scoped-define SELF-NAME System-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse Spiroventbrowser
ON LEFT-MOUSE-CLICK OF System-Browse IN FRAME System-Frame
DO:
    APPLY 'VALUE-CHANGED' TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse Spiroventbrowser
ON LEFT-MOUSE-DBLCLICK OF System-Browse IN FRAME System-Frame
DO:
  APPLY 'CHOOSE' TO MENU-ITEM m_Endre IN MENU MAIN-MENU.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL System-Browse Spiroventbrowser
ON VALUE-CHANGED OF System-Browse IN FRAME System-Frame
DO:
    /* Vis systemdetaljer */
    IF AVAILABLE NPSPSYST THEN 
    DO:
        Current-Rec = ROWID(NPSPSYST).
        systemnrParam = NPSPSYST.systemnr.
        ASSIGN SYSTEMPRIS = (NPSPSYST.antall * NPSPSYST.listepris).
        RUN visDetaljer.
        
    /* Vis riktig tegning */
/*    CASE SELF:SCREEN-VALUE:
        WHEN 'Spirotop' THEN
                tegningBmp = 'spirotop.bmp'.
        WHEN 'Junior' THEN
                tegningBmp = 'junior.bmp'.
        WHEN 'Senior' THEN
                tegningBmp = 'senior.bmp'.
        WHEN 'Dirt' THEN
                tegningBmp = 'dirt.bmp'.
        WHEN 'Superior' THEN
                tegningBmp = 'superior.bmp'.
        WHEN 'Drain' THEN
                tegningBmp = 'drain.bmp'.
        WHEN 'Kanalvarmere' THEN
                tegningBmp = 'kanal.bmp'.
        WHEN 'Spirotube' THEN
                tegningBmp = 'spirotub.bmp'.
    END CASE.
     tegningOK = SPIROVENTTEGNING:LOAD-IMAGE (tegningBmp,0,0,140,202).
     DISPLAY SPIROVENTTEGNING WITH FRAME Dialog-Frame.
*/
    /* Dersom beregninger er foretatt - gi tilgang til tilbehør, ellers ikke */
/*    IF NPSPSYST.kvs_hovedport > 0 THEN
         MENU-ITEM m_Tilbehr:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = YES.
     ELSE
         MENU-ITEM m_Tilbehr:SENSITIVE IN MENU MENU-BAR-SYSTEM-WINDOW = NO.*/
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.systembetegnelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.systembetegnelse Spiroventbrowser
ON ENTRY OF NPSPSYST.systembetegnelse IN FRAME System-Frame /* Systembetegnelse */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SYSTEMPRIS
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SYSTEMPRIS Spiroventbrowser
ON ENTRY OF SYSTEMPRIS IN FRAME System-Frame /* Systempris */
DO:
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSPSYST.utv_gjengeventil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSPSYST.utv_gjengeventil Spiroventbrowser
ON ENTRY OF NPSPSYST.utv_gjengeventil IN FRAME System-Frame /* Utv. gjenget lufteventil */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Spiroventbrowser 


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
    hParent = source-procedure.
    THIS-PROCEDURE:CURRENT-WINDOW:X = hParent:Current-window:X + 10.
    THIS-PROCEDURE:CURRENT-WINDOW:Y = hParent:current-window:Y + 10.
    DYNAMIC-FUNCTION("DoLockWindow",this-procedure:CURRENT-WINDOW).
  /* Disse styrer MDI - simulering */
  IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = hParent:private-data.
  anleggsNrParam   = int(dynamic-function('getAttribute',hParent,'AnleggsnrParam')).
  anleggsNavnParam = dynamic-function('getAttribute',hParent,'AnleggsNavnParam').
  Spiroventbrowser:TITLE = 'Spiroventsystem for anlegg: ' + anleggsNavnParam.  
   RUN MoveToTop.
    APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
    SESSION:SET-WAIT-STATE("").
  RUN enable_UI.
  OPEN QUERY System-Browse   FOR EACH NPSPSYST 
      WHERE NPSPSYST.anleggsnr = anleggsnrParam NO-LOCK
    BY NPSPSYST.systemnr.
    IF AVAILABLE NPSPSYST THEN 
          APPLY 'VALUE-CHANGED' TO System-Browse.
    ELSE
    DO:
        MENU-ITEM m_Utskrift_til_saksmappe:SENSITIVE IN MENU MAIN-MENU = NO.
    END.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE anleggsPris Spiroventbrowser 
PROCEDURE anleggsPris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR sumAnlegg AS DECIMAL.

  sumAnlegg = 0.
  FOR EACH NPSPSYST WHERE NPSPSYST.anleggsnr = anleggsnrParam NO-LOCK:
        sumAnlegg = sumAnlegg +  (NPSPSYST.antall * NPSPSYST.listepris).
  END.
  FIND NPSPANLG WHERE NPSPANLG.anleggsnr = anleggsnrParam EXCLUSIVE-LOCK 
    NO-WAIT NO-ERROR.
  IF AVAILABLE NPSPANLG THEN
      ASSIGN NPSPANLG.standardpris = sumAnlegg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent Spiroventbrowser 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  APPLY "ENTRY" TO NPSPSYST.systemnr IN FRAME {&frame-name}.
  HIDE NPSPSYST.systemnr.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Spiroventbrowser  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Spiroventbrowser)
  THEN DELETE WIDGET Spiroventbrowser.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Spiroventbrowser  _DEFAULT-ENABLE
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
  DISPLAY FILL-IN-produktnavn SYSTEMPRIS 
      WITH FRAME System-Frame IN WINDOW Spiroventbrowser.
  IF AVAILABLE NPSPSYST THEN 
    DISPLAY NPSPSYST.systembetegnelse NPSPSYST.beregnet_anvendelse 
          NPSPSYST.anslutning NPSPSYST.isolasjon NPSPSYST.materialkvaliteter 
          NPSPSYST.max_temp NPSPSYST.max_trykk NPSPSYST.medietemperatur 
          NPSPSYST.kuleventil_ja_nei NPSPSYST.utv_gjengeventil NPSPSYST.refill 
          NPSPSYST.motflenser NPSPSYST.glykoltype NPSPSYST.konsentrasjon 
          NPSPSYST.spiroventkapasitet NPSPSYST.dimmensjon 
          NPSPSYST.innl_hastighet NPSPSYST.antall NPSPSYST.listepris 
      WITH FRAME System-Frame IN WINDOW Spiroventbrowser.
  ENABLE System-Browse NPSPSYST.systemnr NPSPSYST.systembetegnelse 
         FILL-IN-produktnavn NPSPSYST.beregnet_anvendelse NPSPSYST.anslutning 
         NPSPSYST.isolasjon NPSPSYST.materialkvaliteter NPSPSYST.max_temp 
         NPSPSYST.max_trykk NPSPSYST.medietemperatur NPSPSYST.kuleventil_ja_nei 
         NPSPSYST.utv_gjengeventil NPSPSYST.refill NPSPSYST.motflenser 
         NPSPSYST.glykoltype NPSPSYST.konsentrasjon NPSPSYST.spiroventkapasitet 
         NPSPSYST.dimmensjon NPSPSYST.innl_hastighet NPSPSYST.antall 
         NPSPSYST.listepris SYSTEMPRIS 
      WITH FRAME System-Frame IN WINDOW Spiroventbrowser.
  {&OPEN-BROWSERS-IN-QUERY-System-Frame}
  VIEW Spiroventbrowser.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Hide_Win Spiroventbrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_system_fra_temp Spiroventbrowser 
PROCEDURE kopiere_system_fra_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        /* Kopier ny record */
       CREATE NPSPSYST.
       Current-Syst-Rec = ROWID(NPSPSYST).
        ASSIGN
                  NPSPSYST.anleggsnr = tempSystem.anleggsnr
                  NPSPSYST.systemnr = tempSystem.systemnr
                  NPSPSYST.anbefalt_max_kap = tempSystem.anbefalt_max_kap
                  NPSPSYST.anb_max_innl_hast = tempSystem.anb_max_innl_hast
                  NPSPSYST.anslutning  = tempSystem.anslutning
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
                  NPSPSYST.konsentrasjon = tempSystem.konsentrasjon
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
                  NPSPSYST.produkttype= tempSystem.produkttype.
        ASSIGN
                  NPSPSYST.refill = tempSystem.refill
                  NPSPSYST.ror_dim = tempSystem.ror_dim
                  NPSPSYST.spiroventkapasitet = tempSystem.spiroventkapasitet
                  NPSPSYST.systembetegnelse = tempSystem.systembetegnelse
                  NPSPSYST.trykkfall = tempSystem.trykkfall
                  NPSPSYST.utv_gjengeventil = tempSystem.utv_gjengeventil
                  NPSPSYST.varenr = tempSystem.varenr
                  NPSPSYST.vegg_tykkelse = tempSystem.vegg_tykkelse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE kopiere_system_til_temp Spiroventbrowser 
PROCEDURE kopiere_system_til_temp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VAR kopiertSystem AS ROWID.
DEFINE VAR nesteSystemnr AS INTEGER.

    /* Kopier alle system - om det finnes  */
    kopiertSystem = ROWID(NPSPSYST).       
    /* Finn sist brukte systemnr */
    FIND LAST NPSPSYST WHERE anleggsnr = anleggsnrParam 
        USE-INDEX ndx_sp_anleggsnr_systemnr   NO-WAIT NO-ERROR.
    nesteSystemnr = NPSPSYST.systemnr + 1.
    CREATE tempSystem.
    FIND NPSPSYST WHERE ROWID(NPSPSYST) = kopiertSystem NO-WAIT NO-ERROR.
        ASSIGN
                  tempSystem.anleggsnr = anleggsnrParam
                  tempSystem.systemnr = nesteSystemnr
                  tempSystem.anbefalt_max_kap =  NPSPSYST.anbefalt_max_kap 
                  tempSystem.anb_max_innl_hast = NPSPSYST.anb_max_innl_hast 
                  tempSystem.anslutning = NPSPSYST.anslutning 
                  tempSystem.antall = NPSPSYST.antall 
                  tempSystem.avstand_flotor = NPSPSYST.avstand_flotor 
                  tempSystem.beregnet_anvendelse =NPSPSYST.beregnet_anvendelse 
                  tempSystem.dimmensjon = NPSPSYST.dimmensjon 
                  tempSystem.faktor = NPSPSYST.faktor 
                  tempSystem.glykoltype = NPSPSYST.glykoltype.
        ASSIGN
                  tempSystem.innl_hastighet = NPSPSYST.innl_hastighet 
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
                  tempSystem.produkttype = NPSPSYST.produkttype.
        ASSIGN
                  tempSystem.refill = NPSPSYST.refill 
                  tempSystem.ror_dim = NPSPSYST.ror_dim 
                  tempSystem.spiroventkapasitet = NPSPSYST.spiroventkapasitet 
                  tempSystem.systembetegnelse = NPSPSYST.systembetegnelse 
                  tempSystem.trykkfall = NPSPSYST.trykkfall 
                  tempSystem.utv_gjengeventil = NPSPSYST.utv_gjengeventil 
                  tempSystem.varenr = NPSPSYST.varenr 
                  tempSystem.vegg_tykkelse = NPSPSYST.vegg_tykkelse.
                  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop Spiroventbrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE View_Win Spiroventbrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE visDetaljer Spiroventbrowser 
PROCEDURE visDetaljer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
FIND NPSPSYST WHERE  ROWID(NPSPSYST) = Current-Rec.
IF AVAILABLE NPSPSYST THEN
    FILL-IN-produktnavn = NPSPSYST.produktnavn.
  DISPLAY NPSPSYST.systembetegnelse 
         FILL-IN-produktnavn NPSPSYST.beregnet_anvendelse NPSPSYST.anslutning 
         NPSPSYST.motflenser NPSPSYST.isolasjon NPSPSYST.materialkvaliteter 
         NPSPSYST.medietemperatur NPSPSYST.kuleventil_ja_nei NPSPSYST.utv_gjengeventil 
         NPSPSYST.refill  NPSPSYST.motflenser NPSPSYST.max_temp NPSPSYST.max_trykk
         NPSPSYST.glykoltype NPSPSYST.konsentrasjon NPSPSYST.spiroventkapasitet 
         NPSPSYST.dimmensjon 
         NPSPSYST.innl_hastighet 
         NPSPSYST.antall NPSPSYST.listepris SYSTEMPRIS 
      WITH FRAME System-Frame IN WINDOW Spiroventbrowser.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRec Spiroventbrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNyRecord Spiroventbrowser 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentRec Spiroventbrowser 
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

