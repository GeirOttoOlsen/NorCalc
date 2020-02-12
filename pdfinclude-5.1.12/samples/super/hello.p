/******************************************************************************

    Program:        hello.p
    
    Description:    This program illustrates the very basic elements that are 
                    required when using PDFinclude.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/hello.pdf").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */

RUN pdf_new_page("Spdf").

RUN pdf_text("Spdf", "Hello World! ").

/* RUN pdf_insert_page("Spdf", 1, "before"). */
/* RUN pdf_text("Spdf", "Hello World! (inserted)"). */

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of hello.pdf */
