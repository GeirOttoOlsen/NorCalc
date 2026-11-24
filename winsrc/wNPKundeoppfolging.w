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

def var oKontaktdato as JBoxDevExDateEdit no-undo.

/*** Start instance property definitions for JBoxBrowse object oBrwNPKUNDEOPPF ***/
DEF VAR oBrwNPKUNDEOPPF AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPKUNDEOPPF
    FIELD kundenr AS character
    FIELD kontakt_dato AS date
    FIELD kontaktet_av AS character
    FIELD neste_kontakt AS date
    FIELD neste_kontakt_av AS character
    FIELD aktivitet AS character
    FIELD bes_returnert AS logical
    FIELD deres_ref AS character
    FIELD haster AS logical
    FIELD iflg_avtale AS logical
    FIELD kontaktet_pr AS character
    FIELD mini_brev AS character
    FIELD nor_firma AS character
    FIELD oppf_id AS integer
    FIELD oppf_ok AS logical
    FIELD rapport AS character
    FIELD svar_imotesees AS logical
    FIELD takk_for_laanet AS logical
    FIELD til_godkjennelse AS logical
    FIELD til_orientering AS logical
    FIELD vedlegg AS character
    FIELD vennligst_ring AS logical
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NPKUNDEOPPF FOR TEMP-TABLE NPKUNDEOPPF.


FUNCTION getBuffersAndFieldsBrwNPKUNDEOPPF RETURNS CHARACTER():
  RETURN
    'NPKUNDEOPPF'
     + ';kundenr'
     + ';kontakt_dato'
     + ';kontaktet_av'
     + ';neste_kontakt'
     + ';neste_kontakt_av'
     + ';aktivitet'
     + ';bes_returnert'
     + ';deres_ref'
     + ';haster'
     + ';iflg_avtale'
     + ';kontaktet_pr'
     + ';mini_brev'
     + ';nor_firma'
     + ';oppf_id'
     + ';oppf_ok'
     + ';rapport'
     + ';svar_imotesees'
     + ';takk_for_laanet'
     + ';til_godkjennelse'
     + ';til_orientering'
     + ';vedlegg'
     + ';vennligst_ring'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPKUNDEOPPF RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR otbNPKUNDEOPPF AS JBoxToolbar NO-UNDO.


DEF VAR oFmNPKUNDEOPPF AS JBoxFieldMap NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPKUNDEOPPF

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKUNDEOPPF

/* Definitions for BROWSE BrwNPKUNDEOPPF                                */
&Scoped-define FIELDS-IN-QUERY-BrwNPKUNDEOPPF NPKUNDEOPPF.kundenr ~
NPKUNDEOPPF.kontakt_dato NPKUNDEOPPF.kontaktet_av NPKUNDEOPPF.neste_kontakt ~
NPKUNDEOPPF.neste_kontakt_av NPKUNDEOPPF.aktivitet ~
NPKUNDEOPPF.bes_returnert NPKUNDEOPPF.deres_ref NPKUNDEOPPF.haster ~
NPKUNDEOPPF.iflg_avtale NPKUNDEOPPF.kontaktet_pr NPKUNDEOPPF.mini_brev ~
NPKUNDEOPPF.nor_firma NPKUNDEOPPF.oppf_id NPKUNDEOPPF.oppf_ok ~
NPKUNDEOPPF.rapport NPKUNDEOPPF.svar_imotesees NPKUNDEOPPF.takk_for_laanet ~
NPKUNDEOPPF.til_godkjennelse NPKUNDEOPPF.til_orientering ~
NPKUNDEOPPF.vedlegg NPKUNDEOPPF.vennligst_ring 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPKUNDEOPPF NPKUNDEOPPF.kundenr ~
NPKUNDEOPPF.aktivitet 
&Scoped-define QUERY-STRING-BrwNPKUNDEOPPF FOR EACH NPKUNDEOPPF NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPKUNDEOPPF OPEN QUERY BrwNPKUNDEOPPF FOR EACH NPKUNDEOPPF NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPKUNDEOPPF NPKUNDEOPPF
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPKUNDEOPPF NPKUNDEOPPF


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPKUNDEOPPF new_tbNPKUNDEOPPF ~
copy_tbNPKUNDEOPPF undo_tbNPKUNDEOPPF save_tbNPKUNDEOPPF ~
delete_tbNPKUNDEOPPF excel_tbNPKUNDEOPPF Minibrev_tbNPKUNDEOPPF ~
BrwNPKUNDEOPPF oppf_ok kontakt_dato kontaktet_av kontaktet_pr neste_kontakt ~
neste_kontakt_av aktivitet nor_firma deres_ref iflg_avtale haster ~
til_godkjennelse svar_imotesees bes_returnert vennligst_ring ~
takk_for_laanet til_orientering rapport mini_brev 
&Scoped-Define DISPLAYED-OBJECTS oppf_ok kontakt_dato kontaktet_av ~
kontaktet_pr neste_kontakt neste_kontakt_av aktivitet nor_firma deres_ref ~
iflg_avtale haster til_godkjennelse svar_imotesees bes_returnert ~
vennligst_ring takk_for_laanet til_orientering rapport mini_brev lblRapport ~
lblMinibrev 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNPKUNDEOPPF 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Copy" 
     SIZE 7.75 BY 1.94 TOOLTIP "Copy (ALT-C)".

