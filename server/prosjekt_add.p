/* Create Customer
   Parameters:  New customer buffer

   Created: 09/10/23 by goo

   To invoke: [fieldMapObject | browseObject]:customCreateProc = "<procname>".

   In this procedure use the getValue function to get to values passed from the client.

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.

define var ip_neste_id as integer.

DO transaction ON ERROR UNDO, RETURN:
  FIND NPSEKVENS WHERE tabell_navn = 'Prosjekt' EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
  IF AVAILABLE NPSEKVENS THEN DO:
     assign 
       ip_neste_id            = NPSEKVENS.sist_brukt + 1
       NPSEKVENS.sist_brukt   = ip_neste_id
       ihBuffer::prosjektid   = ip_neste_id
       .
    END.
    RETURN.
END.

