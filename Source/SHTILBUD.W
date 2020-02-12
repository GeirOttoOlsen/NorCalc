&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME Tilbuds-Window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Tilbuds-Window 
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

def var appdata as char no-undo. /*setter den via JboxSession:AppTitle*/
appdata = JBoxSession:Instance:AppTitle.
def var hParent as handle no-undo.

/*DEFINE INPUT  PARAMETER appdata AS CHARACTER.                 */
/*DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.              */
/*DEFINE SHARED VARIABLE Current-Rec as ROWID.                  */
/*DEFINE NEW SHARED VAR tilbudsIdParam LIKE NPSHTILBUD.id.      */
/*DEFINE SHARED VAR prosjektidParam LIKE NORPROSJEKT.prosjektid.*/
DEFINE VAR tilbudsnrParam LIKE NPSHTILBUD.tilbudsnr.
def var TilbudsidParam like npshtilbud.tilbudsid.
def var nyRecord as log.
DEFINE VARIABLE anleggsnrParam LIKE NPSHANLG.anleggsnr.
DEFINE var anleggsNavnParam AS CHAR.
/*DEFINE VAR Current-Tilleggs-Rec AS  ROWID.*/
/*DEFINE VAR Current-Oppf-Rec AS ROWID.     */
DEFINE VAR prosjektidParam LIKE NORPROSJEKT.prosjektid.
/* Local Variable Definitions ---                                       */

/*DEFINE NEW SHARED VAR Current-Tilbuds-Rec AS  ROWID.    */
/*DEFINE NEW SHARED VAR Current-Tilleggs-Rec AS  ROWID.   */
/*DEFINE NEW SHARED VAR Current-Oppf-Rec AS ROWID.        */
/*DEFINE NEW SHARED VAR nyRecord AS LOGICAL INITIAL FALSE.*/
def var current-rec as rowid.

DEFINE VAR tilbudsRow AS LOGICAL.
DEFINE VAR tilleggsRow AS LOGICAL.
DEFINE VAR oppfRow AS LOGICAL.
DEFINE VARIABLE dbop-supported AS LOGICAL.
DEFINE VARIABLE dbop-db-name AS CHARACTER.
DEFINE VARIABLE dbop-tbl-name AS CHARACTER.
DEFINE VARIABLE nav-stat AS LOGICAL.
DEFINE VARIABLE browser-handle AS HANDLE.

/*def var h as handle no-undo. /*dummy handle*/*/
/*h = session:first-procedure.                 */

/* Disse styrer MDI - simulering */
IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Oppf_frame
&Scoped-define BROWSE-NAME OPPF_BROWSE

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTOPP NPSHTILBUD NPKUNDE NPSHTILLEGG

/* Definitions for BROWSE OPPF_BROWSE                                   */
&Scoped-define FIELDS-IN-QUERY-OPPF_BROWSE NPSHTOPP.oppf_uke ~
NPSHTOPP.oppf_dato NPSHTOPP.oppf_status NPSHTOPP.neste_oppf_uke ~
NPSHTOPP.neste_oppf NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 ~
NPSHTOPP.tiltak NPSHTOPP.id 
&Scoped-define ENABLED-FIELDS-IN-QUERY-OPPF_BROWSE 
&Scoped-define QUERY-STRING-OPPF_BROWSE FOR EACH NPSHTOPP ~
      WHERE NPSHTOPP.id = tilbudsIdParam NO-LOCK ~
    BY NPSHTOPP.id DESCENDING
&Scoped-define OPEN-QUERY-OPPF_BROWSE OPEN QUERY OPPF_BROWSE FOR EACH NPSHTOPP ~
      WHERE NPSHTOPP.id = tilbudsIdParam NO-LOCK ~
    BY NPSHTOPP.id DESCENDING.
&Scoped-define TABLES-IN-QUERY-OPPF_BROWSE NPSHTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-OPPF_BROWSE NPSHTOPP


/* Definitions for BROWSE Tilbuds-Browse                                */
&Scoped-define FIELDS-IN-QUERY-Tilbuds-Browse NPKUNDE.kundenavn ~
NPSHTILBUD.tilbudsnr NPSHTILBUD.tilbudsdato ~
STRING(NPSHTILBUD.pris  - (NPSHTILBUD.pris * NPSHTILBUD.rabatt%) / 100, ">,>>>,999") ~
NPSHTILBUD.rabatt% NPSHTILBUD.pris NPSHTILBUD.pris_shuntgrupper ~
NPSHTILBUD.pris_tillegg 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Tilbuds-Browse 
&Scoped-define QUERY-STRING-Tilbuds-Browse FOR EACH NPSHTILBUD ~
      WHERE NPSHTILBUD.anleggsnr = anleggsnrParam NO-LOCK, ~
      EACH NPKUNDE OF NPSHTILBUD NO-LOCK ~
    BY NPSHTILBUD.tilbudsdato DESCENDING
&Scoped-define OPEN-QUERY-Tilbuds-Browse OPEN QUERY Tilbuds-Browse FOR EACH NPSHTILBUD ~
      WHERE NPSHTILBUD.anleggsnr = anleggsnrParam NO-LOCK, ~
      EACH NPKUNDE OF NPSHTILBUD NO-LOCK ~
    BY NPSHTILBUD.tilbudsdato DESCENDING.
&Scoped-define TABLES-IN-QUERY-Tilbuds-Browse NPSHTILBUD NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-Tilbuds-Browse NPSHTILBUD
&Scoped-define SECOND-TABLE-IN-QUERY-Tilbuds-Browse NPKUNDE


/* Definitions for BROWSE Tilleggs-Browse                               */
&Scoped-define FIELDS-IN-QUERY-Tilleggs-Browse NPSHTILLEGG.artikkelnr ~
NPSHTILLEGG.artikkelnavn NPSHTILLEGG.pris NPSHTILLEGG.antall ~
NPSHTILLEGG.kostpris NPSHTILLEGG.paaslag_faktor NPSHTILLEGG.med_i_ordre 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Tilleggs-Browse ~
NPSHTILLEGG.med_i_ordre 
&Scoped-define ENABLED-TABLES-IN-QUERY-Tilleggs-Browse NPSHTILLEGG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Tilleggs-Browse NPSHTILLEGG
&Scoped-define QUERY-STRING-Tilleggs-Browse FOR EACH NPSHTILLEGG ~
      WHERE NPSHTILLEGG.id = tilbudsIdParam NO-LOCK ~
    BY NPSHTILLEGG.artikkelnavn
