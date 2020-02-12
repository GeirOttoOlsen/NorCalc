 
/*------------------------------------------------------------------------
   File        : JBoxCompile
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : goo_000
   Created     : Wed Nov 09 09:41:24 CET 2016
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.DataAdmin.ISequence FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxCompile: 
  DEFINE STREAM stIn.
      
  DEFINE TEMP-TABLE ttDirectory NO-UNDO
    FIELD iDirectorySeq    AS INTEGER
    FIELD cSourceDirectory AS CHARACTER 
    FIELD cTargetDirectory AS CHARACTER 
    INDEX iDirectorySeq IS PRIMARY UNIQUE iDirectorySeq
    .
  DEFINE TEMP-TABLE ttFile NO-UNDO 
    FIELD iFileSeq      AS INTEGER
    FIELD iDirectorySeq AS INTEGER
    FIELD cFileName     AS CHARACTER FORMAT 'X(72)'
    FIELD cFullFileName AS CHARACTER FORMAT 'X(72)'
    FIELD cFileExtent   AS CHARACTER  
    FIELD bCompiled     AS LOG
    FIELD cFileStatus   AS CHARACTER FORMAT "x(72)"
       
    INDEX iFileSeq IS PRIMARY UNIQUE iFileSeq
    INDEX iDirectorySeq              iDirectorySeq
    .  

  DEFINE DATASET dsCompile 
    FOR ttDirectory, ttFile
    DATA-RELATION relttDirectory FOR ttDirectory, ttFile RELATION-FIELDS(iDirectorySeq,iDirectorySeq).

  define temp-table ttLog no-undo
    field iLogSeq as int 
    field SourceFilename as char
    field RcodeDirectory as char
    field CopyDirectory as char
    field ErrorMessage as char
    field Created as datetime
    index iLogSeq is primary unique iLogSeq
    index SourceFilename SourceFilename
    .

  DEFINE VARIABLE iSequence AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cTmp      AS CHARACTER NO-UNDO.
    
  DEFINE PUBLIC PROPERTY TargetPath AS CHARACTER NO-UNDO 
    GET.
    SET. 
  DEFINE PUBLIC PROPERTY SourcePath AS CHARACTER NO-UNDO 
    GET.
    SET. 

  DEFINE PUBLIC PROPERTY ttDirecotry AS HANDLE NO-UNDO 
    GET():
      RETURN TEMP-TABLE ttDirectory:HANDLE.  
    END GET.
    SET. 

  DEFINE PUBLIC PROPERTY ttFile AS HANDLE NO-UNDO 
    GET():
      RETURN TEMP-TABLE ttFile:HANDLE.  
    END GET.
    SET. 

  DEFINE PUBLIC PROPERTY ttLog AS HANDLE NO-UNDO 
    GET():
      RETURN TEMP-TABLE ttLog:HANDLE.  
    END GET.
    SET. 

  DEFINE PUBLIC PROPERTY dsCompile AS HANDLE NO-UNDO 
    GET():
      RETURN DATASET dsCompile:HANDLE.  
    END GET.
    SET. 
    
  DEFINE PUBLIC PROPERTY LogFile AS CHARACTER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY LogSeq AS int NO-UNDO GET. SET.

  DEFINE PUBLIC PROPERTY Logg AS LONGCHAR NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY copyToDirectory AS CHARACTER NO-UNDO 
  GET. SET(ipvalue as char): 
    ipValue = replace(ipValue,'/','\').
    IF NOT SUBSTRING(ipValue,LENGTH(ipValue),1) = '\' THEN ipValue = ipValue + '\'.
    copyToDirectory = ipValue.
  end.
  DEFINE PUBLIC PROPERTY RCODEDIR AS CHARACTER NO-UNDO      
  GET. SET(ipvalue as char): 
    ipValue = replace(ipValue,'/','\').
    IF NOT SUBSTRING(ipValue,LENGTH(ipValue),1) = '\' THEN ipValue = ipValue + '\'.
    RCODEDIR = ipValue.
  end.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
		
  CONSTRUCTOR PUBLIC JBoxCompile (INPUT icLogFile AS CHARACTER, INPUT iiLogLevel AS INTEGER  ):
    SUPER ().
		  
    /*		LOG-MANAGER:LOGFILE-NAME  = icLogFile.       */
    /*        log-manager:LOGGING-LEVEL = iiLogLevel.*/
    THIS-OBJECT:LogFile = icLogFile.
    CREATE ttFile.
    ASSIGN
      iSequence            = iSequence + 1 
      ttFile.iFileSeq      = iSequence
      ttFile.cFileName     = ''
      ttFile.cFileExtent   = ''
      ttFile.bCompiled     = ?
      ttFile.iDirectorySeq = ?
      .           
		
    CATCH e AS Progress.Lang.Error:

    END CATCH.

    FINALLY:

    END FINALLY.

  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL addDirectory( INPUT icSourceDirectory AS CHARACTER, INPUT icTargetDirectory AS CHARACTER ):
    assign 
      icTargetDirectory = REPLACE(icTargetDirectory,'/','\')
      icTargetDirectory = replace(icTargetDirectory,'.\','')
      icTargetDirectory = RCODEDIR + icTargetDirectory
      .
    
    IF NOT SUBSTRING(icTargetDirectory,LENGTH(icTargetDirectory),1) = '\' THEN icTargetDirectory = icTargetDirectory + '\'.

    CREATE ttDirectory.
    ASSIGN
      iSequence                    = iSequence + 1 
      ttDirectory.iDirectorySeq    = iSequence
      ttDirectory.cSourceDirectory = icSourceDirectory
      ttDirectory.cTargetDirectory = icTargetDirectory
      .		
    RETURN TRUE.  
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE  quoter(eAny:GetMessage(1))
      VIEW-AS ALERT-BOX.
      JBoxLogging:Instance:LOG('Error.....' + quoter(eAny:GetMessage(1))).
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID addLog(input ipSourceFile as char,ipError as char ):
    create ttLog.
    assign 
      LogSeq = LogSeq + 1
      ttLog.iLogSeq        = LogSeq
      ttLog.SourceFilename = ipSourceFile
      ttLog.RcodeDirectory = RCODEDIR
      ttLog.CopyDirectory  = copyToDirectory
      ttLog.Created        = now
      ttLog.ErrorMessage   = ipError
      .
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL compileDirectory( INPUT icSourceDirectory AS CHARACTER  ):
    DEFINE VARIABLE cFilename   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFileType   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFullname   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iFileSize   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFileExtent AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cTmp        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE oFileInfo AS CLASS     System.IO.FileInfo NO-UNDO.
    def var SourceDir as char no-undo.
    def var TargetDir as char no-undo.
    
    /*      cTmp = SESSION:TEMP-DIRECTORY.*/
    INPUT stream stIn from os-dir(icSourceDirectory).
    REPEAT:
      IMPORT STREAM stIn cFilename cFullname cFileType.
      IF cFileType = 'F' AND index(cFilename,'.') GT 0 THEN
      DO:
        IF CAN-DO('cls,p,w',ENTRY(2,cFileName,'.')) THEN 
        DO:
          cFileExtent = ENTRY(2,cFileName,'.').
          CREATE ttFile.
          ASSIGN
            iSequence            = iSequence + 1 
            ttFile.iFileSeq      = iSequence
            cTmp                 = REPLACE(cFilename,'/','\')
            cTmp                 = IF R-INDEX(cTmp,'\') GT 0 THEN SUBSTRING(cTmp,R-INDEX(cTmp,'\') + 1) ELSE cTmp
            ttFile.cFileName     = cTmp
            ttFile.cFullFileName = cFullname
            ttFile.cFileExtent   = cFileExtent
            ttFile.bCompiled     = ?
            ttFile.iDirectorySeq = ttDirectory.iDirectorySeq
            .  
        END.  
      END. 
    END.
    FOR EACH ttFile, FIRST ttDirectory OF ttFile:
     
      file-info:file-name = ttFile.cFullFileName.
      oFileInfo = NEW System.IO.FileInfo(ttFile.cFullFileName).

      IF NOT System.IO.Directory:Exists(ttDirectory.cTargetDirectory) THEN System.IO.Directory:CreateDirectory(ttDirectory.cTargetDirectory).
      COMPILE value(ttFile.cFullFileName) SAVE INTO value(ttDirectory.cTargetDirectory) No-error.
      IF ERROR-STATUS:ERROR THEN 
      DO:
        addLog(ttFile.cFullFileName,error-status:GET-MESSAGE (1)).
        ASSIGN 
          ttFile.cFileStatus = ERROR-STATUS:GET-MESSAGE (1)
          ttFile.bCompiled   = FALSE
          .
        UNDO, NEXT.                 
      END.
      ELSE 
      DO:
        addLog(ttFile.cFullFileName,'').
        THIS-OBJECT:Logg = THIS-OBJECT:Logg + chr(13) + chr(10) + FILE-INFO:FILENAME + " --> OK ".
        IF copyToDirectory NE '' THEN 
        DO:
          assign 
            SourceDir = REPLACE(FILE-INFO:FILE-NAME,oFileInfo:NAME,'')
            SourceDir = REPLACE(SourceDir,'.\','')
            .
          assign
            SourceDir = replace(SourceDir,System.IO.Directory:GetCurrentDirectory(),'')
            SourceDir = substring(SourceDir,2)
            TargetDir = copyToDirectory + SourceDir
          . 
          IF NOT System.IO.Directory:Exists(TargetDir) THEN System.IO.Directory:CreateDirectory(TargetDir).
          System.IO.File:Copy(System.IO.Path:Combine(RCODEDIR,REPLACE(SourceDir + oFileInfo:name,oFileInfo:Extension,'.r')),System.IO.Path:Combine(TargetDir,REPLACE(FILE-INFO:FILE-NAME,oFileInfo:Extension,'.r')),TRUE).
          THIS-OBJECT:Logg = THIS-OBJECT:Logg  +  " --> " + System.IO.Path:Combine(TargetDir,REPLACE(FILE-INFO:FILE-NAME,oFileInfo:Extension,'.r')).
        END.
        ttFile.bCompiled = TRUE.
      END.
    END.
    CATCH eAny AS Progress.Lang.Error :
      if avail ttFile then addLog(ttFile.cFullFileName,eAny:GetMessage(1)).
      JBoxLogging:Instance:LOG('Error.....' + quoter(eAny:GetMessage(1))).
    END CATCH.
  END METHOD.

  METHOD PUBLIC LOGICAL compileCommand( INPUT icSourceFile AS CHARACTER, INPUT icTargetDirectory AS CHARACTER  ):
    DEFINE VARIABLE cTmp      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE oFileInfo AS CLASS     System.IO.FileInfo NO-UNDO.
    DEFINE VARIABLE SourceDir AS CHARACTER NO-UNDO.
    def var TargetDir as char no-undo.
    
    icSourceFile = REPLACE(icSourceFile,'/','\').
    icTargetDirectory = REPLACE(icTargetDirectory,'/','\').
    
    IF NOT SUBSTRING(icTargetDirectory,LENGTH(icTargetDirectory),1) = '\' THEN icTargetDirectory = icTargetDirectory + '\'.

    FILE-INFO:FILE-NAME = search(icSourceFile).
    oFileInfo = NEW System.IO.FileInfo(FILE-INFO:FILE-NAME).
    assign 
      SourceDir = REPLACE(oFileInfo:FullName,oFileInfo:NAME,'')
      SourceDir = REPLACE(SourceDir,'.\','')
      SourceDir = replace(SourceDir,System.IO.Directory:GetCurrentDirectory(),'')
      SourceDir = substring(SourceDir,2)
      TargetDir = copyToDirectory + SourceDir
    . 
    if RCODEDIR ne '' then IF NOT System.IO.Directory:Exists(if oFileInfo:Extension = '.cls' then RCODEDIR else RCODEDIR + sourceDir) THEN System.IO.Directory:CreateDirectory(if oFileInfo:Extension = '.cls' then RCODEDIR else RCODEDIR + sourceDir).
    IF FILE-INFO:FILE-SIZE NE ? THEN  COMPILE value(FILE-INFO:FILE-NAME) SAVE INTO value(if oFileInfo:Extension = '.cls' then RCODEDIR else RCODEDIR + sourceDir) no-error.
    if error-status:error then do:
      THIS-OBJECT:Logg = THIS-OBJECT:Logg + chr(13) + chr(10) + FILE-INFO:FILENAME + " --> ERROR " + error-status:get-message(1).
      addLog(icSourceFile,FILE-INFO:FILE-NAME).
    end.
    else do:
      THIS-OBJECT:Logg = THIS-OBJECT:Logg + chr(13) + chr(10) + FILE-INFO:FILENAME + " --> OK ".
      IF copyToDirectory NE '' THEN 
      DO:
        addLog(icSourceFile,'').
  /*      System.IO.File:Copy(REPLACE(RCODEDIR + FILE-INFO:FILE-NAME,oFileInfo:Extension,'.r'),System.IO.Path:Combine(copyToDirectory,REPLACE(FILE-INFO:FILE-NAME,oFileInfo:Extension,'.r')),TRUE).*/
        IF NOT System.IO.Directory:Exists(TargetDir) THEN System.IO.Directory:CreateDirectory(TargetDir).
        System.IO.File:Copy(System.IO.Path:Combine(RCODEDIR,REPLACE(SourceDir + oFileInfo:name,oFileInfo:Extension,'.r')),System.IO.Path:Combine(TargetDir,REPLACE(oFileInfo:name,oFileInfo:Extension,'.r')),TRUE).
        THIS-OBJECT:Logg = THIS-OBJECT:Logg  +  " --> " + System.IO.Path:Combine(TargetDir,REPLACE(oFileInfo:name,oFileInfo:Extension,'.r')).
      END.
    end.
    RETURN TRUE.

    CATCH eAny AS Progress.Lang.Error :
      addLog(icSourceFile,eAny:GetMessage(1)).
      THIS-OBJECT:Logg = THIS-OBJECT:Logg + chr(13) + chr(10) + icSourceFile + "-->" + eAny:GetMessage(1).
      RETURN FALSE.
    END CATCH.
  END METHOD.

  METHOD PUBLIC LOGICAL compileCommand( INPUT icSourceFile AS CHARACTER):
    IF NOT RCODEDIR <> '' OR NOT RCODEDIR <> ? THEN NEW Progress.Lang.AppError('RCODEDIR er ikke satt',1).
    IF NOT System.IO.Directory:Exists(RCODEDIR) THEN System.IO.Directory:CreateDirectory(RCODEDIR).
    compileCommand(icSourceFile,RCODEDIR).

    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.
      RETURN FALSE.
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  
  METHOD PUBLIC VOID startCompile ():
    FOR EACH ttDirectory:
      compileDirectory(ttDirectory.cSourceDirectory).
    END.
    THIS-OBJECT:Logg = 'START kompilering:' + chr(13) + chr(10).
/*    FOR EACH ttFile WHERE ttFile.bCompiled:                                                */
/*      THIS-OBJECT:Logg = THIS-OBJECT:Logg + ttFile.cFileName + chr(13) + chr(10) + chr(10).*/
/*    END.                                                                                   */
    IF CAN-FIND(FIRST ttFile WHERE NOT ttFile.bCompiled) THEN THIS-OBJECT:Logg = THIS-OBJECT:Logg + 'Feil ved kompilering:' + chr(13) + chr(10).
    FOR EACH ttFile WHERE NOT ttFile.bCompiled: 
      THIS-OBJECT:Logg = THIS-OBJECT:Logg + ttFile.cFileName + ':' + chr(9) + ttFile.cFileStatus + chr(13) + chr(10).
    END.
    THIS-OBJECT:Logg = THIS-OBJECT:Logg + 'FERDIG:' + chr(13) + chr(10).       
  END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC JBoxCompile ( ):
	  def var errorlog as longchar no-undo.
	  for each ttLog:
	    errorlog = errorlog + ttLog.ErrorMessage.
	  end.
    this-object:logg = this-object:logg + errorlog.  
    COPY-LOB OBJECT THIS-OBJECT:Logg TO FILE THIS-OBJECT:LogFile.
    empty temp-table ttDirectory.
    empty temp-table ttFile.
	END DESTRUCTOR.

END CLASS.
