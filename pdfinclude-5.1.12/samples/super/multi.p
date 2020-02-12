/******************************************************************************

    Program:        multi.p
    
    Description:    This program illustrates the creation of multiple documents
                    within a single procedure.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/multiOne.pdf").
RUN pdf_set_parameter("Spdf", "unittest", "true").
RUN pdf_set_info ("Spdf", "Title",  "multi").
RUN pdf_new_page("Spdf").

RUN pdf_text    ("Spdf", "Multiple Document One!").
 
RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE "One" RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/multiTwo.pdf").
RUN pdf_set_parameter("Spdf", "unittest", "true"). /* 12-MAY-2014 jcc: this test showed me that I had forgotten to reset two logical variables in pdf_reset_(all|stream) */
RUN pdf_new_page("Spdf").

RUN pdf_text    ("Spdf", "Multiple Document Two!").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE "Two" RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of multi.p */