DEFINE BUTTON delete_tbNPKUNDEOPPF 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 7.75 BY 1.94 TOOLTIP "Delete (CTRL-D)".

DEFINE BUTTON excel_tbNPKUNDEOPPF 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Excel" 
     SIZE 7.75 BY 1.94 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON Minibrev_tbNPKUNDEOPPF 
     IMAGE-UP FILE "img/ico/eye_blue.ico":U
     LABEL "Minibrev" 
     SIZE 7.75 BY 1.94 TOOLTIP "Minibrev".

DEFINE BUTTON new_tbNPKUNDEOPPF 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "New" 
     SIZE 7.75 BY 1.94 TOOLTIP "New (CTRL-N)".

DEFINE BUTTON save_tbNPKUNDEOPPF 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 7.75 BY 1.94 TOOLTIP "Save (CTRL-S)".

DEFINE BUTTON undo_tbNPKUNDEOPPF 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 7.75 BY 1.94 TOOLTIP "Undo (CTRL-Z)".

DEFINE VARIABLE aktivitet AS CHARACTER FORMAT "X(256)":U 
     LABEL "Aktivitet" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE kontaktet_av AS CHARACTER FORMAT "X(256)":U 
     LABEL "Vår kontakt" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 36 BY 1 NO-UNDO.

DEFINE VARIABLE kontaktet_pr AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pr." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE neste_kontakt AS CHARACTER FORMAT "X(256)":U 
     LABEL "Neste kontakt" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE neste_kontakt_av AS CHARACTER FORMAT "X(256)":U 
     LABEL "v/" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 26 BY 1 NO-UNDO.

DEFINE VARIABLE nor_firma AS CHARACTER FORMAT "X(256)":U 
     LABEL "Norfirma" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE mini_brev AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 153 BY 2.63 TOOLTIP "Rapport" NO-UNDO.

DEFINE VARIABLE rapport AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 153 BY 4.44 TOOLTIP "Rapport" NO-UNDO.

DEFINE VARIABLE deres_ref AS CHARACTER FORMAT "X(25)" 
     LABEL "Deres ref." 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1.

DEFINE VARIABLE kontakt_dato AS DATE FORMAT "99.99.9999" 
     LABEL "Kontaktdato" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE VARIABLE lblMinibrev AS CHARACTER FORMAT "X(256)":U INITIAL "Minibrev:" 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE lblRapport AS CHARACTER FORMAT "X(256)":U INITIAL "Rapport:" 
      VIEW-AS TEXT 
     SIZE 10 BY .63 NO-UNDO.

