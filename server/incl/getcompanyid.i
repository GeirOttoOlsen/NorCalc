DEF VAR iCompanyId AS INT  NO-UNDO INIT 1.
DEF VAR cUserId    AS CHAR NO-UNDO INIT "bha".

IF icSessionId NE "validsession" THEN DO:
  FIND FIRST JBoxLoginSession
       WHERE JBoxLoginSession.cSessionId = icSessionId
       NO-LOCK NO-ERROR.
  IF AVAIL JBoxLoginSession THEN
    ASSIGN iCompanyId = JBoxLoginSession.iJBoxCompanyId
           cUserId    = JBoxLoginSession.cJBoxUserId.
  ELSE DO:
    ocReturn = "Invalid session id".
    RETURN.
  END.
END.



