 
/*------------------------------------------------------------------------
   File        : JBoxBE
   Purpose     : Provide standard CRUD operations on the database based on a dataset or temp-table
   Syntax      : 
   Description : 
   Author(s)   : brynj
   Created     : Mon Oct 07 17:39:27 CEST 2024
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxBE: 
  DEF VAR bCallAppserver  AS LOG       NO-UNDO.
  DEF VAR hMainTTOrDS     AS HANDLE    NO-UNDO.
  DEF VAR hMainBuffer     AS HANDLE    NO-UNDO.
  DEF VAR bDataset        AS LOG       NO-UNDO.
  DEF VAR oDsChildQuery   AS JBoxQuery NO-UNDO EXTENT.
  DEF VAR cDataSourceName AS CHAR      NO-UNDO.
  DEF VAR firstRowid      AS CHAR      NO-UNDO.
  DEF VAR iQueryNum       AS INT       NO-UNDO.    
  DEF VAR hHelperProc     AS HANDLE    NO-UNDO.                                      
  DEF VAR hCurrObject     AS HANDLE    NO-UNDO.
  DEF VAR hMainTempTable  AS HANDLE    NO-UNDO.
  DEF VAR oJBoxParser     AS JBoxJsonParser NO-UNDO.

  DEF TEMP-TABLE ttChildBaseQuery NO-UNDO
      FIELD baseQuery AS CHAR
      INDEX idxBaseQuery baseQuery.

  DEF TEMP-TABLE ttQueryWhere NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD queryWhere       AS CHAR
      .

  DEF TEMP-TABLE ttQuerySort NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD querySort        AS CHAR
      .

  DEF TEMP-TABLE ttQueryFilter NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD fieldList        AS CHAR
      FIELD operList         AS CHAR
      FIELD valueList        AS CHAR
      .

  DEF TEMP-TABLE ttQueryJoin NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD queryJoin        AS CHAR
      FIELD buffersAndFields AS CHAR
      .

  DEF TEMP-TABLE ttPreScanQueryJoin NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD joinBufferName   AS CHAR
      FIELD preScanQuery     AS CHAR
      .

  DEF TEMP-TABLE ttPreScanBaseQuery NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD preScanBaseQuery AS CHAR // sql first/last
      .
      
  DEF TEMP-TABLE ttChildDataSource NO-UNDO    
      FIELD bufferName       AS CHAR
      FIELD db_Name          AS CHAR
      FIELD dbBufferName     AS CHAR
      FIELD dataSourceName   AS CHAR 
      FIELD dataSourceType   AS CHAR
      FIELD hTTBuffer        AS HANDLE
      FIELD hTempTable       AS HANDLE
      .

  DEF TEMP-TABLE ttFillBufferOnDemand NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD fillOnDemand     AS LOG
      .

  DEF TEMP-TABLE ttChildRowsToBatch NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD rowsToBatch      AS INT
      FIELD keepPages        AS LOG
      .

  DEF TEMP-TABLE ttChildRecordCount NO-UNDO
      FIELD db_Name          AS CHAR
      FIELD bufferName       AS CHAR
      FIELD getRecordCount   AS LOG
      FIELD recordCount      AS INT
      FIELD numPages         AS INT
      FIELD currentPage      AS INT
      FIELD firstRowid       AS CHAR
      .

  DEF PUBLIC PROPERTY mainQuery            AS JBoxQuery NO-UNDO GET. PRIVATE SET.  

  DEF PUBLIC PROPERTY OEdbName            AS CHAR NO-UNDO GET. SET. 
  DEF PUBLIC PROPERTY customCreateProc    AS CHAR NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY customUpdateValProc AS CHAR NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY customDeleteValProc AS CHAR NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY postUpdateProc      AS CHAR NO-UNDO GET. SET. 
  DEF PUBLIC PROPERTY hSourceProc         AS HANDLE NO-UNDO GET. PRIVATE SET.
  DEF PUBLIC PROPERTY mainQueryTTBuffer   AS HANDLE NO-UNDO GET. SET.
  
  DEF PUBLIC PROPERTY dynamicDeleteValidation AS LOG NO-UNDO
      GET(): RETURN customDeleteValProc = "ignore". END GET. 
      SET(ibSetting AS LOG): 
        IF ibSetting THEN customDeleteValProc = "ignore".  
      END SET.

  DEF PUBLIC PROPERTY dynamicUpdateValidation AS LOG 
      GET(): RETURN customUpdateValProc = "ignore". END GET. 
      SET(ibSetting AS LOG): 
        IF ibSetting THEN customUpdateValProc = "ignore".  
      END SET.
                     
  DEF PUBLIC PROPERTY bufferExtraFields   AS CHAR NO-UNDO GET. SET. 
  DEF PUBLIC PROPERTY bufferExtraValues   AS CHAR NO-UNDO GET. 
      SET(icSetting AS CHAR): 
        bufferExtraValues = REPLACE(icSetting,"|",CHR(1)).
      END SET.

  DEF PUBLIC PROPERTY serverTransInputParam AS CHAR GET. SET.  
      
  DEF PUBLIC PROPERTY serverTransReturnParam AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getServerTransReturnParam"). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY serverTransReturnMessage AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getServerTransReturnMessage"). END GET. 
      PROTECTED SET.
       
  DEF PUBLIC PROPERTY checkModified AS LOG NO-UNDO GET. SET. 
       
  DEF PUBLIC PROPERTY commitPrBuffer AS LOG NO-UNDO GET. SET.
  
  DEF PUBLIC PROPERTY rowsToBatch AS INT NO-UNDO GET. SET.

  DEF PUBLIC PROPERTY querySort   AS CHAR NO-UNDO GET. SET.
  
  DEF PUBLIC PROPERTY keepPages   AS LOG NO-UNDO INIT YES GET. 
    SET (INPUT ibSet AS LOG):
      mainQuery:keepData = ibSet.
      keepPages = ibSet.  
    END SET.
    
  DEF PUBLIC PROPERTY numPages    AS INT NO-UNDO GET. PRIVATE SET.
        
  DEF PUBLIC PROPERTY currentPage AS INT NO-UNDO GET. SET.

  DEF PUBLIC PROPERTY atFirstPage AS LOG NO-UNDO 
      GET:
        IF NOT VALID-OBJECT(mainQuery) THEN RETURN ?.    
        RETURN currentPage = 1.
      END GET. 
      PRIVATE SET.

  DEF PUBLIC PROPERTY atLastPage AS LOG NO-UNDO 
      GET:
        IF NOT VALID-OBJECT(mainQuery) THEN RETURN ?.
        IF numPages NE ? AND numPages > 0 THEN    
          RETURN currentPage = numPages.
        ELSE RETURN mainQuery:getJBoxAttribute("lastrowid") NE "".  
      END GET. 
      PRIVATE SET.
  
  DEF PUBLIC PROPERTY getRecordCountMainQuery AS LOG NO-UNDO GET. SET. 
      
  DEF PUBLIC PROPERTY mainQueryRecordCount AS INT NO-UNDO GET. PRIVATE SET.    
      
  DEF PUBLIC PROPERTY dsTablePrefix AS CHAR NO-UNDO GET. SET.    
      
  CONSTRUCTOR PUBLIC JBoxBE (ihTempTableOrDs  AS HANDLE
                            ,icDataSourceName AS CHAR):
                              
    DEF VAR hAps AS HANDLE NO-UNDO.
    SUPER ().
    hAps = DYNAMIC-FUNCTION("getAppserviceHandle") NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN
      bCallAppserver = (hAps NE ? AND hAps NE SESSION) OR (PROGRESS = "full" AND SESSION:CLIENT-TYPE = "4GLclient").
    ELSE bCallAppserver = NO.  
       
    ASSIGN
      hSourceProc = SOURCE-PROCEDURE 
      hMainTTOrDS = (IF ihTempTableOrDs:TYPE = "buffer" THEN ihTempTableOrDs:TABLE-HANDLE ELSE ihTempTableOrDs)
      bDataset    = hMainTTOrDS:TYPE = "dataset"
      hMainBuffer = IF bDataset THEN hMainTTOrDS:GET-BUFFER-HANDLE (1) ELSE hMainTTOrDS:DEFAULT-BUFFER-HANDLE
      oJBoxParser = NEW JBoxJsonParser()  
      .
      
    IF CAN-DO("webclient,4glclient",SESSION:CLIENT-TYPE) AND NOT SESSION:BATCH-MODE THEN  
      cDataSourceName = JBoxServerApi:Instance:getDataSourceConnection (icDataSourceName).
    ELSE  
      cDataSourceName = JBoxServerSide:Instance:getDataSourceConnection (icDataSourceName).
    IF cDataSourceName = "" THEN
      cDataSourceName = icDataSourceName.
      
    IF bDataset THEN
      EXTENT(oDsChildQuery) = hMainTTOrDS:NUM-BUFFERS - 1.

/*    RUN JBoxBEhelper.p PERSIST SET hHelperProc(THIS-OBJECT).*/
  END CONSTRUCTOR.

  METHOD PRIVATE VOID createChildQuery (iiQueryNum AS INT):
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR cJoin AS CHAR NO-UNDO.
    DEF VAR cBufferName AS CHAR NO-UNDO.
    DEF VAR cDbName     AS CHAR NO-UNDO.
        
    cBufferName = (IF hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):ADM-DATA NE "" AND hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):ADM-DATA NE ? THEN
                     hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):ADM-DATA
                   ELSE IF hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):TABLE-HANDLE:ADM-DATA NE "" AND hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):TABLE-HANDLE:ADM-DATA NE ? THEN
                     hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):TABLE-HANDLE:ADM-DATA
                   ELSE hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):NAME).
    cDbName     = (IF hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):PRIVATE-DATA NE "" AND hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):PRIVATE-DATA NE ? THEN
                     hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):PRIVATE-DATA
                   ELSE IF hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):TABLE-HANDLE:PRIVATE-DATA NE "" AND hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):TABLE-HANDLE:PRIVATE-DATA NE ? THEN
                     hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):TABLE-HANDLE:PRIVATE-DATA
                   ELSE "").
    
    IF dsTablePrefix NE "" AND SUBSTR(cBufferName,1,LENGTH(dsTablePrefix)) = dsTablePrefix THEN
      cBufferName = SUBSTR(cBufferName,LENGTH(dsTablePrefix) + 1).
    
    FIND FIRST ttChildDataSource 
         WHERE ttChildDataSource.bufferName = cBufferName
         NO-ERROR.
    
    IF AVAIL ttChildDataSource AND VALID-HANDLE(ttChildDataSource.hTTBuffer) THEN DO:
      DELETE OBJECT ttChildDataSource.hTempTable NO-ERROR.
      CREATE TEMP-TABLE ttChildDataSource.hTempTable.
      ttChildDataSource.hTempTable:CREATE-LIKE(ttChildDataSource.hTTBuffer).
      ttChildDataSource.hTempTable:ADD-NEW-FIELD("localRowid","CHARACTER").
      ttChildDataSource.hTempTable:TEMP-TABLE-PREPARE (ttChildDataSource.hTTBuffer:NAME).
      oJBoxParser:deepCopyTT(ttChildDataSource.hTTBuffer, ttChildDataSource.hTempTable).
      oDsChildQuery[iiQueryNum] = NEW JboxQuery(ttChildDataSource.hTempTable).
    END.  
    ELSE IF AVAIL ttChildDataSource THEN             
      oDsChildQuery[iiQueryNum] = NEW JboxQuery(getBufferAndFields(hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1),ttChildDataSource.dbBufferName)
                                  ,ttChildDataSource.dataSourceName).
    ELSE             
      oDsChildQuery[iiQueryNum] = NEW JboxQuery(getBufferAndFields(hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1),cBufferName)
                                  ,cDataSourceName).

    oDsChildQuery[iiQueryNum]:rowsToBatch = 0.
    DYNAMIC-FUNCTION ("setObjectSourceFileHandle",oDsChildQuery[iiQueryNum]:QUERY-HANDLE,hSourceProc).
    
    IF AVAIL ttChildDataSource AND ttChildDataSource.hTTBuffer NE ? THEN
      oDsChildQuery[iiQueryNum]:useLocalData = YES.
    
    IF AVAIL ttQueryJoin THEN DO: 
      oDsChildQuery[iiQueryNum]:queryJoin = "," + TRIM(ttQueryJoin.queryJoin,",").
      DO ix = 1 TO NUM-ENTRIES(ttQueryJoin.queryJoin):
        cJoin = TRIM(ENTRY(ix,ttQueryJoin.queryJoin)).
        REPEAT WHILE INDEX(cJoin,"  ") > 0:
          cJoin = REPLACE(cJoin,"  "," ").
        END.
        IF NUM-ENTRIES(cJoin," ") < 2 THEN NEXT.   
        oDsChildQuery[iiQueryNum]:setJBoxAttribute("bufferDb" + ENTRY(NUM-ENTRIES(ENTRY(2,cJoin," "),"."),ENTRY(2,cJoin," "),"."),ttChildDataSource.db_Name).
      END.  
    END.  

    IF AVAIL ttChildDataSource THEN
      oDsChildQuery[iiQueryNum]:setJBoxAttribute("bufferDb" + ttChildDataSource.bufferName,ttChildDataSource.db_Name).
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
     
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID createMainQuery(  ):
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR cJoin AS CHAR NO-UNDO.
    DEF VAR cBufferName AS CHAR NO-UNDO.
    
    IF VALID-HANDLE(mainQueryTTBuffer) THEN DO:
      DELETE OBJECT hMainTempTable NO-ERROR.
      CREATE TEMP-TABLE hMainTempTable.
      hMainTempTable:CREATE-LIKE(mainQueryTTBuffer).
      hMainTempTable:ADD-NEW-FIELD("localRowid","CHARACTER").
      hMainTempTable:TEMP-TABLE-PREPARE (mainQueryTTBuffer:NAME).
      oJBoxParser:deepCopyTT(mainQueryTTBuffer, hMainTempTable).
