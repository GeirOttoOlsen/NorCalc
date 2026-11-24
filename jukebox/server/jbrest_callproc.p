
/*------------------------------------------------------------------------
    File        : jbrest_callproc.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Fri Dec 16 12:44:28 CET 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEF INPUT PARAM ioCallParam   AS JBoxJsonParser NO-UNDO.
DEF INPUT-OUTPUT PARAM DATASET-HANDLE odsResponse.

DEF VAR cProcName          AS CHAR   NO-UNDO.
DEF VAR httResponseHeader  AS HANDLE NO-UNDO.
DEF VAR cError             AS CHAR   NO-UNDO.
DEF VAR hProcParam         AS HANDLE NO-UNDO.
DEF VAR hProcData          AS HANDLE NO-UNDO.
DEF VAR hProcDataContent   AS HANDLE NO-UNDO.
DEF VAR oParam             AS oo.Parameter NO-UNDO.
DEF VAR ix                 AS INT NO-UNDO.
DEF VAR bOk                AS LOG NO-UNDO.   
DEF VAR cReturnParam       AS CHAR NO-UNDO.
DEF VAR oOutputParam       AS JBoxJsonParser NO-UNDO.

DO ON ERROR UNDO, THROW:
    
  cProcName = ioCallParam:getResultFirstFieldValue("callparam","procname").
  IF SEARCH(cProcName) = ? THEN UNDO,THROW NEW Progress.Lang.AppError ("Could not find procedure " + cProcName,0).
  
  hProcParam = ioCallParam:getResultBufferHandle("procparameter").
  IF hProcParam = ? THEN UNDO,THROW NEW Progress.Lang.AppError ("Parameter missing for " + cProcName,0).

  oParam = NEW oo.Parameter().
  bOk = hProcParam:FIND-FIRST() NO-ERROR.
  IF bOk THEN 
    DO ix = 1 TO hProcParam:NUM-FIELDS:
      IF hProcParam:BUFFER-FIELD(ix):BUFFER-VALUE NE ? THEN
        oParam:addParameter(hProcParam:BUFFER-FIELD(ix):NAME,STRING(hProcParam:BUFFER-FIELD(ix):BUFFER-VALUE)).
    END.    
  
  hProcData = ioCallParam:getResultBufferHandle("procdata").
  IF VALID-HANDLE(hProcData) THEN 
    hProcDataContent = ioCallParam:hDsResult:GET-BUFFER-HANDLE (4).

  IF VALID-HANDLE(hProcDataContent) THEN DO: 
    IF NOT JBoxServerSide:Instance:CallServerProc(cProcName,oParam:getParameters(),hProcDataContent) THEN
      UNDO,THROW NEW Progress.Lang.AppError (JBoxServerSide:Instance:getCallMessage(),0).
    hProcDataContent = JBoxServerSide:Instance:getCallReturnTable().
  END.
  ELSE DO:
    IF NOT JBoxServerSide:Instance:CallServerProc(cProcName,oParam:getParameters()) THEN
      UNDO,THROW NEW Progress.Lang.AppError (JBoxServerSide:Instance:getCallMessage(),0).
  END.      
    
  cReturnParam = JBoxServerSide:Instance:getCallReturnParam().

  IF cReturnParam NE "" THEN DO:
    oOutputParam = NEW JBoxJsonParser().
    IF oOutputParam:createSchema(cReturnParam,"returnParameter") THEN 
      httResponseHeader = oOutputParam:hDsResult:GET-BUFFER-HANDLE (1).
  END.                                                             
  IF NOT VALID-HANDLE(httResponseHeader) THEN DO:  
    CREATE TEMP-TABLE httResponseHeader.
    httResponseHeader:ADD-NEW-FIELD ("returnParameter","CHARACTER").
    httResponseHeader:TEMP-TABLE-PREPARE("responseheader").
    httResponseHeader:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE ().
    httResponseHeader:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD ("returnParameter"):BUFFER-VALUE = cReturnParam.
  END.
END.                                                           

ioCallParam:hdsResult:CLEAR().

CREATE DATASET odsResponse.
odsResponse:NAME = "response".
odsResponse:ADD-BUFFER (httResponseHeader:DEFAULT-BUFFER-HANDLE).
IF VALID-HANDLE(hProcDataContent) THEN
  odsResponse:ADD-BUFFER (hProcDataContent).

CATCH eApp AS Progress.Lang.AppError :
  JBoxServerSide:Instance:AddError(eApp:GetMessage(1)).
END CATCH.  
