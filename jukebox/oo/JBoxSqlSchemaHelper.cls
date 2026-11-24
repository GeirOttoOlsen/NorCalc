 
 /*------------------------------------------------------------------------
    File        : JBoxSqlSchemaHelper
    Purpose     : Either get full schema (for client) or build (incremental) cache for run-time.
    Syntax      : 
    Description : 
    Author(s)   : bryhasleadm
    Created     : Thu Oct 20 14:50:13 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING oo.JBoxSqlQueryHelper FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxSqlSchemaHelper: 

  /* Start temp-tables used for transport : */
  DEF TEMP-TABLE ttSqlSchema NO-UNDO
    FIELD Db_Name          AS CHAR 
    FIELD Table_Type       AS CHAR FORMAT "x(12)"
    FIELD Table_Name       AS CHAR FORMAT "x(40)"
    FIELD Ordinal_Position AS INT  
    FIELD Column_Name      AS CHAR FORMAT "x(32)"
    FIELD Data_Type        AS CHAR FORMAT "x(20)"
    FIELD Column_Default   AS CHAR FORMAT "x(40)"
    FIELD Character_Maximum_Length AS INT64 FORMAT "->>>,>>>,>>9"
    FIELD RowCount         AS INT
    FIELD ColNameLength    AS INT
    FIELD OETableName      AS CHAR FORMAT "x(32)"
    FIELD OEFieldName      AS CHAR FORMAT "x(32)"
    FIELD OEdataType       AS CHAR FORMAT "x(10)"
    FIELD OEformat         AS CHAR FORMAT "x(25)"
    FIELD OElabel          AS CHAR FORMAT "x(32)"
    FIELD OEvalmsg         AS CHAR FORMAT "x(50)"
    FIELD cDataSourceType  AS CHAR
    . 

  DEF TEMP-TABLE ttSqlIndex NO-UNDO
    FIELD Table_name       AS CHAR
    FIELD Column_name      AS CHAR
    FIELD Index_name       AS CHAR
    FIELD Unique_Index     AS CHAR
    FIELD Index_seq        AS INT
    .
      
  DEF VAR hbttSqlIndex AS HANDLE NO-UNDO.

  DEF DATASET dsSqlSchema FOR ttSqlSchema, ttSqlIndex.
  DEF VAR hDsSqlSchema AS HANDLE NO-UNDO.

  DEF TEMP-TABLE ttSqlColumns NO-UNDO
      FIELD Column_Name      AS CHAR
      FIELD Table_Catalog    AS CHAR 
      FIELD Table_Schema     AS CHAR 
      FIELD Data_Type        AS CHAR      
      FIELD ColNameLength    AS INT
      FIELD OETableName      AS CHAR FORMAT "x(32)"
      FIELD OEFieldName      AS CHAR FORMAT "x(32)"
      FIELD OEdataType       AS CHAR FORMAT "x(10)"
      FIELD OEformat         AS CHAR FORMAT "x(25)"
      FIELD OElabel          AS CHAR FORMAT "x(32)"
      FIELD OEvalmsg         AS CHAR FORMAT "x(50)"
      .
  DEF VAR hbttSqlColumns AS HANDLE NO-UNDO.

  DEF TEMP-TABLE ttSqlPrimaryKey NO-UNDO
      FIELD Table_Name     AS CHAR
      FIELD Column_Name    AS CHAR
      .
  DEF VAR hbttSqlPrimaryKey AS HANDLE NO-UNDO.

  DEF TEMP-TABLE ttSqlReadCount NO-UNDO
      FIELD ReadCount AS INT
      .
  DEF VAR hbttSqlReadCount AS HANDLE NO-UNDO.

  /* end transport tables - start cache tables - first for client-side (or server query object) */

  DEF TEMP-TABLE tt_ds NO-UNDO
      FIELD cDataSourceName AS CHAR
      FIELD cDataSourceType AS CHAR
      FIELD cLDBname        AS CHAR
      .
  DEF VAR hbtt_ds AS HANDLE NO-UNDO.    

  DEF TEMP-TABLE tt_file NO-UNDO
      FIELD cFile-Name      AS CHAR
      FIELD cTbl-Type       AS CHAR
      FIELD cLDBname        AS CHAR
      FIELD cType           AS CHAR /* table / view */
      FIELD iFileNum        AS INT
      FIELD cDataSourceType AS CHAR
      FIELD cSqlTableName   AS CHAR
      INDEX FileNum iFileNum
      INDEX idxDbName cLDBname.
      
  DEF TEMP-TABLE tt_field NO-UNDO
      FIELD cField-Name   AS CHAR
      FIELD cData-Type    AS CHAR
      FIELD cFormat       AS CHAR
      FIELD cLabel        AS CHAR
      FIELD iOrder        AS INT
      FIELD iExtent       AS INT
      FIELD iFileNum      AS INT
      FIELD iFieldNum     AS INT
      FIELD cIndexName    AS CHAR
      FIELD cIndexType    AS CHAR
      FIELD iIndexSeq     AS INT
      FIELD cSqlFieldName AS CHAR
      FIELD cSqlDataType  AS CHAR
      INDEX FileNum iFileNum
      INDEX FieldNum iFieldNum.
      
  /* cache for server-side JBoxSqlQueryHelper: */     

  DEF TEMP-TABLE ttAllSqlPrimaryKeys NO-UNDO
      FIELD DataSourceName AS CHAR
      FIELD Table_Name     AS CHAR
      FIELD Column_Name    AS CHAR
      .
  DEF VAR hbttAllSqlPrimaryKeys AS HANDLE NO-UNDO.    

  DEF TEMP-TABLE ttAllSqlColumns NO-UNDO
      FIELD DataSourceName   AS CHAR
      FIELD Table_Name       AS CHAR
      FIELD Column_Name      AS CHAR
      FIELD Table_Catalog    AS CHAR 
      FIELD Table_Schema     AS CHAR 
      FIELD Data_Type        AS CHAR      
      FIELD ColNameLength    AS INT
      FIELD OETableName      AS CHAR FORMAT "x(32)"
      FIELD OEFieldName      AS CHAR FORMAT "x(32)"
      FIELD OEdataType       AS CHAR FORMAT "x(10)"
      FIELD OEformat         AS CHAR FORMAT "x(25)"
      FIELD OElabel          AS CHAR FORMAT "x(32)"
      FIELD OEvalmsg         AS CHAR FORMAT "x(50)"
      .

  DEF TEMP-TABLE ttAllSqlIndexCols NO-UNDO
      FIELD DataSourceName   AS CHAR
      FIELD Table_name       AS CHAR
      FIELD Column_name      AS CHAR
      FIELD Index_name       AS CHAR
      FIELD Unique_Index     AS CHAR
      FIELD Index_seq        AS INT
      .

  DEF TEMP-TABLE ttNonUniqueKeyTable NO-UNDO
      FIELD DataSourceName   AS CHAR
      FIELD Table_Name       AS CHAR
      FIELD UniqueColumns    AS CHAR
      FIELD RecordCount      AS INT // If this has changed we need to re-evaluate what are then unique columns
      .
  
  DEF TEMP-TABLE ttTablePrimaryKeyColumns NO-UNDO  // Temporary - used in getPrimaryKeyColumns
      FIELD Column_Name AS CHAR.

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxSqlSchemaHelper NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxSqlSchemaHelper().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEF PUBLIC PROPERTY hbttSqlSchema AS HANDLE NO-UNDO GET. PROTECTED SET.
  
  DEF PUBLIC PROPERTY sqlSchemaMessage AS CHAR NO-UNDO GET. PROTECTED SET.

  DEF PUBLIC PROPERTY duplicateTtFields AS CHAR NO-UNDO GET. PROTECTED SET.
  
  DEF PUBLIC PROPERTY sqlQueryHelper AS JBoxSqlQueryHelper NO-UNDO GET. SET.
  
  DEF VAR cSqlDbName AS CHAR NO-UNDO.
  DEF VAR bCallAppserver AS LOG NO-UNDO.
  DEF VAR hbttTablePrimaryKeyColumns AS HANDLE NO-UNDO.
      
  CONSTRUCTOR PUBLIC JBoxSqlSchemaHelper ():
    DEF VAR hAps AS HANDLE NO-UNDO.
    DEF VAR cServerModeYes AS CHAR NO-UNDO.
    
    SUPER ().
    hbttSqlSchema = BUFFER ttSqlSchema:HANDLE.
    hbttSqlIndex = BUFFER ttSqlIndex:HANDLE.
    hbttSqlPrimaryKey = BUFFER ttSqlPrimaryKey:HANDLE.    
    hbttSqlColumns = BUFFER ttSqlColumns:HANDLE.
    hDsSqlSchema = DATASET dsSqlSchema:HANDLE.
    hbttSqlReadCount = BUFFER ttSqlReadCount:HANDLE.
    hbttTablePrimaryKeyColumns = BUFFER ttTablePrimaryKeyColumns:HANDLE.
    hbtt_ds = BUFFER tt_ds:HANDLE.
    hbttAllSqlPrimaryKeys = BUFFER ttAllSqlPrimaryKeys:HANDLE.
    cServerModeYes = DYNAMIC-FUNCTION("getAttribute",SESSION,"serverMode") NO-ERROR.
    IF cServerModeYes NE "yes" THEN DO:
      hAps = DYNAMIC-FUNCTION("getAppserviceHandle") NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
        bCallAppserver = (hAps NE ? AND hAps NE SESSION) OR (PROGRESS = "full" AND SESSION:CLIENT-TYPE = "4GLclient").
      ELSE bCallAppserver = NO.
    END.
    ELSE bCallAppserver = NO.
        
    sqlQueryHelper = NEW JBoxSqlQueryHelper().
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID createOESchema( INPUT icTableList AS CHAR ):
    
    DEF VAR cDfFile AS CHAR NO-UNDO.
    DEF VAR bOk     AS LOG  NO-UNDO.
    
    SYSTEM-DIALOG GET-FILE cDfFile USE-FILENAME UPDATE bOk.
    IF bOk THEN DO:
      
      OUTPUT TO VALUE(cDfFile).
      FOR EACH ttSqlSchema
          WHERE ttSqlSchema.OEFieldName NE ""
            AND CAN-DO(icTableList,ttSqlSchema.Table_Name)
          BREAK BY ttSqlSchema.Table_Name
                BY ttSqlSchema.Ordinal_Position
          :
        IF FIRST-OF(ttSqlSchema.Table_Name) THEN
          PUT UNFORMATTED 'ADD TABLE "' ttSqlSchema.Table_Name '"' SKIP(1).
        
         
        PUT UNFORMATTED 'ADD FIELD "' ttSqlSchema.OEFieldName '" OF "' ttSqlSchema.Table_Name '" AS ' ttSqlSchema.OEdataType SKIP.
        PUT UNFORMATTED '  FORMAT "' ttSqlSchema.OEformat '"' SKIP.
        PUT UNFORMATTED '  LABEL "' ttSqlSchema.OElabel '"' SKIP.
        IF ttSqlSchema.OEvalmsg NE "" THEN
          PUT UNFORMATTED '  VALMSG "' ttSqlSchema.OEvalmsg '"' SKIP(1).
        ELSE PUT SKIP(1).
      END.
      
      OUTPUT CLOSE.     
      OS-COMMAND NO-WAIT VALUE("notepad " + cDfFile).          
    END.
    
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Figure out which columns that make up a unique row for a mssql table that don't have primary or unique constraint or unique index  
   Notes:   Server use ONLY - mssql ONLY
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED CHARACTER findUniqueColumns( INPUT icSourceName  AS CHAR
                                               ,INPUT icTableName   AS CHAR
                                               ,INPUT icTableSchema AS CHAR
                                               ,INPUT iiRecordCount AS INT):
    
    DEF VAR ocReturn    AS CHAR NO-UNDO.
    DEF VAR bOk         AS LOG  NO-UNDO.
    DEF VAR cFieldExpr  AS CHAR NO-UNDO.
    DEF VAR cFields     AS CHAR NO-UNDO.
    DEF VAR cAddedFlds  AS CHAR NO-UNDO.
    DEF VAR ix          AS INT  NO-UNDO.
    DEF VAR cSqlTable   AS CHAR NO-UNDO.
    
    DEF BUFFER ttAllSqlColumns FOR ttAllSqlColumns.
    
    cSqlTable = getABLTableSQLName(icSourceName, realTable(icTableName)).
    
