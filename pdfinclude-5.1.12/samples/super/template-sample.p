/******************************************************************************

    Program:        template-sample.p

    Description:    This program reads a sample invoice file and then
                    opens and applies a template.
    
******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/template-sample.pdf").

RUN pdf_set_parameter("sPDF","unitTest","TRUE").

/* Setup Tagging */
DEFINE VARIABLE cFont AS CHARACTER NO-UNDO INIT "Courier". /* Helvetica */
RUN pdf_set_parameter("sPDF","TagColor:Black","0,0,0").
RUN pdf_set_parameter("sPDF","TagColor:Red","255,0,0").
RUN pdf_set_parameter("sPDF","TagColor:Green","0,200,0").
RUN pdf_set_parameter("sPDF","TagColor:Blue","0,0,255").
RUN pdf_set_parameter("sPDF","UseTags","TRUE").
RUN pdf_set_parameter("sPDF","BoldFont",cFont + "-Bold").
RUN pdf_set_parameter("sPDF","ItalicFont",cFont + "-Oblique").
RUN pdf_set_parameter("sPDF","BoldItalicFont",cFont + "-BoldOblique").
RUN pdf_set_parameter("sPDF","DefaultFont",cFont).
RUN pdf_set_parameter("sPDF","DefaultColor","Black").
RUN pdf_set_parameter("sPDF","LinkColor","144,12,144"). /* "0,0,255" (blue) by default */

RUN pdf_load_template("Spdf","Template",cPdfIncludePath + "samples/super/template-sample.cfg").

DEFINE VARIABLE v_line  AS CHARACTER NO-UNDO.

RUN pdf_set_Font("Spdf",cFont,7). 
RUN pdf_set_LeftMargin("Spdf",30).

/* Create the first page */
RUN pdf_new_page("Spdf").
RUN pdf_use_template("Spdf","Template").

INPUT FROM VALUE(cPdfIncludePath + "samples/super/template-sample.txt") NO-ECHO.
  REPEAT:
    IMPORT UNFORMATTED v_Line.

    RUN pdf_text    ("Spdf", v_Line).
    RUN pdf_skip    ("Spdf").

    /* If a Page Character is found then perform a New Page.  If text document
       contains no page characters the paging will occur automatically as soon
       as the BottomMargin is reached */
    IF INDEX(v_Line,CHR(12)) > 0 THEN DO:
      RUN pdf_new_page("Spdf").
      RUN pdf_use_template("Spdf","Template").
    END.
  END.
INPUT CLOSE.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of template.pdf */
