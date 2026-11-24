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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHANLG ***/
DEF VAR oBrwNPSHANLG AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHANLG
    FIELD anleggsnr AS integer
    FIELD anlegg AS character
    FIELD prosjektid AS integer
    FIELD prosjekt_navn AS character
    FIELD aktivt AS logical
    FIELD anbudsfrist AS date
    FIELD anleggstype AS character
    FIELD arkivnr AS character
    FIELD beskrevet AS character
    FIELD byggestart AS date
    FIELD dato AS date
    FIELD endrings_laas AS logical
    FIELD entreprise AS character
    FIELD faktura# AS integer
    FIELD konsulentens_saksbeh AS character
    FIELD konsulentid AS integer
    FIELD konsulentnr AS character
    FIELD kundenr AS character
    FIELD leveringstid AS character
    FIELD oppf_aar AS integer
    FIELD oppf_uke AS integer
    FIELD opplysninger AS character
    FIELD referanse_tekst AS character
    FIELD saksbehandler AS character
    FIELD salgsdistrikt AS character
    FIELD selger AS character
    FIELD sikker AS logical
    FIELD standardpris AS decimal
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_NPSHANLG FOR TEMP-TABLE NPSHANLG.


FUNCTION getBuffersAndFieldsBrwNPSHANLG RETURNS CHARACTER():
  RETURN
    'NPSHANLG'
     + ';anleggsnr'
     + ';anlegg'
     + ';prosjektid'
     + ';aktivt'
     + ';anbudsfrist'
     + ';anleggstype'
     + ';arkivnr'
     + ';beskrevet'
     + ';byggestart'
     + ';dato'
     + ';endrings_laas'
     + ';entreprise'
     + ';faktura#'
     + ';konsulentens_saksbeh'
     + ';konsulentid'
     + ';konsulentnr'
     + ';kundenr'
     + ';leveringstid'
     + ';oppf_aar'
     + ';oppf_uke'
     + ';opplysninger'
     + ';referanse_tekst'
     + ';saksbehandler'
     + ';salgsdistrikt'
     + ';selger'
     + ';sikker'
     + ';standardpris'
  + ',NORPROSJEKT'
     + ';prosjekt_navn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHANLG RETURNS CHARACTER():
  RETURN 'EACH NORPROSJEKT OF NPSHANLG NO-LOCK'.
END FUNCTION.
DEF VAR oTabNPSHANLG AS JBoxMsTabs NO-UNDO.
DEF VAR otbNPSHANLG AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHANLG

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHANLG

