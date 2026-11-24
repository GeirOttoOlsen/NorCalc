DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR bOk             AS LOG    NO-UNDO.
DEF VAR cUserId         AS CHAR   NO-UNDO.
DEF VAR hPwdInterval    AS HANDLE NO-UNDO.
DEF VAR hLastPwdChange  AS HANDLE NO-UNDO.
DEF VAR dPwdChanged     AS DATE   NO-UNDO.
DEF VAR hBuffJBoxUser   AS HANDLE NO-UNDO.
DEF VAR hChangePwd      AS HANDLE NO-UNDO.
DEF VAR hb_user         AS HANDLE NO-UNDO.

{incl/validatecaller.i}

cUserId = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE).

CREATE BUFFER hb_user FOR TABLE "_user".

IF NOT VALID-HANDLE(hb_user) THEN RETURN.

bOk = hb_user:FIND-FIRST("WHERE _userid = '" + cUserId + "'",NO-LOCK) NO-ERROR.

IF NOT bOk THEN RETURN.

IF ENCODE(cUserId) = hb_user::_Password THEN DO:
  ocReturn = "yes|".  
  RETURN.
END. 

IF NOT JBoxServerSide:Instance:getTableBuffer("JboxUser",OUTPUT hBuffJBoxUser) THEN RETURN.

ASSIGN hPwdInterval   = hBuffJBoxUser:BUFFER-FIELD("iPwdInterval") 
       hLastPwdChange = hBuffJBoxUser:BUFFER-FIELD("dLastPwdChange")
       hChangePwd     = hBuffJBoxUser:BUFFER-FIELD("bChangePwd")
       NO-ERROR.

IF VALID-HANDLE(hPwdInterval) AND VALID-HANDLE(hLastPwdChange) THEN DO:
  bOk = hBuffJBoxUser:FIND-FIRST("WHERE JBoxUser.cJBoxUserId = '" + cUserId + "'"
                                ,NO-LOCK) NO-ERROR.
  IF bOk THEN DO:
    
    IF VALID-HANDLE(hChangePwd) AND hChangePwd:BUFFER-VALUE = YES THEN DO:
      ocReturn = "yes|".  
      RETURN.
    END. 
    
    IF hPwdInterval:BUFFER-VALUE > 0 THEN DO:
      dPwdChanged = IF hLastPwdChange:BUFFER-VALUE NE ? THEN hLastPwdChange:BUFFER-VALUE ELSE hBuffJBoxUser:BUFFER-FIELD("dCreated"):BUFFER-VALUE.
      IF dPwdChanged = ? THEN DO:
        hBuffJBoxUser:FIND-CURRENT(EXCLUSIVE-LOCK,NO-WAIT) NO-ERROR.
        IF hBuffJBoxUser:AVAIL THEN
          hLastPwdChange:BUFFER-VALUE = TODAY.
      END.
      ELSE DO:
        IF TODAY - hPwdInterval:BUFFER-VALUE GT dPwdChanged THEN
          ocReturn = "yes|".
        ELSE IF TODAY - hPwdInterval:BUFFER-VALUE GT dPwdChanged - 10 THEN
          ocReturn = "yes|" + STRING(ABS(TODAY - dPwdChanged - hPwdInterval:BUFFER-VALUE)).
      END.
    END.
  END.
END.

CATCH eErr AS Progress.Lang.Error :
  ocReturn = eErr:getMessage(1).  
END CATCH.

FINALLY:
  DELETE OBJECT hBuffJBoxUser NO-ERROR.
  DELETE OBJECT hb_user NO-ERROR.
  
  obOk = ENTRY(1,ocReturn,"|") = "yes".
END FINALLY.  