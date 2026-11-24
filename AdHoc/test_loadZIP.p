
/*------------------------------------------------------------------------
    File        : test_loadZIP.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Sat Apr 13 12:19:33 CEST 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.
l
/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var zipFile          as char no-undo.
def var unpackDirectory  as char no-undo.
def var ArchiveDirectory as char no-undo.
def var qh               as handle no-undo.
def var oDirectory       as class System.IO.DirectoryInfo no-undo.
def var oTool            as class oo.Toolbox no-undo.
def var oFile            as class oo.FileHelper no-undo.

oTool = new oo.Toolbox().
zipFile = 'e:\temp\_ helenev.zip'.
unpackDirectory = 'e:\temp'.

ArchiveDirectory = unpackDirectory + '\helenev'. 
if not System.IO.File:Exists(zipFile) then 
  undo, throw new Progress.Lang.AppError(subst('Fant ikke filen &1',zipFile),0).

oDirectory = new System.IO.DirectoryInfo(ArchiveDirectory).
if not oDirectory:Exists then 
  undo, throw new Progress.Lang.AppError(subst('Katalogen &1 finnes ikke',ArchiveDirectory),0).

oFile = new oo.FileHelper().
//oFile:loadZipFile('e:\temp\_ HELENEV.zip','e:\temp').
oFile:ProcessDirectory(oDirectory,'*.jpg',?,?).

create query qh.
qh:ADD-BUFFER (oFile:bhFiles).
qh:QUERY-PREPARE ('for each ' + oFile:bhFiles:name).
qh:query-open().

do while qh:get-next():
  MESSAGE qh:get-buffer-handle(1)::fullFilename skip(2) oTool:toBase64(qh:get-buffer-handle(1)::FilePath)  
  VIEW-AS ALERT-BOX.  
end.

FINALLY:
  delete object qh.  
END FINALLY.