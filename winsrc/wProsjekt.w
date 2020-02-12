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

DEFINE NEW SHARED VAR prosjektIdParam as int.

/* Local Variable Definitions ---                                       */

DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR hBrowse     AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR hFieldMap   AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.
DEF VAR oreg_dato   AS JBoxDevExDateEdit NO-UNDO.
def var hbtnSP as handle no-undo.
def var hbtnSH as handle no-undo.

/*** Start instance property definitions for JBoxBrowse object oBrwNORPROSJEKT ***/
DEF VAR oBrwNORPROSJEKT AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NORPROSJEKT
    FIELD prosjektid AS integer
    FIELD prosjekt_navn AS character
    FIELD reg_dato AS date
    FIELD aktivt AS logical
    FIELD shuntgrupper AS character
    FIELD spirovent AS character
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1
    .
DEF BUFFER v_NORPROSJEKT FOR TEMP-TABLE NORPROSJEKT.


FUNCTION getBuffersAndFieldsBrwNORPROSJEKT RETURNS CHARACTER():
  RETURN
    'NORPROSJEKT'
     + ';prosjektid'
     + ';prosjekt_navn'
     + ';reg_dato'
     + ';aktivt'
     + ';shuntgrupper'
     + ';spirovent'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNORPROSJEKT RETURNS CHARACTER():
  RETURN ''.
END FUNCTION.
DEF VAR oFmNORPROSJEKT AS JBoxFieldMap NO-UNDO.
DEF VAR otbNORPROSJEKT AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNORPROSJEKT

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NORPROSJEKT

/* Definitions for BROWSE BrwNORPROSJEKT                                */
&Scoped-define FIELDS-IN-QUERY-BrwNORPROSJEKT NORPROSJEKT.prosjektid ~
NORPROSJEKT.prosjekt_navn NORPROSJEKT.reg_dato NORPROSJEKT.aktivt ~
NORPROSJEKT.shuntgrupper NORPROSJEKT.spirovent 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNORPROSJEKT ~
NORPROSJEKT.prosjektid 
&Scoped-define QUERY-STRING-BrwNORPROSJEKT FOR EACH NORPROSJEKT NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNORPROSJEKT OPEN QUERY BrwNORPROSJEKT FOR EACH NORPROSJEKT NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNORPROSJEKT NORPROSJEKT
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNORPROSJEKT NORPROSJEKT


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNORPROSJEKT new_tbNORPROSJEKT ~
edit_tbNORPROSJEKT copy_tbNORPROSJEKT save_tbNORPROSJEKT undo_tbNORPROSJEKT ~
delete_tbNORPROSJEKT refresh_tbNORPROSJEKT filter_tbNORPROSJEKT ~
excel_tbNORPROSJEKT SPanlegg_tbNORPROSJEKT SHAnlegg_tbNORPROSJEKT fiSearch ~
BrwNORPROSJEKT prosjektid aktivt prosjekt_navn reg_dato shuntgrupper ~
spirovent 
&Scoped-Define DISPLAYED-OBJECTS fiSearch prosjektid aktivt prosjekt_navn ~
reg_dato shuntgrupper spirovent 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON copy_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/documents.ico":U
     IMAGE-INSENSITIVE FILE "gif/documents_disabled.gif":U
     LABEL "Kopier" 
     SIZE 7.8 BY 1.95 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/document_delete.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_delete_disabled.gif":U
     LABEL "Slett" 
     SIZE 7.8 BY 1.95 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON edit_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/document_edit.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_edit_disabled.gif":U
     LABEL "Edit" 
     SIZE 7.8 BY 1.95 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/excel.ico":U
     IMAGE-INSENSITIVE FILE "gif/excel_disabled.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/document_find.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_find_disabled.gif":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON new_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/document_add.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_add_disabled.gif":U
     LABEL "Ny" 
     SIZE 7.8 BY 1.95 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON refresh_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/document_refresh.ico":U
     IMAGE-INSENSITIVE FILE "gif/document_refresh_disabled.gif":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/floppy_disk.ico":U
     IMAGE-INSENSITIVE FILE "gif/floppy_disk_disabled.gif":U
     LABEL "Lagre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON SHAnlegg_tbNORPROSJEKT 
     IMAGE-UP FILE "ico\index.ico":U
     LABEL "Shunt anlegg" 
     SIZE 7.8 BY 1.95.

