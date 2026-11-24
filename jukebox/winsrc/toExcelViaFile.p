USING System.Globalization.* FROM ASSEMBLY.

DEF INPUT PARAMETER ihObject   AS HANDLE NO-UNDO.  
DEF INPUT PARAMETER iiMaxCount AS INT NO-UNDO.

DEF VAR chExcelApplication      AS COM-HANDLE NO-UNDO.
DEF VAR chWorkbook              AS COM-HANDLE NO-UNDO.
DEF VAR chWorksheet             AS COM-HANDLE NO-UNDO.
DEF VAR iCount                  AS INTEGER NO-UNDO.
DEF VAR iColumn                 AS INTEGER INITIAL 1 NO-UNDO.

DEF VAR hQuery          AS WIDGET-HANDLE NO-UNDO.
DEF VAR hBuffer         AS WIDGET-HANDLE NO-UNDO.
DEF VAR hField          AS WIDGET-HANDLE NO-UNDO.
DEF VAR hColumn         AS HANDLE NO-UNDO.

DEF VAR cCurrDateFormat AS CHAR NO-UNDO.
DEF VAR cCurrNumFormat  AS CHAR NO-UNDO.
DEF VAR cFileName       AS CHAR NO-UNDO.
DEF VAR cOutput         AS CHAR NO-UNDO.
DEF VAR bOk             AS LOG NO-UNDO.
DEF VAR fDec            AS DEC FORMAT "->>,>>>,>>>,>>9.99".      
DEF VAR ix              AS INT NO-UNDO.
DEF VAR cTmpFileName    AS CHAR NO-UNDO.
DEF VAR bUseExcel       AS LOG  NO-UNDO INIT YES.
DEF VAR cNumSep         AS CHAR NO-UNDO.
DEF VAR cNumDec         AS CHAR NO-UNDO.
DEF VAR bOpenFile       AS LOG  NO-UNDO INIT YES.
DEF VAR cDelimiter      AS CHAR NO-UNDO INIT "~t".
DEF VAR bIncludeRowid   AS LOG NO-UNDO.

IF NOT VALID-HANDLE(ihObject) THEN RETURN.
IF ihObject:TYPE = "TEMP-TABLE" THEN ihObject = ihObject:DEFAULT-BUFFER-HANDLE.

IF iiMaxCount = -2 THEN bUseExcel = NO.
ELSE IF iiMaxCount = -3 THEN bOpenFile = NO.
ELSE IF iiMaxCount = -4 THEN
  ASSIGN bOpenFile = NO
         cDelimiter = "|".
ELSE IF iiMaxCount = -5 THEN
  bIncludeRowid = YES.         

ASSIGN cCurrDateFormat = SESSION:DATE-FORMAT
       cCurrNumFormat  = SESSION:NUMERIC-FORMAT
       cNumSep         = SESSION:NUMERIC-SEPARATOR
       cNumDec         = SESSION:NUMERIC-DECIMAL-POINT
       cFileName       = SESSION:TEMP-DIR 
                       + (IF ihObject:TYPE = "buffer" AND ihObject:NAME NE ? THEN ihObject:NAME + "_" ELSE "")
                       + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY)) + STRING(TIME) 
                       + (IF cDelimiter = "~t" THEN ".xls" ELSE ".data")
       .

IF CAN-DO(SOURCE-PROCEDURE:INTERNAL-ENTRIES,"getFileOutputCat") THEN
  cFileName = TRIM(DYNAMIC-FUNCTION("getFileOutputCat" IN SOURCE-PROCEDURE),"\/") + "/" 
            + (IF ihObject:TYPE = "buffer" AND ihObject:NAME NE ? THEN ihObject:NAME ELSE STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY)) + STRING(TIME)) 
            + (IF cDelimiter = "~t" THEN ".xls" ELSE ".data")
            .

