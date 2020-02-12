/******************************************************************************

    Program:        pdfencrypt.p

    Written By:     JC Cardot - Snowwolf-software.com
    Written On:     October 10, 2013

    Description:    Contains function and variable definitions for
                    PDF encryption

    Note:           This was copied from pdf_inc.p

    --------------------- Revision History ------------------

    Date:     Author        Change Description

    10/10/13  JC Cardot     Initial Copy from pdf_inc.p
    
    05/14/14  JC Cardot     Better initialization of some pointers

    03/26/15  JC Cardot     Move pdf_pre.i & pdf_func.i to inc

******************************************************************************/

DEFINE TEMP-TABLE hexarray NO-UNDO
   FIELD hex-val   AS CHARACTER
   FIELD chr-val   AS INTEGER
INDEX hex-idx AS PRIMARY
      hex-val
INDEX chr-idx 
      chr-val.

DEFINE INPUT PARAMETER iphPdfInc AS HANDLE   NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR hexarray.

{inc/pdf_pre.i}
{inc/pdf_func.i iphPdfInc}

DEFINE SHARED VARIABLE int2hexArray AS CHARACTER   EXTENT 256 NO-UNDO.

DEFINE VARIABLE mOriginalKey  AS MEMPTR NO-UNDO.

DEFINE VARIABLE m_O          AS MEMPTR      NO-UNDO.
DEFINE VARIABLE vowner-str   AS MEMPTR      NO-UNDO.
DEFINE VARIABLE vrc4-128     AS MEMPTR      NO-UNDO.
DEFINE VARIABLE vrc4-key     AS MEMPTR      NO-UNDO.
DEFINE VARIABLE vuser-str    AS MEMPTR      NO-UNDO.

/* -------- Start of PDFEncryptLib External procedure definitions -------- */

FUNCTION PDFendecrypt RETURNS LOGICAL
        (INPUT BufferPtr    AS MEMPTR,
         INPUT PasswordPtr  AS MEMPTR):
  RUN endecrypt
              (INPUT GET-POINTER-VALUE(BufferPtr),
               INPUT GET-SIZE(BufferPtr),
               INPUT GET-POINTER-VALUE(PasswordPtr),
               INPUT GET-SIZE(PasswordPtr) ) .

  RETURN TRUE.
END FUNCTION. /* PDFendecrypt */

PROCEDURE endecrypt EXTERNAL "{&pdfencryptlib}" CDECL PERSISTENT:
    DEFINE INPUT        PARAMETER pBufferPtr    AS LONG   NO-UNDO.
    DEFINE INPUT        PARAMETER pBufferLen    AS LONG   NO-UNDO.
    DEFINE INPUT        PARAMETER pPasswordKey  AS LONG   NO-UNDO.
    DEFINE INPUT        PARAMETER pPasswordLen  AS LONG   NO-UNDO.
END PROCEDURE.

PROCEDURE ReleasePDFencryptlib:  /* PRIVATE */
  RELEASE EXTERNAL "{&pdfencryptlib}".
END.

/* ---------- End of PDFEncryptLib External procedure definitions --------- */

PROCEDURE md5Hash:
  DEFINE INPUT  PARAMETER pUniqueID AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pHashMem  AS MEMPTR NO-UNDO.
  /* 24-SEP-2013 jcc: return a memptr instead, to enable the easy use of MD5-DIGEST when available */
  /* DEFINE OUTPUT PARAMETER pHash     AS CHARACTER NO-UNDO. */
  DEFINE OUTPUT PARAMETER pHash     AS MEMPTR NO-UNDO.

  /* 24-SEP-2013 jcc: make use of the new MD5-DIGEST function if available */
  &IF INTEGER(ENTRY(1, PROVERSION, ".")) >= 10 &THEN

    pHash = MD5-DIGEST(pHashMem).

  &ELSE

    DEFINE VARIABLE cHash    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cMD5File AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cTxtFile AS CHARACTER   NO-UNDO.

    ASSIGN cTxtFile = SESSION:TEMP-DIR + pUniqueID + "-O.txt"
           cMD5File = SESSION:TEMP-DIR + pUniqueID + "-O.md5".

    OUTPUT TO VALUE(cTxtFile).
    EXPORT pHashMem.
    OUTPUT CLOSE.

    IF OPSYS = "UNIX" THEN DO:
        INPUT THROUGH VALUE("{&MD5LIB} " + cTxtFile) NO-ECHO.
        IMPORT cHash.
        INPUT CLOSE.
    END.

    ELSE DO:
        OS-COMMAND SILENT VALUE("{&MD5LIB} " + cTxtFile + " > " + cMD5File) NO-ECHO.
        INPUT FROM VALUE(cMD5file) NO-ECHO NO-CONVERT.
        IMPORT cHash.
        INPUT CLOSE.
        OS-DELETE VALUE(cMD5File).
    END.

    OS-DELETE VALUE(cTxtFile).

    /* 24-SEP-2013 jcc: transform cHash into its memptr representation */
    pHash = HEX-DECODE(cHash).

  &ENDIF

