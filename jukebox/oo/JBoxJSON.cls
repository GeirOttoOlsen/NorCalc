 
/*------------------------------------------------------------------------
   File        : JboxJSON
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : goo_000
   Created     : Wed Nov 08 10:17:32 CET 2017
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.


ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxJSON INHERITS Progress.Json.ObjectModel.JsonObject: 

  DEFINE public property oObject      AS CLASS Progress.Json.ObjectModel.JsonObject              NO-UNDO get. private set.
  DEFINE public property oArray       AS CLASS Progress.Json.ObjectModel.JsonArray               NO-UNDO get. set.
  def var oJH as class JsonHelper no-undo.
  
  DEFINE VARIABLE oParser      AS CLASS Progress.Json.ObjectModel.ObjectModelParser NO-UNDO.
  DEFINE VARIABLE oConstructor AS CLASS Progress.Json.ObjectModel.JsonConstruct     NO-UNDO.
  def property Codepage as char no-undo get. set.   
  def property hasError as log  no-undo get. private set. 
  def property ErrorMsg as char no-undo get. private set. 

    def var FieldMapping as handle extent no-undo. /*Mapper jsonObject's name to buffer-field(...)*/
    def var jsonFields as char extent no-undo.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxJSON (  ):
    SUPER ().
    oJH = new JsonHelper().    
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxJSON (ipJSON AS LONGCHAR):
    def var lc as longchar no-undo.
    fix-codepage(lc) = 'utf-8'.
    lc = ipJSON.
    oParser = NEW Progress.Json.ObjectModel.ObjectModelParser ().
    oConstructor = oParser:Parse(lc).
        
    oObject = CAST(oConstructor,Progress.Json.ObjectModel.JsonObject).
    oJH = new JsonHelper().    
    
  END CONSTRUCTOR.



  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     string(oJson:oObject:GetJsonText('a'))
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC void buildJSON(ipJSON as longchar  ):
    def var lc as longchar no-undo.
    fix-codepage(lc) = 'utf-8'.
    lc = ipJSON.
    oParser = NEW Progress.Json.ObjectModel.ObjectModelParser ().
    oConstructor = oParser:Parse(lc).
    oObject = CAST(oConstructor,Progress.Json.ObjectModel.JsonObject).
    RETURN.
    CATCH eAny AS Progress.Lang.Error :
      assign 
        hasError = true
        ErrorMsg = eAny:GetMessage(1)
        .  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     string(oJson:oObject:GetJsonText('a'))
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC void buildJSONArray(ipJSON as longchar  ):
    def var lc as longchar no-undo.
    fix-codepage(lc) = 'utf-8'.
    lc = ipJSON.
    oParser = NEW Progress.Json.ObjectModel.ObjectModelParser ().
    oConstructor = oParser:Parse(lc).
    oArray = CAST(oConstructor,Progress.Json.ObjectModel.JsonArray).
    RETURN.
    CATCH eAny AS Progress.Lang.Error :
      assign 
        hasError = true
        ErrorMsg = eAny:GetMessage(1)
        .  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID BuildBufferByJSON(input ipBuffer as handle, input ipObject as Progress.Json.ObjectModel.JsonObject ):
    def var ii as int no-undo.

    jsonFields = ipObject:GetNames().
    extent(FieldMapping) = extent(jsonFields).
    setFieldMapping(ipBuffer).
    
    ipBuffer:buffer-create().
    do ii = 1 to extent(jsonFields):
      if valid-handle(FieldMapping[ii]) then 
        oJH:setFieldValue(FieldMapping[ii],jsonFields[ii],ipObject).
    end.
    
      
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC void getArrayByField(input ipField as char):
    if valid-object(oObject) then 
      oArray = oObject:getJsonArray(ipField).
    
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC void setFieldMapping(input ipBuffer as handle):
    def var iFields as int no-undo.
    def var hField as handle no-undo.

    do iFields = 1 to extent(jsonFields):
      hField = oJH:getBufferField(ipBuffer, jsonFields[iFields]).
      if valid-handle(hField) then
        FieldMapping[iFields] = hField.
    end.
  END METHOD.

END CLASS.