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

DEFINE INPUT  PARAMETER appdata AS CHARACTER.
DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.
DEFINE SHARED VARIABLE anleggsnrParam LIKE npagANLG.anleggsnr.
DEFINE SHARED VARIABLE Current-Rec as ROWID.
DEFINE NEW SHARED VAR tilbudsIdParam LIKE npagTILBUD.id.
DEFINE VAR tilbudsnrParam LIKE npagTILBUD.tilbudsnr.
DEFINE SHARED VAR prosjektidParam LIKE NORPROSJEKT.prosjektid.

/* Local Variable Definitions ---                                       */
DEFINE VAR pointer AS LOGICAL.
DEFINE NEW SHARED VAR Current-Tilbuds-Rec AS  ROWID.
DEFINE NEW SHARED VAR Current-Oppf-Rec AS ROWID.
DEFINE NEW SHARED VAR nyRecord AS LOGICAL INITIAL FALSE.
DEFINE VAR tilbudsRow AS LOGICAL.
DEFINE VAR tilleggsRow AS LOGICAL.
DEFINE VAR oppfRow AS LOGICAL.
   DEFINE VARIABLE dbop-supported AS LOGICAL.
   DEFINE VARIABLE dbop-db-name AS CHARACTER.
   DEFINE VARIABLE dbop-tbl-name AS CHARACTER.
   DEFINE VARIABLE nav-stat AS LOGICAL.
   DEFINE VARIABLE browser-handle AS HANDLE.

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
&Scoped-define FRAME-NAME Oppf-Frame
&Scoped-define BROWSE-NAME BROWSE-OPPFOLGING

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES npagTOPP npagTILBUD NPKUNDE

/* Definitions for BROWSE BROWSE-OPPFOLGING                             */
&Scoped-define FIELDS-IN-QUERY-BROWSE-OPPFOLGING npagTOPP.oppf_uke ~
npagTOPP.oppf_dato npagTOPP.oppf_status npagTOPP.kriterium_1 ~
npagTOPP.kriterium_2 npagTOPP.tiltak npagTOPP.neste_oppf_uke ~
npagTOPP.neste_oppf npagTOPP.notater 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-OPPFOLGING 
&Scoped-define OPEN-QUERY-BROWSE-OPPFOLGING OPEN QUERY BROWSE-OPPFOLGING FOR EACH npagTOPP ~
      WHERE npagTOPP.id = tilbudsidParam NO-LOCK ~
    BY npagTOPP.id DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-OPPFOLGING npagTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-OPPFOLGING npagTOPP


/* Definitions for BROWSE Tilbuds-Browse                                */
&Scoped-define FIELDS-IN-QUERY-Tilbuds-Browse NPKUNDE.kundenavn ~
npagTILBUD.tilbudsnr npagTILBUD.tilbudsdato npagTILBUD.avgittpris ~
npagTILBUD.rabatt% 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Tilbuds-Browse 
&Scoped-define OPEN-QUERY-Tilbuds-Browse OPEN QUERY Tilbuds-Browse FOR EACH npagTILBUD ~
      WHERE npagTILBUD.anleggsnr = anleggsnrParam NO-LOCK, ~
      EACH NPKUNDE OF npagTILBUD NO-LOCK ~
    BY npagTILBUD.tilbudsdato DESCENDING.
&Scoped-define TABLES-IN-QUERY-Tilbuds-Browse npagTILBUD NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-Tilbuds-Browse npagTILBUD
&Scoped-define SECOND-TABLE-IN-QUERY-Tilbuds-Browse NPKUNDE


/* Definitions for FRAME Oppf-Frame                                     */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Oppf-Frame ~
    ~{&OPEN-QUERY-BROWSE-OPPFOLGING}