END. /* md5Hash */

PROCEDURE DetermineOwnerKey:
  DEFINE INPUT        PARAMETER pdfStream       AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER p_UniqueID      AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER p_UserPassword  AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER p_OwnerPassword AS CHARACTER NO-UNDO.

  DEFINE VARIABLE L_Loop    AS INTEGER NO-UNDO.
  DEFINE VARIABLE L_Loop2   AS INTEGER NO-UNDO.
  DEFINE VARIABLE L_Length  AS INTEGER NO-UNDO.

  DEFINE VARIABLE L_md5hash   AS MEMPTR NO-UNDO.

  IF p_OwnerPassword = "" THEN
      p_OwnerPassword = p_UserPassword. /* PDF spec: If there is no owner password, use the user password instead. */

  RUN InitString (pdfStream, p_OwnerPassword, INPUT-OUTPUT vowner-str).
  RUN InitString (pdfStream, p_UserPassword, INPUT-OUTPUT vuser-str).

  /* Use Algorithm 3.3 from the Adobe 1.4 Spec */

  /* Step 1 - Pad the Owner String to 32-bytes */
  IF LENGTH(p_OwnerPassword) < 32 THEN
    RUN PadString (LENGTH(p_OwnerPassword),
                   INPUT-OUTPUT vOwner-Str).

  /* Step 2 - pass the padded Owner Password String to md5 Encryption hash */
  RUN md5Hash(INPUT  p_UniqueID,
              INPUT  vOwner-str,
              OUTPUT L_md5hash).

  L_Length = IF pdf_get_parameter(pdfStream,"EncryptKey") = "40" THEN 5 ELSE 16.
  /* Step 3 - only for Rev 3 encryption - do md5 hash another 50 times*/
  IF L_Length = 16 THEN DO:
    DO l_Loop = 1 TO 50:
      RUN md5Hash(INPUT  p_UniqueID,
                  INPUT  L_md5hash,
                  OUTPUT L_md5hash).
    END. /* Loop 50 */
  END. /* 128 Bit encryption */

  /* Step 4 - create an RC4 Encryption key using the first n bytes of the
              MD5 hash obtained in Step 2. */
  SET-SIZE(vrc4-key) = 0.
  SET-SIZE(vrc4-key) = L_Length.
  PUT-BYTES(vrc4-key, 1) = GET-BYTES(L_md5hash, 1, L_Length).

  /* Step 5 - pad or truncate the User Password */
  IF LENGTH(p_UserPassword) < 32 THEN
    RUN PadString (LENGTH(p_UserPassword),
                   INPUT-OUTPUT vuser-str).

  /* Step 6 - Encrypt the result of Step 5 using RC4 Key obtained in Step 4 */
  PDFendecrypt(vuser-str, vrc4-key).

  /* Step 7 - Perform this 19 times */
  IF l_Length = 16 THEN DO:  /* Len = 16 equals 128 Bit encryption */
    DO L_Loop = 1 TO 19:
      SET-SIZE(vrc4-128) = 16.
 
      DO l_Loop2 = 1 TO 16:
        PUT-BYTE(vrc4-128,l_Loop2) = bin_xor(GET-BYTE(vrc4-key,L_Loop2), l_Loop).
      END.

      PDFendecrypt(vuser-str, vrc4-128).

      SET-SIZE(vrc4-128) = 0.
    END.
  END.

  SET-SIZE(m_O) = GET-SIZE(vuser-str).
  PUT-BYTES(m_O, 1) = vuser-str.

  p_OwnerPassword = HEX-ENCODE(m_O).

