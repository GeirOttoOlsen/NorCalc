
/*------------------------------------------------------------------------
    File        : jbserv_jb_calc_helper.p
    Purpose     : 

    Syntax      :

    Description : Procedure for built-in calculated fields

    Author(s)   : bryhasleadm
    Created     : Thu Sep 15 10:06:31 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/
DEF INPUT PARAM ihBuffer      AS HANDLE NO-UNDO.
DEF INPUT PARAM cWeekDayList  AS CHAR   NO-UNDO INIT "Søn,Man,Tir,Ons,Tor,Fre,Lør".
DEF INPUT PARAM icContext     AS CHAR   NO-UNDO INIT "ABL". /* "SQL" when started from JBoxMsSQL.cls */
DEF INPUT PARAM ihSpecFlds    AS HANDLE NO-UNDO.

DEF VAR hBuffer AS HANDLE NO-UNDO EXTENT 100.

hBuffer[1] = ihBuffer.

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

BUFFER ttSpecFlds:HANDLE:COPY-TEMP-TABLE (ihSpecFlds).


PROCEDURE JB_age:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(YEAR(TODAY) - YEAR(idDate) - IF (MONTH(TODAY) = MONTH(idDate) AND DAY(TODAY) GT DAY(idDate)) OR MONTH(TODAY) GT MONTH(idDate) THEN 0 ELSE 1).  


END PROCEDURE.
  
PROCEDURE JB_calc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM ihField1   AS HANDLE NO-UNDO.
DEF INPUT  PARAM ihField2   AS HANDLE NO-UNDO.
DEF INPUT  PARAM icOper     AS CHAR   NO-UNDO.
DEF INPUT  PARAM ifConstant AS DEC    NO-UNDO. /* If Field2 is a constant */
DEF OUTPUT PARAM ocValue    AS CHAR   NO-UNDO.

DEF VAR cDelimiter AS CHAR NO-UNDO.
DEF VAR cOper1     AS CHAR NO-UNDO.
DEF VAR cOper2     AS CHAR NO-UNDO.


IF ifConstant NE 0 THEN
CASE icOper:
  WHEN "*"   THEN ocValue = STRING(ihField1:BUFFER-VALUE * ifConstant) NO-ERROR.
  WHEN "/"   THEN ocValue = STRING(ihField1:BUFFER-VALUE / ifConstant) NO-ERROR. 
  WHEN "+"   THEN ocValue = STRING(ihField1:BUFFER-VALUE + ifConstant) NO-ERROR. 
  WHEN "-"   THEN ocValue = STRING(ihField1:BUFFER-VALUE - ifConstant) NO-ERROR. 
END CASE.

