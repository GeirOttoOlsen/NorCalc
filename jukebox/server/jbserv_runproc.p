/* HUB for excecuting (most) BL procedures */

DEF INPUT  PARAM icSessionId  AS CHAR NO-UNDO. 
DEF INPUT  PARAM icRunProc    AS CHAR NO-UNDO.
DEF INPUT  PARAM icParamList  AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE-HANDLE ihttTable.
DEF OUTPUT PARAM ocReturn     AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOk         AS LOG NO-UNDO.

DEF VAR bAccess AS LOG    NO-UNDO INIT YES.

{incl/validatesession.i}

IF SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "p") NE ? OR 
   SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "r") NE ? OR 
   SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "w") NE ? THEN DO:

  IF SEARCH("jbserv_check_runproc_access.p") NE ? OR SEARCH("jbserv_check_runproc_access.r") NE ? THEN
    RUN jbserv_check_runproc_access.p (icSessionId,icRunProc,iCurrCompanyId,OUTPUT bAccess) NO-ERROR.
  IF bAccess THEN DO:
    RUN VALUE(icRunProc) (icParamList,
                          IF VALID-HANDLE(ihttTable) THEN 
                            ihttTable:DEFAULT-BUFFER-HANDLE
                          ELSE ?,
                          icSessionId,
                          OUTPUT ocReturn, 
                          OUTPUT obOK).
  END.
  ELSE ocReturn = "You don't have access to run this procedure: " + icRunProc.
END.

ELSE ocReturn = "Couldn't find " + icRunProc + " on server".

IF VALID-HANDLE(ihttTable) THEN DELETE OBJECT ihttTable.

IF VALID-HANDLE(hJbAPI) THEN 
  DYNAMIC-FUNCTION("setPreTransBuffer" IN hJbAPI,?).

