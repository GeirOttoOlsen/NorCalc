 
/*------------------------------------------------------------------------
   File        : JBoxFileHelper
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : goo_000
   Created     : Thu Oct 24 15:59:56 CEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.
  
CLASS JBoxFileHelper: 
  DEFINE TEMP-TABLE Files NO-UNDO
    FIELD iSeq          AS INTEGER
    FIELD ShortFilename AS CHARACTER FORMAT "x(20)"
    FIELD ShortPath     AS CHARACTER FORMAT "x(20)"
    FIELD Filepath      AS CHARACTER FORMAT "x(50)"
    FIELD FullFilename  AS CHARACTER FORMAT "x(50)"
    FIELD FileModified  AS DATETIME
    FIELD FileCreated   AS DATETIME
    FIELD FileSize      AS int64
    field FileMatchesStreng as log
    INDEX iSeq IS PRIMARY UNIQUE iSeq
    .
  DEFINE PUBLIC PROPERTY bhFiles AS HANDLE NO-UNDO 
    GET():
      RETURN TEMP-TABLE Files:DEFAULT-BUFFER-HANDLE.
    END GET. 
    PRIVATE SET.  
  define public property ExcludeDirectories as char no-undo get. set.
  def public property iCounter as int no-undo get. private set.
  
  DEFINE VARIABLE oFileInfo AS System.IO.FileInfo NO-UNDO.
  def var oRoot as System.IO.DirectoryInfo no-undo.
    
  DEFINE PUBLIC PROPERTY FileContent AS LONGCHAR NO-UNDO 
    GET():
      IF NOT VALID-OBJECT(oFileInfo) THEN RETURN ?.  
      IF oFileInfo:Exists THEN 
      DO: 
        COPY-LOB FILE oFileInfo:FullName TO OBJECT FileContent.
        RETURN FileContent.
      END.
      RETURN ''.
    END GET. 
    PRIVATE SET.
      
  DEFINE PUBLIC PROPERTY FullFilename AS CHARACTER NO-UNDO 
    GET(): 
      RETURN oFileInfo:FullName.
    END GET. 
    
    PRIVATE SET.
  
  DEFINE PUBLIC PROPERTY FileSize AS int64 NO-UNDO 
    GET(): 
      RETURN oFileInfo:Length.
    END GET. 
    PRIVATE SET.
  
  DEFINE PUBLIC PROPERTY Exsist AS LOG NO-UNDO 
    GET(): 
      RETURN oFileInfo:Exists. 
    END GET. 
    PRIVATE SET.
  
  DEFINE PUBLIC PROPERTY hasError AS LOG NO-UNDO GET. 
    PRIVATE SET.
  DEFINE PUBLIC PROPERTY StatusMessage AS CHARACTER NO-UNDO GET. 
    PRIVATE SET.
  def public property ReadRecursive as log no-undo get. set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxFileHelper (INPUT ipFile AS CHARACTER):
    def var oStrRead as System.IO.StreamReader no-undo.
    fix-codepage(FileContent) = 'UTF-8'.
    oFileInfo = NEW System.IO.FileInfo(ipFile).
    oStrRead = new System.IO.StreamReader(oFileInfo:FullName,System.Text.Encoding:UTF8).
    FileContent = oStrRead:ReadToEnd().
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxFileHelper (INPUT ipFile AS CHARACTER,input ipEncoding as System.Text.Encoding ):
    def var oStrRead as System.IO.StreamReader no-undo.
    fix-codepage(FileContent) = 'UTF-8'.
    oFileInfo = NEW System.IO.FileInfo(ipFile).
    oStrRead = new System.IO.StreamReader(oFileInfo:FullName,ipEncoding).
    FileContent = oStrRead:ReadToEnd().
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxFileHelper ():
    fix-codepage(FileContent) = 'UTF-8'.
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID CopyDirectory(INPUT ipFromDirectory AS CHARACTER, INPUT ipToDirectory AS CHARACTER, INPUT ipCopyAll AS LOG):
    DEFINE VARIABLE oFromDirectory AS System.IO.DirectoryInfo NO-UNDO.
    DEFINE VARIABLE oToDirectory   AS System.IO.DirectoryInfo NO-UNDO.
    
    DEFINE VARIABLE oCmd           AS CLASS                   JBoxCMD NO-UNDO.

    oFromDirectory = NEW System.IO.DirectoryInfo(ipFromDirectory).
    IF NOT oFromDirectory:Exists THEN UNDO, THROW NEW Progress.Lang.AppError('Fra katalog ikke gyldig').

    oToDirectory = NEW System.IO.DirectoryInfo(ipToDirectory).
    IF NOT oFromDirectory:Exists THEN UNDO, THROW NEW Progress.Lang.AppError('Til katalog ikke gyldig').

    oCmd = NEW JBoxCMD('robocopy.exe',oFromDirectory:FullName + ' ' + oToDirectory:FullName + (IF ipCopyAll THEN " /e" ELSE '')).
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.    
        
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID DeleteDirectory(INPUT ipDirectory AS CHARACTER, INPUT ipRecursive AS LOG  ):
    DEFINE VARIABLE Directories    AS CHARACTER               EXTENT NO-UNDO.
    DEFINE VARIABLE Files          AS CHARACTER               EXTENT NO-UNDO.
    DEFINE VARIABLE oDirectory     AS System.IO.DirectoryInfo NO-UNDO.
    DEFINE VARIABLE oDirectories   AS System.IO.DirectoryInfo EXTENT NO-UNDO.
    DEFINE VARIABLE DirectoryName  AS CHARACTER               NO-UNDO.
    DEFINE VARIABLE DirectoryLoop  AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE FileLoop       AS INTEGER                 NO-UNDO.
    DEFINE VARIABLE oFiles         AS System.IO.FileInfo      EXTENT NO-UNDO.
    DEFINE VARIABLE FileCount      AS INTEGER                 NO-UNDO.    
    DEFINE VARIABLE DirectoryCount AS INTEGER                 NO-UNDO.    
    
    oDirectory = NEW System.IO.DirectoryInfo(ipDirectory).
    IF NOT oDirectory:Exists THEN UNDO, THROW NEW Progress.Lang.AppError('Katalog ikke gyldig').
    IF oDirectory:GetDirectories():Length = 0 THEN RETURN.
    if can-do(ExcludeDirectories,ipDirectory) then return.
    oDirectories = oDirectory:GetDirectories().
    if oDirectory:GetDirectories():Length gt 0 then DirectoryCount = oDirectory:GetDirectories():Length. else DirectoryCount = 0.
    DO DirectoryLoop = 1 TO DirectoryCount:
      DirectoryName = oDirectories[DirectoryLoop]:FullName.
      IF oDirectories[DirectoryLoop]:GetFiles():Length GT 0 THEN do: 
        FileCount = int(oDirectories[DirectoryLoop]:GetFiles():Length).
        oFiles = oDirectories[DirectoryLoop]:GetFiles().
      end. else FileCount = 0.        
      DO FileLoop = 1 TO FileCount:
        oFiles[FileLoop]:Delete().
      END.
      EXTENT(oFiles) = ?.
      DeleteDirectory(DirectoryName, ipRecursive).
      System.IO.Directory:Delete(DirectoryName).
    END.
    oDirectory = NEW System.IO.DirectoryInfo(DirectoryName).
    IF oDirectory:Exists THEN System.IO.Directory:Delete(ipDirectory).
    EXTENT(oDirectories) = ?.
    CATCH eAny AS System.IO.IOException :
      /*Det kan gå for fort, derfor oppfatter ikke System.IO.... at filen har blitt slettet, denne fanger opp feilen...*/
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID emtpyContent(  ):
    
    FileContent = ''.

  END METHOD.