ELSE CASE icOper:
  WHEN "*"   THEN ocValue = STRING(ihField1:BUFFER-VALUE * ihField2:BUFFER-VALUE) NO-ERROR.
  WHEN "%"   THEN ocValue = STRING(ihField1:BUFFER-VALUE / ihField2:BUFFER-VALUE * 100) NO-ERROR.
  WHEN "/"   THEN ocValue = STRING(ihField1:BUFFER-VALUE / ihField2:BUFFER-VALUE) NO-ERROR. 
  WHEN "+"   THEN ocValue = STRING(ihField1:BUFFER-VALUE + ihField2:BUFFER-VALUE) NO-ERROR. 
  WHEN "-"   THEN ocValue = STRING(ihField1:BUFFER-VALUE - ihField2:BUFFER-VALUE) NO-ERROR. 
  WHEN "MOD" THEN ocValue = STRING(ihField1:BUFFER-VALUE MOD ihField2:BUFFER-VALUE) NO-ERROR. 
  WHEN "AGE" THEN DO:
    IF VALID-HANDLE(ihField2) THEN
      ocValue = STRING(YEAR(ihField2:BUFFER-VALUE) - YEAR(ihField1:BUFFER-VALUE) - IF (MONTH(ihField2:BUFFER-VALUE) = MONTH(ihField1:BUFFER-VALUE) AND DAY(ihField2:BUFFER-VALUE) GT DAY(ihField1:BUFFER-VALUE)) OR MONTH(ihField2:BUFFER-VALUE) GT MONTH(ihField1:BUFFER-VALUE) THEN 1 ELSE 0).  
    ELSE
      ocValue = STRING(YEAR(TODAY) - YEAR(ihField1:BUFFER-VALUE) - IF (MONTH(TODAY) = MONTH(ihField1:BUFFER-VALUE) AND DAY(TODAY) GT DAY(ihField1:BUFFER-VALUE)) OR MONTH(TODAY) GT MONTH(ihField1:BUFFER-VALUE) THEN 0 ELSE 1).  
  END.  
  WHEN "YEARS" THEN DO:
    IF VALID-HANDLE(ihField2) THEN
      ocValue = STRING(YEAR(ihField2:BUFFER-VALUE) - YEAR(ihField1:BUFFER-VALUE)).  
    ELSE
      ocValue = STRING(YEAR(TODAY) - YEAR(ihField1:BUFFER-VALUE)).  
  END.  
  WHEN "MONTHS" THEN DO:
    IF VALID-HANDLE(ihField2) THEN
      ocValue = STRING(INT(STRING(YEAR(ihField2:BUFFER-VALUE)) + STRING(MONTH(ihField2:BUFFER-VALUE))) - INT(STRING(YEAR(ihField1:BUFFER-VALUE)) + STRING(MONTH(ihField1:BUFFER-VALUE)))).  
    ELSE
      ocValue = STRING(INT(STRING(YEAR(TODAY)) + STRING(MONTH(TODAY))) - INT(STRING(YEAR(ihField1:BUFFER-VALUE)) + STRING(MONTH(ihField1:BUFFER-VALUE)))).  
  END.  
  OTHERWISE DO:
    IF icOper BEGINS "CONCAT" THEN DO:
      cDelimiter = SUBSTR(icOper,7).
      IF cDelimiter = "" THEN cDelimiter = " ".
      ELSE IF LENGTH(cDelimiter) = 2 THEN cDelimiter = TRIM(cDelimiter).
      ELSE IF cDelimiter = "comma" THEN cDelimiter = ", ".
      ocValue = STRING(ihField1:BUFFER-VALUE) + cDelimiter + STRING(ihField2:BUFFER-VALUE) NO-ERROR. 
    END.
    ELSE IF icOper BEGINS "COND" THEN DO:
      IF (CAN-DO("INTEGER,DECIMAL",ihField2:DATA-TYPE) AND ihField2:BUFFER-VALUE NE 0) 
         OR (ihField2:DATA-TYPE = "CHARACTER" AND ihField2:BUFFER-VALUE NE "")
         OR (ihField2:DATA-TYPE BEGINS "DATE" AND ihField2:BUFFER-VALUE NE ?) 
         OR (ihField2:DATA-TYPE = "LOGICAL" AND ihField2:BUFFER-VALUE) THEN
        ocValue = STRING(ihField2:BUFFER-VALUE).
      ELSE   
        ocValue = STRING(ihField1:BUFFER-VALUE).
    END.  
    ELSE IF icOper MATCHES "*TODAY*" AND ihField1:DATA-TYPE = "DATE" AND ihField2:DATA-TYPE = "DATE" THEN DO:
      ASSIGN cOper1 = ENTRY(1,icOper," ")
             cOper2 = ENTRY(3,icOper," ")
             ocValue = "no".
      IF CAN-DO("LE,<=",cOper1) AND ihField1:BUFFER-VALUE LE TODAY THEN ocValue = "yes".            
      IF CAN-DO("LT,<",cOper1)  AND ihField1:BUFFER-VALUE LT TODAY THEN ocValue = "yes".            
      IF CAN-DO("GE,>=",cOper2) AND TODAY <= ihField2:BUFFER-VALUE THEN ocValue = "yes". ELSE ocValue = "no".            
      IF CAN-DO("GT,>",cOper2)  AND TODAY < ihField2:BUFFER-VALUE THEN ocValue = "yes". ELSE ocValue = "no".            
/*     LogThis("Calc date int","icOper: " + icOper + " cOper1: " + cOper1 + " cOper2: " + cOper2 + " field1: " + ihField1:STRING-VALUE + " field2: " + ihField2:STRING-VALUE + " ocValue: " + ocValue,0).*/
      
    END.  
  END.
END CASE.

END PROCEDURE.

PROCEDURE JB_can-find :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM iiBufferNum    AS INT NO-UNDO.
DEF OUTPUT PARAM ocValue        AS CHAR   NO-UNDO.

DEF VAR ix      AS INT  NO-UNDO.
DEF VAR cModExp AS CHAR NO-UNDO.

