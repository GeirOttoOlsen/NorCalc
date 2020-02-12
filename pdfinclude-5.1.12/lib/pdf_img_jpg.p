/******************************************************************************

    Program:        lib/pdf_img_jpg.p

    Written By:     Jean-Christophe Cardot
    Written On:     November 25, 2014

    Description:    Load and parse a JPEG picture in order to make it usable
                    within a pdf file.

    Note:           Code moved here from pdf_inc.p
    
    --------------------- Revision History ------------------

    Date:     Author        Change Description

    11/25/14  JC Cardot     Creation

******************************************************************************/

{inc/pdf_func_bin.i "SHARED"}

/* The following defines are used to determine the JPEG Image Height and Width */
&GLOBAL-DEFINE M_SOF0  192 /* 0xC0 */      /* Start Of Frame N */
&GLOBAL-DEFINE M_SOF1  193 /* 0xC1 */      /* N indicates which compression process */
&GLOBAL-DEFINE M_SOF2  194 /* 0xC2 */      /* Only SOF0-SOF2 are now in common use */
&GLOBAL-DEFINE M_SOF3  195 /* 0xC3 */
&GLOBAL-DEFINE M_SOF5  197 /* 0xC5 */      /* NB: codes C4 and CC are NOT SOF markers */
&GLOBAL-DEFINE M_SOF6  198 /* 0xC6 */
&GLOBAL-DEFINE M_SOF7  199 /* 0xC7 */
&GLOBAL-DEFINE M_SOF9  201 /* 0xC9 */
&GLOBAL-DEFINE M_SOF10 202 /* 0xCA */
&GLOBAL-DEFINE M_SOF11 203 /* 0xCB */
&GLOBAL-DEFINE M_SOF13 205 /* 0xCD */
&GLOBAL-DEFINE M_SOF14 206 /* 0xCE */
&GLOBAL-DEFINE M_SOF15 207 /* 0xCF */
&GLOBAL-DEFINE M_SOI   216 /* 0xD8 */      /* Start Of Image (beginning of datastream) */
&GLOBAL-DEFINE M_EOI   217 /* 0xD9 */      /* End Of Image (end of datastream) */
&GLOBAL-DEFINE M_SOS   218 /* 0xDA */      /* Start Of Scan (begins compressed data) */
&GLOBAL-DEFINE M_APP0  224 /* 0xE0 */      /* Application-specific marker, type N */
&GLOBAL-DEFINE M_APP12 236 /* 0xEC */      /* (we don't bother to list all 16 APPn's) */
&GLOBAL-DEFINE M_APP14 238 /* 0xEE */      /* 13-NOV-2013 jcc: add Adobe APP14 support for CMYK files */
&GLOBAL-DEFINE M_COM   254 /* 0xFE */      /* Comment */
&GLOBAL-DEFINE M_MARK  255 /* 0xFF */      /* Marker */

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

DEFINE VARIABLE iApp14Transfo  AS INTEGER     INITIAL ? NO-UNDO.
DEFINE VARIABLE iFileSize      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iNumComponents AS INTEGER     INITIAL ? NO-UNDO.
DEFINE VARIABLE iPos           AS INTEGER     NO-UNDO.
DEFINE VARIABLE lSkip          AS LOGICAL     NO-UNDO.


RUN getFileAsMemptr (pdfStream, pImage, ?, INPUT-OUTPUT mImage, OUTPUT iFileSize).
iPos = 3.
blkMarkers:
DO WHILE TRUE:
/* loop through the markers until we find the one starting with 0xFF,0xC0
   which is the block containing the image information */
    DO WHILE TRUE: /* loop until we find the beginning of the next marker */
        IF   GET-BYTE(mImage, iPos) = {&M_Mark}
         AND GET-BYTE(mImage, iPos + 1) <> {&M_Mark} THEN
            LEAVE.
        iPos = iPos + 1.
        IF iPos >= iFileSize - 10 THEN DO:
            SET-SIZE(mImage) = 0.
            RETURN ERROR 'JPG: Unknown image type!'.
        END.
    END.

    ASSIGN
     lSkip = NO
     iPos  = iPos + 1.

    CASE GET-BYTE(mImage, iPos):
        WHEN {&M_SOF0} OR WHEN {&M_SOF1} OR WHEN {&M_SOF2} OR WHEN {&M_SOF3}
        OR WHEN {&M_SOF5} OR WHEN {&M_SOF6} OR WHEN {&M_SOF7} OR WHEN {&M_SOF9}
        OR WHEN {&M_SOF10} OR WHEN {&M_SOF11} OR WHEN {&M_SOF13}
        OR WHEN {&M_SOF14} OR WHEN {&M_SOF15} THEN DO:
            /* we have found the right block, let's extract the values */
            ASSIGN
             opcType        = "JPG"
             opiHeight      = GET-BYTE(mImage, iPos + 4) * 256 + GET-BYTE(mImage, iPos + 5)
             opiWidth       = GET-BYTE(mImage, iPos + 6) * 256 + GET-BYTE(mImage, iPos + 7)
             iNumComponents = GET-BYTE(mImage, iPos + 8)
             opiDepth       = iNumComponents * 8
             opcDataFile    = pImage
             opcFilter      = "/DCTDecode"
             opiBitDepth    = 8.
            /* 13-NOV-2013 jcc: add support for CMYK & Grayscale jpeg */
            CASE iNumComponents:
                WHEN 4 THEN opcColorSpace = "/DeviceCMYK".
                WHEN 1 THEN opcColorSpace = "/DeviceGray".
                OTHERWISE opcColorSpace = "/DeviceRGB".
            END CASE.
            LEAVE blkMarkers.
            /* lSkip = YES. */
        END.
        WHEN {&M_APP14} THEN DO: /* 13-NOV-2013 jcc: add support for Adobe's APP14 segment */
            IF GET-BYTES(mImage, iPos + 3, 5) = "Adobe" THEN
                iApp14Transfo = GET-BYTE(mImage, iPos + 14). /* "transformation" flag */
            lSkip = YES.
        END.
        WHEN {&M_SOS} OR WHEN {&M_EOI} THEN
            LEAVE blkMarkers.
        OTHERWISE /* keep looking */
            lSkip = YES.
    END CASE.
    IF lSkip THEN DO:
        iPos = iPos + 256 * GET-BYTE(mImage, iPos + 1) + GET-BYTE(mImage, iPos + 2).
        IF iPos >= iFileSize - 10 THEN DO:
            SET-SIZE(mImage) = 0.
            RETURN ERROR 'JPG: Unknown image type!'.
        END.
    END.
END. /* blkMarkers: DO WHILE TRUE */

/* 13-NOV-2013 jcc: when there was an app14 segment, then give the right /Decode array in
   order to invert back the ink values, as Adobe CMYK files have their ink values inverted,
   default /Decode being [0 1 0 1 0 1 0 1] */
IF iApp14Transfo <> ? THEN CASE iApp14Transfo:
    WHEN 0 OR /* iNumComponents = 3 => RGB, iNumComponents = 4 => CMYK */
    WHEN 2 THEN /* YCCK */
        opcParams = IF iNumComponents = 4 THEN "/Decode[1 0 1 0 1 0 1 0]" ELSE "".
    WHEN 1 THEN . /* YCbCr, exported as RGB: we should not need to do anything there */
END CASE.
