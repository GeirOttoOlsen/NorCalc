 
 /*------------------------------------------------------------------------
    File        : JBoxXML
    Purpose     : Read and write xml document(s)
    Syntax      : 
    Description : Management of relationships between fields and buffer
    Author(s)   : brynjar
    Created     : Thu feb 18 13:18:49 CEST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.


CLASS JBoxXml INHERITS JBoxJsonParser: 
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
  DEF VAR hSourceProc   AS HANDLE NO-UNDO.
  DEF VAR hXmlLib       AS HANDLE NO-UNDO.
  DEF VAR cDocName      AS CHAR   NO-UNDO INIT "class".
  DEF VAR iNameSeq      AS INT    NO-UNDO.
/*	  
  DEF TEMP-TABLE ttTables NO-UNDO
      FIELD TableName             AS CHAR 
      FIELD hTable                AS HANDLE
      FIELD hBuffer               AS HANDLE
      FIELD cType                 AS CHAR
      FIELD bIncluded             AS LOG
      FIELD Level                 AS INT
      FIELD Seq                   AS INT
      FIELD ParentSeq             AS INT
      FIELD ParentTableName       AS CHAR
      FIELD JsonTableName         AS CHAR 
      FIELD ParentJsonTableName   AS CHAR 
      FIELD orgTableName          AS CHAR
      INDEX TableName IS UNIQUE TableName ParentTableName Level
      INDEX JsonTableName JsonTableName ParentJsonTableName Level
      INDEX TableSeq IS PRIMARY Level Seq
      . 

  DEF TEMP-TABLE ttFields NO-UNDO
      FIELD TableName           AS CHAR FORMAT "x(50)"
      FIELD FieldName           AS CHAR FORMAT "x(50)"
      FIELD DataType            AS CHAR FORMAT "x(10)"
      FIELD JsonFieldName       AS CHAR FORMAT "x(50)" 
      FIELD JsonTableName       AS CHAR FORMAT "x(50)"
      FIELD ParentJsonTableName AS CHAR FORMAT "x(50)"
      FIELD hField              AS HANDLE
      FIELD bIncluded           AS LOG
      FIELD Level               AS INT
      FIELD Length              AS INT
      FIELD FormatString        AS CHAR
      FIELD Seq                 AS INT
      FIELD TableSeq            AS INT
      INDEX TableFieldName TableName FieldName Level
      INDEX TableJsonFieldName JsonTableName JsonFieldName Level
      INDEX FieldSeq IS PRIMARY TableName Seq
      .

  DEFINE DATASET dsSchema FOR ttTables, ttFields
         DATA-RELATION ttFields FOR ttTables, ttFields RELATION-FIELDS ( TableName, TableName ) NESTED
         .

  DEF PUBLIC PROPERTY hdsSchema   AS HANDLE  NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY reservedNames  AS CHAR NO-UNDO GET. SET.
		*/
  CONSTRUCTOR PUBLIC JBoxXML ():
	  SUPER ().
		
    hSourceProc = SOURCE-PROCEDURE.
	
	  
