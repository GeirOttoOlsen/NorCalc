 /******************************************************************************

    Program:        FormFill.p
    
    Description:    This program illustrates how to open an existing PDF 
                    document that has Text Form Fields in it.  This program then
                    goes onto show how to assign text to those form fields.

    Note:           The pdf form has been generated using OpenOffice.org 3.1
    
******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/FormOOo-filled.pdf").

RUN pdf_open_PDF("Spdf", cPdfIncludePath + "samples/support/FormOOo.pdf","OOo"). 

RUN pdf_new_page("Spdf").
RUN pdf_use_PDF_page("Spdf", "OOo", 1). 

RUN pdf_fill_text("Spdf", "TextBox1", "I've been filled using PDFInclude!", "").
/* RUN pdf_fill_text("Spdf", "CheckBox", "X", ""). */

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of FormFillOOo.pdf */
 
