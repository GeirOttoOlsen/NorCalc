
/*------------------------------------------------------------------------
    File        : jbox_run_viewds_script.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Tue Jul 25 15:22:45 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */
{incl/tt_viewds.i}
hdsViewDs = DATASET dsViewDs:HANDLE.

{tt_schema.i}
hdsSchema = DATASET dsSchema:HANDLE.

/* ***************************  Main Block  *************************** */

DEF VAR cViewDsFile       AS CHAR NO-UNDO.
DEF VAR cViewDsId         AS CHAR NO-UNDO.
DEF VAR cConnectionFile   AS CHAR NO-UNDO.
DEF VAR cRunQueryId       AS CHAR NO-UNDO.
DEF VAR cQueryLogFile     AS CHAR NO-UNDO.
DEF VAR cAsConnectString  AS CHAR NO-UNDO. // May be inherited from gui startup
DEF VAR hServer           AS HANDLE NO-UNDO.
DEF VAR cExportFileName   AS CHAR NO-UNDO.
DEF VAR cLogFile          AS CHAR NO-UNDO.
DEF VAR hDataBrw          AS HANDLE NO-UNDO.    
DEF VAR cSqlDb            AS CHAR NO-UNDO.
DEF VAR hViewFunc         AS HANDLE NO-UNDO. // handle to JBoxViewDsDefTable.w
DEF VAR hDsViewFunc       AS HANDLE NO-UNDO. // dataset in JboxViewDsDefTable.w
DEF VAR cDelimiter        AS CHAR NO-UNDO INIT "|".
DEF VAR cScriptOutType    AS CHAR NO-UNDO.
DEF VAR cSqlDbList        AS CHAR NO-UNDO.
DEF VAR ix                AS INT  NO-UNDO.
DEF VAR bOkUser           AS LOG  NO-UNDO.
DEF VAR iStartTime        AS INT NO-UNDO.
DEF VAR bDevMode          AS LOG NO-UNDO.
DEF VAR cOutputTo         AS CHAR NO-UNDO.    
DEF VAR cExportCat        AS CHAR NO-UNDO.
DEF VAR iOsError          AS INT  NO-UNDO.       
//bDevMode = YES.

ETIME(YES).
iStartTime = MTIME.

IF bDevMode THEN
  ASSIGN cViewDsFile      = "C:\temp\sjekk.json"
         cViewDsFile      = "C:\Users\brynj\Documents\LazyBI\config\views\MariaItemSuppQry.json"
         cViewDsID        = "83290c15-37e4-59a7-b014-1cb8c83992c3"
         cViewDsId        = "c68a9412-d4e7-74a2-c014-bdde6ca00b9f"
         cConnectionFile  = "C:\Progress\JukeBox\WebClient\config\sportsSql.json"
         cConnectionFile  = "C:\Users\brynj\Documents\LazyBI\config\connections\MariaSports.json"
         cRunQueryId      = "query1"
         .
ELSE DO:
  ASSIGN cViewDsFile      = ENTRY(1,SESSION:PARAMETER,"^")
         cViewDsID        = ENTRY(2,SESSION:PARAMETER,"^")
         cConnectionFile  = ENTRY(3,SESSION:PARAMETER,"^")
         cRunQueryId      = ENTRY(4,SESSION:PARAMETER,"^")
         .
  IF NUM-ENTRIES(SESSION:PARAMETER,"^") > 4 THEN       
    cAsConnectString = ENTRY(5,SESSION:PARAMETER,"^").
  IF NUM-ENTRIES(SESSION:PARAMETER,"^") > 5 THEN       
    cSqlDbList = ENTRY(6,SESSION:PARAMETER,"^").
END.   

FUNCTION getExportFileName RETURNS CHAR(): // called from toexcelviafile.p
  RETURN cExportFileName.
END.  
FUNCTION getExportDelimiter RETURNS CHAR():
  RETURN cDelimiter.
END.

