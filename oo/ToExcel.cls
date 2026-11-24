 
 /*------------------------------------------------------------------------
    File        : ToExcel
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Fri Jan 19 10:19:33 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.ToExcel: 
  DEFINE VARIABLE oCmd AS CLASS JBoxCmd NO-UNDO.

  DEFINE PUBLIC PROPERTY ObjectHandle AS HANDLE    NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY OutputFile   AS CHARACTER NO-UNDO GET. SET.

  def public property DateNumberFormat as longchar no-undo get. set.
  def public property DateTimeNumberFormat as longchar no-undo get. set.
  def public property LongNumberFormat as longchar no-undo get. set.
  def public property DecimalNumberFormat as longchar no-undo get. set.
  def public property CurrencyNumberFormat as longchar no-undo get. set.

  def public property Callback as handle no-undo get. set.
  
  DEFINE VARIABLE chExcelApplication AS COMPONENT-HANDLE NO-UNDO.
  DEFINE VARIABLE chWorkbook         AS COMPONENT-HANDLE NO-UNDO.
  DEFINE VARIABLE chWorksheet        AS COMPONENT-HANDLE NO-UNDO.
  DEFINE VARIABLE iCount             AS INTEGER          NO-UNDO.
  DEFINE VARIABLE iColumn            AS INTEGER          INITIAL 1 NO-UNDO.
 
  DEFINE VARIABLE hQuery             AS WIDGET-HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer            AS WIDGET-HANDLE    NO-UNDO.
  DEFINE VARIABLE hField             AS WIDGET-HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn            AS HANDLE           NO-UNDO.
  
  DEFINE VARIABLE cCurrDateFormat    AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cCurrNumFormat     AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE cOutput            AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE bOk                AS LOG              NO-UNDO.
  DEFINE VARIABLE fDec               AS DECIMAL          FORMAT "->>,>>>,>>>,>>9.99".      
  DEFINE VARIABLE ix                 AS INTEGER          NO-UNDO.
  DEFINE VARIABLE cTmpFileName       AS CHARACTER        NO-UNDO.
  DEFINE VARIABLE bUseExcel          AS LOG              NO-UNDO INIT YES.
  DEFINE VARIABLE MaxCount           AS INTEGER          NO-UNDO.

  
  &SCOPED-DEFINE xlMacintosh 1
  &SCOPED-DEFINE xlWindows 2
  &SCOPED-DEFINE xlMSDOS 3
  &SCOPED-DEFINE xlUniCodeUTF8 65001
  
  
  &SCOPED-DEFINE xlDelimited 1
  &SCOPED-DEFINE xlFixedWidth 2
  
  &SCOPED-DEFINE xlTextQualifierDoubleQuote 1
  &SCOPED-DEFINE xlTextQualifierNone -4142
  &SCOPED-DEFINE xlTextQualifierSingleQuote 2
  
  &SCOPED-DEFINE xlConsecutiveDelimiter
  &SCOPED-DEFINE xlTab TRUE
  &SCOPED-DEFINE xlSemicolon
  &SCOPED-DEFINE xlComma
  &SCOPED-DEFINE xlSpace
  &SCOPED-DEFINE xlOther
  &SCOPED-DEFINE xlOtherChar
  
  &SCOPED-DEFINE xlDecimalSeparator
  &SCOPED-DEFINE xlThousandSeparator
  &SCOPED-DEFINE xlTrailingMinusNumbers
  &SCOPED-DEFINE xlLocal TRUE
    
  &SCOPED-DEFINE xlPlatform {&xlWindows}
  &SCOPED-DEFINE xlTextParsingType {&xlDelimited}
  &SCOPED-DEFINE xlTextQualifier {&xlDelimited}
  
  
  def public event ExcelSheetParams signature void (input ipApp as com-handle, input ipBook as com-handle, input ipSheet as com-handle,input ipRow as int).
  def var ObjectColumns as handle extent no-undo.



  /*------------------------------------------------------------------------------
   Purpose:
   Notes: brukes for å sette properties buildexcel.
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC ToExcel ():
    fix-codepage(DateNumberFormat)     = 'utf-8'.
    fix-codepage(DateTimeNumberFormat) = 'utf-8'.
  end CONSTRUCTOR.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC ToExcel (INPUT ipObject AS HANDLE, ipMaxCount AS INTEGER, ipCallback as handle):
/*    run test persistent set hEventhelper ().*/
    fix-codepage(DateNumberFormat)     = 'utf-8'.
    fix-codepage(DateTimeNumberFormat) = 'utf-8'.

    Initiate(ipObject,ipMaxCount,ipCallBack).    
    
  END CONSTRUCTOR.

method public void Initiate(INPUT ipObject AS HANDLE, ipMaxCount AS INTEGER, ipCallback as handle):

    ASSIGN 