SESSION:SET-NUMERIC-FORMAT(CultureInfo:CurrentCulture:NumberFormat:NumberGroupSeparator,  /* -numsep / SESSION:NUMERIC-SEPARATOR */
                           CultureInfo:CurrentCulture:NumberFormat:NumberDecimalSeparator /* -numdec / SESSION:NUMERIC-DECIMAL-POINT */ ).

IF CAN-DO(SOURCE-PROCEDURE:INTERNAL-ENTRIES,"getExportFileName") THEN DO:
  cTmpFileName = DYNAMIC-FUNCTION("getExportFileName" IN SOURCE-PROCEDURE).
  IF cTmpFileName NE "" THEN cFileName = cTmpFileName.
END.
IF CAN-DO(SOURCE-PROCEDURE:INTERNAL-ENTRIES,"getExportDelimiter") THEN DO:
  cDelimiter = DYNAMIC-FUNCTION("getExportDelimiter" IN SOURCE-PROCEDURE).
  IF cDelimiter = "" THEN cDelimiter = "|".
END.


OUTPUT TO VALUE(cFileName) NO-CONVERT.

IF ihObject:TYPE = "BROWSE" THEN DO:

  iCount = 1.
  DO iColumn = 1 TO ihObject:NUM-COLUMNS:
    ASSIGN hColumn = ihObject:GET-BROWSE-COLUMN(iColumn)
           NO-ERROR.
    IF VALID-HANDLE(hColumn) AND hColumn:VISIBLE THEN
      cOutput = cOutput + REPLACE(hColumn:LABEL,"!"," ") + (IF iiMaxCount = -1 THEN " " + hColumn:NAME ELSE "") + cDelimiter.
/*       cOutput = cOutput + REPLACE(DYNAMIC-FUNCTIO("getStrippedSortLabel",hColumn),"!"," ") + cDelimiter. */
  END.
  IF iiMaxCount < 0 THEN iiMaxCount = 0.

  PUT UNFORMATTED cOutput SKIP.
  cOutput = "". 
  
  iCount = 2.
    
  IF NOT ihObject:MULTIPLE OR (ihObject:MULTIPLE AND ihObject:NUM-SELECTED-ROWS = 0) THEN DO:      
    CREATE QUERY hQuery.    
    hQuery = ihObject:QUERY.
    hQuery:GET-FIRST().
    
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
      DO iColumn = 1 TO ihObject:NUM-COLUMNS:
        ASSIGN hColumn = ihObject:GET-BROWSE-COLUMN(iColumn)
               hField = hColumn:BUFFER-FIELD NO-ERROR.
        IF VALID-HANDLE(hColumn) AND hColumn:VISIBLE THEN DO:
          IF hField:DATA-TYPE = "integer" OR hField:DATA-TYPE = "decimal" THEN DO:
            fDec = hField:BUFFER-VALUE.
            cOutput = cOutput + (IF fDec NE ? THEN STRING(fDec) ELSE "0") + cDelimiter.
          END.
          ELSE IF hField:DATA-TYPE = "DATE" THEN
            cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN string(hField:BUFFER-VALUE,'99/99/9999') ELSE "") + cDelimiter.
          ELSE IF hField:DATA-TYPE = "DATETIME" or hField:data-type = 'DATETIME-TZ' THEN
            cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE  ELSE "") + cDelimiter.
          ELSE IF hField:DATA-TYPE = "LOGICAL" THEN
            cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE ELSE "") + cDelimiter.
          ELSE
            cOutput = cOutput + (IF hField:BUFFER-VALUE NE ? THEN REPLACE(REPLACE(REPLACE(hField:BUFFER-VALUE,CHR(10)," "),CHR(9)," "),CHR(13)," ") ELSE "") + cDelimiter.
        END.
      END.
      PUT UNFORMATTED cOutput SKIP.
      cOutput = "". 
      iCount = iCount + 1.
      IF (iiMaxCount NE 0 AND iCount > iiMaxCount + 1) THEN LEAVE.
      hQuery:GET-NEXT().
    END.
  END.
  ELSE 
    DO ix = 1 TO ihObject:NUM-SELECTED-ROWS:
    bOk = ihObject:FETCH-SELECTED-ROW(ix).
    IF bOk THEN DO:
      DO iColumn = 1 TO ihObject:NUM-COLUMNS:
        ASSIGN hColumn = ihObject:GET-BROWSE-COLUMN(iColumn)
               hField = hColumn:BUFFER-FIELD NO-ERROR.
        IF VALID-HANDLE(hColumn) AND hColumn:VISIBLE THEN DO:
          IF hField:DATA-TYPE = "integer" OR hField:DATA-TYPE = "decimal" THEN DO:
            fDec = hField:BUFFER-VALUE.
            cOutput = cOutput + (IF fDec NE ? THEN STRING(fDec) ELSE "0") + cDelimiter.
          END.
          ELSE IF hField:DATA-TYPE = "DATE" THEN
            cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN string(hField:buffer-value,'99/99/9999') ELSE "") + cDelimiter.
          ELSE IF hField:DATA-TYPE = "DATETIME" or hField:data-type = 'DATETIME-TZ' THEN
            cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE  ELSE "") + cDelimiter.
          else if hField:DATA-TYPE = "LOGICAL" THEN
            cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE ELSE "") + cDelimiter.
          ELSE
            cOutput = cOutput + (IF hField:BUFFER-VALUE NE ? THEN REPLACE(REPLACE(REPLACE(hField:BUFFER-VALUE,CHR(10)," "),CHR(9)," "),CHR(13)," ") ELSE "") + cDelimiter.
        END.
      END.
      PUT UNFORMATTED cOutput SKIP.
      cOutput = "". 
      iCount = iCount + 1.  
    END.
  END.

