/******************************************************************************

    Program:        PSPbind.p
    
    Written By:     Gordon Campbell - PRO-SYS Consultants Ltd.
    Written On:     November, 2003
    
    Description:    This procedure binds (creates) the PDFlib PSP products' C 
                    Library (either via DLL or Shared Library) to the Progress
                    4GL.
                    
                    ********* IMPORTANT NOTE *******
                    
                    It is imperative that you modify the PSPlib preprocessor
                    to define the correct path and name of the appropriate
                    PSP Shared Library or DLL.
                    
                    Also, you must have the Pretty Safe PDF product (from PDFlib
                    Gmbh) installed.  You can download the product from
                    www.pdflib.com.  If you wish to purchase the product then
                    go to www.epro-sys.com.  
                    
                    PRO-SYS offers a discount to PEG Members.  The discount will 
                    only be accepted if products are ordered via PRO-SYS. PDFlib 
                    GmbH will not honour the discount.

******************************************************************************/

&GLOBAL-DEFINE PSPlib   libpsp.dll

/* -------------- Begin Bindings to DLL / Shared Library ------------------ */

/***************************** GENERAL FUNCTIONS ****************************/

PROCEDURE PSP_delete EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT PARAMETER pPSP  AS LONG.
END.

PROCEDURE PSP_new EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE RETURN PARAMETER pPSP  AS LONG.
END.


/******************************* I/O FUNCTIONS *****************************/

/* currently not defined 
PROCEDURE PSP_open_callback EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
END.
*/

PROCEDURE PSP_close EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP        AS LONG.
END.

PROCEDURE PSP_create_file EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP        AS LONG.
  DEFINE INPUT  PARAMETER pMaster     AS CHARACTER.
  DEFINE INPUT  PARAMETER pUser       AS CHARACTER.
  DEFINE INPUT  PARAMETER pAccess     AS CHARACTER.
  DEFINE INPUT  PARAMETER pAlgorithm  AS LONG.
  DEFINE INPUT  PARAMETER pKeyLen     AS LONG.
  DEFINE INPUT  PARAMETER pFileName   AS CHARACTER.
  DEFINE RETURN PARAMETER pStatus     AS LONG.
END.

PROCEDURE PSP_get_buffer EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE INPUT  PARAMETER pSize     AS LONG.
  DEFINE RETURN PARAMETER pData     AS CHARACTER.
END.

PROCEDURE PSP_open_file EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE INPUT  PARAMETER pPassword AS CHARACTER.
  DEFINE INPUT  PARAMETER pFileName AS CHARACTER.
  DEFINE RETURN PARAMETER pStatus   AS LONG.
END.

PROCEDURE PSP_open_mem EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE INPUT  PARAMETER pPassword AS CHARACTER.
  DEFINE INPUT  PARAMETER pData     AS CHARACTER.
  DEFINE INPUT  PARAMETER pLen      AS LONG.
  DEFINE INPUT  PARAMETER pCopy     AS LONG.
END.

/**************************** PARAMETER FUNCTIONS *************************/

PROCEDURE PSP_get_parameter EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE INPUT  PARAMETER pKey      AS CHARACTER.
  DEFINE INPUT  PARAMETER pLen      AS LONG.
  DEFINE RETURN PARAMETER pValue    AS CHARACTER.
END.

PROCEDURE PSP_get_value EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE INPUT  PARAMETER pKey      AS CHARACTER.
  DEFINE RETURN PARAMETER pValue    AS DOUBLE.
END.

PROCEDURE PSP_set_parameter EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE INPUT  PARAMETER pKey      AS CHARACTER.
  DEFINE INPUT  PARAMETER pValue    AS CHARACTER.
END.

/* currently no values for this function
PROCEDURE PSP_set_value EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pKey      AS CHARACTER.
  DEFINE INPUT  PARAMETER pValue    AS DOUBLE.
END.
*/

/**************************** ERROR FUNCTIONS ****************************/

PROCEDURE PSP_get_apiname EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE RETURN PARAMETER pAPIname  AS CHARACTER.
END.

PROCEDURE PSP_get_errmsg EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE RETURN PARAMETER pErrorMsg AS CHARACTER.
END.

PROCEDURE PSP_get_errnum EXTERNAL "{&PSPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPSP      AS LONG.
  DEFINE RETURN PARAMETER pErrorNum AS LONG.
END.

/* ---------------- End Bindings to DLL / Shared Library ------------------ */
