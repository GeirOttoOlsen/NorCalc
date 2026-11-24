&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DECLARATIONS C-Win 
USING uc.JBoxMsTreeView FROM PROPATH.

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
DYNAMIC-FUNCTION("setAttribute",SESSION,"UseAdvGui","yes") NO-ERROR.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR bOk               AS LOG    NO-UNDO.
DEF VAR hBrowse           AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer        AS JBoxContainer NO-UNDO.
DEF VAR oJBoxMsTreeView   AS uc.JBoxMsTreeView NO-UNDO.
DEF VAR oTabBrowse        AS JBoxMsTabs NO-UNDO.
DEF VAR cCurrentTable     AS CHAR NO-UNDO.
DEF VAR cFirstNode        AS CHAR NO-UNDO.
DEF VAR hQuerySearch      AS HANDLE NO-UNDO.
DEF VAR cPrevSearch       AS CHAR NO-UNDO.
DEF VAR oPageBrowse       AS JBoxBrowse NO-UNDO.
DEF VAR bDynValidation    AS LOG NO-UNDO.
DEF VAR cTableFilter      AS CHAR NO-UNDO.
DEF VAR hAppServer        AS HANDLE NO-UNDO.
DEF VAR hFreeForm         AS HANDLE NO-UNDO.
DEF VAR bSql              AS LOGICAL NO-UNDO.
DEF VAR cSqlDbNameList    AS CHAR NO-UNDO. // INIT "vismaSQL,booking,consentSQL".
DEF VAR cSqlParamList     AS CHAR NO-UNDO. // INIT "SQLvisma,bookingSQL,SQLconsent".
DEF VAR iCurrFileNum      AS INT NO-UNDO.
DEF VAR hProgBar          AS HANDLE NO-UNDO.
DEF VAR bUpdateAllowed    AS LOG NO-UNDO.
DEF VAR bUpdateMode       AS LOG NO-UNDO.
DEF VAR cSelectedFields   AS CHAR NO-UNDO.
DEF VAR hLabelColumn      AS HANDLE NO-UNDO.
DEF VAR hFormatColumn     AS HANDLE NO-UNDO.
DEF VAR iCurrDictTab      AS INT NO-UNDO.
DEF VAR cSelectedFileNums AS CHAR NO-UNDO.
DEF VAR cAddToView        AS CHAR NO-UNDO.
DEF VAR bWinResize        AS LOG  NO-UNDO.
DEF VAR cDbList           AS CHAR NO-UNDO.
DEF VAR iDbCnt            AS INT  NO-UNDO.

&IF DEFINED(UIB_is_Running) NE 0 &THEN
  {tt_schema.i "NEW SHARED"}
&ELSE
  {tt_schema.i SHARED}
&ENDIF
  
hdsSchema = DATASET dsSchema:HANDLE.

{incl/tt_viewds.i}
hdsViewDs = DATASET dsViewDs:HANDLE.

DEF VAR httViewDs AS HANDLE NO-UNDO.
httViewDs = BUFFER ttViewDs:HANDLE.

DEF TEMP-TABLE ttTableViewTab
    FIELD TableOrViewName AS CHAR
    FIELD TabPage#        AS INT
    FIELD oDataBrowseObj  AS Progress.Lang.Object
    FIELD iFileNum        AS INT
    INDEX idxTabPage IS PRIMARY TabPage#.

DEF TEMP-TABLE ttTableFlds NO-UNDO
    FIELD cTable        AS CHAR  FORMAT "x(32)"    LABEL "Table"
    FIELD cDbFld        AS CHAR  FORMAT "x(32)"    LABEL "Field"
    FIELD cDataType     AS CHAR  FORMAT "x(12)"    LABEL "Datatype"
    FIELD cLabel        AS CHAR  FORMAT "x(32)"    LABEL "Label"
    FIELD cFormat       AS CHAR  FORMAT "x(15)"    LABEL "Format"
    FIELD iExtent       AS INT   FORMAT ">>9"      LABEL "Extent"
    FIELD iSeq          AS INT   LABEL "Order"
    FIELD cDbName       AS CHAR  FORMAT "x(15)"    LABEL "Dbname"
    FIELD iNodeIdx      AS INT
    FIELD iFileNum      AS INT
    FIELD iFieldNum     AS INT
    FIELD iFieldTreeId  AS INT    
    FIELD bIndex        AS LOG FORMAT "*/" LABEL "Index"
    INDEX idxFileNum  iFileNum
    INDEX idxFieldNum iFieldNum
    INDEX idxTreeId   iFieldTreeId
    .

DEF TEMP-TABLE ttTableFlds2 NO-UNDO LIKE ttTableFlds.

DEF TEMP-TABLE ttDummyExp NO-UNDO
    FIELD cTable        AS CHAR
    FIELD iNodeIdx      AS INT
    .

DEF TEMP-TABLE ttRecordCount NO-UNDO
    FIELD iDbNum      AS INT
    FIELD cTableName  AS CHAR
    FIELD cFieldName  AS CHAR
    FIELD iCount      AS INT
    .
    
DEF TEMP-TABLE ttQueryJoin NO-UNDO
    FIELD iLeftFileNum AS INT
    FIELD iRightFileNum  AS INT
    FIELD cQueryJoin     AS CHAR
    .    

DEF TEMP-TABLE ttViewDsProc NO-UNDO
    FIELD hViewDef  AS HANDLE
    FIELD cViewName AS CHAR
    FIELD ViewDsId  AS CHAR 
    FIELD hOwner    AS HANDLE
    .

DEF VAR otb_Tree AS JBoxToolbar NO-UNDO.


DEF VAR opopup_CB_DB AS JBoxPopupMenu NO-UNDO.

DEF VAR oTabTabTvGrid AS JBoxAblTabs NO-UNDO.

DEF VAR oBrwTableFlds AS JBoxBrowse NO-UNDO.


