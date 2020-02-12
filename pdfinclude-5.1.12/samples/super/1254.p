/******************************************************************************

    Program:        1254.p
    
    Description:    This program illustrates the use of national characters in
                    PdfInclude. pdf_set_base14_codepage applies to all base fonts.
                    This program is encoded in 1254.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE cValue AS CHARACTER   NO-UNDO.

RUN pdf_new ("Spdf", cPdfIncludePath + "samples\super\1254.pdf").

RUN pdf_set_parameter ("Spdf", "unitTest", "true").

/* all the magic is in the following call */
RUN pdf_set_base14_codepage ('Spdf', '1254').

/* RUN pdf_load_font2("Spdf","Arial",OS-GETENV("windir") + "\fonts\arial.ttf",NO,"c:/temp/1254.differences","subset=no"). */

RUN pdf_new_page ("Spdf").

cValue = CODEPAGE-CONVERT("Lorem Ipsum , masaÃ¼stÃ¼ yayÄ±ncÄ±lÄ±k ve basÄ±n yayÄ±n sektÃ¶rÃ¼nde kullanÄ±lan taklit yazÄ± bloÄŸu olarak tanÄ±mlanÄ±r. Lipsum, oluÅŸturulacak ÅŸablon ve taslaklarda iÃ§erik yerine geÃ§erek yazÄ± bloÄŸunu doldurmak iÃ§in kullanÄ±lÄ±r.
~n
~n
Lipsum, 1500â€™lerin baÅŸlarÄ±nda bir matbaacÄ±nÄ±n font model kitabÄ± oluÅŸturmak iÃ§in , bir yazÄ± tipi kÃ¼tÃ¼phanesindeki harflerin sÄ±ralamasÄ±nÄ± bozarak yerleÅŸtirdiÄŸinden bu yana endÃ¼stri standardÄ± haline gelmiÅŸtir.",
    IF SESSION:CHARSET = "utf-8" THEN "utf-8" ELSE "1254", "utf-8").

/* cValue = "Lorem Ipsum , masaüstü yayýncýlýk ve basýn yayýn sektöründe kullanýlan taklit yazý bloðu olarak tanýmlanýr. Lipsum, oluþturulacak þablon ve taslaklarda içerik yerine geçerek yazý bloðunu doldurmak için kullanýlýr. */
/* ~n                                                                                                                                                                                                                              */
/* ~n                                                                                                                                                                                                                              */
/* Lipsum, 1500’lerin baþlarýnda bir matbaacýnýn font model kitabý oluþturmak için , bir yazý tipi kütüphanesindeki harflerin sýralamasýný bozarak yerleþtirdiðinden bu yana endüstri standardý haline gelmiþtir.".                */

RUN pdf_set_font ('Spdf', 'Helvetica', 12.0).
RUN pdf_wrap_text_xy_dec (
    'Spdf',
    cValue,
    36, 700, 250, 300, 
    10.5,
    'LEFT').

RUN pdf_set_font ('Spdf', 'Times-Roman', 12.0).
RUN pdf_wrap_text_xy_dec (
    'Spdf',
    cValue,
    144, 300, 250, 300, 
    10.5,
    'LEFT').

/* RUN pdf_set_font ('Spdf', 'Arial', 12.0). */
/* RUN pdf_wrap_text_xy_dec ( */
    /* 'Spdf', */
    /* cValue, */
    /* 80, 500, 250, 300, */
    /* 10.5, */
    /* 'LEFT'). */

RUN pdf_close ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of 1254.pdf */
