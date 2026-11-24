 
 /*------------------------------------------------------------------------
    File        : JBoxMsSQL
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo_000
    Created     : Tue May 08 16:00:34 CEST 2018
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING System.Data.SqlClient.*.
USING System.Data.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS JBoxMsSQL: 
    DEF PROTECTED PROPERTY sqlServer   AS CHAR NO-UNDO GET. SET.
    DEF PROTECTED PROPERTY sqlDatabase AS CHAR NO-UNDO GET. SET.        
    DEF PROTECTED PROPERTY sqlUserid   AS CHAR NO-UNDO GET. SET.
    DEF PROTECTED PROPERTY sqlPassword  AS CHAR NO-UNDO GET. SET.

    DEF VAR Conn         AS System.Data.SqlClient.SqlConnection NO-UNDO.
    DEF VAR Cmd          AS System.Data.SqlClient.SqlCommand    NO-UNDO.
    DEF VAR bRead        AS LOG  NO-UNDO.
    DEF VAR SQLstatement AS CHAR NO-UNDO.

    DEF PUBLIC PROPERTY Rdr AS SqlDataReader NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY ReadCount AS INT NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY ReadLimit AS INT NO-UNDO GET. SET.
    DEF PUBLIC PROPERTY SQLerror  AS CHAR NO-UNDO GET. PROTECTED SET.
    DEF PUBLIC PROPERTY SQLtimeout AS INT NO-UNDO GET. SET. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
    
  CONSTRUCTOR PUBLIC JBoxMsSQL ():
    SUPER ().
    SQLtimeout = 300.
  END CONSTRUCTOR.


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
    
    Cmd = NEW SqlCommand(SQLstatement, Conn).
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
      
    Cmd = NEW SqlCommand(sqlStatement, Conn).
    IF ipUpdate THEN 
      Cmd:ExecuteNonQuery(). 
    ELSE DO:
      Rdr = Cmd:ExecuteReader().
      bRead = NO.
    END.

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in CallSQL with update flag: " + anyError:GetMessage(1) + CHR(10) + "SQL: " + (IF ipSQLstatement NE ? THEN ipSQLstatement ELSE "?").      
    END CATCH.

    FINALLY:
      RETURN SQLerror = "".
    END FINALLY.

   END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID ConnectSQL(  ):
    DEF VAR ix           AS INT NO-UNDO.
    DEF VAR SeqString    AS System.Security.SecureString NO-UNDO.
    DEF VAR SqlCred      AS System.Data.SqlClient.SqlCredential NO-UNDO.
    DEF VAR sqlConnect   AS CHAR NO-UNDO.
    
    SeqString = NEW System.Security.SecureString().
    DO ix = 1 TO LENGTH(sqlPassword):
      SeqString:AppendChar(SUBSTR(sqlPassword,ix,1)).
    END.  
    SeqString:MakeReadOnly().
  
    SqlCred = NEW SqlCredential(sqlUserid,SeqString).
    sqlConnect = "Server=" + sqlServer + ';Database=' + sqlDatabase .
    Conn = NEW SqlConnection(sqlConnect,SqlCred). 
    Conn:Open().

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in ConnectSql: " + anyError:GetMessage(1) + CHR(10) + "Connect paramams:" + CHR(10)
        + "sqlServer: " + sqlServer + CHR(10)
        + "sqlDatabase: " + sqlDatabase + CHR(10)
        + "sqlUserid: " + sqlUserid + CHR(10)
        + "sqlPassword: " + (IF sqlPassword NE "" THEN "<unlike blank>" ELSE "<not set>")
        .      
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
   
    DEF VAR hFlds            AS HANDLE NO-UNDO EXTENT 200.
    DEF VAR cSqlFldNames     AS CHAR   NO-UNDO EXTENT 200.
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

    Cmd = NEW SqlCommand(icSql, Conn).
    
    Cmd:CommandTimeout = SQLtimeout.
    
    Rdr = Cmd:ExecuteReader().
     
    IF NOT VALID-OBJECT(Cmd) THEN DO:
      SQLerror = "Missing sql statement in fillTempTable".
      RETURN FALSE.    
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
          hFlds[iy]:BUFFER-VALUE = DECIMAL(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "LOGICAL" THEN  
          hFlds[iy]:BUFFER-VALUE = LOGICAL(STRING(Rdr[cSqlFldNames[iy]])).
        ELSE IF hFlds[iy]:DATA-TYPE = "CHARACTER" THEN   
          hFlds[iy]:BUFFER-VALUE = TRIM(STRING(Rdr[cSqlFldNames[iy]])).
          
      END.
      IF ReadLimit > 0 AND ReadCount > ReadLimit THEN LEAVE. 
    END.

    CATCH anyError AS Progress.Lang.Error :
      SQLerror = "Error in fillTempTable: " + anyError:GetMessage(1) + CHR(10)
                                            + (IF iy > 1 THEN "Could be error in field after " + hFlds[iy - 1]:NAME + CHR(10) ELSE "") 
                                            + "SQL: " + (IF icSQL NE ? THEN icSQL ELSE "?").      
    END CATCH.
    
    FINALLY:
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

  METHOD PUBLIC CHARACTER getViewDefinition (INPUT icViewName AS CHARACTER):
/*    RETURN oSysPara:getParameterDescription(icViewName).*/
  END.  

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

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
  
  DESTRUCTOR PUBLIC JBoxMsSQL():

    THIS-OBJECT:CloseConnection().
    
  END DESTRUCTOR.  
END CLASS.