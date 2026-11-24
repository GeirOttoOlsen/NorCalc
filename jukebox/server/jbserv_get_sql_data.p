/* Hent data fra SQL base
   Connect-parametere og view-definisjoner hentes fra SysParameter 
   Parametere: 
     | Navn på parametertype for database: SQLVisma, SQLConsent,..
     | Navn på view 
     | WHERE-sats 

   Eksempel på kall (fra adhoc\sqlTest.w):
     
    IF NOT JBoxServerAPI:Instance:CallServerProc("get_sql_table.p",
                                                 "SQLVisma|Betalinger|WHERE CustomerNo = " + VGkundenr:SCREEN-VALUE
                                              + (IF INT(VGfakturanr:SCREEN-VALUE) NE 0 THEN " AND VoucherNo = " + VGfakturanr:SCREEN-VALUE ELSE "")
                                                ,BUFFER ttSql:HANDLE) THEN
      JBoxServerAPI:Instance:viewCallMessage().

   Her fylles kolonner i ttSQL automatisk fra view-definisjonen. "Lokale" kolonner som ikke skal fylles fra SQL
   legges etter RowCount og RowIdent1

   Created: 19/02/19 by brynj
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam      AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer     AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId  AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn     AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK         AS LOG NO-UNDO.

IF NOT SOURCE-PROCEDURE:FILE-NAME MATCHES "*JboxSqlQueryHelper*" AND NOT SOURCE-PROCEDURE:FILE-NAME MATCHES "*JboxSqlSchemaHelper*" THEN DO:
  {incl/validatecaller.i}
END.  

DEF VAR iReadCount       AS INT  NO-UNDO.
DEF VAR oConnector AS oo.JBoxDataSourceConnector NO-UNDO.

oConnector = JBoxDataSourceHelper:Instance:connectDataSource(ENTRY(1,icParam,"|")).
IF VALID-OBJECT(oConnector) AND oConnector:sourceConnected THEN DO:
  IF VALID-HANDLE(ihBuffer) THEN DO:
    IF oConnector:fillTempTable(icParam,icSessionId,ihBuffer) THEN
      iReadCount = oConnector:ReadCount.
    ELSE
      ocReturn = oConnector:connectorMessage.  
  END.    
//  IF NOT CAN-DO("ttSqlColumns,ttSqlPrimaryKey,ttMsSqlSchema",ihBuffer:NAME) THEN
    oConnector:closeConnection().
END.
ELSE IF VALID-OBJECT(oConnector) AND NOT oConnector:sourceConnected THEN
  ocReturn = "Failed to connect to datasource: " + ENTRY(1,icParam,"|") + " Error: " + JBoxDataSourceHelper:Instance:dataSourceMessage. 
ELSE ocReturn = "Failed to instantiate data source connector (oo.JBoxDataSourceConnector) for datasource: " + ENTRY(1,icParam,"|") + " Error: " + JBoxDataSourceHelper:Instance:dataSourceMessage.

CATCH eErr AS Progress.Lang.Error :
  ocReturn = eErr:getMessage(1).
END CATCH.

FINALLY:
  IF ocReturn = "" THEN
    ocReturn = JBoxDataSourceHelper:Instance:dataSourceMessage.
  obOk = ocReturn = "".
  IF obOk THEN ocReturn = STRING(iReadCount).
END.