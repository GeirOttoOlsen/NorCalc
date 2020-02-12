/*******************************************************************************

    Program:        readme.p
    
    Description:    Generates readme.pdf from the readme.txt file

*******************************************************************************/
{samples/support/config.i}

{readme/evalABL.i} /* evaluate formulae */

{pdf_inc.i "THIS-PROCEDURE"}

FUNCTION basename           RETURNS CHARACTER (ipcFile AS CHARACTER) IN h_PDFinc.
FUNCTION getWidgetOption2   RETURNS CHARACTER (pOption  AS CHARACTER, pOptions AS CHARACTER, pDefault AS CHARACTER) IN h_PDFinc.
FUNCTION pdf_in_transaction RETURNS LOGICAL   (pdfStream AS CHARACTER) IN h_PDFinc.
/* FUNCTION pdf_text_width     RETURNS INTEGER   (pdfStream AS CHARACTER, pdfText AS CHARACTER) IN h_PDFinc. */
FUNCTION replaceQuotes RETURNS CHARACTER (pcString AS CHARACTER) IN THIS-PROCEDURE.

SUBSCRIBE TO "GeneratePDFPage" IN h_PDFinc.
SUBSCRIBE TO "InsertPDFPage"   IN h_PDFinc.
DEFINE VARIABLE iNumInsertedPages AS INTEGER   NO-UNDO.
DEFINE VARIABLE lNewPage          AS LOGICAL   NO-UNDO.
PROCEDURE GeneratePDFPage:
    DEFINE INPUT PARAMETER pdfStream AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pdfPage   AS INTEGER     NO-UNDO.
    lNewPage = YES.
END.
PROCEDURE InsertPDFPage:
    DEFINE INPUT PARAMETER pdfStream AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pdfPage   AS INTEGER     NO-UNDO.
    iNumInsertedPages = iNumInsertedPages + 1.
END.

/* 14-OCT-2014 jcc: use the syntaxic coloration library */
DEFINE VARIABLE hABLColor AS HANDLE   NO-UNDO.
RUN lib/pdf_ABL_color.p PERSISTENT SET hABLColor (h_PDFinc).

DEFINE TEMP-TABLE ttProcsAndFuncs NO-UNDO
 FIELD name AS CHARACTER
 FIELD type AS CHARACTER
 INDEX ix name
 INDEX ix2 type name.

DEFINE TEMP-TABLE ttTOC NO-UNDO LABEL "Table of contents Temp-table"
 FIELD id       AS INTEGER
 FIELD level    AS INTEGER
 FIELD name     AS CHARACTER
 FIELD tocpage  AS INTEGER
 FIELD textX    AS DECIMAL
INDEX ix IS PRIMARY UNIQUE id.

DEFINE VARIABLE cBookmarks         AS CHARACTER   NO-UNDO INITIAL ",,,,,,". /* keep track of the parent bookmarks */.
DEFINE VARIABLE cChar              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFont              AS CHARACTER   NO-UNDO INITIAL "Helvetica".
DEFINE VARIABLE cLine              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOldFont           AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cText              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cType              AS CHARACTER   NO-UNDO.
DEFINE VARIABLE deCodeFontSize     AS DECIMAL     INIT 10 NO-UNDO.
DEFINE VARIABLE deTextFontSize     AS DECIMAL     INIT 12 NO-UNDO.
DEFINE VARIABLE dMaxY              AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dOldFontSize       AS DECIMAL     NO-UNDO.
DEFINE VARIABLE dStartY            AS DECIMAL     NO-UNDO.
DEFINE VARIABLE i                  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iBookmark          AS INTEGER     NO-UNDO.
DEFINE VARIABLE iHeight            AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLevel             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLine              AS INTEGER     NO-UNDO.
DEFINE VARIABLE iOption            AS INTEGER     NO-UNDO.
DEFINE VARIABLE iPage              AS INTEGER     NO-UNDO.
DEFINE VARIABLE iSeek              AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTitle             AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTitleSeek         AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTocPage           AS INTEGER     NO-UNDO.
DEFINE VARIABLE iWidth             AS INTEGER     NO-UNDO.
DEFINE VARIABLE j                  AS INTEGER     NO-UNDO.
DEFINE VARIABLE lJustRolledBack    AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lLastLineWasATitle AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lTitleNoTOC        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE pdfStream          AS CHARACTER   NO-UNDO INITIAL "sPDF".

ETIME(YES).

RUN pdf_new(pdfStream,cPdfIncludePath + "readme.pdf").

RUN pdf_set_parameter(pdfStream,"COMPRESS","TRUE").

RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(50089, SESSION:CHARSET, "utf-8")). /* accentuated char to test utf-8 */
RUN pdf_set_info ("Spdf", "Title",  "pdfInclude - README.pdf").
RUN pdf_set_info ("Spdf", "Producer",  "pdfInclude " + pdf_get_parameter("Spdf", "VERSION")).

RUN pdf_set_parameter("Spdf", "defaultHeader", "TRUE"). /* 08-APR-2014 jcc */
RUN pdf_set_parameter("Spdf", "HeaderNotOn1stPage", "TRUE"). /* 30-MAR-2015 jcc */
RUN pdf_set_parameter("Spdf", "HeaderLogo", "readme/pdfInclude-logo.png|90|30|RIGHT"). /* 30-MAR-2015 jcc */
/* RUN pdf_set_parameter("Spdf", "headerLine1", pdf_get_info("Spdf", "Title")). */ /* Title is the default for headerLine1 */
/* RUN pdf_set_parameter("Spdf", "headerLine2", "par " + pdf_get_info("Spdf", "Author")). /* Author is the default for headerLine1 */ */
/* RUN pdf_set_parameter("Spdf", "defaultFooter", "TRUE"). /* 08-APR-2014 jcc */ */
/* RUN pdf_set_parameter("Spdf", "footerLine1", "page " + pdf_PageNo("Spdf") + " de " + pdf_TotalPages("Spdf")). */

/* Setup Tagging */
RUN pdf_set_parameter(pdfStream,"TagColor:Black","0,0,0").
RUN pdf_set_parameter(pdfStream,"TagColor:Red","255,0,0").
RUN pdf_set_parameter(pdfStream,"TagColor:Green","0,200,0").
RUN pdf_set_parameter(pdfStream,"TagColor:Blue","0,0,255").

RUN pdf_set_parameter(pdfStream,"UseTags","TRUE").
RUN pdf_set_parameter(pdfStream,"BoldFont",cFont + "-Bold").
RUN pdf_set_parameter(pdfStream,"ItalicFont",cFont + "-Oblique").
RUN pdf_set_parameter(pdfStream,"BoldItalicFont",cFont + "-BoldOblique").
RUN pdf_set_parameter(pdfStream,"DefaultFont",cFont).
RUN pdf_set_parameter(pdfStream,"DefaultColor","Black").
RUN pdf_set_parameter(pdfStream,"LinkColor","144,12,144"). /* "0,0,255" (blue) by default */

