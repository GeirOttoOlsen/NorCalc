/******************************************************************************

  Program:      pdfdebug.i
  
  Written By:   Jean-Christophe Cardot
  Written On:   October 2013
  
  Description:  Debug functions, procedures & defines
  
  10/11/13  JC Cardot   Moved here the debug code from pdf_inc.p

******************************************************************************/

&GLOBAL-DEFINE callStack "1: " + ( ENTRY(1,PROGRAM-NAME(1)," ") + " | 2:" + ENTRY(1,PROGRAM-NAME(2)," ") + (IF PROGRAM-NAME(3) <> ? THEN " | 3:" + ENTRY(1,PROGRAM-NAME(3)," ") ELSE "") + (IF PROGRAM-NAME(4) <> ? THEN " | 4:" + ENTRY(1,PROGRAM-NAME(4)," ") ELSE "")  + (IF PROGRAM-NAME(5) <> ? THEN " | 5:" + ENTRY(1,PROGRAM-NAME(5)," ") ELSE "")  + (IF PROGRAM-NAME(6) <> ? THEN " | 6:" + ENTRY(1,PROGRAM-NAME(6)," ") ELSE "") )

FUNCTION ABLCallStack RETURNS CHARACTER (piMaxLevel AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Build an Advanced Business Language (new name of 4GL) call Stack
            Each item in the call stack is separated by TAB (chr(9))

    Notes:  if piMaxLevel = ? or piMaxLevel = 0, then we build the complete stack,
            otherwize, we limit the stack the the provided max level
------------------------------------------------------------------------------*/
    DEFINE VARIABLE cStack     AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE iMaxLevel  AS INTEGER    NO-UNDO.
    DEFINE VARIABLE iLevel     AS INTEGER    NO-UNDO.

    /* sla 13/06/2006  the point of the following trick is to not add the call
     stack multipe times to the RETURN-VALUE, but keep the largest that was added
     earlier by a first API deeper in the call stack */
    IF INDEX(RETURN-VALUE, "#ABL Call Stack:") > 0 THEN RETURN "". 

    iMaxLevel = IF piMaxLevel = ? OR piMaxLevel = 0
                   THEN 9999999 /* we will never go this high ;) */
                   ELSE piMaxLevel + 2. /* + 2 = this very level + level of iMaxLevel */
    iLevel = 2. /* ignore PRGRAM-NAME(1) = this very level */

    DO WHILE iLevel < iMaxLevel:
        IF PROGRAM-NAME(iLevel) = ? OR PROGRAM-NAME(iLevel) = "" THEN LEAVE.

        /* 31-AUG-2007 sla: took opportunity to build the list from top to down (lowest level at TOP )*/
        cStack = cStack + "~nlevel" + STRING(iLevel - 1,">>>9") + ": " + PROGRAM-NAME(iLevel).
        iLevel = iLevel + 1.
    END.

    IF cStack > "" THEN RETURN "  #ABL Call Stack:" + cStack.

    RETURN "".   /* this should logically never come to this point */
END FUNCTION.

&GLOBAL-DEFINE adReturnValueAndStack CHR(3) + ReturnValue() + (IF INDEX(RETURN-VALUE, "#ABL Call Stack:") = 0 THEN CHR(3) + ABLCallStack(0) ELSE "")
&GLOBAL-DEFINE adCheckErrorAndReturn IF ERROR-STATUS:ERROR THEN RETURN ERROR {&adReturnValueAndStack}.

FUNCTION ReturnValue RETURNS CHARACTER () :
/*------------------------------------------------------------------------------
  Purpose:  to build a (error) RETURN-VALUE String
            adReturnValue returns:
             a) the current RETURN-VALUE if not empty
             b) OTHERWISE it returns the possible Progress ABL error
                messages contained in the ERROR-STATUS system handle.

    Notes:  In case of non handled errors (like a RUN unexistingProc  without the
    NO-ERROR option), then the Progress ABL errors can't be retrieved from
    ERROR-STATUS System handle.  I could try to use the unhandledMsgCheckStack()
    API, but I decided to not go that far, since this stack can contain unhandled
    errors that occured earlier, which could be very confusing.
------------------------------------------------------------------------------*/
    
IF RETURN-VALUE > "" THEN RETURN LEFT-TRIM(RETURN-VALUE, CHR(3)).

    DEFINE VARIABLE iError            AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cErrorReturnValue AS CHARACTER  NO-UNDO.
    
    
    DO iError = 1 TO ERROR-STATUS:NUM-MESSAGES:
        cErrorReturnValue =  cErrorReturnValue + CHR(3)
                           + ERROR-STATUS:GET-MESSAGE(iError).
    END.
    RETURN LEFT-TRIM(cErrorReturnValue, CHR(3)).

END FUNCTION.

/* &IF DEFINED(debug) <> 0 OR DEFINED(trace) <> 0 &THEN */
DEFINE STREAM debugLog.
PROCEDURE debugLog:
    DEFINE INPUT  PARAMETER pcLog AS CHARACTER   NO-UNDO.
    OUTPUT STREAM debugLog TO VALUE(SESSION:TEMP-DIRECTORY + "/debuglog.txt") APPEND.
    PUT STREAM debugLog UNFORMATTED TODAY "~t" STRING(TIME,"hh:mm:ss") "~t" pcLog "~t" REPLACE(REPLACE(ABLCallStack(0),"~n","~t"), "level   1: debugLog pdfextract.p~t", "") SKIP.
    OUTPUT STREAM debugLog CLOSE.
END.
PROCEDURE debugTrace:
    DEFINE INPUT  PARAMETER pcParams AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cProcFuncName AS CHARACTER   NO-UNDO.
    cProcFuncName = ENTRY(1, PROGRAM-NAME(2), " ").
    OUTPUT STREAM debugLog TO VALUE(SESSION:TEMP-DIRECTORY + "/trace.txt") APPEND.
    PUT STREAM debugLog UNFORMATTED
        (IF ENTRY(1, THIS-PROCEDURE:GET-SIGNATURE(cProcFuncName)) = "PROCEDURE" THEN "RUN " ELSE "")
        + ENTRY(1, PROGRAM-NAME(2), " ") + "(" + pcParams + "). /* called from " + ENTRY(1, PROGRAM-NAME(3), " ") + " */" SKIP.
    OUTPUT STREAM debugLog CLOSE.
END.

PROCEDURE outputCsv:
    DEFINE INPUT PARAMETER icFile   AS CHARACTER   NO-UNDO.

    DEFINE BUFFER TT_dict  FOR TT_dict.
    DEFINE BUFFER TT_array FOR TT_array.

    DEFINE VARIABLE c AS CHARACTER   NO-UNDO.

    IF icFile = "clipboard" THEN OUTPUT TO "clipboard".
    ELSE OUTPUT TO VALUE(icFile).
    FOR EACH TT_dict:
        c = "dict;" + STRING(TT_dict.dict_id) + ";" + TT_dict.value_type + ";" + TT_dict.dict_key + ";" +
            STRING(TT_dict.value_array_id) + ";" + STRING(TT_dict.value_dict_id) + ";" +
            STRING(TT_dict.value_indirect[1]) + ";" + STRING(TT_dict.value_indirect[2]) + ";" + TT_dict.value_scalar.
        PUT UNFORMATTED c SKIP.
    END.
    FOR EACH TT_array:
        c = "array;" + STRING(TT_array.array_id) + ";" + TT_array.value_type + ";" + STRING(TT_array.value_id) + ";" +
            STRING(TT_array.value_array_id) + ";" + STRING(TT_array.value_dict_id) + ";" +
            STRING(TT_array.value_indirect[1]) + ";" + STRING(TT_array.value_indirect[2]) + ";" + TT_array.value_scalar .
        PUT UNFORMATTED c SKIP.
    END.
    OUTPUT CLOSE.
END.

/* to prevent infinite loops & repeating twice the same object... */
DEFINE TEMP-TABLE ttOutput NO-UNDO
 FIELD TYPE AS CHARACTER
 FIELD id AS INTEGER
 INDEX ix TYPE id.

PROCEDURE outputTree:
    DEFINE INPUT PARAMETER icFile        AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER iiDictOrArray AS INTEGER     NO-UNDO.
    DEFINE INPUT PARAMETER icType        AS CHARACTER   NO-UNDO.
    DEFINE INPUT PARAMETER icIndent      AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE cIndent  AS CHARACTER   INITIAL "  " NO-UNDO.
    DEFINE VARIABLE iNumElts AS INTEGER     NO-UNDO.
    DEFINE VARIABLE lScalar  AS LOGICAL     NO-UNDO.

    DEFINE BUFFER TT_dict   FOR TT_dict.
    DEFINE BUFFER TT_array  FOR TT_array.
    DEFINE BUFFER bTT_array FOR TT_array.

    IF icFile = "clipboard" THEN OUTPUT TO "clipboard".
    ELSE IF icFile <> "" THEN OUTPUT TO VALUE(icFile).

    CASE icType:
        WHEN "ARRAY" THEN DO:
            FOR EACH TT_array WHERE TT_array.array_id = iiDictOrArray
                BY TT_array.value_id:
                CASE TT_array.value_type:
                    WHEN "SCALAR" THEN DO:
                        PUT UNFORMATTED icIndent TT_array.value_scalar SKIP.
                    END.
                    WHEN "ARRAY" THEN DO:
                        IF TT_array.value_array_id = -1 THEN
                            PUT UNFORMATTED icIndent "[ ]" SKIP.
                        ELSE DO:
                            lScalar = YES.
                            FOR EACH bTT_array WHERE bTT_array.array_id = TT_array.value_array_id:
                                ASSIGN
                                 iNumElts = iNumElts + 1
                                 lScalar = lScalar AND bTT_array.value_type = "SCALAR".
                            END.
                            PUT UNFORMATTED icIndent "[".
                            IF lScalar THEN DO:
                                FOR EACH bTT_array WHERE bTT_array.array_id = TT_array.value_array_id
                                    BY bTT_array.value_id:
                                    PUT UNFORMATTED " " bTT_array.value_scalar.
                                END.
                                PUT UNFORMATTED " ]" SKIP.
                            END.
                            ELSE DO:
                                PUT UNFORMATTED SKIP.
                                IF NOT CAN-FIND(ttOutput WHERE ttOutput.TYPE = "ARRAY" AND ttOutput.id = TT_array.value_array_id) THEN DO:
                                    CREATE ttOutput.
                                    ASSIGN
                                        ttOutput.id = TT_array.value_array_id
                                        ttOutput.TYPE = "ARRAY".
                                    RUN outputTree("", TT_array.value_array_id, "ARRAY", cIndent + icIndent).
                                END.
                                ELSE PUT UNFORMATTED cIndent icIndent "..." SKIP.
                                PUT UNFORMATTED cIndent icIndent "]" SKIP.
                            END.
                        END.
                    END.
                    WHEN "DICT" THEN DO:
                        IF TT_array.value_dict_id = -1 THEN
                            PUT UNFORMATTED icIndent "<< >>" SKIP.
                        ELSE DO:
                            PUT UNFORMATTED icIndent "<<" SKIP.
                            IF NOT CAN-FIND(ttOutput WHERE ttOutput.TYPE = "DICT" AND ttOutput.id = TT_array.value_dict_id) THEN DO:
                                CREATE ttOutput.
                                ASSIGN
                                    ttOutput.id = TT_array.value_dict_id
                                    ttOutput.TYPE = "DICT".
                                RUN outputTree("", TT_array.value_dict_id, "DICT", cIndent + icIndent).
                            END.
                            ELSE PUT UNFORMATTED cIndent icIndent "..." SKIP.
                            PUT UNFORMATTED cIndent icIndent ">>" SKIP.
                        END.
                    END.
                END CASE.
            END.
        END.
        WHEN "DICT" THEN DO:
            {getDict TT_dict iiDictOrArray "/Type"}.
            IF AVAILABLE TT_dict THEN
                PUT UNFORMATTED icIndent TT_dict.dict_key " " TT_dict.value_scalar SKIP.
            {getDict TT_dict iiDictOrArray "/Subtype"}.
            IF AVAILABLE TT_dict THEN
                PUT UNFORMATTED icIndent TT_dict.dict_key " " TT_dict.value_scalar SKIP.
            FOR EACH TT_dict WHERE TT_dict.dict_id = iiDictOrArray
                               AND NOT CAN-DO("/Type,/Subtype", TT_dict.dict_key):
                CASE TT_dict.value_type:
                    WHEN "SCALAR" THEN DO:
                        PUT UNFORMATTED icIndent TT_dict.dict_key " " TT_dict.value_scalar SKIP.
                    END.
                    WHEN "ARRAY" THEN DO:
                        IF TT_dict.value_array_id = -1 THEN
                            PUT UNFORMATTED icIndent TT_dict.dict_key " [ ]" SKIP.
                        ELSE DO:
                            lScalar = YES.
                            FOR EACH bTT_array WHERE bTT_array.array_id = TT_dict.value_array_id:
                                ASSIGN
                                 iNumElts = iNumElts + 1
                                 lScalar = lScalar AND bTT_array.value_type = "SCALAR".
                            END.
                            PUT UNFORMATTED icIndent TT_dict.dict_key " [".
                            IF lScalar THEN DO:
                                FOR EACH bTT_array WHERE bTT_array.array_id = TT_dict.value_array_id
                                    BY bTT_array.value_id:
                                    PUT UNFORMATTED " " bTT_array.value_scalar.
                                END.
                                PUT UNFORMATTED " ]" SKIP.
                            END.
                            ELSE DO:
                                PUT UNFORMATTED SKIP.
                                IF NOT CAN-FIND(ttOutput WHERE ttOutput.TYPE = "ARRAY" AND ttOutput.id = TT_dict.value_array_id) THEN DO:
                                    CREATE ttOutput.
                                    ASSIGN
                                        ttOutput.id = TT_dict.value_array_id
                                        ttOutput.TYPE = "ARRAY".
                                    RUN outputTree("", TT_dict.value_array_id, "ARRAY", cIndent + icIndent).
                                END.
                                ELSE PUT UNFORMATTED cIndent icIndent "..." SKIP.
                                PUT UNFORMATTED cIndent icIndent "]" SKIP.
                            END.
                        END.
                    END.
                    WHEN "DICT" THEN DO:
                        IF TT_dict.value_dict_id = -1 THEN
                            PUT UNFORMATTED icIndent TT_dict.dict_key " << >>" SKIP.
                        ELSE DO:
                            PUT UNFORMATTED icIndent TT_dict.dict_key " <<" SKIP.
                            IF NOT CAN-FIND(ttOutput WHERE ttOutput.TYPE = "DICT" AND ttOutput.id = TT_dict.value_dict_id) THEN DO:
                                CREATE ttOutput.
                                ASSIGN
                                    ttOutput.id = TT_dict.value_dict_id
                                    ttOutput.TYPE = "DICT".
                                RUN outputTree("", TT_dict.value_dict_id, "DICT", cIndent + icIndent).
                            END.
                            ELSE PUT UNFORMATTED cIndent icIndent "..." SKIP.
                            PUT UNFORMATTED cIndent icIndent ">>" SKIP.
                        END.
                    END.
                END CASE.
            END.
        END.
    END CASE.
    IF icFile <> "" THEN OUTPUT CLOSE.
END.

PROCEDURE outputCsvObjects:
    DEFINE INPUT PARAMETER icFile   AS CHARACTER   NO-UNDO.

    DEFINE BUFFER TT_Object FOR TT_Object.

    IF icFile = "clipboard" THEN OUTPUT TO "clipboard".
    ELSE OUTPUT TO VALUE(icFile).
    PUT UNFORMATTED
        "obj_stream" ";" "pdf_id" ";"
        "obj_id" ";" "gen_id" ";"
        "obj_seq" ";" "new_obj" ";"
        "obj_type" ";"
        "obj_value_type" ";"
        "obj_array_id" ";"
        "obj_dict_id" ";"
        "obj_value_indirect[1]" ";"
        "obj_value_indirect[2]" ";"
        "obj_scalar" ";"
        "page_id" ";"
        "obj_ptr" ";" "obj_size" ";"
        "stream_idx" ";" "stream_obj" ";" "stream_ptr" ";"
        "is_dirty" SKIP.
    FOR EACH TT_Object:
        PUT UNFORMATTED
            TT_Object.obj_stream ";" TT_Object.pdf_id ";"
            TT_Object.obj_id ";" TT_Object.gen_id ";"
            TT_Object.obj_seq ";" TT_Object.new_obj ";"
            TT_Object.obj_type ";"
            TT_Object.obj_value_type ";"
            TT_Object.obj_array_id ";"
            TT_Object.obj_dict_id ";"
            TT_Object.obj_value_indirect[1] ";"
            TT_Object.obj_value_indirect[2] ";"
            TT_Object.obj_scalar ";"
            TT_Object.page_id ";"
            TT_Object.obj_ptr ";" TT_Object.obj_size ";"
            TT_Object.stream_idx ";" TT_Object.stream_obj ";" TT_Object.stream_ptr ";"
            TT_Object.is_dirty SKIP.
    END.
    OUTPUT CLOSE.
END.
/* &ENDIF /* &IF DEFINED(debug) */ */

