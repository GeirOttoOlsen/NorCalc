&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME Win-Kundekartotek
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Win-Kundekartotek 
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
DEFINE INPUT  PARAMETER appdata AS CHARACTER.
DEFINE NEW SHARED VAR kundenrParam LIKE NPKUNDE.kundenr.
DEFINE NEW SHARED VAR oppfidParam LIKE NPKUNDEOPPF.oppf_id.
DEFINE VAR sokNavn AS CHAR INITIAL "".
DEFINE VAR sokSted AS CHAR INITIAL "".
DEFINE VAR sokKategori AS CHAR INITIAL "".
DEFINE VAR sokDistrikt AS CHAR INITIAL "".
DEFINE VAR sokPnr AS CHAR INITIAL "".

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VAR Current-Kunde-Rec AS  ROWID.
DEFINE NEW SHARED VAR Current-Oppf-Rec AS  ROWID.
DEFINE NEW SHARED VAR nyRecord AS LOGICAL INITIAL FALSE.
DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR kundeRow AS LOGICAL.
DEFINE VAR oppfRow AS LOGICAL.
DEFINE VAR Detail-Handle AS HANDLE.
DEFINE VAR kundeNavnParam AS CHAR.
DEFINE VAR iNextKundenr AS INTEGER.
DEFINE VAR iCurKundenr AS INTEGER.
DEFINE VAR p-handle AS HANDLE.

/*DEFINE VARIABLE dbop-supported AS LOGICAL.
DEFINE VARIABLE dbop-db-name AS CHARACTER.
DEFINE VARIABLE dbop-tbl-name AS CHARACTER.
DEFINE VARIABLE nav-stat AS LOGICAL.*/
DEFINE VARIABLE browser-handle AS HANDLE.
DEFINE VAR ip_neste_id AS INTEGER.

DEFINE QUERY Nytt-Sok FOR NPKUNDE SCROLLING.

def var h as handle no-undo. /*dummy handle*/
h = session:first-procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-kunder

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKUNDE NPKUNDEOPPF

/* Definitions for BROWSE BROWSE-kunder                                 */
&Scoped-define FIELDS-IN-QUERY-BROWSE-kunder NPKUNDE.kundenavn ~
NPKUNDE.adresse1 NPKUNDE.er_konsulent NPKUNDE.adresse2 NPKUNDE.avdeling ~
NPKUNDE.postnr NPKUNDE.poststed NPKUNDE.telefon NPKUNDE.kundenr ~
NPKUNDE.kundedistriktnr NPKUNDE.kundekategori NPKUNDE.tilbudsmottager 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-kunder 
&Scoped-define QUERY-STRING-BROWSE-kunder FOR EACH NPKUNDE ~
      WHERE NPKUNDE.aktiv = TRUE NO-LOCK ~
    BY NPKUNDE.kundenavn
&Scoped-define OPEN-QUERY-BROWSE-kunder OPEN QUERY BROWSE-kunder FOR EACH NPKUNDE ~
      WHERE NPKUNDE.aktiv = TRUE NO-LOCK ~
    BY NPKUNDE.kundenavn.
&Scoped-define TABLES-IN-QUERY-BROWSE-kunder NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-kunder NPKUNDE


/* Definitions for BROWSE BROWSE-Oppf                                   */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Oppf ~
IF (NPKUNDEOPPF.rapport = ""  OR NPKUNDEOPPF.rapport = ?) THEN (False) ELSE (True) ~
IF (NPKUNDEOPPF.mini_brev = "" OR NPKUNDEOPPF.mini_brev = ?) THEN (False) ELSE (True) ~
NPKUNDEOPPF.kontakt_dato NPKUNDEOPPF.neste_kontakt NPKUNDEOPPF.rapport ~
NPKUNDEOPPF.kundenr NPKUNDEOPPF.oppf_id 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Oppf 
&Scoped-define QUERY-STRING-BROWSE-Oppf FOR EACH NPKUNDEOPPF ~
      WHERE NPKUNDEOPPF.kundenr = kundenrParam NO-LOCK ~
    BY NPKUNDEOPPF.oppf_id DESCENDING
&Scoped-define OPEN-QUERY-BROWSE-Oppf OPEN QUERY BROWSE-Oppf FOR EACH NPKUNDEOPPF ~
      WHERE NPKUNDEOPPF.kundenr = kundenrParam NO-LOCK ~
    BY NPKUNDEOPPF.oppf_id DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-Oppf NPKUNDEOPPF
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Oppf NPKUNDEOPPF


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-kunder}

