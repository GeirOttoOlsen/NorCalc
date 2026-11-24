&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
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
DEF VAR bOk                 AS LOG    NO-UNDO.
DEF VAR hBrowse             AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer          AS JBoxContainer NO-UNDO.

DEF VAR oQryViewDs          AS JBoxQuery NO-UNDO.
DEF VAR oQryViewDsTable     AS JBoxQuery NO-UNDO.
DEF VAR oFmViewDsTable      AS JBoxFieldMap NO-UNDO.

DEF VAR oBrwViewDsField     AS JBoxBrowse NO-UNDO.
DEF VAR cCurrDb             AS CHAR NO-UNDO.
DEF VAR cCurrTable          AS CHAR NO-UNDO.
DEF VAR bShowTable          AS LOG  NO-UNDO.
DEF VAR iCurrDbNum          AS INT  NO-UNDO.
DEF VAR cCurrViewId         AS CHAR NO-UNDO.
DEF VAR bLabelFormatPos     AS LOG  NO-UNDO.
DEF VAR oLookup             AS JBoxDynLookup NO-UNDO.
DEF VAR cFilterLookupTblFld AS CHAR NO-UNDO.
DEF VAR bDeleteTableOnCancelFields AS LOG NO-UNDO.
DEF VAR cCurrSourceName     AS CHAR NO-UNDO.
DEF VAR oJboxParser         AS JBoxJsonParser NO-UNDO.
DEF VAR bJoinSameSource     AS LOG NO-UNDO.
DEF VAR cBuffersJoined      AS CHAR NO-UNDO.
DEF VAR bSetExtraTools      AS LOG NO-UNDO.
DEF VAR cViewDsName         AS CHAR NO-UNDO.
DEF VAR hDsTempDataView     AS HANDLE NO-UNDO.
DEF VAR bAddQueryBuilderTools AS LOG NO-UNDO.
DEF VAR hReturnQueryDefTo   AS HANDLE NO-UNDO.
DEF VAR cTtBufferSourceList AS CHAR NO-UNDO.
DEF VAR cCalcOperSuggestion AS CHAR NO-UNDO.

&IF DEFINED(UIB_is_Running) NE 0 &THEN
  {tt_schema.i "NEW SHARED"}
&ELSE
  {tt_schema.i SHARED}
&ENDIF
hdsSchema = DATASET dsSchema:HANDLE.

{incl/tt_viewds.i}
hdsViewDs = DATASET dsViewDs:HANDLE.

DEF TEMP-TABLE ttTableLookup NO-UNDO
  FIELD FieldMatch AS CHAR FORMAT "x(32)" LABEL "Field/idx-match"
  FIELD MatchType  AS CHAR FORMAT "x(8)"  LABEL "Match-type"
  FIELD TableName  AS CHAR FORMAT "x(32)" LABEL "Table"
  FIELD Db         AS CHAR FORMAT "x(32)" 
  INDEX idxFieldMatch Db TableName FieldMatch
  .
DEF VAR hbttTableLookup AS HANDLE NO-UNDO.
hbttTableLookup = BUFFER ttTableLookup:HANDLE.    

DEF TEMP-TABLE ttKeyMatch NO-UNDO
    FIELD FieldName     AS CHAR
    FIELD bMatch        AS LOG
    FIELD ParentKey     AS LOG
    FIELD ChildKey      AS LOG
    FIELD iNumFldMatch  AS INT
    FIELD iFileNum      AS INT
    INDEX idxFileNum iFileNum
    .  

DEF TEMP-TABLE ttSelectFields NO-UNDO
//  FIELD FieldSeq    AS INT  FORMAT ">>>9"  LABEL "Seq"
  FIELD FieldName    AS CHAR FORMAT "x(32)" LABEL "Field"
  FIELD TableName    AS CHAR FORMAT "x(32)" LABEL "Table"
  FIELD FieldType    AS CHAR FORMAT "x(12)" LABEL "Type"
  FIELD FieldFormat  AS CHAR FORMAT "x(12)" LABEL "Format"
  FIELD FieldLabel   AS CHAR FORMAT "x(20)" LABEL "Label"
  FIELD FieldIndexed AS LOG  FORMAT "*/"    LABEL "Indexed"
  FIELD Db           AS CHAR
  FIELD RowIdent1    AS CHAR 
  .

DEF VAR oJBoxMsTreeView AS uc.JBoxMsTreeView NO-UNDO.

DEF VAR otbViewDsField AS JBoxToolbar NO-UNDO.

DEF TEMP-TABLE ttSort NO-UNDO
  FIELD cRowid   AS CHAR
  FIELD iSeq     AS INT
  .

DEF VAR otbBrwViewDsField AS JBoxPopupMenu NO-UNDO.

DEF VAR otbViewDsTable AS JBoxToolbar NO-UNDO.

DEF TEMP-TABLE ttAPIparams NO-UNDO
    FIELD sessionid         AS CHAR
    FIELD method            AS CHAR
    FIELD buffersAndFields  AS CHAR
    FIELD queryJoin         AS CHAR
    FIELD altPrimaryBufferList AS CHAR
    FIELD baseQuery         AS CHAR
    FIELD queryFilter       AS CHAR
    FIELD queryFilterGroup1 AS CHAR
    FIELD queryFilterGroup2 AS CHAR
    FIELD queryFilterGroup3 AS CHAR
    FIELD queryFilterGroup4 AS CHAR
    FIELD queryFilterGroup5 AS CHAR
    FIELD queryFilterGroup6 AS CHAR
    FIELD queryFilterGroup7 AS CHAR
    FIELD queryFilterGroup8 AS CHAR
    FIELD queryFilterGroup9 AS CHAR
    FIELD prescanQuery1     AS CHAR
    FIELD prescanQuery2     AS CHAR
    FIELD prescanQuery3     AS CHAR
    FIELD prescanQuery4     AS CHAR
    FIELD prescanQuery5     AS CHAR
    FIELD prescanQuery6     AS CHAR
    FIELD prescanQuery7     AS CHAR
    FIELD prescanQuery8     AS CHAR
    FIELD prescanQuery9     AS CHAR
    FIELD prescanBaseQuery  AS CHAR // for sql sub-selects
    FIELD querySort         AS CHAR
    FIELD distinctColumns   AS CHAR
    FIELD accumFields       AS CHAR
    FIELD batchSize         AS INT
    FIELD startRow          AS INT
    FIELD getRecordCount    AS LOG
    FIELD queryLogFile      AS CHAR
    FIELD dataSource        AS CHAR
    . 

