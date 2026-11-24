 
 /*------------------------------------------------------------------------
    File        : oo.JBoxSqlQueryHelper
    Purpose     : 4GL to SQL 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Tue Mar 11 10:03:36 CEST 2020
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Ccs.Common.IClientContext FROM PROPATH.

ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS oo.JBoxSqlQueryHelper: 
  
  DEF TEMP-TABLE ttSqlPrimaryKey NO-UNDO
      FIELD Column_Name AS CHAR
      .
  DEF VAR hbttSqlPrimaryKey AS HANDLE NO-UNDO.

  DEF TEMP-TABLE ttSqlColumns NO-UNDO
      FIELD Column_Name      AS CHAR
      FIELD Table_Catalog    AS CHAR 
      FIELD Table_Schema     AS CHAR 
      FIELD Data_Type        AS CHAR      
      FIELD ColNameLength    AS INT
      FIELD OETableName      AS CHAR FORMAT "x(32)"
      FIELD OEFieldName      AS CHAR FORMAT "x(32)"
      FIELD OEdataType       AS CHAR FORMAT "x(10)"
      FIELD OEformat         AS CHAR FORMAT "x(25)"
      FIELD OElabel          AS CHAR FORMAT "x(32)"
      FIELD OEvalmsg         AS CHAR FORMAT "x(50)"
      .
  DEF VAR hbttSqlColumns AS HANDLE NO-UNDO.

  DEF TEMP-TABLE ttAllSqlColumns NO-UNDO
      FIELD Table_Name       AS CHAR
      FIELD Column_Name      AS CHAR
      FIELD AliasName        AS CHAR
      FIELD MappedToOE       AS LOG 
      FIELD TableSeqNo       AS INT 
      FIELD Data_Type        AS CHAR      
      FIELD ColNameLength    AS INT
      FIELD OETableName      AS CHAR FORMAT "x(32)"
      FIELD OEFieldName      AS CHAR FORMAT "x(32)"
      FIELD OEdataType       AS CHAR FORMAT "x(10)"
      FIELD OEformat         AS CHAR FORMAT "x(25)"
      FIELD OElabel          AS CHAR FORMAT "x(32)"
      FIELD OEvalmsg         AS CHAR FORMAT "x(50)"
      .

  DEF TEMP-TABLE ttResultSetFields NO-UNDO
      FIELD BufferName   AS CHAR
      FIELD FieldName    AS CHAR
      FIELD MappedToSql  AS LOG
      .

  DEF TEMP-TABLE ttSqlReadCount NO-UNDO
      FIELD ReadCount AS INT
      .
  DEF VAR httSqlReadCount AS HANDLE NO-UNDO.

  DEF TEMP-TABLE ttSqlCalcFldWhere NO-UNDO
      FIELD FieldName    AS CHAR
      FIELD CalcFunction AS CHAR
      FIELD CalcOperator AS CHAR
      FIELD WhereClause  AS CHAR
      .

  DEF TEMP-TABLE ttSqlAccumExpr NO-UNDO
      FIELD CalcFieldName AS CHAR
      FIELD CalcExpr      AS CHAR
      .

  DEF TEMP-TABLE ttSqlCalcField NO-UNDO
      FIELD CalcFieldName       AS CHAR
      FIELD ParamFldSourceTable AS CHAR
      FIELD CalcFieldType       AS CHAR
      FIELD JBoxFunction        AS CHAR
      FIELD SQLfunction         AS CHAR
      FIELD ParamFldOrExpr      AS CHAR
      FIELD AccumField          AS LOG
      .

  DEF TEMP-TABLE ttSqlCalcFieldFilter NO-UNDO
      FIELD CalcFieldName  AS CHAR
      FIELD FilterOperator AS CHAR
      FIELD FilterValue    AS CHAR
      FIELD SQLoperator    AS CHAR
      .

  DEF TEMP-TABLE ttNotExistQuery NO-UNDO
      FIELD TableName     AS CHAR
      FIELD QueryString   AS CHAR // if appended from filter - is NOT the join criteria
      .

  DEF VAR cLeftPar   AS CHAR NO-UNDO.
  DEF VAR cRightPar  AS CHAR NO-UNDO.
  DEF PUBLIC PROPERTY c2Q        AS CHAR NO-UNDO INIT '"' GET. SET.
  DEF PUBLIC PROPERTY c2QDot2Q   AS CHAR NO-UNDO INIT '"."' GET. SET.
  
  DEFINE PUBLIC PROPERTY JB_to_SQL_funclist AS CHARACTER INIT "jb_weeknum,jb_weeknum_ww,jb_weeknum_dt,jb_weeknum_dt_ww,jb_month,jb_month_mm,jb_month_dt,jb_month_dt_mm,jb_quarter,jb_quarter_q,jb_quarter_dt,jb_quarter_dt_q,jb_year,jb_year_dt,jb_calc" GET. SET.
  DEFINE PUBLIC PROPERTY JB_to_SQL_datefunc AS CHARACTER INIT "jb_weeknum,jb_weeknum_ww,jb_weeknum_dt,jb_weeknum_dt_ww,jb_month,jb_month_mm,jb_month_dt,jb_month_dt_mm,jb_quarter,jb_quarter_q,jb_quarter_dt,jb_quarter_dt_q,jb_year,jb_year_dt" GET. SET.
  DEFINE PUBLIC PROPERTY JB_to_SQL_otherfunc AS CHARACTER INIT "jb_calc" GET. SET.

  DEFINE PUBLIC PROPERTY SQLrowsToBatch     AS INTEGER GET. SET.

  DEFINE PUBLIC PROPERTY SQLstartRow        AS INTEGER GET. SET.

  DEFINE PUBLIC PROPERTY SQLtableList       AS CHAR GET. PRIVATE SET.

  DEFINE PUBLIC PROPERTY SQLprimaryTable    AS CHAR GET. 
    SET(icPrimaryTable AS CHAR):
      SQLprimaryTable = icPrimaryTable.
      
      IF NOT CAN-DO(SQLtableList,icPrimaryTable) THEN
        SQLtableList = icPrimaryTable + SQLtableList.        
    END SET.

  DEFINE PUBLIC PROPERTY SQLqueryDirection  AS CHAR GET. SET.
  
  DEFINE PUBLIC PROPERTY ABLqueryWhere      AS CHAR GET. SET.
  DEFINE PUBLIC PROPERTY SQLqueryWhere      AS CHAR GET. SET.

  DEFINE PUBLIC PROPERTY ABLquerySort       AS CHAR GET. SET.
  DEFINE PUBLIC PROPERTY SQLquerySort       AS CHAR GET. SET.

  DEFINE PUBLIC PROPERTY SQLdbType          AS CHAR INIT "progressSql" GET. SET.
  DEFINE PUBLIC PROPERTY SQLschema       AS CHAR GET. 
         SET (INPUT icSqlSchema AS CHAR):
           IF SQLDbType NE "MySql" THEN
             SQLschema = icSqlSchema.
         END SET.  
  
  DEFINE PUBLIC PROPERTY SQLdb              AS CHAR GET. 
    SET (INPUT icSqlDb AS CHAR):
      DEF VAR cDbType AS CHAR NO-UNDO.
      cDbType = JBoxDataSourceHelper:Instance:getDataSourceType(icSqlDb).      
      SQLdb = icSqlDb.
      SQLDbType = IF cDbType NE ? THEN cDbType ELSE "progressSql".
      IF CAN-DO("progressSql,sqlexp",SQLDbType) THEN SQLschema = "pub.".       
      IF SQLDbType = "MySql" THEN
        ASSIGN c2Q = "`"
               c2QDot2Q = "`.`".       
    END SET.

  DEFINE PUBLIC PROPERTY SQLfields            AS CHAR GET. SET.

  DEFINE PUBLIC PROPERTY SQLgroupBy           AS CHAR GET. SET.

  DEFINE PUBLIC PROPERTY SQLsumDbFields       AS CHAR GET. SET.
  
  DEFINE PUBLIC PROPERTY SQLnumCalcExpr       AS INT 
    GET:
      DEF VAR iCnt AS INT NO-UNDO.
      FOR EACH ttSqlAccumExpr:
        iCnt = iCnt + 1.
      END.
      RETURN iCnt.  
    END GET.   
    PROTECTED SET.

  DEFINE PUBLIC PROPERTY OEfields             AS CHAR GET. SET.
  
  DEFINE PUBLIC PROPERTY SQLcalcFieldDef      AS CHAR GET. SET.

  DEFINE PUBLIC PROPERTY SQLnotExistBuffers AS CHAR GET. 
    SET (INPUT icNotExistList AS CHAR):
      DEF VAR ix       AS INT NO-UNDO.
      DEF VAR cModList AS CHAR NO-UNDO.
      DO ix = 1 TO NUM-ENTRIES(icNotExistList):
        cModList = cModList + (IF cModList NE "" THEN "," ELSE "") + ENTRY(NUM-ENTRIES(ENTRY(ix,icNotExistList),"."),ENTRY(ix,icNotExistList),".").
      END.  
      SQLnotExistBuffers = cModList.
    END SET.  
  DEFINE PUBLIC PROPERTY SQLnotExistExpr    AS CHAR GET. SET.

  DEFINE PUBLIC PROPERTY SQLcalcFieldWhere  AS CHAR GET. SET. // for calc.field filter that can be sql function (date -> month..)

  DEFINE PUBLIC PROPERTY SQLtimeLimitSec    AS INT GET. SET.

  DEFINE PUBLIC PROPERTY SQLview            AS CHAR GET. 
     SET(icView AS CHAR):
       REPEAT WHILE INDEX(icView,"  ") > 0:
         icView = REPLACE(icView,"  "," ").
       END.   
       SQLview = TRIM(icView).
     END SET.
     
  DEFINE PUBLIC PROPERTY ABLbuffersAndFields AS CHAR GET. 
    SET (INPUT icBuffersAndFields AS CHAR):
      DEF VAR ix AS INT NO-UNDO.
      DEF VAR iy AS INT NO-UNDO.
      DEF VAR cBuffer AS CHAR NO-UNDO.
      DEF VAR cElement AS CHAR NO-UNDO.
      DEF VAR cBufferList AS CHAR NO-UNDO.
      
      DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
        ASSIGN cElement = ENTRY(ix,icBuffersAndFields) 
               cBuffer = ENTRY(1,cElement,";")
               cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + cBuffer
               .
        DO iy = 2 TO NUM-ENTRIES(cElement,";"):
          CREATE ttResultSetFields.
          ASSIGN ttResultSetFields.BufferName = cBuffer
                 ttResultSetFields.FieldName  = ENTRY(1,ENTRY(iy,cElement,";"),"|").
          IF ttResultSetFields.FieldName BEGINS "distinct " THEN ttResultSetFields.FieldName = SUBSTR(ttResultSetFields.FieldName,10).       
          IF ttResultSetFields.FieldName BEGINS "accum " THEN ttResultSetFields.FieldName = SUBSTR(ttResultSetFields.FieldName,7).     
          IF SUBSTR(ttResultSetFields.FieldName,LENGTH(ttResultSetFields.FieldName)) = "_"  AND KEYWORD(TRIM(ttResultSetFields.FieldName,"_")) NE ? THEN
            ttResultSetFields.FieldName = TRIM(ttResultSetFields.FieldName,"_").
        END.    
      END.
      THIS-OBJECT:SQLtableList = cBufferList.
      THIS-OBJECT:SQLprimaryTable = ENTRY(1,cBufferList).
      
    END SET.     

  DEFINE PUBLIC PROPERTY ABLqueryJoin    AS CHAR GET. 
    SET (INPUT icJoin AS CHAR):
      REPEAT WHILE INDEX(icJoin,"  ") > 0:
        icJoin = REPLACE(icJoin,"  "," ").
      END.
      icJoin = REPLACE(icJoin,", FIRST","¤").
      icJoin = REPLACE(icJoin,",FIRST","¤").
      icJoin = REPLACE(icJoin,", EACH","¤").
      icJoin = REPLACE(icJoin,",EACH","¤").
      icJoin = REPLACE(icJoin,", LAST","¤").
      icJoin = REPLACE(icJoin,",LAST","¤").
      ABLqueryJoin = icJoin.
    END.  
  
  DEFINE PUBLIC PROPERTY SQLjoin         AS CHAR GET. 
     SET(icJoin AS CHAR):
       DEF VAR ix AS INT NO-UNDO.
       REPEAT WHILE INDEX(icJoin,"  ") > 0:
         icJoin = REPLACE(icJoin,"  "," ").
       END.   
       SQLjoin = TRIM(icJoin).
       IF SQLtableList = "" THEN
         DO ix = 1 TO NUM-ENTRIES(SQLjoin," "):
           IF CAN-DO("JOIN,OUTER-JOIN,INNER-JOIN",ENTRY(ix,SQLjoin," ")) THEN DO:
             IF NUM-ENTRIES(icJoin," ") > ix + 1 AND ENTRY(ix + 2,SQLjoin," ") = "AS" THEN
               SQLtableList = SQLtableList + "," + ENTRY(ix + 3,SQLjoin," ").
             ELSE  
               SQLtableList = SQLtableList + "," + ENTRY(ix + 1,SQLjoin," ").
           END.  
         END.      
      
     END SET.

  DEF PUBLIC PROPERTY SQLsubQueries AS CHAR GET. SET.
    
  DEFINE PUBLIC PROPERTY hSourceProc     AS HANDLE GET. SET.
  
  DEFINE PUBLIC PROPERTY sqlQueryHelperMessage AS CHAR GET. PROTECTED SET.
		
	CONSTRUCTOR PUBLIC JBoxSqlQueryHelper ():
    hbttSqlPrimaryKey = BUFFER ttSqlPrimaryKey:HANDLE.    
    hbttSqlColumns = BUFFER ttSqlColumns:HANDLE.
    httSqlReadCount = BUFFER ttSqlReadCount:HANDLE.
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE CHARACTER ABL2SQLJoin(  ):
    DEF VAR cSqlJoin   AS CHAR NO-UNDO.
    DEF VAR ix         AS INT  NO-UNDO.
    DEF VAR iy         AS INT  NO-UNDO.
    DEF VAR cElement   AS CHAR NO-UNDO.
    DEF VAR cSub       AS CHAR NO-UNDO.
    DEF VAR cJoin      AS CHAR NO-UNDO.
    DEF VAR cError     AS CHAR NO-UNDO.
    DEF VAR cBuffer    AS CHAR NO-UNDO.
    DEF VAR cRealTable AS CHAR NO-UNDO.
    DEF VAR iSkipY     AS INT  NO-UNDO.    
    DEF VAR cFunction  AS CHAR NO-UNDO.
    DEF VAR cConst     AS CHAR NO-UNDO. 
    DEF VAR cTail      AS CHAR NO-UNDO.
    DEF VAR dDate      AS DATE NO-UNDO.
    DEF VAR cPreSub    AS CHAR NO-UNDO.
    DEF VAR cDbAndBuff AS CHAR NO-UNDO.
    
    
    IF ABLqueryJoin BEGINS "BY " OR TRIM(ABLqueryJoin) = "where false" THEN RETURN "".

    QueryElement:
    DO ix = 1 TO NUM-ENTRIES(THIS-OBJECT:ABLqueryJoin,"¤"):
      cElement = setSqlWhere(ENTRY(ix,THIS-OBJECT:ABLqueryJoin,"¤"),YES).
      cJoin = IF cElement MATCHES "*outer-join*" THEN "LEFT OUTER JOIN" ELSE "JOIN".
      IF cJoin BEGINS "LEFT" THEN cElement = REPLACE(cElement,"outer-join","").
      DO iy = 1 TO NUM-ENTRIES(cElement," "):
        IF iy = iSkipY THEN NEXT.
        ASSIGN cSub = ENTRY(iy,cElement," ")
               cRealTable = ""
               cBuffer = ""
               cFunction = "".
        IF iy = 1 THEN DO:
          cSub = cJoin.
          iSkipY = iy + 1.
          cBuffer = REPLACE(ENTRY(iy + 1,cElement," "),c2Q,'').
          IF NUM-ENTRIES(cBuffer,".") > 1 THEN 
            ASSIGN cDbAndBuff = cBuffer
                   cBuffer = ENTRY(2,cBuffer,".").
          IF CAN-DO(SQLnotExistBuffers,cBuffer) THEN DO:
            ASSIGN SQLnotExistExpr = SQLnotExistExpr + 
                                    (IF SQLnotExistExpr NE "" THEN "AND " ELSE "WHERE ")
                                   + "NOT EXISTS (SELECT * FROM " 
                                   + (IF cDbAndBuff NE "" THEN 
                                        REPLACE(cElement,cDbAndBuff,SQLschema + c2Q + cBuffer + c2Q)
                                      ELSE 
                                        cElement)
                                   + getNotExistQuery(cBuffer)     
                   .
            NEXT QueryElement.       
          END.         
          IF NOT CAN-DO(SQLtableList,cBuffer) THEN
            SQLtableList = SQLtableList + "," + cBuffer.
          IF LENGTH(cBuffer) > 5 AND cBuffer MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(cBuffer,4,2)) THEN 
            cRealTable = SUBSTR(cBuffer,INDEX(cBuffer,"_") + 1).
        END.
        ELSE IF cSub = "WHERE" THEN cSub = "ON".
        ELSE IF cSub = "NO-LOCK" THEN cSub = "".
        ELSE IF cSub = "OF" THEN DO:
          cError = "Invalid expression. ABL OF-relation cannot be resolved to SQL (use WHERE..): " + THIS-OBJECT:ABLqueryJoin.
          LEAVE.
        END.

        IF CAN-DO("=,<>",cSub) THEN DO:
          cPreSub = cSub.
          NEXT.
        END.  
        IF CAN-DO("=,<>",cPreSub) AND cFunction = "" THEN DO: // ***
          IF cSub = "null" OR cSub MATCHES "null)*" THEN 
            cSub = (IF cPreSub = "=" THEN "IS" ELSE "IS NOT") + " " + cSub.
          ELSE
            cSub = cPreSub + " " + cSub. 
          cPreSub = "".  
        END.  
          
        IF cRealTable NE "" THEN cRealTable = SQLschema + c2Q + TRIM(cRealTable,'"') + c2Q.
        ELSE IF cBuffer NE "" THEN cBuffer = SQLschema + c2Q + TRIM(cBuffer,'"') + c2Q.
        
        IF SQLdbType = "mssql" THEN DO:
          IF cFunction BEGINS "INT" OR cFunction BEGINS "DEC" OR cFunction BEGINS "STR" THEN
            cFunction = "CONVERT(VARCHAR,".
        END.
        ELSE DO:
          IF cFunction BEGINS "INT" OR cFunction BEGINS "DEC" OR cFunction BEGINS "STR" THEN
            ASSIGN cFunction = "LTRIM(TO_CHAR("
                   cSub = cSub + ")". 
        END.

        IF CAN-DO("=,<>",cPreSub) THEN // ***
          ASSIGN cFunction = cPreSub + " " + cFunction
                 cPreSub = "".
        
        cSqlJoin = cSqlJoin + (IF cSqlJoin NE "" THEN " " ELSE "")
                 + cFunction
                 + cSub 
                 + (IF cFunction NE "" THEN ")" ELSE "")
                 + (IF cRealTable NE "" THEN " " + cRealTable + " AS " ELSE "")
                 + (IF cBuffer NE "" THEN " " + cBuffer ELSE "")
                 .
      END.  
    END.
    THIS-OBJECT:logToQueryLog("SqlJoin", cSqlJoin).
    IF cError = "" THEN 
      THIS-OBJECT:SQLjoin = cSqlJoin.
    RETURN cError.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PROTECTED CHARACTER realTable( INPUT icTable AS CHAR ):
    
    DEFINE VARIABLE cRealTable AS CHARACTER NO-UNDO.

    IF LENGTH(icTable) > 5 AND icTable MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(icTable,4,2)) THEN 
      cRealTable = SUBSTR(icTable,INDEX(icTable,"_") + 1).
    ELSE
      cRealTable = icTable.  
    
    RETURN cRealTable.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: Return element stripped of enclosing paranthesis
   Notes:   IF the element is a function, keep the inner-most right paranthesis
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE CHARACTER remLeftRightPar(INPUT icElement  AS CHAR
                                          ,INPUT ibFunction AS LOG):
    
    DEF VAR cElement AS CHARACTER NO-UNDO.
    DEF VAR iy       AS INT NO-UNDO.

    ASSIGN cLeftPar = ""
           cRightPar = "".
           
    IF icElement BEGINS "(" THEN DO:
      DO iy = 1 TO LENGTH(icElement):
        IF SUBSTR(icElement,iy,1) = "(" THEN
          cLeftPar = cLeftPar + SUBSTR(icElement,iy,1).
        ELSE DO:
          cElement = SUBSTR(icElement,iy).
          LEAVE.
        END.    
      END.
    END.
    IF icElement MATCHES "*)" THEN DO:
      DO iy = LENGTH(icElement) TO 1 BY -1:
        IF SUBSTR(icElement,iy,1) = ")" THEN
          cRightPar = cRightPar + SUBSTR(icElement,iy,1).
        ELSE DO:
          cElement = SUBSTR(icElement,1,iy + (IF ibFunction THEN 1 ELSE 0)).
          IF ibFunction THEN
            cRightPar = SUBSTR(cRightPar,1,LENGTH(cRightPar) - 1).
          LEAVE.
        END.    
      END.
    END.
    IF cElement = "" THEN cElement = icElement.

    RETURN cElement.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC INTEGER getReadCount(  ):
    DEF VAR ocReturn AS CHAR NO-UNDO.
    DEF VAR bOk      AS LOG  NO-UNDO.

    EMPTY TEMP-TABLE ttSqlReadCount.
    
    RUN jbserv_get_sql_data.p (THIS-OBJECT:SqlDb + "|"
                             + "SELECT COUNT(*) AS ReadCount" 
                             + " FROM " + SQLschema + c2Q + SQLprimaryTable + c2Q + " " 
                             + THIS-OBJECT:SQLjoin + " "
                             + THIS-OBJECT:SQLqueryWhere 
                             ,httSqlReadCount,"",OUTPUT ocReturn,OUTPUT bOk).

    THIS-OBJECT:logToQueryLog("Query count expr", "SELECT COUNT(*) AS ReadCount" 
                             + " FROM " + SQLschema + c2Q + SQLprimaryTable + c2Q + " " 
                             + THIS-OBJECT:SQLjoin + " "
                             + THIS-OBJECT:SQLqueryWhere).

    IF bOk THEN DO:
      FIND FIRST ttSqlReadCount NO-ERROR.
      IF AVAIL ttSqlReadCount THEN
        RETURN ttSqlReadCount.ReadCount.
      ELSE  
        RETURN 0.
    END.     
    ELSE DO:
      THIS-OBJECT:logToQueryLog("Error query count",ocReturn).
      RETURN 0.
    END.  

  END METHOD.
    
  METHOD PUBLIC CHARACTER getCalcFieldsInUse ():
    DEF VAR cReturn AS CHAR NO-UNDO.
    FOR EACH ttSqlCalcField:
      IF SQLgroupBy = "" OR CAN-DO(SQLgroupBy,ttSqlCalcField.CalcFieldName) OR ttSqlCalcField.AccumField THEN
        cReturn = cReturn + (IF cReturn NE "" THEN "," ELSE "") + ttSqlCalcField.CalcFieldName.
    END.
    RETURN cReturn.
  END.  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER getTableField(INPUT icField AS CHAR):
    
    DEFINE VARIABLE cTableField AS CHARACTER NO-UNDO.
    
    DEF BUFFER ttAllSqlColumns FOR TEMP-TABLE ttAllSqlColumns.

    IF NUM-ENTRIES(icField,".") > 1 AND LOOKUP(ENTRY(1,icField,"."),SQLtableList) > 0 THEN DO:
      FIND FIRST ttAllSqlColumns
           WHERE ttAllSqlColumns.AliasName = ENTRY(2,icField,".")
           NO-ERROR.
      IF AVAIL ttAllSqlColumns THEN
        cTableField = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
      ELSE DO:
        FIND FIRST ttAllSqlColumns
             WHERE ttAllSqlColumns.OETableName = ENTRY(1,icField,".")
               AND ttAllSqlColumns.OEFieldName = ENTRY(2,icField,".")
/*             WHERE ttAllSqlColumns.Table_Name = ENTRY(1,icField,".") */
/*               AND ttAllSqlColumns.Column_Name = ENTRY(2,icField,".")*/
             NO-ERROR.
        IF AVAIL ttAllSqlColumns THEN     
          cTableField = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
        ELSE DO:  
          FIND FIRST ttAllSqlColumns
               WHERE ttAllSqlColumns.OEFieldName = ENTRY(2,icField,".")
