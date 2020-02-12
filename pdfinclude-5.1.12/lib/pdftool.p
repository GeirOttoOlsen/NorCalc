/******************************************************************************

    Program:        PDFtool.p

    Written By:     Gordon Campbell - PRO-SYS Consultants Ltd.
    Written On:     January 6, 2004

    Description:    This program will contain a bunch of tools for helping to
                    build PDF documents.

                    Tools currently available are:

                    - TABLE (see BuildTable).
                    - CALENDAR (see BuildCalendar)
                    - MATRIX (see BuildMatrix)

    Note:           This code was separated into this procedure to ensure
                    that we don't cause any memory or compilation issues with
                    the current PDFinclude procedure.

                    Also, when running PDFinclude procedures you need to run
                    them with reference to pCallProc. For example:

                    RUN pdf_text IN pCallProc (pdfStream, "Text", 10).


    History:       
    
    02/26/04  G Campbell    Added the CALENDAR tool
    06/03/04  G Campbell    Added new 'WeekDayStart' parameter for CALENDAR
                            tool.  This allows you to specify the starting day
                            (eg: 1 = Sunday - default) for the calendar weeks.
                            You would also need to change the "WeekDays" 
                            parameter to correctly associate the Day Labels 
                            (eg: Sunday,Monday etc).  
                            If you set WeekDayStart = 2 then the "WeekDays"
                            parameter should be "Monday,Tuesday ... etc"
                            
    06/04/04  G Campbell    Allowed 'DayFontSize','DayFontColor', and 'DayFont'
                            settings to be set for a specific day.
                            
                            This was implemented by Peter Kiss of Paradyme, 
                            Belgium.

    06/04/04  G Campbell    Added DayHighlight and Highlight colour options so
                            that you can highlight a day and associate text
                            with it.

    06/15/04  G Campbell    Added the MATRIX Tool
        
                            Allows you to build matrixes (tables) at a specific
                            x/y coordinate.  You can control the number of rows
                            and columns, as well as, the cell values.

    10/12/04  G Campbell    Added code to right-align decimal field plus
                            left-align integer fields.

                            Also use the BUFFER-FIELD:COLUMN-LABEL if the 
                            ColumnHeader parameter for the given column is 
                            blank.  

                            You need to ensure that the RCODE-INFORMATION option
                            is enabled on the TEMP-TABLE definition.

    05/18/05  G Campbell    At some point I had updated this code with code
                            received from James McAteer.  But I hadn't bothered
                            to verify my sample programs (eg: table.p).  I 
                            just did this and added a piece of code to handle
                            a blank 'UseFields' parameter.  Now the table.p
                            sample works OK.

    02/23/10  JC Cardot     As per Tomasz Judycki 1/8/2007, add Column Vertical Padding

    08/03/12  JC Cardot     TABLE tool: Implement wrap within cells (making use
                            of the new transaction functionality in pdf_inc.p)
                            
    08/07/12  JC Cardot     MATRIX tool:
                            * Implement wrap within cells (also uses transactions,
                              demonstrate the use of pdf_transaction_buffer)
                            * Add ColumnPadding & ColumnVerticalPadding parameters
                              (as in the TABLE tool)

    10/03/13  JC Cardot     MATRIX tool: fix default line & column padding and text position
                            within the cells in order to match pdfinclude3 behaviour
                            TABLE tool: fix bug in the "wrap" cells when no limit is defined
                            + don't enter an infinite loop when the first line does not enter
                            vertically within the page (for too big a "wrap" cell's content)
                            + fix table outline so that no blank line is outlined at the end
                            of the table when there has been a rollback (i.e. a new page has
                            been created because the line did not fit in the page).

    06/08/14  JC Cardot     TABLE tool: adapt to the new way pdf_wrap_text_xy works. Instead of checking
                            the page change using the last Y value returned by pdf_wrap_text_xy,
                            simply check that pdf_Page() has not changed - as it should have been
                            done in first place.

    03/26/15  JC Cardot     * Move pdf_func.i to inc
                            MATRIX TOOL:
                            * The MATRIX tool did not take into account its FGColor parameter,
                              this has been fixed
                            * New parameter PageBreak: allow page breaks if the matrix does not fit
                              onto the page. New Parameter Repeat1stRow: flag to repeat the first
                              row of the matrix in case of a page break.

******************************************************************************/

DEFINE INPUT PARAMETER pCallProc  AS HANDLE NO-UNDO.

{ inc/pdf_func.i pCallProc }

DEFINE VARIABLE h_DataQuery   AS HANDLE NO-UNDO.
DEFINE VARIABLE h_DataBuffer  AS HANDLE NO-UNDO.
DEFINE VARIABLE h_DataField   AS HANDLE NO-UNDO.

DEFINE VARIABLE c_OldDetailFont     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c_DetailFont        AS CHARACTER NO-UNDO.

DEFINE VARIABLE d_DetailFontSize    AS DECIMAL NO-UNDO.
DEFINE VARIABLE d_OldDetailFontSize AS DECIMAL NO-UNDO.

/* ---------------------- TABLE Related Procedures ------------------ */

PROCEDURE BuildTable:
  DEFINE INPUT PARAMETER pdfStream   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pDataBuffer AS HANDLE NO-UNDO.

  DEFINE VARIABLE c_Font       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE dLastY       AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE dOldY        AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE d_FontSize   AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE iCurrentPage AS INTEGER     NO-UNDO.
  DEFINE VARIABLE l_firstLine  AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE l_skip       AS LOGICAL     NO-UNDO INITIAL FALSE.

  /* Store old values */
  c_OldDetailFont = pdf_Font(pdfStream).
  d_OldDetailFontSize = pdf_PointSize(pdfStream).

  /* Determine Font and Font Size for Header Labels */
  c_DetailFont = pdf_get_tool_parameter (pdfStream,
                                   pdfToolname,
                                   "DetailFont",
                                   0).
  d_DetailFontSize = DEC(pdf_get_tool_parameter (pdfStream,
                                                 pdfToolname,
                                                 "DetailFontSize",
                                                 0)) NO-ERROR.

  /* 23-FEB-2010 jcc: Tomasz Judycki 1/8/2007 http://www.tv.com.pl/stepbystep/pdfinclude/ */
  DEFINE VARIABLE d_ColumnVerticalPadding AS DECIMAL NO-UNDO.
  d_ColumnVerticalPadding = DECIMAL(pdf_get_tool_parameter(pdfStream,pdfToolname,"ColumnVerticalPadding",0)) NO-ERROR.
  IF ERROR-STATUS:ERROR OR d_ColumnVerticalPadding = ? OR d_ColumnVerticalPadding <= 0 THEN
      d_ColumnVerticalPadding = 0.
  /* 23-FEB-2010 jcc: end */

  /* Create QUery and start processing data */
  CREATE QUERY h_DataQuery.

  h_DataBuffer = pDataBuffer:DEFAULT-BUFFER-HANDLE.

  h_DataQuery:ADD-BUFFER(h_DataBuffer).
  h_DataQuery:QUERY-PREPARE("PRESELECT EACH " + h_DataBuffer:NAME + " NO-LOCK").
  h_DataQuery:QUERY-OPEN.

  h_DataQuery:GET-FIRST(NO-LOCK).
  l_firstLine = YES.

  /* Handle Table Header */
  IF h_DataBuffer:AVAILABLE THEN DO:

    /* Perform some Table Preprocessing.  For example, we need to determine the
       actual Y-axis starting points for each Column -- based on the Column Header
       Width */
    RUN PreProcessTable(pdfStream, pdfToolName).

    RUN DisplayTableHeader (pdfStream, pdfToolName).

    REPEAT WHILE h_DataBuffer:AVAIL:
      iCurrentPage = pdf_Page(pdfStream).

      /* Do we need to insert a new line? Only do this */
      /* if this line isnt the first line.  This also  */
      /* removes the extra blank line at the bottom of */
      /* a table.                                      */
      /* 03-OCT-2013 jcc: also do not insert a new line when pdf_skip() will trigger a new page or when the table line won't fit in the page */
      dOldY = pdf_TextY(pdfStream).
      DEFINE VARIABLE L_Spacer    AS DECIMAL   NO-UNDO.
      DEFINE VARIABLE L_VertSpace AS DECIMAL   NO-UNDO.
      L_Spacer = INTEGER(pdf_get_parameter(pdfStream, "LineSpacer")) NO-ERROR.
      L_VertSpace = pdf_VerticalSpace(pdfstream).
      L_Spacer = IF L_VertSpace = 0 THEN pdf_PointSize(pdfStream) + L_Spacer ELSE L_VertSpace.
      IF l_skip AND pdf_TextY(pdfStream) - L_Spacer - d_ColumnVerticalPadding > pdf_BottomMargin(pdfStream) THEN
          RUN pdf_skip IN pCallProc (pdfStream).
      ELSE IF l_skip THEN DO: /* 03-OCT-2013 jcc: if the line won't fit then directly create a new page (do not go up to the transaction rollback) */
          RUN DisplayTableOutline (pdfStream, pdfToolName).
          RUN pdf_new_page2 IN pCallProc (pdfStream, pdf_Orientation(pdfStream)).
          iCurrentPage = pdf_Page(pdfStream).
          l_firstLine = YES.
      END.

      /* 3-AUG-2012 jcc: create each line within a transaction so that we can rollback if the last line does not fit into the page */
      RUN pdf_transaction_begin IN pCallProc (pdfStream).

      RUN DisplayTableDetail(pdfStream, pdfToolName, l_firstLine, d_ColumnVerticalPadding, OUTPUT dLastY).

      /* 3-AUG-2012 jcc: commit or rollback and force a new page if we went too far down the page (i.e. past the botton margin) */
      /* IF dLastY - DECIMAL(pdf_get_tool_parameter2(pdfStream,pdfToolname,"ColumnVerticalPadding",0,"0")) <= pdf_BottomMargin(pdfStream) THEN DO: */
      /* 08-JUN-2014 jcc: instead, check if the current page has changed */
      IF pdf_Page(pdfStream) > iCurrentPage THEN DO:
        RUN pdf_transaction_rollback IN pCallProc (pdfStream).
        RUN pdf_set_textY IN pCallProc (pdfStream, dOldY).
        RUN DisplayTableOutline (pdfStream, pdfToolName).
        RUN pdf_new_page2 IN pCallProc (pdfStream, pdf_Orientation(pdfStream)).
        iCurrentPage = pdf_Page(pdfStream).
        l_firstLine = YES.
        RUN DisplayTableDetail(pdfStream, pdfToolName, l_firstLine, d_ColumnVerticalPadding, OUTPUT dLastY).
      END.
      ELSE
        RUN pdf_transaction_commit IN pCallProc (pdfStream).

      ASSIGN l_skip = TRUE.

      h_DataQuery:GET-NEXT(NO-LOCK).
      l_firstLine = NO.
    END.
  END. /* Data Available */

  RUN DisplayTableOutline (pdfStream, pdfToolName).

  /* Reset old values */
  RUN pdf_set_font IN pCallProc (pdfStream, c_OldDetailFont, d_OldDetailFontSize).

  DELETE WIDGET h_DataQuery.

