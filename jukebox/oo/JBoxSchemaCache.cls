 
 /*------------------------------------------------------------------------
    File        : JBoxSchemaCache
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : bryhasleadm
    Created     : Thu Oct 20 14:50:13 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxSchemaCache: 

  {tt_schema.i}

  DEF TEMP-TABLE ttSqlSchema NO-UNDO
    FIELD Db_Name          AS CHAR 
    FIELD Table_Type       AS CHAR FORMAT "x(12)"
    FIELD Table_Name       AS CHAR FORMAT "x(40)"
    FIELD Ordinal_Position AS INT  
    FIELD Column_Name      AS CHAR FORMAT "x(32)"
    FIELD Data_Type        AS CHAR FORMAT "x(20)"
    FIELD Column_Default   AS CHAR FORMAT "x(40)"
    FIELD Character_Maximum_Length AS INT64 FORMAT "->>>,>>>,>>9"
    FIELD RowCount         AS INT
    FIELD ColNameLength    AS INT
    FIELD OETableName      AS CHAR FORMAT "x(32)"
    FIELD OEFieldName      AS CHAR FORMAT "x(32)"
    FIELD OEdataType       AS CHAR FORMAT "x(10)"
    FIELD OEformat         AS CHAR FORMAT "x(25)"
    FIELD OElabel          AS CHAR FORMAT "x(32)"
    FIELD OEvalmsg         AS CHAR FORMAT "x(50)"
    FIELD cDataSourceType  AS CHAR
    . 

  DEF TEMP-TABLE ttSqlIndex NO-UNDO
    FIELD Table_name       AS CHAR
    FIELD Column_name      AS CHAR
    FIELD Index_name       AS CHAR
    FIELD Unique_Index     AS CHAR
    FIELD Index_seq        AS INT
    .
      
  DEF VAR hbttSqlIndex AS HANDLE NO-UNDO.

  DEF DATASET dsSqlSchema FOR ttSqlSchema, ttSqlIndex.
  DEF VAR hDsSqlSchema  AS HANDLE NO-UNDO.
  DEF VAR bOkUser       AS LOG    NO-UNDO.
  DEF VAR cAsuserName   AS CHAR   NO-UNDO.
  DEF VAR cSessionId    AS CHAR   NO-UNDO.
  DEF VAR iCompanyId    AS INT    NO-UNDO. 
  DEF VAR cOrgSessionId AS CHAR   NO-UNDO.
  DEF VAR hOrgAsHandle  AS HANDLE NO-UNDO.
  DEF VAR hGlobSchemaHolder AS HANDLE NO-UNDO.

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxSchemaCache NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxSchemaCache().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEF PUBLIC PROPERTY hbttSqlSchema AS HANDLE NO-UNDO GET. PROTECTED SET.
  
  DEF PUBLIC PROPERTY SchemaMessage AS CHAR NO-UNDO GET. PROTECTED SET.
  
  DEF PUBLIC PROPERTY ProgressSchemaFetched AS LOG NO-UNDO 
      GET: RETURN CAN-FIND(FIRST tt_db WHERE CAN-DO("ProgressDb,ProgressApsv",tt_db.cSourceType)). END GET.

  DEF PUBLIC PROPERTY SqlSchemaFetched AS LOG NO-UNDO 
      GET: RETURN CAN-FIND(FIRST tt_db WHERE tt_db.cSourceType MATCHES "*.sql"). END GET.
      
  
  DEF VAR bCallAppserver AS LOG NO-UNDO.
      
  CONSTRUCTOR PUBLIC JBoxSchemaCache ():
    SUPER ().
    
    IF CAN-DO("webclient,4GLclient",SESSION:CLIENT-TYPE) THEN
      RUN JBoxSchemaCacheGlobal.p PERSIST SET hGlobSchemaHolder.
    hdsSchema     = DATASET dsSchema:HANDLE.
    hDsSqlSchema  = DATASET dsSqlSchema:HANDLE.
    hOrgAsHandle  = DYNAMIC-FUNCTION("getAppserviceHandle") NO-ERROR.
    IF NOT ERROR-STATUS:ERROR THEN 
      bCallAppserver = (hOrgAsHandle NE ? AND hOrgAsHandle NE SESSION) OR (PROGRESS = "full" AND SESSION:CLIENT-TYPE = "4GLclient").
    ELSE bCallAppserver = NO.  
    cOrgSessionId = DYNAMIC-FUNCTION("getSessionId").
    IF NOT bCallAppserver THEN
      JBoxServerSide:Instance:InitializeObject(?,cOrgSessionId).
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL clearSchema( INPUT icDataSource AS CHAR ):
    
    FOR EACH tt_db 
        WHERE tt_db.cSourceName = icDataSource:
          
      FOR EACH tt_file 
          WHERE tt_file.iDbNum = tt_db.iDbNum:
        FOR EACH tt_index
            WHERE tt_index.iFileNum = tt_file.iFileNum:
          DELETE tt_index.
        END.    
        FOR EACH tt_index-field
            WHERE tt_index-field.iFileNum = tt_file.iFileNum:  
          DELETE tt_index-field.
        END.
        DELETE tt_file.      
      END.      
                  
      FOR EACH tt_field
          WHERE tt_field.iDbNum = tt_db.iDbNum:
        DELETE tt_field.
      END.
      
      FOR EACH tt_sequence
          WHERE tt_sequence.iDbNum = tt_db.iDbNum
          :
        DELETE tt_sequence.
      END.        
      
      DELETE tt_db.
    END.         
             
    RETURN YES.   
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID dbLogin( INPUT icUser AS CHAR,INPUT icSourceName AS CHAR,INPUT ihAppServer AS HANDLE ):
    bOkUser = NO.
    /*
    RUN JBoxCallLogin.p (icUser,"EN",OUTPUT bOkUser).
    */
    DEF VAR bScand       AS LOG  NO-UNDO.
    DEF VAR cPrompt      AS CHAR NO-UNDO.
    DEF VAR iReturn      AS INT  NO-UNDO.
    DEF VAR cPwd         AS CHAR NO-UNDO.
    DEF VAR ocSessionId  AS CHAR NO-UNDO.
    DEF VAR ocAsUserName AS CHAR NO-UNDO.
    DEF VAR oiCompanyId  AS INT  NO-UNDO.
    
    IF CAN-DO("WebClient,4GLclient",SESSION:CLIENT-TYPE) THEN DO:
      bScand = JBoxSession:Instance:Scandinavian.
      IF icUser = "" THEN DO: 
        RUN JBoxAskForValue.w ((IF bScand THEN "Logg inn " ELSE "Login ") + icSourceName
                              ,(IF bScand THEN "Brukernavn" ELSE "Username") + "|CHARACTER|x(30)¤" + (IF bScand THEN "Passord" ELSE "Password") + "|CHARACTER|x(30)||pwd"
                              ,INPUT-OUTPUT cPrompt,OUTPUT iReturn).
        IF iReturn = 2 THEN
          ASSIGN icUser = ENTRY(1,cPrompt,"|")
                 cPwd   = ENTRY(2,cPrompt,"|"). 
      END.
      ELSE DO:
        RUN JBoxAskForValue.w ((IF bScand THEN "Angi passord for " ELSE "Password for user ") + icUser + " for " + icSourceName
                              ,"CHARACTER|x(30)||pwd"
                              ,INPUT-OUTPUT cPrompt,OUTPUT iReturn).
        IF iReturn = 2 THEN 
          cPwd   = cPrompt.
      END.
      IF iReturn = 2 THEN DO:
        RUN jbserv_validateuser.p ON ihAppServer (icUser,cPwd,
                                           SESSION:DATE-FORMAT,
                                           SESSION:NUMERIC-FORMAT,
                                           OUTPUT ocSessionId,
                                           OUTPUT ocASuserName,
                                           OUTPUT oiCompanyId,
                                           OUTPUT bOkUser).
        IF bOkUser THEN DO:
          ASSIGN cSessionId  = ocSessionId
                 cAsuserName = ocAsUserName
                 iCompanyId  = oiCompanyId.
          DYNAMIC-FUNCTION("initASconnection",icSourceName,ihAppServer,ocSessionId,icUser,ocAsUserName,oiCompanyId,YES).
        END.         
      END.                                       
    END.   
    
  END METHOD.

  // Use to retrieve schema for (pre-)existing connections (connections at startup) to Progress db or appserver.
  METHOD PUBLIC LOGICAL getDbSchema(INPUT ihDsSchema AS HANDLE):

    DEF VAR cSqlDbList     AS CHAR NO-UNDO.
    DEF VAR ix             AS INT  NO-UNDO.
    DEF VAR bReceivedByRef AS LOG  NO-UNDO.
 
    SchemaMessage = "".
    IF NOT CAN-FIND(FIRST tt_db) THEN DO:
      IF bCallAppserver THEN DO:
        THIS-OBJECT:getProgressDbSchema(?,
                   (IF hOrgAsHandle = ? OR hOrgAsHandle = SESSION THEN "ProgressDb" ELSE "ProgressApsv"),
                   (IF hOrgAsHandle = ? OR hOrgAsHandle = SESSION THEN "ProgressDb" ELSE "ProgressApsv"),
                   hOrgAsHandle,"",ENTRY(1,SESSION:PARAMETER,";")).
        DYNAMIC-FUNCTION("initASconnection","ProgressApsv",hOrgAsHandle,DYNAMIC-FUNCTION("getSessionId"),JBoxSession:Instance:UserId,JBoxSession:Instance:UserName,JBoxSession:Instance:CompanyId,YES).
        // Pick up schemas for any sql connections defined on the appserver that hasn't already been loaded:
        cSqlDbList = JBoxSession:Instance:getJboxAttribute("SqlDbList").
        IF cSqlDbList NE "" THEN DO:
      
          DO ix = 1 TO NUM-ENTRIES(cSqlDbList):
            IF NOT CAN-FIND(FIRST tt_db WHERE tt_db.cSourceName = ENTRY(1,ENTRY(ix,cSqlDbList),"|")) THEN DO:
              IF NOT getSqlDbSchema(?,
                                         ENTRY(1,ENTRY(ix,cSqlDbList),"|"), // data source name
                                         ENTRY(2,ENTRY(ix,cSqlDbList),"|"), // db name
                                         ENTRY(3,ENTRY(ix,cSqlDbList),"|"), // db type
                                         JBoxSession:Instance:AppServerHandle) THEN  // db type (equals datasource type for sql)
                MESSAGE JBoxSchemaCache:Instance:SchemaMessage
                VIEW-AS ALERT-BOX.                         
            END.  
          END.  
        END. 
        
      END.  
      ELSE IF NUM-DBS > 0 THEN DO:
        THIS-OBJECT:getProgressDbSchema(ihDsSchema,"ProgressDb","ProgressDb",SESSION,"","").
        DYNAMIC-FUNCTION("initASconnection","ProgressDb",SESSION,DYNAMIC-FUNCTION("getSessionId"),JBoxSession:Instance:UserId,JBoxSession:Instance:UserName,JBoxSession:Instance:CompanyId,YES).
      END.  
      FOR EACH tt_db: tt_db.hServer = IF hOrgAsHandle NE ? THEN hOrgAsHandle ELSE SESSION. END. 
    END.    

    IF CAN-DO(SOURCE-PROCEDURE:INTERNAL-ENTRIES,"receiveSchemaByRef") THEN
      RUN receiveSchemaByRef IN SOURCE-PROCEDURE (DATASET dsSchema BY-REFERENCE,OUTPUT bReceivedByRef).
    IF NOT bReceivedByRef AND VALID-HANDLE(ihDsSchema) THEN
      ihDsSchema:COPY-DATASET (hdsSchema,YES,NO,YES).
    
    IF VALID-HANDLE(hGlobSchemaHolder) THEN
      RUN refreshGlobal IN hGlobSchemaHolder(hdsSchema).
    
    FINALLY:
      RETURN SchemaMessage = "".
    END.   
    
  END METHOD.

  // Obtain schema for new connection (loaded in session)
  METHOD PUBLIC LOGICAL getDbSchema(INPUT ihDsSchema AS HANDLE,icConnectionFile AS CHAR):
    DEF VAR oJboxParser    AS JboxJsonParser NO-UNDO.
    DEF VAR lcJson         AS LONGCHAR NO-UNDO.
    DEF VAR cSourceName    AS CHAR     NO-UNDO.
    DEF VAR cSourceType    AS CHAR     NO-UNDO.
    DEF VAR cSourceHost    AS CHAR     NO-UNDO.
    DEF VAR cSourcePort    AS CHAR     NO-UNDO.
    DEF VAR cSourceDb      AS CHAR     NO-UNDO.
    DEF VAR cUser          AS CHAR     NO-UNDO.
    DEF VAR hAppServer     AS HANDLE   NO-UNDO.
    DEF VAR bReceivedByRef AS LOG      NO-UNDO.

    FIX-CODEPAGE(lcJson) = "utf-8".
    
    THIS-OBJECT:setUseDefaultConnection().

    SchemaMessage = "".
    
