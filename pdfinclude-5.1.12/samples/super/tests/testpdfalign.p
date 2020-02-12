DEFINE INPUT  PARAMETER ipcFont AS CHARACTER   NO-UNDO.

{tests/pdf_tests.i}

DEF VAR v1 AS DEC FORMAT "->>>,>>>.99" NO-UNDO INIT 123.50.
DEF VAR v2 AS DEC FORMAT "->>>,>>>.99" NO-UNDO INIT 67123.50.

{pdf_inc.i "THIS-PROCEDURE" }

RUN pdf_new ("Spdf", gcTestsDir + "tests/testpdfalign." + ipcFont + ".pdf").
RUN pdf_set_PaperType("Spdf","A4").

CASE ipcFont:
    WHEN "Arial" THEN DO:
        RUN pdf_load_font("Spdf","Arial",OS-GETENV("windir") + "\fonts\arial.ttf","samples\support\arial.afm","").
        /* RUN pdf_load_font("Spdf","Arial-Bold",OS-GETENV("windir") + "\fonts\arialbd.ttf","samples\support\arialbd.afm","").        */
        /* RUN pdf_load_font("Spdf","Arial-BoldOblique",OS-GETENV("windir") + "\fonts\arialbi.ttf","samples\support\arialbi.afm",""). */
        /* RUN pdf_load_font("Spdf","Arial-Oblique",OS-GETENV("windir") + "\fonts\ariali.ttf","samples\support\ariali.afm","").       */
    END.
    WHEN "DejavuSans" THEN DO:
        RUN pdf_load_font("Spdf","DejavuSans","C:\User\JCCARDOT\Perso\Travail\pdfinc\PDFinclude4.0\pdfinclude\fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSans.ttf","C:\User\JCCARDOT\Perso\Travail\pdfinc\PDFinclude4.0\pdfinclude\fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSans.ufm","").
    END.
END CASE.

RUN pdf_new_page("Spdf").

/* RUN pdf_set_parameter("Spdf", "optimizePDFOutput", "FALSE"). */
RUN pdf_set_parameter("Spdf", "UnitTest", "TRUE").

IF ipcFont <> "Courier" THEN
    RUN pdf_set_font("Spdf",ipcFont,10.0).

RUN pdf_skipn("Spdf",15).
RUN pdf_text_to("Spdf",STRING(v1, "->>>,>>>.99"),80). 
RUN pdf_skip("Spdf").
RUN pdf_text_to("Spdf",STRING(v2, "->>>,>>>.99"),80). 
RUN pdf_skip("Spdf").

RUN pdf_close("Spdf").
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
/* OS-COMMAND NO-WAIT VALUE("testalign1.pdf"). */
