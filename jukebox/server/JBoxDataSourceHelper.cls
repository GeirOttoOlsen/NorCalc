 
 /*------------------------------------------------------------------------
    File        : JBoxDataSourceHelper
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : meg
    Created     : Fri Nov 11 10:50:06 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Json.ObjectModel.ObjectModelParser.
USING progress.Json.*.
USING progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxDataSourceHelper: 

  DEF TEMP-TABLE ttConnection
      FIELD SourceName    AS CHAR
      FIELD SourceType    AS CHAR
      FIELD SourceUser    AS CHAR
      FIELD SourcePwd     AS CHAR
      FIELD SourceHost    AS CHAR
      FIELD SourcePort    AS CHAR
      FIELD SourceDriver  AS CHAR
      FIELD SourceDb      AS CHAR
      FIELD SourceConnected AS LOG
      FIELD ConnectionInfo  AS CHAR
      FIELD oConnection AS Progress.Lang.Object
      .   
  
  DEF VAR hbttConnection AS HANDLE NO-UNDO.
  DEF VAR cJsonFileInfo  AS CHAR   NO-UNDO.
  DEF VAR bPwdPrompt     AS LOG    NO-UNDO.
  
  DEF VAR oOdbcConnector        AS oo.JBoxOdbcConnector NO-UNDO. 
  DEF VAR oProgressSqlConnector AS oo.JBoxProgressSqlConnector NO-UNDO. 
  DEF VAR oMsSqlConnector       AS oo.JBoxMsSqlConnector NO-UNDO. 

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxDataSourceHelper NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxDataSourceHelper().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEF PUBLIC PROPERTY dataSourceMessage AS CHAR GET. PROTECTED SET.


  CONSTRUCTOR PUBLIC JBoxDataSourceHelper (  ):
    hbttConnection = BUFFER ttConnection:HANDLE.
  END CONSTRUCTOR.

  METHOD PUBLIC oo.JboxDataSourceConnector connectDataSource(INPUT icDataSourceName AS CHAR).
  
    DEF VAR cSourceType AS CHAR     NO-UNDO.
    DEF VAR oJBoxDataSourceConnector AS oo.JboxDataSourceConnector NO-UNDO.
    DEF VAR rConnection AS ROWID    NO-UNDO.
    DEF VAR bok AS LOG NO-UNDO.
    DEF VAR cc AS CHAR NO-UNDO.
    DEF VAR bNew AS LOG NO-UNDO.

    dataSourceMessage = "".
    cJsonFileInfo = "".
        
    FIND FIRST ttConnection 
         WHERE ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".")
         NO-ERROR.
  
    IF NOT AVAIL ttConnection OR (AVAIL ttConnection AND NOT ttConnection.SourceConnected) THEN DO:
      IF NOT AVAIL ttConnection THEN DO:
        CREATE ttConnection.
        ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".").
        bNew = YES.
      END.
      ELSE cJsonFileInfo = ttConnection.ConnectionInfo.  
      rConnection = ROWID(ttConnection).
      IF ttConnection.SourcePwd = "" OR ttConnection.SourcePwd = "<blank>" THEN DO:
        bPwdPrompt = YES.
        IF NOT importSource(icDataSourceName,rConnection) THEN RETURN ?.
        FIND ttConnection WHERE ROWID(ttConnection) = rConnection.
      END.  
    END.
    ELSE rConnection = ROWID(ttConnection).
    
    IF VALID-OBJECT(ttConnection.oConnection) THEN DO:        
      oJBoxDataSourceConnector = CAST(ttConnection.oConnection,"oo.JboxDataSourceConnector").
      CASE ttConnection.SourceType:
        WHEN "MsSQL"       THEN 
          ttConnection.SourceConnected = oJBoxDataSourceConnector:MsSqlConnector:MsSqlConn:State = System.Data.ConnectionState:Open.
        WHEN "sqlexp"       THEN 
          ttConnection.SourceConnected = oJBoxDataSourceConnector:SqlExpConnector:SourceConnected.
        OTHERWISE 
          ttConnection.SourceConnected = oJBoxDataSourceConnector:OdbcConnector:ProgressODBC:State = System.Data.ConnectionState:Open.
/*        WHEN "REST"        THEN ttConnection.SourceConnected =*/
      END CASE.  
    END.  
    ELSE DO: 
      oJBoxDataSourceConnector = NEW oo.JBoxDataSourceConnector().
      ttConnection.oConnection = CAST(oJBoxDataSourceConnector,"Progress.Lang.Object").
    END.         
        
    IF NOT ttConnection.SourceConnected THEN DO ON ERROR UNDO, THROW:
      CASE ttConnection.SourceType:
        WHEN "MsSQL" THEN DO:
          oMsSqlConnector = NEW oo.JBoxMsSqlConnector().
          ttConnection.SourceConnected = oMsSqlConnector:doConnect(hbttConnection).
          IF NOT AVAIL ttConnection OR (AVAIL ttConnection AND NOT ttConnection.SourceConnected) OR oMsSqlConnector:statusMessage NE "" THEN DO:
            dataSourceMessage = oMsSqlConnector:statusMessage.
            IF AVAIL ttConnection THEN DELETE ttConnection.
            RETURN ?.
          END.  
          oJBoxDataSourceConnector:MsSqlConnector = oMsSqlConnector. 
        END.  
        WHEN "sqlexp" THEN DO:
          oProgressSqlConnector = NEW oo.JBoxProgressSqlConnector().
          ttConnection.SourceConnected = oProgressSqlConnector:doConnect(hbttConnection).
          IF NOT AVAIL ttConnection OR (AVAIL ttConnection AND NOT ttConnection.SourceConnected) OR oProgressSqlConnector:statusMessage NE "" THEN DO:
            dataSourceMessage = oProgressSqlConnector:statusMessage.
            IF AVAIL ttConnection THEN DELETE ttConnection.
            RETURN ?.
          END.  
          oJBoxDataSourceConnector:SqlExpConnector = oProgressSqlConnector.
        END.  
        OTHERWISE DO:
          oOdbcConnector = NEW oo.JBoxOdbcConnector().
          ttConnection.SourceConnected = oOdbcConnector:doConnect(hbttConnection).
          IF NOT AVAIL ttConnection OR (AVAIL ttConnection AND NOT ttConnection.SourceConnected) OR oOdbcConnector:statusMessage NE "" THEN DO:
            dataSourceMessage = oOdbcConnector:statusMessage.
            IF AVAIL ttConnection THEN DELETE ttConnection.
            RETURN ?.
          END.  
          oJBoxDataSourceConnector:OdbcConnector = oOdbcConnector.
        END.  
      END CASE.        
    END.  

    ASSIGN oJBoxDataSourceConnector:sourceConnected = ttConnection.SourceConnected
           oJBoxDataSourceConnector:sourceType = ttConnection.SourceType
           oJBoxDataSourceConnector:sourceDb = ttConnection.SourceDb.
  
    CATCH eApp AS Progress.Lang.AppError :
       dataSourceMessage = eApp:GetMessage(1).
    END CATCH.
    CATCH eErr AS Progress.Lang.Error :
       dataSourceMessage = eErr:GetMessage(1). 
    END CATCH.
    
    FINALLY:
      IF VALID-OBJECT(oJBoxDataSourceConnector) THEN
        RETURN oJBoxDataSourceConnector.
      ELSE DO:
        IF bNew THEN DELETE ttConnection.
        RETURN ?.
      END.    
    END FINALLY.
      
  END METHOD.

  METHOD PUBLIC CHARACTER getDbName(INPUT icDataSourceName AS CHAR).
  
    dataSourceMessage = "".
    cJsonFileInfo = "".
    
    IF NUM-ENTRIES(icDataSourceName,"\/") > 1 THEN
      FIND FIRST ttConnection 
           WHERE ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".")
           NO-ERROR.
    ELSE IF NUM-ENTRIES(icDataSourceName,".") > 1 THEN
      FIND FIRST ttConnection 
           WHERE ttConnection.SourceName = ENTRY(1,icDataSourceName,".")
             AND ttConnection.SourceDb = ENTRY(2,icDataSourceName,".")
           NO-ERROR.
    ELSE
      FIND FIRST ttConnection 
           WHERE ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".")
           NO-ERROR.
    IF NOT AVAIL ttConnection THEN getDataSourceType(icDataSourceName).
    IF AVAIL ttConnection THEN
      RETURN ttConnection.SourceDb.
    ELSE RETURN "".  
           
  END METHOD.

  METHOD PUBLIC CHARACTER getDataSourceType(INPUT icDataSourceName AS CHAR).
  
    DEF VAR cSourceType AS CHAR     NO-UNDO.
    DEF VAR rConnection AS ROWID    NO-UNDO.

    dataSourceMessage = "".
    cJsonFileInfo = "".
    IF NUM-ENTRIES(icDataSourceName,"\/") > 1 THEN
      FIND FIRST ttConnection 
           WHERE ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".")
           NO-ERROR.
    ELSE IF NUM-ENTRIES(icDataSourceName,".") > 1 THEN
      FIND FIRST ttConnection 
           WHERE ttConnection.SourceName = ENTRY(1,icDataSourceName,".")
             AND ttConnection.SourceDb = ENTRY(2,icDataSourceName,".")
           NO-ERROR.
    ELSE
      FIND FIRST ttConnection 
           WHERE ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".")
           NO-ERROR.

    IF NOT AVAIL ttConnection THEN DO:
      CREATE ttConnection.
      ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".").
      rConnection = ROWID(ttConnection).
      bPwdPrompt = NO.
      IF NOT importSource(icDataSourceName,rConnection) THEN DO:
        cJsonFileInfo = "".
        RETURN ?.
      END.  
      FIND ttConnection WHERE ROWID(ttConnection) = rConnection.
      ttConnection.ConnectionInfo = cJsonFileInfo.
    END.

    cJsonFileInfo = "".
    RETURN ttConnection.SourceType.

  END METHOD.

  METHOD PUBLIC CHARACTER getDataSourceType(INPUT icDataSourceName AS CHAR,
                                            INPUT icJsonFileInfo AS CHAR).
  
    DEF VAR cSourceType AS CHAR     NO-UNDO.
    DEF VAR rConnection AS ROWID    NO-UNDO.
    
    dataSourceMessage = "".
    cJsonFileInfo = icJsonFileInfo.
    
    FIND FIRST ttConnection 
         WHERE ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".")
         NO-ERROR.
         
    IF NOT AVAIL ttConnection THEN DO:
      CREATE ttConnection.
      ttConnection.SourceName = ENTRY(1,ENTRY(NUM-ENTRIES(icDataSourceName,"\/"),icDataSourceName,"\/"),".").
      rConnection = ROWID(ttConnection).
      bPwdPrompt = NO.
      IF NOT importSource(icDataSourceName,rConnection) THEN DO:
        cJsonFileInfo = "".
        DELETE ttConnection.
        RETURN ?.
      END.  
      FIND ttConnection WHERE ROWID(ttConnection) = rConnection.
      ttConnection.ConnectionInfo = cJsonFileInfo.
    END.

    cJsonFileInfo = "".
    RETURN ttConnection.SourceType.

  END METHOD.

  METHOD PUBLIC LOGICAL getIsDataSourceConnected(INPUT icDataSourceName AS CHAR):
    RETURN CAN-FIND(FIRST ttConnection WHERE ttConnection.SourceName = icDataSourceName AND ttConnection.SourceConnected).
  END METHOD.

  METHOD PUBLIC LOGICAL getIsDbConnected(INPUT icDataBaseName AS CHAR):
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR bConnected AS LOG NO-UNDO.
    
    IF NUM-ENTRIES(icDataBaseName,".") > 1 THEN
      bConnected = CAN-FIND(FIRST ttConnection 
                            WHERE ttConnection.SourceName = ENTRY(1,icDataBaseName,".")
                              AND ttConnection.SourceDb   = ENTRY(2,icDataBaseName,".")).
    ELSE                           
      DO ix = 1 TO NUM-DBS:
        IF LDBNAME(ix) = icDataBaseName THEN RETURN YES.
      END.  
      
    RETURN bConnected.
      
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED LOGICAL importSource(INPUT icDataSourceName AS CHAR, INPUT irConnection AS ROWID):
    
    DEF VAR cFileName   AS CHAR     NO-UNDO.  
    DEF VAR lcJson      AS LONGCHAR NO-UNDO.
    DEF VAR oJboxParser AS JBoxJsonParser NO-UNDO.
    DEF VAR ix          AS INT      NO-UNDO.
    DEF VAR bOk         AS LOG      NO-UNDO.
    DEF VAR hBuffer     AS HANDLE   NO-UNDO.
    DEF VAR cSourceType AS CHAR     NO-UNDO.
    DEF VAR cPwd        AS CHAR     NO-UNDO.
    DEF VAR cPrompt     AS CHAR     NO-UNDO.
    DEF VAR iReturn     AS INT      NO-UNDO.
    DEF VAR bScand      AS LOG      NO-UNDO.
    DEF VAR cOrgFile    AS CHAR     NO-UNDO.

    DEF BUFFER ttConnection FOR TEMP-TABLE ttConnection.
    
    def var oEncrypt as class JBoxCrypto no-undo.
    oEncrypt = new JBoxCrypto().
    
    dataSourceMessage = "".
    cOrgFile = icDataSourceName.
    
    FIX-CODEPAGE(lcJson) = "utf-8".
        
    IF cJsonFileInfo NE "" THEN 
      lcJson = cJsonFileInfo.
    ELSE DO:  
      IF NUM-ENTRIES(icDataSourceName,"\/") = 1 THEN DO:
        cFileName = SEARCH(icDataSourceName + ".json").
        IF cFileName = ? THEN 
          cFileName = SEARCH(icDataSourceName + "_connect.json").
        IF cFileName = ? THEN 
          cFileName = SEARCH(ENTRY(1,icDataSourceName,".") + ".json").
        IF cFileName = ? THEN 
          cFileName = SEARCH(ENTRY(1,icDataSourceName,".") + "_connect.json").
      END.
      ELSE cFileName = icDataSourceName.
    END.      

    IF cFileName NE ? OR cJsonFileInfo NE "" THEN DO:
      oJBoxParser = NEW JBoxJsonParser().
          
      IF cJsonFileInfo = "" THEN DO:
        COPY-LOB FROM FILE cFileName TO lcJson.
        cJsonFileInfo = STRING(lcJson).
      END.    
        
      oJboxParser:createSchema(lcJson, "jsonfields").
    
      IF oJboxParser:statusMessage NE "" THEN 
        UNDO, THROW NEW Progress.Lang.AppError(oJboxParser:statusMessage,0).

      hBuffer = oJboxParser:hdsResult:GET-BUFFER-HANDLE (2).
      IF NOT VALID-HANDLE(hBuffer) THEN
        UNDO, THROW NEW Progress.Lang.AppError ("Could not retrieve buffer 2 from connector dataset",0).
      bOk = hBuffer:FIND-FIRST() NO-ERROR.
      FIND ttConnection WHERE ROWID(ttConnection) = irConnection NO-ERROR.
      IF bOk AND AVAIL ttConnection THEN DO:
        DO ix = 1 TO hBuffer:NUM-FIELDS.
          IF hBuffer:BUFFER-FIELD(ix):NAME BEGINS "SourcePwd" THEN DO:
            IF hBuffer:BUFFER-FIELD(ix):NAME = "SourcePwd_encrypt" THEN
              cPwd = oEncrypt:decryptString(hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE).
            ELSE
              cPwd = hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE.  
          END.
          ELSE IF hBuffer:BUFFER-FIELD(ix):NAME MATCHES "*_encrypt" THEN
            hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE = oEncrypt:decryptString(hBuffer:BUFFER-FIELD(ix):BUFFER-VALUE).
        END.
        BUFFER ttConnection:HANDLE:BUFFER-COPY(hBuffer,"SourcePwd,SourceName").
        IF cPwd NE "" AND cPwd NE "<blank>" THEN 
          ttConnection.SourcePwd = cPwd.
        ELSE IF CAN-DO("WebClient,4GLclient",SESSION:CLIENT-TYPE) AND bPwdPrompt THEN DO:
          bScand = JBoxSession:Instance:Scandinavian NO-ERROR.
          IF ttConnection.SourceUser = "" THEN DO: 
            RUN JBoxAskForValue.w ((IF bScand THEN "Logg inn " ELSE "Login ") + ttConnection.SourceName
                                  ,(IF bScand THEN "Brukernavn" ELSE "Username") + "|CHARACTER|x(30)¤" + (IF bScand THEN "Passord" ELSE "Password") + "|CHARACTER|x(30)||pwd"
                                  ,INPUT-OUTPUT cPrompt,OUTPUT iReturn).
            IF iReturn = 2 THEN 
              ASSIGN ttConnection.SourceUser = ENTRY(1,cPrompt,"|")
                     ttConnection.SourcePwd = ENTRY(2,cPrompt,"|")
                     .
          END.
          ELSE DO:
            RUN JBoxAskForValue.w ((IF bScand THEN "Angi passord for " ELSE "Password for user ") + ttConnection.SourceUser + ", " + ttConnection.SourceName
                                  ,"CHARACTER|x(30)||pwd"
                                  ,INPUT-OUTPUT cPrompt,OUTPUT iReturn).
            IF iReturn = 2 THEN 
              ASSIGN ttConnection.SourcePwd = cPrompt
                     .
            ELSE dataSourceMessage = "cancelConnect".      
          END.                                         
        END.   
        ttConnection.SourceHost = REPLACE(ttConnection.SourceHost,"¤","\").  
      END.
      ELSE DO:
        IF NOT bOk THEN
          UNDO,THROW NEW Progress.Lang.AppError("Cannot find connector file-name: " + cFileName + " for datasource " + icDataSourceName,0).
        ELSE  
          UNDO,THROW NEW Progress.Lang.AppError("Cannot find connection for: " + icDataSourceName,0).
      END.  
    END.  
    ELSE UNDO,THROW NEW Progress.Lang.AppError("Cannot find connector file-name (org): " + cOrgFile,0).
 
    CATCH eApp AS Progress.Lang.AppError :
       dataSourceMessage = eApp:GetMessage(1). 
    END CATCH.
    CATCH eErr AS Progress.Lang.Error :
       dataSourceMessage = eErr:GetMessage(1). 
    END CATCH.
    
    FINALLY:
//      run toexcelviafile.p (hbttConnection,-2).
      RETURN dataSourceMessage = "".
    END FINALLY.

  END METHOD.
  
END CLASS.