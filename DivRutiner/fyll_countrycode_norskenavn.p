DEF TEMP-TABLE tt NO-UNDO
    FIELD seq AS INT
    FIELD toletter AS CHAR
    FIELD cname AS CHAR
    FIELD cnameshort AS CHAR
    INDEX seq IS PRIMARY UNIQUE seq.

DEF STREAM st.
DEF VAR i AS INT NO-UNDO.

FILE-INFO:FILE-NAME = "C:\Users\goo_000\Downloads\377.csv".
INPUT STREAM st FROM VALUE(FILE-INFO:FILE-NAME).

REPEAT:
  i = i + 1.
  CREATE tt.
  ASSIGN seq = i.
  IMPORT STREAM st DELIMITER ';' 
      tt.toletter 
      tt.cname
      tt.cnameshort
      .

END.

FOR EACH tt:
    FIND FIRST land WHERE land.cLandKode = tt.toletter NO-ERROR.
     IF AVAIL land THEN
      ASSIGN 
        land.cLand     = tt.cname
    .
END.