/* Definitions for FRAME FRAME-Oppf                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-FRAME-Oppf ~
    ~{&OPEN-QUERY-BROWSE-Oppf}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPKUNDE.kundenr 
&Scoped-define ENABLED-TABLES NPKUNDE
&Scoped-define FIRST-ENABLED-TABLE NPKUNDE
&Scoped-Define ENABLED-OBJECTS RECT-1 COMBO-BOX-navn ~
COMBO-BOX_kundekategori FILL-IN-navn COMBO-BOX-poststed ~
COMBO-BOX_kundedistriktnr FILL-IN-poststed FILL-IN-postnr BROWSE-kunder 
&Scoped-Define DISPLAYED-FIELDS NPKUNDE.kundenr 
&Scoped-define DISPLAYED-TABLES NPKUNDE
&Scoped-define FIRST-DISPLAYED-TABLE NPKUNDE
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-navn COMBO-BOX_kundekategori ~
FILL-IN-navn COMBO-BOX-poststed COMBO-BOX_kundedistriktnr FILL-IN-poststed ~
FILL-IN-postnr 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR Win-Kundekartotek AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Kunder 
       MENU-ITEM m_Nykunde      LABEL "&Ny..."         ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endrekunde   LABEL "&Endre.."       ACCELERATOR "CTRL-E"
              DISABLED
       MENU-ITEM m_Slettekunde  LABEL "&Slette..."     ACCELERATOR "CTRL-S"
              DISABLED
       MENU-ITEM m_Oppdater     LABEL "Oppdater"      .

DEFINE SUB-MENU m_Oppflging 
       MENU-ITEM m_Nyoppf       LABEL "&Ny..."         ACCELERATOR "ALT-CTRL-N"
              DISABLED
       MENU-ITEM m_Endreoppf    LABEL "&Endre..."      ACCELERATOR "ALT-CTRL-E"
              DISABLED
       MENU-ITEM m_Sletteoppf   LABEL "&Slette..."     ACCELERATOR "ALT-CTRL-S"
              DISABLED.

DEFINE SUB-MENU m_Kundekort 
       MENU-ITEM m_Denne_kunden_utskrift LABEL "&Denne kunden" 
       MENU-ITEM m_Denne_kunden_-_2_sider LABEL "D&enne kunden - 2 sider"
       MENU-ITEM m_Utvalg_utskrift LABEL "&Utvalg..."    
       MENU-ITEM m_Kundehode_liste LABEL "Kundekort uten tillegg".

DEFINE SUB-MENU m_Utskrifter 
       SUB-MENU  m_Kundekort    LABEL "&Kundekort"    
       MENU-ITEM m_Minibrev_utskrift LABEL "&Minibrev"     .

DEFINE MENU MENU-BAR-Win-Kundekartotek MENUBAR
       SUB-MENU  m_Kunder       LABEL "&Kunder"       
       SUB-MENU  m_Oppflging    LABEL "Opp&følging"   
       SUB-MENU  m_Utskrifter   LABEL "&Utskrifter"   
       MENU-ITEM m_Avslutt      LABEL "Avslut&t"      .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-navn AS CHARACTER FORMAT "X(15)":U INITIAL "Begynner med" 
     LABEL "&Navn" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Begynner med","Er lik","Inneholder" 
     DROP-DOWN-LIST
     SIZE 22.6 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-poststed AS CHARACTER FORMAT "X(15)":U INITIAL "Begynner med" 
     LABEL "&Poststed" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Begynner med","Er lik","Inneholder" 
     DROP-DOWN-LIST
     SIZE 22.6 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE COMBO-BOX_kundedistriktnr AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Distrikt" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "dummy",0
     DROP-DOWN-LIST
     SIZE 32 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE VARIABLE COMBO-BOX_kundekategori AS CHARACTER FORMAT "X(6)" 
     LABEL "Kategori" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "d" 
     DROP-DOWN-LIST
     SIZE 18.2 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE VARIABLE FILL-IN-navn AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 47.4 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-postnr AS CHARACTER FORMAT "X(8)":U 
     LABEL "Postnr" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 10.6 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-poststed AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 22.8 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124.8 BY 3.43.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-kunder FOR 
      NPKUNDE SCROLLING.

DEFINE QUERY BROWSE-Oppf FOR 
      NPKUNDEOPPF SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-kunder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-kunder Win-Kundekartotek _STRUCTURED
  QUERY BROWSE-kunder NO-LOCK DISPLAY
      NPKUNDE.kundenavn FORMAT "X(30)":U
      NPKUNDE.adresse1 FORMAT "X(30)":U
      NPKUNDE.er_konsulent FORMAT "ja/nei":U
      NPKUNDE.adresse2 FORMAT "X(30)":U
      NPKUNDE.avdeling FORMAT "X(30)":U
      NPKUNDE.postnr FORMAT "X(8)":U
      NPKUNDE.poststed FORMAT "X(22)":U
      NPKUNDE.telefon FORMAT "X(15)":U
      NPKUNDE.kundenr FORMAT "X(8)":U
      NPKUNDE.kundedistriktnr FORMAT ">>9":U
      NPKUNDE.kundekategori FORMAT "X(6)":U
      NPKUNDE.tilbudsmottager FORMAT "ja/nei":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 125.8 BY 7.52
         BGCOLOR 15 FGCOLOR 1 FONT 2.

DEFINE BROWSE BROWSE-Oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Oppf Win-Kundekartotek _STRUCTURED
  QUERY BROWSE-Oppf NO-LOCK DISPLAY
      IF (NPKUNDEOPPF.rapport = ""  OR NPKUNDEOPPF.rapport = ?) THEN (False) ELSE (True) COLUMN-LABEL "Oppf." FORMAT "Ja/Nei":U
      IF (NPKUNDEOPPF.mini_brev = "" OR NPKUNDEOPPF.mini_brev = ?) THEN (False) ELSE (True) COLUMN-LABEL "Minibrev" FORMAT "Ja/Nei":U
      NPKUNDEOPPF.kontakt_dato FORMAT "99.99.9999":U
      NPKUNDEOPPF.neste_kontakt FORMAT "99.99.9999":U
      NPKUNDEOPPF.rapport FORMAT "X(1024)":U
      NPKUNDEOPPF.kundenr FORMAT "X(8)":U
      NPKUNDEOPPF.oppf_id FORMAT ">>9":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 125.4 BY 5.57
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME FRAME-Oppf
     BROWSE-Oppf AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 12.57
         SIZE 125.8 BY 6.57
         BGCOLOR 8 FGCOLOR 5 FONT 2
         TITLE "Oppfølgingslogg".

DEFINE FRAME DEFAULT-FRAME
     COMBO-BOX-navn AT ROW 1.91 COL 13 COLON-ALIGNED
     COMBO-BOX_kundekategori AT ROW 1.95 COL 100 COLON-ALIGNED
     FILL-IN-navn AT ROW 2 COL 35.8 COLON-ALIGNED NO-LABEL
     NPKUNDE.kundenr AT ROW 2 COL 119.6 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 1 BY 1
     COMBO-BOX-poststed AT ROW 3.24 COL 13 COLON-ALIGNED
     COMBO-BOX_kundedistriktnr AT ROW 3.24 COL 90.6 COLON-ALIGNED
     FILL-IN-poststed AT ROW 3.33 COL 35.8 COLON-ALIGNED NO-LABEL
     FILL-IN-postnr AT ROW 3.33 COL 67.8 COLON-ALIGNED
     BROWSE-kunder AT ROW 5.14 COL 1
     " Søke" VIEW-AS TEXT
          SIZE 8.4 BY .62 AT ROW 1.14 COL 5.8
     RECT-1 AT ROW 1.48 COL 1.6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 125.8 BY 11.67
         FONT 2.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW Win-Kundekartotek ASSIGN
         HIDDEN             = YES
         TITLE              = "Kundekartotek"
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 18.14
         WIDTH              = 125.8
         MAX-HEIGHT         = 18.14
         MAX-WIDTH          = 125.8
         VIRTUAL-HEIGHT     = 18.14
         VIRTUAL-WIDTH      = 125.8
         RESIZE             = yes
         SCROLL-BARS        = yes
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-Win-Kundekartotek:HANDLE.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT Win-Kundekartotek:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT Win-Kundekartotek:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW Win-Kundekartotek
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* BROWSE-TAB BROWSE-kunder FILL-IN-postnr DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR FRAME FRAME-Oppf
                                                                        */
