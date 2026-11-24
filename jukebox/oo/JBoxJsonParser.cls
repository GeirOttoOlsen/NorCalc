 
 /*------------------------------------------------------------------------
    File        : Bring
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : gry
    Created     : Wed May 19 13:39:20 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Json.ObjectModel.ObjectModelParser.
USING progress.Json.*.
USING progress.Json.ObjectModel.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxJsonParser: 
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  
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
      INDEX TableName     TableName ParentTableName Level
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
  
  DEF TEMP-TABLE ttErrors NO-UNDO
      FIELD TableName           AS CHAR
      FIELD FieldName           AS CHAR
      FIELD DataType            AS CHAR
      FIELD JsonValue           AS CHAR
      FIELD ErrorMessage        AS CHAR
      .               

  DEF TEMP-TABLE ttRenameArray NO-UNDO
      FIELD FromName AS CHAR
      FIELD ToName   AS CHAR
      .

  DEF TEMP-TABLE ttView
      FIELD httView    AS HANDLE
      FIELD FillString AS CHAR
      .

  DEF TEMP-TABLE ttViewTableDef
      FIELD httView       AS HANDLE
      FIELD ViewTableName AS CHAR
      FIELD ViewTableSeq  AS INT
      FIELD FieldMap      AS CHAR
      FIELD ExceptList    AS CHAR
      FIELD BufferFields  AS CHAR
      FIELD FieldPropList AS CHAR
      FIELD JoinOper      AS CHAR
      FIELD JoinType      AS CHAR
      FIELD JoinCrit      AS CHAR
      FIELD ExtraFields   AS CHAR
      .
            
  DEF VAR oParser                    AS ObjectModelParser NO-UNDO.
  DEF VAR JsonLongChar               AS LONGCHAR          NO-UNDO.
  DEF VAR iGlobTableSeq              AS INT               NO-UNDO.
  DEF VAR iNameSeq                   AS INT               NO-UNDO.
  DEF VAR bHideJboxRowIdent          AS LOG               NO-UNDO.
  DEF VAR cTablePrefix               AS CHAR              NO-UNDO.  
  DEF VAR cPrimaryIdxFields          AS CHAR              NO-UNDO.
  DEF VAR c4GLschemaFile             AS CHAR              NO-UNDO.      
  
  DEF PUBLIC    PROPERTY ABLidxFields AS CHAR    NO-UNDO  GET. SET.
  DEF PUBLIC    PROPERTY ABLfieldList AS CHAR    NO-UNDO  GET. SET.
  DEF PROTECTED PROPERTY hParent     AS HANDLE   NO-UNDO GET. SET.
  DEF PROTECTED PROPERTY iGlobId     AS INT      NO-UNDO GET. SET.
  DEF PUBLIC    PROPERTY cSchemaName AS CHAR     NO-UNDO GET. SET.
  DEF PROTECTED PROPERTY cOrgNumFormat AS CHAR   NO-UNDO GET. SET.
  
  DEF PUBLIC PROPERTY keepParsedTextFile AS LOG  NO-UNDO GET. SET.
            
  DEF PUBLIC PROPERTY hdsSchema   AS HANDLE  NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY hdsResult   AS HANDLE  NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY hdsView     AS HANDLE  NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY hbttErrors  AS HANDLE  NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY httView     AS HANDLE  NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY hbttTables  AS HANDLE  NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY hbttFields  AS HANDLE  NO-UNDO GET. SET.

  DEF PUBLIC PROPERTY logFile AS CHAR NO-UNDO GET.
      SET (INPUT icLogFile AS CHAR):
        logFile = icLogfile.
        IF logFile NE "" THEN 
          LOG-MANAGER:LOGFILE-NAME = icLogFile.
      END SET.
  DEF PUBLIC PROPERTY statusMessage    AS CHAR NO-UNDO GET. 
      PROTECTED SET (INPUT icStatusMessage AS CHAR):
        statusMessage = icStatusMessage.
        IF icStatusMessage NE "" AND logFile NE "" THEN
          LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(2) + " " + icStatusMessage).
      END SET. 
  DEF PUBLIC PROPERTY schemaWarning    AS CHAR NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY logFieldErrors   AS LOGICAL NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY fieldErrorCount  AS INT NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY returnBlankWhenNoValue AS LOGICAL NO-UNDO GET. SET. 
  DEF PUBLIC PROPERTY reservedNames  AS CHAR NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY createTableForEmptyArrays AS LOG NO-UNDO GET. SET.

  /* To substitute a tablename for a (previous) field value in the object.
     F.ex to make two branches from two otherwise similar objects:
           "evidenceValues": [
        {
            "evidenceValueName": "enhetsinformasjon",
            "source": "Enhetsregisteret",
            "timestamp": "2022-10-26T10:30:32.1956146Z",
            "value": "{\"tildaenhet\":\"910441124\",\"tildaenhetNavn\":\"BEGNA BRUK AS\",\"besoeksadresse\":{\"adressenavn\":\"Begnavegen 215\",\"postnummer\":\"2937\",\"poststedsnavn\":\"BEGNA\",\"kommunenummer\":\"3449\",\"fylkesnummer\":\"3449\"},\"naeringskode\":\"16.100\",\"organisasjonsform\":\"AS\",\"regnskapsInformasjon\":{\"fraDato\":\"2021-01-01T00:00:00\",\"tilDato\":\"2021-12-31T00:00:00\",\"aarligOmsetning\":\"393734000\"},\"driftsstatus\":\"ok\"}",
            "valueType": "jsonSchema"
        },
        {
            "evidenceValueName": "tilsynsrapporter",
            "source": "974761211",
            "timestamp": "2022-10-26T10:30:32.195639Z",
            "value": "{\"status\":\"ok\",\"statustekst\":\"OK. ElapsedMs: 5508\",\"tilsynsmyndighet\":\"974761211\",\"tilsynsrapporter\":[]}",
            "valueType": "jsonSchema"
        },
    
    In this case set fieldsUsedAsTableName = "evidenceValueName". to split "enhetsinformasjon" and "tilsynsrapporter".   
    
    fieldUsedAsTableName has an initial value of "abc" - to force full scan of the file when building the schema
  */
  DEF PUBLIC PROPERTY fieldsUsedAsTableName AS CHAR NO-UNDO GET. SET.
  
  DEF PUBLIC PROPERTY specialUrlCharSourceList AS CHAR NO-UNDO INIT "Æ,Ø,Å,æ,ø,å" GET. SET.
  DEF PUBLIC PROPERTY specialUrlCharTargetList AS CHAR NO-UNDO INIT "%C3%86,%C3%98,%C3%85,%C3%A6,%C3%B8,%C3%A5" GET. SET.

   def public property rowidentsHidden  as log no-undo INIT YES get.
      set(input ipValue as log):
        rowidentsHidden = ipValue.
      end set.


  DEFINE DATASET dsSchema FOR ttTables, ttFields
         DATA-RELATION ttFields FOR ttTables, ttFields RELATION-FIELDS ( TableName, TableName ) NESTED
         .

  DEFINE DATASET dsView FOR ttView, ttViewTableDef
         DATA-RELATION ttViewTableDef FOR ttView, ttViewTableDef RELATION-FIELDS ( httView, httView ) NESTED
         .
              
  CONSTRUCTOR PUBLIC JBoxJsonParser ():
    
    cOrgNumFormat = SESSION:NUMERIC-FORMAT.
    IF TRIM(cOrgNumFormat) = "," THEN cOrgNumFormat = "European".
    hParent = SOURCE-PROCEDURE.
    FIX-CODEPAGE(JsonLongChar) = "UTF-8".
    ASSIGN hdsSchema = DATASET dsSchema:HANDLE
           hdsView   = DATASET dsView:HANDLE
           hbttErrors = BUFFER ttErrors:HANDLE
           hbttTables = BUFFER ttTables:HANDLE
           hbttFields = BUFFER ttFields:HANDLE
           .
    reservedNames = "value,status,alias,message,locked,text,userid,label,format,available,color,ascending,self,first,last,each,next,page,title".
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED LOGICAL AssignValue(INPUT icTableName AS CHAR, INPUT icJsonType AS CHARACTER,INPUT ihTargetFld AS HANDLE,INPUT icValue AS CHAR,INPUT ihFldLength AS HANDLE  ):
    CASE icJsonType:
      WHEN "BOOLEAN" THEN DO:
        IF ihTargetFld:DATA-TYPE = "LOGICAL" THEN ihTargetFld:BUFFER-VALUE = LOGICAL(icValue).
        ELSE IF ihTargetFld:DATA-TYPE = "DECIMAL" THEN ihTargetFld:BUFFER-VALUE = LOOKUP(icValue,"false,true").
        ELSE ihTargetFld:BUFFER-VALUE = icValue. 
      END. 
      WHEN "NUMBER" THEN DO:
        IF ihTargetFld:DATA-TYPE = "CHARACTER" THEN
          ihTargetFld:BUFFER-VALUE = STRING(icValue).
        ELSE DO:
          IF icValue = "true" THEN icValue = "1".
          ELSE IF icValue = "false" THEN icValue = "0".  
          ihTargetFld:BUFFER-VALUE = DECIMAL(icValue).
        END.  
      END.  
      OTHERWISE DO: /* STRING */
        IF ihTargetFld:DATA-TYPE = "DATE" THEN
          ihTargetFld:BUFFER-VALUE = DATE(INT(SUBSTR(STRING(icValue),6,2)),INT(SUBSTR(STRING(icValue),9,2)),INT(SUBSTR(STRING(icValue),1,4))).
        ELSE IF ihTargetFld:DATA-TYPE = "DATETIME" AND LENGTH(icValue) GE 19 THEN
          ihTargetFld:BUFFER-VALUE = DATETIME(INT(SUBSTR(STRING(icValue),6,2)),INT(SUBSTR(STRING(icValue),9,2)),INT(SUBSTR(STRING(icValue),1,4)),INT(SUBSTR(STRING(icValue),12,2)),INT(SUBSTR(STRING(icValue),15,2)),INT(SUBSTR(STRING(icValue),18,2))).
        ELSE IF ihTargetFld:DATA-TYPE = "DATETIME" THEN
          ihTargetFld:BUFFER-VALUE = DATETIME(INT(SUBSTR(STRING(icValue),6,2)),INT(SUBSTR(STRING(icValue),9,2)),INT(SUBSTR(STRING(icValue),1,4)),INT(SUBSTR(STRING(icValue),12,2)),INT(SUBSTR(STRING(icValue),15,2))).
        ELSE IF CAN-DO("INTEGER,INT64,DECIMAL",ihTargetFld:DATA-TYPE) THEN
          ihTargetFld:BUFFER-VALUE = DECIMAL(icValue).  
        ELSE DO:
          ihTargetFld:BUFFER-VALUE = icValue.
//          ihTargetFld:BUFFER-VALUE = CODEPAGE-CONVERT(icValue,SESSION:CHARSET,"utf-8").
          IF LENGTH(icValue) > ihFldLength:BUFFER-VALUE THEN  
             ihFldLength:BUFFER-VALUE = MIN(LENGTH(icValue),255).
        END.         
      END. 
    END CASE.    
    
    RETURN YES.
    
    CATCH eAny AS Progress.Lang.Error :
      fieldErrorCount = fieldErrorCount + 1.
      IF logFieldErrors THEN DO:
        CREATE ttErrors.
        ASSIGN ttErrors.TableName    = icTableName
               ttErrors.FieldName    = ihTargetFld:NAME
               ttErrors.DataType     = ihTargetFld:DATA-TYPE
               ttErrors.JsonValue    = icValue
               ttErrors.ErrorMessage = eAny:GetMessage(1)
               .
      END.
      ELSE           
        StatusMessage = "Error in AssignValue: " + eAny:GetMessage(1) + " Field: " + ihTargetFld:NAME + " Json type: " + icJsonType + " Value: " + icValue.
        
      RETURN NO.  
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER buildDsResultViewDef(INPUT icJoinType AS CHAR):
    
    DEF VAR ix       AS INT  NO-UNDO.
    DEF VAR iy       AS INT  NO-UNDO.
    DEF VAR cViewDef AS CHAR NO-UNDO.
    
    icJoinType = TRIM(icJoinType).
    IF icJoinType = "" THEN icJoinType = "OUTER-JOIN".
    
    cViewDef = hdsResult:GET-BUFFER-HANDLE (1):NAME.
    
    DO ix = 1 TO hdsResult:NUM-RELATIONS:
      cViewDef = cViewDef + ","
               + hdsResult:GET-RELATION(ix):CHILD-BUFFER:NAME
               + "|".
      DO iy = 1 TO NUM-ENTRIES(hdsResult:GET-RELATION(ix):RELATION-FIELDS) BY 2:
        cViewDef = cViewDef + hdsResult:GET-RELATION(ix):CHILD-BUFFER:NAME 
                 + "." + ENTRY(iy + 1,hdsResult:GET-RELATION(ix):RELATION-FIELDS)
                 + " = " + hdsResult:GET-RELATION(ix):PARENT-BUFFER:NAME
                 + "." + ENTRY(iy,hdsResult:GET-RELATION(ix):RELATION-FIELDS)
                 + " " + icJoinType
                 .
      END.           
    END.  
    
    cViewDef = cViewDef + ";+jbCountDistinct|INTEGER|>>>>>>>>9;+jbAverage|DECIMAL|->>>>>>>>9.99".    
    
    RETURN cViewDef.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LONGCHAR codepageConvert( INPUT ilcSource AS LONGCHAR ):
    
    DEFINE VARIABLE result AS LONGCHAR NO-UNDO.
    DEF VAR lcReturn AS LONGCHAR NO-UNDO.
  
    def var bcp as log no-undo.
  
    FIX-CODEPAGE(lcReturn) = "utf-8".
    FIX-CODEPAGE(result) = "utf-8".
  
    IF NUM-ENTRIES(ilcSource,CHR(10)) < 3 THEN
      ilcSource = REPLACE(ilcSource,"},","}," + CHR(10)).
       
    DEF VAR cLine AS CHAR NO-UNDO.
    DEF VAR cFile AS CHAR NO-UNDO.
    cFile = SESSION:TEMP-DIR + "response_" + STRING(TIME) + ".json".
    COPY-LOB FROM OBJECT ilcSource TO FILE cFile.

    INPUT FROM VALUE(cFile).
    REPEAT ON ERROR UNDO, LEAVE:
      IMPORT UNFORMATTED cLine.
      cLine = REPLACE(cLine,"\u00e6","æ").
      cLine = REPLACE(cLine,"\u00f8","ø").
      cLine = REPLACE(cLine,"\u00e5","å").
      cLine = REPLACE(cLine,"\u00c6","Æ").
      cLine = REPLACE(cLine,"\u00d8","Ø").
      cLine = REPLACE(cLine,"\u00c5","Å").
      cLine = REPLACE(cLine,"\u00e1","á"). 
      cLine = REPLACE(cLine,"\u0161","š").
      result = result + (IF result NE "" THEN CHR(10) ELSE "") + cLine.
      CATCH eErr AS Progress.Lang.Error :
        MESSAGE eErr:GetMessage(1)
        VIEW-AS ALERT-BOX.  
      END CATCH.
    END.
    INPUT CLOSE.  

    lcReturn = result.

    RETURN lcReturn.

  END METHOD.

  METHOD PUBLIC LOGICAL createSchemaAndLoadData (INPUT ilcData      AS LONGCHAR).
    THIS-OBJECT:createSchema(ilcData,"").
    RETURN statusMessage = "".
  END METHOD.

  METHOD PUBLIC LOGICAL createSchemaAndLoadData (INPUT icData      AS CHAR).
    DEF VAR lcData AS LONGCHAR NO-UNDO.
    FIX-CODEPAGE(lcData) = "UTF-8".
    lcData = icData.
    THIS-OBJECT:createSchema(lcData,"").
    RETURN statusMessage = "".
  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose: 
   Notes:   Feil i navngivning..
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL createSchema (INPUT ilcData      AS LONGCHAR
                                     ,INPUT icSchemaName AS CHAR):
    
    DEF VAR oJsonObject      AS JsonObject                 NO-UNDO.
    DEF VAR oJsonArray       AS JsonArray                  NO-UNDO.
    DEF VAR cDataString      AS CHAR     NO-UNDO.
    DEF VAR cReturn          AS CHAR     NO-UNDO.
    DEF VAR idValue          AS INT      NO-UNDO.
    DEF VAR httTable         AS HANDLE   NO-UNDO.
    DEF VAR lcText           AS LONGCHAR NO-UNDO.
    DEF VAR lcText2          AS LONGCHAR NO-UNDO.
    DEF VAR iy               AS INT      NO-UNDO.
    DEF VAR iCurrTableSeq    AS INT      NO-UNDO.
    DEF VAR cFile            AS CHAR     NO-UNDO.

    IF KEYWORD(icSchemaName) NE ? THEN DO:
      statusMessage = "Dataset schema cannot be named as keyword " + KEYWORD(icSchemaName).
      RETURN NO.
    END.  
                
