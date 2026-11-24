 
 /*------------------------------------------------------------------------
    File        : JBoxMsSqlHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bryhasleadm
    Created     : Thu Oct 20 14:50:13 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxMsSqlHelper: 

  DEF TEMP-TabLE ttMsSqlSchema
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
    . 

  DEF TEMP-TABLE tt_file
      FIELD cFile-Name  AS CHAR
      FIELD cTbl-Type   AS CHAR
      FIELD cLDBname    AS CHAR
      FIELD cType       AS CHAR /* table / view */
      FIELD iFileNum    AS INT
      INDEX FileNum iFileNum.
      
  DEF TEMP-TABLE tt_field
      FIELD cField-Name AS CHAR
      FIELD cData-Type  AS CHAR
      FIELD cFormat     AS CHAR
      FIELD cLabel      AS CHAR
      FIELD iOrder      AS INT
      FIELD iExtent     AS INT
      FIELD iFileNum AS INT
      FIELD iFieldNum AS INT
      INDEX FileNum iFileNum
      INDEX FieldNum iFieldNum.

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxMsSqlHelper NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxMsSqlHelper().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEF PUBLIC PROPERTY hbttMsSqlSchema AS HANDLE NO-UNDO GET. PROTECTED SET.
  
  DEF VAR cSqlDbName AS CHAR NO-UNDO.
      
  CONSTRUCTOR PUBLIC JBoxMsSqlHelper ():
    SUPER ().
    hbttMsSqlSchema = BUFFER ttMsSqlSchema:HANDLE.
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC HANDLE getTtDef(INPUT icSqlDb AS CHAR, INPUT icBuffersAndFields AS CHAR ):
    
    DEF VAR ix           AS INT NO-UNDO.
    DEF VAR cFetchList   AS CHAR NO-UNDO.

    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      IF NOT CAN-FIND(FIRST tt_file WHERE tt_file.cLDBname = ENTRY(1,ENTRY(ix,icBuffersAndFields),";")) THEN
        cFetchList = cFetchList + (IF cFetchList NE "" THEN " OR " ELSE "WHERE ")
                   + "INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = '" + ENTRY(1,ENTRY(ix,icBuffersAndFields),";") + "'"
                   + ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
    END.  

    IF cFetchList NE "" THEN getTableSchema (icSqlDb,cFetchList). 
      
    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      IF NOT CAN-FIND(FIRST tt_file WHERE tt_file.cLDBname = ENTRY(1,ENTRY(ix,icBuffersAndFields),";")) THEN
        cFetchList = cFetchList + (IF cFetchList NE "" THEN " OR " ELSE "WHERE ")
                   + "INFORMATION_SCHEMA.COLUMNS.TABLE_NAME = '" + ENTRY(1,ENTRY(ix,icBuffersAndFields),";") + "'"
                   + ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
    END.  

  END METHOD.

  METHOD PUBLIC VOID getTableSchema (INPUT icSqlDb AS CHAR,INPUT icWhere AS CHAR ):
    
    DEF VAR ixFileNum    AS INT NO-UNDO.
    DEF VAR ixIdxNum     AS INT NO-UNDO.
    DEF VAR ixFieldNum   AS INT NO-UNDO.
    DEF VAR ix           AS INT NO-UNDO.
  
    IF JBoxServerAPI:Instance:GetMyTempTable("jbserv_get_sql_data.p"
      ,icSqlDb
      + "|SELECT * FROM INFORMATION_SCHEMA.COLUMNS JOIN INFORMATION_SCHEMA.TABLES ON INFORMATION_SCHEMA.TABLES.TABLE_NAME = INFORMATION_SCHEMA.COLUMNS.TABLE_NAME"
      + icWhere
      ,hbttMsSqlSchema) THEN DO:
        
      setProgressProp(icSqlDb). 
      
      run toexcelviafile.p (hbttMsSqlSchema,-2).
      
      FOR EACH tt_file BY tt_file.iFileNum DESC:
        ixFileNum = tt_file.iFileNum.
        LEAVE.
      END.
    
      FOR EACH ttMsSqlSchema
          WHERE ttMsSqlSchema.OETableName NE ""
          BREAK BY ttMsSqlSchema.OETableName
          :
        IF FIRST-OF(ttMsSqlSchema.OETableName) THEN DO:
  //        if ix > 2 then leave.
          CREATE tt_file.
          ASSIGN tt_file.cFile-Name = ttMsSqlSchema.OETableName
                 tt_file.cLDBname   = icSqlDb
                 tt_file.cTbl-Type  = "T"
                 tt_file.cType      = IF ttMsSqlSchema.Table_Type = "BASE TABLE" THEN "TABLE" ELSE "VIEW"
                 ixFileNum          = ixFileNum + 1
                 tt_file.iFileNum   = ixFileNum
                 ix                 = ix + 1
                 .
        END.  
              
        CREATE tt_field.
        ASSIGN tt_field.iFileNum    = tt_file.iFileNum
               ixFieldNum           = ixFieldNum + 1
               tt_field.iFieldNum   = ixFieldNum
               tt_field.cField-Name = ttMsSqlSchema.OEFieldName
               tt_field.cData-Type  = ttMsSqlSchema.OEdataType
               tt_field.cFormat     = ttMsSqlSchema.OEformat
               tt_field.cLabel      = ttMsSqlSchema.OElabel
               tt_field.iOrder      = ttMsSqlSchema.Ordinal_Position
               .
      END.
    END.
    ELSE JBoxServerAPI:Instance:viewCallMessage().
  
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
  
  FOR EACH ttMsSqlSchema
      WHERE CAN-DO("VIEW,BASE TABLE", ttMsSqlSchema.Table_Type)
        AND ttMsSqlSchema.Table_Name NE "sysdiagrams"
      :
    
    CASE ttMsSqlSchema.Data_Type:  
      WHEN "nvarchar" OR WHEN "varchar" OR WHEN "char" OR WHEN "varbinary" OR WHEN "binary" OR WHEN "text" THEN 
        ASSIGN cFldType = "CHARACTER"
               cFldFormat = 'x(' + STRING(MAX(1,MIN(ttMsSqlSchema.Character_Maximum_Length,100))) + ')'.       
      WHEN "bit" THEN 
        ASSIGN cFldType = "LOGICAL"
               cFldFormat = 'True/False'.       
      WHEN "int" OR WHEN "smallint" THEN 
        ASSIGN cFldType = "INTEGER"
               cFldFormat = '->>>>>>>>9'.       
      WHEN "tinyint" THEN 
        ASSIGN cFldType = "INTEGER"
               cFldFormat = '->>9'.       
      WHEN "bigint" THEN 
        ASSIGN cFldType = "INT64"
               cFldFormat = '->>>>>>>>>>9'.       
      WHEN "uniqueidentifier" THEN 
        ASSIGN cFldType = "CHARACTER"
               cFldFormat = 'x(50)'.       
      WHEN "datetime" THEN
        ASSIGN cFldType = "DATETIME"
               cFldFormat = '99.99.9999 HH:MM:SS'.
      WHEN "smalldatetime" THEN
        ASSIGN cFldType = "DATE"
               cFldFormat = '99.99.9999'.
      WHEN "float" OR WHEN "numeric" OR WHEN "decimal" OR WHEN "real" THEN
        ASSIGN cFldType = "DECIMAL"
               cFldFormat = '->>>,>>>,>>9.99'.
      WHEN "smallmoney" OR WHEN "money" THEN
        ASSIGN cFldType = "DECIMAL"
               cFldFormat = '->>,>>>,>>9.9999'.
      OTHERWISE NEXT.         
  /*        WHEN "text" THEN                          */
  /*          ASSIGN cFldType = "CLOB"                */
  /*                 cFldFormat = '  FORMAT "x(255)"'.*/
  /*        WHEN "image" THEN                         */
  /*          ASSIGN cFldType = "BLOB"                */
  /*                 cFldFormat = '  FORMAT "x(8)"'.  */
    END CASE.     
    
    ttMsSqlSchema.OETableName = REPLACE(ttMsSqlSchema.Table_Name,"æ","a_e_").
    ttMsSqlSchema.OETableName = REPLACE(ttMsSqlSchema.OETableName,"ø","o_e_").
    ttMsSqlSchema.OETableName = REPLACE(ttMsSqlSchema.OETableName,"å","a_a_").
    ttMsSqlSchema.OETableName = REPLACE(ttMsSqlSchema.OETableName," ","__").
    IF LENGTH(ttMsSqlSchema.Table_Name) > 32 THEN
      ttMsSqlSchema.OETableName = SUBSTR(ttMsSqlSchema.Table_Name,1,32).
      
    cFldName = ttMsSqlSchema.Column_Name.    
    ttMsSqlSchema.ColNameLength = LENGTH(ttMsSqlSchema.Column_Name).
    cValMsg  = "".
    cLabel   = CAPS(SUBSTR(cFldName,1,1)) + SUBSTR(cFldName,2).
    cFldName = REPLACE(cFldName,"æ","a_e_").  
    cFldName = REPLACE(cFldName,"ø","o_e_").  
    cFldName = REPLACE(cFldName,"å","a_a_").  
    cFldName = REPLACE(cFldName," ","__").
    cFldName = REPLACE(cFldName,"(","#_#_").
    cFldName = REPLACE(cFldName,")","_#_#").
    IF CAN-DO("value,status,alias,message,locked,text,userid,label,format,available,color,ascending",cFldName) THEN
      cFldName = cFldName + "_".
    
    IF LENGTH(cFldName) > 32 THEN
      ASSIGN cValMsg  = cFldName
             cFldName = SUBSTR(cFldName,1,32).
  
    ASSIGN ttMsSqlSchema.OEdataType  = cFldType
           ttMsSqlSchema.OEFieldName = cFldName
           ttMsSqlSchema.OEformat    = cFldFormat
           ttMsSqlSchema.OElabel     = cLabel
           ttMsSqlSchema.OEvalmsg    = cValMsg
           .
  END.
  
  
  END METHOD.
    
  DESTRUCTOR PUBLIC JBoxMsSqlHelper():

    
  END DESTRUCTOR.  
END CLASS.