/* Definitions for BROWSE BrwNPSHANLG                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHANLG NPSHANLG.anleggsnr ~
NPSHANLG.anlegg NPSHANLG.prosjektid NPSHANLG.prosjekt_navn NPSHANLG.aktivt ~
NPSHANLG.anbudsfrist NPSHANLG.anleggstype NPSHANLG.arkivnr ~
NPSHANLG.beskrevet NPSHANLG.byggestart NPSHANLG.dato NPSHANLG.endrings_laas ~
NPSHANLG.entreprise NPSHANLG.faktura# NPSHANLG.konsulentens_saksbeh ~
NPSHANLG.konsulentid NPSHANLG.konsulentnr NPSHANLG.kundenr ~
NPSHANLG.leveringstid NPSHANLG.oppf_aar NPSHANLG.oppf_uke ~
NPSHANLG.opplysninger NPSHANLG.referanse_tekst NPSHANLG.saksbehandler ~
NPSHANLG.salgsdistrikt NPSHANLG.selger NPSHANLG.sikker ~
NPSHANLG.standardpris 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHANLG NPSHANLG.anleggsnr 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSHANLG NPSHANLG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSHANLG NPSHANLG
&Scoped-define QUERY-STRING-BrwNPSHANLG FOR EACH NPSHANLG NO-LOCK, ~
    EACH NORPROSJEKT OF NPSHANLG NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHANLG OPEN QUERY BrwNPSHANLG FOR EACH NPSHANLG NO-LOCK, ~
    EACH NORPROSJEKT OF NPSHANLG NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHANLG NPSHANLG
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHANLG NPSHANLG


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TabNPSHANLG tbNPSHANLG refresh_tbNPSHANLG ~
filter_tbNPSHANLG browseconfig_tbNPSHANLG excel_tbNPSHANLG BrwNPSHANLG 

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
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/table.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/table_disabled.gif":U
     LABEL "Column setup" 
     SIZE 7.75 BY 1.94 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON excel_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/excel_disabled.gif":U
     LABEL "Excel" 
     SIZE 7.75 BY 1.94 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.75 BY 1.94 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPSHANLG 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "img/gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.75 BY 1.94 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE TabNPSHANLG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 167 BY 15.

DEFINE RECTANGLE tbNPSHANLG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 166 BY 2.13.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHANLG FOR 
      NPSHANLG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHANLG
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHANLG C-Win _STRUCTURED
  QUERY BrwNPSHANLG NO-LOCK DISPLAY
      NPSHANLG.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
            WIDTH 9.38
      NPSHANLG.anlegg COLUMN-LABEL "Anlegg" FORMAT "X(100)":U WIDTH 50
      NPSHANLG.prosjektid COLUMN-LABEL "prosjektid" FORMAT ">>>>>>>9":U
            WIDTH 9.63
      NPSHANLG.prosjekt_navn COLUMN-LABEL "Prosjektnavn" FORMAT "X(100)":U
            WIDTH 50
      NPSHANLG.aktivt COLUMN-LABEL "Aktivt" FORMAT "ja/nei":U WIDTH 5.38
      NPSHANLG.anbudsfrist COLUMN-LABEL "Anbudsfrist" FORMAT "99.99.9999":U
            WIDTH 10.75
      NPSHANLG.anleggstype COLUMN-LABEL "Type" FORMAT "X(22)":U
      NPSHANLG.arkivnr COLUMN-LABEL "Arkivnr" FORMAT "X(10)":U
      NPSHANLG.beskrevet COLUMN-LABEL "Beskrevet" FORMAT "X(10)":U
      NPSHANLG.byggestart COLUMN-LABEL "Byggestart" FORMAT "99.99.9999":U
            WIDTH 10.75
      NPSHANLG.dato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U WIDTH 10.75
      NPSHANLG.endrings_laas COLUMN-LABEL "LÂst" FORMAT "ja/nei":U
            WIDTH 4
      NPSHANLG.entreprise COLUMN-LABEL "Entreprise" FORMAT "X(8)":U
            WIDTH 9.38
      NPSHANLG.faktura# COLUMN-LABEL "faktura#" FORMAT "999999":U
            WIDTH 8
      NPSHANLG.konsulentens_saksbeh COLUMN-LABEL "v/" FORMAT "X(25)":U
      NPSHANLG.konsulentid COLUMN-LABEL "Konsulent" FORMAT ">>>9":U
            WIDTH 9.38
      NPSHANLG.konsulentnr COLUMN-LABEL "konsulentnr" FORMAT "X(8)":U
            WIDTH 11
      NPSHANLG.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSHANLG.leveringstid COLUMN-LABEL "Leveringstid" FORMAT "X(15)":U
      NPSHANLG.oppf_aar COLUMN-LABEL "Oppf. Âr" FORMAT "9999":U
            WIDTH 7.63
      NPSHANLG.oppf_uke COLUMN-LABEL "Oppf. uke" FORMAT "99":U
            WIDTH 9.38
      NPSHANLG.opplysninger COLUMN-LABEL "Opplysninger" FORMAT "X(3072)":U
      NPSHANLG.referanse_tekst COLUMN-LABEL "referanse_tekst" FORMAT "X(80)":U
      NPSHANLG.saksbehandler COLUMN-LABEL "Saksbehandler" FORMAT "X(25)":U
      NPSHANLG.salgsdistrikt COLUMN-LABEL "Salgsdistrikt" FORMAT "X(30)":U
      NPSHANLG.selger COLUMN-LABEL "Selger" FORMAT "X(25)":U
      NPSHANLG.sikker COLUMN-LABEL "sikker" FORMAT "ja/nei":U WIDTH 5.63
      NPSHANLG.standardpris COLUMN-LABEL "Standardpris" FORMAT ">>,>>>,>>9.99":U
            WIDTH 13.75
  ENABLE
      NPSHANLG.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 167 BY 5.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSHANLG AT ROW 1.09 COL 1.25 WIDGET-ID 6
     filter_tbNPSHANLG AT ROW 1.09 COL 9 WIDGET-ID 8
     browseconfig_tbNPSHANLG AT ROW 1.09 COL 17 WIDGET-ID 10
     excel_tbNPSHANLG AT ROW 1.09 COL 24.75 WIDGET-ID 12
     BrwNPSHANLG AT ROW 3.38 COL 1 WIDGET-ID 200
     TabNPSHANLG AT ROW 9.09 COL 1 WIDGET-ID 2
     tbNPSHANLG AT ROW 1 COL 1 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 167 BY 23.28 WIDGET-ID 100.


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
         TITLE              = "<Insert window title>"
         HEIGHT             = 23.28
         WIDTH              = 167
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 167
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 167
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
/* BROWSE-TAB BrwNPSHANLG excel_tbNPSHANLG DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 23.29
       FRAME DEFAULT-FRAME:WIDTH            = 167.

ASSIGN 
       NPSHANLG.prosjektid:VISIBLE IN BROWSE BrwNPSHANLG = FALSE
       NPSHANLG.prosjekt_navn:VISIBLE IN BROWSE BrwNPSHANLG = FALSE.

ASSIGN 
       tbNPSHANLG:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHANLG
/* Query rebuild information for BROWSE BrwNPSHANLG
     _TblList          = "norcalc.NPSHANLG"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSHANLG.anleggsnr
"NPSHANLG.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSHANLG.anlegg
"NPSHANLG.anlegg" "Anlegg" "X(100)" "character" ? ? ? ? ? ? no "Anleggets navn (oppdragssted)" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSHANLG.prosjektid
"NPSHANLG.prosjektid" "prosjektid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSHANLG.prosjekt_navn
"NPSHANLG.prosjekt_navn" "Prosjektnavn" "X(100)" "character" ? ? ? ? ? ? no "" no no "50" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSHANLG.aktivt
"NPSHANLG.aktivt" "Aktivt" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSHANLG.anbudsfrist
"NPSHANLG.anbudsfrist" "Anbudsfrist" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSHANLG.anleggstype
"NPSHANLG.anleggstype" "Type" "X(22)" "character" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSHANLG.arkivnr
"NPSHANLG.arkivnr" "Arkivnr" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSHANLG.beskrevet
"NPSHANLG.beskrevet" "Beskrevet" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSHANLG.byggestart
"NPSHANLG.byggestart" "Byggestart" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSHANLG.dato
"NPSHANLG.dato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSHANLG.endrings_laas
"NPSHANLG.endrings_laas" "LÔøΩst" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSHANLG.entreprise
"NPSHANLG.entreprise" "Entreprise" "X(8)" "character" ? ? ? ? ? ? no "" no no "9.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSHANLG.faktura#
"NPSHANLG.faktura#" "faktura#" "999999" "integer" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSHANLG.konsulentens_saksbeh
"NPSHANLG.konsulentens_saksbeh" "v/" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSHANLG.konsulentid
"NPSHANLG.konsulentid" "Konsulent" ">>>9" "integer" ? ? ? ? ? ? no "" no no "9.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSHANLG.konsulentnr
"NPSHANLG.konsulentnr" "konsulentnr" "X(8)" "character" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSHANLG.kundenr
"NPSHANLG.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSHANLG.leveringstid
"NPSHANLG.leveringstid" "Leveringstid" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSHANLG.oppf_aar
"NPSHANLG.oppf_aar" "Oppf. Âr" "9999" "integer" ? ? ? ? ? ? no "Oppgi Âr for neste oppf¯ging" no no "7.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSHANLG.oppf_uke
"NPSHANLG.oppf_uke" "Oppf. uke" "99" "integer" ? ? ? ? ? ? no "" no no "9.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSHANLG.opplysninger
"NPSHANLG.opplysninger" "Opplysninger" "X(3072)" "character" ? ? ? ? ? ? no "" no no "3072" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSHANLG.referanse_tekst
"NPSHANLG.referanse_tekst" "referanse_tekst" "X(80)" "character" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSHANLG.saksbehandler
"NPSHANLG.saksbehandler" "Saksbehandler" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSHANLG.salgsdistrikt
"NPSHANLG.salgsdistrikt" "Salgsdistrikt" "X(30)" "character" ? ? ? ? ? ? no "Velg distrikt" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSHANLG.selger
"NPSHANLG.selger" "Selger" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSHANLG.sikker
"NPSHANLG.sikker" "sikker" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSHANLG.standardpris
"NPSHANLG.standardpris" "Standardpris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHANLG */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <Insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <Insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHANLG
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
{incl/conttrigg.i oBrwNPSHANLG:BROWSE-HANDLE}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
run super.

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
  ENABLE TabNPSHANLG tbNPSHANLG refresh_tbNPSHANLG filter_tbNPSHANLG 
         browseconfig_tbNPSHANLG excel_tbNPSHANLG BrwNPSHANLG 
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

  oBrwNPSHANLG = NEW JBoxBrowse(brwNPSHANLG:HANDLE).
  oBrwNPSHANLG:setNoResizeY().

  oTabNPSHANLG = NEW JBoxMSTabs(TabNPSHANLG:HANDLE,oBrwNPSHANLG).
  oTabNPSHANLG:pageOneType = "oneToOne".

  oTabNPSHANLG:setLinkFields("anleggsnr").
  oTabNPSHANLG:AddPage("Detalj","wSHAnleggDetalj.w").
  oTabNPSHANLG:AddPage("System","wSHSystem.w").
  oTabNPSHANLG:AddPage("Tilbud","wSHTilbud.w").
/*  oTabNPSHANLG:AddPage("Tillegg","wSHTillegg.w").*/
/*  oTabNPSHANLG:AddPage("Oppf√∏lging","wSHOppfolging.w").*/
  otbNPSHANLG = NEW JBoxToolbar(tbNPSHANLG:HANDLE).

  oBrwNPSHANLG:TOOLBAR-OBJECT = otbNPSHANLG.
END.
oBrwNPSHANLG:OpenQuery().


oContainer:initResize(300,500).

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
  oBrwNPSHANLG:setParentBrowseObject(oParentBrowse,'Prosjektid').
  oParentBrowse:refresh().
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