&Scoped-define OPEN-QUERY-Tilleggs-Browse OPEN QUERY Tilleggs-Browse FOR EACH NPSHTILLEGG ~
      WHERE NPSHTILLEGG.id = tilbudsIdParam NO-LOCK ~
    BY NPSHTILLEGG.artikkelnavn.
&Scoped-define TABLES-IN-QUERY-Tilleggs-Browse NPSHTILLEGG
&Scoped-define FIRST-TABLE-IN-QUERY-Tilleggs-Browse NPSHTILLEGG


/* Definitions for FRAME Oppf_frame                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Oppf_frame ~
    ~{&OPEN-QUERY-OPPF_BROWSE}

/* Definitions for FRAME Tilbuds-Frame                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame ~
    ~{&OPEN-QUERY-Tilbuds-Browse}

/* Definitions for FRAME Tilleggs-Frame                                 */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Tilleggs-Frame ~
    ~{&OPEN-QUERY-Tilleggs-Browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS OPPF_BROWSE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRec Tilbuds-Window 
FUNCTION getCurrentRec RETURNS ROWID
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNyRecord Tilbuds-Window 
FUNCTION getNyRecord RETURNS LOGICAL
  () FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentRec Tilbuds-Window 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR Tilbuds-Window AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Tilbud 
       MENU-ITEM m_Nytt         LABEL "&Nytt..."       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre        LABEL "&Endre..."      ACCELERATOR "CTRL-E"
              DISABLED
       MENU-ITEM m_Slette       LABEL "&Slette..."     ACCELERATOR "CTRL-S"
              DISABLED
       MENU-ITEM m_Til_referanseliste LABEL "&Til referanseliste..."
              DISABLED.

DEFINE SUB-MENU m_Tillegg 
       MENU-ITEM m_Nytt2        LABEL "&Nytt..."      
              DISABLED
       MENU-ITEM m_Endre2       LABEL "&Endre..."     
              DISABLED
       MENU-ITEM m_Slette2      LABEL "&Slette..."    
              DISABLED.

DEFINE SUB-MENU m_Oppflging 
       MENU-ITEM m_Ny_oppf      LABEL "&Ny..."        
              DISABLED
       MENU-ITEM m_Endre_oppf   LABEL "&Endre..."     
              DISABLED
       MENU-ITEM m_Slette_oppf  LABEL "&Slette..."    .

DEFINE SUB-MENU m_Ordre 
       MENU-ITEM m_Ordregrunnlag LABEL "&Ordregrunnlag..."
       MENU-ITEM m_Utskrift_av_Ordregrunnlag LABEL "&Utskrift av Ordregrunnlag".

DEFINE SUB-MENU m_Utskrift 
       MENU-ITEM m_Tilbudsbrev  LABEL "&Tilbudsbrev"  
              DISABLED
       MENU-ITEM m_Tekn_spes_standard LABEL "Tekn. spes. &standard"
       MENU-ITEM m_Tekn_spes_koder LABEL "Tekn. spes. &koder"
       MENU-ITEM m_Tekn_spes_alle_opplysninger LABEL "Tekn. spes. alle opplysninger"
       MENU-ITEM m_Tekn_spes_alle_upris LABEL "Tekn. spes. alle opplysninger uten pris".

DEFINE MENU MENU-BAR-TILBUDS-WINDOW MENUBAR
       SUB-MENU  m_Tilbud       LABEL "&Tilbud"       
       SUB-MENU  m_Tillegg      LABEL "T&illegg"      
       SUB-MENU  m_Oppflging    LABEL "&Oppfølging"   
       SUB-MENU  m_Ordre        LABEL "O&rdre"        
       SUB-MENU  m_Utskrift     LABEL "&Utskrift"     
       MENU-ITEM m_Avslutt      LABEL "&Avslutt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY OPPF_BROWSE FOR 
      NPSHTOPP SCROLLING.

DEFINE QUERY Tilbuds-Browse FOR 
      NPSHTILBUD, 
      NPKUNDE SCROLLING.

DEFINE QUERY Tilleggs-Browse FOR 
      NPSHTILLEGG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE OPPF_BROWSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS OPPF_BROWSE Tilbuds-Window _STRUCTURED
  QUERY OPPF_BROWSE NO-LOCK DISPLAY
      NPSHTOPP.oppf_uke FORMAT ">9":U
      NPSHTOPP.oppf_dato FORMAT "99.99.9999":U
      NPSHTOPP.oppf_status FORMAT "X(15)":U COLUMN-FGCOLOR 12 LABEL-FGCOLOR 1 LABEL-BGCOLOR 12
      NPSHTOPP.neste_oppf_uke FORMAT ">9":U
      NPSHTOPP.neste_oppf FORMAT "99.99.9999":U
      NPSHTOPP.kriterium_1 FORMAT "X(25)":U COLUMN-FGCOLOR 1 LABEL-FGCOLOR 1 LABEL-BGCOLOR 8
      NPSHTOPP.kriterium_2 FORMAT "X(25)":U COLUMN-FGCOLOR 1 LABEL-FGCOLOR 1 LABEL-BGCOLOR 8
      NPSHTOPP.tiltak FORMAT "X(15)":U COLUMN-FGCOLOR 1 LABEL-FGCOLOR 1 LABEL-BGCOLOR 8
      NPSHTOPP.id FORMAT ">>>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 65.8 BY 7
         BGCOLOR 15 FGCOLOR 1 FONT 2.

DEFINE BROWSE Tilbuds-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Tilbuds-Browse Tilbuds-Window _STRUCTURED
  QUERY Tilbuds-Browse NO-LOCK DISPLAY
      NPKUNDE.kundenavn FORMAT "X(30)":U COLUMN-FONT 2
      NPSHTILBUD.tilbudsnr FORMAT "X(20)":U COLUMN-FONT 2
      NPSHTILBUD.tilbudsdato FORMAT "99.99.9999":U COLUMN-FONT 2
      STRING(NPSHTILBUD.pris  - (NPSHTILBUD.pris * NPSHTILBUD.rabatt%) / 100, ">,>>>,999") COLUMN-LABEL "Avgitt Pris" FORMAT "x(9)":U
            COLUMN-FONT 2
      NPSHTILBUD.rabatt% FORMAT "->>9.99":U COLUMN-FONT 2
      NPSHTILBUD.pris FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.pris_shuntgrupper FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.pris_tillegg FORMAT ">>>,>>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 125.4 BY 10.1
         FONT 2.

DEFINE BROWSE Tilleggs-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Tilleggs-Browse Tilbuds-Window _STRUCTURED
  QUERY Tilleggs-Browse NO-LOCK DISPLAY
      NPSHTILLEGG.artikkelnr FORMAT "X(8)":U COLUMN-FGCOLOR 4 LABEL-FGCOLOR 4 LABEL-BGCOLOR 8
      NPSHTILLEGG.artikkelnavn FORMAT "X(30)":U COLUMN-FGCOLOR 4 LABEL-FGCOLOR 4 LABEL-BGCOLOR 8
      NPSHTILLEGG.pris FORMAT ">>>,>>9.99":U COLUMN-FGCOLOR 3 LABEL-FGCOLOR 3 LABEL-BGCOLOR 8
      NPSHTILLEGG.antall FORMAT ">>9":U COLUMN-FGCOLOR 4 LABEL-FGCOLOR 4 LABEL-BGCOLOR 8
      NPSHTILLEGG.kostpris FORMAT ">>>,>>9.99":U COLUMN-FGCOLOR 4 LABEL-FGCOLOR 4 LABEL-BGCOLOR 8
      NPSHTILLEGG.paaslag_faktor FORMAT "9.99":U COLUMN-FGCOLOR 4 LABEL-FGCOLOR 4 LABEL-BGCOLOR 8
      NPSHTILLEGG.med_i_ordre FORMAT "ja/nei":U COLUMN-FGCOLOR 2
  ENABLE
      NPSHTILLEGG.med_i_ordre
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 58.6 BY 7
         FGCOLOR 4 FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Tilleggs-Frame
     Tilleggs-Browse AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 11.1
         SIZE 59.21 BY 8
         BGCOLOR 15 FGCOLOR 4 
         TITLE FGCOLOR 4 "Tillegg":L.

DEFINE FRAME Oppf_frame
     OPPF_BROWSE AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 60 ROW 11.1
         SIZE 66.8 BY 8
         BGCOLOR 15 FGCOLOR 1 FONT 2
         TITLE "Oppfølging".

DEFINE FRAME Tilbuds-Frame
     Tilbuds-Browse AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 126 BY 10.1.


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
  CREATE WINDOW Tilbuds-Window ASSIGN
         HIDDEN             = YES
         TITLE              = "Tilbud for shuntanlegg"
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 18.19
         WIDTH              = 126
         MAX-HEIGHT         = 18.33
         MAX-WIDTH          = 126
         VIRTUAL-HEIGHT     = 18.33
         VIRTUAL-WIDTH      = 126
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-TILBUDS-WINDOW:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT Tilbuds-Window:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT Tilbuds-Window:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Tilbuds-Window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME Oppf_frame
                                                                        */
/* BROWSE-TAB OPPF_BROWSE 1 Oppf_frame */
/* SETTINGS FOR FRAME Tilbuds-Frame
   UNDERLINE                                                            */
/* BROWSE-TAB Tilbuds-Browse 1 Tilbuds-Frame */
/* SETTINGS FOR FRAME Tilleggs-Frame
                                                                        */
/* BROWSE-TAB Tilleggs-Browse 1 Tilleggs-Frame */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Tilbuds-Window)
THEN Tilbuds-Window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE OPPF_BROWSE
/* Query rebuild information for BROWSE OPPF_BROWSE
     _TblList          = "norcalc.NPSHTOPP"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPSHTOPP.id|no"
     _Where[1]         = "NPSHTOPP.id = tilbudsIdParam"
     _FldNameList[1]   = norcalc.NPSHTOPP.oppf_uke
     _FldNameList[2]   = norcalc.NPSHTOPP.oppf_dato
     _FldNameList[3]   > norcalc.NPSHTOPP.oppf_status
"NPSHTOPP.oppf_status" ? ? "character" ? 12 ? 12 1 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = norcalc.NPSHTOPP.neste_oppf_uke
     _FldNameList[5]   = norcalc.NPSHTOPP.neste_oppf
     _FldNameList[6]   > norcalc.NPSHTOPP.kriterium_1
"NPSHTOPP.kriterium_1" ? ? "character" ? 1 ? 8 1 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > norcalc.NPSHTOPP.kriterium_2
"NPSHTOPP.kriterium_2" ? ? "character" ? 1 ? 8 1 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > norcalc.NPSHTOPP.tiltak
"NPSHTOPP.tiltak" ? ? "character" ? 1 ? 8 1 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   = norcalc.NPSHTOPP.id
     _Query            is OPENED
*/  /* BROWSE OPPF_BROWSE */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Tilbuds-Browse
/* Query rebuild information for BROWSE Tilbuds-Browse
     _TblList          = "norcalc.NPSHTILBUD,norcalc.NPKUNDE OF norcalc.NPSHTILBUD"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPSHTILBUD.tilbudsdato|no"
     _Where[1]         = "NPSHTILBUD.anleggsnr = anleggsnrParam"
     _FldNameList[1]   > norcalc.NPKUNDE.kundenavn
"NPKUNDE.kundenavn" ? ? "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > norcalc.NPSHTILBUD.tilbudsnr
"NPSHTILBUD.tilbudsnr" ? ? "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > norcalc.NPSHTILBUD.tilbudsdato
"NPSHTILBUD.tilbudsdato" ? ? "date" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"STRING(NPSHTILBUD.pris  - (NPSHTILBUD.pris * NPSHTILBUD.rabatt%) / 100, "">,>>>,999"")" "Avgitt Pris" "x(9)" ? ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > norcalc.NPSHTILBUD.rabatt%
"NPSHTILBUD.rabatt%" ? ? "decimal" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   = norcalc.NPSHTILBUD.pris
     _FldNameList[7]   = norcalc.NPSHTILBUD.pris_shuntgrupper
     _FldNameList[8]   = norcalc.NPSHTILBUD.pris_tillegg
     _Query            is OPENED
*/  /* BROWSE Tilbuds-Browse */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Tilleggs-Browse
/* Query rebuild information for BROWSE Tilleggs-Browse
     _TblList          = "norcalc.NPSHTILLEGG"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPSHTILLEGG.artikkelnavn|yes"
     _Where[1]         = "NPSHTILLEGG.id = tilbudsIdParam"
     _FldNameList[1]   > norcalc.NPSHTILLEGG.artikkelnr
"NPSHTILLEGG.artikkelnr" ? ? "character" ? 4 ? 8 4 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > norcalc.NPSHTILLEGG.artikkelnavn
"NPSHTILLEGG.artikkelnavn" ? ? "character" ? 4 ? 8 4 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > norcalc.NPSHTILLEGG.pris
"NPSHTILLEGG.pris" ? ? "decimal" ? 3 ? 8 3 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > norcalc.NPSHTILLEGG.antall
"NPSHTILLEGG.antall" ? ? "integer" ? 4 ? 8 4 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > norcalc.NPSHTILLEGG.kostpris
"NPSHTILLEGG.kostpris" ? ? "decimal" ? 4 ? 8 4 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > norcalc.NPSHTILLEGG.paaslag_faktor
"NPSHTILLEGG.paaslag_faktor" ? ? "decimal" ? 4 ? 8 4 ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > norcalc.NPSHTILLEGG.med_i_ordre
"NPSHTILLEGG.med_i_ordre" ? ? "logical" ? 2 ? ? ? ? yes ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE Tilleggs-Browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Tilbuds-Window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tilbuds-Window Tilbuds-Window
ON HELP OF Tilbuds-Window /* Tilbud for shuntanlegg */
DO:
  MESSAGE "This basic navigation window can be used to browse through " +
      "record in one or more tables. Lay out database fields onto " +
      "the frame. You may also add a browser for a table which is " +
      "joinable to the first." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Endre /* Endre... */