//               WHERE ttAllSqlColumns.Column_Name = ENTRY(2,icField,".")
               NO-ERROR.
          IF AVAIL ttAllSqlColumns THEN     
            cTableField = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
        END.    
      END.  
    END.
    ELSE DO:
      FIND FIRST ttAllSqlColumns
           WHERE ttAllSqlColumns.AliasName = icField
           NO-ERROR.
      IF AVAIL ttAllSqlColumns THEN
        cTableField = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
      ELSE DO:
        FIND FIRST ttAllSqlColumns
             WHERE ttAllSqlColumns.OEFieldName = icField
//             WHERE ttAllSqlColumns.Column_Name = icField
             NO-ERROR.
        IF AVAIL ttAllSqlColumns THEN     
          cTableField = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
        ELSE DO:
          FIND FIRST ttResultSetFields
               WHERE ttResultSetFields.FieldName = icField
               NO-ERROR.
          IF AVAIL ttResultSetFields THEN
            cTableField = c2Q + icField + c2Q.
        END.    
      END.
    END.    

    RETURN cTableField.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID logToQueryLog( INPUT icLogLabel AS CHAR,
                                    INPUT icLogText AS CHAR):
    
    IF VALID-HANDLE(hSourceProc) AND CAN-DO(hSourceProc:INTERNAL-ENTRIES,"LogThis") THEN
      DYNAMIC-FUNCTION("LogThis" IN hSourceProc,icLogLabel,icLogText,0).
    IF icLogLabel BEGINS "error" THEN
      sqlQueryHelperMessage = icLogLabel + CHR(10) + icLogText.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: re-shape a list of calculated fields on this form
            OrderDate_week;character;jb_weeknum;OrderDate;=,>=,<=;199802|19975|199750,OrderDate_q;character;jb_quarter;OrderDate;;
            To
            OrderDate_week;character;jb_weeknum;OrderDate;=;199741,
            OrderDate_week;character;jb_weeknum;OrderDate;>=;19975,
            OrderDate_week;character;jb_weeknum;OrderDate;<=;199750,            
            OrderDate_q;character;jb_quarter;OrderDate;;
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE CHARACTER reShapeSqlCalcFlds( INPUT icCalcFlds AS CHAR ):
    
    DEF VAR cNewList    AS CHAR NO-UNDO.
    DEF VAR cEntry      AS CHAR NO-UNDO.
    DEF VAR cThisField  AS CHAR NO-UNDO.
    DEF VAR cPrevField  AS CHAR NO-UNDO.
    DEF VAR cOperList   AS CHAR NO-UNDO.
    DEF VAR cValueList  AS CHAR NO-UNDO.
    DEF VAR ix          AS INT  NO-UNDO.
    DEF VAR iy          AS INT  NO-UNDO.

    DO ix = 1 TO NUM-ENTRIES(icCalcFlds,";"):
      IF NUM-ENTRIES(ENTRY(ix,icCalcFlds,";"),",") > 1 AND INDEX(ENTRY(ix,icCalcFlds,";"),"|") = 0 THEN  // this is a list of operators
        ENTRY(ix,icCalcFlds,";") = REPLACE(ENTRY(ix,icCalcFlds,";"),",","¤").
    END.
    DO ix = 1 TO NUM-ENTRIES(icCalcFlds):
      cEntry = ENTRY(ix,icCalcFlds).
      cThisField = "".
      DO iy = 1 TO 4:
        cThisField = cThisField + (IF cThisField NE "" THEN ";" ELSE "") + ENTRY(iy,cEntry,";").
      END.  
      IF NUM-ENTRIES(cEntry,";") > 5 AND 
         NUM-ENTRIES(ENTRY(5,cEntry,";"),"¤") > 1 AND
         NUM-ENTRIES(ENTRY(6,cEntry,";"),"|") = NUM-ENTRIES(ENTRY(5,cEntry,";"),"¤") 
         THEN DO: // add complete definition for each operator / value
        cOperList = ENTRY(5,cEntry,";").  
        cValueList = ENTRY(6,cEntry,";").  
        DO iy = 1 TO NUM-ENTRIES(cOperList,"¤"):
          cNewList = cNewList + "," + cThisField + ";" + ENTRY(iy,cOperList,"¤") + ";" + ENTRY(iy,cValueList,"|").
        END. 
      END.
      ELSE cNewList = cNewList + (IF cNewList NE "" THEN "," ELSE "") + cThisField
                    + (IF NUM-ENTRIES(cEntry,";") > 4 THEN ";" + ENTRY(5,cEntry,";") ELSE "")
                    + (IF NUM-ENTRIES(cEntry,";") > 5 THEN ";" + ENTRY(6,cEntry,";") ELSE "")
                    .
      cPrevField = cThisField.
    END.
    
    RETURN cNewList.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE VOID reShapeSubQueries(  ):
    DEF VAR ix             AS INT NO-UNDO.
    DEF VAR cSubQuery      AS CHAR NO-UNDO.
    DEF VAR cAllSubQueries AS CHAR NO-UNDO.
    
    SQLsubQueries = REPLACE(SQLsubQueries,CHR(3),"").
    SQLsubQueries = REPLACE(SQLsubQueries,CHR(28),"").
    DO ix = 1 TO NUM-ENTRIES(SQLsubQueries):
      cSubQuery = setSqlWhere(ENTRY(ix,SQLsubQueries), YES). // fake join to avoid setting the actual where..
      cAllSubQueries = cAllSubQueries + (IF cAllSubQueries NE "" THEN " AND " ELSE "") + cSubQuery.
    END.  
    SQLsubQueries = cAllSubQueries.
    
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE VOID setCalcFldWhere( INPUT icCalcFld AS CHAR, 
                                       INPUT icFunction AS CHAR,
                                       INPUT icOperator AS CHAR,
                                       INPUT icFilterValue AS CHAR ):

    DEF VAR cAnd AS CHAR NO-UNDO.
    DEF VAR iFilterValue AS INT NO-UNDO.

    FIND FIRST ttSqlCalcFldWhere 
         WHERE ttSqlCalcFldWhere.FieldName = icCalcFld
           AND ttSqlCalcFldWhere.CalcFunction = icFunction
           AND ttSqlCalcFldWhere.CalcOperator = icOperator
         NO-ERROR.
    IF NOT AVAIL ttSqlCalcFldWhere THEN DO:      
      CREATE ttSqlCalcFldWhere.
      ASSIGN ttSqlCalcFldWhere.FieldName = icCalcFld
             ttSqlCalcFldWhere.CalcFunction = icFunction
             ttSqlCalcFldWhere.CalcOperator = icOperator
             .
      IF CAN-DO(JB_to_SQL_datefunc,icFunction) THEN DO:
        IF CAN-DO("begins,matches",icOperator) THEN icOperator = "=".
        icFilterValue = TRIM(icFilterValue,"'").
        IF LENGTH(icFilterValue) GE 4 THEN DO:
