/*******************************************************************************

    Program:        column-list.p
    
    Description:    lllustrates the use of Column placement using a Proportional
                    Font.
                    
*******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

DEFINE VARIABLE j# AS INTEGER   NO-UNDO.
DEFINE VARIABLE i# AS CHARACTER NO-UNDO.

/* Create stream for new PDF file */
RUN pdf_new        ("Spdf",cPdfIncludePath + "samples/super/column-list.pdf").

RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc: for testing purposes */

/* Load Arial Code Font */
RUN pdf_load_font  ("Spdf","Arial",cWinDir + "\fonts\arial.ttf",cPdfIncludePath + "samples/support/arial.afm","").

/* Start a New Page */
RUN pdf_new_page("Spdf").

/* Set the Font to Arial */
RUN pdf_set_font ("Spdf","Arial",10.0).

REPEAT j# = 1 TO 5:
   i# = STRING( EXP( 10, j#) ).

   RUN pdf_text_at ("Spdf", i#,10).
   RUN pdf_text_at ("Spdf", STRING(j#),70).

   RUN pdf_skip("Spdf").
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of column-list.p */
