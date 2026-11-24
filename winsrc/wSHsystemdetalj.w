&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS C-Win 
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
def var tmpUpdateFields as char no-undo.
def var updateFields as char no-undo.

def var oNorcalc as class oo.NorcalcData no-undo.
def var oToolbox as class oo.Toolbox no-undo.
DEF VAR oFmNPSHSYST AS JBoxFieldMap NO-UNDO.
DEF VAR otbNPSHSYST AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 22/02/24 -  5:21 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */


/*** Start instance property definitions for JBoxBrowse object oBrwNPSHSYST ***/
DEF VAR oBrwNPSHSYST AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHSYST
    FIELD anleggsnr AS integer
    FIELD systemnr AS integer
    FIELD beregnet_anvendelse AS character
    FIELD anlegg AS character
    FIELD koblings_alternativ AS character
    FIELD systembetegnelse AS character
    FIELD anvendelse AS character
    FIELD prim_konst_var AS character
    FIELD sek_konst_var AS character
    FIELD reguleringsventil AS character
    FIELD ventil_type3 AS character
    FIELD prim_effekt AS integer
    FIELD prim_kapasitet AS decimal
    FIELD prim_temp_inn AS decimal
    FIELD prim_temp_ut AS decimal
    FIELD sek_effekt AS integer
    FIELD sek_kapasitet AS decimal
    FIELD sek_temp_inn AS decimal
    FIELD sek_temp_ut AS decimal
    FIELD type AS character
    FIELD ventil_type AS character
    FIELD ms_ventiltype AS character
    FIELD ms_shuntventil_i_leveranse AS logical
    FIELD shunt_dimmensjon AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowIdent3 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2 RowIdent3
    .
DEF BUFFER v_NPSHSYST FOR TEMP-TABLE NPSHSYST.


FUNCTION getBuffersAndFieldsBrwNPSHSYST RETURNS CHARACTER():
  RETURN
    'NPSHSYST'
     + ';anleggsnr'
     + ';systemnr'
     + ';beregnet_anvendelse'
     + ';koblings_alternativ'
     + ';systembetegnelse'
     + ';prim_effekt'
     + ';prim_kapasitet'
     + ';prim_temp_inn'
     + ';prim_temp_ut'
     + ';sek_effekt'
     + ';sek_kapasitet'
     + ';sek_temp_inn'
     + ';sek_temp_ut'
     + ';type'
     + ';ventil_type'
     + ';ms_ventiltype'
     + ';ms_shuntventil_i_leveranse'
     + ';shunt_dimmensjon'
  + ',NPSHANLG'
     + ';anlegg'
  + ',NPSHKOBL'
     + ';anvendelse'
     + ';prim_konst_var'
     + ';sek_konst_var'
     + ';reguleringsventil'
     + ';ventil_type'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHSYST RETURNS CHARACTER():
  RETURN 'FIRST NPSHANLG OF NPSHSYST NO-LOCK,EACH NPSHKOBL  WHERE NPSHKOBL.koblingsalternativ = NPSHSYST.koblings_alternativ NO-LOCK'.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHSYST

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHSYST

