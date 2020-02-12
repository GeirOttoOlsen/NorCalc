/******************************************************************************

    Program:        tagalog.p
    
    Description:    This program illustrates unicode fonts usage in pdfinclude.
                    When using unicode fonts (i.e. with a .ufm file) then the
                    input to text procedures must be utf8 encoded.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/tagalog.pdf").

RUN pdf_set_parameter("sPDF","UseTags","TRUE").
RUN pdf_set_parameter("sPDF","DefaultFont","Helvetica").
RUN pdf_set_parameter("sPDF","BoldFont","Helvetica-Bold").
RUN pdf_set_parameter("sPDF","ItalicFont","Helvetica-Oblique").
RUN pdf_set_parameter("sPDF","BoldItalicFont","Helvetica-BoldOblique").
RUN pdf_set_parameter("sPDF","TagColor:Black","0,0,0").
RUN pdf_set_parameter("sPDF","TagColor:Red","255,0,0").
RUN pdf_set_parameter("sPDF","DefaultColor","Black").

RUN pdf_set_BottomMargin("Spdf", 50).

RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(50089, SESSION:CPINTERNAL, "utf-8")). /* accentuated char to test utf-8 */

RUN pdf_load_font("Spdf","Baybayin|SUBSET",cPdfIncludePath + "fonts\Baybayin\TagDoc93.ttf",cPdfIncludePath + "fonts\Baybayin\TagDoc93.ufm","").
RUN pdf_load_font("Spdf","Arial|SUBSET","c:\windows\fonts\Arial.ttf","fonts\Arial.ufm","").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */
/* RUN pdf_set_parameter("Spdf","compress","TRUE"). */

RUN pdf_new_page("Spdf").

/* The TagDoc93 font defines both ASCII characters and unicode ones. First we test the ASCII: */
RUN pdf_set_font("Spdf","Baybayin",12).
RUN pdf_text("Spdf", "ABCDEFGHIJKLMNOPQRSTUVWXYZ,!BiBoB+").
RUN pdf_skipn("Spdf", 2).
    
/* then we will import an utf-8 file with tagalog text to test the unicode characters: */

RUN pdf_set_font("Spdf","Helvetica",12).

DEFINE VARIABLE cLine AS CHARACTER   NO-UNDO.
INPUT FROM VALUE(cPdfIncludePath + "samples/support/tagalog.txt") BINARY NO-MAP NO-CONVERT.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine > "" THEN
        RUN pdf_text("Spdf", cLine).
    RUN pdf_skip("Spdf").
END.
INPUT CLOSE.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of tagalog.p */
