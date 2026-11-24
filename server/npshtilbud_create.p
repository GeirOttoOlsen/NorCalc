/* Create Customer
   Parameters:  New customer buffer

   Created: 13/12/20 by goo_000

   To invoke: [fieldMapObject | browseObject]:customCreateProc = "<procname>".

   In this procedure use the getValue function to get to values passed from the client.


tilbudsid er et løpenr innen tilbudet, mens id er sekvens for alle npshtilbud.
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.

DEF VAR NesteTilbudsid AS INT NO-UNDO INIT 1.
def var NesteTilbudssekvens as int no-undo.
def buffer bNPSHtilbud for npshtilbud.

DO transaction ON ERROR UNDO, RETURN:
  FIND NPSEKVENS WHERE tabell_navn = 'NPSHtilbud' EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
  IF AVAILABLE NPSEKVENS THEN 
    assign 
      NesteTilbudssekvens = NPSEKVENS.sist_brukt + 1
      NPSEKVENS.sist_brukt = NesteTilbudssekvens
      .
  
  else undo, throw new Progress.Lang.AppError('Sekvens for npshtilbud ble ikke funnet',1).

  for each bNPSHTILBUD no-lock WHERE bNPSHTILBUD.anleggsnr = ihBuffer::anleggsnr by anleggsnr  by tilbudsid desc: 
    leave.
  end.
  /* Dersom det er gitt tilbud på dette anlegget tidligere - øk teller */
  assign 
    NesteTilbudsid = IF AVAILABLE(bNPSHTILBUD) then bNPSHTILBUD.tilbudsid + 1 else 1
    ihBuffer::tilbudsid = NesteTilbudsid
    ihBuffer::id = NesteTilbudssekvens
  .
END.
