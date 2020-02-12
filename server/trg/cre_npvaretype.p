TRIGGER PROCEDURE FOR CREATE OF NPVareType.
 def var iId as int no-undo.
 def buffer buf for NPVareType.
 
 for last buf by iNPVareTypeId: leave. end.
 iId = if avail buf then buf.iNPVareTypeid + 1 else 1.
 
 NPVareType.iNPVareTypeId = iId.
