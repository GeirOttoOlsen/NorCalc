 
 /*------------------------------------------------------------------------
    File        : JBoxDataSourceConnector
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Thu Dec 01 16:31:11 CET 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.JBoxDataSourceConnector: 

  DEF PUBLIC PROPERTY OdbcConnector     AS oo.JBoxOdbcConnector NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY oOdbcSql          AS oo.JBoxOdbcSql NO-UNDO GET. PROTECTED SET.

  DEF PUBLIC PROPERTY SqlExpConnector   AS oo.JBoxProgressSqlConnector NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY oSqlExp           AS oo.JBoxProgressSql NO-UNDO GET. PROTECTED SET.

  DEF PUBLIC PROPERTY MsSqlConnector    AS oo.JBoxMsSqlConnector NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY oMsSql            AS oo.JBoxMsSql NO-UNDO GET. PROTECTED SET.

  DEF PUBLIC PROPERTY sourceType        AS CHAR NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY sourceDb          AS CHAR NO-UNDO GET. SET.
  
  DEF PUBLIC PROPERTY sourceConnected   AS LOG NO-UNDO GET. SET.

  DEF PUBLIC PROPERTY connectorMessage  AS CHAR NO-UNDO GET. SET.
  
  DEF PUBLIC PROPERTY readCount         AS INT NO-UNDO GET. SET.
  DEF PUBLIC PROPERTY elapseMsec        AS INT NO-UNDO GET. PROTECTED SET.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  CONSTRUCTOR PUBLIC JBoxDataSourceConnector ():
    SUPER ().
  END CONSTRUCTOR.

  METHOD PUBLIC LOGICAL fillTempTable( INPUT icParam       AS CHAR
                                      ,INPUT icSessionId   AS CHAR
                                      ,INPUT ihBufferOrDs  AS HANDLE):

    DEF VAR cCalcFieldProcs  AS CHAR NO-UNDO.
    DEF VAR cSqlCalcFlds     AS CHAR NO-UNDO.
    DEF VAR cCalcFieldFilter AS CHAR NO-UNDO.
    DEF VAR cStatFields      AS CHAR NO-UNDO.
    DEF VAR iiBatchSize      AS INT  NO-UNDO.
    DEF VAR iiStartRow       AS INT  NO-UNDO.
    DEF VAR cCalcSortFields  AS CHAR NO-UNDO.
    DEF VAR cViewDef         AS CHAR NO-UNDO.
    DEF VAR cQueryWhere      AS CHAR NO-UNDO.
    DEF VAR cFillOEfieldList AS CHAR NO-UNDO.
    DEF VAR obOk             AS LOG  NO-UNDO.

    connectorMessage = "".
    IF NUM-ENTRIES(icParam,"|") < 2 THEN DO:
      connectorMessage = "Invalid parameter for query: " + icParam + " (incomplete)".
      RETURN NO.
    END.  

    CASE sourceType:
      WHEN "MsSql" THEN DO:
        oMsSql = NEW oo.JBoxMsSql().
        IF ENTRY(2,icParam,"|") = "getOverriddenDbName" THEN DO:
          obOK = ?.
          RETURN YES.
        END.  
        cViewDef = oMsSql:getViewDefinition(ENTRY(2,icParam,"|")).
        oMsSql:setConnection(MsSqlConnector:MsSqlConn).
      END.
      WHEN "sqlexp" THEN DO:
        oSqlExp = NEW oo.JBoxProgressSql().
        cViewDef = oSqlExp:getViewDefinition(ENTRY(2,icParam,"|")).
        oSqlExp:setConnection(SqlExpConnector).
      END.
      OTHERWISE DO:
        oOdbcSql = NEW oo.JBoxOdbcSql().
        cViewDef = oOdbcSql:getViewDefinition(ENTRY(2,icParam,"|")).
        oOdbcSql:setConnection(OdbcConnector:ProgressODBC).
      END.
    END.    
    /* If no view is referenced the view is defined by the query: */
    IF cViewDef = ? OR cViewDef = "" THEN
      cViewDef = ENTRY(2,icParam,"|").
    
    IF NUM-ENTRIES(icParam,"|") > 2 THEN 
      cQueryWhere = ENTRY(3,icParam,"|").
    
    IF NUM-ENTRIES(icParam,"|") > 3 AND ENTRY(4,icParam,"|") NE "" THEN
      cFillOEfieldList = ENTRY(4,icParam,"|"). 
        
    IF NUM-ENTRIES(icParam,"|") > 4 AND NUM-ENTRIES(ENTRY(5,icParam,"|"),CHR(1)) > 1 THEN DO: 
      ASSIGN cCalcFieldProcs  = ENTRY(1,ENTRY(5,icParam,"|"),CHR(1))
             cSqlCalcFlds     = ENTRY(2,ENTRY(5,icParam,"|"),CHR(1))
             cCalcFieldFilter = ENTRY(3,ENTRY(5,icParam,"|"),CHR(1))
             cStatFields      = ENTRY(4,ENTRY(5,icParam,"|"),CHR(1))
             iiBatchSize      = INT(ENTRY(5,ENTRY(5,icParam,"|"),CHR(1)))
             iiStartRow       = INT(ENTRY(6,ENTRY(5,icParam,"|"),CHR(1)))
             cCalcSortFields  = ENTRY(7,ENTRY(5,icParam,"|"),CHR(1))
             .

      CASE sourceType:
        WHEN "MsSql" THEN DO:
          ASSIGN oMsSql:cCalcFieldProcs  = cCalcFieldProcs
                 oMsSql:cSqlCalcFlds     = cSqlCalcFlds
                 oMsSql:cCalcFieldFilter = cCalcFieldFilter
                 oMsSql:cStatFields      = cStatFields
                 oMsSql:iiBatchSize      = iiBatchSize
                 oMsSql:iiStartRow       = iiStartRow
                 oMsSql:cCalcSortFields  = cCalcSortFields 
                 .
          oMsSql:fillTempTable(TRIM(cViewDef + " " + cQueryWhere)
                                   ,ihBufferOrDs:GET-BUFFER-HANDLE(1)
                                   ,cFillOEfieldList
                                   ,ihBufferOrDs:GET-BUFFER-HANDLE(2) /* ttSpecFields */
                                   ,ihBufferOrDs:GET-BUFFER-HANDLE(3) /* ttRowSpecVal */
                                   ).
        END.
        WHEN "sqlexp" THEN DO:
          ASSIGN oSqlExp:cCalcFieldProcs  = cCalcFieldProcs
                 oSqlExp:cSqlCalcFlds     = cSqlCalcFlds
                 oSqlExp:cCalcFieldFilter = cCalcFieldFilter
                 oSqlExp:cStatFields      = cStatFields
                 oSqlExp:iiBatchSize      = iiBatchSize
                 oSqlExp:iiStartRow       = iiStartRow
                 oSqlExp:cCalcSortFields  = cCalcSortFields 
                 .
          oSqlExp:fillTempTable(TRIM(cViewDef + " " + cQueryWhere)
                               ,ihBufferOrDs:GET-BUFFER-HANDLE(1)
                               ,cFillOEfieldList
                               ,ihBufferOrDs:GET-BUFFER-HANDLE(2) /* ttSpecFields */
                               ,ihBufferOrDs:GET-BUFFER-HANDLE(3) /* ttRowSpecVal */
                               ).
        END.            
        OTHERWISE DO:
          ASSIGN oOdbcSql:cCalcFieldProcs  = cCalcFieldProcs
                 oOdbcSql:cSqlCalcFlds     = cSqlCalcFlds
                 oOdbcSql:cCalcFieldFilter = cCalcFieldFilter
                 oOdbcSql:cStatFields      = cStatFields
                 oOdbcSql:iiBatchSize      = iiBatchSize
                 oOdbcSql:iiStartRow       = iiStartRow
                 oOdbcSql:cCalcSortFields  = cCalcSortFields 
                 .
          oOdbcSql:fillTempTable(TRIM(cViewDef + " " + cQueryWhere)
                                   ,ihBufferOrDs:GET-BUFFER-HANDLE(1)
                                   ,cFillOEfieldList
                                   ,ihBufferOrDs:GET-BUFFER-HANDLE(2) /* ttSpecFields */
                                   ,ihBufferOrDs:GET-BUFFER-HANDLE(3) /* ttRowSpecVal */
                                   ).
        END.
      END.
    END. 
    ELSE IF cFillOEfieldList NE "" THEN
      CASE sourceType:
        WHEN "MsSql" THEN DO:
          oMsSql:cSqlCalcFlds = IF NUM-ENTRIES(icParam,"|") > 4 THEN ENTRY(5,icParam,"|") ELSE "".
          oMsSql:SQLtimeout = IF NUM-ENTRIES(icParam,"|") > 5 THEN INT(ENTRY(6,icParam,"|")) ELSE 0.
          oMsSql:fillTempTable(TRIM(cViewDef + " " + cQueryWhere),ihBufferOrDs,ENTRY(4,icParam,"|")).
        END.    
        WHEN "sqlexp" THEN DO:
          oSqlExp:cSqlCalcFlds = IF NUM-ENTRIES(icParam,"|") > 4 THEN ENTRY(5,icParam,"|") ELSE "".
          oSqlExp:SQLtimeout = IF NUM-ENTRIES(icParam,"|") > 5 THEN INT(ENTRY(6,icParam,"|")) ELSE 0.
          oSqlExp:fillTempTable(cViewDef,cQueryWhere,ihBufferOrDs,cFillOEfieldList).
        END.            
        OTHERWISE DO: 
          oOdbcSql:cSqlCalcFlds = IF NUM-ENTRIES(icParam,"|") > 4 THEN ENTRY(5,icParam,"|") ELSE "".
          oOdbcSql:SQLtimeout = IF NUM-ENTRIES(icParam,"|") > 5 THEN INT(ENTRY(6,icParam,"|")) ELSE 0.
          oOdbcSql:fillTempTable(TRIM(cViewDef + " " + cQueryWhere),ihBufferOrDs,cFillOEfieldList). 
        END.              
      END CASE.   
    ELSE 
      CASE sourceType:
        WHEN "MsSql" THEN 
          oMsSql:fillTempTable(TRIM(cViewDef + " " + cQueryWhere),ihBufferOrDs).
        WHEN "sqlexp" THEN
          oSqlExp:fillTempTable(cViewDef,cQueryWhere,ihBufferOrDs).
