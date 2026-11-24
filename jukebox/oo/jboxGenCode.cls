 
 /*------------------------------------------------------------------------
    File        : jboxGenCode
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Wed Feb 21 15:12:11 CET 2024
    Notes       : 

DYNAMIC-FUNCTION("getFieldValues","JBoxGenCode","WHERE cCodeType = 'URLs' AND cCodeValue = 'PanelURL' AND iJBoxCompanyId = " + DYNAMIC-FUNCTION("getCompanyId") ,"cMisc1")
      
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS jboxGenCode: 

    DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxGenCode NO-UNDO
       GET():
         IF Instance = ? THEN Instance = NEW JBoxGenCode().
         RETURN Instance.
       END GET.
       protected SET.
    def property CompanyId as int no-undo 
      get():
        return jboxsession:Instance:CompanyId.        
      end get. protected set.
    def public property StatusMessage as char no-undo get. protected set.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC jboxGenCode (  ):
    
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
          undo, throw new Progress.Lang.AppError(substitute('JBoxGenCode ikke tilgjengelig med type: &1 og språk:&2',ipGenCodeType,ipGenCodeLanguage),0).
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC character getGenCodeList(input ipGenCodeType as char,input ipGenCodeLanguage as char,input ipReturnField as char ):
    def var list as char no-undo.
    StatusMessage = ''.
    if can-do('',ipReturnField) then 
      undo, throw new Progress.Lang.AppError('Feil returfelt, må være et av følgende:Description,Misc1,Misc2',0).
      
    if not JBoxServerAPI:Instance:Find('jboxGenCodeType',substitute('where cCodeType = "&1"',ipGenCodeType)) then
      undo,throw new Progress.Lang.AppError(substitute('JBoxGenCodeType ikke tilgjengelig for CodeType:&1',ipGenCodeType),0).

    case ipReturnField:
      when 'CodeValue' or when 'cCodeValue' then  
        return JBoxServerAPI:Instance:FieldListValid('jboxGenCode;cCodeValue',substitute('where cCodeType = "&1" and cLanguage = "&2" and iJBoxCompanyId = &3',ipGenCodeType,ipGenCodeLanguage,CompanyId)).
      when '2xCodeValue' or when '2xcCodeValue' then  
        return JBoxServerAPI:Instance:FieldListValid('jboxGenCode;cCodeValue;cCodeValue',substitute('where cCodeType = "&1" and cLanguage = "&2" and iJBoxCompanyId = &3',ipGenCodeType,ipGenCodeLanguage,CompanyId)).
      when 'Misc1' or when 'cMisc1' then 
        return JBoxServerAPI:Instance:FieldListValid('jboxGenCode;cMisc1',substitute('where cCodeType = "&1" and cLanguage = "&2" and iJBoxCompanyId = &3',ipGenCodeType,ipGenCodeLanguage,CompanyId)).
      when 'Misc2' or when 'cMisc2' then 
        List =  JBoxServerAPI:Instance:FieldListValid('jboxGenCode;cMisc2',substitute('where cCodeType = "&1" and cLanguage = "&2" and iJBoxCompanyId = &3',ipGenCodeType,ipGenCodeLanguage,CompanyId)).
      otherwise 
        return 'N/A'.
    end case.
    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).  
    END CATCH.
  END METHOD.

  DESTRUCTOR PUBLIC jboxGenCode ( ):

  END DESTRUCTOR.

END CLASS.