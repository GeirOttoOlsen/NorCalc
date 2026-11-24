 
 /*------------------------------------------------------------------------
    File        : JBoxBrowse
    Purpose     : 
    Syntax      : 
    Description : OO Wrapper for library function NewBrowse
    Author(s)   : brynjar
    Created     : Wed Oct 02 10:47:14 CEST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS JBoxBrowse: 
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEF VAR hSourceProc       AS HANDLE NO-UNDO.
  DEF VAR bOk               AS LOG    NO-UNDO.
  DEF VAR bTryFilter        AS LOG    NO-UNDO. /* Clear the filter if no records were found */
  DEF VAR bNoExecFilter     AS LOG    NO-UNDO.
  DEF VAR cLastFilter       AS CHAR   NO-UNDO.
  DEF VAR cInitAttr         AS CHAR   NO-UNDO.
  DEF VAR cSortExpr         AS CHAR   NO-UNDO.
  DEF VAR cQueryJoin        AS CHAR   NO-UNDO.
  DEF VAR cBufferList       AS CHAR   NO-UNDO.
  DEF VAR cBuffersAndFields AS CHAR   NO-UNDO.
  DEF VAR oToolbar          AS JBoxToolbar   NO-UNDO.
  DEF VAR oPopupMenu        AS JBoxPopupMenu NO-UNDO.
  DEF VAR cSearchColumn     AS CHAR   NO-UNDO.
  DEF VAR hColumnFieldMap   AS HANDLE NO-UNDO.  
  DEF VAR hBrowse           AS HANDLE NO-UNDO.
  DEF VAR cCallFromMethod   AS CHAR   NO-UNDO.
  DEF VAR oFieldMap         AS JBoxFieldMap NO-UNDO.
  DEF VAR bRebuildBuffAndFld AS LOG NO-UNDO.
  
  DEF TEMP-TABLE ttOverlay
      FIELD oOverlay      AS Progress.Lang.Object
      FIELD cType         AS CHAR
      FIELD cBrowseColumn AS CHAR
      FIELD cBufferColumn AS CHAR 
      FIELD hOverlay      AS HANDLE
      FIELD bInitRefrRow  AS LOG
      FIELD iSeq          AS INT
      .

  DEF TEMP-TABLE ttFieldBufferRef NO-UNDO // To identify correct table for fields in sql query  
      FIELD BufferName AS CHAR            // Buffer-ref is added as pipe-entry 6 in buffersandfield ref
      FIELD FieldName  AS CHAR                
      INDEX idxField FieldName 
      .

  DEF PUBLIC PROPERTY DESIGN-WIDGET-HANDLE   AS HANDLE GET. PROTECTED SET.
  DEF PUBLIC PROPERTY BROWSE-HANDLE          AS HANDLE GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY QUERY-HANDLE           AS HANDLE GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY BUFFER-HANDLE          AS HANDLE GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY TEMP-TABLE-HANDLE      AS HANDLE GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY PARENT-BROWSE-OBJECT   AS JBoxBrowse  GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY PARENT-QUERY-OBJECT    AS JBoxQuery   GET. PROTECTED SET.
  DEF PUBLIC PROPERTY CHILD-BROWSE-OBJECT    AS JBoxBrowse  GET. SET. 
  DEF PUBLIC PROPERTY CHILD-QUERY-OBJECT     AS JBoxQuery   GET. SET.
  DEF PUBLIC PROPERTY SOURCE-FILE-HANDLE     AS HANDLE      GET(): RETURN hSourceProc. END GET. PROTECTED SET.
  DEF PUBLIC PROPERTY GRID-FILTER-HANDLE     AS HANDLE      NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY CONTAINER-OBJECT       AS JBoxContainer GET. SET.
  DEF PUBLIC PROPERTY DATABROWSE-PARENT-PROC AS HANDLE NO-UNDO GET. SET.
   
  DEF PUBLIC PROPERTY PARENT-BUFFER-HANDLE AS HANDLE 
      GET():
         DEF VAR hParent AS HANDLE NO-UNDO.
         hParent = DYNAMIC-FUNCTION("getLinkedObject",BROWSE-HANDLE,"parent","from").
         IF VALID-HANDLE(hParent) THEN DO:
           IF hParent:TYPE = "browse" THEN RETURN hParent:QUERY:GET-BUFFER-HANDLE(1).
           ELSE RETURN hParent:GET-BUFFER-HANDLE(1).
         END.  
         ELSE RETURN ?.  
      END GET.
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY SEARCH-FIELD-HANDLE  AS HANDLE 
      GET():
        RETURN DYNAMIC-FUNCTION("GetLinkedObject",BROWSE-HANDLE,"browse-search-field","from").
      END GET.   
      PROTECTED SET.

//  {JBoxBrowseQueryProp.i BROWSE-HANDLE}
  
