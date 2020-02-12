  {pdf_inc.i "THIS-PROCEDURE"}
  
  {tests/pdf_tests.i}

  RUN pdf_new ("Sbvr", gcTestsDir + "tests/testbvr2.2-result.pdf").

  RUN pdf_set_parameter("Sbvr", "UnitTest", "TRUE").
  
  RUN pdf_set_PaperType("Sbvr","A4").
  RUN pdf_set_VerticalSpace("Sbvr",12).
  RUN pdf_set_BottomMargin("Sbvr",343). 
  /* RUN pdf_load_font("Sbvr","Arial",OS-GETENV("windir") + "\fonts\arial.ttf","fonts\arial.afm",""). */
  /* RUN pdf_load_font("Sbvr","Arial-Bold",OS-GETENV("windir") + "\fonts\arialbd.ttf","fonts\arialbd.afm",""). */
  
  pdf_PageHeader("Sbvr", THIS-PROCEDURE:HANDLE,"").
  pdf_PageFooter("Sbvr", THIS-PROCEDURE:HANDLE,"bvr").

  RUN pdf_new_page("Sbvr").

  RUN pdf_set_TextY("Sbvr",832).
  RUN pdf_set_font("Sbvr","Helvetica-Bold",16.0).
  RUN pdf_skipn("Sbvr",3).
  RUN pdf_text_at("Sbvr","Ancienne version PDFINCLUDE",75).
  RUN pdf_set_font("Sbvr","Helvetica",10.0).
  RUN pdf_skipn("Sbvr",4).
  
  RUN pdf_close("Sbvr").
  IF RETURN-VALUE > "" THEN
      MESSAGE RETURN-VALUE
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
              
  PROCEDURE bvr:
    RUN pdf_text_to("Sbvr","99999",17).    
    RUN pdf_text_to("Sbvr",STRING("99", "99"),23).      
    RUN pdf_text_to("Sbvr","99999",43).    
    RUN pdf_text_to("Sbvr",STRING("99", "99"),49).
    RUN pdf_text_at("Sbvr","xxxxxxxxxxxxxxxxxxx",125).    
  END.


