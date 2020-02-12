/******************************************************************************

    Program:        super-3a.p
    
    Description:    This program uses the super Super of PDFinclude.
    
                    Called from super-3.p

******************************************************************************/
{ samples/support/config.i }

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/super-3a.pdf").
RUN pdf_set_parameter("Spdf", "unittest", "true").
RUN pdf_new_page("Spdf").

RUN pdf_text    ("Spdf", "Super Three, eh!").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of super-3a.pdf */