/* BROWSE-TAB BROWSE-Oppf 1 FRAME-Oppf */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Win-Kundekartotek)
THEN Win-Kundekartotek:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-kunder
/* Query rebuild information for BROWSE BROWSE-kunder
     _TblList          = "norcalc.NPKUNDE"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPKUNDE.kundenavn|yes"
     _Where[1]         = "NPKUNDE.aktiv = TRUE"
     _FldNameList[1]   = norcalc.NPKUNDE.kundenavn
     _FldNameList[2]   = norcalc.NPKUNDE.adresse1
     _FldNameList[3]   > norcalc.NPKUNDE.er_konsulent
"NPKUNDE.er_konsulent" ? "ja/nei" "logical" ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   = norcalc.NPKUNDE.adresse2
     _FldNameList[5]   = norcalc.NPKUNDE.avdeling
     _FldNameList[6]   = norcalc.NPKUNDE.postnr
     _FldNameList[7]   = norcalc.NPKUNDE.poststed
     _FldNameList[8]   = norcalc.NPKUNDE.telefon
     _FldNameList[9]   = norcalc.NPKUNDE.kundenr
     _FldNameList[10]   = norcalc.NPKUNDE.kundedistriktnr
     _FldNameList[11]   = norcalc.NPKUNDE.kundekategori
     _FldNameList[12]   = norcalc.NPKUNDE.tilbudsmottager
     _Query            is OPENED
*/  /* BROWSE BROWSE-kunder */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Oppf
/* Query rebuild information for BROWSE BROWSE-Oppf
     _TblList          = "norcalc.NPKUNDEOPPF"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPKUNDEOPPF.oppf_id|no"
     _Where[1]         = "NPKUNDEOPPF.kundenr = kundenrParam"
     _FldNameList[1]   > "_<CALC>"
"IF (NPKUNDEOPPF.rapport = """"  OR NPKUNDEOPPF.rapport = ?) THEN (False) ELSE (True)" "Oppf." "Ja/Nei" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"IF (NPKUNDEOPPF.mini_brev = """" OR NPKUNDEOPPF.mini_brev = ?) THEN (False) ELSE (True)" "Minibrev" "Ja/Nei" ? ? ? ? ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   = norcalc.NPKUNDEOPPF.kontakt_dato
     _FldNameList[4]   = norcalc.NPKUNDEOPPF.neste_kontakt
     _FldNameList[5]   = norcalc.NPKUNDEOPPF.rapport
     _FldNameList[6]   = norcalc.NPKUNDEOPPF.kundenr
     _FldNameList[7]   = norcalc.NPKUNDEOPPF.oppf_id
     _Query            is OPENED
*/  /* BROWSE BROWSE-Oppf */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Win-Kundekartotek
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Win-Kundekartotek Win-Kundekartotek
ON END-ERROR OF Win-Kundekartotek /* Kundekartotek */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Win-Kundekartotek Win-Kundekartotek
ON WINDOW-CLOSE OF Win-Kundekartotek /* Kundekartotek */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-kunder
&Scoped-define SELF-NAME BROWSE-kunder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-kunder Win-Kundekartotek
ON ENTRY OF BROWSE-kunder IN FRAME DEFAULT-FRAME
DO:
  DEFINE VAR i AS INTEGER.
  DEFINE VAR rad AS LOGICAL.
  
  i = BROWSE-kunder:GET-REPOSITIONED-ROW().
  rad = BROWSE-kunder:SELECT-ROW(i).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-kunder Win-Kundekartotek
ON LEFT-MOUSE-CLICK OF BROWSE-kunder IN FRAME DEFAULT-FRAME
DO:
    APPLY 'VALUE-CHANGED' TO SELF. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-kunder Win-Kundekartotek
ON LEFT-MOUSE-DBLCLICK OF BROWSE-kunder IN FRAME DEFAULT-FRAME
DO:
 APPLY 'CHOOSE' TO MENU-ITEM m_endrekunde IN MENU MENU-BAR-Win-Kundekartotek.
 RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-kunder Win-Kundekartotek
ON VALUE-CHANGED OF BROWSE-kunder IN FRAME DEFAULT-FRAME
DO:
    kundenrParam = NPKUNDE.kundenr.
    Current-Kunde-Rec = ROWID(NPKUNDE).
   {&OPEN-BROWSERS-IN-QUERY-FRAME-Oppf}  
DO WITH FRAME FRAME-Oppf:
    APPLY 'VALUE-CHANGED' TO BROWSE-Oppf.
END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Oppf
&Scoped-define FRAME-NAME FRAME-Oppf
&Scoped-define SELF-NAME BROWSE-Oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Oppf Win-Kundekartotek
ON LEFT-MOUSE-DBLCLICK OF BROWSE-Oppf IN FRAME FRAME-Oppf
DO:
 APPLY 'CHOOSE' TO MENU-ITEM m_endreoppf IN MENU MENU-BAR-Win-Kundekartotek.
 RETURN NO-APPLY.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Oppf Win-Kundekartotek
ON VALUE-CHANGED OF BROWSE-Oppf IN FRAME FRAME-Oppf
DO:
   IF AVAILABLE NPKUNDEOPPF THEN 
   DO:
        MENU-ITEM m_Endreoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
        MENU-ITEM m_Sletteoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
    END.   
    ELSE  
   DO:
        MENU-ITEM m_Endreoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = NO.
        MENU-ITEM m_Sletteoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = NO.
    END.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME COMBO-BOX_kundedistriktnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_kundedistriktnr Win-Kundekartotek
ON VALUE-CHANGED OF COMBO-BOX_kundedistriktnr IN FRAME DEFAULT-FRAME /* Distrikt */
DO:
    sokNavn = " ".
    sokSted = " ".
    sokKategori = " ".
    ASSIGN FILL-IN-navn = sokNavn.
    ASSIGN FILL-IN-poststed = sokSted.
    COMBO-BOX_Kundekategori:SCREEN-VALUE = sokKategori.
    DISPLAY FILL-IN-poststed WITH FRAME DEFAULT-frame.   
    DISPLAY COMBO-BOX_Kundekategori WITH FRAME DEFAULT-frame.
         OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
            WHERE NPKUNDE.kundedistriktnr = int(SELF:SCREEN-VALUE)  BY NPKUNDE.kundenavn.

    IF AVAILABLE NPKUNDE THEN DO:
         APPLY 'VALUE-CHANGED' TO BROWSE-Kunder.
         APPLY 'ENTRY' TO BROWSE-Kunder.
         RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = "":U.       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_kundekategori
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_kundekategori Win-Kundekartotek
ON VALUE-CHANGED OF COMBO-BOX_kundekategori IN FRAME DEFAULT-FRAME /* Kategori */
DO:
    /* Dersom poststed inneholder verdi, skal dette tas med i s›ket */
    sokNavn = " ".
    sokSted = FILL-IN-poststed:SCREEN-VALUE.
    sokDistrikt = " ".
    ASSIGN FILL-IN-navn = sokNavn.
    COMBO-BOX_kundedistriktnr:SCREEN-VALUE = sokDistrikt.
    DISPLAY FILL-IN-navn WITH FRAME DEFAULT-frame.   
    
    DISPLAY COMBO-BOX_kundedistriktnr WITH FRAME DEFAULT-frame.
        IF sokSted = ? or soksted = ' ' THEN do: 
          OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
              WHERE NPKUNDE.kundekategori = SELF:SCREEN-VALUE
               BY NPKUNDE.kundenavn DESCENDING.
