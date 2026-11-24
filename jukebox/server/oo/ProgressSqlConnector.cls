 
 /*------------------------------------------------------------------------
    File        : ProgressSqlConnector
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Tue Nov 15 21:21:20 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.ProgressSqlConnector: 

  DEF TEMP-TABLE ttError NO-UNDO SERIALIZE-NAME "Error"
      FIELD errorMessage AS CHAR
      FIELD errorNumber  AS INT SERIALIZE-HIDDEN
      .
  DEF PUBLIC PROPERTY httError AS HANDLE NO-UNDO GET. PROTECTED SET.
  
  DEF PUBLIC PROPERTY ProgressSqlConn   AS System.Data.Odbc.OdbcConnection NO-UNDO GET. PROTECTED SET.

  DEF PUBLIC PROPERTY SourceConnected AS LOGICAL NO-UNDO
      GET: RETURN VALID-OBJECT(ProgressSqlConn). END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY StatusMessage AS CHAR NO-UNDO GET. PROTECTED SET.  

  DEF PUBLIC PROPERTY sqlDriver   AS CHAR NO-UNDO INIT "Progress OpenEdge 12.2 Driver" GET. SET.
  DEF PUBLIC PROPERTY sqlHost     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPort     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlDatabase AS CHAR NO-UNDO  GET. SET.        
  DEF PUBLIC PROPERTY sqlUserid   AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPassword  AS CHAR NO-UNDO PRIVATE GET. SET.


  CONSTRUCTOR PUBLIC ProgressSqlConnector (  ):
      
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID addError(input ipErrorText as char):
      log-manager:WRITE-MESSAGE (ipErrorText). /*for å få fram feilen i loggen....*/
/*                                                              */
      CREATE ttError.
      ASSIGN ttError.errorMessage = ipErrorText.
      
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL doConnect (INPUT ihBuffer AS HANDLE):
    DEF VAR sqlConnect   AS CHAR NO-UNDO.
    
    StatusMessage = "".
    
    IF VALID-HANDLE(ihBuffer) AND ihBuffer:AVAIL THEN DO:
//      ASSIGN sqlHost
    END.  
    
    SqlConnect = 'DRIVER=' + CHR(123) + sqlDriver + CHR(125) 
               + ';HOST=' + sqlHost
               + ';PORT=' + sqlPort
               + ';DB='   + sqlDatabase
               + ';UID='  + sqlUserid
               + ';PWD='  + sqlPassword
               + ';DIL=0'.
    ProgressSqlConn = NEW System.Data.Odbc.OdbcConnection(sqlConnect). 
    ProgressSqlConn:Open().

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
    END CATCH.
    
    
    FINALLY:
    END FINALLY.

  END METHOD.

	DESTRUCTOR PUBLIC ProgressSqlConnector ( ):

	END DESTRUCTOR.
  
END CLASS.