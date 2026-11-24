&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEF VAR ix                AS INT    NO-UNDO.
DEF VAR bOk               AS LOG    NO-UNDO.
DEF VAR bTest             AS LOG    NO-UNDO.
DEF VAR cRoot             AS CHAR   NO-UNDO INIT ".\".
DEF VAR cProPath          AS CHAR   NO-UNDO.
DEF VAR bRestart          AS LOG    NO-UNDO.
DEF VAR hServer           AS HANDLE NO-UNDO.
DEF VAR cOSfile           AS CHAR   NO-UNDO.
DEF VAR cSignature        AS CHAR   NO-UNDO.
DEF VAR cLatestPackage    AS CHAR   NO-UNDO.
DEF VAR cSessionId        AS CHAR   NO-UNDO.
DEF VAR cReturnTrans      AS CHAR   NO-UNDO.
DEF VAR iNumPackages      AS INT    NO-UNDO.
DEF VAR httPackages       AS HANDLE NO-UNDO.
DEF VAR httPackagesBuffer AS HANDLE NO-UNDO.
DEF VAR httPackagesQuery  AS HANDLE NO-UNDO.
DEF VAR cAppTitle         AS CHAR   NO-UNDO.
DEF VAR cLanguages        AS CHAR   NO-UNDO.
DEF VAR cBaseLanguage     AS CHAR   NO-UNDO.
DEF VAR cPrefLanguage     AS CHAR   NO-UNDO.
DEF VAR cBehaviour        AS CHAR   NO-UNDO.
DEF VAR cUserId           AS CHAR   NO-UNDO.
DEF VAR cTemp             AS CHAR   NO-UNDO.
DEF VAR cOrgProPath       AS CHAR   NO-UNDO.
DEF VAR hOldAppservice    AS HANDLE NO-UNDO.
DEF VAR hNewAppservice    AS HANDLE NO-UNDO.
DEF VAR cOldSessionId     AS CHAR   NO-UNDO.
DEF VAR bWcUpgrade        AS LOG    NO-UNDO.
DEF VAR bViperUpgrade     AS LOG    NO-UNDO.
DEF VAR bAUIUpgrade       AS LOG    NO-UNDO.
DEF VAR iOsError          AS INT    NO-UNDO.
DEF VAR iFileSize         AS INT    NO-UNDO.
DEF VAR cVirtualStore     AS CHAR   NO-UNDO.
DEF VAR cVirtualRoot      AS CHAR   NO-UNDO.
DEF VAR cRenamePattern    AS CHAR   NO-UNDO INIT "*jll;dll".
DEF VAR bRunAsAdmin       AS LOG    NO-UNDO.
DEF VAR hWindow           AS HANDLE NO-UNDO.
DEF VAR hFrame            AS HANDLE NO-UNDO.
DEF VAR hBgFrame          AS HANDLE NO-UNDO.
DEF VAR cPrefUser         AS CHAR   NO-UNDO.

DEF VAR httDoc          AS HANDLE NO-UNDO.
DEF TEMP-TABLE ttDoc NO-UNDO
    FIELD cFileName       AS CHAR
    FIELD cFullPathName   AS CHAR
    FIELD cFileType       AS CHAR
    FIELD cDescription    AS CHAR
    FIELD iDocSize        AS INT
    FIELD blDocument      AS BLOB
    FIELD dFileCreateDate AS DATE
    FIELD iFileCreateTime AS INT
    FIELD dFileModDate    AS DATE
    FIELD iFileModTime    AS INT
    FIELD cCreatedBy      AS CHAR
    FIELD dCreated        AS DATE
    FIELD cContext        AS CHAR
    FIELD cEntityId       AS CHAR
    .
httDoc = BUFFER ttDoc:HANDLE:TABLE-HANDLE.

DEF STREAM strFile.

DEF VAR bChunkInProgress AS LOG    NO-UNDO.
DEF VAR httDocInfoBuf    AS HANDLE NO-UNDO.

DEF TEMP-TABLE ttDocInfo NO-UNDO
    FIELD iJBoxDocumentId AS INT
    FIELD iDocSize        AS INT
    FIELD cFileName       AS CHAR
    FIELD cFileType       AS CHAR
    FIELD cDescription    AS CHAR
    FIELD dFileModDate    AS DATE
    FIELD cCat            AS CHAR
    FIELD blChunk         AS BLOB
    .