/*	  hdsSchema = DATASET dsSchema:HANDLE.                                                                                                         */
/*    reservedNames = "value,status,alias,message,locked,text,userid,label,format,available,color,ascending,self,first,last,each,next,page,title".*/
		
		InitializeComponent().       
	END CONSTRUCTOR.
	
	METHOD PRIVATE LOGICAL InitializeComponent():
	  RUN JBoxXmlLib.p PERSIST SET hXmlLib.
	  RUN initXMLdoc IN hXmlLib (cDocName).	
	  RETURN YES.
	END METHOD.

  METHOD PUBLIC LOGICAL loadDoc(INPUT ilcDoc AS LONGCHAR):
    
    RUN deleteDocs IN hXmlLib.
    RUN loadXML IN hXmlLib (cDocName,ilcDoc).
    RETURN YES.                                    
    
  END METHOD.  
	  
  METHOD PUBLIC LOGICAL loadDoc(INPUT icFileName AS CHAR):
    DEF VAR lcDoc AS LONGCHAR NO-UNDO.
     
    IF SEARCH(icFileName) NE ? THEN DO:
      FILE-INFO:FILE-NAME = SEARCH(icFileName).
      COPY-LOB FROM FILE FILE-INFO:FULL-PATHNAME TO lcDoc NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN
        RETURN THIS-OBJECT:loadDoc(lcDoc).
      ELSE RETURN NO.
    END.
    ELSE RETURN NO.                                    
  END METHOD.  

  METHOD PUBLIC LOGICAL dumpNodes():
    
    RUN dumpXmlNodes IN hXmlLib (cDocName).
    RETURN YES.                                    
    
  END METHOD.  

  METHOD PUBLIC LOGICAL dumpNumericNodes():
    DYNAMIC-FUNCTION("setDumpFilter" IN hXmlLib,"numeric").
    RUN dumpXmlNodes IN hXmlLib (cDocName).
    DYNAMIC-FUNCTION("setDumpFilter" IN hXmlLib,"").
    RETURN YES.                                    
  END METHOD.  

  METHOD PUBLIC LOGICAL dumpFilteredNodeNames(INPUT icFilter AS CHAR):
    DYNAMIC-FUNCTION("setDumpFilter" IN hXmlLib,icFilter).
    RUN dumpXmlNodes IN hXmlLib (cDocName).
    DYNAMIC-FUNCTION("setDumpFilter" IN hXmlLib,"").
    RETURN YES.                                    
  END METHOD.  

  METHOD PUBLIC CHARACTER getValue(INPUT icNode AS CHAR):
    
    DEF VAR cValue AS CHAR NO-UNDO.
    
    RUN getNodeValue IN hXmlLib (cDocName,icNode,OUTPUT cValue).
    RETURN cValue.                                    
    
  END METHOD.  


/*
  METHOD PUBLIC LOGICAL saveNewRecord(INPUT icFields AS CHAR,
                                      INPUT icValues AS CHAR):
                                        
    THIS-OBJECT:objectState = "new".
    DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"bufferExtraFields",icFields).
    DYNAMIC-FUNCTION("setAttribute",BUFFER-HANDLE,"bufferExtraValues",icValues).
                                        
    RUN InvokeMethod(BUFFER-HANDLE,"SaveRecord"). 
    RETURN DYNAMIC-FUNCTION("getTransactionMessage") = "".
  END METHOD.  

  METHOD PUBLIC LOGICAL refreshFields():
    RETURN DYNAMIC-FUNCTION("DisplayFieldMap",BUFFER-HANDLE). 
  END METHOD.  

  METHOD PUBLIC HANDLE getUpdateFieldHandle(INPUT icFieldName AS CHAR):
    IF LOOKUP(icFieldName,THIS-OBJECT:updateFields) > 0 THEN
      RETURN WIDGET-HANDLE(ENTRY(LOOKUP(icFieldName,THIS-OBJECT:updateFields),THIS-OBJECT:updateWidgets)).
    ELSE
      RETURN ?. 
  END METHOD.  
*/
  
  METHOD PUBLIC OVERRIDE LOGICAL createSchema (INPUT ilcXML AS LONGCHAR, INPUT icSchemaName AS CHAR):

    DEF VAR hDoc             AS HANDLE NO-UNDO.
    DEF VAR hRoot            AS HANDLE NO-UNDO.
    DEF VAR httTable         AS HANDLE NO-UNDO.
    DEF VAR iTableSeq        AS INT    NO-UNDO.
    DEF VAR hBuffer          AS HANDLE NO-UNDO.

    CREATE X-DOCUMENT hDoc.
    CREATE X-NODEREF hRoot.
        
    hDoc:LOAD("longchar",ilcXml,FALSE).
