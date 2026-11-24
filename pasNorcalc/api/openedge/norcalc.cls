 
/*------------------------------------------------------------------------
   File        : PF
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : goo@thinc.no
   Created     : Wed Jun 26 10:08:38 CEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Web.WebResponseWriter.
USING OpenEdge.Net.HTTP.StatusCodeEnum.
USING OpenEdge.Web.WebHandler.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS norcalc INHERITS WebHandler: 
    
  METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        
    UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

  END METHOD.

  METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
        
    UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

  END METHOD.

  /*------------------------------------------------------------------------------
          Purpose: Default handler for the HTTP POST method. The request being
                   serviced and an optional status code is returned. A zero or
                   null value means this method will deal with all errors.
          Notes:
  ------------------------------------------------------------------------------*/
  METHOD OVERRIDE PROTECTED INTEGER HandlePut(INPUT poRequest AS OpenEdge.Web.IWebRequest ):

    var class OpenEdge.Net.HTTP.IHttpResponse oResponse.
    var class OpenEdge.Web.WebResponseWriter oWriter.
    
    var class Progress.Lang.Object oBody. 
    var class OpenEdge.Net.HTTP.Filter.Payload.MessageWriter oEntityWriter.
    var class oo.Toolbox oTool.
    var class Token oToken.
    var class LoginSession oLoginSession.
    var class Progress.Json.ObjectModel.JsonObject oJObody.
    var class Progress.Json.ObjectModel.JsonArray oJAbody.
    var class OpenEdge.Net.HTTP.Cookie [] oCookies. 
    var class OpenEdge.Net.HTTP.HttpHeader [] oHeaders.
    
    var char Uuid,uid, TokenStreng, ServiceMethod, ServiceVersion, ServiceTable,queryString,sessionid,cookie.
    var int MemberId,UriLength,sendtMemberId,ix.     
    
    var longchar body,jsonOutput.
    var char [] Fieldnames.

    var class Progress.Json.ObjectModel.JsonObject oData.
    var class members oMembers.


    run jboxloadlib.p ("jboxuilib.p").
    JBoxSession:Instance:AppServerHandle = SESSION.
    
    do on error undo, throw:
    ASSIGN
      fix-codepage(body)       = 'UTF-8'
      UriLength                = NUM-ENTRIES(poRequest:UriTemplate,'/')
      ServiceVersion           = ENTRY(2,poRequest:UriTemplate,'/')
      ServiceTable             = ENTRY(3,poRequest:UriTemplate,'/')
      queryString              = poRequest:GetContextValue('query_string')
      .
      CATCH eAny AS Progress.Lang.Error :
        undo, throw new Progress.Lang.AppError('Feilet i UriTemplate: ' + quoter(poRequest:UriTemplate),500).            
      END CATCH.
    end.

    oResponse  = NEW OpenEdge.Web.WebResponse().
    
/*    do on error undo, throw:                                              */
/*      oData = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).*/
/*      CATCH eAny AS Progress.Lang.Error :                                 */
/*         undo, throw eAny.                                                */
/*      END CATCH.                                                          */
/*    end.                                                                  */

    do on error undo, throw:
    ASSIGN
      fix-codepage(JsonOutput) = 'UTF-8'
      UriLength                = NUM-ENTRIES(poRequest:UriTemplate,'/')
      ServiceVersion           = ENTRY(2,poRequest:UriTemplate,'/')
      ServiceTable             = ENTRY(3,poRequest:UriTemplate,'/')
      queryString              = poRequest:GetContextValue('query_string')
      .
      
      CATCH eAny AS Progress.Lang.Error :
        undo, throw new Progress.Lang.AppError(subst('Feilet i UriTemplate: &1',poRequest:UriTemplate),500).            
      END CATCH.
    end.
    
    oTool = new oo.Toolbox().
    oTool:buildList('queryString',queryString,'&').
    oLoginSession = new LoginSession().
    oResponse  = NEW OpenEdge.Web.WebResponse().
    
    log-manager:write-message(subst('UriLength: &1 ServiceVersion:&2 ServiceTable: &3 - UriTemplate:&4 ',UriLength,ServiceVersion,ServiceTable,poRequest:UriTemplate),'debug').
    
    poRequest:GetCookies(output oCookies).
    poRequest:GetHeaders(output oHeaders).
