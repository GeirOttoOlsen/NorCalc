/******************************************************************************

    Program:        template.p

    Description:    This program illustrates how to include and use a template 
                    file.  The template only appears on the page where it is 
                    'used'.

    Note:           must be attached to the Sports2000 DB to run example.
    
******************************************************************************/
{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/template.pdf").

RUN pdf_set_parameter("sPDF","unitTest","TRUE").

RUN pdf_load_template("Spdf","Temp1",cPdfIncludePath + "samples\super\Temp1.cfg").
RUN pdf_load_template("Spdf","Temp2",cPdfIncludePath + "samples\super\Temp2.cfg").
RUN pdf_load_template("Spdf","Portrait",cPdfIncludePath + "samples\super\Portrait.cfg").

FOR EACH Order WHERE Order.CustNum = 1 NO-LOCK:
  RUN pdf_new_page("Spdf").
  RUN pdf_use_template("Spdf","Portrait").
  RUN pdf_use_template("Spdf","Temp1").

  RUN pdf_skipn("Spdf",5).
  RUN pdf_text_at("Spdf","Order #:" + STRING(Order.OrderNum),18).

  RUN pdf_skip("Spdf").
  RUN pdf_text_at("Spdf"," Cust #:" + STRING(Order.CustNum),18).

  RUN pdf_new_page("Spdf").
  RUN pdf_use_template("Spdf","Portrait").

  RUN pdf_text_at("Spdf","This page could be used to outline order processing requirements etc",10).
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of template.pdf */