DO:
    DEFINE VAR nyId AS INTEGER INITIAL 0.     

    SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + String(NPSHTILBUD.tilbudsid).
    current-rec = ROWID(NPSHTILBUD).
    nyRecord = FALSE.
    RUN SHTLBRED.W.
    IF nyId > 0 THEN DO:
        /* Oppdater avgitt pris for dette tilbudet */
        FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD) = current-rec EXCLUSIVE-LOCK 
            NO-WAIT NO-ERROR.    
        IF AVAILABLE NPSHTILBUD THEN DO:
        ASSIGN NPSHTILBUD.avgittpris = 
             (NPSHTILBUD.pris - (NPSHTILBUD.pris  *  NPSHTILBUD.rabatt%) / 100).

          {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
            REPOSITION Tilbuds-Browse TO ROWID(current-rec).           
            APPLY 'VALUE-CHANGED' TO Tilbuds-Browse
           IN FRAME TILBUDS-FRAME.
        END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre2 Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Endre2 /* Endre... */
DO:
    /* Er endringslås opphevet */
    DEFINE VAR laast AS LOGICAL.
    
    SELECT endrings_laas INTO laast FROM NPSHANLG WHERE anleggsnr = anleggsnrParam.
    IF laast THEN
        DO:
            MESSAGE 'Anlegget er låst for endringer' VIEW-AS ALERT-BOX TITLE 'Stopp!'.
            RETURN NO-APPLY.
        END.
   SESSION:SET-WAIT-STATE("GENERAL").
   Current-Rec = ROWID(NPSHTILLEGG).
   dynamic-function('setAttribute',this-procedure,'current-tilbud-rec',string(rowid(npshtilbud))).
   
   IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + String(tilbudsIdParam).
     dynamic-function('setAttribute',this-procedure,'TilbudsIdParam',int(NPSHTILBUD.tilbudsid)).
     RUN SHENDTLG.W.
    {&OPEN-BROWSERS-IN-QUERY-Tilleggs-Frame}            
     APPLY 'VALUE-CHANGED' TO Tilbuds-Browse IN FRAME Tilbuds-Frame.
     {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
     REPOSITION Tilbuds-Browse TO ROWID(current-rec).           

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre_oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre_oppf Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Endre_oppf /* Endre... */
DO:
    /* Endre oppfølging */
    SESSION:SET-WAIT-STATE("GENERAL").
    current-rec = ROWID(NPSHTOPP).
    anleggsnrParam = NPSHTILBUD.anleggsnr.
    RUN SHENDOPP.W.
     {&OPEN-BROWSERS-IN-QUERY-Oppf_Frame}
     REPOSITION Oppf_Browse TO ROWID(current-rec).           
      /* Set aktivtflagg på prosjektnivå */
      RUN SETAKTIV.P (INPUT prosjektidParam).
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Nytt /* Nytt... */
DO:
    /* Nytt tilbud */
    nyRecord = TRUE.
    SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN SHTLBRED.W.
    IF current-rec ne ? THEN DO:
        FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD) = current-rec 
            NO-LOCK NO-ERROR NO-WAIT.
        IF AVAILABLE NPSHTILBUD THEN DO:
            /* Oppdater shuntpris, prisog avgitt pris for dette tilbudet */
            DEFINE VAR c_shuntpris AS DECIMAL INITIAL 0.
            DEFINE VAR c_pris AS DECIMAL INITIAL 0.
            DEFINE VAR c_avgittpris AS DECIMAL INITIAL 0.
            FOR EACH NPSHSYST WHERE NPSHSYST.anleggsnr = anleggsnrParam:
                c_shuntpris = c_shuntpris + NPSHSYST.standardpris.
            END.      
            FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD) = current-rec NO-WAIT 
                NO-ERROR.            
            IF AVAILABLE NPSHTILBUD THEN
            DO:
                c_pris = c_shuntpris.
                 c_avgittpris = c_pris - ((c_pris *  NPSHTILBUD.rabatt%) / 100).
                 tilbudsIdParam = npshtilbud.id. 
           
                ASSIGN NPSHTILBUD.pris_shuntgrupper  = c_shuntpris
                              NPSHTILBUD.pris = c_pris
                              NPSHTILBUD.avgittpris =  c_avgittpris.
            END.
            /* Opprett første record i oppfølging, og sett oppf.uke */
            DEFINE VAR cUke LIKE NPSHANLG.oppf_uke.
            DEFINE VAR cAar LIKE NPSHANLG.oppf_aar.

            FIND NPSHANLG WHERE NPSHANLG.anleggsnr = anleggsnrParam NO-LOCK 
                NO-WAIT NO-ERROR.
            IF AVAILABLE NPSHANLG THEN
                    cUke = NPSHANLG.oppf_uke.
                    cAar = NPSHANLG.oppf_aar.
            define var cp_tabell_navn as char.
            define var ip_neste_id as integer.

            cp_tabell_navn  = 'npshtopp'.
            run neste_id.p (input cp_tabell_navn, output ip_neste_id).
            CREATE NPSHTOPP.
            ASSIGN 
            NPSHTOPP.id = tilbudsIdParam
            NPSHTOPP.oppf_nr = ip_neste_id
            NPSHTOPP.neste_oppf_uke = cUke.
            NPSHTOPP.neste_oppf_aar = cAar.            
           /* Sett endringslås på anlegget */
           UPDATE NPSHANLG SET endrings_laas = TRUE WHERE anleggsnr = anleggsnrParam.
           
          {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
            REPOSITION Tilbuds-Browse TO ROWID(current-rec).           
            APPLY 'VALUE-CHANGED' TO Tilbuds-Browse
                IN FRAME TILBUDS-FRAME.
          {&OPEN-BROWSERS-IN-QUERY-Oppf_Frame}

            MENU-ITEM m_Nytt2:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
            MENU-ITEM m_Endre2:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
            MENU-ITEM m_Slette2:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
            MENU-ITEM m_Tilbudsbrev:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
            MENU-ITEM m_Endre:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
            MENU-ITEM m_Slette:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
           MENU-ITEM m_Ny_oppf:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
           MENU-ITEM m_Endre_oppf:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        END.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt2 Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Nytt2 /* Nytt... */
DO:
      /* Nytt tillegg */
    nyRecord = FALSE.
    SESSION:SET-WAIT-STATE("GENERAL").
    tilbudsIdParam = NPSHTILBUD.id.
    dynamic-function('setAttribute',this-procedure,'current-tilbud-rec',string(rowid(npshtilbud))).
    dynamic-function('setAttribute',this-procedure,'tilbudsIdParam',string(npshtilbud.id)).
     
    current-rec = ROWID(NPSHTillegg).
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN SHNYTTLG.W.
    IF nyRecord THEN
        DO:
          {&OPEN-BROWSERS-IN-QUERY-Tilleggs-Frame}            
           APPLY 'VALUE-CHANGED' TO Tilbuds-Browse IN FRAME Tilbuds-Frame.
          {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
           REPOSITION Tilbuds-Browse TO ROWID(current-rec).           
        END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ny_oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ny_oppf Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Ny_oppf /* Ny... */
DO:
    /* Ny oppfølging */
    nyRecord = FALSE.
    SESSION:SET-WAIT-STATE("GENERAL").
    Current-Rec = ROWID(NPSHTOPP).
    tilbudsIdParam = NPSHTILBUD.id.
    dynamic-function('setAttribute',this-procedure,'TilbudsIdParam',tilbudsIdParam).
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(tilbudsIdParam).
    RUN SHNYOPPF.W.
    IF nyRecord THEN
        DO:
          {&OPEN-BROWSERS-IN-QUERY-Oppf_Frame}
           REPOSITION Oppf_Browse TO ROWID(Current-Rec). 
            /* Set aktivtflagg på prosjektnivå */
            RUN SETAKTIV.P (INPUT prosjektidParam).

        END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ordregrunnlag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ordregrunnlag Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Ordregrunnlag /* Ordregrunnlag... */
DO:
  /* Dersom det ikke er registrert ordregrunnlag - registrer ny
      dersom det er registrert men den ikke er skrevet ut - endringsmodus
      dersom der er skrevet ut - vis */
DEFINE VAR  alleredeRegistrert AS LOGICAL INITIAL FALSE.
DEFINE VAR skrevetUt AS LOGICAL INITIAL FALSE.
DEFINE VAR cKunde LIKE NPKUNDE.kundenavn.

   anleggsnrParam = NPSHTILBUD.anleggsnr.
   tilbudsIdParam = NPSHTILBUD.id.
   tilbudsnrParam = NPSHTILBUD.tilbudsnr.
   cKunde = NPKUNDE.kundenavn.
   FIND NPSHORD WHERE NPSHORD.anleggsnr = anleggsnrParam NO-LOCK NO-WAIT NO-ERROR.
   IF AVAILABLE NPSHORD THEN
      DO:
        alleredeRegistrert = TRUE.
        IF NPSHORD.overfoert THEN
            skrevetUt = TRUE.
      END.       
         
    SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(tilbudsIdParam).

    IF alleredeRegistrert THEN do:
/*        RUN SHENDORD.W (INPUT THIS-PROCEDURE:PRIVATE-DATA,                */
/*            INPUT skrevetUt, INPUT cKunde, INPUT tilbudsnrParam) NO-ERROR.*/
      run shendord.w.
      end.
    ELSE
        DO:
            RUN SHNYORD.W.
          {&OPEN-BROWSERS-IN-QUERY-Oppf_Frame}
        END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Slette /* Slette... */
DO:
      DEFINE VAR cur_rec AS ROWID.
    
      MESSAGE "Vil du slette dette tilbudet?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
                SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = ROWID(NPSHTILBUD).
                FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD)  = cur_rec  EXCLUSIVE-LOCK NO-WAIT
                    NO-ERROR.
                IF AVAILABLE NPSHTILBUD THEN
                         DELETE NPSHTILBUD.                         
                STATUS DEFAULT.
                SESSION:SET-WAIT-STATE("").
                RUN enable_UI.
                {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
                {&OPEN-BROWSERS-IN-QUERY-Tilleggs-Frame}
                {&OPEN-BROWSERS-IN-QUERY-Oppf_Frame}
                GET FIRST Tilbuds-Browse.   
                IF AVAILABLE NPSHSYST THEN 
                    DO:
                        tilbudsRow =  Tilbuds-Browse:SELECT-ROW(1) IN FRAME Tilbuds-Frame.
                        APPLY 'VALUE-CHANGED' TO Tilbuds-Browse.
                    END.
                ELSE
                       /* Dette er siste tilbud på dette anlegget - opphev endringslås */
                       UPDATE NPSHANLG SET endrings_laas = FALSE WHERE anleggsnr = anleggsnrParam.

          END.
         WHEN FALSE THEN /* No */
          DO:
             MESSAGE "Sletting avbrutt."
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             RETURN NO-APPLY.
          END.
         END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette2 Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Slette2 /* Slette... */
DO:
    /* Slette tillegg */
      DEFINE VAR cur_rec AS ROWID.
    
      MESSAGE "Vil du slette dette tillegget?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
                SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = ROWID(NPSHTILLEGG).
                FIND NPSHTILLEGG WHERE ROWID(NPSHTILLEGG)  = cur_rec  EXCLUSIVE-LOCK 
                    NO-WAIT NO-ERROR.
                IF AVAILABLE NPSHTILLEGG THEN
                    DO:
                        RUN reduserTilbudspris.
                        STATUS DEFAULT.
                        SESSION:SET-WAIT-STATE("").
                        {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
                        {&OPEN-BROWSERS-IN-QUERY-Tilleggs-Frame}
                        GET FIRST Tilleggs-Browse.
                        IF AVAILABLE NPSHTILLEGG THEN 
                          REPOSITION Tilbuds-Browse TO ROWID(current-rec).                 
                    END.
          END.
/*         WHEN FALSE THEN /* No */                            */
/*          DO:                                                */
/*             MESSAGE "Sletting avbrutt."                     */
/*                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.*/
/*                    RETURN NO-APPLY.                         */
/*          END.                                               */
         END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette_oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette_oppf Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Slette_oppf /* Slette... */
DO:
      DEFINE VAR cur_rec AS ROWID.
      DEFINE VAR antall AS INTEGER NO-UNDO.
      DEFINE VAR ferdig AS LOGICAL NO-UNDO.
            
      /* Hvis bare 1 oppfølgingsrad - ikke mulig å slette */
      SELECT COUNT(*) INTO antall
      FROM NPSHTOPP  WHERE NPSHTOPP.id = tilbudsidParam:

       IF antall <= 1 THEN DO:
         MESSAGE 'Det er bare en oppfølging. Denne kan ikke slettes'  VIEW-AS ALERT-BOX TITLE 'Stopp'.
         RETURN.
      END.
                
      MESSAGE "Vil du slette denne oppfølgingen?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN DO:                /* Yes */
                 SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = ROWID(NPSHTOPP).
                FIND NPSHTOPP  WHERE ROWID(NPSHTOPP)  = cur_rec  EXCLUSIVE-LOCK NO-WAIT
                    NO-ERROR.
                IF AVAILABLE NPSHTOPP THEN DO WITH FRAME Oppf_Frame:
                  DELETE NPSHTOPP.                   
                  ferdig = OPPF_BROWSE:DELETE-CURRENT-ROW().                   
                END.
                STATUS DEFAULT.
                 SESSION:SET-WAIT-STATE("").
            END.      
          WHEN FALSE THEN DO:          /* No */
             MESSAGE "Sletting avbrutt."
                    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
             RETURN NO-APPLY.
          END.
         END CASE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tekn_spes_alle_opplysninger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tekn_spes_alle_opplysninger Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Tekn_spes_alle_opplysninger /* Tekn. spes. alle opplysninger */
DO:
   DEFINE VAR svar AS LOGICAL INITIAL TRUE.
   tilbudsIdParam = NPSHTILBUD.id.
  MESSAGE 'Vil du skrive ut teknisk spesifikasjon?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Teknisk Spesifikasjon'  UPDATE svar.
    IF svar THEN
    /* Skriv teknisk spesifikasjon */
    RUN aderb/_printrb.p
        ("report\norshtek.prl",
        "Shunttilbud - tekn. spes. max",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O",
        "NPSHTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        session:first-procedure:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud - tekn. spes.",
        yes,
        yes,
        no,
        "").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tekn_spes_alle_upris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tekn_spes_alle_upris Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Tekn_spes_alle_upris /* Tekn. spes. alle opplysninger uten pris */
DO:
  DEFINE VAR svar AS LOGICAL INITIAL TRUE.
   tilbudsIdParam = NPSHTILBUD.id.
  MESSAGE 'Vil du skrive ut teknisk spesifikasjon?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Teknisk Spesifikasjon'  UPDATE svar.
    IF svar THEN
    /* Skriv teknisk spesifikasjon */
    RUN aderb/_printrb.p
        ("report\norshtek.prl",
        "Shunttilbud - tekn.spekmaxUpris",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O",
        "NPSHTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        session:first-procedure:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud - tekn. spes. uten pris",
        yes,
        yes,
        no,
        "").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tekn_spes_koder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tekn_spes_koder Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Tekn_spes_koder /* Tekn. spes. koder */
DO:
   DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    tilbudsIdParam = NPSHTILBUD.id.
  MESSAGE 'Vil du skrive ut teknisk spesifikasjon?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Teknisk Spesifikasjon'  UPDATE svar.
    IF svar THEN
    /* Skriv teknisk spesifikasjon */
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shunttilbud - tekn. spes. min",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O",
        "NPSHTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        session:first-procedure:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud - tekn. spes.",
        yes,
        yes,
        no,
        "").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tekn_spes_standard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tekn_spes_standard Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Tekn_spes_standard /* Tekn. spes. standard */
DO:
   DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    tilbudsIdParam = NPSHTILBUD.id.
    MESSAGE 'Vil du skrive ut teknisk spesifikasjon ? ' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Teknisk Spesifikasjon'  UPDATE svar.        
    IF svar THEN
    /* Skriv teknisk spesifikasjon - med pris */
    RUN aderb/_printrb.p
         ("report\norshtek.prl", 
        "Shunttilbud - tekn. spes.-pris",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O",
        "NPSHTILBUD.id = " + string(tilbudsIdParam),
        "",
        "", /*D - preview*/
        session:first-procedure:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud - tekn. spes.",
        no,
        yes,
        no,
        "").        
    /* Skriv teknisk spesifikasjon - uten pris */
    RUN aderb/_printrb.p
         ("report\norshtek.prl", 
        "Shunttilbud - tekn. spes.-upris",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O",
        "NPSHTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        session:first-procedure:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud - tekn. spes.",
        yes,
        yes,
        no,
        "").        

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbudsbrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbudsbrev Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Tilbudsbrev /* Tilbudsbrev */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    tilbudsIdParam = NPSHTILBUD.id.
    MESSAGE 'Vil du skrive ut tilbudsbrev?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Tilbudsutskrift'  UPDATE svar.
    IF svar THEN
    /* Skriv tilbudsbrev - forside */
RUN aderb/_printrb.p 
        ("report\norshunt.prl",
        "Shunttilbud - tilbudsbrev",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),
        "O", 
        "NPSHTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        session:first-procedure:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud - tilbudsbrev",
        yes,
        yes,
        no,
        "").        

    MESSAGE 'Vil du skrive ut tilleggsleveranser?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Tilleggsleveranser'  UPDATE svar.
    IF svar THEN
    /* Skriv tilleggsleveranser */
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Shunttilbud - tilleggsleveranser",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O",
        "NPSHTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        session:first-procedure:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Shunttilbud - tilbudsbrev",
        yes,
        yes,
        no,
        "").        


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Til_referanseliste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Til_referanseliste Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Til_referanseliste /* Til referanseliste... */
DO:
  message 'Ikke på plass ennå' view-as alert-box title 'Ikke Ferdig'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Utskrift_av_Ordregrunnlag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Utskrift_av_Ordregrunnlag Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Utskrift_av_Ordregrunnlag /* Utskrift av Ordregrunnlag */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR svarOverfoer AS LOGICAL INITIAL FALSE.

    MESSAGE 'Vil du skrive ut ordregrunnlag?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Ordregrunnlag'  UPDATE svar.        
    IF svar THEN
        DO:
            /* Først må det sjekkes om ordre er produsert */
            FIND NPSHORD WHERE NPSHORD.tilbudsid = NPSHTILBUD.tilbudsid NO-ERROR.
            IF NOT AVAILABLE NPSHORD THEN
                DO:
                    MESSAGE 'Ordre er ikke registrert for dette anlegget' VIEW-AS ALERT-BOX TITLE 'Feil'.
                    RETURN NO-APPLY.
                END.
            ELSE
                DO:
                    /* Sjekk om ordre er sperret */
                   IF NPSHORD.overfoert THEN
                        DO:
                             MESSAGE 'Ordre er sperret. Den kan ikke skrives ut' VIEW-AS ALERT-BOX TITLE 'Feil'.
                            RETURN NO-APPLY.                         
                        END. 
                       /* Skriv ordregrunnlag */    
                       RUN aderb/_printrb.p 
                    ("report\norshunt.prl",
                       "Ordregrunnlag",
                      JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                      "O", 
                      "NPSHORD.tilbudsid = " + string(NPSHTILBUD.tilbudsid),
                       "",
                       "",
        session:first-procedure:private-data,
                      "",
                      "",
                       0,
                       0,
                      0,
                      no,
                       "Ordregrunnlag",
                       yes,
                      yes,
                       no,
                      "").        

                MESSAGE 'Vil du skrive ut ordregrunnlag for tilleggsleveranser?' VIEW-AS ALERT-BOX QUESTION 
                BUTTONS YES-NO TITLE 'Tilleggsleveranser'  UPDATE svar.
                IF svar THEN
                /* Skriv tilleggsleveranser */
                 RUN aderb/_printrb.p
                 ("report\norshunt.prl",
                       "Ordregrunnlag - tillegg",
                     JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                     "O", 
                      "NPSHORD.tilbudsid = " + string(tilbudsIdParam),
                       "",
                       "",
        session:first-procedure:private-data,
                      "",
                      "",
                       0,
                       0,
                      0,
                      no,
                       "Ordregrunnlag - tillegg",
                       yes,
                      yes,
                       no,
                      "").        


