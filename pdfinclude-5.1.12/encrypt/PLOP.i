/******************************************************************************

    Program:        PLOP.i
    
    Written By:     JC Cardot
    Written On:     October, 2012
    
    Description:    This include file predefines the PDFlib PLOP functions that 
                    are created in PLOPbind.p.
                    PLOP stands for PDF Linearization, Optimization, Protection.

                    Also, you must have the PLOP product (from PDFlib
                    Gmbh) installed. You can download the product from
                    www.pdflib.com.
                    
******************************************************************************/

&IF DEFINED( PLOPlib ) = 0 &THEN
  DEFINE VARIABLE h_PLOPbind    AS HANDLE NO-UNDO.
  RUN PLOPbind.p PERSISTENT SET h_PLOPbind.

  /* Determine if it should be run as a SUPER procedure */
  IF "{1}" = "SESSION" THEN DO:
    SESSION:ADD-SUPER-PROCEDURE(h_PLOPbind).
  END.

  ELSE IF "{1}" = "THIS-PROCEDURE" THEN DO:
    THIS-PROCEDURE:ADD-SUPER-PROCEDURE(h_PLOPbind).
  END.

  /* ---------------------- Function Definitions -------------------------- */
  
  FUNCTION PLOP_close_document  RETURNS LOGICAL
           (INPUT pPLOP AS INTEGER,
            INPUT pDoc  AS INTEGER):
    RUN PLOP_close_document IN h_PLOPbind
        (pPLOP, pDoc) .

    RETURN TRUE.
  END.

  FUNCTION PLOP_create_file RETURNS INTEGER
           (INPUT  pPLOP     AS INTEGER,
            INPUT  pFileName AS CHARACTER,
            INPUT  pLen      AS INTEGER,
            INPUT  pOptList  AS CHARACTER):

    DEFINE VARIABLE L_Status  AS INTEGER NO-UNDO.
    RUN PLOP_create_file IN h_PLOPbind
        (pPLOP, pFileName, pLen, pOptList,
         OUTPUT L_Status).

    RETURN L_Status.
  END.

  FUNCTION PLOP_delete RETURNS LOGICAL (INPUT pPLOP AS INTEGER):
    RUN PLOP_delete IN h_PLOPbind
        (pPLOP) .

    RETURN TRUE.
  END.

  FUNCTION PLOP_get_apiname RETURNS CHARACTER
         (INPUT pPLOP AS INTEGER):

    DEFINE VARIABLE L_API AS CHARACTER NO-UNDO.
    RUN PLOP_get_apiname IN h_PLOPbind
        (pPLOP, OUTPUT L_API) .

    RETURN L_API.
  END.

/*   FUNCTION PLOP_get_buffer RETURNS CHARACTER      */
/*            (INPUT pPLOP AS INTEGER,               */
/*             INPUT pSize AS INTEGER):              */
/*                                                   */
/*     DEFINE VARIABLE L_Value AS CHARACTER NO-UNDO. */
/*     RUN PLOP_get_buffer IN h_PLOPbind             */
/*         (pPLOP, pSize, OUTPUT L_value) .          */
/*                                                   */
/*     RETURN L_Value.                               */
/*   END.                                            */

  FUNCTION PLOP_get_errmsg RETURNS CHARACTER
         (INPUT pPLOP AS INTEGER):

    DEFINE VARIABLE L_Msg AS CHARACTER NO-UNDO.
    RUN PLOP_get_errmsg IN h_PLOPbind
        (pPLOP, OUTPUT L_Msg) .

    RETURN L_Msg.
  END.

  FUNCTION PLOP_get_errnum RETURNS INTEGER
         (INPUT pPLOP AS INTEGER):

    DEFINE VARIABLE L_Num AS INTEGER NO-UNDO.
    RUN PLOP_get_errnum IN h_PLOPbind
        (pPLOP, OUTPUT L_Num) .

    RETURN L_Num.
  END.

/*   FUNCTION PLOP_get_parameter RETURNS CHARACTER   */
/*            (INPUT pPLOP  AS INTEGER,              */
/*             INPUT pKey  AS CHARACTER,             */
/*             INPUT pLen  AS INTEGER):              */
/*                                                   */
/*     DEFINE VARIABLE L_Value AS CHARACTER NO-UNDO. */
/*     RUN PLOP_get_parameter IN h_PLOPbind          */
/*         (pPLOP, pKey, pLen, OUTPUT L_value) .     */
/*                                                   */
/*     RETURN L_Value.                               */
/*   END.                                            */
/*                                                   */
/*   FUNCTION PLOP_get_value RETURNS DECIMAL         */
/*            (INPUT pPLOP  AS INTEGER,              */
/*             INPUT pKey  AS CHARACTER):            */
/*                                                   */
/*     DEFINE VARIABLE L_Value AS DECIMAL NO-UNDO.   */
/*     RUN PLOP_get_value IN h_PLOPbind              */
/*         (pPLOP, pKey, OUTPUT L_value) .           */
/*                                                   */
/*     RETURN L_Value.                               */
/*   END.                                            */

  FUNCTION PLOP_new RETURNS INTEGER ():
    DEFINE VARIABLE L_PLOP AS INTEGER NO-UNDO.
    RUN PLOP_new IN h_PLOPbind
        (OUTPUT L_PLOP) .

    RETURN L_PLOP.
  END.

  FUNCTION PLOP_open_document RETURNS INTEGER
      (INPUT  pPLOP     AS INTEGER,
       INPUT  pFileName AS CHARACTER,
       INPUT  pLen      AS INTEGER,
       INPUT  pOptList  AS CHARACTER):

    DEFINE VARIABLE L_Status  AS INTEGER NO-UNDO.
    RUN PLOP_open_document IN h_PLOPbind
       (pPLOP, pFileName, pLen, pOptList,
        OUTPUT L_Status).

    RETURN L_Status.
  END.

/*   FUNCTION PLOP_open_mem RETURNS LOGICAL         */
/*            (INPUT pPLOP      AS INTEGER,         */
/*             INPUT pPassword AS CHARACTER,        */
/*             INPUT pData     AS CHARACTER,        */
/*             INPUT pLen      AS INTEGER,          */
/*             INPUT pCopy     AS INTEGER):         */
/*                                                  */
/*     RUN PLOP_open_mem IN h_PLOPbind              */
/*         (pPLOP, pPassword, pData, pLen, pCopy) . */
/*                                                  */
/*     RETURN TRUE.                                 */
/*   END.                                           */
/*                                                  */
/*   FUNCTION PLOP_set_parameter RETURNS LOGICAL    */
/*            (INPUT pPLOP    AS INTEGER,           */
/*             INPUT pKey    AS CHARACTER,          */
/*             INPUT pValue  AS CHARACTER):         */
/*                                                  */
/*     RUN PLOP_get_parameter IN h_PLOPbind         */
/*         (pPLOP, pKey, pValue) .                  */
/*                                                  */
/*     RETURN TRUE.                                 */
/*   END.                                           */

  &GLOBAL-DEFINE PLOPlib
&ENDIF
