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
/* &SCOPED-DEFINE AdvGuiWin */ 

{tt_schema.i SHARED}
hdsSchema = DATASET dsSchema:HANDLE.

{incl\tt_viewds.i}
hdsViewDs = DATASET dsViewDs:HANDLE.

/* Local Variable Definitions ---                                       */
DEF VAR bOk           AS LOG    NO-UNDO.
DEF VAR hBrowse       AS HANDLE NO-UNDO. /* placeholder */
DEF VAR oContainer    AS JBoxContainer NO-UNDO.
DEF VAR cDropDownFlds AS CHAR NO-UNDO.
DEF VAR cLookupFlds   AS CHAR NO-UNDO.

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

DEF VAR oLookup             AS JBoxDynLookup NO-UNDO.

DEF TEMP-TABLE ttLookup
    FIELD DatasourceName    AS CHAR FORMAT "x(32)"
    FIELD DatabaseName      AS CHAR FORMAT "x(32)"
    FIELD TableName         AS CHAR FORMAT "x(32)"
    FIELD FieldName         AS CHAR FORMAT "x(32)"
    FIELD SourceProcName    AS CHAR FORMAT "x(30)"
    FIELD LookupDatasource  AS CHAR FORMAT "x(32)"
    FIELD LookupDatabase    AS CHAR FORMAT "x(32)"
    FIELD LookupBaseTable   AS CHAR FORMAT "x(32)"
    FIELD QueryDef          AS CHAR FORMAT "x(50)" 
    FIELD QueryString       AS CHAR FORMAT "x(50)"
    FIELD LookupReturnField AS CHAR FORMAT "x(32)"
    FIELD DropDownValueList AS CHAR FORMAT "x(120)"
    FIELD LookupGuid        AS CHAR
    FIELD sessionOnly       AS LOG
    FIELD RowIdent1         AS CHAR
    INDEX idxLookup IS UNIQUE DatasourceName DatabaseName TableName SourceProcName FieldName sessionOnly
    .  

DEF TEMP-TABLE ttImport
    FIELD DatasourceName    AS CHAR
    FIELD DatabaseName      AS CHAR
    FIELD TableName         AS CHAR FORMAT "x(30)"
    FIELD FieldName         AS CHAR FORMAT "x(30)"
    FIELD SourceProcName    AS CHAR FORMAT "x(20)"
    FIELD LookupDatasource  AS CHAR
    FIELD LookupDatabase    AS CHAR
    FIELD LookupBaseTable   AS CHAR
    FIELD QueryDef          AS CHAR FORMAT "x(50)"
    FIELD QueryString       AS CHAR FORMAT "x(50)"
    FIELD LookupReturnField AS CHAR FORMAT "x(30)"
    FIELD DropDownValueList AS CHAR FORMAT "x(120)"
    FIELD LookupGuid        AS CHAR
    FIELD RowIdent1         AS CHAR
    INDEX idxLookup IS UNIQUE DatasourceName DatabaseName TableName SourceProcName FieldName
    .
DEF VAR hbttLookup AS HANDLE NO-UNDO.
hbttLookup = BUFFER ttLookup:HANDLE.

DEF VAR oBrwLookup AS JBoxBrowse NO-UNDO.


DEF VAR oFmLookup AS JBoxFieldMap NO-UNDO.


