DEFINE INPUT  PARAMETER ipcFont AS CHARACTER   NO-UNDO.
/* DEFINE VARIABLE ipcFont AS CHARACTER   NO-UNDO. */
/* ipcFont = "simyou". */

{tests/pdf_tests.i}

DEF VAR v1 AS DEC FORMAT "->>>,>>>.99" NO-UNDO INIT 123.50.
DEF VAR v2 AS DEC FORMAT "->>>,>>>.99" NO-UNDO INIT 67123.50.

IF ipcFont = "cleanCache" THEN DO:
    /* empty the cache */
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\fonts\*.cache").
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\fonts\*.cid2gid").
    RETURN.
END.

{pdf_inc.i "THIS-PROCEDURE" }

RUN pdf_new ("Spdf", gcTestsDir + "tests/testpdfalign2." + ipcFont + ".pdf").

/* RUN pdf_set_parameter("Spdf", "compress", "true"). */

RUN pdf_set_PaperType("Spdf","A4").

ipcFont = ENTRY(1, ipcFont, "-").

CASE ipcFont:
    WHEN "Arial" THEN DO:
        RUN pdf_load_font2("Spdf","Arial",OS-GETENV("windir") + "\fonts\arial.ttf",NO,"","subset").
        /* RUN pdf_load_font("Spdf","Arial-Bold",OS-GETENV("windir") + "\fonts\arialbd.ttf","samples\support\arialbd.afm","").        */
        /* RUN pdf_load_font("Spdf","Arial-BoldOblique",OS-GETENV("windir") + "\fonts\arialbi.ttf","samples\support\arialbi.afm",""). */
        /* RUN pdf_load_font("Spdf","Arial-Oblique",OS-GETENV("windir") + "\fonts\ariali.ttf","samples\support\ariali.afm","").       */
    END.
    WHEN "DejavuSans" THEN DO:
        RUN pdf_load_font2("Spdf","DejavuSans", gcTestsDir + "..\..\fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSans.ttf",NO,"","subset").
    END.
    OTHERWISE DO:
        RUN pdf_load_font2("Spdf",ipcFont, gcTestsDir + "..\..\fonts\" + ipcFont + ".ttf",NO,"","subset").
        /* RUN pdf_load_font("Spdf",ipcFont + "|subset", gcTestsDir + "..\..\fonts\" + ipcFont + ".ttf",gcTestsDir + "..\..\fonts\" + ipcFont + ".afm",""). */
    END.
END CASE.

RUN pdf_new_page("Spdf").

/* RUN pdf_set_parameter("Spdf", "optimizePDFOutput", "FALSE"). */
RUN pdf_set_parameter("Spdf", "UnitTest", "TRUE").

IF ipcFont <> "Courier" THEN
    RUN pdf_set_font("Spdf",ipcFont,10.0).

RUN pdf_text_to("Spdf","This is " + ipcFont,80). 
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