//    IF INDEX(ilcData,"\u00") > 0 THEN ilcData = codepageConvert(ilcData).                
                
    SESSION:NUMERIC-FORMAT = "American".
                
    IF VALID-HANDLE(hdsResult) THEN 
      DELETE OBJECT hdsResult.
    
    CREATE DATASET hdsResult.
        
    FIX-CODEPAGE(lcText)  = "UTF-8".    
    FIX-CODEPAGE(lcText2) = "UTF-8".    
     
    ASSIGN JsonLongChar  = ilcData
           statusMessage = ""
           .
 
    IF icSchemaName NE "refreshSchema" THEN DO:
      ASSIGN iGlobId = 0
             iNameSeq = 0
             iGlobTableSeq = 0
             .
      DATASET dsSchema:EMPTY-DATASET ().
      cSchemaName = (IF icSchemaName NE "" THEN icSchemaName ELSE "ttJsonHeader").    
      cSchemaName = THIS-OBJECT:CreateTtTable(cSchemaName,"",0,0,"",OUTPUT httTable,OUTPUT iCurrTableSeq).
    END.  
    ELSE reBuildSchemaTables(). 
        
    oParser = NEW ObjectModelParser().
    oJsonObject = CAST(oParser:Parse(JsonLongChar), JsonObject) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      oJsonArray = CAST(oParser:Parse(JsonLongChar), JsonArray) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO iy = 1 TO oJsonArray:LENGTH:
        lcText2  = oJsonArray:getJsonText(iy).
        IF oJsonArray:GetType(iy) = Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
          lcText = oJsonArray:getJsonText(iy).
          oJsonObject = CAST(oParser:Parse(lcText), JsonObject) NO-ERROR.
          IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
            MESSAGE "Invalid cast to object in array ttJsonHeader" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
            VIEW-AS ALERT-BOX.
          ELSE  
            THIS-OBJECT:CreateJsonObjectSchema(oJsonObject,cSchemaName,"",1,1,httTable).
        END.
        ELSE
          MESSAGE "Simple array not supported:" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX.
      END.
    END.  
    ELSE  
      THIS-OBJECT:CreateJsonObjectSchema(oJsonObject,cSchemaName,"",1,1,httTable).
    
    THIS-OBJECT:prepareSchema(cSchemaName).

    FIND FIRST ttTables 
         WHERE ttTables.TableName = cSchemaName
           AND ttTables.ParentTableName = ""
         NO-ERROR.
    IF NOT AVAIL ttTables THEN DO:
      MESSAGE "No schema was generated"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO.
    END.

    IF icSchemaName = "refreshSchema" THEN RETURN YES. // Caller is responsible for re-appending the data again
        
    ttTables.hBuffer:BUFFER-CREATE ().
    ASSIGN iGlobId = iGlobId + 1
           ttTables.hBuffer::JBoxRowIdent = iGlobId
           ttTables.hBuffer::JBoxParentRowIdent = 0
           .
    
    oParser = NEW ObjectModelParser().
    oJsonObject = CAST(oParser:Parse(JsonLongChar), JsonObject) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN DO:
      oJsonArray = CAST(oParser:Parse(JsonLongChar), JsonArray) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO iy = 1 TO oJsonArray:LENGTH:
        lcText2  = oJsonArray:getJsonText(iy).
        IF iy > 1 THEN DO:
          ttTables.hBuffer:BUFFER-CREATE ().
          ASSIGN iGlobId = iGlobId + 1
                 ttTables.hBuffer::JBoxRowIdent = iGlobId
                 ttTables.hBuffer::JBoxParentRowIdent = 0
                 .
        END.
        CASE oJsonArray:GetType(iy):
          WHEN Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
            lcText = oJsonArray:getJsonText(iy).
            oJsonObject = CAST(oParser:Parse(lcText), JsonObject) NO-ERROR.
            IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
              MESSAGE "Invalid cast to object in array ttJsonHeader" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
              VIEW-AS ALERT-BOX.
            THIS-OBJECT:readJsonData(oJsonObject,cSchemaName,1,iGlobId,ttTables.hBuffer,ttTables.Seq).
          END.
          OTHERWISE
            MESSAGE "Simple array not supported:" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
                    VIEW-AS ALERT-BOX.
/*              ttTables.hBuffer::BUFFER-FIELD(cFldOrTable):BUFFER-VALUE = lcText2. */              
        END CASE.
      END.
      ELSE DO:
/*        IF ERROR-STATUS:GET-NUMBER(1) = 16068 THEN DO:                                   */
/*          hdsSchema:EMPTY-DATASET ().                                                    */
/*          cFile = SESSION:TEMP-DIR + icSchemaName + "_" + STRING(time) + ".json".        */
/*          COPY-LOB FROM object ilcData TO file cFile CONVERT TARGET CODEPAGE "iso8859-1".*/
/*          ilcData = "".                                                                  */
/*          COPY-LOB FROM file cFile TO OBJECT ilcData.                                    */
/*          createSchema(ilcData, icSchemaName).                                           */
/*        END.                                                                             */
/*        ELSE                                                                             */
        statusMessage = ERROR-STATUS:GET-MESSAGE(1).
      END.
    END.
    ELSE THIS-OBJECT:readJsonData(oJsonObject,cSchemaName,1,iGlobId,ttTables.hBuffer,ttTables.Seq).
   
    FOR EACH ttFields: 
      IF VALID-HANDLE(ttFields.hField) THEN DO:
        IF ttFields.DataType = "CHARACTER" AND ttFields.Length > 0 THEN
           ttFields.hField:FORMAT = "x(" + STRING(ttFields.Length) + ")".
           
        ttFields.FormatString = ttFields.hField:FORMAT.
      END.      
    END.
             
    CATCH eAny AS Progress.Lang.Error :
      IF eAny:GetMessageNum(1) = 12009 OR eAny:GetMessageNum(1) = 16068 THEN DO: 
        hdsSchema:EMPTY-DATASET ().
        cFile = SESSION:TEMP-DIR + icSchemaName + "_" + STRING(time) + ".json".
        COPY-LOB FROM object ilcData TO file cFile.
        ilcData = "".
        COPY-LOB FROM file cFile TO OBJECT ilcData.
        createSchema(ilcData, icSchemaName).
      END.  
      ELSE StatusMessage = eAny:GetMessage(1) + " (Caller: " + PROGRAM-NAME(2) + ")".
    END CATCH.
    
    FINALLY:
      SESSION:NUMERIC-FORMAT = cOrgNumFormat.
      RETURN statusMessage = "".
    END FINALLY.

  END METHOD.

  METHOD PROTECTED VOID CreateJsonObjectSchema (ioJsonObject           AS JsonObject
                                               ,icParentJsonTableName  AS CHAR
                                               ,icGrandPaJsonTableName AS CHAR   
                                               ,iiLevel                AS INT
                                               ,iiParentTableSeq       AS INT
                                               ,ihttTable              AS HANDLE):

    DEF VAR myArray           AS CHAR          EXTENT NO-UNDO.
    DEF VAR ix                AS INT           NO-UNDO.
    DEF VAR iy                AS INT           NO-UNDO.
    DEF VAR lcText            AS LONGCHAR      NO-UNDO.  
    DEF VAR oJsonObject       AS JsonObject    NO-UNDO. 
    DEF VAR oJsonArray        AS JsonArray     NO-UNDO.
    DEF VAR cJsonFldOrTable   AS CHAR          NO-UNDO.
    DEF VAR cOEname           AS CHAR          NO-UNDO.     
    DEF VAR httTable          AS HANDLE        NO-UNDO.
    DEF VAR bValueArray       AS LOG           NO-UNDO.
    DEF VAR cNumberFormat     AS CHAR          NO-UNDO.
    DEF VAR cUseAsObjName     AS CHAR          NO-UNDO.
    DEF VAR lcText2           AS LONGCHAR      NO-UNDO.  
    DEF VAR iCurrTableSeq         AS INT           NO-UNDO.
    DEF VAR cType             AS CHAR          NO-UNDO.

    DEF BUFFER ttTables FOR TEMP-TABLE ttTables.
    DEF BUFFER ttFields FOR TEMP-TABLE ttFields.

    FIX-CODEPAGE(lcText) = "utf-8".
    FIX-CODEPAGE(lcText2) = "utf-8".

    myArray = ioJsonObject:GetNames().
            
    DO ix = 1 TO EXTENT(myArray):
      lcText  = ioJsonObject:getJsonText(myArray[ix]).
      
      cJsonFldOrTable = myArray[ix].

      IF ioJsonObject:GetType(cJsonFldOrTable) = Progress.Json.ObjectModel.JsonDataType:NULL THEN 
        NEXT.
      ELSE IF ioJsonObject:GetType(cJsonFldOrTable) = Progress.Json.ObjectModel.JsonDataType:ARRAY THEN DO:
        oJsonArray = CAST(oParser:Parse(lcText), JsonArray).
        bValueArray = YES.
        IF oJsonArray:LENGTH > 0 THEN DO iy = 1 TO oJsonArray:LENGTH:
          IF oJsonArray:GetType(iy) = Progress.Json.ObjectModel.JsonDataType:NULL THEN 
            NEXT.
          FIND FIRST ttRenameArray WHERE ttRenameArray.FromName = cJsonFldOrTable NO-ERROR.
          IF AVAIL ttRenameArray THEN cJsonFldOrTable = ttRenameArray.ToName.

          IF iy = 1 THEN 
            cOEname = THIS-OBJECT:CreateTtTable(cJsonFldOrTable,icParentJsonTableName,iiLevel,iiParentTableSeq,cType,OUTPUT httTable,OUTPUT iCurrTableSeq).
          
          IF oJsonArray:GetType(iy) = Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
            bValueArray = NO.
            lcText = oJsonArray:getJsonText(iy).
            
            oJsonObject = CAST(oParser:Parse(lcText), JsonObject).
            THIS-OBJECT:CreateJsonObjectSchema(oJsonObject, cJsonFldOrTable,icParentJsonTableName, iiLevel + 1,iCurrTableSeq, httTable).
          END.
          ELSE IF NOT cJsonFldOrTable MATCHES ("JBox*Rowident") THEN DO:  
            FIND FIRST ttFields 
                 WHERE ttFields.JsonTableName = cJsonFldOrTable
                   AND ttFields.JsonFieldName = cJsonFldOrTable
                   AND ttFields.ParentJsonTableName = icParentJsonTableName // icGrandPaJsonTableName
                   AND ttFields.Level = iiLevel
                   AND ttFields.TableSeq = iCurrTableSeq
                 NO-ERROR.
            IF NOT AVAIL ttFields THEN DO ON ERROR UNDO, THROW:      
              CREATE ttFields.
              ASSIGN ttFields.JsonFieldName = cJsonFldOrTable
                     ttFields.JsonTableName = cJsonFldOrTable
                     ttFields.ParentJsonTableName = icParentJsonTableName
                     ttFields.TableName     = cOEname
                     ttFields.FieldName     = THIS-OBJECT:validOEname(cJsonFldOrTable,cJsonFldOrTable,0,NO)
                     ttFields.Level         = iiLevel
                     ttFields.Seq           = 1
                     ttFields.TableSeq      = iCurrTableSeq
                     .
              CASE oJsonArray:GetType(iy):
                WHEN Progress.Json.ObjectModel.JsonDataType:STRING THEN DO:
                  httTable:ADD-NEW-FIELD(ttFields.FieldName,"CHARACTER",0,"x(30)").
                  ttFields.DataType = "CHARACTER".
                END.   
                WHEN Progress.Json.ObjectModel.JsonDataType:BOOLEAN THEN DO:
                  httTable:ADD-NEW-FIELD(ttFields.FieldName,"LOGICAL"). 
                  ttFields.DataType = "LOGICAL".
                END.   
                WHEN Progress.Json.ObjectModel.JsonDataType:NUMBER THEN DO:
                  httTable:ADD-NEW-FIELD(ttFields.FieldName,"DECIMAL",0,"->>,>>>,>>>,>>9.99").
                  ttFields.DataType = "DECIMAL".
                END.   
              END CASE.
              CATCH eErr AS Progress.Lang.Error :
                statusMessage = "Error adding array field " + ttFields.TableName + "." + ttFields.FieldName + CHR(10) 
                              + eErr:GetMessage(1).
              END CATCH.
            END.  
          END.
          IF bValueArray THEN LEAVE.
        END.
        ELSE IF createTableForEmptyArrays THEN
          cOEname = THIS-OBJECT:CreateTtTable(cJsonFldOrTable,icParentJsonTableName,iiLevel,iiParentTableSeq,cType,OUTPUT httTable,OUTPUT iCurrTableSeq).
          
      END.  
      ELSE IF ioJsonObject:GetType(cJsonFldOrTable) = Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
        oJsonObject = CAST(oParser:Parse(lcText), JsonObject).
        IF cUseAsObjName = "" THEN cUseAsObjName = cJsonFldOrTable.

        IF iiLevel = 1 THEN cType = cSchemaName.
        ELSE cType = getUniqueDs (iiParentTableSeq).

        FIND FIRST ttTables 
             WHERE ttTables.JsonTableName   = cJsonFldOrTable
               AND ttTables.ParentJsonTableName = icParentJsonTableName
               AND ttTables.Level = iiLevel
               AND ttTables.ParentSeq = iiParentTableSeq
             NO-ERROR.
                     
        IF NOT AVAIL ttTables THEN 
          cOEname = THIS-OBJECT:CreateTtTable(cJsonFldOrTable,icParentJsonTableName,iiLevel,iiParentTableSeq,cType,OUTPUT httTable,OUTPUT iCurrTableSeq).
        ELSE ASSIGN httTable = ttTables.hTable
                    iCurrTableSeq = ttTables.Seq.  
        THIS-OBJECT:CreateJsonObjectSchema(oJsonObject,cJsonFldOrTable,icParentJsonTableName,iiLevel + 1,iCurrTableSeq,httTable).
      END.
      ELSE IF lcText NE ? AND SUBSTR(lcText,1,2) = CHR(123) + CHR(92) THEN DO:
        DO ON ERROR UNDO, THROW:
          lcText2 = ioJsonObject:GetCharacter(cJsonFldOrTable).
          CATCH eText AS Progress.Lang.Error :
            lcText2 = REPLACE(ioJsonObject:GetJsonText(cJsonFldOrTable),'\"','"').   
          END CATCH.
        END.
        lcText = lcText2.
                                   
        lcText = trim(lcText,'"').
        oJsonObject = CAST(oParser:Parse(lcText), JsonObject).

        IF cUseAsObjName = "" THEN cUseAsObjName = cJsonFldOrTable.

        FIND FIRST ttTables 
             WHERE ttTables.JsonTableName   = cJsonFldOrTable
               AND ttTables.ParentJsonTableName = icParentJsonTableName
               AND ttTables.Level = iiLevel
               AND ttTables.ParentSeq = iiParentTableSeq
             NO-ERROR.
                
        IF NOT AVAIL ttTables THEN  
          cOEname = THIS-OBJECT:CreateTtTable(cUseAsObjName,icParentJsonTableName,iiLevel,iiParentTableSeq,cType,OUTPUT httTable,OUTPUT iCurrTableSeq).
        ELSE ASSIGN httTable = ttTables.hTable
                    iCurrTableSeq = ttTables.Seq.  
        THIS-OBJECT:CreateJsonObjectSchema(oJsonObject,cUseAsObjName,icParentJsonTableName,iiLevel + 1,iCurrTableSeq,httTable).
      END.
      ELSE IF NOT cJsonFldOrTable MATCHES ("JBox*Rowident") THEN DO:
        FIND FIRST ttTables 
             WHERE ttTables.JsonTableName = icParentJsonTableName
               AND ttTables.Level         = iiLevel - 1
               AND ttTables.Seq           = iiParentTableSeq
             NO-ERROR.
        IF NOT AVAIL ttTables AND iiLevel = 1 AND icParentJsonTableName = cSchemaName THEN DO:
          FIND FIRST ttTables
               WHERE ttTables.JsonTableName = cSchemaName
               NO-ERROR.
          IF NOT AVAIL ttTables THEN     
            FIND FIRST ttTables
                 WHERE ttTables.TableName = cSchemaName
                 NO-ERROR.
        END.        
        IF NOT AVAIL ttTables THEN DO:
          MESSAGE "Could not identify parent table for field" cJsonFldOrTable SKIP
                  "Level: " iiLevel - 1 SKIP
                  "Parent: " icParentJsonTableName SKIP
                  "Schema name: " cSchemaName SKIP
                  "Unique parent:" cType
          VIEW-AS ALERT-BOX.
          RETURN.
        END.     
              
        FIND FIRST ttFields 
             WHERE ttFields.JsonFieldName       = cJsonFldOrTable
               AND ttFields.TableSeq            = ttTables.Seq
             NO-ERROR.

        IF CAN-DO(fieldsUsedAsTableName,cJsonFldOrTable) THEN 
          cUseAsObjName = STRING(lcText).

        IF NOT AVAIL ttFields THEN DO ON ERROR UNDO, THROW:      
          CREATE ttFields.
          ASSIGN ttFields.JsonTableName       = icParentJsonTableName
                 ttFields.JsonFieldName       = cJsonFldOrTable
                 ttFields.ParentJsonTableName = icGrandPaJsonTableName
                 ttFields.FieldName           = validOEname(icParentJsonTableName,cJsonFldOrTable,0,NO)
                 ttFields.Level               = iiLevel
                 ttFields.Seq                 = ix
                 ttFields.TableSeq            = ttTables.Seq
                 ttFields.TableName           = ttTables.TableName
                 .
          CASE ioJsonObject:GetType(cJsonFldOrTable): 
             WHEN Progress.Json.ObjectModel.JsonDataType:STRING THEN DO:
               ihttTable:ADD-NEW-FIELD(ttFields.FieldName,"CHARACTER"). 
               ttFields.DataType = "CHARACTER".
             END.   
             WHEN Progress.Json.ObjectModel.JsonDataType:BOOLEAN THEN DO:
               ihttTable:ADD-NEW-FIELD(ttFields.FieldName,"LOGICAL"). 
               ttFields.DataType = "LOGICAL".
             END.   
             WHEN Progress.Json.ObjectModel.JsonDataType:NUMBER THEN DO:
               IF NUM-ENTRIES(lcText,".") = 2 AND LENGTH(ENTRY(2,lcText,".")) > 12 THEN DO:
                 ihttTable:ADD-NEW-FIELD(ttFields.FieldName,"CHARACTER",0,"x(20)").
                 ttFields.DataType = "CHARACTER".
               END.
               ELSE DO: 
                 IF NUM-ENTRIES(lcText,".") = 2 THEN
                   cNumberFormat = "->>,>>>,>>>,>>9." + FILL("9",LENGTH(ENTRY(2,lcText,"."))).
                 ELSE cNumberFormat = "->>,>>>,>>>,>>9".  
                 ihttTable:ADD-NEW-FIELD(ttFields.FieldName,"DECIMAL",0,cNumberFormat).
                 ttFields.DataType = "DECIMAL".
               END.  
             END.   
          END CASE.
          CATCH eErr AS Progress.Lang.Error :
            statusMessage = "Error adding object field " + ttFields.TableName + "." + ttFields.FieldName + CHR(10) 
                          + eErr:GetMessage(1).
          END CATCH.
        END.                      
      END.
    END.  
    
  END METHOD.                                        

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID createTtField( INPUT icTableName       AS CHAR
                                      ,INPUT icFieldName       AS CHAR
                                      ,INPUT icDataType        AS CHAR
                                      ,INPUT icParentTableName AS CHAR
                                      ,INPUT icType            AS CHAR
                                      ,INPUT iiLevel           AS INT ):
    DEF BUFFER ttFields FOR ttFields.
    DEF BUFFER ttTables FOR ttTables.

    FIND FIRST ttTables 
         WHERE ttTables.JsonTableName = icTableName
           AND ttTables.ParentJsonTableName = icParentTableName 
           AND ttTables.Level = iiLevel
           AND ttTables.cType = icType
         NO-ERROR.
    IF AVAIL ttTables THEN DO:    
      FIND FIRST ttFields 
           WHERE ttFields.TableName = ttTables.TableName
             AND ttFields.JsonFieldName = icFieldName
           NO-ERROR.
      IF NOT AVAIL ttFields THEN DO:      
        CREATE ttFields.
        ASSIGN ttFields.JsonFieldName = icFieldName
               ttFields.JsonTableName = icTableName
               ttFields.ParentJsonTableName = icParentTableName
               ttFields.TableName     = ttTables.TableName
               ttFields.FieldName     = THIS-OBJECT:validOEname("",icFieldName,0,NO)
               ttFields.Level         = iiLevel
               ttFields.Seq           = 1
               ttFields.TableSeq      = ttTables.Seq
               .
               
        CASE icDataType:
          WHEN "CHARACTER" THEN DO:
            ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,"CHARACTER",0,"x(30)").
            ASSIGN ttFields.DataType = "CHARACTER"
                   ttFields.FormatString = "x(30)".
          END.   
          WHEN "LOGICAL" THEN DO:
            ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,"LOGICAL"). 
            ttFields.DataType = "LOGICAL".
          END.   
          WHEN "DECIMAL" THEN DO:
            ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,"DECIMAL",0,"->>,>>>,>>>,>>9.99").
            ttFields.DataType = "DECIMAL".
          END.   
        END CASE.
      END.  
    END.      
    RETURN.

  END METHOD.

  METHOD PROTECTED CHARACTER CreateTtTable (INPUT icJsonTableName   AS CHAR
                                           ,INPUT icParentJsonTableName AS CHAR
                                           ,INPUT iiLevel           AS INT
                                           ,INPUT iiParentTableSeq  AS INT
                                           ,INPUT icType            AS CHAR
                                           ,OUTPUT httTable         AS HANDLE
                                           ,OUTPUT ioTableSeq       AS INT):
    DEF VAR cOEname     AS CHAR NO-UNDO.
    DEF VAR ix          AS INT  NO-UNDO.
                     
    DEF BUFFER ttTables  FOR TEMP-TABLE ttTables.
    
    cOEname = THIS-OBJECT:validOEname(icJsonTableName,icParentJsonTableName,iiLevel,YES).
    
    FIND FIRST ttTables 
         WHERE ttTables.JsonTableName = icJsonTableName
           AND ttTables.ParentJsonTableName = icParentJsonTableName
           AND ttTables.Level = iiLevel
           AND ttTables.ParentSeq = iiParentTableSeq
