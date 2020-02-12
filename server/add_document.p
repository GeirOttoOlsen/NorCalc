
DEFINE INPUT  PARAMETER icParam     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER bhTransfer  AS HANDLE NO-UNDO.
DEFINE INPUT  PARAMETER icSessionId AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER ocReturn    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER obOK        AS LOG NO-UNDO.

/* Doc handling: */
/*DEFINE VARIABLE bhDoc          AS HANDLE    NO-UNDO.*/
/*DEFINE VARIABLE httDoc         AS HANDLE    NO-UNDO.*/

/*DEFINE TEMP-TABLE ttDoc NO-UNDO            */
/*  FIELD iFileNum        AS INTEGER         */
/*  FIELD cFileName       AS CHARACTER       */
/*  FIELD cFullPathName   AS CHARACTER       */
/*  FIELD cFileType       AS CHARACTER       */
/*  FIELD cDescription    AS CHARACTER       */
/*  FIELD iDocSize        AS INTEGER         */
/*  FIELD blDocument      AS BLOB            */
/*  FIELD dFileCreateDate AS DATE            */
/*  FIELD iFileCreateTime AS INTEGER         */
/*  FIELD dFileModDate    AS DATE            */
/*  FIELD iFileModTime    AS INTEGER         */
/*  FIELD cCreatedBy      AS CHARACTER       */
/*  FIELD dCreated        AS DATE            */
/*  FIELD cContext        AS CHARACTER       */
/*  FIELD cEntityId       AS CHARACTER       */
/*  FIELD iSeq            AS INTEGER         */
/*  INDEX iFileNum IS PRIMARY UNIQUE iFileNum*/
/*  .                                        */

/*bhDoc = TEMP-TABLE ttDoc:DEFAULT-BUFFER-HANDLE.*/

ASSIGN 
  obOk      = TRUE
  .
def var qh as handle no-undo.
create query qh.
qh:SET-BUFFERS (bhTransfer).
qh:QUERY-PREPARE ('for each ' + bhTransfer:NAME).
qh:query-open().
qh:get-first().
do while not qh:QUERY-OFF-END:
  find first jboxdocument where JBoxDocument.cFileName = bhTransfer::cFileName and JBoxDocument.iDocSize = bhTransfer::iDocSize no-lock no-error.
  if not avail jboxdocument then do:
    create jboxDocument.
    buffer jboxDocument:BUFFER-COPY (bhTransfer).      
  end.
  FIND FIRST JBoxDocRel NO-LOCK
         WHERE JBoxDocRel.iJBoxDocumentId = JBoxDocument.iJBoxDocumentId
           AND JBoxDocRel.cEntityId       = bhTransfer::cEntityId
           AND JBoxDocRel.cContext        = bhTransfer::cContext
         no-error.
   if not avail JBoxDocRel then do:
   create JBoxDocRel.
   assign 
     JBoxDocRel.iJBoxDocumentId = JBoxDocument.iJBoxDocumentId
     JBoxDocRel.cEntityId       = bhTransfer::cEntityId
     JBoxDocRel.cContext        = bhTransfer::cContext
   .         
   end.  
  qh:GET-NEXT().    
END.




/* **********************  Internal Procedures  *********************** */

CATCH e AS Progress.Lang.Error:
  ASSIGN 
    obOk     = FALSE
    ocReturn = e:GetMessage(1)
    .
  JBoxLogging:Instance:LOG('ERROR:', e:GetMessage(1) + ':' + ocReturn).
END CATCH.

FINALLY:
  DELETE OBJECT qh NO-ERROR.        
END FINALLY.
