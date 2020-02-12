 /******************************************************************************

    Program:        w2form.p
    
    Description:    This program illustrates how to open the W2 Form .
                    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}
   
DEFINE VARIABLE iPage AS INTEGER NO-UNDO.

/* Create a new output document */
RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/w2form.pdf").

/* Compress the contents */
RUN pdf_set_parameter("Spdf","Compress","TRUE"). 

/* Open the blank Bill-of-Lading template */
RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/fw2.pdf","W2"). 

DO iPage = 1 TO INT(pdf_get_pdf_info("Spdf","W2","Pages")).
  RUN DoNewPage (iPage).
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* ------------------- INTERNAL PROCEDURES ------------------------- */
PROCEDURE DoNewPage:
  DEFINE INPUT PARAMETER pPage  AS INTEGER NO-UNDO.

  RUN pdf_new_page("Spdf").
  RUN pdf_use_PDF_page("Spdf","W2",pPage). 
END.

/* end of w2form.p */
