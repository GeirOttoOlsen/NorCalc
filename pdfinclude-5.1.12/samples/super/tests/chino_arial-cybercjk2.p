/******************************************************************************

    Program:        chino_arial-cybercjk.p
    
    Description:    This program illustrates unicode fonts usage in pdfinclude.
                    When using unicode fonts (i.e. with a .ufm file) then the
                    input to text procedures must be utf8 encoded.
                    This file tests chinese along with some latin 1 characters

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE INPUT PARAMETER pcRunCase AS CHARACTER   NO-UNDO.

IF pcRunCase = "cleanCache" THEN DO:
    /* empty the cache */
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\fonts\*.cache").
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\fonts\*.cid2gid").
    RETURN.
END.

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/tests/chino_arial-cybercjk2." + pcRunCase + ".pdf").

RUN pdf_set_BottomMargin("Spdf", 50).

RUN pdf_set_info ("Spdf", "Title", "Chinese characters test (chino_arial-cybercjk.p)").
RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(233, SESSION:CPINTERNAL, "iso8859-1")). /* accentuated char to test utf-8 */
RUN pdf_set_info ("Spdf", "Producer", "PDFInclude").

RUN pdf_load_font2("Spdf", "Bitstream CyberCJK", "fonts\CyberCJK.ttf", YES, "", "SUBSET").
RUN pdf_load_font2("Spdf", "Arial", "c:\windows\fonts\Arial.ttf", YES, "", "SUBSET").

/* RUN pdf_load_font("Spdf","Bitstream CyberCJK|NOEMBED","fonts\CyberCJK.ttf","fonts\CyberCJK.ufm",""). */
/* RUN pdf_load_font("Spdf","Arial Unicode MS","c:\windows\fonts\ArialUni.ttf","fonts\ArialUni.ufm",""). */
/* RUN pdf_load_font("Spdf","Arial","c:\windows\fonts\Arial.ttf","fonts\Arial.afm",""). */
/* RUN pdf_load_font("Spdf","Arial|NOEMBED","c:\windows\fonts\Arial.ttf","fonts\Arial.ufm",""). */
/* RUN pdf_load_font("Spdf","TimesNewRomanPSMT|NOEMBED","","fonts\Times.ufm",""). */

DEFINE VARIABLE cFont AS CHARACTER  INITIAL "Arial" NO-UNDO.

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */
RUN pdf_set_parameter("Spdf","compress","TRUE").

RUN pdf_set_parameter("sPDF","UseTags","TRUE").
RUN pdf_set_parameter("sPDF","BoldFont","Bitstream CyberCJK").
/* RUN pdf_set_parameter("sPDF","BoldFont",cFont). */
RUN pdf_set_parameter("sPDF","ItalicFont",cFont).
RUN pdf_set_parameter("sPDF","BoldItalicFont",cFont).
RUN pdf_set_parameter("sPDF","DefaultFont",cFont).
RUN pdf_set_parameter("sPDF","TagColor:Black","0,0,0").
RUN pdf_set_parameter("sPDF","DefaultColor","Black").

RUN pdf_new_page("Spdf").

RUN pdf_set_font("Spdf","Courier",12).
RUN pdf_text("Spdf", "This text is an extract from Wikipedia.").
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "It has been created by PDFinclude.").
RUN pdf_skipn("Spdf", 2).

RUN pdf_set_font("Spdf",cFont,12).
/* RUN pdf_set_font("Spdf","Arial Unicode MS",12). */
/* RUN pdf_set_font("Spdf","Arial",12). */

DEFINE VARIABLE cLine AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iMaxY AS INTEGER     NO-UNDO.
INPUT FROM VALUE(cPdfIncludePath + "samples/support/chino1.txt") BINARY NO-MAP NO-CONVERT.
REPEAT:
    IMPORT UNFORMATTED cLine.
    IF cLine > "" THEN
        RUN pdf_wrap_text("Spdf", cLine, 1, 100, "LEFT", OUTPUT iMaxY).
        /* RUN pdf_text("Spdf", cLine). */
    RUN pdf_skip("Spdf").
END.
INPUT CLOSE.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of chino_arial-cybercjk.p */
