DEF INPUT PARAM  irJBoxCompany  AS ROWID NO-UNDO.
DEF INPUT PARAM  icMenuItem     AS CHAR  NO-UNDO.
DEF INPUT PARAM  icSessionId    AS CHAR  NO-UNDO.
DEF OUTPUT PARAM ocReturn       AS CHAR  NO-UNDO INIT "no".

DEF VAR hbJBoxCompany     AS HANDLE NO-UNDo.
DEF VAR hbJBoxCompanyMenu AS HANDLE NO-UNDo.
DEF VAR bFound        AS LOG NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompany",OUTPUT hbJBoxCompany) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompanyMenu",OUTPUT hbJBoxCompanyMenu) THEN RETURN.

bFound = hbJBoxCompany:FIND-BY-ROWID (irJBoxCompany, NO-LOCK) NO-ERROR.
IF bFound THEN DO:
  bFound = hbJBoxCompanyMenu:FIND-FIRST("WHERE JBoxCompanyMenu.iJBoxMenuId = " + icMenuItem
                                      + "AND JBoxCompanyMenu.iJBoxCompanyId = " + STRING(hbJBoxCompany::iJBoxCompanyId),NO-LOCK)
                                        NO-ERROR.
  IF bFound  THEN
    ocReturn = STRING(hbJBoxCompanyMenu::bWriteAccess).
END.

FINALLY:
  DELETE OBJECT hbJBoxCompany NO-ERROR.      
  DELETE OBJECT hbJBoxCompanyMenu NO-ERROR.      
END FINALLY.
