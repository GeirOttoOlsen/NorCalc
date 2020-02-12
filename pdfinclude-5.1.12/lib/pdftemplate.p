/******************************************************************************

    Program:        pdftemplate.p

    Written By:     Gordon Campbell - PRO-SYS Consultants Ltd.
    Written On:     March 23, 2004

    Description:    This program will load a template file

******************************************************************************/

DEFINE INPUT PARAMETER pCallProc  AS HANDLE NO-UNDO.

DEFINE STREAM Scfg.

{ inc/pdf_func.i pCallProc }

DEFINE TEMP-TABLE TT_Template
  FIELD temp_Stream AS CHARACTER
  FIELD temp_id     AS CHARACTER
  FIELD temp_file   AS CHARACTER.

DEFINE TEMP-TABLE TT_Content
  FIELD temp_Stream   AS CHARACTER
  FIELD temp_id       AS CHARACTER
  FIELD temp_type     AS CHARACTER
  FIELD temp_content  AS CHARACTER.

PROCEDURE LoadTemplate:
  DEFINE INPUT  PARAMETER pdfStream       AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pdfTemplateID   AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pdfTemplateFile AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER opFontTags      AS CHARACTER   NO-UNDO. /* 18-NOV-2013 jcc: return used fonts */
  DEFINE OUTPUT PARAMETER opImgTags       AS CHARACTER   NO-UNDO. /* 07-MAY-2014 jcc: return used images */

  IF CAN-FIND(FIRST TT_Template 
              WHERE TT_Template.temp_Stream = pdfStream
                AND TT_Template.temp_id     = pdfTemplateID NO-LOCK) THEN DO:
    RETURN "Template ID has already been used!".
  END.

  IF SEARCH(pdfTemplateFile) = ? THEN 
    RETURN "Cannot find Template File specified!".

  pdfTemplateFile = SEARCH(pdfTemplateFile). /* 24-MAR-2015 jcc: use PROPATH */

  CREATE TT_Template.
  ASSIGN TT_Template.temp_Stream = pdfStream
         TT_Template.temp_id     = pdfTemplateID
         TT_Template.temp_file   = pdfTemplateFile.

  DEFINE VARIABLE c_Data          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Option        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Value         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Text          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Font          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE c_Image         AS CHARACTER NO-UNDO.

  DEFINE VARIABLE d_OldRed        AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_OldGreen      AS DECIMAL DECIMALS 4 NO-UNDO.
  DEFINE VARIABLE d_OldBlue       AS DECIMAL DECIMALS 4 NO-UNDO.
  
  d_OldRed   = pdf_TextRed(pdfStream).
  d_OldGreen = pdf_TextGreen(pdfStream).
  d_OldBlue  = pdf_TextBlue(pdfStream).

  /* List of possible Options */
  DEFINE VARIABLE c_ValidOptions     AS CHARACTER NO-UNDO.
  ASSIGN c_ValidOptions = "Text,Rectangle,Line,Image".

  INPUT STREAM Scfg FROM VALUE( pdfTemplateFile ) NO-ECHO.
    REPEAT:
      IMPORT STREAM Scfg UNFORMATTED c_Data.
      
      /* Ignore comment lines */
      IF c_Data BEGINS "#" THEN NEXT.

      /* Load Configuration Key Name */
      c_Option = ENTRY(1, c_Data, ":") NO-ERROR.
      IF ERROR-STATUS:ERROR THEN NEXT.

      /* Load Configuration Key Value */
      c_Data = REPLACE(c_Data,c_Option + ":","").
      c_value = c_Data.

      /* If not a valid Key type then ignore */
      IF LOOKUP(c_Option , c_ValidOptions) = 0 THEN NEXT.

      /* Since the Key is valid, verify that the value entered for the Key
         is Valid */
      CASE c_Option:
        WHEN "TEXT" THEN DO:
          c_Text = ENTRY(1, c_value, "|").
          /* RUN pdf_replace_text IN pCallProc (INPUT-OUTPUT c_Text). */
          /* 18-NOV-2013 jcc: API update */
          /* RUN pdf_replace_text IN pCallProc (pdfStream, c_Text, OUTPUT c_Text). */
          /* 21-OCT-2014 jcc: API update */
          RUN pdf_replace_text IN pCallProc (pdfStream, c_Text, LOGICAL(pdf_get_parameter2(pdfStream, "unicode", "NO")), OUTPUT c_Text).

          CREATE TT_Content.
          ASSIGN TT_Content.temp_Stream  = pdfStream
                 TT_Content.temp_id      = pdfTemplateID
                 TT_Content.temp_Type    = "TEXT"
                 TT_Content.temp_Content = "BT" + CHR(13)
                                         +  "/" + ENTRY(2, c_value, "|") + " " 
                                         + STRING(DEC( ENTRY(5, c_value, "|") )) 
                                         + " Tf" + CHR(13) 
                                         + "1 0 0 1 " 
                                         + STRING(DEC( ENTRY(3, c_value, "|") )) 
                                         + " "                       
                                         + STRING(DEC( ENTRY(4, c_value, "|") ))
                                         + " Tm" + CHR(13) 
                                         + " " + STRING(DEC( ENTRY(6,c_value,"|") ))
                                         + " " + STRING(DEC( ENTRY(7,c_value,"|") ))
                                         + " " + STRING(DEC( ENTRY(8,c_value,"|") ))
                                         + " rg" + CHR(13) 
                                         + "(" + c_Text + ") Tj" + CHR(13) 
                                         + STRING(d_OldRed) + " " 
                                         + STRING(d_oldGreen) + " " 
                                         + STRING(d_OldBlue) + " rg" + CHR(13)
                                         + "ET" + CHR(13).
          /* 18-NOV-2013 jcc: return used fonts */
          c_Font = ENTRY(2, c_value, "|").
          IF LOOKUP(c_Font, opFontTags, CHR(1)) = 0 THEN
            opFontTags = opFontTags + CHR(1) + c_Font.
        END. /* Text */

        WHEN "IMAGE" THEN DO:

          RUN pdf_Load_image IN pCallProc
              (pdfStream,
               ENTRY(1, c_value, "|"),
               SEARCH(ENTRY(2, c_value, "|"))). /* 6-AUG-2012 jcc: add SEARCH */

          CREATE TT_Content.
          ASSIGN TT_Content.temp_Stream  = pdfStream
                 TT_Content.temp_id      = pdfTemplateID
                 TT_Content.temp_Type    = "IMAGE"
                 TT_Content.temp_Content = "q" + CHR(13) + ENTRY(5, c_value, "|") 
                                         + " 0 0 " 
                                         + ENTRY(6, c_value, "|")
                                         + " " + ENTRY(3, c_value, "|") + " "
                                         + STRING(DEC(ENTRY(4, c_value, "|"))) + " cm "
                                         + "/Im" + ENTRY(1, c_value, "|") + " Do" + CHR(13)
                                         + "Q" + CHR(13).

          /* 07-MAY-2014 jcc: return used images */
          c_Image = ENTRY(1, c_value, "|").
          IF LOOKUP(c_Image, opImgTags, CHR(1)) = 0 THEN
            opImgTags = opImgTags + CHR(1) + c_Image.
        END. /* Image */

        WHEN "RECTANGLE" THEN DO:

          CREATE TT_Content.
          ASSIGN TT_Content.temp_Stream  = pdfStream
                 TT_Content.temp_id      = pdfTemplateID
                 TT_Content.temp_Type    = "RECTANGLE"
                 TT_Content.temp_Content = "q" + CHR(13) + ENTRY(11, c_value, "|")
                                         + " w" + CHR(13)
                                         + ENTRY(1, c_value, "|") + " " 
                                         + ENTRY(2, c_value, "|") + " "
                                         + ENTRY(3, c_value, "|") + " " 
                                         + ENTRY(4, c_value, "|")
                                         + " re" + CHR(13)
                                         + ENTRY(5, c_value, "|") + " "
                                         + ENTRY(6, c_value, "|") + " "
                                         + ENTRY(7, c_value, "|") + " "
                                         + "RG " + CHR(13)
                                         + ENTRY(8, c_value, "|") + " "
                                         + ENTRY(9, c_value, "|") + " "
                                         + ENTRY(10, c_value, "|") + " "
                                         + "rg " + CHR(13)
                                         + "B" + CHR(13)
                                         + "Q" + CHR(13).

        END. /* Rectangle */

        WHEN "LINE" THEN DO:

          CREATE TT_Content.
          ASSIGN TT_Content.temp_Stream  = pdfStream
                 TT_Content.temp_id      = pdfTemplateID
                 TT_Content.temp_Type    = "LINE"
                 TT_Content.temp_Content = "q" + CHR(13) + ENTRY(8, c_value, "|") + " w" + CHR(13)
                                         + ENTRY(1, c_value, "|") + " " 
                                         + ENTRY(2, c_value, "|") + " m" + CHR(13)
                                         + ENTRY(3, c_value, "|") + " " 
                                         + ENTRY(4, c_value, "|") + " l" + CHR(13)
                                         + ENTRY(5, c_value, "|") + " "
                                         + ENTRY(6, c_value, "|") + " "
                                         + ENTRY(7, c_value, "|") + " "
                                         + "RG" + CHR(13)
                                         + "S" + CHR(13)
                                         + "Q" + CHR(13).


        END. /* Line */


      END CASE. /* Option */
    END. /* Repeat */
  INPUT STREAM Scfg CLOSE.

  opFontTags = SUBSTRING(opFontTags, 2).
  opImgTags = SUBSTRING(opImgTags, 2).

  RETURN "".