MESSAGE 1 self:screen-value skip soksted length(soksted)
VIEW-AS ALERT-BOX.
        end.
        ELSE do:
          OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK
              WHERE NPKUNDE.kundekategori = SELF:SCREEN-VALUE 
              AND NPKUNDE.poststed = sokSted  BY NPKUNDE.kundenavn DESCENDING.
              
MESSAGE 2 self:screen-value skip soksted
VIEW-AS ALERT-BOX.
       end.
    IF AVAILABLE NPKUNDE THEN DO:
         APPLY 'VALUE-CHANGED' TO BROWSE-Kunder.
         APPLY 'ENTRY' TO BROWSE-Kunder.
         RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = "":U.       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-navn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-navn Win-Kundekartotek
ON LEAVE OF FILL-IN-navn IN FRAME DEFAULT-FRAME
OR RETURN OF FILL-IN-navn DO:
    sokNavn = SELF:SCREEN-VALUE.
    sokSted = " ".
    sokKategori = " ".
    sokDistrikt = " ".
    ASSIGN FILL-IN-poststed = sokSted.
    COMBO-BOX_Kundekategori:SCREEN-VALUE = sokKategori.
    COMBO-BOX_kundedistriktnr:SCREEN-VALUE = sokDistrikt.
    DISPLAY FILL-IN-poststed WITH FRAME DEFAULT-FRAME.   
    DISPLAY COMBO-BOX_Kundekategori WITH FRAME DEFAULT-FRAME.
    DISPLAY COMBO-BOX_kundedistriktnr WITH FRAME DEFAULT-FRAME.
    IF   SELF:SCREEN-VALUE NE "":U THEN
    DO:
        CASE COMBO-BOX-navn:SCREEN-VALUE:
            WHEN 'Begynner med' THEN          
                OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
                  WHERE NPKUNDE.kundenavn BEGINS SELF:SCREEN-VALUE
                USE-INDEX ndx_kundenavn.
            WHEN  'Er lik' THEN
                OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
                  WHERE NPKUNDE.kundenavn = CAPS(SELF:SCREEN-VALUE)  
                USE-INDEX ndx_kundenavn.
            WHEN 'Inneholder' THEN
                OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
                  WHERE NPKUNDE.kundenavn MATCHES "*" + CAPS(SELF:SCREEN-VALUE) + "*"
                USE-INDEX ndx_kundenavn.
        END CASE.    
    END.
ELSE
          OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK /*USE-INDEX ndx_anlegg,*/ 
                USE-INDEX ndx_kundenavn.

    IF AVAILABLE NPKUNDE THEN DO:
         APPLY 'VALUE-CHANGED' TO BROWSE-Kunder.
         APPLY 'ENTRY' TO BROWSE-Kunder.
         RETURN NO-APPLY.
    END.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-postnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-postnr Win-Kundekartotek
ON LEAVE OF FILL-IN-postnr IN FRAME DEFAULT-FRAME /* Postnr */
OR RETURN OF FILL-IN-postnr DO:
/* NB: Dersom kundekategori inneholder verdi, skal denne tas med i søket */
    sokNavn = " ".
    sokPnr = SELF:SCREEN-VALUE.
    sokSted = "".
    sokKategori = COMBO-BOX_Kundekategori:SCREEN-VALUE.
    sokDistrikt = " ".
    ASSIGN FILL-IN-navn = sokNavn.
    COMBO-BOX_kundedistriktnr:SCREEN-VALUE = sokDistrikt.
    DISPLAY FILL-IN-navn WITH FRAME DEFAULT-frame.   
    DISPLAY COMBO-BOX_kundedistriktnr WITH FRAME DEFAULT-frame.
    IF   SELF:SCREEN-VALUE NE "":U THEN
    DO:
        IF sokKategori = ? THEN
            OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK  
               WHERE NPKUNDE.postnr BEGINS CAPS(SELF:SCREEN-VALUE) 
                     BY NPKUNDE.kundenavn.
        ELSE
             OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK  
                WHERE NPKUNDE.postnr BEGINS CAPS(SELF:SCREEN-VALUE) 
                 AND NPKUNDE.kundekategori = sokKategori  BY NPKUNDE.kundenavn.
    END.
    ELSE
        IF sokKategori = ? THEN
             OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK
                   BY NPKUNDE.kundenavn.
        ELSE
             OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK
             WHERE NPKUNDE.kundekategori = sokKategori  BY NPKUNDE.kundenavn.
    IF AVAILABLE NPKUNDE THEN DO:
         APPLY 'VALUE-CHANGED' TO BROWSE-Kunder.
         APPLY 'ENTRY' TO BROWSE-Kunder.
         RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = "":U.       

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN-poststed
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN-poststed Win-Kundekartotek
ON LEAVE OF FILL-IN-poststed IN FRAME DEFAULT-FRAME
OR RETURN OF FILL-IN-poststed DO:
/* NB: Dersom kundekategori inneholder verdi, skal denne tas med i søket */
    sokNavn = " ".
    sokSted = SELF:SCREEN-VALUE.
    sokKategori = COMBO-BOX_Kundekategori:SCREEN-VALUE.
    sokDistrikt = " ".
    ASSIGN FILL-IN-navn = sokNavn.
    COMBO-BOX_kundedistriktnr:SCREEN-VALUE = sokDistrikt.
    DISPLAY FILL-IN-navn WITH FRAME DEFAULT-frame.   
    DISPLAY COMBO-BOX_kundedistriktnr WITH FRAME DEFAULT-frame.
    IF   SELF:SCREEN-VALUE NE "":U THEN
    DO:
        CASE COMBO-BOX-poststed:SCREEN-VALUE:
            WHEN 'Begynner med' THEN          
                IF sokKategori = ? THEN
                    OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK  
                       WHERE NPKUNDE.poststed BEGINS CAPS(SELF:SCREEN-VALUE) 
                     BY NPKUNDE.kundenavn.
                ELSE
                    OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK  
                       WHERE NPKUNDE.poststed BEGINS CAPS(SELF:SCREEN-VALUE) 
                       AND NPKUNDE.kundekategori = sokKategori
                     BY NPKUNDE.kundenavn.
            WHEN  'Er lik' THEN
                IF sokKategori = ? THEN
                    OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
                       WHERE NPKUNDE.poststed = CAPS(SELF:SCREEN-VALUE) 
                     BY NPKUNDE.kundenavn.
                ELSE
                    OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
                       WHERE NPKUNDE.poststed = CAPS(SELF:SCREEN-VALUE) 
                       AND NPKUNDE.kundekategori = sokKategori
                     BY NPKUNDE.kundenavn.
            WHEN 'Inneholder' THEN
                IF sokKategori = ? THEN
                    OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
                       WHERE NPKUNDE.poststed MATCHES "*" + CAPS(SELF:SCREEN-VALUE) + "*"
                     BY NPKUNDE.kundenavn.
                ELSE
                    OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK 
                        WHERE NPKUNDE.poststed MATCHES "*" + CAPS(SELF:SCREEN-VALUE) + "*"
                       AND NPKUNDE.kundekategori = sokKategori
                    BY NPKUNDE.kundenavn.
        END CASE.    
    END.
