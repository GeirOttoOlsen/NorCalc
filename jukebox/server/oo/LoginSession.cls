 
/*------------------------------------------------------------------------
   File        : JBoxLoginSession
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : qa-3pthinc
   Created     : Tue Sep 17 15:01:56 CEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
//USING OpenEdge.Net.HTTP.StatusCodeEnum.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.LoginSession:

  DEFINE BUFFER jboxloginsession FOR jboxloginsession.
  DEFINE PROPERTY SessionID AS CHARACTER NO-UNDO 
    GET():
      RETURN IF AVAILABLE jboxloginsession THEN JBoxLoginSession.cSessionId ELSE ''. 
    END GET. 
    PROTECTED SET.
  
  DEFINE PROPERTY SessionCode AS CHARACTER NO-UNDO 
    GET():
      DEFINE VARIABLE vSessionCode AS CHARACTER NO-UNDO.
      IF AVAILABLE jboxloginsession AND entry(1,JBoxLoginSession.cContext,'=') = 'SessionCode' THEN 
      DO:
        ASSIGN 
          vSessionCode = ENTRY(2,JBoxLoginSession.cContext,'=')
          .
      END.
      RETURN vSessionCode. 
    END GET. 
    PROTECTED SET.

  DEFINE PROPERTY SessionUser AS CHARACTER NO-UNDO 
    GET():
      RETURN IF AVAILABLE jboxloginsession AND JBoxLoginSession.cJBoxUserId <> '' THEN JBoxLoginSession.cJBoxUserId ELSE ''.
    END GET. 
    PROTECTED SET.
  DEFINE PROPERTY MessageStatus AS CHARACTER NO-UNDO GET. 
    PROTECTED SET.
  DEFINE PROPERTY hasError AS LOG INIT FALSE NO-UNDO GET. 
    PROTECTED SET.
  DEFINE PROPERTY TilgangsType AS CHARACTER NO-UNDO GET. 
    PROTECTED SET.

  def property Uuid as char no-undo get. protected set.
    
  def property mnr as char no-undo 
    get():
      return if avail jboxloginsession then JBoxLoginSession.cJBoxUserId else ''. 
    end get. protected set.

  def property StatusMessage as char no-undo get. protected set.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:

  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC LoginSession ():

  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER encryptPassword(input ipPwdToHash as char):
    DEFINE VARIABLE loopInteger    AS INTEGER   NO-UNDO INIT 0.
    DEFINE VARIABLE firstHashedPwd AS CHARACTER NO-UNDO.
    DEFINE VARIABLE finalHashedPwd AS RAW       NO-UNDO.
    def var pwdToHash as char no-undo.
    
    finalHashedPwd = MESSAGE-DIGEST("SHA-512", ipPwdToHash).
    firstHashedPwd = STRING(finalHashedPwd). 
                
    REPEAT WHILE loopInteger < 15000:
        finalHashedPwd = MESSAGE-DIGEST("SHA-512", finalHashedPwd).
        loopInteger = loopInteger + 1.
    END.
    
    pwdToHash = STRING(finalHashedPwd).
    RETURN pwdToHash.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC DATETIME newSession(INPUT ipUsername AS CHARACTER):
    DEFINE VARIABLE hLogInTime           AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hLogOutTime          AS HANDLE    NO-UNDO.
    DEFINE VARIABLE iDefaultLogoutInMsec AS INTEGER   NO-UNDO.
    DEFINE VARIABLE dtExpire             AS DATETIME  NO-UNDO.
    DEFINE VARIABLE isCreated            AS LOG       NO-UNDO.
    DEFINE VARIABLE logoutTime           AS CHARACTER NO-UNDO.
    
    
    /*Ny session håndtering*/        
    iDefaultLogoutInMsec = 4 * 3600. /*3600 = 1 time -> 4 timer*/
    dtExpire = System.DateTime:UtcNow.
    dtExpire = ADD-INTERVAL(dtExpire,int(iDefaultLogoutInMsec / 3600),'HOURS').
    logoutTime = STRING(TIME + iDefaultLogoutInMsec).
    DO TRANSACTION:
      CREATE jboxLoginSession.
      ASSIGN 
        JBoxLoginSession.cSessionId  = Uuid
        JBoxLoginSession.cDateFormat = 'DMY'
        JBoxLoginSession.cNumFormat  = 'European'
        JBoxLoginSession.dCreated    = TODAY
        JBoxLoginSession.iLogoutTime = int(logoutTime) 
        JBoxLoginSession.cContext    = 'SessionCode=' + string(RANDOM(1,999999),"999999")
        SessionId                    = JBoxLoginSession.cSessionId
        JBoxLoginSession.cJBoxUserId = ipUsername  /*denne er ikke registrert i jboxuser, brukes som holder*/
        .
  
    END.

    /*    JBoxServerAPI:Instance:Update('JBoxLoginSession','cSessionId',ipToken,'iLogOutTime',string(TIME + iDefaultLogoutInMsec),false).*/


    RETURN dtExpire.

    CATCH eAny AS Progress.Lang.Error :
      MessageStatus = eAny:GetMessage(1).
      hasError = TRUE.
    END CATCH.
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL validateUser(input ipUsernameConverted as char, input ipPwdConverted as char):
/*    def var medlemsnr as int no-undo.                                                                                   */
/*    for first medlem no-lock where medlem.medlemsnr = int(ipUsernameConverted): leave. end.                             */
/*    if not avail medlem then                                                                                            */
/*      for first medlem no-lock where Medlem.Mobil   = int64(ipUsernameConverted): leave. end.                           */
/*    if not avail medlem then                                                                                            */
/*      UNDO, THROW NEW Progress.Lang.AppError('Fant ikke medlem med medlemsnr eller mobilnr:' + ipUsernameConverted,404).*/
/*                                                                                                                        */
/*    medlemsnr = medlem.medlemsnr.                                                                                       */
/*    for first medlem no-lock where medlem.medlemsnr = medlemsnr                                                         */
/*                                                                                                                        */
/*                               and medlem.passord   = encryptPassword(ipPwdConverted): leave. end.                      */
/*    if not avail medlem then                                                                                            */
/*      undo, throw new Progress.Lang.AppError('Feil passord er oppgitt',404).                                            */
    
    return true.
    
    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).
      return false.  
    END CATCH.    

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL ValidSession(ipSessionId AS CHARACTER):
    FOR FIRST JBoxLoginSession NO-LOCK WHERE JBoxLoginSession.cSessionId = ipSessionId: 
      LEAVE. 
    END.    
    IF NOT AVAILABLE jboxloginsession OR (JBoxLoginSession.dCreated LT TODAY OR (JBoxLoginSession.dCreated EQ TODAY AND JBoxLoginSession.iLogoutTime LT TIME))THEN 
      RETURN FALSE.
    RETURN TRUE.

    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).
      return false.  
    END CATCH.    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL ValidSessionCode(ipSessionId AS CHARACTER,INPUT ipSessionCode AS CHARACTER):
    FOR FIRST JBoxLoginSession NO-LOCK WHERE JBoxLoginSession.cSessionId = ipSessionId
                                         AND JBoxLoginSession.cContext   = 'SessionCode=' + ipSessionCode
      : 
      LEAVE. 
    END.
    IF NOT AVAILABLE jboxloginsession OR (JBoxLoginSession.dCreated LT TODAY OR (JBoxLoginSession.dCreated EQ TODAY AND JBoxLoginSession.iLogoutTime LT TIME))THEN 
      RETURN FALSE.
    DO TRANSACTION:          
      FIND CURRENT JBoxLoginSession EXCLUSIVE-LOCK NO-WAIT NO-ERROR. 
      IF NOT AVAILABLE jboxloginsession THEN RETURN FALSE.                               
      JBoxLoginSession.cContext = ''.      
    END.
    FIND CURRENT JBoxLoginSession NO-LOCK NO-ERROR.
    RETURN AVAILABLE jboxloginsession.
  END METHOD.

 
END CLASS.
