/******************************************************************************

    Program:        defaultheadnfoot.p
    
    Description:    This program illustrates the default PDFInclude headers & Footers

******************************************************************************/
{samples/support/config.i}

{pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE i AS INTEGER     NO-UNDO.
DEFINE VARIABLE cTxt AS CHARACTER   NO-UNDO.

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/defaultheadnfoot.pdf").

RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(50089, SESSION:CHARSET, "utf-8")). /* accentuated char to test utf-8 */
RUN pdf_set_info ("Spdf", "Title",  "Hello world!").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf", "unitTest", "TRUE"). /* 12-AUG-2013 jcc */
/* RUN pdf_set_parameter("Spdf", "compress", "TRUE"). */

RUN pdf_set_parameter("Spdf", "defaultHeader", "TRUE"). /* 08-APR-2014 jcc */
/* RUN pdf_set_parameter("Spdf", "headerLine1", pdf_get_info("Spdf", "Title")). */ /* Title is the default for headerLine1 */
RUN pdf_set_parameter("Spdf", "headerLine2", "par " + pdf_get_info("Spdf", "Author")). /* Author is the default for headerLine1 */
RUN pdf_set_parameter("Spdf", "defaultFooter", "TRUE"). /* 08-APR-2014 jcc */
RUN pdf_set_parameter("Spdf", "footerLine1", "page " + pdf_PageNo("Spdf") + " de " + pdf_TotalPages("Spdf")).

RUN pdf_set_font("Spdf", "Courier", 12).

RUN pdf_set_PaperType("Spdf", "A6").
RUN pdf_set_TopMargin("Spdf", 40). /* default top margin is 50 */
RUN pdf_set_BottomMargin("Spdf", 15). /* default bottom margin is 10 when using defaultFooter */

DO i = 1 TO 12:
    RUN pdf_new_page("Spdf").
    RUN pdf_text("Spdf", "Hello World! ").
    RUN pdf_skip("Spdf").
    /* also test dynamic justification */
    RUN pdf_text_boxed_xy("Spdf", "(Page @@PageNo-Spdf/@@TotalPages-Spdf)", pdf_PageWidth("Spdf") / 2 - 50, pdf_Pageheight("Spdf") / 2 - pdf_PointSize("Spdf") * 2, 100, pdf_PointSize("Spdf"), "left",   0.5).
    RUN pdf_text_boxed_xy("Spdf", "(Page @@PageNo-Spdf/@@TotalPages-Spdf)", pdf_PageWidth("Spdf") / 2 - 50, pdf_Pageheight("Spdf") / 2                            , 100, pdf_PointSize("Spdf"), "center", 0.5).
    RUN pdf_text_boxed_xy("Spdf", "(Page @@PageNo-Spdf/@@TotalPages-Spdf)", pdf_PageWidth("Spdf") / 2 - 50, pdf_Pageheight("Spdf") / 2 + pdf_PointSize("Spdf") * 2, 100, pdf_PointSize("Spdf"), "right",  0.5).
    RUN pdf_text_align("Spdf", "(Page @@PageNo-Spdf/@@TotalPages-Spdf)", "left",   pdf_LeftMargin("Spdf"),                         pdf_Pageheight("Spdf") / 2 + pdf_PointSize("Spdf") * 4).
    RUN pdf_text_align("Spdf", "(Page @@PageNo-Spdf/@@TotalPages-Spdf)", "center", pdf_PageWidth("Spdf") / 2,                      pdf_Pageheight("Spdf") / 2 + pdf_PointSize("Spdf") * 6).
    RUN pdf_text_align("Spdf", "(Page @@PageNo-Spdf/@@TotalPages-Spdf)", "right",  pdf_PageWidth("Spdf") - pdf_LeftMargin("Spdf"), pdf_Pageheight("Spdf") / 2 + pdf_PointSize("Spdf") * 8).
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of defaultheadnfoot.pdf */
