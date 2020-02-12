/******************************************************************************

    Program:        rotatetext.p
    
    Description:    Illustrates the rotation of text available via PDFinclude.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE iAngle AS INTEGER     NO-UNDO.

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/rotatetext.pdf").
RUN pdf_new_page("Spdf").

RUN pdf_set_parameter("sPDF","UnitTest","TRUE").

DEFINE VARIABLE cfont AS CHARACTER   NO-UNDO.
cfont = "Courier".
RUN pdf_set_parameter("sPDF","UseTags","TRUE").
RUN pdf_set_parameter("sPDF","BoldFont",cFont + "-Bold").
RUN pdf_set_parameter("sPDF","ItalicFont",cFont + "-Oblique").
RUN pdf_set_parameter("sPDF","BoldItalicFont",cFont + "-BoldOblique").
RUN pdf_set_parameter("sPDF","DefaultFont",cFont).
RUN pdf_set_parameter("sPDF","DefaultColor","Black").

/* Place some text */
RUN pdf_skipn("Spdf",15).
RUN pdf_text    ("Spdf", FILL("<u>HORIZONTAL</u> ",2)).

RUN pdf_text_rotate ("Spdf",90).
RUN pdf_text    ("Spdf", FILL("<i>VERTICAL</i> ",2)).

RUN pdf_text_rotate ("Spdf",0).
RUN pdf_text    ("Spdf", FILL("<b>HORIZON</b> ",2)).

RUN pdf_text_rotate ("Spdf",270).
RUN pdf_text    ("Spdf", FILL("<s>VERT</s> ",2)).

RUN pdf_text_rotate ("Spdf",0).
RUN pdf_set_font ("Spdf",pdf_Font("Spdf"),12).
RUN pdf_text_color ("Spdf",1,0,0).
RUN pdf_text    ("Spdf", "SNAKEHEAD----8~~ ").

/* Part 2 */
RUN pdf_text_rotate ("Spdf",0).
RUN pdf_skipn("Spdf",15).
RUN pdf_text_at    ("Spdf", "HORIZONTAL HORIZONTAL  ",1).

RUN pdf_text_rotate ("Spdf",45).
RUN pdf_text    ("Spdf", " 045 <u>DEGREES</u>").

RUN pdf_text_rotate ("Spdf",315).
RUN pdf_text    ("Spdf", " 315 <url=315>DEGREES</url>").

RUN pdf_text_rotate ("Spdf",135).
RUN pdf_text    ("Spdf", " 135 <s>DEGREES</s>").

RUN pdf_text_rotate ("Spdf",225).
RUN pdf_text    ("Spdf", " 225 <url=225>DEGREES</url>").

RUN pdf_text_rotate ("Spdf",0).
RUN pdf_text    ("Spdf", "  HORIZONTAL HORIZONTAL ").

RUN pdf_text_rotate ("Spdf",5).
RUN pdf_text    ("Spdf", " 5 <url=5>DEGREES</url>").

RUN pdf_text_rotate ("Spdf",0). /* 23-APR-2014 jcc: added */
/* End Part 2 */

/* Part 3 - draw a circle */
RUN pdf_skipn("Spdf",15).
RUN pdf_set_font ("Spdf",pdf_Font("Spdf"), 6).
RUN pdf_text ("Spdf", "  HORIZONTAL HORIZONTAL HORIZONTAL HORIZONTAL HORIZONTAL HORIZONTAL HORIZONTAL ").
RUN pdf_text_color ("Spdf",0,1,0).
DO iAngle = 1 TO 360 BY 4:
    RUN pdf_text_rotate ("Spdf", iAngle).
    RUN pdf_text ("Spdf", "<u>" + STRING(iAngle,">>9 ") + "</u>").
    /* RUN pdf_text ("Spdf", "          " + STRING(iAngle,">>9") + " DEGREES" + " " + STRING(iAngle,">>9") + " DEGREES"). */
END.
RUN pdf_text_rotate ("Spdf",0). /* 23-APR-2014 jcc: added */
/* End part 3 */

/* Part 4 - draw the circle radiuses */
RUN pdf_skipn("Spdf",15).
RUN pdf_text_color ("Spdf",0,0,1).
DO iAngle = 1 TO 360 BY 4:
    RUN pdf_set_textX("Spdf",200).
    RUN pdf_set_textY("Spdf",200).
    RUN pdf_text_rotate ("Spdf", iAngle).
    RUN pdf_text ("Spdf", "----------" + STRING(iAngle,">>9") + " <s>DEGREES</s>" + " " + STRING(iAngle,">>9") + " <u>DEGREES</u>").
END.
/* End part 4 */

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of rotatetext.p */
