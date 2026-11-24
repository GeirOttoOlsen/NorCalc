/* Session validation */
DEF INPUT  PARAM icSessionId     AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocReturn        AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocCurrUserId    AS CHAR   NO-UNDO.
DEF OUTPUT PARAM oiCurrCompanyId AS INT    NO-UNDO.
DEF OUTPUT PARAM ocCurrLanguage  AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocContext       AS CHAR   NO-UNDO.

IF SESSION:CLIENT-TYPE = "WEBCLIENT" THEN RETURN.

DEF VAR hJBoxLoginSession AS HANDLE NO-UNDO.
DEF VAR bJbLsFound        AS LOG    NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxLoginSession",OUTPUT hJBoxLoginSession) THEN DO:
  ocCurrUserId = USERID(LDBNAME(1)).
  RETURN.
END.  

bJbLsFound = hJBoxLoginSession:FIND-FIRST("WHERE JBoxLoginSession.cSessionId = '" + icSessionId + "'",NO-LOCK) NO-ERROR.
IF bJbLsFound AND icSessionId NE "" THEN
  ASSIGN SESSION:DATE-FORMAT    = hJBoxLoginSession:BUFFER-FIELD("cDateFormat"):BUFFER-VALUE
         SESSION:NUMERIC-FORMAT = hJBoxLoginSession:BUFFER-FIELD("cNumFormat"):BUFFER-VALUE
         ocCurrUserId           = hJBoxLoginSession:BUFFER-FIELD("cJBoxUserId"):BUFFER-VALUE
         oiCurrCompanyId        = hJBoxLoginSession:BUFFER-FIELD("iJBoxCompanyID"):BUFFER-VALUE
         ocCurrLanguage         = hJBoxLoginSession:BUFFER-FIELD("cLanguage"):BUFFER-VALUE
         ocContext              = hJBoxLoginSession:BUFFER-FIELD("cContext"):BUFFER-VALUE
         .
ELSE IF (SESSION:CLIENT-TYPE = "4GLCLIENT" AND NUM-DBS > 0) THEN 
  ocCurrUserId = USERID(LDBNAME(1)).
ELSE 
  ocReturn = "Invalid session. Either expired or reset due to system upgrade. Try new login".
         
FINALLY:         
  DELETE OBJECT hJBoxLoginSession NO-ERROR.
END FINALLY.
