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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHTOPP ***/
DEF VAR oBrwNPSHTOPP AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHTOPP
    FIELD tilbudsnr AS character
    FIELD tilbudsid AS integer
    FIELD anlegg AS character
    FIELD kundenavn AS character
    FIELD id AS integer
    FIELD kriterium_1 AS character
    FIELD kriterium_2 AS character
    FIELD neste_oppf AS date
    FIELD neste_oppf_aar AS integer
    FIELD neste_oppf_uke AS integer
    FIELD notater AS character
    FIELD oppf_dato AS date
    FIELD oppf_nr AS integer
    FIELD oppf_status AS character
    FIELD oppf_uke AS integer
    FIELD tiltak AS character
    FIELD vaar_kontakt AS character
    FIELD anleggsnr AS integer
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD id2 AS integer
    FIELD kundenr AS character
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD pris AS decimal
    FIELD pris_shuntgrupper AS decimal
    FIELD pris_tillegg AS decimal
    FIELD rabatt% AS decimal
    FIELD tilbudsdato AS date
    FIELD vaar_ref AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowIdent4 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3 RowIdent4
    .
DEF BUFFER v_NPSHTOPP FOR TEMP-TABLE NPSHTOPP.


FUNCTION getBuffersAndFieldsBrwNPSHTOPP RETURNS CHARACTER():
  RETURN
    'NPSHTOPP'
     + ';id'
     + ';kriterium_1'
     + ';kriterium_2'
     + ';neste_oppf'
     + ';neste_oppf_aar'
     + ';neste_oppf_uke'
     + ';notater'
     + ';oppf_dato'
     + ';oppf_nr'
     + ';oppf_status'
     + ';oppf_uke'
     + ';tiltak'
     + ';vaar_kontakt'
  + ',NPSHTILBUD'
     + ';tilbudsnr'
     + ';tilbudsid'
     + ';anleggsnr'
     + ';avgittpris'
     + ';bet_bet'
     + ';deres_ref'
     + ';gyldighetstid'
     + ';id'
     + ';kundenr'
     + ';lev_bet'
     + ';opplysninger'
     + ';pris'
     + ';pris_shuntgrupper'
     + ';pris_tillegg'
     + ';rabatt%'
     + ';tilbudsdato'
     + ';vaar_ref'
  + ',NPSHANLG'
     + ';anlegg'
  + ',NPKUNDE'
     + ';kundenavn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHTOPP RETURNS CHARACTER():
  RETURN 'EACH NPSHTILBUD OF NPSHTOPP NO-LOCK,EACH NPSHANLG OF NPSHTILBUD NO-LOCK,EACH NPKUNDE OF NPSHTILBUD NO-LOCK'.
END FUNCTION.
DEF VAR otbNPSHTILBUD AS JBoxToolbar NO-UNDO.
DEF VAR opopupNPSHTOPP AS JBoxPopupMenu NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define WIDGETID-FILE-NAME 

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHTOPP

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTOPP

/* Definitions for BROWSE BrwNPSHTOPP                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHTOPP NPSHTOPP.tilbudsnr ~
NPSHTOPP.tilbudsid NPSHTOPP.anlegg NPSHTOPP.kundenavn NPSHTOPP.id ~
NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 NPSHTOPP.neste_oppf ~
NPSHTOPP.neste_oppf_aar NPSHTOPP.neste_oppf_uke NPSHTOPP.notater ~
NPSHTOPP.oppf_dato NPSHTOPP.oppf_nr NPSHTOPP.oppf_status NPSHTOPP.oppf_uke ~
NPSHTOPP.tiltak NPSHTOPP.vaar_kontakt NPSHTOPP.anleggsnr ~
NPSHTOPP.avgittpris NPSHTOPP.bet_bet NPSHTOPP.deres_ref ~
NPSHTOPP.gyldighetstid NPSHTOPP.id2 NPSHTOPP.kundenr NPSHTOPP.lev_bet ~
NPSHTOPP.opplysninger NPSHTOPP.pris NPSHTOPP.pris_shuntgrupper ~
NPSHTOPP.pris_tillegg NPSHTOPP.rabatt% NPSHTOPP.tilbudsdato ~
NPSHTOPP.vaar_ref 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHTOPP NPSHTOPP.tilbudsnr ~
NPSHTOPP.id 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSHTOPP NPSHTOPP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSHTOPP NPSHTOPP
&Scoped-define QUERY-STRING-BrwNPSHTOPP FOR EACH NPSHTOPP NO-LOCK, ~
    EACH NPSHTILBUD OF NPSHTOPP NO-LOCK, ~
    EACH NPSHANLG OF NPSHTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSHTILBUD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHTOPP OPEN QUERY BrwNPSHTOPP FOR EACH NPSHTOPP NO-LOCK, ~
    EACH NPSHTILBUD OF NPSHTOPP NO-LOCK, ~
    EACH NPSHANLG OF NPSHTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSHTILBUD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHTOPP NPSHTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHTOPP NPSHTOPP


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHTILBUD browseconfig_tbNPSHTILBUD ~
filter_tbNPSHTILBUD refresh_tbNPSHTILBUD excel_tbNPSHTILBUD BrwNPSHTOPP 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPSHTILBUD 
     IMAGE-UP FILE "bmp/table.bmp":U
     LABEL "Column setup" 
     SIZE 6 BY 1.52 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON excel_tbNPSHTILBUD 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.52 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNPSHTILBUD 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 6 BY 1.52 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON refresh_tbNPSHTILBUD 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSHTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 109 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHTOPP FOR 
      NPSHTOPP SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHTOPP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHTOPP C-Win _STRUCTURED
  QUERY BrwNPSHTOPP NO-LOCK DISPLAY
      NPSHTOPP.tilbudsnr FORMAT "X(20)":U
      NPSHTOPP.tilbudsid FORMAT "9999":U
      NPSHTOPP.anlegg FORMAT "X(45)":U
      NPSHTOPP.kundenavn FORMAT "X(30)":U
      NPSHTOPP.id FORMAT ">>>>9":U
      NPSHTOPP.kriterium_1 FORMAT "X(25)":U
      NPSHTOPP.kriterium_2 FORMAT "X(25)":U
      NPSHTOPP.neste_oppf FORMAT "99.99.9999":U
      NPSHTOPP.neste_oppf_aar FORMAT "9999":U
      NPSHTOPP.neste_oppf_uke FORMAT ">9":U
      NPSHTOPP.notater FORMAT "X(1024)":U
      NPSHTOPP.oppf_dato FORMAT "99.99.9999":U
      NPSHTOPP.oppf_nr FORMAT ">>>>>>9":U
      NPSHTOPP.oppf_status FORMAT "X(15)":U
      NPSHTOPP.oppf_uke FORMAT ">9":U
      NPSHTOPP.tiltak FORMAT "X(15)":U
      NPSHTOPP.vaar_kontakt FORMAT "X(25)":U
      NPSHTOPP.anleggsnr FORMAT ">>>>>9":U
      NPSHTOPP.avgittpris FORMAT ">>,>>>,>>9.99":U
      NPSHTOPP.bet_bet FORMAT "X(20)":U
      NPSHTOPP.deres_ref FORMAT "X(30)":U
      NPSHTOPP.gyldighetstid FORMAT ">99":U
      NPSHTOPP.id2 FORMAT ">>>>>>":U
      NPSHTOPP.kundenr FORMAT "X(8)":U
      NPSHTOPP.lev_bet FORMAT "X(8)":U
      NPSHTOPP.opplysninger FORMAT "X(1024)":U
      NPSHTOPP.pris FORMAT ">>,>>>,>>9.99":U
      NPSHTOPP.pris_shuntgrupper FORMAT ">>,>>>,>>9.99":U
      NPSHTOPP.pris_tillegg FORMAT ">>>,>>9":U
      NPSHTOPP.rabatt% FORMAT "->>9.99":U
      NPSHTOPP.tilbudsdato FORMAT "99.99.9999":U
      NPSHTOPP.vaar_ref FORMAT "X(25)":U
  ENABLE
      NPSHTOPP.tilbudsnr
      NPSHTOPP.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 110 BY 11.52 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     browseconfig_tbNPSHTILBUD AT ROW 1.1 COL 1.2 WIDGET-ID 10
     filter_tbNPSHTILBUD AT ROW 1.1 COL 7.4 WIDGET-ID 8
     refresh_tbNPSHTILBUD AT ROW 1.1 COL 13.4 WIDGET-ID 4
     excel_tbNPSHTILBUD AT ROW 1.1 COL 19.4 WIDGET-ID 6
     BrwNPSHTOPP AT ROW 3.38 COL 1 WIDGET-ID 200
     tbNPSHTILBUD AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 110 BY 13.91 WIDGET-ID 100.


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
         HEIGHT             = 13.91
         WIDTH              = 110
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 114.2
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
&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
  IF C-Win = ? THEN
    CREATE FRAME C-Win
           ASSIGN HIDDEN = YES.
&ENDIF

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
/* BROWSE-TAB BrwNPSHTOPP excel_tbNPSHTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 13.91
       FRAME DEFAULT-FRAME:WIDTH            = 110.

ASSIGN 
       BrwNPSHTOPP:PRIVATE-DATA IN FRAME DEFAULT-FRAME           = 
                "multiSortBrowse;Sorter på flere kolonner".

ASSIGN 
       tbNPSHTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "browseconfig;Column setup,filter;Filter,refresh;Refresh,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHTOPP
/* Query rebuild information for BROWSE BrwNPSHTOPP
     _TblList          = "norcalc.NPSHTOPP"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSHTOPP.tilbudsnr
"NPSHTOPP.tilbudsnr" "Tilbudsnr." "X(20)" "character" ? ? ? ? ? ? yes "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSHTOPP.tilbudsid
"NPSHTOPP.tilbudsid" "tilbudsid" "9999" "integer" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSHTOPP.anlegg
"NPSHTOPP.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn (oppdragssted)" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSHTOPP.kundenavn
"NPSHTOPP.kundenavn" "Kundenavn" "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSHTOPP.id
"NPSHTOPP.id" "id" ">>>>9" "integer" ? ? ? ? ? ? yes "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSHTOPP.kriterium_1
"NPSHTOPP.kriterium_1" "Kriterium 1" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSHTOPP.kriterium_2
"NPSHTOPP.kriterium_2" "Kriterium 2" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSHTOPP.neste_oppf
"NPSHTOPP.neste_oppf" "Neste oppf." "99.99.9999" "date" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSHTOPP.neste_oppf_aar
"NPSHTOPP.neste_oppf_aar" "Oppf. år" "9999" "integer" ? ? ? ? ? ? no "Oppgi år for neste oppfølging" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSHTOPP.neste_oppf_uke
"NPSHTOPP.neste_oppf_uke" "Neste oppf.uke" ">9" "integer" ? ? ? ? ? ? no "" no no "14.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSHTOPP.notater
"NPSHTOPP.notater" "Notater" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSHTOPP.oppf_dato
"NPSHTOPP.oppf_dato" "Oppf.dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSHTOPP.oppf_nr
"NPSHTOPP.oppf_nr" "Oppf.nr." ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSHTOPP.oppf_status
"NPSHTOPP.oppf_status" "Status" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSHTOPP.oppf_uke
"NPSHTOPP.oppf_uke" "Oppf.uke" ">9" "integer" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSHTOPP.tiltak
"NPSHTOPP.tiltak" "Tiltak" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSHTOPP.vaar_kontakt
"NPSHTOPP.vaar_kontakt" "Vår kontakt" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSHTOPP.anleggsnr
"NPSHTOPP.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSHTOPP.avgittpris
"NPSHTOPP.avgittpris" "Avgitt pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSHTOPP.bet_bet
"NPSHTOPP.bet_bet" "Bet. bet." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSHTOPP.deres_ref
"NPSHTOPP.deres_ref" "Deres ref." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSHTOPP.gyldighetstid
"NPSHTOPP.gyldighetstid" "Gyldighetstid" ">99" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSHTOPP.id2
"NPSHTOPP.id2" "Id" ">>>>>>" "integer" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSHTOPP.kundenr
"NPSHTOPP.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSHTOPP.lev_bet
"NPSHTOPP.lev_bet" "Lev. bet." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSHTOPP.opplysninger
"NPSHTOPP.opplysninger" "Opplysninger" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSHTOPP.pris
"NPSHTOPP.pris" "Pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSHTOPP.pris_shuntgrupper
"NPSHTOPP.pris_shuntgrupper" "Shunt" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > NPSHTOPP.pris_tillegg
"NPSHTOPP.pris_tillegg" "Tillegg" ">>>,>>9" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > NPSHTOPP.rabatt%
"NPSHTOPP.rabatt%" "Rabatt%" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > NPSHTOPP.tilbudsdato
"NPSHTOPP.tilbudsdato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > NPSHTOPP.vaar_ref
"NPSHTOPP.vaar_ref" "Vår ref." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHTOPP */
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


&Scoped-define BROWSE-NAME BrwNPSHTOPP
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
&ENDIF

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPSHTOPP:BROWSE-HANDLE}
&ENDIF

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
  ENABLE tbNPSHTILBUD browseconfig_tbNPSHTILBUD filter_tbNPSHTILBUD 
         refresh_tbNPSHTILBUD excel_tbNPSHTILBUD BrwNPSHTOPP 
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
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DO WITH FRAME {&FRAME-NAME}:

  oBrwNPSHTOPP = NEW JBoxBrowse(brwNPSHTOPP:HANDLE).
  otbNPSHTILBUD = NEW JBoxToolbar(tbNPSHTILBUD:HANDLE).

  oBrwNPSHTOPP:TOOLBAR-OBJECT = otbNPSHTILBUD.
  opopupNPSHTOPP = NEW JBoxPopupMenu().
  opopupNPSHTOPP:AddToolGroup('multiSortBrowse;Sorter på flere kolonner').

  oBrwNPSHTOPP:POPUP-MENU-OBJECT = opopupNPSHTOPP.
END.
oBrwNPSHTOPP:OpenQuery().

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize().
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

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

