
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
DEF VAR httResponseHeader  AS HANDLE NO-UNDO.
DEF VAR httResult          AS HANDLE NO-UNDO.
DEF VAR cError             AS CHAR   NO-UNDO.
DEF VAR oQuery             AS JBoxQuery NO-UNDO.
DEF VAR cFilter            AS CHAR   NO-UNDO.

DO ON ERROR UNDO, THROW:

  oQuery = NEW JBoxQuery().
  
    
  cBuffsAndFlds = ioCallParam:getResultFirstFieldValue("callparam","buffersAndFields").
  IF cBuffsAndFlds = ? THEN UNDO,THROW NEW Progress.Lang.AppError ("BuffersAndFields parameter missing",0).
          
  oQuery:buffersAndFields = ioCallParam:getResultFirstFieldValue("callparam","buffersAndFields").
  oQuery:queryJoin        = "," + TRIM(ioCallParam:getResultFirstFieldValue("callparam","queryJoin"),",").


  cFilter = ioCallParam:getResultFirstFieldValue("callparam","queryFilter").
  IF cFilter NE "" THEN 
    oQuery:setFilter(ENTRY(1,cFilter,";"), ENTRY(2,cFilter,";"), ENTRY(3,cFilter,";")).

  oQuery:setQuerySort(ioCallParam:getResultFirstFieldValue("callparam","querySort")).
          
  bRecordCount = LOGICAL(ioCallParam:getResultFirstFieldValue("callparam","getRecordCount")) NO-ERROR.
//  IF bRecordCount NE ? THEN oQuery:getRecordCount = bRecordCount.
  
 
  cStatFields = TRIM("elapseTime," + (IF bRecordCount THEN "rowcount," ELSE "") + ioCallParam:getResultFirstFieldValue("callparam","queryStatFields"),",").
  oQuery:queryStatFields = cStatFields.

    
  cStartRow = ioCallParam:getResultFirstFieldValue("callparam","startRow").
  IF cStartRow NE "" AND INT(cStartRow) NE 0 THEN iStartRow = INT(cStartRow).
  oQuery:setJBoxAttribute("SmartComponentLibrary_QueryStart",STRING(iStartRow - 1)).  
  
  cBatchSize = ioCallParam:getResultFirstFieldValue("callparam","batchSize").
  IF cBatchSize NE "" AND INT(cBatchSize) NE 0 THEN iBatchSize = INT(cBatchSize).
  oQuery:rowsToBatch = iBatchSize.                                        
  
  DYNAMIC-FUNCTION("setQueryLogFile",ioCallParam:getResultFirstFieldValue("callparam","queryLogFile")).
  
  oQuery:openQuery().  

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
//odsResponse:ADD-BUFFER (httResult:DEFAULT-BUFFER-HANDLE).
odsResponse:ADD-BUFFER (oQuery:BUFFER-HANDLE).


CATCH eApp AS Progress.Lang.AppError :
  JBoxServerSide:Instance:AddError(eApp:GetMessage(1)).
END CATCH.  
   
