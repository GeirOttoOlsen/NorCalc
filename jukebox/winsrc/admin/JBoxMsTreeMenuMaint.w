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
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   
/* Uncomment to enable use of .Net components: */
 &SCOPED-DEFINE AdvGuiWin

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
/*&SCOPED-DEFINE PureABLWin 1*/

DEF VAR bOk               AS LOG NO-UNDO.
DEF VAR ix                AS INT NO-UNDO.

DEF VAR hTabFolder        AS HANDLE NO-UNDO.
DEF VAR iTab              AS INT    NO-UNDO.
DEF VAR hCurrTabProc      AS HANDLE NO-UNDO.
DEF VAR hParent           AS HANDLE NO-UNDO.

DEF VAR hToolBar          AS HANDLE NO-UNDO.
DEF VAR hWinToolBar       AS HANDLE NO-UNDO.

DEF VAR hTempTable        AS HANDLE NO-UNDO.
/*DEF VAR hQuery            AS HANDLE NO-UNDO.*/
/*DEF VAR oQryJBoxMenu:BUFFER-HANDLE           AS HANDLE NO-UNDO.*/

DEF VAR cTreeDragNode     AS CHAR   NO-UNDO.
DEF VAR hTree             AS HANDLE NO-UNDO.
DEF VAR cSelectNode       AS CHAR   NO-UNDO.
DEF VAR hTreeViewFrame    AS HANDLE NO-UNDO.
DEF VAR iRootNode         AS INT    NO-UNDO.
DEF VAR hTestTree         AS HANDLE NO-UNDO.
DEF VAR bMultiMenu        AS LOG    NO-UNDO.
DEF VAR hTestMenu         AS HANDLE NO-UNDO.
DEF VAR hMenuLinks        AS HANDLE NO-UNDO.
DEF VAR bTranslationInst  AS LOG    NO-UNDO.
DEF VAR hMenuTranslation  AS HANDLE NO-UNDO.

DEF VAR oContainer  AS JBoxContainer NO-UNDO.

DEF VAR oJBoxMsTreeView AS uc.JBoxMsTreeView NO-UNDO.

DEF TEMP-TABLE ttExpand
    FIELD cNodeIndex AS CHAR
    FIELD bExpanded  AS LOGICAL.


DEF VAR oTabMenu AS JBoxMsTabs NO-UNDO.

DEF VAR oQryJBoxMenu AS JBoxQuery NO-UNDO.