/*                    MESSAGE 'Skal denne ordren merkes som overført til Ordresystemet? ' + CHR(10) + CHR(13) + 'Svarer du Ja vil det ikke kunne gj›res endringer p† ordren senere. ' 
                        VIEW-AS ALERT-BOX QUESTION 
                        BUTTONS YES-NO TITLE 'Sperring av ordre'  UPDATE svarOverfoer.
                    IF svarOverfoer THEN
                        UPDATE NPSHORD SET overfoert = TRUE WHERE tilbudsId = tilbudsIdParam.     */
            END.
        END.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME OPPF_BROWSE
&Scoped-define SELF-NAME OPPF_BROWSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL OPPF_BROWSE Tilbuds-Window
ON LEFT-MOUSE-DBLCLICK OF OPPF_BROWSE IN FRAME Oppf_frame
DO:
  APPLY 'CHOOSE' TO MENU-ITEM m_Endre_oppf IN MENU MENU-BAR-TILBUDS-WINDOW.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Tilbuds-Browse
&Scoped-define FRAME-NAME Tilbuds-Frame
&Scoped-define SELF-NAME Tilbuds-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tilbuds-Browse Tilbuds-Window
ON LEFT-MOUSE-CLICK OF Tilbuds-Browse IN FRAME Tilbuds-Frame
DO:
    APPLY 'VALUE-CHANGED' TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tilbuds-Browse Tilbuds-Window
