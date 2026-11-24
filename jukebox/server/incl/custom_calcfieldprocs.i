/* Make a copy of this file to the <project>/server/incl catalog for adding your own
   standard procedures for frequently used calculated fields.
   Extra well suited if the procedures are not bound to a particular source buffer. */

DEF VAR bUserQueryExecLogged AS LOG NO-UNDO.
DEF VAR hbJBoxUserSetting    AS HANDLE NO-UNDO.
DEF VAR cParameterCopy       AS CHAR   NO-UNDO.
DEF VAR cQueryCriteriaCopy   AS CHAR   NO-UNDO.
DEF VAR cBuffersAndFldsCopy  AS CHAR   NO-UNDO.

ASSIGN cBuffersAndFldsCopy = icBuffersAndFields
       cQueryCriteriaCopy  = icQueryCriteria
       cParameterCopy      = icParam
       .

CREATE BUFFER hbJBoxUserSetting FOR TABLE "JBoxUserSetting" NO-ERROR.

PROCEDURE LogUserQueryExec:
  DEF INPUT  PARAM irSomeRowid     AS ROWID NO-UNDO.
  DEF INPUT  PARAM icUserSettingId AS CHAR  NO-UNDO.
  DEF INPUT  PARAM icSessionId     AS CHAR  NO-UNDO.
  DEF OUTPUT PARAM ocReturn        AS CHAR  NO-UNDO.
  
  DEF VAR cLogFile            AS CHAR NO-UNDO.
  DEF VAR ix                  AS INT  NO-UNDO.
  DEF VAR cConvParamChr1      AS CHAR NO-UNDO.
  DEF VAR cConvParamChr3      AS CHAR NO-UNDO.
  DEF VAR cConvParamChr28     AS CHAR NO-UNDO.
  DEF VAR cParentSettingName  AS CHAR NO-UNDO.
  DEF VAR cParentContext      AS CHAR NO-UNDO.
  DEF VAR cParentSourceFile   AS CHAR NO-UNDO.
  DEF VAR cParentCreatedBy    AS CHAR NO-UNDO.
  DEF VAR cViewFields         AS CHAR NO-UNDO.
  
  IF icUserSettingId NE "" AND NOT bUserQueryExecLogged AND VALID-HANDLE(hbJBoxUserSetting) THEN DO: 
    bUserQueryExecLogged = YES.
    hbJBoxUserSetting:FIND-FIRST ("WHERE iJBoxUserSettingId = " + icUserSettingId, NO-LOCK) NO-ERROR.
    IF hbJBoxUserSetting:AVAIL THEN DO:
      
      ASSIGN cParentSettingName   = hbJBoxUserSetting::cSettingName
             cParentContext       = hbJBoxUserSetting::cContext
             cParentSourceFile    = hbJBoxUserSetting::cSourceFile
             cParentCreatedBy     = hbJBoxUserSetting::cCreatedBy
             .       
      
      DO ix = 1 TO NUM-ENTRIES(cParameterCopy,CHR(1)):
        cConvParamChr1 = cConvParamChr1 + (IF cConvParamChr1 NE "" THEN '" + CHR(1) + "' ELSE "") + ENTRY(ix,cParameterCopy,CHR(1)).
      END.
      DO ix = 1 TO NUM-ENTRIES(cConvParamChr1,CHR(3)):
        cConvParamChr3 = cConvParamChr3 + (IF cConvParamChr3 NE "" THEN '" + CHR(3) + "' ELSE "") + ENTRY(ix,cConvParamChr1,CHR(3)).
      END.
      DO ix = 1 TO NUM-ENTRIES(cConvParamChr3,CHR(28)):
        cConvParamChr28 = cConvParamChr28 + (IF cConvParamChr28 NE "" THEN '" + CHR(28) + "' ELSE "") + ENTRY(ix,cConvParamChr3,CHR(28)).
      END.
        
