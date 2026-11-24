 
 /*------------------------------------------------------------------------
    File        : JBoxServerAPI
    Purpose     : Singleton for database operations
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Tue Mar 15 10:03:36 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxServerAPI: 

  DEFINE VARIABLE bSourceProcSet   AS LOG NO-UNDO.
  DEFINE VARIABLE bOk              AS LOG NO-UNDO.
  DEFINE VARIABLE cSelectorProg    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hMySourceProc    AS HANDLE NO-UNDO. /* For keeping source-proc when calling UI with call-back option (where source-proc might be changed) */
  DEFINE VARIABLE cCallFromMethod  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hLookupTtQuery   AS HANDLE NO-UNDO.
  DEFINE VARIABLE cTTname          AS CHARACTER NO-UNDO.

  DEFINE TEMP-TABLE ttCallstack
      FIELD hSourceProc    AS HANDLE
      FIELD cMethod        AS CHARACTER
      FIELD cParam         AS CHARACTER
      FIELD bSuccess       AS LOG
      FIELD cMessage       AS CHARACTER
      FIELD cReturnParam   AS CHARACTER
      FIELD hReturnHandle  AS HANDLE
      .

  DEFINE TEMP-TABLE ttFieldValue
      FIELD hSourceProc AS HANDLE
      FIELD cBuffer AS CHARACTER 
      FIELD cField  AS CHARACTER 
      FIELD cValue  AS CHARACTER.    

  DEF TEMP-TABLE ttDataSource
      FIELD DataSourceName AS CHAR
      FIELD ConnectionFile AS CHAR.

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxServerAPI NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxServerAPI().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEFINE PUBLIC PROPERTY hSourceProc      AS HANDLE GET. SET.

  DEFINE PUBLIC PROPERTY ttCallStackHandle AS HANDLE NO-UNDO
         GET(): 
           RETURN BUFFER ttCallstack:HANDLE. END GET.
         PROTECTED SET.

  DEFINE PUBLIC PROPERTY ttFieldValueHandle AS HANDLE NO-UNDO
         GET(): 
           RETURN BUFFER ttFieldValue:HANDLE. END GET.
         PROTECTED SET.

  DEFINE PUBLIC PROPERTY LookupOk AS LOG NO-UNDO
         GET. PROTECTED SET.
         
  DEFINE PUBLIC PROPERTY SelectorOk AS LOG NO-UNDO
         GET. PROTECTED SET.
         
  DEFINE PUBLIC PROPERTY SelectorRowidList AS CHARACTER NO-UNDO
         GET():
           ASSIGN hSourceProc    = hMySourceProc    
                  bSourceProcSet = YES.
           RETURN THIS-OBJECT:FieldValue("JBoxSelector.RowidList").
         END GET. PROTECTED SET.

  DEFINE PUBLIC PROPERTY SelectorReturnValueList AS CHARACTER NO-UNDO
         GET():
           ASSIGN hSourceProc    = hMySourceProc    
                  bSourceProcSet = YES.
           RETURN THIS-OBJECT:FieldValue("JBoxSelector.ReturnValueList").
         END GET. PROTECTED SET.
  
  DEFINE PUBLIC PROPERTY SelectorDeselectRowidList AS CHARACTER GET. SET.  

  DEFINE PUBLIC PROPERTY SELECTOR-PANEL-HANDLE AS HANDLE GET. SET.

  DEFINE PUBLIC PROPERTY LastCreatedRowid AS CHARACTER GET. PROTECTED SET.  

  DEFINE PUBLIC PROPERTY serverTransInputParam AS CHARACTER PROTECTED GET. 
         SET(icParam AS CHARACTER):
           DYNAMIC-FUNCTION("setServerTransInputParam",icParam).
         END SET.  

  DEFINE PUBLIC PROPERTY serverTransReturnParam AS CHARACTER 
         GET():
           RETURN DYNAMIC-FUNCTION("getServerTransReturnParam").
         END SET.
         PROTECTED SET.  

  DEFINE PUBLIC PROPERTY serverTransReturnMessage AS CHARACTER 
         GET():
           RETURN DYNAMIC-FUNCTION("getTransactionMessage").
         END SET.
         PROTECTED SET.
           
  DEFINE PUBLIC PROPERTY sessionId AS CHARACTER PROTECTED GET. 
         SET(icSessionId AS CHARACTER):
           DYNAMIC-FUNCTION("setSessionId",icSessionId).
         END SET.  
    
  DEFINE PUBLIC PROPERTY queryLogFile AS CHARACTER GET.
         SET(icLogFile AS CHARACTER):
           queryLogFile = icLogFile.
           DYNAMIC-FUNCTION("setASlibBehaviour","QueryLogFile|" + icLogFile).   
         END SET.

  DEFINE PUBLIC PROPERTY transactionLogFile AS CHARACTER GET.
         SET(icLogFile AS CHARACTER):
           transactionLogFile = icLogFile.
           DYNAMIC-FUNCTION("setASlibBehaviour","TransLogFile|" + icLogFile).   
         END SET.

  /* To force no replace when returning DS from CallServerProc */
  DEFINE PUBLIC PROPERTY DatasetReplace AS LOGICAL INIT YES NO-UNDO GET. SET.
		
  DEFINE PUBLIC PROPERTY hbttCallStack AS HANDLE NO-UNDO GET. PROTECTED SET.		
		
	CONSTRUCTOR PRIVATE JBoxServerAPI ():
	  IF SESSION:DISPLAY-TYPE = "TTY" THEN
      RUN JBoxLoadLib.p ("JBoxASlib.p,JBoxUIlib.p,JBoxFUlib.p").
    ELSE 
      RUN JBoxLoadLib.p ("ResizeLib.p,JBoxASlib.p,JBoxUIlib.p,JBoxFUlib.p" + (IF SEARCH("controls.dll") NE ? AND PROCESS-ARCHITECTURE = 32 THEN ",controls.p" ELSE "")).
