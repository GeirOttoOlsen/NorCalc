&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR bOk                  AS LOG    NO-UNDO.
DEF VAR ix                   AS INT    NO-UNDO.
DEF VAR iReturn              AS INT    NO-UNDO.
DEF VAR hParent              AS HANDLE NO-UNDO.
DEF VAR hParentBrowse        AS HANDLE NO-UNDO.  
DEF VAR hToolbar             AS HANDLE NO-UNDO.

DEF VAR hBrowse              AS HANDLE NO-UNDO.

DEF VAR cTotalMenu           AS CHAR   NO-UNDO.
DEF VAR cTotalFields         AS CHAR   NO-UNDO.
DEF VAR cTotalLabels         AS CHAR   NO-UNDO.
DEF VAR hTotalsMenu          AS HANDLE NO-UNDO.
DEF VAR bDecimalFields       AS LOG    NO-UNDO.
DEF VAR iRowsToBatch         AS INT    NO-UNDO.
DEF VAR bManualView          AS LOG    NO-UNDO.

DEF VAR cInitFilterFields    AS CHAR   NO-UNDO.
DEF VAR cInitFilterOperators AS CHAR   NO-UNDO.
DEF VAR cInitFilterValues    AS CHAR   NO-UNDO.
DEF VAR cInitCalcFieldProcs  AS CHAR   NO-UNDO.
DEF VAR cInitSort            AS CHAR   NO-UNDO.

DEF VAR cUseLocalData        AS CHAR   NO-UNDO.
DEF VAR cCustomFilter        AS CHAR   NO-UNDO.
DEF VAR cExcludeFields       AS CHAR   NO-UNDO.
DEF VAR bPrintButton         AS LOG    NO-UNDO.
DEF VAR bWordButton          AS LOG    NO-UNDO.
DEF VAR bEmailButton         AS LOG    NO-UNDO.
DEF VAR bSMSButton           AS LOG    NO-UNDO.
DEF VAR bAccumButton         AS LOG    NO-UNDO INIT TRUE.
DEF VAR bAccumFieldSort      AS LOG    NO-UNDO INIT TRUE.

DEF VAR cOrgWinTitle         AS CHAR   NO-UNDO.
DEF VAR cQueryTitle          AS CHAR   NO-UNDO.
DEF VAR cExcludedList        AS CHAR   NO-UNDO.
DEF VAR bDisableSaveFilter   AS LOG    NO-UNDO.
DEF VAR bEnableSaveQuery     AS LOG    NO-UNDO.
DEF VAR hBtnSaveQuery        AS HANDLE NO-UNDO.
DEF VAR hBtnDeleteQuery      AS HANDLE NO-UNDO.
DEF VAR hBtnShareQuery       AS HANDLE NO-UNDO.
DEF VAR hBtnScheduleQuery    AS HANDLE NO-UNDO.
DEF VAR hFilterBtn           AS HANDLE NO-UNDO.
DEF VAR cActiveFilterBtn     AS CHAR   NO-UNDO.
DEF VAR cPassiveFilterBtn    AS CHAR   NO-UNDO.
DEF VAR hAccumBtn            AS HANDLE NO-UNDO.
DEF VAR cActiveAccumBtn      AS CHAR   NO-UNDO.
DEF VAR cPassiveAccumBtn     AS CHAR   NO-UNDO.
DEF VAR hConfigBtn           AS HANDLE NO-UNDO.
DEF VAR cActiveConfigBtn     AS CHAR   NO-UNDO.
DEF VAR cPassiveConfigBtn    AS CHAR   NO-UNDO.
DEF VAR cQuerySettingList    AS CHAR   NO-UNDO.
DEF VAR cCurrQuerySettings   AS CHAR   NO-UNDO.
DEF VAR cOrgViewFields       AS CHAR   NO-UNDO.
DEF VAR hExcelGraph          AS HANDLE NO-UNDO.
DEF VAR cGraphMenu           AS CHAR   NO-UNDO.
DEF VAR cGraphLabels         AS CHAR   NO-UNDO.
DEF VAR cGraphFields         AS CHAR   NO-UNDO.
DEF VAR cCurrGraphField      AS CHAR   NO-UNDO.
DEF VAR iMaxGraph            AS INT    NO-UNDO INIT 50.
DEF VAR cCurrFlatDistinct    AS CHAR   NO-UNDO.
DEF VAR cCurrFlatAccum       AS CHAR   NO-UNDO.
DEF VAR bUseStdAppServer     AS LOG    NO-UNDO.
DEF VAR bNoDrillDown         AS LOG    NO-UNDO.
DEF VAR cAccumTotalFields    AS CHAR   NO-UNDO.
DEF VAR cTitlePrefixTotals   AS CHAR   NO-UNDO.
DEF VAR cTitlePrefixDetails  AS CHAR   NO-UNDO.
DEF VAR hMenuItemCountRows   AS HANDLE NO-UNDO.
DEF VAR oDynDataBrowse       AS JBoxDynDataBrowse NO-UNDO.
DEF VAR cQueryOwner          AS CHAR   NO-UNDO.
DEF VAR cCurrQueryId         AS CHAR   NO-UNDO.
DEF VAR hMyQueriesMenu       AS HANDLE NO-UNDO.
DEF VAR hSharedQueriesMenu   AS HANDLE NO-UNDO.
DEF VAR cMyMenuIdList        AS CHAR   NO-UNDO.
DEF VAR cMyMenuNameList      AS CHAR   NO-UNDO.
DEF VAR cSharedMenuIdList    AS CHAR   NO-UNDO.
DEF VAR cSharedMenuNameList  AS CHAR   NO-UNDO.
DEF VAR hWinToolbar          AS HANDLE NO-UNDO.
DEF VAR oContainer           AS JBoxContainer NO-UNDO.
DEF VAR cJBoxUserSettingId   AS CHAR NO-UNDO.
DEF VAR hViewTablesMenu      AS HANDLE NO-UNDO.
DEF VAR hScheduler           AS HANDLE NO-UNDO.
DEF VAR hFillTimeSeries      AS HANDLE NO-UNDO.
DEF VAR hMenuItemShareQuery  AS HANDLE NO-UNDO.
DEF VAR hDrillInNewWindow    AS HANDLE NO-UNDO.
DEF VAR hSwitchLocal         AS HANDLE NO-UNDO. 
/*DEF VAR hShowQuery           AS HANDLE NO-UNDO.       */
/*DEF VAR oMenuStatusBar       AS JBoxPopupMenu NO-UNDO.*/

DEF VAR oBrowse              AS JBoxBrowse NO-UNDO.

def var BatchQueryId         as char no-undo.

cQuerySettingList = "OperatorInUse_,GroupOperator_,FieldGroup_,FieldOperator_,OperatorInUse_,FieldOperator_,FilterValue_,HiddenGroupOperator_,queryfilter,prescanquery,calcfieldfilter,advancedfilter,getrecordcount"
/*                    + ",allaccumfields,allcalcfields,prescanmainquerycandidates_filter" /* <- to keep from clearing */  */
//                   + ",gridFilterValue_,gridOperatorInUse_"
                   + ",currviewfields,widthpixellist,distinctcolumns,accumfields,accumsortfields,accumviewfields"
                   + ",querysort,localsort,querydesc,1stsortcolumn,1stsortcolumndesc,2ndsortcolumn,2ndsortcolumndesc,3rdsortcolumn,3rdsortcolumndesc,4thsortcolumn,4thsortcolumndesc"
                   + ",queryWhere,distinctTables,accumTables"
                     .

DEF TEMP-TABLE ttChild
    FIELD hChild AS HANDLE.

/* {pdfprint.i}  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BrwFlatView searchField rectToolbar ~
rectWinToolbar fiCurrentQuery 
&Scoped-Define DISPLAYED-OBJECTS fiCurrentQuery 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD AdjustBrowseColumns C-Win 
FUNCTION AdjustBrowseColumns RETURNS LOGICAL
  ( INPUT ihBrowse     AS HANDLE,
    INPUT icBrowseName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ClearAttributes C-Win 
FUNCTION ClearAttributes RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ClearUseIndex C-Win 
FUNCTION ClearUseIndex RETURNS CHARACTER
  ( INPUT icQueryString AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CreateSearchField C-Win 
FUNCTION CreateSearchField RETURNS LOGICAL
  ( INPUT icInitSort AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBatchQueryId C-Win 
FUNCTION getBatchQueryId RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseHandle C-Win 
FUNCTION getBrowseHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDynDataBrowseObject C-Win 
FUNCTION getDynDataBrowseObject RETURNS JBoxDynDataBrowse
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFrameHandle C-Win 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getToolbarHandle C-Win 
FUNCTION getToolbarHandle RETURNS HANDLE
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ReduceFields C-Win 
FUNCTION ReduceFields RETURNS CHARACTER
  ( INPUT icBuffersAndFields AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD resetRowCounter C-Win 
FUNCTION resetRowCounter RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SaveQuery C-Win 
FUNCTION SaveQuery RETURNS LOGICAL
  ( INPUT icCurrQueryId AS CHAR,
    INPUT icName        AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SeqToAlpha C-Win 
FUNCTION SeqToAlpha RETURNS CHARACTER
  ( INPUT iiSeqNo AS INT,
    INPUT iCount  AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAccumButton C-Win 
FUNCTION setAccumButton RETURNS LOGICAL
  ( INPUT ibAccumButton AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAccumFieldSort C-Win 
FUNCTION setAccumFieldSort RETURNS LOGICAL
  ( INPUT ibAccumFieldSort AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBatchQueryId C-Win 
FUNCTION setBatchQueryId RETURNS LOGICAL
 ( input ipValue as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setBrowseObject C-Win 
FUNCTION setBrowseObject RETURNS LOGICAL
  ( INPUT ioBrowse AS JBoxBrowse )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCalcFieldProcs C-Win 
FUNCTION setCalcFieldProcs RETURNS LOGICAL
  ( INPUT icCalcFieldProcs AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCustomFilterWin C-Win 
FUNCTION setCustomFilterWin RETURNS LOGICAL
  ( INPUT icCustomFilter AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisableSaveFilter C-Win 
FUNCTION setDisableSaveFilter RETURNS LOGICAL
  ( INPUT ibDisableSaveFilter AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEmailButton C-Win 
FUNCTION setEmailButton RETURNS LOGICAL
  ( INPUT ibEmailButton AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setEnableSaveQuery C-Win 
FUNCTION setEnableSaveQuery RETURNS LOGICAL
  ( INPUT ibEnableSaveQuery AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setExcludeFields C-Win 
FUNCTION setExcludeFields RETURNS LOGICAL
  ( icExcludeFields AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInitFilter C-Win 
FUNCTION setInitFilter RETURNS LOGICAL
  ( INPUT icInitFilterFields    AS CHAR,
    INPUT icInitFilterOperators AS CHAR,
    INPUT icInitFilterValues    AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setManualView C-Win 
FUNCTION setManualView RETURNS LOGICAL
  ( INPUT ibManualView AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMyQueriesMenu C-Win 
FUNCTION setMyQueriesMenu RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNoDrillDown C-Win 
FUNCTION setNoDrillDown RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  ( INPUT ihParent AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPrintButton C-Win 
FUNCTION setPrintButton RETURNS LOGICAL
  ( INPUT ibPrintButton AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowsToBatch C-Win 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( INPUT iiRowsToBatch AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD SetSharedQueriesMenu C-Win 
FUNCTION SetSharedQueriesMenu RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSMSButton C-Win 
FUNCTION setSMSButton RETURNS LOGICAL
  ( INPUT ibSMSButton AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTotalFields C-Win 
FUNCTION setTotalFields RETURNS LOGICAL
  ( INPUT icTotalFields AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTotalFieldsMenu C-Win 
FUNCTION setTotalFieldsMenu RETURNS LOGICAL
  ( INPUT icViewType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseLocalData C-Win 
FUNCTION setUseLocalData RETURNS LOGICAL
  ( ibUseLocalData AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUseStdAppserver C-Win 
FUNCTION setUseStdAppserver RETURNS LOGICAL
  ( INPUT ibUseStdAppServer AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewAllTablesMenu C-Win 
FUNCTION setViewAllTablesMenu RETURNS LOGICAL
  ( INPUT icViewType AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWinTitle C-Win 
FUNCTION setWinTitle RETURNS LOGICAL
  ( INPUT icWinTitle AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setWordButton C-Win 
FUNCTION setWordButton RETURNS LOGICAL
  ( INPUT ibWordButton AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StartQuery C-Win 
FUNCTION StartQuery RETURNS LOGICAL
  ( INPUT icFilterFields    AS CHAR,
    INPUT icFilterOperators AS CHAR,
    INPUT icFilterValues    AS CHAR,
    INPUT icInitSort        AS CHAR,
    INPUT icDistinctCols    AS CHAR,
    INPUT icAccumFields     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StartQueryCls C-Win 
FUNCTION StartQueryCls RETURNS LOGICAL
  ( INPUT icFilterFields    AS CHAR,
    INPUT icFilterOperators AS CHAR,
    INPUT icFilterValues    AS CHAR,
    INPUT icInitSort        AS CHAR,
    INPUT icDistinctCols    AS CHAR,
    INPUT icAccumFields     AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ViewQueryStat C-Win 
FUNCTION ViewQueryStat RETURNS LOGICAL
  ( INPUT ihBrowse AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE fiCurrentQuery AS CHARACTER FORMAT "X(256)":U 
     LABEL "Fill 1" 
     VIEW-AS FILL-IN 
     SIZE 42 BY .86 NO-UNDO.

DEFINE RECTANGLE BrwFlatView
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 129 BY 15.71.

DEFINE RECTANGLE rectToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY .91.

DEFINE RECTANGLE rectWinToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 4.2 BY .91.

DEFINE RECTANGLE searchField
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18.8 BY .95.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     fiCurrentQuery AT ROW 1.43 COL 68.2 COLON-ALIGNED
     BrwFlatView AT ROW 2.67 COL 1.8
     searchField AT ROW 1.33 COL 27.4
     rectToolbar AT ROW 1.33 COL 2.2
     rectWinToolbar AT ROW 1.29 COL 125.2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 130.6 BY 17.62.


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
         TITLE              = "<insert window title>"
         HEIGHT             = 17.62
         WIDTH              = 130.6
         MAX-HEIGHT         = 52.38
         MAX-WIDTH          = 320
         VIRTUAL-HEIGHT     = 52.38
         VIRTUAL-WIDTH      = 320
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

{incl\jb_shared.i}
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <insert window title> */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-RESIZED OF C-Win /* <insert window title> */
DO:
  DYNAMIC-FUNCTION("setWidgetResize",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE:CURRENT-WINDOW,"resize","").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiCurrentQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiCurrentQuery C-Win
ON VALUE-CHANGED OF fiCurrentQuery IN FRAME DEFAULT-FRAME /* Fill 1 */
DO:
  IF cQueryOwner = JBoxSession:Instance:UserId OR cQueryOwner = "" THEN hBtnSaveQuery:SENSITIVE = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
  DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW).
  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    DYNAMIC-FUNCTION("setCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  &ENDIF   
  
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  FOR EACH ttChild:
    IF VALID-HANDLE(ttChild.hChild) THEN 
      APPLY "close" TO ttChild.hChild.
  END.
  RUN disable_UI.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
/*     RUN InitializeObject ("Hovedbok","WHERE true","iHovedbokId",TRUE). */
    RUN InitializeObject ("FakturaLinje","WHERE ifakturalinjeid > 30","iFakturaHodeId",TRUE).
  &ENDIF

  SUBSCRIBE TO "InitStringTranslation" ANYWHERE.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  {incl/wintrigg.i}

  ON 'ctrl-s' OF FRAME {&FRAME-NAME} ANYWHERE DO:
    IF cCurrQueryId NE "" THEN RUN SaveCurrentQuery.
    RETURN.
  END.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeDynAccum C-Win 
PROCEDURE BeforeDynAccum :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihBrowse AS HANDLE NO-UNDO.
DEF INPUT PARAM icAction AS CHAR   NO-UNDO.

IF ihBrowse NE hBrowse THEN RETURN.

IF icAction = "clear" THEN DO:
  IF cInitSort NE "" THEN
    DYNAMIC-FUNCTION("setSortString",hBrowse,ENTRY(NUM-ENTRIES(cInitSort,"."),cInitSort,".")).
  
  IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"originalTempTable") NE "" THEN DO:
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"tempTableHandle",DYNAMIC-FUNCTION("getAttribute",hBrowse,"originalTempTable")).
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"uselocaldata","yes").
  END.
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeSetDynFilter C-Win 
PROCEDURE BeforeSetDynFilter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihQueryObject AS HANDLE NO-UNDO.

IF ihQueryObject NE hBrowse THEN RETURN.

IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"uselocaldata") = "yes" AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"tempTableHandle") = "" THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"uselocaldata","").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyHelpTextRecord C-Win 
PROCEDURE copyHelpTextRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  CLIPBOARD:VALUE = oContainer:statusBar:hHelpText:SCREEN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CopyToClipboardRecord C-Win 
PROCEDURE CopyToClipboardRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DYNAMIC-FUNCTION("CopyBrowseToClipboard",hBrowse).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CountRecord C-Win 
PROCEDURE CountRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF hMenuItemCountRows:CHECKED THEN DO:
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"getRecordCount","yes").
  RUN InvokeMethod(hBrowse,"OpenQuery").
END.
ELSE 
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"getRecordCount","").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DefaultActionBrowse C-Win 
PROCEDURE DefaultActionBrowse :
/*------------------------------------------------------------------------------
  Purpose:    If the browse is showing distinct values allow drill-down
              if the distinct columns is contained within the basetablefields 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cDistinctColumns       AS CHAR   NO-UNDO.
DEF VAR cBaseTableFilterFields AS CHAR   NO-UNDO.
DEF VAR hCurrFlatView          AS HANDLE NO-UNDO.
DEF VAR hCurrFlatBrw           AS HANDLE NO-UNDO.

ASSIGN cDistinctColumns = DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns")
       cBaseTableFilterFields = DYNAMIC-FUNCTION("getAttribute",hBrowse,"basetablefilterfields")
       .

IF cDistinctColumns NE "" THEN DO:
  hCurrFlatView = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"flatviewhandle")) NO-ERROR.
  IF VALID-HANDLE(hCurrFlatView) THEN DO:
    hCurrFlatBrw = DYNAMIC-FUNCTION("getBrowseHandle" IN hCurrFlatView).
    CREATE ttChild.
    ttChild.hChild = hCurrFlatView.

    ASSIGN cCurrFlatDistinct = DYNAMIC-FUNCTION("getAttribute",hCurrFlatBrw,"distinctcolumns")
           cCurrFlatAccum    = DYNAMIC-FUNCTION("getAttribute",hCurrFlatBrw,"accumfields").  
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"flatviewhandle","").
  END.
  ELSE DO: 
    bOk = NO.
    SjekkChild:
    FOR EACH ttChild:
      IF VALID-HANDLE(ttChild.hChild) THEN DO:
        hCurrFlatBrw = DYNAMIC-FUNCTION("getBrowseHandle" IN ttChild.hChild).
        ASSIGN cCurrFlatDistinct = DYNAMIC-FUNCTION("getAttribute",hCurrFlatBrw,"distinctcolumns")
               cCurrFlatAccum    = DYNAMIC-FUNCTION("getAttribute",hCurrFlatBrw,"accumfields").
        IF cCurrFlatDistinct NE "" THEN DO:
          bOk = YES.  
          LEAVE SjekkChild.
        END.
      END.
    END.
    IF NOT bOk THEN
      ASSIGN cCurrFlatDistinct = ""
             cCurrFlatAccum    = "".
  END.
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"drillDown","yes").
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"childwindow",DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"childwindow")).
  RUN FlatViewRecord.
END.
ELSE 
  PUBLISH "FlatViewDblClick" (ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"buffersandfields")),";"),
                                 hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD("RowIdent1"):BUFFER-VALUE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteQuery C-Win 
PROCEDURE DeleteQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF cQueryOwner NE JBoxSession:Instance:UserId AND oDynDataBrowse:ViewDsId = "" THEN DO:
  IF JBoxSession:Instance:ViewQuestionYesNo((IF JBoxSession:Instance:Scandinavian THEN "Fjern kobling fra min bruker til" + CHR(10) 
                                             ELSE "Delete link from my user to" + CHR(10)) + fiCurrentQuery:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "?") THEN DO: 
    IF DYNAMIC-FUNCTION("setUserSetting",THIS-PROCEDURE:FILE-NAME,
                     "userquery",
                     DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext"),
                     cCurrQueryId,
                     "delete_setting") THEN DO:
      SetSharedQueriesMenu().
      ClearAttributes().
      APPLY "cursor-up" to hBrowse.
    END.  
  END.    
END.
ELSE DO:
  IF JBoxSession:Instance:ViewQuestionYesNo((IF JBoxSession:Instance:Scandinavian THEN "Slett" + CHR(10) ELSE "Delete" + CHR(10)) + fiCurrentQuery:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "?") THEN 
    SaveQuery(cCurrQueryId,"delete_setting").
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeselectRowRecord C-Win 
PROCEDURE DeselectRowRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR hRecordSelectWidget AS HANDLE NO-UNDO.

hBrowse:DESELECT-ROWS().

hRecordSelectWidget = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE:CURRENT-WINDOW,"RecordSelectWidget")) NO-ERROR.
IF VALID-HANDLE(hRecordSelectWidget) THEN 
  hRecordSelectWidget:SCREEN-VALUE = "".

IF VALID-HANDLE(hExcelGraph) THEN 
  hExcelGraph:SENSITIVE = INT(DYNAMIC-FUNCTION("getAttribute",hBrowse,"recordCount")) < iMaxGraph AND NUM-ENTRIES(DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns")) = 1.


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
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cDistinctCol AS CHAR NO-UNDO.

/*DYNAMIC-FUNCTION("DoLockWindow",hBrowse:WINDOW).                       */
/*DYNAMIC-FUNCTION("setAttribute",SESSION,"userKeepsWindowLocked","yes").*/

PUBLISH "BeforeDisplayRecord" (hBrowse,hToolbar).
RUN SUPER.

cDistinctCol = DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns").
IF VALID-HANDLE(hFillTimeSeries) THEN DO:
  hFillTimeSeries:SENSITIVE = cDistinctCol NE "" 
                              AND NUM-ENTRIES(cDistinctCol) = 1
                              AND CAN-DO("jb_weeknum,jb_month,jb_quarter,jb_year",DYNAMIC-FUNCTION("getAttribute",hBrowse,"calcProc" + cDistinctCol))
                              .  
END.        
IF VALID-HANDLE(hDrillInNewWindow) THEN
  hDrillInNewWindow:SENSITIVE = cDistinctCol NE "".     
IF VALID-HANDLE(hSwitchLocal) THEN 
  hSwitchLocal:SENSITIVE = DYNAMIC-FUNCTION("getAttribute",hBrowse,"lastRowid") NE "" AND cDistinctCol = "".