/* Definitions for FRAME Tilbuds-Frame                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame ~
    ~{&OPEN-QUERY-Tilbuds-Browse}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-OPPFOLGING 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
       MENU-ITEM m_Tekn_spes_til_tilbud LABEL "Tekn. &spes. til tilbud".

DEFINE MENU MENU-BAR-TILBUDS-WINDOW MENUBAR
       SUB-MENU  m_Tilbud       LABEL "&Tilbud"       
       SUB-MENU  m_Oppflging    LABEL "&Oppfølging"   
       SUB-MENU  m_Ordre        LABEL "O&rdre"        
       SUB-MENU  m_Utskrift     LABEL "&Utskrift"     
       MENU-ITEM m_Avslutt      LABEL "&Avslutt"      
       MENU-ITEM m_Hjelp        LABEL "&Hjelp"        .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 3 BY .52 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-OPPFOLGING FOR 
      npagTOPP SCROLLING.

DEFINE QUERY Tilbuds-Browse FOR 
      npagTILBUD, 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-OPPFOLGING
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-OPPFOLGING Tilbuds-Window _STRUCTURED
  QUERY BROWSE-OPPFOLGING NO-LOCK DISPLAY
      npagTOPP.oppf_uke FORMAT ">9":U
      npagTOPP.oppf_dato FORMAT "99.99.9999":U
      npagTOPP.oppf_status FORMAT "X(18)":U COLUMN-FGCOLOR 12 LABEL-FGCOLOR 12
      npagTOPP.kriterium_1 FORMAT "X(25)":U
      npagTOPP.kriterium_2 FORMAT "X(25)":U
      npagTOPP.tiltak FORMAT "X(15)":U
      npagTOPP.neste_oppf_uke FORMAT ">9":U
      npagTOPP.neste_oppf FORMAT "99.99.9999":U
      npagTOPP.notater FORMAT "X(1024)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 125.4 BY 7.91
         FONT 2.

DEFINE BROWSE Tilbuds-Browse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS Tilbuds-Browse Tilbuds-Window _STRUCTURED
  QUERY Tilbuds-Browse NO-LOCK DISPLAY
      NPKUNDE.kundenavn FORMAT "X(30)":U
      npagTILBUD.tilbudsnr FORMAT "X(20)":U
      npagTILBUD.tilbudsdato FORMAT "99.99.9999":U
      npagTILBUD.avgittpris FORMAT ">>,>>>,>>9.99":U
      npagTILBUD.rabatt% FORMAT "->>9.99":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 125.4 BY 8
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Oppf-Frame
     BROWSE-OPPFOLGING AT ROW 1 COL 1
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 10.05
         SIZE 125.8 BY 9.05
         TITLE "Oppfølging".

DEFINE FRAME Tilbuds-Frame
     Tilbuds-Browse AT ROW 1 COL 1
     FILL-IN-1 AT ROW 7.33 COL 84.2 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS THREE-D 
         AT COL 1 ROW 1
         SIZE 125.8 BY 9
         TITLE "Tilbud".


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
         TITLE              = "Tilbud for Aggregatanlegg"
         COLUMN             = 10.4
         ROW                = 7.33
         HEIGHT             = 18.1
         WIDTH              = 125.8
         MAX-HEIGHT         = 18.1
         MAX-WIDTH          = 125.8
         VIRTUAL-HEIGHT     = 18.1
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
/* SETTINGS FOR FRAME Oppf-Frame
                                                                        */
/* BROWSE-TAB BROWSE-OPPFOLGING 1 Oppf-Frame */
/* SETTINGS FOR FRAME Tilbuds-Frame
   UNDERLINE                                                            */
/* BROWSE-TAB Tilbuds-Browse 1 Tilbuds-Frame */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME Tilbuds-Frame
   NO-DISPLAY                                                           */
ASSIGN 
       FILL-IN-1:HIDDEN IN FRAME Tilbuds-Frame           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(Tilbuds-Window)
