&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description:        Container for a JukeBox window program

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            brynjar@chemistry.no

  Created:           18.oct.2006

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   
/* Uncomment to enable use of .Net components: */
&SCOPED-DEFINE AdvGuiWin 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR hFieldMap   AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.
def var oParentBrowse as JBoxBrowse no-undo.

/*** Start instance property definitions for JBoxBrowse object oBrwNPSPANLG ***/
DEF VAR oBrwNPSPANLG AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSPANLG
    FIELD prosjektid AS integer
    FIELD anleggsnr AS integer
    FIELD anlegg AS character
    FIELD kundenr AS character
    FIELD aktivt AS logical
    FIELD anbudsfrist AS date
    FIELD arkivnr AS character
    FIELD beskrevet AS character
    FIELD byggestart AS date
    FIELD dato AS date
    FIELD endrings_laas AS logical
    FIELD entreprise AS character
    FIELD konsulentens_saksbeh AS character
    FIELD konsulentid AS integer
    FIELD leveringsdato AS date
    FIELD leveringstid AS character
    FIELD oppf_aar AS integer
    FIELD oppf_uke AS integer
    FIELD opplysninger AS character
    FIELD ordre AS logical
    FIELD referanse_tekst AS character
    FIELD saksbehandler AS character
    FIELD salgsdistrikt AS character
    FIELD selger AS character
    FIELD sikker AS logical
    FIELD standardpris AS decimal
    FIELD kundedistriktnavn AS character
    FIELD kundedistriktNr AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_NPSPANLG FOR TEMP-TABLE NPSPANLG.




/* ************************  Function Implementations ***************** */
FUNCTION getBuffersAndFieldsBrwNPSPANLG RETURNS CHARACTER():
  RETURN
    'NPSPANLG'
     + ';prosjektid'
     + ';anleggsnr'
     + ';anlegg'
     + ';kundenr'
     + ';aktivt'
     + ';anbudsfrist'
     + ';arkivnr'
     + ';beskrevet'
     + ';byggestart'
     + ';dato'
     + ';endrings_laas'
     + ';entreprise'
     + ';konsulentens_saksbeh'
     + ';konsulentid'
     + ';leveringsdato'
     + ';leveringstid'
     + ';oppf_aar'
     + ';oppf_uke'
     + ';opplysninger'
     + ';ordre'
     + ';referanse_tekst'
     + ';saksbehandler'
     + ';salgsdistrikt'
     + ';selger'
     + ';sikker'
     + ';standardpris'
  + ',NPkundedistrikt'
     + ';kundedistriktnavn'
     + ';kundedistriktNr'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPANLG RETURNS CHARACTER():
  RETURN 'EACH NPkundedistrikt  WHERE npkundedistrikt.kundedistriktnr = int(npspanlg.salgsdistrikt) NO-LOCK'.
END FUNCTION.

DEF VAR otbNORPROSJEKT AS JBoxToolbar NO-UNDO.


DEF VAR oTabNPSPANLG AS JBoxMsTabs NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSPANLG

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPANLG

