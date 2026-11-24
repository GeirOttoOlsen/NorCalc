 
 /*------------------------------------------------------------------------
    File        : JBoxLookupDef
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : brynj
    Created     : Wed Feb 12 13:39:17 CET 2025
    Notes       : Table-name can be ommitted for global use 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxLookupDef:

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxLookupDef NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxLookupDef().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEF VAR cBuffersAndFields AS CHAR NO-UNDO.
  DEF VAR cSourceFileName   AS CHAR NO-UNDO.
  DEF VAR hBrowseOrQuery    AS HANDLE NO-UNDO. 
  DEF VAR cDbName           AS CHAR NO-UNDO.  
  DEF VAR cDsName           AS CHAR NO-UNDO.
  DEF VAR bsessionOnly      AS LOG  NO-UNDO.
   
  DEF TEMP-TABLE ttLookup
      FIELD DatasourceName    AS CHAR
      FIELD DatabaseName      AS CHAR
      FIELD TableName         AS CHAR
      FIELD FieldName         AS CHAR
      FIELD SourceProcName    AS CHAR
      FIELD LookupDatasource  AS CHAR
      FIELD LookupDatabase    AS CHAR
      FIELD LookupBaseTable   AS CHAR
      FIELD QueryDef          AS CHAR
      FIELD QueryString       AS CHAR
      FIELD LookupReturnField AS CHAR
      FIELD DropDownValueList AS CHAR
      FIELD sessionOnly       AS LOG
      FIELD RowIdent1         AS CHAR
      INDEX idxLookup IS UNIQUE DatasourceName DatabaseName TableName SourceProcName FieldName sessionOnly
      .  
   
         
  DEFINE PUBLIC PROPERTY CurrentDataSource       AS CHAR NO-UNDO GET. SET.   
  DEFINE PUBLIC PROPERTY CurrentLookupDataSource AS CHAR NO-UNDO GET. SET.   
  DEFINE PUBLIC PROPERTY httLookup               AS HANDLE NO-UNDO GET. PROTECTED SET.     


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC JBoxLookupDef (  ):
    httLookup = BUFFER ttLookup:TABLE-HANDLE.
    fetchLookupTable().
  END CONSTRUCTOR.


  METHOD PUBLIC VOID fetchLookupTable(  ):
    
    EMPTY TEMP-TABLE ttLookup.
    
    IF NOT JBoxServerAPI:Instance:GetMyTempTable("jbadmin_lookup_get_put.p","get",httLookup) THEN 
      JBoxServerAPI:Instance:viewCallMessage().
          
  END METHOD.

  METHOD PUBLIC VOID saveLookupTable(  ):
    FOR EACH ttLookup 
        WHERE ttLookup.TableName = ?:
      ttLookup.TableName = "".
    END.    
    IF NOT JBoxServerAPI:Instance:CallServerProc("jbadmin_lookup_get_put.p","put",httLookup) THEN 
      JBoxServerAPI:Instance:viewCallMessage().
    ELSE fetchLookupTable().

   RETURN.

  END METHOD.

  METHOD VOID setFieldLookup (INPUT icTableName         AS CHAR
                             ,INPUT icFieldName         AS CHAR
                             ,INPUT icQueryDef          AS CHAR
                             ,INPUT icQueryString       AS CHAR
                             ,INPUT icLookupReturnField AS CHAR):
                              
    THIS-OBJECT:setFieldLookup(icTableName, icFieldName, icQueryDef, icQueryString, icLookupReturnField, "", NO).
                                           
  END METHOD.                           

  METHOD VOID setFieldLookup (INPUT icTableName         AS CHAR
                             ,INPUT icFieldName         AS CHAR
                             ,INPUT icQueryDef          AS CHAR
                             ,INPUT icQueryString       AS CHAR
                             ,INPUT icLookupReturnField AS CHAR
                             ,INPUT ibSessionOnly       AS LOG):
                              
    THIS-OBJECT:setFieldLookup(icTableName, icFieldName, icQueryDef, icQueryString, icLookupReturnField, "", ibSessionOnly).
                                           
  END METHOD.                           

  METHOD VOID setFieldLookup (INPUT icTableName         AS CHAR
                             ,INPUT icFieldName         AS CHAR
                             ,INPUT icQueryDef          AS CHAR
                             ,INPUT icQueryString       AS CHAR
                             ,INPUT icLookupReturnField AS CHAR 
                             ,INPUT icSourceProcName    AS CHAR):
                               
    THIS-OBJECT:setFieldLookup(icTableName, icFieldName, icQueryDef, icQueryString, icLookupReturnField, icSourceProcName, NO).                           
  END METHOD.
  
  METHOD VOID setFieldLookup (INPUT icTableName         AS CHAR
                             ,INPUT icFieldName         AS CHAR
                             ,INPUT icQueryDef          AS CHAR
                             ,INPUT icQueryString       AS CHAR
                             ,INPUT icLookupReturnField AS CHAR 
                             ,INPUT icSourceProcName    AS CHAR
                             ,INPUT ibSessionOnly       AS LOG):
                               
    icTableName = setDsDb(icTableName).                   
                               
    FIND FIRST ttLookup
         WHERE ttLookup.DatasourceName = cDsName
           AND ttLookup.DatabaseName   = cDbName 
           AND ttLookup.TableName      = icTableName
           AND ttLookup.FieldName      = icFieldName
           AND ttLookup.SourceProcName = icSourceProcName
           AND ttLookup.sessionOnly    = ibSessionOnly
         NO-ERROR.
    IF NOT AVAIL ttLookup THEN DO:
      CREATE ttLookup.
      ASSIGN ttLookup.DatasourceName = cDsName
             ttLookup.DatabaseName   = cDbName
             ttLookup.TableName      = icTableName
             ttLookup.FieldName      = icFieldName
             ttLookup.SourceProcName = icSourceProcName
             ttLookup.sessionOnly    = ibSessionOnly
             .
    END.
    ASSIGN ttLookup.QueryDef    = icQueryDef
           ttLookup.LookupReturnField = icLookupReturnField
           ttLookup.LookupDatasource  = CurrentLookupDataSource
           .
  END METHOD.                           

  METHOD VOID setFieldDropDownQuery (INPUT icTableName   AS CHAR
                                    ,INPUT icFieldName   AS CHAR
                                    ,INPUT icQueryDef    AS CHAR
                                    ,INPUT icQueryString AS CHAR): 
                              
    THIS-OBJECT:setFieldDropDownQuery(icTableName, icFieldName, icQueryDef, icQueryString, "", NO).                                  
                                           
  END METHOD.                           

  METHOD VOID setFieldDropDownQuery (INPUT icTableName   AS CHAR
                                    ,INPUT icFieldName   AS CHAR
                                    ,INPUT icQueryDef    AS CHAR
                                    ,INPUT icQueryString AS CHAR
                                    ,INPUT ibSessionOnly AS LOG): 
                              
    THIS-OBJECT:setFieldDropDownQuery(icTableName, icFieldName, icQueryDef, icQueryString, "", ibSessionOnly).                                  
                                           
  END METHOD.                           

  METHOD VOID setFieldDropDownQuery (INPUT icTableName      AS CHAR
                                    ,INPUT icFieldName      AS CHAR
                                    ,INPUT icQueryDef       AS CHAR
                                    ,INPUT icQueryString    AS CHAR
                                    ,INPUT icSourceProcName AS CHAR):
             
    THIS-OBJECT:setFieldDropDownQuery(icTableName, icFieldName, icQueryDef, icQueryString, icSourceProcName, NO).                                  
  END METHOD.                                    

  METHOD VOID setFieldDropDownQuery (INPUT icTableName      AS CHAR
                                    ,INPUT icFieldName      AS CHAR
                                    ,INPUT icQueryDef       AS CHAR
                                    ,INPUT icQueryString    AS CHAR
                                    ,INPUT icSourceProcName AS CHAR
                                    ,INPUT ibSessionOnly    AS LOG):
                               
    icTableName = setDsDb(icTableName).                   
                               
    FIND FIRST ttLookup
         WHERE ttLookup.DatasourceName = cDsName
           AND ttLookup.DatabaseName   = cDbName 
           AND ttLookup.TableName      = icTableName
           AND ttLookup.FieldName      = icFieldName
           AND ttLookup.SourceProcName = icSourceProcName
           AND ttLookup.sessionOnly    = ibSessionOnly
         NO-ERROR.
    IF NOT AVAIL ttLookup THEN DO:
      CREATE ttLookup.
      ASSIGN ttLookup.DatasourceName = cDsName
             ttLookup.DatabaseName   = cDbName
             ttLookup.TableName      = icTableName
             ttLookup.FieldName      = icFieldName
             ttLookup.SourceProcName = icSourceProcName
             ttLookup.sessionOnly      = ibSessionOnly
             .
    END.
    ASSIGN ttLookup.QueryDef         = icQueryDef
           ttLookup.QueryString      = icQueryString
           ttLookup.LookupDatasource = CurrentLookupDataSource
           .
  END METHOD.                           

  METHOD VOID setFieldDropDownValueList (INPUT icTableName         AS CHAR
                                        ,INPUT icFieldName         AS CHAR
                                        ,INPUT icDropDownValueList AS CHAR): 
                              
    THIS-OBJECT:setFieldDropDropDownValueList(icTableName, icFieldName, icDropDownValueList, "", NO).                                          
                                           
  END METHOD.                           

  METHOD VOID setFieldDropDownValueList (INPUT icTableName         AS CHAR
                                        ,INPUT icFieldName         AS CHAR
                                        ,INPUT icDropDownValueList AS CHAR
                                        ,INPUT ibSessionOnly       AS LOG): 
                              
    THIS-OBJECT:setFieldDropDropDownValueList(icTableName, icFieldName, icDropDownValueList, "", ibSessionOnly).                                          
                                           
  END METHOD.                           

  METHOD VOID setFieldDropDropDownValueList (INPUT icTableName         AS CHAR
                                            ,INPUT icFieldName         AS CHAR
                                            ,INPUT icDropDownValueList AS CHAR
                                            ,INPUT icSourceProcName    AS CHAR):
    THIS-OBJECT:setFieldDropDropDownValueList(icTableName, icFieldName, icDropDownValueList, icSourceProcName, NO).                                          
  END METHOD.                                            

  METHOD VOID setFieldDropDropDownValueList (INPUT icTableName         AS CHAR
                                            ,INPUT icFieldName         AS CHAR
                                            ,INPUT icDropDownValueList AS CHAR
                                            ,INPUT icSourceProcName    AS CHAR
                                            ,INPUT ibSessionOnly       AS LOG):
                               
    icTableName = setDsDb(icTableName).                   
                               
    FIND FIRST ttLookup
         WHERE ttLookup.DatasourceName = cDsName
           AND ttLookup.DatabaseName   = cDbName 
           AND ttLookup.TableName      = icTableName
           AND ttLookup.FieldName      = icFieldName
           AND ttLookup.SourceProcName = icSourceProcName
           AND ttLookup.sessionOnly    = ibSessionOnly
         NO-ERROR.
    IF NOT AVAIL ttLookup THEN DO:
      CREATE ttLookup.
      ASSIGN ttLookup.DatasourceName = cDsName
             ttLookup.DatabaseName   = cDbName
             ttLookup.TableName      = icTableName
             ttLookup.FieldName      = icFieldName
             ttLookup.SourceProcName = icSourceProcName
             ttLookup.sessionOnly    = ibSessionOnly
             .
    END.
    ttLookup.DropDownValueList = icDropDownValueList.
    
  END METHOD.                           

  METHOD VOID assignFilterLookup (INPUT ioBrowse AS JBoxBrowse):
    
    cBuffersAndFields = ioBrowse:buffersAndFields.
    IF VALID-HANDLE(ioBrowse:DATABROWSE-PARENT-PROC) THEN
      cSourceFileName = ioBrowse:DATABROWSE-PARENT-PROC:FILE-NAME.
    ELSE
      cSourceFileName = ioBrowse:SOURCE-FILE-HANDLE:FILE-NAME. 

    hBrowseOrQuery = ioBrowse:BROWSE-HANDLE.

    setFilterLookup().    
  END.

  METHOD VOID assignFilterLookup (INPUT ioQuery AS JBoxQuery):
    
    cBuffersAndFields = ioQuery:buffersAndFields.
    cSourceFileName = ioQuery:SOURCE-FILE-HANDLE:FILE-NAME. 
    hBrowseOrQuery = ioQuery:QUERY-HANDLE.

    setFilterLookup().    
  END.
  
  METHOD PROTECTED VOID setFilterLookup().
    
    DEF VAR ix         AS INT  NO-UNDO.
    DEF VAR iy         AS INT  NO-UNDO.
    DEF VAR cDb        AS CHAR NO-UNDO.
    DEF VAR cTable     AS CHAR NO-UNDO.
    DEF VAR cFieldList AS CHAR NO-UNDO.
    DEF VAR cField     AS CHAR NO-UNDO.
    
    DO ix = 1 TO NUM-ENTRIES(cBuffersAndFields):
      cTable = ENTRY(1,ENTRY(ix,cBuffersAndFields),";").
      IF NUM-ENTRIES(cTable,".") > 1 THEN
        ASSIGN cDb    = ENTRY(1,cTable,".")
               cTable = ENTRY(2,cTable,".")
               .
      ELSE cDb = "".
      cTable = RealTable(cTable).
                     
      cFieldList = SUBSTR(ENTRY(ix,cBuffersAndFields),INDEX(ENTRY(ix,cBuffersAndFields),";") + 1).         
      DO iy = 1 TO NUM-ENTRIES(cFieldList,";"):
        cField = ENTRY(1,ENTRY(iy,cFieldList,";"),"|").
        FIND FIRST ttLookup
             WHERE ttLookup.DatasourceName = CurrentDataSource
               AND ttLookup.DatabaseName   = cDb
               AND ttLookup.TableName      = cTable
               AND ttLookup.SourceProcName = cSourceFileName
               AND ttLookup.FieldName      = cField
             NO-ERROR.
        IF NOT AVAIL ttLookup THEN     
          FIND FIRST ttLookup
               WHERE ttLookup.DatasourceName = CurrentDataSource
                 AND ttLookup.DatabaseName   = cDb
                 AND ttLookup.TableName      = cTable
                 AND ttLookup.SourceProcName = ""
                 AND ttLookup.FieldName      = cField
               NO-ERROR.
        IF NOT AVAIL ttLookup THEN     
          FIND FIRST ttLookup
               WHERE ttLookup.DatasourceName = CurrentDataSource
                 AND ttLookup.DatabaseName   = cDb
                 AND ttLookup.TableName      = ""
                 AND ttLookup.SourceProcName = ""
                 AND ttLookup.FieldName      = cField
               NO-ERROR.
               
        IF NOT AVAIL ttLookup THEN
          FIND FIRST ttLookup
               WHERE ttLookup.DatabaseName   = cDb
                 AND ttLookup.TableName      = cTable
                 AND ttLookup.SourceProcName = cSourceFileName
                 AND ttLookup.FieldName      = cField
               NO-ERROR.
        IF NOT AVAIL ttLookup THEN     
          FIND FIRST ttLookup
               WHERE ttLookup.DatabaseName   = cDb
                 AND ttLookup.TableName      = cTable
                 AND ttLookup.SourceProcName = ""
                 AND ttLookup.FieldName      = cField
               NO-ERROR.
        IF NOT AVAIL ttLookup THEN     
          FIND FIRST ttLookup
               WHERE ttLookup.DatabaseName   = cDb
                 AND ttLookup.TableName      = ""
                 AND ttLookup.SourceProcName = ""
                 AND ttLookup.FieldName      = cField
               NO-ERROR.
        IF NOT AVAIL ttLookup THEN     
          FIND FIRST ttLookup
               WHERE ttLookup.DatasourceName = CurrentDataSource
                 AND ttLookup.TableName      = ""
                 AND ttLookup.SourceProcName = ""
                 AND ttLookup.FieldName      = cField
               NO-ERROR.

        IF AVAIL ttLookup THEN DO:
          IF ttLookup.LookupReturnField NE "" THEN DO:
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterlookupfields_" + cField,ttLookup.QueryDef).
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterlookupquery_" + cField,ttLookup.QueryString).
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterlookupreturnfield_" + cField,ttLookup.LookupReturnField).
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterlookupdatasource_" + cField,ttLookup.LookupDatasource).
          END.
          ELSE IF ttLookup.DropDownValueList NE "" THEN 
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterdropdownvaluelist_" + cField,getDropDownValues(ttLookup.DropDownValueList)).
          ELSE DO:
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterdropdownfields_" + cField,ttLookup.QueryDef).
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterdropdownquery_" + cField,ttLookup.QueryString).
            DYNAMIC-FUNCTION("setAttribute",hBrowseOrQuery,"filterlookupdatasource_" + cField,ttLookup.LookupDatasource).
          END.  
        END.         
      END.  
    END.             
         
  END METHOD.                           

  METHOD PROTECTED CHARACTER setDsDb(INPUT icTableName AS CHAR):
    
    IF icTableName = "" THEN RETURN icTableName.
    
    ASSIGN cDsName = IF NUM-ENTRIES(icTableName,".") > 2 THEN ENTRY(1,icTableName,".") ELSE CurrentDataSource
           cDbName = IF NUM-ENTRIES(icTableName,".") > 2 THEN ENTRY(2,icTableName,".")
                     ELSE IF NUM-ENTRIES(icTableName,".") > 1 THEN ENTRY(1,icTableName,".") 
                     ELSE ""
                     .
    RETURN ENTRY(NUM-ENTRIES(icTableName,"."),icTableName,".").
  END.  

  METHOD PROTECTED CHARACTER getDropDownValues(INPUT icList AS CHAR):
    
    DEF VAR ix    AS INT  NO-UNDO.
    DEF VAR cList AS CHAR NO-UNDO.
    
    IF INDEX(icList,"|") = 0 THEN DO:
      IF INDEX(icList,";") > 0 THEN icList = REPLACE(icList,";","|").
      ELSE IF INDEX(icList,",") > 0 THEN icList = REPLACE(icList,",","|").
      DO ix = 1 TO NUM-ENTRIES(icList,"|"):
        cList = cList + (IF cList NE "" THEN "|" ELSE "") + ENTRY(ix,icList,"|") + "|" + ENTRY(ix,icList,"|"). 
      END.  
      RETURN cList.  
    END.  
    ELSE IF NUM-ENTRIES(icList,"|") MOD 2 NE 0 THEN DO:
      DO ix = 1 TO NUM-ENTRIES(icList,"|"):
        cList = cList + (IF cList NE "" THEN "|" ELSE "") + ENTRY(ix,icList,"|") + "|" + ENTRY(ix,icList,"|"). 
      END.  
      RETURN cList.
    END.    
    ELSE RETURN icList.
  END.  
  
  METHOD PUBLIC CHARACTER RealTable ( INPUT icTableName AS CHAR ):
  
  icTableName = LEFT-TRIM(icTableName,"(").
  
  RETURN IF LENGTH(icTableName) > 5 AND icTableName MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(icTableName,4,2)) THEN 
           SUBSTR(icTableName,INDEX(icTableName,"_") + 1)
         ELSE icTableName.
  
  END METHOD.
  
END CLASS.