/*      DateTimeNumberFormat = 'dd.mm.åååå'*/
      cCurrDateFormat  = SESSION:DATE-FORMAT
      cCurrNumFormat   = SESSION:NUMERIC-FORMAT
      LongNumberFormat     = if LongNumberFormat = '' then '#' else LongNumberFormat
      DecimalNumberFormat  = if DecimalNumberFormat = '' then '#' else DecimalNumberFormat
      CurrencyNumberFormat = if CurrencyNumberFormat = '' then '#' else CurrencyNumberFormat
      .
    
    /*    IF CAN-DO(SOURCE-PROCEDURE:INTERNAL-ENTRIES,"getExportFileName") THEN DO:  */
    /*      cTmpFileName = DYNAMIC-FUNCTION("getExportFileName" IN SOURCE-PROCEDURE).*/
    /*      IF cTmpFileName NE "" THEN OutputFile = cTmpFileName.                    */
    /*    END.                                                                       */
    
    SESSION:SET-NUMERIC-FORMAT(System.Globalization.CultureInfo:CurrentCulture:NumberFormat:NumberGroupSeparator,  /* -numsep / SESSION:NUMERIC-SEPARATOR */
                               System.Globalization.CultureInfo:CurrentCulture:NumberFormat:NumberDecimalSeparator /* -numdec / SESSION:NUMERIC-DECIMAL-POINT */ ).
    assign 
      ObjectHandle = ipObject
      MaxCount     = ipMaxCount
      Callback     = ipCallback
      .
      
    IF MaxCount = -2 THEN 
      bUseExcel = NO.

    IF NOT VALID-HANDLE(ObjectHandle) THEN 
      RETURN.

    OutputFile       = SESSION:TEMP-DIR 
                      + (IF ObjectHandle:TYPE = "buffer" AND ObjectHandle:NAME NE ? THEN ObjectHandle:NAME + "_" ELSE "")
                      + STRING(YEAR(TODAY)) + STRING(MONTH(TODAY),"99") + STRING(DAY(TODAY)) + STRING(TIME) + ".txt"
                      .
      
    IF ObjectHandle:TYPE = "TEMP-TABLE" THEN 
      ObjectHandle = ObjectHandle:DEFAULT-BUFFER-HANDLE.
    
    OUTPUT TO VALUE(OutputFile) NO-CONVERT.
    
    CASE ObjectHandle:TYPE:
      WHEN "BROWSE" THEN 
        DO:
          OutputBrowse().
        END.
      OTHERWISE 
      DO:
        IF ObjectHandle:TYPE = "query" THEN
          hBuffer = ObjectHandle:GET-BUFFER-HANDLE(1).
        ELSE 
          hBuffer = ObjectHandle.
        OutputBuffer().
      END.
    END CASE.
    
    OUTPUT CLOSE.
    ASSIGN 
      SESSION:DATE-FORMAT    = cCurrDateFormat
      SESSION:NUMERIC-FORMAT = cCurrNumFormat
      .

    bOK = SESSION:SET-WAIT-STATE("").

    IF bUseExcel THEN 
      buildExcel().
    ELSE
      oCmd = NEW JBoxCmd('notepad',OutputFile).    
  
end method. 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID buildExcel(  ):

    def var ColumnRange as char no-undo.
    def var ActiveRange as com-handle no-undo.
    
    do on error undo, throw:
      CREATE "Excel.Application" chExcelApplication.
      CATCH eExcel AS Progress.Lang.Error :
        oCmd = NEW JBoxCmd('notepad',OutputFile).             
      END CATCH.
    end.
    
    ASSIGN
      chExcelApplication:VISIBLE = TRUE
      .
     
    chExcelApplication:Workbooks:OpenText(OutputFile,{&xlPlatform},,{&xlTextParsingType},{&xlTextQualifier},{&xlConsecutiveDelimiter},{&xlTab},{&xlSemicolon},{&xlComma},{&xlSpace},{&xlOther},{&xlOtherChar},,,{&xlDecimalSeparator},{&xlThousandSeparator},{&xlTrailingMinusNumbers},{&xlLocal}).