END.

ELSE DO: /* <-- buffer */

  IF ihObject:TYPE = "query" THEN
    hBuffer = ihObject:GET-BUFFER-HANDLE(1).
  ELSE hBuffer = ihObject.

  iCount = 1.
  DO iColumn = 1 TO hBuffer:NUM-FIELDS:
    ASSIGN hColumn = hBuffer:BUFFER-FIELD(iColumn)
           NO-ERROR.
    DO ix = 0 TO hColumn:EXTENT:
      IF hColumn:EXTENT > 0 AND ix = 0 THEN NEXT.
      cOutput = cOutput + hColumn:LABEL + (IF ix > 0 THEN "[" + STRING(ix) + "]" ELSE IF iiMaxCount = -1 THEN " " + hColumn:NAME ELSE "") + cDelimiter.
    END.
  END.
  IF bIncludeRowid THEN
    cOutput = cOutput + "ROWID".
  
  IF iiMaxCount < 0 THEN iiMaxCount = 0.
  PUT UNFORMATTED cOutput SKIP.
  cOutput = "". 
  
  iCount = 2.
    
  CREATE QUERY hQuery.
  
  hQuery:SET-BUFFERS(hBuffer).
  hQuery:QUERY-PREPARE("FOR EACH " + hBuffer:NAME).
  hQuery:QUERY-OPEN().

  hQuery:GET-FIRST(). 
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    DO iColumn = 1 TO hBuffer:NUM-FIELDS:

      hField = hBuffer:BUFFER-FIELD(iColumn) NO-ERROR.

      DO ix = 0 TO hField:EXTENT:
        IF hField:EXTENT > 0 AND ix = 0 THEN NEXT.
        IF hField:BUFFER-VALUE[ix] = ? THEN DO:
          cOutput = cOutput + cDelimiter.
          NEXT.
        END.

        IF hField:DATA-TYPE = "integer" OR hField:DATA-TYPE = "decimal" THEN DO:
          fDec = hField:BUFFER-VALUE[ix].
          cOutput = cOutput + (IF fDec NE ? THEN STRING(fDec) ELSE "0") + cDelimiter.
        END.
        ELSE IF hField:DATA-TYPE = "DATE" THEN 
          cOutput = cOutput + (IF hField:STRING-VALUE[ix] NE ? THEN string(hField:BUFFER-VALUE[ix],'99/99/9999') ELSE "") + cDelimiter.
          ELSE IF hField:DATA-TYPE = "DATETIME" or hField:data-type = 'DATETIME-TZ' THEN
            cOutput = cOutput + (IF hField:STRING-VALUE[ix] NE ? THEN hField:STRING-VALUE[ix]  ELSE "") + cDelimiter.
        ELSE IF CAN-DO("LOGICAL,ROWID",hField:DATA-TYPE) THEN 
          cOutput = cOutput + (IF hField:STRING-VALUE[ix] NE ? THEN hField:STRING-VALUE[ix] ELSE "") + cDelimiter.
        ELSE 
          cOutput = cOutput + (IF hField:BUFFER-VALUE[ix] NE ? THEN REPLACE(REPLACE(REPLACE(hField:BUFFER-VALUE[ix],CHR(10)," "),CHR(9)," "),CHR(13)," ") ELSE "") + cDelimiter.
      END.
    END.
    IF bIncludeRowid THEN
      cOutput = cOutput + STRING(hBuffer:ROWID).
    PUT UNFORMATTED cOutput SKIP.
    cOutput = "". 
    iCount = iCount + 1.
    IF (iiMaxCount NE 0 AND iCount > iiMaxCount + 1) THEN LEAVE.
    hQuery:GET-NEXT().
  END.
  DELETE OBJECT hQuery.
