/* Process a set of records sent from the client

   Created: 17/03/20 by goo_000

-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

def var dbliste as char no-undo.
def var databaseName as char no-undo.

DEF VAR qh AS HANDLE NO-UNDO.
DEF VAR bh AS HANDLE NO-UNDO.
def var ii as int no-undo.

dbliste = entry(1,icParam,'|').
create query qh.
do ii = 1 to num-entries(dbListe,','):
  databaseName = entry(ii,dbliste,',').
  databaseName = if databaseName = '' then ldbname(1) else databaseName.
  create buffer bh for table databaseName + '._file'.
  qh:set-buffers(bh).
  qh:QUERY-PREPARE ('for each ' + bh:name + ' where _tbl-type = "T"').
  qh:query-open().
  qh:get-first().
  do while not qh:query-off-end:
    ihBuffer:buffer-create().
    assign 
      ihBuffer::DatabaseName = databaseName
      ihBuffer::TableName = bh::_file-name
      .
    qh:get-next().
  end. 
  qh:query-close.
  bh:BUFFER-RELEASE ().
end.

FINALLY:
  delete object qh.
  obOk = ocReturn = "".
END FINALLY.

