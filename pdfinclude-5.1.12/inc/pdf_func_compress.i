/******************************************************************************

  Program:      pdf_func_compress.i
  
  Written By:   Jean-Christophe Cardot
  Written On:   October 2014
  
  Description:  Compression routines
  
  Note:         Moved here from pdf_inc.p
  
  --------------------- Revision History ------------------

  Date:     Author      Change Description

  11/25/14  JC Cardot   Created

  10/16/15  JC Cardot   added "NO-MAP NO-ECHO" to the INPUT & OUTPUT statements

******************************************************************************/

DEFINE STREAM S_compress.

/* ------------ Start of External Zlib procedure definitions --------------- */

/* Return codes for the compression/decompression functions. Negative values are errors, positive values are used for special but normal events. */
&GLOBAL-DEFINE Z_OK              0
&GLOBAL-DEFINE Z_STREAM_END      1
&GLOBAL-DEFINE Z_NEED_DICT       2
&GLOBAL-DEFINE Z_ERRNO         (-1)
&GLOBAL-DEFINE Z_STREAM_ERROR  (-2)
&GLOBAL-DEFINE Z_DATA_ERROR    (-3)
&GLOBAL-DEFINE Z_MEM_ERROR     (-4)
&GLOBAL-DEFINE Z_BUF_ERROR     (-5)
&GLOBAL-DEFINE Z_VERSION_ERROR (-6)

/* compress returns Z_OK if success, Z_MEM_ERROR if there was not enough memory,
   Z_BUF_ERROR if there was not enough room in the output buffer. */
PROCEDURE compress EXTERNAL "{&zlib}" CDECL PERSISTENT: /* PRIVATE */
    DEFINE INPUT        PARAMETER pDestBuf    AS MEMPTR NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER iDestSize   AS LONG NO-UNDO.
    DEFINE INPUT        PARAMETER pSourceBuf  AS MEMPTR NO-UNDO.
    DEFINE INPUT        PARAMETER iSourceSize AS LONG NO-UNDO.
    DEFINE RETURN PARAMETER iretcode AS LONG NO-UNDO.
END PROCEDURE.

/* uncompress returns Z_OK if success, Z_MEM_ERROR if there was not enough memory,
   Z_BUF_ERROR if there was not enough room in the output buffer, or Z_DATA_ERROR
   if the input data was corrupted or incomplete. In the case where there is not
   enough room, uncompress() will fill the output buffer with the uncompressed
   data up to that point. */
PROCEDURE uncompress EXTERNAL "{&zlib}" CDECL PERSISTENT: /* PRIVATE */
    DEFINE INPUT        PARAMETER pDestBuf    AS MEMPTR NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER iDestSize   AS LONG NO-UNDO.
    DEFINE INPUT        PARAMETER pSourceBuf  AS MEMPTR NO-UNDO.
    DEFINE INPUT        PARAMETER iSourceSize AS LONG NO-UNDO.
    DEFINE RETURN PARAMETER iretcode AS LONG NO-UNDO.
END PROCEDURE.

PROCEDURE ReleaseZlib: /* PRIVATE */
  RELEASE EXTERNAL "{&zlib}".
END.
/* ---------------- End of External Zlib procedure definitions ------------- */

/* -------------- Functions for zlib handling in Progress ----------------- */
FUNCTION CompressBuffer RETURNS INTEGER
         (INPUT        InputBuffer  AS MEMPTR,
          INPUT-OUTPUT OutputBuffer AS MEMPTR,
          OUTPUT       OutputSize   AS INTEGER) :
  
  /* Compress a piece of memory and return a pointer to the compressed data,
     in case of failure the size of compressed data = -1
  */

  DEFINE VARIABLE InputSize  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRetCode   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE TempBuffer AS MEMPTR    NO-UNDO.

  InputSize  = GET-SIZE(InputBuffer).
  OutputSize = (InputSize * 1.01) + 12.
  SET-SIZE(TempBuffer) = OutputSize.

  RUN compress(TempBuffer, 
               INPUT-OUTPUT OutputSize, 
               InputBuffer, 
               InputSize, 
               OUTPUT iRetCode) .
  
  IF iRetCode = {&Z_OK} THEN DO:
    SET-SIZE(OutputBuffer) = OutputSize.
    OutputBuffer = GET-BYTES(TempBuffer, 1, OutputSize).
  END.
  ELSE 
     OutputSize = -1.

  SET-SIZE(TempBuffer) = 0.

  RETURN iRetCode.

END FUNCTION. /* Compress Buffer */

