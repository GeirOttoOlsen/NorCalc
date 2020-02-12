/******************************************************************************

    Program:        link.p
    
    Description:    Illustrates a text object used as a link

******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/link.pdf").

RUN pdf_set_parameter("Spdf", "unittest", "true").

RUN pdf_new_page("Spdf").

/* Place some text */
RUN pdf_text  ("Spdf", FILL("123456789 ",8)). 
RUN pdf_skip  ("Spdf").
RUN pdf_text  ("Spdf", "Press the big blue rectangle below").
RUN pdf_link  ("Spdf", 100,100,300,300,"http://www.epro-sys.com",0.0,0.0,1.0,1,"I").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of link.p */
