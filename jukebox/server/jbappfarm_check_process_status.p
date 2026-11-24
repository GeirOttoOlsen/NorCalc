/* Purpose:    Check status of application processes.
               Processes are configuered pr user and application.
               Usage: Check process status before (batch) download of application updates
   Parameters: Application id
               username 
   Created:   22.05.12 by brynjar@chemistry.no
-------------------------------------------------------------------------*/                  
DEF INPUT  PARAM icApplicationId     AS CHAR NO-UNDO. 
DEF INPUT  PARAM icComputerUserName  AS CHAR NO-UNDO.
DEF INPUT  PARAM icSessionId         AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocRunningProcesses  AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocStoppedProcesses  AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn            AS CHAR NO-UNDO.

{incl/validatesession.i}

DEF VAR hbJBoxAppProcess     AS HANDLE NO-UNDO.
DEF VAR hbJBoxAppProcessType AS HANDLE NO-UNDO.
DEF VAR bFound               AS LOG    NO-UNDO.
DEF VAR hqAppProcess         AS HANDLE NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxAppProcess",OUTPUT hbJBoxAppProcess) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxAppProcessType",OUTPUT hbJBoxAppProcessType) THEN RETURN.

CREATE QUERY hqAppProcess.
hqAppProcess:SET-BUFFERS (hbJBoxAppProcess).
hqAppProcess:QUERY-PREPARE ("FOR EACH JBoxAppProcess NO-LOCK WHERE JBoxAppProcess.iJBoxApplicationId = " + icApplicationId
                          + " AND JBoxAppProcess.cJBoxUserId = '" + icComputerUserName + "'"
                          + " AND JBoxAppProcess.bActive").
hqAppProcess:QUERY-OPEN ().
REPEAT WHILE hqAppProcess:GET-NEXT():
  
  bFound = hbJBoxAppProcessType:FIND-FIRST("WHERE iJBoxAppProcessTypeId = " + STRING(hbJBoxAppProcess::iJBoxAppProcessTypeId),NO-LOCK) NO-ERROR.
  
  IF hbJBoxAppProcess::bRunning THEN
    ocRunningProcesses = ocRunningProcesses +(IF ocRunningProcesses NE "" THEN ";" ELSE "") 
                       + (IF bFound THEN hbJBoxAppProcessType::cProcessType ELSE STRING(hbJBoxAppProcess::iJBoxAppProcessId)).
  ELSE
    ocStoppedProcesses = ocStoppedProcesses +(IF ocStoppedProcesses NE "" THEN ";" ELSE "") 
                       + (IF bFound THEN hbJBoxAppProcessType::cProcessType ELSE STRING(hbJBoxAppProcess::iJBoxAppProcessId)).
END.

FINALLY:
  DELETE OBJECT hqAppProcess NO-ERROR.
  DELETE OBJECT hbJBoxAppProcess NO-ERROR.
  DELETE OBJECT hbJBoxAppProcessType NO-ERROR.
END FINALLY.