/* Definitions for BROWSE BrwNPSHSYST                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHSYST NPSHSYST.anleggsnr ~
NPSHSYST.systemnr NPSHSYST.beregnet_anvendelse NPSHSYST.anlegg ~
NPSHSYST.koblings_alternativ NPSHSYST.systembetegnelse NPSHSYST.anvendelse ~
NPSHSYST.prim_konst_var NPSHSYST.sek_konst_var NPSHSYST.reguleringsventil ~
NPSHSYST.ventil_type3 NPSHSYST.prim_effekt NPSHSYST.prim_kapasitet ~
NPSHSYST.prim_temp_inn NPSHSYST.prim_temp_ut NPSHSYST.sek_effekt ~
NPSHSYST.sek_kapasitet NPSHSYST.sek_temp_inn NPSHSYST.sek_temp_ut ~
NPSHSYST.type NPSHSYST.ventil_type NPSHSYST.ms_ventiltype ~
NPSHSYST.ms_shuntventil_i_leveranse NPSHSYST.shunt_dimmensjon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHSYST NPSHSYST.anleggsnr 
&Scoped-define QUERY-STRING-BrwNPSHSYST FOR EACH NPSHSYST NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHSYST OPEN QUERY BrwNPSHSYST FOR EACH NPSHSYST NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHSYST NPSHSYST
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHSYST NPSHSYST


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSHSYST shunttegning rectPrim ~
new_tbNPSHSYST edit_tbNPSHSYST copy_tbNPSHSYST undo_tbNPSHSYST ~
save_tbNPSHSYST delete_tbNPSHSYST refresh_tbNPSHSYST filter_tbNPSHSYST ~
browseconfig_tbNPSHSYST excel_tbNPSHSYST BrwNPSHSYST anleggsnr systemnr ~
systembetegnelse koblings_alternativ beregnet_anvendelse prim_effekt ~
sek_effekt prim_temp_inn sek_temp_inn prim_temp_ut sek_temp_ut ~
prim_kapasitet sek_kapasitet BtnReset type ms_ventiltype ~
ms_shuntventil_i_leveranse btnshunt_dimmensjon lblType 
&Scoped-Define DISPLAYED-OBJECTS anleggsnr systemnr systembetegnelse ~
koblings_alternativ anvendelse prim_konst_var FILL-IN_reguleringsventil ~
sek_konst_var ventil_type beregnet_anvendelse prim_effekt sek_effekt ~
prim_temp_inn sek_temp_inn prim_temp_ut sek_temp_ut prim_kapasitet ~
sek_kapasitet ms_ventiltype ms_shuntventil_i_leveranse shunt_dimmensjon ~
anlegg lblType 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPSHSYST 
     IMAGE-UP FILE "bmp/table.bmp":U
     LABEL "Column setup" 
     SIZE 7.75 BY 1.94 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON BtnReset 
     LABEL "Reset" 
     SIZE 7 BY 1.13.

DEFINE BUTTON btnshunt_dimmensjon 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON copy_tbNPSHSYST 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 7.75 BY 1.94 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbNPSHSYST 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 7.75 BY 1.94 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON edit_tbNPSHSYST 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 7.75 BY 1.94 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbNPSHSYST 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 7.75 BY 1.94 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNPSHSYST 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 7.75 BY 1.94 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNPSHSYST 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 7.75 BY 1.94 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON refresh_tbNPSHSYST 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 7.75 BY 1.94 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNPSHSYST 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 7.75 BY 1.94 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbNPSHSYST 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 7.75 BY 1.94 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE koblings_alternativ AS CHARACTER FORMAT "x(50)" INITIAL "1" 
     LABEL "Kobl.alt." 
     VIEW-AS COMBO-BOX INNER-LINES 8
     LIST-ITEM-PAIRS "1","1"
     DROP-DOWN-LIST
     SIZE 41 BY 1.

DEFINE VARIABLE ms_ventiltype AS CHARACTER FORMAT "X(256)":U 
     LABEL "MS-Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "item1","item1"
     DROP-DOWN-LIST
     SIZE 49 BY 1
     FONT 2 NO-UNDO.

DEFINE VARIABLE anlegg AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 47 BY 1 NO-UNDO.

DEFINE VARIABLE anleggsnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Anleggsnr" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1.

DEFINE VARIABLE anvendelse AS CHARACTER FORMAT "X(15)" INITIAL "Varme/Kjøle" 
     LABEL "Anvendelse" 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1.

DEFINE VARIABLE FILL-IN_reguleringsventil AS CHARACTER FORMAT "X(20)" INITIAL "Sekundærkrets" 
     LABEL "Reguleringsventil i" 
     VIEW-AS FILL-IN 
     SIZE 31 BY 1.

DEFINE VARIABLE lblType AS CHARACTER FORMAT "X(256)":U INITIAL "Type:" 
      VIEW-AS TEXT 
     SIZE 6 BY .63 NO-UNDO.

DEFINE VARIABLE prim_effekt AS INTEGER FORMAT "->>>>>>9":U INITIAL 0 
     LABEL "Effekt" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE prim_kapasitet AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Kapasitet" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE prim_konst_var AS CHARACTER FORMAT "X(15)" INITIAL "Konstant" 
     LABEL "Primærside" 
     VIEW-AS FILL-IN 
     SIZE 22.63 BY 1.

DEFINE VARIABLE prim_temp_inn AS DECIMAL FORMAT "->>9.9<":U INITIAL 0 
     LABEL "Temp. inn" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE prim_temp_ut AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "Temp. ut" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE sek_effekt AS INTEGER FORMAT "->>>>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE sek_kapasitet AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE sek_konst_var AS CHARACTER FORMAT "X(15)" INITIAL "Konstant" 
     LABEL "Sekundærside" 
     VIEW-AS FILL-IN 
     SIZE 22.63 BY 1.

DEFINE VARIABLE sek_temp_inn AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE sek_temp_ut AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE shunt_dimmensjon AS CHARACTER FORMAT "X(3)" 
     LABEL "Shuntdimmensjon" 
     VIEW-AS FILL-IN 
     SIZE 7.63 BY 1.

DEFINE VARIABLE systembetegnelse AS CHARACTER FORMAT "X(100)":U 
     LABEL "Systembetegnelse" 
     VIEW-AS FILL-IN 
     SIZE 53 BY 1 NO-UNDO.

DEFINE VARIABLE systemnr AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "Systemnr" 
     VIEW-AS FILL-IN 
     SIZE 9 BY 1.

DEFINE VARIABLE ventil_type AS CHARACTER FORMAT "X(10)" INITIAL "To-Veis" 
     LABEL "Ventiltype" 
     VIEW-AS FILL-IN 
     SIZE 39.75 BY 1.

DEFINE IMAGE shunttegning
     FILENAME "adeicon/blank":U
     SIZE 35.38 BY 12.75.

DEFINE VARIABLE beregnet_anvendelse AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Item 1", "1"
     SIZE 23 BY 6.25 NO-UNDO.

DEFINE VARIABLE type AS CHARACTER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "item1", "item1"
     SIZE 20 BY .94.

DEFINE RECTANGLE rectPrim
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52 BY 7.

DEFINE RECTANGLE tbNPSHSYST
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 181.63 BY 2.13.

DEFINE VARIABLE ms_shuntventil_i_leveranse AS LOGICAL INITIAL no 
     LABEL "MS - Shuntventil med i leveranse" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .75.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHSYST FOR 
      NPSHSYST SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHSYST
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHSYST C-Win _STRUCTURED
  QUERY BrwNPSHSYST NO-LOCK DISPLAY
      NPSHSYST.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSHSYST.systemnr COLUMN-LABEL "Systemnr" FORMAT ">>>>>9":U
      NPSHSYST.beregnet_anvendelse COLUMN-LABEL "Anvendelse" FORMAT "X(18)":U
      NPSHSYST.anlegg COLUMN-LABEL "Anlegg" FORMAT "X(45)":U
      NPSHSYST.koblings_alternativ COLUMN-LABEL "Kobl.alt." FORMAT "X(2)":U
      NPSHSYST.systembetegnelse COLUMN-LABEL "Syst.bet." FORMAT "X(40)":U
      NPSHSYST.anvendelse COLUMN-LABEL "Anvendelse" FORMAT "X(15)":U
      NPSHSYST.prim_konst_var COLUMN-LABEL "prim_konst_var" FORMAT "X(15)":U
      NPSHSYST.sek_konst_var COLUMN-LABEL "sek_konst_var" FORMAT "X(15)":U
      NPSHSYST.reguleringsventil COLUMN-LABEL "Reg. ventil" FORMAT "X(20)":U
      NPSHSYST.ventil_type3 COLUMN-LABEL "Ventil type" FORMAT "X(10)":U
      NPSHSYST.prim_effekt COLUMN-LABEL "Effekt" FORMAT ">>>>>>9":U
      NPSHSYST.prim_kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSHSYST.prim_temp_inn COLUMN-LABEL "Temp. inn" FORMAT "->>9.99":U
      NPSHSYST.prim_temp_ut COLUMN-LABEL "Temp. ut" FORMAT "->>9.99":U
      NPSHSYST.sek_effekt COLUMN-LABEL "Effekt" FORMAT ">>>>>>9":U
      NPSHSYST.sek_kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSHSYST.sek_temp_inn COLUMN-LABEL "Temp. inn" FORMAT "->>9.99":U
      NPSHSYST.sek_temp_ut COLUMN-LABEL "Temp. ut" FORMAT "->>9.99":U
      NPSHSYST.type COLUMN-LABEL "Type" FORMAT "X(2)":U
      NPSHSYST.ventil_type COLUMN-LABEL "Ventil type" FORMAT "X(8)":U
      NPSHSYST.ms_ventiltype COLUMN-LABEL "Ventiltype" FORMAT "X(20)":U
      NPSHSYST.ms_shuntventil_i_leveranse COLUMN-LABEL "Shuntventil med" FORMAT "ja/nei":U
      NPSHSYST.shunt_dimmensjon COLUMN-LABEL "Shunt-dimm." FORMAT "X(3)":U
  ENABLE
      NPSHSYST.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 66 BY 26.25 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNPSHSYST AT ROW 1.09 COL 2.13 WIDGET-ID 10
     edit_tbNPSHSYST AT ROW 1.09 COL 10 WIDGET-ID 12
     copy_tbNPSHSYST AT ROW 1.09 COL 17.88 WIDGET-ID 14
     undo_tbNPSHSYST AT ROW 1.09 COL 25.75 WIDGET-ID 16
     save_tbNPSHSYST AT ROW 1.09 COL 33.75 WIDGET-ID 18
     delete_tbNPSHSYST AT ROW 1.09 COL 41.63 WIDGET-ID 20
     refresh_tbNPSHSYST AT ROW 1.09 COL 49.5 WIDGET-ID 22
     filter_tbNPSHSYST AT ROW 1.09 COL 57.38 WIDGET-ID 24
     browseconfig_tbNPSHSYST AT ROW 1.09 COL 65.25 WIDGET-ID 26
     excel_tbNPSHSYST AT ROW 1.09 COL 73.25 WIDGET-ID 28
     BrwNPSHSYST AT ROW 3.75 COL 2 WIDGET-ID 200
     anleggsnr AT ROW 5 COL 90 COLON-ALIGNED
     systemnr AT ROW 6 COL 90 COLON-ALIGNED
     systembetegnelse AT ROW 6 COL 118 COLON-ALIGNED
     koblings_alternativ AT ROW 7.19 COL 90 COLON-ALIGNED WIDGET-ID 36
     anvendelse AT ROW 8.25 COL 91 COLON-ALIGNED
     prim_konst_var AT ROW 8.5 COL 148 COLON-ALIGNED
     FILL-IN_reguleringsventil AT ROW 9.38 COL 91 COLON-ALIGNED
     sek_konst_var AT ROW 9.5 COL 148 COLON-ALIGNED
     ventil_type AT ROW 10.5 COL 91 COLON-ALIGNED
     beregnet_anvendelse AT ROW 13 COL 124 NO-LABEL WIDGET-ID 32
     prim_effekt AT ROW 13.25 COL 78 COLON-ALIGNED
     sek_effekt AT ROW 13.25 COL 93.38 COLON-ALIGNED NO-LABEL
     prim_temp_inn AT ROW 14.38 COL 78 COLON-ALIGNED
     sek_temp_inn AT ROW 14.38 COL 93.38 COLON-ALIGNED NO-LABEL
     prim_temp_ut AT ROW 15.5 COL 78 COLON-ALIGNED
     sek_temp_ut AT ROW 15.5 COL 93.38 COLON-ALIGNED NO-LABEL
     prim_kapasitet AT ROW 16.75 COL 78 COLON-ALIGNED
     sek_kapasitet AT ROW 16.75 COL 93.38 COLON-ALIGNED NO-LABEL
     BtnReset AT ROW 18 COL 102 WIDGET-ID 66
     type AT ROW 19.75 COL 86 NO-LABEL WIDGET-ID 76
     ms_ventiltype AT ROW 21 COL 84 COLON-ALIGNED WIDGET-ID 84
     ms_shuntventil_i_leveranse AT ROW 21.88 COL 86 WIDGET-ID 74
     shunt_dimmensjon AT ROW 22.75 COL 84 COLON-ALIGNED
     btnshunt_dimmensjon AT ROW 22.75 COL 93.63 WIDGET-ID 86 NO-TAB-STOP 
     anlegg AT ROW 5 COL 99 COLON-ALIGNED NO-LABEL
     lblType AT ROW 19.75 COL 76.63 COLON-ALIGNED NO-LABEL
     "W" VIEW-AS TEXT
          SIZE 3 BY .63 AT ROW 13.31 COL 111 WIDGET-ID 56
          FONT 6
     "l / s" VIEW-AS TEXT
          SIZE 5 BY .63 AT ROW 17 COL 111 WIDGET-ID 64
          FONT 6
     "°C" VIEW-AS TEXT
          SIZE 3 BY .63 AT ROW 14.5 COL 111 WIDGET-ID 60
          FONT 6
     "Sekundær" VIEW-AS TEXT
          SIZE 12 BY .63 AT ROW 12.5 COL 96.38 WIDGET-ID 54
          FONT 5
     "w" VIEW-AS TEXT
          SIZE 3 BY .63 AT ROW 13.31 COL 111 WIDGET-ID 58
          FONT 6
     "Primær" VIEW-AS TEXT
          SIZE 8 BY .63 AT ROW 12.5 COL 82 WIDGET-ID 52
          FONT 5
     "°C" VIEW-AS TEXT
          SIZE 3 BY .63 AT ROW 15.75 COL 111 WIDGET-ID 62
          FONT 6
     tbNPSHSYST AT ROW 1 COL 2 WIDGET-ID 8
     shunttegning AT ROW 13 COL 148 WIDGET-ID 34
     rectPrim AT ROW 12.25 COL 69 WIDGET-ID 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 183.75 BY 29.72 WIDGET-ID 100.


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
         HEIGHT             = 29.72
         WIDTH              = 183.75
         MAX-HEIGHT         = 29.72
         MAX-WIDTH          = 183.75
         VIRTUAL-HEIGHT     = 29.72
         VIRTUAL-WIDTH      = 183.75
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
/* BROWSE-TAB BrwNPSHSYST excel_tbNPSHSYST DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 29.72
       FRAME DEFAULT-FRAME:WIDTH            = 183.75.

/* SETTINGS FOR FILL-IN anlegg IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       anlegg:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FILL-IN anvendelse IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN_reguleringsventil IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       lblType:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE
       lblType:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "Type:".

/* SETTINGS FOR FILL-IN prim_konst_var IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN sek_konst_var IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN shunt_dimmensjon IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       tbNPSHSYST:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,copy;Kopier,undo;Angre,save;Lagre,delete;Slett,refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Eksporter til E&xcelmaxborder".

/* SETTINGS FOR RADIO-SET type IN FRAME DEFAULT-FRAME
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN ventil_type IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHSYST
/* Query rebuild information for BROWSE BrwNPSHSYST
     _TblList          = "norcalc.NPSHSYST"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST,"
     _FldNameList[1]   > "_<CALC>"
"NPSHSYST.anleggsnr" "Anleggsnr" ">>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHSYST.systemnr" "Systemnr" ">>>>>9" "integer" ? ? ? ? ? ? no "" no no "8.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHSYST.beregnet_anvendelse" "Anvendelse" "X(18)" "character" ? ? ? ? ? ? no "Velg anvendelsesområde" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHSYST.anlegg" "Anlegg" "X(45)" "character" ? ? ? ? ? ? no "Anleggets navn (oppdragssted)" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHSYST.koblings_alternativ" "Kobl.alt." "X(2)" "character" ? ? ? ? ? ? no "" no no "7" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHSYST.systembetegnelse" "Syst.bet." "X(40)" "character" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > "_<CALC>"
"NPSHSYST.anvendelse" "Anvendelse" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > "_<CALC>"
"NPSHSYST.prim_konst_var" "prim_konst_var" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > "_<CALC>"
"NPSHSYST.sek_konst_var" "sek_konst_var" "X(15)" "character" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > "_<CALC>"
"NPSHSYST.reguleringsventil" "Reg. ventil" "X(20)" "character" ? ? ? ? ? ? no "Reguleringsvetil skal stå i" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > "_<CALC>"
"NPSHSYST.ventil_type3" "Ventil type" "X(10)" "character" ? ? ? ? ? ? no "Velg ventiltype" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > "_<CALC>"
"NPSHSYST.prim_effekt" "Effekt" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "7.88" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > "_<CALC>"
"NPSHSYST.prim_kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > "_<CALC>"
"NPSHSYST.prim_temp_inn" "Temp. inn" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > "_<CALC>"
"NPSHSYST.prim_temp_ut" "Temp. ut" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > "_<CALC>"
"NPSHSYST.sek_effekt" "Effekt" ">>>>>>9" "integer" ? ? ? ? ? ? no "" no no "7.88" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > "_<CALC>"
"NPSHSYST.sek_kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.38" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > "_<CALC>"
"NPSHSYST.sek_temp_inn" "Temp. inn" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.63" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > "_<CALC>"
"NPSHSYST.sek_temp_ut" "Temp. ut" "->>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > "_<CALC>"
"NPSHSYST.type" "Type" "X(2)" "character" ? ? ? ? ? ? no "" no no "4.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > "_<CALC>"
"NPSHSYST.ventil_type" "Ventil type" "X(8)" "character" ? ? ? ? ? ? no "Velg ventiltype" no no "9.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > "_<CALC>"
"NPSHSYST.ms_ventiltype" "Ventiltype" "X(20)" "character" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > "_<CALC>"
"NPSHSYST.ms_shuntventil_i_leveranse" "Shuntventil med" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "14.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > "_<CALC>"
"NPSHSYST.shunt_dimmensjon" "Shunt-dimm." "X(3)" "character" ? ? ? ? ? ? no "" no no "11.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHSYST */
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


