 
/*------------------------------------------------------------------------
   File        : Token
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : qa-3pthinc
   Created     : Wed Sep 18 10:49:53 CEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS Token: 

  DEFINE PROPERTY ClientId     AS CHARACTER NO-UNDO GET. 
    PRIVATE SET.
    
  DEFINE PROPERTY ClientSecret AS CHARACTER NO-UNDO GET. 
    PRIVATE SET.
    
  DEFINE PROPERTY Token AS CHARACTER NO-UNDO GET. 
    PRIVATE SET.
  
  DEFINE PROPERTY MessageStatus AS CHARACTER NO-UNDO GET. 
    PRIVATE SET.

  DEFINE VARIABLE base64Encoded AS CHARACTER                            NO-UNDO. 
  DEFINE VARIABLE base64Decoded AS CHARACTER                            NO-UNDO. 
  DEFINE VARIABLE ByteStreng    AS "System.Byte[]"                      NO-UNDO.
  DEFINE VARIABLE oToken        AS Progress.Json.ObjectModel.JsonObject NO-UNDO.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC Token (  ):
    
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER buildToken(  ):
    DEFINE VARIABLE shaAlgorithm AS System.Security.Cryptography.SHA256Managed NO-UNDO.
    DEFINE VARIABLE TextStreng   AS CHARACTER                                  NO-UNDO.

    clearStatus().                        
  
    shaAlgorithm = NEW System.Security.Cryptography.SHA256Managed().
    ByteStreng = shaAlgorithm:ComputeHash(System.Text.ASCIIEncoding:ASCII:GetBytes(STRING(NOW))).  
    TextStreng = System.BitConverter:ToString(ByteStreng).
    RETURN REPLACE(TextStreng,'-',''). /*Dette er bare en unique streng, så ett fett hvordan den ser ut*/
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER newSessionId(input ipUUid as char, input ipCookie as char  ):
    clearStatus().                        
    for each webbruker no-lock where WebBruker.guid   = ipUUid
                                 and WebBruker.Cookie = ipCookie: leave. end.
    if not avail webbruker then 
      undo, throw new Progress.Lang.AppError('Webbruker ikke funnet',403).
                                   
    do transaction:
      CREATE JBoxLoginSession.
      ASSIGN JBoxLoginSession.cSessionId  = buildToken()
             JBoxLoginSession.cJBoxUserId = string(WebBruker.Medlemsnr)
             JBoxLoginSession.cDateFormat = 'dmy'
             JBoxLoginSession.cNumFormat  = 'european'
             JBoxLoginSession.dCreated    = TODAY
             JBoxLoginSession.cLanguage   = 'NO'
             JBoxLoginSession.iLoginTime  = time
             .
    end.
    find current JBoxLoginSession no-lock.
    return JBoxLoginSession.cSessionId.
     
    CATCH eAny AS Progress.Lang.Error :
      log-manager:write-message(subst('ipUUid:&1 ipCookie:&2 - &3',ipUUid,ipCookie,eAny:GetMessage(1)),'debug').
      MessageStatus = eAny:GetMessage(1).  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Mottar clientid.clientsecret base64encoded, decoder og sjekker mot Clientid og ClientSecret i base
            og om ok, lager token som blir lagret i basen med en utløpsdato. Token som sendes skal inneholde 
            TOKEN: og Expirer: som json i base64 encoded.
            
   Notes:

  ------------------------------------------------------------------------------*/

  METHOD PUBLIC Progress.Json.ObjectModel.JsonObject getTokenByClientInfo(INPUT ipClientInfo AS CHARACTER  ):
    DEFINE VARIABLE oLoginSession AS CLASS    LoginSession NO-UNDO.
    DEFINE VARIABLE Expires       AS DATETIME NO-UNDO.
    def var isOk as log no-undo.
    def var ocSessionId as char no-undo.
    def var ocASUserName as char no-undo.
    def var oiCompanyId as int no-undo.
    def var hServer as handle no-undo.

    clearStatus().                        

/*log-manager:WRITE-MESSAGE ('Tipper 1: ', 'DEBUG').*/
    hServer = jboxsession:Instance:AppServerHandle.
    if not valid-handle(hServer) or (valid-handle(hServer) and not hServer:connected()) then do on error undo, throw:
      dynamic-function('reconnectServer').      
      hServer = jboxsession:Instance:AppServerHandle.
      if not valid-handle(hServer) then
        undo, throw new Progress.Lang.AppError('Ikke gyldig serverhandle',204).
      CATCH eConnect AS Progress.Lang.Error :
        undo, throw new Progress.Lang.AppError(eConnect:GetMessage(1),204).          
      END CATCH.
    end.

/*log-manager:WRITE-MESSAGE ('Tipper 2: ', 'DEBUG').*/

    ByteStreng = System.Convert:FromBase64String(ipClientInfo).
    base64Decoded = System.Text.ASCIIEncoding:ASCII:GetString(ByteStreng).

    IF NUM-ENTRIES(base64Decoded,':') LT 2 THEN 
      UNDO, THROW NEW Progress.Lang.AppError('Feil skilletegn mellom ClientId og ClientSecret, må være ":" :' + base64Decoded,1).
/*log-manager:WRITE-MESSAGE ('Tipper 3: ', 'DEBUG').*/

    ASSIGN 
      ClientId     = ENTRY(1,base64Decoded,':')
      ClientSecret = ENTRY(2,base64Decoded,':')
      .   
/*    DYNAMIC-FUNCTION("setASUserId",ClientId,"").                     */
/*    isOk = DYNAMIC-FUNCTION("getUserConfirmation",ClientSecret,"",0).*/
    RUN jbserv_validateuser.p ON hServer (ClientId,ClientSecret
                                            ,SESSION:DATE-FORMAT
                                            ,SESSION:NUMERIC-FORMAT
                                            ,OUTPUT ocSessionId
                                            ,OUTPUT ocASuserName
                                            ,OUTPUT oiCompanyId
                                            , OUTPUT isOk).
    if not isOk then undo, throw new Progress.Lang.AppError('Ugyldig brukernavn eller passord',204).
    
    oLoginSession = NEW LoginSession().
/*log-manager:WRITE-MESSAGE ('Tipper 4: ', 'DEBUG').*/
    
/*    Token = buildToken().*/
/*    LOG-MANAGER:WRITE-MESSAGE ('før NewSession ... TOKEN:' + string(Token),'debug').*/
/*    Expires = oLoginSession:newSession(ClientId,ocSessionId).*/
/*    LOG-MANAGER:WRITE-MESSAGE ('Expires:' + string(Expires),'debug').*/
/*log-manager:WRITE-MESSAGE ('Tipper 5: ', 'DEBUG').*/
    
    oToken = NEW Progress.Json.ObjectModel.JsonObject().
    oToken:Add('Token',ocSessionId).
    oToken:Add('Expires',Expires).
/*log-manager:WRITE-MESSAGE ('Tipper 6: ', 'DEBUG').*/

    RETURN oToken.               

    CATCH eAny AS Progress.Lang.Error :
      LOG-MANAGER:WRITE-MESSAGE (eAny:GetMessage(1),'ERROR').        
      MessageStatus = eAny:GetMessage(1).
    END CATCH.     
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER clearStatus(  ):
    MessageStatus = ''.
  END METHOD.

END CLASS.