/*    do ix = 1 to extent(oHeaders):                                             */
/*      log-manager:write-message(subst('lengde:&1',oHeaders[ix]:name ),'debug').*/
/*    end.                                                                       */
    /*Henter ut Token*/
    assign 
      TokenStreng = string(poRequest:GetHeader('Authorization'))
    .

    if ServiceTable <> 'Token' then do:
      sessionid = poRequest:GetCookie('sessionid'):Value.
            
      JBoxServerAPI:Instance:sessionId = sessionid.
      log-manager:write-message(subst('sessionid: &1',sessionid),'debug').
      if not oLoginSession:validateSession(sessionid) then
        undo, throw new Progress.Lang.AppError('Loginsession not valid',401). 
/*      IF NOT oLoginSession:validateParameters(uid,Uuid) then                                                                */
/*        UNDO, THROW NEW Progress.Lang.AppError(oLoginSession:MessageStatus,int(StatusCodeEnum:NonAuthoritativeInformation)).*/
    end.

    CASE ServiceTable:
      WHEN 'SoknadTransType' THEN DO:
        oMembers = new members().
        oJObody = new Progress.Json.ObjectModel.JsonObject().
        oJObody = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).
                
        oMembers:putSoknadTransType(oJObody).

        if oMembers:MessageStatus <> '' then 
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
        //log-manager:write-message(string(JsonOutput),'debug').
      end.
      WHEN 'SoknadType' THEN DO:
        oMembers = new members().
        oJObody = new Progress.Json.ObjectModel.JsonObject().
        oJObody = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).
                
        oMembers:putSoknadType(oJObody).

        if oMembers:MessageStatus <> '' then 
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
        //log-manager:write-message(string(JsonOutput),'debug').
      end.
      WHEN 'SoknadStatus' THEN DO:
        oMembers = new members().
        oJObody = new Progress.Json.ObjectModel.JsonObject().
        oJObody = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).
                
        oMembers:putSoknadStatus(oJObody).

        if oMembers:MessageStatus <> '' then 
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
        //log-manager:write-message(string(JsonOutput),'debug').
      end.
      WHEN 'SoknadTrans' THEN DO:
        oMembers = new members().
        oJObody = new Progress.Json.ObjectModel.JsonObject().
        oJObody = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).
                
        oMembers:putSoknadTrans(oJObody).

        if oMembers:MessageStatus <> '' then 
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
        //log-manager:write-message(string(JsonOutput),'debug').
      end.
      WHEN 'Soknad' THEN DO:
        oMembers = new members().
        oJObody = new Progress.Json.ObjectModel.JsonObject().
        oJObody = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).
                
        oMembers:putSoknad(oJObody).

        if oMembers:MessageStatus <> '' then 
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
        //log-manager:write-message(string(JsonOutput),'debug').
      end.
    end case.


    oBody = new OpenEdge.Core.String(JsonOutput).
    ASSIGN
      oResponse:Entity      = oBody
      oResponse:ContentType = 'application/json'
      .

    /* The WebResponseWriter ensures that the status line and
       all headers are writted out before the message body/entity. */
    oWriter = NEW WebResponseWriter(oResponse).
    oWriter:Open().
    oWriter:Close().
        
    /* A response of 0 means that this handler will build the entire response;
       a non-zero value is mapped to a static handler in the webapp's /static/error folder.
       The mappings are maintained in the webapps's WEB-INF/web.xml 
       A predefined set of HTTP status codes is provided in the OpenEdge.Net.HTTP.StatusCodeEnum 
       enumeration */
    RETURN 0.
    CATCH eAny AS Progress.Lang.Error :
      def var ErrorMsg as char no-undo.
      def var ErrorNumber as int no-undo.
      def var oJO as class Progress.Json.ObjectModel.JsonObject no-undo.
  
    LOG-MANAGER:WRITE-MESSAGE ('-->error: ' + string(eAny:GetMessageNum(1)) + ' ' + string(eAny:GetMessage(1)),'DEBUG').
      assign
        ErrorMsg    = eAny:GetMessage(1)
        ErrorNumber = eAny:GetMessageNum(1)
        ErrorNumber = if ErrorNumber gt 1 then ErrorNumber else INTEGER(StatusCodeEnum:BadRequest)
        .

      oJO = new Progress.Json.ObjectModel.JsonObject().
      oJO:Add("ErrorNumber",ErrorNumber).
      oJO:Add("ErrorMessage",ErrorMsg).
      
      
      oResponse               = NEW OpenEdge.Web.WebResponse().
      oResponse:StatusCode    = IF ErrorNumber ge 1 then ErrorNumber ELSE INTEGER(StatusCodeEnum:BadRequest). 
      oResponse:Entity        = oJO.
      oResponse:ContentType   = 'application/json'.
      oWriter = NEW WebResponseWriter(oResponse).

      oWriter:Open().
      oWriter:Close().
      return 0.
    END CATCH.

    FINALLY:

    END FINALLY.     
  END METHOD.
    

  /*------------------------------------------------------------------------------
          Purpose: Default handler for the HTTP POST method. The request being
                   serviced and an optional status code is returned. A zero or
                   null value means this method will deal with all errors.
          Notes:
  ------------------------------------------------------------------------------*/
  METHOD OVERRIDE PROTECTED INTEGER HandlePost(INPUT poRequest AS OpenEdge.Web.IWebRequest ):

    var class OpenEdge.Net.HTTP.IHttpResponse oResponse.
    var class OpenEdge.Web.WebResponseWriter oWriter.
    
    var class Progress.Lang.Object oBody. 
    var class OpenEdge.Net.HTTP.Filter.Payload.MessageWriter oEntityWriter.
    var class oo.Toolbox oTool.
    var class Token oToken.
    var class LoginSession oLoginSession.
    var class Progress.Json.ObjectModel.JsonObject oJSbody.
    var class OpenEdge.Net.HTTP.Cookie [] oCookies. 
    var class OpenEdge.Net.HTTP.HttpHeader [] oHeaders.
    
    var char Uuid,uid, TokenStreng, ServiceMethod, ServiceVersion, ServiceTable,queryString,sessionid,cookie.
    var int MemberId,UriLength,sendtMemberId,ix.     
    
    var longchar body,jsonOutput.
    var char [] Fieldnames.

    var class Progress.Json.ObjectModel.JsonObject oData.
    var class members oMembers.


    run jboxloadlib.p ("jboxuilib.p").
    JBoxSession:Instance:AppServerHandle = SESSION.
    
    do on error undo, throw:
    ASSIGN
      fix-codepage(body)       = 'UTF-8'
      UriLength                = NUM-ENTRIES(poRequest:UriTemplate,'/')
      ServiceVersion           = ENTRY(2,poRequest:UriTemplate,'/')
      ServiceTable             = ENTRY(3,poRequest:UriTemplate,'/')
      queryString              = poRequest:GetContextValue('query_string')
      .
      CATCH eAny AS Progress.Lang.Error :
        undo, throw new Progress.Lang.AppError('Feilet i UriTemplate: ' + quoter(poRequest:UriTemplate),500).            
      END CATCH.
    end.

    oResponse  = NEW OpenEdge.Web.WebResponse().
    