ELSE
        IF sokKategori = ? THEN
             OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK
                   BY NPKUNDE.kundenavn.
        ELSE
             OPEN QUERY BROWSE-Kunder FOR EACH NPKUNDE NO-LOCK
             WHERE NPKUNDE.kundekategori = sokKategori  BY NPKUNDE.kundenavn.
    IF AVAILABLE NPKUNDE THEN DO:
         APPLY 'VALUE-CHANGED' TO BROWSE-Kunder.
         APPLY 'ENTRY' TO BROWSE-Kunder.
         RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = "":U.       
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Denne_kunden_-_2_sider
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Denne_kunden_-_2_sider Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Denne_kunden_-_2_sider /* Denne kunden - 2 sider */
DO:
    kundenrParam = NPKUNDE.kundenr.
    RUN aderb/_prntrb2.p
        ("report\norshunt.prl",                /* RB-REPORT-LIBRARY */
        "Kundekort",                                                                       /* RB-REPORT-NAME */
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),                                                                                           /* RB-DB-CONNECTION */
        "O",                                                                                       /* RB-INCLUDE-RECORDS - letter O*/
        "NPKUNDE.kundenr = '" + kundenrParam + "'",   /* RB-FILTER */
        "",                                                                                          /* RB-MEMO-FILE */
        "",                                                                                          /* RB-PRINT-DESTINATION */
        h:private-data,
        "",                                                                                          /* RB-PRINTER-PORT */
        "",                                                                                          /* RB-OUTPUT-FILE */  
        0,                                                                                          /* RB-NUMBER-COPIES - zero */
        1,                                                                                          /* RB-BEGIN-PAGE -zero */
        2,                                                                                          /* RB-END-PAGE - zero */
        no,                                                                                       /* RB-TEST-PATTERN */
        "kundekort",                                                                    /* RB-WINDOW-TITLE */
        yes,                                                                                    /* RB-DISPLAY-ERRORS */
        yes,                                                                                    /* RB-DISPLAY-STATUS */
        no,                                                                                      /* RB-NO-WAIT */
        "",                                                                                      /* RB-OTHER-PARAMETERS */
        "status.out").                                                                  /*RB-STATUS-FILE */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Denne_kunden_utskrift
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Denne_kunden_utskrift Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Denne_kunden_utskrift /* Denne kunden */
DO:   
    kundenrParam = NPKUNDE.kundenr.
    RUN aderb/_prntrb2.p
        ("report\norshunt.prl",                /* RB-REPORT-LIBRARY */
        "Kundekort",                                                                       /* RB-REPORT-NAME */
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),                                                                                           /* RB-DB-CONNECTION */
        "O",                                                                                       /* RB-INCLUDE-RECORDS - letter O*/
        "NPKUNDE.kundenr = '" + kundenrParam + "'",   /* RB-FILTER */
        "",                                                                                          /* RB-MEMO-FILE */
        "",                                                                                          /* RB-PRINT-DESTINATION */
        h:private-data,
        "",                                                                                          /* RB-PRINTER-PORT */
        "",                                                                                          /* RB-OUTPUT-FILE */  
        0,                                                                                          /* RB-NUMBER-COPIES - zero */
        0,                                                                                          /* RB-BEGIN-PAGE -zero */
        0,                                                                                          /* RB-END-PAGE - zero */
        no,                                                                                       /* RB-TEST-PATTERN */
        "kundekort",                                                                    /* RB-WINDOW-TITLE */
        yes,                                                                                    /* RB-DISPLAY-ERRORS */
        yes,                                                                                    /* RB-DISPLAY-STATUS */
        no,                                                                                      /* RB-NO-WAIT */
        "",                                                                                      /* RB-OTHER-PARAMETERS */
        "status.out").                                                                  /*RB-STATUS-FILE */
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endrekunde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endrekunde Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Endrekunde /* Endre.. */
DO:
    nyRecord = FALSE.
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    kundenrParam = NPKUNDE.kundenr.
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(kundenrParam).
    Current-Kunde-Rec = ROWID(NPKUNDE).
    RUN KUNDERED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
    {&OPEN-BROWSERS-IN-QUERY-Browse-Kunder}
     REPOSITION Browse-Kunder TO ROWID(Current-Kunde-Rec).
     APPLY 'VALUE-CHANGED' TO Browse-Kunder
           IN FRAME DEFAULT-FRAME.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endreoppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endreoppf Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Endreoppf /* Endre... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = FALSE. 
    kundenrParam = NPKUNDEOPPF.kundenr.
    oppfidParam = NPKUNDEOPPF.oppf_id.
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(kundenrParam).
    Current-Oppf-Rec = ROWID(NPKUNDEOPPF).
    RUN KUNOPRED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
    {&OPEN-BROWSERS-IN-QUERY-Browse-Oppf}
     REPOSITION Browse-Oppf TO ROWID(Current-Oppf-Rec).
     APPLY 'VALUE-CHANGED' TO Browse-Oppf
           IN FRAME FRAME-Oppf.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kundehode_liste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kundehode_liste Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Kundehode_liste /* Kundekort uten tillegg */