DEFINE BUTTON SPanlegg_tbNORPROSJEKT 
     IMAGE-UP FILE "ico\index.ico":U
     LABEL "Spirovent anlegg" 
     SIZE 7.8 BY 1.95 TOOLTIP "Spirovent anlegg".

DEFINE BUTTON undo_tbNORPROSJEKT 
     IMAGE-UP FILE "ico/undo.ico":U
     IMAGE-INSENSITIVE FILE "gif/undo_disabled.gif":U
     LABEL "Angre" 
     SIZE 7.8 BY 1.95 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE shuntgrupper AS CHARACTER FORMAT "X(8)" INITIAL "Nei" 
     LABEL "Shuntgrupper" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 36 BY 1.

DEFINE VARIABLE spirovent AS CHARACTER FORMAT "X(8)" INITIAL "Nei" 
     LABEL "Spirovent" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 36 BY 1.

DEFINE VARIABLE fiSearch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 NO-UNDO.

DEFINE VARIABLE prosjektid AS INTEGER FORMAT ">>>>>>>9" INITIAL 0 
     LABEL "Id" 
     VIEW-AS FILL-IN 
     SIZE 13.2 BY 1.

DEFINE VARIABLE prosjekt_navn AS CHARACTER FORMAT "X(45)" 
     LABEL "Prosjektnavn" 
     VIEW-AS FILL-IN 
     SIZE 47 BY 1.

DEFINE VARIABLE reg_dato AS DATE FORMAT "99.99.9999" 
     LABEL "Reg.dato" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.

DEFINE RECTANGLE tbNORPROSJEKT
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 150 BY 2.14.

DEFINE VARIABLE aktivt AS LOGICAL INITIAL no 
     LABEL "Aktivt" 
     VIEW-AS TOGGLE-BOX
     SIZE 11 BY .81 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNORPROSJEKT FOR 
      NORPROSJEKT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNORPROSJEKT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNORPROSJEKT C-Win _STRUCTURED
  QUERY BrwNORPROSJEKT NO-LOCK DISPLAY
      NORPROSJEKT.prosjektid COLUMN-LABEL "prosjektid" FORMAT ">>>>>>>9":U
      NORPROSJEKT.prosjekt_navn COLUMN-LABEL "Prosjektnavn" FORMAT "X(45)":U
            WIDTH 30
      NORPROSJEKT.reg_dato COLUMN-LABEL "Reg.dato" FORMAT "99.99.9999":U
      NORPROSJEKT.aktivt COLUMN-LABEL "Aktivt" FORMAT "ja/nei":U
            WIDTH 10.6
      NORPROSJEKT.shuntgrupper COLUMN-LABEL "SH" FORMAT "X(7)":U
            WIDTH 5
      NORPROSJEKT.spirovent COLUMN-LABEL "SP" FORMAT "X(7)":U
  ENABLE
      NORPROSJEKT.prosjektid
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 83 BY 9.95 ROW-HEIGHT-CHARS .57 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     new_tbNORPROSJEKT AT ROW 1.1 COL 1.2 WIDGET-ID 12
     edit_tbNORPROSJEKT AT ROW 1.1 COL 9.2 WIDGET-ID 26
     copy_tbNORPROSJEKT AT ROW 1.1 COL 17 WIDGET-ID 14
     save_tbNORPROSJEKT AT ROW 1.1 COL 24.8 WIDGET-ID 18
     undo_tbNORPROSJEKT AT ROW 1.1 COL 32.6 WIDGET-ID 16
     delete_tbNORPROSJEKT AT ROW 1.1 COL 40.4 WIDGET-ID 20
     refresh_tbNORPROSJEKT AT ROW 1.1 COL 48.2 WIDGET-ID 22
     filter_tbNORPROSJEKT AT ROW 1.1 COL 56 WIDGET-ID 24
     excel_tbNORPROSJEKT AT ROW 1.1 COL 63.8 WIDGET-ID 42
     SPanlegg_tbNORPROSJEKT AT ROW 1.1 COL 71.6 WIDGET-ID 44
     SHAnlegg_tbNORPROSJEKT AT ROW 1.1 COL 79.4 WIDGET-ID 46
     fiSearch AT ROW 3.76 COL 2 NO-LABEL
     BrwNORPROSJEKT AT ROW 4.81 COL 2 WIDGET-ID 200
     prosjektid AT ROW 5.05 COL 101 COLON-ALIGNED
     aktivt AT ROW 5.05 COL 118 WIDGET-ID 8
     prosjekt_navn AT ROW 6.05 COL 101 COLON-ALIGNED
     reg_dato AT ROW 7.05 COL 101 COLON-ALIGNED
     shuntgrupper AT ROW 8.05 COL 101 COLON-ALIGNED WIDGET-ID 36
     spirovent AT ROW 9.05 COL 101 COLON-ALIGNED WIDGET-ID 38
     tbNORPROSJEKT AT ROW 1 COL 1 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 150.2 BY 14.1 WIDGET-ID 100.


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
         TITLE              = "Prosjekt vedlikehold"
         HEIGHT             = 14.1
         WIDTH              = 150.2
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 150.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 150.2
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
/* BROWSE-TAB BrwNORPROSJEKT fiSearch DEFAULT-FRAME */
/* SETTINGS FOR FILL-IN fiSearch IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
ASSIGN 
       tbNORPROSJEKT:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,copy;Kopier,save;Lagre,undo;Angre,delete;Slett,refresh;Refresh,filter;Filter,excel;Eksporter til E&xcel,SPanlegg;Spirovent anlegg,SHAnlegg;Shunt anleggmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNORPROSJEKT
/* Query rebuild information for BROWSE BrwNORPROSJEKT
     _TblList          = "norcalc.NORPROSJEKT"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > "_<CALC>"
"NORPROSJEKT.prosjektid" "prosjektid" ">>>>>>>9" "integer" ? ? ? ? ? ? yes "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NORPROSJEKT.prosjekt_navn" "Prosjektnavn" "X(45)" "character" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NORPROSJEKT.reg_dato" "Reg.dato" "99.99.9999" "date" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NORPROSJEKT.aktivt" "Aktivt" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NORPROSJEKT.shuntgrupper" "SH" "X(7)" "character" ? ? ? ? ? ? no "" no no "5" yes yes no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NORPROSJEKT.spirovent" "SP" "X(7)" "character" ? ? ? ? ? ? no "" no no "8.4" yes yes no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNORPROSJEKT */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Prosjekt vedlikehold */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Prosjekt vedlikehold */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNORPROSJEKT
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
{incl/conttrigg.i oBrwNORPROSJEKT:BROWSE-HANDLE}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddSHanleggRecord C-Win 
PROCEDURE AddSHanleggRecord :
def var hChild as handle no-undo.
  hChild = JBoxMainMenu:Instance:StartTabWindow("wSPanlegg.w","Spiroventanlegg",THIS-PROCEDURE,no,no).
  dynamic-function('setParentBrowse' in hChild ,input oBrwNORPROSJEKT).