DEF STREAM sLog.
FUNCTION LogThis RETURNS LOGICAL
  ( INPUT icLogText   AS CHAR,
    INPUT iiSkipLines AS INT ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF cLogFile NE "" THEN DO:
  OUTPUT STREAM sLog TO VALUE(cLogFile) APPEND.
  PUT STREAM sLog UNFORMATTED NOW " ** " icLogText.
  CASE iiSkipLines:
    WHEN 0 THEN PUT STREAM sLog SKIP.
    WHEN 1 THEN PUT STREAM sLog SKIP(1).
    WHEN 2 THEN PUT STREAM sLog SKIP(2).
    WHEN 3 THEN PUT STREAM sLog SKIP(3).
    WHEN 4 THEN PUT STREAM sLog SKIP(4).
    WHEN 5 THEN PUT STREAM sLog SKIP(5).
  END CASE.
  OUTPUT STREAM sLog CLOSE.
END.
RETURN TRUE.

END FUNCTION.
        
        
CREATE SERVER hServer.

IF ENTRY(1,cAsConnectString,";") NE "" THEN DO ON ERROR UNDO, THROW: 
  hServer:CONNECT(ENTRY(1,cAsConnectString,";")).  
    
  JBoxSession:Instance:AppServerHandle = hServer.
  
  CATCH eErr AS Progress.Lang.Error :
    OUTPUT TO queryError.dmp APPEND.
    PUT UNFORMATTED NOW ": - Could not connect to appserver: " ENTRY(1,cAsConnectString,";")  " " eErr:getMessage(1) SKIP.
    OUTPUT CLOSE.
    QUIT.
  END CATCH.
END.
ELSE hServer = SESSION.    

JBoxSession:Instance:UseAdvGui = NO.
       
IF cConnectionFile = "<startup>" THEN DO:
  
  RUN dbLogin(hServer,OUTPUT bOkUser).
  IF NOT bOkUser THEN DO:
    OUTPUT TO queryError.dmp APPEND.
    IF hServer = SESSION THEN
      PUT UNFORMATTED NOW ": - Login failed" SKIP.
    OUTPUT CLOSE.
    QUIT.
  END.  
  
  IF NOT JBoxSchemaCache:Instance:getDbSchema(hdsSchema) THEN DO:
    OUTPUT TO queryError.dmp APPEND.
    IF hServer = SESSION THEN
      PUT UNFORMATTED NOW ": - Could not retrieve schema from database-connection" SKIP.
    ELSE  
      PUT UNFORMATTED NOW ": - Could not retrieve schema from appserver-connection: " ENTRY(1,cAsConnectString,";") SKIP.
    OUTPUT CLOSE.
    QUIT.
  END.  
  DO ix = 1 TO NUM-ENTRIES(cSqlDbList):
    IF NOT CAN-FIND(FIRST tt_db WHERE tt_db.cSourceName = ENTRY(1,ENTRY(ix,cSqlDbList),"|")) THEN DO:
      IF NOT JBoxSchemaCache:Instance:getSqlDbSchema(hDsSchema,
                                 ENTRY(1,ENTRY(ix,cSqlDbList),"|"), // data source name
                                 ENTRY(2,ENTRY(ix,cSqlDbList),"|"), // db name
                                 ENTRY(3,ENTRY(ix,cSqlDbList),"|"),
                                 hServer) THEN DO: // db type (equals datasource type for sql)
        OUTPUT TO queryError.dmp APPEND.
        PUT UNFORMATTED NOW ": - Could not retrieve schema from database-connection: " ENTRY(ix,cSqlDbList) SKIP.
        OUTPUT CLOSE.
        QUIT.
      END.                         
    END.  
  END.  
END.  
ELSE DO:
  IF SEARCH(cConnectionFile) = ? THEN DO:
    OUTPUT TO queryError.dmp APPEND.
    PUT UNFORMATTED NOW ": - Could not find connection file " cConnectionFile SKIP.
    OUTPUT CLOSE.
    QUIT.
  END.  
  IF NOT JBoxSchemaCache:Instance:getDbSchema(hDsSchema,cConnectionFile) THEN DO:  
    OUTPUT TO queryError.dmp APPEND.
    PUT UNFORMATTED NOW ": - Could not retrieve schema for datasource: " + JBoxSchemaCache:Instance:schemaMessage. 
    OUTPUT CLOSE.
    QUIT.
  END.
END.

IF SEARCH(cViewDsFile) = ? THEN DO:
  OUTPUT TO queryError.dmp APPEND.
  PUT UNFORMATTED NOW ": - Could not find view definition file " cViewDsFile SKIP.
  OUTPUT CLOSE.
  QUIT.
END.  
  
hDsViewDs:READ-JSON ("file",cViewDsFile).

FIND FIRST ttViewDs
     WHERE ttViewDs.ViewDsId = cViewDsId
     NO-ERROR.
IF NOT AVAIL ttViewDs THEN DO:
  OUTPUT TO queryError.dmp APPEND.
  PUT UNFORMATTED NOW ": - Could not find view id " cViewDsId " in view definition file " cViewDsFile SKIP.
  OUTPUT CLOSE.
  QUIT.
END.

IF cRunQueryId NE "" THEN DO:
  FIND FIRST ttJBoxUserSetting
       WHERE ttJBoxUserSetting.ViewDsId = cViewDsId
         AND ttJBoxUserSetting.cObjectName = "userquery"
         AND ttJBoxUserSetting.cSettingName = cRunQueryId
       NO-ERROR.
       
  IF NOT AVAIL ttViewDs THEN DO:
    OUTPUT TO queryError.dmp APPEND.
    PUT UNFORMATTED NOW ": - Could not find filter setting for userquery " cRunQueryId " in view " cViewDsId " for definition file " cViewDsFile SKIP.
    OUTPUT CLOSE.
    QUIT.
  END.
  ELSE DO:
    ASSIGN cDelimiter = IF ttJBoxUserSetting.ScriptOutputType = "txtt" THEN "~t"
                        ELSE IF ttJBoxUserSetting.ScriptOutputType = "csv" THEN ";" 
                        ELSE "|"
           cScriptOutType = ttJBoxUserSetting.ScriptOutputType     
           cOutputTo  = ttJBoxUserSetting.ScriptOutputDir.
           
    IF cOutputTo = "" THEN DO:
      OUTPUT TO queryError.dmp APPEND.
      PUT UNFORMATTED NOW ": - Output destination (file or directory) not assigned in definition file " cViewDsFile SKIP.
      OUTPUT CLOSE.
      QUIT.
    END.
    cOutputTo = REPLACE(cOutputTo,"\","/").
    
    IF NUM-ENTRIES(ENTRY(NUM-ENTRIES(TRIM(cOutputTo,"."),"/"),TRIM(cOutputTo,"."),"/"),".") > 1 THEN
      cExportFileName = cOutputTo.
    ELSE                       
      ASSIGN cExportCat = cOutputTo
             cExportFileName = TRIM(cOutputTo,"/") + "/" 
                      + ttViewDs.SourceName 
                      + "_" + ttJBoxUserSetting.cSetting
                      + "_" + ISO-DATE(TODAY) + "_" + REPLACE(STRING(TIME,"HH:MM:SS"),":","-")
                      + "." + (IF ttJBoxUserSetting.ScriptOutputType BEGINS "txt" THEN "txt"
                               ELSE IF ttJBoxUserSetting.ScriptOutputType BEGINS "csv" THEN "csv"
                               ELSE ttJBoxUserSetting.ScriptOutputType)
                      .
  END.                
END.
ELSE DO:
  ASSIGN cDelimiter = IF ttViewDs.ScriptOutputType = "txtt" THEN "~t"
                      ELSE IF ttViewDs.ScriptOutputType = "csv" THEN ";" 
                      ELSE "|"
         cScriptOutType = ttViewDs.ScriptOutputType
         cOutputTo  = ttViewDs.ScriptOutputDir
         .

  IF cOutputTo = "" THEN DO:
    OUTPUT TO queryError.dmp APPEND.
    PUT UNFORMATTED NOW ": - Output destination (file or directory) not assigned in definition file " cViewDsFile SKIP.
    OUTPUT CLOSE.
    QUIT.
  END.

  cOutputTo = REPLACE(cOutputTo,"\","/").
  IF NUM-ENTRIES(ENTRY(NUM-ENTRIES(TRIM(cOutputTo,"."),"/"),TRIM(cOutputTo,"."),"/"),".") > 1 THEN
    cExportFileName = cOutputTo.
  ELSE                       
    ASSIGN cExportCat = cOutputTo
           cExportFileName = TRIM(cOutputTo,"/") + "/" 
                    + ttViewDs.SourceName 
                    + "_" + ttViewDs.ViewDsName
                    + "_" + ISO-DATE(TODAY) + "_" + REPLACE(STRING(TIME,"HH:MM:SS"),":","-")
                    + "." + (IF ttViewDs.ScriptOutputType BEGINS "txt" THEN "txt"
                             ELSE IF ttViewDs.ScriptOutputType BEGINS "csv" THEN "csv"
                             ELSE ttViewDs.ScriptOutputType)
                    .
END.

IF cExportCat NE "" THEN DO:  
  FILE-INFO:FILE-NAME = cExportCat.
  IF FILE-INFO:FILE-TYPE = ? THEN DO:
    OS-CREATE-DIR VALUE(cExportCat).
    iOsError = OS-ERROR.
    IF iOsError NE 0 THEN DO:
      OUTPUT TO queryError.dmp APPEND.
      PUT UNFORMATTED NOW ": - Unable to create directory " cExportCat SKIP.
      OUTPUT CLOSE.
      QUIT.
    END.  
  END.
END.    

cLogFile = ttViewDs.ScriptLogFile.                
     
FIND FIRST tt_db
     WHERE tt_db.cLDBname     = ttViewDs.BaseDb
       AND tt_db.cSourceName  = ttViewDs.SourceName
     NO-ERROR.
IF NOT AVAIL tt_db THEN DO:
  OUTPUT TO queryError.dmp APPEND.
  PUT UNFORMATTED NOW ": - Could not match db schema for view " +  ttViewDs.SourceName + ", " + ttViewDs.ViewDsName SKIP.
  OUTPUT CLOSE.
  QUIT.
END.     

LogThis("Start export for " + ttViewDs.SourceName + "." + ttViewDs.ViewDsName + " Initial load time: " + STRING(etime / 1000), 1).

IF tt_db.cDbType MATCHES "*sql*" THEN
  cSqlDb = tt_db.cLDBname.     

RUN JBoxViewDsDefTable.w PERSIST SET hViewFunc.
hDsViewFunc = DYNAMIC-FUNCTION("getViewDsHandle" IN hViewFunc).
hDsViewFunc:COPY-DATASET(hdsViewDs).
IF NOT DYNAMIC-FUNCTION("setCurrViewId" IN hViewFunc,cViewDsId) THEN DO:
  OUTPUT TO queryError.dmp APPEND.
  PUT UNFORMATTED NOW ": - Failed to syncronize view " +  ttViewDs.SourceName + ", " + ttViewDs.ViewDsName SKIP.
  OUTPUT CLOSE.
  QUIT.
END.

IF cLogFile NE "" THEN DO:  
  IF ENTRY(1,cAsConnectString,";") NE "" THEN
    DYNAMIC-FUNCTION("setASlibBehaviour","QueryLogFile|" + cLogFile).
  ELSE
    DYNAMIC-FUNCTION("setQueryLogFile",cLogFile).
END.    
       
RUN JboxDataBrw.w PERSIST SET hDataBrw.
DYNAMIC-FUNCTION("setParent" IN hDataBrw,THIS-PROCEDURE).

PROCEDURE myDatabrowseObject:
  DEF INPUT PARAM ioDynDataBrowse AS JBoxDynDataBrowse NO-UNDO.
  
  DEF VAR hDsView AS HANDLE NO-UNDO.
  DEF VAR htt          AS HANDLE NO-UNDO.
  DEF VAR hBuffer      AS HANDLE NO-UNDO.
  DEF VAR ix           AS INT    NO-UNDO.
  DEF VAR cExceptCols  AS CHAR   NO-UNDO.
  DEF VAR cCsvDelim    AS CHAR   NO-UNDO.
    
  // must be set prior to initialization:
  ioDynDataBrowse:ViewDsId = ttViewDs.ViewDsId.
  ioDynDataBrowse:EnableSaveQuery = NO.
  ioDynDataBrowse:userSettingContext = "JBoxViewDsDef.w".
  ioDynDataBrowse:QueryCanBeScheduled = NO. 
  ioDynDataBrowse:QueryCanBeShared = NO.
  
  hDsView = DYNAMIC-FUNCTION("getViewDsHandle" IN hViewFunc).
  ioDynDataBrowse:hViewDsUserSetting = hDsView:GET-BUFFER-HANDLE (4). 
  
  IF cSqlDb = "" THEN DO:
    DYNAMIC-FUNCTION("setActiveASconnection",ttViewDs.SourceName).  
  
    ioDynDataBrowse:InitializeQuery(
        DYNAMIC-FUNCTION("getBuffersAndFields" IN hViewFunc,YES)
       ,DYNAMIC-FUNCTION("getQueryJoin" IN hViewFunc,"","")
       ,DYNAMIC-FUNCTION("getSortColumn" IN hViewFunc)  
       ,FALSE /* <- do record count */
       ).
  END.     
  ELSE DO:     
    JBoxSchemaCache:Instance:setUseDefaultConnection().
    ioDynDataBrowse:InitializeQuery(
        DYNAMIC-FUNCTION("getBuffersAndFields" IN hViewFunc,YES)
       ,DYNAMIC-FUNCTION("getQueryJoin" IN hViewFunc,"","")
       ,DYNAMIC-FUNCTION("getSortColumn" IN hViewFunc)  
       ,FALSE /* <- do record count */
       ,ttViewDs.SourceName + "." + cSqlDb /* reference to sql database, ie parameter for jbserv_get_sql_data.p */     
        ).
  END.     
  
  //ioDynDataBrowse:calcFieldProc = "customer_browsecalc.p".
   
 // ioDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE:WINDOW:HIDDEN = YES.
  
  ioDynDataBrowse:BROWSE-OBJECT:RowsToBatch = 0.
  
  ioDynDataBrowse:BROWSE-OBJECT:setJBoxAttribute("DataSourceName",ttViewDs.SourceName).
    
  ioDynDataBrowse:BROWSE-OBJECT:baseQuery = DYNAMIC-FUNCTION("getBaseQuery" IN hViewFunc).
  
  ioDynDataBrowse:BatchMode = YES.
  
  IF cRunQueryId = "" THEN
    ioDynDataBrowse:BROWSE-OBJECT:openQuery().
  ELSE   // run a stored filter via activateWithFilter
    ioDynDataBrowse:startViewDsUserQuery(cRunQueryId).

  JBoxSession:Instance:setJBoxAttribute("dropExcelWarning","yes").
  
  IF DYNAMIC-FUNCTION("FetchAllRows",ioDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE) THEN DO:

    hBuffer = ioDynDataBrowse:BROWSE-OBJECT:BUFFER-HANDLE.
    DO ix = 1 TO ioDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE:NUM-COLUMNS:
      IF NOT ioDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):VISIBLE THEN
        cExceptCols = cExceptCols + (IF cExceptCols NE "" THEN "," ELSE "") 
                    + ioDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE:GET-BROWSE-COLUMN(ix):NAME.
    END.              
/*    cExceptCols = IF ioDynDataBrowse:BROWSE-OBJECT:distinctColumns NE "" THEN*/
/*                    "RowCount"                                               */
/*                  ELSE "RowCount,jbCountDistinct,jbAverage".                 */
  
    IF CAN-DO("json,xml",cScriptOutType) THEN DO:
      CREATE TEMP-TABLE htt.
      DO ix = 1 TO hBuffer:NUM-FIELDS:
        IF CAN-DO(cExceptCols,hBuffer:BUFFER-FIELD(ix):NAME) 
           OR hBuffer:BUFFER-FIELD(ix):NAME BEGINS "RowIdent"
           OR hBuffer:BUFFER-FIELD(ix):NAME BEGINS "jbextent_"
              THEN NEXT.
             
        htt:ADD-LIKE-FIELD (hBuffer:BUFFER-FIELD(ix):NAME, hBuffer:BUFFER-FIELD(ix):HANDLE).
      END.
      htt:TEMP-TABLE-PREPARE(hBuffer:NAME).
      htt:COPY-TEMP-TABLE (hBuffer,YES,NO,YES).
      IF cScriptOutType = "Json" THEN
        htt:WRITE-JSON("file",cExportFileName,YES).
      ELSE
        htt:WRITE-XML("file",cExportFileName,YES).
      DELETE OBJECT htt.  
    END.  
    ELSE IF cScriptOutType BEGINS "csv" THEN DO:
      cCsvDelim = IF cScriptOutType = "csvp" THEN "|" ELSE ";".
      IF NOT DYNAMIC-FUNCTION("BufferToCsv",ioDynDataBrowse:BROWSE-OBJECT:BUFFER-HANDLE,cExportFileName,cCsvDelim,cExceptCols,NO) THEN
        LogThis("Export to " + cExportFileName + " failed when executing BufferToCsv for export file name " + cExportFileName, 1).
    END.  
    ELSE IF cScriptOutType = "txtp" THEN
      RUN toExcelViaFile.p (ioDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,-4).
    ELSE  
      RUN toExcelViaFile.p (ioDynDataBrowse:BROWSE-OBJECT:BROWSE-HANDLE,-3).
  END.      
  ELSE
    LogThis("Export to " + cExportFileName + " failed when executing FetchAllRows", 1).
END PROCEDURE.  
       
LogThis("Export to " + cExportFileName + " finished. Elapse time: " + STRING((MTIME - iStartTime)  / 1000), 1).
       
QUIT.

PROCEDURE dbLogin:
  DEF INPUT  PARAM ihAppServer AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM bOkUser     AS LOG NO-UNDO.

  DEF VAR bScand       AS LOG  NO-UNDO.
  DEF VAR cPrompt      AS CHAR NO-UNDO.
  DEF VAR iReturn      AS INT  NO-UNDO.
  DEF VAR cUserId       AS CHAR NO-UNDO.    
  DEF VAR cPwd         AS CHAR NO-UNDO.
  DEF VAR ocSessionId  AS CHAR NO-UNDO.
  DEF VAR ocAsUserName AS CHAR NO-UNDO.
  DEF VAR oiCompanyId  AS INT  NO-UNDO.
  
  cUserId = System.Environment:UserName.
  
  
  RUN jbserv_validateuser.p ON ihAppServer (cUserId,"",
                                            SESSION:DATE-FORMAT,
                                            SESSION:NUMERIC-FORMAT,
                                            OUTPUT ocSessionId,
                                            OUTPUT ocASuserName,
                                            OUTPUT oiCompanyId,
                                            OUTPUT bOkUser).

  IF NOT bOkUser THEN DO:                                            
  
    RUN JBoxAskForValue.w ((IF bScand THEN "Logg inn " ELSE "Login ")
                          ,(IF bScand THEN "Brukernavn" ELSE "Username") + "|CHARACTER|x(30)¤" + (IF bScand THEN "Passord" ELSE "Password") + "|CHARACTER|x(30)||pwd"
                          ,INPUT-OUTPUT cPrompt,OUTPUT iReturn).
    IF iReturn = 2 THEN DO:
      ASSIGN cUserId = ENTRY(1,cPrompt,"|")
             cPwd   = ENTRY(2,cPrompt,"|"). 
      RUN jbserv_validateuser.p ON ihAppServer (cUserId,cPwd,
                                         SESSION:DATE-FORMAT,
                                         SESSION:NUMERIC-FORMAT,
                                         OUTPUT ocSessionId,
                                         OUTPUT ocASuserName,
                                         OUTPUT oiCompanyId,
                                         OUTPUT bOkUser).
    END.  
  END.
  
  IF bOkUser THEN DO:
    JBoxServerAPI:Instance:sessionId = ocSessionId.
    DYNAMIC-FUNCTION("setASuserId",cUserId,ocASuserName).
    DYNAMIC-FUNCTION("setCompanyId",oiCompanyId).
  END.
             
  END PROCEDURE.                                       
    
  