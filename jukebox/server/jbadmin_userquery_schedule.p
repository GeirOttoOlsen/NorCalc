/********************************************************************************
Created....23/03/2023 by bryhasleadm
Purpose....
Used by....  <list of_ client procedures>
Modified...
********************************************************************************/
DEF VAR hBuffSchedule AS HANDLE NO-UNDO.
DEF VAR hBuffSchedItm AS HANDLE NO-UNDO.
DEF VAR hQSchedule    AS HANDLE NO-UNDO.

/* DYNAMIC-FUNCTION('startASlib' IN SOURCE-PROCEDURE). /* Optionally enable appserver library functions on server */ */

PROCEDURE CleanUp:
  /* Delete any dynamic objects here (avoid creating them inside the internal procedure(s)) */
  DELETE OBJECT hBuffSchedItm NO-ERROR.
  DELETE OBJECT hBuffSchedule NO-ERROR.
  DELETE OBJECT hQSchedule NO-ERROR.
END PROCEDURE.


FUNCTION setResultSetBuffer RETURNS LOGICAL (INPUT ihTTbuffer AS HANDLE):
  /* Called if exists to provide access to the result set buffer */
END FUNCTION.

CREATE BUFFER hBuffSchedItm FOR TABLE "JobbKoSchedulerItem" NO-ERROR.
IF NOT ERROR-STATUS:ERROR THEN DO:
  CREATE BUFFER hBuffSchedule FOR TABLE "JobbKoScheduler" NO-ERROR.
  CREATE QUERY hQSchedule.
  hQSchedule:SET-BUFFERS (hBuffSchedItm,hBuffSchedule).
END.

PROCEDURE QuerySchedule:
  DEF INPUT  PARAM irJBoxUserSetting AS ROWID NO-UNDO.
  DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ocReturn AS CHAR NO-UNDO.

  FIND JBoxUserSetting NO-LOCK
       WHERE ROWID(JBoxUserSetting) = irJBoxUserSetting
       NO-ERROR.
  IF AVAIL JBoxUserSetting AND VALID-HANDLE(hQSchedule) THEN DO:
    hQSchedule:QUERY-PREPARE ("FOR EACH JobbKoSchedulerItem NO-LOCK "
                            + "WHERE JobbKoSchedulerItem.cItem = '" + STRING(JBoxUserSetting.iJBoxUserSettingId) + "'" 
                            + ",FIRST JobbKoScheduler NO-LOCK "
                            + " WHERE JobbKoScheduler.iJobbKoSchedulerId = JobbKoSchedulerItem.iJobbKoSchedulerId").
    hQSchedule:QUERY-OPEN ().
    hQSchedule:GET-FIRST ().                        
    IF hBuffSchedule:AVAIL THEN
      ocReturn = hBuffSchedule::JobbKoSchedulerNavn.
  END.
END PROCEDURE.