/******************************************************************************

    Program:        invForm.p
    
    Description:    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/invForm.pdf").

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/invForm.pdf","fs").

RUN pdf_new_page("Spdf").
RUN pdf_use_PDF_page("Spdf","fs",1).

RUN pdf_fill_text("Spdf","CustomerName","Jean-Christophe","").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of invForm.p */
