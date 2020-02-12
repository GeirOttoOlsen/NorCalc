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
/* &SCOPED-DEFINE AdvGuiWin */ 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR hFieldMap   AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHANLG ***/
DEF VAR oBrwNPSHANLG AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHANLG
    FIELD dato AS date
    FIELD anleggsnr AS integer
    FIELD anlegg AS character
    FIELD prosjektid2 AS integer
    FIELD prosjekt_navn AS character
    FIELD aktivt2 AS logical
    FIELD kundenr AS character
    FIELD aktivt AS logical
    FIELD anbudsfrist AS date
    FIELD anleggstype AS character
    FIELD arkivnr AS character
    FIELD beskrevet AS character
    FIELD byggestart AS date
    FIELD endrings_laas AS logical
    FIELD entreprise AS character
    FIELD faktura# AS integer
    FIELD konsulentens_saksbeh AS character
    FIELD konsulentid AS integer
    FIELD konsulentnr AS character
    FIELD leveringstid AS character
    FIELD oppf_aar AS integer
    FIELD oppf_uke AS integer
    FIELD opplysninger AS character
    FIELD prosjektid AS integer
    FIELD referanse_tekst AS character
    FIELD saksbehandler AS character
    FIELD salgsdistrikt AS character
    FIELD selger AS character
    FIELD sikker AS logical
    FIELD standardpris AS decimal
    FIELD aggregater AS character
    FIELD reg_dato AS date
    FIELD shuntgrupper AS character
    FIELD spirovent AS character
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
     + ';dato'
     + ';anleggsnr'
     + ';anlegg'
     + ';kundenr'
     + ';aktivt'
     + ';anbudsfrist'
     + ';anleggstype'
     + ';arkivnr'
     + ';beskrevet'
     + ';byggestart'
     + ';endrings_laas'
     + ';entreprise'
     + ';faktura#'
     + ';konsulentens_saksbeh'
     + ';konsulentid'
     + ';konsulentnr'
     + ';leveringstid'
     + ';oppf_aar'
     + ';oppf_uke'
     + ';opplysninger'
     + ';prosjektid'
     + ';referanse_tekst'
     + ';saksbehandler'
     + ';salgsdistrikt'
     + ';selger'
     + ';sikker'
     + ';standardpris'
  + ',NORPROSJEKT'
     + ';prosjektid'
     + ';prosjekt_navn'
     + ';aktivt'
     + ';aggregater'
     + ';reg_dato'
     + ';shuntgrupper'
     + ';spirovent'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHANLG RETURNS CHARACTER():
  RETURN 'EACH NORPROSJEKT OF NPSHANLG NO-LOCK'.
