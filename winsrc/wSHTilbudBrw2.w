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


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHTILBUD ***/
DEF VAR oBrwNPSHTILBUD AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHTILBUD
    FIELD id AS integer
    FIELD tilbudsid AS integer
    FIELD tilbudsnr AS character
    FIELD tilbudsdato AS date
    FIELD anleggsnr AS integer
    FIELD pris_shuntgrupper AS decimal
    FIELD pris AS decimal
    FIELD pris_tillegg AS decimal
    FIELD rabatt% AS decimal
    FIELD anlegg AS character
    FIELD kundenr AS character
    FIELD avgittpris AS decimal
    FIELD bet_bet AS character
    FIELD deres_ref AS character
    FIELD gyldighetstid AS integer
    FIELD lev_bet AS character
    FIELD opplysninger AS character
    FIELD vaar_ref AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_NPSHTILBUD FOR TEMP-TABLE NPSHTILBUD.


FUNCTION getBuffersAndFieldsBrwNPSHTILBUD RETURNS CHARACTER():
  RETURN
    'NPSHTILBUD'
     + ';id'
     + ';tilbudsid'
     + ';tilbudsnr'
     + ';tilbudsdato'
     + ';anleggsnr'
     + ';pris_shuntgrupper'
     + ';pris'
     + ';pris_tillegg'
     + ';rabatt%'
     + ';kundenr'
     + ';avgittpris'
     + ';bet_bet'
     + ';deres_ref'
     + ';gyldighetstid'
     + ';lev_bet'
     + ';opplysninger'
     + ';vaar_ref'
  + ',NPSHANLG'
     + ';anlegg'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHTILBUD RETURNS CHARACTER():
  RETURN 'EACH NPSHANLG OF NPSHTILBUD NO-LOCK'.
END FUNCTION.
DEF VAR otbNPSHTILBUD AS JBoxToolbar NO-UNDO.


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHTOPP ***/
DEF VAR oBrwNPSHTOPP AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHTOPP
    FIELD id AS integer
    FIELD neste_oppf_aar AS integer
    FIELD neste_oppf_uke AS integer
    FIELD neste_oppf AS date
    FIELD kriterium_1 AS character
    FIELD kriterium_2 AS character
    FIELD oppf_dato AS date
    FIELD oppf_nr AS integer
    FIELD oppf_status AS character
    FIELD oppf_uke AS integer
    FIELD tiltak AS character
    FIELD vaar_kontakt AS character
    FIELD notater AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPSHTOPP FOR TEMP-TABLE NPSHTOPP.


FUNCTION getBuffersAndFieldsBrwNPSHTOPP RETURNS CHARACTER():
  RETURN
    'NPSHTOPP'
     + ';id'
     + ';neste_oppf_aar'
     + ';neste_oppf_uke'
     + ';neste_oppf'
     + ';kriterium_1'
     + ';kriterium_2'
     + ';oppf_dato'
     + ';oppf_nr'
     + ';oppf_status'
     + ';oppf_uke'
     + ';tiltak'
     + ';vaar_kontakt'
     + ';notater'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHTOPP RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNPSHTOPP AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHTILBUD

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTILBUD NPSHTOPP