RUN pdf_set_paperType(pdfStream, "A4").

/* Set Page Header procedure */
pdf_PageFooter (pdfStream, THIS-PROCEDURE:HANDLE, "PageFooter").

RUN pdf_set_LeftMargin(pdfStream, 100).
RUN pdf_set_RightMargin(pdfStream, 20).
RUN pdf_set_BottomMargin(pdfStream, 50).
RUN pdf_set_TopMargin(pdfStream, 50).

RUN pdf_new_page(pdfStream).

RUN pdf_set_font(pdfStream, cFont, deTextFontSize).

INPUT FROM VALUE(cPdfIncludePath + "readme.txt").

blkLine:
REPEAT:
    iSeek = SEEK(INPUT).
    iLine = iLine + 1.
    IMPORT UNFORMATTED cLine NO-ERROR.
    cChar = SUBSTRING(cLine, 1, 1).
    CASE cChar:
        /* Preprocessors */
        WHEN "&" THEN DO:
            DEFINE VARIABLE cPreprocessor AS CHARACTER   NO-UNDO.
            cPreprocessor = ENTRY(1, cLine, " ").
            CASE cPreprocessor:
                WHEN "&EOF" THEN DO:
                    IF pdf_in_transaction(pdfStream) THEN
                        RUN pdf_transaction_commit(pdfStream).
                    LEAVE blkLine. /* End Of File */
                END.
                WHEN "&T"   THEN /* Toggle tags */
                    RUN pdf_set_parameter(
                        pdfStream, "UseTags",
                        IF pdf_get_parameter(pdfStream, "UseTags") = "TRUE" THEN "FALSE" ELSE "TRUE").
                WHEN "&IMG" THEN DO: /* Image */
                    DEFINE VARIABLE cAlign     AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE cImageDef  AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE cImageFile AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE cLegend    AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE dRatio     AS DECIMAL     NO-UNDO.

                    cImageDef = SUBSTRING(cLine, LENGTH(cPreprocessor) + 2).
                    cImageFile = ENTRY(1, cImageDef, "|").
                    cAlign = ENTRY(2, cImageDef, "|") NO-ERROR.
                    IF ERROR-STATUS:ERROR THEN
                        cAlign = "LEFT".
                    cLegend = ENTRY(3, cImageDef, "|") NO-ERROR.

                    RUN pdf_load_image(pdfStream, basename(cImageFile), cImageFile).
                    RUN pdf_get_image_info(pdfStream, basename(cImageFile),
                                           OUTPUT cType, OUTPUT iHeight, OUTPUT iWidth).
                    iHeight = iHeight / 2.
                    iWidth  = iWidth / 2.
                    IF iWidth > pdf_PageWidth(pdfStream) - pdf_LeftMargin(pdfStream) THEN ASSIGN
                        dRatio  = (pdf_PageWidth(pdfStream) - pdf_LeftMargin(pdfStream)) / iWidth
                        iHeight = iHeight * dRatio
                        iWidth  = iWidth * dRatio.
                    RUN pdf_set_textY(pdfStream, pdf_TextY(pdfStream) - iHeight - 2).
                    RUN pdf_place_image(pdfStream, basename(cImageFile)
                                       ,IF cAlign = "LEFT"   THEN pdf_TextX(pdfStream) ELSE
                                        IF cAlign = "RIGHT"  THEN pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream) - iWidth ELSE
                                        IF cAlign = "CENTER" THEN (pdf_PageWidth(pdfStream) + pdf_LeftMargin(pdfStream) - pdf_RightMargin(pdfStream) - iWidth) / 2
                                        /* PAGECENTER */     ELSE (pdf_PageWidth(pdfStream) - iWidth) / 2
                                       ,pdf_PageHeight(pdfStream) - pdf_TextY(pdfStream), iWidth, iHeight).
                    RUN pdf_skip(pdfStream).
                    IF cLegend > "" THEN DO:
                        RUN pdf_set_font("Spdf",cFont + "-BoldOblique",9).
                        RUN pdf_wrap_text_x(pdfStream,
                                            replaceQuotes(cLegend),
                                            pdf_LeftMargin(pdfStream),
                                            pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream),
                                            cAlign,
                                            OUTPUT dMaxY).
                        RUN pdf_set_font("Spdf",cFont,deTextFontSize).
                        RUN pdf_skip(pdfStream).
                    END.

                END.
                WHEN "&HR" THEN DO: /* Horizontal rule */
                    /* 20-APR-2015 jcc: only if it will be below the header (i.e. remove if first thing on page) */
                    IF pdf_TextY(pdfStream) + pdf_PointSize(pdfStream) < pdf_PageHeight(pdfStream) - pdf_TopMargin(pdfStream) THEN DO:
                        RUN pdf_skip(pdfStream).
                        IF pdf_TextY(pdfStream) + pdf_PointSize(pdfStream) < pdf_PageHeight(pdfStream) - pdf_TopMargin(pdfStream) THEN DO: /* do the test twice because the pdf_skip above might have triggered a new page */
                            RUN pdf_stroke_color(pdfStream, .8, .8, .8).
                            RUN pdf_line(pdfStream, pdf_LeftMargin(pdfStream) - 5, pdf_TextY(pdfStream) + pdf_PointSize(pdfStream), pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream) + 5, pdf_TextY(pdfStream) + pdf_PointSize(pdfStream), 1).
                        END.
                    END.
                END.
                WHEN "&FF" THEN
                    RUN pdf_new_page(pdfStream).
                WHEN "&INDEX" THEN DO:
                    RUN outputTitle(iLevel + 1, "Global list").
                    FOR EACH ttProcsAndFuncs BY ttProcsAndFuncs.name:
                        RUN outputIndexEntry (NO).
                    END.
                    RUN outputTitle(iLevel + 1, "Procedures list").
                    RUN pdf_text(pdfStream, "").
                    FOR EACH ttProcsAndFuncs WHERE ttProcsAndFuncs.type = "P":
                        RUN outputIndexEntry (YES).
                    END.
                    RUN outputTitle(iLevel + 1, "Functions list").
                    FOR EACH ttProcsAndFuncs WHERE ttProcsAndFuncs.type = "F":
                        RUN outputIndexEntry (YES).
                    END.
                END.
                WHEN "&FONT" THEN DO:
                    DEFINE VARIABLE cFontDef AS CHARACTER   NO-UNDO.
                    cFontDef = SUBSTRING(cLine, LENGTH(cPreprocessor) + 2).
                    IF ENTRY(1, cFontDef, "|") = "Code" THEN deCodeFontSize = DECIMAL(ENTRY(2, cFontDef, "|")).
                    ELSE IF ENTRY(1, cFontDef, "|") = "Text" THEN deTextFontSize = DECIMAL(ENTRY(2, cFontDef, "|")).
                END.
                WHEN "&TABLESTART" THEN DO:
                    DEFINE VARIABLE cColValues    AS CHARACTER   EXTENT 12 NO-UNDO.
                    DEFINE VARIABLE cOption       AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE cTableOption  AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE cTableOptions AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE iColumn       AS INTEGER     NO-UNDO.
                    DEFINE VARIABLE iNumCell      AS INTEGER     NO-UNDO.
                    DEFINE VARIABLE iNumCols      AS INTEGER     NO-UNDO.
                    DEFINE VARIABLE iNumRows      AS INTEGER     NO-UNDO.

                    ASSIGN
                     iNumCell = 0
                     iNumRows = 0
                     iNumCols = 0.

                    cTableOptions = SUBSTRING(cLine, LENGTH(cPreprocessor) + 2).

                    RUN pdf_tool_add ("Spdf","tbl", "MATRIX", ?).

                    RUN pdf_set_tool_parameter("Spdf","tbl","X",0,pdf_LeftMargin(pdfStream)).
                    RUN pdf_set_tool_parameter("Spdf","tbl","Y",0,pdf_TextY(pdfStream) - pdf_PointSize(pdfStream)).
                    RUN pdf_set_tool_parameter("Spdf","tbl","GridWeight",0,"0.5").
                    RUN pdf_set_tool_parameter("Spdf","tbl","GridColor",0,"0,0,0").
                    RUN pdf_set_tool_parameter("Spdf","tbl","FontSize",0,deTextFontSize).
                    RUN pdf_set_tool_parameter("Spdf","tbl","BGcolor",0,"255,255,255").
                    RUN pdf_set_tool_parameter("Spdf","tbl","ColumnVerticalPadding",0,"4").
                    RUN pdf_set_tool_parameter("Spdf","tbl","PageBreak",0,"YES"). /* 27-MAR-2015 jcc: new parameter */
                    RUN pdf_set_tool_parameter("Spdf","tbl","Repeat1stRow",0,"YES"). /* 27-MAR-2015 jcc: new parameter */

                    IF LOGICAL(getWidgetOption2("header", cTableOptions, "YES")) THEN DO:
                        RUN pdf_set_tool_parameter("Spdf","tbl","BGcolor",1,"100,180,255").
                        RUN pdf_set_tool_parameter("Spdf","tbl","FGcolor",1,"255,255,255").
                        RUN pdf_set_tool_parameter("Spdf","tbl","Font",1,cFont + "-Bold").
                    END.
                    ELSE
                        RUN pdf_set_tool_parameter("Spdf","tbl","Font",2,cFont).

                    RUN pdf_set_tool_parameter("Spdf","tbl","Font",2,"Helvetica").

                    blkTblOption:
                    DO iOption = 1 TO NUM-ENTRIES(cTableOptions):
                        cTableOption = ENTRY(iOption, cTableOptions).
                        IF NUM-ENTRIES(cTableOption, "=") <> 2 THEN NEXT blkTblOption.
                        cOption = ENTRY(1, cTableOption, "=").
                        IF INDEX(cOption, "[") > 0 THEN ASSIGN
                            iColumn = INTEGER(RIGHT-TRIM(ENTRY(2, cOption, "["), "]"))
                            cOption = ENTRY(1, cOption, "[").
                        ELSE
                            iColumn = 0.
                        RUN pdf_set_tool_parameter("Spdf","tbl", cOption, iColumn, ENTRY(2, cTableOption, "=")).
                    END.

                    blkReadTable:
                    REPEAT:
                        IMPORT UNFORMATTED cLine.
                        IF iNumCols = 0 THEN DO:
                             iNumCols = NUM-ENTRIES(cLine, "~t").
                             RUN pdf_set_tool_parameter("Spdf","tbl","Columns",0,INTEGER(iNumCols)).
                             DO iColumn = 1 TO iNumCols:
                                 RUN pdf_set_tool_parameter("Spdf","tbl","WrapText",iColumn,"0").
                             END.
                        END.
                        IF cLine BEGINS "----" OR TRIM(cLine) = "&TABLEEND" THEN DO:
                            iNumRows = iNumRows + 1.
                            DO iColumn = 1 TO iNumCols:
                                iNumCell = iNumCell + 1.
                                /* MESSAGE iNumCell SKIP iColumn SKIP cColValues[iColumn] */
                                    /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                                RUN pdf_set_tool_parameter("Spdf","tbl","CellValue",iNumCell,RIGHT-TRIM(cColValues[iColumn], "~n")).
                            END.
                            cColValues = "".
                        END.
                        ELSE DO iColumn = 1 TO iNumCols:
                            IF NUM-ENTRIES(cLine, "~t") >= iColumn THEN
                                cColValues[iColumn] = cColValues[iColumn] 
                                                      + (IF cColValues[iColumn] > "" THEN "~n" ELSE "")
                                                      + ENTRY(iColumn, replaceQuotes(cLine), "~t").
                            /* MESSAGE iColumn cColValues[iColumn] */
                                /* VIEW-AS ALERT-BOX INFO BUTTONS OK. */
                        END.
                        IF TRIM(cLine) = "&TABLEEND" THEN DO:
                            RUN pdf_set_tool_parameter("Spdf","tbl","Rows",0,INTEGER(iNumRows)).
                            RUN pdf_tool_create ("Spdf","tbl").
                            RUN pdf_tool_destroy ("Spdf","tbl"). /* in order to be able to reuse the same "tbl" identifier */
                            LEAVE blkReadTable.
                        END.
                    END.
                END.

                WHEN "&TOC" THEN /* just remember where to insert it for later (once we have read all the titles) */
                    iTocPage = pdf_Page(pdfStream).

                WHEN "&CODE" THEN DO:
                    DEFINE VARIABLE cCodeOptions AS CHARACTER   NO-UNDO.
                    DEFINE VARIABLE cColor       AS CHARACTER   NO-UNDO.
                    cCodeOptions = SUBSTRING(cLine, LENGTH(cPreprocessor) + 2).
                    cColor       = ENTRY(1, cCodeOptions, "|").
                    RUN pdf_set_parameter(pdfStream, "UseTags", "FALSE").
                    IF NUM-ENTRIES(cCodeOptions, "|") > 1 THEN
                        deCodeFontSize = DECIMAL(ENTRY(2, cCodeOptions, "|")).
                    RUN pdf_set_font(pdfStream, "Courier", deCodeFontSize).
                    blkReadCode:
                    REPEAT:
                        lNewPage = NO.
                        IMPORT UNFORMATTED cLine.
                        IF cLine = "&CODE" THEN LEAVE blkReadCode.
                        CASE cColor:
                            WHEN "ABL" THEN RUN pdf_text_ABL_syntax_color IN hABLColor (pdfStream, cLine).
                            WHEN "PDF" THEN RUN pdf_text_PDF_syntax_color (pdfStream, cLine).
                            WHEN "XML" THEN RUN pdf_text_XML_syntax_color (pdfStream, cLine).
                            OTHERWISE       RUN pdf_text (pdfStream, cLine).
                        END CASE.
                        RUN pdf_skip(pdfStream).
                        IF lNewPage THEN DO:
                            RUN pdf_set_font(pdfStream, "Courier", deCodeFontSize).
                            lNewPage = NO.
                        END.
                    END.
                    RUN pdf_text_color(pdfStream, 0, 0, 0).
                    RUN pdf_set_font(pdfStream, cFont, deTextFontSize).    
                    RUN pdf_set_parameter(pdfStream, "UseTags", "TRUE").
                END.

                WHEN "&NEED" THEN DO:
                    DEFINE VARIABLE cNeedOptions AS CHARACTER   NO-UNDO.
                    cNeedOptions = SUBSTRING(cLine, LENGTH(cPreprocessor) + 2).
                    IF pdf_TextY(pdfStream) < INTEGER(cNeedOptions) + pdf_BottomMargin(pdfStream) THEN
                        RUN pdf_new_page(pdfStream).
                END.

                OTHERWISE NEXT blkLine. /* ignore unknown preprocessor */
            END CASE.
        END. /* preprocessors */

        /* Comment */
        WHEN "#" THEN NEXT blkLine.
        
        /* Heading */
        WHEN "=" THEN DO:
            cText = LEFT-TRIM(cLine, "=").
            iLevel = LENGTH(cLine) - LENGTH(cText).
            RUN outputTitle (iLevel, cText).
        END.
        /* Bullets */
        WHEN "*" THEN DO:
            cText = LEFT-TRIM(cLine, "*").
            iLevel = LENGTH(cLine) - LENGTH(cText).
            IF iLevel = 1 THEN DO:
                RUN pdf_stroke_color(pdfStream, .6, .6, .6).
                RUN pdf_stroke_fill(pdfStream, .6, .6, .6).
            END.
            ELSE DO:
                RUN pdf_stroke_color(pdfStream, .6, .6, .6).
                RUN pdf_stroke_fill(pdfStream, 1, 1, 1).
            END.
            RUN pdf_circle(pdfStream, pdf_LeftMargin(pdfStream) + 12 * iLevel, pdf_TextY(pdfStream) + 4, 2, 0).
            RUN pdf_wrap_text_x(pdfStream,
                                replaceQuotes(cText),
                                pdf_LeftMargin(pdfStream) + 12 * (iLevel + 1),
                                pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream),
                                "LEFT",
                                OUTPUT dMaxY).
            RUN pdf_skip(pdfStream).
            RUN pdf_set_textY(pdfStream, pdf_TextY(pdfStream) - pdf_PointSize(pdfStream) / 3).
        END.
        /* Indentation */
        WHEN "-" THEN DO:
            cText = LEFT-TRIM(cLine, "-").
            iLevel = LENGTH(cLine) - LENGTH(cText).
            RUN pdf_wrap_text_x(pdfStream,
                                replaceQuotes(cText),
                                pdf_LeftMargin(pdfStream) + 12 * (iLevel + 1),
                                pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream),
                                "LEFT",
                                OUTPUT dMaxY).
            RUN pdf_skip(pdfStream).
            RUN pdf_set_textY(pdfStream, pdf_TextY(pdfStream) - pdf_PointSize(pdfStream) / 3).
        END.
        /* Code */
        WHEN "@" THEN DO:
            RUN pdf_set_font(pdfStream, "Courier", deCodeFontSize).
            RUN pdf_text_ABL_syntax_color IN hABLColor (pdfStream, SUBSTRING(cLine, 2)).
            RUN pdf_skip(pdfStream).                                         
            RUN pdf_set_font(pdfStream, cFont, deTextFontSize).    
        END.
        /* API calls */
        WHEN "%" THEN DO:
            DEFINE VARIABLE cAPI     AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE cCommand AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE cOperand AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE cOptions AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE cParam   AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE cParams  AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE cValue   AS CHARACTER   NO-UNDO.
            DEFINE VARIABLE lEval    AS LOGICAL     NO-UNDO.
            cCommand = SUBSTRING(cLine, 2).
            cAPI = ENTRY(1, cCommand, " ").
            cParams = SUBSTRING(cCommand, LENGTH(cAPI) + 2).
            IF cParams = "" THEN
                RUN VALUE(cAPI) (pdfStream).
            ELSE DO:
                /* Refine parameters: evaluate formulae */
                DO i = 1 TO NUM-ENTRIES(cParams, "|"):
                    ASSIGN
                     lEval  = NO
                     cParam = ENTRY(i, cParams, "|").
                    DO j = 1 TO NUM-ENTRIES(cParam, " "):
                        cOperand = ENTRY(j, cParam, " ").
                        IF cOperand MATCHES "pdf_*()" THEN ASSIGN
                            lEval                 = YES
                            ENTRY(j, cParam, " ") = STRING(DYNAMIC-FUNCTION(ENTRY(1, cOperand, "(") IN h_PDFinc, pdfStream)).
                    END.
                    IF lEval THEN DO:
                        RUN evaluateABLDec (cParam, OUTPUT cParam) NO-ERROR.
                        cParam = REPLACE(cParam, ".", ",").
                    END.

                    ENTRY(i, cParams, "|") = cParam.
                END.
                /* Refine options for pdf_place_pdf_page */
                IF cAPI = "pdf_place_pdf_page" THEN DO:
                    cOptions = ENTRY(NUM-ENTRIES(cParams, "|"), cParams, "|").
                    DO i = 1 TO NUM-ENTRIES(cOptions):
                        ASSIGN
                         lEval = NO
                         cParam = ENTRY(i, cOptions)
                         cOption = ENTRY(1, cParam, "=")
                         cValue = SUBSTRING(cParam, INDEX(cParam, "=") + 1).
                        DO j = 1 TO NUM-ENTRIES(cValue, " "):
                            cOperand = ENTRY(j, cValue, " ").
                            IF cOperand MATCHES "pdf_*()" THEN ASSIGN
                                lEval                 = YES
                                ENTRY(j, cValue, " ") = STRING(DYNAMIC-FUNCTION(ENTRY(1, cOperand, "(") IN h_PDFinc, pdfStream)).
                        END.
                        IF lEval THEN DO:
                            RUN evaluateABLDec (cValue, OUTPUT cValue).
                            cValue = REPLACE(cValue, ".", ",").
                        END.

                        ENTRY(i, cOptions) = cOption + "=" + cValue.
                    END.
                    ENTRY(NUM-ENTRIES(cParams, "|"), cParams, "|") = cOptions.
                END.
                
                /* Then run the API */
                IF cAPI = "pdf_wrap_text_x" THEN /* special case for the OUTPUT parameter */
                    RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), OUTPUT dMaxY).
                ELSE CASE NUM-ENTRIES(cParams, "|"):
                    WHEN  1 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|")) NO-ERROR.
                    WHEN  2 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|")) NO-ERROR.
                    WHEN  3 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|")) NO-ERROR.
                    WHEN  4 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|")) NO-ERROR.
                    WHEN  5 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|")) NO-ERROR.
                    WHEN  6 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|")) NO-ERROR.
                    WHEN  7 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|")) NO-ERROR.
                    WHEN  8 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|"), ENTRY(8, cParams, "|")) NO-ERROR.
                    WHEN  9 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|"), ENTRY(8, cParams, "|"), ENTRY(9, cParams, "|")) NO-ERROR.
                    WHEN 10 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|"), ENTRY(8, cParams, "|"), ENTRY(9, cParams, "|"), ENTRY(10, cParams, "|")) NO-ERROR.
                    WHEN 11 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|"), ENTRY(8, cParams, "|"), ENTRY(9, cParams, "|"), ENTRY(10, cParams, "|"), ENTRY(11, cParams, "|")) NO-ERROR.
                    WHEN 12 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|"), ENTRY(8, cParams, "|"), ENTRY(9, cParams, "|"), ENTRY(10, cParams, "|"), ENTRY(11, cParams, "|"), ENTRY(12, cParams, "|")) NO-ERROR.
                    WHEN 13 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|"), ENTRY(8, cParams, "|"), ENTRY(9, cParams, "|"), ENTRY(10, cParams, "|"), ENTRY(11, cParams, "|"), ENTRY(12, cParams, "|"), ENTRY(13, cParams, "|")) NO-ERROR.
                    WHEN 14 THEN RUN VALUE(cAPI) (pdfStream, ENTRY(1, cParams, "|"), ENTRY(2, cParams, "|"), ENTRY(3, cParams, "|"), ENTRY(4, cParams, "|"), ENTRY(5, cParams, "|"), ENTRY(6, cParams, "|"), ENTRY(7, cParams, "|"), ENTRY(8, cParams, "|"), ENTRY(9, cParams, "|"), ENTRY(10, cParams, "|"), ENTRY(11, cParams, "|"), ENTRY(12, cParams, "|"), ENTRY(13, cParams, "|"), ENTRY(14, cParams, "|")) NO-ERROR.
                END CASE.
                IF ERROR-STATUS:ERROR THEN MESSAGE "Line" iLine SKIP "Error when running " cApi "(pdfStream," cParams ")"
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
            END. 
        END.
        /* Normal text */
            OTHERWISE DO:
            RUN pdf_set_font(pdfStream, cFont, deTextFontSize).
            RUN pdf_wrap_text_x(pdfStream,
                                replaceQuotes(cLine),
                                pdf_LeftMargin(pdfStream),
                                pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream),
                                "LEFT",
                                OUTPUT dMaxY).
            RUN pdf_skip(pdfStream).
            RUN pdf_set_textY(pdfStream, pdf_TextY(pdfStream) - pdf_PointSize(pdfStream) / 3).
        END.
    END.
    DEFINE VARIABLE dey AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE inewpage AS INTEGER     NO-UNDO.
    dey = pdf_TextY(pdfStream).
    inewpage = pdf_Page(pdfStream).
    IF lLastLineWasATitle AND cChar <> "=" THEN DO: /* not a title */
        /* if we did not change page -> commit, else rollback, new page and start over */
        IF iPage = pdf_Page(pdfStream) 
          OR (pdf_Page(pdfStream) - iPage > 1) /* more than one page */
          OR (dStartY > pdf_TextY(pdfStream)) /* went onto next page but does not fit into one page */
          /* OR (lLastLineWasATitle AND lNewPage) */
        THEN DO:
            RUN pdf_transaction_commit(pdfStream).
        END.
        ELSE DO:
            RUN pdf_transaction_rollback(pdfStream).
            SEEK INPUT TO iTitleSeek.
            RUN pdf_new_page(pdfStream).
            RUN pdf_set_textY(pdfStream, pdf_TextY(pdfStream) - pdf_PointSize(pdfStream) / 3).
        END. 
        lLastLineWasATitle = NO.
    END.
    IF lNewPage AND cChar <> "=" THEN
        lNewPage = NO.