/* Common properties for browse and query objects */
  DEF PUBLIC PROPERTY TOOLBAR-OBJECT AS JBoxToolbar GET. 
      SET(ioToolbar AS JBoxToolbar):
        IF NOT VALID-OBJECT(ioToolbar) THEN DO:
          IF VALID-OBJECT(oToolbar) THEN
            DYNAMIC-FUNCTION ("DeleteObjectLink",BROWSE-HANDLE,oToolbar:TOOLBAR-HANDLE).
        END.
        ELSE DYNAMIC-FUNCTION("createObjectLink",BROWSE-HANDLE,ioToolbar:TOOLBAR-HANDLE).
        oToolbar = ioToolbar.
        TOOLBAR-OBJECT = ioToolbar.
      END SET.

  DEF PUBLIC PROPERTY FIELDMAP-OBJECT AS JBoxFieldMap GET. 
      SET(ioFieldMap AS JBoxFieldMap):
        IF NOT VALID-OBJECT(ioFieldMap) THEN DO:
          IF VALID-OBJECT(oFieldMap) THEN
            DYNAMIC-FUNCTION ("DeleteObjectLink",BROWSE-HANDLE,oFieldMap:BUFFER-HANDLE).
        END.
        ELSE DYNAMIC-FUNCTION("createObjectLink",BROWSE-HANDLE,ioFieldMap:BUFFER-HANDLE).
        oFieldMap = ioFieldMap.
        FIELDMAP-OBJECT = ioFieldMap.
      END SET.

  DEF PUBLIC PROPERTY TAB-FOLDER-OBJECT AS JBoxMsTabs GET. SET. 

  DEF PUBLIC PROPERTY filterExcludeFields AS CHAR /* <field>,<field>,..*/
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"filterExcludeFields"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterExcludeFields",icAttr).
      END SET.
   
  DEF PUBLIC PROPERTY baseQuery AS CHAR /* WHERE ..*/
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"baseQuery"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"baseQuery",icAttr).
      END SET.
      
  DEF PUBLIC PROPERTY preScanBaseQuery AS CHAR /* To view customers for salesrep names matching *b*a* (Salesrep doesn't need to be included in the query): Salesrep WHERE Repname MATCHES '*b*a*',EACH Customer NO-LOCK OF Salesrep */
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"preScanBaseQuery"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"preScanBaseQuery",icAttr).
      END SET.

  DEF PUBLIC PROPERTY preScanQueryWhere AS CHAR /* Ff a searchfield is implemented this property is automatically maintained based on the (internal) prescanQuery<table> attribute. Use the method setPrescanQuery */
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"preScanQueryWhere"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"preScanQueryWhere",icAttr).
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"keepsearchvalue","yes").
      END SET.

  DEF PUBLIC PROPERTY preScanQueryFilter AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"preScanQueryFilter"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"preScanQueryFilter",icAttr).
      END SET.
        
  DEF PUBLIC PROPERTY calcFieldProc AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"calcFieldProc"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"calcFieldProc",icAttr).
      END SET.  

  DEF PUBLIC PROPERTY queryFilter AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"queryFilter"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"queryFilter",icAttr).
      END SET.  

  DEF PUBLIC PROPERTY queryWhere AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"queryWhere"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"queryWhere",icAttr).
      END SET.

  DEF PUBLIC PROPERTY altPrimaryBufferList AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"altPrimaryBufferList"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"altPrimaryBufferList",icAttr).
      END SET.

  DEF PUBLIC PROPERTY calcFieldFilter AS CHAR /* <fieldname>¤<operator>¤<value>|<fieldname>¤.. */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"calcFieldFilter"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"calcFieldFilter",icAttr).
      END SET.
        
  DEF PUBLIC PROPERTY calcFieldWhere AS CHAR /* <fieldname>¤<operator>¤<value>|<fieldname>¤.. */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"calcFieldWhere"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"calcFieldWhere",icAttr).
      END SET.  

  DEF PUBLIC PROPERTY allowCan-DoFilterOperator AS CHAR /* <fieldname>,<fieldname>,.. */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"allowCan-DoFilterOperator"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"allowCan-DoFilterOperator",icAttr).
      END SET.  
      
  DEF PUBLIC PROPERTY parentLink AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"parentLink"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"parentLink",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY useLocalData AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"useLocalData") = "yes". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"useLocalData",IF ibSetting THEN STRING(ibSetting) ELSE "").
      END SET.
      
  DEF PUBLIC PROPERTY IsCurrent  AS LOG 
      GET(): 
        RETURN THIS-OBJECT:BROWSE-HANDLE = DYNAMIC-FUNCTION ("getCurrentObject"). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY recordAvailable  AS LOG 
      GET(): 
       IF VALID-HANDLE(BUFFER-HANDLE) THEN RETURN BUFFER-HANDLE:AVAIL. ELSE RETURN NO. END GET. 
      PROTECTED SET.

  DEF PUBLIC PROPERTY querySort  AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"querySort"). END GET. 
      PROTECTED SET. /* use setSortString to set */
      
  DEF PUBLIC PROPERTY localSort  AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"localSort"). END GET. 
      PROTECTED SET. /* use setSortString to set */

  DEF PUBLIC PROPERTY getRecordCount AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"getRecordCount") NE "NO". END GET.
      SET(ibSet AS LOG): 
        IF ibSet THEN
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"getRecordCount","yes").
        ELSE
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"getRecordCount","no").
      END SET.
        
  DEF PUBLIC PROPERTY currentCount AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"currentCount")). END GET.
      SET(iiSet AS INT): DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"currentCount",STRING(iiSet)). END SET.  

  DEF PUBLIC PROPERTY recordCount AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"recordCount")). END GET.
      SET(iiSet AS INT): DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"recordCount",STRING(iiSet)). END SET.  

  DEF PUBLIC PROPERTY redrawOnRowChange AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"redrawOnRowChange") = "YES". END GET.
      SET(ibSet AS LOG): DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"redrawOnRowChange",STRING(ibSet,"yes/")). END SET.  

  DEF PUBLIC PROPERTY totalCount AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"totalCount")). END GET.
      SET(iiSet AS INT): DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"totalCount",STRING(iiSet)). END SET.  

  DEF PUBLIC PROPERTY viewRecordCount AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"viewRecordCount") NE "NO". END GET.
      SET(ibSet AS LOG): 
        IF ibSet THEN
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"viewRecordCount","yes").
        ELSE
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"viewRecordCount","no").
      END SET.

  DEF PUBLIC PROPERTY objectName AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getObjectName",BROWSE-HANDLE). END GET. 
      SET(icName AS CHAR): 
        DYNAMIC-FUNCTION("setObjectName",BROWSE-HANDLE,icName).  
      END SET. 

  DEF PUBLIC PROPERTY objectState AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getObjectState",BROWSE-HANDLE). END GET. 
      SET(icState AS CHAR): 
        DYNAMIC-FUNCTION("setObjectState",BROWSE-HANDLE,icState).  
      END SET. 
 
  DEF PUBLIC PROPERTY overlayBGcolor AS INT      
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"overlayBGcolor")). END GET.
      SET(iiColor AS INT): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"overlayBGcolor",STRING(iiColor)).
      END SET.

  DEF PUBLIC PROPERTY overlayBGcolNum AS INT // Progress color table     
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"overlaybgcolnum")). END GET.
      SET(iiColNum AS INT): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"overlaybgcolnum",STRING(iiColNum)).
      END SET.
      
      
  DEF PUBLIC PROPERTY filterFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"filterFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterFields",icSetting).
      END SET.

  DEF PUBLIC PROPERTY extrafilterFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"extrafilterFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"extrafilterFields",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY flatViewBuffersAndFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"flatViewBuffersAndFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"flatViewBuffersAndFields",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY flatViewQueryJoin AS CHAR 
      GET(): RETURN TRIM(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"flatViewQueryJoin"),"-"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"flatViewQueryJoin",IF icSetting = "" THEN "-" ELSE icSetting).
      END SET.

  DEF PUBLIC PROPERTY flatViewTitle AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"flatViewTitle"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"flatViewTitle",icSetting).
      END SET.

  DEF PUBLIC PROPERTY flatViewOuterJoin AS LOG /* Can be set on each query in a chain. If set on the top level it applies to all levels */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"flatViewJoinType") = "outer-join". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"flatViewJoinType",IF ibSetting THEN "OUTER-JOIN" ELSE "").
      END SET.

  DEF PUBLIC PROPERTY flatViewRecordCount AS LOG /* Must be set on top-level browse/query. Default ON */ 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"flatViewRecordCount") NE "no". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"flatViewRecordCount",STRING(ibSetting)).
      END SET.

  DEF PUBLIC PROPERTY excludeFromFlatView AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"excludeFromFlatView") = "yes". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"excludeFromFlatView",STRING(ibSetting)).
      END SET.

  DEF PUBLIC PROPERTY accumDataTypes AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"accumDataTypes"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"accumDataTypes",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY availAccumFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"availAccumFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"availAccumFields",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY accumFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"accumFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"accumFields",icSetting).
      END SET.

  DEF PUBLIC PROPERTY distinctDataTypes AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"distinctDataTypes"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"distinctDataTypes",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY availDistinctColumns AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"availDistinctColumns"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"availDistinctColumns",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY distinctColumns AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"distinctColumns"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"distinctColumns",icSetting).
      END SET.

  DEF PUBLIC PROPERTY queryStatFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"queryStatFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"queryStatFields",icSetting).
      END SET.

  DEF PUBLIC PROPERTY skipServerSort AS LOGICAL 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"skipServerSort") = "yes". END GET. 
      SET(ibSetting AS LOGICAL): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"skipServerSort",IF ibSetting THEN "yes" ELSE "").
      END SET.

  DEF PUBLIC PROPERTY userSettingContext AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"userSettingContext"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"userSettingContext",icSetting).
      END SET.

  DEF PUBLIC PROPERTY fieldNameDeleteWarning AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"fieldNameDeleteWarning"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"fieldNameDeleteWarning",icSetting).
      END SET.

  DEF PUBLIC PROPERTY lastRecord AS LOG 
      GET(): RETURN VALID-HANDLE(BUFFER-HANDLE) AND BUFFER-HANDLE:AVAIL AND DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"lastRowid") = STRING(BUFFER-HANDLE:ROWID). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY firstRecord AS LOG 
      GET(): RETURN VALID-HANDLE(BUFFER-HANDLE) AND BUFFER-HANDLE:AVAIL AND DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"firstRowid") = STRING(BUFFER-HANDLE:ROWID). END GET. 
      PROTECTED SET.

  DEF PUBLIC PROPERTY activeFilter AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"queryFilter") NE "" 
                 OR DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"prescanQueryFilter") NE ""
                 OR DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"calcFieldFilter") NE "". 
      END GET. 
      PROTECTED SET.
            
  DEF PUBLIC PROPERTY queryStopAfter AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"queryStopAfter")). END GET. 
      SET(iiSetting AS INTEGER): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"queryStopAfter",STRING(iiSetting)).
      END SET.

  DEF PUBLIC PROPERTY skipRows AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"BatchQueryStart")). END GET. 
      SET(ipSkipRows AS INT):
        ipSkipRows = if ipSkipRows = ? then 0 else ipSkipRows. 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"BatchQueryStart",STRING(ipSkipRows)). END SET. 
 /* End common properties query/browse */  
   
  DEF PUBLIC PROPERTY noColumnSort AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"noColumnSort"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"noColumnSort",icAttr).
      END SET.

  DEF PUBLIC PROPERTY allViewFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"allViewFields"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"allViewFields",icAttr).
      END SET.

  DEF PUBLIC PROPERTY currViewFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"currViewFields"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"currViewFields",icAttr).
      END SET.

  DEF PUBLIC PROPERTY noDisplayFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"noDisplayFields"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"noDisplayFields",icAttr).
      END SET.

  DEF PUBLIC PROPERTY allFields AS CHAR 
      GET():
        RETURN TRIM(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"allViewFields") + "," + DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"noDisplayFields"),","). 
      END GET.
      PROTECTED SET.

  DEF PUBLIC PROPERTY widthPixelsList AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"widthPixelsList"). END GET.
      SET(icAttr AS CHAR): 
         DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"widthPixelsList",icAttr).
      END SET.
                                                 
  DEF PUBLIC PROPERTY POPUP-MENU-OBJECT AS JBoxPopupMenu GET. 
      SET(ioPopupMenu AS JBoxPopupMenu):
        IF NOT VALID-OBJECT(ioPopupMenu) THEN DO:
          IF VALID-OBJECT(oPopupMenu) THEN DO:
            BROWSE-HANDLE:POPUP-MENU = ?.
            DYNAMIC-FUNCTION("deletObjectLink",BROWSE-HANDLE,ioPopupMenu:POPUP-MENU-HANDLE).
          END.  
        END.
        ELSE IF BROWSE-HANDLE:POPUP-MENU = ? THEN DO:
          BROWSE-HANDLE:POPUP-MENU = ioPopupMenu:POPUP-MENU-HANDLE.
          DYNAMIC-FUNCTION("createObjectLink",BROWSE-HANDLE,ioPopupMenu:POPUP-MENU-HANDLE).
          DYNAMIC-FUNCTION("setObjectName",ioPopupMenu:POPUP-MENU-HANDLE,"popupMenu" + BROWSE-HANDLE:NAME).
        END.
        ELSE
          DYNAMIC-FUNCTION("setObjectName",ioPopupMenu:POPUP-MENU-HANDLE,"popupMenu" + BROWSE-HANDLE:NAME).
        oPopupMenu = ioPopupMenu.  
        POPUP-MENU-OBJECT = ioPopupMenu.
      END SET.
                      
  DEF PUBLIC PROPERTY MSWinMultiSelect AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"windowsBrowse") = "yes". END GET.
      SET(ibSet AS LOG): 
        IF ibSet THEN
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"windowsBrowse","yes").
        ELSE
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"windowsBrowse","").
      END SET.
      
  DEF PUBLIC PROPERTY browseSearchAsFilter AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"searchDefault") = "filter". END GET.
      SET(ibSet AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"searchDefault",IF ibSet THEN "filter" ELSE "").
      END SET.
        
  DEF PUBLIC PROPERTY rowsToBatch      AS INT 
      GET(): RETURN INT(DYNAMIC-FUNCTION("getAttribute",
                       IF VALID-HANDLE(BROWSE-HANDLE) THEN BROWSE-HANDLE ELSE DESIGN-WIDGET-HANDLE,"rowsToBatch")). 
      END GET. 
      SET(iiRowsToBatch AS INT):
        DYNAMIC-FUNCTION("setAttribute",
                          IF VALID-HANDLE(BROWSE-HANDLE) THEN BROWSE-HANDLE ELSE DESIGN-WIDGET-HANDLE,"rowsToBatch",STRING(iiRowsToBatch)).
      END SET.

  DEF PUBLIC PROPERTY lastQuery      AS CHAR 
      GET(): RETURN getJBoxAttribute("statvalueLastQuery").
      END GET.
      PROTECTED SET.    

  DEF PUBLIC PROPERTY queryJoin AS CHAR
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"queryJoin"). END GET.
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
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"bufferJoin" + cBuffer, "," + cBufferJoin).
        END.
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"queryJoin",icQueryJoin).
        IF BROWSE-HANDLE:TYPE NE "browse" THEN cQueryJoin = icQueryJoin.
      END SET.

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

  DEF PUBLIC PROPERTY buffersAndFields AS CHAR
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"buffersAndFields"). END GET.
      SET(icBuffersAndFields AS CHAR):
        DEF VAR ix            AS INT    NO-UNDO.
        DEF VAR iy            AS INT    NO-UNDO.
        DEF VAR cTtField      AS CHAR   NO-UNDO.
        DEF VAR cTtFieldList  AS CHAR   NO-UNDO.
        DEF VAR hColumn       AS HANDLE NO-UNDO.
        DEF VAR cTtLabList    AS CHAR   NO-UNDO.
        DEF VAR cTtFormatList AS CHAR   NO-UNDO.
        DEF VAR cTtWidthList     AS CHAR   NO-UNDO.
        DEF VAR cViewBuffsAndFlds AS CHAR NO-UNDO.
        DEF VAR hTT           AS HANDLE NO-UNDO.
        DEF VAR cCalcFlds     AS CHAR   NO-UNDO.
        DEF VAR cCalcParams   AS CHAR   NO-UNDO.
        DEF VAR cBufferFldIdx AS INT    NO-UNDO EXTENT.
        DEF VAR iColWidth     AS INT    NO-UNDO.
                
        IF NOT (icBuffersAndFields NE "" AND BROWSE-HANDLE NE ? AND DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"tempTableHandle") NE "") THEN DO:
          IF icBuffersAndFields NE "" THEN DO:
            EXTENT(cBufferFldIdx) = NUM-ENTRIES(icBuffersAndFields).
            DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
              IF ix > 1 THEN
                ASSIGN cBufferList = cBufferList + "," + ENTRY(1,ENTRY(ix,icBuffersAndFields),";")
                       cBufferFldIdx[ix] = cBufferFldIdx[ix - 1] + NUM-ENTRIES(ENTRY(ix,icBuffersAndFields),";") - 1.
              ELSE          
                cBufferFldIdx[ix] = NUM-ENTRIES(ENTRY(ix,icBuffersAndFields),";") - 1.
            END.
          END.    
          
          IF DESIGN-WIDGET-HANDLE:TYPE NE "BROWSE" AND SQLdbName NE "" THEN DO:  /* dynamic browse for sql - need to get the tt-def */
            IF icBuffersAndFields NE "" THEN DO:
              hTT = JBoxSqlSchemaHelper:Instance:getTtDef (SQLdbName,icBuffersAndFields).
              DYNAMIC-FUNCTION("setAttribute",DESIGN-WIDGET-HANDLE,"tempTableHandle",STRING(hTT)).
            END.
            ELSE 
              ASSIGN hTT = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",DESIGN-WIDGET-HANDLE,"tempTableHandle"))
                     bRebuildBuffAndFld = YES. // To force rebuild in InitializeComponent  
          END.  
          
          IF VALID-HANDLE(BROWSE-HANDLE) AND BROWSE-HANDLE:TYPE = "browse" THEN DYNAMIC-FUNCTION("deleteObject",BROWSE-HANDLE).
          DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).
          BROWSE-HANDLE = DYNAMIC-FUNCTION("NewBrowse",DESIGN-WIDGET-HANDLE,rowsToBatch,cInitAttr,icBuffersAndFields,"where false" + cBufferList,"").
          IF DESIGN-WIDGET-HANDLE:TYPE NE "BROWSE" THEN DO:
            DYNAMIC-FUNCTION("deleteObject",DESIGN-WIDGET-HANDLE).
            DYNAMIC-FUNCTION("createObjectLink",BROWSE-HANDLE,hSourceProc).
            IF SQLdbName NE "" THEN DO:
              THIS-OBJECT:BUFFER-HANDLE = hTT:DEFAULT-BUFFER-HANDLE.
              DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields,";"):
                IF NUM-ENTRIES(ENTRY(ix,icBuffersAndFields,";"),"|") > 3 AND ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|") NE "" THEN DO:
                  iColWidth = INT(ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|")) NO-ERROR.
                  IF ERROR-STATUS:ERROR THEN
                    ASSIGN cCalcFlds   = cCalcFlds + (IF cCalcFlds NE "" THEN "," ELSE "") + TRIM(ENTRY(1,ENTRY(ix,icBuffersAndFields,";"),"|"),"+")
                           cCalcParams = cCalcParams + (IF cCalcParams NE "" THEN "," ELSE "") + ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|")
                           .
                END.         
              END.
              icBuffersAndFields = THIS-OBJECT:BUFFER-HANDLE:NAME.
              DO ix = 1 TO THIS-OBJECT:BUFFER-HANDLE:NUM-FIELDS:
                IF NOT BUFFER-HANDLE:BUFFER-FIELD(ix):NAME BEGINS "RowIdent" AND NOT BUFFER-HANDLE:BUFFER-FIELD(ix):NAME BEGINS "RowCount" THEN DO:
                  icBuffersAndFields = icBuffersAndFields + ";" 
                                    + BUFFER-HANDLE:BUFFER-FIELD(ix):NAME + "|" 
                                    + BUFFER-HANDLE:BUFFER-FIELD(ix):DATA-TYPE + "|"
                                    + REPLACE(DYNAMIC-FUNCTION("getBrowseColumnFormat",BROWSE-HANDLE,BUFFER-HANDLE:BUFFER-FIELD(ix):NAME),",","<") 
                                    + "|"
                                    + (IF CAN-DO(cCalcFlds,BUFFER-HANDLE:BUFFER-FIELD (ix):NAME) THEN ENTRY(LOOKUP(BUFFER-HANDLE:BUFFER-FIELD (ix):NAME,cCalcFlds),cCalcParams) ELSE "")  
                                    + "|"
                                    + DYNAMIC-FUNCTION("getBrowseColumnLabel",BROWSE-HANDLE,BUFFER-HANDLE:BUFFER-FIELD(ix):NAME) 
                                    .
                  DO iy = 1 TO EXTENT(cBufferFldIdx):
                    IF ix LE cBufferFldIdx[iy] THEN DO:
                      icBuffersAndFields = icBuffersAndFields + "|"
                                         + IF iy = 1 THEN THIS-OBJECT:BUFFER-HANDLE:NAME ELSE ENTRY(iy,cBufferList).
                      LEAVE.                   
                    END.  
                  END.                              
                END.                    
              END.   
              DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"buffersAndFields",icBuffersAndFields).
              DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"bufferList",ENTRY(1,ENTRY(1,icBuffersAndFields),";") + cBufferList).
              DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"numbuffers",STRING(NUM-ENTRIES(cBufferList))).
              DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"useLocalData","").
            END.  
          END.  
        END.
        ELSE DO:
          DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields,";"):
            cTtField = ENTRY(ix,icBuffersAndFields,";").
            cTtFieldList = cTtFieldList + (IF cTtFieldList NE "" THEN "," ELSE "") + ENTRY(1,cTtField,"|").
            IF NUM-ENTRIES(cTtField,"|") > 3 THEN 
              ASSIGN cTtWidthList = cTtWidthList + "|" + ENTRY(4,cTtField,"|")
                     cTtFormatList = cTtFormatList + "|" + ENTRY(3,cTtField,"|")
                     cTtLabList = cTtLabList + "|" + ENTRY(2,cTtField,"|").
            ELSE IF NUM-ENTRIES(cTtField,"|") > 2 THEN 
              ASSIGN cTtWidthList = cTtWidthList + "|"
                     cTtFormatList = cTtFormatList + "|" + ENTRY(1,ENTRY(3,cTtField,"|"),"@")
                     cTtLabList = cTtLabList + "|" + ENTRY(2,cTtField,"|").
            ELSE IF NUM-ENTRIES(cTtField,"|") > 1 THEN
              ASSIGN cTtWidthList = cTtWidthList + "|"
                     cTtFormatList = cTtFormatList + "|"
                     cTtLabList = cTtLabList + "|" + ENTRY(2,cTtField,"|").
            ELSE  
              ASSIGN cTtWidthList = cTtWidthList + "|"
                     cTtFormatList = cTtFormatList + "|"
                     cTtLabList = cTtLabList + "|".
          END.   
          ASSIGN cTtWidthList = SUBSTR(cTtWidthList,2)
                 cTtFormatList = SUBSTR(cTtFormatList,2)
                 cTtLabList = SUBSTR(cTtLabList,2)
                 .
          IF BROWSE-HANDLE:TYPE = "browse" THEN DO:        
            cViewBuffsAndFlds = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1):NAME.
            DO ix = 1 TO BROWSE-HANDLE:NUM-COLUMNS:
              hColumn = BROWSE-HANDLE:GET-BROWSE-COLUMN(ix).
              IF NOT CAN-DO(cTtFieldList,hColumn:NAME) THEN hColumn:VISIBLE = NO.
              ELSE DO:
                IF ENTRY(LOOKUP(hColumn:NAME,cTtFieldList),cTtLabList,"|") NE "" THEN 
                  hColumn:LABEL = ENTRY(LOOKUP(hColumn:NAME,cTtFieldList),cTtLabList,"|").
                IF ENTRY(LOOKUP(hColumn:NAME,cTtFieldList),cTtFormatList,"|") NE "" THEN                                        
                  THIS-OBJECT:setJBoxAttribute("ColumnFormat_" + hColumn:NAME, ENTRY(LOOKUP(hColumn:NAME,cTtFieldList),cTtFormatList,"|")).
                IF ENTRY(LOOKUP(hColumn:NAME,cTtFieldList),cTtWidthList,"|") NE "" THEN                                        
                  hColumn:WIDTH-CHARS = INT(ENTRY(LOOKUP(hColumn:NAME,cTtFieldList),cTtWidthList,"|")).
              END.  
            END.
            DO iy = 1 TO NUM-ENTRIES(cTtFieldList):
              DO ix = 1 TO BROWSE-HANDLE:NUM-COLUMNS:
                hColumn = BROWSE-HANDLE:GET-BROWSE-COLUMN(ix).
                IF hColumn:NAME = ENTRY(iy,cTtFieldList) THEN DO:
                  BROWSE-HANDLE:MOVE-COLUMN(ix,iy).
                  cViewBuffsAndFlds = cViewBuffsAndFlds + ";" + hColumn:NAME + "|" + hColumn:DATA-TYPE + "|" + REPLACE(hColumn:FORMAT,",","<") + "||" + hColumn:LABEL.
                  LEAVE.
                END.  
              END.
            END.
            DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"viewBuffersAndFields",cViewBuffsAndFlds).
          END.    
          THIS-OBJECT:filterFields = cTtFieldList. /* fikset for sql */
        END.
        ASSIGN BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
               QUERY-HANDLE      = BROWSE-HANDLE:QUERY
               TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
               cBuffersAndFields = icBuffersAndFields
               hBrowse           = BROWSE-HANDLE 
               .
        IF cSortExpr NE "" THEN
          DYNAMIC-FUNCTION("setSortString",BROWSE-HANDLE,cSortExpr).     
        IF VALID-HANDLE(SEARCH-FIELD-HANDLE) THEN
          THIS-OBJECT:setSearchField(SEARCH-FIELD-HANDLE,cSearchColumn).
        IF cQueryJoin NE "" THEN
          queryJoin = cQueryJoin.  
        cBufferList = ENTRY(1,ENTRY(1,icBuffersAndFields),";") + cBufferList.
        
        CATCH eErr AS Progress.Lang.Error :
          MESSAGE eErr:GetMessage(1)
          VIEW-AS ALERT-BOX.
        END CATCH.
      END SET.  

  DEF PUBLIC PROPERTY enabledColumns AS CHAR GET.
      SET(icFieldList AS CHAR):
        DEF VAR ix       AS INT    NO-UNDO.
        DEF VAR hColumn  AS HANDLE NO-UNDO.
        DEF VAR oFillIn  AS JBoxBrowseFillIn NO-UNDO.
        DEF VAR oToggle  AS JBoxBrowseToggle NO-UNDO.
        DO ix = 1 TO BROWSE-HANDLE:NUM-COLUMNS:
          IF CAN-DO(icFieldList,BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):NAME) AND (IF icFieldList = "*" THEN BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):VISIBLE ELSE TRUE) THEN DO:
            IF BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):DATA-TYPE = "LOGICAL" THEN 
              oToggle = NEW JBoxBrowseToggle(THIS-OBJECT,BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):NAME,hSourceProc,
                        icFieldList NE "*" /* Refresh after each update if all columns are enabled */
                        ).
            ELSE            
              oFillIn = NEW JBoxBrowseFillIn(THIS-OBJECT,BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):NAME,hSourceProc,
                        icFieldList NE "*" /* Refresh after each update if all columns are enabled */
                        ).
          END.            
        END. 
      END SET.

  DEF PUBLIC PROPERTY enableOnDblClick AS LOG
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"enableOnDblClick") = "yes". END GET.
      SET(ibEnable AS LOG):
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"enableOnDblClick",STRING(ibEnable)).        
      END SET.

  DEF PUBLIC PROPERTY enableOnToolbarClick AS LOG
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"enableOnToolbarClick") = "yes". END GET.
      SET(ibEnable AS LOG):
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"enableOnToolbarClick",STRING(ibEnable)).        
      END SET.

  DEF PUBLIC PROPERTY setReadOnlyOnReturn AS LOG
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"setReadOnlyOnReturn") = "yes". END GET.
      SET(ibEnable AS LOG):
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"setReadOnlyOnReturn",STRING(ibEnable)).        
      END SET.

  DEF PUBLIC PROPERTY customCreateProc AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customCreateProc"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"customCreateProc",icSetting).  
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"customCreateProc",icSetting). /* Duplicated since the buffer might function as a field-map */  
      END SET.
      
  DEF PUBLIC PROPERTY customUpdateValProc AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customUdateValProc"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"customUpdateValProc",  
                         (IF icSetting = "ignore" OR icSetting BEGINS "+" THEN icSetting ELSE "=" + TRIM(icSetting,"="))).
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"customUpdateValProc",DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customUpdateValProc")).            
      END SET.
      
  DEF PUBLIC PROPERTY customDeleteValProc AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customDeleteValProc"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"customDeleteValProc",
                         (IF icSetting = "ignore" OR icSetting BEGINS "+" THEN icSetting ELSE "=" + TRIM(icSetting,"="))).  
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"customDeleteValProc",DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customDeleteValProc")).            
      END SET.

  DEF PUBLIC PROPERTY dynamicDeleteValidation AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customDeleteValProc") = "". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"customDeleteValProc",IF ibSetting THEN "" ELSE "ignore").  
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"customDeleteValProc",DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customDeleteValProc")).            
      END SET.

  DEF PUBLIC PROPERTY dynamicUpdateValidation AS LOG 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customUpdateValProc") = "". END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"customUpdateValProc",IF ibSetting THEN "" ELSE "ignore").  
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"customUpdateValProc",DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"customUpdateValProc")).            
      END SET.
       
  DEF PUBLIC PROPERTY postUpdateProc AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"postUdateProc"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"postUpdateProc",icSetting).
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"postUpdateProc",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY bufferExtraFields AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"bufferExtraFields"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"bufferExtraFields",icSetting).
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"bufferExtraFields",icSetting).
      END SET.
       
  DEF PUBLIC PROPERTY bufferExtraValues AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"bufferExtraValues"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"bufferExtraValues",icSetting).
        DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"bufferExtraValues",icSetting).
      END SET.
      
  DEF PUBLIC PROPERTY serverTransInputParam AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"serverTransInputParam"). END GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"serverTransInputParam",icSetting).
      END SET.

  DEF PUBLIC PROPERTY serverTransReturnParam AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"serverTransReturnParam"). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY serverTransReturnMessage AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"serverTransReturnMessage"). END GET. 
      PROTECTED SET.

  DEF PUBLIC PROPERTY placeholderName AS CHAR 
      GET(): RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"placeholderName"). END GET. 
      PROTECTED SET.
        
   DEF PUBLIC PROPERTY editUsingOverlayFieldMap AS LOG
      GET(): END GET.
      SET(ibSetting AS LOG):
        DEF VAR hToolbar  AS HANDLE NO-UNDO.
        
        DEF VAR cUpdFlds     AS CHAR NO-UNDO.
        DEF VAR cCorrUpdFlds AS CHAR NO-UNDO.
        DEF VAR ix           AS INT  NO-UNDO.
        DEF VAR hCol         AS HANDLE NO-UNDO.
        
        IF ibSetting AND NOT VALID-HANDLE(hColumnFieldMap) THEN DO:
          DO ix = 1 TO THIS-OBJECT:BROWSE-HANDLE:NUM-COLUMNS:
            hCol = THIS-OBJECT:BROWSE-HANDLE:GET-BROWSE-COLUMN(ix).
            FIND FIRST ttOverlay WHERE ttOverlay.cBrowseColumn = hCol:NAME NO-ERROR.
            IF AVAIL ttOverlay THEN DO: 
              ttOverlay.iSeq = -1.
              LEAVE.
            END.
          END.      

          hToolbar = DYNAMIC-FUNCTION("GetLinkedObject",THIS-OBJECT:BROWSE-HANDLE,"toolbar","from").
        
          FOR EACH ttOverlay BY ttOverlay.iSeq:
            ASSIGN cUpdFlds = cUpdFlds + (IF cUpdFlds NE "" THEN "," ELSE "") + ttOverlay.cBrowseColumn
                   cCorrUpdFlds = cCorrUpdFlds + (IF cCorrUpdFlds NE "" THEN "," ELSE "") + ttOverlay.cBufferColumn
                   .  
            DYNAMIC-FUNCTION("setAttribute",ttOverlay.hOverlay,"refreshRow","no").       
          END.    
          
          IF cUpdFlds NE "" AND VALID-HANDLE(hToolbar) THEN DO: 
            hColumnFieldMap = DYNAMIC-FUNCTION("NewFieldMap"
                         ,THIS-OBJECT:BROWSE-HANDLE:QUERY
                         ,THIS-OBJECT:BROWSE-HANDLE:FRAME
                         ,cCorrUpdFlds,cUpdFlds
                         ,"",""
                         ,";UseForBrwOverlays").      
            DYNAMIC-FUNCTION("CreateObjectLink",hColumnFieldMap,THIS-OBJECT:BROWSE-HANDLE).
            DYNAMIC-FUNCTION("CreateObjectLink",hColumnFieldMap,hToolbar).
            
            DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"insertBrowseRow","yes").  
            DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"editWithFieldMap","yes").  
            DYNAMIC-FUNCTION("setAttribute",hColumnFieldMap,"fieldMapIsBrowse","yes").
            DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"editUsingOverlayFieldMap","yes").
            DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"enableOnToolbarClick","yes").
          END.
          ELSE IF NOT VALID-HANDLE(hToolbar) THEN
            MESSAGE 'Failed to set property "editUsingOverlayFieldMap" - no toolbar is defined'
                     VIEW-AS ALERT-BOX ERROR.   
          ELSE 
            MESSAGE 'Failed to set property "editUsingOverlayFieldMap" - no overlay fields are defined'
                     VIEW-AS ALERT-BOX ERROR.   
        END.
        ELSE
          hToolbar = DYNAMIC-FUNCTION("GetLinkedObject",THIS-OBJECT:BROWSE-HANDLE,"toolbar","from").
                  
      END SET.
      
  DEFINE PUBLIC PROPERTY disabledTools AS CHARACTER
    GET():
      RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"disabledEvents").
    END GET.
    SET(icSetting AS CHARACTER): 
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"disabledEvents",icSetting).
    END SET.
        
  DEFINE PUBLIC PROPERTY enabledTools AS CHARACTER
    GET():
      RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"enabledEvents").
    END GET.
    SET(icSetting AS CHARACTER): 
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"enabledEvents",icSetting).
    END SET.  

  DEFINE PUBLIC PROPERTY dataBrowseObject AS LOG
    GET():
      RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"dataBrowseObject") = "yes".
    END GET.
    SET(ibSetting AS LOG): 
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"dataBrowseObject",IF ibSetting THEN "yes" ELSE "").
    END SET.  

  DEFINE PUBLIC PROPERTY advancedFilterDisabled AS LOG
    GET():
      RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"advancedfilterdisabled") = "yes".
    END GET.
    SET(ibSetting AS LOG): 
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"advancedfilterdisabled",IF ibSetting THEN "yes" ELSE "").
    END SET.  
      
  DEFINE PUBLIC PROPERTY gridFilterFieldsInUse AS CHAR NO-UNDO
    GET():
      DEF VAR cAllFields    AS CHAR NO-UNDO.
      DEF VAR cInUseList  AS CHAR NO-UNDO.
      DEF VAR ix            AS INT  NO-UNDO.
      cAllFields = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"currviewfields").
      DO ix = 1 TO NUM-ENTRIES(cAllFields):
        IF DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridOperatorInUse_" + ENTRY(ix,cAllFields)) NE "" AND
           DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridFilterValue_" + ENTRY(ix,cAllFields)) NE "" THEN
          cInUseList = cInUseList + (IF cInUseList NE "" THEN "," ELSE "") + ENTRY(ix,cAllFields).   
      END.
      RETURN cInUseList.  
    END GET.
    PROTECTED SET.    

  DEFINE PUBLIC PROPERTY gridFilterOperatorsInUse AS CHAR NO-UNDO
    GET():
      DEF VAR cAllFields    AS CHAR NO-UNDO.
      DEF VAR cInUseList  AS CHAR NO-UNDO.
      DEF VAR ix            AS INT  NO-UNDO.
      cAllFields = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"currviewfields").
      DO ix = 1 TO NUM-ENTRIES(cAllFields):
        IF DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridOperatorInUse_" + ENTRY(ix,cAllFields)) NE "" AND
           DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridFilterValue_" + ENTRY(ix,cAllFields)) NE "" THEN
          cInUseList = cInUseList + (IF cInUseList NE "" THEN "," ELSE "") 
                     + DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridOperatorInUse_" + ENTRY(ix,cAllFields)).   
      END.
      RETURN cInUseList.  
    END GET.
    PROTECTED SET.    

  DEFINE PUBLIC PROPERTY gridFilterValuesInUse AS CHAR NO-UNDO
    GET():
      DEF VAR cAllFields    AS CHAR NO-UNDO.
      DEF VAR cInUseList  AS CHAR NO-UNDO.
      DEF VAR ix            AS INT  NO-UNDO.
      cAllFields = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"currviewfields").
      DO ix = 1 TO NUM-ENTRIES(cAllFields):
        IF DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridOperatorInUse_" + ENTRY(ix,cAllFields)) NE "" AND
           DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridFilterValue_" + ENTRY(ix,cAllFields)) NE "" THEN
          cInUseList = cInUseList + (IF cInUseList NE "" THEN "|" ELSE "") 
                     + DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"gridFilterValue_" + ENTRY(ix,cAllFields)).   
      END.
      RETURN cInUseList.  
    END GET.
    PROTECTED SET.    
                 	
  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
      ASSIGN BROWSE-HANDLE     = ihDesignWidget
             BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
             QUERY-HANDLE      = BROWSE-HANDLE:QUERY
             TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
             cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
             hBrowse           = BROWSE-HANDLE
             .
    ELSE 
      InitializeComponent(ihDesignWidget,NO,"",NO,?).
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ihSourceProc   AS HANDLE):
      SUPER ().

    hSourceProc = ihSourceProc.

    IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
      ASSIGN BROWSE-HANDLE     = ihDesignWidget
             BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
             QUERY-HANDLE      = BROWSE-HANDLE:QUERY
             TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
             cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
             hBrowse           = BROWSE-HANDLE
             . 
    ELSE
      InitializeComponent(ihDesignWidget,NO,"",NO,?).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ihSourceProc   AS HANDLE
                                ,ibMultiple     AS LOG):
      SUPER ().

    hSourceProc = ihSourceProc.

    IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
      ASSIGN BROWSE-HANDLE     = ihDesignWidget
             BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
             QUERY-HANDLE      = BROWSE-HANDLE:QUERY
             TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
             cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
             hBrowse           = BROWSE-HANDLE
             . 
    ELSE
      InitializeComponent(ihDesignWidget,ibMultiple,"",NO,?).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ihSourceProc   AS HANDLE
                                ,ibMultiple     AS LOG
                                ,ihTEMP-TABLE   AS HANDLE):
      SUPER ().

    hSourceProc = ihSourceProc.

    IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
      ASSIGN BROWSE-HANDLE     = ihDesignWidget
             BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
             QUERY-HANDLE      = BROWSE-HANDLE:QUERY
             TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
             cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
             hBrowse           = BROWSE-HANDLE
             . 
    ELSE
      InitializeComponent(ihDesignWidget,ibMultiple,"",NO,ihTEMP-TABLE).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ibMultiple     AS LOG
                                ,ihTEMP-TABLE   AS HANDLE):
      SUPER ().

    hSourceProc = SOURCE-PROCEDURE.

    IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
      ASSIGN BROWSE-HANDLE     = ihDesignWidget
             BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
             QUERY-HANDLE      = BROWSE-HANDLE:QUERY
             TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
             cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
             hBrowse           = BROWSE-HANDLE
             . 
    ELSE
      InitializeComponent(ihDesignWidget,ibMultiple,"",NO,ihTEMP-TABLE).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ihSourceProc   AS HANDLE
                                ,ibMultiple     AS LOG
                                ,ihTEMP-TABLE   AS HANDLE
                                ,ibDataBrowse   AS LOG):
      SUPER ().

    hSourceProc = ihSourceProc.

    THIS-OBJECT:dataBrowseObject = ibDataBrowse.
  
    IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
      ASSIGN BROWSE-HANDLE     = ihDesignWidget
             BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
             QUERY-HANDLE      = BROWSE-HANDLE:QUERY
             TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
             cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
             hBrowse           = BROWSE-HANDLE
             . 
    ELSE
      InitializeComponent(ihDesignWidget,ibMultiple,"",NO,ihTEMP-TABLE).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE,ibMultiple AS LOG):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ihDesignWidget,ibMultiple,"",NO,?).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ibMultiple     AS LOG
                                ,icTitle        AS CHAR):
      SUPER ().

    hSourceProc = SOURCE-PROCEDURE.
    
    InitializeComponent(ihDesignWidget,ibMultiple,icTitle,NO,?).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ibMultiple     AS LOG
                                ,icTitle        AS CHAR
                                ,icSQLdbName    AS CHAR):
    SUPER ().

    hSourceProc = SOURCE-PROCEDURE.

    IF icSQLdbName = "" THEN DO:
      InitializeComponent(ihDesignWidget,ibMultiple,icTitle,NO,?).                 
      RETURN.
    END.

    IF CAN-DO("webclient,4glclient",SESSION:CLIENT-TYPE) AND NOT SESSION:BATCH-MODE THEN    
      SQLdbName = JBoxServerApi:Instance:getDataSourceConnection (icSQLdbName).
    ELSE  
      SQLdbName = JBoxServerSide:Instance:getDataSourceConnection (icSQLdbName).
      
    IF SQLdbName = "" THEN
      SQLdbName = icSQLdbName.
    
    InitializeComponent(ihDesignWidget,ibMultiple,icTitle,NO,?).                 
      
    THIS-OBJECT:setJBoxAttribute("sqlDbname",SQLdbName).
    THIs-OBJECT:useLocalData = NO.
      
  END CONSTRUCTOR.
  
  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget AS HANDLE
                                ,ibMultiple     AS LOG
                                ,icTitle        AS CHAR
                                ,ibRowMarkers   AS LOG):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    
    InitializeComponent(ihDesignWidget,ibMultiple,icTitle,ibRowMarkers,?).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget     AS HANDLE
                                ,ibMultiple         AS LOG
                                ,icTitle            AS CHAR
                                ,ibRowMarkers       AS LOG
                                ,iTEMP-TABLE-HANDLE AS HANDLE):
      SUPER ().

    hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ihDesignWidget,ibMultiple,icTitle,ibRowMarkers,iTEMP-TABLE-HANDLE).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget     AS HANDLE
                                ,ihSourceProc       AS HANDLE
                                ,ibMultiple         AS LOG
                                ,icTitle            AS CHAR
                                ,ibRowMarkers       AS LOG
                                ,iTEMP-TABLE-HANDLE AS HANDLE):
      SUPER ().

    hSourceProc = ihSourceProc.

    InitializeComponent(ihDesignWidget,ibMultiple,icTitle,ibRowMarkers,iTEMP-TABLE-HANDLE).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget     AS HANDLE
                                ,ibMultiple         AS LOG
                                ,icTitle            AS CHAR
                                ,ibRowMarkers       AS LOG
                                ,iTEMP-TABLE-HANDLE AS HANDLE
                                ,icSqlDbName        AS CHAR
                                ,icBuffersAndFields AS CHAR):
      SUPER ().

    hSourceProc = SOURCE-PROCEDURE.

    IF CAN-DO("webclient,4glclient",SESSION:CLIENT-TYPE) AND NOT SESSION:BATCH-MODE THEN    
      SQLdbName = JBoxServerApi:Instance:getDataSourceConnection (icSQLdbName).
    ELSE  
      SQLdbName = JBoxServerSide:Instance:getDataSourceConnection (icSQLdbName).
      
    IF SQLdbName = "" THEN
      SQLdbName = icSQLdbName.

    cBuffersAndFields = icBuffersAndFields.
                
    InitializeComponent(ihDesignWidget,ibMultiple,icTitle,ibRowMarkers,iTEMP-TABLE-HANDLE).                 
      
    THIS-OBJECT:setJBoxAttribute("sqlDbname",SQLdbName).
    THIs-OBJECT:useLocalData = NO.

      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowse (ihDesignWidget   AS HANDLE
                                ,icSQLdbName      AS CHAR):
    SUPER ().

    DEF VAR ix AS INT NO-UNDO.

    hSourceProc = SOURCE-PROCEDURE.

    IF icSQLdbName = "" THEN DO:
      IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
        ASSIGN BROWSE-HANDLE     = ihDesignWidget
               BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
               QUERY-HANDLE      = BROWSE-HANDLE:QUERY
               TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
               cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
               hBrowse           = BROWSE-HANDLE
               .
      ELSE 
        InitializeComponent(ihDesignWidget,NO,"",NO,?).
      RETURN.
    END.

    IF CAN-DO("webclient,4glclient",SESSION:CLIENT-TYPE) AND NOT SESSION:BATCH-MODE THEN
      SQLdbName = JBoxServerApi:Instance:getDataSourceConnection (icSQLdbName).
    ELSE 
      SQLdbName = JBoxServerSide:Instance:getDataSourceConnection (icSQLdbName).
      
    IF SQLdbName = "" THEN
      SQLdbName = icSQLdbName.

    IF ihDesignWidget:TYPE = "browse" AND DYNAMIC-FUNCTION("getObjectType",ihDesignWidget) = "browse" THEN    
      ASSIGN BROWSE-HANDLE     = ihDesignWidget
             BUFFER-HANDLE     = BROWSE-HANDLE:QUERY:GET-BUFFER-HANDLE(1)
             QUERY-HANDLE      = BROWSE-HANDLE:QUERY
             TEMP-TABLE-HANDLE = BUFFER-HANDLE:TABLE-HANDLE
             cBuffersAndFields = DYNAMIC-FUNCTION("getAttribute",ihDesignWidget,"buffersAndFields")
             hBrowse           = BROWSE-HANDLE
             .
    ELSE 
      InitializeComponent(ihDesignWidget,NO,"",NO,ihDesignWidget:QUERY:GET-BUFFER-HANDLE (1)).
              
    THIS-OBJECT:setJBoxAttribute("sqlDbname",SQLdbName).
    THIS-OBJECT:setQuerySort(ihDesignWidget:GET-BROWSE-COLUMN (1):NAME).
    THIs-OBJECT:useLocalData = NO.
      
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL createGridFilter(INPUT icFilterExcludeFields AS CHAR ):
    DEF VAR ix                   AS INT    NO-UNDO.
    DEF VAR hColumn              AS HANDLE NO-UNDO.
    DEF VAR cSearchFields        AS CHAR   NO-UNDO.
    DEF VAR cSearchColumns       AS CHAR   NO-UNDO.
    DEF VAR hFillIn              AS HANDLE NO-UNDO.
    DEF VAR hFirstGridFilterFld  AS HANDLE NO-UNDO.
    DEF VAR hLastGridFilterFld   AS HANDLE NO-UNDO.
    DEF VAR cFieldHandleList     AS CHAR   NO-UNDO.
    DEF VAR cFieldLabelList      AS CHAR   NO-UNDO.
    DEF VAR cDropDownList        AS CHAR   NO-UNDO.
    DEF VAR cDropDownFields      AS CHAR   NO-UNDO.
    DEF VAR cDropDownQuery       AS CHAR   NO-UNDO.
    DEF VAR cOperatorList        AS CHAR   NO-UNDO.
    DEF VAR cDropDownQueryResult AS CHAR   NO-UNDO.
    DEF VAR hPlaceHolder         AS HANDLE NO-UNDO. // Uses first search field as place-holder for GRID-FILTER-OBJECT
    DEF VAR iSearchXpos          AS INT    NO-UNDO.
    DEF VAR hPrevFillin          AS HANDLE NO-UNDO.

    DYNAMIC-FUNCTION("deleteObject",GRID-FILTER-HANDLE).

    IF icFilterExcludeFields = "*" THEN RETURN NO.

    IF VALID-OBJECT(POPUP-MENU-OBJECT) AND VALID-HANDLE(POPUP-MENU-OBJECT:POPUP-MENU-HANDLE) THEN DO:
      POPUP-MENU-OBJECT:addRule().
      POPUP-MENU-OBJECT:addTool("clearGridFilter"
                                ,IF DYNAMIC-FUNCTION("Scandinavian") THEN "Blank kolonnefilter" ELSE "Clear grid-filter"
                                ,YES).
    END.
    ELSE  
      DYNAMIC-FUNCTION("NewMenuBand",BROWSE-HANDLE
                                  ,"clearGridFilter;"
                                  + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "Blank kolonnefilter" ELSE "Clear grid-filter") + "¤enable"
                                  ,"").

    BROWSE-HANDLE:HEIGHT-PIXELS = BROWSE-HANDLE:HEIGHT-PIXELS - 24.
    BROWSE-HANDLE:Y = BROWSE-HANDLE:Y + 24.     
    DO ix = 1 TO BROWSE-HANDLE:NUM-COLUMNS:
      hColumn = BROWSE-HANDLE:GET-BROWSE-COLUMN(ix).
      
      IF icFilterExcludeFields NE "" AND CAN-DO(icFilterExcludeFields,hColumn:NAME) THEN NEXT.
      
      cDropDownList   = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"filterDropdownValuelist_" + hColumn:NAME).
      cDropDownFields = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"filterDropdownFields_" + hColumn:NAME).
      cDropDownQuery  = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"filterDropdownQuery_" + hColumn:NAME).
            
      IF hColumn:X NE ? THEN DO:
        IF BROWSE-HANDLE:X + hColumn:X + hColumn:WIDTH-PIXELS LT BROWSE-HANDLE:FRAME:WIDTH-PIXELS THEN
          iSearchXpos = BROWSE-HANDLE:X + hColumn:X.
        ELSE iSearchXpos = 1.
        IF cDropDownQuery NE "" THEN 
          cDropDownQueryResult = JBoxServerAPI:Instance:FieldList(cDropDownFields,cDropDownQuery,"|",THIS-OBJECT:SQLdbName).
          
        IF cDropDownList NE "" OR cDropDownQueryResult NE "" THEN DO:
           
          CREATE COMBO-BOX hFillIn
            ASSIGN DELIMITER        = "|"
                   DATA-TYPE        = "CHARACTER"
                   FORMAT           = "x(256)"
                   NAME             = "search_" + hColumn:NAME
                   SUBTYPE          = "DROP-DOWN-LIST"
                   INNER-LINES      = 50
                   FRAME            = BROWSE-HANDLE:FRAME
                   LIST-ITEM-PAIRS  = IF cDropDownList NE "||" AND cDropDownList NE "" THEN cDropDownList 
                                      ELSE cDropDownList + cDropDownQueryResult
                   X                = iSearchXpos
                   Y                = BROWSE-HANDLE:Y - 23
                   WIDTH-PIXELS     = hColumn:WIDTH-PIXELS - 1
                   VISIBLE          = BROWSE-HANDLE:X + hColumn:X + hColumn:WIDTH-PIXELS < BROWSE-HANDLE:FRAME:WIDTH-PIXELS
                   SENSITIVE        = TRUE
                   TAB-STOP         = TRUE
                   HELP             = hColumn:HELP
                   TOOLTIP          = hColumn:HELP
                   .
          hFillIn:LIST-ITEM-PAIRS = "||" + hFillIn:LIST-ITEM-PAIRS.
          cOperatorList = cOperatorList + (IF cOperatorList NE "" THEN "," ELSE "") + "=".
        END.  
        ELSE IF hColumn:DATA-TYPE = "logical" THEN DO:
          CREATE COMBO-BOX hFillIn
            ASSIGN DELIMITER        = "|"
                   DATA-TYPE        = "CHARACTER"
                   FORMAT           = "x(256)"
                   NAME             = "search_" + hColumn:NAME
                   SUBTYPE          = "DROP-DOWN-LIST"
                   FRAME            = BROWSE-HANDLE:FRAME
                   LIST-ITEM-PAIRS  = "||" + ENTRY(1,hColumn:FORMAT,"/") + "|yes|" + ENTRY(2,hColumn:FORMAT,"/") + "|no"
                   X                = iSearchXpos
                   Y                = BROWSE-HANDLE:Y - 23
                   WIDTH-PIXELS     = hColumn:WIDTH-PIXELS - 1
                   VISIBLE          = BROWSE-HANDLE:X + hColumn:X + hColumn:WIDTH-PIXELS < BROWSE-HANDLE:FRAME:WIDTH-PIXELS
                   SENSITIVE        = TRUE
                   TAB-STOP         = TRUE
                   HELP             = hColumn:HELP
                   TOOLTIP          = hColumn:HELP
                   .
          cOperatorList = cOperatorList + (IF cOperatorList NE "" THEN "," ELSE "") + "=".
        END.           
        ELSE DO:
          CREATE FILL-IN hFillIn 
            ASSIGN FRAME            = BROWSE-HANDLE:FRAME
                   NAME             = "search_" + hColumn:NAME
                   DATA-TYPE        = (IF CAN-DO("integer,int64,decimal,widget-handle",hColumn:DATA-TYPE) THEN "CHARACTER" ELSE hColumn:DATA-TYPE)
                   FORMAT           = (IF CAN-DO("integer,int64,decimal,widget-handle",hColumn:DATA-TYPE) THEN "x(12)"
                                       ELSE IF hColumn:FORMAT = "!" THEN "X" 
                                       ELSE REPLACE(hColumn:FORMAT,"!",""))
                   X                = iSearchXpos
                   Y                = BROWSE-HANDLE:Y - 23
                   WIDTH-PIXELS     = hColumn:WIDTH-PIXELS - 1
                   VISIBLE          = BROWSE-HANDLE:X + hColumn:X + hColumn:WIDTH-PIXELS < BROWSE-HANDLE:FRAME:WIDTH-PIXELS
                   SENSITIVE        = TRUE
                   TAB-STOP         = TRUE
                   HELP             = hColumn:HELP
                   TOOLTIP          = IF JBoxSession:Instance:Scandinavian THEN "Dobbeltklikk (eller F3) for å velge operator"
                                      ELSE "Double-click (or F3) to select operator"
                   SCREEN-VALUE     = ""
                   .
          cOperatorList = cOperatorList + (IF cOperatorList NE "" THEN "," ELSE "") + "default".
        END.
                 
        IF hColumn:DATA-TYPE BEGINS "date" THEN DO:
          ON BACKSPACE OF hFillIn PERSISTENT RUN DoProcessEvent (SOURCE-PROCEDURE,"clear-date-time").
          ON DELETE-CHARACTER OF hFillIn PERSISTENT RUN DoProcessEvent (SOURCE-PROCEDURE,"clear-date-time").
          ON " " OF hFillIn PERSISTENT  RUN DoProcessEvent (SOURCE-PROCEDURE,"clear-date-time").
          ON "t" OF hFillIn PERSISTENT  RUN DoProcessEvent (SOURCE-PROCEDURE,"todays-date-key").
          ON "d" OF hFillIn PERSISTENT  RUN DoProcessEvent (SOURCE-PROCEDURE,"todays-date-key").
          ON "+" OF hFillIn PERSISTENT  RUN DoProcessEvent (SOURCE-PROCEDURE,"todays-date-key").
          ON "-" OF hFillIn PERSISTENT  RUN DoProcessEvent (SOURCE-PROCEDURE,"todays-date-key").
        END.    

        IF hFillIn:TYPE NE "COMBO-BOX" THEN DO:
          ON MOUSE-SELECT-DBLCLICK OF hFillIn PERSISTENT RUN DoProcessEvent (SOURCE-PROCEDURE,"grid-filter-lookup").
          ON F3 OF hFillIn PERSISTENT RUN DoProcessEvent (SOURCE-PROCEDURE,"grid-filter-lookup").
        END.
          
        ON ENTRY OF hFillIn PERSISTENT RUN DoProcessEvent (SOURCE-PROCEDURE,"entry-of-widget").
        ON SHIFT-CURSOR-RIGHT OF hFillIn PERSISTENT RUN DoProcessEvent (SOURCE-PROCEDURE,"shift-cursor-right-gridfilter").

        ASSIGN cSearchFields = cSearchFields + (IF cSearchFields NE "" THEN "," ELSE "")  + "search_" + hColumn:NAME
               cSearchColumns = cSearchColumns + (IF cSearchColumns NE "" THEN "," ELSE "") + hColumn:NAME
               cFieldHandleList = cFieldHandleList + (IF cFieldHandleList NE "" THEN "," ELSE "") + STRING(hFillIn)
               cFieldLabelList = cFieldLabelList + (IF cFieldLabelList NE "" THEN "|" ELSE "") + (IF hColumn:LABEL NE ? THEN hColumn:LABEL ELSE hColumn:NAME).
                 
        IF hFirstGridFilterFld = ? THEN hFirstGridFilterFld = hFillIn.
        hLastGridFilterFld = hFillIn.         
        DYNAMIC-FUNCTION("setAttribute",hFillIn,"myHelpText",(IF DYNAMIC-FUNCTION("Scandinavian") THEN "Søk " ELSE "Search ")
                                     + (IF hColumn:LABEL NE ? THEN hColumn:LABEL ELSE hColumn:NAME)
                                     + (IF hColumn:DATA-TYPE NE "logical" THEN
                                          " " + (IF DYNAMIC-FUNCTION("Scandinavian") THEN "F3/dobbelklikk for valg" ELSE "F3/dbl.click for options")
                                        ELSE "")
                         ).
        IF NOT VALID-HANDLE(hPlaceHolder) THEN hPlaceHolder = hFillIn.
        IF VALID-HANDLE(hPrevFillIn) THEN
          hFillIn:MOVE-AFTER(hPrevFillIn).
        hPrevFillin = hFillIn.  
      END.  
    END.
    IF hFirstGridFilterFld = ? THEN RETURN NO.
    
    GRID-FILTER-HANDLE = DYNAMIC-FUNCTION("NewGridFilter",
                               BROWSE-HANDLE,
                               hFirstGridFilterFld,
                               cSearchFields,        /* Input fields */
                               cSearchColumns,       /* Corr. buffer fields - blank if equal to input flds */
                               REPLACE(cOperatorList,"default",""),        /* Operators - if different from default */
                               cSearchFields,        /* List of operatorfields */
                               YES,                  /* Start the filter on RETURN or VALUE-CHANGED of input flds */
                               "").
    DYNAMIC-FUNCTION("createObjectLink",GRID-FILTER-HANDLE,BROWSE-HANDLE).   
    
    PUBLISH "DoResizeSetting" FROM SOURCE-PROCEDURE ("setNoMoveX",BROWSE-HANDLE:FRAME,cSearchFields).
    
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"keepsearchvalue","yes").
        
    DO ix = 1 TO NUM-ENTRIES(cFieldHandleList):
      hFillIn = WIDGET-HANDLE(ENTRY(ix,cFieldHandleList)).
      DYNAMIC-FUNCTION("AddEvent",GRID-FILTER-HANDLE,hFillIn,"grid-filter-lookup","grid-filter-lookup","fill-in",ENTRY(ix,cFieldLabelList,"|"),"gridFilterLookup").
      DYNAMIC-FUNCTION("AddEvent",GRID-FILTER-HANDLE,hFillIn,"entry-of-widget","entry-of-widget","fill-in",ENTRY(ix,cFieldLabelList,"|"),"EntryOfWidget").
      IF hFillIn:DATA-TYPE BEGINS "date" THEN DO:
        DYNAMIC-FUNCTION("AddEvent",GRID-FILTER-HANDLE,hFillIn,"todays-date-key","todays-date-key","fill-in",ENTRY(ix,cFieldLabelList,"|"),"TodaysDateKey").
        DYNAMIC-FUNCTION("AddEvent",GRID-FILTER-HANDLE,hFillIn,"clear-date-time","clear-date-time","fill-in",ENTRY(ix,cFieldLabelList,"|"),"ClearDateTime").
        DYNAMIC-FUNCTION("AddEvent",GRID-FILTER-HANDLE,hFillIn,"shift-cursor-right-gridfilter","shift-cursor-right-gridfilter","fill-in",ENTRY(ix,cFieldLabelList,"|"),"ShiftCursorRightGridFilter").
      END.  
    END.
    
    APPLY "ENTRY" TO hFirstGridFilterFld.
    hFirstGridFilterFld:MOVE-AFTER-TAB-ITEM (BROWSE-HANDLE).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"nextTabItem",STRING(hFirstGridFilterFld)).
    DYNAMIC-FUNCTION("setAttribute",GRID-FILTER-HANDLE,"return-no-apply","yes").

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
    FINALLY:
      RETURN YES.
    END.  

  END METHOD.

	METHOD PRIVATE CHARACTER getFilterOper(INPUT icOper AS CHAR):
		
		DEFINE VARIABLE ocOper AS CHARACTER NO-UNDO.
  
    CASE TRIM(icOper):
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

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID InitFilterGroup(icFilterGroupName AS CHAR
                                    ,icGroupOperator   AS CHAR  ):
    
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterGroup_Operator_" + icFilterGroupName,icFilterGroupName + "|" + icGroupOperator).

  END METHOD.

  METHOD PUBLIC VOID addFilterGroupCriteria (icFilterGroupName AS CHAR
                                            ,icFieldOperator   AS CHAR  
                                            ,icFieldName       AS CHAR
                                            ,icOperator        AS CHAR
                                            ,icValue           AS CHAR):

    DEF VAR iFieldInstCnt AS INT NO-UNDO.
    
    iFieldInstCnt = INT(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE, "filterGroup_" + icFilterGroupName + "_FieldCnt_" + icFieldName)) + 1.
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterGroup_" + icFilterGroupName + "_FieldCnt_" + icFieldName,STRING(iFieldInstCnt)).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterGroup_" + icFilterGroupName + "_FieldName_" + icFieldName,icFieldName).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterGroup_" + icFilterGroupName + "_FieldOperator_" + icFieldName + "_" + STRING(iFieldInstCnt),icFieldOperator).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterGroup_" + icFilterGroupName + "_Operator_" + icFieldName + "_" + STRING(iFieldInstCnt),icOperator).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterGroup_" + icFilterGroupName + "_Value_" + icFieldName + "_" + STRING(iFieldInstCnt),icValue).

  END METHOD.

  METHOD PRIVATE VOID initializeComponent(ihDesignWidget     AS HANDLE 
                                         ,ibMultiple         AS LOG
                                         ,icTitle            AS CHAR
                                         ,ibRowMarkers       AS LOG
                                         ,iTEMP-TABLE-HANDLE AS HANDLE):
    DEF VAR ix            AS INT  NO-UNDO.
    DEF VAR cBuffsAndFlds AS CHAR NO-UNDO.
    DEF VAR cQueryJoin    AS CHAR NO-UNDO.
    DEF VAR cBufferList   AS CHAR NO-UNDO.
    DEF VAR cCalcFldProc  AS CHAR NO-UNDO.
    DEF VAR cCalcFlds     AS CHAR NO-UNDO.
    DEF VAR cCalcParams   AS CHAR NO-UNDO.                                           
    DEF VAR cDistinctCols AS CHAR NO-UNDO.
    DEF VAR cAccumFields  AS CHAR NO-UNDO.
    DEF VAR cBufferDef    AS CHAR NO-UNDO.
    DEF VAR cBufferFields AS CHAR NO-UNDO.
    DEF VAR cFieldDef     AS CHAR NO-UNDO.
    DEF VAR iy            AS INT  NO-UNDO.
    DEF VAR cNotExist     AS CHAR NO-UNDO.
 
    DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).
    DYNAMIC-FUNCTION("NewObject",
                     IF VALID-HANDLE(hSourceProc:CURRENT-WINDOW) THEN hSourceProc:CURRENT-WINDOW ELSE ?,
                     hSourceProc,"procedure").

    DESIGN-WIDGET-HANDLE  = ihDesignWidget.
    IF ihDesignWidget:TYPE = "browse" AND SQLdbName = "" THEN DO: 
      IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getBuffersAndFieldsBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME) THEN  
        cBuffsAndFlds = DYNAMIC-FUNCTION("getBuffersAndFieldsBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME IN hSourceProc) NO-ERROR.
      IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getQueryJoinBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME) THEN DO:  
        cQueryJoin = TRIM(DYNAMIC-FUNCTION("getQueryJoinBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME IN hSourceProc),",").
        DYNAMIC-FUNCTION("setAttribute",ihDesignWidget,"queryJoin","," + cQueryJoin) NO-ERROR.
      END.
      IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getCalcFieldProcBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME) THEN  
        DYNAMIC-FUNCTION("setAttribute",ihDesignWidget,"calcFieldProc",DYNAMIC-FUNCTION("getCalcFieldProcBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME IN hSourceProc)) NO-ERROR.
    END.  
    ELSE DO:
      DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).
      IF NOT dataBrowseObject AND SQLdbName = "" THEN
        DYNAMIC-FUNCTION("NewObject",
                         IF VALID-HANDLE(hSourceProc:CURRENT-WINDOW) THEN hSourceProc:CURRENT-WINDOW ELSE ?,
                         ihDesignWidget,"browse").
      ELSE IF SQLdbName NE "" AND ihDesignWidget:TYPE = "browse" AND CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getQueryJoinBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME) THEN DO:  
        cQueryJoin = TRIM(DYNAMIC-FUNCTION("getQueryJoinBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME IN hSourceProc),",").
        IF cQueryJoin NE "" THEN
          DYNAMIC-FUNCTION("setAttribute",ihDesignWidget,"queryJoin",CHR(1) + "," + cQueryJoin) NO-ERROR.
        IF CAN-DO(hSourceProc:INTERNAL-ENTRIES,"getBuffersAndFieldsBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME) THEN  
          cBuffsAndFlds = DYNAMIC-FUNCTION("getBuffersAndFieldsBrw" + ihDesignWidget:QUERY:GET-BUFFER-HANDLE(1):NAME IN hSourceProc) NO-ERROR.
      END.
    END.                     
    
    IF ibMultiple THEN 
      cInitAttr = "MULTIPLE".
    IF icTitle NE "" THEN
      cInitAttr = cInitAttr + (IF cInitAttr NE "" THEN "," ELSE "") + "TITLE|" + icTitle.               
    IF ibRowMarkers THEN
      cInitAttr = cInitAttr + (IF cInitAttr NE "" THEN "," ELSE "") + "ROW-MARKERS".               
               
    BROWSE-HANDLE = DESIGN-WIDGET-HANDLE.
    
    IF VALID-HANDLE(iTEMP-TABLE-HANDLE) THEN DO:
      IF iTEMP-TABLE-HANDLE:TYPE = "buffer" THEN 
        TEMP-TABLE-HANDLE = iTEMP-TABLE-HANDLE:TABLE-HANDLE.
      ELSE 
        TEMP-TABLE-HANDLE = iTEMP-TABLE-HANDLE.
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"tempTableHandle",STRING(TEMP-TABLE-HANDLE)).
      
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"basetable",iTEMP-TABLE-HANDLE:NAME).
      IF NOT dataBrowseObject THEN DO:
        IF cBuffsAndFlds = "" AND cBuffersAndFields NE "" THEN // case: dynamic browse for sql where tt is pre-defined
          cBuffsAndFlds = cBuffersAndFields.
          
        buffersAndFields = "". /* Creates the browse - no need to set buffers and fields from container */

        IF cBuffersAndFields = "" OR bRebuildBuffAndFld THEN DO: /* except if sql */
        
          cDistinctCols = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"distinctColumns").
          cAccumFields  = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"accumFields").

