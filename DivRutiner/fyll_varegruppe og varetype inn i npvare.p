FOR EACH npspsyst:
    IF npspsyst.produkttype NE '' THEN
    DO:
      FIND FIRST npvaretype WHERE npvaretype.varetypenavn = npspsyst.produkttype NO-ERROR.
      IF NOT AVAIL npVaretype THEN 
      DO:
          CREATE NPVareType.
          ASSIGN NPVareType.VareTypeNavn = npspsyst.produkttype.
      END.
    END.
    IF npspsyst.produktnavn NE '' THEN
    DO:
      FIND FIRST npvaregruppe WHERE npvaregruppe.vareGruppenavn = npspsyst.produktnavn NO-ERROR.
      IF NOT AVAIL npVareGruppe THEN 
      DO:
        CREATE NPVareGruppe.
        ASSIGN npVareGruppe.VareGruppeNavn = npspsyst.produktnavn
               npVareGruppe.VareGruppeAktiv = TRUE.
      END.

    FIND FIRST npspvareliste WHERE npspvareliste.varenr = npspsyst.varenr NO-ERROR.
    IF NOT AVAIL npspvareliste THEN
      FIND FIRST npspvareliste WHERE npspvareliste.nrf = npspsyst.nrf NO-ERROR.

    IF AVAIL npspvareliste THEN
    DO:
        IF npspsyst.produkttype NE '' THEN
        DO:
          IF AVAIL npvaretype THEN 
          do:
           FIND FIRST npvare WHERE npvare.varenr = npspvareliste.varenr NO-ERROR.
           IF NOT AVAIL npvare THEN
               FIND FIRST npvare WHERE npvare.nrfnr = npspvareliste.nrf NO-ERROR.
           IF AVAIL npvare THEN 
           do: 
               npvare.iNPVareTypeId = npvareType.iNPvareTypeid.
           END.
          END.
        END.
          IF AVAIL npvareGruppe THEN 
          do:
           FIND FIRST npvare WHERE npvare.varenr = npspvareliste.varenr NO-ERROR.
           IF NOT AVAIL npvare THEN
               FIND FIRST npvare WHERE npvare.nrfnr = npspvareliste.nrf NO-ERROR.
           IF AVAIL npvare THEN 
           do: 
               npvare.iNPVareGruppeId = npvareGruppe.iNPvareGruppeid.
           END.
          END.
        END.
    END.
  END.
    
                         /**
            FOR EACH npvare :
    FIND FIRST npspsyst WHERE npspsyst.varenr = npvare.varenr NO-ERROR.
    IF AVAIL npvaretype THEN 
    DO:
        MESSAGE npvare.varenr
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
      FIND FIRST npvaretype WHERE npvaretype.varetypenavn = npspsyst.produkttype NO-ERROR.
      IF AVAIL npvaretype THEN
      DO:
        npvare.inpvaretypeid = npvaretype.iNPvaretypeid.
      END.
    END.
END.


**/
