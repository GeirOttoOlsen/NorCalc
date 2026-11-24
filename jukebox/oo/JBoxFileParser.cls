 
 /*------------------------------------------------------------------------
    File        : JBoxFileParser
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : brynj
    Created     : Tue Feb 04 09:41:42 CET 2025
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxFileParser: 

  VAR INT     iNameSeq,iVoidSeq,ifieldSeq,maxRows.
  VAR CHAR    cFieldList,cFileList,cFindExpr,cHeader.
  VAR HANDLE  httSampleImport,httDataImport.
  VAR LOGICAL bFieldSepSet.

  DEF STREAM strImport.

  DEF TEMP-TABLE ttDataSample NO-UNDO
      FIELD cLine   AS CHAR FORMAT "x(318)"
      .
  DEF TEMP-TABLE ttSchema NO-UNDO
      FIELD TableName    AS CHAR FORMAT "x(32)"
      FIELD FieldName    AS CHAR FORMAT "x(32)"
      FIELD DataType     AS CHAR FORMAT "x(15)"
      FIELD FormatString AS CHAR FORMAT "x(20)"
      FIELD bIndexed     AS LOG  LABEL "Indexed"
      FIELD bUnique      AS LOG  LABEL "Unique"
      FIELD iLength      AS INT  LABEL "Length"
      FIELD iSeq         AS INT  LABEL "Seq"
      FIELD hImportField AS HANDLE LABEL "Field handle"
      INDEX idxSeq iSeq      
      .
      
  DEF TEMP-TABLE ttErrorlog
      FIELD fileName     AS CHAR
      FIELD LineNum      AS INT
      FIELD ErrorMessage AS CHAR
      .   
          
  DEF PUBLIC PROPERTY TableName       AS CHARACTER NO-UNDO GET. 
      SET (INPUT icTableName AS CHAR):
        IF icTableName NE "" THEN
          FOR EACH ttSchema:
            ttSchema.TableName = SUBSTR(icTableName,1,32).
          END.  
        TableName = icTableName.  
      END SET. 
  DEF PUBLIC PROPERTY FieldSeparator  AS CHARACTER NO-UNDO GET. 
      SET (icSeparator AS CHAR):
        ASSIGN FieldSeparator = icSeparator
               bFieldSepSet = YES.
      END SET.  
  DEF PUBLIC PROPERTY httSchema             AS HANDLE NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY hBuffDataSample       AS HANDLE NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY hTempTable            AS HANDLE NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY StatusMessage         AS CHAR   NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY fileCodePage          AS CHAR   NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY maxImportRows         AS INT    NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY maxSampleRows         AS INT    NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY importFilterFields    AS CHAR   NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY importFilterOperators AS CHAR   NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY importFilterValues    AS CHAR   NO-UNDO GET. SET.
  
  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  CONSTRUCTOR PUBLIC JBoxFileParser (  ):
    SUPER ().
    FieldSeparator = ";".
    bFieldSepSet = NO.
    httSchema = BUFFER ttSchema:HANDLE:TABLE-HANDLE.
    hBuffDataSample = BUFFER ttDataSample:HANDLE.
    maxSampleRows = 500.
    fileCodePage = "utf-8".
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

    /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID createResultTable( INPUT icFieldList AS CHAR
                                          ,INPUT icIndexFldList AS CHAR ):

    VAR INTEGER ix.
    VAR CHARACTER useFieldList.
    VAR CHARACTER useDataTypeList.
      
    DELETE OBJECT hTempTable NO-ERROR.
    
    cFindExpr = "".    
    
    CREATE TEMP-TABLE hTempTable.
    
    IF icFieldList = "" OR icFieldList = "*" THEN useFieldList = "*".
    ELSE DO ix = 1 TO NUM-ENTRIES(icFieldList):
      ASSIGN useFieldList = useFieldList + (IF useFieldList NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(ix,icFieldList),";")
             useDataTypeList = useDataTypeList + (IF useDataTypeList NE "" THEN "," ELSE "") + ENTRY(2,ENTRY(ix,icFieldList),";")
             .
    END.  
    
    DO ix = 1 TO httSampleImport:DEFAULT-BUFFER-HANDLE:NUM-FIELDS:
      IF CAN-DO(useFieldList,httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME) THEN DO:
        IF useFieldList = "*" THEN
          hTempTable:ADD-LIKE-FIELD(httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME,httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix)).
        ELSE IF ENTRY(LOOKUP(httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME,useFieldList),useDataTypeList) = httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):DATA-TYPE THEN 
          hTempTable:ADD-NEW-FIELD(httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME,
                                   ENTRY(LOOKUP(httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME,useFieldList),useDataTypeList),
                                   0,
                                   httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):FORMAT).
        ELSE
          hTempTable:ADD-NEW-FIELD(httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME,
                                   ENTRY(LOOKUP(httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME,useFieldList),useDataTypeList)).
      END.  
    END.    
    DO ix = 1 TO NUM-ENTRIES(icIndexFldList):
      hTempTable:ADD-NEW-INDEX ("idx" + ENTRY(ix,icIndexFldList)).
      hTempTable:ADD-INDEX-FIELD ("idx" + ENTRY(ix,icIndexFldList),ENTRY(ix,icIndexFldList)).
    END.      

    hTempTable:TEMP-TABLE-PREPARE (TableName).

    DO ix = 1 TO hTempTable:DEFAULT-BUFFER-HANDLE:NUM-FIELDS:
      FIND FIRST ttSchema
           WHERE ttSchema.FieldName = hTempTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME
           NO-ERROR.
      IF AVAIL ttSchema THEN DO:
        ASSIGN ttSchema.DataType = hTempTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):DATA-TYPE
               ttSchema.FormatString = hTempTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):FORMAT
               .
        
        IF CAN-DO(importFilterFields,ttSchema.FieldName) THEN
          cFindExpr = cFindExpr + " " + ttSchema.FieldName + " "
                    + ENTRY(LOOKUP(ttSchema.FieldName,importFilterFields),importFilterOperators) + " "
                    + (IF hTempTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):DATA-TYPE NE "CHARACTER" THEN
                         hTempTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):DATA-TYPE + "('"
                       ELSE "'")
                    + ENTRY(LOOKUP(ttSchema.FieldName,importFilterFields),importFilterValues,"|")   
                    + (IF hTempTable:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):DATA-TYPE NE "CHARACTER" THEN
                         "')"
                       ELSE "'")
                    + " AND".
      END.  
      ELSE ttSchema.iSeq = -1.
    END.
    cFindExpr = RIGHT-TRIM(cFindExpr,"AND").
    
    CREATE TEMP-TABLE httDataImport.
    DO ix = 1 TO httSampleImport:DEFAULT-BUFFER-HANDLE:NUM-FIELDS:
      FIND FIRST ttSchema
           WHERE ttSchema.FieldName = httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(ix):NAME.
      httDataImport:ADD-NEW-FIELD(ttSchema.FieldName,ttSchema.DataType,0,ttSchema.FormatString).
    END.
    httDataImport:TEMP-TABLE-PREPARE ("ttDataImport").        
    
    FOR EACH ttSchema WHERE ttSchema.iSeq = -1: DELETE ttSchema. END.                                 

    // (Re-)create in cache
    hTempTable = JBoxSchemaCache:Instance:addTempTableToSchema(?,hTempTable,"tempdata","temp-table",YES,icIndexFldList).
    
    CATCH eErr AS Progress.Lang.Error :
      StatusMessage = PROGRAM-NAME(1) + " " + eErr:GetMessage(1).
      MESSAGE StatusMessage
      VIEW-AS ALERT-BOX.  
    END CATCH.
        
  END METHOD.

METHOD PROTECTED LOGICAL appendFile( INPUT icFileName AS CHAR
                                    ,INPUT ibSample   AS LOG ):
    
    DEF VAR bFound        AS LOG  NO-UNDO.
    DEF VAR cValue        AS CHAR NO-UNDO.
    DEF VAR bRow          AS LOG  NO-UNDO.
    DEF VAR cExceptList   AS CHAR NO-UNDO.
    DEF VAR ix            AS INT  NO-UNDO.
    DEF VAR hImportBuffer AS HANDLE NO-UNDO.
    DEF VAR hResultBuffer AS HANDLE NO-UNDO.
    DEF VAR iLineNum      AS INT    NO-UNDO INIT 1.
        
    ASSIGN hImportBuffer = IF ibSample THEN httSampleImport:DEFAULT-BUFFER-HANDLE ELSE httDataImport:DEFAULT-BUFFER-HANDLE
           hResultBuffer = hTempTable:DEFAULT-BUFFER-HANDLE. 

    hImportBuffer:BUFFER-CREATE ().
    
    INPUT FROM VALUE(icFileName) CONVERT SOURCE fileCodePage TARGET SESSION:CPINTERNAL.
    SET ^.
    REPEAT ON ERROR UNDO, NEXT:
      iLineNum = iLineNum + 1.
      hImportBuffer:BUFFER-IMPORT (?,FieldSeparator) NO-ERROR.
      IF ibSample AND ERROR-STATUS:GET-NUMBER(1) = 76 THEN do:
        MESSAGE ix skip iLineNum ERROR-STATUS:GET-MESSAGE(1) skip FieldSeparator
        VIEW-AS ALERT-BOX.
        logThis(icFileName,ix,ERROR-STATUS:GET-MESSAGE(1)). 
      end.  
      hImportBuffer:BUFFER-RELEASE ().
      hImportBuffer:FIND-FIRST("").
      
      bFound = YES.
      IF cFindExpr NE "" THEN 
        bFound = hImportBuffer:FIND-FIRST("WHERE" + cFindExpr) NO-ERROR.
      IF NOT bFound THEN DO:
        hImportBuffer:FIND-FIRST("").
        NEXT.
      END.    

      ASSIGN bRow = NO
             ix = ix + 1.

      IF maxRows > 0 AND ix > maxRows THEN LEAVE.
             
      FOR EACH ttSchema:
        cValue = STRING(ttSchema.hImportField:BUFFER-VALUE).
               
        IF NOT bRow THEN DO:
          IF ttSchema.DataType BEGINS "date" THEN 
            bRow = cValue NE ? AND cValue NE "".
          ELSE IF (ttSchema.DataType = "decimal" OR ttSchema.DataType BEGINS "int") THEN
            bRow = DECIMAL(cValue) NE 0.
          ELSE IF cValue NE "" AND cValue NE ? THEN
            bRow = YES.  
        END.    
      END.  
      IF NOT bRow THEN NEXT.
        
      hResultBuffer:BUFFER-CREATE ().
      hResultBuffer:BUFFER-COPY (hImportBuffer).
    END.  
    INPUT CLOSE.

    CATCH eErr AS Progress.Lang.Error :
      StatusMessage = PROGRAM-NAME(1) + " " + eErr:GetMessage(1).        
      MESSAGE StatusMessage
      VIEW-AS ALERT-BOX.
    END CATCH.
    
    FINALLY:
      maxRows = 0.
      RETURN StatusMessage = "".
    END FINALLY.
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID createFileSchema ( INPUT icFileName  AS CHAR):

    DEF VAR ix            AS INT  NO-UNDO.
    
    statusMessage = "".    
    
    IF SEARCH(icFileName) = ? THEN DO:
      StatusMessage = "Invalid filename".
      RETURN.
    END.  
        
    IF TableName = "" THEN
      ASSIGN TableName = RIGHT-TRIM(REPLACE(ENTRY(1,ENTRY(NUM-ENTRIES(icFileName,"\/"),icFileName,"\/"),".")," ",""),"_")
             TableName = validOEname(TableName).
        
    EMPTY TEMP-TABLE ttDataSample.
    EMPTY TEMP-TABLE ttSchema.
    ASSIGN iNameSeq = 0
           iVoidSeq = 0
           ifieldSeq = 0
           cFieldList = "".
    
    INPUT STREAM strImport FROM VALUE(icFileName) CONVERT SOURCE fileCodePage TARGET SESSION:CPINTERNAL.
    REPEAT:
      ix = ix + 1.
      IF ix = 1 THEN DO:
        IMPORT STREAM strImport UNFORMATTED cHeader.
        IF NOT headerIsHeader() THEN DO:
          CREATE ttDataSample.
          ttDataSample.cLine = cHeader.
        END.  
      END.  
      ELSE DO:
        CREATE ttDataSample.
        IMPORT STREAM strImport UNFORMATTED ttDataSample.cLine.   
      END.  
      IF ix > 100 THEN LEAVE.
    END.  
    INPUT STREAM strImport CLOSE.
    FOR EACH ttDataSample:
      IF NUM-ENTRIES(ttDataSample.cLine,FieldSeparator) < NUM-ENTRIES(cHeader,FieldSeparator) THEN DELETE ttDataSample.
    END.    
 
    DO ix = 1 TO NUM-ENTRIES(cHeader,FieldSeparator):
      CREATE ttSchema.
      ASSIGN ttSchema.TableName = TableName
             ttSchema.FieldName = validOEname(ENTRY(ix,cHeader,FieldSeparator))
             ttSchema.iSeq       = ix
             .
    END.
    FOR EACH ttSchema
        BY ttSchema.iSeq DESC:
      IF NOT ttSchema.FieldName BEGINS "void_" THEN
        LEAVE.
      ELSE DELETE ttSchema.
    END.        
        
    setDataTypes().
        
        
    CATCH eErr AS Progress.Lang.Error :
      StatusMessage = PROGRAM-NAME(1) + " " + eErr:getMessage(1).  
      MESSAGE StatusMessage 
      VIEW-AS ALERT-BOX.
    END CATCH.    

  END METHOD.
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID createImportTable():
    
    IF VALID-OBJECT(hTempTable) THEN DELETE OBJECT hTempTable.
    IF VALID-OBJECT(httSampleImport)  THEN DELETE OBJECT httSampleImport.
    
    DEF VAR iFieldCnt AS INT NO-UNDO.
    
    statusMessage = "".
    
    CREATE TEMP-TABLE hTempTable.
    FOR EACH ttSchema
        BY ttSchema.iSeq:
      IF ttSchema.DataType = "" THEN DO:
        StatusMessage = "Error assigning datatype for " + ttSchema.FieldName + " (column: " + STRING(ttSchema.iSeq) + ")".
        RETURN.
      END.      
      IF ttSchema.DataType BEGINS "datet" THEN
        hTempTable:ADD-NEW-FIELD (ttSchema.FieldName,ttSchema.DataType).
      ELSE  
        hTempTable:ADD-NEW-FIELD (ttSchema.FieldName,ttSchema.DataType,0,ttSchema.FormatString).
      IF ttSchema.bUnique THEN DO:
        hTempTable:ADD-NEW-INDEX ("idx" + ttSchema.FieldName,YES).
        hTempTable:ADD-INDEX-FIELD ("idx" + ttSchema.FieldName,ttSchema.FieldName).
      END.
      ELSE IF ttSchema.bIndexed THEN DO:
        hTempTable:ADD-NEW-INDEX ("idx" + ttSchema.FieldName).
        hTempTable:ADD-INDEX-FIELD ("idx" + ttSchema.FieldName,ttSchema.FieldName).
      END.  
      iFieldCnt = iFieldCnt + 1.
    END.
          
    hTempTable:TEMP-TABLE-PREPARE (TableName).
    
    CREATE TEMP-TABLE httSampleImport.
    httSampleImport:CREATE-LIKE (hTempTable).
    httSampleImport:TEMP-TABLE-PREPARE ("ttSampleImport").      

    DO iFieldCnt = 1 TO httSampleImport:DEFAULT-BUFFER-HANDLE:NUM-FIELDS:
      FIND FIRST ttSchema
           WHERE ttSchema.FieldName = httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(iFieldCnt):NAME
           NO-ERROR.
      IF AVAIL ttSchema THEN 
        ttSchema.hImportField = httSampleImport:DEFAULT-BUFFER-HANDLE:BUFFER-FIELD(iFieldCnt).
    END.

    CATCH eErr AS Progress.Lang.Error :
      StatusMessage = PROGRAM-NAME(1) + " " + eErr:getMessage(1).  
      MESSAGE StatusMessage
      VIEW-AS ALERT-BOX.
    END CATCH.    

/*    FINALLY:                    */
/*      RETURN StatusMessage = "".*/
/*    END.                        */

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getErrorLog(  ):
    
    VAR CHAR ocError.
    VAR INT ix.

    FOR EACH ttErrorlog:
      ocError = ocError + CHR(10)
              + (IF NUM-ENTRIES(cFileList) > 1 THEN "File: " + ttErrorlog.fileName + " " ELSE "") 
              + "Line: " + STRING(ttErrorlog.LineNum) + " Error: " + ttErrorlog.ErrorMessage.
      ix = ix + 1.
      IF ix > 100 THEN LEAVE.        
    END.
    
    IF ocError NE "" THEN
      ocError = "Field mapping errors" + ocError.

    RETURN ocError.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED LOGICAL headerIsHeader():
    VAR INT ix. 
    VAR CHARACTER cColValue.
    VAR DATE dDate.
    VAR DATETIME-TZ dtDateTimeTz.
    VAR DATETIME dtDateTime.
    
    IF NOT bFieldSepSet THEN
      ASSIGN FieldSeparator = IF INDEX(cHeader,"|") > 0 THEN "|" 
                              ELSE IF INDEX(cHeader,";") > 0 THEN ";"
                              ELSE IF INDEX(cHeader,"~t") > 0 THEN "~t"
                              ELSE IF INDEX(cHeader,"¤") > 0 THEN "¤"
                              ELSE IF INDEX(cHeader,"^") > 0 THEN "^"
                              ELSE ","
             bFieldSepSet   = NO
             cHeader        = TRIM(cHeader,FieldSeparator)
             .
    DO ix = 1 TO NUM-ENTRIES(cHeader,FieldSeparator):
      cColValue = ENTRY(ix,cHeader,FieldSeparator).
      IF convertDecimal(cColValue) THEN RETURN NO.
      IF NUM-ENTRIES(cColValue,"/") > 2 OR NUM-ENTRIES(cColValue,".") > 2 THEN DO: 
        dDate = DATE(cColValue) NO-ERROR.
        
        IF NOT ERROR-STATUS:ERROR THEN RETURN NO.
        ELSE DO:
          dtDateTimeTz = DATETIME-TZ(cColValue) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN  RETURN NO.
          ELSE DO:
            dtDateTime = DATETIME(cColValue) NO-ERROR.
            IF NOT ERROR-STATUS:ERROR THEN  RETURN NO.
          END.
        END.
      END.      
    END.  

    RETURN YES.

  END METHOD.

  // Import file(list) in one operation
  METHOD PUBLIC LOGICAL importFileList ( INPUT icFileList  AS CHAR):
    VAR INTEGER ix.    

    ASSIGN statusMessage = ""
           cFileList = icFileList.  
    
    EMPTY TEMP-TABLE ttErrorlog.

    createFileSchema(ENTRY(1,icFileList)).
    IF StatusMessage NE "" THEN RETURN NO.
    createImportTable().
    IF StatusMessage NE "" THEN RETURN NO.
    
    DO ix = 1 TO NUM-ENTRIES(icFileList):
      IF NOT appendFile(ENTRY(ix,icFileList),NO) THEN RETURN NO.
    END.
    
    RETURN YES.
  END.  

  // Create a sample of data (for field selection) 
  METHOD PUBLIC LOGICAL getSample ( INPUT icFileName  AS CHAR):
        
    createFileSchema(icFileName).
    IF StatusMessage NE "" THEN RETURN NO.
    createImportTable().
    IF StatusMessage NE "" THEN RETURN NO.
    
    maxRows = maxSampleRows.
    
    importFilterFields = "".
    cFindExpr = "".
    
    IF NOT appendFile(icFileName,YES) THEN RETURN NO.

    RETURN YES.
    
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE PROGRAM-NAME(1) eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END.  

  // Create a sample of data (for field selection) 
  METHOD PUBLIC LOGICAL getAll ( INPUT icFileList  AS CHAR
                                ,INPUT icFieldList AS CHAR
                                ,INPUT icIndexFldList AS CHAR
                                ):

    VAR INTEGER ix.    

    ASSIGN statusMessage = ""
           cFileList = icFileList.  
    
    EMPTY TEMP-TABLE ttErrorlog.
        
    createResultTable(icFieldList,icIndexFldList).

    maxRows = maxImportRows.
    DO ix = 1 TO NUM-ENTRIES(icFileList):
      IF NOT appendFile(ENTRY(ix,icFileList),NO) THEN RETURN NO.
    END.
    
    RETURN YES.
  END.  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED VOID logThis(INPUT icFileName AS CHAR, INPUT iiLineNum AS INT, INPUT icErrorMessage AS CHAR):
    
    CREATE ttErrorlog.
    ASSIGN ttErrorlog.fileName = icFileName
           ttErrorlog.LineNum = iiLineNum
           ttErrorlog.ErrorMessage = icErrorMessage
           .
    RETURN.

  END METHOD.

  METHOD PROTECTED VOID setDataTypes():
    DEF VAR dDate        AS DATE NO-UNDO.
    DEF VAR dtDateTime   AS DATETIME NO-UNDO.
    DEF VAR dtDateTimeTz AS DATETIME-TZ NO-UNDO.
    DEF VAR iInt         AS INT  NO-UNDO.
    DEF VAR iInt64       AS INT64  NO-UNDO.
    DEF VAR fDec         AS DECIMAL NO-UNDO.
    DEF VAR bLog         AS LOG NO-UNDO.
    DEF VAR cColValue    AS CHAR NO-UNDO.
    
    FOR EACH ttSchema:
      CheckValues:
      FOR EACH ttDataSample:
        cColValue = ENTRY(ttSchema.iSeq,ttDataSample.cLine,FieldSeparator).
        
        IF ttSchema.DataType NE "CHARACTER" AND cColValue NE ? AND cColValue NE "" THEN DO:
          IF NUM-ENTRIES(cColValue,"/") > 2 OR NUM-ENTRIES(cColValue,".") > 2 THEN DO: 
            dDate = DATE(cColValue) NO-ERROR.
            
            IF NOT ERROR-STATUS:ERROR THEN ttSchema.DataType = "DATE".
            ELSE DO:
              dtDateTimeTz = DATETIME-TZ(cColValue) NO-ERROR.
              IF NOT ERROR-STATUS:ERROR THEN ttSchema.DataType = "DATETIME-TZ".
              ELSE DO:
                dtDateTime = DATETIME(cColValue) NO-ERROR.
                IF NOT ERROR-STATUS:ERROR THEN ttSchema.DataType = "DATETIME".
                ELSE DO:
                  ttSchema.DataType = "CHARACTER".
                  ttSchema.iLength = MAX(ttSchema.iLength,LENGTH(cColValue)).
                END.  
              END.
            END.
          END.      
          ELSE DO:
            IF convertDecimal(cColValue) THEN ttSchema.DataType = "DECIMAL".
            ELSE DO:
              iInt = INTEGER(cColValue) NO-ERROR.
              IF NOT ERROR-STATUS:ERROR THEN ttSchema.DataType = "INTEGER".
              ELSE DO:
                iInt64 = INT64(cColValue) NO-ERROR.
                IF NOT ERROR-STATUS:ERROR THEN ttSchema.DataType = "INT64".
                ELSE DO:
                  bLog = LOGICAL(cColValue) NO-ERROR.
                  IF NOT ERROR-STATUS:ERROR THEN ttSchema.DataType = "LOGICAL".
                  ELSE DO:
                    ttSchema.DataType = "CHARACTER".
                    ttSchema.iLength = MAX(ttSchema.iLength,LENGTH(cColValue)).
                  END.  
                END.  
              END.  
            END.  
          END.  
        END.
        ELSE DO:
          ttSchema.DataType = "CHARACTER".
          ttSchema.iLength = MAX(ttSchema.iLength,LENGTH(cColValue)).
        END.  
      END.
    END.  
    FOR EACH ttSchema:
      IF ttSchema.DataType = "CHARACTER" THEN
        ttSchema.FormatString = "X(" + STRING(MAX(8,ttSchema.iLength + 5)) + ")".
      ELSE IF ttSchema.DataType = "DATE" THEN
        ttSchema.FormatString = "99.99.9999".  
      ELSE IF ttSchema.DataType = "DECIMAL" THEN
        ttSchema.FormatString = "->>>,>>>,>>9.99".  
      ELSE IF ttSchema.DataType = "INTEGER" THEN
        ttSchema.FormatString = "->>>>>>>>>9".  
      ELSE IF ttSchema.DataType = "INT64" THEN
        ttSchema.FormatString = "->>>>>>>>>>>>>>>>>>9".  
    END.
