 
 /*------------------------------------------------------------------------
    File        : JBoxMsSqlConnector
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Fri Dec 02 14:26:07 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.JBoxMsSqlConnector: 

  DEF TEMP-TABLE ttError NO-UNDO SERIALIZE-NAME "Error"
      FIELD errorMessage AS CHAR
      FIELD errorNumber  AS INT SERIALIZE-HIDDEN
      .
  DEF PUBLIC PROPERTY httError AS HANDLE NO-UNDO GET. PROTECTED SET.
       
  DEF PUBLIC PROPERTY MsSqlConn      AS System.Data.SqlClient.SqlConnection NO-UNDO GET. SET.

  DEF PUBLIC PROPERTY SourceConnected AS LOGICAL NO-UNDO
      GET: RETURN VALID-OBJECT(MsSqlConn). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY StatusMessage AS CHAR NO-UNDO 
      GET:
        FOR EACH ttError: 
          StatusMessage = StatusMessage + (IF StatusMessage NE "" THEN CHR(10) ELSE "") + ttError.errorMessage.
        END.
        RETURN StatusMessage.  
      END GET. 
      PROTECTED SET.  

  DEF PUBLIC PROPERTY sqlHost     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPort     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlDatabase AS CHAR NO-UNDO  GET. SET.        
  DEF PUBLIC PROPERTY sqlUserid   AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPassword  AS CHAR NO-UNDO PRIVATE GET. SET.

  DEF PUBLIC PROPERTY connectionFile AS CHAR NO-UNDO GET. SET. 
  DEF PUBLIC PROPERTY sourceType     AS CHAR NO-UNDO GET. PROTECTED SET. 
  

  CONSTRUCTOR PUBLIC JBoxMsSqlConnector (  ):
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL addError(input ipErrorText as char):
      log-manager:WRITE-MESSAGE (ipErrorText). /*for å få fram feilen i loggen....*/
/*                                                              */
      CREATE ttError.
      ASSIGN ttError.errorMessage = ipErrorText.
      
    RETURN NO.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     Integrated Security=SSPI
     https://community.progress.com/s/article/Sample-code-to-connect-to-and-read-data-from-a-SQL-Server-database-using-System-Data-SqlClient-object-from-the-ABL
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL doConnect (INPUT ihBuffer AS HANDLE):

    DEF VAR sqlConnect   AS CHAR NO-UNDO.
    DEF VAR cDriver      AS CHAR NO-UNDO.
    DEF VAR ix           AS INT NO-UNDO.
    DEF VAR SeqString    AS System.Security.SecureString NO-UNDO.
    DEF VAR SqlCred      AS System.Data.SqlClient.SqlCredential NO-UNDO.
        
    StatusMessage = "".
    
    IF VALID-HANDLE(ihBuffer) AND ihBuffer:AVAIL THEN DO:
      sourceType = ihBuffer::SourceType.
        
      sqlHost      = ihBuffer::SourceHost.
      sqlPort      = ihBuffer::SourcePort.  
      sqlDatabase  = ihBuffer::SourceDb.  
      sqlUserid    = ihBuffer::SourceUser.  
      sqlPassword  = ihBuffer::SourcePwd.  
        
      SeqString = NEW System.Security.SecureString().
      DO ix = 1 TO LENGTH(sqlPassword):
        SeqString:AppendChar(SUBSTR(sqlPassword,ix,1)).
      END.  
      SeqString:MakeReadOnly().
    
      SqlCred = NEW System.Data.SqlClient.SqlCredential(sqlUserid,SeqString).
      sqlConnect = "Server=" + sqlHost + ';Database=' + sqlDatabase .
      MsSqlConn = NEW System.Data.SqlClient.SqlConnection(sqlConnect,SqlCred). 
      MsSqlConn:Open().
    END.  
    

    CATCH eApp AS Progress.Lang.AppError :
      assign
        StatusMessage = eApp:GetMessage(1).
        .
        addError(StatusMessage).
    END CATCH.

    CATCH anyError AS Progress.Lang.Error :
      StatusMessage = "Error in doConnect: " + anyError:GetMessage(1) + CHR(10) + "Connect params:" + CHR(10)
        + "sqlHost: " + sqlHost + CHR(10)
        + "sqlDatabase: " + sqlDatabase + CHR(10)
        + "sqlUserid: " + sqlUserid + CHR(10)
        + "sqlPassword: " + (IF sqlPassword NE "" THEN "<unlike blank>" ELSE "<not set>")
        .      
        
      MESSAGE "StatusMessage" StatusMessage "sqlPass ok: " sqlPassword = "pro2sql"
      VIEW-AS ALERT-BOX.  
    END CATCH.
    
    
    FINALLY:
      RETURN StatusMessage = "".
    END FINALLY.

  END METHOD.

  METHOD PUBLIC LOGICAL closeConnection ():
    MsSqlConn:Close().
  END METHOD.  

  DESTRUCTOR PUBLIC JBoxMsSqlConnector ( ):

  END DESTRUCTOR.
  
END CLASS.