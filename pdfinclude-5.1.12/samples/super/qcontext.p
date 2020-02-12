{ samples/support/config.i }
{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("s",cPdfIncludePath + "samples/super/qcontext.pdf").
RUN pdf_set_parameter("s","unitTest","TRUE").
RUN pdf_new_page("s").

RUN pdf_stroke_color("s", .8, 0, 0).
RUN pdf_stroke_fill("s", .9, .9, .9).
RUN pdf_rect("s", pdf_LeftMargin("s"),pdf_textY("s") - 40,pdf_PageWidth("s") - pdf_LeftMargin("s") - pdf_RightMargin("s"),40,1).

RUN pdf_set_TextY("s", pdf_TextY("s") - 40).
RUN pdf_skip("s").
RUN pdf_Text("s", "This is some text").
RUN pdf_skip("s").

RUN pdf_rect("s", pdf_LeftMargin("s"),pdf_textY("s") - 40,pdf_PageWidth("s") - pdf_LeftMargin("s") - pdf_RightMargin("s"),40,1).

RUN pdf_close("s").
IF RETURN-VALUE > '' THEN
    MESSAGE "1" RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