END. /* BuildTable */

PROCEDURE PreProcessTable:
  DEFINE INPUT PARAMETER pdfStream    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE c_ColLabel    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_ColWidth    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Font        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_ColX        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_ColPad      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_OldFont     AS CHARACTER NO-UNDO.

  DEFINE VARIABLE d_FontSize    AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_OldFontSize AS DECIMAL NO-UNDO.

  DEFINE VARIABLE i_Field       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_ColWidth    AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_ColPoints   AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_ColX        AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_ColPad      AS INTEGER NO-UNDO.

  DEFINE VARIABLE i_RunX        AS INTEGER NO-UNDO.

  DEFINE VARIABLE c_Fields      AS CHARACTER NO-UNDO.
  
  /* Determine which fields the user wants to display */
  /* within the temp table.                           */
  c_Fields = pdf_get_tool_parameter (pdfStream,
                                     pdfToolname,
                                     "UseFields",
                                     0).
  
  i_RunX = pdf_LeftMargin(pdfStream).
  IF i_RunX = 0 THEN i_RunX = 1.

  /* Store old values */
  c_OldFont = pdf_Font(pdfStream).
  d_OldFontSize = pdf_PointSize(pdfStream).

  /* Determine if the Font and Font Size have been setup for the Header.
     If not, then set them to the current Font and Font Size */
  c_Font = pdf_get_tool_parameter (pdfStream,
                                   pdfToolname,
                                   "HeaderFont",
                                   0).
  IF c_Font = "" THEN
    RUN pdf_set_tool_parameter IN pCallProc
        (pdfstream,
         pdfToolName,
         "HeaderFont",
         0,
         pdf_Font(pdfStream)).

  d_FontSize = DEC(pdf_get_tool_parameter (pdfStream,
                                           pdfToolname,
                                           "HeaderFontSize",
                                           0)) NO-ERROR.
  IF d_FontSize = 0 THEN
    RUN pdf_set_tool_parameter IN pCallProc
        (pdfstream,
         pdfToolName,
         "HeaderFontSize",
         0,
         STRING(pdf_PointSize(pdfStream))).

  /* Set the Font to the Header Size so that we can ensure that we don't
     overrun our columns */
  RUN pdf_set_Font IN pCallProc
                     (pdfStream, c_Font, d_FontSize).

  /* Determine if the Column Padding is setup -- if not default to 5 points.
    This should be setup as a default when adding the Table */
  i_ColPad = INT(pdf_get_tool_parameter (pdfStream,
                                   pdfToolname,
                                   "ColumnPadding",
                                   0)) NO-ERROR.
  IF i_ColPad = 0 THEN DO:
    RUN pdf_set_tool_parameter IN pCallProc
        (pdfstream,
         pdfToolName,
         "ColumnPadding",
         0,
         "5").
    i_ColPad = 5.
  END.

  /* Now PreProcess for each Column */
  DO i_Field = 1 TO h_DataBuffer:NUM-FIELDS:
    /* If this field isnt required, skip it */
    IF (c_Fields <> "") AND (LOOKUP(STRING(i_Field), c_Fields, ",") = 0) THEN
      NEXT.
    
    h_DataField = h_DataBuffer:BUFFER-FIELD(i_Field).

    /* Determine Column Label */
    c_ColLabel = pdf_get_tool_parameter(pdfStream,
                                        pdfToolname,
                                        "ColumnHeader",
                                        i_Field).

    /* Determine Column Width - initially in Characters but convert to
       Points */
    c_ColWidth = pdf_get_tool_parameter (pdfStream,
                                         pdfToolname,
                                         "ColumnWidth",
                                         i_Field).

    i_ColWidth = INT(c_ColWidth) NO-ERROR.
    IF i_ColWidth = 0 THEN DO:

      i_ColWidth = LENGTH(STRING('',h_DataField:FORMAT), "character":U).
      IF LENGTH(c_ColLabel, "character":U) > i_ColWidth THEN
        i_ColWidth = LENGTH(c_ColLabel, "character":U).

      RUN pdf_set_tool_parameter IN pCallProc
          (pdfStream,pdfToolName,"ColumnWidth",i_Field,STRING(i_ColWidth)).
    END.

    /* Determine Column Placement - in Points -- if set */
    c_ColX = pdf_get_tool_parameter (pdfStream,
                                     pdfToolname,
                                     "ColumnX",
                                     i_Field).
    i_ColX = INT(c_ColX) NO-ERROR.

    /* If zero then the Y Point hasn't been set so we need to determine the
       default Columns - in points - and we will use the Header font, font size,
       and ColumnWidth parameters to determine the value */
    IF i_ColX = 0 THEN DO:

      /* Determine Font and Font Size for Header Labels -- assuming that the
         Header Label will be at minimum the same size as the detail text. Add:

         Current X Placement
         Column Padding
         Header Width - based on selected Header Font and Font Size
      */
      i_ColX = i_RunX + i_ColPad .

      RUN pdf_set_tool_parameter IN pCallProc
          (pdfStream,
           pdfToolName,
           "ColumnX",
           i_Field,
           STRING(i_ColX)).

      RUN pdf_set_tool_parameter IN pCallProc
          (pdfStream,
           pdfToolName,
           "MaxX",
           i_Field,
           STRING(i_ColPad + pdf_text_widthdec(pdfStream,FILL("D",i_ColWidth)))).

      i_RunX = i_RunX + i_ColPad + pdf_text_widthdec(pdfStream,FILL("D",i_ColWidth)).
    END.

  END. /* Num Fields */

  /* Reset old values */
  RUN pdf_set_font IN pCallProc (pdfStream, c_OldFont, d_OldFontSize).

END. /* PreProcessTable */

