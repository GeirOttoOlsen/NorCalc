/* Update SQL database

   Created: 07/08/24 by brynjar
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam      AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer     AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId  AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn     AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK         AS LOG NO-UNDO.

IF NOT SOURCE-PROCEDURE:FILE-NAME MATCHES "*JboxSqlQueryHelper*" AND NOT SOURCE-PROCEDURE:FILE-NAME MATCHES "*JboxSqlSchemaHelper*" THEN DO:
  {incl/validatecaller.i}
END.  

DEF VAR oConnector AS oo.JBoxDataSourceConnector NO-UNDO.

oConnector = JBoxDataSourceHelper:Instance:connectDataSource(ENTRY(1,icParam,"|")).
IF VALID-OBJECT(oConnector) AND oConnector:sourceConnected THEN DO:
  IF NOT oConnector:CallSql(ENTRY(2,icParam,"|"),icSessionId,ihBuffer) THEN
    ocReturn = oConnector:connectorMessage.  
//  IF NOT CAN-DO("ttSqlColumns,ttSqlPrimaryKey,ttMsSqlSchema",ihBuffer:NAME) THEN
  oConnector:closeConnection().
END.
ELSE IF VALID-OBJECT(oConnector) AND NOT oConnector:sourceConnected THEN
  ocReturn = "Failed to connect to datasource: " + ENTRY(1,icParam,"|") + " Error: " + JBoxDataSourceHelper:Instance:dataSourceMessage. 
ELSE ocReturn = "Failed to instantiate data source connector (oo.JBoxDataSourceConnector) for datasource: " + ENTRY(1,icParam,"|") + " Error: " + JBoxDataSourceHelper:Instance:dataSourceMessage.

FINALLY:
  IF ocReturn = "" THEN
    ocReturn = JBoxDataSourceHelper:Instance:dataSourceMessage.
  obOk = ocReturn = "".
END.