/* Definitions for BROWSE BrwNPSHTILBUD                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD.id ~
NPSHTILBUD.tilbudsid NPSHTILBUD.tilbudsnr NPSHTILBUD.tilbudsdato ~
NPSHTILBUD.anleggsnr NPSHTILBUD.pris_shuntgrupper NPSHTILBUD.pris ~
NPSHTILBUD.pris_tillegg NPSHTILBUD.rabatt% NPSHTILBUD.anlegg ~
NPSHTILBUD.kundenr NPSHTILBUD.avgittpris NPSHTILBUD.bet_bet ~
NPSHTILBUD.deres_ref NPSHTILBUD.gyldighetstid NPSHTILBUD.lev_bet ~
NPSHTILBUD.opplysninger NPSHTILBUD.vaar_ref 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD.id ~
NPSHTILBUD.anleggsnr 
&Scoped-define QUERY-STRING-BrwNPSHTILBUD FOR EACH NPSHTILBUD NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHTILBUD OPEN QUERY BrwNPSHTILBUD FOR EACH NPSHTILBUD NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHTILBUD NPSHTILBUD


/* Definitions for BROWSE BrwNPSHTOPP                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHTOPP NPSHTOPP.id ~
NPSHTOPP.neste_oppf_aar NPSHTOPP.neste_oppf_uke NPSHTOPP.neste_oppf ~
NPSHTOPP.kriterium_1 NPSHTOPP.kriterium_2 NPSHTOPP.oppf_dato ~
NPSHTOPP.oppf_nr NPSHTOPP.oppf_status NPSHTOPP.oppf_uke NPSHTOPP.tiltak ~
NPSHTOPP.vaar_kontakt NPSHTOPP.notater 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHTOPP NPSHTOPP.id 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSHTOPP NPSHTOPP
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSHTOPP NPSHTOPP
&Scoped-define QUERY-STRING-BrwNPSHTOPP FOR EACH NPSHTOPP NO-LOCK, INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHTOPP OPEN QUERY BrwNPSHTOPP FOR EACH NPSHTOPP NO-LOCK, INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHTOPP NPSHTOPP
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHTOPP NPSHTOPP


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHTILBUD refresh_tbNPSHTILBUD ~
BrwNPSHTILBUD BrwNPSHTOPP notater lblNotat 
&Scoped-Define DISPLAYED-OBJECTS notater lblNotat 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON refresh_tbNPSHTILBUD 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 6 BY 1.52 TOOLTIP "Refresh (F5)".

DEFINE VARIABLE notater AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 76 BY 3.57 NO-UNDO.

DEFINE VARIABLE lblNotat AS CHARACTER FORMAT "X(256)":U INITIAL "Notat:" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE RECTANGLE tbNPSHTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 134.8 BY 1.71.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHTILBUD FOR 
      NPSHTILBUD SCROLLING.

DEFINE QUERY BrwNPSHTOPP FOR 
      NPSHTOPP SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHTILBUD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHTILBUD C-Win _STRUCTURED
  QUERY BrwNPSHTILBUD NO-LOCK DISPLAY
      NPSHTILBUD.id COLUMN-LABEL "Id" FORMAT ">>>>>>":U
      NPSHTILBUD.tilbudsid COLUMN-LABEL "tilbudsid" FORMAT "9999":U
      NPSHTILBUD.tilbudsnr COLUMN-LABEL "Tilbudsnr." FORMAT "X(20)":U
      NPSHTILBUD.tilbudsdato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSHTILBUD.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHTILBUD.pris_shuntgrupper COLUMN-LABEL "Shunt" FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.pris COLUMN-LABEL "Pris" FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.pris_tillegg COLUMN-LABEL "Tillegg" FORMAT ">>>,>>9":U
      NPSHTILBUD.rabatt% COLUMN-LABEL "Rabatt%" FORMAT "->>9.99":U
      NPSHTILBUD.anlegg COLUMN-LABEL "Anlegg" FORMAT "X(45)":U
      NPSHTILBUD.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSHTILBUD.avgittpris COLUMN-LABEL "Avgitt pris" FORMAT ">>,>>>,>>9.99":U
      NPSHTILBUD.bet_bet COLUMN-LABEL "Bet. bet." FORMAT "X(20)":U
      NPSHTILBUD.deres_ref COLUMN-LABEL "Deres ref." FORMAT "X(30)":U
      NPSHTILBUD.gyldighetstid COLUMN-LABEL "Gyldighetstid" FORMAT ">99":U
      NPSHTILBUD.lev_bet COLUMN-LABEL "Lev. bet." FORMAT "X(8)":U
      NPSHTILBUD.opplysninger COLUMN-LABEL "Opplysninger" FORMAT "X(1024)":U
      NPSHTILBUD.vaar_ref COLUMN-LABEL "Vår ref." FORMAT "X(25)":U
  ENABLE
      NPSHTILBUD.id
      NPSHTILBUD.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 58 BY 13.62 FIT-LAST-COLUMN.

DEFINE BROWSE BrwNPSHTOPP
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHTOPP C-Win _STRUCTURED
  QUERY BrwNPSHTOPP NO-LOCK DISPLAY
      NPSHTOPP.id COLUMN-LABEL "id" FORMAT ">>>>9":U
      NPSHTOPP.neste_oppf_aar COLUMN-LABEL "Oppf. år" FORMAT "9999":U
      NPSHTOPP.neste_oppf_uke COLUMN-LABEL "Neste oppf.uke" FORMAT ">9":U
      NPSHTOPP.neste_oppf COLUMN-LABEL "Neste oppf." FORMAT "99.99.9999":U
      NPSHTOPP.kriterium_1 COLUMN-LABEL "Kriterium 1" FORMAT "X(25)":U
      NPSHTOPP.kriterium_2 COLUMN-LABEL "Kriterium 2" FORMAT "X(25)":U
      NPSHTOPP.oppf_dato COLUMN-LABEL "Oppf.dato" FORMAT "99.99.9999":U
      NPSHTOPP.oppf_nr COLUMN-LABEL "Oppf.nr." FORMAT ">>>>>>9":U
      NPSHTOPP.oppf_status COLUMN-LABEL "Status" FORMAT "X(15)":U
      NPSHTOPP.oppf_uke COLUMN-LABEL "Oppf.uke" FORMAT ">9":U
      NPSHTOPP.tiltak COLUMN-LABEL "Tiltak" FORMAT "X(15)":U
      NPSHTOPP.vaar_kontakt COLUMN-LABEL "Vår kontakt" FORMAT "X(25)":U
      NPSHTOPP.notater COLUMN-LABEL "Notater" FORMAT "X(1024)":U
  ENABLE
      NPSHTOPP.id
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 76 BY 8.81 ROW-HEIGHT-CHARS .57 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSHTILBUD AT ROW 1.1 COL 2.2 WIDGET-ID 4
     BrwNPSHTILBUD AT ROW 3.14 COL 1 WIDGET-ID 200
     BrwNPSHTOPP AT ROW 3.14 COL 61 WIDGET-ID 300
     notater AT ROW 13.14 COL 61 NO-LABEL WIDGET-ID 6
     lblNotat AT ROW 12.43 COL 59 COLON-ALIGNED NO-LABEL
     tbNPSHTILBUD AT ROW 1 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 136.8 BY 15.76 WIDGET-ID 100.


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
         HEIGHT             = 15.76
         WIDTH              = 136.8
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 136.8
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 136.8
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
/* BROWSE-TAB BrwNPSHTILBUD refresh_tbNPSHTILBUD DEFAULT-FRAME */
/* BROWSE-TAB BrwNPSHTOPP BrwNPSHTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 15.76
       FRAME DEFAULT-FRAME:WIDTH            = 136.8.

ASSIGN 
       NPSHTILBUD.id:VISIBLE IN BROWSE BrwNPSHTILBUD = FALSE
       NPSHTILBUD.tilbudsid:VISIBLE IN BROWSE BrwNPSHTILBUD = FALSE
       NPSHTILBUD.anleggsnr:VISIBLE IN BROWSE BrwNPSHTILBUD = FALSE.

ASSIGN 
       NPSHTOPP.id:VISIBLE IN BROWSE BrwNPSHTOPP = FALSE
       NPSHTOPP.notater:VISIBLE IN BROWSE BrwNPSHTOPP = FALSE.

ASSIGN 
       lblNotat:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE
       lblNotat:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Notat:".

ASSIGN 
       tbNPSHTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refreshmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHTILBUD
/* Query rebuild information for BROWSE BrwNPSHTILBUD
     _TblList          = "norcalc.NPSHTILBUD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPSHTILBUD.id" "Id" ">>>>>>" "integer" ? ? ? ? ? ? yes "" no no "7.2" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHTILBUD.tilbudsid" "tilbudsid" "9999" "integer" ? ? ? ? ? ? no "" no no "7.6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHTILBUD.tilbudsnr" "Tilbudsnr." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHTILBUD.tilbudsdato" "Dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHTILBUD.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.4" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHTILBUD.pris_shuntgrupper" "Shunt" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHTILBUD.pris" "Pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHTILBUD.pris_tillegg" "Tillegg" ">>>,>>9" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSHTILBUD.rabatt%" "Rabatt%" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSHTILBUD.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn (oppdragssted)" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSHTILBUD.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSHTILBUD.avgittpris" "Avgitt pris" ">>,>>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSHTILBUD.bet_bet" "Bet. bet." "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSHTILBUD.deres_ref" "Deres ref." "X(30)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSHTILBUD.gyldighetstid" "Gyldighetstid" ">99" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSHTILBUD.lev_bet" "Lev. bet." "X(8)" "character" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSHTILBUD.opplysninger" "Opplysninger" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPSHTILBUD.vaar_ref" "Vår ref." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHTILBUD */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHTOPP
/* Query rebuild information for BROWSE BrwNPSHTOPP
     _TblList          = "norcalc.NPSHTOPP"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSHTOPP.id
"NPSHTOPP.id" "id" ">>>>9" "integer" ? ? ? ? ? ? yes "" no no "6" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSHTOPP.neste_oppf_aar
"NPSHTOPP.neste_oppf_aar" "Oppf. år" "9999" "integer" ? ? ? ? ? ? no "Oppgi år for neste oppfølging" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSHTOPP.neste_oppf_uke
"NPSHTOPP.neste_oppf_uke" "Neste oppf.uke" ">9" "integer" ? ? ? ? ? ? no "" no no "14.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSHTOPP.neste_oppf
"NPSHTOPP.neste_oppf" "Neste oppf." "99.99.9999" "date" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSHTOPP.kriterium_1
"NPSHTOPP.kriterium_1" "Kriterium 1" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSHTOPP.kriterium_2
"NPSHTOPP.kriterium_2" "Kriterium 2" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSHTOPP.oppf_dato
"NPSHTOPP.oppf_dato" "Oppf.dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSHTOPP.oppf_nr
"NPSHTOPP.oppf_nr" "Oppf.nr." ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSHTOPP.oppf_status
"NPSHTOPP.oppf_status" "Status" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSHTOPP.oppf_uke
"NPSHTOPP.oppf_uke" "Oppf.uke" ">9" "integer" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSHTOPP.tiltak
"NPSHTOPP.tiltak" "Tiltak" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSHTOPP.vaar_kontakt
"NPSHTOPP.vaar_kontakt" "Vår kontakt" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSHTOPP.notater
"NPSHTOPP.notater" "Notater" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" no no no "U" "" "" "" "" "" "" 0 no 0 no no
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


&Scoped-define BROWSE-NAME BrwNPSHTILBUD
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
{incl/conttrigg.i oBrwNPSHTILBUD:BROWSE-HANDLE}
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
  DISPLAY notater lblNotat 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHTILBUD refresh_tbNPSHTILBUD BrwNPSHTILBUD BrwNPSHTOPP notater 
         lblNotat 
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

  oBrwNPSHTILBUD = NEW JBoxBrowse(brwNPSHTILBUD:HANDLE).
  
  otbNPSHTILBUD = NEW JBoxToolbar(tbNPSHTILBUD:HANDLE).

  oBrwNPSHTILBUD:TOOLBAR-OBJECT = otbNPSHTILBUD.
  oBrwNPSHTOPP = NEW JBoxBrowse(brwNPSHTOPP:HANDLE).

  oFmNPSHTOPP = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPSHTOPP:updateFields = 'notater'.

  oFmNPSHTOPP:BROWSE-OBJECT = oBrwNPSHTOPP.
  oBrwNPSHTOPP:setParentBrowseObject(oBrwNPSHTILBUD,'id').
END.
oBrwNPSHTILBUD:OpenQuery().

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oBrwNPSHTOPP:setNoResizeY().
  oBrwNPSHTILBUD:setNoResizeX().
  oContainer:initResize(500,300).
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

