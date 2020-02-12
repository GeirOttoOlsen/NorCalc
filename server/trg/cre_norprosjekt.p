TRIGGER PROCEDURE FOR CREATE OF NORPROSJEKT.
 def var iId as int no-undo.
 def buffer buf for norprosjekt.
 
 for last buf by prosjektid: leave. end.
 iId = if avail buf then buf.prosjektid + 1 else 1.
 
 norprosjekt.prosjektid = iId.
