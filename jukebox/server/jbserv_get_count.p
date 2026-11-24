/* Process a set of records sent from the client

   Created: 01/03/24 by brynj

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEF VAR cDataSourceName AS CHAR NO-UNDO.
DEF VAR cDataSourceType AS CHAR NO-UNDO.
DEF VAR cDbName         AS CHAR NO-UNDO.
DEF VAR hQuery          AS HANDLE NO-UNDO.
DEF VAR hbttCnt         AS HANDLE NO-UNDO.
DEF VAR iCnt            AS INT    NO-UNDO.
DEF VAR iTotCnt         AS INT64  NO-UNDO.
DEF VAR iTableCnt       AS INT    NO-UNDO.
DEF VAR cMethod         AS CHAR   NO-UNDO.
DEF VAR iStartTime      AS INT  NO-UNDO. iStartTime = MTIME.

DEF VAR oSqlHelper AS oo.JBoxSqlQueryHelper NO-UNDO.


ASSIGN cDataSourceName = ENTRY(1,icParam,"|")
       cDataSourceType = ENTRY(2,icParam,"|")
       cDbName         = LC(ENTRY(3,icParam,"|"))
       .

IF NOT cDataSourceType MATCHES "*sql*" THEN DO:
  cMethod = "Aggregate".
  IF SEARCH(cDbName + "_aggregate_count.r") NE ? THEN
    RUN VALUE(cDbName + "_aggregate_count.r") (OUTPUT hbttCnt).
  ELSE IF PROGRESS = "full" AND PROVERSION > "12.3" THEN
    RUN genAndRunAggrCount.
  ELSE cMethod = "Dyn.query".     
END.   
ELSE IF cDataSourceType MATCHES "*sql*" THEN DO:
  cMethod = "SQL".
  oSqlHelper = NEW oo.JBoxSqlQueryHelper().
  oSqlHelper:SQLdb = cDataSourceName.
END.

CREATE QUERY hQuery.
hQuery:SET-BUFFERS(ihBuffer).
hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME + " NO-LOCK").
hQuery:QUERY-OPEN().

hQuery:GET-FIRST().
REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  IF VALID-HANDLE(hbttCnt) THEN DO:
    hbttCnt:FIND-FIRST("WHERE cTableName = '" + ihBuffer::cTableName + "'") NO-ERROR.
    IF hbttCnt:AVAIL THEN
      ihBuffer::iCount = hbttCnt::iCnt.
  END.       
  ELSE IF cDataSourceType MATCHES "*sql*" THEN DO: 
    oSqlHelper:SQLprimaryTable = ihBuffer::cTableName.
    ihBuffer::iCount = oSqlHelper:getReadCount().
  END.
  ELSE DO:
    RUN jbserv_getrecordcount.p (icSessionId,cDbName + "." + ihBuffer::cTableName,"",OUTPUT iCnt,OUTPUT ocReturn).
    ihBuffer::iCount = iCnt.
  END.
  iTotCnt = iTotCnt + ihBuffer::iCount.
  iTableCnt = iTableCnt + 1.
    
  hQuery:GET-NEXT().
END.


FINALLY:
  DELETE OBJECT hQuery.
  obOk = ocReturn = "".
  IF obOk THEN 
    ocReturn = "Table count: " + STRING(iTableCnt) + CHR(10) + "Total record count: " + STRING(iTotCnt,">>,>>>,>>>,>>9") + CHR(10) + "Elapse time: " + STRING((MTIME - iStartTime) / 1000)
             + CHR(10) + "Method: " + cMethod. 
END FINALLY.

PROCEDURE genAndRunAggrCount:

  DEF VAR cCntProg AS CHAR NO-UNDO.
  
  cCntProg = SESSION:TEMP-DIR + cDbName + "_aggregate_count.p".

  OUTPUT TO VALUE(cCntProg).

  PUT UNFORMATTED "DEF OUTPUT PARAM ohttCnt   AS HANDLE NO-UNDO." SKIP.
  
  PUT UNFORMATTED "DEF TEMP-TABLE ttCnt NO-UNDO" SKIP.
  PUT UNFORMATTED "    FIELD cTableName AS CHAR" SKIP. 
  PUT UNFORMATTED "    FIELD iCnt       AS INT64." SKIP(1). 
  
  PUT UNFORMATTED "ohttCnt = BUFFER ttCnt:HANDLE." SKIP(1).

  PUT UNFORMATTED "ETIME(YES)." SKIP(1).
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(ihBuffer).
  hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME + " NO-LOCK").
  hQuery:QUERY-OPEN().

  hQuery:GET-FIRST().
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    PUT UNFORMATTED "CREATE ttCnt." SKIP.
    PUT UNFORMATTED "ttCnt.cTableName = '" ihBuffer::cTableName "'." SKIP.
    PUT UNFORMATTED "AGGREGATE ttCnt.iCnt = COUNT(" cDbName "." ihBuffer::cTableName "." ihBuffer::cFieldName ") FOR " cDbName "." ihBuffer::cTableName "." SKIP.
    hQuery:GET-NEXT().
  END.
  
  OUTPUT CLOSE.
  
  RUN VALUE(cCntProg) (OUTPUT hbttCnt).
  
END.