END.

INPUT CLOSE.

/* 30-MAR-2015 jcc: output TOC */
/* First, output the labels, to know how many pages we need to insert for the TOC to fit,
   then go back to the TOC first page and add the page numbers, incremented correctly */
DEFINE VARIABLE dAvailableWidth AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dDigitWidth     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dDotWidth       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dStartTOCY      AS DECIMAL   NO-UNDO.
DEFINE VARIABLE iTocEntryPage   AS INTEGER   NO-UNDO.
IF iTocPage <> 0 THEN DO:
    RUN pdf_set_parameter(pdfStream, "LineSpacer", 2).
    RUN pdf_set_page(pdfStream, iTocPage).
    RUN pdf_set_parameter(pdfStream, "insertPageMode", "insert"). /* 01-APR-2015 jcc: new parameter: pdf_skip will insert pages (instead of append them to the document) */
    dStartTOCY = pdf_PageHeight(pdfStream) - pdf_TopMargin(pdfStream) - 24 - 3 * pdf_PointSize(pdfStream).
    RUN pdf_set_textXY(pdfStream, pdf_LeftMargin(pdfStream), dStartTOCY, YES).
    ASSIGN
     dDigitWidth     = pdf_text_widthdec(pdfStream, "0")
     dDotWidth       = pdf_text_widthdec(pdfStream, ".")
     dAvailableWidth = pdf_PageWidth(pdfStream)
                     - pdf_RightMargin(pdfStream).
    FOR EACH ttTOC BY ttTOC.id:
        IF ttTOC.level = 1 THEN
            RUN pdf_set_font(pdfStream, cFont + "-Bold", 12).
        ELSE IF ttTOC.level = 2 THEN
            RUN pdf_set_font(pdfStream, cFont + "-Bold", 10).
        ELSE
            RUN pdf_set_font(pdfStream, cFont, 10).
        /* next line or next (insert) page */
        RUN pdf_skip(pdfStream).
        RUN pdf_text_at(pdfStream, "<url=#" + ttTOC.name + ">" + ttTOC.name + "</url>  ", 1 + 5 * (ttTOC.level - 1)).
        ttTOC.textX = pdf_TextX(pdfStream).
    END.
    /* now add the dots and the page numbers */
    RUN pdf_set_page(pdfStream, iTocPage).
    RUN pdf_set_textXY(pdfStream, pdf_LeftMargin(pdfStream), dStartTOCY, YES).
    RUN pdf_set_parameter(pdfStream, "insertPageMode", "next"). /* 01-APR-2015 jcc: new parameter: pdf_skip will go to next page */
    FOR EACH ttTOC BY ttTOC.id:
        IF ttTOC.level = 1 THEN
            RUN pdf_set_font(pdfStream, cFont, 12).
        ELSE IF ttTOC.level = 2 THEN
            RUN pdf_set_font(pdfStream, cFont, 10).
        ELSE
            RUN pdf_set_font(pdfStream, cFont, 10).
        RUN pdf_skip(pdfStream).
        iTocEntryPage = ttTOC.tocpage + IF ttTOC.tocpage > iTocPage THEN iNumInsertedPages ELSE 0.
        /* dots */
        RUN pdf_set_font(pdfStream, "Times-Roman", 10).
        RUN pdf_set_TextXY(pdfStream, ttTOC.textX, pdf_TextY(pdfStream), YES).
        RUN pdf_text(pdfStream, FILL(".  ", INTEGER(TRUNCATE((dAvailableWidth - pdf_TextX(pdfStream) - dDigitWidth * LENGTH(STRING(iTocEntryPage) /* page number width */ )) / pdf_text_widthdec(pdfStream, ".  "), 0)))).
        IF pdf_TextX(pdfStream) + dDotWidth < pdf_PageWidth(pdfStream)
                                              - pdf_RightMargin(pdfStream) 
                                              - dDigitWidth * LENGTH(STRING(iTocEntryPage)) + 1 THEN
            RUN pdf_text(pdfStream, "."). /* put a last dot if it fits */
        /* page numbers */
        RUN pdf_set_font(pdfStream, cFont, 10).
        RUN pdf_text_align(pdfStream, STRING(iTocEntryPage), "RIGHT", pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream), pdf_TextY(pdfStream)).
    END.
