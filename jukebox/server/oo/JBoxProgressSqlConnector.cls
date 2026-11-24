 
 /*------------------------------------------------------------------------
    File        : ProgressSqlConnector
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Tue Nov 15 21:21:20 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.JBoxProgressSqlConnector: 

  DEF STREAM strSql.

  DEF VAR cSqlExp      AS CHAR   NO-UNDO.

  DEF PUBLIC PROPERTY SourceConnected AS LOGICAL NO-UNDO GET. PROTECTED SET.
      
  DEF PUBLIC PROPERTY StatusMessage AS CHAR NO-UNDO GET. PROTECTED SET.  

  DEF PUBLIC PROPERTY sqlHost     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPort     AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlDatabase AS CHAR NO-UNDO  GET. SET.        
  DEF PUBLIC PROPERTY sqlUserid   AS CHAR NO-UNDO  GET. SET.
  DEF PUBLIC PROPERTY sqlPassword  AS CHAR NO-UNDO PRIVATE GET. SET.

  DEF PUBLIC PROPERTY connectionFile AS CHAR NO-UNDO GET. SET. 
  DEF PUBLIC PROPERTY sourceType     AS CHAR NO-UNDO GET. PROTECTED SET. 
  

  CONSTRUCTOR PUBLIC JBoxProgressSqlConnector (  ):
  END CONSTRUCTOR.


  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL doConnect (INPUT ihBuffer AS HANDLE):

    DEF VAR sqlConnect   AS CHAR   NO-UNDO.
    DEF VAR ConnectError AS CHAR   NO-UNDO.
    DEF VAR cCmd         AS CHAR   NO-UNDO.
    DEF VAR ix           AS INT    NO-UNDO.
    DEF VAR cStatus      AS CHAR   NO-UNDO EXTENT 5. 
    
    StatusMessage = "".
    
    IF VALID-HANDLE(ihBuffer) AND ihBuffer:AVAIL AND (cSqlExp = ? OR cSqlExp = "") THEN DO ON ERROR UNDO, THROW:
      sqlHost      = ihBuffer::SourceHost.
      sqlPort      = ihBuffer::SourcePort.  
      sqlDatabase  = ihBuffer::SourceDb.  
      sqlUserid    = ihBuffer::SourceUser.  
      sqlPassword  = ihBuffer::SourcePwd.  

      IF OPSYS BEGINS "win" THEN
        cSqlExp = SEARCH("sqlexp.bat").
      ELSE     
        cSqlExp = SEARCH("sqlexp.sh").
        
      IF cSqlExp = ? THEN 
        StatusMessage = "Sql explorer not available".
        
      ELSE DO:  
        cCmd = cSqlExp + " -db " + sqlDatabase + " -H " + sqlHost + " -S " + sqlPort + " -user " + sqlUserid + " -password " + sqlPassword + " -command exit;".
            
        INPUT STREAM strSql THROUGH VALUE(cCmd).
        REPEAT:
          ix = ix + 1.
          IF ix < 6 THEN IMPORT STREAM strSql UNFORMATTED cStatus[ix].
        END.
                
        INPUT STREAM strSql CLOSE.  
        
        IF cStatus[3] BEGINS "Error" OR cStatus[3] BEGINS "=== SQL Exception" THEN
          StatusMessage = cStatus[1] + CHR(10) 
                        + cStatus[2] + CHR(10)
                        + cStatus[3] + CHR(10)
                        + cStatus[4] + CHR(10)
                        + cStatus[5]
                        .
      END.        
    END.  

    CATCH eApp AS Progress.Lang.AppError :
      StatusMessage = eApp:GetMessage(1).
    END CATCH.

    CATCH anyError AS Progress.Lang.Error :
      StatusMessage = "Error in doConnect: " + anyError:GetMessage(1).     
    END CATCH.
    
    FINALLY:
      IF StatusMessage NE "" THEN
        StatusMessage = StatusMessage  + CHR(10) + "Connect params:" + CHR(10)
        + "sqlHost: " + sqlHost + CHR(10)
        + "sqlDatabase: " + sqlDatabase + CHR(10)
        + "sqlUserid: " + sqlUserid + CHR(10)
        + "sqlPassword: " + (IF sqlPassword NE "" THEN "<unlike blank>" ELSE "<not set>")
        . 
      
      ELSE SourceConnected = YES.
        
      RETURN StatusMessage = "".
    END FINALLY.

  END METHOD.

 METHOD PUBLIC INTEGER callSqlExp(INPUT icViewDef    AS CHAR,
                                  INPUT ihBuffer     AS HANDLE):

    DEF VAR ix       AS INT  NO-UNDO.
    DEF VAR iy       AS INT  NO-UNDO.
    DEF VAR cCmd     AS CHAR NO-UNDO.
    DEF VAR cFields  AS CHAR NO-UNDO.
    DEF VAR hField   AS HANDLE NO-UNDO EXTENT.
    DEF VAR cInput   AS CHAR NO-UNDO.
    DEF VAR bError   AS LOG  NO-UNDO.
    DEF VAR iFldCnt  AS INT  NO-UNDO.
    DEF VAR cValue   AS CHAR NO-UNDO.
    DEF VAR iReadCnt AS INT  NO-UNDO.
    DEF VAR bReadCnt AS LOG  NO-UNDO.
    DEF VAR cStatus  AS CHAR NO-UNDO EXTENT 6.
    DEF VAR bReadErr AS LOG  NO-UNDO.
    DEF VAR cOrgNumFormat AS CHAR NO-UNDO.  

    REPEAT WHILE INDEX(icViewDef,"  ") > 0:
      icViewDef = REPLACE(icViewDef,"  "," ").
    END.
 
    cCmd =  cSqlExp 
         + " -db " + sqlDatabase
         + " -H " + sqlHost
         + " -S " + sqlPort
         + " -user " + sqlUserid
         + " -password " + sqlPassword
         + ' -command "' + getSqlExpView(icViewDef) + ';"'.
    
    cOrgNumFormat = SESSION:NUMERIC-FORMAT.
    SESSION:NUMERIC-FORMAT = "AMERICAN".

    StatusMessage = "".
    
    cFields = getSqlExpFields(icViewDef,ihBuffer).
    DO iy = 1 TO NUM-ENTRIES(cFields):
      IF ENTRY(iy,cFields) NE "<skip>" THEN ix = ix + 1.
    END.  
    
    IF ix > 0 THEN
      EXTENT(hField) = ix.
    
    ix = 0.  
    DO iy = 1 TO NUM-ENTRIES(cFields):
      IF ENTRY(iy,cFields) NE "<skip>" THEN
        ASSIGN ix = ix + 1
               hField[ix] = ihBuffer:BUFFER-FIELD(ENTRY(iy,cFields)).
    END.
    
    cCmd = REPLACE(cCmd,'%','~~%').
    
    ix = 0.  
    INPUT-OUTPUT STREAM strSql THROUGH VALUE(cCmd) CONVERT SOURCE "utf-8" TARGET SESSION:CPINTERNAL.
    REPEAT:
      ix = ix + 1.
      IF ix > 4 AND NOT bError AND NOT bReadCnt THEN DO:
        IMPORT STREAM strSql UNFORMATTED cInput.
        IF cInput BEGINS "=== SQL Exception" THEN DO:
          bReadErr = YES.
          cStatus[3] = cInput.
          NEXT.
        END.  
        IF bReadErr THEN DO:
          cStatus[4] = cInput.
          LEAVE.
        END.          
        ihBuffer:BUFFER-CREATE().
        ASSIGN iFldCnt = 0
               iReadCnt = iReadCnt + 1.
        DO iy = 1 TO NUM-ENTRIES(cFields):
          IF ENTRY(iy,cFields) NE "<skip>" THEN DO:
            ASSIGN iFldCnt = iFldCnt + 1
                   cValue  = TRIM(ENTRY(iy,cInput,CHR(3))).
            CASE hField[iFldCnt]:DATA-TYPE:
              WHEN "DATE" THEN hField[iFldCnt]:BUFFER-VALUE = DATE(cValue).
              WHEN "DATETIME" THEN hField[iFldCnt]:BUFFER-VALUE = getDateTime(cValue).
              WHEN "DATETIME-TZ" THEN hField[iFldCnt]:BUFFER-VALUE = getDateTimeTZ(cValue).
              WHEN "INTEGER" THEN hField[iFldCnt]:BUFFER-VALUE = INTEGER(cValue).
              WHEN "INT64" THEN hField[iFldCnt]:BUFFER-VALUE = INT64(cValue).
              WHEN "LOGICAL" THEN hField[iFldCnt]:BUFFER-VALUE = IF CAN-DO("0,1",cValue) THEN cValue = "1" ELSE LOGICAL(cValue).
              OTHERWISE hField[iFldCnt]:BUFFER-VALUE = cValue.
            END CASE.  
          END.  
        END.  
      END.
      ELSE DO:
        IMPORT STREAM strSql UNFORMATTED cStatus[ix].
        IF cStatus[ix] BEGINS "Error" OR cStatus[ix] BEGINS "=== SQL Exception" THEN
          bError = YES.
        IF TRIM(cStatus[ix]) = "READCOUNT" THEN 
          bReadCnt = YES.
        IF ix = 5 AND bReadCnt THEN DO:
          iReadCnt = INT(cStatus[ix]).
          ihBuffer:BUFFER-CREATE ().
          ihBuffer::ReadCount = iReadCnt.
        END.
        IF ix = 6 THEN  
          LEAVE.
      END.  
    END.

    INPUT-OUTPUT STREAM strSql THROUGH VALUE("exit;").

    INPUT STREAM strSql CLOSE.  

    IF cStatus[3] BEGINS "Error" OR cStatus[3] BEGINS "=== SQL Exception" THEN
      statusMessage = cStatus[1] + CHR(10) + cStatus[2] + CHR(10) + cStatus[3] + CHR(10) + cStatus[4] + CHR(10) + cStatus[5] + CHR(10) + cStatus[6].
    
    CATCH eErr AS Progress.Lang.Error :
      statusMessage = eErr:GetMessage(1) + CHR(10) + "Curr.Value: " + cValue + CHR(10) + "Curr.record: " +  cInput.
      MESSAGE StatusMessage
      VIEW-AS ALERT-BOX.
    END CATCH.
    FINALLY:
      SESSION:NUMERIC-FORMAT = cOrgNumFormat.
      RETURN iReadCnt.
    END.                                            
  END METHOD.                                                
  
  METHOD PRIVATE CHARACTER getSqlExpView (INPUT icViewDef AS CHAR):
    DEF VAR ix             AS INT  NO-UNDO.
    DEF VAR cNewView       AS CHAR NO-UNDO.
    DEF VAR bStopMessing   AS LOG  NO-UNDO.
    DEF VAR bSkipDelimiter AS LOG  NO-UNDO.
        
    DO ix = 1 TO NUM-ENTRIES(icViewDef):
      cNewView = cNewView + (IF cNewView NE "" THEN "," ELSE "") + ENTRY(ix,icViewDef).
      bSkipDelimiter = NO.
      
      IF ENTRY(ix,icViewDef) MATCHES "* from *" THEN bStopMessing = YES.
      
      IF INDEX(ENTRY(ix,icViewDef),"(") > 0 AND INDEX(ENTRY(ix,icViewDef),")") < INDEX(ENTRY(ix,icViewDef),"(") THEN
        bSkipDelimiter = YES.

      IF NOT bStopMessing AND NOT bSkipDelimiter THEN 
        cNewView = cNewView + ",'" + CHR(3) + "'".
    END.
    RETURN cNewView.
  END METHOD.

  METHOD PRIVATE CHARACTER getSqlExpFields (INPUT icViewDef AS CHAR
                                           ,INPUT ihBuffer  AS HANDLE):
    DEF VAR ix            AS INT  NO-UNDO.
    DEF VAR cFields       AS CHAR NO-UNDO.
    DEF VAR bStopMessing  AS LOG  NO-UNDO.
    DEF VAR cFieldDef     AS CHAR NO-UNDO.
    DEF VAR hField        AS HANDLE NO-UNDO.
    DEF VAR bSkip         AS LOG  NO-UNDO.
        
    DO ix = 1 TO NUM-ENTRIES(icViewDef):
      cFieldDef = ENTRY(ix,icViewDef).
      IF bSkip AND NOT cFieldDef MATCHES "* AS *" THEN NEXT.
      ELSE bSkip = NO.
      IF INDEX(cFieldDef,"(") > 0 AND INDEX(cFieldDef,")") < INDEX(cFieldDef,"(") AND INDEX(cFieldDef,"count(") = 0 AND INDEX(cFieldDef," from ") = 0 THEN DO:
        IF INDEX(cFieldDef,"(") > 0 AND NOT cFieldDef MATCHES "* AS *" THEN bSkip = YES.
        NEXT.
      END.   
      IF cFieldDef MATCHES "* from *" THEN 
        ASSIGN cFieldDef = TRIM(SUBSTR(cFieldDef,1,INDEX(cFieldDef," from ")))
               bStopMessing = YES.
      cFieldDef = ENTRY(NUM-ENTRIES(cFieldDef," "),cFieldDef," ").
      cFieldDef = ENTRY(NUM-ENTRIES(cFieldDef,"."),cFieldDef,".").
      cFieldDef = TRIM(cFieldDef,'"'). 
      hField = ihBuffer:BUFFER-FIELD(cFieldDef) NO-ERROR.
      cFields = cFields + (IF cFields NE "" THEN "," ELSE "") 
              + (IF ERROR-STATUS:ERROR THEN "<skip>" ELSE cFieldDef).
      IF bStopMessing THEN LEAVE.
    END.
    RETURN cFields.
  END METHOD.

  METHOD PUBLIC DATETIME getDateTime(INPUT icDateTime AS CHAR):
    VAR CHAR orgDateFormat.
    VAR CHAR datePart.
    VAR DATETIME dtDate.
    
    orgDateFormat = SESSION:DATE-FORMAT.
    SESSION:DATE-FORMAT = "dmy".
    datePart = ENTRY(1,icDateTime," ").
    dtDate = DATETIME(SUBSTR(datePart,9) + "/" + SUBSTR(datePart,6,2) + "/" + SUBSTR(datePart,1,4) + SUBSTR(icDateTime,11)) NO-ERROR.  
      
    FINALLY:
      SESSION:DATE-FORMAT = orgDateFormat.  
      RETURN dtDate.
    END FINALLY.
  END.  

  METHOD PUBLIC DATETIME-TZ getDateTimeTZ(INPUT icDateTime AS CHAR):
    VAR CHAR orgDateFormat.
    VAR CHAR datePart.
    VAR DATETIME-TZ dtDate.
    
    orgDateFormat = SESSION:DATE-FORMAT.
    SESSION:DATE-FORMAT = "dmy".
    datePart = ENTRY(1,icDateTime," ").
    dtDate = DATETIME-TZ(SUBSTR(datePart,9) + "/" + SUBSTR(datePart,6,2) + "/" + SUBSTR(datePart,1,4) + SUBSTR(icDateTime,11)) NO-ERROR.  
      
    FINALLY:
      SESSION:DATE-FORMAT = orgDateFormat.  
      RETURN dtDate.
    END FINALLY.
  END.  

  METHOD PUBLIC LOGICAL closeConnection ():
    SourceConnected = NO.
  END METHOD.  

	DESTRUCTOR PUBLIC JBoxProgressSqlConnector ( ):

	END DESTRUCTOR.
  
END CLASS.