FUNCTION DeCompressBuffer RETURNS INTEGER
        (INPUT  InputBuffer  AS MEMPTR,
         OUTPUT OutputBuffer AS MEMPTR,
         OUTPUT OutputSize   AS INTEGER):

  /* DeCompress a piece of memory and return a pointer to the decompressed data,
     in case of failure the size of decompressed data = -1
  */

  DEFINE VARIABLE InputSize  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRetCode   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE TempBuffer AS MEMPTR    NO-UNDO.

  InputSize  = GET-SIZE(InputBuffer).
  OutputSize = InputSize * 100.
  iRetCode = {&Z_BUF_ERROR}.
  DO WHILE iRetCode = {&Z_BUF_ERROR}:
      SET-SIZE(TempBuffer) = OutputSize.
      &IF DEFINED(debug) &THEN RUN debugLog("Decompress a buffer of " + STRING(InputSize) + " bytes / prepare output buffer of " + STRING(OutputSize) + " bytes"). &ENDIF

      RUN uncompress 
          (TempBuffer, 
           INPUT-OUTPUT OutputSize, 
           InputBuffer, 
           InputSize,
           OUTPUT iRetCode).
      &IF DEFINED(debug) &THEN RUN debugLog("zlib returned: " + STRING(OutputSize) + " bytes with return code " + STRING(iRetCode)). &ENDIF
      
      IF iRetCode = {&Z_BUF_ERROR} THEN DO: /* not enough space in the output buffer: try again with a bigger buffer */
          SET-SIZE(TempBuffer) = 0.
          OutputSize = OutputSize + InputSize * 100.
          IF OutputSize > InputSize * 1000 THEN LEAVE.
      END.
  END.

  IF iRetCode = {&Z_OK} THEN DO:
    SET-SIZE(OutputBuffer) = OutputSize.
    OutputBuffer = GET-BYTES(TempBuffer, 1, OutputSize).
  END.
  ELSE 
     OutputSize = -1.
  SET-SIZE(TempBuffer) = 0.

  RETURN iRetCode.
END FUNCTION. /* DeCompress Buffer */

/* 06-FEB-2014 jcc: added */
FUNCTION CompressFile2Buffer RETURNS INTEGER
         (INPUT        cInputFile   AS CHARACTER,
          INPUT-OUTPUT OutputBuffer AS MEMPTR,
          OUTPUT       OutputSize   AS INTEGER):

    DEFINE VARIABLE iRetCode    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE pFileBuf    AS MEMPTR    NO-UNDO.

    FILE-INFO:FILE-NAME = cInputFile.
    SET-SIZE(pFileBuf) = FILE-INFO:FILE-SIZE.

    INPUT STREAM S_compress FROM VALUE(cInputFile) BINARY NO-CONVERT NO-MAP NO-ECHO.
    IMPORT STREAM S_compress pFileBuf.
    INPUT STREAM S_compress CLOSE.
    
    iRetCode = compressbuffer(pFileBuf,
                              INPUT-OUTPUT OutputBuffer,
                              OUTPUT OutputSize).

    SET-SIZE(pFileBuf) = 0.

    RETURN iRetCode.
END FUNCTION. /* Compress File to Buffer */

FUNCTION compressfile RETURNS INTEGER
         (INPUT cInputFile  AS CHARACTER,
          INPUT cOutputFile AS CHARACTER):

    DEFINE VARIABLE iFileSize   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iRetCode    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iTargetSize AS INTEGER   NO-UNDO.
    DEFINE VARIABLE pFileBuf    AS MEMPTR    NO-UNDO.
    DEFINE VARIABLE pTargetBuf  AS MEMPTR    NO-UNDO.

    FILE-INFO:FILE-NAME = cInputFile.
    iFileSize = FILE-INFO:FILE-SIZE.

    SET-SIZE(pFileBuf) = iFileSize.

    INPUT STREAM S_compress FROM  VALUE(cInputFile) BINARY NO-CONVERT NO-MAP NO-ECHO.
    IMPORT STREAM S_compress pFileBuf.
    INPUT STREAM S_compress CLOSE.
    
    iRetCode = compressbuffer(pFileBuf,
                              INPUT-OUTPUT pTargetBuf,
                              OUTPUT iTargetSize).

    IF iRetCode = {&Z_OK} AND iTargetSize > 0 THEN
    DO:
      OUTPUT STREAM S_compress TO VALUE(cOutputFile) BINARY NO-CONVERT NO-MAP NO-ECHO.
      EXPORT STREAM S_compress pTargetBuf.
      OUTPUT STREAM S_compress CLOSE.
    END.
    
    SET-SIZE(pFileBuf) = 0.
    SET-SIZE(pTargetBuf) = 0.

    RETURN iRetCode.
END FUNCTION. /* Compress File */

FUNCTION decompressfile RETURNS INTEGER
         (INPUT cInputFile  AS CHARACTER,
          INPUT cOutputFile AS CHARACTER):

    DEFINE VARIABLE iFileSize   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iRetCode    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iTargetSize AS INTEGER   NO-UNDO.
    DEFINE VARIABLE pFileBuf    AS MEMPTR    NO-UNDO.
    DEFINE VARIABLE pTargetBuf  AS MEMPTR    NO-UNDO.

    FILE-INFO:FILE-NAME = cInputFile.
    iFileSize = FILE-INFO:FILE-SIZE.
    
    SET-SIZE(pFileBuf) = iFileSize.

    INPUT STREAM S_compress FROM VALUE(cInputFile) BINARY NO-CONVERT NO-MAP NO-ECHO.
    IMPORT STREAM S_compress pFileBuf.
    INPUT STREAM S_compress CLOSE.

    iRetCode = decompressbuffer(pFileBuf,
                                OUTPUT pTargetBuf,
                                OUTPUT iTargetSize).
    IF iRetCode = {&Z_OK} AND iTargetSize > 0 THEN DO:
      OUTPUT STREAM S_compress TO VALUE(cOutputFile) BINARY NO-CONVERT NO-MAP NO-ECHO.
      EXPORT STREAM S_compress pTargetBuf.
      OUTPUT STREAM S_compress CLOSE.
    END.

    SET-SIZE(pFileBuf) = 0.
    SET-SIZE(pTargetBuf) = 0.

    RETURN iRetCode.
END FUNCTION. /* Decompress File */

/* ----------------- End of Zlib Function Definitons ---------------------- */
