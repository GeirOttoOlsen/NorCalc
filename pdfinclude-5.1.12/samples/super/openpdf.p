 /******************************************************************************

    Program:        openPDF.p
    
    Description:    This program illustrates how to open an existing PDF
                    and include a page into your PDFinclude PDF document.

    Notes:          You must be connected to the Sports2000 DB to run.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE i_Counter AS INTEGER NO-UNDO.

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/openpdf.pdf").
RUN pdf_set_parameter("Spdf","Compress","TRUE").

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/Invoice.pdf","Inv").
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\super\hello.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\support\word-Samples.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\support\Samples-v5.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\support\fw2.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\support\fw2-2005.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\super\column-list.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\support\POForm5.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\support\adobe-exemple.pdf","Inv"). */
/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\super\openpdf.pdf","Inv"). */

/* RUN pdf_open_PDF("Spdf","G:\Fadiese\temp\pdfinclude\samples\support\PDF32000_2008.pdf","Inv"). */

FOR EACH Invoice NO-LOCK:
  RUN DoNewPage.

  RUN DoInvoiceInfo.

  /* Only do two pages for demo purposes */
  i_Counter = i_Counter + 1.
  IF i_Counter = 2  THEN LEAVE.
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* ------------------- INTERNAL PROCEDURES ------------------------- */
PROCEDURE DoNewPage:
  RUN pdf_new_page("Spdf").
  RUN pdf_use_PDF_page("Spdf","Inv",1). 
END.

PROCEDURE DoInvoiceInfo:

  RUN pdf_set_font("Spdf","Helvetica",8).
  RUN pdf_text_color("Spdf",1.0,0.0,0.0).

  /* This procedure overlays the DB info on the external PDF form */
  RUN pdf_text_xy ("Spdf",STRING(Invoice.InvoiceNum,"99999"),350,557).
  RUN pdf_text_xy ("Spdf",STRING(Invoice.InvoiceDate,"99.99.9999"),350,546).
  RUN pdf_text_xy ("Spdf",STRING(Invoice.CustNum,"99999"),350,535).

END.

/* end of openPDF.pdf */
 