//    hDoc:LOAD("file","V:\prowrk\pf\data\302490930.xml",FALSE).
    
    hDoc:GET-DOCUMENT-ELEMENT(hRoot).

    SESSION:NUMERIC-FORMAT = "American".
                
    IF VALID-HANDLE(hdsResult) THEN    
      DELETE OBJECT hdsResult.
    
    CREATE DATASET hdsResult.
        
        
    hdsSchema:EMPTY-DATASET ().
    
    ASSIGN iGlobId = 0
           cSchemaName   = (IF icSchemaName NE "" THEN icSchemaName ELSE "ttXMLHeader")    
           statusMessage = ""
           iNameSeq = 0
           .

    CreateTtTable(cSchemaName,"",0,0,"OBJECT",OUTPUT httTable,OUTPUT iTableSeq).

    createObjectSchema(hRoot, 1,iTableSeq,httTable).

    prepareSchema(icSchemaName).

    hbttTables:FIND-FIRST("WHERE ttTables.TableName = '" + cSchemaName
                        + "' AND ttTables.ParentTableName = ''")
               NO-ERROR.
    IF hbttTables:AVAIL THEN DO: 
      hBuffer = hbttTables::hBuffer.
      hBuffer:BUFFER-CREATE ().
      ASSIGN iGlobId = iGlobId + 1
             hbttTables::hBuffer::JBoxRowIdent = iGlobId
             hbttTables::hBuffer::JBoxParentRowIdent = 0
             .

      readData(hRoot,1,iGlobId,hbttTables).
    END.  

    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1) + " (" + PROGRAM-NAME(2) + ")".
    END CATCH.
    
    FINALLY:
      SESSION:NUMERIC-FORMAT = cOrgNumFormat.
      DELETE OBJECT hDoc.
      DELETE OBJECT hRoot.
      RETURN statusMessage = "".
    END FINALLY.
  
  END METHOD.  

  METHOD PRIVATE VOID createObjectSchema(INPUT ihParent   AS HANDLE
                                        ,INPUT iiLevel    AS INTEGER
                                        ,iiParentTableSeq AS INT
                                        ,ihBuffer         AS HANDLE):

    DEF VAR ix          AS INTEGER NO-UNDO.
    DEF VAR hNoderef    AS HANDLE NO-UNDO.
    DEF VAR bOk         AS LOGICAL NO-UNDO.
    DEF VAR cOEname     AS CHAR NO-UNDO.
    DEF VAR iTableSeq   AS INT  NO-UNDO.
    DEF VAR httTable    AS HANDLE NO-UNDO.
    DEF VAR hGrandPa    AS HANDLE NO-UNDO.
    DEF VAR bGrandPaOk  AS lOG NO-UNDO.

    CREATE X-NODEREF hNoderef.

    CREATE X-NODEREF hGrandPa.
    bGrandPaOk = ihParent:GET-PARENT(hGrandPa).

    REPEAT ix = 1 TO ihParent:NUM-CHILDREN:
      bOk = ihParent:GET-CHILD(hNoderef,ix).
      IF NOT bOk THEN LEAVE.
      IF NOT CAN-DO("element",hNoderef:SUBTYPE) THEN NEXT.
      IF hNoderef:NUM-CHILDREN > 1 THEN DO:
        cOEname = THIS-OBJECT:createTtTable(hNoderef:NAME,ihParent:NAME,iiLevel,iiParentTableSeq,"OBJECT",OUTPUT httTable,OUTPUT iTableSeq).
        createObjectSchema(hNoderef,iiLevel + 1,iTableSeq,httTable).
      END.
      ELSE IF bGrandPaOk AND NOT hNoderef:NAME MATCHES "JBox*RowIdent" THEN 
        createTtField(ihParent:NAME,hNoderef:NAME,"CHARACTER",hGrandPa:NAME,iiLevel - 1).      
    END.

    DELETE OBJECT hNoderef.
    IF bGrandPaOk THEN DELETE OBJECT hGrandPa.
  END METHOD.    

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID readData (INPUT ihParent   AS HANDLE
                                 ,iiLevel          AS INT
                                 ,iiParentId       AS INT
                                 ,ihBuffer         AS HANDLE):
    
    DEF VAR ix          AS INTEGER NO-UNDO.
    DEF VAR hNoderef    AS HANDLE NO-UNDO.
    DEF VAR bOk         AS LOGICAL NO-UNDO.
    DEF VAR cOEname     AS CHAR NO-UNDO.
    DEF VAR iTableSeq   AS INT  NO-UNDO.
    DEF VAR httTable    AS HANDLE NO-UNDO.
    DEF VAR hGrandPa    AS HANDLE NO-UNDO.
    DEF VAR bGrandPaOk  AS lOG NO-UNDO.
    DEF VAR hBuffer     AS HANDLE NO-UNDO.

    CREATE X-NODEREF hNoderef.

    CREATE X-NODEREF hGrandPa.
    bGrandPaOk = ihParent:GET-PARENT(hGrandPa).

    REPEAT ix = 1 TO ihParent:NUM-CHILDREN:
      bOk = ihParent:GET-CHILD(hNoderef,ix).
      IF NOT bOk THEN LEAVE.
      IF NOT CAN-DO("element,text",hNoderef:SUBTYPE) THEN NEXT.
      IF hNoderef:SUBTYPE = "element" AND hNoderef:NUM-CHILDREN > 1 THEN DO:
        hbttTables:FIND-FIRST("WHERE ttTables.JsonTableName = '" + hNoderef:NAME
                            + "' AND ttTables.ParentJsonTableName = '" + ihParent:NAME
                            + "' AND ttTables.Level = " + STRING(iiLevel)
                              )
                   NO-ERROR.
        IF hbttTables:AVAIL THEN DO:           
          hbttTables::hBuffer:BUFFER-CREATE ().
          ASSIGN iGlobId = iGlobId + 1
                 hbttTables::hBuffer::JBoxRowIdent = iGlobId
                 hbttTables::hBuffer::JBoxParentRowIdent = iiParentId
                 .
