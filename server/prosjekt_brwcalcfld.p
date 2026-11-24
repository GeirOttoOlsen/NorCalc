/********************************************************************************
Created....08/04/2020 by goo_000
Purpose....
Used by....  <list of_ client procedures>
Modified...
********************************************************************************/

/* DYNAMIC-FUNCTION('startASlib' IN SOURCE-PROCEDURE). /* Optionally enable appserver library functions on server */ */

PROCEDURE CleanUp:
  /* Delete any dynamic objects here (avoid creating them inside the internal procedure(s)) */
END PROCEDURE.


FUNCTION setResultSetBuffer RETURNS LOGICAL (INPUT ihTTbuffer AS HANDLE):
  /* Called if exists to provide access to the result set buffer */
END FUNCTION.


PROCEDURE isShunt:
  DEF INPUT  PARAM irNORPROSJEKT AS ROWID NO-UNDO.
  DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ocReturn AS CHAR NO-UNDO.
  
  find norprosjekt where rowid(norprosjekt) = irNORPROSJEKT no-lock.
  ocReturn = string(can-find(first NPSHANLG where NPSHANLG.prosjektid = norProsjekt.ProsjektId)).
END PROCEDURE.





PROCEDURE isSpiro:
  DEF INPUT  PARAM irNORPROSJEKT AS ROWID NO-UNDO.
  DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ocReturn AS CHAR NO-UNDO.

  find norprosjekt where rowid(norprosjekt) = irNORPROSJEKT no-lock.
  ocReturn = string(can-find(first NPSPANLG where NPSPANLG.prosjektid = norProsjekt.ProsjektId)).
END PROCEDURE.