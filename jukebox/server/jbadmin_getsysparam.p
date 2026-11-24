/* get system parameter (from server procs) */
DEF INPUT PARAM  icParamName  AS CHAR NO-UNDO.
DEF INPUT PARAM  icValueType  AS CHAR NO-UNDO.
DEF INPUT PARAM  iiCompanyId  AS INT  NO-UNDO.
DEF INPUT PARAM  iiCodeMaster AS INT  NO-UNDO.
DEF OUTPUT PARAM ocValue      AS CHAR NO-UNDO.

DEF VAR hbJBoxSysParam AS HANDLE NO-UNDO.
DEF VAR bFound         AS LOG    NO-UNDO.

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxSysParam",OUTPUT hbJBoxSysParam) THEN RETURN.

IF iiCodeMaster NE 0 THEN 
  bFound = hbJBoxSysParam:FIND-FIRST("WHERE JBoxSysParam.iJBoxCompanyId = " + STRING(iiCodeMaster)
                                   + " AND JBoxSysParam.cSysParamName  = '" + icParamName + "'"
                                   + " AND JBoxSysParam.bActive",NO-LOCK) NO-ERROR.

IF NOT bFound AND iiCompanyId NE 0 THEN
  bFound = hbJBoxSysParam:FIND-FIRST("WHERE JBoxSysParam.iJBoxCompanyId = " + STRING(iiCompanyId)
                                   + " AND JBoxSysParam.cSysParamName  = '" + icParamName + "'"
                                   + " AND JBoxSysParam.bActive",NO-LOCK) NO-ERROR.

IF NOT bFound THEN
  bFound = hbJBoxSysParam:FIND-FIRST("WHERE JBoxSysParam.iJBoxCompanyId = 0"
                                   + " AND JBoxSysParam.cSysParamName  = '" + icParamName + "'"
                                   + " AND JBoxSysParam.bActive",NO-LOCK) NO-ERROR.

IF bFound THEN 
  CASE icValueType:
    WHEN "date"    THEN ocValue = STRING(hbJBoxSysParam::dSysParamDateValue).
    WHEN "integer" THEN ocValue = STRING(hbJBoxSysParam::iSysParamIntValue).
    WHEN "decimal" THEN ocValue = STRING(hbJBoxSysParam::fSysParamDecimalValue).
    WHEN "text"    THEN ocValue = hbJBoxSysParam::cSysParamText.
    OTHERWISE           ocValue = hbJBoxSysParam::cSysParamCharValue.
  END CASE.
ELSE ocValue = ?.

FINALLY:
  DELETE OBJECT hbJBoxSysParam NO-ERROR.      
END FINALLY.