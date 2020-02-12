/******************************************************************************

    Program:        xobject.p
    
    Description:    This program illustrates the use of patterns (XObjects)

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE ipatternId AS INTEGER     NO-UNDO.
DEFINE VARIABLE ipatternId2 AS INTEGER     NO-UNDO.

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/xobject.pdf").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */

RUN pdf_new_page("Spdf").

RUN pdf_text("Spdf", "pattern tests").

RUN pdf_load_image("Spdf", "test", "samples/support/test.png").

RUN pdf_place_image("Spdf", "test", 100, 200, 64, 64).

/* patterns definition */
&GLOBAL-DEFINE tpl2Height 12
&GLOBAL-DEFINE tpl2Width  245
RUN pdf_pattern_begin("Spdf", OUTPUT ipatternId2, {&tpl2Width}, {&tpl2Height}, "").
RUN pdf_rect("Spdf", 0, 1, {&tpl2Width} - 1, {&tpl2Height} - 1, 0.5).
/* RUN pdf_text("Spdf", "This is the included pattern"). */
RUN pdf_set_dash("Spdf", 4, 2).
RUN pdf_text_boxed_xy("Spdf", "This is the included pattern (" + pdf_TotalPages("Spdf") + ")",
                      1, {&tpl2Height} - pdf_PointSize("Spdf"),
                      {&tpl2Width} - 1, pdf_PointSize("Spdf"), "center", 0.5).
RUN pdf_pattern_end("Spdf").

&GLOBAL-DEFINE tplHeight 34
&GLOBAL-DEFINE tplWidth  pdf_PageWidth("Spdf")
RUN pdf_pattern_begin("Spdf", OUTPUT ipatternId, {&tplWidth}, {&tplHeight}, "").
RUN pdf_line ("Spdf", 0, {&tplHeight}, {&tplWidth}, {&tplHeight}, 0.5).
RUN pdf_line ("Spdf", 0, 0, {&tplWidth}, 0, 0.5).
RUN pdf_line ("Spdf", 0, 0, 0, {&tplHeight}, 0.5).
RUN pdf_line ("Spdf", {&tplWidth}, 0, {&tplWidth}, {&tplHeight}, 0.5).
RUN pdf_text("Spdf", "This is the pattern (1)").
RUN pdf_skip("Spdf").
RUN pdf_set_font("Spdf", "Helvetica", 10).
RUN pdf_text("Spdf", "This is the pattern (" + pdf_TotalPages("Spdf") + ")").
RUN pdf_skip("Spdf").
RUN pdf_set_font("Spdf", "Courier", 10).
RUN pdf_text("Spdf", "This is the pattern (" + pdf_PageNo("Spdf") + ")"). /* PageNo should not be used: the pattern might be used in many pages */
RUN pdf_place_image("Spdf", "test", 144, 30, 30, 30). /* x, y, width, height */
RUN pdf_pattern_use("Spdf", ipatternId2, 170, {&tplHeight} - {&tpl2Height}, ?, ?).
RUN pdf_pattern_use("Spdf", ipatternId2, 180, {&tplHeight} - {&tpl2Height} * 2 - 2, ?, ?).
RUN pdf_pattern_end("Spdf").
/* patterns definition end */

RUN pdf_pattern_use("Spdf", ipatternId, 0, pdf_PageHeight("Spdf") - {&tplHeight}, ?, ?).
RUN pdf_pattern_use("Spdf", ipatternId, 0, 400, ?, ?).
RUN pdf_pattern_use("Spdf", ipatternId, 0, 300, ?, ?).
RUN pdf_pattern_use("Spdf", ipatternId, 0, 200, ?, ?).
RUN pdf_pattern_use("Spdf", ipatternId, 0, 100, ?, ?).

/* change original xobject dimensions */
RUN pdf_pattern_use("Spdf", ipatternId, 144, 500, {&tplWidth} / 2, {&tplHeight} / 2).

RUN pdf_skip("Spdf").
RUN pdf_text("Spdf", "pattern tests").

/* test a second page */
RUN pdf_new_page("Spdf").
RUN pdf_pattern_use("Spdf", ipatternId, 0, pdf_PageHeight("Spdf") - {&tplHeight}, ?, ?).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of xobject.pdf */
