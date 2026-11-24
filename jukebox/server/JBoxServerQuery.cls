 /*------------------------------------------------------------------------
    File        : JBoxServerQuery
    Purpose     : Singleton for operations in calculated fields or their container: <queryObject | browseObject>:calcFieldProc (can be a list of proc's)
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Fri Apr 24 10:03:36 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxServerQuery: 

  DEF VAR hSourceProc     AS HANDLE NO-UNDO.

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxServerQuery NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxServerQuery().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEF PUBLIC PROPERTY cSessionId      AS CHAR   NO-UNDO GET. PROTECTED SET.

  DEFINE PUBLIC PROPERTY ResultSetBuffer AS HANDLE NO-UNDO
         GET(): 
           RETURN DYNAMIC-FUNCTION("getResultSetBuffer" IN hSourceProc).
         END GET.
         PROTECTED SET.  

  DEFINE PUBLIC PROPERTY QueryOutputParam AS CHAR PROTECTED GET. 
         SET(icParam AS CHAR):
           DYNAMIC-FUNCTION("setReturnMessage" IN hSourceProc,icParam).
         END SET.  
                     
  CONSTRUCTOR PRIVATE JBoxServerQuery ():

  END CONSTRUCTOR.

  METHOD PUBLIC VOID InitializeObject (INPUT icSessionId  AS CHAR,
                                       INPUT ihSourceProc AS HANDLE):
 
    ASSIGN hSourceProc = ihSourceProc
           cSessionId  = icSessionId
           .
                             
  END METHOD.                           
                                          
  METHOD PUBLIC HANDLE getQueryBuffer (icBufferName AS CHAR):
    RETURN DYNAMIC-FUNCTION("getQueryBuffer" IN hSourceProc,icBufferName).
  END METHOD.

  METHOD PUBLIC VOID setCheckForSkipRow (ibDoCalcForAllRows_ToGetCorrectRecordCount AS LOG):
    DYNAMIC-FUNCTION("setCheckForSkipRow" IN hSourceProc,ibDoCalcForAllRows_ToGetCorrectRecordCount).
  END METHOD.  

  METHOD PUBLIC VOID LogThis (icLineLabel AS CHAR
                             ,icLineText  AS CHAR):
    DYNAMIC-FUNCTION("LogThis" IN hSourceProc,icLineLabel,icLineText,0).
  END METHOD.
  
  METHOD PUBLIC VOID LogThis (icLineLabel AS CHAR
                             ,icLineText  AS CHAR
                             ,iiSkipAfter AS INT):
    DYNAMIC-FUNCTION("LogThis" IN hSourceProc,icLineLabel,icLineText,iiSkipAfter).
  END METHOD.
  
  METHOD PUBLIC HANDLE getOtherCalcProcHandle (INPUT icCalcProcContainerName AS CHAR):
    RETURN DYNAMIC-FUNCTION("getCalcProcHandle" IN hSourceProc,icCalcProcContainerName).
  END METHOD.  

  METHOD PUBLIC HANDLE getCalcFieldParam (icFieldName AS CHAR):
    RETURN DYNAMIC-FUNCTION("getCalcFieldParam" IN hSourceProc,icFieldName).
  END METHOD.
    
  METHOD PUBLIC CHARACTER getCalcFieldFilterValue (INPUT icFieldName AS CHAR):
    RETURN DYNAMIC-FUNCTION("getCalcFieldFilterValue" IN hSourceProc,icFieldName).   
  END METHOD.    

  METHOD PUBLIC CHARACTER getCalcFieldFilterOperator (INPUT icFieldName AS CHAR):
    RETURN DYNAMIC-FUNCTION("getCalcFieldFilterOperator" IN hSourceProc,icFieldName).   
  END METHOD.    
    
  METHOD PUBLIC LOGICAL addPrescanQuery (INPUT icPrescanQuery AS CHAR):
    RETURN DYNAMIC-FUNCTION("addPrescanQuery" IN hSourceProc,icPrescanQuery).
  END.  
  
  METHOD PUBLIC CHARACTER getQueryCriteria().
    RETURN DYNAMIC-FUNCTION("getQueryCriteria" IN hSourceProc).
  END.  
    
  DESTRUCTOR PUBLIC JBoxServerQuery ( ):

  END DESTRUCTOR.
  
  
END CLASS.

