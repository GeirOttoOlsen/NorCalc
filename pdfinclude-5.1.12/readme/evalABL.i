/* evalABL.i */
/* 02-APR-2015 jcc: creation */

/* 14-FEB-2008 jcc: resource to cache the results of evaluateABLChar */
&SCOPED-DEFINE EvalABLCharCacheSize 20000
DEFINE VARIABLE gdEvalAblCharCacheID AS DECIMAL DECIMALS 0  NO-UNDO.
DEFINE VARIABLE gdEvalAblCharCacheNumRecs AS INTEGER        NO-UNDO.

/* The following ressources are necessary to apply Solution P39990
   "How to evaluate a 4GL/ABL expression on the fly"  see comments in
    the internal procedure evaluateABLDec */
DEFINE TEMP-TABLE ttABLEval NO-UNDO FIELD dExp AS DECIMAL DECIMALS 10.
DEFINE VARIABLE gdEvalResult AS DECIMAL    NO-UNDO.
DEFINE VARIABLE gcEvalResult AS CHARACTER  NO-UNDO.

DEFINE TEMP-TABLE ttEvalAblCharCache NO-UNDO LABEL "ttEvalAblDecCache (cache for character evaluation)"
 FIELD cExp    AS CHARACTER
 FIELD cExpIdx AS CHARACTER /* substring(1, 170 of the above) */
 FIELD gdEvalAblCharCacheID AS DECIMAL DECIMALS 0
 FIELD cResult AS CHARACTER
 INDEX gdEvalAblCharCacheID IS UNIQUE gdEvalAblCharCacheID
 INDEX cExpIdx cExpIdx.

/* sla 29/09/2006  resource to cache the results of evaluateABLDec */
&SCOPED-DEFINE EvalABLDecCacheSize 20000
DEFINE VARIABLE gdEvalAblDecCacheID AS DECIMAL DECIMALS 0  NO-UNDO.
DEFINE VARIABLE gdEvalAblDecCacheNumRecs AS INTEGER        NO-UNDO.

DEFINE TEMP-TABLE ttEvalAblDecCache NO-UNDO LABEL "ttEvalAblDecCache (cache for decimal evaluation)"
 FIELD cExp    AS CHARACTER
 FIELD cExpIdx AS CHARACTER /* substring(1, 170 of the above) */
 FIELD gdEvalAblDecCacheID AS DECIMAL DECIMALS 0
 FIELD dResult AS DECIMAL
 INDEX gdEvalAblDecCacheID IS UNIQUE gdEvalAblDecCacheID
 INDEX cExpIdx cExpIdx.

