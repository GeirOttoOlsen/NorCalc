/*********************************************************************
File:           password.p
Description:    Password security. This is for testing the 
                Report Builder utility _rbpwenc.p which encodes the
                given password.
                Running Report Engine from an application - TABLE INTERFACE.
                
                You must be connected to a database containing the RBREPORT 
                table in multi-user mode before running this procedure. 
**********************************************************************/
DEF VAR encodepw AS CHARACTER.

DO TRANSACTION:
 
  CREATE RBREPORT.

  ASSIGN 
    RBREPORT.RB-REPORT-LIBRARY = "rbsample.prl"
    RBREPORT.RB-REPORT-NAME = "Customer Discount"
    RBREPORT.RB-PRINT-DESTINATION = "D".
        
  RELEASE RBREPORT.  

END.

RUN aderb/_rbpwenc.p ("password", OUTPUT encodepw).

RUN aderb/_prore.p (FALSE, "-db sample.db -S demosv1 -H localhost -N tcp -rbdel -U username -rbP " 
+ encodepw ).

