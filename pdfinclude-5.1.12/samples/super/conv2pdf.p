/******************************************************************************

    Program:        conv2pdf.p
    
    Description:    Illustrates a simple program that reads a text file
                    and creates a PDF file.

                    Called from convert.p
                    
******************************************************************************/
{ samples/support/config.i }

DEFINE INPUT PARAMETER p_TextFile AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_PDFFile  AS CHARACTER NO-UNDO.

DEFINE VARIABLE v_line  AS CHARACTER NO-UNDO.

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",p_PDFFile).

RUN pdf_set_parameter("Spdf", "unittest", "TRUE").

/* The following line ensures that we don't go less than 50 points from the 
   bottom of the page -- this is mostly for readability purposes.  If we didn't
   have this then the PDF would have text on the very last line of the page.
   Ugly.  This just moves it up a couple of lines. */
RUN pdf_set_BottomMargin("Spdf",50).
RUN pdf_set_Orientation("Spdf","Landscape"). 

RUN pdf_new_page("Spdf"). /* Instantiate a new page */

INPUT FROM VALUE(p_TextFile) NO-ECHO.
  REPEAT:
    IMPORT UNFORMATTED v_Line.

    IF v_Line <> "" THEN DO: /* 14-APR-2012 jcc: for empty lines, only skip. Note: " " = "" so even if the line contains only spaces then it will be skiped */
        RUN pdf_text_color ("Spdf",0.0,.0,.0).
        RUN pdf_text    ("Spdf", v_Line).
    END.
    RUN pdf_skip    ("Spdf").

    /* If a Page Character is found then perform a New Page.  If text document
       contains no page characters the paging will occur automatically as soon
       as the BottomMargin is reached */
    IF INDEX(v_Line,CHR(12)) > 0 THEN
      RUN pdf_new_page("Spdf").
  END.
INPUT CLOSE.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of conv2pdf.p */
