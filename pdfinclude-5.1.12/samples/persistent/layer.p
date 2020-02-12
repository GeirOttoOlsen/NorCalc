/******************************************************************************

    Program:        layer.p
    
    Description:    This program illustrates the creation of a single PDF 
                    document but generated across multiple program layers.
                    
                    NOTE: Must be attached to Sports2000 DB to run this
                          example

******************************************************************************/

{ pdf_inc.i "NOT SUPER"}

{ samples/support/config.i }

RUN pdf_new IN h_PDFinc ("Spdf",cPdfIncludePath + "samples\persistent\layer.pdf").

/* For each Customer - create a HEADER page */
FOR EACH Customer WHERE Customer.Name BEGINS "A" NO-LOCK:
  RUN pdf_new_page IN h_PDFinc ("Spdf").
  RUN pdf_set_font IN h_PDFinc ("Spdf","Courier",24.0).
  RUN pdf_text IN h_PDFinc ("Spdf", "Customer: " + Customer.Name).
  RUN pdf_skip IN h_PDFinc("Spdf").

  RUN samples/persistent/layer2.p (INPUT h_PDFinc,
                INPUT Customer.CustNum).

END. /* each Customer */

RUN pdf_close IN h_PDFinc ("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* end of layer.p */

