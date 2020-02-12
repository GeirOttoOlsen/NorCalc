/******************************************************************************

    Program:        PSP.i
    
    Written By:     Gordon Campbell - PRO-SYS Consultants Ltd
    Written On:     November, 2003
    
    Description:    This include file predefines the PDFlib PSP functions that 
                    are created in PSPbind.p.

                    Also, you must have the Pretty Safe PDF product (from PDFlib
                    Gmbh) installed.  You can download the product from
                    www.pdflib.com.  If you wish to purchase the product then
                    go to www.epro-sys.com.  
                    
                    We offer a discount to PEG Members.  The discount will only 
                    be accepted if products are ordered via PRO-SYS. PDFlib GmbH
                    will not honour the discount.

******************************************************************************/

&IF DEFINED( PSPlib ) = 0 &THEN
  DEFINE VARIABLE h_PSPbind    AS HANDLE NO-UNDO.
  RUN PSPbind.p PERSISTENT SET h_PSPbind.

  /* Determine if it should be run as a SUPER procedure */
  IF "{1}" = "SESSION" THEN DO:
    SESSION:ADD-SUPER-PROCEDURE(h_PSPbind).
  END.

  ELSE IF "{1}" = "THIS-PROCEDURE" THEN DO:
    THIS-PROCEDURE:ADD-SUPER-PROCEDURE(h_PSPbind).
  END.

  /* ---------------------- Function Definitions -------------------------- */
  
  FUNCTION PSP_close  RETURNS LOGICAL (INPUT pPSP AS INTEGER):
    RUN PSP_close IN h_PSPbind
        (pPSP) .

    RETURN TRUE.
  END.

  FUNCTION PSP_create_file RETURN INTEGER
           (INPUT  pPSP    AS INTEGER,
            INPUT  pMaster     AS CHARACTER,
            INPUT  pUser       AS CHARACTER,
            INPUT  pAccess     AS CHARACTER,
            INPUT  pAlgorithm  AS INTEGER,
            INPUT  pKeyLen     AS INTEGER,
            INPUT  pFileName   AS CHARACTER).

    DEFINE VARIABLE L_Status  AS INTEGER NO-UNDO.
    RUN PSP_create_file IN h_PSPbind
        (pPSP, pMaster, pUser, pAccess, pAlgorithm, pKeyLen, pFileName,
         OUTPUT L_Status).

    RETURN L_Status.
  END.

  FUNCTION PSP_delete RETURNS LOGICAL (INPUT pPSP AS INTEGER):
    RUN PSP_delete IN h_PSPbind
        (pPSP) .

    RETURN TRUE.
  END.

  FUNCTION PSP_get_apiname RETURNS CHARACTER
         (INPUT pPSP AS INTEGER):

    DEFINE VARIABLE L_API AS CHARACTER NO-UNDO.
    RUN PSP_get_buffer IN h_PSPbind
        (pPSP, OUTPUT L_API) .

    RETURN L_API.
  END.

  FUNCTION PSP_get_buffer RETURNS CHARACTER
           (INPUT pPSP AS INTEGER,
            INPUT pSize AS INTEGER):

    DEFINE VARIABLE L_Value AS CHARACTER NO-UNDO.
    RUN PSP_get_buffer IN h_PSPbind
        (pPSP, pSize, OUTPUT L_value) .

    RETURN L_Value.
  END.

  FUNCTION PSP_get_errmsg RETURNS CHARACTER
         (INPUT pPSP AS INTEGER):

    DEFINE VARIABLE L_Msg AS CHARACTER NO-UNDO.
    RUN PSP_get_errmsg IN h_PSPbind
        (pPSP, OUTPUT L_Msg) .

    RETURN L_Msg.
  END.

  FUNCTION PSP_get_errnum RETURNS INTEGER
         (INPUT pPSP AS INTEGER):

    DEFINE VARIABLE L_Num AS INTEGER NO-UNDO.
    RUN PSP_get_errnum IN h_PSPbind
        (pPSP, OUTPUT L_Num) .

    RETURN L_Num.
  END.

  FUNCTION PSP_get_parameter RETURNS CHARACTER
           (INPUT pPSP  AS INTEGER,
            INPUT pKey  AS CHARACTER,
            INPUT pLen  AS INTEGER):

    DEFINE VARIABLE L_Value AS CHARACTER NO-UNDO.
    RUN PSP_get_parameter IN h_PSPbind
        (pPSP, pKey, pLen, OUTPUT L_value) .

    RETURN L_Value.
  END.

  FUNCTION PSP_get_value RETURNS DECIMAL
           (INPUT pPSP  AS INTEGER,
            INPUT pKey  AS CHARACTER):

    DEFINE VARIABLE L_Value AS DECIMAL NO-UNDO.
    RUN PSP_get_value IN h_PSPbind
        (pPSP, pKey, OUTPUT L_value) .

    RETURN L_Value.
  END.

  FUNCTION PSP_new RETURNS INTEGER ():
    DEFINE VARIABLE L_PSP AS INTEGER NO-UNDO.
    RUN PSP_new IN h_PSPbind
        (OUTPUT L_PSP) .

    RETURN L_PSP.
  END.

  FUNCTION PSP_open_file RETURNS INTEGER
           (INPUT pPSP      AS INTEGER,
            INPUT pPassword AS CHARACTER,
            INPUT pFileName AS CHARACTER):

    DEFINE VARIABLE L_Status AS INTEGER NO-UNDO.
    RUN PSP_open_file IN h_PSPbind
        (pPSP, pPassword, pFileName, OUTPUT L_Status) .

    RETURN L_Status.
  END.

  FUNCTION PSP_open_mem RETURNS LOGICAL
           (INPUT pPSP      AS INTEGER,
            INPUT pPassword AS CHARACTER,
            INPUT pData     AS CHARACTER,
            INPUT pLen      AS INTEGER,
            INPUT pCopy     AS INTEGER):

    RUN PSP_open_mem IN h_PSPbind
        (pPSP, pPassword, pData, pLen, pCopy) .

    RETURN TRUE.
  END.

  FUNCTION PSP_set_parameter RETURNS LOGICAL
           (INPUT pPSP    AS INTEGER,
            INPUT pKey    AS CHARACTER,
            INPUT pValue  AS CHARACTER):

    RUN PSP_get_parameter IN h_PSPbind
        (pPSP, pKey, pValue) .

    RETURN TRUE.
  END.

  &GLOBAL-DEFINE PSPlib
&ENDIF
