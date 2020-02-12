/********************************************************************************
Created....26/09/2018 by brynj
Purpose....
Used by....  <list of_ client procedures>
Modified...
********************************************************************************/

/* DYNAMIC-FUNCTION('startASlib' IN SOURCE-PROCEDURE). /* Optionally enable appserver library functions on server */ */

PROCEDURE CleanUp:
  /* Delete any dynamic objects here (avoid creating them inside the internal procedure(s)) */
END PROCEDURE.


PROCEDURE EmployeeAge:
  DEF INPUT  PARAM irEmployee AS ROWID NO-UNDO.
  DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ocReturn AS CHAR NO-UNDO.

  FIND Employee NO-LOCK WHERE ROWID(Employee) = irEmployee NO-ERROR.
  IF AVAIL Employee THEN
    ocReturn = STRING(INTERVAL(TODAY,Employee.Birthdate,"years")).
END PROCEDURE.