//          IF CAN-DO("<,>",icOperator) THEN icOperator = icOperator + "=".      
          ASSIGN ttSqlCalcFldWhere.WhereClause = 'YEAR(' + icCalcFld + ') ' + icOperator + ' ' + SUBSTR(icFilterValue,1,4)
                 icFilterValue = TRIM(SUBSTR(icFilterValue,5),"*")
                 cAnd = " AND ".
        END.         
        ELSE         
          icFilterValue = TRIM(icFilterValue,"*").
        
        icFilterValue = REPLACE(icFilterValue,"Q","").  
          
        iFilterValue = INT(icFilterValue) NO-ERROR.
        icFilterValue = STRING(iFilterValue).  
                   
        IF iFilterValue > 0 THEN                              
          CASE icFunction:
            WHEN "jb_weeknum" OR WHEN "jb_weeknum_dt" OR WHEN "jb_weeknum_ww" OR WHEN "jb_weeknum_dt_ww" THEN DO:
              CASE THIS-OBJECT:SQLdbType:
                WHEN "mssql" THEN 
                  ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'convert(varchar(2),DATEPART(iso_week,' + icCalcFld + ')) ' + icOperator + " " + CHR(39) + icFilterValue + CHR(39).
                WHEN "mysql" THEN 
                  ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'WEEK(' + icCalcFld + ') ' + icOperator + " " + icFilterValue.
                OTHERWISE 
                  ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'ISOWEEK(' + icCalcFld + ') ' + icOperator + " " + icFilterValue.
              END CASE.
            END.  
            WHEN "jb_month" OR WHEN "jb_month_dt" OR WHEN "jb_month_mm" OR WHEN "jb_month_dt_mm" THEN 
              ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'MONTH(' + icCalcFld + ') ' + icOperator + " " + icFilterValue.

            WHEN "jb_quarter" OR WHEN "jb_quarter_dt"  OR WHEN "jb_quarter_q" OR WHEN "jb_quarter_dt_q" THEN 
              CASE icFilterValue:
                WHEN "1" THEN 
                  ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'MONTH(' + icCalcFld + ') >= 1 AND MONTH(' + icCalcFld + ') <= 3'.
                WHEN "2" THEN 
                  ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'MONTH(' + icCalcFld + ') >= 4 AND MONTH(' + icCalcFld + ') <= 6'.
                WHEN "3" THEN 
                  ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'MONTH(' + icCalcFld + ') >= 7 AND MONTH(' + icCalcFld + ') <= 9'.
                WHEN "4" THEN 
                  ttSqlCalcFldWhere.WhereClause = ttSqlCalcFldWhere.WhereClause + cAnd + 'MONTH(' + icCalcFld + ') >= 10'.
              END CASE.  
          END.
        ELSE IF icFilterValue = ? THEN
         ttSqlCalcFldWhere.WhereClause = icCalcFld + " IS NULL".         
      END.
      ELSE IF CAN-DO(JB_to_SQL_otherfunc,icFunction) THEN DO:
        CASE icFunction:
          WHEN "jb_calc" THEN 
            ttSqlCalcFldWhere.WhereClause = icCalcFld + " " + icOperator + " " + icFilterValue.
        END CASE.  
      END.  
    END.    
    
    RETURN.
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PRIVATE CHARACTER getSQLfunction( INPUT icCalcFld AS CHAR, 
                                           INPUT icJboxFunction AS CHAR):

    DEF VAR cSqlFunction AS CHAR NO-UNDO.

    CASE THIS-OBJECT:SQLdbType:
      WHEN "mssql" THEN 
        CASE icJboxFunction:
          WHEN "jb_weeknum" OR WHEN "jb_weeknum_dt" THEN cSqlFunction = 'convert(varchar(4),' + icCalcFld + ', 112) + convert(varchar(2),DATEPART(iso_week,' + icCalcFld + '))'.
          WHEN "jb_weeknum_ww" OR WHEN "jb_weeknum_dt_ww" THEN cSqlFunction = 'convert(varchar(2),DATEPART(iso_week,' + icCalcFld + '))'.
          WHEN "jb_month" OR WHEN "jb_month_dt" THEN cSqlFunction = 'convert(varchar(6),' + icCalcFld + ', 112)'. 
          WHEN "jb_month_mm" OR WHEN "jb_month_dt_mm" THEN cSqlFunction = 'convert(varchar(2),DATEPART(MM,' + icCalcFld + '))'.
          WHEN "jb_quarter" OR WHEN "jb_quarter_dt" THEN cSqlFunction = 'convert(varchar(4),' + icCalcFld + ', 112) + ' + CHR(39) + 'Q' + CHR(39) + ' + convert(varchar(2),DATEPART(q,' + icCalcFld + '))'.
          WHEN "jb_quarter_q" OR WHEN "jb_quarter_dt_q" THEN cSqlFunction = 'convert(varchar(2),DATEPART(q,' + icCalcFld + '))'.
          WHEN "jb_year" OR WHEN "jb_year_dt" THEN cSqlFunction = 'convert(varchar(4),' + icCalcFld + ', 112)'. 
        END CASE.
      WHEN "mysql" THEN
        CASE icJboxFunction:
          WHEN "jb_weeknum" OR WHEN "jb_weeknum_dt" THEN
            cSqlFunction = 'CAST(YEARWEEK(' + icCalcFld + ') AS CHAR)'. 
          WHEN "jb_weeknum_ww" OR WHEN "jb_weeknum_dt_ww" THEN
            cSqlFunction = 'CAST(WEEK(' + icCalcFld + ') AS CHAR)'. 
          WHEN "jb_month" OR WHEN "jb_month_dt" THEN
            cSqlFunction = 'CAST(DATE_FORMAT(' + icCalcFld + ',' + CHR(39) + '%Y%m' + CHR(39) + ') AS CHAR)'.
          WHEN "jb_month_mm" OR WHEN "jb_month_dt_mm" THEN 
            cSqlFunction = 'CAST(DATE_FORMAT(' + icCalcFld + ',' + CHR(39) + '%m' + CHR(39) + ') AS CHAR)'.
          WHEN "jb_quarter" OR WHEN "jb_quarter_dt" THEN 
            cSqlFunction = 'CONCAT(CONCAT(CAST(YEAR(' + icCalcFld + ') AS CHAR),' + CHR(39) + 'Q' + CHR(39) + '),CAST(QUARTER(' + icCalcFld + ') AS CHAR))'. 
          WHEN "jb_quarter_q" OR WHEN "jb_quarter_dt_q" THEN 
            cSqlFunction = 'CAST(QUARTER(' + icCalcFld + ') AS CHAR)'. 
          WHEN "jb_year" OR WHEN "jb_year_dt" THEN 
            cSqlFunction = 'CAST(DATE_FORMAT(' + icCalcFld + ',' + CHR(39) + '%Y' + CHR(39) + ') AS CHAR)'. 
        END CASE.
      OTHERWISE 
        CASE icJboxFunction:
          WHEN "jb_weeknum" OR WHEN "jb_weeknum_dt" THEN
            cSqlFunction = 'TO_CHAR(' + icCalcFld + ',' + CHR(39) + 'YYYY' + CHR(39) + ') + LTRIM(TO_CHAR(ISOWEEK(' + icCalcFld + ')))'. 
          WHEN "jb_weeknum_ww" OR WHEN "jb_weeknum_dt_ww" THEN
            cSqlFunction = 'LTRIM(TO_CHAR(ISOWEEK(' + icCalcFld + ')))'. 
          WHEN "jb_month" OR WHEN "jb_month_dt" THEN
            cSqlFunction = 'TO_CHAR(' + icCalcFld + ',' + CHR(39) + 'YYYYMM' + CHR(39) + ')'.
          WHEN "jb_month_mm" OR WHEN "jb_month_dt_mm" THEN 
            cSqlFunction = 'TO_CHAR(' + icCalcFld + ',' + CHR(39) + 'MM' + CHR(39) + ')'.
          WHEN "jb_quarter" OR WHEN "jb_quarter_dt" THEN 
            cSqlFunction = 'TO_CHAR(' + icCalcFld + ',' + CHR(39) + 'YYYY' + CHR(39) + ') + ' + CHR(39) + 'Q' + CHR(39) + ' + TO_CHAR(' + icCalcFld + ',' + CHR(39) + 'Q' + CHR(39)  + ')'. 
          WHEN "jb_quarter_q" OR WHEN "jb_quarter_dt_q" THEN 
            cSqlFunction = 'TO_CHAR(' + icCalcFld + ',' + CHR(39) + 'Q' + CHR(39)  + ')'. 
          WHEN "jb_year" OR WHEN "jb_year_dt" THEN 
            cSqlFunction = 'TO_CHAR(' + icCalcFld + ',' + CHR(39) + 'YYYY' + CHR(39) + ')'. 
        END CASE.
    END CASE.    
    
    RETURN cSqlFunction.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose: If no view or join def given from client the bufferlist must be set 
            prior to creating the result-set buffer (ref FinalizeCreateQuery)
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setSqlBuffersAndFields( INPUT icBuffersAndFields AS CHAR ):
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR cBufferList AS CHAR NO-UNDO.
    DEF VAR cElement    AS CHAR NO-UNDO.
    
    cBufferList = ENTRY(1,icBuffersAndFields,";").
    IF ABLqueryJoin NE "" THEN DO:
      DO ix = 2 TO NUM-ENTRIES(ABLqueryJoin,"¤"):
        cElement = ENTRY(2,ENTRY(ix,ABLqueryJoin,"¤")," ").
        IF NUM-ENTRIES(cElement,".") > 1 THEN cElement = ENTRY(2,cElement,".").
        cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + cElement.
      END.
    END.  
    ELSE  
      DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields):
        cElement = ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
        IF NUM-ENTRIES(cElement,".") > 1 THEN cElement = ENTRY(2,cElement,".").
        cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + cElement.
      END.
    THIS-OBJECT:SQLtableList = cBufferList.
    THIS-OBJECT:SQLprimaryTable = ENTRY(1,cBufferList).
    
    // If any duplicate field for query appear 1st time in a buffer other than first buffer
    // the only way to specify it correctly is if it was referred from the client:
    DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields,";"):
      cElement = ENTRY(ix,icBuffersAndFields,";").
      CREATE ttResultSetFields.
             ttResultSetFields.FieldName  = ENTRY(1,cElement,"|").
      IF NUM-ENTRIES(cElement,"|") > 5 AND ENTRY(6,cElement,"|") NE "" THEN DO:
        IF ENTRY(6,cElement,"|") BEGINS "NOT EXIST " THEN DO:
          ttResultSetFields.BufferName = TRIM(SUBSTR(ENTRY(6,cElement,"|"),11)).
          IF NOT CAN-DO(SQLnotExistBuffers,ttResultSetFields.BufferName) THEN
            SQLnotExistBuffers = SQLnotExistBuffers + (IF SQLnotExistBuffers NE "" THEN "," ELSE "")
                               + ttResultSetFields.BufferName.
        END.         
        ELSE  
          ttResultSetFields.BufferName = ENTRY(6,cElement,"|").
      END.  
      ELSE
        ttResultSetFields.BufferName = ENTRY(1,cBufferList).
      IF ttResultSetFields.FieldName BEGINS "distinct " THEN ttResultSetFields.FieldName = SUBSTR(ttResultSetFields.FieldName,10).       
      IF ttResultSetFields.FieldName BEGINS "accum " THEN ttResultSetFields.FieldName = SUBSTR(ttResultSetFields.FieldName,7).     
      IF SUBSTR(ttResultSetFields.FieldName,LENGTH(ttResultSetFields.FieldName)) = "_"  AND KEYWORD(TRIM(ttResultSetFields.FieldName,"_")) NE ? THEN
        ttResultSetFields.FieldName = TRIM(ttResultSetFields.FieldName,"_").
        
    END.

