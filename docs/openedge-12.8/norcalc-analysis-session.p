DEFINE BUFFER bField FOR _Field.
OUTPUT TO "norcalc-analysis-session.txt".
PUT UNFORMATTED PROVERSION "|" PDBNAME(1) "|" DBRESTRICTIONS(LDBNAME(1)) SKIP.
FOR EACH _File NO-LOCK WHERE _File._File-Number > 0 AND _File._File-Number < 32000:
  EXPORT DELIMITER "|" "TABLE" _File._File-Name _File._Dump-Name.
  FOR EACH _Field OF _File NO-LOCK:
    EXPORT DELIMITER "|" "FIELD" _File._File-Name _Field._Field-Name _Field._Data-Type _Field._Mandatory _Field._Extent.
  END.
  FOR EACH _Index OF _File NO-LOCK:
    EXPORT DELIMITER "|" "INDEX" _File._File-Name _Index._Index-Name _Index._Unique _Index._Active (_File._Prime-Index = RECID(_Index)).
    FOR EACH _Index-Field NO-LOCK WHERE _Index-Field._Index-Recid = RECID(_Index), FIRST bField NO-LOCK WHERE RECID(bField) = _Index-Field._Field-Recid:
      EXPORT DELIMITER "|" "INDEX-FIELD" _File._File-Name _Index._Index-Name _Index-Field._Index-Seq bField._Field-Name _Index-Field._Ascending.
    END.
  END.
END.
FOR EACH _Sequence NO-LOCK:
  EXPORT DELIMITER "|" "SEQUENCE" _Sequence._Seq-Name.
END.
OUTPUT CLOSE.
OUTPUT TO "norcalc-analysis-menu.txt".
FOR EACH JBoxMenu NO-LOCK:
 EXPORT DELIMITER "|" "NODE" iJBoxMenuId cMenuType cMenuLabel cLaunchType cLaunch iJBoxProgramId bDefault.
END.
FOR EACH JBoxMenuToMenu NO-LOCK:
 EXPORT DELIMITER "|" "LINK" iFromMenuId iToMenuId iSeq.
END.
OUTPUT CLOSE.
QUIT.