DO ix = 1 TO NUM-ENTRIES(ttSpecFlds.cCallProcParam,"¤") BY 2:
  IF ix < NUM-ENTRIES(ttSpecFlds.cCallProcParam,"¤") THEN
    cModExp = cModExp + ENTRY(ix,ttSpecFlds.cCallProcParam,"¤") + STRING(hBuffer[iiBufferNum]:BUFFER-FIELD(ENTRY(ix + 1,ttSpecFlds.cCallProcParam,"¤")):BUFFER-VALUE).
  ELSE
    cModExp = cModExp + ENTRY(ix,ttSpecFlds.cCallProcParam,"¤").
END.

ttSpecFlds.hTargetBuff:FIND-FIRST(cModExp) NO-ERROR.
ocValue = STRING(ttSpecFlds.hTargetBuff:AVAILABLE).

END PROCEDURE.

PROCEDURE JB_date_dt:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATETIME NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(DATE(idDate),"99/99/9999").


END PROCEDURE.
  
PROCEDURE JB_hhmm :
/*------------------------------------------------------------------------------
  Purpose:     Conversion of time to hh:mm time 
  Parameters:  <none>
  Notes:       Standard conversion
------------------------------------------------------------------------------*/
DEF INPUT  PARAM iiTime      AS INT  NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(iiTime,"HH:MM").
END PROCEDURE.

PROCEDURE JB_hhmmss :
/*------------------------------------------------------------------------------
  Purpose:     Conversion of time to hh:mm:ss time 
  Parameters:  <none>
  Notes:       Standard conversion
------------------------------------------------------------------------------*/
DEF INPUT  PARAM iiTime      AS INT  NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(iiTime,"HH:MM:SS").
END PROCEDURE.

PROCEDURE jb_isodate:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(YEAR(idDate),"9999") + "-" + STRING(MONTH(idDate),"99") + "-" + STRING(DAY(idDate),"99").


END PROCEDURE.
  
PROCEDURE jb_isodate_dt:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATETIME NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(YEAR(idDate),"9999") + "-" + STRING(MONTH(idDate),"99") + "-" + STRING(DAY(idDate),"99") + "T" + REPLACE(SUBSTR(STRING(idDate),12),",",".").

END PROCEDURE.
  
PROCEDURE JB_max:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihFldArray AS HANDLE NO-UNDO EXTENT 12.
DEF INPUT PARAM iCntFlds   AS INT    NO-UNDO.
DEF OUTPUT PARAM ocReturn  AS CHAR   NO-UNDO.

CASE iCntFlds:
  WHEN 2  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE)
                                     ).
  WHEN 3  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE
                                     )).
  WHEN 4  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE
                                     )).
  WHEN 5  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE
                                     )).
  WHEN 6  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE
                                     )).
  WHEN 7  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE
                                     )).
  WHEN 8  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE
                                     )).
  WHEN 9  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE
                                     )).
  WHEN 10 THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE,
                                     ihFldArray[10]:BUFFER-VALUE
                                     )).
  WHEN 11 THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE,
                                     ihFldArray[10]:BUFFER-VALUE,
                                     ihFldArray[11]:BUFFER-VALUE
                                     )).
  WHEN 12 THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE,
                                     ihFldArray[10]:BUFFER-VALUE,
                                     ihFldArray[11]:BUFFER-VALUE,
                                     ihFldArray[12]:BUFFER-VALUE
                                     )).
END.
    
END PROCEDURE.
  
PROCEDURE JB_min:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihFldArray AS HANDLE NO-UNDO EXTENT 12.
DEF INPUT PARAM iCntFlds   AS INT    NO-UNDO.
DEF OUTPUT PARAM ocReturn  AS CHAR   NO-UNDO.

