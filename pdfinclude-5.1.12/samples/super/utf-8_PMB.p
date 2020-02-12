/******************************************************************************

    Program:        utf-8_PMB.p
    
    Description:    This program illustrates unicode fonts usage in pdfinclude.
                    The generated pdf will contain characters from the
                    Basic Multilingual Plane

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/utf-8_PMB.pdf").

RUN pdf_set_BottomMargin("Spdf", 50).

RUN pdf_set_info ("Spdf", "Title", "Unicode (Basic Multilingual Plane)").
RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(50089, SESSION:CPINTERNAL, "utf-8")). /* accentuated char to test utf-8 */
RUN pdf_set_info ("Spdf", "Producer", "PDFInclude").

RUN pdf_load_font("Spdf","ArialUni|SUBSET", "fonts/ArialUni.ttf", "fonts/ArialUni.ufm","").
/* RUN pdf_load_font("Spdf","ArialUni|SUBSET","c:\windows\fonts\Arial.ttf","fonts\Arial.ufm",""). */

DEFINE VARIABLE cFont AS CHARACTER  INITIAL "ArialUni" NO-UNDO.

/* The following parameters are not needed (for tests only) */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */
RUN pdf_set_parameter("Spdf","compress","TRUE").

RUN pdf_set_parameter("sPDF","UseTags","TRUE").
RUN pdf_set_parameter("sPDF","BoldFont",cFont).
RUN pdf_set_parameter("sPDF","ItalicFont",cFont).
RUN pdf_set_parameter("sPDF","BoldItalicFont",cFont).
RUN pdf_set_parameter("sPDF","DefaultFont",cFont).
RUN pdf_set_parameter("sPDF","TagColor:Black","0,0,0").
RUN pdf_set_parameter("sPDF","TagColor:Red","255,0,0").
RUN pdf_set_parameter("sPDF","DefaultColor","Black").

RUN pdf_new_page("Spdf").
/*
RUN pdf_set_font("Spdf","Courier",12).
RUN pdf_text("Spdf", "This text is an extract from Wikipedia.").
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "The pdf file has been created by PDFinclude.").
RUN pdf_skipn("Spdf", 2).
*/
RUN pdf_set_font("Spdf",cFont,12).

DEFINE VARIABLE cLine AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iMaxY AS INTEGER     NO-UNDO.
INPUT FROM VALUE(cPdfIncludePath + "samples/support/utf-8_PMB.txt") BINARY NO-MAP NO-CONVERT.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine > "" THEN RUN pdf_wrap_text("Spdf", cLine, 1, 500, "LEFT", OUTPUT iMaxY).
    RUN pdf_skip("Spdf").
END.
INPUT CLOSE.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of utf-8_PMB.p */
