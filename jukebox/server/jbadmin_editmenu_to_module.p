/* Update module to menu link
   Parameters:  <menuid>|<moduleidlist> 
      
   Created: 20.01.11 by Brynjar Hasle                  
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix            AS INT   NO-UNDO.
DEF VAR iMenuId       AS INT   NO-UNDO.
DEF VAR cModuleIdList AS CHAR  NO-UNDO.
DEF VAR cUserId       AS CHAR  NO-UNDO.
DEF VAR hbJBoxAppModuleItem AS HANDLE NO-UNDO.
DEF VAR hqAppModuleItm      AS HANDLE NO-UNDO.
DEF VAR bFound              AS LOG    NO-UNDO.

{incl/validatecaller.i}

ASSIGN iMenuId        = INT(ENTRY(1,icParam,";"))
       cModuleIdList = ENTRY(2,icParam,";")
       cUserId        = DYNAMIC-FUNCTION("getAsUserId" IN SOURCE-PROCEDURE).

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxAppModuleItem",OUTPUT hbJBoxAppModuleItem) THEN RETURN.

CREATE QUERY hqAppModuleItm.
hqAppModuleItm:SET-BUFFERS(hbJBoxAppModuleItem).

DO TRANSACTION:
  hqAppModuleItm:QUERY-PREPARE ("FOR EACH JBoxAppModuleItem EXCLUSIVE-LOCK WHERE JBoxAppModuleItem.iJBoxMenuId = " + STRING(iMenuId)).
  hqAppModuleItm:QUERY-OPEN ().
  REPEAT WHILE hqAppModuleItm:GET-NEXT ().
    IF LOOKUP(STRING(hbJBoxAppModuleItem::iJBoxAppModuleId),cModuleIdList,"|") = 0 THEN
      hbJBoxAppModuleItem:BUFFER-DELETE ().
  END.
  DO ix = 1 TO NUM-ENTRIES(cModuleIdList,"|"):
    bFound = hbJBoxAppModuleItem:FIND-FIRST("WHERE JBoxAppModuleItem.iJBoxMenuId  = " + STRING(iMenuId)
                                          + " AND JBoxAppModuleItem.iJBoxAppModuleId = " + ENTRY(ix,cModuleIdList,"|"),NO-LOCK) NO-ERROR.
    IF NOT bFound THEN DO:
      hbJBoxAppModuleItem:BUFFER-CREATE().
      ASSIGN hbJBoxAppModuleItem::iJBoxMenuId      = iMenuId
             hbJBoxAppModuleItem::iJBoxAppModuleId = INT(ENTRY(ix,cModuleIdList,"|"))
             hbJBoxAppModuleItem::dCreated         = TODAY
             hbJBoxAppModuleItem::cCreatedBy       = cUserId
             .
    END.
  END.
END.

IF ocReturn = "" THEN obOk = TRUE.

FINALLY:
  DELETE OBJECT hqAppModuleItm NO-ERROR.
  DELETE OBJECT hbJBoxAppModuleItem NO-ERROR.      
END FINALLY.