DEFINE RECTANGLE tbNPKUNDEOPPF
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 157 BY 2.13.

DEFINE VARIABLE bes_returnert AS LOGICAL INITIAL no 
     LABEL "Bes returnert" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 NO-UNDO.

DEFINE VARIABLE haster AS LOGICAL INITIAL no 
     LABEL "HASTER" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.38 BY .81 NO-UNDO.

DEFINE VARIABLE iflg_avtale AS LOGICAL INITIAL no 
     LABEL "I følge avtale" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .81 TOOLTIP "I følge avtale" NO-UNDO.

DEFINE VARIABLE oppf_ok AS LOGICAL INITIAL no 
     LABEL "Oppfølging ok" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .81 NO-UNDO.

DEFINE VARIABLE svar_imotesees AS LOGICAL INITIAL no 
     LABEL "Svar imøtesees" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .81 NO-UNDO.

DEFINE VARIABLE takk_for_laanet AS LOGICAL INITIAL no 
     LABEL "Takk for lånet" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .81 NO-UNDO.

DEFINE VARIABLE til_godkjennelse AS LOGICAL INITIAL no 
     LABEL "Til godkjennelse" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

DEFINE VARIABLE til_orientering AS LOGICAL INITIAL no 
     LABEL "Til orientering" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 NO-UNDO.