END. /* DetermineOwnerKey */

PROCEDURE DetermineUserKey:
  DEFINE INPUT        PARAMETER pdfStream       AS CHARACTER   NO-UNDO.
  DEFINE INPUT        PARAMETER p_UniqueID      AS CHARACTER   NO-UNDO.
  DEFINE INPUT        PARAMETER p_ID            AS CHARACTER   NO-UNDO.
  DEFINE INPUT        PARAMETER p_AllowPrint    AS INTEGER     NO-UNDO.
  DEFINE INPUT        PARAMETER p_AllowCopy     AS INTEGER     NO-UNDO.
  DEFINE INPUT        PARAMETER p_AllowModify   AS INTEGER     NO-UNDO.
  DEFINE INPUT        PARAMETER p_AllowAnnots   AS INTEGER     NO-UNDO.
  DEFINE INPUT        PARAMETER p_AllowForms    AS INTEGER     NO-UNDO.
  DEFINE INPUT        PARAMETER p_AllowExtract  AS INTEGER     NO-UNDO.
  DEFINE INPUT        PARAMETER p_AllowAssembly AS INTEGER     NO-UNDO.
  /* DEFINE OUTPUT       PARAMETER p_OrigKey       AS MEMPTR      NO-UNDO. */
  DEFINE INPUT-OUTPUT PARAMETER p_UserPassword  AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT       PARAMETER p_IntID         AS INTEGER     NO-UNDO.

  DEFINE VARIABLE vLast-hash  AS MEMPTR NO-UNDO.

  DEFINE VARIABLE L_Byte   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE L_Length AS INTEGER   NO-UNDO.
  DEFINE VARIABLE L_Loop   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE L_Loop2  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE vP-str   AS INTEGER   NO-UNDO.

  DEFINE VARIABLE vPad-mem  AS MEMPTR  NO-UNDO.
  DEFINE VARIABLE vP-mem    AS MEMPTR  NO-UNDO.
  DEFINE VARIABLE vID-mem   AS MEMPTR  NO-UNDO.
  DEFINE VARIABLE vTot-mem  AS MEMPTR  NO-UNDO.
  DEFINE VARIABLE v128-mem  AS MEMPTR  NO-UNDO.


  L_Length = IF pdf_get_parameter(pdfStream,"EncryptKey") = "40" THEN 5 ELSE /* "128" */ 16.

  /* Step 1 - Create an Encryption Key based on Algorithm 3.2 */

  /* Step 1A - Pad the User Password to 32 bytes */
  RUN InitString (pdfStream, p_UserPassword, INPUT-OUTPUT vuser-str).
  IF LENGTH(p_UserPassword) < 32 THEN
    RUN PadString (LENGTH(p_UserPassword),
                   INPUT-OUTPUT vUser-Str).

  /* Step 1B - Pass concatenation of:
                 - Padded User Password 
                 - the value of the /O value
                 - the value of the /P entry 
                 - the first element of the /ID entry
               to the md5 hash function */

  /* Set ID Memptr from /ID Hex string passed */
  vID-mem = HEX-DECODE(p_ID).

  /* If non Rev 3 (or 128 Bit Encryption) then the following must be 1 since 
     they are not valid in Rev 2 Encryption */
  IF L_Length = 5 THEN ASSIGN
      p_AllowForms    = 1
      p_AllowExtract  = 1
      p_AllowAssembly = 1.

  /* 20-SEP-2013 jcc: initialize vP-Str to -1 to that ABL will not complain when I set the 32th bit */
  vP-Str = -1.
  PUT-BITS(vP-Str,1,1)   = 0.   /* Reserved */
  PUT-BITS(vP-Str,2,1)   = 0.   /* Reserved */
  PUT-BITS(vP-Str,3,1)   = p_AllowPrint.      /* Print the Document */
  PUT-BITS(vP-Str,4,1)   = p_AllowModify.     /* Modify the Contents */
  PUT-BITS(vP-Str,5,1)   = p_AllowCopy.       /* Copy Graphics or Text */
  PUT-BITS(vP-Str,6,1)   = p_AllowAnnots.     /* Add or modify Annotations */
  PUT-BITS(vP-Str,7,1)   = 1.                 /* Reserved - must be 1 */
  PUT-BITS(vP-Str,8,1)   = 1.                 /* Reserved - must be 1 */
  PUT-BITS(vP-Str,9,1)   = p_AllowForms.      /* Fill in existing Form Fields */
  PUT-BITS(vP-Str,10,1)  = p_AllowExtract.    /* Extract text and Graphics - Rev 3 */
  PUT-BITS(vP-Str,11,1)  = p_AllowAssembly.   /* Assemble the document - Rev 3 */
  PUT-BITS(vP-Str,12,1)  = 1.   /* Print the doc - Rev 3 */
  PUT-BITS(vP-Str,13,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,14,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,15,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,16,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,17,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,18,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,19,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,20,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,21,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,22,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,23,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,24,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,25,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,26,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,27,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,28,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,29,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,30,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,31,1)  = 1.   /* Reserved */
  PUT-BITS(vP-Str,32,1)  = 1.   /* Reserved */

  /* Return the value so we can set it in the Encryption Dictionary */
  p_IntID = Vp-Str.

  SET-SIZE(vP-Mem) = 4.
  PUT-BYTE(vP-Mem,1) = GET-BITS(vP-str,1,8).
  PUT-BYTE(vP-Mem,2) = GET-BITS(vP-str,9,8).
  PUT-BYTE(vP-Mem,3) = GET-BITS(vP-str,17,8).
  PUT-BYTE(vP-Mem,4) = GET-BITS(vP-str,25,8).

  /* Concatenate the user pwd, /O, /P & /ID */
  SET-SIZE(vTot-mem) = GET-SIZE(vuser-str) + GET-SIZE(m_O)
                     + GET-SIZE(vP-mem) + GET-SIZE(vID-mem).
  /* Add Padded User Password string to Total String */
  /*   21-SEP-2013 jcc: use PUT-BYTES instead of strange uses of ASC(CHR()) and Hexarray */
  PUT-BYTES(vTot-mem, 1) = vuser-str.
  /* Add /O entry to Total String */
  PUT-BYTES(vTot-mem, GET-SIZE(vuser-str) + 1) = m_O.
  /* add the /P entry to Total String - low-order byte first */
  PUT-BYTES(vTot-mem, GET-SIZE(vuser-str) + GET-SIZE(m_O) + 1) = vP-mem.
  /* Add the /ID entry to Total String */
  PUT-BYTES(vTot-mem, GET-SIZE(vuser-str) + GET-SIZE(m_O) + GET-SIZE(vP-mem) + 1) = vID-mem.

  /* Step 1C - Hash the concatenated value */
  RUN md5Hash(INPUT  p_UniqueID,
              INPUT  vTot-mem,
              OUTPUT vLast-hash).

  /* Step 1D - Now perform the hash 50 more times (for 128 bits key only) */
  IF L_Length = 16 THEN DO l_Loop = 1 TO 50:
    RUN md5Hash(INPUT  p_UniqueID,
                INPUT  vLast-hash,
                OUTPUT vLast-hash).
  END. /* Loop 50 */

  /* Step 1E - Set the encryption Key to the first n (5 or 16) bytes of the final md5hash */
  SET-SIZE(vrc4-key) = 0.
  SET-SIZE(vrc4-key) = L_Length. /* 5 or 16 */
  PUT-BYTES(vrc4-key, 1) = GET-BYTES(vLast-hash, 1, L_Length).

  /* Now that we've got the original encryption key - store it for future use */
  /* SET-SIZE(p_OrigKey) = 0. */
  /* SET-SIZE(p_OrigKey) = L_Length. */
  /* PUT-BYTES(p_OrigKey, 1) = vrc4-key. */
  SET-SIZE(mOriginalKey) = 0.
  SET-SIZE(mOriginalKey) = L_Length.
  PUT-BYTES(mOriginalKey, 1) = vrc4-key.

  /* Step 2 0f Algorithm 3.5 */
  RUN PadString (0,
                 INPUT-OUTPUT vPad-mem).

  IF L_Length = 5 THEN DO: /* 40 bits */
      /* Plus run the encryption routine on the padded User password with this key */
      PDFendecrypt(vPad-mem, vrc4-key).
      
      /* But since we are outputting in hex we need to convert back to hex values */
      p_UserPassword = HEX-ENCODE(vPad-mem).
  END.
  ELSE DO: /* 16 -> 128 bits */
      SET-SIZE(v128-mem) = 48.
      PUT-BYTES(v128-mem, 1) = vPad-mem.
      PUT-BYTES(v128-mem, 33) = vID-mem.

      /* Step 3 0f Algorithm 3.5 */
      /* Now perform the Hash on the total bytes */
      RUN md5Hash(INPUT  p_UniqueID,
                  INPUT  v128-mem,
                  OUTPUT vLast-hash).

      /* Step 4 0f Algorithm 3.5 */
      /* run the encryption routine on the Hash Result using the Original key */
      /* PDFendecrypt(vLast-hash, p_OrigKey). */
      PDFendecrypt(vLast-hash, mOriginalKey).

      /* Step 5 0f Algorithm 3.5 */
      SET-SIZE(vrc4-128) = 0.
      DO L_Loop = 1 TO 19:
        SET-SIZE(vrc4-128) = 16.

        DO l_Loop2 = 1 TO 16:
          /* PUT-BYTE(vrc4-128,l_Loop2) = bin_xor(GET-BYTE(p_OrigKey,L_Loop2), L_Loop). */
          PUT-BYTE(vrc4-128,l_Loop2) = bin_xor(GET-BYTE(mOriginalKey,L_Loop2), L_Loop).
        END.

        /* PDFendecrypt(vrc4-key, vrc4-128). */
        PDFendecrypt(vLast-hash, vrc4-128).

        SET-SIZE(vrc4-128) = 0.
      END.

      /* Step 6 0f Algorithm 3.5 */
      /* Append 16 Bytes of arbitrary padding */
      /* But since we are outputting in hex we need to convert back to hex values */
      p_UserPassword = HEX-ENCODE(vLast-hash).

      /* Append 16 arbitrary bytes */
      DO L_Loop = 1 TO 16:
          P_UserPassWord = p_UserPassword + int2hexArray[RANDOM(1,256)].
      END.
  END.

  SET-SIZE(vrc4-key) = 0.
  SET-SIZE(vLast-hash) = 0.