/*DYNAMIC-FUNCTION("setAttribute",SESSION,"userKeepsWindowLocked","").*/
/*DYNAMIC-FUNCTION("DoLockWindow",?).                                 */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DrillInNewWinRecord C-Win 
PROCEDURE DrillInNewWinRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DYNAMIC-FUNCTION("setAttribute",THIS-PROCEDURE,"childwindow","yes").
RUN DefaultActionBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DynAccumDone C-Win 
PROCEDURE DynAccumDone :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihBrowse AS HANDLE NO-UNDO.
DEF INPUT PARAM icAction AS CHAR   NO-UNDO.

DEF VAR hFilter                  AS HANDLE NO-UNDO.
DEF VAR cPermanentDisabledEvents AS CHAR   NO-UNDO.
DEF VAR cTitlePrefix             AS CHAR   NO-UNDO.
DEF VAR cTitleSuffix             AS CHAR   NO-UNDO.
DEF VAR cDistinctCols            AS CHAR   NO-UNDO.
DEF VAR cButton                  AS CHAR   NO-UNDO.

IF ihBrowse NE hBrowse THEN RETURN.

cPermanentDisabledEvents = DYNAMIC-FUNCTION("getAttribute",hToolbar,"permanentdisabledevents").

IF VALID-HANDLE(hDrillInNewWindow) THEN
  hDrillInNewWindow:SENSITIVE = icAction = "accum". 

IF icAction = "accum" THEN DO:
  ASSIGN cDistinctCols = DYNAMIC-FUNCTION("getAttribute",ihBrowse,"distinctcolumns")
         cButton = DYNAMIC-FUNCTION("getAttribute",SESSION,"activeaccumbutton").

  IF CAN-DO(cPermanentDisabledEvents,"filter") THEN DO:
    cTitlePrefix = cTitlePrefixTotals + " ".
/*     IF DYNAMIC-FUNCTION("Scandinavian") THEN */
/*       cTitlePrefix  = "Totalt pr ".          */
/*     ELSE                                     */
/*       cTitlePrefix  = "Totals pr ".          */
  END.
  ELSE DO:
    cTitleSuffix = " - " + cTitlePrefixTotals + " ".
/*     IF DYNAMIC-FUNCTION("Scandinavian") THEN */
/*       cTitleSuffix  = " - Totalt pr ".       */
/*     ELSE                                     */
/*       cTitleSuffix  = " - Totals pr ".       */
  END.

  DO ix = 1 TO NUM-ENTRIES(cDistinctCols):
    IF CAN-DO(cPermanentDisabledEvents,"filter") THEN 
      cTitlePrefix = cTitlePrefix + DYNAMIC-FUNCTION("getBrowseColumnLabel",ihBrowse,ENTRY(ix,cDistinctCols)) + 
                     IF ix = NUM-ENTRIES(cDistinctCols) THEN ". " ELSE ", ".
    ELSE
      cTitleSuffix = cTitleSuffix + DYNAMIC-FUNCTION("getBrowseColumnLabel",ihBrowse,ENTRY(ix,cDistinctCols)) + 
                     IF ix = NUM-ENTRIES(cDistinctCols) THEN ". " ELSE ", ".
  END.
  THIS-PROCEDURE:CURRENT-WINDOW:TITLE = cTitlePrefix + (IF cQueryTitle NE "" THEN cQueryTitle ELSE cOrgWinTitle) + cTitleSuffix.

  DYNAMIC-FUNCTION("setAttribute",hToolbar,"disabledevents",TRIM(cPermanentDisabledEvents + ",word,browseconfig",",")).
  hFilter = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"filterhandle")) NO-ERROR.
  IF VALID-HANDLE(hFilter) THEN APPLY "close" TO hFilter.
  setTotalFieldsMenu("accum").
  setViewAllTablesMenu("accum").
  resetRowCounter().
  
END.
ELSE DO:
  THIS-PROCEDURE:CURRENT-WINDOW:TITLE = cOrgWinTitle.
  cButton = DYNAMIC-FUNCTION("getAttribute",SESSION,"passiveaccumbutton").
  DYNAMIC-FUNCTION("setAttribute",hToolbar,"disabledevents",cPermanentDisabledEvents).
  setTotalFieldsMenu("details").
  setViewAllTablesMenu("details").
END.

IF VALID-HANDLE(hAccumBtn) THEN 
  hAccumBtn:LOAD-IMAGE(cButton).
       
APPLY "value-changed" TO hBrowse.

APPLY "cursor-up" to hBrowse.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE emailRecord C-Win 
PROCEDURE emailRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PUBLISH "FlatViewEmailRecord" (ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"buffersandfields")),";"),
                               hBrowse).

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
  DISPLAY fiCurrentQuery 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE BrwFlatView searchField rectToolbar rectWinToolbar fiCurrentQuery 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelGraph C-Win 
PROCEDURE ExcelGraph :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR hMenuItem         AS HANDLE NO-UNDO.
DEF VAR cDistinctField    AS CHAR   NO-UNDO.
DEF VAR iOrgPosDistinct   AS INT    NO-UNDO.
DEF VAR iOrgPosGraphField AS INT    NO-UNDO.

ASSIGN hMenuItem       = DYNAMIC-FUNCTION("getCurrentWidget")
       cCurrGraphField = ENTRY(LOOKUP(hMenuItem:LABEL,cGraphLabels),cGraphFields)
       cDistinctField  = DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns")
       .

DO ix = 1 TO hBrowse:NUM-COLUMNS:
  IF ix > 1 AND hBrowse:GET-BROWSE-COLUMN(ix):NAME = cDistinctField THEN DO:
    hBrowse:MOVE-COLUMN(ix,1).  
    iOrgPosDistinct = ix.
    LEAVE.
  END.
END.
DO ix = 1 TO hBrowse:NUM-COLUMNS:
  IF ix NE 2 AND hBrowse:GET-BROWSE-COLUMN(ix):NAME = cCurrGraphField THEN DO:
    hBrowse:MOVE-COLUMN(ix,2).  
    iOrgPosGraphField = ix.
    LEAVE.
  END.
END.

DYNAMIC-FUNCTION("setCurrentObject",hBrowse).
RUN ExcelRecord.

cCurrGraphField = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelRecord C-Win 
PROCEDURE ExcelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN SUPER.

IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"useExcelViewer") = "yes" THEN
  PUBLISH "ExcelDataReady" (hBrowse).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelSheetParams C-Win 
PROCEDURE ExcelSheetParams :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihBrowse           AS HANDLE     NO-UNDO.
DEF INPUT PARAM chExcelApplication AS COM-HANDLE NO-UNDO.
DEF INPUT PARAM chWorkbook         AS COM-HANDLE NO-UNDO.
DEF INPUT PARAM chWorksheet        AS COM-HANDLE NO-UNDO.
DEF INPUT PARAM iCount             AS INT        NO-UNDO.

DEF VAR chChart              AS COM-HANDLE NO-UNDO.
DEF VAR chWorksheetRange     AS COM-HANDLE NO-UNDO.
DEF VAR cRange               AS CHAR       NO-UNDO.
DEF VAR cAccumFields         AS CHAR       NO-UNDO.
DEF VAR cDistinctFields      AS CHAR       NO-UNDO.
DEF VAR cYtext               AS CHAR       NO-UNDO.
DEF VAR iRange               AS INT        NO-UNDO.

IF ihBrowse NE hBrowse THEN RETURN.

IF cCurrGraphField = "" THEN RETURN.

IF VALID-HANDLE(hParent) AND CAN-DO(hParent:INTERNAL-ENTRIES,"ExcelSheetParams") AND hParent:FILE-NAME NE THIS-PROCEDURE:FILE-NAME THEN RETURN.

cRange = "A1:B" + STRING(iCount).

chWorksheetRange = chWorksheet:Range(cRange).
chWorksheet:ChartObjects:Add(10,150,425,300):Activate.
chExcelApplication:ActiveChart:ChartWizard(chWorksheetRange, 3, 1, 2, 1, 1, TRUE,
    IF NOT fiCurrentQuery:HIDDEN IN FRAME {&FRAME-NAME} THEN fiCurrentQuery:SCREEN-VALUE ELSE THIS-PROCEDURE:CURRENT-WINDOW:TITLE,
    "",
    "").

chExcelApplication:VISIBLE = TRUE.
chExcelApplication:ActiveChart:PrintPreview(0).

/* release com-handles */
RELEASE OBJECT chChart NO-ERROR.
RELEASE OBJECT chWorksheetRange NO-ERROR.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExtraFlatViewRecord C-Win 
PROCEDURE ExtraFlatViewRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM ihFlatView  AS HANDLE NO-UNDO.
DEF OUTPUT PARAM obOk        AS LOG    NO-UNDO.

DEF VAR hNewBrwPlaceHolder  AS HANDLE NO-UNDO.
DEF VAR cBaseQuery          AS CHAR   NO-UNDO.
DEF VAR cQueryFilter        AS CHAR   NO-UNDO.
DEF VAR cBrowseColumn       AS CHAR   NO-UNDO.
DEF VAR cBufferColumn       AS CHAR   NO-UNDO.
DEF VAR cDistinctCols       AS CHAR   NO-UNDO.
DEF VAR cCalcFields         AS CHAR   NO-UNDO.
DEF VAR cBuffDistinct       AS CHAR   NO-UNDO.
DEF VAR cCalcDistinct       AS CHAR   NO-UNDO.
DEF VAR cBufferList         AS CHAR   NO-UNDO.
DEF VAR cFieldBuffer        AS CHAR   NO-UNDO.
DEF VAR cDBfield            AS CHAR   NO-UNDO.
DEF VAR cCalcFieldFilter    AS CHAR   NO-UNDO.
DEF VAR cBuffPreScanQry     AS CHAR   NO-UNDO EXTENT 20.
DEF VAR cPreScanValue       AS CHAR   NO-UNDO.
DEF VAR cCurrPreScanQry     AS CHAR   NO-UNDO.
DEF VAR cPrescanQuery       AS CHAR   NO-UNDO.
DEF VAR cPreScanQueryFilter AS CHAR   NO-UNDO.
DEF VAR cWindowTitle        AS CHAR   NO-UNDO.
DEF VAR hNewBrowse          AS HANDLE NO-UNDO.
DEF VAR hNewFilterButton    AS HANDLE NO-UNDO.
DEF VAR hNewToolbar         AS HANDLE NO-UNDO.
DEF VAR cActiveFilterButton AS CHAR   NO-UNDO.
DEF VAR cCalcFilterTitle    AS CHAR   NO-UNDO.
DEF VAR iz                  AS INT    NO-UNDO.
DEF VAR cFilterExclude      AS CHAR   NO-UNDO.
DEF VAR cOperatorAttributes AS CHAR   NO-UNDO.
DEF VAR cFieldsForOperators AS CHAR   NO-UNDO.
DEF VAR cFieldsInUse        AS CHAR   NO-UNDO.
DEF VAR cOperatorsInUse     AS CHAR   NO-UNDO.
DEF VAR hColumn             AS HANDLE NO-UNDO.
DEF VAR cLastPreScan        AS CHAR   NO-UNDO.
DEF VAR cModBuffsAndFlds    AS CHAR   NO-UNDO.
DEF VAR cModQueryJoin       AS CHAR   NO-UNDO.
DEF VAR cModBaseQuery       AS CHAR   NO-UNDO.
DEF VAR cModSkipUnique      AS CHAR   NO-UNDO.
DEF VAR cNewCurrFields      AS CHAR   NO-UNDO.
DEF VAR cModCurrFields      AS CHAR   NO-UNDO.
DEF VAR cCurrViewFields     AS CHAR   NO-UNDO.
DEF VAR hTT                 AS HANDLE NO-UNDO.
DEF VAR hNewTT              AS HANDLE NO-UNDO.

IF bNoDrillDown THEN DO:
  DYNAMIC-FUNCTION("DoMessage",0,0,
                   (IF DYNAMIC-FUNCTION("Scandinavian") THEN
                     "Drill-down er ikke tilgjengelig for denne spørringen"
                    ELSE
                     "Drill-down not available for this query"),"","").
  obOk = NO.
  RETURN.
END.

cCurrViewFields = DYNAMIC-FUNCTION("getAttribute",hBrowse,"currviewfields").

/* If the buffer sequence has been modified for query speed, swap back to design sequence here: */
IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"orgbuffersandfields") NE "" THEN DO:
  ASSIGN cModBuffsAndFlds = DYNAMIC-FUNCTION("getAttribute",hBrowse,"buffersandfields")
         cModQueryJoin    = DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryjoin")
         cModBaseQuery    = DYNAMIC-FUNCTION("getAttribute",hBrowse,"basequery")
         cModSkipUnique   = DYNAMIC-FUNCTION("getAttribute",hBrowse,"skipuniquerows")
         .
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"SkipUniqueRows","").
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"buffersandfields",DYNAMIC-FUNCTION("getAttribute",hBrowse,"orgbuffersandfields")).
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"queryjoin",DYNAMIC-FUNCTION("getAttribute",hBrowse,"orgqueryjoin")).
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"basequery",DYNAMIC-FUNCTION("getAttribute",hBrowse,"orgbasequery")).
END.

ASSIGN hNewBrwPlaceHolder = DYNAMIC-FUNCTION("getBrowseHandle" IN ihFlatView)
       cBaseQuery         = DYNAMIC-FUNCTION("getAttribute",hBrowse,"basequery")
       cQueryFilter       = DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryfilter")
       cDistinctCols      = DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns")
       cCalcFields        = DYNAMIC-FUNCTION("getAttribute",hBrowse,"allcalcfields")
       cBufferList        = DYNAMIC-FUNCTION("getAttribute",hBrowse,"bufferlist")
       cBuffDistinct      = IF cBaseQuery MATCHES "*WHERE *" THEN " AND" ELSE " WHERE"
       cFilterExclude     = DYNAMIC-FUNCTION("getAttribute",hBrowse,"filterexcludefields")
       .

IF cBufferList BEGINS "TEMP-TABLE " THEN cBufferList = SUBSTR(cBufferList,12).

DO ix = 1 TO hBrowse:NUM-COLUMNS:
  ASSIGN
    cBrowseColumn = hBrowse:GET-BROWSE-COLUMN(ix):NAME
    cBufferColumn = IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"orgdbfield" + hBrowse:GET-BROWSE-COLUMN(ix):NAME) NE "" THEN 
                      DYNAMIC-FUNCTION("getAttribute",hBrowse,"orgdbfield" + hBrowse:GET-BROWSE-COLUMN(ix):NAME)
                    ELSE
                      cBrowseColumn
    cFieldBuffer  = DYNAMIC-FUNCTION("getAttribute",hBrowse,"fieldbuffer" + cBrowseColumn)
                    .
  IF CAN-DO(cDistinctCols,cBrowseColumn) AND
     ((NOT CAN-DO(cCalcFields,cBrowseColumn) AND LOOKUP(cFieldBuffer,cBufferList) = 1) 
       OR DYNAMIC-FUNCTION("getAttribute",hBrowse,"originaltemptable") NE "") THEN DO:
//       OR DYNAMIC-FUNCTION("getAttribute",hBrowse,"switchedToLocal") = "yes") THEN DO:
    ASSIGN cBuffDistinct  = cBuffDistinct + " " + cBrowseColumn + " = "
           cFilterExclude = cFilterExclude + "," + cBrowseColumn.
    CASE hBrowse:GET-BROWSE-COLUMN(ix):DATA-TYPE:
      WHEN "CHARACTER" THEN cBuffDistinct = cBuffDistinct + QUOTER(hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE).
      WHEN "DATE"      THEN cBuffDistinct = cBuffDistinct + "DATE('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "DECIMAL"   THEN cBuffDistinct = cBuffDistinct + "DECIMAL('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "INTEGER"   THEN cBuffDistinct = cBuffDistinct + "INTEGER('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "INT64"     THEN cBuffDistinct = cBuffDistinct + "INT64('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "LOGICAL"   THEN cBuffDistinct = cBuffDistinct + "LOGICAL('" + hBrowse:GET-BROWSE-COLUMN(ix):INPUT-VALUE + "')".
    END CASE.
    cBuffDistinct = cBuffDistinct + " AND".
  END.
  ELSE IF CAN-DO(cDistinctCols,cBrowseColumn) AND CAN-DO(cCalcFields,cBrowseColumn) THEN 
    ASSIGN cCalcFieldFilter = cCalcFieldFilter + cBrowseColumn + "¤=¤" 
                            + (IF hBrowse:GET-BROWSE-COLUMN(ix):INPUT-VALUE NE ? THEN
                                 REPLACE(hBrowse:GET-BROWSE-COLUMN(ix):INPUT-VALUE,",",CHR(1))
                               ELSE "?")  
                            + "|"
           cFilterExclude   = cFilterExclude + "," + cBrowseColumn
           cCalcFilterTitle = cCalcFilterTitle + " AND " +
                       (IF cBrowseColumn BEGINS "jb_month_" THEN "MONTH(" + SUBSTR(cBrowseColumn,10) + ")"
                        ELSE IF cBrowseColumn BEGINS "jb_quarter_" THEN "QUARTER(" + SUBSTR(cBrowseColumn,12) + ")"
                        ELSE IF cBrowseColumn BEGINS "jb_week_" THEN "WEEK(" + SUBSTR(cBrowseColumn,9) + ")"
                        ELSE IF cBrowseColumn BEGINS "jb_year_" THEN "YEAR(" + SUBSTR(cBrowseColumn,9) + ")"
                        ELSE cBrowseColumn) + " = " 
                      + (IF hBrowse:GET-BROWSE-COLUMN(ix):INPUT-VALUE NE ? THEN
                           REPLACE(hBrowse:GET-BROWSE-COLUMN(ix):INPUT-VALUE,",",CHR(1))
                         ELSE "?")  
                        .
  ELSE IF CAN-DO(cDistinctCols,cBrowseColumn) AND LOOKUP(cFieldBuffer,cBufferList) > 1 THEN DO:
    cFilterExclude = cFilterExclude + "," + cBrowseColumn.
    CASE hBrowse:GET-BROWSE-COLUMN(ix):DATA-TYPE:
      WHEN "CHARACTER" THEN cPreScanValue = QUOTER(REPLACE(hBrowse:GET-BROWSE-COLUMN(ix):INPUT-VALUE,",",CHR(1))).
      WHEN "DATE"      THEN cPreScanValue = "DATE('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "DECIMAL"   THEN cPreScanValue = "DECIMAL('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "INTEGER"   THEN cPreScanValue = "INTEGER('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "INT64"     THEN cPreScanValue = "INT64('" + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE + "')".
      WHEN "LOGICAL"   THEN cPreScanValue = "LOGICAL('" + hBrowse:GET-BROWSE-COLUMN(ix):INPUT-VALUE + "')".
    END CASE.
    cBuffPreScanQry[LOOKUP(cFieldBuffer,cBufferList)] = cBuffPreScanQry[LOOKUP(cFieldBuffer,cBufferList)] +
       (IF cBuffPreScanQry[LOOKUP(cFieldBuffer,cBufferList)] NE "" THEN " AND " ELSE cFieldBuffer + ".") +
       cBufferColumn + " = " + REPLACE(cPreScanValue,",",CHR(1)).
  END.

  IF CAN-DO(cDistinctCols,cBrowseColumn) THEN
    cWindowTitle = cWindowTitle
                 + (IF cWindowTitle NE "" THEN ", " ELSE "") 
                 + DYNAMIC-FUNCTION("getBrowseColumnLabel",hBrowse,cBrowseColumn) + " = " + hBrowse:GET-BROWSE-COLUMN(ix):SCREEN-VALUE. 
  
END.
IF LENGTH(cBuffDistinct) > 6 THEN
  cBuffDistinct = RIGHT-TRIM(cBuffDistinct," AND").
ELSE cBuffDistinct = "".

DO ix = 1 TO 20:
  IF cBuffPreScanQry[ix] NE "" THEN DO:
    IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"prescanquery" + ENTRY(ix,cBufferList)) NE "" THEN DO:
      cPrescanQuery = DYNAMIC-FUNCTION("getAttribute",hBrowse,"prescanquery" + ENTRY(ix,cBufferList)).
      DO iz = 1 TO 5:
        cPreScanQuery = REPLACE(cPreScanQuery,"  "," ").
      END.

      ASSIGN cPreScanQuery   = REPLACE(cPreScanQuery,",FIRST","¤FIRST")
             cPreScanQuery   = REPLACE(cPreScanQuery,", FIRST","¤FIRST")
             cPreScanQuery   = REPLACE(cPreScanQuery,",LAST","¤LAST")
             cPreScanQuery   = REPLACE(cPreScanQuery,", LAST","¤LAST")
             cPreScanQuery   = REPLACE(cPreScanQuery,",EACH","¤EACH")
             cPreScanQuery   = REPLACE(cPreScanQuery,", EACH","¤EACH")
             cPrescanQuery = ENTRY(ix,cBufferList) + " WHERE " + cBuffPreScanQry[ix] + "," + cPrescanQuery
             .
      DO iz = 1 TO NUM-ENTRIES(cPreScanQuery,"¤"):
        IF iz < NUM-ENTRIES(cPreScanQuery,"¤") THEN
          cCurrPreScanQry = cCurrPreScanQry + ENTRY(iz,cPreScanQuery,"¤") + ",".
        ELSE
          cPreScanQuery = ENTRY(iz,cPreScanQuery,"¤").
      END.
      ASSIGN cLastPreScan  = cPrescanQuery
             cPreScanQuery = cPrescanQuery + " " + (IF cBaseQuery   BEGINS "WHERE " AND cLastPreScan MATCHES "* WHERE *" THEN "AND " + SUBSTR(cBaseQuery,7) ELSE cBaseQuery)  
             cPreScanQuery = cPrescanQuery + " " + (IF cQueryFilter BEGINS "WHERE " AND cLastPreScan MATCHES "* WHERE *" THEN "AND " + SUBSTR(cQueryFilter,7) ELSE cQueryFilter)  
             cCurrPreScanQry = cCurrPreScanQry + cPrescanQuery + CHR(28).
    END.
    ELSE 
      ASSIGN cPrescanQuery = ENTRY(ix,cBufferList) + " WHERE " + cBuffPreScanQry[ix] + ",EACH " + DYNAMIC-FUNCTION("getAttribute",hBrowse,"basetable") + " NO-LOCK OF " + ENTRY(ix,cBufferList)
             cCurrPreScanQry = cCurrPreScanQry + cPrescanQuery + " " + DYNAMIC-FUNCTION("getAttribute",hBrowse,"basequery") + DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryfilter") + CHR(28)
             .

/*     cWindowTitle    = cWindowTitle + ENTRY(1,cPrescanQuery) + ", ". */
  END.
END.

cOperatorAttributes = DYNAMIC-FUNCTION("getAttributeList",hBrowse,"operatorInUse_","",NO).
IF cOperatorAttributes NE "|" THEN DO:
  ASSIGN cFieldsForOperators = ENTRY(1,cOperatorAttributes,"|")
         cOperatorAttributes = ENTRY(2,cOperatorAttributes,"|").
  IF cWindowTitle = "" THEN DO:       
    DO ix = 1 TO NUM-ENTRIES(cFieldsForOperators):
      cWindowTitle = cWindowTitle + DYNAMIC-FUNCTION("getBrowseColumnLabel",hBrowse,
                                                     SUBSTR(ENTRY(ix,cFieldsForOperators),R-INDEX(ENTRY(ix,cFieldsForOperators),"_") + 1))
                                  + " " + ENTRY(ix,cOperatorAttributes,CHR(1))
                                  + " " + DYNAMIC-FUNCTION("getAttribute",hBrowse,"filtervalue" +
                                                           SUBSTR(ENTRY(ix,cFieldsForOperators),INDEX(ENTRY(ix,cFieldsForOperators),"_")))
                                  + ", ".
    END.
    cWindowTitle = REPLACE(TRIM(cWindowTitle,", "),CHR(1),",").
  END.  
END.
ELSE IF cWindowTitle = "" THEN
  cWindowTitle = TRIM(
                 TRIM(cWindowTitle + DYNAMIC-FUNCTION("getAttribute",hBrowse,"prescanqueryfilter"),",")
                    + DYNAMIC-FUNCTION("getAttribute",hBrowse,"basetable") + " "
                    + (IF TRIM(DYNAMIC-FUNCTION("getAttribute",hBrowse,"basequery") + DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryfilter")) = "where true" THEN " WHERE "
                       ELSE DYNAMIC-FUNCTION("getAttribute",hBrowse,"basequery") + DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryfilter") + " ")
                    + TRIM(cBuffDistinct,"AND ") + " "
                    + cCalcFilterTitle
                 ,"where ")
                  .

DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"prescanqueryfilter",TRIM(cCurrPreScanQry + CHR(28) + DYNAMIC-FUNCTION("getAttribute",hBrowse,"prescanqueryfilter"),CHR(28))).
DO ix = 1 TO NUM-ENTRIES(cBufferList):
  DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"prescanquery" + ENTRY(ix,cBufferList),DYNAMIC-FUNCTION("getAttribute",hBrowse,"prescanquery" + ENTRY(ix,cBufferList))).
END.

DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"availdistinctcolumns",DYNAMIC-FUNCTION("getAttribute",hBrowse,"availdistinctcolumns")).
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"availaccumfields",DYNAMIC-FUNCTION("getAttribute",hBrowse,"availaccumfields")).
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"accumdatatypes",DYNAMIC-FUNCTION("getAttribute",hBrowse,"accumdatatypes")).
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"distinctdatatypes",DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctdatatypes")).
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"calcfieldfilter",TRIM(cCalcFieldFilter + "|" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"calcfieldfilter"),"|")).

DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"originaltemptable",DYNAMIC-FUNCTION("getAttribute",hBrowse,"originaltemptable")).
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"distinctcolumns",cCurrFlatDistinct).
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"accumfields",cCurrFlatAccum).
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"filterexcludefields",TRIM(cFilterExclude,",")).

IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlDbName") NE "" THEN 
  DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"sqlbufferlist",TRIM(cBufferList,",")).

DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FieldGroup_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FieldOperator_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FilterLookupFields_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FilterLookupQuery_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FilterLookupReturnField_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FilterValue_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FilterDropdownFields_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FilterDropdownQuery_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"FilterDropDownValueList_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"GroupOperator_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"HiddenGroupOperator_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"OperatorInUse_").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"querysort").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"localsort").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"disabledrilldownfilter").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"usersettingcontext").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"prescanlimit").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"calcparam").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"calcphrase").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"shadedRows").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"WindowsBrowse").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"numbuffers").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"switchedToLocal").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"fieldBuffer").
IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"switchedToLocal") = "yes" THEN
  DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"useLocalData","yes").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"grid").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"prescanquerywhere").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrwPlaceHolder,"filterExcludeFields").


ihFlatView:CURRENT-WINDOW:TITLE = cTitlePrefixDetails + " "
/*         (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Detaljer: " ELSE "Details: ") */
        + cWindowTitle.

DYNAMIC-FUNCTION("setWordButton" IN ihFlatView,bWordButton).
DYNAMIC-FUNCTION("setExcludeFields" IN ihFlatView,cDistinctCols).

DYNAMIC-FUNCTION("setRowsToBatch" IN ihFlatView,iRowsToBatch).

DYNAMIC-FUNCTION("setUseStdAppserver" IN ihFlatView,YES).

/* No load of userfilter when doing drill-down.. */
DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"usersettingcontext","-").

IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlDbName") NE "" 
   OR DYNAMIC-FUNCTION("getAttribute",hNewBrwPlaceHolder,"originaltemptable") NE ""
   OR DYNAMIC-FUNCTION("getAttribute",hBrowse,"switchedToLocal") = "yes" THEN DO:
  IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlDbName") NE ""
     OR DYNAMIC-FUNCTION("getAttribute",hBrowse,"switchedToLocal") = "yes" THEN
    hTT = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"temptablehandle")).
  ELSE   
    hTT = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"originalTempTable")).
  CREATE TEMP-TABLE hNewTT.
  hNewTT:CREATE-LIKE (hTT).
  hNewTT:TEMP-TABLE-PREPARE (hTT:NAME).
  DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"temptablehandle",STRING(hNewTT)).
  DYNAMIC-FUNCTION("setAttribute",hNewBrwPlaceHolder,"sqlDbName",DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlDbName")).
END.  


RUN InitializeObject IN ihFlatView (DYNAMIC-FUNCTION("getAttribute",hBrowse,"buffersandfields"),"where false" + 
                                      DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryjoin")
                                     ,"", 
                                   TRUE).

hNewBrowse       = DYNAMIC-FUNCTION("getBrowseHandle" IN ihFlatView).

hNewBrowse:SEPARATORS = hBrowse:SEPARATORS.

hNewBrowse:HELP = ihFlatView:CURRENT-WINDOW:TITLE.

DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrowse,"baseQuery").
DYNAMIC-FUNCTION("AppendAttribute",hNewBrowse,"baseQuery",cBuffDistinct + " "," ").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrowse,"queryFilter").
IF DYNAMIC-FUNCTION("getAttribute",hNewBrowse,"queryFilter") BEGINS "WHERE " AND DYNAMIC-FUNCTION("getAttribute",hNewBrowse,"baseQuery") NE "" THEN
  DYNAMIC-FUNCTION("setAttribute",hNewBrowse,"queryFilter"," AND" + SUBSTR(DYNAMIC-FUNCTION("getAttribute",hNewBrowse,"queryFilter"),6)).
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrowse,"queryWhere").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrowse,"allCalcFields").

//IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"tempTableHandle") NE "" THEN 
//  hNewBrowse:QUERY:GET-BUFFER-HANDLE (1):TABLE-HANDLE:COPY-TEMP-TABLE (hBrowse:QUERY:GET-BUFFER-HANDLE(1):TABLE-HANDLE,NO,NO,YES).  
//  run toexcelviafile.p (hBrowse:QUERY:GET-BUFFER-HANDLE(1):TABLE-HANDLE,0).
  
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrowse,"sqlDbName").
DYNAMIC-FUNCTION("CopyAttributes",hBrowse,hNewBrowse,"sqlView").
  
IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlDbName") NE "" THEN DO:
  DYNAMIC-FUNCTION("setAttribute",hNewBrowse,"uselocaldata","").
  DYNAMIC-FUNCTION("setAttribute",hNewBrowse,"temptablehandle",STRING(hNewBrowse:QUERY:GET-BUFFER-HANDLE (1):TABLE-HANDLE)).
END.  

DYNAMIC-FUNCTION("RemoveUseIndex",hNewBrowse).

RUN InvokeMethod(hNewBrowse,"openQuery").

hNewFilterButton = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",DYNAMIC-FUNCTION("getLinkedObject",hNewBrowse,"toolbar","from"),"buttonFilter")).
hNewToolbar      = DYNAMIC-FUNCTION("getLinkedObject",hNewBrowse,"toolbar","from").

DYNAMIC-FUNCTION("setAttribute",hNewBrowse,"filterexcludefields",TRIM(cFilterExclude,",")).

IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryfilter") NE "" OR 
   DYNAMIC-FUNCTION("getAttribute",hBrowse,"prescanqueryfilter") NE "" OR 
   DYNAMIC-FUNCTION("getAttribute",hBrowse,"calcfieldfilter") NE "" THEN DO:
  cActiveFilterButton = DYNAMIC-FUNCTION("getAttribute",SESSION,"ActiveFilterButton").
  IF VALID-HANDLE(hNewFilterButton) AND cActiveFilterButton NE "" THEN
    hNewFilterButton:LOAD-IMAGE(cActiveFilterButton) NO-ERROR.
END.

DYNAMIC-FUNCTION("setAttribute",hNewToolbar,"disabledevents","browseconfig,filter").
DYNAMIC-FUNCTION("setAttribute",hNewToolbar,"permanentdisabledevents","browseconfig,filter").

IF cCurrFlatDistinct NE "" THEN DO:
  hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hNewBrowse,"jbCountDistinct").
  IF VALID-HANDLE(hColumn) THEN hColumn:VISIBLE = YES.

  IF cCurrFlatAccum NE "" AND NUM-ENTRIES(cCurrFlatAccum) = 1 THEN DO:
    hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hNewBrowse,"jbAverage").
    IF VALID-HANDLE(hColumn) THEN hColumn:VISIBLE = YES.
  END.

  DYNAMIC-FUNCTION("setBrowseColumns",hNewBrowse,
                   cCurrFlatDistinct + (IF cCurrFlatAccum NE "" AND NUM-ENTRIES(cCurrFlatAccum) = 1 THEN 
                                          "," + cCurrFlatAccum + ",jbCountDistinct,jbAverage" 
                                        ELSE IF cCurrFlatAccum NE "" THEN
                                          "," + cCurrFlatAccum + ",jbCountDistinct" 
                                        ELSE ",jbCountDistinct"),NO).    
  RUN DynAccumDone IN ihFlatView (hNewBrowse,"accum").
  DYNAMIC-FUNCTION("setAttribute",hNewBrowse,"uselocaldata","yes").
END.

APPLY "value-changed" TO hNewBrowse.

DYNAMIC-FUNCTION("DeleteObject",DYNAMIC-FUNCTION("getLinkedObject",hNewBrowse,"browse-search-field","from")).

IF DYNAMIC-FUNCTION("getAttribute",hNewBrowse,"currviewfields") = "" THEN 
  DYNAMIC-FUNCTION("setBrowseColumns",hNewBrowse,DYNAMIC-FUNCTION("getAttribute",hBrowse,"allviewfields"),NO).
ELSE DO:
  cNewCurrFields = DYNAMIC-FUNCTION("getAttribute",hNewBrowse,"currviewfields").
  DO ix = 1 TO NUM-ENTRIES(cCurrViewFields):
    IF CAN-DO(cNewCurrFields,ENTRY(ix,cCurrViewFields)) AND 
       NOT CAN-DO(cDistinctCols,ENTRY(ix,cCurrViewFields)) AND
       NOT ENTRY(ix,cCurrViewFields) BEGINS "jbph2_"
       THEN
      cModCurrFields = cModCurrFields + ENTRY(ix,cCurrViewFields) + ",".
  END.
  cModCurrFields = TRIM(cModCurrFields,",").
  IF cModCurrFields NE "" THEN DO:
    DYNAMIC-FUNCTION("setAttribute",hNewBrowse,"currviewfields",cModCurrFields).
    DYNAMIC-FUNCTION("setBrowseColumns",hNewBrowse,cModCurrFields,NO).
  END.
END.
DYNAMIC-FUNCTION("setAttribute",hNewBrowse,"allviewfields",DYNAMIC-FUNCTION("getAttribute",hBrowse,"allviewfields")).

DYNAMIC-FUNCTION("swapObjectHandle",hNewBrwPlaceHolder,hNewBrowse).

PUBLISH "SizeToFitTab" (hNewBrowse:WINDOW).
PUBLISH "DrillFromToBrowse" (hBrowse,ihFlatView,hNewBrowse).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExtraStartSearch C-Win 
PROCEDURE ExtraStartSearch :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM ihBrowse      AS HANDLE NO-UNDO.
DEF INPUT  PARAM icColumnName  AS CHAR   NO-UNDO.
DEF INPUT  PARAM ibDesc        AS LOG    NO-UNDO.
DEF OUTPUT PARAM obOk          AS LOG    NO-UNDO INIT YES.

PUBLISH "DataBrwExtraStartSearch" (ihBrowse,icColumnName,ibDesc,OUTPUT obOk).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FillTimeSeriesRecord C-Win 
PROCEDURE FillTimeSeriesRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hqTime       AS HANDLE NO-UNDO.
DEF VAR cDistinctCol AS CHAR NO-UNDO.
DEF VAR cCalcProc    AS CHAR NO-UNDO.
DEF VAR ix           AS INT  NO-UNDO.
DEF VAR iy           AS INT  NO-UNDO.
DEF VAR iPrevVal     AS INT  NO-UNDO.
DEF VAR cValue       AS CHAR NO-UNDO.
DEF VAR iValue       AS INT  NO-UNDO.
DEF VAR hBuffer      AS HANDLE NO-UNDO.
DEF VAR hTT          AS HANDLE NO-UNDO.
DEF VAR iFirstYear   AS INT NO-UNDO.
DEF VAR iLastYear    AS INT NO-UNDO.

cDistinctCol = DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns").
cCalcProc = DYNAMIC-FUNCTION("getAttribute",hBrowse,"calcProc" + cDistinctCol).

IF NOT CAN-DO("jb_year,jb_quarter,jb_month,jb_weeknum",cCalcProc) THEN DO:
  JBoxSession:Instance:ViewMessage(IF JBoxSession:Instance:Scandinavian THEN "Ugyldig kolonne for aggregeringsnivå (kan kun være kalkulert år/kvartal/mnd/uke)" ELSE "Invalid level for aggregation (can only be calculated year/quarter/month/week").
  RETURN.
END.  

hBuffer = hBrowse:QUERY:GET-BUFFER-HANDLE(1).

CREATE TEMP-TABLE hTT.
hTT:CREATE-LIKE(hBuffer).
hTT:TEMP-TABLE-PREPARE ("firstRow").

CREATE QUERY hqTime.
hqTime:SET-BUFFERS (hBuffer).
hqTime:QUERY-PREPARE ("FOR EACH " + hBuffer:NAME + " BY " + cDistinctCol).
hqTime:QUERY-OPEN ().
REPEAT WHILE hqTime:GET-NEXT ():
  IF iFirstYear = 0 THEN DO:
    iFirstYear = INT(SUBSTR(hBuffer:BUFFER-FIELD(cDistinctCol):BUFFER-VALUE,1,4)).
    hTT:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE ().
    hTT:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(hBuffer).
  END.  
  iLastYear = INT(SUBSTR(hBuffer:BUFFER-FIELD(cDistinctCol):BUFFER-VALUE,1,4)).
END.

DO ix = iFirstYear TO iLastYear:
  CASE cCalcProc:
    WHEN "jb_year" THEN DO:
      hBuffer:FIND-FIRST("WHERE " + cDistinctCol + " = '" + STRING(ix) + "'") NO-ERROR.
      IF NOT hBuffer:AVAIL THEN DO:
        hBuffer:BUFFER-CREATE().
        hBuffer:BUFFER-COPY (hTT:DEFAULT-BUFFER-HANDLE).
        ASSIGN hBuffer:BUFFER-FIELD(cDistinctCol):BUFFER-VALUE = STRING(ix)
               hBuffer::jbCountDistinct = 0
               hBuffer::RowIdent1 = STRING(ix)
               hBuffer::RowCount = INT(STRING(ix))
               .
      END.          
    END.
    WHEN "jb_quarter" THEN DO iy = 1 TO 4:
      hBuffer:FIND-FIRST("WHERE " + cDistinctCol + " = '" + STRING(ix) + "Q" + STRING(iy) + "'") NO-ERROR.
      IF NOT hBuffer:AVAIL THEN DO:
        hBuffer:BUFFER-CREATE().
        hBuffer:BUFFER-COPY (hTT:DEFAULT-BUFFER-HANDLE).
        ASSIGN hBuffer:BUFFER-FIELD(cDistinctCol):BUFFER-VALUE = STRING(ix) + "Q" + STRING(iy)
               hBuffer::jbCountDistinct = 0
               hBuffer::RowIdent1 = STRING(ix) + STRING(iy)
               hBuffer::RowCount = INT(STRING(ix) + STRING(iy))
               .
      END.
    END.
    WHEN "jb_month" THEN DO iy = 1 TO 12:
      hBuffer:FIND-FIRST("WHERE " + cDistinctCol + " = '" + STRING(ix) + STRING(iy,"99") + "'") NO-ERROR.
      IF NOT hBuffer:AVAIL THEN DO:
        hBuffer:BUFFER-CREATE().
        hBuffer:BUFFER-COPY (hTT:DEFAULT-BUFFER-HANDLE).
        ASSIGN hBuffer:BUFFER-FIELD(cDistinctCol):BUFFER-VALUE = STRING(ix) + STRING(iy,"99")
               hBuffer::jbCountDistinct = 0
               hBuffer::RowIdent1 = STRING(ix) + STRING(iy,"99")
               hBuffer::RowCount = INT(STRING(ix) + STRING(iy,"99"))
               . 
      END.  
    END.    
    WHEN "jb_weeknum" THEN DO iy = 1 TO 52:
      hBuffer:FIND-FIRST("WHERE " + cDistinctCol + " = '" + STRING(ix) + STRING(iy,"99") + "'") NO-ERROR.
      IF NOT hBuffer:AVAIL THEN DO:
        hBuffer:BUFFER-CREATE().
        hBuffer:BUFFER-COPY (hTT:DEFAULT-BUFFER-HANDLE).
        ASSIGN hBuffer:BUFFER-FIELD(cDistinctCol):BUFFER-VALUE = STRING(ix) + STRING(iy,"99")
               hBuffer::jbCountDistinct = 0
               hBuffer::RowIdent1 = STRING(ix) + STRING(iy,"99")
               hBuffer::RowCount = INT(STRING(ix) + STRING(iy,"99"))
               . 
      END.  
    END.    
  END CASE.
END.

ix = 0.
hqTime:QUERY-OPEN ().
REPEAT WHILE hqTime:GET-NEXT ():
  ix = ix + 1.
  hBuffer::RowCount = ix.
END.

hBrowse:QUERY:QUERY-OPEN().  

DELETE OBJECT hqTime.
DELETE OBJECT hTT.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FilterRecord C-Win 
PROCEDURE FilterRecord :
/*------------------------------------------------------------------------------
  Purpose:    To enable the filter to assign the correct value for source-buffer for the fields 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR bLocal AS LOG NO-UNDO.

IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"uselocaldata") = "yes" THEN DO:
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"uselocaldata","").
  bLocal = YES.
END.

RUN SUPER.

IF bLocal THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"uselocaldata","yes").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icBuffersAndFields AS CHAR NO-UNDO.
DEF INPUT PARAM icWhereString      AS CHAR NO-UNDO.
DEF INPUT PARAM icInitSort         AS CHAR NO-UNDO.
DEF INPUT PARAM ibRecordCount      AS LOG  NO-UNDO.

/* RUN enable_UI. */
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DEF VAR cNoColumnSearch   AS CHAR   NO-UNDO.
DEF VAR hBrwMenu          AS HANDLE NO-UNDO.
DEF VAR cInitFilter       AS CHAR   NO-UNDO.
DEF VAR cNavMenuLabel     AS CHAR   NO-UNDO.
DEF VAR cEditMenuLabel    AS CHAR   NO-UNDO.
DEF VAR cDefaultFrameFont AS CHAR   NO-UNDO.
DEF VAR cDefaultBrwFont   AS CHAR   NO-UNDO.
DEF VAR hAppServer        AS HANDLE NO-UNDO.
DEF VAR cQueryAppS        AS CHAR   NO-UNDO.
DEF VAR hExportMenu       AS HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  cDefaultFrameFont = DYNAMIC-FUNCTION("getAttribute",SESSION,"defaultFrameFont").
  IF cDefaultFrameFont NE "" THEN
    FRAME {&FRAME-NAME}:FONT = INTEGER(cDefaultFrameFont) NO-ERROR.
  cDefaultBrwFont = DYNAMIC-FUNCTION("getAttribute",SESSION,"defaultDataBrowseFont").
  IF cDefaultBrwFont = "" THEN
    cDefaultBrwFont = DYNAMIC-FUNCTION("getAttribute",SESSION,"defaultBrowseFont").

  IF ERROR-STATUS:ERROR THEN cDefaultBrwFont = "".

  ASSIGN fiCurrentQuery:LABEL   = (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Spørring" ELSE "Query")
         fiCurrentQuery:HIDDEN  = YES

  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
         
         fiCurrentQuery:SIDE-LABEL-HANDLE:Y = fiCurrentQuery:SIDE-LABEL-HANDLE:Y - 2
         cOrgWinTitle           = IF cOrgWinTitle = "" THEN THIS-PROCEDURE:CURRENT-WINDOW:TITLE ELSE cOrgWinTitle
         
  &endif         
         
         cInitSort              = icInitSort
         icInitSort             = IF NUM-ENTRIES(icInitSort,".") > 1 THEN TRIM(ENTRY(2,icInitSort,".")) ELSE TRIM(icInitSort)
         cTitlePrefixTotals     = IF DYNAMIC-FUNCTION("Scandinavian") THEN "Totalt pr:" ELSE "Totals pr:"
         cTitlePrefixDetails    = IF DYNAMIC-FUNCTION("Scandinavian") THEN "Detaljer:"  ELSE "Details:"
         .
  IF cOrgWinTitle BEGINS "Details: " THEN
    cQueryTitle = SUBSTR(cOrgWinTitle,10).
  ELSE IF cOrgWinTitle BEGINS "Detaljer: " THEN
    cQueryTitle = SUBSTR(cOrgWinTitle,11).

  IF NUM-ENTRIES(ENTRY(1,icBuffersAndFields),";") > 1 THEN
    icBuffersAndFields = ReduceFields(icBuffersAndFields).
    
  IF cInitFilterFields NE "" THEN DO:
    DO ix = 1 TO NUM-ENTRIES(cInitFilterFields):
      cInitFilter = cInitFilter + " AND "
                    + ENTRY(ix,cInitFilterFields) + " "
                    + ENTRY(ix,cInitFilterOperators) + " " 
                    + ENTRY(ix,cInitFilterValues,"|") 
                    .
    END.
  END.

  IF iRowsToBatch = 0 THEN
    iRowsToBatch = IF cUseLocalData = "yes" THEN 60000 ELSE 200.

  IF VALID-HANDLE(hParent) AND DYNAMIC-FUNCTION("getAttribute",BrwFlatView:HANDLE,"usersettingcontext") = "" THEN
    DYNAMIC-FUNCTION("setAttribute",BrwFlatView:HANDLE,"usersettingcontext",hParent:FILE-NAME).
  ELSE IF NOT VALID-HANDLE(hParent) AND DYNAMIC-FUNCTION("getAttribute",BrwFlatView:HANDLE,"usersettingcontext") = "" THEN
    DYNAMIC-FUNCTION("setAttribute",BrwFlatView:HANDLE,"disablesavefilter","yes").

  IF NOT bUseStdAppServer OR CAN-DO(DYNAMIC-FUNCTION("getAttribute",SESSION,"use_query_appservice"),THIS-PROCEDURE:FILE-NAME) THEN DO:
    IF DYNAMIC-FUNCTION("getAttribute",SESSION,"query_appservice") = "" THEN DO:
      cQueryAppS = DYNAMIC-FUNCTION("getAttribute",SESSION,"query_appservice_connect").
      IF cQueryAppS NE "" THEN DO:
        CREATE SERVER hAppServer.
        hAppServer:CONNECT(cQueryAppS) NO-ERROR.
        IF hAppServer:CLIENT-CONNECTION-ID NE "" THEN 
          DYNAMIC-FUNCTION("setAttribute",SESSION,"query_appservice",STRING(hAppServer)).
      END.
    END.      
    IF DYNAMIC-FUNCTION("getAttribute",SESSION,"query_appservice") NE "" THEN
      DYNAMIC-FUNCTION("setAttribute",BrwFlatView:HANDLE,"useAppserver","query_appservice").
  END.

  IF DYNAMIC-FUNCTION("getAttribute",BrwFlatView:HANDLE,"switchedToLocal") = "yes" THEN
    oContainer:statusBar:hHelpText:FRAME:BGCOLOR = 3.
  
  IF icInitSort NE "" THEN
    DYNAMIC-FUNCTION("setAttribute",BrwFlatView:HANDLE,"InitialSortString",icInitSort).
  /* Create the browse: */
  DO ON ERROR UNDO, THROW:
    hBrowse = DYNAMIC-FUNCTION("NewBrowse",
                             BrwFlatView:HANDLE, 
                             iRowsToBatch,
    &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
                             "MULTIPLE,!FIT-LAST-COLUMN" 
                           + (IF cDefaultBrwFont NE "" THEN "FONT|" + cDefaultBrwFont ELSE ""), 
    &else "",                          
    &endif
                             icBuffersAndFields,  
                             icWhereString + " " + cInitFilter,
                             (IF ibRecordCount AND DYNAMIC-FUNCTION("getAttribute",BrwFlatView:HANDLE,"getrecordcount") NE "no" THEN ",getrecordcount" ELSE "") + 
                             cInitCalcFieldProcs).
    CATCH eR AS Progress.Lang.Error :
        MESSAGE eR:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END.
  IF NOT VALID-OBJECT(oBrowse) AND hBrowse:TYPE = "browse" THEN 
    oBrowse = NEW JBoxBrowse(BrwFlatView:HANDLE,THIS-PROCEDURE,YES).
  IF VALID-OBJECT(oBrowse) THEN DO:  
    oBrowse:setBrowseHandle(hBrowse).
    oBrowse:DATABROWSE-PARENT-PROC = hParent.
    JBoxLookupDef:Instance:assignFilterLookup(oBrowse).
  END.  

  hBrowse:NAME = "JBoxDataBrw".
  /* If any field are excluded from the browse they should also be excluded from the filter: */
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"filterexcludefields",cExcludeFields).

  DYNAMIC-FUNCTION("setAttribute",hBrowse,"fieldTypeForLogicalSearchFields","combo-box").
