 
/*------------------------------------------------------------------------
   File        : JBoxArcSql
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : Brynjar
   Created     : 24.feb.21
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.JBoxArcSql: 
  DEFINE VARIABLE sqlBruker    AS CHARACTER                    INIT 'BafoModule' NO-UNDO.
  DEFINE VARIABLE sqlPassord   AS CHARACTER                    INIT 'xxxx' NO-UNDO.
  DEFINE VARIABLE sqlServer    AS CHARACTER                    INIT 'QA-SXD6E-003' NO-UNDO.
  DEFINE VARIABLE sqlDatabase  AS CHARACTER                    INIT 'Consent' NO-UNDO.
  DEFINE VARIABLE SQLstatement AS CHARACTER                    INIT 'Select * from vwConsents' NO-UNDO.
  DEFINE VARIABLE sqlConnect   AS CHARACTER                    NO-UNDO.  
  DEF VAR cDriver              AS CHAR NO-UNDO INIT "DataDirect 8.0 Autonomous REST Connector".
  DEF VAR cRestSamplePath      AS CHAR NO-UNDO INIT "https://data.brreg.no/enhetsregisteret/api/enheter/".
  DEF VAR cRestConfigFile      AS CHAR NO-UNDO INIT "C:\prowrk\odbc\schema\ChemistryBA.rest".

  DEF VAR Conn         AS System.Data.Odbc.OdbcConnection.
  DEF VAR Cmd          AS System.Data.Odbc.OdbcCommand.
  DEFINE VARIABLE SqlCred      AS System.Data.SqlClient.SqlCredential  NO-UNDO.
  DEFINE VARIABLE SeqString    AS System.Security.SecureString NO-UNDO.
  DEFINE VARIABLE bRead        AS LOG                          NO-UNDO.

  DEFINE PUBLIC PROPERTY Rdr AS System.Data.Odbc.OdbcDataReader NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ReadCount AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY ReadLimit AS INTEGER NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY SQLerror  AS CHARACTER NO-UNDO GET. 
    PROTECTED SET. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxArcSql (INPUT ipServer AS CHARACTER, INPUT ipDatabase AS CHARACTER, INPUT ipBruker AS CHARACTER, INPUT ipPassord AS CHARACTER ):
    ASSIGN 
      sqlBruker   = ipBruker
      sqlPassord  = ipPassord
      sqlServer   = ipServer
      sqlDatabase = ipDatabase
      . 
    ConnectSQL().
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxArcSql (INPUT icDatabase AS CHARACTER ):
    
    DEFINE VARIABLE ix AS INTEGER NO-UNDO.
    
    ConnectSQL().                
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD private VOID ConnectSQL(  ):
    def var ix as int no-undo.
                    
/*    SeqString = NEW System.Security.SecureString().                        */
/*    DO ix = 1 TO LENGTH(sqlPassord):                                       */
/*      SeqString:AppendChar(SUBSTR(sqlPassord,ix,1)).                       */
/*    END.                                                                   */
/*    SeqString:MakeReadOnly().                                              */
/*                                                                           */
/*    SqlCred = NEW System.Data.SqlClient.SqlCredential(sqlBruker,SeqString).*/
    
    sqlConnect = "DRIVER=" + CHR(123) + cDriver + CHR(125) 
                  + ";RestConfigFile='" + cRestConfigFile + "';"
                  .

    Conn = NEW System.Data.Odbc.OdbcConnection(sqlConnect). 
    Conn:Open().

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Feil i Constructor av JBoxArcSql: " + anyError:GetMessage(1) + CHR(10) + "Connect paramams:" + CHR(10)
        + "sqlServer: " + sqlServer + CHR(10)
        + "sqlDatabase: " + sqlDatabase + CHR(10)
        + "sqlBruker: " + sqlBruker + CHR(10)
        + "sqlPassord: " + (IF sqlPassord NE "" THEN "<ulik blank>" ELSE "<ikke angitt>")
        .      
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID CallSQL(INPUT ipSelect AS CHARACTER):
    DEFINE VARIABLE ix AS INTEGER NO-UNDO.

    SQLstatement = ipSelect.
           
    if not valid-object(conn) then undo, throw new Progress.Lang.AppError('Har ikke knyttning til SQL',1).

    Cmd = NEW System.Data.Odbc.OdbcCommand(SQLstatement, Conn).
    Rdr = Cmd:ExecuteReader().
    bRead = NO.
  
    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in CallSQL: " + anyError:GetMessage(1).      
    END CATCH.
    
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID CallSQL(INPUT ipSQLstatement AS CHARACTER, INPUT ipUpdate AS LOG):
    DEFINE VARIABLE ix AS INTEGER NO-UNDO.

    sqlStatement = ipSQLstatement.

    if not valid-object(conn) then undo, throw new Progress.Lang.AppError('Har ikke knyttning til SQL',1).
    Cmd = NEW System.Data.Odbc.OdbcCommand(sqlStatement, Conn).
    IF ipUpdate THEN 
      Cmd:ExecuteNonQuery(). 
    ELSE 
    DO:
      Rdr = Cmd:ExecuteReader().
      bRead = NO.
    END.

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in CallSQL with update flag: " + anyError:GetMessage(1).      
    END CATCH.

  END METHOD.

  METHOD PUBLIC CHARACTER getValue (INPUT icFieldName AS CHARACTER):
    DEFINE VARIABLE iy AS INTEGER NO-UNDO.
    
    IF NOT VALID-OBJECT (Rdr) THEN RETURN "sql reader not defined".
    IF NOT bRead THEN 
      bRead = Rdr:Read().
    
    IF bRead THEN    
      RETURN STRING(Rdr[icFieldName]).
    ELSE RETURN ?.  
  END.

  METHOD PUBLIC CHARACTER getViewDefinition (INPUT icViewName AS CHARACTER):
    RETURN "".
  END.  

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
        
    IF NOT VALID-OBJECT(Cmd) AND icSQL NE "" THEN DO:
      Cmd = NEW System.Data.Odbc.OdbcCommand(icSql, Conn).
      Rdr = Cmd:ExecuteReader().
    END.  
    ELSE IF NOT VALID-OBJECT(Cmd) THEN UNDO, THROW NEW Progress.Lang.AppError("Missing sql statement in fillTempTable",1).
    
    ReadCount = 0.
    DO WHILE Rdr:Read():
      IF ReadCount = 0 THEN DO:
        EXTENT(hFields) = Rdr:FieldCount.
        DO ii = 0 TO (Rdr:FieldCount - 1) ON ERROR UNDO, LEAVE: /*array starts on 0*/
          FieldName   = Rdr:GetName(ii).
          hFields[ii + 1] = ihBuffer:BUFFER-FIELD(FieldName) NO-ERROR.
        END.
        RowIdent1 = ihBuffer:BUFFER-FIELD('RowIdent1') NO-ERROR. 
        RowCount  = ihBuffer:BUFFER-FIELD('RowCount') NO-ERROR.          
      END.
      
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
          WHEN 'decimal'   THEN ASSIGN hField:BUFFER-VALUE = DECIMAL(STRING(Rdr:GetValue(ii))).
          WHEN 'datetime'  THEN ASSIGN hField:BUFFER-VALUE = DATETIME(STRING(Rdr:GetValue(ii))).
          WHEN 'date'      THEN ASSIGN hField:BUFFER-VALUE = DATE(STRING(Rdr:GetValue(ii))).
          WHEN 'character' THEN ASSIGN hField:BUFFER-VALUE = TRIM(STRING(Rdr:GetValue(ii))).
          WHEN 'logical'   THEN ASSIGN hField:BUFFER-VALUE = LOGICAL(STRING(Rdr:GetBoolean(ii))).
          OTHERWISE UNDO, THROW NEW Progress.Lang.AppError('Fant ikke datatype konvertering for:' + FieldName + ':datatype:' + hField:DATA-TYPE,1).
        END CASE.
        
        CATCH eAnyError AS Progress.Lang.Error :
          MESSAGE "Rdr:error " + eAnyError:GetMessage(1) + '-> ' + FieldName + '(' + upper(hField:DATA-TYPE) + '-->' + upper(SQLFieldDataType)
          VIEW-AS ALERT-BOX.
          UNDO, THROW NEW Progress.Lang.AppError ("Rdr:error " + eAnyError:GetMessage(1) + '-> ' + FieldName + '(' + upper(hField:DATA-TYPE) + '-->' + upper(SQLFieldDataType),1).      
        END CATCH.
      END.
      IF VALID-HANDLE(RowIdent1) THEN RowIdent1:buffer-value = STRING(ReadCount). 
      IF VALID-HANDLE(RowCount)  THEN RowCount:buffer-value  = ReadCount.
    END.
    
    CATCH eAnyError AS Progress.Lang.Error :
      SQLerror = "Error in fillTempTable: " + eAnyError:GetMessage(1).      
    END CATCH.
    
    FINALLY:
      if valid-object(Rdr) then do:
        Rdr:Close().
        delete object Rdr no-error.
        delete object Cmd no-error.
      end.
      RETURN SQLerror = "".
    END FINALLY.
    
  END METHOD.
 
  METHOD PUBLIC LOGICAL fillTempTable(INPUT icSQL             AS CHAR
                                     ,INPUT ihBuffer          AS HANDLE
                                     ,INPUT icFillOEfieldList AS CHAR ):
   
   
    DEF VAR hFlds            AS HANDLE NO-UNDO EXTENT 100.
    DEF VAR ix               AS INT  NO-UNDO.           
    DEF VAR iy               AS INT  NO-UNDO.           
    DEF VAR iExtraFlds       AS INT  NO-UNDO.
    DEF VAR bStartExtrFldCnt AS LOG  NO-UNDO.
    DEF VAR cDate            AS CHAR NO-UNDO.
    DEF VAR cTime            AS CHAR NO-UNDO.
    DEF VAR iFieldCount      AS INT  NO-UNDO.
    DEF VAR iIncrFldCnt      AS INT  NO-UNDO INIT 1.
    DEF VAR cBufferFlds      AS CHAR NO-UNDO.

    IF NOT VALID-OBJECT(Conn) THEN UNDO, THROW NEW Progress.Lang.AppError('Har ikke knyttning til SQL',1).      
    ELSE IF VALID-OBJECT(Rdr) THEN
      Rdr:Close().

    IF NOT VALID-OBJECT(Cmd) AND icSQL NE "" THEN DO:
      Cmd = NEW System.Data.Odbc.OdbcCommand(icSql, Conn).
      Rdr = Cmd:ExecuteReader().
    END.  
    ELSE IF NOT VALID-OBJECT(Cmd) THEN UNDO, THROW NEW Progress.Lang.AppError("Missing sql statement in fillTempTable",1).
    
    Cmd:CommandTimeout = 300.
    
