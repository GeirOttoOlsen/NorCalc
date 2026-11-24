/* Update table-to-table link
   Parameters:  <parentid>|<childid-list>

   Created: 23/06/16 by goo_000
-----------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER icParam     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER ihBuffer    AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER icSessionId AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER ocReturn    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER obOK        AS LOG NO-UNDO.

DEFINE VARIABLE ix      AS INTEGER NO-UNDO.
DEFINE VARIABLE iPersonId AS INTEGER NO-UNDO.
DEFINE VARIABLE iGruppeId AS INTEGER NO-UNDO.
ASSIGN 
  iGruppeId = int(ENTRY(1,icParam,"|"))
  .
DO TRANSACTION:  
  FOR EACH PersonGruppe EXCLUSIVE-LOCK WHERE PersonGruppe.iGruppeId = iGruppeId, FIRST person OF PersonGruppe:
    IF LOOKUP(STRING(ROWID(person)),icParam,"|") = 0 or LOOKUP(STRING(ROWID(person)),icParam,"|") = ? THEN DELETE PersonGruppe.
  END.
  if num-entries(icParam,'|') = 2 and entry(2,icParam,'|') = '' then  
  do:
    /*Første element er Personid, resterende er knyttning, når den er 2 og nummer 2 er blank, vil det si at det ikke finnes grupper, alt skal slettes*/
    for each PersonGruppe where PersonGruppe.iGruppeId = iGruppeId:
      delete PersonGruppe.
    end.
  end.
  else
  DO ix = 2 TO NUM-ENTRIES(icParam,'|'):
    FIND FIRST person WHERE ROWID(person) = to-rowid(ENTRY(ix,icParam,'|')) NO-LOCK no-error.
    iPersonId = IF AVAILABLE person THEN Person.iPersonId ELSE 0.
    FIND PersonGruppe WHERE PersonGruppe.iPersonId = iPersonId 
      AND PersonGruppe.iGruppeId = iGruppeId NO-LOCK NO-ERROR.
    IF NOT AVAILABLE PersonGruppe THEN 
    DO:
      CREATE PersonGruppe.
      ASSIGN 
        PersonGruppe.iPersonId = iPersonId
        PersonGruppe.iGruppeId = iGruppeId
        .
    END.
  END.
END.

obOk = ocReturn = "".

