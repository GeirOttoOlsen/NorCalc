/******************************************************************************

    Program:        hello.p
    
    Description:    This program illustrates the use of national characters in
                    PdfInclude. pdf_set_base14_codepage applies to all base fonts.
                    This program is encoded in 1251.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "NOT SUPER"}

DEFINE VARIABLE cValue AS CHARACTER   NO-UNDO.

RUN pdf_new IN h_PDFinc ("Spdf", cPdfIncludePath + "samples\persistent\cyrillic.pdf").

/* all the magic is in the following call */
RUN pdf_set_base14_codepage IN h_PDFinc ('Spdf', '1251').

RUN pdf_new_page IN h_PDFinc ("Spdf").

cValue = "currencies: рубль,рубл€,рублей,копейка,копейки,копеек~n
~n
numbers: один, два, три, четыре, п€ть, шесть, семь, восемь, дев€ть, дес€ть, одиннадцать, двенадцать, тринадцать, четырнадцать, п€тнадцать, шестнадцать, семевдцать, восемнадцать, дев€тнадцть, двадцать, тридцать, сорок, п€тьдес€т, шестьдес€т, семьдес€т, восемьдес€т, дев€носто, сто, двести, триста, четыреста, п€тьсот, шестьсот, семьсот, восемьсот, дев€тьсот, тыс€ча, тыс€чи, тыс€ч, миллион, миллионов".

RUN pdf_set_font IN h_PDFinc ('Spdf', 'Helvetica', 12.0).
RUN pdf_wrap_text_xy_dec IN h_PDFinc (
    'Spdf',
    cValue,
    36, 700, 250, 300, 
    10.5,
    'LEFT').

RUN pdf_set_font IN h_PDFinc ('Spdf', 'Times-Roman', 12.0).
RUN pdf_wrap_text_xy_dec IN h_PDFinc (
    'Spdf',
    cValue,
    144, 300, 250, 300, 
    10.5,
    'LEFT').

RUN pdf_close IN h_PDFinc ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of hello.pdf */
