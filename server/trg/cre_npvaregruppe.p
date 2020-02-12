TRIGGER PROCEDURE FOR CREATE OF NPVaregruppe.
 def var iId as int no-undo.
 def buffer buf for NPVaregruppe.
 
 for last buf by iNPVareGruppeId: leave. end.
 iId = if avail buf then buf.iNPVareGruppeid + 1 else 1.
 
 NPVaregruppe.iNPVareGruppeId = iId.
