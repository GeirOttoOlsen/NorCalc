 /******************************************************************************

    Program:        jcc.p
    
    Description:    This program illustrates how to open an existing PDF
                    and include a page into your PDFinclude PDF document.

    Notes:          

******************************************************************************/
/* DEBUGGER:INITIATE(). */

{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE i_Counter AS INTEGER NO-UNDO.

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/jcc.pdf").
/* RUN pdf_set_parameter("Spdf","Compress","TRUE"). */

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/jcc.pdf","jcc").

RUN pdf_new_page("Spdf").

RUN pdf_use_PDF_page("Spdf","jcc",1). 

RUN pdf_set_font("Spdf","Helvetica",12).

RUN pdf_text_color("Spdf",1.0,0.0,0.0).

RUN pdf_text_xy ("Spdf","Hello world!",350,557).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
