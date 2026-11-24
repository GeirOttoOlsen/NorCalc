VAR INTEGER iSok = 109861.
VAR HANDLE hb.
VAR LOGICAL bOk.

CURRENT-WINDOW:WIDTH-CHARS = 250.

FOR EACH md._index-field NO-LOCK
    WHERE _index-field._index-seq = 1
   ,FIRST _field NO-LOCK OF _index-field
          WHERE _data-type BEGINS "int"
   ,FIRST _index NO-LOCK OF _index-field
   ,FIRST _file NO-LOCK OF _index
   :
  
  CREATE BUFFER hb FOR TABLE _file-name.
  
  hb:FIND-FIRST("WHERE " + _field-name + " = " + STRING(iSok)) NO-ERROR. 
   
  DISP _file-name
       _field-name
       _data-type
       hb:AVAIL
       WITH WIDTH 250. 
  DELETE OBJECT hb.     
END.