END. /* DetermineUserKey */

PROCEDURE InitString:
  DEFINE INPUT        PARAMETER pdfStream AS CHARACTER   NO-UNDO.
  DEFINE INPUT        PARAMETER pString   AS CHARACTER   NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pMemPtr   AS MEMPTR      NO-UNDO.

  DEFINE VARIABLE l_Loop  AS INTEGER   NO-UNDO.

  /* No Password  */
  IF LENGTH(pString) > 0 AND LENGTH(pString) <= 32 THEN DO:
    /* 26-SEP-2013 jcc: enable chars > 127 in passwords, both for single byte and utf-8 sessions */
    DEFINE VARIABLE cCodePage AS CHARACTER  NO-UNDO.
    cCodePage = pdf_get_parameter(pdfStream, "CodePage").
    IF SESSION:CPINTERNAL = "utf-8" AND cCodePage = "" THEN cCodePage = "iso8859-1".
    IF cCodePage <> "" THEN
        pString = CODEPAGE-CONVERT(pString, cCodePage).

    SET-SIZE(pMemPtr) = 0.
    SET-SIZE(pMemPtr) = 32.
    /* 26-SEP-2013 jcc: rewrite using put-string */
    PUT-STRING(pMemPtr, 1, LENGTH(pString)) = pString.
  END.