/*    IF VALID-HANDLE(ihDsSchema) AND SEARCH(icConnectionFile) = ? THEN                                                                        */
/*      UNDO, THROW NEW Progress.Lang.AppError("Cannont find connection file: " + (IF icConnectionFile NE ? THEN icConnectionFile ELSE "?"),0).*/
/*    ELSE IF VALID-HANDLE(ihDsSchema) AND SEARCH(icConnectionFile) NE ? THEN                                                                  */
/*      COPY-LOB FROM FILE icConnectionFile TO lcJson.                                                                                         */
/*    ELSE IF NOT VALID-HANDLE(ihDsSchema) THEN                                                                                                */
/*      lcJson = icConnectionFile.                                                                                                             */

    IF SEARCH(icConnectionFile) NE ? THEN
      COPY-LOB FROM FILE icConnectionFile TO lcJson.
    ELSE
      lcJson = icConnectionFile.  
            
    oJBoxParser = NEW JBoxJsonParser().
      
    oJboxParser:createSchema(lcJson, "jsonfields").
  
    IF oJboxParser:statusMessage NE "" THEN 
      UNDO, THROW NEW Progress.Lang.AppError(oJboxParser:statusMessage,0).

    cSourceDb = oJboxParser:getResultFirstFieldValue("JBoxDataSource","SourceDb").
    IF cSourceDb = ? THEN 
      UNDO, THROW NEW Progress.Lang.AppError("Missing SourceDb in connection file",0).

    cSourceName = oJboxParser:getResultFirstFieldValue("JBoxDataSource","SourceName").
    IF cSourceName = ? THEN 
      UNDO, THROW NEW Progress.Lang.AppError("Missing SourceName in connection file",0).    

    FIND FIRST tt_db WHERE tt_db.cSourceName = cSourceName NO-ERROR.
    IF AVAIL tt_db AND CAN-FIND(FIRST tt_file WHERE tt_file.cLDBname = tt_db.cLDBname) THEN 
      UNDO, THROW NEW Progress.Lang.AppError(cSourceName + " already connected",0).
 
    cSourceType = oJboxParser:getResultFirstFieldValue("JBoxDataSource","SourceType").
    IF cSourceType = ? THEN 
      UNDO, THROW NEW Progress.Lang.AppError("Missing SourceType in connection file",0).
          
    cSourceHost = oJboxParser:getResultFirstFieldValue("JBoxDataSource","SourceHost").
    IF cSourceHost = ? THEN 
      UNDO, THROW NEW Progress.Lang.AppError("Missing SourceHost in connection file",0).    

    IF cSourceType MATCHES "*sql*" THEN
      THIS-OBJECT:getSqlDbSchema(ihDsSchema,cSourceDb,cSourceName,cSourceType,lcJson,icConnectionFile).
    ELSE IF cSourceType = "file" THEN DO:
      FILE-INFO:FILE-NAME = cSourceHost.
      IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
        IF readDataFjordSchema(cSourceHost) THEN
          UNDO, THROW NEW Progress.Lang.AppError("Error reading Datafjord schema from " + FILE-INFO:FULL-PATHNAME,0).    
      END.  
    END.    
    ELSE DO:
      cUser = oJboxParser:getResultFirstFieldValue("JBoxDataSource","SourceUser").
      IF cUser = ? THEN cUser = OS-GETENV("username").

      IF cSourceType = "ProgressApsv" THEN DO:
        CREATE SERVER hAppServer.
        IF cSourceHost BEGINS "http" THEN cSourceHost = "-URL " + cSourceHost.
        hAppServer:CONNECT(cSourceHost) NO-ERROR.
        IF hAppServer:CLIENT-CONNECTION-ID NE "" THEN 
          dbLogin(cUser,cSourceName,hAppserver).
        IF bOkUser AND NOT VALID-HANDLE(hOrgAsHandle) THEN 
          ASSIGN hOrgAsHandle = hAppServer
                 cOrgSessionId = cSessionId.  
      END.      
      ELSE IF cSourceType = "ProgressDb" THEN DO:
        IF SESSION:CLIENT-TYPE = "webclient" THEN
          UNDO, THROW NEW Progress.Lang.AppError("Cannot connect Progress database with Webclient",0).
        cSourcePort = oJboxParser:getResultFirstFieldValue("JBoxDataSource","SourcePort").
        IF cSourcePort = ? THEN 
          UNDO, THROW NEW Progress.Lang.AppError("Missing SourcePort in connection file",0).
              
        CONNECT VALUE("-db " + cSourceDb + "-H " + cSourceHost + " -S " + cSourcePort).
        hAppServer = SESSION.
        dbLogin(cUser,cSourceName,hAppServer).
      END.
      IF bOkUser THEN DO:
        DYNAMIC-FUNCTION("setDisableAsLibCache",YES).
        THIS-OBJECT:getProgressDbSchema(?,cSourceName,cSourceType,hAppServer,icConnectionFile,cSourceHost).
        THIS-OBJECT:setUseDefaultConnection().
      END.    
      ELSE  
        UNDO, THROW NEW Progress.Lang.AppError("Invalid user/pwd",0).    
    END.

    IF CAN-DO(SOURCE-PROCEDURE:INTERNAL-ENTRIES,"receiveSchemaByRef") THEN
      RUN receiveSchemaByRef IN SOURCE-PROCEDURE (DATASET dsSchema BY-REFERENCE,OUTPUT bReceivedByRef).
    IF NOT bReceivedByRef AND VALID-HANDLE(ihDsSchema) THEN
      ihDsSchema:COPY-DATASET (hdsSchema,NO,YES,YES).

    CATCH eAppErr AS Progress.Lang.AppError :
      SchemaMessage = eAppErr:GetMessage(1).  
    END CATCH.
    CATCH eErr AS Progress.Lang.Error :
      SchemaMessage = eErr:GetMessage(1).  
    END CATCH.
    
    FINALLY:
      DELETE OBJECT oJboxParser NO-ERROR.
      RETURN SchemaMessage = "".
    END.   
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Fetch Progress schema
   Notes:   
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE LOGICAL getProgressDbSchema(INPUT ihDsSchema   AS HANDLE
                                            ,INPUT icSourceName AS CHAR
                                            ,INPUT icSourceType AS CHAR
                                            ,INPUT ihServer     AS HANDLE
                                            ,INPUT icConnectionFile AS CHAR
                                            ,INPUT icSourceHost AS CHAR):
    DEF VAR ix           AS INT    NO-UNDO.
    DEF VAR cSourceList  AS CHAR   NO-UNDO.
    DEF VAR cAddedDbList AS CHAR   NO-UNDO.

    FOR EACH tt_db: cSourceList = cSourceList + (IF cSourceList NE "" THEN "," ELSE "") + tt_db.cSourceName. END.

    SchemaMessage = "".
    
    IF JBoxServerAPI:Instance:CallServerProc("jbserv_getnumdbconnected.p","") THEN DO:
      ix = INT(JBoxServerAPI:Instance:getCallReturnParam()).
      IF ix > 0 THEN DO:
        JBoxServerAPI:Instance:DatasetReplace = NO.
        IF NOT JBoxServerAPI:Instance:CallServerProc("jbserv_getschema.p","",hDsSchema) THEN
          UNDO, THROW NEW Progress.Lang.AppError(JBoxServerAPI:Instance:getCallMessage(),0).
      END.
    END.
    
    CATCH eAppError AS Progress.Lang.AppError :
      SchemaMessage = eAppError:GetMessage(1).        
    END CATCH.
          
    FINALLY:
      IF SchemaMessage = "" THEN DO:      
        FOR EACH tt_db WHERE
            IF cSourceList NE "" THEN NOT CAN-DO(cSourceList,tt_db.cSourceName) ELSE TRUE:
          ASSIGN tt_db.cSourceName = icSourceName
                 tt_db.cSourceType = icSourceType
                 tt_db.hServer     = ihServer
                 tt_db.cConnection = icConnectionFile
                 tt_db.cSourceHost = icSourceHost
                 cAddedDbList      = cAddedDbList + (IF cAddedDbList NE "" THEN "," ELSE "") + tt_db.cLDBname. 
        END.
        IF VALID-HANDLE(ihDsSchema) THEN
          ihDsSchema:COPY-DATASET (hdsSchema,NO,YES,YES). // full replace of schema in caller
        DYNAMIC-FUNCTION("addAsLibCache",cAddedDbList) NO-ERROR. // update aslib schema cache
        RETURN YES.
      END.
      ELSE RETURN NO.
    END FINALLY.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL getIsDbConnected( INPUT icDataSource AS CHAR
                                         ,INPUT icDataSourceType AS CHAR 
                                         ,INPUT icDbName AS CHAR ):
    
    FIND FIRST tt_db
         WHERE tt_db.cSourceName = icDataSource
           AND tt_db.cLDBname = icDbName
         NO-ERROR.
         
    IF icDataSourceType MATCHES "*sql*" THEN DO:
      IF AVAIL tt_db AND VALID-HANDLE(tt_db.hServer) THEN RETURN TRUE. // If (sql) connection is pre-defined (defined on startup) and calls are done via appserver
      ELSE IF bCallAppserver THEN RETURN JboxServerApi:Instance:CallServerProc("jbserv_get_is_db_connected.p",icDataSource + "." + icDbName).
      ELSE RETURN JboxServerSide:Instance:CallServerProc("jbserv_get_is_db_connected.p",icDataSource + "." + icDbName).
    END.  
    IF AVAIL tt_db THEN       
      RETURN VALID-HANDLE(tt_db.hServer).
      
    RETURN NO.
  END METHOD.

  METHOD PUBLIC LOGICAL getIsDbConnected( INPUT iiDbNum AS INT ):
        
    RETURN CAN-FIND(FIRST tt_db WHERE tt_db.iDbNum = iiDbNum AND VALID-HANDLE(tt_db.hServer)).

  END METHOD.

  // Connect using connection file
  METHOD PUBLIC LOGICAL getSqlDbSchema(INPUT ihDsSchema   AS HANDLE
                                      ,INPUT icDbName     AS CHAR
                                      ,INPUT icSourceName AS CHAR
                                      ,INPUT icDbType     AS CHAR 
                                      ,INPUT ilcFile      AS LONGCHAR
                                      ,INPUT icConnectionFile AS CHAR):
  
    DEF VAR cDataSource AS CHAR NO-UNDO.
    DEF VAR cDbNumList  AS CHAR NO-UNDO.
    SchemaMessage = "".
    
    FOR EACH tt_db: cDbNumList = cDbNumList + (IF cDbNumList NE "" THEN "," ELSE "") + STRING(tt_db.iDbNum). END.
    
    IF bCallAppserver THEN DO:
      // Establishes the connection record (if it doesn't exist already)
      IF JBoxServerApi:Instance:CallServerProc("jbserv_get_datasource_type.p",icSourceName + CHR(1) + STRING(ilcFile)) THEN DO:
        IF ENTRY(1,JBoxServerApi:Instance:getCallReturnParam(),"|") = icDbType THEN   
          THIS-OBJECT:getSqlDbSchema(?,icDbName,icSourceName,icDbType).
        ELSE SchemaMessage = "Mismatch in data source type: " + icDbType + " / " + JBoxServerAPI:Instance:getCallReturnParam().    
      END.
      ELSE SchemaMessage = JBoxServerApi:Instance:getCallMessage().
    END.
    ELSE DO:
      IF JBoxServerSide:Instance:CallServerProc("jbserv_get_datasource_type.p",icSourceName + CHR(1) + STRING(ilcFile)) THEN   
        THIS-OBJECT:getSqlDbSchema(?, icDbName, icSourceName, ENTRY(1,JBoxServerSide:Instance:getCallReturnParam(),"|")).
      ELSE SchemaMessage = JBoxServerSide:Instance:getCallMessage().
    END.  
    
    FINALLY:
      IF SchemaMessage = "" THEN DO:
        FOR EACH tt_db WHERE NOT CAN-DO(cDbNumList,STRING(tt_db.iDbNum)): tt_db.cConnection = icConnectionFile. END.
        IF VALID-HANDLE(ihDsSchema) THEN
          ihDsSchema:COPY-DATASET (hdsSchema,NO,YES,YES). // full replace of schema in caller - except when the call is just to check connect..
      END.  
      ELSE MESSAGE SchemaMessage VIEW-AS ALERT-BOX.
      RETURN SchemaMessage = "".
    END FINALLY.              
  END METHOD.  

  // Connect via appserver (connection defined on startup) 
  METHOD PUBLIC LOGICAL getSqlDbSchema(INPUT ihDsSchema   AS HANDLE
                                      ,INPUT icSourceName AS CHAR
                                      ,INPUT icDbName     AS CHAR
                                      ,INPUT icDbType     AS CHAR 
                                      ,INPUT ihServer     AS HANDLE):
  
    DEF VAR cDataSource AS CHAR NO-UNDO.
    DEF VAR cDbNumList  AS CHAR NO-UNDO.
    SchemaMessage = "".
    
    FOR EACH tt_db: cDbNumList = cDbNumList + (IF cDbNumList NE "" THEN "," ELSE "") + STRING(tt_db.iDbNum). END.
    
    IF bCallAppserver THEN DO:
      // Establishes the connection record (if it doesn't exist already)
      IF JBoxServerApi:Instance:CallServerProc("jbserv_get_datasource_type.p",icSourceName + "." + icDbName) THEN DO:
        IF ENTRY(1,JBoxServerApi:Instance:getCallReturnParam(),"|") = icDbType THEN   
          THIS-OBJECT:getSqlDbSchema(?,icDbName,icSourceName,icDbType).
        ELSE SchemaMessage = "Mismatch in data source type: " + icDbType + " / " + JBoxServerAPI:Instance:getCallReturnParam().    
      END.
      ELSE SchemaMessage = JBoxServerApi:Instance:getCallMessage().
    END.
    ELSE DO:
      IF JBoxServerSide:Instance:CallServerProc("jbserv_get_datasource_type.p",icSourceName + "." + icDbName) THEN   
        THIS-OBJECT:getSqlDbSchema(?, icDbName, icSourceName, ENTRY(1,JBoxServerSide:Instance:getCallReturnParam(),"|")).
      ELSE SchemaMessage = JBoxServerSide:Instance:getCallMessage().
    END.  
    
    FINALLY:
      IF SchemaMessage = "" THEN DO:
        FOR EACH tt_db WHERE NOT CAN-DO(cDbNumList,STRING(tt_db.iDbNum)): tt_db.hServer = ihServer. END.
        IF VALID-HANDLE(ihDsSchema) THEN
          ihDsSchema:COPY-DATASET (hdsSchema,NO,YES,YES). // full replace of schema in caller
      END.  
      ELSE MESSAGE SchemaMessage VIEW-AS ALERT-BOX.
      RETURN SchemaMessage = "".
    END FINALLY.              
  END METHOD.  

  /*------------------------------------------------------------------------------
   Purpose: Fetch SQL schema
   Notes:   Connection must exist (maybe on appserver)
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC LOGICAL getSqlDbSchema(INPUT ihDsSchema  AS HANDLE
                                      ,INPUT icDbSqlName AS CHAR
                                      ,INPUT icDbSqlSourceName AS CHAR
                                      ,INPUT icDbSqlType AS CHAR ):
    DEF VAR hSqlSchema AS HANDLE NO-UNDO.
    DEF VAR ixFileNum  AS INT NO-UNDO.
    DEF VAR ixIdxNum   AS INT NO-UNDO.
    DEF VAR ixFieldNum AS INT NO-UNDO.
    DEF VAR ixDbNum    AS INT NO-UNDO.
    DEF VAR ix         AS INT NO-UNDO.
    DEF BUFFER bttIndexField FOR tt_index-field.
    DEF VAR iFakeIdxSeq AS INT NO-UNDO.
    
    FIND FIRST tt_db 
         WHERE tt_db.cLDBname    = icDbSqlName
           AND tt_db.cDbType     = icDbSqlType
           AND tt_db.cSourceName = icDbSqlSourceName
         NO-ERROR.
    IF NOT AVAIL tt_db THEN DO:
      FOR EACH tt_db BY tt_db.iDbNum: ixDbNum = tt_db.iDbNum. END.
      CREATE tt_db.
      ASSIGN tt_db.cLDBname    = icDbSqlName
             tt_db.cDbType     = icDbSqlType
             tt_db.cSourceName = icDbSqlSourceName
             tt_db.cSourceType = icDbSqlType // always the same as dbtype for sql
             ixDbNum           = ixDbNum + 1
             tt_db.iDbNum      = ixDbNum
             . 
      
      hDsSqlSchema:EMPTY-DATASET ().
      
      hSqlSchema = JBoxSqlSchemaHelper:Instance:getSqlSchema(icDbSqlName,icDbSqlSourceName,icDbSqlType).
      IF JBoxSqlSchemaHelper:Instance:sqlSchemaMessage NE "" THEN DO:
        SchemaMessage = JBoxSqlSchemaHelper:Instance:sqlSchemaMessage.
        DELETE tt_db.
        RETURN NO.
      END.  
      IF VALID-HANDLE(hSqlSchema) THEN
        hDsSqlSchema:COPY-DATASET (hSqlSchema).
      
//      hDsSqlSchema:WRITE-JSON ("file","c:\temp\" + icDbSqlName + ".json",yes).
      
      FOR EACH tt_file BY tt_file.iFileNum DESC:
        ixFileNum = tt_file.iFileNum.
        LEAVE.
      END.
      
      FOR EACH ttSqlSchema
          WHERE ttSqlSchema.OETableName NE ""
          BREAK BY ttSqlSchema.OETableName
          :
        IF FIRST-OF(ttSqlSchema.OETableName) THEN DO:
          CREATE tt_file.
          ASSIGN tt_file.cFile-Name     = ttSqlSchema.OETableName
                 tt_file.cLDBname       = icDbSqlName
                 tt_file.cTbl-Type      = "T"
                 tt_file.cType          = IF CAN-DO("T,BASE TABLE",ttSqlSchema.Table_Type) THEN "TABLE" ELSE "VIEW"
                 ixFileNum              = ixFileNum + 1
                 tt_file.iFileNum       = ixFileNum
                 tt_file.iDbNum         = ixDbNum
                 tt_file.cSqlTableName  = ttSqlSchema.Table_Name
                 ix                 = ix + 1
                 .
          FOR EACH ttSqlIndex
              WHERE ttSqlIndex.Table_Name = ttSqlSchema.Table_name
              BREAK BY ttSqlIndex.Index_name
              :
            IF FIRST-OF(ttSqlIndex.Index_name) THEN DO:    
              CREATE tt_index.
              ASSIGN tt_index.iFileNum = tt_file.iFileNum
                     ixIdxNum             = ixIdxNum + 1
                     tt_index.iIdxNum     = ixIdxNum
                     tt_index.cIndex-name = ttSqlIndex.Index_name
                     tt_index.bUnique     = CAN-DO("U,true",ttSqlIndex.Unique_Index)
                     tt_index.bActive     = YES
                     .    
            END.
            FIND FIRST tt_index-field
                 WHERE tt_index-field.iFileNum = tt_file.iFileNum
                   AND tt_index-field.iIdxNum  = tt_index.iIdxNum
                   AND tt_index-field.iIdxSeq  = ttSqlIndex.Index_seq
                 NO-ERROR.
            IF AVAIL tt_index-field THEN 
              FOR EACH bttIndexField
                  WHERE bttIndexField.iFieldNum = tt_file.iFileNum
                    AND bttIndexField.iIdxNum   = tt_index.iIdxNum
                  BY bttIndexField.iIdxSeq DESC:
                bttIndexField.iIdxSeq = bttIndexField.iIdxSeq + 1.
              END.        
            FIND FIRST tt_index-field
                 WHERE tt_index-field.iFileNum = tt_file.iFileNum
                   AND tt_index-field.iIdxNum  = tt_index.iIdxNum
                   AND tt_index-field.iIdxSeq  = ttSqlIndex.Index_seq
                 NO-ERROR.
            IF NOT AVAIL tt_index-field THEN DO:          
              CREATE tt_index-field.
              ASSIGN tt_index-field.cFieldName = ttSqlIndex.Column_name
                     tt_index-field.iFileNum   = tt_file.iFileNum
                     tt_index-field.iIdxNum    = tt_index.iIdxNum
                     tt_index-field.iIdxSeq    = ttSqlIndex.Index_seq
                     .
            END.         
          END.      
        END.  
        
        IF NOT CAN-FIND(FIRST tt_field
                        WHERE tt_field.iFileNum = tt_file.iFileNum
                          AND tt_field.cField-Name = ttSqlSchema.OEFieldName) THEN DO:
          CREATE tt_field.
          ASSIGN tt_field.iFileNum      = tt_file.iFileNum
                 ixFieldNum             = ixFieldNum + 1
                 tt_field.iFieldNum     = ixFieldNum
                 tt_field.cField-Name   = ttSqlSchema.OEFieldName
                 tt_field.cData-Type    = ttSqlSchema.OEdataType
                 tt_field.cFormat       = ttSqlSchema.OEformat
                 tt_field.cLabel        = ttSqlSchema.OElabel
                 tt_field.iOrder        = ttSqlSchema.Ordinal_Position
                 tt_field.iDbNum        = ixDbNum
                 tt_field.cSqlFieldName = ttSqlSchema.Column_Name
                 tt_field.cSqlDataType  = ttSqlSchema.Data_Type
                 .
        END.         
      END.
      
      tt_db.iUsrTableCnt = ix.  
      
    END.       

    IF ihDsSchema NE ? THEN
      ihDsSchema:COPY-DATASET (hdsSchema,NO,YES,YES). // full replace of schema in caller
        
    RETURN YES.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.    

  END METHOD.    

  METHOD PUBLIC CHARACTER getSqlDbType( INPUT icSourceName AS CHAR):
    
    FIND FIRST tt_db
         WHERE tt_db.cSourceName = icSourceName
         NO-ERROR.
         
    IF AVAIL tt_db THEN RETURN tt_db.cDbType. ELSE RETURN "".
    
  END METHOD.

  METHOD PUBLIC LOGICAL getSqlUsesRowid( INPUT icSourceName AS CHAR):
    
    FIND FIRST tt_db
         WHERE tt_db.cSourceName = icSourceName
         NO-ERROR.
         
    IF AVAIL tt_db THEN RETURN CAN-DO("ProgressSql,sqlexp",tt_db.cDbType).
    ELSE RETURN NO.
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC HANDLE CreateTt(INPUT icDataSource AS CHAR
                               ,INPUT icDbName     AS CHAR
                               ,INPUT icTableName  AS CHAR ):
   
    DEF VAR hTempTable AS HANDLE NO-UNDO.
    DEF BUFFER tt_db FOR tt_db.
    DEF BUFFER tt_file FOR tt_file.
   
    FOR EACH tt_db
        WHERE tt_db.cSourceName = icDataSource
          AND tt_db.cLDBname    = icDbName
       ,FIRST tt_file
              WHERE tt_file.iDbNum = tt_db.iDbNum
                AND tt_file.cFile-Name = RealTable(icTableName)
        :           
      CREATE TEMP-TABLE hTempTable.
      FOR EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
          :
        hTempTable:ADD-NEW-FIELD(tt_field.cField-Name,tt_field.cData-Type).
      END.
      FOR EACH tt_index
          WHERE tt_index.iFileNum = tt_file.iFileNum
            AND LENGTH(tt_index.cIndex-name) < 33
          :  
        IF NOT CAN-FIND(FIRST tt_index-field
                        WHERE tt_index-field.iFileNum = tt_file.iFileNum
                          AND tt_index-field.iIdxNum  = tt_index.iIdxNum
                          AND LENGTH(tt_index-field.cFieldName) < 33) THEN NEXT.    
        hTempTable:ADD-NEW-INDEX(tt_index.cIndex-name).
        FOR EACH tt_index-field
            WHERE tt_index-field.iFileNum = tt_file.iFileNum
              AND tt_index-field.iIdxNum  = tt_index.iIdxNum
              AND LENGTH(tt_index-field.cFieldName) < 33
            BY tt_index-field.iIdxSeq:
          hTempTable:ADD-INDEX-FIELD(tt_index.cIndex-name,tt_index-field.cFieldName).
        END.
      END.
      hTempTable:TEMP-TABLE-PREPARE (LEFT-TRIM(icTableName,"(")).          
    END.
    
    RETURN hTempTable.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL mergeToDsSchema( INPUT ihDs AS HANDLE ):
    
    DEF VAR bOk         AS LOGICAL NO-UNDO.
    DEF VAR ix          AS INT NO-UNDO.
    DEF VAR ixDbNum     AS INT NO-UNDO.
    DEF VAR ixFileNum   AS INT NO-UNDO.
    DEF VAR hQuery      AS HANDLE NO-UNDO.
    DEF VAR hbField     AS HANDLE NO-UNDO.
    DEF VAR hQryField   AS HANDLE NO-UNDO.
    DEF VAR hbIndex     AS HANDLE NO-UNDO.
    DEF VAR hQryIndex   AS HANDLE NO-UNDO.
    DEF VAR hbIdxFld    AS HANDLE NO-UNDO.
    DEF VAR hQryIdxFld  AS HANDLE NO-UNDO.
    DEF VAR bReplace    AS LOG  NO-UNDO.
    
    DO ix = 1 TO ihDs:NUM-BUFFERS:
      
      IF NOT CAN-DO("tt_db,tt_file,tt_sequence",ihDs:GET-BUFFER-HANDLE (ix):NAME) THEN NEXT.
      
      CREATE QUERY hQuery.
      hQuery:SET-BUFFERS(ihDs:GET-BUFFER-HANDLE (ix)).
      hQuery:QUERY-PREPARE ("FOR EACH " + ihDs:GET-BUFFER-HANDLE (ix):NAME).
      hQuery:QUERY-OPEN().
      hQuery:GET-FIRST().
      IF NOT hQuery:GET-BUFFER-HANDLE(1):AVAIL THEN NEXT.
      
      IF ihDs:GET-BUFFER-HANDLE (ix):NAME = "tt_db" THEN DO:
        FIND FIRST tt_db 
             WHERE tt_db.cLDBname    = ihDs:GET-BUFFER-HANDLE (ix):BUFFER-FIELD("cLDBname"):BUFFER-VALUE
               AND tt_db.cDbType     = ihDs:GET-BUFFER-HANDLE (ix):BUFFER-FIELD("cDbType"):BUFFER-VALUE
               AND tt_db.cSourceName = ihDs:GET-BUFFER-HANDLE (ix):BUFFER-FIELD("cSourceName"):BUFFER-VALUE
             NO-ERROR.
        IF NOT AVAIL tt_db THEN DO:
          FOR EACH tt_db BY tt_db.iDbNum: ixDbNum = tt_db.iDbNum. END.
          CREATE tt_db.
          ASSIGN tt_db.cLDBname    = ihDs:GET-BUFFER-HANDLE (ix):BUFFER-FIELD("cLDBname"):BUFFER-VALUE
                 tt_db.cDbType     = ihDs:GET-BUFFER-HANDLE (ix):BUFFER-FIELD("cDbType"):BUFFER-VALUE
                 tt_db.cSourceName = ihDs:GET-BUFFER-HANDLE (ix):BUFFER-FIELD("cSourceName"):BUFFER-VALUE
                 tt_db.cSourceType = ihDs:GET-BUFFER-HANDLE (ix):BUFFER-FIELD("cSourceType"):BUFFER-VALUE
                 ixDbNum           = ixDbNum + 1
                 tt_db.iDbNum      = ixDbNum
                 . 
        END.
        ELSE bReplace = YES.
      END.
      ELSE IF ihDs:GET-BUFFER-HANDLE (ix):NAME = "tt_file" THEN DO:
        IF bReplace THEN DO:
          FOR EACH tt_file 
              WHERE tt_file.iDbNum = tt_db.iDbNum
              :
            FOR EACH tt_field
                WHERE tt_field.iFileNum = tt_file.iFileNum
                :
              DELETE tt_field.
            END.
            FOR EACH tt_index WHERE tt_index.iFileNum = tt_file.iFileNum
                :
              FOR EACH tt_index-field
                  WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
                  :
                DELETE tt_index-field.
              END.
              DELETE tt_index.
            END.
            DELETE tt_file.
          END.
          FOR EACH tt_sequence
              WHERE tt_sequence.iDbNum = tt_db.iDbNum
              :
            DELETE tt_sequence.
          END.
          bReplace = NO.
        END.
          
        hbField = ihDs:GET-BUFFER-HANDLE ("tt_field") NO-ERROR.
        IF VALID-HANDLE(hbField) THEN DO:
          CREATE QUERY hQryField.
          hQryField:SET-BUFFERS (hbField).
        END.           
        hbIndex = ihDs:GET-BUFFER-HANDLE ("tt_index") NO-ERROR.
        IF VALID-HANDLE(hbIndex) THEN DO:
          CREATE QUERY hQryIndex.
          hQryIndex:SET-BUFFERS (hbIndex).
        END.           
        hbIdxFld = ihDs:GET-BUFFER-HANDLE ("tt_index-field") NO-ERROR.
        IF VALID-HANDLE(hbIdxFld) THEN DO:
          CREATE QUERY hQryIdxFld.
          hQryIdxFld:SET-BUFFERS (hbIdxFld).
        END.
                   
        FOR EACH tt_file BY tt_file.iFileNum DESC:
          ixFileNum = tt_file.iFileNum.
          LEAVE.
        END.
        REPEAT WHILE hQuery:GET-BUFFER-HANDLE(1):AVAIL: // tt_file
          
          ixFileNum = ixFileNum + 1.
          
          hQryField:QUERY-PREPARE ("FOR EACH tt_field WHERE tt_field.iFileNum = " + hQuery:GET-BUFFER-HANDLE(1):BUFFER-FIELD("iFileNum"):STRING-VALUE).
          hQryField:QUERY-OPEN ().
          REPEAT WHILE hQryField:GET-NEXT ():
            CREATE tt_field.
            BUFFER tt_field:BUFFER-COPY(hbField,"iDbNum,iFileNum,JBoxRowident,JBoxParentRowIdent,JBoxRowid1").
            ASSIGN tt_field.iDbNum   = tt_db.iDbNum
                   tt_field.iFileNum = ixFileNum
                   .
          END.  

          hQryIndex:QUERY-PREPARE ("FOR EACH tt_index WHERE tt_index.iFileNum = " + hQuery:GET-BUFFER-HANDLE(1):BUFFER-FIELD("iFileNum"):STRING-VALUE).
          hQryIndex:QUERY-OPEN ().
          REPEAT WHILE hQryIndex:GET-NEXT ():
            CREATE tt_index.
            BUFFER tt_index:BUFFER-COPY(hbIndex,"iFileNum").
            ASSIGN tt_index.iFileNum = ixFileNum
                   .
          END.  

          hQryIdxFld:QUERY-PREPARE ("FOR EACH tt_index-field WHERE tt_index-field.iFileNum = " + hQuery:GET-BUFFER-HANDLE(1):BUFFER-FIELD("iFileNum"):STRING-VALUE).
          hQryIdxFld:QUERY-OPEN ().
          REPEAT WHILE hQryIdxFld:GET-NEXT ():
            CREATE tt_index-field.
            BUFFER tt_index-field:BUFFER-COPY(hbIdxFld,"iFileNum").
            ASSIGN tt_index-field.iFileNum = ixFileNum
                   .
          END.  

          CREATE tt_file.
          BUFFER tt_file:BUFFER-COPY (hQuery:GET-BUFFER-HANDLE(1),"iDbNum,iFileNum").
          ASSIGN tt_file.iDbNum   = tt_db.iDbNum
                 tt_file.iFileNum = ixFileNum
                 .
          hQuery:GET-NEXT ().       
        END.
      END.   
      ELSE IF ihDs:GET-BUFFER-HANDLE (ix):NAME = "tt_sequence" THEN DO:
        FOR EACH tt_sequence
            WHERE tt_sequence.iDbNum = tt_db.iDbNum
            :
          DELETE tt_sequence.
        END.
        REPEAT WHILE hQuery:GET-BUFFER-HANDLE (1):AVAIL:
          CREATE tt_sequence.
          BUFFER tt_sequence:BUFFER-COPY (hQuery:GET-BUFFER-HANDLE(1),"iDbNum").
          ASSIGN tt_sequence.iDbNum   = tt_db.iDbNum
                 .
          hQuery:GET-NEXT().
        END.  
      END.        

      DELETE OBJECT hQuery.
    END.            
      
    CATCH eErr AS Progress.Lang.Error :
      SchemaMessage = PROGRAM-NAME(1) + " " + eErr:GetMessage(1).  
    END CATCH.  

    FINALLY:
      DELETE OBJECT hQuery NO-ERROR.
      DELETE OBJECT hQryField NO-ERROR.
      DELETE OBJECT hQryIndex NO-ERROR.
      DELETE OBJECT hQryIdxFld NO-ERROR.
      RETURN SchemaMessage = "".
    END.  

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Add temp-table to temp-table schema
   Notes:   
  ------------------------------------------------------------------------------*/
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID saveDatafjordSchema(  ):
    DEF VAR hdsDatafjord AS HANDLE NO-UNDO.
    
    FILE-INFO:FILE-NAME = "data\/datafjord".
    IF FILE-INFO:FULL-PATHNAME = ? THEN RETURN.
    
    CREATE DATASET hdsDatafjord.
    hdsDatafjord:CREATE-LIKE (hdsSchema).
    FOR EACH tt_db
        WHERE tt_db.cSourceName = "Datafjord"
        :
      hdsDatafjord:GET-BUFFER-HANDLE (1):BUFFER-CREATE ().
      hdsDatafjord:GET-BUFFER-HANDLE (1):BUFFER-COPY (BUFFER tt_db:HANDLE).
      FOR EACH tt_file
          WHERE tt_file.iDbNum = tt_db.iDbNum
          :
        hdsDatafjord:GET-BUFFER-HANDLE (2):BUFFER-CREATE().
        hdsDatafjord:GET-BUFFER-HANDLE (2):BUFFER-COPY(BUFFER tt_file:HANDLE).
        FOR EACH tt_field
            WHERE tt_field.iFileNum = tt_file.iFileNum
            :
          hdsDatafjord:GET-BUFFER-HANDLE (3):BUFFER-CREATE().
          hdsDatafjord:GET-BUFFER-HANDLE (3):BUFFER-COPY(BUFFER tt_field:HANDLE).
        END.
        FOR EACH tt_index
            WHERE tt_index.iFileNum = tt_file.iFileNum
            :  
          hdsDatafjord:GET-BUFFER-HANDLE (4):BUFFER-CREATE().
          hdsDatafjord:GET-BUFFER-HANDLE (4):BUFFER-COPY(BUFFER tt_index:HANDLE).
          FOR EACH tt_index-field
              WHERE tt_index-field.iIdxNum = tt_index.iIdxNum
              :
            hdsDatafjord:GET-BUFFER-HANDLE (5):BUFFER-CREATE().
            hdsDatafjord:GET-BUFFER-HANDLE (5):BUFFER-COPY(BUFFER tt_index-field:HANDLE).
          END.  
        END.
      END.  
    END.
                     
    hdsDatafjord:WRITE-JSON("file",FILE-INFO:FULL-PATHNAME + "/datafjord.json",YES).
    
    DELETE OBJECT hdsDatafjord.
    
    RETURN.

  END METHOD.

  METHOD PUBLIC HANDLE addTempTableToSchema(INPUT ihDsSchema      AS HANDLE
                                           ,INPUT ihTtOrBuffer    AS HANDLE
                                           ,INPUT icDataSource    AS CHAR
                                           ,INPUT icDbName        AS CHAR
                                           ,INPUT ibKeepInCache   AS LOG
                                           ,INPUT icIndexedFields AS CHAR).
                                      
    DEF VAR ixFileNum  AS INT NO-UNDO.
    DEF VAR ixIdxNum   AS INT NO-UNDO.
    DEF VAR ixFieldNum AS INT NO-UNDO.
    DEF VAR ixDbNum    AS INT NO-UNDO.
    DEF VAR ix         AS INT NO-UNDO.
    DEF VAR hBuffer    AS HANDLE NO-UNDO.
    
    IF NOT CAN-FIND(FIRST tt_db) THEN getDbSchema(?).
    
    IF icDbName = "" THEN icDbName = "root".
    
    IF ihTtOrBuffer:TYPE = "TEMP-TABLE" THEN
      hBuffer = ihTtOrBuffer:DEFAULT-BUFFER-HANDLE.
    ELSE    
      ASSIGN hBuffer = ihTtOrBuffer
             ihTtOrBuffer = ihTtOrBuffer:TABLE-HANDLE.
    
    FIND FIRST tt_db 
         WHERE tt_db.cLDBname    = icDbName
           AND tt_db.cSourceName = icDataSource
         NO-ERROR.
    IF NOT AVAIL tt_db THEN DO:
      FOR EACH tt_db BY tt_db.iDbNum: ixDbNum = tt_db.iDbNum. END.
      CREATE tt_db.
      ASSIGN tt_db.cLDBname    = icDbName
             tt_db.cDbType     = "TT"
             tt_db.cSourceName = icDataSource
             tt_db.cSourceType = "TT"