&Scoped-define SELF-NAME BtnReset
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnReset C-Win
ON CHOOSE OF BtnReset IN FRAME DEFAULT-FRAME /* Reset */
DO:
  run Resetvalues.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnshunt_dimmensjon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnshunt_dimmensjon C-Win
ON CHOOSE OF btnshunt_dimmensjon IN FRAME DEFAULT-FRAME /* ... */
DO:
  def var iGruppeTypeId as int no-undo.

  if JBoxServerAPI:Instance:Find('NPSHGruppeType','where NPSHGruppeTypeNavn = ' + quoter(type:screen-value)) then 
    iGruppeTypeId = JBoxServerAPI:Instance:IntValue('iNPSHGruppeTypeId').

  JBoxServerAPI:Instance:Lookup("NPSHGruppe"
                   + ';storrelse'
                   + ';nedre'
                   + ';ovre'
                   + ';grunnlag'
                   + ';iNPSHGruppeTypeId'
                + ',NPSHGruppeType'
                   + ';NPSHGruppeTypeNavn'
                   ,subst("where iNPSHGruppeTypeId = &1, FIRST NPSHGruppeType WHERE NPSHGruppeType.iNPSHGruppeTypeId = npshGruppe.iNPSHGruppeTypeId",iGruppeTypeId)
                   ,"storrelse,nedre,ovre,grunnlag"   /* <- return values for these fields */
                    ).

  IF JBoxServerAPI:Instance:LookupOk THEN DO:
    ASSIGN shunt_dimmensjon:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("npshgruppe.storrelse")
           .

    APPLY "any-printable" TO shunt_dimmensjon.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME type
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL type C-Win
ON LEAVE OF type IN FRAME DEFAULT-FRAME
DO:
  def var hChild as handle no-undo.
  def var oNorcalcData as oo.norcalcdata no-undo.
  
  do with frame {&frame-name}:
      DEFINE VAR c_kapasitet as int no-undo.
      DEFINE VAR c_grunnlag AS CHARACTER.
  
      IF prim_kapasitet:INPUT-VALUE = 0 AND sek_kapasitet:INPUT-VALUE = 0 THEN DO:
        MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'
          view-as alert-box.
        APPLY "ENTRY" TO sek_effekt.
        RETURN NO-APPLY.
      END.
      
      if can-do('5,6,7',koblings_alternativ:screen-value) then 
        assign 
          c_kapasitet = sek_kapasitet:input-value
          c_grunnlag = 'Sekundærkrets'
          .
      else
        assign
          c_kapasitet = prim_kapasitet:input-value
          c_grunnlag = 'Primærkrets'
          .

      RUN velgNPSHGruppe.w persistent set hChild.
      if valid-handle(hChild) then do:
        run initializeObject in hChild.
        run setValues in hChild(type:screen-value,c_kapasitet,c_grunnlag).
        run MoveToTop in hChild.
      end.             
  
  END.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHSYST
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeregnSek C-Win 
PROCEDURE BeregnSek :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
    DEFINE VAR teller AS DECIMAL.
    DEFINE VAR nevner AS DECIMAL.
    DEFINE VAR register AS DECIMAL.

    DO WITH FRAME NYTT-SYSTEM:
        IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) > 0 
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) <>  0
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  <>  0 THEN
           /* Kapasitet er ikke kjent */
           /* FORMEL: KAPASITET = (A * 0.86) / (B - C) /  3600  */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  * 0.86.
                nevner = DECIMAL(sek_temp_inn:SCREEN-VALUE)  - DECIMAL(sek_temp_ut:SCREEN-VALUE).
                ASSIGN NPSHSYST.sek_kapasitet = ABSOLUTE((teller  /  nevner)  /  3600).
                IF NPSHSYST.sek_kapasitet = ? THEN
                    ASSIGN NPSHSYST.sek_kapasitet = 0.
                DISPLAY  NPSHSYST.sek_kapasitet.
                ASSIGN  NPSHSYST.prim_kapasitet = NPSHSYST.sek_kapasitet.
                DISPLAY  NPSHSYST.prim_kapasitet.
            END.
        ELSE  IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) = 0
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) <>  0
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  <>  0
            AND DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Effekt er ikke kjent */
           /* Formel: EFFEKT = (D*  3600) * (B - C) / 0.86 */
            DO:
              teller = (DECIMAL(sek_kapasitet:SCREEN-VALUE)  * 3600) *
                    (DECIMAL(sek_temp_inn:SCREEN-VALUE)  - 
                    DECIMAL(sek_temp_ut:SCREEN-VALUE)).
                nevner = 0.86.
                ASSIGN NPSHSYST.sek_effekt = ABSOLUTE((teller  /  nevner)).
                IF NPSHSYST.sek_effekt = ? THEN
                    ASSIGN NPSHSYST.sek_effekt = 0.
                DISPLAY  NPSHSYST.sek_effekt.
                ASSIGN  NPSHSYST.prim_effekt = NPSHSYST.sek_effekt.
                DISPLAY  NPSHSYST.prim_effekt.
            END.
        ELSE  IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) > 0
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) = 0 
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  >  0
            AND DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Temperatur inn er ikke kjent */
            /* FORMEL: TEMPERATUR INN = C + (A * 0.86) / (D* 3600) */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  *   0.86.
                nevner =  DECIMAL(sek_kapasitet:SCREEN-VALUE)   * 3600. 
                ASSIGN NPSHSYST.sek_temp_inn =  
                    DECIMAL(sek_temp_ut:SCREEN-VALUE) + (teller  /  nevner).
                IF NPSHSYST.sek_temp_inn = ? THEN
                    ASSIGN NPSHSYST.sek_temp_inn = 0.
                DISPLAY  NPSHSYST.sek_temp_inn.
                ASSIGN  NPSHSYST.prim_temp_inn = NPSHSYST.sek_temp_inn.
                DISPLAY  NPSHSYST.prim_temp_inn.
            END.                      
        ELSE  IF INTEGER(NPSHSYST.sek_effekt:SCREEN-VALUE) > 0
            AND DECIMAL(NPSHSYST.sek_temp_inn:SCREEN-VALUE) > 0 
            AND DECIMAL(NPSHSYST.sek_temp_ut:SCREEN-VALUE)  =  0
            AND DECIMAL(NPSHSYST.sek_kapasitet:SCREEN-VALUE) > 0 THEN
            /* Temperatur ut er ikke kjent */
            /* FORMEL: TEMPERATUR UT = B - (A * 0.86) / (D* 3600) */
            DO:
                teller = DECIMAL(sek_effekt:SCREEN-VALUE)  *   0.86.
                nevner =  DECIMAL(sek_kapasitet:SCREEN-VALUE)   * 3600. 
                ASSIGN NPSHSYST.sek_temp_ut =  
                    DECIMAL(sek_temp_inn:SCREEN-VALUE) - (teller  /  nevner).
                IF NPSHSYST.sek_temp_ut = ? THEN
                    ASSIGN NPSHSYST.sek_temp_ut = 0.
                DISPLAY  NPSHSYST.sek_temp_ut.
                ASSIGN  NPSHSYST.prim_temp_ut = NPSHSYST.sek_temp_ut.
                DISPLAY  NPSHSYST.prim_temp_ut.
            END.                      
    END.    

