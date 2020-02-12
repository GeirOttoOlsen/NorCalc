/* To invoke: 
   DYNAMIC-FUNCTION("setAttribute",hFieldMap | hBrowse,"PostUpdateProc","<procedure>").
   If there's no fieldmap (viewer) set the attribute on the browse object
   
   NOTE: If the action is DELETE the buffer handle is for a temp-table copy of the record that was deleted
-----------------------------------------------------------------------------------------*/   
DEF INPUT  PARAM ihBuffer       AS HANDLE NO-UNDO.  /* Handle to current buffer */
DEF INPUT  PARAM icAction       AS CHAR   NO-UNDO.  /* Delete, Create or Update */
DEF INPUT  PARAM icSessionId    AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocValue        AS CHAR   NO-UNDO.  /* Error message. If <> blank the transaction is backed out */

DEF VAR cFields     AS CHAR NO-UNDO.
DEF VAR cValues     AS CHAR NO-UNDO.
def var iAnleggsnr  as int no-undo.

iAnleggsnr = ihBuffer:buffer-field('anleggsnr'):buffer-value.

case icAction:
  when 'Create' then run doCreate.
  when 'Update' then run doUpdate.
  when 'Delete' then run doDelete. 
end case.

/* To get the fields used in current update (comma-separated list): */
cFields = DYNAMIC-FUNCTION("getCurrentValueFields" IN SOURCE-PROCEDURE).

/* To get the corrensponding list of values used in current update (pipe-separated list): */
cValues = DYNAMIC-FUNCTION("getCurrentValues" IN SOURCE-PROCEDURE).

/* To get a spesific value from current update: */
/*cValues = DYNAMIC-FUNCTION("getValue" IN SOURCE-PROCEDURE,"<field name>").*/


/* **********************  Internal Procedures  *********************** */

PROCEDURE doCreate:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/


END PROCEDURE.

PROCEDURE doDelete:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
END PROCEDURE.

PROCEDURE doUpdate:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/


END PROCEDURE.
