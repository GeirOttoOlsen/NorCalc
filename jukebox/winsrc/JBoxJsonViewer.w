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
DYNAMIC-FUNCTION("setAttribute",SESSION,"UseAdvGui","yes") NO-ERROR.

&IF DEFINED(UIB_is_Running) NE 0 &THEN
  {tt_schema.i "NEW SHARED"}
&ELSE
  {tt_schema.i SHARED}
&ENDIF

{incl/tt_viewds.i}

hdsViewDs = DATASET dsViewDs:HANDLE.
DEF VAR httViewDs AS HANDLE NO-UNDO.
httViewDs = BUFFER ttViewDs:HANDLE.

/* Local Variable Definitions ---                                       */
DEF VAR bOk               AS LOG    NO-UNDO.
DEF VAR hBrowse           AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer        AS JBoxContainer NO-UNDO.

DEF VAR hbttTables        AS HANDLE NO-UNDO.
DEF VAR hqttTables        AS HANDLE NO-UNDO.
DEF VAR hbttFields        AS HANDLE NO-UNDO.
DEF VAR hqttFields        AS HANDLE NO-UNDO.
DEF VAR cCurrentTable     AS CHAR   NO-UNDO.
DEF VAR oPageBrowse       AS JBoxBrowse NO-UNDO.
DEF VAR lcJson            AS LONGCHAR   NO-UNDO.
DEF VAR cSchemaName       AS CHAR NO-UNDO.
DEF VAR cJsonFile         AS CHAR NO-UNDO.
DEF VAR cFieldsUsedAsTableList AS CHAR NO-UNDO.
DEF VAR cTablePrefix      AS CHAR NO-UNDO.

DEF VAR cApiUrl           AS CHAR NO-UNDO.
DEF VAR cApiAccept        AS CHAR NO-UNDO.
DEF VAR cEndpointFile     AS CHAR NO-UNDO.
DEF VAR lcPutPost         AS LONGCHAR NO-UNDO.
DEF VAR cSepWinType       AS CHAR NO-UNDO.

DEF VAR hTtBuffer2View    AS HANDLE NO-UNDO.
DEF VAR hViewContainer    AS HANDLE NO-UNDO.
DEF VAR cViewTargetNode   AS CHAR NO-UNDO.
DEF VAR hCallFileParser   AS HANDLE NO-UNDO.
DEF VAR cFlatFileList     AS CHAR NO-UNDO. 
DEF VAR hSelectorPanel    AS HANDLE NO-UNDO.
DEF VAR httFlatFile       AS HANDLE NO-UNDO.

DEF VAR cFlatFileFilterFields  AS CHAR NO-UNDO.
DEF VAR cFlatFileOperInUseList AS CHAR NO-UNDO.
DEF VAR cFlatFileFilterValList AS CHAR NO-UNDO.
DEF VAR cFlatFileTableName     AS CHAR NO-UNDO.
DEF VAR iFlatFileImpMaxRows    AS INT NO-UNDO.
DEF VAR cFlatFileCodePage      AS CHAR NO-UNDO.

DEF VAR bSaveEndpointAS        AS LOG NO-UNDO.

DEF VAR oJBoxMsTreeView AS uc.JBoxMsTreeView NO-UNDO.

DEF VAR oJBoxParser AS JboxJsonParser NO-UNDO.

DEF VAR oTabBrowse AS JBoxMsTabs NO-UNDO.

DEF TEMP-TABLE ttTableViewTab
    FIELD TableOrViewId   AS CHAR
    FIELD TabPage#        AS INT
    FIELD TableOrViewName AS CHAR
    FIELD oDataBrowseObj  AS Progress.Lang.Object
    INDEX idxTabPage IS PRIMARY TabPage#.

DEF TEMP-TABLE ttTableViewWindow
    FIELD TableOrViewId   AS CHAR
    FIELD oDataBrowseObj  AS Progress.Lang.Object
    FIELD hDataBrw        AS HANDLE
    FIELD cType           AS CHAR /* view or table */
    .

DEF TEMP-TABLE ttView
    FIELD ViewId       AS CHAR
    FIELD hViewTable   AS HANDLE
    FIELD hViewBuffer  AS HANDLE
    .
DEF TEMP-TABLE ttViewTables
    FIELD ViewId            AS CHAR
    FIELD ViewTableId       AS CHAR
    FIELD ParentViewTableId AS CHAR
    FIELD ParentTableName   AS CHAR
    FIELD TableName         AS CHAR
    FIELD SourceBuffer      AS HANDLE
    FIELD ViewTableLevel    AS INT
    FIELD ViewTableSeq      AS INT
    FIELD JoinType          AS CHAR
    FIELD PrimaryIdx        AS CHAR
    FIELD FieldList         AS CHAR
    INDEX idxViewTableSeq IS PRIMARY ViewId ViewTableSeq
    .    
DEF TEMP-TABLE ttViewFields
    FIELD ViewId            AS CHAR
    FIELD ViewTableId       AS CHAR
    FIELD FieldName         AS CHAR
    FIELD TableName         AS CHAR
    FIELD DataType          AS CHAR
    FIELD Length            AS INT
    FIELD FieldHandle       AS HANDLE
    FIELD SourceFieldName   AS CHAR
    FIELD SourceFieldHandle AS HANDLE
    FIELD FormatString      AS CHAR
    FIELD ViewFieldSeq      AS INT
    FIELD FieldLabel        AS CHAR
    FIELD OrgFieldName      AS CHAR
    INDEX ViewFieldSeq IS PRIMARY ViewId ViewTableId ViewFieldSeq
    INDEX idxTableName TableName
    .    

DEF TEMP-TABLE ttSelectFields NO-UNDO
  FIELD FieldName    AS CHAR FORMAT "x(32)" LABEL "Field"
  FIELD TableName    AS CHAR FORMAT "x(32)" LABEL "Table"
  FIELD FieldType    AS CHAR FORMAT "x(12)" LABEL "Data type"
  FIELD ixSelected   AS INT
  FIELD RowIdent1    AS CHAR 
  .

DEF TEMP-TABLE ttEndpoint NO-UNDO
    FIELD EndpointUrl            AS CHAR
    FIELD EndpointName           AS CHAR
    FIELD EndpointAppend         AS LOG
    FIELD EndpointMethod         AS CHAR
    FIELD EndpointPutPostInitial AS CHAR
    FIELD EndpointPutPostCP      AS CHAR
    .
DEF TEMP-TABLE ttEndpointParam NO-UNDO
    FIELD EndpointName           AS CHAR
    FIELD EndPointParamType      AS CHAR LABEL "Header/Query"
    FIELD EndpointParamName      AS CHAR FORMAT "x(40)" LABEL "Parameter name"
    FIELD EndpointParamValue     AS CHAR FORMAT "x(1000)" LABEL "Parameter value"
    FIELD EndpointParamSeq       AS INT
    FIELD EndPointParamDataType  AS CHAR
    FIELD EndPointParamMandatory AS LOGICAL
    FIELD EndPointParamInitial   AS CHAR
    FIELD EndPointParamRole      AS CHAR
    FIELD EndPointFilterMapField AS CHAR
    .

DEF VAR otbJson AS JBoxToolbar NO-UNDO.

DEF TEMP-TABLE ttCsvTable NO-UNDO
    FIELD TableName              AS CHAR
    FIELD Seq                    AS INT
    FIELD ParentSeq              AS INT
    FIELD hBuffer                AS HANDLE
    FIELD FieldList              AS CHAR
    FIELD IndexFldList           AS CHAR
    FIELD FilterFields           AS CHAR
    FIELD FilterOperInUseList    AS CHAR
    FIELD FilterValueList        AS CHAR
    FIELD ImpMaxRows             AS INT
    FIELD hSchemaBuffer          AS HANDLE
    .

DEF TEMP-TABLE ttViewDsProc NO-UNDO
    FIELD hViewDef  AS HANDLE
    FIELD cViewName AS CHAR
    FIELD ViewDsId  AS CHAR 
    FIELD hOwner    AS HANDLE
    .
    
DEF TEMP-TABLE ttFlatFileFields
    FIELD iSeq      AS INT     FORMAT ">>9"    LABEL "Seq"
    FIELD FieldName AS CHAR    FORMAT "x(32)"  LABEL "Field name"
    FIELD DataType  AS CHAR    FORMAT "x(10)"  LABEL "Data type"
    FIELD AddIndex  AS LOGICAL FORMAT "Yes/No" LABEL "Add index"
    .

DEF TEMP-TABLE ttFiles NO-UNDO
    FIELD FileName AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS TabBrowse tbJson LoadFile_tbJson ~
