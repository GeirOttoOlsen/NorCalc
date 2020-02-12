/******************************************************************************

    Program:        hello-subset.p
    
    Description:    This program illustrates the very basic elements that are 
                    required when using PDFinclude.
                    It also demonstrate the font subsetting functionnality.

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", cPdfIncludePath + "samples/super/hello-subset.pdf").

/* The following parameters are not needed (for tests only) */
/* RUN pdf_set_parameter("Spdf","optimizePDFOutput","FALSE"). /* 02-AUG-2013 jcc */ */
RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc */
/* RUN pdf_set_parameter("Spdf","compress","TRUE"). */

/* RUN pdf_load_font("Spdf","myFont|SUBSET","fonts\FreeSerif.ttf","fonts\FreeSerif.ufm",""). */
RUN pdf_load_font("Spdf","myFont|SUBSET","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSerif.ttf","fonts\dejavu-fonts-ttf-2.34\ttf\DejaVuSerif.ufm","").

RUN pdf_new_page("Spdf").

RUN pdf_set_font("Spdf", "myFont", 10.0).
/* RUN pdf_text("Spdf", "A"). */
RUN pdf_text("Spdf", "Hello World! ").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of hello.pdf */