THEN Tilbuds-Window:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-OPPFOLGING
/* Query rebuild information for BROWSE BROWSE-OPPFOLGING
     _TblList          = "norcalc.npagTOPP"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.npagTOPP.id|no"
     _Where[1]         = "npagTOPP.id = tilbudsidParam"
     _FldNameList[1]   = norcalc.npagTOPP.oppf_uke
     _FldNameList[2]   = norcalc.npagTOPP.oppf_dato
     _FldNameList[3]   > norcalc.npagTOPP.oppf_status
"npagTOPP.oppf_status" ? ? "character" ? 12 ? ? 12 ? no ? no no ? yes no no "U" "" ""
     _FldNameList[4]   = norcalc.npagTOPP.kriterium_1
     _FldNameList[5]   = norcalc.npagTOPP.kriterium_2
     _FldNameList[6]   = norcalc.npagTOPP.tiltak
     _FldNameList[7]   = norcalc.npagTOPP.neste_oppf_uke
     _FldNameList[8]   = norcalc.npagTOPP.neste_oppf
     _FldNameList[9]   = norcalc.npagTOPP.notater
     _Query            is OPENED
*/  /* BROWSE BROWSE-OPPFOLGING */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE Tilbuds-Browse
/* Query rebuild information for BROWSE Tilbuds-Browse
     _TblList          = "norcalc.npagTILBUD,norcalc.NPKUNDE OF norcalc.npagTILBUD"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.npagTILBUD.tilbudsdato|no"
     _Where[1]         = "npagTILBUD.anleggsnr = anleggsnrParam"
     _FldNameList[1]   = norcalc.NPKUNDE.kundenavn
     _FldNameList[2]   = norcalc.npagTILBUD.tilbudsnr
     _FldNameList[3]   = norcalc.npagTILBUD.tilbudsdato
     _FldNameList[4]   = norcalc.npagTILBUD.avgittpris
     _FldNameList[5]   = norcalc.npagTILBUD.rabatt%
     _Query            is OPENED
*/  /* BROWSE Tilbuds-Browse */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Tilbuds-Window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Tilbuds-Window Tilbuds-Window
ON HELP OF Tilbuds-Window /* Tilbud for Aggregatanlegg */
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
        
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + String(anleggsnrParam).
    nyRecord = FALSE.
    Current-Tilbuds-Rec = ROWID(NPAGTILBUD).
    RUN AGTLBRED.W  (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT-OUTPUT nyRecord,
        OUTPUT nyId) NO-ERROR.
    IF nyId > 0 THEN DO:
        FIND NPAGANLG WHERE ROWID(NPAGANLG) = Current-Tilbuds-Rec NO-LOCK NO-ERROR NO-WAIT.
         IF AVAILABLE NPAGANLG THEN DO:
                /* Oppdater avgitt pris for dette tilbudet */
                RUN regnutTilbudspris.
              {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
               REPOSITION Tilbuds-Browse TO ROWID(Current-Tilbuds-Rec).           
               APPLY 'VALUE-CHANGED' TO Tilbuds-Browse
               IN FRAME TILBUDS-FRAME.
        END.
    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Endre_oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Endre_oppf Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Endre_oppf /* Endre... */
DO:
    /* Endre oppfølging */
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    Current-Oppf-Rec = ROWID(NPAGTOPP).
    anleggsnrParam = NPAGTILBUD.anleggsnr.
    tilbudsIdParam = NPAGTILBUD.id.
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + String(tilbudsIdParam).
    RUN AGENDOPP.W  (INPUT THIS-PROCEDURE:PRIVATE-DATA) NO-ERROR.
     {&OPEN-BROWSERS-IN-QUERY-Oppf-Frame}
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
    DEFINE VAR nyId AS INTEGER INITIAL 0.
    nyRecord = TRUE.
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(anleggsnrParam).
    RUN AGTLBRED.W  (INPUT THIS-PROCEDURE:PRIVATE-DATA, INPUT-OUTPUT nyRecord,
        OUTPUT nyId) NO-ERROR.
    IF nyId > 0 THEN DO:
    FIND NPAGTILBUD WHERE ROWID(NPAGTILBUD) = Current-Tilbuds-Rec 
        NO-LOCK NO-ERROR NO-WAIT.
    IF AVAILABLE NPAGTILBUD THEN DO:
            RUN regnutTilbudspris.
            /* Opprett første record i oppfølging, og sett oppf.uke og år*/
            DEFINE VAR cUke LIKE  NPAGANLG.oppf_uke.
            DEFINE VAR cAar LIKE NPAGANLG.oppf_aar.
            
            FIND NPAGANLG WHERE NPAGANLG.anleggsnr = anleggsnrParam NO-LOCK 
                NO-WAIT NO-ERROR.
            IF AVAILABLE NPAGANLG THEN
                    cUke = NPAGANLG.oppf_uke.
                    cAar = NPAGANLG.oppf_aar.
            define var cp_tabell_navn as char.
            define var ip_neste_id as integer.

            cp_tabell_navn  = 'npagtopp'.
            run neste_id.p (input cp_tabell_navn, output ip_neste_id).
            CREATE NPAGTOPP.
            ASSIGN 
            NPAGTOPP.id = tilbudsIdParam
            NPAGTOPP.oppf_nr = ip_neste_id
            NPAGTOPP.neste_oppf_uke = cUke.
            NPAGTOPP.neste_oppf_aar = cAar.
            
           /* Sett endringslås på anlegget */
           UPDATE NPAGANLG SET endrings_laas = TRUE WHERE anleggsnr = anleggsnrParam.
           
          {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
            REPOSITION Tilbuds-Browse TO ROWID(Current-Tilbuds-Rec).           
            APPLY 'VALUE-CHANGED' TO Tilbuds-Browse
                IN FRAME TILBUDS-FRAME.
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


&Scoped-define SELF-NAME m_Ny_oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ny_oppf Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Ny_oppf /* Ny... */
DO:
    /* Ny oppfølging */
    nyRecord = FALSE.
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    tilbudsIdParam = NPAGTILBUD.id.
    anleggsnrParam = NPAGTILBUD.anleggsnr.
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(tilbudsIdParam).
    RUN AGNYOPPF.W  (INPUT THIS-PROCEDURE:PRIVATE-DATA).
    IF nyRecord THEN
        DO:
          {&OPEN-BROWSERS-IN-QUERY-Oppf-Frame}
/*           REPOSITION Browse-Oppfolging TO ROWID(Current-Oppf-Rec). */
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

   anleggsnrParam = NPAGTILBUD.anleggsnr.
   tilbudsIdParam = NPAGTILBUD.id.
   tilbudsnrParam = NPAGTILBUD.tilbudsnr.
   cKunde = NPKUNDE.kundenavn.
   FIND NPAGORD WHERE npagORD.anleggsnr = anleggsnrParam NO-LOCK NO-WAIT NO-ERROR.
   IF AVAILABLE NPAGORD THEN
      DO:
        alleredeRegistrert = TRUE.
        IF NPAGORD.overfoert THEN
            skrevetUt = TRUE.
      END.       
         
    pointer =  SESSION:SET-WAIT-STATE("GENERAL").
    IF THIS-PROCEDURE:PERSISTENT THEN
        THIS-PROCEDURE:PRIVATE-DATA = appdata + "," + STRING(tilbudsIdParam).

    IF alleredeRegistrert THEN
        RUN AGENDORD.W (INPUT THIS-PROCEDURE:PRIVATE-DATA, 
            INPUT skrevetUt, INPUT cKunde, INPUT tilbudsnrParam) NO-ERROR.
    ELSE
        DO:
            RUN AGNYORD.W  (INPUT THIS-PROCEDURE:PRIVATE-DATA,
            INPUT cKunde, INPUT tilbudsnrParam).
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
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = ROWID(npagTILBUD).
                FIND npagTILBUD WHERE ROWID(npagTILBUD)  = cur_rec  EXCLUSIVE-LOCK NO-WAIT
                    NO-ERROR.
                IF AVAILABLE npagTILBUD THEN
                         DELETE npagTILBUD.                         
                STATUS DEFAULT.
                pointer = SESSION:SET-WAIT-STATE("").
                RUN enable_UI.
                {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
                GET FIRST Tilbuds-Browse.   
                IF AVAILABLE npagSYST THEN 
                    DO:
                        tilbudsRow =  Tilbuds-Browse:SELECT-ROW(1) IN FRAME Tilbuds-Frame.
                        APPLY 'VALUE-CHANGED' TO Tilbuds-Browse.
                    END.
                ELSE
                       /* Dette er siste tilbud på dette anlegget - opphev endringslås */
                       UPDATE npagANLG SET endrings_laas = FALSE WHERE anleggsnr = anleggsnrParam.

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


&Scoped-define SELF-NAME m_Slette_oppf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Slette_oppf Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Slette_oppf /* Slette... */
DO:
      DEFINE VAR cur_rec AS ROWID.
      DEFINE VAR antall AS INTEGER NO-UNDO.
      DEFINE VAR ferdig AS LOGICAL NO-UNDO.
            
      /* Hvis bare 1 oppfølgingsrad - ikke mulig å slette */
      SELECT COUNT(*) INTO antall
      FROM NPAGTOPP  WHERE NPAGTOPP.id = tilbudsidParam:

       IF antall <= 1 THEN DO:
         MESSAGE 'Det er bare en oppfølging. Denne kan ikke slettes'  VIEW-AS ALERT-BOX TITLE 'Stopp'.
         RETURN.
      END.
                
      MESSAGE "Vil du slette denne oppfølgingen?"
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO
                    TITLE "" UPDATE choice AS LOGICAL.
      CASE choice:
         WHEN TRUE THEN DO:                /* Yes */
                pointer = SESSION:SET-WAIT-STATE("GENERAL").
                STATUS DEFAULT "Sletting pågår. Vennligst vent ...".
                cur_rec = ROWID(NPAGTOPP).
                FIND NPAGTOPP  WHERE ROWID(NPAGTOPP)  = cur_rec  EXCLUSIVE-LOCK NO-WAIT
                    NO-ERROR.
                IF AVAILABLE NPAGTOPP THEN DO WITH FRAME Oppf-Frame:
                  DELETE NPAGTOPP.                   
                  ferdig = BROWSE-OPPFOLGING:DELETE-CURRENT-ROW().                   
                END.
                STATUS DEFAULT.
                pointer = SESSION:SET-WAIT-STATE("").
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


&Scoped-define SELF-NAME m_Tekn_spes_til_tilbud
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tekn_spes_til_tilbud Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Tekn_spes_til_tilbud /* Tekn. spes. til tilbud */
DO:
   DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    tilbudsIdParam = NPAGTILBUD.id.
    MESSAGE 'Vil du skrive ut teknisk spesifikasjon?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Teknisk Spesifikasjon'  UPDATE svar.
    IF svar THEN
    /* Skriv teknisk spesifikasjon - med pris */
    RUN aderb/_printrb.p
        ("report\noragg.prl",
        "Tekn. spes. tilbud-pris",
        "-db norcalc -H 10.11.0.22 -S 4000 -U norcalc -P norcalc123",              
        "O",
        "NPAGTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        h:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Aggregattilbud - tekn. spes.",
        yes,
        yes,
        no,
        "").        
    /* Skriv teknisk spesifikasjon - uten pris */
/* Kommenert ut etter henstilling fra 'Aggregat ingeni›rene' */
/*    RUN aderb/_printrb.p
        ("report\noragg.prl",
        "Tekn. spes. tilbud-upris",
        "",              
        "O",
        "NPAGTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        h:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Aggregattilbud - tekn. spes.",
        yes,
        yes,
        no,
        "").        
*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Tilbudsbrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Tilbudsbrev Tilbuds-Window
ON CHOOSE OF MENU-ITEM m_Tilbudsbrev /* Tilbudsbrev */
DO:
    DEFINE VAR svar AS LOGICAL INITIAL TRUE.
    tilbudsIdParam = npagTILBUD.id.
    MESSAGE 'Vil du skrive ut tilbudsbrev?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Tilbudsutskrift'  UPDATE svar.
    IF svar THEN
    /* Skriv tilbudsbrev - forside */
RUN aderb/_printrb.p 
        ("report\noragg.prl",
        "Aggregat - tilbudsbrev",
        "-db norcalc -H 10.11.0.22 -S 4000 -U norcalc -P norcalc123",              
        "O", 
        "NPAGTILBUD.id = " + string(tilbudsIdParam),
        "",
        "",
        h:private-data,
        "",
        "",
        0,
        0,
        0,
        no,
        "Aggregater - tilbudsbrev",
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

    tilbudsidParam = NPAGTILBUD.id.
    MESSAGE 'Vil du skrive ut ordregrunnlag?' VIEW-AS ALERT-BOX QUESTION 
        BUTTONS YES-NO TITLE 'Ordregrunnlag'  UPDATE svar.        
    IF svar THEN
        DO:
            /* F›rst m† det sjekkes om ordre er produsert */
            FIND NPAGORD WHERE NPAGORD.tilbudsid = tilbudsidParam NO-ERROR.
            IF NOT AVAILABLE NPAGORD THEN
                DO:
                    MESSAGE 'Ordre er ikke registrert for dette anlegget' VIEW-AS ALERT-BOX TITLE 'Feil'.
                    RETURN NO-APPLY.
                END.
            ELSE
                DO:
                    /* Sjekk om ordre er sperret */
                   IF NPAGORD.overfoert THEN
                        DO:
                             MESSAGE 'Ordre er sperret. Den kan ikke skrives ut' VIEW-AS ALERT-BOX TITLE 'Feil'.
                            RETURN NO-APPLY.                         
                        END. 
                       /* Skriv ordregrunnlag */    
                       RUN aderb/_printrb.p 
                    ("report\norvent.prl",
                       "Ordregrunnlag",
                      "-db norcalc -H 10.11.0.22 -S 4000 -U norcalc -P norcalc123",              
                      "O", 
                      "NPAGORD.tilbudsid = " + string(tilbudsIdParam),
                       "",
                       "",
        h:private-data,
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


/*                    MESSAGE 'Skal denne ordren merkes som overført til Ordresystemet? ' + CHR(10) + CHR(13) + 'Svarer du Ja vil det ikke kunne gj›res endringer p† ordren senere. ' 
                        VIEW-AS ALERT-BOX QUESTION 
                        BUTTONS YES-NO TITLE 'Sperring av ordre'  UPDATE svarOverfoer.
                    IF svarOverfoer THEN
                        UPDATE NPAGORD SET overfoert = TRUE WHERE tilbudsId = tilbudsIdParam.     */
            END.
        END.  
  
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
    tilbudsIdParam = npagTILBUD.id.
    Current-Tilbuds-Rec = ROWID(npagTILBUD).
   {&OPEN-BROWSERS-IN-QUERY-OPPF-FRAME}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME Oppf-Frame
&Scoped-define BROWSE-NAME BROWSE-OPPFOLGING
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Tilbuds-Window 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

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

   pointer = SESSION:SET-WAIT-STATE("").

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will slways fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   Tilbuds-Window:TITLE = 'Tilbud for anlegg: ' + anleggsNavnParam.
   RUN enable_UI.
   GET FIRST Tilbuds-Browse.   
   IF AVAILABLE norcalc.npagTILBUD THEN 
   DO:
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
    APPLY "ENTRY" TO FILL-IN-1 IN FRAME Tilbuds-Frame.
    HIDE FILL-IN-1 IN FRAME Tilbuds-Frame.
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
  ENABLE Tilbuds-Browse FILL-IN-1 
      WITH FRAME Tilbuds-Frame IN WINDOW Tilbuds-Window.
  {&OPEN-BROWSERS-IN-QUERY-Tilbuds-Frame}
  ENABLE BROWSE-OPPFOLGING 
      WITH FRAME Oppf-Frame IN WINDOW Tilbuds-Window.
  {&OPEN-BROWSERS-IN-QUERY-Oppf-Frame}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE regnutTilbudspris Tilbuds-Window 
PROCEDURE regnutTilbudspris :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
            /* Oppdater  prisog avgitt pris for dette tilbudet */
            DEFINE VAR c_systempris AS DECIMAL INITIAL 0.
            DEFINE VAR c_avgittpris AS DECIMAL INITIAL 0.
            FOR EACH NPAGSYST WHERE NPAGSYST.anleggsnr = anleggsnrParam:
                c_systempris = c_systempris + NPAGSYST.standardpris.
            END.      
            FIND NPAGTILBUD WHERE ROWID(NPAGTILBUD) = Current-Tilbuds-Rec NO-WAIT 
                NO-ERROR.            
            IF AVAILABLE NPAGTILBUD THEN
            DO:
                 c_avgittpris = c_systempris - ((c_systempris *  NPAGTILBUD.rabatt%) / 100).
                 tilbudsIdParam = NPAGTILBUD.id. 
           
                ASSIGN NPAGTILBUD.pris  = c_systempris
                              NPAGTILBUD.avgittpris =  c_avgittpris.
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

