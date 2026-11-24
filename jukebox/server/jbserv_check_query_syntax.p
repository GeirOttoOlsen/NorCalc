/* Check query syntax
   Parameters:  table|query string

   Created: 07/09/21 by Brynjar
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEF VAR hQuery     AS HANDLE NO-UNDO.
DEF VAR hBuffer    AS HANDLE NO-UNDO.

IF NUM-DBS = 0 THEN RETURN.

CREATE BUFFER hBuffer FOR TABLE ENTRY(1,icParam,CHR(1)) NO-ERROR.
IF ERROR-STATUS:GET-MESSAGE(1) NE "" THEN 
  ocReturn = ERROR-STATUS:GET-MESSAGE(1).
  
IF ocReturn = "" THEN DO:
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hBuffer).
  hQuery:QUERY-PREPARE("FOR EACH " + ENTRY(1,icParam,CHR(1)) + " " + ENTRY(2,icParam,CHR(1))) NO-ERROR.
  IF ERROR-STATUS:GET-MESSAGE(1) NE "" THEN 
    ocReturn = ERROR-STATUS:GET-MESSAGE(1).
END.

FINALLY:
  IF VALID-HANDLE(hQuery)  THEN DELETE OBJECT hQuery.
  IF VALID-HANDLE(hBuffer) THEN DELETE OBJECT hBuffer.
  obOk = ocReturn = "".
END FINALLY.
