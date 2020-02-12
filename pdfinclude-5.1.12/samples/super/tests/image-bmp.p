/*******************************************************************************

    Program:        image-gif.p
    
    Description:    Illustrates how to include images in a pdf

    History:        

*******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE INPUT PARAMETER pcRunCase AS CHARACTER   NO-UNDO.
/* DEFINE VARIABLE pcRunCase AS CHARACTER   INITIAL "nocache" NO-UNDO. */

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
RUN pdf_new("Spdf",cPdfIncludePath + "samples/super/tests/image-bmp." + pcRunCase + ".pdf").

RUN pdf_set_parameter("Spdf","unittest","TRUE").
/* RUN pdf_set_parameter("Spdf","Compress","TRUE"). */

/* Instantiate a New Page */
RUN pdf_new_page("Spdf").

/* Load & place BMP File */
/* 1 bit */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/Yuerlingwood.bmp"). */
RUN pdf_load_image ("Spdf", "indian2", cPdfIncludePath + "samples/support/bmp/indian2.bmp").
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/horses2.bmp"). */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/Edisonwood.bmp"). */
RUN pdf_place_image ("Spdf", "indian2", 10, 130, 178, 120).
RUN pdf_text_xy("Spdf", "BMP 1 bit", 10, pdf_PageHeight("Spdf") - 130 - pdf_PointSize("Spdf")).

/* 4 bits */
RUN pdf_load_image ("Spdf", "cntnrdlg", cPdfIncludePath + "samples/support/bmp/cntnrdlg.bmp").
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/spin.bmp"). */
RUN pdf_place_image ("Spdf", "cntnrdlg", 10, 350, ?, ?).
RUN pdf_text_xy("Spdf", "BMP 4 bits", 10, pdf_PageHeight("Spdf") - 350 - pdf_PointSize("Spdf")).

/* 8 bits */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/cat15.bmp"). */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/cat7.bmp"). */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/psa.bmp"). */
RUN pdf_load_image ("Spdf", "MONTAGE", cPdfIncludePath + "samples/support/bmp/MONTAGE.bmp").
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/toolclip.original.bmp"). */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/imglores.bmp"). */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/horses.bmp"). */
RUN pdf_place_image ("Spdf", "MONTAGE", 350, 500, ?, ?).
RUN pdf_text_xy("Spdf", "BMP 8 bits", 350, pdf_PageHeight("Spdf") - 500 - pdf_PointSize("Spdf")).

/* 16 bits */
RUN pdf_load_image ("Spdf", "DebugSplash16", cPdfIncludePath + "samples/support/bmp/DebugSplash16.bmp").
RUN pdf_place_image ("Spdf", "DebugSplash16", 400, 150, 192, 128).
RUN pdf_text_xy("Spdf", "BMP 16 bits", 400, pdf_PageHeight("Spdf") - 150 - pdf_PointSize("Spdf")).

/* 24 bits */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/SplashScreen.bmp"). */
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/splash.bmp"). */
RUN pdf_load_image ("Spdf", "euro_2", cPdfIncludePath + "samples/support/bmp/euro_2.bmp").
/* RUN pdf_load_image ("Spdf", "mybmp", cPdfIncludePath + "samples/support/bmp/euro_3.bmp"). */
RUN pdf_place_image ("Spdf", "euro_2", 10, 780, ?, ?).
RUN pdf_text_xy("Spdf", "BMP 24 bits", 10, pdf_PageHeight("Spdf") - 780 - pdf_PointSize("Spdf")).

/* 32 bits */
RUN pdf_load_image ("Spdf", "DebugSplash32", cPdfIncludePath + "samples/support/bmp/DebugSplash32.bmp").
RUN pdf_place_image ("Spdf", "DebugSplash32", 100, 600, 192, 128).
RUN pdf_text_xy("Spdf", "BMP 32 bits", 100, pdf_PageHeight("Spdf") - 600 - pdf_PointSize("Spdf")).


RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* MESSAGE ETIME */
    /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