DO:
  /*Lagt inn av Geir Otto som kopi av utv..., det for å gjøre jobben minst mulig.
     Jeg har ikke endret noe annet enn rapportnavn
  */
    DEFINE VAR cParmString AS CHAR INITIAL "".
    DEFINE VAR lTom AS LOGICAL INITIAL TRUE.
    DEFINE VAR cKundenavn AS CHAR INITIAL "".
    DEFINE VAR cKategori AS CHAR INITIAL "".
    DEFINE VAR cPostnr AS CHAR INITIAL "".
    DEFINE VAR cPoststed AS CHAR INITIAL "".
    DEFINE VAR cDistrikt AS CHAR INITIAL "".
    DEFINE VAR dFraDato AS DATE INITIAL ?.
    DEFINE VAR dTilDato AS DATE INITIAL ?. 
    DEFINE VAR dag AS INTEGER.
    DEFINE VAR mnd AS INTEGER.
    DEFINE VAR aar AS INTEGER.
    DEFINE VAR cSaksbehandler AS CHAR.
    DEFINE VAR cAktivitet AS CHAR.
    DEFINE VAR cDmKode AS CHAR.
    DEFINE VAR iReturverdi AS INTEGER INITIAL 0.
            
     /* Hent inn parameter */
            RUN KUOPPARM.W PERSISTENT (INPUT-OUTPUT cKundenavn, INPUT-OUTPUT cKategori, 
                INPUT-OUTPUT  cPostnr, 
                INPUT-OUTPUT cPoststed, INPUT-OUTPUT cDistrikt, INPUT-OUTPUT dFraDato, 
                INPUT-OUTPUT dTilDato, INPUT-OUTPUT cSaksbehandler, INPUT-OUTPUT cAktivitet, 
                INPUT-OUTPUT cDmKode, INPUT-OUTPUT iReturverdi).
        IF iReturverdi = 0 THEN
            RETURN NO-APPLY.
            
           /* Kundenavn */
            IF cKundenavn <> "" AND cKundenavn <> ? THEN DO:                
                cParmString =  'NPKUNDE.kundenavn MATCHES ' + "'" + cKundenavn + "*'".
                lTom = FALSE.
            END.
           /* Kategori */
            IF cKategori <> "" AND cKategori <> ? THEN DO:                
                 IF lTom THEN DO:
                    cParmString =  'NPKUNDE.kundekategori = ' + "'" + cKategori + "'".
                    lTom = FALSE.
                 END.
                 ELSE
                    cParmString =  cParmString + ' AND NPKUNDE.kundekategori = ' + "'" + cKategori + "'".                
            END.
            /* Postnummer */
            IF cPostnr <> "" AND cPostnr <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPKUNDE.postnr MATCHES ' + "'" + cPostnr + "*'".
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPKUNDE.postnr MATCHES ' + "'" + cPostnr + "*'".
            END.
            /* Poststed */
            IF cPoststed <> "" AND cPoststed <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPKUNDE.poststed MATCHES ' + "'" + cPoststed + "*'".
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPKUNDE.poststed MATCHES ' + "'" + cPoststed + "*'".
            END.
            /* Distrikt */
            IF cDistrikt <> "" AND cDistrikt <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPKUNDE.kundedistriktnr = ' + "'" + cDistrikt + "'".
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPKUNDE.kundedistriktnr = ' + "'" + cDistrikt + "'".
            END.
            /* Fra dato */
            IF dFraDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                       cParmString =  'NPKUNDEOPPF.neste_kontakt >= ' + STRING(mnd) + '/' + 
                        STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                        cParmString =  cParmString + 
                            ' AND NPKUNDEOPPF.neste_kontakt >= ' + STRING(mnd) + '/' + 
                            STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Til dato */
            IF dTilDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  'NPKUNDEOPPF.neste_kontakt <= ' + STRING(mnd) + '/' + 
                     STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  cParmString + 
                        ' AND NPKUNDEOPPF.neste_kontakt <= ' + STRING(mnd) + '/' + 
                         STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Saksbehandler */
            IF cSaksbehandler <> ? THEN  DO:                
                 IF lTom THEN DO:
                       cParmString =  'NPKUNDEOPPF.kontaktet_av = ' + "'" + cSaksbehandler + "'".
                     lTom = FALSE.
                END.
                ELSE
                       cParmString =  cParmString + ' AND NPKUNDEOPPF.kontaktet_av = ' + "'" + cSaksbehandler + "'".
            END.
            /* Aktivitet */
            IF cAktivitet <> ? THEN DO:
                 IF lTom THEN DO:
                    cParmString = 'NPKUNDEOPPF.aktivitet = ' + "'" + cAktivitet + "'".
                    lTom = FALSE.
                END.
                ELSE
                    cParmString =  cParmString + ' AND NPKUNDEOPPF.aktivitet = ' + "'" + cAktivitet + "'".
            END.
            /* DM kode */
            IF cDmKode <> ? THEN DO:
                 IF lTom THEN DO:
                    cParmString = 'NPKUNDE.dm_kode = ' + "'" + cDmKode + "'".
                    lTom = FALSE.
                END.
                ELSE
                 cParmString =  cParmString + ' AND NPKUNDE.dm_kode = ' + "'" + cDmKode + "'".
            END.
                

/* MESSAGE cParmString view-as alert-box title 'Parameterstreng'. */
            /* Ble det mottat noen parameter ? */
            IF cParmString = "" THEN DO:    
                MESSAGE 'Ingen utvalgsparameter ble valgt' VIEW-AS ALERT-BOX TITLE 'Stopp'.
                RETURN NO-APPLY.            
            END.
            RUN aderb/_printrb.p
                ("report\norshunt.prl",
                "Nytt kundekort",  /*kundekort*/
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        h:private-data,
                "",
                "",
                0,
                0,
                0,
                no,
                "Kundekort uten tillegg",
                yes,
                yes,
                no,
                "").        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Minibrev_utskrift
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Minibrev_utskrift Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Minibrev_utskrift /* Minibrev */
DO:
    kundenrParam = NPKUNDE.kundenr.
    oppfidParam = NPKUNDEOPPF.oppf_id.
    RUN aderb/_printrb.p
        ("report\norshunt.prl",
        "Minibrev",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "NPKUNDE.kundenr = '" + kundenrParam + "' AND
        NPKUNDEOPPF.oppf_id = "  + STRING(oppfIdParam),
        "",
        "",
        h:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Minibrev",
        yes,
        yes,
        no,
        "").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nykunde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nykunde Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Nykunde /* Ny... */
