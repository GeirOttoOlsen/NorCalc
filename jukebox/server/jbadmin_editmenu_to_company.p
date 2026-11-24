/* Update company to menu link
   Parameters:  <menuid>|<companyidlist> 
      
   Created:  01.05.08 by Brynjar Hasle     
   Modified: 26.06.13 by Brynjar
             Support of parameter value pairs like <id|write access|id|write access|id..>            
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix              AS INT    NO-UNDO.
DEF VAR iMenuId         AS INT    NO-UNDO.
DEF VAR cCompanyIdList  AS CHAR   NO-UNDO.
DEF VAR cUserId         AS CHAR   NO-UNDO.
DEF VAR hWriteAccess    AS HANDLE NO-UNDO.
DEF VAR hbJBoxCompanyMenu AS HANDLE NO-UNDO.
DEF VAR hqCompMenu        AS HANDLE NO-UNDO.
DEF VAR bFound            AS LOG  NO-UNDO. 

{incl/validatecaller.i}

ASSIGN iMenuId         = INT(ENTRY(1,icParam,";"))
       cCompanyIdList  = ENTRY(2,icParam,";")
       cUserId         = DYNAMIC-FUNCTION("getAsUserId" IN SOURCE-PROCEDURE)
       .
     
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxCompanyMenu",OUTPUT hbJBoxCompanyMenu) THEN RETURN.
              
hWriteAccess = hbJBoxCompanyMenu:BUFFER-FIELD("bWriteAccess") NO-ERROR.

CREATE QUERY hqCompMenu.
hqCompMenu:SET-BUFFERS (hbJBoxCompanyMenu).

DO TRANSACTION:
  hqCompMenu:QUERY-PREPARE("FOR EACH JBoxCompanyMenu EXCLUSIVE-LOCK WHERE JBoxCompanyMenu.iJBoxMenuId = " + STRING(iMenuId)).
  hqCompMenu:QUERY-OPEN ().
  REPEAT WHILE hqCompMenu:GET-NEXT():
    IF LOOKUP(STRING(hbJBoxCompanyMenu::iJBoxCompanyId),cCompanyIdList,"|") = 0 THEN
      hbJBoxCompanyMenu:BUFFER-DELETE.
  END.
  IF VALID-HANDLE(hWriteAccess) THEN
    DO ix = 1 TO NUM-ENTRIES(cCompanyIdList,"|") BY 2:
      bFound = hbJBoxCompanyMenu:FIND-FIRST("WHERE JBoxCompanyMenu.iJBoxMenuId = " + STRING(iMenuId)
                                          + " AND JBoxCompanyMenu.iJBoxCompanyId = " + ENTRY(ix,cCompanyIdList,"|"),EXCLUSIVE-LOCK,NO-WAIT) NO-ERROR.
      IF NOT bFound THEN DO:
        hbJBoxCompanyMenu:BUFFER-CREATE().
        ASSIGN hbJBoxCompanyMenu::iJBoxMenuId      = iMenuId
               hbJBoxCompanyMenu::iJBoxCompanyId   = INT(ENTRY(ix,cCompanyIdList,"|"))
               hbJBoxCompanyMenu::dCreated         = TODAY
               hbJBoxCompanyMenu::cCreatedBy       = cUserId
               .
      END.
      hWriteAccess:BUFFER-VALUE = LOGICAL(ENTRY(ix + 1,cCompanyIdList,"|")).
    END.
  ELSE
    DO ix = 1 TO NUM-ENTRIES(cCompanyIdList,"|"):
      bFound = hbJBoxCompanyMenu:FIND-FIRST("WHERE JBoxCompanyMenu.iJBoxMenuId = " + STRING(iMenuId)
                                          + " AND JBoxCompanyMenu.iJBoxCompanyId = " + ENTRY(ix,cCompanyIdList,"|"),NO-LOCK) NO-ERROR.
      IF NOT bFound THEN DO:
        hbJBoxCompanyMenu:BUFFER-CREATE().
        ASSIGN hbJBoxCompanyMenu::iJBoxMenuId      = iMenuId
               hbJBoxCompanyMenu::iJBoxCompanyId   = INT(ENTRY(ix,cCompanyIdList,"|"))
               hbJBoxCompanyMenu::dCreated         = TODAY
               hbJBoxCompanyMenu::cCreatedBy       = cUserId
               .
      END.
    END.
END.

IF ocReturn = "" THEN obOk = TRUE.

FINALLY:
  DELETE OBJECT hqCompMenu NO-ERROR.
  DELETE OBJECT hbJBoxCompanyMenu NO-ERROR.      
END FINALLY.