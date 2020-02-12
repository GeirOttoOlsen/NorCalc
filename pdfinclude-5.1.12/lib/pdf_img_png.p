/******************************************************************************

    Program:        lib/pdf_img_png.p

    Written By:     Jean-Christophe Cardot
    Written On:     November 25, 2014

    Description:    Load and parse a PNG picture in order to make it usable
                    within a pdfStream file.

    Note:           All bit depths supported; indexed and RGB, transparency
                    and alpha layer included.
                    Code moved here from pdf_inc.p.
    
    --------------------- Revision History ------------------

    Date:     Author        Change Description

    11/25/14  JC Cardot     Creation

******************************************************************************/

{inc/pdf_pre.i}
{inc/pdf_func_compress.i}
{inc/pdf_func_bin.i "SHARED"}

DEFINE STREAM S_pdf_inp.

DEFINE INPUT  PARAMETER pdfStream             AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pImage                AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opcType               AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opiWidth              AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER opiHeight             AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER opiDepth              AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER opiBitDepth           AS INTEGER     NO-UNDO. /* aka bits per component */
DEFINE OUTPUT PARAMETER opcColorSpace         AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opcAltColorSpace      AS CHARACTER   NO-UNDO. /* 14-NOV-2014 jcc */
DEFINE OUTPUT PARAMETER opcDeviceNComponents  AS CHARACTER   NO-UNDO. /* 13-NOV-2014 jcc */
DEFINE OUTPUT PARAMETER opcFunctionParams     AS CHARACTER   NO-UNDO. /* 13-NOV-2014 jcc */
DEFINE OUTPUT PARAMETER opcFunctionPostScript AS CHARACTER   NO-UNDO. /* 13-NOV-2014 jcc */
DEFINE OUTPUT PARAMETER opcFilter             AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opcParams             AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opcDataFile           AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opcPalFile            AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opiPalLength          AS INTEGER     NO-UNDO.
DEFINE OUTPUT PARAMETER opcTrns               AS CHARACTER   NO-UNDO.
DEFINE OUTPUT PARAMETER opcTrnsMaskFile       AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER cTmpImgName           AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER mImage                AS MEMPTR      NO-UNDO.

DEFINE VARIABLE i            AS INTEGER   NO-UNDO.
DEFINE VARIABLE iAlpha       AS INTEGER   NO-UNDO.
DEFINE VARIABLE iByteDepth   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iChunkLength AS INTEGER   NO-UNDO.
DEFINE VARIABLE iColorType   AS INTEGER   NO-UNDO.
DEFINE VARIABLE iDataLength  AS INTEGER   NO-UNDO.
DEFINE VARIABLE iDecompSize  AS INTEGER   NO-UNDO.
DEFINE VARIABLE iFileSize    AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPos         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iRetCode     AS INTEGER   NO-UNDO.
DEFINE VARIABLE j            AS INTEGER   NO-UNDO.
DEFINE VARIABLE lIDATFound   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mByte        AS MEMPTR    NO-UNDO.
DEFINE VARIABLE mChunk       AS MEMPTR    NO-UNDO.
DEFINE VARIABLE mDecomp      AS MEMPTR    NO-UNDO.
DEFINE VARIABLE mSixBytes    AS MEMPTR    NO-UNDO.
DEFINE VARIABLE mThreeBytes  AS MEMPTR    NO-UNDO.
DEFINE VARIABLE mTwoBytes    AS MEMPTR    NO-UNDO.

opiBitDepth = GET-BYTE(mImage, 25).
iColorType = GET-BYTE(mImage, 26).
CASE iColorType:
    WHEN 0 THEN /* grayscale */
        ASSIGN
         opcColorSpace = "/DeviceGray"
         opiDepth      = opiBitDepth.
    WHEN 2 THEN /* RGB encoded */
        ASSIGN
         opcColorSpace = "/DeviceRGB"
         opiDepth      = opiBitDepth * 3.
    WHEN 3 THEN /* Palette based, 8 bpp */
        ASSIGN
         opcColorSpace    = "/Indexed"
         opcAltColorSpace = "/DeviceRGB"
         opiDepth         = 8.
    WHEN 4 THEN DO: /* greyscale with alpha */
        ASSIGN
         opcColorSpace = "/DeviceGray"
         opiDepth      = opiBitDepth * 2.
        SET-SIZE(mImage) = 0.
        RETURN ERROR 'PNG: alpha channel not currently supported'.
    END.
    WHEN 6 THEN DO: /* RGB encoded with alpha */
        ASSIGN
         opcColorSpace = "/DeviceRGB"
         opiDepth      = opiBitDepth * 4.
    END.
    OTHERWISE DO:
        SET-SIZE(mImage) = 0.
        RETURN ERROR 'PNG: unknown color type'.
    END.
