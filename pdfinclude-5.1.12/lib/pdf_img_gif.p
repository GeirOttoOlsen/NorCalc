/******************************************************************************

    Program:        lib/pdf_img_gif.p

    Written By:     Jean-Christophe Cardot
    Written On:     November 25, 2014

    Description:    Load and parse a GIF picture in order to make it usable
                    within a pdfStream file.

    Note:           Only 8 bit GIF files, non interlaced, are supported.
                    The algorithm used here transforms the LZW GIF compression into
                    pdfStream LZW compression (reverse bits order).
    
    --------------------- Revision History ------------------

    Date:     Author        Change Description

    11/25/14  JC Cardot     Creation

******************************************************************************/

{inc/pdf_func_bin.i "SHARED"}

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

DEFINE VARIABLE iAvailableBits        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBgColor              AS INTEGER   NO-UNDO.
DEFINE VARIABLE iBlockSize            AS INTEGER   NO-UNDO.
DEFINE VARIABLE iByte                 AS INTEGER   NO-UNDO.
DEFINE VARIABLE iCodeSize             AS INTEGER   INITIAL 9 NO-UNDO.
DEFINE VARIABLE iCurrentCode          AS INTEGER   INITIAL 256 NO-UNDO.
DEFINE VARIABLE iExp2                 AS INTEGER   EXTENT 14 INIT [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192] NO-UNDO.
DEFINE VARIABLE iFileSize             AS INTEGER   NO-UNDO.
DEFINE VARIABLE iGlobalColorTableSize AS INTEGER   NO-UNDO.
DEFINE VARIABLE iLZWCode              AS INTEGER   NO-UNDO.
DEFINE VARIABLE iNextBump             AS INTEGER   INITIAL 512 NO-UNDO.
DEFINE VARIABLE iOffset               AS INTEGER   NO-UNDO.
DEFINE VARIABLE iOffsetBlock          AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPacked               AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPendingBits          AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPendingInput         AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPendingOutput        AS INTEGER   NO-UNDO.
DEFINE VARIABLE iSeparator            AS INTEGER   NO-UNDO.
DEFINE VARIABLE lGlobalColorTable     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE mByte                 AS MEMPTR    NO-UNDO.
DEFINE VARIABLE mPalette              AS MEMPTR    NO-UNDO.

ASSIGN
 opcType = "GIF"
 opiWidth  = 256 * GET-BYTE(mImage, 8) + GET-BYTE(mImage, 7)
 opiHeight = 256 * GET-BYTE(mImage, 10) + GET-BYTE(mImage, 9).
iPacked = GET-BYTE(mImage, 11).
opiDepth  = bin_and(iPacked, 7) + 1.
lGlobalColorTable = bin_and(iPacked, 128) = 128.
IF lGlobalColorTable THEN
   iGlobalColorTableSize = 3 * EXP(2, opiDepth).
iBgColor = GET-BYTE(mImage, 12).

RUN getFileAsMemptr (pdfStream, pImage, ?, INPUT-OUTPUT mImage, OUTPUT iFileSize).

iOffset = 14.
IF lGlobalColorTable THEN DO:
    opiPalLength = iGlobalColorTableSize.
    SET-SIZE(mPalette) = iGlobalColorTableSize.
    PUT-BYTES(mPalette, 1) = GET-BYTES(mImage, iOffset, iGlobalColorTableSize).
    iOffset = iOffset + iGlobalColorTableSize.
    opcPalFile = cTmpImgName + ".pal".
    OUTPUT TO VALUE(opcPalFile) BINARY NO-MAP NO-CONVERT NO-ECHO.
    EXPORT mPalette.
    OUTPUT CLOSE.
    SET-SIZE(mPalette) = 0.
END.

