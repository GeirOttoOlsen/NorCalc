/* Process a set of records sent from the client

   Created: 15/08/22 by Brynjar

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

{incl/validatecaller.i}

DEF VAR oEmail AS SendEmailDotNet NO-UNDO.

DEF VAR cMailHub  AS CHAR NO-UNDO.
DEF VAR cMailUser AS CHAR NO-UNDO.
DEF VAR cMailPwd  AS CHAR NO-UNDO.     
DEF VAR cFrom     AS CHAR NO-UNDO.
DEF VAR cTo       AS CHAR NO-UNDO.
DEF VAR cSubject  AS CHAR NO-UNDO.
DEF VAR cBody     AS CHAR NO-UNDO.
DEF VAR cLogFile  AS CHAR NO-UNDO.
DEF VAR cLine     AS CHAR NO-UNDO.

IF SEARCH("emaillogin.p") NE ? OR SEARCH("emaillogin.r") NE ? THEN RUN emaillogin.p (OUTPUT cMailHub,OUTPUT cMailUser,OUTPUT cMailPwd,OUTPUT cFrom,OUTPUT ocReturn).
ELSE DO:
  ocReturn = "Could not find emaillogin.p".
  RETURN.
END.
IF ocReturn NE "" THEN RETURN.

ASSIGN cTo      = ENTRY(1,icParam,"|")
       cSubject = ENTRY(2,icParam,"|")
       cBody    = ENTRY(3,icParam,"|")
       cLogFile = SESSION:TEMP-DIR + JBoxServerSide:Instance:UserId + "_emaillog_" + STRING(TIME) + ".log".
       . 
       
oEmail = NEW SendEmailDotNet(cMailHub,cMailUser,cMailPwd).    
ASSIGN oEmail:LogFile          = cLogFile      
       oEmail:SuppressErrorMsg = NO       
       oEmail:LogErrorsOnly    = YES
       oEmail:From             = cFrom
       oEmail:TO               = cTo
       oEmail:Subject          = cSubject
       oEmail:Body             = cBody
       . 
       
IF NOT oEmail:Send() THEN DO:
  INPUT FROM VALUE(cLogFile).
  REPEAT:
    IMPORT UNFORMATTED cLine.
    ocReturn = ocReturn + (IF ocReturn NE "" THEN CHR(1) ELSE "") + cLine.
  END.
  INPUT CLOSE.        
END.

FINALLY:
  obOk = ocReturn = "".
END FINALLY.