------------------------------------------------------------------------------*/
  do with frame {&Frame-name}:
    /*KAPASITET*/
    if sek_effekt:input-value > 0 and sek_temp_inn:input-value > 0 and sek_temp_ut:INPUT-VALUE > 0 then do:
      assign 
        sek_kapasitet:screen-value  = string(oNorcalc:beregnSekKapasitet(sek_effekt:handle,sek_temp_inn:handle, sek_temp_ut:handle, sek_kapasitet:handle))
        prim_kapasitet:screen-value = sek_kapasitet:screen-value
        .
    end.
    /*EFFEKT*/ 
    else if sek_effekt:input-value = 0 and sek_temp_inn:input-value > 0 and sek_temp_ut:INPUT-VALUE > 0 and sek_kapasitet:input-value > 0 then do:
      assign 
        sek_effekt:screen-value  = string(oNorcalc:beregnSekKapasitet(sek_effekt:handle,sek_temp_inn:handle, sek_temp_ut:handle, sek_kapasitet:handle))
        prim_effekt:screen-value = sek_effekt:screen-value
        .
    end.
    /*TEMP INN*/
    else if sek_effekt:input-value > 0 and sek_temp_inn:input-value = 0 and sek_temp_ut:INPUT-VALUE > 0 and sek_kapasitet:input-value > 0 then do:
      assign 
        sek_temp_inn:screen-value  = string(oNorcalc:beregnSekKapasitet(sek_effekt:handle,sek_temp_inn:handle, sek_temp_ut:handle, sek_kapasitet:handle))
        prim_temp_inn:screen-value = sek_temp_inn:screen-value
        .
    end.
    /*TEMP UT*/
    else if sek_effekt:input-value > 0 and sek_temp_inn:input-value > 0 and sek_temp_ut:INPUT-VALUE = 0 and sek_kapasitet:input-value > 0 then do: 
      assign 
        sek_temp_ut:screen-value  = string(oNorcalc:beregnSekKapasitet(sek_effekt:handle,sek_temp_inn:handle, sek_temp_ut:handle, sek_kapasitet:handle))
        prim_temp_ut:screen-value = sek_temp_ut:screen-value
        .
    end.
    else do:
    end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteRecord C-Win 