//      hMainTempTable:COPY-TEMP-TABLE (mainQueryTTBuffer,NO,YES,YES).
      mainQuery = NEW JboxQuery(hMainTempTable).
      mainQuery:useLocalData = YES.
    END.  
    ELSE DO:
      cBufferName = hMainBuffer:NAME.
      IF dsTablePrefix NE "" AND SUBSTR(cBufferName,1,LENGTH(dsTablePrefix)) = dsTablePrefix THEN
        cBufferName = SUBSTR(cBufferName,LENGTH(dsTablePrefix) + 1).
      mainQuery = NEW JBoxQuery(getBufferAndFields(hMainBuffer,cBufferName),cDataSourceName).
    END.  
    DYNAMIC-FUNCTION ("setObjectSourceFileHandle",mainQuery:QUERY-HANDLE,hSourceProc).
    IF AVAIL ttQueryJoin THEN DO: 
      mainQuery:queryJoin = "," + TRIM(ttQueryJoin.queryJoin,",").
      
      DO ix = 1 TO NUM-ENTRIES(ttQueryJoin.queryJoin):
        cJoin = TRIM(ENTRY(ix,ttQueryJoin.queryJoin)).
        REPEAT WHILE INDEX(cJoin,"  ") > 0:
          cJoin = REPLACE(cJoin,"  "," ").
        END.
        IF NUM-ENTRIES(cJoin," ") < 2 THEN NEXT.   
        mainQuery:setJBoxAttribute("bufferDb" + ENTRY(NUM-ENTRIES(ENTRY(2,cJoin," "),"."),ENTRY(2,cJoin," "),"."),ttQueryJoin.db_Name).
      END.  
    END.
    
  END METHOD.

  METHOD PUBLIC LOGICAL getAtFirstPage (icBufferName AS CHAR):
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN ?.    
    IF icBufferName NE "" THEN    
      iQueryNum = getChildQueryNum("",icBufferName).
    ELSE RETURN atFirstPage.

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.
    IF AVAIL ttChildRecordCount THEN
      RETURN ttChildRecordCount.currentPage = 1.
    ELSE RETURN oDsChildQuery[iQueryNum]:getJBoxAttribute("firstrowid") NE "".       
  END METHOD.

  METHOD PUBLIC LOGICAL getAtFirstPage (icDbName AS CHAR,icBufferName AS CHAR):
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN ?.    
    IF icBufferName NE "" THEN    
      iQueryNum = getChildQueryNum(icDbName,icBufferName).
    ELSE RETURN atFirstPage.

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.
    IF AVAIL ttChildRecordCount THEN
      RETURN ttChildRecordCount.currentPage = 1.
    ELSE RETURN oDsChildQuery[iQueryNum]:getJBoxAttribute("firstrowid") NE "".       
  END METHOD.

  METHOD PUBLIC LOGICAL getAtLastPage (icBufferName AS CHAR):
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN ?.    
    IF icBufferName NE "" THEN    
      iQueryNum = getChildQueryNum("",icBufferName).
    ELSE RETURN atLastPage.

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.
    IF AVAIL ttChildRecordCount THEN
      RETURN ttChildRecordCount.currentPage = ttChildRecordCount.numPages.
    ELSE RETURN oDsChildQuery[iQueryNum]:getJBoxAttribute("lastrowid") NE "".       
  END METHOD.

  METHOD PUBLIC LOGICAL getAtLastPage (icDbName AS CHAR,icBufferName AS CHAR):
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN ?.    
    IF icBufferName NE "" THEN    
      iQueryNum = getChildQueryNum(icDbName,icBufferName).
    ELSE RETURN atLastPage.

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.
    IF AVAIL ttChildRecordCount THEN
      RETURN ttChildRecordCount.currentPage = ttChildRecordCount.numPages.
    ELSE RETURN oDsChildQuery[iQueryNum]:getJBoxAttribute("lastrowid") NE "".       
  END METHOD.

  METHOD PUBLIC LOGICAL getChild (icBufferName AS CHAR ):
    RETURN getChild("",icBufferName).
  END.  

  METHOD PUBLIC LOGICAL getChild (icDbName AS CHAR, icBufferName AS CHAR ):

    DEF VAR ix                 AS INT  NO-UNDO.
    DEF VAR iy                 AS INT  NO-UNDO.
    DEF VAR cBaseQuery         AS CHAR NO-UNDO.
    DEF VAR iQueryNum          AS INT  NO-UNDO.
    DEF VAR cQueryWhere        AS CHAR NO-UNDO.
    DEF VAR cRelFields         AS CHAR NO-UNDO.
    DEF VAR cParentFieldType   AS CHAR NO-UNDO.
    DEF VAR cChildFieldType    AS CHAR NO-UNDO.
    DEF VAR iNumFlds           AS INT  NO-UNDO.
    DEF VAR hParentFlds        AS HANDLE NO-UNDO EXTENT.
    DEF VAR bBaseQueryOrFilter AS LOG  NO-UNDO.

    hCurrObject = DYNAMIC-FUNCTION("getCurrentObject").

    DO ix = 2 TO hMainTTOrDS:NUM-BUFFERS:
      IF hMainTTOrDS:GET-BUFFER-HANDLE(ix):TABLE-HANDLE:ADM-DATA NE "" AND hMainTTOrDS:GET-BUFFER-HANDLE (ix):ADM-DATA NE ?
         AND hMainTTOrDS:GET-BUFFER-HANDLE (ix):ADM-DATA = icBufferName
         AND hMainTTOrDS:GET-BUFFER-HANDLE (ix):PRIVATE-DATA = icDbName THEN DO: 
          hMainTTOrDS:GET-BUFFER-HANDLE (ix):EMPTY-TEMP-TABLE().
          iQueryNum = ix - 1.
          LEAVE.
        END.
    END.
    IF iQueryNum = 0 THEN
      DO ix = 2 TO hMainTTOrDS:NUM-BUFFERS:
        IF hMainTTOrDS:GET-BUFFER-HANDLE(ix):NAME = icBufferName THEN DO:       
          hMainTTOrDS:GET-BUFFER-HANDLE (ix):EMPTY-TEMP-TABLE().
          iQueryNum = ix - 1.
          LEAVE.
        END.
      END.
    IF iQueryNum = 0 THEN DO:
      MESSAGE "Buffer" icBufferName "is not a (child) buffer in the dataset"
      VIEW-AS ALERT-BOX.                             
      RETURN NO.
    END.
    IF NOT hMainTTOrDS:GET-RELATION(iQueryNum):PARENT-BUFFER:AVAIL THEN RETURN NO.
        
    ASSIGN cRelFields = hMainTTOrDS:GET-RELATION(iQueryNum):RELATION-FIELDS
           iNumFlds = NUM-ENTRIES(cRelFields) / 2
           EXTENT(hParentFlds) = iNumFlds
           .
    
    DO ix = 1 TO NUM-ENTRIES(cRelFields) BY 2:
      iy = iy + 1.
      cParentFieldType = hMainTTOrDS:GET-RELATION(iQueryNum):PARENT-BUFFER:BUFFER-FIELD(ENTRY(ix,cRelFields)):DATA-TYPE.
      cChildFieldType  = hMainTTOrDS:GET-RELATION(iQueryNum):PARENT-BUFFER:BUFFER-FIELD(ENTRY(ix + 1,cRelFields)):DATA-TYPE.

      cBaseQuery = cBaseQuery + (IF cBaseQuery NE "" THEN " AND " ELSE "WHERE (")