/*    RUN JBoxServerAPI_helper.p PERSIST SET hServerApiHelper (THIS-OBJECT).    */
    hbttCallStack = BUFFER ttCallstack:HANDLE.
  END CONSTRUCTOR.

  METHOD PUBLIC VOID Initiate():
    
  END METHOD.

  METHOD PUBLIC LOGICAL Create(icTableName        AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomCreateProc AS CHARACTER
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG
                              ,icParameter        AS CHARACTER):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    DYNAMIC-FUNCTION("setPostUpdProc",icPostUpdateProc).
    DYNAMIC-FUNCTION("setServerTransInputParam",icParameter).
        
    bOk = DYNAMIC-FUNCTION("DoCreate",icTableName,
                  IF icCustomUpdValProc NE "" THEN
                    LEFT-TRIM(RIGHT-TRIM(icCustomUpdValProc + ",=" +
                                         icCustomCreateProc,",="),",")
                  ELSE IF icCustomCreateProc NE "" THEN
                    ",=" + icCustomCreateProc
                  ELSE "",
                  icFieldList,
                  icValueList,
                  ibCommit). 
    CreateCall(icTableName,bOk,?).
    IF ibCommit THEN
      THIS-OBJECT:LastCreatedRowid = DYNAMIC-FUNCTION("DoRefetchValues","RowIdent1","FIRST","").
    RETURN bOk.       
  END METHOD.

  METHOD PUBLIC LOGICAL Create(icTableName        AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomCreateProc AS CHARACTER
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER):
                                   
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    bSourceProcSet = YES.
    
    RETURN THIS-OBJECT:Create(icTableName,icFieldList,icValueList,icCustomCreateProc,icCustomUpdValProc,icPostUpdateProc,YES,"").
  END METHOD.

  METHOD PUBLIC LOGICAL Create(icTableName        AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomCreateProc AS CHARACTER
                              ,ibValidate         AS LOG):
                                   
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    bSourceProcSet = YES.
    
    RETURN THIS-OBJECT:Create(icTableName,icFieldList,icValueList,icCustomCreateProc,IF ibValidate THEN "" ELSE "NO","",YES,"").
  END METHOD.

  METHOD PUBLIC LOGICAL Create(icTableName        AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomCreateProc AS CHARACTER
                              ,ibValidate         AS LOG
                              ,icPostUpdateProc   AS CHARACTER):
                                   
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    bSourceProcSet = YES.
    
    RETURN THIS-OBJECT:Create(icTableName,icFieldList,icValueList,icCustomCreateProc,IF ibValidate THEN "" ELSE "NO",icPostUpdateProc,YES,"").
  END METHOD.

  METHOD PUBLIC LOGICAL Create(icTableName        AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG):
                                   
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    bSourceProcSet = YES.
    
    RETURN THIS-OBJECT:Create(icTableName,icFieldList,icValueList,"",IF ibValidate THEN "" ELSE "NO","",YES,"").
  END METHOD.

  METHOD PUBLIC LOGICAL Create(icTableName        AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,ibCommit           AS LOG):
                                   
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    bSourceProcSet = YES.
    
    RETURN THIS-OBJECT:Create(icTableName,icFieldList,icValueList,"",IF ibValidate THEN "" ELSE "NO","",ibCommit,"").
  END METHOD.

  METHOD PUBLIC LOGICAL Create(icTableName        AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER):  /* pipe or chr(1) sep */
                                   
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    
    RETURN THIS-OBJECT:Create(icTableName,icFieldList,icValueList,"","NO","",YES,"").
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER LastCreatedFieldValue( INPUT icFieldName AS CHARACTER ):
    
    RETURN DYNAMIC-FUNCTION("DoRefetchValues",icFieldName,"FIRST","").

  END METHOD.

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG
                              ,icParameter        AS CHARACTER):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    DYNAMIC-FUNCTION("setPostUpdProc",icPostUpdateProc).
    DYNAMIC-FUNCTION("setServerTransInputParam",icParameter).
        
    bOk = DYNAMIC-FUNCTION("DoUpdate",icTableName,
                  IF NOT CAN-DO("no,ignore",icCustomUpdValProc) AND icCustomUpdValProc NE "" THEN 
                     "=" + LEFT-TRIM(icCustomUpdValProc,"=")
                  ELSE IF icCustomUpdValProc = "no" THEN "ignore"
                  ELSE icCustomUpdValProc,
                  icKeyFieldList,
                  icKeyValueList,
                  icFieldList,
                  icValueList,
                  ibCommit). 
    CreateCall(icTableName,bOk,?).
    RETURN bOk.       
  END METHOD.

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    RETURN THIS-OBJECT:Update(icTableName,icKeyFieldList,icKeyValueList,icFieldList,icValueList,icCustomUpdValProc,icPostUpdateProc,YES,"").
  END METHOD.

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,icKeyFieldList,icKeyValueList,icFieldList,icValueList,icCustomUpdValProc,icPostUpdateProc,YES,"").
  END METHOD.

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,icParameter        AS CHARACTER):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,icKeyFieldList,icKeyValueList,icFieldList,icValueList,icCustomUpdValProc,icPostUpdateProc,YES,icParameter).
  END METHOD.

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,"",icRowId,icFieldList,icValueList,IF ibValidate THEN "" ELSE "NO","",YES,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,icKeyFieldList,icKeyValueList,icFieldList,icValueList,IF ibValidate THEN "" ELSE "NO","",YES,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,ibCommit           AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,icKeyFieldList,icKeyValueList,icFieldList,icValueList,IF ibValidate THEN "" ELSE "NO","",ibCommit,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,ibCommit           AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,"",icRowId,icFieldList,icValueList,IF ibValidate THEN "" ELSE "NO","",ibCommit,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER):   /* pipe or chr(1) sep */
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,"",icRowId,icFieldList,icValueList,"NO","",YES,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,"",icRowId,icFieldList,icValueList,IF ibValidate THEN "" ELSE "NO",icPostUpdateProc,ibCommit,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG
                              ,icParameter        AS CHARACTER):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,"",icRowId,icFieldList,icValueList,IF ibValidate THEN "" ELSE "NO",icPostUpdateProc,ibCommit,icParameter).
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,"",icRowId,icFieldList,icValueList,icCustomUpdValProc,icPostUpdateProc,ibCommit,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Update(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER
                              ,icFieldList        AS CHARACTER
                              ,icValueList        AS CHARACTER   /* pipe or chr(1) sep */
                              ,icCustomUpdValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG
                              ,icParameter        AS CHARACTER):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Update(icTableName,"",icRowId,icFieldList,icValueList,icCustomUpdValProc,icPostUpdateProc,ibCommit,icParameter).
  END METHOD.    

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomDeleteValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG
                              ,icParameter        AS CHARACTER):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    DYNAMIC-FUNCTION("setPostUpdProc",icPostUpdateProc).
    DYNAMIC-FUNCTION("setServerTransInputParam",icParameter).
        
    bOk = DYNAMIC-FUNCTION("DoDelete",icTableName,
                  IF NOT CAN-DO("no,ignore",icCustomDeleteValProc) AND icCustomDeleteValProc NE "" THEN 
                     "=" + LEFT-TRIM(icCustomDeleteValProc,"=")
                  ELSE IF icCustomDeleteValProc = "no" THEN "ignore"
                  ELSE icCustomDeleteValProc,
                  icKeyFieldList,
                  icKeyValueList,
                  ibCommit). 
    CreateCall(icTableName,bOk,?).
    RETURN bOk.       
  END METHOD.

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomDeleteValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER
                              ,ibCommit           AS LOG):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    RETURN THIS-OBJECT:Delete(icTableName, icKeyFieldList, icKeyValueList, icCustomDeleteValProc, icPostUpdateProc, ibCommit, "").        

  END METHOD.
                              

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,icCustomDeleteValProc AS CHARACTER
                              ,icPostUpdateProc   AS CHARACTER):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    RETURN THIS-OBJECT:Delete(icTableName, icKeyFieldList, icKeyValueList, icCustomDeleteValProc, icPostUpdateProc, YES, "").        

  END METHOD.

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,icPostUpdateProc   AS CHARACTER):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    RETURN THIS-OBJECT:Delete(icTableName, icKeyFieldList, icKeyValueList, IF ibValidate THEN "" ELSE "NO", icPostUpdateProc, YES, "").        

  END METHOD.

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icKeyFieldList     AS CHARACTER
                              ,icKeyValueList     AS CHARACTER  /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,ibCommit           AS LOG):
          
    IF NOT bSourceProcSet THEN                                 
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    RETURN THIS-OBJECT:Delete(icTableName, icKeyFieldList, icKeyValueList, IF ibValidate THEN "" ELSE "NO", "", ibCommit, "").        

  END METHOD.

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER  /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Delete(icTableName,"",icRowId,IF ibValidate THEN "" ELSE "NO","",YES, "").
  END METHOD.    

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER  /* pipe or chr(1) sep */
                              ,ibValidate         AS LOG
                              ,ibCommit           AS LOG):
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Delete(icTableName,"",icRowId,IF ibValidate THEN "" ELSE "NO","",ibCommit,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Delete(icTableName        AS CHARACTER
                              ,icRowid            AS CHARACTER):  /* pipe or chr(1) sep */
          
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
      
    RETURN THIS-OBJECT:Delete(icTableName,"",icRowId,"NO","",YES,"").
  END METHOD.    

  METHOD PUBLIC LOGICAL Commit():
    RETURN DYNAMIC-FUNCTION("DoCommit",YES).
  END METHOD.    

  METHOD PUBLIC CHARACTER FieldList(icBuffersAndFields AS CHARACTER
                                   ,icQueryCrit        AS CHARACTER):
    RETURN DYNAMIC-FUNCTION("getFieldList",icBuffersAndFields,IF NOT icQueryCrit BEGINS "FIRST " THEN "WHERE " + (IF icQueryCrit BEGINS "WHERE " THEN SUBSTR(icQueryCrit,7) ELSE icQueryCrit) ELSE icQueryCrit).                                        
  END METHOD.                                        
  METHOD PUBLIC CHARACTER FieldList(icBuffersAndFields AS CHARACTER
                                   ,icQueryCrit        AS CHARACTER
                                   ,icDelimiter        AS CHARACTER):
    RETURN REPLACE(THIS-OBJECT:FieldList(icBuffersAndFields,icQueryCrit),"|",icDelimiter).                                        
  END METHOD.                                        
  METHOD PUBLIC CHARACTER FieldListValid(icBuffersAndFields AS CHARACTER
                                        ,icQueryCrit        AS CHARACTER):
    DEFINE VARIABLE cList AS CHARACTER NO-UNDO.                                      
    cList = THIS-OBJECT:FieldList(icBuffersAndFields,icQueryCrit).
    IF cList = "" THEN cList = "|".
    RETURN cList.                                        
  END METHOD.                                        
  METHOD PUBLIC CHARACTER FieldListFirst(icBuffersAndFields AS CHARACTER
                                        ,icQueryCrit        AS CHARACTER):
    
    IF NOT icQueryCrit BEGINS "FIRST " THEN 
      icQueryCrit = "FIRST WHERE " + (IF icQueryCrit BEGINS "WHERE " THEN SUBSTR(icQueryCrit,7) ELSE icQueryCrit).
                                          
    RETURN THIS-OBJECT:FieldList(icBuffersAndFields,icQueryCrit).
  END METHOD.                                        

  METHOD PUBLIC CHARACTER FieldList(icBuffersAndFields AS CHARACTER
                                   ,icQueryCrit        AS CHARACTER
                                   ,icDelimiter        AS CHARACTER
                                   ,icSqlDb            AS CHAR):

    DEF VAR oQuery          AS JBoxQuery NO-UNDO.
    DEF VAR ix              AS INT  NO-UNDO.
    DEF VAR iy              AS INT  NO-UNDO.
    DEF VAR iz              AS INT  NO-UNDO.
    DEF VAR cEntry          AS CHAR NO-UNDO.
    DEF VAR cFld            AS CHAR NO-UNDO.
    DEF VAR cFields         AS CHAR NO-UNDO.
    DEF VAR cModBuffAndFlds AS CHAR NO-UNDO.
    DEF VAR cConcat         AS CHAR NO-UNDO.
    DEF VAR cConcatVal      AS CHAR NO-UNDO.
    DEF VAR ocReturn        AS CHAR NO-UNDO. 
    
    IF NOT bSourceProcSet THEN                          
      hSourceProc = SOURCE-PROCEDURE.
    
    bSourceProcSet = YES.
    
    IF icSqlDb = "" THEN RETURN THIS-OBJECT:FieldList(icBuffersAndFields,icQueryCrit,icDelimiter).
    
    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      cModBuffAndFlds = cModBuffAndFlds + (IF cModBuffAndFlds NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
      cEntry = ENTRY(ix,icBuffersAndFields).
      DO iy = 2 TO NUM-ENTRIES(cEntry,";"):
        cFld = ENTRY(iy,cEntry,";").
        IF NUM-ENTRIES(cFld,"|") > 1 THEN DO:
          cConcat = cFld.
          DO iz = 1 TO NUM-ENTRIES(cConcat,"|"):
            IF NOT CAN-DO(cFields,ENTRY(iz,cConcat,"|")) THEN
              cModBuffAndFlds = cModBuffAndFlds + ";" + ENTRY(iz,cConcat,"|").
          END.           
        END.  
        ELSE IF NOT CAN-DO(cFields,cFld) THEN
          cModBuffAndFlds = cModBuffAndFlds + ";" + cFld.
          
        cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + cFld.  
      END.    
    END.
    
    oQuery = NEW JBoxQuery (cModBuffAndFlds,icSqlDb).
    oQuery:baseQuery = ENTRY(1,icQueryCrit).
    oQuery:rowsToBatch = 500.
    IF NUM-ENTRIES (icBuffersAndFields) > 1 THEN
      oQuery:queryJoin = SUBSTR(icQueryCrit,INDEX(icQueryCrit,",")).

    oQuery:openQuery().
    oQuery:QUERY-HANDLE:GET-FIRST().
    REPEAT WHILE NOT oQuery:QUERY-HANDLE:QUERY-OFF-END:
      DO ix = 1 TO NUM-ENTRIES(cFields):
        ocReturn = ocReturn + (IF ocReturn NE "" THEN icDelimiter ELSE "").
        IF ENTRY(ix,cFields) = cConcat THEN DO:
          cConcatVal = "".
          DO iy = 1 TO NUM-ENTRIES(cConcat,"|"):
            cConcatVal = cConcatVal + (IF cConcatVal NE "" THEN " / " ELSE "")
                       + (IF oQuery:BUFFER-HANDLE:BUFFER-FIELD(ENTRY(iy,cConcat,"|")):BUFFER-VALUE NE ? THEN
                           STRING(oQuery:BUFFER-HANDLE:BUFFER-FIELD(ENTRY(iy,cConcat,"|")):BUFFER-VALUE)
                          ELSE "").  
          END.
          ocReturn = ocReturn + cConcatVal.
        END.
        ELSE ocReturn = ocReturn               
                      + (IF oQuery:BUFFER-HANDLE:BUFFER-FIELD(ENTRY(ix,cFields)):BUFFER-VALUE NE ? THEN
                          STRING(oQuery:BUFFER-HANDLE:BUFFER-FIELD(ENTRY(ix,cFields)):BUFFER-VALUE)
                         ELSE "").  
      END.                   
      oQuery:QUERY-HANDLE:GET-NEXT().
    END.        
    
    DELETE OBJECT oQuery.
    RETURN ocReturn.
                              
  END METHOD.                                        

  METHOD PUBLIC CHARACTER FieldValues(icBuffer      AS CHARACTER
                                     ,icQueryCrit   AS CHARACTER
                                     ,icFieldList   AS CHARACTER):
    DEFINE VARIABLE cReturn   AS CHARACTER NO-UNDO.                                      
    DEFINE VARIABLE cDbBuffer AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ix        AS INTEGER  NO-UNDO.
    
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    
    IF icBuffer MATCHES "buf*_*" THEN
      cDbBuffer = SUBSTR(icBuffer,6).
    ELSE
      cDbBuffer = icBuffer.                             
    
    ASSIGN icFieldList    = REPLACE(icFieldList,";",",")
           bSourceProcSet = NO.
             
    DYNAMIC-FUNCTION("setFieldValueDelimiter",CHR(3)).    
             
    cReturn = DYNAMIC-FUNCTION("getFieldValues",cDbBuffer,"WHERE " + (IF icQueryCrit BEGINS "WHERE " THEN SUBSTR(icQueryCrit,7) ELSE icQueryCrit),icFieldList).
    
    FOR EACH ttFieldValue
        WHERE ttFieldValue.cBuffer = ENTRY(NUM-ENTRIES(icBuffer," "),icBuffer," ")
          AND ttFieldValue.hSourceProc = hSourceProc:
      DELETE ttFieldValue.
    END.
    
    IF cReturn NE "AMBIGUOUS" AND cReturn NE ? THEN 
      DO ix = 1 TO NUM-ENTRIES(icFieldList):
        CREATE ttFieldValue.
        ASSIGN ttFieldValue.hSourceProc = hSourceProc
               ttFieldValue.cBuffer     = ENTRY(NUM-ENTRIES(icBuffer," "),icBuffer," ")
               ttFieldValue.cField      = ENTRY(ix,icFieldList) 
               ttFieldValue.cValue      = ENTRY(ix,cReturn,CHR(3)).
      END.
                       
    RETURN cReturn.                       
  END METHOD.
  
  METHOD PUBLIC LOGICAL Find(icBuffer    AS CHARACTER
                            ,icQueryCrit AS CHARACTER):
                              
    DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.
    
    IF NOT bSourceProcSet THEN                          
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    
    bSourceProcSet = YES.
    
    IF CAN-DO("PREV,NEXT",ENTRY(1,icBuffer," ")) THEN DO:
      MESSAGE "FIND PREV/NEXT not supported in the appserver api"
              VIEW-AS ALERT-BOX.
      RETURN NO.
    END.   
    
    cReturn = THIS-OBJECT:FieldValues(icBuffer,icQueryCrit,DYNAMIC-FUNCTION("getFieldsForTable",ENTRY(NUM-ENTRIES(icBuffer," "),icBuffer," ")) + ",ROWID").       
    
    IF cReturn = "AMBIGUOUS" THEN
      RETURN ?.
    ELSE       
      RETURN cReturn NE ?.                          
  END METHOD.                            

  METHOD PUBLIC LOGICAL Find(icExpr AS CHARACTER):
                              
    DEFINE VARIABLE cBuffer AS CHARACTER NO-UNDO.
                              
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    
    bSourceProcSet = YES.
    
    REPEAT WHILE icExpr MATCHES "*  *":
      icExpr = REPLACE(icExpr,"  "," ").
    END.
    icExpr = TRIM(icExpr).
        
    IF CAN-DO("FIRST,LAST,UNIQUE,PREV,NEXT",ENTRY(1,icExpr," ")) THEN 
      ASSIGN cBuffer = ENTRY(1,icExpr," ")
             icExpr  = TRIM(SUBSTR(icExpr,INDEX(icExpr," "))).  
             
    cBuffer = cBuffer + (IF cBuffer NE "" THEN " " ELSE "") + ENTRY(1,icExpr," ").
    IF INDEX(icExpr," ") > 0 THEN
      icExpr  = TRIM(SUBSTR(icExpr,INDEX(icExpr," "))).         
    ELSE
      icExpr = "WHERE true".

    RETURN THIS-OBJECT:Find(cBuffer,icExpr).
           
  END METHOD.                            
            
  METHOD PUBLIC LOGICAL Find(icBuffer    AS CHARACTER
                            ,icQueryCrit AS CHARACTER
                            ,icSqlDb     AS CHARACTER):
                              
    DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
    DEF VAR cOper     AS CHAR NO-UNDO. // FIRST / LAST
    DEF VAR oQuery    AS JBoxQuery NO-UNDO.
    DEF VAR ix        AS INT NO-UNDO.
    DEF VAR cSort     AS CHAR NO-UNDO.
    DEF VAR cFld      AS CHAR NO-UNDO.
    
    IF NOT bSourceProcSet THEN                          
      hSourceProc = SOURCE-PROCEDURE.
    
    bSourceProcSet = YES.
    
    IF icSqlDb = "" THEN RETURN THIS-OBJECT:Find(icBuffer, icQueryCrit).
    
    REPEAT WHILE INDEX(icBuffer,"  ") > 0:
      icBuffer = REPLACE(icBuffer,"  "," ").
    END.
    icBuffer = TRIM(icBuffer).
    
    IF NUM-ENTRIES(icBuffer," ") = 2 THEN DO:
      ASSIGN cOper    = ENTRY(1,icBuffer," ")
             icBuffer = ENTRY(2,icBuffer," ").
    
      IF CAN-DO("PREV,NEXT",cOper) THEN DO:
        MESSAGE "FIND PREV/NEXT not supported in the appserver api"
                VIEW-AS ALERT-BOX.
        RETURN NO.
      END.   
      IF NOT CAN-DO("FIRST,LAST",cOper) THEN DO:
        MESSAGE "Only FIRST/LAST supported for FIND in the appserver api"
                VIEW-AS ALERT-BOX.
        RETURN NO.
      END.   
    END.
    
    cFields = JBoxSqlSchemaHelper:Instance:getTableAblColumns(icSqlDb,icBuffer).
    
    oQuery = NEW JBoxQuery (icBuffer + ";" + REPLACE(cFields,",",";"),icSqlDb).
    oQuery:baseQuery = icQueryCrit.
    oQuery:rowsToBatch = 1.
    IF INDEX(icQueryCrit," BY ") = 0 THEN DO:
      DO ix = 1 TO NUM-ENTRIES(icQueryCrit," "):
        cFld = ENTRY(NUM-ENTRIES(ENTRY(ix,icQueryCrit," "),"."),ENTRY(ix,icQueryCrit," "),".").
        IF CAN-DO(cFields,cFld) THEN
          cSort = cSort + (IF cSort NE "" THEN "," ELSE "") + cFld
                + (IF cOper = "LAST" THEN ";DESC" ELSE "")
                . 
      END.
      IF cSort = "" THEN cSort = ENTRY(1,JBoxSqlSchemaHelper:Instance:getTableIndexedColumnList(icSqlDb, icBuffer)).
      IF cSort = "" THEN cSort = ENTRY(1,cFields).
      oQuery:setQuerySort(cSort).
    END.   
    oQuery:openQuery().    
    
    FOR EACH ttFieldValue
        WHERE ttFieldValue.cBuffer = icBuffer
          AND ttFieldValue.hSourceProc = hSourceProc:
      DELETE ttFieldValue.
    END.
    
    IF oQuery:recordCount = 1 THEN DO: 
      DO ix = 1 TO NUM-ENTRIES(cFields):
        CREATE ttFieldValue.
        ASSIGN ttFieldValue.hSourceProc = hSourceProc
               ttFieldValue.cBuffer     = icBuffer
               ttFieldValue.cField      = ENTRY(ix,cFields) 
               ttFieldValue.cValue      = STRING(oQuery:BUFFER-HANDLE:BUFFER-FIELD(ENTRY(ix,cFields)):BUFFER-VALUE).
      END.
      CREATE ttFieldValue.
      ASSIGN ttFieldValue.hSourceProc = hSourceProc
             ttFieldValue.cBuffer     = icBuffer
             ttFieldValue.cField      = "ROWID" 
             ttFieldValue.cValue      = oQuery:BUFFER-HANDLE:BUFFER-FIELD("RowIdent1"):BUFFER-VALUE.
      DELETE OBJECT oQuery.
      RETURN YES.
    END. 
    
    DELETE OBJECT oQuery.
    RETURN NO.                          
  END METHOD.                            
                                          
  METHOD PUBLIC CHARACTER FieldValue (icField AS CHARACTER):
    DEFINE VARIABLE cBuffer       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDbAndBuffer  AS CHARACTER NO-UNDO.
    
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    bSourceProcSet = NO.
    
    IF icField BEGINS "JBoxLookup" AND NUM-ENTRIES(icField,".") = 3 THEN
      icField = "JBoxLookup." + ENTRY(3,icField,".").
    
    IF NUM-ENTRIES(icField,".") > 1 THEN DO:
      IF NUM-ENTRIES(icField,".") > 2 THEN
        ASSIGN cDbAndBuffer = ENTRY(1,icField,".") + "." + ENTRY(2,icField,".")
               cBuffer      = ENTRY(2,icField,".")
               icField      = ENTRY(3,icField,".").
      ELSE         
        ASSIGN cBuffer = ENTRY(1,icField,".")
               icField = ENTRY(2,icField,".").
            
      FIND FIRST ttFieldValue
           WHERE ttFieldValue.hSourceProc = hSourceProc
             AND ttFieldValue.cBuffer     = cBuffer
             AND ttFieldValue.cField      = icField
           NO-ERROR.
      IF NOT AVAILABLE ttFieldValue AND cDbAndBuffer NE "" THEN 
        FIND FIRST ttFieldValue
             WHERE ttFieldValue.hSourceProc = hSourceProc
               AND ttFieldValue.cBuffer     = cDbAndBuffer
               AND ttFieldValue.cField      = icField
             NO-ERROR.
    END.
    ELSE DO:          
      FIND ttFieldValue
           WHERE ttFieldValue.hSourceProc = hSourceProc
             AND ttFieldValue.cField      = icField
           NO-ERROR.
      IF AMBIGUOUS ttFieldValue THEN DO:
        MESSAGE "Ambiguous value for" icField "in program" hSourceProc:FILE-NAME SKIP
                "Programmers mistake - field reference must be preceeded by table name" SKIP(1)
                "Returns unknown value"
                VIEW-AS ALERT-BOX ERROR.
        RETURN ?.        
      END.       
    END.       
           
    IF AVAILABLE ttFieldValue THEN RETURN ttFieldValue.cValue.
    ELSE RETURN ?.       
  END METHOD.

  METHOD PUBLIC INTEGER IntValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN INT(THIS-OBJECT:FieldValue(icField)).
  END.
   
  METHOD PUBLIC DATE DateValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN DATE(THIS-OBJECT:FieldValue(icField)).
  END.
   
  METHOD PUBLIC DATETIME DateTimeValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN DATETIME(THIS-OBJECT:FieldValue(icField)).
  END. 

  METHOD PUBLIC DECIMAL DecValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN DECIMAL(THIS-OBJECT:FieldValue(icField)).
  END. 

  METHOD PUBLIC LOGICAL LogValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN LOGICAL(THIS-OBJECT:FieldValue(icField)).
  END. 

  METHOD PUBLIC CHARACTER RowIdent (icBuffer AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN THIS-OBJECT:FieldValue(icBuffer + ".ROWID").
  END METHOD.
  
  METHOD PUBLIC CHARACTER FieldType (icField AS CHARACTER):
    RETURN DYNAMIC-FUNCTION("getFieldDataType",icField).
  END METHOD.

  METHOD PUBLIC LOGICAL ProcessDataSet(icProcName   AS CHARACTER
                                      ,icParameter  AS CHARACTER
                                      ,ihDataSet    AS HANDLE).

    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    IF NOT VALID-HANDLE(ihDataSet) THEN 
      RETURN NO.
        
    bOk = DYNAMIC-FUNCTION("getMyDataSet",icProcName,icParameter,ihDataSet).
            
    CreateCall(icParameter,IF bOk THEN ? ELSE NO,ihDataSet).
    RETURN bOk.
  END METHOD.

  METHOD PUBLIC LOGICAL ProcessTempTable(icProcName    AS CHARACTER
                                        ,icParameter   AS CHARACTER
                                        ,ihTtOrBuffer  AS HANDLE).

    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
              
    IF NOT VALID-HANDLE(ihTtOrBuffer) THEN 
      RETURN NO.
    RUN JBoxLogFuncToMeth.p ("getMyTempTable","CHAR,CHAR,HANDLE",icProcName + CHR(1) + icParameter + CHR(1),ihTtOrBuffer,OUTPUT bOk).
      
    CreateCall(icParameter,IF bOk THEN ? ELSE NO,ihTtOrBuffer).
    RETURN bOk.
  END METHOD.

  METHOD PUBLIC HANDLE GetDbTable(icTable      AS CHARACTER
                                 ,icQueryCrit  AS CHARACTER).

    DEFINE VARIABLE hTT AS HANDLE NO-UNDO.

    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    
    hTT = DYNAMIC-FUNCTION("getTempTable","",icTable + "|" + icQueryCrit,?).

    CreateCall(icTable,DYNAMIC-FUNCTION("getTransactionMessage") = "",?).

    RETURN hTT.
      
  END METHOD.

  METHOD PUBLIC HANDLE GetDbTable(icTable      AS CHARACTER).

    DEFINE VARIABLE hTT AS HANDLE NO-UNDO.

    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    
    hTT = DYNAMIC-FUNCTION("getTempTable","",icTable,?).
                          
    CreateCall(icTable,DYNAMIC-FUNCTION("getTransactionMessage") = "",?).

    RETURN hTT.
      
  END METHOD.

  METHOD PUBLIC LOGICAL BufferCopy(icSourceTable  AS CHARACTER
                                  ,icSourceRowid  AS CHARACTER
                                  ,ihTargetBuffer AS HANDLE ).

    DEFINE VARIABLE hTT AS HANDLE NO-UNDO.

    IF ihTargetBuffer:TYPE = "TEMP-TABLE" THEN
      ihTargetBuffer = ihTargetBuffer:DEFAULT-BUFFER-HANDLE. 

    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    
    hTT = DYNAMIC-FUNCTION("getTempTable",""
                          ,icSourceTable + "|WHERE ROWID(" + icSourceTable + ") = TO-ROWID('" + icSourceRowid + "')"
                          ,ihTargetBuffer).
                          
    CreateCall(icSourceTable,DYNAMIC-FUNCTION("getTransactionMessage") = "",?).
      
  END METHOD.

  METHOD PUBLIC HANDLE GetDataSet(icProcName     AS CHARACTER
                                 ,icParameter    AS CHARACTER).

    DEFINE VARIABLE hReturn AS HANDLE NO-UNDO.
    
    IF NOT bSourceProcSet THEN hSourceProc = SOURCE-PROCEDURE.
   
    bOk = DYNAMIC-FUNCTION("runProcGetDS",icProcName,icParameter).
    IF bOk THEN
      hReturn = DYNAMIC-FUNCTION("getRunProcReturnDS",?,NO,NO).
    
    CreateCall(icParameter,IF VALID-HANDLE(hReturn) THEN ? ELSE NO,?).
    
    RETURN hReturn.
          
  END METHOD.

  METHOD PUBLIC HANDLE GetTempTable(icProcName     AS CHARACTER
                                   ,icParameter    AS CHARACTER).

    DEFINE VARIABLE hReturn AS HANDLE NO-UNDO.
    
    IF NOT bSourceProcSet THEN hSourceProc = SOURCE-PROCEDURE.
   
    bOk = DYNAMIC-FUNCTION("runProcGetTT",icProcName,icParameter).
    IF bOk THEN
      hReturn = DYNAMIC-FUNCTION("getRunProcReturnTable",?).
    CreateCall(icParameter,IF VALID-HANDLE(hReturn) THEN ? ELSE NO,?).
    
    RETURN hReturn.
          
  END METHOD.

  METHOD PUBLIC LOGICAL GetMyDataSet(icProcName    AS CHARACTER
                                    ,icParameter   AS CHARACTER
                                    ,ihDs          AS HANDLE).

    IF NOT bSourceProcSet THEN hSourceProc = SOURCE-PROCEDURE.
        
    IF NOT VALID-HANDLE(ihDs) THEN RETURN NO.
    
    bOk = DYNAMIC-FUNCTION("getMyDataSet",icProcName,icParameter,ihDs).  
      
    CreateCall(icParameter,IF bOk THEN ? ELSE NO,ihDs).
    RETURN bOk.
  END METHOD.

  METHOD PUBLIC LOGICAL GetMyTempTable(icProcName    AS CHARACTER
                                      ,icParameter   AS CHARACTER
                                      ,ihTtOrBuffer  AS HANDLE).

    IF NOT bSourceProcSet THEN hSourceProc = SOURCE-PROCEDURE.
        
    IF NOT VALID-HANDLE(ihTtOrBuffer) THEN 
      RETURN NO.

    bOk = DYNAMIC-FUNCTION("getMyTempTable",icProcName,icParameter,ihTtOrBuffer).  
      
    CreateCall(icParameter,IF bOk THEN ? ELSE NO,ihTtOrBuffer).
    RETURN bOk.
  END METHOD.

  METHOD PUBLIC LOGICAL GetDbTable(icTable       AS CHARACTER
                                  ,icQueryCrit   AS CHARACTER
                                  ,ihTargetTTorBuffer  AS HANDLE).

    DEFINE VARIABLE hTT AS HANDLE NO-UNDO.
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    IF NOT VALID-HANDLE(ihTargetTtOrBuffer) THEN 
      RETURN NO.
    hTT = DYNAMIC-FUNCTION("getTempTable","",icTable + "|" + icQueryCrit,ihTargetTTorBuffer).
      
    CreateCall(icTable,DYNAMIC-FUNCTION("getTransactionMessage") = "",?).
    RETURN DYNAMIC-FUNCTION("getTransactionMessage") = "".
  END METHOD.

  METHOD PUBLIC LOGICAL GetDbTableJoin(icBuffersAndFields   AS CHARACTER
                                      ,icQueryString        AS CHARACTER
                                      ,ihTargetTTorBuffer   AS HANDLE).

    DEFINE VARIABLE hTT AS HANDLE NO-UNDO.
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    IF NOT VALID-HANDLE(ihTargetTtOrBuffer) THEN 
      RETURN NO.
    hTT = DYNAMIC-FUNCTION("getTempTableJoin",icBuffersAndFields,icQueryString,ihTargetTTorBuffer).
      
    CreateCall(ENTRY(1,ENTRY(1,icBuffersAndFields),";"),DYNAMIC-FUNCTION("getTransactionMessage") = "",?).
    RETURN DYNAMIC-FUNCTION("getTransactionMessage") = "".
      
  END METHOD.

  METHOD PUBLIC LOGICAL GetDbTable(icTable   AS CHARACTER
                                  ,ihTargetTTorBuffer  AS HANDLE).

    DEFINE VARIABLE hTT AS HANDLE NO-UNDO.
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    IF NOT VALID-HANDLE(ihTargetTtOrBuffer) THEN 
      RETURN NO.
    hTT = DYNAMIC-FUNCTION("getTempTable","",icTable,ihTargetTTorBuffer).
      
    CreateCall(icTable,DYNAMIC-FUNCTION("getTransactionMessage") = "",?).
    RETURN DYNAMIC-FUNCTION("getTransactionMessage") = "".
  END METHOD.

  METHOD PUBLIC LOGICAL CallServerProc(icProcName      AS CHARACTER
                                      ,icParameter     AS CHARACTER
                                      ,ihReturnHandle  AS HANDLE):

    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
        
    IF VALID-HANDLE(ihReturnHandle) AND ihReturnHandle:TYPE = "DATASET" THEN
      bOk = DYNAMIC-FUNCTION("runProcDS",icProcName,icParameter,ihReturnHandle).
    ELSE  
      bOk = DYNAMIC-FUNCTION("runProc",icProcName,icParameter,ihReturnHandle).
      
    CreateCall(icParameter,bOk,ihReturnHandle).
    RETURN bOk.
  END METHOD.

  METHOD PUBLIC LOGICAL CallServerProc(icProcName      AS CHARACTER
                                      ,icParameter     AS CHARACTER):
                                 
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    
    bSourceProcSet = YES.
    
    RETURN THIS-OBJECT:CallServerProc(icProcName,icParameter,?).
  END METHOD.

  METHOD PUBLIC LOGICAL UploadFiles (icFileNames    AS CHARACTER
                                    ,icContext      AS CHARACTER
                                    ,icEntityId     AS CHARACTER
                                    ,icDescriptions AS CHARACTER):
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
                                      
    bOk = DYNAMIC-FUNCTION("LoadDocs",icFileNames,icContext,icEntityId,icDescriptions).

    CreateCall(icFileNames,bOk,?).
    RETURN bOk.                            
  END METHOD.

  METHOD PUBLIC LOGICAL UploadFiles (icFileNames    AS CHARACTER
                                    ,icUploadProc   AS CHARACTER):
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    DYNAMIC-FUNCTION("setDocLoadProc",icUploadProc,NO,"").
                                      
    bOk = DYNAMIC-FUNCTION("LoadDocs",icFileNames,"","","").

    CreateCall(icFileNames,bOk,?).
    RETURN bOk.                            
  END METHOD.

  METHOD PUBLIC LOGICAL UploadFiles (icFileNames    AS CHARACTER
                                    ,icUploadProc   AS CHARACTER
                                    ,icUploadParam  AS CHARACTER):
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    DYNAMIC-FUNCTION("setDocLoadProc",icUploadProc,NO,icUploadParam).
                                      
    bOk = DYNAMIC-FUNCTION("LoadDocs",icFileNames,"","","").

    CreateCall(icFileNames,bOk,?).
    RETURN bOk.                            
  END METHOD.

  METHOD PUBLIC LOGICAL UploadFilesToDisk (icFileNames    AS CHARACTER
                                          ,icContext      AS CHARACTER
                                          ,icEntityId     AS CHARACTER
                                          ,icDescriptions AS CHARACTER
                                          ,icDiskCat      AS CHARACTER):
                                              
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.

    icDiskCat = RIGHT-TRIM(icDiskCat,"/").
    icDiskCat = RIGHT-TRIM(icDiskCat,"\").
    
    DYNAMIC-FUNCTION("setDocLoadProc","jbdoc_savedoctodisk.p",NO,icDiskCat).
                                      
    bOk = DYNAMIC-FUNCTION("LoadDocs",icFileNames,icContext,icEntityId,icDescriptions).

    CreateCall(icFileNames,bOk,?).
    RETURN bOk.                            
  END METHOD.

  METHOD PUBLIC LOGICAL UploadFiles (icFileNames    AS CHARACTER
                                    ,icContext      AS CHARACTER
                                    ,icEntityId     AS CHARACTER
                                    ,icDescriptions AS CHARACTER
                                    ,ibReplaceFile  AS LOG):
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
  
    DYNAMIC-FUNCTION("setDocLoadParam","replacedoc").
                                      
    bOk = DYNAMIC-FUNCTION("LoadDocs",icFileNames,icContext,icEntityId,icDescriptions).

    CreateCall(icFileNames,bOk,?).
    RETURN bOk.                            
  END METHOD.

  METHOD PUBLIC LOGICAL UploadFiles (icFileNames      AS CHARACTER
                                    ,icContext        AS CHARACTER
                                    ,icEntityId       AS CHARACTER
                                    ,icDescriptions   AS CHARACTER
                                    ,ibReplaceFile    AS LOG
                                    ,ibKeepOldVersion AS LOG):
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
  
    DYNAMIC-FUNCTION("setDocLoadParam","replacedoc,saveoldversion").
                                      
    bOk = DYNAMIC-FUNCTION("LoadDocs",icFileNames,icContext,icEntityId,icDescriptions).

    CreateCall(icFileNames,bOk,?).
    RETURN bOk.                            
  END METHOD.

  METHOD PUBLIC LOGICAL DownloadFiles (icContext        AS CHARACTER
                                      ,icEntityId       AS CHARACTER
                                      ,ibOpen           AS LOG
                                      ,icSaveDir        AS CHARACTER):
    IF NOT bSourceProcSet THEN                                   
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
  
                                      
    bOk = DYNAMIC-FUNCTION("ViewDocs",icContext,icEntityId,ibOpen,icSaveDir).

    CreateCall(icContext,bOk,?).
    RETURN bOk.                            
  END METHOD.

  METHOD PRIVATE VOID CreateCall (icParam        AS CHARACTER
                                 ,ibOk           AS LOG
                                 ,ihReturnHandle AS HANDLE):
    CREATE ttCallstack.
    ASSIGN ttCallstack.hSourceProc   = hSourceProc
           ttCallstack.cMethod       = IF cCallFromMethod NE "" THEN cCallFromMethod ELSE ENTRY(1,PROGRAM-NAME(2)," ")
           ttCallstack.cMessage      = IF CAN-DO("UploadFiles",ttCallstack.cMethod) THEN 
                                         DYNAMIC-FUNCTION("getOutParam") 
                                       ELSE DYNAMIC-FUNCTION("getTransactionMessage")
           ttCallstack.cParam        = icParam
           ttCallstack.bSuccess      = IF ibOk = ? THEN YES ELSE ibOk
           ttCallstack.cReturnParam  = DYNAMIC-FUNCTION("getServerTransReturnParam")
           ttCallstack.hReturnHandle = ihReturnHandle
           bSourceProcSet            = NO
           cCallFromMethod           = "".

    IF ibOk THEN DO:
      IF VALID-HANDLE(ihReturnHandle) AND ihReturnHandle:TYPE = "DATASET" THEN DO:
        DYNAMIC-FUNCTION("getRunProcReturnDS",ttCallstack.hReturnHandle,NO,DatasetReplace).
        DatasetReplace = YES.
      END.
      ELSE IF VALID-HANDLE(ihReturnHandle) THEN 
        DYNAMIC-FUNCTION("getRunProcReturnTable",ttCallstack.hReturnHandle).
    END.       
  END METHOD.

  METHOD PUBLIC VOID CreateCall (icMethod       AS CHARACTER
                                ,icParam        AS CHARACTER
                                ,ibOk           AS LOG
                                ,ihReturnHandle AS HANDLE
                                ,ihSourceProc   AS HANDLE):
    hSourceProc = ihSourceProc.
    cCallFromMethod = icMethod.
    THIS-OBJECT:CreateCall(icParam,ibOk,ihReturnHandle).                               
  END.                                 

  METHOD PUBLIC CHARACTER getCallMessage (ihSourceProc AS HANDLE
                                         ,icMethod     AS CHARACTER
                                         ,icParam      AS CHARACTER):
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = ihSourceProc
           AND ttCallstack.cMethod     = icMethod
           AND ttCallstack.cParam      = icParam
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN RETURN ttCallstack.cMessage.
    ELSE RETURN "".  
           
  END METHOD.

  METHOD PUBLIC CHARACTER getCallMessage ():
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = hSourceProc
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN RETURN ttCallstack.cMessage.
    ELSE RETURN "".  
  END METHOD.

  METHOD PUBLIC CHARACTER getCallReturnParam (ihSourceProc AS HANDLE
                                             ,icMethod     AS CHARACTER
                                             ,icParam      AS CHARACTER):
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = ihSourceProc
           AND ttCallstack.cMethod     = icMethod
           AND ttCallstack.cParam      = icParam
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN RETURN ttCallstack.cReturnParam.
    ELSE RETURN "".  
           
  END METHOD.

  METHOD PUBLIC CHARACTER getCallReturnParam ():
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = hSourceProc
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN RETURN ttCallstack.cReturnParam.
    ELSE RETURN "".  
  END METHOD.

  METHOD PUBLIC HANDLE getCallReturnTable (ihSourceProc AS HANDLE
                                          ,icMethod     AS CHARACTER):
    DEFINE VARIABLE httSource AS HANDLE NO-UNDO.
             
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = ihSourceProc
           AND ttCallstack.cMethod     = icMethod
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN DO:
      IF ttCallstack.hReturnHandle:TYPE = "buffer" THEN httSource = ttCallstack.hReturnHandle:TABLE-HANDLE.
      ELSE httSource = ttCallstack.hReturnHandle.
      RETURN httSource.
    END.   
    ELSE RETURN ?.  
           
  END METHOD.

  METHOD PUBLIC HANDLE getCallReturnTable ():
    DEFINE VARIABLE httSource AS HANDLE NO-UNDO.
    
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = hSourceProc
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN DO:
      IF ttCallstack.hReturnHandle:TYPE = "buffer" THEN httSource = ttCallstack.hReturnHandle:TABLE-HANDLE.
      ELSE httSource = ttCallstack.hReturnHandle.
      RETURN httSource.
    END.   
    ELSE RETURN ?.  
  END METHOD.

  METHOD PUBLIC VOID viewCallMessage (ihSourceProc AS HANDLE
                                     ,icMethod     AS CHARACTER
                                     ,icParam      AS CHARACTER):
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = ihSourceProc
           AND ttCallstack.cMethod     = icMethod
           AND ttCallstack.cParam      = icParam
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN 
      DYNAMIC-FUNCTION("DoMessage",0,0,ttCallstack.cMessage,"","").
           
  END METHOD.

  METHOD PUBLIC VOID viewCallMessageInNotepad (ihSourceProc AS HANDLE
                                     ,icMethod     AS CHARACTER
                                     ,icParam      AS CHARACTER):
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = ihSourceProc
           AND ttCallstack.cMethod     = icMethod
           AND ttCallstack.cParam      = icParam
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN 
      DYNAMIC-FUNCTION("DoMessage",0,20,ttCallstack.cMessage,"","").
           
  END METHOD.

  METHOD PUBLIC VOID viewCallMessage ():
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = hSourceProc
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN 
      DYNAMIC-FUNCTION("DoMessage",0,0,ttCallstack.cMessage,"","").
  END METHOD.

  METHOD PUBLIC VOID viewCallMessageInNotepad ():
    FIND LAST ttCallstack
         WHERE ttCallstack.hSourceProc = hSourceProc
         NO-ERROR.
    IF AVAILABLE ttCallstack THEN 
      DYNAMIC-FUNCTION("DoMessage",0,20,ttCallstack.cMessage,"","").
  END METHOD.

  METHOD PUBLIC VOID Lookup (icBuffersAndFlds AS CHARACTER
                            ,icQuery         AS CHARACTER
                            ,icReturnFields  AS CHARACTER):
    DEFINE VARIABLE cReturnValues   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bOk             AS LOG  NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.

    IF NOT bSourceProcSet THEN DO:
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    END.  
    hMySourceProc = hSourceProc.

    IF VALID-HANDLE(hSourceProc:CURRENT-WINDOW) THEN
      hSourceProc:CURRENT-WINDOW:SENSITIVE = FALSE.
    RUN JBoxLookup.w (hSourceProc,200,
                     icBuffersAndFlds
                    ,icQuery
                    ,""                                                  
                    ,icReturnFields,   /* <- return values for these fields */
                    OUTPUT cReturnValues,
                    OUTPUT bOK).
    IF VALID-HANDLE(hSourceProc:CURRENT-WINDOW) THEN DO:
      hSourceProc:CURRENT-WINDOW:SENSITIVE = TRUE.
      hSourceProc:CURRENT-WINDOW:MOVE-TO-TOP().
    END.  

    THIS-OBJECT:LookupOk = bOk.
      
    IF bOk THEN DO:
      
      FOR EACH ttFieldValue
          WHERE ttFieldValue.cBuffer = "JBoxLookup":
        IF ttFieldValue.hSourceProc = hMySourceProc OR NOT VALID-HANDLE(ttFieldValue.hSourceProc) THEN
          DELETE ttFieldValue.
      END.
    
      DO ix = 1 TO NUM-ENTRIES(icReturnFields):
        CREATE ttFieldValue.
        ASSIGN ttFieldValue.hSourceProc = hMySourceProc
               ttFieldValue.cBuffer     = "JBoxLookup"
               ttFieldValue.cField      = ENTRY(ix,icReturnFields) 
               ttFieldValue.cValue      = ENTRY(ix,cReturnValues,"|").    
      END.
    END.  
    bSourceProcSet = NO.  
  END METHOD.

  METHOD PUBLIC VOID Lookup (ihTtBuffer AS HANDLE):
    DEFINE VARIABLE cBuffersAndFlds AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFields         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bOk             AS LOG  NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    bSourceProcSet = YES.

    cBuffersAndFlds = "TEMP-TABLE " + ihTtBuffer:NAME.
    DO ix = 1 TO ihTtBuffer:NUM-FIELDS:
      ASSIGN cBuffersAndFlds = cBuffersAndFlds + ";" 
                             + ihTtBuffer:BUFFER-FIELD(ix):NAME 
                             + "|" + ihTtBuffer:BUFFER-FIELD(ix):DATA-TYPE
                             + "|" + REPLACE(ihTtBuffer:BUFFER-FIELD(ix):FORMAT,",","<")
                             + "||" + ihTtBuffer:BUFFER-FIELD(ix):LABEL
             cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ihTtBuffer:BUFFER-FIELD(ix):NAME                
                             .
    END.        
    CREATE QUERY hLookupTtQuery.
    hLookupTtQuery:SET-BUFFERS(ihTtBuffer).          
    THIS-OBJECT:Lookup(cBuffersAndFlds,"WHERE TRUE",cFields).
  END METHOD.

  METHOD PUBLIC VOID Lookup (ihTtBuffer AS HANDLE,INPUT icQueryString AS CHAR):
    DEFINE VARIABLE cBuffersAndFlds AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFields         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bOk             AS LOG  NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    bSourceProcSet = YES.

    cBuffersAndFlds = "TEMP-TABLE " + ihTtBuffer:NAME.
    DO ix = 1 TO ihTtBuffer:NUM-FIELDS:
      ASSIGN cBuffersAndFlds = cBuffersAndFlds + ";" 
                             + ihTtBuffer:BUFFER-FIELD(ix):NAME 
                             + "|" + ihTtBuffer:BUFFER-FIELD(ix):DATA-TYPE
                             + "|" + REPLACE(ihTtBuffer:BUFFER-FIELD(ix):FORMAT,",","<")
                             + "||" + ihTtBuffer:BUFFER-FIELD(ix):LABEL
             cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ihTtBuffer:BUFFER-FIELD(ix):NAME                
                             .
    END.        
    CREATE QUERY hLookupTtQuery.
    hLookupTtQuery:SET-BUFFERS(ihTtBuffer).          
    THIS-OBJECT:Lookup(cBuffersAndFlds,icQueryString,cFields).
  END METHOD.

  METHOD PUBLIC VOID LookupDialog (ihTtBuffer AS HANDLE):
    DEFINE VARIABLE cBuffersAndFlds AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFields         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bOk             AS LOG  NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    bSourceProcSet = YES.

    cBuffersAndFlds = "TEMP-TABLE " + ihTtBuffer:NAME.
    DO ix = 1 TO ihTtBuffer:NUM-FIELDS:
      ASSIGN cBuffersAndFlds = cBuffersAndFlds + ";" 
                             + ihTtBuffer:BUFFER-FIELD(ix):NAME 
                             + "|" + ihTtBuffer:BUFFER-FIELD(ix):DATA-TYPE
                             + "|" + ihTtBuffer:BUFFER-FIELD(ix):FORMAT
                             + "||" + ihTtBuffer:BUFFER-FIELD(ix):LABEL
             cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ihTtBuffer:BUFFER-FIELD(ix):NAME                
                             .
    END.        
    CREATE QUERY hLookupTtQuery.
    hLookupTtQuery:SET-BUFFERS(ihTtBuffer).          
    THIS-OBJECT:LookupDialog(cBuffersAndFlds,"WHERE TRUE",cFields).
  END METHOD.

  METHOD PUBLIC VOID LookupDialog (ihTtBuffer AS HANDLE,INPUT icQueryString AS CHAR):
    DEFINE VARIABLE cBuffersAndFlds AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFields         AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bOk             AS LOG  NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    bSourceProcSet = YES.

    cBuffersAndFlds = "TEMP-TABLE " + ihTtBuffer:NAME.
    DO ix = 1 TO ihTtBuffer:NUM-FIELDS:
      ASSIGN cBuffersAndFlds = cBuffersAndFlds + ";" 
                             + ihTtBuffer:BUFFER-FIELD(ix):NAME 
                             + "|" + ihTtBuffer:BUFFER-FIELD(ix):DATA-TYPE
                             + "|" + ihTtBuffer:BUFFER-FIELD(ix):FORMAT
                             + "||" + ihTtBuffer:BUFFER-FIELD(ix):LABEL
             cFields = cFields + (IF cFields NE "" THEN "," ELSE "") + ihTtBuffer:BUFFER-FIELD(ix):NAME                
                             .
    END.        
    CREATE QUERY hLookupTtQuery.
    hLookupTtQuery:SET-BUFFERS(ihTtBuffer).          
    THIS-OBJECT:LookupDialog(cBuffersAndFlds,icQueryString,cFields).
  END METHOD.

  METHOD PUBLIC VOID fillLookupTableFromLookup (ihBrwLookup AS HANDLE):
    DEFINE VARIABLE hTtBuffer AS HANDLE NO-UNDO.
    DEFINE VARIABLE ix        AS INTEGER    NO-UNDO.
    
    hTtBuffer = ihBrwLookup:QUERY:GET-BUFFER-HANDLE (1).
    
    IF VALID-HANDLE(hLookupTtQuery) AND hTtBuffer:NAME = hLookupTtQuery:GET-BUFFER-HANDLE (1):NAME THEN DO:
      hLookupTtQuery:QUERY-PREPARE ("FOR EACH " + hTtBuffer:NAME).
      hLookupTtQuery:QUERY-OPEN ().
      hLookupTtQuery:GET-FIRST ().
      REPEAT WHILE NOT hLookupTtQuery:QUERY-OFF-END:
        hTtBuffer:BUFFER-CREATE().
        hTtBuffer:BUFFER-COPY(hLookupTtQuery:GET-BUFFER-HANDLE (1)).
        hLookupTtQuery:GET-NEXT ().
      END.  
      ihBrwLookup:QUERY:QUERY-OPEN ().
      DELETE OBJECT hLookupTtQuery. 
    END. 
  END.  

  METHOD PUBLIC VOID LookupDialog (icBuffersAndFlds AS CHARACTER
                                  ,icQuery         AS CHARACTER
                                  ,icReturnFields  AS CHARACTER):
    DEFINE VARIABLE cReturnValues   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bOk             AS LOG  NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.

    IF NOT bSourceProcSet THEN DO:
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    END.
    hMySourceProc = hSourceProc.
  
    cReturnValues = icReturnFields.
  
    RUN JBoxDLookup.w (icBuffersAndFlds
                    ,icQuery
                    ,INPUT-OUTPUT cReturnValues).

    THIS-OBJECT:LookupOk = cReturnValues NE "".
  
    IF cReturnValues NE "" THEN DO:
      
      FOR EACH ttFieldValue
          WHERE ttFieldValue.cBuffer  = "JBoxLookup":
        IF ttFieldValue.hSourceProc = hMySourceProc OR NOT VALID-HANDLE(ttFieldValue.hSourceProc) THEN
          DELETE ttFieldValue.
      END.
    
      DO ix = 1 TO NUM-ENTRIES(icReturnFields):
        CREATE ttFieldValue.
        ASSIGN ttFieldValue.hSourceProc = hMySourceProc
               ttFieldValue.cBuffer     = "JBoxLookup"
               ttFieldValue.cField      = ENTRY(ix,icReturnFields) 
               ttFieldValue.cValue      = ENTRY(ix,cReturnValues,"|").    
      END.
    END.  
    bSourceProcSet = NO.  
  END METHOD.

  METHOD PUBLIC VOID Selector (icBuffersAndFlds AS CHARACTER
                              ,icQuery          AS CHARACTER
                              ,icSelectedRowids AS CHARACTER
                              ,icReturnFields   AS CHARACTER):
    DEFINE VARIABLE cReturnValues   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE bOk             AS LOG  NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.
    DEFINE VARIABLE iy              AS INTEGER  NO-UNDO.

    IF NOT bSourceProcSet THEN DO:
      IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
      ELSE hSourceProc = SOURCE-PROCEDURE.
    END.  
    hMySourceProc = hSourceProc.
    
    IF cSelectorProg = "" THEN cSelectorProg = "JBoxSelector.w". 
   
    IF VALID-HANDLE(hMySourceProc:CURRENT-WINDOW) THEN
      hMySourceProc:CURRENT-WINDOW:SENSITIVE = FALSE.
    RUN VALUE(cSelectorProg) (hMySourceProc,0
                        ,icBuffersAndFlds
                        ,icQuery
                        ,INPUT-OUTPUT icSelectedRowids
                        ,icReturnFields
                        ,INPUT-OUTPUT cReturnValues
                        ,IF cTTname NE "" THEN "TTname;" + cTTname ELSE ""
                        ,""
                        ,OUTPUT bOk).
    IF VALID-HANDLE(hMySourceProc:CURRENT-WINDOW) THEN DO:
      hMySourceProc:CURRENT-WINDOW:SENSITIVE = TRUE.
      hMySourceProc:CURRENT-WINDOW:MOVE-TO-TOP().
    END.
      
    ASSIGN cSelectorProg = ""  
           THIS-OBJECT:SelectorOk = bOk.
      
    IF bOk THEN DO ON ERROR UNDO, THROW:
      
      FOR EACH ttFieldValue
          WHERE ttFieldValue.cBuffer = "JBoxSelector":
        IF ttFieldValue.hSourceProc = hMySourceProc OR NOT VALID-HANDLE(ttFieldValue.hSourceProc) THEN
          DELETE ttFieldValue.
      END.
      
      CREATE ttFieldValue.
      ASSIGN ttFieldValue.hSourceProc = hMySourceProc
             ttFieldValue.cBuffer     = "JBoxSelector"
             ttFieldValue.cField      = "RowidList" 
             ttFieldValue.cValue      = icSelectedRowids.

      CREATE ttFieldValue.
      ASSIGN ttFieldValue.hSourceProc = hMySourceProc
             ttFieldValue.cBuffer     = "JBoxSelector"
             ttFieldValue.cField      = "ReturnValueList" 
             ttFieldValue.cValue      = cReturnValues.
 
      DO ix = 1 TO NUM-ENTRIES(cReturnValues,"|"): 
        IF ix = 1 OR ix MOD NUM-ENTRIES(icReturnFields) = 0 THEN DO:
          DO iy = 1 TO NUM-ENTRIES(icReturnFields):
            CREATE ttFieldValue.
            ASSIGN ttFieldValue.hSourceProc = hMySourceProc
                   ttFieldValue.cBuffer     = "JBoxSelector"
                   ttFieldValue.cField      = ENTRY(iy,icReturnFields) 
                   ttFieldValue.cValue      = ENTRY(ix + iy - 1,cReturnValues,"|").
          END.             
        END.  
        IF NUM-ENTRIES(cReturnValues,"|") = NUM-ENTRIES(icReturnFields) OR ix = NUM-ENTRIES(cReturnValues,"|") - NUM-ENTRIES(icReturnFields) THEN LEAVE.  
      END.
    END.
    bSourceProcSet = NO.  
    
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1) SKIP icReturnFields SKIP cReturnValues
      VIEW-AS ALERT-BOX.  
    END CATCH.
    
  END METHOD.

  METHOD PUBLIC VOID Selector (icBuffersAndFlds AS CHARACTER
                              ,icQuery          AS CHARACTER
                              ,icSelectedRowids AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    THIS-OBJECT:Selector(icBuffersAndFlds,icQuery,icSelectedRowids,"").                            
  END METHOD.                              

  METHOD PUBLIC VOID Selector (icBuffersAndFlds AS CHARACTER
                              ,icQuery          AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    THIS-OBJECT:Selector(icBuffersAndFlds,icQuery,"","").                            
  END METHOD.                              

  METHOD PUBLIC VOID Selector (ihTtBuffer AS HANDLE
                              ,icReturnFields   AS CHARACTER):
    /* NB Selector table must be populated in mySelectorObject callback procedure */                                
    DEFINE VARIABLE cBuffersAndFlds AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ix              AS INTEGER  NO-UNDO.

    IF NOT bSourceProcSet THEN hSourceProc = SOURCE-PROCEDURE.

    bSourceProcSet = YES.

    IF ihTtBuffer:TYPE = "TEMP-TABLE" THEN ihTtBuffer = ihTtBuffer:DEFAULT-BUFFER-HANDLE.
    
    cTTname = ihTtBuffer:NAME.

    cBuffersAndFlds = "TEMP-TABLE".
    DO ix = 1 TO ihTtBuffer:NUM-FIELDS:
      ASSIGN cBuffersAndFlds = cBuffersAndFlds + ";" 
                             + ihTtBuffer:BUFFER-FIELD(ix):NAME 
                             + "|" + ihTtBuffer:BUFFER-FIELD(ix):DATA-TYPE
                             + "|" + REPLACE(ihTtBuffer:BUFFER-FIELD(ix):FORMAT,",","<")
                             + "||" + ihTtBuffer:BUFFER-FIELD(ix):LABEL
                             .
    END.        
    THIS-OBJECT:Selector(cBuffersAndFlds,"WHERE FALSE","",icReturnFields).
    cTTname = "".
  END METHOD.
                                
  METHOD PUBLIC VOID SelectorDialog (icBuffersAndFlds AS CHARACTER
                                    ,icQuery          AS CHARACTER
                                    ,icSelectedRowids AS CHARACTER
                                    ,icReturnFields   AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    cSelectorProg = "JBoxDSelector.w".                                      
    THIS-OBJECT:Selector(icBuffersAndFlds,icQuery,icSelectedRowids,icReturnFields).                            
  END METHOD.
                                
  METHOD PUBLIC VOID SelectorDialog (icBuffersAndFlds AS CHARACTER
                                    ,icQuery          AS CHARACTER
                                    ,icSelectedRowids AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    cSelectorProg = "JBoxDSelector.w".                                      
    THIS-OBJECT:Selector(icBuffersAndFlds,icQuery,icSelectedRowids,"").                            
  END METHOD.                              

  METHOD PUBLIC VOID SelectorDialog (icBuffersAndFlds AS CHARACTER
                                    ,icQuery          AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    cSelectorProg = "JBoxDSelector.w".                                      
    THIS-OBJECT:Selector(icBuffersAndFlds,icQuery,"","").                            
  END METHOD.                              

  METHOD PUBLIC VOID SelectorDialog (ihTtBuffer AS HANDLE
                                    ,icReturnFields   AS CHARACTER):
    hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    cSelectorProg = "JBoxDSelector.w".                                      
    THIS-OBJECT:Selector(ihTtBuffer,icReturnFields).                            
  END METHOD.                              

  METHOD PUBLIC CHARACTER LookupValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN THIS-OBJECT:FieldValue("JBoxLookup." + icField).
  END.
  
  METHOD PUBLIC INTEGER LookupIntValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN INT(THIS-OBJECT:FieldValue("JBoxLookup." + icField)).
  END.
  
  METHOD PUBLIC DATE LookupDateValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN DATE(THIS-OBJECT:FieldValue("JBoxLookup." + icField)).
  END.
  
  METHOD PUBLIC DATETIME LookupDateTimeValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN DATETIME(THIS-OBJECT:FieldValue("JBoxLookup." + icField)).
  END.
  
  METHOD PUBLIC DECIMAL LookupDecValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN DECIMAL(THIS-OBJECT:FieldValue("JBoxLookup." + icField)).
  END.
  
  METHOD PUBLIC LOGICAL LookupLogValue (icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN LOGICAL(THIS-OBJECT:FieldValue("JBoxLookup." + icField)).
  END.
  
  METHOD PUBLIC CHARACTER SelectorFieldValueList (INPUT icField AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.    
    bSourceProcSet = YES.
    RETURN THIS-OBJECT:FieldValue("JBoxSelector." + icField).
  END.

  METHOD PUBLIC CHARACTER getRowIdList (INPUT icBufferList AS CHARACTER
                                       ,INPUT icQuery      AS CHARACTER):
    DEFINE VARIABLE cRowidList AS CHARACTER NO-UNDO.
    
    RUN JBoxCharFuncToMeth.p ("getRowIdList"
                            ,"CHARACTER,CHARACTER,CHARACTER"
                            ,icBufferList + CHR(1) + CHR(1) + icQuery
                            ,?
                            ,OUTPUT cRowidList).
    RETURN cRowidList.                           
  END.                             

  METHOD PUBLIC CHARACTER getRowIdList (INPUT icBufferList AS CHARACTER
                                       ,INPUT icBufferName AS CHARACTER /* If not last buffer in bufferlist */
                                       ,INPUT icQuery      AS CHARACTER):
    DEFINE VARIABLE cRowidList AS CHARACTER NO-UNDO.
    
    RUN JBoxCharFuncToMeth.p ("getRowIdList"
                            ,"CHARACTER,CHARACTER,CHARACTER"
                            ,icBufferList + CHR(1) + icBufferName + CHR(1) + icQuery
                            ,?
                            ,OUTPUT cRowidList).
    RETURN cRowidList.                           
  END.                             

  METHOD PUBLIC INTEGER getRecordCount (INPUT icBufferList AS CHARACTER
                                       ,INPUT icQuery      AS CHARACTER):
    DEFINE VARIABLE iCount AS INTEGER NO-UNDO.
    
    RUN JBoxIntFuncToMeth.p ("getRecordCount"
                            ,"CHARACTER,CHARACTER"
                            ,icBufferList + CHR(1) + icQuery
                            ,?
                            ,OUTPUT iCount).
    RETURN iCount.                           
  END.                             

  METHOD PUBLIC DECIMAL getTotal (INPUT icBufferList AS CHARACTER
                                 ,INPUT icQuery      AS CHARACTER
                                 ,INPUT icFieldName  AS CHARACTER):
    DEFINE VARIABLE fTotal AS DECIMAL NO-UNDO.
    
    RUN JBoxDecFuncToMeth.p ("getTotal"
                            ,"CHARACTER,CHARACTER,CHARACTER"
                            ,icBufferList + CHR(1) + icQuery + CHR(1) + icFieldName
                            ,?
                            ,OUTPUT fTotal).
    RETURN fTotal.                           
  END.                             
  
  METHOD PUBLIC LOGICAL getActionPermission(INPUT icAction AS CHARACTER):
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    RUN JBoxLogFuncToMeth.p ("getActionPermission"
                            ,"CHARACTER,CHARACTER,CHARACTER"
                            ,hSourceProc:FILE-NAME + CHR(1) + CHR(1) + icAction
                            ,?
                            ,OUTPUT bOk).
    RETURN bOk.                        
  END.
  
  METHOD PUBLIC VOID clearCalls(ihSourceProc AS HANDLE):
    FOR EACH ttCallstack WHERE ttCallstack.hSourceProc = ihSourceProc:
      DELETE ttCallstack.
    END.
    FOR EACH ttFieldValue WHERE ttFieldValue.hSourceProc = ihSourceProc:
      DELETE ttFieldValue.
    END.
  END. 

  METHOD PUBLIC LOGICAL getAllCache():
    DYNAMIC-FUNCTION("getSessionData").
    RETURN YES.                        
  END.

  METHOD PUBLIC LOGICAL getUserSettingCache():
    DYNAMIC-FUNCTION("BuildTableCache","JBoxUserSetting|WHERE cJBoxUserId = '" + DYNAMIC-FUNCTION("getASuserId") + "'").
    RETURN YES.                        
  END.

  METHOD PUBLIC CHARACTER getUserSetting(INPUT icSourceFile     AS CHARACTER,
                                         INPUT icObjectName     AS CHARACTER,
                                         INPUT icContext        AS CHARACTER,
                                         INPUT icSettingName    AS CHARACTER ):
    RETURN DYNAMIC-FUNCTION("getUserSetting",
                             icSourceFile,
                             icObjectName,
                             icContext,
                             icSettingName).
  END.

  METHOD PUBLIC CHARACTER getUserSetting(INPUT icSourceFile     AS CHARACTER,
                                         INPUT icObjectName     AS CHARACTER,
                                         INPUT icContext        AS CHARACTER,
                                         INPUT icSettingName    AS CHARACTER,
                                         INPUT icUserId         AS CHARACTER ):
                                           
    RETURN DYNAMIC-FUNCTION("getUserSetting",
                             icSourceFile,
                             icObjectName,
                             icContext,
                             icSettingName + CHR(1) + icUserId).
  END.

  METHOD PUBLIC LOGICAL setUserSetting(INPUT icSourceFile     AS CHARACTER,
                                       INPUT icObjectName     AS CHARACTER,
                                       INPUT icContext        AS CHARACTER,
                                       INPUT icSettingName    AS CHARACTER,
                                       INPUT icSetting        AS CHARACTER ):
                                           
    RETURN DYNAMIC-FUNCTION("setUserSetting",
                             icSourceFile,
                             icObjectName,
                             icContext,
                             icSettingName,
                             icSetting).
  END.

  METHOD PUBLIC VOID setDataSourceConnection( INPUT icDataSourceName AS CHAR
                                             ,INPUT icConnectionFile AS CHAR ):
    
    FIND FIRST ttDataSource
         WHERE ttDataSource.DataSourceName = icDataSourceName
         NO-ERROR.
    IF NOT AVAIL ttDataSource THEN DO:
      CREATE ttDataSource.
      ASSIGN ttDataSource.DataSourceName = icDataSourceName.
    END.
    ttDataSource.ConnectionFile = icConnectionFile.
         
    RETURN.

  END METHOD.

  METHOD PUBLIC CHARACTER getDataSourceConnection( INPUT icDataSourceName AS CHAR):
    
    FIND FIRST ttDataSource
         WHERE ttDataSource.DataSourceName = icDataSourceName
         NO-ERROR.
    IF AVAIL ttDataSource THEN RETURN ttDataSource.ConnectionFile.
         
    RETURN "".

  END METHOD.

  METHOD PUBLIC LOGICAL getSchemaCache():
    DYNAMIC-FUNCTION("BuildTableCache","jbserv_getfieldcache.p").                        
    RETURN YES.                        
  END.


	DESTRUCTOR PUBLIC JBoxServerAPI ( ):

	END DESTRUCTOR.
	
	
END CLASS.

