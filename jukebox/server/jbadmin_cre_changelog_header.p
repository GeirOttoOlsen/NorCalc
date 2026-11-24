DEF INPUT  PARAM iiCompanyId         AS INT  NO-UNDO.
DEF INPUT  PARAM icText              AS CHAR NO-UNDO.
DEF INPUT  PARAM icUserId            AS CHAR NO-UNDO.
DEF INPUT  PARAM idFrom              AS DATE NO-UNDO.
DEF INPUT  PARAM iiFromTime          AS INT  NO-UNDO.
DEF INPUT  PARAM icExtra             AS CHAR NO-UNDO.
DEF OUTPUT PARAM oiChangeLogHeaderId AS INT  NO-UNDO.

DEF VAR hbJBoxChangeLogHeader AS HANDLE NO-UNDO.

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxChangeLogHeader",OUTPUT hbJBoxChangeLogHeader) THEN RETURN.

hbJBoxChangeLogHeader:BUFFER-CREATE ().
ASSIGN hbJBoxChangeLogHeader::cChangeLogHeaderText = icText
       hbJBoxChangeLogHeader::cCreatedBy           = icUserId
       hbJBoxChangeLogHeader::dChange              = idFrom
       hbJBoxChangeLogHeader::iChangeTime          = iiFromTime
       hbJBoxChangeLogHeader::iJBoxCompanyId       = iiCompanyId
       hbJBoxChangeLogHeader::dCreated             = TODAY
       .
oiChangeLogHeaderId = hbJBoxChangeLogHeader::iJBoxChangeLogHeaderId.

FINALLY:
  DELETE OBJECT hbJBoxChangeLogHeader NO-ERROR.      
END FINALLY.
