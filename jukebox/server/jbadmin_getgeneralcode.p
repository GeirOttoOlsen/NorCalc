/* get system parameter (from server procs) */
DEF INPUT PARAM  icCodeType   AS CHAR NO-UNDO.
DEF INPUT PARAM  icValueDesc  AS CHAR NO-UNDO. /* description or value */
DEF INPUT PARAM  iiCompanyId  AS INT  NO-UNDO.
DEF INPUT PARAM  iiCodeMaster AS INT  NO-UNDO.
DEF OUTPUT PARAM ocValue      AS CHAR NO-UNDO.

DEF VAR hbJBoxGenCode AS HANDLE NO-UNDO.
DEF VAR bFound        AS LOG    NO-UNDO.

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxGenCode",OUTPUT hbJBoxGenCode) THEN RETURN.

IF iiCodeMaster NE 0 THEN DO:
  bFound = hbJBoxGenCode:FIND-FIRST("WHERE JBoxGenCode.iJBoxCompanyId = " + STRING(iiCodeMaster)
                                  + " AND JBoxGenCode.cCodeType       = '" + icCodeType + "'"
                                  + " AND JBoxGenCode.cDescription    = '" + icValueDesc + "'",NO-LOCK) NO-ERROR.
  IF bFound THEN
    ocValue = hbJBoxGenCode::cCodeValue.
  ELSE DO:
    bFound = hbJBoxGenCode:FIND-FIRST("WHERE JBoxGenCode.iJBoxCompanyId = " + STRING(iiCodeMaster)
                                    + " AND JBoxGenCode.cCodeType       = '" + icCodeType + "'"
                                    + " AND JBoxGenCode.cCodeValue      = '" + icValueDesc + "'",NO-LOCK) NO-ERROR.
    IF bFound THEN
      ocValue = hbJBoxGenCode::cDescription.
  END.  
END. 

IF NOT bFound AND iiCompanyId NE 0 THEN DO:
  bFound = hbJBoxGenCode:FIND-FIRST("WHERE JBoxGenCode.iJBoxCompanyId = " + STRING(iiCompanyId)
                                  + " AND JBoxGenCode.cCodeType       = '" + icCodeType + "'"
                                  + " AND JBoxGenCode.cDescription    = '" + icValueDesc + "'",NO-LOCK) NO-ERROR.
  IF bFound THEN
    ocValue = hbJBoxGenCode::cCodeValue.
  ELSE DO:
    bFound = hbJBoxGenCode:FIND-FIRST("WHERE JBoxGenCode.iJBoxCompanyId = " + STRING(iiCompanyId)
                                    + " AND JBoxGenCode.cCodeType       = '" + icCodeType + "'"
                                    + " AND JBoxGenCode.cCodeValue      = '" + icValueDesc + "'",NO-LOCK) NO-ERROR.
    IF bFound THEN
      ocValue = hbJBoxGenCode::cDescription.
  END.  
END.

IF NOT bFound THEN DO:
  bFound = hbJBoxGenCode:FIND-FIRST("WHERE JBoxGenCode.iJBoxCompanyId = 0"
                                  + " AND JBoxGenCode.cCodeType       = '" + icCodeType + "'"
                                  + " AND JBoxGenCode.cDescription    = '" + icValueDesc + "'",NO-LOCK) NO-ERROR.
  IF bFound THEN
    ocValue = hbJBoxGenCode::cCodeValue.
  ELSE DO:
    bFound = hbJBoxGenCode:FIND-FIRST("WHERE JBoxGenCode.iJBoxCompanyId = 0"
                                    + " AND JBoxGenCode.cCodeType       = '" + icCodeType + "'"
                                    + " AND JBoxGenCode.cCodeValue      = '" + icValueDesc + "'",NO-LOCK) NO-ERROR.
    IF bFound THEN
      ocValue = hbJBoxGenCode::cDescription.
  END.  
END.

FINALLY:
  DELETE OBJECT hbJBoxGenCode NO-ERROR.      
END FINALLY.