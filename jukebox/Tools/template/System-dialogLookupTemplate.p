  DEF VAR cUseFileName AS CHAR NO-UNDO.
  DEF VAR bOk          AS LOG  NO-UNDO.

  cUseFileName = <field1>:SCREEN-VALUE.

  SYSTEM-DIALOG GET-FILE cUseFileName USE-FILENAME UPDATE bOk.
  IF bOk THEN 
    <field1>:SCREEN-VALUE = cUseFileName.  

