DEF STREAM st.
DEF TEMP-TABLE tt LIKE NPvare.

RUN DUMP.
RUN LOAD.
RUN Fyll.

PROCEDURE DUMP:
OUTPUT STREAM st TO './vareliste.d'.
FOR EACH npspvareliste:
    EXPORT STREAM st DELIMITER ";" varenr produktnavn dimmensjon pris ror_dim vegg_tykkelse kv_verdi diameter kapasitet volum MAX_trykk MAX_Temp nrf_nr fast_tekst.
END.
OUTPUT STREAM st CLOSE.
END.

PROCEDURE LOAD:
    DEF VAR cVG AS CHAR NO-UNDO.
    DEF VAR cVT AS CHAR NO-UNDO.
    DEF VAR iSeq AS INT NO-UNDO.

    INPUT STREAM st FROM './vareliste.d'.
    REPEAT :
        CREATE tt.
        ASSIGN
            iSeq = iSeq + 1
            tt.iNPVareid = iSeq
            .
        IMPORT STREAM st DELIMITER ";" varenr cVG varenavn vareenhetspris varedimmensjon vareveggtykkelse varekvverdi varepipedim varekapasitet varevannkapasitet vareMAXtrykk vareMAXTemperatur nrfnr varebeskrivelse.
        FIND FIRST NPVaregruppe WHERE NPVaregruppe.VaregruppeNavn = cVG NO-ERROR.
        IF NOT AVAIL npVareGruppe THEN 
        DO:
            IF NOT AVAIL npVareGruppe THEN 
            DO:
              CREATE NPVareGruppe.
              ASSIGN npVareGruppe.VareGruppeNavn = cVG
                     npVareGruppe.VareGruppeAktiv = TRUE.
            END.

        END.
        FIND FIRST NPVareType   WHERE NPVareType.VareTypeNavn = cVT NO-ERROR.
        IF NOT AVAIL npVaretype THEN 
        DO:
            CREATE NPVareType.
            ASSIGN NPVareType.VareTypeNavn = cVT.
        END.

        ASSIGN
            tt.iNPVareGruppeId = IF AVAIL NPVareGruppe THEN NPVareGruppe.iNPVareGruppeId ELSE ?
            tt.iNPVareTypeId   = IF AVAIL NPVareType   THEN NPVareType.iNPVareTypeId ELSE ?
            tt.varenavn = cVG + ' ' + varenavn
       .
    END.
    INPUT STREAM st CLOSE.
END.

PROCEDURE Fyll:
    FOR EACH npVare:
        DELETE npVare.
    END.
    FOR EACH tt:
      CREATE npVare.
      BUFFER-COPY tt TO npVare.
    END.
END.
