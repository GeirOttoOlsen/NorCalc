/******************************************************************************

    Program:        multi.p
    
    Description:    This program illustrates the creation of multiple documents
                    within a single procedure.

******************************************************************************/

{ pdf_inc.i "NOT SUPER"}

{ samples/support/config.i }

RUN pdf_new IN h_PDFinc ("Spdf",cPdfIncludePath + "samples\persistent\multiOne.pdf").
RUN pdf_new_page IN h_PDFinc ("Spdf").

RUN pdf_text IN h_PDFinc ("Spdf", "Multiple Document One!").
 
RUN pdf_close IN h_PDFinc ("Spdf").

RUN pdf_new IN h_PDFinc ("Spdf",cPdfIncludePath + "samples\persistent\multiTwo.pdf").
RUN pdf_new_page IN h_PDFinc ("Spdf").

RUN pdf_text IN h_PDFinc ("Spdf", "Multiple Document Two!").

RUN pdf_close IN h_PDFinc ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of multi.p */
