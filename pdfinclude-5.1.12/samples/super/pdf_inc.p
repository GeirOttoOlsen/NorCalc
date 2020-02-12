/* 11-MAY-2014 jcc: convert pdf_inc.p to a pdf file, with syntaxic coloration */

DEFINE VARIABLE pdfStream AS CHARACTER   INITIAL "Spdf" NO-UNDO.
DEFINE VARIABLE v-line    AS CHARACTER   NO-UNDO.

{samples/support/config.i}

{pdf_inc.i "THIS-PROCEDURE"}

/* 11-MAY-2014 jcc: subscribe to the page event to restore the color in case
   we change page within e.g. a comment */
SUBSCRIBE TO "GeneratePDFPage" IN h_PDFinc.

RUN pdf_new (pdfStream, cPdfIncludePath + "samples/super/pdf_inc.pdf").

RUN pdf_set_TopMargin("Spdf", 40). /* default top margin is 50 */
RUN pdf_set_BottomMargin("Spdf", 15). /* default bottom margin is 10 when using defaultFooter */

RUN pdf_set_info (pdfStream, "Author", "Jic" + CHR(233, SESSION:CPINTERNAL, "iso8859-1")). /* accentuated char to test utf-8 */
RUN pdf_set_info (pdfStream, "Title",  "pdf_inc.p procedure").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf", "unitTest", "TRUE"). /* 12-AUG-2013 jcc */
/* RUN pdf_set_parameter("Spdf", "compress", "TRUE"). */

RUN pdf_set_parameter("Spdf", "defaultHeader", "TRUE"). /* 08-APR-2014 jcc */
RUN pdf_set_parameter("Spdf", "defaultFooter", "TRUE"). /* 08-APR-2014 jcc */

RUN pdf_set_parameter("Spdf", "PageLayout", "OneColumn").

RUN pdf_set_font(pdfStream, "Courier", 6).

RUN pdf_new_page2(pdfStream, "landscape").

INPUT FROM VALUE(cPdfIncludePath + "pdf_inc.p").
/* INPUT FROM VALUE(cPdfIncludePath + "pdf_inc.i"). */
/* INPUT FROM VALUE(cPdfIncludePath + "test.p"). */

REPEAT :
    IMPORT UNFORMATTED v-line NO-ERROR.
    RUN ParseLine.
    RUN pdf_text(pdfStream, v-line).
    RUN pdf_skip(pdfStream).
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/*****************************************************************************/

&GLOBAL-DEFINE TAG_DEFAULT       RUN pdf_text_color(pdfStream,0.0,0.0,0.0).
/* comments */
&GLOBAL-DEFINE TAG_START_COMMENT RUN pdf_text_color(pdfStream,0.0,0.7,0.0).
/* progress 4GL keywords */
&GLOBAL-DEFINE TAG_START_KEYWORD RUN pdf_text_color(pdfStream,0.0,0.0,0.7).
/* literal integers and decimals */ 
&GLOBAL-DEFINE TAG_START_NUMBER  RUN pdf_text_color(pdfStream,0.7,0.0,0.0).
/* literal strings */ 
&GLOBAL-DEFINE TAG_START_CHAR    RUN pdf_text_color(pdfStream,0.0,0.7,0.7).
/* preprocessors (things between {} or starting with &) */   
&GLOBAL-DEFINE TAG_START_PREP    RUN pdf_text_color(pdfStream,1.0,0.0,1.0).

DEF VAR v-commentdepth AS INTEGER NO-UNDO INITIAL 0.
DEF VAR v-insource     AS LOGICAL NO-UNDO INITIAL FALSE.
DEF VAR v-pdffile      AS CHAR    NO-UNDO.
DEF VAR v-prevtag      AS CHAR    NO-UNDO INITIAL "".
DEF VAR v-prevposition AS INTEGER NO-UNDO INITIAL 0.