END FUNCTION.
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
&Scoped-define FIELDS-IN-QUERY-BrwNPSHANLG NPSHANLG.dato NPSHANLG.anleggsnr ~
NPSHANLG.anlegg NPSHANLG.prosjektid2 NPSHANLG.prosjekt_navn ~
NPSHANLG.aktivt2 NPSHANLG.kundenr NPSHANLG.aktivt NPSHANLG.anbudsfrist ~
NPSHANLG.anleggstype NPSHANLG.arkivnr NPSHANLG.beskrevet ~
NPSHANLG.byggestart NPSHANLG.endrings_laas NPSHANLG.entreprise ~
NPSHANLG.faktura# NPSHANLG.konsulentens_saksbeh NPSHANLG.konsulentid ~
NPSHANLG.konsulentnr NPSHANLG.leveringstid NPSHANLG.oppf_aar ~
NPSHANLG.oppf_uke NPSHANLG.opplysninger NPSHANLG.prosjektid ~
NPSHANLG.referanse_tekst NPSHANLG.saksbehandler NPSHANLG.salgsdistrikt ~
NPSHANLG.selger NPSHANLG.sikker NPSHANLG.standardpris NPSHANLG.aggregater ~
NPSHANLG.reg_dato NPSHANLG.shuntgrupper NPSHANLG.spirovent 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHANLG NPSHANLG.dato 
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
&Scoped-Define ENABLED-OBJECTS tbNPSHANLG refresh_tbNPSHANLG ~
excel_tbNPSHANLG BrwNPSHANLG 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbNPSHANLG 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON refresh_tbNPSHANLG 
     IMAGE-UP FILE "ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSHANLG
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 115 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHANLG FOR 
      NPSHANLG SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHANLG
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHANLG C-Win _STRUCTURED
  QUERY BrwNPSHANLG NO-LOCK DISPLAY
      NPSHANLG.dato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSHANLG.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHANLG.anlegg COLUMN-LABEL "Anlegg" FORMAT "X(45)":U
      NPSHANLG.prosjektid2 COLUMN-LABEL "prosjektid" FORMAT ">>>>>>>9":U
      NPSHANLG.prosjekt_navn COLUMN-LABEL "Prosjektnavn" FORMAT "X(45)":U
      NPSHANLG.aktivt2 COLUMN-LABEL "Aktivt" FORMAT "ja/nei":U
      NPSHANLG.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSHANLG.aktivt FORMAT "ja/nei":U
      NPSHANLG.anbudsfrist FORMAT "99.99.9999":U
      NPSHANLG.anleggstype FORMAT "X(22)":U
      NPSHANLG.arkivnr FORMAT "X(10)":U
      NPSHANLG.beskrevet FORMAT "X(10)":U
      NPSHANLG.byggestart FORMAT "99.99.9999":U
      NPSHANLG.endrings_laas FORMAT "ja/nei":U
      NPSHANLG.entreprise FORMAT "X(8)":U
      NPSHANLG.faktura# FORMAT "999999":U
      NPSHANLG.konsulentens_saksbeh FORMAT "X(25)":U
      NPSHANLG.konsulentid FORMAT ">>>9":U
      NPSHANLG.konsulentnr FORMAT "X(8)":U
      NPSHANLG.leveringstid FORMAT "X(15)":U
      NPSHANLG.oppf_aar FORMAT "9999":U
      NPSHANLG.oppf_uke FORMAT "99":U
      NPSHANLG.opplysninger FORMAT "X(3072)":U
      NPSHANLG.prosjektid FORMAT ">>>>>>>9":U
      NPSHANLG.referanse_tekst FORMAT "X(80)":U
      NPSHANLG.saksbehandler FORMAT "X(25)":U
      NPSHANLG.salgsdistrikt FORMAT "X(30)":U
      NPSHANLG.selger FORMAT "X(25)":U
      NPSHANLG.sikker FORMAT "ja/nei":U
      NPSHANLG.standardpris FORMAT ">>,>>>,>>9.99":U
      NPSHANLG.aggregater FORMAT "X(8)":U
      NPSHANLG.reg_dato FORMAT "99.99.9999":U
      NPSHANLG.shuntgrupper FORMAT "X(8)":U
      NPSHANLG.spirovent FORMAT "X(8)":U
  ENABLE
      NPSHANLG.dato
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 114.8 BY 9.57 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSHANLG AT ROW 1.1 COL 1.2 WIDGET-ID 4
     excel_tbNPSHANLG AT ROW 1.1 COL 9.2 WIDGET-ID 6
     BrwNPSHANLG AT ROW 3.38 COL 2 WIDGET-ID 200
     tbNPSHANLG AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 115.8 BY 11.95 WIDGET-ID 100.


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
         HEIGHT             = 11.95
         WIDTH              = 115.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 115.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 115.8
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
       FRAME DEFAULT-FRAME:HEIGHT           = 11.95
       FRAME DEFAULT-FRAME:WIDTH            = 115.8.

ASSIGN 
       NPSHANLG.kundenr:VISIBLE IN BROWSE BrwNPSHANLG = FALSE.

ASSIGN 
       tbNPSHANLG:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,excel;Excelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHANLG
