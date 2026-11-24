/* get or put lookup settings 
   Created: 16/02/25 by Brynjar
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEF VAR hbJBoxLookupDef AS HANDLE NO-UNDO.
DEF VAR hQuery          AS HANDLE NO-UNDO.
DEF VAR cFileName       AS CHAR   NO-UNDO.
DEF VAR bUpdate         AS LOG    NO-UNDO.
DEF VAR hqDbTable       AS HANDLE NO-UNDO.

CREATE BUFFER hbJBoxLookupDef FOR TABLE "JBoxLookupDef" NO-ERROR.

IF NOT VALID-HANDLE(hbJBoxLookupDef) THEN DO:
  FILE-INFO:FILE-NAME = "config/settings".
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
    cFileName = FILE-INFO:FULL-PATHNAME + "/jboxlookupdef.json".
    IF icParam = "put" THEN
      ihBuffer:WRITE-JSON("file",cFileName).
    ELSE IF SEARCH(cFileName) NE ? THEN
      ihBuffer:READ-JSON("file",cFileName).
  END.    
END.  
ELSE IF icParam = "put" THEN DO TRANSACTION:
  
  CREATE QUERY hqDbTable.
  hqDbTable:SET-BUFFERS(hbJBoxLookupDef).
  hqDbTable:QUERY-PREPARE("FOR EACH " + hbJBoxLookupDef:NAME).
  hqDbTable:QUERY-OPEN ().
  REPEAT WHILE hqDbTable:GET-NEXT().
    ihBuffer:FIND-FIRST("WHERE DatasourceName = '" + hbJBoxLookupDef::DatasourceName + "'"
                       + " AND DatabaseName = '" + hbJBoxLookupDef::DatabaseName + "'"
                       + " AND TableName = '" + hbJBoxLookupDef::TableName + "'"
                       + " AND SourceProcName = '" + hbJBoxLookupDef::SourceProcName + "'"
                       + " AND FieldName = '" + hbJBoxLookupDef::FieldName + "'") NO-ERROR.
    IF NOT ihBuffer:AVAIL THEN DO:
      hbJBoxLookupDef:FIND-CURRENT(EXCLUSIVE-LOCK,NO-WAIT).
      IF hbJBoxLookupDef:AVAIL THEN
        hbJBoxLookupDef:BUFFER-DELETE ().
    END.                     
  END.
  DELETE OBJECT hqDbTable.

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(ihBuffer).
  hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME + " WHERE NOT sessionOnly").
  hQuery:QUERY-OPEN ().
  REPEAT WHILE hQuery:GET-NEXT().
    bUpdate = NO.
    hbJBoxLookupDef:FIND-FIRST("WHERE DatasourceName = '" + ihBuffer::DatasourceName + "'"
                              + " AND DatabaseName = '" + ihBuffer::DatabaseName + "'"
                              + " AND TableName = '" + ihBuffer::TableName + "'"
                              + " AND SourceProcName = '" + ihBuffer::SourceProcName + "'"
                              + " AND FieldName = '" + ihBuffer::FieldName + "'") NO-ERROR.
    IF NOT hbJBoxLookupDef:AVAIL THEN  
      hbJBoxLookupDef:BUFFER-CREATE().
    ELSE bUpdate = YES.
    hbJBoxLookupDef:BUFFER-COPY(ihBuffer).
    IF bUpdate THEN
      ASSIGN hbJBoxLookupDef::dModified = TODAY
             hbJBoxLookupDef::cModifiedBy = JBoxServerSide:Instance:UserId
             .
    ELSE         
      ASSIGN hbJBoxLookupDef::dCreated = TODAY
             hbJBoxLookupDef::cCreatedBy = JBoxServerSide:Instance:UserId
             .
                              
  END.
END.  
ELSE DO:
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hbJBoxLookupDef).
  hQuery:QUERY-PREPARE("FOR EACH " + hbJBoxLookupDef:NAME).
  hQuery:QUERY-OPEN ().
  REPEAT WHILE hQuery:GET-NEXT():
    ihBuffer:BUFFER-CREATE().
    ihBuffer:BUFFER-COPY(hbJBoxLookupDef).
  END.  
END.   

FINALLY:
  IF VALID-HANDLE(hQuery) THEN DELETE OBJECT hQuery.
  IF VALID-HANDLE(hbJBoxLookupDef) THEN DELETE OBJECT hbJBoxLookupDef.
  obOk = ocReturn = "".
END. 