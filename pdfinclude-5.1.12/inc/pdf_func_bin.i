/******************************************************************************

  Program:      pdf_func_bin.i
  
  Written By:   Jean-Christophe Cardot
  Written On:   October 2014
  
  Description:  Binary & memptr related functions & procedures
  
  10/22/14  JC Cardot   Created

******************************************************************************/

{inc/pdf_func_error.i "{1}"} /* needed for getFileAsMemptr -> pdferror.i */

/* 14-MAY-2014 jcc: rewritten & merged with GetFileContent */
PROCEDURE getFileAsMemptr:  /* PRIVATE */
    DEFINE INPUT        PARAMETER pdfStream     AS CHARACTER   NO-UNDO.
    DEFINE INPUT        PARAMETER pcFile        AS CHARACTER   NO-UNDO.
    DEFINE INPUT        PARAMETER piBytesToRead AS INTEGER     NO-UNDO. /* if ? then the whole file will be read */
    DEFINE INPUT-OUTPUT PARAMETER pMemPtr       AS MEMPTR      NO-UNDO.
    DEFINE OUTPUT       PARAMETER piFileSize    AS INTEGER     NO-UNDO.

    SET-SIZE(pMemPtr) = 0.
    FILE-INFO:FILE-NAME = pcFile.
    IF FILE-INFO:FULL-PATHNAME = ? THEN
        {pdferror.i &msg="'Cannot find file ' + QUOTER(pcFile)" &return=YES &error=YES &returnmsg=YES}.
    piFileSize = IF piBytesToRead <> ? THEN piBytesToRead ELSE FILE-INFO:FILE-SIZE.
    SET-SIZE(pMemPtr) = piFileSize.
    INPUT FROM VALUE(FILE-INFO:FULL-PATHNAME) NO-ECHO BINARY NO-CONVERT NO-MAP NO-ECHO.
    IMPORT pMemPtr.
    INPUT CLOSE.
END. /* getFileAsMemptr */

/* 10-OCT-2013 jcc: rewrote string2hex */
FUNCTION string2hex RETURNS CHARACTER (cString AS CHARACTER):
    DEFINE VARIABLE c AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE m AS MEMPTR      NO-UNDO.
    SET-SIZE(m) = LENGTH(cString) + 1.
    PUT-STRING(m, 1) = cString.
    c = HEX-ENCODE(m).
    SET-SIZE(m) = 0. /* 17-JUN-2015 jcc: memory leak! */
    RETURN SUBSTRING(c, 1, LENGTH(c) - 2).
END FUNCTION.

/* 06-JUL-2011 jcc: added ; taken from Robert Ayris [rayris@comops.com.au] (see below) */
FUNCTION Hex2Int RETURNS INTEGER (vp_Hex AS CHARACTER): /* PRIVATE */
    DEFINE VARIABLE vl_Num AS INTEGER NO-UNDO. /* 24-OCT-2011 jcc: this and the function return type could be set to INT64 for OE>=10 */
    DEFINE VARIABLE vl_i   AS INTEGER NO-UNDO.
    DEFINE VARIABLE vl_pos AS INTEGER NO-UNDO.

    DO vl_i = 1 TO LENGTH(vp_Hex):
        vl_Pos = INDEX("0123456789ABCDEF", SUBSTRING(vp_Hex, vl_i, 1)).
        IF vl_Pos = 0 THEN DO:
            vl_Num = 0.
            LEAVE.
        END.
        IF vl_Pos LE 10 then
            vl_Num = vl_Num + INTEGER(SUBSTRING(vp_Hex, vl_i, 1)) * EXP(16, (LENGTH(vp_Hex) - vl_i)).
        ELSE
            vl_Num = vl_Num + (vl_Pos - 1) * EXP(16, (length(vp_Hex) - vl_i)).
    END.
    RETURN vl_Num.
END.

