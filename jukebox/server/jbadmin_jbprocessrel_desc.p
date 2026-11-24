/* Find related record for relation from JBoxProcess to event-type, etc (records that may relate to a specific workflow)
   Created 04.01.12 by brynjar@chemistry.no
-----------------------------------------------------------*/   

DEF INPUT PARAM  irProcessRel AS ROWID NO-UNDO.
DEF INPUT PARAM  icSessionId  AS CHAR  NO-UNDO.
DEF OUTPUT PARAM ocReturn     AS CHAR  NO-UNDO.

DEF VAR hBuffContext AS HANDLE NO-UNDO.
DEF VAR bOk          AS LOG    NO-UNDO.
DEF VAR hbJBoxProcessRel AS HANDLE NO-UNDO.
DEF VAR cTable           AS CHAR   NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxProcessRel",OUTPUT hbJBoxProcessRel) THEN RETURN.

bOk = hbJBoxProcessRel:FIND-BY-ROWID (irProcessRel,NO-LOCK) NO-ERROR.
     
IF bOk THEN DO:
  cTable = hbJBoxProcessRel::cContext.
  CREATE BUFFER hBuffContext FOR TABLE cTable NO-ERROR.
  IF VALID-HANDLE(hBuffContext) THEN 
    CASE cTable:
      WHEN "JBoxEmailAccount" THEN DO:
        bOk = hBuffContext:FIND-FIRST("WHERE iJBoxEmailAccountId = " + hbJBoxProcessRel::cEntityId,NO-LOCK) NO-ERROR.
        IF bOk THEN
          ocReturn = hBuffContext:BUFFER-FIELD("cEmailAddress"):BUFFER-VALUE.
      END.
      WHEN "JBoxEventLogType" THEN DO:
        bOk = hBuffContext:FIND-FIRST("WHERE cEventLogType = '" + hbJBoxProcessRel::cEntityId + "'",NO-LOCK) NO-ERROR.
        IF bOk THEN
          ocReturn = hBuffContext:BUFFER-FIELD("cEventLogTypeText"):BUFFER-VALUE.
      END.
    END CASE.

END.

FINALLY:
  DELETE OBJECT hbJBoxProcessRel NO-ERROR.
  DELETE OBJECT hBuffContext NO-ERROR.      
END FINALLY.