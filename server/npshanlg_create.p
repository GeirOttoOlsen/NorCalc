/* Create Customer
   Parameters:  New buffer
                Fields (comma-separated)
                Values (pipe-separated)
   
   Created: 06.10.05 by Brynjar Hasle                  

   To invoke: DYNAMIC-FUNCTION("setAttribute",hFieldMap | hBrowse,"customCreateProc","<procname>").
   
   In this procedure use the getValue function to get to values passed from the client rather
   than looking up icValues parameter to avoid planned change in use of delimiter

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM hBuffer     AS HANDLE NO-UNDO.
DEF INPUT  PARAM icFields    AS CHAR NO-UNDO.
DEF INPUT  PARAM icValues    AS CHAR NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO. 

def var isCopy     as log no-undo.
def var rCopyRowid as rowid no-undo.
DEF VAR iId AS INT NO-UNDO INIT 1.

def buffer bNPSHanlg for NPSHanlg.
def buffer bNPSHsyst for NPSHsyst.

FUNCTION findNextNum RETURNS INT () FORWARD.

rCopyRowid = to-rowid(JBoxServerSide:Instance:FieldValue('CopyRowid')).
isCopy     = rCopyRowid ne ?.
  

/*DO ON ERROR UNDO, RETURN:*/
  ASSIGN 
    iId = findNextNum()
  NO-ERROR.
  ASSIGN 
    hBuffer:BUFFER-FIELD("anleggsnr"):BUFFER-VALUE= iId
  .
  
  find first NORPROSJEKT where NORPROSJEKT.prosjektid = hBuffer::ProsjektId no-error.
  if avail norprosjekt then NORPROSJEKT.aktivt = true.
  
if isCopy then 
do:
  find first bNPSHanlg where rowid(bNPSHanlg) = rCopyRowid no-lock no-error.
  if avail bNPSHanlg then 
  do:
    for each bNPSHsyst of bNPSHanlg no-lock:
      create NPSHsys.
      buffer-copy bNPSHsyst except anleggsnr systemnr to npshsys.
      assign 
        NPSHSYST.anleggsnr = hBuffer::anleggsnr
        NPSHSYST.systemnr  = bNPSHsyst.systemnr
        .
    end.
  end.
end.  
/*END.*/

FUNCTION findNextNum RETURNS INT ():
  def var nyNr as int no-undo.
  run neste_id.p (input 'NPSHANLG',output nyNr).
  RETURN nyNr.
END FUNCTION.

FINALLY:

END FINALLY.