PROCEDURE DeleteRecord :
DO WITH FRAME {&FRAME-NAME}:
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
IF oBrwNPSHSYST:IsCurrent THEN DO WITH FRAME {&FRAME-NAME}:
    oFmNPSHSYST:setSensitiveFields('').    
end.
  RUN SUPER.
  IF oBrwNPSHSYST:isCurrent THEN  DO WITH FRAME {&FRAME-NAME}:
    if avail NPSHSYST then do:
      assign 
        ms_ventiltype:hidden              = not type:screen-value begins 'MS'
        ms_shuntventil_i_leveranse:hidden = not type:screen-value begins 'MS'
        .
    end.
  END.

  if avail NPSHSYST and NPSHSYST.koblings_alternativ <> '' then 
    run showKobling(input koblings_alternativ:screen-value).
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
DO WITH FRAME {&FRAME-NAME}:
    if can-do('1,2,3,4,7a',koblings_alternativ:screen-value) then 
      oToolbox:buildList('Koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,type,beregnet_anvendelse',',').
    else if can-do('5,7',koblings_alternativ:screen-value) then   
      oToolbox:buildList('Koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,prim_temp_inn,type,beregnet_anvendelse',',').
    else if can-do('6',koblings_alternativ:screen-value) then 
      oToolbox:buildList('Koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,beregnet_anvendelse',',').
    
    tmpUpdateFields = oToolbox:getListByName('koblingsalternativ').       
    
    if type:screen-value = 'MS' then 
      tmpUpdateFields + ',ms_ventiltype,ms_shuntventil_i_leveranse'.
    
    oFmNPSHSYST:setSensitiveFields(tmpUpdateFields).
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
  END.

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
  DISPLAY anleggsnr systemnr systembetegnelse koblings_alternativ anvendelse 
          prim_konst_var FILL-IN_reguleringsventil sek_konst_var ventil_type 
          beregnet_anvendelse prim_effekt sek_effekt prim_temp_inn sek_temp_inn 
          prim_temp_ut sek_temp_ut prim_kapasitet sek_kapasitet ms_ventiltype 
          ms_shuntventil_i_leveranse shunt_dimmensjon anlegg lblType 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNPSHSYST shunttegning rectPrim new_tbNPSHSYST edit_tbNPSHSYST 
         copy_tbNPSHSYST undo_tbNPSHSYST save_tbNPSHSYST delete_tbNPSHSYST 
         refresh_tbNPSHSYST filter_tbNPSHSYST browseconfig_tbNPSHSYST 
         excel_tbNPSHSYST BrwNPSHSYST anleggsnr systemnr systembetegnelse 
         koblings_alternativ beregnet_anvendelse prim_effekt sek_effekt 
         prim_temp_inn sek_temp_inn prim_temp_ut sek_temp_ut prim_kapasitet 
         sek_kapasitet BtnReset type ms_ventiltype ms_shuntventil_i_leveranse 
         btnshunt_dimmensjon lblType 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EntryOfWidget C-Win 
