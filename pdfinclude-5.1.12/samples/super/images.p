/*******************************************************************************

    Program:        images.p
    
    Description:    Illustrates how to include images in a pdf

    History:        

*******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

ETIME (TRUE).

/* Create stream for new PDF file */
RUN pdf_new("Spdf",cPdfIncludePath + "samples/super/images.pdf").

RUN pdf_set_parameter("Spdf","unittest","TRUE").
/* RUN pdf_set_parameter("Spdf","Compress","TRUE"). */

/* Instantiate a New Page */
RUN pdf_new_page("Spdf").

/* Load & place jpg File */
/* RGB */
RUN pdf_load_image ("Spdf", "myjpg", cPdfIncludePath + "samples/support/prosyslogo.jpg").
RUN pdf_place_image ("Spdf", "myjpg", pdf_LeftMargin("Spdf"), pdf_TopMargin("Spdf") - 20, 179, 20).
/* Grayscale */
RUN pdf_load_image ("Spdf", "mygrayjpg", cPdfIncludePath + "samples/support/jpeg/grayscale2.jpg").
RUN pdf_place_image ("Spdf", "mygrayjpg", 300, 150, 90, 80).
/* CMYK */
RUN pdf_load_image ("Spdf", "mycmykjpg", cPdfIncludePath + "samples/support/jpeg/cmyk_sample2.jpg").
RUN pdf_place_image ("Spdf", "mycmykjpg", 25, 130, 260, 96).

/* Load & place gif File */
/* Currently not supported */
/* RUN pdf_load_image ("Spdf","gif",cPdfIncludePath + "samples/support/test.gif"). */
/* RUN pdf_place_image ("Spdf","gif",pdf_LeftMargin("Spdf"), pdf_TopMargin("Spdf") + 100, 179, 20). */

/* write some text to check for the transparency of the 1st png */
RUN pdf_wrap_text_xy_dec (
    'Spdf',
    "un deux trois quatre cinq six sept huit neuf dix onze douze treize quatorze quinze seize dix-sept dix-huit dix-neuf vingt",
    120, 570, 200, 300, 
    10.5,
    'LEFT').

RUN pdf_wrap_text_xy_dec (
    'Spdf',
    "un deux trois quatre cinq six sept huit neuf dix onze douze treize quatorze quinze seize dix-sept dix-huit dix-neuf vingt",
    120, 470, 200, 300, 
    10.5,
    'LEFT').

RUN pdf_stroke_fill('Spdf', 0, 127, 127).
RUN pdf_rect ('Spdf', 120, 470, 300, 100, 0.5).

/* Load & place png Files */
/* 1. a plain one (RGB, one transparent colour) */
RUN pdf_load_image ("Spdf","mypngrgbtransp",
cPdfIncludePath + "samples/support/png/rgb-1transp.png").
RUN pdf_place_image ("Spdf","mypngrgbtransp",pdf_LeftMargin("Spdf") + 200, pdf_TopMargin("Spdf") + 301, ?, ?).
/* 2. one with transparency (indexed, one completely transparent colour) */
RUN pdf_load_image ("Spdf","mypngidxtransp",
cPdfIncludePath + "samples/support/png/indexed-1transp.png").
RUN pdf_place_image ("Spdf","mypngidxtransp",pdf_LeftMargin("Spdf") + 200, pdf_TopMargin("Spdf") + 200, ?, ?).
/* 3. and one with a transparent (alpha) layer */
/* 3a. 16 bits components */
RUN pdf_load_image ("Spdf","mypngalpha",cPdfIncludePath + "samples/support/png/alpha.png").
RUN pdf_place_image ("Spdf","mypngalpha",pdf_LeftMargin("Spdf") + 220, pdf_TopMargin("Spdf") + 400, ?, ?).
/* add the generated mask to check it visually and because it it fun ;-) */
RUN pdf_place_image ("Spdf","mypngalpha-mask",pdf_LeftMargin("Spdf") + 220, pdf_TopMargin("Spdf") + 700, ?, ?).
/* 3b. 8 bits components */
RUN pdf_load_image ("Spdf","mypngalpha8",cPdfIncludePath + "samples\support\png\fbt_rgba_ni.png").
/*RUN pdf_load_image ("Spdf","mypngalpha8",cPdfIncludePath + "samples\support\png\stefan_255_rgba.png").*/
RUN pdf_place_image ("Spdf","mypngalpha8",pdf_LeftMargin("Spdf") + 100, pdf_TopMargin("Spdf") + 300, ?, ?).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

MESSAGE ETIME
    VIEW-AS ALERT-BOX INFO BUTTONS OK.
