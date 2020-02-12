&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME PROSJEKTOVERSIKT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS PROSJEKTOVERSIKT 
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
DEF VAR appdata AS CHAR NO-UNDO. /*setter den via JboxSession:AppTitle*/
appdata = JBoxSession:Instance:AppTitle.

DEFINE VAR sokNavn AS CHAR INITIAL "".
DEFINE VAR sokNr AS INTEGER INITIAL 0.

/* Local Variable Definitions ---                                       */
DEF VAR Current-Rec AS ROWID.
DEFINE VAR nyRecord AS LOGICAL.
DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR prosjektRow AS LOGICAL.
DEFINE VAR Detail-Handle AS HANDLE.
DEFINE VAR prosjektNavnParam AS CHAR.
DEFINE VAR iNextProsjektnr AS INTEGER.
DEFINE VAR iCurProsjektnr AS INTEGER.
DEFINE VAR p-handle AS HANDLE.
DEFINE VARIABLE dbop-supported AS LOGICAL.
DEFINE VARIABLE dbop-db-name AS CHARACTER.
DEFINE VARIABLE dbop-tbl-name AS CHARACTER.
DEFINE VARIABLE nav-stat AS LOGICAL.
DEFINE VARIABLE browser-handle AS HANDLE.
DEFINE VAR bareAktive AS LOGICAL.
DEFINE VAR ip_neste_id AS INTEGER.
DEFINE QUERY Nytt-Sok FOR NORPROSJEKT SCROLLING.
DEFINE VAR cParmString AS CHAR INITIAL "".

DEF VAR hMainMenu AS HANDLE NO-UNDO. /*dummy handle*/
hMainMenu = SESSION:FIRST-PROCEDURE.

/* Disse styrer MDI - simulering */
/*IF THIS-PROCEDURE:PERSISTENT THEN         */
/*    THIS-PROCEDURE:PRIVATE-DATA = appdata.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WINDOW
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Prosjekt-Frame
&Scoped-define BROWSE-NAME BROWSE-Prosjekt

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NORPROSJEKT

/* Definitions for BROWSE BROWSE-Prosjekt                               */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Prosjekt NORPROSJEKT.prosjekt_navn ~
NORPROSJEKT.reg_dato NORPROSJEKT.aggregater NORPROSJEKT.shuntgrupper ~
NORPROSJEKT.spirovent NORPROSJEKT.aktivt NORPROSJEKT.prosjektid 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Prosjekt 
&Scoped-define QUERY-STRING-BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK ~
    BY NORPROSJEKT.reg_dato DESCENDING
&Scoped-define OPEN-QUERY-BROWSE-Prosjekt OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK ~
    BY NORPROSJEKT.reg_dato DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-Prosjekt NORPROSJEKT
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Prosjekt NORPROSJEKT


/* Definitions for FRAME Prosjekt-Frame                                 */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame ~
    ~{&OPEN-QUERY-BROWSE-Prosjekt}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-12 COMBO-BOX-prosjekt FILL-IN_prosjekt ~