PROCEDURE DisplayTableHeader:
  DEFINE INPUT PARAMETER pdfStream    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE c_ColLabel    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_ColWidth    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Font        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_OldFont     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Fields      AS CHARACTER NO-UNDO.

  DEFINE VARIABLE d_FontSize      AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_OldFontSize   AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_Outline       AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_BGRed         AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGGreen       AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGBlue        AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HdrTextRed    AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HdrTextGreen  AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HdrTextBlue   AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DtlTextRed    AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DtlTextGreen  AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DtlTextBlue   AS DECIMAL DECIMALS 4 NO-UNDO.

  DEFINE VARIABLE i_ColWidth    AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Field       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_StartY      AS INTEGER NO-UNDO.

  DEFINE VARIABLE i_RunWidth    AS INTEGER NO-UNDO INIT 1.

  /* Store old values */
  c_OldFont = pdf_Font(pdfStream).
  d_OldFontSize = pdf_PointSize(pdfStream).

  /* Determine which fields the user wants to display */
  /* within the temp table.                           */
  c_Fields = pdf_get_tool_parameter (pdfStream,
                                     pdfToolname,
                                     "UseFields",
                                     0).
  
  /* Determine Font and Font Size for Header Labels */
  c_Font = pdf_get_tool_parameter (pdfStream,
                                   pdfToolname,
                                   "HeaderFont",
                                   0).
  d_FontSize = DEC(pdf_get_tool_parameter (pdfStream,
                                           pdfToolname,
                                           "HeaderFontSize",
                                           0)) NO-ERROR.

  RUN pdf_set_Font IN pCallProc
                     (pdfStream, c_Font, d_FontSize).

  /* Determine the Outline WIdth - if used */
  d_Outline = DEC(pdf_get_tool_parameter (pdfStream,
                                          pdfToolname,
                                          "Outline",
                                          0)) NO-ERROR.

  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "HeaderBGColor",
                      INPUT  0,
                      OUTPUT d_BGred,
                      OUTPUT d_BGgreen,
                      OUTPUT d_BGblue).

  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "HeaderTextColor",
                      INPUT  0,
                      OUTPUT d_HdrTextred,
                      OUTPUT d_HdrTextgreen,
                      OUTPUT d_HdrTextblue).

  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "DetailTextColor",
                      INPUT  0,
                      OUTPUT d_DtlTextred,
                      OUTPUT d_DtlTextgreen,
                      OUTPUT d_DtlTextblue).

  RUN pdf_text_color in pCallProc (pdfStream,d_HdrTextred,d_HdrTextgreen,d_HdrTextblue).

  /* Set the current page count to 1, this is so that */
  /* if the table spans pages, on page 1 the table    */
  /* starts on the row specified by StartY whereas    */
  /* on any other page it will start at the top.      */
  RUN pdf_set_tool_parameter IN pCallProc
                             (pdfStream,
                              pdfToolname,
                              "Pages",
                              0,
                              STRING(INT(pdf_get_tool_parameter (pdfStream,
                                                                 pdfToolname,
                                                                 "Pages",
                                                                 0)) + 1)).
  
  /* Determine where on a page the table wants to start. If the */
  /* parameter is not set, the table will start at the top.     */
  IF (INT(pdf_get_tool_parameter(pdfStream,pdfToolname,"Pages",0)) = 1) AND
      (INT(pdf_get_tool_parameter(pdfStream,pdfToolname,"StartY",0)) <> 0) THEN
    i_StartY = INT(pdf_get_tool_parameter(pdfStream,pdfToolname,"StartY",0)).
  ELSE
    i_StartY = pdf_textY(pdfStream).
  
  /* Now produce the Column Headers */
  DO i_Field = 1 TO h_DataBuffer:NUM-FIELDS:

    /* If this field isnt required, skip it */
    IF (c_Fields <> "") AND (LOOKUP(STRING(i_Field), c_Fields, ",") = 0) THEN
      NEXT.
    
    /* If Outline is not zero then draw a Rectangle around each of the
       Header Columns */
    IF d_Outline <> 0 THEN DO:
      RUN pdf_stroke_fill in pCallProc (pdfStream,d_BGred,d_BGgreen,d_BGblue).

      RUN pdf_rect IN pCallProc
          (pdfStream,
           INT( pdf_get_tool_parameter (pdfStream,
                                  pdfToolname,
                                  "ColumnX",
                                  i_Field) )
           -
           INT( pdf_get_tool_parameter (pdfStream,
                                  pdfToolname,
                                  "ColumnPadding",
                                  0) ),
           i_StartY - 2,
           pdf_get_tool_parameter (pdfStream,
                                  pdfToolname,
                                  "MaxX",
                                  i_Field),
           pdf_PointSize(pdfStream) + 2,
           d_Outline).

    END. /* Outline */


    h_DataField = h_DataBuffer:BUFFER-FIELD(i_Field).

    /* Determine Column Label */
    c_ColLabel = pdf_get_tool_parameter(pdfStream,
                                        pdfToolname,
                                        "ColumnHeader",
                                        i_Field).
    IF c_ColLabel = "" THEN
      c_ColLabel = h_DataField:COLUMN-LABEL.

    /* Determine Column Width */
    c_ColWidth = pdf_get_tool_parameter(pdfStream,
                                        pdfToolname,
                                        "ColumnWidth",
                                        i_Field).
    i_ColWidth = INT(c_ColWidth) NO-ERROR.
    IF i_ColWidth = 0 THEN DO:

      i_ColWidth = LENGTH(STRING('',h_DataField:FORMAT), "character":U).
      IF LENGTH(c_ColLabel, "character":U) > i_ColWidth THEN
        i_ColWidth = LENGTH(c_ColLabel, "character":U).

      RUN pdf_set_tool_parameter IN pCallProc
          (pdfStream,pdfToolName,"ColumnWidth",i_Field,STRING(i_ColWidth)).
    END.

    RUN pdf_text_xy IN pCallProc
        (pdfStream, c_ColLabel,
                    pdf_get_tool_parameter (pdfStream,
                                            pdfToolname,
                                            "ColumnX",
                                            i_Field),
                                            i_StartY + 1).

  END. /* Num Fields */

  /* Set to Detail Values */
  RUN pdf_set_font IN pCallProc (pdfStream, c_OldFont, d_OldFontSize).
  RUN pdf_set_Font IN pCallProc
                     (pdfStream, c_DetailFont, d_DetailFontSize).
  RUN pdf_text_color in pCallProc (pdfStream,d_DtlTextred,d_DtlTextgreen,d_DtlTextblue).

  RUN pdf_set_TextY IN pCallProc
                   (pdfStream,
                    i_StartY
                    - INT(pdf_get_tool_parameter (pdfStream,
                                                  pdfToolname,
                                                  "ColumnPadding",
                                                  0)) * 2).

  RUN pdf_set_tool_parameter IN pCallProc
      (pdfStream,pdfToolName,"MaxY",0,STRING(i_StartY)).

END. /* DisplayTableHeader*/

PROCEDURE DisplayTableDetail:
  DEFINE INPUT  PARAMETER pdfStream                AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pdfToolName              AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pdfFirstLine             AS LOGICAL     NO-UNDO.
  DEFINE INPUT  PARAMETER pdfColumnVerticalPadding AS DECIMAL     NO-UNDO.
  DEFINE OUTPUT PARAMETER pdLastY                  AS DECIMAL     NO-UNDO.

  DEFINE VARIABLE i_Field       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_ColWidth    AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Width       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_X           AS INTEGER NO-UNDO.

  DEFINE VARIABLE c_Data        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_DataType    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Fields      AS CHARACTER NO-UNDO.

  DEFINE VARIABLE d_CellUnderline AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_BGred         AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGgreen       AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGblue        AS DECIMAL DECIMALS 4 NO-UNDO.
  
  /* 14-JUN-2012 jcc: implement wrap in cells */
  DEFINE VARIABLE iWrapLinesLimit AS INTEGER NO-UNDO.

  DEF VAR w-first-field         AS CHAR.
  DEF VAR w-last-field          AS CHAR.
  DEF VAR w-start-pos           AS INT.
  DEF VAR w-end-pos             AS INT.
  
  /* 23-FEB-2010 jcc */
  DEFINE VARIABLE i_TableCol    AS INTEGER NO-UNDO.

  /* 23-FEB-2010 jcc: Tomasz Judycki 1/8/2007 http://www.tv.com.pl/stepbystep/pdfinclude/ */
  IF pdfColumnVerticalPadding <> 0 THEN
    RUN pdf_set_TextY IN pCallProc (pdfStream, pdf_TextY(pdfStream) - pdfColumnVerticalPadding).
  /* 23-FEB-2010 jcc: end */

  /* Determine which fields the user wants to display */
  /* within the temp table.                           */
  c_Fields = pdf_get_tool_parameter (pdfStream,
                                     pdfToolname,
                                     "UseFields",
                                     0).
  /* This is probably because UseFields wasn't set -- so set it to list all
     fields in temp-table */
  IF c_Fields = "" THEN DO:
    DO i_Field = 1 TO h_DataBuffer:NUM-FIELDS:
      h_DataField = h_DataBuffer:BUFFER-FIELD(i_Field).

      c_Fields = IF i_Field <> h_DataBuffer:NUM-FIELDS THEN
                   c_Fields + STRING(i_Field) + ","
                 ELSE
                   c_Fields + STRING(i_Field).
    END.
  END.

  ASSIGN w-first-field = ENTRY(1, c_Fields, ",")
         w-last-field  = ENTRY(NUM-ENTRIES(c_Fields, ","), c_Fields, ",").

  /* Determine the Outline WIdth - if used */
  d_CellUnderline = DEC(pdf_get_tool_parameter (pdfStream,
                                                pdfToolname,
                                                "CellUnderline",
                                                0)) NO-ERROR.

  /* Display Table Detail */

  pdLastY = pdf_textY(pdfStream).

  DO i_Field = 1 TO h_DataBuffer:NUM-FIELDS:

    /* If this field isnt required, skip it */
    /* 23-FEB-2010 jcc: Lonny L.Granstrom 22/1/2007 */
    /* IF (c_Fields <> "") AND (LOOKUP(STRING(i_Field), c_Fields, ",") = 0) THEN */
      /* NEXT. */
    /* h_DataField = h_DataBuffer:BUFFER-FIELD(i_Field). */

	IF i_Field <= NUM-ENTRIES(c_Fields, ",") THEN
	  i_TableCol = INTEGER(ENTRY(i_Field, c_Fields, ",")) NO-ERROR.
	ELSE
	  LEAVE.
	If i_TableCol <= 0 THEN
	  NEXT.
	h_DataField = h_DataBuffer:BUFFER-FIELD(i_TableCol).
    /* 23-FEB-2010 jcc: end */

    i_ColWidth = INT(pdf_get_tool_parameter (pdfStream,
                                         pdfToolname,
                                         "ColumnWidth",
                                         i_Field)).

    c_Data = STRING(h_DataField:BUFFER-VALUE(),h_DataField:FORMAT).
    c_Data = STRING(SUBSTR(c_Data,1,i_ColWidth, "character":U)).

    c_DataType = h_DataField:DATA-TYPE.
    CASE c_DataType:
      WHEN "Decimal" OR WHEN "Integer" THEN DO:
                                     
        RUN pdf_text_align IN pCallProc
           (pdfStream, 
           c_Data,
           "RIGHT",
           INT(pdf_get_tool_parameter (pdfStream,
                                   pdfToolname,
                                   "ColumnX",
                                   i_Field))
           + pdf_text_width(pdfStream,FILL("9",i_ColWidth)) - 2 ,
           pdf_textY(pdfStream)).

        pdLastY = MIN(pdLastY, pdf_textY(pdfStream)).

      END. /* Decimal and Integer - Right Align */

      OTHERWISE DO:        /* Left Align */
        /* 14-jun-2012 jcc: Wrap in the cell */
        IF pdf_get_tool_parameter(pdfStream, pdfToolname, "WrapText", i_Field) <> "" THEN DO:
            iWrapLinesLimit = INTEGER(pdf_get_tool_parameter2(pdfStream, pdfToolname, "WrapText", i_Field, "0")) NO-ERROR.
            IF ERROR-STATUS:ERROR OR iWrapLinesLimit = 0 THEN
                /* iWrapLinesLimit = pdf_textY(pdfStream) - pdf_BottomMargin(pdfStream). /* if no limit defined, then the limit is the end of page */ */
                iWrapLinesLimit = IF pdfFirstLine THEN pdf_textY(pdfStream) - pdf_BottomMargin(pdfStream)
                                  ELSE pdf_PageHeight(pdfStream). /* if no limit defined, then the limit is the end of page */
            ELSE
                iWrapLinesLimit = iWrapLinesLimit * pdf_PointSize(pdfStream).
            RUN pdf_wrap_text_xy IN pCallProc
               (pdfStream, 
                h_DataField:BUFFER-VALUE(),
                pdf_get_tool_parameter(pdfStream, pdfToolname, "ColumnX", i_Field),
                pdf_textY(pdfStream),
                INTEGER(pdf_get_tool_parameter(pdfStream, pdfToolname, "MaxX", i_Field))
                  - INTEGER(pdf_get_tool_parameter(pdfStream, pdfToolname, "ColumnPadding", 0)) * 2,
                iWrapLinesLimit,
                pdf_PointSize(pdfStream),
                "LEFT").
            pdLastY = MIN(pdLastY, DECIMAL(RETURN-VALUE)).
        END.
        /* else put the truncated text - old behaviour */
        ELSE DO:
            RUN pdf_text_xy IN pCallProc
               (pdfStream, 
                c_Data,
                pdf_get_tool_parameter(pdfStream, pdfToolname, "ColumnX", i_Field),
                pdf_textY(pdfStream)).
            pdLastY = MIN(pdLastY, pdf_textY(pdfStream)).
        END.

      END. /* Otherwise */
    END CASE. /* CASE c_DataType */

    /*  3-AUG-2012 jcc: if we go past end of page, then return now */
    IF pdLastY - pdfColumnVerticalPadding <= pdf_BottomMargin(pdfStream) THEN
        RETURN.

    i_X = INT( pdf_get_tool_parameter (pdfStream,
                                       pdfToolname,
                                       "ColumnX",
                                       i_Field) )
        - INT( pdf_get_tool_parameter (pdfStream,
                                       pdfToolname,
                                       "ColumnPadding",
                                       0) ).
    
    IF ENTRY(i_field, c_Fields, ",") = w-first-field THEN
        ASSIGN w-start-pos = i_X.
    
    /* Does the user want each cell outlining? */
    IF (ENTRY(i_field, c_Fields, ",") = w-last-field) AND (d_CellUnderline > 0) THEN
    DO:
      RUN pdf_set_TextY IN pCallProc (pdfStream, /* 14-JUN-2012 jcc: pdf_TextY(pdfStream)*/ pdLastY - pdfColumnVerticalPadding).
      ASSIGN w-end-pos = i_X + INT(pdf_get_tool_parameter (pdfStream,
                                   pdfToolname,
                                   "MaxX",
                                   i_Field)).
      
      RUN DetermineColor (INPUT  pdfStream,
                          INPUT  pdfToolname,
                          INPUT  "DetailBGColor",
                          INPUT  0,
                          OUTPUT d_BGred,
                          OUTPUT d_BGgreen,
                          OUTPUT d_BGblue).

      RUN pdf_stroke_fill IN pCallProc (pdfStream,d_BGred,d_BGgreen,d_BGblue).

      RUN pdf_line IN pCallProc (pdfStream,
                                 w-start-pos,
                                 pdLastY - pdfColumnVerticalPadding - 1,
                                 w-end-pos,
                                 pdLastY - pdfColumnVerticalPadding - 1,
                                 d_CellUnderline).
    END.
  END. /* DO i_Field = 1 TO h_DataBuffer:NUM-FIELDS */