//  DYNAMIC-FUNCTION("setAttribute",hBrowse,"searchdefault","filter").  
  
  IF icWhereString NE "where false" THEN DO:
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"basequery",DYNAMIC-FUNCTION("getAttribute",hBrowse,"querywhere")).
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"querywhere","").
  END.

  IF ibRecordCount THEN DYNAMIC-FUNCTION("setAttribute",hBrowse,"getrecordcount","yes").
  IF DYNAMIC-FUNCTION("getAttribute",SESSION,"useDataBrwRowShade") = "YES" THEN
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"shadedRows","YES").

  IF cExcludedList NE "" THEN DYNAMIC-FUNCTION("setAttribute",hBrowse,"excludedfieldposlist",cExcludedList).

  IF bDisableSaveFilter THEN DYNAMIC-FUNCTION("setAttribute",hBrowse,"disablesavefilter","yes").

  IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlDbName") NE "" AND
     DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlbufferlist") NE "" THEN 
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"bufferlist",DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlbufferlist")).

  /* If the extract should be treated as a temp-table after first retrieval from the database: */
  IF cUseLocalData = "yes" THEN
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"uselocaldata",cUseLocalData).
  ELSE DO:
    IF NOT bAccumFieldSort THEN
      DYNAMIC-FUNCTION("setNoColumnSort",hBrowse,DYNAMIC-FUNCTION("getAttribute",hBrowse,"allcalcfields")).
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"nocolumnsearch",
                     TRIM(DYNAMIC-FUNCTION("getAttribute",hBrowse,"alljoinviewfields") + "," + DYNAMIC-FUNCTION("getAttribute",hBrowse,"allcalcfields"),",")).
    DYNAMIC-FUNCTION("setAttribute",hBrowse,"prescanlimit","50000").
  END.

  IF cInitFilterFields NE "" THEN DO:
    DO ix = 1 TO NUM-ENTRIES(cInitFilterFields):
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"FilterField_" + ENTRY(ix,cInitFilterFields),TRIM(ENTRY(ix,cInitFilterValues,"|"),"'")).
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"FieldOperator_" + ENTRY(ix,cInitFilterFields),"AND").
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"operatorInUse_" + ENTRY(ix,cInitFilterFields),ENTRY(ix,cInitFilterOperators)).
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"filtervalue_" + ENTRY(ix,cInitFilterFields),TRIM(ENTRY(ix,cInitFilterValues,"|"),"'")).
    END.
  END.


  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  

/*  IF icInitSort NE "" THEN                     */
/*    CreateSearchField(ENTRY(1,icInitSort," ")).*/
/*  ELSE                                         */
    searchField:HIDDEN = TRUE.

  hBrwMenu = DYNAMIC-FUNCTION("NewMenuBand",
                   hBrowse,                                      /* Parent widget */
                   "MultiSortBrowse;"
                   + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Sorter på flere kolonner" ELSE "Sort on multiple columns")
                 + ",|" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Summér markerte rader" ELSE "Totals selected rows") 
                 + ",CopyToClipboard;"
                    + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Kopier markerte rader" ELSE "Copy seleced rows")
                 + ",DeselectRow;"
                    + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Fjern markering av rad" ELSE "Deselect rows")
                 + ",FillTimeSeries;"
                    + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Komplettér tids-serie" ELSE "Complete time series")
                 + ",|" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Excel graf" ELSE "Excel graph")
                 + ",SetQueryWhere;"
                    + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Sett egne spørrekriterier" ELSE "Set query crit") + "¤enable"
                 + ",RowsToBatch;"
                    + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Sett antall rader i resultatsett" ELSE "Set rows to batch") + "¤enable" 
                 + (IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"sqlDbName") = "" 
                       AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"tempTableHandle") = "" THEN
                     ",SwitchLocal;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Behold lokalt utvalg" ELSE "Keep local copy") + ";toggle"
                    ELSE "")
                 + (IF JBoxSession:Instance:SuperUser
                       AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"orgdbfieldLogUserQueryExec") NE "" 
                       AND bEnableSaveQuery AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "" AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "JBoxDataBrw.w" THEN
                     ",LogUserQueryExec;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Kjør lagret spørring med logging av parametere" ELSE "Exec. saved query with log of parameters")
                    ELSE "")
                 + ",ViewRow;"
                     + (IF JBoxSession:Instance:Scandinavian THEN "Vis rad som en kolonne" ELSE "View row as one column")    
                 + (IF JBoxSession:Instance:SuperUser THEN
                     ",|" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Vis alle felter" ELSE "View all fields")
                    ELSE "")  
                 + (IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"childwindow") NE "yes" THEN  
                      ",DrillInNewWin;" + (IF JBoxSession:Instance:Scandinavian THEN "Vis detaljer (drill-down) i nytt vindu" ELSE "View details (drill-down) in separate window")    
                    ELSE "")  
                 + ",|Export;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Eksporter" ELSE "Export")   
                   ,"").
                   
  hExportMenu = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"placeholder3")).
  DYNAMIC-FUNCTION("NewMenuBand",hExportMenu,
                   "ToCsv;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Til csv-fil" ELSE "To csv-file")
                 + ",ToJson;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Til Json-fil" ELSE "To Json-file")
                 + ",ToXml;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Til XML-fil" ELSE "To XML-file")
                   ,"").
                   
  hTotalsMenu       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"placeholder1")).
  hExcelGraph       = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"placeholder2")).
  hFillTimeSeries   = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"menu-itemFillTimeSeries")).
  IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"childwindow") NE "yes" THEN 
    hDrillInNewWindow = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"menu-itemDrillInNewWin")).
  hSwitchLocal      = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"menu-itemSwitchLocal")).  
    
  hExcelGraph:SENSITIVE = NO.
  hFillTimeSeries:SENSITIVE = NO.
  setTotalFieldsMenu("details").
  IF JBoxSession:Instance:SuperUser THEN DO:
    hViewTablesMenu = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"placeholder3")).
    setViewAllTablesMenu("details").
  END.  

  IF VALID-OBJECT(oBrowse) THEN 
    oBrowse:createGridFilter(oBrowse:filterExcludeFields).

  ASSIGN cNavMenuLabel  = IF DYNAMIC-FUNCTION("Scandinavian") THEN "Naviger" ELSE "Navigate"
         cEditMenuLabel = IF DYNAMIC-FUNCTION("Scandinavian") THEN "Rediger" ELSE "Edit".

  hToolbar = DYNAMIC-FUNCTION("NewToolbar",
                             rectToolbar:HANDLE,      
                             IF DYNAMIC-FUNCTION("Scandinavian") THEN "Fil" ELSE "File",      
                             (IF bEnableSaveQuery AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "" AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "JBoxDataBrw.w" THEN
                               "SaveNewQuery;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Lagre som ny spørring ctrl-n" ELSE "Save as new query ctrl-n") + ";;SaveNewQuery¤menu,"
                              ELSE "")
                           + (IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "" AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "JBoxDataBrw.w" THEN 
                               "BrowseConfig|" + cEditMenuLabel + ";" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Kolonneoppsett" ELSE "Browse config") + "," 
                              ELSE "")
                           + "excel" + (IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"useExcelViewer") = "yes" THEN
                                          ";Dump to dataview;;;" + 
                                           (IF DYNAMIC-FUNCTION("getAttribute",SESSION,"btnImg_excelViewer") NE "" THEN
                                              DYNAMIC-FUNCTION("getAttribute",SESSION,"btnImg_excelViewer")
                                            ELSE "bmp\spread16.bmp")
                                        ELSE "")
                           + ",filter|" + cEditMenuLabel
                           + (IF bAccumButton THEN 
                               ",accum|" + cEditMenuLabel + ";" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Akkumuler" ELSE "Accumulate") + "¤enable"
                              ELSE "")
                           + (IF bWordButton THEN ",word" ELSE "")
                           + (IF bPrintButton THEN ",print" ELSE "")
                           + (IF bEmailButton THEN ",email" ELSE "")
                           + (IF bSMSButton THEN ",SMS" ELSE "")
                           + (IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "" AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "JBoxDataBrw.w" THEN 
                               ",Count|" + cEditMenuLabel + ";" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Vis antall rader" ELSE "View record count") + ";toggle¤menu enable" 
                              ELSE "")
                           + ",showQuery|" + cEditMenuLabel + ";" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Vis siste spørring" ELSE "View last query") + ";¤menu enable" 
/*                            + ",rule"  */
/*                           + ",first|" + cNavMenuLabel + (IF DYNAMIC-FUNCTION("Scandinavian") THEN ";Første" ELSE "")    */
/*                              + ",prev|" + cNavMenuLabel + (IF DYNAMIC-FUNCTION("Scandinavian") THEN ";F&orrige" ELSE "")*/
/*                              + ",next|" + cNavMenuLabel + (IF DYNAMIC-FUNCTION("Scandinavian") THEN ";Neste" ELSE "")   */
/*                              + ",last|" + cNavMenuLabel + (IF DYNAMIC-FUNCTION("Scandinavian") THEN ";Siste" ELSE "")   */
                           + (IF bEnableSaveQuery AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "" AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") NE "JBoxDataBrw.w" THEN
                               ",|" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Mine spørringer" ELSE "My queries") + "¤menu"
                             + (IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"canShare") NE "NO" THEN
                                  ",|" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Delte spørringer" ELSE "Shared queries") + "¤menu"
                                ELSE "")  
                              ELSE "")
/*                            + ",rule" */
                            ,"maxborder").
  &ENDIF
                            
  DYNAMIC-FUNCTION("setObjectSourceFileHandle",hBrowse,THIS-PROCEDURE).                            

  hMyQueriesMenu = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"placeholder1")) NO-ERROR.
  hSharedQueriesMenu = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"placeholder2")) NO-ERROR.
  IF VALID-HANDLE(hMyQueriesMenu) THEN SetMyQueriesMenu().
  IF VALID-HANDLE(hSharedQueriesMenu) THEN SetSharedQueriesMenu().
  ASSIGN hFilterBtn        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonFilter"))
         cActiveFilterBtn  = DYNAMIC-FUNCTION("getAttribute",SESSION,"activefilterbutton") /*DYNAMIC-FUNCTION("getActiveFilterButtonFile")*/
         cPassiveFilterBtn = DYNAMIC-FUNCTION("getAttribute",SESSION,"passivefilterbutton")
         hAccumBtn         = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonAccum"))
         cActiveAccumBtn   = DYNAMIC-FUNCTION("getAttribute",SESSION,"activeaccumbutton")
         cPassiveAccumBtn  = DYNAMIC-FUNCTION("getAttribute",SESSION,"passiveaccumbutton")
         hConfigBtn        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonBrowseConfig"))
         cActiveConfigBtn  = DYNAMIC-FUNCTION("getAttribute",SESSION,"activeconfigbutton")
         cPassiveConfigBtn = DYNAMIC-FUNCTION("getAttribute",SESSION,"passiveconfigbutton")
//         hShowQuery        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"menu-itemShowQuery"))
         .

  hMenuItemCountRows = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"menu-itemCount")) NO-ERROR.
  IF VALID-HANDLE(hMenuItemCountRows) THEN
    hMenuItemCountRows:CHECKED = ibRecordCount.
  
  /* If the filter values should be set in custom .w: */
  DYNAMIC-FUNCTION("setAttribute",hToolbar,"filterwindow",cCustomFilter).

  IF cInitFilterFields NE "" THEN 
    hFilterBtn:LOAD-IMAGE(cActiveFilterBtn).

  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  

  IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"canSchedule") = "NO" THEN 
    rectWinToolbar:X = rectWinToolbar:X - 22. 
  IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"canShare") = "NO" THEN 
    rectWinToolbar:X = rectWinToolbar:X - 22. 

  hWinToolbar = DYNAMIC-FUNCTION("NewToolbar",
                             rectWinToolbar:HANDLE,
                             IF DYNAMIC-FUNCTION("Scandinavian") THEN "Fil" ELSE "File",
                             (IF JBoxSession:Instance:getJBoxAttribute("queryScheduler") NE ""
                                 AND DYNAMIC-FUNCTION("getAttribute",hBrowse,"canSchedule") NE "NO"
                                 AND JBoxServerAPI:Instance:getActionPermission("scheduleQuery")
                               THEN  
                                "Schedule;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Planlegg" ELSE "Schedule")  + ";;;gif/sessionconfig16.gif"
                              ELSE "")  
                           + (IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"canShare") NE "NO" THEN
                              ",Share;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Del definisjon av spørring" ELSE "Share query setup") + ";;;bmp/share16.bmp"
                              ELSE "")
                           + ",Delete|;&;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Slett spørring" ELSE "Delete current query&")
                                      + ";DeleteQuery"
                           + ",Save|;Savectrl-s;" + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Lagre spørring" ELSE "Save current query")
                                      + ";SaveCurrentQuery"
                            ,"right,enable").  
  ASSIGN hBtnSaveQuery            = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hWinToolbar,"buttonSave"))
         hBtnSaveQuery:HIDDEN     = YES
         hBtnDeleteQuery          = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hWinToolbar,"buttonDelete"))
         hBtnDeleteQuery:HIDDEN   = YES
         hBtnShareQuery           = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hWinToolbar,"buttonShare"))
         hMenuItemShareQuery      = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hWinToolbar,"menu-itemShare"))
         hBtnScheduleQuery        = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hWinToolbar,"buttonSchedule"))
         .


  IF VALID-HANDLE(hBtnScheduleQuery) THEN
    hBtnScheduleQuery:HIDDEN = YES.
  IF VALID-HANDLE(hBtnShareQuery) THEN
    ASSIGN hBtnShareQuery:HIDDEN = YES
           hMenuItemShareQuery:SENSITIVE = NO.

  /* Link the browse and the toolbar */
  DYNAMIC-FUNCTION("CreateObjectLink",hBrowse,hToolbar).
  &ENDIF

  SUBSCRIBE TO "ExcelSheetParams" ANYWHERE.
  SUBSCRIBE TO "BeforeDynAccum" ANYWHERE.
  SUBSCRIBE TO "DynAccumDone" ANYWHERE.
  SUBSCRIBE TO "BeforeSetDynFilter" ANYWHERE.

  DYNAMIC-FUNCTION("InitTranslation",THIS-PROCEDURE:CURRENT-WINDOW).

  rectToolbar:WIDTH-PIXELS = rectToolbar:WIDTH-PIXELS - 3. 

  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    DYNAMIC-FUNCTION("setAddMoveX", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE, "fiCurrentQuery").
    DYNAMIC-FUNCTION("setNoResizeX", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE, "searchField").
    DYNAMIC-FUNCTION("setNoResizeY", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE, "rectWinToolbar").
    DYNAMIC-FUNCTION("setOrgWinSize",THIS-PROCEDURE:CURRENT-WINDOW,350,150,0,150).
  &ENDIF  

  APPLY "value-changed" TO hBrowse.
  APPLY "entry" TO hBrowse.

  SESSION:SET-WAIT-STATE("").

END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
IF NOT bManualView THEN DO:
  THIS-PROCEDURE:CURRENT-WINDOW:HIDDEN = FALSE.
  IF icWhereString BEGINS "where false" THEN 
    APPLY "cursor-up" to hBrowse.
END.
&ENDIF

CATCH eAny AS Progress.Lang.Error :
  MESSAGE 'Error InitializeObject' eAny:GetMessage(1)
          VIEW-AS ALERT-BOX.
END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitQuery C-Win 
PROCEDURE InitQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icFilterFields    AS CHAR NO-UNDO.
DEF INPUT PARAM icFilterOperators AS CHAR NO-UNDO.
DEF INPUT PARAM icFilterValues    AS CHAR NO-UNDO.
DEF INPUT PARAM icInitSort        AS CHAR NO-UNDO.
DEF INPUT PARAM icDistinctCols    AS CHAR NO-UNDO.
DEF INPUT PARAM icAccumFields     AS CHAR NO-UNDO.

DEF VAR hColumn AS HANDLE NO-UNDO.

RUN InitWithUserQuery(OUTPUT bOk).

IF bOk THEN RETURN.
ELSE 
  StartQuery(icFilterFields,
             icFilterOperators,
             icFilterValues,
             icInitSort,
             icDistinctCols,
             icAccumFields).

/*
DYNAMIC-FUNCTION("setAttribute",hBrowse,"distinctcolumns",icDistinctCols).
DYNAMIC-FUNCTION("setAttribute",hBrowse,"accumfields",icAccumFields).

IF icInitSort NE "" AND icDistinctCols = "" THEN DO:
  DYNAMIC-FUNCTION("setSortString",hBrowse,icInitSort).
  CreateSearchField(ENTRY(1,icInitSort)).
END.
ELSE IF icDistinctCols NE "" THEN DO:
  DYNAMIC-FUNCTION("setSortString",hBrowse,icDistinctCols).
  CreateSearchField(ENTRY(1,icDistinctCols)).
END.

IF icFilterFields NE "" THEN
  DYNAMIC-FUNCTION("InitDynFilter",hBrowse
                   ,icFilterFields
                   ,icFilterOperators
                   ,icFilterValues
                   ,"").

ELSE 
  RUN InvokeMethod(hBrowse,"OpenQuery").

IF icDistinctCols NE "" THEN DO:    
  hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hBrowse,"jbCountDistinct").
  IF VALID-HANDLE(hColumn) THEN hColumn:VISIBLE = YES.

  IF icAccumFields NE "" AND NUM-ENTRIES(icAccumFields) = 1 THEN DO:
    hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hBrowse,"jbAverage").
    IF VALID-HANDLE(hColumn) THEN hColumn:VISIBLE = YES.
  END.

  DYNAMIC-FUNCTION("setBrowseColumns",hBrowse,
                   icDistinctCols    + (IF icAccumFields NE "" AND NUM-ENTRIES(icAccumFields) = 1 THEN 
                                          "," + icAccumFields + ",jbCountDistinct,jbAverage" 
                                        ELSE IF icAccumFields NE "" THEN
                                          "," + icAccumFields + ",jbCountDistinct"
                                        ELSE ",jbCountDistinct"),NO).    

  RUN DynAccumDone (hBrowse,"accum").
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"uselocaldata","yes").
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitStringTranslation C-Win 
PROCEDURE InitStringTranslation :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM        ihWindow    AS HANDLE NO-UNDO.
DEF INPUT-OUTPUT PARAM iocTypeList AS CHAR   NO-UNDO.

IF ihWindow NE THIS-PROCEDURE:CURRENT-WINDOW THEN RETURN.

/* For translation: Init special translation type and corresponding values: */
IF NOT CAN-DO(iocTypeList,"TitlePrefix-Details") THEN
  iocTypeList = iocTypeList + ",TitlePrefix-Details".
IF NOT CAN-DO(iocTypeList,"TitlePrefix-Totals") THEN
  iocTypeList = iocTypeList + ",TitlePrefix-Totals".

cTitlePrefixDetails = DYNAMIC-FUNCTION("getStringTranslation",THIS-PROCEDURE:FILE-NAME,
                                       "TitlePrefix-Details",cTitlePrefixDetails).
cTitlePrefixTotals  = DYNAMIC-FUNCTION("getStringTranslation",THIS-PROCEDURE:FILE-NAME,
                                       "TitlePrefix-Totals",cTitlePrefixTotals).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitWithUserQuery C-Win 
PROCEDURE InitWithUserQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM obOk AS LOG    NO-UNDO.

DEF VAR cMenuDef        AS CHAR   NO-UNDO.
DEF VAR cMenuItems      AS CHAR   NO-UNDO.
DEF VAR cMyQueryList    AS CHAR   NO-UNDO.
DEF VAR cMyMenuNameList AS CHAR   NO-UNDO.
DEF VAR hMenuItem       AS HANDLE NO-UNDO.