DO:
    nyRecord = TRUE.
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(kundenrParam).
    RUN KUNDERED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
    FIND NPKUNDE WHERE ROWID(NPKUNDE) = Current-Kunde-Rec NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE NPKUNDE THEN DO:
          {&OPEN-BROWSERS-IN-QUERY-Browse-Kunder}
            REPOSITION Browse-Kunder TO ROWID(Current-Kunde-Rec).
            APPLY 'VALUE-CHANGED' TO Browse-Kunder
                IN FRAME DEFAULT-FRAME.          
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nyoppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nyoppf Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Nyoppf /* Ny... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    nyRecord = TRUE. 
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(kundenrParam).
    RUN KUNOPRED.W (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
    FIND NPKUNDEOPPF  WHERE ROWID(NPKUNDEOPPF) = Current-Oppf-Rec 
        NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE NPKUNDEOPPF THEN DO:
          {&OPEN-BROWSERS-IN-QUERY-FRAME-Oppf}
           REPOSITION Browse-Oppf TO ROWID(Current-Oppf-Rec).
          MENU-ITEM m_Endreoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
          MENU-ITEM m_Sletteoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
    END.   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Oppdater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Oppdater Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Oppdater /* Oppdater */
DO:
  run kundenr.w.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slettekunde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slettekunde Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Slettekunde /* Slette... */
DO:
    DEFINE VAR cur_rec AS RECID.
    
      MESSAGE "Vil du slette denne kunden med tilhørende oppfølgingslogg?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = RECID(NPKUNDE).
                DO TRANSACTION:
                    FIND NPKUNDE WHERE RECID(NPKUNDE)  = cur_rec  EXCLUSIVE-LOCK
                        NO-ERROR NO-WAIT.
                     IF AVAILABLE(NPKUNDE) THEN
                             DO:
                                 DELETE NPKUNDE.
                                  pointer = SESSION:SET-WAIT-STATE("").
                                 {&OPEN-BROWSERS-IN-QUERY-DEFAULT-Frame}
                                  GET FIRST Browse-Kunder.   
                                  IF AVAILABLE NPKUNDE THEN 
                                      DO:
                                          kundeRow =  Browse-Kunder:SELECT-ROW(1) IN FRAME DEFAULT-Frame.
                                          APPLY 'VALUE-CHANGED' TO Browse-Kunder.
                                     END.
                               END.
                    /* Oppf›lgingslogg slettes i trigger */
                    ELSE
                      DO:
                         MESSAGE 'Tabellen for kunder er i bruk. Prøv igjen om en stund' 
                             VIEW-AS ALERT-BOX TITLE 'Sletting'.
                          RETURN.
                     END.
                END.
           STATUS DEFAULT "                                                             ".
           END.
         END CASE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sletteoppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sletteoppf Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Sletteoppf /* Slette... */
DO:
    DEFINE VAR cur_rec AS RECID.
    
      MESSAGE "Vil du slette denne  oppfølgingen?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = RECID(NPKUNDEOPPF).
                DO TRANSACTION:
                    FIND NPKUNDEOPPF WHERE RECID(NPKUNDEOPPF)  = cur_rec  EXCLUSIVE-LOCK
                        NO-ERROR NO-WAIT.
                     IF AVAILABLE(NPKUNDEOPPF) THEN
                             DO:
                                 DELETE NPKUNDEOPPF.
                                  pointer = SESSION:SET-WAIT-STATE("").
                                 {&OPEN-BROWSERS-IN-QUERY-Frame-Oppf}
                                  GET FIRST Browse-Oppf.   
                                  IF AVAILABLE NPKUNDEOPPF THEN 
                                      DO:
                                            oppfRow =  Browse-Oppf:SELECT-ROW(1) IN FRAME Frame-Oppf.
                                          APPLY 'VALUE-CHANGED' TO Browse-Oppf.
                                     END.
                               END.
                    /* Oppfølgingslogg slettes i trigger */
                    ELSE
                      DO:
                         MESSAGE 'Tabellen for kunder er i bruk. Prøv igjen om en stund' 
                             VIEW-AS ALERT-BOX TITLE 'Sletting'.
                          RETURN.
                     END.
                END.
           STATUS DEFAULT "                                                             ".
           END.
         END CASE.
  GET FIRST Browse-Oppf.   
   IF AVAILABLE NPKUNDEOPPF THEN 
   DO:
        MENU-ITEM m_Endreoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
        MENU-ITEM m_Sletteoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
    END.   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Utvalg_utskrift
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Utvalg_utskrift Win-Kundekartotek
ON CHOOSE OF MENU-ITEM m_Utvalg_utskrift /* Utvalg... */
DO:
    DEFINE VAR cParmString AS CHAR INITIAL "".
    DEFINE VAR lTom AS LOGICAL INITIAL TRUE.
    DEFINE VAR cKundenavn AS CHAR INITIAL "".
    DEFINE VAR cKategori AS CHAR INITIAL "".
    DEFINE VAR cPostnr AS CHAR INITIAL "".
    DEFINE VAR cPoststed AS CHAR INITIAL "".
    DEFINE VAR cDistrikt AS CHAR INITIAL "".
    DEFINE VAR dFraDato AS DATE INITIAL ?.
    DEFINE VAR dTilDato AS DATE INITIAL ?. 
    DEFINE VAR dag AS INTEGER.
    DEFINE VAR mnd AS INTEGER.
    DEFINE VAR aar AS INTEGER.
    DEFINE VAR cSaksbehandler AS CHAR.
    DEFINE VAR cAktivitet AS CHAR.
    DEFINE VAR cDmKode AS CHAR.
    DEFINE VAR iReturverdi AS INTEGER INITIAL 0.
            
     /* Hent inn parameter */
            RUN KUOPPARM.W PERSISTENT (INPUT-OUTPUT cKundenavn, INPUT-OUTPUT cKategori, 
                INPUT-OUTPUT  cPostnr, 
                INPUT-OUTPUT cPoststed, INPUT-OUTPUT cDistrikt, INPUT-OUTPUT dFraDato, 
                INPUT-OUTPUT dTilDato, INPUT-OUTPUT cSaksbehandler, INPUT-OUTPUT cAktivitet, 
                INPUT-OUTPUT cDmKode, INPUT-OUTPUT iReturverdi).
        IF iReturverdi = 0 THEN
            RETURN NO-APPLY.
            
           /* Kundenavn */
            IF cKundenavn <> "" AND cKundenavn <> ? THEN DO:                
                cParmString =  'NPKUNDE.kundenavn MATCHES ' + "'" + cKundenavn + "*'".
                lTom = FALSE.
            END.
           /* Kategori */
            IF cKategori <> "" AND cKategori <> ? THEN DO:                
                 IF lTom THEN DO:
                    cParmString =  'NPKUNDE.kundekategori = ' + "'" + cKategori + "'".
                    lTom = FALSE.
                 END.
                 ELSE
                    cParmString =  cParmString + ' AND NPKUNDE.kundekategori = ' + "'" + cKategori + "'".                
            END.
            /* Postnummer */
            IF cPostnr <> "" AND cPostnr <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPKUNDE.postnr MATCHES ' + "'" + cPostnr + "*'".
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPKUNDE.postnr MATCHES ' + "'" + cPostnr + "*'".
            END.
            /* Poststed */
            IF cPoststed <> "" AND cPoststed <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPKUNDE.poststed MATCHES ' + "'" + cPoststed + "*'".
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPKUNDE.poststed MATCHES ' + "'" + cPoststed + "*'".
            END.
            /* Distrikt */
            IF cDistrikt <> "" AND cDistrikt <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPKUNDE.kundedistriktnr = ' + "'" + cDistrikt + "'".
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPKUNDE.kundedistriktnr = ' + "'" + cDistrikt + "'".
            END.
            /* Fra dato */
            IF dFraDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                       cParmString =  'NPKUNDEOPPF.neste_kontakt >= ' + STRING(mnd) + '/' + 
                        STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                        cParmString =  cParmString + 
                            ' AND NPKUNDEOPPF.neste_kontakt >= ' + STRING(mnd) + '/' + 
                            STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Til dato */
            IF dTilDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  'NPKUNDEOPPF.neste_kontakt <= ' + STRING(mnd) + '/' + 
                     STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  cParmString + 
                        ' AND NPKUNDEOPPF.neste_kontakt <= ' + STRING(mnd) + '/' + 
                         STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Saksbehandler */
            IF cSaksbehandler <> ? THEN  DO:                
                 IF lTom THEN DO:
                       cParmString =  'NPKUNDEOPPF.kontaktet_av = ' + "'" + cSaksbehandler + "'".
                     lTom = FALSE.
                END.
                ELSE
                       cParmString =  cParmString + ' AND NPKUNDEOPPF.kontaktet_av = ' + "'" + cSaksbehandler + "'".
            END.
            /* Aktivitet */
            IF cAktivitet <> ? THEN DO:
                 IF lTom THEN DO:
                    cParmString = 'NPKUNDEOPPF.aktivitet = ' + "'" + cAktivitet + "'".
                    lTom = FALSE.
                END.
                ELSE
                    cParmString =  cParmString + ' AND NPKUNDEOPPF.aktivitet = ' + "'" + cAktivitet + "'".
            END.
            /* DM kode */
            IF cDmKode <> ? THEN DO:
                 IF lTom THEN DO:
                    cParmString = 'NPKUNDE.dm_kode = ' + "'" + cDmKode + "'".
                    lTom = FALSE.
                END.
                ELSE
                 cParmString =  cParmString + ' AND NPKUNDE.dm_kode = ' + "'" + cDmKode + "'".
            END.
                