/*    def var hh as handle no-undo.        */
/*    hh = buffer ttResultSetFields:handle.*/
/*    run toexcelviafile.p (hh,-2).        */
    RETURN.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC CHARACTER setSqlView( INPUT ihResultTTBuffer AS HANDLE ):
    
    DEFINE VARIABLE cReturn  AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ix       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE iy       AS INT       NO-UNDO.
    DEF VAR iz               AS INT       NO-UNDO.
    DEF VAR ii               AS INT       NO-UNDO.
    DEF VAR cPkFields        AS CHAR      NO-UNDO.
    DEF VAR cSqlPkFields     AS CHAR      NO-UNDO.
    DEF VAR cFields          AS CHAR      NO-UNDO.
    DEF VAR ocReturn         AS CHAR      NO-UNDO.
    DEF VAR bOkSchema        AS LOG       NO-UNDO.
    DEF VAR cPKey            AS CHAR      NO-UNDO.
    DEF VAR hFld             AS HANDLE    NO-UNDO.
    DEF VAR cRealTable       AS CHAR      NO-UNDO.
    DEF VAR cFieldDef        AS CHAR      NO-UNDO.
    DEF VAR cGrpPkFields     AS CHAR      NO-UNDO.
    DEF VAR cAvgField        AS CHAR      NO-UNDO.
    DEF VAR cModGroupBy      AS CHAR      NO-UNDO.
    DEF VAR cCalcGroupBy     AS CHAR      NO-UNDO.
    DEF VAR cCalcFld         AS CHAR      NO-UNDO.
    DEF VAR cCalc2Where      AS CHAR      NO-UNDO.
    DEF VAR cModFields       AS CHAR      NO-UNDO.
    DEF VAR bIsGroupField    AS LOG       NO-UNDO.
    DEF VAR bIsSumField      AS LOG       NO-UNDO.
    DEF VAR cTop             AS CHAR      NO-UNDO.
    DEF VAR cLimit           AS CHAR      NO-UNDO.
    DEF VAR cTableAlias      AS CHAR      NO-UNDO.
    DEF VAR cCalcFldParam    AS CHAR      NO-UNDO.
    DEF VAR cCalcFldSrcTable AS CHAR      NO-UNDO.
    DEF VAR cCalcFldSrcField AS CHAR      NO-UNDO.
    DEF VAR cCalcFldName     AS CHAR      NO-UNDO.
    DEF VAR cCalcFldFilter   AS CHAR      NO-UNDO.
    DEF VAR cCalcFldFunction AS CHAR      NO-UNDO.

    ASSIGN hSourceProc = SOURCE-PROCEDURE
           SQLfields = ""
           .
    
    IF VALID-HANDLE(ihResultTTBuffer) THEN DO:  
      IF SQLtableList = "" THEN 
        SQLtableList = ihResultTTBuffer:NAME.
      ELSE IF NOT CAN-DO(SQLtableList,ihResultTTBuffer:NAME) THEN
        SQLtableList = ihResultTTBuffer:NAME + "," + SQLtableList.
    END.    
    THIS-OBJECT:logToQueryLog("SQLtableList",SQLtableList).
    IF NOT CAN-DO("TABLE_CONSTRAINTS,CONSTRAINT_COLUMN_USAGE",SQLtableList) THEN DO ix = 1 TO NUM-ENTRIES(SQLtableList):
      
      EMPTY TEMP-TABLE ttSqlPrimaryKey.
      EMPTY TEMP-TABLE ttSqlColumns.
      cPKey = "".
      cRealTable = ENTRY(ix,SQLtableList).
      
      IF NUM-ENTRIES(cRealTable,".") > 1 THEN cRealTable = ENTRY(2,cRealTable,".").
      cTableAlias = cRealTable.
      
      cRealTable = realTable(cRealTable).
      iy = 0.

      bOkSchema = JBoxSqlSchemaHelper:Instance:getTableColumns(THIS-OBJECT:SQLdb,hbttSqlColumns,cRealTable).
      IF NOT bOkSchema THEN 
        THIS-OBJECT:logToQueryLog("Error getting Sql fields:",cRealTable + " - " + JBoxSqlSchemaHelper:Instance:sqlSchemaMessage).  
      
      CASE THIS-OBJECT:SQLdbType:
        WHEN "ProgressSql" OR WHEN "sqlexp" THEN DO:
          IF SQLgroupBy = "" AND  NOT CAN-DO(SQLnotExistBuffers,cRealTable) THEN
            ASSIGN cPkFields = cPkFields + (IF cPkFields NE "" THEN "," ELSE "") + c2Q + cRealTable + c2Q + ".ROWID AS RowIdent" + STRING(ix) + ""
                   cSqlPkFields = cSqlPkFields + (IF cSqlPkFields NE "" THEN "," ELSE "") + "RowIdent" + STRING(ix).
        END.             
        OTHERWISE DO: // mssql doesn't have rowid so we need to try to figure out what else is unique (to use as rowid)
          bOkSchema = JBoxSqlSchemaHelper:Instance:getPrimaryKey(THIS-OBJECT:SQLdb,hbttSqlPrimaryKey,cRealTable).
          IF bOkSchema THEN DO: 
            FOR EACH ttSqlPrimaryKey: 
              IF ttSqlPrimaryKey.Column_Name BEGINS "PROGRESS_RECID" THEN DELETE ttSqlPrimaryKey.
              ELSE 
                iy = iy + 1. 
            END.
            FOR EACH ttSqlPrimaryKey:
              cPKey = cPKey + (IF cPKey NE "" THEN "," ELSE IF iy > 1 THEN "CONCAT_WS('" + CHR(1) + "'," ELSE "") + c2Q + ENTRY(ix,SQLtableList) + c2Q + "." + c2Q + ttSqlPrimaryKey.Column_Name + c2Q.
            END.
            IF iy > 1 THEN cPKey = cPKey + ")".
          END.
          ELSE IF THIS-OBJECT:SQLdbType = "mssql" AND JBoxSqlSchemaHelper:Instance:sqlSchemaMessage = "0" AND NUM-ENTRIES(SQLtableList) = 1 THEN
            cPKey = "sys.fn_PhysLocFormatter(" + SQLprimaryTable + ".%%physloc%%)".
          ELSE DO:
            cReturn = "Error - missing Sql primary or unique key for " + cRealTable + CHR(10)