PROCEDURE EntryOfWidget :
DO WITH FRAME {&FRAME-NAME}:
  END.
//  RUN SUPER.
  IF oFmNPSHSYST:isCurrent THEN DO WITH FRAME {&FRAME-NAME}:
    CASE oFmNPSHSYST:currentField:
      WHEN "prim_effekt" THEN DO:
        
      END.
      WHEN "sek_effekt" THEN DO:

      END.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getContainer C-Win 
PROCEDURE getContainer :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def output param oopContainer as JBoxContainer no-undo.

oopContainer = oContainer.

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
def var radioListAnvendelse as char no-undo.
def var radiolistType as char no-undo.
def var ix as int no-undo.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
  oToolbox = new oo.Toolbox().
  oNorcalc = new oo.NorcalcData().
  JBoxSession:Instance:CompanyId = 1.

  oBrwNPSHSYST = NEW JBoxBrowse(brwNPSHSYST:HANDLE).

  oFmNPSHSYST = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  updateFields = 'systembetegnelse,koblings_alternativ,beregnet_anvendelse' 
                 + ',prim_effekt,sek_effekt,prim_temp_inn,sek_temp_inn,prim_temp_ut,sek_temp_ut,prim_kapasitet,sek_kapasitet,btnReset'
                 + ',type,ms_ventiltype,shunt_dimmensjon,ms_shuntventil_i_leveranse'
                 .
  oFmNPSHSYST:updateFields = updateFields
                           . 
  //oFmNPSHSYST:primaryKeyFields = 'anleggsnr,systemnr'.
  oFmNPSHSYST:DisplayFields = 'anleggsnr,systemnr,anlegg,anvendelse,prim_konst_var,sek_konst_var,ventil_type'.
  
  oFmNPSHSYST:BROWSE-OBJECT = oBrwNPSHSYST.

  otbNPSHSYST = NEW JBoxToolbar(tbNPSHSYST:HANDLE).
  oFmNPSHSYST:TOOLBAR-OBJECT = otbNPSHSYST.
  oBrwNPSHSYST:TOOLBAR-OBJECT = otbNPSHSYST.
  
  oBrwNPSHSYST:customCreateProc    = "crt_npshsyst.p".
  oBrwNPSHSYST:customUpdateValProc = "=upd_npshsyst.p".
  oBrwNPSHSYST:customDeleteValProc = "=dlt_npshsyst.p".
  oBrwNPSHSYST:postUpdateProc      = "postupd_npshsyst.p".
  oBrwNPSHSYST:fieldNameDeleteWarning = 'SystemNr'.
  
  assign 
    beregnet_anvendelse:delimiter = '|'
    beregnet_anvendelse:RADIO-BUTTONS = jboxGenCode:Instance:getGenCodeList('DroppAnvendelse','NO','2xCodeValue')
    koblings_alternativ:delimiter = '|'
    koblings_alternativ:LIST-ITEM-PAIRS = jboxserverapi:Instance:FieldListValid('npshkobl;betegnelse|koblingsalternativ;koblingsalternativ','where true')
    TYPE:DELIMITER = '|'
    TYPE:RADIO-BUTTONS = 'FM|FM|MS|MS'
    ms_ventiltype:DELIMITER = '|'
    ms_ventiltype:LIST-ITEM-PAIRS = DYNAMIC-FUNCTION("getFieldList","npshventiltype;ventiltype|fabrikat;ventiltype","WHERE VentiltypeAktiv BY ventiltype")
    . 
