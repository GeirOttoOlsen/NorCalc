/******************************************************************************

    Program:        utf8test-subset.p
    
    Description:    This program illustrates unicode fonts usage in pdfinclude
                    with font subsetting.
                    When using unicode fonts (i.e. with a .ufm file) then the
                    input to text procedures must be utf8 encoded.
                    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/utf8test-subset.pdf").

RUN pdf_set_BottomMargin("Spdf", 50).

RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(233, SESSION:CPINTERNAL, "iso8859-1")). /* accentuated char to test utf-8 */

RUN pdf_load_font("Spdf","FreeSerif|SUBSET","fonts\FreeSerif.ttf","fonts\FreeSerif.ufm","").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */

RUN pdf_new_page("Spdf").

RUN pdf_set_font("Spdf","FreeSerif",12).

DEFINE VARIABLE cLine AS CHARACTER   NO-UNDO.
INPUT FROM VALUE(cPdfIncludePath + "samples/support/utf8test.txt") BINARY UNBUFFERED NO-CONVERT.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine > "" THEN
        RUN pdf_text("Spdf", cLine).
    RUN pdf_skip("Spdf").
END.
INPUT CLOSE.

RUN pdf_skipn("Spdf",4).

DEFINE VARIABLE cLang AS CHARACTER   NO-UNDO.
INPUT FROM VALUE(cPdfIncludePath + "samples/support/helloworld.txt") BINARY UNBUFFERED NO-CONVERT.
REPEAT:
    IMPORT DELIMITER "~t" cLang cLine.
    IF cLine > "" THEN
        RUN pdf_text("Spdf", cLang + ": " + cLine).
    RUN pdf_skip("Spdf").
END.
INPUT CLOSE.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of utf8test.p */
