 /******************************************************************************

    Program:        sample.p
    
    Description:    This program illustrates how to open an existing PDF
                    and include a page into your PDFinclude PDF document.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE i_Counter AS INTEGER NO-UNDO.

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/word-sample.pdf").   
RUN pdf_set_parameter("Spdf","Compress","TRUE").
 
RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/samples-v5.pdf","Test"). 

RUN DoNewPage.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* ------------------- INTERNAL PROCEDURES ------------------------- */
PROCEDURE DoNewPage:
  RUN pdf_new_page("Spdf").
  RUN pdf_use_PDF_page("Spdf","Test",1). 
END.

/* end of sample.pdf */
 