//           AND ttTables.cType = icType // 1st unique (..,great,grand,) parent
         NO-ERROR.
    IF AVAIL ttTables THEN DO:     
      httTable = ttTables.hTable.
      ioTableSeq = ttTables.Seq.
      RETURN ttTables.TableName.  
    END.     
                                                       
    CREATE TEMP-TABLE httTable.
    httTable:ADD-NEW-FIELD("JBoxRowIdent","INTEGER").
    httTable:ADD-NEW-FIELD("JBoxParentRowIdent","INTEGER").
    httTable:ADD-NEW-INDEX("idxRowIdent",YES,YES).
    httTable:ADD-INDEX-FIELD("idxRowIdent","JBoxRowIdent").
    httTable:ADD-NEW-INDEX("idxParentRowIdent").
    httTable:ADD-INDEX-FIELD("idxParentRowIdent","JBoxParentRowIdent").
  
    
    IF CAN-FIND(FIRST ttTables WHERE ttTables.TableName = cOEname) THEN DO:
      cOEname = TRIM(cOEname,"_") + "_" + STRING(iiLevel) + "_" + TRIM(validOEname(icParentJsonTableName,"",0,NO),"_"). // TRIM(icParentJsonTableName,"_").
      IF LENGTH(cOEname) > 32 THEN cOEname = SUBSTR(cOEname,1,32).
      REPEAT WHILE CAN-FIND(FIRST ttTables WHERE ttTables.TableName = cOEname):
        ix = ix + 1.
        IF ix > 99 THEN LEAVE.
        cOEname = SUBSTR(cOEname,1,29) + "_" + STRING(ix,"99").
      END.  
      IF ix > 99 THEN DO: 
        schemaWarning = "Too many occurences of child name " + icJsonTableName + " for parent " + icParentJsonTableName.
        RETURN ?.  
      END.
    END.      
  
    CREATE ttTables.
    ASSIGN ttTables.TableName           = cOEname  
           ttTables.hTable              = httTable
           ttTables.cType               = (IF icType = "" THEN cSchemaName ELSE icType)
           ttTables.ParentJsonTableName = icParentJsonTableName
           ttTables.JsonTableName       = icJsonTableName
           ttTables.bIncluded           = YES
           iGlobTableSeq                = iGlobTableSeq + 1
           ttTables.Seq                 = iGlobTableSeq
//           ttTables.ParentSeq           = iiParentTableSeq
           ttTables.ParentSeq           = (IF iiLevel = 1 AND PROGRAM-NAME(2) BEGINS "CreateJson" THEN 1 ELSE iiParentTableSeq)
           ttTables.Level               = iiLevel
           ioTableSeq                   = iGlobTableSeq
           .
           
    CREATE ttFields.
    ASSIGN ttFields.TableName           = ttTables.TableName
           ttFields.FieldName           = "JBoxRowIdent"
//           ttFields.ParentJsonTableName = icParentJsonTableName
           ttFields.JsonTableName       = icJsonTableName
           ttFields.DataType            = "INTEGER"
           ttFields.Seq                 = 98
           ttFields.TableSeq            = ttTables.Seq
           .       

    CREATE ttFields.
    ASSIGN ttFields.TableName           = ttTables.TableName
           ttFields.FieldName           = "JBoxParentRowIdent"
//           ttFields.ParentJsonTableName = icParentJsonTableName
           ttFields.JsonTableName       = icJsonTableName
           ttFields.DataType            = "INTEGER"
           ttFields.Seq                 = 99
           ttFields.TableSeq            = ttTables.Seq
           .       
    
    RETURN ttTables.TableName.
           
  END METHOD.  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID deepCopyTT( INPUT ihFromTt AS HANDLE,INPUT ihToTt AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
  DEF VAR hQuery   AS HANDLE NO-UNDO.
  DEF VAR ix       AS INT NO-UNDO.
  DEF VAR hFromFld AS HANDLE NO-UNDO.
  
  IF ihFromTt:TYPE = "TEMP-TABLE" THEN ihFromTt = ihFromTt:DEFAULT-BUFFER-HANDLE.
  IF ihToTt:TYPE = "TEMP-TABLE" THEN ihToTt = ihToTt:DEFAULT-BUFFER-HANDLE.
  
  CREATE QUERY hQuery.
  hQuery:SET-BUFFERS (ihFromTt).
  hQuery:QUERY-PREPARE ("FOR EACH " + ihFromTt:NAME).
  hQuery:QUERY-OPEN ().
  REPEAT WHILE hQuery:GET-NEXT().
    ihToTt:BUFFER-CREATE ().
    DO ix = 1 TO ihToTt:NUM-FIELDS:
      hFromFld = ihFromTt:BUFFER-FIELD(ihToTt:BUFFER-FIELD (ix):NAME) NO-ERROR.
      IF VALID-HANDLE (hFromFld) THEN
        ihToTt:BUFFER-FIELD (ix):BUFFER-VALUE = hFromFld:BUFFER-VALUE. 
    END.
  END.
  DELETE OBJECT hQuery.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getTableList(  ):
    
    DEFINE VARIABLE cTableList AS CHARACTER NO-UNDO.
    FOR EACH ttTables:
      cTableList = cTableList + (IF cTableList NE "" THEN "," ELSE "") + ttTables.TableName.
    END.
    RETURN cTableList.

  END METHOD.

  METHOD PUBLIC CHARACTER getUniqueDsParent( INPUT iiSeq AS INTEGER):
    // When a xml dataset is loades, find the unique parent
    
    DEF BUFFER ttTables FOR ttTables.
 
    DEF VAR ix         AS INT NO-UNDO.
    DEF VAR bOk        AS LOG NO-UNDO.
    DEF VAR cParent    AS CHAR NO-UNDO.
    DEF VAR iParentSeq AS INT NO-UNDO.
   
    FIND FIRST ttTables
         WHERE ttTables.Seq = iiSeq
         NO-ERROR.   
    IF AVAIL ttTables THEN 
      ASSIGN cParent = ttTables.ParentJsonTableName
             iParentSeq = ttTables.ParentSeq.
    IF cParent NE "" THEN DO:
      FOR EACH ttTables 
          WHERE ttTables.JsonTableName = cParent:
        ix = ix + 1.
      END.
      IF ix > 1 THEN 
        cParent = getUniqueDsParent(iParentSeq).
    END.

    RETURN cParent.

  END METHOD.

  METHOD PUBLIC CHARACTER getUniqueDs( INPUT iiSeq AS INTEGER):
    // When a json dataset is loaded, find the unique parent for a table node
    
    DEF BUFFER ttTables FOR ttTables.
 
    DEF VAR ix        AS INT  NO-UNDO.
    DEF VAR cTable    AS CHAR NO-UNDO.
    DEF VAR iSeq      AS INT  NO-UNDO.
    DEF VAR iLevel    AS INT  NO-UNDO.
   
    FIND FIRST ttTables
         WHERE ttTables.Seq = iiSeq
         NO-ERROR.   
    IF AVAIL ttTables THEN DO: 
      ASSIGN cTable = ttTables.JsonTableName
             iSeq   = ttTables.Seq
             iLevel = ttTables.Level.
      FOR EACH ttTables 
          WHERE ttTables.JsonTableName = cTable
            AND ttTables.Level = iLevel:
        ix = ix + 1.
      END.
      IF ix > 1 THEN 
        cTable = getUniqueDsParent(iSeq).
    END.

    RETURN cTable.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getUniqueXMLParent( INPUT ihNoderef AS HANDLE):
    
    DEF BUFFER ttTables FOR ttTables.
 
    DEF VAR ix      AS INT NO-UNDO.
    DEF VAR bOk     AS LOG NO-UNDO.
    DEF VAR cParent AS CHAR NO-UNDO.
    DEF VAR hParent AS HANDLE NO-UNDO.
    
    CREATE X-NODEREF hParent.
    
    bOk = ihNoderef:GET-PARENT(hParent).
    IF bOk THEN DO:
      FOR EACH ttTables 
          WHERE ttTables.JsonTableName = hParent:LOCAL-NAME:
        ix = ix + 1.
      END.
      IF ix > 1 THEN 
        cParent = getUniqueXMLParent(hParent).
      ELSE cParent = hParent:LOCAL-NAME.
    END.
    ELSE DO:
      FIND FIRST ttTables
           WHERE ttTables.JsonTableName = ihNoderef:LOCAL-NAME
           NO-ERROR.
      IF AVAIL ttTables THEN
        cParent = ttTables.JsonTableName. 
    END.   

    DELETE OBJECT hParent.
    RETURN cParent.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL LoadData(INPUT ilcData AS LONGCHAR ):
    DEF VAR oJsonObject  AS JsonObject                NO-UNDO.
    DEF VAR oJsonArray   AS JsonArray                 NO-UNDO.
    DEF VAR lcText       AS LONGCHAR                  NO-UNDO.
    DEF VAR lcText2      AS LONGCHAR                  NO-UNDO.
    DEF VAR iy           AS INT                       NO-UNDO.
   
    FIX-CODEPAGE(lcText)  = "UTF-8".
    FIX-CODEPAGE(lcText2) = "UTF-8".
   
    ASSIGN statusMessage = ""
           fieldErrorCount = 0
           schemaWarning = "".
    
    THIS-OBJECT:renewResultDS().            
            
    ASSIGN iGlobId = 0
           JsonLongChar = ilcData
           .
    FIND FIRST ttTables 
         WHERE ttTables.TableName = cSchemaName
           AND ttTables.ParentTableName = ""
         NO-ERROR.
    IF AVAIL ttTables THEN DO: 
      ttTables.hBuffer:BUFFER-CREATE ().
      ASSIGN iGlobId = iGlobId + 1
             ttTables.hBuffer::JBoxRowIdent = iGlobId
             ttTables.hBuffer::JBoxParentRowIdent = 0
             .

      oParser = NEW ObjectModelParser().
      oJsonObject = CAST(oParser:Parse(JsonLongChar), JsonObject) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        oJsonArray = CAST(oParser:Parse(JsonLongChar), JsonArray) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN DO iy = 1 TO oJsonArray:LENGTH:
          lcText2  = oJsonArray:getJsonText(iy).
          IF iy > 1 THEN DO:
            ttTables.hBuffer:BUFFER-CREATE ().
            ASSIGN iGlobId = iGlobId + 1
                   ttTables.hBuffer::JBoxRowIdent = iGlobId
                   ttTables.hBuffer::JBoxParentRowIdent = 0
                   .
          END.
          CASE oJsonArray:GetType(iy):
            WHEN Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
              lcText = oJsonArray:getJsonText(iy).
              oJsonObject = CAST(oParser:Parse(lcText), JsonObject) NO-ERROR.
              IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
                MESSAGE "Invalid cast to object in array ttJsonHeader" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
                VIEW-AS ALERT-BOX.
              THIS-OBJECT:readJsonData(oJsonObject,cSchemaName,1,iGlobId,ttTables.hBuffer,ttTables.Seq).
            END.
            OTHERWISE
              MESSAGE "Simple array not supported:" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
                      VIEW-AS ALERT-BOX.
/*              ttTables.hBuffer::BUFFER-FIELD(cFldOrTable):BUFFER-VALUE = lcText2. */              
          END CASE.
        END.
      END.
      ELSE THIS-OBJECT:readJsonData(oJsonObject,cSchemaName,0,iGlobId,ttTables.hBuffer,ttTables.Seq).
      
      FOR EACH ttFields: 
        IF ttFields.DataType = "CHARACTER" AND ttFields.Length > 0 THEN
           ttFields.hField:FORMAT = "x(" + STRING(ttFields.Length) + ")".
           
        ttFields.FormatString = ttFields.hField:FORMAT.    
      END.
    END.  

    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).
    END CATCH.

    FINALLY:
      RETURN statusMessage = "".
    END.

  END METHOD.

  METHOD PUBLIC LOGICAL appendData(INPUT ilcData AS LONGCHAR ):
    DEF VAR oJsonObject  AS JsonObject                NO-UNDO.
    DEF VAR oJsonArray   AS JsonArray                 NO-UNDO.
    DEF VAR lcText       AS LONGCHAR                  NO-UNDO.
    DEF VAR lcText2      AS LONGCHAR                  NO-UNDO.
    DEF VAR iy           AS INT                       NO-UNDO.

    SESSION:NUMERIC-FORMAT = "American".
   
    FIX-CODEPAGE(lcText)  = "UTF-8".
    FIX-CODEPAGE(lcText2) = "UTF-8".
      
    ASSIGN statusMessage = ""
           fieldErrorCount = 0
           schemaWarning = "".
                              
    ASSIGN JsonLongChar = ilcData
           .
    FIND FIRST ttTables
         WHERE ttTables.TableName = cSchemaName
           AND ttTables.ParentTableName = ""
         NO-ERROR.

    IF AVAIL ttTables THEN DO:
      ttTables.hBuffer:FIND-FIRST("WHERE JBoxRowIdent = 1") NO-ERROR.           
      IF NOT ttTables.hBuffer:AVAIL THEN DO:       
        ttTables.hBuffer:BUFFER-CREATE ().
        ASSIGN iGlobId = iGlobId + 1
               ttTables.hBuffer::JBoxRowIdent = iGlobId
               ttTables.hBuffer::JBoxParentRowIdent = 0
               .
      END.         

      oParser = NEW ObjectModelParser().
      oJsonObject = CAST(oParser:Parse(JsonLongChar), JsonObject) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN DO:
        oJsonArray = CAST(oParser:Parse(JsonLongChar), JsonArray) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN DO iy = 1 TO oJsonArray:LENGTH:
          lcText2  = oJsonArray:getJsonText(iy).
          IF iy > 1 THEN DO:
            ttTables.hBuffer:BUFFER-CREATE ().
            ASSIGN iGlobId = iGlobId + 1
                   ttTables.hBuffer::JBoxRowIdent = iGlobId
                   ttTables.hBuffer::JBoxParentRowIdent = 0
                   .
          END.
          CASE oJsonArray:GetType(iy):
            WHEN Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
              lcText = oJsonArray:getJsonText(iy).
              oJsonObject = CAST(oParser:Parse(lcText), JsonObject) NO-ERROR.
              IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
                MESSAGE "Invalid cast to object in array ttJsonHeader" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
                VIEW-AS ALERT-BOX.
              THIS-OBJECT:readJsonData(oJsonObject,cSchemaName,1,iGlobId,ttTables.hBuffer,ttTables.Seq).
            END.
            OTHERWISE
              MESSAGE "Simple array not supported:" SKIP STRING(lcText) SKIP ERROR-STATUS:GET-MESSAGE(1)
                      VIEW-AS ALERT-BOX.
