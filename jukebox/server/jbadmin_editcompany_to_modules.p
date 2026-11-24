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

DEF VAR ix                     AS INT     NO-UNDO.
DEF VAR iModuleId              AS INT     NO-UNDO.
DEF VAR cCompanyList           AS CHAR    NO-UNDO.
DEF VAR hbJBoxAppModuleCompany AS HANDLE  NO-UNDO.
DEF VAR hqAppMod               AS HANDLE  NO-UNDO.
DEF VAR bFound                 AS lOGICAL NO-UNDO.

ASSIGN iModuleId    = INTEGER(ENTRY(1,icParam,";"))
       cCompanyList = ENTRY(2,icParam,";")
       .

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxAppModuleCompany",OUTPUT hbJBoxAppModuleCompany) THEN RETURN.

CREATE QUERY hqAppMod.
hqAppMod:SET-BUFFERS(hbJBoxAppModuleCompany).

DO TRANSACTION:
  hqAppMod:QUERY-PREPARE("FOR EACH JBoxAppModuleCompany EXCLUSIVE-LOCK WHERE JBoxAppModuleCompany.iJBoxAppModuleId = " + STRING(iModuleId)).
  hqAppMod:QUERY-OPEN ().
  REPEAT WHILE hqAppMod:GET-NEXT ():
    IF LOOKUP(STRING(hbJBoxAppModuleCompany::iJBoxCompanyId),cCompanyList,"|") = 0 THEN
      hbJBoxAppModuleCompany:BUFFER-DELETE().
  END.
  DO ix = 1 TO NUM-ENTRIES(cCompanyList,"|"):
    bFound = hbJBoxAppModuleCompany:FIND-FIRST("WHERE JBoxAppModuleCompany.iJBoxAppModuleId = " + STRING(iModuleId)
                                             + " AND JBoxAppModuleCompany.iJBoxCompanyId = INT('" + ENTRY(ix,cCompanyList,"|") + "')",NO-LOCK)
                                    NO-ERROR.
    IF NOT bFound THEN DO:
      hbJBoxAppModuleCompany:BUFFER-CREATE ().
      ASSIGN hbJBoxAppModuleCompany::iJBoxAppModuleId = iModuleId
             hbJBoxAppModuleCompany::iJBoxCompanyId   = INT(ENTRY(ix,cCompanyList,"|"))
             .
    END.
  END.
END.

IF ocReturn = "" THEN obOk = TRUE.

FINALLY:
  DELETE OBJECT hqAppMod NO-ERROR.
  DELETE OBJECT hbJBoxAppModuleCompany NO-ERROR.
END FINALLY.