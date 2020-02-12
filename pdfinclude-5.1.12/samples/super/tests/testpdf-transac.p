  DEF VAR t AS INT NO-UNDO.
  DEF VAR v AS INT NO-UNDO.

  DEF VAR oldy AS INT NO-UNDO.

  DEFINE VARIABLE cType AS CHARACTER INITIAL "to"  NO-UNDO.

  {pdf_inc.i "THIS-PROCEDURE"}
  RUN pdf_new("Spdf","C:\User\JCCARDOT\Perso\Travail\pdfinc\PDFinclude4.0\pdfinclude\tmp\mediainfo\testpdf-transac-" + cType + ".pdf").
  RUN pdf_set_PaperType("Spdf","A4").
  RUN pdf_set_VerticalSpace("Spdf",12).
  RUN pdf_set_BottomMargin("Spdf",50).
  RUN pdf_set_TopMargin("Spdf",20).

  pdf_PageHeader("Spdf", THIS-PROCEDURE:HANDLE,"entete").

  RUN pdf_new_page("Spdf").

  REPEAT:
    ASSIGN v = v + 1.

    oldy = pdf_texty("Spdf").
    RUN pdf_transaction_begin("Spdf").

    RUN pdf_line("Spdf",pdf_TextX("Spdf") + 55,pdf_TextY("Spdf"),pdf_TextX("Spdf") + 573,pdf_TextY("Spdf"),0.5).
    RUN pdf_skip("Spdf").
    RUN pdf_set_font("Spdf","Helvetica-Bold",12.0).
    RUN pdf_text_at("Spdf","aaaaaaa",18).
    RUN pdf_skip("Spdf").
    RUN pdf_set_font("Spdf","Helvetica",10.0).
    RUN pdf_text_at("Spdf","bbbbbbb",21).
    RUN pdf_text_at("Spdf","ccccc",110).
    RUN pdf_text_at("Spdf","ddddd",120).

    CASE cType:
        WHEN "at" THEN
            /* Avec l'instruction suivante c'est OK */
            RUN pdf_text_at("Spdf","eeeeee",194).
        WHEN "to" THEN
            /* Avec l'instruction suivante ce n'est pas OK */
            RUN pdf_text_to("Spdf","eeeeee",87).
        OTHERWISE DO:
            MESSAGE "cType must be at or to."
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            QUIT.
        END.
    END CASE.


    RUN pdf_skipn("Spdf",2).

    RUN pdf_text_at("Spdf","Problème enregistré le " + STRING(TODAY, "99/99/9999") + ":",21).
    RUN pdf_skip("Spdf").
    RUN pdf_Wrap_Text("Spdf","ffffffffffffff",21,130,"LEFT",OUTPUT t).
    RUN pdf_skipn("Spdf",2).
    RUN pdf_text_at("Spdf","Décision:",21).
    RUN pdf_skip("Spdf").
    RUN pdf_Wrap_Text("Spdf","ggggggggggggggg",21,130,"LEFT",OUTPUT t).
    RUN pdf_skipn("Spdf",2).
    RUN pdf_text_at("Spdf","Conclusion:",21).
    RUN pdf_skip("Spdf").
    RUN pdf_Wrap_Text("Spdf","hhhhhhhhhhhhhhhhhh",21,130,"LEFT",OUTPUT t).
    RUN pdf_skipn("Spdf",2).

    /* if we went too far, rollback the transaction */
    IF pdf_textY("Spdf") > oldy THEN DO: /* if there has been an automatic new page */
        RUN pdf_transaction_rollback("Spdf").
        RUN pdf_line("Spdf",pdf_TextX("Spdf") + 55,pdf_TextY("Spdf"),pdf_TextX("Spdf") + 573,pdf_TextY("Spdf"),0.5).
        v = v - 1.
        RUN pdf_new_page("Spdf").
    END.
    ELSE DO:
        RUN pdf_transaction_commit("Spdf").
    END.

    IF v GT 10
    THEN LEAVE.
  END.
  
  RUN pdf_line("Spdf",pdf_TextX("Spdf") + 55,pdf_TextY("Spdf"),pdf_TextX("Spdf") + 573,pdf_TextY("Spdf"),0.5).

  RUN pdf_close("Spdf").
  IF RETURN-VALUE > "" THEN
      MESSAGE RETURN-VALUE
          VIEW-AS ALERT-BOX INFO BUTTONS OK.

  PROCEDURE entete:
    RUN pdf_set_font("Spdf","Helvetica",10.0).
    RUN pdf_text_at("Spdf","SUIVI TECHNIQUE PARTICULIER AU " + STRING(TODAY, "99/99/9999"),21).
    RUN pdf_text_to("Spdf","Page " + STRING(pdf_Page("Spdf")),87).
    RUN pdf_skip("Spdf").
  END.