DEFINE VARIABLE vennligst_ring AS LOGICAL INITIAL no 
     LABEL "Vennligst ring" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPKUNDEOPPF FOR 
      NPKUNDEOPPF SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPKUNDEOPPF
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPKUNDEOPPF C-Win _STRUCTURED
  QUERY BrwNPKUNDEOPPF NO-LOCK DISPLAY
      NPKUNDEOPPF.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPKUNDEOPPF.kontakt_dato COLUMN-LABEL "Kontaktdato" FORMAT "99.99.9999":U
            WIDTH 11.63
      NPKUNDEOPPF.kontaktet_av COLUMN-LABEL "Vår kontakt" FORMAT "X(25)":U
      NPKUNDEOPPF.neste_kontakt COLUMN-LABEL "Neste kontakt" FORMAT "99.99.9999":U
            WIDTH 13.38
      NPKUNDEOPPF.neste_kontakt_av COLUMN-LABEL "Neste kontakt av" FORMAT "X(25)":U
      NPKUNDEOPPF.aktivitet COLUMN-LABEL "Aktivitet" FORMAT "X(10)":U
      NPKUNDEOPPF.bes_returnert COLUMN-LABEL "Returner" FORMAT "yes/no":U
            WIDTH 12.38
      NPKUNDEOPPF.deres_ref COLUMN-LABEL "Deres ref." FORMAT "X(25)":U
      NPKUNDEOPPF.haster COLUMN-LABEL "Haster" FORMAT "yes/no":U
            WIDTH 5.75
      NPKUNDEOPPF.iflg_avtale COLUMN-LABEL "Ifølge avtale" FORMAT "yes/no":U
            WIDTH 11.63
      NPKUNDEOPPF.kontaktet_pr COLUMN-LABEL "Kontaktet pr." FORMAT "X(5)":U
            WIDTH 12.25
      NPKUNDEOPPF.mini_brev COLUMN-LABEL "Minibrev" FORMAT "X(1024)":U
      NPKUNDEOPPF.nor_firma COLUMN-LABEL "Firma" FORMAT "X(2)":U
      NPKUNDEOPPF.oppf_id COLUMN-LABEL "oppf_id" FORMAT ">>9":U
            WIDTH 7
      NPKUNDEOPPF.oppf_ok COLUMN-LABEL "OK" FORMAT "ja/nei":U
      NPKUNDEOPPF.rapport COLUMN-LABEL "Rapport" FORMAT "X(1024)":U
      NPKUNDEOPPF.svar_imotesees COLUMN-LABEL "svar_imotesees" FORMAT "yes/no":U
            WIDTH 14.63
      NPKUNDEOPPF.takk_for_laanet COLUMN-LABEL "takk_for_laanet" FORMAT "yes/no":U
            WIDTH 14.75
      NPKUNDEOPPF.til_godkjennelse COLUMN-LABEL "til_godkjennelse" FORMAT "yes/no":U
            WIDTH 15.25
      NPKUNDEOPPF.til_orientering COLUMN-LABEL "til_orientering" FORMAT "yes/no":U
            WIDTH 12.38
      NPKUNDEOPPF.vedlegg COLUMN-LABEL "Vedlegg" FORMAT "X(256)":U
      NPKUNDEOPPF.vennligst_ring COLUMN-LABEL "vennligst_ring" FORMAT "yes/no":U
            WIDTH 13
  ENABLE
      NPKUNDEOPPF.kundenr
      NPKUNDEOPPF.aktivitet
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 44 BY 7.38 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPKUNDEOPPF AT ROW 1.09 COL 1.25 WIDGET-ID 64
     copy_tbNPKUNDEOPPF AT ROW 1.09 COL 9.25 WIDGET-ID 66
     undo_tbNPKUNDEOPPF AT ROW 1.09 COL 17 WIDGET-ID 68
     save_tbNPKUNDEOPPF AT ROW 1.09 COL 24.75 WIDGET-ID 70
     delete_tbNPKUNDEOPPF AT ROW 1.09 COL 32.63 WIDGET-ID 72
     excel_tbNPKUNDEOPPF AT ROW 1.09 COL 40.38 WIDGET-ID 10
     Minibrev_tbNPKUNDEOPPF AT ROW 1.09 COL 48.25 WIDGET-ID 74
     BrwNPKUNDEOPPF AT ROW 3.38 COL 2 WIDGET-ID 200
     oppf_ok AT ROW 3.63 COL 62 WIDGET-ID 44
     kontakt_dato AT ROW 4.47 COL 60 COLON-ALIGNED
     kontaktet_av AT ROW 5.53 COL 60 COLON-ALIGNED WIDGET-ID 52
     kontaktet_pr AT ROW 5.53 COL 102 COLON-ALIGNED WIDGET-ID 54
     neste_kontakt AT ROW 6.72 COL 60 COLON-ALIGNED WIDGET-ID 50
     neste_kontakt_av AT ROW 6.72 COL 81 COLON-ALIGNED WIDGET-ID 60
     aktivitet AT ROW 6.72 COL 118 COLON-ALIGNED WIDGET-ID 56
     nor_firma AT ROW 7.91 COL 60 COLON-ALIGNED WIDGET-ID 46
     deres_ref AT ROW 8.13 COL 89 COLON-ALIGNED
     iflg_avtale AT ROW 9.56 COL 62.63 WIDGET-ID 30
     haster AT ROW 9.56 COL 81.63 WIDGET-ID 42
     til_godkjennelse AT ROW 9.56 COL 103.63 WIDGET-ID 36
     svar_imotesees AT ROW 9.56 COL 127.63 WIDGET-ID 40
     bes_returnert AT ROW 10.28 COL 62.63 WIDGET-ID 32
     vennligst_ring AT ROW 10.28 COL 81.63 WIDGET-ID 34
     takk_for_laanet AT ROW 10.28 COL 103.63 WIDGET-ID 38
     til_orientering AT ROW 10.38 COL 127.63 WIDGET-ID 48
     rapport AT ROW 12.25 COL 2 NO-LABEL WIDGET-ID 58
     mini_brev AT ROW 17.44 COL 2 NO-LABEL WIDGET-ID 76
     lblRapport AT ROW 11.47 COL 2 NO-LABEL
     lblMinibrev AT ROW 16.72 COL 2 NO-LABEL
     tbNPKUNDEOPPF AT ROW 1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 157 BY 19.56 WIDGET-ID 100.


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
         HEIGHT             = 19.56
         WIDTH              = 157
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 157
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 157
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
/* BROWSE-TAB BrwNPKUNDEOPPF Minibrev_tbNPKUNDEOPPF DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 19.57
       FRAME DEFAULT-FRAME:WIDTH            = 157.

ASSIGN 
       NPKUNDEOPPF.kundenr:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.bes_returnert:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.deres_ref:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.haster:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.iflg_avtale:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.kontaktet_pr:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.mini_brev:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.nor_firma:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.oppf_id:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.oppf_ok:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.rapport:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.svar_imotesees:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.takk_for_laanet:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.til_godkjennelse:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.til_orientering:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.vedlegg:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE
       NPKUNDEOPPF.vennligst_ring:VISIBLE IN BROWSE BrwNPKUNDEOPPF = FALSE.

/* SETTINGS FOR FILL-IN lblMinibrev IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       lblMinibrev:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Minibrev:".

/* SETTINGS FOR FILL-IN lblRapport IN FRAME DEFAULT-FRAME
   NO-ENABLE ALIGN-L                                                    */