//                    + "You may browse the table as a single table but it cannot be used in joins"
                    .
            THIS-OBJECT:logToQueryLog("Error Sql Primary key:",cRealTable + " - " + JBoxSqlSchemaHelper:Instance:sqlSchemaMessage).
            RETURN cReturn.
          END.    
          IF SQLgroupBy = "" AND NOT CAN-DO(SQLnotExistBuffers,cRealTable) THEN 
            ASSIGN cPkFields = cPkFields + (IF cPkFields NE "" THEN "," ELSE "") + cPKey + " AS RowIdent" + STRING(ix) + ""
                   cSqlPkFields = cSqlPkFields + (IF cSqlPkFields NE "" THEN "," ELSE "") + "RowIdent" + STRING(ix).
        END.
      END.      
    
      // Common handling from here (further branching on dbtype is done in the methods - except for group-by with mssql):
      
      FOR EACH ttSqlCalcField
          WHERE ttSqlCalcField.ParamFldSourceTable = cTableAlias
          :
        
        IF ttSqlCalcField.JBoxFunction = "jb_calc" THEN DO: // whatever.. sql functions, or an expression

          
          IF allowedExpr(ttSqlCalcField.ParamFldOrExpr) AND 
             (SQLgroupBy = "" OR CAN-DO(SQLgroupBy,ttSqlCalcField.CalcFieldName) OR ttSqlCalcField.AccumField) THEN DO:
          
            FIND FIRST ttSqlAccumExpr WHERE ttSqlAccumExpr.CalcFieldName = ttSqlCalcField.CalcFieldName NO-ERROR.
            
            cCalcFld = (IF AVAIL ttSqlAccumExpr THEN "sum(" ELSE "") 
                     + ttSqlCalcField.SQLfunction
                     + addQuotes(ttSqlCalcField.ParamFldOrExpr) 
                     + (IF AVAIL ttSqlAccumExpr THEN ")" ELSE "")
                     + " AS " + c2Q + ttSqlCalcField.CalcFieldName + c2Q
                     .
            IF LOOKUP(cCalcFld,cFields,"|") = 0 THEN  // otherwise the field will be repeated for each table..         
              ASSIGN cFields = cFields + (IF cFields NE "" THEN "|" ELSE "") + cCalcFld
    
                     cAvgField = (IF cAvgField = "" AND NUM-ENTRIES(SQLsumDbFields) + SQLnumCalcExpr = 2 THEN
                                    "avg(" + addQuotes(ttSqlCalcField.ParamFldOrExpr) + ") AS jbAverage" 
                                  ELSE cAvgField)
                           .
          END.
          ELSE logToQueryLog("Blocked sql expr",ttSqlCalcField.ParamFldOrExpr).
        END.     
        ELSE IF SQLgroupBy = "" /* OR CAN-DO(SQLgroupBy,ttSqlCalcField.CalcFieldName) */ THEN DO: // date/time conversion 
          cCalcFld = getSQLfunction(c2Q + cTableAlias + c2QDot2Q + ttSqlCalcField.ParamFldOrExpr + c2Q, // here: parameter field
                                    ttSqlCalcField.JBoxFunction). 
          IF cCalcFld NE "" THEN
            ASSIGN cFields = cFields + (IF cFields NE "" THEN "|" ELSE "")
                           + cCalcFld
                           + " AS " + c2Q + ttSqlCalcField.CalcFieldName + c2Q
                   SQLfields = SQLfields + (IF SQLfields NE "" THEN "," ELSE "") + ttSqlCalcField.CalcFieldName.
                   
        END.
        FOR EACH ttSqlCalcFieldFilter
            WHERE ttSqlCalcFieldFilter.CalcFieldName = ttSqlCalcField.CalcFieldName:
          IF ttSqlCalcField.JBoxFunction = "jb_calc" THEN
            setCalcFldWhere(ttSqlCalcField.SQLfunction + addQuotes(ttSqlCalcField.ParamFldOrExpr),
                            ttSqlCalcField.JBoxFunction, 
                            ttSqlCalcFieldFilter.SQLoperator, 
                            ttSqlCalcFieldFilter.FilterValue).
          ELSE                  
            setCalcFldWhere(addQuotes(cTableAlias + "." + ttSqlCalcField.ParamFldOrExpr),
                            ttSqlCalcField.JBoxFunction, 
                            ttSqlCalcFieldFilter.FilterOperator, 
                            ttSqlCalcFieldFilter.FilterValue).
        END.                    
      END.  
        
      cCalcGroupBy = "".
      IF ix = 1 THEN cModGroupBy = REPLACE(SQLgroupBy,",","¤").
      DO iz = 1 TO NUM-ENTRIES(cModGroupBy,"¤"):
        DO ii = 1 TO NUM-ENTRIES(SQLcalcFieldDef):
          cCalcGroupBy = "".
          IF ENTRY(iz,cModGroupBy,"¤") = ENTRY(1,ENTRY(ii,SQLcalcFieldDef),";")
             AND ENTRY(1,ENTRY(4,ENTRY(ii,SQLcalcFieldDef),";"),".") = cRealTable THEN DO:
            FIND FIRST ttSqlColumns 
                 WHERE ttSqlColumns.Column_Name = ENTRY(2,ENTRY(4,ENTRY(ii,SQLcalcFieldDef),";"),".")
                 NO-ERROR.
            IF AVAIL ttSqlColumns THEN DO:      
              cCalcGroupBy = getSQLfunction(c2Q + cRealTable + c2QDot2Q + ttSqlColumns.Column_Name + c2Q, // parameter field
                                            ENTRY(3,ENTRY(ii,SQLcalcFieldDef),";")).   // function
              IF cCalcGroupBy NE "" THEN
                ASSIGN cFields = cFields + (IF cFields NE "" THEN "|" ELSE "")
                               + cCalcGroupBy
                               + " AS " + c2Q + ENTRY(iz,cModGroupBy,"¤") + c2Q
                       SQLfields = SQLfields + (IF SQLfields NE "" THEN "," ELSE "") + ENTRY(iz,cModGroupBy,"¤")
                       .
              ELSE IF cCalcGroupBy NE "" AND cFields MATCHES "*" + cCalcGroupBy + " AS " + ENTRY(iz,cModGroupBy,"¤") + "*" THEN
                cCalcGroupBy = "".
            END.         
          END.  
          // mssql cannot use field name in group by expression but rather the full function definition
          IF THIS-OBJECT:SQLdbType = "mssql" AND cCalcGroupBy NE "" THEN ENTRY(iz,cModGroupBy,"¤") = cCalcGroupBy.
        END.
      END.
      iy = 0.
         
      IF bOkSchema OR (JBoxSqlSchemaHelper:Instance:sqlSchemaMessage = "0" AND NUM-ENTRIES(SQLtableList) = 1) THEN  
        FOR EACH ttSqlColumns:
          CREATE ttAllSqlColumns.
          ASSIGN ttAllSqlColumns.Table_Name  = ENTRY(ix,SQLtableList)
                 ttAllSqlColumns.Column_Name = ttSqlColumns.Column_Name
                 ttAllSqlColumns.Data_Type   = ttSqlColumns.Data_Type
                 ttAllSqlColumns.OEFieldName = ttSqlColumns.OEFieldName
                 ttAllSqlColumns.OETableName = ttSqlColumns.OETableName
                 ttAllSqlColumns.TableSeqNo  = ix
                 iy                          = iy + 1
                 .
          IF ix = 1 AND iy = 1 THEN SQLschema = (IF ttSqlColumns.Table_Catalog NE "" THEN ttSqlColumns.Table_Catalog + "." ELSE "") + c2Q + ttSqlColumns.Table_Schema + c2Q + ".".       
        END.
      IF ix > 1 AND NOT (ENTRY(ix,SQLtableList) MATCHES "buf*_*" AND CAN-DO("1_,2_,3_,4_,5_,6_,7_,8_,9_",SUBSTR(ENTRY(ix,SQLtableList),4,2))) THEN
        THIS-OBJECT:SQLjoin = REPLACE(THIS-OBJECT:SQLjoin," " + ENTRY(ix,SQLtableList) + " "," " + SQLschema + ENTRY(ix,SQLtableList) + " ").                               

    END. // table loop                           

    IF THIS-OBJECT:SQLjoin = "" THEN DO:
      cReturn = THIS-OBJECT:abl2sqlJoin().
      IF cReturn NE "" THEN RETURN cReturn.
    END.  

    SQLgroupBy = REPLACE(cModGroupBy,"¤",",").

    addTableToSqlGroupBy(SQLgroupBy).

    FOR EACH ttAllSqlColumns
        BY ttAllSqlColumns.TableSeqNo:
          
      ASSIGN bIsGroupField = CAN-DO(SQLgroupBy,ttAllSqlColumns.Table_Name + "." + ttAllSqlColumns.Column_Name) OR 
                             CAN-DO(SQLgroupBy,ttAllSqlColumns.Table_Name + "." + ttAllSqlColumns.Column_Name + STRING(ttAllSqlColumns.TableSeqNo))
             bIsSumField   = CAN-DO(SQLsumDbFields,ttAllSqlColumns.Table_Name + "." + ttAllSqlColumns.Column_Name) OR
                             CAN-DO(SQLsumDbFields,ttAllSqlColumns.Table_Name + "." + ttAllSqlColumns.Column_Name + STRING(ttAllSqlColumns.TableSeqNo))
                             .                 
          
      IF (SQLgroupBy NE "" AND NOT bIsGroupField AND NOT bIsSumField) OR CAN-DO(SQLnotExistBuffers, ttAllSqlColumns.Table_Name) THEN NEXT.

      FIND FIRST ttResultSetFields
           WHERE ttResultSetFields.FieldName = ttAllSqlColumns.Column_Name
             AND ttResultSetFields.BufferName = ttAllSqlColumns.Table_Name
             AND NOT ttResultSetFields.MappedToSql
           NO-ERROR.
      IF AVAIL ttResultSetFields THEN DO:
        IF THIS-OBJECT:SQLdbType = "mssql" AND ttAllSqlColumns.Data_Type = "datetime" THEN
          cFields = cFields + "|CONVERT(VARCHAR," + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ",126)"
                            + " AS " + c2Q 
                            + ttResultSetFields.FieldName + c2Q.
        ELSE IF THIS-OBJECT:SQLdbType NE "mssql" AND ttAllSqlColumns.Data_Type = "date" THEN
          cFields = cFields + "|TO_CHAR(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ","
                            + (IF CAN-DO("dmy,european",SESSION:DATE-FORMAT) THEN "'dd/mm/yyyy')" ELSE "'mm/dd/yyyy')")
                            + " AS " + c2Q 
                            + ttResultSetFields.FieldName + c2Q.
        ELSE                    
          ASSIGN cFields = cFields + "|"
                     + (IF bIsSumField THEN "sum(" + c2Q ELSE c2Q)
                     + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q
                     + (IF bIsSumField THEN ") AS " + c2Q + ttResultSetFields.FieldName + c2Q ELSE '') 
                 cAvgField = (IF cAvgField = "" AND NUM-ENTRIES(SQLsumDbFields) + SQLnumCalcExpr = 2 AND bIsSumField THEN
                               "avg(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ") AS jbAverage" 
                              ELSE cAvgField)        
                     .
      END.       
      ELSE DO:   
        FIND FIRST ttResultSetFields
             WHERE ttResultSetFields.FieldName = ttAllSqlColumns.Column_Name + STRING(ttAllSqlColumns.TableSeqNo)
               AND ttResultSetFields.BufferName = ttAllSqlColumns.Table_Name
               AND NOT ttResultSetFields.MappedToSql
             NO-ERROR.
        IF AVAIL ttResultSetFields THEN DO:
          ttAllSqlColumns.AliasName = ttResultSetFields.FieldName.
          
          IF THIS-OBJECT:SQLdbType = "mssql" AND ttAllSqlColumns.Data_Type = "datetime" THEN
            cFields = cFields + "|CONVERT(VARCHAR," + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ",126)"
                              + " AS " + c2Q 
                              + ttResultSetFields.FieldName + c2Q.
          ELSE IF THIS-OBJECT:SQLdbType NE "mssql" AND ttAllSqlColumns.Data_Type = "date" THEN
            cFields = cFields + "|TO_CHAR(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ","
                              + (IF CAN-DO("dmy,european",SESSION:DATE-FORMAT) THEN "'dd/mm/yyyy')" ELSE "'mm/dd/yyyy')")
                              + " AS " + c2Q 
                              + ttResultSetFields.FieldName + c2Q.
          ELSE                    
            ASSIGN cFields = cFields + "|"
                       + (IF bIsSumField THEN "sum(" ELSE "") + c2Q
                       + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q
                       + (IF bIsSumField THEN ")" ELSE "") + " AS " + c2Q + ttResultSetFields.FieldName + c2Q 
                   cAvgField = (IF cAvgField = "" AND NUM-ENTRIES(SQLsumDbFields) + SQLnumCalcExpr = 2 AND bIsSumField THEN
                                 "avg(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ") AS jbAverage" 
                                ELSE cAvgField)        
                       .
        END.       
        ELSE DO:   

          FIND FIRST ttResultSetFields
               WHERE ttResultSetFields.FieldName = ttAllSqlColumns.Column_Name
                 AND ttResultSetFields.BufferName = ""
                 AND NOT ttResultSetFields.MappedToSql
               NO-ERROR.
                              
          IF NOT AVAIL ttResultSetFields THEN DO:    
            FIND FIRST ttResultSetFields
                 WHERE ttResultSetFields.FieldName = ttAllSqlColumns.Column_Name + STRING(ttAllSqlColumns.TableSeqNo)
                   AND ttResultSetFields.BufferName = ""
                   AND NOT ttResultSetFields.MappedToSql
                 NO-ERROR.
            IF AVAIL ttResultSetFields THEN DO:
              ttAllSqlColumns.AliasName = ttResultSetFields.FieldName.
              IF THIS-OBJECT:SQLdbType = "mssql" AND ttAllSqlColumns.Data_Type = "datetime" THEN
                cFields = cFields + "|CONVERT(VARCHAR," + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ",126)"
                                  + " AS " + c2Q 
                                  + ttResultSetFields.FieldName + c2Q.
              ELSE IF THIS-OBJECT:SQLdbType NE "mssql" AND ttAllSqlColumns.Data_Type = "date" THEN
                cFields = cFields + "|TO_CHAR(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ","
                                  + (IF CAN-DO("dmy,european",SESSION:DATE-FORMAT) THEN "'dd/mm/yyyy')" ELSE "'mm/dd/yyyy')")
                                  + " AS " + c2Q 
                                  + ttResultSetFields.FieldName + c2Q.
              ELSE 
                ASSIGN cFields = cFields + "|"
                               + (IF bIsSumField THEN "sum(" ELSE "") + c2Q
                               + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name 
                               + (IF bIsSumField THEN c2Q + ") AS " + c2Q ELSE c2Q + " AS ") 
                               + ttResultSetFields.FieldName + c2Q
                       cAvgField = (IF cAvgField = "" AND NUM-ENTRIES(SQLsumDbFields) + SQLnumCalcExpr = 2 AND bIsSumField THEN
                                      "avg(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ") AS jbAverage" 
                                    ELSE cAvgField)        
                       .     
            END.         
          END.
          ELSE DO: 
            IF THIS-OBJECT:SQLdbType = "mssql" AND ttAllSqlColumns.Data_Type = "datetime" THEN
              cFields = cFields + "|CONVERT(VARCHAR," + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ",126)"
                                + " AS " + c2Q 
                                + ttResultSetFields.FieldName + c2Q.
            ELSE IF THIS-OBJECT:SQLdbType NE "mssql" AND ttAllSqlColumns.Data_Type = "date" THEN
              cFields = cFields + "|TO_CHAR(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ","
                                + (IF CAN-DO("dmy,european",SESSION:DATE-FORMAT) THEN "'dd/mm/yyyy')" ELSE "'mm/dd/yyyy')")
                                + " AS " + c2Q 
                                + ttResultSetFields.FieldName + c2Q.
            ELSE                    
              ASSIGN cFields = cFields + "|"
                         + (IF bIsSumField THEN "sum(" ELSE "") + c2Q
                         + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q
                         + (IF bIsSumField THEN ") AS " + c2Q + ttResultSetFields.FieldName + c2Q ELSE '')
                     // average only when there is 1 field to accumulate:      
                     cAvgField = (IF cAvgField = "" AND NUM-ENTRIES(SQLsumDbFields) + SQLnumCalcExpr = 2 AND bIsSumField THEN
                                   "avg(" + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + ") AS jbAverage" 
                                  ELSE cAvgField)        
                         .
          END.
        END.               
      END.
                  
      IF AVAIL ttResultSetFields THEN
        ASSIGN ttResultSetFields.MappedToSql = YES
               ttAllSqlColumns.MappedToOE = YES
               SQLfields = SQLfields + "," + ttResultSetFields.FieldName
               .
    END.    
    
    IF SQLgroupBy NE "" THEN 
      ASSIGN cFields = cFields + (IF cAvgField NE "" THEN "|" + cAvgField ELSE "") 
             SQLfields = SQLfields + ",jbCountDistinct" + (IF cAvgField NE "" THEN ",jbAverage" ELSE "").
        
    ASSIGN cFields = TRIM(cPkFields,",") + "," + TRIM(REPLACE(cFields,"|",","),",")
           SQLfields = TRIM(TRIM(cSqlPkFields,",") + "," + TRIM(SQLfields,","),",").
           
    IF SQLgroupBy NE "" THEN cFields = cFields + ", count(*) as jbCountDistinct".       

    reShapeSubQueries(). // Can be done now since we have the schema
    
    IF THIS-OBJECT:SQLdbType = "MySql" THEN
      ASSIGN SQLschema = ""
             cFields = REPLACE(cFields,'"',c2Q)
             cLimit  = (IF SQLrowsToBatch > 1 AND SQLgroupBy = "" THEN " LIMIT 0" /* + STRING(SQLstartRow)*/ + "," + STRING(SQLstartRow + SQLrowsToBatch)
                        ELSE IF SQLrowsToBatch = 1 AND SQLgroupBy = "" THEN " LIMIT 1" 
                        ELSE "")
             .
    ELSE
      cTop = (IF SQLrowsToBatch > 0 AND SQLgroupBy = "" THEN "TOP " + STRING(SQLstartRow + SQLrowsToBatch) ELSE "").         

    IF SQLprimaryTable = "CONSTRAINT_COLUMN_USAGE" THEN  
      ASSIGN SQLview = "SELECT CONCAT(Table_Name,',',Column_Name) AS RowIdent1,Column_Name,Table_Name FROM INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE " 
              + THIS-OBJECT:setSqlSort(THIS-OBJECT:ABLquerySort)
              SQLfields = "RowIdent1,Table_Name,Column_Name" 
              .
    ELSE
      SQLview = "SELECT " 
              + cTop // (IF SQLrowsToBatch > 0 AND SQLgroupBy = "" THEN "TOP " + STRING(SQLstartRow + SQLrowsToBatch) ELSE "")
              + " " + TRIM(cFields,",")
