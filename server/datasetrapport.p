/* Process a set of records sent from the client

   Created: 11/02/24 by goo

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihDataset   AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

def var oParam as oo.parameter no-undo.

def var ReportName as char no-undo.
def var callProcedure as handle no-undo.

oParam = new oo.parameter().
oParam:addParameters(icParam).
assign 
  obOk       = true
  ReportName = oParam:getParameter('ReportName')
  .
if lookup(reportname,this-procedure:INTERNAL-ENTRIES) = 0 then 
  undo, throw new Progress.Lang.AppError(substitute('Fant ikke rapport: &1',ReportName),0).

//{incl/validatecaller.i}

create call callProcedure.
callProcedure:call-name = ReportName.
callProcedure:invoke.

CATCH eAny AS Progress.Lang.Error :
  assign 
    ocReturn = eAny:GetMessage(1)
    obOk     = false
    .  
END CATCH.

procedure NorProsjekt01:
  def var ProsjektId as int no-undo.
  def var bhProsjekt as handle no-undo.
  def var bhAnlegg   as handle no-undo.
  def var bhKunde   as handle no-undo.
  def var bhKundedistrikt   as handle no-undo.
  def var bhTilbud   as handle no-undo.
   
  ProsjektId = int(oParam:getParameter('ProsjektId')).
  if ihDataset:num-buffers <> 5 then 
    undo, throw new Progress.Lang.AppError(substitute('Feil antall buffer, skal være &1',2),0).

  if not valid-handle(ihDataset:get-buffer-handle('norprosjekt')) then  
    undo, throw new Progress.Lang.AppError(substitute('Finner ikke buffer &1 i datasett','norprosjekt'),0).

  if not valid-handle(ihDataset:get-buffer-handle('npshanlg')) then  
    undo, throw new Progress.Lang.AppError(substitute('Finner ikke buffer &1 i datasett','npshanlg'),0).
  
  assign 
    bhProsjekt      = ihDataset:get-buffer-handle('norprosjekt')
    bhAnlegg        = ihDataset:get-buffer-handle('npshanlg')
    bhKunde         = ihDataset:get-buffer-handle('npkunde')
    bhKundedistrikt = ihDataset:get-buffer-handle('npkundedistrikt')
    bhTilbud        = ihDataset:get-buffer-handle('npshtilbud')
    .    
  for each norprosjekt no-lock where NORPROSJEKT.prosjektid = ProsjektId
     ,each NPSHANLG no-lock where NPSHANLG.prosjektid = NORPROSJEKT.prosjektid
     ,first npkunde no-lock where npkunde.kundenr = npshanlg.kundenr
     ,first npkundedistrikt no-lock where NPkundedistrikt.kundedistriktnr = NPSHANLG.kundedistriktNr
     ,each npshtilbud no-lock where NPSHTILBUD.anleggsnr = NPSHANLG.anleggsnr:
    bhProsjekt:find-first(substitute('where prosjektid = &1',ProsjektId)) no-error.
    if not bhProsjekt:avail then do: 
      bhProsjekt:buffer-create().
      bhProsjekt:buffer-copy(buffer norprosjekt:handle).
    end.
    bhAnlegg:find-first(substitute('where prosjektid = &1',ProsjektId)) no-error.
    if not bhAnlegg:avail then do: 
      bhAnlegg:buffer-create().
      bhAnlegg:buffer-copy(buffer npshanlg:handle).
    end.    
    bhKunde:find-first(substitute('where kundenr = &1',npkunde.kundenr)) no-error.    
    if not bhKunde:avail then do: 
      bhKunde:buffer-create().
      bhKunde:buffer-copy(buffer npkunde:handle).
    end.    
    bhKundedistrikt:find-first(substitute('where kundedistriktnr = &1',npkundedistrikt.kundedistriktnr)) no-error.    
    if not bhKundedistrikt:avail then do: 
      bhKundedistrikt:buffer-create().
      bhKundedistrikt:buffer-copy(buffer NPkundedistrikt:handle).
    end.  
    bhTilbud:find-first(substitute('where id = &1',npshtilbud.id)) no-error.
    if not bhTilbud:avail then do: 
      bhTilbud:buffer-create().
      bhTilbud:buffer-copy(buffer NPSHTILBUD:handle).
    end.    
  end.       
     
  
end procedure.

FINALLY:
  delete object callProcedure.
END FINALLY.