FUNCTION oct2int RETURNS INTEGER ( cOct AS CHARACTER ):
    RETURN 8 * 8 * INTEGER(SUBSTRING(cOct,1,1)) + 8 * INTEGER(SUBSTRING(cOct,2,1)) + INTEGER(SUBSTRING(cOct,3,1)).
END FUNCTION.
/* 06-JUL-2011 jcc: end */

/* 24-SEP-2013 jcc: create hexEncode & hexDecode to take advantage of the new builtins */
/* 17-JUN-2015 jcc: better re-create the new built-ins for Progress < 10 */
&IF INTEGER(ENTRY(1, PROVERSION, ".")) < 10 &THEN
FUNCTION HEX-ENCODE RETURNS CHARACTER ( ipm AS MEMPTR ):
    DEFINE VARIABLE c     AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iLoop AS INTEGER     NO-UNDO.
    DO iloop = 1 TO GET-SIZE(ipm):
        c = c + int2hexArray[GET-BYTE(ipm,iLoop) + 1].
    END.
    RETURN c.
END FUNCTION.

FUNCTION HEX-DECODE RETURNS MEMPTR ( ipc AS CHARACTER ):
    DEFINE VARIABLE iByte AS INTEGER   INITIAL 1 NO-UNDO.
    DEFINE VARIABLE iLen  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iLoop AS INTEGER   NO-UNDO.
    DEFINE VARIABLE opm   AS MEMPTR    NO-UNDO.
    iLen = LENGTH(ipc).
    SET-SIZE(opm) = INTEGER(iLen / 2).
    DO iLoop = 1 TO iLen BY 2:
        FIND FIRST HexArray WHERE HexArray.Hex-Val = SUBSTR(ipc, iLoop, 2).
        PUT-BYTE(opm, iByte) = HexArray.chr-val.
        iByte = iByte + 1.
    END.
    RETURN opm.
END FUNCTION.
&ENDIF
/* 24-SEP-2013 jcc: end */

/* 16-JUN-2015 jcc: GET-UNSIGNED-LONG for Progress < 10 */
&IF INTEGER(ENTRY(1, PROVERSION, ".")) < 10 &THEN
FUNCTION GET-UNSIGNED-LONG RETURNS INTEGER
    (pmMptr AS MEMPTR, piOffset AS INTEGER):
    IF GET-BYTE-ORDER(pmMptr) = BIG-ENDIAN THEN
        RETURN GET-UNSIGNED-SHORT(pmMptr, piOffset + 2) + GET-UNSIGNED-SHORT(pmMptr, piOffset) * 65536.
    ELSE
        RETURN GET-UNSIGNED-SHORT(pmMptr, piOffset) + GET-UNSIGNED-SHORT(pmMptr, piOffset + 2) * 65536.
END FUNCTION.
&ENDIF

/* 16-JUN-2015 jcc: PUT-UNSIGNED-LONG for Progress < 10 */
&IF INTEGER(ENTRY(1, PROVERSION, ".")) < 10 &THEN
FUNCTION PUT-UNSIGNED-LONG RETURNS LOGICAL
    (pmMptr AS MEMPTR, piOffset AS INTEGER, piLong AS INTEGER):    
    IF GET-BYTE-ORDER(pmMptr) = BIG-ENDIAN THEN DO:
        PUT-UNSIGNED-SHORT(pmMptr, piOffset + 2) = piLong MODULO 65536.
        PUT-UNSIGNED-SHORT(pmMptr, piOffset)     = INTEGER(TRUNCATE(piLong / 65536, 0)).
    END.
    ELSE DO: /* Only works for little endian platforms... */
        PUT-UNSIGNED-SHORT(pmMptr, piOffset)     = piLong MODULO 65536.
        PUT-UNSIGNED-SHORT(pmMptr, piOffset + 2) = INTEGER(TRUNCATE(piLong / 65536, 0)).
    END.
    RETURN TRUE.
END FUNCTION.
&ENDIF

