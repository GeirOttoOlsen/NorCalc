/*------------------------------------------------------------------------------
  pdftk.p
  Purpose:     concatenate pdf files
  Parameters:  
  Notes:       15-JAN-2015 jcc: creation
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcInputFiles AS CHARACTER   NO-UNDO. /* CHR(1) separated */
DEFINE INPUT PARAMETER pcAction     AS CHARACTER   NO-UNDO. /* "concat" */
DEFINE INPUT PARAMETER pcOptions    AS CHARACTER   NO-UNDO. /* "" */
DEFINE INPUT PARAMETER pcOutputFile AS CHARACTER   NO-UNDO. /* full path name */

{pdf_inc.i "THIS-PROCEDURE"}.

DEFINE VARIABLE cPdfId     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE iFile      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPage      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPageCount AS INTEGER     NO-UNDO.

RUN pdf_new("s", pcOutputFile).

RUN pdf_set_parameter("s", "compress", "TRUE").
RUN pdf_set_parameter("s", "retainAnnots", "*"). /* keep all annotations  */
RUN pdf_set_parameter("s", "UseExternalPageSize", "TRUE"). /* use the input file page size */

RUN pdf_set_info("s", "Producer", "PDFInclude toolkit").

DO iFile = 1 TO NUM-ENTRIES(pcInputFiles, CHR(1)):
    cPdfId = "p" + STRING(iFile).
    /* open & parse the input file */
    RUN pdf_open_pdf("s", ENTRY(iFile, pcInputFiles, CHR(1)), cPdfId).
    /* get the number of pages */
    RUN pdf_ext_get_nb_pages("s", cPdfId, OUTPUT iPageCount).
    /* copy the input pages to the output file */
    DO iPage = 1 TO iPageCount:
        RUN pdf_new_page("s").
        RUN pdf_use_pdf_page2("s", cPdfId, iPage, ""). /* will change the page size according to the external file page size */
    END.
END.

RUN pdf_close("s") NO-ERROR.
IF RETURN-VALUE > "" THEN
    MESSAGE "Error(s) while generating the PDF file:" SKIP RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

