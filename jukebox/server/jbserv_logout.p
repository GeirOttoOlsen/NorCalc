DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i} 

DEF VAR hLogoutTime AS HANDLE NO-UNDO.
DEF VAR hbJBoxLoginSession AS HANDLE NO-UNDO.
DEF VAR bFound AS LOG NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxLoginSession",OUTPUT hbJBoxLoginSession) THEN RETURN.

bFound = hbJBoxLoginSession:FIND-FIRST("WHERE JBoxLoginSession.cSessionId = '" + icSessionId + "'", EXCLUSIVE-LOCK, NO-WAIT) NO-ERROR.
IF bFound THEN DO:
  hLogoutTime = hbJBoxLoginSession:HANDLE:BUFFER-FIELD("iLogoutTime") NO-ERROR.
  IF VALID-HANDLE(hLogoutTime) THEN
    hLogoutTime:BUFFER-VALUE = TIME.
END.

FINALLY:
  DELETE OBJECT hbJBoxLoginSession NO-ERROR.
END FINALLY.