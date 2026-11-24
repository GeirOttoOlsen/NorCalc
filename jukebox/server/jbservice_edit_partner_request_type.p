/* Update link from ExternalParter to RequestTypes
   Parameters: <partner id>;<list of request types>
         
   Created:  26.11.12 by Brynjar Hasle  
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix            AS INT   NO-UNDO.
DEF VAR iPartnerId    AS INT   NO-UNDO.
DEF VAR cRequestTypes AS CHAR  NO-UNDO.
DEF VAR cUserId       AS CHAR  NO-UNDO.

ASSIGN iPartnerId    = INT(ENTRY(1,icParam,";"))
       cRequestTypes = ENTRY(2,icParam,";")
       cUserId       = DYNAMIC-FUNCTION("getAsUserId" IN SOURCE-PROCEDURE)
       .

{incl/validatecaller.i}

DEF VAR hbJBoxExternalPartnerRequestType AS HANDLE NO-UNDO.
DEF VAR hbJBoxExternalRequestType        AS HANDLE NO-UNDO.
DEF VAR bFound                           AS LOG    NO-UNDO.
DEF VAR hqRequestType                    AS HANDLE NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxExternalPartnerRequestType",OUTPUT hbJBoxExternalPartnerRequestType) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxExternalRequestType",OUTPUT hbJBoxExternalRequestType) THEN RETURN.

CREATE QUERY hqRequestType.
hqRequestType:SET-BUFFERS (hbJBoxExternalPartnerRequestType).


DO TRANSACTION:
  hqRequestType:QUERY-PREPARE ("FOR EACH JBoxExternalPartnerRequestType EXCLUSIVE-LOCK WHERE JBoxExternalPartnerRequestType.iJBoxExternalPartnerId = " + STRING(iPartnerId)).
  hqRequestType:QUERY-OPEN ().
  REPEAT WHILE hqRequestType:GET-NEXT():
    IF LOOKUP(STRING(hbJBoxExternalPartnerRequestType::iJBoxExternalRequestTypeId),cRequestTypes,"|") = 0 THEN
      hbJBoxExternalPartnerRequestType:BUFFER-DELETE ().
  END.
  DO ix = 1 TO NUM-ENTRIES(cRequestTypes,"|"):
    bFound = hbJBoxExternalRequestType:FIND-FIRST("WHERE JBoxExternalRequestType.iJBoxExternalRequestTypeId = INT('" + ENTRY(ix,cRequestTypes,"|") + "')",NO-LOCK)
             NO-ERROR.
    IF bFound THEN DO: 
       bFound = hbJBoxExternalPartnerRequestType:FIND-FIRST("WHERE JBoxExternalPartnerRequestType.iJBoxExternalPartnerId = " + STRING(iPartnerId)
                                                          + " AND JBoxExternalPartnerRequestType.iJBoxExternalRequestTypeId = " + STRING(hbJBoxExternalRequestType::iJBoxExternalRequestTypeId),NO-LOCK)
                NO-ERROR.                                                           
      IF NOT bFound THEN DO:
        hbJBoxExternalPartnerRequestType:BUFFER-CREATE().
        ASSIGN hbJBoxExternalPartnerRequestType::iJBoxExternalPartnerId     = iPartnerId
               hbJBoxExternalPartnerRequestType::iJBoxExternalRequestTypeId = hbJBoxExternalRequestType::iJBoxExternalRequestTypeId
               hbJBoxExternalPartnerRequestType::dCreated                   = TODAY
               hbJBoxExternalPartnerRequestType::cCreatedBy                 = cUserId 
               .
      END.         
    END.
  END.
END.

obOk = ocReturn = "".

FINALLY:
  DELETE OBJECT hqRequestType NO-ERROR.
  DELETE OBJECT hbJBoxExternalPartnerRequestType NO-ERROR.
  DELETE OBJECT hbJBoxExternalRequestType NO-ERROR.      
END FINALLY.
