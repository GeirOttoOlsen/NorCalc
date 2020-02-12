/******************************************************************************

    Program:        combination3.p
    
    Description:    idem that combination2 but one 2 pages template

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/combination3.pdf").

RUN pdf_set_parameter("Spdf","unittest","TRUE").

RUN pdf_set_parameter("Spdf","UseExternalPageSize","TRUE").

RUN pdf_new_page("Spdf").
RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/template-2pages.pdf","main").
RUN pdf_use_PDF_page("Spdf","main",1).

RUN pdf_new_page("Spdf").
RUN pdf_use_PDF_page("Spdf","main",2).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of combination2.p */
