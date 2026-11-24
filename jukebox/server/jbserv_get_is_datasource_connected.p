/* Check if datasource is connected

   Created: 05/07/23 by Brynjar
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icDataSourceName AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer         AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId      AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn         AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK             AS LOG NO-UNDO.

{incl/validatecaller.i}

obOk = JBoxDataSourceHelper:Instance:getIsDataSourceConnected(icDataSourceName).