//          ReadCount = callSqlExp(cViewDef,cQueryWhere,ihBufferOrDs).          
        OTHERWISE 
          oOdbcSql:fillTempTable(TRIM(cViewDef + " " + cQueryWhere),ihBufferOrDs).
      END CASE.

    CASE sourceType:
      WHEN "MsSql" THEN 
        ASSIGN ReadCount = oMsSql:ReadCount    
               connectorMessage = oMsSql:SQLerror
               elapseMsec = oMsSql:elapseMsec
               .
      WHEN "sqlexp" THEN 
        ASSIGN ReadCount = oSqlExp:ReadCount
               connectorMessage = oSqlExp:SQLerror
               elapseMsec = oSqlExp:elapseMsec
               .    
      OTHERWISE 
        ASSIGN ReadCount = oOdbcSql:ReadCount
               connectorMessage = oOdbcSql:SQLerror
               elapseMsec = oOdbcSql:elapseMsec
               .    
    END CASE.
         
    CATCH anyError AS Progress.Lang.Error :
      connectorMessage = "Error in fillTempTable: " + anyError:GetMessage(1).      
    END CATCH.
         
    FINALLY:      
      RETURN IF obOk = ? THEN obOk ELSE connectorMessage = "".
    END FINALLY.
  END METHOD.

  METHOD PUBLIC LOGICAL fillTempTable(INPUT icSQL    AS CHARACTER,INPUT ihBuffer AS HANDLE ):
    RETURN THIS-OBJECT:fillTempTable("|" + icSQL,"", ihBuffer).
  END METHOD.  

  METHOD PUBLIC LOGICAL callSQL(INPUT icSQL         AS CHARACTER
                               ,INPUT icSessionId   AS CHAR
                               ,INPUT ihBufferOrDs  AS HANDLE ):
    
    DEF VAR bOk AS LOG NO-UNDO.
                                 
    CASE sourceType:
      WHEN "MsSql" THEN DO:
        oMsSql = NEW oo.JBoxMsSql().
        oMsSql:setConnection(MsSqlConnector:MsSqlConn).
        bOk = oMsSql:CallSQL(icSQL,YES).
        IF NOT bOk THEN connectorMessage = oMsSql:SQLerror.
      END.
      WHEN "sqlexp" THEN DO:
        oSqlExp = NEW oo.JBoxProgressSql().
        oSqlExp:CallSql("SET TRANSACTION ISOLATION LEVEL READ COMMITTED",YES).
        bOk = oSqlExp:CallSQL(icSQL,YES).
        IF NOT bOk THEN connectorMessage = oSqlExp:SQLerror.
      END.
      OTHERWISE DO:
        oOdbcSql = NEW oo.JBoxOdbcSql().
        oOdbcSql:setConnection(OdbcConnector:ProgressODBC).
        IF sourceType = "ProgressSql" THEN
          oOdbcSql:CallSql("SET TRANSACTION ISOLATION LEVEL READ COMMITTED",YES).
        bOk = oOdbcSql:CallSQL(icSQL,YES).
        IF NOT bOk THEN connectorMessage = oOdbcSql:SQLerror.
      END.
      
    END CASE.  
    
    RETURN NO.
  END METHOD.  

  METHOD PUBLIC LOGICAL closeConnection():
      CASE sourceType:
        WHEN "ProgressSql" OR WHEN "MySql" THEN 
          oOdbcSql:closeConnection().
        WHEN "SqlExp" THEN 
          oSqlExp:closeConnection().
        WHEN "MsSql" THEN 
          oMsSql:closeConnection().
      END CASE.
  END METHOD.  

END CLASS.