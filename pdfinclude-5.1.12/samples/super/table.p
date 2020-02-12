{ samples/support/config.i }

DEFINE VARIABLE h_PDFtable  AS HANDLE NO-UNDO.
DEFINE VARIABLE h_TT        AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE TT_mydata NO-UNDO
    FIELD Custno    LIKE Customer.CustNum
    FIELD CustNameW LIKE Customer.Name
    FIELD CustName  LIKE Customer.Name
    FIELD PhoneNo   LIKE Customer.Phone
    FIELD State     LIKE Customer.State.

/* Build my Temp Table Data */
FOR EACH Customer WHERE name BEGINS "B" NO-LOCK:
/* FIND FIRST Customer WHERE name BEGINS "B" NO-LOCK. */
  CREATE TT_mydata.
  ASSIGN TT_mydata.CustNo    = Customer.CustNum
         /* TT_mydata.CustNameW = "<i>" + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + "</i>" */
         TT_mydata.CustNameW = "<i>" + Customer.Name + "</i>"
         TT_mydata.CustName  = Customer.Name
         TT_mydata.PhoneNo   = "<color=green><b>" + Customer.Phone + "</b></color>"
         TT_mydata.State     = Customer.State.
END.
/* FIND NEXT Customer WHERE name BEGINS "B" NO-LOCK.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             */
/*   CREATE TT_mydata.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           */
/*   ASSIGN TT_mydata.CustNo    = Customer.CustNum                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               */
/*          TT_mydata.CustNameW = "<i>" + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + Customer.Name + "</i>" */
/*          /* TT_mydata.CustNameW = "<i>" + Customer.Name + "</i>" */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           */
/*          TT_mydata.CustName  = Customer.Name                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  */
/*          TT_mydata.PhoneNo   = "<color=green><b>" + Customer.Phone + "</b></color>"                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           */
/*          TT_mydata.State     = Customer.State.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                */

{ pdf_inc.i "THIS-PROCEDURE" }

RUN pdf_new("Spdf",cPdfIncludePath + "samples/super/table.pdf").

RUN pdf_set_parameter("Spdf","unitTest","TRUE"). /* 12-AUG-2013 jcc: for testing purpose */

/* It is possible to make use of the tags - only in the "Wrap" columns, see WrapText parameter below */
DEFINE VARIABLE cFont AS CHARACTER INITIAL "Helvetica" NO-UNDO.
RUN pdf_set_parameter("sPDF","UseTags","TRUE").
RUN pdf_set_parameter("sPDF","TagColor:Black","0,0,0").
RUN pdf_set_parameter("sPDF","TagColor:Red","255,0,0").
RUN pdf_set_parameter("sPDF","TagColor:Green","0,200,0").
RUN pdf_set_parameter("sPDF","TagColor:Blue","0,0,200").
RUN pdf_set_parameter("sPDF","BoldFont",cFont + "-Bold").
RUN pdf_set_parameter("sPDF","ItalicFont",cFont + "-Oblique").
RUN pdf_set_parameter("sPDF","BoldItalicFont",cFont + "-BoldOblique").
RUN pdf_set_parameter("sPDF","DefaultFont",cFont).
RUN pdf_set_parameter("sPDF","DefaultColor","Blue"). /* should match the DetailTextColor parameter defined below */

/*
SUBSCRIBE TO "GeneratePDFPage" IN h_PDFinc RUN-PROCEDURE "NewPage".

RUN pdf_open_PDF("Spdf",cPdfIncludePath + "samples/support/template.pdf","PdfMask").
*/

/* RUN pdf_set_parameter("Spdf","Compress","TRUE"). */

/* Set Page Header procedure */
pdf_PageHeader ("Spdf",
                THIS-PROCEDURE:HANDLE,
                "PageHeader").

/* Set Page Header procedure */
pdf_PageFooter ("Spdf",
                THIS-PROCEDURE:HANDLE,
                "PageFooter").

/* Don't want the table to be going until the end of the page or too near the 
   side */
RUN pdf_set_LeftMargin("Spdf",20).
RUN pdf_set_BottomMargin("Spdf",50).

/* Link the Temp-Table to the PDF */
h_TT = TEMP-TABLE TT_mydata:HANDLE.
RUN pdf_tool_add ("Spdf","CustList", "TABLE", h_TT).

/* Now Setup some Parameters for the Table */

