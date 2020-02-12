/* Husk å last menyer først! */
  
FOR EACH Company NO-LOCK:
  CREATE JBoxCompany.
  BUFFER-COPY Company TO JBoxCompany.
  JBoxCompany.iJBoxCompanyId = Company.iCompanyId.
END.

FIND LAST JBoxCompany.
CURRENT-VALUE(seqJBoxCompanyId) = JBoxCompany.iJBoxCompanyId.

FOR EACH AdminUser NO-LOCK:
  CREATE JBoxUser.
  BUFFER-COPY AdminUser TO JBoxUser.
  ASSIGN JBoxUser.cJBoxUserId = AdminUser.cUserId.
END.

FOR EACH AdminUserCompany NO-LOCK:
  CREATE JBoxCompanyUser.
  BUFFER-COPY AdminUserCompany TO JBoxCompanyUser.
  ASSIGN JBoxCompanyUser.cJBoxUserId    = AdminUserCompany.cUserId
         JBoxCompanyUser.iJBoxCompanyId = AdminUserCompany.iCompanyId
         .
END.

FOR EACH genCode NO-LOCK:
  CREATE JBoxGenCode.
  BUFFER-COPY genCode TO JBoxGenCode.
  ASSIGN JBoxGenCode.iJboxCompanyId = genCode.iCompanyId.
END.
FIND LAST JBoxGenCode NO-ERROR.
IF AVAIL JBoxGenCode THEN
  CURRENT-VALUE(seqJBoxGenCodeId) = iJBoxGenCodeId.

DELETE FROM JBoxGenCodeType.
FOR EACH genCodeType NO-LOCK:
  CREATE JBoxGenCodeType.
  BUFFER-COPY genCodeType TO JBoxGenCodeType.
END.

FOR EACH loginSession NO-LOCK:
  CREATE JBoxLoginSession.
  BUFFER-COPY loginSession TO JBoxLoginSession.
  ASSIGN JBoxLoginSession.cJBoxUserId    = loginSession.cUserId
         JBoxLoginSession.iJBoxCompanyId = loginSession.iCompanyId
         .
END.

FOR EACH Translation NO-LOCK:
  CREATE JBoxTranslation.
  BUFFER-COPY Translation TO JBoxTranslation.
END.
FIND LAST JBoxTranslation NO-ERROR.
IF AVAIL JBoxTranslation THEN
  CURRENT-VALUE(seqJBoxTranslationId) = JBoxTranslation.iJBoxTranslationId.

FIND LAST jboxmenu.  CURRENT-VALUE(seqJboxMenuId) = ijboxmenuid.
