DO:
  /* Invoked on top of server-side procedures.
     You should comment out the "validsession" test in a production environment. */ 
  DEF VAR cOrgDateFormat    AS CHAR   NO-UNDO.
  DEF VAR cOrgNumFormat     AS CHAR   NO-UNDO.
  DEF VAR cCurrUserId       AS CHAR   NO-UNDO.
  DEF VAR iCurrCompanyId    AS INT    NO-UNDO.
  DEF VAR cCurrLanguage     AS CHAR   NO-UNDO.
  DEF VAR cCurrContext      AS CHAR   NO-UNDO.
  DEF VAR iCodeMaster       AS INT    NO-UNDO.
  DEF VAR hBuffCompToComp   AS HANDLE NO-UNDO.
  DEF VAR hJbAPI            AS HANDLE NO-UNDO.

  {incl/demo.i}
  {incl/server_devmode.i}
  
  IF 
//    icSessionId NE "validsession" AND 
    (SEARCH("jbserv_validatesession.r") NE ? OR SEARCH("jbserv_validatesession.p") NE ?) THEN DO:

    RUN jbserv_validatesession.p (INPUT icSessionId, 
                                  OUTPUT ocReturn, 
                                  OUTPUT cCurrUserId, 
                                  OUTPUT iCurrCompanyId,
                                  OUTPUT cCurrLanguage,
                                  OUTPUT cCurrContext
                                  ).
    IF ocReturn NE "" THEN 
      RETURN.  
    ELSE DO:
      CREATE BUFFER hBuffCompToComp FOR TABLE "JBoxCompanyToCompany" NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO:
        hBuffCompToComp:FIND-FIRST("WHERE iJBoxCompanyId = " + STRING(iCurrCompanyId) + " AND cCompanyRole = 'codemaster'"
                                   ,NO-LOCK) NO-ERROR.  
        IF NOT ERROR-STATUS:ERROR AND hBuffCompToComp:AVAIL THEN
          iCodeMaster = hBuffCompToComp:BUFFER-FIELD("iJBoxToCompanyid"):BUFFER-VALUE.
        ELSE iCodeMaster = iCurrCompanyId.
        DELETE OBJECT hBuffCompToComp NO-ERROR.
      END.        
      ELSE iCodeMaster = iCurrCompanyId.
    END.
  END.
  ELSE 
/*    IF icSessionId NE "validsession" THEN*/
/*    DO:*/
      ocReturn = "Invalid session".
/*      RETURN.*/
/*    END.     */
/*    ELSE IF USERID(LDBNAME(1)) NE "" THEN cCurrUserId = USERID(LDBNAME(1)).*/

  IF ocReturn NE "" THEN RETURN.    

  ASSIGN cOrgDateFormat  = SESSION:DATE-FORMAT
         cOrgNumFormat   = SESSION:NUMERIC-FORMAT.

  IF SEARCH("jbserv_init_jboxserverside.p") NE ? OR SEARCH("jbserv_init_jboxserverside.r") NE ? THEN DO:
    RUN jbserv_init_jboxserverside.p (icSessionId,THIS-PROCEDURE,INPUT-OUTPUT hJbAPI,OUTPUT ocReturn).
    IF ocReturn NE "" THEN RETURN.    
  END.  

  /*
  IF CAN-DO("WEBSPEED,APPSERVER",SESSION:TYPE) AND PROGRAM-NAME(1) NE "jbserv_api_for_server.p" AND
     (SEARCH("jbserv_loadserverlib.p") NE ? OR SEARCH("jbserv_loadserverlib.p") NE ?) THEN DO:
    RUN jbserv_loadserverlib.p (icSessionId).
  END.  
  IF PROGRAM-NAME(1) = "jbserv_gettemptablejoin.p" AND (SEARCH("jbserv_init_jboxserverquery.p") NE ? OR SEARCH("jbserv_init_jboxserverquery.r") NE ?) THEN
    RUN jbserv_init_jboxserverquery.p (icSessionId,THIS-PROCEDURE,OUTPUT ocReturn).  
  IF PROGRAM-NAME(1) = "jbserv_servertrans.p" AND (SEARCH("jbserv_init_jboxservertrans.p") NE ? OR SEARCH("jbserv_init_jboxservertrans.r") NE ?) THEN
    RUN jbserv_init_jboxservertrans.p (icSessionId,THIS-PROCEDURE,OUTPUT ocReturn).
  */
  

END.
  
FUNCTION getASuserId RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN cCurrUserId.

END FUNCTION.

FUNCTION getCompanyId RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN iCurrCompanyId. 

END FUNCTION.

FUNCTION getCodeMaster RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN STRING(iCodeMaster). 

END FUNCTION.

FUNCTION getCodeMasterId RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN iCodeMaster. 

END FUNCTION.

FUNCTION getLanguageCode RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

RETURN cCurrLanguage.

END FUNCTION.

FUNCTION Scandinavian RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  IF CAN-DO("da,dk,no,sv,se,nn,",cCurrLanguage) THEN
    RETURN TRUE.
  ELSE
    RETURN FALSE.  
END FUNCTION.

FUNCTION getSysParam RETURNS CHARACTER
  ( INPUT icParamName AS CHAR,
    INPUT icValueType AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cParamValue       AS CHAR   NO-UNDO.
DEF VAR hBuffJboxSysParam AS HANDLE NO-UNDO.

CREATE BUFFER hBuffJboxSysParam FOR TABLE "JBoxSysParam" NO-ERROR.
IF ERROR-STATUS:ERROR THEN
  RETURN ?.
DELETE OBJECT hBuffJboxSysParam.

IF SEARCH("jbadmin_getsysparam.p") NE ? OR SEARCH("jbadmin_getsysparam.r") NE ? THEN
  RUN jbadmin_getsysparam.p (icParamName,icValueType,iCurrCompanyId,iCodeMaster,OUTPUT cParamValue).
ELSE RETURN ?.

RETURN cParamValue.

END FUNCTION.

FUNCTION getGenCode RETURNS CHARACTER
  ( INPUT icCodeType  AS CHAR,
    INPUT icValueDesc AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cCodeValue        AS CHAR   NO-UNDO.
DEF VAR hBuffJboxGenCode  AS HANDLE NO-UNDO.

CREATE BUFFER hBuffJboxGenCode FOR TABLE "JBoxGenCode" NO-ERROR.
IF ERROR-STATUS:ERROR THEN
  RETURN ?.
DELETE OBJECT hBuffJboxGenCode.

IF SEARCH("jbadmin_getgeneralcode.p") NE ? OR SEARCH("jbadmin_getgeneralcode.r") NE ? THEN
  RUN jbadmin_getgeneralcode.p (icCodeType,icValueDesc,iCurrCompanyId,iCodeMaster,OUTPUT cCodeValue).
ELSE RETURN ?.

RETURN cCodeValue.

END FUNCTION.

FUNCTION startASlib RETURNS HANDLE ():
  IF NOT VALID-HANDLE(hJbAPI) THEN
    RUN jbserv_api_for_server.p PERSIST SET hJbAPI (icSessionId).
  ELSE  
    IF NOT DYNAMIC-FUNCTION("setSessionId" IN hJbAPI,icSessionId) THEN RETURN ?.
  SOURCE-PROCEDURE:ADD-SUPER-PROCEDURE(hJbAPI).
  RETURN hJbAPI.
END.

  
