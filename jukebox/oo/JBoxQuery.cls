 
 /*------------------------------------------------------------------------
    File        : JBoxQuery
    Purpose     : 
    Syntax      : 
    Description : OO Wrapper for library function NewQuery
    Author(s)   : brynjar
    Created     : Tue Nov 05 10:47:14 CEST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

/*USING oo.* FROM PROPATH.*/

CLASS JBoxQuery: 
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DEF VAR hSourceProc     AS HANDLE NO-UNDO.
	DEF VAR bOk             AS LOG    NO-UNDO.
	DEF VAR bTryFilter      AS LOG    NO-UNDO. /* Clear the filter if no records were found */
	DEF VAR bNoExecFilter   AS LOG    NO-UNDO.
	DEF VAR cLastFilter     AS CHAR   NO-UNDO.
	DEF VAR cInitAttr       AS CHAR   NO-UNDO.
	DEF VAR cSortExpr       AS CHAR   NO-UNDO.
	DEF VAR cQueryJoin      AS CHAR   NO-UNDO.
	DEF VAR hTableHandle    AS HANDLE NO-UNDO.
	DEF VAR oToolbar        AS JBoxToolbar   NO-UNDO.
	DEF VAR cCallFromMethod AS CHAR   NO-UNDO.
  DEF VAR oFieldMap       AS JBoxFieldMap NO-UNDO.
  
  DEF TEMP-TABLE ttFieldBufferRef NO-UNDO // To identify correct table for fields in sql query  
      FIELD BufferName AS CHAR            // Buffer-ref is added as pipe-entry 6 in buffersandfield ref
      FIELD FieldName  AS CHAR                
      INDEX idxField FieldName 
      .

  DEF PUBLIC PROPERTY QUERY-HANDLE         AS HANDLE GET. PROTECTED SET.
  DEF PUBLIC PROPERTY BUFFER-HANDLE        AS HANDLE GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY TABLE-HANDLE         AS HANDLE GET. PROTECTED SET.
  DEF PUBLIC PROPERTY PARENT-BROWSE-OBJECT AS JBoxBrowse GET. PROTECTED SET.
  DEF PUBLIC PROPERTY PARENT-QUERY-OBJECT  AS JBoxQuery  GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY CHILD-BROWSE-OBJECT  AS JBoxBrowse GET. SET. 
  DEF PUBLIC PROPERTY CHILD-QUERY-OBJECT   AS JBoxQuery  GET. SET.
  DEF PUBLIC PROPERTY CONTAINER-OBJECT     AS JBoxContainer GET. SET.    
  DEF PUBLIC PROPERTY SOURCE-FILE-HANDLE    AS HANDLE    GET(): RETURN hSourceProc. END GET. PROTECTED SET.
  
  DEF PUBLIC PROPERTY PARENT-BUFFER-HANDLE AS HANDLE 
      GET():
         DEF VAR hParent AS HANDLE NO-UNDO.
         hParent = DYNAMIC-FUNCTION("getLinkedObject",QUERY-HANDLE,"parent","from").
         IF VALID-HANDLE(hParent) THEN DO:
           IF hParent:TYPE = "browse" THEN RETURN hParent:QUERY:GET-BUFFER-HANDLE(1).
           ELSE RETURN hParent:GET-BUFFER-HANDLE(1).
         END.  
         ELSE RETURN ?.  
      END GET.
      PROTECTED SET.
                      