FILL-IN_prosjektnr COMBO-BOX-prosjektnr TOGGLE-IKKE-AKTIVE-PROSJEKT ~
BROWSE-Prosjekt 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-prosjekt FILL-IN_prosjektnr ~
COMBO-BOX-prosjektnr TOGGLE-IKKE-AKTIVE-PROSJEKT 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRec PROSJEKTOVERSIKT 
FUNCTION getCurrentRec RETURNS ROWID
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrentRec PROSJEKTOVERSIKT 
FUNCTION setCurrentRec RETURNS LOGICAL
  (input ipRowid as rowid  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR PROSJEKTOVERSIKT AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Prosjekt 
       MENU-ITEM m_Nytt_Prosjekt LABEL "&Nytt..."       ACCELERATOR "CTRL-N"
       MENU-ITEM m_Endre_prosjekt LABEL "&Endre"         ACCELERATOR "CTRL-E"
       MENU-ITEM m_Slette_prosjekt LABEL "S&lette..."    .

DEFINE SUB-MENU m_Anlegg 
       MENU-ITEM m_Spirovent    LABEL "S&pirovent"     ACCELERATOR "ALT-CTRL-P"
       MENU-ITEM m_Shuntgrupper LABEL "&Shuntgrupper"  ACCELERATOR "ALT-CTRL-S"
       MENU-ITEM m_Aggregater   LABEL "&Aggregater"    ACCELERATOR "ALT-CTRL-A"
              DISABLED.

DEFINE SUB-MENU m_Utskrift_Prosjekt 
       MENU-ITEM m_prosjekt_Pr_Kunde LABEL "Pr. K&unde"    
       MENU-ITEM m_prosjekt_Pr_Konsulent LABEL "Pr. K&onsulent"
       MENU-ITEM m_prosjekt_Pr_SelgerUke LABEL "Pr. &Selger/Uke".

DEFINE SUB-MENU m_Oppflging_shunt 
       MENU-ITEM m_Kunder_shunt LABEL "&Kunder"       
       MENU-ITEM m_Kunder_utsendelse2 LABEL "K&under utsendelse"
       MENU-ITEM m_Konsulenter_shunt LABEL "K&onsulenter"  
       MENU-ITEM m_SelgerOppf_uke_shunt LABEL "&Selger/Oppf. uke"
       MENU-ITEM m_Sikre_tilbud_shunt LABEL "Sikre &tilbud" .

DEFINE SUB-MENU m_Shuntanlegg 
       SUB-MENU  m_Oppflging_shunt LABEL "Oppfølging"    
       RULE
       MENU-ITEM m_Sortering_Anlegg_shunt LABEL "Sortering: &Anlegg"
       MENU-ITEM m_Sortering_Anleggsnr_shunt LABEL "Sortering: Anleggs&nr"
       MENU-ITEM m_Anlegg_ett_Distrikt_shunt LABEL "Anlegg for ett &Distrikt".

DEFINE SUB-MENU m_Oppflging_spiro 
       MENU-ITEM m_Kunder_spiro LABEL "&Kunder"       
       MENU-ITEM m_Kunder_-_utsendelse LABEL "K&under - utsendelse"
       MENU-ITEM m_Konsulenter_spiro LABEL "K&onsulenter"  
       MENU-ITEM m_SelgerOppf_uke_spiro LABEL "&Selger/Oppf. uke"
       MENU-ITEM m_Sikre_tilbud_spiro LABEL "Sikre &tilbud" .

DEFINE SUB-MENU m_Spiroventanlegg 
       SUB-MENU  m_Oppflging_spiro LABEL "&Oppfølging"   
       RULE
       MENU-ITEM m_Sortering_Anlegg_spiro LABEL "Sortering: &Anlegg"
       MENU-ITEM m_Sortering_Anleggsnr_spiro LABEL "Sortering: Anleggs&nr"
       MENU-ITEM m_Anlegg_ett_Distrikt_spiro LABEL "Anlegg for ett &Distrikt".

DEFINE SUB-MENU m_Oppflging_agg 
       MENU-ITEM m_Kunder_agg   LABEL "&Kunder"       
       MENU-ITEM m_Kunder_utsendelse LABEL "K&under utsendelse"
       MENU-ITEM m_Konsulenter_agg LABEL "K&onsulenter"  
       MENU-ITEM m_SelgerOppf_uke_agg LABEL "&Selger/Oppf. uke"
       MENU-ITEM m_Sikre_tilbud_aggregat LABEL "Sikre &tilbud" .

DEFINE SUB-MENU m_Aggregatanlegg 
       SUB-MENU  m_Oppflging_agg LABEL "&Oppfølging"   
       RULE
       MENU-ITEM m_Sortering_Anlegg_agg LABEL "Sortering: &Anlegg"
       MENU-ITEM m_Sortering_Anleggsnr_agg LABEL "Sortering: Anleggs&nr"
       MENU-ITEM m_Anlegg_ett_Distrikt_agg LABEL "Anlegg for ett &Distrikt".

DEFINE SUB-MENU m_Aggregater_refliste 
       MENU-ITEM m_Velg_konsulent_aggref LABEL "Velg k&onsulent..."
       MENU-ITEM m_Velg_kunde_aggref LABEL "Velg k&unde..."
       MENU-ITEM m_Annet_kriterium_aggref LABEL "&Annet kriterium...".

DEFINE SUB-MENU m_Shunter_ref_liste 
       MENU-ITEM m_Velg_konsulent_shuntref LABEL "Velg k&onsulent..."
       MENU-ITEM m_Velg_kunde_shuntref LABEL "Velg k&unde..."
       MENU-ITEM m_Annet_kriterium_shuntref LABEL "&Annet kriterium...".

DEFINE SUB-MENU m_Spirovent_ref_liste 
       MENU-ITEM m_Velg_konsulent_sprioref LABEL "Velg k&onsulent..."
       MENU-ITEM m_Velg_kunde_spiroref LABEL "Velg k&unde..."
       MENU-ITEM m_Annet_kriterium_spiroref LABEL "&Annet kriterium...".

DEFINE SUB-MENU m_Referanseliste 
       SUB-MENU  m_Aggregater_refliste LABEL "&Aggregater"   
       SUB-MENU  m_Shunter_ref_liste LABEL "&Shunter"      
       SUB-MENU  m_Spirovent_ref_liste LABEL "S&pirovent"    .

DEFINE SUB-MENU m_Utskrift 
       MENU-ITEM m_Drilldown    LABEL "Drilldown"     
       SUB-MENU  m_Utskrift_Prosjekt LABEL "&Prosjekt"     
       SUB-MENU  m_Shuntanlegg  LABEL "&Shuntanlegg"  
       SUB-MENU  m_Spiroventanlegg LABEL "S&piroventanlegg"
       SUB-MENU  m_Aggregatanlegg LABEL "&Aggregatanlegg"
              DISABLED
       SUB-MENU  m_Referanseliste LABEL "&Referanseliste".

DEFINE MENU MAIN-MENU MENUBAR
       SUB-MENU  m_Prosjekt     LABEL "&Prosjekt"     
       SUB-MENU  m_Anlegg       LABEL "&Anlegg"       
       SUB-MENU  m_Utskrift     LABEL "Utskr&ift"     
       MENU-ITEM m_Avslutt      LABEL "Avslu&tt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE COMBO-BOX-prosjekt AS CHARACTER FORMAT "X(15)":U INITIAL "Inneholder" 
     LABEL "P&rosjekt" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Begynner med","Er lik","Inneholder" 
     DROP-DOWN-LIST
     SIZE 18 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE COMBO-BOX-prosjektnr AS CHARACTER FORMAT "X(12)":U INITIAL "St›rre enn" 
     LABEL "Prosjekt&nr" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Større enn","Lik" 
     DROP-DOWN-LIST
     SIZE 18.2 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN_prosjekt AS CHARACTER FORMAT "X(45)" 
     VIEW-AS FILL-IN 
     SIZE 89.2 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE VARIABLE FILL-IN_prosjektnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.2 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124 BY 3.14.

DEFINE VARIABLE TOGGLE-IKKE-AKTIVE-PROSJEKT AS LOGICAL INITIAL no 
     LABEL "Inn&kl. Ikke-aktive" 
     VIEW-AS TOGGLE-BOX
     SIZE 25 BY .76 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Prosjekt FOR 
      NORPROSJEKT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Prosjekt PROSJEKTOVERSIKT _STRUCTURED
  QUERY BROWSE-Prosjekt NO-LOCK DISPLAY
      NORPROSJEKT.prosjekt_navn FORMAT "X(43)":U COLUMN-FONT 2
      NORPROSJEKT.reg_dato FORMAT "99.99.9999":U COLUMN-FONT 2
      NORPROSJEKT.aggregater FORMAT "X(8)":U COLUMN-FONT 2
      NORPROSJEKT.shuntgrupper COLUMN-LABEL "Shunter" FORMAT "X(8)":U
            COLUMN-FONT 2
      NORPROSJEKT.spirovent FORMAT "X(8)":U COLUMN-FONT 2
      NORPROSJEKT.aktivt FORMAT "ja/nei":U COLUMN-FONT 2
      NORPROSJEKT.prosjektid FORMAT ">>>>>>>9":U COLUMN-FONT 2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 125 BY 13.33
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Prosjekt-Frame
     COMBO-BOX-prosjekt AT ROW 1.95 COL 15.2 COLON-ALIGNED
     FILL-IN_prosjekt AT ROW 1.95 COL 33.8 COLON-ALIGNED NO-LABEL
     FILL-IN_prosjektnr AT ROW 3.14 COL 42.2 RIGHT-ALIGNED NO-LABEL
     COMBO-BOX-prosjektnr AT ROW 3.19 COL 15.8 COLON-ALIGNED
     TOGGLE-IKKE-AKTIVE-PROSJEKT AT ROW 3.29 COL 44.8
     BROWSE-Prosjekt AT ROW 4.81 COL 1
     " Søke" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 1.19 COL 5.2
     RECT-12 AT ROW 1.52 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 126.2 BY 18.29
         FONT 2
         TITLE "Prosjektoversikt".


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
  CREATE WINDOW PROSJEKTOVERSIKT ASSIGN
         HIDDEN             = YES
         TITLE              = "Prosjekt"
         COLUMN             = 3
         ROW                = 1.48
         HEIGHT             = 18.29
         WIDTH              = 126.2
         MAX-HEIGHT         = 20.71
         MAX-WIDTH          = 126.2
         VIRTUAL-HEIGHT     = 20.71
         VIRTUAL-WIDTH      = 126.2
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
IF NOT PROSJEKTOVERSIKT:LOAD-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT PROSJEKTOVERSIKT:LOAD-SMALL-ICON("adeicon\progress":U) THEN
    MESSAGE "Unable to load small icon: adeicon\progress"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW PROSJEKTOVERSIKT
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME Prosjekt-Frame
   FRAME-NAME                                                           */
/* BROWSE-TAB BROWSE-Prosjekt TOGGLE-IKKE-AKTIVE-PROSJEKT Prosjekt-Frame */
ASSIGN 
       FRAME Prosjekt-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* SETTINGS FOR FILL-IN FILL-IN_prosjekt IN FRAME Prosjekt-Frame
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN FILL-IN_prosjektnr IN FRAME Prosjekt-Frame
   ALIGN-R                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(PROSJEKTOVERSIKT)
THEN PROSJEKTOVERSIKT:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Prosjekt
/* Query rebuild information for BROWSE BROWSE-Prosjekt
     _TblList          = "norcalc.NORPROSJEKT"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NORPROSJEKT.reg_dato|no"
     _FldNameList[1]   > norcalc.NORPROSJEKT.prosjekt_navn
"NORPROSJEKT.prosjekt_navn" ? "X(43)" "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > norcalc.NORPROSJEKT.reg_dato
"NORPROSJEKT.reg_dato" ? ? "date" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > norcalc.NORPROSJEKT.aggregater
"NORPROSJEKT.aggregater" ? ? "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > norcalc.NORPROSJEKT.shuntgrupper
"NORPROSJEKT.shuntgrupper" "Shunter" ? "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > norcalc.NORPROSJEKT.spirovent
"NORPROSJEKT.spirovent" ? ? "character" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > norcalc.NORPROSJEKT.aktivt
"NORPROSJEKT.aktivt" ? ? "logical" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > norcalc.NORPROSJEKT.prosjektid
"NORPROSJEKT.prosjektid" ? ? "integer" ? ? 2 ? ? ? no ? no no ? yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is OPENED
*/  /* BROWSE BROWSE-Prosjekt */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME PROSJEKTOVERSIKT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PROSJEKTOVERSIKT PROSJEKTOVERSIKT
ON HELP OF PROSJEKTOVERSIKT /* Prosjekt */
DO:
  MESSAGE "This basic navigation window can be used to browse through " +
      "record in one or more tables. Lay out database fields onto " +
      "the frame. You may also add a browser for a table which is " +
      "joinable to the first." VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-Prosjekt
&Scoped-define SELF-NAME BROWSE-Prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Prosjekt PROSJEKTOVERSIKT
ON DEFAULT-ACTION OF BROWSE-Prosjekt IN FRAME Prosjekt-Frame
DO:
  current-rec = rowid(norprosjekt).
  jboxSession:Instance:setJBoxAttribute('ProsjektIdParam',string(NORPROSJEKT.prosjektid)).
  jboxSession:Instance:setJBoxAttribute('ProsjektNavnParam',string(NORPROSJEKT.prosjekt_navn)).
/*goo - jboxrelation*/
/*  prosjektIdParam = NORPROSJEKT.prosjektid.     */
/*  prosjektNavnParam = NORPROSJEKT.prosjekt_navn.*/
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&Scoped-define SELF-NAME FILL-IN_prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_prosjekt PROSJEKTOVERSIKT
ON LEAVE OF FILL-IN_prosjekt IN FRAME Prosjekt-Frame
OR RETURN OF FILL-IN_prosjekt DO:
    sokNavn = SELF:SCREEN-VALUE.
    sokNr =0.
    ASSIGN FILL-IN_prosjektnr = sokNr.
    DISPLAY FILL-IN_prosjektnr WITH FRAME {&FRAME-NAME}.
    IF   SELF:SCREEN-VALUE NE "":U THEN
    DO:
        CASE COMBO-BOX-prosjekt:SCREEN-VALUE:            
            WHEN 'Begynner med' THEN    
            DO:
                IF bareAktive = TRUE THEN
                    OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
                       WHERE NORPROSJEKT.prosjekt_navn  MATCHES SELF:SCREEN-VALUE + "*"
                       AND NORPROSJEKT.aktivt  = TRUE
                    BY NORPROSJEKT.prosjekt_navn.
                ELSE         
                      OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
                       WHERE NORPROSJEKT.prosjekt_navn BEGINS SELF:SCREEN-VALUE
                    BY NORPROSJEKT.prosjekt_navn.
            END.
            WHEN  'Er lik' THEN
            DO:
                IF bareAktive = TRUE THEN
                    OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
                       WHERE NORPROSJEKT.prosjekt_navn  = SELF:SCREEN-VALUE
                       AND NORPROSJEKT.aktivt  = TRUE
                     BY NORPROSJEKT.prosjekt_navn.
                ELSE        
                    OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
                       WHERE NORPROSJEKT.prosjekt_navn  = SELF:SCREEN-VALUE
                     BY NORPROSJEKT.prosjekt_navn.
            END.
            WHEN 'Inneholder' THEN
             DO:
                IF bareAktive = TRUE THEN
                    OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
                       WHERE NORPROSJEKT.prosjekt_navn MATCHES "*" + SELF:SCREEN-VALUE + "*"
                       AND NORPROSJEKT.aktivt  = TRUE
                    BY NORPROSJEKT.prosjekt_navn.
                ELSE
                    OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
                       WHERE NORPROSJEKT.prosjekt_navn MATCHES "*" + SELF:SCREEN-VALUE + "*"
                    BY NORPROSJEKT.prosjekt_navn.
            END.
        END CASE.    
    END.
  ELSE
    IF bareAktive = TRUE THEN
        OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
           WHERE NORPROSJEKT.aktivt  = TRUE
             BY NORPROSJEKT.reg_dato DESCENDING.
    ELSE
      OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK
       BY NORPROSJEKT.reg_dato DESCENDING.

    IF AVAILABLE NORPROSJEKT THEN DO:
        APPLY "ENTRY" TO  BROWSE-Prosjekt.
         RETURN NO-APPLY.
    END.
    ELSE
      OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK
       BY NORPROSJEKT.reg_dato DESCENDING.
    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_prosjektnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_prosjektnr PROSJEKTOVERSIKT
ON LEAVE OF FILL-IN_prosjektnr IN FRAME Prosjekt-Frame
OR RETURN OF FILL-IN_prosjektnr DO:
    sokNr = INTEGER(SELF:SCREEN-VALUE).
    sokNavn = "".
    ASSIGN FILL-IN_prosjekt = sokNavn.
    DISPLAY FILL-IN_prosjekt WITH FRAME {&FRAME-NAME}.
   IF   SELF:SCREEN-VALUE NE "":U THEN
    DO:
        CASE COMBO-BOX-prosjektnr:SCREEN-VALUE:
            WHEN 'Større enn' THEN
            DO:
                IF bareAktive = TRUE THEN
                     OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK
                       WHERE NORPROSJEKT.prosjektid > INTEGER(SELF:SCREEN-VALUE)
                       AND NORPROSJEKT.aktivt  = TRUE
                    BY NORPROSJEKT.prosjektid DESCENDING.
                ELSE
                     OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK
                       WHERE NORPROSJEKT.prosjektid > INTEGER(SELF:SCREEN-VALUE)
                    BY NORPROSJEKT.prosjektid DESCENDING.
            END.
            WHEN  'Lik' THEN
                OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK
                  WHERE NORPROSJEKT.prosjektid = INTEGER(SELF:SCREEN-VALUE)
                BY NORPROSJEKT.prosjektid DESCENDING.
        END CASE.    
    END.
ELSE
     IF bareAktive = TRUE THEN
      OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK
       WHERE NORPROSJEKT.aktivt  = TRUE
       BY NORPROSJEKT.prosjektid DESCENDING.
    ELSE
      OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK
       BY NORPROSJEKT.prosjektid DESCENDING.

    IF AVAILABLE NORPROSJEKT THEN DO:
        APPLY 'ENTRY' TO BROWSE-Prosjekt.
         RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = "":U.       


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME MAIN-MENU
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL MAIN-MENU PROSJEKTOVERSIKT
ON CHOOSE OF MENU MAIN-MENU
DO:
/*    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    anleggsnrParam = NPSHANLG.anleggsnr.
    anleggsNavnParam = NPSHANLG.anlegg.
    Current-Rec = RECID(NPSHANLG).
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN SHUSYST.W  (INPUT THIS-PROCEDURE:PRIVATE-DATA,  INPUT anleggsNavnParam) NO-ERROR.
    APPLY "VALUE-CHANGED" TO ANLEGGS-BROWSE IN FRAME ANLEGG-FRAME.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Aggregater
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Aggregater PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Aggregater /* Aggregater */
DO:
/*  currentProsjektRow = ROWID(NORPROSJEKT).*/
  pointer = SESSION:SET-WAIT-STATE("GENERAL").
/*  prosjektIdParam = NORPROSJEKT.prosjektId.     */
/*  prosjektNavnParam = NORPROSJEKT.prosjekt_navn.*/
  RUN AGANLEGG.W  PERSISTENT  SET p-handle (INPUT  Prosjektoversikt:TITLE, INPUT prosjektNavnParam ) NO-ERROR.
  RUN appl_ent IN p-handle.
  {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}
   REPOSITION BROWSE-Prosjekt TO ROWID(current-rec).
   APPLY 'VALUE-CHANGED' TO BROWSE-Prosjekt   IN FRAME Prosjekt-Frame.            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Anlegg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Anlegg PROSJEKTOVERSIKT
ON CHOOSE OF MENU m_Anlegg /* Anlegg */
DO:
    SESSION:SET-WAIT-STATE("GENERAL").
/*    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(NORPROSJEKT.prosjektid).*/
    RUN SHUANLG.W  PERSISTENT SET p-handle.
    RUN appl_ent IN p-handle.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Anlegg_ett_Distrikt_agg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Anlegg_ett_Distrikt_agg PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Anlegg_ett_Distrikt_agg /* Anlegg for ett Distrikt */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR fraDistrikt AS CHAR  INITIAL "".
    
    MESSAGE 'Vil du skrive ut anlegsliste - aggregater for distrikt?' 
        VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
        DO:
            RUN SHANLDST.W PERSISTENT (INPUT-OUTPUT fraDistrikt).
            IF fraDistrikt = ""  THEN
                DO:
                    MESSAGE 'Distrikt ble ikke satt opp riktig' VIEW-AS ALERT-BOX TITLE 'Feil'.
                     RETURN NO-APPLY.
                END.
            RUN aderb/_prntrb2.p
           ("report\noragg.prl",
             "Anlegg-distrikt",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPAGANLG.kundedistriktnr = '" + fraDistrikt + "'  AND NPAGANLG.aktivt = TRUE",
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Anleggliste for distrikt",
            YES,
             YES,
            NO,
             "",
             "status.out").        
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Anlegg_ett_Distrikt_shunt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Anlegg_ett_Distrikt_shunt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Anlegg_ett_Distrikt_shunt /* Anlegg for ett Distrikt */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR fraDistrikt AS CHAR  INITIAL "".
    
    MESSAGE 'Vil du skrive ut anlegsliste - shunter for distrikt?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
        DO:
            RUN SHANLDST.W PERSISTENT (INPUT-OUTPUT fraDistrikt).
            IF fraDistrikt = ""  THEN
                DO:
                    MESSAGE 'Distrikt ble ikke satt opp riktig' VIEW-AS ALERT-BOX TITLE 'Feil'.
                     RETURN NO-APPLY.
                END.
            RUN aderb/_prntrb2.p
           ("report\norshunt.prl",
             "Anlegg-distrikt",
             JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSHANLG.kundedistriktnr = '" + fraDistrikt + "'  AND NPSHANLG.aktivt = TRUE",
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
            0,
            0,
             0,
            NO,
             "Anleggliste for distrikt",
            YES,
             YES,
            NO,
             "",
             "status.out").        
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Anlegg_ett_Distrikt_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Anlegg_ett_Distrikt_spiro PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Anlegg_ett_Distrikt_spiro /* Anlegg for ett Distrikt */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR fraDistrikt AS CHAR  INITIAL "".
    
    MESSAGE 'Vil du skrive ut anlegsliste - spirovent for distrikt?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
        DO:
            RUN SHANLDST.W PERSISTENT (INPUT-OUTPUT fraDistrikt).
            IF fraDistrikt = ""  THEN
                DO:
                    MESSAGE 'Distrikt ble ikke satt opp riktig' VIEW-AS ALERT-BOX TITLE 'Feil'.
                     RETURN NO-APPLY.
                END.
            RUN aderb/_prntrb2.p
           ("report\norvent.prl",
             "Anlegg-distrikt",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSPANLG.kundedistriktnr = '" + fraDistrikt + "'  AND NPSPANLG.aktivt = TRUE",
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Anleggliste for distrikt",
            YES,
             YES,
            NO,
             "",
             "status.out").        
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Annet_kriterium_aggref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Annet_kriterium_aggref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Annet_kriterium_aggref /* Annet kriterium... */
DO:
    DEFINE VAR lTom AS LOGICAL INITIAL TRUE.
    DEFINE VAR cAnleggsnavn AS CHAR INITIAL "".
    DEFINE VAR cProdukttype AS CHAR INITIAL "".
    DEFINE VAR iDistrikt AS INT INITIAL ?.
    DEFINE VAR dFraDato AS DATE INITIAL ?.
    DEFINE VAR dTilDato AS DATE INITIAL ?. 
    DEFINE VAR dag AS INTEGER.
    DEFINE VAR mnd AS INTEGER.
    DEFINE VAR aar AS INTEGER.
    DEFINE VAR visPris AS INTEGER INITIAL 0.
    DEFINE VAR iReturverdi AS INTEGER INITIAL 0.
            
     /* Hent inn parameter */
     RUN REFLPARM.W PERSISTENT (INPUT-OUTPUT cAnleggsnavn, 
                INPUT-OUTPUT cProdukttype, INPUT-OUTPUT iDistrikt, INPUT-OUTPUT dFraDato, 
                INPUT-OUTPUT dTilDato, INPUT-OUTPUT iReturverdi, INPUT-OUTPUT visPris).
        IF iReturverdi = 0 THEN
            RETURN NO-APPLY.
            
           /* Anleggsnavn */
            IF cAnleggsnavn <> "" AND cAnleggsnavn <> ? THEN DO:                
                cParmString =  'NPAGANLG.anlegg MATCHES ' + "'" + cAnleggsnavn + "*'".
                lTom = FALSE.
            END.
           /* Produkttype */
            IF cProdukttype <> "" AND cProdukttype <> ? THEN DO:                
                 IF lTom THEN DO:
                    cParmString =  'NPAGANLG.referanse_tekst MATCHES ' + "'*" + cProdukttype + "*'".
                    lTom = FALSE.
                 END.
                 ELSE
                    cParmString =  cParmString + ' AND NPAGANLG.referanse_tekst MATCHES ' + "'*" + 
                        cProdukttype + "*'".                
            END.
            /* Distrikt */
            IF iDistrikt <> 0 AND iDistrikt <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPAGANLG.kundedistriktnr = ' + string(iDistrikt).
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPAGANLG.kundedistriktnr = ' + string(iDistrikt).
            END.
            /* Fra dato */
            IF dFraDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                       cParmString =  'NPAGORD.leveringsdato >= ' + STRING(mnd) + '/' + 
                        STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                        cParmString =  cParmString + 
                            ' AND NPAGORD.leveringsdato >= ' + STRING(mnd) + '/' + 
                            STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Til dato */
            IF dTilDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  'NPAGORD.leveringsdato <= ' + STRING(mnd) + '/' + 
                     STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  cParmString + 
                        ' AND NPAGORD.leveringsdato <= ' + STRING(mnd) + '/' + 
                         STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Ble det mottat noen parameter ? */

/*MESSAGE cParmString view-as alert-box title 'Parameterstreng'.*/
            IF cParmString = "" THEN DO:    
                MESSAGE 'Ingen utvalgsparameter ble valgt' VIEW-AS ALERT-BOX TITLE 'Stopp'.
                RETURN NO-APPLY.            
            END.
            IF visPris = 0 THEN
                RUN prc_aggref_uten_pris.
        ELSE
                RUN prc_aggtref_med_pris.          
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Annet_kriterium_shuntref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Annet_kriterium_shuntref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Annet_kriterium_shuntref /* Annet kriterium... */
DO:
    DEFINE VAR lTom AS LOGICAL INITIAL TRUE.
    DEFINE VAR cAnleggsnavn AS CHAR INITIAL "".
    DEFINE VAR cProdukttype AS CHAR INITIAL "".
    DEFINE VAR iDistrikt AS INT INITIAL ?.
    DEFINE VAR dFraDato AS DATE INITIAL ?.
    DEFINE VAR dTilDato AS DATE INITIAL ?. 
    DEFINE VAR dag AS INTEGER.
    DEFINE VAR mnd AS INTEGER.
    DEFINE VAR aar AS INTEGER.
    DEFINE VAR visPris AS INTEGER INITIAL 0.
    DEFINE VAR iReturverdi AS INTEGER INITIAL 0.
            
     /* Hent inn parameter */
     RUN REFLPARM.W PERSISTENT (INPUT-OUTPUT cAnleggsnavn, 
                INPUT-OUTPUT cProdukttype, INPUT-OUTPUT iDistrikt, INPUT-OUTPUT dFraDato, 
                INPUT-OUTPUT dTilDato, INPUT-OUTPUT iReturverdi, INPUT-OUTPUT visPris).
        IF iReturverdi = 0 THEN
            RETURN NO-APPLY.
            
           /* Anleggsnavn */
            IF cAnleggsnavn <> "" AND cAnleggsnavn <> ? THEN DO:                
                cParmString =  'NPSHANLG.anlegg MATCHES ' + "'" + cAnleggsnavn + "*'".
                lTom = FALSE.
            END.
           /* Produkttype */
            IF cProdukttype <> "" AND cProdukttype <> ? THEN DO:                
                 IF lTom THEN DO:
                    cParmString =  'NPSHANLG.referanse_tekst MATCHES ' + "'*" + cProdukttype + "*'".
                    lTom = FALSE.
                 END.
                 ELSE
                    cParmString =  cParmString + ' AND NPSHANLG.referanse_tekst MATCHES ' + "'*" + 
                        cProdukttype + "*'".                
            END.
            /* Distrikt */
            IF iDistrikt <> 0 AND iDistrikt <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPSHANLG.kundedistriktnr = ' + string(iDistrikt).
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPSHANLG.kundedistriktnr = ' + string(iDistrikt).
            END.
            /* Fra dato */
            IF dFraDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                       cParmString =  'NPSHORD.leveringsdato >= ' + STRING(mnd) + '/' + 
                        STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                        cParmString =  cParmString + 
                            ' AND NPSHORD.leveringsdato >= ' + STRING(mnd) + '/' + 
                            STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Til dato */
            IF dTilDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  'NPSHORD.leveringsdato <= ' + STRING(mnd) + '/' + 
                     STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  cParmString + 
                        ' AND NPSHORD.leveringsdato <= ' + STRING(mnd) + '/' + 
                         STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Ble det mottat noen parameter ? */

/*MESSAGE cParmString view-as alert-box title 'Parameterstreng'.*/
            IF cParmString = "" THEN DO:    
                MESSAGE 'Ingen utvalgsparameter ble valgt' VIEW-AS ALERT-BOX TITLE 'Stopp'.
                RETURN NO-APPLY.            
            END.
            IF visPris = 0 THEN
                RUN prc_shuntref_uten_pris.
        ELSE
                RUN prc_shuntref_med_pris.          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Annet_kriterium_spiroref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Annet_kriterium_spiroref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Annet_kriterium_spiroref /* Annet kriterium... */
DO:
    DEFINE VAR lTom AS LOGICAL INITIAL TRUE.
    DEFINE VAR cAnleggsnavn AS CHAR INITIAL "".
    DEFINE VAR cProdukttype AS CHAR INITIAL "".
    DEFINE VAR iDistrikt AS INT INITIAL ?.
    DEFINE VAR dFraDato AS DATE INITIAL ?.
    DEFINE VAR dTilDato AS DATE INITIAL ?. 
    DEFINE VAR dag AS INTEGER.
    DEFINE VAR mnd AS INTEGER.
    DEFINE VAR aar AS INTEGER.
    DEFINE VAR visPris AS INTEGER INITIAL 0.
    DEFINE VAR iReturverdi AS INTEGER INITIAL 0.
            
     /* Hent inn parameter */
     RUN REFLPARM.W PERSISTENT (INPUT-OUTPUT cAnleggsnavn, 
                INPUT-OUTPUT cProdukttype, INPUT-OUTPUT iDistrikt, INPUT-OUTPUT dFraDato, 
                INPUT-OUTPUT dTilDato, INPUT-OUTPUT iReturverdi, INPUT-OUTPUT visPris).
        IF iReturverdi = 0 THEN
            RETURN NO-APPLY.
            
           /* Anleggsnavn */
            IF cAnleggsnavn <> "" AND cAnleggsnavn <> ? THEN DO:                
                cParmString =  'NPSPANLG.anlegg MATCHES ' + "'" + cAnleggsnavn + "*'".
                lTom = FALSE.
            END.
           /* Produkttype */
            IF cProdukttype <> "" AND cProdukttype <> ? THEN DO:                
                 IF lTom THEN DO:
                    cParmString =  'NPSPANLG.referanse_tekst MATCHES ' + "'*" + cProdukttype + "*'".
                    lTom = FALSE.
                 END.
                 ELSE
                    cParmString =  cParmString + ' AND NPSPANLG.referanse_tekst MATCHES ' + "'*" + 
                        cProdukttype + "*'".                
            END.
            /* Distrikt */
            IF iDistrikt <> 0 AND iDistrikt <> ? THEN  DO:                
                 IF lTom THEN DO:
                     cParmString =  'NPSPANLG.kundedistriktnr = ' + string(iDistrikt).
                     lTom = FALSE.
                END.
                ELSE
                     cParmString =  cParmString + ' AND NPSPANLG.kundedistriktnr = ' + string(iDistrikt).
            END.
            /* Fra dato */
            IF dFraDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                       cParmString =  'NPSPORD.leveringsdato >= ' + STRING(mnd) + '/' + 
                       STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                        dag = DAY(dFraDato).
                        mnd = MONTH (dFraDato).
                        aar = YEAR (dFraDato).
                        cParmString =  cParmString + 
                            ' AND NPSPORD.leveringsdato >= ' + STRING(mnd) + '/' + 
                            STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Til dato */
            IF dTilDato <> ? THEN  DO:                
                 IF lTom THEN DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  'NPSPORD.leveringsdato <= ' + STRING(mnd) + '/' + 
                     STRING(dag) + '/' + STRING(aar).
                     lTom = FALSE.
                END.
                ELSE DO:
                     dag = DAY(dTilDato).
                     mnd = MONTH (dTilDato).
                     aar = YEAR (dTilDato).
                     cParmString =  cParmString + 
                        ' AND NPSPORD.leveringsdato <= ' + STRING(mnd) + '/' + 
                         STRING(dag) + '/' + STRING(aar).
                END.
            END.
            /* Ble det mottat noen parameter ? */

/*MESSAGE cParmString view-as alert-box title 'Parameterstreng'.*/
            IF cParmString = "" THEN DO:    
                MESSAGE 'Ingen utvalgsparameter ble valgt' VIEW-AS ALERT-BOX TITLE 'Stopp'.
                RETURN NO-APPLY.            
            END.
            IF visPris = 0 THEN
                RUN prc_spiroref_uten_pris.
        ELSE
                RUN prc_spiroref_med_pris.          
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Avslutt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Avslutt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Avslutt /* Avslutt */
DO:
  APPLY "CLOSE" TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Drilldown
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Drilldown PROSJEKTOVERSIKT av
ON CHOOSE OF MENU-ITEM m_Drilldown /* Drilldown */
DO:
  DEF VAR hDataBrwWin AS HANDLE NO-UNDO.
  DEF VAR hDrilldown AS HANDLE NO-UNDO.
  
  RUN JBoxDataBrw.w PERSIST SET hDataBrwWin.

  IF VALID-HANDLE(hDataBrwWin) THEN 
  DO: 
    hDataBrwWin:CURRENT-WINDOW:TITLE = "Drilldown".
    RUN Drilldown.w PERSISTENT SET hDrilldown (hDataBrwWin).
    DYNAMIC-FUNCTION('setParent' IN hDataBrwWin,hDrilldown).
    RUN InitializeObject IN hDrillDown.
    SUBSCRIBE TO "InvalidateHandle" IN hDataBrwWin.
    SUBSCRIBE TO "InvalidateHandle" IN hDrilldown.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre_prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre_prosjekt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Endre_prosjekt /* Endre */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
/*    prosjektIdParam = NORPROSJEKT.prosjektid.*/
    JBoxSession:Instance:setJBoxAttribute('prosjektidparam',STRING(norprosjekt.prosjektid)).
    nyRecord = FALSE.
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + string(norprosjekt.prosjektid).
    Current-Rec = ROWID(NORPROSJEKT).
    RUN PROSJRED.W (INPUT-OUTPUT nyRecord) NO-ERROR.
    {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}
     REPOSITION BROWSE-Prosjekt TO ROWID(Current-Rec).
     APPLY 'VALUE-CHANGED' TO BROWSE-Prosjekt  IN FRAME Prosjekt-Frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Konsulenter_agg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Konsulenter_agg PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Konsulenter_agg /* Konsulenter */
DO:
    RUN AGKO_OPP.P.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Konsulenter_shunt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Konsulenter_shunt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Konsulenter_shunt /* Konsulenter */
DO:
    RUN SHKO_OPP.P.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Konsulenter_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Konsulenter_spiro PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Konsulenter_spiro /* Konsulenter */
DO:
    RUN SPKO_OPP.P.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kunder_-_utsendelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kunder_-_utsendelse PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Kunder_-_utsendelse /* Kunder - utsendelse */
DO:
  /* Skriver ut oppfølgingslister for kunder - spiro  til utsendelser */

    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR kundenrParam AS CHAR INITIAL "".
    DEFINE VAR kundenavnParam AS CHAR INITIAL "".
    DEFINE VAR rabattParam AS DECIMAL.
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKUND.W PERSISTENT (INPUT-OUTPUT kundenrParam, 
          INPUT-OUTPUT kundenavnParam, OUTPUT rabattParam).
    IF kundenrParam = "" THEN
          DO:
              MESSAGE 'Kunde ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN.
         END.            
    DO:
        SELECT COUNT(*) INTO funnet FROM  NPSPTILBUD, NPSPANLG, NPSPTOPP
        WHERE NPSPTILBUD.kundenr =  kundenrParam
              AND   NPSPANLG.aktivt = TRUE AND NOT NPSPTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPSPTOPP.oppf_status BEGINS 'ORDRE' 
              AND NPSPTILBUD.anleggsnr = NPSPANLG.anleggsnr
              AND NPSPTILBUD.id = NPSPTOPP.id .
        IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN.
        END.
           RUN aderb/_printrb.p
           ("report\norvent.prl",
              "Spirovent-oppf-kunde-uts",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSPTILBUD.kundenr = " + '"' + kundenrParam + '"' +
             " AND NPSPANLG.aktivt = TRUE AND NOT NPSPTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPSPTOPP.oppf_status BEGINS 'ORDRE'",
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Oppfølgingsliste for spiroventkunde",
            YES,
             YES,
            NO,
             "").        
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kunder_agg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kunder_agg PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Kunder_agg /* Kunder */
DO:
    RUN AGKU_OPP.P.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kunder_shunt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kunder_shunt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Kunder_shunt /* Kunder */
DO:
    RUN SHKU_OPP.P.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kunder_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kunder_spiro PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Kunder_spiro /* Kunder */
DO:
    RUN SPKU_OPP.P.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kunder_utsendelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kunder_utsendelse PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Kunder_utsendelse /* Kunder utsendelse */
DO:
/* Skriver ut oppfølgingsliser for kunder - aggregater */

    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR kundenrParam AS CHAR INITIAL "".
    DEFINE VAR kundenavnParam AS CHAR INITIAL "".
    DEFINE VAR rabattParam AS DECIMAL.
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKUND.W PERSISTENT (INPUT-OUTPUT kundenrParam, 
          INPUT-OUTPUT kundenavnParam, OUTPUT rabattParam).
    IF kundenrParam = "" THEN
          DO:
              MESSAGE 'Kunde ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN.
         END.            
        SELECT COUNT(*) INTO funnet FROM  NPAGTILBUD, NPAGANLG, NPAGTOPP
        WHERE NPAGTILBUD.kundenr =  kundenrParam
              AND   NPAGANLG.aktivt = TRUE AND NOT NPAGTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPAGTOPP.oppf_status BEGINS 'ORDRE' 
              AND NPAGTILBUD.anleggsnr = NPAGANLG.anleggsnr
              AND NPAGTILBUD.id = NPAGTOPP.id .
        IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN.
        END.
           RUN aderb/_prntrb2.p
           ("report\noragg.prl",
              "Aggregat-oppf-kunde-uts",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPAGTILBUD.kundenr = " + '"' + kundenrParam + '"' +
             " AND NPAGANLG.aktivt = TRUE AND NOT NPAGTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPAGTOPP.oppf_status BEGINS 'ORDRE'",
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Oppfølgingsliste for aggregatkunde",
            YES,
             YES,
            NO,
             "",
             "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Kunder_utsendelse2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Kunder_utsendelse2 PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Kunder_utsendelse2 /* Kunder utsendelse */
DO:
/* Skriver ut oppfølgingslister for kunder-shunt */

    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR kundenrParam AS CHAR INITIAL "".
    DEFINE VAR kundenavnParam AS CHAR INITIAL "".
    DEFINE VAR rabattParam AS DECIMAL.
    DEFINE VAR funnet AS INTEGER INITIAL 0.
    
    RUN VELGKUND.W PERSISTENT (INPUT-OUTPUT kundenrParam, 
          INPUT-OUTPUT kundenavnParam, OUTPUT rabattParam).

    IF kundenrParam = "" THEN
          DO:
              MESSAGE 'Kunde ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN.
         END.            
        /* Test om data finnes */
        SELECT COUNT(*) INTO funnet FROM  NPSHTILBUD, NPSHANLG, NPSHTOPP
        WHERE NPSHTILBUD.kundenr =  kundenrParam
              AND   NPSHANLG.aktivt = TRUE AND NOT NPSHTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPSHTOPP.oppf_status BEGINS 'ORDRE' 
              AND NPSHTILBUD.anleggsnr = NPSHANLG.anleggsnr
              AND NPSHTILBUD.id = NPSHTOPP.id .
        IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN.
        END.
           RUN aderb/_printrb.p
           ("report\norshunt.prl",
              "Shunttilbud-oppf-kunde-uts",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSHTILBUD.kundenr = " + '"' + kundenrParam + '"' +
             " AND NPSHANLG.aktivt = TRUE AND NOT NPSHTOPP.oppf_status BEGINS 'Tapt'
              AND NOT NPSHTOPP.oppf_status BEGINS 'ORDRE'",
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Oppfølgingsliste for shuntkunde",
            YES,
             YES,
            NO,
             "").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Nytt_Prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Nytt_Prosjekt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Nytt_Prosjekt /* Nytt... */
DO:
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    JBoxSession:Instance:setJBoxAttribute('prosjektidparam',STRING(norprosjekt.prosjektid)).
/*    prosjektIdParam = NORPROSJEKT.prosjektId.*/
    Current-Rec = ROWID(NORPROSJEKT).
    nyRecord = TRUE.
    IF THIS-PROCEDURE:PERSISTENT THEN THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(norprosjekt.prosjektid).
    RUN PROSJRED.W (INPUT-OUTPUT nyRecord) NO-ERROR.
    IF nyRecord THEN
        DO:
          {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}
            REPOSITION BROWSE-Prosjekt TO ROWID(Current-Rec).
            APPLY 'VALUE-CHANGED' TO BROWSE-Prosjekt IN FRAME Prosjekt-Frame.            
        END.
    APPLY "GO" TO FRAME Prosjekt-Frame.     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_prosjekt_Pr_Konsulent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_prosjekt_Pr_Konsulent PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_prosjekt_Pr_Konsulent /* Pr. Konsulent */
DO:
    RUN KOPROPPF.P.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_prosjekt_Pr_Kunde
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_prosjekt_Pr_Kunde PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_prosjekt_Pr_Kunde /* Pr. Kunde */
DO:
    RUN KUPROPPF.P.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_prosjekt_Pr_SelgerUke
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_prosjekt_Pr_SelgerUke PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_prosjekt_Pr_SelgerUke /* Pr. Selger/Uke */
DO:
  RUN SELGOPPF.P.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_SelgerOppf_uke_agg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_SelgerOppf_uke_agg PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_SelgerOppf_uke_agg /* Selger/Oppf. uke */
DO:
    RUN AGSLGOPF.p.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_SelgerOppf_uke_shunt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_SelgerOppf_uke_shunt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_SelgerOppf_uke_shunt /* Selger/Oppf. uke */
DO:
    RUN SHSLGOPF.p.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_SelgerOppf_uke_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_SelgerOppf_uke_spiro PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_SelgerOppf_uke_spiro /* Selger/Oppf. uke */
DO:
    RUN SPSLGOPF.p.
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Shuntgrupper
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Shuntgrupper PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Shuntgrupper /* Shuntgrupper */
DO:
   current-rec = ROWID(NORPROSJEKT).
   pointer = SESSION:SET-WAIT-STATE("GENERAL").
/*  prosjektIdParam = NORPROSJEKT.prosjektId.     */
/*  prosjektNavnParam = NORPROSJEKT.prosjekt_navn.*/
  RUN SHANLEGG.W  PERSISTENT  SET p-handle.
  RUN appl_ent IN p-handle.
  
   {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}
   REPOSITION BROWSE-Prosjekt TO ROWID(current-rec).
   APPLY 'VALUE-CHANGED' TO BROWSE-Prosjekt   IN FRAME Prosjekt-Frame.            

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sikre_tilbud_aggregat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sikre_tilbud_aggregat PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sikre_tilbud_aggregat /* Sikre tilbud */
DO:
    RUN AGSIKKER.p.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sikre_tilbud_shunt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sikre_tilbud_shunt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sikre_tilbud_shunt /* Sikre tilbud */
DO:
    RUN SHSIKKER.p.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sikre_tilbud_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sikre_tilbud_spiro PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sikre_tilbud_spiro /* Sikre tilbud */
DO:
    RUN SPSIKKER.p.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Slette_prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette_prosjekt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Slette_prosjekt /* Slette... */
DO:  
      MESSAGE "Vil du slette dette prosjektet med alle tilhørende anlegg?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN /* Yes */
          DO:
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                Current-Rec = ROWID(NORPROSJEKT).
                DO TRANSACTION:
                    FIND NORPROSJEKT WHERE ROWID(NORPROSJEKT)  = Current-Rec  EXCLUSIVE-LOCK
                        NO-ERROR NO-WAIT.
                     IF AVAILABLE(NORPROSJEKT) THEN
                             DO:
                                 DELETE NORPROSJEKT.
                                  pointer = SESSION:SET-WAIT-STATE("").
                                 {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}
                                  GET FIRST Browse-Prosjekt.
                                  IF AVAILABLE NORPROSJEKT THEN 
                                      DO:
                                          prosjektRow =  Browse-Prosjekt:SELECT-ROW(1) IN FRAME Prosjekt-Frame.
                                          APPLY 'VALUE-CHANGED' TO Browse-Prosjekt.
                                     END.
                               END.
                    ELSE
                      DO:
                         MESSAGE 'Tabellen for Prosjekter er i bruk. Prøv igjen om en stund' 
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


&Scoped-define SELF-NAME m_Sortering_Anleggsnr_agg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sortering_Anleggsnr_agg PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sortering_Anleggsnr_agg /* Sortering: Anleggsnr */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    MESSAGE 'Vil du skrive ut anleggsliste  for aggregater sortert på anleggsnr?' 
        VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
    RUN aderb/_prntrb2.p 
        ("report\noragg.prl",
        "Anlegg-alle sortert:anleggsnr",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "",
        "",
        "",
        hMainMenu:PRIVATE-DATA,
        "",
        "",
        0,
        0,
        0,
        NO,
        "Anleggsliste",
        YES,
        YES,
        NO,
        "",
        "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sortering_Anleggsnr_shunt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sortering_Anleggsnr_shunt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sortering_Anleggsnr_shunt /* Sortering: Anleggsnr */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    MESSAGE 'Vil du skrive ut anleggsliste  for shunter sortert på anleggsnr?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
    RUN aderb/_prntrb2.p 
        ("report\norshunt.prl",
        "Anlegg-alle sortert:anleggsnr",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "",
        "",
        "",
        hMainMenu:PRIVATE-DATA,
        "",
        "",
        0,
        0,
        0,
        NO,
        "Anleggsliste",
        YES,
        YES,
        NO,
        "",
        "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sortering_Anleggsnr_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sortering_Anleggsnr_spiro PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sortering_Anleggsnr_spiro /* Sortering: Anleggsnr */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    MESSAGE 'Vil du skrive ut anleggsliste  for spirovent sortert på anleggsnr?' 
        VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
    RUN aderb/_prntrb2.p 
        ("report\norvent.prl",
        "Anlegg-alle sortert:anleggsnr",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "",
        "",
        "",
        hMainMenu:PRIVATE-DATA,
        "",
        "",
        0,
        0,
        0,
        NO,
        "Anleggsliste",
        YES,
        YES,
        NO,
        "",
        "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sortering_Anlegg_agg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sortering_Anlegg_agg PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sortering_Anlegg_agg /* Sortering: Anlegg */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    MESSAGE 'Vil du skrive ut anleggsliste  for aggregater sortert på anlegg?' 
        VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
    RUN aderb/_prntrb2.p 
        ("report\noragg.prl",
        "Anlegg-alle sortert:anlegg",
         JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
       "O", 
        "",
        "",
        "",
        hMainMenu:PRIVATE-DATA,
        "",
        "",
        0,
        0,
        0,
        NO,
        "Anleggsliste",
        YES,
        YES,
        NO,
        "",
        "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sortering_Anlegg_shunt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sortering_Anlegg_shunt PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sortering_Anlegg_shunt /* Sortering: Anlegg */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    MESSAGE 'Vil du skrive ut anleggsliste for shunter  sortert på anlegg?' 
        VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
    RUN aderb/_prntrb2.p 
        ("report\norshunt.prl",
        "Anlegg-alle sortert:anlegg",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "",
        "",
        "",
        hMainMenu:PRIVATE-DATA,
        "",
        "",
        0,
        0,
        0,
        NO,
        "Anleggsliste",
        YES,
        YES,
        NO,
        "",
        "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sortering_Anlegg_spiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sortering_Anlegg_spiro PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Sortering_Anlegg_spiro /* Sortering: Anlegg */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    MESSAGE 'Vil du skrive ut anleggsliste for spirovent  sortert på anlegg?' 
        VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Anleggsliste'  UPDATE svar.
    IF svar THEN
    RUN aderb/_prntrb2.p 
        ("report\norvent.prl",
        "Anlegg-alle sortert:anlegg",
        JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
        "O", 
        "",
        "",
        "",
        hMainMenu:PRIVATE-DATA,
        "",
        "",
        0,
        0,
        0,
        NO,
        "Anleggsliste",
        YES,
        YES,
        NO,
        "",
        "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Spirovent
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Spirovent PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Spirovent /* Spirovent */
DO:

  current-rec = ROWID(NORPROSJEKT).
  SESSION:SET-WAIT-STATE("GENERAL").
/*  prosjektIdParam = NORPROSJEKT.prosjektId.     */
/*  prosjektNavnParam = NORPROSJEKT.prosjekt_navn.*/
  RUN SPANLEGG.W  PERSISTENT  SET p-handle NO-ERROR.
  RUN appl_ent IN p-handle.
     
  {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}
   REPOSITION BROWSE-Prosjekt TO ROWID(current-rec).
   APPLY 'VALUE-CHANGED' TO BROWSE-Prosjekt   IN FRAME Prosjekt-Frame.            

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Velg_konsulent_aggref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Velg_konsulent_aggref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Velg_konsulent_aggref /* Velg konsulent... */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR konsulentnrParam AS CHAR INITIAL "".
    DEFINE VAR konsulentnavnParam AS CHAR INITIAL "".
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKONS.W PERSISTENT (INPUT-OUTPUT konsulentnrParam, 
          INPUT-OUTPUT konsulentnavnParam).

    IF konsulentnrParam = "" THEN
          DO:
              MESSAGE 'Konsulent ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN NO-APPLY.
         END.            

   /* Test om data finnes */
  SELECT COUNT(*) INTO funnet FROM  NPAGANLG, NPAGORD 
    WHERE NPAGANLG.kundenr =  konsulentnrParam
    AND NPAGANLG.anleggsnr = NPAGORD.anleggsnr.
   IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
     RUN aderb/_prntrb2.p
           ("report\noragg.prl",
              "Referanse-Aggregat-Konsulent",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPAGANLG.kundenr = " + '"' + konsulentnrParam + '"' ,
            "",
             "",
         hMainMenu:PRIVATE-DATA,
            "",
            "",
             0,
            0,
             0,
            NO,
             "Referanseliste for Aggregat Konsulenter",
            YES,
             YES,
            NO,
             "",
             "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Velg_konsulent_shuntref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Velg_konsulent_shuntref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Velg_konsulent_shuntref /* Velg konsulent... */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR konsulentnrParam AS CHAR INITIAL "".
    DEFINE VAR konsulentnavnParam AS CHAR INITIAL "".
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKONS.W PERSISTENT (INPUT-OUTPUT konsulentnrParam, 
          INPUT-OUTPUT konsulentnavnParam).

    IF konsulentnrParam = "" THEN
          DO:
              MESSAGE 'Konsulent ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN NO-APPLY.
         END.            

   /* Test om data finnes */
  SELECT COUNT(*) INTO funnet FROM  NPSHANLG, NPSHORD 
    WHERE NPSHANLG.kundenr =  konsulentnrParam
    AND NPSHANLG.anleggsnr = NPSHORD.anleggsnr.
   IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
     RUN aderb/_prntrb2.p
           ("report\norshtek.prl",
              "Referanse-Shunt-Konsulent",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSHANLG.kundenr = " + '"' + konsulentnrParam + '"' ,
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Referanseliste for Shuntanlegg Konsulenter",
            YES,
             YES,
            NO,
             "",
             "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Velg_konsulent_sprioref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Velg_konsulent_sprioref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Velg_konsulent_sprioref /* Velg konsulent... */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR konsulentnrParam AS CHAR INITIAL "".
    DEFINE VAR konsulentnavnParam AS CHAR INITIAL "".
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKONS.W PERSISTENT (INPUT-OUTPUT konsulentnrParam, 
          INPUT-OUTPUT konsulentnavnParam).

    IF konsulentnrParam = "" THEN
          DO:
              MESSAGE 'Konsulent ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN NO-APPLY.
         END.            

   /* Test om data finnes */   
  SELECT COUNT(*) INTO funnet FROM  NPSPANLG, NPSPORD 
    WHERE NPSPANLG.kundenr =  konsulentnrParam
    AND NPSPANLG.anleggsnr = NPSPORD.anleggsnr.
   IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
     RUN aderb/_prntrb2.p
           ("report\norvent.prl",
              "Referanse-Spiro-Konsulent",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSPANLG.kundenr = " + '"' + konsulentnrParam + '"' ,
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Referanseliste for Spiroventanlegg Konsulenter",
            YES,
             YES,
            NO,
             "",
             "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Velg_kunde_aggref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Velg_kunde_aggref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Velg_kunde_aggref /* Velg kunde... */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR kundenrParam AS CHAR INITIAL "".
    DEFINE VAR kundenavnParam AS CHAR INITIAL "".
    DEFINE VAR rabattParam AS DECIMAL.
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKUND.W PERSISTENT (INPUT-OUTPUT kundenrParam, 
          INPUT-OUTPUT kundenavnParam, OUTPUT rabattParam).

    IF kundenrParam = "" THEN
          DO:
              MESSAGE 'Kunde ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN NO-APPLY.
         END.            

   /* Test om data finnes */
  SELECT COUNT(*) INTO funnet FROM  NPAGTILBUD, NPAGORD
    WHERE NPAGTILBUD.kundenr =  kundenrParam
     AND NPAGORD.id = NPAGTILBUD.id.
   IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
     RUN aderb/_prntrb2.p
           ("report\noragg.prl",
              "Referanse-Aggregat-Kunde",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPAGTILBUD.kundenr = " + '"' + kundenrParam + '"' ,
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Referanseliste for Aggregatanlegg - Kunder",
            YES,
             YES,
            NO,
             "",
             "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Velg_kunde_shuntref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Velg_kunde_shuntref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Velg_kunde_shuntref /* Velg kunde... */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR kundenrParam AS CHAR INITIAL "".
    DEFINE VAR kundenavnParam AS CHAR INITIAL "".
    DEFINE VAR rabattParam AS DECIMAL.
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKUND.W PERSISTENT (INPUT-OUTPUT kundenrParam, 
          INPUT-OUTPUT kundenavnParam, OUTPUT rabattParam).

    IF kundenrParam = "" THEN
          DO:
              MESSAGE 'Kunde ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN NO-APPLY.
         END.            

   /* Test om data finnes */
  SELECT COUNT(*) INTO funnet FROM  NPSHTILBUD, NPSHORD
    WHERE NPSHTILBUD.kundenr =  kundenrParam
     AND NPSHORD.id = NPSHTILBUD.id.
   IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
     RUN aderb/_prntrb2.p
           ("report\norshtek.prl",
              "Referanse-Shunt-Kunde",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSHTILBUD.kundenr = " + '"' + kundenrParam + '"' ,
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Referanseliste for Shuntanlegg - Kunder",
            YES,
             YES,
            NO,
             "",
             "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Velg_kunde_spiroref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Velg_kunde_spiroref PROSJEKTOVERSIKT
ON CHOOSE OF MENU-ITEM m_Velg_kunde_spiroref /* Velg kunde... */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    DEFINE VAR kundenrParam AS CHAR INITIAL "".
    DEFINE VAR kundenavnParam AS CHAR INITIAL "".
    DEFINE VAR rabattParam AS DECIMAL.
    DEFINE VAR funnet AS INTEGER INITIAL 0.
        
    RUN VELGKUND.W PERSISTENT (INPUT-OUTPUT kundenrParam, 
          INPUT-OUTPUT kundenavnParam, OUTPUT rabattParam).

    IF kundenrParam = "" THEN
          DO:
              MESSAGE 'Kunde ble ikke valgt' VIEW-AS ALERT-BOX TITLE 'Feil'.
              RETURN NO-APPLY.
         END.            

   /* Test om data finnes */
  SELECT COUNT(*) INTO funnet FROM  NPSPTILBUD, NPSPORD
    WHERE NPSPTILBUD.kundenr =  kundenrParam
     AND NPSPORD.id = NPSPTILBUD.id.
   IF funnet = 0 THEN
        DO:
            MESSAGE 'Ingen data funnet. Utskrift ikke mulig' VIEW-AS ALERT-BOX TITLE 'STOPP'.
            RETURN NO-APPLY.
        END.
     RUN aderb/_prntrb2.p
           ("report\norvent.prl",
              "Referanse-Spiro-Kunde",
            JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
            "O", 
             "NPSPTILBUD.kundenr = " + '"' + kundenrParam + '"' ,
            "",
             "",
        hMainMenu:PRIVATE-DATA,
             "",
            "",
             0,
            0,
             0,
            NO,
             "Referanseliste for Spiroventanlegg - Kunder",
            YES,
             YES,
            NO,
             "",
             "status.out").        
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TOGGLE-IKKE-AKTIVE-PROSJEKT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TOGGLE-IKKE-AKTIVE-PROSJEKT PROSJEKTOVERSIKT
ON VALUE-CHANGED OF TOGGLE-IKKE-AKTIVE-PROSJEKT IN FRAME Prosjekt-Frame /* Innkl. Ikke-aktive */
DO:  
    IF bareAktive = TRUE THEN
        bareAktive = FALSE.
    ELSE
        bareAktive = TRUE.
     /* Prosjekt er fylt ut */
     IF sokNavn <>"" THEN 
        DO:
             APPLY 'LEAVE' TO FILL-IN_prosjekt.
         END. 
     /* Prosjektnr er fylt ut */
     ELSE IF sokNr <> 0 THEN
         APPLY 'LEAVE' TO FILL-IN_prosjektnr.
     ELSE 
         APPLY 'LEAVE' TO FILL-IN_prosjekt.
     APPLY 'ENTRY' TO BROWSE-Prosjekt.

     RETURN NO-APPLY.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK PROSJEKTOVERSIKT 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*ASSIGN prosjektHandle = CURRENT-WINDOW:handle.*/

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

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  THIS-PROCEDURE:CURRENT-WINDOW:X = JBoxSession:Instance:WindowX.
  THIS-PROCEDURE:CURRENT-WINDOW:Y = JBoxSession:Instance:WindowY.
  DYNAMIC-FUNCTION("DoLockWindow",this-procedure:CURRENT-WINDOW).

  RUN enable_UI.
  RUN MoveToTop.
  APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
  SESSION:SET-WAIT-STATE("").
  do with frame {&Frame-name}:
    apply 'value-changed' to browse BROWSE-Prosjekt.
    /* Set InnkluderIkke Aktive til TRUE */
    TOGGLE-IKKE-AKTIVE-PROSJEKT:CHECKED = TRUE.
    bareAktive = FALSE.
  end.
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE appl_ent PROSJEKTOVERSIKT 
PROCEDURE appl_ent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    APPLY "ENTRY" TO FILL-IN_prosjekt IN FRAME Prosjekt-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI PROSJEKTOVERSIKT  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(PROSJEKTOVERSIKT)
  THEN DELETE WIDGET PROSJEKTOVERSIKT.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI PROSJEKTOVERSIKT  _DEFAULT-ENABLE
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
  DISPLAY COMBO-BOX-prosjekt FILL-IN_prosjektnr COMBO-BOX-prosjektnr 
          TOGGLE-IKKE-AKTIVE-PROSJEKT 
      WITH FRAME Prosjekt-Frame IN WINDOW PROSJEKTOVERSIKT.
  ENABLE RECT-12 COMBO-BOX-prosjekt FILL-IN_prosjekt FILL-IN_prosjektnr 
         COMBO-BOX-prosjektnr TOGGLE-IKKE-AKTIVE-PROSJEKT BROWSE-Prosjekt 
      WITH FRAME Prosjekt-Frame IN WINDOW PROSJEKTOVERSIKT.
  {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Hide_Win PROSJEKTOVERSIKT 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop PROSJEKTOVERSIKT 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_aggref_med_pris PROSJEKTOVERSIKT 
PROCEDURE prc_aggref_med_pris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                RUN aderb/_printrb.p
                ("report\noragg.prl",
                "Referanse-Aggregat-Pris",
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        hMainMenu:PRIVATE-DATA,
                "",
                "",
                1,
                1,
                9999,
                NO,
                "Referanseliste - Aggregat",
                YES,
                YES,
                NO,
                "").        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_aggref_uten_pris PROSJEKTOVERSIKT 
PROCEDURE prc_aggref_uten_pris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                RUN aderb/_prntrb2.p
                ("report\noragg.prl",
                "Referanse-Aggregater",
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        hMainMenu:PRIVATE-DATA,
                "",
                "",
                1,
                1,
                9999,
                NO,
                "Referanseliste - Aggregater",
                YES,
                YES,
                NO,
                "",
                "status.out").        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_shuntref_med_pris PROSJEKTOVERSIKT 
PROCEDURE prc_shuntref_med_pris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                RUN aderb/_printrb.p
                ("report\norshtek.prl",
                "Referanse-Shunt-Pris",
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        hMainMenu:PRIVATE-DATA,
                "",
                "",
                1,
                1,
                9999,
                NO,
                "Referanseliste - Shunt",
                YES,
                YES,
                NO,
                "").        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_shuntref_uten_pris PROSJEKTOVERSIKT 
PROCEDURE prc_shuntref_uten_pris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                RUN aderb/_prntrb2.p
                ("report\norshtek.prl",
                "Referanse-Shunt",
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        hMainMenu:PRIVATE-DATA,
                "",
                "",
                1,
                1,
                9999,
                NO,
                "Referanseliste - Shunt",
                YES,
                YES,
                NO,
                "",
                "status.out").        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_spiroref_med_pris PROSJEKTOVERSIKT 
PROCEDURE prc_spiroref_med_pris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                RUN aderb/_printrb.p
                ("report\norvent.prl",
                "Referanse-Spiro-Pris",
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        hMainMenu:PRIVATE-DATA,
                "",
                "",
                1,
                1,
                9999,
                NO,
                "Referanseliste - Spiro",
                YES,
                YES,
                NO,
                "").        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_spiroref_uten_pris PROSJEKTOVERSIKT 
PROCEDURE prc_spiroref_uten_pris :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
                RUN aderb/_prntrb2.p
                ("report\norvent.prl",
                "Referanse-Spiro",
                JBoxServerAPI:Instance:FieldValues('JBoxGenCode','where iJBoxCompanyId = ' + DYNAMIC-FUNCTION("getCompany") + ' AND cCodeType = "ConnectRB" and cCodeValue = "ProdDB"','cMisc1'),              
                "O", 
                cParmString,
                "",
                "",
        hMainMenu:PRIVATE-DATA,
                "",
                "",
                1,
                1,
                9999,
                NO,
                "Referanseliste - Spiro",
                YES,
                YES,
                NO,
                "",
                "status.out").        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE View_Win PROSJEKTOVERSIKT 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRec PROSJEKTOVERSIKT 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrentRec PROSJEKTOVERSIKT 
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

