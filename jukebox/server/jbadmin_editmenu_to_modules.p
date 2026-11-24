/* Update module-company link
   Parameters:  <module id>|<companylist> 
      
            + <ROWID>|<List of rowid's>
         OR + <List of primary keys >
         
         OR temp-table containing CustNum 
   
   Created: 18.01.11 by Brynjar Hasle                  
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix            AS INT    NO-UNDO.
DEF VAR iModuleId     AS INT    NO-UNDO.
DEF VAR cSubmenuList  AS CHAR   NO-UNDO.
DEF VAR cUserId       AS CHAR   NO-UNDO.
DEF VAR hbJBoxAppModuleItem AS HANDLE NO-UNDO.
DEF VAR hqAppModuleItm      AS HANDLE NO-UNDO.
DEF VAR bFound              AS LOG    NO-UNDO.

{incl/validatecaller.i}

ASSIGN iModuleId    = INTEGER(ENTRY(1,icParam,";"))
       cSubmenuList = ENTRY(2,icParam,";")
       cUserId      = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE)
       .
       
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxAppModuleItem",OUTPUT hbJBoxAppModuleItem) THEN RETURN.
       
CREATE QUERY hqAppModuleItm.
hqAppModuleItm:SET-BUFFERS(hbJBoxAppModuleItem).

DO TRANSACTION:
  hqAppModuleItm:QUERY-PREPARE("FOR EACH JBoxAppModuleItem EXCLUSIVE-LOCK WHERE JBoxAppModuleItem.iJBoxAppModuleId = " + STRING(iModuleId)
                             + " AND JBoxAppModuleItem.iJBoxMenuId > 0"
                             + " AND JBoxAppModuleItem.iJBoxCompanyId = 0").
  hqAppModuleItm:QUERY-OPEN ().
  REPEAT WHILE hqAppModuleItm:GET-NEXT ():                             
    IF LOOKUP(STRING(hbJBoxAppModuleItem::iJBoxMenuId),cSubmenuList,"|") = 0 THEN
      hbJBoxAppModuleItem:BUFFER-DELETE ().
  END.
  DO ix = 1 TO NUM-ENTRIES(cSubmenuList,"|"):
    bFound = hbJBoxAppModuleItem:FIND-FIRST("WHERE JBoxAppModuleItem.iJBoxAppModuleId = " + STRING(iModuleId)
                                          + " AND JBoxAppModuleItem.iJBoxMenuId = " + ENTRY(ix,cSubmenuList,"|"),NO-LOCK) NO-ERROR.
    IF NOT bFound THEN DO:
      hbJBoxAppModuleItem:BUFFER-CREATE ().
      ASSIGN hbJBoxAppModuleItem::iJBoxAppModuleId = iModuleId
             hbJBoxAppModuleItem::iJBoxMenuId      = INT(ENTRY(ix,cSubmenuList,"|"))
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
