{pdf_inc.i "THIS-PROCEDURE"}
{ samples/support/config.i }

DEFINE VARIABLE iAngle AS INTEGER     NO-UNDO.
DEFINE VARIABLE gcDir AS CHARACTER  INITIAL "C:\User\JCCARDOT\Perso\Travail\pdfinc\PDFinclude4.0\pdfinclude\samples\super"  NO-UNDO.
DEFINE VARIABLE lOpened AS LOGICAL     NO-UNDO.

DO iAngle = 0 TO 355 BY 5:
    RUN pdf_new("s", cPdfIncludePath + "samples/super/ext-rotate." + STRING(iAngle) + ".pdf").
    RUN pdf_set_parameter("s", "UseExternalPageSize", "TRUE").
    RUN pdf_set_parameter("s", "ReuseExternal", STRING(iAngle < 355, "TRUE/FALSE")).
    IF NOT lOpened THEN
        RUN pdf_open_pdf("s", cPdfIncludePath + "samples/support/A4.pdf", "A4").
    lOpened = YES.
    RUN pdf_new_page("s").
    RUN pdf_place_pdf_page("s","A4",1,"Rotate=" + STRING(iAngle) + ",Scale=0.6").
    RUN pdf_close("s").
    IF RETURN-VALUE > "" THEN
        MESSAGE RETURN-VALUE
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
END.