FUNCTION GET-FWORD RETURNS INTEGER
    (pmMptr AS MEMPTR, piOffset AS INTEGER):
    DEFINE VARIABLE iResult AS INTEGER     NO-UNDO.
    iResult = GET-UNSIGNED-SHORT(pmMptr, piOffset).
    IF iResult > 32767 /* 0x7fff */ THEN iResult = iResult - 65536 /* 0x10000 */.
    RETURN iResult.
END FUNCTION.

FUNCTION GET-FIXED RETURNS DECIMAL
    (pmMptr AS MEMPTR, piOffset AS INTEGER):
    DEFINE VARIABLE iMantissa AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iFraction AS INTEGER     NO-UNDO.
    iMantissa = GET-FWORD(pmMptr, piOffset).
    iFraction = GET-UNSIGNED-SHORT(pmMptr, piOffset + 2).
    RETURN DECIMAL(STRING(iMantissa) + SESSION:NUMERIC-DECIMAL-POINT + STRING(iFraction)).
END FUNCTION.

/* 17-NOV-2014 jcc */
FUNCTION reverseByte RETURNS INTEGER (iByte AS INTEGER):
    DEFINE VARIABLE i    AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iRet AS INTEGER   INITIAL 0 NO-UNDO.

    DO i = 8 TO 1 BY -1:
        PUT-BITS(iRet, 9 - i, 1) = GET-BITS(ibyte, i, 1).
    END.
    RETURN iRet.
END FUNCTION.

FUNCTION bin_xor RETURNS INTEGER
        (INPUT iFirstOperand AS integer,
         INPUT iSecondOperand AS integer):

  DEFINE VARIABLE iFirstOpBit  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLoopCounter AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iSecondOpBit AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iXORedResult AS INTEGER   NO-UNDO INITIAL 0.

  DO iLoopCounter = 1 to 32:
    IF GET-BITS(iFirstOperand, iLoopCounter, 1) + GET-BITS(iSecondOperand, iLoopCounter, 1) EQ 1 THEN
      iXORedResult = iXORedResult + EXP(2, iLoopCounter - 1).
  END.

  RETURN iXORedResult.
END FUNCTION. /* bin_xor */

/* 19-FEB-2010 jcc: start */
FUNCTION bin_or RETURNS INTEGER
    (iFirstOperand AS INTEGER, iSecondOperand AS INTEGER):
    DEFINE VARIABLE iLoopCounter AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iORedResult  AS INTEGER   NO-UNDO.

    DO iLoopCounter = 1 to 32:
      IF GET-BITS(iFirstOperand, iLoopCounter, 1) + GET-BITS(iSecondOperand, iLoopCounter, 1) GE 1 THEN
        iORedResult = iORedResult + EXP(2, iLoopCounter - 1).
    END.
    RETURN iORedResult.
END FUNCTION.

FUNCTION bin_and RETURNS INTEGER
    (iFirstOperand AS INTEGER, iSecondOperand AS INTEGER):
    DEFINE VARIABLE iLoopCounter AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iANDedResult AS INTEGER   NO-UNDO.

    DO iLoopCounter = 1 to 32:
      IF GET-BITS(iFirstOperand, iLoopCounter, 1) + GET-BITS(iSecondOperand, iLoopCounter, 1) EQ 2 THEN
        iANDedResult = iANDedResult + EXP(2, iLoopCounter - 1).
    END.
    RETURN iANDedResult.
END FUNCTION.

FUNCTION bin_lshift RETURNS INTEGER
    (n AS INTEGER, s AS INTEGER ):
    n = n * EXP(2, s).
    RETURN n.
END FUNCTION.

FUNCTION bin_rshift RETURNS INTEGER
    (n AS INTEGER, s AS INTEGER ):
    n = TRUNC(n / EXP(2, s), 0).
    RETURN n.
END FUNCTION.
/* 19-FEB-2010 jcc: end */