/*    do on error undo, throw:                                              */
/*      oData = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).*/
/*      CATCH eAny AS Progress.Lang.Error :                                 */
/*         undo, throw eAny.                                                */
/*      END CATCH.                                                          */
/*    end.                                                                  */

    do on error undo, throw:
    ASSIGN
      fix-codepage(JsonOutput) = 'UTF-8'
      UriLength                = NUM-ENTRIES(poRequest:UriTemplate,'/')
      ServiceVersion           = ENTRY(2,poRequest:UriTemplate,'/')
      ServiceTable             = ENTRY(3,poRequest:UriTemplate,'/')
      queryString              = poRequest:GetContextValue('query_string')
      .
      
      CATCH eAny AS Progress.Lang.Error :
        undo, throw new Progress.Lang.AppError(subst('Feilet i UriTemplate: &1',poRequest:UriTemplate),500).            
      END CATCH.
    end.
    
    oTool = new oo.Toolbox().
    oTool:buildList('queryString',queryString,'&').
    oLoginSession = new LoginSession().
    oResponse  = NEW OpenEdge.Web.WebResponse().
    
    log-manager:write-message(subst('UriLength: &1 ServiceVersion:&2 ServiceTable: &3 - UriTemplate:&4 ',UriLength,ServiceVersion,ServiceTable,poRequest:UriTemplate),'debug').
    
    poRequest:GetCookies(output oCookies).
    poRequest:GetHeaders(output oHeaders).
