/******************************************************************************

    Program:        hello-enc-plop.p
    
    Description:    This program illustrates the very basic elements that are 
                    required when using PDFinclude.
                    Encryption using PLOP from pdflib.com

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/hello-enc-plop.pdf").
/* RUN pdf_set_parameter ("Spdf","Compress","TRUE"). */

/* The following parameters are for pdfinclude native encryption */
/* RUN pdf_set_parameter ("Spdf","Encrypt","TRUE"). */
/* RUN pdf_set_parameter ("Spdf","EncryptKey","128"). */
/* RUN pdf_set_parameter ("Spdf","MasterPassword","M4sterPwd"). */
/* RUN pdf_set_parameter ("Spdf","UserPassword","Us3rPwd"). */

/* 03-OCT-2012 jcc: encrypt using PLOP */
RUN pdf_encrypt("Spdf",
                "M4sterPwd",
                "Us3rPwd",
                "noprint,nohiresprint,nomodify,noaccessible", /* permissions; possible values: "noprint,nohiresprint,nomodify,nocopy,noannots,noforms,noaccessible,noassemble" */
                "1.6",      /* pdf version compatibility (select encryption algorithm) */
                "SHARED",   /* interaction mode with PLOP SHARED (dll), COM or OS */
                FALSE       /* silent (TRUE) or interactive (FALSE) */).

RUN pdf_new_page("Spdf").

RUN pdf_text("Spdf", "Hello World!").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of hello.pdf */