/*          DO ix = 1 TO NUM-ENTRIES(cBuffsAndFlds):                                                                     */
/*            cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(ix,cBuffsAndFlds),";").*/
/*          END.                                                                                                         */

          EMPTY TEMP-TABLE ttFieldBufferRef.
      
          DO ix = 1 TO NUM-ENTRIES(cBuffsAndFlds):
            cBufferDef = ENTRY(1,ENTRY(ix,cBuffsAndFlds),";").
            IF cBufferDef BEGINS "NOT EXIST " THEN 
              ASSIGN cBufferDef = TRIM(SUBSTR(cBufferDef,11))
                     cNotExist = cNotExist + (IF cNotExist NE "" THEN "," ELSE "") 
                               + ENTRY(NUM-ENTRIES(cBufferDef,"."),cBufferDef,".") 
                     .
            cBufferFields = ENTRY(ix,cBuffsAndFlds).
            IF NUM-ENTRIES(cBufferDef,".") > 1 THEN cBufferDef = ENTRY(2,cBufferDef,".").
            cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + cBufferDef.
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


          DO ix = 2 TO NUM-ENTRIES(cBuffsAndFlds,";"):
            IF NUM-ENTRIES(ENTRY(ix,cBuffsAndFlds,";"),"|") > 3 AND ENTRY(4,ENTRY(ix,cBuffsAndFlds,";"),"|") NE "" THEN
              ASSIGN cCalcFlds   = cCalcFlds + (IF cCalcFlds NE "" THEN "," ELSE "") + TRIM(ENTRY(1,ENTRY(ix,cBuffsAndFlds,";"),"|"),"+")
                     cCalcParams = cCalcParams + (IF cCalcParams NE "" THEN "," ELSE "") + ENTRY(4,ENTRY(ix,cBuffsAndFlds,";"),"|")
                     .
          END.
        
          cBuffersAndFields = THIS-OBJECT:BUFFER-HANDLE:NAME.
          cBufferList = cBuffersAndFields.
          DO ix = 1 TO THIS-OBJECT:BUFFER-HANDLE:NUM-FIELDS:
            IF NOT BUFFER-HANDLE:BUFFER-FIELD(ix):NAME BEGINS "RowIdent" AND NOT BUFFER-HANDLE:BUFFER-FIELD(ix):NAME BEGINS "RowCount" THEN DO:
              FIND FIRST ttFieldBufferRef
                   WHERE ttFieldBufferRef.FieldName = BUFFER-HANDLE:BUFFER-FIELD(ix):NAME
                   NO-ERROR.         
              cBuffersAndFields = cBuffersAndFields + ";" 
                                + (IF CAN-DO(cDistinctCols,BUFFER-HANDLE:BUFFER-FIELD(ix):NAME) THEN "distinct "
                                   ELSE IF CAN-DO(cAccumFields,BUFFER-HANDLE:BUFFER-FIELD(ix):NAME) THEN "accum "
                                   ELSE "")   
                                + (IF AVAIL ttFieldBufferRef THEN ttFieldBufferRef.FieldName ELSE BUFFER-HANDLE:BUFFER-FIELD(ix):NAME) + "|" 
                                + BUFFER-HANDLE:BUFFER-FIELD(ix):DATA-TYPE + "|"
                                + REPLACE(DYNAMIC-FUNCTION("getBrowseColumnFormat",BROWSE-HANDLE,BUFFER-HANDLE:BUFFER-FIELD(ix):NAME),",","<") 
                                + "|"
                                + (IF CAN-DO(cCalcFlds,BUFFER-HANDLE:BUFFER-FIELD (ix):NAME) THEN ENTRY(LOOKUP(BUFFER-HANDLE:BUFFER-FIELD (ix):NAME,cCalcFlds),cCalcParams) ELSE "")  
                                + "|"
                                + DYNAMIC-FUNCTION("getBrowseColumnLabel",BROWSE-HANDLE,BUFFER-HANDLE:BUFFER-FIELD(ix):NAME) 
                                .        

              IF AVAIL ttFieldBufferRef THEN
                cBuffersAndFields = cBuffersAndFields + "|" + ttFieldBufferRef.BufferName
                                  + (IF CAN-DO(cNotExist,ttFieldBufferRef.BufferName) THEN "NOT EXIST " ELSE "") 
                                  .
              ELSE IF CAN-DO(cCalcFlds,BUFFER-HANDLE:BUFFER-FIELD (ix):NAME) THEN DO:
                FIND FIRST ttFieldBufferRef
                     WHERE ttFieldBufferRef.FieldName = "+" + BUFFER-HANDLE:BUFFER-FIELD (ix):NAME
                     NO-ERROR.         
                IF AVAIL ttFieldBufferRef THEN
                  cBuffersAndFields = cBuffersAndFields + "|" + ttFieldBufferRef.BufferName.
              END.
            END.
          END.   
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"buffersAndFields",cBuffersAndFields).
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"bufferList",cBufferList).
          DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"numbuffers",STRING(NUM-ENTRIES(cBufferList))).
        END.  
      END.  
    END.  
    ELSE IF cBuffsAndFlds NE "" THEN DO: 
      buffersAndFields = cBuffsAndFlds.
      cBufferList = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"bufferList").
    END.
    
    IF VALID-HANDLE(ihDesignWidget) AND ihDesignWidget:TYPE = "browse" THEN
      DYNAMIC-FUNCTION("CreateObjectLink",BROWSE-HANDLE,hSourceProc).
                 
    IF DYNAMIC-FUNCTION("getAttribute",SESSION,"rowsToBatch") NE "" THEN
      THIS-OBJECT:rowsToBatch = INT(DYNAMIC-FUNCTION("getAttribute",SESSION,"rowsToBatch")).
    ELSE               
      THIS-OBJECT:rowsToBatch = 200.      
      
    PUBLISH "setChildBrowseObject" FROM hSourceProc (hSourceProc,THIS-OBJECT). /* publish to tabfolder class */                             
    PUBLISH "setContainerBrowseObject" FROM hSourceProc (hSourceProc,THIS-OBJECT). /* publish to container class */

    IF NUM-ENTRIES(BuffersAndFields,";") > 1 THEN    
      JBoxLookupDef:Instance:assignFilterLookup(THIS-OBJECT).
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.                             
  END METHOD.                                       

  METHOD PUBLIC LOGICAL applyFilter(icExprList AS CHAR):
    DEF VAR cFields    AS CHAR NO-UNDO.
    DEF VAR cOperators AS CHAR NO-UNDO.
    DEF VAR cValues    AS CHAR NO-UNDO.
    DEF VAR hToolbar AS HANDLE NO-UNDO.
    
    hToolbar = DYNAMIC-FUNCTION("getLinkedObject",BROWSE-HANDLE,"toolbar","from").
    bOK = NO.                                  
    IF resolveFilterExpr(IF icExprList = "" THEN cLastFilter ELSE icExprList,OUTPUT cFields,OUTPUT cOperators,OUTPUT cValues) THEN DO:                                  
      IF BROWSE-HANDLE:TYPE = "browse" THEN DO:                                  
        bOK = DYNAMIC-FUNCTION("InitDynFilter",BROWSE-HANDLE,cFields,cOperators,cValues,
                              (IF hToolbar = ? OR DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonFilter") = "" THEN "static" ELSE "") +
                              (IF bNoExecFilter THEN "noexec" ELSE IF bTryFilter THEN "try" ELSE "")).
        DYNAMIC-FUNCTION("setCurrentObject",BROWSE-HANDLE).
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
    hToolbar = DYNAMIC-FUNCTION("getLinkedObject",BROWSE-HANDLE,"toolbar","from").
    
    bOK = NO.                                  
    IF QUERY-HANDLE:TYPE = "Browse" THEN DO:                                  
      bOK = DYNAMIC-FUNCTION("InitDynFilter",BROWSE-HANDLE,icFieldList,icOperList,icValueList,
                             (IF hToolbar = ? OR DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonFilter") = "" THEN "static" ELSE "") +
                             (IF bNoExecFilter THEN "noexec" ELSE IF bTryFilter THEN "try" ELSE "")).
      DYNAMIC-FUNCTION("setCurrentObject",BROWSE-HANDLE).
    END.                         
    ELSE
      MESSAGE "Filter cannot be applied before object is initialized, ie buffers and fields are defined (buffersAndFields property)"
      VIEW-AS ALERT-BOX.
      
    ASSIGN bTryFilter = NO
           bNoExecFilter = NO
           cLastFilter = "".

    RETURN bOk.      
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose: Use if object name was changed after initialization (to get the correct user settings)
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID initViewFields( INPUT icViewFields AS CHAR ):
    
    DEF VAR cUserViewFields  AS CHAR NO-UNDO.
    DEF VAR cOrgViewFields   AS CHAR NO-UNDO.
    DEF VAR cUserWidthPixels AS CHAR NO-UNDO.
    DEF VAR cWidthPixelsList AS CHAR NO-UNDO.
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR iy AS INT NO-UNDO.
   
    cWidthPixelsList = widthPixelsList.
     
    cUserWidthPixels = DYNAMIC-FUNCTION("getUserSetting",
                                         hSourceProc:FILE-NAME,
                                         objectName,
                                         userSettingContext,
                                        "widthpixelslist").
                                            
    IF cUserWidthPixels NE "" THEN
      DO ix = 1 TO NUM-ENTRIES(cUserWidthPixels):
        iy = LOOKUP(ENTRY(1,ENTRY(ix,cUserWidthPixels),";"),allViewFields).
        IF iy > 0 THEN
          ENTRY(iy,cWidthPixelsList) = ENTRY(2,ENTRY(ix,cUserWidthPixels),";").
      END.
    widthPixelsList = TRIM(cWidthPixelsList,",").
    
    cUserViewFields = DYNAMIC-FUNCTION("getUserSetting",
                                       hSourceProc:FILE-NAME,
                                       objectName,
                                       userSettingContext,
                                       "currviewfields").
/*      cOrgViewFields = DYNAMIC-FUNCTION("getUserSetting",      */
/*                                         hSourceProc:FILE-NAME,*/
/*                                         objectName,           */
/*                                         userSettingContext,   */
/*                                         "orgviewfields").     */
/*    ELSE                             */
/*      cCurrViewFields = icViewFields.*/
      
    overlayBGcolor = INT(DYNAMIC-FUNCTION("getUserSetting",
                                     hSourceProc:FILE-NAME,
                                     objectName,
                                     userSettingContext,
                                     "overlaybgcolor")).
    IF overlayBGcolor NE 0 THEN
      overlayBGcolNum = DYNAMIC-FUNCTION("getColNumFromRGB",overlayBGcolor) NO-ERROR.
    
    IF cUserViewFields = "" THEN cUserViewFields = icViewFields.
    IF cUserViewFields = "" THEN cUserViewFields = allViewFields.

    currviewfields = cUserViewFields.

    IF cUserViewFields NE allViewFields 
       OR cUserWidthPixels NE "" 
/*       OR getAttribute(hBrowse,"nodbreadaccessfields") NE ""  */
/*       OR getAttribute(hBrowse,"nodbwriteaccessfields") NE "" */
/*       OR getAttribute(hBrowse,"nodbwriteaccessbuffers") NE ""*/
       THEN 
      DYNAMIC-FUNCTION("setBrowseColumns",BROWSE-HANDLE,cUserViewFields,NO).
    
    RETURN.

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
    
    hToolbar = DYNAMIC-FUNCTION("getLinkedObject",BROWSE-HANDLE,"toolbar","from").
    
    IF BROWSE-HANDLE:TYPE = "browse" THEN DO:                                  
      bOK = DYNAMIC-FUNCTION("InitDynFilter",BROWSE-HANDLE,icFieldList,icOperList,icValueList,
                             IF hToolbar = ? OR DYNAMIC-FUNCTION("getAttribute",hToolbar,"buttonFilter") = "" THEN "static,noexec" ELSE "noexec").
      DYNAMIC-FUNCTION("setCurrentObject",BROWSE-HANDLE).
    END.                         
    ELSE
      MESSAGE "Filter cannot be applied before object is initialized, ie buffers and fields are defined (buffersAndFields property)"
      VIEW-AS ALERT-BOX.
  END METHOD.  

  METHOD PUBLIC VOID setGridFilter(icFieldList AS CHAR
                                  ,icOperList  AS CHAR
                                  ,icValueList AS CHAR):
    
    IF BROWSE-HANDLE:TYPE = "browse" THEN DO:                                  
      bOK = DYNAMIC-FUNCTION("InitGridFilter",BROWSE-HANDLE,icFieldList,icOperList,icValueList,"noexec").
      DYNAMIC-FUNCTION("setCurrentObject",BROWSE-HANDLE).
    END.                         
    ELSE
      MESSAGE "Filter cannot be applied before object is initialized, ie buffers and fields are defined (buffersAndFields property)"
      VIEW-AS ALERT-BOX.
  END METHOD.  

  METHOD PUBLIC VOID setGridFilterDropDownList(icSearchFieldName AS CHAR
                                              ,icDropDownList AS CHAR
                                              ,icScreenValue AS CHAR):
    
    DEF VAR hDropDown     AS HANDLE NO-UNDO.
    DEF VAR ix            AS INT    NO-UNDO.
    DEF VAR cList         AS CHAR   NO-UNDO.
    DEF VAR hFilterValues AS HANDLE NO-UNDO.
    DEF VAR bOk           AS LOG NO-UNDO.
    
    icSearchFieldName = LEFT-TRIM(icSearchFieldName,"search_").
    
    hDropDown = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",GRID-FILTER-HANDLE,"filterfield_search_" + icSearchFieldName)) NO-ERROR.
        
    IF VALID-HANDLE(hDropDown) THEN DO:
      IF INDEX(icDropDownList,"|") > 0 THEN 
        hDropDown:LIST-ITEM-PAIRS = icDropDownList.
      ELSE DO:
        DO ix = 1 TO NUM-ENTRIES(icDropDownList):
          cList = cList + (IF cList NE "" THEN "|" ELSE "||") + ENTRY(ix,icDropDownList) + "|" + ENTRY(ix,icDropDownList).
        END.
        hDropDown:LIST-ITEM-PAIRS = cList.   
      END.
      hFilterValues = DYNAMIC-FUNCTION("getCurrentObject").
      hFilterValues = hFilterValues:BUFFER-HANDLE.
      bOK = hFilterValues:FIND-FIRST("WHERE ColumnName = '" + icSearchFieldName + "'") NO-ERROR.
      IF bOk THEN 
        ASSIGN hFilterValues::ColumnValue = icScreenValue
               hFilterValues::Operator = IF icScreenValue = "" THEN "" ELSE "=".
    END.
  END METHOD.  

  METHOD PUBLIC VOID clearFilter():
    bNoExecFilter = YES.
    applyFilter("").
    displayRecord().
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

  METHOD PUBLIC VOID clearGridFilter():
    RUN InvokeMethod(GRID-FILTER-HANDLE,"clearGridFilterRecord").
  END METHOD.  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setGridFilterFieldOperator( INPUT icFieldName AS CHAR, INPUT icOperator AS CHAR ):
    
    IF NOT icFieldName BEGINS "search_" THEN icFieldName = "search_" + icFieldName.
    
    DYNAMIC-FUNCTION("setAttribute",GRID-FILTER-HANDLE,"gridOperatorInUse_" + icFieldName,icOperator).

  END METHOD.

  METHOD PUBLIC VOID setQuerySort(icSortExpr AS CHAR): /* "field1;[desc],field2.." or "field1 [desc] by field2.." */
    DEF VAR ix         AS INT  NO-UNDO.
    DEF VAR cEntry     AS CHAR NO-UNDO.
    DEF VAR cPrevEntry AS CHAR NO-UNDO.
    DEF VAR cNewString AS CHAR NO-UNDO.
    
    icSortExpr = REPLACE(icSortExpr,"descending","desc").
    
    IF NUM-ENTRIES(icSortExpr," ") > 1 AND NUM-ENTRIES(icSortExpr) = 1 THEN DO:
      DO ix = 1 TO NUM-ENTRIES(icSortExpr," "):
        cEntry = ENTRY(ix,icSortExpr," ").
        IF cEntry = "BY" THEN
          cNewString = cNewString + (IF cNewString NE "" THEN "," ELSE "").
        ELSE IF (cEntry = "desc" OR cEntry = "descending") AND cPrevEntry NE "BY" AND cNewString NE "" THEN
          cNewString = cNewString + ";desc".
        ELSE 
          cNewString = cNewString + (IF cNewString NE "" THEN "," ELSE "") + cEntry.       
        cPrevEntry = cEntry.  
      END.
      icSortExpr = cNewString.
    END.    
    
    IF VALID-HANDLE(BROWSE-HANDLE) AND BROWSE-HANDLE:TYPE = "browse" THEN
      DYNAMIC-FUNCTION("setSortString",BROWSE-HANDLE,icSortExpr).
    ELSE cSortExpr = icSortExpr.
  END METHOD.
  
  // Reverses the sort properties to the initial expr: field[;desc][,field..
  METHOD PUBLIC CHARACTER getQuerySort():
    DEF VAR ix         AS INT  NO-UNDO.
    DEF VAR cSortExpr  AS CHAR NO-UNDO.   
    
    IF NUM-ENTRIES(querySort," ") > 1 THEN
      DO ix = 1 TO NUM-ENTRIES(querySort," "):
        cSortExpr = cSortExpr
                  + (IF cSortExpr = "" THEN ENTRY(ix,querySort," ")
                     ELSE 
                      (IF ENTRY(ix,querySort," ") = "desc" THEN ";DESC" 
                       ELSE "," + ENTRY(ix,querySort," "))
                     ).
      END.
    ELSE     
      cSortExpr  = querySort + (IF getJBoxAttribute("querydesc") NE "" THEN ";" + getJBoxAttribute("querydesc") ELSE "").
    RETURN cSortExpr.  
  END METHOD.  

  METHOD PUBLIC VOID addCalcField(icSourceBuffer AS CHAR
                                 ,icFieldName    AS CHAR
                                 ,icProcedure    AS CHAR
                                 ,icParameter    AS CHAR):
    DEF VAR ix            AS INT    NO-UNDO.
    DEF VAR cBufferFields AS CHAR   NO-UNDO.
    DEF VAR cFieldDef     AS CHAR   NO-UNDO.
    DEF VAR cBuffsAndFlds AS CHAR   NO-UNDO.
    DEF VAR cBuffFldsDef  AS CHAR   NO-UNDO.
    DEF VAR cAllCalcFlds  AS CHAR   NO-UNDO.
    DEF VAR hColumn       AS HANDLE NO-UNDO.
    
    hColumn = BUFFER-HANDLE:BUFFER-FIELD (icFieldName) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE ERROR-STATUS:GET-MESSAGE(1) SKIP
              "(Field " icFieldName  " needs to be defined in the static temp-table " buffer-handle:NAME ")"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    
    IF icSourceBuffer = "" THEN icSourceBuffer = ENTRY(1,cBufferList).
    cFieldDef = "+" + icFieldName + "|" + hColumn:DATA-TYPE + "||" + icProcedure 
              + (IF icParameter = "calcParam" THEN
                   "ROWID"          
                 ELSE IF CAN-DO("jb_can-find,jb_total",icProcedure) THEN  
                   "(" + icParameter + ")"
                 ELSE IF icParameter NE "" AND DYNAMIC-FUNCTION ("getIsFieldInTable",icSourceBuffer + "." + icParameter) THEN 
                   "(" + icParameter + ")"
                 ELSE IF icParameter NE "" THEN
                   "ROWID" + icParameter  
                 ELSE "").
    
    cBufferFields = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"bufferFields" + icSourceBuffer).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"fieldBuffer" + icFieldName,icSourceBuffer).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"orgDbField" + icFieldName,icFieldName).
    cAllCalcFlds = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"allCalcFields").
    IF NOT CAN-DO(cAllCalcFlds,icFieldName) THEN DO:
      cAllCalcFlds = icFieldName + (IF cAllCalcFlds NE "" THEN "," ELSE "") + cAllCalcFlds.
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"allCalcFields",cAllCalcFlds).
    END.
    IF NOT CAN-DO(cBufferFields,icFieldName) THEN DO:
      cBufferFields = cBufferFields + (IF cBufferFields NE "" THEN "," ELSE "") + icFieldName.
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"bufferFields" + icSourceBuffer,cBufferFields).
    END.  
    cBufferFields = "".
    DO ix = 1 TO NUM-ENTRIES(cBuffersAndFields):
      cBuffFldsDef = ENTRY(ix,cBuffersAndFields).
      IF ENTRY(1,cBuffFldsDef,";") = icSourceBuffer AND lookup(cFieldDef,cBuffFldsDef,";") = 0 THEN
        cBuffFldsDef = cBuffFldsDef + ";" + cFieldDef.
      cBufferFields = cBufferFields + (IF cBufferFields NE "" THEN "," ELSE "") + cBuffFldsDef. 
    END.           
    cBuffersAndFields = cBufferFields.                        
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"buffersAndFields",cBufferFields).
  END METHOD.
  METHOD PUBLIC VOID addCalcField(icFieldName    AS CHAR
                                 ,icProcedure    AS CHAR
                                 ,icParameter    AS CHAR):
    addCalcField("",icFieldName,icProcedure,icParameter).
  END METHOD.
  METHOD PUBLIC VOID addCalcField(icFieldName    AS CHAR
                                 ,icProcedure    AS CHAR):
    addCalcField("",icFieldName,icProcedure,"").
  END METHOD.
  
  METHOD PUBLIC VOID calcCan-Find(icSourceBuffer AS CHAR
                                 ,icFieldName    AS CHAR
                                 ,icExpression   AS CHAR):
    DEF VAR hColumn AS HANDLE NO-UNDO.
                                  
    hColumn = BUFFER-HANDLE:BUFFER-FIELD (icFieldName) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE ERROR-STATUS:GET-MESSAGE(1) SKIP
              "(Field " icFieldName  " needs to be defined as type LOGICAL in the temp-table " buffer-handle:NAME ")"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    ELSE IF hColumn:DATA-TYPE NE "LOGICAL" THEN DO:
      MESSAGE "Field " icFieldName  " needs to be defined as type LOGICAL in the temp-table " buffer-handle:NAME
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    IF icExpression BEGINS "(" THEN icExpression = SUBSTR(icExpression,2).
    IF SUBSTR(icExpression,LENGTH(icExpression)) = ")" THEN
      icExpression = SUBSTR(icExpression,1,LENGTH(icExpression) - 1).
    addCalcField(icSourceBuffer,icFieldName,"jb_can-find",icExpression).
  END METHOD.
  METHOD PUBLIC VOID calcCan-Find(icFieldName    AS CHAR
                                 ,icExpression   AS CHAR):
    calcCan-Find("",icFieldName,icExpression).                               
  END METHOD.

  METHOD PUBLIC VOID calcTotal(icSourceBuffer AS CHAR
                              ,icFieldName    AS CHAR
                              ,icQuery        AS CHAR
                              ,icExpression   AS CHAR):
    DEF VAR hColumn AS HANDLE NO-UNDO.
                                  
    hColumn = BUFFER-HANDLE:BUFFER-FIELD (icFieldName) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE ERROR-STATUS:GET-MESSAGE(1) SKIP
              "(Field " icFieldName  " needs to be defined as type DECIMAL or INTEGER in the temp-table " buffer-handle:NAME ")"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    ELSE IF NOT CAN-DO("DECIMAL,INTEGER",hColumn:DATA-TYPE) THEN DO:
      MESSAGE "Field " icFieldName  " needs to be defined as type DECIMAL or INTEGER in the temp-table " buffer-handle:NAME
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    addCalcField(icSourceBuffer,icFieldName,"jb_total",icQuery + "¤" + icExpression).
  END METHOD.
  METHOD PUBLIC VOID calcTotal(icFieldName    AS CHAR
                              ,icQuery        AS CHAR
                              ,icExpression   AS CHAR):
    calcTotal("",icFieldName,icQuery,icExpression).                               
  END METHOD.


  METHOD PUBLIC VOID calcWeek(icSourceBuffer AS CHAR
                             ,icFieldName    AS CHAR
                             ,icParamField   AS CHAR):
    DEF VAR hColumn AS HANDLE NO-UNDO.
                
    IF icSourceBuffer = "" THEN icSourceBuffer = ENTRY(1,cBufferList).
                                  
    hColumn = BUFFER-HANDLE:BUFFER-FIELD (icFieldName) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      MESSAGE ERROR-STATUS:GET-MESSAGE(1) SKIP
              "(Field " icFieldName  " needs to be defined as type CHARACTER in the temp-table " buffer-handle:NAME ")"
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    ELSE IF hColumn:DATA-TYPE NE "CHARACTER" THEN DO:
      MESSAGE "Field " icFieldName  " needs to be defined as type CHARACTER in the temp-table " buffer-handle:NAME
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    
    IF DYNAMIC-FUNCTION ("getFieldDataType",icSourceBuffer + "." + icParamField) NE "date" THEN DO:
      MESSAGE ERROR-STATUS:GET-MESSAGE(1) SKIP
              "Parameterfield " icParamField  " needs to be of type DATE."
      VIEW-AS ALERT-BOX ERROR.
      RETURN.
    END.
    addCalcField(icSourceBuffer,icFieldName,"jb_weeknum",icParamField).
  END METHOD.

  METHOD PUBLIC VOID setCalcFieldParam(icFieldName AS CHAR
                                      ,icParameter AS CHAR):
    IF INDEX(icParameter,",") > 0 OR INDEX(icParameter,";") > 0 OR INDEX(icParameter,"|") > 0 THEN
      MESSAGE "Characters , ; or | (pipe) not allowed in parameter value for calculated field " icFieldName SKIP
              "Use f.ex CHR(1)" 
      VIEW-AS ALERT-BOX ERROR.
    ELSE                                    
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"calcParam" + icFieldName,icParameter).        
  END METHOD.
           	
  METHOD PUBLIC VOID openQuery():
    RUN InvokeMethod(BROWSE-HANDLE,"OpenQuery").
  END METHOD.
  
  METHOD PUBLIC VOID openQuery(INPUT icQueryString AS CHAR):
    icQueryString = TRIM(icQueryString).
    IF (DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"baseQuery") NE "" OR
        DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"queryFilter") NE "") AND 
       icQueryString BEGINS "WHERE " THEN DO:
      icQueryString = " AND (" + SUBSTR(icQueryString,6) + ")".      
    END.
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"queryWhere",icQueryString).
    RUN InvokeMethod(BROWSE-HANDLE,"OpenQuery").
  END METHOD.
  
  METHOD PUBLIC VOID displayRecord():
    /* Check if current row is modified before displaying the record, refreshing child records and setting the toolbar */
    RUN InvokeMethod(BROWSE-HANDLE,"DisplayRecord").
  END METHOD.

  METHOD PUBLIC VOID excelRecord():
    RUN InvokeMethod(BROWSE-HANDLE,"ExcelRecord").
  END METHOD.
  
  METHOD PUBLIC VOID excelRecord(icFileName AS CHAR):
    DEF VAR cType AS CHAR NO-UNDO.
    
    cType = ENTRY(NUM-ENTRIES(icFileName,"."),icFileName,".").
    IF cType = "csv" THEN
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"ExcelDelimiter",";").
    
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"ExcelFileName",icFileName).
        
    RUN InvokeMethod(BROWSE-HANDLE,"ExcelRecord").
    
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"ExcelDelimiter","").
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"ExcelFileName","").
  END METHOD.

  METHOD PUBLIC LOGICAL refreshRow():
    /* Refresh row from database */
    IF THIS-OBJECT:useLocalData THEN RETURN THIS-OBJECT:BROWSE-HANDLE:Refresh().
    ELSE
      RETURN DYNAMIC-FUNCTION("RefreshRowids",THIS-OBJECT:BROWSE-HANDLE,IF THIS-OBJECT:BUFFER-HANDLE:AVAIL THEN THIS-OBJECT:BUFFER-HANDLE::RowIdent1 ELSE "") > 0. 
  END METHOD.

  METHOD PUBLIC LOGICAL refreshSelectedRows():
    /* Refresh rows from database */
    DEF VAR ix         AS INT  NO-UNDO.
    DEF VAR cRowidList AS CHAR NO-UNDO.
    DO ix = 1 TO THIS-OBJECT:BROWSE-HANDLE:NUM-SELECTED-ROWS:
      IF THIS-OBJECT:BROWSE-HANDLE:FETCH-SELECTED-ROW(ix) THEN
        cRowidList = cRowidList + (IF cRowidList NE "" THEN "," ELSE "") + THIS-OBJECT:BUFFER-HANDLE::RowIdent1.
    END.    
      
    RETURN DYNAMIC-FUNCTION("RefreshRowids",THIS-OBJECT:BROWSE-HANDLE,cRowidList) > 0. 
  END METHOD.

  METHOD PUBLIC LOGICAL DisplayColumns():
    /* Refresh screen-values for current row only */
    RETURN DYNAMIC-FUNCTION("DisplayRow",THIS-OBJECT:BROWSE-HANDLE). 
  END METHOD.

  METHOD PUBLIC VOID refresh():
    /* Refresh all records in the query */
    RUN InvokeMethod(THIS-OBJECT:BROWSE-HANDLE,"RefreshBrowseRecord").	
  END METHOD.
    
  METHOD PUBLIC VOID setFilterDropDownQuery(icFieldName AS CHAR
                                           ,icBuffersAndFields AS CHAR
                                           ,icQuery AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterDropdownFields_" + icFieldName,icBuffersAndFields).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterDropdownQuery_" + icFieldName,icQuery).
  END METHOD.  

  METHOD PUBLIC VOID setFilterDropDownList(icFieldName  AS CHAR
                                      ,icValuePairs AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterDropdownValuelist_" + icFieldName,icValuePairs).
  END METHOD.  

  METHOD PUBLIC VOID setFilterLookup(icFieldName  AS CHAR
                                    ,icBuffersAndFields AS CHAR
                                    ,icQuery AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterLookupFields_" + icFieldName,icBuffersAndFields).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterLookupQuery_" + icFieldName,icQuery).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterLookupReturnField_" + icFieldName,icFieldName).
  END METHOD.  

  METHOD PUBLIC VOID setFilterLookup(icFieldName  AS CHAR
                                    ,icBuffersAndFields AS CHAR
                                    ,icQuery AS CHAR
                                    ,icReturnField AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterLookupFields_" + icFieldName,icBuffersAndFields).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterLookupQuery_" + icFieldName,icQuery).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterLookupReturnField_" + icFieldName,icReturnField).
  END METHOD.  

  /*----------------------------------------------------------------------------
    Purpose: Create a parent relationship for the browse 
    Notes:   If field-names are different in parent object the entry in relationship
             list must be split by ; stating the child field-name first, eg
             custnum;customernum 
    @param ioParentBrowse Parent browse object
    @param icRelationShip Comma-sep. list of fields to define the relationship             
  ------------------------------------------------------------------------------*/    
  METHOD PUBLIC VOID setParentBrowseObject(ioParentBrowse AS JBoxBrowse
                                          ,icRelationship AS CHAR):
    IF NOT VALID-OBJECT(ioParentBrowse) THEN DO:
      IF VALID-OBJECT(PARENT-BROWSE-OBJECT) THEN
        DYNAMIC-FUNCTION ("deleteObjectLink",BROWSE-HANDLE,PARENT-BROWSE-OBJECT:BROWSE-HANDLE).
    END.
    ELSE DO:
      DYNAMIC-FUNCTION ("deleteObjectLink",BROWSE-HANDLE,ioParentBrowse:BROWSE-HANDLE).
      DYNAMIC-FUNCTION("createParentLink",THIS-OBJECT:BROWSE-HANDLE,ioParentBrowse:BROWSE-HANDLE,icRelationShip).
      IF NOT VALID-OBJECT(ioParentBrowse:CHILD-BROWSE-OBJECT) THEN
        ioParentBrowse:CHILD-BROWSE-OBJECT = THIS-OBJECT.
    END.  

    PARENT-BROWSE-OBJECT = ioParentBrowse.
  END METHOD.  

  METHOD PUBLIC VOID setParentQueryObject(ioParentQuery  AS JBoxQuery
                                         ,icRelationship AS CHAR):
    IF NOT VALID-OBJECT(ioParentQuery) THEN DO:
      IF VALID-OBJECT(PARENT-QUERY-OBJECT) THEN
        DYNAMIC-FUNCTION ("deleteObjectLink",BROWSE-HANDLE,PARENT-QUERY-OBJECT:QUERY-HANDLE).
    END.
    ELSE DO:
      DYNAMIC-FUNCTION ("deleteObjectLink",BROWSE-HANDLE,ioParentQuery:QUERY-HANDLE).
      DYNAMIC-FUNCTION("createParentLink",THIS-OBJECT:BROWSE-HANDLE,ioParentQuery:QUERY-HANDLE,icRelationShip).
      IF NOT VALID-OBJECT(ioParentQuery:CHILD-BROWSE-OBJECT) THEN
        ioParentQuery:CHILD-BROWSE-OBJECT = THIS-OBJECT.
    END.  

    PARENT-QUERY-OBJECT = ioParentQuery.
  END METHOD.  

  /*----------------------------------------------------------------------------
    Purpose: Link a fill-in as column search field for the browse. 
    Notes:   The fill-in will be re-created to match the datatype of the column
             If sorting isn's specified for the browse it will be set according to 
             the search column.
    @param ihSearchField Handle for either a rectangle or a fill-in field
    @param icSearchColumn Name of initial column. If ommitted first column is assumed
  ------------------------------------------------------------------------------*/   
  METHOD PUBLIC VOID setSearchField(ihSearchField  AS HANDLE
                                   ,icSearchColumn AS CHAR):
      
    DEF VAR iColumnNum    AS INT NO-UNDO INIT 1.  
    DEF VAR hSearchField  AS HANDLE NO-UNDO.
                                     
    ASSIGN SEARCH-FIELD-HANDLE  = ihSearchField
           cSearchColumn = icSearchColumn.
    IF NOT VALID-HANDLE(BROWSE-HANDLE) OR NOT VALID-HANDLE(ihSearchField) THEN 
      RETURN.

    IF icSearchColumn NE "" THEN
      iColumnNum = DYNAMIC-FUNCTION ("getBrowseColumnNum",BROWSE-HANDLE,icSearchColumn).
    IF iColumnNum = 0 THEN iColumnNum = 1.      
    IF icSearchColumn = "" THEN
      icSearchColumn = BROWSE-HANDLE:GET-BROWSE-COLUMN(1):NAME.
                                    
    DYNAMIC-FUNCTION("deleteObjectLink",SEARCH-FIELD-HANDLE,BROWSE-HANDLE).
    
    IF DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"1stSortColumn") = "" THEN
      THIS-OBJECT:setQuerySort(icSearchColumn).                                      
    
    hSearchField = DYNAMIC-FUNCTION("NewBrowseSearchField",ihSearchField,
                   BROWSE-HANDLE,iColumnNum).
    DYNAMIC-FUNCTION("createObjectLink",BROWSE-HANDLE,hSearchField).
    SEARCH-FIELD-HANDLE = hSearchField.   
    
  END METHOD.  

  METHOD PUBLIC VOID setSearchField(ihSearchField  AS HANDLE):
    THIS-OBJECT:setSearchField(ihSearchField,"").
  END METHOD.  

  METHOD PUBLIC VOID setPreScanQuery(icJoinedTable  AS CHAR
                                    ,icQueryFromJoinedToPrimaryTable AS CHAR): 
    IF NOT icQueryFromJoinedToPrimaryTable BEGINS "FIRST " 
       AND NOT icQueryFromJoinedToPrimaryTable BEGINS "EACH "                                        
       AND NOT icQueryFromJoinedToPrimaryTable BEGINS "LAST " THEN 
      icQueryFromJoinedToPrimaryTable = "EACH " + icQueryFromJoinedToPrimaryTable.
                                              
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"prescanQuery" + icJoinedTable,icQueryFromJoinedToPrimaryTable).                                      
  END METHOD.  

  METHOD PUBLIC VOID setExtraFilterField(icTable      AS CHAR
                                        ,icField      AS CHAR
                                        ,icLabel      AS CHAR
                                        ,icPrescanQry AS CHAR):
    DEF VAR cExtraFilter AS CHAR NO-UNDO.
    cExtraFilter = DYNAMIC-FUNCTION("getAttribute",THIS-OBJECT:BROWSE-HANDLE,"extraFilterFields").
    cExtraFilter = cExtraFilter + (IF cExtraFilter NE "" THEN "," ELSE "")
                 + icTable + "." + icField + "|" + icLabel.                                           
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"extraFilterFields",cExtraFilter).
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"prescanQuery" + icTable,icPrescanQry).                                      
  END METHOD.  

  METHOD PUBLIC LOGICAL setFieldCalcProc(INPUT icFieldName AS CHAR, INPUT icProcDef AS CHAR ):
    
    DEFINE VARIABLE result AS LOGICAL NO-UNDO INIT YES.

    DEF VAR ix                AS INT    NO-UNDO. /* sql */
    DEF VAR cTTbufAndFlds     AS CHAR   NO-UNDO. /* sql */
    DEF VAR cModTTbufAndFlds  AS CHAR   NO-UNDO. /* sql */
    DEF VAR cElement          AS CHAR   NO-UNDO. /* sql */

    cTTbufAndFlds = DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"BuffersAndFields").
    IF cTTbufAndFlds NE "" THEN DO:
      DO ix = 1 TO NUM-ENTRIES(cTTbufAndFlds,";"):
        cElement = ENTRY(ix,cTTbufAndFlds,";").
        IF TRIM(ENTRY(1,cElement,"|"),"+") = icFieldName THEN
          ENTRY(4,cElement,"|") = icProcDef.
        cModTTbufAndFlds = cModTTbufAndFlds + (IF cModTTbufAndFlds NE "" THEN ";" ELSE "") + cElement.
      END.
      DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"BuffersAndFields",cModTTbufAndFlds).
    END.
    ELSE DO:
      MESSAGE "Warning: Cannot assign procedure to field when buffers and fields are not defined"
      VIEW-AS ALERT-BOX.  
      RETURN NO.
    END.

    RETURN result.

  END METHOD.

  METHOD PUBLIC VOID setFieldQuerySort(icFieldName  AS CHAR
                                      ,icSortExpr   AS CHAR):
  /*----------------------------------------------------------------------------
    Purpose: Replace the sort string when a browse column is sorted 
    Notes:   The sort expression might consist of more than one field, f.ex
             Sak.iSaksaar desc BY Sak.cSaksnr 
             the search column.
    @param icFieldName Name of (local) field name
    @param icSortExpr  [tablename.]fieldName [desc] [by [tablename.]fieldname..]
  ------------------------------------------------------------------------------*/   
    icSortExpr = REPLACE(icSortExpr," desc "," <desc> ").                                      
    icSortExpr = REPLACE(icSortExpr," descending "," <desc> ").                                      
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"myQuerySort" + icFieldName,icSortExpr).                                      
  END METHOD.  

  METHOD PUBLIC CHARACTER getFieldQuerySort(icFieldName  AS CHAR):
    RETURN DYNAMIC-FUNCTION("getAttribute",THIS-OBJECT:BROWSE-HANDLE,"myQuerySort" + icFieldName).                                      
  END METHOD.
    
  METHOD PUBLIC VOID setFieldQueryIndex(icFieldName  AS CHAR
                                       ,icIndexName  AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",THIS-OBJECT:BROWSE-HANDLE,"use-index_" + icFieldName,icIndexName).                                      
  END METHOD.  

  METHOD PUBLIC CHARACTER getFieldQueryIndex(icFieldName  AS CHAR):
    RETURN DYNAMIC-FUNCTION("getAttribute",THIS-OBJECT:BROWSE-HANDLE,"use_index_" + icFieldName).                                      
  END METHOD.  

  METHOD PUBLIC VOID registerOverlay(INPUT ioOverlay   AS Progress.Lang.Object
                                    ,INPUT icType      AS CHAR
                                    ,INPUT icBrowseColumn AS CHAR
                                    ,INPUT ihOverlay   AS HANDLE):
    DEF VAR bRefresh AS LOG NO-UNDO.        
            
    FIND FIRST ttOverlay 
         WHERE ttOverlay.oOverlay = ioOverlay 
         NO-ERROR.
    IF NOT AVAIL ttOverlay THEN DO:
      bRefresh = LOGICAL(DYNAMIC-FUNCTION("getAttribute",ihOverlay,"refreshRow")) NO-ERROR.
      
      CREATE ttOverlay.
      ASSIGN ttOverlay.oOverlay      = ioOverlay
             ttOverlay.cType         = icType
             ttOverlay.cBrowseColumn = icBrowseColumn
             ttOverlay.hOverlay      = ihOverlay
             ttOverlay.bInitRefrRow  = bRefresh
             ttOverlay.cBufferColumn = DYNAMIC-FUNCTION("getAttribute",ihOverlay,"buffercolumn")
             .
    END.                                      
  END METHOD.                                         

  METHOD PUBLIC CHARACTER getOverlaySCREEN-VALUE(icBrowseColumn AS CHAR):
    FIND FIRST ttOverlay 
         WHERE ttOverlay.cBrowseColumn = icBrowseColumn
         NO-ERROR.
    IF AVAIL ttOverlay AND VALID-OBJECT(ttOverlay.oOverlay) THEN DO:
      CASE ttOverlay.cType:
        WHEN "JBoxBrowseFillIn" THEN DO:
          DEF VAR oBrowseFillIn AS JBoxBrowseFillIn NO-UNDO.
          oBrowseFillIn = CAST(ttOverlay.oOverlay,"JBoxBrowseFillIn").
          RETURN oBrowseFillIn:SCREEN-VALUE.
        END.
        WHEN "JBoxBrowseDropDown" THEN DO:
          DEF VAR oBrowseDropDown AS JBoxBrowseDropDown NO-UNDO.
          oBrowseDropDown = CAST(ttOverlay.oOverlay,"JBoxBrowseDropDown").
          RETURN oBrowseDropDown:SCREEN-VALUE.
        END.
      END CASE.
    END.  
    ELSE RETURN ?.     
  END METHOD. 

  METHOD PUBLIC LOGICAL setOverlaySCREEN-VALUE(icBrowseColumn AS CHAR
                                              ,icScreenValue  AS CHAR):
    FIND FIRST ttOverlay 
         WHERE ttOverlay.cBrowseColumn = icBrowseColumn
         NO-ERROR.
    IF AVAIL ttOverlay AND VALID-OBJECT(ttOverlay.oOverlay) THEN DO:
      CASE ttOverlay.cType:
        WHEN "JBoxBrowseFillIn" THEN DO:
          DEF VAR oBrowseFillIn AS JBoxBrowseFillIn NO-UNDO.
          oBrowseFillIn = CAST(ttOverlay.oOverlay,"JBoxBrowseFillIn") NO-ERROR.
          IF VALID-OBJECT(oBrowseFillIn) THEN DO:
            oBrowseFillIn:SCREEN-VALUE = icScreenValue.
            RETURN YES.
          END.
          ELSE RETURN NO.
        END.
        WHEN "JBoxBrowseDropDown" THEN DO:
          DEF VAR oBrowseDropDown AS JBoxBrowseDropDown NO-UNDO.
          oBrowseDropDown = CAST(ttOverlay.oOverlay,"JBoxBrowseDropDown") NO-ERROR.
          IF VALID-OBJECT(oBrowseDropDown) THEN DO:
            oBrowseDropDown:SCREEN-VALUE = icScreenValue.
            RETURN YES.
          END.  
          ELSE RETURN NO.
        END.
      END CASE.
    END.  
    ELSE RETURN NO.     
  END METHOD. 
  
  METHOD PUBLIC HANDLE getOverlayHandle (INPUT icBrowseColumn AS CHAR).
    DEF VAR hOverlay AS HANDLE NO-UNDO.
  
    FIND FIRST ttOverlay WHERE ttOverlay.cBrowseColumn = icBrowseColumn
         NO-ERROR.
    IF AVAIL ttOverlay AND VALID-HANDLE(ttOverlay.hOverlay) THEN RETURN ttOverlay.hOverlay.
    ELSE IF AVAIL ttOverlay THEN 
      hOverlay = DYNAMIC-FUNCTION("getObjectByNameAndType",hSourceProc:CURRENT-WINDOW,ttOverlay.cBrowseColumn,ttOverlay.cType).
      
    RETURN hOverlay.
  
  END METHOD.

  METHOD PUBLIC HANDLE getPopupToolHandle (icTool  AS CHARACTER):
    DEFINE VARIABLE hWidget AS HANDLE NO-UNDO.
    hWidget = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"menu-item" + icTool)) NO-ERROR.
    RETURN hWidget.
  END METHOD.

