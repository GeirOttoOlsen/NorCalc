/* 03-OCT-2014 jcc: parse a ttf file and create the corresponding ufm file */

/* Temp-tables definition */
{inc/pdf_tt_fonts.i "NEW SHARED"}

DEFINE STREAM sAFM.

FUNCTION GetWidgetOption2 RETURNS CHARACTER   /* PRIVATE */
    (INPUT pOption  AS CHARACTER,
     INPUT pOptions AS CHARACTER,
     INPUT pDefault AS CHARACTER):

    DEFINE VARIABLE cOpt AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i    AS INTEGER     NO-UNDO.

    DO i = NUM-ENTRIES(pOptions) TO 1 BY -1:
        cOpt = ENTRY(i, pOptions).
        IF ENTRY(1, cOpt, "=") = pOption THEN
            IF NUM-ENTRIES(cOpt, "=") = 1 THEN
                RETURN "YES".
            ELSE
                RETURN ENTRY(2, cOpt, "=").
    END.
    RETURN pDefault.
END FUNCTION. /* GetWidgetOption2 */

FUNCTION basename RETURNS CHARACTER (ipcFile AS CHARACTER):
    RETURN ENTRY(NUM-ENTRIES(REPLACE(ipcFile, "~\", "~/"), "~/"), REPLACE(ipcFile, "~\", "~/"), "~/").
END FUNCTION.

PROCEDURE _outputUFMHeadItem:
    DEFINE INPUT  PARAMETER pcHeader AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pcValue AS CHARACTER   NO-UNDO.

    IF pcValue = ? THEN RETURN.
    PUT STREAM sAFM UNFORMATTED pcHeader " " REPLACE(pcValue, "~n", " ") "~n".
END PROCEDURE.

/* 07-OCT-2014 jcc: create a font ufm or afm file */
PROCEDURE outputUFM:
    DEFINE PARAMETER BUFFER tt_pdf_font FOR tt_pdf_font.
    DEFINE INPUT PARAMETER pcFileName AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pcOptions  AS CHARACTER   NO-UNDO.

    OUTPUT STREAM sAFM TO value(pcFileName) NO-MAP NO-CONVERT.
    PUT STREAM sAFM UNFORMATTED "StartFontMetrics 4.1" SKIP.
    RUN _outputUFMHeadItem("FontName", tt_pdf_font.afm_FontName).
    RUN _outputUFMHeadItem("FullName", tt_pdf_font.afm_FullName).
    RUN _outputUFMHeadItem("Notice", tt_pdf_font.afm_Notice).
    /* RUN _outputUFMHeadItem("EncodingScheme", tt_pdf_font.afm_EncodingScheme). */
    RUN _outputUFMHeadItem("FamilyName", tt_pdf_font.afm_FamilyName).
    RUN _outputUFMHeadItem("Weight", tt_pdf_font.afm_Weight).
    RUN _outputUFMHeadItem("Version", tt_pdf_font.afm_Version).
    RUN _outputUFMHeadItem("Characters", tt_pdf_font.afm_Characters).
    RUN _outputUFMHeadItem("ItalicAngle", tt_pdf_font.afm_ItalicAngle).
    RUN _outputUFMHeadItem("Ascender", tt_pdf_font.afm_Ascender).
    RUN _outputUFMHeadItem("Descender", tt_pdf_font.afm_Descender).
    RUN _outputUFMHeadItem("UnderlinePosition", tt_pdf_font.afm_UnderlinePosition).
    RUN _outputUFMHeadItem("UnderlineThickness", tt_pdf_font.afm_UnderlineThickness).
    RUN _outputUFMHeadItem("IsFixedPitch", IF tt_pdf_font.afm_IsFixedPitch = "1" THEN "true" ELSE "false").
    RUN _outputUFMHeadItem("FontBBox", tt_pdf_font.afm_FontBBox).
    RUN _outputUFMHeadItem("CapHeight", tt_pdf_font.afm_CapHeight).
    RUN _outputUFMHeadItem("XHeight", tt_pdf_font.afm_XHeight).
    RUN _outputUFMHeadItem("StdHW", tt_pdf_font.afm_StdHW).
    RUN _outputUFMHeadItem("StdVW", tt_pdf_font.afm_StdVW).
    RUN _outputUFMHeadItem("StartCharMetrics", tt_pdf_font.afm_StartCharMetrics).
    IF GetWidgetOption2("type", pcOptions, "ufm") = "afm" THEN DO: /* AFM */
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.char_id >= 0:
            PUT STREAM sAFM UNFORMATTED "C " IF TT_pdf_font_character.char_id >= 0 AND TT_pdf_font_character.char_id <= 255 THEN TT_pdf_font_character.char_id ELSE -1 " ; WX " TT_pdf_font_character.char_width " ; N " TT_pdf_font_character.char_name " ; B " TT_pdf_font_character.char_bbox " ;~n".
        END.
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.char_id < 0:
            PUT STREAM sAFM UNFORMATTED "C -1 ; WX " TT_pdf_font_character.char_width " ; N " TT_pdf_font_character.char_name " ; B " TT_pdf_font_character.char_bbox " ;~n".
        END.
    END.
    ELSE DO: /* UFM */
        /* FOR EACH TT_pdf_font_character BY TT_pdf_font_character.glyph BY TT_pdf_font_character.char_id: */
            /* PUT STREAM sAFM UNFORMATTED "U " IF TT_pdf_font_character.glyph = 0 THEN -1 ELSE IF TT_pdf_font_character.char_id >= 32 AND TT_pdf_font_character.char_id <= 65536 THEN TT_pdf_font_character.char_id ELSE -1 " ; WX " TT_pdf_font_character.char_width " ; N " TT_pdf_font_character.char_name " ; G " TT_pdf_font_character.glyph " ;~n". */
        /* END. */
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.char_id >= 0:
            PUT STREAM sAFM UNFORMATTED "U " IF TT_pdf_font_character.glyph = 0 THEN -1 ELSE IF TT_pdf_font_character.char_id >= 32 AND TT_pdf_font_character.char_id <= 65536 THEN TT_pdf_font_character.char_id ELSE -1 " ; WX " TT_pdf_font_character.char_width " ; N " TT_pdf_font_character.char_name " ; G " TT_pdf_font_character.glyph " ;~n".
        END.
        FOR EACH TT_pdf_font_character WHERE TT_pdf_font_character.char_id < 0 BY TT_pdf_font_character.glyph:
            PUT STREAM sAFM UNFORMATTED "U -1 ; WX " TT_pdf_font_character.char_width " ; N " TT_pdf_font_character.char_name " ; G " TT_pdf_font_character.glyph " ;~n".
        END.
    END.
    PUT STREAM sAFM UNFORMATTED "EndCharMetrics~n".
    PUT STREAM sAFM UNFORMATTED "EndFontMetrics~n".
    OUTPUT STREAM sAFM CLOSE.

END PROCEDURE.

DEFINE VARIABLE cFontName      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFontType      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cFontFile      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE hFontParserLib AS HANDLE      NO-UNDO.

RUN lib/pdf_parse_font.p PERSISTENT SET hFontParserLib.

/* cFontFile = "fonts/dejavu-fonts-ttf-2.34/ttf/DejaVuSans.ttf". */
/* cFontFile = "fonts/dejavu-fonts-ttf-2.34/ttf/DejaVuSerif-BoldItalic.ttf". */
/* cFontFile = "fonts/Baybayin/TagDoc93.ttf". */
/* cFontFile = "fonts/code39.ttf". */
/* cFontFile = "fonts/ArialUni.ttf". */
/* cFontFile = "fonts/SIMYOU.ttf". */
/* cFontFile = "fonts/Cybercjk.ttf". */
/* cFontFile = "c:/windows/fonts/lucon.ttf". */
/* cFontFile = "c:/windows/fonts/lhandw.ttf". */
/* cFontFile = "c:/windows/fonts/cour.ttf". */
cFontFile = "c:/windows/fonts/arial.ttf".
/* cFontFile = "fonts/BRLNSB.ttf". */

ETIME(YES).
RUN parseFont IN hFontParserLib
    ("Spdf", "myFont", cFontFile, BUFFER tt_pdf_font,
     "usecache=NO,cid2gid,charbbox,charname,kerning=NO,unicode").
DISPLAY ETIME LABEL "ETIME".

RUN outputUFM (BUFFER tt_pdf_font
              ,SESSION:TEMP-DIRECTORY + "pdfcache/fonts/" + REPLACE(basename(cFontFile), ".ttf", ".ufm")
              ,"").
RUN outputUFM (BUFFER tt_pdf_font
              ,SESSION:TEMP-DIRECTORY + "pdfcache/fonts/" + REPLACE(basename(cFontFile), ".ttf", ".afm")
              ,"type=afm,kerning=no").

DISPLAY tt_pdf_font.

FOR EACH TT_pdf_font_character:
    DISPLAY TT_pdf_font_character.
END.

/*
DEFINE VARIABLE cFile AS CHARACTER   NO-UNDO.
DEFINE STREAM sLog.
INPUT FROM OS-DIR("c:/windows/fonts") NO-ATTR-LIST.
OUTPUT STREAM sLog TO C:/TEMP/OpenEdge/WRK/pdfcache/fonts/parsefont.log.
REPEAT:
    IMPORT cFile.
    IF cFile MATCHES "*.ttf" THEN DO:
        /* DISPLAY cFile. */
        CREATE tt_pdf_font.afm_
        cFontFile = "c:/windows/fonts/" + cFile.
        ETIME(YES).
        RUN parseFont (BUFFER tt_pdf_font_metrics, "usecache=n,charbbox=NO,charname").
        /* PROCESS EVENTS. */
        EXPORT STREAM sLog cFile ETIME.
        RUN outputUFM (BUFFER tt_pdf_font_metrics, SESSION:TEMP-DIRECTORY + "pdfcache/fonts/" + REPLACE(cFile, ".ttf", ".ufm"), ?).
        EMPTY TEMP-TABLE tt_pdf_font.afm_
        EMPTY TEMP-TABLE TT_pdf_font_character.
    END.
END.
OUTPUT STREAM sLog CLOSE.
INPUT CLOSE.
*/

DELETE PROCEDURE hFontParserLib.