//             tt_db.cConnection = "data/datafjord/" + (IF icSubCatalog NE "" THEN TRIM(icSubCatalog,"\/") + "/" ELSE "") + ihTtBuffer:NAME + ".json"
             ixDbNum           = ixDbNum + 1
             tt_db.iDbNum      = ixDbNum
             . 
    END.         
    FOR EACH tt_file
        WHERE tt_file.iDbNum = tt_db.iDbNum
          AND tt_file.cFile-Name = ihTtOrBuffer:NAME
        :
      FOR EACH tt_field
          WHERE tt_field.iFileNum = tt_file.iFileNum
          :      
        DELETE tt_field.
      END.
      FOR EACH tt_index
          WHERE tt_index.iFileNum = tt_file.iFileNum
          :
        FOR EACH tt_index-field
            WHERE tt_index-field.iFileNum = tt_file.iFileNum
              AND tt_index-field.iIdxNum = tt_index.iIdxNum
            :
          DELETE tt_index-field.
        END.
        DELETE tt_index.
      END.
      DELETE tt_file.
      tt_db.iUsrTableCnt = tt_db.iUsrTableCnt - 1.  
    END.           

    RUN deleteFile IN hGlobSchemaHolder (tt_db.iDbNum,ihTtOrBuffer:NAME).  
      
    FOR EACH tt_file BY tt_file.iFileNum DESC:
      ixFileNum = tt_file.iFileNum.
      LEAVE.
    END.

    CREATE tt_file.
    ASSIGN tt_file.cFile-Name     = ihTtOrBuffer:NAME
           tt_file.cLDBname       = icDbName
           tt_file.cTbl-Type      = "T"
           tt_file.cType          = "TABLE"
           ixFileNum              = ixFileNum + 1
           tt_file.iFileNum       = ixFileNum
           tt_file.iDbNum         = tt_db.iDbNum
           .

    DO ix = 1 TO hBuffer:NUM-FIELDS:      

      CREATE tt_field.
      ASSIGN tt_field.iFileNum      = tt_file.iFileNum
             tt_field.iFieldNum     = ix
             tt_field.cField-Name   = hBuffer:BUFFER-FIELD(ix):NAME
             tt_field.cData-Type    = hBuffer:BUFFER-FIELD(ix):DATA-TYPE
             tt_field.cFormat       = hBuffer:BUFFER-FIELD(ix):FORMAT
             tt_field.cLabel        = hBuffer:BUFFER-FIELD(ix):LABEL
             tt_field.iOrder        = ix
             tt_field.iDbNum        = tt_db.iDbNum
             .
      IF CAN-DO(icIndexedFields,tt_field.cField-Name) THEN DO:
        CREATE tt_index.
        ASSIGN tt_index.iFileNum = tt_file.iFileNum
               tt_index.iIdxNum = ix
               tt_index.bActive = YES
               tt_index.cIndex-name = "idx" + ENTRY(LOOKUP(tt_field.cField-Name,icIndexedFields),icIndexedFields)
               .
        CREATE tt_index-field.
        ASSIGN tt_index-field.cFieldName = tt_field.cField-Name
               tt_index-field.iFieldNum  = ix
               tt_index-field.iFileNum   = tt_file.iFileNum
               tt_index-field.iIdxNum    = LOOKUP(tt_field.cField-Name,icIndexedFields)
               tt_index-field.iIdxSeq    = 1
               .       
      END.         
    END.
        
    tt_db.iUsrTableCnt = tt_db.iUsrTableCnt + 1.  
                    
    RUN refreshGlobal IN hGlobSchemaHolder (hdsSchema).  
    
    IF ibKeepInCache THEN 
      RUN createTempTable IN hGlobSchemaHolder (tt_file.iFileNum,ihTtOrBuffer,
                                                "localRowid;CHARACTER,Rowident1;CHARACTER,RowCount;INTEGER,jbCountDistinct;INTEGER;>>><>>><>>9,jbAverage;DECIMAL;->>><>>><>>9.99",
                                                OUTPUT tt_file.hTempTable).

    IF ihDsSchema NE ? THEN 
      ihDsSchema:COPY-DATASET (hdsSchema,NO,YES,YES). // full replace of schema in caller
        
    RETURN tt_file.hTempTable.

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.    

  END METHOD.    

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER RealTable ( INPUT icTableName AS CHAR ):
  
  icTableName = LEFT-TRIM(icTableName,"(").
  
  RETURN IF LENGTH(icTableName) > 5 AND icTableName MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(icTableName,4,2)) THEN 
           SUBSTR(icTableName,INDEX(icTableName,"_") + 1)
         ELSE icTableName.
  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL readDataFjordSchema( INPUT icDataFjordSchemaFile AS CHAR ):
    
    DEF VAR lcJson AS LONGCHAR NO-UNDO.
    DEF VAR oParser AS JBoxJsonParser NO-UNDO.
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR hbTt AS HANDLE NO-UNDO.
    DEF VAR hdsDataFjord AS HANDLE NO-UNDO.
   
    oParser = NEW JBoxJsonParser().
    
    FIX-CODEPAGE(lcJson) = "utf-8".
    
    COPY-LOB FROM file icDataFjordSchemaFile TO lcJson.
    
    oParser:createSchemaAndLoadData(lcJson).
        
    CREATE DATASET hdsDataFjord.
    hdsDataFjord:CREATE-LIKE(hdsSchema).
    
    DO ix = 1 TO hdsDataFjord:NUM-BUFFERS:
      hbTt = oParser:getResultBufferHandle(hdsDataFjord:GET-BUFFER-HANDLE (ix):NAME).
      IF VALID-HANDLE(hbTt) THEN 
        oParser:deepCopyTT(hbtt,hdsDataFjord:GET-BUFFER-HANDLE (ix)).
    END.
    
    mergeToDsSchema (hdsDataFjord).
    
    DELETE OBJECT hdsDataFjord.

    CATCH eErr AS Progress.Lang.Error :
      SchemaMessage = PROGRAM-NAME(1) + ": " + eErr:GetMessage(1).  
    END CATCH.
    
    FINALLY:
      RETURN SchemaMessage = "".
    END FINALLY.

  END METHOD.

