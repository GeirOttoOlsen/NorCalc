/* Get a list of contexts for some user settings. 
   Created: 05.12.18 By brynjar@chemistry.no
----------------------------------------------------------------------------------------*/
DEF INPUT  PARAM icSessionId        AS CHAR NO-UNDO. 
DEF INPUT  PARAM icSourceFile       AS CHAR NO-UNDO.
DEF INPUT  PARAM icObjectName       AS CHAR NO-UNDO.
DEF INPUT  PARAM icSettingName      AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn           AS CHAR NO-UNDO.

DEF VAR hBuffer      AS HANDLE NO-UNDO.
DEF VAR bOk          AS LOG    NO-UNDO INIT YES.
DEF VAR hQuery       AS HANDLE NO-UNDO.
DEF VAR cContextList AS CHAR   NO-UNDO.

{incl/validatesession.i}

CREATE BUFFER hBuffer FOR TABLE "JBoxUserSetting" NO-ERROR.
IF ERROR-STATUS:ERROR THEN RETURN "No setting table".

IF icSourceFile = "" AND icObjectName = "" AND icSettingName = "" THEN
  RETURN "Invalid qualifier".

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(hBuffer).
hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME + " USE-INDEX idxUserId "
                    + " WHERE cSourceFile  = '" + icSourceFile + "'"
                    + "   AND cObjectName  = '" + icObjectName + "'"
                    + "   AND CAN-DO('" + icSettingName + "',cSettingName)"
                    + "   AND cJBoxUserId  = '" + cCurrUserId + "' BY cContext") NO-ERROR.
IF ERROR-STATUS:GET-MESSAGE(1) = "" THEN DO:
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  IF hBuffer:AVAIL AND hBuffer::cContext = "" THEN cContextList = "|".
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    ASSIGN ocReturn     = ocReturn + hBuffer:BUFFER-FIELD("cSetting"):BUFFER-VALUE + CHR(1)
           cContextList = cContextList + (IF LOOKUP(hBuffer::cContext,cContextList,"|") = 0 THEN hBuffer::cContext + "|" ELSE "").
    hQuery:GET-NEXT().
  END.
END.
ELSE bOk = NO.

IF LENGTH(cContextList) > 0 THEN
  cContextList = SUBSTR(cContextList,1,LENGTH(cContextList) - 1). 

DELETE OBJECT hQuery.
DELETE OBJECT hBuffer.

IF NOT bOk THEN
  RETURN "Invalid query for user setting".
ELSE 
  RETURN cContextList.