CASE iCntFlds:
  WHEN 2  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE)
                                     ).
  WHEN 3  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE
                                     )).
  WHEN 4  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE
                                     )).
  WHEN 5  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE
                                     )).
  WHEN 6  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE
                                     )).
  WHEN 7  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE
                                     )).
  WHEN 8  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE
                                     )).
  WHEN 9  THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE
                                     )).
  WHEN 10 THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE,
                                     ihFldArray[10]:BUFFER-VALUE
                                     )).
  WHEN 11 THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE,
                                     ihFldArray[10]:BUFFER-VALUE,
                                     ihFldArray[11]:BUFFER-VALUE
                                     )).
  WHEN 12 THEN ocReturn = STRING(MAX(ihFldArray[1]:BUFFER-VALUE,
                                     ihFldArray[2]:BUFFER-VALUE,
                                     ihFldArray[3]:BUFFER-VALUE,
                                     ihFldArray[4]:BUFFER-VALUE,
                                     ihFldArray[5]:BUFFER-VALUE,
                                     ihFldArray[6]:BUFFER-VALUE,
                                     ihFldArray[7]:BUFFER-VALUE,
                                     ihFldArray[8]:BUFFER-VALUE,
                                     ihFldArray[9]:BUFFER-VALUE,
                                     ihFldArray[10]:BUFFER-VALUE,
                                     ihFldArray[11]:BUFFER-VALUE,
                                     ihFldArray[12]:BUFFER-VALUE
                                     )).
END.

END PROCEDURE.
  
PROCEDURE JB_month :
/*------------------------------------------------------------------------------
  Purpose:     Conversion of date to month 
  Parameters:  <none>
  Notes:       Standard conversion
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(YEAR(idDate)) + STRING(MONTH(idDate),"99").
END PROCEDURE.

PROCEDURE JB_month_dt:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATETIME NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(YEAR(idDate)) + STRING(MONTH(idDate),"99").


END PROCEDURE.
  
PROCEDURE JB_quarter :
/*------------------------------------------------------------------------------
  Purpose:     Conversion of date to quarter 
  Parameters:  <none>
  Notes:       Standard conversion
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

DEF VAR iMonth AS INT NO-UNDO.

iMonth = MONTH(idDate).
IF iMonth < 4 THEN
  ocValue = STRING(YEAR(idDate)) + "Q1".
ELSE IF iMonth < 7 THEN
  ocValue = STRING(YEAR(idDate)) + "Q2".
ELSE IF iMonth < 10 THEN
  ocValue = STRING(YEAR(idDate)) + "Q3".
ELSE 
  ocValue = STRING(YEAR(idDate)) + "Q4".

END PROCEDURE.

PROCEDURE JB_quarter_dt:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATETIME NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

DEF VAR iMonth AS INT NO-UNDO.

iMonth = MONTH(idDate).
IF iMonth < 4 THEN
  ocValue = STRING(YEAR(idDate)) + "Q1".
ELSE IF iMonth < 7 THEN
  ocValue = STRING(YEAR(idDate)) + "Q2".
ELSE IF iMonth < 10 THEN
  ocValue = STRING(YEAR(idDate)) + "Q3".
ELSE 
  ocValue = STRING(YEAR(idDate)) + "Q4".

END PROCEDURE.
  
PROCEDURE JB_total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT  PARAM iiBufferNum    AS INT NO-UNDO.
DEF OUTPUT PARAM ocValue        AS CHAR   NO-UNDO.

DEF VAR ix      AS INT  NO-UNDO.
DEF VAR cModExp AS CHAR NO-UNDO.
DEF VAR fCalc   AS DEC  NO-UNDO.
DEF VAR fTotal  AS DEC  NO-UNDO.

DO ix = 1 TO NUM-ENTRIES(ttSpecFlds.cTargetQuery,"¤") BY 2:
  IF ix < NUM-ENTRIES(ttSpecFlds.cTargetQuery,"¤") THEN
    cModExp = cModExp + ENTRY(ix,ttSpecFlds.cTargetQuery,"¤") + STRING(hBuffer[iiBufferNum]:BUFFER-FIELD(ENTRY(ix + 1,ttSpecFlds.cTargetQuery,"¤")):BUFFER-VALUE).
  ELSE 
    cModExp = cModExp + ENTRY(ix,ttSpecFlds.cTargetQuery,"¤").
END.
ttSpecFlds.hTargetQuery:QUERY-PREPARE(cModExp) NO-ERROR.

IF NOT ERROR-STATUS:ERROR THEN DO:
  ttSpecFlds.hTargetQuery:QUERY-OPEN().
  ttSpecFlds.hTargetQuery:GET-FIRST().
  REPEAT WHILE NOT ttSpecFlds.hTargetQuery:QUERY-OFF-END:
    CASE ttSpecFlds.cCallProcParam:
      WHEN "*"     THEN fCalc = ttSpecFlds.hSourceField:BUFFER-VALUE * ttSpecFlds.hSourceField2:BUFFER-VALUE NO-ERROR.
      WHEN "/"     THEN fCalc = ttSpecFlds.hSourceField:BUFFER-VALUE / ttSpecFlds.hSourceField2:BUFFER-VALUE NO-ERROR. 
      WHEN "+"     THEN fCalc = ttSpecFlds.hSourceField:BUFFER-VALUE + ttSpecFlds.hSourceField2:BUFFER-VALUE NO-ERROR. 
      WHEN "-"     THEN fCalc = ttSpecFlds.hSourceField:BUFFER-VALUE - ttSpecFlds.hSourceField2:BUFFER-VALUE NO-ERROR. 
      WHEN "MOD"   THEN fCalc = ttSpecFlds.hSourceField:BUFFER-VALUE MOD ttSpecFlds.hSourceField2:BUFFER-VALUE NO-ERROR. 
      WHEN "COUNT" THEN fCalc = 1.
      OTHERWISE fCalc = ttSpecFlds.hSourceField:BUFFER-VALUE.
    END CASE.

    IF fCalc NE ? THEN fTotal = fTotal + fCalc.

    ttSpecFlds.hTargetQuery:GET-NEXT().
  END.
  ocValue = STRING(fTotal).
END.

END PROCEDURE.

PROCEDURE JB_weekday:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = ENTRY(WEEKDAY(idDate),cWeekDayList).  


END PROCEDURE.

PROCEDURE JB_weekday_dt:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATETIME NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = ENTRY(WEEKDAY(idDate),cWeekDayList).  


END PROCEDURE.
  
PROCEDURE JB_weeknum :
/*------------------------------------------------------------------------------
  Purpose:     Conversion of date to week 
  Parameters:  <none>
  Notes:       Standard conversion
------------------------------------------------------------------------------*/
DEF INPUT  PARAM inDate      AS DATE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

