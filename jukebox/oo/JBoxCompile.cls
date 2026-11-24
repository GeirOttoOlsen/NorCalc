 
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

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxCompile: 
  DEFINE STREAM stIn.
      
  DEFINE TEMP-TABLE ttDirectory NO-UNDO
    FIELD DirectorySeq    AS INTEGER
    FIELD SourceDirectory AS CHARACTER 
    field ShortSourceDirectory as char 
    FIELD TargetDirectory AS CHARACTER 
    INDEX DirectorySeq IS PRIMARY UNIQUE DirectorySeq
    .

  DEFINE TEMP-TABLE Files NO-UNDO
    FIELD iSeq          AS INTEGER
    FIELD ShortFilename AS CHARACTER FORMAT "x(20)"
    FIELD ShortPath     AS CHARACTER FORMAT "x(20)"
    FIELD Filepath      AS CHARACTER FORMAT "x(50)"
    FIELD FullFilename  AS CHARACTER FORMAT "x(50)"
    FIELD FileModified  AS DATETIME
    FIELD FileCreated   AS DATETIME
    FIELD FileSize      AS int64
    INDEX iSeq IS PRIMARY UNIQUE iSeq
    .

  DEFINE TEMP-TABLE ttFile NO-UNDO 
    FIELD iFileSeq      AS INTEGER
    FIELD DirectorySeq AS INTEGER
    FIELD cFileName     AS CHARACTER FORMAT 'X(72)'
    FIELD cFullFileName AS CHARACTER FORMAT 'X(72)'
    FIELD cFileExtent   AS CHARACTER  
    FIELD bCompiled     AS LOG
    FIELD cFileStatus   AS CHARACTER FORMAT "x(72)"
       
    INDEX iFileSeq IS PRIMARY UNIQUE iFileSeq
    INDEX DirectorySeq              DirectorySeq
    .  

  DEFINE DATASET dsCompile 
    FOR ttDirectory, ttFile
    DATA-RELATION relttDirectory FOR ttDirectory, ttFile RELATION-FIELDS(DirectorySeq,DirectorySeq).

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
  def public property ROOTDirectory as char no-undo get. private set.
    
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
  def property FilePattern as char no-undo 
  get():
    if FilePattern = '' or FilePattern = ? then return '*.cls,*.w,*.p'.
    else return FilePattern.
  end get. set.
  def var oFileHelper as class JBoxFileHelper no-undo.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxCompile (input ipROOTDirectory as char, INPUT icLogFile AS CHARACTER, INPUT iiLogLevel AS INTEGER  ):
    
    THIS-OBJECT:LogFile = icLogFile.
    ROOTDirectory = ipROOTDirectory.
    if not System.IO.Directory:Exists(ipROOTDirectory) then undo, throw new Progress.Lang.AppError('Fant ikke ROOT katalog:' + ipROOTDirectory).
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL addDirectory( INPUT icSourceDirectory AS CHARACTER):
    addDirectory(icSourceDirectory,'').  
  END METHOD.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL addDirectory( INPUT icSourceDirectory AS CHARACTER, input ipTargetDirectory as char):
    def var oSourceDirectory as System.IO.DirectoryInfo no-undo.
    def var oTargetDirectory as System.IO.DirectoryInfo no-undo.
     
    if RCODEDIR = ? or RCODEDIR = '' then undo, throw new Progress.Lang.AppError('RCODE Katalog må settes',1).
    
    assign 
      icSourceDirectory = replace(icSourceDirectory,'/','\')
      icSourceDirectory = replace(icSourceDirectory,'.\','')
      .
    if System.IO.Directory:Exists(icSourceDirectory) then 
      oSourceDirectory = new System.IO.DirectoryInfo(icSourceDirectory).
      
    else oSourceDirectory = new System.IO.DirectoryInfo(ROOTDirectory + '\' + icSourceDirectory).
    if not oSourceDirectory:Exists then undo, throw new Progress.Lang.AppError('Katalogen ' + icSourceDirectory + ' ble ikke funnet',1).

    if not (ipTargetDirectory = '' or ipTargetDirectory = ?) and index(ipTargetDirectory,RCODEDIR) le 0 then ipTargetDirectory = RCODEDIR + ipTargetDirectory.
    else  ipTargetDirectory = RCODEDIR + trim(replace(icSourceDirectory,ROOTDirectory,''),'\').
    
    oTargetDirectory = new System.IO.DirectoryInfo(ipTargetDirectory).

    CREATE ttDirectory.
    ASSIGN
      iSequence                        = iSequence + 1 
      ttDirectory.DirectorySeq         = iSequence
      ttDirectory.SourceDirectory      = oSourceDirectory:FullName
      ttDirectory.TargetDirectory      = oTargetDirectory:FullName
      ttDirectory.ShortSourceDirectory = trim(replace(oSourceDirectory:FullName,ROOTDirectory,''),'\') 
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

    METHOD PUBLIC VOID addFile(input ipFileInfo as System.IO.FileInfo ):
      
      find first ttDirectory where ttDirectory.SourceDirectory = ipFileInfo:Directory:FullName no-error.
      if not avail ttDirectory then do:
        addDirectory(ipFileInfo:Directory:FullName).
      end. 
        
      CREATE ttFile.
      ASSIGN
        iSequence            = iSequence + 1
        ttFile.iFileSeq      = iSequence
        ttFile.cFileName     = ipFileInfo:Name
        ttFile.cFullFileName = ipFileInfo:FullName
        ttFile.cFileExtent   = ipFileInfo:Extension
        ttFile.bCompiled     = ?
        ttFile.DirectorySeq  = ttDirectory.DirectorySeq
        .
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

    def var ix as int no-undo.
    def var oDirectory as System.IO.DirectoryInfo no-undo.
    def var SubDirectory as char no-undo.
    oDirectory = new System.IO.DirectoryInfo(icSourceDirectory).
    
    oFileHelper = new JBoxFileHelper().
    oFileHelper:ReadRecursive = false.
    do ix = 1 to num-entries(FilePattern):
      oFileHelper:ProcessDirectory(oDirectory,entry(ix,FilePattern),?,?).
    end.    
    temp-table Files:COPY-TEMP-TABLE (oFileHelper:bhFiles:table-handle).
    for each Files:
      oFileInfo = new System.IO.FileInfo(Files.FullFilename).
      if oFileInfo:Exists then addFile(oFileInfo).
    end.

    FOR EACH ttFile, FIRST ttDirectory OF ttFile:
      oFileInfo = NEW System.IO.FileInfo(ttFile.cFullFileName).
      compileCommand(ttDirectory.ShortSourceDirectory + '\' + oFileInfo:Name,ttDirectory.TargetDirectory).
    END.
    CATCH eAny AS Progress.Lang.Error :
      if avail ttFile then addLog(ttFile.cFullFileName,eAny:GetMessage(1)).
      JBoxLogging:Instance:LOG('Error.....' + quoter(eAny:GetMessage(1))).
    END CATCH.
  END METHOD.

  METHOD PUBLIC LOGICAL compileCommand( INPUT icSourceFile AS CHARACTER):
      compileCommand(icSourceFile,'').
  END method.
  
  METHOD PUBLIC LOGICAL compileCommand( INPUT icSourceFile AS CHARACTER,input ipTargetDirectory as char):
    DEFINE VARIABLE cTmp      AS CHARACTER NO-UNDO.
    DEFINE VARIABLE oFileInfo AS CLASS     System.IO.FileInfo NO-UNDO.
    def var oTargetDirectory as class System.IO.DirectoryInfo no-undo.
        
    DEFINE VARIABLE SourceDir AS CHARACTER NO-UNDO.

    assign 
      icSourceFile = REPLACE(icSourceFile,'/','\')
      .
    
    oFileInfo = NEW System.IO.FileInfo(icSourceFile).
    if not oFileInfo:Exists then undo, throw new Progress.Lang.AppError('Filen eksisterer ikke: ' + icSourceFile,1).
    
    find first ttFile where ttFile.cFullFileName = oFileInfo:FullName no-error.
    if not avail ttFile then addFile(oFileInfo).

    if ipTargetDirectory = '' then oTargetDirectory = new System.IO.DirectoryInfo(ttDirectory.TargetDirectory).
    else oTargetDirectory = new System.IO.DirectoryInfo(ipTargetDirectory).
    
    if not oTargetDirectory:Exists then System.IO.Directory:CreateDirectory(oTargetDirectory:FullName).
    
    COMPILE value(oFileInfo:FullName) SAVE INTO value(oTargetDirectory:FullName) no-error.
    if error-status:ERROR then do:
      assign 
        ttFile.bCompiled   = false 
        ttFile.cFileStatus = error-status:GET-MESSAGE (1)
        .
    end.
    else 
      assign 
        ttFile.bCompiled = true
        ttFile.cFileStatus = 'OK'
        .
    
/*        System.IO.File:Copy(System.IO.Path:Combine(RCODEDIR,REPLACE(SourceDir + oFileInfo:name,oFileInfo:Extension,'.r')),System.IO.Path:Combine(TargetDir,REPLACE(oFileInfo:name,oFileInfo:Extension,'.r')),TRUE).                                     */
/*        THIS-OBJECT:Logg = THIS-OBJECT:Logg  +  " --> " + System.IO.Path:Combine(TargetDir,REPLACE(oFileInfo:name,oFileInfo:Extension,'.r')).                                                                                                           */
/*      END.                                                                                                                                                                                                                                              */
/*    end.                                                                                                                                                                                                                                                */
    RETURN TRUE.

    CATCH eAny AS Progress.Lang.Error :
      addLog(icSourceFile,eAny:GetMessage(1)).
      RETURN FALSE.
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  
  METHOD PUBLIC VOID startCompile ():
    THIS-OBJECT:Logg = 'START kompilering:' + chr(13) + chr(10).
    FOR EACH ttDirectory:
      compileDirectory(ttDirectory.SourceDirectory).
    END.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DESTRUCTOR PUBLIC JBoxCompile ( ):
    for each ttFile by cFileName by bCompiled:
        this-object:logg = this-object:logg + ttFile.cFileName + ':' + ttFile.cFileStatus + chr(13) + chr(10).  
    end.
    COPY-LOB OBJECT THIS-OBJECT:Logg TO FILE THIS-OBJECT:LogFile.
    empty temp-table ttDirectory.
    empty temp-table ttFile.
    empty temp-table Files.
  END DESTRUCTOR.

END CLASS.
