DEF INPUT PARAM  irJBoxUserGroup  AS ROWID NO-UNDO.
DEF INPUT PARAM  icMenuItem     AS CHAR  NO-UNDO.
DEF INPUT PARAM  icSessionId    AS CHAR  NO-UNDO.
DEF OUTPUT PARAM ocReturn       AS CHAR  NO-UNDO INIT "no".

DEF VAR hbJBoxUserGroup AS HANDLE NO-UNDO.
DEF VAR hbJBoxUserMenu  AS HANDLE NO-UNDO.
DEF VAR bFound          AS LOG NO-UNDO.

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUserGroup",OUTPUT hbJBoxUserGroup) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUserMenu",OUTPUT hbJBoxUserMenu) THEN RETURN.

bFound = hbJBoxUserGroup:FIND-BY-ROWID (irJBoxUserGroup, NO-LOCK) NO-ERROR.
IF bFound THEN DO:
  
  bFound = hbJBoxUserMenu:FIND-FIRST("WHERE JBoxUserMenu.iJBoxMenuId = " + icMenuItem
                                   + " AND JBoxUserMenu.iJBoxUserGroupId = " + STRING(hbJBoxUserGroup::iJBoxUserGroupId),NO-LOCK) NO-ERROR.
  IF bFound THEN
    ocReturn = STRING(hbJBoxUserMenu::bWriteAccess).
END.

FINALLY:
  DELETE OBJECT hbJBoxUserGroup NO-ERROR.
  DELETE OBJECT hbJBoxUserMenu NO-ERROR.  
END FINALLY.