DEF TEMP-TABLE ttAPIfieldGroup NO-UNDO
    FIELD fieldGroup           AS CHAR
    FIELD groupOper            AS CHAR // AND / OR for group
    FIELD groupField           AS CHAR
    FIELD groupFieldOper       AS CHAR // AND / OR for field
    FIELD groupFieldOperInUse  AS CHAR // =, <>..
    FIELD groupFieldValue      AS CHAR
    FIELD fieldName            AS CHAR
    FIELD FieldOperator        AS LOG
    FIELD OperatorInUse        AS LOG  // to get fields, operators in us and filter values separated
    FIELD filtervalue          AS LOG
    FIELD iSeq                 AS INT  // retrieve fields in right order within group
    FIELD iSubSeq              AS INT  // to make sure that fields, operators in use and values are paired correctly
    .

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brwViewFields tbViewDsField tbViewDsTable ~
JBoxMsTreeView delete_tbViewDsField moveup_tbViewDsField ~
movedown_tbViewDsField rsField edit_tbViewDsTable undo_tbViewDsTable ~
save_tbViewDsTable delete_tbViewDsTable ViewDsTable ViewDsTableOuterJoin ~
ViewDsTableQuery ViewDsTableJoinType ViewDsTableFirstLast ~
ViewDsTableNotExist 
&Scoped-Define DISPLAYED-OBJECTS rsField ViewDsTable ViewDsTableOuterJoin ~
ViewDsTableQuery ViewDsTableJoinType ViewDsTableFirstLast ~
ViewDsTableNotExist 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addAllFields C-Win 
FUNCTION addAllFields RETURNS LOGICAL
  ( INPUT icDb AS CHAR,
    INPUT icTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addDsJoinBuffersToDsTable C-Win 
FUNCTION addDsJoinBuffersToDsTable RETURNS CHARACTER
  ( INPUT ihDs AS HANDLE,
    INPUT icSourceName AS CHAR,
    INPUT icTopDb AS CHAR,
    INPUT icTopTable AS CHAR,
    INPUT icParentDb AS CHAR,
    INPUT icParentTable AS CHAR,
    INPUT ihTt AS HANDLE,
    INPUT icAddedFields AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addFieldFromDictToTt C-Win 
FUNCTION addFieldFromDictToTt RETURNS LOGICAL
  ( INPUT ihTt AS HANDLE,
    INPUT icDataSource AS CHAR,
    INPUT icDb AS CHAR,
    INPUT icTable AS CHAR,
    INPUT icField AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addTableToDs C-Win 
FUNCTION addTableToDs RETURNS LOGICAL
  ( INPUT ihDs           AS HANDLE,
    INPUT ihParentBuffer AS HANDLE,  
    INPUT icParentDb     AS CHAR,
    INPUT icParentTable  AS CHAR,
    INPUT icDb           AS CHAR,
    INPUT icTable        AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BuildTableLookup C-Win 
FUNCTION BuildTableLookup RETURNS LOGICAL
  ( INPUT iiDbNum AS INT,
    INPUT icTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canAddFunction C-Win 
FUNCTION canAddFunction RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeTableQuery C-Win 
FUNCTION closeTableQuery RETURNS LOGICAL ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyFunctions C-Win 
FUNCTION copyFunctions RETURNS LOGICAL
  ( INPUT icToViewDsId AS CHAR,
    INPUT icFromViewDsId AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD createDataSet C-Win 
FUNCTION createDataSet RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DeleteChildTable C-Win 
FUNCTION DeleteChildTable RETURNS LOGICAL
  ( INPUT icParentTable AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FillTreeChildNodes C-Win 
FUNCTION FillTreeChildNodes RETURNS LOGICAL
  ( INPUT icViewDsId    AS CHAR,
    INPUT icParentDb    AS CHAR,
    INPUT icParentTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAlias C-Win 
FUNCTION getAlias RETURNS CHARACTER
  (INPUT icDb    AS CHAR,
   INPUT icTable AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAltPrimaryBuffers C-Win 
FUNCTION getAltPrimaryBuffers RETURNS CHARACTER
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getApiParams C-Win 
FUNCTION getApiParams RETURNS CHARACTER
  ( INPUT icObjectName AS CHAR,
    INPUT ibView       AS LOG ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBaseQuery C-Win 
FUNCTION getBaseQuery RETURNS CHARACTER
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBuffersAndFields C-Win 
FUNCTION getBuffersAndFields RETURNS CHARACTER (INPUT ibLabelFormatPos AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalcOperSuggestion C-Win 
FUNCTION getCalcOperSuggestion RETURNS CHARACTER
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getChildBuffersAndFields C-Win 
FUNCTION getChildBuffersAndFields RETURNS CHARACTER
  ( INPUT icBuffersAndFields AS CHARACTER,
    INPUT icTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceIsSql C-Win 
FUNCTION getDataSourceIsSql RETURNS LOGICAL
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDbPrefix C-Win 
FUNCTION getDbPrefix RETURNS CHARACTER
  ( INPUT icTable AS CHAR,
    INPUT icDb    AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJoinCrit C-Win 
FUNCTION getJoinCrit RETURNS CHARACTER
  ( INPUT icJoinFields AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getJoinCritRev C-Win 
FUNCTION getJoinCritRev RETURNS CHARACTER
  ( INPUT icJoinFields AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLookupTtHandle C-Win 
FUNCTION getLookupTtHandle RETURNS HANDLE
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getParentDataSource C-Win 
FUNCTION getParentDataSource RETURNS CHARACTER
  ( INPUT icDb AS CHAR,
    INPUT icTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrescanQueries C-Win 
FUNCTION getPrescanQueries RETURNS CHARACTER
  ( INPUT icSourceName AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPrescanQuery C-Win 
FUNCTION getPrescanQuery RETURNS CHARACTER
  ( INPUT icPrescan    AS CHAR
   ,INPUT icSourceName AS CHAR
   ,INPUT icDb         AS CHAR 
   ,INPUT icTable      AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryJoin C-Win 
FUNCTION getQueryJoin RETURNS CHARACTER
        (INPUT icQueryJoin AS CHAR,
         INPUT icParentTable AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRelationFields C-Win 
FUNCTION getRelationFields RETURNS CHARACTER
  ( INPUT icParentDb AS CHAR,
    INPUT icParentTable AS CHAR,
    INPUT icDb AS CHAR,
    INPUT icTable AS CHAR,
    INPUT icRelType AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRelTableFromJoin C-Win 
FUNCTION getRelTableFromJoin RETURNS CHARACTER
  ( INPUT icProbableParent  AS CHAR,
    INPUT icRelationship    AS CHAR,
    INPUT icJoin            AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSortColumn C-Win 
FUNCTION getSortColumn RETURNS CHARACTER ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSqlDb C-Win 
FUNCTION getSqlDb RETURNS CHARACTER ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSqlSubQueries C-Win 
FUNCTION getSqlSubQueries RETURNS CHAR
        (INPUT icDb AS CHAR,
         INPUT icTable AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewDsHandle C-Win 
FUNCTION getViewDsHandle RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewDsId C-Win 
FUNCTION getViewDsId RETURNS CHARACTER FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getViewDsName C-Win 
FUNCTION getViewDsName RETURNS CHARACTER
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD LastFieldSeq C-Win 
FUNCTION LastFieldSeq RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD MoveFlds C-Win 
FUNCTION MoveFlds RETURNS LOGICAL
  ( INPUT icUpDown AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RealTable C-Win 
FUNCTION RealTable RETURNS CHARACTER
  ( INPUT icTableName AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RenumFields C-Win 
FUNCTION RenumFields RETURNS LOGICAL
  ( INPUT ibOpenQuery AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD selectFieldPair C-Win 
FUNCTION selectFieldPair RETURNS CHARACTER
  ( INPUT icDsChildName      AS CHAR,
    INPUT icDsChildType      AS CHAR,
    INPUT icChildTable       AS CHAR,
    INPUT icChildDb          AS CHAR,
    INPUT icParentSourceName AS CHAR,
    INPUT icParentSourceType AS CHAR,
    INPUT icParentTable      AS CHAR,
    INPUT icParentDb         AS CHAR,
    INPUT ibIntChar          AS LOG ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAddExtraTools C-Win 
FUNCTION setAddExtraTools RETURNS LOGICAL
  ( INPUT ibSetExtraTools AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAddQueryBuilderTools C-Win 
FUNCTION setAddQueryBuilderTools RETURNS LOGICAL
  ( INPUT ihReturnQueryDefTo AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrDbNum C-Win 
FUNCTION setCurrDbNum RETURNS LOGICAL
  ( INPUT icCurrDb AS CHAR, INPUT icSourceName AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCurrViewId C-Win 
FUNCTION setCurrViewId RETURNS LOGICAL
  (INPUT icCurrViewId AS CHAR  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDropDownDefinitions C-Win 
FUNCTION setDropDownDefinitions RETURNS LOGICAL (INPUT ioBrowseObject AS JBoxBrowse )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLookupDefinitions C-Win 
FUNCTION setLookupDefinitions RETURNS LOGICAL (INPUT ioBrowseObject AS JBoxBrowse )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueries C-Win 
FUNCTION setQueries RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTableQuery C-Win 
FUNCTION setTableQuery RETURNS CHARACTER
  ( INPUT icTable AS CHAR,
    INPUT icQuery AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setViewDsName C-Win 
FUNCTION setViewDsName RETURNS LOGICAL
  ( INPUT icViewDsName AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON delete_tbViewDsField 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 4.6 BY 1.14 TOOLTIP "Delete".

DEFINE BUTTON delete_tbViewDsTable 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Delete" 
     SIZE 4.6 BY 1.14 TOOLTIP "Delete".

DEFINE BUTTON edit_tbViewDsTable 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 4.6 BY 1.14 TOOLTIP "Edit".

DEFINE BUTTON movedown_tbViewDsField 
     IMAGE-UP FILE "gif/movedown.gif":U
     LABEL "Move Down" 
     SIZE 4.6 BY 1.14 TOOLTIP "Move Down".

DEFINE BUTTON moveup_tbViewDsField 
     IMAGE-UP FILE "gif/moveup.gif":U
     LABEL "Move Up" 
     SIZE 4.6 BY 1.14 TOOLTIP "Move Up".

DEFINE BUTTON save_tbViewDsTable 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Save" 
     SIZE 4.6 BY 1.14 TOOLTIP "Save".

DEFINE BUTTON undo_tbViewDsTable 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Undo" 
     SIZE 4.6 BY 1.14 TOOLTIP "Undo".

DEFINE VARIABLE ViewDsTableFirstLast AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE ViewDsTableJoinType AS CHARACTER FORMAT "X(256)":U INITIAL "EACH" 
     LABEL "Join type" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "FIRST","EACH","LAST" 
     DROP-DOWN-LIST
     SIZE 10.8 BY 1 TOOLTIP "FIRST/LAST: OpenEdge ABL uses primary idx (alt rowid). SQL: select column" NO-UNDO.

DEFINE VARIABLE ViewDsTableQuery AS CHARACTER 
     VIEW-AS EDITOR SCROLLBAR-VERTICAL
     SIZE 62.8 BY 1.14 NO-UNDO.

DEFINE VARIABLE ViewDsTable AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY 1 TOOLTIP "Table name" NO-UNDO.

DEFINE VARIABLE rsField AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "All", 1,
"Table", 2
     SIZE 19 BY .67 NO-UNDO.

DEFINE RECTANGLE brwViewFields
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 6.14.

DEFINE RECTANGLE JBoxMsTreeView
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 39.6 BY 5.95.

DEFINE RECTANGLE tbViewDsField
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 63 BY 1.33.

DEFINE RECTANGLE tbViewDsTable
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 19.4 BY 1.33.

DEFINE VARIABLE ViewDsTableNotExist AS LOGICAL INITIAL no 
     LABEL "Not exists" 
     VIEW-AS TOGGLE-BOX
     SIZE 12.6 BY .86 TOOLTIP "Parent record will only show if no child record exists" NO-UNDO.

DEFINE VARIABLE ViewDsTableOuterJoin AS LOGICAL INITIAL no 
     LABEL "Outer" 
     VIEW-AS TOGGLE-BOX
     SIZE 10 BY .81 TOOLTIP "Outer join - parent record will show even if no child record exists" NO-UNDO.

DEFINE BUTTON btnSplitBarX  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 1 BY 9.05
     BGCOLOR 12 FGCOLOR 12 .

DEFINE BUTTON btnSplitBarY  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE 63 BY .48
     BGCOLOR 8 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     delete_tbViewDsField AT ROW 1.19 COL 64.2 WIDGET-ID 14
     moveup_tbViewDsField AT ROW 1.19 COL 69 WIDGET-ID 16
     movedown_tbViewDsField AT ROW 1.19 COL 73.6 WIDGET-ID 18
     rsField AT ROW 1.43 COL 44.8 NO-LABEL WIDGET-ID 8
     edit_tbViewDsTable AT ROW 7.62 COL 2.4 WIDGET-ID 26
     undo_tbViewDsTable AT ROW 7.62 COL 7.2 WIDGET-ID 28
     save_tbViewDsTable AT ROW 7.62 COL 11.8 WIDGET-ID 30
     delete_tbViewDsTable AT ROW 7.62 COL 16.4 WIDGET-ID 34
     ViewDsTable AT ROW 7.67 COL 19 COLON-ALIGNED NO-LABEL
     ViewDsTableOuterJoin AT ROW 8.86 COL 23.8 WIDGET-ID 20
     ViewDsTableQuery AT ROW 9.05 COL 44.2 NO-LABEL WIDGET-ID 4
     ViewDsTableJoinType AT ROW 9.1 COL 9.4 COLON-ALIGNED WIDGET-ID 22
     ViewDsTableFirstLast AT ROW 9.1 COL 20.4 COLON-ALIGNED NO-LABEL WIDGET-ID 38
     ViewDsTableNotExist AT ROW 9.62 COL 23.8 WIDGET-ID 36
     brwViewFields AT ROW 2.48 COL 44 WIDGET-ID 6
     tbViewDsField AT ROW 1.14 COL 44 WIDGET-ID 12
     tbViewDsTable AT ROW 7.52 COL 2.2 WIDGET-ID 24
     JBoxMsTreeView AT ROW 1.24 COL 2.4 WIDGET-ID 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 107.4 BY 9.67 WIDGET-ID 100.

DEFINE FRAME frSplitBarX
     btnSplitBarX AT ROW 1 COL 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 34 ROW 1.24
         SIZE 16 BY 9.05 WIDGET-ID 300.

DEFINE FRAME frSplitBarY
     btnSplitBarY AT ROW 2.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         THREE-D 
         AT COLUMN 43.6 ROW 7.19
         SIZE 63.4 BY 2.62 WIDGET-ID 400.


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
         HEIGHT             = 9.67
         WIDTH              = 107.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 124.6
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 124.6
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
ASSIGN FRAME frSplitBarX:FRAME = FRAME DEFAULT-FRAME:HANDLE
       FRAME frSplitBarY:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       rsField:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "1".

ASSIGN 
       tbViewDsField:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "delete|File;Delete,moveup|File;Move Up,movedown|File;Move Down,creDataset|File;ABL dataset definition¤menu,getABLcode|File;ABL code¤menuFilehide".

ASSIGN 
       tbViewDsTable:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "edit;Edit,undo;Undo,save;Save,delete;Deletehide".

ASSIGN 
       ViewDsTableJoinType:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "EACH".

ASSIGN 
       ViewDsTableQuery:READ-ONLY IN FRAME DEFAULT-FRAME        = TRUE.

/* SETTINGS FOR FRAME frSplitBarX
                                                                        */
ASSIGN 
       btnSplitBarX:MOVABLE IN FRAME frSplitBarX          = TRUE
       btnSplitBarX:PRIVATE-DATA IN FRAME frSplitBarX     = 
                "AddFields;Add fields¤enable".

/* SETTINGS FOR FRAME frSplitBarY
   NOT-VISIBLE UNDERLINE                                                */
ASSIGN 
       btnSplitBarY:MOVABLE IN FRAME frSplitBarY          = TRUE.

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME frSplitBarY
/* Query rebuild information for FRAME frSplitBarY
     _Query            is NOT OPENED
*/  /* FRAME frSplitBarY */
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


&Scoped-define FRAME-NAME frSplitBarX
&Scoped-define SELF-NAME btnSplitBarX
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarX C-Win
ON END-MOVE OF btnSplitBarX IN FRAME frSplitBarX
DO:
    DYNAMIC-FUNCTION("setSplitBarX" , THIS-PROCEDURE:CURRENT-WINDOW, btnSplitBarX:HANDLE IN FRAME frSplitBarX,NO).
    /*  RUN MoveToTop IN hCurrTabProc NO-ERROR.*/

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


&Scoped-define FRAME-NAME frSplitBarY
&Scoped-define SELF-NAME btnSplitBarY
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarY C-Win
ON END-MOVE OF btnSplitBarY IN FRAME frSplitBarY
DO:
  DYNAMIC-FUNCTION("setSplitBarY",THIS-PROCEDURE:CURRENT-WINDOW, btnSplitBarY:HANDLE IN FRAME frSplitBarY,NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define SELF-NAME rsField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsField C-Win
ON VALUE-CHANGED OF rsField IN FRAME DEFAULT-FRAME
DO:
  bShowTable = rsField:SCREEN-VALUE = "2".

  IF bShowTable THEN  
    oBrwViewDsField:setFilter("ViewDsDb,ViewDsTable","=,=",cCurrDb + "|" + cCurrTable).
  ELSE
    oBrwViewDsField:queryFilter = "".
  
  oBrwViewDsField:openQuery().
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ViewDsTableQuery
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ViewDsTableQuery C-Win
ON CTRL-F OF ViewDsTableQuery IN FRAME DEFAULT-FRAME
DO:
  DEF VAR cPrompt     AS CHAR NO-UNDO.
  
  IF ViewDsTableQuery:READ-ONLY THEN RETURN NO-APPLY.
  
  cPrompt = selectFieldPair(ttViewDsTable.SourceName,ttViewDsTable.SourceType,ttViewDsTable.ViewDsTable,ttViewDsTable.ViewDsDb
                           ,ttViewDsTable.ParentSourceName,ttViewDsTable.ParentSourceType,ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsParentDb,NO).
  IF cPrompt NE "" THEN 
    ViewDsTableQuery:SCREEN-VALUE = TRIM(ViewDsTableQuery:SCREEN-VALUE,CHR(10)) + (IF ViewDsTableQuery:SCREEN-VALUE NE "" THEN CHR(10) ELSE "")
                                  + cPrompt.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ViewDsTableQuery C-Win
ON CTRL-S OF ViewDsTableQuery IN FRAME DEFAULT-FRAME
DO:
  otbViewDsTable:invokeTool("Save").  
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
//  DYNAMIC-FUNCTION("DeleteUserControlByPlaceholder",JBoxMsTreeView:HANDLE IN FRAME {&FRAME-NAME}).
  RUN CloseForm (THIS-PROCEDURE,OUTPUT bOk).
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    DELETE OBJECT oContainer NO-ERROR.
  &ENDIF
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */
&ENDIF
ON "WINDOW-RESIZED" OF {&WINDOW-NAME} DO:
  DEF VAR iBtnResizeYPos AS INT NO-UNDO.
  DEF VAR iFrResizeYHP   AS INT NO-UNDO.
  ASSIGN iFrResizeYHP   = FRAME frSplitBarY:HEIGHT-PIXELS
         iBtnResizeYPos = btnSplitBarY:Y IN FRAME frSplitBarY. 
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",THIS-PROCEDURE:CURRENT-WINDOW) NO-ERROR.
  DYNAMIC-FUNCTION("setWidgetResize",THIS-PROCEDURE:CURRENT-WINDOW,THIS-PROCEDURE:CURRENT-WINDOW,"resize","").

/*  Anchor the Y-split */
  btnSplitBarY:Y IN FRAME frSplitBarY = iBtnResizeYPos + (FRAME frSplitBarY:HEIGHT-PIXELS - iFrResizeYHP).
  APPLY "end-move" TO btnSplitBarY IN FRAME frSplitBarY.
  APPLY "end-move" TO btnSplitBarX IN FRAME frSplitBarX. // Moves the Y-split bar above itself
  DYNAMIC-FUNCTION("ResizeKeepsWindowLocked",?) NO-ERROR.
END.


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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ActivateRecord C-Win 
PROCEDURE ActivateRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hContainer AS HANDLE NO-UNDO.

DEF BUFFER bttViewDs FOR ttViewDs.
DEF BUFFER bttViewDsTable FOR ttViewDsTable.
DEF VAR ix    AS INT NO-UNDO.
DEF VAR hDs   AS HANDLE NO-UNDO.  

FOR EACH bttViewDs BREAK BY bttViewDs.SourceName:
  IF FIRST-OF(bttViewDs.SourceName) THEN ix = ix + 1.
END.
IF VALID-HANDLE(hDsTempDataView) THEN DO:
  hDsTempDataView:EMPTY-DATASET ().
  hDsTempDataView = ?.
END.   

FIND FIRST bttViewDsTable
     WHERE bttViewDsTable.ViewDsId = ttViewDs.ViewDsId
       AND bttViewDsTable.SourceName NE ""
       AND (bttViewDsTable.SourceName NE ttViewDs.SourceName
            OR ttViewDsTable.SourceType NE ttViewDs.SourceType)
     NO-ERROR.       
IF NOT AVAIL bttViewDsTable THEN DO:
  IF CAN-DO("tempdata,datafjord",ttViewDs.SourceName) 
//     AND CAN-FIND(FIRST ttViewDsTable WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId) 
     THEN DO:
    oJboxParser:hdsResult = createDataSet().
    oJboxParser:hdsResult:GET-BUFFER-HANDLE(1):COPY-TEMP-TABLE(ttViewDs.hTempTable,NO,NO,YES).
    FOR EACH bttViewDsTable
        WHERE bttViewDsTable.ViewDsId = ttViewDs.ViewDsId
        :
      oJboxParser:hdsResult:GET-BUFFER-HANDLE(bttViewDsTable.ViewDsTable):COPY-TEMP-TABLE(bttViewDsTable.hTempTable,NO,NO,YES).
    END.      
    hDsTempDataView = oJboxParser:createView(oJBoxParser:buildDsResultViewDef("")). 
  END. 
  hContainer = oContainer:StartTabWindow("JboxDataBrw.w",
                                         (IF ix > 1 THEN ttViewDs.SourceName + ", " ELSE "") + ttViewDs.ViewDsName
                                         ,YES,NO).
  /* Initialization in procedure myDatabrowseObject */
END.
ELSE DO:
  hContainer = oContainer:StartChildWindow("JBoxBeViewer.w", 
                                          (IF ix > 1 THEN ttViewDs.SourceName + ", " ELSE "") + ttViewDs.ViewDsName
                                          ,YES).
                            
  hDs = createDataSet().
  
  RUN ViewDataset IN hContainer (hDs,hdsSchema,hdsViewDs,ttViewDs.ViewDsId).
  
  JBoxSession:Instance:setDelayedRun("MoveToTop",hContainer).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addExtraTools C-Win 
PROCEDURE addExtraTools :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  
  otbViewDsField:AddTool("Activate",YES).
  otbViewDsField:AddTool("SaveView","Save","gif/folder.gif",YES).
/*  hBtnSaveView = oChildCont:TOOLBAR-OBJECT:getButtonHandle("SaveView").*/
/*  oChildCont:setFollowSplitBarX(STRING(hBtnSaveView)).                 */
  oContainer:statusBar:hHelpText:FRAME:HIDDEN = NO.

  otbViewDsField:addTool("joinForDatasource","Join tables from same datasource","",YES,"toggle").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddFields C-Win 
PROCEDURE AddFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF BUFFER bttTable FOR ttViewDsTable.  

FIND FIRST ttViewDs 
     WHERE ttViewDs.ViewDsId = ENTRY(1,icNode,".")
     NO-ERROR.
IF AVAIL ttViewDs THEN DO:
  FIND FIRST bttTable 
       WHERE bttTable.ViewDsId     = ENTRY(1,icNode,".")
         AND bttTable.ViewDsDb     = ENTRY(2,icNode,".")
         AND bttTable.ViewDsTable  = ENTRY(3,icNode,".")
       NO-ERROR.
  IF AVAIL bttTable AND setCurrDbNum(bttTable.ViewDsDb,bttTable.SourceName) THEN DO:
    ASSIGN bShowTable = YES
           cCurrTable = bttTable.ViewDsTable
           cCurrDb = bttTable.ViewDsDb
           .
    RUN AddFieldsRecord.
    IF rsField:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1" THEN APPLY "value-changed" TO rsField.       
  END.
  else MESSAGE icNode "bttTable.SourceName" bttTable.SourceName
       VIEW-AS ALERT-BOX.
END.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddFieldsRecord C-Win 
PROCEDURE AddFieldsRecord :
DEF VAR iSeq          AS INT  NO-UNDO.
DEF VAR cFieldList    AS CHAR NO-UNDO.
DEF VAR ix            AS INT  NO-UNDO.
DEF VAR bOkField      AS LOG  NO-UNDO.

DEF BUFFER ttViewDsField FOR ttViewDsField.
DEF BUFFER bttViewDsTable FOR ttViewDsTable.

JBoxServerAPI:Instance:Selector(BUFFER ttSelectFields:HANDLE,"FieldName,TableName,Db"). /* Get list of selected values */

IF JBoxServerAPI:Instance:SelectorOk THEN DO ON ERROR UNDO, THROW:
  cFieldList = REPLACE(JBoxServerAPI:Instance:SelectorReturnValueList,"|",",").

  iSeq = LastFieldSeq().

  DO ix = 1 TO NUM-ENTRIES(cFieldList) BY 3:
    IF NUM-ENTRIES(ENTRY(ix,cFieldList),"[") = 1 THEN DO:
      FIND FIRST ttViewDsField 
           WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
             AND ttViewDsField.ViewDsFieldName = ENTRY(ix,cFieldList)
             AND ttViewDsField.ViewDsTable = ENTRY(ix + 1,cFieldList)
             AND ttViewDsField.ViewDsDb    = ENTRY(ix + 2,cFieldList)
           NO-ERROR.        
      IF NOT AVAIL ttViewDsField THEN
        FOR EACH tt_db
            WHERE tt_db.cSourceName = cCurrSourceName
           ,EACH tt_file 
                 WHERE tt_file.iDbNum = tt_db.iDbNum
                   AND tt_file.cLDBname = ENTRY(ix + 2,cFieldList)
                   AND tt_file.cFile-Name = RealTable(ENTRY(ix + 1,cFieldList))
           ,EACH tt_field 
                 WHERE tt_field.iFileNum = tt_file.iFileNum
                   AND tt_field.cField-Name = ENTRY(ix,cFieldList)
          :
  
          CREATE ttViewDsField.
          ASSIGN ttViewDsField.ViewDsDb = ENTRY(ix + 2,cFieldList)
                 ttViewDsField.ViewDsId = ttViewDs.ViewDsId
                 ttViewDsField.ViewDsTable = ENTRY(ix + 1,cFieldList)
                 ttViewDsField.ViewDsFieldName = tt_field.cField-Name
                 ttViewDsField.ViewDsFieldType = tt_field.cData-Type
                 ttViewDsField.ViewDsFieldLabel = tt_field.cLabel
                 ttViewDsField.ViewDsFieldFormat = tt_field.cFormat
                 ttViewDsField.SourceName = cCurrSourceName
                 ttViewDsField.SourceType = tt_db.cSourceType
                 ttViewDsField.ViewDsFieldIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,ttViewDsField.ViewDsTable,tt_file.cLDBname,ttViewDs.SourceName)
                 iSeq = iSeq + 1
                 ttViewDsField.ViewDsFieldSeq = iSeq + ix
                 ttViewDsField.RowIdent1 = STRING(ROWID(ttViewDsField))
                 . 
        END.
    END.
    ELSE DO:
      FIND FIRST ttViewDsField 
           WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
             AND ttViewDsField.ViewDsFieldName = ENTRY(ix,cFieldList)
             AND ttViewDsField.ViewDsTable = ENTRY(ix + 1,cFieldList)
             AND ttViewDsField.ViewDsDb    = ENTRY(ix + 2,cFieldList)
           NO-ERROR.        
      IF NOT AVAIL ttViewDsField THEN
        FOR EACH tt_db
            WHERE tt_db.cSourceName = cCurrSourceName
           ,EACH tt_file 
                 WHERE tt_file.iDbNum = tt_db.iDbNum
                   AND tt_file.cLDBname = ENTRY(ix + 2,cFieldList)
                   AND tt_file.cFile-Name = RealTable(ENTRY(ix + 1,cFieldList))
           ,EACH tt_field 
                 WHERE tt_field.iFileNum = tt_file.iFileNum
                   AND tt_field.cField-Name = ENTRY(1,ENTRY(ix,cFieldList),"[")
          :
  
          CREATE ttViewDsField.
          ASSIGN ttViewDsField.ViewDsDb = ENTRY(ix + 2,cFieldList)
                 ttViewDsField.ViewDsId = ttViewDs.ViewDsId
                 ttViewDsField.ViewDsTable = ENTRY(ix + 1,cFieldList)
                 ttViewDsField.ViewDsFieldName = ENTRY(ix,cFieldList)
                 ttViewDsField.ViewDsFieldType = tt_field.cData-Type
                 ttViewDsField.ViewDsFieldLabel = tt_field.cLabel + "[" + ENTRY(2,ENTRY(ix,cFieldList),"[")
                 ttViewDsField.ViewDsFieldFormat = tt_field.cFormat
                 ttViewDsField.ViewDsFieldIndexed = NO
                 ttViewDsField.SourceName = cCurrSourceName
                 ttViewDsField.SourceType = tt_db.cSourceType
                 iSeq = iSeq + 1
                 ttViewDsField.ViewDsFieldSeq = iSeq + ix
                 ttViewDsField.RowIdent1 = STRING(ROWID(ttViewDsField))
                 . 
        END.
    END.       
  END.
  
  FOR EACH ttViewDsField
      WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
     ,FIRST bttViewDsTable
            WHERE bttViewDsTable.ViewDsId = ttViewDsField.ViewDsId
              AND bttViewDsTable.ViewDsDb = ttViewDsField.ViewDsDb
              AND bttViewDsTable.ViewDsTable = ttViewDsField.ViewDsTable 
      :
    IF AVAIL ttViewDsTable AND bttViewDsTable.SourceName NE ttViewDsTable.SourceName THEN NEXT.    
    IF bShowTable AND ttViewDsField.ViewDsTable NE cCurrTable OR ttViewDsField.ViewDsDb NE cCurrDb THEN NEXT.
    bOkField = NO.
    DO ix = 1 TO NUM-ENTRIES(cFieldList) BY 3:
      IF ENTRY(ix,cFieldList) = ttViewDsField.ViewDsFieldName AND ENTRY(ix + 1,cFieldList) = ttViewDsField.ViewDsTable AND ENTRY(ix + 2,cFieldList) = ttViewDsField.ViewDsDb THEN
        bOkField = YES.
    END.
    IF NOT bOkField THEN 
      DELETE ttViewDsField.
  END.
  
  copyFunctions(ttViewDs.ViewDsId,"").
    
  RenumFields(NO).
  setQueries().
END.
ELSE IF AVAIL ttViewDsTable AND bDeleteTableOnCancelFields THEN 
  DELETE ttViewDsTable.

CATCH eErr AS Progress.Lang.Error :
  MESSAGE eErr:GetMessage(1) SKIP
          cFieldList
  VIEW-AS ALERT-BOX.
END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddFieldsToBaseTable C-Win 
PROCEDURE AddFieldsToBaseTable :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF BUFFER bttTable FOR ttViewDsTable.  

FIND FIRST ttViewDs 
     WHERE ttViewDs.ViewDsId = ENTRY(1,icNode,".")
     NO-ERROR.
IF AVAIL ttViewDs THEN DO:

  IF setCurrDbNum(ttViewDs.BaseDb,ttViewDs.SourceName) THEN DO:
    ASSIGN bShowTable = YES
           cCurrTable = ttViewDs.BaseTable
           .
    RUN AddFieldsRecord.
    IF rsField:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1" THEN APPLY "value-changed" TO rsField.
  END.         
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddFunctionRecord C-Win 
PROCEDURE AddFunctionRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cSourceTable  AS CHAR NO-UNDO.
DEF VAR cParamField   AS CHAR NO-UNDO.
DEF VAR cFieldName    AS CHAR NO-UNDO.
DEF VAR cDataType     AS CHAR NO-UNDO.
DEF VAR cFormat       AS CHAR NO-UNDO.
DEF VAR cLabel        AS CHAR NO-UNDO.
DEF VAR cCalcCont     AS CHAR NO-UNDO.
DEF VAR cCalcProc     AS CHAR NO-UNDO.
DEF VAR cMandatory    AS CHAR NO-UNDO.
DEF VAR bOK           AS LOG  NO-UNDO.

DEF VAR iSeq          AS INT  NO-UNDO.
DEF VAR cTmpFldName   AS CHAR NO-UNDO.

ASSIGN cSourceTable = ttViewDsField.ViewDsTable
/*       cParamField  = ttViewDsField.ViewDsFieldName*/
/*       cDataType    = ttViewDsField.ViewDsFieldType*/
       cFormat      = ttViewDsField.ViewDsFieldFormat
       cLabel       = ttViewDsField.ViewDsFieldLabel
       cTmpFldName  = ttViewDsField.ViewDsFieldName /* cause cParamField is returned as enclosed () */
       cCurrDb      = ttViewDsField.ViewDsDb
       .
DO iSeq = 1 TO oBrwViewDsField:BROWSE-HANDLE:NUM-SELECTED-ROWS:
  IF oBrwViewDsField:BROWSE-HANDLE:FETCH-SELECTED-ROW(iSeq) THEN
    ASSIGN cParamField = cParamField + (IF cParamField NE "" THEN "," ELSE "") + ttViewDsField.ViewDsTable + "." + ttViewDsField.ViewDsFieldName
           cDataType = cDataType + (IF cDataType NE "" THEN "," ELSE "") + ttViewDsField.ViewDsFieldType
           cLabel = cLabel + (IF cLabel NE "" THEN "," ELSE "") + ttViewDsField.ViewDsFieldLabel
           .
END.
cParamField = cParamField + ",useForQuery". // real bad..

IF oBrwViewDsField:BROWSE-HANDLE:NUM-SELECTED-ROWS > 1 OR NOT ttViewDsField.ViewDsFieldType BEGINS "date" THEN
  cCalcProc = "jb_calc".
             
RUN JBoxSelectCalcFieldFunction.w (ttViewDsField.ViewDsTable
                              ,INPUT-OUTPUT cSourceTable
                              ,INPUT-OUTPUT cParamField
                              ,INPUT-OUTPUT cFieldName
                              ,INPUT-OUTPUT cDataType
                              ,INPUT-OUTPUT cFormat
                              ,INPUT-OUTPUT cLabel
                              ,INPUT-OUTPUT cCalcCont
                              ,INPUT-OUTPUT cCalcProc
                              ,INPUT-OUTPUT cMandatory
                              ,OUTPUT bOk 
                               ).
IF bOk THEN DO:
  iSeq = LastFieldSeq().
         
  CREATE ttViewDsField.
  ASSIGN ttViewDsField.ViewDsDb = cCurrDb
         ttViewDsField.ViewDsId = ttViewDs.ViewDsId
         ttViewDsField.ViewDsTable = cSourceTable
         ttViewDsField.ViewDsFieldName = cFieldName
         ttViewDsField.ViewDsFieldType = cDataType
         ttViewDsField.ViewDsFieldLabel = cLabel
         ttViewDsField.ViewDsFieldFormat = cFormat
         ttViewDsField.ViewDsFieldSeq = iSeq + 1
         ttViewDsField.ViewDsFieldFunction = cCalcProc + cParamField
         ttViewDsField.RowIdent1 = STRING(ROWID(ttViewDsField))
         . 
   oBrwViewDsField:refresh().
   
   PUBLISH "replaceViewDs".
   
 END.                                 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addQueryBuilderTools C-Win 
PROCEDURE addQueryBuilderTools :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
otbViewDsField:AddTool("Activate",YES).
otbViewDsField:AddTool("getQueryDef","Get query","",YES).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddTable C-Win 
PROCEDURE AddTable :
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEF INPUT PARAM icNode AS CHAR NO-UNDO.

  DEF VAR cKeys         AS CHAR NO-UNDO.
  DEF VAR ix            AS INT  NO-UNDO.
  DEF VAR cAlias        AS CHAR NO-UNDO.
  DEF VAR cPrompt       AS CHAR NO-UNDO.
  DEF VAR bIntChar      AS LOG  NO-UNDO.
  DEF VAR cChildDb      AS CHAR NO-UNDO.
  DEF VAR cChildDsName  AS CHAR NO-UNDO.
  DEF VAR cChildDsType  AS CHAR NO-UNDO.
  DEF VAR cParentDsName AS CHAR NO-UNDO.
  DEF VAR cParentDsType AS CHAR NO-UNDO.
  
  DEF BUFFER bttTable FOR ttViewDsTable.  
  
  IF NUM-ENTRIES(icNode,"|") > 1 THEN
    ASSIGN cParentDsName = ENTRY(2,icNode,"|")
           cParentDsType = ENTRY(3,icNode,"|") 
           cChildDb      = ENTRY(1,ENTRY(4,icNode,"|"),".")
           cAlias        = ENTRY(2,ENTRY(4,icNode,"|"),".")
           cChildDsName  = ENTRY(5,icNode,"|")
           cChildDsType  = ENTRY(6,icNode,"|") 
           icNode        = ENTRY(1,icNode,"|") // parent
           .
           
  FIND FIRST bttTable 
       WHERE bttTable.ViewDsId     = ENTRY(1,icNode,".")
         AND bttTable.ViewDsDb     = ENTRY(2,icNode,".")
         AND bttTable.ViewDsTable  = ENTRY(3,icNode,".")
       NO-ERROR.
  IF AVAIL bttTable THEN DO:
    IF cChildDsName = "" THEN
      ASSIGN cChildDsName  = bttTable.SourceName
             cChildDsType  = bttTable.SourceType
             cParentDsName = bttTable.SourceName
             cParentDsType = bttTable.SourceType 
             .         
    
    IF cAlias = "" THEN JBoxServerAPI:Instance:Lookup(hbttTableLookup).                                                
    IF cAlias NE "" OR JBoxServerAPI:Instance:LookupOk THEN DO:
      IF cAlias = "" THEN
        cAlias = getAlias(JBoxServerAPI:Instance:LookupValue("Db"),JBoxServerAPI:Instance:LookupValue("TableName")).
      ELSE  
        cAlias = getAlias(cChildDb,cAlias).
      IF cAlias = ? THEN RETURN.
      CREATE ttViewDsTable.
      ASSIGN ttViewDsTable.ViewDsId            = bttTable.ViewDsId
             ttViewDsTable.ViewDsParentDb      = bttTable.ViewDsDb
             ttViewDsTable.ViewDsParentTable   = bttTable.ViewDsTable
             ttViewDsTable.ViewDsDb            = IF cChildDb NE "" THEN cChildDb ELSE JBoxServerAPI:Instance:LookupValue("Db")
             ttViewDsTable.ViewDsTable         = cAlias
             ttViewDsTable.ViewDsTableJoinType = "EACH"
             ttViewDsTable.RowIdent1           = STRING(ROWID(ttViewDsTable))
             ttViewDsTable.ViewDsTableLevel    = bttTable.ViewDsTableLevel + 1
             ttViewDsTable.SourceName          = cChildDsName
             ttViewDsTable.SourceType          = cChildDsType
             ttViewDsTable.ParentSourceName    = cParentDsName
             ttViewDsTable.ParentSourceType    = cParentDsType
             cCurrDb                           = ttViewDsTable.ViewDsDb
             cCurrTable                        = ttViewDsTable.ViewDsTable
             cKeys                             = IF cChildDb NE "" THEN "" ELSE JBoxServerAPI:Instance:LookupValue("FieldMatch")
             .
      setCurrDbNum(cCurrDb, cChildDsName). 
      IF cKeys = "" THEN DO:
//        bIntChar = JBoxSession:Instance:ViewQuestionYesNo("View only integer and character fields when selecting field pair for join?").
        cPrompt = selectFieldPair(cChildDsName,cChildDsType,ttViewDsTable.ViewDsTable,ttViewDsTable.ViewDsDb
                                 ,ttViewDsTable.ParentSourceName,ttViewDsTable.ParentSourceType
                                 ,ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsParentDb,?).
        IF cPrompt NE "" THEN 
          ttViewDsTable.ViewDsTableQuery = cPrompt.
        ELSE DO:
          DELETE ttViewDsTable.
          RETURN.                                       
        END.  
      END.     
      ELSE DO ix = 1 TO NUM-ENTRIES(cKeys):
        ttViewDsTable.ViewDsTableQuery = ttViewDsTable.ViewDsTableQuery
                                       + (IF ttViewDsTable.ViewDsTableQuery NE "" THEN CHR(10) ELSE "")
                                       + getDbPrefix(ttViewDsTable.ViewDsTable,ttViewDsTable.ViewDsDb)
                                       + ttViewDsTable.ViewDsTable + "." + ENTRY(ix,cKeys) + " = "
                                       + getDbPrefix(ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsDb)
                                       + ttViewDsTable.ViewDsParentTable + "." + ENTRY(ix,cKeys)
                                       .
      END.    
      bShowTable = YES. 
      bDeleteTableOnCancelFields = YES.
      otbBrwViewDsField:applyTool("addfields").
      bShowTable = rsField:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2".
      oQryViewDs:openQuery().
      RenumFields(NO).
      APPLY "value-changed" TO rsField.       
    END.                                                     
  
  END.
  ELSE IF cChildDb NE "" THEN RETURN "TryBaseTable".           

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddToBaseTable C-Win 
PROCEDURE AddToBaseTable :
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEF INPUT PARAM icNode AS CHAR NO-UNDO.

  DEF VAR bAddAllFlds AS LOG  NO-UNDO.
  DEF VAR cKeys       AS CHAR NO-UNDO.
  DEF VAR ix          AS INT  NO-UNDO.
  DEF VAR cAlias      AS CHAR NO-UNDO.
  DEF VAR cPrompt     AS CHAR NO-UNDO.
  DEF VAR bIntChar    AS LOG  NO-UNDO.
  DEF VAR cChildDb      AS CHAR NO-UNDO.
  DEF VAR cChildDsName  AS CHAR NO-UNDO.
  DEF VAR cChildDsType  AS CHAR NO-UNDO.
  
  DEF BUFFER bttTable FOR ttViewDsTable.  
  
  IF NUM-ENTRIES(icNode,"|") > 1 THEN
    ASSIGN cChildDb      = ENTRY(1,ENTRY(4,icNode,"|"),".")
           cAlias        = ENTRY(2,ENTRY(4,icNode,"|"),".")
           cChildDsName  = ENTRY(5,icNode,"|")
           cChildDsType  = ENTRY(6,icNode,"|") 
           icNode        = ENTRY(1,icNode,"|") // parent
           .

  FIND FIRST ttViewDs 
       WHERE ttViewDs.ViewDsId = ENTRY(1,icNode,".")
       NO-ERROR.
  IF AVAIL ttViewDs THEN DO:
    IF cChildDsName = "" THEN
      ASSIGN cChildDsName = ttViewDs.SourceName
             cChildDsType = ttViewDs.SourceType
             .         
    IF cAlias = "" THEN JBoxServerAPI:Instance:Lookup(hbttTableLookup).                                                
    IF cAlias NE "" OR JBoxServerAPI:Instance:LookupOk THEN DO:
      IF cAlias = "" THEN
        cAlias = getAlias(JBoxServerAPI:Instance:LookupValue("Db"),JBoxServerAPI:Instance:LookupValue("TableName")).
      ELSE  
        cAlias = getAlias(cChildDb,cAlias).
      IF cAlias = ? THEN RETURN.
      CREATE ttViewDsTable.
      ASSIGN ttViewDsTable.ViewDsId       = ttViewDs.ViewDsId
        ttViewDsTable.ViewDsParentDb      = ttViewDs.BaseDb
        ttViewDsTable.ViewDsParentTable   = ttViewDs.BaseTable
        ttViewDsTable.ViewDsDb            = IF cChildDb NE "" THEN cChildDb ELSE JBoxServerAPI:Instance:LookupValue("Db")
        ttViewDsTable.ViewDsTable         = cAlias
        ttViewDsTable.ViewDsTableJoinType = "EACH"
        ttViewDsTable.RowIdent1           = STRING(ROWID(ttViewDsTable))
        ttViewDsTable.ViewDsTableLevel    = 1
        ttViewDsTable.SourceName          = cChildDsName
        ttViewDsTable.SourceType          = cChildDsType
        ttViewDsTable.ParentSourceName    = ttViewDs.SourceName
        ttViewDsTable.ParentSourceType    = ttViewDs.SourceType
        cCurrDb                           = ttViewDsTable.ViewDsDb
        cCurrTable                        = ttViewDsTable.ViewDsTable
        cKeys                             = IF cChildDb NE "" THEN "" ELSE JBoxServerAPI:Instance:LookupValue("FieldMatch")
        .
      setCurrDbNum(cCurrDb,cChildDsName).  
      IF cKeys = "" THEN DO:
//        bIntChar = JBoxSession:Instance:ViewQuestionYesNo("View only integer and character fields when selecting field pair for join?").
        cPrompt = selectFieldPair(cChildDsName,cChildDsType,ttViewDsTable.ViewDsTable,ttViewDsTable.ViewDsDb
                                 ,ttViewDs.SourceName,ttViewDs.SourceType // parent
                                 ,ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsParentDb,?).
        IF cPrompt NE "" THEN 
          ttViewDsTable.ViewDsTableQuery = cPrompt.
        ELSE DO:
          DELETE ttViewDsTable.
          RETURN.
        END.  
      END.     
      ELSE DO ix = 1 TO NUM-ENTRIES(cKeys):
        ttViewDsTable.ViewDsTableQuery = ttViewDsTable.ViewDsTableQuery
                                       + (IF ttViewDsTable.ViewDsTableQuery NE "" THEN CHR(10) ELSE "")
                                       + getDbPrefix(ttViewDsTable.ViewDsTable,ttViewDsTable.ViewDsDb)
                                       + ttViewDsTable.ViewDsTable + "." + ENTRY(ix,cKeys) + " = "
                                       + getDbPrefix(ttViewDs.BaseTable,ttViewDs.BaseDb)
                                       + ttViewDsTable.ViewDsParentTable + "." + ENTRY(ix,cKeys)
                                       .
      END.    
        
/*      IF JBoxSession:Instance:ViewQuestionYesNo("Add all fields for " + cCurrTable + "?") THEN*/
/*        addAllFields(ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable).                       */
/*      ELSE DO:                                                                                */
        bShowTable = YES. 
        otbBrwViewDsField:applyTool("addfields").
        bShowTable = rsField:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2".
/*      END.*/
                                
      oQryViewDs:openQuery().
      RenumFields(NO).
      APPLY "value-changed" TO rsField.       
    END.                                                     
  
  END.           

  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddTtBuffer C-Win 
PROCEDURE AddTtBuffer :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF INPUT PARAM ihTtBuffer  AS HANDLE NO-UNDO.
  DEF INPUT PARAM icTargetNode AS CHAR NO-UNDO.
  DEF INPUT PARAM icSourceName AS CHAR NO-UNDO.

  DEF VAR bAddAllFlds   AS LOG  NO-UNDO.
  DEF VAR cKeys         AS CHAR NO-UNDO.
  DEF VAR ix            AS INT  NO-UNDO.
  DEF VAR cAlias        AS CHAR NO-UNDO.
  DEF VAR cPrompt       AS CHAR NO-UNDO.
  DEF VAR bIntChar      AS LOG  NO-UNDO.
  DEF VAR cChildDb      AS CHAR NO-UNDO.
  DEF VAR cChildDsName  AS CHAR NO-UNDO.
  DEF VAR cChildDsType  AS CHAR NO-UNDO.
  DEF VAR cFkFld        AS CHAR NO-UNDO.
  DEF VAR cParentDsName AS CHAR NO-UNDO.
  DEF VAR cParentDsType AS CHAR NO-UNDO.
  DEF VAR bCached       AS LOG  NO-UNDO.
    
  DEF BUFFER bttTable FOR ttViewDsTable.  
  DEF BUFFER tt_file  FOR tt_file.
    
  IF AVAIL ttViewDs THEN DO:
    ASSIGN cChildDsName = IF icSourceName = "" THEN "tempdata" ELSE icSourceName
           cChildDsType = IF icSourceName = "" THEN "tt" ELSE "json"
           cChildDb     = IF icSourceName = "" THEN "temp-table" ELSE "file"
           .
    IF NUM-ENTRIES(icTargetNode,".") > 2 THEN       
      ASSIGN cCurrDb      = ENTRY(2,icTargetNode,".")
             cCurrTable   = ENTRY(3,icTargetNode,".")
             .
    ELSE IF NUM-ENTRIES(icTargetNode,".") > 1 THEN       
      ASSIGN cCurrDb      = ENTRY(1,icTargetNode,".")
             cCurrTable   = ENTRY(2,icTargetNode,".")
             .
                    
    IF cCurrDb = ttViewDs.BaseDb AND cCurrTable = ttViewDs.BaseTable THEN
      ASSIGN cParentDsName = ttViewDs.SourceName
             cParentDsType = ttViewDs.SourceType
             .
    ELSE DO: 
      FIND FIRST bttTable 
           WHERE bttTable.ViewDsDb = cCurrDb
             AND bttTable.ViewDsTable = cCurrTable
           NO-ERROR.
      IF AVAIL bttTable THEN       
        ASSIGN cParentDsName = ttViewDsTable.SourceName
               cParentDsType = ttViewDsTable.SourceType
               .
    END.                           
    
    PUBLISH "getIsCachedTempTable" (ihTtBuffer:TABLE-HANDLE,OUTPUT bCached).
    
    IF NOT bCached THEN 
      JBoxSchemaCache:Instance:addTempTableToSchema(hdsSchema,ihTtBuffer,cChildDsName,cChildDb,NO,"").
             
    FIND FIRST tt_db
         WHERE tt_db.cSourceName = cChildDsName
           AND tt_db.cLDBname    = cChildDb
         NO-ERROR.
    IF NOT AVAIL tt_db THEN DO:
      MESSAGE "Failed to add temp-table db to schema - invalid dataset/db " + cChildDsName + " / " + cChildDb
              VIEW-AS ALERT-BOX.
      RETURN.        
    END.
    FIND FIRST tt_file
         WHERE tt_file.iDbNum = tt_db.iDbNum
           AND tt_file.cLDBname = cChildDb
           AND tt_file.cFile-Name = ihTtBuffer:NAME
         NO-ERROR.
    IF NOT AVAIL tt_file THEN DO:
      MESSAGE "Failed to add temp-table to schema - invalid db/table " + cChildDb + " / " + ihTtBuffer:NAME
              VIEW-AS ALERT-BOX.
      RETURN.        
    END.

    IF tt_file.cFile-Name NE ttViewDs.BaseTable THEN DO:
      cPrompt = selectFieldPair(cChildDsName,cChildDsType,tt_file.cFile-Name,tt_file.cLDBname
                               ,cParentDsName,cParentDsType // parent
                               ,cCurrTable,cCurrDb,?).
      IF cPrompt NE "" THEN DO:
        CREATE ttViewDsTable.
        ASSIGN ttViewDsTable.ViewDsId            = ttViewDs.ViewDsId
               ttViewDsTable.ViewDsParentDb      = cCurrDb
               ttViewDsTable.ViewDsParentTable   = cCurrTable
               ttViewDsTable.ViewDsDb            = cChildDb
               ttViewDsTable.ViewDsTable         = ihTtBuffer:NAME
               ttViewDsTable.ViewDsTableJoinType = "EACH"
               ttViewDsTable.RowIdent1           = STRING(ROWID(ttViewDsTable))
               ttViewDsTable.ViewDsTableLevel    = 1
               ttViewDsTable.SourceName          = cChildDsName
               ttViewDsTable.SourceType          = cChildDsType
               ttViewDsTable.ParentSourceName    = ttViewDs.SourceName
               ttViewDsTable.ParentSourceType    = ttViewDs.SourceType
               ttViewDsTable.ViewDsTableQuery    = cPrompt
               ttViewDsTable.hTempTable          = ihTtBuffer:TABLE-HANDLE
               cCurrDb                           = cChildDb
               cCurrTable                        = ttViewDsTable.ViewDsTable
               .
  
                
        
        CREATE TEMP-TABLE ttViewDsTable.hTempTable.
        ttViewDsTable.hTempTable:CREATE-LIKE(ihTtBuffer).
        ttViewDsTable.hTempTable:ADD-NEW-FIELD ("localRowid","CHARACTER").
        ttViewDsTable.hTempTable:ADD-NEW-FIELD ("Rowident1","CHARACTER").
        ttViewDsTable.hTempTable:ADD-NEW-FIELD ("RowCount","INTEGER").
        
        cFkFld = TRIM(ENTRY(1,ENTRY(2,ENTRY(1,cPrompt," "),"."),")")).
        
        ttViewDsTable.hTempTable:ADD-NEW-INDEX ("idx_" + cFkFld).
        ttViewDsTable.hTempTable:ADD-INDEX-FIELD ("idx_" + cFkFld,cFkFld).
      
        ttViewDsTable.hTempTable:TEMP-TABLE-PREPARE(ihTtBuffer:NAME).
        oJboxParser:deepCopyTT(ihTtBuffer,ttViewDsTable.hTempTable).
//        ttViewDsTable.hTempTable:COPY-TEMP-TABLE(ihTtBuffer,NO,YES,YES).     
      END.  
      ELSE DO:
        DELETE ttViewDsTable.
        RETURN.
      END.  
    END.  
    ELSE DO:
      ttViewDs.hTempTable = ihTtBuffer:TABLE-HANDLE.
/*      CREATE TEMP-TABLE ttViewDs.hTempTable.                  */
/*      ttViewDs.hTempTable:CREATE-LIKE(ihTtBuffer).            */
/*      ttViewDs.hTempTable:TEMP-TABLE-PREPARE(ihTtBuffer:NAME).*/
/*      oJboxParser:deepCopyTT(ihTtBuffer,ttViewDs.hTempTable). */
//      ttViewDs.hTempTable:COPY-TEMP-TABLE(ihTtBuffer,NO,YES,YES).
    END.  

    setCurrDbNum(cCurrDb,cChildDsName).

    bShowTable = YES. 
    otbBrwViewDsField:applyTool("addfields").
    bShowTable = rsField:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "2".
                              
    oQryViewDs:openQuery().
    RenumFields(NO).
    APPLY "value-changed" TO rsField.         
  END.           

  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateViewDs C-Win 
PROCEDURE CreateViewDs :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icDataSourceName    AS CHAR NO-UNDO.
DEF INPUT PARAM icDataSourceType    AS CHAR NO-UNDO.
DEF INPUT PARAM icBaseDb            AS CHAR NO-UNDO.
DEF INPUT PARAM icBaseTable         AS CHAR NO-UNDO.
DEF INPUT PARAM icViewDsName        AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM iocViewDsId  AS CHAR NO-UNDO.

IF iocViewDsId = "" THEN iocViewDsId = GUID.

DATASET dsViewDs:EMPTY-DATASET ().

FIND FIRST tt_db
     WHERE tt_db.cSourceName = icDataSourceName
       AND tt_db.cLDBname    = icBaseDb
     NO-ERROR.
IF AVAIL tt_db THEN DO:
  CREATE ttViewDs.
  ASSIGN ttViewDs.ViewDsId   = iocViewDsId
         ttViewDs.SourceName = icDataSourceName
         ttViewDs.SourceType = IF icDataSourceType = "" THEN tt_db.cSourceType ELSE icDataSourceType
         ttViewDs.BaseDb     = icBaseDb
         ttViewDs.BaseTable  = icBaseTable
         ttViewDs.ViewDsName = icViewDsName
         cCurrDb     = ttViewDs.BaseDb
         cCurrTable  = ttViewDs.BaseTable
         cCurrViewId = ttViewDs.ViewDsId
        .
  setCurrDbNum(cCurrDb,ttViewDs.SourceName).         
  oQryViewDs:openQuery().
END.
ELSE MESSAGE "Datasource" icDataSourceName " not loaded"
     VIEW-AS ALERT-BOX.               

CATCH eErr AS Progress.Lang.Error :
  MESSAGE PROGRAM-NAME(1) eErr:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE creDatasetRecord C-Win 
PROCEDURE creDatasetRecord :
DEF VAR hDs                 AS HANDLE NO-UNDO.
DEF VAR cDs                 AS CHAR NO-UNDO.
DEF VAR cDsName             AS CHAR NO-UNDO.
DEF VAR cPrefix             AS CHAR NO-UNDO.

hDs = createDataSet().
IF VALID-HANDLE(hDs) THEN DO:
  RUN genDsTableDef(hDs,OUTPUT cPrefix,OUTPUT cDsName,OUTPUT cDs).
  JBoxSession:Instance:ViewMessageInNotepad(cDs).
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defDropdownRecord C-Win 
PROCEDURE defDropdownRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cDropDown AS CHAR NO-UNDO.
DEF VAR bOk AS LOG NO-UNDO.

IF ENTRY(1,ttViewDsField.ViewDsFieldFunction,";") = "filterDropDown" AND NUM-ENTRIES(ttViewDsField.ViewDsFieldFunction,";") > 1 THEN
  cDropDown = REPLACE(ENTRY(2,ttViewDsField.ViewDsFieldFunction,";"),"|",CHR(10)).
RUN JboxDSmallEditor.w (INPUT-OUTPUT cDropDown,"Drop-down values",NO,OUTPUT bOk).
IF bOk THEN DO:
  IF cDropDown NE "" THEN
    ttViewDsField.ViewDsFieldFunction = "filterDropDown;" + REPLACE(cDropDown,CHR(10),"|").
  ELSE  
    ttViewDsField.ViewDsFieldFunction = "".
  oBrwViewDsField:refreshRow().
END.

PUBLISH "replaceViewDs".


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defLookupRecord C-Win 
PROCEDURE defLookupRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cFieldList         AS CHAR NO-UNDO.
DEF VAR cFilterReturnField AS CHAR NO-UNDO.
DEF VAR cLookupTable       AS CHAR NO-UNDO.
DEF VAR cLookupDb          AS CHAR NO-UNDO.
DEF VAR cBaseQuery         AS CHAR NO-UNDO.

JBoxServerAPI:Instance:Lookup(hbttTableLookup).                                                
IF JBoxServerAPI:Instance:LookupOk THEN DO:
  cFilterLookupTblFld = JBoxServerAPI:Instance:LookupValue("TableName").
  cLookupDb = JBoxServerAPI:Instance:LookupValue("Db").
  FIND FIRST tt_db
       WHERE tt_db.cSourceName = ttViewDs.SourceName
         AND tt_db.cLDBname    = cLookupDb.
  iCurrDbNum = tt_db.iDbNum.       
  cLookupTable = cFilterLookupTblFld.
  IF NUM-ENTRIES(ttViewDsField.ViewDsFieldFunction,";") > 2 AND cFilterLookupTblFld = ENTRY(2,ttViewDsField.ViewDsFieldFunction,";") THEN
    cFilterLookupTblFld = SUBSTR(ttViewDsField.ViewDsFieldFunction,INDEX(ttViewDsField.ViewDsFieldFunction,";") + 1).
  ELSE
    cFilterLookupTblFld = cFilterLookupTblFld + ";" + ttViewDsField.ViewDsFieldName.  

  JBoxServerAPI:Instance:Selector(BUFFER ttSelectFields:HANDLE,"FieldName"). /* Get list of selected values */
  
  IF JBoxServerAPI:Instance:SelectorOk THEN DO ON ERROR UNDO, THROW:
    cFieldList = REPLACE(JBoxServerAPI:Instance:SelectorReturnValueList,"|",";").
    IF cFieldList NE "" THEN DO:
      IF LOOKUP(ttViewDsField.ViewDsFieldName,cFieldList,";") = 0 THEN DO:
        IF CAN-DO(cFilterLookupTblFld,ttViewDsField.ViewDsFieldName) THEN
          cFieldList = cFieldList + ";" + ttViewDsField.ViewDsFieldName.
        ELSE DO:
          JBoxSession:Instance:SimpleSelectList(cFilterLookupTblFld,",",NO,"Select return-value").
          IF JBoxSession:Instance:SelectListOk THEN DO:
            IF LOOKUP(JBoxSession:Instance:SelectListValue,cFieldList,";") = 0 THEN
              cFieldList = cFieldList + ";" + JBoxSession:Instance:SelectListValue.
            cFilterReturnField = JBoxSession:Instance:SelectListValue.  
          END.  
          ELSE RETURN.
        END.    
      END.  
      IF JBoxSession:Instance:ViewQuestionYesNo("Define base-query for lookup?") THEN
        cBaseQuery = REPLACE(setTableQuery(cLookupTable,""),CHR(10),"").
      ttViewDsField.ViewDsFieldFunction = "filterLookup;"
                                        + cLookupDb + "." 
                                        + cLookupTable + ";" + cFieldList
                                        + (IF cFilterReturnField NE "" THEN "|filterReturnField;" + cFilterReturnField ELSE "")
                                        + (IF cBaseQuery NE "" THEN "|filterBaseQuery;" + cBaseQuery ELSE "")
                                        .
    END.  
    ELSE 
      ttViewDsField.ViewDsFieldFunction = "".  
  END.
  ELSE RETURN.
END.  
ELSE RETURN.

PUBLISH "replaceViewDs".

FINALLY:
  oBrwViewDsField:refreshRow().
  cFilterLookupTblFld = "".
END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteRecord C-Win 
PROCEDURE DeleteRecord :
DEF VAR cTable AS CHAR NO-UNDO.
  IF otbViewDsTable:IsCurrent THEN
    cTable = ttViewDsTable.ViewDsTable.
  RUN SUPER.
  IF cTable NE "" THEN DO:
    FOR EACH ttViewDsField
        WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
          AND ttViewDsField.ViewDsTable = cTable:
      DELETE ttViewDsField.
    END.
    DeleteChildTable(cTable).
  END.
  DO WITH FRAME {&FRAME-NAME}:
    RenumFields(YES).
  END.
  IF cTable NE "" THEN oQryViewDs:openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteView C-Win 
PROCEDURE DeleteView :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icViewId AS CHAR NO-UNDO.

FOR EACH ttViewDsTable
    WHERE ttViewDsTable.ViewDsId = icViewId
    :
  DELETE ttViewDsTable.
END.
FOR EACH ttViewDsField 
    WHERE ttViewDsField.ViewDsId = icViewId
    :
  DELETE ttViewDsField.
END.
FIND FIRST ttViewDs
     WHERE ttViewDs.ViewDsId = icViewId
     NO-ERROR.
IF AVAIL ttViewDs THEN
  DELETE ttViewDs.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE delFilterRecord C-Win 
PROCEDURE delFilterRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
oLookup:BROWSE-OBJECT:setFilter("").
oLookup:BROWSE-OBJECT:setQuerySort("TableName").
oLookup:BROWSE-OBJECT:openQuery().

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
DEF VAR cDisabledBrw    AS CHAR NO-UNDO.
  DEF VAR cFirstLastFlds  AS CHAR NO-UNDO.
  DEF VAR cCurrSource     AS CHAR NO-UNDO.
  
  DEF BUFFER bttViewDsField FOR ttViewDsField.
  DEF BUFFER bttViewDsTable FOR ttViewDsTable.
  
  IF oBrwViewDsField:isCurrent THEN DO WITH FRAME {&FRAME-NAME}:
    otbViewDsField:disabledTools = IF bShowTable OR NOT oBrwViewDsField:querySort MATCHES "*ViewDsFieldSeq" THEN "moveup,movedown" ELSE "".
    IF AVAIL ttViewDsField THEN DO:
      cDisabledBrw = IF NOT canAddFunction() THEN
                       "addFunction"
                     ELSE IF ttViewDsField.ViewDsFieldFunction = "" THEN
                       "editFunction"
                     ELSE "".
        
    END.  
    IF NOT bShowTable THEN DO:
      FIND FIRST bttViewDsTable
           WHERE bttViewDsTable.ViewDsId = ttViewDs.ViewDsId
             AND bttViewDsTable.SourceName NE ttViewDs.SourceName
           NO-ERROR.
      IF AVAIL bttViewDsTable THEN
        cDisabledBrw = cDisabledBrw + (IF cDisabledBrw NE "" THEN "," ELSE "") + "AddFields".
    END.           
    oBrwViewDsField:disabledTools = cDisabledBrw.
  END.
  ELSE IF oQryViewDsTable:IsCurrent THEN DO: 
    cFirstLastFlds = "".
    IF AVAIL ttViewDsTable THEN 
      FOR EACH bttViewDsField
          WHERE bttViewDsField.ViewDsId = ttViewDs.ViewDsId
            AND bttViewDsField.ViewDsDb = ttViewDsTable.ViewDsDb
            AND bttViewDsField.ViewDsTable = ttViewDsTable.ViewDsTable
            AND NOT bttViewDsField.ViewDsFieldFunction BEGINS "jb_"
          BY bttViewDsField.ViewDsFieldName
          :
        cFirstLastFlds = cFirstLastFlds + (IF cFirstLastFlds NE "" THEN "|" ELSE "") + bttViewDsField.ViewDsFieldName + "|" + bttViewDsField.ViewDsFieldName.      
      END.
    IF cFirstLastFlds = "" THEN cFirstLastFlds = "|".
    ViewDsTableFirstLast:LIST-ITEM-PAIRS = cFirstLastFlds. 
  END.  
  
  RUN SUPER.

  ViewDsTableQuery:HELP = "".
  bDeleteTableOnCancelFields = NO.
  IF oQryViewDsTable:IsCurrent AND AVAIL ttViewDsTable THEN 
    RUN ValueChangedField("ViewDsTableJoinType").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE editFunctionRecord C-Win 
PROCEDURE editFunctionRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cSourceTable  AS CHAR NO-UNDO.
DEF VAR cParamField   AS CHAR NO-UNDO.
DEF VAR cFieldName    AS CHAR NO-UNDO.
DEF VAR cDataType     AS CHAR NO-UNDO.
DEF VAR cFormat       AS CHAR NO-UNDO.
DEF VAR cLabel        AS CHAR NO-UNDO.
DEF VAR cCalcCont     AS CHAR NO-UNDO.
DEF VAR cCalcProc     AS CHAR NO-UNDO.
DEF VAR cMandatory    AS CHAR NO-UNDO.
DEF VAR bOK           AS LOG  NO-UNDO.

DEF VAR iSeq          AS INT  NO-UNDO.
DEF VAR cTmpFldName   AS CHAR NO-UNDO.

ASSIGN cSourceTable = ttViewDsField.ViewDsTable
/*       cParamField  = ttViewDsField.ViewDsFieldName*/
/*       cDataType    = ttViewDsField.ViewDsFieldType*/
       cFieldName   = ttViewDsField.ViewDsFieldName
       cFormat      = ttViewDsField.ViewDsFieldFormat
       cLabel       = ttViewDsField.ViewDsFieldLabel
       cTmpFldName  = ttViewDsField.ViewDsFieldName /* cause cParamField is returned as enclosed () */
       cCurrDb      = ttViewDsField.ViewDsDb
 //      cParamField  = ttViewDsField.ViewDsTable + "." + ttViewDsField.ViewDsFieldName
       cDataType    = ttViewDsField.ViewDsFieldType
       cLabel       = ttViewDsField.ViewDsFieldLabel
       cCalcProc    = ttViewDsField.ViewDsFieldFunction 
       cParamField = cParamField + ",useForQueryEdit" // real bad..
       .
             
RUN JBoxSelectCalcFieldFunction.w (ttViewDsField.ViewDsTable
                              ,INPUT-OUTPUT cSourceTable
                              ,INPUT-OUTPUT cParamField
                              ,INPUT-OUTPUT cFieldName
                              ,INPUT-OUTPUT cDataType
                              ,INPUT-OUTPUT cFormat
                              ,INPUT-OUTPUT cLabel
                              ,INPUT-OUTPUT cCalcCont
                              ,INPUT-OUTPUT cCalcProc
                              ,INPUT-OUTPUT cMandatory
                              ,OUTPUT bOk 
                               ).
IF bOk THEN DO:
  ASSIGN ttViewDsField.ViewDsTable = cSourceTable
         ttViewDsField.ViewDsFieldName = cFieldName
         ttViewDsField.ViewDsFieldType = cDataType
         ttViewDsField.ViewDsFieldLabel = cLabel
         ttViewDsField.ViewDsFieldFormat = cFormat
         ttViewDsField.ViewDsFieldFunction = cCalcProc + cParamField
         . 
   oBrwViewDsField:refresh().
   
   PUBLISH "replaceViewDs".
   
 END.                                 


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
IF AVAIL ttViewDsTable THEN DO: 
    IF otbViewDsTable:IsCurrent THEN DO WITH FRAME {&FRAME-NAME}:
      ViewDsTableQuery:HELP = "Press CTRL-F to select field / field pair".
      IF NOT bAddQueryBuilderTools AND VALID-OBJECT(oContainer:PARENT-CONTAINER-OBJECT) THEN DO:
        oContainer:PARENT-CONTAINER-OBJECT:TOOLBAR-OBJECT:setDisabledTools("*").
        oContainer:PARENT-CONTAINER-OBJECT:TOOLBAR-OBJECT:setTools().
        oContainer:PARENT-CONTAINER-OBJECT:BROWSE-OBJECT:POPUP-MENU-OBJECT:setDisabledTools("").
        oContainer:PARENT-CONTAINER-OBJECT:BROWSE-OBJECT:POPUP-MENU-OBJECT:setTools().
      END.  
    END.
    RUN SUPER.    
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
  DISPLAY rsField ViewDsTable ViewDsTableOuterJoin ViewDsTableQuery 
          ViewDsTableJoinType ViewDsTableFirstLast ViewDsTableNotExist 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE brwViewFields tbViewDsField tbViewDsTable JBoxMsTreeView 
         delete_tbViewDsField moveup_tbViewDsField movedown_tbViewDsField 
         rsField edit_tbViewDsTable undo_tbViewDsTable save_tbViewDsTable 
         delete_tbViewDsTable ViewDsTable ViewDsTableOuterJoin ViewDsTableQuery 
         ViewDsTableJoinType ViewDsTableFirstLast ViewDsTableNotExist 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE btnSplitBarX 
      WITH FRAME frSplitBarX IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frSplitBarX}
  ENABLE btnSplitBarY 
      WITH FRAME frSplitBarY IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frSplitBarY}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE focusFields C-Win 
PROCEDURE focusFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hBrw AS HANDLE NO-UNDO.
IF AVAIL ttViewDsField THEN DO:
  hBrw = oBrwViewDsField:BROWSE-HANDLE.
  APPLY "entry" TO hBrw.
  oBrwViewDsField:displayRecord().
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genDsTableDef C-Win 
PROCEDURE genDsTableDef :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM ihDs                 AS HANDLE NO-UNDO.
DEF OUTPUT PARAM ocPrefix             AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocDsName             AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocDs                 AS CHAR   NO-UNDO.

DEF VAR ix           AS INT NO-UNDO.
DEF VAR iy           AS INT NO-UNDO.
DEF VAR cTables      AS CHAR NO-UNDO.
DEF VAR cRelations   AS CHAR NO-UNDO.
DEF VAR cDs          AS CHAR NO-UNDO.
DEF VAR cTablList    AS CHAR NO-UNDO.
DEF VAR bLabelAsSer  AS LOG  NO-UNDO INIT YES.

JBoxSession:Instance:PromptForValues("Dataset layout options", "Table prefix|CHARACTER|x(3)¤Label as ser.name|LOGICAL|Yes/No|No¤DS name|CHARACTER|x(32)|ds" + ttViewDs.ViewDsName).
IF JBoxSession:Instance:PromptValueOk THEN
  ASSIGN ocPrefix    = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
         bLabelAsSer = LOGICAL(ENTRY(2,JBoxSession:Instance:PromptValue,"|"))
         ocDsName    = ENTRY(3,JBoxSession:Instance:PromptValue,"|")
         . 
ELSE RETURN.

IF ihDs:NUM-RELATIONS > 0 THEN DO ix = 1 TO ihDs:NUM-RELATIONS:
  IF ix = 1 THEN DO:
    cTablList = ocPrefix + ihDs:GET-RELATION (1):PARENT-BUFFER:NAME.
    cTables = "DEFINE TEMP-TABLE " + ocPrefix + ihDs:GET-RELATION (1):PARENT-BUFFER:NAME + " NO-UNDO".
    DO iy = 1 TO ihDs:GET-RELATION(1):PARENT-BUFFER:NUM-FIELDS:
      cTables = cTables + CHR(10)
              + "    FIELD "
              + ihDs:GET-RELATION(1):PARENT-BUFFER:BUFFER-FIELD (iy):NAME
              + " AS " 
              + ihDs:GET-RELATION(1):PARENT-BUFFER:BUFFER-FIELD (iy):DATA-TYPE
              + (IF bLabelAsSer THEN
                   " SERIALIZE-NAME '" + REPLACE(ihDs:GET-RELATION(1):PARENT-BUFFER:BUFFER-FIELD (iy):LABEL," ","_") + "'"
                 ELSE "")  
              .
    END.  
    cTables = cTables + CHR(10) + "    .".
  END.  
  
  ASSIGN cTables = cTables + CHR(10) + CHR(10)
         cTablList = cTablList + "," + ocPrefix + ihDs:GET-RELATION (ix):CHILD-BUFFER:NAME
         .
  
  cTables = cTables + "DEFINE TEMP-TABLE " + ocPrefix + ihDs:GET-RELATION (ix):CHILD-BUFFER:NAME + " NO-UNDO".
  DO iy = 1 TO ihDs:GET-RELATION(ix):CHILD-BUFFER:NUM-FIELDS:
    cTables = cTables + CHR(10)
            + "    FIELD "
            + ihDs:GET-RELATION(ix):CHILD-BUFFER:BUFFER-FIELD (iy):NAME
            + " AS " 
            + ihDs:GET-RELATION(ix):CHILD-BUFFER:BUFFER-FIELD (iy):DATA-TYPE
            + (IF bLabelAsSer THEN
                 " SERIALIZE-NAME '" + REPLACE(ihDs:GET-RELATION(ix):CHILD-BUFFER:BUFFER-FIELD (iy):LABEL," ","_") + "'"
               ELSE "")  
            .
  END.
  cTables = cTables + CHR(10) + "    .".

  cRelations = cRelations + CHR(10)
             + "   DATA-RELATION " + ihDs:GET-RELATION (ix):CHILD-BUFFER:NAME
             + " FOR " + ocPrefix + ihDs:GET-RELATION (ix):PARENT-BUFFER:NAME
             + "," + ocPrefix + ihDs:GET-RELATION (ix):CHILD-BUFFER:NAME
             + " RELATION-FIELDS (" + ihDs:GET-RELATION (ix):RELATION-FIELDS + ") NESTED"
             .  
END.  
ELSE DO:
  cTables = cTables + "DEFINE TEMP-TABLE " + ocPrefix + ihDs:GET-BUFFER-HANDLE (1):NAME + " NO-UNDO".
  DO iy = 1 TO ihDs:GET-BUFFER-HANDLE (1):NUM-FIELDS:
    cTables = cTables + CHR(10)
            + "    FIELD "
            + ihDs:GET-BUFFER-HANDLE (1):BUFFER-FIELD (iy):NAME
            + " AS " 
            + ihDs:GET-BUFFER-HANDLE (1):BUFFER-FIELD (iy):DATA-TYPE
            + (IF bLabelAsSer THEN
                 " SERIALIZE-NAME '" + REPLACE(ihDs:GET-BUFFER-HANDLE (1):BUFFER-FIELD (iy):LABEL," ","_") + "'"
               ELSE "")  
            .
  END.
  cTables = cTables + CHR(10) + "    .".
 
END.  

ocDs = cTables
     + (IF ihDs:NUM-RELATIONS > 0 THEN 
         CHR(10) + CHR(10)
      + "DEFINE DATASET " + ocDsName + " FOR " + cTablList + cRelations + CHR(10) + "    ."
        ELSE "").



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getABLcodeRecord C-Win 
PROCEDURE getABLcodeRecord :
DEF VAR hDs                 AS HANDLE NO-UNDO.
DEF VAR cDsDef              AS CHAR NO-UNDO.
DEF VAR cPrefix             AS CHAR NO-UNDO.
DEF VAR cDsName             AS CHAR NO-UNDO.
DEF VAR cCode               AS CHAR NO-UNDO.
DEF VAR cSourcelist         AS CHAR NO-UNDO.
DEF VAR ix                  AS INT  NO-UNDO.
DEF VAR iy                  AS INT  NO-UNDO.
DEF VAR cTableSourceList    AS CHAR NO-UNDO.
DEF VAR cBufferDoneList     AS CHAR NO-UNDO.
DEF VAR cDbBufferName       AS CHAR NO-UNDO.
DEF VAR cDbName             AS CHAR NO-UNDO.
DEF VAR cQueryJoin          AS CHAR NO-UNDO.
DEF VAR cBuffersAndFlds     AS CHAR NO-UNDO.
DEF VAR cFormBuffAndFlds    AS CHAR NO-UNDO.
DEF VAR cFormQueryJoin      AS CHAR NO-UNDO.

DEF BUFFER ttViewDsTable FOR ttViewDsTable.

FIND FIRST ttViewDsTable 
     WHERE ttViewDsTable.SourceName NE ttViewDs.SourceName
     NO-ERROR.
FIND FIRST tt_db
     WHERE tt_db.cSourceName = ttViewDs.SourceName
     .
IF NOT AVAIL tt_db THEN DO:
  MESSAGE "Schema not loaded for " ttViewDs.SourceName
  VIEW-AS ALERT-BOX.
  RETURN.
END.  
     
IF AVAIL ttViewDsTable THEN DO:
  hDs = createDataSet().
  IF NOT VALID-HANDLE(hDs) THEN RETURN.
  RUN genDsTableDef(hDs,OUTPUT cPrefix,OUTPUT cDsName, OUTPUT cDsDef).
   
  cDsDef = 'VAR JBoxBe oBe.' + CHR(10) + CHR(10) + cDsDef.
          
  IF NOT CAN-DO("progressDb,progressApsv",tt_db.cSourceType) THEN     
    cCode = 'JBoxServerApi:Instance:setDataSourceConnection ("' + tt_db.cSourceName + '","' + tt_db.cConnection + '").' + ' // use JBoxServerSide for appserver/batch' + CHR(10).
  
  cSourcelist = tt_db.cSourceName.

  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
     ,FIRST tt_db
            WHERE tt_db.cSourceName = ttViewDsTable.SourceName 
      :
    IF NOT CAN-DO(cSourcelist,ttViewDsTable.SourceName) AND NOT CAN-DO("progressDb,progressApsv",tt_db.cSourceType) THEN
      ASSIGN cSourcelist = cSourcelist + (IF cSourcelist NE "" THEN "," ELSE "") + tt_db.cSourceName
             cCode = cCode + 'JBoxServerApi:Instance:setDataSourceConnection ("' + tt_db.cSourceName + '","' + tt_db.cConnection + '").' + CHR(10).
             .
  END.         
  
  cCode = cCode + CHR(10) + 'JBoxServerAPI:Instance:queryLogFile = "' + cDsName + '.log".' + CHR(10) + CHR(10).

  cCode = cCode + CHR(10) + 'oBe = NEW JBoxBe(DATASET ' + cDsName + ':HANDLE,"' + ENTRY(1,cSourcelist) + '").' + CHR(10) + CHR(10).

  IF cPrefix NE "" THEN
    cCode = cCode + 'oBe:dsTablePrefix = "' + cPrefix + '".' + CHR(10) + CHR(10).

  IF ttViewDs.queryJoin NE "" THEN
    cCode = cCode + 'oBe:setBufferQueryJoin("' + ttViewDs.BaseDb  + '.' + ttViewDs.BaseTable + '","' + ttViewDs.queryJoin + '","'
                  + TRIM(ttViewDs.buffersAndFields + ',' + ttViewDs.joinBuffersAndFields,',') + '").' + CHR(10) + CHR(10).

  DO ix = 2 TO hDs:NUM-BUFFERS:
    DO iy = 1 TO NUM-ENTRIES(cTtBufferSourceList):
      IF ENTRY(1,ENTRY(iy,cTtBufferSourceList),";") = hDs:GET-BUFFER-HANDLE (ix):NAME THEN DO:
        ASSIGN cDbBufferName = ENTRY(2,ENTRY(iy,cTtBufferSourceList),";")
               cDbName       = ENTRY(3,ENTRY(iy,cTtBufferSourceList),";")
               .
        FOR FIRST ttViewDsTable
            WHERE ttViewDsTable.ViewDsId    = ttViewDs.ViewDsId
              AND ttViewDsTable.ViewDsTable = cDbBufferName
              AND ttViewDsTable.ViewDsDb    = cDbName
           ,FIRST tt_db
                  WHERE tt_db.cSourceName = ttViewDsTable.SourceName 
            : 
          IF NOT CAN-DO(cBufferDoneList,hDs:GET-BUFFER-HANDLE (ix):NAME) THEN DO:
            IF NOT CAN-DO("progressDb,progressApsv",tt_db.cSourceType) THEN
              cCode = cCode + 'oBe:setChildBufferDataSource("' + hDs:GET-BUFFER-HANDLE (ix):NAME 
                                                          + '","' + ttViewDsTable.ViewDsTable 
                                                          + '","' + ttViewDsTable.ViewDsDb 
                                                          + '","' + ttViewDsTable.SourceName + '").' + CHR(10).
            cBufferDoneList = cBufferDoneList + (IF cBufferDoneList NE "" THEN "," ELSE "") + hDs:GET-BUFFER-HANDLE (ix):NAME.
            IF ttViewDsTable.queryJoin NE "" THEN
              cCode = cCode + 'oBe:setBufferQueryJoin("' + ttViewDsTable.ViewDsDb  + '.' + ttViewDsTable.ViewDsTable + '"' + CHR(10) 
                            + FILL(" ",23) + ',"' + ttViewDsTable.queryJoin + '"' + CHR(10) 
                            + FILL(" ",23) + ',"' + TRIM(ttViewDsTable.buffersAndFields + ',' + ttViewDsTable.joinBuffersAndFields,',') + '").' + CHR(10).
          END.                  
        END.                  
      END.                    
    END.   
  END.
  
  IF ttViewDs.BaseQuery NE "" THEN
    cCode = cCode + CHR(10) + 'oBe:mainQuery:baseQuery = "' + REPLACE(ttViewDs.BaseQuery,CHR(10)," ") + '".' + CHR(10).

  cCode = cCode + CHR(10) + 'oBe:rowsToBatch = 10.' + CHR(10).

  cCode = cCode + CHR(10) + 'oBe:Get().' + CHR(10).

  cCode = cCode + CHR(10) + 'DATASET ' + cDsName + ':WRITE-JSON("file","' + SESSION:TEMP-DIR + cDsName + '.json",yes).' + CHR(10).

  cCode = cCode + CHR(10) + 'OS-COMMAND NO-WAIT VALUE("notepad ' + SESSION:TEMP-DIR + cDsName + '.json").' + CHR(10).
 
  cCode = cDsDef + CHR(10) + cCode.         
//  JBoxSession:Instance:ViewMessageInNotepad(cDsDef + CHR(10) + cCode).         
END.     
ELSE DO:
  cCode = 'VAR JBoxQuery oQuery.' + CHR(10) + CHR(10).
          
  cBuffersAndFlds = getBuffersAndFields(NO).
  DO ix = 1 TO NUM-ENTRIES(cBuffersAndFlds):
    cFormBuffAndFlds = cFormBuffAndFlds +  CHR(10) + FILL(" ",9) + (IF cFormBuffAndFlds NE "" THEN '+ ",' ELSE '"') + ENTRY(1,ENTRY(ix,cBuffersAndFlds),";") + '"'.
    DO iy = 2 TO NUM-ENTRIES(ENTRY(ix,cBuffersAndFlds),";"):
      cFormBuffAndFlds = cFormBuffAndFlds + CHR(10) + FILL(" ",10) + ' + ";' + ENTRY(iy,ENTRY(ix,cBuffersAndFlds),";") + '"'.
    END.
  END.             
          
  IF NOT CAN-DO("progressDb,progressApsv",tt_db.cSourceType) THEN      
    ASSIGN cCode = cCode + 'JBoxServerApi:Instance:setDataSourceConnection ("' + tt_db.cSourceName + '","' + tt_db.cConnection + '").' + ' // use JBoxServerSide for appserver/batch' + CHR(10)  
           cCode = cCode + CHR(10)
                 + 'oQuery = NEW JBoxQuery(' + cFormBuffAndFlds + CHR(10)
                 + FILL(" ",9) + ',"' + ttViewDs.SourceName + '").' + CHR(10)
           .
  ELSE
    ASSIGN cCode = cCode + CHR(10) + 'JBoxSession:Instance:Initiate().  // for test' + CHR(10)
           cCode = cCode + CHR(10) + 'oQuery = NEW JBoxQuery(' + cFormBuffAndFlds + ').' + CHR(10).
             
  cQueryJoin = getQueryJoin("","").
  IF NUM-ENTRIES(cQueryJoin) > 1 THEN DO:
    cQueryJoin = SUBSTR(cQueryJoin,INDEX(cQueryJoin,",") + 1).
    DO ix = 1 TO NUM-ENTRIES(cQueryJoin):
      cFormQueryJoin = cFormQueryJoin + (IF cFormQueryJoin NE "" THEN CHR(10) + FILL(" ",16) + ' + ",' ELSE '"')
                                      + ENTRY(ix,cQueryJoin) + '"'.
    END.                                              
    cCode = cCode + CHR(10) + 'oQuery:queryJoin = ' + cFormQueryJoin + '.' + CHR(10).
  END.         
  
  cCode = cCode + CHR(10) + '// oQuery:setQuerySort("<fieldname>[;desc],<fieldname>..").' + CHR(10).

  IF ttViewDs.BaseQuery NE "" THEN
    cCode = cCode + CHR(10) + 'oQuery:baseQuery = "' + REPLACE(ttViewDs.BaseQuery,CHR(10)," ") + '".' + CHR(10). 

  cCode = cCode + CHR(10) + 'oQuery:rowsToBatch = 10.' + CHR(10).

  cCode = cCode + CHR(10) + 'oQuery:batchQueryStart = 0.' + CHR(10).
  
  cCode = cCode + CHR(10) + 'JBoxServerAPI:Instance:queryLogFile = "' + ttViewDs.ViewDsName + '.log".' + CHR(10) + CHR(10).
  
  cCode = cCode + CHR(10) + 'oQuery:openQuery().' + CHR(10).

  cCode = cCode + CHR(10) + 'oQuery:BUFFER-HANDLE:WRITE-JSON("file","' + SESSION:TEMP-DIR + ttViewDs.ViewDsName + '.json",yes).' + CHR(10).

  cCode = cCode + CHR(10) + 'OS-COMMAND NO-WAIT VALUE("notepad ' + SESSION:TEMP-DIR + ttViewDs.ViewDsName + '.json").' + CHR(10).
        
END.

OUTPUT TO VALUE(SESSION:TEMP-DIR + "\codeclip.txt").
PUT UNFORMATTED cCode.
OUTPUT CLOSE.
DO ON ERROR UNDO, THROW:  
  System.Diagnostics.Process:Start("notepad.exe",SESSION:TEMP-DIR + "\codeclip.txt").
  CATCH eOS AS Progress.Lang.Error :
     MESSAGE eOS:GetMessage(1) VIEW-AS ALERT-BOX.
  END CATCH.
END.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQueryDefRecord C-Win 
PROCEDURE getQueryDefRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
IF CAN-DO(hReturnQueryDefTo:INTERNAL-ENTRIES,"getQueryDef") THEN
  RUN getQueryDef IN hReturnQueryDefTo (hdsViewDs).
ELSE
  MESSAGE hReturnQueryDefTo:file-name " missing getQueryDef procedure"
  VIEW-AS ALERT-BOX.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeComponents C-Win 
PROCEDURE InitializeComponents :
&IF DEFINED(AdvGuiWin) &THEN
  DO WITH FRAME {&FRAME-NAME}:

    oJBoxMsTreeView = NEW uc.JBoxMsTreeView(THIS-PROCEDURE,JBoxMsTreeView:HANDLE,"tvpics\Fold.bmp,tvpics\FoldOpen.bmp").
    oJBoxMsTreeView:RegisterWithJukeBox(YES).
    oJBoxMsTreeView:setAllowDrop(YES).
  END.
&ENDIF
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
    ASSIGN brwViewFields:HIDDEN = YES
           ViewDsTableFirstLast:HIDDEN = YES
           ViewDsTableFirstLast:DELIMITER = "|"
           .                 

    oJboxParser = NEW JBoxJsonParser().
    
    oQryViewDs = NEW JBoxQuery(BUFFER ttViewDs:HANDLE).
    oQryViewDs:useLocalData = yes.
  
    oQryViewDsTable = NEW JBoxQuery(BUFFER ttViewDsTable:HANDLE).
    oQryViewDsTable:useLocalData = yes.

    oFmViewDsTable = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
    oFmViewDsTable:QUERY-OBJECT = oQryViewDsTable.
    oFmViewDsTable:updateFields = "ViewDsTableJoinType,ViewDsTableOuterJoin,ViewDsTableNotExist,ViewDsTableQuery,ViewDsTableFirstLast".
    oFmViewDsTable:displayFields = "ViewDsTable".
    oFmViewDsTable:fieldNameDeleteWarning = "ViewDsTable".

  
    oBrwViewDsField = NEW JBoxBrowse(brwViewFields:HANDLE,      /* handle to place-holder rectangle */
      YES,                       /* multiple-select? */ 
      "",                       /* title */
      NO,                       /* row-markers (if multiple) */
      BUFFER ttViewDsField:HANDLE).    /* The BUFFER ttCust.. parameter tells the browse that it is a local temp-table */
    
    oBrwViewDsField:buffersAndFields = "ttViewDsField;ViewDsFieldSeq;ViewDsFieldName;ViewDsTable;ViewDsFieldType;ViewDsFieldLabel;ViewDsFieldFormat;ViewDsFieldIndexed;ViewDsFieldFunction".
    oBrwViewDsField:setQuerySort("ViewDsFieldSeq").
    oBrwViewDsField:setParentQueryObject(oQryViewDs, "ViewDsId,SourceName").
    oBrwViewDsField:enabledColumns = "ViewDsFieldLabel,ViewDsFieldFormat".
    oBrwViewDsField:enableOnDblClick = YES.
    oBrwViewDsField:BROWSE-HANDLE:TOOLTIP = "Double-click to edit properties, right-click for functions".
        
    otbViewDsField = NEW JBoxToolbar(tbViewDsField:HANDLE).
    IF bSetExtraTools THEN RUN addExtraTools.
    IF bAddQueryBuilderTools THEN RUN addQueryBuilderTools.

    oBrwViewDsField:TOOLBAR-OBJECT = otbViewDsField.

    otbBrwViewDsField = NEW JBoxPopupMenu().
    otbBrwViewDsField:AddToolGroup('AddFields;Select fields¤enable,AddFunction;Add function,editFunction;Edit function'). //,DefLookup;Define filter table lookup,DefDropdown;Enter filter dropdown values').
    oBrwViewDsField:POPUP-MENU-OBJECT = otbBrwViewDsField.
  
    RUN InitializeComponents.
    oContainer:setAddResizeX("ViewDsTable,ViewDsTableFirstLast").
    oContainer:setSplitBarX(btnSplitBarX:HANDLE IN FRAME frSplitBarX).
    oContainer:setFollowSplitBarX(STRING(JBoxMsTreeView:HANDLE) + "," + STRING(brwViewFields:HANDLE) + "," + STRING(oBrwViewDsField:BROWSE-HANDLE)
      + "," + STRING(rsField:HANDLE) + "," + STRING(ViewDsTableQuery:HANDLE) + "," + STRING(ViewDsTableFirstLast:HANDLE)
      + "," + STRING(tbViewDsField:HANDLE)
      + "," + STRING(FRAME frSplitBarY:HANDLE) + "," + STRING(btnSplitBarY:HANDLE) + "," + STRING(ViewDsTable:HANDLE)
      + "," + otbViewDsField:buttonAndRuleWidgetList
    //  + "," + STRING(delete_tbViewDsField:HANDLE) + "," + STRING(movedown_tbViewDsField:HANDLE) + "," + STRING(moveup_tbViewDsField:HANDLE)      
      ).
    oContainer:setNoResizeX("JBoxMsTreeView,ViewDsTable,ViewDsTableFirstLast").
    oContainer:setNoResizeY("brwViewFields," + oBrwViewDsField:BROWSE-HANDLE:NAME).
    oContainer:setNoMoveY("frSplitBarY").
    
    oContainer:setAddMoveY("edit_tbViewDsTable,save_tbViewDsTable,undo_tbViewDsTable,delete_tbViewDsTable,ViewDsTableJoinType,ViewDsTableOuterJoin,ViewDsTableNotExist,ViewDsTable,ViewDsTableFirstLast").
    
    oContainer:setSplitBarY(btnSplitBarY:HANDLE IN FRAME frSplitBarY).
    oContainer:setFollowSplitBarY(STRING(brwViewFields:HANDLE) + "," + STRING(oBrwViewDsField:BROWSE-HANDLE) + "," + STRING(ViewDsTableQuery:HANDLE)).

    otbViewDsTable = NEW JBoxToolbar(tbViewDsTable:HANDLE).
  
    oQryViewDsTable:TOOLBAR-OBJECT = otbViewDsTable.
    oFmViewDsTable:TOOLBAR-OBJECT = otbViewDsTable.
    
    setQueries().

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE joinForDatasourceRecord C-Win 
PROCEDURE joinForDatasourceRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hMenuItem AS HANDLE NO-UNDO.

hMenuItem = otbViewDsField:getMenuItemHandle("joinForDataSource").

bJoinSameSource = hMenuItem:CHECKED.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadViewDs C-Win 
PROCEDURE LoadViewDs :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM icViewJsonFile AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocViewDsId     AS CHAR NO-UNDO.

hdsViewDs:READ-JSON ("file",icViewJsonFile).
FOR EACH ttViewDs:
  ttViewDs.ViewFileName = icViewJsonFile.
  ocViewDsId = ttViewDs.ViewDsId.
  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsTable.SourceName = ""
      :
    ASSIGN ttViewDsTable.SourceName = ttViewDs.SourceName
           ttViewDsTable.SourceType = ttViewDs.SourceType
           .    
  END.        
  FOR EACH ttViewDsField
      WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsField.SourceName = ""
      :
    ASSIGN ttViewDsField.SourceName = ttViewDs.SourceName
           ttViewDsField.SourceType = ttViewDs.SourceType
           .    
  END.        
END.
oQryViewDs:openQuery().
JBoxSession:Instance:setDelayedRun("focusFields", THIS-PROCEDURE).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE movedownRecord C-Win 
PROCEDURE movedownRecord :
DEF VAR rBuffer  AS ROWID NO-UNDO.
  DEF VAR iSeq     AS INT   NO-UNDO.
  DEF VAR iPrevSeq AS INT   NO-UNDO.
  
  DEF BUFFER bttFields FOR ttViewDsField.

  IF NOT AVAIL ttViewDsField THEN RETURN.

  IF oBrwViewDsField:BROWSE-HANDLE:NUM-SELECTED-ROWS > 1 THEN
    moveFlds("down").
  ELSE DO:
    ASSIGN rBuffer = ROWID(ttViewDsField)
           iSeq    = ttViewDsField.ViewDsFieldSeq.

    IF CAN-FIND(FIRST ttViewDsField WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId AND ttViewDsField.ViewDsFieldSeq GT iSeq) THEN 
       FOR EACH bttFields 
           WHERE bttFields.ViewDsId = ttViewDs.ViewDsId
             AND bttFields.ViewDsFieldSeq > iSeq BY bttFields.ViewDsFieldSeq
       :  
  
      ASSIGN iPrevSeq = bttFields.ViewDsFieldSeq
             bttFields.ViewDsFieldSeq = iSeq
             ttViewDsField.ViewDsFieldSeq = iPrevSeq
             .
    
      oBrwViewDsField:openQuery().
      oBrwViewDsField:BROWSE-HANDLE:SET-REPOSITIONED-ROW(oBrwViewDsField:BROWSE-HANDLE:DOWN,"conditional").
      oBrwViewDsField:QUERY-HANDLE:REPOSITION-TO-ROWID(rBuffer).
      oBrwViewDsField:BROWSE-HANDLE:SELECT-ROW(oBrwViewDsField:BROWSE-HANDLE:FOCUSED-ROW).
      oBrwViewDsField:displayRecord().
      LEAVE.
    END. 
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
  oJBoxMsTreeView:setVisible(YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE moveupRecord C-Win 
PROCEDURE moveupRecord :
DEF VAR rBuffer  AS ROWID NO-UNDO.
  DEF VAR iSeq     AS INT   NO-UNDO.
  DEF VAR iPrevSeq AS INT   NO-UNDO.

  DEF BUFFER bttFields FOR ttViewDsField.

  IF NOT AVAIL ttViewDsField THEN RETURN.

  IF oBrwViewDsField:BROWSE-HANDLE:NUM-SELECTED-ROWS > 1 THEN
    moveFlds("up").
  ELSE DO:
    ASSIGN rBuffer = ROWID(ttViewDsField)
           iSeq    = ttViewDsField.ViewDsFieldSeq.
  
    IF CAN-FIND(FIRST ttViewDsField WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId AND ttViewDsField.ViewDsFieldSeq LT iSeq) THEN 
       FOR EACH bttFields 
           WHERE bttFields.ViewDsId = ttViewDs.ViewDsId
             AND bttFields.ViewDsFieldSeq < iSeq BY bttFields.ViewDsFieldSeq DESC
       :  
  
      ASSIGN iPrevSeq = bttFields.ViewDsFieldSeq
             bttFields.ViewDsFieldSeq = iSeq
             ttViewDsField.ViewDsFieldSeq = iPrevSeq
             .
    
      oBrwViewDsField:openQuery().
      oBrwViewDsField:BROWSE-HANDLE:SET-REPOSITIONED-ROW(oBrwViewDsField:BROWSE-HANDLE:DOWN,"conditional").
      oBrwViewDsField:QUERY-HANDLE:REPOSITION-TO-ROWID(rBuffer).
      oBrwViewDsField:BROWSE-HANDLE:SELECT-ROW(oBrwViewDsField:BROWSE-HANDLE:FOCUSED-ROW).
      oBrwViewDsField:displayRecord().
      LEAVE.
    END. 
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myDatabrowseObject C-Win 
PROCEDURE myDatabrowseObject :
DEF INPUT PARAM ioDynDataBrowse AS JBoxDynDataBrowse NO-UNDO.

DEF VAR cSqlDb            AS CHAR NO-UNDO.
DEF VAR hDsView           AS HANDLE NO-UNDO.
DEF VAR cJboxPrescan      AS CHAR NO-UNDO.
DEF VAR cPrescanTableList AS CHAR NO-UNDO.
DEF VAR ix                AS INT NO-UNDO.

cSqlDb = getSqlDb().
IF cSqlDb = ? THEN RETURN.

// must be set prior to initialization:
ioDynDataBrowse:ViewDsId = ttViewDs.ViewDsId.
/*ioDynDataBrowse:EnableSaveQuery = YES.                 */
/*ioDynDataBrowse:userSettingContext = "JBoxViewDsDef.w".*/
ioDynDataBrowse:QueryCanBeScheduled = NO. 
ioDynDataBrowse:QueryCanBeShared = NO.

hDsView = getViewDsHandle().
ioDynDataBrowse:hViewDsUserSetting = hDsView:GET-BUFFER-HANDLE (4). 

IF VALID-HANDLE(hDsTempDataView) THEN
  ioDynDatabrowse:InitializeQuery(hDsTempDataView).
ELSE IF VALID-HANDLE(ttViewDs.hTempTable) THEN 
  ioDynDatabrowse:InitializeQuery(ttViewDs.hTempTable).
ELSE IF cSqlDb = "" THEN DO:
  DYNAMIC-FUNCTION("setActiveASconnection",ttViewDs.SourceName).  

  ioDynDataBrowse:InitializeQuery(
      getBuffersAndFields(YES)
     ,getQueryJoin("","")
     ,getSortColumn()  
     ,FALSE /* <- do record count */
     ).
END.     
ELSE DO:     
  JBoxSchemaCache:Instance:setUseDefaultConnection().
  ioDynDataBrowse:InitializeQuery(
      getBuffersAndFields(YES)
     ,getQueryJoin("","")
     ,getSortColumn()  
     ,ttViewDs.SourceType NE "ProgressSql" /* <- do record count */
     ,ttViewDs.SourceName + "." + cSqlDb /* reference to sql database, ie parameter for jbserv_get_sql_data.p */     
      ).
END.     

setDropDownDefinitions(ioDynDataBrowse:BROWSE-OBJECT).
setLookupDefinitions(ioDynDataBrowse:BROWSE-OBJECT).

ioDynDataBrowse:setViewDsUserQueryMenu().

ioDynDataBrowse:BROWSE-OBJECT:setJBoxAttribute("DataSourceName",ttViewDs.SourceName).
  
ioDynDataBrowse:BROWSE-OBJECT:baseQuery = getBaseQuery().

IF cSqlDb = "" THEN DO:
  DYNAMIC-FUNCTION("setActiveASconnection",ttViewDs.SourceName).
  cJboxPrescan = getPrescanQueries("").
  IF cJboxPrescan NE "" THEN DO:
    ASSIGN cPrescanTableList = ENTRY(1,cJboxPrescan,"¤")
           cJboxPrescan = ENTRY(2,cJboxPrescan,"¤"). 
    DO ix = 1 TO NUM-ENTRIES(cPrescanTableList):
      ioDynDataBrowse:BROWSE-OBJECT:setPreScanQuery(ENTRY(ix,cPrescanTableList),ENTRY(ix,cJboxPrescan,"|")).
    END.
    ioDynDataBrowse:BROWSE-OBJECT:altPrimaryBufferList = getAltPrimaryBuffers().
  END.  
  ioDynDataBrowse:BROWSE-OBJECT:queryStopAfter = 30.
END.    
ELSE DO:
  ioDynDataBrowse:BROWSE-OBJECT:queryStopAfter = 10.
  ioDynDataBrowse:BROWSE-OBJECT:prescanBaseQuery = getSqlSubQueries("","").
END.  

ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addSubMenu("Export").
ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addTool("ToCsv","To Csv file","Export").
ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addTool("ToJson","To Json file","Export").
ioDynDataBrowse:BROWSE-OBJECT:POPUP-MENU-OBJECT:addTool("ToXml","To XML file","Export").

ioDynDataBrowse:BROWSE-OBJECT:openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myLookupObject C-Win 
PROCEDURE myLookupObject :
DEF INPUT PARAM ioLookup AS JBoxDynLookup NO-UNDO.

BuildTableLookup(iCurrDbNum,cCurrTable).

oLookup = ioLookup.

IF CAN-FIND(FIRST ttTableLookup WHERE ttTableLookup.MatchType = "Key") THEN DO:
  ioLookup:TOOLBAR-OBJECT:addTool("Filter").
  ioLookup:TOOLBAR-OBJECT:addTool("DelFilter","Clear filter","gif/filterd.gif").
  ioLookup:BROWSE-OBJECT:setFilter("MatchType","=","Key").
  ioLookup:BROWSE-OBJECT:setQuerySort("FieldMatch;desc,TableName").
END.  
ELSE IF CAN-FIND(FIRST ttTableLookup WHERE ttTableLookup.MatchType = "Name/Idx") THEN DO:
  ioLookup:TOOLBAR-OBJECT:addTool("Filter").
  ioLookup:TOOLBAR-OBJECT:addTool("DelFilter","Clear filter","gif/filterd.gif").
  ioLookup:BROWSE-OBJECT:setFilter("MatchType","=","Name/Idx").
  ioLookup:BROWSE-OBJECT:setQuerySort("FieldMatch;desc,TableName").
END.  
ELSE DO:
  ioLookup:ExpandSearchDialogY(400).
  ioLookup:BROWSE-OBJECT:setQuerySort("TableName").
END.  

ioLookup:BROWSE-OBJECT:setFilterDropDownList("MatchType", "Key|Key|Name/Idx|Name/Idx").

ioLookup:BROWSE-OBJECT:openQuery().


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mySelectorObject C-Win 
PROCEDURE mySelectorObject :
DEF INPUT PARAM ioSelector AS JBoxDynSelector NO-UNDO.

DEF VAR cSelectedRows AS CHAR   NO-UNDO.
DEF VAR hSrcBuff      AS HANDLE NO-UNDO.
DEF VAR hTargetBuff   AS HANDLE NO-UNDO.
DEF VAR cTableList    AS CHAR   NO-UNDO.
DEF VAR cSelectedFlds AS CHAR   NO-UNDO.
DEF VAR cLookupTable  AS CHAR   NO-UNDO.

DEF VAR ix AS INT NO-UNDO.
DEF VAR iy AS INT NO-UNDO.
DEF VAR iz AS INT NO-UNDO.

DEF BUFFER ttViewDsField FOR ttViewDsField.

ASSIGN hSrcBuff    = ioSelector:SOURCE-BROWSE-OBJECT:BUFFER-HANDLE
       hTargetBuff = ioSelector:TARGET-BROWSE-OBJECT:BUFFER-HANDLE
       .

ioSelector:SOURCE-BROWSE-OBJECT:baseQuery = "WHERE TRUE".
ioSelector:SOURCE-BROWSE-OBJECT:useLocalData = YES.
ioSelector:TARGET-BROWSE-OBJECT:useLocalData = YES.

IF cFilterLookupTblFld NE "" THEN DO:
  ioSelector:SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:GET-BROWSE-COLUMN(2):VISIBLE = NO.
  ioSelector:TARGET-BROWSE-OBJECT:BROWSE-HANDLE:GET-BROWSE-COLUMN(2):VISIBLE = NO.
  IF NUM-ENTRIES(cFilterLookupTblFld,";") > 1 THEN
    cSelectedFlds = REPLACE(SUBSTR(cFilterLookupTblFld,INDEX(cFilterLookupTblFld,";") + 1),";",",").
  cLookupTable = ENTRY(1,cFilterLookupTblFld,";").
  cFilterLookupTblFld = "".  
  FOR FIRST tt_db
      WHERE tt_db.cSourceName = cCurrSourceName
        AND tt_db.iDbNum = iCurrDbNum
     ,EACH tt_file
            WHERE tt_file.iDbNum = tt_db.iDbNum
              AND tt_file.cFile-Name = cLookupTable
     ,EACH tt_field
            WHERE tt_field.iFileNum = tt_file.iFileNum
      BY tt_field.iOrder:

    cFilterLookupTblFld = cFilterLookupTblFld + (IF cFilterLookupTblFld NE "" THEN "," ELSE "") + tt_field.cField-Name.

    IF tt_field.iExtent = 0 THEN DO:
      hSrcBuff:BUFFER-CREATE().
      ASSIGN hSrcBuff::FieldName    = tt_field.cField-Name
             hSrcBuff::TableName    = cLookupTable
             hSrcBuff::Db           = tt_db.cLDBname
             hSrcBuff::FieldType    = tt_field.cData-Type
             hSrcBuff::FieldFormat  = tt_field.cFormat
             hSrcBuff::FieldLabel   = tt_field.cLabel
             hSrcBuff::FieldIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,cCurrTable,tt_db.cLDBname,ttViewDs.SourceName)
             ix = ix + 1
             hSrcBuff::RowIdent1   = STRING(ix,"999")
             .
  
      IF CAN-DO(cSelectedFlds,tt_field.cField-Name) THEN DO:
        cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
        hTargetBuff:BUFFER-CREATE().
        ASSIGN hTargetBuff::iJBoxSelectIndex = LOOKUP(tt_field.cField-Name,cSelectedFlds)
               hTargetBuff::FieldName    = tt_field.cField-Name
               hTargetBuff::TableName    = cLookupTable
               hTargetBuff::Db           = tt_db.cLDBname
               hTargetBuff::FieldType    = tt_field.cData-Type
               hTargetBuff::FieldFormat  = tt_field.cFormat
               hTargetBuff::FieldLabel   = tt_field.cLabel
               hTargetBuff::FieldIndexed = hSrcBuff::FieldIndexed 
               hTargetBuff::RowIdent1    = STRING(ix,"999")
               .
      END.
    END.
    ELSE DO iz = 1 TO tt_field.iExtent:
      hSrcBuff:BUFFER-CREATE().
      ASSIGN hSrcBuff::FieldName    = tt_field.cField-Name + "[" + STRING(iz) + "]"
             hSrcBuff::TableName    = cLookupTable
             hSrcBuff::Db           = tt_db.cLDBname
             hSrcBuff::FieldType    = tt_field.cData-Type
             hSrcBuff::FieldFormat  = tt_field.cFormat
             hSrcBuff::FieldLabel   = tt_field.cLabel + "[" + STRING(iz) + "]"
             hSrcBuff::FieldIndexed = NO
             ix = ix + 1
             hSrcBuff::RowIdent1   = STRING(ix,"999")
             .
  
      IF CAN-DO(cSelectedFlds,hSrcBuff::FieldName) THEN DO:
        cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
        hTargetBuff:BUFFER-CREATE().
        ASSIGN hTargetBuff::iJBoxSelectIndex = LOOKUP(hSrcBuff::FieldName,cSelectedFlds)
               hTargetBuff::FieldName    = hSrcBuff::FieldName
               hTargetBuff::TableName    = cLookupTable
               hTargetBuff::Db           = tt_db.cLDBname
               hTargetBuff::FieldType    = tt_field.cData-Type
               hTargetBuff::FieldFormat  = tt_field.cFormat
               hTargetBuff::FieldLabel   = tt_field.cLabel + "[" + STRING(iz) + "]"
               hTargetBuff::FieldIndexed = hSrcBuff::FieldIndexed 
               hTargetBuff::RowIdent1    = STRING(ix,"999")
               .
      END.
    END.          
  END.
END.
ELSE IF bShowTable THEN DO: 
  ioSelector:ExpandSelectorDialogX(380).
  ioSelector:SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:GET-BROWSE-COLUMN(2):VISIBLE = NO.
  ioSelector:TARGET-BROWSE-OBJECT:BROWSE-HANDLE:GET-BROWSE-COLUMN(2):VISIBLE = NO.
    
  FOR FIRST tt_db
      WHERE tt_db.cSourceName = cCurrSourceName
        AND tt_db.iDbNum = iCurrDbNum
     ,EACH tt_file
            WHERE tt_file.iDbNum = tt_db.iDbNum
              AND tt_file.cFile-Name = RealTable(cCurrTable)
     ,EACH tt_field
            WHERE tt_field.iFileNum = tt_file.iFileNum
      BY tt_field.iOrder:

    IF tt_field.iExtent = 0 THEN DO:
      FIND FIRST ttViewDsField 
           WHERE ttViewDsField.ViewDsId        = ttViewDs.ViewDsId
             AND ttViewDsField.ViewDsDb        = cCurrDb
             AND ttViewDsField.ViewDsTable     = cCurrTable
             AND ttViewDsField.ViewDsFieldName = tt_field.cField-Name
           NO-ERROR.
      hSrcBuff:BUFFER-CREATE().
      ASSIGN hSrcBuff::FieldName    = tt_field.cField-Name
             hSrcBuff::TableName    = cCurrTable
             hSrcBuff::Db           = tt_db.cLDBname
             hSrcBuff::FieldType    = tt_field.cData-Type
             hSrcBuff::FieldFormat  = tt_field.cFormat
             hSrcBuff::FieldLabel   = tt_field.cLabel
             hSrcBuff::FieldIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,cCurrTable,tt_db.cLDBname,ttViewDs.SourceName)
             ix = ix + 1
             hSrcBuff::RowIdent1   = STRING(ix,"999")
             .
  
      IF AVAIL ttViewDsField THEN DO:
        cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
        hTargetBuff:BUFFER-CREATE().
        ASSIGN hTargetBuff::iJBoxSelectIndex = ttViewDsField.ViewDsFieldSeq
               hTargetBuff::FieldName    = tt_field.cField-Name
               hTargetBuff::TableName    = cCurrTable
               hTargetBuff::Db           = tt_db.cLDBname
               hTargetBuff::FieldType    = tt_field.cData-Type
               hTargetBuff::FieldFormat  = tt_field.cFormat
               hTargetBuff::FieldLabel   = tt_field.cLabel
               hTargetBuff::FieldIndexed = hSrcBuff::FieldIndexed 
               hTargetBuff::RowIdent1    = STRING(ix,"999")
               .
      END.
    END.
    ELSE DO iz = 1 TO tt_field.iExtent:
      FIND FIRST ttViewDsField 
           WHERE ttViewDsField.ViewDsId        = ttViewDs.ViewDsId
             AND ttViewDsField.ViewDsDb        = cCurrDb
             AND ttViewDsField.ViewDsTable     = cCurrTable
             AND ttViewDsField.ViewDsFieldName = tt_field.cField-Name + "[" + STRING(iz) + "]"
           NO-ERROR.
      hSrcBuff:BUFFER-CREATE().
      ASSIGN hSrcBuff::FieldName    = tt_field.cField-Name + "[" + STRING(iz) + "]"
             hSrcBuff::TableName    = cCurrTable
             hSrcBuff::Db           = tt_db.cLDBname
             hSrcBuff::FieldType    = tt_field.cData-Type
             hSrcBuff::FieldFormat  = tt_field.cFormat
             hSrcBuff::FieldLabel   = tt_field.cLabel + "[" + STRING(iz) + "]"
             hSrcBuff::FieldIndexed = NO
             ix = ix + 1
             hSrcBuff::RowIdent1   = STRING(ix,"999")
             .
  
      IF AVAIL ttViewDsField THEN DO:
        cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
        hTargetBuff:BUFFER-CREATE().
        ASSIGN hTargetBuff::iJBoxSelectIndex = ttViewDsField.ViewDsFieldSeq
               hTargetBuff::FieldName    = tt_field.cField-Name + "[" + STRING(iz) + "]"
               hTargetBuff::TableName    = cCurrTable
               hTargetBuff::Db           = tt_db.cLDBname
               hTargetBuff::FieldType    = tt_field.cData-Type
               hTargetBuff::FieldFormat  = tt_field.cFormat
               hTargetBuff::FieldLabel   = tt_field.cLabel + "[" + STRING(iz) + "]"
               hTargetBuff::FieldIndexed = hSrcBuff::FieldIndexed 
               hTargetBuff::RowIdent1    = STRING(ix,"999")
               .
      END.
    END.
  END.
  FOR EACH ttViewDsField
      WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsField.ViewDsTable = cCurrTable
        AND ttViewDsField.ViewDsFieldFunction NE ""
        AND NOT ttViewDsField.ViewDsFieldFunction BEGINS "filter"
    :
    hSrcBuff:BUFFER-CREATE().
    ASSIGN hSrcBuff::FieldName   = ttViewDsField.ViewDsFieldName
           hSrcBuff::TableName   = cCurrTable
           hSrcBuff::FieldType   = ttViewDsField.ViewDsFieldType
           hSrcBuff::FieldFormat = ttViewDsField.ViewDsFieldType
           hSrcBuff::FieldLabel  = ttViewDsField.ViewDsFieldLabel
           hSrcBuff::Db          = cCurrDb
           ix = ix + 1
           hSrcBuff::RowIdent1   = STRING(ix,"999")
           .

    cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
    hTargetBuff:BUFFER-CREATE().
    ASSIGN hTargetBuff::iJBoxSelectIndex = ttViewDsField.ViewDsFieldSeq
           hTargetBuff::FieldName   = ttViewDsField.ViewDsFieldName
           hTargetBuff::TableName   = cCurrTable
           hTargetBuff::Db          = cCurrDb
           hTargetBuff::FieldType   = ttViewDsField.ViewDsFieldType
           hTargetBuff::FieldFormat = ttViewDsField.ViewDsFieldType
           hTargetBuff::FieldLabel  = ttViewDsField.ViewDsFieldLabel
           hTargetBuff::RowIdent1   = STRING(ix,"999")
           .
  END.    
END.
ELSE DO:
  ioSelector:ExpandSelectorDialogX(500).
  cTableList = ttViewDs.BaseTable + ";" + ttViewDs.BaseDb.
  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
      :
    cTableList = cTableList + "," + ttViewDsTable.ViewDsTable + ";" + ttViewDsTable.ViewDsDb.    
  END.      
  DO iy = 1 TO NUM-ENTRIES(cTableList):
    FOR EACH tt_db
        WHERE tt_db.cSourceName = ttViewDs.SourceName
       ,EACH tt_file
              WHERE tt_file.iDbNum = tt_db.iDbNum 
                AND tt_file.cLDBname = ENTRY(2,ENTRY(iy,cTableList),";")
                AND tt_file.cFile-Name = RealTable(ENTRY(1,ENTRY(iy,cTableList),";"))
       ,EACH tt_field
              WHERE tt_field.iFileNum = tt_file.iFileNum
        BY tt_field.iOrder:

      IF tt_field.iExtent = 0 THEN DO:
        FIND FIRST ttViewDsField 
             WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
               AND ttViewDsField.ViewDsTable = ENTRY(1,ENTRY(iy,cTableList),";")
               AND ttViewDsField.ViewDsFieldName = tt_field.cField-Name
             NO-ERROR.
             
        hSrcBuff:BUFFER-CREATE().
        ASSIGN hSrcBuff::FieldName    = tt_field.cField-Name
               hSrcBuff::TableName    = ENTRY(1,ENTRY(iy,cTableList),";")
               hSrcBuff::Db           = tt_db.cLDBname
               hSrcBuff::FieldType    = tt_field.cData-Type
               hSrcBuff::FieldFormat  = tt_field.cFormat
               hSrcBuff::FieldLabel   = tt_field.cLabel
               hSrcBuff::FieldIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,hSrcBuff::TableName,tt_db.cLDBname,ttViewDs.SourceName)
               ix = ix + 1
               hSrcBuff::RowIdent1   = STRING(ix,"999")
               .
    
        IF AVAIL ttViewDsField THEN DO:
          cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
          hTargetBuff:BUFFER-CREATE().
          ASSIGN hTargetBuff::iJBoxSelectIndex = ttViewDsField.ViewDsFieldSeq
                 hTargetBuff::FieldName   = tt_field.cField-Name
                 hTargetBuff::TableName   = ENTRY(1,ENTRY(iy,cTableList),";")
                 hTargetBuff::Db          = tt_file.cLDBname
                 hTargetBuff::FieldType   = tt_field.cData-Type
                 hTargetBuff::FieldFormat = tt_field.cFormat
                 hTargetBuff::FieldLabel  = tt_field.cLabel
                 hTargetBuff::FieldIndexed = hSrcBuff::FieldIndexed 
                 hTargetBuff::RowIdent1   = STRING(ix,"999")
                 .
        END.
      END.  
      ELSE DO iz = 1 TO tt_field.iExtent:
        FIND FIRST ttViewDsField 
             WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
               AND ttViewDsField.ViewDsTable = ENTRY(1,ENTRY(iy,cTableList),";")
               AND ttViewDsField.ViewDsFieldName = tt_field.cField-Name + "[" + STRING(iz) + "]"
             NO-ERROR.
             
        hSrcBuff:BUFFER-CREATE().
        ASSIGN hSrcBuff::FieldName    = tt_field.cField-Name + "[" + STRING(iz) + "]"
               hSrcBuff::TableName    = ENTRY(1,ENTRY(iy,cTableList),";")
               hSrcBuff::Db           = tt_file.cLDBname
               hSrcBuff::FieldType    = tt_field.cData-Type
               hSrcBuff::FieldFormat  = tt_field.cFormat
               hSrcBuff::FieldLabel   = tt_field.cLabel + "[" + STRING(iz) + "]"
               hSrcBuff::FieldIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,hSrcBuff::TableName,tt_db.cLDBname,ttViewDs.SourceName)
               ix = ix + 1
               hSrcBuff::RowIdent1   = STRING(ix,"999")
               .
    
        IF AVAIL ttViewDsField THEN DO:
          cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
          hTargetBuff:BUFFER-CREATE().
          ASSIGN hTargetBuff::iJBoxSelectIndex = ttViewDsField.ViewDsFieldSeq
                 hTargetBuff::FieldName   = tt_field.cField-Name + "[" + STRING(iz) + "]"
                 hTargetBuff::TableName   = ENTRY(1,ENTRY(iy,cTableList),";")
                 hTargetBuff::Db          = tt_file.cLDBname
                 hTargetBuff::FieldType   = tt_field.cData-Type
                 hTargetBuff::FieldFormat = tt_field.cFormat
                 hTargetBuff::FieldLabel  = tt_field.cLabel + "[" + STRING(iz) + "]"
                 hTargetBuff::FieldIndexed = hSrcBuff::FieldIndexed 
                 hTargetBuff::RowIdent1   = STRING(ix,"999")
                 .
        END.
      END.  
    END.
    FOR EACH ttViewDsField
        WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
          AND ttViewDsField.ViewDsTable = ENTRY(1,ENTRY(iy,cTableList),";")
          AND ttViewDsField.ViewDsFieldFunction NE ""
      :
      hSrcBuff:BUFFER-CREATE().
      ASSIGN hSrcBuff::FieldName   = ttViewDsField.ViewDsFieldName
             hSrcBuff::TableName   = ENTRY(1,ENTRY(iy,cTableList),";")
             hSrcBuff::Db          = cCurrDb
             hSrcBuff::FieldType   = ttViewDsField.ViewDsFieldType
             hSrcBuff::FieldFormat = ttViewDsField.ViewDsFieldType
             hSrcBuff::FieldLabel  = ttViewDsField.ViewDsFieldLabel
             ix = ix + 1
             hSrcBuff::RowIdent1   = STRING(ix,"999")
             .

      cSelectedRows = cSelectedRows + (IF cSelectedRows NE "" THEN "," ELSE "") + STRING(ix,"999").
      hTargetBuff:BUFFER-CREATE().
      ASSIGN hTargetBuff::iJBoxSelectIndex = ttViewDsField.ViewDsFieldSeq
             hTargetBuff::FieldName   = ttViewDsField.ViewDsFieldName
             hTargetBuff::TableName   = ENTRY(1,ENTRY(iy,cTableList),";")
             hTargetBuff::Db          = cCurrDb
             hTargetBuff::FieldType   = ttViewDsField.ViewDsFieldType
             hTargetBuff::FieldFormat = ttViewDsField.ViewDsFieldType
             hTargetBuff::FieldLabel  = ttViewDsField.ViewDsFieldLabel
             hTargetBuff::RowIdent1   = STRING(ix,"999")
             .
    END.    
  END.  
END.

IF ix > 18 THEN
  ioSelector:ExpandSelectorDialogY(MIN(45,ix - 18) * 10).
  
ioSelector:setSelectedRowidList(cSelectedRows).
ioSelector:SOURCE-BROWSE-OBJECT:setQuerySort("FieldName").   
ioSelector:TARGET-BROWSE-OBJECT:setQuerySort("iJBoxSelectIndex").   
ioSelector:OpenQuerySource().
ioSelector:OpenQueryTarget().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQuery C-Win 
PROCEDURE OpenQuery :
RUN SUPER.

  IF oQryViewDs:IsCurrent THEN DO WITH FRAME {&FRAME-NAME}:  
    oJBoxMsTreeView:clearNodes().
    IF AVAIL ttViewDs THEN DO:
      ASSIGN cCurrDb = ttViewDs.BaseDb
             cCurrTable = ttViewDs.BaseTable
             cCurrViewId = ttViewDs.ViewDsId
             oBrwViewDsField:baseQuery = "WHERE ViewDsId = '" + ttViewDs.ViewDsId + "'"
             ViewDsTableQuery:SCREEN-VALUE = ttViewDs.BaseQuery
             ViewDsTable:SCREEN-VALUE = ttViewDs.BaseTable
             ViewDsTableJoinType:SCREEN-VALUE = "EACH".
             .
      setCurrDbNum(cCurrDb,ttViewDs.SourceName).       
       
      oJBoxMsTreeView:AddNode("",ttViewDs.ViewDsId + "." + ttViewDs.BaseDb + "." + ttViewDs.BaseTable,ttViewDs.BaseDb + "." + ttViewDs.BaseTable,"BaseTable",0,1).
      FillTreeChildNodes(ttViewDs.ViewDsId,ttViewDs.BaseDb,ttViewDs.BaseTable).
          
      oJBoxMsTreeView:AddContextMenuStrip("",
        "BaseTable" /* The menu is added to nodes of type "Produkt" */
        ).
    
      oJBoxMsTreeView:AddContextMenuItem("BaseTable",
        "",
        "AddToBaseTable", /* Procedure to call when menu item is selected */  
        "Add table", /* Text */
        "ico\bullet_ball_yellow.ico"). 

      oJBoxMsTreeView:AddContextMenuItem("BaseTable",
        "",
        "setBaseQuery", /* Procedure to call when menu item is selected */  
        "Set base query", /* Text */
        "ico\bullet_ball_red.ico"). 

      oJBoxMsTreeView:AddContextMenuItem("BaseTable",
                                         "",
                                         "AddFieldsToBaseTable", /* Procedure to call when menu item is selected */
                                         "Select fields", /* Text */
                                         "ico\bullet_ball_green.ico").
    
      oJBoxMsTreeView:AddContextMenuStrip("",
        "Table" /* The menu is added to nodes of type "Produkt" */
        ).
    
      oJBoxMsTreeView:AddContextMenuItem("Table",
        "",
        "AddTable", /* Procedure to call when menu item is selected */  
        "Add table", /* Text */
        "ico\bullet_ball_yellow.ico"). 
      
      oJBoxMsTreeView:AddContextMenuItem("Table",
                                         "",
                                         "AddFields", /* Procedure to call when menu item is selected */
                                         "Select fields", /* Text */
                                         "ico\bullet_ball_green.ico").
      
      oJBoxMsTreeView:ExpandNodes("").
      oJBoxMsTreeView:SelectNode(ttViewDs.ViewDsId + "." + ttViewDs.BaseDb + "." + ttViewDs.BaseTable).
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReBuildTablesFromText C-Win 
PROCEDURE ReBuildTablesFromText :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icBuffsAndFlds       AS CHAR NO-UNDO.
DEF INPUT PARAM icQueryString        AS CHAR NO-UNDO.
DEF INPUT PARAM icBuffAndFldListType AS CHAR NO-UNDO.

DEF VAR ix          AS INT  NO-UNDO.
DEF VAR iy          AS INT  NO-UNDO.
DEF VAR cBufferDef  AS CHAR NO-UNDO.
DEF VAR cJoinDef    AS CHAR NO-UNDO.
DEF VAR cFieldDef   AS CHAR NO-UNDO.
DEF VAR cParenDbTbl AS CHAR NO-UNDO.
DEF VAR cElement    AS CHAR NO-UNDO.
DEF VAR cDbTable    AS CHAR NO-UNDO.
DEF VAR cParentList AS CHAR NO-UNDO.
DEF VAR cLabel      AS CHAR NO-UNDO.
DEF VAR cFormat     AS CHAR NO-UNDO.
DEF VAR iSeq        AS INT  NO-UNDO.

DEF BUFFER tt_db FOR tt_db.

/*MESSAGE 123       */
/*VIEW-AS ALERT-BOX.*/
DO ix = 1 TO NUM-ENTRIES(icBuffsAndFlds):
  ASSIGN cBufferDef = ENTRY(ix,icBuffsAndFlds)
         cJoinDef   = TRIM(ENTRY(ix,icQueryString))
         .
  REPEAT WHILE INDEX(cJoinDef,"  ") > 0:
    cJoinDef = REPLACE(cJoinDef,"  "," ").
  END.       
  IF ix = 1 THEN DO: 
    FIND FIRST tt_db
         WHERE tt_db.cLDBname = ENTRY(1,ENTRY(1,cBufferDef,";"),".")
         NO-ERROR.
    IF NOT AVAIL tt_db THEN DO:
      MESSAGE "Schema not loaded for database " ENTRY(1,ENTRY(1,cBufferDef,";"),".")
      VIEW-AS ALERT-BOX.
      RETURN.
    END.       

    CREATE ttViewDs.
    ASSIGn ttViewDs.SourceName   = tt_db.cSourceName
           ttViewDs.BaseDb       = tt_db.cLDBname
           ttViewDs.BaseTable    = ENTRY(2,ENTRY(1,cBufferDef,";"),".")
           ttViewDs.ViewDsId     = GUID
           ttViewDs.ViewDsName   = "RebuildQuery"
           cParentList           = ENTRY(1,cBufferDef,";")
           cCurrDb               = ttViewDs.BaseDb
           cCurrTable            = ttViewDs.BaseTable
           cCurrViewId           = ttViewDs.ViewDsId
           .
    setCurrDbNum(cCurrDb,ttViewDs.SourceName).
           
  END.  
  ELSE DO:
    DO iy = 1 TO NUM-ENTRIES(cParentList):
      cParenDbTbl = getRelTableFromJoin(ENTRY(iy,cParentList),"parent",cJoinDef).
      IF cParenDbTbl NE "" THEN DO:
        IF NOT CAN-DO(cParentList,cParenDbTbl) THEN
          cParentList = cParentList + "," + cParenDbTbl.
        LEAVE.
      END.  
    END.  
    cDbTable = getRelTableFromJoin(cParenDbTbl,"child",cJoinDef).
    CREATE ttViewDsTable.
    ASSIGN ttViewDsTable.ViewDsId          = ttViewDs.ViewDsId
           ttViewDsTable.SourceName        = ttViewDs.SourceName
           ttViewDsTable.ViewDsParentDb    = ENTRY(1,cParenDbTbl,".")
           ttViewDsTable.ViewDsParentTable = ENTRY(2,cParenDbTbl,".")
           ttViewDsTable.ViewDsDb          = ENTRY(1,cDbTable,".")
           ttViewDsTable.ViewDsTable       = ENTRY(2,cDbTable,".")
           ttViewDsTable.queryJoin         = REPLACE(cJoinDef,"AND",CHR(10))
           .
    DO iy = 1 TO NUM-ENTRIES(cJoinDef," "):
      cElement = ENTRY(iy,cJoinDef," ").
      CASE cElement:
        WHEN "FIRST" OR WHEN "EACH" OR WHEN "LAST" THEN ttViewDsTable.ViewDsTableJoinType = cElement.
        WHEN "OUTER-JOIN" THEN ttViewDsTable.ViewDsTableOuterJoin = YES.
        WHEN "NO-LOCK" OR WHEN "WHERE" THEN .
        WHEN "AND" THEN ttViewDsTable.ViewDsTableQuery = ttViewDsTable.ViewDsTableQuery + CHR(10).
        OTHERWISE DO:
          IF iy > 2 THEN
            ttViewDsTable.ViewDsTableQuery = ttViewDsTable.ViewDsTableQuery + " " + cElement.
        END.   
      END CASE. 
    END.        
    ttViewDsTable.ViewDsTableQuery = TRIM(ttViewDsTable.ViewDsTableQuery). 
  END.
  DO iy = 2 TO NUM-ENTRIES(cBufferDef,";"):
    ASSIGN cFieldDef = ENTRY(iy,cBufferDef,";")
           cLabel    = ""
           cFormat   = "".
    IF NUM-ENTRIES(cFieldDef,"@") > 1 THEN
      ASSIGN iSeq = INT(ENTRY(2,cFieldDef,"@"))
             cFieldDef = ENTRY(1,cFieldDef,"@").
    ELSE iSeq = iy - 1.                
           
    IF icBuffAndFldListType NE "drop-down" THEN DO:
      IF NUM-ENTRIES(cFieldDef,"|") > 1 THEN cLabel  = ENTRY(2,cFieldDef,"|").   
      IF NUM-ENTRIES(cFieldDef,"|") > 2 THEN cFormat = ENTRY(3,cFieldDef,"|").   
    END.
    
    CREATE ttViewDsField.
    ASSIGN ttViewDsField.ViewDsId        = ttViewDs.ViewDsId 
           ttViewDsField.ViewDsDb        = IF ix = 1 THEN ttViewDs.BaseDb ELSE ttViewDsTable.ViewDsDb
           ttViewDsField.ViewDsTable     = IF ix = 1 THEN ttViewDs.BaseTable ELSE ttViewDsTable.ViewDsTable
           ttViewDsField.ViewDsFieldName = ENTRY(1,cFieldDef,"|")
           ttViewDsField.ViewDsFieldSeq  = iSeq
           .
    FOR EACH tt_file
        WHERE tt_file.iDbNum = tt_db.iDbNum
          AND tt_file.cFile-Name = (IF ix = 1 THEN ttViewDs.BaseTable ELSE ttViewDsTable.ViewDsTable)
       ,EACH tt_field
             WHERE tt_field.iFileNum    = tt_file.iFileNum
               AND tt_field.cField-Name = ttViewDsField.ViewDsFieldName
       :
      ASSIGN ttViewDsField.ViewDsFieldType = tt_field.cData-Type   
             ttViewDsField.ViewDsFieldLabel = IF cLabel = "" THEN tt_field.cLabel ELSE cLabel
             ttViewDsField.ViewDsFieldFormat = IF cFormat = "" THEN tt_field.cFormat ELSE cFormat
             ttViewDsField.ViewDsFieldIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(
                                                ttViewDsField.ViewDsFieldName,
                                                IF ix = 1 THEN ttViewDs.BaseTable ELSE ttViewDsTable.ViewDsTable,
                                                IF ix = 1 THEN ttViewDs.BaseDb ELSE ttViewDsTable.ViewDsDb,
                                                ttViewDs.SourceName).
    END.                       
  END.  
  
END.
oQryViewDs:openQuery().

CATCH eErr AS Progress.Lang.Error :
  MESSAGE PROGRAM-NAME(1) SKIP eErr:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RefreshSchemaDataSet C-Win 
PROCEDURE RefreshSchemaDataSet :
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEF INPUT PARAM ihDataSet  AS HANDLE NO-UNDO.

/*  hdsSchema:EMPTY-DATASET ().        */
/*  hdsSchema:COPY-DATASET (ihDataSet).*/

  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RefreshViewTempTable C-Win 
PROCEDURE RefreshViewTempTable :
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEF INPUT PARAM ihTempTable    AS HANDLE NO-UNDO.
  DEF INPUT PARAM icCurrViewDsId AS CHAR   NO-UNDO.
  DEF INPUT PARAM ibNew          AS LOG    NO-UNDO.

  hdsViewDs:GET-BUFFER-HANDLE (1):EMPTY-TEMP-TABLE ().
  hdsViewDs:GET-BUFFER-HANDLE (1):COPY-TEMP-TABLE (ihTempTable,NO,YES,YES).
  FIND FIRST ttViewDs WHERE ttViewDs.ViewDsId = icCurrViewDsId NO-ERROR.

  IF AVAIL ttViewDs THEN DO:
    ASSIGN cCurrDb     = ttViewDs.BaseDb
           cCurrTable  = ttViewDs.BaseTable
           cCurrViewId = ttViewDs.ViewDsId
           .
    setCurrDbNum(cCurrDb,ttViewDs.SourceName).
    IF ibNew THEN        
      otbBrwViewDsField:applyTool("addfields").
    
    oQryViewDs:openQuery().
  END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
DEF VAR cError     AS CHAR NO-UNDO.
DEF VAR cJoinCrit  AS CHAR NO-UNDO.
DEF VAR ix         AS INT  NO-UNDO.
DEF VAR cDbTblList AS CHAR NO-UNDO.
DEF VAR cModJoin   AS CHAR NO-UNDO.
DEF VAR cDbAndTbl  AS CHAR NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    cJoinCrit = getJoinCritRev(ViewDsTableQuery:SCREEN-VALUE).
    REPEAT WHILE INDEX("  ",cJoinCrit) > 0:
      cJoinCrit = REPLACE(cJoinCrit,"  "," ").
    END.
    DO ix = 1 TO NUM-ENTRIES(cJoinCrit," "):
      IF NUM-ENTRIES(ENTRY(ix,cJoinCrit," "),"(") = 1 THEN DO: 
        IF NUM-ENTRIES(ENTRY(ix,cJoinCrit," "),".") > 2 THEN DO:
          cDbAndTbl = SUBSTR(ENTRY(ix,cJoinCrit," "),1,R-INDEX(ENTRY(ix,cJoinCrit," "),".") - 1).
          IF NOT CAN-DO(cDbTblList,cDbAndTbl) THEN
            cDbTblList = cDbTblList + (IF cDbTblList NE "" THEN "," ELSE "") + cDbAndTbl.
          cModJoin = cModJoin + (IF cModJoin NE "" THEN " " ELSE "") + SUBSTR(ENTRY(ix,cJoinCrit," "),INDEX(ENTRY(ix,cJoinCrit," "),".") + 1).
        END.         
        ELSE IF NUM-ENTRIES(ENTRY(ix,cJoinCrit," "),".") = 2 THEN DO:
          cDbAndTbl = ttViewDs.BaseDb + "." + ENTRY(1,ENTRY(ix,cJoinCrit," "),".").
          IF NOT CAN-DO(cDbTblList,cDbAndTbl) THEN
            cDbTblList = cDbTblList + (IF cDbTblList NE "" THEN "," ELSE "") + cDbAndTbl.
          cModJoin = cModJoin + (IF cModJoin NE "" THEN " " ELSE "") + ENTRY(ix,cJoinCrit," ").
        END.
        ELSE         
          cModJoin = cModJoin + (IF cModJoin NE "" THEN " " ELSE "") + ENTRY(ix,cJoinCrit," ").
      END.    
      ELSE         
        cModJoin = cModJoin + (IF cModJoin NE "" THEN " " ELSE "") + ENTRY(ix,cJoinCrit," ").
    END.  
    IF NOT CAN-DO(cDbTblList,ttViewDsTable.ViewDsParentDb + "." + ttViewDsTable.ViewDsParentTable) THEN
      cDbTblList = ttViewDsTable.ViewDsParentDb + "." + ttViewDsTable.ViewDsParentTable + (IF cDbTblList NE "" THEN "," ELSE "") + cDbTblList.
    IF NOT CAN-DO(cDbTblList,ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable) THEN
      cDbTblList = cDbTblList + (IF cDbTblList NE "" THEN "," ELSE "") + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable.

    cDbTblList = ttViewDsTable.ViewDsParentDb + "." + ttViewDsTable.ViewDsParentTable + "," + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable.
    cError = JBoxSchemaCache:Instance:CheckQuerySyntax(ttViewDsTable.SourceName,cDbTblList,
             "FOR EACH " + ttViewDsTable.ViewDsParentTable + ",EACH " + ttViewDsTable.ViewDsTable + " WHERE "
             + cModJoin).
    IF cError NE "" THEN DO: 
      JBoxSession:Instance:ViewMessage("Syntax warning: " + CHR(10) + cError).
//      RETURN.
    END.  
  END.
  IF otbViewDsTable:IsCurrent THEN DO WITH FRAME {&FRAME-NAME}:
     IF CAN-DO("FIRST,LAST",ViewDsTableJoinType:SCREEN-VALUE)  
        AND ttViewDs.SourceType MATCHES "*sql*" AND ViewDsTableFirstLast:SCREEN-VALUE = ? THEN DO:
       MESSAGE "To be able to specify FIRST/LAST you must add the field the selection should be based on"
               VIEW-AS ALERT-BOX.
       RETURN.
     END.             
    IF NOT bAddQueryBuilderTools AND VALID-OBJECT(oContainer:PARENT-CONTAINER-OBJECT) THEN DO:
      oContainer:PARENT-CONTAINER-OBJECT:TOOLBAR-OBJECT:setDisabledTools("").
      oContainer:PARENT-CONTAINER-OBJECT:TOOLBAR-OBJECT:setTools().
      oContainer:PARENT-CONTAINER-OBJECT:BROWSE-OBJECT:POPUP-MENU-OBJECT:setDisabledTools("").
      oContainer:PARENT-CONTAINER-OBJECT:BROWSE-OBJECT:POPUP-MENU-OBJECT:setTools().
    END.  
  END.
  
  RUN SUPER.

  PUBLISH "replaceViewDs".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveViewRecord C-Win 
PROCEDURE SaveViewRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cViewJsonFile   AS CHAR NO-UNDO.
DEF VAR cDataFjordCat   AS CHAR NO-UNDO.
DEF VAR bSelectDfCat    AS LOG  NO-UNDO.
DEF VAR bSaveTempData   AS LOG  NO-UNDO INIT YES.

DEF BUFFER bttViewDs FOR ttViewDs.
DEF BUFFER bttViewDsTable FOR ttViewDsTable.

FIND bttViewDs WHERE bttViewDs.ViewDsId = ttViewDs.ViewDsId. 

FIND FIRST bttViewDsTable
     WHERE bttViewDsTable.ViewDsId = bttViewDs.ViewDsId
       AND bttViewDsTable.hTempTable NE ?
     NO-ERROR.
IF AVAIL bttViewDsTable THEN DO:     
  IF bttViewDs.dataFjordCatalog NE "" THEN DO:     
    FILE-INFO:FILE-NAME = cDataFjordCat.      
    IF FILE-INFO:FULL-PATHNAME = ? THEN
      bSelectDfCat = YES.
  END.
  ELSE bSelectDfCat = YES.    
       
  IF bSelectDfCat AND VALID-HANDLE(bttViewDsTable.hTempTable) THEN DO:
    SYSTEM-DIALOG GET-DIR cDataFjordCat TITLE "Select catalog for temporary data".
    FILE-INFO:FILE-NAME = cDataFjordCat.      
    IF FILE-INFO:FULL-PATHNAME NE ? THEN
      bttViewDs.dataFjordCatalog = FILE-INFO:FULL-PATHNAME.
    ELSE bSaveTempData = NO.  
  END.      
END.

SYSTEM-DIALOG GET-FILE cViewJsonFile 
              FILTERS "Json files" "*.json"
              UPDATE bOK.
IF NOT bOk THEN RETURN.
IF NOT cViewJsonFile MATCHES "*.json" THEN cViewJsonFile = cViewJsonFile + ".json".
ttViewDs.ViewFileName = cViewJsonFile.
hdsViewDs:WRITE-JSON("file",cViewJsonFile,YES).

IF bSaveTempData THEN
  FOR EACH bttViewDsTable
      WHERE bttViewDsTable.ViewDsId = bttViewDs.ViewDsId
        AND bttViewDsTable.hTempTable NE ?:
    IF VALID-HANDLE(bttViewDsTable.hTempTable) THEN
      bttViewDsTable.hTempTable:WRITE-JSON("file",TRIM(bttViewDs.dataFjordCatalog,"\/") + "\" + bttViewDsTable.hTempTable:NAME + ".json",NO).
  END.          


FIND ttViewDs WHERE ttViewDs.ViewDsId = bttViewDs.ViewDsId.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBaseQuery C-Win 
PROCEDURE setBaseQuery :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF VAR cQuery        AS CHAR   NO-UNDO.
DEF VAR hSearchField  AS HANDLE NO-UNDO.
DEF VAR cFlds         AS CHAR   NO-UNDO.
DEF VAR ix            AS INT    NO-UNDO.
DEF VAR cDataType     AS CHAR   NO-UNDO.
DEF VAR cError        AS CHAR   NO-UNDO.
DEF VAR bIndexedOnly  AS LOG    NO-UNDO.
DEF VAR bIndexed      AS LOG    NO-UNDO.

cQuery = setTableQuery(ttViewDs.BaseTable,ttViewDs.BaseQuery).
       
ttViewDs.BaseQuery = cQuery.
ViewDsTableQuery:SCREEN-VALUE IN FRAME {&FRAME-NAME} = cQuery.  
PUBLISH "replaceViewDs".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeNodeSelectedRecord C-Win 
PROCEDURE TreeNodeSelectedRecord :
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

IF NUM-ENTRIES(icNode,".") < 3 THEN DO:
  MESSAGE "Invalid node selection: " IF icNode = "" THEN "<blank>" ELSE icNode
  VIEW-AS ALERT-BOX.
  RETURN.
END.   
DO WITH FRAME {&FRAME-NAME}:
  ASSIGN cCurrDb    = ENTRY(2,icNode,".")
         cCurrTable = ENTRY(3,icNode,".").
  IF AVAIL ttViewDs THEN DO:         
    FIND FIRST ttViewDsTable
         WHERE ttViewDsTable.ViewDsDb = cCurrDb
           AND ttViewDsTable.ViewDsTable = cCurrTable
           AND ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
    NO-ERROR.
    IF AVAIL ttViewDsTable THEN
      setCurrDbNum(cCurrDb,ttViewDsTable.SourceName).
    ELSE              
      setCurrDbNum(cCurrDb,ttViewDs.SourceName).
  END.  
  ELSE DO:
/*    MESSAGE "View not available (re-select)"*/
/*    VIEW-AS ALERT-BOX.                      */
    RETURN.
  END.           
    
  setQueries().       
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UndoRecord C-Win 
PROCEDURE UndoRecord :
IF NOT bAddQueryBuilderTools AND otbViewDsTable:IsCurrent AND VALID-OBJECT(oContainer:PARENT-CONTAINER-OBJECT) THEN DO WITH FRAME {&FRAME-NAME}:
    oContainer:PARENT-CONTAINER-OBJECT:TOOLBAR-OBJECT:setDisabledTools("").
    oContainer:PARENT-CONTAINER-OBJECT:TOOLBAR-OBJECT:setTools().
    oContainer:PARENT-CONTAINER-OBJECT:BROWSE-OBJECT:POPUP-MENU-OBJECT:setDisabledTools("").
    oContainer:PARENT-CONTAINER-OBJECT:BROWSE-OBJECT:POPUP-MENU-OBJECT:setTools().
  END.
  RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValueChangedField C-Win 
PROCEDURE ValueChangedField :
DEF INPUT PARAM icFieldName   AS CHAR NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  
  CASE icFieldName:
    WHEN "ViewDsTableJoinType" THEN DO:
      IF getParentDataSource(ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable) NE ttViewDsTable.SourceName THEN DO:
        ASSIGN ViewDsTableOuterJoin:CHECKED = NO
               ViewDsTableNotExist:CHECKED = NO
               ViewDsTableOuterJoin:HIDDEN = YES
               ViewDsTableNotExist:HIDDEN = YES
               ViewDsTableFirstLast:HIDDEN = YES.                 

        IF CAN-DO("FIRST,LAST",ViewDsTableJoinType:SCREEN-VALUE) THEN DO:      
          MESSAGE 'Since the parent table has a different datasource the only "JOIN"-option is EACH'
                  VIEW-AS ALERT-BOX.
          otbViewDsTable:invokeTool("undo").
          RETURN.                    
        END.
      END.
      ELSE IF CAN-DO("FIRST,LAST",ViewDsTableJoinType:SCREEN-VALUE) THEN DO: 
        IF ttViewDsTable.SourceType MATCHES "*sql*" AND ViewDsTableFirstLast:LIST-ITEM-PAIRS = "|" THEN DO:
          MESSAGE "To be able to specify FIRST/LAST you must add the field the selection should be based on"
                  VIEW-AS ALERT-BOX.
          otbViewDsTable:invokeTool("undo").
          RETURN.                    
        END.
        ASSIGN ViewDsTableOuterJoin:CHECKED = NO
               ViewDsTableNotExist:CHECKED = NO
               ViewDsTableOuterJoin:HIDDEN = YES
               ViewDsTableNotExist:HIDDEN = YES
               .
        IF ttViewDsTable.SourceType MATCHES "*sql*" THEN 
          ViewDsTableFirstLast:HIDDEN = NO.
        ELSE                   
          ViewDsTableFirstLast:HIDDEN = YES.                 
      END.  
      ELSE DO:          
        ASSIGN ViewDsTableOuterJoin:HIDDEN = NO
               ViewDsTableNotExist:HIDDEN = NO
               .
        IF ttViewDsTable.SourceType MATCHES "*sql*" THEN
          ViewDsTableFirstLast:HIDDEN = YES.                 
      END.
    END.  
    WHEN "ViewDsTableOuterJoin" THEN DO:
      IF ViewDsTableOuterJoin:CHECKED THEN
        ViewDsTableNotExist:CHECKED = NO.
    END.  
    WHEN "ViewDsTableNotExist" THEN DO:
      IF ViewDsTableNotExist:CHECKED THEN
        ViewDsTableOuterJoin:CHECKED = NO.
    END.  
  END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addAllFields C-Win 
FUNCTION addAllFields RETURNS LOGICAL
  ( INPUT icDb AS CHAR,
    INPUT icTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR iSeq AS INT NO-UNDO.
DEF VAR iz   AS INT NO-UNDO.

iSeq = LastFieldSeq().

FOR EACH tt_db
    WHERE tt_db.cSourceName = ttViewDs.SourceName
   ,EACH tt_file
         WHERE tt_file.iDbNum   = tt_db.iDbNum
           AND tt_file.cLDBname = icDb
           AND tt_file.cFile-Name = RealTable(icTable)
   ,EACH tt_field
         WHERE tt_field.iFileNum = tt_file.iFileNum
    BY tt_field.iOrder:
  IF tt_field.iExtent = 0 THEN DO:    
    CREATE ttViewDsField.
    ASSIGN ttViewDsField.ViewDsId           = ttViewDs.ViewDsId
           ttViewDsField.ViewDsDb           = ttViewDs.BaseDb
           ttViewDsField.ViewDsTable        = icTable
           ttViewDsField.ViewDsFieldName    = tt_field.cField-Name
           ttViewDsField.ViewDsFieldType    = tt_field.cData-Type
           ttViewDsField.ViewDsFieldLabel   = tt_field.cLabel
           ttViewDsField.ViewDsFieldFormat  = tt_field.cFormat
           ttViewDsField.ViewDsFieldIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(ttViewDsField.ViewDsFieldName,ttViewDsField.ViewDsTable,tt_file.cLDBname,ttViewDs.SourceName)
           iSeq                             = iSeq + 1
           ttViewDsField.ViewDsFieldSeq     = iSeq
           ttViewDsField.RowIdent1          = STRING(ROWID(ttViewDsField))
           .
  END.
  ELSE DO iz = 1 TO  tt_field.iExtent:
    CREATE ttViewDsField.
    ASSIGN ttViewDsField.ViewDsId           = ttViewDs.ViewDsId
           ttViewDsField.ViewDsDb           = ttViewDs.BaseDb
           ttViewDsField.ViewDsTable        = icTable
           ttViewDsField.ViewDsFieldName    = tt_field.cField-Name + "[" + STRING(iz) + "]"
           ttViewDsField.ViewDsFieldType    = tt_field.cData-Type
           ttViewDsField.ViewDsFieldLabel   = tt_field.cLabel + "[" + STRING(iz) + "]"
           ttViewDsField.ViewDsFieldFormat  = tt_field.cFormat
           ttViewDsField.ViewDsFieldIndexed = NO
           iSeq                             = iSeq + 1
           ttViewDsField.ViewDsFieldSeq     = iSeq
           ttViewDsField.RowIdent1          = STRING(ROWID(ttViewDsField))
           .
  END.          
END.                         

PUBLISH "replaceViewDs".

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addDsJoinBuffersToDsTable C-Win 
FUNCTION addDsJoinBuffersToDsTable RETURNS CHARACTER
  ( INPUT ihDs AS HANDLE,
    INPUT icSourceName AS CHAR,
    INPUT icTopDb AS CHAR,
    INPUT icTopTable AS CHAR,
    INPUT icParentDb AS CHAR,
    INPUT icParentTable AS CHAR,
    INPUT ihTt AS HANDLE,
    INPUT icAddedFields AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Join together tables from same datasource and chain
------------------------------------------------------------------------------*/
DEF VAR ix               AS INT NO-UNDO.
DEF VAR iy               AS INT NO-UNDO.
DEF VAR iz               AS INT NO-UNDO.
DEF VAR cJoinTableList   AS CHAR NO-UNDO.
DEF VAR cChildrenRelFlds AS CHAR   NO-UNDO.
DEF VAR cRelDs           AS CHAR   NO-UNDO.
DEF VAR cRelDb           AS CHAR   NO-UNDO.
DEF VAR cRelTable        AS CHAR   NO-UNDO.
DEF VAR cRelFlds         AS CHAR   NO-UNDO.

DEF BUFFER bttViewDs      FOR ttViewDs.
DEF BUFFER ttViewDsTable  FOR ttViewDsTable.
DEF BUFFER bttViewDsTable FOR ttViewDsTable.
DEF BUFFER ttViewDsField  FOR ttViewDsField.

IF icTopDb = ttViewDs.BaseDb AND icTopTable = ttViewDs.BaseTable AND icParentDb = "" THEN
  ASSIGN ttViewDs.queryJoin = ""
         ttViewDs.joinBuffersAndFields = "".
ELSE DO:
  FIND FIRST bttViewDsTable 
       WHERE bttViewDsTable.ViewDsDb = icTopDb
         AND bttViewDsTable.ViewDsTable = icTopTable
       NO-ERROR.
  IF NOT AVAIL bttViewDsTable THEN DO:
    FIND FIRST bttViewDs
         WHERE bttViewDs.BaseDb = icTopDb
           AND bttViewDs.BaseTable = icTopTable
         NO-ERROR.
    IF NOT AVAIL bttViewDs THEN       
      RETURN "".
  END.       
  IF icParentDb = "" THEN     
    ASSIGN bttViewDsTable.queryJoin = ""
           bttViewDsTable.joinBuffersAndFields = "".        
END.                  

FOR EACH ttViewDsTable
    WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsTable.ViewDsParentDb = (IF icParentDb NE "" THEN icParentDb ELSE icTopDb)
      AND ttViewDsTable.ViewDsParentTable = (IF icParentTable NE "" THEN icParentTable ELSE icTopTable)
      AND ttViewDsTable.SourceName = icSourceName
      AND (IF NOT bJoinSameSource THEN ttViewDsTable.ViewDsTableJoinType NE "EACH" ELSE TRUE)
      AND NOT CAN-DO(cBuffersJoined,ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable)
    : 

  IF icTopDb = ttViewDs.BaseDb AND icTopTable = ttViewDs.BaseTable THEN
    ASSIGN ttViewDs.queryJoin = ttViewDs.queryJoin 
                              + (IF ttViewDs.queryJoin NE "" THEN "," ELSE "")
                              + (IF ttViewDsTable.ViewDsTableNotExist THEN "FIRST" ELSE ttViewDsTable.ViewDsTableJoinType) 
                              + " " + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable
                              + " NO-LOCK WHERE "
                              + getJoinCrit(ttViewDsTable.ViewDsTableQuery)
                              + (IF ttViewDsTable.ViewDsTableOuterJoin THEN " OUTER-JOIN" ELSE "")
           ttViewDs.joinBuffersAndFields = ttViewDs.joinBuffersAndFields
                              + (IF ttViewDs.joinBuffersAndFields NE "" THEN "," ELSE "")
                              + getChildBuffersAndFields("-",ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable)
                              .     
  ELSE
    ASSIGN bttViewDsTable.queryJoin = bttViewDsTable.queryJoin 
                              + (IF bttViewDsTable.queryJoin NE "" THEN "," ELSE "")
                              + (IF ttViewDsTable.ViewDsTableNotExist THEN "FIRST" ELSE ttViewDsTable.ViewDsTableJoinType) 
                              + " " + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable
                              + " NO-LOCK WHERE "
                              + getJoinCrit(ttViewDsTable.ViewDsTableQuery)
                              + (IF ttViewDsTable.ViewDsTableOuterJoin THEN " OUTER-JOIN" ELSE "")
           bttViewDsTable.joinBuffersAndFields = bttViewDsTable.joinBuffersAndFields
                              + (IF bttViewDsTable.joinBuffersAndFields NE "" THEN "," ELSE "")
                              + getChildBuffersAndFields("-",ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable)
                              .     
  
  ttViewDsTable.preScanBaseQuery = getSqlSubQueries(ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable).
  
  FOR EACH ttViewDsField
      WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsField.ViewDsDb = ttViewDsTable.ViewDsDb
        AND ttViewDsField.ViewDsTable = ttViewDsTable.ViewDsTable
      BY ttViewDsField.ViewDsFieldSeq
      :
    ihTt:ADD-NEW-FIELD (ttViewDsField.ViewDsFieldName
                          ,ttViewDsField.ViewDsFieldType,0
                          ,ttViewDsField.ViewDsFieldFormat,""
                          ,ttViewDsField.ViewDsFieldLabel
                          ).
    icAddedFields = icAddedFields + (IF icAddedFields NE "" THEN "," ELSE "") + ttViewDsField.ViewDsFieldName.                      
  END.                     
  cBuffersJoined = cBuffersJoined + (IF cBuffersJoined NE "" THEN "," ELSE "")
                 + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable.
  cJoinTableList = cJoinTableList + (IF cJoinTableList NE "" THEN "," ELSE "") 
                  + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable.     
                  
  // Joined tables might have children belonging to another datasource
  // In that case we need to add relationship fields for those (grand) children as well
  cChildrenRelFlds = getRelationFields(ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable,"",""
                                      ,"childWithDS"). // get datasource info also
  DO iz = 1 TO NUM-ENTRIES(cChildrenRelFlds):
    ASSIGN cRelFlds  = ENTRY(1,ENTRY(iz,cChildrenRelFlds),";")
           cRelDs    = ENTRY(2,ENTRY(iz,cChildrenRelFlds),";")
           cRelDb    = ENTRY(3,ENTRY(iz,cChildrenRelFlds),";")
           cRelTable = ENTRY(4,ENTRY(iz,cChildrenRelFlds),";")
           .
    IF cRelDs NE icSourceName THEN       
      DO ix = 1 TO NUM-ENTRIES(cRelFlds):       
        IF NOT CAN-DO(icAddedFields,ENTRY(ix,cRelFlds)) THEN DO:
          IF icTopDb = ttViewDs.BaseDb AND icTopTable = ttViewDs.BaseTable THEN
            ttViewDs.joinBuffersAndFields = ttViewDs.joinBuffersAndFields + ";" + ENTRY(ix,cRelFlds).
          ELSE
            bttViewDsTable.joinBuffersAndFields = bttViewDsTable.joinBuffersAndFields + ";" + ENTRY(ix,cRelFlds).
          addFieldFromDictToTt(ihTt,cRelDs, cRelDb, cRelTable, ENTRY(ix,cRelFlds)).
          icAddedFields = icAddedFields + (IF icAddedFields NE "" THEN "," ELSE "") + ENTRY(ix,cRelFlds).                      
        END.
      END.    
  END.   
                                            
  addDsJoinBuffersToDsTable(ihDs,icSourceName, icTopDb, icTopTable,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable, ihTt,icAddedFields).
END.

IF icTopDb = ttViewDs.BaseDb AND icTopTable = ttViewDs.BaseTable AND icParentDb = "" THEN DO:
  ihtt:TEMP-TABLE-PREPARE (icTopTable).   
  ihtt:ADM-DATA = icTopTable.   
  ihtt:PRIVATE-DATA = icTopDb.
                     
  ihDs:ADD-BUFFER (ihtt:DEFAULT-BUFFER-HANDLE).

  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsTable.ViewDsParentDb = icTopDb
        AND ttViewDsTable.ViewDsParentTable = icTopTable
        AND NOT CAN-DO(cJoinTableList,ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable)
      :  
    IF NOT addTableToDs(ihDs,ihtt:DEFAULT-BUFFER-HANDLE,ttViewDsTable.ViewDsParentDb,ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable) THEN LEAVE.
  END.
  
  DO ix = 1 TO NUM-ENTRIES(cJoinTableList):
    FOR EACH ttViewDsTable
        WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
          AND ttViewDsTable.ViewDsParentDb = ENTRY(1,ENTRY(ix,cJoinTableList),".")
          AND ttViewDsTable.ViewDsParentTable = ENTRY(2,ENTRY(ix,cJoinTableList),".")
          AND ttViewDsTable.SourceName NE icSourceName
          AND NOT CAN-DO(cJoinTableList,ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable)
        :  
      IF NOT addTableToDs(ihDs,ihtt:DEFAULT-BUFFER-HANDLE,ttViewDsTable.ViewDsParentDb,ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable) THEN LEAVE.
    END.
  END.
  RETURN "".
END.  

RETURN cJoinTableList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addFieldFromDictToTt C-Win 
FUNCTION addFieldFromDictToTt RETURNS LOGICAL
  ( INPUT ihTt AS HANDLE,
    INPUT icDataSource AS CHAR,
    INPUT icDb AS CHAR,
    INPUT icTable AS CHAR,
    INPUT icField AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
FOR EACH tt_db
    WHERE (IF icDataSource NE "" THEN tt_db.cSourceName = icDataSource ELSE TRUE)
      AND tt_db.cLDBname = icDb
    ,EACH tt_file
          WHERE tt_file.iDbNum = tt_db.iDbNum
            AND tt_file.cLDBname = icDb
            AND tt_file.cFile-Name = RealTable(icTable)
    ,EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND tt_field.cField-Name = icField
          :
  ihTt:ADD-NEW-FIELD (icField
                     ,tt_field.cData-Type,0
                     ,tt_field.cFormat,""
                     ,tt_field.cLabel).
  LEAVE.
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addTableToDs C-Win 
FUNCTION addTableToDs RETURNS LOGICAL
  ( INPUT ihDs           AS HANDLE,
    INPUT ihParentBuffer AS HANDLE,  
    INPUT icParentDb     AS CHAR,
    INPUT icParentTable  AS CHAR,
    INPUT icDb           AS CHAR,
    INPUT icTable        AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR htt              AS HANDLE NO-UNDO.
DEF VAR hRel             AS HANDLE NO-UNDO.
DEF VAR ix               AS INT    NO-UNDO.
DEF VAR iy               AS INT    NO-UNDO.
DEF VAR iz               AS INT    NO-UNDO.
DEF VAR cParentRelFlds   AS CHAR   NO-UNDO.
DEF VAR cChildrenRelFlds AS CHAR   NO-UNDO.
DEF VAR cRel             AS CHAR   NO-UNDO.
DEF VAR cTableSuff       AS CHAR   NO-UNDO.
DEF VAR cJoinTableList   AS CHAR   NO-UNDO.
DEF VAR cSourceName      AS CHAR   NO-UNDO.
DEF VAR cFieldList       AS CHAR   NO-UNDO.

DEF BUFFER ttViewDsTable  FOR ttViewDsTable.
DEF BUFFER bttViewDsTable FOR ttViewDsTable.
DEF BUFFER ttViewDsField  FOR ttViewDsField.

cParentRelFlds   = getRelationFields(icParentDb,icParentTable,icDb,icTable,"parent").
cChildrenRelFlds = getRelationFields(icDb,icTable,"","","child").

CREATE TEMP-TABLE htt.
FOR EACH ttViewDsField
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsField.ViewDsDb = icDb
      AND ttViewDsField.ViewDsTable = icTable
    BY ttViewDsField.ViewDsFieldSeq
    :
  htt:ADD-NEW-FIELD (ttViewDsField.ViewDsFieldName
                    ,ttViewDsField.ViewDsFieldType,0
                    ,ttViewDsField.ViewDsFieldFormat,""
                    ,ttViewDsField.ViewDsFieldLabel
                     ).
  IF CAN-DO(cParentRelFlds,ttViewDsField.ViewDsFieldName) THEN
    cParentRelFlds = REPLACE(cParentRelFlds,ttViewDsField.ViewDsFieldName,"").                   
  IF CAN-DO(cChildrenRelFlds,ttViewDsField.ViewDsFieldName) THEN
    cChildrenRelFlds = REPLACE(cChildrenRelFlds,ttViewDsField.ViewDsFieldName,"").
  cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ttViewDsField.ViewDsFieldName.                      
END.

FIND FIRST ttViewDsTable
     WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
       AND ttViewDsTable.ViewDsDb = icDb
       AND ttViewDsTable.ViewDsTable = icTable.

ttViewDsTable.preScanBaseQuery = getSqlSubQueries(ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable).                              

// Get my fields without fields from children (-)
ttViewDsTable.buffersAndFields = getChildBuffersAndFields("-",ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable).

cSourceName = ttViewDsTable.SourceName.

DO ix = 1 TO NUM-ENTRIES(cParentRelFlds):
  IF ENTRY(ix,cParentRelFlds) NE "" THEN DO:
    ttViewDsTable.buffersAndFields = ttViewDsTable.buffersAndFields + ";" + ENTRY(ix,cParentRelFlds).
    addFieldFromDictToTt(hTt,ttViewDsTable.SourceName,icDb, icTable, ENTRY(ix,cParentRelFlds)).
    cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ENTRY(ix,cParentRelFlds).                      
  END.  
END.

DO ix = 1 TO NUM-ENTRIES(cChildrenRelFlds):
  IF ENTRY(ix,cChildrenRelFlds) NE "" THEN DO:
    ttViewDsTable.buffersAndFields = ttViewDsTable.buffersAndFields + ";" + ENTRY(ix,cChildrenRelFlds).
    addFieldFromDictToTt(hTt,ttViewDsTable.SourceName, icDb, icTable, ENTRY(ix,cChildrenRelFlds)).
    cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ENTRY(ix,cChildrenRelFlds).                      
  END.  
END.

cJoinTableList = addDsJoinBuffersToDsTable(ihDs,ttViewDsTable.SourceName,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable,"","",htt,cFieldList).

ttViewDsTable.preScanQueries = getPrescanQueries(ttViewDsTable.SourceName).


DO ix = 1 TO ihDs:NUM-RELATIONS:
  IF ihDs:GET-RELATION (ix):CHILD-BUFFER:NAME = icTable THEN
    cTableSuff = STRING(ix).
END.

htt:TEMP-TABLE-PREPARE (icTable + cTableSuff).   
htt:ADM-DATA = icTable.   
htt:PRIVATE-DATA = icDb.
cTtBufferSourceList = cTtBufferSourceList + (IF cTtBufferSourceList NE "" THEN "," ELSE "") + icTable + cTableSuff + ";" + icTable + ";" + icDb.

                     
ihDs:ADD-BUFFER (htt:DEFAULT-BUFFER-HANDLE).

cRel = getRelationFields(icParentDb,icParentTable,icDb,icTable,"pairs").

IF cRel NE "" THEN 
  ihDs:ADD-RELATION(ihParentBuffer,htt:DEFAULT-BUFFER-HANDLE,cRel).
ELSE
  MESSAGE "Relationship not defined for " icTable
  VIEW-AS ALERT-BOX.  
  
FOR EACH ttViewDsTable
    WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsTable.ViewDsParentDb = icDb
      AND ttViewDsTable.ViewDsParentTable = icTable
      AND ttViewDsTable.ViewDsTableJoinType = "EACH"
      AND NOT CAN-DO(cBuffersJoined,ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable)
    :  
  IF NOT addTableToDs(ihDs,htt:DEFAULT-BUFFER-HANDLE,ttViewDsTable.ViewDsParentDb,ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable) THEN DO:
    cRel = "".
    LEAVE.
  END.   
END.
DO ix = 1 TO NUM-ENTRIES(cJoinTableList):
  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsTable.ViewDsParentDb = ENTRY(1,ENTRY(ix,cJoinTableList),".")
        AND ttViewDsTable.ViewDsParentTable = ENTRY(2,ENTRY(ix,cJoinTableList),".")
        AND ttViewDsTable.SourceName NE cSourceName
        AND NOT CAN-DO(cJoinTableList,ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable)
      :  
    addTableToDs(ihDs,htt:DEFAULT-BUFFER-HANDLE,ttViewDsTable.ViewDsParentDb,ttViewDsTable.ViewDsParentTable,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable).
  END.
END.

CATCH eErr AS Progress.Lang.Error :
  MESSAGE eErr:GetMessage(1)
  VIEW-AS ALERT-BOX. 
END CATCH.
FINALLY:
  RETURN cRel NE "".
END.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BuildTableLookup C-Win 
FUNCTION BuildTableLookup RETURNS LOGICAL
  ( INPUT iiDbNum AS INT,
    INPUT icTable AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:
  ------------------------------------------------------------------------------*/
  DEF VAR cFieldMatch AS CHAR NO-UNDO.
  DEF VAR cParentKeyFields AS CHAR NO-UNDO.
  DEF VAR ix AS INT NO-UNDO. 
  DEF VAR cParentKey   AS CHAR NO-UNDO.
  DEF VAR cChildKey    AS CHAR NO-UNDO.
  DEF VAR cMatchType   AS CHAR NO-UNDO.
  DEF VAR cMatchFields AS CHAR NO-UNDO.
  DEF VAR cMaxMatch    AS CHAR NO-UNDO.
  DEF VAR iMaxMatch    AS INT  NO-UNDO.
  DEF VAR cIdxFlds     AS CHAR NO-UNDO.

  EMPTY TEMP-TABLE ttTableLookup.
  EMPTY TEMP-TABLE ttKeyMatch.
  
  DEF BUFFER bttKeyMatch FOR ttKeyMatch.
  DEF BUFFER bttIndex    FOR tt_index.
  
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH tt_db
             WHERE tt_db.cSourceName = cCurrSourceName
       ,EACH tt_file
             WHERE tt_file.iDbNum = tt_db.iDbNum
               AND tt_file.cFile-Name = icTable
       ,EACH tt_index
             WHERE tt_index.iFileNum = tt_file.iFileNum
               AND tt_index.bActive
       ,EACH tt_index-field 
             WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
               AND tt_index-field.iFileNum = tt_file.iFileNum
               AND tt_index-field.cFieldName NE "prrowid"
        BREAK BY tt_index.iIdxNum
              BY tt_index-field.iIdxSeq
        :
      IF FIRST-OF(tt_index.iIdxNum) THEN DO:
        CREATE ttKeyMatch.
        ASSIGN ttKeyMatch.FieldName = tt_index-field.cFieldName
               ttKeyMatch.ParentKey = tt_index.bUnique
               .
      END.     
      ELSE ttKeyMatch.FieldName = ttKeyMatch.FieldName + "," + tt_index-field.cFieldName.        
    END.     
    FOR EACH tt_db
        WHERE tt_db.cSourceName = cCurrSourceName
       ,EACH tt_file
             WHERE tt_file.iDbNum = tt_db.iDbNum
//               AND tt_file.cFile-Name NE icTable             
               AND CAN-DO("TABLE,T",tt_file.cTbl-Type) 
        BY tt_db.cLDBname 
        BY tt_file.cFile-Name               
      :
      FOR EACH ttKeyMatch WHERE ttKeyMatch.iFileNum = 0:
        CREATE bttKeyMatch.
        BUFFER-COPY ttKeyMatch TO bttKeyMatch.
        ASSIGN bttKeyMatch.iFileNum = tt_file.iFileNum.
      END.          
      FOR EACH ttKeyMatch
          WHERE ttKeyMatch.iFileNum = tt_file.iFileNum: 
        FOR EACH tt_index
            WHERE tt_index.iFileNum = tt_file.iFileNum
           ,EACH tt_index-field 
                 WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
                   AND tt_index-field.iFileNum = tt_file.iFileNum
            BREAK BY tt_index.iIdxNum
                  BY tt_index-field.iIdxSeq
            :
          IF FIRST-OF(tt_index.iIdxNum) 
             AND tt_index-field.cFieldName = ENTRY(1,ttKeyMatch.FieldName)
             THEN   
            ASSIGN ttKeyMatch.ChildKey = tt_index.bUnique
                   ttKeyMatch.bMatch = YES.
        END.           
        IF ttKeyMatch.bMatch AND NUM-ENTRIES(ttKeyMatch.FieldName) > 1 THEN DO:
          cMaxMatch = ENTRY(1,ttKeyMatch.FieldName).          
          FOR EACH tt_index
              WHERE tt_index.iFileNum = tt_file.iFileNum
              :       
            cIdxFlds = "".
            FOR EACH tt_index-field
                WHERE tt_index-field.iFileNum = tt_file.iFileNum
                  AND tt_index-field.iIdxNum = tt_index.iIdxNum
                BY tt_index-field.iIdxSeq:
              cIdxFlds = cIdxFlds + (IF cIdxFlds NE "" THEN "," ELSE "") + tt_index-field.cFieldName.
            END.
            cMatchFields = "". 
            DO ix = 1 TO NUM-ENTRIES(ttKeyMatch.FieldName):
              IF NUM-ENTRIES(cIdxFlds) GE ix AND ENTRY(ix,cIdxFlds) = ENTRY(ix,ttKeyMatch.FieldName) THEN
                cMatchFields = cMatchFields + (IF cMatchFields NE "" THEN "," ELSE "") + ENTRY(ix,ttKeyMatch.FieldName).
              ELSE DO: // Check if a single index can be added..
                FOR EACH bttIndex 
                    WHERE bttIndex.iFileNum = tt_file.iFileNum
                      AND bttIndex.iIdxNum NE tt_index.iIdxNum
                   ,EACH tt_index-field
                         WHERE tt_index-field.iFileNum = tt_file.iFileNum
                           AND tt_index-field.iIdxNum = bttIndex.iIdxNum
                    BREAK BY bttIndex.iIdxNum       
                          BY tt_index-field.iIdxSeq:
                  IF FIRST-OF(bttIndex.iIdxNum) AND tt_index-field.cFieldName = ENTRY(ix,ttKeyMatch.FieldName) THEN DO:          
                    cMatchFields = cMatchFields + (IF cMatchFields NE "" THEN "," ELSE "") + ENTRY(ix,ttKeyMatch.FieldName).
                    LEAVE.
                  END.  
                END.
              END.    
            END.
            cMaxMatch = IF NUM-ENTRIES(cMatchFields) > NUM-ENTRIES(cMaxMatch) THEN cMatchFields ELSE cMaxMatch.
          END.        
          ASSIGN ttKeyMatch.FieldName = cMaxMatch
                 ttKeyMatch.iNumFldMatch = NUM-ENTRIES(cMaxMatch).      
        END.
        
      END.
      
      IF CAN-FIND(FIRST ttKeyMatch WHERE ttKeyMatch.iFileNum = tt_file.iFileNum AND ttKeyMatch.bMatch) THEN
        FOR EACH ttKeyMatch 
            WHERE ttKeyMatch.iFileNum = tt_file.iFileNum
              AND ttKeyMatch.bMatch
            BY ttKeyMatch.iNumFldMatch DESC:
          cMatchType = IF ttKeyMatch.ParentKey OR ttKeyMatch.ChildKey THEN "Key" ELSE "Name/Idx".
          FIND FIRST ttTableLookup
               WHERE ttTableLookup.Db = tt_db.cLDBname
                 AND ttTableLookup.TableName = tt_file.cFile-Name
                 AND ttTableLookup.FieldMatch = ttKeyMatch.FieldName
               NO-ERROR.
          IF NOT AVAIL ttTableLookup THEN DO:
            CREATE ttTableLookup.
            ASSIGN ttTableLookup.Db         = tt_db.cLDBname
                   ttTableLookup.TableName  = tt_file.cFile-Name
                   ttTableLookup.FieldMatch = ttKeyMatch.FieldName
                   ttTableLookup.MatchType  = cMatchType
                   .
          END.         
          LEAVE.
        END.
      ELSE DO:              
        CREATE ttTableLookup.
        ASSIGN ttTableLookup.Db = tt_db.cLDBname
               ttTableLookup.TableName = tt_file.cFile-Name
               .
      END.             
    END.
  END.

  RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canAddFunction C-Win 
FUNCTION canAddFunction RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    DEF VAR bOk AS LOGICAL NO-UNDO.
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR cDatatype1 AS CHAR NO-UNDO.
    DEF VAR cDatatype2 AS CHAR NO-UNDO.

    IF oBrwViewDsField:BROWSE-HANDLE:NUM-SELECTED-ROWS > 2 THEN RETURN NO.
    
    DO ix = 1 TO oBrwViewDsField:BROWSE-HANDLE:NUM-SELECTED-ROWS:
      IF oBrwViewDsField:BROWSE-HANDLE:FETCH-SELECTED-ROW(ix) THEN DO:
        IF ix = 1 THEN cDatatype1 = ttViewDsField.ViewDsFieldType.
        ELSE cDatatype2 = ttViewDsField.ViewDsFieldType.
        IF ttViewDsField.ViewDsFieldFunction NE "" THEN RETURN NO.
      END.  
    END.
    IF CAN-DO("CHARACTER,LOGICAL",cDatatype1) OR CAN-DO("CHARACTER,LOGICAL",cDatatype2) THEN 
      cCalcOperSuggestion = "CONCAT".
    ELSE IF CAN-DO("INTEGER,DECIMAL",cDatatype1) AND CAN-DO("INTEGER,DECIMAL",cDatatype2) THEN
      cCalcOperSuggestion = "*".
    ELSE  
      cCalcOperSuggestion = "-".
              
    RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeTableQuery C-Win 
FUNCTION closeTableQuery RETURNS LOGICAL ( ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DO WITH FRAME {&FRAME-NAME}:
  oJBoxMsTreeView:clearNodes().
  oQryViewDsTable:openQuery("where false").
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyFunctions C-Win 
FUNCTION copyFunctions RETURNS LOGICAL
  ( INPUT icToViewDsId AS CHAR,
    INPUT icFromViewDsId AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttToViewDsField FOR ttViewDsField.
DEF BUFFER ttFromViewDsField FOR ttViewDsField.

FOR EACH ttFromViewDsField
    WHERE ttFromViewDsField.ViewDsId NE icToViewDsId
      AND CAN-DO("filterlookup,filterdropdown",ENTRY(1,ttFromViewDsField.ViewDsFieldFunction,";"))
      AND (IF icFromViewDsId NE "" THEN ttFromViewDsField.ViewDsId = icFromViewDsId ELSE TRUE)
   ,FIRST ttToViewDsField
          WHERE ttToViewDsField.ViewDsId = icToViewDsId 
            AND ttToViewDsField.ViewDsTable = ttFromViewDsField.ViewDsTable
            AND ttToViewDsField.ViewDsFieldName = ttFromViewDsField.ViewDsFieldName
    :
  ttToViewDsField.ViewDsFieldFunction = ttFromViewDsField.ViewDsFieldFunction.    
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION createDataSet C-Win 
FUNCTION createDataSet RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR hDs              AS HANDLE NO-UNDO.
DEF VAR httBase          AS HANDLE NO-UNDO.
DEF VAR cChildrenRelFlds AS CHAR   NO-UNDO.
DEF VAR ix               AS INT    NO-UNDO.
DEF VAR cFieldList       AS CHAR   NO-UNDO.

DEF BUFFER ttViewDsTable FOR ttViewDsTable.
DEF BUFFER ttViewDsField FOR ttViewDsField.
DEF BUFFER bttViewDsField FOR ttViewDsField.

cChildrenRelFlds = getRelationFields(ttViewDs.BaseDb,ttViewDs.BaseTable,"","","child").

cTtBufferSourceList = "".

CREATE TEMP-TABLE httBase.

FOR EACH ttViewDsField
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsField.ViewDsDb = ttViewDs.BaseDb
      AND ttViewDsField.ViewDsTable = ttViewDs.BaseTable
    BY ttViewDsField.ViewDsFieldSeq
    :
  httBase:ADD-NEW-FIELD (ttViewDsField.ViewDsFieldName
                        ,ttViewDsField.ViewDsFieldType,0
                        ,ttViewDsField.ViewDsFieldFormat,""
                        ,ttViewDsField.ViewDsFieldLabel
                         ).
  IF CAN-DO(cChildrenRelFlds,ttViewDsField.ViewDsFieldName) THEN
    cChildrenRelFlds = REPLACE(cChildrenRelFlds,ttViewDsField.ViewDsFieldName,"").                       
  cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ttViewDsField.ViewDsFieldName.       
END.

ttViewDs.buffersAndFields = getChildBuffersAndFields("-",ttViewDs.BaseDb + "." + ttViewDs.BaseTable).

DO ix = 1 TO NUM-ENTRIES(cChildrenRelFlds): // adding mandatory fields for relations
  IF ENTRY(ix,cChildrenRelFlds) NE "" THEN DO:
    ttViewDs.buffersAndFields = ttViewDs.buffersAndFields + ";" + ENTRY(ix,cChildrenRelFlds).
    addFieldFromDictToTt(httBase,ttViewDs.SourceName,ttViewDs.BaseDb,ttViewDs.BaseTable,ENTRY(ix,cChildrenRelFlds)).
    cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ENTRY(ix,cChildrenRelFlds).                      
  END.  
END.  

cBuffersJoined = "".
ttViewDs.joinBuffersAndFields = "".

ttViewDs.preScanQueries = getPrescanQueries(ttViewDs.SourceName).
ttViewDs.altPrimaryBufferList = getAltPrimaryBuffers().

CREATE DATASET hDs.
addDsJoinBuffersToDsTable(hDs,ttViewDs.SourceName,ttViewDs.BaseDb,ttViewDs.BaseTable,"","",httBase,cFieldList).

RETURN hDs.

CATCH eErr AS Progress.Lang.Error :
  MESSAGE eErr:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DeleteChildTable C-Win 
FUNCTION DeleteChildTable RETURNS LOGICAL
  ( INPUT icParentTable AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF BUFFER ttViewDsTable FOR ttViewDsTable.
  DEF BUFFER ttViewDsField FOR ttViewDsField.
  
  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsTable.ViewDsParentTable = icParentTable
        :
    DeleteChildTable(ttViewDsTable.ViewDsTable).
    FOR EACH ttViewDsField
        WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
          AND ttViewDsField.ViewDsTable = icParentTable
        :
      DELETE ttViewDsField.
    END.
    DELETE ttViewDsTable.
  END.
  
  RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FillTreeChildNodes C-Win 
FUNCTION FillTreeChildNodes RETURNS LOGICAL
  ( INPUT icViewDsId    AS CHAR,
    INPUT icParentDb    AS CHAR,
    INPUT icParentTable AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:
  ------------------------------------------------------------------------------*/
  DEF BUFFER ttViewDsTable FOR ttViewDsTable.

  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = icViewDsId
        AND ttViewDsTable.ViewDsParentDb = icParentDb
        AND ttViewDsTable.ViewDsParentTable = icParentTable
      :  
      oJBoxMsTreeView:AddNode(icViewDsId + "." + icParentDb + "." + icParentTable,
        icViewDsId + "." + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable,
        ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable,"Table",0,1).
      FillTreeChildNodes(icViewDsId,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable).
    END.
  END.

  RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAlias C-Win 
FUNCTION getAlias RETURNS CHARACTER
  (INPUT icDb    AS CHAR,
   INPUT icTable AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR ix AS INT NO-UNDO.

  DEF BUFFER ttViewDsTable FOR ttViewDsTable.

  IF ttViewDs.BaseDb = icDb AND ttViewDs.BaseTable = icTable THEN
    ix = 1. 
  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId    = ttViewDs.ViewDsId
        AND ttViewDsTable.ViewDsDb    = icDb
       :
    IF RealTable(ttViewDsTable.ViewDsTable) = icTable THEN
      ix = ix + 1.     
  END.        
  IF ix > 9 THEN DO:
    MESSAGE "Too many aliases for " icTable
    VIEW-AS ALERT-BOX.
    RETURN ?.
  END.
  ELSE IF ix > 0 THEN
    RETURN "buf" + STRING(ix) + "_" + icTable.
  ELSE 
    RETURN icTable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAltPrimaryBuffers C-Win 
FUNCTION getAltPrimaryBuffers RETURNS CHARACTER
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cAltPrimaryBufferList AS CHAR NO-UNDO.

DEF BUFFER ttViewDsTable FOR TEMP-TABLE ttViewDsTable.

FOR EACH ttViewDsTable
    WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
    BY ttViewDsTable.ViewDsTableLevel DESC
    :
  IF ttViewDsTable.ViewDsTableJoinType NE "EACH" OR ttViewDsTable.ViewDsTableNotExist THEN RETURN "".    
  cAltPrimaryBufferList = cAltPrimaryBufferList + (IF cAltPrimaryBufferList NE "" THEN "," ELSE "") + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable.                  
END.  

RETURN cAltPrimaryBufferList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getApiParams C-Win 
FUNCTION getApiParams RETURNS CHARACTER
  ( INPUT icObjectName AS CHAR,
    INPUT ibView       AS LOG ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

DEF VAR cQuerySort        AS CHAR NO-UNDO.
DEF VAR cFilterFields     AS CHAR NO-UNDO.
DEF VAR cGroupDef         AS CHAR NO-UNDO.
DEF VAR iGroupCnt         AS INT  NO-UNDO.
DEF VAR iSubSeqCnt        AS INT  NO-UNDO.
DEF VAR cFilterDef        AS CHAR NO-UNDO.
DEF VAR clParams          AS LONGCHAR NO-UNDO.
DEF VAR cParams           AS CHAR NO-UNDO.
DEF VAR bOk               AS LOG  NO-UNDO.
DEF VAR cJboxPrescan      AS CHAR NO-UNDO.
DEF VAR cPrescanTableList AS CHAR NO-UNDO.
DEF VAR ix                AS INT  NO-UNDO.

DEF BUFFER ttJBoxUserSetting FOR TEMP-TABLE ttJBoxUserSetting.

EMPTY TEMP-TABLE ttAPIparams.
EMPTY TEMP-TABLE ttAPIfieldGroup.

IF NOT ttViewDs.SourceType MATCHES "*sql*" THEN
  DYNAMIC-FUNCTION("setActiveASconnection",ttViewDs.SourceName).  

CREATE ttAPIparams.
ASSIGN ttAPIparams.buffersAndFields = getBuffersAndFields(NO)
       ttAPIparams.queryJoin        = LEFT-TRIM(getQueryJoin("",""),"where false")
       ttAPIparams.method           = "query"
       ttAPIparams.baseQuery        = getBaseQuery()
       ttAPIparams.sessionid        = DYNAMIC-FUNCTION("getSessionId")
       ttAPIparams.dataSource       = ttViewDs.SourceName
       ttAPIparams.altPrimaryBufferList = getAltPrimaryBuffers()
       .

FOR EACH ttJBoxUserSetting
    WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
      AND ttJBoxUserSetting.cObjectName = icObjectName
      AND ttJBoxUserSetting.cSetting NE "" 
      AND ttJBoxUserSetting.cSetting NE ?
    BY ttJBoxUserSetting.cSettingName   
    :
  CASE ttJBoxUserSetting.cSettingName:
    WHEN "1stSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting. 
    WHEN "1stSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
    WHEN "2ndSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + "," + ttJBoxUserSetting.cSetting. 
    WHEN "2ndSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
    WHEN "3rdSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + "," + ttJBoxUserSetting.cSetting. 
    WHEN "3rdSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
    WHEN "4thSortColumn" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + "," + ttJBoxUserSetting.cSetting. 
    WHEN "4thSortColumnDesc" THEN
      cQuerySort = ttJBoxUserSetting.cSetting + ";" + ttJBoxUserSetting.cSetting. 
    WHEN "distinctcolumns" THEN
      ttAPIparams.distinctColumns = ttJBoxUserSetting.cSetting.
    WHEN "accumfields" THEN
      ttAPIparams.accumFields = ttJBoxUserSetting.cSetting.
    WHEN "rowsToBatch" THEN
      ttAPIparams.batchSize = INT(ttJBoxUserSetting.cSetting).
  END.
  IF NUM-ENTRIES(ttJBoxUserSetting.cSettingName,"_") > 1 THEN 
    CASE SUBSTR(ttJBoxUserSetting.cSettingName,1,11):
      WHEN "FieldGroup_" THEN DO:
        CREATE ttAPIfieldGroup.
        ASSIGN ttAPIfieldGroup.fieldGroup = cSetting
               ttAPIfieldGroup.groupField = SUBSTR(ttJBoxUserSetting.cSettingName,12)
               .
        IF CAN-DO("1,2,3,4,5,6,7,8,9",SUBSTR(ttAPIfieldGroup.groupField,1,1))
           AND SUBSTR(ttAPIfieldGroup.groupField,2,1) = "_" THEN       
          ASSIGN ttAPIfieldGroup.fieldName = SUBSTR(ttAPIfieldGroup.groupField,3)
                 ttAPIfieldGroup.iSeq      = 1
                 .  
        ELSE 
          ASSIGN ttAPIfieldGroup.fieldName = ttAPIfieldGroup.groupField
                 ttAPIfieldGroup.iSeq      = -1
                 .  
      END.  
    END CASE.
END.

ttAPIparams.querySort = cQuerySort.

FOR EACH ttAPIfieldGroup 
    BY ttAPIfieldGroup.fieldGroup
    :
  FIND FIRST ttJBoxUserSetting
       WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
         AND ttJBoxUserSetting.cObjectName = icObjectName
         AND ttJBoxUserSetting.cSettingName = "FieldOperator_" + ttAPIfieldGroup.groupField // AND / OR
         .
  iSubSeqCnt = iSubSeqCnt + 1.
         
  ASSIGN ttAPIfieldGroup.groupFieldOper = ttJBoxUserSetting.cSetting
         ttAPIfieldGroup.FieldOperator = YES
         ttAPIfieldGroup.iSubSeq = iSubSeqCnt.                 

  FIND FIRST ttJBoxUserSetting
       WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
         AND ttJBoxUserSetting.cObjectName = icObjectName
         AND ttJBoxUserSetting.cSettingName = "OperatorInUse_" + ttAPIfieldGroup.groupField // = / <>..
         NO-ERROR.
  IF AVAIL ttJBoxUserSetting THEN       
    ASSIGN ttAPIfieldGroup.groupFieldOperInUse = ttJBoxUserSetting.cSetting
           ttAPIfieldGroup.OperatorInUse = YES
           ttAPIfieldGroup.iSubSeq = iSubSeqCnt.                 

  FIND FIRST ttJBoxUserSetting
       WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
         AND ttJBoxUserSetting.cObjectName = icObjectName
         AND ttJBoxUserSetting.cSettingName = "filtervalue_" + ttAPIfieldGroup.groupField
         NO-ERROR.
  IF AVAIL ttJBoxUserSetting THEN       
    ASSIGN ttAPIfieldGroup.groupFieldValue = ttJBoxUserSetting.cSetting
           ttAPIfieldGroup.filtervalue = YES
           ttAPIfieldGroup.iSubSeq = iSubSeqCnt.                 
END.

// Extract filter setting (group = 0)

FOR EACH ttAPIfieldGroup
    WHERE ttAPIfieldGroup.fieldGroup = "0"
      AND ttAPIfieldGroup.OperatorInUse // field with active operator (=/<>..)
    BY ttAPIfieldGroup.iSubSeq:
  cFilterDef = cFilterDef + (IF cFilterDef NE "" THEN "," ELSE "") + ttAPIfieldGroup.fieldName.
END.          

IF cFilterDef NE "" THEN cFilterDef = cFilterDef + ";".

FOR EACH ttAPIfieldGroup
    WHERE ttAPIfieldGroup.fieldGroup = "0"
      AND ttAPIfieldGroup.OperatorInUse // operators in use (=,<>..
    BY ttAPIfieldGroup.iSubSeq:
  cFilterDef = cFilterDef + ttAPIfieldGroup.groupFieldOperInUse + ",".
END.          

IF cFilterDef NE "" THEN cFilterDef = SUBSTR(cFilterDef,1,LENGTH(cFilterDef) - 1) + ";".

FOR EACH ttAPIfieldGroup
    WHERE ttAPIfieldGroup.fieldGroup = "0"
      AND ttAPIfieldGroup.filtervalue // filter values
    BY ttAPIfieldGroup.iSubSeq:
  cFilterDef = cFilterDef + ttAPIfieldGroup.groupFieldValue + "|".
END.          
IF cFilterDef NE "" THEN
  ttAPIparams.queryFilter = SUBSTR(cFilterDef,1,LENGTH(cFilterDef) - 1).


// Extract filter group settings (group > 0)

DO iGroupCnt = 1 TO 9:
  cGroupDef = "".
  FOR EACH ttAPIfieldGroup
      WHERE ttAPIfieldGroup.fieldGroup = STRING(iGroupCnt)
        AND ttAPIfieldGroup.FieldOperator // field names with field operators (and/or)
      BY ttAPIfieldGroup.iSeq  
      BY ttAPIfieldGroup.iSubSeq:
    IF cGroupDef = "" THEN DO:
      FIND FIRST ttJBoxUserSetting
           WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
             AND ttJBoxUserSetting.cObjectName = icObjectName
             AND ttJBoxUserSetting.cSettingName = "GroupOperator_" + ttAPIfieldGroup.fieldName
           .
      cGroupDef = ttJBoxUserSetting.cSetting + "(" + ttAPIfieldGroup.fieldName.     
    END.
    ELSE DO:
      FIND FIRST ttJBoxUserSetting
           WHERE ttJBoxUserSetting.ViewDsId = ttViewDs.ViewDsId
             AND ttJBoxUserSetting.cObjectName = icObjectName
             AND ttJBoxUserSetting.cSettingName = "FieldGroup_" + ttAPIfieldGroup.fieldName
           .
      cGroupDef = cGroupDef + "," + ttAPIfieldGroup.groupFieldOper + " " + ttAPIfieldGroup.fieldName.
    END.  
  END.          
  
  IF cGroupDef NE "" THEN cGroupDef = cGroupDef + ";".
  
  FOR EACH ttAPIfieldGroup
      WHERE ttAPIfieldGroup.fieldGroup = STRING(iGroupCnt)
        AND ttAPIfieldGroup.OperatorInUse // operators in use (=,<>..
      BY ttAPIfieldGroup.iSeq  
      BY ttAPIfieldGroup.iSubSeq:
    cGroupDef = cGroupDef + ttAPIfieldGroup.groupFieldOperInUse + ",".
  END.          
  
  IF cGroupDef NE "" THEN cGroupDef = SUBSTR(cGroupDef,1,LENGTH(cGroupDef) - 1) + ";".
  
  FOR EACH ttAPIfieldGroup
      WHERE ttAPIfieldGroup.fieldGroup = STRING(iGroupCnt)
        AND ttAPIfieldGroup.filtervalue // filter values
      BY ttAPIfieldGroup.iSeq  
      BY ttAPIfieldGroup.iSubSeq:
    cGroupDef = cGroupDef + ttAPIfieldGroup.groupFieldValue + "|".
  END.          
  IF cGroupDef NE "" THEN
    BUFFER ttAPIparams:BUFFER-FIELD("queryFilterGroup" + STRING(iGroupCnt)):BUFFER-VALUE = SUBSTR(cGroupDef,1,LENGTH(cGroupDef) - 1).
  ELSE  
    BUFFER ttAPIparams:BUFFER-FIELD("queryFilterGroup" + STRING(iGroupCnt)):SERIALIZE-HIDDEN = YES.
END.

IF NOT ttViewDs.SourceType MATCHES "*sql*" THEN DO:
  BUFFER ttAPIparams:BUFFER-FIELD("dataSource"):SERIALIZE-HIDDEN = YES.

  cJboxPrescan = getPrescanQueries("").
  IF cJboxPrescan NE "" THEN DO:
    ASSIGN cPrescanTableList = ENTRY(1,cJboxPrescan,"¤")
           cJboxPrescan = ENTRY(2,cJboxPrescan,"¤").
    DO ix = 1 TO MIN(9,NUM-ENTRIES(cPrescanTableList)):
      BUFFER ttAPIparams:BUFFER-FIELD("prescanQuery" + STRING(ix)):SERIALIZE-NAME = "prescanQuery" + ENTRY(ix,cPrescanTableList).
      BUFFER ttAPIparams:BUFFER-FIELD("prescanQuery" + STRING(ix)):BUFFER-VALUE = ENTRY(ix,cJboxPrescan,"|").
    END.
    DO ix = 1 TO 9:
      IF BUFFER ttAPIparams:BUFFER-FIELD("prescanQuery" + STRING(ix)):BUFFER-VALUE = "" THEN
        BUFFER ttAPIparams:BUFFER-FIELD("prescanQuery" + STRING(ix)):SERIALIZE-HIDDEN = YES.
    END.
  END.  
END.
ELSE DO: 
  DO ix = 1 TO 9:
    BUFFER ttAPIparams:BUFFER-FIELD("prescanQuery" + STRING(ix)):SERIALIZE-HIDDEN = YES.
  END.
  ttAPIparams.prescanBaseQuery = getSqlSubQueries("","").
END.  
  
DO ix = 1 TO BUFFER ttAPIparams:NUM-FIELDS:
  IF BUFFER ttAPIparams:BUFFER-FIELD(ix):DATA-TYPE = "CHARACTER" THEN
    BUFFER ttAPIparams:BUFFER-FIELD(ix):BUFFER-VALUE = REPLACE(REPLACE(BUFFER ttAPIparams:BUFFER-FIELD(ix):BUFFER-VALUE,"[","\u0091"),"]","\u0093").
END.    

FIX-CODEPAGE(clParams) = "utf-8".
BUFFER ttAPIparams:WRITE-JSON ("longchar",clParams,yes).

cParams = STRING(clParams).
cParams = TRIM(LEFT-TRIM(ENTRY(1,ENTRY(2,cParams,"["),"]"),CHR(10))).

IF ibView THEN
  RUN JBoxDEditor.w (INPUT-OUTPUT cParams,NO,NO,NO,"API parameters",OUTPUT bOK).

RETURN cParams.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBaseQuery C-Win 
FUNCTION getBaseQuery RETURNS CHARACTER
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
RETURN ttViewDs.BaseQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBuffersAndFields C-Win 
FUNCTION getBuffersAndFields RETURNS CHARACTER (INPUT ibLabelFormatPos AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
bLabelFormatPos = ibLabelFormatPos.

RETURN getChildBuffersAndFields("", ttViewDs.BaseDb + "." + ttViewDs.BaseTable).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalcOperSuggestion C-Win 
FUNCTION getCalcOperSuggestion RETURNS CHARACTER
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    RETURN cCalcOperSuggestion.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getChildBuffersAndFields C-Win 
FUNCTION getChildBuffersAndFields RETURNS CHARACTER
  ( INPUT icBuffersAndFields AS CHARACTER,
    INPUT icTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttViewDsTable FOR TEMP-TABLE ttViewDsTable.
DEF BUFFER ttViewDsField FOR TEMP-TABLE ttViewDsField.

DEF VAR bFieldsFound AS LOG NO-UNDO.
DEF VAR bOnlyThisTable AS LOG NO-UNDO.

IF icBuffersAndFields = "-" THEN
  ASSIGN bOnlyThisTable = YES
         icBuffersAndFields = "".


FOR EACH ttViewDsField 
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsField.ViewDsDb    = ENTRY(1,icTable,".")
      AND ttViewDsField.ViewDsTable = ENTRY(2,icTable,".")
    BREAK BY ttViewDsField.ViewDsTable
    BY ttViewDsField.ViewDsFieldSeq
    :
    
  bFieldsFound = YES.
    
  IF FIRST-OF(ttViewDsField.ViewDsTable) THEN DO: 
    FIND FIRST ttViewDsTable
         WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
           AND ttViewDsTable.ViewDsDb = ttViewDsField.ViewDsDb
           AND ttViewDsTable.ViewDsTable = ttViewDsField.ViewDsTable
         NO-ERROR.     
    icBuffersAndFields = icBuffersAndFields + (IF icBuffersAndFields NE "" THEN "," ELSE "")
                       + (IF AVAIL ttViewDsTable AND ttViewDsTable.ViewDsTableNotExist THEN
                            "NOT EXIST " 
                          ELSE "") 
                       + ttViewDsField.ViewDsDb + "." + ttViewDsField.ViewDsTable.
  END.                     
                
  IF CAN-DO("filterlookup,filterdropdown",ENTRY(1,ttViewDsField.ViewDsFieldFunction,";")) OR ttViewDsField.ViewDsFieldFunction = "" THEN
    icBuffersAndFields = icBuffersAndFields + ";" 
                       + (IF ttViewDsField.ViewDsFieldHidden THEN "!" ELSE "")
                       + ttViewDsField.ViewDsFieldName   
                       + (IF bLabelFormatPos THEN
                           "|" + (IF ttViewDsField.ViewDsFieldLabel NE "" AND ttViewDsField.ViewDsFieldLabel NE ? THEN 
                                    REPLACE(ttViewDsField.ViewDsFieldLabel,",","%2C") 
                                  ELSE ttViewDsField.ViewDsFieldName)
                         + "|" + REPLACE(ttViewDsField.ViewDsFieldFormat,",","<")
                         + "@" + STRING(ttViewDsField.ViewDsFieldSeq)
                         ELSE "")
                       .
  ELSE                     
    icBuffersAndFields = icBuffersAndFields + ";" 
                       + (IF ttViewDsField.ViewDsFieldHidden THEN "!" ELSE "")
                       + "+"
                       + ttViewDsField.ViewDsFieldName   
                       + "|" + ttViewDsField.ViewDsFieldType
                       + "|" + REPLACE(ttViewDsField.ViewDsFieldFormat,",","<")
                       + "|" + REPLACE(ttViewDsField.ViewDsFieldFunction,",","\002C")
                       + (IF bLabelFormatPos THEN
                           "|" + (IF ttViewDsField.ViewDsFieldLabel NE "" AND ttViewDsField.ViewDsFieldLabel NE ? THEN 
                                    REPLACE(ttViewDsField.ViewDsFieldLabel,",","%2C") 
                                  ELSE ttViewDsField.ViewDsFieldName) 
                         + "@" + STRING(ttViewDsField.ViewDsFieldSeq)
                         ELSE "")
                       .
END.

IF NOT bFieldsFound THEN do:
  FOR EACH tt_db
      WHERE tt_db.cSourceName = ttViewDs.SourceName
     ,EACH tt_file
           WHERE tt_file.iDbNum   = tt_db.iDbNum 
             AND tt_file.cLDBname = ENTRY(1,icTable,".")
             AND tt_file.cFile-Name = RealTable(ENTRY(2,icTable,"."))
    ,EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
     :     
    FIND FIRST ttViewDsTable
         WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
           AND ttViewDsTable.ViewDsDb = tt_file.cLDBname
           AND ttViewDsTable.ViewDsTable = tt_file.cFile-Name
         NO-ERROR.     

    icBuffersAndFields = icBuffersAndFields + (IF icBuffersAndFields NE "" THEN "," ELSE "")
                       + (IF AVAIL ttViewDsTable AND ttViewDsTable.ViewDsTableNotExist THEN "NOT EXIST " ELSE "") 
                       + tt_file.cLDBname + "." + ENTRY(2,icTable,".")
                       + ";!"
                       + tt_field.cField-Name.                
    LEAVE.
  END.                      
END.   

IF NOT bOnlyThisTable THEN
  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsTable.ViewDsParentDb = ENTRY(1,icTable,".")
        AND ttViewDsTable.ViewDsParentTable = ENTRY(2,icTable,".")
      BY ttViewDsTable.ViewDsTable:
    icBuffersAndFields = getChildBuffersAndFields(icBuffersAndFields,ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable).
  END.      

RETURN icBuffersAndFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceIsSql C-Win 
FUNCTION getDataSourceIsSql RETURNS LOGICAL
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  IF AVAIL ttViewDs THEN    
    RETURN ttViewDs.SourceType MATCHES "*sql*".
  ELSE RETURN NO.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDbPrefix C-Win 
FUNCTION getDbPrefix RETURNS CHARACTER
  ( INPUT icTable AS CHAR,
    INPUT icDb    AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose: Check if tablename is unique within datasource - if not return db.
 Notes:
------------------------------------------------------------------------------*/
DEF BUFFER tt_db   FOR tt_db.
DEF BUFFER tt_file FOR tt_file.

DEF VAR ix AS INT NO-UNDO.

IF ttViewDs.SourceType MATCHES "*sql*" THEN RETURN "".

FOR EACH tt_db
    WHERE tt_db.cSourceName = ttViewDs.SourceName
/*    ,EACH tt_file                            */
/*          WHERE tt_file.iDbNum = tt_db.iDbNum*/
/*            AND tt_file.cFile-Name = icTable */
   :
  ix = ix + 1.
END.
IF ix > 1 THEN RETURN icDb + ".".        
ELSE RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJoinCrit C-Win 
FUNCTION getJoinCrit RETURNS CHARACTER
  ( INPUT icJoinFields AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR cExpr   AS CHAR NO-UNDO.
  DEF VAR cEntry  AS CHAR NO-UNDO.
  DEF VAR ix      AS INT  NO-UNDO.
  
  icJoinFields = TRIM(icJoinFields,CHR(10)).
  DO ix = 1 TO NUM-ENTRIES(icJoinFields,CHR(10)):
    cEntry = ENTRY(ix,icJoinFields,CHR(10)).
    IF cEntry MATCHES "* and" THEN cEntry = SUBSTR(cEntry,1,LENGTH(cEntry) - 4).
    cExpr = cExpr + (IF cExpr NE "" THEN " AND " ELSE "") + cEntry.
  END.
  
  RETURN cExpr.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getJoinCritRev C-Win 
FUNCTION getJoinCritRev RETURNS CHARACTER
  ( INPUT icJoinFields AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR cExpr      AS CHAR NO-UNDO.
  DEF VAR cEntry     AS CHAR NO-UNDO.
  DEF VAR ix         AS INT  NO-UNDO.
  DEF VAR cExpRight  AS CHAR NO-UNDO.
  DEF VAR cTable     AS CHAR NO-UNDO.
  DEF VAR cRealTable AS CHAR NO-UNDO.
  
  icJoinFields = TRIM(icJoinFields,CHR(10)).
  DO ix = 1 TO NUM-ENTRIES(icJoinFields,CHR(10)):
    cEntry = ENTRY(ix,icJoinFields,CHR(10)).
    IF cEntry MATCHES "* and" THEN cEntry = SUBSTR(cEntry,1,LENGTH(cEntry) - 4).
    cExpr = cExpr + (IF cExpr NE "" THEN " AND " ELSE "").
    IF NUM-ENTRIES(cEntry,"=") = 2 THEN DO:
      cExpRight = ENTRY(2,cEntry,"=").
      cRealTable = "".
      IF NUM-ENTRIES(cExpRight,".") > 2 THEN
        cRealTable = RealTable(ENTRY(2,cExpRight,".")).
      ELSE IF NUM-ENTRIES(cExpRight,".") = 2 THEN
        cRealTable = RealTable(ENTRY(1,cExpRight,".")).
      IF cRealTable NE "" THEN  
        cExpr = cExpr + ENTRY(2,cEntry,"=") + " = " + ENTRY(1,cEntry,"=").
      ELSE cExpr = cExpr + cEntry.
    END.    
    ELSE cExpr = cExpr + cEntry.
  END.
  
  RETURN cExpr.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLookupTtHandle C-Win 
FUNCTION getLookupTtHandle RETURNS HANDLE
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
RETURN TEMP-TABLE ttTableLookup:HANDLE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getParentDataSource C-Win 
FUNCTION getParentDataSource RETURNS CHARACTER
  ( INPUT icDb AS CHAR,
    INPUT icTable AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttViewDsTable FOR ttViewDsTable.
DEF BUFFER ttParent      FOR ttViewDsTable.

FIND FIRST ttViewDsTable
     WHERE ttViewDsTable.ViewDsDb = icDb
       AND ttViewDsTable.ViewDsTable = icTable
     NO-ERROR.
IF AVAIL ttViewDsTable THEN DO:
  IF ttViewDsTable.ViewDsParentDb = ttViewDs.BaseDb AND ttViewDsTable.ViewDsParentTable = ttViewDs.BaseTable THEN
    RETURN ttViewDs.SourceName.
  ELSE DO:  
    FIND FIRST ttParent
         WHERE ttParent.ViewDsDb = ttViewDsTable.ViewDsParentDb
           AND ttParent.ViewDsTable = ttViewDsTable.ViewDsParentTable
         NO-ERROR.
    IF AVAIL ttParent THEN RETURN ttParent.SourceName.
  END.                
END.

RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrescanQueries C-Win 
FUNCTION getPrescanQueries RETURNS CHARACTER
  ( INPUT icSourceName AS CHAR):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cPrescanQueryList AS CHAR NO-UNDO.
DEF VAR cTableList        AS CHAR NO-UNDO.  

DEF BUFFER ttViewDsTable FOR TEMP-TABLE ttViewDsTable.

FOR EACH ttViewDsTable
    WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
      AND (IF icSourceName NE "" THEN
             ttViewDsTable.SourceName = icSourceName 
/*             AND ttViewDsTable.ViewDsParentDb = icDb      */
/*             AND ttViewDsTable.ViewDsParentTable = icTable*/
           ELSE TRUE)
    :
  cPrescanQueryList = cPrescanQueryList + (IF cPrescanQueryList NE "" THEN "|" ELSE "")
                    + getPrescanQuery("",icSourceName,ttViewDsTable.ViewDsDb,ttViewDsTable.ViewDsTable)
                    .
  cTableList = cTableList + (IF cTableList NE "" THEN "," ELSE "") + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable.                  
END.  

RETURN cTableList + (IF cTableList NE "" THEN "¤" ELSE "") + cPrescanQueryList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPrescanQuery C-Win 
FUNCTION getPrescanQuery RETURNS CHARACTER
  ( INPUT icPrescan    AS CHAR
   ,INPUT icSourceName AS CHAR
   ,INPUT icDb         AS CHAR 
   ,INPUT icTable      AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF BUFFER ttViewDsTable FOR TEMP-TABLE ttViewDsTable.

FIND FIRST ttViewDsTable
     WHERE ttViewDsTable.ViewDsId    = ttViewDs.ViewDsId
       AND ttViewDsTable.ViewDsDb    = icDb
       AND ttViewDsTable.ViewDsTable = icTable
       AND (IF icSourceName NE "" THEN ttViewDsTable.SourceName = icSourceName ELSE TRUE)
     NO-ERROR.
IF AVAIL ttViewDsTable AND ttViewDsTable.ViewDsParentTable NE "" THEN DO:
  icPrescan = icPrescan + (IF icPrescan NE "" THEN "," ELSE "")
            + "EACH " + ttViewDsTable.ViewDsParentDb + "." + ttViewDsTable.ViewDsParentTable + " NO-LOCK "
            + (IF NOT TRIM(ttViewDsTable.ViewDsTableQuery) BEGINS "WHERE" THEN " WHERE " ELSE " ")
            + getJoinCritRev(ttViewDsTable.ViewDsTableQuery). // ttViewDsTable.ViewDsTableQuery.
  icPrescan = getPrescanQuery(icPrescan,icSourceName,ttViewDsTable.ViewDsParentDb,ttViewDsTable.ViewDsParentTable).
END.                     

RETURN icPreScan.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryJoin C-Win 
FUNCTION getQueryJoin RETURNS CHARACTER
        (INPUT icQueryJoin AS CHAR,
         INPUT icParentTable AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttViewDsTable FOR TEMP-TABLE ttViewDsTable.

IF icParentTable = "" THEN 
  ASSIGN icParentTable = ttViewDs.BaseTable
         icQueryJoin = "WHERE FALSE".

FOR EACH ttViewDsTable
    WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsTable.ViewDsParentTable = icParentTable
    BY ttViewDsTable.ViewDsTable:
   icQueryJoin = icQueryJoin + "," 
               + (IF ttViewDsTable.ViewDsTableNotExist THEN "FIRST" ELSE ttViewDsTable.ViewDsTableJoinType) 
               + " " + ttViewDsTable.ViewDsDb + "." + ttViewDsTable.ViewDsTable
               + " NO-LOCK WHERE " + getJoinCrit(ttViewDsTable.ViewDsTableQuery)
               + (IF ttViewDsTable.ViewDsTableOuterJoin THEN " OUTER-JOIN" ELSE "")
               . 
   icQueryJoin = getQueryJoin(icQueryJoin,ttViewDsTable.ViewDsTable).
END.      


RETURN icQueryJoin.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRelationFields C-Win 
FUNCTION getRelationFields RETURNS CHARACTER
  ( INPUT icParentDb AS CHAR,
    INPUT icParentTable AS CHAR,
    INPUT icDb AS CHAR,
    INPUT icTable AS CHAR,
    INPUT icRelType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF BUFFER ttViewDsTable FOR ttViewDsTable.

DEF VAR cFieldRel       AS CHAR NO-UNDO.
DEF VAR cRel            AS CHAR NO-UNDO.
DEF VAR ix              AS INT  NO-UNDO.
DEF VAR cRelParentDb    AS CHAR NO-UNDO.
DEF VAR cRelChildDb     AS CHAR NO-UNDO.
DEF VAR cRelParentTable AS CHAR NO-UNDO.
DEF VAR cRelChildTable  AS CHAR NO-UNDO.

IF icRelType BEGINS "child" THEN // get list of mandatory fields for parent buffer in dataset based on defined child relations
  FOR EACH ttViewDsTable
      WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
        AND ttViewDsTable.ViewDsParentDb = icParentDb
        AND ttViewDsTable.ViewDsParentTable = icParentTable
        AND (IF icDb NE "" THEN ttViewDsTable.ViewDsDb = icDb ELSE TRUE)
        AND (IF icTable NE "" THEN ttViewDsTable.ViewDsTable = icTable ELSE TRUE)
      :
    DO ix = 1 TO NUM-ENTRIES(ttViewDsTable.ViewDsTableQuery,CHR(10)):
      cFieldRel = ENTRY(ix,ttViewDsTable.ViewDsTableQuery,CHR(10)).
      REPEAT WHILE INDEX(cFieldRel,"  ") > 0:
        cFieldRel = REPLACE(cFieldRel,"  "," ").
      END.
      IF NUM-ENTRIES(cFieldRel," ") = 3 
         AND NUM-ENTRIES(ENTRY(1,cFieldRel," "),".") GE 2
         AND ENTRY(2,cFieldRel," ") = "="
         AND NUM-ENTRIES(ENTRY(3,cFieldRel," "),".") GE 2
          THEN DO:

        // Assumes parent reference on right side of equation
        IF NUM-ENTRIES(ENTRY(3,cFieldRel," "),".") = 3 THEN
          ASSIGN cRelParentDb    = ENTRY(1,ENTRY(3,cFieldRel," "),".")
                 cRelParentTable = ENTRY(2,ENTRY(3,cFieldRel," "),".")
                 .
        ELSE IF NUM-ENTRIES(ENTRY(3,cFieldRel," "),".") = 2 THEN
          ASSIGN cRelParentDb    = icParentDb
                 cRelParentTable = ENTRY(1,ENTRY(3,cFieldRel," "),".")
                 .
        ELSE         
          ASSIGN cRelParentDb    = icParentDb
                 cRelParentTable = icParentTable
                 .
  
        IF NUM-ENTRIES(ENTRY(1,cFieldRel," "),".") = 3 THEN
          ASSIGN cRelChildDb    = ENTRY(1,ENTRY(1,cFieldRel," "),".")
                 cRelChildTable = ENTRY(2,ENTRY(1,cFieldRel," "),".")
                 .
        ELSE IF NUM-ENTRIES(ENTRY(1,cFieldRel," "),".") = 2 THEN
          ASSIGN cRelChildDb    = icDb
                 cRelChildTable = ENTRY(1,ENTRY(1,cFieldRel," "),".")
                 .
        ELSE         
          ASSIGN cRelChildDb    = icDb
                 cRelChildTable = icTable
                 .

        ASSIGN cRelChildDb     = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelChildDb,"(")),cRelChildDb,"("))
               cRelChildTable  = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelChildTable,"(")),cRelChildTable,"("))
               cRelParentDb    = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelParentDb,"(")),cRelParentDb,"("))
               cRelParentTable = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelParentTable,"(")),cRelParentTable,"("))
               .         
            
        IF cRelParentDb = icParentDb AND cRelParentTable = icParentTable THEN
          cRel = cRel  
               + (IF cRel NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(3,cFieldRel," "),"."),ENTRY(3,cFieldRel," "),"."),")") // child field
               .
        ELSE       
          cRel = cRel 
               + (IF cRel NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(1,cFieldRel," "),"."),ENTRY(1,cFieldRel," "),"."),")") // child field
               .
      END.  
    END.
    IF icRelType = "childWithDS" THEN
      cRel = cRel + ";" + ttViewDsTable.SourceName + ";" + ttViewDsTable.ViewDsDb + ";" + ttViewDsTable.ViewDsTable.       
  END.
ELSE DO:
  FIND FIRST ttViewDsTable 
       WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
         AND ttViewDsTable.ViewDsDb = icDb
         AND ttViewDsTable.ViewDsTable = icTable
       .     
  DO ix = 1 TO NUM-ENTRIES(ttViewDsTable.ViewDsTableQuery,CHR(10)):
    cFieldRel = ENTRY(ix,ttViewDsTable.ViewDsTableQuery,CHR(10)).
    REPEAT WHILE INDEX(cFieldRel,"  ") > 0:
      cFieldRel = REPLACE(cFieldRel,"  "," ").
    END.
    IF NUM-ENTRIES(cFieldRel," ") = 3 
       AND NUM-ENTRIES(ENTRY(1,cFieldRel," "),".") GE 2
       AND ENTRY(2,cFieldRel," ") = "="
       AND NUM-ENTRIES(ENTRY(3,cFieldRel," "),".") GE 2
        THEN DO:

      IF icParentDb    = "" THEN icParentDb = icDb.
      IF icParentTable = "" THEN icParentTable = icTable.
    
      // Assumes parent reference on right side of equation
      IF NUM-ENTRIES(ENTRY(3,cFieldRel," "),".") = 3 THEN
        ASSIGN cRelParentDb    = ENTRY(1,ENTRY(3,cFieldRel," "),".")
               cRelParentTable = ENTRY(2,ENTRY(3,cFieldRel," "),".")
               .
      ELSE IF NUM-ENTRIES(ENTRY(3,cFieldRel," "),".") = 2 THEN
        ASSIGN cRelParentDb    = icParentDb
               cRelParentTable = ENTRY(1,ENTRY(3,cFieldRel," "),".")
               .
      ELSE 
        ASSIGN cRelParentDb    = icParentDb
               cRelParentTable = icParentTable
               .

      IF NUM-ENTRIES(ENTRY(1,cFieldRel," "),".") = 3 THEN
        ASSIGN cRelChildDb    = ENTRY(1,ENTRY(1,cFieldRel," "),".")
               cRelChildTable = ENTRY(2,ENTRY(1,cFieldRel," "),".")
               .
      ELSE IF NUM-ENTRIES(ENTRY(1,cFieldRel," "),".") = 2 THEN
        ASSIGN cRelChildDb    = icDb
               cRelChildTable = ENTRY(1,ENTRY(1,cFieldRel," "),".")
               .
      ELSE 
        ASSIGN cRelChildDb    = icDb
               cRelChildTable = icTable
               .
               
      ASSIGN cRelChildDb     = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelChildDb,"(")),cRelChildDb,"("))
             cRelChildTable  = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelChildTable,"(")),cRelChildTable,"("))
             cRelParentDb    = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelParentDb,"(")),cRelParentDb,"("))
             cRelParentTable = TRIM(ENTRY(MAX(1,NUM-ENTRIES(cRelParentTable,"(")),cRelParentTable,"("))
             .         
      
      IF icRelType = "parent" THEN DO: // get list of fields mandatory fields for child buffer to be able to relate to parent   
        IF cRelParentDb = icDb AND cRelParentTable = icTable THEN
          cRel = cRel  
               + (IF cRel NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(3,cFieldRel," "),"."),ENTRY(3,cFieldRel," "),"."),")") // child field
               .
        ELSE IF cRelChildDb = icDb AND cRelChildTable = icTable THEN      
          cRel = cRel 
               + (IF cRel NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(1,cFieldRel," "),"."),ENTRY(1,cFieldRel," "),"."),")") // child field
               .
      END.
      ELSE DO: // get pairs list for adding the a relation to the dataset
        IF cRelParentDb = ttViewDsTable.ViewDsParentDb AND cRelParentTable = ttViewDsTable.ViewDsParentTable THEN
          cRel = cRel 
               + (IF cRel NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(3,cFieldRel," "),"."),ENTRY(3,cFieldRel," "),"."),")") // parent field
               + "," + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(1,cFieldRel," "),"."),ENTRY(1,cFieldRel," "),"."),")"). // child field
        ELSE       
          cRel = cRel 
               + (IF cRel NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(1,cFieldRel," "),"."),ENTRY(1,cFieldRel," "),"."),")") // parent field
               + "," + ENTRY(1,ENTRY(NUM-ENTRIES(ENTRY(3,cFieldRel," "),"."),ENTRY(3,cFieldRel," "),"."),")"). // child field
      END.           
    END.  
  END.       
END.    
  
RETURN cRel.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRelTableFromJoin C-Win 
FUNCTION getRelTableFromJoin RETURNS CHARACTER
  ( INPUT icProbableParent  AS CHAR,
    INPUT icRelationship    AS CHAR,
    INPUT icJoin            AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR ix       AS INT NO-UNDO.
DEF VAR cJoin    AS CHAR NO-UNDO.
DEF VAR cElement AS CHAR NO-UNDO.
DEF VAR cDbTable AS CHAR NO-UNDO.

DEF BUFFER bViewDsTable FOR ttViewDsTable.

/*MESSAGE "icRelationship" icRelationship skip*/
/*        "icJoin" icJoin skip                */
/*        "icProbableParent" icProbableParent */
/*VIEW-AS ALERT-BOX.                          */
IF icRelationship = "parent" THEN DO:
  DO ix = 1 TO NUM-ENTRIES(icJoin," "):
    cElement = ENTRY(ix,icJoin," ").
    IF NUM-ENTRIES(cElement,".") > 1 AND ENTRY(1,cElement,".") = ENTRY(2,icProbableParent,".") THEN
      cDbTable = ENTRY(1,icProbableParent,".") + "." + ENTRY(1,cElement,".").  
  END.  
  IF cDbTable = "" THEN 
    FOR EACH bViewDsTable:
      DO ix = 1 TO NUM-ENTRIES(icJoin," "):
        cElement = ENTRY(ix,icJoin," ").
        IF NUM-ENTRIES(cElement,".") > 1 AND ENTRY(1,cElement,".") = bViewDsTable.ViewDsTable THEN
          cDbTable = bViewDsTable.ViewDsDb + "." + bViewDsTable.ViewDsTable.
      END.  
    END.  
END.
ELSE
  DO ix = 1 TO NUM-ENTRIES(icJoin," "):
    cElement = ENTRY(ix,icJoin," ").
    IF NUM-ENTRIES(cElement,".") > 1 AND ENTRY(1,cElement,".") NE ENTRY(2,icProbableParent,".") THEN
      cDbTable = ENTRY(1,icProbableParent,".") + "." + ENTRY(1,cElement,".").  
  END.  

RETURN cDbTable.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSortColumn C-Win 
FUNCTION getSortColumn RETURNS CHARACTER () :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttViewDsField FOR ttViewDsField.

FOR EACH ttViewDsField
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
    BY ttViewDsField.ViewDsFieldSeq:
  IF ttViewDsField.ViewDsFieldIndexed THEN
    RETURN ttViewDsField.ViewDsFieldName.
END.      
FOR EACH ttViewDsField
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
    BY ttViewDsField.ViewDsFieldSeq:
  RETURN ttViewDsField.ViewDsFieldName.
END.

RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSqlDb C-Win 
FUNCTION getSqlDb RETURNS CHARACTER ( ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
IF NOT AVAIL ttViewDs AND cCurrViewId NE "" THEN 
  FIND FIRST ttViewDs WHERE ttViewDs.ViewDsId = cCurrViewId NO-ERROR.

IF NOT AVAIL ttViewDs THEN DO:
  MESSAGE "View not available (re-select)"
  VIEW-AS ALERT-BOX.
  RETURN ?.
END.      

FIND FIRST tt_db
     WHERE tt_db.cLDBname     = ttViewDs.BaseDb
       AND tt_db.cSourceName  = ttViewDs.SourceName
     NO-ERROR.
IF AVAIL tt_db AND tt_db.cDbType MATCHES "*sql*" THEN
  RETURN tt_db.cLDBname.     

RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSqlSubQueries C-Win 
FUNCTION getSqlSubQueries RETURNS CHAR
        (INPUT icDb AS CHAR,
         INPUT icTable AS CHAR):
/*------------------------------------------------------------------------------
  Purpose: Fetch subqueries to support FIRST/LAST for Sql. (Sent to server as prescanBaseQuery)
------------------------------------------------------------------------------*/
DEF VAR cSubQueries AS CHAR NO-UNDO.
DEF VAR cJoinCrit   AS CHAR NO-UNDO.
DEF VAR ix          AS INT  NO-UNDO.
DEF VAR cModJoin    AS CHAR NO-UNDO.
DEF VAR cElement    AS CHAR NO-UNDO.  

DEF BUFFER ttViewDsTable FOR TEMP-TABLE ttViewDsTable.

FOR EACH ttViewDsTable
    WHERE ttViewDsTable.ViewDsId = ttViewDs.ViewDsId
      AND CAN-DO("FIRST,LAST",ttViewDsTable.ViewDsTableJoinType)
      AND ttViewDsTable.ViewDsTableFirstLast NE ""
      AND (IF icDb NE "" THEN
            ttViewDsTable.ViewDsParentDb = icDb AND ttViewDsTable.ViewDsParentTable = icTable
           ELSE TRUE)
    :
   cJoinCrit = getJoinCrit(ttViewDsTable.ViewDsTableQuery).
   cModJoin = "".
   DO ix = 1 TO NUM-ENTRIES(cJoinCrit," "):
     cElement = ENTRY(ix,cJoinCrit," ").
     IF NUM-ENTRIES(cElement,".") > 1 AND ENTRY(1,cElement,".") = ttViewDsTable.ViewDsTable THEN
       cElement = "nox_" + cElement.
     cModJoin = cModJoin + (IF cModJoin NE "" THEN " " ELSE "") + cElement.  
   END.     
   cSubQueries = cSubQueries + (IF cSubQueries NE "" THEN "," ELSE "") 
               + "NOT EXISTS (SELECT * FROM " + ttViewDsTable.ViewDsTable 
               + " nox_" + ttViewDsTable.ViewDsTable
               + " WHERE " + cModJoin
               + " AND nox_" + ttViewDsTable.ViewDsTable + "." + ttViewDsTable.ViewDsTableFirstLast
               + (IF ttViewDsTable.ViewDsTableJoinType = "FIRST" THEN " < " ELSE " > ")
               + ttViewDsTable.ViewDsTable + "." + ttViewDsTable.ViewDsTableFirstLast
               + " )".   
END.      

IF cSubQueries NE "" THEN cSubQueries = "<sqlSub>" + cSubQueries + "<sqlSub>".

RETURN cSubQueries.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewDsHandle C-Win 
FUNCTION getViewDsHandle RETURNS HANDLE
  ( ) :
  /*------------------------------------------------------------------------------
    Purpose: This version of the dataset is the master..
  ------------------------------------------------------------------------------*/

  RETURN hdsViewDs.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewDsId C-Win 
FUNCTION getViewDsId RETURNS CHARACTER:
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

RETURN IF AVAIL ttViewDs THEN ttViewDs.ViewDsId ELSE "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getViewDsName C-Win 
FUNCTION getViewDsName RETURNS CHARACTER
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    RETURN cViewDsName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION LastFieldSeq C-Win 
FUNCTION LastFieldSeq RETURNS INTEGER
  ( ) :
  /*------------------------------------------------------------------------------
    Purpose:
  ------------------------------------------------------------------------------*/
  DEF VAR iSeq AS INT NO-UNDO.

  DEF BUFFER ttViewDsField FOR ttViewDsField.

  FOR EACH ttViewDsField WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId BY ttViewDsField.ViewDsFieldSeq DESC: iSeq = ttViewDsField.ViewDsFieldSeq. LEAVE. END.

  RETURN iSeq.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION MoveFlds C-Win 
FUNCTION MoveFlds RETURNS LOGICAL
  ( INPUT icUpDown AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:
  ------------------------------------------------------------------------------*/

  DEF VAR ix         AS INT  NO-UNDO.
  DEF VAR iSeq       AS INT  NO-UNDO.
  DEF VAR cSelList   AS CHAR NO-UNDO.

  DEF VAR bhBuffer   AS HANDLE NO-UNDO.
  DEF VAR qbhBuffer  AS HANDLE NO-UNDO.

  oContainer:freezeContainer().

  CREATE BUFFER bhBuffer FOR TABLE oBrwViewDsField:BUFFER-HANDLE:TABLE-HANDLE.
  CREATE QUERY qbhBuffer.

  qbhBuffer:SET-BUFFERS (bhBuffer).


  DO WITH FRAME {&FRAME-NAME}:
    EMPTY TEMP-TABLE ttSort.

    DO ix = 1 TO oBrwViewDsField:BROWSE-HANDLE:NUM-SELECTED-ROWS:
      IF oBrwViewDsField:BROWSE-HANDLE:FETCH-SELECTED-ROW(ix) THEN DO:
        CREATE ttSort.
        ASSIGN ttSort.iSeq     = ttViewDsField.ViewDsFieldSeq
               ttSort.cRowid   = STRING(ROWID(ttViewDsField))
               cSelList        = cSelList + (IF cSelList NE "" THEN "," ELSE "") + STRING(ttViewDsField.ViewDsFieldSeq)
               .
      END.
    END.
    IF icUpDown = "up" THEN DO:
      FOR EACH ttSort BY iSeq:
        FIND FIRST ttViewDsField WHERE ROWID(ttViewDsField) = TO-ROWID(ttSort.cRowid).
        qbhBuffer:QUERY-PREPARE("FOR EACH " + bhBuffer:NAME + " WHERE ViewDsId = '" + ttViewDs.ViewDsId + "' AND ViewDsFieldSeq < " + STRING(ttSort.iSeq)
          + " AND NOT CAN-DO('" + cSelList + "',STRING(ViewDsFieldSeq))"
          + " BY ViewDsFieldSeq DESC").
        qbhBuffer:QUERY-OPEN ().
        qbhBuffer:GET-FIRST().
        IF NOT bhBuffer:AVAIL THEN RETURN NO.
        LEAVE.
      END.
      FOR EACH ttSort BY ttSort.iSeq DESC:
        FIND FIRST ttViewDsField WHERE ROWID(ttViewDsField) = TO-ROWID(ttSort.cRowid).
        qbhBuffer:QUERY-PREPARE("FOR EACH " + bhBuffer:NAME + " WHERE ViewDsId = '" + ttViewDs.ViewDsId + "' AND ViewDsFieldSeq < " + STRING(ttSort.iSeq)
          + " AND NOT CAN-DO('" + cSelList + "',STRING(ViewDsFieldSeq))"
          + " BY ViewDsFieldSeq DESC").
        qbhBuffer:QUERY-OPEN ().
        qbhBuffer:GET-FIRST().
        IF bhBuffer:AVAIL THEN 
          ASSIGN iSeq = bhBuffer::ViewDsFieldSeq
            bhBuffer::ViewDsFieldSeq = ttViewDsField.ViewDsFieldSeq
            ttViewDsField.ViewDsFieldSeq = iSeq.
      END.
    END.
    ELSE DO:
      FOR EACH ttSort BY ttSort.iSeq DESC:
        FIND FIRST ttViewDsField WHERE ROWID(ttViewDsField) = TO-ROWID(ttSort.cRowid).
        qbhBuffer:QUERY-PREPARE("FOR EACH " + bhBuffer:NAME + " WHERE ViewDsId = '" + ttViewDs.ViewDsId + "' AND ViewDsFieldSeq > " + STRING(ttSort.iSeq)
          + " AND NOT CAN-DO('" + cSelList + "',STRING(ViewDsFieldSeq))"
          + " BY ViewDsFieldSeq").
        qbhBuffer:QUERY-OPEN ().
        qbhBuffer:GET-FIRST().
        IF NOT bhBuffer:AVAIL THEN RETURN NO.
        LEAVE.
      END.
      FOR EACH ttSort BY ttSort.iSeq:
        ix = ix + 1.
        FIND FIRST ttViewDsField WHERE ROWID(ttViewDsField) = TO-ROWID(ttSort.cRowid).
        qbhBuffer:QUERY-PREPARE("FOR EACH " + bhBuffer:NAME + " WHERE ViewDsId = '" + ttViewDs.ViewDsId + "' AND ViewDsFieldSeq > " + STRING(ttSort.iSeq)
          + " AND NOT CAN-DO('" + cSelList + "',STRING(ViewDsFieldSeq))"
          + " BY ViewDsFieldSeq").
        qbhBuffer:QUERY-OPEN ().
        qbhBuffer:GET-FIRST().
        IF bhBuffer:AVAIL THEN 
          ASSIGN iSeq = bhBuffer::ViewDsFieldSeq
            bhBuffer::ViewDsFieldSeq = ttViewDsField.ViewDsFieldSeq
            ttViewDsField.ViewDsFieldSeq = iSeq.
      END.
    END.

    oBrwViewDsField:openQuery().
    oBrwViewDsField:BROWSE-HANDLE:DESELECT-SELECTED-ROW (oBrwViewDsField:BROWSE-HANDLE:FOCUSED-ROW) NO-ERROR.
    FOR EACH ttSort:
      oBrwViewDsField:BROWSE-HANDLE:SET-REPOSITIONED-ROW(oBrwViewDsField:BROWSE-HANDLE:DOWN,"conditional").
      oBrwViewDsField:BROWSE-HANDLE:QUERY:REPOSITION-TO-ROWID(TO-ROWID(ttSort.cRowid)).
      oBrwViewDsField:BROWSE-HANDLE:SELECT-ROW(oBrwViewDsField:BROWSE-HANDLE:FOCUSED-ROW).
    END.

  END.

  RETURN YES.

  FINALLY:
    DELETE OBJECT bhBuffer.
    DELETE OBJECT qbhBuffer.
    oContainer:unFreezeContainer().
  END FINALLY.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RealTable C-Win 
FUNCTION RealTable RETURNS CHARACTER
  ( INPUT icTableName AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

RETURN IF LENGTH(icTableName) > 5 AND icTableName MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(icTableName,4,2)) THEN 
         SUBSTR(icTableName,INDEX(icTableName,"_") + 1)
       ELSE icTableName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION RenumFields C-Win 
FUNCTION RenumFields RETURNS LOGICAL
  ( INPUT ibOpenQuery AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttViewDsField FOR ttViewDsField.

DEF VAR iCount AS INT NO-UNDO.

FOR EACH ttViewDsField 
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
    : 
  ASSIGN ttViewDsField.ViewDsFieldSeq = ttViewDsField.ViewDsFieldSeq - 1000
         iCount = iCount + 1. 
END.

FOR EACH ttViewDsField
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
    BY ttViewDsField.ViewDsFieldSeq DESC
    :
  ASSIGN ttViewDsField.ViewDsFieldSeq = iCount
         iCount = iCount - 1.
END.
IF ibOpenQuery THEN
  oBrwViewDsField:openQuery().

PUBLISH "replaceViewDs".

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION selectFieldPair C-Win 
FUNCTION selectFieldPair RETURNS CHARACTER
  ( INPUT icDsChildName      AS CHAR,
    INPUT icDsChildType      AS CHAR,
    INPUT icChildTable       AS CHAR,
    INPUT icChildDb          AS CHAR,
    INPUT icParentSourceName AS CHAR,
    INPUT icParentSourceType AS CHAR,
    INPUT icParentTable      AS CHAR,
    INPUT icParentDb         AS CHAR,
    INPUT ibIntChar          AS LOG ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR iReturn          AS INT  NO-UNDO.
  DEF VAR cPrompt          AS CHAR NO-UNDO.
  DEF VAR cChildFlds       AS CHAR NO-UNDO.
  DEF VAR cParentFlds      AS CHAR NO-UNDO.
  DEF VAR iSpaceWidth      AS INT  NO-UNDO.
  DEF VAR cValue           AS CHAR NO-UNDO.
  DEF VAR cDataType        AS CHAR NO-UNDO. 
  DEF VAR cParentFieldFunc AS CHAR NO-UNDO.
  DEF VAR cChildFieldFunc  AS CHAR NO-UNDO.
  DEF VAR iNumFlds         AS INT  NO-UNDO. 
  DEF VAR cChildIdxFlds    AS CHAR NO-UNDO.
  DEF VAR cParentIdxFlds   AS CHAR NO-UNDO.
  DEF VAR bIndexed         AS LOG  NO-UNDO.
  DEF VAR ix               AS INT  NO-UNDO.

  IF ibIntChar = ? THEN DO:
    FOR EACH tt_db
        WHERE tt_db.cSourceName = icDsChildName 
          AND tt_db.cSourceType = icDsChildType     
       ,EACH tt_file
             WHERE tt_file.iDbNum = tt_db.iDbNum
               AND tt_file.cLDBname = icChildDb
               AND tt_file.cFile-Name = RealTable(icChildTable)
       ,EACH tt_field
             WHERE tt_field.iFileNum = tt_file.iFileNum
               AND CAN-DO("character,integer,int64",tt_field.cData-Type) 
       :
      bIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,tt_file.cFile-Name,tt_file.cLDBname,ttViewDs.SourceName).
      
      IF bIndexed THEN
        cChildIdxFlds = cChildIdxFlds + (IF cChildIdxFlds NE "" THEN "," ELSE "") + tt_field.cField-Name + "^" + tt_field.cData-Type. 
    END.                  
  
    FOR EACH tt_db
        WHERE tt_db.cSourceName = icParentSourceName
          AND tt_db.cSourceType = icParentSourceType     
       ,EACH tt_file
             WHERE tt_file.iDbNum = tt_db.iDbNum
               AND tt_file.cLDBname = icParentDb
               AND tt_file.cFile-Name = RealTable(icParentTable)
       ,EACH tt_field
             WHERE tt_field.iFileNum = tt_file.iFileNum
               AND CAN-DO("character,integer,int64",tt_field.cData-Type) 
        :            
      bIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,tt_file.cFile-Name,tt_file.cLDBname,ttViewDs.SourceName).
      
      IF bIndexed THEN
        cParentIdxFlds = cParentIdxFlds + (IF cParentIdxFlds NE "" THEN "," ELSE "") + tt_field.cField-Name + "^" + tt_field.cData-Type. 
    END.                  
  
    DO ix = 1 TO NUM-ENTRIES(cChildIdxFlds):
      IF CAN-DO(cParentIdxFlds,ENTRY(ix,cChildIdxFlds)) THEN DO:
        cPrompt = ENTRY(ix,cChildIdxFlds).
        LEAVE. 
      END.  
    END.
  
    IF cPrompt = "" THEN 
      ibIntChar = JBoxSession:Instance:ViewQuestionYesNo("View only integer and character fields when selecting field pair for join?").
    ELSE  
      ibIntChar = YES.
  END.
  
  FOR EACH tt_db
      WHERE tt_db.cSourceName = icDsChildName 
        AND tt_db.cSourceType = icDsChildType     
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.cLDBname = icChildDb
             AND tt_file.cFile-Name = RealTable(icChildTable)
     ,EACH tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND (IF ibIntChar THEN CAN-DO("character,integer,int64",tt_field.cData-Type) 
                  ELSE CAN-DO("character,date,decimal,integer,int64,logical",tt_field.cData-Type))
     :
    iNumFlds = iNumFlds + 1.
  END.                  
        
  FOR EACH tt_db
      WHERE tt_db.cSourceName = icDsChildName
        AND tt_db.cSourceType = icDsChildType     
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.cLDBname = icChildDb
             AND tt_file.cFile-Name = RealTable(icChildTable)
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
                + (IF JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,tt_file.cFile-Name,tt_file.cLDBname,ttViewDs.SourceName) THEN " *" ELSE "")
                + ")|" + tt_field.cField-Name + "^" + tt_field.cData-Type
                .                   
  END.              
  
  iNumFlds = 0.
  FOR EACH tt_db
      WHERE tt_db.cSourceName = icParentSourceName
        AND tt_db.cSourceType = icParentSourceType     
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.cLDBname = icParentDb
             AND tt_file.cFile-Name = RealTable(icParentTable)
     ,EACH tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND (IF ibIntChar THEN CAN-DO("character,integer,int64",tt_field.cData-Type) 
                  ELSE CAN-DO("character,date,decimal,integer,int64,logical",tt_field.cData-Type))
      :            
    iNumFlds = iNumFlds + 1.
  END.                  
  
  FOR EACH tt_db
      WHERE tt_db.cSourceName = icParentSourceName
        AND tt_db.cSourceType = icParentSourceType     
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum
             AND tt_file.cLDBname = icParentDb
             AND tt_file.cFile-Name = RealTable(icParentTable)
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
                + (IF JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name,tt_file.cFile-Name,tt_file.cLDBname,ttViewDs.SourceName) THEN " *" ELSE "")
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
           + getDbPrefix(icChildTable,icChildDb) + ENTRY(1,cChildFlds,"^")
           + (IF cChildFieldFunc NE "" THEN ")" ELSE "")
           + " = " 
           + cParentFieldFunc
           + getDbPrefix(icParentTable,icParentDb) + ENTRY(1,cParentFlds,"^")
           + (IF cParentFieldFunc NE "" THEN ")" ELSE "")
           .
    END.    
    ELSE IF NUM-ENTRIES(cChildFlds,"^") = 2 THEN DO:
      ENTRY(1,cChildFlds,"^") = getDbPrefix(icChildTable,icChildDb) + icChildTable + "." + ENTRY(1,cChildFlds,"^") + " = ".
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
  RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAddExtraTools C-Win 
FUNCTION setAddExtraTools RETURNS LOGICAL
  ( INPUT ibSetExtraTools AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

bSetExtraTools = ibSetExtraTools.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAddQueryBuilderTools C-Win 
FUNCTION setAddQueryBuilderTools RETURNS LOGICAL
  ( INPUT ihReturnQueryDefTo AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
ASSIGN bAddQueryBuilderTools = YES
       hReturnQueryDefTo = ihReturnQueryDefTo.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrDbNum C-Win 
FUNCTION setCurrDbNum RETURNS LOGICAL
  ( INPUT icCurrDb AS CHAR, INPUT icSourceName AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF BUFFER tt_db FOR TEMP-TABLE tt_db.

FIND FIRST tt_db 
     WHERE tt_db.cLDBname = icCurrDb
       AND tt_db.cSourceName = icSourceName
     NO-ERROR.
IF AVAIL tt_db THEN 
  ASSIGN iCurrDbNum = tt_db.iDbNum
         cCurrSourceName = tt_db.cSourceName.   

RETURN AVAIL tt_db.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCurrViewId C-Win 
FUNCTION setCurrViewId RETURNS LOGICAL
  (INPUT icCurrViewId AS CHAR  ):
/*------------------------------------------------------------------------------
 Purpose: Used in batch mode to avoid openquery and such..
 Notes:
------------------------------------------------------------------------------*/
  cCurrViewId = icCurrViewId.
  FIND FIRST ttViewDs
       WHERE ttViewDs.ViewDsId = cCurrViewId
       NO-ERROR.

  RETURN AVAIL ttViewDs.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDropDownDefinitions C-Win 
FUNCTION setDropDownDefinitions RETURNS LOGICAL (INPUT ioBrowseObject AS JBoxBrowse ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR ix            AS INT  NO-UNDO.
DEF VAR cFieldList    AS CHAR NO-UNDO.
DEF VAR cDropDownList AS CHAR NO-UNDO.

DEF BUFFER ttViewDsField FOR TEMP-TABLE ttViewDsField.

FOR EACH ttViewDsField 
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsField.ViewDsFieldFunction BEGINS "filterDropDown"
      AND NUM-ENTRIES(ttViewDsField.ViewDsFieldFunction,";") > 1:
  ASSIGN cDropDownList = ""
         cFieldList = TRIM(ENTRY(2,ttViewDsField.ViewDsFieldFunction,";"),CHR(10)).
  DO ix = 1 TO NUM-ENTRIES(cFieldList,"|"):
    cDropDownList = cDropDownList + (IF cDropDownList NE "" THEN "|" ELSE "")
                  + ENTRY(ix,cFieldList,"|") + "|" + ENTRY(ix,cFieldList,"|").
  END.
  IF cDropDownList NE "" THEN      
    ioBrowseObject:setFilterDropDownList(ttViewDsField.ViewDsFieldName,cDropDownList).
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLookupDefinitions C-Win 
FUNCTION setLookupDefinitions RETURNS LOGICAL (INPUT ioBrowseObject AS JBoxBrowse ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF BUFFER ttViewDsField FOR TEMP-TABLE ttViewDsField.

DEF VAR ix AS INT NO-UNDO.
DEF VAR cElement AS CHAR NO-UNDO.
DEF VAR cReturnField    AS CHAR NO-UNDO.
DEF VAR cBaseQuery      AS CHAR NO-UNDO.
DEF VAR cBuffersAndFlds AS CHAR NO-UNDO.
DEF VAR cFields         AS CHAR NO-UNDO.

FOR EACH ttViewDsField 
    WHERE ttViewDsField.ViewDsId = ttViewDs.ViewDsId
      AND ttViewDsField.ViewDsFieldFunction BEGINS "filterLookup"
      AND NUM-ENTRIES(ttViewDsField.ViewDsFieldFunction,";") > 1:
  cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ttViewDsField.ViewDsFieldName.      
  IF NUM-ENTRIES(ttViewDsField.ViewDsFieldFunction,"|") = 1 THEN      
    ioBrowseObject:setFilterLookup(ttViewDsField.ViewDsFieldName,
                                   SUBSTR(ttViewDsField.ViewDsFieldFunction,INDEX(ttViewDsField.ViewDsFieldFunction,";") + 1),
                                   "where false"
                                   ).
  ELSE DO:
    ASSIGN cBaseQuery = ""
           cReturnField = ""
           cBuffersAndFlds = "".
    DO ix = 1 TO NUM-ENTRIES(ttViewDsField.ViewDsFieldFunction,"|"):
      cElement = ENTRY(ix,ttViewDsField.ViewDsFieldFunction,"|").
      CASE ENTRY(1,cElement,";"):
        WHEN "filterLookup"      THEN cBuffersAndFlds = SUBSTR(cElement,INDEX(cElement,";") + 1).
        WHEN "filterBaseQuery"   THEN cBaseQuery      = ENTRY(2,cElement,";").
        WHEN "filterReturnField" THEN cReturnField    = ENTRY(2,cElement,";").
      END CASE.    
    END.       
    IF cBaseQuery = "" THEN cBaseQuery = "WHERE FALSE".
    IF cReturnField = "" THEN 
      ioBrowseObject:setFilterLookup(ttViewDsField.ViewDsFieldName,
                                     cBuffersAndFlds,
                                     cBaseQuery).
    ELSE                                 
      ioBrowseObject:setFilterLookup(ttViewDsField.ViewDsFieldName,
                                     cBuffersAndFlds,
                                     cBaseQuery,
                                     cReturnField).
  END.
  ioBrowseObject:allowCan-DoFilterOperator = cFields.                                   
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueries C-Win 
FUNCTION setQueries RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

IF AVAIL ttViewDs THEN DO WITH FRAME {&FRAME-NAME}:
  IF cCurrDb = ttViewDs.BaseDb AND cCurrTable = ttViewDs.BaseTable THEN DO:
    oQryViewDsTable:openQuery("WHERE false").
    oQryViewDsTable:displayRecord().                              
    ASSIGN ViewDsTableQuery:SCREEN-VALUE = ttViewDs.BaseQuery
           ViewDsTable:SCREEN-VALUE = ttViewDs.BaseTable
           ViewDsTableJoinType:SCREEN-VALUE = "EACH"
           ViewDsTableOuterJoin:HIDDEN = YES
           ViewDsTableNotExist:HIDDEN = YES
           ViewDsTableFirstLast:HIDDEN = YES
           .
  END.  
  ELSE DO:
    oQryViewDsTable:openQuery("WHERE ttViewDsTable.ViewDsId = '" + ttViewDs.ViewDsId + "'"
                              + " AND ttViewDsTable.ViewDsDb = '" + cCurrDb + "'"
                              + " AND ttViewDsTable.ViewDsTable = '" + cCurrTable + "'"
                              ).
    oQryViewDsTable:displayRecord().                              
  END.   
           
  IF bShowTable THEN
    oBrwViewDsField:setFilter("ViewDsDb,ViewDsTable","=,=",cCurrDb + "|" + cCurrTable).
  oBrwViewDsField:openQuery().
END.
ELSE DO:
  oQryViewDsTable:openQuery("WHERE false").
  oQryViewDsTable:displayRecord().                              
END.  

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setTableQuery C-Win 
FUNCTION setTableQuery RETURNS CHARACTER
  ( INPUT icTable AS CHAR,
    INPUT icQuery AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR hSearchField  AS HANDLE NO-UNDO.
DEF VAR cFlds         AS CHAR   NO-UNDO.
DEF VAR ix            AS INT    NO-UNDO.
DEF VAR cDataType     AS CHAR   NO-UNDO.
DEF VAR cError        AS CHAR   NO-UNDO.
DEF VAR bIndexedOnly  AS LOG    NO-UNDO.
DEF VAR bIndexed      AS LOG    NO-UNDO.
DEF VAR bNew          AS LOG    NO-UNDO.

IF icQuery = "" THEN DO:
  bIndexedOnly = JBoxSession:Instance:ViewQuestionYesNo("View indexed columns only?").
  icQuery = "WHERE (".
  FOR EACH tt_db
      WHERE tt_db.cSourceName = ttViewDs.SourceName
     ,EACH tt_file
           WHERE tt_file.iDbNum = tt_db.iDbNum 
             AND tt_file.cLDBname = ttViewDs.BaseDb
             AND tt_file.cFile-Name = icTable
     ,EACH tt_field 
           WHERE tt_field.iFileNum = tt_file.iFileNum
      BY tt_field.cField-Name:
    bIndexed = JBoxSchemaCache:Instance:getIsFieldIndexed(tt_field.cField-Name, tt_file.cFile-Name,tt_file.cLDBname, ttViewDs.SourceName).
    IF bIndexedOnly AND NOT bIndexed THEN NEXT.
    
    icQuery = icQuery + CHR(10) + (IF ix > 1 THEN " AND " ELSE "") + tt_file.cLDBname + "." + tt_file.cFile-Name + "." + tt_field.cField-Name + " = ".    
    cDataType = tt_field.cData-Type.
    CASE cDataType:
      WHEN "CHARACTER"  THEN icQuery = icQuery + "'<value>'".
      WHEN "DATE" OR WHEN "DATETIME" OR WHEN "DATETIME-TZ"
        THEN icQuery = icQuery + cDataType + "('" + (IF SESSION:DATE-FORMAT = "dmy" THEN "dd.mm.yyyy" ELSE "mm.dd.yyyy") + "')".
      WHEN "DECIMAL"    THEN icQuery = icQuery + "DECIMAL('" + (IF SESSION:NUMERIC-FORMAT = "american" THEN "999.99" ELSE "999,99") + "')".
      WHEN "LOGICAL"    THEN icQuery = icQuery + "true/false".
      OTHERWISE icQuery = icQuery + "<value>".
    END CASE.
    IF NOT bIndexedOnly AND bIndexed THEN
      icQuery = icQuery + " (*)".
  END.
  icQuery = icQuery + CHR(10) + ")".    
  bNew = YES.
END.

IF icQuery NE "" THEN 
  REPEAT:
    RUN JBoxDSmallEditor.w (INPUT-OUTPUT icQuery,
                            "Set base query" + IF NOT bIndexedOnly THEN " (*): Indexed" ELSE "",
                            NO,OUTPUT bOk).
    IF bOk AND icQuery NE "" THEN DO:
      cError = JBoxSchemaCache:Instance:CheckQuerySyntax(ttViewDs.SourceName,ttViewDs.BaseDb + "." + icTable,
               "FOR EACH " + icTable + " " + icQuery).
      IF cError NE "" THEN DO:
        JBoxSession:Instance:ViewMessage("Syntax error: " + CHR(10) + cError).
        NEXT.
      END.  
      ELSE LEAVE.
    END.   
    ELSE DO:
      IF bNew THEN icQuery = "".
      LEAVE.
    END.    
  END.
ELSE IF bNew THEN MESSAGE "No available fields"
                  VIEW-AS ALERT-BOX.   

RETURN icQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setViewDsName C-Win 
FUNCTION setViewDsName RETURNS LOGICAL
  ( INPUT icViewDsName AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  cViewDsName = icViewDsName.

  RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