/*      chExcelApplication:Workbooks:OpenText(OutputFile,2,,,,,TRUE).*/
     
    ASSIGN 
      chWorkbook  = chExcelApplication:WorkBooks:ITEM(1)
      chWorkSheet = chExcelApplication:Sheets:ITEM(1)
      .
      
    ASSIGN 
      chWorkSheet:NAME = TRIM(SUBSTR(PROGRAM-NAME(2),INDEX(PROGRAM-NAME(2)," ") + 1,LENGTH(PROGRAM-NAME(2)) - 2),SESSION:TEMP-DIR) NO-ERROR.
      
    ASSIGN
      chWorkSheet:Rows(1):FONT:Bold = TRUE
      .
      
    do iColumn = 1 to extent(ObjectColumns):
      case ObjectColumns[iColumn]:data-type:
        when 'Date' then do:
          assign 
            ColumnRange = chr(64 + iColumn) + ':' + chr(64 + iColumn) 
            ActiveRange = chWorkSheet:Range(ColumnRange)
            chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = DateNumberFormat
          .
        end.
        when 'Datetime' or when 'Datetime-tz' then 
          assign 
            ColumnRange = chr(64 + iColumn) + ':' + chr(64 + iColumn) 
            chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = DateTimeNumberFormat
            .
        when 'integer' or when 'int64' then 
          assign 
            ColumnRange = chr(64 + iColumn) + ':' + chr(64 + iColumn) 
            chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = LongNumberFormat
            .
        when 'decimal' then 
          assign 
            ColumnRange = chr(64 + iColumn) + ':' + chr(64 + iColumn) 
            chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = CurrencyNumberFormat
            .
/*          otherwise                                                                                                        */
/*            assign                                                                                                         */
/*              ColumnRange = chr(64 + iColumn) + ':' + chr(64 + iColumn)                                                    */
/*              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = System.Globalization.NumberFormatInfo:CurrentInfo:*/
/*              .                                                                                                            */
      end case.
    end.      