END.
//oBrwNPSHSYST:OpenQuery().

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:setNoResizeX('rectPrim').
  oContainer:setNoResizeY('rectPrim').
  oContainer:initResize(600,700).
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfField C-Win 
PROCEDURE LeaveOfField :
DEF INPUT PARAM icFieldName   AS CHAR NO-UNDO.

  do with frame {&frame-name}:
    case icFieldName:
      when 'sek_effekt' then do:
        assign 
          prim_effekt:screen-value = sek_effekt:screen-value
/*          sek_effekt:screen-value  = string(oNorcalc:beregnSekEffekt(sek_effekt:handle,sek_temp_inn:handle,sek_temp_ut:handle,sek_kapasitet:handle))*/
          .
        run BeregnSek.        
      end.
      when 'prim_temp_inn' then
        assign 
          prim_kapasitet:screen-value  = string(oNorcalc:beregnSekEffekt(sek_effekt:handle,sek_temp_inn:handle,sek_temp_ut:handle,sek_kapasitet:handle))
          .        
      when 'sek_kapasitet' then do:
        run BeregnSek.
        if can-do('5,7',koblings_alternativ:screen-value) then do:  
          if sek_effekt:input-value = 0 then do:
            apply 'entry' to prim_kapasitet.
            return no-apply.
          end. 
        end.
        else 
          assign 
            prim_kapasitet:screen-value = sek_kapasitet:screen-value
            .   
      end.
      when 'sek_temp_inn' then do:
        if can-do('1,2,3,4,7A',koblings_alternativ:screen-value) then
          prim_temp_inn:screen-value = sek_temp_inn:SCREEN-VALUE. 
        else if can-do('6',koblings_alternativ:screen-value) then
          prim_temp_ut:screen-value = sek_temp_inn:screen-value.
        run BeregnSek.
      end.
      when 'sek_temp_ut' then do:
        if can-do('1,2,3,4,5,7',koblings_alternativ:screen-value) then
          prim_temp_ut:screen-value = sek_temp_ut:SCREEN-VALUE. 
        else if can-do('6',koblings_alternativ:screen-value) then
          prim_temp_inn:screen-value = sek_temp_ut:screen-value.
        run BeregnSek.
      end.  
    end case.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
/*------------------------------------------------------------------------------
  Purpose:     Retrieve lookup values when a foreign key field is modified
  Parameters:  Handle to foreign key field
  Notes:       The FieldValues method is a short version of Find
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihField AS HANDLE NO-UNDO.

IF ihField:MODIFIED THEN DO WITH FRAME {&FRAME-NAME}:
  CASE ihField:NAME:
    //WHEN "shunt_dimmensjon" THEN <field2>:SCREEN-VALUE = JBoxServerAPI:Instance:FieldValues("<table>","WHERE shunt_dimmensjon = '" + ihField:SCREEN-VALUE + "'","<field2>").
  END CASE.

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myLookupObject C-Win 
PROCEDURE myLookupObject :
DEF INPUT PARAM ioLookup AS JBoxDynLookup NO-UNDO.
  def var Kapasitet as dec format ">>9.9<" no-undo.
  def var Grunnlag as char no-undo.
  def var filter as char no-undo.
  def var iGruppeTypeId as int no-undo.

  def var filter2 as char no-undo.

  do with frame {&frame-name}:
    if JBoxServerAPI:Instance:Find('NPSHGruppeType','where NPSHGruppeTypeNavn = ' + quoter(type:screen-value)) then 
      iGruppeTypeId = JBoxServerAPI:Instance:IntValue('iNPSHGruppeTypeId').

    IF prim_kapasitet:INPUT-VALUE = 0 AND sek_kapasitet:INPUT-VALUE = 0 THEN DO:
      MESSAGE 'Shuntdimmensjon kan ikke beregnes når kapasitet er 0'
        view-as alert-box.
      APPLY "ENTRY" TO sek_effekt.
      RETURN NO-APPLY.
    END.
    
    if can-do('5,6,7',koblings_alternativ:screen-value) then 
      assign 
        Kapasitet = dec(sek_kapasitet:screen-value)
        Grunnlag = 'Sekundærkrets'
        .
    else
      assign
        Kapasitet = dec(prim_kapasitet:screen-value)
        Grunnlag = 'Primærkrets'
        .
    ioLookup:ExpandSearchDialogX(400).
    ioLookup:BROWSE-OBJECT:openQuery().
  end.
  //filter = substitute('WHERE (nedre < &1 and ovre >= &1) and grunnlag = "&2" and iNPSHGruppeTypeId = &3 ',oToolbox:coreDecimal(Kapasitet),Grunnlag,iGruppeTypeId).
  filter = substitute('WHERE (nedre < &1 and ovre >= &1) and grunnlag = &2 and iNPSHGruppeTypeId = &3 ',quoter(Kapasitet),quoter(Grunnlag),quoter(iGruppeTypeId)).
/*  filter = 'WHERE (nedre < dec("' + string(kapasitet) + '") and ovre >= dec("' + string(Kapasitet) + '")) and grunnlag = ' + quoter(grunnlag) + ' and iNPSHGruppeTypeId = ' + string(iGruppeTypeId).*/
  ioLookup:BROWSE-OBJECT:BUFFER-HANDLE:find-first(filter2) no-error.
  if error-status:error then MESSAGE 'feilet:'
                             VIEW-AS ALERT-BOX.  
  if ioLookup:BROWSE-OBJECT:BUFFER-HANDLE:avail then do:
    ioLookup:BROWSE-OBJECT:QUERY-HANDLE:reposition-to-rowid(ioLookup:BROWSE-OBJECT:BUFFER-HANDLE:rowid).
    ioLookup:BROWSE-OBJECT:displayRecord().
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
DO WITH FRAME {&FRAME-NAME}:
/*    if can-do('1,2,3,4,7a',koblings_alternativ:screen-value) then                                                                                   */
/*      oToolbox:buildList('Koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,type,beregnet_anvendelse',',').              */
/*    else if can-do('5,7',koblings_alternativ:screen-value) then                                                                                     */
/*      oToolbox:buildList('Koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,prim_temp_inn,type,beregnet_anvendelse',',').*/
/*    else if can-do('6',koblings_alternativ:screen-value) then                                                                                       */
/*      oToolbox:buildList('Koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,beregnet_anvendelse',',').                   */
/*                                                                                                                                                    */
/*    tmpUpdateFields = oToolbox:getListByName('koblingsalternativ').                                                                                 */
/*                                                                                                                                                    */
/*    if type:screen-value = 'MS' then                                                                                                                */
/*      tmpUpdateFields + ',ms_ventiltype,ms_shuntventil_i_leveranse'.                                                                                */
/*                                                                                                                                                    */
/*    oFmNPSHSYST:setSensitiveFields(tmpUpdateFields).                                                                                                */
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Resetvalues C-Win 
PROCEDURE Resetvalues :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  do with frame {&frame-name}:
    assign 
      prim_effekt:screen-value    = '0'
      sek_effekt:screen-value     = '0'
      prim_temp_inn:screen-value  = '0'
      sek_temp_inn:screen-value   = '0'
      prim_temp_ut:screen-value   = '0'
      sek_temp_ut:screen-value    = '0'
      prim_kapasitet:screen-value = '0'
      sek_kapasitet:screen-value  = '0'
     .
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
DO WITH FRAME {&FRAME-NAME}:
    /* Dersom MS-Ventil er valgt, må ventiltype velges */
    IF type:SCREEN-VALUE = 'MS' AND ventil_type:SCREEN-VALUE = "" THEN 
      undo, throw new Progress.Lang.AppError('Når MS-Ventil er valgt, må også ventiltype velges',0). 
  
    /* Dersom MS-Ventil er valgt, skjekk om NPSHMKVS har denne kombinasjonen av 
      ventiltype og shuntdommensjon */
    IF type:SCREEN-VALUE = 'MS' THEN 
      if not jboxserverapi:Instance:Find('npshmkvs',substitute('where ventiltype = "&1" and shunt_dimmensjon = "&2"',ventil_type:screen-value,shunt_dimmensjon:input-value)) then
        undo, throw new Progress.Lang.AppError(substitute('I beregningdata er det ikke definert KVS- verdi for ventiltype: &1 med dimmensjon &2',ventil_type:screen-value,shunt_dimmensjon:input-value),0).

  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDimmValue C-Win 
