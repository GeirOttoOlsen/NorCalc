DEF TEMP-TABLE ttCustomer NO-UNDO
    FIELD Custnum AS INT
    FIELD NAME AS CHAR
    FIELD Salesrep AS CHAR
    FIELD ordernum AS INT
    FIELD Salesrep2 AS CHAR
    FIELD Repname AS CHAR
    FIELD RowIdent1 AS CHAR
    FIELD RowIdent2 AS CHAR
    FIELD RowIdent3 AS CHAR
    FIELD RowCount AS INT
    .
    
DEF VAR hbttCustomer AS HANDLE NO-UNDO.
hbttCustomer = BUFFER ttCustomer:HANDLE.

DEF VAR oSqlHelper AS oo.JBoxSqlQueryHelper NO-UNDO.

FUNCTION LogThis RETURNS LOGICAL (INPUT icLabel AS CHAR, INPUT icText AS CHAR, INPUT iiSkip AS INT):
  MESSAGE icLabel SKIP icText
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END FUNCTION.

oSqlHelper = NEW oo.JBoxSqlQueryHelper().

oSqlHelper:hSourceProc = THIS-PROCEDURE.

oSqlHelper:SQLdb = "C:\Prowrk\Sports2000\pas\openedge\sportsSql.json".

oSqlHelper:SQLqueryDirection = "".   // ulik blank: gå fra bunnen
oSqlHelper:SQLstartRow       = 0.    // irrelevant
oSqlHelper:SQLrowsToBatch    = 20.

oSqlHelper:ABLbuffersAndFields = "customer;custnum;name;salesrep,order;ordernum;salesrep,salesrep;repname".
oSqlHelper:ABLqueryJoin = "EACH Order WHERE Order.Custnum = Customer.custnum,first salesrep where salesrep.salesrep = order.salesrep".
oSqlHelper:ABLqueryWhere = "WHERE name BEGINS 'o'".
oSqlHelper:ABLquerySort = "customer.custnum".
oSqlHelper:createSqlView().

MESSAGE oSqlHelper:sqlview
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
oSqlHelper:fillTempTable(BUFFER ttCustomer:HANDLE).

RUN toexcelviafile.p (hbttCustomer,-2).

FOR EACH ttCustomer:
  DISP custnum NAME ordernum salesrep repname.
END.

//oSqlHelper:SQLgroupBy = "salesrep".  // komma-sep liste
//oSqlHelper:SQLsumFields = cSqlSumFields

/*
oSqlHelper:SQLprimaryTable = "customer".

MESSAGE oSqlHelper:getReadCount()
    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
*/    
