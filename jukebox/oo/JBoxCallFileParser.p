
/*------------------------------------------------------------------------
    File        : JBoxCallCsvParser.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : brynj
    Created     : Wed Feb 05 12:37:36 CET 2025
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
VAR HANDLE hSourceProc. 
VAR JBoxFileParser oCsv.

/*DEF INPUT PARAM  icFileName     AS CHAR   NO-UNDO.*/
/*DEF OUTPUT PARAM TABLE-HANDLE ohTempTable.        */
/*DEF OUTPUT PARAM TABLE-HANDLE ohttSchema.         */
/*DEF OUTPUT PARAM ocErrorMessage AS CHAR   NO-UNDO.*/

    
hSourceProc = SOURCE-PROCEDURE.

SUBSCRIBE TO "InvalidateHandle" IN SOURCE-PROCEDURE.

oCsv = NEW JBoxFileParser().

/*oCsv:createFileSchema(icFileName).      */
/*IF oCsv:StatusMessage NE "" THEN RETURN.*/
/*oCsv:createImportTable().               */
/*IF oCsv:StatusMessage NE "" THEN RETURN.*/
/*                                        */
/*ASSIGN ohTempTable = oCsv:hTempTable    */
/*       ohttSchema  = oCsv:httSchema.    */
/*                                        */
/*FINALLY:                                */
/*  ocErrorMessage = oCsv:statusMessage.  */
/*END FINALLY.                            */

PROCEDURE importFileList:
  DEF INPUT PARAM  icFileList     AS CHAR   NO-UNDO.
  DEF OUTPUT PARAM ohTempTable    AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM ocErrorMessage AS CHAR   NO-UNDO.

  IF oCsv:importFileList(icFileList) THEN 
    ohTempTable = oCsv:hTempTable.

  FINALLY:
    ocErrorMessage = oCsv:statusMessage.  
  END FINALLY.    

END PROCEDURE.

PROCEDURE getSample:
  DEF INPUT PARAM  icFileName     AS CHAR   NO-UNDO.
  DEF OUTPUT PARAM ohTempTable    AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM ohSchemaTable  AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM ocErrorMessage AS CHAR   NO-UNDO.

  VAR INTEGER ix.
  VAR CHARACTER selectedFields.
  VAR CHARACTER errorLog.
  
  oCsv:TableName = "".
  
  IF oCsv:getSample(icFileName) THEN
    ASSIGN ohTempTable = oCsv:hTempTable
           ohSchemaTable = oCsv:httSchema.

  errorLog = oCsv:getErrorLog().
  IF errorLog NE "" THEN
    JBoxSession:Instance:ViewMessageInNotepad(errorLog).

  FINALLY:
    ocErrorMessage = oCsv:statusMessage.  
  END FINALLY.    

END PROCEDURE.

PROCEDURE getAll:
  DEF INPUT  PARAM icFileList              AS CHAR   NO-UNDO.
  DEF INPUT  PARAM icFieldList             AS CHAR   NO-UNDO.
  DEF INPUT  PARAM icIndexedFields         AS CHAR   NO-UNDO.
  DEF INPUT  PARAM icFlatFileFilterFields  AS CHAR NO-UNDO.
  DEF INPUT  PARAM icFlatFileOperInUseList AS CHAR NO-UNDO.
  DEF INPUT  PARAM icFlatFileFilterValList AS CHAR NO-UNDO.
  DEF INPUT  PARAM icFlatFileTableName     AS CHAR NO-UNDO.
  DEF INPUT  PARAM iiFlatFileMaxRows       AS INT NO-UNDO.
  DEF INPUT  PARAM iiFlatFileSampleMaxRows AS INT NO-UNDO.
  DEF INPUT  PARAM icFlatFileCodePage      AS CHAR NO-UNDO.
  DEF OUTPUT PARAM ohTempTable             AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM ohSchemaTable           AS HANDLE NO-UNDO.
  DEF OUTPUT PARAM ocErrorMessage          AS CHAR   NO-UNDO.

  VAR INTEGER ix.
  VAR CHARACTER selectedFields.
  
  ASSIGN oCsv:TableName                = icFlatFileTableName
         oCsv:maxImportRows            = iiFlatFileMaxRows
         oCsv:maxSampleRows            = iiFlatFileSampleMaxRows
         oCsv:importFilterFields       = icFlatFileFilterFields
         oCsv:importFilterOperators    = icFlatFileOperInUseList
         oCsv:importFilterValues       = icFlatFileFilterValList
         oCsv:fileCodePage             = icFlatFileCodePage
         .
         
  IF oCsv:getAll(icFileList,icFieldList,icIndexedFields) THEN
    ASSIGN ohTempTable = oCsv:hTempTable
           ohSchemaTable = oCsv:httSchema.

  FINALLY:
    ocErrorMessage = oCsv:statusMessage.  
  END FINALLY.    
END PROCEDURE.

PROCEDURE InvalidateHandle:
  DEF INPUT PARAM ihCaller AS HANDLE NO-UNDO.
  IF ihCaller = hSourceProc THEN DO:
    DELETE OBJECT oCsv.
    DELETE PROCEDURE THIS-PROCEDURE.
  END.  
END PROCEDURE.      