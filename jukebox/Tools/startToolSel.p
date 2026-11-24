DEF VAR hToolsel AS HANDLE NO-UNDO.
RUN JBoxToolSelector.w PERSIST SET hToolSel.
JBoxSession:Instance:UseAdvGui = YES.
JBoxSession:Instance:setRowShadeColor(240,240,240).

SUBSCRIBE TO "InvalidateHandle" IN hToolSel.

WAIT-FOR System.Windows.Forms.Application:Run().

PROCEDURE InvalidateHandle:
  DEF INPUT PARAM ihProc AS HANDLE NO-UNDO.
  IF ihProc = hToolSel THEN
    QUIT.
END.    