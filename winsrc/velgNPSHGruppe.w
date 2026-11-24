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

def var iGruppeTypeId as int no-undo.
def var dKapasitet    as dec no-undo.
def var cGrunnlag     as char no-undo.

/*** Start instance property definitions for JBoxBrowse object oBrwNPSHGruppe ***/
DEF VAR oBrwNPSHGruppe AS JBoxBrowse NO-UNDO.
DEF TEMP-TABLE NPSHGruppe
    FIELD storrelse AS character
    FIELD nedre AS decimal
    FIELD ovre AS decimal
    FIELD grunnlag AS character
    FIELD NPSHGruppeTypeNavn AS character
    FIELD iNPSHGruppeTypeId AS integer
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
    .
DEF BUFFER v_NPSHGruppe FOR TEMP-TABLE NPSHGruppe.


FUNCTION getBuffersAndFieldsBrwNPSHGruppe RETURNS CHARACTER():
  RETURN
    'NPSHGruppe'
     + ';storrelse'
     + ';nedre'
     + ';ovre'
     + ';grunnlag'
     + ';iNPSHGruppeTypeId'
  + ',NPSHGruppeType'
     + ';NPSHGruppeTypeNavn'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSHGruppe RETURNS CHARACTER():
  RETURN 'FIRST NPSHGruppeType  WHERE NPSHGruppeType.iNPSHGruppeTypeId = NPSHGruppe.iNPSHGruppeTypeId NO-LOCK'.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSHGruppe

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHGruppe

/* Definitions for BROWSE BrwNPSHGruppe                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSHGruppe NPSHGruppe.storrelse ~
NPSHGruppe.nedre NPSHGruppe.ovre NPSHGruppe.grunnlag ~
NPSHGruppe.NPSHGruppeTypeNavn NPSHGruppe.iNPSHGruppeTypeId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSHGruppe NPSHGruppe.storrelse ~
NPSHGruppe.NPSHGruppeTypeNavn 
&Scoped-define QUERY-STRING-BrwNPSHGruppe FOR EACH NPSHGruppe NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSHGruppe OPEN QUERY BrwNPSHGruppe FOR EACH NPSHGruppe NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSHGruppe NPSHGruppe
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSHGruppe NPSHGruppe


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BrwNPSHGruppe 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSHGruppe FOR 
      NPSHGruppe SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSHGruppe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSHGruppe C-Win _STRUCTURED
  QUERY BrwNPSHGruppe NO-LOCK DISPLAY
      NPSHGruppe.storrelse COLUMN-LABEL "Størrelse" FORMAT "X(2)":U
            WIDTH 8.25
      NPSHGruppe.nedre COLUMN-LABEL "Nedre" FORMAT "->>,>>9.99":U
            WIDTH 10.25
      NPSHGruppe.ovre COLUMN-LABEL "Øvre" FORMAT "->>,>>9.99":U
            WIDTH 10.25
      NPSHGruppe.grunnlag COLUMN-LABEL "Grunnlag" FORMAT "x(14)":U
      NPSHGruppe.NPSHGruppeTypeNavn COLUMN-LABEL "GruppeType" FORMAT "X(3)":U
            WIDTH 11.75
      NPSHGruppe.iNPSHGruppeTypeId COLUMN-LABEL "NPSHGruppeTypeId" FORMAT ">>>>>>>>9":U
            WIDTH 18.25
  ENABLE
      NPSHGruppe.storrelse
      NPSHGruppe.NPSHGruppeTypeNavn
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 98 BY 11.72 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BrwNPSHGruppe AT ROW 1 COL 1 WIDGET-ID 200
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SCROLLABLE SIZE 98 BY 11.72 WIDGET-ID 100.


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
         TITLE              = "Velg dimmensjon"
         HEIGHT             = 11.72
         WIDTH              = 98
         MAX-HEIGHT         = 23.53
         MAX-WIDTH          = 114.25
         VIRTUAL-HEIGHT     = 23.53
         VIRTUAL-WIDTH      = 114.25
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
/* BROWSE-TAB BrwNPSHGruppe 1 DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 11.71
       FRAME DEFAULT-FRAME:WIDTH            = 98.

ASSIGN 
       NPSHGruppe.iNPSHGruppeTypeId:VISIBLE IN BROWSE BrwNPSHGruppe = FALSE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSHGruppe
/* Query rebuild information for BROWSE BrwNPSHGruppe
     _TblList          = "norcalc.NPSHGruppe"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _TblOptList       = ", FIRST OUTER"
     _FldNameList[1]   > "_<CALC>"
"NPSHGruppe.storrelse" "Størrelse" "X(2)" "character" ? ? ? ? ? ? yes "" no no "8.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > "_<CALC>"
"NPSHGruppe.nedre" "Nedre" "->>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > "_<CALC>"
"NPSHGruppe.ovre" "Øvre" "->>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > "_<CALC>"
"NPSHGruppe.grunnlag" "Grunnlag" "x(14)" "character" ? ? ? ? ? ? no "" no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > "_<CALC>"
"NPSHGruppe.NPSHGruppeTypeNavn" "GruppeType" "X(3)" "character" ? ? ? ? ? ? yes "" no no "11.75" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > "_<CALC>"
"NPSHGruppe.iNPSHGruppeTypeId" "NPSHGruppeTypeId" ">>>>>>>>9" "integer" ? ? ? ? ? ? no "" no no "18.25" no no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSHGruppe */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Velg dimmensjon */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Velg dimmensjon */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSHGruppe
&Scoped-define SELF-NAME BrwNPSHGruppe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrwNPSHGruppe C-Win
ON GO OF BrwNPSHGruppe IN FRAME DEFAULT-FRAME
DO:
  if avail NPSHGruppe then publish 'setValues' (NPSHGruppe.storrelse).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BrwNPSHGruppe C-Win