/* MESSAGE cParmString view-as alert-box title 'Parameterstreng'. */
            /* Ble det mottat noen parameter ? */
            IF cParmString = "" THEN DO:    
                MESSAGE 'Ingen utvalgsparameter ble valgt' VIEW-AS ALERT-BOX TITLE 'Stopp'.
                RETURN NO-APPLY.            
            END.
            RUN aderb/_printrb.p
                ("report\norshunt.prl",
                "kundekort",  
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        h:private-data,
                "",
                "",
                0,
                0,
                0,
                no,
                "Kundekort med utvalg",
                yes,
                yes,
                no,
                "").        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-kunder
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Win-Kundekartotek 


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
  RUN enable_UI.
  assign 
    COMBO-BOX_kundedistriktnr:DELIMITER = '|' 
    combo-box_kundedistriktnr:LIST-ITEM-PAIRS = '|0|' + JBoxServerAPI:Instance:FieldList('NPKundedistrikt;KundeDistriktNr|KundeDistriktNavn;kundedistriktnr','where true')
    COMBO-BOX_kundekategori:DELIMITER = '|' 
    combo-box_kundekategori:LIST-ITEM-PAIRS = '||' + JBoxServerAPI:Instance:FieldList('NPKundekategori;KundeKategoriId|KundekategoriBeskrivelse;kundekategoriId','where true')
  .
   GET FIRST Browse-Kunder.   
   IF AVAILABLE NPKUNDE THEN 
   DO:
        MENU-ITEM m_Endrekunde:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
        MENU-ITEM m_Slettekunde:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
        MENU-ITEM m_Nyoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
        kundeRow =  Browse-Kunder:SELECT-ROW(1) IN FRAME DEFAULT-FRAME.
       APPLY 'VALUE-CHANGED' TO Browse-Kunder.
    END.   
   GET FIRST Browse-Oppf.   
   IF AVAILABLE NPKUNDEOPPF THEN 
   DO:
        MENU-ITEM m_Endreoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
        MENU-ITEM m_Sletteoppf:SENSITIVE IN MENU MENU-BAR-Win-Kundekartotek = YES.
    END.   
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent Win-Kundekartotek 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "ENTRY" TO NPKUNDE.kundenr IN FRAME DEFAULT-FRAME.
    DISABLE NPKUNDE.kundenr WITH FRAME DEFAULT-FRAME.
    HIDE NPKUNDE.kundenr.
    APPLY "ENTRY" TO FILL-IN-navn.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Win-Kundekartotek  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Win-Kundekartotek)
  THEN DELETE WIDGET Win-Kundekartotek.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Win-Kundekartotek  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-navn COMBO-BOX_kundekategori FILL-IN-navn COMBO-BOX-poststed 
          COMBO-BOX_kundedistriktnr FILL-IN-poststed FILL-IN-postnr 
      WITH FRAME DEFAULT-FRAME IN WINDOW Win-Kundekartotek.
  IF AVAILABLE NPKUNDE THEN 
    DISPLAY NPKUNDE.kundenr 
      WITH FRAME DEFAULT-FRAME IN WINDOW Win-Kundekartotek.
  ENABLE RECT-1 COMBO-BOX-navn COMBO-BOX_kundekategori FILL-IN-navn 
         NPKUNDE.kundenr COMBO-BOX-poststed COMBO-BOX_kundedistriktnr 
         FILL-IN-poststed FILL-IN-postnr BROWSE-kunder 
      WITH FRAME DEFAULT-FRAME IN WINDOW Win-Kundekartotek.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE BROWSE-Oppf 
      WITH FRAME FRAME-Oppf IN WINDOW Win-Kundekartotek.
  {&OPEN-BROWSERS-IN-QUERY-FRAME-Oppf}
  VIEW Win-Kundekartotek.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

