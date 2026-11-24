DEF INPUT  PARAM iiChangeLogHeaderId AS INT  NO-UNDO.
DEF INPUT  PARAM iiCompanyId         AS INT  NO-UNDO.
DEF INPUT  PARAM icChangeType        AS CHAR NO-UNDO.
DEF INPUT  PARAM icUserId            AS CHAR NO-UNDO.
DEF INPUT  PARAM icEntityIdFields    AS CHAR NO-UNDO.
DEF INPUT  PARAM icEntityIdValues    AS CHAR NO-UNDO.
DEF INPUT  PARAM icTableName         AS CHAR NO-UNDO.
DEF INPUT  PARAM icFieldsChanged     AS CHAR NO-UNDO.
DEF INPUT  PARAM icFromValues        AS CHAR NO-UNDO.
DEF INPUT  PARAM icToValues          AS CHAR NO-UNDO.
DEF INPUT  PARAM icExtra             AS CHAR NO-UNDO.

DEF VAR hbJBoxChangeLogType AS HANDLE NO-UNDO.
DEF VAR hbJBoxChangeLog     AS HANDLE NO-UNDO.
DEF VAR bFound              AS LOG    NO-UNDO.

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxChangeLogType",OUTPUT hbJBoxChangeLogType) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxChangeLog",OUTPUT hbJBoxChangeLog) THEN RETURN.

bFound = hbJBoxChangeLogType:FIND-FIRST("WHERE JBoxChangeLogType.cChangeLogTypeId = '" + icChangeType + "'",NO-LOCK) NO-ERROR.

IF NOT bFound THEN DO:
  hbJBoxChangeLogType:BUFFER-CREATE ().
  ASSIGN hbJBoxChangeLogType::cChangeLogTypeId   = icChangeType
         hbJBoxChangeLogType::cChangeLogTypeText = icChangeType
         hbJBoxChangeLogType::dCreated           = TODAY
         hbJBoxChangeLogType::cCreatedBy         = icUserId
         .
END.

hbJBoxChangeLog:BUFFER-CREATE().
ASSIGN hbJBoxChangeLog::iJBoxChangeLogHeaderId = iiChangeLogHeaderId
       hbJBoxChangeLog::iJBoxCompanyId         = iiCompanyId
       hbJBoxChangeLog::cChangeLogTypeId       = icChangeType
       hbJBoxChangeLog::cEntityIdFields        = icEntityIdFields
       hbJBoxChangeLog::cEntityIdValues        = icEntityIdValues
       hbJBoxChangeLog::cTableChanged          = icTableName
       hbJBoxChangeLog::cFieldsChanged         = icFieldsChanged
       hbJBoxChangeLog::cFromValues            = icFromValues
       hbJBoxChangeLog::cToValues              = icToValues
       hbJBoxChangeLog::dCreated               = TODAY
       .

FINALLY:
  DELETE OBJECT hbJBoxChangeLog NO-ERROR.
  DELETE OBJECT hbJBoxChangeLogType NO-ERROR.      
END FINALLY.