END. /* LoadTemplate */

PROCEDURE GetContent:
  DEFINE INPUT  PARAMETER pdfStream        AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pdfTemplateID    AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pdfContent      AS CHARACTER NO-UNDO.

  IF NOT CAN-FIND(FIRST TT_Template 
                  WHERE TT_Template.temp_Stream = pdfStream
                    AND TT_Template.temp_id     = pdfTemplateID NO-LOCK) 
  THEN
    RETURN "Template ID has not been loaded!".

  /* pdfContent = "q " + CHR(13). */
  FOR EACH TT_Content WHERE TT_Content.temp_stream = pdfStream
                        AND TT_Content.temp_id     = pdfTemplateID 
                        AND TT_Content.temp_type  <> "TEXT" NO-LOCK:
    pdfContent = pdfContent + CHR(13) + TT_Content.temp_content.
  END.
  /* pdfContent = pdfContent + "Q " + CHR(13). */

  FOR EACH TT_Content WHERE TT_Content.temp_stream = pdfStream
                        AND TT_Content.temp_id     = pdfTemplateID 
                        AND TT_Content.temp_type   = "TEXT" NO-LOCK:
    pdfContent = pdfContent + CHR(13) + TT_Content.temp_content.
  END.

  RETURN "".
END. /* GetContent */

/* end of pdftemplate.p */