END. /* DisplayTableDetail */

PROCEDURE DisplayTableOutline:
  DEFINE INPUT PARAMETER pdfStream    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE d_Outline     AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_BGred       AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGgreen     AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGblue      AS DECIMAL DECIMALS 4 NO-UNDO.

  DEFINE VARIABLE i_Field       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Height      AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_X           AS INTEGER NO-UNDO.

  DEFINE VARIABLE c_Fields      AS CHARACTER NO-UNDO.

  /* Determine which fields the user wants to display */
  /* within the temp table.                           */
  c_Fields = pdf_get_tool_parameter (pdfStream,
                                     pdfToolname,
                                     "UseFields",
                                     0).
  
  /* Determine the Outline WIdth - if used */
  d_Outline = DEC(pdf_get_tool_parameter (pdfStream,
                                          pdfToolname,
                                          "Outline",
                                          0)) NO-ERROR.

  IF d_Outline > 0 THEN DO:
    RUN DetermineColor (INPUT  pdfStream,
                        INPUT  pdfToolname,
                        INPUT  "DetailBGColor",
                        INPUT  0,
                        OUTPUT d_BGred,
                        OUTPUT d_BGgreen,
                        OUTPUT d_BGblue).

    RUN pdf_stroke_fill IN pCallProc (pdfStream,d_BGred,d_BGgreen,d_BGblue).

    /* Determine the outline height - for the given page */
    i_Height = INT(pdf_get_tool_parameter (pdfStream,
                                           pdfToolname,
                                           "MaxY",
                                           0))
             - pdf_TextY(pdfstream) + 2
/*
             + INT(pdf_get_tool_parameter (pdfStream,
                                           pdfToolname,
                                           "ColumnPadding",
                                           0))
*/
                     + INT(pdf_get_tool_parameter (pdfStream,
                                           pdfToolname,
                                           "DetailFontSize",
                                           0)).

    /* Display Table Detail */
    DO i_Field = 1 TO h_DataBuffer:NUM-FIELDS:
      
      /* If this field isnt required, skip it */
      IF (c_Fields <> "") AND (LOOKUP(STRING(i_Field), c_Fields, ",") = 0) THEN
        NEXT.
      
      h_DataField = h_DataBuffer:BUFFER-FIELD(i_Field).

      i_X = INT( pdf_get_tool_parameter (pdfStream,
                                         pdfToolname,
                                         "ColumnX",
                                         i_Field) )
          - INT( pdf_get_tool_parameter (pdfStream,
                                         pdfToolname,
                                         "ColumnPadding",
                                         0) ).

      RUN pdf_rect2 IN pCallProc
          (pdfStream,
           i_X,
           pdf_textY(pdfStream) - 1,
           pdf_get_tool_parameter (pdfStream,
                                  pdfToolname,
                                  "MaxX",
                                  i_Field),
           i_Height,
           d_Outline).

    END. /* Fields */

  END. /* Outline > 0 */

END. /* DisplayTableOutline */

/* ---------------------- CALENDAR Related Procedures ------------------ */
PROCEDURE BuildCalendar:
  DEFINE INPUT PARAMETER pdfStream   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE i_Year          AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Month         AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Height        AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Width         AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_X             AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Y             AS INTEGER NO-UNDO.

  /* Determine Height and Width of Calendar ... if set to zero then use
     the Page Dimensions */
  i_Height = INT( pdf_get_tool_parameter(pdfStream,
                                         pdfToolName,
                                         "Height",
                                         0)) NO-ERROR.
  IF i_Height = 0 THEN
    i_Height = pdf_PageHeight(pdfStream).

  i_Width = INT( pdf_get_tool_parameter(pdfStream,
                                        pdfToolName,
                                        "Width",
                                        0)) NO-ERROR.
  IF i_Width = 0 THEN
    i_Width = pdf_PageWidth(pdfStream).

  /* Determine X/Y Coordinates of Calendar ... if set to zero then use 1 */
  i_X = INT( pdf_get_tool_parameter(pdfStream,
                                    pdfToolName,
                                    "X",
                                    0)) NO-ERROR.
  IF i_X = 0 THEN i_X = 1.

  i_Y = INT( pdf_get_tool_parameter(pdfStream,
                                    pdfToolName,
                                    "Y",
                                    0)) NO-ERROR.
  IF i_Y = 0 THEN i_Y = 1.

  /* Determine the Year and month of Calendar */
  i_Year = INT( pdf_get_tool_parameter(pdfStream,
                                       pdfToolName,
                                       "Year",
                                       0)) NO-ERROR.
  IF i_Year = 0 THEN i_Year = YEAR(TODAY).

  i_Month = INT( pdf_get_tool_parameter(pdfStream,
                                        pdfToolName,
                                        "Month",
                                        0)) NO-ERROR.
  /* Month can be zero because a YEAR calendar doesn't need the month */
  IF i_Month > 12 THEN DO:
    /* How will we handle errors? */
    RETURN.
  END.

  IF i_Month = 0 THEN i_Month = MONTH(TODAY).

  /* Store old values */
  c_OldDetailFont = pdf_Font(pdfStream).
  d_OldDetailFontSize = pdf_PointSize(pdfStream).

  /*  Process the Calendar */
  RUN CalendarMonth (INPUT pdfStream,
                     INPUT pdfToolName,
                     INPUT i_Height,
                     INPUT i_Width,
                     INPUT i_X,
                     INPUT i_Y,
                     INPUT i_Year,
                     INPUT i_Month).

/* Reset old values */
  RUN pdf_set_font IN pCallProc (pdfStream, c_OldDetailFont, d_OldDetailFontSize).

END. /* BuildCalendar */