/*      ExcelSheetParams:Publish(chExcelApplication,chWorkbook,chWorksheet,iCount - 1).*/
/*run Excel.event in hEventh*/
/*      PUBLISH "ExcelSheetParams" from Callback (chExcelApplication,chWorkbook,chWorksheet,iCount - 1).*/
    

    CATCH eAny AS Progress.Lang.Error :
      MESSAGE 'ERROR:' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID OutputBrowse(  ):
    /*Loop igjennom kolonnene*/
    extent(ObjectColumns) = ObjectHandle:NUM-COLUMNS.
     
    iCount = 1.
    DO iColumn = 1 TO ObjectHandle:NUM-COLUMNS:
      ASSIGN 
        hColumn = ObjectHandle:GET-BROWSE-COLUMN(iColumn)
               NO-ERROR.
      IF VALID-HANDLE(hColumn) AND hColumn:VISIBLE THEN
        assign
          ObjectColumns[iColumn] = hColumn 
          cOutput = cOutput + REPLACE(hColumn:LABEL,"!"," ") + (IF MaxCount = -1 THEN " " + hColumn:NAME ELSE "") + "~t".
    /*       cOutput = cOutput + REPLACE(DYNAMIC-FUNCTIO("getStrippedSortLabel",hColumn),"!"," ") + "~t". */
    END.
    IF MaxCount < 0 THEN MaxCount = 0.
    
    PUT UNFORMATTED cOutput SKIP.
    cOutput = "". 
      
    iCount = 2.
        
    IF NOT ObjectHandle:MULTIPLE OR (ObjectHandle:MULTIPLE AND ObjectHandle:NUM-SELECTED-ROWS = 0) THEN 
    DO:      
      CREATE QUERY hQuery.    
      hQuery = ObjectHandle:QUERY.
      hQuery:GET-FIRST().
        
      REPEAT WHILE NOT hQuery:QUERY-OFF-END:
        DO iColumn = 1 TO ObjectHandle:NUM-COLUMNS:
          ASSIGN 
            hColumn = ObjectHandle:GET-BROWSE-COLUMN(iColumn)
            hField  = hColumn:BUFFER-FIELD NO-ERROR.
          IF VALID-HANDLE(hColumn) AND hColumn:VISIBLE THEN 
          DO:
            IF hField:DATA-TYPE = "integer" OR hField:DATA-TYPE = "decimal" THEN 
            DO:
              fDec = hField:BUFFER-VALUE.
              cOutput = cOutput + (IF fDec NE ? THEN STRING(fDec) ELSE "0") + "~t".
            END.
            ELSE IF hField:DATA-TYPE = "DATE" then
              assign 
                hField:format = '99.99.9999' 
                cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE ELSE "") + "~t"
                .
            else if hField:DATA-TYPE = "LOGICAL" THEN 
                cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE ELSE "") + "~t".
              ELSE 
                cOutput = cOutput + (IF hField:BUFFER-VALUE NE ? THEN REPLACE(REPLACE(REPLACE(hField:BUFFER-VALUE,CHR(10)," "),CHR(9)," "),CHR(13)," ") ELSE "") + "~t".
          END.
        END.
        PUT UNFORMATTED cOutput SKIP.
        cOutput = "". 
        iCount = iCount + 1.
        IF (MaxCount NE 0 AND iCount > MaxCount + 1) THEN LEAVE.
        hQuery:GET-NEXT().
      END.
    END.
    ELSE 
    DO ix = 1 TO ObjectHandle:NUM-SELECTED-ROWS:
      bOk = ObjectHandle:FETCH-SELECTED-ROW(ix).
      IF bOk THEN 
      DO:
        DO iColumn = 1 TO ObjectHandle:NUM-COLUMNS:
          ASSIGN 
            hColumn = ObjectHandle:GET-BROWSE-COLUMN(iColumn)
            hField  = hColumn:BUFFER-FIELD NO-ERROR.
          IF VALID-HANDLE(hColumn) AND hColumn:VISIBLE THEN 
          DO:
            IF hField:DATA-TYPE = "integer" OR hField:DATA-TYPE = "decimal" THEN 
            DO:
              fDec = hField:BUFFER-VALUE.
              cOutput = cOutput + (IF fDec NE ? THEN STRING(fDec) ELSE "0") + "~t".
            END.
            ELSE IF hField:DATA-TYPE = "DATE" then
              assign
                hField:format = '99.99.9999' 
                cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE ELSE "") + "~t"
                .
            else if hField:DATA-TYPE = "LOGICAL" THEN 
                cOutput = cOutput + (IF hField:STRING-VALUE NE ? THEN hField:STRING-VALUE ELSE "") + "~t".
              ELSE 
                cOutput = cOutput + (IF hField:BUFFER-VALUE NE ? THEN REPLACE(REPLACE(REPLACE(hField:BUFFER-VALUE,CHR(10)," "),CHR(9)," "),CHR(13)," ") ELSE "") + "~t".
          END.
        END.
        PUT UNFORMATTED cOutput SKIP.
        cOutput = "". 
        iCount = iCount + 1.  
      END.
    END.
    
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE 'ERROR:' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID OutputBuffer(  ):
    /*Loop igjennom kolonnene*/
    extent(ObjectColumns) = hBuffer:NUM-FIELDS.
      
    iCount = 1.
    DO iColumn = 1 TO hBuffer:NUM-FIELDS:
      ASSIGN      
        hColumn = hBuffer:BUFFER-FIELD(iColumn)
        ObjectColumns[iColumn] = hColumn
             NO-ERROR.
      DO ix = 0 TO hColumn:EXTENT:
        IF hColumn:EXTENT > 0 AND ix = 0 THEN NEXT.
        IF hColumn:DATA-TYPE = 'ROWID' THEN NEXT.
        cOutput = cOutput + hColumn:LABEL + (IF ix > 0 THEN "[" + STRING(ix) + "]" ELSE IF MaxCount = -1 THEN " " + hColumn:NAME ELSE "") + "~t".
      END.
    END.
    IF MaxCount < 0 THEN MaxCount = 0.
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
          IF hField:DATA-TYPE = 'ROWID' THEN NEXT.
          
          CASE hField:DATA-TYPE:
            WHEN 'ROWID' THEN 
              NEXT.
            WHEN 'integer' OR 
            WHEN 'decimal' THEN 
              DO:
                fDec = hField:BUFFER-VALUE[ix].
                cOutput = cOutput + (IF fDec NE ? THEN STRING(fDec) ELSE "0") + "~t".
              END.
            WHEN 'DATE' /*or when 'DATETIME' or when 'DATETIME-TZ'*/ THEN 
              DO:
                assign
                  hField:format = '99.99.9999' 
                  cOutput = cOutput + (IF hField:STRING-VALUE[ix] NE ? THEN hField:STRING-VALUE[ix] ELSE "") + "~t"
                  .
              END.
            WHEN 'logical' THEN 
              DO:
                cOutput = cOutput + (IF hField:STRING-VALUE[ix] NE ? THEN hField:STRING-VALUE[ix] ELSE "") + "~t".
              /*            cOutput = cOutput + (IF hField:STRING-VALUE[ix] NE ? THEN (if hField:buffer-value then 'X' else '') ELSE "") + "~t".*/
              END.
            OTHERWISE 
            DO:
              cOutput = cOutput + (IF hField:BUFFER-VALUE[ix] NE ? THEN REPLACE(REPLACE(REPLACE(hField:BUFFER-VALUE[ix],CHR(10)," "),CHR(9)," "),CHR(13)," ") ELSE "") + "~t".
            END.
          END CASE.
        END.
      END.
      PUT UNFORMATTED cOutput SKIP.
      cOutput = "". 
      iCount = iCount + 1.
      IF (MaxCount NE 0 AND iCount > MaxCount + 1) THEN LEAVE.
      hQuery:GET-NEXT().
    END.
    IF VALID-HANDLE(hQuery) THEN DELETE OBJECT hQuery.

    CATCH eAny AS Progress.Lang.Error :
      MESSAGE 'ERROR:' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

END CLASS.