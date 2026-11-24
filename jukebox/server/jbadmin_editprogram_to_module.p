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
DEF VAR iProgramId   AS INT    NO-UNDO.
DEF VAR cModuleList  AS CHAR   NO-UNDO.
DEF VAR cUserId      AS CHAR   NO-UNDO.
DEF VAR hbJBoxAppModuleItem AS HANDLE NO-UNDO.
DEF VAR hqAppModuleItm      AS HANDLE NO-UNDO.
DEF VAR bFound              AS LOG    NO-UNDO.

ASSIGN iProgramId  = INTEGER(ENTRY(1,icParam,";"))
       cModuleList = ENTRY(2,icParam,";")
       cUserId     = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE)
       .

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxAppModuleItem",OUTPUT hbJBoxAppModuleItem) THEN RETURN.

CREATE QUERY hqAppModuleItm.
hqAppModuleItm:SET-BUFFERS (hbJBoxAppModuleItem).

DO TRANSACTION:
  hqAppModuleItm:QUERY-PREPARE ("FOR EACH JBoxAppModuleItem EXCLUSIVE-LOCK WHERE JBoxAppModuleItem.iJBoxAppProgramId = " + STRING(iProgramId)
                              + " AND JBoxAppModuleItem.iJBoxCompanyId = 0").
  hqAppModuleItm:QUERY-OPEN ().
  REPEAT WHILE hqAppModuleItm:GET-NEXT ():
    IF LOOKUP(STRING(hbJBoxAppModuleItem::iJBoxAppModuleId),cModuleList,"|") = 0 THEN
      hbJBoxAppModuleItem:BUFFER-DELETE ().
  END.
  DO ix = 1 TO NUM-ENTRIES(cModuleList,"|"):
    bFound = hbJBoxAppModuleItem:FIND-FIRST("WHERE JBoxAppModuleItem.iJBoxAppProgramId = " + STRING(iProgramId)
                                          + " AND JBoxAppModuleItem.iJBoxAppModuleId  = " + ENTRY(ix,cModuleList,"|")
                                          + " AND JBoxAppModuleItem.iJBoxCompanyId    = 0",NO-LOCK) NO-ERROR.
                                          
    IF NOT bFound THEN DO:
      hbJBoxAppModuleItem:BUFFER-CREATE().
      ASSIGN hbJBoxAppModuleItem::iJBoxAppProgramId = iProgramId
             hbJBoxAppModuleItem::iJBoxAppModuleId  = INT(ENTRY(ix,cModuleList,"|"))
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