FUNCTION evaluateABLCharQDyn RETURNS LOGICAL PRIVATE
  (INPUT pcABLExp AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Function called from evaluateABLDec to apply solution P39990
    Notes:    => see comment in evaluateABLDec
------------------------------------------------------------------------------*/

  gcEvalResult = pcABLExp.
  RETURN TRUE.
END FUNCTION.

FUNCTION evaluateABLDecQDyn RETURNS LOGICAL PRIVATE
  (INPUT pdABLExp AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Function called from evaluateABLDec to apply solution P39990
    Notes:    => see comment in evaluateABLDec
------------------------------------------------------------------------------*/

  gdEvalResult = pdABLExp.
  RETURN TRUE.
END FUNCTION.

PROCEDURE evaluateABLChar :
    /*------------------------------------------------------------------------------
      Purpose:  see Comment in evaluateABLDec
      Modify:   (CZ) - 01/12/2011 - ANQ-6661.        
    ------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcABLExp          AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER opcEvalResult     AS CHARACTER  NO-UNDO.
    
    DEFINE VARIABLE cErrorReturnValue AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE lQueryOK          AS LOGICAL       NO-UNDO.
    DEFINE VARIABLE iError            AS INTEGER       NO-UNDO.
    /* (CZ) */
    DEFINE VARIABLE lPattern          AS LOGICAL INITIAL FALSE   NO-UNDO.
    DEFINE VARIABLE cSep              AS CHARACTER INITIAL "!":U NO-UNDO.
    /**/
    DEFINE QUERY qttABLEval FOR ttABLEval.
    
    /* Sanity check */
    IF pcABLExp = ? THEN RETURN ERROR PROGRAM-NAME(1) + "  Unknown value passed as character expression to evaluate".
    
    /* (CZ) */
    ASSIGN lPattern = FALSE.
    IF NUM-ENTRIES(pcABLExp,cSep) = 2 THEN
       ASSIGN lPattern = TRUE
              pcABLExp = ENTRY(2,pcABLExp,cSep) NO-ERROR.
    /**/
    
    /* 14-FEB-2008 jcc: implement a cache to speed up things  */
    FIND FIRST ttEvalAblCharCache WHERE
         ttEvalAblCharCache.cExpIdx = SUBSTR(pcABLExp, 1, 170) /* truncated index to speed up the search */
     AND ttEvalAblCharCache.cExp    = pcABLExp
     NO-ERROR.
    IF AVAILABLE ttEvalAblCharCache THEN DO:
        ASSIGN
         gdEvalAblCharCacheID = gdEvalAblCharCacheID + 1
         ttEvalAblCharCache.gdEvalAblCharCacheID = gdEvalAblCharCacheID  /* make it last in the fifo */
         opcEvalResult = ttEvalAblCharCache.cResult.
        RETURN.
    END.
    
    gcEvalResult = ?. /* reset this global variable */ 
    /* (CZ) */
    lQueryOK = (IF lPattern THEN 
                   (QUERY qttABLEval:QUERY-PREPARE("FOR EACH ttABLEval WHERE DYNAMIC-FUNCTION('evaluateABLCharQDyn' IN THIS-PROCEDURE, " + QUOTER(pcABLExp) + ") = TRUE")) 
                ELSE 
                   (QUERY qttABLEval:QUERY-PREPARE("FOR EACH ttABLEval WHERE DYNAMIC-FUNCTION('evaluateABLCharQDyn' IN THIS-PROCEDURE, " + pcABLExp + ") = TRUE"))) NO-ERROR.
    /**/
    IF lQueryOK THEN lQueryOK = QUERY qttABLEval:QUERY-OPEN() NO-ERROR. /* not necessary to close it afterwards */
    
    IF NOT lQueryOK THEN DO:
        cErrorReturnValue = PROGRAM-NAME(1) + " problem to evaluate this character expression : " + pcABLExp.
        DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
            /* error 7324 is not interesting because due to the dummy query we use:
              PREPARE syntax is: {FOR | PRESELECT} EACH <buf> OF.. WHERE ... etc". (7324)
                 => so we will skip it */
            IF ERROR-STATUS:GET-NUMBER(iError) = 7324 THEN NEXT.
    
            cErrorReturnValue = cErrorReturnValue + CHR(3) + ERROR-STATUS:GET-MESSAGE(iError).
        END.
    END.
    
    
    IF lQueryOK AND gcEvalResult = ? THEN cErrorReturnValue = PROGRAM-NAME(1) + " This character expression results in unknown value: " + pcABLExp.
    IF cErrorReturnValue > "" THEN RETURN ERROR cErrorReturnValue.
    
    
    /*======================  Cache the result  =========================*/
    IF gdEvalAblCharCacheNumRecs >= {&EvalABLCharCacheSize}
     THEN FIND FIRST ttEvalAblCharCache USE-INDEX gdEvalAblCharCacheID. /* reuse oldest record */
    ELSE DO:
        CREATE ttEvalAblCharCache.
        gdEvalAblCharCacheNumRecs = gdEvalAblCharCacheNumRecs + 1.
    END.
    ASSIGN
     opcEvalResult        = gcEvalResult
     gdEvalAblCharCacheID = gdEvalAblCharCacheID + 1
     ttEvalAblCharCache.gdEvalAblCharCacheID = gdEvalAblCharCacheID  /* make it last in the fifo */
     ttEvalAblCharCache.cResult = gcEvalResult
     ttEvalAblCharCache.cExpIdx = SUBSTR(pcABLExp, 1, 170) /* truncated index to speed up the search */
     ttEvalAblCharCache.cExp    = pcABLExp.
    
    RETURN. /* This return is essential to reset a previous value kept in RETURN-VALUE 
               in an earlier call*/
END PROCEDURE.

PROCEDURE evaluateABLDec :
    /*------------------------------------------------------------------------------
      Purpose:  Implementation of solution P39990 "How to evaluate a 4GL/ABL
      expression on the fly", refined by Sebastien Lacroix May 2006.
      This version handles the case of errors in the 4GL/ABL expression, to return an
      ERROR to the caller with a return value containg a list of error messages so
      the end users can refine their formulaes.  It also handle the case of unknown
      value that can occurs with a division by 0, or instead of error 223 
         => ** Incompatible data types in expression or assignment. (223)
    
      Notes:  This is a strange and great piece of code.  The trick is to open a
      dummy dynamic query, which predicate expression calls a dynamic-function
      evaluateABLDecQDyn() with the expression to evaluate passed as an input
      parameter.  The magic is that this function actually evaluates the input
      expression, as documented in the online help page of the FUNCTION Statement, so
      the result could be used by the dummy query.  At this point we manage to keep
      track of the result in a global variable.
      At first, I tried to implement this code in a User Defined Function, but a UDF
      cannot return an error condition, so I used a procedure instead.  This way I 
      can also return a detailed error message in a RETURN-VALUE
    
      Usage:
      ======
      RUN evaluateABLDec IN hLib ('2 + 3.141592654 * 4', OUTPUT d) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN
       MESSAGE "An error occured" RETURN-VALUE
        VIEW-AS ALERT-BOX INFO BUTTONS OK.
      ELSE MESSAGE d VIEW-AS ALERT-BOX INFO BUTTONS OK.
    
      Update on 31/05/2006: Actually there is a big issue with decimal numbers in a
      4GL/ABL expression if we are running with the european numeric format.  The only
      solution is to wrap all numbers into DECIMAL('<number>')
    
      Performances obtained with an Intel Xeon 3.6GHz CPU:
      ===================================================
      Large expression (badly formatted with many spaces) with AMERICAN format :
       result = 474.5877407631   625 ms to perform 1000 evaluations (625 탎/eval)
      ( (        38833.32) - (         4000.00) - (           400.00) - (           400.00)
       - (         2000.00) - (           400.00) - (           350.00) - (         1147.00)
       - (             0.00) + (0.00) ) * ( 1 - 1 / ( 1 + (24.0000) / 100 / 360 * (24.00) ) )
    
      Large expression (badly formatted with many spaces) with EUROPEAN format :
       result = 474.5877407631    2765ms to perform 1000 evaluations (2765 탎/eval)
      ( (        38833,32) - (         4000,00) - (           400,00) - (           400,00)
       - (         2000,00) - (           400,00) - (           350,00) - (         1147,00)
       - (             0,00) + (0,00) ) * ( 1 - 1 / ( 1 + (24,0000) / 100 / 360 * (24,00) ) )
    
      Small expression 2 + 3 * 4    result = 14
       with American format: 250ms (250 탎/eval)
       with European Format: 454ms  (450 탎/eval)
    
    ------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER ipcABLExp         AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER opdEvalResult     AS DECIMAL    NO-UNDO.
    
    DEFINE VARIABLE cErrorReturnValue AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE lQueryOK          AS LOGICAL       NO-UNDO.
    DEFINE VARIABLE iError            AS INTEGER       NO-UNDO.
    DEFINE VARIABLE pcABLExp          AS CHARACTER  NO-UNDO.
    DEFINE QUERY qttABLEval FOR ttABLEval.
    
    DEFINE BUFFER ttEvalAblDecCache FOR ttEvalAblDecCache. /* limit the scope of this buffer to this procedure */
    
    /* Sanity check */
    IF ipcABLExp = ? THEN RETURN ERROR PROGRAM-NAME(1) + "  Unknown value passed as decimal expression to evaluate".
    
    pcABLExp = ipcABLExp.
    
    /* sla 29/09/2006 implement a cache to speed up things  */
    FIND FIRST ttEvalAblDecCache WHERE
         ttEvalAblDecCache.cExpIdx = SUBSTR(ipcABLExp, 1, 170) /* truncated index to speed up the search */
     AND ttEvalAblDecCache.cExp    = ipcABLExp
     NO-ERROR.
    IF AVAILABLE ttEvalAblDecCache THEN DO:
        ASSIGN
         gdEvalAblDecCacheID = gdEvalAblDecCacheID + 1
         ttEvalAblDecCache.gdEvalAblDecCacheID = gdEvalAblDecCacheID  /* make it last in the fifo */
         opdEvalResult = ttEvalAblDecCache.dResult.
        RETURN.
    END.
    
    /* Refine the decimal numbers in the expression if not using american numeric format
      This code is optimized against speed */
    DEFINE VARIABLE cOneChar         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE iLength          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE iPos             AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lNumber          AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE pcABLExpToRefine AS CHARACTER   NO-UNDO.
    
    
    IF SESSION:NUMERIC-FORMAT <> "AMERICAN" THEN DO:
        /* First remove unecessary spaces, this can lead to 30% gain */
        DO WHILE TRUE:
            IF INDEX(pcABLExp, "  ") = 0 THEN LEAVE.
            pcABLExp = REPLACE(pcABLExp, "  ", " ").
        END.
    
        ASSIGN
         pcABLExpToRefine = pcABLExp + " " /* Required for a possible last "')" to add at the end */
         pcABLExp = ""
         iLength  = LENGTH(pcABLExpToRefine).
        DO iPos = 1 TO iLength:
            cOneChar = SUBSTR(pcABLExpToRefine, iPos, 1).
    
            IF NOT lNumber
             AND INDEX("0123456789", cOneChar) > 0  
             THEN ASSIGN
              pcABLExp = pcABLExp + "DECIMAL('"
              lNumber = YES.
    
            /* sla 07/08/2006 special case with '-' when used for a negative sign
             We have to make '-3' become 'DECIMAL(-3)' or '- DECIMAL(3)'
              but not ' -DECIMAL(3)   => '- DECIMAL(3)' is much easier*/
            IF cOneChar = "-" THEN DO:
                 pcABLExp = pcABLExp + "- ".
                NEXT.
            END.
    
            IF INDEX("0123456789.,", cOneChar) = 0
             AND lNumber
             THEN ASSIGN
              lNumber = NO
              pcABLExp = pcABLExp + "')" + cOneChar.
            ELSE pcABLExp = pcABLExp + cOneChar.
        END.
    END.
    /* End refine the decimal numbers [...] not using american numeric format */
    
    
    gdEvalResult = ?. /* reset this global variable.  A few errors like 223 (incompatible data types)
     cannot be caught with this mecanism, but leave the global varial with its previous value.  As we
     check that the result is not unknow at the end, we will then be able to catch this kind of situation */  
    
    lQueryOK = QUERY qttABLEval:QUERY-PREPARE("FOR EACH ttABLEval WHERE DYNAMIC-FUNCTION('evaluateABLDecQDyn' IN THIS-PROCEDURE, " + pcABLExp + ") = TRUE") NO-ERROR.
    IF lQueryOK THEN lQueryOK = QUERY qttABLEval:QUERY-OPEN() NO-ERROR. /* not necessary to close it afterwards */
    
    IF NOT lQueryOK THEN DO:
        cErrorReturnValue = PROGRAM-NAME(1) + " problem to evaluate this decimal expression: " + pcABLExp.
        DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
            /* error 7324 is not interesting because due to the dummy query we use:
              PREPARE syntax is: {FOR | PRESELECT} EACH <buf> OF.. WHERE ... etc". (7324)
                 => so we will skip it */
            IF ERROR-STATUS:GET-NUMBER(iError) = 7324 THEN NEXT.
    
            cErrorReturnValue = cErrorReturnValue + CHR(3) + ERROR-STATUS:GET-MESSAGE(iError).
        END.
    END.
    
    IF lQueryOK AND gdEvalResult = ?
     THEN cErrorReturnValue = PROGRAM-NAME(1) + " This decimal expression results in unknown value: "
                              + pcABLExp.
    
    IF cErrorReturnValue > "" THEN RETURN ERROR cErrorReturnValue.
    
    
    /*======================  Cache the result  =========================*/
    IF gdEvalAblDecCacheNumRecs >= {&EvalABLDecCacheSize}
     THEN FIND FIRST ttEvalAblDecCache USE-INDEX gdEvalAblDecCacheID. /* reuse oldest record */
    ELSE DO:
        CREATE ttEvalAblDecCache.
        gdEvalAblDecCacheNumRecs = gdEvalAblDecCacheNumRecs + 1.
    END.
    ASSIGN
     opdEvalResult       = gdEvalResult
     gdEvalAblDecCacheID = gdEvalAblDecCacheID + 1
     ttEvalAblDecCache.gdEvalAblDecCacheID = gdEvalAblDecCacheID  /* make it last in the fifo */
     ttEvalAblDecCache.dResult = gdEvalResult
     ttEvalAblDecCache.cExpIdx = SUBSTR(ipcABLExp, 1, 170) /* truncated index to speed up the search */
     ttEvalAblDecCache.cExp    = ipcABLExp.
    
    RETURN. /* This return is essential to reset a previous value kept in RETURN-VALUE in an earlier call*/
END PROCEDURE.

