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
def var iProsjektId as int no-undo.

iProsjektid = ihBuffer:buffer-field('prosjektid'):buffer-value.

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

  find first NORPROSJEKT where NORPROSJEKT.prosjektid = iProsjektId no-lock no-error.
  if avail NORPROSJEKT then
  do transaction:
    find current NORPROSJEKT exclusive-lock no-error.
    if avail NORPROSJEKT then
    do:
      NORPROSJEKT.spirovent = "Ja".
    end.
  end.
  find current NORPROSJEKT no-lock no-error.    


END PROCEDURE.

PROCEDURE doDelete:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  find first NPSPANLG where NPSPANLG.prosjektid = iProsjektId no-lock no-error.
  find first NORPROSJEKT where NORPROSJEKT.prosjektid = iProsjektId no-lock no-error.
  if avail NORPROSJEKT then
  do transaction:
    find current NORPROSJEKT exclusive-lock no-error.
    if avail NORPROSJEKT then
    do:
      NORPROSJEKT.spirovent = if avail NPSPANLG then 'Ja' else 'Nei'.
    end.
  end.
  find current NORPROSJEKT no-lock no-error.    
END PROCEDURE.

PROCEDURE doUpdate:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/


END PROCEDURE.
