{pdf_inc.i "THIS-PROCEDURE"}

{tests/pdf_tests.i}

/* DEFINE INPUT  PARAMETER lXY AS LOGICAL     NO-UNDO. */
DEFINE VARIABLE lXY AS LOGICAL  INITIAL NO   NO-UNDO.

DEF VAR wTexteWrap AS CHAR.
DEF VAR wCurrentY AS INT.

wTexteWrap = "ligne 1" + CHR(10)
           + "ligne 2" + CHR(10)
           + "ligne 3" + CHR(10)
           + "ligne 4" + CHR(10)
           + "ligne 5" + CHR(10)
           + "ligne 6" + CHR(10)
           + "ligne 7" + CHR(10)
           + "ligne 8" + CHR(10)
           + "ligne 9" + CHR(10).

RUN pdf_new("sPdf", gcTestsDir + "tests/testwrap" + TRIM(STRING(lXY, "XY/")) + ".pdf").
RUN pdf_set_parameter("sPdf", "unittest", "true").
RUN pdf_set_PaperType("sPdf","A4").
pdf_PageHeader("sPdf", THIS-PROCEDURE:HANDLE, "entete").
RUN pdf_new_page("sPdf").
RUN pdf_set_textY("sPdf",20).

/* DEBUGGER:INITIATE(). */
/* DEBUGGER:SET-BREAK(). */
IF lXY THEN DO:
    RUN pdf_stroke_fill("sPdf",1,1,1).
    RUN pdf_rect("sPdf",70,500 + pdf_PointSize("spdf") - 68,510,68,.5).
    RUN pdf_Wrap_Text_xy("sPdf",wTexteWrap,70,500,510,68,11,"LEFT").
    RUN pdf_rect("sPdf",70,pdf_textY("sPdf") + pdf_PointSize("spdf") - 68,510,68,.5).
    RUN pdf_Wrap_Text_xy("sPdf",wTexteWrap,70,pdf_textY("sPdf"),510,68,11,"LEFT").
END.
ELSE DO:
    RUN pdf_set_textY("sPdf",20).
    RUN pdf_Wrap_Text   ("sPdf",wTexteWrap,21,85,"LEFT", OUTPUT wCurrentY).
END.

RUN pdf_close("sPdf").
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

PROCEDURE entete:
    RUN pdf_text_at ("sPdf","Ligne entete 1",25).
    RUN pdf_skip("sPdf").
    RUN pdf_text_at ("sPdf","Ligne entete 2",25).
    RUN pdf_skip("sPdf").
    RUN pdf_text_at ("sPdf","Ligne entete 3",25).
    RUN pdf_skip("sPdf").
    RUN pdf_text_at ("sPdf","Ligne entete 4",25).
    RUN pdf_skip("sPdf").
    RUN pdf_text_at ("sPdf","Ligne entete 5",25).
    RUN pdf_skipn("sPdf",6).
    /* RUN pdf_set_texty("spdf", pdf_Pageheight("spdf") - pdf_TopMargin("spdf")). */
 END.