END.

RUN pdf_set_page(pdfStream, 1).
RUN pdf_set_textXY(pdfStream, pdf_LeftMargin(pdfStream), pdf_BottomMargin(pdfStream) + 2 * pdf_PointSize(pdfStream), YES).
RUN pdf_wrap_text_x(pdfStream, "<i>This document was generated by pdfInclude " + pdf_get_parameter(pdfStream, "version") + " in " + REPLACE(TRIM(STRING(ROUND(ETIME / 1000, 2), ">>>>9.99")), ",", ".") + " seconds.</i>", 0, pdf_PageWidth(pdfStream), "center", OUTPUT dMaxY).

RUN pdf_close(pdfStream).
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
ELSE
    MESSAGE "done in " ETIME / 1000 " seconds"
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

DELETE PROCEDURE hABLColor.


/************************* Internal procedures ********************************/

PROCEDURE PageFooter:
/*------------------------------------------------------------------------------
  Purpose:  Procedure to Print Page Footer on all pages.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE y AS DECIMAL     NO-UNDO.

  IF pdf_Page(pdfStream) = 1 THEN RETURN.

  y = pdf_TextY(pdfStream).
  RUN pdf_set_font(pdfStream,"Courier-Bold", 10).
  RUN pdf_text_color(pdfStream, 0, 0, 0).
  RUN pdf_stroke_color(pdfStream, .6, .6, .6).
  RUN pdf_set_dash_pattern(pdfStream, "", 0).
  RUN pdf_line(pdfStream, pdf_LeftMargin(pdfStream), pdf_TextY(pdfStream) - 5, pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream) , pdf_TextY(pdfStream) - 5, 1).
  RUN pdf_text_align(pdfStream,
                     "(c) 2015 snowwolf-software.com",
                     "LEFT",
                     pdf_LeftMargin(pdfStream),
                     y - 30).
  RUN pdf_text_align(pdfStream,
                     "Page " + pdf_PageNo(pdfStream) + " of " + pdf_TotalPages(pdfStream),
                     "RIGHT",
                     pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream),
                     y - 30).
  /* restore default font */
  RUN pdf_set_font(pdfStream, cFont, 12).
