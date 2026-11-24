 
 /*------------------------------------------------------------------------
    File        : JBoxOdbcSql
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Tue Nov 08 16:00:34 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING System.Data.Odbc.*.
USING System.Data.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.JBoxOdbcSql: 
    DEF VAR bCalcFieldFilter AS LOG NO-UNDO.
    DEF VAR cOldDateFormat   AS CHAR   NO-UNDO.
    
    DEF STREAM sLog.
    DEF STREAM lesIni.

    DEF PUBLIC PROPERTY sqlDriver   AS CHAR NO-UNDO INIT "Progress OpenEdge 12.2 Driver" GET. SET.
    DEF PUBLIC PROPERTY sqlHost     AS CHAR NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY sqlPort     AS CHAR NO-UNDO GET. SET.
  
 //   DEF PROTECTED PROPERTY sqlServer   AS CHAR NO-UNDO GET. SET.
    DEF PROTECTED PROPERTY sqlDatabase AS CHAR NO-UNDO GET. SET.        
    DEF PROTECTED PROPERTY sqlUserid   AS CHAR NO-UNDO GET. SET.
    DEF PROTECTED PROPERTY sqlPassword  AS CHAR NO-UNDO GET. SET.

    DEF PROTECTED PROPERTY Conn         AS System.Data.Odbc.OdbcConnection NO-UNDO GET. SET.
    DEF PROTECTED PROPERTY Cmd          AS System.Data.Odbc.OdbcCommand    NO-UNDO GET. SET.
    DEF PROTECTED PROPERTY bRead        AS LOG  NO-UNDO GET. SET.
    DEF PROTECTED PROPERTY SQLstatement AS CHAR NO-UNDO GET. SET.

    DEF PUBLIC PROPERTY Rdr             AS System.Data.Odbc.OdbcDataReader NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY ReadCount       AS INT NO-UNDO GET. PROTECTED SET. /* Used when filtering on calc.flds */
    DEF PUBLIC PROPERTY ReadLimit       AS INT NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY SQLerror        AS CHAR NO-UNDO GET. PROTECTED SET.
    DEF PUBLIC PROPERTY SQLtimeout      AS INT NO-UNDO GET. SET. 

    def public property debugging as log no-undo get. set.
    
    DEF PUBLIC PROPERTY weekdayList AS CHAR INIT "Søn,Man,Tir,Ons,Tor,Fre,Lør" GET. SET. 
    DEF PUBLIC PROPERTY cSessionId  AS CHAR NO-UNDO GET. SET. 
    DEF PUBLIC PROPERTY cCalcFieldFilter AS CHAR NO-UNDO GET. 
      SET (INPUT icCalcFieldFilter AS CHAR):
        bCalcFieldFilter = icCalcFieldFilter NE "" AND icCalcFieldFilter NE "¤=¤". 
        cCalcFieldFilter = icCalcFieldFilter.
      END SET.
    DEF PUBLIC PROPERTY cCalcFieldProcs AS CHAR NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY cSqlCalcFlds    AS CHAR NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY getRowCount     AS LOG  NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY cStatFields     AS CHAR NO-UNDO GET. 
        SET (INPUT icStatFields AS CHAR):
          getRowCount = icStatFields BEGINS "rowcount".
          cStatFields = icStatFields.
        END SET.
    DEF PUBLIC PROPERTY cLogFile        AS CHAR NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY bLogSkipRow     AS LOG  NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY iiBatchSize     AS INT  NO-UNDO GET. SET. /* Used when filtering on calc.flds */
    DEF PUBLIC PROPERTY iiStartRow      AS INT  NO-UNDO GET. SET. /* Used when filtering on calc.flds */
    DEF PUBLIC PROPERTY cCalcSortFields AS CHAR NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY elapseMsec      AS INT  NO-UNDO GET. PROTECTED SET. 
    DEF PUBLIC PROPERTY decimalFactor   AS INT  NO-UNDO INIT 100 GET. SET.
        
    DEF TEMP-TABLE ttSpecFlds  NO-UNDO
        FIELD iCallBufferNum           AS INT          /* The source buffer num in the query to feed the calc.proc */
        FIELD iFieldNum                AS INT          /* Seqnum within buffer */
        FIELD cFillField               AS CHAR         /* Name of calculated field */
        FIELD cFillFieldType           AS CHAR         /* Datatype for calculated field */
        FIELD hSourceField             AS HANDLE       /* Two purposes: Handle to parameter field for calculation or handle to distinct column */
        FIELD hSourceField2            AS HANDLE       /* Handle to additional parameter for jb_calc */
        FIELD hTargetBuff              AS HANDLE 
        FIELD hTargetQuery             AS HANDLE
        FIELD cTargetQuery             AS CHAR
        FIELD cCallProc                AS CHAR         /* Name of procedure for calculation */
        FIELD cCallProcParam           AS CHAR         /* String parameter to calc.procedure */
        FIELD bGrandTotal              AS LOG          /* If the calc.field is in the list of grand totals */
        FIELD bDistinct                AS LOG          
        FIELD bAccum                   AS LOG          
        FIELD b2phAcc                  AS LOG          /* Indicates if the calculated field should be invoked on the accumulated resultset */
        FIELD hCalcFieldProc           AS HANDLE       /* Handle to the calc proc if it is in a persistent procedure */
        FIELD cCalcSortField           AS CHAR         /* If the calc.field is member of the sort fields put it's name here as well (equals cFillField) */
        FIELD cFilterOperator          AS CHAR         /* If the field is part of the filter.. */
        FIELD cFilterValue             AS CHAR         /* If the field is part of the filter.. */
        FIELD iExtent                  AS INT          /* The extent for an array field */
        FIELD bCalcByPreScan           AS LOG          /* Indicates if the value was calculated by prescan */
        FIELD bDirectAssign            AS LOG
        FIELD hCompareFields           AS HANDLE EXTENT 12   /* For dynamic field comparison (max, min) */
        FIELD iCntCompareFields        AS INT                /* For dynamic field comparison (max, min) */
        FIELD fCalcConstant            AS DEC          /* Used when field2 in spec of simple calculation is a constant and not a field name */
        FIELD bMandatoryCalc           AS LOG          /* Always calc - force calculation of column for all rows */   
        FIELD cSourceTable             AS CHAR         /* For sql calc fields */
        INDEX idxCallBuffer  IS PRIMARY UNIQUE  iCallBufferNum iFieldNum
        INDEX idxCallBuffPrescan  iCallBufferNum bCalcByPreScan bMandatoryCalc iFieldNum  
        .

    DEF TEMP-TABLE ttRowSpecVal  NO-UNDO
        FIELD iCallBufferNum   AS INT          /* The source buffer num in the query to feed the calc.proc */
        FIELD cFillField       AS CHAR         /* Name of calculated field */
        FIELD hFillField       AS HANDLE       /* Handle to field in the output temp-table where the corresponding values from PreScan 
                                                  are moved in ProcessQuery */
        FIELD cCallProc        AS CHAR         /* Name of procedure for calculation (either in persistent or external procedure)
                                                  Used here to check if the value comes from a calc.field or the source buffer */
        FIELD hSourceField     AS HANDLE       /* Two purposes: Handle to parameter field for calculation or handle to distinct column */
        FIELD bAccum           AS LOG          /* Here for same reason as bDistinct (approx) */
        FIELD b2phAcc          AS LOG          /* Indicates if the calculated field should be invoked on the accumulated resultset */
        FIELD cCurrCallOutput  AS CHAR         /* Keeps the last output value from the calculated field when processing the query */
        FIELD fRowValue        AS DEC          /* Value for grand total field for current row */
        FIELD fGrandTotal      AS DEC          /* The accumulated value for GrandTotal fields */
        FIELD hPreScanField    AS HANDLE       /* Handle to corresponding field in the PreScan table when prescan or in output table when no prescan
                                                  (added for preformance reason) */
        FIELD bOnlyGrandTotal  AS LOG          /* Fields that ar just grand totals should not be stored in the PreScan table (accum values kept in ttSpecFlds) */
        FIELD bCalcByPreScan   AS LOG          /* Indicates if the value was calculated by prescan */
        INDEX idxCallBuffer IS UNIQUE PRIMARY iCallBufferNum cFillField
        INDEX idxCalcByPreScan bCalcByPreScan    
        .

  DEF TEMP-TABLE ttCalcContains
      FIELD cCalcValue AS CHAR
      INDEX idxCalcValue  AS WORD-INDEX cCalcValue
      .

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxOdbcSql ():
    SUPER ().
    SQLtimeout = 300.
    
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxOdbcSql (INPUT ipHost AS CHAR, INPUT ipPort AS CHAR, INPUT ipDatabase AS CHAR, INPUT ipBruker AS CHAR, INPUT ipPassord AS CHAR ):
    SUPER ().
    ASSIGN 
      sqlDriver   = "Progress OpenEdge " + PROVERSION + " Driver"
      sqlHost     = ipHost
      sqlPort     = ipPort
      sqlDatabase = ipDatabase
      sqlUserid   = ipBruker
      sqlPassword = ipPassord
      . 
    ConnectSql().  
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxOdbcSql (INPUT icDatabase AS CHAR ):
    
    DEF VAR ix AS INT NO-UNDO.
    SUPER ().

