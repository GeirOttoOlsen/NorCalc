  {pdf_inc.i "THIS-PROCEDURE"}

  {tests/pdf_tests.i}

  RUN pdf_new ("Spdf", gcTestsDir + "tests/testmatrix2.pdf").

  RUN pdf_set_parameter("Spdf", "UnitTest", "TRUE").

  RUN pdf_set_PaperType("Spdf","A4").
  RUN pdf_set_VerticalSpace("Spdf",12).
  RUN pdf_load_font2("Spdf","Arial-Bold", OS-GETENV("windir") + "\fonts\arialbd.ttf", NO, "", "subset").

  RUN pdf_new_page("Spdf").

  RUN pdf_text_at("Spdf","ARIAL BOLD",10).
  RUN pdf_skipn("Spdf",2).

  RUN pdf_tool_add ("Spdf","Tableau", "MATRIX", ?).

  RUN pdf_set_tool_parameter("Spdf","Tableau","X",0,"65").
  RUN pdf_set_tool_parameter("Spdf","Tableau","Y",0,pdf_TextY("Spdf") - 10).
  RUN pdf_set_tool_parameter("Spdf","Tableau","Rows",0,"1").
  RUN pdf_set_tool_parameter("Spdf","Tableau","Columns",0,"4").
  RUN pdf_set_tool_parameter("Spdf","Tableau","GridWeight",0,"1.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau","GridColor",0,"0,0,0").
  RUN pdf_set_tool_parameter("Spdf","Tableau","FontSize",0,"10.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau","BGcolor",0,"255,255,255").

  /* Entête tableau */
  RUN pdf_set_tool_parameter("Spdf","Tableau","BGcolor",1,"255,255,255").
  RUN pdf_set_tool_parameter("Spdf","Tableau","Font",1,"Arial-Bold").

  /* Lignes tableau */

  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnWidth",1,"298").
  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnAlign",1,"LEFT").
  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnWidth",2,"54").
  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnAlign",2,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnWidth",3,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnAlign",3,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnWidth",4,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau","ColumnAlign",4,"RIGHT").

  RUN pdf_set_tool_parameter("Spdf","Tableau","CellValue",1,"D" + CHR(233, SESSION:CPINTERNAL, "iso8859-1") + "signation").
  RUN pdf_set_tool_parameter("Spdf","Tableau","CellValue",2,"Qte").
  RUN pdf_set_tool_parameter("Spdf","Tableau","CellValue",3,"P.U.").
  RUN pdf_set_tool_parameter("Spdf","Tableau","CellValue",4,"Montant").

  RUN pdf_tool_create ("Spdf","Tableau").

  RUN pdf_skipn("Spdf",2).

  RUN pdf_tool_add ("Spdf","Tableau2", "MATRIX", ?).

  RUN pdf_set_tool_parameter("Spdf","Tableau2","X",0,"65").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","Y",0,pdf_TextY("Spdf") - 10).
  RUN pdf_set_tool_parameter("Spdf","Tableau2","Rows",0,"1").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","Columns",0,"4").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","GridWeight",0,"1.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","GridColor",0,"0,0,0").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","FontSize",0,"10.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","BGcolor",0,"255,255,255").

  /* Entête tableau */
  RUN pdf_set_tool_parameter("Spdf","Tableau2","BGcolor",1,"255,255,255").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","Font",1,"Arial-Bold").

  /* Lignes tableau */

  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnWidth",1,"298").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnAlign",1,"LEFT").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnWidth",2,"54").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnAlign",2,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnWidth",3,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnAlign",3,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnWidth",4,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","ColumnAlign",4,"RIGHT").

  RUN pdf_set_tool_parameter("Spdf","Tableau2","CellValue",1,"D" + CHR(233, SESSION:CPINTERNAL, "iso8859-1") + "signation").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","CellValue",2,"Qt" + CHR(233, SESSION:CPINTERNAL, "iso8859-1")).
  RUN pdf_set_tool_parameter("Spdf","Tableau2","CellValue",3,"P.U.").
  RUN pdf_set_tool_parameter("Spdf","Tableau2","CellValue",4,"Montant").

  RUN pdf_tool_create ("Spdf","Tableau2").

  RUN pdf_skipn("Spdf",2).
  RUN pdf_text_at("Spdf","HELVETICA BOLD",10).
  RUN pdf_skipn("Spdf",2).

  RUN pdf_tool_add ("Spdf","Tableau3", "MATRIX", ?).

  RUN pdf_set_tool_parameter("Spdf","Tableau3","X",0,"65").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","Y",0,pdf_TextY("Spdf") - 10).
  RUN pdf_set_tool_parameter("Spdf","Tableau3","Rows",0,"1").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","Columns",0,"4").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","GridWeight",0,"1.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","GridColor",0,"0,0,0").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","FontSize",0,"10.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","BGcolor",0,"255,255,255").

  /* Entête tableau */
  RUN pdf_set_tool_parameter("Spdf","Tableau3","BGcolor",1,"255,255,255").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","Font",1,"Helvetica-Bold").

  /* Lignes tableau */

  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnWidth",1,"298").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnAlign",1,"LEFT").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnWidth",2,"54").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnAlign",2,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnWidth",3,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnAlign",3,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnWidth",4,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","ColumnAlign",4,"RIGHT").

  RUN pdf_set_tool_parameter("Spdf","Tableau3","CellValue",1,"D" + CHR(233, SESSION:CPINTERNAL, "iso8859-1") + "signation").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","CellValue",2,"Qte").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","CellValue",3,"P.U.").
  RUN pdf_set_tool_parameter("Spdf","Tableau3","CellValue",4,"Montant").

  RUN pdf_tool_create ("Spdf","Tableau3").

  RUN pdf_skipn("Spdf",2).

  RUN pdf_tool_add ("Spdf","Tableau4", "MATRIX", ?).

  RUN pdf_set_tool_parameter("Spdf","Tableau4","X",0,"65").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","Y",0,pdf_TextY("Spdf") - 10).
  RUN pdf_set_tool_parameter("Spdf","Tableau4","Rows",0,"1").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","Columns",0,"4").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","GridWeight",0,"1.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","GridColor",0,"0,0,0").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","FontSize",0,"10.0").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","BGcolor",0,"255,255,255").

  /* Entête tableau */
  RUN pdf_set_tool_parameter("Spdf","Tableau4","BGcolor",1,"255,255,255").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","Font",1,"Helvetica-Bold").

  /* Lignes tableau */

  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnWidth",1,"298").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnAlign",1,"LEFT").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnWidth",2,"54").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnAlign",2,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnWidth",3,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnAlign",3,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnWidth",4,"58").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","ColumnAlign",4,"RIGHT").

  RUN pdf_set_tool_parameter("Spdf","Tableau4","CellValue",1,"D" + CHR(233, SESSION:CPINTERNAL, "iso8859-1") + "signation").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","CellValue",2,"Qt" + CHR(233, SESSION:CPINTERNAL, "iso8859-1")).
  RUN pdf_set_tool_parameter("Spdf","Tableau4","CellValue",3,"P.U.").
  RUN pdf_set_tool_parameter("Spdf","Tableau4","CellValue",4,"Montant").

  RUN pdf_tool_create ("Spdf","Tableau4").

  RUN pdf_close("Spdf").
  IF RETURN-VALUE > "" THEN
      MESSAGE RETURN-VALUE
          VIEW-AS ALERT-BOX INFO BUTTONS OK.
