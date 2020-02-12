/*********************************************************************
File:           printlst.p
Description:    List the available printers on current machine.
                This is for testing the Report Builder utility _prlist.p
**********************************************************************/
DEF VAR printer-list AS CHARACTER NO-UNDO.
DEF VAR port-list AS CHARACTER NO-UNDO.
DEF VAR i AS INTEGER NO-UNDO.
DEF VAR printer-count AS INTEGER NO-UNDO.
DEF VAR printer AS CHARACTER NO-UNDO FORMAT "x(30)".
DEF VAR port AS CHARACTER NO-UNDO FORMAT "x(12)".

RUN aderb\_prlist.p (OUTPUT printer-list, OUTPUT port-list, OUTPUT printer-count).

REPEAT i = 1 TO printer-count:
  printer = entry (i, printer-list).
  port = entry (i, port-list).
  DISPLAY i ")" printer port.
END.

PAUSE.

