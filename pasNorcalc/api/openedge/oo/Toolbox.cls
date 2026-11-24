 
/*------------------------------------------------------------------------
   File        : Toolbox
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : goo@thinc.no
   Created     : Mon Sep 17 08:55:46 CEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.Toolbox: 

  DEFINE PUBLIC PROPERTY Fdato AS DATE NO-UNDO GET. PRIVATE SET. /*F�dseldato*/
  DEFINE PUBLIC PROPERTY Pnr   AS INTEGER  NO-UNDO GET. PRIVATE SET. /*Personnr*/
  def public property kjonn as char no-undo get. private set. /*Kj�nn*/

  DEFINE PROPERTY StatusMessage AS CHARACTER NO-UNDO GET. PRIVATE SET.
  def property ValidDataTypes     as char no-undo get. private set. 
  def var seqCount as int no-undo.
  
  DEFINE TEMP-TABLE ParameterList NO-UNDO
    field seqParameter      as int 
    FIELD ParameterName     AS CHARACTER
    FIELD ParameterValue    AS CHARACTER
    field ParameterType     as character
    field ParameterDataType as character
    index idxParameterName is primary ParameterName
    index idxParameterType ParameterType
    .

  /*------------------------------------------------------------------------------
   Purpose: 
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC Toolbox ():
    assign 
      ValidDatatypes     = 'I,Int,Integer,C,Char,Character,D,Date,DT,Datetime,Log,Logical,Dec,Decimal'
      .
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER convertDataType(input ipDatatype as char ):
    case ipDataType:
      when 'I' or when 'Int' then   return 'INTEGER'.
      when 'C' or when 'Char' then  return 'CHARACTER'.
      when 'D' then                 return 'DATE'.
      when 'DT' then                return 'DATETIME'.
      when 'L' or when 'Log' then   return 'LOGICAL'.
      WHEN 'Dec'then                return 'DECIMAL'.
      otherwise return ''.
    end case.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC LOGICAL checkSSN(INPUT ipSSN AS CHARACTER):
    StatusMessage = ''.
    IF LENGTH(ipSSN) NE 11 THEN DO:
      StatusMessage = 'Feil antall siffer i personnummer, skal ha 11'.
      RETURN FALSE.      
    END.
    Pnr   = int(SUBSTRING(ipSSN,7,5)).
    Fdato = getDateOfSSN(SUBSTRING(ipSSN,1,6),int(SUBSTRING(ipSSN,7,3))).
    kjonn = if lookup(substring(string(Pnr),3,1),'1,3,5,7,9') GT 0 then 'M' else 'F'.
    
    RETURN TRUE.
    
    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1) + '(' + substring(ipSSN,3,2) + ',' + substring(ipSSN,1,2) + ',' + substring(ipSSN,5,2) + ',' + substring(ipSSN,7,5) + ')'.
      RETURN FALSE.  
    END CATCH.
  END METHOD.    
  
 /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     yyyy-mm-ddThh:mm:ss.000000
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC DATETIME convertFromISODate(input ipISOdate as char ):
    if ipISOdate = '' then return ?.
    return DATETIME(INT(SUBSTR(STRING(ipISOdate),6,2)),INT(SUBSTR(STRING(ipISOdate),9,2)),INT(SUBSTR(STRING(ipISOdate),1,4)),INT(SUBSTR(STRING(ipISOdate),12,2)),INT(SUBSTR(STRING(ipISOdate),15,2)),INT(SUBSTR(STRING(ipISOdate),18,2))).
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getBufferFields(input ipBufferHandle as handle,input ipDelimiter as char  ):
    def var feltnavn as char no-undo.
    def var ii as int no-undo.

    do ii = 1 to ipBufferhandle:num-fields:      
      feltnavn = feltnavn + (if feltnavn = '' then '' else ipDelimiter) + ipBufferhandle:buffer-field(ii):name.
    end.
    return feltnavn.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC char getSSN(INPUT ipFdato AS date, input ipPnr as int):
    def var ssn as char no-undo.
    StatusMessage = ''.
    IF ipFdato = ? or ipPnr le 0 or ipPnr = ? then DO:
      StatusMessage = 'Kan ikke lage SSN grunnet feil input data, enten ? eller 0'.
      RETURN ?.      
    END.
    ssn = string(day(ipFdato),'99') + string(month(ipFdato),'99') + substring(string(year(ipFdato),'9999'),3,2) + string(ipPnr,'99999').
    checkSSN(ssn).
    return ssn.
        
    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1) + '(' + quoter(ipFdato) + string(ipPnr) + ')'.
      RETURN ?.  
    END CATCH.
  END METHOD.    

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC DATE getDateOfSSN(INPUT ipFdatePart AS CHARACTER, INPUT ipPnrPart AS INTEGER): /*6 f�rste siffer er fdato*/
      DEFINE VARIABLE IndividNummer AS INTEGER NO-UNDO.
      
      ASSIGN 
        IndividNummer = int(SUBSTRING(STRING(ipPnrPart),1,3))
        kjonn = if lookup(substring(string(ipPnrPart),3,1),'1,3,5,7,9') GT 0 then 'M' else 'F'
        .
      IF IndividNummer LE 499 THEN DO:
        Fdato = DATE(int(SUBSTRING(ipFdatePart,3,2)),int(SUBSTRING(ipFdatePart,1,2)),int('19' + substring(ipFdatePart,5,2))).
        RETURN fDato.
      END. 
      ELSE IF IndividNummer LE 999 THEN DO:
        Fdato = DATE(int(SUBSTRING(ipFdatePart,3,2)),int(SUBSTRING(ipFdatePart,1,2)),int('20' + substring(ipFdatePart,5,2))).
        RETURN Fdato.
      END.
      ELSE UNDO, THROW NEW Progress.Lang.AppError("Feil med de 3 kontrollsiffer for dato", 1).

    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1) + '(' + substring(ipFdatePart,3,2) + ',' + substring(ipFdatePart,1,2) + ',' + substring(ipFdatePart,5,2) + ',' + substring(ipFdatePart,7,5) + ')'.
      RETURN ?.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC DATE getDateOfSSN(INPUT ipSSN AS CHARACTER): /*6 f�rste siffer er fdato*/
