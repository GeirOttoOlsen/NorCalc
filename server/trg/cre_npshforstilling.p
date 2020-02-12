TRIGGER PROCEDURE FOR CREATE OF NPSHForstilling.
 def var iId as int no-undo.
 def buffer buf for NPSHForstilling.
 
 for last buf by id: leave. end.
 iId = if avail buf then buf.id + 1 else 1.
 
 NPSHForstilling.Id = iId.
