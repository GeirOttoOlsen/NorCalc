/******************************************************************************

    Program:        hello-mandarin.p
    
    Description:    This program illustrates unicode fonts usage in pdfinclude.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/hello-mandarin.pdf").

RUN pdf_load_font("Spdf","SIMYOU|SUBSET", "fonts/SIMYOU.ttf", "fonts/SIMYOU.ufm","").
/* RUN pdf_load_font("Spdf","Arial|SUBSET","c:\windows\fonts\Arial.ttf","fonts\Arial.ufm",""). */

/* The following parameters are not needed (for tests only) */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */
RUN pdf_set_parameter("Spdf","compress","TRUE").

RUN pdf_new_page("Spdf").

RUN pdf_set_font("Spdf","SIMYOU",12).
/* RUN pdf_set_font("Spdf","Arial",12). */

RUN pdf_text("Spdf", "Hello 北方話"). /* Hello Mandarin in UTF-8 */
/* RUN pdf_text("Spdf", "mǐn"). */ /* compound glyph */

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of hello-mandarin.p */
