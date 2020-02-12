/******************************************************************************

    Program:        curve.p
    
    Description:    Illustrates a curve

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/curve.pdf").

RUN pdf_set_parameter("sPDF","unitTest","TRUE").

RUN pdf_new_page("Spdf").

RUN pdf_stroke_color("Spdf",0.0, 1.0, 0.0). 
RUN pdf_stroke_fill("Spdf",0.0, 1.0, 0.0). 
RUN pdf_set_linecap("Spdf", 1).

RUN pdf_move_to("Spdf",250,200).
RUN pdf_curve("Spdf",350,282.84271,282.84271,350,200,350,1.0).
RUN pdf_close_path("Spdf"). 

RUN pdf_stroke_color("Spdf",0.0, 0.0, 1.0). 
RUN pdf_stroke_fill("Spdf",0.0, 0.0, 1.0). 

RUN pdf_move_to("Spdf",150,100).
RUN pdf_curve("Spdf",350,282.84271,282.84271,350,200,350,10.0).
RUN pdf_close_path("Spdf"). 

/* 16-MAY-2014 jcc: also test more APIs */
RUN pdf_stroke_color("Spdf",0.0, 0.0, 0.0). 
RUN pdf_stroke_fill("Spdf",1.0, 0.0, 0.0). 
RUN pdf_circle("Spdf", 300, 400, 50, 0.5).
RUN pdf_stroke_fill("Spdf",1.0, 0.0, 1.0). 
RUN pdf_ellipse("Spdf", 250, 100, 60, 30, 0.35, 0.5).
/* pdf_ellipse can also give fun shapes: */
RUN pdf_set_dash("Spdf", 2, 2).
RUN pdf_ellipse("Spdf", 100, 700, 70, 30, 0, 0.5). /* losange */
RUN pdf_ellipse("Spdf", 250, 700, 70, 30, 0.1, 0.5). /* rounded losange */
RUN pdf_ellipse("Spdf", 400, 700, 70, 30, 0.7, 0.5).
RUN pdf_ellipse("Spdf", 100, 600, 60, 20, 1, 0.5).
RUN pdf_ellipse("Spdf", 250, 600, 60, 20, 1.5, 0.5).
RUN pdf_ellipse("Spdf", 400, 600, 60, 20, 2, 0.5).
RUN pdf_ellipse("Spdf", 550, 600, 30, 20, 4, 0.5).
RUN pdf_ellipse("Spdf", 550, 700, 10, 10, 10, 0.5).

RUN pdf_set_dash("Spdf", 1, 0).
RUN pdf_stroke_color("Spdf",0.0, 1.0, 1.0). 
RUN pdf_stroke_fill("Spdf",1.0, 1.0, 0.0). 
RUN pdf_set_linejoin("Spdf", 1).
RUN pdf_rectdec("Spdf", 40, 500, 80, 40, 10).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of curve.p */
