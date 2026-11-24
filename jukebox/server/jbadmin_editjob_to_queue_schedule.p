/* Update module-company link
   Parameters:  <module id>|<companylist> 
      
            + <ROWID>|<List of rowid's>
         OR + <List of primary keys >
         
         OR temp-table containing CustNum 
   
   Created: 18.01.11 by Brynjar Hasle                  
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix        AS INT    NO-UNDO.
DEF VAR iQueueId  AS INT    NO-UNDO.
DEF VAR cJobList  AS CHAR   NO-UNDO.
DEF VAR cUserId   AS CHAR   NO-UNDO.
DEF VAR hbJBoxJobSchedule AS HANDLE NO-UNDO.
DEF VAR hqJobShedule      AS HANDLE NO-UNDO.
DEF VAR bFound            AS LOG NO-UNDO.

{incl/validatecaller.i}

ASSIGN iQueueId = INTEGER(ENTRY(1,icParam,";"))
       cJobList = ENTRY(2,icParam,";")
       cUserId  = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE)
       .

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxJobSchedule",OUTPUT hbJBoxJobSchedule) THEN RETURN.

CREATE QUERY hqJobShedule.
hqJobShedule:SET-BUFFERS (hbJBoxJobSchedule).

DO TRANSACTION:
  hqJobShedule:QUERY-PREPARE ("FOR EACH JBoxJobSchedule EXCLUSIVE-LOCK WHERE JBoxJobSchedule.iJBoxJobQueueId = " + STRING(iQueueId)).
  hqJobShedule:QUERY-OPEN ().
  REPEAT WHILE hqJobShedule:GET-NEXT():
    IF LOOKUP(STRING(hbJBoxJobSchedule::iJBoxJobDefinitionId),cJobList,"|") = 0 THEN
      hbJBoxJobSchedule::BUFFER-DELETE ().
  END.
  DO ix = 1 TO NUM-ENTRIES(cJobList,"|"):
    bFound = hbJBoxJobSchedule:FIND-FIRST("WHERE JBoxJobSchedule.iJBoxJobQueueId = " + STRING(iQueueId)
                                        + " AND JBoxJobSchedule.iJBoxJobDefinitionId = INT('" + ENTRY(ix,cJobList,"|") + "'),NO-LOCK") NO-ERROR.
    IF NOT bFound THEN DO:
      hbJBoxJobSchedule:BUFFER-CREATE ().
      ASSIGN hbJBoxJobSchedule::iJBoxJobQueueId       = iQueueId
             hbJBoxJobSchedule::iJBoxJobDefinitionId  = INT(ENTRY(ix,cJobList,"|"))
             hbJBoxJobSchedule::dCreated              = TODAY
             hbJBoxJobSchedule::cCreatedBy            = cUserId
             .
    END.
  END.
END.

IF ocReturn = "" THEN obOk = TRUE.

FINALLY:
  DELETE OBJECT hqJobShedule NO-ERROR.
  DELETE OBJECT hbJBoxJobSchedule NO-ERROR.      
END FINALLY.