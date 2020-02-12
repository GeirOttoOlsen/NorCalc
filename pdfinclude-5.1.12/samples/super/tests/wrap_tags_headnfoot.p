/******************************************************************************

    Program:        wrap_tags_headnfoot.p
    
    Description:    test that the tags do not disturb headers and footers

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE t      AS INTEGER     NO-UNDO.
DEFINE VARIABLE vsouli AS LOGICAL     NO-UNDO.
DEFINE VARIABLE vtexte AS CHARACTER   NO-UNDO.

/* MESSAGE "voulez-vous le texte souligné" VIEW-AS ALERT-BOX BUTTONS YES-NO */
  /* UPDATE vsouli AS LOG. */
vsouli = YES.

RUN pdf_new("spdf",cPdfIncludePath + "samples/super/tests/wrap_tags_headnfoot.pdf").
RUN pdf_set_parameter("spdf","UnitTest","TRUE").
pdf_PageHeader("spdf", THIS-PROCEDURE:HANDLE,"entete").  
RUN pdf_set_PaperType("spdf","A4").
RUN pdf_set_VerticalSpace("spdf",12).  
RUN pdf_set_BottomMargin("spdf",100). 
RUN pdf_new_page("spdf").
pdf_Pagefooter("spdf", THIS-PROCEDURE:HANDLE,"pied"). 

RUN pdf_set_font("spdf","Helvetica-bold",10.0).
ASSIGN vtexte = "blabla ligne 1" + CHR(10)
              + "blabla ligne 2" + CHR(10)
              + "blabla ligne 3" + CHR(10)
              + "blabla ligne 4" + CHR(10).

IF vsouli THEN
DO:
  RUN pdf_set_parameter("spdf","UseTags","TRUE").
  RUN pdf_set_parameter("spdf","BoldFont","Helvetica-Bold").
  RUN pdf_set_parameter("spdf","ItalicFont","Helvetica-Oblique").
  RUN pdf_set_parameter("spdf","tagColor:red","255,0,0").
  RUN pdf_set_parameter("spdf","tagColor:green","0,255,0").
END.

/* underscore */

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text_xy(
    "spdf",
    "<u>" + vtexte + "</u>",
    50,pdf_TextY("spdf"),550,100,pdf_VerticalSpace("spdf"),"LEFT").

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text(
    "spdf",
    "<u>" + vtexte + "</u>",
    21,50,"left",OUTPUT t).

/* strike */

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text_xy(
    "spdf",
    "<s>" + vtexte + "</s>",
    50,pdf_TextY("spdf"),550,100,pdf_VerticalSpace("spdf"),"LEFT").

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text(
    "spdf",
    "<s>" + vtexte + "</s>",
    21,50,"left",OUTPUT t).

/* link */

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text_xy(
    "spdf",
    "<url=http://example.com>" + vtexte + "</url>",
    50,pdf_TextY("spdf"),550,100,pdf_VerticalSpace("spdf"),"LEFT").

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text(
    "<url=http://example.com>" + vtexte + "</url>",
    "<s>" + vtexte + "</s>",
    21,50,"left",OUTPUT t).

/* color */

vtexte = "<color=red><u>" + REPLACE(vtexte, "ligne", "<color=green>ligne</color>") + "</u></color>".

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text_xy(
    "spdf",
    vtexte,
    50,pdf_TextY("spdf"),550,100,pdf_VerticalSpace("spdf"),"LEFT").

RUN pdf_set_textY("spdf",124).
RUN pdf_skip("spdf").
RUN pdf_Wrap_Text(
    vtexte,
    "<s>" + vtexte + "</s>",
    21,50,"left",OUTPUT t).


IF vsouli THEN RUN pdf_set_parameter("spdf","UseTags","FALSE").
RUN pdf_set_font("spdf","Helvetica",10.0).

RUN pdf_close("Spdf").

PROCEDURE entete:
  RUN pdf_set_textY("spdf",800).
  RUN pdf_set_font("spdf","Helvetica",10.0).
  RUN pdf_text_xy("spdf","Ligne entete 1",50,pdf_TextY("spdf")).
  RUN pdf_skip("spdf").
  RUN pdf_text_xy("spdf","Ligne entete 2",50,pdf_TextY("spdf")).
  RUN pdf_skip("spdf").
  RUN pdf_line ("spdf",50,pdf_TextY("spdf") + 6,550,pdf_TextY("spdf") + 6,0.75).
  RUN pdf_skipn("spdf",2).
  RUN pdf_set_font("spdf","Helvetica-oblique",11.0).
END.

PROCEDURE Pied:
  RUN pdf_skip("spdf").
  RUN pdf_line ("spdf",50,pdf_TextY("spdf") + 6,550,pdf_TextY("spdf") + 6,0.75).
  RUN pdf_skipn("spdf",2).
  RUN pdf_set_font("spdf","Helvetica",10.0).
  RUN pdf_text_xy("spdf","Ligne pied 1",50,pdf_TextY("spdf")).
  RUN pdf_skip("spdf").
  RUN pdf_text_xy("spdf","Ligne pied 2",50,pdf_TextY("spdf")).
  RUN pdf_set_font("spdf","Helvetica",10.0).

END.