/*    DEF VAR hbttAllSqlColumns AS HANDLE NO-UNDO.      */
/*    hbttAllSqlColumns = BUFFER ttAllSqlColumns:HANDLE.*/
/*    RUN toexcelviafile.p (hbttAllSqlColumns,-2).      */
    
    // Test #1: Check if there is a unique identifier column 
    FOR EACH ttAllSqlColumns
        WHERE ttAllSqlColumns.DataSourceName = icSourceName 
          AND ttAllSqlColumns.Table_Name     = icTableName
          AND ttAllSqlColumns.Data_Type      = "uniqueidentifier"
          :
        ASSIGN cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ttAllSqlColumns.Column_name
               cFieldExpr = cFieldExpr + (IF cFieldExpr NE "" THEN "," ELSE "") + '"' + ttAllSqlColumns.Table_name + '"."' + ttAllSqlColumns.Column_name + '"'.
    END.              
    IF cFields NE "" THEN DO:
      EMPTY TEMP-TABLE ttSqlReadCount.
      IF NUM-ENTRIES(cFields) > 1 THEN 
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT CONCAT(" + cFieldExpr + ")) AS ReadCount" 
                                                + " FROM " + icTableSchema + '"' + cSqlTable + '"'
                  ,hbttSqlReadCount).
      ELSE                            
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT " + cFieldExpr + ") AS ReadCount" 
                                + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                  ,hbttSqlReadCount).
      FIND FIRST ttSqlReadCount NO-ERROR.
      IF AVAIL ttSqlReadCount AND ttSqlReadCount.ReadCount = iiRecordCount THEN RETURN cFields.
    END.  
    
    // Test #2 - check if combined indexes are unique 
    IF NOT CAN-FIND(FIRST ttAllSqlIndexCols WHERE ttAllSqlIndexCols.DataSourceName = icSourceName AND ttAllSqlIndexCols.Table_name = icTableName) THEN DO:
      EMPTY TEMP-TABLE ttSqlIndex. 
      IF getSqlData(icSourceName
             + "|SELECT Column_Name = col.name,Table_Name = t.name,Index_Name = ind.name,Unique_Index = ind.is_unique,Index_seq = ic.key_ordinal FROM 
               sys.indexes ind 
               INNER JOIN sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
               INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
               INNER JOIN sys.tables t ON ind.object_id = t.object_id WHERE t.name = '" + cSqlTable + "'" 
             ,hbttSqlIndex) THEN
        FOR EACH ttSqlIndex:
          CREATE ttAllSqlIndexCols.
          BUFFER-COPY ttSqlIndex TO ttAllSqlIndexCols.
          ASSIGN ttAllSqlIndexCols.DataSourceName = icSourceName
                 ttAllSqlIndexCols.Table_name = icTableName.
        END.  
    END.
    
    FOR EACH ttAllSqlIndexCols
        WHERE ttAllSqlIndexCols.DataSourceName = icSourceName 
          AND ttAllSqlIndexCols.Table_name = icTableName
        :
      ASSIGN cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ttAllSqlIndexCols.Column_name
             cFieldExpr = cFieldExpr + (IF cFieldExpr NE "" THEN "," ELSE "") + '"' + ttAllSqlIndexCols.Table_name + '"."' + ttAllSqlIndexCols.Column_name + '"'.    
    END.
    IF cFields NE "" THEN DO:
      EMPTY TEMP-TABLE ttSqlReadCount.
      getSqlData(icSourceName + "|SELECT COUNT(DISTINCT CONCAT(" + cFieldExpr + ")) AS ReadCount" 
                              + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                ,hbttSqlReadCount).
                                
      FIND FIRST ttSqlReadCount NO-ERROR.
      IF AVAIL ttSqlReadCount AND ttSqlReadCount.ReadCount = iiRecordCount THEN RETURN cFields.
    END.  
    
    // Test #3: Add some fields.. 
    FOR EACH ttAllSqlColumns
        WHERE ttAllSqlColumns.DataSourceName = icSourceName 
          AND ttAllSqlColumns.Table_Name = icTableName
          AND (ttAllSqlColumns.Data_Type MATCHES "*char")
          AND (ttAllSqlColumns.Column_Name MATCHES "*id" 
               OR ttAllSqlColumns.Column_Name MATCHES "*num*" 
               OR ttAllSqlColumns.Column_Name MATCHES "*no"
               OR ttAllSqlColumns.Column_Name MATCHES "*nr"
               ):
      IF NOT CAN-DO(cFields,ttAllSqlColumns.Column_Name) THEN           
        ASSIGN cAddedFlds = cAddedFlds + (IF cAddedFlds NE "" THEN "," ELSE "") + ttAllSqlColumns.Column_Name      
               cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ttAllSqlColumns.Column_name
               cFieldExpr = cFieldExpr + (IF cFieldExpr NE "" THEN "," ELSE "") + '"' + ttAllSqlColumns.Table_name + '"."' + ttAllSqlColumns.Column_name + '"'.
    END.              
    IF cAddedFlds NE "" THEN DO:
      EMPTY TEMP-TABLE ttSqlReadCount.
      IF NUM-ENTRIES(cFields) > 1 THEN  
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT CONCAT(" + cFieldExpr + ")) AS ReadCount" 
                                + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                  ,hbttSqlReadCount).
      ELSE                             
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT " + cFieldExpr + ") AS ReadCount" 
                                                + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                                  ,hbttSqlReadCount).
                                
      FIND FIRST ttSqlReadCount NO-ERROR.
      IF AVAIL ttSqlReadCount AND ttSqlReadCount.ReadCount = iiRecordCount THEN RETURN cFields.
    END.  

    // Test #4: Add more fields (max 3)..
    cAddedFlds = "". 
    FOR EACH ttAllSqlColumns
        WHERE ttAllSqlColumns.DataSourceName = icSourceName 
          AND ttAllSqlColumns.Table_Name = icTableName
          AND (ttAllSqlColumns.Data_Type MATCHES "*char")
        :
      IF NOT CAN-DO(cFields,ttAllSqlColumns.Column_Name) THEN           
        ASSIGN cAddedFlds = cAddedFlds + (IF cAddedFlds NE "" THEN "," ELSE "") + ttAllSqlColumns.Column_Name      
               cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ttAllSqlColumns.Column_name
               cFieldExpr = cFieldExpr + (IF cFieldExpr NE "" THEN "," ELSE "") + '"' + ttAllSqlColumns.Table_name + '"."' + ttAllSqlColumns.Column_name + '"'
               ix = ix + 1.
      IF ix > 3 THEN LEAVE.         
    END.              
    IF cAddedFlds NE "" THEN DO:
      EMPTY TEMP-TABLE ttSqlReadCount.
      IF NUM-ENTRIES(cFields) > 1 THEN  
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT CONCAT(" + cFieldExpr + ")) AS ReadCount" 
                                + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                  ,hbttSqlReadCount).
      ELSE                            
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT " + cFieldExpr + ") AS ReadCount" 
                                + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                  ,hbttSqlReadCount).
                                
      FIND FIRST ttSqlReadCount NO-ERROR.
      IF AVAIL ttSqlReadCount AND ttSqlReadCount.ReadCount = iiRecordCount THEN RETURN cFields.
    END.  

    // Test #5: Add more fields (max 3 more)..
    cAddedFlds = "". 
    FOR EACH ttAllSqlColumns
        WHERE ttAllSqlColumns.DataSourceName = icSourceName 
          AND ttAllSqlColumns.Table_Name = icTableName
          AND (ttAllSqlColumns.Data_Type MATCHES "*char" OR ttAllSqlColumns.Data_Type MATCHES "*int")
        :
      IF NOT CAN-DO(cFields,ttAllSqlColumns.Column_Name) THEN           
        ASSIGN cAddedFlds = cAddedFlds + (IF cAddedFlds NE "" THEN "," ELSE "") + ttAllSqlColumns.Column_Name      
               cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ttAllSqlColumns.Column_name
               cFieldExpr = cFieldExpr + (IF cFieldExpr NE "" THEN "," ELSE "") + '"' + ttAllSqlColumns.Table_name + '"."' + ttAllSqlColumns.Column_name + '"'
               ix = ix + 1.
      IF ix > 3 THEN LEAVE.         
    END.              
    IF cAddedFlds NE "" THEN DO:
      EMPTY TEMP-TABLE ttSqlReadCount.
      IF NUM-ENTRIES(cFields) > 1 THEN  
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT CONCAT(" + cFieldExpr + ")) AS ReadCount" 
                                + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                  ,hbttSqlReadCount).
      ELSE                             
        getSqlData(icSourceName + "|SELECT COUNT(DISTINCT " + cFieldExpr + ") AS ReadCount" 
                                + " FROM " + icTableSchema + '"' + cSqlTable + '"' 
                  ,hbttSqlReadCount).

      FIND FIRST ttSqlReadCount NO-ERROR.
      IF AVAIL ttSqlReadCount AND ttSqlReadCount.ReadCount = iiRecordCount THEN RETURN cFields.
    END.  
    
    RETURN "".

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Used from JBoxSqlQueryHelper 
   Notes:   Server side ONLY
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL getPrimaryKey(INPUT icDataSourceName AS CHAR
                                     ,INPUT ihTargetBuffer AS HANDLE
                                     ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR bOk             AS LOG  NO-UNDO.
    DEF VAR cPKey           AS CHAR NO-UNDO.
    DEF VAR SQLschema       AS CHAR NO-UNDO.
    DEF VAR ocReturn        AS CHAR NO-UNDO.
    DEF VAR ix              AS INT  NO-UNDO.
    DEF VAR cSqlTable       AS CHAR NO-UNDO.
    
    icTableName = RealTable(icTableName).

    FOR EACH ttAllSqlPrimaryKeys
         WHERE ttAllSqlPrimaryKeys.DataSourceName = icDataSourceName 
           AND ttAllSqlPrimaryKeys.Table_Name     = icTableName
         :
      bOk = YES.
      ihTargetBuffer:BUFFER-CREATE().
      ihTargetBuffer:BUFFER-COPY (BUFFER ttAllSqlPrimaryKeys:HANDLE).
    END.    
    IF NOT bOk THEN DO:
      cDataSourceType = JBoxDataSourceHelper:Instance:getDataSourceType(icDataSourceName).
      cSqlTable = getABLTableSQLName(icDataSourceName, icTableName).
      EMPTY TEMP-TABLE ttSqlPrimaryKey.
      CASE cDataSourceType:
        WHEN "mssql" THEN DO:
          IF getSqlData(icDataSourceName + "|"
                                   + "SELECT Col.Column_Name FROM 
                                      INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
                                      INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
                                  WHERE 
                                      Col.Constraint_Name = Tab.Constraint_Name
                                      AND Col.Table_Name = Tab.Table_Name
                                      AND (Constraint_Type = 'PRIMARY KEY' OR Constraint_Type = 'UNIQUE') 
                                      AND Col.Table_Name = '" + cSqlTable + "'"  
                    ,hbttSqlPrimaryKey) THEN DO:
                      
            bOk = NO.
            FOR EACH ttSqlPrimaryKey:
              ihTargetBuffer:BUFFER-CREATE().
              ihTargetBuffer:BUFFER-COPY (hbttSqlPrimaryKey).
              CREATE ttAllSqlPrimaryKeys.
              BUFFER ttAllSqlPrimaryKeys:HANDLE:BUFFER-COPY(hbttSqlPrimaryKey).
              ASSIGN ttAllSqlPrimaryKeys.DataSourceName = icDataSourceName
                     ttAllSqlPrimaryKeys.Table_Name     = icTableName
                     bOk = YES.
            END.     
            IF NOT bOk THEN DO:  
              IF getSqlData(icDataSourceName + "|"
                                       + "SELECT Column_Name = col.name FROM 
                                         sys.indexes ind 
                                         INNER JOIN sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
                                         INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
                                         INNER JOIN sys.tables t ON ind.object_id = t.object_id 
                                    WHERE 
                                         ind.is_unique = 1
                                         and t.name = '" + cSqlTable + "'"  
                                       ,hbttSqlPrimaryKey) THEN DO:
                bOk = NO.  
                FOR EACH ttSqlPrimaryKey:
                  ihTargetBuffer:BUFFER-CREATE().
                  ihTargetBuffer:BUFFER-COPY (hbttSqlPrimaryKey).
                  CREATE ttAllSqlPrimaryKeys.
                  BUFFER ttAllSqlPrimaryKeys:HANDLE:BUFFER-COPY(hbttSqlPrimaryKey).
                  ASSIGN ttAllSqlPrimaryKeys.DataSourceName = icDataSourceName
                         ttAllSqlPrimaryKeys.Table_Name     = icTableName
                         bOk = YES
                         .
                END.  
              END.  
                                      
              IF NOT bOK THEN DO ON ERROR UNDO,LEAVE: // check for real unique columns. At this point columns have already been retrieved
                EMPTY TEMP-TABLE ttSqlReadCount.
                
                FIND FIRST ttAllSqlColumns
                     WHERE ttAllSqlColumns.DataSourceName = icDataSourceName
                       AND ttAllSqlColumns.Table_Name = icTableName.
                SQLschema = (IF ttAllSqlColumns.Table_Catalog NE "" THEN ttAllSqlColumns.Table_Catalog + "." ELSE "") + ttAllSqlColumns.Table_Schema + ".".
                                
                IF getSqlData(icDataSourceName + "|"
                                         + "SELECT COUNT(*) AS ReadCount" 
                                         + " FROM " + SQLschema + '"' + cSqlTable + '"' 
                                         ,hbttSqlReadCount) THEN DO:
                  bOk = NO.  
                  FIND FIRST ttSqlReadCount.
                  FIND FIRST ttNonUniqueKeyTable
                       WHERE ttNonUniqueKeyTable.DataSourceName = icDataSourceName
                         AND ttNonUniqueKeyTable.Table_Name = icTableName
                         AND ttNonUniqueKeyTable.UniqueColumns NE ""
                       NO-ERROR.  
                  IF AVAIL ttNonUniqueKeyTable AND ttNonUniqueKeyTable.RecordCount = ttSqlReadCount.ReadCount THEN
                    DO ix = 1 TO NUM-ENTRIES(ttNonUniqueKeyTable.UniqueColumns):
                      ihTargetBuffer:BUFFER-CREATE().
                      ASSIGN ihTargetBuffer::Column_Name = ENTRY(ix,ttNonUniqueKeyTable.UniqueColumns)
                             bOk = YES
                             .
                    END.
                  ELSE IF NOT AVAIL ttNonUniqueKeyTable THEN DO:
                    FIND FIRST ttNonUniqueKeyTable
                         WHERE ttNonUniqueKeyTable.DataSourceName = icDataSourceName
                           AND ttNonUniqueKeyTable.Table_Name = icTableName
                         NO-ERROR.
                    IF NOT AVAIL ttNonUniqueKeyTable THEN DO:       
                      CREATE ttNonUniqueKeyTable.
                      ASSIGN ttNonUniqueKeyTable.DataSourceName = icDataSourceName
                             ttNonUniqueKeyTable.Table_Name     = icTableName
                             .
                    END.         
                    ASSIGN ttNonUniqueKeyTable.RecordCount    = ttSqlReadCount.ReadCount
                           ttNonUniqueKeyTable.UniqueColumns  = THIS-OBJECT:findUniqueColumns(icDataSourceName,icTableName,SQLschema,ttSqlReadCount.ReadCount)
                           .
                    DO ix = 1 TO NUM-ENTRIES(ttNonUniqueKeyTable.UniqueColumns):
                      ihTargetBuffer:BUFFER-CREATE().
                      ASSIGN ihTargetBuffer::Column_Name = ENTRY(ix,ttNonUniqueKeyTable.UniqueColumns)
                             bOk = YES
                             .
                    END.
                  END.  
                  ELSE DO:
                    ASSIGN ttNonUniqueKeyTable.RecordCount    = ttSqlReadCount.ReadCount
                           ttNonUniqueKeyTable.UniqueColumns  = THIS-OBJECT:findUniqueColumns(icDataSourceName,icTableName,SQLschema,ttSqlReadCount.ReadCount)
                           .
                    DO ix = 1 TO NUM-ENTRIES(ttNonUniqueKeyTable.UniqueColumns):
                      ihTargetBuffer:BUFFER-CREATE().
                      ASSIGN ihTargetBuffer::Column_Name = ENTRY(ix,ttNonUniqueKeyTable.UniqueColumns)
                             bOk = YES
                             .
                    END.
                  END.    
                END.                  
                                        
                CATCH eErr AS Progress.Lang.Error :
                  ASSIGN sqlSchemaMessage = PROGRAM-NAME(1) + CHR(10) + eErr:GetMessage(1)
                         bOk = NO.  
                END CATCH.
              END.  
            END.
          END.
        END.
        WHEN "mysql" THEN DO:
          IF getSqlData(icDataSourceName + "|"
                                   + "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                                      WHERE TABLE_NAME = '" + icTableName + "' AND CONSTRAINT_NAME = 'PRIMARY'"             
                       ,hbttSqlPrimaryKey) THEN DO:
            bOk = NO.
            FOR EACH ttSqlPrimaryKey:
              ihTargetBuffer:BUFFER-CREATE().
              ihTargetBuffer:BUFFER-COPY (hbttSqlPrimaryKey).
              CREATE ttAllSqlPrimaryKeys.
              BUFFER ttAllSqlPrimaryKeys:HANDLE:BUFFER-COPY(hbttSqlPrimaryKey).
              ASSIGN ttAllSqlPrimaryKeys.DataSourceName = icDataSourceName
                     ttAllSqlPrimaryKeys.Table_Name     = icTableName
                     bOk = YES.
            END.   
          END.
        END.
        WHEN "ProgressSql" OR WHEN "sqlexp" THEN DO:
          IF getSqlData(icDataSourceName
                                  + "|SELECT COLNAME AS Column_name,SYSTABLES.TBL AS Table_Name, IDXNAME AS Index_Name, IDXTYPE AS Unique_Index, IDXSEQ AS Index_seq FROM SYSPROGRESS.SYSINDEXES JOIN SYSPROGRESS.SYSTABLES ON SYSTABLES.TBL = SYSINDEXES.TBL 
                                      WHERE SYSTABLES.TBLTYPE = 'T' AND SYSTABLES.TBL = '" + icTableName + "' AND Unique_Index = 'U'"
                       ,hbttSqlPrimaryKey) THEN DO:
            bOk = NO.
            FOR EACH ttSqlPrimaryKey:
              ihTargetBuffer:BUFFER-CREATE().
              ihTargetBuffer:BUFFER-COPY (hbttSqlPrimaryKey).
              CREATE ttAllSqlPrimaryKeys.
              BUFFER ttAllSqlPrimaryKeys:HANDLE:BUFFER-COPY(hbttSqlPrimaryKey).
              ASSIGN ttAllSqlPrimaryKeys.DataSourceName = icDataSourceName
                     ttAllSqlPrimaryKeys.Table_Name     = icTableName
                     bOk = YES.
            END.     
          END.
        END.  
        OTHERWISE 
          ASSIGN sqlSchemaMessage = "getTableColumns for data source type " + cDataSourceType + " not supported"
                 bOk = NO.  
      END CASE.  
    END.
    RETURN bOk.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getPrimaryKeyColumns(INPUT icDataSourceName AS CHAR
                                              ,INPUT icTableName AS CHAR ):
    
    DEFINE VARIABLE cPrimaryKeyColumns AS CHARACTER NO-UNDO.

    EMPTY TEMP-TABLE ttTablePrimaryKeyColumns.
    IF getPrimaryKey(icDataSourceName,hbttTablePrimaryKeyColumns,icTableName) THEN
      FOR EACH ttTablePrimaryKeyColumns
          WHERE NOT ttTablePrimaryKeyColumns.Column_Name BEGINS "PROGRESS_RECID":
        cPrimaryKeyColumns = cPrimaryKeyColumns + (IF cPrimaryKeyColumns NE "" THEN "," ELSE "") + ttTablePrimaryKeyColumns.Column_Name.     
      END.       

    RETURN cPrimaryKeyColumns.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve ABL datatype for ABL column
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getABLFieldABLType(INPUT icSqlDb     AS CHAR
                                            ,INPUT icTableName AS CHAR
                                            ,INPUT icFieldName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.

    icTableName = getABLTableSQLName(icSqlDb,RealTable(icTableName)).

    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
           AND tt_ds.cDataSourceType = cDataSourceType 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = tt_ds.cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN DO:           
      FIND FIRST tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND tt_field.cField-Name = icFieldName
           NO-ERROR.       
      IF AVAIL tt_field THEN 
        RETURN tt_field.cData-Type.
    END.
        
    RETURN "".

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve SQL fieldname for ABL column
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getABLFieldQuoSQLName(INPUT icSqlDb     AS CHAR
                                               ,INPUT icTableName AS CHAR
                                               ,INPUT icFieldName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR c2Q        AS CHAR NO-UNDO INIT '"'.
    DEF VAR c2QDot2Q   AS CHAR NO-UNDO INIT '"."'.

    icTableName = getABLTableSQLName(icSqlDb,RealTable(icTableName)).

    cDataSourceType = getTableDsType(icSqlDb, icTableName).

    IF cDataSourceType = "MySql" THEN
      ASSIGN c2Q = "`"
             c2QDot2Q = "`.`".       
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
           AND tt_ds.cDataSourceType = cDataSourceType 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = tt_ds.cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN DO:           
      FIND FIRST tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND tt_field.cField-Name = icFieldName
           NO-ERROR.       
      IF AVAIL tt_field THEN 
        RETURN c2Q /* + tt_file.cSqlTableName + c2QDot2Q */ + tt_field.cSqlFieldName + c2Q.
    END.
        
    RETURN "".

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve SQL fieldname for ABL column
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getABLFieldSQLName(INPUT icSqlDb     AS CHAR
                                            ,INPUT icTableName AS CHAR
                                            ,INPUT icFieldName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.

    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
           AND tt_ds.cDataSourceType = cDataSourceType 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = tt_ds.cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN DO:           
      FIND FIRST tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND tt_field.cField-Name = icFieldName
           NO-ERROR.       
      IF AVAIL tt_field THEN 
        RETURN tt_file.cSqlTableName + "." + tt_field.cSqlFieldName.
    END.
        
    RETURN "".

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve SQL fieldname for ABL column
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getABLTableSQLName(INPUT icSqlDb     AS CHAR
                                            ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.

    cDataSourceType = getTableDsType(icSqlDb, icTableName).
        
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN            
      RETURN tt_file.cSqlTableName.
        
    RETURN "".

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve SQL fieldname for ABL column
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getABLTableQuoSQLName(INPUT icSqlDb     AS CHAR
                                               ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR c2Q        AS CHAR NO-UNDO INIT '"'.

    cDataSourceType = getTableDsType(icSqlDb, icTableName).

    IF cDataSourceType = "MySql" THEN
      c2Q = "`".       
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
           AND tt_ds.cDataSourceType = cDataSourceType 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = tt_ds.cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN            
      RETURN c2Q + tt_file.cSqlTableName + c2Q.
        
    RETURN "".

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve SQL datatype for ABL column
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getABLFieldSQLType(INPUT icSqlDb     AS CHAR
                                            ,INPUT icTableName AS CHAR
                                            ,INPUT icFieldName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.

    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
           AND tt_ds.cDataSourceType = cDataSourceType 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = tt_ds.cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN DO:           
      FIND FIRST tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND tt_field.cField-Name = icFieldName
           NO-ERROR.       
      IF AVAIL tt_field THEN 
        RETURN tt_field.cSqlDataType.
    END.
        
    RETURN "".

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve SQL string value for ABL column value
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getABLToSQLValue  (INPUT icSqlDb     AS CHAR
                                            ,INPUT icTableName AS CHAR
                                            ,INPUT icFieldName AS CHAR
                                            ,INPUT icValue     AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR cValue          AS CHAR NO-UNDO.
    
    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
           AND tt_ds.cDataSourceType = cDataSourceType 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = tt_ds.cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN DO:           
      FIND FIRST tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND tt_field.cField-Name = icFieldName
           NO-ERROR.      
      IF AVAIL tt_field THEN 
        CASE tt_field.cSqlDataType:
          WHEN "nvarchar" OR WHEN "varchar" OR WHEN "char" OR WHEN "varbinary" OR WHEN "binary" OR WHEN "text" OR WHEN "uniqueidentifier" THEN 
            cValue = "'" + icValue + "'".
          WHEN "bit" THEN 
            cValue = IF CAN-DO("yes,true",icValue) THEN "1" ELSE "0".
          WHEN "date" THEN
            cValue = "'" + STRING(ISO-DATE(DATE(icValue))) + "'".
          WHEN "datetime" OR WHEN "timestamp" OR WHEN "smalldatetime" THEN
            cValue = "'" + ENTRY(1,REPLACE(STRING(ISO-DATE(DATETIME(icValue))),"T"," "),".") + "'".
          OTHERWISE DO:
            IF tt_field.cSqlDataType BEGINS "DEC" 
               OR tt_field.cSqlDataType BEGINS "DOUBLE" 
               OR tt_field.cSqlDataType = "FLOAT" 
               OR tt_field.cSqlDataType = "NUMERIC" 
               THEN DO:
              IF SESSION:NUMERIC-DECIMAL-POINT = "," THEN 
                ASSIGN cValue = REPLACE(icValue,".","")
                       cValue = REPLACE(cValue,",",".")
                       .
              ELSE
                cValue = REPLACE(icValue,",","").
              cValue = REPLACE(cValue," ","").
            END.
            ELSE cValue = icValue.  
          END.  
        END CASE.
    END.
        
    RETURN cValue.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Find referenced tables - ie tables where the primary/unique key field(s) 
            exist in the input table
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getReferencedTables(INPUT icSqlDb        AS CHAR
                                             ,INPUT icSQLTableName AS CHAR ):
    
    DEF VAR cRefTables      AS CHARACTER NO-UNDO.
    DEF VAR ix              AS INT       NO-UNDO. 
    DEF VAR cInputTableFlds AS CHAR      NO-UNDO.
    DEF VAR cDsType         AS CHAR      NO-UNDO.
    DEF VAR cTables         AS CHAR      NO-UNDO.
    
    cDsType = getTableDsType(icSqlDb, icSQLTableName).
    cInputTableFlds = getTableSqlColumns(icSqlDb, icSQLTableName).
    
    DO ix = 1 TO NUM-ENTRIES(cInputTableFlds):
      cTables = getTablesForSqlColumn(icSqlDb, cDsType, ENTRY(ix,cInputTableFlds)).
    END.

    RETURN cRefTables.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE LOGICAL getSqlData( INPUT icExpr AS CHAR
                                    ,INPUT ihFill AS HANDLE ):
    
    DEF VAR bOK AS LOGICAL NO-UNDO.

    IF bCallAppserver THEN 
      bOk = JBoxServerAPI:Instance:CallServerProc("jbserv_get_sql_data.p",icExpr,ihFill).
    ELSE                        
      bOk = JBoxServerSide:Instance:CallServerProc("jbserv_get_sql_data.p",icExpr,ihFill).
    IF NOT bOk THEN 
      sqlSchemaMessage = IF bCallAppserver THEN JBoxServerAPI:Instance:getCallMessage()
                         ELSE JBoxServerSide:Instance:getCallMessage().
    ELSE 
      sqlSchemaMessage = "".
      
    RETURN bOk.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve quooted SQL fieldname for SQL column
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getSQLFieldQuoSQLName(INPUT icSqlDb        AS CHAR
                                               ,INPUT icABLTableName AS CHAR
                                               ,INPUT icSqlFieldName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR c2Q        AS CHAR NO-UNDO INIT '"'.
    DEF VAR c2QDot2Q   AS CHAR NO-UNDO INIT '"."'.

    cDataSourceType = getTableDsType(icSqlDb, icABLTableName).

    IF cDataSourceType = "MySql" THEN
      ASSIGN c2Q = "`"
             c2QDot2Q = "`.`".       
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
           AND tt_ds.cDataSourceType = cDataSourceType 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icABLTableName
           AND tt_file.cDataSourceType = tt_ds.cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN DO:           
      FIND FIRST tt_field
           WHERE tt_field.iFileNum = tt_file.iFileNum
             AND tt_field.cSqlFieldName = icSqlFieldName
           NO-ERROR.       
      IF AVAIL tt_field THEN 
        RETURN c2Q + tt_file.cSqlTableName + c2QDot2Q + tt_field.cSqlFieldName + c2Q.
    END.
        
    RETURN "".

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve columns for tables in query if none are specified
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getTableSqlColumns(INPUT icSqlDb     AS CHAR
                                               ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR cFieldList      AS CHAR NO-UNDO.

    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN           
      FOR EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
          : 
        cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + tt_field.cSqlFieldName.
      END.
    RETURN cFieldList.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve columns for tables in query if none are specified
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getTableAblColumns(INPUT icSqlDb     AS CHAR
                                            ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR cFieldList      AS CHAR NO-UNDO.

    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN           
      FOR EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
          : 
        cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + tt_field.cField-Name.
      END.
    RETURN cFieldList.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve potiential foreign key columns for table
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getTableIndexedColumnList(INPUT icSqlDb     AS CHAR
                                                   ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR cFieldList      AS CHAR NO-UNDO.
    
    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN           
      FOR EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND tt_field.cIndexType NE ""
          BY tt_field.cIndexType DESC
          :
        cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + tt_field.cField-Name.
      END.
    RETURN cFieldList.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve potiential foreign key columns for table
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE CHARACTER getTableFKcolumnList(INPUT icSqlDb     AS CHAR
                                               ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR cFieldList      AS CHAR NO-UNDO.
    
    cDataSourceType = getTableDsType(icSqlDb, icTableName).
    
    IF NOT AVAIL tt_ds THEN RETURN "".
    
    FIND FIRST tt_file
         WHERE tt_file.cLDBname = tt_ds.cLDBname
           AND tt_file.cFile-Name = icTableName
           AND tt_file.cDataSourceType = cDataSourceType
         NO-ERROR.
    IF AVAIL tt_file THEN           
      FOR EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
            AND tt_field.cIndexType NE ""
          BREAK BY tt_field.cIndexName
                BY tt_field.iIndexSeq
          :
        IF FIRST-OF(tt_field.cIndexName) THEN     
          cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + tt_field.cIndexName.
        cFieldList = cFieldList + ";" + tt_field.cField-Name.
      END.
    RETURN cFieldList.

  END METHOD.

  METHOD PUBLIC CHARACTER getDsType(INPUT icDsName     AS CHAR):

    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icDsName 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN DO:
      CREATE tt_ds.
      IF icDsName = "Datafjord" THEN DO:
        ASSIGN tt_ds.cDataSourceName = "Datafjord"
               tt_ds.cDataSourceType = "TT"
               tt_ds.cLDBname = "TEMP-TABLE"
               .
        RETURN "TT".       
      END.
    
      IF bCallAppserver THEN DO: 
        IF JBoxServerAPI:Instance:CallServerProc("jbserv_get_datasource_type.p",icDsName) THEN 
          ASSIGN tt_ds.cDataSourceName = icDsName
                 tt_ds.cDataSourceType = ENTRY(1,JBoxServerAPI:Instance:getCallReturnParam(),"|")
                 tt_ds.cLDBname = ENTRY(2,JBoxServerAPI:Instance:getCallReturnParam(),"|")
                 .
        ELSE MESSAGE JBoxServerApi:Instance:getCallMessage() 
             VIEW-AS ALERT-BOX.  
      END.    
      ELSE DO:   
        IF JBoxServerSide:Instance:CallServerProc("jbserv_get_datasource_type.p",icDsName) THEN 
          ASSIGN tt_ds.cDataSourceName = icDsName
                 tt_ds.cDataSourceType = ENTRY(1,JBoxServerSide:Instance:getCallReturnParam(),"|")
                 tt_ds.cLDBname = ENTRY(2,JBoxServerSide:Instance:getCallReturnParam(),"|")
                 .
        ELSE MESSAGE JBoxServerSide:Instance:getCallMessage() 
             VIEW-AS ALERT-BOX.  
      END.    
    END.      
    IF NOT AVAIL tt_ds OR tt_ds.cDataSourceType = "" THEN DO:
      MESSAGE "Could not retrieve data source type for " icDsName 
      VIEW-AS ALERT-BOX ERROR.
      RETURN ?. 
    END.
    
    
    RETURN tt_ds.cDataSourceType.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose: Use on client (or server) to retrieve datasource type. Also fetches the schema for the table
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE CHARACTER getTableDsType(INPUT icSqlDb     AS CHAR
                                         ,INPUT icTableName AS CHAR ):
    
    DEF VAR cOper AS CHAR NO-UNDO.
 
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN DO:
      getDsType(icSqlDb).
      FIND FIRST tt_ds
           WHERE tt_ds.cDataSourceName = icSqlDb 
           NO-ERROR.
    END.      
    IF NOT AVAIL tt_ds OR tt_ds.cDataSourceType = "" THEN 
      RETURN ?. 
    
    IF NOT CAN-FIND(FIRST tt_file WHERE tt_file.cLDBname = tt_ds.cLDBname AND tt_file.cFile-Name = icTableName) THEN DO:
      cOper = "=".
      IF icTableName MATCHES "*_" AND KEYWORD(SUBSTR(icTableName,1,LENGTH(icTableName) - 1)) NE ? THEN icTableName = SUBSTR(icTableName,1,LENGTH(icTableName) - 1).
      ELSE IF LENGTH(icTableName) = 32 THEN
        ASSIGN icTableName = icTableName + "%"
               cOper = "LIKE". 
      
      getTableSchema (icSqlDb,tt_ds.cDataSourceType,
                     (IF CAN-DO("mssql,mysql",tt_ds.cDataSourceType) THEN "INFORMATION_SCHEMA.COLUMNS.TABLE_NAME " + cOper + " '"
                      ELSE IF CAN-DO("ProgressSql,sqlexp",tt_ds.cDataSourceType) THEN "SYSCOLUMNS_FULL.TBL = '"
                      ELSE "")  /* Add for PostresSQL.. */
                   + icTableName + "'"
                    ,(IF tt_ds.cDataSourceType = "mssql" THEN "t.name = '"
                      ELSE IF tt_ds.cDataSourceType = "MySql" THEN "TABLE_NAME = '"
                      ELSE IF CAN-DO("ProgressSql,sqlexp",tt_ds.cDataSourceType) THEN "SYSTABLES.TBL = '"
                      ELSE "")  /* Add for PostresSQL.. */
                   + icTableName + "'"
                     ).
    END.                  

    RETURN tt_ds.cDataSourceType.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

END METHOD.


  /*------------------------------------------------------------------------------
   Purpose: Use on server (JBoxSqlQueryHelper) to retrieve columns for tables in query
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL getTableColumns(INPUT icDataSourceName AS CHAR
                                       ,INPUT ihTargetBuffer AS HANDLE
                                       ,INPUT icTableName AS CHAR ):
    
    DEF VAR cDataSourceType AS CHAR NO-UNDO.
    DEF VAR bOk             AS LOG  NO-UNDO.
    DEF VAR cPKey           AS CHAR NO-UNDO.

    FOR EACH ttAllSqlColumns
         WHERE ttAllSqlColumns.DataSourceName = icDataSourceName 
           AND ttAllSqlColumns.Table_Name     = icTableName
         :
      bOk = YES.
      ihTargetBuffer:BUFFER-CREATE().
      ihTargetBuffer:BUFFER-COPY (BUFFER ttAllSqlColumns:HANDLE).
    END.      
       
    IF NOT bOk THEN DO ON ERROR UNDO, LEAVE:
      cDataSourceType = JBoxDataSourceHelper:Instance:getDataSourceType(icDataSourceName).
      EMPTY TEMP-TABLE ttSqlColumns.
      CASE cDataSourceType:
        WHEN "mssql" OR WHEN "mysql" THEN DO:
          IF getSqlData(icDataSourceName + "|"
                                   + "SELECT * FROM INFORMATION_SCHEMA.COLUMNS JOIN INFORMATION_SCHEMA.TABLES ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME WHERE INFORMATION_SCHEMA.TABLES.TABLE_NAME = '"      
                                   + icTableName + "'"  
                       ,hbttSqlColumns) THEN DO:
            bOk = NO.
            setProgressFieldProp(icTableName).
            FOR EACH ttSqlColumns:
              ihTargetBuffer:BUFFER-CREATE().
              ihTargetBuffer:BUFFER-COPY (hbttSqlColumns).
              CREATE ttAllSqlColumns.
              BUFFER ttAllSqlColumns:HANDLE:BUFFER-COPY(BUFFER ttSqlColumns:HANDLE).
              ASSIGN ttAllSqlColumns.DataSourceName = icDataSourceName
                     ttAllSqlColumns.Table_Name     = icTableName
                     bOk = YES.
            END.    
          END.
        END.
        WHEN "ProgressSQL" OR WHEN "sqlexp" THEN DO:
          IF getSqlData(icDataSourceName + "|"
                                   + "SELECT SYSCOLUMNS.COL AS Column_Name,SYSCOLUMNS.TBL AS Table_Name, SYSCOLUMNS.OWNER AS Table_Schema, SYSCOLUMNS.COLTYPE AS Data_Type FROM SYSPROGRESS.SYSCOLUMNS WHERE SYSCOLUMNS.TBL = '"
                                   + icTableName + "'"  
                       ,hbttSqlColumns) THEN DO:
            bOk = NO.
            setProgressFieldProp(icTableName).
            FOR EACH ttSqlColumns:
              ihTargetBuffer:BUFFER-CREATE().
              ihTargetBuffer:BUFFER-COPY (hbttSqlColumns).
              CREATE ttAllSqlColumns.
              BUFFER ttAllSqlColumns:HANDLE:BUFFER-COPY(BUFFER ttSqlColumns:HANDLE).
              ASSIGN ttAllSqlColumns.DataSourceName = icDataSourceName
                     ttAllSqlColumns.Table_Name     = icTableName
                     bOk = YES.
            END.     
          END.    
        END.
        OTHERWISE 
          ASSIGN sqlSchemaMessage = "getTableColumns for dataSourceType " + cDataSourceType + " not supported. Type derived from data source name: " + icDataSourceName
                 bOk = NO.  
      END CASE.  
      CATCH eErr AS Progress.Lang.Error :
        MESSAGE eErr:GetMessage(1)
        VIEW-AS ALERT-BOX.
          
      END CATCH.
    END.
    RETURN bOk.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Used on client (or query object on server) to build placeholder tt for browse or query
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC HANDLE getTtDef(INPUT icSqlDb AS CHAR, INPUT icBuffersAndFields AS CHAR ):
    
    DEF VAR ix                  AS INT NO-UNDO.
    DEF VAR iy                  AS INT NO-UNDO.
    DEF VAR cFetchList          AS CHAR NO-UNDO.
    DEF VAR cFieldDef           AS CHAR NO-UNDO.
    DEF VAR cCalcFldName        AS CHAR NO-UNDO.
    DEF VAR hTT                 AS HANDLE NO-UNDO.
    DEF VAR cTbl                AS CHAR NO-UNDO.                          
    DEF VAR cFldSuff            AS CHAR NO-UNDO.
    DEF VAR bGetTTdef           AS LOG  NO-UNDO.    
    DEF VAR cAddedDbFlds        AS CHAR NO-UNDO. 
    DEF VAR cTtName             AS CHAR NO-UNDO.
    DEF VAR cIndexFetchList     AS CHAR NO-UNDO.
    DEF VAR cOper               AS CHAR NO-UNDO.

    duplicateTtFields = "".

    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN DO:
      getDsType(icSqlDb).
      FIND FIRST tt_ds
           WHERE tt_ds.cDataSourceName = icSqlDb 
           NO-ERROR.
    END.      
    IF NOT AVAIL tt_ds OR tt_ds.cDataSourceType = "" THEN DO:
      MESSAGE "Could not retrieve data source type for " icSqlDb 
      VIEW-AS ALERT-BOX ERROR.
      RETURN ?. 
    END.
    
    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      cTbl = realTable(ENTRY(1,ENTRY(ix,icBuffersAndFields),";")).
      IF NOT CAN-FIND(FIRST tt_file WHERE tt_file.cLDBname = icSqlDb AND tt_file.cFile-Name = cTbl) THEN DO:
        cOper = "=".
        IF cTbl MATCHES "*_" AND KEYWORD(SUBSTR(cTbl,1,LENGTH(cTbl) - 1)) NE ? THEN cTbl = SUBSTR(cTbl,1,LENGTH(cTbl) - 1).
        ELSE IF LENGTH(cTbl) = 32 THEN
          ASSIGN cTbl = cTbl + "%"
                 cOper = "LIKE". 
         
        ASSIGN cFetchList = cFetchList + (IF cFetchList NE "" THEN " OR " ELSE "")
                   + (IF CAN-DO("mssql,mysql",tt_ds.cDataSourceType) THEN "INFORMATION_SCHEMA.COLUMNS.TABLE_NAME " + cOper + " '"
                      ELSE IF CAN-DO("ProgressSql,sqlexp",tt_ds.cDataSourceType) THEN "SYSCOLUMNS_FULL.TBL = '"
                      ELSE "")  /* Add for PostresSQL.. */
                   + cTbl + "'"
               cIndexFetchList = cIndexFetchList + (IF cIndexFetchList NE "" THEN " OR " ELSE "") 
                   + (IF tt_ds.cDataSourceType = "mssql" THEN "t.name = '"
                      ELSE IF tt_ds.cDataSourceType = "MySql" THEN "table_name = '"
                      ELSE IF CAN-DO("ProgressSql,sqlexp",tt_ds.cDataSourceType) THEN "SYSTABLES.TBL = '"
                      ELSE "")  /* Add for PostresSQL.. */
                   + cTbl + "'"
                   .
      END.             
    END.  

    IF cFetchList NE "" THEN DO:
      getTableSchema (icSqlDb,tt_ds.cDataSourceType,cFetchList,cIndexFetchList).
      IF sqlSchemaMessage MATCHES "*cancelConnect" THEN RETURN ?.
    END.   
           
    CREATE TEMP-TABLE hTT.
    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      cTbl = ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
      IF cTbl BEGINS "NOT EXIST " THEN cTbl = SUBSTR(cTbl,11).
      IF NUM-ENTRIES(cTbl,".") > 1 THEN cTbl = ENTRY(2,cTbl,".").
      IF ix = 1 THEN cTtName = cTbl.
      cFldSuff = "".
      FIND FIRST tt_file WHERE tt_file.cLDBname = tt_ds.cLDBname 
           AND tt_file.cFile-Name = cTbl
           NO-ERROR.
      IF NOT AVAIL tt_file AND cTbl MATCHES "buf*_*" THEN 
        FIND FIRST tt_file WHERE tt_file.cLDBname = tt_ds.cLDBname 
             AND tt_file.cFile-Name = SUBSTR(cTbl,INDEX(cTbl,"_") + 1)
             NO-ERROR.
      IF AVAIL tt_file THEN DO iy = 2 TO NUM-ENTRIES(ENTRY(ix,icBuffersAndFields),";"):
        cFieldDef = ENTRY(1,ENTRY(iy,ENTRY(ix,icBuffersAndFields),";"),"@").
        FIND FIRST tt_field 
             WHERE tt_field.iFileNum = tt_file.iFileNum
               AND tt_field.cField-Name = LEFT-TRIM(ENTRY(1,cFieldDef,"|"),"!")
             NO-ERROR.
        IF AVAIL tt_field THEN DO:
          IF CAN-DO(cAddedDbFlds,tt_field.cField-Name) THEN
            ASSIGN cFldSuff = STRING(ix)
                   duplicateTtFields = duplicateTtFields + (IF duplicateTtFields NE "" THEN "," ELSE "") + tt_field.cField-Name + cFldSuff
                   .
          ELSE cFldSuff = "".     
          CASE NUM-ENTRIES(cFieldDef,"|"):
            WHEN 1 THEN hTT:ADD-NEW-FIELD (tt_field.cField-Name + cFldSuff,tt_field.cData-Type,0,tt_field.cFormat).
            WHEN 2 THEN hTT:ADD-NEW-FIELD (tt_field.cField-Name + cFldSuff,tt_field.cData-Type,0,tt_field.cFormat,"",ENTRY(2,cFieldDef,"|")).
            WHEN 3 OR WHEN 4 THEN hTT:ADD-NEW-FIELD (tt_field.cField-Name + cFldSuff,tt_field.cData-Type,0,REPLACE(ENTRY(3,cFieldDef,"|"),"<",","),"",ENTRY(2,cFieldDef,"|")).
          END CASE.  
          cAddedDbFlds = cAddedDbFlds + (IF cAddedDbFlds NE "" THEN "," ELSE "") + tt_field.cField-Name.
        END.  
        ELSE IF cFieldDef BEGINS "!+" OR cFieldDef BEGINS "+" THEN DO:
          cCalcFldName = ENTRY(1,cFieldDef,"|").
          cCalcFldName = SUBSTR(cCalcFldName,INDEX(cCalcFldName,"+") + 1).
          CASE NUM-ENTRIES(cFieldDef,"|"):
            WHEN 2 THEN hTT:ADD-NEW-FIELD (cCalcFldName,ENTRY(2,cFieldDef,"|")).
            WHEN 3 OR WHEN 4 THEN hTT:ADD-NEW-FIELD (cCalcFldName,ENTRY(2,cFieldDef,"|"),0,REPLACE(ENTRY(3,cFieldDef,"|"),"<",",")).
            WHEN 5 THEN hTT:ADD-NEW-FIELD (cCalcFldName,ENTRY(2,cFieldDef,"|"),0,REPLACE(ENTRY(3,cFieldDef,"|"),"<",","),"",ENTRY(5,cFieldDef,"|")).
          END.  
        END.  
      END.           
    END.  
    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      hTT:ADD-NEW-FIELD ("RowIdent" + STRING(ix),"CHARACTER").
    END.  
    hTT:ADD-NEW-FIELD ("RowCount","INTEGER",0,">>>>>>>9").
    hTT:ADD-NEW-FIELD ("jbCountDistinct","INTEGER",0,">>>,>>>,>>9").
    hTT:ADD-NEW-FIELD ("jbAverage","DECIMAL",0,"->>>,>>>,>>9.99").
    
    hTT:TEMP-TABLE-PREPARE (cTtName).
    RETURN hTT.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Used here from getTtDef (for client or query object on server) to build placeholder tt for browse or query
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE VOID getTableSchema (INPUT icSqlDb AS CHAR,INPUT icDataSourceType AS CHAR,INPUT icWhere AS CHAR,INPUT icIndexWhere AS CHAR ):
    
    DEF VAR ixFileNum    AS INT NO-UNDO.
    DEF VAR ixIdxNum     AS INT NO-UNDO.
    DEF VAR ixFieldNum   AS INT NO-UNDO.
    DEF VAR ix           AS INT NO-UNDO.

    sqlSchemaMessage = "".
    
//    JBoxSchemaCache:Instance:viewSchema().
    
    FIND FIRST tt_ds
         WHERE tt_ds.cDataSourceName = icSqlDb 
         NO-ERROR.
    IF NOT AVAIL tt_ds THEN DO:
      getDsType(icSqlDb).
      FIND FIRST tt_ds
           WHERE tt_ds.cDataSourceName = icSqlDb 
           NO-ERROR.
    END.      
    IF NOT AVAIL tt_ds OR tt_ds.cDataSourceType = "" THEN DO:
      MESSAGE "Could not retrieve data source type for " icSqlDb 
      VIEW-AS ALERT-BOX ERROR.
      RETURN. 
    END.
  
    EMPTY TEMP-TABLE ttSqlSchema.
    EMPTY TEMP-TABLE ttSqlIndex.
        
    IF icDataSourceType = "mssql" THEN DO:
      IF getSqlData(icSqlDb
          + "|SELECT * FROM INFORMATION_SCHEMA.COLUMNS JOIN INFORMATION_SCHEMA.TABLES ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME WHERE "
          + icWhere
        ,hbttSqlSchema) THEN DO:
        setProgressProp(icSqlDb).
        IF NOT getSqlData(icSqlDb
             + "|SELECT Column_Name = col.name,Table_Name = t.name,Index_Name = ind.name,Unique_Index = ind.is_unique,Index_seq = ic.key_ordinal FROM 
               sys.indexes ind 
               INNER JOIN sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
               INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
               INNER JOIN sys.tables t ON ind.object_id = t.object_id WHERE "
             + icIndexWhere   
             ,hbttSqlIndex) THEN 
          sqlSchemaMessage = "INFO - failed to get sql-indexes" + CHR(10) + sqlSchemaMessage.
      END.      
    END.

    ELSE IF icDataSourceType = "MySql" THEN DO:
      IF getSqlData(icSqlDb
           + "|SELECT * FROM INFORMATION_SCHEMA.COLUMNS JOIN INFORMATION_SCHEMA.TABLES ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME WHERE INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA = '" + tt_ds.cLDBname + "' AND ("
           + icWhere + ")"
        ,hbttSqlSchema) THEN DO:
        setProgressProp(icSqlDb). 
    
        IF NOT getSqlData(icSqlDb
             + "|SELECT table_schema, table_name, index_name, column_name, index_name = 'PRIMARY' as unique_index,seq_in_index AS index_seq
                FROM information_schema.statistics WHERE (" + icIndexWhere
             + ") AND table_schema = '" + tt_ds.cLDBname + "'" 
             ,hbttSqlIndex) THEN 
          sqlSchemaMessage = "INFO - failed to get sql-indexes" + CHR(10) + sqlSchemaMessage.
      END.    
    END.
    
    ELSE IF CAN-DO("ProgressSql,sqlexp",icDataSourceType) THEN DO:
      IF getSqlData(icSqlDb
          + "|SELECT COL AS Column_Name,COLTYPE AS Data_Type,SYSCOLUMNS_FULL.FORMAT AS OEformat,SYSCOLUMNS_FULL.LABEL AS OElabel,SYSCOLUMNS_FULL.VALMSG AS OEvalmsg, SYSCOLUMNS_FULL.TBL AS Table_Name, SYSTABLES.OWNER AS Table_Schema,TBLTYPE AS Table_Type FROM SYSPROGRESS.SYSCOLUMNS_FULL JOIN SYSPROGRESS.SYSTABLES ON SYSTABLES.TBL = SYSCOLUMNS_FULL.TBL WHERE "
          + icWhere
        ,hbttSqlSchema) THEN DO:
        setProgressProp(icSqlDb).
        
        IF NOT JBoxServerAPI:Instance:GetMyTempTable("jbserv_get_sql_data.p",icSqlDb
             + "|SELECT COLNAME AS Column_name,SYSTABLES.TBL AS Table_Name, IDXNAME AS Index_Name, IDXTYPE AS Unique_Index, IDXSEQ AS Index_seq FROM SYSPROGRESS.SYSINDEXES JOIN SYSPROGRESS.SYSTABLES ON SYSTABLES.TBL = SYSINDEXES.TBL WHERE SYSTABLES.TBLTYPE = 'T' AND "      
             + icIndexWhere   
             ,hbttSqlIndex) THEN 
          sqlSchemaMessage = "INFO - failed to get sql-indexes" + CHR(10) + sqlSchemaMessage.
      END.       
    END.
    ELSE IF icDataSourceType NE "TT" THEN
      sqlSchemaMessage = "Invalid data source type: " + icDataSourceType.
        
    IF sqlSchemaMessage = "" THEN DO:  
      FOR EACH tt_file BY tt_file.iFileNum DESC:
        ixFileNum = tt_file.iFileNum.
        LEAVE.
      END.
    
      FOR EACH ttSqlSchema
          WHERE ttSqlSchema.OETableName NE ""
          BREAK BY ttSqlSchema.OETableName
          :
        IF FIRST-OF(ttSqlSchema.OETableName) THEN DO:
          CREATE tt_file.
          ASSIGN tt_file.cFile-Name      = ttSqlSchema.OETableName
                 tt_file.cLDBname        = tt_ds.cLDBname
                 tt_file.cTbl-Type       = "T"
                 tt_file.cType           = IF ttSqlSchema.Table_Type = "BASE TABLE" THEN "TABLE" ELSE "VIEW"
                 ixFileNum               = ixFileNum + 1
                 tt_file.iFileNum        = ixFileNum
                 tt_file.cDataSourceType = icDataSourceType
                 tt_file.cSqlTableName   = ttSqlSchema.Table_Name
                 ix                      = ix + 1
                 .
        END.  
              
        CREATE tt_field.
        ASSIGN tt_field.iFileNum      = tt_file.iFileNum
               ixFieldNum             = ixFieldNum + 1
               tt_field.iFieldNum     = ixFieldNum
               tt_field.cField-Name   = ttSqlSchema.OEFieldName
               tt_field.cData-Type    = ttSqlSchema.OEdataType
               tt_field.cFormat       = ttSqlSchema.OEformat
               tt_field.cLabel        = ttSqlSchema.OElabel
               tt_field.iOrder        = ttSqlSchema.Ordinal_Position
               tt_field.cSqlFieldName = ttSqlSchema.Column_Name
               tt_field.cSqlDataType  = ttSqlSchema.Data_Type
               .
        FOR EACH ttSqlIndex
            BREAK BY ttSqlIndex.Index_name
                  BY ttSqlIndex.Index_seq
            :
          IF FIRST-OF(ttSqlIndex.Index_name) AND ttSqlIndex.Column_name = ttSqlSchema.Column_Name THEN
            ASSIGN tt_field.cIndexType = ttSqlIndex.Unique_Index
                   tt_field.cIndexName = ttSqlIndex.Index_name
                   tt_field.iIndexSeq  = ttSqlIndex.Index_seq. 
        END.        
      END.
    END.
    ELSE MESSAGE sqlSchemaMessage
         VIEW-AS ALERT-BOX.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  
END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Used here from getTtDef (for client or query object on server) to build placeholder tt for browse or query
   Notes:
  ------------------------------------------------------------------------------*/

METHOD PRIVATE CHARACTER getTablesForSqlColumn (INPUT icSqlDb AS CHAR,INPUT icDataSourceType AS CHAR,INPUT icColumnName AS CHAR):
    
  DEF VAR ix           AS INT  NO-UNDO.
  DEF VAR cReturn      AS CHAR NO-UNDO.

  EMPTY TEMP-TABLE ttSqlSchema.
  sqlSchemaMessage = "".
      
  IF CAN-DO("mysql,mssql",icDataSourceType) THEN 
    getSqlData(icSqlDb
        + "|SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME = '" + icColumnName + "'"
        ,hbttSqlSchema).      
  ELSE IF CAN-DO("ProgressSql,sqlexp",icDataSourceType) THEN 
    getSqlData(icSqlDb
        + "|SELECT COL AS Column_Name,COLTYPE AS Data_Type,SYSCOLUMNS_FULL.FORMAT AS OEformat,SYSCOLUMNS_FULL.LABEL AS OElabel,SYSCOLUMNS_FULL.VALMSG AS OEvalmsg, SYSCOLUMNS_FULL.TBL AS Table_Name FROM SYSPROGRESS.SYSCOLUMNS_FULL WHERE SYSCOLUMNS_FULL.COL = '" + icColumnName + "'"
        ,hbttSqlSchema).
  ELSE sqlSchemaMessage = "Invalid data source type: " + icDataSourceType.
         
  IF sqlSchemaMessage = "" THEN DO:
    FOR EACH ttSqlSchema:
      cReturn = cReturn + (IF cReturn NE "" THEN "," ELSE "") + ttSqlSchema.Table_Name.
    END.
    RETURN cReturn.
  END.     
  ELSE MESSAGE sqlSchemaMessage
       VIEW-AS ALERT-BOX.

  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.
  
END METHOD.


/*------------------------------------------------------------------------------
 Purpose: Check if a column is the primary key somewhere
 Notes:
------------------------------------------------------------------------------*/

METHOD PRIVATE CHARACTER getSqlPrimaryKeyTablesForColumn (INPUT icSqlDb AS CHAR,INPUT icDataSourceType AS CHAR,INPUT icColumnName AS CHAR):
    
  DEF VAR ix           AS INT  NO-UNDO.
  DEF VAR cError       AS CHAR NO-UNDO.
  DEF VAR cReturn      AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  EMPTY TEMP-TABLE ttSqlPrimaryKey.
  sqlSchemaMessage = "".
  IF SUBSTR(icColumnName,LENGTH(icColumnName)) = "_" AND
     KEYWORD(SUBSTR(icColumnName,1,LENGTH(icColumnName) - 1)) NE ? THEN
    icColumnName = SUBSTR(icColumnName,1,LENGTH(icColumnName) - 1). 
      
  IF icDataSourceType = "mssql" THEN DO:
    IF getSqlData(icSqlDb + "|"
                          + "SELECT Col.Table_Name FROM 
                             INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab, 
                             INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col 
                         WHERE 
                             Col.Constraint_Name = Tab.Constraint_Name
                             AND Col.Table_Name = Tab.Table_Name
                             AND (Constraint_Type = 'PRIMARY KEY' OR Constraint_Type = 'UNIQUE') 
                             AND Col.Column_Name = '" + icColumnName + "'"  
                         ,hbttSqlPrimaryKey) THEN
      FIND FIRST ttSqlPrimaryKey NO-ERROR.
    IF NOT AVAIL ttSqlPrimaryKey THEN                      
      getSqlData(icSqlDb + "|"
                         + "SELECT Table_Name = t.name FROM 
                             sys.indexes ind 
                             INNER JOIN sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
                             INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
                             INNER JOIN sys.tables t ON ind.object_id = t.object_id 
                         WHERE 
                             ind.is_unique = 1
                             and col.name = '" + icColumnName + "'"  
                             ,hbttSqlPrimaryKey).
  END.  

  ELSE IF icDataSourceType = "mysql" THEN 
    getSqlData(icSqlDb + "|"
                       + "SELECT DISTINCT KEY_COLUMN_USAGE.CONSTRAINT_NAME, KEY_COLUMN_USAGE.TABLE_NAME, KEY_COLUMN_USAGE.COLUMN_NAME, KEY_COLUMN_USAGE.REFERENCED_TABLE_NAME, KEY_COLUMN_USAGE.REFERENCED_COLUMN_NAME
                          FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
                          INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
                          ON TABLE_CONSTRAINTS.CONSTRAINT_NAME=KEY_COLUMN_USAGE.CONSTRAINT_NAME AND TABLE_CONSTRAINTS.CONSTRAINT_SCHEMA=KEY_COLUMN_USAGE.CONSTRAINT_SCHEMA
                          WHERE TABLE_CONSTRAINTS.CONSTRAINT_TYPE='PRIMARY KEY' AND KEY_COLUMN_USAGE.COLUMN_NAME= '" + icColumnName + "'"  
                       ,hbttSqlPrimaryKey).
  
  ELSE IF CAN-DO("ProgressSql,sqlexp",icDataSourceType)   THEN 
    getSqlData(icSqlDb
                    + "|SELECT COLNAME AS Column_name,SYSTABLES.TBL AS Table_Name, IDXNAME AS Index_Name, IDXTYPE AS Unique_Index, IDXSEQ AS Index_seq FROM SYSPROGRESS.SYSINDEXES JOIN SYSPROGRESS.SYSTABLES ON SYSTABLES.TBL = SYSINDEXES.TBL WHERE SYSTABLES.TBLTYPE = 'T' AND INDEX_SEQ = 0 AND UNIQUE_INDEX = 'U' AND COLNAME = '" + icColumnName + "'"
                    ,hbttSqlPrimaryKey).

  ELSE sqlSchemaMessage = "Invalid data source type: " + icDataSourceType.

  IF sqlSchemaMessage = "" THEN DO:
    FOR EACH ttSqlPrimaryKey:
      cReturn = cReturn + (IF cReturn NE "" THEN "," ELSE "") + ttSqlPrimaryKey.Table_Name.
    END.
    RETURN cReturn.
  END.     
       
  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.
  
END METHOD.

    
METHOD PRIVATE VOID setProgressProp
  ( INPUT icSqlDb AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:
  ------------------------------------------------------------------------------*/
  DEF VAR bOk          AS LOG  NO-UNDO.
  DEF VAR cFldName     AS CHAR NO-UNDO.
  DEF VAR cFldType     AS CHAR NO-UNDO.
  DEF VAR cFldFormat   AS CHAR NO-UNDO.
  DEF VAR cLabel       AS CHAR NO-UNDO.
  DEF VAR cValMsg      AS CHAR NO-UNDO.
  
  FOR EACH ttSqlSchema
      WHERE CAN-DO("VIEW,BASE TABLE,T", ttSqlSchema.Table_Type)
        AND ttSqlSchema.Table_Name NE "sysdiagrams"
      :
    
    CASE ttSqlSchema.Data_Type:  
      WHEN "nvarchar" OR WHEN "varchar" OR WHEN "char" OR WHEN "varbinary" OR WHEN "binary" OR WHEN "text" THEN 
        ASSIGN cFldType = "CHARACTER"
               cFldFormat = 'x(' + STRING(MAX(1,MIN(ttSqlSchema.Character_Maximum_Length,100))) + ')'.
      WHEN "bit" THEN 
        ASSIGN cFldType = "LOGICAL"
               cFldFormat = 'True/False'.       
      WHEN "int" OR WHEN "smallint" OR WHEN "integer" OR WHEN "mediumint" THEN 
        ASSIGN cFldType = "INTEGER"
               cFldFormat = '->>>>>>>>>9'.       
      WHEN "tinyint" THEN 
        ASSIGN cFldType = "INTEGER"
               cFldFormat = '->>>>>>9'.       
      WHEN "bigint" THEN 
        ASSIGN cFldType = "INT64"
               cFldFormat = '->>>>>>>>>>>>9'.       
      WHEN "uniqueidentifier" THEN 
        ASSIGN cFldType = "CHARACTER"
               cFldFormat = 'x(50)'.       
      WHEN "datetime" OR WHEN "timestamp" THEN
        ASSIGN cFldType = "DATETIME"
               cFldFormat = '99.99.9999 HH:MM:SS'.
      WHEN "smalldatetime" OR WHEN "date" THEN
        ASSIGN cFldType = "DATE"
               cFldFormat = '99.99.9999'.
      WHEN "float" OR WHEN "numeric" OR WHEN "decimal" OR WHEN "real" THEN
        ASSIGN cFldType = "DECIMAL"
               cFldFormat = '->>>>,>>>,>>9.99'.
      WHEN "smallmoney" OR WHEN "money" THEN
        ASSIGN cFldType = "DECIMAL"
               cFldFormat = '->>>>,>>>,>>9.9999'.
      OTHERWISE NEXT.         
  /*        WHEN "text" THEN                          */
  /*          ASSIGN cFldType = "CLOB"                */
  /*                 cFldFormat = '  FORMAT "x(255)"'.*/
  /*        WHEN "image" THEN                         */
  /*          ASSIGN cFldType = "BLOB"                */
  /*                 cFldFormat = '  FORMAT "x(8)"'.  */
    END CASE.     
    
    ttSqlSchema.OETableName = REPLACE(ttSqlSchema.Table_Name,"æ","a_e_").
    ttSqlSchema.OETableName = REPLACE(ttSqlSchema.OETableName,"ø","o_e_").
    ttSqlSchema.OETableName = REPLACE(ttSqlSchema.OETableName,"å","a_a_").
    ttSqlSchema.OETableName = REPLACE(ttSqlSchema.OETableName," ","__").
    IF KEYWORD(ttSqlSchema.OETableName) NE ? THEN
      ttSqlSchema.OETableName = ttSqlSchema.OETableName + "_".
    
    IF LENGTH(ttSqlSchema.Table_Name) > 32 THEN 
      ttSqlSchema.OETableName = SUBSTR(ttSqlSchema.Table_Name,1,32).
      
    cFldName = ttSqlSchema.Column_Name.    
    ttSqlSchema.ColNameLength = LENGTH(ttSqlSchema.Column_Name).
    cValMsg  = "".
    cLabel   = CAPS(SUBSTR(cFldName,1,1)) + SUBSTR(cFldName,2).
    cFldName = REPLACE(cFldName,"æ","a_e_").  
    cFldName = REPLACE(cFldName,"ø","o_e_").  
    cFldName = REPLACE(cFldName,"å","a_a_").  
    cFldName = REPLACE(cFldName," ","__").
    cFldName = REPLACE(cFldName,"(","#_#_").
    cFldName = REPLACE(cFldName,")","_#_#").
    
    IF KEYWORD(cFldName) NE ? THEN
      cFldName = cFldName + "_".

    IF ttSqlSchema.OEformat NE "" THEN
      ASSIGN cFldFormat = ttSqlSchema.OEformat
             cLabel     = ttSqlSchema.OElabel
             cValMsg    = ttSqlSchema.OEvalmsg
             .
    
    IF LENGTH(cFldName) > 32 THEN
      ASSIGN cValMsg  = cFldName
             cFldName = SUBSTR(cFldName,1,32).
  
    ASSIGN ttSqlSchema.OEdataType  = cFldType
           ttSqlSchema.OEFieldName = cFldName
           ttSqlSchema.OEformat    = cFldFormat
           ttSqlSchema.OElabel     = cLabel
           ttSqlSchema.OEvalmsg    = cValMsg
           .
  END.
  
  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.
  
  END METHOD.

METHOD PRIVATE VOID setProgressFieldProp
  ( INPUT icSqlTableName AS CHAR ) :
  /*------------------------------------------------------------------------------
    Purpose:
  ------------------------------------------------------------------------------*/
  DEF VAR bOk          AS LOG  NO-UNDO.
  DEF VAR cFldName     AS CHAR NO-UNDO.
  DEF VAR cFldType     AS CHAR NO-UNDO.
  DEF VAR cFldFormat   AS CHAR NO-UNDO.
  DEF VAR cLabel       AS CHAR NO-UNDO.
  DEF VAR cValMsg      AS CHAR NO-UNDO.
  
  FOR EACH ttSqlColumns
      :
    
    CASE ttSqlColumns.Data_Type:  
      WHEN "nvarchar" OR WHEN "varchar" OR WHEN "char" OR WHEN "varbinary" OR WHEN "binary" OR WHEN "text" THEN 
        ASSIGN cFldType = "CHARACTER"
               cFldFormat = 'x(80)'.
      WHEN "bit" THEN 
        ASSIGN cFldType = "LOGICAL"
               cFldFormat = 'True/False'.       
      WHEN "int" OR WHEN "smallint" OR WHEN "integer" OR WHEN "mediumint" THEN 
        ASSIGN cFldType = "INTEGER"
               cFldFormat = '->>>>>>>>>9'.       
      WHEN "tinyint" THEN 
        ASSIGN cFldType = "INTEGER"
               cFldFormat = '->>>>>>9'.       
      WHEN "bigint" THEN 
        ASSIGN cFldType = "INT64"
               cFldFormat = '->>>>>>>>>>>>9'.       
      WHEN "uniqueidentifier" THEN 
        ASSIGN cFldType = "CHARACTER"
               cFldFormat = 'x(50)'.       
      WHEN "datetime" OR WHEN "timestamp" THEN
        ASSIGN cFldType = "DATETIME"
               cFldFormat = '99.99.9999 HH:MM:SS'.
      WHEN "smalldatetime" OR WHEN "date" THEN
        ASSIGN cFldType = "DATE"
               cFldFormat = '99.99.9999'.
      WHEN "float" OR WHEN "numeric" OR WHEN "decimal" OR WHEN "real" THEN
        ASSIGN cFldType = "DECIMAL"
               cFldFormat = '->>>>,>>>,>>9.99'.
      WHEN "smallmoney" OR WHEN "money" THEN
        ASSIGN cFldType = "DECIMAL"
               cFldFormat = '->>>>,>>>,>>9.9999'.
      OTHERWISE NEXT.         
  /*        WHEN "text" THEN                          */
  /*          ASSIGN cFldType = "CLOB"                */
  /*                 cFldFormat = '  FORMAT "x(255)"'.*/
  /*        WHEN "image" THEN                         */
  /*          ASSIGN cFldType = "BLOB"                */
  /*                 cFldFormat = '  FORMAT "x(8)"'.  */
    END CASE.     
    
    ttSqlColumns.OETableName = REPLACE(icSqlTableName,"æ","a_e_").
    ttSqlColumns.OETableName = REPLACE(ttSqlColumns.OETableName,"ø","o_e_").
    ttSqlColumns.OETableName = REPLACE(ttSqlColumns.OETableName,"å","a_a_").
    ttSqlColumns.OETableName = REPLACE(ttSqlColumns.OETableName," ","__").
    IF LENGTH(ttSqlColumns.OETableName) > 32 THEN
      ttSqlColumns.OETableName = SUBSTR(ttSqlColumns.OETableName,1,32).
      
    cFldName = ttSqlColumns.Column_Name.    
    ttSqlColumns.ColNameLength = LENGTH(ttSqlColumns.Column_Name).
    cValMsg  = "".
    cLabel   = CAPS(SUBSTR(cFldName,1,1)) + SUBSTR(cFldName,2).
    cFldName = REPLACE(cFldName,"æ","a_e_").  
    cFldName = REPLACE(cFldName,"ø","o_e_").  
    cFldName = REPLACE(cFldName,"å","a_a_").  
    cFldName = REPLACE(cFldName," ","__").
    cFldName = REPLACE(cFldName,"(","#_#_").
    cFldName = REPLACE(cFldName,")","_#_#").
    
    IF KEYWORD(cFldName) NE ? THEN
      cFldName = cFldName + "_".

    IF ttSqlColumns.OEformat NE "" THEN
      ASSIGN cFldFormat = ttSqlColumns.OEformat
             cLabel     = ttSqlColumns.OElabel
             cValMsg    = ttSqlColumns.OEvalmsg
             .
    
    IF LENGTH(cFldName) > 32 THEN
      ASSIGN cValMsg  = cFldName
             cFldName = SUBSTR(cFldName,1,32).
  
    ASSIGN ttSqlColumns.OEdataType  = cFldType
           ttSqlColumns.OEFieldName = cFldName
           ttSqlColumns.OEformat    = cFldFormat
           ttSqlColumns.OElabel     = cLabel
           ttSqlColumns.OEvalmsg    = cValMsg
           .
  END.
  
  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.
  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL SqlCanFind( INPUT icSqlDb     AS CHAR
                                   ,INPUT icTableName AS CHAR
                                   ,INPUT icFieldList AS CHAR
                                   ,INPUT icOperList  AS CHAR
                                   ,INPUT icValueList AS CHAR):
    
    DEF VAR cDsType      AS CHAR NO-UNDO.
    DEF VAR ix           AS INT  NO-UNDO.
    DEF VAR cAblWhere    AS CHAR NO-UNDO.
    DEF VAR cFieldType   AS CHAR NO-UNDO.     
    DEF VAR httFill      AS HANDLE NO-UNDO.
    DEF VAR cLeftPar     AS CHAR NO-UNDO.  
    DEF VAR cRightPar    AS CHAR NO-UNDO.  
    DEF VAR bActivePar   AS LOG  NO-UNDO.
    DEF VAR cUsedFields  AS CHAR NO-UNDO.
    
    cDsType = getDsType(icSqlDb).
    
    CREATE TEMP-TABLE httFill.

    DO ix = 1 TO NUM-ENTRIES(icFieldList):
      cFieldType = getABLFieldABLType(icSqlDb, icTableName, ENTRY(ix,icFieldList)).
      IF NUM-ENTRIES(icFieldList) > ix AND ENTRY(ix + 1,icFieldList) = ENTRY(ix,icFieldList) THEN DO:
        IF ix > 1 AND ENTRY(ix - 1,icFieldList) = ENTRY(ix,icFieldList) THEN
          cLeftPar = "".
        ELSE
          cLeftPar = "(".    
        bActivePar = YES.  
      END.  
      ELSE IF ix > 1 AND ENTRY(ix - 1,icFieldList) = ENTRY(ix,icFieldList) THEN
        ASSIGN cRightPar = ")"
               bActivePar = YES.
       
      cAblWhere = cAblWhere + (IF cAblWhere NE "" THEN 
                                 (IF bActivePar THEN " OR " ELSE " AND ") 
                               ELSE "WHERE ")
                            + cLeftPar    
                            + ENTRY(ix,icFieldList)
                + ENTRY(ix,icOperList) + " "
                + (IF cFieldType = "CHARACTER" THEN "'" + ENTRY(ix,icValueList,"|") + "'"
                   ELSE IF cFieldType = "LOGICAL" THEN
                     (IF CAN-DO("YES,TRUE",ENTRY(ix,icValueList,"|")) THEN "YES" ELSE "NO")
                   ELSE ENTRY(ix,icValueList,"|"))
                + cRightPar.
      cLeftPar = "".      
      IF cRightPar = ")" THEN bActivePar = NO.       
      cRightPar = "".
      IF NOT CAN-DO(cUsedFields,ENTRY(ix,icFieldList)) THEN DO:
        cUsedFields = cUsedFields + (IF cUsedFields NE "" THEN "," ELSE "") + ENTRY(ix,icFieldList).
        httFill:ADD-NEW-FIELD (ENTRY(ix,icFieldList),cFieldType).
      END.           
    END.
    httFill:ADD-NEW-FIELD ("RowIdent1","CHARACTER").         
    httFill:ADD-NEW-FIELD ("RowCount","INTEGER").         
    httFill:TEMP-TABLE-PREPARE ("tt" + icTableName).

    ASSIGN sqlQueryHelper:SQLdb             = icSqlDb
           sqlQueryHelper:SQLstartRow       = 0
           sqlQueryHelper:SQLrowsToBatch    = 1
           sqlQueryHelper:ABLbuffersAndFields = icTableName + ";" + REPLACE(icFieldList,",",";")
           sqlQueryHelper:ABLqueryWhere     = cAblWhere
           .
    sqlQueryHelper:createSqlView().

    IF NOT sqlQueryHelper:fillTempTable(httFill:DEFAULT-BUFFER-HANDLE) THEN 
      sqlSchemaMessage = sqlQueryHelper:sqlQueryHelperMessage.
    ELSE DO:
      httFill:DEFAULT-BUFFER-HANDLE:FIND-FIRST ("WHERE true") NO-ERROR.
      RETURN httFill:DEFAULT-BUFFER-HANDLE:AVAIL.
    END.    
           
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

    FINALLY:
      DELETE OBJECT httFill.
    END FINALLY.  
  END METHOD.

/*------------------------------------------------------------------------------
 Purpose: Get complete schema - called from JBoxSchemaCache
 Notes:
------------------------------------------------------------------------------*/

METHOD PUBLIC HANDLE getSqlSchema 
   (INPUT icDbName AS CHAR,
    INPUT icSourceName AS CHAR,
    INPUT icDbType AS CHAR):

  hDsSqlSchema:EMPTY-DATASET ().
  sqlSchemaMessage = "".
  
  CASE icDbType:
    WHEN "mssql" THEN DO:
      IF getSqlData(icSourceName
                 + "|SELECT * FROM INFORMATION_SCHEMA.COLUMNS JOIN INFORMATION_SCHEMA.TABLES ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME WHERE INFORMATION_SCHEMA.TABLES.TABLE_TYPE <> 'VIEW'",hbttSqlSchema) THEN DO:
        setProgressProp(icDbName). 
    
        IF NOT getSqlData(icSourceName
             + "|SELECT Column_Name = col.name,Table_Name = t.name,Index_Name = ind.name,Unique_Index = ind.is_unique,Index_seq = ic.key_ordinal FROM 
               sys.indexes ind 
               INNER JOIN sys.index_columns ic ON  ind.object_id = ic.object_id and ind.index_id = ic.index_id 
               INNER JOIN sys.columns col ON ic.object_id = col.object_id and ic.column_id = col.column_id 
               INNER JOIN sys.tables t ON ind.object_id = t.object_id" 
             ,hbttSqlIndex) THEN 
          sqlSchemaMessage = "INFO - failed to get sql-indexes" + CHR(10) + sqlSchemaMessage.
      END.         
    END.
    
    WHEN "mysql" THEN DO:
      IF getSqlData(icSourceName
         + "|SELECT * FROM INFORMATION_SCHEMA.COLUMNS JOIN INFORMATION_SCHEMA.TABLES ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME  WHERE INFORMATION_SCHEMA.TABLES.TABLE_SCHEMA = '" + icDbName + "'",hbttSqlSchema) THEN DO:
        setProgressProp(icDbName). 
    
        IF NOT getSqlData(icSourceName
             + "|SELECT table_schema, table_name, index_name, column_name, index_name = 'PRIMARY' as unique_index,seq_in_index AS index_seq
                FROM information_schema.statistics
                WHERE table_schema = '" + icDbName + "'" 
             ,hbttSqlIndex) THEN 
          sqlSchemaMessage = "INFO - failed to get sql-indexes" + CHR(10) + sqlSchemaMessage.
      END.      
    END.
    
    WHEN "progressSql" OR WHEN "sqlexp" THEN DO:
      IF getSqlData(icSourceName
          + "|SELECT COL AS Column_name,SYSTABLES.TBL AS Table_Name, COLTYPE AS Data_Type, TBLTYPE AS Table_Type, WIDTH AS Character_Maximum_Length, FIELD_RPOS AS Ordinal_Position FROM SYSPROGRESS.SYSCOLUMNS_FULL JOIN SYSPROGRESS.SYSTABLES ON SYSTABLES.TBL = SYSCOLUMNS_FULL.TBL WHERE SYSTABLES.TBLTYPE = 'T'"      
                                     ,hbttSqlSchema) THEN DO:
        setProgressProp(icDbName). 
          
        IF NOT getSqlData(icSourceName
          + "|SELECT COLNAME AS Column_name,SYSTABLES.TBL AS Table_Name, IDXNAME AS Index_Name, IDXTYPE AS Unique_Index, IDXSEQ AS Index_seq FROM SYSPROGRESS.SYSINDEXES JOIN SYSPROGRESS.SYSTABLES ON SYSTABLES.TBL = SYSINDEXES.TBL WHERE SYSTABLES.TBLTYPE = 'T'"      
             ,hbttSqlIndex) THEN 
           sqlSchemaMessage = "INFO - failed to get sql-indexes" + CHR(10) + sqlSchemaMessage.
      END.       
    END.  
  END CASE.
  
  RETURN hDsSqlSchema.

  CATCH eErr AS Progress.Lang.Error :
    MESSAGE eErr:GetMessage(1)
    VIEW-AS ALERT-BOX.  
  END CATCH.

END METHOD.
    
  METHOD PUBLIC CHARACTER RealTable ( INPUT icTableName AS CHAR ):
  
  IF icTableName BEGINS "NOT EXIST " THEN icTableName = SUBSTR(icTableName,11).
  IF NUM-ENTRIES(icTableName,".") > 1 THEN icTableName = ENTRY(2,icTableName,".").
  icTableName = LEFT-TRIM(icTableName,"(").
  
  RETURN IF LENGTH(icTableName) > 5 AND icTableName MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(icTableName,4,2)) THEN 
           SUBSTR(icTableName,INDEX(icTableName,"_") + 1)
         ELSE icTableName.
  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Check if fiels are FK's (indexed) and also PK in another table. 
            Also does the lookup to verify the FK 
   Notes:   Returns blank if ok 
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER ValidateFK(INPUT icSqldb            AS CHAR
                                    ,INPUT icTableName        AS CHAR
                                    ,INPUT icFieldList        AS CHAR
                                    ,INPUT icChr1sepValueList AS CHAR
                                    ,INPUT icExcepFieldList   AS CHAR):
    
    DEF VAR cReturn         AS CHAR NO-UNDO.
    DEF VAR ix              AS INT  NO-UNDO.
    DEF VAR iy              AS INT  NO-UNDO.
    DEF VAR cIndexes        AS CHAR NO-UNDO.
    DEF VAR cSqlTable       AS CHAR NO-UNDO.
    DEF VAR cPKcols         AS CHAR NO-UNDO.
    DEF VAR cCheckCols      AS CHAR NO-UNDO.
    DEF VAR cCheckSqlTables AS CHAR NO-UNDO.
    DEF VAR cDsType         AS CHAR NO-UNDO.
                   
    cDsType = getDsType(icSqlDb).
    
    cSqlTable = getABLTableSQLName(icSqlDb, RealTable(icTableName)).
    
    cIndexes = getTableFKcolumnList(icSqlDb, icTableName).
    DO ix = 1 TO NUM-ENTRIES (cIndexes):
      cCheckCols = cCheckCols + (IF cCheckCols NE "" THEN "," ELSE "") + ENTRY(2,ENTRY(ix,cIndexes),";").
    END.
    DO ix = 1 TO NUM-ENTRIES(icFieldList):
      IF CAN-DO(cCheckCols,ENTRY(ix,icFieldList)) THEN DO:
        cCheckSqlTables = getSqlPrimaryKeyTablesForColumn(icSqlDb, cDsType, ENTRY(ix,icFieldList)).
        IF cCheckSqlTables NE "" THEN DO iy = 1 TO NUM-ENTRIES(cCheckSqlTables):
          cPKcols = getPrimaryKeyColumns(icSqldb,ENTRY(iy,cCheckSqlTables)).
          IF cPKcols = ENTRY(ix,icFieldList) THEN DO:
            IF NOT SqlCanFind(icSqlDb, ENTRY(iy,cCheckSqlTables), cPKcols,"=",ENTRY(ix,icChr1sepValueList,CHR(1))) THEN
              cReturn = cReturn + (IF cReturn NE "" THEN "," ELSE "") + ENTRY(iy,cCheckSqlTables). 
          END.  
        END.  
      END.  
    END.    

    RETURN cReturn.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

  END METHOD.
    
  DESTRUCTOR PUBLIC JBoxSqlSchemaHelper():

    
  END DESTRUCTOR.  
END CLASS.