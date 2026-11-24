 
 /*------------------------------------------------------------------------
    File        : JBoxServerTrans
    Purpose     : Singleton for operations in hook procedures for jbserv_servertrans.p, ie
                  <fieldMapObject | browseObject>:customCreateProc
                  <fieldMapObject | browseObject>:customUpdateValProc
                  <fieldMapObject | browseObject>:customDeleteValProc
                  <fieldMapObject | browseObject>:postUpdateProc
                  or as parameters to 
                  JBoxServerApi:Instance:Create, Update or Delete
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Fri Apr 24 10:03:36 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxServerTrans: 

  DEF VAR hSourceProc     AS HANDLE NO-UNDO.
  DEF VAR bOk             AS LOG    NO-UNDO.
  DEF VAR cSessionId      AS CHAR   NO-UNDO.

  DEFINE PUBLIC STATIC PROPERTY Instance AS CLASS JBoxServerTrans NO-UNDO
         GET():
           IF Instance = ? THEN Instance = NEW JBoxServerTrans().
           RETURN Instance.
         END GET.
         PRIVATE SET.

  DEFINE PUBLIC PROPERTY PreTransBuffer AS HANDLE NO-UNDO
         GET(): 
           RETURN DYNAMIC-FUNCTION("getPreTransBuffer" IN hSourceProc).
         END GET.
         PROTECTED SET.  

  DEFINE PUBLIC PROPERTY InputParam AS CHAR NO-UNDO
         GET(): 
           RETURN DYNAMIC-FUNCTION("getInputParam" IN hSourceProc).
         END GET.  
         PROTECTED SET.  

  DEFINE PUBLIC PROPERTY OutputParam AS CHAR PROTECTED GET. 
         SET(icParam AS CHAR):
           DYNAMIC-FUNCTION("setOutputParam" IN hSourceProc,icParam).
         END SET.  

  /* Use to persist information from hook-to-hook (Create to Update/Delete validation to Post update) */
  DEFINE PUBLIC PROPERTY TransactionContext AS CHAR 
         GET():
           RETURN DYNAMIC-FUNCTION("getContext").
         END SET.
         SET(icParam AS CHAR):
           DYNAMIC-FUNCTION("setContext" IN hSourceProc,icParam).
         END SET.  

  DEFINE PUBLIC PROPERTY ActionCreate AS LOGICAL 
         GET():
           RETURN DYNAMIC-FUNCTION("getCurrentAction" IN hSourceProc) = "Create".
         END SET.
         PROTECTED SET.

  DEFINE PUBLIC PROPERTY ActionDelete AS LOGICAL 
         GET():
           RETURN DYNAMIC-FUNCTION("getCurrentAction" IN hSourceProc) = "Delete".
         END SET.
         PROTECTED SET.

  DEFINE PUBLIC PROPERTY ActionUpdate AS LOGICAL 
         GET():
           RETURN DYNAMIC-FUNCTION("getCurrentAction" IN hSourceProc) = "Update".
         END SET.
         PROTECTED SET.

  DEFINE PUBLIC PROPERTY ValueFields AS CHAR 
         GET():
           RETURN DYNAMIC-FUNCTION("getCurrentValueFields" IN hSourceProc).
         END SET.
         PROTECTED SET.

  DEFINE PUBLIC PROPERTY FieldValues AS CHAR 
         GET():
           RETURN DYNAMIC-FUNCTION("getCurrentValues" IN hSourceProc).
         END SET.
         PROTECTED SET.

           
	CONSTRUCTOR PRIVATE JBoxServerTrans ():

	END CONSTRUCTOR.

  METHOD PUBLIC VOID InitializeObject (INPUT icSessionId  AS CHAR,
                                       INPUT ihSourceProc AS HANDLE):
 
    ASSIGN hSourceProc = ihSourceProc
           cSessionId  = icSessionId
           .
                             
  END METHOD.                           
                                          
  METHOD PUBLIC CHARACTER FieldValue (icField AS CHAR):
    RETURN DYNAMIC-FUNCTION("getValue" IN hSourceProc,icField).
  END METHOD.

  METHOD PUBLIC INTEGER IntValue (icField AS CHAR):
    RETURN INT(THIS-OBJECT:FieldValue(icField)).
  END.
   
  METHOD PUBLIC DATE DateValue (icField AS CHAR):
    RETURN DATE(THIS-OBJECT:FieldValue(icField)).
  END.
   
  METHOD PUBLIC DATETIME DateTimeValue (icField AS CHAR):
    RETURN DATETIME(THIS-OBJECT:FieldValue(icField)).
  END. 

  METHOD PUBLIC DECIMAL DecValue (icField AS CHAR):
    RETURN DECIMAL(THIS-OBJECT:FieldValue(icField)).
  END. 

  METHOD PUBLIC LOGICAL LogValue (icField AS CHAR):
    RETURN LOGICAL(THIS-OBJECT:FieldValue(icField)).
  END. 

  METHOD PUBLIC LOGICAL FieldIncluded (icField AS CHAR):
    RETURN CAN-DO(THIS-OBJECT:ValueFields,icField).
  END. 

  METHOD PUBLIC VOID SuppressDynDelete ():
    DYNAMIC-FUNCTION("SuppressDynDelete" IN hSourceProc).
  END METHOD.
  	
	DESTRUCTOR PUBLIC JBoxServerTrans ( ):

	END DESTRUCTOR.
	
	
END CLASS.