/*    000�499 omfatter personer f�dt i perioden 1900�1999.*/
/*    500�749 omfatter personer f�dt i perioden 1854�1899.*/
/*    500�999 omfatter personer f�dt i perioden 2000�2039.*/
/*    900�999 omfatter personer f�dt i perioden 1940�1999.*/

    DEF VAR cHundreAar AS CHAR NO-UNDO.
    DEF VAR iIndividnr AS INT NO-UNDO.
    DEF VAR cY1        AS CHAR NO-UNDO. 
    DEF VAR cY2        AS CHAR NO-UNDO. 
    DEF VAR returnDate AS DATE NO-UNDO.
    
    cHundreAar = SUBSTR(ipSSN,5,2).
  
    IF LENGTH(ipSSN) = 11 THEN DO:  
      iIndividnr = INT(SUBSTR(ipSSN,7,3)) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
        cY1 = (IF cHundreAar GE SUBSTR(STRING(YEAR(TODAY),"9999"),2) THEN "19" ELSE "20").
      ELSE DO:  
        IF iIndividnr LE 499 OR (iIndividnr GE 900 AND cHundreAar GE "40") THEN
          cY1 = "19".
        ELSE IF iIndividnr LE 749 THEN   
          cY1 = "18".
        ELSE    
          cY1 = "20".
      END.    
      returnDate = DATE(INT(SUBSTR(ipSSN,3,2)),INT(SUBSTR(ipSSN,1,2)),INT(cY1 + SUBSTR(ipSSN,5,2))) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN UNDO, THROW NEW Progress.Lang.AppError('Feil dato:' + ipSSN,0).
    END.
    ELSE UNDO, THROW NEW Progress.Lang.AppError('SSN nummer er ikke 11 siffer',0).
    RETURN returnDate.
    
    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1) + '(' + quoter(ipSSN) + ')'.
      RETURN ?.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER encryptPassword(input ipPassword as char):
    
    DEFINE VARIABLE loopInteger    AS INTEGER   NO-UNDO INIT 0.
    DEFINE VARIABLE firstHashedPwd AS CHARACTER NO-UNDO.
    DEFINE VARIABLE finalHashedPwd AS RAW       NO-UNDO.
    
    DEFINE var pwdToHash AS CHARACTER NO-UNDO.
    

    finalHashedPwd = MESSAGE-DIGEST("SHA-512", ipPassword).
    firstHashedPwd = STRING(finalHashedPwd). 
                
    REPEAT WHILE loopInteger < 15000:
        finalHashedPwd = MESSAGE-DIGEST("SHA-512", finalHashedPwd).
        loopInteger = loopInteger + 1.
    END.
    
    pwdToHash = STRING(finalHashedPwd).
    RETURN pwdToHash.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:

  ------------------------------------------------------------------------------*/

  METHOD PUBLIC character HashPassword(input ipPassword as char):
    def var vHashPwd as raw no-undo.
    def var Returnvalue as char no-undo.
    def var vi as int no-undo.
    
    vi = 0.
    vHashPwd = MESSAGE-DIGEST("SHA-512", ipPassword).      
    REPEAT WHILE vi < 15000:
      vHashPwd = MESSAGE-DIGEST("SHA-512", vHashPwd).
      vi = vi + 1.
    END.
    Returnvalue = string(vHashPwd).
    vHashPwd = ?.  
    return Returnvalue.
  END METHOD.

  METHOD PUBLIC character deEncryptPassword(input ipEncryptedPassword as char, input ipEncryptionMethod as char, input BinaryKey as raw):
    /* Decrypt string. See also setEncryptedValue() */
    
    DEF VAR EncryptedValue AS RAW    NO-UNDO.
    DEF VAR DecryptedValue AS CHAR   NO-UNDO.
    
    if openedge.core.string:isNullOrEmpty(ipEncryptedPassword) then return ''.
    
    EncryptedValue = BASE64-DECODE(ipEncryptedPassword).
    
    ASSIGN SECURITY-POLICY:SYMMETRIC-ENCRYPTION-ALGORITHM = ""
           SECURITY-POLICY:SYMMETRIC-ENCRYPTION-KEY       = BinaryKey
           SECURITY-POLICY:SYMMETRIC-ENCRYPTION-IV        = ?
           DecryptedValue                                = GET-STRING(DECRYPT(EncryptedValue) , 1).
    
    RETURN DecryptedValue.

  END METHOD.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC character getListByName(input ipType as char):
    def var ix as int no-undo.
    def var returnValue as char no-undo.
    setDefaultValues().
    case length(ipType) gt 0:
      when true then do:
        for each ParameterList where ParameterList.ParameterType = ipType:
          ix = ix + 1.
          assign 
            returnValue = returnValue + ',' + ParameterList.ParameterName.
        end.
      end.
      otherwise do:
        for each ParameterList:
          ix = ix + 1.
          assign 
            returnValue = returnValue + ',' + ParameterList.ParameterName.
        end.
      end.
    end case.
    return trim(returnValue,',').
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC character getListByValue(input ipType as char):
    def var ix as int no-undo.
    def var returnValue as char no-undo.
    setDefaultValues().
    case length(ipType) gt 0:
      when true then do:
        for each ParameterList where ParameterList.ParameterType = ipType:
          ix = ix + 1.
          assign 
            returnValue = returnValue + ',' + ParameterList.ParameterValue.
        end.
      end.
      otherwise do:
        for each ParameterList:
          ix = ix + 1.
          assign 
            returnValue = returnValue + ',' + ParameterList.ParameterValue.
        end.
      end.
    end case.
    return trim(returnValue,',').
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID emptyList(  ):
    empty temp-table ParameterList.    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getParameter(input ipType as char, INPUT ipName AS CHARACTER):
    /*Run through all parameters and change ? to either '', 0 or if date keep ?*/
    setDefaultValues().
    FOR FIRST ParameterList WHERE ParameterList.ParameterType = ipType and ParameterList.ParameterName = ipName: 
      LEAVE. 
    END.
    RETURN IF AVAILABLE ParameterList THEN ParameterList.ParameterValue ELSE ''.
  END METHOD.

  METHOD PUBLIC CHARACTER getParameter(INPUT ipName AS CHARACTER):
    /*Run through all parameters and change ? to either '', 0 or if date keep ?*/
    setDefaultValues().
    FOR FIRST ParameterList WHERE ParameterList.ParameterName = ipName: 
      LEAVE. 
    END.
    RETURN IF AVAILABLE ParameterList THEN ParameterList.ParameterValue ELSE ''.
  END METHOD.

  METHOD PUBLIC CHARACTER getSearchPhrase():
    /*Run through all parameters and change ? to either '', 0 or if date keep ?*/
    setDefaultValues().
    FOR FIRST ParameterList WHERE ParameterList.ParameterName = "searchPhrase": 
      LEAVE. 
    END.
    RETURN IF AVAILABLE ParameterList THEN (IF ParameterList.ParameterValue = ? THEN '' ELSE ParameterList.ParameterValue) ELSE ''.
  END METHOD.

  METHOD PUBLIC CHARACTER getSessionId():
    /*Run through all parameters and change ? to either '', 0 or if date keep ?*/
    setDefaultValues().
    FOR FIRST ParameterList WHERE ParameterList.ParameterName = "SessionId": 
      LEAVE. 
    END.
    RETURN IF AVAILABLE ParameterList THEN (IF ParameterList.ParameterValue = ? THEN '' ELSE ParameterList.ParameterValue) ELSE ''.
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL isNULL(input ipType as char, input ipName as char ):
    for first Parameterlist where ParameterList.ParameterType = ipType and ParameterList.ParameterName = ipName: 
      leave. 
    end.
    if avail Parameterlist then if ParameterList.ParameterValue = ? then return true. else return false.
    else return true. 
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER maskText(input ipTekst as char):
    
    def var maskertTekst as char no-undo.
  
    IF INDEX(ipTekst,"@") > 0 THEN
      assign 
        maskertTekst = SUBSTRING(ipTekst, 1, 3) +  "**********" + SUBSTRING(ipTekst,INDEX(ipTekst, "@")).
    else if length(ipTekst) ge 5 then 
      maskertTekst = "****" + SUBSTRING(STRING(ipTekst), 5).
  
    return if maskertTekst <> '' then maskertTekst else ipTekst.
    

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID removeParameter(input ipType as char, input ipName as char):
    for first Parameterlist where ParameterList.ParameterType = ipType and ParameterList.ParameterName = ipName: 
      delete ParameterList. 
    end.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:

  ------------------------------------------------------------------------------*/
  METHOD PUBLIC logical getTrueFalse(input ipTrueFalseValue as char):
    def var isTrue as char no-undo.
    def var isFalse as char no-undo.
    assign 
      isTrue  = 'j,ja,sant,y,yes,t,true,1'
      isFalse = 'n,nei,usant,no,f,false,0'
      .
    if can-do(isTrue,ipTrueFalseValue) then return true.
    if can-do(isFalse,ipTrueFalseValue) then return false.
    return ?. 
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC logical setDataType(input ipType as char, INPUT ipName AS CHARACTER, input ipDatatype as char):
    FOR FIRST ParameterList WHERE ParameterList.ParameterType = ipType and ParameterList.ParameterName = ipName:
      ParameterList.ParameterDataType = convertDataType(ipDatatype). 
    END.
    return AVAILABLE ParameterList. 
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setDefaultValues(  ):
    for each ParameterList where ParameterList.ParameterValue = ?:
      if can-do('INTEGER,CHARACTER,DECIMAL',ParameterList.ParameterDataType) then do:
        if ParameterList.ParameterDataType = 'INTEGER' then ParameterList.ParameterValue = string(0).
        else if ParameterList.ParameterDataType = 'CHARACTER' then ParameterList.ParameterValue = ''.
        else if ParameterList.ParameterDataType = 'DECIMAL' then ParameterList.ParameterValue = string(0).
      end. 
      /*usikker p� hva logiske eller date* settes til*/
    end.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC logical setValue(input ipType as char, INPUT ipName AS CHARACTER,input ipValue as char):
    FOR FIRST ParameterList WHERE ParameterList.ParameterType = ipType and ParameterList.ParameterName = ipName:
      ParameterList.ParameterValue = ipValue. 
    END.
    return AVAILABLE ParameterList. 
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC logical setParameter(input ipType as char, INPUT ipName AS CHARACTER, input ipValue as char, input ipDatatype as char):
    if not can-do(ValidDataTypes,ipDatatype) then 
      undo, throw new Progress.Lang.AppError('Datatype m� ha en av f�lgnede verdier [' + ValidDataTypes + ']',1).
      
    FOR FIRST ParameterList WHERE ParameterList.ParameterType = ipType and ParameterList.ParameterName = ipName:
      LEAVE. 
    END.
    if not avail ParameterList then do:
      create ParameterList.
      assign
        seqCount = seqCount + 1
        ParameterList.seqParameter      = seqCount 
        ParameterList.ParameterName     = ipName
        ParameterList.ParameterType     = ipType
        ParameterList.ParameterValue    = ipValue
        ParameterList.ParameterDataType = convertDataType(ipDatatype)
        .
    end.
    return true.
    
    CATCH eAny AS Progress.Lang.Error :
      assign 
        StatusMessage = eAny:GetMessage(1)
        .
      return false.  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC Progress.Json.ObjectModel.JsonObject getListJSON():
    def var oJS   as class Progress.Json.ObjectModel.JsonObject no-undo.
    
    oJS = new Progress.Json.ObjectModel.JsonObject().
    FOR each ParameterList:
      case ParameterList.ParameterDataType:
        when 'INTEGER'  then oJS:Add(ParameterList.ParameterName,int(ParameterList.ParameterValue)).
        when 'DATE'     then oJS:Add(ParameterList.ParameterName,date(ParameterList.ParameterValue)).
        when 'DATETIME' then oJS:Add(ParameterList.ParameterName,datetime(ParameterList.ParameterValue)).
        when 'LOGICAL'  then oJS:Add(ParameterList.ParameterName,logical(ParameterList.ParameterValue)).
        when 'DECIMAL'  then oJS:Add(ParameterList.ParameterName,decimal(ParameterList.ParameterValue)).
        otherwise oJS:Add(ParameterList.ParameterName,ParameterList.ParameterValue).
      end case.
    END.
    return oJS.
    
    CATCH eAny AS Progress.Lang.Error :
      assign 
        StatusMessage = eAny:GetMessage(1)
        .
    END CATCH.
  END METHOD.

  method public character getQueryString (input ipType as char):
    def var returnList as char no-undo.
    for each ParameterList where ParameterList.ParameterType = ipType by seqParameter:
      returnList = returnList + (if returnList = '' then '' else '&') + ParameterList.ParameterName + '=' + ParameterList.ParameterValue.
    end.  
    return returnList.
  end method.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
     current=1&rowCount=25&searchPhrase=ast
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER buildList(input ipType as char, INPUT ipList AS CHARACTER,input ipDelimiter as char):
    DEFINE VARIABLE FieldList AS CHARACTER EXTENT NO-UNDO.
    DEFINE VARIABLE ii        AS INTEGER   NO-UNDO.
    DEFINE VARIABLE Pointer   AS INTEGER   NO-UNDO.
    