/*              ttTables.hBuffer::BUFFER-FIELD(cFldOrTable):BUFFER-VALUE = lcText2. */              
          END CASE.
        END.
        ELSE statusMessage = ERROR-STATUS:GET-MESSAGE(1).
      END.
      ELSE THIS-OBJECT:readJsonData(oJsonObject,cSchemaName,1,iGlobId,ttTables.hBuffer,ttTables.Seq).
    END.  

    FOR EACH ttFields: 
      IF VALID-HANDLE(ttFields.hField) THEN DO:
        IF ttFields.DataType = "CHARACTER" AND ttFields.Length > 0 THEN
           ttFields.hField:FORMAT = "x(" + STRING(ttFields.Length) + ")".
           
        ttFields.FormatString = ttFields.hField:FORMAT.
      END.      
    END.

    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).
    END CATCH.

    FINALLY:
      SESSION:NUMERIC-FORMAT = cOrgNumFormat.
      
      RETURN statusMessage = "".
    END.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID LoadPredefinedDS( INPUT ihDs AS HANDLE ):
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR iy AS INT NO-UNDO.
    DEF VAR hB AS HANDLE NO-UNDO.
    DEF VAR hF AS HANDLE NO-UNDO.
    DEF VAR hR AS HANDLE NO-UNDO.
        
    IF KEYWORD(ihDs:NAME) NE ? THEN DO:
      MESSAGE "Dataset cannot be named as keyword " + KEYWORD(ihDs:NAME) VIEW-AS ALERT-BOX.
      RETURN.
    END.  
    
    DEF BUFFER bttTables FOR ttTables.
        
    hdsSchema:EMPTY-DATASET ().
    
    hdsResult = ihDs.
    cSchemaName = hdsResult:NAME.
    iGlobId = 0.
    
    DO ix = 1 TO hdsResult:NUM-BUFFERS:
      CREATE ttTables.
      ASSIGN hB = hdsResult:GET-BUFFER-HANDLE(ix)
             ttTables.TableName = hB:NAME
             ttTables.Seq = ix
             ttTables.hBuffer = hB
             ttTables.bIncluded = YES
             ttTables.JsonTableName = IF hB:SERIALIZE-NAME NE "" THEN 
                                        hB:SERIALIZE-NAME 
                                      ELSE hB:NAME
             .
      DO iy = 1 TO hB:NUM-FIELDS:
        hF = hB:BUFFER-FIELD (iy). 
        CREATE ttFields.
        ASSIGN ttFields.FieldName     = hF:NAME
               ttFields.DataType      = hF:DATA-TYPE
               ttFields.Seq           = iy
               ttFields.TableName     = hB:NAME
               ttFields.JsonTableName = ttTables.JsonTableName
               ttFields.JsonFieldName = hF:SERIALIZE-NAME
               ttFields.hField        = hF
               ttFields.TableSeq      = ix
               .
      END.       
    END.          
    DO ix = 1 TO hdsResult:NUM-RELATIONS:
      hR = hdsResult:GET-RELATION (ix).
      FIND FIRST ttTables 
           WHERE ttTables.TableName = hR:CHILD-BUFFER:NAME.
      ASSIGN ttTables.ParentTableName     = hR:PARENT-BUFFER:NAME
             ttTables.ParentJsonTableName = IF hR:PARENT-BUFFER:SERIALIZE-NAME NE "" THEN
                                              hR:PARENT-BUFFER:SERIALIZE-NAME
                                            ELSE
                                              hR:PARENT-BUFFER:NAME  
             ttTables.Level               = addRelationLevel(ttTables.TableName)
             .      
      FIND FIRST bttTables
           WHERE bttTables.TableName = hR:PARENT-BUFFER:NAME
           NO-ERROR.
      IF AVAIL bttTables THEN
        ttTables.ParentSeq = bttTables.Seq.            
    END.
    FOR EACH ttTables
       ,EACH ttFields
             WHERE ttFields.TableName = ttTables.TableName:
      ttFields.Level = ttTables.Level + 1.
    END.           
      
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PRIVATE INTEGER addRelationLevel(INPUT icTableName AS CHAR):
    DEF BUFFER ttTables FOR ttTables. 
    
    DEF VAR iLevel AS INT NO-UNDO.
    
    FIND FIRST ttTables WHERE ttTables.TableName = icTableName
         NO-ERROR.
    IF ttTables.ParentTableName NE "" THEN
      iLevel = iLevel + 1 + addRelationLevel(ttTables.ParentTableName).     
    RETURN iLevel.
  END METHOD.  

  METHOD PUBLIC LOGICAL LoadSchema(INPUT ilcSchema AS LONGCHAR):
    
    statusMessage = "".
    SESSION:NUMERIC-FORMAT = "American".
    IF cSchemaName = "" THEN
      cSchemaName = "ttJsonHeader".
    
/*    FOR EACH ttTables:                                                    */
/*      IF VALID-HANDLE(ttTables.hTable) THEN DELETE OBJECT ttTables.hTable.*/
/*    END.                                                                  */
    IF ilcSchema NE "" AND ilcSchema NE ? THEN DO:
      hdsSchema:EMPTY-DATASET ().
      hdsSchema:READ-JSON("longchar",ilcSchema,"empty").
    END.
      
    IF VALID-HANDLE(hDsResult) THEN DELETE OBJECT hdsResult.
    
    CREATE DATASET hDsResult.
    
    FOR EACH ttTables BY ttTables.Seq:
      CREATE TEMP-TABLE ttTables.hTable.
      FOR EACH ttFields
          WHERE ttFields.TableName = ttTables.TableName
             BY ttFields.Seq
          :
        ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,IF ttFields.DataType = "" THEN "CHARACTER" ELSE ttFields.DataType,0,ttFields.FormatString) no-error.
        IF ERROR-STATUS:ERROR THEN 
          MESSAGE "Error adding field " ttFields.FieldName SKIP 
                  ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX.
      END.      
      ttTables.hTable:ADD-NEW-INDEX("idxRowIdent",YES,YES).
      ttTables.hTable:ADD-INDEX-FIELD("idxRowIdent","JBoxRowIdent").
      ttTables.hTable:ADD-NEW-INDEX("idxParentRowIdent").
      ttTables.hTable:ADD-INDEX-FIELD("idxParentRowIdent","JBoxParentRowIdent").
      
      FOR EACH ttFields
          WHERE ttFields.TableName = ttTables.TableName
          :
        ttTables.hTable:ADD-NEW-FIELD (ttFields.FieldName,ttFields.DataType,0,ttFields.FormatString).
      END.
    END.

    prepareSchema(cSchemaName).
    

    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).
    END CATCH.

    FINALLY:
      SESSION:NUMERIC-FORMAT = cOrgNumFormat.
      RETURN statusMessage = "".
    END.
  END METHOD.

  METHOD PUBLIC LOGICAL prepareSchema (INPUT icSchemaName AS CHAR):
    DEF VAR iErrCnt   AS INT NO-UNDO.
    DEF VAR hFld      AS HANDLE NO-UNDO.
    DEF VAR hRelation AS HANDLE NO-UNDO.
    
    DEF BUFFER bttTables FOR ttTables.
    
    FOR EACH ttTables:
      FOR EACH bttTables 
          WHERE bttTables.ParentJsonTableName = ttTables.JsonTableName
            AND bttTables.Level = ttTables.Level + 1
            AND bttTables.ParentSeq = ttTables.Seq
          :
        bttTables.ParentTableName = ttTables.TableName.
      END.
    END.  
    FOR EACH ttFields,
        FIRST ttTables 
              WHERE ttTables.JsonTableName = ttFields.JsonTableName
                AND ttTables.ParentJsonTableName = ttFields.ParentJsonTableName
                AND ttTables.Level = ttFields.Level - 1
                AND ttTables.Seq = ttFields.TableSeq
        :
      ttFields.TableName = ttTables.TableName.
    END.

    FOR EACH ttTables:
      ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
      IF ERROR-STATUS:NUM-MESSAGES > 0 AND logFile NE "" THEN
        LOG-MANAGER:WRITE-MESSAGE ("Warning - failed to prepare (but may be able to correct name): " + ttTables.TableName + " " + ERROR-STATUS:GET-MESSAGE(1) + ". For error 329 add name to reservedNames property").
                 
      IF ERROR-STATUS:NUM-MESSAGES > 0 AND (ERROR-STATUS:GET-NUMBER(1) = 329 OR ERROR-STATUS:GET-NUMBER(1) = 274) THEN DO:
        ASSIGN ttTables.orgTableName = ttTables.TableName
               ttTables.TableName = ttTables.TableName + "_"
               ttTables.TableName = REPLACE(ttTables.TableName,"/","_sl_")
               ttTables.TableName = REPLACE(ttTables.TableName,CHR(123),"_clb_")
               ttTables.TableName = REPLACE(ttTables.TableName,CHR(125),"_crb_")
               .
        FOR EACH bttTables WHERE bttTables.ParentTableName = ttTables.orgTableName:
          bttTables.ParentTableName = ttTables.TableName.
        END.
        FOR EACH ttFields WHERE ttFields.TableName = ttTables.orgTableName:
          ttFields.TableName = ttTables.TableName.
          ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,ttFields.DataType).
        END.
        ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES = 0 THEN DO:
        END.
        ELSE IF ERROR-STATUS:GET-NUMBER(1) = 9033 THEN DO:
          ttTables.hTable:ADD-NEW-FIELD("JBoxRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-FIELD("JBoxParentRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-INDEX("idxRowIdent",YES,YES).
          ttTables.hTable:ADD-INDEX-FIELD("idxRowIdent","JBoxRowIdent").
          ttTables.hTable:ADD-NEW-INDEX("idxParentRowIdent").
          ttTables.hTable:ADD-INDEX-FIELD("idxParentRowIdent","JBoxParentRowIdent").
          ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
          IF ERROR-STATUS:NUM-MESSAGES > 1 THEN
            DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
              MESSAGE "Could not prepare table " ttTables.TableName " (after name modification and adding dummy fields) " SKIP
                      ERROR-STATUS:GET-MESSAGE(iErrCnt)
                      VIEW-AS ALERT-BOX ERROR.       
            END.
        END.    
        ELSE DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
          MESSAGE "Could not prepare table " ttTables.TableName " (after name modification) " SKIP
                  ERROR-STATUS:GET-MESSAGE(iErrCnt)
                  VIEW-AS ALERT-BOX ERROR.
        END.          
      END.
      ELSE IF ERROR-STATUS:NUM-MESSAGES > 0 AND ERROR-STATUS:GET-NUMBER(1) = 1700 THEN DO:
        ASSIGN ttTables.orgTableName = ttTables.TableName
               ttTables.TableName = SUBSTR(ttTables.TableName,1,32).
        FOR EACH bttTables WHERE bttTables.ParentTableName = ttTables.orgTableName:
          bttTables.ParentTableName = ttTables.TableName.
        END.
        FOR EACH ttFields WHERE ttFields.TableName = ttTables.orgTableName:
          ttFields.TableName = ttTables.TableName.
          ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,ttFields.DataType).
        END.
        ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES = 0 THEN DO:
        END.
        ELSE IF ERROR-STATUS:GET-NUMBER(1) = 9033 THEN DO:
          ttTables.hTable:ADD-NEW-FIELD("JBoxRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-FIELD("JBoxParentRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-INDEX("idxRowIdent",YES,YES).
          ttTables.hTable:ADD-INDEX-FIELD("idxRowIdent","JBoxRowIdent").
          ttTables.hTable:ADD-NEW-INDEX("idxParentRowIdent").
          ttTables.hTable:ADD-INDEX-FIELD("idxParentRowIdent","JBoxParentRowIdent").
          ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
          IF ERROR-STATUS:NUM-MESSAGES > 1 THEN
            DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
              MESSAGE "Could not prepare table " ttTables.TableName " (after name modification and adding dummy fields) " SKIP
                      ERROR-STATUS:GET-MESSAGE(iErrCnt)
                      VIEW-AS ALERT-BOX ERROR.       
            END.
        END.    
        ELSE DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
          MESSAGE "Could not prepare table " ttTables.TableName " (after name modification) " SKIP
                  ERROR-STATUS:GET-MESSAGE(iErrCnt)
                  VIEW-AS ALERT-BOX ERROR.
        END.          
      END.
      ELSE IF ERROR-STATUS:NUM-MESSAGES = 0 THEN
        ttTables.orgTableName = ttTables.TableName.
      ELSE DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
        MESSAGE "Could not prepare table " ttTables.TableName  SKIP
                ERROR-STATUS:GET-MESSAGE(iErrCnt)
                VIEW-AS ALERT-BOX ERROR.
      END.          
         
      ttTables.hBuffer = ttTables.hTable:DEFAULT-BUFFER-HANDLE.
      
      ttTables.hBuffer:BUFFER-FIELD ("JBoxRowIdent"):SERIALIZE-HIDDEN = rowidentsHidden.
      ttTables.hBuffer:BUFFER-FIELD ("JBoxParentRowIdent"):SERIALIZE-HIDDEN = rowidentsHidden.
      
      hdsResult:ADD-BUFFER(ttTables.hBuffer).
      FIND FIRST bttTables 
           WHERE bttTables.TableName = ttTables.ParentTableName
             AND bttTables.Level = ttTables.Level - 1
           NO-ERROR.
      IF AVAIL bttTables THEN DO: 
        hRelation = hdsResult:ADD-RELATION(bttTables.hBuffer,ttTables.hBuffer,"JBoxRowIdent,JBoxParentRowIdent").
        hRelation:NAME = ttTables.TableName.
      END.
            
      FOR EACH ttFields 
          WHERE ttFields.TableName = ttTables.TableName
          :
        hFld = ttTables.hBuffer:BUFFER-FIELD(ttFields.FieldName) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN
          ASSIGN ttFields.hField  = hFld
                 .
        ELSE 
          MESSAGE "Invalid field name " ttFields.FieldName " for table " ttTables.TableName SKIP
                  ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX ERROR.
      END.
    END.
        
  END METHOD. 



  METHOD PUBLIC VOID manuallyCopyDS(INPUT ipdshTarget AS handle):
    def var iSource as int no-undo.
    def var iTarget as int no-undo.
    def var hTarget as handle no-undo.
    def var bhSource as handle extent no-undo.
    def var bhTarget as handle no-undo.

    extent(bhSource) = hdsResult:NUM-BUFFERS.
    ipdshTarget:EMPTY-DATASET ().
    do iSource = 1 to extent(bhSource):
      bhSource[iSource] = hdsResult:get-buffer-handle(iSource).
      do iTarget = 1 to ipdshTarget:num-buffers:
        bhTarget = ipdshTarget:get-buffer-handle(iTarget).  
        if ipdshTarget:get-buffer-handle(iTarget):name = bhSource[iSource]:name then do:
          bhTarget:table-handle:copy-temp-table(bhSource[iSource]:table-handle,false,false,true).
        end.
      end.     
    end.
  END METHOD. 

  METHOD PROTECTED VOID readJsonData (ioJsonObject          AS JsonObject
                                     ,icParentJsonTableName AS CHAR
                                     ,iiLevel               AS INT
                                     ,iiParentId            AS INT
                                     ,ihBuffer              AS HANDLE
                                     ,iiParentTableSeq      AS INT):

    DEF VAR myArray         AS CHAR          EXTENT NO-UNDO.
    DEF VAR ix              AS INT           NO-UNDO.
    DEF VAR iy              AS INT           NO-UNDO.
    DEF VAR lcText          AS LONGCHAR      NO-UNDO.  
    DEF VAR oJsonObject     AS JsonObject    NO-UNDO. 
    DEF VAR oJsonArray      AS JsonArray     NO-UNDO.
    DEF VAR cJsonFldOrTable AS CHAR          NO-UNDO.
    DEF VAR iErr            AS INT           NO-UNDO.
    DEF VAR lcText2         AS LONGCHAR      NO-UNDO.    
    DEF VAR hFldLength      AS HANDLE        NO-UNDO.
    DEF VAR cUseAsObjName   AS CHAR          NO-UNDO.
    DEF VAR iUseAsParent    AS INT           NO-UNDO.
    DEF VAR cType           AS CHAR          NO-UNDO.
    

    DEF BUFFER ttTables FOR TEMP-TABLE ttTables.    
    DEF BUFFER ttFields FOR TEMP-TABLE ttFields.    
    
    hFldLength = BUFFER ttFields:BUFFER-FIELD("Length").
    
    FIX-CODEPAGE(lcText)  = "UTF-8".
    FIX-CODEPAGE(lcText2) = "UTF-8".
           
    myArray = ioJsonObject:GetNames().
        
    DO ix = 1 TO EXTENT(myArray):
      lcText  = ioJsonObject:getJsonText(myArray[ix]).
            
      cJsonFldOrTable = myArray[ix].
                  
      IF ioJsonObject:GetType(cJsonFldOrTable) = Progress.Json.ObjectModel.JsonDataType:NULL THEN 
        NEXT.
      ELSE IF ioJsonObject:GetType(cJsonFldOrTable) = Progress.Json.ObjectModel.JsonDataType:ARRAY THEN DO:
        oJsonArray = CAST(oParser:Parse(lcText), JsonArray) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN 
          statusMessage = "Invalid cast to array " + cJsonFldOrTable + " " + STRING(lcText) + " " + ERROR-STATUS:GET-MESSAGE(1).
      
        ELSE IF oJsonArray:LENGTH > 0 THEN DO:
          FIND FIRST ttRenameArray WHERE ttRenameArray.FromName = cJsonFldOrTable NO-ERROR.
          IF AVAIL ttRenameArray THEN cJsonFldOrTable = ttRenameArray.ToName.
            
          FIND FIRST ttTables 
               WHERE ttTables.JsonTableName = cJsonFldOrTable
                 AND ttTables.ParentSeq = iiParentTableSeq
                 AND ttTables.Level = iiLevel
               NO-ERROR.

          IF AVAIL ttTables THEN DO:
            FIND FIRST ttFields 
                 WHERE ttFields.TableName = ttTables.TableName
                 NO-ERROR.
            IF AVAIL ttFields THEN     
              DO iy = 1 TO oJsonArray:LENGTH:
                IF oJsonArray:GetType(iy) = Progress.Json.ObjectModel.JsonDataType:NULL THEN 
                  NEXT.
                lcText2  = oJsonArray:getJsonText(iy).
                ttTables.hBuffer:BUFFER-CREATE ().
                ASSIGN iGlobId = iGlobId + 1
                       ttTables.hBuffer::JBoxRowIdent = iGlobId
                       ttTables.hBuffer::JBoxParentRowIdent = iiParentId
                       . 
                CASE oJsonArray:GetType(iy):
                  WHEN Progress.Json.ObjectModel.JsonDataType:STRING THEN 
                    AssignValue(ttFields.TableName,"STRING",ttTables.hBuffer:BUFFER-FIELD(ttFields.FieldName),STRING(lcText2),hFldLength).
                  WHEN Progress.Json.ObjectModel.JsonDataType:BOOLEAN THEN 
                    AssignValue(ttFields.TableName,"BOOLEAN",ttTables.hBuffer:BUFFER-FIELD(ttFields.FieldName),STRING(lcText2),hFldLength).
                  WHEN Progress.Json.ObjectModel.JsonDataType:NUMBER THEN  
                    AssignValue(ttFields.TableName,"NUMBER",ttTables.hBuffer:BUFFER-FIELD(ttFields.FieldName),STRING(lcText2),hFldLength).
                  WHEN Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
                    lcText = oJsonArray:getJsonText(iy).
                    oJsonObject = CAST(oParser:Parse(lcText), JsonObject) NO-ERROR.
                    IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
                      statusMessage = "Invalid cast to object in array " + cJsonFldOrTable + " " + STRING(lcText) + " " + ERROR-STATUS:GET-MESSAGE(1).
                    ELSE THIS-OBJECT:readJsonData(oJsonObject,ttTables.JsonTableName,iiLevel + 1,iGlobId,ttTables.hBuffer,ttTables.Seq).
                  END.
                  OTHERWISE 
                    statusMessage = "Invalid object type in array (array in array not supported) " + STRING(lcText).
                END CASE.
              END.
            ELSE schemaWarning = "Error for ARRAY: Couldn't find field definition for tablename " + cJsonFldOrTable + " Level: " + STRING(iiLevel) + " Parent table: " + icParentJsonTableName.  
          END.
          ELSE schemaWarning = "Error for ARRAY: Couldn't find ttTables for json tablename " + cJsonFldOrTable + " Level: " + STRING(iiLevel) + " Parent table: " + icParentJsonTableName.
        END.  
      END.  
      ELSE IF ioJsonObject:GetType(cJsonFldOrTable) = Progress.Json.ObjectModel.JsonDataType:OBJECT THEN DO:
        oJsonObject = CAST(oParser:Parse(lcText), JsonObject) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
          statusMessage = "Invalid cast to object in object " + cJsonFldOrTable + " " + STRING(lcText) + " " + ERROR-STATUS:GET-MESSAGE(1).
        ELSE DO:  
          IF cUseAsObjName = "" THEN cUseAsObjName = cJsonFldOrTable.
          
          FIND FIRST ttTables 
               WHERE ttTables.JsonTableName = cJsonFldOrTable
                 AND ttTables.ParentSeq = iiParentTableSeq
                 AND ttTables.Level = iiLevel
               NO-ERROR.
          IF AVAIL ttTables THEN DO: 
            ttTables.hBuffer:BUFFER-CREATE ().
            ASSIGN iGlobId = iGlobId + 1
                   ttTables.hBuffer::JBoxRowIdent = iGlobId
                   ttTables.hBuffer::JBoxParentRowIdent = iiParentId
                   . 
            THIS-OBJECT:readJsonData(oJsonObject,ttTables.JsonTableName,iiLevel + 1,iGlobId,ttTables.hBuffer,ttTables.Seq).
          END.  
          ELSE schemaWarning = "Error for OBJECT: Couldn't find ttTables for tablename " + cJsonFldOrTable + " Level: " + STRING(iiLevel) + " Parent table: " + icParentJsonTableName.
          cUseAsObjName = "".
        END.  
      END.
      ELSE IF lcText NE ? AND SUBSTR(lcText,1,2) = CHR(123) + CHR(92) THEN DO:
        DO ON ERROR UNDO, THROW:
          lcText2 = ioJsonObject:GetCharacter(cJsonFldOrTable).
          CATCH eText AS Progress.Lang.Error :
            lcText2 = REPLACE(ioJsonObject:GetJsonText(cJsonFldOrTable),'\"','"').   
          END CATCH.
        END.
        lcText = lcText2.
        
        lcText = trim(lcText,'"').
        oJsonObject = CAST(oParser:Parse(lcText), JsonObject).
        oJsonObject = CAST(oParser:Parse(lcText), JsonObject) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
          statusMessage = "Invalid cast to object in object " + cJsonFldOrTable + " " + STRING(lcText) + " " + ERROR-STATUS:GET-MESSAGE(1).
        ELSE DO:  
          
          IF cUseAsObjName = "" THEN cUseAsObjName = cJsonFldOrTable.

          FIND FIRST ttTables 
               WHERE ttTables.JsonTableName = cUseAsObjName
                 AND ttTables.ParentSeq = iiParentTableSeq
                 AND ttTables.Level = iiLevel
               NO-ERROR.
          IF NOT AVAIL ttTables THEN          
            FIND FIRST ttTables
                 WHERE ttTables.JsonTableName       = cUseAsObjName
                   AND ttTables.ParentJsonTableName = icParentJsonTableName
                   AND ttTables.Level = iiLevel
                   AND ttTables.cType = cType
                 NO-ERROR.
               
          IF AVAIL ttTables THEN DO: 
            ttTables.hBuffer:BUFFER-CREATE ().
            ASSIGN iGlobId = iGlobId + 1
                   ttTables.hBuffer::JBoxRowIdent = iGlobId
                   ttTables.hBuffer::JBoxParentRowIdent = iiParentId
                   . 
            THIS-OBJECT:readJsonData(oJsonObject,ttTables.JsonTableName,iiLevel + 1,iGlobId,ttTables.hBuffer,ttTables.Seq).
          END.  
          ELSE schemaWarning = "Error for OBJECT: Couldn't find ttTables for tablename " + cJsonFldOrTable + " Level: " + STRING(iiLevel) + " Parent table: " + icParentJsonTableName.
          cUseAsObjName = "".
        END.  
      END.  
      ELSE DO:            

        FIND FIRST ttFields 
             WHERE ttFields.JsonTableName = icParentJsonTableName
               AND ttFields.JsonFieldName = cJsonFldOrTable
               AND ttFields.Level         = iiLevel 
               AND ttFields.TableSeq      = iiParentTableSeq
             NO-ERROR.

        IF AVAIL ttFields THEN DO:      
          IF CAN-DO(fieldsUsedAsTableName,cJsonFldOrTable) THEN cUseAsObjName = STRING(lcText).   
          CASE ioJsonObject:GetType(cJsonFldOrTable): 
             WHEN Progress.Json.ObjectModel.JsonDataType:STRING THEN DO:
               lcText = ioJsonObject:getCharacter(myArray[ix]).
               AssignValue(ttFields.TableName,"STRING",ihBuffer:BUFFER-FIELD(ttFields.FieldName),STRING(lcText),hFldLength).
             END.
             WHEN Progress.Json.ObjectModel.JsonDataType:BOOLEAN THEN 
               AssignValue(ttFields.TableName,"BOOLEAN",ihBuffer:BUFFER-FIELD(ttFields.FieldName),STRING(lcText),hFldLength).
             WHEN Progress.Json.ObjectModel.JsonDataType:NUMBER  THEN 
               AssignValue(ttFields.TableName,"NUMBER",ihBuffer:BUFFER-FIELD(ttFields.FieldName),STRING(lcText),hFldLength).
          END CASE.
        END.        
        ELSE schemaWarning = "Error for field: Couldn't find field for update " + cJsonFldOrTable + " Level: " + STRING(iiLevel) + " Table: " + icParentJsonTableName.
      END.  
    END.  

    CATCH eAny AS Progress.Lang.Error :
      StatusMessage = eAny:GetMessage(1).
      UNDO, THROW eAny.
    END CATCH.
    
  END METHOD.                                        

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID reBuildSchemaTables(  ):

    DEF VAR httTable AS HANDLE NO-UNDO.
    
    iGlobTableSeq = 0.
    
    FOR EACH ttTables:
      DELETE OBJECT ttTables.hTable NO-ERROR.
      CREATE TEMP-TABLE httTable.
      httTable:ADD-NEW-FIELD("JBoxRowIdent","INTEGER").
      httTable:ADD-NEW-FIELD("JBoxParentRowIdent","INTEGER").
      httTable:ADD-NEW-INDEX("idxRowIdent",YES,YES).
      httTable:ADD-INDEX-FIELD("idxRowIdent","JBoxRowIdent").
      httTable:ADD-NEW-INDEX("idxParentRowIdent").
      httTable:ADD-INDEX-FIELD("idxParentRowIdent","JBoxParentRowIdent").
    
      ttTables.hTable = httTable.
      
      iGlobTableSeq = IF ttTables.Seq > iGlobTableSeq THEN ttTables.Seq ELSE iGlobTableSeq.
      
      FOR EACH ttFields
          WHERE ttFields.TableName = ttTables.TableName
          :
        CASE ttFields.DataType:
          WHEN "CHARACTER" THEN 
            ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,"CHARACTER",0,IF ttFields.FormatString NE "" THEN ttFields.FormatString ELSE "x(30)").
          WHEN "LOGICAL" THEN
            ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,"LOGICAL"). 
          WHEN "DECIMAL" THEN 
            ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,"DECIMAL",0,"->>,>>>,>>>,>>9.99").
        END CASE.
      END.
    END. 
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Use for weird cases like this where the value of "evidenceValueName" is mapped to a table name and "tilsynsrapporer" becomes therefore becomes ambiguous 
     
            "evidenceValueName": "tilsynsrapporter",
            "source": "874761192",
            "timestamp": "2022-10-26T10:30:32.1956728Z",
            "value": "{\"status\":\"ok\",\"statustekst\":\"OK. ElapsedMs: 456\",\"tilsynsmyndighet\":\"874761192\",\"tilsynsrapporter\":[{\"tildaenhet\":\"910441124\",\"tilsynutfoertav\":\"874761192\",\"ansvarligTilsynsmyndighet\":\"874761192\"}]}",
            "valueType": "jsonSchema"
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID RenameArray(INPUT icFromArrayName AS CHAR,INPUT icToArrayName AS CHAR  ):
   
    FIND FIRST ttRenameArray WHERE ttRenameArray.FromName = icFromArrayName NO-ERROR.
    IF NOT AVAIL ttRenameArray THEN DO:
      CREATE ttRenameArray.
      ASSIGN ttRenameArray.FromName = icFromArrayName
             ttRenameArray.ToName   = icToArrayName.
    END.
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID renewResultDS(  ):
    DEF BUFFER bttTables FOR ttTables.
        
    IF VALID-HANDLE(hdsResult) THEN    
      DELETE OBJECT hdsResult.
    
    CREATE DATASET hdsResult.
    
    FOR EACH ttTables:
      hdsResult:ADD-BUFFER(ttTables.hBuffer).
      FIND FIRST bttTables 
           WHERE bttTables.TableName = ttTables.ParentTableName