PROCEDURE setDimmValue :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  def input param ipDimmValue as dec no-undo.
  
  do with frame {&frame-name}:
    ASSIGN
      shunt_dimmensjon:screen-value = string(ipDimmValue)
      type:modified = true
      .    
  end.
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showKobling C-Win 
PROCEDURE showKobling :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
   ventil_type
   ,sek_konst_var
   ,reguleringsventil
   ,prim_konst_var
   ,koblingsalternativ
   ,betegnelse,anvendelse
------------------------------------------------------------------------------*/
  def input param ipKobling as char no-undo.
  def var fieldListValues as char no-undo.

  do with frame {&frame-name}:  
    fieldListValues = jboxserverapi:Instance:FieldValues('npshkobl',substitute('where koblingsalternativ = "&1"',ipKobling),'ventil_type,reguleringsventil,prim_konst_var,sek_konst_var,betegnelse,anvendelse').
    if fieldListValues = ? then 
      undo, throw new Progress.Lang.AppError(substitute('Fant ikke kobling for koblingsalternativ &1',ipKobling),0).
    assign 
      ventil_type:screen-value       = entry(1,fieldListValues,'|')
  /*    reguleringsventil:screen-value = entry(2,fieldListValues,'|')*/
      prim_konst_var:screen-value    = entry(3,fieldListValues,'|')
      sek_konst_var:screen-value     = entry(4,fieldListValues,'|')
  //    betegnelse:screen-value        = entry(5,fieldListValues,'|')
      anvendelse:screen-value        = entry(6,fieldListValues,'|')
      .
    shunttegning:STRETCH-TO-FIT = true.
    do on error undo, throw:
      SHUNTTEGNING:LOAD-IMAGE (oo.NorcalcData:Instance:getTegning(ipKobling)).
      CATCH eTegning AS Progress.Lang.Error :
        SHUNTTEGNING:LOAD-IMAGE('').    
      END CATCH.
    end.
      
  end.    
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValueChangedField C-Win 
PROCEDURE ValueChangedField :
DEF INPUT PARAM icFieldName   AS CHAR NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    CASE icFieldName:
      WHEN "koblings_alternativ" THEN do:
        if can-do('1,2,3,4,7a',koblings_alternativ:screen-value) then 
          oToolbox:buildList('koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,type,beregnet_anvendelse',',').
        else if can-do('5,7',koblings_alternativ:screen-value) then  
          oToolbox:buildList('koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,prim_temp_inn,type,beregnet_anvendelse',',').
        else if can-do('6',koblings_alternativ:screen-value) then      
          oToolbox:buildList('koblingsalternativ','koblings_alternativ,sek_effekt,sek_temp_inn,sek_temp_ut,beregnet_anvendelse',',').
        
        if type:screen-value begins 'MS' then 
          tmpUpdateFields = oToolbox:getListByName('koblingsalternativ') + ',ms_ventiltype,ms_shuntventil_i_leveranse'.
        else 
          tmpUpdateFields = oToolbox:getListByName('koblingsalternativ').
          
        oFmNPSHSYST:setSensitiveFields(tmpUpdateFields).
                        
        run showKobling(input koblings_alternativ:screen-value).
      end.
      when 'type' then do:
        /* Dersom MS-Ventil er valgt, skal MS-Ventiltype enables, hvis ikke skal det som ligger i felt slettes */
        IF type:SCREEN-VALUE begins 'MS' then do:
          tmpUpdateFields = oToolbox:getListByName('koblingsalternativ') + ',ms_ventiltype,ms_shuntventil_i_leveranse'.
          oFmNPSHSYST:setSensitiveFields(tmpUpdateFields).
          assign 
            ms_ventiltype:hidden                   = false
            ms_shuntventil_i_leveranse:hidden      = false
          .
        end.
        else 
          assign 
            ms_ventiltype:hidden                   = true
            ms_shuntventil_i_leveranse:hidden      = true
          .        

        if ms_ventiltype:hidden then do:                  
          if ms_shuntventil_i_leveranse:input-value then ms_shuntventil_i_leveranse:input-value = FALSE.
          if ms_ventiltype:INPUT-VALUE <> '' then ms_ventiltype:INPUT-VALUE = ''.
          .
        end.
      end.
    END CASE.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

