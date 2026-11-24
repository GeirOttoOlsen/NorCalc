FIND FIRST npkunde WHERE npkunde.kundenavn BEGINS 'nor-shunt'.
FOR EACH npkontakt:
  ASSIGN     
    iNPkontaktid = NEXT-VALUE(seqNPkontaktid)
    npkontakt.kundenr = npkunde.kundenr
    .
  IF num-entries(kontaktperson,' ') = 2 THEN
  DO:
    ASSIGN 
      fornavn   = ENTRY(1,kontaktperson,' ')
      etternavn = ENTRY(2,kontaktperson,' ')
      .  
  END.
  IF num-entries(kontaktperson,' ') = 3 THEN
  DO:
    ASSIGN 
      fornavn   = ENTRY(1,kontaktperson,' ') + ' ' + ENTRY(2,kontaktperson,' ')
      etternavn = ENTRY(3,kontaktperson,' ')
      .  
      
  END.
END.
