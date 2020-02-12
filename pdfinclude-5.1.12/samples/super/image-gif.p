/*******************************************************************************

    Program:        image-gif.p
    
    Description:    Illustrates how to include images in a pdf

    History:        

*******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

ETIME (TRUE).

/* Create stream for new PDF file */
RUN pdf_new("Spdf",cPdfIncludePath + "samples/super/image-gif.pdf").

RUN pdf_set_parameter("Spdf","unittest","TRUE").
/* RUN pdf_set_parameter("Spdf","Compress","TRUE"). */

/* Instantiate a New Page */
RUN pdf_new_page("Spdf").

/* GIF */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/splash.gif"). */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/SplashScreenLogo_v20.gif"). */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/diag1.gif"). */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/diag2.gif"). */

RUN pdf_load_image ("Spdf", "wsbgr", cPdfIncludePath + "samples/support/gif/wsbgr.gif").
RUN pdf_place_image ("Spdf", "wsbgr", 0, 188, ?, ?).

RUN pdf_load_image ("Spdf", "sun", cPdfIncludePath + "samples/support/gif/sun.gif").
RUN pdf_place_image ("Spdf", "sun", 300, 790, ?, ?).

RUN pdf_load_image ("Spdf", "time", cPdfIncludePath + "samples/support/gif/time.gif").
RUN pdf_place_image ("Spdf", "time", 550, 60, ?, ?).

/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/helpbook2.gif"). */
/* interlaced */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/helpbook.gif"). */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/penguineyes.gif"). */
/* 4 bits depth picture: won't work */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/sound2.gif"). */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/sound.gif"). /* 4 bits */ */


RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* MESSAGE ETIME */
    /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