/* 11-MAY-2014 jcc: added */
PROCEDURE GeneratePDFPage:
    DEFINE INPUT PARAMETER pdfStream AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pdfPage   AS INTEGER     NO-UNDO.

    IF v-commentdepth > 0 THEN
        {&TAG_START_COMMENT}
END PROCEDURE.

PROCEDURE ParseLine :

    DEF VAR indoublestring AS LOGICAL NO-UNDO INITIAL FALSE.
    DEF VAR insinglestring AS LOGICAL NO-UNDO INITIAL FALSE.
    DEF VAR v-token        AS CHAR    NO-UNDO INITIAL "".
    DEF VAR v-number       AS DECIMAL NO-UNDO.
    DEF VAR inhtml         AS LOGICAL NO-UNDO INITIAL FALSE.
    DEF VAR stringed       AS LOGICAL NO-UNDO INITIAL FALSE.

    DEF VAR v-save         AS CHARACTER NO-UNDO.

   /* step 0: reset previous tag and previous position */

   ASSIGN v-prevtag      = ""
          v-prevposition = 0.

   /* step 1: find (nested) comments */
   DEF VAR i AS INTEGER NO-UNDO.
   DEF VAR vc AS CHAR NO-UNDO.
   
   i = 0.
   loop_chars:
   DO WHILE i < LENGTH(v-line) :
       i = i + 1.
       stringed = FALSE.

       vc = SUBSTRING(v-line, i , 2).

       IF vc = "~/*":U  THEN DO:
          v-commentdepth = v-commentdepth + 1.
          IF v-commentdepth=1 THEN DO:
              v-save = v-line.
              v-line = SUBSTRING(v-save, 1, i - 1).
              RUN pdf_text(pdfStream,v-line).
              {&TAG_START_COMMENT}

              RUN pdf_text(pdfStream,"~/*"). 

              v-line = SUBSTRING(v-save, i + 2).
              i = 1.
              ASSIGN v-prevtag      = ""
                     v-prevposition = 0.
          END.
          NEXT loop_chars.
       END.

       IF vc = "*~/":U  THEN DO:
          v-commentdepth = v-commentdepth - 1.
          IF v-commentdepth=0 THEN DO:
              v-save = v-line.
              v-line = SUBSTRING(v-line, 1, i + 1).
              RUN pdf_text(pdfStream,v-line).

              {&TAG_DEFAULT}

              v-line = SUBSTRING(v-save, i + 2).
              i = 1.
              ASSIGN v-prevtag      = ""
                     v-prevposition = 0.
          END.
          NEXT loop_chars.
       END.
   
      IF v-commentdepth>0 THEN NEXT loop_chars.

      /* step 2a: find string literals ("" - double quotes) */
      IF NOT insinglestring THEN DO:
          vc = SUBSTRING(v-line, i,1).
          IF vc='"' THEN DO:
             IF NOT indoublestring THEN DO:
                 v-save = v-line.
                 v-line = SUBSTRING(v-line, 1, i - 1).
                 RUN pdf_text(pdfStream,v-line).

                 {&TAG_START_CHAR}

                 v-line = SUBSTRING(v-save, i).
                 i = 1.
                 indoublestring = TRUE.
                 stringed = TRUE.
             END.
             ELSE DO:
                 v-save = v-line.
                 v-line = SUBSTRING(v-line, 1, i).
                 RUN pdf_text(pdfStream,v-line).

                 {&TAG_DEFAULT}

                 v-line = SUBSTRING(v-save, i + 1).
                 i = 1.
                 indoublestring = false.
                 stringed = false.
             END.

             ASSIGN v-prevtag      = ""
                    v-prevposition = 0.
          END.
      END.

      /* step 2b: find string literals ('' - single quotes) */
      IF NOT indoublestring THEN DO:
          vc = SUBSTRING(v-line, i,1).
          IF vc="'" THEN DO:
             IF NOT insinglestring THEN DO:
                 v-save = v-line.
                 v-line = SUBSTRING(v-line, 1, i - 1).
                 RUN pdf_Text(pdfStream,v-line).

                 {&TAG_START_CHAR}
                 v-line = SUBSTRING(v-save, i).
                 i = 1.
             END.
             ELSE DO:
                 v-save = v-line.
                 v-line = SUBSTRING(v-line, 1, i).
                 RUN pdf_text(pdfStream,v-line).

                 {&TAG_DEFAULT}
                 v-line = SUBSTRING(v-save, i + 1).
                 i = 1.
             END.
             insinglestring = NOT insinglestring.
             stringed = TRUE.
             ASSIGN v-prevtag      = ""
                    v-prevposition = 0.
          END.
      END.

      /* step 3a: find preprocessors and include directives */
      vc = SUBSTRING(v-line, i,1).
      IF vc="~{" THEN DO:
          v-save = v-line.
          v-line = SUBSTRING(v-line, 1, i - 1).
          RUN pdf_text(pdfStream,v-line).

          {&TAG_START_PREP}
          v-line = SUBSTRING(v-save, i).
          i = 1.
          ASSIGN v-prevtag      = ""
                 v-prevposition = 0.
      END.

      /* step 4: find words (could be keywords or numbers) */
      IF NOT (indoublestring OR insinglestring) THEN DO:
          vc = SUBSTRING(v-line, i,1).
          IF INDEX(" (),/+.:=" + CHR(9), vc) > 0 OR stringed THEN DO:
             IF KEYWORD-ALL(v-token) NE ? THEN
                 RUN AddKeywordTags(INPUT-OUTPUT i, v-token).
             ELSE IF v-token MATCHES "&*" THEN
                 RUN AddPreprocessorTags(INPUT-OUTPUT i, v-token).
             ELSE IF v-token<>'' THEN DO:
                v-number = ?.
                ASSIGN v-number=DECIMAL(v-token) NO-ERROR.
                IF v-number<>? THEN
                   RUN AddNumberTags(INPUT-OUTPUT i, v-token).
                ELSE 
                   RUN AddStandardTags(INPUT-OUTPUT i, v-token).
             END.
             v-token = ''.

             IF (NOT stringed) AND (vc<>" ") THEN DO:
                /* the word-separator itself has to be colored too */
                 RUN AddStandardTags(INPUT-OUTPUT i, vc).
             END.

          END.
          ELSE 
             v-token = v-token + vc.
      END.

      /* 11-MAY-2014 jcc: moved after step 4 because a keyword can be followed by a } */
      /* step 3b: find preprocessors and include directives */
      IF vc="~}" THEN DO:
          v-save = v-line.
          v-line = SUBSTRING(v-line, 1, i).

          {&TAG_START_PREP}
          RUN pdf_text(pdfStream,v-line).

          {&TAG_DEFAULT}
          v-line = SUBSTRING(v-save, i + 1).
          i = 1.
          ASSIGN v-prevtag      = ""
                 v-prevposition = 0.
      END.
   END.

   /* step 5: remaining token at end of line */
   i = LENGTH(v-line) + 1.
   IF (NOT (indoublestring OR insinglestring)) AND TRIM(v-token)<>'' THEN DO:
          IF KEYWORD-ALL(v-token) NE ? THEN
             RUN AddKeywordTags (INPUT-OUTPUT i, v-token).
          ELSE IF v-token MATCHES "&*" THEN
              RUN AddPreprocessorTags(INPUT-OUTPUT i, v-token).
          ELSE DO:
             v-number = ?.
             ASSIGN v-number=DECIMAL(v-token) NO-ERROR.
             IF v-number<>? THEN
                 RUN AddNumberTags(INPUT-OUTPUT i, v-token).
          END.
   END.

   ASSIGN v-prevtag      = ""
          v-prevposition = 0.

