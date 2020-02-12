/******************************************************************************

    Program:        hello_uni.p
    
    Description:    This program illustrates the very basic elements that are 
                    required when using PDFinclude.
                    /* 11-FEB-2014 jcc: testing unicode output */

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/hello_uni.pdf").

RUN pdf_set_BottomMargin("Spdf", 50).

RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(50089, SESSION:CPINTERNAL, "utf-8")). /* accentuated char to test utf-8 */
RUN pdf_set_info ("Spdf", "Title",    "Hello world!").
RUN pdf_set_info ("Spdf", "Keywords", "hello,world,test,unicode").

RUN pdf_load_font("Spdf","DejavuSans","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSans.ttf","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSans.ufm","").
RUN pdf_load_font("Spdf","DejavuSerif","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSerif.ttf","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSerif.ufm","").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */

RUN pdf_new_page("Spdf").
RUN pdf_set_font("Spdf","Helvetica",10.0).
RUN pdf_text("Spdf", "Hello World!").

RUN pdf_skipn("Spdf", 2).
RUN pdf_set_font("Spdf","Courier",10.0).
RUN pdf_text("Spdf", "DejaVuSans:").
RUN pdf_skip("Spdf").

RUN pdf_set_font("Spdf","DejavuSans",10.0).

RUN pdf_text("Spdf", "Hello World! Příšerně žluťoučký kůň úpěl ďábelské ódy. ").
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "Hello World! Γαζέες καὶ μυρτιὲς δὲν θὰ βρῶ πιὰ στὸ χρυσαφὶ ξέφωτο ").
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "Hello World! ? В чащах юга жил бы цитрус? Да, но фальшивый экземпляр! ").

/* 13-FEB-2014 jcc: testing pdf_text_width */
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "un ").
RUN pdf_text("Spdf", "deux ").
RUN pdf_text("Spdf", "trois ").
RUN pdf_text("Spdf", "quatre ").
RUN pdf_text("Spdf", "cinq ").
RUN pdf_text("Spdf", "six ").
RUN pdf_text("Spdf", "sept ").
RUN pdf_text("Spdf", "huit ").
RUN pdf_text("Spdf", "neuf ").
RUN pdf_text("Spdf", "dix ").
RUN pdf_text("Spdf", pdf_TextX("Spdf")).
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "un deux trois quatre cinq six sept huit neuf dix ").
RUN pdf_text("Spdf", pdf_TextX("Spdf")).
RUN pdf_skip("Spdf").

RUN pdf_skipn("Spdf", 2).
RUN pdf_set_font("Spdf","Courier",10.0).
RUN pdf_text("Spdf", "DejaVuSerif:").
RUN pdf_skip("Spdf").

RUN pdf_set_font("Spdf","DejavuSerif",10.0).
/* The following text is encoded using utf-8, which is needed for special characters in unicode fonts for pdfinclude */
RUN pdf_text("Spdf", "Hello World! Příšerně žluťoučký kůň úpěl ďábelské ódy. ").
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "Hello World! Γαζέες καὶ μυρτιὲς δὲν θὰ βρῶ πιὰ στὸ χρυσαφὶ ξέφωτο ").
RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "Hello World! ? В чащах юга жил бы цитрус? Да, но фальшивый экземпляр! ").

RUN pdf_skipn("Spdf", 2).
RUN pdf_set_font("Spdf","Courier",10.0).
RUN pdf_text("Spdf", "Hello world in various languages:").
RUN pdf_skip("Spdf").

RUN pdf_set_font("Spdf","DejavuSerif",10.0).


DEFINE VARIABLE cLang AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cLine AS CHARACTER   NO-UNDO.
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

/* end of hello_uni.p */
