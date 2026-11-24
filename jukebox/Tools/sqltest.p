
/*------------------------------------------------------------------------
    File        : sqltest
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : meg
    Created     : Thu Dec 01 16:18:05 CET 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

CURRENT-WINDOW:WIDTH-CHARS = 200.
/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
SESSION:DATE-FORMAT = "dmy".
SESSION:NUMERIC-FORMAT = "European".

DEF TEMP-TABLE ttCustomer
    FIELD CustNum AS INT                                 
    FIELD Name    AS CHAR                                
    FIELD SalesRep AS CHAR                               
    FIELD RepName AS CHAR                               
    FIELD State    AS CHAR                               
//    FIELD CreditLimit AS DECIMAL FORMAT '->>>,>>>,>>9.99'
//    FIELD Category1 AS CHAR
//    FIELD Price AS DEC FORMAT '->>>,>>>,>>9.99'
    FIELD Qty AS DEC FORMAT '->>>,>>>,>>9.99'
//    FIELD Weight AS DEC FORMAT '->>>,>>>,>>9.99'
    FIELD jbCountDistinct AS INTEGER
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    FIELD RowIdent1 AS CHAR
    FIELD RowIdent2 AS CHAR
    .

DEF VAR oConnector AS oo.JBoxDataSourceConnector NO-UNDO.
MESSAGE 
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
oConnector = JBoxDataSourceHelper:Instance:connectDataSource("c:\prowrk\sports2000\Sports2002.json").

IF oConnector:sourceConnected THEN DO:
//  IF oConnector:fillTempTable("select salesrep, state, count(*) as jbCountDistinct, avg(CreditLimit) as jbAverage, sum(CreditLimit) as CreditLimit from pub.customer group by salesrep, state",BUFFER ttCustomer:HANDLE) THEN 
 // IF oConnector:fillTempTable("SELECT TOP 200 Order.ROWID AS RowIdent1,Salesrep.ROWID AS RowIdent2 FROM pub.Order JOIN pub.Salesrep ON Salesrep.salesrep = Order.salesrep ORDER BY Order.OrderStatus",BUFFER ttCustomer:HANDLE) THEN
// IF oConnector:fillTempTable('SELECT Item.Category1 AS RowIdent2,Item."Category1",sum(Item."Weight") AS Weight, count(*) as jbCountDistinct FROM PUB.Item JOIN PUB.orderline ON orderline."itemnum" = item."itemnum" WHERE ( Item."Weight" > 0 AND Item."Weight" < 25 ) AND Item."Itemnum" > 10 GROUP BY Item."Category1"',BUFFER ttCustomer:HANDLE) THEN
  IF oConnector:fillTempTable('SELECT CONCAT(TO_CHAR(Customer."Custnum"),Salesrep."RepName") AS RowIdent1,Customer."Custnum",Salesrep."RepName",sum(Orderline."Qty") AS Qty,avg(Orderline."Qty") AS jbAverage, count(*) as jbCountDistinct FROM PUB.Customer JOIN PUB.Order ON Order."Custnum" = Customer."custnum" JOIN PUB.Salesrep ON salesrep."salesrep" = Customer."salesrep" JOIN PUB.Orderline ON Orderline."ordernum" = Order."Ordernum" GROUP BY Customer."Custnum", Salesrep."RepName"',BUFFER ttCustomer:HANDLE) THEN 


 
    
    FOR EACH ttCustomer:
      DISP ttCustomer
           WITH WIDTH 200.
    END.
  ELSE MESSAGE oConnector:connectorMessage
       VIEW-AS ALERT-BOX.  
END.
ELSE IF JBoxDataSourceHelper:Instance:dataSourceMessage NE "" THEN
  MESSAGE JBoxDataSourceHelper:Instance:dataSourceMessage
          VIEW-AS ALERT-BOX.
ELSE IF oConnector:connectorMessage NE "" THEN
  MESSAGE oConnector:connectorMessage VIEW-AS ALERT-BOX. 
ELSE DO:
  MESSAGE oConnector:readCount
          oConnector:elapseMsec 
          VIEW-AS ALERT-BOX.
  oConnector:closeConnection().        
END.           
