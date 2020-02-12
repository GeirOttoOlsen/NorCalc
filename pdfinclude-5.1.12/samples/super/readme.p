/*******************************************************************************

    Program:        readme.p
    
    Description:    Generates readme.pdf from the readme.txt file
    
    Purpose:        Test links within a document

*******************************************************************************/
{samples/support/config.i}

{pdf_inc.i "THIS-PROCEDURE"}

/* 14-OCT-2014 jcc: use the syntaxic coloration library */
DEFINE VARIABLE hABLColor AS HANDLE   NO-UNDO.
RUN lib/pdf_ABL_color.p PERSISTENT SET hABLColor (h_PDFinc).

FUNCTION basename RETURNS CHARACTER (ipcFile AS CHARACTER):
    RETURN ENTRY(NUM-ENTRIES(REPLACE(ipcFile, "~\", "~/"), "~/"), REPLACE(ipcFile, "~\", "~/"), "~/").
END FUNCTION.

DEFINE VARIABLE cBookmarks   AS CHARACTER   NO-UNDO INITIAL ",,,,,". /* keep track of the parent bookmarks */.
DEFINE VARIABLE cChar        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFont        AS CHARACTER   NO-UNDO INITIAL "Helvetica".
DEFINE VARIABLE cLine        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cOldFont     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cText        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cType        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dOldFontSize AS DECIMAL     NO-UNDO.
DEFINE VARIABLE iBookmark    AS INTEGER     NO-UNDO.
DEFINE VARIABLE iHeight      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iLevel       AS INTEGER     NO-UNDO.
DEFINE VARIABLE iMaxY        AS INTEGER     NO-UNDO.
DEFINE VARIABLE iWidth       AS INTEGER     NO-UNDO.
DEFINE VARIABLE pdfStream    AS CHARACTER   NO-UNDO INITIAL "sPDF".

RUN pdf_new(pdfStream,cPdfIncludePath + "samples/super/readme.pdf").

/* RUN pdf_set_parameter(pdfStream,"COMPRESS","TRUE"). */

RUN pdf_set_info ("Spdf", "Author", "Jic" + CHR(50089, SESSION:CHARSET, "utf-8")). /* accentuated char to test utf-8 */
RUN pdf_set_info ("Spdf", "Title",  "readme.p").

RUN pdf_set_parameter("Spdf", "unitTest", "TRUE").

RUN pdf_set_parameter("Spdf", "defaultHeader", "TRUE"). /* 08-APR-2014 jcc */
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
RUN pdf_set_BottomMargin(pdfStream, 50).
RUN pdf_set_TopMargin(pdfStream, 50).

/* Instantiate a New Page */
RUN pdf_new_page(pdfStream).

RUN pdf_set_font(pdfStream, cFont, 12).

INPUT FROM VALUE(cPdfIncludePath + "samples/super/readme.txt").

REPEAT :
    IMPORT UNFORMATTED cLine NO-ERROR.
    cChar = SUBSTRING(cLine, 1, 1).
    CASE cChar:
        /* Preprocessors */
        WHEN "&" THEN
            CASE ENTRY(1, cLine, " "):
                WHEN "&EOF" THEN LEAVE. /* End Of File */
                WHEN "&T"   THEN /* Toggle tags */
                    RUN pdf_set_parameter(
                        pdfStream, "UseTags",
                        IF pdf_get_parameter(pdfStream, "UseTags") = "TRUE" THEN "FALSE" ELSE "TRUE").
                WHEN "&IMG" THEN DO: /* Image */
                    RUN pdf_load_image(pdfStream, basename(ENTRY(2, cLine, " ")), ENTRY(2, cLine, " ")).
                    RUN pdf_get_image_info(pdfStream, basename(ENTRY(2, cLine, " ")),
                                           OUTPUT cType, OUTPUT iHeight, OUTPUT iWidth).
                    iHeight = iHeight / 3.
                    iWidth  = iWidth / 3.
                    IF pdf_TextY(pdfStream) - iHeight / pdf_PointSize(pdfStream) < pdf_BottomMargin(pdfStream) THEN
                        RUN pdf_new_page(pdfStream).
                    RUN pdf_skipn(pdfStream, iHeight / pdf_PointSize(pdfStream)).
                    RUN pdf_place_image(pdfStream, basename(ENTRY(2, cLine, " ")), pdf_TextX(pdfStream), pdf_PageHeight(pdfStream) - pdf_TextY(pdfStream), iWidth, iHeight).
                    RUN pdf_skip(pdfStream).
                END.
                WHEN "&HR" THEN DO: /* Horizontal rule */
                    RUN pdf_skip(pdfStream).
                    RUN pdf_stroke_color(pdfStream, .8, .8, .8).
                    RUN pdf_line(pdfStream, pdf_LeftMargin(pdfStream) - 5, pdf_TextY(pdfStream) + pdf_PointSize(pdfStream) / 2, pdf_PageWidth(pdfStream) - 15, pdf_TextY(pdfStream) + pdf_PointSize(pdfStream) / 2, 1).
                END.
                WHEN "&FF" THEN
                    RUN pdf_new_page(pdfStream).
                OTHERWISE NEXT. /* ignore unknown preprocessor */
            END CASE.
        /* Comment */
        WHEN "#" THEN NEXT.
        /* Heading */
        WHEN "=" THEN DO:
            cText = LEFT-TRIM(cLine, "=").
            iLevel = LENGTH(cLine) - LENGTH(cText).
            /* Page break before title 1 */
            IF iLevel = 1 THEN DO:
                RUN pdf_new_page(pdfStream).
                RUN pdf_skipn(pdfStream, 2).
            END.
            ELSE RUN pdf_skip(pdfStream).
            
            /* 14-OCT-2014 jcc: the font size has to be set before calling pdf_bookmark, to get an accurate position within the pdf file */
            dOldFontSize = pdf_PointSize(pdfStream).
            RUN pdf_set_font(pdfStream, cFont, MAXIMUM(12 * (5 - iLevel) / 2, 12)).

            /* Manage bookmarks and parent them correctly */
            RUN pdf_bookmark(pdfStream, cText, IF iLevel = 1 THEN 0 ELSE INTEGER(ENTRY(iLevel - 1, cBookmarks)), iLevel = 1, OUTPUT iBookmark).
            ENTRY(iLevel, cBookmarks) = STRING(iBookmark).

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
                END CASE.
                RUN pdf_wrap_text(pdfStream,
                                  cText,
                                  1,
                                  80,
                                  "LEFT",
                                  OUTPUT iMaxY).
                IF iLevel = 3 THEN
                    RUN pdf_set_font(pdfStream, cFont, pdf_PointSize(pdfStream)).
            END.
            RUN pdf_set_font(pdfStream, cFont, dOldFontSize).
            RUN pdf_skipn(pdfStream, 2).
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
            RUN pdf_wrap_text(pdfStream,
                              cText,
                              4 * (iLevel + 1),
                              80,
                              "LEFT",
                              OUTPUT iMaxY).
            RUN pdf_skip(pdfStream).
        END.
        /* Indentation */
        WHEN "-" THEN DO:
            cText = LEFT-TRIM(cLine, "-").
            iLevel = LENGTH(cLine) - LENGTH(cText).
            RUN pdf_wrap_text(pdfStream,
                              cText,
                              4 * (iLevel + 1),
                              80,
                              "LEFT",
                              OUTPUT iMaxY).
            RUN pdf_skip(pdfStream).
        END.
        /* Code */
        WHEN "@" THEN DO:
            RUN pdf_set_font(pdfStream, "Courier", pdf_PointSize(pdfStream)).
            RUN pdf_text_ABL_syntax_color IN hABLColor (pdfStream, SUBSTRING(cLine, 2)).
            RUN pdf_skip(pdfStream).                                         
            RUN pdf_set_font(pdfStream, cFont, pdf_PointSize(pdfStream)).    
        END.
        /* Normal text */
        OTHERWISE DO:
            RUN pdf_wrap_text(pdfStream,
                              cLine,
                              1,
                              80,
                              "LEFT",
                              OUTPUT iMaxY).
            RUN pdf_skip(pdfStream).
        END.
    END.
END.

INPUT CLOSE.

RUN pdf_close(pdfStream).
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

DELETE PROCEDURE hABLColor.


/************************* Internal procedures ********************************/

PROCEDURE PageFooter:
/*------------------------------------------------------------------------------
  Purpose:  Procedure to Print Page Footer on all pages.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE y AS DECIMAL     NO-UNDO.
  y = pdf_TextY(pdfStream).
  RUN pdf_set_font(pdfStream,"Courier-Bold", 10).
  RUN pdf_text_color(pdfStream, 0, 0, 0).
  RUN pdf_stroke_color(pdfStream, .6, .6, .6).
  RUN pdf_line(pdfStream, 20, pdf_TextY(pdfStream) - 5, pdf_PageWidth(pdfStream) - 20 , pdf_TextY(pdfStream) - 5, 1).
  RUN pdf_text_align(pdfStream,
                     "(c) 2013 snowwolf-software.com",
                     "LEFT",
                     20,
                     y - 30).
  RUN pdf_text_align(pdfStream,
                     "Page " + STRING(pdf_page(pdfStream)) + " of " + pdf_TotalPages(pdfStream),
                     "LEFT",
                     pdf_PageWidth(pdfStream) - 100,
                     y - 30).
  /* restore default font */
  RUN pdf_set_font(pdfStream, cFont, 12).
END. /* PageFooter */

/* readme.p */
