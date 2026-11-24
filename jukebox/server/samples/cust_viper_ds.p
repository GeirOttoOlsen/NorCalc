/* Create a Viper report

   Created: 01/02/22 by meg

   Samples for running the report:

     DEF VAR obOk         AS LOG  NO-UNDO.
     DEF VAR ocReturn     AS CHAR NO-UNDO.
     DEF VAR cTmpPdfFile  AS CHAR NO-UNDO.

     DEF TEMP-TABLE ttReportPdf NO-UNDO
         FIELD PdfBlob AS BLOB
         .

     /* Preview report (no pdf):
     RUN cust_viper_ds.p ("<some parameter>|preview",?,"",OUTPUT ocReturn, OUTPUT obOk).
     */

     /* Preview pdf:
     RUN cust_viper_ds.p ("<some parameter>|previewPdf",?,"",OUTPUT ocReturn, OUTPUT obOk).
     */

     /* Retrieve pdf from appserver
     IF JBoxServerAPI:Instance:CallServerProc(cust_viper_ds.p, icParameter, BUFFER ttReportPdf:HANDLE) THEN DO:
       FIND FIRST ttReportPdf NO-ERROR.
       IF AVAIL ttReportPdf THEN DO:
         cTmpPdfFile = SESSION:TEMP-DIR + STRING(TIME) + ".pdf".
         COPY-LOB ttReportPdf.PdfBlob TO FILE cTmpPdfFile.
         JBoxFunctions:Instance:ViewFile(cTmpPdfFile)
       END.
     END.
     */

     /* get tt-definition for field group in designer:
     RUN cust_viper_ds.p ("getGrpTT|<group name>",?,"",OUTPUT ocReturn, OUTPUT obOk).
     CLIPBOARD:VALUE = ocReturn.
     */

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEFINE TEMP-TABLE vpCustomer
    FIELD Name AS CHARACTER LABEL 'Name'
    FIELD CustNum AS INTEGER LABEL 'Cust Num'
    FIELD Address AS CHARACTER LABEL 'Address'
    FIELD SalesRep AS CHARACTER LABEL 'Sales Rep'
    FIELD RepName AS CHARACTER LABEL 'Rep Name'
.

DEF VAR hvpCustomer AS HANDLE NO-UNDO.
hvpCustomer = BUFFER vpCustomer:HANDLE.

DEFINE TEMP-TABLE vpOrder
    FIELD Ordernum AS INTEGER LABEL 'Order Num'
    FIELD OrderDate AS DATE LABEL 'Ordered'
    FIELD ShipDate AS DATE LABEL 'Shipped'
    FIELD OrderStatus AS CHARACTER LABEL 'Order Status'
.

DEF VAR hvpOrder AS HANDLE NO-UNDO.
hvpOrder = BUFFER vpOrder:HANDLE.

DEFINE TEMP-TABLE vpOrderLine
    FIELD Linenum AS INTEGER LABEL 'Pos'
    FIELD Itemnum AS INTEGER LABEL 'Item'
    FIELD ItemName AS CHARACTER LABEL 'Item Name'
    FIELD OrderPrice AS DECIMAL LABEL 'Price'
    FIELD Qty AS INTEGER LABEL 'Qty'
    FIELD LineTotal AS DECIMAL LABEL 'Total'
    FIELD OrderNum AS INT
.

DEF VAR hvpOrderLine AS HANDLE NO-UNDO.
hvpOrderLine = BUFFER vpOrderLine:HANDLE.

DEFINE DATASET dsViperCustomer FOR vpCustomer, vpOrder, vpOrderLine.

DEF VAR hdsViperCustomer AS HANDLE NO-UNDO.
hdsViperCustomer = DATASET dsViperCustomer:HANDLE.

FIND FIRST Customer NO-LOCK 
     WHERE Customer.CustNum = INT(icParam)
     NO-ERROR.
IF AVAIL Customer THEN DO:
  CREATE vpCustomer.
  BUFFER-COPY Customer TO vpCustomer.
  FIND FIRST SalesRep NO-LOCK
       OF Customer NO-ERROR.
  IF AVAIL Salesrep THEN
    vpCustomer.RepName = Salesrep.RepName.
  
  FOR EACH Order NO-LOCK 
      OF Customer:
    CREATE vpOrder.
    BUFFER-COPY Order TO vpOrder.
    
    FOR EACH OrderLine NO-LOCK
        OF Order
       ,FIRST Item NO-LOCK OF OrderLine:
      CREATE vpOrderLine.
      BUFFER-COPY OrderLine TO vpOrderLine.
      ASSIGN vpOrderLine.LineTotal = OrderLine.Price * OrderLine.Qty
             vpOrderLine.ItemName  = Item.ItemName
             .
    END.
      
  END.            
END.       

FINALLY:
  obOk = ocReturn = "".
  IF obOk THEN
    ihBuffer:COPY-DATASET (hDsViperCustomer).
END FINALLY.

