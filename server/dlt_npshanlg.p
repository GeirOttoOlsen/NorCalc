/* To invoke: 
   DYNAMIC-FUNCTION("setAttribute",hFieldMap,"CustomDeleteValProc","=delete_validation.p").
   Procedure name must be prefixed by = or +
   =:   Dynamic validation is suppressed
   +:   The validation proc is run in addition to dynamic validation
   
   If there's no fieldmap (viewer) set the attribute on the browse or query object
-----------------------------------------------------------------------------------------*/   
DEF INPUT  PARAM icBufferName        AS CHAR NO-UNDO.
DEF INPUT  PARAM icRowid             AS CHAR NO-UNDO.
DEF INPUT  PARAM icSessionId         AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn            AS CHAR NO-UNDO.  

FIND npshanlg WHERE ROWID(npshanlg) = TO-ROWID(icRowId) EXCLUSIVE-LOCK NO-ERROR.
IF AVAIL npshanlg THEN do:
  MESSAGE 'dlt_npshanlg må endres... skal anlegg slettes?'
  VIEW-AS ALERT-BOX.
end.
ocReturn = 'Må oppdateres før denne kan kjøres...'
  


