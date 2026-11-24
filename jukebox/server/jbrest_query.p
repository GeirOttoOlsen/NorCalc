
/*------------------------------------------------------------------------
    File        : jbrest_tablejoin.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Tue Oct 18 16:59:21 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEF INPUT PARAM ioCallParam   AS JBoxJsonParser NO-UNDO.
DEF INPUT-OUTPUT PARAM DATASET-HANDLE odsResponse.

DEF VAR cBatchSize         AS CHAR   NO-UNDO.
DEF VAR iBatchSize         AS INT    NO-UNDO INIT 50.
DEF VAR cStartRow          AS CHAR   NO-UNDO.
DEF VAR iStartRow          AS INT    NO-UNDO INIT 1.
DEF VAR cStatFields        AS CHAR   NO-UNDO.
DEF VAR cStatValues        AS CHAR   NO-UNDO.
DEF VAR cBuffsAndFlds      AS CHAR   NO-UNDO.
DEF VAR bRecordCount       AS LOG    NO-UNDO.
DEF VAR ix                 AS INT    NO-UNDO.
DEF VAR iy                 AS INT    NO-UNDO.
DEF VAR httResponseHeader  AS HANDLE NO-UNDO.
DEF VAR httResult          AS HANDLE NO-UNDO.
DEF VAR cError             AS CHAR   NO-UNDO.
DEF VAR oQuery             AS JBoxQuery NO-UNDO.
DEF VAR cFilter            AS CHAR   NO-UNDO.
DEF VAR cDataSource        AS CHAR   NO-UNDO.
DEF VAR hbParserTT         AS HANDLE NO-UNDO.
DEF VAR cDataSourceType    AS CHAR   NO-UNDO.
DEF VAR cFilterGrpList     AS CHAR   NO-UNDO.
DEF VAR cFilterGroupDef    AS CHAR   NO-UNDO.
DEF VAR cFilterGroup       AS CHAR   NO-UNDO. 
DEF VAR cGroupFields       AS CHAR   NO-UNDO.
DEF VAR cGroupFieldDef     AS CHAR   NO-UNDO.
DEF VAR cGroupFldOper      AS CHAR   NO-UNDO.
DEF VAR cGroupFldValue     AS CHAR   NO-UNDO.
DEF VAR cBufferList        AS CHAR   NO-UNDO.
DEF VAR cPrescanQuery      AS CHAR   NO-UNDO.

DO ON ERROR UNDO, THROW:

  hbParserTT = ioCallParam:hdsResult:GET-BUFFER-HANDLE(1).

  DO ix = 1 TO hbParserTT:NUM-FIELDS:
    IF hbParserTT:BUFFER-FIELD(ix):DATA-TYPE = "CHARACTER" THEN
      hbParserTT:BUFFER-FIELD(ix):BUFFER-VALUE = REPLACE(REPLACE(hbParserTT:BUFFER-FIELD(ix):BUFFER-VALUE,"\u0091","["),"\u0093","]").
  END.  

  cBuffsAndFlds = ioCallParam:getResultFirstFieldValue("callparam","buffersAndFields").
  IF cBuffsAndFlds = ? THEN UNDO,THROW NEW Progress.Lang.AppError ("BuffersAndFields parameter missing",0).

  cDataSource = ioCallParam:getResultFirstFieldValue("callparam","datasource").

  IF cDataSource NE "" AND cDataSource NE ? THEN DO:
    IF JBoxServerSide:Instance:CallServerProc("jbserv_get_datasource_type.p",cDataSource) THEN 
      cDataSourceType = ENTRY(1,JBoxServerSide:Instance:getCallReturnParam(),"|").
    ELSE UNDO,THROW NEW Progress.Lang.AppError ("Error for datasource: " + JBoxServerSide:Instance:getCallMessage(),0).
     
    IF cDataSourceType MATCHES "*sql*" THEN DO:
      oQuery = NEW JBoxQuery(cBuffsAndFlds,cDataSource).
      oQuery:queryJoin = ioCallParam:getResultFirstFieldValue("callparam","queryJoin").
    END. 
    ELSE UNDO,THROW NEW Progress.Lang.AppError ("Invalid datasource type: " + cDataSourceType + " For datasource " + (IF SEARCH(cDataSource) = ? THEN " unknown: " ELSE "") + cDataSource,0). 
  END.
  ELSE DO:
    oQuery = NEW JBoxQuery().
    oQuery:buffersAndFields = ioCallParam:getResultFirstFieldValue("callparam","buffersAndFields").
    oQuery:queryJoin        = ioCallParam:getResultFirstFieldValue("callparam","queryJoin").
  END.  

  oQuery:baseQuery = ioCallParam:getResultFirstFieldValue("callparam","baseQuery").

  IF NOT cDataSourceType MATCHES "*sql*" THEN DO:
    cBufferList = oQuery:getJBoxAttribute("bufferlist").
    DO ix = 2 TO NUM-ENTRIES(cBufferList):
      cPrescanQuery = ioCallParam:getResultFirstFieldValue("callparam","prescanQuery" + ENTRY(ix,cBufferList)).
      IF cPrescanQuery NE "" THEN
        oQuery:setPrescanQuery(ENTRY(ix,cBufferList),cPrescanQuery).
    END.
    oQuery:altPrimaryBufferList = ioCallParam:getResultFirstFieldValue("callparam","altPrimaryBufferList").   
  END.   
  ELSE oQuery:preScanBaseQuery = ioCallParam:getResultFirstFieldValue("callparam","preScanBaseQuery"). // sql subselects

  // Sample filter group:     "queryFilterGroup1": "AND(salesrep,OR salesrep;=,=;hxm|jal",    
  DO ix = 1 TO 9:
    cFilterGroupDef = ioCallParam:getResultFirstFieldValue("callparam","queryFilterGroup" + STRING(ix)).
    IF cFilterGroupDef NE "" THEN DO:
      cFilterGroup = "filtergroup" + STRING(ix).
      oQuery:InitFilterGroup(cFilterGroup,ENTRY(1,cFilterGroupDef,"(")).
      cFilterGroupDef = SUBSTR(cFilterGroupDef,INDEX(cFilterGroupDef,"(") + 1).
      ASSIGN cGroupFields   = ENTRY(1,cFilterGroupDef,";")
             cGroupFldOper  = ENTRY(2,cFilterGroupDef,";")
             cGroupFldValue = ENTRY(3,cFilterGroupDef,";")
             .
      DO iy = 1 TO NUM-ENTRIES(cGroupFields):
        cGroupFieldDef = ENTRY(iy,cGroupFields).
        oQuery:addFilterGroupCriteria(cFilterGroup,
                                      IF iy = 1 OR NUM-ENTRIES(cGroupFieldDef," ") = 1 THEN 
                                        "AND"
                                      ELSE ENTRY(1,cGroupFieldDef," "),
                                      ENTRY(NUM-ENTRIES(cGroupFieldDef," "),cGroupFieldDef," "),
                                      ENTRY(iy,cGroupFldOper),
                                      ENTRY(iy,cGroupFldValue,"|")
                                      ).
      END.                                
    END.  
  END.  

  cFilter = ioCallParam:getResultFirstFieldValue("callparam","queryFilter").
  IF cFilter NE "" THEN 
    oQuery:setFilter(ENTRY(1,cFilter,";"), ENTRY(2,cFilter,";"), ENTRY(3,cFilter,";")).
  ELSE 
    oQuery:setFilter("").  

  oQuery:setQuerySort(ioCallParam:getResultFirstFieldValue("callparam","querySort")).
          
  bRecordCount = LOGICAL(ioCallParam:getResultFirstFieldValue("callparam","getRecordCount")) NO-ERROR.

  oQuery:distinctColumns = ioCallParam:getResultFirstFieldValue("callparam","distinctColumns").   
  oQuery:accumFields = ioCallParam:getResultFirstFieldValue("callparam","accumFields").   

    
  cStatFields = TRIM("elapseTime" + (IF bRecordCount THEN ",rowcount" ELSE "") 
                                   + (IF ioCallParam:getResultFirstFieldValue("callparam","queryStatFields") NE "" THEN "," + ioCallParam:getResultFirstFieldValue("callparam","queryStatFields") ELSE "")
                                   + (IF oQuery:accumFields NE "" THEN "," + oQuery:accumFields ELSE "")
                                   ,",").
  oQuery:queryStatFields = cStatFields.

    
  cStartRow = ioCallParam:getResultFirstFieldValue("callparam","startRow").
  IF cStartRow NE "" AND INT(cStartRow) NE 0 THEN iStartRow = INT(cStartRow).
  oQuery:batchQueryStart = iStartRow.  
  
  cBatchSize = ioCallParam:getResultFirstFieldValue("callparam","batchSize").
  IF cBatchSize NE "" AND INT(cBatchSize) NE 0 THEN iBatchSize = INT(cBatchSize).
  oQuery:rowsToBatch = iBatchSize.                                        
  
  DYNAMIC-FUNCTION("setQueryLogFile",ioCallParam:getResultFirstFieldValue("callparam","queryLogFile")).
  
  oQuery:openQuery().
  IF oQuery:queryError THEN
    UNDO,THROW NEW Progress.Lang.AppError ("Query error: " + oQuery:errorMessage,0).
    

  CREATE TEMP-TABLE httResponseHeader.
                                                    
  DO ix = 1 TO NUM-ENTRIES(cStatFields):
    IF ENTRY(ix,cStatFields) = "rowcount" THEN
      httResponseHeader:ADD-NEW-FIELD ("recordCount","DECIMAL").
    ELSE  
      httResponseHeader:ADD-NEW-FIELD (ENTRY(ix,cStatFields),"DECIMAL").
  END.                                                           
  httResponseHeader:TEMP-TABLE-PREPARE("responseheader").
  httResponseHeader:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE ().
  DO ix = 1 TO NUM-ENTRIES(cStatFields):
    IF ENTRY(ix,cStatFields) = "rowcount" THEN
      httResponseHeader:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD ("recordCount"):BUFFER-VALUE = oQuery:recordCount.
    ELSE
      httResponseHeader:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD (ENTRY(ix,cStatFields)):BUFFER-VALUE = DECIMAL(oQuery:getQueryStatValue(ENTRY(ix,cStatFields))).
  END.                                                           
  
END.                                                           

CREATE DATASET odsResponse.
odsResponse:NAME = "response".
odsResponse:ADD-BUFFER (httResponseHeader:DEFAULT-BUFFER-HANDLE).
odsResponse:ADD-BUFFER (oQuery:BUFFER-HANDLE).


CATCH eApp AS Progress.Lang.AppError :
  JBoxServerSide:Instance:AddError(eApp:GetMessage(1)).
END CATCH.  
   
