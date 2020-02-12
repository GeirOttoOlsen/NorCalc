/******************************************************************************

    Program:        super-1.p
    
    Description:    This program uses the Session Super of PDFinclude.

                    Called from super.p

******************************************************************************/
{ samples/support/config.i }

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/super-1.pdf").
RUN pdf_set_parameter("Spdf", "unittest", "true").
RUN pdf_new_page("Spdf").

RUN pdf_text    ("Spdf", "Super One!").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of super-1.pdf */