/*    def var hbttSchema as handle no-undo.*/
/*    hbttSchema = buffer ttSchema:handle. */
/*    run toExcelViaFile.p (hbttSchema,0). */
    
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE PROGRAM-NAME(1) eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
      StatusMessage = eErr:GetMessage(1).
    END CATCH.
  END.  
  
  METHOD PROTECTED LOGICAL convertDecimal(INPUT icDecimal AS CHARACTER):
    
    DEFINE VARIABLE result AS DECIMAL NO-UNDO.
    DEF VAR cOldFormat    AS CHAR NO-UNDO.
    DEF VAR cConvMessage  AS CHAR NO-UNDO.

    cOldFormat = SESSION:NUMERIC-FORMAT.
        
    IF INDEX(icDecimal,".") > INDEX(icDecimal,",") AND SESSION:NUMERIC-DECIMAL-POINT = "," THEN DO:
      SESSION:NUMERIC-FORMAT = "American".
      result = DECIMAL(icDecimal).
    END.
    ELSE IF INDEX(icDecimal,",") > INDEX(icDecimal,".") AND SESSION:NUMERIC-DECIMAL-POINT = "." THEN DO:
      SESSION:NUMERIC-FORMAT = "European".
      result = DECIMAL(icDecimal).
    END.
    ELSE cConvMessage = "integer".

    CATCH eErr AS Progress.Lang.Error :
      cConvMessage = eErr:GetMessage(1).  
    END CATCH.

    FINALLY:
      SESSION:NUMERIC-FORMAT = cOldFormat.
      RETURN cConvMessage = "".
    END.  

  END METHOD.
  
  METHOD PROTECTED CHARACTER validOEname(INPUT icFieldName AS CHAR):
    DEF VAR cValidName AS CHAR NO-UNDO.
    DEF VAR Char1      AS INT  NO-UNDO.
    DEF VAR ix         AS INT  NO-UNDO.
        
    cValidName = TRIM(icFieldName,'"').
    
    REPEAT WHILE INDEX(cValidName,"  ") > 0:
      cValidName = REPLACE(cValidName,"  "," ").
    END.
    cValidName = REPLACE(cValidName," ","_").  

    IF cValidName = "/" THEN cValidName = "r".
    ELSE IF cValidName BEGINS "/" THEN cValidName = TRIM(cValidName,"/").
      
    
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

    IF KEYWORD(cValidName) NE ? THEN 
      cValidName = cValidName + "_".
      
    IF LENGTH(cValidName) > 32 THEN 
      ASSIGN iNameSeq = iNameSeq + 1
             iNameSeq = MIN(99,iNameSeq) 
             cValidName = SUBSTR(cValidName,1,30) + STRING(iNameSeq,"99") 
             .
    IF cValidName = "" THEN
      ASSIGN iVoidSeq = iVoidSeq + 1 
             cValidName = "Void_" + STRING(iVoidSeq)
             .         
    IF CAN-DO(cFieldList,cValidName) THEN
      ASSIGN ifieldSeq = iFieldSeq + 1
             cValidName = cValidName + STRING(ifieldSeq).         
    cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + cValidName.          
             
    RETURN cValidName.

  END METHOD.

	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
	DESTRUCTOR PUBLIC JBoxFileParser ( ):
    IF VALID-OBJECT(hTempTable) THEN DELETE OBJECT hTempTable.
    IF VALID-OBJECT(httSampleImport)  THEN DELETE OBJECT httSampleImport.
    IF VALID-OBJECT(httDataImport)  THEN DELETE OBJECT httDataImport.
	END DESTRUCTOR.
  
END CLASS.