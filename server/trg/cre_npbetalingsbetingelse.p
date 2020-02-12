TRIGGER PROCEDURE FOR CREATE OF NPBetalingsBetingelse.
 def var iId as int no-undo.
 def buffer buf for NPBetalingsBetingelse.
 
 for last buf by iNPBetalingsBetingelseId: leave. end.
 iId = if avail buf then buf.iNPBetalingsBetingelseid + 1 else 1.
 
 NPBetalingsBetingelse.iNPBetalingsBetingelseId = iId.
