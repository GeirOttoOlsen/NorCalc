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

FOR EACH tt BREAK BY pnr:
    IF FIRST-OF(tt.pnr) THEN
    DO:
      IF tt.pnr = 0 THEN UNDO, NEXT.
      CREATE postnummer.
      ASSIGN 
          postnummer.cPostnr = STRING(tt.pnr)
          postnummer.cPostSted   = tt.sted
          postnummer.kommunekode = string(tt.kkode)
          postnummer.cLandkode   = 'NO'
          postnummer.latitude    = tt.lat
          postnummer.longitude   = tt.longi
          postnummer.postnummerkategorikode = tt.kkat
          .
    END.
END.
