/******************************************************************************

    Program:        combination2.p
    
    Description:    combine 2 one-page pdf in one pdf of 2 pages

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/combination2.pdf").

RUN pdf_set_parameter("sPDF","unitTest","TRUE").

RUN pdf_set_parameter("Spdf","UseExternalPageSize","TRUE").

RUN pdf_new_page("Spdf").
RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/template_main.pdf","main").
RUN pdf_use_PDF_page("Spdf","main",1).

RUN pdf_new_page("Spdf").
RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/template_detail.pdf","detail").
RUN pdf_use_PDF_page("Spdf","detail",1).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of combination2.p */
