
/*------------------------------------------------------------------------
    File        : jbrest_find.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Brynjar
    Created     : Tue Oct 18 16:59:21 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

DEF INPUT PARAM ioCallParam   AS JBoxJsonParser NO-UNDO.
DEF INPUT-OUTPUT PARAM DATASET-HANDLE odsResponse.

DEF VAR cBuffsAndFlds      AS CHAR   NO-UNDO.
DEF VAR httResponseHeader  AS HANDLE NO-UNDO.
DEF VAR httResult          AS HANDLE NO-UNDO.
DEF VAR cError             AS CHAR   NO-UNDO.


DO ON ERROR UNDO, THROW:
    
  cBuffsAndFlds = ioCallParam:getResultFirstFieldValue("callparam","buffersAndFields").
  IF cBuffsAndFlds = ? THEN UNDO,THROW NEW Progress.Lang.AppError ("BuffersAndFields parameter missing",0).
          
  httResult = JBoxServerSide:Instance:getDbTableJoin(1,0
                                                    ,""
                                                    ,ioCallParam:getResultFirstFieldValue("callparam","buffersAndFields")
                                                    ,ioCallParam:getResultFirstFieldValue("callparam","queryString")
                                                    ,ioCallParam:getResultFirstFieldValue("callparam","calcFieldProc")
                                                    ,""
                                                    ,ioCallParam:getResultFirstFieldValue("callparam","queryLogFile")
                                                    ).
  cError = JBoxServerSide:Instance:serverQueryReturnMessage.      
  IF cError NE "" THEN UNDO,THROW NEW Progress.Lang.AppError (cError,0).                                              
                                                    
                                                     
END.                                                           

CREATE DATASET odsResponse.
odsResponse:NAME = "response".
odsResponse:ADD-BUFFER (httResult:DEFAULT-BUFFER-HANDLE).

CATCH eApp AS Progress.Lang.AppError :
  JBoxServerSide:Instance:AddError(eApp:GetMessage(1)).
END CATCH.  
