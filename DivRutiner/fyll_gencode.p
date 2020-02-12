FIND FIRST jboxcompany WHERE jboxcompany.cCompanyname = 'Nor-Shunt AS'.
FIND FIRST jboxgencodetype WHERE jboxgencodetype.cCodeType = 'DropListSPBeskrevet'.
DISP jboxgencodetype.cCodeType.

FOR EACH npspanlg BREAK BY beskrevet:
    IF FIRST-OF(beskrevet) THEN DO:
      FIND FIRST jboxgencode WHERE jboxgencode.cCodeType = jboxgencodetype.cCodetype AND 
          jboxgencode.cCodeValue = npspanlg.beskrevet NO-ERROR.
      IF NOT AVAIL jboxgencode THEN
      DO:
        CREATE jboxgencode. 
        ASSIGN 
          jboxgencode.cCodevalue = npspanlg.beskrevet
          jboxgencode.cCodeType  = jboxgencodetype.cCodeType
          jboxgencode.ijboxcompanyid = jboxcompany.ijboxcompanyid
          jboxgencode.cLanguage = 'NO'

            .
      END.
    END.
END.
FOR EACH jboxgencode WHERE jboxgencode.cCodeType = jboxgencodetype.cCodeType:
    DISP jboxgencode WITH 1 COL.
END.