ASSIGN 
       lblRapport:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Rapport:".

ASSIGN 
       tbNPKUNDEOPPF:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;New,copy;Copy,undo;Undo,save;Save,delete;Delete,excel;Excel,Minibrev;Minibrevmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPKUNDEOPPF
/* Query rebuild information for BROWSE BrwNPKUNDEOPPF
     _TblList          = "norcalc.NPKUNDEOPPF"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NPKUNDEOPPF.kundenr" "Kundenr" "X(8)" "character" ? ? ? ? ? ? yes "" no no "8" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPKUNDEOPPF.kontakt_dato" "Kontaktdato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "11.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPKUNDEOPPF.kontaktet_av" "Vår kontakt" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPKUNDEOPPF.neste_kontakt" "Neste kontakt" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "13.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPKUNDEOPPF.neste_kontakt_av" "Neste kontakt av" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPKUNDEOPPF.aktivitet" "Aktivitet" "X(10)" "character" ? ? ? ? ? ? yes "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPKUNDEOPPF.bes_returnert" "Returner" "yes/no" "logical" ? ? ? ? ? ? no "" no no "12.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPKUNDEOPPF.deres_ref" "Deres ref." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPKUNDEOPPF.haster" "Haster" "yes/no" "logical" ? ? ? ? ? ? no "" no no "5.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPKUNDEOPPF.iflg_avtale" "Ifølge avtale" "yes/no" "logical" ? ? ? ? ? ? no "" no no "11.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPKUNDEOPPF.kontaktet_pr" "Kontaktet pr." "X(5)" "character" ? ? ? ? ? ? no "" no no "12.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPKUNDEOPPF.mini_brev" "Minibrev" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPKUNDEOPPF.nor_firma" "Firma" "X(2)" "character" ? ? ? ? ? ? no "" no no "5" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPKUNDEOPPF.oppf_id" "oppf_id" ">>9" "integer" ? ? ? ? ? ? no "" no no "7" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPKUNDEOPPF.oppf_ok" "OK" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "3" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPKUNDEOPPF.rapport" "Rapport" "X(1024)" "character" ? ? ? ? ? ? no "" no no "1024" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPKUNDEOPPF.svar_imotesees" "svar_imotesees" "yes/no" "logical" ? ? ? ? ? ? no "" no no "14.63" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPKUNDEOPPF.takk_for_laanet" "takk_for_laanet" "yes/no" "logical" ? ? ? ? ? ? no "" no no "14.75" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPKUNDEOPPF.til_godkjennelse" "til_godkjennelse" "yes/no" "logical" ? ? ? ? ? ? no "" no no "15.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPKUNDEOPPF.til_orientering" "til_orientering" "yes/no" "logical" ? ? ? ? ? ? no "" no no "12.38" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"NPKUNDEOPPF.vedlegg" "Vedlegg" "X(256)" "character" ? ? ? ? ? ? no "" no no "256" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"NPKUNDEOPPF.vennligst_ring" "vennligst_ring" "yes/no" "logical" ? ? ? ? ? ? no "" no no "13" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPKUNDEOPPF */
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