PROCEDURE CalendarMonth:
  DEFINE INPUT PARAMETER pdfStream    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfHeight    AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pdfWidth     AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pdfX         AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pdfY         AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pdfYear      AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pdfMonth     AS INTEGER NO-UNDO.

  DEFINE VARIABLE c_CalendarTitle     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_WeekDays          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_HeaderFont        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_DayLabelFont      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_DayFont           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_DayFontDay        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_DayHighlight      AS CHARACTER NO-UNDO.

  DEFINE VARIABLE i_Row               AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Day               AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_DayCtr            AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_WeekDay           AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_WeekDayStart      AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Loop              AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_HeaderHeight      AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_DayLabelHeight    AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_DayLabelY         AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_X                 AS INTEGER NO-UNDO.

  DEFINE VARIABLE d_DistX             AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DistY             AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_Row               AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HeaderFontSize    AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_DayLabelFontSize  AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_DayFontSize       AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_DayFontSizeDay    AS DECIMAL NO-UNDO.

  DEFINE VARIABLE d_BGRed             AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGGreen           AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGBlue            AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HdrFontRed        AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HdrFontGreen      AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HdrFontBlue       AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayLabelFontRed   AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayLabelFontGreen AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayLabelFontBlue  AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayLabelBGRed     AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayLabelBGGreen   AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayLabelBGBlue    AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayFontRed        AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayFontGreen      AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayFontBlue       AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayFontRedDay     AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayFontGreenDay   AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_DayFontBlueDay    AS DECIMAL DECIMALS 4 NO-UNDO.

  pdfX = pdfX + pdf_LeftMargin(pdfStream).
  pdfY = pdfY + pdf_BottomMargin(pdfStream).

  /* Perform some variable initialization */
  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "DayLabelBGColor",
                      INPUT  0,
                      OUTPUT d_DayLabelBGred,
                      OUTPUT d_DayLabelBGgreen,
                      OUTPUT d_DayLabelBGblue).

  i_HeaderHeight = INT(pdf_get_tool_parameter(pdfStream,
                                              pdfToolName,
                                              "HeaderHeight",
                                              0)).
  IF i_HeaderHeight = 0 THEN i_HeaderHeight = 30.

  d_HeaderFontSize = DEC(pdf_get_tool_parameter(pdfStream,
                                                pdfToolName,
                                                "HeaderFontSize",
                                                0)).
  IF d_HeaderFontSize = 0 THEN d_HeaderFontSize = 10.

  c_HeaderFont = pdf_get_tool_parameter(pdfStream,
                                        pdfToolName,
                                        "HeaderFont",
                                        0).
  IF c_HeaderFont = "" THEN c_HeaderFont = "Courier".

  i_DayLabelHeight = INT(pdf_get_tool_parameter(pdfStream,
                                                pdfToolName,
                                                "DayLabelHeight",
                                                0)).
  IF i_DayLabelHeight = 0 THEN i_DayLabelHeight = 12.

  d_DayLabelFontSize = DEC(pdf_get_tool_parameter(pdfStream,
                                                  pdfToolName,
                                                  "DayLabelFontSize",
                                                  0)).
  IF d_DayLabelFontSize = 0 THEN d_DayLabelFontSize = 10.

  c_DayLabelFont = pdf_get_tool_parameter(pdfStream,
                                          pdfToolName,
                                          "DayLabelFont",
                                          0).
  IF c_DayLabelFont = "" THEN c_DayLabelFont = "Courier".

  d_DayFontSize = DEC(pdf_get_tool_parameter(pdfStream,
                                             pdfToolName,
                                             "DayFontSize",
                                             0)).
  IF d_DayFontSize = 0 THEN d_DayFontSize = 10.

  c_DayFont = pdf_get_tool_parameter(pdfStream,
                                     pdfToolName,
                                     "DayFont",
                                     0).
  IF c_DayFont = "" THEN c_DayFont = "Courier".

  /* Determine the default BG colour for the Day rectangles and set the fill
     colour appropriately */
  IF pdf_get_tool_parameter (pdfStream,
                             pdfToolname,
                             "DayBGColor",
                             0) = "" THEN
    ASSIGN d_BGred   = 1
           d_BGGreen = 1
           d_BGBlue  = 1.
  ELSE
    RUN DetermineColor (INPUT  pdfStream,
                        INPUT  pdfToolname,
                        INPUT  "DayBGColor",
                        INPUT  0,
                        OUTPUT d_BGred,
                        OUTPUT d_BGgreen,
                        OUTPUT d_BGblue).
  RUN pdf_stroke_fill in pCallProc (pdfStream,d_BGred,d_BGgreen,d_BGblue).

  /* Draw Outside Border based on starting point and Width/Height */
  RUN pdf_rect IN pCallProc (pdfStream, 
                             pdfX, 
                             pdfY ,
                             pdfWidth, 
                             pdfHeight, 
                             .5).

  /* Draw Rectangle for Header ... putting in BG Color */
  IF pdf_get_tool_parameter (pdfStream,
                             pdfToolname,
                             "HeaderBGColor",
                             0) = "" THEN
    ASSIGN d_BGred   = 1
           d_BGGreen = 1
           d_BGBlue  = 1.
  ELSE
    RUN DetermineColor (INPUT  pdfStream,
                        INPUT  pdfToolname,
                        INPUT  "HeaderBGColor",
                        INPUT  0,
                        OUTPUT d_BGred,
                        OUTPUT d_BGgreen,
                        OUTPUT d_BGblue).
  RUN pdf_stroke_fill in pCallProc (pdfStream,d_BGred,d_BGgreen,d_BGblue).
  RUN pdf_rect IN pCallProc (pdfStream, 
                             pdfX, 
                             pdfY + pdfHeight - i_HeaderHeight,
                             pdfWidth, 
                             i_HeaderHeight, 
                             .5).
  
  /* Draw Rectangle for DayLabels ... putting in BG Color */
  IF pdf_get_tool_parameter (pdfStream,
                             pdfToolname,
                             "DayLabelBGColor",
                             0) = "" THEN
    ASSIGN d_BGred   = 1
           d_BGGreen = 1
           d_BGBlue  = 1.
  ELSE
    RUN DetermineColor (INPUT  pdfStream,
                        INPUT  pdfToolname,
                        INPUT  "DayLabelBGColor",
                        INPUT  0,
                        OUTPUT d_BGred,
                        OUTPUT d_BGgreen,
                        OUTPUT d_BGblue).
  RUN pdf_stroke_fill in pCallProc (pdfStream,d_BGred,d_BGgreen,d_BGblue).
  RUN pdf_rect IN pCallProc (pdfStream, 
                             pdfX , 
                             pdfY + pdfHeight - i_HeaderHeight - i_DayLabelHeight,
                             pdfWidth, 
                             i_DayLabelheight, 
                             .5).

  /* Move to start X/Y drawing location */
  RUN pdf_move_to IN pCallProc (pdfStream, 
                             pdfX + pdfWidth, 
                             pdfY + pdfHeight).

  /* Draw Lines for Day Descriptions */
  RUN pdf_line IN pCallProc (pdfStream, 
                             pdfX, 
                             pdf_GraphicY(pdfStream) - i_HeaderHeight,
                             pdfWidth + pdfX, 
                             pdf_GraphicY(pdfStream) - i_HeaderHeight, 
                             .5).
  RUN pdf_line IN pCallProc (pdfStream, 
                             pdfX, 
                             pdf_GraphicY(pdfStream) - i_DayLabelHeight,
                             pdfWidth + pdfX, 
                             pdf_GraphicY(pdfStream) - i_DayLabelHeight, 
                             .5).

  /* Now Draw Lines across calendar form to separate the weeks */
  d_DistY = (pdf_GraphicY(pdfStream) - pdfY) / 5.

  DO i_Loop = 2 TO 5:
    RUN pdf_line_dec IN pCallProc (pdfStream, 
                                pdfX, 
                                pdf_GraphicY(pdfStream) -  d_DistY, 
                                pdfWidth + pdfX, 
                                pdf_GraphicY(pdfStream) - d_DistY, 
                                .5).
  END.

  /* Draw Day Sections - 7 per week */
  d_DistX = (pdf_GraphicX(pdfStream) - pdfX) / 7.

  DO i_Loop = 1 TO 6:
    RUN pdf_line_dec IN pCallProc (pdfStream, 
                                   pdf_GraphicX(pdfStream) -  d_DistX,
                                   pdfY,
                                   pdf_GraphicX(pdfStream) -  d_DistX,
                                   pdfHeight + pdfY - i_HeaderHeight,
                                   .5).
  END. /* Day sections */

  /* Determine Week Day Labels */
  c_Weekdays = pdf_get_tool_parameter(pdfStream,
                                      pdfToolName,
                                      "WeekDays",
                                       0) NO-ERROR.
  IF c_Weekdays = "" THEN 
    c_Weekdays = "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday".

  IF NUM-ENTRIES(c_Weekdays,",") <> 7 THEN DO:
    /* Another Error */
    RETURN.
  END.

  /* Display Week Day Labels */
  i_DayLabelY = INT(pdf_get_tool_parameter(pdfStream,
                                           pdfToolName,
                                           "DayLabelY",
                                           0)).
  RUN pdf_set_font IN pCallProc 
      (pdfStream, c_DayLabelFont, d_DayLabelFontSize).
  
  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "DayLabelFontColor",
                      INPUT  0,
                      OUTPUT d_DayLabelFontRed,
                      OUTPUT d_DayLabelFontGreen,
                      OUTPUT d_DayLabelFontBlue).
  
  RUN pdf_text_color in pCallProc 
     (pdfStream,d_DayLabelFontRed,d_DayLabelFontGreen,d_DayLabelFontBlue).

  IF i_DayLabelY = 0 THEN DO i_Loop = 0 TO 6:
    d_Row = pdfY + pdfHeight - i_HeaderHeight.
    d_Row = d_Row - (i_DayLabelHeight / 2).
    d_Row = d_Row - (d_DayLabelFontSize / 4).

    /* This tries to center the day label in the Day Label box */
    RUN pdf_text_xy_dec IN pCallProc (pdfStream,
                                      ENTRY(i_Loop + 1,c_Weekdays,","),
                                      pdfX + (i_Loop * d_Distx) + 2,
                                      d_row).
  END.

  ELSE DO i_Loop = 0 TO 6:
    /* This places the Day Label at the specified Day Label Y Coordinate */
    RUN pdf_text_xy_dec IN pCallProc (pdfStream,
                                  ENTRY(i_Loop + 1,c_Weekdays,","),
                                  pdfX + (i_Loop * d_Distx) + 2,
                                  i_DayLabelY).
  END.

  /* Display Calendar Title */
  c_CalendarTitle = pdf_get_tool_parameter(pdfStream,
                                           pdfToolName,
                                           "Title",
                                           0).
  IF c_CalendarTitle = "" THEN
    c_CalendarTitle = "No Title Specified".

  RUN pdf_set_font IN pCallProc 
      (pdfStream, c_HeaderFont, d_HeaderFontSize).
  
  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "HeaderFontColor",
                      INPUT  0,
                      OUTPUT d_HdrFontred,
                      OUTPUT d_HdrFontgreen,
                      OUTPUT d_HdrFontblue).

  RUN pdf_text_color in pCallProc 
     (pdfStream,d_HdrFontRed,d_HdrFontGreen,d_HdrFontBlue).

  RUN pdf_text_xy_dec IN pCallProc (pdfStream,
                                c_CalendarTitle,
                                pdfX + 2,
                                pdfY + pdfHeight 
                                - (i_HeaderHeight / 2) 
                                - (d_HeaderFontSize / 2)).

  /* Now Display the Days in the Month */
  RUN pdf_set_font IN pCallProc 
      (pdfStream, c_DayFont, d_DayFontSize).

  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "DayFontColor",
                      INPUT  0,
                      OUTPUT d_DayFontRed,
                      OUTPUT d_DayFontGreen,
                      OUTPUT d_DayFontBlue).
  
  RUN pdf_text_color in pCallProc 
     (pdfStream,d_DayFontRed,d_DayFontGreen,d_DayFontBlue).

  /* Determine how many Days in the specified Year/Month */
  i_Loop = DAY(DATE((pdfMonth MODULO 12) + 1, 1,
                    pdfYear + INTEGER(TRUNCATE(pdfMonth / 12, 0))) - 1).
  i_Row = 0.

  /* Determine which is the start day for the week */
  i_WeekDayStart = INT(pdf_get_tool_parameter(pdfStream,
                                          pdfToolName,
                                         "WeekDayStart",
                                         0)) NO-ERROR.
  IF i_WeekDayStart = 0 THEN
    i_WeekDayStart = 1. /* Sunday */

  /* Now go through each day in the Month and add to Calendar */
  DO i_Day = 1 TO i_Loop:

    /* Try to change Font & Size for this specific day if possible */
    d_DayFontSizeDay = DEC(pdf_get_tool_parameter(pdfStream,
                                                  pdfToolName,
                                                  "DayFontSize",
                                                  i_Day)).
    IF d_DayFontSizeDay = 0
       THEN d_DayFontSizeDay = d_DayFontSize.

    c_DayFontDay = pdf_get_tool_parameter(pdfStream,
                                       pdfToolName,
                                       "DayFont",
                                       i_Day).
    IF c_DayFontDay = ""
       THEN c_DayFontDay = c_DayFont.

    RUN DetermineColor (INPUT  pdfStream,
                        INPUT  pdfToolname,
                        INPUT  "DayFontColor",
                        INPUT  i_Day,
                        OUTPUT d_DayFontRedDay,
                        OUTPUT d_DayFontGreenDay,
                        OUTPUT d_DayFontBlueDay).
    IF  d_DayFontRedDay   = 0
    AND d_DayFontGreenDay = 0
    AND d_DayFontBlueDay  = 0
        THEN ASSIGN d_DayFontRedDay   = d_DayFontRed
                    d_DayFontGreenDay = d_DayFontGreen
                    d_DayFontBlueDay  = d_DayFontBlue.

    RUN pdf_text_color in pCallProc (pdfStream,d_DayFontRedDay,d_DayFontGreenDay,d_DayFontBlueDay).
             
    /* Now Display the Days in New font */
    RUN pdf_set_font IN pCallProc (pdfStream, c_DayFontDay, d_DayFontSizeDay).

    ASSIGN i_WeekDay = WEEKDAY(DATE(pdfMonth,i_Day ,pdfYear))
           i_DayCtr  = i_DayCtr + 1.

    IF i_WeekDay = i_WeekDayStart AND i_Day <> 1 THEN
      ASSIGN i_Row    = i_Row + 1
             i_DayCtr = 1.

    /* Determine if they requested a 'Highlight' of the Date */
    c_DayHighlight = pdf_get_tool_parameter(pdfStream,
                                            pdfToolName,
                                            "DayHighlight",
                                            i_Day).

    /* This is to accommodate Months (like May 2004) that actually have more
       than 5 rows of days */
    IF i_Row = 5 THEN DO:
      /* This draws a line between the two dates that are sharing the box */
      RUN pdf_line_dec IN pCallProc (pdfStream, 
                                     pdfX + (d_DistX * (i_DayCtr - 1)) + 1, /* pdfX + (d_DistX * (i_WeekDay - i_WeekDayStart)) + 1, */
                                     pdfY + pdfHeight - i_DayLabelHeight - i_HeaderHeight - ((i_Row - 1) * d_DistY) - (d_DistY / 2),
                                     pdfX + (d_DistX * (i_DayCtr - 1)) + d_DistX - 2,
                                     pdfY + pdfHeight - i_DayLabelHeight - i_HeaderHeight - ((i_Row - 1) * d_DistY) - (d_DistY / 2),
                                     .5).

      i_X = pdfX + (d_DistX * (i_DayCtr - 1)) + 2.
      RUN pdf_text_xy_dec IN pCallProc (pdfStream,
                                    STRING(i_Day),
                                    i_X,
                                    pdfY + pdfHeight
                                    - i_DayLabelHeight 
                                    - i_HeaderHeight 
                                    - ((i_Row - 1) * d_DistY) 
                                    - (d_DistY / 2)
                                    - d_DayFontSize).
      IF c_DayHighlight <> "" THEN 
        RUN DayHighLight (pdfStream,
                          pdfToolName,
                          c_DayHighlight,
                          pdfMonth,
                          i_day,
                          pdfYear,
                          i_X, 
                          pdfY + pdfHeight - i_DayLabelHeight
                                           - i_HeaderHeight
                                           - ((i_Row - 1) * d_DistY) - 5
                                           - (d_DistY / 2)
                                           + d_DayFontSize ,
                          i_X + PDF_text_width(pdfStream,STRING(i_Day)),
                          pdfY + pdfHeight
                                    - i_DayLabelHeight
                                    - i_HeaderHeight
                                    - ((i_Row - 1) * d_DistY)
                                    - (d_DayFontSize * 2)
                                     ).
    END. /* Row 5 */

    ELSE DO:
      IF i_Row = 0 THEN DO:
        IF i_WeekDay > i_WeekDayStart THEN 
          i_X = pdfX + (d_DistX * (i_WeekDay - i_WeekDayStart) ) + 2.
        ELSE DO:
          IF (i_WeekDay + (7 - i_WeekDayStart)) >= 7 THEN
            i_X = pdfX + 2.
          ELSE
            i_X = pdfX + (d_DistX * (i_WeekDay + (7 - i_WeekDayStart))) + 2.
        END.
      END.
      ELSE
        i_X = pdfX + (d_DistX * (i_DayCtr - 1)) + 2.

      RUN pdf_text_xy_dec IN pCallProc (pdfStream,
                                        STRING(i_Day),
                                        i_X,
                                        pdfY + pdfHeight
                                        - i_DayLabelHeight
                                        - i_HeaderHeight
                                        - (i_Row * d_DistY) 
                                        - d_DayFontSize ).
      IF c_DayHighlight <> "" THEN
        RUN DayHighLight (pdfStream,
                          pdfToolName,
                          c_DayHighlight,
                          pdfMonth,
                          i_day,
                          pdfYear,
                          i_X, 
                          pdfY + pdfHeight - i_DayLabelHeight - i_HeaderHeight - ((i_Row - 1) * d_DistY) - (d_DistY),
                          i_X + PDF_text_width(pdfStream,STRING(i_Day)),
                          pdfY + pdfHeight 
                          - i_DayLabelHeight
                          - i_HeaderHeight
                          - (i_Row * d_DistY) 
                          - (d_DayFontSize * 2) + 4).
    END.
  END. /* Show Day Numbers */

