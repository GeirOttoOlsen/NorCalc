/******************************************************************************

    Program:        combination.p
    
    Description:    combine 2 pdf in one page 
                    (in this example adding a "DUPLICATA" banner)

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/combination.pdf").

RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc: for testing purposes */

RUN pdf_set_parameter("Spdf","UseExternalPageSize","TRUE").

RUN pdf_new_page("Spdf").

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/watermark.pdf","wm").
RUN pdf_use_PDF_page("Spdf","wm",1).

/* RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/jcc.pdf","jcc"). */
/* RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/POFormOOo.pdf","jcc"). */
RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/template.pdf","jcc").
RUN pdf_use_PDF_page("Spdf","jcc",1).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of combination.p */
