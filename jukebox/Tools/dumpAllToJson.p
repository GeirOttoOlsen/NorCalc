DEFINE VAR htt AS HANDLE NO-UNDO.

DEF VAR hBuffer AS HANDLE NO-UNDO.
DEF VAR hQuery  AS HANDLE NO-UNDO.
DEF VAR hField  AS HANDLE NO-UNDO.
DEF VAR ix      AS INT    NO-UNDO.

FOR EACH _file NO-LOCK
    WHERE _tbl-type = "T"
      AND _File-name = "Eiendom"
     :
  
  CREATE BUFFER hBuffer FOR TABLE _file-name.

  CREATE TEMP-TABLE htt.
  htt:CREATE-LIKE(hBuffer).
  htt:TEMP-TABLE-PREPARE(_File-name).

  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS(hBuffer).
  hQuery:QUERY-PREPARE("for each " + _file-name).
  hQuery:QUERY-OPEN().
  hQuery:GET-FIRST().
  REPEAT WHILE NOT hQuery:QUERY-OFF-END:
    htt:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
    htt:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(hBuffer).
    hQuery:GET-NEXT().
  END.

  htt:WRITE-JSON("file","c:\temp\" + _file-name + ".json",YES,"utf-8").

  DELETE OBJECT hQuery.
  DELETE OBJECT hBuffer.
  DELETE OBJECT htt.

END.


