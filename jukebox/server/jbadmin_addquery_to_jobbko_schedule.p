/* Update query definition to schedule
   Parameters:  scheduleId-list|queryId (user setting id)|run now 

   Created: 16/06/22 by bryhasleadm
-----------------------------------------------------------------------------------*/


DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix               AS INT   NO-UNDO.
DEF VAR cScheduleIdList  AS CHAR  NO-UNDO.
DEF VAR cUsrSettingId    AS CHAR  NO-UNDO.
DEF VAR bRunNow          AS LOG   NO-UNDO.
DEF VAR oJobbQ           AS server.oo.JobQueue NO-UNDO.
DEF VAR iJobbId          AS INT   NO-UNDO.

{incl/validatecaller.i}

ASSIGN cScheduleIdList = ENTRY(1,icParam,";")
       cUsrSettingId   = ENTRY(2,icParam,";")
       bRunNow         = LOGICAL(ENTRY(3,icParam,";"))
       NO-ERROR.
IF ERROR-STATUS:GET-MESSAGE(1) NE "" THEN DO:
  ocReturn = "Error in parameter string: " + icParam.
  RETURN.
END.       

DO TRANSACTION:
  FOR EACH JobbKoSchedulerItem EXCLUSIVE-LOCK
      WHERE JobbKoSchedulerItem.cItem = cUsrSettingId
     ,FIRST JobbKoScheduler NO-LOCK
            WHERE JobbKoScheduler.iJobbKoSchedulerId = JobbKoScheduler.iJobbKoSchedulerId
     ,FIRST JobbKoType NO-LOCK 
            WHERE JobbKoType.iJobbKoTypeId = JobbKoScheduler.iJobbKoType 
              AND JobbKoType.iJobbKoTypeId = 1       
     :
    IF LOOKUP(STRING(JobbKoSchedulerItem.iJobbKoSchedulerItemId),cScheduleIdList,"|") = 0 THEN
      DELETE JobbKoSchedulerItem.
  END.
  DO ix = 1 TO NUM-ENTRIES(cScheduleIdList,"|"):
    FIND JobbKoSchedulerItem
         WHERE JobbKoSchedulerItem.iJobbKoSchedulerId = INT(ENTRY(ix,cScheduleIdList)) 
           AND JobbKoSchedulerItem.cItem  = cUsrSettingId
         NO-LOCK NO-ERROR.
    IF NOT AVAIL JobbKoSchedulerItem THEN DO:
      CREATE JobbKoSchedulerItem.
      ASSIGN JobbKoSchedulerItem.cItem              = cUsrSettingId
             JobbKoSchedulerItem.iJobbKoSchedulerId = INT(ENTRY(ix,cScheduleIdList,"|"))
             JobbKoSchedulerItem.dCreated           = TODAY
             JobbKoSchedulerItem.cCreatedBy         = JBoxServerSide:Instance:UserId
             .
    END.
  END.
END.
IF bRunNow THEN DO:
  oJobbQ = NEW server.oo.JobQueue().
  iJobbId = oJobbQ:addJobbko(?,INT(server.enum.JobQueueType:QueryReport),INT(server.enum.JobQueueStatus:Initiate)).
  oJobbQ:addJobbkoFelt("Item", cUsrSettingId).
  oJobbQ:addJobbkoFelt("Prosess", "queryreport.p").
  oJobbQ:changeJobbkoStatus(INT(server.enum.JobQueueStatus:New)).
END.
FINALLY:
  obOk = ocReturn = "".
  IF bRunNow THEN
    ocReturn = STRING(iJobbId).
END FINALLY.