&Scoped-define BROWSE-NAME BrwNPKUNDEOPPF
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
{incl/conttrigg.i oBrwNPKUNDEOPPF:BROWSE-HANDLE}

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
  DISPLAY oppf_ok kontakt_dato kontaktet_av kontaktet_pr neste_kontakt 
          neste_kontakt_av aktivitet nor_firma deres_ref iflg_avtale haster 
          til_godkjennelse svar_imotesees bes_returnert vennligst_ring 
          takk_for_laanet til_orientering rapport mini_brev lblRapport 
          lblMinibrev 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPKUNDEOPPF new_tbNPKUNDEOPPF copy_tbNPKUNDEOPPF undo_tbNPKUNDEOPPF 
         save_tbNPKUNDEOPPF delete_tbNPKUNDEOPPF excel_tbNPKUNDEOPPF 
         Minibrev_tbNPKUNDEOPPF BrwNPKUNDEOPPF oppf_ok kontakt_dato 
         kontaktet_av kontaktet_pr neste_kontakt neste_kontakt_av aktivitet 
         nor_firma deres_ref iflg_avtale haster til_godkjennelse svar_imotesees 
         bes_returnert vennligst_ring takk_for_laanet til_orientering rapport 
         mini_brev 
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

  oBrwNPKUNDEOPPF = NEW JBoxBrowse(brwNPKUNDEOPPF:HANDLE).
  oBrwNPKUNDEOPPF:setQuerySort('kundenr,kontakt_dato;DESC').
  oBrwNPKUNDEOPPF:setNoResizeY().

  otbNPKUNDEOPPF = NEW JBoxToolbar(tbNPKUNDEOPPF:HANDLE).

  oBrwNPKUNDEOPPF:TOOLBAR-OBJECT = otbNPKUNDEOPPF.
  oFmNPKUNDEOPPF = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNPKUNDEOPPF:updateFields = 'kontakt_dato,kontaktet_av,neste_kontakt,neste_kontakt_av,aktivitet,iflg_avtale,kontaktet_pr,haster,bes_returnert,deres_ref,mini_brev,nor_firma,oppf_ok,rapport,svar_imotesees,takk_for_laanet,til_godkjennelse,til_orientering,vennligst_ring'. /*,,,,'.*/
  
  oFmNPKUNDEOPPF:BROWSE-OBJECT = oBrwNPKUNDEOPPF.
  assign 
    kontaktet_av:DELIMITER = '|'
    kontaktet_av:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid('NPKontakt;Kontaktperson;kontaktperson','where true')
    kontaktet_pr:DELIMITER = '|'
    kontaktet_pr:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid('JBoxGenCode;cCodeValue;cCodeValue','where cCodeType = "DropListKontaktForm"')
    neste_kontakt:DELIMITER = '|'
    neste_kontakt:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid('NPKontakt;Kontaktperson;kontaktperson','where true')
    neste_kontakt_av:DELIMITER = '|'
    neste_kontakt_av:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid('NPKontakt;Kontaktperson;kontaktperson','where true')
    aktivitet:DELIMITER = '|'
    aktivitet:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid('JBoxGenCode;cCodeValue;cCodeValue','where cCodeType = "DropListAktivitet"')
    nor_firma:DELIMITER = '|'
    nor_firma:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid('JBoxGenCode;cCodeValue;cCodeValue','where cCodeType = "DropListFirma"')
    .
    oKontaktdato = NEW JBoxDevExDateEdit(THIS-PROCEDURE,kontakt_dato:HANDLE).
    oKontaktdato:RegisterWithJukeBox(YES).
    
END.
oBrwNPKUNDEOPPF:OpenQuery().


oContainer:setNoResizeY('rapport').
oContainer:initResize(450,830).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MinibrevRecord C-Win 
PROCEDURE MinibrevRecord :
MESSAGE 'åpner editor for minibrev.... KOMMER...'
VIEW-AS ALERT-BOX.

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

