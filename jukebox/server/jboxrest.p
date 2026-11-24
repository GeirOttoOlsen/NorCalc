
/*------------------------------------------------------------------------
    File        : find.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar / Geir Otto
    Created     : Tue Oct 18 10:48:57 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

CREATE WIDGET-POOL.

{src/web2/wrap-cgi.i}


DEF VAR hDsResponse AS HANDLE NO-UNDO.

RUN process-web-request.

PROCEDURE outputHeader :
  output-content-type ("application/json;charset=utf-8":U).
END PROCEDURE.

FUNCTION CheckForLib RETURNS LOGICAL
  (INPUT ihProc     AS HANDLE,
   INPUT icLibName  AS CHAR):

  DEF VAR hSessProc AS HANDLE NO-UNDO.
  hSessProc = SESSION:FIRST-PROCEDURE.

  IF NOT VALID-HANDLE(ihProc) THEN
    RETURN NO.
  ELSE REPEAT WHILE VALID-HANDLE(hSessProc):
    IF hSessProc:FILE-NAME = icLibName THEN RETURN YES.
    ELSE hSessProc = hSessProc:NEXT-SIBLING.
  END.
  RETURN NO.
END FUNCTION.

PROCEDURE process-web-request :
  /*------------------------------------------------------------------------------
    Purpose:     Process the web request.
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE oLoginSession AS CLASS oo.LoginSession NO-UNDO. 
  DEFINE VARIABLE oWeb AS CLASS oo.WebHandler NO-UNDO.
  
  DEF VAR sessionId       AS CHAR NO-UNDO.
  DEF VAR methodProc      AS CHAR NO-UNDO.
  DEF VAR oJBoxJsonParser AS JBoxJsonParser NO-UNDO.
  DEF VAR hAsLib          AS HANDLE NO-UNDO.
    
  RUN outputHeader.

  oWeb = NEW oo.WebHandler().
  oWeb:InitializeObject().
      
  oLoginSession = NEW oo.LoginSession().
  
  IF NOT oWeb:oRequestBodyJson:Has('sessionid') THEN 
    UNDO, THROW NEW Progress.Lang.AppError('Feilformatering av innsending, mangler "sessionId"',500).
  
  ELSE DO:
    sessionId = oWeb:oRequestBodyJson:GetCharacter('sessionid').
    IF NOT oLoginSession:ValidSession(sessionId) THEN 
      UNDO, THROW NEW Progress.Lang.AppError('Invalid token ' + oLoginSession:statusMessage,404).
  END.
  
  IF NOT VALID-HANDLE(JBoxServerSide:Instance:hJbServerLib) THEN DO:
    RUN "jbserv_api_for_server.p" PERSIST SET hAsLib (sessionId).
    SESSION:ADD-SUPER-PROCEDURE(hAsLib).
    JBoxServerSide:Instance:hJbServerLib = hAsLib.
  END.  
  ELSE DO:
    hAsLib = JBoxServerSide:Instance:InitializeObject(?,sessionId).
    SESSION:ADD-SUPER-PROCEDURE(hAsLib).
  END.  
  
  RUN JBoxLoadLib.p("JBoxUILib.p").
  
  oJBoxJsonParser = NEW JBoxJsonParser().
  oJBoxJsonParser:createSchema(oWeb:oRequestBodyJson:getJsonText(),"callparam").
  oJBoxJsonParser:returnBlankWhenNoValue = YES.

  methodProc = "jbrest_" + oJBoxJsonParser:getResultFirstFieldValue("callparam","method") + ".p".
  RUN VALUE(methodProc) (oJBoxJsonParser,INPUT-OUTPUT DATASET-HANDLE hDsResponse).

  CATCH eApp AS Progress.Lang.AppError :
    IF NOT oWeb:hasError THEN oWeb:AddError(eApp:GetMessage(1)). 
  END CATCH.
    
  CATCH eAny AS Progress.Lang.Error :
    IF NOT oWeb:hasError THEN DO:
      IF eAny:GetMessageNum(1) = 293 THEN 
        oWeb:AddError("Invalid method name: " + SUBSTR(methodProc,8,R-INDEX(methodProc,".") - 1) + " " + eAny:GetMessage(1)).
      ELSE 
        oWeb:AddError(eAny:GetMessage(1)).
    END.   
  END CATCH.

  FINALLY:
    IF oWeb:HasError THEN
      oWeb:httError:WRITE-JSON("stream","WebStream",yes,"UTF-8").
    ELSE IF JBoxServerSide:Instance:HasError THEN 
      JBoxServerSide:Instance:httError:WRITE-JSON("stream","WebStream",yes,"UTF-8").
    ELSE  
      hDsResponse:WRITE-JSON("stream","WebStream",yes,"UTF-8").
  END FINALLY.

END PROCEDURE.