END PROCEDURE.

PROCEDURE AddStandardTags :
    DEFINE INPUT-OUTPUT PARAMETER i       AS INTEGER NO-UNDO.
    DEFINE INPUT        PARAMETER v-token AS CHAR    NO-UNDO.
    
    v-prevtag      = "".
    v-prevposition = 0.
END PROCEDURE.


PROCEDURE AddNumberTags :
    DEFINE INPUT-OUTPUT PARAMETER i       AS INTEGER NO-UNDO.
    DEFINE INPUT        PARAMETER v-token AS CHAR    NO-UNDO.

    RUN AddSyntaxTags (INPUT-OUTPUT i, v-token, "~{~&TAG_START_NUMBER~}", "~{~&TAG_END_NUMBER~}").

END PROCEDURE.

PROCEDURE AddPreprocessorTags :
    DEFINE INPUT-OUTPUT PARAMETER i       AS INTEGER NO-UNDO.
    DEFINE INPUT        PARAMETER v-token AS CHAR    NO-UNDO.

    IF v-token MATCHES "&lt;*" OR v-token MATCHES "&gt;*" THEN DO:
        RUN AddKeywordTags(INPUT-OUTPUT i, v-token).
        RETURN.
    END.

    RUN AddSyntaxTags (INPUT-OUTPUT i, v-token, "~{~&TAG_START_PREP~}", "~{~&TAG_END_PREP~}").