END CASE.
/* Checks for (un)supported functionalities */
IF GET-BYTE(mImage, 27) <> 0 THEN DO:
    SET-SIZE(mImage) = 0.
    RETURN ERROR 'PNG: unsupported compression method'.
END.
IF GET-BYTE(mImage, 28) <> 0 THEN DO:
    SET-SIZE(mImage) = 0.
    RETURN ERROR 'PNG: unsupported filter method'.
END.
IF GET-BYTE(mImage, 29) <> 0 THEN DO:
    SET-SIZE(mImage) = 0.
    RETURN ERROR 'PNG: interlaced images not currently supported'.
END.
ASSIGN
 opcType = "PNG"
 opiWidth  = 16777216 * GET-BYTE(mImage, 17) + 65536 * GET-BYTE(mImage, 18) + 256 * GET-BYTE(mImage, 19) + GET-BYTE(mImage, 20)
 opiHeight = 16777216 * GET-BYTE(mImage, 21) + 65536 * GET-BYTE(mImage, 22) + 256 * GET-BYTE(mImage, 23) + GET-BYTE(mImage, 24)
 opcParams = "/DecodeParms <</Predictor 15 /Colors " + (IF iColorType = 2 OR iColorType = 6 THEN "3" ELSE "1") + " /BitsPerComponent " + STRING(opiBitDepth) + " /Columns " + STRING(opiWidth) + ">>"
 opcFilter = "/FlateDecode".
/* now store the data, palette & transparency information in temp files */

