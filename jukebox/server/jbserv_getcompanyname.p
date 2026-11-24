DEF INPUT  PARAM icSessionId       AS CHAR NO-UNDO.
DEF INPUT  PARAM iiJBoxCompanyId   AS INT  NO-UNDO.
DEF OUTPUT PARAM ocJBoxCompanyName AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocCodeMaster      AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocParentCompany   AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocCompanyLogo     AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocParam           AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOk              AS LOG  NO-UNDO.

DEF VAR ocReturn           AS CHAR   NO-UNDO.
DEF VAR hCompToCompBuffer  AS HANDLE NO-UNDO.
DEF VAR hCompToCompQuery   AS HANDLE NO-UNDO.
DEF VAR hLogoField         AS HANDLE NO-UNDO.
DEF VAR hBuffGenCode       AS HANDLE NO-UNDO.
DEF VAR cCompRole          AS CHAR   NO-UNDO.
DEF VAR hbJBoxUser         AS HANDLE NO-UNDO.
DEF VAR hbJBoxCompany      AS HANDLE NO-UNDO.
DEF VAR hbJBoxCompanyUser  AS HANDLE NO-UNDO.
DEF VAR hbJBoxLoginSession AS HANDLE NO-UNDO.
DEF VAR bFound             AS LOG    NO-UNDO.

{incl/validatesession.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUser",OUTPUT hbJBoxUser) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompany",OUTPUT hbJBoxCompany) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompanyUser",OUTPUT hbJBoxCompanyUser) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxLoginSession",OUTPUT hbJBoxLoginSession) THEN RETURN.

IF cCurrUserId NE "" THEN DO:
  bFound = hbJBoxUser:FIND-FIRST("WHERE JBoxUser.cJBoxUserId = '" + cCurrUserId + "'",NO-LOCK) NO-ERROR.
  IF NOT bFound THEN RETURN. 
  
  IF NOT hbJBoxUser::bSuperUser THEN DO: 
    bFound = hbJBoxCompanyUser:FIND-FIRST("WHERE JBoxCompanyUser.cJBoxUserId = '" + cCurrUserId
                                     + "' AND JBoxCompanyUser.iJBoxCompanyId = " + STRING(iiJBoxCompanyId),NO-LOCK) NO-ERROR.
    IF NOT bFound THEN RETURN.
  END.  
END.

bFound = hbJBoxCompany:FIND-FIRST("WHERE JBoxCompany.iJBoxCompanyId = " + STRING(iiJBoxCompanyId), NO-LOCK) NO-ERROR.
IF bFound THEN DO:
  ocJBoxCompanyName = hbJBoxCompany::cCompanyName.
  DO TRANSACTION:
    bFound = hbJBoxLoginSession:FIND-FIRST("WHERE JBoxLoginSession.cSessionId = '" + icSessionId + "'", EXCLUSIVE-LOCK) NO-ERROR.
    IF bFound THEN
      ASSIGN hbJBoxLoginSession::iJBoxCompanyId = hbJBoxCompany::iJBoxCompanyId
             obOk                               = YES
             .
  END.           
END.