END. /* PageFooter */

PROCEDURE outputIndexEntry:
    DEFINE INPUT  PARAMETER plStripType AS LOGICAL     NO-UNDO.

    RUN pdf_stroke_color(pdfStream, .6, .6, .6).
    RUN pdf_stroke_fill(pdfStream, .6, .6, .6).
    RUN pdf_circle(pdfStream, pdf_LeftMargin(pdfStream) + 12, pdf_TextY(pdfStream) + 4, 2, 0).
    RUN pdf_wrap_text_x(pdfStream,
                        "<url=#" + ttProcsAndFuncs.name + ">" + (IF plStripType THEN ENTRY(1, ttProcsAndFuncs.name, " ") ELSE ttProcsAndFuncs.name) +  "</url>",
                        pdf_LeftMargin(pdfStream) + 12 * 2,
                        pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream),
                        "LEFT",
                        OUTPUT dMaxY).
    RUN pdf_skip(pdfStream).
END PROCEDURE.

PROCEDURE outputTitle:
    DEFINE INPUT PARAMETER iLevel AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER cText  AS CHARACTER   NO-UNDO.

    /* Page break before title 1 & 2 */
    IF iLevel = 1 /*OR (iLevel = 2 AND NOT lLastLineWasATitle)*/ THEN DO:
        RUN pdf_new_page(pdfStream).
        RUN pdf_skipn(pdfStream, 2).
    END.
    ELSE RUN pdf_skip(pdfStream).

    IF NOT lLastLineWasATitle AND NOT lNewPage THEN DO: /* make titles to stick with their first paragraph, in case of a new page */
        lLastLineWasATitle = YES.
        RUN pdf_transaction_begin(pdfStream).
        iPage = pdf_Page(pdfStream).
        dStartY = pdf_TextY(pdfStream).
        iTitleSeek = iSeek.
    END.

    /* 14-OCT-2014 jcc: the font size has to be set before calling pdf_bookmark, to get an accurate position within the pdf file */
    dOldFontSize = pdf_PointSize(pdfStream).
    RUN pdf_set_font(pdfStream, cFont, MAXIMUM(12 * (5 - iLevel) / 2, deTextFontSize)).

    /* Manage bookmarks and parent them correctly */
    lTitleNoTOC = NUM-ENTRIES(cText, "|") > 1 AND ENTRY(2, cText, "|") = "NOTOC".
    cText = replaceQuotes(ENTRY(1, cText, "|")).
    IF NOT lTitleNoTOC THEN DO:
        RUN pdf_bookmark(pdfStream, TRIM(cText, " "), IF iLevel = 1 THEN 0 ELSE INTEGER(ENTRY(iLevel - 1, cBookmarks)), iLevel = 1, OUTPUT iBookmark).
        ENTRY(iLevel, cBookmarks) = STRING(iBookmark).
    END.

    IF iLevel = 1 THEN
        RUN pdf_text_align(pdfStream,
                           cText,
                           "CENTER",
                           pdf_PageWidth(pdfStream) / 2,
                           pdf_TextY(pdfStream)).
    ELSE DO:
        CASE iLevel:
            WHEN 2 THEN DO:
                RUN pdf_skip(pdfStream).
                RUN pdf_stroke_color(pdfStream, .8, .8, .8).
                RUN pdf_stroke_fill(pdfStream, .8, .8, .8).
                RUN pdf_rectdec(pdfStream, pdf_LeftMargin(pdfStream) - 5, pdf_TextY(pdfStream) - 3, pdf_PageWidth(pdfStream) - pdf_LeftMargin(pdfStream) - 10, pdf_PointSize(pdfStream), .5).
            END.
            WHEN 3 THEN
                RUN pdf_set_font(pdfStream, pdf_get_parameter(pdfStream, "BoldFont"), pdf_PointSize(pdfStream)).
            WHEN 4 THEN
                RUN pdf_set_font(pdfStream, pdf_get_parameter(pdfStream, "ItalicFont"), pdf_PointSize(pdfStream)).
            WHEN 5 THEN
                cText = "<u>" + cText + "</u>".
        END CASE.
        /* 20-APR-2015 jcc: ensure the title is not too close to the header separator */
        IF pdf_TextY(pdfStream) > pdf_PageHeight(pdfStream) - pdf_TopMargin(pdfStream) - pdf_PointSize(pdfStream) THEN 
            RUN pdf_set_TextY(pdfStream, pdf_PageHeight(pdfStream) - pdf_TopMargin(pdfStream) - pdf_PointSize(pdfStream)).
        RUN pdf_wrap_text_x(pdfStream,
                            cText,
                            pdf_LeftMargin(pdfStream),
                            pdf_PageWidth(pdfStream) - pdf_RightMargin(pdfStream),
                            "LEFT",
                            OUTPUT dMaxY).
        IF iLevel = 3 THEN
            RUN pdf_set_font(pdfStream, cFont, pdf_PointSize(pdfStream)).
    END.
    RUN pdf_set_font(pdfStream, cFont, dOldFontSize).
    IF iLevel < 5 THEN
        RUN pdf_skipn(pdfStream, 2).
    ELSE DO:
        RUN pdf_set_parameter(pdfStream, "LineSpacer", pdf_PointSize(pdfStream) / 2).
        RUN pdf_skip(pdfStream).
        RUN pdf_set_parameter(pdfStream, "LineSpacer", 0).
    END.

    IF (cText MATCHES "*(PROCEDURE)" OR cText MATCHES "*(FUNCTION)")
      AND NOT CAN-FIND(ttProcsAndFuncs WHERE ttProcsAndFuncs.name = cText) THEN DO:
        CREATE ttProcsAndFuncs.
        ASSIGN
         ttProcsAndFuncs.type = IF cText MATCHES "*(PROCEDURE)" THEN "P" ELSE "F"
         ttProcsAndFuncs.name = cText.
    END.

    IF NOT lTitleNoTOC THEN DO:
        /* FIND ttTOC WHERE ttTOC.name = cText NO-ERROR. */
        /* IF NOT AVAILABLE ttTOC THEN DO: */
            CREATE ttTOC.
            ASSIGN
             iTitle        = iTitle + 1
             ttTOC.id      = iTitle
             ttTOC.level   = iLevel
             ttTOC.name    = cText.
        /* END. */
        ttTOC.tocpage = pdf_Page(pdfStream).
    END.