METHOD PUBLIC LOGICAL reloadSchema( INPUT icDataSource AS CHAR,
                                    INPUT ihDsSchema   AS HANDLE ):
    
    DEF VAR cConnection AS CHAR NO-UNDO.
    FIND FIRST tt_db
         WHERE tt_db.cSourceName = icDataSource
         NO-ERROR.
    IF NOT AVAIL tt_db THEN DO:      
      SchemaMessage = "Datasource not loaded".
      RETURN NO.
    END.  
    IF tt_db.cConnection = "" THEN DO:      
      SchemaMessage = "Datasource missing connect params".
      RETURN NO.
    END.  
    cConnection = tt_db.cConnection.
    IF clearSchema(icDataSource) THEN 
      RETURN getDbSchema(ihDsSchema,cConnection).
    ELSE RETURN NO.  

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setUseDefaultConnection(  ):
  
   IF VALID-HANDLE(hOrgAsHandle) THEN DO:
     DYNAMIC-FUNCTION("setAppserviceHandle",hOrgAsHandle).
     DYNAMIC-FUNCTION("setSessionId",cOrgSessionId).
   END.   
    
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER CheckQuerySyntax (INPUT icDataSource AS CHAR 
                                           ,INPUT icDbTblList  AS CHAR
                                           ,INPUT icExpr       AS CHAR):
    
    DEF VAR cError      AS CHAR NO-UNDO.
    DEF VAR cEntry      AS CHAR NO-UNDO.
    DEF VAR cTable      AS CHAR NO-UNDO.
    
    DEF VAR ix          AS INT NO-UNDO.
    DEF VAR hQuery      AS HANDLE NO-UNDO.
    DEF VAR hTtArr      AS HANDLE EXTENT 20.
    DEF VAR hTempT      AS HANDLE NO-UNDO.
    DEF VAR ixTT        AS INT NO-UNDO.
    DEF VAR cModExp     AS CHAR NO-UNDO.
    DEF VAR iIntCheck   AS INT NO-UNDO.
    
    REPEAT WHILE INDEX(icExpr,"  ") > 0:
      icExpr = REPLACE(icExpr,"  "," ").
    END.
  
    CREATE QUERY hQuery.
  
    DO ON ERROR UNDO, THROW:  
    
      icExpr = REPLACE(icExpr,CHR(10),"").

      DO ix = 1 TO NUM-ENTRIES(icExpr," "):
        cEntry = ENTRY(ix,icExpr," ").
        IF NUM-ENTRIES(cEntry,".") = 3
           AND (ENTRY(1,cEntry,"(") BEGINS "STRING" OR
                ENTRY(1,cEntry,"(") BEGINS "INT" OR
                ENTRY(1,cEntry,"(") BEGINS "DATE" OR
                ENTRY(1,cEntry,"(") BEGINS "LOG" OR
                ENTRY(1,cEntry,"(") BEGINS "DEC" 
                ) THEN DO:
          IF ENTRY(1,cEntry,"(") BEGINS "DATE" THEN DO:
            iIntCheck = INTEGER(ENTRY(2,cEntry,".")) NO-ERROR.
            IF ERROR-STATUS:ERROR THEN // it's a field name
              cModExp = cModExp + (IF cModExp NE "" THEN " " ELSE "")
                      + ENTRY(1,cEntry,"(") + "(" + SUBSTR(cEntry,INDEX(cEntry,".") + 1).
            ELSE // it's a date(time) constant          
              cModExp = cModExp + (IF cModExp NE "" THEN " " ELSE "") + cEntry.
          END.          
          ELSE
            cModExp = cModExp + (IF cModExp NE "" THEN " " ELSE "")
                    + ENTRY(1,cEntry,"(") + "(" + SUBSTR(cEntry,INDEX(cEntry,".") + 1).
        END.
        ELSE IF NUM-ENTRIES(cEntry,".") = 3 AND cEntry BEGINS "(" THEN 
          cModExp = cModExp + (IF cModExp NE "" THEN " " ELSE "") + "(" + SUBSTR(cEntry,INDEX(cEntry,".") + 1).
        ELSE IF NUM-ENTRIES(cEntry,".") = 3 THEN 
          cModExp = cModExp + (IF cModExp NE "" THEN " " ELSE "") + SUBSTR(cEntry,INDEX(cEntry,".") + 1).
        ELSE                  
          cModExp = cModExp + (IF cModExp NE "" THEN " " ELSE "") + cEntry.
      END.
      icExpr = cModExp.

      DO ix = 1 TO NUM-ENTRIES(icDbTblList):
        cEntry = ENTRY(ix,icDbTblList).
        hTempT = CreateTt(icDataSource,ENTRY(1,cEntry,"."),ENTRY(2,cEntry,".")).
        IF VALID-HANDLE(hTempT) THEN DO:
          ixTt = ixTT + 1.
          hTtArr[ixTT] = hTempT. 
          hQuery:ADD-BUFFER (hTempT:DEFAULT-BUFFER-HANDLE).
        END.
      END.  
      
      hQuery:QUERY-PREPARE (icExpr).
    END.

    CATCH eErr AS Progress.Lang.Error :
      IF eErr:GetMessageNum(1) = 1700 THEN cError = "". /* Some identifier too long for tt generation */
      ELSE
        cError = eErr:GetMessage(1) + CHR(10) + CHR(10) + "Expression: " + CHR(10) + icExpr.  
    END CATCH.
           
    FINALLY:   
      DELETE OBJECT hQuery.
      DO ix = 1 TO 20:
        IF VALID-HANDLE(hTtArr[ix]) THEN DELETE OBJECT hTtArr[ix].
      END.  
      RETURN cError.
    END FINALLY.  

  END METHOD.
        
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL getIsFieldIndexed(INPUT icField      AS CHAR
                                         ,INPUT icTable      AS CHAR
                                         ,INPUT icDbName     AS CHAR
                                         ,INPUT icDataSource AS CHAR):
                                           
    FOR EACH tt_db
        WHERE tt_db.cSourceName = icDataSource
          AND tt_db.cLDBname    = icDbName
       ,EACH tt_file
             WHERE tt_file.iDbNum = tt_db.iDbNum
               AND tt_file.cFile-Name = icTable
       ,EACH tt_field
             WHERE tt_field.iFileNum = tt_file.iFileNum
               AND tt_field.cField-Name = icField
       ,EACH tt_index
              WHERE tt_index.iFileNum = tt_file.iFileNum
                AND tt_index.bActive
       ,EACH tt_index-field
             WHERE tt_index-field.iFileNum = tt_file.iFileNum 
               AND tt_index-field.iIdxNum  = tt_index.iIdxNum       
       BREAK BY tt_index.iIdxNum
             BY tt_index-field.iIdxSeq         
       :                    
      IF FIRST-OF(tt_index.iIdxNum) AND tt_index-field.cFieldName = icField THEN RETURN YES.
    END.
    
    RETURN NO.
                                           
  END METHOD.                                          

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID viewSchema(  ):
    
    hdsSchema:WRITE-JSON("file",SESSION:TEMP-DIR + "\schemacache.json",YES).
    
    DO ON ERROR UNDO, THROW:  
      System.Diagnostics.Process:Start("notepad.exe",SESSION:TEMP-DIR + "\schemacache.json").
      CATCH eOS AS Progress.Lang.Error :
         MESSAGE eOS:GetMessage(1) VIEW-AS ALERT-BOX.
      END CATCH.
    END.
    
  END METHOD.
        
  DESTRUCTOR PUBLIC JBoxSchemaCache():

    
  END DESTRUCTOR.  
END CLASS.