httDocInfoBuf = BUFFER ttDocInfo:HANDLE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-CheckIfAdmin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckIfAdmin Procedure 
FUNCTION CheckIfAdmin RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CleanUpDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CleanUpDir Procedure 
FUNCTION CleanUpDir RETURNS LOGICAL
  ( INPUT icCleanUpDir AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ConnectAppFarm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD ConnectAppFarm Procedure 
FUNCTION ConnectAppFarm RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CreateInstallDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CreateInstallDir Procedure 
FUNCTION CreateInstallDir RETURNS LOGICAL
  ( INPUT icSaveDir AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPackageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPackageList Procedure 
FUNCTION getPackageList RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVirtualStore) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getVirtualStore Procedure 
FUNCTION getVirtualStore RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InstallPackage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD InstallPackage Procedure 
FUNCTION InstallPackage RETURNS LOGICAL
  ( INPUT icPackageId AS CHAR,
    INPUT icSaveDir   AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVariable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setVariable Procedure 
FUNCTION setVariable RETURNS LOGICAL
  ( INPUT icVarName AS CHAR,
    INPUT icValue   AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

IF VALID-HANDLE(SOURCE-PROCEDURE) THEN 
  ASSIGN cRoot          = DYNAMIC-FUNCTION("getRootDir" IN SOURCE-PROCEDURE)
         bTest          = TRUE
         cOrgProPath    = PROPATH
         hOldAppservice = DYNAMIC-FUNCTION("getAppServiceHandle")
         cOldSessionId  = DYNAMIC-FUNCTION("getSessionId")
         .

cVirtualStore = getVirtualStore().
IF cVirtualStore NE "" THEN DO:
  bRunAsAdmin = CheckIfAdmin().
  IF SEARCH(cVirtualStore + "new_webclient\progress.cfg") NE ? THEN 
    OS-DELETE VALUE(cVirtualStore + "new_webclient") RECURSIVE.    
  IF SEARCH(cVirtualStore + "new_viper\viper.key") NE ? THEN 
    OS-DELETE VALUE(cVirtualStore + "new_viper") RECURSIVE.    
  IF NOT bRunAsAdmin AND SEARCH(cVirtualStore + "WebClient_Upgrade_Warning.txt") NE ? THEN DO:
    IF SEARCH(cVirtualStore + "Upgrade_Warning_Message.txt") NE ? THEN
      MESSAGE "The existence of the file " cVirtualStore + "WebClient_Upgrade_Warning.txt" SKIP
              "indicates that a recent application upgrade required the application to be re-started with Administrator privileges." SKIP(1)
              "If the restart was done from a user account other than " OS-GETENV("username") " the WebClient_Upgrade_Warning.txt file was not removed" SKIP
              "but you can still continue to start the application." SKIP(1)
              "If the restart as Administrator hasn't been done yet it is STRONGLY RECOMMENDED that you DON'T CONTINUE to start the program at this time." SKIP(1)
              '(To restart as Administrator right-click on the startup icon and select "Run as Administrator")' SKIP(1)
              VIEW-AS ALERT-BOX INFO BUTTONS YES-NO TITLE "Continue to start application?" UPDATE bOk. 
    ELSE DO:
      MESSAGE "The existence of the file " cVirtualStore + "WebClient_Upgrade_Warning.txt" SKIP
              "indicates that a recent application upgrade required the application to be re-started with Administrator privileges." SKIP(1)
              "If the admin restart was done from a user account other than " OS-GETENV("username") " the WebClient_Upgrade_Warning.txt file was not removed." SKIP
              "In this case you can safely start the application again and bypass the warning." SKIP(1)
              'If the restart as Administrator has not been done you can right-click on the startup icon and select "Run as Administrator"'
              VIEW-AS ALERT-BOX INFO BUTTONS OK TITLE "Incomplete upgrade". 
      OUTPUT TO VALUE(cVirtualStore + "Upgrade_Warning_Message.txt").
      PUT UNFORMATTED "The existence of the file " cVirtualStore + "WebClient_Upgrade_Warning.txt" 
                    + " indicates that a recent application upgrade required the application to be re-started with Administrator privileges.".
      OUTPUT CLOSE.
    END.
    IF NOT bOk THEN QUIT.
    ELSE DO:
      OS-DELETE VALUE(cVirtualStore + "WebClient_Upgrade_Warning.txt") NO-ERROR.  
      OS-DELETE VALUE(cVirtualStore + "Upgrade_Warning_Message.txt") NO-ERROR.  
    END. 
  END.
END.

IF SEARCH("jboxstartup_hook1.r") NE ? THEN
  RUN jboxstartup_hook1.r.

IF SEARCH(cRoot + "signature.txt") NE ? THEN DO:

  INPUT FROM VALUE(cRoot + "signature.txt").
  IMPORT UNFORMATTED cSignature.
  INPUT CLOSE.
  IF cSignature = "" THEN DO:
    MESSAGE "Missing signature (could be missing LF in signature file)"
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
    QUIT.
  END.
  IF NUM-ENTRIES(cSignature,"|") > 1 THEN
    cLatestPackage = ENTRY(2,cSignature,"|") NO-ERROR.
  
  IF NUM-ENTRIES(cSignature,"|") GE 3 THEN cAppTitle     = ENTRY(3,cSignature,"|").
  IF NUM-ENTRIES(cSignature,"|") GE 4 THEN cLanguages    = ENTRY(4,cSignature,"|").
  IF NUM-ENTRIES(cSignature,"|") GE 5 THEN cBaseLanguage = ENTRY(5,cSignature,"|").

  IF ConnectAppFarm() THEN DO:
    IF GetPackageList() THEN 
      RUN GetUpdates.
    hServer:DISCONNECT() NO-ERROR.
  END.
  ELSE DO:
    IF SEARCH(cRoot + "propath.txt") NE ? THEN DO:
      INPUT FROM VALUE(cRoot + "propath.txt").
      IMPORT UNFORMATTED cProPath.
      INPUT CLOSE.
      PROPATH = cProPath.
    END.
  END.
  
  IF SEARCH("jboxstartup_hook2.r") NE ? THEN
    RUN jboxstartup_hook2.r.

  IF iNumPackages > 0 THEN DO:
    IF VALID-HANDLE(hWindow) THEN
      hWindow:TITLE = "Processing packages.".
    IF cVirtualStore = "" THEN
      cVirtualStore = getVirtualStore().

    IF SEARCH("gzip.exe") NE ? THEN
      OS-COMMAND SILENT VALUE(SEARCH("gzip.exe") + " -dfr *.*").
    
    IF VALID-HANDLE(hWindow) THEN
      hWindow:TITLE = hWindow:TITLE + ".".
  
    IF cVirtualStore NE "" THEN
      RUN RenameFiles (cVirtualStore).
    RUN RenameFiles (cRoot).
  END.
  ELSE RUN RenameFiles (cRoot).

  DELETE OBJECT hFrame   NO-ERROR.
  DELETE OBJECT hBgFrame NO-ERROR.
  DELETE OBJECT hWindow  NO-ERROR.

  IF SEARCH("jboxstartup_hook3.r") NE ? THEN
    RUN jboxstartup_hook3.r.

  IF SEARCH(cRoot + "new_jboxstartup.r") NE ? THEN DO:    
    FILE-INFO:FILE-NAME = SEARCH("jboxstartup.r").
    iFileSize = FILE-INFO:FILE-SIZE.
    FILE-INFO:FILE-NAME = SEARCH(cRoot + "new_jboxstartup.r").
    IF iFileSize NE FILE-INFO:FILE-SIZE THEN
      bRestart = TRUE.

    OS-DELETE VALUE(SEARCH("jboxstartup.r")) NO-ERROR.
    OS-COPY   VALUE(SEARCH("new_jboxstartup.r")) VALUE(cRoot + "jboxstartup.r").
    OS-DELETE VALUE(SEARCH("new_jboxstartup.r")).
  END.
  IF SEARCH(cRoot + "new_progress.ini") NE ? THEN DO:    
    FILE-INFO:FILE-NAME = SEARCH("progress.ini").
    iFileSize = FILE-INFO:FILE-SIZE.
    FILE-INFO:FILE-NAME = SEARCH(cRoot + "new_progress.ini").
    IF iFileSize NE FILE-INFO:FILE-SIZE THEN
      bRestart = TRUE.

    OS-DELETE VALUE(SEARCH("progress.ini")) NO-ERROR.
    OS-COPY   VALUE(SEARCH("new_progress.ini")) VALUE(cRoot + "progress.ini").
    OS-DELETE VALUE(SEARCH("new_progress.ini")).
  END.
  IF SEARCH(cRoot + "new_startup.pf") NE ? THEN DO:    
    FILE-INFO:FILE-NAME = SEARCH("startup.pf").
    iFileSize = FILE-INFO:FILE-SIZE.
    FILE-INFO:FILE-NAME = SEARCH(cRoot + "new_startup.pf").
    IF iFileSize NE FILE-INFO:FILE-SIZE THEN
      bRestart = TRUE.

    OS-DELETE VALUE(SEARCH("startup.pf")) NO-ERROR.
    OS-COPY   VALUE(SEARCH("new_startup.pf")) VALUE(cRoot + "startup.pf").
    OS-DELETE VALUE(SEARCH("new_startup.pf")).
  END.
  
  IF SEARCH("jboxstartup_hook4.r") NE ? THEN
    RUN jboxstartup_hook4.r.

  IF SEARCH(cRoot + "new_webclient\progress.cfg") NE ? THEN 
    ASSIGN bRestart   = YES
           bWcUpgrade = YES.

  IF SEARCH(cRoot + "new_viper\viper.key") NE ? THEN 
    ASSIGN bRestart      = YES
           bViperUpgrade = YES.

  IF SEARCH(cRoot + "new_assemblies\assemblies.xml") NE ? THEN 
    ASSIGN bRestart    = YES
           bAUIUpgrade = YES.

  IF SEARCH("jboxstartup_hook5.r") NE ? THEN
    RUN jboxstartup_hook5.r.

  IF (bWcUpgrade AND cVirtualStore NE "" AND SEARCH(cVirtualStore + "new_webclient\progress.cfg") NE ?) OR
     (bViperUpgrade AND cVirtualStore NE "" AND SEARCH(cVirtualStore + "new_viper\viper.key") NE ?) OR
     (bAUIUpgrade AND cVirtualStore NE "" AND SEARCH(cVirtualStore + "new_assemblies\assemblies.xml") NE ?)
     THEN DO:
    MESSAGE "The upgrade requires a restart of the application with Administrator privileges" SKIP
            'Right-click on the startup icon and select "Run as Administrator"'
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    OUTPUT TO VALUE(cVirtualStore + "WebClient_Upgrade_Warning.txt").
    PUT UNFORMATTED "The last upgrade requires a restart of the application with Administrator privileges".
    OUTPUT CLOSE.
    IF NOT bTest THEN QUIT.
  END.

  IF cAppTitle = "JukeBox" THEN 
    MESSAGE "To add JukeBox to your development environment:" SKIP
            "Add the generated propath in propath.txt to your propath" SKIP
            "To verify that the installation is ok, start Progress, connect a Sports2000 database," SKIP
            "open and run winsrc\samples\customer.w." SKIP
            "(If you use Progress version 9.1d or 9.1e you cannot use JBoxFUlib.p," SKIP
            " ref winsrc\incl\devMode.i and winsrc\template\JBoxStart.p.)" 
            VIEW-AS ALERT-BOX INFORMATION.
  ELSE IF bTest THEN 
    MESSAGE "Application install/upgrade completed"
            VIEW-AS ALERT-BOX INFORMATION.
  ELSE IF NOT bRestart THEN DO:
    IF SEARCH("jboxappstart.r") NE ? OR SEARCH("jboxappstart.p") NE ? THEN DO:
      IF SEARCH(cRoot + "preferences.txt") NE ? THEN DO:
        INPUT FROM VALUE(cRoot + "preferences.txt").
        REPEAT:
          IMPORT UNFORMATTED cTemp.
          CASE ENTRY(1,cTemp,"¤"):
            WHEN "language"     THEN cPrefLanguage          = ENTRY(2,cTemp,"¤").
            WHEN "userid"       THEN cUserId                = ENTRY(2,cTemp,"¤").
            WHEN "behaviour"    THEN cBehaviour             = ENTRY(2,cTemp,"¤").
            WHEN "date-format"  THEN SESSION:DATE-FORMAT    = ENTRY(2,cTemp,"¤") NO-ERROR.
            WHEN "num-format"   THEN SESSION:NUMERIC-FORMAT = ENTRY(2,cTemp,"¤") NO-ERROR.
          END CASE.
        END.
        INPUT CLOSE.
      END.
      ELSE cBehaviour = "DefaultSortFont|6," +   
                        "DefaultSortColor|15," + 
                        "BrowseSearchDefault|match," +
                        "TabOnReturn|yes," +       
                        "SetSortLabel|yes"
                        .

      IF SEARCH("jboxstartup_hook6.r") NE ? THEN
        RUN jboxstartup_hook6.r.

      RUN jboxappstart.p (bTest,
                      cAppTitle,
                      REPLACE(cLanguages,",","|"),
                      cBaseLanguage,
                      cPrefLanguage,
                      cBehaviour,
                      cUserId,
                      cRoot
                      ).

      cPrefUser = DYNAMIC-FUNCTION("getASuserid") NO-ERROR.
  
      IF ERROR-STATUS:GET-MESSAGE(1) = "" THEN DO:
        OUTPUT TO VALUE(cRoot + "preferences.txt").
        PUT UNFORMATTED "language¤"    + DYNAMIC-FUNCTION("getLanguageCode") SKIP
                        "userid¤"      + DYNAMIC-FUNCTION("getASuserid") SKIP
                        "behaviour¤"   + DYNAMIC-FUNCTION("getBehaviour") SKIP
                        "date-format¤" + SESSION:DATE-FORMAT SKIP
                        "num-format¤"  + SESSION:NUMERIC-FORMAT SKIP
                        .
        OUTPUT CLOSE.
      END.  

    END.
    ELSE 
      MESSAGE "Application unavailable" VIEW-AS ALERT-BOX ERROR.
  END.
  ELSE DO:
    IF SEARCH("jboxstartup_hook7.r") NE ? THEN
      RUN jboxstartup_hook7.r.

    OUTPUT TO .\restart.bat.
    PUT UNFORMATTED "@ECHO OFF" SKIP.
    IF bWcUpgrade THEN DO:
      IF SEARCH(".\new_webclient\bin\sleep.exe") NE ? THEN
        PUT UNFORMATTED ".\new_webclient\bin\sleep 2" SKIP.
      PUT UNFORMATTED "DEL /Q .\WebClient\bin\*.*" SKIP.
      PUT UNFORMATTED "DEL /Q .\WebClient\*.*" SKIP.
      PUT UNFORMATTED "COPY /Y .\new_webclient\bin\*.* .\WebClient\bin" SKIP.
      PUT UNFORMATTED "COPY /Y .\new_webclient\*.* .\WebClient" SKIP.
      PUT UNFORMATTED "RMDIR /S /Q .\new_webclient" SKIP.
    END.
    IF bViperUpgrade THEN DO:
      PUT UNFORMATTED "DEL /Q .\Viper\*.*" SKIP.
      PUT UNFORMATTED "COPY /Y .\new_viper\*.* .\Viper" SKIP.
      PUT UNFORMATTED "RMDIR /S /Q .\new_viper" SKIP.
    END.
    IF bAUIUpgrade THEN DO:
      PUT UNFORMATTED "DEL /Q .\Assemblies\*.*" SKIP.
      PUT UNFORMATTED "COPY /Y .\new_assemblies\*.* .\Assemblies" SKIP.
      PUT UNFORMATTED "RMDIR /S /Q .\new_assemblies" SKIP.
    END.
    PUT UNFORMATTED ".\WebClient\bin\prowc.exe -basekey ini -pf startup.pf -T " + SESSION:TEMP-DIR SKIP.
    PUT UNFORMATTED "EXIT" SKIP.
    OUTPUT CLOSE.
        
    IF cVirtualStore NE "" THEN DO:
      OS-DELETE VALUE(cVirtualStore + "WebClient_Upgrade_Warning.txt") NO-ERROR.
      OS-DELETE VALUE(cVirtualStore + "Upgrade_Warning_Message.txt") NO-ERROR.  
    END.

    OS-COMMAND NO-WAIT VALUE("CMD /C .\restart.bat").
    QUIT.
  END.
END.
ELSE MESSAGE "Application unavailable (missing signature file)" VIEW-AS ALERT-BOX ERROR.
  
IF SEARCH("jboxstartup_hook8.r") NE ? THEN
  RUN jboxstartup_hook8.r.

/* Housekeeping: */
INPUT FROM OS-DIR(SESSION:TEMP-DIRECTORY).
REPEAT:
  IMPORT cOSfile.
  IF cOSfile BEGINS "lbi0" 
     OR cOSfile BEGINS "srt0"
     OR cOSfile BEGINS "DBI0"
     OR cOSfile MATCHES "*.jpg"
     OR cOSfile MATCHES "*.bmp"
     OR cOSfile MATCHES "*.tif"
     OR cOSfile MATCHES "*.txt"
     OR cOSfile MATCHES "*.pdf"
     OR cOSfile MATCHES "*.doc"
     OR cOSfile MATCHES "*.csv"
     OR cOSfile MATCHES "*.tmp"
     THEN DO:

    ASSIGN cOSfile = SESSION:TEMP-DIRECTORY + cOSfile
           FILE-INFO:FILE-NAME = cOSfile
           . 

    IF FILE-INFO:FILE-MOD-DATE LT TODAY - 5 THEN
      OS-DELETE VALUE(cOSfile) NO-ERROR.
  END.
END.
INPUT CLOSE.

IF SEARCH("jboxstartup_hook9.r") NE ? THEN
  RUN jboxstartup_hook9.r.

IF NOT bTest THEN QUIT.
/*
IF bTest THEN DO:
  ASSIGN hNewAppservice = DYNAMIC-FUNCTION("getAppServiceHandle")
         PROPATH = cOrgProPath.
  hNewAppservice:DISCONNECT() NO-ERROR.
  DYNAMIC-FUNCTION("setAppserviceHandle",hOldAppservice).
  DYNAMIC-FUNCTION("setSessionId",cOldSessionId).
END.
ELSE QUIT.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-ChunkDownload) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ChunkDownload Procedure 
PROCEDURE ChunkDownload :
/*------------------------------------------------------------------------------
  Purpose:     Analyse a download of docs if files need to be chunked or batched in a number of files at a time  
  Parameters:  <none>
  Notes:       Done to get past timeout limits and bugs in the java classes used by Aia
------------------------------------------------------------------------------*/
DEF INPUT PARAM  icPackageId AS CHAR NO-UNDO.
DEF INPUT PARAM  icSaveDir   AS CHAR NO-UNDO.
DEF OUTPUT PARAM obChunk     AS LOG  NO-UNDO.
DEF OUTPUT PARAM obChunkOk   AS LOG  NO-UNDO.

DEF VAR hTempTable     AS HANDLE NO-UNDO.
DEF VAR hTempBuffer    AS HANDLE NO-UNDO.
DEF VAR hTempQuery     AS HANDLE NO-UNDO.
DEF VAR iTotSmallSize  AS INT    NO-UNDO.
DEF VAR iTotSize       AS INT    NO-UNDO.
DEF VAR iSizeLimit     AS INT    NO-UNDO INIT 10000000.
DEF VAR iCount         AS INT    NO-UNDO.
DEF VAR iStartDocBatch AS INT    NO-UNDO.
DEF VAR cOutFile       AS CHAR   NO-UNDO.
DEF VAR bUseOrgName    AS LOG    NO-UNDO.
DEF VAR mpTarget       AS MEMPTR NO-UNDO.
DEF VAR iDocsize       AS INT    NO-UNDO.
DEF VAR iStartChunk    AS INT    NO-UNDO.
DEF VAR iChunkSize     AS INT    NO-UNDO.
DEF VAR cChunkFileName AS CHAR   NO-UNDO.
DEF VAR cReturn        AS CHAR   NO-UNDO.

SESSION:SET-WAIT-STATE("general").

IF VALID-HANDLE(hServer) THEN DO:
  RUN jbdoc_getdocinfo.p
      ON hServer
     (cSessionId,
      "JBoxPackage|" + icPackageId,
      OUTPUT TABLE-HANDLE hTempTable,
      OUTPUT cReturn,
      OUTPUT bOk)
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "File-list unavaliable for package: " STRING(icPackageId )
            VIEW-AS ALERT-BOX ERROR.
    RETURN.
  END.
END.
ELSE 
  RUN jbdoc_getdocinfo.p
     (cSessionId,
      "JBoxPackage|" + icPackageId,
      OUTPUT TABLE-HANDLE hTempTable,
      OUTPUT cReturn,
      OUTPUT bOk).

EMPTY TEMP-TABLE ttDocInfo.

hTempBuffer = hTempTable:DEFAULT-BUFFER-HANDLE.
CREATE QUERY hTempQuery.
hTempQuery:SET-BUFFERS(hTempBuffer).
hTempQuery:QUERY-PREPARE("FOR EACH " + hTempBuffer:NAME).
hTempQuery:QUERY-OPEN().
hTempQuery:GET-FIRST().

REPEAT WHILE NOT hTempQuery:QUERY-OFF-END:
  CREATE ttDocInfo.
  httDocInfoBuf:BUFFER-COPY(hTempBuffer).

  IF hTempBuffer:BUFFER-FIELD("iDocSize"):BUFFER-VALUE > iSizeLimit THEN
    ttDocInfo.cCat = "big".

  ASSIGN iTotSize = iTotSize + hTempBuffer:BUFFER-FIELD("iDocSize"):BUFFER-VALUE
         iCount   = iCount + 1.

  hTempQuery:GET-NEXT().
END.

/* Now we know if the total download exceeds max in one call
   and the single files that exceeds max. */

IF iTotSize > iSizeLimit THEN DO:
  ASSIGN bChunkInProgress = YES
         obChunk          = YES
         .
  IF icSaveDir = "" THEN icSaveDir = SESSION:TEMP-DIR.
  ELSE 
    ASSIGN icSaveDir   = TRIM(icSaveDir,"\") + "\"
           bUseOrgName = TRUE.

  /* First process the files under size limit in batches that are less than limit - 
     Approximately: Includes the current doc that is the one that pushes over the limit: */  

  FOR EACH ttDocInfo
      WHERE ttDocInfo.cCat NE "big"
      BY ttDocInfo.iJBoxDocumentId:
    iTotSmallSize = iTotSmallSize + ttDocInfo.iDocSize.

    IF iTotSmallSize > iSizeLimit THEN DO:
      bChunkInProgress = YES.
      obChunkOk = InstallPackage(
                  icPackageId
                + "||"
                + STRING(iStartDocBatch) + "¤" + STRING(ttDocInfo.iJBoxDocumentId) + "¤" + STRING(iSizeLimit),
                  icSaveDir).      
      ASSIGN iStartDocBatch = ttDocInfo.iJBoxDocumentId
             iTotSmallSize  = 0.
    END.
  END.
  IF iTotSmallSize > 0 THEN DO:      
    bChunkInProgress = YES.
    obChunkOk = InstallPackage(
               icPackageId
              + "||"
              + STRING(iStartDocBatch) + "¤999999999¤" + STRING(iSizeLimit),
                icSaveDir).      
  END.

  /* Now process the documents exceeding max size indivdually by chunks: */

  DELETE OBJECT hTempTable NO-ERROR.  
  FOR EACH ttDocInfo
      WHERE ttDocInfo.cCat = "big"
      BY ttDocInfo.iJBoxDocumentId:

    ASSIGN iChunkSize       = iSizeLimit
           iStartChunk      = 1
           ix               = 0
           .

    SET-SIZE(mpTarget) = 0.
    SET-SIZE(mpTarget) = ttDocInfo.iDocSize.
    
    GetChunks:
    REPEAT:
      ASSIGN iChunkSize = MIN(ttDocInfo.iDocSize - iStartChunk + 1,iChunkSize)
             ix = ix + 1.
      IF VALID-HANDLE(hServer) THEN 
        RUN jbdoc_getdocchunk.p
            ON hServer
           (cSessionId,
            ttDocInfo.iJBoxDocumentId,
            iChunkSize,
            iStartChunk,
            OUTPUT TABLE-HANDLE hTempTable,
            OUTPUT iDocsize,
            OUTPUT cChunkFileName,  /* Same as ttDocInfo.cFileName */
            OUTPUT cReturn,
            OUTPUT bOk)
            NO-ERROR.
      ELSE 
        RUN jbdoc_getdocchunk.p
           (cSessionId,
            ttDocInfo.iJBoxDocumentId,
            iChunkSize,
            iStartChunk,
            OUTPUT TABLE-HANDLE hTempTable,
            OUTPUT iDocsize,
            OUTPUT cChunkFileName,
            OUTPUT cReturn,
            OUTPUT bOk).

      IF ix > 100 OR NOT bOk THEN DO:
        IF NOT bOk THEN
          MESSAGE PROGRAM-NAME(1) SKIP
                  cReturn VIEW-AS ALERT-BOX ERROR.
        DELETE OBJECT hTempTable NO-ERROR.  
        SET-SIZE(mpTarget) = 0.
        RETURN.
      END.

      hTempBuffer = hTempTable:DEFAULT-BUFFER-HANDLE.
      bOk = hTempBuffer:FIND-FIRST() NO-ERROR.
      IF bOk THEN DO:
        COPY-LOB FROM OBJECT hTempBuffer:BUFFER-FIELD("blChunk"):BUFFER-VALUE                 
                 TO OBJECT mpTarget
                 OVERLAY AT iStartChunk
                 NO-ERROR.
        IF ERROR-STATUS:ERROR THEN DO:
          SET-SIZE(mpTarget) = ttDocInfo.iDocSize + 1.
          COPY-LOB FROM OBJECT hTempBuffer:BUFFER-FIELD("blChunk"):BUFFER-VALUE                 
                   TO OBJECT mpTarget
                   OVERLAY AT iStartChunk
                   NO-ERROR.
          IF ERROR-STATUS:ERROR THEN DO:
            MESSAGE ERROR-STATUS:GET-MESSAGE(1) SKIP
                   "iDocsize: " iDocsize SKIP
                   "ttDocInfo.iDocSize: " ttDocInfo.iDocSize SKIP
                   "iChunkSize: " iChunkSize SKIP
                   "iStartChunk: " iStartChunk SKIP
                   "GET-SIZE(mpTarget): " GET-SIZE(mpTarget) SKIP(1)
                   "Upgrade failed. Report this error to Sys.admin"
                VIEW-AS ALERT-BOX INFO BUTTONS OK.
            RETURN.
          END.
        END.

        iStartChunk = iStartChunk + iChunkSize.

        IF iStartChunk > iDocSize THEN DO:

          IF NOT CreateInstallDir(icSaveDir) THEN QUIT.
          icSaveDir = TRIM(icSaveDir,"\") + "\".
/* /*           OS-COMMAND SILENT mkdir VALUE('"' + icSaveDir + '"').  */                   */
/*                                                                                          */
/*           OS-CREATE-DIR VALUE(icSaveDir).                                                */
/*           iOsError = OS-ERROR.                                                           */
/*           IF iOsError NE 0 THEN DO:                                                      */
/*             MESSAGE "Cannot create directory " icSaveDir SKIP                            */
/*                     "Check your permissions or try running the program as administrator" */
/*                     VIEW-AS ALERT-BOX ERROR.                                             */
/*             QUIT.                                                                        */
/*           END.                                                                           */

          OUTPUT STREAM strFile TO VALUE(icSaveDir + cChunkFileName) NO-MAP BINARY NO-CONVERT.
          EXPORT STREAM strFile mpTarget.
          OUTPUT STREAM strFile CLOSE.

          DELETE OBJECT hTempTable NO-ERROR.  
          LEAVE GetChunks.
        END.
      END.
    END.
    DELETE OBJECT hTempTable NO-ERROR.  
  END.
  SET-SIZE(mpTarget) = 0.
END.

ELSE obChunk = NO.

SESSION:SET-WAIT-STATE("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-GetUpdates) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetUpdates Procedure 
PROCEDURE GetUpdates :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR fTotSize         AS DEC    NO-UNDO.
DEF VAR hRectangle       AS HANDLE NO-UNDO.
DEF VAR ix               AS INT    NO-UNDO.

httPackagesBuffer = httPackages:DEFAULT-BUFFER-HANDLE.
CREATE QUERY httPackagesQuery NO-ERROR.
httPackagesQuery:SET-BUFFERS(httPackagesBuffer) NO-ERROR.
httPackagesQuery:QUERY-PREPARE("FOR EACH " + httPackagesBuffer:NAME 
                               + " WHERE cSignature GT '" + ENTRY(2,cSignature,"|") + "'"
                               + " BY iInstallSeq").
httPackagesQuery:QUERY-OPEN.

iNumPackages = 0.
httPackagesQuery:GET-FIRST().
REPEAT WHILE NOT httPackagesQuery:QUERY-OFF-END:
  ASSIGN iNumPackages = iNumPackages + 1
         fTotSize     = fTotSize + httPackagesBuffer:BUFFER-FIELD("fTotSize"):BUFFER-VALUE
         .
  httPackagesQuery:GET-NEXT().
END.

IF fTotSize > 100 THEN DO:
  CREATE WINDOW hWindow
         ASSIGN CONTROL-BOX   = FALSE
                STATUS-AREA   = FALSE
                MESSAGE-AREA  = FALSE
                X             = SESSION:WIDTH-PIXELS / 2 - 88
                Y             = SESSION:HEIGHT-PIXELS / 2 - iNumPackages * 20 / 2
                WIDTH-PIXELS  = 170
                HEIGHT-PIXELS = iNumPackages * 20 + 2
                VISIBLE       = YES
                TITLE         = "Getting upgrade packages"
                TOP-ONLY      = YES
                .
  
  CREATE FRAME hBgFrame
         ASSIGN PARENT        = hWindow
                SCROLLABLE    = NO
                FONT          = 0
                X             = 0
                Y             = 0
                WIDTH-PIXELS  = hWindow:WIDTH-PIXELS
                HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS
                VISIBLE       = YES                
                SENSITIVE     = FALSE
                BGCOLOR       = 7
                .

  CREATE FRAME hFrame
         ASSIGN PARENT        = hWindow
                SCROLLABLE    = NO
                FONT          = 0
                X             = hWindow:WIDTH-PIXELS / 2 - 35
                Y             = 0
                WIDTH-PIXELS  = 70
                HEIGHT-PIXELS = hWindow:HEIGHT-PIXELS
                VISIBLE       = YES                
                SENSITIVE     = TRUE
                BGCOLOR       = 8
                .
END.

ix = 0.
httPackagesQuery:GET-FIRST().
REPEAT WHILE NOT httPackagesQuery:QUERY-OFF-END:
  IF fTotSize > 100 THEN
    CREATE RECTANGLE hRectangle
           ASSIGN FRAME         = hFrame
                  X             = RANDOM(1,hFrame:WIDTH-PIXELS - 52)
                  Y             = MAX(0,hFrame:HEIGHT-PIXELS - hFrame:HEIGHT-PIXELS / iNumPackages - ix * 20 - 1)
                  WIDTH-PIXELS  = 49
                  HEIGHT-PIXELS = 19
                  FILLED        = YES
                  VISIBLE       = YES
                  BGCOLOR       = RANDOM(9,15)
                  .
  ix = ix + 1.        

  IF httPackagesBuffer:BUFFER-FIELD("bComplete"):BUFFER-VALUE THEN 
    CleanUpDir(cRoot + LEFT-TRIM(httPackagesBuffer:BUFFER-FIELD("cRelativePath"):BUFFER-VALUE,".\")).

  IF httPackagesBuffer:BUFFER-FIELD("bRestart"):BUFFER-VALUE THEN
    bRestart = TRUE.

  InstallPackage(STRING(httPackagesBuffer:BUFFER-FIELD("iJBoxPackageId"):BUFFER-VALUE),
                 cRoot + LEFT-TRIM(httPackagesBuffer:BUFFER-FIELD("cRelativePath"):BUFFER-VALUE,".\")
                 ).
  IF httPackagesBuffer:BUFFER-FIELD("cSignature"):BUFFER-VALUE > cLatestPackage THEN
    cLatestPackage = httPackagesBuffer:BUFFER-FIELD("cSignature"):BUFFER-VALUE.
  httPackagesQuery:GET-NEXT().
  PROCESS EVENTS.
END.
  
OUTPUT TO VALUE(cRoot + "signature.txt").
PUT UNFORMATTED ENTRY(1,cSignature,"|") + "|" + cLatestPackage + "|" + cAppTitle + "|" + cLanguages + "|" + cBaseLanguage SKIP.
OUTPUT CLOSE.

IF NOT bRestart THEN DO:
  httPackagesQuery:QUERY-PREPARE("FOR EACH " + httPackagesBuffer:NAME 
                                 + " WHERE bProPath"
                                 + " BY iProPathSeq").
  httPackagesQuery:QUERY-OPEN.
  httPackagesQuery:GET-FIRST().
  
  /* cProPath = PROPATH. */
  REPEAT WHILE NOT httPackagesQuery:QUERY-OFF-END:
    cProPath = cProPath + 
               cRoot + LEFT-TRIM(httPackagesBuffer:BUFFER-FIELD("cRelativePath"):BUFFER-VALUE,".\") + ";".
    httPackagesQuery:GET-NEXT().
  END.
  
  PROPATH = cProPath + PROPATH.
  OUTPUT TO VALUE(cRoot + "propath.txt").
  PUT UNFORMATTED cProPath SKIP.
  OUTPUT CLOSE.
END.

DELETE OBJECT httPackagesQuery.
DELETE OBJECT httPackages.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RenameFiles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RenameFiles Procedure 
PROCEDURE RenameFiles :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM icCat AS CHAR NO-UNDO.

DEF VAR cTmpFileName     AS CHAR NO-UNDO.
DEF VAR cTmpFileFullName AS CHAR NO-UNDO.
DEF VAR cNewName         AS CHAR NO-UNDO.
DEF VAR cNewFullName     AS CHAR NO-UNDO.
DEF VAR cReplaceString   AS CHAR NO-UNDO.
DEF VAR cDirList         AS CHAR NO-UNDO.
DEF VAR ix               AS INT  NO-UNDO.

FILE-INFO:FILE-NAME = icCat.
IF FILE-INFO:FULL-PATHNAME = ? THEN RETURN.

IF VALID-HANDLE(hWindow) AND LENGTH(hWindow:TITLE) < 35 THEN hWindow:TITLE = hWindow:TITLE + ".".

INPUT FROM OS-DIR(icCat).
REPEAT:
  IMPORT cTmpFileName.
  FILE-INFO:FILE-NAME = RIGHT-TRIM(icCat,"\") + "\" + cTmpFileName.
  cTmpFileFullName = FILE-INFO:FULL-PATHNAME.
  IF cTmpFileName BEGINS "." THEN NEXT.

  IF FILE-INFO:FILE-TYPE = "drw" THEN DO:
    cDirList = cDirList + (IF cDirList NE "" THEN "," ELSE "") + cTmpFileFullName.
    NEXT.
  END.

  bOk = FALSE.
  DO ix = 1 TO NUM-ENTRIES(cRenamePattern):
    IF cTmpFileName MATCHES ENTRY(1,ENTRY(ix,cRenamePattern),";") THEN DO:
      ASSIGN cReplaceString = REPLACE(ENTRY(1,ENTRY(ix,cRenamePattern),";"),"*","")
             cNewName = REPLACE(cTmpFileName,cReplaceString,ENTRY(2,ENTRY(ix,cRenamePattern),";"))  
             FILE-INFO:FILE-NAME = cNewName
             cNewFullName = REPLACE(cTmpFileFullName,cTmpFileName,cNewName)
             .
  
      OS-RENAME VALUE(cTmpFileFullName) VALUE(cNewFullName).
    END.
  END.
END.
INPUT CLOSE.

DO ix = 1 TO NUM-ENTRIES(cDirList):
  RUN RenameFiles(ENTRY(ix,cDirList)).
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CheckIfAdmin) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckIfAdmin Procedure 
FUNCTION CheckIfAdmin RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cInput AS CHAR NO-UNDO.
DEF VAR bAdmin AS LOG  NO-UNDO.
OS-COMMAND SILENT VALUE("whoami /groups /fo csv /nh > " + SESSION:TEMP-DIRECTORY + "whoami.txt").
INPUT FROM VALUE(SESSION:TEMP-DIRECTORY + "whoami.txt").
REPEAT:
  IMPORT UNFORMATTED cInput.
  IF CAN-DO(cInput,'"S-1-16-12288"') THEN DO:
    bAdmin = YES.
    LEAVE.
  END. 
END.
INPUT CLOSE.
RETURN bAdmin.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CleanUpDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CleanUpDir Procedure 
FUNCTION CleanUpDir RETURNS LOGICAL
  ( INPUT icCleanUpDir AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
icCleanUpDir = TRIM(icCleanUpDir,"\").

FILE-INFO:FILE-NAME = icCleanUpDir.
IF FILE-INFO:FILE-TYPE = ? THEN DO:
  OS-COMMAND SILENT mkdir VALUE('"' + icCleanUpDir + '"').
  FILE-INFO:FILE-NAME = icCleanUpDir.
  IF FILE-INFO:FILE-TYPE = ? THEN RETURN NO.
END.
INPUT FROM OS-DIR(icCleanUpDir) CONVERT TARGET "UTF-8" SOURCE "ISO8859-1".
icCleanUpDir = TRIM(icCleanUpDir,"\") + "\".
REPEAT:
  IMPORT cOSfile NO-ERROR.
  IF cOSfile NE ".." THEN
    OS-DELETE VALUE(icCleanUpDir + cOSfile) NO-ERROR.
END.
INPUT CLOSE.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ConnectAppFarm) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION ConnectAppFarm Procedure 
FUNCTION ConnectAppFarm RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
IF bTest AND PROGRESS = "Full" THEN RETURN TRUE.

{incl/startupconnect.i}
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CreateInstallDir) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CreateInstallDir Procedure 
FUNCTION CreateInstallDir RETURNS LOGICAL
  ( INPUT icSaveDir AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cDirComp AS CHAR NO-UNDO.
DEF VAR cTmp     AS CHAR NO-UNDO.
DEF VAR ix       AS INT  NO-UNDO.

icSaveDir = TRIM(icSaveDir,"\").

FILE-INFO:FILE-NAME = icSaveDir.
IF FILE-INFO:FILE-TYPE = "drw" THEN RETURN YES.

OS-COMMAND SILENT mkdir VALUE('"' + icSaveDir + '"').
FILE-INFO:FILE-NAME = icSaveDir.
IF FILE-INFO:FILE-TYPE = ? THEN DO:
  MESSAGE "Cannot create directory " icSaveDir SKIP
          "Check your permissions or try running the program as administrator"
          VIEW-AS ALERT-BOX ERROR.
  RETURN NO.
END.

/*
DO ix = 1 TO NUM-ENTRIES(icSaveDir,"\"):
  cTmp = cTmp + (IF cTmp NE "" THEN "\" ELSE "") + ENTRY(ix,icSaveDir,"\").
  IF LENGTH(TRIM(cTmp,"\") + "\") > LENGTH(cRoot) THEN DO:
    cDirComp = cDirComp + (IF cDirComp NE "" THEN "\" ELSE "") + ENTRY(ix,icSaveDir,"\").
                                                             
    OS-CREATE-DIR VALUE(cDirComp).
    iOsError = OS-ERROR.
    IF iOsError NE 0 THEN DO:
      MESSAGE "Cannot create directory " icSaveDir SKIP
              "Check your permissions or try running the program as administrator"
              VIEW-AS ALERT-BOX ERROR.
      RETURN NO.
    END.
  END.
END.
*/

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPackageList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPackageList Procedure 
FUNCTION getPackageList RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
bOK = SESSION:SET-WAIT-STATE("general").

IF VALID-HANDLE(hServer) THEN DO:
  RUN jbappfarm_get_package_list.p
      ON hServer
     (ENTRY(1,cSignature,"|"),
      OS-GETENV("COMPUTERNAME"),
      OS-GETENV("USERNAME"),
      OUTPUT TABLE-HANDLE httPackages,
      OUTPUT cReturnTrans,
      OUTPUT cSessionId)
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "Package list unavaliable for signature: " cSignature 
            VIEW-AS ALERT-BOX ERROR.
    RETURN FALSE.
  END.
END.
ELSE 
  RUN jbappfarm_get_package_list.p
     (ENTRY(1,cSignature,"|"),
      OS-GETENV("COMPUTERNAME"),
      OS-GETENV("USERNAME"),
      OUTPUT TABLE-HANDLE httPackages,
      OUTPUT cReturnTrans,
      OUTPUT cSessionId)
      .

bOK = SESSION:SET-WAIT-STATE("").

IF cSessionId NE "" THEN DO:
  ASSIGN cAppTitle     = ENTRY(1,cReturnTrans,"|")
         cLanguages    = ENTRY(2,cReturnTrans,"|")
         cBaseLanguage = ENTRY(3,cReturnTrans,"|")
         .
  RETURN TRUE.
END.
ELSE DO:
  MESSAGE cReturnTrans VIEW-AS ALERT-BOX WARNING.
  RETURN FALSE.
END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getVirtualStore) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getVirtualStore Procedure 
FUNCTION getVirtualStore RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR cVirtualRoot  AS CHAR NO-UNDO.
DEF VAR cStartDir     AS CHAR NO-UNDO.

FILE-INFO:FILE-NAME = cRoot.
cStartDir = FILE-INFO:FULL-PATHNAME.

IF OS-GETENV("localappdata") NE ? THEN DO:
  cVirtualRoot = OS-GETENV("localappdata").
  FILE-INFO:FILE-NAME = cVirtualRoot + RIGHT-TRIM("\VirtualStore" + SUBSTR(cStartDir,INDEX(cStartDir,"\")),"\") + "\".
  IF FILE-INFO:FILE-TYPE = "drw" THEN
    RETURN FILE-INFO:FULL-PATHNAME.
END.
ELSE IF OS-GETENV("allusersprofile") NE ? THEN DO:
  cVirtualRoot = OS-GETENV("allusersprofile").
  FILE-INFO:FILE-NAME = cVirtualRoot + RIGHT-TRIM("\VirtualStore" + SUBSTR(cStartDir,INDEX(cStartDir,"\")),"\") + "\".
  IF FILE-INFO:FILE-TYPE = "drw" THEN
    RETURN FILE-INFO:FULL-PATHNAME.
END.

RETURN "".

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InstallPackage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION InstallPackage Procedure 
FUNCTION InstallPackage RETURNS LOGICAL
  ( INPUT icPackageId AS CHAR,
    INPUT icSaveDir   AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
DEF VAR hTempTable  AS HANDLE NO-UNDO.
DEF VAR hTempBuffer AS HANDLE NO-UNDO.
DEF VAR hTempQuery  AS HANDLE NO-UNDO.
DEF VAR cOutFile    AS CHAR   NO-UNDO.
DEF VAR mpDocument  AS MEMPTR NO-UNDO.
DEF VAR bChunk      AS LOG    NO-UNDO.
DEF VAR bChunkOk    AS LOG    NO-UNDO.

IF NOT bChunkInProgress THEN DO:
  RUN ChunkDownload(icPackageId,icSaveDir,OUTPUT bChunk,OUTPUT bChunkOk).
  IF bChunk THEN 
    RETURN bChunkOk.
END.

bChunkInProgress = NO.

bOK = SESSION:SET-WAIT-STATE("general").

IF VALID-HANDLE(hServer) THEN DO:
  RUN jbdoc_getdoc.p
      ON hServer
     (cSessionId,
      "JBoxPackage|" + icPackageId,
      OUTPUT TABLE-HANDLE hTempTable,
      OUTPUT cReturnTrans,
      OUTPUT bOk)
      NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE "File-list unavaliable for package: " icPackageId 
            VIEW-AS ALERT-BOX ERROR.
    RETURN FALSE.
  END.
END.
ELSE 
  RUN jbdoc_getdoc.p
     (cSessionId,
      "JBoxPackage|" + icPackageId,
      OUTPUT TABLE-HANDLE hTempTable,
      OUTPUT cReturnTrans,
      OUTPUT bOk)
      .

IF NOT CreateInstallDir(icSaveDir) THEN QUIT.
icSaveDir = TRIM(icSaveDir,"\") + "\".
/* /* OS-COMMAND SILENT mkdir VALUE('"' + icSaveDir + '"'). */                    */
/* OS-CREATE-DIR VALUE(icSaveDir).                                                */
/* iOsError = OS-ERROR.                                                           */
/* IF iOsError NE 0 THEN DO:                                                      */
/*   MESSAGE "Cannot create directory " icSaveDir SKIP                            */
/*           "Check your permissions or try running the program as administrator" */
/*           VIEW-AS ALERT-BOX ERROR.                                             */
/*   QUIT.                                                                        */
/* END.                                                                           */


hTempBuffer = hTempTable:DEFAULT-BUFFER-HANDLE.
CREATE QUERY hTempQuery.
hTempQuery:SET-BUFFERS(hTempBuffer).
hTempQuery:QUERY-PREPARE("FOR EACH " + hTempBuffer:NAME + " BY cFileType DESC"). /* So that .bat files comes last */
hTempQuery:QUERY-OPEN().
hTempQuery:GET-FIRST().

REPEAT WHILE NOT hTempQuery:QUERY-OFF-END:
  cOutFile = icSaveDir + hTempBuffer:BUFFER-FIELD("cFileName"):BUFFER-VALUE.
  SET-SIZE(mpDocument) = hTempBuffer:BUFFER-FIELD('iDocSize'):BUFFER-VALUE.
  COPY-LOB FROM OBJECT hTempBuffer:BUFFER-FIELD('blDocument'):BUFFER-VALUE TO OBJECT mpDocument NO-ERROR.
  IF ERROR-STATUS:ERROR THEN DO:
    MESSAGE ERROR-STATUS:GET-MESSAGE(1) SKIP
            hTempBuffer:BUFFER-FIELD('iDocSize'):BUFFER-VALUE SKIP(1)
            "Upgrade failed. Report this error to sys.admin"
            VIEW-AS ALERT-BOX INFO BUTTONS OK.
    RETURN NO.
  END.
  OUTPUT STREAM strFile TO VALUE(cOutFile) NO-MAP BINARY NO-CONVERT.
  EXPORT STREAM strFile mpDocument.
  OUTPUT STREAM strFile CLOSE.

  IF hTempBuffer:BUFFER-FIELD('cFileType'):BUFFER-VALUE = "bat" AND NOT cOutFile MATCHES "*webclient*" THEN
    OS-COMMAND SILENT VALUE(cOutFile).

  hTempQuery:GET-NEXT().
END.

DELETE OBJECT hTempQuery.
DELETE OBJECT hTempTable.
SET-SIZE(mpDocument) = 0.

bOK = SESSION:SET-WAIT-STATE("").

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setVariable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setVariable Procedure 
FUNCTION setVariable RETURNS LOGICAL
  ( INPUT icVarName AS CHAR,
    INPUT icValue   AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
CASE icVarName:
  WHEN "cRenamePattern" THEN cRenamePattern = icValue.
END CASE.

RETURN YES.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