END.

OUTPUT CLOSE.

bOK = SESSION:SET-WAIT-STATE("").

IF bOpenFile THEN DO:

  IF bUseExcel THEN DO:
    CREATE "Excel.Application" chExcelApplication NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DO:
        
      ASSIGN chExcelApplication:VISIBLE = TRUE.
       
      chExcelApplication:Workbooks:OpenText(cFileName,2,,,,,TRUE).
       
      ASSIGN chWorkbook = chExcelApplication:WorkBooks:ITEM(1)
             chWorkSheet = chExcelApplication:Sheets:ITEM(1).
        
      ASSIGN chWorkSheet:NAME  = TRIM(SUBSTR(PROGRAM-NAME(2),INDEX(PROGRAM-NAME(2)," ") + 1,LENGTH(PROGRAM-NAME(2)) - 2),SESSION:TEMP-DIR) NO-ERROR.
        
      ASSIGN chWorkSheet:Rows(1):FONT:Bold = TRUE.
      
      PUBLISH "ExcelSheetParams" (chExcelApplication,chWorkbook,chWorksheet,iCount - 1).
    END.
    
    ELSE DO ON ERROR UNDO, THROW:  
      System.Diagnostics.Process:Start("notepad.exe",cFileName).
      CATCH eOS AS Progress.Lang.Error :
         MESSAGE eOS:GetMessage(1) VIEW-AS ALERT-BOX.
      END CATCH.
    END.
     
//    OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
  END.  
  ELSE DO ON ERROR UNDO, THROW:  
    System.Diagnostics.Process:Start("notepad.exe",cFileName).
    CATCH eOS AS Progress.Lang.Error :
       MESSAGE eOS:GetMessage(1) VIEW-AS ALERT-BOX.
    END CATCH.
  END.
//    OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
END.   

CATCH eAny AS Progress.Lang.Error :
   OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
   LEAVE.
END CATCH.

FINALLY:
  ASSIGN SESSION:NUMERIC-SEPARATOR = cNumSep
         SESSION:NUMERIC-DECIMAL   = cNumSep  
         SESSION:DATE-FORMAT       = cCurrDateFormat
         SESSION:NUMERIC-FORMAT    = cCurrNumFormat
         NO-ERROR.
END FINALLY.

/* OS-DELETE VALUE(cFileName). */