//              + " " + cModFields
              + " FROM " + SQLschema + c2Q + SQLprimaryTable + c2Q + " " 
              + THIS-OBJECT:SQLjoin + " "
              + THIS-OBJECT:setSqlWhere(THIS-OBJECT:ABLqueryWhere,NO) + " " 
              + THIS-OBJECT:setSqlGroupBy(THIS-OBJECT:SQLgroupBy) +  " "
              + THIS-OBJECT:setSqlSort(THIS-OBJECT:ABLquerySort)
              + cLimit 
              .
     
     IF NOT allowedExpr(SQLview) THEN SQLview = "".
     
     RETURN cReturn.

     CATCH eErr AS Progress.Lang.Error :
       MESSAGE eErr:GetMessage(1)
       VIEW-AS ALERT-BOX.  
     END CATCH.
  END METHOD.

  METHOD PUBLIC LOGICAL createSqlView():
    RETURN THIS-OBJECT:setSqlView(?) = "". 
  END METHOD.  

  METHOD PUBLIC LOGICAL fillTempTable (INPUT ihbTempTable AS HANDLE
                                      ,INPUT icSessionId  AS CHAR):
             
    DEF VAR bOk       AS LOG NO-UNDO.
    DEF VAR ocReturn  AS CHAR NO-UNDO.
             
    IF SQLtimeLimitSec NE 0 THEN 
      DO STOP-AFTER SQLtimeLimitSec + 1 ON STOP UNDO, LEAVE:
        RUN jbserv_get_sql_data.p (SQLdb + "|" + THIS-OBJECT:SQLview + "||" + THIS-OBJECT:SQLfields + "|" + THIS-OBJECT:getCalcFieldsInUse() + "|" + STRING(SQLtimeLimitSec) 
                                  ,ihbTempTable,icSessionId,OUTPUT ocReturn,OUTPUT bOk).
      END.
    ELSE  
      RUN jbserv_get_sql_data.p (SQLdb + "|" + THIS-OBJECT:SQLview + "||" + THIS-OBJECT:SQLfields + "|" + THIS-OBJECT:getCalcFieldsInUse() 
                                ,ihbTempTable,icSessionId,OUTPUT ocReturn,OUTPUT bOk).

    IF NOT bOk THEN DO:
      sqlQueryHelperMessage = ocReturn.
      logToQueryLog("Error from fillTempTable",ocReturn).
    END.                                
                                       
    RETURN bOk.                                   
  END METHOD.                                     

  METHOD PUBLIC LOGICAL fillTempTable(INPUT ihbTempTable AS HANDLE):
    RETURN THIS-OBJECT:fillTempTable(ihbTempTable,"").                            
  END METHOD.  
  
  METHOD PUBLIC VOID addAccumCalcExpr (INPUT icCalcFieldName AS CHAR
                                      ,INPUT icExpr          AS CHAR):
    FIND FIRST ttSqlAccumExpr
         WHERE ttSqlAccumExpr.CalcFieldName = icCalcFieldName
         NO-ERROR.
    IF NOT AVAIL ttSqlAccumExpr THEN DO:
      CREATE ttSqlAccumExpr.
      ttSqlAccumExpr.CalcFieldName = icCalcFieldName.
    END.
    ttSqlAccumExpr.CalcExpr = icExpr.                                    
  END METHOD.                                      

  METHOD PUBLIC VOID addCalcFieldDef (INPUT icCalcFieldName    AS CHAR
                                     ,INPUT icParamFldSrcTable AS CHAR
                                     ,INPUT icCalcFieldType    AS CHAR
                                     ,INPUT icJBoxFunction     AS CHAR
                                     ,INPUT icSQLfunction      AS CHAR
                                     ,INPUT icParamOrExpr      AS CHAR
                                     ,INPUT ibAccumField       AS LOG):
    FIND FIRST ttSqlCalcField
         WHERE ttSqlCalcField.CalcFieldName       = icCalcFieldName
         NO-ERROR.
    IF NOT AVAIL ttSqlCalcField THEN DO:
      CREATE ttSqlCalcField.
      ttSqlCalcField.CalcFieldName       = icCalcFieldName.
    END.  
    ASSIGN ttSqlCalcField.ParamFldSourceTable = icParamFldSrcTable
           ttSqlCalcField.CalcFieldType       = icCalcFieldType
           ttSqlCalcField.JBoxFunction        = icJBoxFunction
           ttSqlCalcField.SQLfunction         = icSQLfunction
           ttSqlCalcField.ParamFldOrExpr      = REPLACE(icParamOrExpr,"\002C",",")
           ttSqlCalcField.AccumField          = ibAccumField
           .
    IF NUM-ENTRIES(icParamOrExpr," ") = 1 AND NUM-ENTRIES(icParamOrExpr,".") = 2 AND ENTRY(1,icParamOrExpr,".") = icParamFldSrcTable THEN
      ttSqlCalcField.ParamFldOrExpr = ENTRY(2,icParamOrExpr,".").       
  END METHOD.                                      

  METHOD PUBLIC VOID addCalcFieldFilter (INPUT icCalcFieldName    AS CHAR
                                        ,INPUT icFilterOperator   AS CHAR
                                        ,INPUT icFilterValue      AS CHAR):
                                          
    FIND FIRST ttSqlCalcField
         WHERE ttSqlCalcField.CalcFieldName = icCalcFieldName
         NO-ERROR.                                          
    FIND FIRST ttSqlCalcFieldFilter
         WHERE ttSqlCalcFieldFilter.CalcFieldName  = icCalcFieldName
           AND ttSqlCalcFieldFilter.FilterOperator = icFilterOperator
         NO-ERROR.
    IF NOT AVAIL ttSqlCalcFieldFilter THEN DO:
      CREATE ttSqlCalcFieldFilter.
      ASSIGN ttSqlCalcFieldFilter.CalcFieldName  = icCalcFieldName
             ttSqlCalcFieldFilter.FilterOperator = icFilterOperator
             .
    END.
    IF AVAIL ttSqlCalcField THEN DO: 
      IF ttSqlCalcField.CalcFieldType = "decimal" THEN
        ttSqlCalcFieldFilter.FilterValue = STRING(convertDecimal(icFilterValue)).
      ELSE IF ttSqlCalcField.CalcFieldType = "character" THEN DO:
        ASSIGN ttSqlCalcFieldFilter.FilterValue = TRIM(icFilterValue,'"')
               ttSqlCalcFieldFilter.FilterValue = TRIM(icFilterValue,"'")
               .
        IF icFilterOperator = "BEGINS" THEN
          icFilterValue = icFilterValue + '%'.
                 
        ASSIGN ttSqlCalcFieldFilter.FilterValue = REPLACE(icFilterValue,"*","%")
               ttSqlCalcFieldFilter.FilterValue = "'" + icFilterValue + "'"
               .
      END.         
    END.  
    ELSE         
      ttSqlCalcFieldFilter.FilterValue = icFilterValue.
      
    IF CAN-DO("begins,matches",icFilterOperator) THEN ttSqlCalcFieldFilter.SQLoperator = "LIKE".
    ELSE ttSqlCalcFieldFilter.SQLoperator = icFilterOperator.  

  END METHOD.
  
  METHOD PUBLIC CHARACTER analyseSqlView (INPUT ihResultTTBuffer AS HANDLE):
    DEF VAR ocReturn AS CHAR NO-UNDO.
    DEF VAR bOk      AS LOG  NO-UNDO.
    DEF VAR cDbName  AS CHAR NO-UNDO.
    DEF VAR cView    AS CHAR NO-UNDO.

    /* The best I could do to overcome binding error because of views cataloged with incorrect databasename: */
    RUN jbserv_get_sql_data.p (THIS-OBJECT:SqlDb + "|getOverriddenDbName",?,"",OUTPUT cDbName,OUTPUT bOk).

    EMPTY TEMP-TABLE ttSqlColumns.
    RUN jbserv_get_sql_data.p (THIS-OBJECT:SqlDb + "|"
                             + (IF cDbName NE "" THEN "SELECT SCHEMA_NAME(t.schema_id) as 'Table_Schema'"
                                ELSE "SELECT db_name() + '.' + SCHEMA_NAME(t.schema_id) as 'Table_Schema'")
                             + ", c.name  AS 'Column_Name' "
                             + ", s.name  AS 'Data_Type' "
                             + "FROM sys.columns c JOIN sys.views t ON c.object_id = t.object_id JOIN sys.types s ON c.system_type_id = s.system_type_id "
                             + "WHERE t.name = '" + THIS-OBJECT:SQLview + "'"  
                              ,hbttSqlColumns,"",OUTPUT ocReturn,OUTPUT bOk).
//    run toexcelviafile.p (hbttSqlColumns,-2).         
    IF NOT bOk THEN RETURN ocReturn.
 
    FOR EACH ttSqlColumns:
      CREATE ttAllSqlColumns.
      ASSIGN ttAllSqlColumns.Table_Name  = THIS-OBJECT:SQLview
             ttAllSqlColumns.Column_Name = ttSqlColumns.Column_Name
             .
    END.         
 
    FIND FIRST ttSqlColumns.
    THIS-OBJECT:SQLview = "SELECT " 
                        + (IF SQLrowsToBatch > 0 THEN "TOP " + STRING(SQLstartRow + SQLrowsToBatch) ELSE "")
                        + (IF THIS-OBJECT:ABLquerySort NE "" THEN " ROW_NUMBER() OVER (" + THIS-OBJECT:setSqlSort(THIS-OBJECT:ABLquerySort) + ") AS RowIdent1,*" ELSE " *") 
                        + " FROM " + (IF cDbName NE "" THEN cDbName + "." ELSE "") + ttSqlColumns.Table_Schema + "." + THIS-OBJECT:SQLview + " "
                        + THIS-OBJECT:setSqlWhere(THIS-OBJECT:ABLqueryWhere,NO) + " " 
                        .    