/*def var p-handle as handle no-undo.                                       */
/*/*  SESSION:SET-WAIT-STATE("GENERAL").*/                                  */
/*  prosjektIdParam = NORPROSJEKT.prosjektId.                               */
/*/*  prosjektNavnParam = NORPROSJEKT.prosjekt_navn.*/                      */
/*  RUN SHANLEGG.W  PERSISTENT  SET p-handle                                */
/*    (INPUT  "Prosjekt", INPUT NORPROSJEKT.prosjekt_navn ).                */
/*  RUN appl_ent IN p-handle.                                               */
/*                                                                          */
/*/*   {&OPEN-BROWSERS-IN-QUERY-Prosjekt-Frame}                           */*/
/*/*   REPOSITION BROWSE-Prosjekt TO ROWID(currentProsjektRow).           */*/
/*/*   APPLY 'VALUE-CHANGED' TO BROWSE-Prosjekt   IN FRAME Prosjekt-Frame.*/*/
/*CATCH eAny AS Progress.Lang.Error :                                       */
/*        MESSAGE eAny:GetMessage(1)                                        */
/*  VIEW-AS ALERT-BOX.                                                      */
/*END CATCH.                                                                */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddSPanleggRecord C-Win 
PROCEDURE AddSPanleggRecord :
/*  def var p-handle as handle no-undo.                              */
/*/*  SESSION:SET-WAIT-STATE("GENERAL").*/                           */
/*  RUN spANLEGG.W  PERSISTENT  SET p-handle                         */
/*    (INPUT  "Prosjekt", INPUT NORPROSJEKT.prosjekt_navn ) NO-ERROR.*/
/*  RUN appl_ent IN p-handle.                                        */
  def var hChild as handle no-undo.
  hChild = JBoxMainMenu:Instance:StartTabWindow("wSPanlegg.w","Spiroventanlegg",THIS-PROCEDURE,no,no).
  dynamic-function('setParentBrowse' in hChild ,input oBrwNORPROSJEKT).
  
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
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
run super.
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
  DISPLAY fiSearch prosjektid aktivt prosjekt_navn reg_dato shuntgrupper 
          spirovent 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE tbNORPROSJEKT new_tbNORPROSJEKT edit_tbNORPROSJEKT copy_tbNORPROSJEKT 
         save_tbNORPROSJEKT undo_tbNORPROSJEKT delete_tbNORPROSJEKT 
         refresh_tbNORPROSJEKT filter_tbNORPROSJEKT excel_tbNORPROSJEKT 
         SPanlegg_tbNORPROSJEKT SHAnlegg_tbNORPROSJEKT fiSearch BrwNORPROSJEKT 
         prosjektid aktivt prosjekt_navn reg_dato 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeComponents C-Win 
