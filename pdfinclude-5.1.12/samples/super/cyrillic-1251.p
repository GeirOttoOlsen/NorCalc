/******************************************************************************

    Program:        cyrillic.p
    
    Description:    This program illustrates the use of national characters in
                    PdfInclude. pdf_set_base14_codepage applies to all base fonts.
                    This program is encoded in 1251.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE cValue AS CHARACTER   NO-UNDO.

RUN pdf_new ("Spdf", cPdfIncludePath + "samples\super\cyrillic-1251.pdf").

RUN pdf_set_parameter("sPDF","unitTest","TRUE").

/* all the magic is in the following call */
RUN pdf_set_base14_codepage ('Spdf', '1251').

RUN pdf_new_page ("Spdf").

/* cValue = CODEPAGE-CONVERT("currencies: ðóáëü,ðóáëÿ,ðóáëåé,êîïåéêà,êîïåéêè,êîïååê~n                                                                                                                                                                                                                                                                                                                                 */
/* ~n                                                                                                                                                                                                                                                                                                                                                                                                                 */
/* numbers: îäèí, äâà, òðè, ÷åòûðå, ïÿòü, øåñòü, ñåìü, âîñåìü, äåâÿòü, äåñÿòü, îäèííàäöàòü, äâåíàäöàòü, òðèíàäöàòü, ÷åòûðíàäöàòü, ïÿòíàäöàòü, øåñòíàäöàòü, ñåìåâäöàòü, âîñåìíàäöàòü, äåâÿòíàäöòü, äâàäöàòü, òðèäöàòü, ñîðîê, ïÿòüäåñÿò, øåñòüäåñÿò, ñåìüäåñÿò, âîñåìüäåñÿò, äåâÿíîñòî, ñòî, äâåñòè, òðèñòà, ÷åòûðåñòà, ïÿòüñîò, øåñòüñîò, ñåìüñîò, âîñåìüñîò, äåâÿòüñîò, òûñÿ÷à, òûñÿ÷è, òûñÿ÷, ìèëëèîí, ìèëëèîíîâ ", */
/*     SESSION:CHARSET, IF SESSION:CHARSET = "utf-8" THEN "1251" ELSE SESSION:CHARSET).                                                                                                                                                                                                                                                                                                                               */

/* 24-SEP-2014 jcc: use literal text defined as utf-8 and mùake it work in utf-8 AND single byte sessions */
cValue = CODEPAGE-CONVERT("currencies: Ñ€ÑƒÐ±Ð»ÑŒ,Ñ€ÑƒÐ±Ð»Ñ,Ñ€ÑƒÐ±Ð»ÐµÐ¹,ÐºÐ¾Ð¿ÐµÐ¹ÐºÐ°,ÐºÐ¾Ð¿ÐµÐ¹ÐºÐ¸,ÐºÐ¾Ð¿ÐµÐµÐº~n
~n
numbers: Ð¾Ð´Ð¸Ð½, Ð´Ð²Ð°, Ñ‚Ñ€Ð¸, Ñ‡ÐµÑ‚Ñ‹Ñ€Ðµ, Ð¿ÑÑ‚ÑŒ, ÑˆÐµÑÑ‚ÑŒ, ÑÐµÐ¼ÑŒ, Ð²Ð¾ÑÐµÐ¼ÑŒ, Ð´ÐµÐ²ÑÑ‚ÑŒ, Ð´ÐµÑÑÑ‚ÑŒ, Ð¾Ð´Ð¸Ð½Ð½Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, Ð´Ð²ÐµÐ½Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, Ñ‚Ñ€Ð¸Ð½Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, Ñ‡ÐµÑ‚Ñ‹Ñ€Ð½Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, Ð¿ÑÑ‚Ð½Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, ÑˆÐµÑÑ‚Ð½Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, ÑÐµÐ¼ÐµÐ²Ð´Ñ†Ð°Ñ‚ÑŒ, Ð²Ð¾ÑÐµÐ¼Ð½Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, Ð´ÐµÐ²ÑÑ‚Ð½Ð°Ð´Ñ†Ñ‚ÑŒ, Ð´Ð²Ð°Ð´Ñ†Ð°Ñ‚ÑŒ, Ñ‚Ñ€Ð¸Ð´Ñ†Ð°Ñ‚ÑŒ, ÑÐ¾Ñ€Ð¾Ðº, Ð¿ÑÑ‚ÑŒÐ´ÐµÑÑÑ‚, ÑˆÐµÑÑ‚ÑŒÐ´ÐµÑÑÑ‚, ÑÐµÐ¼ÑŒÐ´ÐµÑÑÑ‚, Ð²Ð¾ÑÐµÐ¼ÑŒÐ´ÐµÑÑÑ‚, Ð´ÐµÐ²ÑÐ½Ð¾ÑÑ‚Ð¾, ÑÑ‚Ð¾, Ð´Ð²ÐµÑÑ‚Ð¸, Ñ‚Ñ€Ð¸ÑÑ‚Ð°, Ñ‡ÐµÑ‚Ñ‹Ñ€ÐµÑÑ‚Ð°, Ð¿ÑÑ‚ÑŒÑÐ¾Ñ‚, ÑˆÐµÑÑ‚ÑŒÑÐ¾Ñ‚, ÑÐµÐ¼ÑŒÑÐ¾Ñ‚, Ð²Ð¾ÑÐµÐ¼ÑŒÑÐ¾Ñ‚, Ð´ÐµÐ²ÑÑ‚ÑŒÑÐ¾Ñ‚, Ñ‚Ñ‹ÑÑÑ‡Ð°, Ñ‚Ñ‹ÑÑÑ‡Ð¸, Ñ‚Ñ‹ÑÑÑ‡, Ð¼Ð¸Ð»Ð»Ð¸Ð¾Ð½, Ð¼Ð¸Ð»Ð»Ð¸Ð¾Ð½Ð¾Ð²",
    IF SESSION:CHARSET = "utf-8" THEN "utf-8" ELSE "1251", "utf-8").

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

RUN pdf_close ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of hello.pdf */
