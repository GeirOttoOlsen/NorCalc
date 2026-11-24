
DEF VAR hbJBoxUserMenu     AS HANDLE NO-UNDO.
DEF VAR bFound               AS LOG    NO-UNDO.
DEF VAR iSeqDbNum            AS INT NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUserMenu",OUTPUT hbJBoxUserMenu) THEN RETURN.

iSeqDbNum = JBoxServerSide:Instance:getSequenceDbNum("seqJboxUserMenuId").
IF iSeqDbNum = 0 THEN RETURN.


bFound = hbJBoxUserMenu:FIND-LAST ("WHERE iJBoxUserMenuId > -1 USE-INDEX idxUserMenuId", NO-LOCK) NO-ERROR. 
IF bFound THEN
  DYNAMIC-CURRENT-VALUE("seqJboxUserMenuId",LDBNAME(iSeqDbNum)) = hbJBoxUserMenu::iJBoxUserMenuId.

  