RUN getFileAsMemptr (pdfStream, pImage, ?, INPUT-OUTPUT mImage, OUTPUT iFileSize).
iPos = 34. /* start of the next chunk */
blkChunks:
DO WHILE TRUE:
    iChunkLength  = 16777216 * GET-BYTE(mImage, iPos) + 65536 * GET-BYTE(mImage, iPos + 1) + 256 * GET-BYTE(mImage, iPos + 2) + GET-BYTE(mImage, iPos + 3).
    /* MESSAGE "png chunk:" GET-STRING(mImage, iPos + 4, 4) SKIP "length:" iChunkLength VIEW-AS ALERT-BOX INFO BUTTONS OK. */
    CASE GET-STRING(mImage, iPos + 4, 4):
        /* Palette */
        WHEN "PLTE" THEN DO:
            ASSIGN
             opcPalFile = cTmpImgName + ".pal"
             opiPalLength = iChunkLength.
            SET-SIZE(mChunk) = iChunkLength.
            PUT-BYTES(mChunk, 1) = GET-BYTES(mImage, iPos + 8, iChunkLength).
            OUTPUT TO VALUE(opcPalFile) BINARY NO-MAP NO-CONVERT NO-ECHO.
            EXPORT mChunk.
            OUTPUT CLOSE.
            SET-SIZE(mChunk) = 0.
        END.
        /* Transparency information */
        WHEN "TRNS" THEN DO:
            CASE iColorType:
                WHEN 0 THEN DO: /* grayscale: one transparent grayscale level */
                    opcTrns = STRING(GET-BYTE(mImage, iPos + 8 + i) * 256 + GET-BYTE(mImage, iPos + 8 + i + 1)) + " " + STRING(GET-BYTE(mImage, iPos + 8 + i) * 256 + GET-BYTE(mImage, iPos + 8 + i + 1)).
                END.
                WHEN 2 THEN DO: /* RGB encoded: one transparent R,G,B color */
                    opcTrns = STRING(GET-BYTE(mImage, iPos + 8 + i)     * 256 + GET-BYTE(mImage, iPos + 8 + i + 1)) + " " + STRING(GET-BYTE(mImage, iPos + 8 + i)     * 256 + GET-BYTE(mImage, iPos + 8 + i + 1)) + " " +
                              STRING(GET-BYTE(mImage, iPos + 8 + i + 2) * 256 + GET-BYTE(mImage, iPos + 8 + i + 3)) + " " + STRING(GET-BYTE(mImage, iPos + 8 + i + 2) * 256 + GET-BYTE(mImage, iPos + 8 + i + 3)) + " " + 
                              STRING(GET-BYTE(mImage, iPos + 8 + i + 4) * 256 + GET-BYTE(mImage, iPos + 8 + i + 5)) + " " + STRING(GET-BYTE(mImage, iPos + 8 + i + 4) * 256 + GET-BYTE(mImage, iPos + 8 + i + 5)).
                END.
                WHEN 3 THEN DO: /* Palette based, 8 bpp: alpha level (0-255) for corresponding palette entries */
                    /* The following is valid only there is only some completely transparent colors! i.e. no "intermediate" alpha values */
                    DO i = 1 TO iChunkLength:
                        iAlpha = GET-BYTE(mImage, iPos + 7 + i).
                        IF iAlpha = 0 THEN
                            opcTrns = opcTrns + " " + STRING(i - 1) + " " + STRING(i - 1).
                        ELSE IF iAlpha < 255 THEN DO:
                            opcTrns = "".
                            LEAVE.
                        END.
                    END.
                    IF opcTrns > "" THEN
                        opcTrns = SUBSTRING(opcTrns, 2).
                    ELSE DO: /* we have palette entries with alpha values not 0 nor 255. We have to create a soft mask! */
                        /* 1. un-filter the PNG image using the png predictor */
                        /* 2. for each pixel of the image, get its palette entry (= its integer value) */
                        /* 4. depending on the value of its alpha, set the soft mask pixel between 0 & 255 */
                        SET-SIZE(mImage) = 0.
                        RETURN ERROR 'PNG: palette alpha transparency unsupported'.
                    END.
                END.
                OTHERWISE DO: /* This chunk must not appear when there is a full alpha channel */
                    SET-SIZE(mImage) = 0.
                    RETURN ERROR 'PNG: malformed image'.
                END.
            END CASE.
        END.
        /* Image data ; there might be more than one IDAT chunk */
        WHEN "IDAT" THEN DO:
            SET-SIZE(mChunk) = iChunkLength.
            ASSIGN
                iDataLength = iDataLength + iChunkLength
                i = 1.
            DO WHILE i < iChunkLength:
                PUT-BYTES(mChunk, i) = GET-BYTES(mImage, iPos + 7 + i, MIN(iChunkLength - i + 1, 30000)).
                i = i + 30000.
            END.
            IF NOT lIDATFound THEN DO:
                lIDATFound = YES.
                opcDataFile = cTmpImgName + ".data".
                OUTPUT TO VALUE(opcDataFile) BINARY NO-MAP NO-CONVERT NO-ECHO.
            END.
            ELSE DO:
                OUTPUT TO VALUE(opcDataFile) BINARY NO-MAP NO-CONVERT NO-ECHO APPEND.
            END.
            EXPORT mChunk.
            OUTPUT CLOSE. /* OUTPUT TO VALUE(opcDataFile) */
            SET-SIZE(mChunk) = 0.
            /* as there might be more than one IDAT chunk, postpone the image processing to the IEND chunk */
        END.
        /* Image end */
        WHEN "IEND" THEN DO:
            /* If there is an alpha channel, then extract the alpha information to create a soft mask (/SMask)
               and the plain image, i.e. without alpha channel */
            /* Note: should be optimized not to generate a soft mask when there is no transparency at all */
            IF lIDATFound AND (iColorType = 4 OR iColorType = 6) THEN DO:
                SET-SIZE(mByte) = 1. SET-SIZE(mTwoBytes) = 2. SET-SIZE(mThreeBytes) = 3. SET-SIZE(mSixBytes) = 6.

                SET-SIZE(mChunk) = iDataLength.
                INPUT  STREAM S_pdf_inp FROM VALUE(SEARCH(opcDataFile)) BINARY NO-MAP NO-CONVERT.
                IMPORT STREAM S_pdf_inp mChunk.
                INPUT  STREAM S_pdf_inp CLOSE.
                OS-DELETE VALUE(opcDataFile). /* is created again below */
                iRetCode = DeCompressBuffer(mChunk, OUTPUT mDecomp, OUTPUT iDecompSize). /* OUTPUT TO c:\temp\data.txt BINARY NO-MAP NO-CONVERT. EXPORT mDecomp. OUTPUT CLOSE. */
                IF iRetCode <> 0 THEN DO:
                    SET-SIZE(mImage) = 0.
                    SET-SIZE(mChunk) = 0. SET-SIZE(mByte) = 0. SET-SIZE(mTwoBytes) = 0. SET-SIZE(mThreeBytes) = 0. SET-SIZE(mSixBytes) = 0.
                    RETURN ERROR 'PNG: zlib error: ' + STRING(iRetCode).
                END.
                /* Extract alpha transparency layer => will go in a /SMask */
                OUTPUT TO VALUE(cTmpImgName + ".alpha") BINARY NO-MAP NO-CONVERT NO-ECHO.
                iByteDepth = opiBitDepth / 8.
                i = 1.
                DO WHILE i <= iDecompSize - opiWidth * opiBitDepth / 2:
                    /* pdf filter byte */
                    PUT-BYTE(mByte, 1) = GET-BYTE(mDecomp, i).
                    EXPORT mByte.

                    IF opiBitDepth = 8 THEN DO j = 4 TO opiWidth * 4 /* opiBitDepth / 2 */:
                        PUT-BYTE(mByte, 1) = GET-BYTE(mDecomp, i + j).
                        EXPORT mByte.
                        j = j + 3. /* skip RGB */
                    END.
                    /* Note about 16 bits soft masks:
                     * 16 bits pictures are supported starting with pdf 1.5 (Acrobat 6),
                       however 16 bits masks only work starting with Acrobat X. not my bug.
                     * Work with: Acrobat X, Foxit Reader (tested v3.3), Ghostscript (GSview 4.7), MacOS X Preview
                     * Does not work with Acrobat 6 7 8 9, nor Google Docs (as of 10/20/2011) */
                    ELSE IF opiBitDepth = 16 THEN DO j = 7 TO opiWidth * 8 /* opiBitDepth / 2 */:
                        PUT-BYTES(mTwoBytes, 1) = GET-BYTES(mDecomp, i + j, 2).
                        EXPORT mTwoBytes.
                        j = j + 7. /* increment j + skip RGB (6 bytes) */
                    END.
                    i = i + opiWidth * opiBitDepth / 2 + 1.
                END.
                OUTPUT CLOSE.

                /* Extract image information without the alpha channel */
                OUTPUT TO VALUE(cTmpImgName + ".rgb") BINARY NO-MAP NO-CONVERT NO-ECHO.
                i = 1.
                DO WHILE i <= iDecompSize - opiWidth * opiBitDepth / 2:
                    /* pdf filter byte */
                    PUT-BYTE(mByte, 1) = GET-BYTE(mDecomp, i).
                    EXPORT mByte.

                    IF opiBitDepth = 8 THEN DO j = 1 TO opiWidth * 4 /* opiBitDepth / 2 */:
                        PUT-BYTES(mThreeBytes, 1) = GET-BYTES(mDecomp, i + j, 3).
                        EXPORT mThreeBytes.
                        j = j + 3. /* increment j (2 more bytes) + skip alpha channel (1 byte) */
                    END.
                    ELSE IF opiBitDepth = 16 THEN DO j = 1 TO opiWidth * 8 /* opiBitDepth / 2 */:
                        PUT-BYTES(mSixBytes, 1) = GET-BYTES(mDecomp, i + j, 6).
                        EXPORT mSixBytes.
                        j = j + 7. /* increment j (5 more bytes) + skip alpha channel (2 bytes) */
                    END.
                    i = i + opiWidth * opiBitDepth / 2 + 1.
                END.
                OUTPUT CLOSE.

                iRetCode = compressFile(cTmpImgName + ".rgb", cTmpImgName + ".rgb.z").
                IF iRetCode <> 0 THEN DO:
                    SET-SIZE(mImage) = 0.
                    SET-SIZE(mChunk) = 0. SET-SIZE(mByte) = 0. SET-SIZE(mTwoBytes) = 0. SET-SIZE(mThreeBytes) = 0. SET-SIZE(mSixBytes) = 0.
                    RETURN ERROR 'PNG: zlib error: ' + STRING(iRetCode).
                END.
                OS-DELETE VALUE(cTmpImgName + ".rgb").
                iRetCode = compressFile(cTmpImgName + ".alpha", cTmpImgName + ".alpha.z").
                IF iRetCode <> 0 THEN DO:
                    SET-SIZE(mImage) = 0.
                    SET-SIZE(mChunk) = 0. SET-SIZE(mByte) = 0. SET-SIZE(mTwoBytes) = 0. SET-SIZE(mThreeBytes) = 0. SET-SIZE(mSixBytes) = 0.
                    RETURN ERROR 'PNG: zlib error: ' + STRING(iRetCode).
                END.

                OS-DELETE VALUE(cTmpImgName + ".alpha").
                ASSIGN
                 opcDataFile     = cTmpImgName + ".rgb.z"
                 opcTrnsMaskFile = cTmpImgName + ".alpha.z".
                /* cleanup */
                SET-SIZE(mChunk) = 0.
                SET-SIZE(mByte) = 0. SET-SIZE(mTwoBytes) = 0. SET-SIZE(mThreeBytes) = 0. SET-SIZE(mSixBytes) = 0.
            END.

            LEAVE blkChunks.
        END.
        OTHERWISE DO:
            /* nothing: ignore the chunk */
        END.
    END CASE.
    iPos = iPos + 8 + iChunkLength + 4.
    IF iPos >= iFileSize - 10 THEN DO:
        SET-SIZE(mImage) = 0.
        RETURN ERROR 'PNG: incorrect file format!'.
    END.
END. /* blkChunks: DO WHILE TRUE */

IF opcColorSpace = "/Indexed" AND opcPalFile = "" THEN DO:
    SET-SIZE(mImage) = 0.
    RETURN ERROR 'PNG: missing palette'.
END.
