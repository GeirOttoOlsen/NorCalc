/******************************************************************************

    Program:        rotatetext.p
    
    Description:    Illustrates the rotation of text available via PDFinclude.

******************************************************************************/

{ pdf_inc.i "NOT SUPER"}

{ samples/support/config.i }

DEFINE VARIABLE iAngle AS INTEGER     NO-UNDO.

RUN pdf_new IN h_PDFinc ("Spdf",cPdfIncludePath + "samples\persistent\rotatetext.pdf").
RUN pdf_new_page IN h_PDFinc ("Spdf").

/* Place some text */
RUN pdf_text IN h_PDFinc ("Spdf", FILL("HORIZONTAL ",2)).

RUN pdf_text_rotate IN h_PDFinc ("Spdf",90).
RUN pdf_text IN h_PDFinc ("Spdf", FILL("VERTICAL ",2)).

RUN pdf_text_rotate IN h_PDFinc ("Spdf",0).
RUN pdf_text IN h_PDFinc ("Spdf", FILL("HORIZON ",2)).

RUN pdf_text_rotate IN h_PDFinc ("Spdf",270).
RUN pdf_text IN h_PDFinc ("Spdf", FILL("VERT ",2)).

RUN pdf_text_rotate IN h_PDFinc ("Spdf",0).
RUN pdf_set_font IN h_PDFinc ("Spdf",pdf_Font("Spdf"),12).
RUN pdf_text_color IN h_PDFinc ("Spdf",1,0,0).
RUN pdf_text IN h_PDFinc ("Spdf", "SNAKEHEAD----8~~ ").

/* Part 3 */
RUN pdf_skipn IN h_PDFinc ("Spdf",15).
RUN pdf_set_font IN h_PDFinc ("Spdf",pdf_Font("Spdf"), 6).
RUN pdf_text IN h_PDFinc ("Spdf", "  HORIZONTAL HORIZONTAL HORIZONTAL HORIZONTAL ").
RUN pdf_text_color IN h_PDFinc ("Spdf",0,1,0).
DO iAngle = 1 TO 360 BY 4:
    RUN pdf_text_rotate IN h_PDFinc ("Spdf", iAngle).
    RUN pdf_text IN h_PDFinc ("Spdf", "          " + STRING(iAngle,">>9") + " DEGREES" + " " + STRING(iAngle,">>9") + " DEGREES").
END.
/* End part 3 */

RUN pdf_close IN h_PDFinc ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of rotatetext.p */
