/* HUB for excecuting BL procedures that will return a dataset */

DEF INPUT  PARAM icSessionId  AS CHAR NO-UNDO. 
DEF INPUT  PARAM icRunProc    AS CHAR NO-UNDO.
DEF INPUT  PARAM icParamList  AS CHAR NO-UNDO.
DEF OUTPUT PARAM DATASET-HANDLE ohDs.
DEF OUTPUT PARAM ocReturn     AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOk         AS LOG NO-UNDO.

DEF VAR bAccess AS LOG    NO-UNDO INIT YES.

{incl/validatesession.i}

IF SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "p") NE ? OR 
   SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "r") NE ? OR 
   SEARCH(SUBSTR(icRunProc,1,R-INDEX(icRunProc,".")) + "w") NE ? THEN DO:

  IF SEARCH("jbserv_check_runproc_access.p") NE ? OR SEARCH("jbserv_check_runproc_access.r") NE ? THEN
    RUN jbserv_check_runproc_access.p (icSessionId,icRunProc,iCurrCompanyId,OUTPUT bAccess) NO-ERROR.
  IF bAccess THEN 
    RUN VALUE(icRunProc) (icParamList,
                          OUTPUT DATASET-HANDLE ohDs,
                          icSessionId,
                          OUTPUT ocReturn, 
                          OUTPUT obOK).
  ELSE ocReturn = "You don't have access to run this procedure".
END.

ELSE ocReturn = "Couldn't find " + icRunProc + " on server".

IF VALID-HANDLE(ohDs) THEN DELETE OBJECT ohDs.

IF VALID-HANDLE(hJbAPI) THEN 
  DYNAMIC-FUNCTION("setPreTransBuffer" IN hJbAPI,?).