/*    Rdr = Cmd:ExecuteReader().*/
         
    IF icFillOEfieldList NE "" THEN DO:
      IF NOT CAN-DO(icFillOEfieldList,"RowCount") THEN
        icFillOEfieldList = icFillOEfieldList + ",RowCount".
      iFieldCount = NUM-ENTRIES(icFillOEfieldList).
      DO iy = 1 TO iFieldCount:
        hFlds[iy] = ihBuffer:BUFFER-FIELD(ENTRY(iy,icFillOEfieldList)).
      END.
    END.    
    ELSE DO:    
      DO iy = 1 TO ihBuffer:NUM-FIELDS:
        hFlds[iy] = ihBuffer:BUFFER-FIELD (iy).
        
        cBufferFlds = cBufferFlds + (IF cBufferFlds NE "" THEN "," ELSE "") + hFlds[iy]:NAME.
         
        IF hFlds[iy]:NAME = "RowCount" OR hFlds[iy]:NAME BEGINS "RowIdent" THEN 
          bStartExtrFldCnt = YES.
        IF bStartExtrFldCnt AND hFlds[iy]:NAME NE "RowCount" AND NOT hFlds[iy]:NAME BEGINS "RowIdent" THEN
          iExtraFlds = iExtraFlds + 1.
      END.
      iFieldCount = ihBuffer:NUM-FIELDS - iExtraFlds.
    END.  
        
    ReadCount = 0.  
    DO WHILE Rdr:Read():
      ReadCount = ReadCount + 1.
    
      ihBuffer:BUFFER-CREATE().
      FieldLoop:
      DO iy = 1 TO iFieldCount:
        IF icFillOEfieldList NE "" AND NOT CAN-DO(icFillOEfieldList,hFlds[iy]:NAME) THEN 
          NEXT FieldLoop.
        
        IF hFlds[iy]:NAME BEGINS "RowIdent" THEN
          hFlds[iy]:BUFFER-VALUE = STRING(Rdr[hFlds[iy]:NAME]).
        ELSE IF hFlds[iy]:NAME = "RowCount" THEN
          hFlds[iy]:BUFFER-VALUE = ReadCount.
        ELSE IF hFlds[iy]:DATA-TYPE = "date" THEN 
          hFlds[iy]:BUFFER-VALUE = DATE(STRING(Rdr[hFlds[iy]:NAME])).
        ELSE IF hFlds[iy]:DATA-TYPE = "datetime" THEN 
          ASSIGN cDate = ENTRY(1,STRING(Rdr[hFlds[iy]:NAME])," ")
                 cTime = REPLACE(ENTRY(2,STRING(Rdr[hFlds[iy]:NAME])," "),".",":")         
                 hFlds[iy]:BUFFER-VALUE = DATETIME(cDate + " " + cTime).
        ELSE IF hFlds[iy]:DATA-TYPE = "INTEGER" THEN  
          hFlds[iy]:BUFFER-VALUE = INTEGER(STRING(Rdr[hFlds[iy]:NAME])).
        ELSE IF hFlds[iy]:DATA-TYPE = "INT64" THEN 
          hFlds[iy]:BUFFER-VALUE = INT64(STRING(Rdr[hFlds[iy]:NAME])).
        ELSE IF hFlds[iy]:DATA-TYPE = "DECIMAL" THEN  
          hFlds[iy]:BUFFER-VALUE = DECIMAL(STRING(Rdr[hFlds[iy]:NAME])).
        ELSE IF hFlds[iy]:DATA-TYPE = "LOGICAL" THEN  
          hFlds[iy]:BUFFER-VALUE = LOGICAL(STRING(Rdr[hFlds[iy]:NAME])).
        ELSE IF hFlds[iy]:DATA-TYPE = "CHARACTER" THEN   
          hFlds[iy]:BUFFER-VALUE = TRIM(STRING(Rdr[hFlds[iy]:NAME])).
          
      END.
      IF ReadLimit > 0 AND ReadCount > ReadLimit THEN LEAVE. 
    END.

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

