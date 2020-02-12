 
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
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxServerFile (INPUT ipFilename AS CHARACTER):
    ASSIGN 
      myFileName = ipFilename
      .
      
    InitializeJBoxServerFile().
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  METHOD PUBLIC VOID InitializeJBoxServerFile(  ):
    CREATE DATASET hDS.
    hDS:SET-BUFFERS(TEMP-TABLE ttFile:DEFAULT-BUFFER-HANDLE).

    IF NOT JBoxServerAPI:Instance:ProcessDataSet('getserverfile.p',myFilename,hDS) THEN 
      JBoxServerAPI:Instance:viewCallMessage().    
    ELSE 
    DO:
      hDS:GET-BUFFER-HANDLE (1):FIND-FIRST ().
      rGUID = GENERATE-UUID.
      cGUID = GUID (rGUID).
      cExtent = SUBSTRING(myFilename,R-INDEX(myFilename,'.')).
      tmpFilename = session:TEMP-DIRECTORY + cGUID + cExtent. 
      
      IF hDS:GET-BUFFER-HANDLE (1):avail THEN COPY-LOB OBJECT hDS:GET-BUFFER-HANDLE (1)::BLOBContent TO FILE tmpFileName.
      
      bSuccess = YES.
    END.
  END METHOD.

  DESTRUCTOR PUBLIC JBoxServerFile ( ):
    IF VALID-HANDLE(hDS) THEN DELETE OBJECT hDS.
  END DESTRUCTOR.

END CLASS.