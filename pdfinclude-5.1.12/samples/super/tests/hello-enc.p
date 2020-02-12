/******************************************************************************

    Program:        hello-enc.p
    
    Description:    This program illustrates the very basic elements that are 
                    required when using PDFinclude.

******************************************************************************/
DEFINE INPUT  PARAMETER cEncryptAlgo AS CHARACTER   NO-UNDO. /* RC4 or AES */
DEFINE INPUT  PARAMETER cEncryptKey  AS CHARACTER   NO-UNDO.                 

{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

{tests/pdf_tests.i}

/* DEFINE VARIABLE cEncryptAlgo  AS CHARACTER   INITIAL "AES" NO-UNDO. /* RC4 or AES */ */
/* DEFINE VARIABLE cEncryptKey   AS CHARACTER   INITIAL "128" NO-UNDO. */
DEFINE VARIABLE cUserPassword AS CHARACTER   INITIAL "" NO-UNDO.

RUN pdf_new ("Spdf", gcTestsDir + "tests/hello-enc." + cEncryptAlgo + "-" + cEncryptKey + ".pdf").
/* RUN pdf_set_parameter ("Spdf","Compress","TRUE"). */

RUN pdf_set_info ("Spdf", "Author",   "Jic" + CHR(50089, SESSION:CHARSET, "utf-8")). /* accentuated char to test utf-8 */
RUN pdf_set_info ("Spdf", "Title",    "Hello world!").
RUN pdf_set_info ("Spdf", "Keywords", "hello,world,test,encrypt").

RUN pdf_set_parameter ("Spdf","Encrypt","TRUE").
RUN pdf_set_parameter ("Spdf","EncryptAlgorithm",cEncryptAlgo).
RUN pdf_set_parameter ("Spdf","EncryptKey",cEncryptKey).
RUN pdf_set_parameter ("Spdf","MasterPassword","M4st3rPwd").
RUN pdf_set_parameter ("Spdf","UserPassword",cUserPassword).

RUN pdf_new_page("Spdf").

RUN pdf_text("Spdf", "Hello World!").
RUN pdf_skipn("Spdf", 2).
RUN pdf_set_font("Spdf", "Helvetica", 8).
RUN pdf_text("Spdf", "by Jic" + CHR(50089, SESSION:CHARSET, "utf-8")).

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of hello.pdf */
