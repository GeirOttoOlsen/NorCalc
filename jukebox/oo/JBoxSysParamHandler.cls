 
 /*------------------------------------------------------------------------
    File        : JBoxSysParamHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : admin
    Created     : Sat Nov 13 09:56:10 CET 2021
    Notes       : 

DYNAMIC-FUNCTION("getFieldValues","JBoxGenCode","WHERE cCodeType = 'URLs' AND cCodeValue = 'PanelURL' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") ,"cMisc1")
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxSysParamHandler: 
  def public property iJboxCompanyId as int no-undo get. private set.
  def public property StatusMessage as char no-undo get. private set.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC JBoxSysParamHandler (  ):
    iJBoxCompanyId = 0.
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC JBoxSysParamHandler (input iJBoxCompanyId as int):
    iJBoxCompanyId = iJBoxCompanyId.
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getSysParamCharacter(input ipParamNameType as char,input ipNameText as char  ): /*SysParamNames, SysParam*/
    def var ReturnValue as char no-undo.
    jboxserverapi:Instance:find('JBoxSysParam','where cSysParamName = ' + quoter(ipParamNameType) + ' AND cSysParamText = ' + quoter(ipNameText) + (if iJBoxCompanyId <> 0 then ' AND iJBoxCompanyId = ' + string(iJboxCompanyId) else '')).
    ReturnValue = jboxserverapi:Instance:FieldValue("JBoxSysParam.cSysParamCharValue").
    
    return ReturnValue.
    CATCH eAny AS Progress.Lang.Error :
      assign
        StatusMessage = eAny:GetMessage(1)
        . 
      return ?.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DESTRUCTOR PUBLIC JBoxSysParamHandler ( ):

  END DESTRUCTOR.
  
END CLASS.