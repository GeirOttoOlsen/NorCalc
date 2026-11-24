DEF VAR cFlds AS CHAR INIT '
	"POSITION" Integer NOT NULL, 
	"ORGANISASJONSNUMMER" Integer, 
	"NAVN" VarChar, 
	"KODE" VarChar, 
	"BESKRIVELSE" VarChar, 
	"HREF" VarChar, 
	"REGISTRERINGSDATOENHETSREGISTERET" Date, 
	"REGISTRERTIMVAREGISTERET" Boolean, 
	"BESKRIVELSE_1" VarChar, 
	"KODE_1" Double, 
	"ANTALLANSATTE" Integer, 
	"LAND" VarChar, 
	"LANDKODE" VarChar, 
	"POSTNUMMER" Integer, 
	"POSTSTED" VarChar, 
	"KOMMUNE" VarChar, 
	"KOMMUNENUMMER" Integer, 
	"KODE_2" Integer, 
	"BESKRIVELSE_2" VarChar, 
	"REGISTRERTIFORETAKSREGISTERET" Boolean, 
	"REGISTRERTISTIFTELSESREGISTERET" Boolean, 
	"REGISTRERTIFRIVILLIGHETSREGISTERET" Boolean, 
	"KONKURS" Boolean, 
	"UNDERAVVIKLING" Boolean, 
	"UNDERTVANGSAVVIKLINGELLERTVANGSOPPLOSNING" Boolean, 
	"MAALFORM" VarChar, 
	"HREF_1" VarChar, 
	"STIFTELSESDATO" Date, 
	"LAND_1" VarChar, 
	"LANDKODE_1" VarChar, 
	"POSTNUMMER_1" Integer, 
	"POSTSTED_1" VarChar, 
	"KOMMUNE_1" VarChar, 
	"KOMMUNENUMMER_1" Integer, 
	"HREF_2" VarChar, 
	"HREF_3" VarChar, 
	"HREF_4" VarChar, 
	"HREF_5" VarChar, 
	"SIZE" Integer NOT NULL, 
	"TOTALELEMENTS" Integer, 
	"TOTALPAGES" Integer, 
	"NUMBER" Integer
'.

DEF VAR ix         AS INT NO-UNDO.
DEF VAR cEntry     AS CHAR NO-UNDO.
DEF VAR cTable     AS CHAR NO-UNDO.
DEF VAR cFileName  AS CHAR NO-UNDO INIT "c:\progress\jukebox\dbs\brreg.df".
DEF VAR cInput     AS CHAR NO-UNDO.
DEF VAR bReadFlds  AS LOG  NO-UNDO.
DEF VAR cFldName   AS CHAR NO-UNDO.
DEF VAR cFldType   AS CHAR NO-UNDO.
DEF VAR cFldFormat AS CHAR NO-UNDO.

cTable = "ENHETSREGISTERET_API_ENHETER".

cFlds = REPLACE(cFlds,'"','').

OUTPUT TO VALUE(cFileName).

PUT UNFORMATTED 'ADD TABLE "' cTable '"' SKIP.

DO ix = 1 TO NUM-ENTRIES(cFlds):
  cEntry = TRIM(ENTRY(ix,cFlds)).
  cFldName = SUBSTR(ENTRY(1,cEntry," "),1,32).
  cFldType = TRIM(ENTRY(2,cEntry," ")).
    CASE cFldType:
    WHEN "boolean" THEN 
      ASSIGN cFldType = "LOGICAL"
             cFldFormat = '  FORMAT "Ja/Nei"'.       
    WHEN "double" THEN 
      ASSIGN cFldType = "DECIMAL"
             cFldFormat = '  FORMAT "->>>,>>>,>>9.99"'.       
    WHEN "varchar" THEN 
      ASSIGN cFldType = "CHARACTER"
             cFldFormat = '  FORMAT "x(30)"'.              
    WHEN "nvarchar" THEN 
      ASSIGN cFldType = "CHARACTER"
             cFldFormat = '  FORMAT "x(30)"'.              
    WHEN "bit" THEN 
      ASSIGN cFldType = "INTEGER"
             cFldFormat = '  FORMAT "9"'.       
    WHEN "integer" THEN 
      ASSIGN cFldType = "INTEGER"
             cFldFormat = '  FORMAT "->>>>>>>>9"'.       
    WHEN "bigint" THEN 
      ASSIGN cFldType = "INT64"
             cFldFormat = '  FORMAT "->>>>>>>>>>9"'.       
    WHEN "date" THEN
      cFldFormat = '  FORMAT "99.99.9999"'.
    WHEN "datetime" THEN
      cFldFormat = '  FORMAT "99.99.9999 HH:MM:SS"'.
  END CASE.
  IF CAN-DO("value,status",cFldName) THEN
    cFldName = cFldName + "_".
  PUT UNFORMATTED 'ADD FIELD "' cFldName '" OF ' cTable " AS " cFldType SKIP.
  PUT UNFORMATTED cFldFormat SKIP(1).
END.  

OUTPUT CLOSE.

OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
