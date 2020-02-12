/* Create Customer
   Parameters:  New buffer
                Fields (comma-separated)
                Values (pipe-separated)
   
   Created: 06.10.05 by Brynjar Hasle                  

   To invoke: DYNAMIC-FUNCTION("setAttribute",hFieldMap | hBrowse,"customCreateProc","<procname>").
   
   In this procedure use the getValue function to get to values passed from the client rather
   than looking up icValues parameter to avoid planned change in use of delimiter

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM hBuffer     AS HANDLE NO-UNDO.
DEF INPUT  PARAM icFields    AS CHAR NO-UNDO.
DEF INPUT  PARAM icValues    AS CHAR NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO. 

/*def var iFieldNum as int no-undo.                */
/*def var ipKundeId as int no-undo.                */
/*                                                 */
/*assign                                           */
/*  iFieldNum = lookup('iKundeId',icFields)        */
/*  ipKundeId  = int(entry(iFieldNum,icValues,'|'))*/
/*.                                                */

DO ON ERROR UNDO, RETURN:
  ASSIGN 
    hBuffer:BUFFER-FIELD("iKundekontaktId"):BUFFER-VALUE= next-value(seqNPFellesId).
  .
END.

