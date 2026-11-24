/* To invoke: 
   DYNAMIC-FUNCTION("setAttribute",hFieldMap,"CustomUpdateValProc","=update_validation.p").
   Procedure name must be prefixed by = or +
   =:   Dynamic validation is suppressed
   +:   The validation proc is run in addition to dynamic validation
   Dynamic (automatic) validation is done before custom val (ref doc/html/fieldMap.html for rules).
   
   If there's no fieldmap (viewer) set the attribute on the browse object
-----------------------------------------------------------------------------------------*/   
DEF INPUT  PARAM icRowid             AS CHAR NO-UNDO.
DEF INPUT  PARAM icFields            AS CHAR NO-UNDO.
DEF INPUT  PARAM icValues            AS CHAR NO-UNDO.
DEF INPUT  PARAM icSessionId         AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn            AS CHAR NO-UNDO.  

DEF VAR iCodemasterCompany     AS INT    NO-UNDO.
DEF VAR iParentCompany         AS INT    NO-UNDO.
DEF VAR hbJBoxCompany          AS HANDLE NO-UNDO.
DEF VAR hbJBoxCompanyToCompany AS HANDLE NO-UNDO.
DEF VAR bFound                 AS LOG    NO-UNDO. 

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompany",OUTPUT hbJBoxCompany) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompanyToCompany",OUTPUT hbJBoxCompanyToCompany) THEN RETURN.

bFound = hbJBoxCompany:FIND-FIRST("WHERE ROWID(JBoxCompany) = TO-ROWID('" + icRowId + "')",EXCLUSIVE-LOCK,NO-WAIT) NO-ERROR.
IF bFound THEN DO:  
  iCodeMasterCompany = INT(DYNAMIC-FUNCTION("getValue" IN SOURCE-PROCEDURE,"codemaster")).
  bFound = hbJBoxCompanyToCompany:FIND-FIRST("WHERE  JBoxCompanyToCompany.iJBoxCompanyId = " + STRING(hbJBoxCompany::iJBoxCompanyId)
                                           + " AND JBoxCompanyToCompany.cCompanyRole = 'codemaster'",EXCLUSIVE-LOCK,NO-WAIT)
                                             NO-ERROR.
  IF bFound THEN DO:
    IF iCodemasterCompany = 0 THEN hbJBoxCompanyToCompany:BUFFER-DELETE ().
    ELSE hbJBoxCompanyToCompany::iJBoxToCompanyId = iCodeMasterCompany.
  END.
  ELSE IF iCodeMasterCompany NE 0 THEN DO:
    hbJBoxCompanyToCompany:BUFFER-CREATE ().
    ASSIGN hbJBoxCompanyToCompany::iJBoxCompanyId   = hbJBoxCompany::iJBoxCompanyId
           hbJBoxCompanyToCompany::iJBoxToCompanyId = iCodeMasterCompany
           hbJBoxCompanyToCompany::cCompanyRole     = "codemaster".
  END.

  iParentCompany = INT(DYNAMIC-FUNCTION("getValue" IN SOURCE-PROCEDURE,"parent")).
  bFound = hbJBoxCompanyToCompany:FIND-FIRST("WHERE  JBoxCompanyToCompany.iJBoxCompanyId = " + STRING(hbJBoxCompany::iJBoxCompanyId)
                                           + " AND JBoxCompanyToCompany.cCompanyRole = 'parent'",EXCLUSIVE-LOCK,NO-WAIT)
                                             NO-ERROR.
  IF bFound THEN DO:
    IF iParentCompany = 0 THEN hbJBoxCompanyToCompany:BUFFER-DELETE ().
    ELSE hbJBoxCompanyToCompany::iJBoxToCompanyId = iParentCompany.
  END.
  ELSE IF iParentCompany NE 0 THEN DO:
    hbJBoxCompanyToCompany:BUFFER-CREATE ().
    ASSIGN hbJBoxCompanyToCompany::iJBoxCompanyId   = hbJBoxCompany::iJBoxCompanyId
           hbJBoxCompanyToCompany::iJBoxToCompanyId = iParentCompany
           hbJBoxCompanyToCompany::cCompanyRole     = "parent".
  END.
END.

FINALLY:
  DELETE OBJECT hbJBoxCompany NO-ERROR.
  DELETE OBJECT hbJBoxCompanyToCompany NO-ERROR.
END FINALLY.