DEF VAR otbLookup AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnSearchLookupTarget new_tbLookup ~
btnSourceProcName edit_tbLookup copy_tbLookup undo_tbLookup save_tbLookup ~
delete_tbLookup refresh_tbLookup excel_tbLookup DatasourceName DatabaseName ~
TableName FieldName SourceProcName RsType LookupDatasource LookupDatabase ~
LookupBaseTable LookupReturnField QueryDef QueryString DropDownValueList ~
btnQueryDef brwLookup tbLookup 
&Scoped-Define DISPLAYED-OBJECTS DatasourceName DatabaseName TableName ~
FieldName SourceProcName RsType LookupDatasource LookupDatabase ~
LookupBaseTable LookupReturnField QueryDef QueryString DropDownValueList 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD BuildTableLookup C-Win 
FUNCTION BuildTableLookup RETURNS LOGICAL
  ( INPUT icTable AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCombos C-Win 
FUNCTION setCombos RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VARIABLE C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnQueryDef 
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON btnSearchLookupTarget  NO-FOCUS FLAT-BUTTON
     LABEL "Search lookup-target" 
     SIZE 46.4 BY 1.14 TOOLTIP "Search lookup table within selected datasource".

DEFINE BUTTON btnSourceProcName 
     IMAGE-UP FILE "bmp/folderopen.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "..." 
     SIZE 4 BY 1.

DEFINE BUTTON copy_tbLookup 
     IMAGE-UP FILE "bmp/copy.bmp":U
     LABEL "Kopier" 
     SIZE 4.6 BY 1.1 TOOLTIP "Kopier (ALT-K)".

DEFINE BUTTON delete_tbLookup 
     IMAGE-UP FILE "bmp/del16e.bmp":U
     LABEL "Slett" 
     SIZE 4.6 BY 1.1 TOOLTIP "Slett (CTRL-D)".

DEFINE BUTTON edit_tbLookup 
     IMAGE-UP FILE "bmp/edit16e.bmp":U
     LABEL "Edit" 
     SIZE 4.6 BY 1.1 TOOLTIP "Edit (CTRL-E)".

DEFINE BUTTON excel_tbLookup 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 4.6 BY 1.1 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON new_tbLookup 
     IMAGE-UP FILE "bmp/new16e.bmp":U
     LABEL "Ny" 
     SIZE 4.6 BY 1.1 TOOLTIP "Ny (CTRL-N)".

DEFINE BUTTON refresh_tbLookup 
     IMAGE-UP FILE "gif/refresh.gif":U
     LABEL "Refresh" 
     SIZE 4.6 BY 1.1 TOOLTIP "Refresh (F5)".

DEFINE BUTTON save_tbLookup 
     IMAGE-UP FILE "bmp/save.bmp":U
     LABEL "Lagre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Lagre (CTRL-S)".

DEFINE BUTTON undo_tbLookup 
     IMAGE-UP FILE "bmp/undo16e.bmp":U
     LABEL "Angre" 
     SIZE 4.6 BY 1.1 TOOLTIP "Angre (CTRL-Z)".

DEFINE VARIABLE DatabaseName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Database" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 46.6 BY 1 NO-UNDO.

DEFINE VARIABLE DatasourceName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Datasource" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE FieldName AS CHARACTER 
     LABEL "Field name" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN
     SIZE 46.4 BY 1 NO-UNDO.

DEFINE VARIABLE LookupBaseTable AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lookup base table" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE LookupDatabase AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lookup database" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 46.4 BY 1 NO-UNDO.

DEFINE VARIABLE LookupDatasource AS CHARACTER FORMAT "X(256)":U 
     LABEL "Lookup datasource" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 43 BY 1 NO-UNDO.

DEFINE VARIABLE LookupReturnField AS CHARACTER 
     LABEL "Lookup return field" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN
     SIZE 46.4 BY 1 NO-UNDO.

DEFINE VARIABLE TableName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Table name" 
     VIEW-AS COMBO-BOX INNER-LINES 25
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 44 BY 1 NO-UNDO.

DEFINE VARIABLE DropDownValueList AS CHARACTER FORMAT "X(320)":U 
     LABEL "Drop-down values" 
     VIEW-AS FILL-IN 
     SIZE 107 BY 1 NO-UNDO.

DEFINE VARIABLE QueryDef AS CHARACTER FORMAT "X(256)":U 
     LABEL "Query def" 
     VIEW-AS FILL-IN 
     SIZE 107 BY 1 TOOLTIP "List of buffers (tables) and fields" NO-UNDO.

DEFINE VARIABLE QueryString AS CHARACTER FORMAT "X(320)":U 
     LABEL "Query string" 
     VIEW-AS FILL-IN 
     SIZE 107 BY 1 NO-UNDO.

DEFINE VARIABLE SourceProcName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Program name" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1 NO-UNDO.

DEFINE VARIABLE RsType AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Lookup", 1,
"Drop-down", 2,
"Drop-down values", 3
     SIZE 49 BY 1.19 NO-UNDO.

DEFINE RECTANGLE brwLookup
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 130 BY 8.95.

DEFINE RECTANGLE tbLookup
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 130.2 BY 1.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnSearchLookupTarget AT ROW 14.24 COL 84 WIDGET-ID 48
     new_tbLookup AT ROW 1.38 COL 2.2 WIDGET-ID 30
     btnSourceProcName AT ROW 14.29 COL 61.4 WIDGET-ID 14 NO-TAB-STOP 
     edit_tbLookup AT ROW 1.38 COL 6.8 WIDGET-ID 32
     copy_tbLookup AT ROW 1.38 COL 11.6 WIDGET-ID 34
     undo_tbLookup AT ROW 1.38 COL 16.2 WIDGET-ID 36
     save_tbLookup AT ROW 1.38 COL 21 WIDGET-ID 38
     delete_tbLookup AT ROW 1.38 COL 25.6 WIDGET-ID 40
     refresh_tbLookup AT ROW 1.38 COL 30.4 WIDGET-ID 42
     excel_tbLookup AT ROW 1.38 COL 35 WIDGET-ID 44
     DatasourceName AT ROW 12.1 COL 19.4 COLON-ALIGNED WIDGET-ID 4
     DatabaseName AT ROW 12.1 COL 82 COLON-ALIGNED WIDGET-ID 6
     TableName AT ROW 13.19 COL 19.4 COLON-ALIGNED WIDGET-ID 8
     FieldName AT ROW 13.19 COL 82.2 COLON-ALIGNED WIDGET-ID 10
     SourceProcName AT ROW 14.29 COL 19.4 COLON-ALIGNED
     RsType AT ROW 15.52 COL 43 NO-LABEL WIDGET-ID 24
     LookupDatasource AT ROW 16.91 COL 19.4 COLON-ALIGNED WIDGET-ID 16
     LookupDatabase AT ROW 16.91 COL 82 COLON-ALIGNED WIDGET-ID 18
     LookupBaseTable AT ROW 18.05 COL 19.2 COLON-ALIGNED WIDGET-ID 20
     LookupReturnField AT ROW 18 COL 82 COLON-ALIGNED WIDGET-ID 46
     QueryDef AT ROW 19.19 COL 19.2 COLON-ALIGNED
     QueryString AT ROW 20.29 COL 19.2 COLON-ALIGNED
     DropDownValueList AT ROW 21.38 COL 19.2 COLON-ALIGNED
     btnQueryDef AT ROW 19.19 COL 128.2 WIDGET-ID 22 NO-TAB-STOP 
     brwLookup AT ROW 2.76 COL 2 WIDGET-ID 2
     tbLookup AT ROW 1.29 COL 2 WIDGET-ID 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1
         SIZE 132.2 BY 21.91 WIDGET-ID 100.


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
         TITLE              = "Lookup maintenance"
         HEIGHT             = 21.71
         WIDTH              = 132.2
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 132.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 132.2
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
   FRAME-NAME Custom                                                    */
ASSIGN 
       tbLookup:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "new;Ny,edit;Edit,copy;Kopier,undo;Angre,save;Lagre,delete;Slett,refresh;Refresh,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Lookup maintenance */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Lookup maintenance */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnQueryDef
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnQueryDef C-Win
ON CHOOSE OF btnQueryDef IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR hViewDef  AS HANDLE NO-UNDO.
  DEF VAR ix        AS INT NO-UNDO.
  DEF VAR cViewDsId AS CHAR NO-UNDO.
  
  hViewDef = oContainer:StartChildWindow("JBoxViewDsDefTable.w","Define lookup/drop-down query",YES).

  RUN RefreshSchemaDataSet IN hViewDef (hdsSchema).

  IF QueryDef:SCREEN-VALUE = "" THEN DO:    
    
    RUN CreateViewDs IN hViewDef(LookupDatasource:SCREEN-VALUE,"",LookupDatabase:SCREEN-VALUE,LookupBaseTable:SCREEN-VALUE,"Lookup",INPUT-OUTPUT cViewDsId).
    
/*    CREATE ttViewDs.                                                                            */
/*    ASSIGn ttViewDs.SourceName   = LookupDatasource:SCREEN-VALUE                                */
/*           ttViewDs.BaseDb       = LookupDatabase:SCREEN-VALUE                                  */
/*           ttViewDs.BaseTable    = LookupBaseTable:SCREEN-VALUE                                 */
/*           ttViewDs.ViewDsId     = GUID                                                         */
/*           ttViewDs.ViewDsName   = "Lookup"                                                     */
/*           .                                                                                    */
/*                                                                                                */
/*    RUN "RefreshViewTempTable" IN hViewDef (hdsViewDs:GET-BUFFER-HANDLE(1),ttViewDs.ViewDsId,?).*/

    RUN AddFieldsRecord IN hViewDef.
  END.  
  ELSE
    RUN ReBuildTablesFromText IN hViewDef (IF NUM-ENTRIES(QueryDef:SCREEN-VALUE,";") = 1 THEN
                                             LookupDatabase:SCREEN-VALUE + "." + QueryDef:SCREEN-VALUE
                                           ELSE QueryDef:SCREEN-VALUE  
                                          ,QueryString:SCREEN-VALUE
                                          ,IF RsType:SCREEN-VALUE = "2" THEN "drop-down" ELSE "").
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSearchLookupTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSearchLookupTarget C-Win
ON CHOOSE OF btnSearchLookupTarget IN FRAME DEFAULT-FRAME /* Search lookup-target */
DO:
DEF VAR cFieldList          AS CHAR NO-UNDO.
DEF VAR cFilterReturnField  AS CHAR NO-UNDO.
DEF VAR cLookupTable        AS CHAR NO-UNDO.
DEF VAR cLookupDb           AS CHAR NO-UNDO.
DEF VAR cBaseQuery          AS CHAR NO-UNDO.

JBoxServerAPI:Instance:Lookup(hbttTableLookup).                                                
IF JBoxServerAPI:Instance:LookupOk THEN DO:
  LookupDatabase:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("Db").
  RUN ValueChangedField("LookupDatabase").
  LookupBaseTable:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("TableName").
  RUN ValueChangedField("LookupBaseTable").
  IF RsType:SCREEN-VALUE = "1" THEN DO:
    LookupReturnField:SCREEN-VALUE = JBoxServerAPI:Instance:LookupValue("FieldMatch").
    APPLY "leave" TO LookupReturnField.
  END.  
 
 /* 
  FIND FIRST tt_db
       WHERE tt_db.cLDBname    = cLookupDb.
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
      */  
  END.
  ELSE RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSourceProcName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSourceProcName C-Win
ON CHOOSE OF btnSourceProcName IN FRAME DEFAULT-FRAME /* ... */
DO:
  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = SourceProcName:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cUseFileName USE-FILENAME UPDATE bOk.
  IF bOk THEN 
    SourceProcName:SCREEN-VALUE = ENTRY(NUM-ENTRIES(cUseFileName,"\"),cUseFileName,"\").  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME LookupReturnField
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LookupReturnField C-Win
ON RETURN OF LookupReturnField IN FRAME DEFAULT-FRAME /* Lookup return field */
DO:
  IF ENTRY(1,QueryDef:SCREEN-VALUE,";") = LookupBaseTable:SCREEN-VALUE THEN
    QueryDef:SCREEN-VALUE = QueryDef:SCREEN-VALUE + ";" + SELF:SCREEN-VALUE.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RsType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RsType C-Win
ON VALUE-CHANGED OF RsType IN FRAME DEFAULT-FRAME
DO:
  CASE SELF:SCREEN-VALUE:
    WHEN "1" THEN
      ASSIGN LookupReturnField:SENSITIVE = YES
             DropDownValueList:SENSITIVE = NO
             DropDownValueList:SCREEN-VALUE = ""
             QueryString:SENSITIVE = YES
             QueryDef:SENSITIVE = YES
             LookupDatasource:SENSITIVE = YES
             LookupDatabase:SENSITIVE = YES
             LookupBaseTable:SENSITIVE = YES
             QueryDef:SCREEN-VALUE = (IF cLookupFlds NE "" THEN cLookupFlds ELSE QueryDef:SCREEN-VALUE)
             .
    WHEN "2" THEN
      ASSIGN LookupReturnField:SENSITIVE = NO
             LookupReturnField:SCREEN-VALUE = " "
             DropDownValueList:SENSITIVE = NO
             DropDownValueList:SCREEN-VALUE = ""
             QueryString:SENSITIVE = YES
             QueryDef:SENSITIVE = YES
             LookupDatasource:SENSITIVE = YES
             LookupDatabase:SENSITIVE = YES
             LookupBaseTable:SENSITIVE = YES
             QueryDef:SCREEN-VALUE = (IF cDropDownFlds NE "" THEN cDropDownFlds ELSE QueryDef:SCREEN-VALUE)
             .
    WHEN "3" THEN
      ASSIGN LookupReturnField:SENSITIVE = NO
             LookupReturnField:SCREEN-VALUE = " "
             DropDownValueList:SENSITIVE = YES
             QueryString:SCREEN-VALUE = ""
             QueryDef:SCREEN-VALUE = ""
             QueryString:SENSITIVE = NO
             QueryDef:SENSITIVE = NO
             LookupDatasource:SENSITIVE = NO
             LookupDatabase:SENSITIVE = NO
             LookupBaseTable:SENSITIVE = NO
             .
  END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforeSetDynFilter C-Win 
PROCEDURE BeforeSetDynFilter :
DEF INPUT PARAM ihQryOrBrwHandle AS HANDLE NO-UNDO.

DEF VAR cList AS CHAR NO-UNDO.
DEF VAR cSourceList AS CHAR NO-UNDO.

/* Remember to subscribe to this event: SUBSCRIBE TO "BeforeSetDynFilter" ANYWHERE. */

IF ihQryOrBrwHandle = oBrwLookup:BROWSE-HANDLE THEN DO WITH FRAME {&FRAME-NAME}:
  IF JBoxSession:Instance:CurrentWidget:NAME = "search_Datasourcename" THEN DO:
    FOR EACH tt_db
        WHERE (IF JBoxSession:Instance:CurrentWidget:SCREEN-VALUE NE "" THEN
                 tt_db.cSourceName = JBoxSession:Instance:CurrentWidget:SCREEN-VALUE
               ELSE TRUE)
        :       
      cList = cList + (IF cList NE "" THEN "," ELSE "") + tt_db.cLDBname.
      IF NOT CAN-DO(cSourceList,tt_db.cSourceName) THEN
        cSourceList = cSourceList + (IF cSourceList NE "" THEN "," ELSE "") + tt_db.cSourceName. 
    END.
    DatasourceName:LIST-ITEMS = cSourceList.
    LookupDatasource:LIST-ITEMS = cSourceList.
    RUN ValueChangedField("DatasourceName").
    RUN ValueChangedField("LookupDatasource").
    oBrwLookup:setGridFilterDropDownList("DatabaseName",cList,"").
  END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DeleteRecord C-Win 
PROCEDURE DeleteRecord :
DO WITH FRAME {&FRAME-NAME}:
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
    JBoxLookupDef:Instance:httLookup:EMPTY-TEMP-TABLE().
    JBoxLookupDef:Instance:httLookup:COPY-TEMP-TABLE(BUFFER ttLookup:HANDLE,NO,NO,YES).
    JBoxLookupDef:Instance:saveLookupTable().
  END.

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
IF AVAIL ttLookup THEN DO WITH FRAME {&FRAME-NAME}:
    DatasourceName:SCREEN-VALUE = ttLookup.DatasourceName.
    RUN ValueChangedField("DatasourceName").
     
    DatabaseName:SCREEN-VALUE = ttLookup.DatabaseName.
    RUN ValueChangedField("DatabaseName"). 
    
    TableName:SCREEN-VALUE = ttLookup.TableName.
    RUN ValueChangedField("TableName"). 
    
    LookupDatasource:SCREEN-VALUE = ttLookup.LookupDatasource.
    RUN ValueChangedField("LookupDatasource"). 
    
    LookupDatabase:SCREEN-VALUE = ttLookup.LookupDatabase.
    RUN ValueChangedField("LookupDatabase"). 

    LookupBaseTable:SCREEN-VALUE = ttLookup.LookupBaseTable.
    RUN ValueChangedField("LookupBaseTable"). 
    
  END.  

  ASSIGN cLookupFlds   = ""
         cDropDownFlds = "".
  
  RUN SUPER.
  IF oBrwLookup:isCurrent AND AVAIL ttLookup THEN DO WITH FRAME {&FRAME-NAME}:
    RsType:SCREEN-VALUE = (IF ttLookup.DropDownValueList NE "" THEN "3"
                           ELSE IF ttLookup.LookupReturnField NE "" THEN "1"
                           ELSE "2").
    RsType:SENSITIVE = NO.                       
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DropFileNotifyBrowse C-Win 
PROCEDURE DropFileNotifyBrowse :
DEF VAR ix         AS INT NO-UNDO.
  DEF VAR cFileNames AS CHAR   NO-UNDO.
  
  EMPTY TEMP-TABLE ttImport.
  DO ix = 1 TO SELF:NUM-DROPPED-FILES:
    cFileNames = cFileNames + (IF cFileNames NE "" THEN ";" ELSE "") + SELF:GET-DROPPED-FILE(ix).
    LEAVE.
  END.
  IF cFileNames NE "" THEN DO:
    INPUT FROM VALUE(cFileNames).
    SET ^.
    REPEAT:
      CREATE ttImport.
      IMPORT DELIMITER ";" ttImport NO-ERROR.
    END.
    INPUT CLOSE.
    FOR EACH ttImport:
      IF ttImport.FieldName = "" THEN DELETE ttImport.
      ELSE DO:
        FIND FIRST ttLookup
             WHERE ttLookup.DatasourceName = ttImport.DatasourceName
               AND ttLookup.DatabaseName   = ttImport.DatabaseName
               AND ttLookup.TableName      = ttImport.TableName
               AND ttLookup.SourceProcName = ttImport.SourceProcName
               AND ttLookup.FieldName      = ttImport.FieldName
             NO-ERROR.
        IF NOT AVAIL ttLookup THEN DO:
          CREATE ttLookup.
          BUFFER-COPY ttImport TO ttLookup.
        END.         
      END.        
    END.      
    JBoxLookupDef:Instance:httLookup:COPY-TEMP-TABLE(BUFFER ttLookup:HANDLE,NO,YES,YES).
    oBrwLookup:openQuery().
  END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EditRecord C-Win 
PROCEDURE EditRecord :
DO WITH FRAME {&FRAME-NAME}:
  oBrwLookup:BROWSE-HANDLE:SELECT-ROW(oBrwLookup:BROWSE-HANDLE:FOCUSED-ROW).
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
    RsType:SENSITIVE = YES.                       
    APPLY "value-changed" TO RsType.
  END.
  
  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.

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
  DISPLAY DatasourceName DatabaseName TableName FieldName SourceProcName RsType 
          LookupDatasource LookupDatabase LookupBaseTable LookupReturnField 
          QueryDef QueryString DropDownValueList 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  ENABLE btnSearchLookupTarget new_tbLookup btnSourceProcName edit_tbLookup 
         copy_tbLookup undo_tbLookup save_tbLookup delete_tbLookup 
         refresh_tbLookup excel_tbLookup DatasourceName DatabaseName TableName 
         FieldName SourceProcName RsType LookupDatasource LookupDatabase 
         LookupBaseTable LookupReturnField QueryDef QueryString 
         DropDownValueList btnQueryDef brwLookup tbLookup 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getQueryDef C-Win 
PROCEDURE getQueryDef :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihDsViewDs AS HANDLE NO-UNDO.

DEF VAR cQueryDef     AS CHAR NO-UNDO.
DEF VAR ix            AS INT  NO-UNDO.
DEF VAR cModQuerydef  AS CHAR NO-UNDO.
DEF VAR cBaseQuery    AS CHAR NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  cLookupFlds   = DYNAMIC-FUNCTION("getBuffersAndFields" IN SOURCE-PROCEDURE,YES).
  cDropDownFlds = DYNAMIC-FUNCTION("getBuffersAndFields" IN SOURCE-PROCEDURE,NO).
  cBaseQuery    = DYNAMIC-FUNCTION("getBaseQuery" IN SOURCE-PROCEDURE).
  
  IF cBaseQuery = "" THEN cBaseQuery = "WHERE TRUE".   
    
  IF RsType:SCREEN-VALUE = "2" AND NUM-ENTRIES(cDropDownFlds,";") > 3 THEN DO:
    IF NUM-ENTRIES(cDropDownFlds,";") > 5 THEN DO:
      MESSAGE "Max 4 fields allowed for drop-down: First 3 for concatinated view + the value"
      VIEW-AS ALERT-BOX.
      RETURN.
    END.
    DO ix = 1 TO NUM-ENTRIES(cDropDownFlds,";"):
      cModQuerydef = cModQuerydef + (IF cModQuerydef NE "" THEN
                                       (IF ix = 2 OR ix = NUM-ENTRIES(cDropDownFlds,";") THEN ";" ELSE "|")
                                     ELSE "")
                                  + ENTRY(ix,cDropDownFlds,";").
    END.
    cDropDownFlds = cModQuerydef. 
  END.
  
  APPLY "value-changed" TO RsType.  
  
  
  QueryString:SCREEN-VALUE = REPLACE(
                               DYNAMIC-FUNCTION("getQueryJoin" IN SOURCE-PROCEDURE,"","")
                               ,"WHERE FALSE",cBaseQuery).
                               
  APPLY "close" TO SOURCE-PROCEDURE.                             
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

IF CAN-DO(ihChild:INTERNAL-ENTRIES,"setAddQueryBuilderTools") THEN
  DYNAMIC-FUNCTION("setAddQueryBuilderTools" IN ihChild,THIS-PROCEDURE).


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

DEF VAR cDbList AS CHAR NO-UNDO.

//JBoxSchemaCache:Instance:getDbSchema(hDsSchema).

SUBSCRIBE TO "BeforeSetDynFilter" ANYWHERE.

DO WITH FRAME {&FRAME-NAME}:
  oBrwLookup = NEW JBoxBrowse(brwLookup:HANDLE,NO,hbttLookup).
//  oBrwLookup:buffersAndFields = "ttLookup;TableName;FieldName;SourceProcName;LookupQueryDef;LookupQueryString;LookupReturnField;DropDownValueList".
  oBrwLookup:BROWSE-HANDLE:DROP-TARGET = YES.
  oBrwLookup:baseQuery = "WHERE NOT sessionOnly".
  
  
  oFmLookup = NEW JBoxFieldMap(FRAME {&FRAME-NAME}:HANDLE).
  oFmLookup:updateFields = 'DatasourceName,DatabaseName,TableName,FieldName,SourceProcName,LookupDatabase,LookupDatasource,LookupBaseTable,LookupReturnField,QueryDef,QueryString,DropDownValueList'.

  oFmLookup:BROWSE-OBJECT = oBrwLookup.
  otbLookup = NEW JBoxToolbar(tbLookup:HANDLE).

  oBrwLookup:TOOLBAR-OBJECT = otbLookup.
  oFmLookup:TOOLBAR-OBJECT = otbLookup.
  
  DatasourceName:LIST-ITEMS = "".
  FOR EACH tt_db
      BREAK BY tt_db.cSourceName:
    IF FIRST-OF(tt_db.cSourceName) THEN
      DatasourceName:ADD-LAST(tt_db.cSourceName).
    cDbList = cDbList + (IF cDbList NE "" THEN "," ELSE "") + tt_db.cLDBname.      
  END.
  LookupDatasource:LIST-ITEMS = DatasourceName:LIST-ITEMS.

  oBrwLookup:baseQuery = "WHERE NOT sessionOnly". 

  JBoxLookupDef:Instance:setFieldDropDropDownValueList("ttLookup","DatasourceName",DatasourceName:LIST-ITEMS,THIS-PROCEDURE:FILE-NAME,YES).
  JBoxLookupDef:Instance:setFieldDropDropDownValueList("ttLookup","DatabaseName",cDbList,THIS-PROCEDURE:FILE-NAME,YES).
  
  JBoxLookupDef:Instance:assignFilterLookup(oBrwLookup).

  oBrwLookup:createGridFilter("").
  
  BUFFER ttLookup:COPY-TEMP-TABLE(JBoxLookupDef:Instance:httLookup,NO,YES,YES).
  
  oBrwLookup:setGridFilter("DatasourceName","=",JBoxLookupDef:Instance:CurrentDataSource).
  oBrwLookup:openQuery().
END.

oContainer:setAddResizeX("QueryDef,QueryString,DropDownValueList").
oContainer:setAddMoveX("btnQueryDef").
oContainer:initResize(800,100).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE LeaveOfFieldHandle C-Win 
PROCEDURE LeaveOfFieldHandle :
DEF INPUT PARAM ihField   AS HANDLE NO-UNDO.

IF ihField:MODIFIED THEN DO WITH FRAME {&FRAME-NAME}:
  CASE ihField:NAME:
/*    WHEN "LookupReturnField" THEN                                                       */
/*      QueryDef:SCREEN-VALUE = LookupBaseTable:SCREEN-VALUE + ";" + ihField:SCREEN-VALUE.*/
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

BuildTableLookup(TableName:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE NewRecord C-Win 
PROCEDURE NewRecord :
DEF VAR cDsName AS CHAR NO-UNDO.
  DEF VAR cDbName AS CHAR NO-UNDO.
  DEF VAR cLUDsName AS CHAR NO-UNDO.
  DEF VAR cLUDbName AS CHAR NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cDsName = DatasourceName:SCREEN-VALUE
           cDbName = DatabaseName:SCREEN-VALUE
           cLUDsName = LookupDatasource:SCREEN-VALUE
           cLUDbName = LookupDatabase:SCREEN-VALUE
           .
  END.
  RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
    IF cDsName NE ? THEN 
      ASSIGN DatasourceName:SCREEN-VALUE = cDsName 
             DatabaseName:SCREEN-VALUE = cDbName
             TableName:SCREEN-VALUE = ?
             FieldName:SCREEN-VALUE = ?
             .
    ELSE DO:         
      DatasourceName:SCREEN-VALUE = DatasourceName:ENTRY(1).
      RUN ValueChangedField("DatasourceName"). 
      DatabaseName:SCREEN-VALUE = DatabaseName:ENTRY(1).
      RUN ValueChangedField("DatabaseName"). 
    END.  
    IF cLUDsName NE ? THEN
      ASSIGN LookupDatasource:SCREEN-VALUE = cLUDsName 
             LookupDatabase:SCREEN-VALUE = cLUDbName
             LookupBaseTable:SCREEN-VALUE = ?
             .
    ELSE DO:         
      LookupDatasource:SCREEN-VALUE = LookupDatasource:ENTRY(1).
      RUN ValueChangedField("LookupDatasource"). 
      LookupDatabase:SCREEN-VALUE = LookupDatabase:ENTRY(1).
      RUN ValueChangedField("LookupDatabase"). 
    END.  
    
    RUN ValueChangedField("TableName").
    
    RsType:SENSITIVE = YES.                       
    
    APPLY "value-changed" TO RsType.
             
    APPLY "entry" TO FieldName.         
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RefreshRecord C-Win 
PROCEDURE RefreshRecord :
JBoxLookupDef:Instance:fetchLookupTable().
  BUFFER ttLookup:COPY-TEMP-TABLE(JBoxLookupDef:Instance:httLookup,NO,YES,YES).
  oBrwLookup:openQuery().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveRecord C-Win 
PROCEDURE SaveRecord :
  DEF VAR cTbState AS CHAR NO-UNDO.
  
  cTbState = otbLookup:objectState.
  
  IF CAN-DO("new,copy",otbLookup:objectState) THEN DO WITH FRAME {&FRAME-NAME}:
    IF CAN-FIND(FIRST ttLookup
                WHERE ttLookup.DatabaseName = DatabaseName:SCREEN-VALUE
                  AND ttLookup.DatasourceName = DatasourceName:SCREEN-VALUE
                  AND ttLookup.TableName = (IF TableName:SCREEN-VALUE = ? THEN "" ELSE TableName:SCREEN-VALUE)
                  AND ttLookup.FieldName = FieldName:SCREEN-VALUE
                  AND ttLookup.SourceProcName = SourceProcName:SCREEN-VALUE
                  AND NOT ttLookup.sessionOnly) THEN DO:
      MESSAGE "Lookup definition already exists"
      VIEW-AS ALERT-BOX.
      RETURN ERROR.
    END.  
  END.
  
  IF RsType:SCREEN-VALUE = "1" AND (LookupReturnField:SCREEN-VALUE = ? OR LookupReturnField:SCREEN-VALUE = "") THEN DO:
    MESSAGE "Look-up requires a return-field" 
    VIEW-AS ALERT-BOX.
    RETURN ERROR.
  END.
  
RUN SUPER.
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH ttLookup WHERE ttLookup.LookupReturnField = ?: ttLookup.LookupReturnField = "". END.
    JBoxLookupDef:Instance:httLookup:COPY-TEMP-TABLE(BUFFER ttLookup:HANDLE,NO,YES,YES).
    JBoxLookupDef:Instance:saveLookupTable().
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValueChangedField C-Win 
PROCEDURE ValueChangedField :
DEF INPUT PARAM icFieldName   AS CHAR NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  CASE icFieldName:
    WHEN "DatasourceName" THEN DO:
      Databasename:LIST-ITEMS = "".
      FOR EACH tt_db WHERE tt_db.cSourceName = DatasourceName:SCREEN-VALUE:
        DatabaseName:ADD-LAST(tt_db.cLDBname).
      END.  
    END.   
    WHEN "DatabaseName" THEN DO:
      TableName:LIST-ITEMS = "".
      FOR EACH tt_file 
          WHERE tt_file.cLDBname = DatabaseName:SCREEN-VALUE
            AND tt_file.cTbl-Type = "T"
          BY tt_file.cFile-Name:
        TableName:ADD-LAST(tt_file.cFile-Name).
      END.  
      TableName:ADD-FIRST("").
    END.   
    WHEN "TableName" THEN DO:
      FieldName:LIST-ITEMS = "".
      IF TableName:SCREEN-VALUE NE ? THEN
        FOR EACH tt_db
            WHERE tt_db.cSourceName = DatasourceName:SCREEN-VALUE
              AND tt_db.cLDBname = DatabaseName:SCREEN-VALUE
           ,EACH tt_file
                 WHERE tt_file.iDbNum = tt_db.iDbNum
                   AND tt_file.cFile-Name = TableName:SCREEN-VALUE
           ,EACH tt_field WHERE tt_field.iFileNum = tt_file.iFileNum
            BY tt_field.cField-Name:
          FieldName:ADD-LAST(tt_field.cField-Name).
        END.
      ELSE    
        FOR EACH tt_db
            WHERE tt_db.cSourceName = DatasourceName:SCREEN-VALUE
              AND tt_db.cLDBname = DatabaseName:SCREEN-VALUE
           ,EACH tt_file
                 WHERE tt_file.iDbNum = tt_db.iDbNum
                   AND tt_file.cTbl-Type = "T"
           ,EACH tt_field WHERE tt_field.iFileNum = tt_file.iFileNum
            BREAK BY tt_field.cField-Name:
          IF FIRST-OF(tt_field.cField-Name) THEN    
            FieldName:ADD-LAST(tt_field.cField-Name).
        END.
    END.   

    WHEN "LookupDatasource" THEN DO:
      LookupDatabase:LIST-ITEMS = "".
      FOR EACH tt_db WHERE tt_db.cSourceName = LookupDatasource:SCREEN-VALUE:
        LookupDatabase:ADD-LAST(tt_db.cLDBname).
      END.  
    END.   
    WHEN "LookupDatabase" THEN DO:
      LookupBaseTable:LIST-ITEMS = "".
      FOR EACH tt_file 
          WHERE tt_file.cLDBname = LookupDatabase:SCREEN-VALUE
            AND tt_file.cTbl-Type = "T"
          BY tt_file.cFile-Name:
        LookupBaseTable:ADD-LAST(tt_file.cFile-Name).
      END.  
      LookupBaseTable:ADD-FIRST("").
    END.   
    WHEN "LookupBaseTable" THEN DO:
      LookupReturnField:LIST-ITEMS = "".
      FOR EACH tt_db
          WHERE tt_db.cSourceName = DatasourceName:SCREEN-VALUE
            AND tt_db.cLDBname = DatabaseName:SCREEN-VALUE
         ,EACH tt_file
               WHERE tt_file.iDbNum = tt_db.iDbNum
                 AND tt_file.cFile-Name = LookupBaseTable:SCREEN-VALUE
         ,EACH tt_field WHERE tt_field.iFileNum = tt_file.iFileNum
          BY tt_field.cField-Name:
        LookupReturnField:ADD-LAST(tt_field.cField-Name).
      END.
      QueryDef:SCREEN-VALUE = LookupBaseTable:SCREEN-VALUE.
      QueryString:SCREEN-VALUE = "WHERE TRUE".
    END.
      
         
  END CASE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION BuildTableLookup C-Win 
FUNCTION BuildTableLookup RETURNS LOGICAL
  ( INPUT icTable AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:
  ------------------------------------------------------------------------------*/
  DEF VAR cFieldMatch      AS CHAR NO-UNDO.
  DEF VAR cParentKeyFields AS CHAR NO-UNDO.
  DEF VAR ix               AS INT NO-UNDO. 
  DEF VAR cParentKey       AS CHAR NO-UNDO.
  DEF VAR cChildKey        AS CHAR NO-UNDO.
  DEF VAR cMatchType       AS CHAR NO-UNDO.
  DEF VAR cMatchFields     AS CHAR NO-UNDO.
  DEF VAR cMaxMatch        AS CHAR NO-UNDO.
  DEF VAR iMaxMatch        AS INT  NO-UNDO.
  DEF VAR cIdxFlds         AS CHAR NO-UNDO.

  EMPTY TEMP-TABLE ttTableLookup.
  EMPTY TEMP-TABLE ttKeyMatch.
  
  DEF BUFFER bttKeyMatch FOR ttKeyMatch.
  DEF BUFFER bttIndex    FOR tt_index.
  
  DO WITH FRAME {&FRAME-NAME}:
    FOR EACH tt_db
             WHERE tt_db.cSourceName = DatasourceName:SCREEN-VALUE
       ,EACH tt_file
             WHERE tt_file.iDbNum = tt_db.iDbNum
               AND (IF icTable NE "" AND icTable NE ? THEN tt_file.cFile-Name = icTable ELSE TRUE)
       ,EACH tt_index
             WHERE tt_index.iFileNum = tt_file.iFileNum
               AND tt_index.bActive
       ,EACH tt_index-field 
             WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
               AND tt_index-field.iFileNum = tt_file.iFileNum
               AND tt_index-field.cFieldName = FieldName:SCREEN-VALUE
//               AND tt_index-field.cFieldName NE "prrowid"
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
        WHERE tt_db.cSourceName = DatasourceName:SCREEN-VALUE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCombos C-Win 
FUNCTION setCombos RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
  DEF VAR cDbName   AS CHAR NO-UNDO.
  DEF VAR cTbName   AS CHAR NO-UNDO.
  DEF VAR cLUDbName AS CHAR NO-UNDO.
  DEF VAR cLUTbName AS CHAR NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN cDbName = DatabaseName:SCREEN-VALUE
           cTbName = TableName:SCREEN-VALUE
           cLUDbName = LookupDatabase:SCREEN-VALUE
           cLUTbName = LookupBaseTable:SCREEN-VALUE
           .
    RUN ValueChangedField("DatasourceName"). 
    RUN ValueChangedField("DatabaseName"). 
    RUN ValueChangedField("LookupDatasource"). 
    RUN ValueChangedField("LookupDatabase"). 
    ASSIGN DatabaseName:SCREEN-VALUE = cDbName
           TableName:SCREEN-VALUE = cTbName
           LookupDatabase:SCREEN-VALUE = cLUDbName
           LookupBaseTable:SCREEN-VALUE = cLUTbName
           .
  END.

  RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

