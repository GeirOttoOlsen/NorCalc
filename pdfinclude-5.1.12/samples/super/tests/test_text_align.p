DEFINE INPUT  PARAMETER ipcFont AS CHARACTER   NO-UNDO.

{tests/pdf_tests.i}

DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE VARIABLE y AS INTEGER     NO-UNDO.
DEFINE VARIABLE x AS INTEGER     NO-UNDO.

{pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new("Spdf", gcTestsDir + "tests/test_text_align." + STRING(ipcFont) + ".pdf").

CASE ipcFont:
    WHEN "Arial" THEN DO:
        RUN pdf_load_font("Spdf","Arial",OS-GETENV("windir") + "\fonts\arial.ttf","samples\support\arial.afm","").
    END.
    WHEN "DejavuSans" THEN DO:
        RUN pdf_load_font("Spdf","DejavuSans","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSans.ttf","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSans.ufm","").
    END.
END CASE.

RUN pdf_set_parameter("Spdf", "unitTest", "TRUE").

RUN pdf_new_page("Spdf").
RUN pdf_set_font("Spdf", ipcFont, 10).

y = 750.
x = 140.
DO i = 32 to 255:
    RUN pdf_text_align("Spdf", 
        STRING(i, ">>9") + ": " + FILL(CHR(i, IF ipcFont = "DejavuSans" THEN "utf-8" ELSE SESSION:CPINTERNAL, "iso8859-1"), 8), /* 26-SEP-2014 jcc: DejavuSans being unicode, the input must be utf-8 */
        "RIGHT", x, y).
    y = y - 12.
    IF y < 20 THEN ASSIGN
        x = x + 120
        y = 750.
END.

RUN pdf_line("Spdf", 140, 760, 140, 30, .5).
RUN pdf_line("Spdf", 260, 760, 260, 30, .5).
RUN pdf_line("Spdf", 380, 760, 380, 30, .5).
RUN pdf_line("Spdf", 500, 760, 500, 30, .5).

RUN pdf_close("Spdf").
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
