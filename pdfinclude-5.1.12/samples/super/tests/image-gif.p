/*******************************************************************************

    Program:        image-gif.p
    
    Description:    Illustrates how to include images in a pdf

    History:        

*******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE INPUT PARAMETER pcRunCase AS CHARACTER   NO-UNDO.
/* DEFINE VARIABLE pcRunCase AS CHARACTER INITIAL "nocache" NO-UNDO. */

IF pcRunCase = "cleanCache" THEN DO:
    /* empty the cache */
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\*.cache").
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\*.data").
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\*.pal").
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\*.alpha.z").
    OS-COMMAND SILENT VALUE("del " + SESSION:TEMP-DIRECTORY + "pdfcache\*.rgb.z").
    RETURN.
END.
/* ETIME (TRUE). */

/* Create stream for new PDF file */
RUN pdf_new("Spdf",cPdfIncludePath + "samples/super/tests/image-gif." + pcRunCase + ".pdf").

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
RUN pdf_text_xy("Spdf", "GIF", 1, pdf_Pageheight("Spdf") - 188 - pdf_PointSize("Spdf")).

RUN pdf_load_image ("Spdf", "sun", cPdfIncludePath + "samples/support/gif/sun.gif").
RUN pdf_place_image ("Spdf", "sun", 300, 750, ?, ?).
RUN pdf_text_xy("Spdf", "GIF", 300, pdf_Pageheight("Spdf") - 750 - pdf_PointSize("Spdf")).

RUN pdf_load_image ("Spdf", "time", cPdfIncludePath + "samples/support/gif/time.gif").
RUN pdf_place_image ("Spdf", "time", 550, 60, ?, ?).
RUN pdf_text_xy("Spdf", "GIF (transp.)", 520, pdf_Pageheight("Spdf") - 60 - pdf_PointSize("Spdf")).

/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/helpbook2.gif"). */

/* interlaced: not supported */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/helpbook.gif"). */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/penguineyes.gif"). */

/* 4 bits depth picture: not supported */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/sound2.gif"). */
/* RUN pdf_load_image ("Spdf", "mygif", cPdfIncludePath + "samples/support/gif/sound.gif"). /* 4 bits */ */


RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* MESSAGE ETIME */
    /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