/* Query rebuild information for BROWSE BrwNPSHANLG
     _TblList          = "norcalc.NPSHANLG"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSHANLG.dato
"NPSHANLG.dato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? yes "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSHANLG.anleggsnr
"NPSHANLG.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSHANLG.anlegg
"NPSHANLG.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn (oppdragssted)" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSHANLG.prosjektid2
"NPSHANLG.prosjektid2" "prosjektid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSHANLG.prosjekt_navn
"NPSHANLG.prosjekt_navn" "Prosjektnavn" "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSHANLG.aktivt2
"NPSHANLG.aktivt2" "Aktivt" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSHANLG.kundenr
"NPSHANLG.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSHANLG.aktivt
"NPSHANLG.aktivt" "Aktivt" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSHANLG.anbudsfrist
"NPSHANLG.anbudsfrist" "Anbudsfrist" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSHANLG.anleggstype
"NPSHANLG.anleggstype" "Type" "X(22)" "character" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSHANLG.arkivnr
"NPSHANLG.arkivnr" "Arkivnr" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSHANLG.beskrevet
"NPSHANLG.beskrevet" "Beskrevet" "X(10)" "character" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSHANLG.byggestart
"NPSHANLG.byggestart" "Byggestart" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSHANLG.endrings_laas
"NPSHANLG.endrings_laas" "Låst" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSHANLG.entreprise
"NPSHANLG.entreprise" "Entreprise" "X(8)" "character" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSHANLG.faktura#
"NPSHANLG.faktura#" "faktura#" "999999" "integer" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSHANLG.konsulentens_saksbeh
"NPSHANLG.konsulentens_saksbeh" "v/" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSHANLG.konsulentid
"NPSHANLG.konsulentid" "Konsulent" ">>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSHANLG.konsulentnr
"NPSHANLG.konsulentnr" "konsulentnr" "X(8)" "character" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSHANLG.leveringstid
"NPSHANLG.leveringstid" "Leveringstid" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSHANLG.oppf_aar
"NPSHANLG.oppf_aar" "Oppf. år" "9999" "integer" ? ? ? ? ? ? no "Oppgi år for neste oppfølging" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSHANLG.oppf_uke
"NPSHANLG.oppf_uke" "Oppf. uke" "99" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSHANLG.opplysninger
"NPSHANLG.opplysninger" "Opplysninger" "X(3072)" "character" ? ? ? ? ? ? no "" no no "3072" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSHANLG.prosjektid
"NPSHANLG.prosjektid" "prosjektid" ">>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSHANLG.referanse_tekst
"NPSHANLG.referanse_tekst" "referanse_tekst" "X(80)" "character" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSHANLG.saksbehandler
"NPSHANLG.saksbehandler" "Saksbehandler" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSHANLG.salgsdistrikt
"NPSHANLG.salgsdistrikt" "Salgsdistrikt" "X(30)" "character" ? ? ? ? ? ? no "Velg distrikt" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSHANLG.selger
"NPSHANLG.selger" "Selger" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > NPSHANLG.sikker
"NPSHANLG.sikker" "sikker" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "5.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > NPSHANLG.standardpris
"NPSHANLG.standardpris" "Standardpris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > NPSHANLG.aggregater
"NPSHANLG.aggregater" "Aggregater" "X(8)" "character" ? ? ? ? ? ? no "" no no "10.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > NPSHANLG.reg_dato
"NPSHANLG.reg_dato" "Reg.dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > NPSHANLG.shuntgrupper
"NPSHANLG.shuntgrupper" "Shuntgrupper" "X(8)" "character" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > NPSHANLG.spirovent
"NPSHANLG.spirovent" "Spirovent" "X(8)" "character" ? ? ? ? ? ? no "" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
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
  ENABLE tbNPSHANLG refresh_tbNPSHANLG excel_tbNPSHANLG BrwNPSHANLG 
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

  otbNPSHANLG = NEW JBoxToolbar(tbNPSHANLG:HANDLE).

  oBrwNPSHANLG:TOOLBAR-OBJECT = otbNPSHANLG.
END.
oBrwNPSHANLG:OpenQuery().


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

