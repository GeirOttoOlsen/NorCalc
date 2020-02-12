/*********************************************************************
File:           defprint.p
Description:    Identify the default printer on the current machine. 
                This is for testing the Report Builder utility _prdef.p
**********************************************************************/
DEF VAR printer AS CHARACTER FORMAT "x(45)".
DEF VAR port AS CHARACTER FORMAT "x(20)".
DEF VAR success AS LOGICAL.

RUN aderb\_prdef.p (OUTPUT printer, OUTPUT port, OUTPUT success).

IF success THEN 
DO:
  DISPLAY printer port.
  PAUSE.
END.
ELSE 
  MESSAGE "_prdef failed" VIEW-AS ALERT-BOX ERROR.
