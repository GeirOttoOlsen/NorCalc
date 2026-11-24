/* You can use a static temp-table on the server and transfer the handle to it like you would do with a dynamic.
   There are orders not assigned to salesrep in the db. Hence the extra loop.

   Created: 20/12/22 by meg
-----------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

/*DEF INPUT  PARAM icSessionId  AS CHAR NO-UNDO.*/
/*DEF INPUT  PARAM icParam      AS CHAR NO-UNDO.*/
/*DEF OUTPUT PARAM TABLE-HANDLE ohTempTable.    */
/*DEF OUTPUT PARAM ocReturn     AS CHAR NO-UNDO.*/


{incl/validatesession.i}

DEFINE NEW SHARED TEMP-TABLE ttLock NO-UNDO
    FIELD cDb    AS CHAR 
    FIELD cTABLE AS CHARACTER
    FIELD iUSER AS INTEGER
    FIELD cName AS CHARACTER
    FIELD rRECID AS INTEGER
    FIELD iTABLE AS INTEGER
    INDEX UserName cName ASCENDING.

ihBuffer = TEMP-TABLE ttLock:BUFFER-HANDLE.

DEF VAR ix AS INT NO-UNDO.

REPEAT ix = 1 TO NUM-DBS:
  DELETE ALIAS dictdb.
  CREATE ALIAS dictdb FOR DATABASE VALUE (LDBNAME(ix)).
  RUN jbadmin_checklocks_db.p (LDBNAME(ix)).
END.
IF ix > 1 THEN DO:
  DELETE ALIAS dictdb.
  CREATE ALIAS dictdb FOR DATABASE VALUE (LDBNAME(1)).
END.