PasteJson_tbJson API_tbJson CreateView_tbJson tbViewFields JBoxMsTreeView 
&Scoped-Define DISPLAYED-OBJECTS tbViewFields tbViewSerialized ~
JBoxMsTreeView 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BuildViewContent C-Win 
FUNCTION BuildViewContent RETURNS HANDLE
  ( INPUT icViewId AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BuildViewDef C-Win 
FUNCTION BuildViewDef RETURNS CHAR
  ( INPUT icViewId AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckXML C-Win 
FUNCTION CheckXML RETURNS LONGCHAR
  ( INPUT ilcFile AS LONGCHAR, INPUT icFilename AS CHAR ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ClearAll C-Win 
FUNCTION ClearAll RETURNS LOGICAL FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD DeepCopyTT C-Win 
FUNCTION DeepCopyTT RETURNS LOGICAL
  ( INPUT ihFromTt AS HANDLE,INPUT ihToTt AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteViewTables C-Win 
FUNCTION deleteViewTables RETURNS LOGICAL
  ( INPUT icViewId AS CHAR,
    INPUT icViewTableId AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD flatFile C-Win 
FUNCTION flatFile RETURNS LOGICAL
  ( INPUT ibClear AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTableFieldList C-Win 
FUNCTION getTableFieldList RETURNS CHARACTER
  ( INPUT icTableName     AS CHAR,
    INPUT icSelectedList  AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD LoadEndpoint C-Win 
FUNCTION LoadEndpoint RETURNS LOGICAL
  ( INPUT icFileName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD LoadFile C-Win 
FUNCTION LoadFile RETURNS LOGICAL
  ( INPUT icFileName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ReCreateView C-Win 
FUNCTION ReCreateView RETURNS LOGICAL
  ( INPUT icViewId AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD RemoveTabFromList C-Win 
FUNCTION RemoveTabFromList RETURNS LOGICAL
  ( INPUT iiTab# AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD renumTabs C-Win 
FUNCTION renumTabs RETURNS LOGICAL
  ( INPUT iiTab# AS INT )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setTabBrowse C-Win 
FUNCTION setTabBrowse RETURNS LOGICAL
  ( INPUT ioBrowse AS JBoxBrowse )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD StartTab C-Win 
FUNCTION StartTab RETURNS LOGICAL
  ( INPUT ihBuffer   AS HANDLE
   ,INPUT icViewId AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ViewSchema C-Win 
FUNCTION ViewSchema RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON API_tbJson 
     LABEL "Call endpoint" 
     SIZE 14 BY 1.1 TOOLTIP "Load data from API/service".

DEFINE BUTTON CreateView_tbJson 
     LABEL "Create view" 
     SIZE 14 BY 1.1 TOOLTIP "Create view of (sub-set of) tables".

DEFINE BUTTON LoadFile_tbJson 
     LABEL "Load file" 
     SIZE 14 BY 1.1 TOOLTIP "Load file and build schema" DROP-TARGET.

DEFINE BUTTON PasteJson_tbJson 
     LABEL "Editor" 
     SIZE 14 BY 1.1 TOOLTIP "Click to open text editor".

DEFINE VARIABLE JBoxMsTreeView AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 60 BY 19.52 NO-UNDO.

DEFINE RECTANGLE TabBrowse
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 75 BY 19.52.

DEFINE RECTANGLE tbJson
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 136.8 BY 1.29.

DEFINE VARIABLE tbViewFields AS LOGICAL INITIAL no 
     LABEL "View fields" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.6 BY .81 NO-UNDO.

DEFINE VARIABLE tbViewSerialized AS LOGICAL INITIAL no 
     LABEL "View ser. names" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.8 BY .81 TOOLTIP "View serialized names" NO-UNDO.

DEFINE BUTTON btnSplitBarX  NO-FOCUS FLAT-BUTTON
     LABEL "" 
     SIZE .8 BY 19.43
     BGCOLOR 12 FGCOLOR 12 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     LoadFile_tbJson AT ROW 1.33 COL 2.2 WIDGET-ID 8
     PasteJson_tbJson AT ROW 1.33 COL 16.4 WIDGET-ID 20
     API_tbJson AT ROW 1.33 COL 30.4 WIDGET-ID 24
     CreateView_tbJson AT ROW 1.33 COL 44.4 WIDGET-ID 10
     tbViewFields AT ROW 1.48 COL 105 WIDGET-ID 12
     tbViewSerialized AT ROW 1.48 COL 119.2 WIDGET-ID 18
     JBoxMsTreeView AT ROW 2.91 COL 2 NO-LABEL WIDGET-ID 2
     TabBrowse AT ROW 2.91 COL 64 WIDGET-ID 4
     tbJson AT ROW 1.24 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 138.8 BY 21.86 WIDGET-ID 100.

DEFINE FRAME frSplitBarX
     btnSplitBarX AT ROW 1.1 COL 19.8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 43 ROW 2.91
         SIZE 34.2 BY 19.52 WIDGET-ID 300.


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
         TITLE              = "JukeBox Json and XML Explorer"
         HEIGHT             = 21.91
         WIDTH              = 138.8
         MAX-HEIGHT         = 32.29
         MAX-WIDTH          = 138.8
         VIRTUAL-HEIGHT     = 32.29
         VIRTUAL-WIDTH      = 138.8
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
ASSIGN FRAME frSplitBarX:FRAME = FRAME DEFAULT-FRAME:HANDLE.

/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       tbJson:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "LoadFile|File;Load file¤enable,PasteJson|File;Editor¤enable,API|File;Call endpoint¤enable,CreateView|File;Create view¤enable,NewViewDs|File;New view or dataset¤menuenable,ViewSchema|File;View schema tables as Json¤menuenable,ViewResultDs|File;View dataset as Json¤menuenable,ABLschema|File;ABL schema¤menuenable,ABLcode|File;ABL code¤menuenable,UseFieldAsTable|File;Set field name(s) as table name¤menuenable,setParserLogfile|File;Set parser logfile¤menuenable,viewParserLogFile|File;View parser logfile¤menuenable,|Endpoint,CreateEndpoint|Endpoint;Create endpoint¤menuenable,LoadEndpointDef|Endpoint;Load endpoint definition¤menuenable,EditEndpoint|Endpoint;Edit endpoint¤menu,sub-menu|Endpoint;Header parameters,AddEndpointHeaderParam|Header parameters;Add header parameter¤menu,EditEndpointHeaderParam|Header parameters;Edit header parameter¤menu,DeleteEndPointHeaderParam|Header parameters;Delete header parameter¤menu,sub-menu|Endpoint;Query parameters,AddEndpointQueryParam|Query parameters;Add query parameter¤menu,EditEndpointQueryParam|Query parameters;Edit query parameter¤menu,DeleteEndpoingQueryParam|Query parameters;Delete query parameter¤menu,saveEndpoint|Endpoint;Save endpoint¤menu,saveEndpointAs|Endpoint;Save endpoint as¤menuFilemaxborder".

ASSIGN 
       tbViewFields:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "no".

/* SETTINGS FOR TOGGLE-BOX tbViewSerialized IN FRAME DEFAULT-FRAME
   NO-ENABLE                                                            */
ASSIGN 
       tbViewSerialized:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "no".

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
ON END-ERROR OF C-Win /* JukeBox Json and XML Explorer */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* JukeBox Json and XML Explorer */
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
&Scoped-define SELF-NAME LoadFile_tbJson
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LoadFile_tbJson C-Win
ON DROP-FILE-NOTIFY OF LoadFile_tbJson IN FRAME DEFAULT-FRAME /* Load file */
DO:
  DEF VAR lcFile    AS LONGCHAR NO-UNDO.
  DEF VAR ix        AS INT      NO-UNDO.
  DEF VAR cFileList AS CHAR     NO-UNDO.
  
  FIX-CODEPAGE(lcFile) = "utf-8".
  
  LoadFile(SELF:GET-DROPPED-FILE(1)).
  cFileList = SELF:GET-DROPPED-FILE(1).
  
  DO ix = 2 TO SELF:NUM-DROPPED-FILES:  
    COPY-LOB FROM FILE SELF:GET-DROPPED-FILE(ix) TO lcFile.
    IF SELF:GET-DROPPED-FILE(ix) MATCHES("*.xml*") THEN
      oJboxParser:appendXMLData(CheckXML(lcFile,SELF:GET-DROPPED-FILE(ix))).
    ELSE  
      oJboxParser:appendData(lcFile).
    cFileList = cFileList + "," + SELF:GET-DROPPED-FILE(ix).   
  END.
  oContainer:statusBar:StatusText2 = cFileList.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbViewFields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbViewFields C-Win
ON VALUE-CHANGED OF tbViewFields IN FRAME DEFAULT-FRAME /* View fields */
DO:
  ViewSchema().  
  IF NOT SELF:CHECKED THEN 
    tbViewSerialized:CHECKED = NO.
  tbViewSerialized:SENSITIVE = SELF:CHECKED.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbViewSerialized
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbViewSerialized C-Win
ON VALUE-CHANGED OF tbViewSerialized IN FRAME DEFAULT-FRAME /* View ser. names */
DO:
  ViewSchema().  
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
  DELETE OBJECT hqttFields NO-ERROR.
  DELETE OBJECT hqttTables NO-ERROR.
  DELETE OBJECT hbttFields NO-ERROR.
  DELETE OBJECT hbttTables NO-ERROR.
  
  FOR EACH ttViewDsProc
      WHERE ttViewDsProc.hOwner = THIS-PROCEDURE:
    IF VALID-HANDLE(ttViewDsProc.hViewDef) THEN APPLY "close" TO ttViewDsProc.hViewDef.
  END.  
  
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    DELETE OBJECT oContainer NO-ERROR.
  &ENDIF
  RUN disable_UI.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ABLcodeRecord C-Win 
PROCEDURE ABLcodeRecord :
DEF VAR cUseFileName     AS CHAR NO-UNDO.
  DEF VAR bOk              AS LOG  NO-UNDO.
  DEF VAR cViewDef         AS CHAR NO-UNDO.
  DEF VAR cViewId          AS CHAR NO-UNDO.
  DEF VAR ix               AS INT  NO-UNDO.
  DEF VAR iy               AS INT  NO-UNDO.
  DEF VAR cViewFlds        AS CHAR NO-UNDO.
  DEF VAR cField           AS CHAR NO-UNDO.
  DEF VAR bStaticDs        AS LOG  NO-UNDO.
  DEF VAR bJukeBox         AS LOG  NO-UNDO.
  DEF VAR cFilterFields    AS CHAR NO-UNDO.
  DEF VAR cQueryProperties AS CHAR NO-UNDO.

  JBoxSession:Instance:PromptForValues("Code options",
                                       "Static dataset|LOGICAL|Yes/No|No|Yes|yes|No|no"
                                     + "¤Prefix tables|CHARACTER|x(8)|" + cTablePrefix
                                     + "¤JukeBox proc|LOGICAL|Yes/No|No|Yes|yes|No|no"
                                     ).
//  JBoxSession:Instance:PromptForValue("Prefix for table names","CHARACTER","x(8)",cTablePrefix).
  IF NOT JBoxSession:Instance:PromptValueOk THEN RETURN.
  
  ASSIGN bStaticDs    = LOGICAL(ENTRY(1,JBoxSession:Instance:PromptValue,"|"))
         cTablePrefix = ENTRY(2,JBoxSession:Instance:PromptValue,"|")
         bJukeBox     = LOGICAL(ENTRY(3,JBoxSession:Instance:PromptValue,"|"))
         .  

  cUseFileName = SESSION:TEMP-DIRECTORY + cSchemaName + ".p".

/*  SYSTEM-DIALOG GET-FILE cUseFileName        */
/*         FILTERS "Source Files (*.p)"   "*.p"*/
/*         USE-FILENAME UPDATE bOk.            */
  bOk = YES.
  IF bOk THEN DO:
    IF cSchemaName = "ttJsonHeader" THEN DO:
      cJsonFile = SESSION:TEMP-DIR + cSchemaName + ".json".
      OUTPUT TO VALUE(cJsonFile).
      COPY-LOB FROM OBJECT lcJson TO FILE cJsonFile.
      OUTPUT CLOSE. 
    END.  
        
    OUTPUT TO VALUE(cUseFileName).

    PUT UNFORMATTED "/* Procedure: " cUseFileName  SKIP.
    PUT UNFORMATTED "   Purpose:   "   SKIP.
    PUT UNFORMATTED "   Created:   " TODAY " BY " JBoxSession:Instance:UserId SKIP(1).

    FIND FIRST ttView NO-ERROR.
    IF AVAIL ttView THEN cViewId = ttView.ViewId.
    
    IF bJukeBox THEN DO:
      IF AVAIL ttEndpoint AND cViewId NE "" THEN DO:
        PUT UNFORMATTED "    Client usage: " SKIP.
        PUT UNFORMATTED "    Copy temp-table definition and create the browse: " SKIP.
        PUT UNFORMATTED "    oBrw" cViewId " = NEW JBoxBrowse(brw<name of rectangle>:HANDLE,NO,BUFFER " cViewId ":HANDLE)." SKIP(1).
        PUT UNFORMATTED "    Fetch data:" SKIP.                
        PUT UNFORMATTED "    IF JBoxServerAPI:Instance:CallServerProc('" cUseFileName "',<parameter>,oBrw" cViewId ":BUFFER-HANDLE) THEN" SKIP.
        PUT UNFORMATTED "      oBrw" cViewId ":openQuery()." SKIP.
        PUT UNFORMATTED "    ELSE JBoxServerAPI:Instance:viewCallMessage()." SKIP(1).
      END.
      PUT UNFORMATTED "***********/" SKIP(1).
                      
      PUT UNFORMATTED "DEF INPUT  PARAM icParam     AS CHAR NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF OUTPUT PARAM obOk        AS LOG NO-UNDO." SKIP(1).
      
      PUT UNFORMATTED  CHR(123) "incl/validatecaller.i}" SKIP(1).
    END.  
    ELSE PUT UNFORMATTED "***********/" SKIP(1).

  
    IF bStaticDs THEN   
      PUT UNFORMATTED oJBoxParser:get4GLschema() SKIP(1).

    PUT UNFORMATTED "DEF VAR oJboxParser AS JBoxJsonParser NO-UNDO." SKIP.
    PUT UNFORMATTED "DEF VAR hQuery      AS HANDLE NO-UNDO." SKIP.
    PUT UNFORMATTED "DEF VAR httView     AS HANDLE NO-UNDO." SKIP(1).
    IF AVAIL ttView THEN
      PUT UNFORMATTED "DEF VAR htt" cViewId " AS HANDLE NO-UNDO." SKIP(1).

    IF AVAIL ttEndpoint THEN DO:
      PUT UNFORMATTED "DEF VAR wc           AS CLASS System.Net.WebClient NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF VAR oUri         AS CLASS System.Uri           NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF VAR Srdr         AS System.IO.StreamReader     NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF VAR resultString AS LONGCHAR                   NO-UNDO." SKIP.
      PUT UNFORMATTED "DEF VAR cQueryParam  AS CHAR NO-UNDO." SKIP(1).
      
      IF bJukeBox THEN DO:
        FOR EACH ttEndpointParam
            WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
              AND ttEndpointParam.EndPointParamType = "Q"
            :
          IF ttEndpointParam.EndPointParamRole BEGINS "filter" THEN
            cFilterFields = cFilterFields + (IF cFilterFields NE "" THEN "," ELSE "") 
                        + (IF ttEndpointParam.EndPointFilterMapField NE "" THEN ttEndpointParam.EndPointFilterMapField
                           ELSE ttEndpointParam.EndpointParamName).
          ELSE IF ttEndpointParam.EndPointParamRole BEGINS "query" THEN
            cQueryProperties = cQueryProperties + (IF cQueryProperties NE "" THEN "," ELSE "")
                        + ttEndpointParam.EndpointParamName + ";" + ttEndpointParam.EndPointParamRole.                      
        END.  
        IF cFilterFields NE "" THEN 
          PUT UNFORMATTED "DEF VAR cFilterFields AS CHAR NO-UNDO INIT '" + cFilterFields + "'." SKIP.
        ELSE  
          PUT UNFORMATTED "DEF VAR cFilterFields AS CHAR NO-UNDO." SKIP.
        IF cQueryProperties NE "" THEN  
          PUT UNFORMATTED "DEF VAR cQueryProperties AS CHAR NO-UNDO INIT '" + cQueryProperties + "'." SKIP(1).
        ELSE  
          PUT UNFORMATTED "DEF VAR cQueryProperties AS CHAR NO-UNDO." SKIP(1).
          
        PUT UNFORMATTED "IF icParam = 'getFilterFields' THEN DO:" SKIP.
        PUT UNFORMATTED "  ocReturn = cFilterFields." SKIP.  
        PUT UNFORMATTED "  RETURN." SKIP.  
        PUT UNFORMATTED "END." SKIP.  
        PUT UNFORMATTED "IF icParam = 'getQueryProperties' THEN DO:" SKIP.
        PUT UNFORMATTED "  ocReturn = cQueryProperties." SKIP.  
        PUT UNFORMATTED "  RETURN." SKIP.  
        PUT UNFORMATTED "END." SKIP.  
      END.
      
      PUT UNFORMATTED "FIX-CODEPAGE(resultString) = 'UTF-8'." SKIP(1).
      PUT UNFORMATTED "oJboxParser = NEW JBoxJsonParser()." SKIP(1).
    END.
    ELSE DO:
      IF cJsonFile MATCHES "*.xml*" THEN DO:
        PUT UNFORMATTED "DEF VAR cXmlFile    AS CHAR NO-UNDO." SKIP.
        PUT UNFORMATTED "DEF VAR lcXML       AS LONGCHAR NO-UNDO." SKIP(1).
        PUT UNFORMATTED 'FIX-CODEPAGE(lcXML) = "UTF-8".' SKIP(1).
      END.
      ELSE DO:
        PUT UNFORMATTED "DEF VAR cJsonFile   AS CHAR NO-UNDO." SKIP.
        PUT UNFORMATTED "DEF VAR lcJson      AS LONGCHAR NO-UNDO." SKIP(1).
        PUT UNFORMATTED 'FIX-CODEPAGE(lcJson) = "UTF-8".' SKIP(1).
      END.     
      PUT UNFORMATTED "oJboxParser = NEW JBoxJsonParser()." SKIP(1).
    END.    

    IF bStaticDs THEN          
      PUT UNFORMATTED "oJboxParser:LoadPredefinedDS(DATASET " + cTablePrefix + oJBoxParser:hdsResult:GET-BUFFER-HANDLE(1):NAME + ":HANDLE)." SKIP(1).

    FOR EACH ttView:
      IF cViewDef = "" THEN cViewDef = TRIM(BuildViewDef(cViewId)).
      cViewFlds = "".
      IF cViewDef NE "" THEN DO:
        PUT UNFORMATTED "// Static temp-table for opt. transfer from dynamic view tt:" SKIP.
        PUT UNFORMATTED "DEF TEMP-TABLE " ttView.ViewId SKIP.
        FOR EACH ttViewTables
            WHERE ttViewTables.ViewId = ttView.ViewId
            BY ttViewTables.ViewTableSeq
            :
          ix = ix + 1.    
          FOR EACH ttViewFields
              WHERE ttViewFields.ViewId = ttView.ViewId
                AND ttViewFields.ViewTableId = ttViewTables.ViewTableId
              BY ttViewFields.ViewFieldSeq
              :
            cField = ttViewFields.FieldName.    
            IF CAN-DO(cViewFlds,cField) THEN cField = cField + STRING(ix).
            PUT UNFORMATTED "    FIELD " cField " AS " ttViewFields.DataType " FORMAT '" ttViewFields.FormatString "'" SKIP.
            cViewFlds = cViewFlds + (IF cViewFlds NE "" THEN "," ELSE "") + cField.
          END.  
        END.             
        PUT UNFORMATTED "//  FIELD MyExtraField AS CHAR" SKIP.
        PUT UNFORMATTED "    FIELD RowCount     AS INT" SKIP.
        PUT UNFORMATTED "    FIELD RowIdent1    AS CHAR" SKIP.
        PUT UNFORMATTED "    ." SKIP(1).

      END.                    
    END.
    IF cViewDef = "" THEN DO:
      PUT UNFORMATTED "/******** View template - create: (add primary index to table def to control FIRST/LAST) " SKIP(1).
      PUT UNFORMATTED "httView = oJBoxParser:createView('<table>'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                + ';+MyExtraField|CHARACTER|x(30)" + "'" SKIP.
      PUT UNFORMATTED "                              + ',[FIRST | LAST] <child table> [OUTER-JOIN]'" SKIP.
      PUT UNFORMATTED "                                + ';<field>'" SKIP.
      PUT UNFORMATTED "                                )." SKIP(1).
      PUT UNFORMATTED "********/" SKIP(1).
    END.  

    IF AVAIL ttEndpoint THEN DO:
      PUT UNFORMATTED "System.Net.ServicePointManager:SecurityProtocol = System.Net.SecurityProtocolType:Tls12." SKIP(1). 
      PUT UNFORMATTED "wc = NEW System.Net.WebClient()." SKIP.
      PUT UNFORMATTED "wc:Encoding = System.Text.Encoding:UTF8." SKIP(1).
      FOR EACH ttEndpointParam
          WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
            AND ttEndpointParam.EndpointParamType = "H"
            AND ttEndpointParam.EndpointParamValue NE ""
          BY ttEndpointParam.EndpointParamSeq:
        PUT UNFORMATTED "wc:Headers:Add('" ttEndpointParam.EndpointParamName "','" ttEndpointParam.EndpointParamValue "')." SKIP.
      END.           
      FOR EACH ttEndpointParam
          WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
            AND ttEndpointParam.EndpointParamType = "Q"
            AND ttEndpointParam.EndpointParamValue NE ""
          BY ttEndpointParam.EndpointParamSeq:
        PUT UNFORMATTED "cQueryParam = cQueryParam + '&' + '" ttEndpointParam.EndpointParamName "' + '=' + '" ttEndpointParam.EndpointParamValue "'." SKIP.
      END.           
      PUT UNFORMATTED "IF cQueryParam NE '' THEN DO:" SKIP. 
      PUT UNFORMATTED "  cQueryParam = '?' + TRIM(cQueryParam,'&')." SKIP. 
      PUT UNFORMATTED "  cQueryParam = oJBoxParser:UrlEncode(cQueryParam)." SKIP.
      PUT UNFORMATTED "END." SKIP(1).
      PUT UNFORMATTED "oUri = NEW System.Uri('" ttEndpoint.EndpointUrl "' + cQueryParam )." SKIP.
      PUT UNFORMATTED "resultString = wc:DownloadString(oUri:AbsoluteUri)." SKIP.
      PUT UNFORMATTED "IF INDEX(resultString,'\u00') > 0 THEN" SKIP.
      PUT UNFORMATTED "  resultString = System.Text.RegularExpressions.Regex:Unescape(resultString)." SKIP(1).
      IF bStaticDs THEN
        PUT UNFORMATTED "oJboxParser:appendData(resultString)." SKIP(1).
      ELSE  
        PUT UNFORMATTED "oJboxParser:createSchema(resultString,'" cSchemaName "')." SKIP(1).
        
    END.
    ELSE DO:      
      IF cJsonFile MATCHES "*.xml*" THEN DO:
        PUT UNFORMATTED "cXMLFile = '" + cJsonFile + "'." SKIP.
        PUT UNFORMATTED "COPY-LOB FROM FILE cXMLFile TO lcXML." SKIP(1).
        PUT UNFORMATTED "/** For unformatted XML you might need to do something like this:" SKIP(1).
        PUT UNFORMATTED "DEF VAR doc AS System.Xml.XmlDocument NO-UNDO." SKIP.
        PUT UNFORMATTED "doc = new System.Xml.XmlDocument()." SKIP.
        PUT UNFORMATTED "DO ON ERROR UNDO, LEAVE:" SKIP.
        PUT UNFORMATTED "  doc:LoadXml(lcXml)." SKIP.
        PUT UNFORMATTED "  CATCH ex AS System.Xml.XmlException:" SKIP.
        PUT UNFORMATTED "    doc:Load('" + cJsonFile + "')." SKIP.
        PUT UNFORMATTED "  END CATCH." SKIP. 
        PUT UNFORMATTED "END." SKIP.
        PUT UNFORMATTED "lcXml = System.Xml.Linq.XElement:Parse(doc:OuterXml):ToString()." SKIP(1).
        PUT UNFORMATTED "********/" SKIP(1).
        PUT UNFORMATTED "oJboxParser:appendXMLData(lcXML)." SKIP(1).
      END.
      ELSE DO:  
        PUT UNFORMATTED "cJsonFile = '" + cJsonFile + "'." SKIP.
        PUT UNFORMATTED "COPY-LOB FROM FILE cJsonFile TO lcJson." SKIP(1).
        PUT UNFORMATTED "oJboxParser:appendData(lcJson)." SKIP(1).
      END.
    END.  

    IF cViewDef = "" THEN DO:
      PUT UNFORMATTED "/******** View template - fill: " SKIP(1).
      PUT UNFORMATTED "IF NOT oJboxParser:fillView(httView,NO) THEN DO: // httView could also be the buffer handle. NO: Replace data" SKIP.
      PUT UNFORMATTED "  MESSAGE oJboxParser:statusMessage VIEW-AS ALERT-BOX." SKIP.
      PUT UNFORMATTED "  RETURN." SKIP.
      PUT UNFORMATTED "END." SKIP(1).
      PUT UNFORMATTED "// Dynamic - use the parser's view tt:" SKIP.
      PUT UNFORMATTED "CREATE QUERY hQuery." SKIP.
      PUT UNFORMATTED "hQuery:SET-BUFFERS(httView:DEFAULT-BUFFER-HANDLE)." SKIP.
      PUT UNFORMATTED "hQuery:QUERY-PREPARE('FOR EACH ' + httView:DEFAULT-BUFFER-HANDLE:NAME)." SKIP.
      PUT UNFORMATTED "hQuery:QUERY-OPEN()." SKIP.
      PUT UNFORMATTED "REPEAT WHILE hQuery:GET-NEXT():" SKIP.
      IF cViewDef = "" THEN
        PUT UNFORMATTED "  MESSAGE httView:DEFAULT-BUFFER-HANDLE::<field> VIEW-AS ALERT-BOX." SKIP.
      ELSE DO:
        DO ix = 1 TO NUM-ENTRIES(cViewFlds):
          IF ix = 1 THEN  
            PUT UNFORMATTED "  MESSAGE httView:DEFAULT-BUFFER-HANDLE::" + ENTRY(ix,cViewFlds) + " SKIP" SKIP.
          ELSE  
            PUT UNFORMATTED "          httView:DEFAULT-BUFFER-HANDLE::" + ENTRY(ix,cViewFlds) + " SKIP" SKIP.
        END.
        PUT UNFORMATTED "          VIEW-AS ALERT-BOX." SKIP.  
      END.  
      PUT UNFORMATTED "END." SKIP(1).
      PUT UNFORMATTED "DELETE OBJECT hQuery." SKIP(1).
      PUT UNFORMATTED "********/" SKIP(1).
    END.
    ELSE DO:
      DO ix = 1 TO NUM-ENTRIES(cViewDef):
        IF ix = 1 THEN
          PUT UNFORMATTED "htt" cViewId " = oJBoxParser:createView('" ENTRY(1,ENTRY(ix,cViewDef),";") "'" SKIP.
        ELSE  
          PUT UNFORMATTED "                              + '," ENTRY(1,ENTRY(ix,cViewDef),";") "'" SKIP.
        DO iy = 2 TO NUM-ENTRIES(ENTRY(ix,cViewDef),";"):
          PUT UNFORMATTED "                                + ';" ENTRY(iy,ENTRY(ix,cViewDef),";") "'" SKIP.
        END.
        IF ix = 1 THEN
          PUT UNFORMATTED "//                              + ';+MyExtraField|CHARACTER|x(30)" + "'" SKIP.
      END.
      PUT UNFORMATTED "                              )." SKIP(1).
      IF bJukeBox AND cViewId NE "" THEN
        PUT UNFORMATTED "oJboxParser:deepCopyTT(htt" + cViewId ",ihBuffer)." SKIP.
      ELSE
        FOR EACH ttView:  
          PUT UNFORMATTED "IF NOT oJboxParser:fillView(htt" + ttView.ViewId + ",NO) THEN DO:" SKIP. 
          PUT UNFORMATTED "  MESSAGE oJboxParser:statusMessage VIEW-AS ALERT-BOX." SKIP.
          PUT UNFORMATTED "  RETURN." SKIP.
          PUT UNFORMATTED "END." SKIP(1).
          PUT UNFORMATTED "// Proceed using the static temp-table:" SKIP.
          PUT UNFORMATTED "BUFFER " ttView.ViewId ":HANDLE:COPY-TEMP-TABLE(htt" ttView.ViewId ",NO,NO,YES)." SKIP(1).
          PUT UNFORMATTED "// Or use the dynamic view tt:" SKIP.
          PUT UNFORMATTED "RUN toExcelViaFile.p (htt" ttView.ViewId ",-2). // open in notepad" SKIP(2).
        END.
    END.    
    
    IF bStaticDs THEN DO:
      PUT UNFORMATTED "/******** FOR EACH template: */" SKIP(1).
      PUT UNFORMATTED oJBoxParser:getForEach(cTablePrefix) SKIP.
    END.  
    
    IF AVAIL ttEndpoint THEN DO:
      PUT SKIP(1).
      PUT UNFORMATTED "CATCH ex AS System.Net.WebException :" SKIP.
      PUT UNFORMATTED "  Srdr = NEW System.IO.StreamReader(ex:Response:GetResponseStream())." SKIP.
      PUT UNFORMATTED "  resultString = Srdr:ReadToEnd()." SKIP.
      IF bJukeBox THEN
        PUT UNFORMATTED "  ocReturn = STRING(resultString)." SKIP.
      PUT UNFORMATTED "END CATCH." SKIP.
    END.  
    IF bJukeBox THEN DO:
      PUT SKIP(1).
      PUT UNFORMATTED "FINALLY:" SKIP.
      PUT UNFORMATTED "  IF ocReturn = '' THEN ocReturn = oJboxParser:statusMessage." SKIP.
      PUT UNFORMATTED "  obOk = ocReturn = ''" SKIP.
      PUT UNFORMATTED "                  OR (icParam = 'getFilterFields' AND cFilterFields NE '')" SKIP.
      PUT UNFORMATTED "                  OR (icParam = 'getQueryProperties' AND cQueryProperties NE '')." SKIP.
      PUT UNFORMATTED "END FINALLY." SKIP.      
    END.  
    
    OUTPUT CLOSE.
    
    DO ON ERROR UNDO, THROW:  
      System.Diagnostics.Process:Start("notepad.exe",cUseFileName).
      CATCH eOS AS Progress.Lang.Error :
        MESSAGE eOS:GetMessage(1) VIEW-AS ALERT-BOX.
      END CATCH.
    END.        
  END.    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ABLschemaRecord C-Win 
PROCEDURE ABLschemaRecord :
  DEF VAR cPriIndexFlds AS CHAR NO-UNDO.
    
  IF flatFile(NO) THEN DO:
    oJBoxParser:ABLidxFields = ttCsvTable.IndexFldList.
    oJBoxParser:ABLfieldList = ttCsvTable.FieldList. 
    oJBoxParser:saveSchemaAs4GL("").
  END.  
  ELSE DO:  
    JBoxSession:Instance:PromptForValue("Prefix for table names","CHARACTER","x(4)",cTablePrefix).
    IF NOT JBoxSession:Instance:PromptValueOk THEN RETURN.
    cTablePrefix = JBoxSession:Instance:PromptValue.  
    
    FOR EACH ttViewTables WHERE ttViewTables.PrimaryIdx NE "":
      cPriIndexFlds = cPriIndexFlds 
                    + (IF cPriIndexFlds NE "" THEN "," ELSE "")
                    + ttViewTables.TableName + ";" + ttViewTables.PrimaryIdx.
    END.  
  
    oJBoxParser:saveSchemaAs4GL("",YES,cTablePrefix,cPriIndexFlds).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddEndpointHeaderParamRecord C-Win 
PROCEDURE AddEndpointHeaderParamRecord :
DEF VAR iEndpointParamSeq AS INT NO-UNDO INIT 10.
DEF VAR hQueryPage1 AS HANDLE NO-UNDO.
  
DEF BUFFER ttEndPointParam FOR ttEndPointParam.  
  
FIND FIRST ttEndpoint NO-ERROR.
IF NOT AVAIL ttEndpoint THEN DO:
  MESSAGE "Endpoint not defined"
  VIEW-AS ALERT-BOX.  
  RETURN.
END.

FOR EACH ttEndpointParam 
    WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName 
      AND ttEndpointParam.EndPointParamType = "H" BY ttEndpointParam.EndpointParamSeq DESC:
  iEndpointParamSeq = ttEndpointParam.EndpointParamSeq + 10.
  LEAVE.
END.

JBoxSession:Instance:PromptForValue("Add header parameter for endpoint",
                                    "Name|CHARACTER|x(40)¤"
                                  + "Value|CHARACTER|x(200)"
                                  + "¤Input seq|INTEGER|>>9|" + STRING(iEndpointParamSeq)
                                    ).

IF JBoxSession:Instance:PromptValueOk THEN DO:
  FIND FIRST ttEndpointParam
       WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
         AND ttEndpointParam.EndPointParamType = "H"
         AND ttEndpointParam.EndpointParamName = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
       NO-ERROR.
  IF NOT AVAIL ttEndpointParam THEN DO:
    CREATE ttEndpointParam.
    ASSIGN ttEndpointParam.EndpointName = ttEndpoint.EndpointName
           ttEndpointParam.EndPointParamType = "H"
           ttEndpointParam.EndpointParamName = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
           ttEndpointParam.EndPointParamInitial = ENTRY(2,JBoxSession:Instance:PromptValue,"|")
           ttEndpointParam.EndpointParamSeq = INT(ENTRY(3,JBoxSession:Instance:PromptValue,"|"))
           ttEndpointParam.EndpointParamValue = ttEndpointParam.EndPointParamInitial
           .
    hQueryPage1 = oTabBrowse:getPageQuery(1).
    IF VALID-HANDLE(hQueryPage1) AND hQueryPage1:TYPE = "browse" AND hQueryPage1:QUERY:GET-BUFFER-HANDLE (1):NAME = "ttEndpointParam" THEN
      hQueryPage1:QUERY:QUERY-OPEN().       
  END.
  ELSE MESSAGE "Endpoint header parameter " JBoxSession:Instance:PromptValue "already exists for" ttEndpoint.EndpointName
       VIEW-AS ALERT-BOX.            
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AddEndpointQueryParamRecord C-Win 
PROCEDURE AddEndpointQueryParamRecord :
DEF VAR iEndpointParamSeq AS INT NO-UNDO INIT 10.
DEF VAR cMapFilterFields  AS CHAR NO-UNDO.
DEF VAR hQueryPage1 AS HANDLE NO-UNDO.

DEF BUFFER ttEndPointParam FOR ttEndPointParam.  

FIND FIRST ttEndpoint NO-ERROR.
IF NOT AVAIL ttEndpoint THEN DO:
  MESSAGE "Endpoint not defined"
  VIEW-AS ALERT-BOX.  
  RETURN.
END.

FOR EACH ttEndpointParam 
    WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName 
      AND ttEndpointParam.EndPointParamType = "Q" BY ttEndpointParam.EndpointParamSeq DESC:
  iEndpointParamSeq = ttEndpointParam.EndpointParamSeq + 10.
  LEAVE.
END.

JBoxSession:Instance:PromptForValue("Add query parameter for endpoint",
                                    "Name|CHARACTER|x(40)"
                                  + "¤Data type|CHARACTER|x(200)|CHARACTER|Character|CHARACTER|Decimal|DECIMAL|Integer|INTEGER|Iso-date|ISO-DATE|Logical|LOGICAL"
                                  + "¤Required|LOGICAL|Yes/No|No|Yes|Yes|No|No"
                                  + "¤Value|CHARACTER|x(200)"
                                  + "¤Role|CHARACTER|x(8)||Filter|filter|Query - page|querypage|Query - pagesize|querysize|Query - sort|querysort"
                                  + "¤Input seq|INTEGER|>>9|" + STRING(iEndpointParamSeq)
                                    ).
                                    

IF JBoxSession:Instance:PromptValueOk THEN DO:
  FIND FIRST ttEndpointParam
       WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
         AND ttEndpointParam.EndPointParamType = "Q"
         AND ttEndpointParam.EndpointParamName = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
       NO-ERROR.
  IF NOT AVAIL ttEndpointParam THEN DO:
    CREATE ttEndpointParam.
    ASSIGN ttEndpointParam.EndpointName = ttEndpoint.EndpointName
           ttEndpointParam.EndPointParamType = "Q"
           ttEndpointParam.EndpointParamName = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
           ttEndpointParam.EndPointParamDataType = ENTRY(2,JBoxSession:Instance:PromptValue,"|")
           ttEndpointParam.EndPointParamMandatory = LOGICAL(ENTRY(3,JBoxSession:Instance:PromptValue,"|"))
           ttEndpointParam.EndPointParamInitial = ENTRY(4,JBoxSession:Instance:PromptValue,"|")
           ttEndpointParam.EndPointParamRole = ENTRY(5,JBoxSession:Instance:PromptValue,"|")
           ttEndpointParam.EndpointParamSeq = INT(ENTRY(6,JBoxSession:Instance:PromptValue,"|"))
           ttEndpointParam.EndpointParamValue = ttEndpointParam.EndPointParamInitial
           .
    IF ttEndpointParam.EndPointParamRole = "filter" 
       AND CAN-FIND(FIRST ttView) 
       AND NOT CAN-FIND(FIRST ttViewFields WHERE ttViewFields.FieldName = ttEndpointParam.EndpointParamName)
       THEN DO:
      FOR EACH ttViewFields:
        cMapFilterFields = cMapFilterFields + (IF cMapFilterFields NE "" THEN "|" ELSE "")
                         + ttViewFields.ViewId + "." + ttViewFields.FieldName + "|" + ttViewFields.FieldName
                         .
      END.      
      IF cMapFilterFields NE "" THEN DO:
        JBoxSession:Instance:SimpleSelectListPairs(cMapFilterFields,"|",NO
                                                  ,"Map " + ttEndpointParam.EndpointParamName + " to field").
        IF JBoxSession:Instance:SelectListOk THEN
          ttEndpointParam.EndPointFilterMapField = JBoxSession:Instance:SelectListValue.
      END.  
    END.            
    hQueryPage1 = oTabBrowse:getPageQuery(1).
    IF VALID-HANDLE(hQueryPage1) AND hQueryPage1:TYPE = "browse" AND hQueryPage1:QUERY:GET-BUFFER-HANDLE (1):NAME = "ttEndpointParam" THEN
      hQueryPage1:QUERY:QUERY-OPEN().       
  END.
  ELSE MESSAGE "Endpoint header parameter " JBoxSession:Instance:PromptValue "already exists for" ttEndpoint.EndpointName
       VIEW-AS ALERT-BOX.            
END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addTableToView C-Win 
PROCEDURE addTableToView :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
IF NOT VALID-HANDLE(hTtBuffer2View) THEN DO: // The table didn't come from the json/xml parser:
  FIND FIRST ttCsvTable NO-ERROR.
  IF AVAIL ttCsvTable THEN
    hTtBuffer2View = ttCsvTable.hBuffer.    
END.    
IF VALID-HANDLE(hTtBuffer2View) THEN
  RUN AddTtBuffer IN hViewContainer (hTtBuffer2View,cViewTargetNode,"").
ELSE
  MESSAGE "Cannot drop table - handle not valid"
  VIEW-AS ALERT-BOX.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE APIRecord C-Win 
PROCEDURE APIRecord :
DEF VAR wc                   AS CLASS System.Net.WebClient NO-UNDO.
DEF VAR oUri                 AS CLASS System.Uri           NO-UNDO.
DEF VAR Srdr                 AS System.IO.StreamReader     NO-UNDO.
DEF VAR hTabProc             AS HANDLE NO-UNDO.
DEF VAR ix                   AS INT    NO-UNDO.
DEF VAR iy                   AS INT    NO-UNDO.

DEF VAR bRefreshSchema       AS LOG    NO-UNDO INIT YES.
DEF VAR cRefreshSchema       AS CHAR   NO-UNDO.
DEF VAR cViewsFilled         AS CHAR   NO-UNDO.
DEF VAR hOldDsResult         AS HANDLE NO-UNDO.

DEF VAR cApiQryParams        AS CHAR   EXTENT NO-UNDO.
DEF VAR cApiQryParamString   AS CHAR   NO-UNDO.
DEF VAR cApiHdrParams        AS CHAR   EXTENT NO-UNDO.
DEF VAR cApiHdrParamString   AS CHAR   NO-UNDO.
DEF VAR iNumHdrParam         AS INT    NO-UNDO.
DEF VAR cPromptValue         AS CHAR   NO-UNDO.
DEF VAR cQuery               AS CHAR   NO-UNDO.
DEF VAR cInitialValue        AS CHAR   NO-UNDO.
DEF VAR cParam               AS CHAR   NO-UNDO.
DEF VAR cBase64              AS CHAR   NO-UNDO.
DEF VAR iStartBase64         AS INT    NO-UNDO.
DEF VAR iEndBase64           AS INT    NO-UNDO.

DEF BUFFER ttEndPointParam FOR ttEndPointParam.  

DEF VAR resultString   AS LONGCHAR NO-UNDO.

FIX-CODEPAGE(resultString) = 'UTF-8'. 

FIND FIRST ttEndpoint NO-ERROR.
IF NOT AVAIL ttEndpoint THEN DO:
  CREATE ttEndpoint.
  ASSIGN ttEndpoint.EndpointName = "ttJsonHeader"
         ttEndpoint.EndpointUrl = cApiUrl
         cSchemaName = "ttJsonHeader"
         .
END.
ELSE 
  ASSIGN cApiUrl = ttEndpoint.EndpointUrl
         cSchemaName = ttEndpoint.EndpointName
         .         

// Header parameters
FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
      AND ttEndpointParam.EndPointParamType = "H"
    :
  iNumHdrParam = iNumHdrParam + 1.    
END.
EXTENT(cApiHdrParams) = MAX(1,iNumHdrParam).

ix = 0.
FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
      AND ttEndpointParam.EndPointParamType = "H"
    BY ttEndpointParam.EndpointParamSeq  
    :
  ASSIGN cApiHdrParamString = cApiHdrParamString + "¤"
                            + ttEndpointParam.EndPointParamType + ": "
                            + ttEndpointParam.EndpointParamName + "|CHARACTER|x(300)|"
                            + (IF ttEndpointParam.EndpointParamValue NE "" THEN ttEndpointParam.EndpointParamValue
                               ELSE ttEndpointParam.EndPointParamInitial)
         ix = ix + 1           
         cApiHdrParams[ix] = ttEndpointParam.EndpointParamName
         .    
END.


// Query parameters
FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
      AND ttEndpointParam.EndPointParamType = "Q"
    :
  ix = ix + 1.    
END.
EXTENT(cApiQryParams) = MAX(1,ix).

ix = 0.
FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
      AND ttEndpointParam.EndPointParamType = "Q"
    BY ttEndpointParam.EndpointParamSeq  
    :
  IF ttEndpointParam.EndPointParamDataType = "ISO-DATE" AND
     CAN-DO("yesterday,today,tomorrow",ttEndpointParam.EndPointParamInitial) THEN 
    cInitialValue = STRING(ISO-DATE(TODAY
                                 + (IF ttEndpointParam.EndPointParamInitial = "yesterday" THEN -1
                                    ELSE IF ttEndpointParam.EndPointParamInitial = "tomorrow" THEN 1
                                    ELSE 0))).
  ELSE cInitialValue = "".                                  
       
  ASSIGN cApiQryParamString = cApiQryParamString + "¤"
                            + ttEndpointParam.EndPointParamType
                            + (IF ttEndpointParam.EndPointParamMandatory THEN "*" ELSE "")
                            + ": "
                            + ttEndpointParam.EndpointParamName 
                            + "|" + ttEndpointParam.EndPointParamDataType 
                            + "|" + (IF ttEndpointParam.EndPointParamDataType = "CHARACTER" THEN "x(300)"
                                     ELSE IF ttEndpointParam.EndPointParamDataType = "ISO-DATE" THEN "9999-99-99"
                                     ELSE IF ttEndpointParam.EndPointParamDataType = "DECIMAL" THEN "->>>>>>>9.99"
                                     ELSE IF ttEndpointParam.EndPointParamDataType = "INTEGER" THEN "->>>>>>>9"
                                     ELSE "true/false")
                            + "|" + (IF cInitialValue NE "" THEN cInitialValue
                                     ELSE IF ttEndpointParam.EndpointParamValue NE "" THEN ttEndpointParam.EndpointParamValue
                                     ELSE ttEndpointParam.EndPointParamInitial)
                            + (IF ttEndpointParam.EndPointParamDataType = "LOGICAL" THEN "|||true|true|false|false" ELSE "")
         ix = ix + 1           
         cApiQryParams[ix] = ttEndpointParam.EndpointParamName
         .    
END.

JBoxSession:Instance:PromptForValues("Endpoint parameters",
                                     "Url|CHARACTER|x(300)|" + cApiUrl
                                   + cApiHdrParamString
                                   + cApiQryParamString
                                   + "¤Append|LOGICAL|Yes/No|" + STRING(ttEndpoint.EndpointAppend,"Yes/No") + "|Yes|Yes|No|No"
                                   ).
IF NOT JBoxSession:Instance:PromptValueOk THEN RETURN.

cPromptValue = JBoxSession:Instance:PromptValue.

ASSIGN cApiUrl                   = ENTRY(1,cPromptValue,"|")
       ttEndpoint.EndpointUrl    = cApiUrl
       ttEndpoint.EndpointAppend = LOGICAL(ENTRY(NUM-ENTRIES(cPromptValue,"|"),cPromptValue,"|"))
       .

System.Net.ServicePointManager:SecurityProtocol = System.Net.SecurityProtocolType:Tls12. 

wc = NEW System.Net.WebClient().
wc:Encoding = System.Text.Encoding:UTF8.

DO ix = 2 TO NUM-ENTRIES(cPromptValue,"|") - 1:
  IF ix - 1 LE iNumHdrParam THEN DO:
    FIND FIRST ttEndpointParam
         WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
           AND ttEndpointParam.EndpointParamName = cApiHdrParams[ix - 1].
    ttEndpointParam.EndpointParamValue = ENTRY(ix,cPromptValue,"|").       
    IF ttEndpointParam.EndpointParamValue NE "" THEN DO:
      IF ttEndpointParam.EndpointParamValue MATCHES("* base64(*") THEN DO:
        cParam = SUBSTR(ttEndpointParam.EndpointParamValue,1,INDEX(ttEndpointParam.EndpointParamValue,"base64(") - 1).
        iStartBase64 = INDEX(ttEndpointParam.EndpointParamValue,"base64(") + 7.
        iEndBase64 = INDEX(ttEndpointParam.EndpointParamValue,")",iStartBase64).
        cBase64 = JBoxFunctions:Instance:toBase64(SUBSTR(ttEndpointParam.EndpointParamValue,iStartBase64,iEndBase64 - iStartBase64)).
        wc:Headers:Add(ttEndpointParam.EndpointParamName,cParam + cBase64).
      END.
      ELSE  
        wc:Headers:Add(ttEndpointParam.EndpointParamName,ttEndpointParam.EndpointParamValue).
    END.  
  END.           
  ELSE DO:         
    iy = iy + 1.
    FIND FIRST ttEndpointParam
         WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
           AND ttEndpointParam.EndpointParamName = cApiQryParams[iy].
    ttEndpointParam.EndpointParamValue = ENTRY(ix,cPromptValue,"|").       
    IF ttEndpointParam.EndpointParamValue NE "" THEN 
      cQuery = cQuery 
             + (IF cQuery = "" THEN "?" ELSE "&") 
             + ttEndpointParam.EndpointParamName + "="
             + oJBoxParser:UrlEncode(ttEndpointParam.EndpointParamValue)           
             .
  END.           
END.               

oUri = NEW System.Uri(cApiURL + cQuery).

IF CAN-DO("PUT,POST",ttEndpoint.EndpointMethod) THEN DO:
  IF lcPutPost = "" THEN lcPutPost = ttEndpoint.EndpointPutPostInitial.
  RUN JBoxDLargeEditor.w (INPUT-OUTPUT lcPutPost,NO,NO,NO,"Add body content|blankIsOk",OUTPUT bOK).
  IF bOk THEN DO:
    IF lcPutPost = ? THEN lcPutPost = "".
    SESSION:SET-WAIT-STATE("general").
    IF ttEndpoint.EndpointPutPostCP NE "" THEN
      resultString = wc:UploadString(oUri:AbsoluteUri,ttEndpoint.EndpointMethod,CODEPAGE-CONVERT(STRING(lcPutPost),ttEndpoint.EndpointPutPostCP)).
    ELSE  
      resultString = wc:UploadString(oUri:AbsoluteUri,ttEndpoint.EndpointMethod,STRING(lcPutPost)).
  END.
  ELSE RETURN.
END.
ELSE DO:
  SESSION:SET-WAIT-STATE("general").
  resultString = wc:DownloadString(oUri:AbsoluteUri).
END.

IF INDEX(resultString,"\u00") > 0 THEN
  resultString = System.Text.RegularExpressions.Regex:Unescape(resultString).

lcJson = resultString.

IF VALID-HANDLE(hbttTables) THEN DO:
  hbttTables:FIND-FIRST("WHERE true") NO-ERROR.
  IF hbttTables:AVAIL THEN bRefreshSchema = NO.
  
  IF NOT ttEndpoint.EndpointAppend AND VALID-HANDLE(oJBoxParser:hdsResult) THEN DO:
    oJBoxParser:hdsResult:EMPTY-DATASET().
    FOR EACH ttTableViewTab 
        WHERE NOT CAN-DO("dict,apiparameters",ttTableViewTab.TableOrViewId) 
        :
      FIND FIRST ttView WHERE ttView.ViewId = ttTableViewTab.TableOrViewId NO-ERROR.
      IF AVAIL ttView THEN DO:
        IF VALID-HANDLE(ttView.hViewTable) THEN ttView.hViewTable:EMPTY-TEMP-TABLE().
      END.  
      ELSE DO:
        hbttTables:FIND-FIRST("WHERE TableName = '" + CAST(ttTableViewTab.oDataBrowseObj,"JBoxBrowse"):BUFFER-HANDLE:NAME + "'") NO-ERROR.
        IF hbttTables:AVAIL THEN 
          CAST(ttTableViewTab.oDataBrowseObj,"JBoxBrowse"):BUFFER-HANDLE:EMPTY-TEMP-TABLE().
      END.      
    END.
    FOR EACH ttTableViewWindow:
      FIND FIRST ttView WHERE ttView.ViewId = ttTableViewWindow.TableOrViewId NO-ERROR.
      IF AVAIL ttView THEN ttView.hViewTable:EMPTY-TEMP-TABLE().
    END.
  END.  
END.

IF NOT bRefreshSchema THEN DO:    
  
  // temp. copy in case new fields show up..
  IF ttEndpoint.EndpointAppend AND VALID-HANDLE(oJBoxParser:hdsResult) THEN DO:
    CREATE DATASET hOldDsResult.
    hOldDsResult:CREATE-LIKE(oJBoxParser:hdsResult).
    hOldDsResult:COPY-DATASET (oJBoxParser:hdsResult,NO,NO,YES).
  END.  
  
  IF resultString BEGINS "<" THEN
    oJBoxParser:appendXMLData(resultString).
  ELSE  
    oJBoxParser:appendData(resultString).
    
  IF oJBoxParser:statusMessage NE "" THEN DO:
    MESSAGE oJBoxParser:statusMessage
    VIEW-AS ALERT-BOX.  
    RETURN.
  END.
  IF oJBoxParser:schemaWarning NE "" AND ttEndpoint.EndpointMethod = "GET" THEN DO:
    bRefreshSchema = YES.
    MESSAGE "Schema warning:" SKIP
            oJBoxParser:schemaWarning SKIP(1)
            "Refresh?"
    VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO-CANCEL UPDATE bRefreshSchema.
    IF bRefreshSchema = ? THEN RETURN.  
    ELSE cRefreshSchema = "refreshSchema".
  END.  
  ELSE IF oJBoxParser:schemaWarning NE "" THEN 
    bRefreshSchema = YES.  
  ELSE bRefreshSchema = NO.
  
  IF NOT bRefreshSchema THEN DO:
    FOR EACH ttTableViewTab 
        WHERE NOT CAN-DO("dict,apiparameters",ttTableViewTab.TableOrViewId) 
        :
      FIND FIRST ttView WHERE ttView.ViewId = ttTableViewTab.TableOrViewId NO-ERROR.
      IF AVAIL ttView THEN DO:
        oJBoxParser:fillView(ttView.hViewTable,NO).
        CAST(ttTableViewTab.oDataBrowseObj,"JBoxBrowse"):OpenQuery().
        cViewsFilled = cViewsFilled + (IF cViewsFilled NE "" THEN "," ELSE "") + ttView.ViewId.
      END.
      ELSE DO:
        hbttTables:FIND-FIRST("WHERE TableName = '" + CAST(ttTableViewTab.oDataBrowseObj,"JBoxBrowse"):BUFFER-HANDLE:NAME + "'") NO-ERROR.
        IF hbttTables:AVAIL THEN DO:
          CAST(ttTableViewTab.oDataBrowseObj,"JBoxBrowse"):BUFFER-HANDLE:COPY-TEMP-TABLE(hbttTables::hBuffer:TABLE-HANDLE,YES,NO,YES).
          CAST(ttTableViewTab.oDataBrowseObj,"JBoxBrowse"):OpenQuery().
        END.
        ELSE DO:
          oTabBrowse:removePage(ttTableViewTab.TabPage#).
          renumTabs(ttTableViewTab.TabPage#).
          DELETE ttTableViewTab.
        END.  
      END.      
    END.
    FOR EACH ttTableViewWindow:
      FIND FIRST ttView WHERE ttView.ViewId = ttTableViewWindow.TableOrViewId NO-ERROR.
      IF AVAIL ttView THEN DO:
        IF NOT CAN-DO(cViewsFilled,ttView.ViewId) THEN
          oJBoxParser:fillView(ttView.hViewTable,NO).
        CAST(ttTableViewWindow.oDataBrowseObj,"JBoxDynDataBrowse"):BROWSE-OBJECT:OpenQuery().
      END.  
    END.
  END.  
END.
IF bRefreshSchema THEN DO:  
  FOR EACH ttTableViewTab:
    hTabProc = oTabBrowse:getPageHandle(ttTableViewTab.TabPage#) NO-ERROR.
    IF VALID-HANDLE(hTabProc) THEN
      APPLY "close" TO hTabProc.
    DELETE ttTableViewTab.  
  END.    
  IF VALID-OBJECT(oTabBrowse) THEN DO:
    oTabBrowse:Dispose() NO-ERROR.
    oContainer:DeleteUserControlByPlaceholder(TabBrowse:HANDLE IN FRAME {&FRAME-NAME}).
  END.
    
  IF lcJson BEGINS "<" THEN
    oJBoxParser:createXMLSchema(lcJson,cSchemaName).
  ELSE DO:
    oJBoxParser:fieldsUsedAsTableName = cFieldsUsedAsTableList.
    oJBoxParser:createSchema(lcJson,IF cRefreshSchema NE "" THEN cRefreshSchema ELSE cSchemaName).
  END.  
  IF cRefreshSchema NE "" THEN DO:
    IF VALID-HANDLE(hOldDsResult) THEN oJBoxParser:hdsResult:COPY-DATASET(hOldDsResult,YES,NO,YES).
    IF resultString BEGINS "<" THEN
      oJBoxParser:appendXMLData(resultString).
    ELSE  
      oJBoxParser:appendData(resultString).
  END.

  IF oJBoxParser:statusMessage = "" THEN DO:
    THIS-PROCEDURE:CURRENT-WINDOW:TITLE = (IF lcJson BEGINS "<" THEN "XML from " ELSE "Json from ") + cApiUrl.
    ViewSchema(). 
  END.
  ELSE do:
    MESSAGE "Error from parser:" SKIP oJBoxParser:statusMessage 
    VIEW-AS ALERT-BOX.
    // copy-lob from object resultString to file "c:\temp\ress.json".
  end.  
END.

CATCH ex AS System.Net.WebException :
  Srdr = NEW System.IO.StreamReader(ex:Response:GetResponseStream()).
  resultString = Srdr:ReadToEnd().
  MESSAGE STRING(resultString)
  VIEW-AS ALERT-BOX.
END CATCH.

FINALLY:
  IF VALID-HANDLE(hOldDsResult) THEN DELETE OBJECT hOldDsResult.      
  SESSION:SET-WAIT-STATE("").
END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseDictRecord C-Win 
PROCEDURE BrowseDictRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewId = "Dict"
     NO-ERROR.
IF AVAIL ttTableViewTab THEN 
  RemoveTabFromList(ttTableViewTab.TabPage#).

cCurrentTable = "Dict".
StartTab(?,"").
oPageBrowse:POPUP-MENU-OBJECT:addTool("CopyFields","Copy field names").

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

hbttTables:FIND-FIRST("WHERE Seq = " + icNode).

RUN BrowseDictRecord.

oTabBrowse:getPageBrowseObject(oTabBrowse:CurrTabNum):setFilter("TableName", "=",IF flatFile(NO) THEN ttCsvTable.TableName ELSE hbttTables::TableName).
oTabBrowse:getPageBrowseObject(oTabBrowse:CurrTabNum):openQuery().


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

DEF VAR hBuffer AS HANDLE NO-UNDO.
DEF VAR hTt     AS HANDLE NO-UNDO.
DEF VAR bCached AS LOG    NO-UNDO.

icNode = ENTRY(1,icNode,CHR(1)).

FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewId = icNode
     NO-ERROR.
IF AVAIL ttTableViewTab THEN DO:
  oTabBrowse:movePageToTop(ttTableViewTab.TabPage#).
  oTabBrowse:tabControl1:SelectTab(icNode).
END.           
ELSE DO:
  hbttTables:FIND-FIRST("WHERE Seq = " + icNode).

  PUBLISH "getIsCachedTempTable" (hbttTables::hBuffer:TABLE-HANDLE,OUTPUT bCached).
  IF bCached THEN DO:
    StartTab(hbttTables::hBuffer,"").
    RETURN.
  END.

  hBuffer = hbttTables::hBuffer. 
  CREATE TEMP-TABLE hTt.
  hTt:CREATE-LIKE(hBuffer).
  hTt:TEMP-TABLE-PREPARE(hbttTables::hBuffer:NAME).
  hTt:COPY-TEMP-TABLE (hBuffer). 
  StartTab(hTt:DEFAULT-BUFFER-HANDLE,"").
  
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseTableInSeparateWin C-Win 
PROCEDURE BrowseTableInSeparateWin :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

icNode = ENTRY(1,icNode,CHR(1)).

hbttTables:FIND-FIRST("WHERE seq = " + icNode) NO-ERROR.
IF NOT hbttTables:AVAIL THEN DO:
  MESSAGE "Programmers mistake - didn't find table" icNode
  VIEW-AS ALERT-BOX.
  RETURN. 
END.

FIND FIRST ttTableViewWindow
     WHERE ttTableViewWindow.TableOrViewId = icNode
       AND ttTableViewWindow.cType = "table"
     NO-ERROR.
IF AVAIL ttTableViewWindow AND VALID-OBJECT(ttTableViewWindow.oDataBrowseObj) AND VALID-HANDLE(ttTableViewWindow.hDataBrw) THEN
  CAST(ttTableViewWindow.oDataBrowseObj,"JBoxDynDataBrowse"):MoveToTop().     
ELSE DO:
  cSepWinType = "table". 
  oContainer:StartChildWindow("JboxDataBrw.w",hbttTables::hBuffer:NAME,YES). // -> myDataBrowseObject
END.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseView C-Win 
PROCEDURE BrowseView :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

//DEF VAR hTt     AS HANDLE NO-UNDO.

icNode = ENTRY(1,icNode,CHR(1)).

FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewId = icNode
     NO-ERROR.
IF AVAIL ttTableViewTab THEN DO:
  oTabBrowse:movePageToTop(ttTableViewTab.TabPage#).         
  oTabBrowse:tabControl1:SelectTab(icNode).
END.           
ELSE DO:
  FIND FIRST ttView WHERE ttView.ViewId = icNode NO-ERROR.
  IF NOT AVAIL ttView THEN DO:
    MESSAGE "Programmers mistake - didn't find view" icNode
    VIEW-AS ALERT-BOX.
    RETURN. 
  END.
  IF NOT VALID-HANDLE(ttView.hViewTable) THEN DO:
    ttView.hViewTable = oJBoxParser:createView(BuildViewDef(ttView.ViewId)).
    IF NOT VALID-HANDLE(ttView.hViewTable) THEN RETURN.
    ttView.hViewBuffer = ttView.hViewTable:DEFAULT-BUFFER-HANDLE.
  END.  
    
  StartTab(ttView.hViewBuffer,ttView.ViewId).
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BrowseViewInSeparateWin C-Win 
PROCEDURE BrowseViewInSeparateWin :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

icNode = ENTRY(1,icNode,CHR(1)).

FIND FIRST ttView WHERE ttView.ViewId = icNode NO-ERROR.
IF NOT AVAIL ttView THEN DO:
  MESSAGE "Programmers mistake - didn't find view" icNode
  VIEW-AS ALERT-BOX.
  RETURN. 
END.

FIND FIRST ttTableViewWindow
     WHERE ttTableViewWindow.TableOrViewId = ttView.ViewId
       AND ttTableViewWindow.cType = "view"
     NO-ERROR.
IF AVAIL ttTableViewWindow AND VALID-OBJECT(ttTableViewWindow.oDataBrowseObj) AND VALID-HANDLE(ttTableViewWindow.hDataBrw) THEN
  CAST(ttTableViewWindow.oDataBrowseObj,"JBoxDynDataBrowse"):MoveToTop().     
ELSE DO: 
  IF NOT VALID-HANDLE(ttView.hViewTable) THEN DO:
    ttView.hViewTable = oJBoxParser:createView(BuildViewDef(ttView.ViewId)).
    IF NOT VALID-HANDLE(ttView.hViewTable) THEN RETURN.
    ttView.hViewBuffer = ttView.hViewTable:DEFAULT-BUFFER-HANDLE.
  END.  
  cSepWinType = "view".
  oContainer:StartChildWindow("JboxDataBrw.w",ttView.ViewId,YES). // -> myDataBrowseObject 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ConnectOnlineRecord C-Win 
PROCEDURE ConnectOnlineRecord :
JBoxSession:Instance:SimpleSelectList("Documaster Arkivdel").
IF JBoxSession:Instance:SelectListOk THEN 
  CASE JBoxSession:Instance:SelectListValue:
    WHEN "Documaster Arkivdel" THEN DO:
      
    END.
  END CASE.  


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

JBoxSession:Instance:SimpleSelectList("Blank,Comma,Semicolon,=,DynQuery,TEMP-TABLE w/Format,TEMP-TABLE,STRING(<fld>):HANDLE + 'pipe' + ,", ",").
IF NOT JBoxSession:Instance:SelectListOk THEN RETURN.

cSelect = JBoxSession:Instance:SelectListValue.
CASE cSelect:
  WHEN "blank"      THEN cSep = " ".
  WHEN "Comma"      THEN cSep = ",".
  WHEN "Semicolon"  THEN cSep = ";".
  WHEN "TEMP-TABLE w/Format" THEN cSep = " AS <datatype> FORMAT <format>".
  WHEN "TEMP-TABLE" THEN cSep = " AS <datatype>".
  WHEN "="          THEN cSep = " = " + CHR(10) + "       ".
  WHEN "DynQuery"   THEN cSep = "'" + CHR(10) + "   + ';".
  OTHERWISE              ASSIGN cSep = REPLACE(JBoxSession:Instance:SelectListValue,"pipe","|")
                                bRepl = YES.
END CASE.
  
DO ix = 1 TO hBrowse:NUM-SELECTED-ROWS:
  IF hBrowse:FETCH-SELECTED-ROW(ix) THEN DO:
    IF ix = 1 AND cSelect BEGINS "TEMP-TABLE" THEN
      cFields = "DEF TEMP-TABLE tt" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("TableName"):BUFFER-VALUE.
      
    cFld    = hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("FieldName"):BUFFER-VALUE.
    
    IF cSelect BEGINS "TEMP-TABLE" THEN DO:
      ASSIGN cFldProp = cSep
             cFldProp = REPLACE(cFldProp,"<datatype>",hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("DataType"):BUFFER-VALUE)
             cFldProp = REPLACE(cFldProp,"<format>", "'" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("FormatString"):BUFFER-VALUE + "'")                   
             .                  
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


/*
DEF VAR ix       AS INT NO-UNDO.
DEF VAR cFields  AS CHAR NO-UNDO.
DEF VAR hBrowse  AS HANDLE NO-UNDO.
DEF VAR cSep     AS CHAR NO-UNDO.
DEF VAR cFld     AS CHAR NO-UNDO.
DEF VAR bRepl    AS LOG  NO-UNDO.
DEF VAR cSelect  AS CHAR NO-UNDO.
DEF VAR cFldProp AS CHAR NO-UNDO.

hBrowse = oTabBrowse:getPageBrowseObject(oTabBrowse:CurrTabNum):BROWSE-HANDLE.

JBoxSession:Instance:SimpleSelectList("Blank,Comma,Semicolon,=,DynQuery,TEMP-TABLE w/Format,TEMP-TABLE,STRING(<fld>):HANDLE + 'pipe' + ,", ",").
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
      cFields = "DEF TEMP-TABLE tt" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("TableName"):BUFFER-VALUE.
      
    cFld    = hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("FieldName"):BUFFER-VALUE.
    
    IF cSelect BEGINS "TEMP-TABLE" THEN DO:
      ASSIGN cFldProp = cSep
             cFldProp = REPLACE(cFldProp,"<datatype>",hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("DataType"):BUFFER-VALUE)
             cFldProp = REPLACE(cFldProp,"<format>", "'" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("FormatString"):BUFFER-VALUE + "'")                   
             .                  
/*      IF hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cLabel"):BUFFER-VALUE NE ? THEN                                                    */
/*        cFldProp = REPLACE(cFldProp,"<label>","LABEL " + "'" + hBrowse:QUERY:GET-BUFFER-HANDLE (1):BUFFER-FIELD("cLabel"):BUFFER-VALUE + "'").*/
/*      ELSE                                                                                                                                    */
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
*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateEndpointRecord C-Win 
PROCEDURE CreateEndpointRecord :
DEF VAR bOkName       AS LOG  NO-UNDO.
DEF VAR ix            AS INT  NO-UNDO.
DEF VAR Char1         AS INT  NO-UNDO.
DEF VAR cEndpointName AS CHAR NO-UNDO.
DEF VAR iSaveExisting AS INT  NO-UNDO.

FIND FIRST ttEndpoint NO-ERROR.
IF AVAIL ttEndpoint THEN DO:
  iSaveExisting = JBoxSession:Instance:ViewQuestionYesNoCancel("Save existing endpoint?").
  IF iSaveExisting = 1 THEN
    RUN saveEndpointRecord.
  ELSE IF iSaveExisting = 3 THEN RETURN.   
END.  

ClearAll().

REPEAT WHILE NOT bOkName:  

  JBoxSession:Instance:PromptForValues("Endpoint",
                                       "Name (schema)|CHARACTER|x(32)"
                                     + "¤Url|CHARACTER|x(300)"
                                     + "¤Method|CHARACTER|X(4)|GET|GET|GET|POST|POST|PUT|PUT"
                                       ).
  IF JBoxSession:Instance:PromptValueOk THEN DO:
    cEndpointName = ENTRY(1,JBoxSession:Instance:PromptValue,"|").
    
    DO ix = 1 TO LENGTH(cEndpointName): 
      Char1 = ASC(SUBSTR(cEndpointName,ix,1)).
      IF (Char1 < 48 OR (Char1 > 57 AND Char1 < 65) OR (Char1 > 90 AND Char1 < 97) OR Char1 > 122) AND NOT CAN-DO("45,95",STRING(Char1)) THEN DO:
        bOkName = NO.
        LEAVE.
      END.
      ELSE bOkName = YES.  
    END.
    
    IF NOT bOkName THEN 
      MESSAGE "Invalid character in endpoint (schema) name: " CHR(Char1) + (IF Char1 = 32 THEN " (space)" ELSE "")
              VIEW-AS ALERT-BOX.                
  END.  
  ELSE LEAVE.       
END.                                       
IF bOkName THEN DO:
  CREATE ttEndpoint.
  ASSIGN ttEndpoint.EndpointName   = cEndpointName
         ttEndpoint.EndpointUrl    = ENTRY(2,JBoxSession:Instance:PromptValue,"|")
         ttEndpoint.EndpointMethod = ENTRY(3,JBoxSession:Instance:PromptValue,"|")
         .
  IF CAN-DO("PUT,POST",ttEndpoint.EndpointMethod) THEN DO:  
    RUN JBoxDLargeEditor.w (INPUT-OUTPUT lcPutPost,NO,NO,NO,"Set initial value for body content",OUTPUT bOK).
    IF bOk THEN
      ttEndpoint.EndpointPutPostInitial = STRING(lcPutPost).
    JBoxSession:Instance:PromptForValues("Body codepage " + ttEndpoint.EndpointMethod,
                                         "Codepage|CHARACTER|X(12)|UTF-8"
                                         ).
    IF JBoxSession:Instance:PromptValueOk THEN 
      ttEndpoint.EndpointPutPostCP = JBoxSession:Instance:PromptValue.
  END.
  ViewSchema().       
END.         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CreateViewRecord C-Win 
PROCEDURE CreateViewRecord :
DEF VAR bOkName   AS LOG  NO-UNDO.
DEF VAR ix        AS INT  NO-UNDO.
DEF VAR Char1     AS INT NO-UNDO.
DEF VAR cViewName AS CHAR NO-UNDO.

REPEAT WHILE NOT bOkName:  
  JBoxSession:Instance:PromptForValue("Name of view","CHARACTER","x(32)",cViewName).
  IF JBoxSession:Instance:PromptValueOk THEN DO:
    cViewName = JBoxSession:Instance:PromptValue.
    
    DO ix = 1 TO LENGTH(cViewName): 
      Char1 = ASC(SUBSTR(cViewName,ix,1)).
      IF Char1 < 48 OR (Char1 > 57 AND Char1 < 65) OR (Char1 > 90 AND Char1 < 97) OR Char1 > 122 THEN DO:
        bOkName = NO.
        LEAVE.
      END.
      ELSE bOkName = YES.  
    END.
    
    IF bOkName THEN DO:
      FIND FIRST ttView WHERE ttView.ViewId = JBoxSession:Instance:PromptValue NO-ERROR.
      IF AVAIL ttView THEN DO:
        MESSAGE "View " JBoxSession:Instance:PromptValue " already exists"
                 VIEW-AS ALERT-BOX.
        NEXT.         
      END.  
      hbttTables:FIND-FIRST("WHERE TableName = '" + JBoxSession:Instance:PromptValue + "'") NO-ERROR.
      IF hbttTables:AVAIL THEN DO:
        MESSAGE JBoxSession:Instance:PromptValue " already in use for table"
                VIEW-AS ALERT-BOX.
        NEXT.         
      END.  
      
      CREATE ttView.
      ASSIGN ttView.ViewId = JBoxSession:Instance:PromptValue
             .
      ViewSchema().
    END.
    ELSE MESSAGE "Invalid character in view name: " CHR(Char1) + (IF Char1 = 32 THEN " (space)" ELSE "")
         VIEW-AS ALERT-BOX.                
  END.
  ELSE bOkName = YES.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteEndpoingQueryParamRecord C-Win 
PROCEDURE DeleteEndpoingQueryParamRecord :
DEF VAR cParameters AS CHAR NO-UNDO.

DEF BUFFER ttEndPointParam FOR ttEndPointParam.  

FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndPointParamType = "Q"
       BY ttEndpointParam.EndpointParamSeq:
  cParameters = cParameters + (IF cParameters NE "" THEN "|" ELSE "")
              + ttEndpointParam.EndpointParamName
              .
END.
IF cParameters = "" THEN DO:
  MESSAGE "No query parameters defined"
  VIEW-AS ALERT-BOX.
  RETURN.
END.  
JBoxSession:Instance:SimpleSelectList(cParameters,"|",NO,"Select parameter").
IF JBoxSession:Instance:SelectListOk THEN DO:
  FIND FIRST ttEndpointParam
       WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
         AND ttEndpointParam.EndPointParamType = "Q"
         AND ttEndpointParam.EndpointParamName = JBoxSession:Instance:SelectListValue
       NO-ERROR.
  IF AVAIL ttEndpointParam THEN DELETE ttEndpointParam.
  ELSE MESSAGE "Error - could not find query parameter" JBoxSession:Instance:SelectListValue
       VIEW-AS ALERT-BOX.
END.             


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteEndPointHeaderParamRecord C-Win 
PROCEDURE DeleteEndPointHeaderParamRecord :
DEF VAR cParameters AS CHAR NO-UNDO.

DEF BUFFER ttEndPointParam FOR ttEndPointParam.  

FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndPointParamType = "H"
       BY ttEndpointParam.EndpointParamSeq:
  cParameters = cParameters + (IF cParameters NE "" THEN "|" ELSE "")
              + ttEndpointParam.EndpointParamName
              .
END.
IF cParameters = "" THEN DO:
  MESSAGE "No header parameters defined"
  VIEW-AS ALERT-BOX.
  RETURN.
END.  
JBoxSession:Instance:SimpleSelectList(cParameters,"|",NO,"Select parameter").
IF JBoxSession:Instance:SelectListOk THEN DO:
  FIND FIRST ttEndpointParam
       WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
         AND ttEndpointParam.EndPointParamType = "H"
         AND ttEndpointParam.EndpointParamName = JBoxSession:Instance:SelectListValue
       NO-ERROR.
  IF AVAIL ttEndpointParam THEN DELETE ttEndpointParam.
  ELSE MESSAGE "Error - could not find header parameter" JBoxSession:Instance:SelectListValue
       VIEW-AS ALERT-BOX.
END.             


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteViewTable C-Win 
PROCEDURE DeleteViewTable :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF VAR cFieldList AS CHAR NO-UNDO.
DEF VAR ix         AS INT NO-UNDO.
DEF VAR hTabProc   AS HANDLE NO-UNDO.

DEF BUFFER bttViewTables FOR ttViewTables.

FIND FIRST ttView
     WHERE ttView.ViewId = ENTRY(1,icNode,CHR(1))
     NO-ERROR.

FIND FIRST ttViewTables
     WHERE ttViewTables.ViewId = ENTRY(1,icNode,CHR(1))
       AND ttViewTables.ViewTableId = ENTRY(2,icNode,CHR(1))
     NO-ERROR.

IF AVAIL ttViewTables AND JBoxSession:Instance:ViewQuestionOkCancel("Delete " + ttViewTables.TableName + " (with child tables)") THEN DO:
  deleteViewTables(ttView.ViewId,ttViewTables.ViewTableId).
  DELETE ttViewTables.
  ReCreateView(ttView.ViewId).
  ViewSchema().
  FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewId = ENTRY(1,icNode,CHR(1))
       NO-ERROR.
  IF AVAIL ttTableViewTab THEN DO:
    oTabBrowse:removePage(ttTableViewTab.TabPage#).
    renumTabs(ttTableViewTab.TabPage#).
    DELETE ttTableViewTab.
    RUN BrowseView(ENTRY(1,icNode,CHR(1))).  
  END.    
END.
ELSE IF NOT AVAIL ttViewTables THEN
  MESSAGE "Programmers mistake - couldn't find view-table" icNode
  VIEW-AS ALERT-BOX.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditEndpointHeaderParamRecord C-Win 
PROCEDURE EditEndpointHeaderParamRecord :
DEF VAR cParameters AS CHAR NO-UNDO.

DEF BUFFER ttEndPointParam FOR ttEndPointParam.  

FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndPointParamType = "H"
       BY ttEndpointParam.EndpointParamSeq:
  cParameters = cParameters + (IF cParameters NE "" THEN "|" ELSE "")
              + ttEndpointParam.EndpointParamName
              .
END.
IF cParameters = "" THEN DO:
  MESSAGE "No header parameters defined"
  VIEW-AS ALERT-BOX.
  RETURN.
END.  
JBoxSession:Instance:SimpleSelectList(cParameters,"|",NO,"Select parameter").
IF JBoxSession:Instance:SelectListOk THEN DO:
  FIND FIRST ttEndpointParam
       WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
         AND ttEndpointParam.EndPointParamType = "H"
         AND ttEndpointParam.EndpointParamName = JBoxSession:Instance:SelectListValue
       NO-ERROR.
  IF AVAIL ttEndpointParam THEN DO:
    JBoxSession:Instance:PromptForValue("Edit " + ttEndpointParam.EndpointParamName + " header parameter",
                                        "Value|CHARACTER|x(200)|" + ttEndpointParam.EndpointParamValue
                                        + "¤Input seq|INTEGER|>>9|" + STRING(ttEndpointParam.EndpointParamSeq)
                                        ).

    IF JBoxSession:Instance:PromptValueOk THEN 
      ASSIGN ttEndpointParam.EndPointParamValue = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
             ttEndpointParam.EndpointParamSeq = INT(ENTRY(2,JBoxSession:Instance:PromptValue,"|"))
             .
  END.
  ELSE MESSAGE "Error - could not find header parameter" JBoxSession:Instance:SelectListValue
       VIEW-AS ALERT-BOX.
END.             

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE editEndpointParam C-Win 
PROCEDURE editEndpointParam :
IF AVAIL ttEndpointParam THEN DO WITH FRAME {&FRAME-NAME}:
    
    IF ttEndpointParam.EndPointParamType = "H" THEN DO:
      JBoxSession:Instance:PromptForValue("Edit " + ttEndpointParam.EndpointParamName + " header parameter",
                                      "Value|CHARACTER|x(200)|" + ttEndpointParam.EndPointParamValue
                                      + "¤Input seq|INTEGER|>>9|" + STRING(ttEndpointParam.EndpointParamSeq)
                                      ).

      IF JBoxSession:Instance:PromptValueOk THEN 
        ASSIGN ttEndpointParam.EndPointParamInitial = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
               ttEndpointParam.EndpointParamSeq = INT(ENTRY(2,JBoxSession:Instance:PromptValue,"|"))
               ttEndpointParam.EndpointParamValue = ttEndpointParam.EndPointParamInitial
               .
    END.  
    ELSE DO:
      JBoxSession:Instance:PromptForValue("Edit " + ttEndpointParam.EndpointParamName + " query parameter",
                                    "Data type|CHARACTER|x(200)|"
                                      + ttEndpointParam.EndPointParamDataType
                                      + "|Character|CHARACTER|Decimal|DECIMAL|Integer|INTEGER|Iso-date|ISO-DATE|Logical|LOGICAL"
                                    + "¤Required|LOGICAL|Yes/No|" + STRING(ttEndpointParam.EndPointParamMandatory,"Yes/No") 
                                       + "|Yes|Yes|No|No"
                                    + "¤Value|CHARACTER|x(200)|" + ttEndpointParam.EndPointParamValue
                                    + "¤Role|CHARACTER|x(8)|" + ttEndpointParam.EndPointParamRole + "|Filter|filter|Query - page|querypage|Query - pagesize|querysize|Query - sort|querysort"
                                    + "¤Input seq|INTEGER|>>9|" + STRING(ttEndpointParam.EndpointParamSeq)
                                          ).
  
      IF JBoxSession:Instance:PromptValueOk THEN 
        ASSIGN ttEndpointParam.EndPointParamDataType = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
               ttEndpointParam.EndPointParamMandatory = LOGICAL(ENTRY(2,JBoxSession:Instance:PromptValue,"|"))
               ttEndpointParam.EndPointParamInitial = ENTRY(3,JBoxSession:Instance:PromptValue,"|")
               ttEndpointParam.EndPointParamRole = ENTRY(4,JBoxSession:Instance:PromptValue,"|")
               ttEndpointParam.EndpointParamSeq = INT(ENTRY(5,JBoxSession:Instance:PromptValue,"|"))
               ttEndpointParam.EndpointParamValue = ttEndpointParam.EndPointParamInitial
               .
    END.
    oPageBrowse:OpenQuery().
  END.     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditEndpointQueryParamRecord C-Win 
PROCEDURE EditEndpointQueryParamRecord :
DEF VAR cParameters      AS CHAR NO-UNDO.
DEF VAR cMapFilterFields AS CHAR NO-UNDO.

DEF BUFFER ttEndPointParam FOR ttEndPointParam.  

FOR EACH ttEndpointParam
    WHERE ttEndpointParam.EndPointParamType = "Q"
       BY ttEndpointParam.EndpointParamSeq:
  cParameters = cParameters + (IF cParameters NE "" THEN "|" ELSE "")
              + ttEndpointParam.EndpointParamName
              .
END.
IF cParameters = "" THEN DO:
  MESSAGE "No query parameters defined"
  VIEW-AS ALERT-BOX.
  RETURN.
END.  
JBoxSession:Instance:SimpleSelectList(cParameters,"|",NO,"Select parameter").
IF JBoxSession:Instance:SelectListOk THEN DO:
  FIND FIRST ttEndpointParam
       WHERE ttEndpointParam.EndpointName = ttEndpoint.EndpointName
         AND ttEndpointParam.EndPointParamType = "Q"
         AND ttEndpointParam.EndpointParamName = JBoxSession:Instance:SelectListValue
       NO-ERROR.
  IF AVAIL ttEndpointParam THEN DO:
    JBoxSession:Instance:PromptForValue("Edit " + ttEndpointParam.EndpointParamName + " query parameter",
                                  "Data type|CHARACTER|x(200)|"
                                    + ttEndpointParam.EndPointParamDataType
                                    + "|Character|CHARACTER|Decimal|DECIMAL|Integer|INTEGER|Iso-date|ISO-DATE|Logical|LOGICAL"
                                  + "¤Required|LOGICAL|Yes/No|" + STRING(ttEndpointParam.EndPointParamMandatory,"Yes/No") 
                                     + "|Yes|Yes|No|No"
                                  + "¤Value|CHARACTER|x(200)|" + ttEndpointParam.EndpointParamValue
                                  + "¤Role|CHARACTER|x(8)|" + ttEndpointParam.EndPointParamRole + "|Filter|filter|Query - page|querypage|Query - pagesize|querysize|Query - sort|querysort"
                                  + "¤Input seq|INTEGER|>>9|" + STRING(ttEndpointParam.EndpointParamSeq)
                                        ).

    IF JBoxSession:Instance:PromptValueOk THEN DO:
      ASSIGN ttEndpointParam.EndPointParamDataType = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
             ttEndpointParam.EndPointParamMandatory = LOGICAL(ENTRY(2,JBoxSession:Instance:PromptValue,"|"))
             ttEndpointParam.EndpointParamValue = ENTRY(3,JBoxSession:Instance:PromptValue,"|")
             ttEndpointParam.EndPointParamRole = ENTRY(4,JBoxSession:Instance:PromptValue,"|")
             ttEndpointParam.EndpointParamSeq = INT(ENTRY(5,JBoxSession:Instance:PromptValue,"|"))
             .
      /*
      IF ttEndpointParam.EndPointParamRole = "filter" 
         AND CAN-FIND(FIRST ttView) 
         AND NOT CAN-FIND(FIRST ttViewFields WHERE ttViewFields.FieldName = ttEndpointParam.EndpointParamName)
//         AND NOT CAN-FIND(FIRST ttViewFields WHERE ttViewFields.FieldName = ttEndpointParam.EndPointFilterMapField)
         THEN DO:
        FOR EACH ttViewFields:
          cMapFilterFields = cMapFilterFields + (IF cMapFilterFields NE "" THEN "|" ELSE "")
                           + ttViewFields.ViewId + "." + ttViewFields.FieldName + "|" + ttViewFields.FieldName
                           .
        END.      
        IF cMapFilterFields NE "" THEN DO:
          JBoxSession:Instance:SimpleSelectListPairs(cMapFilterFields,"|",NO
                                                    ,"Map " + ttEndpointParam.EndpointParamName + " to field").
          IF JBoxSession:Instance:SelectListOk THEN
            ttEndpointParam.EndPointFilterMapField = JBoxSession:Instance:SelectListValue.
        END.  
      END.   
      */         
    END.         
  END.
  ELSE MESSAGE "Error - could not find query parameter" JBoxSession:Instance:SelectListValue
       VIEW-AS ALERT-BOX.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditEndpointRecord C-Win 
PROCEDURE EditEndpointRecord :
IF NOT AVAIL ttEndpoint THEN FIND FIRST ttEndpoint NO-ERROR.
  IF NOT AVAIL ttEndpoint THEN DO:
    MESSAGE "Endpoint not available"
    VIEW-AS ALERT-BOX.
    RETURN.
  END.
  
  JBoxSession:Instance:PromptForValues("Edit endpoint " + ttEndpoint.EndpointName,
                                       "Url|CHARACTER|x(300)|" + ttEndpoint.EndpointUrl
                                     + "¤Method|CHARACTER|X(4)|" + ttEndpoint.EndpointMethod + "|GET|GET|POST|POST|PUT|PUT"
                                       ).
  IF JBoxSession:Instance:PromptValueOk THEN DO: 
    ASSIGN ttEndpoint.EndpointUrl    = ENTRY(1,JBoxSession:Instance:PromptValue,"|")
           ttEndpoint.EndpointMethod = ENTRY(2,JBoxSession:Instance:PromptValue,"|")
           .
    IF CAN-DO("PUT,POST",ttEndpoint.EndpointMethod) THEN DO:
      lcPutPost = ttEndpoint.EndpointPutPostInitial.  
      RUN JBoxDLargeEditor.w (INPUT-OUTPUT lcPutPost,NO,NO,NO,"Set initial value body content",OUTPUT bOK).
      IF bOk THEN
        ttEndpoint.EndpointPutPostInitial = STRING(lcPutPost).
      JBoxSession:Instance:PromptForValues("Body codepage " + ttEndpoint.EndpointMethod,
                                           "Codepage|CHARACTER|X(12)|" + ttEndpoint.EndpointPutPostCP
                                           ).
      IF JBoxSession:Instance:PromptValueOk THEN 
        ttEndpoint.EndpointPutPostCP = JBoxSession:Instance:PromptValue.
    END.
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
  DISPLAY tbViewFields tbViewSerialized JBoxMsTreeView 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE TabBrowse tbJson LoadFile_tbJson PasteJson_tbJson API_tbJson 
         CreateView_tbJson tbViewFields JBoxMsTreeView 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  ENABLE btnSplitBarX 
      WITH FRAME frSplitBarX IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-frSplitBarX}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSelectorAttributes C-Win 
PROCEDURE getSelectorAttributes :
DEF INPUT  PARAM ihBrwSource AS HANDLE NO-UNDO.
DEF INPUT  PARAM ihBrwTarget AS HANDLE NO-UNDO.
DEF INPUT  PARAM icDeSelRows AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oiReturn    AS INT    NO-UNDO.

DEF VAR oBrwSample        AS JBoxBrowse NO-UNDO.

IF VALID-HANDLE(JBoxServerAPI:Instance:SELECTOR-PANEL-HANDLE) THEN DO:
  oBrwSample = DYNAMIC-FUNCTION("getBrowseObject" IN JBoxServerAPI:Instance:SELECTOR-PANEL-HANDLE).
  
  ASSIGN cFlatFileFilterFields  = oBrwSample:gridFilterFieldsInUse 
         cFlatFileOperInUseList = oBrwSample:gridFilterOperatorsInUse 
         cFlatFileFilterValList = oBrwSample:gridFilterValuesInUse 
         cFlatFileTableName     = oBrwSample:getJBoxAttribute("importTableName") 
         iFlatFileImpMaxRows    = INT(oBrwSample:getJBoxAttribute("importMaxRows"))
         cFlatFileCodePage      = oBrwSample:getJBoxAttribute("importCodePage") 
         .
END.          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeChild C-Win 
PROCEDURE InitializeChild :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihChild AS HANDLE NO-UNDO.

IF CAN-DO(ihChild:INTERNAL-ENTRIES,"setAddExtraTools") THEN
  DYNAMIC-FUNCTION("setAddExtraTools" IN ihChild,YES).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeComponents C-Win 
PROCEDURE InitializeComponents :
&IF DEFINED(AdvGuiWin) &THEN
DO WITH FRAME {&FRAME-NAME}:

  oJBoxMsTreeView = NEW uc.JBoxMsTreeView(THIS-PROCEDURE,JBoxMsTreeView:HANDLE,
                      "tvpics\Fold.bmp,tvpics\FoldOpen.bmp,newbmp\CIORD16E.BMP,bmp\tbls.bmp,newbmp\application.bmp,tvpics\users.BMP,tvpics\user.bmp,bmp\bullet_triangle_green.bmp,bmp\del16e.bmp").
//                      "tvpics\Fold.bmp,tvpics\FoldOpen.bmp,newbmp\LIGHT161.BMP,newbmp\LIGHT163.BMP,newbmp\user.bmp,tvpics\users.BMP,tvpics\user.bmp,bmp\bullet_triangle_green.bmp").
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
  oContainer:addStatusBar("450,40,60").
&ENDIF

DO WITH FRAME {&FRAME-NAME}:
  SUBSCRIBE TO "TreeNodeDropped" ANYWHERE.

  RUN InitializeComponents.
  
  TabBrowse:HANDLE:VISIBLE = NO.
   
  oJBoxParser = NEW JBoxJsonParser().

  oContainer:setSplitBarX(btnSplitBarX:HANDLE IN FRAME frSplitBarX).
  oContainer:setFollowSplitBarX(STRING(JBoxMsTreeView:HANDLE) + "," + STRING(TabBrowse:HANDLE)).
  oContainer:setNoResizeX("JBoxMsTreeView").
  otbJson = NEW JBoxToolbar(tbJson:HANDLE).

END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize(500,100).
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadDataFromFileRecord C-Win 
PROCEDURE LoadDataFromFileRecord :
DEF VAR cFileName AS CHAR     NO-UNDO.
DEF VAR bOk       AS LOG      NO-UNDO.
DEF VAR lcFile    AS LONGCHAR NO-UNDO.
DEF VAR hTabProc  AS HANDLE   NO-UNDO.
DEF VAR hProgBar  AS HANDLE   NO-UNDO.

SYSTEM-DIALOG GET-FILE cFileName
              FILTERS "Json files" "*.json", "Text files" "*.txt" 
              INITIAL-FILTER 1 
              INITIAL-DIR "c:\temp"
              UPDATE bOk.
IF bOk THEN DO WITH FRAME {&FRAME-NAME}:
  FOR EACH ttTableViewTab:
    hTabProc = oTabBrowse:getPageHandle(ttTableViewTab.TabPage#) NO-ERROR.
    IF VALID-HANDLE(hTabProc) THEN
      APPLY "close" TO hTabProc.
    DELETE ttTableViewTab.  
  END.    
  IF VALID-OBJECT(oTabBrowse) THEN DO:
    oTabBrowse:Dispose() NO-ERROR.
    DYNAMIC-FUNCTION("DeleteUserControlByPlaceholder",TabBrowse:HANDLE).
//    DELETE OBJECT oTabBrowse.
  END.
    
  EMPTY TEMP-TABLE ttView.

  FIX-CODEPAGE(lcFile) = "UTF-8".

/*  RUN JBoxProgressBar.w PERSISTENT SET hProgBar.                          */
/*  DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 10,"Imports file..").*/

  SESSION:SET-WAIT-STATE("general").

  RUN ReadFileInChunks (cFileName,OUTPUT lcFile).
//  COPY-LOB FROM FILE cFileName TO lcFile.
//  DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 30,"Reads data..").
  oJBoxParser:LoadData(lcFile).
//  DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 100,"Reads data..").
  IF oJBoxParser:statusMessage = "" THEN DO:
    THIS-PROCEDURE:CURRENT-WINDOW:TITLE = cFileName.
    IF oJBoxParser:schemaWarning NE "" THEN 
      MESSAGE oJBoxParser:schemaWarning 
              VIEW-AS ALERT-BOX.
    
//    ViewSchema(). 
    
  //  oJBoxParser:viewSchemaDS().
  //  oJBoxParser:viewResultDS().
  //  oJBoxParser:viewTtTables().
  END.
  ELSE 
    MESSAGE oJBoxParser:statusMessage 
    VIEW-AS ALERT-BOX.
  
END.

FINALLY:
  SESSION:SET-WAIT-STATE("").
END FINALLY.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadEndpointDefRecord C-Win 
PROCEDURE LoadEndpointDefRecord :
DEF VAR cFileName    AS CHAR NO-UNDO.
DEF VAR bOk          AS LOG  NO-UNDO.
DEF VAR hDsEndpoint  AS HANDLE NO-UNDO.
DEF VAR ix           AS INT NO-UNDO.
DEF VAR iy           AS INT NO-UNDO.
DEF VAR hbttSchema   AS HANDLE NO-UNDO.
DEF VAR hbttEndpoint AS HANDLE NO-UNDO.
DEF VAR hEndPointFld AS HANDLE NO-UNDO.
DEF VAR cSchemaName  AS CHAR   NO-UNDO.
DEF VAR hQuery       AS HANDLE NO-UNDO.

SYSTEM-DIALOG GET-FILE cFileName
              FILTERS "Endpoint definition files" "*.json" 
              UPDATE bOk.
              
IF bOk THEN DO WITH FRAME {&FRAME-NAME}:
  IF LoadEndpoint(cFileName) THEN DO:
    ViewSchema().
    oContainer:statusBar:StatusText2 = cFileName.
    
    FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewName = "APIparameters"
         NO-ERROR.
    IF AVAIL ttTableViewTab THEN DO:
      oTabBrowse:movePageToTop(ttTableViewTab.TabPage#).         
      oTabBrowse:tabControl1:SelectTab(ttTableViewTab.TableOrViewName).
    END.  
    ELSE DO:
      hbttEndpoint = BUFFER ttEndpointParam:HANDLE.
      cCurrentTable = "|APIparameters".
      StartTab(hbttEndpoint,cCurrentTable).
    END.  
    
  END.   
    
  /*  
  clearAll().
  CREATE DATASET hDsEndpoint.
  hDsEndpoint:READ-JSON ("file",cFileName,"empty").
  DO ix = 1 TO hDsEndpoint:NUM-BUFFERS:
    IF CAN-DO("ttTables,ttFields",hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME) THEN DO:
      CREATE QUERY hQuery.
      hbttSchema = oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME).
      hbttEndpoint = hDsEndpoint:GET-BUFFER-HANDLE (ix).
      hQuery:SET-BUFFERS (hbttEndpoint).
      hQuery:QUERY-PREPARE ("FOR EACH " + hbttEndpoint:NAME).
      hQuery:QUERY-OPEN ().
      REPEAT WHILE hQuery:GET-NEXT().
        hbttSchema:BUFFER-CREATE ().
        DO iy = 1 TO hbttSchema:NUM-FIELDS:
          hEndPointFld = hbttEndpoint:BUFFER-FIELD(hbttSchema:BUFFER-FIELD (iy):NAME) NO-ERROR.
          IF VALID-HANDLE (hEndPointFld) THEN
            hbttSchema:BUFFER-FIELD (iy):BUFFER-VALUE = hEndPointFld:BUFFER-VALUE. 
        END.
        IF hbttEndpoint:NAME = "ttTables" AND cSchemaName = "" THEN
          cSchemaName = hbttEndpoint::TableName. 
      END.
      DELETE OBJECT hQuery.
    END.
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttEndpoint" THEN 
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttEndpoint:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttEndpointParam" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttEndpointParam:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttView" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttView:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttViewTables" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttViewTables:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttViewFields" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttViewFields:HANDLE).
  END.
  
/*  def var htt as handle no-undo. */
/*  htt = buffer ttEndpoint:HANDLE.*/
/*  run toexcelviafile.p (htt,-2). */
  
  oJBoxParser:cSchemaName = cSchemaName.
  oJBoxParser:LoadSchema("").
  IF oJBoxParser:statusMessage NE "" THEN
    MESSAGE "Parser status message" SKIP oJBoxParser:statusMessage
    VIEW-AS ALERT-BOX.
  ViewSchema().
  */ 
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadFileRecord C-Win 
PROCEDURE LoadFileRecord :
DEF VAR cFileName AS CHAR NO-UNDO.
DEF VAR bOk       AS LOG  NO-UNDO.
DEF VAR cFilter   AS CHAR NO-UNDO.
DEF VAR cFileList AS CHAR NO-UNDO.
DEF VAR ix        AS INT  NO-UNDO. 
DEF VAR oFiles    AS JBoxSelectFiles NO-UNDO.


IF PROGRESS GE "12.8" THEN 
  cFilter = "Json files (.json)|*.json"
          + "|XML files (*.xml)|*.xml"
          + "|Csv files (.csv)|*.csv"
          + "|Excel files (.xls*)|*.xls*"
          + "|Txt files (pipe or tab-sep)|*.*"
          .
ELSE          
  cFilter = "Json files (.json)|*.json"
          + "|XML files (*.xml)|*.xml"
          .

oFiles = NEW JBoxSelectFiles(cFilter,"","If multiple files are selected they must be of equal type and format",BUFFER ttFiles:HANDLE).

FOR EACH ttFiles:
  ASSIGN ix = ix + 1
         cFileList = cFileList + (IF cFileList NE "" THEN "|" ELSE "") + ttFiles.FileName.
  IF ix MOD 50 = 0 THEN DO:       
    RUN TreeDropFiles(cFileList,"").
    cFileList = "".
  END.
END.
IF cFileList NE "" THEN                                                    
  RUN TreeDropFiles(cFileList,"").                         
                         
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadFlatFileList C-Win 
PROCEDURE loadFlatFileList :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR httFlatFileSchema AS HANDLE NO-UNDO.
DEF VAR cErrMsg           AS CHAR NO-UNDO.
DEF VAR ix                AS INT  NO-UNDO.
DEF VAR cFieldPropList    AS CHAR NO-UNDO.
DEF VAR cFieldList        AS CHAR NO-UNDO.
DEF VAR cIndexFldList     AS CHAR NO-UNDO.
DEF VAR cFieldCheck       AS CHAR NO-UNDO.

IF NOT VALID-HANDLE(hCallFileParser) THEN
  RUN JBoxCallFileParser.p PERSIST SET hCallFileParser.

EMPTY TEMP-TABLE ttFlatFileFields.

FIND FIRST ttCsvTable NO-ERROR.
IF NOT AVAIL ttCsvTable THEN CREATE ttCsvTable.
ttCsvTable.seq = 1.

SESSION:SET-WAIT-STATE("general").

RUN getSample IN hCallFileParser (ENTRY(1,cFlatFileList),OUTPUT httFlatFile,OUTPUT httFlatFileSchema,OUTPUT cErrMsg).

SESSION:SET-WAIT-STATE("").

IF cErrMsg NE "" THEN DO: 
  MESSAGE cErrMsg
  VIEW-AS ALERT-BOX.
  RETURN. 
END.   
  
BUFFER ttFlatFileFields:COPY-TEMP-TABLE (httFlatFileSchema,NO,NO,YES).  
    
JBoxServerAPI:Instance:Selector(BUFFER ttFlatFileFields:HANDLE,"FieldName,DataType,AddIndex").
IF JBoxServerAPI:Instance:SelectorOk THEN DO:
  ClearAll().
  httFlatFile:EMPTY-TEMP-TABLE () NO-ERROR.
  cFieldPropList = REPLACE(JBoxServerAPI:Instance:SelectorReturnValueList,"|",",").
  IF cFieldPropList = "" THEN 
    ASSIGN cFieldList = "*"
           cFieldCheck = "*".
  ELSE DO ix = 1 TO NUM-ENTRIES(cFieldPropList) BY 3:
    cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ENTRY(ix,cFieldPropList) + ";" + ENTRY(ix + 1,cFieldPropList).
    cFieldCheck = cFieldCheck + (IF cFieldCheck NE "" THEN "," ELSE "") + ENTRY(ix,cFieldPropList).
    IF ENTRY(ix + 2,cFieldPropList) = "yes" THEN
      cIndexFldList = cIndexFldList + (IF cIndexFldList NE "" THEN "," ELSE "") + ENTRY(ix,cFieldPropList).
  END.  

  EMPTY TEMP-TABLE ttFlatFileFields.

  SESSION:SET-WAIT-STATE("general").
  RUN getAll IN hCallFileParser (cFlatFileList,
                                 cFieldList,
                                 cIndexFldList,
                                 cFlatFileFilterFields,
                                 cFlatFileOperInUseList,
                                 cFlatFileFilterValList,
                                 cFlatFileTableName,
                                 iFlatFileImpMaxRows,
                                 500, // max sample rows
                                 cFlatFileCodePage,
                                 OUTPUT httFlatFile,
                                 OUTPUT httFlatFileSchema,
                                 OUTPUT cErrMsg).
  
  SESSION:SET-WAIT-STATE("").

  BUFFER ttFlatFileFields:COPY-TEMP-TABLE (httFlatFileSchema,NO,NO,YES).  

END.
ELSE RETURN.

ASSIGN ttCsvTable.hBuffer             = httFlatFile:DEFAULT-BUFFER-HANDLE
       ttCsvTable.TableName           = httFlatFile:DEFAULT-BUFFER-HANDLE:NAME
       ttCsvTable.hSchemaBuffer       = httFlatFileSchema:DEFAULT-BUFFER-HANDLE
       ttCsvTable.FieldList           = cFieldCheck
       ttCsvTable.IndexFldList        = cIndexFldList 
       ttCsvTable.FilterFields        = cFlatFileFilterFields
       ttCsvTable.FilterOperInUseList = cFlatFileOperInUseList
       ttCsvTable.FilterValueList     = cFlatFileFilterValList
       ttCsvTable.ImpMaxRows          = iFlatFileImpMaxRows
       hbttTables                     = BUFFER ttCsvTable:HANDLE
       hbttFields                     = oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(2)
       .

hbttFields:EMPTY-TEMP-TABLE () NO-ERROR.

oJBoxMsTreeView:clearNodes().

CREATE QUERY hqttFields.
hqttFields:SET-BUFFERS(httFlatFileSchema:DEFAULT-BUFFER-HANDLE).

CREATE QUERY hqttTables.
hqttTables:SET-BUFFERS (hbttTables).
hqttTables:QUERY-PREPARE("FOR EACH " + hbttTables:NAME).
hqttTables:QUERY-OPEN ().
REPEAT WHILE hqttTables:GET-NEXT ():
  oJBoxMsTreeView:AddNode(STRING(hbttTables::ParentSeq),STRING(hbttTables::Seq)
                         ,hbttTables::TableName
                         ,"Table",3,1).
  hqttFields:QUERY-PREPARE("FOR EACH " + httFlatFileSchema:DEFAULT-BUFFER-HANDLE:NAME).
  hqttFields:QUERY-OPEN ().
  REPEAT WHILE hqttFields:GET-NEXT().
    IF NOT httFlatFileSchema:DEFAULT-BUFFER-HANDLE::FieldName MATCHES "*JBox*Ident" AND CAN-DO(cFieldCheck,httFlatFileSchema:DEFAULT-BUFFER-HANDLE::FieldName) THEN DO:
      oJBoxMsTreeView:AddNode(STRING(hbttTables::Seq),
                              httFlatFileSchema:DEFAULT-BUFFER-HANDLE::FieldName,
                              httFlatFileSchema:DEFAULT-BUFFER-HANDLE::FieldName
                              + " " + SUBSTR(httFlatFileSchema:DEFAULT-BUFFER-HANDLE::DataType,1,4)
                              + " " + httFlatFileSchema:DEFAULT-BUFFER-HANDLE::FormatString,"Field",4,-1)
                              .

      hbttFields:BUFFER-CREATE().
      hbttFields:BUFFER-COPY(httFlatFileSchema:DEFAULT-BUFFER-HANDLE).
    END.                                 
  END.
END.  

httFlatFileSchema:DEFAULT-BUFFER-HANDLE:FIND-FIRST("") NO-ERROR.
IF httFlatFileSchema:DEFAULT-BUFFER-HANDLE:AVAIL THEN DO:
  oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(1):BUFFER-CREATE().
  oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(1):BUFFER-COPY(httFlatFileSchema:DEFAULT-BUFFER-HANDLE).
END.  

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "Table" /* The menu is added to nodes of type "Produkt" */
                                    ).

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseTable", /* Procedure to call when menu item is selected */  
                                   "Browse table content", /* Text */
                                   "ico\bullet_ball_yellow.ico"). 
       
oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseTableInSeparateWin", /* Procedure to call when menu item is selected */  
                                   "Browse table in separate window", /* Text */
                                   "ico\bullet_triangle_yellow.ico"). 

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseFields", /* Procedure to call when menu item is selected */  
                                   "Browse fields", /* Text */
                                   "ico\bullet_ball_green.ico"). 
     
oJBoxMsTreeView:ExpandNodes("").

otbJson:disabledTools = "ablcode,api,createView,saveschematofile,setparserlogfile,usefieldastable,viewSchema,viewParserLogFile,viewResultDs,viewSchema".
otbJson:setTools().
       
FINALLY:
  cFlatFileList = "".
  DELETE OBJECT hqttFields NO-ERROR.
  DELETE OBJECT hqttTables NO-ERROR.
END.  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LoadSchemaFromFileRecord C-Win 
PROCEDURE LoadSchemaFromFileRecord :
DEF VAR cFileName AS CHAR     NO-UNDO.
DEF VAR bOk       AS LOG      NO-UNDO.
DEF VAR lcFile    AS LONGCHAR NO-UNDO.
DEF VAR hTabProc  AS HANDLE   NO-UNDO.
DEF VAR hProgBar  AS HANDLE   NO-UNDO.

FIX-CODEPAGE(lcFile) = "UTF-8".

SYSTEM-DIALOG GET-FILE cFileName
              FILTERS "Json files" "*.json", "Text files" "*.txt" 
              INITIAL-FILTER 1 
              INITIAL-DIR "c:\temp"
              UPDATE bOk.
IF bOk THEN DO WITH FRAME {&FRAME-NAME}:
  COPY-LOB FROM FILE cFileName TO lcFile.
  IF oJBoxParser:LoadSchema(lcFile) THEN
    ViewSchema().
  ELSE MESSAGE oJBoxParser:statusMessage VIEW-AS ALERT-BOX.  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE myDatabrowseObject C-Win 
PROCEDURE myDatabrowseObject :
DEF INPUT PARAM ioDatabrowse AS JBoxDynDataBrowse NO-UNDO.

DEF VAR hBuffer AS HANDLE NO-UNDO.
DEF VAR hTt     AS HANDLE NO-UNDO.
DEF VAR ix      AS INT    NO-UNDO.
DEF VAR bCached AS LOG    NO-UNDO.

IF AVAIL ttView AND cSepWinType = "view" THEN DO:
  ioDatabrowse:InitializeQuery(ttView.hViewTable).
  CREATE ttTableViewWindow.
  ASSIGN ttTableViewWindow.TableOrViewId  = ttView.ViewId
         ttTableViewWindow.oDataBrowseObj = CAST(ioDatabrowse,"Progress.Lang.Object")
         ttTableViewWindow.hDataBrw       = ioDatabrowse:DataBrwProc
         .
END.  
ELSE IF hbttTables:AVAIL AND cSepWinType = "table" THEN DO:
  PUBLISH "getIsCachedTempTable" (hbttTables::hBuffer:TABLE-HANDLE,OUTPUT bCached).
  IF bCached THEN
    ioDatabrowse:InitializeQuery(hbttTables::hBuffer:TABLE-HANDLE).
  ELSE DO:
    hBuffer = hbttTables::hBuffer. 
    CREATE TEMP-TABLE hTt.
    DO ix = 1 TO hBuffer:NUM-FIELDS:
      IF NOT hBuffer:BUFFER-FIELD(ix):NAME MATCHES "JBox*Ident" THEN
        hTt:ADD-LIKE-FIELD (hBuffer:BUFFER-FIELD(ix):NAME,hBuffer:BUFFER-FIELD(ix)).
    END.
    hTt:ADD-NEW-FIELD("RowCount","integer").    
    hTt:ADD-NEW-FIELD("jbCountDistinct","integer",0,">>>,>>>,>>9").    
    hTt:ADD-NEW-FIELD("jbAverage","decimal",0,"->>>,>>>,>>9.99").    
    
    hTt:TEMP-TABLE-PREPARE(hbttTables::hBuffer:NAME).
    hTt:COPY-TEMP-TABLE (hBuffer,NO,NO,YES). 
    ioDatabrowse:InitializeQuery(hTt).
  END.
    
  CREATE ttTableViewWindow.
  ASSIGN ttTableViewWindow.TableOrViewId  = STRING(hbttTables::Seq)
         ttTableViewWindow.oDataBrowseObj = CAST(ioDatabrowse,"Progress.Lang.Object")
         ttTableViewWindow.hDataBrw       = ioDatabrowse:DataBrwProc
         .
END.
ELSE MESSAGE "Failed to open separate window for" cSepWinType
     VIEW-AS ALERT-BOX.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE mySelectorObject C-Win 
PROCEDURE mySelectorObject :
DEF INPUT PARAM ioSelector AS JBoxDynSelector NO-UNDO.

DEF VAR ix                      AS INT NO-UNDO.
DEF VAR cSelectedRows           AS CHAR NO-UNDO.
DEF VAR oSrcDataTypeDropDown    AS JBoxBrowseDropDown NO-UNDO.
DEF VAR oSrcIndexDropDown       AS JBoxBrowseDropDown NO-UNDO.
DEF VAR oTargetDataTypeDropDown AS JBoxBrowseDropDown NO-UNDO.
DEF VAR oTargetIndexDropDown    AS JBoxBrowseDropDown NO-UNDO.

IF cFlatFileList NE "" THEN DO:
  ioSelector:LoadPanel("JBoxFlatFilePreviewPanel.w").
  hSelectorPanel = ioSelector:SELECTOR-PANEL-HANDLE.
  ioSelector:ExpandSelectorDialogX(300).
  RUN createBrowse IN hSelectorPanel (httFlatFile).
  FOR EACH ttFlatFileFields:
    ioSelector:SOURCE-BROWSE-OBJECT:BUFFER-HANDLE:BUFFER-CREATE().
    ioSelector:SOURCE-BROWSE-OBJECT:BUFFER-HANDLE:BUFFER-COPY(BUFFER ttFlatFileFields:HANDLE).
  END.  
//  oSrcDataTypeDropDown    = NEW JBoxBrowseDropDown(ioSelector:SOURCE-BROWSE-OBJECT,"datatype","CHARACTER|CHARACTER|DATE|DATE|DATETIME|DATETIME|DATETIME-TZ|DATETIME-TZ|DECIMAL|DECIMAL|INTEGER|INTEGER|INT64|INT64|LOGICAL|LOGICAL",YES).
  oTargetDataTypeDropDown = NEW JBoxBrowseDropDown(ioSelector:TARGET-BROWSE-OBJECT,"datatype","CHARACTER|CHARACTER|DATE|DATE|DATETIME|DATETIME|DATETIME-TZ|DATETIME-TZ|DECIMAL|DECIMAL|INTEGER|INTEGER|INT64|INT64|LOGICAL|LOGICAL",YES).
//  oSrcDataTypeDropDown    = NEW JBoxBrowseDropDown(ioSelector:SOURCE-BROWSE-OBJECT,"AddIndex","Yes|Yes|No|No",YES).
  oTargetDataTypeDropDown = NEW JBoxBrowseDropDown(ioSelector:TARGET-BROWSE-OBJECT,"AddIndex","Yes|Yes|No|No",YES).
  ioSelector:OpenQuerySource().
  RETURN.
END.  
      
//ioSelector:TOOLBAR-OBJECT:addTool("Filter").
ioSelector:ExpandSelectorDialogX(200).
FOR EACH ttSelectFields:
  ioSelector:SOURCE-BROWSE-OBJECT:BUFFER-HANDLE:BUFFER-CREATE().
  ioSelector:SOURCE-BROWSE-OBJECT:BUFFER-HANDLE:BUFFER-COPY(BUFFER ttSelectFields:HANDLE).
  ix = ix + 1.
  ioSelector:SOURCE-BROWSE-OBJECT:BUFFER-HANDLE::RowIdent1 = "rowid" + STRING(ix).
  IF ttSelectFields.ixSelected > 0 THEN DO:
    ioSelector:TARGET-BROWSE-OBJECT:BUFFER-HANDLE:BUFFER-CREATE().
    ioSelector:TARGET-BROWSE-OBJECT:BUFFER-HANDLE:BUFFER-COPY(BUFFER ttSelectFields:HANDLE).
    ioSelector:TARGET-BROWSE-OBJECT:BUFFER-HANDLE::RowIdent1 = "rowid" + STRING(ix).
    ioSelector:TARGET-BROWSE-OBJECT:BUFFER-HANDLE::iJBoxSelectIndex = ttSelectFields.ixSelected. 
    cSelectedRows = cSelectedRows + "rowid" + STRING(ix) + ",".
  END.  
END.  
ioSelector:setSelectedRowidList(TRIM(cSelectedRows,",")).
IF cSelectedRows = "" THEN
  ioSelector:SOURCE-BROWSE-OBJECT:baseQuery = "where true".

IF ix > 18 AND cSelectedRows NE "" THEN
  ioSelector:ExpandSelectorDialogY(MIN(45,ix - 18) * 10).
  
ioSelector:SOURCE-BROWSE-OBJECT:setQuerySort("FieldName").   
ioSelector:TARGET-BROWSE-OBJECT:setQuerySort("iJBoxSelectIndex").   
ioSelector:OpenQuerySource().
ioSelector:OpenQueryTarget().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewEndpointParam C-Win 
PROCEDURE NewEndpointParam :
IF AVAIL ttEndpoint THEN DO WITH FRAME {&FRAME-NAME}:
    JBoxSession:Instance:SimpleSelectList("Header|Query").
    IF JBoxSession:Instance:SelectListOk THEN DO:
      IF JBoxSession:Instance:SelectListValue = "Header" THEN 
        RUN AddEndpointHeaderParamRecord.
      ELSE 
        RUN AddEndpointQueryParamRecord.
      oPageBrowse:openQuery().
    END.
  END.
  ELSE RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewViewDsRecord C-Win 
PROCEDURE NewViewDsRecord :
DEF VAR hdsViewDs AS HANDLE NO-UNDO.
  
JBoxSession:Instance:PromptForValue("Name").
IF NOT JBoxSession:Instance:PromptValueOk THEN RETURN.  
  
CREATE ttViewDsProc.
ASSIGN ttViewDsProc.cViewName = JBoxSession:Instance:PromptValue
       ttViewDsProc.hOwner    = THIS-PROCEDURE.  

ttViewDsProc.hViewDef = oContainer:StartChildTab("JBoxViewDsDefTable.w",ttViewDsProc.cViewName, NO, NO).

//RUN CreateViewDs IN ttViewDsProc.hViewDef("tempdata","tt","temp-table","",ttViewDsProc.cViewName,INPUT-OUTPUT ttViewDsProc.ViewDsId).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PasteJsonRecord C-Win 
PROCEDURE PasteJsonRecord :
DEF VAR bOk AS LOG NO-UNDO.
DEF VAR lcFile AS LONGCHAR NO-UNDO.
DEF VAR hTabProc AS HANDLE NO-UNDO.

RUN JBoxDLargeEditor.w (INPUT-OUTPUT lcJson,NO,NO,NO,"Add Json or XML text",OUTPUT bOK).
IF bOk AND lcJson NE "" THEN DO WITH FRAME {&FRAME-NAME}:
  FOR EACH ttTableViewTab:
    hTabProc = oTabBrowse:getPageHandle(ttTableViewTab.TabPage#) NO-ERROR.
    IF VALID-HANDLE(hTabProc) THEN
      APPLY "close" TO hTabProc.
    DELETE ttTableViewTab.  
  END.    
  IF VALID-OBJECT(oTabBrowse) THEN DO:
    oTabBrowse:Dispose() NO-ERROR.
    DYNAMIC-FUNCTION("DeleteUserControlByPlaceholder",TabBrowse:HANDLE).
  END.
    
  EMPTY TEMP-TABLE ttView.

  FIX-CODEPAGE(lcFile) = "UTF-8".

  lcFile = TRIM(lcJson).

  IF lcFile BEGINS "<" THEN
    oJBoxParser:createXMLSchema(lcFile,cSchemaName).
  ELSE DO:
    cSchemaName = "ttJsonHeader".
    oJBoxParser:fieldsUsedAsTableName = cFieldsUsedAsTableList.
    oJBoxParser:createSchema(lcFile,cSchemaName).
  END.  
  
  IF oJBoxParser:statusMessage = "" THEN DO:
    THIS-PROCEDURE:CURRENT-WINDOW:TITLE = IF lcFile BEGINS "<" THEN "XML text" ELSE "Json text".
    
    ViewSchema(). 
    
  //  oJBoxParser:viewSchemaDS().
  //  oJBoxParser:viewResultDS().
  //  oJBoxParser:viewTtTables().
  END.
  ELSE 
    MESSAGE "Status message" oJBoxParser:statusMessage 
    VIEW-AS ALERT-BOX.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReadFileInChunks C-Win 
PROCEDURE ReadFileInChunks :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM icFileName AS CHAR NO-UNDO.
DEF OUTPUT PARAM lcVariable AS LONGCHAR    NO-UNDO.

DEFINE VARIABLE mpVariable AS MEMPTR      NO-UNDO.
DEFINE VARIABLE lcTempoary AS LONGCHAR    NO-UNDO.


DEFINE VARIABLE iFileSize  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iRemaining AS INTEGER     NO-UNDO.
DEFINE VARIABLE iChunkSize AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMptrSize  AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoopCount AS INTEGER     NO-UNDO.

FIX-CODEPAGE(lcVariable) = "UTF-8".
FIX-CODEPAGE(lcTempoary) = "UTF-8".

ASSIGN
    FILE-INFO:FILE-NAME = icFileName
    iFileSize           = FILE-INFO:FILE-SIZE /* Actual file size 501 MB (526,112,370 bytes) */
    iChunkSize          = MIN(25 * 1024 * 1024, iFileSize)

    /*
    Curiously, setting the chunk size to 100MB on windows XP with 4GB RAM causes the statement
    lcVariable = lcVariable + lcTempoary.
    to generate the error:
    
    "Could not allocate memory to perform concatenate operation (15633)
    The operating system does not have sufficient free memory left to satisfy the memory allocation request the AVM is making."
    */ 
    
    iMptrSize         = iChunkSize
    SET-SIZE(mpVariable)     = iMptrSize
    iLoopCount = 0.

iRemaining = iFileSize.
REPEAT WHILE iRemaining > iChunkSize:
    COPY-LOB FROM FILE icFileName STARTING AT iLoopCount * iMptrSize + 1 FOR  iMptrSize TO mpVariable.
    COPY-LOB FROM mpVariable STARTING AT 1 FOR iMptrSize TO lcTempoary. // CONVERT SOURCE CODEPAGE SESSION:CPINTERNAL TARGET CODEPAGE "UTF-8".
    ASSIGN
        iLoopCount = iLoopCount + 1
        iRemaining = iRemaining - iMptrSize
        lcVariable = lcVariable + lcTempoary
        iMptrSize = MIN(iChunkSize, iRemaining)
        SET-SIZE(mpVariable) = 0.
    SET-SIZE(mpVariable) = iMptrSize.
END.

ASSIGN
    iLoopCount = IF iLoopCount > 0 THEN iLoopCount - 1 ELSE iLoopCount
    iMptrSize = iRemaining
    SET-SIZE(mpVariable) = iMptrSize.
 
COPY-LOB FROM FILE icFileName STARTING AT iLoopCount * iMptrSize + 1 FOR  iMptrSize TO mpVariable. // CONVERT TARGET CODEPAGE SESSION:CPINTERNAL.
COPY-LOB FROM mpVariable STARTING AT 1 FOR GET-SIZE(mpVariable) TO lcTempoary NO-ERROR. // CONVERT SOURCE CODEPAGE SESSION:CPINTERNAL TARGET CODEPAGE "UTF-8".
IF ERROR-STATUS:ERROR THEN 
  COPY-LOB FROM FILE icFileName TO lcVariable.
ELSE
  lcVariable = lcVariable + lcTempoary.

SET-SIZE(mpVariable) = 0.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveEndpointAsRecord C-Win 
PROCEDURE saveEndpointAsRecord :
bSaveEndpointAS = YES.
RUN SaveEndpointRecord.
bSaveEndpointAS = NO.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveEndpointRecord C-Win 
PROCEDURE SaveEndpointRecord :
DEF VAR cFile            AS CHAR NO-UNDO.
  DEF VAR hDsEndpoint      AS HANDLE NO-UNDO.
  DEF VAR httEndpoint      AS HANDLE NO-UNDO.
  DEF VAR httEndpointParam AS HANDLE NO-UNDO.
  DEF VAR httView          AS HANDLE NO-UNDO.
  DEF VAR httViewTables    AS HANDLE NO-UNDO.
  DEF VAR httViewFields    AS HANDLE NO-UNDO.
  DEF VAR hbttEndpoint     AS HANDLE NO-UNDO.

  IF AVAIL ttEndpoint THEN
    cFile = ttEndpoint.EndpointName.
  ELSE
    cFile = cEndpointFile.
  
  SYSTEM-DIALOG GET-FILE cFile 
                USE-FILENAME 
                FILTERS "Json files" "*.json", "All files" "*,*"
                UPDATE bOK.
  IF NOT bOk THEN RETURN.
  IF NOT cFile MATCHES "*.json" THEN cFile = cFile + ".json".
  IF SEARCH(cFile) NE ? 
     AND NOT JBoxSession:Instance:ViewQuestionOkCancel("Replace " + cFile) THEN RETURN.
  cEndpointFile = cFile.
  
  FIND FIRST ttEndpoint NO-ERROR.
  IF NOT AVAIL ttEndpoint THEN DO:
    CREATE ttEndpoint.
    ttEndpoint.EndpointUrl = cApiUrl.
  END.    
  ttEndpoint.EndpointName = ENTRY(1,ENTRY(NUM-ENTRIES(cFile,"\/"),cFile,"\/"),".").
    
  IF bSaveEndpointAS THEN ENTRY(NUM-ENTRIES(ttEndpoint.EndpointUrl,"/"),ttEndpoint.EndpointUrl,"/") = ttEndpoint.EndpointName.
   
  FOR EACH ttEndpointParam: ttEndpointParam.EndpointName = ttEndpoint.EndpointName. END.
    
  CREATE DATASET hDsEndpoint.
  hDsEndpoint:CREATE-LIKE(oJBoxParser:hdsSchema).
  
  CREATE TEMP-TABLE httEndpoint.
  httEndpoint:CREATE-LIKE (BUFFER ttEndpoint:HANDLE).
  httEndpoint:TEMP-TABLE-PREPARE ("ttEndpoint").
  httEndpoint:COPY-TEMP-TABLE (BUFFER ttEndpoint:HANDLE).
  hDsEndpoint:ADD-BUFFER (httEndpoint:DEFAULT-BUFFER-HANDLE).
  
  CREATE TEMP-TABLE httEndpointParam.
  httEndpointParam:CREATE-LIKE (BUFFER ttEndpointParam:HANDLE).
  httEndpointParam:TEMP-TABLE-PREPARE ("ttEndpointParam").
  httEndpointParam:COPY-TEMP-TABLE (BUFFER ttEndpointParam:HANDLE).
  hDsEndpoint:ADD-BUFFER (httEndpointParam:DEFAULT-BUFFER-HANDLE).
  
  IF NOT bSaveEndpointAS THEN DO:
    CREATE TEMP-TABLE httView.
    httView:CREATE-LIKE (BUFFER ttView:HANDLE).
    httView:TEMP-TABLE-PREPARE ("ttView").
    httView:COPY-TEMP-TABLE (BUFFER ttView:HANDLE).
    hDsEndpoint:ADD-BUFFER (httView:DEFAULT-BUFFER-HANDLE).
  
    CREATE TEMP-TABLE httViewTables.
    httViewTables:CREATE-LIKE (BUFFER ttViewTables:HANDLE).
    httViewTables:TEMP-TABLE-PREPARE ("ttViewTables").
    httViewTables:COPY-TEMP-TABLE (BUFFER ttViewTables:HANDLE).
    hDsEndpoint:ADD-BUFFER (httViewTables:DEFAULT-BUFFER-HANDLE).
  
    CREATE TEMP-TABLE httViewFields.
    httViewFields:CREATE-LIKE (BUFFER ttViewFields:HANDLE).
    httViewFields:TEMP-TABLE-PREPARE ("ttViewFields").
    httViewFields:COPY-TEMP-TABLE (BUFFER ttViewFields:HANDLE).
    hDsEndpoint:ADD-BUFFER (httViewFields:DEFAULT-BUFFER-HANDLE).

    hDsEndpoint:COPY-DATASET (oJBoxParser:hdsSchema,NO,NO,YES).
  END.  
  
  hDsEndpoint:WRITE-JSON("file",cEndpointFile,YES).

  DELETE OBJECT hDsEndpoint.
  
  IF bSaveEndpointAS AND LoadEndpoint(cEndpointFile) THEN DO:
    ViewSchema().
    
    FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewName = "APIparameters"
         NO-ERROR.
    IF AVAIL ttTableViewTab THEN DO:
      oTabBrowse:movePageToTop(ttTableViewTab.TabPage#).         
      oTabBrowse:tabControl1:SelectTab(ttTableViewTab.TableOrViewName).
    END.  
    ELSE DO:
      hbttEndpoint = BUFFER ttEndpointParam:HANDLE.
      cCurrentTable = "|APIparameters".
      StartTab(hbttEndpoint,cCurrentTable).
    END.  
  END.
  oContainer:statusBar:StatusText2 = cEndpointFile. 
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveSchemaToFileRecord C-Win 
PROCEDURE SaveSchemaToFileRecord :
DEF VAR cFileName AS CHAR     NO-UNDO.
DEF VAR bOk       AS LOG      NO-UNDO.

IF NOT VALID-HANDLE(oJBoxParser:hdsSchema) THEN DO:
  MESSAGE "Schema not created" VIEW-AS ALERT-BOX.
  RETURN.
END.

SYSTEM-DIALOG GET-FILE cFileName
              FILTERS "Schema files" "*.json" 
              UPDATE bOk.
IF bOk THEN DO WITH FRAME {&FRAME-NAME}:
  IF SEARCH(cFileName) NE ? THEN 
    MESSAGE "Replace file " cFileName
            VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO UPDATE bOk.
  IF bOk THEN
    oJBoxParser:hdsSchema:WRITE-JSON("file",cFileName,YES).          
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SelectTableViewFields C-Win 
PROCEDURE SelectTableViewFields :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icNode AS CHAR NO-UNDO.

DEF VAR cFieldList AS CHAR NO-UNDO.
DEF VAR ix         AS INT NO-UNDO.
DEF VAR hTabProc   AS HANDLE NO-UNDO.

FIND FIRST ttView
     WHERE ttView.ViewId = ENTRY(1,icNode,CHR(1))
     NO-ERROR.

FIND FIRST ttViewTables
     WHERE ttViewTables.ViewId = ENTRY(1,icNode,CHR(1))
       AND ttViewTables.ViewTableId = ENTRY(2,icNode,CHR(1))
     NO-ERROR.

IF AVAIL ttViewTables THEN DO:
  getTableFieldList(SUBSTR(ttViewTables.ViewTableId,4),ttViewTables.FieldList).
  JBoxServerAPI:Instance:Selector(BUFFER ttSelectFields:HANDLE,"FieldName").
  IF JBoxServerAPI:Instance:SelectorOk THEN DO:
    ttViewTables.FieldList = REPLACE(JBoxServerAPI:Instance:SelectorReturnValueList,"|",",").
    FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewId = ttView.ViewId
         NO-ERROR.
    ReCreateView(ttView.ViewId).
    IF tbViewFields:CHECKED IN FRAME {&FRAME-NAME} THEN
      ViewSchema().
      
    IF AVAIL ttTableViewTab THEN DO:
      oTabBrowse:removePage(ttTableViewTab.TabPage#).
      renumTabs(ttTableViewTab.TabPage#).
      DELETE ttTableViewTab.      
      RUN BrowseView(ttView.ViewId).  
    END.  
  END.
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setParserLogfileRecord C-Win 
PROCEDURE setParserLogfileRecord :
DEF VAR cFileName AS CHAR     NO-UNDO.
DEF VAR bOk       AS LOG      NO-UNDO.

cFileName = oJBoxParser:logFile. 

SYSTEM-DIALOG GET-FILE cFileName
              FILTERS "Log files" "*.log", "Text files" "*.txt" 
              INITIAL-FILTER 1 
              INITIAL-DIR "c:\temp"
              UPDATE bOk.
IF bOk THEN 
  oJBoxParser:logFile = cFileName.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setSelectorTarget C-Win 
PROCEDURE setSelectorTarget :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihBrwTarget    AS HANDLE NO-UNDO.
DEF INPUT PARAM ibSelect       AS HANDLE NO-UNDO.
DEF INPUT PARAM icCurrmax      AS CHAR NO-UNDO.
DEF INPUT PARAM icSelRowidlist AS CHAR.

DEF VAR cSelectedFieldsList AS CHAR NO-UNDO.
DEF VAR hQSelected AS HANDLE NO-UNDO.

CREATE QUERY hQSelected.
hQSelected:SET-BUFFERS(ihBrwTarget:QUERY:GET-BUFFER-HANDLE (1)).
hQSelected:QUERY-PREPARE ("FOR EACH " + ihBrwTarget:QUERY:GET-BUFFER-HANDLE (1):NAME).
hQSelected:QUERY-OPEN ().

REPEAT WHILE hQSelected:GET-NEXT:
  cSelectedFieldsList = cSelectedFieldsList + (IF cSelectedFieldsList NE "" THEN "," ELSE "") + hQSelected:GET-BUFFER-HANDLE (1)::FieldName.
END.  

RUN selectFields IN hSelectorPanel (cSelectedFieldsList).

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

DEF VAR lcFile        AS LONGCHAR NO-UNDO.
DEF VAR ix            AS INT      NO-UNDO.
DEF VAR cFileList     AS CHAR     NO-UNDO.
DEF VAR cErrMsg       AS CHAR     NO-UNDO.
DEF VAR cTmpFileName  AS CHAR     NO-UNDO.
DEF VAR cConvFile     AS CHAR     NO-UNDO.

cTmpFileName = ENTRY(1,icDropFiles,"|").

IF PROGRESS GE "12.8" AND (cTmpFileName MATCHES "*.csv*" OR cTmpFileName MATCHES "*.xls*" OR cTmpFileName MATCHES "*.txt*") THEN DO:
  ASSIGN tbViewFields:CHECKED IN FRAME {&FRAME-NAME} = YES
         tbViewFields:SENSITIVE = NO.
             
  IF cTmpFileName MATCHES "*.xls*" THEN
    cConvFile = DYNAMIC-FUNCTION("ConvXlsToCsv",cTmpFileName).
  ELSE cConvFile = cTmpFileName.  
    
  cFlatFileList = cConvFile.
  
  DO ix = 2 TO NUM-ENTRIES(icDropFiles,"|"):  
    cTmpFileName = ENTRY(ix,icDropFiles,"|").
    
    IF cTmpFileName MATCHES "*.csv*" OR cTmpFileName MATCHES "*.xls*" THEN DO:
      IF cTmpFileName MATCHES "*.xls*" THEN
        cConvFile = DYNAMIC-FUNCTION("ConvXlsToCsv",cTmpFileName).
      ELSE cConvFile = cTmpFileName.  
      cFlatFileList = cFlatFileList + "," + cConvFile.   
    END.  
  END.
  JBoxSession:Instance:setDelayedRun("loadFlatFileList",THIS-PROCEDURE).
END.
ELSE DO:
  tbViewFields:SENSITIVE = YES.
  
  FIX-CODEPAGE(lcFile) = "utf-8".
  
  LoadFile(ENTRY(1,icDropFiles,"|")).
  cFileList = ENTRY(1,icDropFiles,"|").
  
  DO ix = 2 TO NUM-ENTRIES(icDropFiles,"|"):  
    COPY-LOB FROM FILE ENTRY(ix,icDropFiles,"|") TO lcFile.
    IF ENTRY(ix,icDropFiles,"|") MATCHES("*.xml*") THEN
      oJboxParser:appendXMLData(CheckXML(lcFile,ENTRY(ix,icDropFiles,"|"))).
    ELSE  
      oJboxParser:appendData(lcFile).
    IF LENGTH(cFileList) < 1000 THEN  
      cFileList = cFileList + "," + ENTRY(ix,icDropFiles,"|").   
  END.
END.  
oContainer:statusBar:StatusText2 = cFileList.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeDropFilesTT C-Win 
PROCEDURE TreeDropFilesTT :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihFilesBuffer AS HANDLE NO-UNDO.
DEF INPUT PARAM icDropNode    AS CHAR NO-UNDO.

DEF VAR lcFile        AS LONGCHAR NO-UNDO.
DEF VAR ix            AS INT      NO-UNDO.
DEF VAR cFileList     AS CHAR     NO-UNDO.
DEF VAR cErrMsg       AS CHAR     NO-UNDO.
DEF VAR cTmpFileName  AS CHAR     NO-UNDO.
DEF VAR cConvFile     AS CHAR     NO-UNDO.
DEF VAR bFlatFiles    AS LOG      NO-UNDO.
DEF VAR iFileCnt      AS INT      NO-UNDO.

EMPTY TEMP-TABLE ttFiles.

cFlatFileList = "".
FIX-CODEPAGE(lcFile) = "utf-8".

ClearAll().

BUFFER ttFiles:TABLE-HANDLE:COPY-TEMP-TABLE (ihFilesBuffer).

FOR EACH ttFiles: iFileCnt = iFileCnt + 1. END.

SESSION:SET-WAIT-STATE ("general").
FOR EACH ttFiles:
  ASSIGN ix = ix + 1.
         cTmpFileName = ttFiles.FileName.
  IF ix = 1 AND PROGRESS GE "12.8" AND 
     (cTmpFileName MATCHES "*.csv" OR cTmpFileName MATCHES "*.xls"  OR cTmpFileName MATCHES "*.xlsx" OR cTmpFileName MATCHES "*.txt") THEN DO:
    IF iFileCnt > 100 THEN DO:
      MESSAGE "Max file count (100) exceeded"
      VIEW-AS ALERT-BOX.
      RETURN.
    END.    
    ASSIGN tbViewFields:CHECKED IN FRAME {&FRAME-NAME} = YES
           tbViewFields:SENSITIVE = NO
           bFlatFiles = YES.
  END.         
  ELSE IF ix = 1 THEN
    tbViewFields:SENSITIVE = YES.
             
             
  IF cTmpFileName MATCHES "*.xls*" THEN
    cConvFile = DYNAMIC-FUNCTION("ConvXlsToCsv",cTmpFileName).
  ELSE cConvFile = cTmpFileName.  
  
  IF bFlatFiles THEN 
    cFlatFileList = cFlatFileList + (IF cFlatFileList NE "" THEN "," ELSE "") + cConvFile.
  ELSE DO:  
    IF ix = 1 THEN DO:
      LoadFile(ttFiles.FileName).
      cFileList = ttFiles.FileName.
    END.
    ELSE DO:
      COPY-LOB FROM FILE ttFiles.FileName TO lcFile.
      IF ttFiles.FileName MATCHES("*.xml*") THEN
        oJboxParser:appendXMLData(CheckXML(lcFile,ttFiles.FileName)).
      ELSE  
        oJboxParser:appendData(lcFile).
    END.    
  END.
  IF NOT CAN-DO(cFileList,ttFiles.FileName) AND LENGTH(cFileList) < 1000 THEN  
    cFileList = cFileList + (IF cFileList NE "" THEN "," ELSE "") + ttFiles.FileName.   
END.
IF cFlatFileList NE "" THEN
  JBoxSession:Instance:setDelayedRun("loadFlatFileList",THIS-PROCEDURE).

oContainer:statusBar:StatusText2 = cFileList.

FINALLY:
  SESSION:SET-WAIT-STATE("").      
END FINALLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE TreeDropNode C-Win 
PROCEDURE TreeDropNode :
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
DEF VAR cJoinType       AS CHAR NO-UNDO.
DEF VAR cTableFields    AS CHAR NO-UNDO.
DEF VAR cPrimaryIdx     AS CHAR NO-UNDO.

DEF BUFFER bttViewTables FOR ttViewTables.
DEF BUFFER ttView        FOR ttView.

DEF VAR hqFields AS HANDLE NO-UNDO.

icDragId = ENTRY(1,icDragId,CHR(1)).

IF NUM-ENTRIES(icDropId,CHR(1)) = 1 THEN DO:

  FIND FIRST ttView 
         where ttView.ViewId = icDropId
       NO-ERROR.
  
  IF AVAIL ttView THEN DO:
    IF CAN-FIND(FIRST ttViewTables WHERE ttViewTables.ViewId = icDropId) THEN DO:
      MESSAGE "Invalid drop-node. View has already got a view-table. Valid drag-drop options for this view is to drag a child-table of a view-table on to the view-table"
              VIEW-AS ALERT-BOX.     
      RETURN.
    END.
    hbttTables:FIND-FIRST("WHERE Seq = " + icDragId) NO-ERROR.
    IF hbttTables:AVAIL THEN DO:
      cTableFields = getTableFieldList(hbttTables::TableName,""). // also populates the temp-table used to build field selection
      IF NUM-ENTRIES(cTableFields,"|") > 2 THEN DO: 
        IF NOT JBoxSession:Instance:ViewQuestionYesNo("View all fields?") THEN DO:
          JBoxServerAPI:Instance:SelectorDialog(BUFFER ttSelectFields:HANDLE,"fieldName").
          IF JBoxServerAPI:Instance:SelectorOk THEN
            cTableFields = JBoxServerAPI:Instance:SelectorReturnValueList.
          ELSE RETURN.
        END.
      END.
      ELSE cTableFields = "".    
      FIND LAST bttViewTables 
           WHERE bttViewTables.ViewId = ttView.ViewId
           NO-ERROR.
      CREATE ttViewTables.
      ASSIGN ttViewTables.ViewId              = ttView.ViewId
             ttViewTables.ViewTableId         = "vt_" + hbttTables::TableName
             ttViewTables.ParentViewTableId   = ttView.ViewId
             ttViewTables.TableName           = hbttTables::TableName
             ttViewTables.ViewTableLevel      = hbttTables::Level
             ttViewTables.SourceBuffer        = hbttTables::hBuffer
             ttViewTables.ParentTableName     = hbttTables::ParentTableName
             ttViewTables.ViewTableSeq        = IF AVAIL bttViewTables THEN bttViewTables.ViewTableSeq + 1 ELSE 1
             ttViewTables.FieldList           = REPLACE(cTableFields,"|",",")
             .           
      ReCreateView(ttView.ViewId).       
      ViewSchema().
    END.  
  END.
END.  
ELSE DO:
  FIND FIRST ttViewTables
       WHERE ttViewTables.ViewId      = ENTRY(1,icDropId,CHR(1))
         AND ttViewTables.ViewTableId = ENTRY(2,icDropId,CHR(1))
       NO-ERROR.
       
  IF NOT AVAIL ttViewTables THEN DO:
    MESSAGE "Invalid drop-node. Drop on view or view-table"
            VIEW-AS ALERT-BOX.     
    RETURN.
  END.
  FIND FIRST ttView
       WHERE ttView.ViewId = ttViewTables.ViewId.
       
  hbttTables:FIND-FIRST("WHERE Seq = " + icDragId) NO-ERROR.
    
  IF hbttTables:AVAIL AND (hbttTables::ParentTableName = ttViewTables.TableName OR hbttTables::ParentJsonTableName = ttViewTables.TableName) THEN DO:
    JBoxSession:Instance:PromptForValues("Select join-type", "Join type|CHARACTER|X(15)|EACH|FIRST|FIRST|EACH|EACH|EACH OUTER-JOIN|EACH OUTER-JOIN|LAST|LAST").
    IF NOT JBoxSession:Instance:PromptValueOk THEN RETURN.
    cJoinType = JBoxSession:Instance:PromptValue.
    cTableFields = getTableFieldList(hbttTables::TableName,"").
    IF CAN-DO("FIRST,LAST",cJoinType) THEN DO:
      IF NUM-ENTRIES(cTableFields,"|") > 2 THEN DO:
        JBoxSession:Instance:PromptForValues(cJoinType + " according to","Field name|CHARACTER|x(32)||" + cTableFields).
        IF NOT JBoxSession:Instance:PromptValueOk THEN RETURN.
        cPrimaryIdx = JBoxSession:Instance:PromptValue.
      END.
      ELSE cPrimaryIdx = ENTRY(1,cTableFields,"|").
      MESSAGE "Note: To determine the first or last record there should be a primary index for " cPrimaryIdx SKIP
              "The index will be added when generating the static schema but is not a part of the current dynamic schema definition"
              VIEW-AS ALERT-BOX WARNING. 
    END.  
 
    IF NUM-ENTRIES(cTableFields,"|") > 2 AND NOT JBoxSession:Instance:ViewQuestionYesNo("View all fields?") THEN DO:
      JBoxServerAPI:Instance:SelectorDialog(BUFFER ttSelectFields:HANDLE,"fieldName").
      IF JBoxServerAPI:Instance:SelectorOk THEN
        cTableFields = JBoxServerAPI:Instance:SelectorReturnValueList.
      ELSE RETURN.
    END.  
    FIND LAST bttViewTables
         WHERE bttViewTables.ViewId = ttView.ViewId
         NO-ERROR.
    CREATE ttViewTables.
    ASSIGN ttViewTables.ViewId              = ttView.ViewId
           ttViewTables.ViewTableId         = "vt_" + hbttTables::TableName
           ttViewTables.ParentViewTableId   = icDropId // "vt_" + hbttTables::ParentTableName
           ttViewTables.TableName           = hbttTables::TableName
           ttViewTables.ViewTableLevel      = hbttTables::Level
           ttViewTables.SourceBuffer        = hbttTables::hBuffer
           ttViewTables.ParentTableName     = hbttTables::ParentTableName
           ttViewTables.ViewTableSeq        = IF AVAIL bttViewTables THEN bttViewTables.ViewTableSeq + 1 ELSE 1
           ttViewTables.JoinType            = cJoinType
           ttViewTables.PrimaryIdx          = cPrimaryIdx
           ttViewTables.FieldList           = REPLACE(cTableFields,"|",",")
           .           
    ReCreateView(ttView.ViewId).       
    
    ViewSchema().
      
    FIND FIRST ttTableViewTab WHERE ttTableViewTab.TableOrViewId = ttView.ViewId
         NO-ERROR.
    IF AVAIL ttTableViewTab THEN DO:
      oTabBrowse:removePage(ttTableViewTab.TabPage#).
      renumTabs(ttTableViewTab.TabPage#).
      DELETE ttTableViewTab.
      RUN BrowseView(ttView.ViewId).  
    END.  
    
  END.  
  ELSE IF hbttTables:AVAIL THEN DO:
    MESSAGE "Invalid drop-node. Drop-target must be parent of drag-table"
            VIEW-AS ALERT-BOX.     
  END.
  ELSE DO:
    MESSAGE "Invalid drag-node. Only tables can be dragged"
            VIEW-AS ALERT-BOX.     
  END.  
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

DEF VAR cViewName    AS CHAR NO-UNDO.

IF oJBoxMsTreeView:isThisMyNode(ioSourceNode) THEN DO:

  hViewContainer  = ioTargetTree:CONTAINER-HANDLE.
  cViewName = DYNAMIC-FUNCTION("getViewDsName" IN hViewContainer).

  FIND FIRST ttCsvTable NO-ERROR.
  IF AVAIL ttCsvTable THEN
    hTtBuffer2View = ttCsvTable.hBuffer.
  ELSE DO:      
    hTtBuffer2View  = oJBoxParser:getResultBufferHandle(oJBoxMsTreeView:getNodeText(ioSourceNode:Name)).
    JBoxSchemaCache:Instance:addTempTableToSchema(?,hTtBuffer2View,"tempdata", "temp-table",YES,"").
  END.  
  
  // Didn't drop on a valid node so we re-initiate the view
  IF NOT VALID-OBJECT(ioTargetNode) THEN DO:

    // The view was initiated elsewhere (dbviewer..)
    IF NOT AVAIL ttViewDsProc THEN DO:
      IF NOT CAN-DO(ioTargetTree:CONTAINER-HANDLE:INTERNAL-ENTRIES,"getViewDsId") THEN RETURN.
      CREATE ttViewDsProc.
      ASSIGN ttViewDsProc.hViewDef  = ioTargetTree:CONTAINER-HANDLE
             ttViewDsProc.cViewName = cViewName
             .
    END.  

    // (Re-)create the view
    RUN CreateViewDs IN ioTargetTree:CONTAINER-HANDLE ("tempdata","tt","temp-table",
                                                       oJBoxMsTreeView:getNodeText(ioSourceNode:Name),
                                                       cViewName,
                                                       INPUT-OUTPUT ttViewDsProc.ViewDsId).

  END.
  ELSE IF ioTargetTree:isThisMyNode(ioTargetNode) THEN
    cViewTargetNode = ioTargetTree:getNodeText(ioTargetNode:Name).
           
  JBoxSession:Instance:setDelayedRun("addTableToView",THIS-PROCEDURE).
END.    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE UseFieldAsTableRecord C-Win 
PROCEDURE UseFieldAsTableRecord :
JBoxSession:Instance:PromptForValue("Comma-sep list of fields used as tables (used when array contains different object types)",
                                    "CHARACTER","x(100)",cFieldsUsedAsTableList).
IF JBoxSession:Instance:PromptValueOk THEN
  cFieldsUsedAsTableList = JBoxSession:Instance:PromptValue.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewParserLogFileRecord C-Win 
PROCEDURE viewParserLogFileRecord :
oJBoxParser:viewLogFile().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewResultDsRecord C-Win 
PROCEDURE ViewResultDsRecord :
oJBoxParser:viewResultDS().


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewSchemaRecord C-Win 
PROCEDURE ViewSchemaRecord :
oJBoxParser:viewSchemaDS().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BuildViewContent C-Win 
FUNCTION BuildViewContent RETURNS HANDLE
  ( INPUT icViewId AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF VAR hViewTable  AS HANDLE NO-UNDO.
DEF VAR hViewQuery  AS HANDLE NO-UNDO.
DEF VAR hViewBuffer AS HANDLE NO-UNDO.

DEF VAR cPrepString AS CHAR NO-UNDO INIT "FOR EACH ".
DEF VAR ix          AS INT  NO-UNDO.

CREATE TEMP-TABLE hViewTable.

CREATE QUERY hViewQuery.
FOR EACH ttViewTables
    WHERE ttViewTables.ViewId = icViewId
       BY ttViewTables.ViewTableLevel
       BY ttViewTables.ViewTableSeq
    :
  hViewQuery:ADD-BUFFER (ttViewTables.SourceBuffer).
  ix = ix + 1.
  cPrepString = cPrepString + " " + ttViewTables.TableName
              + (IF ix > 1 THEN " WHERE " + ttViewTables.TableName + ".JBoxParentRowIdent = " + ttViewTables.ParentTableName + ".JBoxRowIdent OUTER-JOIN" ELSE "") 
              + ",EACH"    
              .
  FOR EACH ttViewFields
      WHERE ttViewFields.ViewId      = ttViewTables.ViewId
        AND ttViewFields.ViewTableId = ttViewTables.ViewTableId
      :
    hViewTable:ADD-NEW-FIELD (ttViewFields.FieldName,ttViewFields.DataType,0,ttViewFields.FormatString,"",ttViewFields.FieldLabel).    
  END.              
END.

IF ix = 0 THEN DO:
  hViewTable = ?.
  RETURN ?.
END.             

hViewTable:TEMP-TABLE-PREPARE (icViewId).
hViewBuffer = hViewTable:DEFAULT-BUFFER-HANDLE.

FOR EACH ttViewFields 
    WHERE ttViewFields.ViewId = icViewId
    :
  ttViewFields.FieldHandle = hViewBuffer:BUFFER-FIELD(ttViewFields.FieldName).
END.       

cPrepString = SUBSTR(cPrepString,1,R-INDEX(cPrepString,",") - 1).

hViewQuery:QUERY-PREPARE(cPrepString).
hViewQuery:QUERY-OPEN ().
REPEAT WHILE hViewQuery:GET-NEXT():
  hViewBuffer:BUFFER-CREATE ().  
  DO ix = 1 TO hViewQuery:NUM-BUFFERS:
    FOR EACH ttViewFields 
        WHERE ttViewFields.ViewId = icViewId 
          AND ttViewFields.TableName = hViewQuery:GET-BUFFER-HANDLE (ix):NAME.
      ttViewFields.FieldHandle:BUFFER-VALUE = hViewQuery:GET-BUFFER-HANDLE (ix):BUFFER-FIELD(ttViewFields.SourceFieldName):BUFFER-VALUE.  
    END.    
  END.
END.

FINALLY:
  DELETE OBJECT hViewQuery.
  RETURN hViewTable.
END FINALLY.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BuildViewDef C-Win 
FUNCTION BuildViewDef RETURNS CHAR
  ( INPUT icViewId AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF VAR cViewDef AS CHAR NO-UNDO.

FOR EACH ttViewTables
    WHERE ttViewTables.ViewId = icViewId
//       BY ttViewTables.ViewTableLevel
       BY ttViewTables.ViewTableSeq
    :
  cViewDef = cViewDef + (IF cViewDef NE "" THEN "," ELSE "")
           + (IF NOT ttViewTables.JoinType BEGINS "EACH" THEN ENTRY(1,ttViewTables.JoinType," ") + " " ELSE "") 
           + ttViewTables.TableName
           + (IF NUM-ENTRIES(ttViewTables.JoinType," ") > 1 THEN " " + ENTRY(2,ttViewTables.JoinType," ") ELSE "")
           .
  FOR EACH ttViewFields
      WHERE ttViewFields.ViewId      = ttViewTables.ViewId
        AND ttViewFields.ViewTableId = ttViewTables.ViewTableId
      BY ttViewFields.ViewFieldSeq  
      :
    cViewDef = cViewDef + ";" + (IF ttViewFields.OrgFieldName NE "" THEN ttViewFields.OrgFieldName ELSE ttViewFields.FieldName).    
  END.              
END.
cViewDef = cViewDef + ";+jbCountDistinct|INTEGER|>>>>>>>>9;+jbAverage|DECIMAL|->>>>>>>>9.99".    

RETURN cViewDef.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckXML C-Win 
FUNCTION CheckXML RETURNS LONGCHAR
  ( INPUT ilcFile AS LONGCHAR, INPUT icFilename AS CHAR ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR hDoc             AS HANDLE NO-UNDO.
  DEF VAR hRoot            AS HANDLE NO-UNDO.
  DEF VAR doc              AS System.Xml.XmlDocument NO-UNDO.
  DEF VAR lcFile           AS LONGCHAR NO-UNDO.

  CREATE X-DOCUMENT hDoc.
  CREATE X-NODEREF hRoot.
    
  hDoc:LOAD("longchar",ilcFile,NO).
    
  hDoc:GET-DOCUMENT-ELEMENT(hRoot).
  
  IF hRoot:NUM-CHILDREN = 1 THEN DO:
    doc = new System.Xml.XmlDocument().
    DO ON ERROR UNDO, LEAVE:
      doc:LoadXml(ilcFile).
      CATCH ex AS System.Xml.XmlException :
        doc:Load(icFilename).
      END CATCH.
    END.
//    lcFile = System.Xml.Linq.XElement:Parse(doc:OuterXml):ToString().
  END.
  ELSE lcFile = ilcFile.

  FINALLY:
    DELETE OBJECT hDoc.
    DELETE OBJECT hRoot.
    RETURN lcFile.
  END FINALLY.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ClearAll C-Win 
FUNCTION ClearAll RETURNS LOGICAL:
/*------------------------------------------------------------------------------
  Purpose: Clear temp-tables and close tabs
------------------------------------------------------------------------------*/
DEF VAR hTabProc AS HANDLE NO-UNDO.
DEF VAR hQuery   AS HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  FOR EACH ttTableViewTab:
    hTabProc = oTabBrowse:getPageHandle(ttTableViewTab.TabPage#) NO-ERROR.
    IF VALID-HANDLE(hTabProc) THEN
      APPLY "close" TO hTabProc.
    DELETE ttTableViewTab.  
  END.    
  IF VALID-OBJECT(oTabBrowse) THEN DO:
    oTabBrowse:Dispose() NO-ERROR. // needed since dynamic-cast(..):dispose() is not available..
    oContainer:DeleteUserControlByPlaceholder(TabBrowse:HANDLE).
  END.

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(oJBoxParser:hbttTables).
  hQuery:QUERY-PREPARE("FOR EACH ttTables").
  hQuery:QUERY-OPEN ().
  REPEAT WHILE hQuery:GET-NEXT():
    DELETE OBJECT hQuery:GET-BUFFER-HANDLE(1)::hTable NO-ERROR.
  END.
  DELETE OBJECT hQuery.

  oJBoxParser:hdsSchema:EMPTY-DATASET().
    
  EMPTY TEMP-TABLE ttView.
  EMPTY TEMP-TABLE ttViewTables.
  EMPTY TEMP-TABLE ttViewFields.
  EMPTY TEMP-TABLE ttEndpoint.
  EMPTY TEMP-TABLE ttEndpointParam.
  lcPutPost = "".
  
  flatFile(YES).
  otbJson:disabledTools = "".
  otbJson:setTools().
  
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION DeepCopyTT C-Win 
FUNCTION DeepCopyTT RETURNS LOGICAL
  ( INPUT ihFromTt AS HANDLE,INPUT ihToTt AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR hQuery   AS HANDLE NO-UNDO.
DEF VAR ix       AS INT NO-UNDO.
DEF VAR hFromFld AS HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS (ihFromTt).
  hQuery:QUERY-PREPARE ("FOR EACH " + ihFromTt:NAME).
  hQuery:QUERY-OPEN ().
  REPEAT WHILE hQuery:GET-NEXT().
    ihToTt:BUFFER-CREATE ().
    DO ix = 1 TO ihToTt:NUM-FIELDS:
      hFromFld = ihFromTt:BUFFER-FIELD(ihToTt:BUFFER-FIELD (ix):NAME) NO-ERROR.
      IF VALID-HANDLE (hFromFld) THEN
        ihToTt:BUFFER-FIELD (ix):BUFFER-VALUE = hFromFld:BUFFER-VALUE. 
    END.
  END.
  DELETE OBJECT hQuery.
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteViewTables C-Win 
FUNCTION deleteViewTables RETURNS LOGICAL
  ( INPUT icViewId AS CHAR,
    INPUT icViewTableId AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttViewTables FOR ttViewTables.
DEF BUFFER ttViewFields FOR ttViewFields.

FOR EACH ttViewTables
    WHERE ttViewTables.ViewId = icViewId
      AND ttViewTables.ParentViewTableId = icViewTableId
    :
  FOR EACH ttViewFields
      WHERE ttViewFields.ViewId = ttView.ViewId
        AND ttViewFields.ViewTableId = ttViewTables.ViewTableId
      :
    DELETE ttViewFields.
  END.   
  deleteViewTables(icViewId,ttViewTables.ViewTableId).           
  DELETE ttViewTables.
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION flatFile C-Win 
FUNCTION flatFile RETURNS LOGICAL
  ( INPUT ibClear AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
FIND FIRST ttCsvTable NO-ERROR.

IF AVAIL ttCsvTable THEN DO:
  IF ibClear THEN
    ttCsvTable.hBuffer = ?.
  RETURN VALID-HANDLE(ttCsvTable.hBuffer).
END.  
ELSE RETURN NO.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTableFieldList C-Win 
FUNCTION getTableFieldList RETURNS CHARACTER
  ( INPUT icTableName     AS CHAR,
    INPUT icSelectedList  AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF VAR hqttFields AS HANDLE NO-UNDO.
DEF VAR ix         AS INT    NO-UNDO.
DEF VAR cFieldList AS CHAR   NO-UNDO.

EMPTY TEMP-TABLE ttSelectFields.

CREATE QUERY hqttFields.
hqttFields:SET-BUFFERS(hbttFields).

hqttFields:QUERY-PREPARE("FOR EACH " + hbttFields:NAME
                       + " WHERE TableName = '" + icTableName + "'"
                       + " AND NOT FieldName MATCHES 'JBox*RowIdent'"
                         ).
hqttFields:QUERY-OPEN ().
REPEAT WHILE hqttFields:GET-NEXT().
  cFieldList = cFieldList + (IF cFieldList NE "" THEN "|" ELSE "") + hbttFields::FieldName + "|" + hbttFields::FieldName.
  CREATE ttSelectFields.
  ASSIGN ttSelectFields.TableName = hbttFields::TableName
         ttSelectFields.FieldName = hbttFields::FieldName
         ttSelectFields.FieldType = hbttFields::DataType
         ttSelectFields.ixSelected  = LOOKUP(hbttFields::FieldName,icSelectedList)
         ix = ix + 1
         ttSelectFields.RowIdent1 = STRING(ix)
         .
END.

FINALLY:
  DELETE OBJECT hqttFields.
  RETURN cFieldList.
END.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION LoadEndpoint C-Win 
FUNCTION LoadEndpoint RETURNS LOGICAL
  ( INPUT icFileName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR hDsEndpoint  AS HANDLE NO-UNDO.
DEF VAR ix           AS INT NO-UNDO.
DEF VAR iy           AS INT NO-UNDO.
DEF VAR hbttSchema   AS HANDLE NO-UNDO.
DEF VAR hbttEndpoint AS HANDLE NO-UNDO.
DEF VAR hEndPointFld AS HANDLE NO-UNDO.
DEF VAR cSchemaName  AS CHAR   NO-UNDO.
DEF VAR hQuery       AS HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  clearAll().
  CREATE DATASET hDsEndpoint.
  hDsEndpoint:READ-JSON ("file",icFileName,"empty").
  DO ix = 1 TO hDsEndpoint:NUM-BUFFERS:
    IF CAN-DO("ttTables,ttFields",hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME) THEN DO:
      CREATE QUERY hQuery.
      hbttSchema = oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME).
      hbttEndpoint = hDsEndpoint:GET-BUFFER-HANDLE (ix).
      hQuery:SET-BUFFERS (hbttEndpoint).
      hQuery:QUERY-PREPARE ("FOR EACH " + hbttEndpoint:NAME).
      hQuery:QUERY-OPEN ().
      REPEAT WHILE hQuery:GET-NEXT().
        hbttSchema:BUFFER-CREATE ().
        DO iy = 1 TO hbttSchema:NUM-FIELDS:
          hEndPointFld = hbttEndpoint:BUFFER-FIELD(hbttSchema:BUFFER-FIELD (iy):NAME) NO-ERROR.
          IF VALID-HANDLE (hEndPointFld) THEN
            hbttSchema:BUFFER-FIELD (iy):BUFFER-VALUE = hEndPointFld:BUFFER-VALUE. 
        END.
        IF hbttEndpoint:NAME = "ttTables" AND cSchemaName = "" THEN
          cSchemaName = hbttEndpoint::TableName. 
      END.
      DELETE OBJECT hQuery.
    END.
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttEndpoint" THEN 
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttEndpoint:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttEndpointParam" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttEndpointParam:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttView" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttView:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttViewTables" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttViewTables:HANDLE).
    ELSE IF hDsEndpoint:GET-BUFFER-HANDLE (ix):NAME = "ttViewFields" THEN
      oJBoxParser:deepCopyTT(hDsEndpoint:GET-BUFFER-HANDLE (ix), BUFFER ttViewFields:HANDLE).
  END.
    
  oJBoxParser:cSchemaName = cSchemaName.
  oJBoxParser:LoadSchema("").
  IF oJBoxParser:statusMessage NE "" THEN DO:
    MESSAGE "Parser status message" SKIP oJBoxParser:statusMessage
    VIEW-AS ALERT-BOX.
    RETURN NO.
  END.
END.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION LoadFile C-Win 
FUNCTION LoadFile RETURNS LOGICAL
  ( INPUT icFileName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR hProgBar  AS HANDLE   NO-UNDO.
DEF VAR lcFile    AS LONGCHAR NO-UNDO.
DEF VAR oXML      AS JBoxXml  NO-UNDO.

cJsonFile = icFileName.

cTablePrefix = "".

DO WITH FRAME {&FRAME-NAME}:
  clearAll().
  
  FIX-CODEPAGE(lcFile) = "UTF-8".

/*  RUN JBoxProgressBar.w PERSISTENT SET hProgBar.                          */
/*  DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 10,"Imports file..").*/

  SESSION:SET-WAIT-STATE("general").

  RUN ReadFileInChunks (icFileName,OUTPUT lcFile).
//  COPY-LOB FROM FILE cFileName TO lcFile.

//  DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 30,"Reads schema and data..").
  cSchemaName = RIGHT-TRIM(REPLACE(ENTRY(1,ENTRY(NUM-ENTRIES(icFileName,"\/"),icFileName,"\/"),".")," ",""),"_") + "_root".
    
  IF icFileName MATCHES "*.xml*" THEN 
    oJBoxParser:createXMLSchema(CheckXML(lcFile,icFilename),cSchemaName).
  ELSE DO:  
    oJBoxParser:fieldsUsedAsTableName = cFieldsUsedAsTableList.
    
    oJBoxParser:createSchema(lcFile,cSchemaName).
   //  oJBoxParser:returnBlankWhenNoValue = YES.
  END.
  lcJson = lcFile.
    
//  DYNAMIC-FUNCTION("SetStartupProgress" in hProgBar, 100,"Reads schema and data..").
  IF oJBoxParser:statusMessage = "" THEN DO:
    THIS-PROCEDURE:CURRENT-WINDOW:TITLE = icFileName.
    
    ViewSchema(). 
    
  //  oJBoxParser:viewSchemaDS().
  //  oJBoxParser:viewResultDS().
  //  oJBoxParser:viewTtTables().
  END.
  ELSE DO:
    MESSAGE "Status message" oJBoxParser:statusMessage 
    VIEW-AS ALERT-BOX.
    IF oJBoxParser:logFile NE "" THEN
      oJBoxParser:viewLogFile().
  END.
  
END.

FINALLY:
  SESSION:SET-WAIT-STATE("").
  RETURN YES.
END.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ReCreateView C-Win 
FUNCTION ReCreateView RETURNS LOGICAL
  ( INPUT icViewId AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF BUFFER ttView FOR TEMP-TABLE ttView.
DEF BUFFER bttViewFields FOR TEMP-TABLE ttViewFields.

DEF VAR hqttFields AS HANDLE NO-UNDO.
DEF VAR iFieldSeq  AS INT    NO-UNDO.

CREATE QUERY hqttFields.
hqttFields:SET-BUFFERS(hbttFields).

FIND FIRST ttView 
     WHERE ttView.ViewId = icViewId
     NO-ERROR.
IF AVAIL ttView THEN DO:
  IF VALID-HANDLE(ttView.hViewTable) THEN 
    DELETE OBJECT ttView.hViewTable.
  FOR EACH ttViewFields
      WHERE ttViewFields.ViewID = ttView.ViewID:
    DELETE ttViewFields.
  END.
    
  FOR EACH ttViewTables
      WHERE ttViewTables.ViewID = ttView.ViewId
         BY ttViewTables.ViewTableLevel
         BY ttViewTables.ViewTableSeq
      :
    hqttFields:QUERY-PREPARE("FOR EACH " + hbttFields:NAME + " WHERE TableName = '" + ttViewTables.TableName + "'").
    hqttFields:QUERY-OPEN ().
    REPEAT WHILE hqttFields:GET-NEXT().
      IF ttViewTables.FieldList NE "" AND NOT CAN-DO(ttViewTables.FieldList,hbttFields::FieldName) THEN NEXT.   
      FIND FIRST bttViewFields
           WHERE bttViewFields.ViewId  = ttView.ViewId
             AND bttViewFields.FieldName = hbttFields::FieldName
           NO-ERROR.  
      CREATE ttViewFields.
      ASSIGN ttViewFields.ViewId            = ttView.ViewId
             ttViewFields.ViewTableId       = ttViewTables.ViewTableId
             ttViewFields.SourceFieldName   = hbttFields::FieldName
             ttViewFields.SourceFieldHandle = hbttFields::hField
             ttViewFields.FieldName         = SUBSTR(IF AVAIL bttViewFields THEN ttViewTables.TableName + "_" + hbttFields::FieldName ELSE hbttFields::FieldName,1,32)
             ttViewFields.OrgFieldName      = IF AVAIL bttViewFields THEN hbttFields::FieldName ELSE ""
             ttViewFields.FormatString      = hbttFields::FormatString
             ttViewFields.TableName         = hbttFields::TableName
             ttViewFields.DataType          = hbttFields::DataType
             ttViewFields.FieldLabel        = ttViewFields.TableName + "." + hbttFields::FieldName
             iFieldSeq                      = (IF ttViewTables.FieldList NE "" THEN LOOKUP(hbttFields::FieldName,ttViewTables.FieldList) ELSE iFieldSeq + 1)
             ttViewFields.ViewFieldSeq      = iFieldSeq
             .
    END.
  END.       
END.

FINALLY:
  DELETE OBJECT hqttFields.
  RETURN YES.
END.  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION renumTabs C-Win 
FUNCTION renumTabs RETURNS LOGICAL
  ( INPUT iiTab# AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/

DEF BUFFER ttTableViewTab FOR ttTableViewTab.

FOR EACH ttTableViewTab
    WHERE ttTableViewTab.TabPage# GT iiTab#
    :
  ttTableViewTab.TabPage# = ttTableViewTab.TabPage# - 1.
END.      

RETURN YES.

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
DEF VAR ix           AS INT  NO-UNDO.
DEF VAR bOnlyJbox    AS LOG  NO-UNDO INIT YES.

IF AVAIL ttEndpoint AND ioBrowse:BUFFER-HANDLE:NAME = "ttEndpointParam" THEN DO:
  ioBrowse:buffersAndFields = "ttEndpointParam;EndPointParamType;EndpointParamName;EndpointParamValue".
  ioBrowse:setQuerySort("ttEndpointParam.EndPointParamType,ttEndpointParam.EndpointParamSeq").
END.    
ELSE DO WITH FRAME {&FRAME-NAME}:
  cBuffAndFlds = cCurrentTable.
  DO ix = 1 TO ioBrowse:BROWSE-HANDLE:NUM-COLUMNS:
    IF NOT ioBrowse:BROWSE-HANDLE:GET-BROWSE-COLUM(ix):NAME MATCHES "*Jbox*Ident" OR tbViewSerialized:CHECKED THEN
      cBuffAndFlds = cBuffAndFlds + ";" + ioBrowse:BROWSE-HANDLE:GET-BROWSE-COLUM(ix):NAME.
    ELSE bOnlyJbox = NO.  
  END.
  IF NOT bOnlyJbox THEN 
    ioBrowse:buffersAndFields = cBuffAndFlds.
END.
oPageBrowse = ioBrowse.
//ioBrowse:createGridFilter("").
RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION StartTab C-Win 
FUNCTION StartTab RETURNS LOGICAL
  ( INPUT ihBuffer   AS HANDLE
   ,INPUT icViewId AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR iTab# AS INT NO-UNDO INIT 1.

FIND LAST ttTableViewTab NO-ERROR.     
IF AVAIL ttTableViewTab THEN 
  iTab# = ttTableViewTab.TabPage# + 1.
ELSE DO:
  oTabBrowse = NEW JBoxMsTabs(TabBrowse:HANDLE IN FRAME {&FRAME-NAME}).
  APPLY "end-move" TO btnSplitBarX IN FRAME frSplitBarX.
END.  

IF ihBuffer NE ? THEN DO:
  cCurrentTable = IF NUM-ENTRIES(icViewId,"|") > 1 THEN ENTRY(2,icViewId,"|") ELSE IF icViewId NE "" THEN icViewId ELSE ihBuffer:NAME.
  oTabBrowse:AddPage(cCurrentTable,"JBoxDynTableGrid.w").
  RUN SetBuffersAndFields IN oTabBrowse:getPageHandle(iTab#) (ihBuffer).
  CREATE ttTableViewTab.
  ASSIGN ttTableViewTab.TableOrViewId   = cCurrentTable 
         ttTableViewTab.TabPage#        = iTab#
         ttTableViewTab.oDataBrowseObj  = CAST(oPageBrowse,"Progress.Lang.Object")
         .       
  oTabBrowse:SelectTab(cCurrentTable).
END.
ELSE DO:
  oTabBrowse:AddPage("dict","JBoxDynTableGrid.w").
  cCurrentTable = "dict".
  RUN SetBuffersAndFields IN oTabBrowse:getPageHandle(iTab#) 
      (IF flatFile(NO) THEN ttCsvTable.hSchemaBuffer ELSE oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(2)).
  CREATE ttTableViewTab.
  ASSIGN ttTableViewTab.TableOrViewId   = "dict"
         ttTableViewTab.TabPage#        = iTab#
         ttTableViewTab.oDataBrowseObj  = CAST(oPageBrowse,"Progress.Lang.Object")
         .       
  oTabBrowse:SelectTab("dict").
END.  

oPageBrowse:createGridFilter("").
IF NUM-ENTRIES(icViewId,"|") > 1 THEN DO:
  DYNAMIC-FUNCTION("setEditProc" IN oTabBrowse:getPageHandle(1),"editEndpointParam").
  DYNAMIC-FUNCTION("setNewProc" IN oTabBrowse:getPageHandle(1),"NewEndpointParam").
  oPageBrowse:TOOLBAR-OBJECT:addToolGroup("new,delete").
END.  

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ViewSchema C-Win 
FUNCTION ViewSchema RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
DEF VAR cParentLevel AS CHAR NO-UNDO. 
DEF VAR cLevel       AS CHAR NO-UNDO.

DEF VAR httTable AS HANDLE NO-UNDO.
DEF VAR hBuffer  AS HANDLE NO-UNDO.

hbttTables = oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(1).
hbttFields = oJBoxParser:hdsSchema:GET-BUFFER-HANDLE(2).

oJBoxMsTreeView:clearNodes().

FOR EACH ttView:
  oJBoxMsTreeView:AddNode("",ttView.ViewID,ttView.ViewId,"View",2,1).
  FOR EACH ttViewTables
      WHERE ttViewTables.ViewId = ttView.ViewID
        BY ttViewTables.ViewTableLevel
        BY ttViewTables.ViewTableSeq
      :
    oJBoxMsTreeView:AddNode(ttViewTables.ParentViewTableId,ttView.ViewId + CHR(1) + ttViewTables.ViewTableId,ttViewTables.TableName,"ViewTable",3,1).
  END.   
  IF tbViewFields:CHECKED IN FRAME {&FRAME-NAME} THEN   
    FOR EACH ttViewFields
        WHERE ttViewFields.ViewId = ttView.ViewId
          BY ttViewFields.ViewFieldSeq
        :
      oJBoxMsTreeView:AddNode(ttView.ViewId,ttViewFields.FieldName,ttViewFields.FieldName + " " + SUBSTR(ttViewFields.DataType,1,4) + " " + ttViewFields.FormatString,"ViewField",4,1).
    END.      
END.  
  

CREATE QUERY hqttFields.
hqttFields:SET-BUFFERS(hbttFields).

CREATE QUERY hqttTables.
hqttTables:SET-BUFFERS (hbttTables).
hqttTables:QUERY-PREPARE("FOR EACH " + hbttTables:NAME).
hqttTables:QUERY-OPEN ().
REPEAT WHILE hqttTables:GET-NEXT ():
  oJBoxMsTreeView:AddNode(STRING(hbttTables::ParentSeq),STRING(hbttTables::Seq)
                         ,hbttTables::TableName + (IF tbViewSerialized:CHECKED THEN " - " + hbttTables::JsonTableName ELSE "")
                         ,"Table",3,1).
/*
  CREATE TEMP-TABLE httTable.
  hBuffer = hbttTables::hBuffer.
  IF NOT VALID-HANDLE(hBuffer) THEN hBuffer = hbttTables::hTable.
  httTable:CREATE-LIKE (hBuffer).
  httTable:ADD-NEW-FIELD ("jbCountDistinct","INTEGER",0,">>>>>>>9").
  httTable:ADD-NEW-FIELD ("jbAverage","DECIMAL",0,"->>>>>>>9.99").
  httTable:ADD-NEW-FIELD ("RowCount","INTEGER",0,">>>>>>>9").
  httTable:TEMP-TABLE-PREPARE (hbttTables::hBuffer:NAME).
  httTable:DEFAULT-BUFFER-HANDLE:COPY-TEMP-TABLE(hBuffer,NO,YES,YES) NO-ERROR.
  IF ERROR-STATUS:ERROR THEN
    MESSAGE hBuffer::TableName SKIP ERROR-STATUS:GET-MESSAGE(1)
    VIEW-AS ALERT-BOX.
  hbttTables::hBuffer = httTable:DEFAULT-BUFFER-HANDLE.
*/
  IF tbViewFields:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
    hqttFields:QUERY-PREPARE("FOR EACH " + hbttFields:NAME + " WHERE TableSeq = " + STRING(hbttTables::Seq)).
    hqttFields:QUERY-OPEN ().
    REPEAT WHILE hqttFields:GET-NEXT().
      IF NOT hbttFields::FieldName MATCHES "*JBox*Ident" THEN
        oJBoxMsTreeView:AddNode(STRING(hbttTables::Seq),hbttFields::FieldName,hbttFields::FieldName + " " + SUBSTR(hbttFields::DataType,1,4) + " " + hbttFields::FormatString,"Field",4,-1).
    END.
  END.  
END.  

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "Table" /* The menu is added to nodes of type "Produkt" */
                                    ).

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseTable", /* Procedure to call when menu item is selected */  
                                   "Browse table content", /* Text */
                                   "ico\bullet_ball_yellow.ico"). 

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseTableInSeparateWin", /* Procedure to call when menu item is selected */  
                                   "Browse table in separate window", /* Text */
                                   "ico\bullet_triangle_yellow.ico"). 

oJBoxMsTreeView:AddContextMenuItem("Table",
                                   "",
                                   "BrowseFields", /* Procedure to call when menu item is selected */  
                                   "Browse fields", /* Text */
                                   "ico\bullet_ball_green.ico"). 

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "View" /* The menu is added to nodes of type "View" */
                                    ).

oJBoxMsTreeView:AddContextMenuItem("View",
                                   "",
                                   "BrowseView", /* Procedure to call when menu item is selected */  
                                   "Browse view content", /* Text */
                                   "ico\bullet_ball_yellow.ico"). 

oJBoxMsTreeView:AddContextMenuItem("View",
                                   "",
                                   "BrowseViewInSeparateWin", /* Procedure to call when menu item is selected */  
                                   "Browse view in separate window", /* Text */
                                   "ico\bullet_triangle_yellow.ico"). 

oJBoxMsTreeView:AddContextMenuStrip("",
                                    "ViewTable" /* The menu is added to nodes of type "ViewTable" */
                                    ).
oJBoxMsTreeView:AddContextMenuItem("ViewTable",
                                   "",
                                   "SelectTableViewFields", /* Procedure to call when menu item is selected */  
                                   "Select fields", /* Text */
                                   "ico\bullet_ball_green.ico"). 

oJBoxMsTreeView:AddContextMenuItem("ViewTable",
                                   "",
                                   "DeleteViewTable", /* Procedure to call when menu item is selected */  
                                   "Delete", /* Text */
                                   "bmp\del16e.bmp"). 


oJBoxMsTreeView:ExpandNodes("").

FINALLY:
  DELETE OBJECT hqttFields.
  DELETE OBJECT hqttTables.
  RETURN YES.
END.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