END PROCEDURE.

&GLOBAL-DEFINE TAG_DEFAULT       RUN pdf_text_color (pdfStream,0.0,0.0,0.0).
/* comments */
&GLOBAL-DEFINE TAG_START_COMMENT RUN pdf_text_color (pdfStream,0.0,0.7,0.0).
/* progress 4GL keywords */
&GLOBAL-DEFINE TAG_START_KEYWORD RUN pdf_text_color (pdfStream,0.0,0.0,0.7).
/* literal integers and decimals */ 
&GLOBAL-DEFINE TAG_START_NUMBER  RUN pdf_text_color (pdfStream,0.7,0.0,0.0).
/* literal strings */ 
&GLOBAL-DEFINE TAG_START_CHAR    RUN pdf_text_color (pdfStream,0.0,0.7,0.7).
/* preprocessors (things between {} or starting with &) */   
&GLOBAL-DEFINE TAG_START_PREP    RUN pdf_text_color (pdfStream,1.0,0.0,1.0).

FUNCTION ReadWord RETURNS LOGICAL (INPUT-OUTPUT piPdfSeek AS INTEGER, INPUT pcText AS CHARACTER, INPUT-OUTPUT pcBuffer AS CHARACTER, INPUT-OUTPUT piBuffer AS INTEGER):
  DEFINE VARIABLE cChar      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTmp       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cWord      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iParenLvl  AS INTEGER     NO-UNDO. /* string objects might contain balanced, not backslashed parenthesis */.
  DEFINE VARIABLE dTmp       AS INTEGER     NO-UNDO.
  DEFINE VARIABLE lHexString AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lInComment AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lInString  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lIsName    AS LOGICAL     NO-UNDO.

  /* skip the word separators */
  Skip-Loop:
  DO WHILE TRUE:
    piPdfSeek = piPdfSeek + 1.
    IF piPdfSeek > LENGTH(pcText) THEN
        RETURN FALSE.
    cChar = SUBSTRING(pcText, piPdfSeek, 1).
    IF cChar = " " THEN RUN pdf_text(pdfStream, " ").
    ELSE LEAVE Skip-Loop.
  END.

  IF cChar = "(" THEN
    lInString = YES.
  ELSE IF cChar = "%" THEN DO:
      lInComment = YES.
      {&TAG_START_COMMENT}
      RUN pdf_text(pdfStream, SUBSTRING(pcText, piPdfSeek)).
      piPdfSeek = LENGTH(pcText).
      RETURN TRUE.
  END.
  ELSE IF cChar = "~/" THEN
    lIsName = YES.
  
  Read-Loop:
  DO WHILE TRUE:
    cWord = cWord + cChar.

    IF CAN-DO("[,],<<,>>", cWord) THEN DO:
        IF pcBuffer > "" THEN DO: {&TAG_START_NUMBER} RUN pdf_text(pdfStream, RIGHT-TRIM(pcBuffer)). ASSIGN pcBuffer = "" piBuffer = 0. END.
        {&TAG_DEFAULT}
        RUN pdf_text(pdfStream, cWord).
        RETURN TRUE.
    END.
    piPdfSeek = piPdfSeek + 1.
    IF piPdfSeek > LENGTH(pcText) THEN
        LEAVE Read-Loop.
    cChar = SUBSTRING(pcText, piPdfSeek, 1).
    IF cWord = "<" AND cChar <> "<" AND CAN-DO("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F", cChar) THEN
        lHexString = YES.
    IF lHexString AND cChar = ">" THEN DO:
        cWord = cWord + ">".
        {&TAG_START_CHAR}
        RUN pdf_text(pdfStream, cWord).
        RETURN TRUE.
    END.
    ELSE IF NOT lInString THEN DO:
        IF cChar = " " OR cChar = "~t" THEN
            LEAVE Read-Loop.
        IF (CAN-DO("[,],~/,(,~{", cChar) OR (cChar = "<" AND cWord > "" AND cWord <> "<" )) THEN DO: /* open/closure of array or start of item or string not preceded by a separator or start of dictionary or string */
            piPdfSeek = piPdfSeek - 1.
            LEAVE Read-Loop.
        END.
        IF cWord = ">" AND cChar = ">" THEN DO:
            {&TAG_DEFAULT}
            RUN pdf_text(pdfStream, ">>").
            RETURN TRUE.
        END.
        IF cChar = ">" THEN DO:
            cTmp = SUBSTRING(pcText, piPdfSeek + 1, 1).
            IF cTmp = ">" THEN DO: /* closure of dictionary not preceded by a separator */
                piPdfSeek = piPdfSeek - 1.
                LEAVE Read-Loop.            
            END.
        END.
    END.
    /* string objects ; special cases */
    ELSE DO:
        IF cChar = ")" THEN DO:
            IF iParenLvl = 0 THEN DO:
                /* lInString = NO. */
                cWord = cWord + ")".
                {&TAG_START_CHAR}
                RUN pdf_text (pdfStream, cWord).
                RETURN TRUE.
            END.
            ELSE /* 02-JUL-2011 jcc: manage balanced parenthesis in strings */
                iParenLvl = iParenLvl - 1.
        END.
        /* 02-JUL-2011 jcc: manage balanced parenthesis in strings */
        ELSE IF cChar = "(" THEN
            iParenLvl = iParenLvl + 1.
    END.
  END. /* Read-Loop */

  dTmp = DECIMAL(cWord) NO-ERROR.
  IF NOT ERROR-STATUS:ERROR THEN DO: /* is a number */
      IF piBuffer < 2 THEN DO:
          ASSIGN
           pcBuffer = pcBuffer + cWord + " "
           piBuffer = piBuffer + 1.
          RETURN TRUE.
      END.
      ELSE DO:
          {&TAG_START_NUMBER}
          RUN pdf_text (pdfStream, pcBuffer).
          ASSIGN pcBuffer = "" piBuffer = 0.
      END.
  END.
  ELSE IF CAN-DO("obj,endobj,R", cWord) THEN DO: /* object or reference */
      {&TAG_START_PREP}
      RUN pdf_text (pdfStream, pcBuffer).
      ASSIGN pcBuffer = "" piBuffer = 0.
  END.
  ELSE IF pcBuffer > "" THEN DO: /* bufferized number */
      {&TAG_START_NUMBER}
      RUN pdf_text (pdfStream, pcBuffer).
      ASSIGN pcBuffer = "" piBuffer = 0.
  END.
  ELSE IF lIsName THEN /* /Name */
      {&TAG_START_KEYWORD}
  ELSE
      {&TAG_DEFAULT}

  RUN pdf_text (pdfStream, cWord).
  IF cChar = " " OR cChar = "~t" THEN
      RUN pdf_text (pdfStream, " ").

  RETURN piPdfSeek < LENGTH(pcText).