IF obOk THEN DO:    
  CREATE BUFFER hCompToCompBuffer FOR TABLE "JBoxCompanyToCompany" NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN DO:
    CREATE QUERY hCompToCompQuery.  
    hCompToCompQuery:SET-BUFFERS(hCompToCompBuffer).
    hCompToCompQuery:QUERY-PREPARE("FOR EACH JBoxCompanyToCompany NO-LOCK WHERE JBoxCompanyToCompany.iJBoxCompanyId = " 
                                                                              + STRING(hbJBoxCompany::iJBoxCompanyId)) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DO:        
      hCompToCompQuery:QUERY-OPEN() NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO:
        hCompToCompQuery:GET-FIRST().
        REPEAT WHILE NOT hCompToCompQuery:QUERY-OFF-END:
          cCompRole = hCompToCompBuffer:BUFFER-FIELD("cCompanyRole"):BUFFER-VALUE.
          CASE cCompRole:
            WHEN "parent" THEN
              ocParentCompany = STRING(hCompToCompBuffer:BUFFER-FIELD("iJBoxToCompanyId"):BUFFER-VALUE).
            WHEN "codemaster" THEN
              ocCodeMaster = STRING(hCompToCompBuffer:BUFFER-FIELD("iJBoxToCompanyId"):BUFFER-VALUE).
          END CASE.
          hCompToCompQuery:GET-NEXT().
        END.
      END.
    END.
  END.
  IF hbJBoxCompany:AVAIL THEN DO:
    hLogoField = hbJBoxCompany:BUFFER-FIELD("cCompanyLogo") NO-ERROR.
    IF VALID-HANDLE(hLogoField) AND hLogoField:BUFFER-VALUE NE "" THEN
      ocCompanyLogo = hLogoField:BUFFER-VALUE.
    ELSE IF VALID-HANDLE(hLogoField) THEN DO:
      IF ocParentCompany NE "" THEN DO:
        bFound = hbJBoxCompany:FIND-FIRST("WHERE JBoxCompany.iJBoxCompanyId = " + ocParentCompany,NO-LOCK) NO-ERROR.
        IF bFound THEN
          ocCompanyLogo = hLogoField:BUFFER-VALUE.
      END.
      IF ocCompanyLogo = "" AND ocCodeMaster NE "" THEN DO:
        bFound = hbJBoxCompany:FIND-FIRST("WHERE JBoxCompany.iJBoxCompanyId = " + ocCodeMaster,NO-LOCK) NO-ERROR.
        IF bFound THEN
          ocCompanyLogo = hLogoField:BUFFER-VALUE.
      END.
    END.
    IF ocCompanyLogo = "" THEN DO:
      CREATE BUFFER hBuffGenCode FOR TABLE "JBoxGenCode" NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO:
        bFound = hBuffGenCode:FIND-FIRST("WHERE cCodeType = 'companyLogo' AND iJBoxCompanyId = " + STRING(iiJBoxCompanyId),NO-LOCK) NO-ERROR.  
        IF bFound THEN
          ocCompanyLogo = hBuffGenCode:BUFFER-FIELD("cCodeValue"):BUFFER-VALUE.
        IF ocCompanyLogo = "" AND ocParentCompany NE "" THEN DO:
          bFound = hBuffGenCode:FIND-FIRST("WHERE cCodeType = 'companyLogo' AND iJBoxCompanyId = " + ocParentCompany,NO-LOCK) NO-ERROR.  
          IF bFound THEN
            ocCompanyLogo = hBuffGenCode:BUFFER-FIELD("cCodeValue"):BUFFER-VALUE.
        END.
        IF ocCompanyLogo = "" AND ocCodeMaster NE "" THEN DO:
          bFound = hBuffGenCode:FIND-FIRST("WHERE cCodeType = 'companyLogo' AND iJBoxCompanyId = " + ocCodeMaster,NO-LOCK) NO-ERROR.  
          IF bFound THEN
            ocCompanyLogo = hBuffGenCode:BUFFER-FIELD("cCodeValue"):BUFFER-VALUE.
        END.
      END.
    END.
  END.
END.

FINALLY:
  DELETE OBJECT hCompToCompBuffer  NO-ERROR.
  DELETE OBJECT hCompToCompQuery   NO-ERROR.
  DELETE OBJECT hBuffGenCode       NO-ERROR.
  DELETE OBJECT hbJBoxUser         NO-ERROR.
  DELETE OBJECT hbJBoxCompany      NO-ERROR.
  DELETE OBJECT hbJBoxCompanyUser  NO-ERROR.
  DELETE OBJECT hbJBoxLoginSession NO-ERROR.
END FINALLY.  