/******************************************************************************

    Program:        multipage.p
    
    Description:    This program illustrates the modification of a page after
                    it has been generated (basically, it tests pdf_set_page).

******************************************************************************/

{ samples/support/config.i }

DEFINE VARIABLE iCurrentPage  AS INTEGER NO-UNDO.
{ pdf_inc.i }

RUN pdf_new("Spdf",cPdfIncludePath + "samples/super/multipage.pdf").

RUN pdf_set_parameter("Spdf", "unittest", "true").

/* The following produces 4 pages */
RUN pdf_new_page("Spdf").
RUN pdf_text_color("Spdf", 1,0,0).
RUN pdf_text("Spdf","Page1").

RUN pdf_new_page("Spdf").
RUN pdf_text_color("Spdf", 0,1,0).
RUN pdf_text("Spdf","Page2").

RUN pdf_new_page("Spdf").
RUN pdf_text_color("Spdf", 0,0,1).
RUN pdf_set_font("Spdf", "Helvetica", 10).
RUN pdf_text("Spdf","Page3").

RUN pdf_new_page("Spdf").
RUN pdf_set_font("Spdf", "Times-Roman", 10).
RUN pdf_text("Spdf","Page4").

RUN pdf_new_page("Spdf").
RUN pdf_text("Spdf","THE END").

/* This codes places new text on each pages 1 thru 4 */
DO iCurrentPage = 1 To 4:
  RUN pdf_set_page("Spdf",iCurrentPage).
  RUN pdf_skip("Spdf").
  RUN pdf_text("Spdf","Page " + STRING(iCurrentPage) + " of 4").
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
