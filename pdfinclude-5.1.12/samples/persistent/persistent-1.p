/******************************************************************************

    Program:        persistent-1.p
    
    Description:    This program uses the Persistent instance of PDFinclude.
    
                    Called from persistent.p

******************************************************************************/
{ samples/support/config.i }

DEFINE INPUT PARAMETER p_Handle AS HANDLE NO-UNDO.

RUN pdf_new IN p_Handle ("Spdf",cPdfIncludePath + "samples\persistent\persistent-1.pdf").
RUN pdf_new_page IN p_Handle ("Spdf").

RUN pdf_text IN p_Handle ("Spdf", "Persistent One!").

RUN pdf_close IN p_Handle ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of persistent-1.pdf */
