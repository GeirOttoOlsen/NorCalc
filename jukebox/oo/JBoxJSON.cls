 
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
USING Progress.Json.*.
USING Progress.Json.ObjectModel.*.


ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxJSON INHERITS Progress.Json.ObjectModel.JsonObject: 

  DEFINE property oObject      AS CLASS JsonObject        NO-UNDO get. private set.
  DEFINE property oArray       AS CLASS JsonArray         NO-UNDO get. set.
  DEFINE VARIABLE oParser      AS CLASS ObjectModelParser NO-UNDO.
  DEFINE VARIABLE oConstructor AS CLASS JsonConstruct     NO-UNDO.
  def property Codepage as char no-undo get. set.   
  def property hasError as log  no-undo get. private set. 
  def property ErrorMsg as char no-undo get. private set. 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxJSON (  ):
    SUPER ().
    
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxJSON (ipJSON AS LONGCHAR):
    def var lc as longchar no-undo.
    fix-codepage(lc) = 'utf-8'.
    lc = ipJSON.
    oParser = NEW ObjectModelParser ().
    oConstructor = oParser:Parse(lc).
        
    oObject = CAST(oConstructor,JsonObject).
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
    oParser = NEW ObjectModelParser ().
    oConstructor = oParser:Parse(lc).
    oObject = CAST(oConstructor,JsonObject).
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

  METHOD PUBLIC void getArrayByField(input ipField as char):
    if valid-object(oObject) then 
      oArray = oObject:getJsonArray(ipField).
    
    RETURN.

  END METHOD.

END CLASS.