/*         MESSAGE error-status:get-message(1) skip   */
/*                 string(hbttTables::hBuffer) skip   */
/*                 hbttTables::hBuffer:NAME skip(1)   */
/*                 hbttTables::TableName skip         */
/*                 hbttTables::ParentTableName skip(1)*/
/*                 hNoderef:NAME skip ihParent:NAME   */
/*         VIEW-AS ALERT-BOX.                         */
    
          readData(hNoderef,iiLevel + 1,iGlobId,hbttTables).
        END.  
        else MESSAGE "finner ikke" skip hNoderef:NAME skip ihParent:NAME skip iiLevel
             VIEW-AS ALERT-BOX.
      END.
      ELSE IF hNoderef:SUBTYPE = "element" THEN  
        readData(hNoderef,iiLevel,iGlobId,ihBuffer).
      ELSE DO:
        
        bOk = hbttFields:FIND-FIRST("WHERE ttFields.JsonTableName = '" + ihBuffer::JsonTableName
                            + "' AND ttFields.ParentJsonTableName = '" + ihBuffer::ParentJsonTableName
                            + "' AND ttFields.Level = " + STRING(iiLevel - 1)
                            + " AND ttFields.JsonfieldName = '" + ihParent:NAME + "'"
                              )
                   NO-ERROR.
        IF hbttFields:AVAIL THEN 
          hbttFields::hField:BUFFER-VALUE = hNoderef:NODE-VALUE.
          /*
        MESSAGE "hNoderef:NAME" hNoderef:NAME SKIP
              "hParent:NAME" ihParent:NAME SKIP
              "type" hNoderef:TYPE SKIP
              "hNoderef:SUBTYPE" hNoderef:SUBTYPE SKIP
              "NODE-VALUE" hNoderef:NODE-VALUE SKIP
              "attribute-names" hNoderef:ATTRIBUTE-NAMES SKIP
              "num-children" hNoderef:NUM-CHILDREN skip(1)
              ihBuffer:name skip(1)
              string(hbttFields::hField) skip bOk skip error-status:get-message(1)
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
              */