DO WHILE TRUE:
    iSeparator = GET-BYTE(mImage, iOffset).
    iOffset = iOffset + 1.

    IF iSeparator = 33 /* 0x21 */ THEN DO: /* extension descriptor */
        iOffset = iOffset + 1. /* skip graphic control label */
        iBlockSize = GET-BYTE(mImage, iOffset).
        iOffset = iOffset + 1.
        iPacked = GET-BYTE(mImage, iOffset).
        IF iPacked MODULO 2 = 1 THEN
            opcTrns = STRING(GET-BYTE(mImage, iOffset + 3)) + " " + STRING(GET-BYTE(mImage, iOffset + 3)).
        DO WHILE iBlockSize <> 0:
            iOffset = iOffset + iBlockSize. /* skip block - for now */
            iBlockSize = GET-BYTE(mImage, iOffset).
            iOffset = iOffset + 1.
        END.
    END.
    ELSE IF iSeparator = 44 /* 0x2C */ THEN DO: /* image descriptor */

        iOffset = iOffset + 8. /* skip image header - for now */
        iPacked = GET-BYTE(mImage, iOffset).
        iOffset = iOffset + 1.
        IF bin_and(iPacked, 64) = 64 THEN DO:
            SET-SIZE(mImage) = 0.
            RETURN ERROR 'GIF: interlaced pictures are not supported'.
        END.
        iLZWCode = GET-BYTE(mImage, iOffset).
        iOffset = iOffset + 1.
        IF iLZWCode < 8 THEN DO:
            SET-SIZE(mImage) = 0.
            RETURN ERROR 'GIF: only 256 colors (8 bits depth) GIF pictures are supported'.
        END.
        opcDataFile = cTmpImgName + ".data".
        OUTPUT TO VALUE(opcDataFile) BINARY NO-MAP NO-CONVERT NO-ECHO.
        iBlockSize = GET-BYTE(mImage, iOffset).
        iOffset = iOffset + 1.
        SET-SIZE(mByte) = 1.
        readGIF:
        /* DO WHILE iBlockSize > 0: */
        DO WHILE TRUE:

            /* 1. read the next LZW code */

            /* read some data: */
            DO WHILE iAvailableBits < iCodeSize:
                /* read one byte of data */
                iByte = GET-BYTE(mImage, iOffset + iOffsetBlock).
                iOffsetBlock = iOffsetBlock + 1.
                /* manage GIF blocks */
                IF iOffsetBlock = iBlockSize THEN DO:
                    ASSIGN
                     iOffset      = iOffset + iBlockSize
                     iOffsetBlock = 0
                     iBlockSize   = GET-BYTE(mImage, iOffset)
                     iOffset      = iOffset + 1.
                    IF iBlockSize = 0 THEN
                        LEAVE readGIF.
                END.
                /* prepend the read byte to the pending input */
                /* iPendingInput = bin_or(iPendingInput, bin_lshift(iByte, iAvailableBits)). */
                iPendingInput = iByte * iExp2[iAvailableBits + 1] + iPendingInput.
                iAvailableBits = iAvailableBits + 8.
            END.

            /* get next code */
            /* iLZWCode = bin_and(iPendingInput, iExp2m1[iCodeSize]). */
            iLZWCode = iPendingInput MODULO iExp2[iCodeSize + 1].
            iPendingInput = TRUNCATE(iPendingInput / iExp2[iCodeSize + 1], 0).
            iAvailableBits = iAvailableBits - iCodeSize.
            IF iCurrentCode < 2048 THEN DO: /* for a true LZW decompress, use 4095; here we do not need to increment iCurrentCode anymore once we have reached the maximum iCodeSize (i.e. 12) */
                iCurrentCode = iCurrentCode + 1.
                IF iCurrentCode = iNextBump THEN ASSIGN
                    iNextBump = iNextBump * 2
                    iCodeSize = iCodeSize + 1.
            END.

            /* 2. now write it back, the way PDF needs it (reverse byte order as compared to GIF) */

            iPendingOutput = iPendingOutput * iExp2[iCodeSize + 1] + iLZWCode.
            iPendingBits = iPendingBits + iCodeSize.
            DO WHILE iPendingBits >= 8:
                iByte = TRUNCATE(iPendingOutput / iExp2[iPendingBits - 7 /* - 8 + 1*/], 0).
                PUT-BYTE(mByte, 1) = iByte.
                EXPORT(mByte).
                iPendingOutput = iPendingOutput - iByte * iExp2[iPendingBits - 7 /* - 8 + 1 */].
                iPendingBits = iPendingBits - 8.
            END.

            /* clear dictionary code: we start all over again */
            IF iLZWCode = 256 THEN ASSIGN
                iCurrentCode = 257
                iNextBump    = 512
                iCodeSize    = 9.
        END.
        /* flush anything left */
        DO WHILE iPendingBits > 0:
            iByte = IF iPendingBits > 7
                    THEN TRUNCATE(iPendingOutput / iExp2[iPendingBits - 7 /* - 8 + 1*/], 0)
                    ELSE iPendingOutput * iExp2[8 - iPendingBits + 1].
            PUT-BYTE(mByte, 1) = iByte.
            EXPORT(mByte).
            IF iPendingBits > 7 THEN
                iPendingOutput = iPendingOutput - iByte * iExp2[iPendingBits - 7 /* - 8 + 1 */].
            iPendingBits = iPendingBits - 8.
        END.
        SET-SIZE(mByte) = 0.
        OUTPUT CLOSE.
        ASSIGN
         opcColorSpace    = "/Indexed"
         opcAltColorSpace = "/DeviceRGB"
         opcFilter        = "/LZWDecode"
         opiBitDepth      = 8
         .
        SET-SIZE(mImage) = 0.
        RETURN.
    END.
    ELSE DO:
        SET-SIZE(mImage) = 0.
        RETURN ERROR 'GIF: unknown descriptor ' + QUOTER(iSeparator).
    END.
END.