END. /* InitString */

PROCEDURE PadString:
  DEFINE INPUT PARAMETER        pLength   AS INTEGER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pMemPtr   AS MEMPTR NO-UNDO.

  DEFINE VARIABLE L_ctr   AS INTEGER NO-UNDO.
  DEFINE VARIABLE L_pad   AS INTEGER NO-UNDO.

  /* Password Pad String */ 
  /* from PDF spec: < 28 BF 4E 5E 4E 75 8A 41 64 00 4E 56 FF FA 01 08 2E 2E 00 B6 D0 68 3E 80 2F 0C A9 FE 64 53 69 7A > */
  DEFINE VARIABLE iPadArray AS INTEGER EXTENT 32
      INITIAL [40, 191, 78, 94, 78, 117, 138, 65, 100, 0, 78, 86, 255, 250, 1, 8, 46, 46, 0, 182, 208, 104, 62, 128, 47, 12, 169, 254, 100, 83, 105, 122]
      NO-UNDO.

  SET-SIZE(pMemPtr) = 32. /* in case pMemPtr has already been allocated elsewhere, this won't do anything */

  l_Ctr = pLength + 1.
  l_Pad = 1. 
  DO WHILE TRUE:
    PUT-BYTE(pMemPtr, L_Ctr) = iPadArray[l_pad].
    l_Ctr = l_Ctr + 1.
    L_pad = L_pad + 1.
    IF L_Ctr > 32 THEN LEAVE.
  END. /* While True */

