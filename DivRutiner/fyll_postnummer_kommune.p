DEF TEMP-TABLE tt
    FIELD seq AS INT
    FIELD pnr AS INT
    FIELD sted AS CHAR
    FIELD fkode AS INT
    FIELD fnavn AS CHAR
    FIELD kkode AS INT
    FIELD ksted AS CHAR
    FIELD kkat AS CHAR
    FIELD kkatnavn AS CHAR
    FIELD lat AS CHAR
    FIELD longi AS CHAR
    INDEX seq IS PRIMARY UNIQUE seq
    .

DEF STREAM st.
DEF VAR i AS INT NO-UNDO.

FILE-INFO:FILE-NAME = "C:\Users\goo_000\Downloads\DimPostnummer.csv".
INPUT STREAM st FROM VALUE(FILE-INFO:FILE-NAME).

REPEAT:
  i = i + 1.
  CREATE tt.
  ASSIGN seq = i.
  IMPORT STREAM st DELIMITER ';' 
      tt.pnr 
      tt.sted
      tt.fkode
      tt.fnavn
      tt.kkode
      tt.ksted
      tt.kkat
      tt.kkatnavn
      tt.lat
      tt.longi
      .
END.

FOR EACH tt BREAK BY kkode:
    IF FIRST-OF(tt.kkode) THEN
    DO:
      IF tt.kkode = 0 THEN UNDO, NEXT.
      CREATE kommune.
      ASSIGN 
          kommune.kommunekode = STRING(tt.kkode)
          kommune.kommunenavn = tt.ksted
          kommune.distriktkode = STRING(fkode)
          .
    END.
END.
