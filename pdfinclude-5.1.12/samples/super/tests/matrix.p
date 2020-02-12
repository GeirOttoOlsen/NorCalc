DEFINE INPUT PARAMETER ipiIterations AS INTEGER   NO-UNDO.
DEFINE INPUT PARAMETER iplTotal      AS LOGICAL   NO-UNDO.

{tests/pdf_tests.i}
    
DEF VAR j        AS INT                          NO-UNDO.
DEF VAR k        AS INT                          NO-UNDO.
DEF VAR vcell    AS INT                          NO-UNDO.
DEF VAR vdate    AS CHAR FORMAT "x(50)"          NO-UNDO.
DEF VAR vfin     AS INT                          NO-UNDO.
DEF VAR vnbre    AS INT                          NO-UNDO.
DEF VAR vtableau AS CHAR                         NO-UNDO.

DEF TEMP-TABLE tt NO-UNDO FIELD nopo AS CHAR 
                          FIELD dapo AS DATE
                          FIELD mtfa AS DEC
                          FIELD facture AS CHAR
                          FIELD mapa AS DEC.

{pdf_inc.i "THIS-PROCEDURE"}

RUN pdf_new ("Spdf", gcTestsDir + "tests\matrix." + STRING(ipiIterations) + ".pdf").

RUN pdf_set_parameter("Spdf", "UnitTest", "TRUE").

RUN pdf_set_PaperType("Spdf","A4").
RUN pdf_set_VerticalSpace("Spdf",12).
RUN pdf_set_BottomMargin("Spdf",84). 

RUN pdf_new_page("Spdf").

DO j = 1 TO ipiIterations:
  CREATE tt.
  ASSIGN tt.nopo = STRING(j)
         tt.dapo = 10/15/2013    
         tt.mtfa = j        
         tt.facture = STRING(j)     .
         tt.mapa = j.
END.
    
ASSIGN j = 0.
REPEAT:
  IF NOT CAN-FIND(FIRST tt)
  THEN LEAVE.
  ASSIGN vnbre = 0
         j     = j + 1.
  IF j GT 1
  THEN RUN pdf_new_page("Spdf").
  FOR EACH tt:
    ASSIGN vnbre = vnbre + 1.
  END.
  ASSIGN vtableau = "Tableau" + STRING(j, "99")
         vnbre    = vnbre + 1.
  IF vnbre GT (pdf_TextY("Spdf") / pdf_VerticalSpace("Spdf")) - (pdf_BottomMargin("Spdf") / pdf_VerticalSpace("Spdf"))
  THEN ASSIGN vnbre = (pdf_TextY("Spdf") / pdf_VerticalSpace("Spdf")) - (pdf_BottomMargin("Spdf") / pdf_VerticalSpace("Spdf"))
              vfin  = vnbre - 1.
  ELSE ASSIGN vfin = vnbre.
  /* Tableau */
  RUN pdf_tool_add ("Spdf",vtableau, "MATRIX", ?).

  /* 03-OCT-2013 jcc: testing paddings */
  /* RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnVerticalPadding",0,"10"). */
  /* RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnPadding",0,"10"). */

  RUN pdf_set_tool_parameter("Spdf",vtableau,"X",0,"88").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"Y",0,pdf_TextY("Spdf")).
  RUN pdf_set_tool_parameter("Spdf",vtableau,"Rows",0,STRING(vnbre)).
  RUN pdf_set_tool_parameter("Spdf",vtableau,"Columns",0,"6").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"GridWeight",0,"0.5").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"GridColor",0,"0,0,0").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"FontSize",0,"10.0").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"BGcolor",0,"255,255,255").

  /* Entête tableau */
  RUN pdf_set_tool_parameter("Spdf",vtableau,"BGcolor",1,"192,192,192").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"Font",1,"Helvetica-Bold").

  /* Lignes tableau */
  RUN pdf_set_tool_parameter("Spdf",vtableau,"Font",2,"Helvetica").

  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",1,"50").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",1,"CENTER").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",2,"63").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",2,"CENTER").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",3,"80").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",3,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",4,"80").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",4,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",5,"80").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",5,"RIGHT").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",6,"80").
  RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",6,"RIGHT").

  /* Colonnes tableau */
  RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",1,CODEPAGE-CONVERT("Date",SESSION:CHARSET,"iso8859-1")).
  RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",2,CODEPAGE-CONVERT("N° facture",SESSION:CHARSET,"iso8859-1")).
  RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",3,CODEPAGE-CONVERT("Montant",SESSION:CHARSET,"iso8859-1")).
  RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",4,CODEPAGE-CONVERT("Déduit s/fact.",SESSION:CHARSET,"iso8859-1")).
  RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",5,CODEPAGE-CONVERT("Escompte",SESSION:CHARSET,"iso8859-1")).
  RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",6,CODEPAGE-CONVERT("Montant pay" + CHR(233,"iso8859-1","iso8859-1"),SESSION:CHARSET,"iso8859-1")).

  ASSIGN vcell = 6
         k     = 0.
  fe:
  FOR EACH tt BREAK BY INT(tt.nopo):
    IF tt.dapo NE ?
    THEN RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",vcell + 1, STRING(tt.dapo, "99/99/99")).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",vcell + 2,tt.nopo).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",vcell + 3,STRING(tt.mtfa, "->>>>>>,>>9.99")).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",vcell + 4,tt.facture).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",vcell + 5,pdf_TextY("Spdf") ).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",vcell + 6,STRING(tt.mapa, "->>>>>>,>>9.99")).
    ASSIGN vcell = vcell + 6
           k     = k     + 1.
    DELETE tt.
    IF k EQ vfin
    THEN LEAVE fe.
  END.
  RUN pdf_tool_create ("Spdf",vtableau).
END.

IF iplTotal THEN DO:
    /* Total */
    ASSIGN vtableau = "Total".

    RUN pdf_tool_add ("Spdf",vtableau, "MATRIX", ?).

    RUN pdf_set_tool_parameter("Spdf",vtableau,"X",0,"281").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"Y",0,pdf_TextY("Spdf")).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"Rows",0,1).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"Columns",0,"3").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"GridWeight",0,"0.5").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"GridColor",0,"0,0,0").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"FontSize",0,"10.0").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"BGcolor",0,"255,255,255").

    RUN pdf_set_tool_parameter("Spdf",vtableau,"Font",1,"Helvetica-Bold").

    RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",1,"80").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",1,"LEFT").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",2,"80").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",2,"RIGHT").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnWidth",3,"80").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"ColumnAlign",3,"RIGHT").

    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",1,"Total").
    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",2,STRING(9999, "->>>>>>,>>9.99")).
    RUN pdf_set_tool_parameter("Spdf",vtableau,"CellValue",3,STRING(9999, "->>>>>>,>>9.99")).

    RUN pdf_tool_create ("Spdf",vtableau).
END.

RUN pdf_close("Spdf").
IF RETURN-VALUE > "" THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

