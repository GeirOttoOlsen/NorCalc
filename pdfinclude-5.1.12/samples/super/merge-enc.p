/* 04-OCT-2013 jcc: merge.p
   This demonstrates the use of pdf_merge_stream + usage of pdf templates + jpg & png images */

{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE" }

DEFINE VARIABLE cEncryptAlgo  AS CHARACTER   INITIAL "AES" NO-UNDO. /* RC4 or AES */
DEFINE VARIABLE cEncryptKey   AS CHARACTER   INITIAL "128" NO-UNDO.
DEFINE VARIABLE cUserPassword AS CHARACTER   INITIAL "Us3rPwd" NO-UNDO.

RUN pdf_new ("Spdf",cPdfIncludePath + "samples/super/merge-enc." + cEncryptAlgo + "-" + cEncryptKey + "." + cUserPassword + "." + SESSION:CPINTERNAL + ".pdf").
/* RUN pdf_set_parameter ("Spdf","compress","TRUE"). */
RUN pdf_set_parameter ("Spdf","Encrypt","TRUE").
RUN pdf_set_parameter ("Spdf","EncryptAlgorithm",cEncryptAlgo).
RUN pdf_set_parameter ("Spdf","EncryptKey",cEncryptKey).
RUN pdf_set_parameter ("Spdf","MasterPassword","M4st3rPwd").
RUN pdf_set_parameter ("Spdf","UserPassword",cUserPassword).

RUN pdf_new ("Spdf0",cPdfIncludePath + "samples/super/merge0.pdf").

RUN pdf_new ("Spdf1",cPdfIncludePath + "samples/super/merge1.pdf").
RUN pdf_open_PDF("Spdf1",cPdfIncludePath + "samples/support/Invoice.pdf","Inv1").
RUN pdf_new_page("Spdf1").
RUN pdf_use_PDF_page("Spdf1","Inv1",1).
RUN pdf_set_font("Spdf1","Helvetica",8).
RUN pdf_text_color("Spdf1",1.0,0.0,0.0).
RUN pdf_text_xy ("Spdf1",STRING(1,"99999"),350,557).
RUN pdf_text_xy ("Spdf1",STRING(11/13/2006,"99.99.9999"),350,546).
RUN pdf_text_xy ("Spdf1",STRING(12,"99999"),350,535).
RUN pdf_load_image("Spdf1","product","samples/support/product.jpg").
RUN pdf_place_image("Spdf1","product",200,550,100,60).

RUN pdf_new ("Spdf2",cPdfIncludePath + "samples/super/merge2.pdf").
/* RUN pdf_set_parameter ("Spdf2","compress","TRUE"). */
RUN pdf_open_PDF("Spdf2",cPdfIncludePath + "samples/support/Invoice.pdf","Inv2").
RUN pdf_new_page("Spdf2").
RUN pdf_use_PDF_page("Spdf2","Inv2",1).
RUN pdf_set_font("Spdf2","Helvetica",8).
RUN pdf_text_color("Spdf2",1.0,0.0,0.0).
RUN pdf_text_xy ("Spdf2",STRING(2,"99999"),350,557).
RUN pdf_text_xy ("Spdf2",STRING(11/13/2006,"99.99.9999"),350,546).
RUN pdf_text_xy ("Spdf2",STRING(144,"99999"),350,535).
RUN pdf_load_image("Spdf2","logo","samples/support/test.png"). /* the image name must be different */
RUN pdf_place_image("Spdf2","logo",300,120,100,100).

RUN pdf_new_page("Spdf").
RUN pdf_set_font("Spdf","Helvetica-Bold",12).
RUN pdf_text("Spdf", "This is a merged PDF file").
RUN pdf_skip("Spdf").
RUN pdf_set_font("Spdf","Courier",8).
RUN pdf_text("Spdf", "The next pages contain 3 invoices coming from 3 different streams.").

RUN pdf_merge_stream("Spdf1", "Spdf", 1).
RUN pdf_merge_stream("Spdf2", "Spdf", 1).

RUN pdf_merge_stream("Spdf1", "Spdf0", 1).
RUN pdf_merge_stream("Spdf2", "Spdf0", 1).

RUN pdf_set_parameter("Spdf1","unitTest","TRUE"). /* 12-AUG-2013 jcc */
RUN pdf_close("Spdf1"). IF RETURN-VALUE > "" THEN MESSAGE "Spdf1:" RETURN-VALUE VIEW-AS ALERT-BOX INFO BUTTONS OK.
RUN pdf_set_parameter("Spdf2","unitTest","TRUE"). /* 12-AUG-2013 jcc */
RUN pdf_close("Spdf2"). IF RETURN-VALUE > "" THEN MESSAGE "Spdf2:" RETURN-VALUE VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN pdf_new ("Spdf2",cPdfIncludePath + "samples/super/merge3.pdf").
RUN pdf_open_PDF("Spdf2",cPdfIncludePath + "samples/support/Invoice.pdf","Inv2").
RUN pdf_new_page("Spdf2").
RUN pdf_use_PDF_page("Spdf2","Inv2",1).
RUN pdf_set_font("Spdf2","Helvetica",8).
RUN pdf_text_color("Spdf2",1.0,0.0,0.0).
RUN pdf_text_xy ("Spdf2",STRING(3,"99999"),350,557).
RUN pdf_text_xy ("Spdf2",STRING(11/13/2006,"99.99.9999"),350,546).
RUN pdf_text_xy ("Spdf2",STRING(1728,"99999"),350,535).
RUN pdf_merge_stream("Spdf2", "Spdf", 1).
RUN pdf_merge_stream("Spdf2", "Spdf0", 1).
RUN pdf_set_parameter("Spdf2","unitTest","TRUE"). /* 12-AUG-2013 jcc */
RUN pdf_close("Spdf2"). IF RETURN-VALUE > "" THEN MESSAGE "Spdf2:" RETURN-VALUE VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN pdf_new_page("Spdf").
RUN pdf_set_font("Spdf","Helvetica-Bold",12).
RUN pdf_text("Spdf", "The end.").

RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 13-MAY-2014 jcc: need to set it again before the pdf_close as it is now reset to FALSE by the previous pdf_close */
RUN pdf_close("Spdf").  IF RETURN-VALUE > "" THEN MESSAGE "Spdf:" RETURN-VALUE VIEW-AS ALERT-BOX INFO BUTTONS OK.

RUN pdf_set_parameter("Spdf0","unitTest","TRUE"). /* 13-MAY-2014 jcc: need to set it again before the pdf_close as it is now reset to FALSE by the previous pdf_close */
RUN pdf_close("Spdf0"). IF RETURN-VALUE > "" THEN MESSAGE "Spdf0:" RETURN-VALUE VIEW-AS ALERT-BOX INFO BUTTONS OK.
