 
/*------------------------------------------------------------------------
   File        : JsonHelper
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : qa-3pthinc
   Created     : Tue Jan 21 09:49:51 CET 2020
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JsonHelper: 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  def var ix as int no-undo.
    
  CONSTRUCTOR PUBLIC JsonHelper (  ):
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setFieldValue(INPUT ipField AS HANDLE, INPUT ipJsonField AS CHARACTER, INPUT ipData AS Progress.Json.ObjectModel.JsonObject):
    IF VALID-HANDLE(ipField) THEN 
    DO:
      
      if ipData:GetType(ipJsonField) = Progress.Json.ObjectModel.JsonDataType:ARRAY then do:
        if ipField:EXTENT gt 0 then do:
          do ix = 1 to ipData:GetJsonArray(ipJsonField):Length:
            IF      ipField:DATA-TYPE = 'date' THEN ipField:BUFFER-VALUE(ix) = ipData:GetJsonArray(ipJsonField):GetDate(ix).
            ELSE IF ipField:DATA-TYPE = 'datetime' THEN ipField:BUFFER-VALUE(ix) = ipData:GetJsonArray(ipJsonField):GetDatetime(ix).
              ELSE IF ipField:DATA-TYPE = 'integer' THEN ipField:BUFFER-VALUE(ix) = ipData:GetJsonArray(ipJsonField):GetInteger(ix).
                ELSE IF ipField:DATA-TYPE = 'int64' THEN ipField:BUFFER-VALUE(ix) = ipData:GetJsonArray(ipJsonField):GetInt64(ix).
                  ELSE IF ipField:DATA-TYPE = 'logical' THEN ipField:BUFFER-VALUE(ix) = ipData:GetJsonArray(ipJsonField):GetLogical(ix).
                    ELSE IF ipField:DATA-TYPE = 'character' THEN ipField:BUFFER-VALUE(ix) = ipData:GetJsonArray(ipJsonField):GetCharacter(ix).
                      ELSE IF ipField:DATA-TYPE = 'decimal' THEN ipField:BUFFER-VALUE(ix) = ipData:GetJsonArray(ipJsonField):GetDecimal(ix).
          end.
        end.
      end.
      else
      IF      ipField:DATA-TYPE = 'date' THEN ipField:BUFFER-VALUE = ipData:GetDate(ipJsonField).
      ELSE IF ipField:DATA-TYPE = 'datetime' THEN ipField:BUFFER-VALUE = ipData:GetDatetime(ipJsonField).
        ELSE IF ipField:DATA-TYPE = 'integer' THEN ipField:BUFFER-VALUE = ipData:GetInteger(ipJsonField).
          ELSE IF ipField:DATA-TYPE = 'int64' THEN ipField:BUFFER-VALUE = ipData:GetInt64(ipJsonField).
            ELSE IF ipField:DATA-TYPE = 'logical' THEN ipField:BUFFER-VALUE = ipData:GetLogical(ipJsonField).
              ELSE IF ipField:DATA-TYPE = 'character' THEN ipField:BUFFER-VALUE = ipData:GetCharacter(ipJsonField).
                ELSE IF ipField:DATA-TYPE = 'decimal' THEN ipField:BUFFER-VALUE = ipData:GetDecimal(ipJsonField).
    END.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC HANDLE getBufferField(ipBuffer AS HANDLE, ipJsonField AS CHARACTER  ):
    DEFINE VARIABLE hField AS HANDLE  NO-UNDO.
    DEFINE VARIABLE ix     AS INTEGER NO-UNDO.
    hField = ipBuffer:BUFFER-FIELD(ipJsonField) NO-ERROR.
    IF VALID-HANDLE(hField) THEN RETURN hField.
    ELSE 
    DO ix = 1 TO ipBuffer:NUM-FIELDS:
      hField = ipBuffer:BUFFER-FIELD(ix).
      IF hField:SERIALIZE-NAME = ipJsonField THEN RETURN hField.
    END.
    RETURN ?.
  END METHOD.

  DESTRUCTOR PUBLIC JsonHelper ( ):

  END DESTRUCTOR.

END CLASS.