ON LEFT-MOUSE-DBLCLICK OF BrwNPSHGruppe IN FRAME DEFAULT-FRAME
DO:
  if avail NPSHGruppe then publish 'setValues' (NPSHGruppe.storrelse).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
{incl/conttrigg.i oBrwNPSHGruppe:BROWSE-HANDLE}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DefaultActionBrowse C-Win 
PROCEDURE DefaultActionBrowse :
DO WITH FRAME {&FRAME-NAME}:
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
    publish 'setDimmValue' (oBrwNPSHGruppe:BUFFER-HANDLE::storrelse).
    apply 'close' to this-procedure.
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
  ENABLE BrwNPSHGruppe 
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

  oBrwNPSHGruppe = NEW JBoxBrowse(brwNPSHGruppe:HANDLE).
/*  oBrwNPSHGruppe:setFilter('nedre,ovre,grunnlag','<,>=,=',string(dKapasitet) + '|' + string(dKapasitet) + '|' + cGrunnlag).*/
/*      FOR EACH xxxNPSHFMGR:                                                           */
/*      IF  (xxxNPSHFMGR.nedre  <  c_kapasitet  AND                                     */
/*          xxxNPSHFMGR.ovre  >= c_kapasitet) AND xxxNPSHFMGR.grunnlag = c_grunnlag THEN*/
/*          DO:                                                                         */
/*              dimm_verdi = xxxNPSHFMGR.storrelse.                                     */
/*              LEAVE.                                                                  */
/*          END.                                                                        */
/*      ELSE                                                                            */
/*            selectedRow = BROWSE-5:SELECT-NEXT-ROW().                                 */
/*                                                                                      */
/*    END.                                                                              */
  
END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setValues C-Win 
PROCEDURE setValues :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
def input param ipType      as char no-undo.
def input param ipKapasitet as dec  no-undo.
def input param ipGrunnlag  as char no-undo.

subscribe procedure SOURCE-PROCEDURE to 'setDimmValue' anywhere.

if JBoxServerAPI:Instance:Find('NPSHGruppeType','where NPSHGruppeTypeNavn = ' + quoter(ipType)) then 
  iGruppeTypeId = JBoxServerAPI:Instance:IntValue('iNPSHGruppeTypeId').
assign 
  dKapasitet = ipKapasitet
  cGrunnlag  = ipGrunnlag
.

oBrwNPSHGruppe:baseQuery = substitute('WHERE iNPSHGruppeTypeId = &1',iGruppeTypeId).
oBrwNPSHGruppe:OpenQuery().
oBrwNPSHGruppe:BUFFER-HANDLE:find-first(substitute('WHERE (nedre < &1 and ovre >= &1) and grunnlag = "&2"',dKapasitet,cGrunnlag)) no-error.
if oBrwNPSHGruppe:BUFFER-HANDLE:avail then do:
  oBrwNPSHGruppe:QUERY-HANDLE:reposition-to-rowid(oBrwNPSHGruppe:BUFFER-HANDLE:rowid).
  oBrwNPSHGruppe:displayRecord().
end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

