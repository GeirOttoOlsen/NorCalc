/* Save menu favorites
  
  Created 05 jan 12 by brynjar@chemistry.no
-----------------------------------------------------------------------*/                                                                         
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR cUserId              AS CHAR NO-UNDO.
DEF VAR cMenuIdList          AS CHAR NO-UNDO.
DEF VAR cType                AS CHAR NO-UNDO.
DEF VAR ix                   AS INT  NO-UNDO.
DEF VAR hbJBoxMenuFavorites  AS HANDLE NO-UNDO.
DEF VAR hQuery               AS HANDLE NO-UNDO.
DEF VAR hFldType             AS HANDLE NO-UNDO.
DEF VAR hbJBoxMenu           AS HANDLE NO-UNDO.
DEF VAR bFound               AS LOG    NO-UNDO.

ASSIGN cUserId     = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE)
       cMenuIdList = ENTRY(1,icParam,";")
       .

{incl/validatecaller.i}

IF NUM-ENTRIES(icParam,";") > 1 THEN
  cType = ENTRY(2,icParam,";").

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxMenuFavorites",OUTPUT hbJBoxMenuFavorites) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxMenu",OUTPUT hbJBoxMenu) THEN RETURN.

hFldType = hbJBoxMenuFavorites:BUFFER-FIELD("cType") NO-ERROR.

DO TRANSACTION:

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hbJBoxMenuFavorites).
  hQuery:QUERY-PREPARE("FOR EACH " + hbJBoxMenuFavorites:NAME 
                     + " WHERE cJBoxUserId = '" + cUserId
                     + (IF VALID-HANDLE(hFldType) THEN "' AND cType = '" + cType ELSE "") 
                     + "' AND NOT CAN-DO('" + cMenuIdList + "',STRING(iJBoxMenuId))").
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    hbJBoxMenuFavorites:FIND-CURRENT(EXCLUSIVE-LOCK) NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN
      hbJBoxMenuFavorites:BUFFER-DELETE().
    hQuery:GET-NEXT().
  END.

  DO ix = 1 TO NUM-ENTRIES(cMenuIdList):
    bFound = hbJBoxMenu:FIND-FIRST("WHERE JBoxMenu.iJBoxMenuId = " + ENTRY(ix,cMenuIdList),NO-LOCK) NO-ERROR.
        
    IF bFound THEN DO:
      hbJBoxMenuFavorites:FIND-FIRST("WHERE cJBoxUserId = '" + cUserId 
                                  + "' AND iJBoxMenuId = " + ENTRY(ix,cMenuIdList) 
                                  + (IF VALID-HANDLE(hFldType) THEN " AND cType = '" + cType + "'" ELSE "")
                                   ,NO-LOCK) NO-ERROR.
      IF NOT hbJBoxMenuFavorites:AVAIL THEN DO:
        hbJBoxMenuFavorites:BUFFER-CREATE().
        ASSIGN hbJBoxMenuFavorites:BUFFER-FIELD("iJBoxMenuId"):BUFFER-VALUE = INT(ENTRY(ix,cMenuIdList))
               hbJBoxMenuFavorites:BUFFER-FIELD("cJBoxUserId"):BUFFER-VALUE = cUserId
               hbJBoxMenuFavorites:BUFFER-FIELD("iSeq"):BUFFER-VALUE = ix
               hbJBoxMenuFavorites:BUFFER-FIELD("dCreated"):BUFFER-VALUE = TODAY
               hbJBoxMenuFavorites:BUFFER-FIELD("cCreatedBy"):BUFFER-VALUE = cUserId
               NO-ERROR.
        IF VALID-HANDLE(hFldType) THEN
          hFldType:BUFFER-VALUE = cType.
      END.
    END.
  END.
END.

FINALLY:
  DELETE OBJECT hQuery NO-ERROR.
  DELETE OBJECT hbJBoxMenu NO-ERROR.
  DELETE OBJECT hbJBoxMenuFavorites NO-ERROR.
  
  obOK = ocReturn = "".
END.  

