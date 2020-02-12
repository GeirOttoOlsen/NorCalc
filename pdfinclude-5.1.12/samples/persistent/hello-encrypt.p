/******************************************************************************

    Program:        hello.p
    
    Description:    This program illustrates the very basic elements that are 
                    required when using PDFinclude.

******************************************************************************/

{ pdf_inc.i "NOT SUPER"}

{ samples/support/config.i }

RUN pdf_new IN h_PDFinc ("Spdf", cPdfIncludePath + "samples\persistent\hello-encrypt.pdf").
RUN pdf_new_page IN h_PDFinc ("Spdf").

RUN pdf_text IN h_PDFinc ("Spdf", "Hello World!").

RUN pdf_Encrypt IN h_PDFinc
    ("Spdf",
     "gord1",
     "gord",
     "noprint",
     128,
     "COM",
     FALSE).

RUN pdf_close IN h_PDFinc ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.


/* end of hello.pdf */
