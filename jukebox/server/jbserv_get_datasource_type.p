/* Fetch type based on data source name

   Created: 05/12/22 by Brynjar
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEF VAR cDsName         AS CHAR NO-UNDO.
DEF VAR cDsType         AS CHAR NO-UNDO.
DEF VAR cConnectParams  AS CHAR NO-UNDO.

IF NUM-ENTRIES(icParam,CHR(1)) > 1 THEN DO:
  ASSIGN cDsName        = ENTRY(1,icParam,CHR(1))
         cConnectParams = ENTRY(2,icParam,CHR(1)). /* Content of datasource connection file */
  cDsType = JBoxDataSourceHelper:Instance:getDataSourceType(cDsName,cConnectParams)
          + "|" + JBoxDataSourceHelper:Instance:getDbName(cDsName).
END.  
ELSE // Assumes connection is established:
  ASSIGN cDsName = icParam
         cDsType = JBoxDataSourceHelper:Instance:getDataSourceType(cDsName)
                 + "|" + JBoxDataSourceHelper:Instance:getDbName(cDsName).

FINALLY:
  ocReturn = JBoxDataSourceHelper:Instance:dataSourceMessage.
  obOk = ocReturn = "".
  IF obOk THEN ocReturn = cDsType.
END FINALLY.