cMenuItems = JBoxServerAPI:Instance:FieldList("JBoxUserSetting;cSetting;cSettingName",
                          "WHERE cSourceFile  = '" + THIS-PROCEDURE:FILE-NAME + "'"
                         + " AND cObjectName  = 'userquery'"
                         + " AND cContext     = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                         + " AND cJBoxUserId  = '" + JBoxSession:Instance:UserId + "'"
                         + " AND cCreatedBy   = '" + JBoxSession:Instance:UserId + "'"
                         + " BY cSetting")
                         .
IF cMenuItems NE "" THEN DO:
  RUN JBoxDSimpleSelectList.w (cMenuItems,?,OUTPUT cMenuDef).
  IF cMenuDef NE ? THEN DO:
    hMenuItem = DYNAMIC-FUNCTION("getEventWidget",
                                 hToolbar,
                                 cMenuDef,
                                 "menu-item").
    hMenuItem:CHECKED = YES.
    DYNAMIC-FUNCTION("setCurrentWidget",hMenuItem).
    DYNAMIC-FUNCTION("setAttribute",hToolbar,"lasttoolbaraction",cMenuDef).
    RUN "StartUserQuery".
    obOk = YES.
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LogUserQueryExecRecord C-Win 
PROCEDURE LogUserQueryExecRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
IF cJBoxUserSettingId = "" THEN DO:
  IF JBoxSession:Instance:Scandinavian THEN
    MESSAGE "Ingen bruker-definert spørring er valgt"
            VIEW-AS ALERT-BOX ERROR.
  ELSE
    MESSAGE "No user-defined query is selected"
            VIEW-AS ALERT-BOX ERROR.
            
  RETURN.   
END.

DYNAMIC-FUNCTION("setAttribute",hBrowse,"calcParamLogUserQueryExec",cJBoxUserSettingId).
RUN InvokeMethod(hBrowse,"OpenQuery").


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
THIS-PROCEDURE:CURRENT-WINDOW:WINDOW-STATE = 3.
THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
THIS-PROCEDURE:CURRENT-WINDOW:TOP-ONLY = YES.
IF VALID-HANDLE(hBrowse) THEN
  APPLY "entry" TO hBrowse.
THIS-PROCEDURE:CURRENT-WINDOW:TOP-ONLY = NO.
END PROCEDURE.

//PUBLISH "RebuildActionMenu".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MultiSortBrowse C-Win 
PROCEDURE MultiSortBrowse :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
RUN SUPER.

resetRowCounter().


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mySelectorObject C-Win 
PROCEDURE mySelectorObject :
DEF INPUT PARAM ioSelector AS JBoxDynSelector NO-UNDO.

ioSelector:ExpandSelectorDialogX(400).
ioSelector:SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:WINDOW:TITLE = IF JBoxSession:Instance:Scandinavian THEN 
                                                               "Velg brukere for å dele definisjon av spørring"
                                                             ELSE
                                                               "Select users for sharing current query definition".  

ioSelector:SOURCE-BROWSE-OBJECT:openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuery C-Win 
PROCEDURE OpenQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR bOpenQuery AS LOG NO-UNDO INIT YES.

PUBLISH "OpenQueryFlatView" (THIS-PROCEDURE,hBrowse,OUTPUT bOpenQuery).

IF bOpenQuery THEN DO:
  RUN SUPER.

  IF VALID-HANDLE(hExcelGraph) THEN 
    hExcelGraph:SENSITIVE = INT(DYNAMIC-FUNCTION("getAttribute",hBrowse,"recordCount")) < iMaxGraph AND NUM-ENTRIES(DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns")) = 1.
/*  IF VALID-HANDLE(hShowQuery) AND hShowQuery:CHECKED AND VALID-OBJECT(oContainer) THEN            */
/*    oContainer:statusBar:HelpText = DYNAMIC-FUNCTION("getAttribute",hBrowse,"statvalueLastQuery").*/
  IF VALID-HANDLE(hSwitchLocal) THEN DO: 
    IF hSwitchLocal:SENSITIVE THEN
      hBrowse:MAX-DATA-GUESS = INT(DYNAMIC-FUNCTION("getAttribute",hBrowse,"recordCount")).
    ELSE  
      hBrowse:MAX-DATA-GUESS = INT(DYNAMIC-FUNCTION("getAttribute",hBrowse,"rowsToBatch")).
  END.
END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PdfPrint C-Win 
PROCEDURE PdfPrint :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*  FIND FIRST TTPDF.                                                    */
/*                                                                       */
/*  ASSIGN TTPDF.creporttitle = {&WINDOW-NAME}:TITLE                     */
/*         TTPDF.hbrowse = hBrowse                                       */
/*         TTPDF.loAltColours = NO                                       */
/* /*         TTPDF.deAltColour[1] = DEC(fillin_iRed:SCREEN-VALUE)   */  */
/* /*         TTPDF.deAltColour[2] = DEC(fillin_iGreen:SCREEN-VALUE) */  */
/* /*         TTPDF.deAltColour[3] = DEC(fillin_iBlue:SCREEN-VALUE)  */  */
/*         TTPDF.cFunction[4] = THIS-PROCEDURE:CURRENT-WINDOW:TITLE.     */
/*                                                                       */
/*  RUN pdflibrary.p (INPUT-OUTPUT TABLE TTPDF).                         */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE printRecord C-Win 
PROCEDURE printRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PUBLISH "FlatViewPrintRecord" (ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"buffersandfields")),";"),
                               hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD("RowIdent1"):BUFFER-VALUE).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowDisplayBrowse C-Win 
PROCEDURE RowDisplayBrowse :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN SUPER.
PUBLISH "RowDisplayDataBrowse" (hBrowse).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowEntry C-Win 
PROCEDURE RowEntry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN SUPER.

IF VALID-HANDLE(hExcelGraph) THEN
  hExcelGraph:SENSITIVE = hBrowse:NUM-SELECTED-ROWS < iMaxGraph AND NUM-ENTRIES(DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns")) = 1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RowsToBatchRecord C-Win 
PROCEDURE RowsToBatchRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
RUN SUPER.

IF JBoxSession:Instance:ViewQuestionYesNo(IF JBoxSession:Instance:Scandinavian THEN "Hent data på nytt?" ELSE "Refresh query?") THEN
  RUN InvokeMethod (hBrowse,"OpenQuery").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveCurrentQuery C-Win 
PROCEDURE SaveCurrentQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF cQueryOwner = JBoxSession:Instance:UserId OR cQueryOwner = "" OR oDynDataBrowse:ViewDsId NE "" THEN DO:
  IF JBoxSession:Instance:ViewQuestionYesNo((IF JBoxSession:Instance:Scandinavian THEN "Lagre endringer for" + CHR(10) ELSE "Save changes for" + CHR(10)) + fiCurrentQuery:SCREEN-VALUE IN FRAME {&FRAME-NAME} + "?") THEN DO: 
//    SaveQuery(cCurrQueryId,"delete_setting").
    SaveQuery(cCurrQueryId,REPLACE(fiCurrentQuery:SCREEN-VALUE,","," ")).
//    SaveQuery(cCurrQueryId,IF fiCurrentQuery:MODIFIED IN FRAME {&FRAME-NAME} THEN REPLACE(fiCurrentQuery:SCREEN-VALUE,","," ") ELSE "").
  END.  
END.  
ELSE IF cQueryOwner NE JBoxSession:Instance:UserId THEN
  JBoxSession:Instance:ViewMessage(IF JBoxSession:Instance:Scandinavian THEN 
                                    "Du er ikke eier av denne spørringen. Velg 'Lagre som ny..' for å lage din egen kopi"
                                   ELSE
                                    "You are not the owner of this query. Use the 'Save as new..' option to make your own copy").  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveNewQuery C-Win 
PROCEDURE SaveNewQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cName        AS CHAR NO-UNDO.
DEF VAR iReturn      AS INT  NO-UNDO.
DEF VAR iQryIx       AS INT  NO-UNDO.
DEF VAR cQueryIdList AS CHAR NO-UNDO.

RUN JBoxAskForValue.w (IF DYNAMIC-FUNCTION("Scandinavian") THEN 
                         "Angi navn for ny spørring"
                       ELSE
                        "Enter name for new query instance"
                       ,"CHARACTER|x(100)",INPUT-OUTPUT cName,OUTPUT iReturn).
IF iReturn > 0 AND cName NE "" THEN DO:

  IF oDynDataBrowse:ViewDsId NE "" THEN
    cCurrQueryId = oDynDataBrowse:getNextViewDsUserQueryId().
  ELSE DO:
    cQueryIdList = JBoxServerAPI:Instance:FieldList("JBoxUserSetting;cSettingName",
                          "WHERE cSourceFile = '" + THIS-PROCEDURE:FILE-NAME + "'"
                        + " AND cObjectName = 'userquery'"
                        + " AND cContext = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                        + " BY INT(SUBSTR(cSettingName,6))"). 
    
    IF cQueryIdList NE "" THEN
      cCurrQueryId = "query" + STRING(INT(SUBSTR(ENTRY(NUM-ENTRIES(cQueryIdList,"|"),cQueryIdList,"|"),6)) + 1).
    ELSE cCurrQueryId = "query1".
  END.  
  SaveQuery(cCurrQueryId,REPLACE(cName,","," ")).

  APPLY "cursor-up" to hBrowse.
  
END.
ELSE IF iReturn > 0 AND cName = "" THEN
  DYNAMIC-FUNCTION("DoMessage",0,0,IF DYNAMIC-FUNCTION("Scandinavian") THEN "Du må angi et navn for spørringen"
                                   ELSE "You must enter a name for the query","","").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ScheduleRecord C-Win 
PROCEDURE ScheduleRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
oDynDataBrowse:userSettingName = cCurrQueryId.
oDynDataBrowse:queryName = fiCurrentQuery:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
RUN VALUE(JBoxSession:Instance:getJBoxAttribute("queryScheduler")) (oDynDataBrowse).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetQueryWhereRecord C-Win 
PROCEDURE SetQueryWhereRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cQuery        AS CHAR   NO-UNDO.
DEF VAR hSearchField  AS HANDLE NO-UNDO.
DEF VAR cBaseTable    AS CHAR   NO-UNDO.
DEF VAR cFlds         AS CHAR   NO-UNDO.
DEF VAR ix            AS INT    NO-UNDO.
DEF VAR cDataType     AS CHAR   NO-UNDO.
DEF VAR cTry          AS CHAR   NO-UNDO.

cQuery = DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryWhere").

cBaseTable = DYNAMIC-FUNCTION("getAttribute",hBrowse,"baseTable").

IF cQuery = "" THEN DO:
  IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"baseQuery") NE "" OR DYNAMIC-FUNCTION("getAttribute",hBrowse,"queryFilter") NE "" THEN 
    ASSIGN cQuery = "AND ("
           cTry   = "WHERE true ".
  ELSE 
    cQuery = "WHERE (".
  cFlds = DYNAMIC-FUNCTION("getAttribute",hBrowse,"basetablefields").
  DO ix = 1 TO NUM-ENTRIES(cFlds):
    cQuery = cQuery + CHR(10) + (IF ix > 1 THEN " AND " ELSE "") + ENTRY(ix,cFlds) + " = ".    
    cDataType = DYNAMIC-FUNCTION("getFieldDataType",cBaseTable + "." + ENTRY(ix,cFlds)).
    CASE cDataType:
      WHEN "CHARACTER"  THEN cQuery = cQuery + "'<value>'".
      WHEN "DATE" OR WHEN "DATETIME" OR WHEN "DATETIME-TZ"
        THEN cQuery = cQuery + cDataType + "('" + (IF SESSION:DATE-FORMAT = "dmy" THEN "dd.mm.yyyy" ELSE "mm.dd.yyyy") + "')".
      WHEN "DECIMAL"    THEN cQuery = cQuery + "DECIMAL('" + (IF SESSION:NUMERIC-FORMAT = "american" THEN "999.99" ELSE "999,99") + "')".
      WHEN "LOGICAL"    THEN cQuery = cQuery + "true/false".
      OTHERWISE cQuery = cQuery + "<value>".
    END CASE.
  END.
  cQuery = cQuery + CHR(10) + ")".    
END.
ELSE IF NOT TRIM(cQuery) BEGINS "WHERE" THEN cTry = "WHERE true ". 

REPEAT:
  RUN JBoxDSmallEditor.w (INPUT-OUTPUT cQuery,
                          IF DYNAMIC-FUNCTION("Scandinavian") THEN
                            "Sett spørrekriterium (obs - fjerner mulighet for kolonnesøk)"
                          ELSE 
                            "Set query string (obs - disables column-search)",
                          NO,OUTPUT bOk).
  IF bOk AND cQuery NE "" AND NOT JBoxServerAPI:Instance:CallServerProc("jbserv_check_query_syntax.p",cBaseTable + CHR(1) + cTry + cQuery) THEN DO:
    JBoxServerAPI:Instance:viewCallMessage().
    NEXT.
  END.   
  ELSE LEAVE.  
END.  
IF bOK THEN DO:
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"queryWhere"," " + cQuery).
  
  RUN InvokeMethod(hBrowse,"OpenQuery").
  IF cQuery NE "" THEN DO:
    hSearchField = DYNAMIC-FUNCTION("getLinkedObject",hBrowse,"browse-search-field","from").
    IF hSearchField NE ? THEN DO:
      DYNAMIC-FUNCTION("DeleteObjectLink",hBrowse,hSearchField).
      hSearchField:HIDDEN = YES.
    END.  
  END.  
  ELSE IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"1stSortColumn") NE "" THEN
    CreateSearchField(DYNAMIC-FUNCTION("getAttribute",hBrowse,"1stSortColumn")).  
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShareRecord C-Win 
PROCEDURE ShareRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
 DEF VAR cRowIdList          AS CHAR NO-UNDO.
 DEF VAR bCompUserInstalled  AS LOG  NO-UNDO.

 IF JBoxServerAPI:Instance:Find("FIRST JBoxUserSetting",
                       "WHERE cSourceFile = '" + THIS-PROCEDURE:FILE-NAME + "'"
                     + " AND cObjectName = 'userquery'"
                     + " AND cContext = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                     + " AND cSettingName = '" + cCurrQueryId + "'"
                     + " AND cJBoxUserId = '" + JBoxSession:Instance:UserId + "'"
                     + " AND cJboxUserId = cCreatedBy") THEN
    ASSIGN cJBoxUserSettingId = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.iJBoxUserSettingId")
           cQueryOwner        = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.cJBoxUserId").
  ELSE DO:
    JBoxSession:Instance:ViewMessage("Error: Could not find query id (did you create it..?)").
    RETURN.
  END.                   

  cRowIdList = JBoxServerAPI:Instance:getRowIdList("JBoxUserSetting,JBoxUser",
               "WHERE cSourceFile = '" + THIS-PROCEDURE:FILE-NAME + "'"
             + " AND cObjectName = 'userquery'"
             + " AND cContext = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
             + " AND cSettingName = '" + cCurrQueryId + "'"
             + " AND cCreatedBy = '" + JBoxSession:Instance:UserId + "'"
             + " AND cJboxUserId NE cCreatedBy"
             + ",FIRST JBoxUser NO-LOCK OF JBoxUserSetting" 
               ).
/*  cRowIdList = JBoxServerAPI:Instance:getRowIdList("<TableList>","<table for rowid>","<query>"). */

  bCompUserInstalled = DYNAMIC-FUNCTION("getIsTableInstalled","JBoxCompanyUser").

  JBoxServerAPI:Instance:Selector("JBoxUser"
                      + ";cJBoxUserId"
                      + ";cUserName"
                      + (IF DYNAMIC-FUNCTION("getIsFieldInTable","JboxUser.bActive") THEN ";!bActive" ELSE "")
                      + (IF bCompUserInstalled THEN ",JBoxCompanyUser;!iJBoxCompanyId" ELSE "")
                      ,"WHERE cJBoxUserId NE '" + JBoxSession:Instance:UserId
                     + "' AND cJboxUserId NE '" + cQueryOwner  
                     + "' AND " + (IF DYNAMIC-FUNCTION("getIsFieldInTable","JboxUser.bActive") THEN "bActive" ELSE "TRUE")
                     + (IF bCompUserInstalled THEN
                         ",FIRST JBoxCompanyUser NO-LOCK OF JBoxUser WHERE JBoxCompanyUser.iJBoxCompanyId = " + STRING(JBoxSession:Instance:CompanyId)
                        ELSE "")  
                     ,cRowIdList).
  IF JBoxServerAPI:Instance:SelectorOk THEN DO:
    IF NOT JBoxServerAPI:Instance:CallServerProc("jbserv_share_querydefinition.p", cJBoxUserSettingId + ";" + JBoxServerAPI:Instance:SelectorRowidList) THEN
      JBoxServerAPI:Instance:viewCallMessage().
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE showQueryRecord C-Win 
PROCEDURE showQueryRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cQuery AS CHAR NO-UNDO.
DEF VAR cTime  AS CHAR NO-UNDO.

cQuery = DYNAMIC-FUNCTION("getAttribute",hBrowse,"statvalueLastQuery").
cTime = DYNAMIC-FUNCTION("getAttribute",hBrowse,"statvalueElapseTime").
IF cTime NE "" THEN
  cTime = (IF JBoxSession:Instance:Scandinavian THEN "Kjøretid: " ELSE "Elapse time: ") + cTime + CHR(10) + CHR(10).
   
IF cQuery BEGINS "FOR" THEN cQuery = REPLACE(REPLACE(REPLACE(cQuery,",",CHR(10) + CHR(10) + ",")," BY ",CHR(10) + CHR(10) + "BY ")," WHERE ",CHR(10) + "WHERE ").
ELSE DO:
  cQuery = REPLACE(cQuery," LEFT OUTER JOIN "," LEFT_OUTER_JOIN ").
  cQuery = REPLACE(cQuery," WHERE NOT EXISTS (SELECT * FROM "," WHERE_NOT_EXISTS_(SELECT_*_FROM " ).
  cQuery = REPLACE(cQuery," FROM ",CHR(10) + CHR(10) + "FROM ").
  cQuery = REPLACE(cQuery," JOIN ",CHR(10) + CHR(10) + "JOIN ").
  cQuery = REPLACE(cQuery," WHERE ",CHR(10) + "WHERE ").
  cQuery = REPLACE(cQuery," ORDER BY ",CHR(10) + CHR(10) + "ORDER BY ").
  cQuery = REPLACE(cQuery," LEFT_OUTER_JOIN ",CHR(10) + CHR(10) + "LEFT OUTER JOIN ").
  cQuery = REPLACE(cQuery," WHERE_NOT_EXISTS_(SELECT_*_FROM ",CHR(10) + "WHERE NOT EXISTS (SELECT * FROM ").
END.  

IF JBoxSession:Instance:ViewQuestionYesNo(cQuery + CHR(10) + CHR(10) + cTime
    + (IF JBoxSession:Instance:Scandinavian THEN "Kopier til utklippstavle?" ELSE "Copy to clipboard?")) THEN
  CLIPBOARD:VALUE = cQuery.