//      cConvParamChr28 = REPLACE(cConvParamChr28,' + CHR(28) + ','" + CHR(28) + "').  
      
      cLogFile = "UserQueryExec_" + icUserSettingId + "_" + cCurrUserId + ".log".
      OUTPUT TO VALUE(cLogFile).
      PUT UNFORMATTED 
          "/* Query exec parameters: */"             SKIP(1)
          "RUN jbserv_gettemptablejoin.p"            SKIP  
          '/* icSessionId */           (<sessionid>' SKIP 
          '/* iiBatchSize */           ,0'           SKIP  
          '/* iiStartRow */            ,0'           SKIP              
          '/* icDirection */           ,""'          SKIP             
          '/* icBuffersAndFields */    ,"' + cBuffersAndFldsCopy + '"' SKIP
          '/* icQueryCriteria */       ,"' + cQueryCriteriaCopy + '"' SKIP
          '/* icStatFields */          ,""' SKIP
          '/* icParam */               ,"' + cConvParamChr28 + '"' SKIP
          '/* ohTempTable */           ,OUTPUT TABLE-HANDLE hTT' SKIP 
          '/* ocStatFieldsAndValues */ ,OUTPUT cStatFldsAndValues' SKIP 
          '/* ocReturn */              ,OUTPUT cReturn).' SKIP
           .

      hbJBoxUserSetting:FIND-FIRST ("WHERE cObjectName  = '" + cParentSettingName + "'"
                                   + " AND cContext     = '" + cParentContext + "'"
                                   + " AND cSourceFile  = '" + cParentSourceFile + "'"
                                   + " AND cJBoxUserId  = '" + cParentCreatedBy + "'"
                                   + " AND cSettingName = 'accumviewfields'", NO-LOCK) NO-ERROR.
      IF hbJBoxUserSetting:AVAIL THEN
        PUT UNFORMATTED SKIP(1)
            '/* Accum view-fields: */ ' hbJBoxUserSetting::cSetting SKIP.
      ELSE DO:
        hbJBoxUserSetting:FIND-FIRST ("WHERE cObjectName  = '" + cParentSettingName + "'"
                                     + " AND cContext     = '" + cParentContext + "'"
                                     + " AND cSourceFile  = '" + cParentSourceFile + "'"
                                     + " AND cJBoxUserId  = '" + cParentCreatedBy + "'"
                                     + " AND cSettingName = 'currviewfields'", NO-LOCK) NO-ERROR.
        IF hbJBoxUserSetting:AVAIL THEN
          PUT UNFORMATTED SKIP(1)
              '/* Current view-fields: */ ' hbJBoxUserSetting::cSetting SKIP.
      END.
      
      OUTPUT CLOSE.
      
      FILE-INFO:FILE-NAME = cLogFile.
      LogThis("UserQuery","Logfile: " + FILE-INFO:FULL-PATHNAME,1).
    END.
    ELSE LogThis("UserQuery","Failed to log UserSettingId " + icUserSettingId,1).
  END.

END PROCEDURE.
  
/* This is an example:

Usage (sequence is important in this case):

        + ";+UdfId|CHARACTER|x(16)|udfId(ROWIDsite)|UdfId"
        + ";+UdfDataExist|LOGICAL|y/n|udfDataExist(site-id)|Udf data"

DEF VAR cCalitaTable   AS CHAR NO-UNDO.
DEF VAR cCalitaStudyId AS CHAR NO-UNDO.
DEF VAR cCalitaUdfId   AS CHAR NO-UNDO.
                      
startASlib().

cCalitaStudyId = ENTRY(1,DYNAMIC-FUNCTION("getSessionContext")).

PROCEDURE udfId:
  DEF INPUT  PARAM irTable       AS ROWID NO-UNDO.
  DEF INPUT  PARAM icCalitaTable AS CHAR  NO-UNDO.
  DEF INPUT  PARAM icSessionId   AS CHAR  NO-UNDO.
  DEF OUTPUT PARAM ocReturn      AS CHAR  NO-UNDO.

  cCalitaTable = icCalitaTable.

  FIND FIRST USERDEF NO-LOCK
       WHERE USERDEF.table-name = cCalitaTable
         AND USERDEF.proj-id    = cCalitaStudyId
       NO-ERROR.
  IF AVAIL USERDEF THEN
    ocReturn = USERDEF.userdef-id.

  cCalitaUdfId = ocReturn.
END PROCEDURE.

PROCEDURE udfDataExist:    
  DEF INPUT  PARAM icRecordId    AS CHAR  NO-UNDO.
  DEF INPUT  PARAM icSessionId   AS CHAR  NO-UNDO.
  DEF OUTPUT PARAM ocReturn      AS CHAR  NO-UNDO.

  FIND FIRST UDFDATA NO-LOCK
       WHERE UDFDATA.tab-pk     = icRecordId
         AND UDFDATA.table-name = cCalitaTable
         AND UDFDATA.proj-id    = cCalitaStudyId
         AND UDFDATA.f-data     NE ""
       NO-ERROR.
  
  ocReturn = IF AVAIL UDFDATA THEN "yes" ELSE "no".
END PROCEDURE.

*/   
