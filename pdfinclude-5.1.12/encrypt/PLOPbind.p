/******************************************************************************

    Program:        PLOPbind.p

    Written By:     Jean-Christophe Cardot
    Written On:     October, 2012
    
    Base on:        PSPbind.p    
    Written By:     Gordon Campbell - PRO-SYS Consultants Ltd.
    Written On:     November, 2003
    
    Description:    This procedure binds (creates) the PDFlib PLOP products' C
                    Library (either via DLL or Shared Library) to the Progress
                    4GL.
                    PLOP stands for PDF Linearization, Optimization, Protection.
                    
                    ********* IMPORTANT NOTE *******
                    
                    It is imperative that you modify the PLOPlib preprocessor
                    to define the correct path and name of the appropriate
                    PLOP Shared Library or DLL.
                    
                    Also, you must have the PLOP product (from PDFlib
                    Gmbh) installed. You can download the product from
                    www.pdflib.com.
                    
******************************************************************************/

/* &GLOBAL-DEFINE PLOPlib   libplop.dll */
&GLOBAL-DEFINE PLOPlib   C:\Program Files (x86)\PDFlib\PLOP 4.1 32-bit\bind\c\libplop.dll

/* -------------- Begin Bindings to DLL / Shared Library ------------------ */

/***************************** GENERAL FUNCTIONS ****************************/

PROCEDURE PLOP_delete EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT PARAMETER pPLOP  AS LONG.
END.

PROCEDURE PLOP_new EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE RETURN PARAMETER pPLOP  AS LONG.
END.


/******************************* I/O FUNCTIONS *****************************/

/* currently not defined 
PROCEDURE PLOP_open_callback EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
END.
*/

PROCEDURE PLOP_close_document EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPLOP        AS LONG.
  DEFINE INPUT  PARAMETER pDoc         AS LONG.
END.

PROCEDURE PLOP_create_file EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPLOP      AS LONG.
  DEFINE INPUT  PARAMETER pFileName AS CHARACTER.
  DEFINE INPUT  PARAMETER pLen      AS LONG.
  DEFINE INPUT  PARAMETER oOptList  AS CHARACTER.
  DEFINE RETURN PARAMETER pStatus   AS LONG.
END.

/* PROCEDURE PLOP_get_buffer EXTERNAL "{&PLOPlib}" CDECL PERSISTENT: */
/*   DEFINE INPUT  PARAMETER pPLOP      AS LONG.                     */
/*   DEFINE INPUT  PARAMETER pSize     AS LONG.                      */
/*   DEFINE RETURN PARAMETER pData     AS CHARACTER.                 */
/* END.                                                              */

PROCEDURE PLOP_open_document EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPLOP      AS LONG.
  DEFINE INPUT  PARAMETER pFileName AS CHARACTER.
  DEFINE INPUT  PARAMETER pLen      AS LONG.
  DEFINE INPUT  PARAMETER oOptList  AS CHARACTER.
  DEFINE RETURN PARAMETER pStatus   AS LONG.
END.

/* PROCEDURE PLOP_open_mem EXTERNAL "{&PLOPlib}" CDECL PERSISTENT: */
/*   DEFINE INPUT  PARAMETER pPLOP      AS LONG.                   */
/*   DEFINE INPUT  PARAMETER pPassword AS CHARACTER.               */
/*   DEFINE INPUT  PARAMETER pData     AS CHARACTER.               */
/*   DEFINE INPUT  PARAMETER pLen      AS LONG.                    */
/*   DEFINE INPUT  PARAMETER pCopy     AS LONG.                    */
/* END.                                                            */

/**************************** PARAMETER FUNCTIONS *************************/

/* PROCEDURE PLOP_get_parameter EXTERNAL "{&PLOPlib}" CDECL PERSISTENT: */
/*   DEFINE INPUT  PARAMETER pPLOP      AS LONG.                        */
/*   DEFINE INPUT  PARAMETER pKey      AS CHARACTER.                    */
/*   DEFINE INPUT  PARAMETER pLen      AS LONG.                         */
/*   DEFINE RETURN PARAMETER pValue    AS CHARACTER.                    */
/* END.                                                                 */

/* PROCEDURE PLOP_get_value EXTERNAL "{&PLOPlib}" CDECL PERSISTENT: */
/*   DEFINE INPUT  PARAMETER pPLOP      AS LONG.                    */
/*   DEFINE INPUT  PARAMETER pKey      AS CHARACTER.                */
/*   DEFINE RETURN PARAMETER pValue    AS DOUBLE.                   */
/* END.                                                             */

/* PROCEDURE PLOP_set_parameter EXTERNAL "{&PLOPlib}" CDECL PERSISTENT: */
/*   DEFINE INPUT  PARAMETER pPLOP      AS LONG.                        */
/*   DEFINE INPUT  PARAMETER pKey      AS CHARACTER.                    */
/*   DEFINE INPUT  PARAMETER pValue    AS CHARACTER.                    */
/* END.                                                                 */

/* currently no values for this function
PROCEDURE PLOP_set_value EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pKey      AS CHARACTER.
  DEFINE INPUT  PARAMETER pValue    AS DOUBLE.
END.
*/

/**************************** ERROR FUNCTIONS ****************************/

PROCEDURE PLOP_get_apiname EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPLOP      AS LONG.
  DEFINE RETURN PARAMETER pAPIname  AS CHARACTER.
END.

PROCEDURE PLOP_get_errmsg EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPLOP      AS LONG.
  DEFINE RETURN PARAMETER pErrorMsg AS CHARACTER.
END.

PROCEDURE PLOP_get_errnum EXTERNAL "{&PLOPlib}" CDECL PERSISTENT:
  DEFINE INPUT  PARAMETER pPLOP      AS LONG.
  DEFINE RETURN PARAMETER pErrorNum AS LONG.
END.

/* ---------------- End Bindings to DLL / Shared Library ------------------ */