/*    do ix = 1 to extent(oHeaders):                                             */
/*      log-manager:write-message(subst('lengde:&1',oHeaders[ix]:name ),'debug').*/
/*    end.                                                                       */
    /*Henter ut Token*/
    assign 
      TokenStreng = string(poRequest:GetHeader('Authorization'))
    .

    if ServiceTable <> 'Token' then do:
      sessionid = poRequest:GetCookie('sessionid'):Value.
            
      JBoxServerAPI:Instance:sessionId = sessionid.
      log-manager:write-message(subst('sessionid: &1',sessionid),'debug').
      if not oLoginSession:validateSession(sessionid) then
        undo, throw new Progress.Lang.AppError('Loginsession not valid',401). 
/*      IF NOT oLoginSession:validateParameters(uid,Uuid) then                                                                */
/*        UNDO, THROW NEW Progress.Lang.AppError(oLoginSession:MessageStatus,int(StatusCodeEnum:NonAuthoritativeInformation)).*/
    end.

    CASE ServiceTable:
      WHEN 'members' THEN DO:
        oMembers = new members().
        oJSbody = new Progress.Json.ObjectModel.JsonObject().
        MESSAGE 'før..'
        VIEW-AS ALERT-BOX.
        oJSbody = cast(poRequest:Entity,Progress.Json.ObjectModel.JsonObject).
        MESSAGE 'her..' valid-object(oJSbody)
        VIEW-AS ALERT-BOX. 
        oMembers:getMembers(oJSbody).
        MESSAGE 'her2..'
        VIEW-AS ALERT-BOX.
        if oMembers:MessageStatus <> '' then 
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
        //log-manager:write-message(string(JsonOutput),'debug').
      end.
    end case.


    oBody = new OpenEdge.Core.String(JsonOutput).
    ASSIGN
      oResponse:Entity      = oBody
      oResponse:ContentType = 'application/json'
      .

    /* The WebResponseWriter ensures that the status line and
       all headers are writted out before the message body/entity. */
    oWriter = NEW WebResponseWriter(oResponse).
    oWriter:Open().
    oWriter:Close().
        
    /* A response of 0 means that this handler will build the entire response;
       a non-zero value is mapped to a static handler in the webapp's /static/error folder.
       The mappings are maintained in the webapps's WEB-INF/web.xml 
       A predefined set of HTTP status codes is provided in the OpenEdge.Net.HTTP.StatusCodeEnum 
       enumeration */
    RETURN 0.
    CATCH eAny AS Progress.Lang.Error :
      def var ErrorMsg as char no-undo.
      def var ErrorNumber as int no-undo.
      def var oJO as class Progress.Json.ObjectModel.JsonObject no-undo.
  
    LOG-MANAGER:WRITE-MESSAGE ('-->error: ' + string(eAny:GetMessageNum(1)) + ' ' + string(eAny:GetMessage(1)),'DEBUG').
      assign
        ErrorMsg    = eAny:GetMessage(1)
        ErrorNumber = eAny:GetMessageNum(1)
        ErrorNumber = if ErrorNumber gt 1 then ErrorNumber else INTEGER(StatusCodeEnum:BadRequest)
        .

      oJO = new Progress.Json.ObjectModel.JsonObject().
      oJO:Add("ErrorNumber",ErrorNumber).
      oJO:Add("ErrorMessage",ErrorMsg).
      
      
      oResponse               = NEW OpenEdge.Web.WebResponse().
      oResponse:StatusCode    = IF ErrorNumber ge 1 then ErrorNumber ELSE INTEGER(StatusCodeEnum:BadRequest). 
      oResponse:Entity        = oJO.
      oResponse:ContentType   = 'application/json'.
      oWriter = NEW WebResponseWriter(oResponse).

      oWriter:Open().
      oWriter:Close().
      return 0.
    END CATCH.

    FINALLY:

    END FINALLY.     
  END METHOD.
    
  /*------------------------------------------------------------------------------
          Purpose: Default handler for the HTTP GET method. The request being 
                   serviced and an optional status code is returned. A zero or 
                   null value means this method will deal with all errors.                                                               
          Notes:                                                                        

     The WebResponse body is a wrapper around an entire HTTP response message.
     It contains a status code and reason; headers; cookies and a message body.
           
     PF-level doc for this and related classes can be found at
     https://documentation.progress.com/output/oehttpclient/      

  ------------------------------------------------------------------------------*/
  METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    
    var char uid,Cookie,TokenStreng, ServiceMethod, ServiceVersion, ServiceTable,queryString,SessionId.
    var int MemberId,UriLength,sendtMemberId,ix.     
    
    var class OpenEdge.Net.HTTP.Cookie [] oCookies. 
    var class OpenEdge.Net.HTTP.HttpHeader [] oHeaders.
    var class LoginSession oLoginSession.
    var class jboxJSON oJSBody,oJSObject.
    var class oo.Toolbox oTool.
    var class Token oToken.
     
    var class OpenEdge.Net.HTTP.IHttpResponse oResponse.
    var class OpenEdge.Web.WebResponseWriter oWriter.
    var class OpenEdge.Core.String oBody.

    var longchar JsonOutput.

    var class Progress.Json.ObjectModel.JsonObject oData.
    var class members oMembers.
    
    log-manager:write-message('herinne...','debug').
    run jboxloadlib.p ("jboxuilib.p").
    JBoxSession:Instance:AppServerHandle = SESSION.
    
    do on error undo, throw:
    ASSIGN
      fix-codepage(JsonOutput) = 'UTF-8'
      UriLength                = NUM-ENTRIES(poRequest:UriTemplate,'/')
      ServiceVersion           = ENTRY(2,poRequest:UriTemplate,'/')
      ServiceTable             = ENTRY(3,poRequest:UriTemplate,'/')
      queryString              = poRequest:GetContextValue('query_string')
      .
      
      CATCH eAny AS Progress.Lang.Error :
        undo, throw new Progress.Lang.AppError(subst('Feilet i UriTemplate: &1',poRequest:UriTemplate),500).            
      END CATCH.
    end.
    
    oTool = new oo.Toolbox().
    oTool:buildList('queryString',queryString,'&').
    oLoginSession = new LoginSession().
    oResponse  = NEW OpenEdge.Web.WebResponse().
    
    log-manager:write-message(subst('UriLenght: &1 ServiceVersion:&2 ServiceTable: &3 - UriTemplate:&4 ',UriLength,ServiceVersion,ServiceTable,poRequest:UriTemplate),'debug').
    
    poRequest:GetCookies(output oCookies).
    poRequest:GetHeaders(output oHeaders).
    