ON LEFT-MOUSE-DBLCLICK OF Tilbuds-Browse IN FRAME Tilbuds-Frame
DO:
    APPLY 'CHOOSE' TO MENU-ITEM   m_Endre IN MENU MENU-BAR-TILBUDS-WINDOW.
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tilbuds-Browse Tilbuds-Window
ON VALUE-CHANGED OF Tilbuds-Browse IN FRAME Tilbuds-Frame
DO:
    tilbudsIdParam = NPSHTILBUD.id.
    Current-Rec = ROWID(NPSHTILBUD).
 
   {&OPEN-BROWSERS-IN-QUERY-TILLEGGS-FRAME}
   {&OPEN-BROWSERS-IN-QUERY-OPPF_FRAME}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME Tilleggs-Browse
&Scoped-define FRAME-NAME Tilleggs-Frame
&Scoped-define SELF-NAME Tilleggs-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tilleggs-Browse Tilbuds-Window
ON LEFT-MOUSE-DBLCLICK OF Tilleggs-Browse IN FRAME Tilleggs-Frame
DO:
  APPLY 'CHOOSE' TO MENU-ITEM m_Endre2  IN MENU MENU-BAR-TILBUDS-WINDOW.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tilleggs-Browse Tilbuds-Window
ON VALUE-CHANGED OF Tilleggs-Browse IN FRAME Tilleggs-Frame
DO:
/*    Current-Tilleggs-Rec = ROWID(NPSHTILLEGG).*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Oppf_frame
&Scoped-define BROWSE-NAME OPPF_BROWSE
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Tilbuds-Window 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE do:
   JBoxRelation:instance:Invalidate(this-procedure).
   RUN disable_UI.
end.
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

    SESSION:SET-WAIT-STATE("").

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    hParent = source-procedure.
    THIS-PROCEDURE:CURRENT-WINDOW:X = hParent:Current-window:X + 10.
    THIS-PROCEDURE:CURRENT-WINDOW:Y = hParent:current-window:Y + 10.
    DYNAMIC-FUNCTION("DoLockWindow",this-procedure:CURRENT-WINDOW).
    current-rec = dynamic-function('getCurrentRec' in hParent).
    nyRecord    = logical(dynamic-function('getNyRecord' in hParent)).
    anleggsnrParam = int(dynamic-function('getAttribute',hParent,'anleggsnrParam')).
    anleggsnavnparam = dynamic-function('getAttribute',hParent,'anleggsnavnParam').
    dynamic-function('setAttribute',this-procedure,'anleggsnrParam',int(anleggsnrParam)).
    prosjektidparam  = int(jboxSession:Instance:getJBoxAttribute('ProsjektId')).
   
   Tilbuds-Window:TITLE = 'Tilbud for anlegg: ' + anleggsNavnParam.
   RUN enable_UI.
  RUN MoveToTop.
  APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
  SESSION:SET-WAIT-STATE("").
   
   GET FIRST Tilbuds-Browse.   
   IF AVAILABLE norcalc.NPSHTILBUD THEN 
   DO:
        MENU-ITEM m_Nytt2:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_Endre2:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_Slette2:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_Tilbudsbrev:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_Endre:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_Slette:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_til_referanseliste:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_Ny_oppf:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.
        MENU-ITEM m_Endre_oppf:SENSITIVE IN MENU MENU-BAR-TILBUDS-WINDOW = YES.

       tilbudsRow =  Tilbuds-Browse:SELECT-ROW(1) IN FRAME Tilbuds-Frame.
       APPLY 'VALUE-CHANGED' TO Tilbuds-Browse.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent Tilbuds-Window 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*    APPLY "ENTRY" TO FILL-IN-1 IN FRAME Tilleggs-Frame.*/