DEFINE VAR yyyyww   AS INT   NO-UNDO.   /* Output week, eg 9042     */

DEFINE VARIABLE yr   AS INT  NO-UNDO.  /* Year of indate, eg 1990      */
DEFINE VARIABLE d1   AS INT  NO-UNDO.  /* Weekday of 1/1 current year, eg 2  */
                              /* (01/01/90 is a Monday)      */
DEFINE VARIABLE dat1 AS DATE NO-UNDO. /* Starting date of week 1     */
DEFINE VARIABLE wn   AS INT  NO-UNDO.  /* Week number , eg 45         */

ASSIGN
  yr   = YEAR(indate)
  d1   = WEEKDAY(DATE( 1 , 1 , yr))
  dat1 = (IF d1 LE 5 THEN DATE(1,  3, yr) - d1 ELSE
                          DATE(1, 10, yr) - d1 )
  wn   = TRUNCATE((indate - dat1 + 7) / 7 , 0)
  yyyyww = yr * 100 + wn.

IF wn < 1 THEN       /* Week 52 or 53 previous year ? */
ASSIGN
  yr     = yr - 1
  d1     = WEEKDAY(DATE( 1 , 1 , yr))
  dat1   = (IF d1 LE 5 THEN DATE(1,  3, yr) - d1 ELSE
                            DATE(1, 10, yr) - d1 )
  wn     = TRUNCATE((indate - dat1 + 7) / 7 , 0)
  yyyyww = yr * 100 + wn.

ELSE IF wn > 52 THEN  /* Week 53 this year or week 1 next year ? */
ASSIGN
  yr     = yr + 1
  d1     = WEEKDAY(DATE( 1 , 1 , yr))
  yyyyww = IF d1 EQ 6 OR d1 EQ 7 OR d1 EQ 1
              THEN (yr - 1) * 100 + 53 ELSE yr * 100 + 1.

ocValue = STRING(yyyyww).

END PROCEDURE.

PROCEDURE JB_weeknum_dt:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM inDate      AS DATETIME NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

RUN JB_weeknum (DATE(inDate),icSessionId,OUTPUT ocValue).

END PROCEDURE.
  
PROCEDURE JB_year :
/*------------------------------------------------------------------------------
  Purpose:     Conversion of date to year 
  Parameters:  <none>
  Notes:       Standard conversion
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(YEAR(idDate)).
END PROCEDURE.

PROCEDURE JB_year_dt:
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT  PARAM idDate      AS DATETIME NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocValue     AS CHAR NO-UNDO.

ocValue = STRING(YEAR(idDate)).


END PROCEDURE.
