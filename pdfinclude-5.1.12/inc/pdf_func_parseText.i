/******************************************************************************

  Program:      pdf_func_parseText.i
  
  Written By:   Jean-Christophe Cardot
  Written On:   October 2014
  
  Description:  parseText() function: transforms a pdf string into a 4GL string
  
  10/22/14  JC Cardot   Created

******************************************************************************/
&IF DEFINED(pdf_func_parseText-included) = 0 &THEN
&GLOBAL-DEFINE pdf_func_parseText-included YES

/* 06-JUL-2011 jcc: rewrite parseText */
/* FUNCTION parseFirstChar RETURNS INTEGER ( cText AS CHARACTER, OUTPUT iChars AS INTEGER ): */
/*     DEFINE VARIABLE i AS INTEGER    NO-UNDO.                                              */
/*     IF SUBSTRING(cText,1,1) = "~\" THEN DO:                                               */
/*         i = INTEGER(SUBSTRING(cText,2,3)) NO-ERROR.                                       */
/*         IF NOT ERROR-STATUS:ERROR THEN DO:                                                */
/*             iChars = 4.                                                                   */
/*             RETURN oct2int(SUBSTRING(cText,2,3)).                                         */
/*         END.                                                                              */
/*         ELSE DO:                                                                          */
/*             iChars = 2.                                                                   */
/*             CASE SUBSTRING(cText,1,2):                                                    */
/*                 WHEN "~\n" THEN RETURN ASC("~n").                                         */
/*                 WHEN "~\r" THEN RETURN ASC("~r").                                         */
/*                 WHEN "~\t" THEN RETURN ASC("~t").                                         */
/*                 WHEN "~\b" THEN RETURN ASC("~b").                                         */
/*                 WHEN "~\f" THEN RETURN ASC("~f").                                         */
/*                 OTHERWISE RETURN ASC(SUBSTRING(cText,2,1)).                               */
/*             END CASE.                                                                     */
/*         END.                                                                              */
/*     END.                                                                                  */
/*     ELSE DO:                                                                              */
/*         iChars = 1.                                                                       */
/*         RETURN ASC(SUBSTRING(cText,1,1,'RAW'), 'iso8859-1', 'iso8859-1').                 */
/*     END.                                                                                  */
/* END FUNCTION.                                                                             */

/* 23-MAY-2013 jcc: Defined as a preprocessor in order to inline the code, for performance */
/* 22-SEP-2016 jcc: make it compile for Unix */
&IF OPSYS = "UNIX" &THEN
&SCOPED-DEFINE parseFirstCharIntoIByteAndIChars ~
    IF c BEGINS "\\\\" THEN DO:~
        i = INTEGER(SUBSTRING(c,2,3)) NO-ERROR.~
        IF NOT ERROR-STATUS:ERROR THEN DO:~
            iChars = 4.~
            iByte = oct2int(SUBSTRING(c,2,3)).~
        END.~
        ELSE DO:~
            iChars = 2.~
            CASE SUBSTRING(c,2,1):~
                WHEN "n" THEN iByte = ASC("~~n").~
                WHEN "r" THEN iByte = ASC("~~r").~
                WHEN "t" THEN iByte = ASC("~~t").~
                WHEN "b" THEN iByte = ASC("~~b").~
                WHEN "f" THEN iByte = ASC("~~f").~
                OTHERWISE iByte = ASC(SUBSTRING(c,2,1)).~
            END CASE.~
        END.~
    END.~
    ELSE DO:~
        iChars = 1.~
        iByte = ASC(SUBSTRING(c,1,1,'RAW'), 'iso8859-1', 'iso8859-1').~
    END.
&ELSE
&SCOPED-DEFINE parseFirstCharIntoIByteAndIChars ~
    IF c BEGINS "~\" THEN DO:~
        i = INTEGER(SUBSTRING(c,2,3)) NO-ERROR.~
        IF NOT ERROR-STATUS:ERROR THEN DO:~
            iChars = 4.~
            iByte = oct2int(SUBSTRING(c,2,3)).~
        END.~
        ELSE DO:~
            iChars = 2.~
            CASE SUBSTRING(c,2,1):~
                WHEN "n" THEN iByte = ASC("~~n").~
                WHEN "r" THEN iByte = ASC("~~r").~
                WHEN "t" THEN iByte = ASC("~~t").~
                WHEN "b" THEN iByte = ASC("~~b").~
                WHEN "f" THEN iByte = ASC("~~f").~
                OTHERWISE iByte = ASC(SUBSTRING(c,2,1)).~
            END CASE.~
        END.~
    END.~
    ELSE DO:~
        iChars = 1.~
        iByte = ASC(SUBSTRING(c,1,1,'RAW'), 'iso8859-1', 'iso8859-1').~
    END.
&ENDIF

