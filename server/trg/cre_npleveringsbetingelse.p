TRIGGER PROCEDURE FOR CREATE OF NPLeveringsbetingelse.
 def var iId as int no-undo.
 def buffer buf for NPLeveringsbetingelse.
 
 for last buf by iNPLeveringsbetingelseId: leave. end.
 iId = if avail buf then buf.iNPLeveringsbetingelseid + 1 else 1.
 
 NPLeveringsbetingelse.iNPLeveringsbetingelseId = iId.
