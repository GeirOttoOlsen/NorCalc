/*----------------------------------------------------------------------------

File: _datatyp.p

Description:
    Return a progress datatype given an integer value
    Integer value is assumed to be the same code used in the _dtype field
    in the schema.

    Returns blank if integer is not a known integer value

Parameter:
   INPUT 	dType	        INTEGER
   OUTPUT 	dataType	CHARACTER
   
Author: SLK
Date Created: 08/11/98
Copied integer values from getDataSignature in adm2/browser.p

----------------------------------------------------------------------------*/
/*Copyright (c) by PROGRESS SOFTWARE CORPORATION. 1998 - All Rights Reserved.*/

DEFINE INPUT PARAMETER  pi_dType          AS INTEGER NO-UNDO.
DEFINE OUTPUT PARAMETER pc_dataType       AS CHARACTER NO-UNDO.

CASE pi_dType:
   WHEN 1 THEN pc_dataType = 'CHARACTER':U .
   WHEN 2 THEN pc_dataType = 'DATE':U .
   WHEN 3 THEN pc_dataType = 'LOGICAL':U .
   WHEN 4 THEN pc_dataType = 'INTEGER':U .
   WHEN 5 THEN pc_dataType = 'DECIMAL':U .
      /* Note: Float/Double reserved for possible future use. */
   WHEN 6 THEN pc_dataType = 'DOUBLE':U. /* FLOAT */
   WHEN 7 THEN pc_dataType = 'RECID':U .
   WHEN 8 THEN pc_dataType = 'RAW':U .
   WHEN 9 THEN pc_dataType = 'ROWID':U .
   WHEN 0 THEN pc_dataType = '':U .
   OTHERWISE   pc_dataType = '':U.
END CASE.