END PROCEDURE.


PROCEDURE AddKeywordTags :
    DEFINE INPUT-OUTPUT PARAMETER i       AS INTEGER NO-UNDO.
    DEFINE INPUT        PARAMETER v-token AS CHAR    NO-UNDO.

    IF v-token="?" THEN DO:
       RUN AddNumberTags(INPUT-OUTPUT i, v-token).
       RETURN.
    END.

    RUN AddSyntaxTags (INPUT-OUTPUT i, v-token, "~{~&TAG_START_KEYWORD~}", "~{~&TAG_END_KEYWORD~}").
    
END PROCEDURE.

PROCEDURE AddSyntaxTags :
    DEFINE INPUT-OUTPUT PARAMETER i       AS INTEGER NO-UNDO.
    DEFINE INPUT        PARAMETER v-token AS CHAR    NO-UNDO.
    DEFINE INPUT        PARAMETER v-starttag  AS CHAR    NO-UNDO.
    DEFINE INPUT        PARAMETER v-endtag  AS CHAR    NO-UNDO.

    DEFINE VARIABLE v-save  AS CHARACTER NO-UNDO.

    IF v-prevtag=v-endtag THEN DO:
      /* This determines what color to start */
      CASE v-starttag:
        WHEN "~{~&TAG_START_KEYWORD~}" THEN
          {&TAG_START_KEYWORD}
        WHEN "~{~&TAG_START_NUMBER~}" THEN
          {&TAG_START_NUMBER}
        WHEN "~{~&TAG_START_CHAR~}" THEN
          {&TAG_START_CHAR}
        WHEN "~{~&TAG_START_PREP~}" THEN
          {&TAG_START_PREP}
      END CASE.

       v-save = v-line.
       v-line = SUBSTRING(v-line, 1, i - 1 - LENGTH(v-token))
                      + UPPER(v-token).

       RUN pdf_text(pdfStream,v-line).
    END.
    ELSE DO:
       v-save = v-line.
       v-line = SUBSTRING(v-line, 1, i - 1 - LENGTH(v-token)).

       RUN pdf_text(pdfStream,v-line).

       /* This determines what color to start */
       CASE v-starttag:
         WHEN "~{~&TAG_START_KEYWORD~}" THEN
           {&TAG_START_KEYWORD}
         WHEN "~{~&TAG_START_NUMBER~}" THEN
           {&TAG_START_NUMBER}
         WHEN "~{~&TAG_START_CHAR~}" THEN
           {&TAG_START_CHAR}
         WHEN "~{~&TAG_START_PREP~}" THEN
           {&TAG_START_PREP}
       END CASE.

       RUN pdf_text(pdfStream,UPPER(v-token)).

    END.

    {&TAG_DEFAULT}

    v-line         = SUBSTR(v-save,i).
    i = 1.

    v-prevtag      = v-endtag.
    v-prevposition = i.

END PROCEDURE.
  
