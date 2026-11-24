/* Check for any new broadcasts to current user
   The link from message to user can either exist (message for specific user(s)) or,
   if the message is public - either within a company or for all - the link is created here.
   
   Parameters:  none 
         
   Created: 31.01.06 by Brynjar Hasle                  
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEF VAR hbJBoxUserBroadcast    AS HANDLE NO-UNDO.
DEF VAR hbJBoxLoginSession     AS HANDLE NO-UNDO.
DEF VAR hbJBoxBroadCastMessage AS HANDLE NO-UNDO.
DEF VAR bFound                 AS LOG    NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUserBroadcast",OUTPUT hbJBoxUserBroadcast) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxBroadCastMessage",OUTPUT hbJBoxBroadCastMessage) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxLoginSession",OUTPUT hbJBoxLoginSession) THEN RETURN.

bFound = hbJBoxLoginSession:FIND-FIRST("WHERE JBoxLoginSession.cSessionId = '" + icSessionId + "'",NO-LOCK) NO-ERROR.
     
IF bFound THEN DO:
  bFound = hbJBoxUserBroadcast:FIND-FIRST("WHERE JBoxUserBroadcast.cJBoxUserId = '" + hbJBoxLoginSession::cJBoxUserId + "'"
                                        + " AND NOT JBoxUserBroadcast.bReceived",NO-LOCK) NO-ERROR.
  IF NOT bFound THEN
    bFound = hbJBoxUserBroadcast:FIND-FIRST("WHERE JBoxUserBroadcast.cJBoxUserId = '" + hbJBoxLoginSession::cJBoxUserId + "'"
                                          + " AND JBoxUserBroadcast.bReceived"
                                          + " AND NOT JBoxUserBroadcast.bDoNotShowAgain"
                                          ,NO-LOCK) NO-ERROR.
  IF bFound THEN DO:
    bFound = hbJBoxBroadCastMessage:FIND-FIRST("WHERE JBoxBroadCastMessage.iJBoxBroadCastMessageId = " + STRING(hbJBoxUserBroadcast::iJBoxBroadCastMessageId)
                                             + " AND JBoxBroadCastMessage.dStartBroadCast LE DATE('" + STRING(TODAY,"99/99/9999") + "')"
                                             + " AND JBoxBroadCastMessage.iStartBroadCastTime LE " + STRING(TIME)
                                             + " AND JBoxBroadCastMessage.dEndBroadCast GE DATE('" + STRING(TODAY,"99/99/9999") + "')"
                                             + " AND (IF JBoxBroadCastMessage.dEndBroadCast = DATE('" + STRING(TODAY,"99/99/9999") + "') THEN JBoxBroadCastMessage.iEndBroadCastTime GE " + STRING(TIME) + " ELSE TRUE)"
                                             ,NO-LOCK) NO-ERROR.
    IF bFound THEN DO:
      IF NOT hbJBoxUserBroadcast::bReceived THEN DO:
        hbJBoxUserBroadcast:FIND-CURRENT (EXCLUSIVE-LOCK,NO-WAIT) NO-ERROR.
        IF hbJBoxUserBroadcast:AVAIL THEN
          ASSIGN hbJBoxUserBroadcast::bReceived = YES
                 hbJBoxUserBroadcast::dReceived = TODAY
                 hbJBoxUserBroadcast::iReceived = TIME.
      END.
      ocReturn = STRING(hbJBoxBroadCastMessage::iJBoxBroadCastMessageId).
      obOk = YES.
      RETURN.
    END.
  END.

  bFound = hbJBoxBroadCastMessage:FIND-FIRST("WHERE JBoxBroadCastMessage.dStartBroadCast LE DATE('" + STRING(TODAY,"99/99/9999") + "')"
                                           + " AND JBoxBroadCastMessage.iStartBroadCastTime LE " + STRING(TIME)
                                           + " AND JBoxBroadCastMessage.dEndBroadCast GE DATE('" + STRING(TODAY,"99/99/9999") + "')"
                                           + " AND (IF JBoxBroadCastMessage.dEndBroadCast = DATE('" + STRING(TODAY,"99/99/9999") + "') THEN JBoxBroadCastMessage.iEndBroadCastTime GE " + STRING(TIME) + " ELSE TRUE)"
                                           + " AND (JBoxBroadCastMessage.bAllUsers OR JBoxBroadCastMessage.iJBoxCompanyId = " + STRING(hbJBoxLoginSession::iJBoxCompanyId) + ")"
                                           ,NO-LOCK) NO-ERROR.
  IF bFound THEN DO:
    hbJBoxUserBroadcast:FIND-FIRST("WHERE JBoxUserBroadcast.iJBoxBroadCastMessageId = " + STRING(hbJBoxBroadCastMessage::iJBoxBroadCastMessageId)
                                 + " AND JBoxUserBroadcast.cJBoxUserId = '" + hbJBoxLoginSession::cJBoxUserId + "'"
                                 ,NO-LOCK) NO-ERROR.
    IF NOT bFound THEN DO:
      hbJBoxUserBroadcast:BUFFER-CREATE ().
      ASSIGN hbJBoxUserBroadcast::iJBoxBroadCastMessageId = hbJBoxBroadCastMessage::iJBoxBroadCastMessageId
             hbJBoxUserBroadcast::cJBoxUserId             = hbJBoxLoginSession::cJBoxUserId
             hbJBoxUserBroadcast::bReceived               = YES
             hbJBoxUserBroadcast::dReceived               = TODAY
             hbJBoxUserBroadcast::iReceived               = TIME
             hbJBoxUserBroadcast::dCreated                = TODAY
             hbJBoxUserBroadcast::cCreatedBy              = hbJBoxLoginSession::cJBoxUserId
             ocReturn                                     = STRING(hbJBoxBroadCastMessage::iJBoxBroadCastMessageId).
             .
    END.
    ELSE IF NOT hbJBoxUserBroadcast::bDoNotShowAgain THEN
      ocReturn = STRING(hbJBoxBroadCastMessage::iJBoxBroadCastMessageId).
  END.

END.


FINALLY:
  DELETE OBJECT hbJBoxLoginSession NO-ERROR.
  DELETE OBJECT hbJBoxUserBroadcast NO-ERROR.
  DELETE OBJECT hbJBoxBroadCastMessage NO-ERROR.
        
  obOk = ocReturn NE "".
END FINALLY.