/*    HIDE FILL-IN-1 IN FRAME Tilleggs-Frame.            */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Tilbuds-Window  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Tilbuds-Window)
  THEN DELETE WIDGET Tilbuds-Window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Tilbuds-Window  _DEFAULT-ENABLE
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
  ENABLE Tilbuds-Browse 
      WITH FRAME Tilbuds-Frame IN WINDOW Tilbuds-Window.
  {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
  ENABLE Tilleggs-Browse 
      WITH FRAME Tilleggs-Frame IN WINDOW Tilbuds-Window.
  {&OPEN-BROWSERS-IN-QUERY-Tilleggs-Frame}
  ENABLE OPPF_BROWSE 
      WITH FRAME Oppf_frame IN WINDOW Tilbuds-Window.
  {&OPEN-BROWSERS-IN-QUERY-Oppf_frame}
  VIEW Tilbuds-Window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Hide_Win Tilbuds-Window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop Tilbuds-Window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reduserTilbudspris Tilbuds-Window 
PROCEDURE reduserTilbudspris :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
DEFINE VAR minus_paa_tilbud AS DECIMAL.                

minus_paa_tilbud = NPSHTILLEGG.pris.             
DELETE NPSHTILLEGG.
FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD) = current-rec  EXCLUSIVE-LOCK.
 IF AVAILABLE NPSHTILBUD THEN
      DO:    
           DEFINE VAR c_tillegg AS DECIMAL INITIAL 0.
           DEFINE VAR c_pris AS DECIMAL INITIAL 0.
           DEFINE VAR c_avgittpris AS DECIMAL INITIAL 0.
           c_tillegg = NPSHTILBUD.pris_tillegg - minus_paa_tilbud.
           c_pris = NPSHTILBUD.pris - minus_paa_tilbud.
           c_avgittpris = c_pris - ((c_pris *  NPSHTILBUD.rabatt%) / 100).            
           ASSIGN  NPSHTILBUD.pris_tillegg = c_tillegg
                              NPSHTILBUD.pris = c_pris
                              NPSHTILBUD.avgittpris =  c_avgittpris.
      END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE View_Win Tilbuds-Window 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRec Tilbuds-Window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNyRecord Tilbuds-Window 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentRec Tilbuds-Window 
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

