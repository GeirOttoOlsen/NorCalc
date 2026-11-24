/* Clean up potential errors in menu from dump/load etc   
   Created 09 apr 10 by brynjar@chemistry.no
-----------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR iNext AS INT NO-UNDO.
DEF VAR hBuffUserMenu AS HANDLE NO-UNDO.

{incl/validatecaller.i}

DEF VAR hbJBoxMenu           AS HANDLE NO-UNDO.
DEF VAR hbJBoxMenuToMenu     AS HANDLE NO-UNDO.
DEF VAR bFound               AS LOG    NO-UNDO.
DEF VAR hqMenuToMenu         AS HANDLE NO-UNDO.
DEF VAR iSeqDbNum            AS INT NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxMenu",OUTPUT hbJBoxMenu) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxMenuToMenu",OUTPUT hbJBoxMenuToMenu) THEN RETURN.

iSeqDbNum = JBoxServerSide:Instance:getSequenceDbNum("seqJboxMenuId").
IF iSeqDbNum = 0 THEN RETURN.

CREATE BUFFER hBuffUserMenu FOR TABLE "JBoxUserMenu" NO-ERROR.

bFound = hbJBoxMenu:FIND-LAST ("WHERE iJBoxMenuId > -1",NO-LOCK) NO-ERROR.
IF bFound THEN DO:
  IF hbJBoxMenu::iJBoxMenuId > DYNAMIC-CURRENT-VALUE("seqJBoxMenuId",LDBNAME(iSeqDbNum)) THEN
    DYNAMIC-CURRENT-VALUE("seqJBoxMenuId",LDBNAME(iSeqDbNum)) = hbJBoxMenu::iJBoxMenuId.

  bFound = hbJBoxMenu:FIND-FIRST("WHERE JBoxMenu.iJBoxMenuId = 0",NO-LOCK) NO-ERROR.
  IF bFound THEN DO:
    iNext = DYNAMIC-NEXT-VALUE("seqJboxMenuId",LDBNAME(iSeqDbNum)).
    hbJBoxMenu::iJBoxMenuId = iNext.
    CREATE QUERY hqMenuToMenu.
    hqMenuToMenu:SET-BUFFERS (hbJBoxMenuToMenu).
    hqMenuToMenu:QUERY-PREPARE("FOR EACH JBoxMenuToMenu EXCLUSIVE-LOCK WHERE JBoxMenuToMenu.iFromMenuId = 0").
    hqMenuToMenu:QUERY-OPEN ().
    REPEAT WHILE hqMenuToMenu:GET-NEXT ():
      hbJBoxMenuToMenu::iFromMenuId = iNext.
    END.
    hqMenuToMenu:QUERY-PREPARE("FOR EACH JBoxMenuToMenu EXCLUSIVE-LOCK WHERE JBoxMenuToMenu.iToMenuId = 0").
    hqMenuToMenu:QUERY-OPEN ().
    REPEAT WHILE hqMenuToMenu:GET-NEXT ():
      hbJBoxMenuToMenu::iToMenuId = iNext.
    END.
  END.
END.

IF VALID-HANDLE(hBuffUserMenu) THEN DO:
  RUN jbsetup_fix_usermenu.p.
  DELETE OBJECT hBuffUserMenu.
END.
