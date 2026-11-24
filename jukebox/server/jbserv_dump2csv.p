/* You can use a static temp-table on the server and transfer the handle to it like you would do with a dynamic.
   There are orders not assigned to salesrep in the db. Hence the extra loop.

   Created: 09/04/24 by brynj
-----------------------------------------------------------------*/

DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatesession.i}

DEF VAR hBuffer   AS HANDLE NO-UNDO.
DEF VAR hQuery    AS HANDLE NO-UNDO.
DEF VAR ix        AS INT    NO-UNDO.
DEF VAR htt       AS HANDLE NO-UNDO.
DEF VAR hDateFlds AS HANDLE NO-UNDO EXTENT.
DEF VAR iNumDates AS INT    NO-UNDO.

CREATE BUFFER hBuffer FOR TABLE icParam.

CREATE QUERY hQuery.

hQuery:SET-BUFFERS(hBuffer).
hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME + " NO-LOCK").

DO ix = 1 TO hBuffer:NUM-FIELDS:
  IF hBuffer:BUFFER-FIELD(ix):DATA-TYPE BEGINS "date" THEN
    iNumDates = iNumDates + 1.   
END.

EXTENT(hDateFlds) = iNumDates.

CREATE TEMP-TABLE htt.

iNumDates = 0.

DO ix = 1 TO hBuffer:NUM-FIELDS:
  IF NOT hBuffer:BUFFER-FIELD(ix):DATA-TYPE BEGINS "date" THEN 
    htt:ADD-LIKE-FIELD (hBuffer:BUFFER-FIELD(ix):NAME, hBuffer:BUFFER-FIELD(ix):HANDLE).
  ELSE DO:
    iNumDates = iNumDates + 1.
    hDateFlds[iNumDates] = hBuffer:BUFFER-FIELD(ix).
    htt:ADD-NEW-FIELD(hBuffer:BUFFER-FIELD(ix):NAME,"CHARACTER").
  END.  
END.    
htt:TEMP-TABLE-PREPARE(hBuffer:NAME).
ihBuffer = htt:DEFAULT-BUFFER-HANDLE.

hQuery:QUERY-OPEN ().

REPEAT WHILE hQuery:GET-NEXT():
  ihBuffer:BUFFER-CREATE ().
  ihBuffer:BUFFER-COPY(hBuffer).  
  DO ix = 1 TO iNumDates:
    IF hDateFlds[ix]:BUFFER-VALUE = ? THEN
      ihBuffer:BUFFER-FIELD(hDateFlds[ix]:NAME):BUFFER-VALUE = "NULL".
    ELSE
      ihBuffer:BUFFER-FIELD(hDateFlds[ix]:NAME):BUFFER-VALUE = STRING(ISO-DATE(hDateFlds[ix]:BUFFER-VALUE)).
  END.
END.

FINALLY:
  DELETE OBJECT hBuffer NO-ERROR.
  DELETE OBJECT hQuery NO-ERROR.
  obOk = ocReturn = "".
END.    