/*
  METHOD PUBLIC LOGICAL setFilterDropDown(icFieldName AS CHAR
                                         ,icDrowDownTablesAndFlds AS CHAR
                                         ,icDrowDownQuery AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterDropDownFields_" + icFieldName,icDrowDownTablesAndFlds).                                       
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterDropDownQuery_" + icFieldName,icDrowDownQuery).                                       
  END METHOD.
  METHOD PUBLIC LOGICAL setFilterDropDown(icFieldName AS CHAR
                                         ,icDrowDownValueList AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"filterDropDownValueList_" + icFieldName,icDrowDownValueList).                                       
  END METHOD.
*/  

  METHOD PUBLIC CHARACTER getQueryStatValue(icFieldName AS CHAR):
    IF THIS-OBJECT:useLocalData AND DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"localStatValue" + icFieldName) NE "" THEN
      RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"localStatValue" + icFieldName).
    ELSE  
      RETURN DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,"statValue" + icFieldName).
  END METHOD.

  METHOD PUBLIC CHARACTER getLocalStat(icFieldList AS CHAR):
    DEF VAR cReturn AS CHAR NO-UNDO.
    cReturn = DYNAMIC-FUNCTION("getLocalQueryStat",BROWSE-HANDLE,icFieldList).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"recordcount",ENTRY(2,ENTRY(1,cReturn,";"),"|")).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"rowsadded","").
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"rowsdeleted","").
    
    DYNAMIC-FUNCTION("ViewRecordCount",BROWSE-HANDLE).
    
    IF NUM-ENTRIES(icFieldList) > 1 THEN
      RETURN SUBSTR(cReturn,INDEX(cReturn,";") + 1).
    ELSE    
      RETURN ENTRY(2,ENTRY(2,cReturn,";"),"|").
      
  END METHOD.

  METHOD PUBLIC CHARACTER getLocalStat():
    DEF VAR cReturn AS CHAR NO-UNDO.
    cReturn = DYNAMIC-FUNCTION("getLocalQueryStat",BROWSE-HANDLE,"").
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"rowsadded","").
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"rowsdeleted","").
    
    DYNAMIC-FUNCTION("ViewRecordCount",BROWSE-HANDLE).
    RETURN cReturn.
  END METHOD.

  /* Process selected rows: */ 
  METHOD PUBLIC LOGICAL processRows(icProcName AS CHAR
                                   ,icParam AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.                                           
    IF cCallFromMethod = "" THEN cCallFromMethod = ENTRY(1,PROGRAM-NAME(2)," ").
    bOk = DYNAMIC-FUNCTION("processSelectedRows",BROWSE-HANDLE,icProcName,icParam).    
    JBoxServerAPI:Instance:CreateCall(cCallFromMethod,icParam,bOk,?,hSourceProc).
    cCallFromMethod = "".    
    RETURN bOk.
  END METHOD.

  METHOD PUBLIC LOGICAL processRowsNoRefresh(icProcName AS CHAR
                                            ,icParam AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.                                           
    cCallFromMethod = ENTRY(1,PROGRAM-NAME(2)," ").
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"RefreshProcessedRows","no").    
    bOk = THIS-OBJECT:processRows(icProcName,icParam).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"RefreshProcessedRows","").
    RETURN bOK.
  END METHOD.

  METHOD PUBLIC LOGICAL processRowsNoMessage(icProcName AS CHAR
                                            ,icParam AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.                    
    cCallFromMethod = ENTRY(1,PROGRAM-NAME(2)," ").                       
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"viewErrorsFromProcessRows","no").
    bOk = THIS-OBJECT:processRows(icProcName,icParam).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"viewErrorsFromProcessRows","").
    RETURN bOK.
  END METHOD.

  /* Process all rows for query crit: */ 
  METHOD PUBLIC LOGICAL processSet(icProcName AS CHAR
                                  ,icParam AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.       
    IF cCallFromMethod = "" THEN cCallFromMethod = ENTRY(1,PROGRAM-NAME(2)," ").                                    
    bOk = DYNAMIC-FUNCTION("processQuery",BROWSE-HANDLE,icProcName,icParam).
    JBoxServerAPI:Instance:CreateCall(cCallFromMethod,icParam,bOk,?,hSourceProc).
    cCallFromMethod = "".
    RETURN bOk.
  END METHOD.

  METHOD PUBLIC LOGICAL processSetNoMessage(icProcName AS CHAR
                                           ,icParam AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.                    
    cCallFromMethod = ENTRY(1,PROGRAM-NAME(2)," ").                       
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"viewErrorsFromProcessRows","no").
    bOk = THIS-OBJECT:processSet(icProcName,icParam).
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,"viewErrorsFromProcessRows","").
    RETURN bOK.
  END METHOD.

  METHOD PUBLIC VOID setJBoxAttribute(icAttribute AS CHAR
                                     ,icValue AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",BROWSE-HANDLE,icAttribute,icValue).
  END METHOD.
  METHOD PUBLIC CHARACTER getJBoxAttribute(icAttribute AS CHAR):
    RETURN  DYNAMIC-FUNCTION("getAttribute",BROWSE-HANDLE,icAttribute).
  END METHOD.

  METHOD PUBLIC VOID applyDefaultAction():
    RUN InvokeMethod(BROWSE-HANDLE,"DefaultActionBrowse").
  END METHOD.

  METHOD PUBLIC HANDLE getColumnHandle(INPUT icColumnName AS CHAR):
    RETURN DYNAMIC-FUNCTION("getBrowseColumn",BROWSE-HANDLE,icColumnName).
  END METHOD.

  METHOD PUBLIC VOID selectAllRows():
    RUN InvokeMethod(BROWSE-HANDLE,"selectAllRowsRecord").
  END METHOD.

  METHOD PUBLIC VOID deselectRow():
    RUN InvokeMethod(BROWSE-HANDLE,"deselectRowRecord").
  END METHOD.

  METHOD PUBLIC VOID setNoResizeX():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.
  METHOD PUBLIC VOID setNoResizeY():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.  
  METHOD PUBLIC VOID setAddResizeX():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.
  METHOD PUBLIC VOID setAddResizeY():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.  
              
  METHOD PUBLIC VOID setNoMoveX():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.
  METHOD PUBLIC VOID setNoMoveY():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.
  METHOD PUBLIC VOID setAddMoveX():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.
  METHOD PUBLIC VOID setAddMoveY():
    IF VALID-HANDLE(BROWSE-HANDLE) THEN
      PUBLISH "DoResizeSetting" FROM hSourceProc (ENTRY(1,PROGRAM-NAME(1)," "),hBrowse:FRAME,BROWSE-HANDLE:NAME).
    ELSE MethPropMsg(PROGRAM-NAME(1)).  
  END METHOD.
  
  METHOD PRIVATE VOID MethPropMsg (INPUT icCall AS CHAR):
    MESSAGE "Resize setting " icCall SKIP "cannot be called until browse widget is created"
            VIEW-AS ALERT-BOX.
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

  METHOD PUBLIC LOGICAL getActionPermission(INPUT icAction AS CHAR):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    RUN JBoxLogFuncToMeth.p ("getActionPermission"
                            ,"CHARACTER,CHARACTER,CHARACTER"
                            ,hSourceProc:FILE-NAME + CHR(1) + BROWSE-HANDLE:NAME + CHR(1) + icAction
                            ,?
                            ,OUTPUT bOk).
    RETURN bOk.                        
  END.
  
  METHOD PUBLIC LOGICAL updateRow(INPUT icFields AS CHAR
                                 ,INPUT icValues AS CHAR):
                                   
    IF THIS-OBJECT:BUFFER-HANDLE:AVAIL THEN DO: 
      IF JBoxServerAPI:Instance:Update(ENTRY(1,cBufferList),THIS-OBJECT:BUFFER-HANDLE::RowIdent1,icFields,icValues) THEN DO:
        THIS-OBJECT:refreshRow().
        RETURN YES.
      END.  
      ELSE RETURN NO.
    END.
    ELSE RETURN NO.                                     
  END METHOD.

  METHOD PUBLIC LOGICAL updateSelectedRows(INPUT icFields AS CHAR
                                          ,INPUT icValues AS CHAR):
                                  
    DEF VAR ix AS INT NO-UNDO.
    
    DO ix = 1 TO THIS-OBJECT:BROWSE-HANDLE:NUM-SELECTED-ROWS:
                                   
      IF THIS-OBJECT:BROWSE-HANDLE:FETCH-SELECTED-ROW(ix) THEN DO: 
        IF NOT JBoxServerAPI:Instance:Update(ENTRY(1,cBufferList),THIS-OBJECT:BUFFER-HANDLE::RowIdent1,icFields,icValues,NO,
                                             ix = THIS-OBJECT:BROWSE-HANDLE:NUM-SELECTED-ROWS) THEN 
          RETURN NO.
      END.    
    END.
    THIS-OBJECT:refreshSelectedRows().
    RETURN YES.
  END METHOD.

  METHOD PUBLIC VOID setBrowseHandle(ihBrowse AS HANDLE):
    IF THIS-OBJECT:BROWSE-HANDLE NE ihBrowse THEN DO:
      DYNAMIC-FUNCTION ("swapObjectHandle",THIS-OBJECT:BROWSE-HANDLE,ihBrowse).
      THIS-OBJECT:BROWSE-HANDLE = ihBrowse.
      THIS-OBJECT:BUFFER-HANDLE = ihBrowse:QUERY:GET-BUFFER-HANDLE (1).
      cBufferList = DYNAMIC-FUNCTION("getAttribute",ihBrowse,"bufferlist").
    END.   
  END METHOD.  

  DESTRUCTOR PUBLIC JBoxBrowse ( ):
    DYNAMIC-FUNCTION("deleteObject",GRID-FILTER-HANDLE) NO-ERROR.
    DYNAMIC-FUNCTION("DeleteObject",BROWSE-HANDLE) NO-ERROR.
  END DESTRUCTOR.

END CLASS.
