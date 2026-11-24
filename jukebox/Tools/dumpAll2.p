DEF VAR hb AS HANDLE NO-UNDO.


FUNCTION getFileOutputCat RETURNS CHARACTER():
  RETURN "c:\temp".
END.

FOR EACH _File NO-LOCK
    WHERE _tbl-type = "T"
      AND _File-name = "Eiendom":
  CREATE BUFFER hb FOR TABLE _File-name.
  RUN toexcelviafile.p(hb,-4).
  DELETE OBJECT hb.
END.