//   run toexcelviafile.p (hbttSqlColumns,-2).
    RETURN ocReturn.    
  END METHOD.   

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

  METHOD PUBLIC VOID setNotExistQuery (INPUT icBufferName AS CHAR
                                      ,INPUT icNotExistQuery AS CHAR):
    FIND FIRST ttNotExistQuery
         WHERE ttNotExistQuery.TableName = icBufferName
         NO-ERROR.
    IF NOT AVAIL ttNotExistQuery THEN CREATE ttNotExistQuery.
    ASSIGN ttNotExistQuery.TableName = icBufferName
           ttNotExistQuery.QueryString = TRIM(icNotExistQuery).                                        
  END.                                        

  METHOD PRIVATE CHARACTER getNotExistQuery (INPUT icBufferName AS CHAR):
    DEF VAR cExpr AS CHAR NO-UNDO.
    FIND FIRST ttNotExistQuery
         WHERE ttNotExistQuery.TableName = icBufferName
         NO-ERROR.         
    IF AVAIL ttNotExistQuery THEN DO:
      cExpr = setSqlWhere(ttNotExistQuery.QueryString,YES). // fake join;)
      IF cExpr BEGINS "WHERE " THEN
        RETURN "AND " + SUBSTR(cExpr,7).
      ELSE  
        RETURN cExpr.
    END.
    RETURN "".                                          
  END.                                        

  METHOD PRIVATE CHARACTER setSqlWhere( INPUT ic4GLqueryWhere AS CHAR
                                       ,INPUT ibJoin          AS LOG ):
    DEF VAR ix              AS INT  NO-UNDO.
    DEF VAR cElement        AS CHAR NO-UNDO.
    DEF VAR cPrevElement    AS CHAR NO-UNDO.
    DEF VAR cWHERE          AS CHAR NO-UNDO.
    DEF VAR dDate           AS DATE NO-UNDO.
    DEF VAR dDateTime       AS DATETIME NO-UNDO.
    DEF VAR cSkipIx         AS CHAR NO-UNDO.
    DEF VAR cCurrSqlFldType AS CHAR NO-UNDO.
    DEF VAR cTail           AS CHAR NO-UNDO.
    DEF VAR bStartText      AS LOG  NO-UNDO.
    DEF VAR bEndText        AS LOG  NO-UNDO.
    DEF VAR cStartElement   AS CHAR NO-UNDO.
    DEF VAR iy              AS INT  NO-UNDO.
    DEF VAR cTableFld       AS CHAR NO-UNDO.
    DEF VAR cSubQbuffPrefix AS CHAR NO-UNDO.
    
    REPEAT WHILE INDEX(ic4GLqueryWhere,"  ") > 0:
      ic4GLqueryWhere = REPLACE(ic4GLqueryWhere,"  "," ").
    END.
    ic4GLqueryWhere = TRIM(ic4GLqueryWhere,",").
    ic4GLqueryWhere = REPLACE(ic4GLqueryWhere,CHR(10),"").
    ic4GLqueryWhere = REPLACE(ic4GLqueryWhere," AND TRUE"," ").
      
    IF NOT ibJoin AND SQLnotExistExpr NE "" THEN
      cWHERE = SQLnotExistExpr + " notexistAND".

    DO ix = 1 TO NUM-ENTRIES(ic4GLqueryWhere," "):
      cElement = ENTRY(ix,ic4GLqueryWhere," ").
      dDate = ?.
      cLeftPar = "".
      cRightPar = "".
      IF LENGTH(cElement) > 1 THEN DO:
        
        IF cElement BEGINS '"' THEN 
          cElement = "'" + SUBSTR(cElement,2).
        IF SUBSTR(cElement,LENGTH(cElement)) = '"' THEN 
          cElement = SUBSTR(cElement,1,LENGTH(cElement) - 1) + "'".
        ELSE IF SUBSTR(cElement,LENGTH(cElement)) = '")' THEN 
          cElement = SUBSTR(cElement,1,LENGTH(cElement) - 2) + "')".
          
        IF (LENGTH(cElement) = 8 OR LENGTH(cElement) = 10) AND (NUM-ENTRIES(cElement,"/") = 3 OR NUM-ENTRIES(cElement,".") = 3) THEN DO:
          dDate = DATE(cElement) NO-ERROR.
          IF NOT ERROR-STATUS:ERROR THEN
            cElement = "'" + STRING(YEAR(dDate),"9999") + "-" + STRING(MONTH(dDate),"99") + "-" + STRING(DAY(dDate),"99") + "'".
        END.  
        IF NOT bStartText THEN bStartText = SUBSTR(cElement,1,1) = "'".
        
        bEndText = SUBSTR(cElement,LENGTH(cElement)) = "'" OR SUBSTR(cElement,LENGTH(cElement) - 1) = "')".
        
        IF bStartText AND NOT bEndText THEN DO:
          cStartElement = cStartElement + (IF cStartElement NE "" THEN " " ELSE "") + cElement.
          NEXT.
        END. 
        ELSE IF bStartText AND bEndText AND cStartElement NE "" THEN 
          cElement = cStartElement + " " + cElement.
      END.
      ELSE IF bStartText THEN DO:
        cStartElement = cStartElement + (IF cStartElement NE "" THEN " " ELSE "") + cElement.
        NEXT.
      END.
            
      ASSIGN cStartElement = ""    
             bStartText = NO
             bEndText = NO
             cLeftPar = ""
             cRightPar = ""
             .
      
      IF ix < NUM-ENTRIES(ic4GLqueryWhere," ") AND ENTRY(ix + 1,ic4GLqueryWhere," ") = '?' THEN
        ASSIGN cElement = IF CAN-DO("=,EQ",cElement) THEN "IS" ELSE "IS NOT"
               cPrevElement = cElement
               .
      ELSE IF cElement = "?" AND CAN-DO("IS,IS NOT",cPrevElement) THEN
        cElement = "NULL".         
      ELSE IF CAN-DO("BEGINS,MATCHES",cElement) THEN
        ASSIGN cPrevElement = cElement 
               cElement = "LIKE"
               .
      ELSE IF cElement = "GE" THEN
        ASSIGN cElement = ">="
               .
      ELSE IF cElement = "LE" THEN
        ASSIGN cElement = "<="
               .
      ELSE IF cElement = "NE" THEN
        ASSIGN cElement = "<>"
               .
      ELSE IF cElement = "EQ" THEN
        ASSIGN cElement = "="
               .
      ELSE IF cElement BEGINS "DATE(" OR cElement MATCHES "(*DATE(*" THEN DO:
        IF cElement MATCHES "(*DATE(*" THEN cElement = remLeftRightPar(cElement,YES).
        ASSIGN cPrevElement = ""
               cTail    = SUBSTR(cElement,INDEX(cElement,")") + 1)
               cElement = SUBSTR(cElement,INDEX(cElement,"(") + 2)
               cElement = SUBSTR(cElement,1,INDEX(cElement,")") - 1)
               .
        dDate = DATE(cElement) NO-ERROR.
        IF dDate = ? THEN cElement = "null".
        ELSE cElement = cLeftPar + "'" + ISO-DATE(dDate) + "'" + cTail.
      END.         
      ELSE IF cElement BEGINS "DATETIME(" OR cElement MATCHES "(*DATETIME(*" THEN DO:
        IF cElement MATCHES "(*DATETIME(*" THEN cElement = remLeftRightPar(cElement,YES).

        cElement = SUBSTR(cElement,INDEX(cElement,"(") + 2).

        IF cElement BEGINS "TODAY" THEN 
          cElement = cLeftPar + "'" + STRING(ISO-DATE(TODAY))
                   + " 00:00:00'" + cRightPar.
        ELSE IF cElement MATCHES ('*)') OR cRightPar NE "" THEN DO:
          cElement = RIGHT-TRIM(cElement,")").
          cElement = RIGHT-TRIM(cElement,"'").
          cElement = RIGHT-TRIM(cElement,'"').
          
          dDateTime    = DATE(cElement) NO-ERROR.
          IF dDateTime = ? THEN cElement = "null".
          ELSE 
            cElement = cLeftPar + "'" + REPLACE(STRING(ISO-DATE(dDateTime)),"T"," ") + "'" + cRightPar.
        END.  
        ELSE DO:
          dDateTime    = DATE(cElement) NO-ERROR.
          IF dDateTime = ? THEN cElement = "null".
          ELSE 
            ASSIGN cElement     = ""
                   cPrevElement = cLeftPar + "DATETIME('" + STRING(YEAR(dDateTime),"9999") // datetime is just a tag..
                                                    + "-" + STRING(MONTH(dDateTime),"99")
                                                    + "-" + STRING(DAY(dDateTime),"99")
                                                    + " "
                   .
        END.           
      END.         
      ELSE IF cElement BEGINS "DECIMAL(" OR cElement MATCHES "(*DECIMAL(*" THEN DO:
        IF cElement MATCHES "(*DECIMAL(*" THEN cElement = remLeftRightPar(cElement,YES).
        ASSIGN cTail    = SUBSTR(cElement,INDEX(cElement,")") + 1)
               cElement = RIGHT-TRIM(SUBSTR(cElement,INDEX(cElement,"(") + 1),")") + cTail
               .
        IF cElement BEGINS "'" THEN DO:
          cElement = REPLACE(cElement,"'","").       
          IF INDEX(cElement,".") > 0 AND INDEX(cElement,",") > INDEX(cElement,".") THEN
            ASSIGN cElement = REPLACE(cElement,".","")
                   cElement = REPLACE(cElement,",",".").        
          ELSE IF INDEX(cElement,",") > 0 AND INDEX(cElement,".") > INDEX(cElement,",") THEN
            cElement = REPLACE(cElement,",","").
          ELSE IF SESSION:DATE-FORMAT = "european" THEN
            cElement = REPLACE(cElement,",",".").
        END.
        ELSE DO:
          cTableFld = getTableField(cElement).
          IF cTableFld NE ""  THEN
            cElement = CHR(123) + ' fn CONVERT("' + REPLACE(cElement,'.',c2QDot2Q) + '",SQL_DECIMAL)' + CHR(125).
        END.       
            
        IF cElement = "?" THEN cElement = "null".
        ELSE cElement = cLeftPar + cElement.       
      END.         
      ELSE IF cElement BEGINS "INTEGER(" OR cElement BEGINS "INT64(" OR cElement MATCHES "(*INTEGER(*" OR cElement MATCHES "(*INT64(*" THEN DO:
        IF cElement MATCHES "(*INTEGER(*" OR cElement MATCHES "(*INT64(*" THEN cElement = remLeftRightPar(cElement,YES). 
        ASSIGN cTail    = SUBSTR(cElement,INDEX(cElement,")") + 1)
               cElement = RIGHT-TRIM(SUBSTR(cElement,INDEX(cElement,"(") + 1),")") + cTail
               .
        IF cElement BEGINS "'" THEN 
          cElement = REPLACE(cElement,"'","").       
        ELSE DO:
          cTableFld = getTableField(cElement).
          IF cTableFld NE ""  THEN
            cElement = CHR(123) + ' fn CONVERT("' + REPLACE(cElement,'.',c2QDot2Q) + '",SQL_INTEGER)' + CHR(125).
        END.       
            
        IF cElement = "?" THEN cElement = "null".       
        ELSE cElement = cLeftPar + cElement.
      END.         
      ELSE IF cElement BEGINS "LOGICAL(" OR cElement MATCHES "(*LOGICAL(*" THEN DO:
        IF cElement MATCHES "(*LOGICAL(*" THEN cElement = remLeftRightPar(cElement,YES).
        cTail    = SUBSTR(cElement,INDEX(cElement,")") + 1).
        IF cCurrSqlFldType = "bit" THEN
          ASSIGN cElement     = IF CAN-DO("n,f",SUBSTR(cElement,10,1)) THEN "0" ELSE "1"
                 .
        ELSE
          ASSIGN cElement     = IF CAN-DO("n,f",SUBSTR(cElement,10,1)) THEN "0" ELSE "1"
                 .
        cElement = cLeftPar + cElement + cTail.
      END.          
      ELSE IF cElement BEGINS "STRING(" OR cElement MATCHES "(*STRING(*" THEN DO:
        IF cElement MATCHES "(*STRING(*" THEN cElement = remLeftRightPar(cElement,YES).
        ASSIGN cTail    = SUBSTR(cElement,INDEX(cElement,")") + 1)
               cElement = RIGHT-TRIM(SUBSTR(cElement,INDEX(cElement,"(") + 1),")") + cTail
               cTableFld = getTableField(cElement).
               .
        IF cTableFld NE ""  THEN
          cElement = CHR(123) + ' fn CONVERT("' + REPLACE(cElement,'.',c2QDot2Q) + '",SQL_VARCHAR)' + CHR(125).
            
        IF cElement = "?" THEN cElement = "null".
        ELSE cElement = cLeftPar + cElement.       
      END.          
      ELSE IF cElement BEGINS "CAN-DO(" OR cElement MATCHES "(*CAN-DO(*" THEN DO:
        IF cElement MATCHES "(*CAN-DO(*" THEN cElement = remLeftRightPar(cElement,YES).
        ASSIGN cTail     = SUBSTR(cElement,INDEX(cElement,")") + 1)
               cTableFld = ENTRY(NUM-ENTRIES(cElement),cElement) 
               cElement  = TRIM(SUBSTR(cElement,INDEX(cElement,"(") + 1),cTableFld + ",")
               cElement  = cLeftPar + getTableField(TRIM(cTableFld,")")) + " IN (" + REPLACE(cElement,",","','") + ")" + cTail
               .
      END.         
      ELSE IF cElement BEGINS "LOOKUP(" OR cElement MATCHES "(*LOOKUP(*" THEN DO:
        IF cElement MATCHES "(*LOOKUP(*" THEN cElement = remLeftRightPar(cElement,YES).
        ASSIGN cPrevElement = cElement
               cPrevElement = "LOOKUP2(" + getTableField(ENTRY(1,ENTRY(2,cElement,"(")))
                            + " <¤> IN (" 
                            + REPLACE(SUBSTR(cElement,INDEX(cElement,"'"),R-INDEX(cPrevElement,"'")),",","','")
               cPrevElement = cLeftPar + cPrevElement             
                            .
        NEXT.       
      END.  
      ELSE IF cPrevElement BEGINS "LOOKUP2(" THEN DO:
        ASSIGN cTail = cElement
               cElement = SUBSTR(cPrevElement,INDEX(cPrevElement,"(") + 1)
               cPrevElement = "LOOKUP3("
               .
        IF CAN-DO("=,<,lt",cTail) THEN 
          cElement = REPLACE(cElement,"<¤>","NOT").
        ELSE       
          cElement = REPLACE(cElement,"<¤> ","").
      END.  
      ELSE IF cPrevElement BEGINS "LOOKUP3(" THEN DO:
        cPrevElement = "".
        NEXT.
      END.  
        
      ELSE IF cPrevElement = "BEGINS" THEN DO:
        IF cElement MATCHES "*)" THEN DO:
          DO iy = LENGTH(cElement) TO 1 BY -1:
            IF SUBSTR(cElement,iy,1) = ")" THEN
              cRightPar = cRightPar + SUBSTR(cElement,iy,1).
            ELSE DO:
              cElement = SUBSTR(cElement,1,iy).
              LEAVE.
            END.    
          END.
        END.
        cPrevElement = "".
        cTableFld = getTableField(cElement).
        IF cTableFld = "" THEN
          cElement = SUBSTR(cElement,1,R-INDEX(cElement,"'") - 1) + "%'" + cRightPar.
        ELSE
          cElement = "CONCAT(" + cTableFld + ",'%')" + cRightPar.       
      END.         
      ELSE IF cPrevElement = "MATCHES" AND NOT ibJoin THEN DO:
        IF cElement MATCHES "*)" THEN DO:
          DO iy = LENGTH(cElement) TO 1 BY -1:
            IF SUBSTR(cElement,iy,1) = ")" THEN
              cRightPar = cRightPar + SUBSTR(cElement,iy,1).
            ELSE DO:
              cElement = SUBSTR(cElement,1,iy).
              LEAVE.
            END.    
          END.
        END.
        ASSIGN cPrevElement = ""
               cElement = REPLACE(cElement,"*","%") + cRightPar
               .
      END.         
      ELSE IF cPrevElement BEGINS "DATETIME(" THEN DO: 
        IF cElement MATCHES "*))" THEN DO:
          DO iy = LENGTH(cElement) TO 1 BY -1:
            IF SUBSTR(cElement,iy,1) = ")" THEN
              cRightPar = cRightPar + SUBSTR(cElement,iy,1).
            ELSE DO:
              cElement = SUBSTR(cElement,1,iy).
              LEAVE.
            END.    
          END.
        END.
         
        ASSIGN cRightPar = IF LENGTH(cRightPar) > 1 THEN SUBSTR(cRightPar,2) ELSE "" // if one ) then it's from datetime(..)
               cElement = SUBSTR(cPrevElement,10) + RIGHT-TRIM(REPLACE(REPLACE(ENTRY(1,cElement),",",":"),")",""),"'") + "'" + cRightPar
               cElement = REPLACE(cElement,CHR(1) + "000","")
               cPrevElement = ""
               .
      END.         
      ELSE IF cPrevElement = "IS" AND cElement = "'?'" THEN 
        ASSIGN cElement = "null"
               cPrevElement = ""
               .
      ELSE IF cElement = "FROM" AND ibJoin THEN
        cPrevElement = cElement.         
      ELSE IF cPrevElement = "FROM" AND ibJoin THEN
        ASSIGN cElement = SQLschema + c2Q + cElement + c2Q
               cPrevElement = "".         
      ELSE IF cElement BEGINS "nox_" AND NUM-ENTRIES(cElement,".") = 1 AND ibJoin THEN
        cElement = c2Q + cElement + c2Q.         
      ELSE DO:
        cPrevElement = "".
        
        IF cElement MATCHES "*__*" THEN cElement = "[" + REPLACE(cElement,"__"," ") + "]". /* Blank in sql field name - can appear in views */
        IF cElement MATCHES "*_" THEN cElement = RIGHT-TRIM(cElement,"_"). /*Progress reserved has an added _ */

        IF NUM-ENTRIES(cElement,".") > 1 AND 
           (LOOKUP(LEFT-TRIM(ENTRY(1,cElement,"."),"("),SQLtableList) > 0 
         OR (ibJoin AND ENTRY(1,cElement,".") BEGINS "nox_" AND LOOKUP(SUBSTR(ENTRY(1,cElement,"."),5),SQLtableList) > 0)) THEN DO:
          IF ENTRY(1,cElement,".") BEGINS "nox_" THEN
            ASSIGN cSubQbuffPrefix = "nox_"
                   cElement = SUBSTR(cElement,5).
          ELSE            
            ASSIGN cSubQbuffPrefix = ""
                   cElement = remLeftRightPar(cElement,NO).
          FIND FIRST ttAllSqlColumns
               WHERE ttAllSqlColumns.Table_Name = ENTRY(1,cElement,".")
                 AND ttAllSqlColumns.AliasName = ENTRY(2,cElement,".")
               NO-ERROR.
          IF NOT AVAIL ttAllSqlColumns THEN     
            FIND FIRST ttAllSqlColumns
                 WHERE ttAllSqlColumns.Table_Name = ENTRY(1,cElement,".")
                   AND ttAllSqlColumns.Column_Name = ENTRY(2,cElement,".")
                 NO-ERROR.
          IF NOT AVAIL ttAllSqlColumns THEN DO:     
            FIND FIRST ttAllSqlColumns
                 WHERE ttAllSqlColumns.AliasName = ENTRY(2,cElement,".")
                 NO-ERROR.
            IF AVAIL ttAllSqlColumns THEN
              ASSIGN cElement = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q
                     cCurrSqlFldType = ttAllSqlColumns.Data_Type
                     .
            ELSE DO:
              FIND FIRST ttAllSqlColumns
                   WHERE ttAllSqlColumns.Column_Name = ENTRY(2,cElement,".")
                   NO-ERROR.
              IF AVAIL ttAllSqlColumns THEN     
                ASSIGN cElement = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q
                       cCurrSqlFldType = ttAllSqlColumns.Data_Type
                       .
              ELSE
                ASSIGN cSkipIx = cSkipIx + "," + STRING(ix + 1) + "," + STRING(ix + 2)
                       cElement = "<skipped>".
            END.           
          END.
          ELSE  
            ASSIGN cElement = c2Q + cSubQbuffPrefix + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q
                   cCurrSqlFldType = ttAllSqlColumns.Data_Type
                   .
          cElement = cLeftPar + cElement + cRightPar.         
        END.
        ELSE /* IF NUM-ENTRIES(SQLtableList) = 1 THEN */ DO: /* find field datatype for view or single table */
          FIND FIRST ttAllSqlColumns
               WHERE ttAllSqlColumns.Column_Name = LEFT-TRIM(cElement,"(")
               NO-ERROR.
          IF AVAIL ttAllSqlColumns THEN DO:    
           cElement = remLeftRightPar(cElement,NO).
            ASSIGN cElement = cLeftPar + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q + cRightPar
                   cCurrSqlFldType = ttAllSqlColumns.Data_Type
                   .
          END.         
          ELSE IF LEFT-TRIM(cElement,"(") BEGINS "[" THEN DO:
            FIND FIRST ttSqlColumns 
                 WHERE ttSqlColumns.Column_Name = RIGHT-TRIM(SUBSTR(LEFT-TRIM(cElement,"("),2),"]")
                 NO-ERROR.
            IF AVAIL ttSqlColumns THEN DO:
              cCurrSqlFldType = ttSqlColumns.Data_Type.
              FIND FIRST ttAllSqlColumns
                   WHERE ttAllSqlColumns.Column_Name = LEFT-TRIM(cElement,"(")
                   NO-ERROR.
              IF AVAIL ttAllSqlColumns THEN DO:    
                cElement = remLeftRightPar(cElement,NO).
                ASSIGN cElement = cLeftPar + c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + cElement + c2Q + cRightPar
                       cCurrSqlFldType = ttAllSqlColumns.Data_Type
                       .
              END.         
            END.  
          END.         
        END.  
      END.
      
      IF cElement = "null" THEN DO:
        cWHERE = TRIM(cWHERE).
        IF NOT CAN-DO("IS,NOT",ENTRY(NUM-ENTRIES(cWHERE," "),cWHERE," ")) THEN DO:
          IF ENTRY(NUM-ENTRIES(cWHERE," "),cWHERE," ") = "=" THEN ENTRY(NUM-ENTRIES(cWHERE," "),cWHERE," ") = "IS".
          ELSE ENTRY(NUM-ENTRIES(cWHERE," "),cWHERE," ") = "IS NOT".
        END.
        cWHERE = cWHERE + " ".  
      END.
      IF NOT ibJoin AND SQLnotExistExpr NE "" AND cWhere MATCHES "* notexistAND" THEN
        cWHERE = REPLACE(cWhere,"notexistAND",") AND ").
      ELSE  
        cWHERE = cWHERE + REPLACE(cElement,CHR(1),",") + " ".      
    END.  
    IF cWHERE = "where true" THEN cWHERE = "".
    
    IF NOT ibJoin THEN DO:
      IF SQLnotExistExpr NE "" AND cWhere MATCHES "* notexistAND" THEN
        cWHERE = REPLACE(cWhere,"notexistAND",")").
        
      FOR EACH ttSqlCalcFldWhere:
        cWhere = cWhere + (IF cWhere NE "" THEN " AND " ELSE "WHERE ") + ttSqlCalcFldWhere.WhereClause.
      END.
      IF SQLsubQueries NE "" THEN  
        cWhere = cWHERE + (IF cWhere NE "" THEN " AND " ELSE " WHERE ") + SQLsubQueries.
      THIS-OBJECT:SQLqueryWhere = cWHERE.
      THIS-OBJECT:logToQueryLog("SqlWhere", cWHERE).
    END.
      
    RETURN cWHERE.
  END METHOD.  

  METHOD PRIVATE CHARACTER setSqlSort( INPUT ic4GLQuerySort AS CHAR ):
    
    DEF VAR ix            AS INT NO-UNDO.
    DEF VAR iy            AS INT NO-UNDO.
    DEF VAR cORDER        AS CHAR NO-UNDO.
    DEF VAR cSqlOrder     AS CHAR NO-UNDO.
    DEF VAR cElement      AS CHAR NO-UNDO.
    DEF VAR iSkipElement  AS INT  NO-UNDO.
    DEF VAR cSortColumn   AS CHAR NO-UNDO.
    DEF VAR cColumnList   AS CHAR NO-UNDO. // to eliminate duplicates
    DEF VAR cPrevBY       AS CHAR NO-UNDO.
    
    IF ic4GLQuerySort MATCHES "*jbCountDistinct*" THEN ic4GLQuerySort = "".
    IF ic4GLQuerySort = "" THEN RETURN "".
    
    ic4GLQuerySort = TRIM(ic4GLQuerySort).
    
    REPEAT WHILE INDEX(ic4GLQuerySort,"  ") > 0:
      ic4GLQuerySort = REPLACE(ic4GLQuerySort,"  "," ").
    END.
    IF ic4GLQuerySort BEGINS "BY " THEN
      ic4GLQuerySort = SUBSTR(ic4GLQuerySort,4).
        
    IF SQLqueryDirection NE "" THEN DO: /* gå fra bunnen */
      IF NUM-ENTRIES(ic4GLQuerySort," ") = 1 THEN
        cSqlOrder = ic4GLQuerySort + " DESC".
      ELSE DO ix = 1 TO NUM-ENTRIES(ic4GLQuerySort," "):
        cElement = ENTRY(ix,ic4GLQuerySort," ").
        CASE cElement:
          WHEN "BY" THEN
            cSqlOrder = cSqlOrder + cElement + " ".
          WHEN "DESC" OR WHEN "DESCENDING" THEN .
          OTHERWISE DO:
            IF NUM-ENTRIES(ic4GLQuerySort," ") > ix AND ENTRY(ix + 1,ic4GLQuerySort," ") = "BY" THEN
              cSqlOrder = cSqlOrder + cElement + " DESC ".
            ELSE   
              cSqlOrder = cSqlOrder + cElement + " ".
          END.  
        END CASE.
      END.
    END.
    ELSE cSqlOrder = ic4GLQuerySort.
    
    cSqlOrder = TRIM(cSqlOrder).
        
    iSkipElement = 0.
    BuildSort:
    DO ix = 1 TO NUM-ENTRIES(cSqlOrder," "):
      IF ix = iSkipElement THEN NEXT BuildSort.
      cElement = ENTRY(ix,cSqlOrder," ").
      DO iy = 1 TO NUM-ENTRIES(SQLcalcFieldDef):
        IF cElement = ENTRY(1,ENTRY(iy,SQLcalcFieldDef),";") AND NOT CAN-DO(JB_to_SQL_funclist,ENTRY(3,ENTRY(iy,SQLcalcFieldDef),";")) THEN DO:
          IF NUM-ENTRIES(cSqlOrder," ") > ix AND ENTRY(ix + 1,cSqlOrder," ") BEGINS "DESC" THEN
            iSkipElement = ix + 1.
          NEXT BuildSort.
        END.  
      END.   
      IF NOT CAN-DO("BY,DESC",cElement) THEN DO:
        IF SUBSTR(cElement,LENGTH(cElement)) = "_"  AND KEYWORD(TRIM(ENTRY(NUM-ENTRIES(cElement,"."),cElement,"."),"_")) NE ? THEN
          cElement = RIGHT-TRIM(cElement,"_").
        
        cSortColumn = getTableField(cElement).
        IF CAN-DO(cColumnList,cSortColumn) THEN DO:
          cPrevBY = "".
          NEXT.
        END.  
        ELSE ASSIGN cElement = cSortColumn
                    cColumnList = cColumnList + (IF cColumnList NE "" THEN "," ELSE "") + cElement. 
        IF cElement MATCHES "*__*" THEN cElement = "[" + REPLACE(cElement,"__"," ") + "]".
        IF cElement MATCHES "*_" THEN cElement = RIGHT-TRIM(cElement,"_").
        cORDER = cORDER + " " + (IF cPrevBY NE "" THEN cPrevBy + " " ELSE "") + cElement.
      END.  
      ELSE DO:
        IF cElement = "BY" THEN DO: 
          cPrevBY = cElement.
          NEXT.
        END.
        cORDER = cORDER + " " + cElement.
      END.
    END.  
    
    IF TRIM(cORDER) NE "" THEN
      cORDER = "ORDER BY " + REPLACE(cORDER," BY ",", ").
        
    THIS-OBJECT:SQLquerySort = cORDER.
    THIS-OBJECT:logToQueryLog("SqlOrder", cORDER).
      
    RETURN cORDER.  

    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.    
  END METHOD.  

  METHOD PRIVATE CHARACTER addQuotes (INPUT icExpr AS CHAR):

    DEF VAR ix            AS INT  NO-UNDO.
    DEF VAR iy            AS INT  NO-UNDO.
    DEF VAR cElement      AS CHAR NO-UNDO.
    DEF VAR cSubElement   AS CHAR NO-UNDO.
    DEF VAR cModElement   AS CHAR NO-UNDO.
    DEF VAR cReturn       AS CHAR NO-UNDO.
    DEF VAR cFunc         AS CHAR NO-UNDO.
    
    DO ix = 1 TO NUM-ENTRIES(icExpr," "):
      cElement = remLeftRightPar(ENTRY(ix,icExpr," "),NO).
      IF INDEX(cElement,"(") > 0 THEN
        ASSIGN cFunc = SUBSTR(cElement,1,R-INDEX(cElement,"("))
               cElement = SUBSTR(cElement,1,R-INDEX(cElement,"(") + 1)
               .
      ELSE cFunc = "".
      cModElement = "".         
      DO iy = 1 TO NUM-ENTRIES(cElement):
        cSubElement = ENTRY(iy,cElement).
        IF NUM-ENTRIES(cSubElement,".") = 2 AND LOOKUP(ENTRY(1,cSubElement,"."),SQLtableList) > 0 THEN
          cSubElement = c2Q + ENTRY(1,cSubElement,".") + c2QDot2Q + ENTRY(2,cSubElement,".") + c2Q.
        cModElement = cModElement + (IF cModElement NE "" THEN "," ELSE "") + cSubElement.
      END.    
      cReturn = cReturn + (IF cReturn NE "" THEN " " ELSE "") + cLeftPar + cFunc + cModElement + cRightPar.  
    END.
    RETURN cReturn.
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.
  END METHOD.   

  METHOD PRIVATE LOGICAL allowedExpr (INPUT icExpr AS CHAR):
    IF icExpr BEGINS "ALTER " 
       OR icExpr BEGINS "CREATE "
       OR icExpr BEGINS "DELETE "
       OR icExpr BEGINS "INSERT "
       OR icExpr MATCHES "* ALTER *"
       OR icExpr MATCHES "* CREATE *"
       OR icExpr MATCHES "* DELETE *"
       OR icExpr MATCHES "* INSERT *" THEN
     RETURN NO.
    RETURN YES. 
  END.

  METHOD PRIVATE CHARACTER setSqlGroupBy( INPUT icSqlGroupBy AS CHAR ):
    
    DEF VAR ix            AS INT  NO-UNDO.
    DEF VAR cElement      AS CHAR NO-UNDO.
    DEF VAR cGroupBy      AS CHAR NO-UNDO.

    DO ix = 1 TO NUM-ENTRIES(icSqlGroupBy):
      cElement = ENTRY(ix,icSqlGroupBy).
      IF NUM-ENTRIES(cElement,".") > 1 AND LOOKUP(ENTRY(1,cElement,"."),SQLtableList) > 0 THEN DO:
        FIND FIRST ttAllSqlColumns
             WHERE ttAllSqlColumns.AliasName = ENTRY(2,cElement,".")
             NO-ERROR.
        IF AVAIL ttAllSqlColumns THEN
          cElement = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
        ELSE DO:
          FIND FIRST ttAllSqlColumns
               WHERE ttAllSqlColumns.Table_Name  = ENTRY(1,cElement,".")
                 AND ttAllSqlColumns.Column_Name = ENTRY(2,cElement,".")
               NO-ERROR.
          IF AVAIL ttAllSqlColumns THEN     
            cElement = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
          ELSE DO:
            FIND FIRST ttAllSqlColumns
                 WHERE ttAllSqlColumns.Column_Name = ENTRY(2,cElement,".")
                 NO-ERROR.
            IF AVAIL ttAllSqlColumns THEN     
              cElement = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
          END.    
        END.  
      END.
      ELSE DO:
        FIND FIRST ttAllSqlColumns
             WHERE ttAllSqlColumns.AliasName = cElement
             NO-ERROR.
        IF AVAIL ttAllSqlColumns THEN
          cElement = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
        ELSE DO:
          FIND FIRST ttAllSqlColumns
               WHERE ttAllSqlColumns.Column_Name = cElement
               NO-ERROR.
          IF AVAIL ttAllSqlColumns THEN     
            cElement = c2Q + ttAllSqlColumns.Table_Name + c2QDot2Q + ttAllSqlColumns.Column_Name + c2Q.
        END.  
      END.
      IF cElement MATCHES "*__*" THEN cElement = "[" + REPLACE(cElement,"__"," ") + "]".
      IF cElement MATCHES "*_" THEN cElement = RIGHT-TRIM(cElement,"_").
      IF cGroupBy = "" THEN
        cGroupBy = cGroupBy + " BY " + cElement.
      ELSE
        cGroupBy = cGroupBy + ", " + cElement.  
    END.  
    
    IF TRIM(cGroupBy) NE "" THEN
      cGroupBy = "GROUP " + cGroupBy.
        