//  {JBoxBrowseQueryProp.i QUERY-HANDLE}
  DEF PUBLIC PROPERTY TOOLBAR-OBJECT AS JBoxToolbar GET. 
      SET(ioToolbar AS JBoxToolbar):
        IF NOT VALID-OBJECT(ioToolbar) THEN DO:
          IF VALID-OBJECT(oToolbar) THEN
            DYNAMIC-FUNCTION ("DeleteObjectLink",QUERY-HANDLE,oToolbar:TOOLBAR-HANDLE).
        END.
        ELSE DYNAMIC-FUNCTION("createObjectLink",QUERY-HANDLE,ioToolbar:TOOLBAR-HANDLE).
        oToolbar = ioToolbar.
        TOOLBAR-OBJECT = ioToolbar.
      END SET.

  DEF PUBLIC PROPERTY FIELDMAP-OBJECT AS JBoxFieldMap GET. 
      SET(ioFieldMap AS JBoxFieldMap):
        IF NOT VALID-OBJECT(ioFieldMap) THEN DO:
          IF VALID-OBJECT(oFieldMap) THEN
            DYNAMIC-FUNCTION ("DeleteObjectLink",QUERY-HANDLE,oFieldMap:BUFFER-HANDLE).
        END.
        ELSE DYNAMIC-FUNCTION("createObjectLink",QUERY-HANDLE,ioFieldMap:BUFFER-HANDLE).
        oFieldMap = ioFieldMap.
        FIELDMAP-OBJECT = ioFieldMap.
      END SET.

  DEF PUBLIC PROPERTY TAB-FOLDER-OBJECT AS JBoxMsTabs GET. SET. 

  DEF PUBLIC PROPERTY filterExcludeFields AS CHAR /* <field>,<field>,..*/
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"filterExcludeFields"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterExcludeFields",icAttr).
      END SET.
   
  DEF PUBLIC PROPERTY baseQuery AS CHAR /* WHERE ..*/
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"baseQuery"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"baseQuery",icAttr).
      END SET.
      
  DEF PUBLIC PROPERTY preScanBaseQuery AS CHAR /* To view customers for salesrep names matching *b*a* (Salesrep doesn't need to be included in the query): Salesrep WHERE Repname MATCHES '*b*a*',EACH Customer NO-LOCK OF Salesrep */
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"preScanBaseQuery"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"preScanBaseQuery",icAttr).
      END SET.

  DEF PUBLIC PROPERTY preScanQueryWhere AS CHAR /* Ff a searchfield is implemented this property is automatically maintained based on the (internal) prescanQuery<table> attribute. Use the method setPrescanQuery */
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"preScanQueryWhere"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"preScanQueryWhere",icAttr).
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"keepsearchvalue","yes").
      END SET.

  DEF PUBLIC PROPERTY preScanQueryFilter AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"preScanQueryFilter"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"preScanQueryFilter",icAttr).
      END SET.
        
  DEF PUBLIC PROPERTY calcFieldProc AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"calcFieldProc"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"calcFieldProc",icAttr).
      END SET.  

  DEF PUBLIC PROPERTY queryFilter AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryFilter"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"queryFilter",icAttr).
      END SET.  

  DEF PUBLIC PROPERTY queryWhere AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryWhere"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"queryWhere",icAttr).
      END SET.

  DEF PUBLIC PROPERTY altPrimaryBufferList AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"altPrimaryBufferList"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"altPrimaryBufferList",icAttr).
      END SET.

  DEF PUBLIC PROPERTY calcFieldFilter AS CHAR /* <fieldname>¤<operator>¤<value>|<fieldname>¤.. */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"calcFieldFilter"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"calcFieldFilter",icAttr).
      END SET.
        
  DEF PUBLIC PROPERTY calcFieldWhere AS CHAR /* <fieldname>¤<operator>¤<value>|<fieldname>¤.. */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"calcFieldWhere"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"calcFieldWhere",icAttr).
      END SET.  

  DEF PUBLIC PROPERTY allowCan-DoFilterOperator AS CHAR /* <fieldname>,<fieldname>,.. */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"allowCan-DoFilterOperator"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"allowCan-DoFilterOperator",icAttr).
      END SET.  
      
  DEF PUBLIC PROPERTY parentLink AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"parentLink"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"parentLink",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY useLocalData AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"useLocalData") = "yes". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"useLocalData",STRING(ibSetting)).
      END SET.
      
  DEF PUBLIC PROPERTY IsCurrent  AS LOG 
      GET(): 
        RETURN THIS-OBJECT:QUERY-HANDLE = DYNAMIC-FUNCTION ("getCurrentObject"). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY recordAvailable  AS LOG 
      GET(): 
       IF VALID-HANDLE(BUFFER-HANDLE) THEN RETURN BUFFER-HANDLE:AVAIL. ELSE RETURN NO. END GET. 
      PROTECTED SET.

  DEF PUBLIC PROPERTY querySort  AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"querySort"). END GET. 
      PROTECTED SET. /* use setSortString to set */
      
  DEF PUBLIC PROPERTY localSort  AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"localSort"). END GET. 
      PROTECTED SET. /* use setSortString to set */

  DEF PUBLIC PROPERTY getRecordCount AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"getRecordCount") NE "NO". END GET.
      SET(ibSet AS LOG): 
        IF ibSet THEN
          DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"getRecordCount","yes").
        ELSE
          DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"getRecordCount","no").
      END SET.
        
  DEF PUBLIC PROPERTY currentCount AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"currentCount")). END GET.
      SET(iiSet AS INT): DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"currentCount",STRING(iiSet)). END SET.  

  DEF PUBLIC PROPERTY recordCount AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"recordCount")). END GET.
      SET(iiSet AS INT): DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"recordCount",STRING(iiSet)). END SET.  

  DEF PUBLIC PROPERTY totalCount AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"totalCount")). END GET.
      SET(iiSet AS INT): DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"totalCount",STRING(iiSet)). END SET.  

  DEF PUBLIC PROPERTY queryFromLast AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryDir") NE "". END GET.
      SET(ibSet AS LOG): DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"queryDir",IF ibSet THEN "desc" ELSE ""). END SET.  

  DEF PUBLIC PROPERTY viewRecordCount AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"viewRecordCount") NE "NO". END GET.
      SET(ibSet AS LOG): 
        IF ibSet THEN
          DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"viewRecordCount","yes").
        ELSE
          DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"viewRecordCount","no").
      END SET.

  DEF PUBLIC PROPERTY objectState AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getObjectState",QUERY-HANDLE). END GET. 
      SET(icState AS CHAR): 
        DYNAMIC-FUNCTION("setObjectState",QUERY-HANDLE,icState).  
      END SET. 
      
  DEF PUBLIC PROPERTY filterFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"filterFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterFields",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY flatViewBuffersAndFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"flatViewBuffersAndFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"flatViewBuffersAndFields",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY flatViewQueryJoin AS CHAR 
      GET(): RETURN TRIM(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"flatViewQueryJoin"),"-"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"flatViewQueryJoin",IF icSetting = "" THEN "-" ELSE icSetting).
      END SET.

  DEF PUBLIC PROPERTY flatViewTitle AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"flatViewTitle"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"flatViewTitle",icSetting).
      END SET.

  DEF PUBLIC PROPERTY flatViewOuterJoin AS LOG /* Can be set on each query in a chain. If set on the top level it applies to all levels */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"flatViewJoinType") = "outer-join". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"flatViewJoinType",IF ibSetting THEN "OUTER-JOIN" ELSE "").
      END SET.

  DEF PUBLIC PROPERTY flatViewRecordCount AS LOG /* Must be set on top-level browse/query. Default ON */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"flatViewRecordCount") NE "no". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"flatViewRecordCount",STRING(ibSetting)).
      END SET.

  DEF PUBLIC PROPERTY excludeFromFlatView AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"excludeFromFlatView") = "yes". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"excludeFromFlatView",STRING(ibSetting)).
      END SET.

  DEF PUBLIC PROPERTY accumDataTypes AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"accumDataTypes"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"accumDataTypes",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY availAccumFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"availAccumFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"availAccumFields",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY accumFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"accumFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"accumFields",icSetting).
      END SET.

  DEF PUBLIC PROPERTY distinctDataTypes AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"distinctDataTypes"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"distinctDataTypes",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY availDistinctColumns AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"availDistinctColumns"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"availDistinctColumns",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY distinctColumns AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"distinctColumns"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"distinctColumns",icSetting).
      END SET.

  DEF PUBLIC PROPERTY queryStatFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryStatFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"queryStatFields",icSetting).
      END SET.

  DEF PUBLIC PROPERTY skipServerSort AS LOGICAL 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"skipServerSort") = "yes". END GET. 
      SET(ibSetting AS LOGICAL): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"skipServerSort",IF ibSetting THEN "yes" ELSE "").
      END SET.

  DEF PUBLIC PROPERTY userSettingContext AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"userSettingContext"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"userSettingContext",icSetting).
      END SET.

  DEF PUBLIC PROPERTY fieldNameDeleteWarning AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"fieldNameDeleteWarning"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"fieldNameDeleteWarning",icSetting).
      END SET.

  DEF PUBLIC PROPERTY lastRecord AS LOG 
      GET(): RETURN VALID-HANDLE(BUFFER-HANDLE) AND BUFFER-HANDLE:AVAIL AND DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"lastRowid") = STRING(BUFFER-HANDLE:ROWID). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY firstRecord AS LOG 
      GET(): RETURN VALID-HANDLE(BUFFER-HANDLE) AND BUFFER-HANDLE:AVAIL AND DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"firstRowid") = STRING(BUFFER-HANDLE:ROWID). END GET. 
      PROTECTED SET.

  DEF PUBLIC PROPERTY activeFilter AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryFilter") NE "" 
                 OR DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"prescanQueryFilter") NE ""
                 OR DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"calcFieldFilter") NE "". 
      END GET. 
      PROTECTED SET.
            
  DEF PUBLIC PROPERTY queryStopAfter AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryStopAfter")). END GET. 
      SET(iiSetting AS INTEGER): 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"queryStopAfter",STRING(iiSetting)).
      END SET.

  DEF PUBLIC PROPERTY skipRows AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"BatchQueryStart")). END GET. 
      SET(ipSkipRows AS INT):
        ipSkipRows = if ipSkipRows = ? then 0 else ipSkipRows. 
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"BatchQueryStart",STRING(ipSkipRows)). END SET. 
              
                                            
  DEF PUBLIC PROPERTY rowsToBatch      AS INT   INIT 100 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"rowsToBatch")). 
      END GET. 
      SET(iiRowsToBatch AS INT):
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"rowsToBatch",STRING(iiRowsToBatch)).
      END SET.

  DEF PUBLIC PROPERTY batchQueryStart  AS INT    
      GET(): RETURN INT(getJBoxAttribute("BatchQueryStart")). 
      END GET. 
      SET(iiStartRow AS INT):
        IF iiStartRow = ? OR iiStartRow = 0 OR iiStartRow = 1 THEN 
          setJBoxAttribute("BatchQueryStart","").
        ELSE 
          setJBoxAttribute("BatchQueryStart",STRING(iiStartRow - 1)).
      END SET.

  DEF PUBLIC PROPERTY keepData      AS LOG 
      GET(): RETURN getJBoxAttribute("keepData") = "yes".
      END GET.
      SET(ibSet AS LOG):
        setJBoxAttribute("keepData",IF ibSet THEN "yes" ELSE "").
      END.    

  DEF PUBLIC PROPERTY lastQuery      AS CHAR 
      GET(): RETURN getJBoxAttribute("statvalueLastQuery").
      END GET.
      PROTECTED SET.    

  DEFINE PUBLIC PROPERTY SQLdbName AS CHAR 
      GET:
        DEF VAR cSqlDb AS CHAR NO-UNDO.
        cSqlDb = THIS-OBJECT:getJBoxAttribute("sqlDbname").
        IF cSqlDb = "" THEN RETURN SQLdbName.
        ELSE RETURN cSqlDb.
      END GET.   
      PRIVATE SET(icSqlDbName AS CHAR):
        SQldbName = icSqlDbName.
        THIS-OBJECT:setJBoxAttribute("sqlDbname",icSQLdbName).
      END SET.
   
  DEF PUBLIC PROPERTY queryJoin AS CHAR
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryJoin"). END GET.
      SET(icQueryJoin AS CHAR):
        DEF VAR ix          AS INT NO-UNDO.
        DEF VAR cBufferJoin AS CHAR NO-UNDO.
        DEF VAR cBuffer     AS CHAR NO-UNDO.
        icQueryJoin = TRIM(icQueryJoin).
        IF NOT icQueryJoin BEGINS "," THEN icQueryJoin = "," + icQueryJoin.
        DO ix = 2 TO NUM-ENTRIES(icQueryJoin):
          cBufferJoin = TRIM(ENTRY(ix,icQueryJoin)).
          IF SUBSTR(cBufferJoin,1,6) = "first " OR
             SUBSTR(cBufferJoin,1,5) = "last " OR
             SUBSTR(cBufferJoin,1,5) = "each " THEN
            cBuffer = ENTRY(1,TRIM(SUBSTR(cBufferJoin,6))," ").
          ELSE
            cBuffer = ENTRY(1,cBufferJoin," ").
          DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"bufferJoin" + cBuffer,"," + cBufferJoin).
        END.
        DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"queryJoin",(IF SQLdbName NE "" THEN CHR(1) ELSE "") + icQueryJoin).
        IF QUERY-HANDLE:TYPE NE "Query" THEN cQueryJoin = icQueryJoin.
      END SET.
        
  DEF PUBLIC PROPERTY buffersAndFields AS CHAR
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"buffersAndFields"). END GET.
      SET(icBuffersAndFields AS CHAR):
        DEF VAR ix            AS INT    NO-UNDO.
        DEF VAR cBufferList   AS CHAR   NO-UNDO.
        DEF VAR cTtField      AS CHAR   NO-UNDO.
        DEF VAR cTtFieldList  AS CHAR   NO-UNDO.

        IF NOT (icBuffersAndFields NE "" AND QUERY-HANDLE NE ? AND DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"tempTableHandle") NE "") THEN DO:
          DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields):
            cBufferList = cBufferList + "," + ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
          END.  
          IF VALID-HANDLE(QUERY-HANDLE) THEN DYNAMIC-FUNCTION("deleteObject",QUERY-HANDLE).
          DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).  
          QUERY-HANDLE = DYNAMIC-FUNCTION("NewQuery",rowsToBatch,"",icBuffersAndFields,"where false" + cBufferList
                                         ,"TEMP-TABLE|" + STRING(hTableHandle)).
          BUFFER-HANDLE = QUERY-HANDLE:GET-BUFFER-HANDLE(1).
          DYNAMIC-FUNCTION("CreateObjectLink",QUERY-HANDLE,hSourceProc).
          
          DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"useLocalData","").
          cBufferList = DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"bufferList").
        END.
        ELSE DO:
          DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields,";"):
            cTtField = ENTRY(ix,icBuffersAndFields,";").
            IF NUM-ENTRIES(cTtField) > 1 THEN
              cTtField = ENTRY(2,cTtField).
            cTtFieldList = cTtFieldList + (IF cTtFieldList NE "" THEN "," ELSE "") + ENTRY(1,cTtField,"|").
          END.    
          THIS-OBJECT:filterFields = cTtFieldList. /* fikset for sql */
        END.
        IF cSortExpr NE "" THEN
          DYNAMIC-FUNCTION("setSortString",QUERY-HANDLE,cSortExpr).     
        IF cQueryJoin NE "" THEN
          queryJoin = cQueryJoin.  
      END SET.

  DEF PUBLIC PROPERTY queryError   AS LOG  NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY errorMessage AS CHAR NO-UNDO GET. PROTECTED SET.
              	
  CONSTRUCTOR PUBLIC JBoxQuery():
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.     
    
    InitializeComponent("",?).     
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxQuery (icQueryNameOrBuffsAndFlds AS CHAR):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.     
        
    InitializeComponent(icQueryNameOrBuffsAndFlds,?).     
      
  END CONSTRUCTOR.
  
  CONSTRUCTOR PUBLIC JBoxQuery (icBuffersAndFields AS CHAR
                               ,icSQLdbName      AS CHAR):

    DEF VAR cField                AS CHAR   NO-UNDO.
    DEF VAR cBuffersAndFields     AS CHAR   NO-UNDO.
    DEF VAR cViewBuffersAndFields AS CHAR   NO-UNDO.
    DEF VAR ix                    AS INT    NO-UNDO.
    DEF VAR hBuffer               AS HANDLE NO-UNDO.
    DEF VAR hTT                   AS HANDLE NO-UNDO. 
    DEF VAR hTTStatic             AS HANDLE NO-UNDO. 
    DEF VAR hFld                  AS HANDLE NO-UNDO.
    DEF VAR cCalcFlds             AS CHAR   NO-UNDO.
    DEF VAR cCalcParams           AS CHAR   NO-UNDO.    
    DEF VAR cBufferList           AS CHAR   NO-UNDO.   
    DEF VAR cQueryJoin            AS CHAR   NO-UNDO.     
    DEF VAR cDataSourceType       AS CHAR   NO-UNDO.  
    DEF VAR cBufferDef            AS CHAR   NO-UNDO.
    DEF VAR cBufferFields         AS CHAR   NO-UNDO.
    DEF VAR cFieldDef             AS CHAR   NO-UNDO.
    DEF VAR iy                    AS INT    NO-UNDO.
    DEF VAR cNotExist             AS CHAR   NO-UNDO.

    SUPER ().

    hSourceProc = SOURCE-PROCEDURE.
        
    IF icSQLdbName = "" THEN DO:         
                              
      InitializeComponent(icBuffersAndFields,?).     
      RETURN.
    END.
    
    IF CAN-DO("webclient,4glclient",SESSION:CLIENT-TYPE) AND NOT SESSION:BATCH-MODE AND DYNAMIC-FUNCTION("getAttribute",SESSION,"serverMode") = "" THEN
      SQLdbName = JBoxServerApi:Instance:getDataSourceConnection (icSQLdbName).
    ELSE 
      SQLdbName = JBoxServerSide:Instance:getDataSourceConnection (icSQLdbName).
      