PROCEDURE InitializeComponents :
DO WITH FRAME {&FRAME-NAME}:
  oreg_dato = NEW JBoxDevExDateEdit(THIS-PROCEDURE,reg_dato:HANDLE).
  oreg_dato:RegisterWithJukeBox(YES). /* YES: Visible */
  oreg_dato:CreateDisplayLink(oFmNORPROSJEKT:BUFFER-HANDLE,'reg_dato').
  
  assign 
    hbtnSH = otbNORPROSJEKT:getButtonHandle('AddSHAnlegg')
    hbtnSP = otbNORPROSJEKT:getButtonHandle('AddSPAnlegg')
  .
  assign 
    shuntgrupper:DELIMITER = '|'
    shuntgrupper:LIST-ITEMS = DYNAMIC-FUNCTION("getFieldList","JBoxGenCode;cCodeValue","WHERE cCodeType = 'DropListDM' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
    spirovent:DELIMITER = '|'
    spirovent:LIST-ITEMS = DYNAMIC-FUNCTION("getFieldList","JBoxGenCode;cCodeValue","WHERE cCodeType = 'DropListDM' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompany") + " BY JBoxGenCode.cCodeValue")
  .
END.

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
  oBrwNORPROSJEKT = NEW JBoxBrowse(brwNORPROSJEKT:HANDLE).
  oBrwNORPROSJEKT:setFilter('aktivt = true').
  oBrwNORPROSJEKT:setSearchField(fiSearch:handle).
  oBrwNORPROSJEKT:setQuerySort("reg_dato;DESC").
  oBrwNORPROSJEKT:setNoResizeX().
  
  oFmNORPROSJEKT = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmNORPROSJEKT:updateFields = 'prosjekt_navn,reg_dato,aktivt,shuntgrupper,spirovent'.
  oFmNORPROSJEKT:DisplayFields = 'prosjektid'.

  oFmNORPROSJEKT:BROWSE-OBJECT = oBrwNORPROSJEKT.
  otbNORPROSJEKT = NEW JBoxToolbar(tbNORPROSJEKT:HANDLE).

  oBrwNORPROSJEKT:TOOLBAR-OBJECT = otbNORPROSJEKT.
  oFmNORPROSJEKT:TOOLBAR-OBJECT = otbNORPROSJEKT.
  
  RUN InitializeComponents.
END.
oBrwNORPROSJEKT:OpenQuery().


oContainer:initResize(800,400).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
run super.
do with frame {&frame-name}:
   assign 
     aktivt   = true
     reg_dato = today
     .
   disp reg_dato aktivt.
   assign 
     reg_dato:modified = false
     aktivt:modified   = false
   . 
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SHAnleggRecord C-Win 
PROCEDURE SHAnleggRecord :
def var hChild as handle no-undo.
/*  hChild = JBoxMainMenu:Instance:StartTabWindow("wSHanlegg.w","Shunt anlegg",THIS-PROCEDURE,yes,no).*/
  hChild = JBoxMainMenu:Instance:StartChildTab("wSHanlegg.w","Shunt anlegg",THIS-PROCEDURE,no,no).
  dynamic-function('setParentBrowse' in hChild ,input oBrwNORPROSJEKT).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SPanleggRecord C-Win 
PROCEDURE SPanleggRecord :
def var hChild as handle no-undo.
  hChild = JBoxMainMenu:Instance:StartChildTab("wSPanlegg.w","Spiroventanlegg",THIS-PROCEDURE,yes,no).
  dynamic-function('setParentBrowse' in hChild ,input oBrwNORPROSJEKT).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