//    THIS-OBJECT:SQLgroupBy = cGroupBy.
    THIS-OBJECT:logToQueryLog("SqlGroupBy", cGroupBy).
      
    RETURN cGroupBy.  
    
    CATCH eErr AS Progress.Lang.Error :
      MESSAGE eErr:GetMessage(1)
      VIEW-AS ALERT-BOX.  
    END CATCH.    
  END METHOD.  

  METHOD PRIVATE VOID addTableToSqlGroupBy( INPUT icSqlGroupBy AS CHAR ):
    
    DEF VAR ix            AS INT  NO-UNDO.
    DEF VAR cElement      AS CHAR NO-UNDO.
    DEF VAR cGroupBy      AS CHAR NO-UNDO.

    DO ix = 1 TO NUM-ENTRIES(icSqlGroupBy):
      cElement = ENTRY(ix,icSqlGroupBy).
      IF SUBSTR(cElement,LENGTH(cElement)) = "_"  AND KEYWORD(TRIM(ENTRY(NUM-ENTRIES(cElement,"."),cElement,"."),"_")) NE ? THEN
        cElement = RIGHT-TRIM(cElement,"_").
      
      IF NUM-ENTRIES(cElement,".") > 1 AND LOOKUP(ENTRY(1,cElement,"."),SQLtableList) > 0 THEN DO:
        FIND FIRST ttAllSqlColumns
             WHERE ttAllSqlColumns.AliasName = ENTRY(2,cElement,".")
             NO-ERROR.
        IF AVAIL ttAllSqlColumns THEN
          cElement = ttAllSqlColumns.Table_Name + '.' + ttAllSqlColumns.Column_Name.
        ELSE DO:
          FIND FIRST ttAllSqlColumns
               WHERE ttAllSqlColumns.Table_Name  = ENTRY(1,cElement,".")
                 AND ttAllSqlColumns.Column_Name = ENTRY(2,cElement,".")
               NO-ERROR.
          IF AVAIL ttAllSqlColumns THEN     
            cElement = ttAllSqlColumns.Table_Name + '.' + ttAllSqlColumns.Column_Name.
          ELSE DO:
            FIND FIRST ttAllSqlColumns
                 WHERE ttAllSqlColumns.Column_Name = ENTRY(2,cElement,".")
                 NO-ERROR.
            IF AVAIL ttAllSqlColumns THEN     
              cElement = ttAllSqlColumns.Table_Name + '.' + ttAllSqlColumns.Column_Name.
          END.    
        END.  
      END.
      ELSE DO:
        FIND FIRST ttAllSqlColumns
             WHERE ttAllSqlColumns.AliasName = cElement
             NO-ERROR.
        IF AVAIL ttAllSqlColumns THEN
          cElement = ttAllSqlColumns.Table_Name + '.' + ttAllSqlColumns.Column_Name.
        ELSE DO:
          FIND FIRST ttAllSqlColumns
               WHERE ttAllSqlColumns.Column_Name = cElement
               NO-ERROR.
          IF AVAIL ttAllSqlColumns THEN     
            cElement = ttAllSqlColumns.Table_Name + '.' + ttAllSqlColumns.Column_Name.
        END.  
      END.  
      IF cElement MATCHES "*__*" THEN cElement = "[" + REPLACE(cElement,"__"," ") + "]".
      IF cElement MATCHES "*_" THEN cElement = RIGHT-TRIM(cElement,"_").

      cGroupBy = cGroupBy + (IF cGroupBy NE "" THEN "," ELSE "") + cElement.
    END.  
            
    THIS-OBJECT:SQLgroupBy = cGroupBy.
    THIS-OBJECT:logToQueryLog("TableToSqlGroupBy", cGroupBy).
          
  END METHOD. 

	DESTRUCTOR PUBLIC JBoxSqlQueryHelper ( ):

	END DESTRUCTOR.
	
	
END CLASS.