/*    do ix = 1 to extent(oHeaders):                                             */
/*      log-manager:write-message(subst('lengde:&1',oHeaders[ix]:name ),'debug').*/
/*    end.                                                                       */
    /*Henter ut Token*/
    assign 
      TokenStreng = string(poRequest:GetHeader('x-Authorization'))
    .
log-manager:write-message(subst('header: &1',TokenStreng),'debug').
    IF NOT oLoginSession:validateParameters(uid,Cookie) then do:
      UNDO, THROW NEW Progress.Lang.AppError(oLoginSession:MessageStatus,int(StatusCodeEnum:NonAuthoritativeInformation)).
    end.
 
    if ServiceTable <> 'Token' then do:
      log-manager:write-message('her..','debug').
      
      sessionid = poRequest:GetCookie('sessionid'):Value.
      JBoxServerAPI:Instance:sessionId = sessionid.
      log-manager:write-message(subst('sessionid: &1',sessionid),'debug').
      if not oLoginSession:validateSession(sessionid) then
        undo, throw new Progress.Lang.AppError('Loginsession not valid',401). 
/*      IF NOT oLoginSession:validateParameters(uid,Uuid) then                                                                */
/*        UNDO, THROW NEW Progress.Lang.AppError(oLoginSession:MessageStatus,int(StatusCodeEnum:NonAuthoritativeInformation)).*/
    end.

    CASE ServiceTable:
      WHEN 'Token' THEN DO:
        assign 
          oToken = new Token()
          Uid         = oTool:getParameter('queryString','uid')
          Cookie      = poRequest:GetCookie('Uuid'):Value
          .
        log-manager:write-message(subst('Uid:&1 Cookie:',Uid,Cookie),'debug').
        if oToken:MessageStatus <> '' then
            undo, throw new Progress.Lang.AppError('Token feil: ' + oToken:MessageStatus,int(StatusCodeEnum:NonAuthoritativeInformation)).
  
        SessionId = oToken:newSessionId(uid,Cookie).
        oData = new Progress.Json.ObjectModel.JsonObject().
        oData:Add('sessionid',SessionId).
        oData:Write(JsonOutput).
        oResponse:StatusCode = INTEGER(StatusCodeEnum:OK).
      END.
      WHEN 'members' THEN DO:
        if poRequest:GetPathParameter('memberid') <> ? then do:
          sendtMemberId = int(poRequest:GetPathParameter('memberid')).
          log-manager:write-message(subst('messagestatus: &1',sendtmemberid),'info').
          oMembers = new members(SendtMemberId).
          if oMembers:MessageStatus <> '' then 
            log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').
        end.
        else do:
          oMembers = new members().
          if oMembers:MessageStatus <> '' then 
            log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').          
        end.

        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
      end.
      WHEN 'positions' THEN DO:
        oMembers = new members().
        if poRequest:GetPathParameter('memberid') <> ? then
          sendtMemberId = int(poRequest:GetPathParameter('memberid')).
        if sendtMemberId gt 0 then 
          oMembers:getPositions(sendtMemberId).
        else
          oMembers:getPositions().
        if oMembers:MessageStatus <> '' then do: 
          log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        end.          

        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
      end.
      WHEN 'SoknadTransType' THEN DO:
        oMembers = new members().
        oMembers:getSoknadTransType().
        if oMembers:MessageStatus <> '' then do: 
          log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        end.          

        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
      end.
      WHEN 'SoknadType' THEN DO:
        oMembers = new members().
        oMembers:getSoknadType().
        if oMembers:MessageStatus <> '' then do: 
          log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        end.          

        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
      end.
      WHEN 'SoknadStatus' THEN DO:
        oMembers = new members().
        oMembers:getSoknadStatus().
        if oMembers:MessageStatus <> '' then do: 
          log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        end.          

        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
      end.
      WHEN 'SoknadTrans' THEN DO:
        oMembers = new members().
        if poRequest:GetPathParameter('memberid') <> ? then
          sendtMemberId = int(poRequest:GetPathParameter('memberid')).
        if sendtMemberId gt 0 then 
          oMembers:getSoknadTrans(sendtMemberId).
        else
          undo, throw new Progress.Lang.AppError('Medlemsnr mangler',oMembers:MessageCode).
        
        if oMembers:MessageStatus <> '' then do: 
          log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        end.          

        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
      end.
      WHEN 'Soknad' THEN DO:
        
        oMembers = new members().
        if poRequest:GetPathParameter('memberid') <> ? then
          sendtMemberId = int(poRequest:GetPathParameter('memberid')).
        MESSAGE 'memberid:' poRequest:GetPathParameter('memberid')
        VIEW-AS ALERT-BOX.
        if sendtMemberId gt 0 then 
          oMembers:getSoknad(sendtMemberId).
        else
          undo, throw new Progress.Lang.AppError('Medlemsnr mangler',oMembers:MessageCode).
        
        if oMembers:MessageStatus <> '' then do: 
          log-manager:write-message(subst('messagestatus: &1',oMembers:MessageStatus),'info').
          undo, throw new Progress.Lang.AppError(oMembers:MessageStatus,oMembers:MessageCode).
        end.          

        if oMembers:JsonResult:Length ge 1 then 
          JsonOutput = oMembers:JsonResult:GetJsonText().
      end.
    end case.
    
    oBody = new OpenEdge.Core.String(JsonOutput).
    ASSIGN
      oResponse:Entity      = oBody
      oResponse:ContentType = 'application/json'
      .

    /* The WebResponseWriter ensures that the status line and
       all headers are writted out before the message body/entity. */
    oWriter = NEW WebResponseWriter(oResponse).
    oWriter:Open().
    oWriter:Close().
        
    /* A response of 0 means that this handler will build the entire response;
       a non-zero value is mapped to a static handler in the webapp's /static/error folder.
       The mappings are maintained in the webapps's WEB-INF/web.xml 
       A predefined set of HTTP status codes is provided in the OpenEdge.Net.HTTP.StatusCodeEnum 
       enumeration */
    RETURN 0.

    CATCH eAny AS Progress.Lang.Error :
      def var ErrorMsg as char no-undo.
      def var ErrorNumber as int no-undo.
      def var oJO as class Progress.Json.ObjectModel.JsonObject no-undo.
  
    LOG-MANAGER:WRITE-MESSAGE ('error: ' + string(eAny:GetMessageNum(1)) + ' ' + string(eAny:GetMessage(1)),'DEBUG').
      assign
        ErrorMsg    = eAny:GetMessage(1)
        ErrorNumber = eAny:GetMessageNum(1)
        ErrorNumber = if ErrorNumber gt 1 then ErrorNumber else INTEGER(StatusCodeEnum:BadRequest)
        .
/*    LOG-MANAGER:WRITE-MESSAGE ('error: ' + string(ErrorMsg) + ' ' + string(ErrorNumber),'DEBUG').*/

      oJO = new Progress.Json.ObjectModel.JsonObject().
      oJO:Add("ErrorNumber",ErrorNumber).
      oJO:Add("ErrorMessage",ErrorMsg).
      
      
      oResponse:StatusCode    = 200. //IF ErrorNumber ge 1 then ErrorNumber ELSE INTEGER(StatusCodeEnum:BadRequest). 
      oResponse:Entity        = oJO.
      oResponse:ContentType   = 'application/json'.
      oWriter = NEW WebResponseWriter(oResponse).

      oWriter:Open().
      oWriter:Close().
      return 0.
    END CATCH.

    FINALLY:

    END FINALLY.     
  END METHOD. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DESTRUCTOR PUBLIC norcalc ( ):

  END DESTRUCTOR.
     
     
       
    
END CLASS.