/******************************************************************************

    Program:        cyrillic.p
    
    Description:    This program illustrates the use of national characters in
                    PdfInclude. pdf_set_base14_codepage applies to all base fonts.
                    This program is encoded in 1251.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE cValue AS CHARACTER   NO-UNDO.

RUN pdf_new ("Spdf", cPdfIncludePath + "samples\super\cyrillic-utf8.pdf").

RUN pdf_set_parameter("sPDF","unitTest","TRUE").

/* all the magic is in the following call */
RUN pdf_set_base14_codepage ('Spdf', '1251').

RUN pdf_new_page ("Spdf").

cValue = "currencies: рубль,рубля,рублей,копейка,копейки,копеек~n
~n
numbers: один, два, три, четыре, пять, шесть, семь, восемь, девять, десять, одиннадцать, двенадцать, тринадцать, четырнадцать, пятнадцать, шестнадцать, семевдцать, восемнадцать, девятнадцть, двадцать, тридцать, сорок, пятьдесят, шестьдесят, семьдесят, восемьдесят, девяносто, сто, двести, триста, четыреста, пятьсот, шестьсот, семьсот, восемьсот, девятьсот, тысяча, тысячи, тысяч, миллион, миллионов".


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
