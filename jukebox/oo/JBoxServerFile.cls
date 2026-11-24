 
/*------------------------------------------------------------------------
   File        : JBoxServerFile
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : goo_000
   Created     : Tue Jun 12 15:28:48 CEST 2018
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxServerFile:
  DEFINE VARIABLE hDS     AS HANDLE    NO-UNDO.

  DEFINE VARIABLE rGUID   AS RAW       NO-UNDO.
  DEFINE VARIABLE cGUID   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExtent AS CHARACTER NO-UNDO.

  DEFINE TEMP-TABLE ttFile NO-UNDO
    FIELD Filename    AS CHARACTER 
    FIELD BLOBContent AS blob
    .
  DEFINE PROPERTY myFilename  AS CHARACTER NO-UNDO GET. SET.
  DEFINE PROPERTY tmpFilename AS CHARACTER NO-UNDO GET. 
    PRIVATE SET.
  DEFINE PROPERTY bSuccess    AS LOG NO-UNDO GET. PRIVATE SET.

  DEFINE PROPERTY ttFile AS HANDLE NO-UNDO GET. 
    PRIVATE SET.
  
  def property ShowError as log init false no-undo get. set.
  def property ErrorMessage as char no-undo get. private set.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxServerFile ():

  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxServerFile (INPUT ipFilename AS CHARACTER):
    InitializeJBoxServerFile(ipFilename).
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  METHOD PUBLIC VOID InitializeJBoxServerFile(input ipFilename as char):
    ErrorMessage = ''.
    if valid-handle(hDS) then do:
      empty temp-table ttFile.
      hDS:EMPTY-DATASET ().
      delete object hDS.
    end.
    ASSIGN 
      myFileName = ipFilename
      .
    
    CREATE DATASET hDS.
    hDS:SET-BUFFERS(TEMP-TABLE ttFile:DEFAULT-BUFFER-HANDLE).
    

    IF NOT JBoxServerAPI:Instance:ProcessDataSet('getserverfile.p',myFilename,hDS) THEN do:
      if ShowError then 
        JBoxServerAPI:Instance:viewCallMessage().
      else 
        assign 
          ErrorMessage = JBoxServerAPI:Instance:getCallMessage()
          bSuccess     = false
          .
    end.    
    ELSE 
    DO:      
      hDS:GET-BUFFER-HANDLE (1):FIND-FIRST ().
/*      rGUID = GENERATE-UUID.*/
/*      cGUID = GUID (rGUID). */
      assign 
        cExtent = SUBSTRING(myFilename,R-INDEX(myFilename,'.'))
        myFilename = replace(myFilename,'/','\')
        tmpFilename = (if not System.IO.Directory:Exists('R:\') then 
                         session:TEMP-DIRECTORY 
                       else 
                         'R:\' + JBoxSession:Instance:UserId + '\') 
                       + substring(myFilename,r-index(myFilename,'\') + 1)
        . 
      if hDS:GET-BUFFER-HANDLE (1):avail THEN do:
        COPY-LOB OBJECT hDS:GET-BUFFER-HANDLE (1)::BLOBContent TO FILE tmpFileName.
        bSuccess = true.
      end.
      else bSuccess = false.
      
    END.
  END METHOD.

  DESTRUCTOR PUBLIC JBoxServerFile ( ):
    empty temp-table ttFile.
    IF VALID-HANDLE(hDS) THEN DELETE OBJECT hDS.
  END DESTRUCTOR.

END CLASS.