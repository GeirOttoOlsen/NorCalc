/******************************************************************************

  Program:      pdf_func_error.i
  
  Written By:   Jean-Christophe Cardot
  Written On:   October 2014
  
  Description:  tt_pdf_error & pdf_error()
  
  10/22/14  JC Cardot   Created

******************************************************************************/
&IF DEFINED(pdf_func_error-included) = 0 &THEN
&GLOBAL-DEFINE pdf_func_error-included YES

DEFINE {1} TEMP-TABLE TT_pdf_error NO-UNDO
  FIELD obj_stream  AS CHARACTER
  FIELD obj_func    AS CHARACTER FORMAT "x(20)"
  FIELD obj_error   AS CHARACTER FORMAT "x(40)"
INDEX obj_stream AS PRIMARY
      obj_stream.

PROCEDURE pdf_error :  /* Private */
  DEFINE INPUT PARAMETER pdfStream     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfFunction   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pdfError      AS CHARACTER NO-UNDO.

  CREATE TT_pdf_error.
  ASSIGN TT_pdf_error.obj_stream = pdfStream
         TT_pdf_error.obj_func   = pdfFunction
         TT_pdf_error.obj_error  = pdfError.

END. /* pdf_error */

&ENDIF
