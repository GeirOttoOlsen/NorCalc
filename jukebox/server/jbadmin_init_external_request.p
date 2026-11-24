/* jbadmin_init_external_request.p 
   Parameters partner name, request type, request parameter, pass.phrase (opt)
   Returns requestid for completion.
   
   Created  19.11.12 by brynjar@chemistry.no
-------------------------------------------------------------------------*/   
DEF INPUT  PARAM icPartnerName       AS CHAR NO-UNDO.
DEF INPUT  PARAM icRequestType       AS CHAR NO-UNDO.
DEF INPUT  PARAM icRequestParam      AS CHAR NO-UNDO.
DEF INPUT  PARAM icRequestPassPhrase AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOk                AS LOG  NO-UNDO INIT YES.
DEF OUTPUT PARAM ocReturn            AS CHAR NO-UNDO.
DEF OUTPUT PARAM oiRequestId         AS INT  NO-UNDO.

DEF VAR hbJBoxExternalPartner     AS HANDLE NO-UNDO.
DEF VAR hbJBoxExternalRequestType AS HANDLE NO-UNDO.
DEF VAR hbJBoxExternalRequest     AS HANDLE NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxExternalPartner",OUTPUT hbJBoxExternalPartner) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxExternalRequestType",OUTPUT hbJBoxExternalRequestType) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxExternalRequest",OUTPUT hbJBoxExternalRequest) THEN RETURN.

hbJBoxExternalPartner:FIND-FIRST("WHERE JBoxExternalPartner.cExternalPartnerName = '" + icPartnerName + "'",NO-LOCK) NO-ERROR.

hbJBoxExternalRequestType:FIND-FIRST("WHERE JBoxExternalRequestType.cExternalRequestType = '" + icRequestType + "'",NO-LOCK) NO-ERROR.

RUN jbadmin_validate_external_request.p (icPartnerName,icRequestPassPhrase,OUTPUT obOk).

hbJBoxExternalRequest:BUFFER-CREATE().
ASSIGN hbJBoxExternalRequest::cRequestInputParam   = icRequestParam
       hbJBoxExternalRequest::dtRequest            = NOW
       hbJBoxExternalRequest::bRequestOk           = obOk
       .

oiRequestId = hbJBoxExternalRequest::iJBoxExternalRequestId.

IF hbJBoxExternalRequestType:AVAIL THEN
  hbJBoxExternalRequest::iJBoxExternalRequestTypeId = hbJBoxExternalRequestType::iJBoxExternalRequestTypeId.

IF hbJBoxExternalPartner:AVAIL THEN
  hbJBoxExternalRequest::iJBoxExternalPartnerId = hbJBoxExternalPartner::iJBoxExternalPartnerId.

FINALLY:
  DELETE OBJECT hbJBoxExternalPartner NO-ERROR.
  DELETE OBJECT hbJBoxExternalRequestType NO-ERROR.      
  DELETE OBJECT hbJBoxExternalRequest NO-ERROR.
END FINALLY.