END. /* CalendarMonth */
                                        
PROCEDURE DayHighLight:
  DEFINE INPUT PARAMETER pdfStream    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfText      AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pMonth       AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pDay         AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pYear        AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pX1          AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pY1          AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pX2          AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pY2          AS DECIMAL NO-UNDO.

  DEFINE VARIABLE d_HighlightRed      AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HighlightGreen    AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_HighlightBlue     AS DECIMAL DECIMALS 4 NO-UNDO.

  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "HighlightColor",
                      INPUT  0,
                      OUTPUT d_HighlightRed,
                      OUTPUT d_HighlightGreen,
                      OUTPUT d_HighlightBlue).
  IF  d_HighlightRed   = 0
  AND d_HighlightGreen = 0
  AND d_HighlightBlue  = 0
      THEN ASSIGN d_HighlightRed   = 1
                  d_HighlightGreen = 0
                  d_HighlightBlue  = 0.

  RUN pdf_markup IN pCallProc
                 (pdfStream,
                  pdfText,
                  DATE(pMonth,pDay ,pYear),
                  "Highlight",

                  pX1 ,
                  PY1,

                  pX2, 
                  pY1,

                  pX1,
                  pY2,

                  pX2,
                  pY2,

                  d_HighlightRed,
                  d_HighlightGreen,
                  d_HighlightBlue).

END. /* DayHighlight */

/* ---------------------- MATRIX Related Procedures ------------------------ */
PROCEDURE BuildMatrix:
  DEFINE INPUT PARAMETER pdfStream   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE i_Rows          AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Cols          AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_X             AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Y             AS INTEGER NO-UNDO.

  /* Determine X/Y Coordinates of Matrix ... if set to zero then use 1 */
  i_X = INT( pdf_get_tool_parameter(pdfStream,
                                    pdfToolName,
                                    "X",
                                    0)) NO-ERROR.
  IF i_X = 0 THEN i_X = 1.

  i_Y = INT( pdf_get_tool_parameter(pdfStream,
                                    pdfToolName,
                                    "Y",
                                    0)) NO-ERROR.
  IF i_Y = 0 THEN i_Y = 1.

  /* Determine the Rows and Columns of Matrix */
  i_Cols = INT( pdf_get_tool_parameter(pdfStream,
                                       pdfToolName,
                                       "Columns",
                                       0)) NO-ERROR.
  IF i_Cols = 0 THEN i_Cols = 1.

  i_Rows = INT( pdf_get_tool_parameter(pdfStream,
                                       pdfToolName,
                                       "Rows",
                                       0)) NO-ERROR.
  IF i_Rows = 0 THEN i_Rows = 1.

  /* Store old values */
  c_OldDetailFont     = pdf_Font(pdfStream).
  d_OldDetailFontSize = pdf_PointSize(pdfStream).

  /*  Process the Matrix */
  RUN ProcessMatrix (INPUT pdfStream,
                     INPUT pdfToolName,
                     INPUT i_X,
                     INPUT i_Y,
                     INPUT i_Rows,
                     INPUT i_Cols).

