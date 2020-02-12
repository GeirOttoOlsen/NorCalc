{pdf_inc.i THIS-PROCEDURE}

{tests/pdf_tests.i}

DEF VAR k      AS INT                  NO-UNDO.
DEF VAR t      AS INT                  NO-UNDO.
/* DEF VAR X      AS INT                  NO-UNDO. */
/* DEF VAR Y      AS INT                  NO-UNDO. */
DEF VAR vtexte AS CHAR FORMAT "x(256)" NO-UNDO EXTENT 4.


RUN pdf_new ("Spdf", gcTestsDir + "tests/testtriplast.pdf").

RUN pdf_set_parameter("Spdf", "UnitTest", "TRUE").

RUN pdf_set_PaperType("Spdf","A4").
RUN pdf_set_VerticalSpace("Spdf",12).
RUN pdf_set_BottomMargin("Spdf",312). 
RUN pdf_new_page("Spdf").
RUN pdf_set_font("Spdf","Helvetica",10.0).

ASSIGN vtexte[1] = CHR(10)
                 + "Transformation d'un fixe en ouvrant - Local concierge"
                 + CHR(10)
       vtexte[2] = CODEPAGE-CONVERT("Fourniture et pose d'une tablette en aluminium au-dessus du tableau électrique - Toises 8",SESSION:CHARSET,"iso8859-1")
       vtexte[3] = "Sous-total"
       vtexte[4] = "Rabais 6 %         " + "          " + "77.70" + CHR(10)
                 + "Escompte 2 %       " + "          " + "24.35" + CHR(10)
                 + "Prorata 1 %        " + "          " + "11.95" + CHR(10)
                 + "Assurance TC 0,35 %" + "          " + "4.15".
DO k = 1 TO 4:
  RUN pdf_text_at("Spdf",FILL("x",10),21).
  /* Y = pdf_TextY("Spdf") + pdf_PointSize("Spdf"). */
  RUN pdf_Wrap_Text("Spdf",vtexte[k],40,85,"LEFT",OUTPUT t).
  /* X = pdf_LeftMargin("Spdf") + pdf_text_width("Spdf", FILL(" ", 40 - 1)). */
  /* RUN pdf_rect2("Spdf", X, Y, 205.9, pdf_TextY("Spdf") - Y, .5). */
  RUN pdf_text_to("Spdf",STRING(9999.99, "->>>,>>9.99"),87).
  RUN pdf_skip("Spdf").
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