/* comment out this section to see what the default Table looks like */
RUN pdf_set_tool_parameter("Spdf","CustList","Outline",        0, ".5"            ).
RUN pdf_set_tool_parameter("Spdf","CustList","HeaderFont",     0, "Helvetica-Bold").
RUN pdf_set_tool_parameter("Spdf","CustList","HeaderFontSize", 0, "8"             ).
RUN pdf_set_tool_parameter("Spdf","CustList","HeaderBGColor",  0, "255,0,0"       ).
RUN pdf_set_tool_parameter("Spdf","CustList","HeaderTextColor",0, "255,255,255"   ).

RUN pdf_set_tool_parameter("Spdf","CustList","DetailBGColor",  0, "200,200,200").
RUN pdf_set_tool_parameter("Spdf","CustList","DetailTextColor",0, "0,0,200"    ).
RUN pdf_set_tool_parameter("Spdf","CustList","DetailFont",     0, "Helvetica"  ).
RUN pdf_set_tool_parameter("Spdf","CustList","DetailFontSize", 0, "8"          ).

RUN pdf_set_tool_parameter("Spdf","CustList","ColumnVerticalPadding", 0, "2"   ).
/* end of section */

/* Define Table Column Headers */
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnHeader", 1, "Customer #").
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnHeader", 2, "Name W"    ).
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnHeader", 3, "Name"      ).
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnHeader", 4, "Phone #"   ).
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnHeader", 5, "State"     ).

/* Define Table Column Widths */
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnWidth",  1, "10").
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnWidth",  2, "10").
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnWidth",  3, "10").
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnWidth",  4, "15").
RUN pdf_set_tool_parameter("Spdf","CustList","ColumnWidth",  5, "10").

/* Define Which Table Column Wraps */
/* this parameter is the maximum number of lines to wrap the field's value.
   If the field's value does not fit in this number of lines, then it gets truncated.
   Set to zero for no limit. If not set then the field won't wrap. */
RUN pdf_set_tool_parameter("Spdf","CustList","WrapText",     2, "0").
RUN pdf_set_tool_parameter("Spdf","CustList","WrapText",     4, "1"). /* Define the phone # as wrap in order to be able to use the tags */

/* Now produce the table */
RUN pdf_tool_create ("Spdf","CustList").

RUN pdf_close("Spdf").
IF RETURN-VALUE > '' THEN
    MESSAGE RETURN-VALUE
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.

/* ------------------------ INTERNAL PROCEDURES ---------------------------- */
PROCEDURE NewPage:
/*------------------------------------------------------------------------------
  Purpose:  Procedure called after a new page has been created
    (via SUBSCRIBE TO "GeneratePDFPage" IN h_PDFinc RUN-PROCEDURE "NewPage".)
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pdfStream AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pdfPage   AS INTEGER     NO-UNDO.

    RUN pdf_use_PDF_page("Spdf","PDFMask",1).
END. /* NewPage */

PROCEDURE PageHeader:
/*------------------------------------------------------------------------------
  Purpose:  Procedure to Print Page Header -- on all pages.
------------------------------------------------------------------------------*/

  /* Set Header Font Size and Colour */
  RUN pdf_set_font ("Spdf","Courier-Bold",14.0).  
  RUN pdf_text_color ("Spdf",1.0,.0,.0).

  /* Output Report Header */
  RUN pdf_text_xy  ("Spdf","Customer List",pdf_LeftMargin("Spdf"),pdf_PageHeight("Spdf") - 25).

  RUN pdf_text_color ("Spdf",.0,.0,.0).
  RUN pdf_set_font ("Spdf","Courier",10.0).  

END. /* PageHeader */

PROCEDURE PageFooter:
/*------------------------------------------------------------------------------
  Purpose:  Procedure to Print Page Footer -- on all pages.
------------------------------------------------------------------------------*/
  /* Set Footer Font Size and Colour */
  RUN pdf_set_font ("Spdf","Courier-Bold",10.0).  
  RUN pdf_text_color ("Spdf",0.0,.0,.0).
  
  RUN pdf_skip ("Spdf").
  RUN pdf_set_dash ("Spdf",1,0).
  RUN pdf_line  ("Spdf", pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") - 5, pdf_PageWidth("Spdf") - 20 , pdf_TextY("Spdf") - 5, 1).
  RUN pdf_skip ("Spdf").
  RUN pdf_skip ("Spdf").
  RUN pdf_text_to  ("Spdf",  "Page: " 
                           + STRING(pdf_page("Spdf"))
                           + " of " + pdf_TotalPages("Spdf"), 110).

END. /* PageFooter */