/*             AND bttTables.Level = ttTables.Level - 1 */
           NO-ERROR.
      IF AVAIL bttTables THEN 
        hdsResult:ADD-RELATION(bttTables.hBuffer,ttTables.hBuffer,"JBoxRowIdent,JBoxParentRowIdent").
    END.  
    
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER UrlEncode( INPUT icUrl AS CHAR ):
    
  /**************************************************************************** 
  Description: Encodes unsafe characters in a URL as per RFC 1738 section 2.2. 
  <URL:http://ds.internic.net/rfc/rfc1738.txt>;, 2.2 
  
  Input Parameters: Character string to encode, Encoding option where "query", 
  "cookie", "default" or any specified string of characters are valid. 
  
  In addition, all characters specified in the variable cUnsafe plus ASCII values 0 <= x <= 31 and 127 <= x <= 255 are considered unsafe. 
  
  Returns: Encoded string (unkown value is returned as blank) 
  Variables: cUnsafe, cReserved 
  ****************************************************************************/ 
  DEFINE VAR cValue AS CHARACTER NO-UNDO.
  
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
  
  cValue = icUrl.
  
  /* Don't bother with blank or unknown */ 
  IF LENGTH(cValue) EQ 0 OR 
     cValue         EQ ? THEN 
    RETURN "". 
  
  /* What kind of encoding should be used? */ 
  CASE cEnctype: 
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
           cChar = ASC(SUBSTRING(cValue, iCounter, 1, "RAW":U), 
                       "1252":U, 
                       "1252":U).
    IF (cChar LE 31  OR 
        cChar GE 127 OR 
        INDEX(cEncodeList, CHR(cChar)) GT 0)
        AND (IF specialUrlCharSourceList NE "" THEN NOT CAN-DO(specialUrlCharSourceList,CHR(cChar)) ELSE TRUE)
        THEN DO: 
      /* Replace character with %hh hexidecimal triplet */ 
      SUBSTRING(cValue, iCounter, 1, "RAW":U) = "%":U + 
        SUBSTRING(cHex, INTEGER(TRUNCATE(cChar / 16, 0)) + 1, 1, "RAW":U) + /* high */ 
        SUBSTRING(cHex, cChar MODULO 16 + 1, 1, "RAW":U). /* low digit */ 
  
      iCounter = iCounter + 2. /* skip over hex triplet just inserted */ 
    END. 
    IF iCounter EQ LENGTH(cValue,"RAW":U) THEN LEAVE. 
  END. 
  
  DO iCounter = 1 TO NUM-ENTRIES(specialUrlCharSourceList):
    cValue = REPLACE(cValue,
                     ENTRY(iCounter,specialUrlCharSourceList),
                     ENTRY(iCounter,specialUrlCharTargetList)).
  END.  
  RETURN cValue.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

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
    cValidName = REPLACE(cValidName,":","_c_").
    cValidName = REPLACE(cValidName,"/","_sl_").
    cValidName = REPLACE(cValidName,"\/","_sl_").
    cValidName = REPLACE(cValidName,CHR(123),"_clb_").    
    cValidName = REPLACE(cValidName,CHR(125),"_crb_").    
    cValidName = REPLACE(cValidName,".","").    
    cValidName = REPLACE(cValidName,"+","").    
    cValidName = REPLACE(cValidName,"@","").    
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

  METHOD PUBLIC VOID viewSchemaDS().
    DEF VAR cFileName AS CHAR NO-UNDO.
    
    cFileName = SESSION:TEMP-DIR + cSchemaName + "_schema_" + REPLACE(STRING(NOW,"99.99.9999 hh:mm:ss"),":",".") + ".json".
    
    DATASET dsSchema:WRITE-JSON ("file",cFileName,yes).
    OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
  END METHOD.

  METHOD PUBLIC VOID viewViewDS().
    DEF VAR cFileName AS CHAR NO-UNDO.
    
    cFileName = SESSION:TEMP-DIR + cSchemaName + "_view_" + REPLACE(STRING(NOW,"99.99.9999 hh:mm:ss"),":",".") + ".json".
    
    DATASET dsView:WRITE-JSON ("file",cFileName,yes).
    OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
  END METHOD.

  METHOD PUBLIC VOID saveSchemaToFile(INPUT icFileName AS CHAR).
    DATASET dsSchema:WRITE-JSON ("file",icFileName,yes).
  END METHOD.

  METHOD PUBLIC CHARACTER get4GLschema():
    DEF VAR lcFile AS LONGCHAR NO-UNDO.
    c4GLschemaFile = "fill".
    saveSchemaAs4GL("").
    COPY-LOB FROM file c4GLschemaFile TO object lcFile.
    c4GLschemaFile = "".
    OS-DELETE VALUE(c4GLschemaFile) NO-ERROR.
    RETURN STRING(lcFile).
  END METHOD.  

  METHOD PUBLIC VOID saveSchemaAs4GL(INPUT icFileName AS CHAR).
    DEF VAR cTableList    AS CHAR NO-UNDO.
    DEF VAR ix            AS INT  NO-UNDO.
    DEF VAR iy            AS INT  NO-UNDO.
    DEF VAR cDsName       AS CHAR NO-UNDO.
    DEF VAR bRowIdentFld  AS LOG  NO-UNDO.

    cDsName = (IF cSchemaName NE "" THEN cSchemaName
               ELSE IF VALID-HANDLE(hdsResult) AND hdsResult:NAME NE "" THEN hdsResult:NAME 
               ELSE IF hdsSchema:NAME NE "" THEN hdsSchema:NAME
               ELSE "dsResult").
               
    IF icFileName = "" THEN
      icFileName = SESSION:TEMP-DIR + cSchemaName + "_4GL_" + REPLACE(STRING(NOW,"99.99.9999 hh:mm:ss"),":",".") + ".p".
            
    OUTPUT TO VALUE(icFileName).
    
    FOR EACH ttTables BY ttTables.Seq:
      ix = ix + 1.
      cTableList = cTableList + (IF cTableList NE "" THEN ", " ELSE "") + cTablePrefix + ttTables.TableName.
      PUT UNFORMATTED "DEFINE TEMP-TABLE " + cTablePrefix 
                      ttTables.TableName " NO-UNDO"
                                           + (IF ttTables.JsonTableName NE "" AND ttTables.TableName NE ttTables.JsonTableName THEN " SERIALIZE-NAME '" + ttTables.JsonTableName + "'"
                                              ELSE IF cTablePrefix NE "" THEN " SERIALIZE-NAME '" + ttTables.TableName + "'" 
                                              ELSE "") CHR(13).
      bRowIdentFld = NO.                                        
      FOR EACH ttFields WHERE ttFields.TableSeq = ttTables.Seq:
        IF ABLfieldList NE "" AND NOT CAN-DO(ABLfieldList,ttFields.FieldName) THEN NEXT.
        PUT UNFORMATTED "    FIELD " ttFields.FieldName " AS " ttFields.DataType
                      + (IF ttFields.DataType = "CHARACTER" THEN ' FORMAT "' + ttFields.FormatString + '"' ELSE "")
                      + (IF ttFields.JsonFieldName NE "" AND ttFields.FieldName NE ttFields.JsonFieldName THEN " SERIALIZE-NAME '" + ttFields.JsonFieldName + "'"
                         ELSE IF ttFields.FieldName MATCHES "JBox*RowIdent" AND bHideJboxRowIdent THEN " SERIALIZE-HIDDEN" 
                         ELSE "") CHR(13).
        bRowIdentFld = NOT bRowIdentFld AND ttFields.FieldName MATCHES "JBox*RowIdent".                  
      END.
      IF bRowIdentFld THEN DO:
        PUT UNFORMATTED "INDEX idxJBoxRowIdent JBoxRowIdent" CHR(13).
        PUT UNFORMATTED "INDEX idxJBoxParentRowIdent JBoxParentRowIdent" CHR(13).
      END.  
      DO iy = 1 TO NUM-ENTRIES(cPrimaryIdxFields):
        IF ENTRY(1,ENTRY(iy,cPrimaryIdxFields),";") = ttTables.TableName THEN
          PUT UNFORMATTED "INDEX idx" ENTRY(2,ENTRY(iy,cPrimaryIdxFields),";") " IS PRIMARY " ENTRY(2,ENTRY(iy,cPrimaryIdxFields),";") CHR(13).
      END.  
      DO iy = 1 TO NUM-ENTRIES(ABLidxFields):
        PUT UNFORMATTED "INDEX idx" ENTRY(iy,ABLidxFields) " " ENTRY(iy,ABLidxFields) CHR(13).
      END.  
      PUT "." SKIP.
    END.  
    
    IF CAN-FIND(FIRST ttTables WHERE ttTables.ParentTableName NE "") THEN DO:
      PUT UNFORMATTED "DEFINE DATASET " cTablePrefix + cDsName " FOR " cTableList CHR(13).
      FOR EACH ttTables
          WHERE ttTables.ParentTableName NE ""
          BY ttTables.Seq:
        PUT UNFORMATTED "    DATA-RELATION " cTablePrefix + ttTables.TableName " FOR " cTablePrefix + ttTables.ParentTableName ", " cTablePrefix + ttTables.TableName " RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED" CHR(13).
      END.
      PUT "." SKIP(1).
    END.  
    
    OUTPUT CLOSE.
    IF c4GLschemaFile = "fill" THEN c4GLschemaFile = icFileName.
    ELSE
      OS-COMMAND NO-WAIT VALUE("notepad " + icFileName).
      
    FINALLY:
      ASSIGN ABLfieldList = ""
             ABLidxFields = ""
             .
    END.  
  END METHOD.

  METHOD PUBLIC VOID saveSchemaAs4GL(INPUT icFileName         AS CHAR
                                    ,INPUT ibHideJboxRowIdent AS LOG
                                    ,INPUT icTablePrefix      AS CHAR)
                                    .
    ASSIGN bHideJboxRowIdent = ibHideJboxRowIdent
           cTablePrefix      = icTablePrefix
           .
    THIS-OBJECT:saveSchemaAs4GL(icFileName).       
  END METHOD.

  METHOD PUBLIC VOID saveSchemaAs4GL(INPUT icFileName         AS CHAR
                                    ,INPUT ibHideJboxRowIdent AS LOG
                                    ,INPUT icTablePrefix      AS CHAR
                                    ,INPUT icPrimaryIdxFields AS CHAR)
                                    .
    ASSIGN bHideJboxRowIdent = ibHideJboxRowIdent
           cTablePrefix      = icTablePrefix
           cPrimaryIdxFields = icPrimaryIdxFields
           .
    THIS-OBJECT:saveSchemaAs4GL(icFileName).       
  END METHOD.
  
  METHOD PUBLIC CHARACTER getForEach().
    DEF VAR cForEach AS CHAR NO-UNDO.
    
    FOR EACH ttTables
        WHERE ttTables.ParentTableName = ""
        BY ttTables.Seq:
      cForEach = "FOR EACH " + cTablePrefix + ttTables.TableName + getForEachElement(ttTables.TableName).
      LEAVE.
    END.         
    cForEach = cForEach + CHR(10) + "    :" + CHR(10) + "END." + CHR(10).
    RETURN cForEach.
    
  END METHOD.

  METHOD PUBLIC CHARACTER getForEach(INPUT icTablePrefix      AS CHAR).
    cTablePrefix = icTablePrefix.
    RETURN THIS-OBJECT:getForEach().       
  END METHOD.

  METHOD PRIVATE CHARACTER getForEachElement(INPUT icParentTable AS CHAR).
    DEF VAR cForEach AS CHAR NO-UNDO.
    DEF BUFFER ttTables FOR TEMP-TABLE ttTables.
    
    FOR EACH ttTables 
        WHERE ttTables.ParentTableName = icParentTable
           BY ttTables.Seq:
      cForEach = cForEach 
               + CHR(10) + "   ,EACH " + cTablePrefix + ttTables.TableName
               + " WHERE " + cTablePrefix + ttTables.TableName + ".JBoxParentRowIdent = " + cTablePrefix + icParentTable + ".JBoxRowIdent"
               + getForEachElement(ttTables.TableName)
               .
    END.         
    RETURN cForEach.
    
  END METHOD.

  METHOD PUBLIC VOID viewttTables().
    DEF VAR hbttTables AS HANDLE NO-UNDO.
    DEF VAR hbttFields AS HANDLE NO-UNDO.

    IF SEARCH("toexcelviafile.p") = ? AND SEARCH("toexcelviafile.r") = ? THEN
      MESSAGE "Missing toExcelViaFile.p.."
              VIEW-AS ALERT-BOX.
    ELSE DO:        
      hbttTables = BUFFER ttTables:HANDLE.
      hbttFields = BUFFER ttFields:HANDLE.
      RUN toexcelviafile.p (hbttTables,-2).
      RUN toexcelviafile.p (hbttFields,-2).
    END.  
  END METHOD.

  METHOD PUBLIC VOID viewResultTables(INPUT TableList AS CHAR
                                     ,INPUT OpenWith  AS CHAR):
    IF SEARCH("toexcelviafile.p") = ? AND SEARCH("toexcelviafile.r") = ? THEN
      MESSAGE "Missing toExcelViaFile.p.."
              VIEW-AS ALERT-BOX.
    ELSE DO:        
      FOR EACH ttTables:
        IF VALID-HANDLE(ttTables.hBuffer) AND CAN-DO(TableList,ttTables.hBuffer:NAME) THEN 
          RUN toexcelviafile.p (ttTables.hBuffer,IF OpenWith = "notepad" THEN -2 ELSE 0).
      END.
    END.  
  END METHOD.  
 
  METHOD PUBLIC VOID viewResultDS().
    DEF VAR cFileName AS CHAR NO-UNDO.
    
    cFileName = SESSION:TEMP-DIR + cSchemaName + "_result_" + REPLACE(STRING(NOW,"99.99.9999 hh:mm:ss"),":",".") + ".json".
    
    hdsResult:WRITE-JSON ("file",cFileName,yes).
    OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
  END METHOD.

  METHOD PUBLIC VOID viewJsonInput().
    DEF VAR cFileName AS CHAR NO-UNDO.
    
    cFileName = SESSION:TEMP-DIR + cSchemaName + "_jsoninput_" + REPLACE(STRING(NOW,"99.99.9999 hh:mm:ss"),":",".") + ".json".
    
    COPY-LOB FROM JsonLongChar TO FILE cFileName.
    OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).
  END METHOD.

  METHOD PUBLIC VOID viewLogFile().
    IF logFile NE "" THEN
      OS-COMMAND NO-WAIT VALUE("notepad " + logFile).
  END METHOD.
  
  METHOD PUBLIC HANDLE getResultBufferHandle (INPUT icTableName   AS CHAR):
    FIND FIRST ttTables 
         WHERE ttTables.TableName = icTableName
         NO-ERROR.
    IF AVAIL ttTables THEN
      RETURN ttTables.hBuffer.
    ELSE RETURN ?.
  END METHOD.

  METHOD PUBLIC CHARACTER getResultFirstFieldValue (INPUT icTableName   AS CHAR
                                                   ,INPUT icFieldName AS CHAR):
    DEF VAR bOk AS LOG NO-UNDO.
                                                         
    FIND FIRST ttTables 
         WHERE ttTables.TableName = icTableName
         NO-ERROR.
    IF AVAIL ttTables THEN DO:
      FIND FIRST ttFields
           WHERE ttFields.TableName = ttTables.TableName
             AND ttFields.JsonFieldName = icFieldName
           NO-ERROR.
      IF NOT AVAIL ttFields THEN     
        FIND FIRST ttFields
             WHERE ttFields.TableName = ttTables.TableName
               AND ttFields.FieldName = icFieldName
             NO-ERROR.
      IF AVAIL ttFields THEN DO:
        bOk = ttTables.hBuffer:FIND-FIRST () NO-ERROR.
        IF bOk THEN
          RETURN STRING(ttFields.hField:BUFFER-VALUE).
      END.    
    END.  
    RETURN (IF returnBlankWhenNoValue THEN "" ELSE ?).
    
  END METHOD.

  METHOD PUBLIC HANDLE createView(INPUT icBuffersAndFields AS CHAR):
    DEF VAR ix             AS INT    NO-UNDO.
    DEF VAR iy             AS INT    NO-UNDO.
    DEF VAR iz             AS INT    NO-UNDO.
    DEF VAR hBuffer        AS HANDLE NO-UNDO EXTENT.
    DEF VAR hFillQuery     AS HANDLE NO-UNDO.
    DEF VAR hField         AS HANDLE NO-UNDO.
    DEF VAR cFieldName     AS CHAR   NO-UNDO.
    DEF VAR cFieldList     AS CHAR   NO-UNDO.
    DEF VAR cFillString    AS CHAR   NO-UNDO.
    DEF VAR cTopTable      AS CHAR   NO-UNDO.
    DEF VAR iCnt           AS INT    NO-UNDO.
    DEF VAR cParentBuff    AS CHAR   NO-UNDO.
    DEF VAR hRelation      AS HANDLE NO-UNDO.
    DEF VAR cBufferList    AS CHAR   NO-UNDO.
    DEF VAR cBufferName    AS CHAR   NO-UNDO.
    DEF VAR cBuffFieldDef  AS CHAR   NO-UNDO.
    DEF VAR cFieldDef      AS CHAR   NO-UNDO.
    DEF VAR cExtraField    AS CHAR   NO-UNDO.
    DEF VAR cExtraDataType AS CHAR   NO-UNDO.
    DEF VAR cExtraFormat   AS CHAR   NO-UNDO.
    DEF VAR cExtraInit     AS CHAR   NO-UNDO.
    DEF VAR cExtraLabel    AS CHAR   NO-UNDO.
    DEF VAR bDuplicate     AS LOG    NO-UNDO.
    DEF VAR cFieldProp     AS CHAR   NO-UNDO.

    statusMessage = "".
       
    EXTENT(hBuffer) = hdsResult:NUM-BUFFERS.
    
    CREATE ttView.
    CREATE TEMP-TABLE ttView.httView.
    CREATE QUERY hFillQuery.
    
    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      cBufferName = TRIM(ENTRY(1,ENTRY(ix,icBuffersAndFields),";")).
      REPEAT WHILE INDEX(cBufferName,"  ") > 0:
        cBufferName = REPLACE(cBufferName,"  "," ").
      END.
      CREATE ttViewTableDef.
      ASSIGN ttViewTableDef.httView = ttView.httView
             ttViewTableDef.ViewTableSeq  = ix.
      
      IF NUM-ENTRIES(cBufferName,"|") > 1 THEN
        ASSIGN ttViewTableDef.JoinCrit = ENTRY(2,cBufferName,"|")
               cBufferName = ENTRY(1,cBufferName,"|")
               .
      
      IF NUM-ENTRIES(cBufferName," ") = 2 THEN DO:
        IF CAN-DO("FIRST,EACH,LAST",ENTRY(1,cBufferName," ")) THEN 
          ASSIGN ttViewTableDef.JoinOper = ENTRY(1,cBufferName," ")
                 ttViewTableDef.ViewTableName = ENTRY(2,cBufferName," ")
                 cBufferName = ENTRY(2,cBufferName," ")
                 .
        ELSE         
          ASSIGN ttViewTableDef.JoinOper = "EACH"
                 ttViewTableDef.ViewTableName = ENTRY(1,cBufferName," ")
                 ttViewTableDef.JoinType = ENTRY(2,cBufferName," ")
                 cBufferName   = ENTRY(1,cBufferName," ")
                 .       
      END.         
      ELSE IF NUM-ENTRIES(cBufferName," ") > 2 THEN
        ASSIGN ttViewTableDef.JoinOper = ENTRY(1,cBufferName," ")
               ttViewTableDef.ViewTableName = ENTRY(2,cBufferName," ")
               ttViewTableDef.JoinType = ENTRY(3,cBufferName," ")
               cBufferName   = ENTRY(2,cBufferName," ")
               .       
      ELSE
        ASSIGN ttViewTableDef.ViewTableName = cBufferName
               ttViewTableDef.JoinOper = "EACH"
               .
        
      cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + cBufferName.
      IF INDEX(ENTRY(ix,icBuffersAndFields),";") > 0 THEN DO:
        cBuffFieldDef = SUBSTR(ENTRY(ix,icBuffersAndFields),INDEX(ENTRY(ix,icBuffersAndFields),";") + 1).
        DO iy = 1 TO NUM-ENTRIES(cBuffFieldDef,";"):
          cFieldDef = ENTRY(iy,cBuffFieldDef,";").
          IF cFieldDef BEGINS "+" THEN 
            ttViewTableDef.ExtraFields = ttViewTableDef.ExtraFields + (IF ttViewTableDef.ExtraFields NE "" THEN ";" ELSE "") + SUBSTR(cFieldDef,2).
          ELSE 
            ASSIGN ttViewTableDef.BufferFields = ttViewTableDef.BufferFields 
                                               + (IF ttViewTableDef.BufferFields NE "" THEN ";" ELSE "") 
                                               + ENTRY(1,cFieldDef,"|")
                   ttViewTableDef.FieldPropList = ttViewTableDef.FieldPropList
                                               + (IF ttViewTableDef.FieldPropList NE "" THEN ";" ELSE "")
                                               + cFieldDef                            
                                               .
        END.  
      END.  
    END.
      
    DO ix = 1 TO NUM-ENTRIES(cBufferList):
      hBuffer[ix] = hdsResult:GET-BUFFER-HANDLE(ENTRY(ix,cBufferList)).

      FIND FIRST ttViewTableDef
           WHERE ttViewTableDef.ViewTableName = hBuffer[ix]:NAME
             AND ttViewTableDef.httView = ttView.httView 
           NO-ERROR.
      IF NOT AVAIL ttViewTableDef THEN NEXT.
      IF cTopTable = "" THEN cTopTable = hBuffer[ix]:NAME.
      hRelation = hdsResult:GET-RELATION (hBuffer[ix]:NAME) NO-ERROR.
      IF VALID-HANDLE(hRelation) THEN
        cParentBuff = hRelation:PARENT-BUFFER:NAME.
      ELSE 
        cParentBuff = cTopTable. 

      hFillQuery:ADD-BUFFER(hBuffer[ix]).
      ASSIGN iCnt  = iCnt + 1
             cFillString = cFillString 
                         + (IF cFillString = "" THEN "FOR EACH " + hBuffer[ix]:NAME
                            ELSE 
                              ","
                              + ttViewTableDef.JoinOper     
                              + " " + hBuffer[ix]:NAME
                              + " " + ttViewTableDef.JoinType + " WHERE "
                              + (IF ttViewTableDef.JoinCrit NE "" THEN ttViewTableDef.JoinCrit ELSE hBuffer[ix]:NAME + ".JBoxParentRowIdent = " + cParentBuff + ".JBoxRowIdent"))
             .
      IF ttViewTableDef.BufferFields NE "" THEN DO iy = 1 TO NUM-ENTRIES(ttViewTableDef.BufferFields,";"):       
        hField = hBuffer[ix]:BUFFER-FIELD (ENTRY(iy,ttViewTableDef.BufferFields,";")) NO-ERROR.
        IF NOT VALID-HANDLE(hField) THEN NEXT.
        IF ERROR-STATUS:ERROR THEN DO:
          MESSAGE "Field" ENTRY(iy,ttViewTableDef.BufferFields,";") "does not exist in table" ttViewTableDef.ViewTableName
          VIEW-AS ALERT-BOX.
          NEXT.
        END.
        ASSIGN bDuplicate = NO
               cFieldProp = ENTRY(iy,ttViewTableDef.FieldPropList,";").  
        IF CAN-DO(cFieldList,hField:NAME) THEN 
          ASSIGN cFieldName = hField:NAME + STRING(ix)
                 ttViewTableDef.FieldMap = ttViewTableDef.FieldMap + (IF ttViewTableDef.FieldMap NE "" THEN "," ELSE "")  
                                       + cFieldName + ";" + hField:NAME
                 ttViewTableDef.ExceptList = ttViewTableDef.ExceptList + (IF ttViewTableDef.ExceptList NE "" THEN "," ELSE "")                      
                                       + hField:NAME
                 bDuplicate = YES                                             
                 .   
        ELSE cFieldName = hField:NAME.
        cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + cFieldName.
        IF NUM-ENTRIES(cFieldProp,"|") > 1 THEN DO:
          DO iz = 2 TO NUM-ENTRIES(cFieldProp,"|"):
            CASE iz:
              WHEN 2 THEN cExtraDataType = ENTRY(iz,cFieldProp,"|").
              WHEN 3 THEN cExtraFormat   = ENTRY(iz,cFieldProp,"|").
              WHEN 4 THEN cExtraInit     = ENTRY(iz,cFieldProp,"|").
              WHEN 5 THEN cExtraLabel    = ENTRY(iz,cFieldProp,"|").
            END CASE.
          END.
          iz = iz - 1.
          IF iz < 2 THEN DO:
            MESSAGE PROGRAM-NAME(1) SKIP
                    "Missing data type for field override " + cFieldProp SKIP 
                    "Usage: <fieldname>|<datatype>[|<format>[<init>[|<label>]]]"
                    VIEW-AS ALERT-BOX.
            RETURN ?.
          END.
          CASE iz:
            WHEN 2 THEN DO:
              IF bDuplicate THEN
                ttView.httView:ADD-NEW-FIELD(cFieldName,cExtraDataType,0,hField:FORMAT,"",hBuffer[ix]:NAME + "." + hField:NAME).
              ELSE  
                ttView.httView:ADD-NEW-FIELD(cFieldName,cExtraDataType,0,hField:FORMAT).
            END.  
            WHEN 3 THEN DO:
              IF bDuplicate THEN
                ttView.httView:ADD-NEW-FIELD(cFieldName,cExtraDataType,0,cExtraFormat,"",hBuffer[ix]:NAME + "." + hField:NAME).
              ELSE  
                ttView.httView:ADD-NEW-FIELD(cFieldName,cExtraDataType,0,cExtraFormat).
            END.    
            WHEN 4 THEN DO:
              IF cExtraInit = "" THEN
                ttView.httView:ADD-NEW-FIELD(cExtraField,cExtraDataType,0,cExtraFormat).
              ELSE
                ttView.httView:ADD-NEW-FIELD(cExtraField,cExtraDataType,0,cExtraFormat,cExtraInit).
            END.
            WHEN 5 THEN 
              ttView.httView:ADD-NEW-FIELD(cFieldName,
                                        cExtraDataType,0,
                                        cExtraFormat,
                                        cExtraInit,
                                        cExtraLabel,
                                        IF cExtraLabel MATCHES "*" + CHR(10) + "*" THEN
                                          REPLACE(cExtraLabel,CHR(10),"!")
                                        ELSE ?) NO-ERROR.
          END CASE.
        END.  
        ELSE IF bDuplicate THEN 
          ttView.httView:ADD-NEW-FIELD (cFieldName,hField:DATA-TYPE,0,hField:FORMAT,"",hBuffer[ix]:NAME + "." + hField:NAME).
        ELSE  
          ttView.httView:ADD-NEW-FIELD (cFieldName,hField:DATA-TYPE,0,hField:FORMAT).
      END.       
      DO iy = 1 TO hBuffer[ix]:NUM-FIELDS:
        hField = hBuffer[ix]:BUFFER-FIELD (iy) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN NEXT.
        IF ttViewTableDef.BufferFields NE "" AND LOOKUP(hField:NAME,ttViewTableDef.BufferFields,";") = 0 THEN DO:
          ttViewTableDef.ExceptList = ttViewTableDef.ExceptList + (IF ttViewTableDef.ExceptList NE "" THEN "," ELSE "") + hField:NAME.
          NEXT.
        END.  
        ELSE IF ttViewTableDef.BufferFields NE "" AND LOOKUP(hField:NAME,ttViewTableDef.BufferFields,";") > 0 THEN NEXT.
        
        bDuplicate = NO.  
        IF CAN-DO(cFieldList,hField:NAME) THEN 
          ASSIGN cFieldName = hField:NAME + STRING(ix)
                 ttViewTableDef.FieldMap = ttViewTableDef.FieldMap + (IF ttViewTableDef.FieldMap NE "" THEN "," ELSE "")  
                                       + cFieldName + ";" + hField:NAME
                 ttViewTableDef.ExceptList = ttViewTableDef.ExceptList + (IF ttViewTableDef.ExceptList NE "" THEN "," ELSE "")                      
                                       + hField:NAME                       
                 bDuplicate = YES                                             
                 .   
        ELSE cFieldName = hField:NAME.
        cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + cFieldName. 
        IF bDuplicate THEN 
          ttView.httView:ADD-NEW-FIELD (cFieldName,hField:DATA-TYPE,0,hField:FORMAT,"",hBuffer[ix]:NAME + "." + hField:NAME).
        ELSE  
          ttView.httView:ADD-NEW-FIELD (cFieldName,hField:DATA-TYPE,0,hField:FORMAT).
      END.  

      DO iy = 1 TO NUM-ENTRIES(ttViewTableDef.ExtraFields,";"):
        DO iz = 1 TO NUM-ENTRIES(ENTRY(iy,ttViewTableDef.ExtraFields,";"),"|"):
          CASE iz:
            WHEN 1 THEN cExtraField    = ENTRY(iz,ENTRY(iy,ttViewTableDef.ExtraFields,";"),"|").
            WHEN 2 THEN cExtraDataType = ENTRY(iz,ENTRY(iy,ttViewTableDef.ExtraFields,";"),"|").
            WHEN 3 THEN cExtraFormat   = ENTRY(iz,ENTRY(iy,ttViewTableDef.ExtraFields,";"),"|").
            WHEN 4 THEN cExtraInit     = ENTRY(iz,ENTRY(iy,ttViewTableDef.ExtraFields,";"),"|").
            WHEN 5 THEN cExtraLabel    = ENTRY(iz,ENTRY(iy,ttViewTableDef.ExtraFields,";"),"|").
          END CASE.
        END.
        iz = iz - 1.
        IF iz < 2 THEN DO:
          MESSAGE PROGRAM-NAME(1) SKIP
                  "Missing data type for extra field " + cExtraField SKIP
                  "Usage: +<fieldname>|<datatype>[|<format>[<init>[|<label>]]]"
                  VIEW-AS ALERT-BOX.
          RETURN ?.
        END.
        CASE iz:
          WHEN 2 THEN ttView.httView:ADD-NEW-FIELD(cExtraField,cExtraDataType).
          WHEN 3 THEN ttView.httView:ADD-NEW-FIELD(cExtraField,cExtraDataType,0,cExtraFormat).
          WHEN 4 THEN DO:
            IF cExtraInit = "" THEN
              ttView.httView:ADD-NEW-FIELD(cExtraField,cExtraDataType,0,cExtraFormat).
            ELSE
              ttView.httView:ADD-NEW-FIELD(cExtraField,cExtraDataType,0,cExtraFormat,cExtraInit).
          END.
          WHEN 5 THEN 
            ttView.httView:ADD-NEW-FIELD(cExtraField,
                                      cExtraDataType,0,
                                      cExtraFormat,
                                      cExtraInit,
                                      cExtraLabel,
                                      IF cExtraLabel MATCHES "*" + CHR(10) + "*" THEN
                                        REPLACE(cExtraLabel,CHR(10),"!")
                                      ELSE ?) NO-ERROR.
        END CASE.
        cExtraInit = "".
        
      END.
      
    END.  
    ttView.httView:ADD-NEW-FIELD ("RowIdent1","CHARACTER").
    ttView.httView:ADD-NEW-FIELD ("RowCount","INTEGER").
    
    ttView.httView:TEMP-TABLE-PREPARE (IF cBufferList NE "" THEN ENTRY(1,cBufferList) ELSE hBuffer[1]:NAME).

    IF cFillString NE "" THEN DO:    
      ttView.FillString = cFillString.
      
      hFillQuery:QUERY-PREPARE(cFillString).
      hFillQuery:QUERY-OPEN ().
      iCnt = 0.
      REPEAT WHILE hFillQuery:GET-NEXT():
        ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
        DO ix = 1 TO hFillQuery:NUM-BUFFERS:
          IF NOT hFillQuery:GET-BUFFER-HANDLE(ix):AVAIL THEN NEXT.
          FIND FIRST ttViewTableDef
               WHERE ttViewTableDef.ViewTableName = hFillQuery:GET-BUFFER-HANDLE(ix):NAME 
                 AND ttViewTableDef.httView       = ttView.httView
               NO-ERROR.
          IF NOT AVAIL ttViewTableDef THEN NEXT.
               
          ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(hFillQuery:GET-BUFFER-HANDLE(ix),ttViewTableDef.ExceptList).
          DO iy = 1 TO NUM-ENTRIES(ttViewTableDef.FieldMap):
            ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ENTRY(1,ENTRY(iy,ttViewTableDef.FieldMap),";")):BUFFER-VALUE =
                             hFillQuery:GET-BUFFER-HANDLE(ix):BUFFER-FIELD(ENTRY(2,ENTRY(iy,ttViewTableDef.FieldMap),";")):BUFFER-VALUE.
          END.
        END.  
        ASSIGN iCnt = iCnt + 1
               ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD ("RowIdent1"):BUFFER-VALUE = STRING(ttView.httView:DEFAULT-BUFFER-HANDLE:ROWID)
               ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD ("RowCount"):BUFFER-VALUE = iCnt
               .
      END.
    END.  

    CATCH eErr AS Progress.Lang.Error :
      statusMessage = eErr:GetMessage(1).
    END CATCH.

    FINALLY:
      DELETE OBJECT hFillQuery.
      RETURN ttView.httView.
    END.  
    
  END.
  
  METHOD PUBLIC LOGICAL fillView (INPUT ihViewTable AS HANDLE
                                 ,INPUT ibAppend    AS LOG):
    
    DEF VAR ix             AS INT    NO-UNDO.
    DEF VAR iy             AS INT    NO-UNDO.
    DEF VAR hBuffer        AS HANDLE NO-UNDO EXTENT.
    DEF VAR hFillQuery     AS HANDLE NO-UNDO.
    DEF VAR iCnt           AS INT    NO-UNDO.
    DEF VAR cTable         AS CHAR   NO-UNDO.
    
    EXTENT(hBuffer) = hdsResult:NUM-BUFFERS.
    
    statusMessage = "".    
        
    FIND FIRST ttView 
         WHERE ttView.httView = ihViewTable
         NO-ERROR.
    IF NOT AVAIL ttView AND ihViewTable:TYPE = "buffer" THEN DO:        
      FIND FIRST ttView 
           WHERE ttView.httView = ihViewTable:TABLE-HANDLE
           NO-ERROR.
      IF AVAIL ttView THEN ihViewTable = ihViewTable:TABLE-HANDLE.     
    END.       
    IF NOT AVAIL ttView THEN DO:
      statusMessage = "No view defined for table/buffer handle " + STRING(ihViewTable).
      RETURN NO.
    END. 
    
    IF NOT ibAppend THEN ttView.httView:EMPTY-TEMP-TABLE ().
        
    CREATE QUERY hFillQuery.
          
    REPEAT WHILE INDEX(ttView.FillString,"  ") > 0:
      ttView.FillString = REPLACE(ttView.FillString,"  "," ").
    END.          
    ttView.FillString = TRIM(ttView.FillString).
          
    DO ix = 1 TO NUM-ENTRIES(ttView.FillString):
      IF ENTRY(ix,ttView.FillString) BEGINS "EACH " OR ENTRY(ix,ttView.FillString) BEGINS "FIRST " OR ENTRY(ix,ttView.FillString) BEGINS "LAST " THEN
        cTable = ENTRY(1,ENTRY(2,ENTRY(ix,ttView.FillString)," "),";").
      ELSE IF ENTRY(ix,ttView.FillString) BEGINS "FOR EACH " THEN
        cTable = ENTRY(1,ENTRY(3,ENTRY(ix,ttView.FillString)," "),";").
      ELSE
        cTable = ENTRY(1,ENTRY(ix,ttView.FillString),";").
          
      hBuffer[ix] = hdsResult:GET-BUFFER-HANDLE(cTable).
      FIND FIRST ttViewTableDef
           WHERE ttViewTableDef.ViewTableName = hBuffer[ix]:NAME
             AND ttViewTableDef.httView = ttView.httView 
           NO-ERROR.
      IF NOT AVAIL ttViewTableDef THEN NEXT.

      hFillQuery:ADD-BUFFER(hBuffer[ix]).
    END.  
    
    hFillQuery:QUERY-PREPARE(ttView.FillString).
    hFillQuery:QUERY-OPEN ().
    iCnt = 0.
    REPEAT WHILE hFillQuery:GET-NEXT():
      
      ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-CREATE().
      DO ix = 1 TO hFillQuery:NUM-BUFFERS:
        IF NOT hFillQuery:GET-BUFFER-HANDLE(ix):AVAIL THEN NEXT.
        FIND FIRST ttViewTableDef
             WHERE ttViewTableDef.ViewTableName = hFillQuery:GET-BUFFER-HANDLE(ix):NAME
               AND ttViewTableDef.httView = ttView.httView 
             NO-ERROR.
        IF NOT AVAIL ttViewTableDef THEN NEXT.
             
        ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-COPY(hFillQuery:GET-BUFFER-HANDLE(ix),ttViewTableDef.ExceptList).
        DO iy = 1 TO NUM-ENTRIES(ttViewTableDef.FieldMap):
          ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ENTRY(1,ENTRY(iy,ttViewTableDef.FieldMap),";")):BUFFER-VALUE =
                           hFillQuery:GET-BUFFER-HANDLE(ix):BUFFER-FIELD(ENTRY(2,ENTRY(iy,ttViewTableDef.FieldMap),";")):BUFFER-VALUE.
        END.
      END.  
      ASSIGN iCnt = iCnt + 1
             ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD ("RowIdent1"):BUFFER-VALUE = STRING(ttView.httView:DEFAULT-BUFFER-HANDLE:ROWID)
             ttView.httView:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD ("RowCount"):BUFFER-VALUE = iCnt
             .
    END.

    CATCH eErr AS Progress.Lang.Error :
      statusMessage = eErr:GetMessage(1).
    END CATCH.

    FINALLY:
      DELETE OBJECT hFillQuery NO-ERROR.
      RETURN statusMessage = "".
    END.  
    
  END METHOD.   

  METHOD PUBLIC LOGICAL createXMLSchema (INPUT ilcXML AS LONGCHAR, INPUT icSchemaName AS CHAR):

    DEF VAR hDoc             AS HANDLE NO-UNDO.
    DEF VAR hRoot            AS HANDLE NO-UNDO.
    DEF VAR httTable         AS HANDLE NO-UNDO.
    DEF VAR iCurrTableSeq        AS INT    NO-UNDO.
    DEF VAR hBuffer          AS HANDLE NO-UNDO.

    IF KEYWORD(icSchemaName) NE ? THEN DO:
      statusMessage = "Dataset schema cannot be named as keyword " + KEYWORD(icSchemaName).
      RETURN NO.
    END.  

    CREATE X-DOCUMENT hDoc.
    CREATE X-NODEREF hRoot.
                
    hDoc:LOAD("longchar",ilcXml,NO).
    
    hDoc:GET-DOCUMENT-ELEMENT(hRoot).
    
    SESSION:NUMERIC-FORMAT = "American".
                
    IF VALID-HANDLE(hdsResult) THEN    
      DELETE OBJECT hdsResult.
    
    CREATE DATASET hdsResult.
        
    statusMessage = "".
    
    IF icSchemaName NE "refreshSchema" THEN DO:
      ASSIGN iGlobId = 0
             cSchemaName   = (IF icSchemaName NE "" THEN icSchemaName ELSE "ttXMLHeader")    
             iNameSeq = 0
             iGlobTableSeq = 0
             .
      hdsSchema:EMPTY-DATASET ().
      cSchemaName = CreateTtTable(hRoot:LOCAL-NAME,"",0,0,"OBJECT",OUTPUT httTable,OUTPUT iCurrTableSeq).
    END.  

    createXMLObjectSchema(hRoot, 1,iCurrTableSeq,httTable).

    prepareXMLSchema(cSchemaName).
    
    FIND FIRST ttTables 
         WHERE ttTables.TableName = cSchemaName
           AND ttTables.ParentTableName = ""
         NO-ERROR.
    IF NOT AVAIL ttTables THEN DO:
      MESSAGE "No schema was generated"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO.
    END.
        
    IF icSchemaName = "refreshSchema" THEN RETURN YES. // Caller is responsible for re-appending the data again
           
    ttTables.hBuffer:BUFFER-CREATE ().
    ASSIGN iGlobId = iGlobId + 1
           ttTables.hBuffer::JBoxRowIdent = iGlobId
           ttTables.hBuffer::JBoxParentRowIdent = 0
           .

    readXMLData(hRoot,1,iGlobId,cSchemaName,ttTables.hBuffer,ttTables.Seq).

    FOR EACH ttFields: 
      IF ttFields.DataType = "CHARACTER" AND ttFields.Length > 0 THEN
         ttFields.hField:FORMAT = "x(" + STRING(ttFields.Length) + ")".
         
      ttFields.FormatString = ttFields.hField:FORMAT.    
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

  METHOD PROTECTED VOID createXMLObjectSchema(INPUT ihParent   AS HANDLE
                                             ,INPUT iiLevel    AS INTEGER
                                             ,iiParentTableSeq AS INT
                                             ,ihBuffer         AS HANDLE):

    DEF VAR ix              AS INTEGER NO-UNDO.
    DEF VAR iy              AS INTEGER NO-UNDO.
    DEF VAR hNoderef        AS HANDLE  NO-UNDO.
    DEF VAR bOk             AS LOGICAL NO-UNDO.
    DEF VAR cOEname         AS CHAR    NO-UNDO.
    DEF VAR iCurrTableSeq       AS INT     NO-UNDO.
    DEF VAR httTable        AS HANDLE  NO-UNDO.
    DEF VAR hGrandPa        AS HANDLE  NO-UNDO.
    DEF VAR bGrandPaOk      AS lOG     NO-UNDO.
    DEF VAR cUniqueParent   AS CHAR    NO-UNDO.
    DEF VAR cAnames         AS CHAR    NO-UNDO.

    CREATE X-NODEREF hNoderef.

    CREATE X-NODEREF hGrandPa.
    bGrandPaOk = ihParent:GET-PARENT(hGrandPa).

    REPEAT ix = 1 TO ihParent:NUM-CHILDREN:
      bOk = ihParent:GET-CHILD(hNoderef,ix).
      IF NOT bOk THEN LEAVE.
      IF NOT CAN-DO("element",hNoderef:SUBTYPE) THEN NEXT.
      IF hNoderef:NUM-CHILDREN > 1 THEN DO:
        cUniqueParent = getUniqueXMLParent(hNodeRef).
        cOEname = THIS-OBJECT:createTtTable(hNoderef:LOCAL-NAME,
                                            IF iiParentTableSeq = 1 THEN cSchemaName ELSE ihParent:LOCAL-NAME,
                                            iiLevel,
                                            iiParentTableSeq,
                                            cUniqueParent,
                                            OUTPUT httTable,
                                            OUTPUT iCurrTableSeq).
  
        DO iy = 1 TO NUM-ENTRIES(hNoderef:ATTRIBUTE-NAMES):                         
          createTtField(hNoderef:LOCAL-NAME,ENTRY(iy,hNoderef:ATTRIBUTE-NAMES),"CHARACTER",ihParent:LOCAL-NAME,cUniqueParent,iiLevel).
        END.                                    
        createXMLObjectSchema(hNoderef,iiLevel + 1,iCurrTableSeq,httTable).
      END.
      ELSE IF bGrandPaOk AND NOT hNoderef:LOCAL-NAME MATCHES "JBox*RowIdent" THEN DO:
        cUniqueParent = getUniqueXMLParent(ihParent).
        createTtField(ihParent:LOCAL-NAME,hNoderef:LOCAL-NAME,"CHARACTER",hGrandPa:LOCAL-NAME,cUniqueParent,iiLevel - 1).
      END.   
      ELSE IF iiLevel = 1 THEN
        createTtField(ihParent:LOCAL-NAME,hNoderef:LOCAL-NAME,"CHARACTER","","OBJECT",iiLevel - 1).
    END.

    DELETE OBJECT hNoderef.
    IF bGrandPaOk THEN DELETE OBJECT hGrandPa.
  END METHOD.    

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID readXMLdata (INPUT ihParent         AS HANDLE
                                    ,INPUT iiLevel          AS INT
                                    ,INPUT iiParentId       AS INT
                                    ,INPUT icTableName      AS CHAR
                                    ,INPUT ihBuffer         AS HANDLE
                                    ,INPUT iiParentTableSeq AS INT):
    
    DEF VAR ix            AS INTEGER NO-UNDO.
    DEF VAR iy            AS INT     NO-UNDO.
    DEF VAR hNoderef      AS HANDLE  NO-UNDO.
    DEF VAR bOk           AS LOGICAL NO-UNDO.
    DEF VAR cOEname       AS CHAR    NO-UNDO.
    DEF VAR httTable      AS HANDLE  NO-UNDO.
    DEF VAR hGrandPa      AS HANDLE  NO-UNDO.
    DEF VAR bGrandPaOk    AS lOG     NO-UNDO.
    DEF VAR hBuffer       AS HANDLE  NO-UNDO.
    DEF VAR cUniqueParent AS CHAR    NO-UNDO.
    DEF VAR cTable        AS CHAR    NO-UNDO.
    DEF VAR hFldLength    AS HANDLE  NO-UNDO.

    DEF BUFFER ttTables FOR ttTables.
    DEF BUFFER ttFields FOR ttFields.

    hFldLength = BUFFER ttFields:BUFFER-FIELD("Length").

    CREATE X-NODEREF hNoderef.

    CREATE X-NODEREF hGrandPa.
    bGrandPaOk = ihParent:GET-PARENT(hGrandPa).

    REPEAT ix = 1 TO ihParent:NUM-CHILDREN:
      bOk = ihParent:GET-CHILD(hNoderef,ix).
      IF NOT bOk THEN LEAVE.
      IF NOT CAN-DO("element,text",hNoderef:SUBTYPE) THEN NEXT.
      IF hNoderef:SUBTYPE = "element" AND hNoderef:NUM-CHILDREN > 1 THEN DO:        
        FIND FIRST ttTables 
             WHERE ttTables.JsonTableName = hNoderef:LOCAL-NAME
               AND ttTables.Level = iiLevel
               AND ttTables.ParentSeq = iiParentTableSeq
             NO-ERROR.
        /* Since this is the 2nd round the uniqueParent might be on a level too high
           - 1st search for uniqueness doesn't know about duplicates */     
        IF NOT AVAIL ttTables AND iiLevel > 1 THEN            
          FIND FIRST ttTables 
               WHERE ttTables.JsonTableName = hNoderef:LOCAL-NAME
                 AND ttTables.ParentJsonTableName = ihParent:LOCAL-NAME AND
                     ttTables.cType = ihParent:LOCAL-NAME
                 AND ttTables.Level = iiLevel
               NO-ERROR.
        
        IF AVAIL ttTables THEN DO:         
          ttTables.hBuffer:BUFFER-CREATE ().
          ASSIGN iGlobId = iGlobId + 1
                 ttTables.hBuffer::JBoxRowIdent = iGlobId
                 ttTables.hBuffer::JBoxParentRowIdent = iiParentId
                 .    
          DO iy = 1 TO NUM-ENTRIES(hNoderef:ATTRIBUTE-NAMES):                         
            FIND FIRST ttFields 
                 WHERE ttFields.TableName     = ttTables.TableName
                   AND ttFields.JsonFieldName = ENTRY(iy,hNoderef:ATTRIBUTE-NAMES)
                   AND ttFields.Level         = iiLevel + 1
                   AND ttFields.TableSeq      = ttTables.Seq
                 NO-ERROR.
            IF AVAIL ttFields THEN       
              AssignValue(ttFields.TableName,"STRING",ttTables.hBuffer:BUFFER-FIELD(ttFields.FieldName),hNoderef:GET-ATTRIBUTE(ENTRY(iy,hNoderef:ATTRIBUTE-NAMES)),hFldLength).
          END.                                    
       
          readXMLdata(hNoderef,iiLevel + 1,iGlobId,ttTables.TableName,ttTables.hBuffer,ttTables.Seq).
        END.  
        ELSE schemaWarning = "Warning: Couldn't find ttTables for tablename " + hNoderef:LOCAL-NAME + " Level: " + STRING(iiLevel) + " Parent table: " + ihParent:LOCAL-NAME.
      END.
      ELSE IF hNoderef:SUBTYPE = "element" THEN  
        readXMLdata(hNoderef,iiLevel,iGlobId,icTableName,ihBuffer,iiParentTableSeq).
      ELSE DO:
        FIND FIRST ttFields 
             WHERE ttFields.TableName     = icTableName
               AND ttFields.JsonFieldName = ihParent:LOCAL-NAME
               AND ttFields.Level         = iiLevel 
               AND ttFields.TableSeq      = iiParentTableSeq
             NO-ERROR.
        IF AVAIL ttFields THEN       
          AssignValue(ttFields.TableName,"STRING",ihBuffer:BUFFER-FIELD(ttFields.FieldName),hNoderef:NODE-VALUE,hFldLength).
      END.
    END.

    DELETE OBJECT hNoderef.
    IF bGrandPaOk THEN DELETE OBJECT hGrandPa.

  END METHOD.

  METHOD PUBLIC LOGICAL appendXMLData (INPUT ilcXML AS LONGCHAR):

    DEF VAR hDoc             AS HANDLE NO-UNDO.
    DEF VAR hRoot            AS HANDLE NO-UNDO.
    DEF VAR httTable         AS HANDLE NO-UNDO.
    DEF VAR hBuffer          AS HANDLE NO-UNDO.

    CREATE X-DOCUMENT hDoc.
    CREATE X-NODEREF hRoot.
        
    hDoc:LOAD("longchar",ilcXml,FALSE).
    
    hDoc:GET-DOCUMENT-ELEMENT(hRoot).

    SESSION:NUMERIC-FORMAT = "American".
                        
    FIND FIRST ttTables 
         WHERE ttTables.TableName = cSchemaName
           AND ttTables.ParentTableName = ""
         NO-ERROR.
    IF NOT AVAIL ttTables THEN DO:
      MESSAGE "No schema was generated"
      VIEW-AS ALERT-BOX ERROR.
      RETURN NO.
    END.

    ttTables.hBuffer:BUFFER-CREATE ().
    ASSIGN iGlobId = iGlobId + 1
           ttTables.hBuffer::JBoxRowIdent = iGlobId
           ttTables.hBuffer::JBoxParentRowIdent = 0
           .

    readXMLData(hRoot,1,iGlobId,hRoot:LOCAL-NAME,ttTables.hBuffer,ttTables.Seq).

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

  METHOD PUBLIC LOGICAL prepareXMLSchema (INPUT icSchemaName AS CHAR):
    DEF VAR iErrCnt   AS INT NO-UNDO.
    DEF VAR hFld      AS HANDLE NO-UNDO.
    DEF VAR hRelation AS HANDLE NO-UNDO.
    
    DEF BUFFER bttTables FOR ttTables.

    FOR EACH ttTables BY ttTables.Seq:
      FOR EACH bttTables 
          WHERE bttTables.ParentJsonTableName = ttTables.JsonTableName
            AND bttTables.Level = ttTables.Level + 1
            AND bttTables.ParentTableName = ""
            AND bttTables.ParentSeq = ttTables.Seq
          :
        bttTables.ParentTableName = ttTables.TableName.
      END.
    END.  
    
    FOR EACH ttTables:
      ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
      IF ERROR-STATUS:NUM-MESSAGES > 0 AND logFile NE "" THEN
        LOG-MANAGER:WRITE-MESSAGE ("Warning - failed to prepare (but may be able to correct name): " + ttTables.TableName + " " + ERROR-STATUS:GET-MESSAGE(1) + ". For error 329 add name to reservedNames property").
          
       
      IF ERROR-STATUS:NUM-MESSAGES > 0 AND (ERROR-STATUS:GET-NUMBER(1) = 329 OR ERROR-STATUS:GET-NUMBER(1) = 274) THEN DO:
        ASSIGN ttTables.orgTableName = ttTables.TableName
               ttTables.TableName = ttTables.TableName + "_"
               ttTables.TableName = REPLACE(ttTables.TableName,"/","_sl_")
               ttTables.TableName = REPLACE(ttTables.TableName,CHR(123),"_clb_")
               ttTables.TableName = REPLACE(ttTables.TableName,CHR(125),"_crb_")
               .
        FOR EACH bttTables WHERE bttTables.ParentTableName = ttTables.orgTableName:
          bttTables.ParentTableName = ttTables.TableName.
        END.
        FOR EACH ttFields WHERE ttFields.TableName = ttTables.orgTableName:
          ttFields.TableName = ttTables.TableName.
          ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,ttFields.DataType).
        END.
        ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES = 0 THEN DO:
        END.
        ELSE IF ERROR-STATUS:GET-NUMBER(1) = 9033 THEN DO:
          ttTables.hTable:ADD-NEW-FIELD("JBoxRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-FIELD("JBoxParentRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-INDEX("idxRowIdent",YES,YES).
          ttTables.hTable:ADD-INDEX-FIELD("idxRowIdent","JBoxRowIdent").
          ttTables.hTable:ADD-NEW-INDEX("idxParentRowIdent").
          ttTables.hTable:ADD-INDEX-FIELD("idxParentRowIdent","JBoxParentRowIdent").
          ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
          IF ERROR-STATUS:NUM-MESSAGES > 1 THEN
            DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
              MESSAGE "Could not prepare table " ttTables.TableName " (after name modification and adding dummy fields) " SKIP
                      ERROR-STATUS:GET-MESSAGE(iErrCnt)
                      VIEW-AS ALERT-BOX ERROR.       
            END.
        END.    
        ELSE DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
          MESSAGE "Could not prepare table " ttTables.TableName " (after name modification) " SKIP
                  ERROR-STATUS:GET-MESSAGE(iErrCnt)
                  VIEW-AS ALERT-BOX ERROR.
        END.          
      END.
      ELSE IF ERROR-STATUS:NUM-MESSAGES > 0 AND ERROR-STATUS:GET-NUMBER(1) = 1700 THEN DO:
        ASSIGN ttTables.orgTableName = ttTables.TableName
               ttTables.TableName = SUBSTR(ttTables.TableName,1,32).
        FOR EACH bttTables WHERE bttTables.ParentTableName = ttTables.orgTableName:
          bttTables.ParentTableName = ttTables.TableName.
        END.
        FOR EACH ttFields WHERE ttFields.TableName = ttTables.orgTableName:
          ttFields.TableName = ttTables.TableName.
          ttTables.hTable:ADD-NEW-FIELD(ttFields.FieldName,ttFields.DataType).
        END.
        ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
        IF ERROR-STATUS:NUM-MESSAGES = 0 THEN DO:
        END.
        ELSE IF ERROR-STATUS:GET-NUMBER(1) = 9033 THEN DO:
          ttTables.hTable:ADD-NEW-FIELD("JBoxRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-FIELD("JBoxParentRowIdent","INTEGER").
          ttTables.hTable:ADD-NEW-INDEX("idxRowIdent",YES,YES).
          ttTables.hTable:ADD-INDEX-FIELD("idxRowIdent","JBoxRowIdent").
          ttTables.hTable:ADD-NEW-INDEX("idxParentRowIdent").
          ttTables.hTable:ADD-INDEX-FIELD("idxParentRowIdent","JBoxParentRowIdent").
          ttTables.hTable:TEMP-TABLE-PREPARE (ttTables.TableName) NO-ERROR.
          IF ERROR-STATUS:NUM-MESSAGES > 1 THEN
            DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
              MESSAGE "Could not prepare table " ttTables.TableName " (after name modification and adding dummy fields) " SKIP
                      ERROR-STATUS:GET-MESSAGE(iErrCnt)
                      VIEW-AS ALERT-BOX ERROR.       
            END.
        END.    
        ELSE DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
          MESSAGE "Could not prepare table " ttTables.TableName " (after name modification) " SKIP
                  ERROR-STATUS:GET-MESSAGE(iErrCnt)
                  VIEW-AS ALERT-BOX ERROR.
        END.          
      END.
      ELSE IF ERROR-STATUS:NUM-MESSAGES = 0 THEN
        ttTables.orgTableName = ttTables.TableName.
      ELSE DO iErrCnt = 1 TO ERROR-STATUS:NUM-MESSAGES:
        MESSAGE "Could not prepare table " ttTables.TableName  SKIP
                ERROR-STATUS:GET-MESSAGE(iErrCnt)
                VIEW-AS ALERT-BOX ERROR.
      END.          
         
      ttTables.hBuffer = ttTables.hTable:DEFAULT-BUFFER-HANDLE.
      
      ttTables.hBuffer:BUFFER-FIELD ("JBoxRowIdent"):SERIALIZE-HIDDEN = rowidentsHidden.
      ttTables.hBuffer:BUFFER-FIELD ("JBoxParentRowIdent"):SERIALIZE-HIDDEN = rowidentsHidden.
      
      hdsResult:ADD-BUFFER(ttTables.hBuffer).
      FIND FIRST bttTables 
           WHERE bttTables.TableName = ttTables.ParentTableName
             AND bttTables.Level = ttTables.Level - 1
           NO-ERROR.
      IF AVAIL bttTables THEN DO: 
        hRelation = hdsResult:ADD-RELATION(bttTables.hBuffer,ttTables.hBuffer,"JBoxRowIdent,JBoxParentRowIdent").
        hRelation:NAME = ttTables.TableName.
      END.
      
      FOR EACH ttFields 
          WHERE ttFields.TableName = ttTables.TableName
          :
        hFld = ttTables.hBuffer:BUFFER-FIELD(ttFields.FieldName) NO-ERROR.
        IF NOT ERROR-STATUS:ERROR THEN
          ASSIGN ttFields.hField  = hFld
                 ttFields.Level   = ttTables.Level + 1  // NB - diff from json  
                 .
        ELSE 
          MESSAGE "Invalid field name " ttFields.FieldName " for table " ttTables.TableName SKIP
                  ERROR-STATUS:GET-MESSAGE(1)
                  VIEW-AS ALERT-BOX ERROR.
      END.
    END.
  END. 

  METHOD PUBLIC VOID deleteTtView().
    IF VALID-OBJECT(httView) THEN DELETE OBJECT httView.
  END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC JBoxJsonParser ( ):
    SESSION:NUMERIC-FORMAT = cOrgNumFormat.
    FOR EACH ttView:
      IF VALID-OBJECT(ttView.httView) THEN DELETE OBJECT ttView.httView.
    END.  
    DELETE OBJECT hdsResult NO-ERROR. 
	END DESTRUCTOR.
  
END CLASS.