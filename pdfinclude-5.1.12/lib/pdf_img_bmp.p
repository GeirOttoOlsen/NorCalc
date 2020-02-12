/******************************************************************************

    Program:        lib/pdf_img_bmp.p

    Written By:     Jean-Christophe Cardot
    Written On:     November 6, 2014

    Description:    Load and parse a BMP picture in order to make it usable
                    within a pdfStream file.

    Note:           All bit depths supported; alpha layer in 32 bits BMP will be
                    ignored; 16 bits BMP supported (X-B-R-G = 1-5-5-5) but a bug
                    in Acrobat X makes it to display strangely.
    
    --------------------- Revision History ------------------

    Date:     Author        Change Description

    11/06/14  JC Cardot     Creation

******************************************************************************/

{inc/pdf_pre.i}
{inc/pdf_func_bin.i "SHARED"}
{inc/pdf_func_compress.i}

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

DEFINE VARIABLE i                AS INTEGER   NO-UNDO.
DEFINE VARIABLE iFileSize        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iHeaderSize      AS INTEGER   NO-UNDO.
DEFINE VARIABLE iOffset          AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPadding         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPixelDataOffset AS INTEGER   NO-UNDO.
DEFINE VARIABLE iRetCode         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iScanLineSize    AS INTEGER   NO-UNDO.
DEFINE VARIABLE mChunk           AS MEMPTR    NO-UNDO.
DEFINE VARIABLE mPalette         AS MEMPTR    NO-UNDO.

ASSIGN
 opcType          = "BMP"
 iPixelDataOffset = GET-UNSIGNED-LONG(mImage, 11) + 1
 iHeaderSize      = GET-UNSIGNED-LONG(mImage, 15)
 opiWidth         = GET-UNSIGNED-LONG(mImage, 19)
 opiHeight        = GET-UNSIGNED-LONG(mImage, 23)
 opiDepth         = GET-UNSIGNED-SHORT(mImage, 29)
 opiBitDepth      = opiDepth.
IF GET-UNSIGNED-LONG(mImage, 31) > 0 THEN DO:
     SET-SIZE(mImage) = 0.
     RETURN ERROR 'BMP: compressed BMP images are currently not supported'.
END.
RUN getFileAsMemptr (pdfStream, pImage, ?, INPUT-OUTPUT mImage, OUTPUT iFileSize).
/* build palette */
opiPalLength = GET-UNSIGNED-LONG(mImage, 47). /* some images have this field set to zero, which means the palette defaults to 2^n entries */
IF opiPalLength = 0 THEN CASE opiDepth:
    WHEN  1 THEN ASSIGN opiPalLength  = 2.
    WHEN  2 THEN ASSIGN opiPalLength  = 4.
    WHEN  4 THEN ASSIGN opiPalLength  = 16.
    WHEN  8 THEN ASSIGN opiPalLength  = 256.
END CASE.
/* 1 bit to 8 bits: indexed */
IF opiPalLength <> 0 THEN DO:
    ASSIGN
     opcColorSpace    = "/Indexed"
     opcAltColorSpace = "/DeviceRGB"
     opcPalFile       = cTmpImgName + ".pal".
    SET-SIZE(mPalette) = opiPalLength * 3.
    iOffset = 1.
    DO i = 0 TO opiPalLength - 1: /* 15 below = BMP_HEADER_SIZE + 1 */
        PUT-BYTE(mPalette, iOffset)     = GET-BYTE(mImage, 15 + iHeaderSize + i * 4 + 2).
        PUT-BYTE(mPalette, iOffset + 1) = GET-BYTE(mImage, 15 + iHeaderSize + i * 4 + 1).
        PUT-BYTE(mPalette, iOffset + 2) = GET-BYTE(mImage, 15 + iHeaderSize + i * 4).
        iOffset = iOffset + 3.
    END.
    OUTPUT TO VALUE(opcPalFile) BINARY NO-MAP NO-CONVERT NO-ECHO.
    EXPORT mPalette.
    OUTPUT CLOSE.
    SET-SIZE(mPalette) = 0.
