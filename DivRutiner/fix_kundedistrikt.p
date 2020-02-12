DEF VAR nr AS INT NO-UNDO.
DEF VAR test AS INT NO-UNDO.
DEF VAR navn AS CHAR FORMAT "x(30)" NO-UNDO.

FOR EACH npkunde WITH FRAME f2:
    IF npkunde.kundedistrikt = '' THEN UNDO, NEXT.
    ASSIGN 
      nr = int(ENTRY(1,npkunde.kundedistrikt,'-'))
      navn = ENTRY(2,npkunde.kundedistrikt,'-')
      NO-ERROR
    .
    FIND FIRST npkundedistrikt WHERE npkundedistrikt.kundedistriktnr = nr.
    IF AVAIL npkundedistrikt THEN
        npkunde.kundedistriktnr = npkundedistrikt.kundedistriktnr.
    
END.
