 
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
USING OpenEdge.Net.HTTP.StatusCodeEnum.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS LoginSession:
/*  def buffer webbruker for webbruker.                                                                       */
/*                                                                                                            */
  DEFINE PROPERTY SessionID AS CHARACTER NO-UNDO GET. PRIVATE SET.
  DEFINE PROPERTY MessageStatus AS CHARACTER NO-UNDO GET. PRIVATE SET.
/*                                                                                                            */
/*  def public property memberid as int no-undo                                                               */
/*  get():                                                                                                    */
/*    return if avail jboxloginsession then int(JBoxLoginSession.cJBoxUserId) else 0.                         */
/*  end get. private set.                                                                                     */
/*                                                                                                            */
/*  def public property isAdminbruker as logical no-undo                                                      */
/*  get():                                                                                                    */
/*    for each webbruker no-lock where webbruker.medlemsnr = memberid by WebBruker.Innlogget desc: leave. end.*/
/*    if not avail webbruker then return false.                                                               */
/*    for each vervhist no-lock where vervhist.medlemsnr = memberid                                           */
/*                                and VervHist.Gruppe    = 'Forbundskontoret'                                 */
/*                                and VervHist.Tekst     = 'Adm RR-Lønn': leave. end.                         */
/*    return if avail vervhist then true else if memberid = 21020 then true else false.                       */
/*                       */
/*  end get. private set.*/
  
/*  DEFINE VARIABLE oRESTtilgang AS CLASS SysParameter NO-UNDO.*/
  
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

  METHOD PUBLIC DATETIME newSession():
    var handle hLogInTime,hLogOutTime.
    
    var int iDefaultLogoutInMsec.
    var datetime dtExpire.
    var parameter oParam.
    var logical isCreated.
    
    iDefaultLogoutInMsec = 4 * 3600. /*3600 = 1 time*/

    dtExpire = System.DateTime:UtcNow.
    dtExpire = ADD-INTERVAL(dtExpire,int(iDefaultLogoutInMsec / 3600),'HOURS').
    
    RETURN dtExpire.  
    
    CATCH eAny AS Progress.Lang.Error :
      MessageStatus = eAny:GetMessage(1).
      JBoxLogHandling:addLog('webhandling','ERROR:' + eAny:GetMessage(1)).
    END CATCH.     
  END METHOD.

  METHOD PUBLIC logical validateParameters(input ipuid as char,input ipUuid as char):
/*    log-manager:write-message(subst('Inne....&1--&2',ipuid,ipuuid),'debug').*/
/*    FOR EACH WebBruker no-lock where WebBruker.guid   = ipuid                 */
/*                                 and WebBruker.Cookie = ipUuid                */
/*                                 : leave. end.                                */
/*/*    log-manager:write-message(subst('Funnet:&1',avail WebBruker),'debug').*/*/
/*    if not avail webbruker then                                               */
/*      undo, throw new Progress.Lang.AppError('Authorisering feilet',401).     */
/*                                                                              */
/*    return avail WebBruker.                                                   */
                                     
    CATCH eAny AS Progress.Lang.Error :
      MessageStatus = eAny:GetMessage(1).  
    END CATCH.
  END METHOD.

  METHOD PUBLIC logical validateSession(input ipSessionid as char):
/*    FOR EACH JBoxLoginSession no-lock where JBoxLoginSession.cSessionId = ipSessionid: leave. end.*/
/*/*    log-manager:write-message(subst('Funnet:&1',avail WebBruker),'debug').*/                    */
/*    if not avail JBoxLoginSession then                                                            */
/*      undo, throw new Progress.Lang.AppError('Authorisering feilet',401).                         */
/*                                                                                                  */
/*    return avail JBoxLoginSession.                                                                */
                                     
    CATCH eAny AS Progress.Lang.Error :
      MessageStatus = eAny:GetMessage(1).  
    END CATCH.
  END METHOD.

 
END CLASS.