/*
IF NOT VALID-OBJECT(oContainer) THEN RETURN.
IF hShowQuery:CHECKED THEN DO:
  IF NOT VALID-OBJECT(oMenuStatusBar) THEN DO:
    JBoxSession:Instance:ViewMessage(IF JBoxSession:Instance:Scandinavian THEN 
                                       "Høyreklikk på statuslinjen for å kopiere spørring"
                                     ELSE "Right-click on status-bar to copy query").
    oMenuStatusBar = NEW JBoxPopupMenu().
    oContainer:statusBar:hHelpText:FRAME:POPUP-MENU = oMenuStatusBar:POPUP-MENU-HANDLE.
    oMenuStatusBar:addTool("copyHelpText",IF JBoxSession:Instance:Scandinavian THEN "Kopier" ELSE "Copy").
    oContainer:statusBar:HelpText = DYNAMIC-FUNCTION("getAttribute",hBrowse,"statvalueLastQuery").                                 
  END.                                     
END.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SMSRecord C-Win 
PROCEDURE SMSRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PUBLISH "FlatViewSMSRecord" (ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"buffersandfields")),";"),
                               hBrowse).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartSearch C-Win 
PROCEDURE StartSearch :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
RUN SUPER.

resetRowCounter ().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartSharedQuery C-Win 
PROCEDURE StartSharedQuery :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cQueryAtt         AS CHAR   NO-UNDO.
DEF VAR hCurrMenuId       AS HANDLE NO-UNDO.
DEF VAR cCurrFilterValues AS CHAR   NO-UNDO.
DEF VAR bActiveFilter     AS LOG    NO-UNDO.
DEF VAR cAccumViewFields  AS CHAR   NO-UNDO.
DEF VAR cCurrViewFields   AS CHAR   NO-UNDO.
DEF VAR hAccum            AS HANDLE NO-UNDO.
DEF VAR hFilter           AS HANDLE NO-UNDO.
DEF VAR hConfig           AS HANDLE NO-UNDO.
DEF VAR bViewAvg          AS LOG    NO-UNDO.
DEF VAR bRecordCount      AS LOG    NO-UNDO INIT ?.
DEF VAR bLocal            AS LOG    NO-UNDO.

bLocal = DYNAMIC-FUNCTION("getAttribute",hBrowse,"useLocalData") = "yes".
IF bLocal THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"useLocalData","").

hCurrMenuId = DYNAMIC-FUNCTION("getCurrentWidget").

IF hCurrMenuId:CHECKED THEN DO WITH FRAME {&FRAME-NAME}:
  cCurrQueryId = DYNAMIC-FUNCTION("getAttribute",hToolbar,"lasttoolbaraction").

  cQueryOwner = "".
  
  IF JBoxServerAPI:Instance:Find("FIRST JBoxUserSetting",
                        "WHERE cSourceFile = '" + THIS-PROCEDURE:FILE-NAME + "'"
                      + " AND cObjectName = 'userquery'"
                      + " AND cContext = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                      + " AND cSettingName = '" + cCurrQueryId + "'"
                      + " AND cJboxUserId = cCreatedBy") THEN 
    ASSIGN cQueryOwner = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.cJBoxUserId")
           cJBoxUserSettingId = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.iJBoxUserSettingId")
           .
    
  cQueryAtt = DYNAMIC-FUNCTION("getUserSetting",THIS-PROCEDURE:FILE-NAME,
                               cCurrQueryId,
                               DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext"),
                               "*" + (IF cQueryOwner NE "" THEN CHR(1) + cQueryOwner ELSE "")).
  IF cQueryAtt NE "" THEN DO:
    ASSIGN fiCurrentQuery:SCREEN-VALUE = ENTRY(LOOKUP(cCurrQueryId,cSharedMenuIdList),cSharedMenuNameList,"|")
           fiCurrentQuery:HIDDEN       = NO           
           fiCurrentQuery:MODIFIED     = NO
           hBtnSaveQuery:HIDDEN        = NO
           hBtnSaveQuery:SENSITIVE     = NO
           hBtnDeleteQuery:HIDDEN      = NO
           cCurrQuerySettings          = ENTRY(1,cQueryAtt,"|")
           cCurrFilterValues           = REPLACE(ENTRY(2,cQueryAtt,"|"),CHR(3),"|")
           FRAME {&FRAME-NAME}:WIDTH-PIXELS = {&WINDOW-NAME}:WIDTH-PIXELS
           FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS = {&WINDOW-NAME}:WIDTH-PIXELS
           FRAME {&FRAME-NAME}:HEIGHT-PIXELS = {&WINDOW-NAME}:HEIGHT-PIXELS
           FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = {&WINDOW-NAME}:HEIGHT-PIXELS
           .
    IF VALID-HANDLE(hBtnScheduleQuery) THEN
      hBtnScheduleQuery:HIDDEN    = NO.
    IF VALID-HANDLE(hBtnShareQuery) THEN
      ASSIGN hBtnShareQuery:HIDDEN       = NO
             hMenuItemShareQuery:SENSITIVE = YES.

    hAccum = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"accumhandle")) NO-ERROR.
    IF VALID-HANDLE(hAccum) THEN 
      APPLY "close" TO hAccum.
    hFilter = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"filterhandle")) NO-ERROR.
    IF VALID-HANDLE(hFilter) THEN 
      APPLY "close" TO hFilter.
    hConfig = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"browseconfighandle")) NO-ERROR.
    IF VALID-HANDLE(hConfig) THEN 
      APPLY "close" TO hConfig.

    DO ix = 1 TO NUM-ENTRIES(cQuerySettingList):
      DYNAMIC-FUNCTION("msetAttribute",hBrowse,ENTRY(ix,cQuerySettingList),"").
    END.
    DO ix = 1 TO NUM-ENTRIES(cCurrQuerySettings):
      DYNAMIC-FUNCTION("setAttribute",hBrowse,ENTRY(ix,cCurrQuerySettings),ENTRY(ix,cCurrFilterValues,CHR(1))).
      IF ENTRY(ix,cCurrQuerySettings) BEGINS "filterValue_" AND ENTRY(ix,cCurrFilterValues,CHR(1)) NE "" THEN 
        bActiveFilter = YES.
      IF ENTRY(ix,cCurrQuerySettings) = "accumviewfields" THEN 
        ASSIGN cAccumViewFields = ENTRY(ix,cCurrFilterValues,CHR(1))
               bViewAvg         = CAN-DO(cAccumViewFields,"jbAverage").
      IF ENTRY(ix,cCurrQuerySettings) = "currviewfields" THEN 
        cCurrViewFields = ENTRY(ix,cCurrFilterValues,CHR(1)).
      IF ENTRY(ix,cCurrQuerySettings) = "getRecordCount" THEN 
        bRecordCount = ENTRY(ix,cCurrFilterValues,CHR(1)) = "yes".
    END.

    IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"localsort") NE "" AND
       DYNAMIC-FUNCTION("GetLinkedObject",hBrowse,"browse-search-field","from") = ? THEN
      CreateSearchField(ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"localsort"))).

    DYNAMIC-FUNCTION("setCurrentObject",hBrowse).
    RUN OpenQuery.

    IF cAccumViewFields NE "" THEN DO:
      DYNAMIC-FUNCTION("ViewCountDistinctColumn",hBrowse,YES).
      IF bViewAvg THEN
        DYNAMIC-FUNCTION("ViewAverageColumn",hBrowse,YES).
      DYNAMIC-FUNCTION("DoLockWindow",THIS-PROCEDURE:CURRENT-WINDOW).
      DYNAMIC-FUNCTION("setBrowseColumns",hBrowse,cAccumViewFields,YES).
      RUN DynAccumDone (hBrowse,"accum").
      DYNAMIC-FUNCTION("DoLockWindow",?).
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"currviewfields",cOrgViewFields).
      hAccumBtn:LOAD-IMAGE(cActiveAccumBtn).
      IF VALID-HANDLE(hConfigBtn) THEN
        hConfigBtn:LOAD-IMAGE(cPassiveConfigBtn).
    END.
    ELSE DO:
      DYNAMIC-FUNCTION("ViewCountDistinctColumn",hBrowse,NO).
      DYNAMIC-FUNCTION("ViewAverageColumn",hBrowse,NO).
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"currviewfields",cCurrViewFields).
      DYNAMIC-FUNCTION("DoLockWindow",THIS-PROCEDURE:CURRENT-WINDOW).
      DYNAMIC-FUNCTION("setBrowseColumns",hBrowse,cCurrViewFields,NO).
      RUN DynAccumDone (hBrowse,"clear").
      DYNAMIC-FUNCTION("DoLockWindow",?).
      IF VALID-HANDLE(hAccumBtn) THEN
        hAccumBtn:LOAD-IMAGE(cPassiveAccumBtn).
      IF VALID-HANDLE(hConfigBtn) THEN DO:  
        IF cCurrViewFields NE cOrgViewFields THEN
          hConfigBtn:LOAD-IMAGE(cActiveConfigBtn).
        ELSE
          hConfigBtn:LOAD-IMAGE(cPassiveConfigBtn).
      END.
    END.

    IF bActiveFilter THEN
      hFilterBtn:LOAD-IMAGE(cActiveFilterBtn).
    ELSE
      hFilterBtn:LOAD-IMAGE(cPassiveFilterBtn).
    
    SetSharedQueriesMenu().
  END.
END.
ELSE ClearAttributes().

fiCurrentQuery:READ-ONLY = YES.
    
IF bLocal THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"useLocalData","yes").

DYNAMIC-FUNCTION("setToolbarToggles",hToolbar,NO,cCurrQueryId).

IF bRecordCount NE ? AND VALID-HANDLE(hMenuItemCountRows) THEN
  hMenuItemCountRows:CHECKED = bRecordCount.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartUserQuery C-Win 
PROCEDURE StartUserQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cQueryAtt         AS CHAR   NO-UNDO.
DEF VAR hCurrMenuId       AS HANDLE NO-UNDO.
DEF VAR cCurrFilterValues AS CHAR   NO-UNDO.
DEF VAR bActiveFilter     AS LOG    NO-UNDO.
DEF VAR cAccumViewFields  AS CHAR   NO-UNDO.
DEF VAR cCurrViewFields   AS CHAR   NO-UNDO.
DEF VAR hAccum            AS HANDLE NO-UNDO.
DEF VAR hFilter           AS HANDLE NO-UNDO.
DEF VAR hConfig           AS HANDLE NO-UNDO.
DEF VAR bViewAvg          AS LOG    NO-UNDO.
DEF VAR bRecordCount      AS LOG    NO-UNDO INIT ?.
DEF VAR bLocal            AS LOG    NO-UNDO.

bLocal = DYNAMIC-FUNCTION("getAttribute",hBrowse,"useLocalData") = "yes".
IF bLocal THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"useLocalData","").

hCurrMenuId = DYNAMIC-FUNCTION("getCurrentWidget").

IF
  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
 (VALID-HANDLE(hCurrMenuId) AND hCurrMenuId:CHECKED) OR
  &ENDIF
  BatchQueryId <> '' OR oDynDataBrowse:ViewDsRunQueryId NE "" 
  THEN DO WITH FRAME {&FRAME-NAME}:

  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  cCurrQueryId = DYNAMIC-FUNCTION("getAttribute",hToolbar,"lasttoolbaraction").
  &ENDIF

  cQueryOwner = "".

  IF VALID-OBJECT(oDynDataBrowse) AND oDynDataBrowse:ViewDsId NE "" THEN DO:
    IF oDynDataBrowse:ViewDsRunQueryId NE "" THEN
      cCurrQueryId = oDynDataBrowse:ViewDsRunQueryId. 
    cQueryAtt = oDynDataBrowse:getViewDsUserSetting(IF BatchQueryId NE "" THEN BatchQueryId ELSE cCurrQueryId,"*").
  END.             
  ELSE DO:
    IF BatchQueryId ne '' then do:
  
      IF JBoxServerAPI:Instance:Find("FIRST JBoxUserSetting",
                            "WHERE ijboxusersettingId = " + BatchQueryId) THEN
        ASSIGN
          cCurrQueryId       = JBoxServerAPI:Instance:FieldValue('JBoxUserSetting.cSettingName')
          cQueryOwner        = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.cJBoxUserId")
          cJBoxUserSettingId = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.iJBoxUserSettingId")
          cMyMenuIdList      = cCurrQueryId
          cMyMenuNameList    = JBoxServerAPI:Instance:FieldValue('JBoxUserSetting.cSetting')
          .     
    END.
    ELSE IF JBoxServerAPI:Instance:Find("FIRST JBoxUserSetting",
                          "WHERE cSourceFile = '" + THIS-PROCEDURE:FILE-NAME + "'"
                        + " AND cObjectName = 'userquery'"
                        + " AND cContext = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                        + " AND cSettingName = '" + cCurrQueryId + "'"
                        + " AND cJBoxUserId = '" + JBoxSession:Instance:UserId + "'"
                        + " AND cJboxUserId = cCreatedBy") THEN 
      ASSIGN cQueryOwner = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.cJBoxUserId")
             cJBoxUserSettingId = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.iJBoxUserSettingId").
    ELSE DO:
      MESSAGE "Could not find query user settings"
      VIEW-AS ALERT-BOX.
      RETURN.
    END.         
    
    cQueryAtt = DYNAMIC-FUNCTION("getUserSetting",THIS-PROCEDURE:FILE-NAME,
                                 cCurrQueryId,
                                 DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext"),
                                 "*" + (IF cQueryOwner NE "" THEN CHR(1) + cQueryOwner ELSE "")).
  END.                               

  IF cQueryAtt NE "" THEN DO:
    IF (VALID-OBJECT(oDynDataBrowse) AND NOT oDynDataBrowse:BatchMode) AND BatchQueryId = "" THEN
      ASSIGN fiCurrentQuery:SCREEN-VALUE = ENTRY(LOOKUP(cCurrQueryId,cMyMenuIdList),cMyMenuNameList,"|")
             fiCurrentQuery:HIDDEN       = NO           
             fiCurrentQuery:MODIFIED     = NO
             hBtnSaveQuery:HIDDEN        = NO
             hBtnSaveQuery:SENSITIVE     = YES
             hBtnDeleteQuery:HIDDEN      = NO
             FRAME {&FRAME-NAME}:WIDTH-PIXELS = {&WINDOW-NAME}:WIDTH-PIXELS
             FRAME {&FRAME-NAME}:VIRTUAL-WIDTH-PIXELS = {&WINDOW-NAME}:WIDTH-PIXELS
             FRAME {&FRAME-NAME}:HEIGHT-PIXELS = {&WINDOW-NAME}:HEIGHT-PIXELS
             FRAME {&FRAME-NAME}:VIRTUAL-HEIGHT-PIXELS = {&WINDOW-NAME}:HEIGHT-PIXELS
             .  
    ASSIGN cCurrQuerySettings          = ENTRY(1,cQueryAtt,"|")
           cCurrFilterValues           = REPLACE(ENTRY(2,cQueryAtt,"|"),CHR(3),"|")
           .
    IF VALID-HANDLE(hBtnScheduleQuery) THEN
      hBtnScheduleQuery:HIDDEN    = NO.
    IF VALID-HANDLE(hBtnShareQuery) THEN
      ASSIGN hBtnShareQuery:HIDDEN       = NO
             hMenuItemShareQuery:SENSITIVE = YES.

    hAccum = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"accumhandle")) NO-ERROR.
    IF VALID-HANDLE(hAccum) THEN 
      APPLY "close" TO hAccum.
    hFilter = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"filterhandle")) NO-ERROR.
    IF VALID-HANDLE(hFilter) THEN 
      APPLY "close" TO hFilter.
    hConfig = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"browseconfighandle")) NO-ERROR.
    IF VALID-HANDLE(hConfig) THEN 
      APPLY "close" TO hConfig.

    DO ix = 1 TO NUM-ENTRIES(cQuerySettingList):
      DYNAMIC-FUNCTION("msetAttribute",hBrowse,ENTRY(ix,cQuerySettingList),"").
    END.
    DO ix = 1 TO NUM-ENTRIES(cCurrQuerySettings):
      DYNAMIC-FUNCTION("setAttribute",hBrowse,ENTRY(ix,cCurrQuerySettings),ENTRY(ix,cCurrFilterValues,CHR(1))).
      IF ENTRY(ix,cCurrQuerySettings) BEGINS "filterValue_" AND ENTRY(ix,cCurrFilterValues,CHR(1)) NE "" THEN 
        bActiveFilter = YES.
      IF ENTRY(ix,cCurrQuerySettings) = "accumviewfields" THEN 
        ASSIGN cAccumViewFields = ENTRY(ix,cCurrFilterValues,CHR(1))
               bViewAvg         = CAN-DO(cAccumViewFields,"jbAverage").
      IF ENTRY(ix,cCurrQuerySettings) = "currviewfields" THEN 
        cCurrViewFields = ENTRY(ix,cCurrFilterValues,CHR(1)).
      IF ENTRY(ix,cCurrQuerySettings) = "getRecordCount" THEN 
        bRecordCount = ENTRY(ix,cCurrFilterValues,CHR(1)) = "yes".
    END.

    IF BatchQueryId NE "" THEN
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"RowsToBatch",999999).
    ELSE IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"localsort") NE "" AND
       DYNAMIC-FUNCTION("GetLinkedObject",hBrowse,"browse-search-field","from") = ? THEN
      CreateSearchField(ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"localsort"))).

    DYNAMIC-FUNCTION("setCurrentObject",hBrowse).
    RUN OpenQuery.

    IF cAccumViewFields NE "" THEN DO:
      DYNAMIC-FUNCTION("ViewCountDistinctColumn",hBrowse,YES).
      IF bViewAvg THEN
        DYNAMIC-FUNCTION("ViewAverageColumn",hBrowse,YES).
      DYNAMIC-FUNCTION("DoLockWindow",THIS-PROCEDURE:CURRENT-WINDOW).
      DYNAMIC-FUNCTION("setBrowseColumns",hBrowse,cAccumViewFields,YES).
      RUN DynAccumDone (hBrowse,"accum").
      DYNAMIC-FUNCTION("DoLockWindow",?).
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"currviewfields",cOrgViewFields).
      hAccumBtn:LOAD-IMAGE(cActiveAccumBtn).
      IF VALID-HANDLE(hConfigBtn) THEN
        hConfigBtn:LOAD-IMAGE(cPassiveConfigBtn).
    END.
    ELSE DO:
      DYNAMIC-FUNCTION("ViewCountDistinctColumn",hBrowse,NO).
      DYNAMIC-FUNCTION("ViewAverageColumn",hBrowse,NO).
      DYNAMIC-FUNCTION("setAttribute",hBrowse,"currviewfields",cCurrViewFields).
      DYNAMIC-FUNCTION("DoLockWindow",THIS-PROCEDURE:CURRENT-WINDOW).
      DYNAMIC-FUNCTION("setBrowseColumns",hBrowse,cCurrViewFields,NO).
      RUN DynAccumDone (hBrowse,"clear").
      DYNAMIC-FUNCTION("DoLockWindow",?).
      IF VALID-HANDLE(hAccumBtn) THEN
        hAccumBtn:LOAD-IMAGE(cPassiveAccumBtn).
      IF VALID-HANDLE(hConfigBtn) THEN DO:  
        IF cCurrViewFields NE cOrgViewFields THEN
          hConfigBtn:LOAD-IMAGE(cActiveConfigBtn).
        ELSE
          hConfigBtn:LOAD-IMAGE(cPassiveConfigBtn).
      END.
    END.

    IF bActiveFilter THEN
      hFilterBtn:LOAD-IMAGE(cActiveFilterBtn).
    ELSE
      hFilterBtn:LOAD-IMAGE(cPassiveFilterBtn).
    
    IF BatchQueryId = "" AND (VALID-OBJECT(oDynDataBrowse) AND NOT oDynDataBrowse:BatchMode) THEN setMyQueriesMenu().
  END.
END.
ELSE ClearAttributes().
   
fiCurrentQuery:READ-ONLY = NO.
    
IF bLocal THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"useLocalData","yes").

DYNAMIC-FUNCTION("setToolbarToggles",hToolbar,NO,cCurrQueryId).

IF bRecordCount NE ? AND VALID-HANDLE(hMenuItemCountRows) THEN
  hMenuItemCountRows:CHECKED = bRecordCount.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SumSelected C-Win 
PROCEDURE SumSelected :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR hMenuItem AS HANDLE NO-UNDO.
DEF VAR fTotal    AS DEC NO-UNDO FORMAT "->>>,>>>,>>9.99".
DEF VAR iCount    AS INT NO-UNDO.

hMenuItem = DYNAMIC-FUNCTION("getCurrentWidget").


DO ix = 1 TO hBrowse:NUM-SELECTED-ROWS:
  IF hBrowse:FETCH-SELECTED-ROW(ix) THEN
    ASSIGN fTotal = fTotal + hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD(ENTRY(LOOKUP(hMenuItem:LABEL,cTotalLabels),
                                                                                   (IF cAccumTotalFields NE "" THEN cAccumTotalFields ELSE cTotalFields))):BUFFER-VALUE
           iCount = iCount + 1.
END.
IF DYNAMIC-FUNCTION("DoMessage",0,4,(IF DYNAMIC-FUNCTION("Scandinavian") THEN "Sum " ELSE "Total ") + hMenuItem:LABEL + ": " + STRING(fTotal,"->>>,>>>,>>9.99") + CHR(10)
                                  + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Ant " ELSE "Count ") + hMenuItem:LABEL + ": " + STRING(iCount,"->>>,>>>,>>9")
                    ,IF DYNAMIC-FUNCTION("Scandinavian") THEN "Kopier sum til utklippstavle?" ELSE "Copy total to clipboard?","") = 6 THEN
  CLIPBOARD:VALUE = STRING(fTotal).

RUN MoveToTop.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SwitchLocalRecord C-Win 
PROCEDURE SwitchLocalRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cLocal AS CHAR NO-UNDO.
DEF VAR htt    AS HANDLE NO-UNDO.

cLocal = IF hSwitchLocal:CHECKED THEN "yes" ELSE "".

DYNAMIC-FUNCTION("setAttribute",hBrowse,"useLocalData",cLocal).
DYNAMIC-FUNCTION("setAttribute",hBrowse,"switchedToLocal",cLocal).

IF cLocal = "" THEN DO:
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"tempTableHandle","").
  htt = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hBrowse,"originalTempTable")) NO-ERROR.
  IF VALID-HANDLE(htt) THEN DELETE OBJECT htt.
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"originalTempTable","").
  IF JBoxSession:Instance:ViewQuestionYesNo(IF JBoxSession:Instance:Scandinavian THEN "Hent data på nytt?" ELSE "Refresh query?") THEN
    RUN InvokeMethod (hBrowse,"OpenQuery").
END. 
ELSE DO:
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"tempTableHandle",STRING(hBrowse:QUERY:GET-BUFFER-HANDLE(1):TABLE-HANDLE)).
  CREATE TEMP-TABLE htt.
  htt:CREATE-LIKE(hBrowse:QUERY:GET-BUFFER-HANDLE(1)).
  htt:TEMP-TABLE-PREPARE(hBrowse:QUERY:GET-BUFFER-HANDLE(1):NAME).
  htt:COPY-TEMP-TABLE(hBrowse:QUERY:GET-BUFFER-HANDLE(1)).
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"originalTempTable",STRING(htt)).
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"GoLocalWhenSmallDistinctCount","").
END. 

IF VALID-OBJECT(oContainer) THEN DO:
  IF cLocal NE "" THEN
    ASSIGN oContainer:statusBar:hHelpText:FRAME:BGCOLOR = 3
//           THIS-PROCEDURE:CURRENT-WINDOW:TITLE = THIS-PROCEDURE:CURRENT-WINDOW:TITLE
           oContainer:statusBar:HelpText = oContainer:statusBar:HelpText
         + (IF JBoxSession:Instance:Scandinavian THEN " (lokal)" ELSE " (local)").
  ELSE 
    ASSIGN oContainer:statusBar:hHelpText:FRAME:BGCOLOR = ?
//           THIS-PROCEDURE:CURRENT-WINDOW:TITLE = RIGHT-TRIM(THIS-PROCEDURE:CURRENT-WINDOW:TITLE,
           oContainer:statusBar:HelpText = RIGHT-TRIM(oContainer:statusBar:HelpText,
           IF JBoxSession:Instance:Scandinavian THEN " (lokal)" ELSE " (local)").
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TableDetails C-Win 
PROCEDURE TableDetails :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hMenuItem AS HANDLE NO-UNDO.
DEF VAR cTables   AS CHAR   NO-UNDO.
DEF VAR iTableIdx AS INT    NO-UNDO.
DEF VAR hDetail   AS HANDLE NO-UNDO.

hMenuItem = DYNAMIC-FUNCTION("getCurrentWidget").
cTables = DYNAMIC-FUNCTION("getAttribute",hBrowse,"bufferlist").
iTableIdx = LOOKUP(hMenuItem:LABEL,cTables).
IF iTableIdx > 0 THEN DO:

  hDetail = oContainer:StartChildWindow("JBoxRecordBrw.w",hMenuItem:LABEL, YES).
  RUN ViewDbRecord IN hDetail(hMenuItem:LABEL,hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("RowIdent" + STRING(iTableIdx)):BUFFER-VALUE).
  RUN MoveToTop in hDetail NO-ERROR.
END.  

//RUN MoveToTop.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewRowRecord C-Win 
PROCEDURE ViewRowRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hDetail AS HANDLE NO-UNDO.

hDetail = oContainer:StartChildWindow("JBoxRecordBrw.w",IF JBoxSession:Instance:Scandinavian THEN "Detaljer" ELSE "Details", YES).
RUN ViewTtRecord IN hDetail(hBrowse:QUERY:GET-BUFFER-HANDLE(1)).
RUN MoveToTop in hDetail NO-ERROR.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE wordRecord C-Win 
PROCEDURE wordRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
PUBLISH "FlatViewWordRecord" (ENTRY(1,ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"buffersandfields")),";"),
                               hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD("RowIdent1"):BUFFER-VALUE).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION AdjustBrowseColumns C-Win 
FUNCTION AdjustBrowseColumns RETURNS LOGICAL
  ( INPUT ihBrowse     AS HANDLE,
    INPUT icBrowseName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hColumn AS HANDLE NO-UNDO.
DEF VAR hField  AS HANDLE NO-UNDO.

hColumn = ihBrowse:FIRST-COLUMN.
REPEAT WHILE VALID-HANDLE(hColumn).
  hColumn:WIDTH-PIXELS = MIN(hColumn:WIDTH-PIXELS,120).
  hField = ihBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD(hColumn:NAME) NO-ERROR.
  IF NOT ERROR-STATUS:ERROR AND hField:DATA-TYPE = "DECIMAL" THEN
    bDecimalFields = YES.
  IF hColumn:VISIBLE THEN
    cOrgViewFields = cOrgViewFields + (IF cOrgViewFields NE "" THEN "," ELSE "") + hColumn:NAME.
  hColumn = hColumn:NEXT-COLUMN.
END.

RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ClearAttributes C-Win 
FUNCTION ClearAttributes RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hFilter       AS HANDLE NO-UNDO.
DEF VAR hAccum        AS HANDLE NO-UNDO.
DEF VAR hConfig       AS HANDLE NO-UNDO.
DEF VAR bRecordCount  AS LOG    NO-UNDO INIT ?.

DO WITH FRAME {&FRAME-NAME}:
  ASSIGN cCurrQueryId             = ""
         fiCurrentQuery:HIDDEN    = YES
         hBtnSaveQuery:HIDDEN     = YES
         hBtnDeleteQuery:HIDDEN   = YES
         cCurrQuerySettings       = ""
         cQueryOwner              = ""
         cJBoxUserSettingId       = ""
         .
  IF VALID-HANDLE(hBtnScheduleQuery) THEN       
    hBtnScheduleQuery:HIDDEN = YES.
  IF VALID-HANDLE(hBtnShareQuery) THEN
    ASSIGN hBtnShareQuery:HIDDEN       = YES
           hMenuItemShareQuery:SENSITIVE = NO.

  hAccum = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"accumhandle")) NO-ERROR.
  IF VALID-HANDLE(hAccum) THEN 
    APPLY "close" TO hAccum.
  hConfig = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"browseconfighandle")) NO-ERROR.
  IF VALID-HANDLE(hConfig) THEN 
    APPLY "close" TO hConfig.


  hFilter = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"filterhandle")) NO-ERROR.
  IF VALID-HANDLE(hFilter) THEN
    APPLY "close" TO hFilter.
  DO ix = 1 TO NUM-ENTRIES(cQuerySettingList):
    IF NOT CAN-DO("prescanquery,allaccumfields,allcalcfields,prescanmainquerycandidates_filter",ENTRY(ix,cQuerySettingList)) THEN
      DYNAMIC-FUNCTION("msetAttribute",hBrowse,ENTRY(ix,cQuerySettingList),"").

    IF ENTRY(ix,cQuerySettingList) = "getRecordCount" THEN 
      bRecordCount = NO.
  END.
  DYNAMIC-FUNCTION("msetAttribute",hBrowse,"prescanqueryfilter","").

  DYNAMIC-FUNCTION("setAttribute",hBrowse,"currviewfields",cOrgViewFields).  
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"querysort",cInitSort).
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"localsort",cInitSort).
  DYNAMIC-FUNCTION("DoLockWindow",THIS-PROCEDURE:CURRENT-WINDOW).
  DYNAMIC-FUNCTION("setAttribute",SESSION,"userkeepswindowlocked","yes").
  DYNAMIC-FUNCTION("ViewCountDistinctColumn",hBrowse,NO).
  DYNAMIC-FUNCTION("ViewAverageColumn",hBrowse,NO).
  DYNAMIC-FUNCTION("setBrowseColumns",hBrowse,cOrgViewFields,NO).
  RUN DynAccumDone (hBrowse,"clear").

  DYNAMIC-FUNCTION("setCurrentObject",hBrowse).
  RUN OpenQuery.

  hFilterBtn:LOAD-IMAGE(cPassiveFilterBtn) NO-ERROR.
  IF VALID-HANDLE(hAccumBtn) THEN
    hAccumBtn:LOAD-IMAGE(cPassiveAccumBtn).
  IF VALID-HANDLE(hConfigBtn) THEN
    hConfigBtn:LOAD-IMAGE(cPassiveConfigBtn).

  IF bRecordCount = NO AND VALID-HANDLE(hMenuItemCountRows) THEN hMenuItemCountRows:CHECKED = NO.

  DYNAMIC-FUNCTION("setAttribute",SESSION,"userkeepswindowlocked","").
  DYNAMIC-FUNCTION("DoLockWindow",?).
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ClearUseIndex C-Win 
FUNCTION ClearUseIndex RETURNS CHARACTER
  ( INPUT icQueryString AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cRevQuery AS CHAR NO-UNDO.
DEF VAR iy        AS INT  NO-UNDO.
DEF VAR bRemoved  AS LOG  NO-UNDO.

IF icQueryString MATCHES "*USE-INDEX*" THEN DO:
  DO iy = 2 TO NUM-ENTRIES(icQueryString," "):
    IF ENTRY(iy,icQueryString," ") = "USE-INDEX" OR ENTRY(iy - 1,icQueryString," ") = "USE-INDEX" THEN NEXT.
    cRevQuery = cRevQuery + ENTRY(iy,icQueryString," ") + " ".
  END.
  RETURN cRevQuery.
END.
RETURN icQueryString.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CreateSearchField C-Win 
FUNCTION CreateSearchField RETURNS LOGICAL
  ( INPUT icInitSort AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR ix              AS INT    NO-UNDO.
DEF VAR hSearchField    AS HANDLE NO-UNDO.

RETURN NO. // Search-field replaced by grid-filter sep 24
/*
IF DYNAMIC-FUNCTION("getLinkedObject",hBrowse,"browse-search-field","from") NE ? THEN RETURN NO.

IF icInitSort NE "" THEN DO WITH FRAME {&FRAME-NAME}:
  bOK = FALSE.
  DO ix = 1 TO hBrowse:NUM-COLUMNS:
    IF TRIM(ENTRY(1,icInitSort)) = hBrowse:GET-BROWSE-COLUMN(ix):NAME THEN DO:
      bOk = TRUE.
      LEAVE.
    END.
  END.
  IF bOK AND ix > 0 THEN DO:
    hSearchField = DYNAMIC-FUNCTION("NewBrowseSearchField",SearchField:HANDLE,hBrowse,ix).
    IF VALID-HANDLE(hSearchField) THEN DO:
      DYNAMIC-FUNCTION("CreateObjectLink",hSearchField,hBrowse).
      hSearchField:HIDDEN = NUM-ENTRIES(icInitSort) > 1.
    END.
  END.
  ELSE searchField:HIDDEN = TRUE.
END.
ELSE searchField:HIDDEN = TRUE.

RETURN FALSE.   /* Function return value. */
*/
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBatchQueryId C-Win 
FUNCTION getBatchQueryId RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