//    IF SQLdbName = "" THEN
      SQLdbName = icSQLdbName.
           
    IF INDEX(icBuffersAndFields,";") = 0 THEN DO:
      IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getTableHandleQry" + icBuffersAndFields) THEN 
        hTTStatic = DYNAMIC-FUNCTION("getTableHandleQry" + icBuffersAndFields IN hSourceProc).

      IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getQueryJoinQry" + icBuffersAndFields) THEN 
        cQueryJoin = TRIM(DYNAMIC-FUNCTION("getQueryJoinQry" + icBuffersAndFields IN hSourceProc),",").

      IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getBuffersAndFieldsQry" + icBuffersAndFields) THEN 
        icBuffersAndFields = DYNAMIC-FUNCTION("getBuffersAndFieldsQry" + icBuffersAndFields IN hSourceProc).
    END.    
    
    DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields,";"):
      IF NUM-ENTRIES(ENTRY(ix,icBuffersAndFields,";"),"|") > 3 AND ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|") NE "" THEN
        ASSIGN cCalcFlds   = cCalcFlds + (IF cCalcFlds NE "" THEN "," ELSE "") + TRIM(ENTRY(1,ENTRY(ix,icBuffersAndFields,";"),"|"),"+")
               cCalcParams = cCalcParams + (IF cCalcParams NE "" THEN "," ELSE "") + ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|")
               .
    END.

    EMPTY TEMP-TABLE ttFieldBufferRef.
    
    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      cBufferDef = ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
      IF cBufferDef BEGINS "NOT EXIST " THEN 
        ASSIGN cBufferDef = TRIM(SUBSTR(cBufferDef,11))
               cNotExist = cNotExist + (IF cNotExist NE "" THEN "," ELSE "") 
                         + ENTRY(NUM-ENTRIES(cBufferDef,"."),cBufferDef,".") 
               .
      cBufferFields = ENTRY(ix,icBuffersAndFields).
      IF NUM-ENTRIES(cBufferDef,".") > 1 THEN cBufferDef = ENTRY(2,cBufferDef,".").
      cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + cBufferDef.
      
      cBuffersAndFields = cBuffersAndFields + (IF cBuffersAndFields NE "" THEN "," ELSE "") + cBufferFields.
      IF NUM-ENTRIES(cBufferFields,";") = 1 THEN 
        ASSIGN cBufferFields = REPLACE(JBoxSqlSchemaHelper:Instance:getTableAblColumns(SQLdbName,cBufferDef),",",";")
               cBuffersAndFields = cBuffersAndFields + ";" + cBufferFields.
        
      
      DO iy = 1 TO NUM-ENTRIES(cBufferFields,";"):
        cFieldDef = ENTRY(1,ENTRY(iy,cBufferFields,";"),"@").
        FIND FIRST ttFieldBufferRef
             WHERE ttFieldBufferRef.FieldName = LEFT-TRIM(ENTRY(1,cFieldDef,"|"),"!")
             NO-ERROR. 
        IF NOT AVAIL ttFieldBufferRef THEN DO:     
          CREATE ttFieldBufferRef.
          ASSIGN ttFieldBufferRef.BufferName = cBufferDef
                 ttFieldBufferRef.FieldName  = LEFT-TRIM(ENTRY(1,cFieldDef,"|"),"!")
                 .
        END.   
        ELSE DO:
          CREATE ttFieldBufferRef.
          ASSIGN ttFieldBufferRef.BufferName = cBufferDef
                 ttFieldBufferRef.FieldName  = LEFT-TRIM(ENTRY(1,cFieldDef,"|"),"!") + STRING(ix)
                 .
        END.         
      END.  
    END.

    IF VALID-HANDLE(hTTStatic) THEN 
      hTT = hTTStatic.
    ELSE
      hTT = JBoxSqlSchemaHelper:Instance:getTtDef (SQLdbName,cBuffersAndFields).

    THIS-OBJECT:InitializeComponent("",hTT).
  
    THIS-OBJECT:setJBoxAttribute("sqlDbname",SQLdbName).
    THIS-OBJECT:setJBoxAttribute("numbuffers",STRING(NUM-ENTRIES(cBufferList))).

    hBuffer = hTT:DEFAULT-BUFFER-HANDLE.
        
    cBuffersAndFields = hBuffer:NAME.
    cViewBuffersAndFields = hBuffer:NAME.
      
    DO ix = 1 TO hBuffer:NUM-FIELDS:
      IF NOT hBuffer:BUFFER-FIELD(ix):NAME BEGINS "RowIdent" AND NOT hBuffer:BUFFER-FIELD(ix):NAME BEGINS "RowCount" THEN DO:
        cField = hBuffer:BUFFER-FIELD(ix):NAME + "|" 
               + hBuffer:BUFFER-FIELD(ix):DATA-TYPE + "|"
               + REPLACE(hBuffer:BUFFER-FIELD(ix):FORMAT,",","<") + "|"
               + (IF CAN-DO(cCalcFlds,hBuffer:BUFFER-FIELD (ix):NAME) THEN ENTRY(LOOKUP(hBuffer:BUFFER-FIELD (ix):NAME,cCalcFlds),cCalcParams) ELSE "")  
               + "|"
               .
        FIND FIRST ttFieldBufferRef
             WHERE ttFieldBufferRef.FieldName = hBuffer:BUFFER-FIELD(ix):NAME
             NO-ERROR.         
        IF AVAIL ttFieldBufferRef THEN
          cField = cField + "|"
                 + (IF CAN-DO(cNotExist,ttFieldBufferRef.BufferName) THEN "NOT EXIST " ELSE "") 
                 + ttFieldBufferRef.BufferName.
        ELSE IF CAN-DO(cCalcFlds,hBuffer:BUFFER-FIELD (ix):NAME) THEN DO:
          FIND FIRST ttFieldBufferRef
               WHERE ttFieldBufferRef.FieldName = "+" + hBuffer:BUFFER-FIELD (ix):NAME
               NO-ERROR.         
          IF AVAIL ttFieldBufferRef THEN
            cField = cField + "|" + ttFieldBufferRef.BufferName.
        END.
        IF AVAIL ttFieldBufferRef THEN DO:
          THIS-OBJECT:setJBoxAttribute("fieldbuffer" + hBuffer:BUFFER-FIELD(ix):NAME,ttFieldBufferRef.BufferName).
          ENTRY(1,cField,"|") = ttFieldBufferRef.FieldName. 
        END.  

        cBuffersAndFields = cBuffersAndFields + ";" + cField.
             
        IF NOT cField BEGINS "jbCount" AND NOT cField BEGINS "jbAverage" THEN  
          cViewBuffersAndFields = cViewBuffersAndFields + ";" + cField.
      END.                    
    END.   
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"buffersAndFields",cBuffersAndFields).
    IF cQueryJoin NE "" THEN
      DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"queryjoin","," + TRIM(cQueryJoin,",")).
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"viewbuffersandfields",cViewBuffersAndFields).
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"tempTableHandle",STRING(hBuffer:TABLE-HANDLE)).
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"basetablefields","").
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"basetablefilterfields","").
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"bufferlist",cBufferList).
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"numbuffers",STRING(NUM-ENTRIES(cBufferList))).
    IF cCalcFlds NE "" THEN
      DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"allcalcfields",DYNAMIC-FUNCTION("getAttribute",THIS-OBJECT:QUERY-HANDLE,"allcalcfields") + "," + cCalcFlds).

    THIS-OBJECT:useLocalData = NO.  
            
    THIS-OBJECT:setJBoxAttribute("sqlDbname",SQLdbName).
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxQuery (iTABLE-HANDLE AS HANDLE):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
                         
    InitializeComponent("",iTABLE-HANDLE).         
    useLocalData = YES.        
      
  END CONSTRUCTOR.
 
  METHOD PRIVATE VOID initializeComponent(icQueryTableName   AS CHAR 
                                         ,iTABLE-HANDLE AS HANDLE):
    DEF VAR ix                AS INT  NO-UNDO.
    DEF VAR cBuffsAndFlds     AS CHAR NO-UNDO.
    DEF VAR cDefBuffsAndFlds  AS CHAR NO-UNDO.
    DEF VAR cBufferList       AS CHAR NO-UNDO.
    DEF VAR cCalcFlds         AS CHAR NO-UNDO.
    DEF VAR iy                AS INT  NO-UNDO.
    DEF VAR cDbFields         AS CHAR NO-UNDO.
    DEF VAR cBufferDef        AS CHAR NO-UNDO.
    DEF VAR cFieldDef         AS CHAR NO-UNDO.
    DEF VAR cCalcFldProc      AS CHAR NO-UNDO.
    DEF VAR cCalcParams       AS CHAR NO-UNDO.
    DEF VAR cDistinctCols     AS CHAR NO-UNDO.
    DEF VAR cAccumFields      AS CHAR NO-UNDO.
                                                       
    DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).
    DYNAMIC-FUNCTION("NewObject",
                     IF VALID-HANDLE(hSourceProc:CURRENT-WINDOW) THEN hSourceProc:CURRENT-WINDOW ELSE ?,
                     hSourceProc,"procedure").

    IF icQueryTableName NE "" AND CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getBuffersAndFieldsQry" + icQueryTableName) THEN DO: 
      cDefBuffsAndFlds = DYNAMIC-FUNCTION("getBuffersAndFieldsQry" + icQueryTableName IN hSourceProc).
      DO ix = 1 TO NUM-ENTRIES(cDefBuffsAndFlds):
        ASSIGN cDbFields = ""
               cCalcFlds = ""
               cBufferDef = ENTRY(ix,cDefBuffsAndFlds).
               
        IF NUM-ENTRIES(cBufferDef,";") > 1 THEN DO iy = 2 TO NUM-ENTRIES(cBufferDef,";"):
          cFieldDef = ENTRY(iy,cBufferDef,";").
          IF cFieldDef BEGINS "+" OR cFieldDef BEGINS "!+" THEN 
            cCalcFlds = cCalcFlds + (IF cCalcFlds NE "" THEN ";" ELSE "") + cFieldDef.
          ELSE
            cDbFields = cDbFields + (IF cDbFields NE "" THEN ";" ELSE "") + cFieldDef.            
        END.  
        cBuffsAndFlds = cBuffsAndFlds + (IF cBuffsAndFlds NE "" THEN "," ELSE "") + ENTRY(1,cBufferDef,";")
                      + ";" + (IF cDbFields = "" THEN DYNAMIC-FUNCTION("getFieldsForTable",ENTRY(1,cBufferDef,";")) ELSE cDbFields) 
                      + (IF cCalcFlds NE "" THEN ";" + cCalcFlds ELSE "").
      END.  
      cQueryJoin    = TRIM(DYNAMIC-FUNCTION("getQueryJoinQry" + icQueryTableName IN hSourceProc),",").
      hTableHandle  = DYNAMIC-FUNCTION("getTableHandleQry" + icQueryTableName IN hSourceProc).
      IF cQueryJoin NE "" THEN
        DYNAMIC-FUNCTION("setAttribute",hTableHandle,"queryJoin",(IF SQLdbName NE "" THEN CHR(1) ELSE "") + "," + cQueryJoin).
    END.
    ELSE IF NOT VALID-HANDLE(iTABLE-HANDLE) THEN cBuffsAndFlds = icQueryTableName.  
        
    IF VALID-HANDLE(iTABLE-HANDLE) THEN DO:
      IF iTABLE-HANDLE:TYPE = "buffer" THEN DO:
        DYNAMIC-FUNCTION("setAttribute",iTABLE-HANDLE,"tempTableHandle",STRING(iTABLE-HANDLE:TABLE-HANDLE)).
        hTableHandle = iTABLE-HANDLE:TABLE-HANDLE.
      END.  
      ELSE DO:
        DYNAMIC-FUNCTION("setAttribute",iTABLE-HANDLE,"tempTableHandle",STRING(iTABLE-HANDLE)).
        hTableHandle = iTABLE-HANDLE.
      END.  
      buffersAndFields = "". /* Creates the Query - no need to set buffers and fields from container */
    END.  
    ELSE IF cBuffsAndFlds NE "" THEN 
      THIS-OBJECT:buffersAndFields = cBuffsAndFlds. /* Creates the query */

    IF DYNAMIC-FUNCTION("getAttribute",SESSION,"rowsToBatch") NE "" THEN
      THIS-OBJECT:rowsToBatch = INT(DYNAMIC-FUNCTION("getAttribute",SESSION,"rowsToBatch")).
    ELSE               
      THIS-OBJECT:rowsToBatch = 200.      
                                          
    PUBLISH "setChildQueryObject" FROM hSourceProc (hSourceProc,THIS-OBJECT).                              
    PUBLISH "setContainerQueryObject" FROM hSourceProc (hSourceProc,THIS-OBJECT). /* publish to container class */                             

    IF CAN-DO("4GLclient,webclient",SESSION:CLIENT-TYPE) AND DYNAMIC-FUNCTION("getAttribute",SESSION,"serverMode") NE "yes" THEN
      JBoxLookupDef:Instance:assignFilterLookup(THIS-OBJECT).
    
  END METHOD.                                       

  METHOD PUBLIC VOID InitFilterGroup(icFilterGroupName AS CHAR
                                    ,icGroupOperator   AS CHAR  ):
    
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterGroup_Operator_" + icFilterGroupName,icFilterGroupName + "|" + icGroupOperator).

  END METHOD.

  METHOD PUBLIC VOID addFilterGroupCriteria (icFilterGroupName AS CHAR
                                            ,icFieldOperator   AS CHAR  
                                            ,icFieldName       AS CHAR
                                            ,icOperator        AS CHAR
                                            ,icValue           AS CHAR):
    
    DEF VAR iFieldInstCnt AS INT NO-UNDO.
    
    iFieldInstCnt = INT(DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE, "filterGroup_" + icFilterGroupName + "_FieldCnt_" + icFieldName)) + 1.
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterGroup_" + icFilterGroupName + "_FieldCnt_" + icFieldName,STRING(iFieldInstCnt)).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterGroup_" + icFilterGroupName + "_FieldName_" + icFieldName,icFieldName).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterGroup_" + icFilterGroupName + "_FieldOperator_" + icFieldName + "_" + STRING(iFieldInstCnt),icFieldOperator).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterGroup_" + icFilterGroupName + "_Operator_" + icFieldName + "_" + STRING(iFieldInstCnt),icOperator).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterGroup_" + icFilterGroupName + "_Value_" + icFieldName + "_" + STRING(iFieldInstCnt),icValue).

  END METHOD.

  METHOD PRIVATE CHARACTER getFilterOper(INPUT icOper AS CHAR):
    
    DEFINE VARIABLE ocOper AS CHARACTER NO-UNDO.
  
    CASE icOper:
      WHEN "EQ" THEN ocOper = "=".
      WHEN "NE" THEN ocOper = "<>".
      WHEN "GE" THEN ocOper = ">=".
      WHEN "LE" THEN ocOper = "<=".
      WHEN "GT" THEN ocOper = ">".
      WHEN "LT" THEN ocOper = "<".
      OTHERWISE ocOper = icOper.
    END CASE.  

    RETURN ocOper.

  END METHOD.

  METHOD PUBLIC LOGICAL applyFilter(icExprList AS CHAR):
    DEF VAR cFields    AS CHAR NO-UNDO.
    DEF VAR cOperators AS CHAR NO-UNDO.
    DEF VAR cValues    AS CHAR NO-UNDO.

    DEF VAR hToolbar AS HANDLE NO-UNDO.
    hToolbar = DYNAMIC-FUNCTION("getLinkedObject",QUERY-HANDLE,"toolbar","from").

    bOK = NO.                                  
    IF resolveFilterExpr(IF icExprList = "" THEN cLastFilter ELSE icExprList,OUTPUT cFields,OUTPUT cOperators,OUTPUT cValues) THEN DO:                                  
      IF QUERY-HANDLE:TYPE = "Query" THEN DO:                                  
        bOK = DYNAMIC-FUNCTION("InitDynFilter",QUERY-HANDLE,cFields,cOperators,cValues,
                                (IF hToolbar = ? OR DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonFilter") = "" THEN "static" ELSE "") +
                                (IF bNoExecFilter THEN "noexec" ELSE IF bTryFilter THEN "try" ELSE "")).
        DYNAMIC-FUNCTION("setCurrentObject",QUERY-HANDLE).
      END.                          
      ELSE
        MESSAGE "Filter cannot be applied before object is initialized, ie buffers and fields are defined (buffersAndFields property)"
        VIEW-AS ALERT-BOX.
    END.
    ELSE
      MESSAGE "Error in filter definition: " + icExprList.
      
    ASSIGN bTryFilter = NO
           bNoExecFilter = NO
           cLastFilter = "".

    RETURN bOk.      
  END METHOD.
  
  METHOD PUBLIC LOGICAL applyFilter(icExprList AS CHAR,ibTry AS LOG):
    bTryfilter = ibTry.
    RETURN applyFilter(IF icExprList = "" THEN cLastFilter ELSE icExprList).
  END METHOD.
  
  METHOD PUBLIC LOGICAL applyFilter(icFieldList AS CHAR
                                   ,icOperList  AS CHAR
                                   ,icValueList AS CHAR):
    DEF VAR hToolbar AS HANDLE NO-UNDO.
    hToolbar = DYNAMIC-FUNCTION("getLinkedObject",QUERY-HANDLE,"toolbar","from").
    
    bOK = NO.                                  
    IF QUERY-HANDLE:TYPE = "Query" THEN DO:                                  
      bOK = DYNAMIC-FUNCTION("InitDynFilter",QUERY-HANDLE,icFieldList,icOperList,icValueList,
                             (IF hToolbar = ? OR DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonFilter") = "" THEN "static" ELSE "") +
                             (IF bNoExecFilter THEN "noexec" ELSE IF bTryFilter THEN "try" ELSE "")).
      DYNAMIC-FUNCTION("setCurrentObject",QUERY-HANDLE).
    END.                         
    ELSE
      MESSAGE "Filter cannot be applied before object is initialized, ie buffers and fields are defined (buffersAndFields property)"
      VIEW-AS ALERT-BOX.
      
    ASSIGN bTryFilter = NO
           bNoExecFilter = NO
           cLastFilter = "".

    RETURN bOk.      
  END METHOD.

  METHOD PUBLIC VOID setFilter(icExprList AS CHAR):
    ASSIGN bNoExecFilter = YES
           cLastFilter    = icExprList.
    applyFilter(icExprList).
  END METHOD.
    
  METHOD PUBLIC VOID setFilter(icFieldList AS CHAR
                              ,icOperList  AS CHAR
                              ,icValueList AS CHAR):
    DEF VAR hToolbar AS HANDLE NO-UNDO.
    hToolbar = DYNAMIC-FUNCTION("getLinkedObject",QUERY-HANDLE,"toolbar","from").
                                       
    bOK = DYNAMIC-FUNCTION("InitDynFilter",QUERY-HANDLE,icFieldList,icOperList,icValueList,
                           IF hToolbar = ? OR DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonFilter") = "" THEN "static,noexec" ELSE "noexec").
    
    DYNAMIC-FUNCTION("setCurrentObject",QUERY-HANDLE).
                           
  END METHOD.  
  
  METHOD PUBLIC VOID clearFilter():
    bNoExecFilter = YES.
    applyFilter("").
  END METHOD.  

  METHOD PUBLIC VOID clearFilter(icFieldList AS CHAR):
    DEF VAR cOperList AS CHAR NO-UNDO.
    DEF VAR cValueList AS CHAR NO-UNDO.
    
    IF NUM-ENTRIES(icFieldList) > 1 THEN
      ASSIGN cOperList = FILL(",",NUM-ENTRIES(icFieldList) - 1)
             cValueList = FILL("|",NUM-ENTRIES(icFieldList) - 1)
             .
    THIS-OBJECT:setFilter(icFieldList,cOperList,cValueList).
  END METHOD.  

  METHOD PUBLIC VOID setQuerySort(icSortExpr AS CHAR): /* "field1;[desc],field2.." */
    icSortExpr = REPLACE(icSortExpr,"descending","desc").
    IF VALID-HANDLE(QUERY-HANDLE) AND QUERY-HANDLE:TYPE = "Query" THEN
      DYNAMIC-FUNCTION("setSortString",QUERY-HANDLE,icSortExpr).
    ELSE cSortExpr = icSortExpr.
  END METHOD.

  METHOD PUBLIC VOID addCalcField(icSourceBuffer AS CHAR
                                 ,icDataType     AS CHAR
                                 ,icFormat       AS CHAR
                                 ,icLabel        AS CHAR
                                 ,icProcedure    AS CHAR
                                 ,icParameter    AS CHAR):
                                       
  END METHOD.
  
  METHOD PUBLIC VOID setCalcFieldParam(icFieldName AS CHAR
                                      ,icParameter AS CHAR):
    IF INDEX(icParameter,",") > 0 OR INDEX(icParameter,";") > 0 OR INDEX(icParameter,"|") > 0 THEN
      MESSAGE "Characters , ; or | (pipe) not allowed in parameter value for calculated field " icFieldName SKIP
              "Use f.ex CHR(1)" 
      VIEW-AS ALERT-BOX ERROR.
    ELSE                                    
      DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"calcParam" + icFieldName,icParameter).                                         
  END METHOD.                                        
           	
  METHOD PUBLIC VOID openQuery():
    RUN InvokeMethod(QUERY-HANDLE,"OpenQuery").
    errorMessage = DYNAMIC-FUNCTION("getTransactionMessage").
    queryError = errorMessage NE "".
  END METHOD.

  METHOD PUBLIC VOID openQuery(INPUT icQueryString AS CHAR):
    icQueryString = TRIM(icQueryString).
    IF (DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"baseQuery") NE "" OR
        DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"queryFilter") NE "") AND 
       icQueryString BEGINS "WHERE " THEN DO:
      icQueryString = " AND (" + SUBSTR(icQueryString,6) + ")".      
    END.
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"queryWhere",icQueryString).
    RUN InvokeMethod(QUERY-HANDLE,"OpenQuery").
    errorMessage = DYNAMIC-FUNCTION("getTransactionMessage").
    queryError = errorMessage NE "".
  END METHOD.

  /*----------------------------------------------------------------------------
    Purpose: Create a parent relationship for the browse 
    Notes:   If field-names are different in parent object the entry in relationship
             list must be split by ; stating the child field-name first, eg
             custnum;customernum 
    @param ioParentBrowse Parent browse object
    @param icRelationShip Comma-sep. list of fields to define the relationship or "parentlink" to indicate that the query is custom            
  ------------------------------------------------------------------------------*/    
  METHOD PUBLIC VOID setParentBrowseObject(ioParentBrowse AS JBoxBrowse
                                          ,icRelationship AS CHAR):
    IF NOT VALID-OBJECT(ioParentBrowse) THEN DO:
      IF VALID-OBJECT(PARENT-BROWSE-OBJECT) THEN
        DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,PARENT-BROWSE-OBJECT:BROWSE-HANDLE).
    END.
    ELSE DO:
      DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,ioParentBrowse:BROWSE-HANDLE).
      DYNAMIC-FUNCTION("createParentLink",THIS-OBJECT:QUERY-HANDLE,ioParentBrowse:BROWSE-HANDLE,icRelationShip).
      IF NOT VALID-OBJECT(ioParentBrowse:CHILD-QUERY-OBJECT) THEN
        ioParentBrowse:CHILD-QUERY-OBJECT = THIS-OBJECT.
    END.  

    PARENT-BROWSE-OBJECT = ioParentBrowse.
                                                                                        
  END METHOD.  

  METHOD PUBLIC VOID setParentQueryObject(ioParentQuery  AS JBoxQuery
                                         ,icRelationship AS CHAR):
    IF NOT VALID-OBJECT(ioParentQuery) THEN DO:
      IF VALID-OBJECT(PARENT-QUERY-OBJECT) THEN
        DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,PARENT-QUERY-OBJECT:QUERY-HANDLE).
    END.
    ELSE DO: 
      DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,ioParentQuery:QUERY-HANDLE).
      DYNAMIC-FUNCTION("createParentLink",THIS-OBJECT:QUERY-HANDLE,ioParentQuery:QUERY-HANDLE,icRelationShip).
      IF NOT VALID-OBJECT(ioParentQuery:CHILD-QUERY-OBJECT) THEN
        ioParentQuery:CHILD-QUERY-OBJECT = THIS-OBJECT.
    END.  

    PARENT-QUERY-OBJECT = ioParentQuery.
  END METHOD.
    
  METHOD PUBLIC VOID setOneToOneBrowseObject(ioParentBrowse AS JBoxBrowse
                                            ,icRelationship AS CHAR):
    IF NOT VALID-OBJECT(ioParentBrowse) THEN DO:
      IF VALID-OBJECT(PARENT-BROWSE-OBJECT) THEN
        DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,PARENT-BROWSE-OBJECT:BROWSE-HANDLE).
    END.
    ELSE DO:
      DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,ioParentBrowse:BROWSE-HANDLE).
      DYNAMIC-FUNCTION("createOneToOneLink",THIS-OBJECT:QUERY-HANDLE,ioParentBrowse:BROWSE-HANDLE,icRelationShip).
    END.  

    PARENT-BROWSE-OBJECT = ioParentBrowse.
                                                                                        
  END METHOD.  
  
  METHOD PUBLIC VOID setOneToOneQueryObject(ioParentQuery  AS JBoxQuery
                                           ,icRelationship AS CHAR):
    IF NOT VALID-OBJECT(ioParentQuery) THEN DO:
      IF VALID-OBJECT(PARENT-QUERY-OBJECT) THEN
        DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,PARENT-QUERY-OBJECT:QUERY-HANDLE).
    END.
    ELSE DO:
      DYNAMIC-FUNCTION ("deleteObjectLink",QUERY-HANDLE,ioParentQuery:QUERY-HANDLE).
      DYNAMIC-FUNCTION("createOneToOneLink",THIS-OBJECT:QUERY-HANDLE,ioParentQuery:QUERY-HANDLE,icRelationShip).
    END.  

    PARENT-QUERY-OBJECT = ioParentQuery.
  END METHOD.  

  METHOD PUBLIC VOID displayRecord():
    RUN InvokeMethod(QUERY-HANDLE,"DisplayRecord").
  END METHOD.

  METHOD PUBLIC VOID excelRecord():
    RUN InvokeMethod(QUERY-HANDLE,"ExcelRecord").
  END METHOD.
    
  METHOD PUBLIC LOGICAL refreshRow():
    RETURN DYNAMIC-FUNCTION("RefreshRowids",THIS-OBJECT:QUERY-HANDLE,THIS-OBJECT:BUFFER-HANDLE::RowIdent1) > 0. 
  END METHOD.
           
  METHOD PUBLIC VOID setFilterDropDownQuery(icFieldName AS CHAR
                                           ,icBuffersAndFields AS CHAR
                                           ,icQuery AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterDropdownFields_" + icFieldName,icBuffersAndFields).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterDropdownQuery_" + icFieldName,icQuery).
  END METHOD.  

  METHOD PUBLIC VOID setFilterDropDownList(icFieldName  AS CHAR
                                      ,icValuePairs AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterDropdownValuelist_" + icFieldName,icValuePairs).
  END METHOD.  

  METHOD PUBLIC VOID setFilterLookup(icFieldName  AS CHAR
                                    ,icBuffersAndFields AS CHAR
                                    ,icQuery AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterLookupFields_" + icFieldName,icBuffersAndFields).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterLookupQuery_" + icFieldName,icQuery).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterLookupReturnField_" + icFieldName,icFieldName).
  END METHOD.  

  METHOD PUBLIC VOID setFilterLookup(icFieldName  AS CHAR
                                    ,icBuffersAndFields AS CHAR
                                    ,icQuery AS CHAR
                                    ,icReturnField AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterLookupFields_" + icFieldName,icBuffersAndFields).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterLookupQuery_" + icFieldName,icQuery).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"filterLookupReturnField_" + icFieldName,icReturnField).
  END METHOD.  

  METHOD PUBLIC VOID setJBoxAttribute(icAttribute AS CHAR
                                     ,icValue AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,icAttribute,icValue).
  END METHOD.
  METHOD PUBLIC CHARACTER getJBoxAttribute(icAttribute AS CHAR):
    RETURN  DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,icAttribute).
  END METHOD.
       
  METHOD PRIVATE LOGICAL resolveFilterExpr(icExprList AS CHAR,OUTPUT ocFields AS CHAR,OUTPUT ocOperators AS CHAR,OUTPUT ocValues AS CHAR):
    DEF VAR ix    AS INT  NO-UNDO.
    DEF VAR cExpr AS CHAR NO-UNDO.
    DEF VAR cOper AS CHAR NO-UNDO.
    
    
    DO ix = 1 TO NUM-ENTRIES(icExprList,"|"):
      
      ASSIGN cExpr       = ENTRY(ix,icExprList,"|")
             ocFields    = ocFields + (IF ocFields NE "" THEN "," ELSE "") + entry(1,cExpr," ")
             cOper       = THIS-OBJECT:getFilterOper(ENTRY(2,cExpr," "))
             ocOperators = ocOperators + (IF ocOperators NE "" THEN "," ELSE "") + cOper
             ocValues    = ocValues + (IF ocValues NE "" THEN "|" ELSE "") + replace(REPLACE(TRIM(substr(cExpr,INDEX(cExpr,cOper) + length(cOper))),"'",""),'"','"')
             .
    END.
    RETURN YES.
  END METHOD.
    
  METHOD PUBLIC VOID setPreScanQuery(icTable  AS CHAR
                                    ,icExpr   AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"prescanQuery" + icTable,icExpr).                                      
  END METHOD.  

  METHOD PUBLIC VOID setExtraFilterField(icTable      AS CHAR
                                        ,icField      AS CHAR
                                        ,icLabel      AS CHAR
                                        ,icPrescanQry AS CHAR):
    DEF VAR cExtraFilter AS CHAR NO-UNDO.
    cExtraFilter = DYNAMIC-FUNCTION("getAttribute",THIS-OBJECT:QUERY-HANDLE,"extraFilterFields").
    cExtraFilter = cExtraFilter + (IF cExtraFilter NE "" THEN "," ELSE "")
                 + icTable + "." + icField + "|" + icLabel.                                           
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"extraFilterFields",cExtraFilter).
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:QUERY-HANDLE,"prescanQuery" + icTable,icPrescanQry).                                      
  END METHOD.  

  METHOD PUBLIC CHARACTER getQueryStatValue(icFieldName AS CHAR):
    IF THIS-OBJECT:useLocalData AND DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"localStatValue" + icFieldName) NE "" THEN
      RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"localStatValue" + icFieldName).
    ELSE  
      RETURN DYNAMIC-FUNCTION("getAttribute",QUERY-HANDLE,"statValue" + icFieldName).
  END METHOD.

  METHOD PUBLIC CHARACTER getLocalStat(icFieldList AS CHAR):
    DEF VAR cReturn AS CHAR NO-UNDO.
    cReturn = DYNAMIC-FUNCTION("getLocalQueryStat",QUERY-HANDLE,icFieldList).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"recordcount",ENTRY(2,ENTRY(1,cReturn,";"),"|")).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"rowsadded","").
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"rowsdeleted","").
    
    DYNAMIC-FUNCTION("ViewRecordCount",QUERY-HANDLE).
    
    IF NUM-ENTRIES(icFieldList) > 1 THEN
      RETURN SUBSTR(cReturn,INDEX(cReturn,";") + 1).
    ELSE    
      RETURN ENTRY(2,ENTRY(2,cReturn,";"),"|").
      
  END METHOD.

  METHOD PUBLIC CHARACTER getLocalStat():
    DEF VAR cReturn AS CHAR NO-UNDO.
    cReturn = DYNAMIC-FUNCTION("getLocalQueryStat",QUERY-HANDLE,"").
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"rowsadded","").
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"rowsdeleted","").
    
    DYNAMIC-FUNCTION("ViewRecordCount",QUERY-HANDLE).
    RETURN cReturn.
  END METHOD.

  /* Process all rows for query crit: */ 
  METHOD PUBLIC LOGICAL processSet(icProcName AS CHAR
                                  ,icParam AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.       
    IF cCallFromMethod = "" THEN cCallFromMethod = ENTRY(1,PROGRAM-NAME(2)," ").                                    
    bOk = DYNAMIC-FUNCTION("processQuery",QUERY-HANDLE,icProcName,icParam).
    JBoxServerAPI:Instance:CreateCall(cCallFromMethod,icParam,bOk,?,hSourceProc).
    cCallFromMethod = "".
    RETURN bOk.
  END METHOD.
  
  METHOD PUBLIC LOGICAL processSetNoMessage(icProcName AS CHAR
                                           ,icParam AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.                    
    cCallFromMethod = ENTRY(1,PROGRAM-NAME(2)," ").                       
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"viewErrorsFromProcessRows","no").
    bOk = THIS-OBJECT:processSet(icProcName,icParam).
    DYNAMIC-FUNCTION("setAttribute",QUERY-HANDLE,"viewErrorsFromProcessRows","").
    RETURN bOK.
  END METHOD.

  DESTRUCTOR PUBLIC JBoxQuery ( ):
	  DYNAMIC-FUNCTION("DeleteObject",QUERY-HANDLE) NO-ERROR.
  END DESTRUCTOR.

END CLASS.
