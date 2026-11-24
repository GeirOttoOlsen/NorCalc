/* Update module-company link
   Parameters:  <module id>|<companylist> 
      
            + <ROWID>|<List of rowid's>
         OR + <List of primary keys >
         
         OR temp-table containing CustNum 
   
   Created: 19.01.11 by Brynjar Hasle                  
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEF VAR ix           AS INT    NO-UNDO.
DEF VAR iModuleId    AS INT    NO-UNDO.
DEF VAR cProgramList AS CHAR   NO-UNDO.
DEF VAR cUserId      AS CHAR   NO-UNDO.
DEF VAR hbJBoxAppModuleItem AS HANDLE NO-UNDO.
DEF VAR hqAppModuleItm      AS HANDLE NO-UNDO.
DEF VAR bFound              AS LOG    NO-UNDO.

ASSIGN iModuleId    = INTEGER(ENTRY(1,icParam,";"))
       cProgramList = ENTRY(2,icParam,";")
       cUserId      = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE)
       .

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxAppModuleItem",OUTPUT hbJBoxAppModuleItem) THEN RETURN.

CREATE QUERY hqAppModuleItm.
hqAppModuleItm:SET-BUFFERS(hbJBoxAppModuleItem).

DO TRANSACTION:
  hqAppModuleItm:QUERY-PREPARE("FOR EACH JBoxAppModuleItem EXCLUSIVE-LOCK WHERE JBoxAppModuleItem.iJBoxAppModuleId = " + STRING(iModuleId)
                             + " AND JBoxAppModuleItem.iJBoxCompanyId = 0").
  hqAppModuleItm:QUERY-OPEN ().                           
  REPEAT WHILE hqAppModuleItm:GET-NEXT():
    IF LOOKUP(STRING(hbJBoxAppModuleItem::iJBoxAppProgramId),cProgramList,"|") = 0 THEN
      hbJBoxAppModuleItem:BUFFER-DELETE ().
  END.
  DO ix = 1 TO NUM-ENTRIES(cProgramList,"|"):
    bFound = hbJBoxAppModuleItem:FIND-FIRST("WHERE JBoxAppModuleItem.iJBoxAppModuleId = " + STRING(iModuleId)
                                          + " AND JBoxAppModuleItem.iJBoxAppProgramId = " + ENTRY(ix,cProgramList,"|")
                                          + " AND JBoxAppModuleItem.iJBoxCompanyId    = 0",NO-LOCK) NO-ERROR.
    IF NOT bFound THEN DO:
      hbJBoxAppModuleItem:BUFFER-CREATE ().
      ASSIGN hbJBoxAppModuleItem::iJBoxAppModuleId  = iModuleId
             hbJBoxAppModuleItem::iJBoxAppProgramId = INT(ENTRY(ix,cProgramList,"|"))
             hbJBoxAppModuleItem::dCreated          = TODAY
             hbJBoxAppModuleItem::cCreatedBy        = cUserId
             .
    END.
  END.
END.

IF ocReturn = "" THEN obOk = TRUE.

FINALLY:
  DELETE OBJECT hqAppModuleItm NO-ERROR.
  DELETE OBJECT hbJBoxAppModuleItem NO-ERROR.      
END FINALLY.