END FUNCTION. /* ReadWord */

PROCEDURE pdf_text_PDF_syntax_color:
    DEFINE INPUT  PARAMETER pdfStream AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcLine AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE cBuffer  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iBuffer  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iPdfSeek AS INTEGER     NO-UNDO.

    DO WHILE iPdfSeek < LENGTH(pcLine) AND ReadWord(INPUT-OUTPUT iPdfSeek, pcLine, INPUT-OUTPUT cBuffer, INPUT-OUTPUT iBuffer):
        .
    END.
    IF cBuffer > "" THEN DO:
        {&TAG_START_NUMBER}
        RUN pdf_text (pdfStream, cBuffer).
    END.

END PROCEDURE.

PROCEDURE pdf_text_XML_syntax_color:
    DEFINE INPUT  PARAMETER pdfStream AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcLine AS CHARACTER   NO-UNDO.

    RUN pdf_text (pdfStream, pcLine).
END PROCEDURE.

FUNCTION replaceQuotes RETURNS CHARACTER (pcString AS CHARACTER):
    IF pcString = "" THEN RETURN "".
    pcString = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(pcString
                                      , '" "', '“ ”')
                                      , ' "', ' “')
                                      , '("', '(“')
                                      , '" ', '” ')
                                      , '".', '”.')
                                      , '",', '”,')
                                      , '")', '”)')
                                      , '";', '”;')
                                      , '":', '”:')
                                      , "' ", "’ ")
                                      , "'.", "’.")
                                      , "',", "’,")
                                      , "';", "’;")
                                      , "':", "’:")
                                      , "')", "’)")
                                      , " '", " ‘")
                                      , "'s", "’s")
                                      , "'t", "’t")
                                      , "'d", "’d")
    .
    IF SUBSTRING(pcString, 1, 1) = '"' THEN SUBSTRING(pcString, 1, 1) = '“'.
    IF SUBSTRING(pcString, LENGTH(pcString), 1) = '"' THEN SUBSTRING(pcString, LENGTH(pcString), 1) = '”'.
    IF SUBSTRING(pcString, 1, 1) = "'" THEN SUBSTRING(pcString, 1, 1) = "‘".
    IF SUBSTRING(pcString, LENGTH(pcString), 1) = "'" THEN SUBSTRING(pcString, LENGTH(pcString), 1) = "’".
    RETURN pcString.
END FUNCTION.

/* readme.p */