//        createTtField(ihParent:NAME,hNoderef:NAME,"CHARACTER",hGrandPa:NAME,iiLevel - 1).      
      END.
    END.

    DELETE OBJECT hNoderef.
    IF bGrandPaOk THEN DELETE OBJECT hGrandPa.

  END METHOD.

/*  
  METHOD PROTECTED CHARACTER validOEname(INPUT icJsonTableName         AS CHAR
                                        ,INPUT icJsonFieldOrParentName AS CHAR 
                                        ,INPUT iiLevel                 AS INT
                                        ,INPUT ibTable                 AS LOG):
    DEF VAR cValidName AS CHAR NO-UNDO.
    DEF VAR icJsonName AS CHAR NO-UNDO.
    DEF VAR Char1      AS INT  NO-UNDO.
    DEF VAR ix         AS INT  NO-UNDO.
    
    DEF BUFFER ttTables FOR ttTables.
    DEF BUFFER ttFields FOR ttFields.
    
    IF ibTable THEN DO:
      FIND FIRST ttTables
           WHERE ttTables.JsonTableName = icJsonTableName
             AND ttTables.ParentJsonTableName = icJsonFieldOrParentName
             AND ttTables.Level = iiLevel
           NO-ERROR.
      IF AVAIL ttTables THEN     
         RETURN ttTables.TableName.
      cValidName = icJsonTableName.
    END.  
    ELSE   
      cValidName = icJsonFieldOrParentName.

    IF cValidName = "/" THEN cValidName = "r".
    ELSE IF cValidName BEGINS "/" THEN cValidName = TRIM(cValidName,"/").
      
    icJsonName = cValidName.

    REPEAT:
      ASSIGN Char1 = ASC(SUBSTR(cValidName,1,1))
             ix    = ix + 1.
      IF Char1 < 65 OR (Char1 > 90 AND Char1 < 97) OR Char1 > 122 THEN
        cValidName = SUBSTR(cValidName,2) + SUBSTR(cValidName,1,1).
      ELSE LEAVE.
      IF ix > 10 THEN DO:
        cValidName = "JB_" + SUBSTR(icJsonName,1,29).
        LEAVE.
      END.
    END.
    
    cValidName = REPLACE(cValidName,"<","_lt_").
    cValidName = REPLACE(cValidName,">","_gt_").
    cValidName = REPLACE(cValidName,"/:","_slc_").
    cValidName = REPLACE(cValidName,"/","_sl_").
    cValidName = REPLACE(cValidName,"\/","_sl_").
    cValidName = REPLACE(cValidName,CHR(123),"_clb_").    
    cValidName = REPLACE(cValidName,CHR(125),"_crb_").    
    cValidName = REPLACE(cValidName,".","").    
    cValidName = REPLACE(cValidName,"+","").    
    cValidName = TRIM(cValidName,"\/").    

    IF KEYWORD(cValidName) NE ? OR CAN-DO(reservedNames,cValidName) THEN 
      cValidName = cValidName + "_".
      
    IF LENGTH(cValidName) > 32 THEN 
      ASSIGN iNameSeq = iNameSeq + 1
             iNameSeq = MIN(99,iNameSeq) 
             cValidName = SUBSTR(cValidName,1,30) + STRING(iNameSeq,"99") 
             .
             
    RETURN cValidName.

  END METHOD.
  */
	DESTRUCTOR PUBLIC JBoxXml ( ):
	  APPLY "close" TO hXmlLib.
	  DELETE PROCEDURE hXmlLib. 
	END DESTRUCTOR.

END CLASS.