/*    sqlServer  = THIS-OBJECT:getSqlServer(icDatabase).*/
/*    IF sqlServer = "" THEN RETURN.                    */
                  
    ConnectSql().
                
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED LOGICAL AssignStringValue(  
         INPUT ihField       AS HANDLE
        ,INPUT icUpdateValue AS CHAR ) :

    DEF VAR bOk AS LOG NO-UNDO.
    IF NOT VALID-HANDLE(ihField) THEN DO:
      SQLerror = "Invalid field handle for string value assignment. String value: " + icUpdateValue.
      RETURN NO.
    END.
    CASE ihField:DATA-TYPE:
      WHEN "character" THEN
        ihField:BUFFER-VALUE = icUpdateValue NO-ERROR.
      WHEN "date" THEN
        ihField:BUFFER-VALUE = DATE(icUpdateValue) NO-ERROR.
      WHEN "datetime" THEN
        ihField:BUFFER-VALUE = (IF icUpdateValue = "NOW" THEN NOW ELSE DATETIME(icUpdateValue)) NO-ERROR.
      WHEN "datetime-tz" THEN
        ihField:BUFFER-VALUE = (IF icUpdateValue = "NOW" THEN NOW ELSE DATETIME-TZ(icUpdateValue)) NO-ERROR.
      WHEN "decimal" THEN
        ihField:BUFFER-VALUE = DEC(icUpdateValue) NO-ERROR.
      WHEN "integer" THEN
        ihField:BUFFER-VALUE = INT(icUpdateValue) NO-ERROR.
      WHEN "int64" THEN
        ihField:BUFFER-VALUE = INT64(icUpdateValue) NO-ERROR.
      WHEN "logical" THEN 
        ihField:BUFFER-VALUE = (IF icUpdateValue = "yes" OR icUpdateValue = "true" OR icUpdateValue = "1" THEN TRUE 
                                ELSE IF icUpdateValue = "?" THEN ?
                                ELSE FALSE)  NO-ERROR.

      OTHERWISE DO:
        SQLerror = "Invalid datatype for string assignment: " + ihField:DATA-TYPE.
        RETURN NO.
      END.
    END CASE.
    IF ERROR-STATUS:ERROR THEN DO:
      SQLerror = ERROR-STATUS:GET-MESSAGE(1).
      RETURN NO.
    END.     
    RETURN YES.
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL CalcValueOk(
                INPUT cCalcValue AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Check if value for calculated field passes filter crieria
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR bPass       AS LOG  NO-UNDO.
  DEF VAR ix          AS INT  NO-UNDO.
  DEF VAR cOperator   AS CHAR NO-UNDO.
  DEF VAR cCurrFilter AS CHAR NO-UNDO.
  
  IF NOT CAN-DO(cCalcFieldFilter,ttSpecFlds.cFillField) THEN RETURN TRUE.
  
  DO ix = 1 TO NUM-ENTRIES(ttSpecFlds.cFilterOperator):
    ASSIGN cOperator   = ENTRY(ix,ttSpecFlds.cFilterOperator)
           cCurrFilter = ENTRY(ix,ttSpecFlds.cFilterValue,"|").
  
    CASE ttSpecFlds.cFillFieldType:
      WHEN "CHARACTER" THEN
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN 
            bPass = cCalcValue = cCurrFilter.
          WHEN "<>" OR WHEN "NE" THEN 
            bPass = cCalcValue NE cCurrFilter.
          WHEN ">" OR WHEN "GT" THEN 
            bPass = cCalcValue GT cCurrFilter.
          WHEN "<" OR WHEN "LT" THEN
            bPass = cCalcValue LT cCurrFilter.
          WHEN ">=" OR WHEN "GE" THEN 
            bPass = cCalcValue GE cCurrFilter.
          WHEN "<=" OR WHEN "LE" THEN 
            bPass = cCalcValue LE cCurrFilter.
          WHEN "matches" THEN
            bPass = cCalcValue MATCHES cCurrFilter.
          WHEN "begins" THEN
            bPass = cCalcValue BEGINS cCurrFilter.
          WHEN "contains" THEN DO:
            CREATE ttCalcContains.
            ttCalcContains.cCalcValue = cCalcValue.
            FOR EACH ttCalcContains 
                WHERE ttCalcContains.cCalcValue CONTAINS cCurrFilter:
              bPass = YES.
            END.
            FOR EACH ttCalcContains: DELETE ttCalcContains. END.
          END.
        END CASE.
      WHEN "DATE" THEN 
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN 
            bPass = DATE(cCalcValue) = DATE(cCurrFilter).
          WHEN "<>" OR WHEN "NE" THEN 
            bPass = DATE(cCalcValue) NE DATE(cCurrFilter).
          WHEN ">" OR WHEN "GT" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATE(cCalcValue) GT DATE(cCurrFilter).
          WHEN "<" OR WHEN "LT" THEN
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATE(cCalcValue) LT DATE(cCurrFilter).
          WHEN ">=" OR WHEN "GE" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATE(cCalcValue) GE DATE(cCurrFilter).
          WHEN "<=" OR WHEN "LE" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATE(cCalcValue) LE DATE(cCurrFilter).
        END CASE.
      WHEN "DATETIME" THEN
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN 
            bPass = DATETIME(cCalcValue) = DATETIME(cCurrFilter).
          WHEN "<>" OR WHEN "NE" THEN 
            bPass = DATETIME(cCalcValue) NE DATETIME(cCurrFilter).
          WHEN ">" OR WHEN "GT" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME(cCalcValue) GT DATETIME(cCurrFilter).
          WHEN "<" OR WHEN "LT" THEN
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME(cCalcValue) LT DATETIME(cCurrFilter).
          WHEN ">=" OR WHEN "GE" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME(cCalcValue) GE DATETIME(cCurrFilter).
          WHEN "<=" OR WHEN "LE" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME(cCalcValue) LE DATETIME(cCurrFilter).
        END CASE.
      WHEN "DATETIME-TZ" THEN
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN 
            bPass = DATETIME-TZ(cCalcValue) = DATETIME-TZ(cCurrFilter).
          WHEN "<>" OR WHEN "NE" THEN 
            bPass = DATETIME-TZ(cCalcValue) NE DATETIME-TZ(cCurrFilter).
          WHEN ">" OR WHEN "GT" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME-TZ(cCalcValue) GT DATETIME-TZ(cCurrFilter).
          WHEN "<" OR WHEN "LT" THEN
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME-TZ(cCalcValue) LT DATETIME-TZ(cCurrFilter).
          WHEN ">=" OR WHEN "GE" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME-TZ(cCalcValue) GE DATETIME-TZ(cCurrFilter).
          WHEN "<=" OR WHEN "LE" THEN 
            bPass = cCalcValue NE "" AND cCalcValue NE ? AND DATETIME-TZ(cCalcValue) LE DATETIME-TZ(cCurrFilter).
        END CASE.
      WHEN "DECIMAL" THEN
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN 
            bPass = DECIMAL(cCalcValue) = DECIMAL(cCurrFilter).
          WHEN "<>" OR WHEN "NE" THEN 
            bPass = DECIMAL(cCalcValue) NE DECIMAL(cCurrFilter).
          WHEN ">" OR WHEN "GT" THEN 
            bPass = DECIMAL(cCalcValue) GT DECIMAL(cCurrFilter).
          WHEN "<" OR WHEN "LT" THEN
            bPass = DECIMAL(cCalcValue) LT DECIMAL(cCurrFilter).
          WHEN ">=" OR WHEN "GE" THEN 
            bPass = DECIMAL(cCalcValue) GE DECIMAL(cCurrFilter).
          WHEN "<=" OR WHEN "LE" THEN 
            bPass = DECIMAL(cCalcValue) LE DECIMAL(cCurrFilter).
        END CASE.
      WHEN "INTEGER" THEN
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN 
            bPass = INTEGER(cCalcValue) = INTEGER(cCurrFilter).
          WHEN "<>" OR WHEN "NE" THEN 
            bPass = INTEGER(cCalcValue) NE INTEGER(cCurrFilter).
          WHEN ">" OR WHEN "GT" THEN 
            bPass = INTEGER(cCalcValue) GT INTEGER(cCurrFilter).
          WHEN "<" OR WHEN "LT" THEN
            bPass = INTEGER(cCalcValue) LT INTEGER(cCurrFilter).
          WHEN ">=" OR WHEN "GE" THEN 
            bPass = INTEGER(cCalcValue) GE INTEGER(cCurrFilter).
          WHEN "<=" OR WHEN "LE" THEN 
            bPass = INTEGER(cCalcValue) LE INTEGER(cCurrFilter).
        END CASE.
      WHEN "INT64" THEN
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN 
            bPass = INT64(cCalcValue) = INT64(cCurrFilter).
          WHEN "<>" OR WHEN "NE" THEN 
            bPass = INT64(cCalcValue) NE INT64(cCurrFilter).
          WHEN ">" OR WHEN "GT" THEN 
            bPass = INT64(cCalcValue) GT INT64(cCurrFilter).
          WHEN "<" OR WHEN "LT" THEN
            bPass = INT64(cCalcValue) LT INT64(cCurrFilter).
          WHEN ">=" OR WHEN "GE" THEN 
            bPass = INT64(cCalcValue) GE INT64(cCurrFilter).
          WHEN "<=" OR WHEN "LE" THEN 
            bPass = INT64(cCalcValue) LE INT64(cCurrFilter).
        END CASE.
      WHEN "LOGICAL" THEN DO:
        IF cCalcValue = "" THEN cCalcValue = "no".
        CASE cOperator:
          WHEN "=" OR WHEN "EQ" THEN
            bPass = (CAN-DO("yes,true",cCurrFilter) AND CAN-DO("yes,true",cCalcValue)) OR
                    (CAN-DO("no,false",cCurrFilter) AND CAN-DO("no,false",cCalcValue)).
          WHEN "<>" OR WHEN "NE" THEN
            bPass = (NOT CAN-DO("yes,true",cCurrFilter) AND NOT CAN-DO("yes,true",cCalcValue)) OR
                    (NOT CAN-DO("no,false",cCurrFilter) AND NOT CAN-DO("no,false",cCalcValue)).
        END CASE.
      END.  
    END CASE.
    IF NOT bPass THEN LEAVE.
  END.
  RETURN bPass.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL CallSQL(INPUT ipSelect AS CHAR):
    DEF VAR ix AS INT NO-UNDO.
    SQLstatement = ipSelect.
           
    IF NOT VALID-OBJECT(Conn) THEN DO:
      THIS-OBJECT:ConnectSQL().
      IF SQLerror NE "" THEN RETURN NO.
    END.  
    ELSE IF VALID-OBJECT(Rdr) THEN Rdr:Close().
    
    Cmd = conn:CreateCommand().
    Rdr = Cmd:ExecuteReader().
    bRead = NO.
  
    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in CallSQL: " + anyError:GetMessage(1) + CHR(10) + "SQL: " + (IF ipSelect NE ? THEN ipSelect ELSE "?").      
    END CATCH.

    FINALLY:
      RETURN SQLerror = "".
    END FINALLY.
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL CallSQL(INPUT ipSQLstatement AS CHAR, INPUT ipUpdate AS LOG):
    DEF VAR ix AS INT NO-UNDO.
    sqlStatement = ipSQLstatement.
        
    IF NOT VALID-OBJECT(Conn) THEN DO:
      THIS-OBJECT:ConnectSQL().
      IF SQLerror NE "" THEN RETURN NO.       
    END.
    ELSE IF VALID-OBJECT(Rdr) THEN 
      Rdr:Close().
      
    Cmd = conn:CreateCommand().
    elapseMsec = MTIME.        
    IF ipUpdate THEN DO: 
      Cmd:CommandText = SQLstatement.
      Cmd:ExecuteNonQuery().
    END.   
    ELSE DO:
      Rdr = Cmd:ExecuteReader().
      bRead = NO.
    END.

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in CallSQL with update flag: " + anyError:GetMessage(1) + CHR(10) + "SQL: " + (IF ipSQLstatement NE ? THEN ipSQLstatement ELSE "?").      
    END CATCH.

    FINALLY:
      elapseMsec = MTIME - elapseMsec.        
      RETURN SQLerror = "".
    END FINALLY.

   END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID ConnectSQL(  ):
    DEF VAR sqlConnect   AS CHAR NO-UNDO.
    
    SqlConnect = 'DRIVER=' + CHR(123) + sqlDriver + CHR(125) 
               + ';HOST=' + sqlHost
               + ';PORT=' + sqlPort
               + ';DB='   + sqlDatabase
               + ';UID='  + sqlUserid
               + ';PWD='  + sqlPassword
               + ';DIL=0'
//               + ';Regional=yes'
               .
    Conn = NEW System.Data.Odbc.OdbcConnection(sqlConnect).
    Conn:Open().

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in ConnectSql: " + anyError:GetMessage(1) + CHR(10) + "Connect params:" + CHR(10)
        + "sqlDriver: " + sqlDriver + CHR(10)
        + "sqlHost: " + sqlHost + CHR(10)
        + "sqlDatabase: " + sqlDatabase + CHR(10)
        + "sqlUserid: " + sqlUserid + CHR(10)
        + "sqlPassword: " + (IF sqlPassword NE "" THEN "<unlike blank>" ELSE "<not set>")
        .
      MESSAGE "Connect failure" anyError:GetMessage(1)
      VIEW-AS ALERT-BOX.       
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getValue (INPUT icFieldName AS CHAR):
    DEF VAR iy AS INT NO-UNDO.
    
    IF NOT VALID-OBJECT (Rdr) THEN DO:
      SQLerror = "sql reader not defined".
      RETURN ?.
    END.  
    IF NOT bRead THEN 
      bRead = Rdr:Read().
    
    IF bRead THEN    
      RETURN STRING(Rdr[icFieldName]).
    ELSE RETURN ?.  
  END.

  METHOD PUBLIC CHARACTER convertDatetime(input ipDatetime as char):
    def var Datepart as char no-undo.
    def var Timepart as char no-undo.
    def var oldFormat as char no-undo.
    def var ISOformat as log no-undo.
    def var tmpDatetime as datetime no-undo.
    assign 
      ISOformat = index(ipDatetime,'-') = 5 
      .
    if ISOformat then
      assign 
        oldFormat = session:date-format
        session:date-format = 'ymd'
        tmpDatetime = datetime(ipDatetime)
        .        
    else 
      assign
        Datepart  = entry(1,ipDatetime,' ')
        Datepart  = replace(datepart,'.','/')
        Timepart  = entry(2,ipDatetime,' ')
        Timepart  = replace(Timepart,'.',':')
        .
    if ISOformat then 
      assign session:date-format = oldFormat.

    return if ISOformat then string(tmpDatetime) else Datepart + ' ' + Timepart.  
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC DECIMAL convertDecimal(INPUT icDecimal AS CHARACTER):
    
    DEFINE VARIABLE result AS DECIMAL NO-UNDO.
    DEF VAR cOldFormat AS CHAR NO-UNDO.
    
    IF INDEX(icDecimal,".") > INDEX(icDecimal,",") AND SESSION:NUMERIC-DECIMAL-POINT = "," THEN DO:
      cOldFormat = SESSION:NUMERIC-FORMAT.
      SESSION:NUMERIC-FORMAT = "American".
      result = DECIMAL(icDecimal).
      SESSION:NUMERIC-FORMAT = cOldFormat.
    END.
    ELSE IF INDEX(icDecimal,",") > INDEX(icDecimal,".") AND SESSION:NUMERIC-DECIMAL-POINT = "." THEN DO:
      cOldFormat = SESSION:NUMERIC-FORMAT.
      SESSION:NUMERIC-FORMAT = "European".
      result = DECIMAL(icDecimal).
      SESSION:NUMERIC-FORMAT = cOldFormat.
    END.
    ELSE result = DECIMAL(icDecimal).

    RETURN result.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID CloseConnection(  ):
    IF VALID-OBJECT(conn) THEN Conn:Close().     
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL fillTempTable(INPUT icSQL             AS CHAR
                                     ,INPUT ihBuffer          AS HANDLE
                                     ,INPUT icFillOEfieldList AS CHAR ):
   
    /* Fill a temp-table from an sql table. Fields in temp-table defined
       after the RowCount (or RowIdent*) column are considered local and will not be 
       attempted filled from the sql table/view 
    */    
    DEF VAR hFlds            AS HANDLE NO-UNDO EXTENT.
    DEF VAR cSqlFldNames     AS CHAR   NO-UNDO EXTENT.
    DEF VAR ix               AS INT    NO-UNDO.           
    DEF VAR iy               AS INT    NO-UNDO.           
    DEF VAR iExtraFlds       AS INT    NO-UNDO.
    DEF VAR bStartExtrFldCnt AS LOG    NO-UNDO.
    DEF VAR cDate            AS CHAR   NO-UNDO.
    DEF VAR cTime            AS CHAR   NO-UNDO.
    DEF VAR iFieldCount      AS INT    NO-UNDO.

    IF NOT VALID-OBJECT(Conn) THEN DO:
      THIS-OBJECT:ConnectSQL().
      IF SQLerror NE "" THEN RETURN NO.       
    END.
    ELSE IF VALID-OBJECT(Rdr) THEN 
      Rdr:Close().

    Cmd = conn:CreateCommand().
    Cmd:CommandText = icSql.
    Cmd:CommandTimeout = SQLtimeout.
    
    Rdr = Cmd:ExecuteReader().
             
    IF icFillOEfieldList NE "" THEN DO:
      IF NOT CAN-DO(icFillOEfieldList,"RowCount") THEN
        icFillOEfieldList = icFillOEfieldList + ",RowCount".
      iFieldCount = NUM-ENTRIES(icFillOEfieldList).
      EXTENT(hFlds) = iFieldCount + NUM-ENTRIES(cSqlCalcFlds).
      EXTENT(cSqlFldNames) = iFieldCount + NUM-ENTRIES(cSqlCalcFlds).
      DO iy = 1 TO iFieldCount:
        hFlds[iy] = ihBuffer:BUFFER-FIELD(ENTRY(iy,icFillOEfieldList)).
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_e_","æ").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"o_e_","ø").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_a_","å").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"__"," ").
        IF CAN-DO("value_,status_,alias_,message_,locked_",cSqlFldNames[iy]) THEN
          cSqlFldNames[iy] = TRIM(cSqlFldNames[iy],"_").
  
        IF LENGTH(cSqlFldNames[iy]) > 32 THEN
          cSqlFldNames[iy] = hFlds[iy]:VALIDATE-MESSAGE. 
      END.
      IF cSqlCalcFlds NE "" THEN DO: 
        DO iy = 1 TO NUM-ENTRIES(cSqlCalcFlds):
          hFlds[iy + iFieldCount] = ihBuffer:BUFFER-FIELD(ENTRY(iy,cSqlCalcFlds)).
          cSqlFldNames[iy + iFieldCount] = hFlds[iy + iFieldCount]:NAME.
        END.
        icFillOEfieldList = icFillOEfieldList + "," + cSqlCalcFlds.
        iFieldCount = iFieldCount + NUM-ENTRIES(cSqlCalcFlds).
      END.    
    END.    
    ELSE DO:    
      EXTENT(hFlds) = ihBuffer:NUM-FIELDS.
      EXTENT(cSqlFldNames) = ihBuffer:NUM-FIELDS.
      DO iy = 1 TO ihBuffer:NUM-FIELDS:
        hFlds[iy] = ihBuffer:BUFFER-FIELD (iy).

        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_e_","æ").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"o_e_","ø").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_a_","å").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"__"," ").
        IF CAN-DO("value_,status_,alias_,message_,locked_",cSqlFldNames[iy]) THEN
          cSqlFldNames[iy] = TRIM(cSqlFldNames[iy],"_").
  
        IF LENGTH(cSqlFldNames[iy]) > 32 THEN
          cSqlFldNames[iy] = hFlds[iy]:VALIDATE-MESSAGE. 
         
        IF (hFlds[iy]:NAME = "RowCount" OR hFlds[iy]:NAME BEGINS "RowIdent") AND NOT bStartExtrFldCnt THEN 
          bStartExtrFldCnt = YES.
        ELSE IF bStartExtrFldCnt AND hFlds[iy]:NAME NE "RowCount" AND NOT hFlds[iy]:NAME BEGINS "RowIdent" THEN
          iExtraFlds = iExtraFlds + 1.
      END.
      iFieldCount = ihBuffer:NUM-FIELDS - iExtraFlds.
    END.  
    elapseMsec = MTIME.        
    ReadCount = 0.  
    DO WHILE Rdr:Read():
      ReadCount = ReadCount + 1.
    
      ihBuffer:BUFFER-CREATE().
      FieldLoop:
      DO iy = 1 TO iFieldCount:
        IF icFillOEfieldList NE "" AND NOT CAN-DO(icFillOEfieldList,hFlds[iy]:NAME) THEN 
          NEXT FieldLoop.
        
        IF hFlds[iy]:NAME BEGINS "RowIdent" AND bStartExtrFldCnt THEN
          hFlds[iy]:BUFFER-VALUE = STRING(ReadCount).
        ELSE IF hFlds[iy]:NAME BEGINS "RowIdent" THEN
          hFlds[iy]:BUFFER-VALUE = STRING(Rdr[cSqlFldNames[iy]]).
        ELSE IF hFlds[iy]:NAME = "RowCount" THEN
          hFlds[iy]:BUFFER-VALUE = ReadCount.
        ELSE IF hFlds[iy]:DATA-TYPE = "date" THEN 
          hFlds[iy]:BUFFER-VALUE = DATE(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "datetime" THEN 
          ASSIGN cDate = ENTRY(1,STRING(Rdr[cSqlFldNames[iy]])," ")
                 cTime = REPLACE(ENTRY(2,STRING(Rdr[cSqlFldNames[iy]])," "),".",":")         
                 hFlds[iy]:BUFFER-VALUE = DATETIME(cDate + " " + cTime).
        ELSE IF hFlds[iy]:DATA-TYPE = "INTEGER" THEN  
          hFlds[iy]:BUFFER-VALUE = INTEGER(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "INT64" THEN 
          hFlds[iy]:BUFFER-VALUE = INT64(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "DECIMAL" THEN  
          hFlds[iy]:BUFFER-VALUE = convertDecimal(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "LOGICAL" THEN  
          hFlds[iy]:BUFFER-VALUE = LOGICAL(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "CHARACTER" THEN   
          hFlds[iy]:BUFFER-VALUE = TRIM(STRING(Rdr[cSqlFldNames[iy]])).
          
      END.
      IF ReadLimit > 0 AND ReadCount > ReadLimit THEN LEAVE. 
    END.

    CATCH ex AS System.Data.Odbc.OdbcException :
      SQLerror = ex:Message + CHR(10) + "SQL: " + icSQL.
    END CATCH.

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in fillTempTable: " + anyError:GetMessage(1) + CHR(10)
                                            + (IF iy > 1 THEN "Could be error in field after " + hFlds[iy - 1]:NAME + CHR(10) ELSE "") 
                                            + "SQL: " + (IF icSQL NE ? THEN icSQL ELSE "?").      
    END CATCH.
    
    FINALLY:
      if valid-object(Rdr) then do:
        Rdr:Close().
        delete object Rdr no-error.
        delete object Cmd no-error.
      end.
      elapseMsec = MTIME - elapseMsec.
      IF cOldDateFormat NE "" THEN SESSION:DATE-FORMAT = cOldDateFormat.        
      RETURN SQLerror = "".
    END FINALLY.
    
  END METHOD.

  METHOD PUBLIC LOGICAL fillTempTable(INPUT icSQL    AS CHARACTER,INPUT ihBuffer AS HANDLE ):
   
    DEFINE VARIABLE ii               AS INTEGER   NO-UNDO.           
    DEFINE VARIABLE hField           AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hFields          AS HANDLE  EXTENT  NO-UNDO.
    
    DEFINE VARIABLE RowIdent1 AS HANDLE NO-UNDO.
    DEFINE VARIABLE RowCount  AS HANDLE NO-UNDO.
    
    DEFINE VARIABLE FieldName        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE SQLFieldDataType AS CHARACTER NO-UNDO.
    DEFINE VARIABLE DateTimeToDate   AS DATETIME  NO-UNDO.
        
    if not valid-object(conn) then undo, throw new Progress.Lang.AppError('Har ikke knyttning til SQL',1).
    
    if debugging then MESSAGE '-->Før Cmd' VIEW-AS ALERT-BOX.    
    IF NOT VALID-OBJECT(Cmd) AND icSQL NE "" THEN DO:
      Cmd = NEW System.Data.Odbc.OdbcCommand(icSql, Conn).
      if debugging then MESSAGE '-->Cmd:icsql/conn:' icSql '/' conn  VIEW-AS ALERT-BOX.    
      Cmd:CommandTimeout = 300.
      Rdr = Cmd:ExecuteReader().
      if debugging then MESSAGE '-->executeReader' VIEW-AS ALERT-BOX.    
    END.  
    ELSE IF NOT VALID-OBJECT(Cmd) THEN UNDO, THROW NEW Progress.Lang.AppError("Missing sql statement in fillTempTable",1).
    
    elapseMsec = MTIME.        
    ReadCount = 0.
    DO WHILE Rdr:Read():
      IF ReadCount = 0 THEN DO:
        EXTENT(hFields) = Rdr:FieldCount.
        DO ii = 0 TO (Rdr:FieldCount - 1) ON ERROR UNDO, LEAVE: /*array starts on 0*/
          FieldName   = REPLACE(Rdr:GetName(ii)," ","__").
          hFields[ii + 1] = ihBuffer:BUFFER-FIELD(FieldName) NO-ERROR.
          IF ERROR-STATUS:GET-NUMBER(1) = 7351 THEN DO:
            FieldName = FieldName + "_".
            hFields[ii + 1] = ihBuffer:BUFFER-FIELD(FieldName) NO-ERROR.
          END.  
        END.
        RowIdent1 = ihBuffer:BUFFER-FIELD('RowIdent1') NO-ERROR. 
        RowCount  = ihBuffer:BUFFER-FIELD('RowCount') NO-ERROR.          
      END.
      if debugging then MESSAGE '-->leser Rdr:read:ii:' ii VIEW-AS ALERT-BOX.    
      
      ReadCount = ReadCount + 1.
      ihBuffer:BUFFER-CREATE().
      DO ii = 0 TO (Rdr:FieldCount - 1) ON ERROR UNDO, LEAVE: /*array starts on 0*/
        SQLFieldDataType = ''.
        
        IF NOT VALID-HANDLE(hFields[ii + 1]) THEN NEXT.
        FieldName = Rdr:GetName(ii).
        hField    = hFields[ii + 1].
        SQLFieldDataType = Rdr:GetDataTypeName(ii).

        IF SQLFieldDataType = '' THEN LEAVE. /*If no value, it is the end of index, should leave.*/
        CASE hField:DATA-TYPE:
          WHEN 'integer'   THEN ASSIGN hField:BUFFER-VALUE = int(STRING(Rdr:GetValue(ii))).
          WHEN 'int64'     THEN ASSIGN hField:BUFFER-VALUE = INT64(STRING(Rdr:GetValue(ii))).
          WHEN 'decimal'   THEN ASSIGN hField:BUFFER-VALUE = convertDecimal(STRING(Rdr:GetValue(ii))).
          WHEN 'datetime'  THEN ASSIGN hField:BUFFER-VALUE = convertDatetime(string(Rdr:GetValue(ii))).
          WHEN 'date'      THEN ASSIGN hField:BUFFER-VALUE = DATE(STRING(Rdr:GetValue(ii))).
          WHEN 'character' THEN ASSIGN hField:BUFFER-VALUE = TRIM(STRING(Rdr:GetValue(ii))).
          WHEN 'logical'   THEN do:
            if SQLFieldDataType = 'SmallInt' then
              Assign hField:buffer-value =  int(Rdr:GetValue(ii)) = 1.
            else if SQLFieldDataType = 'Binary' then
              Assign hField:buffer-value =  int(Rdr:GetValue(ii)) = 1.
            ELSE IF SQLFieldDataType = 'BIT' then
              Assign hField:buffer-value =  int(Rdr:GetValue(ii)) = 1.
            else 
              ASSIGN hField:BUFFER-VALUE = LOGICAL(STRING(Rdr:GetBoolean(ii))).
          end.
          OTHERWISE UNDO, THROW NEW Progress.Lang.AppError('Fant ikke datatype konvertering for:' + FieldName + ':datatype:' + hField:DATA-TYPE,1).
        END CASE.
        
        CATCH eAnyError AS Progress.Lang.Error :
          if debugging then MESSAGE "Rdr:error " + eAnyError:GetMessage(1) + '-> ' + FieldName + '(' + upper(hField:DATA-TYPE) + '-->' + upper(SQLFieldDataType) VIEW-AS ALERT-BOX.
          UNDO, THROW NEW Progress.Lang.AppError ("Rdr:error " + eAnyError:GetMessage(1) + '-> ' + FieldName + '(' + upper(hField:DATA-TYPE) + '-->' + upper(SQLFieldDataType),1).      
        END CATCH.
      END.
      if debugging then MESSAGE '-->Ferdig...' VIEW-AS ALERT-BOX.    

      IF VALID-HANDLE(RowIdent1) THEN RowIdent1:buffer-value = STRING(ReadCount). 
      IF VALID-HANDLE(RowCount)  THEN RowCount:buffer-value  = ReadCount.
    END.

    CATCH ex AS System.Data.Odbc.OdbcException :
      SQLerror = ex:Message + CHR(10) + "SQL: " + icSQL.
    END CATCH.
    
    CATCH eAnyError AS Progress.Lang.Error :
      if debugging then MESSAGE '-->Error:' eAnyError:GetMessage(1) VIEW-AS ALERT-BOX.          
      SQLerror = "Error in fillTempTable: " + eAnyError:GetMessage(1).
    END CATCH.
    
    FINALLY:
      if valid-object(Rdr) then do:
        Rdr:Close().
        delete object Rdr no-error.
        delete object Cmd no-error.
      end.
      elapseMsec = MTIME - elapseMsec.        
      RETURN SQLerror = "".
    END FINALLY.
    
  END METHOD.
  
  METHOD PUBLIC LOGICAL fillTempTable(INPUT icSQL             AS CHAR
                                     ,INPUT ihBuffer          AS HANDLE
                                     ,INPUT icFillOEfieldList AS CHAR
                                     ,INPUT ihSpecFlds        AS HANDLE
                                     ,INPUT ihRowSpecVal      AS HANDLE):
      
    /* Fill a temp-table from an sql table. Fields in temp-table defined
       after the RowCount (or RowIdent*) column are considered local and will not be 
       attempted filled from the sql table/view 
    */    
    
    DEF VAR hFlds            AS HANDLE NO-UNDO EXTENT 200.
    DEF VAR cSqlFldNames     AS CHAR   NO-UNDO EXTENT 200.
    DEF VAR ix               AS INT    NO-UNDO.           
    DEF VAR iy               AS INT    NO-UNDO.           
    DEF VAR iExtraFlds       AS INT    NO-UNDO.
    DEF VAR bStartExtrFldCnt AS LOG    NO-UNDO.
    DEF VAR cDate            AS CHAR   NO-UNDO.
    DEF VAR cTime            AS CHAR   NO-UNDO.
    DEF VAR iFieldCount      AS INT    NO-UNDO.
    DEF VAR hCalcFieldProcs  AS HANDLE NO-UNDO EXTENT 10.
    DEF VAR hJboxCalcFlds    AS HANDLE NO-UNDO.
    DEF VAR bCheckForSkipRow AS LOG    NO-UNDO.
    DEF VAR iReadCntEntry    AS INT    NO-UNDO. /* Ref to handle for setting readcount */
    DEF VAR rLastRowid       AS ROWID  NO-UNDO.
    DEF VAR iTop             AS INT    NO-UNDO.

    IF NOT VALID-OBJECT(Conn) THEN DO:
      THIS-OBJECT:ConnectSQL().
      IF SQLerror NE "" THEN RETURN NO.       
    END.
    ELSE IF VALID-OBJECT(Rdr) THEN 
      Rdr:Close().

    IF ENTRY(2,icSQL," ") = "top" THEN
      ASSIGN icSQL = LEFT-TRIM(icSQL,"select top ")
             iTop  = INT(ENTRY(1,icSql," "))
             icSQL = "SELECT" + SUBSTR(icSQL,INDEX(icSQL," ")).

    Cmd = conn:CreateCommand().
    Cmd:CommandText = icSQL.
    Cmd:CommandTimeout = SQLtimeout.
    
    Rdr = Cmd:ExecuteReader().
        
    IF NOT VALID-OBJECT(Cmd) THEN DO:
      SQLerror = "Missing sql statement in fillTempTable".
      RETURN FALSE.    
    END.
        
    ReadLimit = 500000.
    IF iTop > 100000 THEN iiBatchSize = ReadLimit.
    ELSE IF iiBatchSize = 0 THEN iiBatchSize = 200.    
    RUN jbserv_jb_calc_helper.p PERSIST SET hJboxCalcFlds (ihBuffer,weekdayList,"SQL",ihSpecFlds).
    
    BUFFER ttSpecFlds:HANDLE:COPY-TEMP-TABLE (ihSpecFlds).
    
    ix = 1.
    /* Start any persistent procedures for calculated fields: */
    IF cCalcFieldProcs NE ""  THEN DO:
      DO ix = 1 TO NUM-ENTRIES(TRIM(cCalcFieldProcs,";"),";"):
        IF SEARCH(ENTRY(ix,cCalcFieldProcs,";")) = ? AND SEARCH(SUBSTR(ENTRY(ix,cCalcFieldProcs,";"),1,LENGTH(ENTRY(ix,cCalcFieldProcs,";")) - 1) + "r") = ? THEN DO:
          SQLerror = "Couldn't find server program for calculated fields: " + ENTRY(ix,cCalcFieldProcs,";").
          RETURN NO.
        END.
        ELSE DO:
          RUN VALUE(ENTRY(ix,cCalcFieldProcs,";")) PERSIST SET hCalcFieldProcs[ix].
          FOR EACH ttSpecFlds:
            IF CAN-DO(hCalcFieldProcs[ix]:INTERNAL-ENTRIES,ttSpecFlds.cCallProc) THEN
              ttSpecFlds.hCalcFieldProc = hCalcFieldProcs[ix].
          END.
        END.  
      END.
    END.
    hCalcFieldProcs[ix] = hJboxCalcFlds.
    FOR EACH ttSpecFlds:
      /* The ttRowSpecVal tables keeps all values for special fields as they are
         obtained either as calculated or grand total fields (who also can be calculated): */
      CREATE ttRowSpecVal.
      BUFFER-COPY ttSpecFlds TO ttRowSpecVal.   
      ttRowSpecVal.hFillField    = ihBuffer:BUFFER-FIELD(ttRowSpecVal.cFillField).

/*      IF icFillOEfieldList NE "" AND NOT CAN-DO(icFillOEfieldList,ttSpecFlds.cCallProcParam) THEN*/
/*        icFillOEfieldList = icFillOEfieldList + "," + ttSpecFlds.cCallProcParam.                 */

      IF CAN-DO("jb_weeknum,jb_month,jb_quarter,jb_year,jb_date_dt,jb_weeknum_dt,jb_month_dt,jb_quarter_dt,jb_year_dt,jb_calc,jb_can-find,jb_total,jb_weekday,jb_age,jb_isodate,jb_isodate_dt",ttSpecFlds.cCallProc) AND cStatFields NE ""
         AND cCalcFieldFilter MATCHES "*jb_*_*" THEN
        bCheckForSkipRow = YES.
    END.   
    
    IF icFillOEfieldList NE "" THEN DO:
      IF NOT CAN-DO(icFillOEfieldList,"RowCount") THEN
        icFillOEfieldList = icFillOEfieldList + ",RowCount".
      iFieldCount = NUM-ENTRIES(icFillOEfieldList).
      DO iy = 1 TO iFieldCount:
        hFlds[iy] = ihBuffer:BUFFER-FIELD(ENTRY(iy,icFillOEfieldList)).
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_e_","æ").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"o_e_","ø").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_a_","å").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"__"," ").
        IF CAN-DO("value_,status_,alias_,message_,locked_",cSqlFldNames[iy]) THEN
          cSqlFldNames[iy] = TRIM(cSqlFldNames[iy],"_").
  
        IF LENGTH(cSqlFldNames[iy]) > 32 THEN
          cSqlFldNames[iy] = hFlds[iy]:VALIDATE-MESSAGE.
        IF ENTRY(iy,icFillOEfieldList) = "RowCount" THEN iReadCntEntry = iy.   
      END.
    END.    
    ELSE DO:    
      DO iy = 1 TO ihBuffer:NUM-FIELDS:
        hFlds[iy] = ihBuffer:BUFFER-FIELD (iy).

        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_e_","æ").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"o_e_","ø").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"a_a_","å").
        cSqlFldNames[iy] = REPLACE(hFlds[iy]:NAME,"__"," ").
        IF CAN-DO("value_,status_,alias_,message_,locked_",cSqlFldNames[iy]) THEN
          cSqlFldNames[iy] = TRIM(cSqlFldNames[iy],"_").
  
        IF LENGTH(cSqlFldNames[iy]) > 32 THEN
          cSqlFldNames[iy] = hFlds[iy]:VALIDATE-MESSAGE. 
         
        IF (hFlds[iy]:NAME = "RowCount" OR hFlds[iy]:NAME BEGINS "RowIdent") AND NOT bStartExtrFldCnt THEN 
          bStartExtrFldCnt = YES.
        ELSE IF bStartExtrFldCnt AND hFlds[iy]:NAME NE "RowCount" AND NOT hFlds[iy]:NAME BEGINS "RowIdent" THEN
          iExtraFlds = iExtraFlds + 1.
      END.
      iFieldCount = ihBuffer:NUM-FIELDS - iExtraFlds.
    END.  
                
    ReadCount = 0.  
    elapseMsec = MTIME.        
    
    QueryLoop:
    DO WHILE Rdr:Read():
      IF ReadCount LE iiStartRow + iiBatchSize + (IF getRowCount THEN 1 ELSE 0) THEN DO: /* last row is placeholder for calculations */
        ihBuffer:BUFFER-CREATE().
        rLastRowid = ihBuffer:ROWID.
      END.  
      FieldLoop:
      DO iy = 1 TO iFieldCount:
        IF icFillOEfieldList NE "" AND NOT CAN-DO(icFillOEfieldList,hFlds[iy]:NAME) THEN 
          NEXT FieldLoop.
        
        IF hFlds[iy]:NAME BEGINS "RowIdent" AND bStartExtrFldCnt THEN
          hFlds[iy]:BUFFER-VALUE = STRING(ReadCount).
        ELSE IF hFlds[iy]:NAME = "RowCount" THEN
          hFlds[iy]:BUFFER-VALUE = ReadCount.
        ELSE IF hFlds[iy]:DATA-TYPE = "date" THEN 
          hFlds[iy]:BUFFER-VALUE = DATE(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "datetime" THEN 
          ASSIGN cDate = ENTRY(1,STRING(Rdr[cSqlFldNames[iy]])," ")
                 cTime = REPLACE(ENTRY(2,STRING(Rdr[cSqlFldNames[iy]])," "),".",":")         
                 hFlds[iy]:BUFFER-VALUE = DATETIME(cDate + " " + cTime).
        ELSE IF hFlds[iy]:DATA-TYPE = "INTEGER" THEN  
          hFlds[iy]:BUFFER-VALUE = INTEGER(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "INT64" THEN 
          hFlds[iy]:BUFFER-VALUE = INT64(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "DECIMAL" THEN  
          hFlds[iy]:BUFFER-VALUE = convertDecimal(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "LOGICAL" THEN  
          hFlds[iy]:BUFFER-VALUE = LOGICAL(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "CHARACTER" THEN   
          hFlds[iy]:BUFFER-VALUE = TRIM(STRING(Rdr[cSqlFldNames[iy]])).
      END.
      
      FOR EACH ttSpecFlds
          BY ttSpecFlds.bMandatoryCalc DESC
          BY ttSpecFlds.iFieldNum:


        FIND FIRST ttRowSpecVal OF ttSpecFlds.

        /* Either the calculated values: */
        IF ttSpecFlds.cCallProc NE "" THEN DO:
          IF VALID-HANDLE(ttSpecFlds.hCalcFieldProc) THEN DO:
            IF ttSpecFlds.cCallProc = "jb_calc" THEN 
              RUN JB_calc (ttSpecFlds.hSourceField,ttSpecFlds.hSourceField2,ttSpecFlds.cCallProcParam,ttSpecFlds.fCalcConstant,OUTPUT ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            ELSE IF ttSpecFlds.cCallProc = "jb_can-find" THEN 
              RUN JB_can-find (ttSpecFlds.iCallBufferNum,OUTPUT ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            ELSE IF ttSpecFlds.cCallProc = "jb_total" THEN 
              RUN JB_total (ttSpecFlds.iCallBufferNum,OUTPUT ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            ELSE IF ttSpecFlds.cCallProc = "jb_max" THEN 
              RUN JB_max (ttSpecFlds.hCompareFields,ttSpecFlds.iCntCompareFields,OUTPUT ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            ELSE IF ttSpecFlds.cCallProcParam BEGINS "ROWID" THEN
              RUN VALUE(ttSpecFlds.cCallProc) IN ttSpecFlds.hCalcFieldProc
                 (ihBuffer:ROWID,SUBSTR(ttSpecFlds.cCallProcParam,6),cSessionId, OUTPUT ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            ELSE IF ttSpecFlds.cCallProcParam NE "" THEN 
              RUN VALUE(ttSpecFlds.cCallProc) IN ttSpecFlds.hCalcFieldProc 
                  (ttSpecFlds.hSourceField:BUFFER-VALUE,cSessionId, OUTPUT ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            ELSE 
              RUN VALUE(ttSpecFlds.cCallProc) IN ttSpecFlds.hCalcFieldProc 
                  (ihBuffer:ROWID,cSessionId, OUTPUT ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            IF ttSpecFlds.bDirectAssign THEN
              AssignStringValue(ttRowSpecVal.hFillField,ttRowSpecVal.cCurrCallOutput).
          END.
          ELSE DO:
            IF ttSpecFlds.cCallProcParam BEGINS "ROWID" THEN
              RUN VALUE(ttSpecFlds.cCallProc) 
                  (ihBuffer:ROWID,SUBSTR(ttSpecFlds.cCallProcParam,6),cSessionId, OUTPUT ttRowSpecVal.cCurrCallOutput).
            ELSE IF ttSpecFlds.cCallProcParam NE "" THEN
              RUN VALUE(ttSpecFlds.cCallProc) 
                  (ttSpecFlds.hSourceField:BUFFER-VALUE,cSessionId, OUTPUT ttRowSpecVal.cCurrCallOutput).
            ELSE 
              RUN VALUE(ttSpecFlds.cCallProc) 
                  (ihBuffer:ROWID,cSessionId, OUTPUT ttRowSpecVal.cCurrCallOutput).
          END.

          IF ttRowSpecVal.cCurrCallOutput = "skiprow" OR (bCalcFieldFilter AND NOT THIS-OBJECT:CalcValueOk(ttRowSpecVal.cCurrCallOutput)) THEN DO:
            /* If any accumulations were done by prescan they need to be adjusted since the row should not be included: */
            IF bLogSkipRow AND ttRowSpecVal.cCurrCallOutput = "skiprow" THEN LogThis("SKIPROW " + ttSpecFlds.cCallProc,STRING(ihBuffer:ROWID),0).
            FOR EACH ttRowSpecVal where ttRowSpecVal.bCalcByPreScan
                AND ttRowSpecVal.bAccum:
              ttRowSpecVal.fGrandTotal = ttRowSpecVal.fGrandTotal - ttRowSpecVal.fRowValue.
            END.
            IF ReadCount < iiStartRow + iiBatchSize THEN
              ihBuffer:BUFFER-DELETE.
            NEXT QueryLoop.
          END.
          ELSE IF ttSpecFlds.bGrandTotal THEN DO: 
            ttRowSpecVal.fRowValue = DEC(ttRowSpecVal.cCurrCallOutput) NO-ERROR.
            IF ERROR-STATU:ERROR THEN DO:
              SQLerror = "Server calculation routine " + ttSpecFlds.cCallProc + " returns invalid value for accumulation: " + ttRowSpecVal.cCurrCallOutput.
              LogThis(SQLerror,"",1).
              RETURN NO.
            END.
          END.
        END. /* Calculated values */
        /* Or GrandTotal fields from the database buffer: */
        ELSE IF ttSpecFlds.bGrandTotal THEN DO:
          ttRowSpecVal.fRowValue = DEC(ttSpecFlds.hSourceField:BUFFER-VALUE) NO-ERROR.
          IF ERROR-STATU:ERROR THEN DO:
            SQLerror = "Accumulation of field " + ttSpecFlds.cFillField + " on assignment due to a mismatch in datatype (only numbers can be accumulated)".
            LogThis(SQLerror,"",1).
            RETURN NO.
          END.
        END.
      END.  
      
      FOR EACH ttRowSpecVal:
        IF ttRowSpecVal.cCallProc NE "" THEN
          AssignStringValue(ttRowSpecVal.hFillField,ttRowSpecVal.cCurrCallOutput).
        IF ttRowSpecVal.fRowValue NE ? THEN
          ttRowSpecVal.fGrandTotal = ttRowSpecVal.fGrandTotal + ttRowSpecVal.fRowValue.
      END.
      
      ReadCount = ReadCount + 1.
      hFlds[iReadCntEntry]:BUFFER-VALUE = ReadCount.
      IF ReadLimit > 0 AND ReadCount > ReadLimit THEN LEAVE. 
      IF NOT getRowCount AND cCalcSortFields = "" AND ReadCount = iiStartRow + iiBatchSize THEN LEAVE. 
    END.
    
    IF ReadCount > iiStartRow + iiBatchSize AND getRowCount THEN DO:
      ihBuffer:FIND-BY-ROWID (rLastRowid) NO-ERROR.
      ihBuffer:BUFFER-DELETE ().
    END.
    
    CATCH ex AS System.Data.Odbc.OdbcException :
      SQLerror = ex:Message + CHR(10) + "SQL: " + icSQL.
    END CATCH.
    
//    run toexcelviafile.p (ihBuffer,-2).
    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in fillTempTable: " + anyError:GetMessage(1) + CHR(10)
                                            + (IF iy > 1 THEN "Could be error in field after " + hFlds[iy - 1]:NAME + CHR(10) ELSE "") 
                                            + "SQL: " + (IF icSQL NE ? THEN icSQL ELSE "?") + CHR(10) 
                                            + "OE Field list: " + icFillOEfieldList + CHR(10)
                                            + "Startrow: " + STRING(iiStartRow) + " Batchsize: " + STRING(iiBatchSize)
                                            .      
    END CATCH.
    
    FINALLY:
      elapseMsec = MTIME - elapseMsec.        
      RETURN SQLerror = "".
    END FINALLY.
    
  END METHOD.
  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID LogThis( 
      
      INPUT icLogEntry  AS CHAR,
      INPUT icLogText   AS CHAR,
      INPUT iiSkipLines AS INT ) :
  /*------------------------------------------------------------------------------
    Purpose:  
      Notes:  
  ------------------------------------------------------------------------------*/
    IF cLogFile NE "" THEN DO:
      OUTPUT STREAM sLog TO VALUE(cLogFile) APPEND.
      PUT STREAM sLog UNFORMATTED icLogEntry icLogText AT 30.
      CASE iiSkipLines:
        WHEN 0 THEN PUT STREAM sLog SKIP.
        WHEN 1 THEN PUT STREAM sLog SKIP(1).
        WHEN 2 THEN PUT STREAM sLog SKIP(2).
        WHEN 3 THEN PUT STREAM sLog SKIP(3).
        WHEN 4 THEN PUT STREAM sLog SKIP(4).
        WHEN 5 THEN PUT STREAM sLog SKIP(5).
      END CASE.
      OUTPUT STREAM sLog CLOSE.
      IF icLogEntry MATCHES "*Etime*" THEN ETIME(TRUE).
    END.

  END METHOD.

/*
  METHOD PUBLIC LOGICAL multiUpdateTable (INPUT ihBuffer AS HANDLE):
    
    /* Do multiple sql updates by reading temp-table containing the update statements.
       Required columns in the temp-table are 
       cSQL (character)
       iSort (integer)
    */   
    
    DEF VAR hQuery AS HANDLE NO-UNDO.  
        
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(ihBuffer).
    hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME + " BY iSort").
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
      Cmd = NEW SqlCommand(ihBuffer::cSQL, Conn) NO-ERROR.
      IF VALID-OBJECT(Cmd) THEN
        Cmd:ExecuteNonQuery().
      ELSE DO:
        SQLerror = ERROR-STATUS:GET-MESSAGE(1).
        LEAVE.
      END.
      hQuery:GET-NEXT().
    END.
  
    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in multiUpdateTable: " + anyError:GetMessage(1).      
    END CATCH.
    
    FINALLY:
      DELETE OBJECT hQuery NO-ERROR.
      RETURN SQLerror = "".
    END FINALLY.
  
  END METHOD.
*/
  METHOD PUBLIC CHARACTER getViewDefinition (INPUT icViewName AS CHARACTER):
/*    RETURN oSysPara:getParameterDescription(icViewName).*/
  END.  
  
  
  METHOD PUBLIC VOID setConnection( INPUT ioConnection AS System.Data.Odbc.OdbcConnection ):
    
    Conn = ioConnection.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
/*
  METHOD PUBLIC LOGICAL updateTable( INPUT icSQL AS CHAR ):
    
    Cmd = NEW SqlCommand(icSQL, Conn) NO-ERROR.
    IF VALID-OBJECT(Cmd) THEN
      Cmd:ExecuteNonQuery().
    ELSE DO:
      SQLerror = ERROR-STATUS:GET-MESSAGE(1).
      RETURN NO.
    END.  
    RETURN YES.

  END METHOD.
  */
  METHOD PUBLIC CHARACTER getSqlServer( INPUT icKompisConnectIniPath AS CHAR ):
    
    
  DEFINE VARIABLE cSqlServer     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cChar          AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cKompisConnectIniPath AS CHAR NO-UNDO INIT "J:\KompisConnect.ini".

/*  IF icKompisConnectIniPath = "BookingTest" THEN  */
/*    RETURN "dev-sql02.dev.kriminalomsorg.no\test".*/

  IF SEARCH(icKompisConnectIniPath) NE ? THEN 
    cKompisConnectIniPath = icKompisConnectIniPath.

  /* Henter connect-parameter fra session parmeter for klient. */
  /* fra parameterfil pf\Start.pf : -param "IniPath=c:\kurs1\ini\KompisConnect.ini" */

  IF INDEX(SESSION:PARAM, "IniPath=") > 0 THEN DO:
    DEF VAR v_i AS INT NO-UNDO.

    DO v_i = 1 TO NUM-ENTRIES(SESSION:PARAM, ";"):
      IF ENTRY(v_i, SESSION:PARAM, ";") BEGINS "IniPath=" THEN DO:
        cKompisConnectIniPath = TRIM(ENTRY(2, ENTRY(v_i, SESSION:PARAM, ";"), "=")).     
      END.
    END.  
  END.
              
  FILE-INFO:FILE-NAME = cKompisConnectIniPath.
  IF FILE-INFO:FULL-PATHNAME NE ? THEN DO: 
   
    INPUT STREAM lesIni FROM VALUE(FILE-INFO:FULL-PATHNAME).
  
    REPEAT:
      IMPORT STREAM lesIni UNFORMATTED cChar.
      IF cChar BEGINS "sqlServer" THEN 
      DO:
        ASSIGN cSqlServer = TRIM(ENTRY(2,cChar, "=")) NO-ERROR.
        IF ERROR-STATUS:ERROR THEN
          ASSIGN THIS-OBJECT:SQLerror = "Finner ikks sqlserver navn"
                 cSqlServer = "".
      END.
      ELSE IF cChar BEGINS "sqlDbName" THEN
        sqlDatabase = TRIM(ENTRY(2,cChar, "=")).
    END.
    INPUT STREAM lesIni CLOSE.
  END.
  ELSE THIS-OBJECT:SQLerror = "Ugyldig filnavn for connect-info: " + cKompisConnectIniPath.  
  
  RETURN cSqlServer.

  END METHOD.
  
  DESTRUCTOR PUBLIC JBoxOdbcSql():

    THIS-OBJECT:CloseConnection().
    
  END DESTRUCTOR.  
END CLASS.