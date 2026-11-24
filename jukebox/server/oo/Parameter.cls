 
 /*------------------------------------------------------------------------
    File        : Parameter
    Purpose     : Benyttes for å bygge og hente parametre fra temp-table via json
    Syntax      : 
    Description : 
    Author(s)   : goo_000
    Created     : Tue Mar 19 08:32:06 CET 2019
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.Parameter: 
  DEFINE TEMP-TABLE ttParameter NO-UNDO
    FIELD ParameterName  AS CHARACTER
    FIELD ParameterValue AS CHARACTER
    .
    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC Parameter (  ):
      
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE DATE convertDate(INPUT ipValue AS CHARACTER  ):
    DEFINE VARIABLE returnDate AS DATE NO-UNDO.
    IF LENGTH(ipValue) = 10 AND num-entries(ipValue,'-') GT 2 AND length(ENTRY(1,ipValue,'-')) = 4 THEN DO:
      returnDate = DATE(int(ENTRY(2,ipValue,'-')),int(ENTRY(3,ipValue,'-')),int(ENTRY(1,ipValue,'-'))).
    END.
    ELSE DO: /**/
      returnDate = DATE(ipValue).
    END.
    RETURN returnDate.
  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID addParameter(INPUT ipName AS CHARACTER, INPUT ipValue AS CHARACTER  ):
    find first ttParameter where ttParameter.ParameterName = ipName no-error.
    if not avail ttParameter then 
      CREATE ttParameter.
    ASSIGN 
      ttParameter.ParameterName  = ipName
      ttParameter.ParameterValue = ipValue
      .
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID addParameters(INPUT ipParameters AS Progress.Json.ObjectModel.JsonObject):
    DEFINE VARIABLE Fieldlist AS CHARACTER EXTENT NO-UNDO.
    DEFINE VARIABLE i AS INTEGER NO-UNDO.
    DEFINE VARIABLE Felt AS CHARACTER NO-UNDO.
    DEFINE VARIABLE FeltVerdi AS CHARACTER NO-UNDO.
    DEFINE VARIABLE FeltDato AS DATE NO-UNDO.

    Fieldlist = ipParameters:GetNames().
    DO i = 1 TO EXTENT(Fieldlist):
      Felt = Fieldlist[i].
      FeltVerdi = ipParameters:GetJsonText(Felt).
      CREATE ttParameter.
      ASSIGN 
        ttParameter.ParameterName  = Felt
        ttParameter.ParameterValue = FeltVerdi
        .
    END.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID addParameters(INPUT ipValues AS CHARACTER):
    DEFINE VARIABLE lcString AS LONGCHAR NO-UNDO.
    lcString = ipValues.
    TEMP-TABLE ttParameter:HANDLE:READ-JSON ('longchar',lcString,'empty').
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID deleteParameter(INPUT ipName AS CHARACTER ):
    FIND ttParameter WHERE ttParameter.ParameterName = ipName NO-ERROR.
    IF AVAILABLE ttParameter THEN DELETE ttParameter.
        
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID destroyParameters(  ):
    EMPTY TEMP-TABLE ttParameter.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getParameter(INPUT ipName AS CHARACTER  ):
    FIND FIRST ttParameter WHERE ttParameter.ParameterName = ipName NO-LOCK NO-ERROR.
    IF AVAILABLE ttParameter THEN RETURN ttParameter.ParameterValue. ELSE RETURN ?.        
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC DATE getParameterDate(INPUT ipName AS CHARACTER  ):
    FIND FIRST ttParameter WHERE ttParameter.ParameterName = ipName NO-LOCK NO-ERROR.
    IF AVAILABLE ttParameter THEN RETURN convertDate(ttParameter.ParameterValue).        
  END METHOD.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getParameters(  ):
    DEFINE VARIABLE result AS LONGCHAR NO-UNDO.
    TEMP-TABLE ttParameter:HANDLE:WRITE-JSON ('longchar',result,FALSE).
    IF LENGTH(result) GT 32000 THEN UNDO, THROW NEW Progress.Lang.AppError('Kan ikke være lengre enn 32Kb', 1).
    
    RETURN STRING(result).
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getParametersByDelimiter(INPUT ipDelimiter AS CHARACTER):
    DEFINE VARIABLE result AS LONGCHAR NO-UNDO.
    FOR EACH ttParameter:
      result = result + ttParameter.ParameterValue + ipDelimiter.
    END.
    result = RIGHT-TRIM(result,ipDelimiter).
    IF LENGTH(result) GT 32000 THEN UNDO, THROW NEW Progress.Lang.AppError('Kan ikke være lengre enn 32Kb', 1).
    
    RETURN STRING(result).
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getParameterNamesByDelimiter(INPUT ipDelimiter AS CHARACTER):
    DEFINE VARIABLE result AS LONGCHAR NO-UNDO.
    FOR EACH ttParameter:
      result = result + ttParameter.ParameterName + ipDelimiter.
    END.
    result = RIGHT-TRIM(result,ipDelimiter).
    IF LENGTH(result) GT 32000 THEN UNDO, THROW NEW Progress.Lang.AppError('Kan ikke være lengre enn 32Kb', 1).
    
    RETURN STRING(result).
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes: Brukes for å kunne sende json StatusCode og StatusMessage tilbake fra serversiden
   Denne metoden er kun for å sjekke at både StatusCode og StatusMessage er satt...
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL isValidStatusValue(INPUT ipReturnValue AS CHARACTER):
    DEFINE VARIABLE oJson AS CLASS JBoxJSON NO-UNDO.
    oJson = NEW JBoxJSON().
    oJson:buildJSON(ipReturnValue).
    IF NOT oJson:hasError AND oJson:oObject:Has('StatusCode') AND oJson:oObject:Has('StatusMessage') THEN DO:
      addParameters(oJson:oObject).
      RETURN TRUE.
    END.
    
    RETURN FALSE.
    
    CATCH eAny AS Progress.Lang.Error :
      MESSAGE eAny:GetMessage(1)
      VIEW-AS ALERT-BOX.
    END CATCH.
  END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC Parameter ( ):

	END DESTRUCTOR.

END CLASS.