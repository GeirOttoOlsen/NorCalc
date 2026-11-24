
/*------------------------------------------------------------------------
    File        : test_excel.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Fri Jan 19 10:18:02 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var oExcel as oo.ToExcel no-undo.
def var dtNow as datetime no-undo.

def temp-table Test 
  field dato as date
  field datotid as datetime
  field heltall as int64
  field tekst as char
  .
def var bhTest as handle no-undo.
 
function addTest returns logical (input ipDate as date, input ipDateTime as datetime, input ipLongNumber as int64, input ipString as char) forward.

bhTest = buffer test:handle.
dtNow = now.
addTest(today,dtNow,11223423224,'TestæøåØÆÅ').

subscribe to 'ExcelSheetParams' anywhere.

//run toexcelviafile.p (bhTest,2).
oExcel = new oo.ToExcel(buffer Test:handle,2,?).


procedure ExcelSheetParams:
  def input param ipchExcelApplication as com-handle no-undo.
  def input param ipchWorkBook as com-handle no-undo.
  def input param ipchWorkSheet as com-handle no-undo.
  MESSAGE 'herddd'
    VIEW-AS ALERT-BOX.
end procedure.

function addTest returns logical (input ipDate as date, input ipDateTime as datetime, input ipLongNumber as int64, input ipString as char):
  create Test.
  assign 
    test.dato    = ipDate
    test.datotid = ipDateTime
    test.heltall = ipLongNumber
    test.tekst   = ipString
    .    
end function.