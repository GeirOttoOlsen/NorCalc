
/*------------------------------------------------------------------------
    File        : tt_cloudapp.i
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Wed May 29 16:00:23 CEST 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF TEMP-TABLE ttCloudApp NO-UNDO
    FIELD cloudAppId        AS CHAR
    FIELD appName           AS CHAR FORMAT "x(40)"   LABEL "Name"
    FIELD appDescription    AS CHAR FORMAT "x(100)"  LABEL "Desc"
    FIELD baseEndpoint      AS CHAR FORMAT "x(100)"  LABEL "Base endpoint"
    FIELD baseTable         AS CHAR FORMAT "x(32)"   LABEL "Base table"
    FIELD tokenEndpoint     AS CHAR FORMAT "x(100)"  LABEL "Token endpoint"
    FIELD connectionInfo    AS CHAR FORMAT "x(20)"   LABEL "Endpoint connection"
    FIELD tokenId           AS CHAR
    FIELD cloudAppFileName  AS CHAR
    FIELD RowIdent1         AS CHAR 
    INDEX idxCloudAppId IS UNIQUE PRIMARY cloudAppId
    . 
 
DEF TEMP-TABLE ttCloudAppTable NO-UNDO
    FIELD cloudAppId        AS CHAR
    FIELD cloudAppTable     AS CHAR
    FIELD appTableEndpoint  AS CHAR
    FIELD RowIdent1         AS CHAR
    INDEX idxAppTable cloudAppId cloudAppTable 
    .

DEF TEMP-TABLE ttCloudAppField NO-UNDO    
    FIELD cloudAppId        AS CHAR
    FIELD cloudAppTable     AS CHAR
    FIELD cloudAppFieldName AS CHAR FORMAT "x(32)"  LABEL "Field"
    FIELD fieldLabel        AS CHAR FORMAT "x(30)"  LABEL "Label"
    FIELD fieldFormat       AS CHAR FORMAT "x(20)"  LABEL "Format"
    FIELD fieldType         AS CHAR FORMAT "x(12)"  LABEL "Type"
    FIELD fieldFunction     AS CHAR FORMAT "x(120)" LABEL "Function"
    FIELD RowIdent1         AS CHAR
    INDEX idxAppField cloudAppId cloudAppTable cloudAppFieldName
    .
    
DEF TEMP-TABLE ttJBoxUserSetting NO-UNDO
    FIELD ViewDsId            AS CHAR  
    FIELD cObjectName AS character FORMAT 'x(30)' LABEL 'Object name'
    FIELD cSetting AS character FORMAT 'x(50)' LABEL 'Setting'
    FIELD cSettingName AS character FORMAT 'x(30)' LABEL 'Setting name'
    FIELD ScriptType       AS CHAR
    FIELD ScriptName       AS CHAR
    FIELD ScriptOutputDir  AS CHAR
    FIELD ScriptOutputType AS CHAR
    FIELD ScriptLogFile    AS CHAR
    FIELD ScriptFilterId   AS CHAR
    FIELD ScriptFilterName AS CHAR
    .
    
DEF DATASET dsCloudApp FOR ttCloudApp,ttCloudAppTable,ttCloudAppField,ttJBoxUserSetting.
    
DEF VAR hdsCloudApp AS HANDLE NO-UNDO.
