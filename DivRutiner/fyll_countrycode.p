DEF TEMP-TABLE tt NO-UNDO
    FIELD seq AS INT
    FIELD cname AS CHAR
    FIELD toletter AS CHAR
    FIELD threeletter AS CHAR
    FIELD cnum AS INT
    INDEX seq IS PRIMARY UNIQUE seq.

DEF STREAM st.
DEF VAR i AS INT NO-UNDO.

FILE-INFO:FILE-NAME = "C:\Users\goo_000\Downloads\countrycode_toandthree_letters.csv".
INPUT STREAM st FROM VALUE(FILE-INFO:FILE-NAME).

REPEAT:
  i = i + 1.
  CREATE tt.
  ASSIGN seq = i.
  IMPORT STREAM st DELIMITER ';' 
      tt.cname 
      tt.toletter
      tt.threeletter
      tt.cnum
      .

END.

FOR EACH tt:
    CREATE Land.
    ASSIGN 
        land.cLandKode = tt.toletter
        land.ccountry     = tt.cname
        land.ciso3char    = tt.threeletter
        land.iCountryNum  = tt.cnum
    .
END.
