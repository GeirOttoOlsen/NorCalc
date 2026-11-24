
/*------------------------------------------------------------------------
    File        : tt_viewds.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Tue Jul 25 18:43:23 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF TEMP-TABLE ttViewDs NO-UNDO
  FIELD ViewDsName           AS CHAR FORMAT "x(40)"  LABEL "Name"
  FIELD SourceName           AS CHAR FORMAT "x(32)"  LABEL "Data source"
  FIELD SourceType           AS CHAR 
  FIELD BaseDb               AS CHAR FORMAT "x(32)"  LABEL "Base db"
  FIELD BaseTable            AS CHAR FORMAT "x(32)"  LABEL "Base table"
  FIELD ViewDsDesc           AS CHAR FORMAT "x(100)" LABEL "Desc"
  FIELD BaseTableId          AS CHAR  
  FIELD ViewDsId             AS CHAR FORMAT "x(40)"  LABEL "Id"
  FIELD BaseQuery            AS CHAR 
  FIELD RowIdent1            AS CHAR 
  FIELD ConnectionInfo       AS CHAR FORMAT "x(20)" LABEL "Db connection"
  FIELD SchemaStatus         AS CHAR FORMAT "x(12)" LABEL "Db schema"
  FIELD ViewFileName         AS CHAR
  FIELD ScriptType           AS CHAR
  FIELD ScriptName           AS CHAR
  FIELD ScriptOutputDir      AS CHAR
  FIELD ScriptOutputType     AS CHAR
  FIELD ScriptLogFile        AS CHAR
  FIELD ScriptFilterId       AS CHAR  // not i use for view but here for buffer-copy
  FIELD ScriptFilterName     AS CHAR  // not i use for view but here for buffer-copy
  FIELD queryJoin            AS CHAR
  FIELD joinBuffersAndFields AS CHAR 
  FIELD preScanQueries       AS CHAR
  FIELD altPrimaryBufferList AS CHAR
  FIELD preScanBaseQuery     AS CHAR // sql not exists 
  FIELD buffersAndFields     AS CHAR
  FIELD dataFjordCatalog     AS CHAR
  FIELD hTempTable           AS HANDLE
  FIELD cTempTableFileName   AS CHAR
  INDEX idxViewId IS PRIMARY UNIQUE ViewDsId
  INDEX idxNameDb SourceName BaseTable
  .

DEF TEMP-TABLE ttViewDsTable NO-UNDO
  FIELD ViewDsId             AS CHAR  
  FIELD ViewDsDb             AS CHAR
  FIELD ViewDsTable          AS CHAR
  FIELD ViewDsParentDb       AS CHAR
  FIELD ViewDsParentTable    AS CHAR
  FIELD ViewDsTableQuery     AS CHAR
  FIELD ViewDsTableJoinType  AS CHAR
  FIELD ViewDsTableOuterJoin AS LOG
  FIELD ViewDsTableLevel     AS INT
  FIELD ViewDsTableNotExist  AS LOG
  FIELD ViewDsTableFirstLast AS CHAR
  FIELD SourceName           AS CHAR
  FIELD SourceType           AS CHAR 
  FIELD ParentSourceName     AS CHAR
  FIELD ParentSourceType     AS CHAR
  FIELD queryJoin            AS CHAR
  FIELD joinBuffersAndFields AS CHAR
  FIELD preScanQueries       AS CHAR
  FIELD altPrimaryBufferList AS CHAR
  FIELD preScanBaseQuery     AS CHAR // sql not exists 
  FIELD buffersAndFields     AS CHAR
  FIELD hTempTable           AS HANDLE
  FIELD cTempTableFileName   AS CHAR
  FIELD RowIdent1            AS CHAR
  INDEX idxViewId ViewDsId ViewDsTable
  .    

DEF TEMP-TABLE ttViewDsField NO-UNDO
  FIELD ViewDsId            AS CHAR  
  FIELD ViewDsDb            AS CHAR
  FIELD ViewDsFieldSeq      AS INT  FORMAT "->>>9" LABEL "Seq"
  FIELD ViewDsTable         AS CHAR FORMAT "x(32)" LABEL "Table"
  FIELD ViewDsFieldName     AS CHAR FORMAT "x(32)" LABEL "Field"
  FIELD ViewDsFieldLabel    AS CHAR FORMAT "x(30)" LABEL "Label"
  FIELD ViewDsFieldFormat   AS CHAR FORMAT "x(20)" LABEL "Format"
  FIELD ViewDsFieldType     AS CHAR FORMAT "x(12)" LABEL "Type"
  FIELD ViewDsFieldHidden   AS LOG  FORMAT "Yes/No" LABEL "Hidden"
  FIELD ViewDsFieldFunction AS CHAR FORMAT "x(120)" LABEL "Function"
  FIELD ViewDsFieldIndexed  AS LOG  FORMAT "*/" LABEL "Indexed"
  FIELD SourceName          AS CHAR
  FIELD SourceType          AS CHAR 
  FIELD RowIdent1           AS CHAR
  INDEX idxViewId ViewDsId ViewDsTable ViewDsFieldName
  .    

DEF TEMP-TABLE ttJBoxUserSetting NO-UNDO
    FIELD ViewDsId            AS CHAR  
/*    FIELD cContext AS character FORMAT 'x(30)' LABEL 'Context'   */
/*    FIELD cCreatedBy AS character FORMAT 'X(8)' LABEL 'By'       */
/*    FIELD cJBoxUserId AS character FORMAT 'x(30)' LABEL 'User id'*/
/*    FIELD cModifiedBy AS character FORMAT 'X(8)' LABEL 'By'      */
    FIELD cObjectName AS character FORMAT 'x(30)' LABEL 'Object name'
    FIELD cSetting AS character FORMAT 'x(50)' LABEL 'Setting'
    FIELD cSettingName AS character FORMAT 'x(30)' LABEL 'Setting name'
/*    FIELD cSourceFile AS character FORMAT 'x(30)' LABEL 'Source file'              */
/*    FIELD dCreated AS date FORMAT '99/99/9999' LABEL 'Created'                     */
/*    FIELD dModified AS date FORMAT '99/99/9999' LABEL 'Modified'                   */
/*    FIELD iJBoxUserSettingId AS integer FORMAT '->,>>>,>>9' LABEL 'User setting id'*/
    FIELD ScriptType       AS CHAR
    FIELD ScriptName       AS CHAR
    FIELD ScriptOutputDir  AS CHAR
    FIELD ScriptOutputType AS CHAR
    FIELD ScriptLogFile    AS CHAR
    FIELD ScriptFilterId   AS CHAR
    FIELD ScriptFilterName AS CHAR
    .
    
DEF DATASET dsViewDs FOR ttViewDs,ttViewDsTable,ttViewDsField,ttJBoxUserSetting.
DEF VAR hdsViewDs AS HANDLE NO-UNDO.