DEF VAR opopup_fields AS JBoxPopupMenu NO-UNDO.

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

  Created: 22/11/24 - 11:55 am

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TabBrowse tb_Tree cb-cDB tbSysTables ~
tbExpandAll tbFieldsByOrder JBoxMsTreeView 
&Scoped-Define DISPLAYED-OBJECTS cb-cDB tbSysTables tbExpandAll ~
tbFieldsByOrder JBoxMsTreeView 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BuildTree C-Win 
FUNCTION BuildTree RETURNS LOGICAL
  ( INPUT icDbNum AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBuffersAndFields C-Win 
FUNCTION getBuffersAndFields RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSortColumn C-Win 
FUNCTION getSortColumn RETURNS CHARACTER ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD reFormatField C-Win 
FUNCTION reFormatField RETURNS CHARACTER
  (INPUT icDatatype AS CHAR
  ,INPUT icFormat   AS CHAR  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RemoveTabFromList C-Win 
FUNCTION RemoveTabFromList RETURNS LOGICAL
  ( INPUT iiTab# AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD selectFieldPair C-Win 
FUNCTION selectFieldPair RETURNS CHARACTER
  ( INPUT icChildTable  AS CHAR,
    INPUT icChildDb     AS CHAR,
    INPUT icParentTable AS CHAR,
    INPUT icParentDb    AS CHAR,
    INPUT ibIntChar     AS LOG ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabBrowse C-Win 
FUNCTION setTabBrowse RETURNS LOGICAL
  ( INPUT ioBrowse AS JBoxBrowse )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StartTab C-Win 
FUNCTION StartTab RETURNS LOGICAL
  ( INPUT icTable AS CHAR
   ,INPUT iiFileNum AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD TabChanged C-Win 
FUNCTION TabChanged RETURNS LOGICAL
  ( INPUT iiTab AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-cDB AS CHARACTER FORMAT "X(256)":U 
     LABEL "Db" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "item1","item1"
     DROP-DOWN-LIST
     SIZE 34.2 BY 1 NO-UNDO.

DEFINE VARIABLE JBoxMsTreeView AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 58 BY 19.91 NO-UNDO.

DEFINE RECTANGLE TabBrowse
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 113 BY 22.38.

DEFINE RECTANGLE tb_Tree
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 174 BY 1.29.

DEFINE VARIABLE tbExpandAll AS LOGICAL INITIAL no 
     LABEL "Expand all" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.2 BY .81 NO-UNDO.

DEFINE VARIABLE tbFieldsByOrder AS LOGICAL INITIAL yes 
     LABEL "Fields by order" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.8 BY .81 NO-UNDO.

DEFINE VARIABLE tbSysTables AS LOGICAL INITIAL no 
     LABEL "View sys.tables" 
     VIEW-AS TOGGLE-BOX
     SIZE 18 BY .81 NO-UNDO.

DEFINE RECTANGLE brwTableFlds
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 58 BY 21.19.

DEFINE VARIABLE fi-cSearch AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY 1 TOOLTIP "Search table-name" NO-UNDO.

DEFINE BUTTON btnSplitBarX  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE .8 BY 22.05
     BGCOLOR 12 FGCOLOR 12 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     cb-cDB AT ROW 1.38 COL 4.4 COLON-ALIGNED WIDGET-ID 28
     tbSysTables AT ROW 1.48 COL 123.2 WIDGET-ID 20
     tbExpandAll AT ROW 1.48 COL 142.2 WIDGET-ID 12
     tbFieldsByOrder AT ROW 1.48 COL 158 WIDGET-ID 26
     JBoxMsTreeView AT ROW 4.91 COL 2.8 NO-LABEL WIDGET-ID 2
     TabBrowse AT ROW 2.67 COL 63.4 WIDGET-ID 4
     tb_Tree AT ROW 1.29 COL 2 WIDGET-ID 16
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 176 BY 24.14 WIDGET-ID 100.

DEFINE FRAME TabTvGrid
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1.8 ROW 2.52
         SIZE 60 BY 22.52
         BGCOLOR 2  WIDGET-ID 400.

DEFINE FRAME frmTv
     fi-cSearch AT ROW 1.19 COL 1.8 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 2.2 ROW 1.38
         SIZE 56.8 BY 9.62 WIDGET-ID 500.

DEFINE FRAME frmGrid
     brwTableFlds AT ROW 1.1 COL 1 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 2 ROW 1.38
         SIZE 58 BY 21.91 WIDGET-ID 600.

DEFINE FRAME frSplitBarX
     btnSplitBarX AT ROW 1.1 COL 19.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 43 ROW 2.91
         SIZE 88 BY 22.14 WIDGET-ID 300.


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
         TITLE              = "JukeBox Database Explorer"
         HEIGHT             = 24.14
         WIDTH              = 176
         MAX-HEIGHT         = 24.14
         MAX-WIDTH          = 176
         VIRTUAL-HEIGHT     = 24.14
         VIRTUAL-WIDTH      = 176
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
/* REPARENT FRAME */
ASSIGN FRAME frmGrid:FRAME = FRAME TabTvGrid:HANDLE
       FRAME frmTv:FRAME = FRAME TabTvGrid:HANDLE
       FRAME frSplitBarX:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME TabTvGrid:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       tbExpandAll:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "no".

ASSIGN 
       tbFieldsByOrder:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "yes".

ASSIGN 
       tbSysTables:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "no".

ASSIGN 
       tb_Tree:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "connectDataSource|File;Connect data source¤menuenable,recordCount|File;View database record count¤menuenable,NewViewDs|File;New view or dataset¤menuenable,LookupDef|File;Define lookups¤menuenableFilemaxborder".

/* SETTINGS FOR FRAME frmGrid
                                                                        */
/* SETTINGS FOR FRAME frmTv
                                                                        */
/* SETTINGS FOR FILL-IN fi-cSearch IN FRAME frmTv
   ALIGN-L                                                              */
/* SETTINGS FOR FRAME frSplitBarX
                                                                        */
ASSIGN 
       btnSplitBarX:MOVABLE IN FRAME frSplitBarX          = TRUE
       btnSplitBarX:PRIVATE-DATA IN FRAME frSplitBarX     = 
                "BrowseFields;Browse selected fields,BrowseFieldsEdit;Browse fields with edit option".

/* SETTINGS FOR FRAME TabTvGrid
                                                                        */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME frmGrid:MOVE-BEFORE-TAB-ITEM (FRAME frmTv:HANDLE)
/* END-ASSIGN-TABS */.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frmGrid
/* Query rebuild information for FRAME frmGrid
     _Query            is NOT OPENED
*/  /* FRAME frmGrid */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frSplitBarX
/* Query rebuild information for FRAME frSplitBarX
     _Query            is NOT OPENED
*/  /* FRAME frSplitBarX */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME TabTvGrid
/* Query rebuild information for FRAME TabTvGrid
     _Query            is NOT OPENED
*/  /* FRAME TabTvGrid */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* JukeBox Database Explorer */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* JukeBox Database Explorer */
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
  oBrwTableFlds:DESIGN-WIDGET-HANDLE:MOVE-TO-TOP().
  oBrwTableFlds:BROWSE-HANDLE:MOVE-TO-TOP().
  DYNAMIC-FUNCTION("reDrawGridFilter",oBrwTableFlds:BROWSE-HANDLE).
  
  IF NOT bWinResize THEN
    DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarX C-Win
ON START-MOVE OF btnSplitBarX IN FRAME frSplitBarX
DO:
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",THIS-PROCEDURE:CURRENT-WINDOW).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME cb-cDB
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cDB C-Win
ON VALUE-CHANGED OF cb-cDB IN FRAME DEFAULT-FRAME /* Db */
DO:
  DEF VAR bLoadFlds AS LOG NO-UNDO INIT YES.
  DEF VAR cConnFile AS CHAR NO-UNDO.
  FIND FIRST tt_db 
       WHERE tt_db.iDbNum = INT(SELF:SCREEN-VALUE) 
       NO-ERROR.
  IF NOT AVAIL tt_db THEN RETURN NO-APPLY.    

  bSql = tt_db.cDbType MATCHES "*sql*".
  
  cConnFile = tt_db.cConnection.
  
  tbSysTables:HIDDEN = bSql.
  
  IF bSql AND NOT CAN-FIND(FIRST tt_file WHERE tt_file.iDbNum = tt_db.iDbNum) THEN DO:
    IF NOT JBoxSchemaCache:Instance:getSqlDbSchema (hdsSchema,tt_db.cLDBname,tt_db.cSourceName,tt_db.cDbType) THEN DO:
      MESSAGE "Could not retrieve Sql schema for " + SELF:SCREEN-VALUE
              VIEW-AS ALERT-BOX.
      RETURN NO-APPLY.
    END.        
    FIND FIRST tt_db 
         WHERE tt_db.iDbNum = INT(SELF:SCREEN-VALUE) 
         NO-ERROR.
  END.             
  BuildTree(cb-cDB:SCREEN-VALUE).
  
//  oBrwTable:openQuery(). 
  
  oBrwTableFlds:openQuery().
  
  IF VALID-OBJECT(opopup_CB_DB) THEN DO:
    DELETE OBJECT opopup_CB_DB.
    cb-cDB:POPUP-MENU = ?.
  END.  
    
  IF cConnFile NE "" THEN DO:
    opopup_CB_DB = NEW JBoxPopupMenu().
    opopup_CB_DB:AddToolGroup('reloadSchema;Reload schema').
    cb-cDB:POPUP-MENU = opopup_CB_DB:POPUP-MENU-HANDLE.
  END.

  JBoxLookupDef:Instance:CurrentDataSource = tt_db.cSourceName.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME frmTv
&Scoped-define SELF-NAME fi-cSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cSearch C-Win
ON RETURN OF fi-cSearch IN FRAME frmTv
DO:
  IF SELF:SCREEN-VALUE NE cPrevSearch AND SELF:SCREEN-VALUE NE "" THEN DO:
    hQuerySearch:QUERY-PREPARE("FOR EACH ttNode WHERE cNodeText MATCHES '*" + SELF:SCREEN-VALUE + "*' AND ttNode.cParentNodeName = ''").
    hQuerySearch:QUERY-OPEN ().
    hQuerySearch:GET-FIRST ().
    cPrevSearch = SELF:SCREEN-VALUE.
  END.
  ELSE IF SELF:SCREEN-VALUE NE "" THEN DO:
    hQuerySearch:GET-NEXT ().
    IF NOT oJBoxMsTreeView:ttNodeBuffer:AVAIL THEN hQuerySearch:GET-FIRST().
  END.
  ELSE RETURN NO-APPLY.
  
  IF oJBoxMsTreeView:ttNodeBuffer:AVAIL THEN
    oJBoxMsTreeView:SelectNode(oJBoxMsTreeView:ttNodeBuffer::cNodeName).
    
  APPLY "entry" TO SELF.  
  APPLY "cursor-right" TO SELF.
  RETURN NO-APPLY.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME tbExpandAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbExpandAll C-Win
ON VALUE-CHANGED OF tbExpandAll IN FRAME DEFAULT-FRAME /* Expand all */
DO:
  IF SELF:CHECKED THEN
    oJBoxMsTreeView:ExpandNodes("").
  ELSE
    oJBoxMsTreeView:CollapseNodes("").  

oJBoxMsTreeView:SelectNode(cFirstNode).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbFieldsByOrder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbFieldsByOrder C-Win
ON VALUE-CHANGED OF tbFieldsByOrder IN FRAME DEFAULT-FRAME /* Fields by order */
DO:
  BuildTree(cb-cDB:SCREEN-VALUE).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbSysTables
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbSysTables C-Win
ON VALUE-CHANGED OF tbSysTables IN FRAME DEFAULT-FRAME /* View sys.tables */
DO:
  BuildTree(cb-cDB:SCREEN-VALUE).  
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
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  
  FOR EACH ttViewDsProc 
      WHERE ttViewDsProc.hOwner = THIS-PROCEDURE:
    IF VALID-HANDLE(ttViewDsProc.hViewDef) THEN APPLY "close" TO ttViewDsProc.hViewDef.
  END.  
  
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  IF VALID-HANDLE(hFreeForm) THEN APPLY "close" TO hFreeForm.
  RUN disable_UI.
  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    DELETE OBJECT oContainer NO-ERROR.
  &ENDIF
  DELETE OBJECT hQuerySearch.
//  IF VALID-HANDLE(hAppServer) THEN hAppServer:DISCONNECT().
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */
&ENDIF


ON "WINDOW-RESIZED" OF {&WINDOW-NAME} DO:
  bWinResize = YES.
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",THIS-PROCEDURE:CURRENT-WINDOW) NO-ERROR.
  DYNAMIC-FUNCTION("setWidgetResize",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE:CURRENT-WINDOW,"resize","").

  IF iCurrDictTab = 2 THEN     
    FRAME frmGrid:HANDLE:MOVE-TO-TOP ().   
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",?) NO-ERROR.
  bWinResize = NO.
END.


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
/*    DEF VAR cSqlDbSelList   AS CHAR NO-UNDO INIT "Consent|SQLconsent|bookingSQL|j:\test\kompisconnect.ini|Visma|SQLvisma".                              */
/*    DEF VAR cSqlDbSelParam  AS CHAR NO-UNDO.                                                                                                            */
/*    JBoxSession:Instance:SimpleSelectListPairs(cSqlDbSelList).                                                                                          */
/*    IF JBoxSession:Instance:SelectListOk THEN DO:                                                                                                       */
/*      cSqlDbSelParam = JBoxSession:Instance:SelectListValue.                                                                                            */
/*      JBoxSession:Instance:setJBoxAttribute("MsSqlDbList",ENTRY(LOOKUP(cSqlDbSelParam,cSqlDbSelList,"|") - 1,cSqlDbSelList,"|") + ";" + cSqlDbSelParam).*/
/*    END.                                                                                                                                                */
//    JBoxSession:Instance:setJBoxAttribute("SqlDbList","VismaSQL|TESTMedlemsregnskapGLOBALData|mssql,RapportSQL|Rapport|ProgressSql").
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addTableToView C-Win 
PROCEDURE addTableToView :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
RUN AddTable IN ttViewDsProc.hViewDef (cAddToView).
IF RETURN-VALUE = "TryBaseTable" THEN
  RUN AddToBaseTable IN ttViewDsProc.hViewDef (cAddToView).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterExpandNodeRecord C-Win 
PROCEDURE AfterExpandNodeRecord :
/*------------------------------------------------------------------------------
  Purpose:     Typically select the expanded node to make the node available for right-click functions
  Parameters:  Node-name
  Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNodeName AS CHARACTER NO-UNDO.

IF CAN-FIND(FIRST ttTableFlds WHERE ttTableFlds.iFileNum = INT(icNodeName)) THEN
  oJBoxMsTreeView:selectNode(icNodeName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ASconnectEditRecord C-Win 
PROCEDURE ASconnectEditRecord :
/*
DEF VAR cConnString AS CHAR NO-UNDO.
  
  GET-KEY-VALUE SECTION "JBoxDbViewer" KEY "ASconnectString" VALUE cConnString.

  JBoxSession:Instance:PromptForValue("Set appserver connect string", "character","x(256)",cConnString).
  IF JBoxSession:Instance:PromptValueOk THEN DO:
    PUT-KEY-VALUE SECTION "JBoxDbViewer" 
                  KEY  "ASconnectString"
                  VALUE JBoxSession:Instance:PromptValue
                  .
    IF JBoxSession:Instance:PromptValue NE "" AND JBoxSession:Instance:PromptValue NE cConnString THEN DO:
      IF VALID-HANDLE(hAppServer) AND hAppServer:CLIENT-CONNECTION-ID NE "" THEN hAppServer:DISCONNECT().
      RUN ASconnectRecord.
    END.  
  END.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ASconnectRecord C-Win 
PROCEDURE ASconnectRecord :
/*
DEF VAR cConnString  AS CHAR NO-UNDO.
  DEF VAR bOkUser      AS LOG  NO-UNDO.
  DEF VAR ix           AS INT  NO-UNDO.
  DEF VAR cDbSelect    AS CHAR NO-UNDO.
  DEF VAR bDbListEmpty AS LOG  NO-UNDO.
  
  GET-KEY-VALUE SECTION "JBoxDbViewer" KEY "ASconnectString" VALUE cConnString.
  
  IF cConnString = "" THEN RUN ASconnectEditRecord.
  ELSE IF NOT VALID-HANDLE(hAppServer) THEN DO: 
    CREATE SERVER hAppServer.
    IF NOT cConnString BEGINS "-URL" THEN cConnString = "-URL " + cConnString.
    hAppServer:CONNECT(cConnString) NO-ERROR.
    IF hAppServer:CLIENT-CONNECTION-ID NE "" THEN DO:
      DYNAMIC-FUNCTION("setAppserviceHandle",hAppServer).
      RUN JBoxLogin.w (OUTPUT bOkUser).
      IF bOkUser THEN DO WITH FRAME {&FRAME-NAME}:
        IF JBoxServerAPI:Instance:CallServerProc("jbserv_getnumdbconnected.p","") THEN DO:
          ix = INT(JBoxServerAPI:Instance:getCallReturnParam()).
          IF ix > 0 THEN DO:
            JBoxServerAPI:Instance:DatasetReplace = NO.
            IF NOT JBoxServerAPI:Instance:CallServerProc("jbserv_getschema.p","",hdsSchema) THEN
              JBoxServerAPI:Instance:viewCallMessage().
          END.
        END.    
        bDbListEmpty = cb-cDB:LIST-ITEMS = ?.
        FOR EACH tt_db:
          IF NOT CAN-DO(cb-cDB:LIST-ITEMS,tt_db.cLDBname) OR bDbListEmpty THEN DO:
            cb-cDB:ADD-LAST(tt_db.cLDBname).
            IF cDbSelect = "" THEN cDbSelect = tt_db.cLDBname.
          END.  
        END.
        IF cDbSelect NE "" THEN DO:
          cb-cDB:SCREEN-VALUE = cDbSelect.
          APPLY "VALUE-CHANGED" TO cb-cDB.
        END.
      END.
    END.  
    ELSE
      MESSAGE "Failed to connect to" SKIP cConnString
               VIEW-AS ALERT-BOX.
  END.
  ELSE MESSAGE "Appserver already connected" SKIP 
               VIEW-AS ALERT-BOX.
*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeNavBrowseFillIn C-Win 
PROCEDURE BeforeNavBrowseFillIn :
DEF INPUT  PARAM ihFillIn AS HANDLE NO-UNDO.
DEF INPUT  PARAM ihBuffer AS HANDLE NO-UNDO.
DEF OUTPUT PARAM obOk     AS LOG    NO-UNDO INIT YES.

IF ihBuffer:NAME = "ttTableFlds" AND (ihFillIn:NAME = hLabelColumn:NAME OR ihFillIn:NAME = hFormatColumn:NAME) THEN DO:
  FIND FIRST tt_field 
       WHERE tt_field.iFileNum = ihBuffer::iFileNum
         AND tt_field.iFieldNum = ihBuffer::iFieldNum
       NO-ERROR.
  IF AVAIL tt_field THEN DO:
    IF ihFillIn:NAME = hLabelColumn:NAME THEN tt_field.cLabel = ihBuffer::cLabel.
    ELSE tt_field.cFormat = ihBuffer::cFormat. 
  END.      
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseDictRecord C-Win 
PROCEDURE BrowseDictRecord :
FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewName = "Dict"
     NO-ERROR.
IF AVAIL ttTableViewTab THEN DO:
  oTabBrowse:movePageToTop(ttTableViewTab.TabPage#).         
  oTabBrowse:tabControl1:SelectTab(ttTableViewTab.TableOrViewName).
END.  
ELSE DO:
  cCurrentTable = "Dict".
  StartTab("Dict",0).
  oPageBrowse:POPUP-MENU-OBJECT:addTool("CopyFields","Copy field names").
  IF bSql THEN
    oPageBrowse:POPUP-MENU-OBJECT:addTool("CreateDF","Create OE DF file").
END.  



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseFields C-Win 
PROCEDURE BrowseFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

FIND FIRST tt_file
     WHERE tt_file.iFileNum = INT(icNode)
     NO-ERROR.
IF AVAIL tt_file THEN DO:
  RUN BrowseDictRecord.
  
  oTabBrowse:getPageBrowseObject(oTabBrowse:CurrTabNum):setFilter("cTable", "=", tt_file.cFile-Name).
  oTabBrowse:getPageBrowseObject(oTabBrowse:CurrTabNum):openQuery().
END.
ELSE MESSAGE "Invalid node type selected" VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseFieldsEditRecord C-Win 
PROCEDURE BrowseFieldsEditRecord :
bUpdateMode = YES.

RUN BrowseFieldsRecord.
bUpdateMode = NO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseFieldsNewWinRecord C-Win 
PROCEDURE BrowseFieldsNewWinRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

DEF VAR ix AS INT NO-UNDO.

cSelectedFields = "".
DO ix = 1 TO oBrwTableFlds:BROWSE-HANDLE:NUM-SELECTED-ROWS:
  IF oBrwTableFlds:BROWSE-HANDLE:FETCH-SELECTED-ROW(ix) THEN DO:
    IF ix > 1 AND ttTableFlds.iFileNum NE iCurrFileNum THEN DO:
      MESSAGE "You cannot select fields from different tables here"
      VIEW-AS ALERT-BOX.
      RETURN.
    END.   
    ASSIGN cSelectedFields = cSelectedFields + (IF cSelectedFields NE "" THEN "," ELSE "") + ttTableFlds.cDbFld
           cCurrentTable = ttTableFlds.cTable
           iCurrFileNum = ttTableFlds.iFileNum.
  END.         
END.
IF cSelectedFields = "" THEN RETURN.  

oContainer:StartChildWindow("JboxDataBrw.w",cCurrentTable,YES).

FINALLY:
  cSelectedFields = "".
END FINALLY.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseFieldsRecord C-Win 
PROCEDURE BrowseFieldsRecord :
DEF VAR ix           AS INT  NO-UNDO.

ASSIGN cSelectedFields = ""
       cSelectedFileNums = "".
       
DO ix = 1 TO oBrwTableFlds:BROWSE-HANDLE:NUM-SELECTED-ROWS:
  IF oBrwTableFlds:BROWSE-HANDLE:FETCH-SELECTED-ROW(ix) THEN DO:
    IF ix > 1 AND ttTableFlds.iFileNum NE iCurrFileNum THEN DO:
      MESSAGE "You cannot select fields from different tables here"
      VIEW-AS ALERT-BOX.
      RETURN.
    END.   
    ASSIGN cSelectedFields = cSelectedFields + (IF cSelectedFields NE "" THEN "," ELSE "") + ttTableFlds.cDbFld
           cCurrentTable = ttTableFlds.cTable
           iCurrFileNum = ttTableFlds.iFileNum.
  END.         
END.
IF cSelectedFields = "" THEN RETURN.  

IF NUM-ENTRIES(cSelectedFileNums) = 1 THEN cSelectedFileNums = "".

FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewName = ttTableFlds.cTable
     NO-ERROR.
IF AVAIL ttTableViewTab THEN DO:
  oTabBrowse:movePageToTop(ttTableViewTab.TabPage#).
  oTabBrowse:tabControl1:SelectTab(ttTableViewTab.TableOrViewName).
END.           
ELSE DO:
  cCurrentTable = ttTableFlds.cTable.
  iCurrFileNum = ttTableFlds.iFileNum.
  StartTab(ttTableFlds.cTable,ttTableFlds.iFileNum).
END.  

FINALLY:
  cSelectedFields = "".
END FINALLY.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseTable C-Win 
PROCEDURE BrowseTable :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

FIND FIRST ttTableFlds WHERE ttTableFlds.iFileNum = INT(icNode)
     NO-ERROR.
IF NOT AVAIL ttTableFlds THEN RETURN.     

FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewName = ttTableFlds.cTable
     NO-ERROR.
IF AVAIL ttTableViewTab THEN DO:
  oTabBrowse:movePageToTop(ttTableViewTab.TabPage#).
  oTabBrowse:tabControl1:SelectTab(ttTableViewTab.TableOrViewName).
END.           
ELSE DO:
  cCurrentTable = ttTableFlds.cTable.
  iCurrFileNum = ttTableFlds.iFileNum.
  StartTab(ttTableFlds.cTable,ttTableFlds.iFileNum).
END.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseTableNewWin C-Win 
PROCEDURE BrowseTableNewWin :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF VAR hBuffer AS HANDLE NO-UNDO.

FIND FIRST ttTableFlds WHERE ttTableFlds.iFileNum = INT(icNode)
     NO-ERROR.
IF NOT AVAIL ttTableFlds THEN RETURN.     

ASSIGN cCurrentTable = ttTableFlds.cTable
       iCurrFileNum = ttTableFlds.iFileNum.

oContainer:StartChildWindow("JboxDataBrw.w",ttTableFlds.cTable,YES).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseTableUpdateMode C-Win 
PROCEDURE BrowseTableUpdateMode :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

bUpdateMode = YES.
RUN BrowseTable(icNode).
bUpdateMode = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clearTableFilterRecord C-Win 
PROCEDURE clearTableFilterRecord :
cTableFilter = "".
  BuildTree(cb-cDB:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectDataSourceRecord C-Win 
PROCEDURE connectDataSourceRecord :
DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.
  DEF VAR cDbList         AS CHAR NO-UNDO.
  DEF VAR iDbCnt          AS INT  NO-UNDO.

  SYSTEM-DIALOG GET-FILE cUseFileName FILTERS "json" "*.json", "All files" "*.*" USE-FILENAME UPDATE bOk.
  IF bOk THEN DO:
    IF JBoxSchemaCache:Instance:getDbSchema(hDsSchema,cUseFileName) THEN DO: // hDsSchema
      FOR EACH tt_db:
        ASSIGN cDbList = cDbList + (IF cDbList NE "" THEN "," ELSE "") + tt_db.cSourceName + "." + tt_db.cLDBname + "," + STRING(tt_db.iDbNum)
               iDbCnt  = IF tt_db.iDbNum > iDbCnt THEN tt_db.iDbNum ELSE iDbCnt
               .
      END.
      cb-cDB:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cDbList.
      cb-cDB:SCREEN-VALUE = STRING(iDbCnt).
      APPLY "value-changed" TO cb-cDB.
      
      FOR EACH ttViewDsProc:
        IF VALID-HANDLE(ttViewDsProc.hViewDef) THEN
          RUN RefreshSchemaDataSet IN ttViewDsProc.hViewDef (hdsSchema).
      END.  
        
    END.  
    ELSE MESSAGE JBoxSchemaCache:Instance:SchemaMessage
         VIEW-AS ALERT-BOX.
  END.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CopyFieldNameRecord C-Win 
PROCEDURE CopyFieldNameRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF VAR cFormat AS CHAR NO-UNDO.

FIND FIRST ttTableFlds
     WHERE ttTableFlds.iFieldTreeId = INT(icNode)
     NO-ERROR.
IF AVAIL ttTableFlds THEN 
  CLIPBOARD:VALUE = ttTableFlds.cDbFld.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CopyFieldsRecord C-Win 
PROCEDURE CopyFieldsRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR ix       AS INT NO-UNDO.
DEF VAR cFields  AS CHAR NO-UNDO.
DEF VAR hBrowse  AS HANDLE NO-UNDO.
DEF VAR cSep     AS CHAR NO-UNDO.
DEF VAR cFld     AS CHAR NO-UNDO.
DEF VAR bRepl    AS LOG  NO-UNDO.
DEF VAR cSelect  AS CHAR NO-UNDO.
DEF VAR cFldProp AS CHAR NO-UNDO.

hBrowse = oTabBrowse:getPageBrowseObject(oTabBrowse:CurrTabNum):BROWSE-HANDLE.

JBoxSession:Instance:SimpleSelectList("Blank,Comma,Semicolon,=,DynQuery,TEMP-TABLE w/Label and Format,TEMP-TABLE,STRING(<fld>):HANDLE + 'pipe' + ,", ",").
IF NOT JBoxSession:Instance:SelectListOk THEN RETURN.

cSelect = JBoxSession:Instance:SelectListValue.
CASE cSelect:
  WHEN "blank"      THEN cSep = " ".
  WHEN "Comma"      THEN cSep = ",".
  WHEN "Semicolon"  THEN cSep = ";".
  WHEN "TEMP-TABLE w/Label and Format" THEN cSep = " AS <datatype> FORMAT <format> <label>".
  WHEN "TEMP-TABLE" THEN cSep = " AS <datatype>".
  WHEN "="          THEN cSep = " = " + CHR(10) + "       ".
  WHEN "DynQuery"   THEN cSep = "'" + CHR(10) + "   + ';".
  OTHERWISE              ASSIGN cSep = REPLACE(JBoxSession:Instance:SelectListValue,"pipe","|")
                                bRepl = YES.
END CASE.
  
DO ix = 1 TO hBrowse:NUM-SELECTED-ROWS:
  IF hBrowse:FETCH-SELECTED-ROW(ix) THEN DO:
    IF ix = 1 AND cSelect BEGINS "TEMP-TABLE" THEN
      cFields = "DEF TEMP-TABLE tt" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cTable"):BUFFER-VALUE.
      
    cFld    = hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cDbFld"):BUFFER-VALUE.
    
    IF cSelect BEGINS "TEMP-TABLE" THEN DO:
      ASSIGN cFldProp = cSep
             cFldProp = REPLACE(cFldProp,"<datatype>",hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cDataType"):BUFFER-VALUE)
             cFldProp = REPLACE(cFldProp,"<format>", "'" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cFormat"):BUFFER-VALUE + "'")                   
             .                  
      IF hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cLabel"):BUFFER-VALUE NE ? THEN       
        cFldProp = REPLACE(cFldProp,"<label>","LABEL " + "'" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cLabel"):BUFFER-VALUE + "'").
      ELSE
        cFldProp = REPLACE(cFldProp,"<label>","").
      cFields = cFields + CHR(10) + "    FIELD " + cFld + cFldProp.  
    END.    
    ELSE
      cFields = cFields 
              + (IF bRepl THEN REPLACE(cSep,"<fld>",cFld) 
                 ELSE IF cFields NE "" THEN cSep + cFld 
                 ELSE cFld) 
                 .
  END.                    
END.

IF bRepl THEN cFields = SUBSTR(cFields,1,LENGTH(cFields) - 9).
IF cSelect = "DynQuery" THEN
  cFields = "   + ';" + cFields + "'".
ELSE IF cSelect = "=" THEN
  cFields = "ASSIGN " + cFields + " = ".

CLIPBOARD:VALUE = cFields.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CopySelectedFieldsRecord C-Win 
PROCEDURE CopySelectedFieldsRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR ix       AS INT NO-UNDO.
DEF VAR cFields  AS CHAR NO-UNDO.
DEF VAR hBrowse  AS HANDLE NO-UNDO.
DEF VAR cSep     AS CHAR NO-UNDO.
DEF VAR cFld     AS CHAR NO-UNDO.
DEF VAR bRepl    AS LOG  NO-UNDO.
DEF VAR cSelect  AS CHAR NO-UNDO.
DEF VAR cFldProp AS CHAR NO-UNDO.

hBrowse = oBrwTableFlds:BROWSE-HANDLE.

JBoxSession:Instance:SimpleSelectList("Blank,Comma,Semicolon,=,DynQuery,TEMP-TABLE w/Label and Format,TEMP-TABLE,STRING(<fld>):HANDLE + 'pipe' + ,", ",").
IF NOT JBoxSession:Instance:SelectListOk THEN RETURN.

cSelect = JBoxSession:Instance:SelectListValue.
CASE cSelect:
  WHEN "blank"      THEN cSep = " ".
  WHEN "Comma"      THEN cSep = ",".
  WHEN "Semicolon"  THEN cSep = ";".
  WHEN "TEMP-TABLE w/Label and Format" THEN cSep = " AS <datatype> FORMAT <format> <label>".
  WHEN "TEMP-TABLE" THEN cSep = " AS <datatype>".
  WHEN "="          THEN cSep = " = " + CHR(10) + "       ".
  WHEN "DynQuery"   THEN cSep = "'" + CHR(10) + "   + ';".
  OTHERWISE              ASSIGN cSep = REPLACE(JBoxSession:Instance:SelectListValue,"pipe","|")
                                bRepl = YES.
END CASE.
  
DO ix = 1 TO hBrowse:NUM-SELECTED-ROWS:
  IF hBrowse:FETCH-SELECTED-ROW(ix) THEN DO:
    IF ix = 1 AND cSelect BEGINS "TEMP-TABLE" THEN
      cFields = "DEF TEMP-TABLE tt" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cTable"):BUFFER-VALUE.
      
    cFld    = hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cDbFld"):BUFFER-VALUE.
    
    IF cSelect BEGINS "TEMP-TABLE" THEN DO:
      ASSIGN cFldProp = cSep
             cFldProp = REPLACE(cFldProp,"<datatype>",hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cDataType"):BUFFER-VALUE)
             cFldProp = REPLACE(cFldProp,"<format>", "'" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cFormat"):BUFFER-VALUE + "'")                   
             .                  
      IF hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cLabel"):BUFFER-VALUE NE ? THEN       
        cFldProp = REPLACE(cFldProp,"<label>","LABEL " + "'" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cLabel"):BUFFER-VALUE + "'").
      ELSE
        cFldProp = REPLACE(cFldProp,"<label>","").
      cFields = cFields + CHR(10) + "    FIELD " + cFld + cFldProp.  
    END.    
    ELSE
      cFields = cFields 
              + (IF bRepl THEN REPLACE(cSep,"<fld>",cFld) 
                 ELSE IF cFields NE "" THEN cSep + cFld 
                 ELSE cFld) 
                 .
  END.                    
END.

IF bRepl THEN cFields = SUBSTR(cFields,1,LENGTH(cFields) - 9).
IF cSelect = "DynQuery" THEN
  cFields = "   + ';" + cFields + "'".
ELSE IF cSelect = "=" THEN
  cFields = "ASSIGN " + cFields + " = ".

CLIPBOARD:VALUE = cFields.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateDFRecord C-Win 
PROCEDURE CreateDFRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR ix       AS INT NO-UNDO.
DEF VAR hBrowse  AS HANDLE NO-UNDO.
DEF VAR cTables  AS CHAR NO-UNDO.
DEF VAR hQuery   AS HANDLE NO-UNDO.

hBrowse = oTabBrowse:getPageBrowseObject(oTabBrowse:CurrTabNum):BROWSE-HANDLE.

hBrowse:QUERY:GET-FIRST ().
REPEAT WHILE hBrowse:QUERY:GET-BUFFER-HANDLE(1):AVAIL:
  IF NOT CAN-DO(cTables,hBrowse:QUERY:GET-BUFFER-HANDLE (1)::cTable) THEN
    cTables = cTables + (IF cTables NE "" THEN "," ELSE "") + hBrowse:QUERY:GET-BUFFER-HANDLE (1)::cTable.
  hBrowse:QUERY:GET-NEXT().
END.    

JBoxSqlSchemaHelper:Instance:createOEschema(cTables).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DynUpdateValidationRecord C-Win 
PROCEDURE DynUpdateValidationRecord :
bDynValidation = otb_Tree:getMenuItemHandle("dynUpdateValidation"):CHECKED.

FOR EACH ttTableViewTab:
  CAST(ttTableViewTab.oDataBrowseObj,"JBoxBrowse"):dynamicUpdateValidation = bDynValidation.
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
  DISPLAY cb-cDB tbSysTables tbExpandAll tbFieldsByOrder JBoxMsTreeView 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE TabBrowse tb_Tree cb-cDB tbSysTables tbExpandAll tbFieldsByOrder 
         JBoxMsTreeView 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE brwTableFlds 
      WITH FRAME frmGrid IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frmGrid}
  DISPLAY fi-cSearch 
      WITH FRAME frmTv IN WINDOW C-Win.
  ENABLE fi-cSearch 
      WITH FRAME frmTv IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frmTv}
  VIEW FRAME TabTvGrid IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-TabTvGrid}
  ENABLE btnSplitBarX 
      WITH FRAME frSplitBarX IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frSplitBarX}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExcelRecord C-Win 
PROCEDURE ExcelRecord :
DEF VAR hbttTableFlds AS HANDLE NO-UNDO.

hbttTableFlds = BUFFER ttTableFlds:HANDLE.
  
RUN ToExcelViaFile.p (hbttTableFlds,0).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FreeFormTable C-Win 
PROCEDURE FreeFormTable :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF VAR hBuffer AS HANDLE NO-UNDO.
DEF VAR bOk     AS LOG    NO-UNDO.

hBuffer = BUFFER ttTableFlds2:HANDLE.

EMPTY TEMP-TABLE ttTableFlds2.
FOR EACH ttTableFlds 
    WHERE ttTableFlds.iFileNum = INT(icNode):
  CREATE ttTableFlds2.
  BUFFER-COPY ttTableFlds TO ttTableFlds2.
END.
IF NOT VALID-HANDLE(hFreeForm) THEN
  RUN ffDlgOptions.w PERSIST SET hFreeForm (hBuffer,"",OUTPUT bOk).
ELSE
  RUN addTable IN hFreeForm (hBuffer).  
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeChild C-Win 
PROCEDURE InitializeChild :
DEF INPUT PARAM ihChild AS HANDLE NO-UNDO.

IF CAN-DO(ihChild:INTERNAL-ENTRIES,"setAddExtraTools") THEN
  DYNAMIC-FUNCTION("setAddExtraTools" IN ihChild,YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeComponents C-Win 
PROCEDURE InitializeComponents :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DO WITH FRAME {&FRAME-NAME}:

  oJBoxMsTreeView = NEW uc.JBoxMsTreeView(THIS-PROCEDURE,JBoxMsTreeView:HANDLE,
                      "tvpics\Fold.bmp,tvpics\FoldOpen.bmp,newbmp\CIORD16E.BMP,bmp\tbls.bmp,newbmp\application.bmp,tvpics\users.BMP,tvpics\user.bmp,bmp\bullet_triangle_green.bmp,bmp\bullet_triangle_blue.bmp").
//                      "tvpics\Fold.bmp,tvpics\FoldOpen.bmp,newbmp\LIGHT161.BMP,newbmp\LIGHT163.BMP,newbmp\user.bmp,tvpics\users.BMP,tvpics\user.bmp,bmp\bullet_triangle_green.bmp").
  oJBoxMsTreeView:RegisterWithJukeBox(YES).
//  oJBoxMsTreeView:setAllowDrop(YES).

  CREATE QUERY hQuerySearch.
  hQuerySearch:SET-BUFFERS (oJBoxMsTreeView:ttNodeBuffer).
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
DEF VAR cSqlDbList AS CHAR NO-UNDO.
DEF VAR ix         AS INT  NO-UNDO.

DEF VAR cDataSourceList AS CHAR NO-UNDO.
/*DEF VAR cDbList         AS CHAR NO-UNDO.*/
/*DEF VAR iDbCnt          AS INT  NO-UNDO.*/

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
  SUBSCRIBE TO "TreeNodeDropped" ANYWHERE.
  
  RUN InitializeComponents.
  oJBoxMsTreeView:SendToBack().
  JBoxMsTreeView:HIDDEN = YES.
  
  TabBrowse:HANDLE:VISIBLE = NO.
  
  bUpdateAllowed = JBoxSession:Instance:getJBoxAttribute("DbViewerCanUpdate") = "yes".
  
  JBoxSchemaCache:Instance:getDbSchema(?).
//  JBoxSchemaCache:Instance:getDbSchema(hdsSchema).

  FOR EACH tt_db:
    ASSIGN cDbList = cDbList + (IF cDbList NE "" THEN "," ELSE "") + tt_db.cSourceName + "." + tt_db.cLDBname + "," + STRING(tt_db.iDbNum)
           iDbCnt  = IF tt_db.iDbNum > iDbCnt THEN tt_db.iDbNum ELSE iDbCnt
           .
  END.
/*  // Pick up schemas for any sql connections defined on the appserver that hasn't already been loaded:                                */
/*  cSqlDbList = JBoxSession:Instance:getJboxAttribute("SqlDbList").                                                                    */
/*  IF cSqlDbList NE "" THEN DO:                                                                                                        */
/*                                                                                                                                      */
/*    DO ix = 1 TO NUM-ENTRIES(cSqlDbList):                                                                                             */
/*      IF NOT CAN-FIND(FIRST tt_db WHERE tt_db.cSourceName = ENTRY(1,ENTRY(ix,cSqlDbList),"|")) THEN DO:                               */
/*        IF NOT JBoxSchemaCache:Instance:getSqlDbSchema(hDsSchema,                                                                     */
/*                                   ENTRY(1,ENTRY(ix,cSqlDbList),"|"), // data source name                                             */
/*                                   ENTRY(2,ENTRY(ix,cSqlDbList),"|"), // db name                                                      */
/*                                   ENTRY(3,ENTRY(ix,cSqlDbList),"|"), // db type                                                      */
/*                                   JBoxSession:Instance:AppServerHandle) THEN  // db type (equals datasource type for sql)            */
/*          MESSAGE JBoxSchemaCache:Instance:SchemaMessage                                                                              */
/*          VIEW-AS ALERT-BOX.                                                                                                          */
/*      END.                                                                                                                            */
/*    END.                                                                                                                              */
/*    FOR EACH tt_db WHERE tt_db.iDbNum > iDbCnt:                                                                                       */
/*      cDbList = cDbList + (IF cDbList NE "" THEN "," ELSE "") + tt_db.cSourceName + "." + tt_db.cLDBname + "," + STRING(tt_db.iDbNum).*/
/*    END.                                                                                                                              */
/*  END.                                                                                                                                */
  
  oBrwTableFlds = NEW JBoxBrowse(brwTableFlds:HANDLE IN FRAME frmGrid,YES,"",NO,BUFFER ttTableFlds:HANDLE).
  oBrwTableFlds:buffersAndFields = "ttTableFlds;cTable|||20;cDbFld|||20;cDatatype|||15;cLabel|||20;cFormat;bIndex|||6;iSeq||>>>9;iExtent".
  oBrwTableFlds:DESIGN-WIDGET-HANDLE:HIDDEN = YES.

  opopup_fields = NEW JBoxPopupMenu().
  opopup_fields:AddToolGroup('BrowseFields;Browse selected fields'
                           + (IF bUpdateAllowed THEN ',BrowseFieldsEdit;Browse selected fields with edit option' ELSE "")
                           + ',BrowseFieldsNewWin;Browse selected fields in separate window'
                           + ',MultiSortBrowse;Sort on multiple columns,CopySelectedFields;Copy selected fields').

  oBrwTableFlds:POPUP-MENU-OBJECT = opopup_fields.

  oBrwTableFlds:enabledColumns = "cLabel,cFormat".
  oBrwTableFlds:enableOnDblClick = YES.
  hLabelColumn = oBrwTableFlds:BROWSE-HANDLE:GET-BROWSE-COLUMN(4).
  hFormatColumn = oBrwTableFlds:BROWSE-HANDLE:GET-BROWSE-COLUMN(5).

  oBrwTableFlds:createGridFilter("").

  IF cDbList = "" THEN cDbList = ",".
  cb-cDB:LIST-ITEM-PAIRS = cDbList.
  IF cDbList NE "," THEN DO:      
    cb-cDB:SCREEN-VALUE = ENTRY (2, cb-cDB:LIST-ITEM-PAIRS).
  
    APPLY "value-changed" TO cb-cDB.
  END.
            
  otb_Tree = NEW JBoxToolbar(tb_Tree:HANDLE).

  otb_Tree:addTool("LoadViewDs","Load view or dataset definition",YES,"menu-item").
  
  IF bUpdateAllowed THEN
    otb_Tree:addTool("DynUpdateValidation","Use dynamic FK validation for updates", YES, "toggle").

  oJBoxMsTreeView:BringToFront().

  oTabTabTvGrid = NEW JBoxAblTabs(FRAME TabTvGrid:HANDLE).

/*  oTabTabTvGrid:AddPage(FRAME frmTv:HANDLE,"Tree","bmp\root.bmp").                */
/*  oTabTabTvGrid:AddPage(FRAME frmGrid:HANDLE,"Grid","bmp\text0.bmp"). //kon1me.bmp*/
  oTabTabTvGrid:AddPage(FRAME frmTv:HANDLE,"Tree","bmp\konsern.bmp").
  oTabTabTvGrid:AddPage(FRAME frmGrid:HANDLE,"Grid","bmp\attribute1.bmp"). // alignleftmain.bmp kon1me.bmp
  oTabTabTvGrid:selectPage(1).
  
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:setSplitBarX(btnSplitBarX:HANDLE IN FRAME frSplitBarX).
  oContainer:setFollowSplitBarX(STRING(JBoxMsTreeView:HANDLE) + "," + STRING(TabBrowse:HANDLE)
                               + "," + STRING(brwTableFlds:HANDLE) + "," + STRING(oBrwTableFlds:BROWSE-HANDLE)
                               + "," + STRING(oTabTabTvGrid:TAB-FRAME-HANDLE) + "," + STRING(oTabTabTvGrid:TAB-AREA-HANDLE)
                               ).
  oContainer:setNoResizeX("JBoxMsTreeView,brwTableFlds,TabTvGrid," + oBrwTableFlds:BROWSE-HANDLE:NAME).
  oContainer:setNoResizeX(FRAME TabTvGrid:HANDLE,"TabTvGrid").
  oContainer:setAddMoveX("tbExpandAll,tbSysTables,tbFieldsByOrder,tbLoadFieldsAndIdx").
  oContainer:initResize().
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initViewDsDef C-Win 
PROCEDURE initViewDsDef :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
/*FIND FIRST ttViewDs NO-ERROR.                                                         */
/*IF AVAIL ttViewDs THEN DO:                                                            */
/*  RUN "RefreshViewTempTable" IN ttViewDsProc.hViewDef (httViewDs,ttViewDs.ViewDsId,?).*/
/*                                                                                      */
/*  IF ttViewDsProc.hOwner NE THIS-PROCEDURE THEN                                       */
/*     RUN RefreshSchemaDataSet IN ttViewDsProc.hViewDef (hdsSchema).                   */
  
  RUN AddFieldsRecord IN ttViewDsProc.hViewDef.
/*END.*/

CATCH eErr AS Progress.Lang.Error :
  MESSAGE eErr:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadViewDsRecord C-Win 
PROCEDURE LoadViewDsRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hDsView         AS HANDLE NO-UNDO.
DEF VAR cViewJsonFile   AS CHAR NO-UNDO.
DEF VAR oChildCont      AS JBoxContainer NO-UNDO.
DEF VAR cViewDsId       AS CHAR NO-UNDO.
DEF VAR hBtnActivate    AS HANDLE NO-UNDO.
DEF VAR hBtnSaveView    AS HANDLE NO-UNDO.

SYSTEM-DIALOG GET-FILE cViewJsonFile 
              FILTERS "Json files" "*.json"
              MUST-EXIST
              UPDATE bOK.
IF bOk THEN DO:
  
  CREATE ttViewDsProc.
  ASSIGN ttViewDsProc.cViewName = JBoxSession:Instance:PromptValue
         ttViewDsProc.hOwner    = THIS-PROCEDURE.  
    
  ttViewDsProc.hViewDef = oContainer:StartChildTab("JBoxViewDsDefTable.w",
                          ENTRY(1,ENTRY(NUM-ENTRIES(cViewJsonFile,"\/"),cViewJsonFile,"\/"),"."), NO, NO).
  
  oChildCont = oContainer:getChildContainer(ttViewDsProc.hViewDef).
  
  RUN RefreshSchemaDataSet IN ttViewDsProc.hViewDef (hdsSchema).
  RUN LoadViewDs IN ttViewDsProc.hViewDef (cViewJsonFile,OUTPUT cViewDsId).
  ttViewDsProc.ViewDsId = cViewDsId.

/*
  oChildCont:TOOLBAR-OBJECT:addTool("joinForDatasource","Join tables from same datasource","",YES,"toggle").
  
  oChildCont:TOOLBAR-OBJECT:AddTool("Activate",YES).
  hBtnActivate = oChildCont:TOOLBAR-OBJECT:getButtonHandle("Activate").
  oChildCont:setFollowSplitBarX(STRING(hBtnActivate)).
  oChildCont:TOOLBAR-OBJECT:AddTool("SaveView","Save","gif/folder.gif",YES).
  hBtnSaveView = oChildCont:TOOLBAR-OBJECT:getButtonHandle("SaveView").
  oChildCont:setFollowSplitBarX(STRING(hBtnSaveView)).
  oChildCont:statusBar:hHelpText:FRAME:HIDDEN = NO.
*/
  IF DYNAMIC-FUNCTION("getAttribute",ttViewDsProc.hViewDef,"advGuiWin") NE "yes" THEN DO:
    DYNAMIC-FUNCTION("setAttribute",ttViewDsProc.hViewDef,"advGuiWin","yes").
    RUN MoveToTop IN ttViewDsProc.hViewDef.
  END.  
  
/*  hBtnActivate:MOVE-TO-TOP ().*/
/*  hBtnSaveView:MOVE-TO-TOP ().*/
END.              


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LookupDefRecord C-Win 
PROCEDURE LookupDefRecord :
JBoxSession:Instance:StartChildTab("JBoxLookupMaint.w","Lookup definitions").


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ManageViewsRecord C-Win 
PROCEDURE ManageViewsRecord :
DEF VAR hViewDs AS HANDLE NO-UNDO.
DEF VAR oViewCont AS JBoxContainer NO-UNDO.

hViewDs = oContainer:StartTabWindow("JBoxViewDsDef.w", "View/Dataset", NO,YES).

RUN RefreshSchema IN hViewDs (hdsSchema).

oViewCont = JBoxSession:Instance:getContainerObject(hViewDs).
oViewCont:bringContainerToFront().

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
//IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
  RUN ShowForm("").
THIS-PROCEDURE:CURRENT-WINDOW:WINDOW-STATE = 3.
THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
DYNAMIC-FUNCTION("DoLockWindow",?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myDatabrowseObject C-Win 
PROCEDURE myDatabrowseObject :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ioDynDataBrowse AS JBoxDynDataBrowse NO-UNDO.

// must be set prior to initialization:
//ioDynDataBrowse:EnableSaveQuery = NO.
//ioDynDataBrowse:userSettingContext = "JBoxDbViewer.w".
ioDynDataBrowse:QueryCanBeScheduled = NO. 
ioDynDataBrowse:QueryCanBeShared = NO.

IF NOT AVAIL tt_file THEN
  FIND FIRST tt_file 
       WHERE tt_file.iFileNum = iCurrFileNum
       .  
FIND FIRST tt_db WHERE tt_db.iDbNum = tt_file.iDbNum.  

IF NOT bSql THEN DO:
  DYNAMIC-FUNCTION("setActiveASconnection",tt_db.cSourceName).
    
  ioDynDataBrowse:InitializeQuery(getBuffersAndFields(),"",DYNAMIC-FUNCTION("getSortColumn"),NO).
  ioDynDataBrowse:BROWSE-OBJECT:queryStopAfter = 30.
  ioDynDataBrowse:BROWSE-OBJECT:setJBoxAttribute("dataSourceName", tt_db.cSourceName).
END.    
 
ELSE DO:     
  JBoxSchemaCache:Instance:setUseDefaultConnection().
  ioDynDataBrowse:InitializeQuery(getBuffersAndFields(),"",DYNAMIC-FUNCTION("getSortColumn"),
                                  tt_db.cSourceType NE "ProgressSql",
                                  tt_db.cSourceName + "." + tt_db.cLDBname).
  ioDynDataBrowse:BROWSE-OBJECT:queryStopAfter = 10.
  ioDynDataBrowse:BROWSE-OBJECT:openQuery().
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewViewDsRecord C-Win 
PROCEDURE NewViewDsRecord :
JBoxSession:Instance:PromptForValue("Name").
IF NOT JBoxSession:Instance:PromptValueOk THEN RETURN.  
  
CREATE ttViewDsProc.
ASSIGN ttViewDsProc.cViewName = JBoxSession:Instance:PromptValue
       ttViewDsProc.hOwner    = THIS-PROCEDURE
       .  

ttViewDsProc.hViewDef = oContainer:StartChildTab("JBoxViewDsDefTable.w",ttViewDsProc.cViewName, NO, NO).

//RUN CreateViewDs IN ttViewDsProc.hViewDef(tt_db.cSourceName,tt_db.cSourceType,tt_db.cLDBname,"",ttViewDsProc.cViewName,INPUT-OUTPUT ttViewDsProc.ViewDsId).

/*RUN RefreshSchemaDataSet IN ttViewDsProc.hViewDef (hdsSchema).                    */
/*DYNAMIC-FUNCTION("setViewDsName" IN ttViewDsProc.hViewDef,ttViewDsProc.cViewName).*/

IF DYNAMIC-FUNCTION("getAttribute",ttViewDsProc.hViewDef,"advGuiWin") NE "yes" THEN DO:
  DYNAMIC-FUNCTION("setAttribute",ttViewDsProc.hViewDef,"advGuiWin","yes").
  RUN MoveToTop IN ttViewDsProc.hViewDef.
END.  

CATCH eErr AS Progress.Lang.Error :
  MESSAGE eErr:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PostInitialize C-Win 
PROCEDURE PostInitialize :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveSchemaByRef C-Win
PROCEDURE receiveSchemaByRefx:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM DATASET FOR dsSchema BIND.
DEF OUTPUT PARAM pbReceived AS LOG NO-UNDO.


  FOR EACH tt_db:
    ASSIGN cDbList = cDbList + (IF cDbList NE "" THEN "," ELSE "") + tt_db.cSourceName + "." + tt_db.cLDBname + "," + STRING(tt_db.iDbNum)
           iDbCnt  = IF tt_db.iDbNum > iDbCnt THEN tt_db.iDbNum ELSE iDbCnt
           .
  END.

MESSAGE can-find(first tt_file)
VIEW-AS ALERT-BOX.
END PROCEDURE.
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recordCountRecord C-Win 
PROCEDURE recordCountRecord :
DEF VAR cFieldName AS CHAR NO-UNDO.

FIND FIRST tt_db NO-LOCK
     WHERE tt_db.iDbNum = INT(cb-cDB:SCREEN-VALUE IN FRAME {&FRAME-NAME})
     NO-ERROR.
IF NOT AVAIL tt_db THEN DO:
  MESSAGE "No connected database"
  VIEW-AS ALERT-BOX.
  RETURN.
END.       

IF NOT JBoxSession:Instance:ViewQuestionOkCancel("Count records for all tables?") THEN RETURN.

SESSION:SET-WAIT-STATE("general").

EMPTY TEMP-TABLE ttRecordCount.

FOR EACH tt_file 
    WHERE tt_file.iDbNum = tt_db.iDbNum
    AND CAN-DO("TABLE,T",tt_file.cType)  
    AND (IF tbSysTables:CHECKED IN FRAME {&FRAME-NAME} THEN TRUE ELSE tt_file.cTbl-type = "T")
    AND (IF cTableFilter NE "" THEN tt_file.cFile-name MATCHES "*" + cTableFilter + "*" ELSE TRUE)
    :
  IF tbSysTables:CHECKED AND tt_file.cFile-Name BEGINS "SYS" THEN NEXT.    
  FIND FIRST tt_index-field
       WHERE tt_index-field.iFileNum = tt_file.iFileNum
         AND tt_index-field.cFieldName NE ""
       NO-ERROR.
  IF AVAIL tt_index-field THEN cFieldName = tt_index-field.cFieldName.
  ELSE DO:
    FIND FIRST tt_field
         WHERE tt_field.iFileNum = tt_file.iFileNum
         NO-ERROR.
    IF AVAIL tt_field THEN cFieldName = tt_field.cField-Name.     
  END.    
  FIND FIRST ttRecordCount
       WHERE ttRecordCount.iDbNum = tt_file.iDbNum
         AND ttRecordCount.cTableName = tt_file.cFile-Name
       NO-ERROR.
  IF NOT AVAIL ttRecordCount THEN DO:
    CREATE ttRecordCount.
    ASSIGN ttRecordCount.iDbNum  = tt_file.iDbNum
           ttRecordCount.cTableName = tt_file.cFile-Name
           ttRecordCount.cFieldName = cFieldName
           .
  END.
  ELSE ttRecordCount.iCount = 0.              
END.        

DYNAMIC-FUNCTION("setActiveASconnection",tt_db.cSourceName).

IF JBoxServerAPI:Instance:CallServerProc("jbserv_get_count.p",
                                          tt_db.cSourceName + "|" + tt_db.cSourceType + "|" + tt_db.cLDBname,
                                          BUFFER ttRecordCount:HANDLE) THEN 
  BuildTree(cb-cDB:SCREEN-VALUE).

JBoxServerAPI:Instance:viewCallMessage().  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reloadSchemaRecord C-Win 
PROCEDURE reloadSchemaRecord :
FIND FIRST tt_db
     WHERE tt_db.iDbNum = INT(cb-cDB:SCREEN-VALUE IN FRAME {&FRAME-NAME})
     NO-ERROR.
IF NOT AVAIL tt_db THEN RETURN.     

IF JBoxSchemaCache:Instance:reloadSchema(tt_db.cSourceName,hdsSchema) THEN
  APPLY "value-changed" TO cb-cDB. 
ELSE MESSAGE JBoxSchemaCache:Instance:SchemaMessage
     VIEW-AS ALERT-BOX.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetFieldFormat C-Win 
PROCEDURE SetFieldFormat :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF VAR cFormat AS CHAR NO-UNDO.

FIND FIRST ttTableFlds
     WHERE ttTableFlds.iFieldTreeId = INT(icNode)
     NO-ERROR.
IF AVAIL ttTableFlds THEN DO:
  JBoxSession:Instance:PromptForValue("Change field format","CHARACTER","x(20)",ttTableFlds.cFormat).
  IF JBoxSession:Instance:PromptValueOk THEN DO:
    FIND FIRST tt_field 
         WHERE tt_field.iFileNum  = ttTableFlds.iFileNum
           AND tt_field.iFieldNum = ttTableFlds.iFieldNum
         NO-ERROR.  
    tt_field.cFormat = JBoxSession:Instance:PromptValue. /* To keep the change if switching between database */
    ttTableFlds.cFormat = tt_field.cFormat.
    oJBoxMsTreeView:setNodeText(icNode,
                                ttTableFlds.cDbFld 
                              + " - " + ttTableFlds.cDataType 
                              + " - " + ttTableFlds.cFormat 
                              + (IF NOT bSql THEN " - " + (IF ttTableFlds.cLabel NE ? THEN ttTableFlds.cLabel ELSE "") ELSE "")).
    oJBoxMsTreeView:AppyContextMenuStrip("Field").
  END.  
END.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTableFilterRecord C-Win 
PROCEDURE setTableFilterRecord :
JBoxSession:Instance:PromptForValue("Set filter on table name").
IF JBoxSession:Instance:PromptValueOk THEN DO:
  cTableFilter = JBoxSession:Instance:PromptValue.
  BuildTree(cb-cDB:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SQLconnectRecord C-Win 
PROCEDURE SQLconnectRecord :
DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.
  DEF VAR cSourceName  AS CHAR NO-UNDO.
  DEF VAR oConnector   AS oo.JBoxDataSourceConnector NO-UNDO.
  DEF VAR clFile       AS LONGCHAR NO-UNDO.
/*
  SYSTEM-DIALOG GET-FILE cUseFileName FILTERS "json" "*.json", "All files" "*.*" USE-FILENAME UPDATE bOk.
  IF bOk THEN DO WITH FRAME {&FRAME-NAME}:
    cSourceName = ENTRY(1,ENTRY(NUM-ENTRIES(cUseFileName,"\/"),cUseFileName,"\/"),".").
    IF JBoxSchemaCache:Instance:getIsDbConneced(cSourceName) THEN DO:
      MESSAGE cSourceName " is already connected"
              VIEW-AS ALERT-BOX.
      RETURN.
    END.  
    FIX-CODEPAGE(clFile) = "utf-8".
    COPY-LOB FROM FILE cUseFileName TO OBJECT clFile.
 
    IF JBoxServerAPI:Instance:CallServerProc("jbserv_get_datasource_type.p",cSourceName + CHR(1) + STRING(clFile)) THEN DO:   
      CREATE tt_db.
      ASSIGN tt_db.cLDBname    = cSourceName
             tt_db.cSourceName = cSourceName
             tt_db.cDbType     = JBoxServerAPI:Instance:getCallReturnParam()
             . 
      cb-cDB:ADD-LAST(tt_db.cLDBname).

      IF cb-cDB:SCREEN-VALUE NE cSourceName THEN DO:
        cb-cDB:SCREEN-VALUE = cSourceName.
        APPLY "value-changed" TO cb-cDB.
      END.
    END.
    ELSE MESSAGE "Could not connect to " cSourceName
         VIEW-AS ALERT-BOX.    
  END.    
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeDropFiles C-Win 
PROCEDURE TreeDropFiles :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icDropFiles AS CHAR NO-UNDO.
DEF INPUT PARAM icDropNode  AS CHAR NO-UNDO.

DEF VAR cDbList   AS CHAR NO-UNDO.
DEF VAR iDbCnt    AS INT  NO-UNDO.
DEF VAR cDropFile AS CHAR NO-UNDO.
DEF VAR ix        AS INT  NO-UNDO.

DO ix = 1 TO NUM-ENTRIES(icDropFiles,"|"):
  IF JBoxSchemaCache:Instance:getDbSchema(hDsSchema,ENTRY(ix,icDropFiles,"|")) THEN 
    FOR EACH tt_db:
      IF NOT CAN-DO(cDbList,tt_db.cSourceName + "." + tt_db.cLDBname) THEN 
        ASSIGN cDbList = cDbList + (IF cDbList NE "" THEN "," ELSE "") + tt_db.cSourceName + "." + tt_db.cLDBname + "," + STRING(tt_db.iDbNum)
               iDbCnt  = IF tt_db.iDbNum > iDbCnt THEN tt_db.iDbNum ELSE iDbCnt
               .
    END.
  ELSE MESSAGE JBoxSchemaCache:Instance:SchemaMessage
       VIEW-AS ALERT-BOX.
END.
IF cDbList NE "" THEN DO:
  cb-cDB:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cDbList.
  cb-cDB:SCREEN-VALUE = STRING(iDbCnt).
  APPLY "value-changed" TO cb-cDB.
END.

/*
cDropFile = ENTRY(1,icDropFiles,"|").
IF JBoxSchemaCache:Instance:getDbSchema(hDsSchema,cDropFile) THEN DO:
  FOR EACH tt_db:
    ASSIGN cDbList = cDbList + (IF cDbList NE "" THEN "," ELSE "") + tt_db.cSourceName + "." + tt_db.cLDBname + "," + STRING(tt_db.iDbNum)
           iDbCnt  = IF tt_db.iDbNum > iDbCnt THEN tt_db.iDbNum ELSE iDbCnt
           .
  END.
  cb-cDB:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cDbList.
  cb-cDB:SCREEN-VALUE = STRING(iDbCnt).
  APPLY "value-changed" TO cb-cDB.
END.  
ELSE MESSAGE JBoxSchemaCache:Instance:SchemaMessage
     VIEW-AS ALERT-BOX.
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeNodeBeforeExpandRecord C-Win 
PROCEDURE TreeNodeBeforeExpandRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM icNode   AS CHAR NO-UNDO.
DEF OUTPUT PARAM obCancel AS LOG NO-UNDO. 

DEF VAR ix     AS INT  NO-UNDO.
DEF VAR cTable AS CHAR NO-UNDO.

DEF BUFFER ttDummyExp FOR TEMP-TABLE ttDummyExp.
DEF BUFFER ttTableFlds FOR TEMP-TABLE ttTableFlds.
DEF BUFFER tt_file FOR TEMP-TABLE tt_file.
DEF BUFFER tt_index FOR TEMP-TABLE tt_index.
DEF BUFFER tt_index-field FOR TEMP-TABLE tt_index-field.

FIND FIRST ttDummyExp 
     WHERE ttDummyExp.cTable   = icNode
     NO-ERROR.

IF AVAIL ttDummyExp THEN DO:
  oJBoxMsTreeView:getNodeObject(ttDummyExp.iNodeIdx):Remove().
  DELETE ttDummyExp.
    
  IF tbFieldsByOrder:CHECKED IN FRAME {&FRAME-NAME} THEN
    FOR EACH ttTableFlds
        WHERE ttTableFlds.iFileNum = INT(icNode)
        BY ttTableFlds.iSeq:
           
      ttTableFlds.iNodeIdx = oJBoxMsTreeView:AddNode(icNode
                             ,STRING(ttTableFlds.iFieldTreeId)
                             ,ttTableFlds.cDbFld 
                              + " - " + ttTableFlds.cDataType 
                              + " - " + ttTableFlds.cFormat 
                              + (IF NOT bSql THEN " - " + (IF ttTableFlds.cLabel NE ? THEN ttTableFlds.cLabel ELSE "") ELSE "") 
                             ,"Field",4,-1).
    END.
  ELSE  
    FOR EACH ttTableFlds
        WHERE ttTableFlds.iFileNum = INT(icNode)
        BY ttTableFlds.cDbFld:
           
      ttTableFlds.iNodeIdx = oJBoxMsTreeView:AddNode(icNode
                             ,STRING(ttTableFlds.iFieldTreeId)
                             ,ttTableFlds.cDbFld 
                              + " - " + ttTableFlds.cDataType 
                              + " - " + ttTableFlds.cFormat 
                              + (IF NOT bSql THEN " - " + (IF ttTableFlds.cLabel NE ? THEN ttTableFlds.cLabel ELSE "") ELSE "") 
                             ,"Field",4,-1).
    END.
    
  FOR EACH tt_file 
      WHERE tt_file.iFileNum   = INT(icNode)
     ,EACH tt_index
           WHERE tt_index.iFileNum = tt_file.iFileNum
              BY tt_index.iIdxNum:
    oJBoxMsTreeView:AddNode(icNode,tt_file.cFile-name + "." + tt_index.cIndex-name + "__"
                           ,tt_index.cIndex-name + " - " 
                            + (IF tt_index.cCode = "P" THEN "Primary, " ELSE " ")
                            + (IF tt_index.bUnique THEN "Unique, " ELSE " ")
                            + (IF tt_index.bActive THEN "Active" ELSE "Inactive")
                           ,"Index",7,-1).
    FOR EACH tt_index-field 
        WHERE tt_index-field.iFileNum = tt_file.iFileNum
          AND tt_index-field.iIdxNum = tt_index.iIdxNum
        BY tt_index-field.iIdxSeq:
      oJBoxMsTreeView:AddNode(tt_file.cFile-name + "." + tt_index.cIndex-name + "__",tt_file.cFile-name + "." + tt_index.cIndex-name + "." + tt_index-field.cFieldName,tt_index-field.cFieldName,"IndexField",4,-1).
    END.                             
  END.  
    
  oJBoxMsTreeView:AppyContextMenuStrip("Field").
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeNodeDropped C-Win 
PROCEDURE TreeNodeDropped :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ioTargetTree AS uc.JBoxMsTreeView NO-UNDO.
DEF INPUT PARAM ioSourceNode AS System.Windows.Forms.TreeNode NO-UNDO.
DEF INPUT PARAM ioTargetNode AS System.Windows.Forms.TreeNode NO-UNDO.

DEF VAR cTargetDb    AS CHAR NO-UNDO.
DEF VAR cTargetTable AS CHAR NO-UNDO.

DEF BUFFER btt_file FOR tt_file.
DEF BUFFER btt_db   FOR tt_db.

IF NOT AVAIL tt_db THEN DO:
  FIND FIRST tt_db 
       WHERE tt_db.iDbNum = INT(cb-cDB:SCREEN-VALUE IN FRAME {&FRAME-NAME}) 
       NO-ERROR.
  IF NOT AVAIL tt_db THEN RETURN.    
END.

FIND FIRST ttViewDsProc 
     WHERE ttViewDsProc.hViewDef = ioTargetTree:CONTAINER-HANDLE
     NO-ERROR. 
IF oJBoxMsTreeView:isThisMyNode(ioSourceNode) THEN DO:
  // The view was initiated elsewhere (file/api viewer..)
  IF NOT AVAIL ttViewDsProc THEN DO:
    IF NOT CAN-DO(ioTargetTree:CONTAINER-HANDLE:INTERNAL-ENTRIES,"getViewDsId") THEN RETURN.
    CREATE ttViewDsProc.
    ASSIGN ttViewDsProc.hViewDef  = ioTargetTree:CONTAINER-HANDLE
           ttViewDsProc.cViewName = cViewName
           ttViewDsProc.ViewDsId  = DYNAMIC-FUNCTION("getViewDsId" IN ioTargetTree:CONTAINER-HANDLE)
           .
  END.  

  // Didn't drop on a valid node so we re-initiate the view
  IF NOT VALID-OBJECT(ioTargetNode) THEN DO:


    // (Re-)create the view
    RUN CreateViewDs IN ioTargetTree:CONTAINER-HANDLE (tt_db.cSourceName,tt_db.cSourceType,tt_db.cLDBname,
                                                       oJBoxMsTreeView:getNodeText(ioSourceNode:Name),
                                                       cViewName,
                                                       INPUT-OUTPUT ttViewDsProc.ViewDsId).
  
//    JBoxSession:Instance:setDelayedRun("initViewDsDef",THIS-PROCEDURE).
    JBoxSession:Instance:setDelayedRun("AddFieldsRecord",ioTargetTree:CONTAINER-HANDLE).
    
  END.
  ELSE IF ioTargetTree:isThisMyNode(ioTargetNode) THEN DO:
    ASSIGN cTargetDb    = ENTRY(1,ioTargetTree:getNodeText(ioTargetNode:Name),".")
           cTargetTable = ENTRY(2,ioTargetTree:getNodeText(ioTargetNode:Name),".")
           .
    FOR EACH btt_db
        WHERE btt_db.cLDBname = cTargetDb
       ,EACH btt_file
             WHERE btt_file.iDbNum   = btt_db.iDbNum
               AND btt_file.cFile-Name = cTargetTable
        :         
      cAddToView = ttViewDsProc.ViewDsId + "." + ioTargetTree:getNodeText(ioTargetNode:Name)
                 + "|" + btt_db.cSourceName + "|" + btt_db.cSourceType 
                 // child:
                 + "|" + tt_db.cLDBname + "." + oJBoxMsTreeView:getNodeText(ioSourceNode:Name)
                 + "|" + tt_db.cSourceName + "|" + tt_db.cSourceType
                 .
      JBoxSession:Instance:setDelayedRun("addTableToView",THIS-PROCEDURE).
      LEAVE.
    END.                        
  END.
    
  /*  
  hdsViewDs = DYNAMIC-FUNCTION("getViewDsHandle" IN ioTargetTree:CONTAINER-HANDLE).
  hdsViewDs:GET-BUFFER-HANDLE (1):FIND-FIRST("WHERE TRUE") NO-ERROR.
  IF NOT AVAIL ttViewDsProc AND hdsViewDs:GET-BUFFER-HANDLE (1):AVAIL THEN DO:
    CREATE ttViewDsProc.
    ASSIGN ttViewDsProc.ViewDsId  = hdsViewDs:GET-BUFFER-HANDLE (1)::ViewDsId 
           ttViewDsProc.cViewName = hdsViewDs:GET-BUFFER-HANDLE (1)::ViewDsName
           ttViewDsProc.hViewDef  = ioTargetTree:CONTAINER-HANDLE
           .
  END.         
  ELSE IF NOT hdsViewDs:GET-BUFFER-HANDLE (1):AVAIL THEN DO:
    CREATE ttViewDsProc.
    ASSIGN ttViewDsProc.ViewDsId  = GUID
           ttViewDsProc.cViewName = DYNAMIC-FUNCTION("getViewDsName" IN ioTargetTree:CONTAINER-HANDLE)
           ttViewDsProc.hViewDef  = ioTargetTree:CONTAINER-HANDLE
           ttViewDsProc.hOwner    = THIS-PROCEDURE
           .
  END.

  IF NOT VALID-OBJECT(ioTargetNode) THEN DO:
    hdsViewDs:EMPTY-DATASET().
    CREATE ttViewDs.
    ASSIGn ttViewDs.SourceName   = tt_db.cSourceName
           ttViewDs.SourceType   = tt_db.cSourceType 
           ttViewDs.BaseDb       = tt_db.cLDBname
           ttViewDs.BaseTable    = oJBoxMsTreeView:getNodeText(ioSourceNode:Name)
           ttViewDs.ViewDsId     = IF ttViewDsProc.hOwner = THIS-PROCEDURE THEN GUID ELSE ttViewDsProc.ViewDsId
           ttViewDs.ViewDsName   = ttViewDsProc.cViewName
           ttViewDsProc.ViewDsId = ttViewDs.ViewDsId 
           .
    JBoxSession:Instance:setDelayedRun("initViewDsDef",THIS-PROCEDURE).
  END.
  ELSE IF ioTargetTree:isThisMyNode(ioTargetNode) THEN DO:
    ASSIGN cTargetDb    = ENTRY(1,ioTargetTree:getNodeText(ioTargetNode:Name),".")
           cTargetTable = ENTRY(2,ioTargetTree:getNodeText(ioTargetNode:Name),".")
           .
    FOR EACH btt_db
        WHERE btt_db.cLDBname = cTargetDb
       ,EACH btt_file
             WHERE btt_file.iDbNum   = btt_db.iDbNum
               AND btt_file.cFile-Name = cTargetTable
        :         
      cAddToView = ttViewDsProc.ViewDsId + "." + ioTargetTree:getNodeText(ioTargetNode:Name)
                 + "|" + btt_db.cSourceName + "|" + btt_db.cSourceType 
                 // child:
                 + "|" + tt_db.cLDBname + "." + oJBoxMsTreeView:getNodeText(ioSourceNode:Name)
                 + "|" + tt_db.cSourceName + "|" + tt_db.cSourceType
                 .
      JBoxSession:Instance:setDelayedRun("addTableToView",THIS-PROCEDURE).
      LEAVE.
    END.                        
  END.
  */
END.    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BuildTree C-Win 
FUNCTION BuildTree RETURNS LOGICAL
  ( INPUT icDbNum AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR iCnt      AS INT NO-UNDO.
DEF VAR cProgTxt  AS CHAR NO-UNDO INIT ">".
DEF VAR cPrevTxt  AS CHAR NO-UNDO INIT ">".
DEF VAR iFieldId  AS INT  NO-UNDO INIT 9999.

cFirstNode = "".
oContainer:statusBar:HelpText = ">".
SESSION:IMMEDIATE-DISPLAY = TRUE.
SESSION:SET-WAIT-STATE("general").

oJBoxMsTreeView:getDotNetWidget():BeginUpdate().

oJBoxMsTreeView:clearNodes().
EMPTY TEMP-TABLE ttTableFlds.
EMPTY TEMP-TABLE ttDummyExp.

IF VALID-OBJECT(oContainer:WrapperForm) THEN
  oContainer:WrapperForm:Text = "JukeBox Database Explorer" + (IF cTableFilter NE "" THEN " [TABLES matching *" + cTableFilter + "*]" ELSE "").

oContainer:statusBar:HelpText = cProgTxt.
  
FOR EACH tt_file 
    WHERE tt_file.iDbNum = INT(icDbNum) 
      AND CAN-DO("TABLE,T",tt_file.cType)  
      AND (IF tbSysTables:CHECKED IN FRAME {&FRAME-NAME} THEN TRUE ELSE tt_file.cTbl-type = "T")
      AND (IF cTableFilter NE "" THEN tt_file.cFile-name MATCHES "*" + cTableFilter + "*" ELSE TRUE)
    BY tt_file.cFile-Name: 
          
  FIND FIRST ttRecordCount 
       WHERE ttRecordCount.iDbNum = tt_file.iDbNum
         AND ttRecordCount.cTableName = tt_file.cFile-Name
       NO-ERROR.
               
  oJBoxMsTreeView:AddNode("",STRING(tt_file.iFileNum),tt_file.cFile-name + (IF AVAIL ttRecordCount THEN " (" + STRING(ttRecordCount.iCount) + ")" ELSE ""),
                          IF tt_file.cTbl-Type NE "T" THEN "SysTable" ELSE "Table",3,1).

  CREATE ttDummyExp.
  ASSIGN ttDummyExp.cTable   = STRING(tt_file.iFileNum)
         ttDummyExp.iNodeIdx = oJBoxMsTreeView:AddNode(STRING(tt_file.iFileNum)
                               ,tt_file.cFile-name + "." + STRING(TIME)
                               ,"Dummy node to enable expand"
                               ,"DummyField",4,-1).
  
  iCnt = iCnt + 1.
  IF iCnt MOD 15 = 0 THEN
    ASSIGN cProgTxt = " " + STRING(iCnt) + " -> " + STRING(IF tbSysTables:CHECKED THEN tt_db.iTableCnt ELSE tt_db.iUsrTableCnt)
           oContainer:statusBar:HelpText = REPLACE(oContainer:statusBar:HelpText,cPrevTxt,".") + cProgTxt
           cPrevTxt = cProgTxt.

  IF cFirstNode = "" THEN cFirstNode = tt_file.cFile-name.

  FOR EACH tt_field
      WHERE tt_field.iFileNum = tt_file.iFileNum
      : 

    IF NOT CAN-FIND(FIRST ttTableFlds
                    WHERE ttTableFlds.iFileNum = tt_field.iFileNum
                      AND ttTableFlds.cDbFld = tt_field.cField-Name) THEN DO:

      CREATE ttTableFlds.
      ASSIGN ttTableFlds.cDbName      = tt_file.cLDBname
             ttTableFlds.cTable       = tt_file.cFile-name
             ttTableFlds.iFileNum     = tt_file.iFileNum
             ttTableFlds.cDbFld       = tt_field.cField-name 
             ttTableFlds.cDataType    = tt_field.cData-type
             ttTableFlds.cFormat      = tt_field.cFormat
             ttTableFlds.cLabel       = tt_field.cLabel
             ttTableFlds.iSeq         = tt_field.iOrder
             ttTableFlds.iExtent      = tt_field.iExtent
             ttTableFlds.iFieldNum    = tt_field.iFieldNum
             iFieldId                 = iFieldId + 1
             ttTableFlds.iFieldTreeId = iFieldId
             .
      FOR EACH tt_index
          WHERE tt_index.iFileNum = tt_file.iFileNum
         ,EACH tt_index-field
               WHERE tt_index-field.iFileNum = tt_file.iFileNum
                 AND tt_index-field.iIdxNum = tt_index.iIdxNum
                 AND tt_index-field.cFieldName = tt_field.cField-Name
                 AND tt_index-field.iIdxSeq = 1
          :
        ttTableFlds.bIndex = YES.    
      END.                    
    END.         
  END.
END.  
IF CAN-FIND(FIRST tt_sequence WHERE tt_sequence.iDbNum = INT(icDbNum)) THEN DO:
  oJBoxMsTreeView:AddNode("","Sequences","Sequences","Sequences",8,1).
  FOR EACH tt_sequence
      WHERE tt_sequence.iDbNum = INT(icDbNum):
    oJBoxMsTreeView:AddNode("Sequences",tt_sequence.cSeq-name,tt_sequence.cSeq-name,"Sequence",8,1).
  END.
END.
/*
IF bSql THEN DO:
  FOR EACH tt_file 
      WHERE tt_file.iDbNum = INT(icDbNum) 
        AND tt_file.cType = "VIEW"  
        : 
          
    oJBoxMsTreeView:AddNode("",STRING(tt_file.iFileNum),tt_file.cFile-name,"View",2,1).

    CREATE ttDummyExp.
    ASSIGN ttDummyExp.cTable   = STRING(tt_file.iFileNum)
           ttDummyExp.iNodeIdx = oJBoxMsTreeView:AddNode(tt_file.cFile-name
                                 ,tt_file.cFile-name + "." + STRING(TIME)
                                 ,"Dummy node to enable expand"
                                 ,"DummyField",4,-1).
    
    iCnt = iCnt + 1.
    IF iCnt MOD 15 = 0 THEN
      ASSIGN cProgTxt = " " + STRING(iCnt) + " -> " + STRING(tt_db.iUsrTableCnt)
             oContainer:statusBar:HelpText = REPLACE(oContainer:statusBar:HelpText,cPrevTxt,".") + cProgTxt
             cPrevTxt = cProgTxt.
  
    IF cFirstNode = "" THEN cFirstNode = tt_file.cFile-name.

    FOR EACH tt_field
        WHERE tt_field.iFileNum = tt_file.iFileNum
        : 
  
      CREATE ttTableFlds.
      ASSIGN ttTableFlds.cDb          = tt_file.cLDBname
             ttTableFlds.cTable       = tt_file.cFile-name
             ttTableFlds.cDbFld       = tt_field.cField-name 
             ttTableFlds.cDataType    = tt_field.cData-type
             ttTableFlds.cFormat      = tt_field.cFormat
             ttTableFlds.cLabel       = tt_field.cLabel
             ttTableFlds.iSeq         = tt_field.iOrder
             ttTableFlds.iExtent      = tt_field.iExtent
             ttTableFlds.iFileNum     = tt_field.iFileNum
             ttTableFlds.iFieldNum    = tt_field.iFieldNum
             iFieldId                 = iFieldId + 1
             ttTableFlds.iFieldTreeId = iFieldId
             .
    END.

  END.  

END.  
*/

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "Table" /* The menu is added to nodes of type "Produkt" */
                                    ).

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseTable", /* Procedure to call when menu item is selected */  
                                   "Browse table content", /* Text */
                                   "ico\bullet_ball_green.ico"). 

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseTableNewWin", /* Procedure to call when menu item is selected */  
                                   "Browse table content in separate window", /* Text */
                                   "ico\bullet_triangle_green.ico"). 

IF bUpdateAllowed THEN DO:
  oJBoxMsTreeView:AddContextMenuItem("Table",
                                     "",
                                     "BrowseTableUpdateMode", /* Procedure to call when menu item is selected */  
                                     "Browse table content with edit option", /* Text */
                                     "ico\bullet_ball_yellow.ico"). 

  oJBoxMsTreeView:AddContextMenuItem("Table",
                                     "",
                                     "FreeFormTable", /* Procedure to call when menu item is selected */  
                                     "(Add to) Freeform output", /* Text */
                                     "ico\bullet_ball_red.ico"). 
END.

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseFields", /* Procedure to call when menu item is selected */  
                                   "Browse fields", /* Text */
                                   "ico\bullet_square_green.ico"). 

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "SysTable" /* The menu is added to nodes of type "Produkt" */
                                    ).
oJBoxMsTreeView:AddContextMenuItem("SysTable",
                                   "",
                                   "BrowseFields", /* Procedure to call when menu item is selected */  
                                   "Browse fields", /* Text */
                                   "ico\bullet_square_green.ico"). 

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "Field" /* The menu is added to nodes of type "Produkt" */
                                    ).

oJBoxMsTreeView:AddContextMenuItem("Field",
                                   "",
                                   "SetFieldFormat", /* Procedure to call when menu item is selected */
                                   "Set display format", /* Text */
                                   "ico\bullet_square_yellow.ico").

oJBoxMsTreeView:AddContextMenuItem("Field",
                                   "",
                                   "CopyFieldName", /* Procedure to call when menu item is selected */
                                   "Copy field name", /* Text */
                                   "icons\page_copy.png").

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "View" /* The menu is added to nodes of type "View" */
                                    ).

oJBoxMsTreeView:AddContextMenuItem("View",
                                   "",
                                   "BrowseView", /* Procedure to call when menu item is selected */  
                                   "Browse view content", /* Text */
                                   "ico\bullet_ball_green.ico"). 

oJBoxMsTreeView:getDotNetWidget():EndUpdate().
SESSION:IMMEDIATE-DISPLAY = FALSE.
oContainer:statusBar:HelpText = "".
SESSION:SET-WAIT-STATE ("").

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBuffersAndFields C-Win 
FUNCTION getBuffersAndFields RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR cBuffAndFlds AS CHAR NO-UNDO.
DEF VAR ix           AS INT  NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  FIND FIRST tt_file 
       WHERE tt_file.iFileNum = iCurrFileNum NO-ERROR.
  IF AVAIL tt_file THEN DO:
    cBuffAndFlds = tt_file.cLDBname + "." + tt_file.cFile-name.
    IF cSelectedFields NE "" THEN 
      DO ix = 1 TO NUM-ENTRIES(cSelectedFields):
        FOR EACH tt_field 
            WHERE tt_field.iFileNum = tt_file.iFileNum
              AND NOT tt_field.cData-Type MATCHES "*lob"
              AND tt_field.cData-Type NE "raw"
              AND tt_field.cField-Name = ENTRY(ix,cSelectedFields)
            :
          IF tt_field.iExtent > 0 THEN DO ix = 1 TO tt_field.iExtent:
            cBuffAndFlds = cBuffAndFlds 
                         + ";" + tt_field.cField-name  + "[" + STRING(ix) + "]"
                         + "|" + tt_field.cField-name + "[" + STRING(ix) + "]" + "|"
                         + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                         .
          END.
          ELSE     
            cBuffAndFlds = cBuffAndFlds + ";" + tt_field.cField-name + "|" + tt_field.cField-name + "|"
                         + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                         .
        END.
      END.
    ELSE IF tbFieldsByOrder:CHECKED THEN 
      FOR EACH tt_field 
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND NOT tt_field.cData-Type MATCHES "*lob"
            AND tt_field.cData-Type NE "raw"
            AND (IF cSelectedFields NE "" AND NOT CAN-DO(cSelectedFields,tt_field.cField-Name) THEN FALSE ELSE TRUE)
            BY tt_field.iOrder
          :
        IF tt_field.iExtent > 0 THEN DO ix = 1 TO tt_field.iExtent:
          cBuffAndFlds = cBuffAndFlds 
                       + ";" + tt_field.cField-name  + "[" + STRING(ix) + "]"
                       + "|" + tt_field.cField-name + "[" + STRING(ix) + "]" + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
        END.
        ELSE     
          cBuffAndFlds = cBuffAndFlds + ";" + tt_field.cField-name + "|" + tt_field.cField-name + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
      END.
    ELSE  
      FOR EACH tt_field 
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND NOT tt_field.cData-Type MATCHES "*lob"
            AND tt_field.cData-Type NE "raw"
            AND (IF cSelectedFields NE "" AND NOT CAN-DO(cSelectedFields,tt_field.cField-Name) THEN FALSE ELSE TRUE)
          :
        IF tt_field.iExtent > 0 THEN DO ix = 1 TO tt_field.iExtent:
          cBuffAndFlds = cBuffAndFlds 
                       + ";" + tt_field.cField-name  + "[" + STRING(ix) + "]"
                       + "|" + tt_field.cField-name + "[" + STRING(ix) + "]" + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
        END.
        ELSE     
          cBuffAndFlds = cBuffAndFlds + ";" + tt_field.cField-name + "|" + tt_field.cField-name + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
      END.
  END.   
END.

RETURN cBuffAndFlds.
                       
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSortColumn C-Win 
FUNCTION getSortColumn RETURNS CHARACTER () :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR cSortColumn AS CHAR NO-UNDO.
DEF VAR ix         AS INT NO-UNDO.

IF NOT AVAIL tt_file OR (AVAIL tt_file AND tt_file.iFileNum NE iCurrFileNum)  THEN 
  FIND FIRST tt_file 
       WHERE tt_file.iFileNum = iCurrFileNum
       NO-ERROR.
IF AVAIL tt_file THEN DO:       
  FOR EACH tt_index
      WHERE tt_index.iFileNum = tt_file.iFileNum
        AND tt_index.bActive
     ,EACH tt_index-field
           WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
             AND tt_index-field.iFileNum = tt_file.iFileNum
     ,FIRST tt_field
            WHERE tt_field.iFileNum    = tt_file.iFileNum
              AND tt_field.cField-Name = tt_index-field.cFieldName
              AND tt_field.cData-Type  BEGINS "INT"       
      BY tt_index.iIdxNum
      BY tt_index-field.iIdxSeq      
    :        
    cSortColumn = tt_index-field.cFieldName.
    ix = 999.
    LEAVE.
  END.  
  IF ix NE 999 THEN DO:
    FOR EACH tt_index
        WHERE tt_index.iFileNum = tt_file.iFileNum
          AND tt_index.bActive
       ,EACH tt_index-field
             WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
               AND tt_index-field.iFileNum = tt_file.iFileNum
        BY tt_index.iIdxNum
        BY tt_index-field.iIdxSeq      
      :        
      cSortColumn = tt_index-field.cFieldName.
      ix = 999.
      LEAVE.
    END.
    IF ix NE 999 THEN  
      FOR EACH ttTableFlds 
          WHERE ttTableFlds.cTable = tt_file.cFile-Name
          BY ttTableFlds.iSeq:
        cSortColumn = ttTableFlds.cDbFld.
        LEAVE.      
      END.
  END.  
END.  

RETURN cSortColumn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION reFormatField C-Win 
FUNCTION reFormatField RETURNS CHARACTER
  (INPUT icDatatype AS CHAR
  ,INPUT icFormat   AS CHAR  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cFormat AS CHAR NO-UNDO.

cFormat = icFormat.

IF CAN-DO("INTEGER,INT64,DECIMAL",icDatatype) THEN DO:
  IF CAN-DO("9,>,z",SUBSTR(icFormat,1,1)) THEN
    cFormat = "->>>>>>>" + icFormat.
  ELSE IF icFormat BEGINS "-" THEN
    cFormat = "->>>>>>>" + SUBSTR(icFormat,2).

  cFormat = REPLACE(cFormat,",","<").
END.  
ELSE IF icDatatype = "CHARACTER" AND icFormat BEGINS "!" THEN
  cFormat = REPLACE(icFormat,"!","x").

RETURN cFormat.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RemoveTabFromList C-Win 
FUNCTION RemoveTabFromList RETURNS LOGICAL
  ( INPUT iiTab# AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER bttTableViewTab FOR ttTableViewTab.

FIND FIRST ttTableViewTab
     WHERE ttTableViewTab.TabPage# = iiTab# NO-ERROR.     
IF AVAIL ttTableViewTab THEN DO:
  FOR EACH bttTableViewTab WHERE bttTableViewTab.TabPage# > ttTableViewTab.TabPage#
      :
     bttTableViewTab.TabPage# = bttTableViewTab.TabPage# - 1.
  END.    
  DELETE ttTableViewTab.
  DELETE OBJECT oPageBrowse NO-ERROR.
END.  
FOR EACH ttTableViewTab WHERE ttTableViewTab.TabPage# < iiTab# BY ttTableViewTab.TabPage# DESC:
  oTabBrowse:selectTab(ttTableViewTab.TabPage#).
  oPageBrowse = oTabBrowse:getPageBrowseObject(ttTableViewTab.TabPage#).
  LEAVE.
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION selectFieldPair C-Win 
FUNCTION selectFieldPair RETURNS CHARACTER
  ( INPUT icChildTable  AS CHAR,
    INPUT icChildDb     AS CHAR,
    INPUT icParentTable AS CHAR,
    INPUT icParentDb    AS CHAR,
    INPUT ibIntChar     AS LOG ):
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  DEF VAR iReturn          AS INT  NO-UNDO.
  DEF VAR cPrompt          AS CHAR NO-UNDO.
  DEF VAR cChildFlds       AS CHAR NO-UNDO.
  DEF VAR cParentFlds      AS CHAR NO-UNDO.
  DEF VAR iSpaceWidth      AS INT  NO-UNDO.
  DEF VAR cValue           AS CHAR NO-UNDO.
  DEF VAR cDataType        AS CHAR NO-UNDO. 
  DEF VAR cParentFieldFunc AS CHAR NO-UNDO.
  DEF VAR cChildFieldFunc  AS CHAR NO-UNDO.
  DEF VAR iNumFlds         AS INT NO-UNDO. 

  FOR EACH tt_file
      WHERE tt_file.iDbNum = INT(cb-cDB:SCREEN-VALUE)
        AND tt_file.cLDBname = icChildDb
        AND tt_file.cFile-Name = icChildTable
     ,EACH tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND (IF ibIntChar THEN CAN-DO("character,integer,int64",tt_field.cData-Type) 
                  ELSE CAN-DO("character,date,decimal,integer,int64,logical",tt_field.cData-Type))
     :
    iNumFlds = iNumFlds + 1.
  END.                  
        
  FOR EACH tt_db
           WHERE tt_db.cSourceName = ttViewDs.SourceName
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.cLDBname = icChildDb
             AND tt_file.cFile-Name = icChildTable
     ,EACH tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND (IF ibIntChar THEN CAN-DO("character,integer,int64",tt_field.cData-Type) 
                  ELSE CAN-DO("character,date,decimal,integer,int64,logical",tt_field.cData-Type))
      BY tt_field.cField-Name
      :
    iSpaceWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(tt_field.cField-Name, FRAME {&FRAME-NAME}:FONT) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(" ", FRAME {&FRAME-NAME}:FONT).

    cChildFlds = cChildFlds + (IF cChildFlds NE "" THEN "|" ELSE "")
                + tt_field.cField-Name
                + (IF iNumFlds < 200 THEN FILL(" ",MAX(65 - iSpaceWidth,1)) ELSE " ") 
                + "(" + tt_field.cData-Type
                + (IF JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,tt_file.cFile-Name,tt_file.cLDBname,ttViewDs.SourceName)
                   THEN " *" ELSE "")
                + ")|" + tt_field.cField-Name + "^" + tt_field.cData-Type
                .                   
  END.              
  
  iNumFlds = 0.
  FOR EACH tt_db
           WHERE tt_db.cSourceName = ttViewDs.SourceName
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.cLDBname = icParentDb
             AND tt_file.cFile-Name = icParentTable
     ,EACH tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND (IF ibIntChar THEN CAN-DO("character,integer,int64",tt_field.cData-Type) 
                  ELSE CAN-DO("character,date,decimal,integer,int64,logical",tt_field.cData-Type))
      :            
    iNumFlds = iNumFlds + 1.
  END.                  
  
  FOR EACH tt_db
           WHERE tt_db.cSourceName = ttViewDs.SourceName
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.cLDBname = icParentDb
             AND tt_file.cFile-Name = icParentTable
     ,EACH tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND (IF ibIntChar THEN CAN-DO("character,integer,int64",tt_field.cData-Type) 
                  ELSE CAN-DO("character,date,decimal,integer,int64,logical",tt_field.cData-Type))
      BY tt_field.cField-Name
      :
    iSpaceWidth = FONT-TABLE:GET-TEXT-WIDTH-PIXELS(tt_field.cField-Name, FRAME {&FRAME-NAME}:FONT) / FONT-TABLE:GET-TEXT-WIDTH-PIXELS(" ", FRAME {&FRAME-NAME}:FONT).

    cParentFlds = cParentFlds + (IF cParentFlds NE "" THEN "|" ELSE "")
                + tt_field.cField-Name
                + (IF iNumFlds < 200 THEN FILL(" ",MAX(65 - iSpaceWidth,1)) ELSE " ") 
                + "(" + tt_field.cData-Type
                + (IF JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,tt_file.cFile-Name,tt_file.cLDBname,ttViewDs.SourceName)
                   THEN " *" ELSE "")
                + ")|" + tt_field.cField-Name + "^" + tt_field.cData-Type
                .                   
  END.              
   
  RUN JBoxAskForValue.w ("Select field / field pair for join of " + icChildTable + " and " + icParentTable
                        ,icChildTable + "|CHARACTER|x(50)|||" + cChildFlds + "¤" 
                      +  icParentTable + "|CHARACTER|x(50)|||" + cParentFlds
                        ,INPUT-OUTPUT cPrompt,OUTPUT iReturn).
  IF iReturn = 2 AND NUM-ENTRIES(cPrompt,"|") > 1 THEN DO:
    ASSIGN cChildFlds = ENTRY(1,cPrompt,"|")
           cParentFlds = ENTRY(2,cPrompt,"|")
           .

    IF NUM-ENTRIES(cChildFlds,"^") = 2 AND NUM-ENTRIES(cParentFlds,"^") = 2 THEN DO:
      IF ENTRY(2,cChildFlds,"^") NE ENTRY(2,cParentFlds,"^") THEN DO:
        IF ENTRY(2,cChildFlds,"^") NE "CHARACTER" THEN cChildFieldFunc = "STRING(".
          
        ENTRY(1,cChildFlds,"^") = icChildTable + "." + ENTRY(1,cChildFlds,"^").
          
        IF ENTRY(2,cParentFlds,"^") NE "CHARACTER" THEN cParentFieldFunc = "STRING(".

        ENTRY(1,cParentFlds,"^") = icParentTable + "." + ENTRY(1,cParentFlds,"^").
      END.
      ELSE ASSIGN ENTRY(1,cChildFlds,"^") = icChildTable + "." + ENTRY(1,cChildFlds,"^")
                  ENTRY(1,cParentFlds,"^") = icParentTable + "." + ENTRY(1,cParentFlds,"^")
                  .
      RETURN cChildFieldFunc 
           + icChildDb + "." + ENTRY(1,cChildFlds,"^")
           + (IF cChildFieldFunc NE "" THEN ")" ELSE "")
           + " = " 
           + cParentFieldFunc
           + icParentDb + "." + ENTRY(1,cParentFlds,"^")
           + (IF cParentFieldFunc NE "" THEN ")" ELSE "")
           .
    END.    
    ELSE IF NUM-ENTRIES(cChildFlds,"^") = 2 THEN DO:
      ENTRY(1,cChildFlds,"^") = icChildDb + "." + icChildTable + "." + ENTRY(1,cChildFlds,"^") + " = ".
      cDataType = ENTRY(2,cChildFlds,"^").
      CASE cDataType:
        WHEN "CHARACTER"  THEN cValue = cValue + "'<value>' (opt BEGINS or MATCHES 'ab*d')".
        WHEN "DATE" OR WHEN "DATETIME" OR WHEN "DATETIME-TZ"
          THEN cValue = cDataType + "('" + (IF SESSION:DATE-FORMAT = "dmy" THEN "dd.mm.yyyy" ELSE "mm.dd.yyyy") + "') (IS NULL: = ?)".
        WHEN "DECIMAL"    THEN cValue = "DECIMAL('" + (IF SESSION:NUMERIC-FORMAT = "american" THEN "999.99" ELSE "999,99") + "')".
        WHEN "LOGICAL"    THEN cValue = "true/false".
        OTHERWISE cValue = "<value>".
      END CASE.
      RETURN ENTRY(1,cChildFlds,"^") + cValue.
    END.  
  END.  

END.

RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTabBrowse C-Win 
FUNCTION setTabBrowse RETURNS LOGICAL
  ( INPUT ioBrowse AS JBoxBrowse ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR cBuffAndFlds AS CHAR NO-UNDO.
DEF VAR cFields      AS CHAR NO-UNDO.
DEF VAR ix           AS INT  NO-UNDO.
DEF VAR oParser      AS JBoxJsonParser NO-UNDO.
DEF VAR lcFile       AS lONGCHAR NO-UNDO.

FIX-CODEPAGE(lcFile) = "utf-8".  

DYNAMIC-FUNCTION("setUserSetting",
                 DYNAMIC-FUNCTION("getObjectSourceFile",ioBrowse:BROWSE-HANDLE),
                 DYNAMIC-FUNCTION("getObjectName",ioBrowse:BROWSE-HANDLE),
                 DYNAMIC-FUNCTION("getAttribute",ioBrowse:BROWSE-HANDLE,"usersettingcontext"),
                 "widthpixelslist,overlaybgcolor,noeditfields,currviewfields,orgviewfields",
                 "delete_setting").

IF cCurrentTable NE "dict" THEN DO WITH FRAME {&FRAME-NAME}:
  FIND FIRST tt_file 
       WHERE tt_file.iFileNum = iCurrFileNum NO-ERROR.
  IF AVAIL tt_file AND NOT bSql AND tt_db.cSourceName NE "datafjord" THEN DO:
    cBuffAndFlds = tt_file.cLDBname + "." + tt_file.cFile-name.
    IF cSelectedFields NE "" THEN 
      DO ix = 1 TO NUM-ENTRIES(cSelectedFields):
        FOR EACH tt_field 
            WHERE tt_field.iFileNum = iCurrFileNum
              AND NOT tt_field.cData-Type MATCHES "*lob"
              AND tt_field.cData-Type NE "raw"
              AND tt_field.cField-Name = ENTRY(ix,cSelectedFields)
            :
          IF tt_field.iExtent > 0 THEN DO ix = 1 TO tt_field.iExtent:
            cBuffAndFlds = cBuffAndFlds 
                         + ";" + tt_field.cField-name  + "[" + STRING(ix) + "]"
                         + "|" + tt_field.cField-name + "[" + STRING(ix) + "]" + "|"
                         + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                         .
            cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name + "[" + STRING(ix) + "]".
          END.
          ELSE DO:    
            cBuffAndFlds = cBuffAndFlds + ";" + tt_field.cField-name + "|" + tt_field.cField-name + "|"
                         + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                         .
            cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name.
          END.  
        END.
      END.
    ELSE IF tbFieldsByOrder:CHECKED THEN 
      FOR EACH tt_field 
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND NOT tt_field.cData-Type MATCHES "*lob"
            AND tt_field.cData-Type NE "raw"
            BY tt_field.iOrder
          :
        IF tt_field.iExtent > 0 THEN DO ix = 1 TO tt_field.iExtent:
          cBuffAndFlds = cBuffAndFlds 
                       + ";" + tt_field.cField-name  + "[" + STRING(ix) + "]"
                       + "|" + tt_field.cField-name + "[" + STRING(ix) + "]" + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
          cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name + "[" + STRING(ix) + "]".
        END.
        ELSE DO:    
          cBuffAndFlds = cBuffAndFlds + ";" + tt_field.cField-name + "|" + tt_field.cField-name + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
          cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name.
        END.  
      END.
    ELSE  
      FOR EACH tt_field 
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND NOT tt_field.cData-Type MATCHES "*lob"
            AND tt_field.cData-Type NE "raw"
          :
        IF tt_field.iExtent > 0 THEN DO ix = 1 TO tt_field.iExtent:
          cBuffAndFlds = cBuffAndFlds 
                       + ";" + tt_field.cField-name  + "[" + STRING(ix) + "]"
                       + "|" + tt_field.cField-name + "[" + STRING(ix) + "]" + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
          cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name + "[" + STRING(ix) + "]".
        END.
        ELSE DO:    
          cBuffAndFlds = cBuffAndFlds + ";" + tt_field.cField-name + "|" + tt_field.cField-name + "|"
                       + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                       .
          cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name.
        END.  
      END.
    
    FIND FIRST tt_db WHERE tt_db.iDbNum = tt_file.iDbNum.  
    
    DYNAMIC-FUNCTION("setActiveASconnection",tt_db.cSourceName).  
      
    ioBrowse:buffersAndFields = cBuffAndFlds + ";+RowCount|INTEGER".
    
    ioBrowse:setJBoxAttribute("dataSourceName", tt_db.cSourceName).
    
  END.
  ELSE IF AVAIL tt_file AND bSql THEN DO:
/*    IF cSqlDbNameList NE "" THEN                                                                              */
/*      ioBrowse:setJBoxAttribute("sqlDbName", ENTRY(LOOKUP(cb-cDB:SCREEN-VALUE,cSqlDbNameList),cSqlParamList)).*/
/*    ELSE                                                                                                      */
    ioBrowse:setJBoxAttribute("sqlDbName", tt_db.cSourceName + "." + tt_db.cLDBname).
    ioBrowse:setJBoxAttribute("bufferlist", tt_file.cFile-Name).  
    ioBrowse:useLocalData = NO.
    IF tt_file.cType = "VIEW" THEN DO:
      ioBrowse:setJBoxAttribute("sqlView", tt_file.cFile-Name).
      FOR EACH ttTableFlds 
          WHERE ttTableFlds.cTable = tt_file.cFile-Name
          BY ttTableFlds.iSeq:
        ioBrowse:setQuerySort(ttTableFlds.cDbFld).
        LEAVE.      
      END.
    END.
    ELSE DO:
      FOR EACH tt_index
          WHERE tt_index.iFileNum = tt_file.iFileNum
            AND tt_index.bActive
         ,EACH tt_index-field
               WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
                 AND tt_index-field.iFileNum = tt_file.iFileNum
         ,FIRST tt_field
                WHERE tt_field.iFileNum    = tt_file.iFileNum
                  AND tt_field.cField-Name = tt_index-field.cFieldName
                  AND tt_field.cData-Type  BEGINS "INT"       
                  AND (IF cSelectedFields NE "" AND NOT CAN-DO(cSelectedFields,tt_field.cField-Name) THEN FALSE ELSE TRUE)
          BY tt_index.iIdxNum
          BY tt_index-field.iIdxSeq      
        :        
        ioBrowse:setQuerySort(tt_index-field.cFieldName).
        ix = 999.
        LEAVE.
      END.  
      IF ix NE 999 THEN DO:
        FOR EACH tt_index
            WHERE tt_index.iFileNum = tt_file.iFileNum
              AND tt_index.bActive
           ,EACH tt_index-field
                 WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
                   AND tt_index-field.iFileNum = tt_file.iFileNum
                   AND (IF cSelectedFields NE "" AND NOT CAN-DO(cSelectedFields,tt_index-field.cFieldName) THEN FALSE ELSE TRUE)
            BY tt_index.iIdxNum
            BY tt_index-field.iIdxSeq      
          :        
          ioBrowse:setQuerySort(tt_index-field.cFieldName).
          ix = 999.
          LEAVE.
        END.
        IF ix NE 999 THEN  
          FOR EACH ttTableFlds 
              WHERE ttTableFlds.cTable = tt_file.cFile-Name
                AND (IF cSelectedFields NE "" AND NOT CAN-DO(cSelectedFields,ttTableFlds.cDbFld) THEN FALSE ELSE TRUE)
              BY ttTableFlds.iSeq:
            ioBrowse:setQuerySort(ttTableFlds.cDbFld).
            LEAVE.      
          END.
      END.  
      IF cSelectedFields NE "" THEN DO:
        cBuffAndFlds = tt_file.cLDBname + "." + tt_file.cFile-name.
        DO ix = 1 TO NUM-ENTRIES(cSelectedFields):
          FOR EACH tt_field 
              WHERE tt_field.iFileNum = iCurrFileNum
                AND NOT tt_field.cData-Type MATCHES "*lob"
                AND tt_field.cData-Type NE "raw"
                AND tt_field.cField-Name = ENTRY(ix,cSelectedFields)
              :
            cBuffAndFlds = cBuffAndFlds + ";" + tt_field.cField-name + "|" + tt_field.cField-name + "|"
                         + reFormatField(tt_field.cData-Type, tt_field.cFormat)
                         .
            cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name.
          END.
        END.
        ioBrowse:buffersAndFields = cBuffAndFlds.            
      END.  
      ELSE FOR EACH tt_field 
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND NOT tt_field.cData-Type MATCHES "*lob"
            AND tt_field.cData-Type NE "raw"
            AND (IF cSelectedFields NE "" AND NOT CAN-DO(cSelectedFields,tt_field.cField-Name) THEN FALSE ELSE TRUE)
          :
        cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + tt_field.cField-name.
      END.
    END.  
  END.   
  ELSE IF AVAIL tt_file AND tt_db.cSourceName = "datafjord" THEN DO:
    IF SEARCH(tt_file.cSqlTableName) NE ? THEN DO:
      oParser = NEW JBoxJsonParser().        
      COPY-LOB FROM file tt_file.cSqlTableName TO lcFile.
      MESSAGE "length(lcFile)" length(lcFile)
      VIEW-AS ALERT-BOX.
      oParser:createSchema(lcFile,tt_file.cFile-Name).
      oParser:viewViewDS().
      MESSAGE 123
      VIEW-AS ALERT-BOX.
      oParser:deepCopyTT(oParser:getResultBufferHandle(tt_file.cFile-Name + "1_JB"),ioBrowse:BUFFER-HANDLE).
//      ioBrowse:BUFFER-HANDLE:TABLE-HANDLE:READ-JSON("file",tt_file.cSqlTableName,"APPEND").
    END.
    ELSE MESSAGE "Missing data file: " tt_file.cSqlTableName
         VIEW-AS ALERT-BOX.  
  END.  
  IF bUpdateAllowed AND bUpdateMode THEN DO:  
    ioBrowse:enabledColumns = cFields.
    ioBrowse:enableOnDblClick = YES.
    ioBrowse:BROWSE-HANDLE:TOOLTIP = "Double-click to edit row".
  END.  
END.
oPageBrowse = ioBrowse.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StartTab C-Win 
FUNCTION StartTab RETURNS LOGICAL
  ( INPUT icTable AS CHAR
   ,INPUT iiFileNum AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR iTab#    AS INT NO-UNDO INIT 1.
DEF VAR hTable   AS HANDLE NO-UNDO.
DEF VAR ix       AS INT NO-UNDO.
DEF VAR cDataSrc AS CHAR NO-UNDO.

DEF BUFFER btt_file FOR tt_file.

FIND LAST ttTableViewTab NO-ERROR.     
IF AVAIL ttTableViewTab THEN 
  iTab# = ttTableViewTab.TabPage# + 1.
ELSE DO:
  oTabBrowse = NEW JBoxMsTabs(TabBrowse:HANDLE IN FRAME {&FRAME-NAME}).
  APPLY "end-move" TO btnSplitBarX IN FRAME frSplitBarX.
END.  

IF (bSql OR tt_db.cSourceName = "datafjord") AND icTable NE "dict" THEN DO:
  CREATE TEMP-TABLE hTable.
  IF cSelectedFields NE "" THEN
    DO ix = 1 TO NUM-ENTRIES(cSelectedFields):
      FIND FIRST ttTableFlds
           WHERE ttTableFlds.cTable = icTable
             AND ttTableFlds.cDbFld = ENTRY(ix,cSelectedFields)
           NO-ERROR.
      IF AVAIL ttTableFlds THEN       
        hTable:ADD-NEW-FIELD(ttTableFlds.cDbFld,ttTableFlds.cDataType,0,ttTableFlds.cFormat,"",ttTableFlds.cLabel).
    END.  
  ELSE IF tbFieldsByOrder:CHECKED THEN
    FOR EACH ttTableFlds 
        WHERE ttTableFlds.cTable = icTable
        BY ttTableFlds.iSeq:
      hTable:ADD-NEW-FIELD(ttTableFlds.cDbFld,ttTableFlds.cDataType,0,ttTableFlds.cFormat,"",ttTableFlds.cLabel).
    END.
  ELSE    
    FOR EACH ttTableFlds 
        WHERE ttTableFlds.cTable = icTable
        BY ttTableFlds.cTable:
      hTable:ADD-NEW-FIELD(ttTableFlds.cDbFld,ttTableFlds.cDataType,0,ttTableFlds.cFormat,"",ttTableFlds.cLabel).
    END.
  hTable:ADD-NEW-FIELD("RowIdent1","CHARACTER").
  hTable:ADD-NEW-FIELD("RowCount","INTEGER").
  hTable:ADD-NEW-FIELD("jbCountDistinct","INTEGER",0,">>>,>>>,>>9",1).
  hTable:ADD-NEW-FIELD("jbAverage","DECIMAL",0,"->>>,>>>,>>9.99").
  hTable:ADD-NEW-INDEX ("idxRowids",YES).
  hTable:ADD-INDEX-FIELD ("idxRowids","RowIdent1").
  hTable:TEMP-TABLE-PREPARE(ENTRY(NUM-ENTRIES(icTable,"."),icTable,".")).
END.   

FOR EACH btt_file
    WHERE btt_file.cFile-Name = icTable
   ,FIRST tt_db 
          WHERE tt_db.iDbNum = btt_file.iDbNum:
  ix = ix + 1.
  IF cDataSrc = "" THEN cDataSrc = tt_db.cSourceName.
  ELSE IF cDataSrc NE tt_db.cSourceName THEN
    cDataSrc = "amb".  
END.  
IF ix > 1 THEN 
  FOR EACH btt_file 
      WHERE btt_file.iFileNum = iiFileNum
     ,FIRST tt_db
            WHERE tt_db.iDbNum = btt_file.iDbNum
      :
    IF cDataSrc = "amb" THEN    
      icTable = tt_db.cSourceName + "." + btt_file.cLDBname + "." + icTable.
    ELSE  
      icTable = btt_file.cLDBname + "." + icTable.
  END.
  
oTabBrowse:AddPage(icTable,"JBoxDynTableGrid.w").
/* SetBuffersAndFields will do a call-back to setTabBrowse to get table/field info for db tables */
RUN SetBuffersAndFields IN oTabBrowse:getPageHandle(iTab#) 
   (IF icTable = "dict" THEN BUFFER ttTableFlds:HANDLE
    ELSE IF bSql OR tt_db.cSourceName = "datafjord" THEN hTable 
    ELSE ?).
    
CREATE ttTableViewTab.
ASSIGN ttTableViewTab.TableOrViewName = icTable
       ttTableViewTab.TabPage#        = iTab#
       ttTableViewTab.oDataBrowseObj  = CAST(oPageBrowse,"Progress.Lang.Object")
       oPageBrowse:BROWSE-HANDLE:WINDOW:TITLE = icTable
       oPageBrowse:dynamicUpdateValidation = bDynValidation
       .

oPageBrowse:setJBoxAttribute("flatViewTitle",icTable).

IF bSql THEN
  oPageBrowse:setJBoxAttribute("sqlDbname",tt_db.cSourceName).

JBoxLookupDef:Instance:assignFilterLookup(oPageBrowse).

oPageBrowse:createGridFilter("").

IF bUpdateAllowed AND bUpdateMode THEN
  oPageBrowse:TOOLBAR-OBJECT:addToolGroup("new,delete").

oTabBrowse:SelectTab(icTable).

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION TabChanged C-Win 
FUNCTION TabChanged RETURNS LOGICAL
  ( INPUT iiTab AS INT ) :
/*------------------------------------------------------------------------------
  Purpose: We don't want to sync all tabfolders when changing the tab-folder
           Therefore we delete and re-establish links accordingly
------------------------------------------------------------------------------*/
iCurrDictTab = iiTab.

IF PROGRAM-NAME (2) BEGINS "viewPage" THEN DO WITH FRAME {&FRAME-NAME}:
  IF iiTab = 1 THEN DO:
    oJBoxMsTreeView:BringToFront().
    FRAME frmTv:HANDLE:MOVE-TO-TOP().      
  END.  
  ELSE DO:   
    oJBoxMsTreeView:SendToBack().
    FRAME frmGrid:HANDLE:MOVE-TO-TOP ().   
    APPLY "end-move" TO btnSplitBarX IN FRAME frSplitBarX.
  END.  
  ASSIGN tbExpandAll:SENSITIVE = iiTab = 1
         tbFieldsByOrder:SENSITIVE = iiTab = 1.
END.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