return BatchQueryId.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseHandle C-Win 
FUNCTION getBrowseHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF VALID-HANDLE(hBrowse) THEN
  RETURN hBrowse.
ELSE 
  RETURN BrwFlatView:HANDLE IN FRAME {&FRAME-NAME}.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDynDataBrowseObject C-Win 
FUNCTION getDynDataBrowseObject RETURNS JBoxDynDataBrowse
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

RETURN oDynDataBrowse.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFrameHandle C-Win 
FUNCTION getFrameHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN FRAME {&FRAME-NAME}:HANDLE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getToolbarHandle C-Win 
FUNCTION getToolbarHandle RETURNS HANDLE
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN hToolbar.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ReduceFields C-Win 
FUNCTION ReduceFields RETURNS CHARACTER
  ( INPUT icBuffersAndFields AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cNewList   AS CHAR NO-UNDO.
DEF VAR iy         AS INT  NO-UNDO.
DEF VAR iFieldIdx  AS INT  NO-UNDO.
DEF VAR bReduced   AS LOG  NO-UNDO.
DEF VAR cFieldDef  AS CHAR NO-UNDO.
DEF VAR cTable     AS CHAR NO-UNDO.
DEF VAR cField     AS CHAR NO-UNDO.
DEF VAR cDataType  AS CHAR NO-UNDO.
DEF VAR cFormat    AS CHAR NO-UNDO.
DEF VAR cFieldPos  AS CHAR NO-UNDO.

cExcludedList = "".
DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
  bReduced = NO.
  cTable = ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
  IF NUM-ENTRIES(ENTRY(ix,icBuffersAndFields),";") > 1 THEN
    DO iy = 2 TO NUM-ENTRIES(ENTRY(ix,icBuffersAndFields),";"):
      IF iy = 2 THEN
        cNewList = cNewList + ENTRY(iy - 1,ENTRY(ix,icBuffersAndFields),";") + ";".
  
      ASSIGN iFieldIdx = iFieldIdx + 1
             cFieldDef = ENTRY(iy,ENTRY(ix,icBuffersAndFields),";")
             cField    = ENTRY(1,cFieldDef,"|").
      IF NOT cField BEGINS "+" THEN
        cDataType = DYNAMIC-FUNCTION("getFieldDataType",cTable + "." + cField).
      ELSE
        cDataType = "".
        
      IF CAN-DO("INTEGER,DECIMAL",cDataType) THEN DO:         
        cFieldPos = IF NUM-ENTRIES(cFieldDef,"@") > 1 THEN ENTRY(2,cFieldDef,"@") ELSE "". /* skiller ut posisjon for at ikke formatet skal komme i posisjon.. */
        cFieldDef = ENTRY(1,cFieldDef,"@").           
        IF NUM-ENTRIES(cFieldDef,"|") > 2 THEN DO:
          IF CAN-DO("-,9,>",SUBSTR(ENTRY(3,cFieldDef,"|"),1,1)) THEN DO:
            IF ENTRY(3,cFieldDef,"|") BEGINS "-" THEN
              ENTRY(3,cFieldDef,"|") = "->>>>>" + SUBSTR(ENTRY(3,cFieldDef,"|"),3).
            ELSE   
              ENTRY(3,cFieldDef,"|") = "->>>>>" + ENTRY(3,cFieldDef,"|").
          END.    
        END.  
        ELSE DO:
          cFormat = REPLACE(DYNAMIC-FUNCTION("getFieldFormat",cTable + "." + cField),",","<").
          IF cFormat NE "" THEN DO:
            IF CAN-DO("-,9,>",SUBSTR(cFormat,1,1)) THEN DO:
              IF cFormat BEGINS "-" THEN cFormat = "->>>>>" + SUBSTR(cFormat,2). 
              ELSE cFormat = "->>>>>" + cFormat.
            END.        
            IF NUM-ENTRIES(cFieldDef,"|") > 1 THEN  
              cFieldDef = cFieldDef + "|" + cFormat.
            ELSE    
              cFieldDef = cFieldDef + "|" + DYNAMIC-FUNCTION("getFieldLabel",cTable + "." + cField) + "|" + cFormat.
          END.    
        END.       
        IF cFieldPos NE "" THEN cFieldDef = cFieldDef + "@" + cFieldPos.
      END.
             
      IF NOT CAN-DO(cExcludeFields,TRIM(ENTRY(1,ENTRY(iy,ENTRY(ix,icBuffersAndFields),";"),"|"),"!"))
         THEN DO:
        cNewList = cNewList + cFieldDef + ";".
      END.
      ELSE ASSIGN cNewList = cNewList + "!" + TRIM(cFieldDef,"!") + ";"
                  cExcludedList = cExcludedList + (IF cExcludedList NE "" THEN "," ELSE "") + STRING(iFieldIdx)
                  bReduced      = YES.
    END.
  ELSE cNewList = cNewList + "," + ENTRY(ix,icBuffersAndFields).

/*   IF NUM-ENTRIES(ENTRY(ix,cNewList),";") = 2 AND ENTRY(2,ENTRY(ix,cNewList),";") = "" AND bReduced THEN  */
/*     cNewList = cNewList + ",".                                                                           */
/*   ELSE                                                                                                   */
    cNewList = RIGHT-TRIM(cNewList,";") + ",".
END.

RETURN TRIM(cNewList,","). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION resetRowCounter C-Win 
FUNCTION resetRowCounter RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF VAR ix AS INT NO-UNDO.
IF DYNAMIC-FUNCTION("getAttribute",hBrowse,"uselocaldata") = "yes" THEN DO:
  hBrowse:QUERY:GET-FIRST ().
  REPEAT WHILE NOT hBrowse:QUERY:QUERY-OFF-END:
    ix = ix + 1.
    hBrowse:QUERY:GET-BUFFER-HANDLE (1)::RowCount = ix.
    hBrowse:QUERY:GET-NEXT().
  END.
  hBrowse:QUERY:QUERY-OPEN().  
END. 

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SaveQuery C-Win 
FUNCTION SaveQuery RETURNS LOGICAL
  ( INPUT icCurrQueryId AS CHAR,
    INPUT icName        AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cNameList  AS CHAR   NO-UNDO.
DEF VAR cValueList AS CHAR   NO-UNDO.
DEF VAR cAttrList  AS CHAR   NO-UNDO.

IF icName NE "" THEN DO:
  IF oDynDataBrowse:ViewDsId NE "" THEN
    oDynDataBrowse:setViewDsUserSetting("userquery",icCurrQueryId,icName). // "userquery" is object. (or type)
  ELSE  
    DYNAMIC-FUNCTION("setUserSetting",THIS-PROCEDURE:FILE-NAME,
                     "userquery",
                     DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext"),
                     icCurrQueryId, /* settingName */
                     icName).       /* setting */
                     
  SetMyQueriesMenu().

  IF oDynDataBrowse:ViewDsId NE "" THEN
    oDynDataBrowse:setViewDsUserSetting(icCurrQueryId,cCurrQuerySettings,"delete_setting"). 
  ELSE
    DYNAMIC-FUNCTION("setUserSetting",THIS-PROCEDURE:FILE-NAME,
                     icCurrQueryId,
                     DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext"),
                     cCurrQuerySettings,
                     "delete_setting").

  IF icName = "delete_setting" THEN DO:
    ClearAttributes().
    DYNAMIC-FUNCTION("setToolbarToggles",hToolbar,NO,"").
    RETURN YES.
  END.
  ELSE cQueryOwner = JBoxSession:Instance:UserId.
END.

DO ix = 1 TO NUM-ENTRIES(cQuerySettingList):
  cAttrList  = DYNAMIC-FUNCTION("getAttributeList",hBrowse
                                ,ENTRY(ix,cQuerySettingList)
                                ,""
                                ,YES).
  IF cAttrList NE ? AND ENTRY(2,cAttrList,"|") NE "" AND ENTRY(2,cAttrList,"|") NE CHR(1) THEN
    ASSIGN cNameList  = cNameList  + ENTRY(1,cAttrList,"|") + ","
           cValueList = cValueList + ENTRY(2,cAttrList,"|") + CHR(1).
END.
ASSIGN cValueList = SUBSTR(cValueList,1,LENGTH(cValueList) - 1)
       cNameList  = SUBSTR(cNameList,1,LENGTH(cNameList) - 1).

IF oDynDataBrowse:ViewDsId NE "" THEN
  oDynDataBrowse:setViewDsUserSetting(icCurrQueryId,cNameList,cValueList). 
ELSE DO: 
  DYNAMIC-FUNCTION("setUserSetting",THIS-PROCEDURE:FILE-NAME,
                   icCurrQueryId,
                   DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext"),
                   cNameList,
                   cValueList).

  IF JBoxServerAPI:Instance:Find("FIRST JBoxUserSetting",
                        "WHERE cSourceFile = '" + THIS-PROCEDURE:FILE-NAME + "'"
                      + " AND cObjectName = 'userquery'"
                      + " AND cContext = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                      + " AND cSettingName = '" + icCurrQueryId + "'"
                      + " AND cJboxUserId = cCreatedBy") THEN 
    ASSIGN cQueryOwner = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.cJBoxUserId")
           cJBoxUserSettingId = JBoxServerAPI:Instance:FieldValue("JBoxUserSetting.iJBoxUserSettingId").
END.
                 
RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SeqToAlpha C-Win 
FUNCTION SeqToAlpha RETURNS CHARACTER
  ( INPUT iiSeqNo AS INT,
    INPUT iCount  AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cRange AS CHAR NO-UNDO INIT "Z".

IF iiSeqNo < 0 OR iiSeqNo > 80 THEN cRange = "Z".
ELSE IF iiSeqNo < 27 THEN
  cRange = CHR(64 + iiSeqNo).
ELSE IF iiSeqNo < 54 THEN
  cRange = "A" + CHR(64 - 26 + iiSeqNo).
ELSE IF iiSeqNo < 81 THEN
  cRange = "B" + CHR(64 - 26 + iiSeqNo).

cRange = cRange + STRING(iCount).

RETURN cRange.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAccumButton C-Win 
FUNCTION setAccumButton RETURNS LOGICAL
  ( INPUT ibAccumButton AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

bAccumButton = ibAccumButton.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAccumFieldSort C-Win 
FUNCTION setAccumFieldSort RETURNS LOGICAL
  ( INPUT ibAccumFieldSort AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose: Switch on/off sorting on accumulated fields 
    Notes: Can be called before/after the browse is created. Default is YES
------------------------------------------------------------------------------*/
bAccumFieldSort = ibAccumFieldSort.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBatchQueryId C-Win 
FUNCTION setBatchQueryId RETURNS LOGICAL
 ( input ipValue as char) :

/*------------------------------------------------------------------------------

  Purpose: 

    Notes: 

------------------------------------------------------------------------------*/
  BatchQueryId = ipValue.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setBrowseObject C-Win 
FUNCTION setBrowseObject RETURNS LOGICAL
  ( INPUT ioBrowse AS JBoxBrowse ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

oBrowse = ioBrowse.
 
RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCalcFieldProcs C-Win 
FUNCTION setCalcFieldProcs RETURNS LOGICAL
  ( INPUT icCalcFieldProcs AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
cInitCalcFieldProcs = "," + REPLACE(TRIM(icCalcFieldProcs,","),",",";").

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCustomFilterWin C-Win 
FUNCTION setCustomFilterWin RETURNS LOGICAL
  ( INPUT icCustomFilter AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes: Must be set prior to InitializeObject. Use ExtraFlatViewRecord 
------------------------------------------------------------------------------*/
cCustomFilter = icCustomFilter.
RETURN FALSE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisableSaveFilter C-Win 
FUNCTION setDisableSaveFilter RETURNS LOGICAL
  ( INPUT ibDisableSaveFilter AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bDisableSaveFilter = ibDisableSaveFilter.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEmailButton C-Win 
FUNCTION setEmailButton RETURNS LOGICAL
  ( INPUT ibEmailButton AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bEmailButton = ibEmailButton.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setEnableSaveQuery C-Win 
FUNCTION setEnableSaveQuery RETURNS LOGICAL
  ( INPUT ibEnableSaveQuery AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF DYNAMIC-FUNCTION("getIsTableInstalled","JBoxUserSetting") OR oDynDataBrowse:ViewDsId NE "" THEN
  bEnableSaveQuery = ibEnableSaveQuery.
ELSE DO:
  MESSAGE "User setting table not installed. Cannot enable personalized query settings"
  VIEW-AS ALERT-BOX.
  RETURN NO.
END.    

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setExcludeFields C-Win 
FUNCTION setExcludeFields RETURNS LOGICAL
  ( icExcludeFields AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
cExcludeFields = icExcludeFields.

RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInitFilter C-Win 
FUNCTION setInitFilter RETURNS LOGICAL
  ( INPUT icInitFilterFields    AS CHAR,
    INPUT icInitFilterOperators AS CHAR,
    INPUT icInitFilterValues    AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
ASSIGN cInitFilterFields    = icInitFilterFields
       cInitFilterOperators = icInitFilterOperators
       cInitFilterValues    = icInitFilterValues
       .

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setManualView C-Win 
FUNCTION setManualView RETURNS LOGICAL
  ( INPUT ibManualView AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bManualView = ibManualView.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMyQueriesMenu C-Win 
FUNCTION setMyQueriesMenu RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hMenuItem AS HANDLE NO-UNDO.
DEF VAR hNextItem AS HANDLE NO-UNDO.

DEF VAR cMenuItems    AS CHAR NO-UNDO.
DEF VAR cMenuDef      AS CHAR NO-UNDO.
DEF VAR cLabel        AS CHAR NO-UNDO.
DEF VAR iy            AS INT  NO-UNDO.
DEF VAR iCurrMenuPos  AS INT  NO-UNDO.

IF NOT VALID-HANDLE(hMyQueriesMenu) THEN RETURN NO.

hMenuItem = hMyQueriesMenu:FIRST-CHILD NO-ERROR.
REPEAT WHILE VALID-HANDLE(hMenuItem):
  hNextItem = hMenuItem:NEXT-SIBLING.
  DELETE OBJECT hMenuItem.
  hMenuItem = hNextItem.
END.

IF VALID-OBJECT(oDynDataBrowse) AND oDynDataBrowse:ViewDsId NE "" THEN
  cMenuItems = oDynDataBrowse:getViewDsUserQueryMenu().
ELSE
  cMenuItems = JBoxServerAPI:Instance:FieldList("JBoxUserSetting;cSettingName;cSetting",
                            "WHERE cSourceFile  = '" + THIS-PROCEDURE:FILE-NAME + "'"
                           + " AND cObjectName  = 'userquery'"
                           + " AND cContext     = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                           + " AND cJBoxUserId  = '" + JBoxSession:Instance:UserId + "'"
                           + " AND cCreatedBy   = '" + JBoxSession:Instance:UserId + "'"
                           + " BY cSetting")
                           .

ASSIGN cMyMenuIdList = ""
       cMyMenuNameList = ""
       .
          
IF cMenuItems NE "" THEN DO:
  DO ix = 1 TO NUM-ENTRIES(cMenuItems,"|") BY 2:
    cLabel = REPLACE(ENTRY(ix + 1,cMenuItems,"|"),",",CHR(3)).
    ASSIGN cMyMenuIdList   = cMyMenuIdList + (IF cMyMenuIdList NE "" THEN "," ELSE "") + ENTRY(ix,cMenuItems,"|")
           cMyMenuNameList = cMyMenuNameList + (IF cMyMenuNameList NE "" THEN "|" ELSE "") + cLabel
           cMenuDef        = cMenuDef + (IF cMenuDef NE "" THEN "," ELSE "") + ENTRY(ix,cMenuItems,"|") + ";" + cLabel + "&;StartUserQuery;toggle¤enable"
           iy              = iy + 1
           .
    IF ENTRY(ix,cMenuItems,"|") = cCurrQueryId THEN iCurrMenuPos = iy.        
  END.
  DYNAMIC-FUNCTION("NewMenuBand",hMyQueriesMenu,
                   cMenuDef,"").

  DO ix = 1 TO NUM-ENTRIES(cMyMenuIdList):
    hMenuItem = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"menu-item" + ENTRY(ix,cMyMenuIdList))) NO-ERROR.
    IF VALID-HANDLE(hMenuItem) THEN DO:
      hMenuItem:LABEL = REPLACE(hMenuItem:LABEL,CHR(3),",").
      IF ix = iCurrMenuPos THEN 
        hMenuItem:CHECKED = YES.
    END.  
  END.
  cMyMenuNameList = REPLACE(cMyMenuNameList,CHR(3),",").

  hMyQueriesMenu:SENSITIVE = YES.

  IF LOOKUP(cCurrQueryId,cMyMenuIdList) > 0 THEN DO:
    ASSIGN fiCurrentQuery:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(LOOKUP(cCurrQueryId,cMyMenuIdList),cMyMenuNameList,"|")
           fiCurrentQuery:HIDDEN    = NO
           fiCurrentQuery:MODIFIED  = NO
           hBtnSaveQuery:HIDDEN     = NO
           hBtnSaveQuery:SENSITIVE  = YES
           hBtnDeleteQuery:HIDDEN   = NO
           hMenuItem                = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"menu-item" + cCurrQueryId))
           hMenuItem:CHECKED        = YES
           NO-ERROR.
    IF VALID-HANDLE(hBtnScheduleQuery) THEN       
      ASSIGN hBtnScheduleQuery:HIDDEN = NO.
    IF VALID-HANDLE(hBtnShareQuery) THEN
      ASSIGN hBtnShareQuery:HIDDEN       = NO
             hMenuItemShareQuery:SENSITIVE = YES.
  END.         
END.
ELSE DO:
  ASSIGN hMyQueriesMenu:SENSITIVE                     = NO
         fiCurrentQuery:HIDDEN IN FRAME {&FRAME-NAME} = YES
         hBtnSaveQuery:HIDDEN                         = YES
         hBtnDeleteQuery:HIDDEN                       = YES
         NO-ERROR.
  IF VALID-HANDLE(hBtnScheduleQuery) THEN       
    hBtnScheduleQuery:HIDDEN = YES.
  IF VALID-HANDLE(hBtnShareQuery) THEN
    ASSIGN hBtnShareQuery:HIDDEN       = YES
           hMenuItemShareQuery:SENSITIVE = NO.
END.         

PUBLISH "RebuildActionMenu".

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNoDrillDown C-Win 
FUNCTION setNoDrillDown RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

bNoDrillDown = YES.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setParent C-Win 
FUNCTION setParent RETURNS LOGICAL
  ( INPUT ihParent AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(ihParent) THEN RETURN FALSE.
  
  hParent = ihParent.

  IF NOT VALID-OBJECT(oDynDataBrowse) THEN DO WITH FRAME {&FRAME-NAME}:
    oDynDataBrowse = NEW JBoxDynDataBrowse(THIS-PROCEDURE,hParent,BrwFlatView:HANDLE,rectToolbar:HANDLE,searchField:HANDLE).
    DYNAMIC-FUNCTION("createParentLink",THIS-PROCEDURE,hParent,"parentproc").
  END.      
    
  IF CAN-DO(hParent:INTERNAL-ENTRIES,"myDatabrowseObject") THEN
    RUN myDatabrowseObject IN hParent (oDynDataBrowse). 

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPrintButton C-Win 
FUNCTION setPrintButton RETURNS LOGICAL
  ( INPUT ibPrintButton AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bPrintButton = ibPrintButton.

RETURN FALSE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowsToBatch C-Win 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( INPUT iiRowsToBatch AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

iRowsToBatch = iiRowsToBatch.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION SetSharedQueriesMenu C-Win 
FUNCTION SetSharedQueriesMenu RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hMenuItem  AS HANDLE NO-UNDO.
DEF VAR hNextItem  AS HANDLE NO-UNDO.
DEF VAR cMenuItems AS CHAR   NO-UNDO.
DEF VAR cMenuDef   AS CHAR   NO-UNDO.
DEF VAR cLabel     AS CHAR   NO-UNDO.

IF NOT VALID-HANDLE(hSharedQueriesMenu) THEN RETURN NO.

hMenuItem = hSharedQueriesMenu:FIRST-CHILD NO-ERROR.
REPEAT WHILE VALID-HANDLE(hMenuItem):
  hNextItem = hMenuItem:NEXT-SIBLING.
  DELETE OBJECT hMenuItem.
  hMenuItem = hNextItem.
END.

cMenuItems = JBoxServerAPI:Instance:FieldList("JBoxUserSetting;cSettingName;cSetting",
                          "WHERE cSourceFile  = '" + THIS-PROCEDURE:FILE-NAME + "'"
                         + " AND cObjectName  = 'userquery'"
                         + " AND cContext     = '" + DYNAMIC-FUNCTION("getAttribute",hBrowse,"usersettingcontext") + "'"
                         + " AND cJBoxUserId  = '" + JBoxSession:Instance:UserId + "'"
                         + " AND cCreatedBy NE '" + JBoxSession:Instance:UserId + "'"
                         + " BY cSetting")
                         .

ASSIGN cSharedMenuIdList = ""
       cSharedMenuNameList = ""
       .
          
IF cMenuItems NE "" THEN DO:
  DO ix = 1 TO NUM-ENTRIES(cMenuItems,"|") BY 2:
    cLabel = REPLACE(ENTRY(ix + 1,cMenuItems,"|"),",",CHR(3)).
    ASSIGN cSharedMenuIdList   = cSharedMenuIdList + (IF cSharedMenuIdList NE "" THEN "," ELSE "") + ENTRY(ix,cMenuItems,"|")
           cSharedMenuNameList = cSharedMenuNameList + (IF cSharedMenuNameList NE "" THEN "|" ELSE "") + cLabel
           cMenuDef            = cMenuDef + (IF cMenuDef NE "" THEN "," ELSE "") + ENTRY(ix,cMenuItems,"|") + ";" + cLabel + "&;StartSharedQuery;toggle¤enable"
           .
  END.
  DYNAMIC-FUNCTION("NewMenuBand",hSharedQueriesMenu,
                   cMenuDef,"").

  DO ix = 1 TO NUM-ENTRIES(cSharedMenuIdList):
    hMenuItem = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"menu-item" + ENTRY(ix,cSharedMenuIdList))) NO-ERROR.
    IF VALID-HANDLE(hMenuItem) THEN
      hMenuItem:LABEL = REPLACE(hMenuItem:LABEL,CHR(3),",").
  END.
  cSharedMenuNameList = REPLACE(cSharedMenuNameList,CHR(3),",").

  hSharedQueriesMenu:SENSITIVE = YES.

  IF LOOKUP(cCurrQueryId,cSharedMenuIdList) > 0 THEN 
    ASSIGN fiCurrentQuery:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(LOOKUP(cCurrQueryId,cSharedMenuIdList),cSharedMenuNameList,CHR(1))
           fiCurrentQuery:HIDDEN   = NO
           fiCurrentQuery:MODIFIED = NO
           hBtnSaveQuery:HIDDEN    = NO
           hBtnSaveQuery:SENSITIVE = NO
           hBtnDeleteQuery:HIDDEN  = NO
           hBtnShareQuery:HIDDEN   = NO
           hMenuItemShareQuery:SENSITIVE = YES
           hMenuItem               = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hToolbar,"menu-item" + cCurrQueryId))
           hMenuItem:CHECKED       = YES
           NO-ERROR.
END.
ELSE 
  ASSIGN hSharedQueriesMenu:SENSITIVE                 = NO
         fiCurrentQuery:HIDDEN IN FRAME {&FRAME-NAME} = YES
         hBtnSaveQuery:HIDDEN                         = YES
         hBtnDeleteQuery:HIDDEN                       = YES
         hBtnShareQuery:HIDDEN                        = YES
         hMenuItemShareQuery:SENSITIVE                = NO
         NO-ERROR.

PUBLISH "RebuildActionMenu".

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSMSButton C-Win 
FUNCTION setSMSButton RETURNS LOGICAL
  ( INPUT ibSMSButton AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bSMSButton = ibSMSButton.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTotalFields C-Win 
FUNCTION setTotalFields RETURNS LOGICAL
  ( INPUT icTotalFields AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Must be set prior to InitializeObject. Use ExtraFlatViewRecord
------------------------------------------------------------------------------*/
cTotalFields = icTotalFields.

RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTotalFieldsMenu C-Win 
FUNCTION setTotalFieldsMenu RETURNS LOGICAL
  ( INPUT icViewType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hMenuItem  AS HANDLE NO-UNDO.
DEF VAR hNextItem  AS HANDLE NO-UNDO.
DEF VAR hField     AS HANDLE NO-UNDO.
DEF VAR cLabel     AS CHAR   NO-UNDO.
DEF VAR hColumn    AS HANDLE NO-UNDO.

hMenuItem = hTotalsMenu:FIRST-CHILD NO-ERROR.
REPEAT WHILE VALID-HANDLE(hMenuItem):
  hNextItem = hMenuItem:NEXT-SIBLING.
  DELETE OBJECT hMenuItem.
  hMenuItem = hNextItem.
END.

hMenuItem = hExcelGraph:FIRST-CHILD NO-ERROR.
REPEAT WHILE VALID-HANDLE(hMenuItem):
  hNextItem = hMenuItem:NEXT-SIBLING.
  DELETE OBJECT hMenuItem.
  hMenuItem = hNextItem.
END.

ASSIGN cTotalLabels      = ""
       cTotalMenu        = ""
       cAccumTotalFields = "".

IF icViewType = "details" THEN DO:

  IF cTotalFields NE "none" AND cTotalFields NE "" THEN
    DO ix = 1 TO hBrowse:NUM-COLUMNS:
      cLabel = DYNAMIC-FUNCTION("getStrippedSortLabel",hBrowse:GET-BROWSE-COLUMN(ix)).
      IF hBrowse:GET-BROWSE-COLUMN(ix):VISIBLE AND CAN-DO(cTotalFields,hBrowse:GET-BROWSE-COLUMN(ix):NAME) THEN
        ASSIGN cTotalLabels = cTotalLabels + cLabel + ","
               cTotalMenu   = cTotalMenu   + "TotalOf;" + cLabel + ";SumSelected" + ",".
    END.
  ELSE 
    DO ix = 1 TO hBrowse:NUM-COLUMNS:
      cLabel = DYNAMIC-FUNCTION("getStrippedSortLabel",hBrowse:GET-BROWSE-COLUMN(ix)).
      hField = hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD(hBrowse:GET-BROWSE-COLUMN(ix):NAME) NO-ERROR.
      IF hBrowse:GET-BROWSE-COLUMN(ix):VISIBLE AND NOT ERROR-STATUS:ERROR AND hField:DATA-TYPE = "DECIMAL" THEN
        ASSIGN cTotalLabels = cTotalLabels + cLabel + ","
               cTotalFields = cTotalFields + hField:NAME + ","
               cTotalMenu   = cTotalMenu   + "TotalOf;" + cLabel + ";SumSelected" + ",".
    END.
END.
ELSE DO:
  ASSIGN cGraphFields      = ""
         cGraphLabels      = ""
         cGraphMenu        = "".

  IF cTotalFields NE "none" AND cTotalFields NE "" THEN 
    DO ix = 1 TO NUM-ENTRIES(cTotalFields) + 2:
      IF ix LE NUM-ENTRIES(cTotalFields) THEN
        hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hBrowse,ENTRY(ix,cTotalFields)).
      ELSE IF ix = NUM-ENTRIES(cTotalFields) + 1 THEN
        hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hBrowse,"jbCountDistinct").
      ELSE IF ix = NUM-ENTRIES(cTotalFields) + 2 THEN
        hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hBrowse,"jbAverage").
      ELSE hColumn = ?.

      IF VALID-HANDLE(hColumn) AND hColumn:VISIBLE THEN DO:
        IF ix LE NUM-ENTRIES(cTotalFields) + 1 THEN
          cAccumTotalFields = cAccumTotalFields +
                              (IF cAccumTotalFields NE "" THEN "," ELSE "") + 
                              (IF ix LE NUM-ENTRIES(cTotalFields) THEN ENTRY(ix,cTotalFields)
                               ELSE "jbCountDistinct").

        cLabel = DYNAMIC-FUNCTION("getStrippedSortLabel",hColumn).

        IF (CAN-DO(cTotalFields,hColumn:NAME) AND NOT CAN-DO("jbAverage",hColumn:NAME))
          OR hColumn:NAME = "jbCountDistinct" THEN
          ASSIGN cTotalLabels = cTotalLabels + cLabel + ","
                 cTotalMenu   = cTotalMenu   + "TotalOf;" + cLabel + ";SumSelected" + ",".

        IF (CAN-DO(cTotalFields,hColumn:NAME) OR CAN-DO("jbAverage,jbCountDistinct",hColumn:NAME)) THEN
          ASSIGN cGraphLabels = cGraphLabels +  cLabel + ","
                 cGraphFields = cGraphFields + hColumn:NAME + "," 
                 cGraphMenu   = cGraphMenu   + "GraphOf;" +  cLabel + ";ExcelGraph" + ",".
      END.
    END.
  ELSE 
    DO ix = 1 TO hBrowse:NUM-COLUMNS:
      IF NOT hBrowse:GET-BROWSE-COLUMN(ix):VISIBLE THEN NEXT.
      cLabel = DYNAMIC-FUNCTION("getStrippedSortLabel",hBrowse:GET-BROWSE-COLUMN(ix)).

      hField = hBrowse:QUERY:GET-BUFFER-HANDLE(1):BUFFER-FIELD(hBrowse:GET-BROWSE-COLUMN(ix):NAME) NO-ERROR.
      IF (NOT ERROR-STATUS:ERROR AND hField:DATA-TYPE = "DECIMAL" AND NOT CAN-DO("jbAverage",hBrowse:GET-BROWSE-COLUMN(ix):NAME))
         OR hBrowse:GET-BROWSE-COLUMN(ix):NAME = "jbCountDistinct" THEN
        ASSIGN cTotalLabels = cTotalLabels + cLabel + ","
               cTotalMenu   = cTotalMenu   + "TotalOf;" + cLabel + ";SumSelected" + ",".

      IF (NOT ERROR-STATUS:ERROR AND hField:DATA-TYPE = "DECIMAL") OR CAN-DO("jbAverage,jbCountDistinct",hBrowse:GET-BROWSE-COLUMN(ix):NAME) THEN
        ASSIGN cGraphLabels = cGraphLabels +  cLabel + ","
               cGraphFields = cGraphFields + hBrowse:GET-BROWSE-COLUMN(ix):NAME + "," 
               cGraphMenu   = cGraphMenu   + "GraphOf;" +  cLabel + ";ExcelGraph" + ",".
    END.

  ASSIGN cGraphLabels = TRIM(cGraphLabels,",")
         cGraphFields = TRIM(cGraphFields,",")
         cGraphMenu   = TRIM(cGraphMenu,",")
         .
  IF VALID-HANDLE(hExcelGraph) AND cGraphMenu NE "" AND NUM-ENTRIES(DYNAMIC-FUNCTION("getAttribute",hBrowse,"distinctcolumns")) = 1 THEN DO:
    DYNAMIC-FUNCTION("setObjectSourceProc",THIS-PROCEDURE).
    DYNAMIC-FUNCTION("NewMenuBand",hExcelGraph,cGraphMenu,"").
    hExcelGraph:SENSITIVE = INT(DYNAMIC-FUNCTION("getAttribute",hBrowse,"recordCount")) < iMaxGraph.
  END.
END.

ASSIGN cTotalLabels = TRIM(cTotalLabels,",")
       cTotalFields = TRIM(cTotalFields,",")
       cTotalMenu   = TRIM(cTotalMenu,",")
       .

IF cTotalMenu NE "" THEN DO:
  DYNAMIC-FUNCTION("setObjectSourceProc",THIS-PROCEDURE).
  DYNAMIC-FUNCTION("NewMenuBand",hTotalsMenu,cTotalMenu,"").
END.  
ELSE 
  hTotalsMenu:SENSITIVE = NO.


RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseLocalData C-Win 
FUNCTION setUseLocalData RETURNS LOGICAL
  ( ibUseLocalData AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Must be set prior to InitializeObject. Use ExtraFlatViewRecord
------------------------------------------------------------------------------*/
IF ibUseLocalData THEN
  cUseLocalData = "yes".
ELSE
  cUseLocalData = "".

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUseStdAppserver C-Win 
FUNCTION setUseStdAppserver RETURNS LOGICAL
  ( INPUT ibUseStdAppServer AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bUseStdAppServer = ibUseStdAppServer.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewAllTablesMenu C-Win 
FUNCTION setViewAllTablesMenu RETURNS LOGICAL
  ( INPUT icViewType AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hMenuItem  AS HANDLE NO-UNDO.
DEF VAR hNextItem  AS HANDLE NO-UNDO.
DEF VAR hField     AS HANDLE NO-UNDO.
DEF VAR cLabel     AS CHAR   NO-UNDO.
DEF VAR hColumn    AS HANDLE NO-UNDO.
DEF VAR cMenu      AS CHAR   NO-UNDO.
DEF VAR cTables    AS CHAR   NO-UNDO.

hMenuItem = hViewTablesMenu:FIRST-CHILD NO-ERROR.
REPEAT WHILE VALID-HANDLE(hMenuItem):
  hNextItem = hMenuItem:NEXT-SIBLING.
  DELETE OBJECT hMenuItem.
  hMenuItem = hNextItem.
END.

IF NOT JBoxSession:Instance:SuperUser THEN RETURN NO.

IF icViewType = "details" THEN DO:
  cTables = DYNAMIC-FUNCTION("getAttribute",hBrowse,"bufferlist").

  DO ix = 1 TO NUM-ENTRIES(cTables):
    cMenu   = cMenu   + "DetailsOf;" + ENTRY(ix,cTables) + ";TableDetails" + ",".
  END.
END.

cMenu = TRIM(cMenu,",").

IF cMenu NE "" THEN DO:
  DYNAMIC-FUNCTION("setObjectSourceProc",THIS-PROCEDURE).
  DYNAMIC-FUNCTION("NewMenuBand",hViewTablesMenu,cMenu,"").
END.  
ELSE 
  hViewTablesMenu:SENSITIVE = NO.


RETURN YES.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWinTitle C-Win 
FUNCTION setWinTitle RETURNS LOGICAL
  ( INPUT icWinTitle AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
ASSIGN cOrgWinTitle = icWinTitle
       THIS-PROCEDURE:CURRENT-WINDOW:TITLE = icWinTitle.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setWordButton C-Win 
FUNCTION setWordButton RETURNS LOGICAL
  ( INPUT ibWordButton AS LOG) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bWordButton = ibWordButton.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StartQuery C-Win 
FUNCTION StartQuery RETURNS LOGICAL
  ( INPUT icFilterFields    AS CHAR,
    INPUT icFilterOperators AS CHAR,
    INPUT icFilterValues    AS CHAR,
    INPUT icInitSort        AS CHAR,
    INPUT icDistinctCols    AS CHAR,
    INPUT icAccumFields     AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hColumn AS HANDLE  NO-UNDO.
DEF VAR bLocal             AS LOG    NO-UNDO.
DEF VAR cDistDbFields      AS CHAR   NO-UNDO.
DEF VAR cAccumDbFields     AS CHAR   NO-UNDO.
DEF VAR ix                 AS INT    NO-UNDO.
          
bLocal = DYNAMIC-FUNCTION("getAttribute",hBrowse,"useLocalData") = "yes".
IF bLocal THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"useLocalData","").

DYNAMIC-FUNCTION("setAttribute",hBrowse,"distinctcolumns",icDistinctCols).
DYNAMIC-FUNCTION("setAttribute",hBrowse,"accumfields",icAccumFields).

DO ix = 1 TO NUM-ENTRIES(icDistinctCols):
  IF NOT CAN-DO(cDistDbFields,DYNAMIC-FUNCTION("getAttribute",hBrowse,"fieldBuffer" + ENTRY(ix,icDistinctCols))) THEN
    cDistDbFields = cDistDbFields + (IF cDistDbFields NE "" THEN "," ELSE "")
                  + DYNAMIC-FUNCTION("getAttribute",hBrowse,"fieldBuffer" + ENTRY(ix,icDistinctCols))
                  .
END.  
DYNAMIC-FUNCTION("setAttribute",hBrowse,"distinctTables",cDistDbFields).

DO ix = 1 TO NUM-ENTRIES(icAccumFields):
  IF NOT CAN-DO(cAccumDbFields,DYNAMIC-FUNCTION("getAttribute",hBrowse,"fieldBuffer" + ENTRY(ix,icAccumFields))) THEN
    cAccumDbFields = cAccumDbFields + (IF cAccumDbFields NE "" THEN "," ELSE "")
                   + DYNAMIC-FUNCTION("getAttribute",hBrowse,"fieldBuffer" + ENTRY(ix,icAccumFields))
                   .
END.  
DYNAMIC-FUNCTION("setAttribute",hBrowse,"accumTables",cAccumDbFields).

IF icInitSort NE "" AND icDistinctCols = "" THEN DO:
  DYNAMIC-FUNCTION("setSortString",hBrowse,icInitSort).
  CreateSearchField(ENTRY(1,icInitSort)).
END.
ELSE IF icDistinctCols NE "" THEN DO:
  DYNAMIC-FUNCTION("setSortString",hBrowse,icDistinctCols).
  CreateSearchField(ENTRY(1,icDistinctCols)).
END.
ELSE DO:
  icInitSort = ENTRY(1,DYNAMIC-FUNCTION("getAttribute",hBrowse,"allViewFields")).
  DYNAMIC-FUNCTION("setSortString",hBrowse,icInitSort).
  CreateSearchField(icInitSort).
END.

IF icFilterFields NE "" THEN
  DYNAMIC-FUNCTION("InitDynFilter",hBrowse
                   ,icFilterFields
                   ,icFilterOperators
                   ,icFilterValues
                   ,"").

ELSE DO:
  DYNAMIC-FUNCTION("setCurrentObject",hBrowse).
  RUN OpenQuery.
END.

IF icDistinctCols NE "" THEN DO:    
  hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hBrowse,"jbCountDistinct").
  IF VALID-HANDLE(hColumn) THEN hColumn:VISIBLE = YES.

  IF icAccumFields NE "" AND NUM-ENTRIES(icAccumFields) = 1 THEN DO:
    hColumn = DYNAMIC-FUNCTION("getBrowseColumn",hBrowse,"jbAverage").
    IF VALID-HANDLE(hColumn) THEN hColumn:VISIBLE = YES.
  END.

  DYNAMIC-FUNCTION("setBrowseColumns",hBrowse,
                   icDistinctCols    + (IF icAccumFields NE "" AND NUM-ENTRIES(icAccumFields) = 1 THEN 
                                          "," + icAccumFields + ",jbCountDistinct,jbAverage" 
                                        ELSE IF icAccumFields NE "" THEN
                                          "," + icAccumFields + ",jbCountDistinct"
                                        ELSE ",jbCountDistinct"),NO).    

  RUN DynAccumDone (hBrowse,"accum").
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"uselocaldata","yes").
END.
ELSE IF bLocal THEN
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"useLocalData","yes").
  
RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StartQueryCls C-Win 
FUNCTION StartQueryCls RETURNS LOGICAL
  ( INPUT icFilterFields    AS CHAR,
    INPUT icFilterOperators AS CHAR,
    INPUT icFilterValues    AS CHAR,
    INPUT icInitSort        AS CHAR,
    INPUT icDistinctCols    AS CHAR,
    INPUT icAccumFields     AS CHAR) :
/*------------------------------------------------------------------------------
 Purpose: Enable the JBoxDynDataBrowse to use the method name StartQuery
 Notes:
------------------------------------------------------------------------------*/
        RETURN StartQuery(icFilterFields,icFilterOperators,icFilterValues,icInitSort,icDistinctCols,icAccumFields).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ViewQueryStat C-Win 
FUNCTION ViewQueryStat RETURNS LOGICAL
  ( INPUT ihBrowse AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/* MESSAGE PROGRAM-NAME(1) SKIP                                              */
/*         DYNAMIC-FUNCTION("getAttribute",ihBrowse,"QueryStatFieldValues")  */
/*         VIEW-AS ALERT-BOX.                                                */

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

