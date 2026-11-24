DEF VAR cFlds AS CHAR INIT "
CREATE TABLE [dbo].[ConsentOption](
	[ConsentOptionId] [int] IDENTITY(1,1) NOT NULL,
	[ExtConsentOptionId] [nvarchar](50) NOT NULL,
	[ProcessingDefinitionId] [int] NULL,
	[ConsentOptionTypeId] [int] NULL,
	[Name] [nvarchar](500) NULL,
	[Active] [bit] NULL CONSTRAINT [DF_ConsentOption_Active]  DEFAULT ((1)),
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ConsentOption_CreatedDate]  DEFAULT (getdate()),
".

DEF VAR ix         AS INT NO-UNDO.
DEF VAR cEntry     AS CHAR NO-UNDO.
DEF VAR cTable     AS CHAR NO-UNDO.
DEF VAR cFileName  AS CHAR NO-UNDO INIT "c:\prowrk\bafo\dump\consent.df".
DEF VAR cInput     AS CHAR NO-UNDO.
DEF VAR bReadFlds  AS LOG  NO-UNDO.
DEF VAR cFldName   AS CHAR NO-UNDO.
DEF VAR cFldType   AS CHAR NO-UNDO.
DEF VAR cFldFormat AS CHAR NO-UNDO.


INPUT FROM c:\prowrk\bafo\DUMP\script.sql.

OUTPUT TO VALUE(cFileName).

REPEAT:
  IMPORT UNFORMATTED cInput.
  IF cInput BEGINS "CREATE TABLE" THEN 
    RUN outputTable.
  ELSE IF cInput BEGINS CHR(9) + "[" AND bReadFlds THEN
    ASSIGN cInput = REPLACE(cInput,"[","")
           cFlds = cFlds + SUBSTR(cInput,2) + ";".      
  ELSE bReadFlds = NO.  
END.

RUN outputTable.

OUTPUT CLOSE.

OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).

PROCEDURE outputTable:

  IF cTable NE "" THEN DO:
    PUT UNFORMATTED 'ADD TABLE "' cTable '"' SKIP.
    DO ix = 1 TO NUM-ENTRIES(cFlds,";"):
      cEntry = ENTRY(ix,cFlds,";").
      cFldName = ENTRY(1,cEntry,"]").
      IF NUM-ENTRIES(cEntry,"]") > 1 THEN DO:
        cFldType = TRIM(ENTRY(2,cEntry,"]")).
        CASE cFldType:
          WHEN "nvarchar" THEN 
            ASSIGN cFldType = "CHARACTER"
                   cFldFormat  = SUBSTR(ENTRY(1,ENTRY(3,cEntry,"]"),")"),2)
                   cFldFormat = '  FORMAT "x(' + (IF cFldFormat = "max" OR INT(cFldFormat) > 80 THEN "80" ELSE cFldFormat) + ')"'.       
                   
          WHEN "bit" THEN 
            ASSIGN cFldType = "INTEGER"
                   cFldFormat = '  FORMAT "9"'.       
          WHEN "int" THEN 
            ASSIGN cFldType = "INTEGER"
                   cFldFormat = '  FORMAT "->>>>>>>>9"'.       
          WHEN "bigint" THEN 
            ASSIGN cFldType = "INT64"
                   cFldFormat = '  FORMAT "->>>>>>>>>>9"'.       
          WHEN "datetime" THEN
            cFldFormat = '  FORMAT "99.99.9999 HH:MM:SS"'.
        END CASE.
        IF CAN-DO("value,status",cFldName) THEN
          cFldName = cFldName + "_".
        PUT UNFORMATTED 'ADD FIELD "' cFldName '" OF ' cTable " AS " cFldType SKIP.
        PUT UNFORMATTED cFldFormat SKIP(1).
      END.
      ELSE PUT SKIP(1).  
    END.
  END.

  IF cInput BEGINS "CREATE TABLE" THEN 
    ASSIGN cTable = ENTRY(2,cInput,".")
           cTable = SUBSTR(ENTRY(1,cTable,"]"),2).
  cFlds = "".
  bReadFlds = YES.

END PROCEDURE.  