/* Reset old values */
  RUN pdf_set_font IN pCallProc (pdfStream, c_OldDetailFont, d_OldDetailFontSize).

END. /* BuildMatrix */

PROCEDURE ProcessMatrix:
  DEFINE INPUT PARAMETER pdfStream    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfToolName  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pX           AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pY           AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pRows        AS INTEGER NO-UNDO.
  DEFINE INPUT PARAMETER pCols        AS INTEGER NO-UNDO.

  DEFINE VARIABLE i_X           AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Y           AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Col         AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Row         AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Cell        AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_Width       AS INTEGER NO-UNDO.

  DEFINE VARIABLE d_FontSize    AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_GridWeight  AS DECIMAL NO-UNDO.
  DEFINE VARIABLE d_GridRed         AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_GridGreen       AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_GridBlue        AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGRed           AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGGreen         AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_BGBlue          AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_FGRed           AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_FGGreen         AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_FGBlue          AS DECIMAL DECIMALS 4 NO-UNDO.

  DEFINE VARIABLE dDeltaY AS DECIMAL   NO-UNDO.
  DEFINE VARIABLE iPage   AS INTEGER   NO-UNDO.

  DEFINE VARIABLE dColumnPadding    AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE dLinePadding      AS DECIMAL     NO-UNDO.

  dColumnPadding = DECIMAL(pdf_get_tool_parameter2(pdfStream,pdfToolName,"ColumnPadding",0,"5")). /* 03-OCT-2013 jcc: default line padding changed from 2 to 5 to match pdfinclude3 behaviour */
  dLinePadding   = DECIMAL(pdf_get_tool_parameter2(pdfStream,pdfToolName,"ColumnVerticalPadding",0,"1")). /* 03-OCT-2013 jcc: default line padding changed from 2 to 1 to match pdfinclude3 behaviour */

  RUN pdf_move_to IN pCallProc (pdfStream, pX, pY).

  d_GridWeight = DEC( pdf_get_tool_parameter(pdfStream,
                                             pdfToolName,
                                             "GridWeight",
                                             0)) NO-ERROR.

  /* Determine Grid Color */
  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "GridColor",
                      INPUT  0,
                      OUTPUT d_GridRed,
                      OUTPUT d_GridGreen,
                      OUTPUT d_GridBlue).

  /* Determine Default Foreground (Text) colour */
  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "FGColor",
                      INPUT  0,
                      OUTPUT d_FGRed,
                      OUTPUT d_FGGreen,
                      OUTPUT d_FGBlue).

  /* Determine Default Background colour */
  RUN DetermineColor (INPUT  pdfStream,
                      INPUT  pdfToolname,
                      INPUT  "BGColor",
                      INPUT  0,
                      OUTPUT d_BGRed,
                      OUTPUT d_BGGreen,
                      OUTPUT d_BGBlue).

  i_Y = pY.
  blkRow:
  DO i_Row = 1 TO pRows:

    i_X = pX.

    /* We have to:
       - write the text (computing the maximum height)
       - draw the rectangles (using the maximum height)
       However the rectangles must be drawn before the text is written, else
       the text will be invisible, because the rectangles will cover it.
       So we will use the transaction mecanism to buffer the text and output
       it after the rectangles are created. */
    RUN pdf_transaction_begin IN pCallProc (pdfStream).

    iPage = pdf_Page(pdfStream).

    RUN outputMatrixRowText (
        INPUT        pdfStream     ,
        INPUT        pdfToolName   ,
        INPUT        i_X           ,
        INPUT-OUTPUT i_Y           ,
        OUTPUT       dDeltaY       ,
        INPUT-OUTPUT i_Cell        ,
        INPUT        pCols         ,
        INPUT        i_Row         ,
        INPUT        dColumnPadding,
        INPUT        dLinePadding  ,
        INPUT        d_FGRed       ,
        INPUT        d_FGGreen     ,
        INPUT        d_FGBlue      ,
        OUTPUT       d_FontSize    ).

    /* 27-MAR-2015 jcc: implement page skip for MATRIX */
    DEFINE VARIABLE i_First_Cell AS INTEGER  NO-UNDO.
    IF LOGICAL(pdf_get_tool_parameter2(pdfStream, pdfToolname, "PageBreak", 0, "NO"))
      AND (i_Y - (d_FontSize + dLinePadding) - dDeltaY - 1 < pdf_BottomMargin(pdfStream) /* same page, below bottom margin */
        OR pdf_Page(pdfStream) > iPage /* page has changed */ )
           THEN DO:
        RUN pdf_transaction_rollback IN pCallProc (pdfStream).
        RUN pdf_new_page2 IN pCallProc (pdfStream, pdf_Orientation(pdfStream)).
        ASSIGN
         i_First_Cell = 0
         i_Y = pdf_TextY(pdfStream) - pdf_PointSize(pdfStream).
        IF LOGICAL(pdf_get_tool_parameter2(pdfStream, pdfToolname, "Repeat1stRow", 0, "YES")) THEN DO:
            RUN pdf_transaction_begin IN pCallProc (pdfStream).
            RUN outputMatrixRowText (
                INPUT        pdfStream     ,
                INPUT        pdfToolName   ,
                INPUT        i_X           ,
                INPUT-OUTPUT i_Y           ,
                OUTPUT       dDeltaY       ,
                INPUT-OUTPUT i_First_Cell  ,
                INPUT        pCols         ,
                INPUT        1             ,
                INPUT        dColumnPadding,
                INPUT        dLinePadding  ,
                INPUT        d_FGRed       ,
                INPUT        d_FGGreen     ,
                INPUT        d_FGBlue      ,
                OUTPUT       d_FontSize    ).
            RUN pdf_transaction_buffer IN pCallProc (pdfStream).
            RUN outputMatrixRowBorders (
                INPUT pdfStream   ,
                INPUT pdfToolName ,
                INPUT 1           ,
                INPUT i_X         ,
                INPUT i_Y         ,
                INPUT dDeltaY     ,
                INPUT pCols       ,
                INPUT dLinePadding,
                INPUT d_FontSize  ,
                INPUT d_GridWeight,
                INPUT d_GridRed   ,
                INPUT d_GridGreen ,
                INPUT d_GridBlue  ,
                INPUT d_BGRed     ,
                INPUT d_BGGreen   ,
                INPUT d_BGBlue    ).
            RUN pdf_transaction_commit IN pCallProc (pdfStream).
            /* i_Y = i_Y + dLinePadding. */
            i_Y = i_Y - (d_FontSize + dLinePadding) - dDeltaY - 1.
        END.
        ASSIGN
         i_Cell = i_Cell - pCols
         i_Row  = i_Row - 1.
        NEXT blkRow.
    END.

    /* Remember the text for later. Now that we have dDeltaY, we can draw the rectangles. Later we will commit the transaction. */
    RUN pdf_transaction_buffer IN pCallProc (pdfStream).

    RUN outputMatrixRowBorders (
        INPUT pdfStream   ,
        INPUT pdfToolName ,
        INPUT i_Row       ,
        INPUT i_X         ,
        INPUT i_Y         ,
        INPUT dDeltaY     ,
        INPUT pCols       ,
        INPUT dLinePadding,
        INPUT d_FontSize  ,
        INPUT d_GridWeight,
        INPUT d_GridRed   ,
        INPUT d_GridGreen ,
        INPUT d_GridBlue  ,
        INPUT d_BGRed     ,
        INPUT d_BGGreen   ,
        INPUT d_BGBlue    ).

    /* Now, really write the text into the pdf (above the rectangles we just drew) */
    RUN pdf_transaction_commit IN pCallProc (pdfStream).

    i_Y = i_Y - (d_FontSize + dLinePadding) - dDeltaY - 1.

    IF i_Y < 0 THEN DO:
        RUN pdf_error IN pCallProc (pdfStream,"ProcessMatrix","Matrix going past end of page!").
        RETURN.
    END.

  END. /* Each Row */

  /* Save the last Y coordinate so that the caller can use it to position things below the matrix */
  RUN pdf_set_tool_parameter IN pCallProc
      (pdfStream,pdfToolName,"LastY",0,STRING(i_Y)).

  /* Position the text right after the table */
  IF i_Y > pdf_BottomMargin(pdfStream) THEN /* 03-OCT-2013 jcc: ensure we won't trigger a new page */
      RUN pdf_set_TextXY IN pCallProc (pdfStream, pX, i_Y, YES).

END. /* ProcessMatrix */