DEF VAR oTbJBoxMenu AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rectTreeView TabMenu TbJBoxMenu cmbMenu ~
TestAsRibbon_TbJBoxMenu 
&Scoped-Define DISPLAYED-OBJECTS cmbMenu 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNextMenuNum C-Win 
FUNCTION getNextMenuNum RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNodeIndex C-Win 
FUNCTION getNodeIndex RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentId C-Win 
FUNCTION getParentId RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentNodeIndex C-Win 
FUNCTION getParentNodeIndex RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD InitializePopupMenus C-Win 
FUNCTION InitializePopupMenus RETURNS LOGICAL
  ( INPUT icType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD InitializeResize C-Win 
FUNCTION InitializeResize RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RefreshMenuDropDown C-Win 
FUNCTION RefreshMenuDropDown RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ReposToMenuId C-Win 
FUNCTION ReposToMenuId RETURNS LOGICAL
  ( INPUT iMyParameter AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setImgSize C-Win 
FUNCTION setImgSize RETURNS LOGICAL
  ( INPUT icImage      AS CHAR,
    INPUT icImageField AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSelectNode C-Win 
FUNCTION setSelectNode RETURNS LOGICAL
  ( INPUT icSelectNode AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD TabChanged C-Win 
FUNCTION TabChanged RETURNS LOGICAL
  ( INPUT iiTab AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ValidateImage C-Win 
FUNCTION ValidateImage RETURNS LOGICAL
  ( INPUT icImage AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ValidDropNode C-Win 
FUNCTION ValidDropNode RETURNS LOGICAL
  ( INPUT icDropId  AS CHAR,
    INPUT icDragId  AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON TestAsRibbon_TbJBoxMenu 
     LABEL "Test" 
     SIZE 6 BY 1.1.

DEFINE VARIABLE cmbMenu AS CHARACTER FORMAT "X(256)":U 
     LABEL "Menu" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     DROP-DOWN-LIST
     SIZE 42 BY 1 NO-UNDO.

DEFINE RECTANGLE rectTreeView
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49 BY 25.

DEFINE RECTANGLE TabMenu
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 117 BY 25.

DEFINE RECTANGLE TbJBoxMenu
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 116.6 BY 1.29.

DEFINE BUTTON btnSplitBarX  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE .8 BY 25
     BGCOLOR 12 FGCOLOR 12 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cmbMenu AT ROW 1.33 COL 7 COLON-ALIGNED
     TestAsRibbon_TbJBoxMenu AT ROW 1.33 COL 53.2 WIDGET-ID 20
     rectTreeView AT ROW 2.67 COL 2
     TabMenu AT ROW 2.67 COL 53 WIDGET-ID 2
     TbJBoxMenu AT ROW 1.24 COL 53 WIDGET-ID 18
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 169.6 BY 26.91.

DEFINE FRAME frSplitBarX
     btnSplitBarX AT ROW 1 COL 13.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 38.6 ROW 2.67
         SIZE 18.4 BY 25.


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
         HEIGHT             = 26.91
         WIDTH              = 169.6
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

{incl/devmode.i}
{incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME frSplitBarX:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       TbJBoxMenu:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "TestAsRibbon|;Test,MenuLinks|File;Manage menu links¤menu,Export|File;Export¤menu,ImportXML|File;Import xml menu¤menuenable,Search|File;Search program (launch)¤menu,SearchLabel|File;Search menu label¤menuFileborder".

/* SETTINGS FOR FRAME frSplitBarX
                                                                        */
ASSIGN 
       btnSplitBarX:MOVABLE IN FRAME frSplitBarX          = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frSplitBarX
/* Query rebuild information for FRAME frSplitBarX
     _Query            is NOT OPENED
*/  /* FRAME frSplitBarX */
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


&Scoped-define FRAME-NAME frSplitBarX
&Scoped-define SELF-NAME btnSplitBarX
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarX C-Win
ON END-MOVE OF btnSplitBarX IN FRAME frSplitBarX
DO:
  DYNAMIC-FUNCTION("setSplitBarX" , THIS-PROCEDURE:CURRENT-WINDOW, btnSplitBarX:HANDLE IN FRAME frSplitBarX,NO).
  RUN MoveToTop IN hCurrTabProc NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME cmbMenu
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cmbMenu C-Win
ON VALUE-CHANGED OF cmbMenu IN FRAME DEFAULT-FRAME /* Menu */
DO:
  RUN FillTreeView.
  APPLY "end-move" TO btnSplitBarX IN FRAME frSplitBarX.
  
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
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN
    RETURN NO-APPLY "cancel".
  DYNAMIC-FUNCTION("setCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  IF VALID-HANDLE(hTestMenu) THEN APPLY "close" TO hTestMenu.
  IF VALID-HANDLE(hMenuLinks) THEN APPLY "CLOSE" TO hMenuLinks.
  IF VALID-HANDLE(hMenuTranslation) THEN APPLY "close" TO hMenuTranslation.
  RUN disable_UI.
  RETURN.
END.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

{incl/wintrigg.i}

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  
  hParent = SOURCE-PROCEDURE.

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
  &ENDIF

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/*ON "window-resized" OF {&WINDOW-NAME} DO:                                                                     */
/*  DYNAMIC-FUNCTION("setWidgetResize",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE:CURRENT-WINDOW,"resize","").*/
/*  RUN MoveToTop IN hCurrTabProc NO-ERROR.                                                                     */
/*END.                                                                                                          */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteLinkRecord C-Win 
PROCEDURE DeleteLinkRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN DeleteLink IN hCurrTabProc.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteRecord C-Win 
PROCEDURE DeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN DeleteRecord IN hCurrTabProc.

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
/*
IF bMultiMenu AND oQryJBoxMenu:BUFFER-HANDLE:AVAIL AND oQryJBoxMenu:BUFFER-HANDLE::cMenuType NE "menu" THEN
  DYNAMIC-FUNCTION("setAttribute",hToolbar,"disabledevents","test").
ELSE
  DYNAMIC-FUNCTION("setAttribute",hToolbar,"disabledevents","").
*/
IF iTab = 1 AND oQryJBoxMenu:BUFFER-HANDLE:AVAIL THEN do:
  DYNAMIC-FUNCTION("setAttribute",oTabMenu:getPageQuery(iTab),
                   "queryjoin", 
                 ",FIRST JBoxMenuToMenu NO-LOCK OUTER-JOIN"
               + " WHERE JBoxMenuToMenu.iFromMenuId = " + STRING(oQryJBoxMenu:BUFFER-HANDLE::iJBoxMenuId)
               + " AND JBoxMenuToMenu.iToMenuId = " + getParentId()).
end.

RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DropNode C-Win 
PROCEDURE DropNode :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF INPUT PARAM icDragId AS CHAR NO-UNDO.
DEF INPUT PARAM icDropId AS CHAR NO-UNDO.

DEF VAR iDragLevel      AS INT  NO-UNDO.
DEF VAR iDropLevel      AS INT  NO-UNDO.
DEF VAR cDragLabel      AS CHAR NO-UNDO.
DEF VAR cDropLabel      AS CHAR NO-UNDO.
DEF VAR cDragType       AS CHAR NO-UNDO.
DEF VAR cDropType       AS CHAR NO-UNDO.
DEF VAR cDragParentId   AS CHAR NO-UNDO.
DEF VAR cDragParentIdx  AS CHAR NO-UNDO.
DEF VAR cDropParentIdx  AS CHAR NO-UNDO.
DEF VAR cExtraMsg       AS CHAR NO-UNDO.
DEF VAR cReturn         AS CHAR NO-UNDO.
DEF VAR cDropMenuId     AS CHAR NO-UNDO.
DEF VAR cDragMenuId     AS CHAR NO-UNDO.

bOK = oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iNodeIndex = " + icDropId) NO-ERROR.
IF NOT bOK THEN RETURN.

ASSIGN cDropLabel     = oQryJBoxMenu:BUFFER-HANDLE::cMenuLabel
       iDropLevel     = oQryJBoxMenu:BUFFER-HANDLE::iLevel
       cDropType      = oQryJBoxMenu:BUFFER-HANDLE::cMenuType
       cDropMenuId    = STRING(oQryJBoxMenu:BUFFER-HANDLE::iJBoxMenuId)
       cDropParentIdx = oQryJBoxMenu:BUFFER-HANDLE:BUFFER-FIELD("iParentNodeIndex"):STRING-VALUE
       .

oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iNodeIndex = " + icDragId) NO-ERROR.
IF NOT bOK THEN RETURN.

ASSIGN cDragLabel     = oQryJBoxMenu:BUFFER-HANDLE::cMenuLabel
       cDragType      = oQryJBoxMenu:BUFFER-HANDLE::cMenuType
       cDragParentId  = oQryJBoxMenu:BUFFER-HANDLE:BUFFER-FIELD("iParentMenuId"):STRING-VALUE
       cDragParentIdx = oQryJBoxMenu:BUFFER-HANDLE:BUFFER-FIELD("iParentNodeIndex"):STRING-VALUE
       iDragLevel     = oQryJBoxMenu:BUFFER-HANDLE::iLevel
       cDragMenuId    = STRING(oQryJBoxMenu:BUFFER-HANDLE::iJBoxMenuId)
       .

IF cDragParentIdx = cDropParentIdx AND NOT CAN-DO("sub-menu,menubar,tv-nav-bar",cDropType) THEN DO:
  IF NOT DYNAMIC-FUNCTION("getActionPermission",THIS-PROCEDURE:FILE-NAME,"","drop") THEN DO:
    DYNAMIC-FUNCTION("DoMessage",0,0,"Sorry, you don't have permission to do this operation","",""). 
    RETURN.  
  END.
  IF NOT DYNAMIC-FUNCTION("runProc","jbadmin_change_menu_sequence.p",cDragMenuId + "|" + cDragParentId + "|" + cDropMenuId + "|" + cReturn,?) THEN 
    DYNAMIC-FUNCTION("DoMessage",0,0,DYNAMIC-FUNCTION("getTransactionMessage"),"","").
  ELSE DO:
    cSelectNode = icDropId.  
    RUN FillTreeView.
  END.
  RETURN.
END.

IF icDragId = icDropId 
   OR icDropId    = cDragParentId
   OR CAN-DO("placeholder,rule,menu-item",cDropType)
   OR (NOT CAN-DO("menubar,tv-nav-bar",cDragType) AND cDropType = "menu") 
   OR NOT ValidDropNode(cDropMenuId,cDragMenuId)
   THEN
  RETURN.

RUN JBoxDSimpleSelectList.w ('Move "' + cDragLabel + '" to "' + cDropLabel + "|move|"
                           + (IF cDragParentIdx = cDropParentIdx THEN
                               'Move "' + cDragLabel + '" after "' + cDropLabel + '"|moveafter'
                              ELSE
                               'Copy "' + cDragLabel + '" to "' + cDropLabel + '"|copy')
                             ,?,
                             OUTPUT cReturn).


IF NOT DYNAMIC-FUNCTION("getActionPermission",THIS-PROCEDURE:FILE-NAME,"","drop") THEN DO:
  DYNAMIC-FUNCTION("DoMessage",0,0,"Sorry, you don't have permission to do this operation","",""). 
  RETURN.  
END.

IF cReturn NE ? THEN DO:
  IF cReturn = "moveafter" THEN DO:
    IF NOT DYNAMIC-FUNCTION("runProc","jbadmin_change_menu_sequence.p",cDragMenuId + "|" + cDragParentId + "|" + cDropMenuId + "|" + cReturn,?) THEN 
      DYNAMIC-FUNCTION("DoMessage",0,0,DYNAMIC-FUNCTION("getTransactionMessage"),"","").
  END.
  ELSE DO:
    IF NOT DYNAMIC-FUNCTION("runProc","jbadmin_drop_menu_node.p",cDragMenuId + "|" + cDragParentId + "|" + cDropMenuId + "|" + cReturn,?) THEN DO:
      DYNAMIC-FUNCTION("DoMessage",0,0,DYNAMIC-FUNCTION("getTransactionMessage"),"","").
      RETURN.
    END.
  END.
  cSelectNode = icDropId.  
  RUN FillTreeView.
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
  DISPLAY cmbMenu 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE rectTreeView TabMenu TbJBoxMenu cmbMenu TestAsRibbon_TbJBoxMenu 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE btnSplitBarX 
      WITH FRAME frSplitBarX IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frSplitBarX}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportRecord C-Win 
PROCEDURE ExportRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cFileName AS CHAR NO-UNDO.
DEF VAR hBuffParent AS HANDLE NO-UNDO.
cFileName = JBoxFunctions:Instance:getTempFile("p").

oQryJBoxMenu:QUERY-HANDLE:GET-FIRST().
IF oQryJBoxMenu:QUERY-HANDLE:QUERY-OFF-END THEN RETURN.

CREATE BUFFER hBuffParent FOR TABLE oQryJBoxMenu:BUFFER-HANDLE.

OUTPUT TO VALUE(cFileName).

PUT UNFORMATTED 'oMenuXML = NEW JBoxXmlDoc().' SKIP
                'oMenuXML:AddBlockNode("menu").' SKIP
                'oMenuXML:AddNode("cStateImage","' + oQryJBoxMenu:BUFFER-HANDLE::cStateImage + '"). /* logo */' SKIP.

oQryJBoxMenu:QUERY-HANDLE:GET-NEXT().

REPEAT WHILE NOT oQryJBoxMenu:QUERY-HANDLE:QUERY-OFF-END:
  IF hBuffParent:FIND-FIRST("WHERE iNodeIndex = " + STRING(oQryJBoxMenu:BUFFER-HANDLE::iParentNodeIndex)) THEN DO:
    PUT UNFORMATTED SKIP(1) 'oMenuXML:AddBlockNode("' + hBuffParent::cMenuType + '","' + oQryJBoxMenu:BUFFER-HANDLE::cMenuType + '").' SKIP.
    IF CAN-DO("Sub-menu,menu-item",oQryJBoxMenu:BUFFER-HANDLE::cMenuType) THEN DO:
      PUT UNFORMATTED '  oMenuXML:AddNode("cMenuLabel","' + oQryJBoxMenu:BUFFER-HANDLE::cMenuLabel + '").' SKIP.
      IF oQryJBoxMenu:BUFFER-HANDLE::cImage NE "" THEN
        PUT UNFORMATTED '  oMenuXML:AddNode("cImage","' + oQryJBoxMenu:BUFFER-HANDLE::cImage + '").' SKIP.
    END.   
    IF oQryJBoxMenu:BUFFER-HANDLE::cMenuType = "menu-item" THEN DO:
      IF oQryJBoxMenu:BUFFER-HANDLE::cLaunchType NE "start-window" THEN
        PUT UNFORMATTED '  oMenuXML:AddNode("cLaunchType","' + oQryJBoxMenu:BUFFER-HANDLE::cLaunchType + '").' SKIP.
      PUT UNFORMATTED '  oMenuXML:AddNode("cLaunch","' + oQryJBoxMenu:BUFFER-HANDLE::cLaunch + '").' SKIP.
    END.  
  END.
  oQryJBoxMenu:QUERY-HANDLE:GET-NEXT().
END.
OUTPUT CLOSE.

OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).

/*
IF NOT DYNAMIC-FUNCTION("runProc","jbadmin_exportmenu.p","",?) THEN
  DYNAMIC-FUNCTION("DoMessage",0,0,DYNAMIC-FUNCTION("getTransactionMessage"),"","").
*/  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FillTreeView C-Win 
PROCEDURE FillTreeView :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR bEntries      AS LOG    NO-UNDO.
DEF VAR bCreTTExpand  AS LOG    NO-UNDO.
DEF VAR iRootIndex    AS INT    NO-UNDO.

oContainer:freezeContainer().

oQryJBoxMenu:BUFFER-HANDLE:EMPTY-TEMP-TABLE().
oJBoxMsTreeView:clearNodes().
ASSIGN iRootNode  = 0
       ix         = 0
       bMultiMenu = NO.

IF cSelectNode = "" THEN DO:
  bCreTTExpand = YES.  
  EMPTY TEMP-TABLE ttExpand.
END.

/* Here we pass the buffer for the already existing temp-table to for automatic fill. hDummyTT serves just as a placeholder for the return value */
DYNAMIC-FUNCTION("getTempTable","jbsetup_getmenustruct.p"
                  ,"WHERE " 
                 + (IF cmbMenu:SCREEN-VALUE IN FRAME {&FRAME-NAME} NE "" AND cmbMenu:SCREEN-VALUE NE ? THEN 
                     "iJBoxMenuId = " + cmbMenu:SCREEN-VALUE
                    ELSE "cMenuType = 'menu'")
                  ,oQryJBoxMenu:BUFFER-HANDLE).

/*run toexcelviafile.p(hTempTable:DEFAULT-BUFFER-HANDLE,0).*/

oQryJBoxMenu:QUERY-HANDLE:QUERY-PREPARE("FOR EACH JBoxMenu BY iNodeIndex").
oQryJBoxMenu:QUERY-HANDLE:QUERY-OPEN().
oQryJBoxMenu:QUERY-HANDLE:GET-FIRST().
REPEAT WHILE NOT oQryJBoxMenu:QUERY-HANDLE:QUERY-OFF-END:
  IF cSelectNode = "" THEN
    cSelectNode = STRING(oQryJBoxMenu:BUFFER-HANDLE::iNodeIndex).
  IF iRootNode = 0 THEN
    iRootNode = oQryJBoxMenu:BUFFER-HANDLE::iJBoxMenuId.
  IF iRootIndex = 0 THEN
    iRootIndex = oQryJBoxMenu:BUFFER-HANDLE::iNodeIndex.
  ELSE IF oQryJBoxMenu:BUFFER-HANDLE::iParentMenuId = 0 THEN
    bMultiMenu = YES.

  ix = ix + 1.

  IF bCreTTExpand THEN DO:
    CREATE ttExpand.  
    ttExpand.cNodeIndex = STRING(oQryJBoxMenu:BUFFER-HANDLE::iNodeIndex).
  END.

  oJBoxMsTreeView:AddNode(IF oQryJBoxMenu:BUFFER-HANDLE::iParentNodeIndex NE 0 THEN STRING(oQryJBoxMenu:BUFFER-HANDLE::iParentNodeIndex) ELSE "",
                          STRING(oQryJBoxMenu:BUFFER-HANDLE::iNodeIndex),
                          oQryJBoxMenu:BUFFER-HANDLE::cMenuLabel 
                 + " (" + oQryJBoxMenu:BUFFER-HANDLE::cMenuType + ")"
                 + " (" + STRING(oQryJBoxMenu:BUFFER-HANDLE::iSeq) + ")",
                          oQryJBoxMenu:BUFFER-HANDLE::cMenuType,
                          -1,
                          -1).

  oQryJBoxMenu:QUERY-HANDLE:GET-NEXT().
END.

IF cSelectNode NE "" THEN DO:
  oJBoxMsTreeView:SelectNode(cSelectNode).
  oJBoxMsTreeView:ExpandNodes(cSelectNode).
END.

oJBoxMsTreeView:AddContextMenuStrip("", "menu").
oJBoxMsTreeView:AddContextSubMenu("menu","","NewMenu", "New", "").
oJBoxMsTreeView:AddContextMenuItem("", "NewMenu", "MenuBarRecord","Menubar", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("", "NewMenu", "MenuTvNavBarRecord","Treeview/nav-bar/ribbon", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("", "NewMenu", "MenuRecord","Menu", "bmp\add.bmp").

oJBoxMsTreeView:AddContextMenuStrip("", "menubar").
oJBoxMsTreeView:AddContextMenuItem("menubar","","MenuSubRecord", "New sub-menu", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("menubar","","MenuItemRecord","New menu-item", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("menubar","","DeleteRecord","Delete", "bmp\deleterec.bmp").
oJBoxMsTreeView:AddContextMenuItem("menubar","","DeleteLinkRecord","Delete link to parent", "bmp\delete.bmp").
oJBoxMsTreeView:AddContextMenuItem("menubar","","WhereUsedRecord","Where used..", "bmp\links.bmp").

oJBoxMsTreeView:AddContextMenuStrip("", "tv-nav-bar").
oJBoxMsTreeView:AddContextMenuItem("tv-nav-bar","","MenuSubRecord", "New sub-menu", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("tv-nav-bar","","DeleteRecord","Delete", "bmp\deleterec.bmp").
oJBoxMsTreeView:AddContextMenuItem("tv-nav-bar","","DeleteLinkRecord","Delete link to parent", "bmp\delete.bmp").
oJBoxMsTreeView:AddContextMenuItem("tv-nav-bar","","WhereUsedRecord","Where used..", "bmp\links.bmp").

oJBoxMsTreeView:AddContextMenuStrip("", "sub-menu").
oJBoxMsTreeView:AddContextSubMenu("sub-menu","","NewSubMenu", "New", "").
oJBoxMsTreeView:AddContextMenuItem("", "NewSubMenu", "MenuItemRecord","Menu-item", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("", "NewSubMenu", "MenuSubRecord","Sub-menu", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("", "NewSubMenu", "MenuRuleRecord","Rule", "bmp\add.bmp").
oJBoxMsTreeView:AddContextMenuItem("sub-menu","","DeleteRecord","Delete", "bmp\deleterec.bmp").
oJBoxMsTreeView:AddContextMenuItem("sub-menu","","DeleteLinkRecord","Delete link to parent", "bmp\delete.bmp").
oJBoxMsTreeView:AddContextMenuItem("sub-menu","","WhereUsedRecord","Where used..", "bmp\links.bmp").

oJBoxMsTreeView:AddContextMenuStrip("", "menu-item").
oJBoxMsTreeView:AddContextMenuItem("menu-item","","DeleteRecord","Delete", "bmp\deleterec.bmp").
oJBoxMsTreeView:AddContextMenuItem("menu-item","","DeleteLinkRecord","Delete link to parent", "bmp\delete.bmp").
oJBoxMsTreeView:AddContextMenuItem("menu-item","","WhereUsedRecord","Where used..", "bmp\links.bmp").
oJBoxMsTreeView:AddContextMenuItem("menu-item","","RunMenuItem","Run..", "bmp\active16.bmp").

/*
IF ix = 0 THEN InitializePopupMenus("root").
ELSE DO:
   IF NOT bCreTTExpand THEN
     FOR EACH ttExpand
         WHERE ttExpand.bExpanded:
       DYNAMIC-FUNCTION("ExpandNode" IN hTree,ttExpand.cNodeIndex).
     END.
   ELSE IF ix < 30 THEN
     DYNAMIC-FUNCTION("ExpandTree" IN hTree, "").
   ELSE 
     DYNAMIC-FUNCTION("ExpandNode" IN hTree,STRING(iRootIndex)).       
END.

IF cSelectNode NE "" THEN DO:
  DYNAMIC-FUNCTION("SelectNode" IN hTree,cSelectNode).
  RUN tvNodeEvent("select",cSelectNode).
END.
*/
cSelectNode = "".

oContainer:unFreezeContainer().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getMinMaxImgSize C-Win 
PROCEDURE getMinMaxImgSize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM oiMinSize    AS INT  NO-UNDO INIT 100000000.
DEF OUTPUT PARAM ocSmallImg   AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocSmallNode  AS CHAR NO-UNDO.
DEF OUTPUT PARAM oiMaxSize    AS INT  NO-UNDO.
DEF OUTPUT PARAM ocBigImg     AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocBigNode    AS CHAR NO-UNDO.

DEF VAR hQuery AS HANDLE NO-UNDO.
DEF VAR hBuff  AS HANDLE NO-UNDO.

CREATE BUFFER hBuff FOR TABLE oQryJBoxMenu:BUFFER-HANDLE.

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(hBuff).
hQuery:QUERY-PREPARE("FOR EACH " + hBuff:NAME + " WHERE cMenuType NE 'menu'").
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  IF hBuff::iImageSize > 0 AND hBuff::iImageSize < oiMinSize THEN
    ASSIGN oiMinSize   = hBuff::iImageSize
           ocSmallImg  = hBuff::cImage
           ocSmallNode = hBuff::cMenuLabel
           .
  IF hBuff::iSelImageSize > 0 AND hBuff::iSelImageSize < oiMinSize THEN
    ASSIGN oiMinSize   = hBuff::iSelImageSize
           ocSmallImg  = hBuff::cSelImage
           ocSmallNode = hBuff::cMenuLabel
           .
  IF hBuff::iStateImageSize > 0 AND hBuff::iStateImageSize < oiMinSize THEN
    ASSIGN oiMinSize   = hBuff::iStateImageSize
           ocSmallImg  = hBuff::cStateImage
           ocSmallNode = hBuff::cMenuLabel
           .

  IF hBuff::iImageSize > 0 AND hBuff::iImageSize > oiMaxSize THEN
    ASSIGN oiMaxSize = hBuff::iImageSize
           ocBigImg  = hBuff::cImage
           ocBigNode = hBuff::cMenuLabel
           .
  IF hBuff::iSelImageSize > 0 AND hBuff::iSelImageSize > oiMaxSize THEN
    ASSIGN oiMaxSize = hBuff::iSelImageSize
           ocBigImg  = hBuff::cSelImage
           ocBigNode = hBuff::cMenuLabel
           .
  IF hBuff::iStateImageSize > 0 AND hBuff::iStateImageSize > oiMaxSize THEN
    ASSIGN oiMaxSize = hBuff::iStateImageSize
           ocBigImg  = hBuff::cStateImage
           ocBigNode = hBuff::cMenuLabel
           .

  hQuery:GET-NEXT().
END.

DELETE OBJECT hQuery.
DELETE OBJECT hBuff.

IF oiMinSize = 100000000 THEN oiMinSize = 0.
IF oiMaxSize = 0 THEN oiMaxSize = 100000000.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ImportXMLRecord C-Win 
PROCEDURE ImportXMLRecord :
DEF VAR lcXML         AS LONGCHAR NO-UNDO.
DEF VAR oMenuXml      AS JBoxXmlDoc NO-UNDO.
DEF VAR cFileName     AS CHAR NO-UNDO.
DEF VAR httMenu       AS HANDLE NO-UNDO.
DEF VAR hQuery        AS HANDLE NO-UNDO.
DEF VAR hBuffer       AS HANDLE NO-UNDO.
DEF VAR cJBoxMenuFlds AS CHAR NO-UNDO 
    INIT "cMenuType;character,cMenuLabel;character,iJBoxMenuId;integer,iJBoxProgramId;integer,dCreated;date,cCreatedBy;character,dModified;date,cModifiedBy;character,cLaunch;character,cAccelerator;character,cLaunchType;character,bConfigurable;logical,cImage;character,cSelImage;character,cStateImage;character,cTextColor;character,cFontStyle;character,cMenuTooltip;character,cMenuNumber;character,iTvNavBarStyle;integer,iImageSize;integer,iSelImageSize;integer,iStateImageSize;integer,cParameter;character,bLimitToCompanyAdmins;logical,bLimitToSuperUsers;logical,bDefault;logical"
         .

SYSTEM-DIALOG GET-FILE cFileName.

IF SEARCH(cFileName) NE ? THEN DO:

  COPY-LOB FROM FILE cFileName TO OBJECT lcXML.
      
  oMenuXml = NEW JBoxXmlDoc().
  oMenuXml:LoadXml(lcXML).
         
  CREATE TEMP-TABLE httMenu.
  
  DO ix = 1 TO NUM-ENTRIES(cJBoxMenuFlds):
    httMenu:ADD-NEW-FIELD(ENTRY(1,ENTRY(ix,cJBoxMenuFlds),";"),ENTRY(2,ENTRY(ix,cJBoxMenuFlds),";")).
  END.
  httMenu:ADD-NEW-FIELD("iParentMenuId","INTEGER").
  httMenu:ADD-NEW-FIELD("iRootMenuId","INTEGER").
  httMenu:ADD-NEW-FIELD("iLevel","INTEGER").
  httMenu:ADD-NEW-FIELD("iSeq","INTEGER").
  httMenu:ADD-NEW-FIELD("iNodeIndex","INTEGER").
  httMenu:ADD-NEW-FIELD("iColourCode","INTEGER").
  httMenu:ADD-NEW-FIELD("RowIdent1","CHARACTER").
  httMenu:ADD-NEW-FIELD("bDisabled","LOGICAL").
  httMenu:ADD-NEW-FIELD("hMenuItem","HANDLE").
  httMenu:ADD-NEW-FIELD("bMultiple","LOGICAL").
  httMenu:ADD-NEW-FIELD("cParentMenuType","CHARACTER").
  httMenu:ADD-NEW-FIELD("bHasChildSubMenu","LOGICAL").
  httMenu:ADD-NEW-FIELD("cParentImage","CHARACTER").
  httMenu:ADD-NEW-FIELD("iParentNodeIndex","INTEGER").
  httMenu:ADD-NEW-FIELD("bHasChildMenuItem","LOGICAL").
  
  httMenu:TEMP-TABLE-PREPARE("JBoxMenuImport").
  


/*run toexcelviafile.p (oMenuXml:hbttNodes,0).*/


  hBuffer = httMenu:DEFAULT-BUFFER-HANDLE.
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS (oMenuXml:hbttNodes).
  hQuery:QUERY-PREPARE("FOR EACH " + oMenuXml:hbttNodes:NAME + " BY iNodeIdx").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  ix = 1.
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    IF oMenuXml:hbttNodes::cViewType = "block" THEN DO:
      hBuffer:BUFFER-CREATE().
      ASSIGN hBuffer::iJBoxMenuId      = oMenuXml:hbttNodes::iNodeIdx
             hBuffer::iNodeIndex       = oMenuXml:hbttNodes::iNodeIdx
             hBuffer::iParentMenuId    = oMenuXml:hbttNodes::iParentNodeIdx 
             hBuffer::iParentNodeIndex = oMenuXml:hbttNodes::iParentNodeIdx 
             hBuffer::cMenuType        = oMenuXml:hbttNodes::cElement
             hBuffer::iLevel           = oMenuXml:hbttNodes::iLevel + 1
             hBuffer::bHasChildSubMenu = YES
             ix = ix + 1
             .
    END.
    ELSE hBuffer:BUFFER-FIELD(oMenuXml:hbttNodes::cElement):BUFFER-VALUE = oMenuXml:hbttNodes::cNodeValue.
     
    hQuery:GET-NEXT ().
  END.
/* run toexcelviafile.p (hBuffer,0).*/
  IF JBoxServerAPI:Instance:CallServerProc("jbadmin_import_menu.p","",hBuffer) THEN DO:
    cmbMenu:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = JBoxServerAPI:Instance:FieldListValid("JBoxMenu;cMenuLabel;iJBoxMenuId","WHERE cMenuType = 'menu'").
    JBoxSession:Instance:ViewMessage("Menu " + JBoxServerAPI:Instance:getCallReturnParam() + " created").
  END.  
END.

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
oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

RUN enable_UI.

DO WITH FRAME {&FRAME-NAME}:
  DYNAMIC-FUNCTION("NewObject",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE,"container").

  DYNAMIC-FUNCTION("runProc","jbsetup_fix_menu.p","",?).

  bTranslationInst = DYNAMIC-FUNCTION("IsFieldNameInTable","JBoxMenuTranslation","iJBoxMenuId").

  ASSIGN cmbMenu:DELIMITER = "|"
         cmbMenu:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldListValid("JBoxMenu;cMenuLabel;iJBoxMenuId","WHERE cMenuType = 'menu'").

  oJBoxMsTreeView = NEW uc.JBoxMsTreeView(THIS-PROCEDURE,rectTreeView:HANDLE,"tvpics\Fold.bmp,tvpics\FoldOpen.bmp,gif\flag_no.gif").
  oJBoxMsTreeView:RegisterWithJukeBox(YES).
  oJBoxMsTreeView:setAllowDrop(YES).
  
  /* Get the menu temp-table def. and create a query for it so the query can be linked to the fieldmap in the folder object.
     Note that the query is assigned the temp-table so it doesn't have to go to the server for the data definitions
     (it would not even be possible to get the same struct directly from the db) */
  hTempTable = DYNAMIC-FUNCTION("getTempTable","jbsetup_getmenustruct.p","where false",?).
                            
  oQryJBoxMenu = NEW JBoxQuery(hTempTable).
 
  oTabMenu = NEW JBoxMsTabs(TabMenu:HANDLE,oQryJBoxMenu,"newbmp\regblue.bmp;newbmp\user16.bmp;newbmp\application.bmp").
  oTabMenu:AddPage("Menu details", "JBoxMsMenuView.w","regblue.bmp").
  oTabMenu:AddPage("All menu-items", "JBoxMenuBrw.w","application.bmp").
 
  oTbJBoxMenu = NEW JBoxToolbar(TbJBoxMenu:HANDLE).

  oQryJBoxMenu:TOOLBAR-OBJECT = oTbJBoxMenu.

  InitializeResize().

  SESSION:SET-WAIT-STATE("").

END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuBarRecord C-Win 
PROCEDURE MenuBarRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN NewMenuItem IN hCurrTabProc ("MENUBAR").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuItemRecord C-Win 
PROCEDURE MenuItemRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN NewMenuItem IN hCurrTabProc ("MENU-ITEM").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuLinksRecord C-Win 
PROCEDURE MenuLinksRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF NOT VALID-HANDLE(hMenuLinks) THEN DO:
  RUN JboxSubMenuMaint.w PERSISTENT SET hMenuLinks.
  RUN InitializeObject IN hMenuLinks.
END.
RUN MoveToTop IN hMenuLinks NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuPlaceHolderRecord C-Win 
PROCEDURE MenuPlaceHolderRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN NewMenuItem IN hCurrTabProc ("PLACEHOLDER").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuRecord C-Win 
PROCEDURE MenuRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN NewMenuItem IN hCurrTabProc ("MENU").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuRuleRecord C-Win 
PROCEDURE MenuRuleRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN NewMenuItem IN hCurrTabProc ("RULE").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuSubRecord C-Win 
PROCEDURE MenuSubRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN NewMenuItem IN hCurrTabProc ("SUB-MENU").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuTvNavBarRecord C-Win 
PROCEDURE MenuTvNavBarRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN NewMenuItem IN hCurrTabProc ("TV-NAV-BAR").

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
APPLY "end-move" TO btnSplitBarX IN FRAME frSplitBarX.

IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
  RUN ShowForm("").

THIS-PROCEDURE:CURRENT-WINDOW:HIDDEN = FALSE.
THIS-PROCEDURE:CURRENT-WINDOW:WINDOW-STATE = 3.
THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
RUN MoveToTop IN hCurrTabProc NO-ERROR.
APPLY "entry" TO cmbMenu IN FRAME {&FRAME-NAME}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RunMenuItem C-Win 
PROCEDURE RunMenuItem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF NOT oQryJBoxMenu:BUFFER-HANDLE:AVAIL THEN RETURN.
  
IF VALID-HANDLE(hTestMenu) THEN DO:
  RUN ApplyMenu IN hTestMenu (?,oQryJBoxMenu:BUFFER-HANDLE::cLaunch,"") NO-ERROR.
  IF RETURN-VALUE = "not avail" THEN
    MESSAGE "Run the testmenu again to have the new node populated"
            VIEW-AS ALERT-BOX INFORMATION.
END.
ELSE DO:
  RUN ApplyMenu IN hParent (?,oQryJBoxMenu:BUFFER-HANDLE::cLaunch,"") NO-ERROR.
  IF RETURN-VALUE = "not avail" THEN
    MESSAGE "Run the testmenu to have the new node populated"
            VIEW-AS ALERT-BOX INFORMATION.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SearchLabelRecord C-Win 
PROCEDURE SearchLabelRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cReturn     AS CHAR   NO-UNDO.
DEF VAR iReturn     AS INT    NO-UNDO.
DEF VAR cNode       AS CHAR   NO-UNDO.
DEF VAR cParent     AS CHAR   NO-UNDO.
DEF VAR cExpandList AS CHAR   NO-UNDO.
DEF VAR hSearchBuff AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR cNodeList   AS CHAR   NO-UNDO.

RUN JBoxAskForValue.w ("Search for menu label","CHARACTER|x(40)",INPUT-OUTPUT cReturn,OUTPUT iReturn).
IF iReturn = 2 AND cReturn NE "" THEN DO:

  CREATE QUERY hQuery.
  CREATE BUFFER hSearchBuff FOR TABLE oQryJBoxMenu:BUFFER-HANDLE.
  hQuery:SET-BUFFERS(hSearchBuff).
  hQuery:QUERY-PREPARE("FOR EACH " + hSearchBuff:NAME
                     + " WHERE cMenuLabel " 
                     + (IF INDEX(cReturn,"*") > 0 THEN "MATCHES '" ELSE "BEGINS '") 
                     + cReturn + "'").

  hQuery:QUERY-OPEN().
  ix = 0.
  hQuery:GET-FIRST().
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    ASSIGN ix        = ix + 1.
           cNodeList = cNodeList + (IF cNodeList NE "" THEN "|" ELSE "")
                     + hSearchBuff::cMenuLabel 
                     + "|" + hSearchBuff:BUFFER-FIELD("iNodeIndex"):STRING-VALUE
                     + ";" + hSearchBuff:BUFFER-FIELD("iParentNodeIndex"):STRING-VALUE.
    hQuery:GET-NEXT().
  END.
  DELETE OBJECT hSearchBuff.
  DELETE OBJECT hQuery.

  IF ix > 1 THEN 
    RUN JBoxDSimpleSelectList.w (cNodeList,?,OUTPUT cReturn).
  ELSE IF ix = 1 THEN
    cReturn = ENTRY(2,cNodeList,"|").
  ELSE DO:
    DYNAMIC-FUNCTION("DoMessage",0,0,"Not found","","").
    cReturn = "".
  END.

  IF cReturn NE "" AND cReturn NE ? THEN DO:
    ASSIGN cNode   = ENTRY(1,cReturn,";")
           cParent = ENTRY(2,cReturn,";").

    DO ix = 1 TO 10:
      bOk = oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iNodeIndex = " + cParent) NO-ERROR.
      IF bOk THEN DO:
        ASSIGN cExpandList = oQryJBoxMenu:BUFFER-HANDLE:BUFFER-FIELD("iNodeIndex"):STRING-VALUE + "|" + cExpandList
               cParent = oQryJBoxMenu:BUFFER-HANDLE:BUFFER-FIELD("iParentNodeIndex"):STRING-VALUE.
      END.
      ELSE LEAVE.
    END.
    
    oJBoxMsTreeView:ExpandNodes(TRIM(cExpandList,"|")).
    oJBoxMsTreeView:SelectNode(TRIM(cNode)).
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SearchRecord C-Win 
PROCEDURE SearchRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cReturn     AS CHAR NO-UNDO.
DEF VAR iReturn     AS INT  NO-UNDO.
DEF VAR cNode       AS CHAR NO-UNDO.
DEF VAR cParent     AS CHAR NO-UNDO.
DEF VAR cExpandList AS CHAR NO-UNDO.
DEF VAR hSearchBuff AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR cNodeList   AS CHAR   NO-UNDO.

RUN JBoxAskForValue.w ("Search for program name","CHARACTER|x(40)",INPUT-OUTPUT cReturn,OUTPUT iReturn).

IF iReturn = 2 AND cReturn NE "" THEN DO:

  CREATE QUERY hQuery.
  CREATE BUFFER hSearchBuff FOR TABLE oQryJBoxMenu:BUFFER-HANDLE.
  hQuery:SET-BUFFERS(hSearchBuff).
  hQuery:QUERY-PREPARE("FOR EACH " + hSearchBuff:NAME
                     + " WHERE cLaunch " 
                     + (IF INDEX(cReturn,"*") > 0 THEN "MATCHES '" ELSE "BEGINS '") 
                     + cReturn + "'").

  hQuery:QUERY-OPEN().
  ix = 0.
  hQuery:GET-FIRST().
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    IF LOOKUP(hSearchBuff::cLaunch,cNodeList,"|") = 0 THEN
      ASSIGN ix        = ix + 1.
             cNodeList = cNodeList + (IF cNodeList NE "" THEN "|" ELSE "")
                       + hSearchBuff::cLaunch 
                       + "|" + hSearchBuff:BUFFER-FIELD("iNodeIndex"):STRING-VALUE
                       + ";" + hSearchBuff:BUFFER-FIELD("iParentNodeIndex"):STRING-VALUE.
    hQuery:GET-NEXT().
  END.
  DELETE OBJECT hSearchBuff.
  DELETE OBJECT hQuery.

  IF ix > 1 THEN 
    RUN JBoxDSimpleSelectList.w (cNodeList,?,OUTPUT cReturn).
  ELSE IF ix = 1 THEN
    cReturn = ENTRY(2,cNodeList,"|").
  ELSE DO:
    DYNAMIC-FUNCTION("DoMessage",0,0,"Not found","","").
    cReturn = "".
  END.

  IF cReturn NE "" AND cReturn NE ? THEN DO:
    ASSIGN cNode   = ENTRY(1,cReturn,";")
           cParent = ENTRY(2,cReturn,";").

    DO ix = 1 TO 10:
      bOk = oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iNodeIndex = " + cParent) NO-ERROR.
      IF bOk THEN DO:
        ASSIGN cExpandList = oQryJBoxMenu:BUFFER-HANDLE:BUFFER-FIELD("iNodeIndex"):STRING-VALUE + "|" + cExpandList
               cParent = oQryJBoxMenu:BUFFER-HANDLE:BUFFER-FIELD("iParentNodeIndex"):STRING-VALUE.
      END.
      ELSE LEAVE.
    END.

    oJBoxMsTreeView:ExpandNodes(TRIM(cExpandList,"|")).
    oJBoxMsTreeView:SelectNode(TRIM(cNode)).
    
  END.

END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShowImgListRecord C-Win 
PROCEDURE ShowImgListRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE(hTestTree) THEN 
  DYNAMIC-FUNCTION("DoMessage",0,20,
                    "Small images: " + DYNAMIC-FUNCTION("getImageList" IN hTestTree) + CHR(10) +
                    "Large images: " + DYNAMIC-FUNCTION("getLargeImageList" IN hTestTree),"","").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TestAsRibbonRecord C-Win 
PROCEDURE TestAsRibbonRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF VALID-HANDLE(hTestMenu) THEN DO:
  RUN CloseMenu IN hTestMenu.
  DELETE PROCEDURE hTestMenu NO-ERROR.    
END.

RUN SelectAppLanguage.

IF DYNAMIC-FUNCTION("getAttribute",SESSION,"mainMenuType") NE "ribbon" THEN DO:
  DYNAMIC-FUNCTION("setAttribute",SESSION,"mainMenuType","ribbon").
  RUN RestartMenu IN hParent.
END.
ELSE DO:
  RUN JBoxRibbonMenu.p PERSIST SET hTestMenu.
  
  IF NOT bMultiMenu THEN
    RUN InitializeObject IN hTestMenu (iRootNode).
  ELSE
    RUN InitializeObject IN hTestMenu (oQryJBoxMenu:BUFFER-HANDLE::iJBoxMenuId).
  
  hTestTree = DYNAMIC-FUNCTION("getTreeHandle" IN hTestMenu) NO-ERROR.

  DYNAMIC-FUNCTION("setWindowTitle" IN hTestMenu,"Test").

  DYNAMIC-FUNCTION("setAttribute",SESSION,"mainMenuType","ribbon").
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TestRecord C-Win 
PROCEDURE TestRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR cLanguages AS CHAR NO-UNDO.
DEF VAR cSelLang   AS CHAR NO-UNDO.
DEF VAR cReturn    AS CHAR NO-UNDO.

IF VALID-HANDLE(hTestMenu) THEN
  APPLY "close" TO hTestMenu.

RUN SelectAppLanguage.

/* IF DYNAMIC-FUNCTION("getAttribute",SESSION,"mainMenuType") = "ribbon" THEN DO: */
/*   DYNAMIC-FUNCTION("setAttribute",SESSION,"mainMenuType","nav-bar").           */
/*   RUN RestartMenu IN hParent.                                                  */
/* END.                                                                           */
/* ELSE DO:                                                                       */
  RUN JBoxJlwDynMenu.w PERSIST SET hTestMenu.
  
  IF NOT bMultiMenu THEN
    RUN InitializeObject IN hTestMenu (iRootNode).
  ELSE
    RUN InitializeObject IN hTestMenu (oQryJBoxMenu:BUFFER-HANDLE::iJBoxMenuId).
  
  hTestTree = DYNAMIC-FUNCTION("getTreeHandle" IN hTestMenu).
/* END. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TranslateRecord C-Win 
PROCEDURE TranslateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(hMenuTranslation) THEN DO:
  RUN JBoxMenuTranslation.w PERSISTENT SET hMenuTranslation.
  RUN InitializeObject IN hMenuTranslation.
END.
RUN MoveToTop IN hMenuTranslation NO-ERROR.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeDropNode C-Win 
PROCEDURE TreeDropNode :
DEF INPUT PARAM icDragNode  AS CHAR NO-UNDO.
DEF INPUT PARAM icDropNode  AS CHAR NO-UNDO.

RUN DropNode (icDragNode,icDropNode).
/* code suggestion.. validate where the node can be dropped:
IF NOT CAN-DO(cRegionList,icDropNode) OR CAN-DO(cRegionList,icDragNode) THEN RETURN.
*/
/* After a successful drop rebuild the tree and expand the dropped node:
IF JBoxServerAPI:Instance:Update("Salesrep","Salesrep",icDragNode,"Region",icDropNode,NO) THEN DO:
  FillTreeView().
  oJBoxMsTreeView:ExpandNodes(icDropNode).
END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeNodeSelectedRecord C-Win 
PROCEDURE TreeNodeSelectedRecord :
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

  bOK = oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iNodeIndex  = " + icNode) NO-ERROR.
  IF bOk THEN 
    oQryJBoxMenu:displayRecord().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tvNodeEvent C-Win 
PROCEDURE tvNodeEvent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icEvent   AS CHAR NO-UNDO.
DEF INPUT PARAM icNodeKey AS CHAR NO-UNDO.

IF CAN-DO("parentselect,select",icEvent) THEN DO:
  bOK = oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iNodeIndex   = " + icNodeKey) NO-ERROR.
  IF bOk THEN DO:
    oQryJBoxMenu:displayRecord().
    InitializePopupMenus(oQryJBoxMenu:BUFFER-HANDLE::cMenuType).
  END.
END.
ELSE IF CAN-DO("expand",icEvent) THEN DO:
  FIND FIRST ttExpand
       WHERE ttExpand.cNodeIndex = icNodeKey
       NO-ERROR.
  IF AVAIL ttExpand THEN 
    ttExpand.bExpanded = NOT ttExpand.bExpanded.
END.
ELSE IF icEvent = "dragdrop" THEN
  RUN DropNode(ENTRY(1,icNodeKey,"|"),ENTRY(2,icNodeKey,"|")).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WhereUsedRecord C-Win 
PROCEDURE WhereUsedRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF iTab NE 1 THEN
  DYNAMIC-FUNCTION("TabFolderChanged" IN hTabFolder,1).
RUN WhereUsed IN hCurrTabProc.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNextMenuNum C-Win 
FUNCTION getNextMenuNum RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hQuery       AS HANDLE NO-UNDO.
DEF VAR hNextNumBuff AS HANDLE NO-UNDO.
DEF VAR cNextNum     AS CHAR   NO-UNDO.
DEF VAR iNum         AS INT    NO-UNDO.
DEF VAR bNumeric     AS LOG    NO-UNDO INIT YES.

CREATE BUFFER hNextNumBuff FOR TABLE oQryJBoxMenu:BUFFER-HANDLE.
CREATE QUERY hQuery.
hQuery:SET-BUFFERS(hNextNumBuff).
hQuery:QUERY-PREPARE("FOR EACH " + hNextNumBuff:NAME + " WHERE cMenuType = 'menu-item'").
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  iNum = INT(hNextNumBuff::cMenuNumber) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    bNumeric = NO.
    LEAVE.
  END.
  hQuery:GET-NEXT().
END.    

hQuery:QUERY-CLOSE().

hQuery:QUERY-PREPARE("FOR EACH " + hNextNumBuff:NAME 
                   + " WHERE cMenuType = 'menu-item'"
                   + " BY "
                   + (IF bNumeric THEN "INT(" ELSE "")
                   + "cMenuNumber"
                   + (IF bNumeric THEN ")" ELSE "")
                   + " DESC").
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
IF hNextNumBuff:AVAIL THEN DO:
  IF bNumeric THEN
    cNextNum = STRING(INT(hNextNumBuff::cMenuNumber) + 1).
  ELSE hNextNumBuff::cMenuNumber.
END.

DELETE OBJECT hNextNumBuff.
DELETE OBJECT hQuery.

RETURN cNextNum.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNodeIndex C-Win 
FUNCTION getNodeIndex RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF oQryJBoxMenu:BUFFER-HANDLE:AVAIL THEN
  RETURN STRING(oQryJBoxMenu:BUFFER-HANDLE::iNodeIndex).
ELSE 
  MESSAGE PROGRAM-NAME(1) SKIP
          "Tree node not available!!" SKIP
          VIEW-AS ALERT-BOX.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentId C-Win 
FUNCTION getParentId RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF oQryJBoxMenu:BUFFER-HANDLE:AVAIL THEN 
  RETURN STRING(oQryJBoxMenu:BUFFER-HANDLE::iParentMenuId).
ELSE
  RETURN "0".  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentNodeIndex C-Win 
FUNCTION getParentNodeIndex RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF oQryJBoxMenu:BUFFER-HANDLE:AVAIL THEN
  RETURN STRING(oQryJBoxMenu:BUFFER-HANDLE::iParentNodeIndex).
ELSE 
  MESSAGE PROGRAM-NAME(1) SKIP
          "Tree node not available!!" SKIP
          VIEW-AS ALERT-BOX.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION InitializePopupMenus C-Win 
FUNCTION InitializePopupMenus RETURNS LOGICAL
  ( INPUT icType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
/*
DELETE OBJECT hTreeViewFrame:POPUP-MENU NO-ERROR.

/* If there is no current menu items: */
IF icType = "root" THEN
  hPopupRoot =  DYNAMIC-FUNCTION("NewMenuBand",
                      hTreeViewFrame,  /* parent widget */
                      "New;New;MenuBarRecord"
                      ,"").     

/* If current menu item is a menubar: */
ELSE IF CAN-DO("menu",icType) THEN DO:
  hPopupMenuBar =  DYNAMIC-FUNCTION("NewMenuBand",
                    hTreeViewFrame,  /* parent widget */
                    "|New"
                    + ",Delete"
                    + ",Test"
                    ,"").     
  DYNAMIC-FUNCTION("NewMenuBand",
                    WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hTreeViewFrame,"placeholder1")),  /* parent widget */
                    "Menubar;Menubar;MenuBarRecord"
                    + ",Nav-bar;Treeview/Nav-bar;MenuTvNavBarRecord"
                    + ",Menu;Menu;MenuRecord"
                    ,"").     
END.

ELSE IF CAN-DO("menubar",icType) THEN DO:
  hPopupMenuBar =  DYNAMIC-FUNCTION("NewMenuBand",
                    hTreeViewFrame,  /* parent widget */
                    "|New"
                    + ",Delete"
                    + ",DeleteLink;Delete link to parent"
                    + ",WhereUsed;Where used.."
                    ,"").     
  DYNAMIC-FUNCTION("NewMenuBand",
                    WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hTreeViewFrame,"placeholder1")),  /* parent widget */
                    "Sub-menu;Sub-menu;MenuSubRecord"
                    + ",Menu-item;Menu-item;MenuItemRecord"
                    + ",Placeholder;Placeholder;MenuPlaceHolderRecord"
                    ,"").     
END.

ELSE IF CAN-DO("tv-nav-bar",icType) THEN DO:
  hPopupMenuBar =  DYNAMIC-FUNCTION("NewMenuBand",
                    hTreeViewFrame,  /* parent widget */
                    "|New"
                    + ",Delete"
                    + ",DeleteLink;Delete link to parent"
                    + ",WhereUsed;Where used.."
                    ,"").     
  DYNAMIC-FUNCTION("NewMenuBand",
                    WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hTreeViewFrame,"placeholder1")),  /* parent widget */
                    "Sub-menu;Sub-menu;MenuSubRecord"
                    ,"").     
END.

/* If current menu is a sub-menu: */
ELSE IF icType = "sub-menu" THEN DO:   
  hPopupSubMenu =  DYNAMIC-FUNCTION("NewMenuBand",
                      hTreeViewFrame,  /* parent widget */
                      "|New"
                      + ",Delete"
                      + ",DeleteLink;Delete link to parent"
                      + ",WhereUsed;Where used.."
                      ,"").     
  DYNAMIC-FUNCTION("NewMenuBand",
                      WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",hTreeViewFrame,"placeholder1")),  /* parent widget */
                      "Menu-item;Menu-item;MenuItemRecord"
                      + ",Sub-menu;Sub-menu;MenuSubRecord"
                      + ",Ruler;Rule;MenuRuleRecord"
                      + ",Placeholder;Placeholder;MenuPlaceholderRecord"
                      ,"").     
END.
ELSE IF CAN-DO("menu-item",icType) THEN
  hPopupSubMenu =  DYNAMIC-FUNCTION("NewMenuBand",
                      hTreeViewFrame,  /* parent widget */
                      "Delete"
                    + ",DeleteLink;Delete link to parent"
                    + ",RunMnuItem;Run;RunMenuItem"
                    + ",WhereUsed;Where used.."
                      ,"").     
ELSE IF CAN-DO("placeholder",icType) THEN
  hPopupSubMenu =  DYNAMIC-FUNCTION("NewMenuBand",
                      hTreeViewFrame,  /* parent widget */
                      "Delete"
                    + ",DeleteLink;Delete link to parent"
                      ,"").     
ELSE IF CAN-DO("rule",icType) THEN
  hPopupSubMenu =  DYNAMIC-FUNCTION("NewMenuBand",
                      hTreeViewFrame,  /* parent widget */
                      "Delete"
                      ,"").     
*/
RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION InitializeResize C-Win 
FUNCTION InitializeResize RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  Note how the search combo (cmbMenu) is set to make it follow the split-bar only
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:
/*  DYNAMIC-FUNCTION("setNoResizeX" , THIS-PROCEDURE:CURRENT-WINDOW, hTreeViewFrame,hTreeViewFrame:NAME).*/
  DYNAMIC-FUNCTION("setAddResizeX", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE, "cmbMenu").
  DYNAMIC-FUNCTION("setNoMoveX", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE, "cmbMenu").
  DYNAMIC-FUNCTION("setNoResizeX", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE, "rectTreeView,cmbMenu").
  DYNAMIC-FUNCTION("setNoResizeY", THIS-PROCEDURE:CURRENT-WINDOW, FRAME {&FRAME-NAME}:HANDLE, "rectToolbar").

  DYNAMIC-FUNCTION("setSplitBarX" , THIS-PROCEDURE:CURRENT-WINDOW, btnSplitBarX:HANDLE IN FRAME frSplitBarX,NO).
  
  DYNAMIC-FUNCTION("setFollowSplitBarX",THIS-PROCEDURE:CURRENT-WINDOW,btnSplitBarX:HANDLE IN FRAME frSplitBarX, 
                    STRING(cmbMenu:HANDLE) + "," +
                    DYNAMIC-FUNCTION("getToolBarHandles",TbJBoxMenu:HANDLE,"button,rule") + "," +
                    STRING(rectTreeView:HANDLE) + "," + STRING(TbJBoxMenu:HANDLE) + "," +
                    DYNAMIC-FUNCTION("getWidgetsByLasso",TabMenu:HANDLE IN FRAME {&FRAME-NAME},0,"frame,browse,control-frame,rectangle")
                    ).

  DYNAMIC-FUNCTION("setOrgWinSize",THIS-PROCEDURE:CURRENT-WINDOW,800,700,0,0).
END.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RefreshMenuDropDown C-Win 
FUNCTION RefreshMenuDropDown RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
cmbMenu:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = "||" + DYNAMIC-FUNCTION("getFieldList","JBoxMenu;cMenuLabel;iJBoxMenuId","WHERE cMenuType = 'menu'").
  
cmbMenu:SCREEN-VALUE = "".

APPLY "value-changed" TO cmbMenu.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ReposToMenuId C-Win 
FUNCTION ReposToMenuId RETURNS LOGICAL
  ( INPUT iiMenuNodeId AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iJBoxMenuId = " + STRING(iiMenuNodeId)) NO-ERROR.
  IF oQryJBoxMenu:BUFFER-HANDLE:AVAIL THEN
    oJBoxMsTreeView:SelectNode(TRIM(STRING(oQryJBoxMenu:BUFFER-HANDLE::iNodeIndex))).
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setImgSize C-Win 
FUNCTION setImgSize RETURNS LOGICAL
  ( INPUT icImage      AS CHAR,
    INPUT icImageField AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF icImage = "" THEN RETURN NO.
IF SEARCH(icImage) = ? THEN RETURN NO.

FILE-INFO:FILE-NAME = icImage.

IF oQryJBoxMenu:BUFFER-HANDLE:AVAIL THEN
  oQryJBoxMenu:BUFFER-HANDLE::icImageField = FILE-INFO:FILE-SIZE.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSelectNode C-Win 
FUNCTION setSelectNode RETURNS LOGICAL
  ( INPUT icSelectNode AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
cSelectNode = icSelectNode.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION TabChanged C-Win 
FUNCTION TabChanged RETURNS LOGICAL
  ( INPUT iiTab AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hCustBrowse AS HANDLE NO-UNDO.

IF iTab > 0 THEN
  DYNAMIC-FUNCTION("DeleteObjectLink",oQryJBoxMenu:QUERY-HANDLE,oTabMenu:getPageQuery(iiTab)).

/* NB: Since the same menu can appear multiple places in the menu we don't want the automatic sync from child
       to sibling that we get when using the onetoone link: */
IF iiTab = 1 THEN DO:
  DYNAMIC-FUNCTION("CreateParentLink",oTabMenu:getPageQuery(iiTab),oQryJBoxMenu:QUERY-HANDLE,"iJBoxMenuId").
  /* NB: We don't want automatic assignment of the parent id either since this is really a one-to-one relationship: */
  DYNAMIC-FUNCTION("setAttribute",oTabMenu:getPageQuery(iiTab),"parentlinkfields","").
END.

hCurrTabProc = oTabMenu:getPageHandle(iiTab).

iTab = iiTab.

oQryJBoxMenu:displayRecord().

RUN MoveToTop IN hCurrTabProc NO-ERROR.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ValidateImage C-Win 
FUNCTION ValidateImage RETURNS LOGICAL
  ( INPUT icImage AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR iImageSize      AS INT  NO-UNDO.
DEF VAR iCurrMinSize    AS INT  NO-UNDO.
DEF VAR iCurrMaxSize    AS INT  NO-UNDO.
DEF VAR cCurrSmallImg   AS CHAR NO-UNDO.
DEF VAR cCurrSmallNode  AS CHAR NO-UNDO.
DEF VAR cCurrBigImg     AS CHAR NO-UNDO.
DEF VAR cCurrBigNode    AS CHAR NO-UNDO.

IF icImage = "" THEN RETURN YES.

IF SEARCH(icImage) = ? THEN DO:
  MESSAGE "Invalid image: " icImage SKIP "Not in PROPATH"
          VIEW-AS ALERT-BOX ERROR.
  RETURN NO.
END.

FILE-INFO:FILE-NAME = icImage.

IF NOT icImage MATCHES "*.bmp" AND NOT icImage MATCHES "*.ico" AND NOT icImage MATCHES "*.png" AND NOT icImage MATCHES "*.gif" 
   AND NOT icImage MATCHES "*.jpg"
   THEN DO:
  MESSAGE "Invalid image type for " icImage SKIP "Valid types: bmp,ico,png,gif"
          VIEW-AS ALERT-BOX ERROR.
  RETURN NO.
END.

iImageSize = FILE-INFO:FILE-SIZE.
    
RUN getMinMaxImgSize (OUTPUT iCurrMinSize,OUTPUT cCurrSmallImg,OUTPUT cCurrSmallNode,
                      OUTPUT iCurrMaxSize,OUTPUT cCurrBigImg,OUTPUT cCurrBigNode).

IF iImageSize < iCurrMinSize THEN DO:
  MESSAGE "Image " icImage ", size " iImageSize SKIP  
          "is smaller than the smallest image currently defined in the menu: " SKIP 
          cCurrSmallImg " for node " cCurrSmallNode ", size " iCurrMinSize SKIP(1)
          "If " cCurrSmallImg " is used in a navigation bar this is probably ok," SKIP 
          "otherwise it might prevent the image to load - Continue?"
          VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE bOk.
  RETURN bOk.
END.
IF iImageSize > iCurrMaxSize THEN DO:
  MESSAGE "Image " icImage ", size " iImageSize SKIP  
          "is larger than the largest image currently defined in the menu: " SKIP 
          cCurrBigImg " for node " cCurrBigNode ", size " iCurrMinSize SKIP(1)
          "If " cCurrBigImg " is used in a navigation bar this is probably ok," SKIP 
          "otherwise it might prevent the image to load - Continue?"
          VIEW-AS ALERT-BOX WARNING BUTTONS OK-CANCEL UPDATE bOk.
  RETURN bOk.
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ValidDropNode C-Win 
FUNCTION ValidDropNode RETURNS LOGICAL
  ( INPUT icDropId  AS CHAR,
    INPUT icDragId  AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Check if the target (drop) node is a child of the drag node. If so, return false. 
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR iDropParent AS INT NO-UNDO.

bOK = oQryJBoxMenu:BUFFER-HANDLE:FIND-FIRST("WHERE iJBoxMenuId = " + icDropId) NO-ERROR.
IF bOK THEN DO:
  iDropParent = oQryJBoxMenu:BUFFER-HANDLE::iParentMenuId.
  IF iDropParent = INT(icDragId) THEN RETURN FALSE.
  ELSE ValidDropNode (STRING(iDropParent),icDragId).
END.
ELSE RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