/*  /*------------------------------------------------------------------------------                                              */
/*   Purpose:                                                                                                                     */
/*   Notes:                                                                                                                       */
/*  ------------------------------------------------------------------------------*/                                              */
/*  METHOD PUBLIC VOID readDirectory(INPUT ipDirectory AS CHARACTER, INPUT ipSearchPattern AS CHARACTER, ipModified AS DATETIME ):*/
/*    DEFINE VARIABLE bOk          AS LOG                     NO-UNDO.                                                            */
/*    DEFINE VARIABLE Files        AS "System.String[]"       NO-UNDO.                                                            */
/*    DEFINE VARIABLE FullFilename AS CHARACTER               NO-UNDO.                                                            */
/*    DEFINE VARIABLE oFileinfo    AS CLASS                   System.IO.FileInfo NO-UNDO.                                         */
/*    DEFINE VARIABLE ix           AS INTEGER                 NO-UNDO.                                                            */
/*    DEFINE VARIABLE oRoot        AS System.IO.DirectoryInfo NO-UNDO.                                                            */
/*                                                                                                                                */
/*    oRoot = NEW System.IO.DirectoryInfo(ipDirectory).                                                                           */
/*    IF oRoot:Exists THEN                                                                                                        */
/*    DO:                                                                                                                         */
/*      Files = System.IO.Directory:GetFiles(ipDirectory,ipSearchPattern,System.IO.SearchOption:AllDirectories).                  */
/*      IF Files:Length GT 0 THEN                                                                                                 */
/*      DO ix = 0 TO Files:length - 1:                                                                                            */
/*        FullFilename = Files:GetValue(ix).                                                                                      */
/*        oFileinfo = NEW System.IO.FileInfo(FullFilename).                                                                       */
/*        IF ipModified NE ? THEN                                                                                                 */
/*        DO:                                                                                                                     */
/*          IF oFileinfo:LastWriteTime LT ipModified THEN NEXT.                                                                   */
/*        END.                                                                                                                    */
/*        CREATE Files.                                                                                                           */
/*        ASSIGN                                                                                                                  */
/*          Files.iSeq          = ix + 1                                                                                          */
/*          Files.Filepath      = oFileinfo:DirectoryName                                                                         */
/*          Files.FullFilename  = oFileinfo:FullName                                                                              */
/*          Files.ShortFilename = oFileinfo:Name                                                                                  */
/*          Files.ShortPath     = TRIM(REPLACE(oFileinfo:DirectoryName,oRoot:FullName,''),'\')                                    */
/*          Files.FileSize      = oFileinfo:Length                                                                                */
/*          Files.FileCreated   = oFileinfo:CreationTime                                                                          */
/*          Files.FileModified  = oFileinfo:LastWriteTime                                                                         */
/*          .                                                                                                                     */
/*      END.                                                                                                                      */
/*    END.                                                                                                                        */
/*    ELSE UNDO, THROW NEW Progress.Lang.AppError('Katalogen finnes ikke',1).                                                     */
/*  END METHOD.                                                                                                                   */

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID checkContentInFiles(input ipContent as char):
    def var oStream as class System.IO.StreamReader no-undo.
    def var lc as longchar no-undo.
    if ipContent = '' then return.
    for each Files:
      copy-lob from file Files.FullFilename to lc no-error.
      if error-status:error then next.
      files.FileMatchesStreng = index(lc,ipContent) gt 0.
      lc = ''. 
    end.    
  END METHOD. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID readDirectoryRecursive(INPUT ipDirectory AS CHARACTER, INPUT ipSearchPattern AS CHARACTER, ipModifiedFrom AS DATETIME, ipModifiedTo AS DATETIME  ):
    ReadRecursive = true.
    oRoot = new System.IO.DirectoryInfo(ipDirectory).
    if oRoot:Exists then ProcessDirectory(oRoot,ipSearchPattern,ipModifiedFrom,ipModifiedTo).
    
  END METHOD. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID readDirectory(INPUT ipDirectory AS CHARACTER, INPUT ipSearchPattern AS CHARACTER, ipModifiedFrom AS DATETIME, ipModifiedTo AS DATETIME  ):
    ReadRecursive = false.
    oRoot = new System.IO.DirectoryInfo(ipDirectory).
    if oRoot:Exists then ProcessDirectory(oRoot,ipSearchPattern,ipModifiedFrom,ipModifiedTo).
    
  END METHOD. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID ProcessDirectory(INPUT ioDirectory AS System.IO.DirectoryInfo, INPUT ipSearchPattern AS CHARACTER, ipModifiedFrom AS DATETIME, ipModifiedTo AS DATETIME  ):
    def var ix as int no-undo.
    def var ii as int no-undo.
    
    DEFINE VARIABLE oDirectory        AS System.IO.DirectoryInfo NO-UNDO.
    def var Directories as char extent no-undo.
    def var currentDirectory as char no-undo.
    def var SkipDirectory as log no-undo.
    
    SkipDirectory = false.
    IF ioDirectory:Exists THEN 
    DO:
      if not valid-object(oRoot) then oRoot = ioDirectory. 
      assign 
        CurrentDirectory = replace(ioDirectory:FullName,oRoot:FullName,'')
        .
      if CurrentDirectory ne '' then if can-do(ExcludeDirectories,currentDirectory) then SkipDirectory = true.
      if ExcludeDirectories ne '' then do ii = 1 to num-entries(ExcludeDirectories):
        if index(currentDirectory,entry(ii,ExcludeDirectories)) gt 0 then SkipDirectory = true.
      end.
      if not SkipDirectory then ProcessFiles(ioDirectory, ipSearchPattern, ipModifiedFrom, ipModifiedTo).
      if ReadRecursive then do:
        Directories = System.IO.Directory:GetDirectories(ioDirectory:FullName) no-error.
        do ix = 1 to extent(Directories):
          oDirectory = NEW System.IO.DirectoryInfo(Directories[ix]).
          IF oDirectory:Exists THEN 
            ProcessDirectory(oDirectory,ipSearchPattern,ipModifiedFrom,ipModifiedTo).
        end.
      end.
    END.
    CATCH eAny AS Progress.Lang.Error :
        MESSAGE 'processDirectory:' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID ProcessFiles(INPUT ioDirectory AS System.IO.DirectoryInfo, INPUT ipSearchPattern AS CHARACTER, ipModifiedFrom AS DATETIME, input ipModifiedTo as datetime ):
    DEFINE VARIABLE Files        AS "System.String[]"       NO-UNDO.
    def var oFileInfo as System.IO.FileInfo no-undo.
    def var FullFileName as char no-undo.
    def var ix as int no-undo.

    Files = System.IO.Directory:GetFiles(ioDirectory:FullName,ipSearchPattern).
    IF Files:Length GT 0 THEN 
    DO ix = 0 TO Files:length - 1:
      FullFilename = Files:GetValue(ix).
      oFileInfo = new System.IO.FileInfo(FullFileName).
      if not oFileInfo:Exists then next.
      if ipModifiedFrom ne ? and oFileinfo:LastWriteTime LT ipModifiedFrom THEN NEXT.
      if ipModifiedTo   ne ? and oFileInfo:LastWriteTime GT ipModifiedTo then next. 
      
      CREATE Files.
      ASSIGN
        iCounter            = iCounter + 1      
        Files.iSeq          = iCounter
        Files.Filepath      = oFileinfo:DirectoryName
        Files.FullFilename  = oFileinfo:FullName
        Files.ShortFilename = oFileinfo:Name
        Files.ShortPath     = TRIM(REPLACE(oFileinfo:DirectoryName,oRoot:FullName,''),'\')
        Files.FileSize      = oFileinfo:Length
        Files.FileCreated   = oFileinfo:CreationTime
        Files.FileModified  = oFileinfo:LastWriteTime
        .
    END.
    CATCH eAny AS Progress.Lang.Error :
        MESSAGE 'processFiles:' eAny:GetMessage(1) skip oFileInfo:FullName skip iCounter
        VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD. 
  
  method public character extent getFiles ():
    var handle qh.
    var character[] files.
    var int ii.
    
    if valid-handle(bhFiles) then do:
      create query qh.
      qh:add-buffer(bhFiles).
      qh:query-prepare('for each ' + bhFiles:name).
      qh:query-open().
      
      do while not qh:query-off-end and qh:get-next():
        ii += 1.
      end.

      extent(files) = ii.
      ii = 0.        
      qh:query-close().
      qh:query-open().
      do while not qh:query-off-end and qh:get-next():
        ii += 1.
        files[ii] = bhFiles::FullFilename.
      end.        
    end.
    delete object qh no-error.
    return files.
    
  end method.
  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
      
------------------------------------------------------------------------------*/
  
/*  METHOD PUBLIC CHARACTER AddFileToArchive(INPUT ipFile AS CHARACTER ):                                     */
/*    DEFINE VARIABLE filenames AS CHARACTER NO-UNDO.                                                         */
/*    oFileInfo = NEW System.IO.FileInfo(ipFile).                                                             */
/*    Filenames = oFileInfo:FullName.                                                                         */
/*    filenames = REPLACE(Filenames,'\','/').                                                                 */
/*    IF NOT oChillZip:AppendOneFileOrDir(Filenames,FALSE) THEN                                               */
/*      UNDO, THROW NEW Progress.Lang.AppError('Feilet ved komprimering av fil:' + oChillZip:LastErrorText,1).*/
/*  END METHOD.                                                                                               */

    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    DESTRUCTOR PUBLIC JBoxFileHelper ( ):
    empty temp-table Files.
    END DESTRUCTOR.
  
END CLASS.