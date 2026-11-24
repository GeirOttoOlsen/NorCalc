/* Roll back a change LOG 
  Created 28.01.08 by brynjar@chemistry.no
-----------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR hBuffer       AS HANDLE NO-UNDO EXTENT 20.
DEF VAR iBuffCnt      AS INT    NO-UNDO.
DEF VAR iCurrBuffer   AS INT    NO-UNDO.
DEF VAR ix            AS INT    NO-UNDO.
DEF VAR cBufferNames  AS CHAR   NO-UNDO.
DEF VAR cFindString   AS CHAR   NO-UNDO.
DEF VAR cField        AS CHAR   NO-UNDO.
DEF VAR cValue        AS CHAR   NO-UNDO.
DEF VAR hField        AS HANDLE NO-UNDO.
DEF VAR bOk           AS LOG    NO-UNDO.
DEF VAR hbJBoxChangeLogHeader AS HANDLE NO-UNDO.
DEF VAR hbJBoxChangeLog       AS HANDLE NO-UNDO.
DEF VAR hqChangeLog           AS HANDLE NO-UNDO.
DEF VAR cTable                AS CHAR   NO-UNDO.

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxChangeLogHeader",OUTPUT hbJBoxChangeLogHeader) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxChangeLog",OUTPUT hbJBoxChangeLog) THEN RETURN.

CREATE QUERY hqChangeLog.
hqChangeLog:SET-BUFFERS(hbJBoxChangeLog).

UndoChangeLog:
DO TRANSACTION ON ERROR UNDO, LEAVE.

  bOk = ihBuffer:FIND-FIRST("WHERE true",NO-LOCK) NO-ERROR.
  IF NOT bOk THEN DO:
    ocReturn = "Invalid changelog header".
    RETURN.
  END.

  bOK = hbJBoxChangeLogHeader:FIND-FIRST("WHERE JBoxChangeLogHeader.iJBoxChangeLogHeaderId = INT('" + STRING(ihBuffer::iJBoxChangeLogHeaderId) + "')",EXCLUSIVE-LOCK,NO-WAIT)
        NO-ERROR.
  IF NOT bOk THEN DO:
    ocReturn = "Changelog not available".
    RETURN.
  END.
  IF hbJBoxChangeLogHeader::dUndoDate NE ? THEN DO:
    ocReturn = "Changes are already undone".
    RETURN.
  END.

  ASSIGN hbJBoxChangeLogHeader::dUndoDate   = TODAY
         hbJBoxChangeLogHeader::iUndoTime   = TIME
         hbJBoxChangeLogHeader::dModified   = TODAY
         hbJBoxChangeLogHeader::cModifiedBy = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE).

  hqChangeLog:QUERY-PREPARE ("FOR EACH JBoxChangeLog NO-LOCK WHERE JBoxChangeLog.iJboxChangeLogHeaderId = " + STRING(hbJBoxChangeLogHeader::iJBoxChangeLogHeaderId)).
  hqChangeLog:QUERY-OPEN ().
  REPEAT WHILE hqChangeLog:GET-NEXT():
    IF NOT CAN-DO(cBufferNames,hbJBoxChangeLog::cTableChanged) THEN DO:
      ASSIGN iBuffCnt = iBuffCnt + 1
             cBufferNames = cBufferNames + (IF cBufferNames NE "" THEN "," ELSE "") + hbJBoxChangeLog::cTableChanged
             cTable = hbJBoxChangeLog::cTableChanged
             .
      CREATE BUFFER hBuffer[iBuffCnt] FOR TABLE cTable.
      iCurrBuffer = iBuffCnt.
    END.
    ELSE iCurrBuffer = LOOKUP(hbJBoxChangeLog::cTableChanged,cBufferNames).

   cFindString = "WHERE ".

    DO ix = 1 TO NUM-ENTRIES(hbJBoxChangeLog::cEntityIdFields):
      ASSIGN cField = ENTRY(ix,hbJBoxChangeLog::cEntityIdFields)
             cValue = ENTRY(ix,hbJBoxChangeLog::cEntityIdValues,"|")
             .
      hField = hBuffer[iCurrBuffer]:BUFFER-FIELD(cField) NO-ERROR.
      IF ERROR-STATUS:GET-MESSAGE(1) NE "" THEN DO:
        ocReturn = "Field " + cField + " does not exist in table " + hbJBoxChangeLog::cTableChanged.
        UNDO, LEAVE UndoChangeLog.
      END.
      CASE hField:DATA-TYPE:
           WHEN "character" THEN cFindString = cFindString + cField + " = '" + cValue + "' AND ".
           WHEN "date"      THEN cFindString = cFindString + cField + " = DATE('" + cValue + "') AND ".
           WHEN "decimal"   THEN cFindString = cFindString + cField + " = DECIMAL('" + cValue + "') AND ".
           WHEN "integer"   THEN cFindString = cFindString + cField + " = INTEGER('" + cValue + "') AND ".
           WHEN "logical"   THEN cFindString = cFindString + cField + " = LOGICAL('" + cValue + "') AND ".
      END CASE.
    END.

    cFindString = cFindString + "true".

    bOk = hBuffer[iCurrBuffer]:FIND-FIRST(cFindString,EXCLUSIVE-LOCK,NO-WAIT) NO-ERROR.
    IF hBuffer[iCurrBuffer]:LOCKED THEN DO:
      ocReturn = "Record " + cFindString + " in table " + hbJBoxChangeLog::cTableChanged + " is locked".
      UNDO, LEAVE UndoChangeLog.
    END.
    IF bOk THEN DO ix = 1 TO NUM-ENTRIES(hbJBoxChangeLog::cFieldsChanged):
      hField = hBuffer[iCurrBuffer]:BUFFER-FIELD(ENTRY(ix,hbJBoxChangeLog::cFieldsChanged)) NO-ERROR.
      IF ERROR-STATUS:GET-MESSAGE(1) NE "" THEN DO:
        ocReturn = "Field " + ENTRY(ix,hbJBoxChangeLog::cFieldsChanged) + " does not exist in table " + hbJBoxChangeLog::cTableChanged.
        UNDO, LEAVE UndoChangeLog.
      END.
      CASE hField:DATA-TYPE:
           WHEN "character" THEN hField:BUFFER-VALUE = ENTRY(ix,hbJBoxChangeLog::cFromValues,"|").
           WHEN "date"      THEN hField:BUFFER-VALUE = DATE(ENTRY(ix,hbJBoxChangeLog::cFromValues,"|")).
           WHEN "decimal"   THEN hField:BUFFER-VALUE = DECIMAL(ENTRY(ix,hbJBoxChangeLog::cFromValues,"|")).
           WHEN "integer"   THEN hField:BUFFER-VALUE = INTEGER(ENTRY(ix,hbJBoxChangeLog::cFromValues,"|")).
           WHEN "logical"   THEN hField:BUFFER-VALUE = LOGICAL(ENTRY(ix,hbJBoxChangeLog::cFromValues,"|")).
      END CASE.
    END.
  END.
END.

DO ix = 1 TO 20:
  IF VALID-HANDLE(hBuffer[ix]) THEN DELETE OBJECT hBuffer[ix] NO-ERROR.
END.

obOK = ocReturn = "".

FINALLY:
  DELETE OBJECT hbJBoxChangeLog NO-ERROR.
  DELETE OBJECT hbJBoxChangeLogHeader NO-ERROR.
  DELETE OBJECT hbJBoxChangeLog NO-ERROR.      
END FINALLY.