//                        + hMainTTOrDS:GET-RELATION(iiQueryNum):CHILD-BUFFER:NAME + "."
                 + ENTRY(ix + 1,cRelFields) + " = "
                 .

      hParentFlds[iy] = hMainTTOrDS:GET-RELATION(iQueryNum):PARENT-BUFFER:BUFFER-FIELD(ENTRY(ix,cRelFields)).
                        
      IF cChildFieldType = "CHARACTER" THEN                  
        cBaseQuery = cBaseQuery + "'".
      ELSE IF cChildFieldType NE cParentFieldType THEN DO: 
        IF cChildFieldType = "CHARACTER" THEN                  
          cBaseQuery = cBaseQuery + "STRING('".
        ELSE  
          cBaseQuery = cBaseQuery + cChildFieldType + "('".
      END.  
        
      cBaseQuery = cBaseQuery + "<subst>" + STRING(iy).
        
      IF cChildFieldType NE cParentFieldType THEN 
        cBaseQuery = cBaseQuery + "')".
    END.
    
    FIND FIRST ttQueryWhere
         WHERE ttQueryWhere.bufferName = icBufferName
         NO-ERROR.

    FIND FIRST ttQueryFilter
         WHERE ttQueryFilter.bufferName = icBufferName
           AND ttQueryFilter.fieldList NE ""
         NO-ERROR.
    
    FOR EACH ttPreScanQueryJoin 
        WHERE ttPreScanQueryJoin.bufferName = icBufferName:
      oDsChildQuery[iQueryNum]:setPreScanQuery(ttPreScanQueryJoin.joinBufferName,ttPreScanQueryJoin.preScanQuery).    
    END.      
    
    DO ix = 1 TO iNumFlds:
      ASSIGN cBaseQuery = REPLACE(cBaseQuery,"<subst>" + STRING(ix),"&1")
             cBaseQuery = SUBSTITUTE(cBaseQuery,hParentFlds[ix]:BUFFER-VALUE)
             .
    END.

    oDsChildQuery[iQueryNum]:baseQuery = cBaseQuery + ")".

    IF AVAIL ttQueryFilter THEN
      oDsChildQuery[iQueryNum]:setFilter(ttQueryFilter.fieldList,ttQueryFilter.operList,ttQueryFilter.valueList).
    
    IF AVAIL ttQueryWhere THEN
      oDsChildQuery[iQueryNum]:queryWhere = IF TRIM(ttQueryWhere.queryWhere) BEGINS "WHERE " THEN
                                              " AND (" + SUBSTR(TRIM(ttQueryWhere.queryWhere),7) + ")"
                                            ELSE ttQueryWhere.queryWhere.  
    
    FIND FIRST ttChildRowsToBatch
         WHERE ttChildRowsToBatch.bufferName = icBufferName
         NO-ERROR.
    IF AVAIL ttChildRowsToBatch THEN
      oDsChildQuery[iQueryNum]:rowsToBatch = ttChildRowsToBatch.rowsToBatch.
      
    FIND FIRST ttQuerySort
         WHERE ttQuerySort.bufferName = icBufferName
         NO-ERROR.
    IF AVAIL ttQuerySort THEN
      oDsChildQuery[iQueryNum]:setQuerySort(ttQuerySort.querySort).       

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.
    IF AVAIL ttChildRecordCount THEN
      oDsChildQuery[iQueryNum]:getRecordCount = AVAIL ttChildRecordCount.
    
    oDsChildQuery[iQueryNum]:batchQueryStart = 1.
    oDsChildQuery[iQueryNum]:setJBoxAttribute("querystart","0").
    oDsChildQuery[iQueryNum]:setJBoxAttribute("querydir","").
    oDsChildQuery[iQueryNum]:openQuery().

    IF AVAIL ttChildRowsToBatch AND AVAIL ttChildRecordCount THEN
      ASSIGN ttChildRecordCount.RecordCount = oDsChildQuery[iQueryNum]:recordCount
             ttChildRecordCount.numPages = TRUNC(ttChildRecordCount.RecordCount / ttChildRowsToBatch.rowsToBatch,0)
                                         + (IF ttChildRecordCount.RecordCount MOD ttChildRowsToBatch.rowsToBatch > 0 THEN 1 ELSE 0)
             ttChildRecordCount.firstRowid = oDsChildQuery[iQueryNum]:getJBoxAttribute("firstRowid")
             ttChildRecordCount.currentPage = 1                             
             oDsChildQuery[iQueryNum]:getRecordCount = NO.
    
    fillDatasetChildren(iQueryNum + 1,YES).

    FINALLY:        
      IF VALID-HANDLE(hCurrObject) THEN   
        DYNAMIC-FUNCTION("setCurrentObject",hCurrObject).
    END.  
  END.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE VOID fillChildBuffer( iiQueryNum AS INT ):

    DEF VAR cChildBaseQuery    AS CHAR NO-UNDO.
    DEF VAR iExprCnt           AS INT  NO-UNDO.  
    DEF VAR bOneField          AS LOG  NO-UNDO.
    DEF VAR httSubQuery        AS HANDLE NO-UNDO. // temp. storage
    DEF VAR cBufferName        AS CHAR NO-UNDO.
    DEF VAR iRecordCount       AS INT  NO-UNDO.
    DEF VAR bUseSingleQuote    AS LOG  NO-UNDO.
    DEF VAR bUseDoubleQuote    AS LOG  NO-UNDO.
    DEF VAR iNum_OR_oper       AS INT  NO-UNDO.
       
    hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):EMPTY-TEMP-TABLE().                             

    setDsChildBaseQuery(iiQueryNum).
    
    cBufferName = hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1):NAME.
        
    FIND FIRST ttQueryWhere
         WHERE ttQueryWhere.bufferName = cBufferName
         NO-ERROR.

    FIND FIRST ttQueryFilter
         WHERE ttQueryFilter.bufferName = cBufferName
           AND ttQueryFilter.fieldList NE ""
         NO-ERROR.
    
    FOR EACH ttPreScanQueryJoin 
        WHERE ttPreScanQueryJoin.bufferName = cBufferName:
      oDsChildQuery[iiQueryNum]:setPreScanQuery(ttPreScanQueryJoin.joinBufferName,ttPreScanQueryJoin.preScanQuery).    
    END.      
          
    FIND FIRST ttPreScanBaseQuery
         WHERE ttPreScanBaseQuery.bufferName = cBufferName
         NO-ERROR.
    IF AVAIL ttPreScanBaseQuery THEN
      oDsChildQuery[iiQueryNum]:preScanBaseQuery = ttPreScanBaseQuery.preScanBaseQuery.     
          
    FIND FIRST ttChildRowsToBatch 
         WHERE ttChildRowsToBatch.bufferName = cBufferName
         NO-ERROR.
    IF AVAIL ttChildRowsToBatch THEN
      oDsChildQuery[iiQueryNum]:rowsToBatch = ttChildRowsToBatch.rowsToBatch.
      
    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.bufferName = cBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.           
          
    FIND FIRST ttChildBaseQuery NO-ERROR.
    IF AVAIL ttChildBaseQuery THEN DO:
      bOneField = NUM-ENTRIES(ttChildBaseQuery.baseQuery," ") < 4.
      bUseSingleQuote = INDEX(ttChildBaseQuery.baseQuery,"'") > 0 AND NUM-ENTRIES(ttChildBaseQuery.baseQuery,"'") < 3.
      bUseDoubleQuote = INDEX(ttChildBaseQuery.baseQuery,'"') > 0.
      cChildBaseQuery = "WHERE (" + IF bOneField THEN "" ELSE "(".
      FOR EACH ttChildBaseQuery:
        cChildBaseQuery = cChildBaseQuery + ttChildBaseQuery.baseQuery
                        + (IF bUseSingleQuote THEN "'"
                           ELSE IF bUseDoubleQuote THEN '"'
                           ELSE "")
                        + (IF bOneField THEN "" ELSE ")")
                        + " OR "
                        + (IF bOneField THEN "" ELSE "(")
                        .
        iNum_OR_oper = iNum_OR_oper + 1.                
        
        IF LENGTH(cChildBaseQuery) > 5000 OR iNum_OR_oper > 240 THEN DO:
          iNum_OR_oper = 0.
          IF NOT bOneField THEN 
            cChildBaseQuery = SUBSTR(cChildBaseQuery,1,LENGTH(cChildBaseQuery) - 5).
          ELSE
            cChildBaseQuery = SUBSTR(cChildBaseQuery,1,LENGTH(cChildBaseQuery) - 4).
          oDsChildQuery[iiQueryNum]:baseQuery = cChildBaseQuery + ")".
          IF AVAIL ttQueryFilter THEN 
            oDsChildQuery[iiQueryNum]:setFilter(ttQueryFilter.fieldList,ttQueryFilter.operList,ttQueryFilter.valueList).
          IF AVAIL ttQueryWhere THEN
            oDsChildQuery[iiQueryNum]:queryWhere = IF TRIM(ttQueryWhere.queryWhere) BEGINS "WHERE " THEN
                                                     " AND (" + SUBSTR(TRIM(ttQueryWhere.queryWhere),7) + ")"
                                                   ELSE ttQueryWhere.queryWhere.  
          oDsChildQuery[iiQueryNum]:setJBoxAttribute("querydir","").
          
          oDsChildQuery[iiQueryNum]:getRecordCount = AVAIL ttChildRecordCount.
                                                   
          oDsChildQuery[iiQueryNum]:openQuery().
          IF NOT VALID-HANDLE(httSubQuery) THEN DO:
            CREATE TEMP-TABLE httSubQuery.
            httSubQuery:CREATE-LIKE(oDsChildQuery[iiQueryNum]:BUFFER-HANDLE).
            httSubQuery:TEMP-TABLE-PREPARE ("ttSubQuery").
          END.
          httSubQuery:COPY-TEMP-TABLE (oDsChildQuery[iiQueryNum]:BUFFER-HANDLE,YES).
          cChildBaseQuery = "WHERE (" + IF bOneField THEN "" ELSE "(".
          IF AVAIL ttChildRecordCount THEN
            iRecordCount = oDsChildQuery[iiQueryNum]:recordCount.
          NEXT.
        END.  
      END.                  
      IF NOT bOneField THEN 
        cChildBaseQuery = SUBSTR(cChildBaseQuery,1,LENGTH(cChildBaseQuery) - 5).
      ELSE
        cChildBaseQuery = SUBSTR(cChildBaseQuery,1,LENGTH(cChildBaseQuery) - 4).
    END.
    IF cChildBaseQuery NE "" THEN DO:
      oDsChildQuery[iiQueryNum]:baseQuery = cChildBaseQuery + ")".
      IF AVAIL ttQueryFilter THEN 
        oDsChildQuery[iiQueryNum]:setFilter(ttQueryFilter.fieldList,ttQueryFilter.operList,ttQueryFilter.valueList).
        
      IF AVAIL ttQueryWhere THEN
        oDsChildQuery[iiQueryNum]:queryWhere = IF TRIM(ttQueryWhere.queryWhere) BEGINS "WHERE " THEN
                                                 " AND (" + SUBSTR(TRIM(ttQueryWhere.queryWhere),7) + ")"
                                               ELSE ttQueryWhere.queryWhere.  
      oDsChildQuery[iiQueryNum]:setJBoxAttribute("querydir","").                                         
      oDsChildQuery[iiQueryNum]:openQuery().
      IF VALID-HANDLE(httSubQuery) THEN DO:
        oDsChildQuery[iiQueryNum]:BUFFER-HANDLE:COPY-TEMP-TABLE(httSubQuery,YES).
        DELETE OBJECT httSubQuery.
      END.  
      deepCopyTT(oDsChildQuery[iiQueryNum]:BUFFER-HANDLE,hMainTTOrDS:GET-BUFFER-HANDLE (iiQueryNum + 1),YES).
    END.

    IF AVAIL ttChildRecordCount AND AVAIL ttChildRowsToBatch THEN
      ASSIGN ttChildRecordCount.recordCount = oDsChildQuery[iiQueryNum]:recordCount
             ttChildRecordCount.numPages = TRUNC(ttChildRecordCount.recordCount / ttChildRowsToBatch.rowsToBatch,0) 
                                         + (IF ttChildRecordCount.recordCount MOD ttChildRowsToBatch.rowsToBatch > 0 THEN 1 ELSE 0)
             ttChildRecordCount.firstRowid = oDsChildQuery[iiQueryNum]:getJBoxAttribute("firstRowid")
             ttChildRecordCount.currentPage = 1
             oDsChildQuery[iiQueryNum]:getRecordCount = NO                             
             .           

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

   END METHOD.
  
  METHOD PRIVATE LOGICAL fillDataset(): 
      
    DEF VAR ix    AS INT  NO-UNDO.
     
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    
        
    deepCopyTT(mainQuery:BUFFER-HANDLE,hMainBuffer,YES).
    IF bDataset THEN 
      DO ix = 2 TO hMainTTOrDS:NUM-BUFFERS:
        FIND FIRST ttFillBufferOnDemand
             WHERE ttFillBufferOnDemand.bufferName = hMainTTOrDS:GET-BUFFER-HANDLE(ix):NAME
               AND ttFillBufferOnDemand.fillOnDemand
             NO-ERROR.
        IF NOT AVAIL ttFillBufferOnDemand THEN     
          fillChildBuffer(ix - 1).
      END.   
    
    RETURN YES.    
  END.  

  METHOD PRIVATE LOGICAL fillDatasetChildren(iiBufferNum AS INT
                                            ,ibFirstCall AS LOG): 
      
    DEF VAR ix             AS INT  NO-UNDO.
    DEF VAR iChildQueryNum AS INT  NO-UNDO.
    DEF VAR cRealDb        AS CHAR NO-UNDO.
    DEF VAR cRealTable     AS CHAR NO-UNDO.
    
    DEF BUFFER ttChildRowsToBatch FOR ttChildRowsToBatch. 
     
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    
            
    IF ibFirstCall THEN DO:
      FIND FIRST ttChildRowsToBatch
           WHERE ttChildRowsToBatch.bufferName = hMainTTOrDS:GET-BUFFER-HANDLE(iiBufferNum):NAME
           NO-ERROR.
      deepCopyTT(oDsChildQuery[iiBufferNum - 1]:BUFFER-HANDLE,hMainTTOrDS:GET-BUFFER-HANDLE(iiBufferNum),
                 IF AVAIL ttChildRowsToBatch AND ttChildRowsToBatch.keepPages THEN NO ELSE YES).
    END.  
      
    DO ix = 1 TO hMainTTOrDS:NUM-RELATIONS:
      IF hMainTTOrDS:GET-RELATION(ix):PARENT-BUFFER = hMainTTOrDS:GET-BUFFER-HANDLE(iiBufferNum) THEN DO:
        FIND FIRST ttFillBufferOnDemand
             WHERE ttFillBufferOnDemand.bufferName = hMainTTOrDS:GET-RELATION(ix):CHILD-BUFFER:NAME
               AND ttFillBufferOnDemand.fillOnDemand
             NO-ERROR.
        IF NOT AVAIL ttFillBufferOnDemand THEN DO:
          
          iQueryNum = getChildQueryNum(realDb(hMainTTOrDS:GET-RELATION(ix):CHILD-BUFFER),realTable(hMainTTOrDS:GET-RELATION(ix):CHILD-BUFFER)).
                
          fillChildBuffer(iQueryNum).
          fillDatasetChildren(iQueryNum + 1,NO).
        END.  
      END.  
    END.        
    
    RETURN YES.    
  END.  
  
  METHOD PUBLIC LOGICAL get (INPUT icFieldList AS CHAR
                            ,INPUT icOperList AS CHAR
                            ,INPUT icValueList AS CHAR):  // pipe-sep
      
    DEF VAR ix               AS INT  NO-UNDO.
    
    IF bDataset THEN DO ix = 1 TO hMainTTOrDS:NUM-BUFFERS:
      IF ix > 1 THEN DO:
        FIND FIRST ttChildDataSource
             WHERE ttChildDataSource.bufferName = hMainTTOrDS:GET-BUFFER-HANDLE (ix):NAME
             NO-ERROR.
        IF NOT AVAIL ttChildDataSource OR (AVAIL ttChildDataSource AND ttChildDataSource.hTTBuffer = ?) THEN      
          hMainTTOrDS:GET-BUFFER-HANDLE (ix):EMPTY-TEMP-TABLE ().
      END.
      ELSE IF mainQueryTTBuffer = ? THEN
        hMainTTOrDS:GET-BUFFER-HANDLE (1):EMPTY-TEMP-TABLE ().  
    END.  
    ELSE IF mainQueryTTBuffer = ? THEN
      hMainBuffer:EMPTY-TEMP-TABLE ().
      
    numPages = 0.
        
    IF NOT VALID-OBJECT(mainQuery) THEN createMainQuery().    
    ELSE IF VALID-HANDLE(mainQuery:BUFFER-HANDLE) AND mainQueryTTBuffer = ? THEN
      mainQuery:BUFFER-HANDLE:EMPTY-TEMP-TABLE().
    
    mainQuery:getRecordCount = getRecordCountMainQuery.
    mainQuery:rowsToBatch = rowsToBatch.
    mainQuery:batchQueryStart = 1.
    currentPage = 1.
    mainQuery:queryFromLast = NO.
    FIND FIRST ttQueryWhere
         WHERE ttQueryWhere.bufferName = hMainBuffer:NAME
         NO-ERROR.
    IF AVAIL ttQueryWhere THEN
      mainQuery:queryWhere = ttQueryWhere.queryWhere.     

    mainQuery:setQuerySort(querySort).     
      
    mainQuery:setJBoxAttribute("noPublishDynFilterDefined","yes").
    
    IF icFieldList NE "" THEN
      mainQuery:setFilter(icFieldList, icOperList, icValueList).
    ELSE  
      mainQuery:setFilter("").

    mainQuery:openQuery().
    
    firstRowid = mainQuery:getJBoxAttribute("firstRowid").

    IF getRecordCountMainQuery THEN
      ASSIGN mainQueryRecordCount = mainQuery:recordCount
             numPages = TRUNC(mainQueryRecordCount / rowsToBatch,0) + (IF mainQueryRecordCount MOD rowsToBatch > 0 THEN 1 ELSE 0)
             mainQuery:getRecordCount = NO.

    IF bDataset AND NOT VALID-OBJECT(oDsChildQuery[1]) THEN
      DO ix = 2 TO hMainTTOrDS:NUM-BUFFERS:
        createChildQuery(ix - 1).
      END.   
                        
    fillDataset().
    
  END METHOD. 
  
  METHOD PUBLIC LOGICAL get ():
    RETURN THIS-OBJECT:get("","","").
  END.  
  

  METHOD PUBLIC INTEGER getCurrentPage(icBufferName AS CHAR):
    RETURN getCurrentPage("",icBufferName).
  END METHOD.   

  METHOD PUBLIC INTEGER getCurrentPage(icDbName AS CHAR,icBufferName AS CHAR): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN 0.    

    iQueryNum = getChildQueryNum(icDbName,icBufferName).
    IF iQueryNum = 0 THEN RETURN currentPage.

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
         NO-ERROR.
    IF AVAIL ttChildRecordCount THEN
      RETURN ttChildRecordCount.currentPage.
      
    RETURN 0.             
  END METHOD.

  METHOD PUBLIC INTEGER getNumPages(icBufferName AS CHAR):
    RETURN getNumPages("",icBufferName).
  END METHOD.   

  METHOD PUBLIC INTEGER getNumPages(icDbName AS CHAR,icBufferName AS CHAR): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN 0.    

    iQueryNum = getChildQueryNum(icDbName,icBufferName).
    IF iQueryNum = 0 THEN RETURN numPages.

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
         NO-ERROR.
    IF AVAIL ttChildRecordCount THEN
      RETURN ttChildRecordCount.numPages.
      
    RETURN 0.             
  END METHOD.

  METHOD PUBLIC LOGICAL getFirst(): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    mainQuery:BUFFER-HANDLE:EMPTY-TEMP-TABLE().

    mainQuery:setJBoxAttribute("firstrowid","").
    mainQuery:queryFromLast = NO.   
    mainQuery:batchQueryStart = 0.

    currentPage = 1.
    
    IF numPages > 0 THEN DO:
      mainQuery:batchQueryStart = 1.
      mainQuery:openQuery().    
    END.  
    ELSE
      RUN InvokeMethod(mainQuery:QUERY-HANDLE,"FirstRecord"). 
 
    fillDataset().      
  END METHOD.

  METHOD PUBLIC LOGICAL getFirst(icBufferName AS CHAR):
    RETURN getFirst("",icBufferName).
  END METHOD.   

  METHOD PUBLIC LOGICAL getFirst(icDbName AS CHAR,icBufferName AS CHAR): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    iQueryNum = getChildQueryNum(icDbName,icBufferName).
    IF iQueryNum = 0 THEN RETURN getFirst().

    oDsChildQuery[iQueryNum]:setJBoxAttribute("firstrowid","").
    oDsChildQuery[iQueryNum]:queryFromLast = NO.   
    oDsChildQuery[iQueryNum]:batchQueryStart = 0.

    FIND FIRST ttChildRowsToBatch
         WHERE ttChildRowsToBatch.db_Name = icDbName
           AND ttChildRowsToBatch.bufferName = icBufferName
         NO-ERROR.
    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName 
           AND ttChildRecordCount.bufferName = icBufferName
         NO-ERROR.     

    hMainTTOrDS:GET-BUFFER-HANDLE(iQueryNum + 1):EMPTY-TEMP-TABLE().
        
    IF AVAIL ttChildRowsToBatch AND AVAIL ttChildRecordCount THEN DO:     
      ttChildRecordCount.currentPage = 1.
    
      IF ttChildRecordCount.numPages > 0 THEN 
        oDsChildQuery[iQueryNum]:batchQueryStart = 1.
      oDsChildQuery[iQueryNum]:openQuery().
    END.  
    ELSE
      RUN InvokeMethod(oDsChildQuery[iQueryNum]:QUERY-HANDLE,"FirstRecord"). 
 
    fillDatasetChildren(iQueryNum + 1,YES).            
  END.  

  METHOD PUBLIC LOGICAL getLast(): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    IF mainQuery:querySort = "" AND cDataSourceName NE "" THEN DO:
      MESSAGE "The query must be sorted to be able to do a get last on a sql query"
      VIEW-AS ALERT-BOX.
      RETURN NO.
    END.  

    mainQuery:BUFFER-HANDLE:EMPTY-TEMP-TABLE().
    mainQuery:setJBoxAttribute("lastrowid","").

    IF numPages > 0 THEN DO:
      mainQuery:batchQueryStart = (IF mainQueryRecordCount MOD rowsToBatch > 0 THEN
                                     mainQueryRecordCount - mainQueryRecordCount MOD rowsToBatch
                                   ELSE  
                                     mainQueryRecordCount - rowsToBatch)
                                + 1.
      mainQuery:openQuery().    
    END.  
    ELSE DO:
      IF keepPages THEN 
        RUN InvokeMethod(mainQuery:QUERY-HANDLE,"LastRecord").
      ELSE DO:
        mainQuery:queryFromLast = YES.
        mainQuery:batchQueryStart = 1.
        mainQuery:openQuery().
      END.
    END.    
    currentPage = numPages.
 
    fillDataset().      
  END.  

  METHOD PUBLIC LOGICAL getLast(icBufferName AS CHAR):
    RETURN getLast("",icBufferName).
  END METHOD.   

  METHOD PUBLIC LOGICAL getLast(icDbName AS CHAR,icBufferName AS CHAR): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    iQueryNum = getChildQueryNum(icDbName,icBufferName).
    IF iQueryNum = 0 THEN RETURN getLast().

    FIND FIRST ttQuerySort 
         WHERE ttQuerySort.db_Name = icDbName 
           AND ttQuerySort.bufferName = icBufferName
         NO-ERROR.
    FIND FIRST ttChildDataSource
         WHERE ttChildDataSource.db_Name = icDbName
           AND ttChildDataSource.bufferName = icBufferName
         NO-ERROR.     

    IF oDsChildQuery[iQueryNum]:querySort = "" AND
      ((AVAIL ttChildDataSource AND ttChildDataSource.dataSourceName NE "")
          OR (NOT AVAIL ttChildDataSource AND cDataSourceName NE "")) THEN DO: 
      MESSAGE "The query must be sorted to be able to do a get last on a sql query"
              VIEW-AS ALERT-BOX.
      RETURN NO.
    END.  

    oDsChildQuery[iQueryNum]:BUFFER-HANDLE:EMPTY-TEMP-TABLE().
    oDsChildQuery[iQueryNum]:setJBoxAttribute("lastrowid","").

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.
    FIND FIRST ttChildRowsToBatch
         WHERE ttChildRowsToBatch.db_Name = icDbName 
           AND ttChildRowsToBatch.bufferName = icBufferName
         NO-ERROR.     

    IF AVAIL ttChildRowsToBatch AND AVAIL ttChildRecordCount AND ttChildRecordCount.numPages > 0 THEN DO:
      IF ttChildRowsToBatch.keepPages THEN
        hMainTTOrDS:GET-BUFFER-HANDLE(iQueryNum + 1):EMPTY-TEMP-TABLE().

      oDsChildQuery[iQueryNum]:batchQueryStart = (IF ttChildRecordCount.recordCount MOD ttChildRowsToBatch.rowsToBatch > 0 THEN
                                                    ttChildRecordCount.recordCount - ttChildRecordCount.recordCount MOD ttChildRowsToBatch.rowsToBatch
                                                  ELSE  
                                                    ttChildRecordCount.recordCount - ttChildRowsToBatch.rowsToBatch)
                                               + 1.
      oDsChildQuery[iQueryNum]:openQuery().    
    END.  
    ELSE DO:
      FIND FIRST ttChildRowsToBatch
           WHERE ttChildRowsToBatch.db_Name = icDbName
             AND ttChildRowsToBatch.bufferName = icBufferName
             AND ttChildRowsToBatch.keepPages
           NO-ERROR.
      IF AVAIL ttChildRowsToBatch THEN DO:
        hMainTTOrDS:GET-BUFFER-HANDLE(iQueryNum + 1):EMPTY-TEMP-TABLE().
        RUN InvokeMethod(oDsChildQuery[iQueryNum]:QUERY-HANDLE,"LastRecord").
      END.  
      ELSE DO:
        oDsChildQuery[iQueryNum]:queryFromLast = YES.
        oDsChildQuery[iQueryNum]:batchQueryStart = 1.
        oDsChildQuery[iQueryNum]:openQuery().
      END.
    END.    
    IF AVAIL ttChildRecordCount THEN
      ttChildRecordCount.currentPage = ttChildRecordCount.numPages.
 
    fillDatasetChildren(iQueryNum + 1,YES).            
  END.  

  METHOD PUBLIC LOGICAL getPrev(): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    IF NOT keepPages THEN mainQuery:BUFFER-HANDLE:EMPTY-TEMP-TABLE().
      
    IF numPages > 0 THEN DO:
      currentPage = currentPage - 1.
      mainQuery:batchQueryStart = MAX(1,currentPage * rowsToBatch - rowsToBatch + 1).
      mainQuery:openQuery().    
    END.
    ELSE DO:    
      IF keepPages THEN 
        RUN InvokeMethod(mainQuery:QUERY-HANDLE,"OffHome").
      ELSE DO:
        IF mainQuery:queryFromLast THEN
          mainQuery:batchQueryStart = mainQuery:recordCount + 1.
        ELSE
          mainQuery:batchQueryStart = MAX(1,mainQuery:recordCount + 1 - mainQuery:rowsToBatch * 2).
        mainQuery:openQuery().    
      END.
    END.  
 
    fillDataset().      
  END.  

  METHOD PUBLIC LOGICAL getPrev(icBufferName AS CHAR):
    RETURN getPrev("",icBufferName).
  END METHOD.   

  METHOD PUBLIC LOGICAL getPrev(icDbName AS CHAR,icBufferName AS CHAR): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    iQueryNum = getChildQueryNum(icDbName,icBufferName).
    IF iQueryNum = 0 THEN RETURN getPrev().

    FIND FIRST ttChildRowsToBatch
         WHERE ttChildRowsToBatch.db_Name = icDbName
           AND ttChildRowsToBatch.bufferName = icBufferName
         NO-ERROR.
    IF AVAIL ttChildRowsToBatch /* AND NOT ttChildRowsToBatch.keepPages*/ THEN oDsChildQuery[iQueryNum]:BUFFER-HANDLE:EMPTY-TEMP-TABLE().

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.   
    IF AVAIL ttChildRowsToBatch AND NOT ttChildRowsToBatch.keepPages AND AVAIL ttChildRecordCount AND ttChildRecordCount.numPages > 0 THEN DO:
      oDsChildQuery[iQueryNum]:batchQueryStart = MAX(1,ttChildRecordCount.currentPage * ttChildRowsToBatch.rowsToBatch - ttChildRowsToBatch.rowsToBatch * 2 + 1).
      oDsChildQuery[iQueryNum]:openQuery().    
      ttChildRecordCount.currentPage = ttChildRecordCount.currentPage - 1.
    END.
    ELSE DO:    
      IF AVAIL ttChildRowsToBatch AND ttChildRowsToBatch.keepPages THEN DO:
        oDsChildQuery[iQueryNum]:batchQueryStart = 1.
        oDsChildQuery[iQueryNum]:rowsToBatch = INT(oDsChildQuery[iQueryNum]:getJboxAttribute("totalcount")) + ttChildRowsToBatch.rowsToBatch.
        oDsChildQuery[iQueryNum]:setJBoxAttribute("querydir","desc").
        hMainTTOrDS:GET-BUFFER-HANDLE (iQueryNum + 1):EMPTY-TEMP-TABLE().
        oDsChildQuery[iQueryNum]:openQuery().
        oDsChildQuery[iQueryNum]:rowsToBatch = ttChildRowsToBatch.rowsToBatch.    
        ttChildRecordCount.currentPage = ttChildRecordCount.currentPage - 1.
        oDsChildQuery[iQueryNum]:setJBoxAttribute("querydir","").
      END.  
      ELSE DO:
        IF oDsChildQuery[iQueryNum]:queryFromLast THEN
          oDsChildQuery[iQueryNum]:batchQueryStart = oDsChildQuery[iQueryNum]:recordCount + 1.
        ELSE
          oDsChildQuery[iQueryNum]:batchQueryStart = MAX(1,oDsChildQuery[iQueryNum]:recordCount + 1 - oDsChildQuery[iQueryNum]:rowsToBatch * 2).
        oDsChildQuery[iQueryNum]:openQuery().    
      END.
    END.  
 
    fillDatasetChildren(iQueryNum + 1,YES).            
  END.  

  METHOD PUBLIC LOGICAL getNext(): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    mainQuery:queryFromLast = NO.   

    IF NOT keepPages THEN mainQuery:BUFFER-HANDLE:EMPTY-TEMP-TABLE().

    IF numPages > 0 THEN DO:
      mainQuery:batchQueryStart = currentPage * rowsToBatch + 1.
      mainQuery:openQuery().    
      currentPage = currentPage + 1.
    END.
    ELSE DO:
      IF keepPages THEN 
        RUN InvokeMethod(mainQuery:QUERY-HANDLE,"OffEnd").
      ELSE DO:
        // Special handling if last move was getPrev and we are at first page:
        IF mainQuery:getJBoxAttribute("firstRowid") = firstRowid THEN 
          mainQuery:batchQueryStart = mainQuery:totalCount + 1.
        ELSE  
          mainQuery:batchQueryStart = mainQuery:recordCount + 1.
        mainQuery:openQuery().    
      END.
    END. 
    fillDataset().      
  END.  

  METHOD PUBLIC LOGICAL getNext(icBufferName AS CHAR):
    RETURN getNext("",icBufferName).
  END METHOD.   

  METHOD PUBLIC LOGICAL getNext(icDbName AS CHAR,icBufferName AS CHAR): 
      
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    iQueryNum = getChildQueryNum(icDbName,icBufferName).
    IF iQueryNum = 0 THEN RETURN getNext().

    oDsChildQuery[iQueryNum]:queryFromLast = NO.   

    FIND FIRST ttChildRowsToBatch
         WHERE ttChildRowsToBatch.db_Name = icDbName
           AND ttChildRowsToBatch.bufferName = icBufferName
         NO-ERROR.

    IF AVAIL ttChildRowsToBatch /* AND NOT ttChildRowsToBatch.keepPages */ THEN oDsChildQuery[iQueryNum]:BUFFER-HANDLE:EMPTY-TEMP-TABLE().

    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.getRecordCount
         NO-ERROR.   
    IF AVAIL ttChildRowsToBatch AND NOT ttChildRowsToBatch.keepPages AND AVAIL ttChildRecordCount AND ttChildRecordCount.numPages > 0 THEN DO:
      oDsChildQuery[iQueryNum]:batchQueryStart = ttChildRecordCount.currentPage * ttChildRowsToBatch.rowsToBatch + 1.
      oDsChildQuery[iQueryNum]:openQuery().    
      ttChildRecordCount.currentPage = ttChildRecordCount.currentPage + 1.
    END.
    ELSE DO:
      IF AVAIL ttChildRowsToBatch AND ttChildRowsToBatch.keepPages THEN 
        RUN InvokeMethod(oDsChildQuery[iQueryNum]:QUERY-HANDLE,"OffEnd").
      ELSE DO:
        // Special handling if last move was getPrev and we are at first page:
        IF AVAIL ttChildRecordCount AND oDsChildQuery[iQueryNum]:getJBoxAttribute("firstRowid") = ttChildRecordCount.firstRowid THEN 
          oDsChildQuery[iQueryNum]:batchQueryStart = oDsChildQuery[iQueryNum]:totalCount + 1.
        ELSE  
          oDsChildQuery[iQueryNum]:batchQueryStart = oDsChildQuery[iQueryNum]:recordCount + 1.
        oDsChildQuery[iQueryNum]:openQuery().    
      END.
    END. 
    fillDatasetChildren(iQueryNum + 1,YES).            
  END.  


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER realTable( INPUT icTableName AS CHARACTER):
    
    RETURN IF LENGTH(icTableName) > 5 AND icTableName MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(icTableName,4,2)) THEN 
             SUBSTR(icTableName,INDEX(icTableName,"_") + 1)
           ELSE icTableName.

  END METHOD.
  
  METHOD PRIVATE CHARACTER realTable (INPUT ihBuffer AS HANDLE):
    DEF VAR hTT AS HANDLE NO-UNDO.
    
    IF ihBuffer:TYPE = "buffer" THEN hTT = ihBuffer:TABLE-HANDLE.
    ELSE hTT = ihBuffer.
    
    IF hTT:ADM-DATA NE "" AND hTT:ADM-DATA NE ? THEN RETURN htt:ADM-DATA.
    ELSE RETURN hTT:DEFAULT-BUFFER-HANDLE:NAME.
   
  END METHOD.  

  METHOD PRIVATE CHARACTER realDb (INPUT ihBuffer AS HANDLE):
    DEF VAR hTT AS HANDLE NO-UNDO.
    
    IF ihBuffer:TYPE = "buffer" THEN hTT = ihBuffer:TABLE-HANDLE.
    ELSE hTT = ihBuffer.
    
    IF hTT:PRIVATE-DATA NE "" AND hTT:PRIVATE-DATA NE ? THEN RETURN htt:PRIVATE-DATA.
    ELSE "".
   
  END METHOD.  

  METHOD PUBLIC LOGICAL viewPage (iiPageNum AS INT):
    IF numPages > 0 THEN DO:
      mainQuery:BUFFER-HANDLE:EMPTY-TEMP-TABLE().
      mainQuery:batchQueryStart = (iiPageNum - 1) * rowsToBatch + 1.
      mainQuery:openQuery().    
      currentPage = iiPageNum.
      fillDataset().      
      RETURN YES.
    END.
    RETURN NO.
  END.  

  METHOD PUBLIC LOGICAL viewPage (icBufferName AS CHAR
                                 ,iiPageNum AS INT):
    RETURN viewPage("",icBufferName,iiPageNum).                               
  END METHOD.

  METHOD PUBLIC LOGICAL viewPage (icDbName AS CHAR,icBufferName AS CHAR
                                 ,iiPageNum AS INT):
                                   
    IF NOT VALID-OBJECT(mainQuery) THEN RETURN NO.    

    iQueryNum = getChildQueryNum(icDbName,icBufferName).
    IF iQueryNum = 0 THEN RETURN viewPage(iiPageNum).

    FIND FIRST ttChildRowsToBatch
         WHERE ttChildRowsToBatch.db_Name = icDbName
           AND ttChildRowsToBatch.bufferName = icBufferName
         NO-ERROR.
    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
           AND ttChildRecordCount.numPages > 0
         NO-ERROR.
    IF AVAIL ttChildRowsToBatch AND AVAIL ttChildRecordCount THEN DO:
      oDsChildQuery[iQueryNum]:batchQueryStart = (iiPageNum - 1) * ttChildRowsToBatch.rowsToBatch + 1.
      oDsChildQuery[iQueryNum]:openQuery().    
      ttChildRecordCount.currentPage = iiPageNum.
      fillDatasetChildren(iQueryNum + 1,YES).      
      RETURN YES.
    END.
    RETURN NO.
  END.  

  METHOD PUBLIC LOGICAL put ():
    DEF VAR bModified      AS LOG NO-UNDO.
    DEF VAR ix             AS INT NO-UNDO.
    DEF VAR iy             AS INT NO-UNDO.
    DEF VAR bOk            AS LOG NO-UNDO.
    DEF VAR bFieldModified AS LOG NO-UNDO.

    FIND FIRST ttChildDataSource
         WHERE ttChildDataSource.dataSourceType NE cDataSourceName
         NO-ERROR.
    IF AVAIL ttChildDataSource THEN commitPrBuffer = YES.         
    
    mainQuery:QUERY-HANDLE:GET-FIRST().
    REPEAT WHILE mainQuery:BUFFER-HANDLE:AVAIL:
      hMainBuffer:FIND-BY-ROWID (TO-ROWID(mainQuery:BUFFER-HANDLE::localRowid)) NO-ERROR.
      IF hMainBuffer:AVAIL AND NOT hMainBuffer:BUFFER-COMPARE (mainQuery:BUFFER-HANDLE) THEN DO:
        doUpdate(hMainBuffer,mainQuery:BUFFER-HANDLE).
        bModified = YES.
      END.  
      mainQuery:QUERY-HANDLE:GET-NEXT().
    END.
    
    IF bModified AND commitPrBuffer THEN DO:
      DYNAMIC-FUNCTION("setCurrentQueryObject",mainQuery:QUERY-HANDLE).
      bOk = DYNAMIC-FUNCTION("DoCommit",YES).
      IF NOT bDataset OR NOT bOk THEN RETURN bOk.
      bModified = NO.
    END.
    
    IF bDataset THEN DO:
      DO ix = 2 TO hMainTTOrDS:NUM-BUFFERS:
        IF commitPrBuffer THEN
          bModified = NO.

        oDsChildQuery[ix - 1]:QUERY-HANDLE:GET-FIRST().
        REPEAT WHILE oDsChildQuery[ix - 1]:BUFFER-HANDLE:AVAIL:
          hMainTTOrDS:GET-BUFFER-HANDLE (ix):FIND-BY-ROWID (TO-ROWID(oDsChildQuery[ix - 1]:BUFFER-HANDLE::localRowid)) NO-ERROR.
          IF hMainTTOrDS:GET-BUFFER-HANDLE (ix):AVAIL THEN DO:
            bFieldModified = NO.
            DO iy = 1 TO hMainTTOrDS:GET-BUFFER-HANDLE (ix):NUM-FIELDS:
              IF hMainTTOrDS:GET-BUFFER-HANDLE (ix):BUFFER-FIELD(iy):BUFFER-VALUE NE
                 oDsChildQuery[ix - 1]:BUFFER-HANDLE:BUFFER-FIELD(iy):BUFFER-VALUE THEN DO:
                bFieldModified = YES.
                LEAVE.
              END.
            END.
            IF bFieldModified THEN DO:
              doUpdate(hMainTTOrDS:GET-BUFFER-HANDLE (ix),oDsChildQuery[ix - 1]:BUFFER-HANDLE).
              bModified = YES.
            END.  
          END.
          oDsChildQuery[ix - 1]:QUERY-HANDLE:GET-NEXT().  
        END.
        IF bModified AND commitPrBuffer THEN DO:
          DYNAMIC-FUNCTION("setCurrentQueryObject",oDsChildQuery[ix - 1]:QUERY-HANDLE).
          bOk = DYNAMIC-FUNCTION("DoCommit",YES).
          IF NOT bOk THEN RETURN bOk.
        END.
      END.   
    END.

    IF bModified AND NOT commitPrBuffer THEN DO:
      DYNAMIC-FUNCTION("setCurrentQueryObject",mainQuery:QUERY-HANDLE).
      RETURN DYNAMIC-FUNCTION("DoCommit",YES).
    END.  
    
    RETURN NO.  
  END METHOD.  

  METHOD PUBLIC VOID setBufferQueryWhere (icBufferName AS CHAR
                                         ,icQueryWhere AS CHAR):
                                                                                     
    FIND FIRST ttQueryWhere
         WHERE ttQueryWhere.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttQueryWhere THEN DO:
      CREATE ttQueryWhere.
      ASSIGN ttQueryWhere.bufferName = icBufferName.
    END.     
    ttQueryWhere.queryWhere = icQueryWhere.
    IF VALID-OBJECT(mainQuery) THEN DO:
      iQueryNum = getChildQueryNum("",icBufferName).
      IF iQueryNum = 0 THEN mainQuery:queryWhere = icQueryWhere.
      ELSE oDsChildQuery[iQueryNum]:queryWhere = icQueryWhere. 
    END.  
  END METHOD.  

  METHOD PUBLIC VOID setBufferQueryWhere (icDbName     AS CHAR
                                         ,icBufferName AS CHAR
                                         ,icQueryWhere AS CHAR):
                                                                                     
    FIND FIRST ttQueryWhere
         WHERE ttQueryWhere.db_Name    = icDbName 
           AND ttQueryWhere.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttQueryWhere THEN DO:
      CREATE ttQueryWhere.
      ASSIGN ttQueryWhere.db_Name    = icDbName
             ttQueryWhere.bufferName = icBufferName.
    END.     
    ttQueryWhere.queryWhere = icQueryWhere.
    IF VALID-OBJECT(mainQuery) THEN DO:
      iQueryNum = getChildQueryNum(icDbName,icBufferName).
      IF iQueryNum = 0 THEN mainQuery:queryWhere = icQueryWhere.
      ELSE oDsChildQuery[iQueryNum]:queryWhere = icQueryWhere. 
    END.  
  END METHOD.  

  METHOD PUBLIC VOID setBufferQuerySort (icBufferName AS CHAR
                                        ,icQuerySort  AS CHAR):
    setBufferQuerySort("",icBufferName,icQuerySort).
  END METHOD.                                        

  METHOD PUBLIC VOID setBufferQuerySort (icDbName     AS CHAR
                                        ,icBufferName AS CHAR
                                        ,icQuerySort  AS CHAR):
                                          
    hCurrObject = DYNAMIC-FUNCTION("getCurrentObject").
                                              
    FIND FIRST ttQuerySort
         WHERE ttQuerySort.db_Name    = icDbName
           AND ttQuerySort.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttQuerySort THEN DO:
      CREATE ttQuerySort.
      ASSIGN ttQuerySort.db_Name    = icDbName
             ttQuerySort.bufferName = icBufferName.
    END.     
    ttQuerySort.querySort = icQuerySort.
    IF VALID-OBJECT(mainQuery) THEN DO:
      iQueryNum = getChildQueryNum(icDbName,icBufferName).
      IF iQueryNum = 0 THEN mainQuery:setQuerySort(icQuerySort).
      ELSE oDsChildQuery[iQueryNum]:setQuerySort(icQuerySort). 
    END.
      
    FINALLY:     
      IF VALID-HANDLE(hCurrObject) THEN   
        DYNAMIC-FUNCTION("setCurrentObject",hCurrObject).
    END.  
    
  END METHOD.  

  METHOD PUBLIC VOID setBufferQueryFilter (icBufferName    AS CHAR
                                          ,icFieldList     AS CHAR
                                          ,icOperatorList  AS CHAR
                                          ,icValuePipeList AS CHAR):
    setBufferQueryFilter("",icBufferName,icFieldList,icOperatorList,icValuePipeList).
  END.                                          

  METHOD PUBLIC VOID setBufferQueryFilter (icDbName        AS CHAR
                                          ,icBufferName    AS CHAR
                                          ,icFieldList     AS CHAR
                                          ,icOperatorList  AS CHAR
                                          ,icValuePipeList AS CHAR):

    hCurrObject = DYNAMIC-FUNCTION("getCurrentObject").
                                            
    FIND FIRST ttQueryFilter
         WHERE ttQueryFilter.db_Name    = icDbName
           AND ttQueryFilter.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttQueryFilter THEN DO:
      CREATE ttQueryFilter.
      ASSIGN ttQueryFilter.db_Name    = icDbName
             ttQueryFilter.bufferName = icBufferName.
    END.     
    ASSIGN ttQueryFilter.fieldList = icFieldList
           ttQueryFilter.operList  = icOperatorList
           ttQueryFilter.valueList = icValuePipeList
           .
    IF VALID-OBJECT(mainQuery) THEN DO:
      iQueryNum = getChildQueryNum(icDbName,icBufferName).
      IF icFieldList NE "" THEN DO:
        IF iQueryNum = 0 THEN mainQuery:setFilter(icFieldList,icOperatorList,icValuePipeList).
        ELSE oDsChildQuery[iQueryNum]:setFilter(icFieldList,icOperatorList,icValuePipeList).
      END.
      ELSE DO:
        IF iQueryNum = 0 THEN mainQuery:setFilter("").
        ELSE oDsChildQuery[iQueryNum]:setFilter("").
      END.     
    END.
      
    FINALLY:        
      IF VALID-HANDLE(hCurrObject) THEN   
        DYNAMIC-FUNCTION("setCurrentObject",hCurrObject).
    END.  
           
  END METHOD.  

  METHOD PUBLIC LOGICAL setBufferQueryJoin (icBufferName       AS CHAR
                                           ,icQueryJoin        AS CHAR
                                           ,icBuffersAndFields AS CHAR):
    RETURN setBufferQueryJoin("",icBufferName,icQueryJoin,icBuffersAndFields).                                         
  END METHOD.  

  METHOD PUBLIC LOGICAL setBufferQueryJoin (icDbName           AS CHAR
                                           ,icBufferName       AS CHAR
                                           ,icQueryJoin        AS CHAR
                                           ,icBuffersAndFields AS CHAR):
    IF VALID-OBJECT (mainQuery) THEN DO:
      MESSAGE "Query is already defined - too late to change join-buffers"
      VIEW-AS ALERT-BOX.
      RETURN NO.
    END.          
    IF icQueryJoin NE "" OR icBuffersAndFields NE "" THEN DO:                                   
      FIND FIRST ttQueryJoin
           WHERE ttQueryJoin.db_Name = icDbName
             AND ttQueryJoin.bufferName = icBufferName
           NO-ERROR.
      IF NOT AVAIL ttQueryJoin THEN DO:
        CREATE ttQueryJoin.
        ASSIGN ttQueryJoin.db_Name = icDbName
               ttQueryJoin.bufferName = icBufferName
               .
      END.     
      ASSIGN ttQueryJoin.queryJoin = "," + TRIM(TRIM(TRIM(icQueryJoin),","))
             ttQueryJoin.buffersAndFields = TRIM(TRIM(TRIM(icBuffersAndFields),","))
             .
      REPEAT WHILE INDEX(ttQueryJoin.queryJoin,"  ") > 0:
        ttQueryJoin.queryJoin = REPLACE(ttQueryJoin.queryJoin,"  "," ").
      END.
    END.        
    RETURN YES.
  END METHOD.  

  METHOD PUBLIC VOID setBufferPreScanQuery (icBufferName AS CHAR
                                           ,icJoinBufferName  AS CHAR
                                           ,icPrescanQuery AS CHAR):
    setBufferPreScanQuery("",icBufferName,icJoinBufferName,icPrescanQuery).                                         
  END METHOD.  

  METHOD PUBLIC VOID setBufferPreScanQuery (icDbName          AS CHAR
                                           ,icBufferName      AS CHAR
                                           ,icJoinBufferName  AS CHAR
                                           ,icPrescanQuery    AS CHAR):
    FIND FIRST ttPreScanQueryJoin
         WHERE ttPreScanQueryJoin.db_Name = icDbName 
           AND ttPreScanQueryJoin.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttPreScanQueryJoin THEN DO:
      CREATE ttPreScanQueryJoin.
      ASSIGN ttPreScanQueryJoin.db_Name    = icDbName
             ttPreScanQueryJoin.bufferName = icBufferName.
    END.     
    ttPreScanQueryJoin.preScanQuery = TRIM(icPrescanQuery,",").
  END METHOD.  

  METHOD PUBLIC VOID setBufferPreScanBaseQuery (icBufferName AS CHAR
                                               ,icPrescanBaseQuery AS CHAR):
    setBufferPreScanBaseQuery("",icBufferName,icPrescanBaseQuery).                                             
  END METHOD.  

  METHOD PUBLIC VOID setBufferPreScanBaseQuery (icDbName           AS CHAR
                                               ,icBufferName       AS CHAR
                                               ,icPrescanBaseQuery AS CHAR):
    FIND FIRST ttPreScanBaseQuery
         WHERE ttPreScanBaseQuery.db_Name = icDbName
           AND ttPreScanBaseQuery.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttPreScanQueryJoin THEN DO:
      CREATE ttPreScanBaseQuery.
      ASSIGN ttPreScanBaseQuery.db_Name = icDbName
             ttPreScanBaseQuery.bufferName = icBufferName.
    END.     
    ttPreScanBaseQuery.preScanBaseQuery = icPrescanBaseQuery.
  END METHOD.  

  METHOD PUBLIC LOGICAL setChildBufferDataSource (icBufferName AS CHAR
                                                 ,icDataSourceName  AS CHAR):
    DEF VAR cDatasourceName AS CHAR NO-UNDO.
    
    IF CAN-DO("webclient,4glclient",SESSION:CLIENT-TYPE) AND NOT SESSION:BATCH-MODE THEN  
      cDataSourceName = JBoxServerApi:Instance:getDataSourceConnection (icDataSourceName).
    ELSE  
      cDataSourceName = JBoxServerSide:Instance:getDataSourceConnection (icDataSourceName).
    IF cDataSourceName = "" THEN
      cDataSourceName = icDataSourceName.
                                           
    RETURN setChildBufferDataSource(icBufferName,"","",cDataSourceName).                                           
  END METHOD.  

  METHOD PUBLIC LOGICAL setChildBufferDataSource (ihTTbuffer AS HANDLE):
    DEF VAR bOk AS LOG NO-UNDO.                                       
    bOk = setChildBufferDataSource(ihTTbuffer:NAME,"","TEMP-TABLE","Datafjord").
    IF bOk THEN DO:                                           
      FIND FIRST ttChildDataSource
           WHERE ttChildDataSource.db_Name = "TEMP-TABLE"
             AND ttChildDataSource.bufferName = ihTTbuffer:NAME
             .
      ttChildDataSource.hTTBuffer = ihTTbuffer.
    END.       
  END METHOD.  

  METHOD PUBLIC LOGICAL setChildBufferDataSource (icBufferName      AS CHAR
                                                 ,icDbBuffer        AS CHAR
                                                 ,icDbName          AS CHAR
                                                 ,icDataSourceName  AS CHAR):
                                           
    DEF VAR cType AS CHAR NO-UNDO.
    DEF VAR cDatasourceName AS CHAR NO-UNDO.
    DEF VAR cDbBuffer AS CHAR NO-UNDO.
    
    IF CAN-DO("webclient,4glclient",SESSION:CLIENT-TYPE) AND NOT SESSION:BATCH-MODE THEN  
      cDataSourceName = JBoxServerApi:Instance:getDataSourceConnection (icDataSourceName).
    ELSE  
      cDataSourceName = JBoxServerSide:Instance:getDataSourceConnection (icDataSourceName).
    IF cDataSourceName = "" THEN
      cDataSourceName = icDataSourceName.

    IF VALID-OBJECT (mainQuery) THEN DO:
      MESSAGE "Query is already defined - too late to change data source"
      VIEW-AS ALERT-BOX.
      RETURN NO.
    END.                                             
    
    IF icDbBuffer = "" THEN cDbBuffer = icBufferName.
    ELSE cDbBuffer = icDbBuffer. 
    
    IF cDataSourceName NE "" THEN
      cType = JBoxSqlSchemaHelper:Instance:getDsType(cDataSourceName).
                                               
    FIND FIRST ttChildDataSource
         WHERE ttChildDataSource.db_Name = icDbName
           AND ttChildDataSource.bufferName = icBufferName
           AND ttChildDataSource.dbBufferName = cDbBuffer 
         NO-ERROR.
    IF NOT AVAIL ttChildDataSource THEN DO:
      CREATE ttChildDataSource.
      ASSIGN ttChildDataSource.db_Name = icDbName
             ttChildDataSource.bufferName = icBufferName
             ttChildDataSource.dbBufferName = cDbBuffer
             .
    END.     
    ASSIGN ttChildDataSource.dataSourceName = cDataSourceName
           ttChildDataSource.dataSourceType = cType
           .
    RETURN YES.       
  END METHOD.  

  // Must be set to be able to do paging on a (child) buffer
  METHOD PUBLIC VOID setFillBufferOnDemand (icBufferName   AS CHAR
                                           ,ibFillOnDemand AS LOG):

    setFillBufferOnDemand("",icBufferName,ibFillOnDemand).
  END.                                               

  // Must be set to be able to do paging on a (child) buffer
  METHOD PUBLIC VOID setFillBufferOnDemand (icDbName       AS CHAR
                                           ,icBufferName   AS CHAR
                                           ,ibFillOnDemand AS LOG):

    FIND FIRST ttFillBufferOnDemand
         WHERE ttFillBufferOnDemand.db_Name = icDbName
           AND ttFillBufferOnDemand.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttFillBufferOnDemand THEN DO:
      CREATE ttFillBufferOnDemand.
      ASSIGN ttFillBufferOnDemand.db_Name = icDbName
             ttFillBufferOnDemand.bufferName = icBufferName.
    END.
    ttFillBufferOnDemand.fillOnDemand = ibFillOnDemand.                                                      
  END.                                               

  METHOD PUBLIC LOGICAL getFillBufferOnDemand (icBufferName   AS CHAR):

    RETURN getFillBufferOnDemand("",icBufferName).
  END.                                               

  METHOD PUBLIC LOGICAL getFillBufferOnDemand (icDbName AS CHAR,icBufferName   AS CHAR):

    FIND FIRST ttFillBufferOnDemand
         WHERE ttFillBufferOnDemand.db_Name = icDbName
           AND ttFillBufferOnDemand.bufferName = icBufferName
           AND ttFillBufferOnDemand.fillOnDemand
         NO-ERROR.
    RETURN AVAIL ttFillBufferOnDemand.    
  END.                                               

  METHOD PUBLIC VOID setChildBufferRowsToBatch (icBufferName AS CHAR
                                               ,iiRowsToBatch AS INT
                                               ,ibKeepPages AS LOG):
                                           
    setChildBufferRowsToBatch("",icBufferName,iiRowsToBatch,ibKeepPages).                                           
  END METHOD.  

  METHOD PUBLIC VOID setChildBufferRowsToBatch (icDbName      AS CHAR
                                               ,icBufferName  AS CHAR
                                               ,iiRowsToBatch AS INT
                                               ,ibKeepPages   AS LOG):
                                           
    FIND FIRST ttChildRowsToBatch
         WHERE ttChildRowsToBatch.db_Name = icDbName
           AND ttChildRowsToBatch.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttChildRowsToBatch THEN DO:
      CREATE ttChildRowsToBatch.
      ASSIGN ttChildRowsToBatch.db_Name = icDbName
             ttChildRowsToBatch.bufferName = icBufferName.
    END.     
    ASSIGN ttChildRowsToBatch.rowsToBatch = iiRowsToBatch
           ttChildRowsToBatch.keepPages   = ibKeepPages.
  END METHOD.  

  METHOD PUBLIC VOID setChildBufferGetRecordCount (icBufferName AS CHAR
                                                  ,ibGetRecordCount AS LOG):
    setChildBufferGetRecordCount("",icBufferName,ibGetRecordCount).                                           
  END METHOD.  

  METHOD PUBLIC VOID setChildBufferGetRecordCount (icDbName         AS CHAR
                                                  ,icBufferName     AS CHAR
                                                  ,ibGetRecordCount AS LOG):
                                           
    FIND FIRST ttChildRecordCount
         WHERE ttChildRecordCount.db_Name = icDbName
           AND ttChildRecordCount.bufferName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttChildRecordCount THEN DO:
      CREATE ttChildRecordCount.
      ASSIGN ttChildRecordCount.db_Name = icDbName
             ttChildRecordCount.bufferName = icBufferName.
    END.     
    ttChildRecordCount.getRecordCount = ibGetRecordCount.
  END METHOD.  

  METHOD PRIVATE CHARACTER getBufferAndFields (ihbtt          AS HANDLE
                                              ,icDbBufferName AS CHAR):
    DEF VAR ix                   AS INT  NO-UNDO.
    DEF VAR iy                   AS INT  NO-UNDO.
    DEF VAR cBuffAndFlds         AS CHAR NO-UNDO.
    DEF VAR cFirstFieldSpecTable AS CHAR NO-UNDO.
    DEF VAR cFirstJoinTable      AS CHAR NO-UNDO.
    DEF VAR cFieldList           AS CHAR NO-UNDO.
    DEF VAR cBufferDef           AS CHAR NO-UNDO.
    DEF VAR cDb                  AS CHAR NO-UNDO.
    DEF VAR cDbBufferName        AS CHAR NO-UNDO.                
                   
    DEF BUFFER ttChildDataSource FOR ttChildDataSource.                   
                   
    cDbBufferName = (IF ihbtt:ADM-DATA NE ? AND ihbtt:ADM-DATA NE "" THEN
                       ihbtt:ADM-DATA
                     ELSE IF ihbtt:TABLE-HANDLE:ADM-DATA NE ? AND ihbtt:TABLE-HANDLE:ADM-DATA NE "" THEN
                       ihbtt:TABLE-HANDLE:ADM-DATA
                     ELSE icDbBufferName) 
                     .
                     
    cBuffAndFlds = (IF OEdbName NE "" THEN OEdbName + "." ELSE "") + cDbBufferName.
                   
    cDb = IF ihbtt:TABLE-HANDLE:PRIVATE-DATA NE ? AND ihbtt:TABLE-HANDLE:PRIVATE-DATA NE "" THEN ihbtt:TABLE-HANDLE:PRIVATE-DATA
          ELSE IF ihbtt:PRIVATE-DATA NE ? AND ihbtt:PRIVATE-DATA NE "" THEN ihbtt:PRIVATE-DATA  
          ELSE "".
    IF cDb = "" THEN DO:
      FIND FIRST ttChildDataSource
           WHERE ttChildDataSource.dbBufferName = cDbBufferName
           NO-ERROR.
      IF AVAIL ttChildDataSource THEN cDb = ttChildDataSource.db_Name.
      ELSE DO:
        FIND FIRST ttChildDataSource
             WHERE ENTRY(NUM-ENTRIES(ttChildDataSource.bufferName,"."),ttChildDataSource.bufferName,".") = cDbBufferName
             NO-ERROR.
        IF AVAIL ttChildDataSource THEN cDb = ttChildDataSource.db_Name.
      END.       
    END.        
          
    FIND FIRST ttQueryJoin
         WHERE ttQueryJoin.bufferName = ENTRY(NUM-ENTRIES(cBuffAndFlds,"."),cBuffAndFlds,".")
           AND ttQueryJoin.db_Name = cDb
         NO-ERROR.
    IF NOT AVAIL ttQueryJoin THEN DO:      
      FIND FIRST ttQueryJoin
           WHERE ttQueryJoin.bufferName = ENTRY(NUM-ENTRIES(cBuffAndFlds,"."),cBuffAndFlds,".")
           NO-ERROR.
      IF NOT AVAIL ttQueryJoin THEN       
        FIND FIRST ttQueryJoin
             WHERE ENTRY(NUM-ENTRIES(ttQueryJoin.bufferName,"."),ttQueryJoin.bufferName,".") = ENTRY(NUM-ENTRIES(cBuffAndFlds,"."),cBuffAndFlds,".")
             NO-ERROR.
    END.       
            
    IF AVAIL ttQueryJoin THEN DO:
      IF NUM-ENTRIES(ttQueryJoin.queryJoin," ") > 1 THEN
        ASSIGN cFirstJoinTable = ENTRY(2,ttQueryJoin.queryJoin," ") 
               cFirstJoinTable = ENTRY(NUM-ENTRIES(cFirstJoinTable,"."),cFirstJoinTable,".")
               cFirstFieldSpecTable = ENTRY(1,ENTRY(1,ttQueryJoin.buffersAndFields),";")
               cFirstFieldSpecTable = ENTRY(NUM-ENTRIES(cFirstFieldSpecTable,"."),cFirstFieldSpecTable,".")
               .             

      IF cFirstJoinTable NE "" AND cFirstJoinTable = cFirstFieldSpecTable THEN DO:
        DO ix = 1 TO NUM-ENTRIES(ttQueryJoin.buffersAndFields):
          cBufferDef = ENTRY(ix,ttQueryJoin.buffersAndFields).
          DO iy = 2 TO NUM-ENTRIES(cBufferDef,";"):
            cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(iy,cBufferDef,";"),"|").
          END.  
        END.  
        cBuffAndFlds = cBuffAndFlds + ";".       
        DO ix = 1 TO ihbtt:NUM-FIELDS:
          IF NOT CAN-DO(cFieldList,ihbtt:BUFFER-FIELD (ix):NAME) AND NOT CAN-DO("RowCount,RowIdent1",ihbtt:BUFFER-FIELD (ix):NAME) THEN
            cBuffAndFlds = cBuffAndFlds 
                         + ihbtt:BUFFER-FIELD (ix):NAME
                         + ";".
        END.   
        cBuffAndFlds = cBuffAndFlds 
                     + "+localRowid|CHARACTER"
                     + "," + ttQueryJoin.buffersAndFields
                     .
      END.         
      ELSE 
        ASSIGN cBuffAndFlds = ttQueryJoin.buffersAndFields
               ENTRY(1,cBuffAndFlds) = ENTRY(1,cBuffAndFlds) + ";+localRowid|CHARACTER".
    END.       
    ELSE DO:     
      cBuffAndFlds = cBuffAndFlds + ";".       
      DO ix = 1 TO ihbtt:NUM-FIELDS:
        cBuffAndFlds = cBuffAndFlds 
                     + ihbtt:BUFFER-FIELD (ix):NAME
                     + ";".
      END.   
      cBuffAndFlds = cBuffAndFlds + "+localRowid|CHARACTER".
    END.    
    
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
    
    FINALLY:
      RETURN TRIM(cBuffAndFlds,";").
    END.  
  END METHOD. 
    
  METHOD PRIVATE VOID setDsChildBaseQuery(INPUT iiQueryNum AS INT):
    DEF VAR ix                AS INT  NO-UNDO.
    DEF VAR iy                AS INT  NO-UNDO.
    DEF VAR cParentFieldType  AS CHAR NO-UNDO.
    DEF VAR cChildFieldType   AS CHAR NO-UNDO.
    DEF VAR hParentQuery      AS HANDLE NO-UNDO.
    DEF VAR cChildQryTemplate AS CHAR NO-UNDO.
    DEF VAR cChildBaseQuery   AS CHAR NO-UNDO.
    DEF VAR cRelFields        AS CHAR NO-UNDO.
    DEF VAR iNumFlds          AS INT  NO-UNDO.
    DEF VAR hParentFlds       AS HANDLE NO-UNDO EXTENT.
    
    ASSIGN cRelFields = hMainTTOrDS:GET-RELATION(iiQueryNum):RELATION-FIELDS
           iNumFlds = NUM-ENTRIES(cRelFields) / 2
           EXTENT(hParentFlds) = iNumFlds
           .
    
    DO ix = 1 TO NUM-ENTRIES(cRelFields) BY 2:
      iy = iy + 1.
      cParentFieldType = hMainTTOrDS:GET-RELATION(iiQueryNum):PARENT-BUFFER:BUFFER-FIELD(ENTRY(ix,cRelFields)):DATA-TYPE.
      cChildFieldType  = hMainTTOrDS:GET-RELATION(iiQueryNum):CHILD-BUFFER:BUFFER-FIELD(ENTRY(ix + 1,cRelFields)):DATA-TYPE.

      cChildQryTemplate = cChildQryTemplate + (IF cChildQryTemplate NE "" THEN " AND " ELSE "")
                        + ENTRY(ix + 1,cRelFields) + " = "
                        .
      hParentFlds[iy] = hMainTTOrDS:GET-RELATION(iiQueryNum):PARENT-BUFFER:BUFFER-FIELD(ENTRY(ix,cRelFields)).
                        
      IF cChildFieldType = "CHARACTER" THEN                  
        cChildQryTemplate = cChildQryTemplate + "'".
      ELSE IF cChildFieldType NE cParentFieldType THEN DO: 
        IF cChildFieldType = "CHARACTER" THEN                  
          cChildQryTemplate = cChildQryTemplate + "STRING('".
        ELSE  
          cChildQryTemplate = cChildQryTemplate + cChildFieldType + "('".
      END.  
        
      cChildQryTemplate = cChildQryTemplate + "<subst>" + STRING(iy).
        
      IF cChildFieldType NE cParentFieldType THEN 
        cChildQryTemplate = cChildQryTemplate + "')".
    END.       
        
    EMPTY TEMP-TABLE ttChildBaseQuery.
    
    CREATE QUERY hParentQuery.
    hParentQuery:SET-BUFFERS(hMainTTOrDS:GET-RELATION(iiQueryNum):PARENT-BUFFER).
    hParentQuery:QUERY-PREPARE("FOR EACH " + hMainTTOrDS:GET-RELATION(iiQueryNum):PARENT-BUFFER:NAME).
    hParentQuery:QUERY-OPEN().
    iy = 0.
    REPEAT WHILE hParentQuery:GET-NEXT().
      ASSIGN cChildBaseQuery = cChildQryTemplate
             iy = iy + 1
             .
      DO ix = 1 TO iNumFlds:
        ASSIGN cChildBaseQuery = REPLACE(cChildBaseQuery,"<subst>" + STRING(ix),"&1")
               cChildBaseQuery = SUBSTITUTE(cChildBaseQuery,hParentFlds[ix]:BUFFER-VALUE)
               .
      END.   
      FIND FIRST ttChildBaseQuery
           WHERE ttChildBaseQuery.baseQuery = cChildBaseQuery
           NO-ERROR.
      IF NOT AVAIL ttChildBaseQuery THEN DO:
        CREATE ttChildBaseQuery.
        ttChildBaseQuery.baseQuery = cChildBaseQuery.
      END.
    END.
        
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
    
    FINALLY:
      DELETE OBJECT hParentQuery.
    END FINALLY.
  END.  
  
  METHOD PROTECTED VOID deepCopyTT(ihFromTt AS HANDLE
                                  ,ihToTt AS HANDLE
                                  ,ibReplace AS LOG ) :
    DEF VAR hQuery   AS HANDLE NO-UNDO.
    DEF VAR ix       AS INT    NO-UNDO.
    DEF VAR hFromFld AS HANDLE NO-UNDO.
    
    IF ihFromTt:TYPE = "TEMP-TABLE" THEN ihFromTt = ihFromTt:DEFAULT-BUFFER-HANDLE.
    IF ihToTt:TYPE = "TEMP-TABLE" THEN ihToTt = ihToTt:DEFAULT-BUFFER-HANDLE.
    
    IF ibReplace THEN ihToTt:EMPTY-TEMP-TABLE ().
    
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
      ihFromTt::localRowid = STRING(ihToTt:ROWID).
    END.
    DELETE OBJECT hQuery.

  END METHOD.
  
  METHOD PROTECTED LOGICAL doUpdate (ihLocalBuffer AS HANDLE,ihQueryBuffer AS HANDLE):

    DEF VAR cFields AS CHAR NO-UNDO.
    DEF VAR cValues AS CHAR NO-UNDO.
    DEF VAR ix      AS INT  NO-UNDO.
    
    IF NOT ihLocalBuffer:AVAIL OR NOT ihQueryBuffer:AVAIL THEN RETURN NO.
    
    DO ix = 1 TO ihLocalBuffer:NUM-FIELDS:
      IF ihLocalBuffer:BUFFER-FIELD (ix):BUFFER-VALUE NE ihQueryBuffer:BUFFER-FIELD (ihLocalBuffer:BUFFER-FIELD(ix):NAME):BUFFER-VALUE THEN
        ASSIGN cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ihLocalBuffer:BUFFER-FIELD(ix):NAME
               cValues = cValues + (IF cValues NE "" THEN CHR(1) ELSE "") + ihLocalBuffer:BUFFER-FIELD(ix):BUFFER-VALUE
               .
    END.  
    
    IF cFields = "" THEN RETURN NO.

    DYNAMIC-FUNCTION("DoUpdate",(IF OEdbName NE "" THEN OEdbName + "." ELSE "") + ihQueryBuffer:NAME,
                    customUpdateValProc,
                    "",
                    ihQueryBuffer::RowIdent1,
                    cFields,
                    cValues,
                    NO).
    
  END METHOD.  

  METHOD PRIVATE INTEGER getChildQueryNum (icDbName     AS CHAR
                                          ,icBufferName AS CHAR):
    DEF VAR ix AS INT NO-UNDO.
    IF bDataset THEN DO:
      DO ix = 2 TO hMainTTOrDS:NUM-BUFFERS:
        IF hMainTTOrDS:GET-BUFFER-HANDLE(ix):TABLE-HANDLE:ADM-DATA NE "" AND hMainTTOrDS:GET-BUFFER-HANDLE (ix):ADM-DATA NE ?
           AND hMainTTOrDS:GET-BUFFER-HANDLE (ix):ADM-DATA = icBufferName
           AND hMainTTOrDS:GET-BUFFER-HANDLE (ix):PRIVATE-DATA = icDbName THEN 
          RETURN ix - 1.
      END.
      DO ix = 2 TO hMainTTOrDS:NUM-BUFFERS:
        IF hMainTTOrDS:GET-BUFFER-HANDLE (ix):NAME = icBufferName THEN 
          RETURN ix - 1.
      END.
    END.  
    RETURN 0.      
  END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC JBoxBE ( ):
    DEF VAR ix AS INT NO-UNDO.
    DO ix = 1 TO EXTENT(oDsChildQuery):
      IF VALID-OBJECT(oDsChildQuery[ix]) THEN DELETE OBJECT oDsChildQuery[ix]. 
    END.
    DELETE OBJECT mainQuery.
	END DESTRUCTOR.


END CLASS.