FUNCTION parseText RETURNS CHARACTER ( cText AS CHARACTER ):
    DEFINE VARIABLE c        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cRetVal  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE i        AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iByte    AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iByte1   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iByte2   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iChars   AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iChars1  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iChars2  AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lDblByte AS LOGICAL     NO-UNDO.

    /* Text strings */
    IF SUBSTRING(cText,1,1,"RAW") = "(" THEN DO:
        /*cRetVal = RIGHT-TRIM(LEFT-TRIM(cText, "("), ")").*/
        cRetVal = SUBSTRING(cText, 2, -1, "RAW").
        IF SUBSTRING(cRetVal, LENGTH(cRetVal, "RAW"), 1, "RAW") = ")" THEN
            cRetVal = SUBSTRING(cRetVal, 1, LENGTH(cRetVal, "RAW") - 1, "RAW").
        /* Double byte string? (UTF-16BE encoded) */
        /* iByte1 = parseFirstChar(cRetVal, OUTPUT iChars). */
        /* iByte2 = parseFirstChar(SUBSTRING(cRetVal, iChars + 1), OUTPUT iChars2). */
        c = cRetVal.
        {&parseFirstCharIntoIByteAndIChars}
        iByte1 = iByte.
        iChars1 = iChars.
        c = SUBSTRING(cRetVal, iChars + 1).
        {&parseFirstCharIntoIByteAndIChars}
        iByte2 = iByte.
        iChars2 = iChars.
        IF iByte1 = 254 AND iByte2 = 255 THEN DO:
            /* c = SUBSTRING(cRetVal, iChars + iChars2 + 1). */
            c = SUBSTRING(cRetVal, iChars1 + iChars2 + 1).
            cRetVal = "".
            DO WHILE c > "":
                /* iByte1 = parseFirstChar(c, OUTPUT iChars). */
                {&parseFirstCharIntoIByteAndIChars}
                iByte1 = iByte.
                c = SUBSTRING(c, iChars + 1).
                /* iByte2 = parseFirstChar(c, OUTPUT iChars). */
                {&parseFirstCharIntoIByteAndIChars}
                iByte2 = iByte.
                c = SUBSTRING(c, iChars + 1).
                cRetVal = cRetVal + CHR(256 * iByte1 + iByte2, SESSION:CPINTERNAL, 'UTF-16').
            END.
        END.
        /* Are there octal numbers or special characters within the string? */
        ELSE IF INDEX(cRetVal, "~\") > 0 THEN DO:
            c = cRetVal.
            cRetVal = "".
            DO WHILE c > "":
                IF INDEX(c,"~\") > 0 THEN DO:
                    IF SUBSTRING(c,1,1) = "~\" THEN DO:
                        /* jcc: commented to inline the function for performance */
                        /* cRetVal = cRetVal + CHR(parseFirstChar(c, OUTPUT iChars), 'iso8859-1', 'iso8859-1'). */
                        /* c = SUBSTRING(c, iChars + 1). */
                        i = INTEGER(SUBSTRING(c,2,3)) NO-ERROR.
                        /* TODO: octal char might have 1 to three digits! */
                        IF NOT ERROR-STATUS:ERROR THEN DO:
                            cRetVal = cRetVal + CHR(oct2int(SUBSTRING(c,2,3)), SESSION:CPINTERNAL, 'iso8859-1').
                            c = SUBSTRING(c,5).
                        END.
                        ELSE DO:
                            CASE SUBSTRING(c,1,2):
                                WHEN "~\n" THEN cRetVal = cRetVal + "~n".
                                WHEN "~\r" THEN cRetVal = cRetVal + "~r".
                                WHEN "~\t" THEN cRetVal = cRetVal + "~t".
                                WHEN "~\b" THEN cRetVal = cRetVal + "~b".
                                WHEN "~\f" THEN cRetVal = cRetVal + "~f".
                                OTHERWISE cRetVal = cRetVal + SUBSTRING(c,2,1).
                            END CASE.
                            c = SUBSTRING(c,3).
                        END.
                    END.
                    ELSE DO:
                        cRetVal = cRetVal + SUBSTRING(c,1,INDEX(c,"~\") - 1).
                        c = SUBSTRING(c,INDEX(c,"~\")).
                    END.
                END.
                ELSE DO:
                    cRetVal = cRetVal + c.
                    c = "".
                END.
            END. /* DO WHILE c > "" */
        END.
    END.
    /* Double byte hexa encoded string */
    ELSE IF SUBSTRING(cText,1,5) = "<FEFF" THEN DO: /* double byte 254+255 */
        cText = SUBSTRING(RIGHT-TRIM(LEFT-TRIM(cText, "<"), ">"),5).
        DO i = 1 TO LENGTH(cText) BY 4:
            cRetVal = cRetVal + CHR(hex2Int(SUBSTRING(cText,i,4)), SESSION:CPINTERNAL, 'UTF-16').
        END.
    END.
    /* Hexa encoded string */
    ELSE IF SUBSTRING(cText,1,1) = "<" THEN DO:
        cText = RIGHT-TRIM(LEFT-TRIM(cText, "<"), ">").
        DO i = 1 TO LENGTH(cText) BY 2:
            cRetVal = cRetVal + CHR(hex2Int(SUBSTRING(cText,i,2)), SESSION:CPINTERNAL, 'iso8859-1').
        END.
    END.
    /* ASCII encoded string */
    ELSE
        RETURN cText.
    RETURN cRetVal.
END FUNCTION. /* parseText */

&ENDIF
