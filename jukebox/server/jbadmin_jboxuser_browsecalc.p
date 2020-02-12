/* In order to speed up processing of calculated fields it can be crucial
   to place the procedures in a single persistent procedure that is loaded
   once before processing the records.
   To invoke:
   
   DYNAMIC-FUNCTION("setAttribute",hBrowse,"calcfieldproc","orderline_browsecalc.p").
   
   Usage in browse (the name must not end on .p) :
   
   + ";+LineTotal|DECIMAL|->><>>><>>9.99|orderline_total|Total"
   
   (vs, when calling a .p each time - : 
   + ";+LineTotal|DECIMAL|->><>>><>>9.99|orderline_total.p|Total"
   )
------------------------------------------------------------------------*/     
DEF VAR hBuffJboxLoginSession AS HANDLE NO-UNDO.
DEF VAR hQryLoginSession      AS HANDLE NO-UNDO.

CREATE BUFFER hBuffJboxLoginSession FOR TABLE "JBoxLoginSession" NO-ERROR.
IF VALID-HANDLE(hBuffJboxLoginSession) THEN DO:
  CREATE QUERY hQryLoginSession.
  hQryLoginSession:SET-BUFFERS (hBuffJboxLoginSession).
END.


PROCEDURE DbAccess:
  DEF INPUT PARAM  irJBoxUser   AS ROWID NO-UNDO.
  DEF INPUT PARAM  icParam      AS CHAR  NO-UNDO.
  DEF INPUT PARAM  icSessionId  AS CHAR  NO-UNDO.
  DEF OUTPUT PARAM ocReturn     AS CHAR  NO-UNDO.

  DEF VAR hBuffer AS HANDLE NO-UNDO.
  DEF VAR bOk     AS LOG    NO-UNDO.

  FIND JBoxUser NO-LOCK
       WHERE ROWID(JBoxUser) = irJBoxUser
       NO-ERROR.
  IF AVAIL JBoxUser THEN DO:
    CREATE BUFFER hBuffer FOR TABLE icParam + "._user".
  
    bOk = hBuffer:FIND-FIRST("WHERE _userid = '" + JBoxUser.cJBoxUserId + "'") NO-ERROR.

    ocReturn = STRING(bOk).

    DELETE OBJECT hBuffer.
  END.

END PROCEDURE.

PROCEDURE LastActiveDate:
  DEF INPUT PARAM  irJBoxUser   AS ROWID NO-UNDO.
  DEF INPUT PARAM  icSessionId  AS CHAR  NO-UNDO.
  DEF OUTPUT PARAM ocReturn     AS CHAR  NO-UNDO.

  IF NOT VALID-HANDLE(hBuffJboxLoginSession) THEN RETURN.

  FIND JBoxUser NO-LOCK
       WHERE ROWID(JBoxUser) = irJBoxUser
       NO-ERROR.
  IF AVAIL JBoxUser THEN DO:
    hQryLoginSession:QUERY-PREPARE ("FOR EACH JBoxLoginSession NO-LOCK WHERE JBoxLoginSession.cJBoxUserId = '" + JBoxUser.cJBoxUserId + "' BY dCreated DESC").
    hQryLoginSession:QUERY-OPEN().
    hQryLoginSession:GET-FIRST().
    IF NOT hQryLoginSession:QUERY-OFF-END THEN
      ocReturn = STRING(YEAR(hBuffJboxLoginSession::dCreated)) + "-" + STRING(MONTH(hBuffJboxLoginSession::dCreated),"99") + "-" + STRING(DAY(hBuffJboxLoginSession::dCreated),"99") + " " + STRING(hBuffJboxLoginSession::iLoginTime,"HH:MM").
  END.

END PROCEDURE.

PROCEDURE CleanUp:
  IF VALID-HANDLE(hQryLoginSession) THEN DO:
    DELETE OBJECT hQryLoginSession.
    DELETE OBJECT hBuffJboxLoginSession. 
  END.  
END.  