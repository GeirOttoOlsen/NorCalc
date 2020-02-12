
/* concat.p */

/* 02-DEC-2014 jcc: concatenate pdf files in the src/ sub-directory */

&GLOBAL-DEFINE PDFINCVERSION "PDFInclude 5.0 beta1"

{pdf_inc.i "THIS-PROCEDURE"}

{samples/support/config.i} /* cPdfIncludePath */

DEFINE VARIABLE cDestDir AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cDir     AS CHARACTER   INITIAL "tmp/concat/concat.p" NO-UNDO.
DEFINE VARIABLE cFile    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSrcDir  AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iTmpl    AS INTEGER     NO-UNDO.


PROCEDURE appendPDF:
    DEFINE INPUT PARAMETER pdfStream AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcFile    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER piTmpl    AS INTEGER     NO-UNDO.

    DEFINE VARIABLE cPath    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cTmpl    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cType    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cValue   AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iNbPages AS INTEGER     NO-UNDO.

    cTmpl = "tmpl" + STRING(piTmpl).

    RUN pdf_open_pdf("s", cDir + "src/" + pcFile, cTmpl).

    RUN pdf_ext_get_path("s", cTmpl, ?, "/Root/Pages/Count", OUTPUT cPath, OUTPUT cType, OUTPUT cValue).
    iNbPages = INTEGER(cValue).
    IF iNbPages = ? THEN DO:
        RUN pdf_ext_get_path("s", cTmpl, ?, "/Root/Pages/Kids", OUTPUT cPath, OUTPUT cType, OUTPUT cValue).
        IF cValue <> ? THEN
            iNbPages = NUM-ENTRIES(cValue, CHR(1)) - 1.
    END.

    DO i = 1 TO iNbPages:
        /* IF piTmpl = 1 THEN */
            /* RUN pdf_set_pagerotate(pdfStream, 90). */
        /* ELSE */
            /* RUN pdf_set_pagerotate(pdfStream, 0). */
        RUN pdf_new_page(pdfStream).
        RUN pdf_use_pdf_page(pdfStream, cTmpl, i).
    END.

END PROCEDURE.

cDir     = REPLACE(SEARCH(cDir), "~\", "/").
cDir     = SUBSTRING(cDir, 1, R-INDEX(cDir, "/")).
cSrcDir  = REPLACE(cDir, "/", "\") + "src".
cDestDir = REPLACE(cDir, "/", "\").

RUN pdf_new("s", cDestDir + "concat.pdf").

RUN pdf_set_parameter("s", "compress", "TRUE").
RUN pdf_set_parameter("s", "UseExternalPageSize", "TRUE").
RUN pdf_set_parameter("s", "formFlatten", ""). /* keep the forms as is */
RUN pdf_set_parameter("s", "retainAnnots", "*"). /* keep all annotations  */

RUN pdf_set_info("s", "Producer", {&PDFINCVERSION}).

INPUT FROM OS-DIR(cSrcDir).
REPEAT:
    IMPORT cFile.
    IF cFile MATCHES "*.pdf" THEN DO:
        iTmpl = iTmpl + 1.
        RUN appendPDF ("s", cFile, iTmpl).
    END.
END.
INPUT CLOSE.
    
RUN pdf_close("s").
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.