/*    bhFormField = TEMP-TABLE ParameterList:DEFAULT-BUFFER-HANDLE.*/

    EXTENT(FieldList) = NUM-ENTRIES(ipList,ipDelimiter).
    DO ii = 1 TO EXTENT(FieldList) ON ERROR UNDO, LEAVE:
      CREATE ParameterList.
      ASSIGN 
        seqCount = seqCount + 1
        ParameterList.seqParameter      = seqCount 
        FieldList[ii]                   = ENTRY(ii,ipList,ipDelimiter)
        Pointer                         = INDEX(FieldList[ii],'=')
        ParameterList.ParameterName     = SUBSTRING(FieldList[ii],1,Pointer - 1)
        ParameterList.ParameterValue    = SUBSTRING(FieldList[ii],Pointer + 1)
        ParameterList.ParameterType     = ipType
        ParameterList.ParameterDataType = 'CHARACTER'
        .
      if ParameterList.ParameterName = '' then delete ParameterList.
      if ParameterList.ParameterName begins 'Sort' then do:
        /*spesialkode for � hente sortering*/
        if index(ParameterList.ParameterName,'dir') gt 0 then do:
          setParameter(ipType,'SortDir',if ParameterList.ParameterValue <> 'desc' then '' else ParameterList.ParameterValue,'CHARACTER').
        end.
        if index(ParameterList.ParameterName,'field') gt 0 then 
           setParameter(ipType,'SortField',ParameterList.ParameterValue,'CHARACTER').
      end.
      
    END. 
    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).  
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD public character toBase64(input ipString as char ):
    /*Lager en base64string av inputstring*/
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR mp AS MEMPTR NO-UNDO.
    DEF VAR iSize AS INT NO-UNDO.
    DEF VAR myRaw AS RAW NO-UNDO.
    DEF VAR lcText AS LONGCHAR NO-UNDO.
    
    lcText = ipString.
    COPY-LOB FROM lcText TO OBJECT mp.
    lcText = BASE64-ENCODE(mp).
    iSize = LENGTH(lcText).
    PUT-STRING(myRaw,1) = lcText.
    checkblock:
    DO ix = 1 TO iSize on error undo checkblock, leave checkblock:
       IF NOT GET-STRING(myRaw,iSize - ix,1) = 'w' THEN LEAVE checkblock.
       put-byte(myRaw,iSize - ix) = ASC('=').
    END.
    lcText = get-string(myRaw,1). 
    set-size(mp) = 0.
    assign 
      mp = ?
      myRaw = ?
      .
    return string(lcText).
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:

  ------------------------------------------------------------------------------*/
  METHOD public char fromBase64 (ipString as longchar):
    /*Omformer en base64string til vanlig lesbar string*/
    def var mp as memptr no-undo.
    def var decodedBase64 as longchar no-undo.
    def var hode as char no-undo.
    def var payload as char no-undo.
    
    /*Check if _ or - and replace them with / and +*/   
    ipString = replace(replace(ipString,'_','/'),'-','+').
    
    if index(ipString,'.') gt 0 then do:
      /*id_Token handling*/
      Hode = entry(1,ipString,'.').
      Payload = entry(2,ipString,'.').
      PayLoad = PayLoad + substring("==":U, 1, (length(PayLoad) * 3) modulo 4).
      mp = base64-decode(PayLoad).
      copy-lob object mp to object decodedBase64 no-convert.
      set-size(mp) = 0.
      return string(decodedBase64).
    end.
    else do:
      ipString =  ipString + substring("==":U, 1, (length(ipString) * 3) modulo 4).
      mp = base64-decode(ipString).
      copy-lob object mp to object decodedBase64 no-convert.
      set-size(mp) = 0.
      return string(decodedBase64).
    end.
    CATCH eAny AS Progress.Lang.Error :
      assign 
        StatusMessage = 'ERROR:' + eAny:GetMessage(1) + subst('Part1:&1 Part2:&2',Hode,Payload)
        .  
      return ''.
    END CATCH.
  end method.    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes: 
  ------------------------------------------------------------------------------*/
  method public character convertToCamel (input ipText as char):
    def var word as char extent no-undo.
    def var wordLength as int no-undo.
    def var letter as char no-undo.
    def var ix as int no-undo.
    def var ii as int no-undo.
    def var newWord as char no-undo.
    def var returnText as char no-undo.
    
    if ipText = '' or ipText = ? then return ''.
    
    extent(word) = ?.
    extent(word) = num-entries(ipText,' ').
    do ix = 1 to extent(word):
      word[ix] = entry(ix,ipText,' ').
      wordLength = length(word[ix]).
      newWord = ''.
      do ii = 1 to wordLength:
        letter = substring(word[ix],ii,1).
        if ii = 1 then letter = upper(letter).
        else letter = lower(letter).
        newWord = newWord + letter.
      end.
      word[ix] = newWord.
      returnText = returnText + (if returnText = '' then '' else ' ') + word[ix].
    end.
    extent(word) = ?.
    return returnText.
    CATCH eAny AS Progress.Lang.Error :
        MESSAGE eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.
    END CATCH.
  end method.
  
  method public character URLencode (input ipURL as char, input ipEncodeType as char):
    /**************************************************************************** 
    Description: Encodes unsafe characters in a URL as per RFC 1738 section 2.2. 
    <URL:http://ds.internic.net/rfc/rfc1738.txt>;, 2.2 
    
    Input Parameters: Character string to encode, Encoding option where "query", 
    "cookie", "default" or any specified string of characters are valid. 
    
    In addition, all characters specified in the variable cUnsafe plus ASCII values 0 <= x <= 31 and 127 <= x <= 255 are considered unsafe. 
    
    Returns: Encoded string (unkown value is returned as blank) 
    Variables: cUnsafe, cReserved 
    ****************************************************************************/ 
    
    DEFINE VARIABLE cHex        AS CHARACTER   NO-UNDO INITIAL "0123456789ABCDEF":U. 
    DEFINE VARIABLE cEncodeList AS CHARACTER   NO-UNDO INITIAL "query".
    DEFINE VARIABLE cEnctype    AS CHARACTER   NO-UNDO.
    
    DEFINE VARIABLE iCounter    AS INTEGER     NO-UNDO. 
    DEFINE VARIABLE cChar       AS INTEGER     NO-UNDO. 
    
    /* Unsafe characters that must be encoded in URL's.  See RFC 1738 Sect 2.2. */
    DEFINE VARIABLE cUnsafe   AS CHARACTER NO-UNDO 
           INITIAL " <>~"#%~{}|~\^~~[]`":U.
    
    /* Reserved characters that normally are not encoded in URL's */
    DEFINE VARIABLE cReserved AS CHARACTER NO-UNDO 
           INITIAL "~;/?:@=&":U.
    /* Don't bother with blank or unknown */ 
    IF LENGTH(ipURL) EQ 0 OR 
       ipURL         EQ ? THEN 
      RETURN "". 
    
    /* What kind of encoding should be used? */ 
    CASE ipEncodeType: 
      WHEN "query":U THEN /* QUERY_STRING name=value parts */ 
        cEncodeList = cUnsafe + cReserved + "+":U. 
      WHEN "cookie":U THEN /* Persistent Cookies */ 
        cEncodeList = cUnsafe + " ,~;":U. 
      WHEN "default":U OR WHEN "" THEN /* Standard URL encoding */ 
        cEncodeList = cUnsafe. 
      OTHERWISE 
        cEncodeList = cUnsafe + cEnctype. /* user specified ... */ 
    END CASE. 
    
    /* Loop through entire input string */ 
    iCounter = 0. 
    DO WHILE TRUE: 
      ASSIGN iCounter = iCounter + 1 
             /* ASCII value of character using single byte codepage */ 
             cChar = ASC(SUBSTRING(ipURL, iCounter, 1, "RAW":U), 
                         "1252":U, 
                         "1252":U). 
      IF cChar LE 31  OR 
         cChar GE 127 OR 
         INDEX(cEncodeList, CHR(cChar)) GT 0 THEN DO: 
        /* Replace character with %hh hexidecimal triplet */ 
        SUBSTRING(ipURL, iCounter, 1, "RAW":U) = "%":U + 
          SUBSTRING(cHex, INTEGER(TRUNCATE(cChar / 16, 0)) + 1, 1, "RAW":U) + /* high */ 
          SUBSTRING(cHex, cChar MODULO 16 + 1, 1, "RAW":U). /* low digit */ 
    
        iCounter = iCounter + 2. /* skip over hex triplet just inserted */ 
      END. 
      IF iCounter EQ LENGTH(ipURL,"RAW":U) THEN LEAVE. 
    END. 
    
    return ipURL.    
    
  end method.    
  
  method public character URLdecode (input ipURL as char):
 
    DEFINE VARIABLE cChar AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cURL  AS CHARACTER NO-UNDO. /* RETURN string */
    DEFINE VARIABLE cX    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cY    AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ix    AS INTEGER   NO-UNDO.  
    DEFINE VARIABLE iy    AS INTEGER   NO-UNDO INITIAL 1.
 
    DO ix = 1 TO LENGTH(ipURL, "CHARACTER":U):
        ASSIGN
            cY = SUBSTRING(ipURL, iy, 1, "CHARACTER":U)
            cX = cY.
 
        IF cX = "%":U THEN 
            ASSIGN
                cChar = x-2-c(SUBSTRING(ipURL, iy + 1, 2, "CHARACTER":U))
                iy    = iy + 2.
        ELSE 
            cChar = cX.
 
        ASSIGN
            cURL = cURL + cChar
            iy   = iy + 1.
    END.
 
    RETURN cURL.
 
    
  end method. 
  
  method private character x-2-c (input ipHex as char):
    DEFINE VARIABLE cChar1  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cChar2  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cString AS CHARACTER NO-UNDO INITIAL "ABCDEF":U.
    DEFINE VARIABLE iDigit  AS INTEGER   NO-UNDO.  
 
    ASSIGN
        cChar1 = SUBSTRING(ipHex, 1, 1, "CHARACTER":U)
        iDigit = (IF INDEX(cString, cChar1) = 0 THEN INTEGER(cChar1)
              ELSE INDEX(cString, cChar1) + 9)
        iDigit = iDigit * 16
        cChar2 = SUBSTRING(ipHex, 2, 1, "CHARACTER":U)
        iDigit = (IF INDEX(cString, cChar2) = 0 THEN INTEGER(cChar2)
              ELSE INDEX(cString, cChar2) + 9) + iDigit.
 
    RETURN CHR(iDigit).
  end method. 
    
END CLASS.