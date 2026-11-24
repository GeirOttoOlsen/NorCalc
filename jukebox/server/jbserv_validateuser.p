DEF INPUT PARAM icUserId     AS CHAR NO-UNDO.
DEF INPUT PARAM icPwd        AS CHAR NO-UNDO.
DEF INPUT PARAM icDateFormat AS CHAR NO-UNDO.
DEF INPUT PARAM icNumFormat  AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocUserName  AS CHAR NO-UNDO.
DEF OUTPUT PARAM oiCompanyId AS INT NO-UNDO.
DEF OUTPUT PARAM obOk        AS LOG NO-UNDO.

DEF VAR ix                  AS INT    NO-UNDO.
DEF VAR hLoginTime          AS HANDLE NO-UNDO.
DEF VAR hLogoutTime         AS HANDLE NO-UNDO.
DEF VAR hActive             AS HANDLE NO-UNDO.
DEF VAR hbJBoxLoginSession  AS HANDLE NO-UNDO.
DEF VAR hbJBoxLoginSessUpd  AS HANDLE NO-UNDO.
DEF VAR hbJBoxUser          AS HANDLE NO-UNDO.
DEF VAR hbJBoxCompanyUser   AS HANDLE NO-UNDO.
DEF VAR hbJBoxCompany       AS HANDLE NO-UNDO.
DEF VAR hqCompUser          AS HANDLE NO-UNDO.
DEF VAR hqComp              AS HANDLE NO-UNDO.
DEF VAR hqLogin             AS HANDLE NO-UNDO.
DEF VAR bFound              AS LOG    NO-UNDO.

//DEF BUFFER bJBoxLoginSession FOR JBoxLoginSession.

IF icPwd NE CHR(3) THEN
  obOk = SETUSERID(icUserId,icPwd,LDBNAME(1)). 
ELSE obOk = YES.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUser",OUTPUT hbJBoxUser) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxLoginSession",OUTPUT hbJBoxLoginSession) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxLoginSession",OUTPUT hbJBoxLoginSessUpd) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompanyUser",OUTPUT hbJBoxCompanyUser) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompany",OUTPUT hbJBoxCompany) THEN RETURN.

IF obOk THEN DO:
  bFound = hbJBoxUser:FIND-FIRST("WHERE JBoxUser.cJBoxUserId = '" + icUserId + "'",NO-LOCK) NO-ERROR.
  IF bFound THEN DO:

    hActive = hbJBoxUser:BUFFER-FIELD("bActive") NO-ERROR.
    IF VALID-HANDLE(hActive) AND NOT hActive:BUFFER-VALUE THEN DO:
      obOk = NO.
      RETURN.
    END.

    IF NOT hbJBoxUser::bSuperUser AND VALID-HANDLE(hbJBoxCompanyUser) THEN DO:
      CREATE QUERY hqCompUser.
      hqCompUser:SET-BUFFERS(hbJBoxCompanyUser).
      hqCompUser:QUERY-PREPARE ("FOR EACH JBoxCompanyUser NO-LOCK WHERE JBoxCompanyUser.cJBoxUserId = '" 
                              + icUserId + "' BY JBoxCompanyUser.bSuperUserCompany DESC").
      hqCompUser:QUERY-OPEN ().
      IF hqCompUser:GET-FIRST() THEN                         
        oiCompanyId = hbJBoxCompanyUser::iJBoxCompanyId.
    END.
    ELSE IF VALID-HANDLE(hbJBoxCompany) THEN DO:
      CREATE QUERY hqComp.
      hqComp:SET-BUFFERS(hbJBoxCompany).
      hqComp:QUERY-PREPARE("FOR EACH JBoxCompany NO-LOCK").
      hqComp:QUERY-OPEN ().
      REPEAT WHILE hqComp:GET-NEXT():
        ix = ix + 1.
        oiCompanyId = hbJBoxCompany::iJBoxCompanyId.
      END.
      IF ix > 1 THEN
        oiCompanyId = 0.
    END.
  
    IF VALID-HANDLE(hbJBoxLoginSession) THEN DO TRANSACTION:
      CREATE QUERY hqLogin.
      hqLogin:SET-BUFFERS(hbJBoxLoginSession).
      hqLogin:QUERY-PREPARE("FOR EACH JBoxLoginSession NO-LOCK WHERE JBoxLoginSession.cSessionId > ''"
                          + " AND JBoxLoginSession.dCreated < " + STRING(TODAY - 2)).
      hqLogin:QUERY-OPEN ().
      REPEAT WHILE hqLogin:GET-NEXT():                    
        bFound = hbJBoxLoginSessUpd:FIND-FIRST("WHERE ROWID(JBoxLoginSession) = TO-ROWID('" + STRING(hbJBoxLoginSession:ROWID) + "')",EXCLUSIVE-LOCK,NO-WAIT) NO-ERROR.
        IF bFound THEN
          hbJBoxLoginSessUpd::cSessionId = "".
      END.
  
      hbJBoxLoginSessUpd:BUFFER-CREATE ().
      ASSIGN hbJBoxLoginSessUpd::cSessionId  = ENCODE(icUserId + STRING(TODAY) + STRING(TIME))
             hbJBoxLoginSessUpd::cJBoxUserId = icUserId
             hbJBoxLoginSessUpd::cDateFormat = icDateFormat
             hbJBoxLoginSessUpd::cNumFormat  = icNumFormat
             hbJBoxLoginSessUpd::dCreated    = TODAY
             ocSessionId                     = hbJBoxLoginSessUpd::cSessionId
             ocUserName                      = hbJBoxUser::cUserName
             .
      hLoginTime = hbJBoxLoginSessUpd:BUFFER-FIELD("iLoginTime") NO-ERROR.
      IF VALID-HANDLE(hLoginTime) THEN
        hLoginTime:BUFFER-VALUE = TIME.
      hLogoutTime = hbJBoxLoginSessUpd:BUFFER-FIELD("iLogoutTime") NO-ERROR.
      IF VALID-HANDLE(hLogoutTime) THEN
        hLogoutTime:BUFFER-VALUE = 99999.
    END.
  END.
  ELSE obOk = FALSE.
END.

FINALLY:
  DELETE OBJECT hqCompUser NO-ERROR.
  DELETE OBJECT hqComp     NO-ERROR.
  DELETE OBJECT hbJBoxUser NO-ERROR.
  DELETE OBJECT hbJBoxLoginSession NO-ERROR.
  DELETE OBJECT hbJBoxLoginSessUpd NO-ERROR.
  DELETE OBJECT hbJBoxCompanyUser NO-ERROR.
  DELETE OBJECT hbJBoxCompany NO-ERROR.
END FINALLY.