END.
/* 16, 24 & 32 bits: [A]BGR */
ELSE IF opiDepth >= 16 THEN DO:
    opcColorSpace    = "/DeviceN".   /* Special colorspace. Conversion to /DeviceRGB is handled */
    opcAltColorSpace = "/DeviceRGB". /* via a Postscript function. */
    CASE opiDepth:
        WHEN 16 THEN ASSIGN
            opcDeviceNComponents  = "/C1/C2/C3/C4"
            opcFunctionParams     = "/Domain[0 1 0 1 0 1 0 1]/Range[0 1 0 1 0 1]"
            opcFunctionPostScript = "~{15 mul round cvi 8 bitshift 4 1 roll 15 mul round cvi 12 bitshift 4 1 roll 15 mul round cvi 4 1 roll 15 mul round cvi 4 bitshift or or or dup 31744 and -10 bitshift 31 div exch dup 992 and -5 bitshift 31 div exch 31 and 31 div~}". /* transforms 4 4 bits values into 3 5 bits RGB values */
        WHEN 24 THEN ASSIGN /* All the magic is in "3 1 roll exch" which invert the samples from BGR to RGB */
            opcDeviceNComponents  = "/B/G/R"
            opcFunctionParams     = "/Domain[0 1 0 1 0 1]/Range[0 1 0 1 0 1]"
            opcFunctionPostScript = "~{3 1 roll exch~}". /* swap BGR to RGB */
        WHEN 32 THEN ASSIGN
            opcDeviceNComponents  = "/A/B/G/R"
            opcFunctionParams     = "/Domain[0 1 0 1 0 1 0 1]/Range[0 1 0 1 0 1]"
            opcFunctionPostScript = "~{pop 3 1 roll exch~}". /* ignore alpha (for now) & swap BGR to RGB */
    END CASE.
END.

/* build RGB data */
CASE opiDepth:
    WHEN  1 THEN ASSIGN
        iScanLineSize = TRUNCATE(opiWidth / 8, 0) + IF opiWidth MODULO 8 = 0 THEN 0 ELSE 1.
    WHEN  2 THEN ASSIGN
        iScanLineSize = TRUNCATE(opiWidth / 4, 0) + IF opiWidth MODULO 4 = 0 THEN 0 ELSE 1.
    WHEN  4 THEN ASSIGN
        iScanLineSize = TRUNCATE(opiWidth / 2, 0) + IF opiWidth MODULO 2 = 0 THEN 0 ELSE 1.
    WHEN  8 THEN ASSIGN
        iScanLineSize = opiWidth.
    WHEN 16 THEN ASSIGN /* XBGR 1-5-5-5 bits, no palette */
        iScanLineSize = opiWidth * 2
        opiBitDepth   = 4.
    WHEN 24 THEN ASSIGN /* BGR; no palette */
        iScanLineSize = opiWidth * 3
        opiBitDepth   = 8.
    WHEN 32 THEN ASSIGN /* BGRA */
        iScanLineSize = opiWidth * 4
        opiBitDepth   = 8.
END CASE.
SET-SIZE(mChunk) = iScanLineSize.
/* pad the scan line to 4 */
IF iScanLineSize MODULO 4 <> 0 THEN
    iPadding = 4 - iScanLineSize MODULO 4.
iOffset = iPixelDataOffset + (iScanLineSize + iPadding) * (opiHeight - 1).

opcDataFile = cTmpImgName + ".rgb".
OUTPUT TO VALUE(opcDataFile) BINARY NO-MAP NO-CONVERT NO-ECHO.
DO i = 1 TO opiHeight:
    PUT-BYTES(mChunk, 1) = GET-BYTES(mImage, iOffset, iScanLineSize).
    EXPORT mChunk.
    iOffset = iOffset - iScanLineSize - iPadding.
END.
OUTPUT CLOSE.
SET-SIZE(mChunk) = 0.
iRetCode = compressFile(opcDataFile, opcDataFile + ".z").
IF iRetCode <> 0 THEN DO:
    SET-SIZE(mImage) = 0.
    RETURN ERROR 'BMP: zlib error: ' + STRING(iRetCode).
END.
OS-DELETE VALUE(cTmpImgName + ".rgb").
ASSIGN
 opcDataFile  = opcDataFile + ".z"
 opcFilter    = "/FlateDecode"
 opiPalLength = opiPalLength * 3.
