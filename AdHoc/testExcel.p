
/*------------------------------------------------------------------------
    File        : testExcel.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Thu Jan 25 15:11:55 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

def var dtNow as datetime no-undo.
  def var ObjectHandle AS HANDLE    NO-UNDO.
  def var OutputFile   AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE chExcelApplication AS COMPONENT-HANDLE NO-UNDO.
  DEFINE VARIABLE chWorkbook         AS COMPONENT-HANDLE NO-UNDO.
  DEFINE VARIABLE chWorksheet        AS COMPONENT-HANDLE NO-UNDO.
  DEFINE VARIABLE iCount             AS INTEGER          NO-UNDO.
  DEFINE VARIABLE iColumn            AS INTEGER          INITIAL 1 NO-UNDO.
  def var ObjectColumns as handle extent no-undo.
  def var ii as int no-undo.
  def var lcUTF8format as longchar no-undo.
  
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
  
    def var ColumnRange as char no-undo.
    def var ActiveRange as com-handle no-undo.


def temp-table Test 
  field dato as date format "99/99/9999"
  field datotid as datetime
  field heltall as int64
  field tekst as char
  .
function addTest returns logical (input ipDate as date, input ipDateTime as datetime, input ipLongNumber as int64, input ipString as char) forward.


fix-codepage(lcUTF8format) = 'utf-8'.

lcUTF8format = 'ddmmåååå'.

dtNow = now.
addTest(today,dtNow,11223423224,'Test æøå ÆØÅ').
outputfile = 'e:\temp\test.txt'.

/*output to value(outputfile)  convert target 'utf-8' source session:CPINTERNAL.*/
output to value(outputfile).
put unformatted 'dato~tdatotid~theltall~ttekst' skip.
for each test:
  export delimiter '~t' Test.dato test.datotid test.heltall test.tekst.  
end.
output close.
    
    ObjectHandle = buffer Test:handle.
    extent(ObjectColumns) = buffer Test:handle:num-fields.
    do ii = 1 to extent(ObjectColumns):
      ObjectColumns[ii] = buffer Test:handle:buffer-field(ii).
    end.

    CREATE "Excel.Application" chExcelApplication NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN DO:
      ASSIGN 
        chExcelApplication:VISIBLE = TRUE.
       
      chExcelApplication:Workbooks:OpenText(OutputFile,{&xlPlatform},,{&xlTextParsingType},{&xlTextQualifier},{&xlConsecutiveDelimiter},{&xlTab},{&xlSemicolon},{&xlComma},{&xlSpace},{&xlOther},{&xlOtherChar},,,{&xlDecimalSeparator},{&xlThousandSeparator},{&xlTrailingMinusNumbers},{&xlLocal}).
       
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
/*              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = "[$-414]dddd, mmmm dd, yyyy"*/
/*              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = "[$-414]dddd, mmmm dd, åååå"*/
/*              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = "mm.dd.yyyy"*/
/*              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = "mm.dd.åååå"*/
/*              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = lcUTF8format.*/
              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = lcUTF8format.
              .
              ActiveRange = chWorkSheet:Range(ColumnRange).
              
          end.
          when 'Datetime' or when 'Datetime-tz' then 
            assign 
              ColumnRange = chr(64 + iColumn) + ':' + chr(64 + iColumn) 
              chWorkSheet:Range(ColumnRange):EntireColumn:NumberFormat = System.Globalization.DateTimeFormatInfo:CurrentInfo:ShortDatePattern
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
    END.


function addTest returns logical (input ipDate as date, input ipDateTime as datetime, input ipLongNumber as int64, input ipString as char):
  create Test.
  assign 
    test.dato    = ipDate
    test.datotid = ipDateTime
    test.heltall = ipLongNumber
    test.tekst   = ipString
    .    
end function.