/* Definitions for BROWSE BrwNPSPANLG                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPANLG NPSPANLG.prosjektid ~
NPSPANLG.anleggsnr NPSPANLG.anlegg NPSPANLG.kundenr NPSPANLG.aktivt ~
NPSPANLG.anbudsfrist NPSPANLG.arkivnr NPSPANLG.beskrevet ~
NPSPANLG.byggestart NPSPANLG.dato NPSPANLG.endrings_laas ~
NPSPANLG.entreprise NPSPANLG.konsulentens_saksbeh NPSPANLG.konsulentid ~
NPSPANLG.leveringsdato NPSPANLG.leveringstid NPSPANLG.oppf_aar ~
NPSPANLG.oppf_uke NPSPANLG.opplysninger NPSPANLG.ordre ~
NPSPANLG.referanse_tekst NPSPANLG.saksbehandler NPSPANLG.salgsdistrikt ~
NPSPANLG.selger NPSPANLG.sikker NPSPANLG.standardpris ~
NPSPANLG.kundedistriktnavn NPSPANLG.kundedistriktNr 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPANLG NPSPANLG.prosjektid 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSPANLG NPSPANLG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSPANLG NPSPANLG
&Scoped-define QUERY-STRING-BrwNPSPANLG FOR EACH NPSPANLG NO-LOCK, ~
    EACH NPkundedistrikt WHERE TRUE /* Join to NPSPANLG incomplete */ NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPANLG OPEN QUERY BrwNPSPANLG FOR EACH NPSPANLG NO-LOCK, ~
    EACH NPkundedistrikt WHERE TRUE /* Join to NPSPANLG incomplete */ NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPANLG NPSPANLG
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPANLG NPSPANLG


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNORPROSJEKT TabNPSPANLG ~
filter_tbNORPROSJEKT excel_tbNORPROSJEKT BrwNPSPANLG 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParentBrowse C-Win 
FUNCTION setParentBrowse RETURNS LOGICAL
  ( input ioBrwObject as JBoxBrowse  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbNORPROSJEKT 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE RECTANGLE TabNPSPANLG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 124.4 BY 10.67.

DEFINE RECTANGLE tbNORPROSJEKT
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 124 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPANLG FOR 
      NPSPANLG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPANLG
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPANLG C-Win _STRUCTURED
  QUERY BrwNPSPANLG NO-LOCK DISPLAY
      NPSPANLG.prosjektid COLUMN-LABEL "prosjektid" FORMAT ">>>>>>>9":U
      NPSPANLG.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPANLG.anlegg COLUMN-LABEL "Anlegg" FORMAT "X(45)":U
      NPSPANLG.kundenr COLUMN-LABEL "kundenr" FORMAT "X(8)":U
      NPSPANLG.aktivt COLUMN-LABEL "Aktivt" FORMAT "ja/nei":U
      NPSPANLG.anbudsfrist COLUMN-LABEL "Anbudsfrist" FORMAT "99.99.9999":U
      NPSPANLG.arkivnr COLUMN-LABEL "Arkivnr" FORMAT "X(10)":U
      NPSPANLG.beskrevet COLUMN-LABEL "Beskrevet" FORMAT "X(15)":U
      NPSPANLG.byggestart COLUMN-LABEL "Byggestart" FORMAT "99.99.9999":U
      NPSPANLG.dato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSPANLG.endrings_laas COLUMN-LABEL "Låst" FORMAT "ja/nei":U
      NPSPANLG.entreprise COLUMN-LABEL "Entreprise" FORMAT "X(6)":U
      NPSPANLG.konsulentens_saksbeh COLUMN-LABEL "v/" FORMAT "X(25)":U
      NPSPANLG.konsulentid COLUMN-LABEL "Konsulent" FORMAT ">>>9":U
      NPSPANLG.leveringsdato COLUMN-LABEL "Leveringsdato" FORMAT "99.99.9999":U
      NPSPANLG.leveringstid COLUMN-LABEL "Leveringstid" FORMAT "X(15)":U
      NPSPANLG.oppf_aar COLUMN-LABEL "Oppf. år" FORMAT "9999":U
      NPSPANLG.oppf_uke COLUMN-LABEL "Oppf. uke" FORMAT "99":U
      NPSPANLG.opplysninger COLUMN-LABEL "Opplysninger" FORMAT "X(3072)":U
      NPSPANLG.ordre COLUMN-LABEL "ordre" FORMAT "ja/nei":U
      NPSPANLG.referanse_tekst COLUMN-LABEL "referanse_tekst" FORMAT "X(80)":U
      NPSPANLG.saksbehandler COLUMN-LABEL "Saksbehandler" FORMAT "X(25)":U
      NPSPANLG.salgsdistrikt COLUMN-LABEL "Salgsdistrikt" FORMAT "X(30)":U
      NPSPANLG.selger COLUMN-LABEL "Selger" FORMAT "X(25)":U
      NPSPANLG.sikker COLUMN-LABEL "sikker" FORMAT "ja/nei":U
      NPSPANLG.standardpris COLUMN-LABEL "Standardpris" FORMAT ">>,>>>,>>9.99":U
      NPSPANLG.kundedistriktnavn FORMAT "x(100)":U
      NPSPANLG.kundedistriktNr FORMAT ">>9":U
  ENABLE
      NPSPANLG.prosjektid
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 124 BY 5.24 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     filter_tbNORPROSJEKT AT ROW 1.1 COL 1.2 WIDGET-ID 4
     excel_tbNORPROSJEKT AT ROW 1.1 COL 9.2 WIDGET-ID 6
     BrwNPSPANLG AT ROW 3.14 COL 1 WIDGET-ID 200
     tbNORPROSJEKT AT ROW 1 COL 1 WIDGET-ID 2
     TabNPSPANLG AT ROW 8.62 COL 1 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 124.4 BY 18.29 WIDGET-ID 100.


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
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Spirovent anlegg"
         HEIGHT             = 18.29
         WIDTH              = 124.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 124.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 124.4
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

{incl/devmode.i}
{incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BrwNPSPANLG excel_tbNORPROSJEKT DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 18.29
       FRAME DEFAULT-FRAME:WIDTH            = 124.4.

ASSIGN 
       NPSPANLG.arkivnr:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.beskrevet:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.endrings_laas:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.konsulentens_saksbeh:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.oppf_aar:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.oppf_uke:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.opplysninger:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.referanse_tekst:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.salgsdistrikt:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.selger:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.sikker:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.standardpris:VISIBLE IN BROWSE BrwNPSPANLG = FALSE
       NPSPANLG.kundedistriktNr:VISIBLE IN BROWSE BrwNPSPANLG = FALSE.

ASSIGN 
       tbNORPROSJEKT:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "filter;Filter,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPANLG
/* Query rebuild information for BROWSE BrwNPSPANLG
     _TblList          = "norcalc.NPSPANLG"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSPANLG.prosjektid
"NPSPANLG.prosjektid" "prosjektid" ">>>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSPANLG.anleggsnr
"NPSPANLG.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSPANLG.anlegg
"NPSPANLG.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSPANLG.kundenr
"NPSPANLG.kundenr" "kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSPANLG.aktivt
"NPSPANLG.aktivt" "Aktivt" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSPANLG.anbudsfrist
"NPSPANLG.anbudsfrist" "Anbudsfrist" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSPANLG.arkivnr
"NPSPANLG.arkivnr" "Arkivnr" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSPANLG.beskrevet
"NPSPANLG.beskrevet" "Beskrevet" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSPANLG.byggestart
"NPSPANLG.byggestart" "Byggestart" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSPANLG.dato
"NPSPANLG.dato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSPANLG.endrings_laas
"NPSPANLG.endrings_laas" "Låst" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSPANLG.entreprise
"NPSPANLG.entreprise" "Entreprise" "X(6)" "character" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSPANLG.konsulentens_saksbeh
"NPSPANLG.konsulentens_saksbeh" "v/" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSPANLG.konsulentid
"NPSPANLG.konsulentid" "Konsulent" ">>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSPANLG.leveringsdato
"NPSPANLG.leveringsdato" "Leveringsdato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "13.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSPANLG.leveringstid
"NPSPANLG.leveringstid" "Leveringstid" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSPANLG.oppf_aar
"NPSPANLG.oppf_aar" "Oppf. år" "9999" "integer" ? ? ? ? ? ? no "Oppgi år for neste oppfølging" no no "7.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSPANLG.oppf_uke
"NPSPANLG.oppf_uke" "Oppf. uke" "99" "integer" ? ? ? ? ? ? no "" no no "9.4" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSPANLG.opplysninger
"NPSPANLG.opplysninger" "Opplysninger" "X(3072)" "character" ? ? ? ? ? ? no "" no no "3072" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSPANLG.ordre
"NPSPANLG.ordre" "ordre" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSPANLG.referanse_tekst
"NPSPANLG.referanse_tekst" "referanse_tekst" "X(80)" "character" ? ? ? ? ? ? no "" no no "80" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSPANLG.saksbehandler
"NPSPANLG.saksbehandler" "Saksbehandler" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSPANLG.salgsdistrikt
"NPSPANLG.salgsdistrikt" "Salgsdistrikt" "X(30)" "character" ? ? ? ? ? ? no "Velg distrikt" no no "30" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSPANLG.selger
"NPSPANLG.selger" "Selger" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSPANLG.sikker
"NPSPANLG.sikker" "sikker" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSPANLG.standardpris
"NPSPANLG.standardpris" "Standardpris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSPANLG.kundedistriktnavn
"NPSPANLG.kundedistriktnavn" "Distrikt" "x(100)" "character" ? ? ? ? ? ? no "" no no "100" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSPANLG.kundedistriktNr
"NPSPANLG.kundedistriktNr" "Dist.nr" ">>9" "integer" ? ? ? ? ? ? no "" no no "6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPANLG */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Spirovent anlegg */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Spirovent anlegg */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSPANLG
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
END.

{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPSPANLG:BROWSE-HANDLE}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
  &ENDIF

  IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
    &IF DEFINED(UIB_is_Running) = 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
    SESSION:SET-WAIT-STATE("").
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
    ELSE 
    &ENDIF
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  ENABLE tbNORPROSJEKT TabNPSPANLG filter_tbNORPROSJEKT excel_tbNORPROSJEKT 
         BrwNPSPANLG 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Refer to the <jukebox>\winsrc\samples for working examples for Sports2000
------------------------------------------------------------------------------*/
RUN enable_UI.

oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

DO WITH FRAME {&FRAME-NAME}:

  oBrwNPSPANLG = NEW JBoxBrowse(brwNPSPANLG:HANDLE).
  oBrwNPSPANLG:setNoResizeY().
  otbNORPROSJEKT = NEW JBoxToolbar(tbNORPROSJEKT:HANDLE).

  oBrwNPSPANLG:TOOLBAR-OBJECT = otbNORPROSJEKT.
  oTabNPSPANLG = NEW JBoxMSTabs(TabNPSPANLG:HANDLE,oBrwNPSPANLG,"bmp\bullet_ball_green.bmp,").
  oTabNPSPANLG:pageOneType = "oneToOne".
  oTabNPSPANLG:setLinkFields("anleggsnr",1).
  oTabNPSPANLG:AddPage('Detaljer',"wSPAnleggDetalj.w","bullet_ball_green.bmp").
  
  oTabNPSPANLG:setLinkFields("anleggsnr",2).
  oTabNPSPANLG:AddPage('System',"wSPSystem.w","bullet_ball_green.bmp").

  oTabNPSPANLG:setLinkFields("anleggsnr",3).
  oTabNPSPANLG:AddPage('Tilbud',"wSPTilbudBrw.w","bullet_ball_green.bmp").

  oTabNPSPANLG:setLinkFields("anleggsnr",4).
  oTabNPSPANLG:AddPage('Ordre',"wSPOrdreBrw.w","bullet_ball_green.bmp").
 
END.
oBrwNPSPANLG:OpenQuery().


oContainer:initResize().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop C-Win 
PROCEDURE MoveToTop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParentBrowse C-Win 
FUNCTION setParentBrowse RETURNS LOGICAL
  ( input ioBrwObject as JBoxBrowse  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  oParentBrowse = ioBrwObject.
  oBrwNPSPANLG:setParentBrowseObject(oParentBrowse,'Prosjektid').
  oParentBrowse:refresh().
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

