 
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

CLASS oo.JBoxOdbcConnector: 

  DEF STREAM strSql.

  DEF PUBLIC PROPERTY ProgressODBC   AS System.Data.Odbc.OdbcConnection NO-UNDO GET. SET.

  DEF PUBLIC PROPERTY SourceConnected AS LOGICAL NO-UNDO
      GET: RETURN VALID-OBJECT(ProgressODBC) AND ProgressODBC:State = System.Data.ConnectionState:Open. END GET. 
      PROTECTED SET.
      
  DEF PUBLIC PROPERTY StatusMessage AS CHAR NO-UNDO GET. PROTECTED SET.  

  DEF PUBLIC PROPERTY sqlDriver   AS CHAR NO-UNDO INIT "Progress OpenEdge 12.2 Driver" GET. SET.
  DEF PUBLIC PROPERTY sqlHost     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPort     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlDatabase AS CHAR NO-UNDO  GET. SET.        
  DEF PUBLIC PROPERTY sqlUserid   AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPassword  AS CHAR NO-UNDO PRIVATE GET. SET.

  DEF PUBLIC PROPERTY connectionFile AS CHAR NO-UNDO GET. SET. 
  DEF PUBLIC PROPERTY sourceType     AS CHAR NO-UNDO GET. PROTECTED SET. 
  

  CONSTRUCTOR PUBLIC JBoxOdbcConnector (  ):
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL doConnect (INPUT ihBuffer AS HANDLE):

    DEF VAR sqlConnect   AS CHAR   NO-UNDO.
    DEF VAR cDriver      AS CHAR   NO-UNDO.
    DEF VAR hFld         AS HANDLE NO-UNDO.
    DEF VAR ConnectError AS CHAR   NO-UNDO.
    DEF VAR cSqlExp      AS CHAR   NO-UNDO.
    DEF VAR cCmd         AS CHAR   NO-UNDO.
    DEF VAR ix           AS INT    NO-UNDO.
    DEF VAR cStatus      AS CHAR   NO-UNDO EXTENT 4. 
    
    StatusMessage = "".
    
    IF VALID-HANDLE(ihBuffer) AND ihBuffer:AVAIL THEN DO ON ERROR UNDO, THROW:
      sourceType = ihBuffer::SourceType.
         
      hFld = ihBuffer:BUFFER-FIELD("SourceDriver") NO-ERROR.
      IF VALID-HANDLE(hFld) AND hFld:BUFFER-VALUE NE "" AND hFld:BUFFER-VALUE NE "<default>" THEN 
         sqlDriver = hFld:BUFFER-VALUE.
      ELSE
        sqlDriver = "Progress OpenEdge " + PROVERSION + " Driver".
        
      sqlHost      = ihBuffer::SourceHost.
      sqlPort      = ihBuffer::SourcePort.  
      sqlDatabase  = ihBuffer::SourceDb.  
      sqlUserid    = ihBuffer::SourceUser.  
      sqlPassword  = ihBuffer::SourcePwd.  

      SqlConnect = 'DRIVER=' + CHR(123) + sqlDriver + CHR(125) 
                 + ';HOST=' + sqlHost
                 + ';PORT=' + sqlPort
                 + ';DB='   + sqlDatabase
                 + ';UID='  + sqlUserid
                 + ';PWD='  + sqlPassword
                 + ';DIL=0'.

                 
      ProgressODBC = NEW System.Data.Odbc.OdbcConnection(sqlConnect). 
      ProgressODBC:ConnectionTimeout = 10000.
      ProgressODBC:Open().
    END.  

    CATCH ex AS System.Data.Odbc.OdbcException :
      StatusMessage = ex:Message.
    END CATCH.
        
    CATCH eApp AS Progress.Lang.AppError :
      StatusMessage = eApp:GetMessage(1).
    END CATCH.

    CATCH anyError AS Progress.Lang.Error :
      StatusMessage = "Error in doConnect: " + anyError:GetMessage(1).     
    END CATCH.
    
    FINALLY:
      IF StatusMessage NE "" THEN
        StatusMessage = StatusMessage  + CHR(10) + "Connect params:" + CHR(10)
        + "sqlDriver: " + sqlDriver + CHR(10)
        + "sqlHost: " + sqlHost + CHR(10)
        + "sqlDatabase: " + sqlDatabase + CHR(10)
        + "sqlUserid: " + sqlUserid + CHR(10)
        + "sqlPassword: " + (IF sqlPassword NE "" THEN "<unlike blank>" ELSE "<not set>")
        . 
      RETURN StatusMessage = "".
    END FINALLY.

  END METHOD.

  METHOD PUBLIC LOGICAL closeConnection ():
    ProgressODBC:Close().
  END METHOD.  

	DESTRUCTOR PUBLIC JBoxOdbcConnector ( ):

	END DESTRUCTOR.
  
END CLASS.