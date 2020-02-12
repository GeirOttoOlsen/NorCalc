/******************************************************************************

    Program:        adobe-exemple.p
    
    Description:    

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE INPUT PARAMETER pcRunCase AS CHARACTER   NO-UNDO.

/* DEFINE VARIABLE iFirst  AS INTEGER   NO-UNDO. */
/* DEFINE VARIABLE iSecond AS INTEGER   NO-UNDO. */
/* ETIME(TRUE). */

CASE pcRunCase:
    WHEN "first" THEN DO:
        RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/tests/adobe-exemple.pdf").
        RUN pdf_set_parameter("Spdf","unitTest","TRUE").
        RUN pdf_set_parameter("Spdf","reuseExternal","TRUE").
        /* RUN pdf_set_parameter("spdf", "retainAcroForm", "TRUE"). */
        RUN pdf_set_parameter("spdf", "retainAnnots", "Link").
        /* RUN pdf_set_parameter("spdf", "retainAnnots", "*"). */
        RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/adobe-exemple.pdf","fs").
        RUN pdf_new_page("Spdf").
        RUN pdf_use_PDF_page("Spdf","fs",1).
        RUN pdf_fill_text("Spdf","Name_First","Pointy","").
        RUN pdf_fill_text("Spdf","Name_Last","Haired-Boss","").
        RUN pdf_fill_text("Spdf","Address_1","Eunice street","").
        RUN pdf_fill_text("Spdf","Birthdate","25/12/1969","").
        RUN pdf_fill_text("Spdf","SSN","12345678","").
        RUN pdf_fill_text("Spdf","TRADE CERTIFICATE","On","").
        RUN pdf_fill_text("Spdf","Sex","MALE","").
        RUN pdf_close("Spdf").
        IF RETURN-VALUE > '' THEN
            MESSAGE "1" RETURN-VALUE
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
    WHEN "reuse1" THEN DO:
        /* 20-MAY-2014 jcc: reuse the template */
        RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/tests/adobe-exemple2.pdf").
        RUN pdf_set_parameter("Spdf","unitTest","TRUE").
        RUN pdf_set_parameter("spdf", "retainAnnots", "Link").
        RUN pdf_set_parameter("Spdf","reuseExternal","TRUE").
        RUN pdf_new_page("Spdf").
        /* we reuse the "fs" template, without a call to pdf_open_PDF */
        RUN pdf_use_PDF_page("Spdf","fs",1).
        RUN pdf_fill_text("Spdf","Name_First","Dil","").
        RUN pdf_fill_text("Spdf","Name_Last","Bert","").
        RUN pdf_fill_text("Spdf","Address_1","Dilbert street","").
        RUN pdf_fill_text("Spdf","Birthdate","25/12/1972","").
        RUN pdf_fill_text("Spdf","SSN","98765432","").
        RUN pdf_fill_text("Spdf","HIGH SCHOOL DIPLOMA","On","").
        RUN pdf_fill_text("Spdf","Sex","MALE","").
        RUN pdf_close("Spdf").
        IF RETURN-VALUE > '' THEN
            MESSAGE "2" RETURN-VALUE
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
    WHEN "reuse2" THEN DO:
        /* reuse it again! */
        RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/tests/adobe-exemple3.pdf").
        RUN pdf_set_parameter("Spdf","unitTest","TRUE").
        RUN pdf_set_parameter("spdf", "retainAnnots", "Link").
        /* RUN pdf_set_parameter("Spdf","reuseExternal","TRUE"). */ /* as it is the last one, do not set the parameter so that the cleanup will be done */
        RUN pdf_new_page("Spdf").
        /* we reuse the "fs" template, without a call to pdf_open_PDF */
        RUN pdf_use_PDF_page("Spdf","fs",1).
        RUN pdf_fill_text("Spdf","Name_First","Homer","").
        RUN pdf_fill_text("Spdf","Name_Last","Simpson","").
        RUN pdf_fill_text("Spdf","City","Springfield","").
        RUN pdf_fill_text("Spdf","Birthdate","1/5/1968","").
        RUN pdf_fill_text("Spdf","SSN","00000001","").
        RUN pdf_fill_text("Spdf","BACHELORS DEGREE","On","").
        RUN pdf_fill_text("Spdf","Sex","MALE","").
        RUN pdf_close("Spdf").
        IF RETURN-VALUE > '' THEN
            MESSAGE "3" RETURN-VALUE
                VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
END CASE.

/* end of adobe-exemple.p */