END. /* PadString */

PROCEDURE EncryptContent:
  DEFINE INPUT  PARAMETER pdfStream    AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER p_EncryptKey AS MEMPTR      NO-UNDO.
  DEFINE INPUT  PARAMETER p_Original   AS MEMPTR      NO-UNDO.
  DEFINE OUTPUT PARAMETER p_Encrypted  AS MEMPTR      NO-UNDO.

  DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPadding    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE mEncrypted  AS MEMPTR    NO-UNDO.
  DEFINE VARIABLE rEncryptKey AS RAW       NO-UNDO.
  DEFINE VARIABLE rInitVector AS RAW       NO-UNDO.
  /* DEFINE VARIABLE rOriginal   AS RAW       NO-UNDO. */

  CASE pdf_get_parameter(pdfStream, "EncryptAlgorithm"):
      WHEN "RC4" THEN DO:
          SET-SIZE(p_Encrypted) = GET-SIZE(p_Original).
          PUT-BYTES(p_Encrypted, 1) = p_Original.
          PDFendecrypt(p_Encrypted, p_Encryptkey).
      END.
      WHEN "AES" THEN DO:
        &IF INTEGER(ENTRY(1, PROVERSION, ".")) >= 10 &THEN
          /* padding (RFC 2898, PKCS #5: Password-Based Cryptography Specification Version 2.0) */
          /* iPadding = 16 - (GET-SIZE(p_Original) MODULO 16). */
          /* PUT-BYTES(rOriginal, 1) = p_Original. */
          /* DO i = GET-SIZE(p_Original) + 1 TO GET-SIZE(p_Original) + iPadding. */
              /* PUT-BYTE(rOriginal, i) = iPadding. */
          /* END. */
          /* encryption */
          rInitVector = GENERATE-RANDOM-KEY.
          PUT-BYTES(rEncryptKey, 1) = p_EncryptKey.
          mEncrypted = ENCRYPT(p_Original, rEncryptKey, rInitVector, "AES_CBC_128").
          SET-SIZE(p_Encrypted) = 0.
          SET-SIZE(p_Encrypted) = GET-SIZE(mEncrypted) + 16.
          PUT-BYTES(p_Encrypted, 1) = rInitVector.
          PUT-BYTES(p_Encrypted, 17) = mEncrypted.
          SET-SIZE(mEncrypted) = 0.
        &ENDIF
      END.
  END CASE.

END. /* EncryptContent */