/*      MESSAGE "dump?" view-as alert-box question buttons yes-no update bok.*/
/*      if bok then                                                          */
/*      run toexcelviafile.p (ihBuffer,0).                                   */
      RETURN SQLerror = "".
    END FINALLY.
    
  END METHOD.
 
  METHOD PUBLIC LOGICAL multiUpdateTable (INPUT ihBuffer AS HANDLE):
    
    /* Do multiple sql updates by reading temp-table containing the update statements.
       Required columns in the temp-table are 
       cSQL (character)
       iSort (integer)
    */   
    
    DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.  

    if not valid-object(conn) then undo, throw new Progress.Lang.AppError('Har ikke knyttning til SQL',1).
        
    CREATE QUERY hQuery.
    hQuery:SET-BUFFERS(ihBuffer).
    hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME + " BY iSort").
    hQuery:QUERY-OPEN().
    hQuery:GET-FIRST().
    REPEAT WHILE NOT hQuery:QUERY-OFF-END:
      Cmd = NEW System.Data.Odbc.OdbcCommand(ihBuffer::cSQL, Conn) NO-ERROR.
      IF VALID-OBJECT(Cmd) THEN
        Cmd:ExecuteNonQuery().
      ELSE 
      DO:
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
  
  DESTRUCTOR PUBLIC JBoxArcSql():

    THIS-OBJECT:CloseConnection().
    
  END DESTRUCTOR.  
END CLASS.