PROCEDURE outputMatrixRowText:
    DEFINE INPUT        PARAMETER pdfStream      AS CHARACTER   NO-UNDO.
    DEFINE INPUT        PARAMETER pdfToolName    AS CHARACTER   NO-UNDO.
    DEFINE INPUT        PARAMETER i_X            AS INTEGER     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER i_Y            AS DECIMAL     NO-UNDO.
    DEFINE OUTPUT       PARAMETER dDeltaY        AS DECIMAL     NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER i_Cell         AS INTEGER     NO-UNDO.
    DEFINE INPUT        PARAMETER pCols          AS INTEGER     NO-UNDO.
    DEFINE INPUT        PARAMETER i_Row          AS INTEGER     NO-UNDO.
    DEFINE INPUT        PARAMETER dColumnPadding AS DECIMAL     NO-UNDO.
    DEFINE INPUT        PARAMETER dLinePadding   AS DECIMAL     NO-UNDO.
    DEFINE INPUT        PARAMETER d_FGRed        AS DECIMAL     NO-UNDO.
    DEFINE INPUT        PARAMETER d_FGGreen      AS DECIMAL     NO-UNDO.
    DEFINE INPUT        PARAMETER d_FGBlue       AS DECIMAL     NO-UNDO.
    DEFINE OUTPUT       PARAMETER d_FontSize     AS DECIMAL     NO-UNDO.
    

    DEFINE VARIABLE c_Align         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c_Font          AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c_Value         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE d_FGBlueRow     AS DECIMAL     DECIMALS 4 NO-UNDO.
    DEFINE VARIABLE d_FGGreenRow    AS DECIMAL     DECIMALS 4 NO-UNDO.
    DEFINE VARIABLE d_FGRedRow      AS DECIMAL     DECIMALS 4 NO-UNDO.
    DEFINE VARIABLE iWrapLinesLimit AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_Col           AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i_ColWidth      AS INTEGER     NO-UNDO.

    /* Determine Font for Row */
    c_Font = pdf_get_tool_parameter(pdfStream,
                                    pdfToolName,
                                    "Font",
                                    i_Row).
    IF c_Font = "" THEN DO:
      c_Font = pdf_get_tool_parameter(pdfStream,
                                      pdfToolName,
                                      "Font",
                                      0).
      IF c_Font = "" THEN
        c_Font = pdf_Font(pdfStream).
    END.

    /* Determine FontSize for Row */
    d_FontSize = DEC(pdf_get_tool_parameter(pdfStream,
                                            pdfToolName,
                                            "FontSize",
                                            i_Row)) NO-ERROR.
    IF d_FontSize = 0 THEN DO:
      d_FontSize = DEC(pdf_get_tool_parameter(pdfStream,
                                              pdfToolName,
                                              "FontSize",
                                              0)) .
      IF d_FontSize = 0 THEN
        d_FontSize = pdf_PointSize(pdfStream).
    END.

    /* 27-MAR-2015 jcc: Determine Foreground colour for Row - had been forgotten? */
    RUN DetermineColor (INPUT  pdfStream,
                        INPUT  pdfToolname,
                        INPUT  "FGColor",
                        INPUT  i_Row,
                        OUTPUT d_FGRedRow,
                        OUTPUT d_FGGreenRow,
                        OUTPUT d_FGBlueRow).

    ASSIGN
        dDeltaY = 0
        i_Y     = i_Y - dLinePadding + 1.

    DO i_Col = 1 TO pCols:

      i_Cell = i_Cell + 1.

      i_ColWidth = INT( pdf_get_tool_parameter(pdfStream,
                                               pdfToolName,
                                               "ColumnWidth",
                                               i_Col)) NO-ERROR.

      RUN pdf_Set_Font IN pCallProc
                       (pdfStream,
                        c_Font,
                        d_FontSize).

      /* Get the Cell Value (if any) */
      c_Value = pdf_get_tool_parameter(pdfStream,
                                       pdfToolName,
                                       "CellValue",
                                       i_Cell).

      /* message i_Cell c_Value view-as alert-box. */

      /* Put in the Cell Contents */
      IF c_Value <> "" THEN DO:
          /* 27-MAR-2015 jcc: set FG color - had been forgotten? */
          IF pdf_get_tool_parameter(pdfStream,
                                    pdfToolName,
                                    "FGColor",
                                    i_Row) <> "" THEN
            RUN pdf_text_color IN pCallProc
                                 (pdfStream,
                                  d_FGRedRow,
                                  d_FGGreenRow,
                                  d_FGBlueRow).
          ELSE
            RUN pdf_text_color IN pCallProc
                                 (pdfStream,
                                  d_FGRed,
                                  d_FGGreen,
                                  d_FGBlue).

          c_Align = pdf_get_tool_parameter2(pdfStream,
                                            pdfToolName,
                                            "ColumnAlign",
                                            i_Col,
                                            "LEFT").
          
          /* if the column wraps (parameter WrapText), then wrap it within the cell, with the right alignment */
          IF pdf_get_tool_parameter(pdfStream, pdfToolname, "WrapText", i_Col) <> "" THEN DO:
              iWrapLinesLimit = INTEGER(pdf_get_tool_parameter2(pdfStream, pdfToolname, "WrapText", i_Col, "0")) NO-ERROR.
              IF ERROR-STATUS:ERROR OR iWrapLinesLimit = 0 THEN
                  iWrapLinesLimit =  pdf_textY(pdfStream) - pdf_BottomMargin(pdfStream). /* if no limit defined, then the limit is the end of page */
              ELSE
                  iWrapLinesLimit = iWrapLinesLimit * d_FontSize.
          
              RUN pdf_wrap_text_xy IN pCallProc
                 (pdfStream, 
                  c_Value,
                  i_X + dColumnPadding,
                  i_Y + dLinePadding + 1,
                  i_ColWidth - 2 * dColumnPadding,
                  iWrapLinesLimit + 1,
                  d_FontSize,
                  c_Align).
              dDeltaY = MAXIMUM(i_Y - DECIMAL(RETURN-VALUE) + dLinePadding, dDeltaY).
          END.
          ELSE DO: /* else just put the value - old behaviour */
          CASE c_Align:
              WHEN "CENTER" THEN DO:
                RUN pdf_text_align IN pCallProc
                    (pdfStream,
                     c_Value,
                     "CENTER",
                     i_X + ((i_ColWidth) / 2),
                     i_Y + dLinePadding + 1).
              END.
              
              WHEN "RIGHT" THEN DO:
                RUN pdf_text_align IN pCallProc
                    (pdfStream,
                     c_Value,
                     "RIGHT",
                     i_X + i_ColWidth - dColumnPadding,
                     i_Y + dLinePadding + 1).
              END.
              
              OTHERWISE DO:
                  RUN pdf_text_align IN pCallProc
                      (pdfStream,
                       c_Value,
                       "LEFT",
                       i_X + dColumnPadding,
                       i_Y + dLinePadding + 1).
              END.
          END CASE.
      END.
      END. /* IF c_Value <> "" */

      i_X = i_X + i_ColWidth.

    END. /* Each Col */

END PROCEDURE.

PROCEDURE outputMatrixRowBorders:
    DEFINE INPUT PARAMETER pdfStream    AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER pdfToolName  AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER i_Row        AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER i_X          AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER i_Y          AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER dDeltaY      AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER pCols        AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER dLinePadding AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_FontSize   AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_GridWeight AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_GridRed    AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_GridGreen  AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_GridBlue   AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_BGRed      AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_BGGreen    AS DECIMAL     NO-UNDO.
    DEFINE INPUT PARAMETER d_BGBlue     AS DECIMAL     NO-UNDO.

    DEFINE VARIABLE d_BGBlueRow  AS DECIMAL   DECIMALS 4 NO-UNDO.
    DEFINE VARIABLE d_BGGreenRow AS DECIMAL   DECIMALS 4 NO-UNDO.
    DEFINE VARIABLE d_BGRedRow   AS DECIMAL   DECIMALS 4 NO-UNDO.
    DEFINE VARIABLE i_Col        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE i_ColWidth   AS INTEGER   NO-UNDO.

    /* Determine Background colour for Row */
    RUN DetermineColor (INPUT  pdfStream,
                        INPUT  pdfToolname,
                        INPUT  "BGColor",
                        INPUT  i_Row,
                        OUTPUT d_BGRedRow,
                        OUTPUT d_BGGreenRow,
                        OUTPUT d_BGBlueRow).

    /* Draw the Cells Containers */
    /* i_X = pX. */
    DO i_Col = 1 TO pCols:
        i_ColWidth = INT( pdf_get_tool_parameter(pdfStream,
                                                 pdfToolName,
                                                 "ColumnWidth",
                                                 i_Col)) NO-ERROR.
        RUN pdf_stroke_color IN pCallProc
                             (pdfStream,
                              d_GridRed,
                              d_GridGreen,
                              d_GridBlue).

        IF pdf_get_tool_parameter(pdfStream,
                                  pdfToolName,
                                  "BGColor",
                                  i_Row) <> "" THEN
          RUN pdf_stroke_fill IN pCallProc
                                (pdfStream,
                                 d_BGRedRow,
                                 d_BGGreenRow,
                                 d_BGBlueRow).
        ELSE
          RUN pdf_stroke_fill IN pCallProc
                                (pdfStream,
                                 d_BGred,
                                 d_BGGreen,
                                 d_BGBlue).

        RUN pdf_rect IN pCallProc (pdfStream,
                                   i_X,
                                   i_Y - dDeltaY,
                                   i_ColWidth,
                                   d_FontSize + 2 * dLinePadding + dDeltaY,
                                   d_GridWeight).
        i_X = i_X + i_ColWidth.
    END.
END PROCEDURE.

/* ------------------------- Generic Procedures ------------------------ */
PROCEDURE DetermineColor:
  DEFINE INPUT  PARAMETER pdfStream    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pdfToolName  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pdfToolParam AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pdfToolCol   AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER pdfRed       AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE OUTPUT PARAMETER pdfGreen     AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE OUTPUT PARAMETER pdfBlue      AS DECIMAL DECIMALS 4 NO-UNDO.

  DEFINE VARIABLE i_BGRed       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_BGGreen     AS INTEGER NO-UNDO.
  DEFINE VARIABLE i_BGBlue      AS INTEGER NO-UNDO.

  DEFINE VARIABLE c_ParamValue  AS CHARACTER NO-UNDO.

  c_ParamValue = pdf_get_tool_parameter (pdfStream,
                                         pdfToolname,
                                         pdfToolParam,
                                         pdfToolCol).

  /* If not found then default to BLACK .. or all zeroes */
  IF c_ParamValue = "" THEN
    RETURN.

  pdfRed   = DEC(ENTRY(1, c_ParamValue)) / 255.
  pdfGreen = DEC(ENTRY(2, c_ParamValue)) / 255.
  pdfBlue  = DEC(ENTRY(3, c_ParamValue)) / 255.

END. /* DetermineColor */


/* end of PDFtool.p */