PROCEDURE GetEncryptKey:
  DEFINE INPUT  PARAMETER pdfStream         AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_UniqueID        AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER p_Object          AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER p_Gen             AS INTEGER   NO-UNDO.
  /* DEFINE INPUT  PARAMETER p_StreamKey       AS MEMPTR    NO-UNDO. */
  DEFINE OUTPUT PARAMETER p_EncryptKey      AS MEMPTR    NO-UNDO.

  DEFINE VARIABLE cEncAlgo   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cObjectHex AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE L_Hash     AS MEMPTR      NO-UNDO.
  DEFINE VARIABLE L_Keyptr   AS MEMPTR      NO-UNDO.
  DEFINE VARIABLE L_Len      AS INTEGER     NO-UNDO.

  /* 23-SEP-2013 jcc: not used here */
  /* DEFINE VARIABLE L_TxtFile   AS CHARACTER NO-UNDO. */
  /* DEFINE VARIABLE L_md5File   AS CHARACTER NO-UNDO. */
  /* ASSIGN L_TxtFile = SESSION:TEMP-DIR + p_UniqueID + "-key.txt" */
         /* L_md5File = SESSION:TEMP-DIR + p_UniqueID + "-key.md5". */

  cEncAlgo = pdf_get_parameter(pdfStream, "EncryptAlgorithm").

  L_Len = IF pdf_get_parameter(pdfStream,"EncryptKey") = "40" THEN 5 ELSE 16.

  SET-SIZE(L_KeyPtr) = L_Len + 5 + IF cEncAlgo = "AES" THEN 4 ELSE 0.

  /* Take first n-bytes of original Rc4-Key ... */
  /* PUT-BYTES(L_KeyPtr,1) = p_StreamKey. */
  PUT-BYTES(L_KeyPtr,1) = mOriginalKey.

  cObjectHex = int2hexchar(p_Object).
  IF L_Len = 5 THEN DO: /* 40 Bit */
    /* Append Object Number - Low Order 3 Bytes */
    FIND HexArray WHERE HexArray.Hex-Val = SUBSTR(cObjectHex,9,2).
    PUT-BYTE(L_KeyPtr,  6) = HexArray.chr-val.
    FIND HexArray WHERE HexArray.Hex-Val = SUBSTR(cObjectHex,7,2).
    PUT-BYTE(L_KeyPtr,  7) = HexArray.chr-val.
    FIND HexArray WHERE HexArray.Hex-Val = SUBSTR(cObjectHex,5,2).
    PUT-BYTE(L_KeyPtr,  8) = HexArray.chr-val.

    /* Append Generation Number - currently always zero */
    PUT-BYTE(L_KeyPtr,  9) = 0.
    PUT-BYTE(L_KeyPtr, 10) = 0.
  END. /* 40 Bit */

  ELSE DO: /* 128 Bit */
    /* Append Object Number - Low Order 3 Bytes */
    FIND HexArray WHERE HexArray.Hex-Val = SUBSTR(cObjectHex,9,2).
    PUT-BYTE(L_KeyPtr, 17) = HexArray.chr-val.
    FIND HexArray WHERE HexArray.Hex-Val = SUBSTR(cObjectHex,7,2).
    PUT-BYTE(L_KeyPtr, 18) = HexArray.chr-val.
    FIND HexArray WHERE HexArray.Hex-Val = SUBSTR(cObjectHex,5,2).
    PUT-BYTE(L_KeyPtr, 19) = HexArray.chr-val.

    /* Append Generation Number - currently always zero */
    PUT-BYTE(L_KeyPtr, 20) = 0.
    PUT-BYTE(L_KeyPtr, 21) = 0.

    /* AES: append "sAIT" */
    IF cEncAlgo = "AES" THEN DO:
      PUT-BYTE(L_KeyPtr, 22) = 115. /* 0x73 */
      PUT-BYTE(L_KeyPtr, 23) = 65.  /* 0x41 */
      PUT-BYTE(L_KeyPtr, 24) = 108. /* 0x6C */
      PUT-BYTE(L_KeyPtr, 25) = 84.  /* 0x54 */
    END.
  END. /* 128 Bit */

  /* Then run the md5 hash against that n-byte key orig + obj + gen */
  RUN md5hash(INPUT p_UniqueID,
              INPUT l_KeyPtr,
              OUTPUT L_Hash).

  /* Now take the first n + 5 bytes, up to a maximum of 16, of the resulting md5 hash as the new key */
  L_Len = MINIMUM(L_Len + 5, 16).
  SET-SIZE(p_EncryptKey) = L_Len.
  PUT-BYTES(p_EncryptKey, 1) = GET-BYTES(L_Hash, 1, L_Len).

  SET-SIZE(L_KeyPtr) = 0.

END. /* GetEncryptKey */

PROCEDURE BuildDocId:
  DEFINE INPUT  PARAMETER pUniqueID AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pID       AS CHARACTER NO-UNDO.

  DEFINE VARIABLE mID  AS MEMPTR   NO-UNDO.
  DEFINE VARIABLE mpID AS MEMPTR   NO-UNDO.
  
  SET-SIZE(mID) = LENGTH(pUniqueID).
  PUT-STRING(mID, 1, LENGTH(pUniqueID)) = pUniqueID.
  SET-SIZE(mpID) = 16.

  RUN md5Hash (pUniqueID
              ,mID
              ,OUTPUT mpID).

  pID = HEX-ENCODE(mpID).

  SET-SIZE(mID) = 0.
  SET-SIZE(mpID) = 0.
END. /* BuildDocID */

