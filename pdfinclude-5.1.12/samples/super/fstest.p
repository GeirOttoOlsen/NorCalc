/******************************************************************************

    Program:        fstest.p
    
    Description:    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/fstest.pdf").

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/fstest.pdf","fs").

RUN pdf_new_page("Spdf").
RUN pdf_use_PDF_page("Spdf","fs",1).
RUN pdf_fill_text("Spdf","Date","06/08/1972","").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of fstest.p */
