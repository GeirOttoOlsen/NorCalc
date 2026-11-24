/* HUB for excecuting BL procedures that will return a temp-table */

DEF INPUT  PARAM icSessionId  AS CHAR NO-UNDO. 
DEF INPUT  PARAM icRunProc    AS CHAR NO-UNDO.
DEF INPUT  PARAM icParamList  AS CHAR NO-UNDO.
DEF OUTPUT PARAM TABLE-HANDLE ohttTable.
DEF OUTPUT PARAM ocReturn     AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOk         AS LOG NO-UNDO.

DEF VAR bAccess AS LOG    NO-UNDO INIT YES.
DEF VAR hBuffer AS HANDLE NO-UNDO.

{incl/validatesession.i}

IF icRunProc = "" THEN
  RUN jbserv_gettemptable.p (icSessionId,icParamList,OUTPUT TABLE-HANDLE ohttTable,OUTPUT ocReturn).

ELSE IF SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "p") NE ? OR 
   SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "r") NE ? OR 
   SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "w") NE ? THEN DO:

  IF SEARCH("jbserv_check_runproc_access.p") NE ? OR SEARCH("jbserv_check_runproc_access.r") NE ? THEN
    RUN jbserv_check_runproc_access.p (icSessionId,icRunProc,iCurrCompanyId,OUTPUT bAccess) NO-ERROR.
  IF bAccess THEN 
    RUN VALUE(icRunProc) (icParamList,
                          OUTPUT TABLE-HANDLE ohttTable,
                          icSessionId,
                          OUTPUT ocReturn, 
                          OUTPUT obOK).
  ELSE ocReturn = "You don't have access to run this procedure: " + icRunProc.
END.

ELSE ocReturn = "Couldn't find " + icRunProc + " on server".

IF VALID-HANDLE(ohttTable) THEN DELETE OBJECT ohttTable.

IF VALID-HANDLE(hJbAPI) THEN 
  DYNAMIC-FUNCTION("setPreTransBuffer" IN hJbAPI,?).

obOk = ocReturn = "".