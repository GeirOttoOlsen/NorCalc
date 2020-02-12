/* 04-OCT-2013 jcc: openpdf-enc.p
   This demonstrates the use of pdf_open_pdf + encryption */
DEFINE INPUT  PARAMETER cEncryptAlgo AS CHARACTER   NO-UNDO. /* RC4 or AES */
DEFINE INPUT  PARAMETER cEncryptKey  AS CHARACTER   NO-UNDO.

{ samples/support/config.i }

{ pdf_inc.i "THIS-PROCEDURE"}

{tests/pdf_tests.i}

/* DEFINE VARIABLE cEncryptAlgo  AS CHARACTER   INITIAL "AES" NO-UNDO. /* RC4 or AES */ */
/* DEFINE VARIABLE cEncryptKey   AS CHARACTER   INITIAL "128" NO-UNDO. */
DEFINE VARIABLE cUserPassword AS CHARACTER   INITIAL "" NO-UNDO.

RUN pdf_new ("Spdf", gcTestsDir + "tests/openpdf-enc." + cEncryptAlgo + "-" + cEncryptKey + ".pdf").

RUN pdf_set_parameter ("Spdf","unittest","TRUE").
/* RUN pdf_set_parameter ("Spdf","compress","TRUE"). */

RUN pdf_set_parameter ("spdf", "retainAnnots", "Link"). /* try with the templates usetags or link below */

RUN pdf_set_parameter ("Spdf","Encrypt","TRUE").
RUN pdf_set_parameter ("Spdf","EncryptAlgorithm",cEncryptAlgo).
RUN pdf_set_parameter ("Spdf","EncryptKey",cEncryptKey).
RUN pdf_set_parameter ("Spdf","MasterPassword","M4st3rPwd").
RUN pdf_set_parameter ("Spdf","UserPassword",cUserPassword).

RUN pdf_set_info("Spdf","Author","Jic" + CHR(233, SESSION:CPINTERNAL, "iso8859-1")).

RUN pdf_new_page("Spdf").

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/Invoice.pdf","Inv1").
/* RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/word-samples.pdf","Inv1"). */
/* RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/samples-v5.pdf","Inv1"). */
/* RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/super/link.4.0.pdf","Inv1"). /* this one has a doubled key in the /Link dictionary */ */
/* RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/super/usetags.pdf","Inv1"). */
RUN pdf_use_PDF_page("Spdf","Inv1",1).

RUN pdf_set_font("Spdf","Helvetica",8).
RUN pdf_text_color("Spdf",1.0,0.0,0.0).
RUN pdf_text_xy ("Spdf",STRING(1,"99999"),350,557).
RUN pdf_text_xy ("Spdf",STRING(/*TODAY*/ 5/13/2014,"99.99.9999"),350,546).
RUN pdf_text_xy ("Spdf",STRING(12,"99999"),350,535).

RUN pdf_load_image("Spdf","product","samples/support/product.jpg").                                 
RUN pdf_place_image("Spdf","product",200,550,100,60).                                               
RUN pdf_load_image("Spdf","logo","samples/support/test.png"). /* the image name must be different */
RUN pdf_place_image("Spdf","logo",300,120,100,100).                                                 

RUN pdf_close("Spdf").  IF RETURN-VALUE > "" THEN MESSAGE "Spdf:" RETURN-VALUE VIEW-AS ALERT-BOX INFO BUTTONS OK.

