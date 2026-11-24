/* Send email alert message
   Created: 02-dec-12 by brynjar@chemistry.no
   NOTE: Must be run in Client-Server mode..
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR   NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR   NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG    NO-UNDO.

{incl/validatecaller.i}

DEFINE VAR hQuery            AS HANDLE NO-UNDO.
DEFINE VAR cUserId           AS CHAR   NO-UNDO.
DEFINE VAR ix                AS INT    NO-UNDO.
DEFINE VAR cBody             AS CHAR   NO-UNDO.
DEFINE VAR cFrom             AS CHAR   NO-UNDO.
DEFINE VAR cTo               AS CHAR   NO-UNDO.
DEFINE VAR cSubject          AS CHAR   NO-UNDO.
DEFINE VAR iProcessStepId    AS INT    NO-UNDO.
DEFINE VAR iProcessTriggerId AS INT    NO-UNDO.
DEFINE VAR cAttachments      AS CHAR   NO-UNDO.
DEF VAR hbJBoxProcessStepParam AS HANDLE NO-UNDO.
DEF VAR hqStepParam            AS HANDLE NO-UNDO.
DEF VAR hbJBoxEmailInbox       AS HANDLE NO-UNDO.
DEF VAR hbJBoxEmailAccount     AS HANDLE NO-UNDO.
DEF VAR hbJBoxDocRel           AS HANDLE NO-UNDO.
DEF VAR hbJBoxDocument         AS HANDLE NO-UNDO.
DEF VAR cParamName             AS CHAR   NO-UNDO.
DEF VAR bFound                 AS LOG    NO-UNDO.
DEF VAR hqDoc                  AS HANDLE NO-UNDO.

ASSIGN cUserId    = DYNAMIC-FUNCTION("getASuserId" IN SOURCE-PROCEDURE)
       .

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxProcessStepParam",OUTPUT hbJBoxProcessStepParam) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxJBoxEmailInbox",OUTPUT hbJBoxEmailInbox) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxEmailAccount",OUTPUT hbJBoxEmailAccount) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxDocRel",OUTPUT hbJBoxDocRel) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxDocument",OUTPUT hbJBoxDocument) THEN RETURN.

DO ix = 1 TO NUM-ENTRIES(icParam,";"):
  CASE ENTRY(1,ENTRY(ix,icParam,";"),"|"):
    WHEN "processStep"    THEN iProcessStepId    = INTEGER(ENTRY(2,ENTRY(ix,icParam,";"),"|")) NO-ERROR.
    WHEN "processTrigger" THEN iProcessTriggerId = INTEGER(ENTRY(2,ENTRY(ix,icParam,";"),"|")) NO-ERROR.
  END CASE.
END.

CREATE QUERY hqStepParam.
hqStepParam:SET-BUFFERS(hbJBoxProcessStepParam).
hqStepParam:QUERY-PREPARE("FOR EACH JBoxProcessStepParam NO-LOCK WHERE JBoxProcessStepParam.iJBoxProcessStepId = " + STRING(iProcessStepId)
                        + " AND (JBoxProcessStepParam.iJBoxProcessRelId = iProcessTriggerId OR JBoxProcessStepParam.iJBoxProcessRelId = 0)").
hqStepParam:QUERY-OPEN ().
REPEAT WHILE hqStepParam:GET-NEXT():
  cParamName = hbJBoxProcessStepParam::cParameterName.                        
  CASE cParamName:
    WHEN "MailSubject" THEN cSubject = hbJBoxProcessStepParam::cParameterText.
    WHEN "MailTo"      THEN cTo      = cTo + (IF cTo NE "" THEN "," ELSE "") + hbJBoxProcessStepParam::cParameterText.
  END CASE.
END.

IF cTo = "" THEN DO:
  ocReturn = "No recipients defined".
  RETURN.
END.


CREATE QUERY hQuery.
hQuery:SET-BUFFERS(ihBuffer).

CREATE QUERY hqDoc.
hqDoc:SET-BUFFERS (hbJBoxDocRel,hbJBoxDocument).

hQuery:QUERY-PREPARE("FOR EACH " + ihBuffer:NAME).
hQuery:QUERY-OPEN().
hQuery:GET-FIRST().
REPEAT WHILE NOT hQuery:QUERY-OFF-END:
  bFound = hbJBoxEmailInbox:FIND-FIRST("WHERE JBoxEmailInbox.iJBoxEmailInboxId = INTEGER('" + STRING(ihBuffer::iJBoxEmailInboxId) + "')",NO-LOCK) NO-ERROR.
  IF bFound THEN DO:

    bFound = hbJBoxEmailAccount:FIND-FIRST("WHERE iJBoxEmailAccountId = " + STRING(hbJBoxEmailInbox::iJBoxEmailAccountId),NO-LOCK) NO-ERROR.
    IF bFound THEN DO:
      cFrom = hbJBoxEmailAccount::cEmailAddress.
      IF OPSYS = "WIN32" THEN DO:
        cAttachments = "".
        
        hqDoc:QUERY-PREPARE ("FOR EACH JBoxDocRel NO-LOCK WHERE JBoxDocRel.cContext = 'JBoxEmailInbox'"
                           + " AND JBoxDocRel.cEntityId = STRING('" + hbJBoxEmailInbox::iJBoxEmailInboxId + "')"
                           + ",FIRST JBoxDocument FIELDS(cFileName cFullPathName) NO-LOCK OF JBoxDocRel"
                           + " BY JBoxDocRel.iJBoxDocumentId DESC").
        hqDoc:QUERY-OPEN ().
        REPEAT WHILE hqDoc:GET-NEXT().

          IF SEARCH(hbJBoxDocument::cFullPathName) NE ? THEN DO:
            IF hbJBoxDocument::cFullPathName MATCHES "*.gz" AND SEARCH("gzip.exe") NE ? THEN DO:
              OS-COMMAND SILENT VALUE(SEARCH("gzip.exe") + ' -df "' + hbJBoxDocument::cFullPathName + '"').
              cAttachments = cAttachments + (IF cAttachments NE "" THEN "," ELSE "") + SUBSTR(hbJBoxDocument::cFullPathName,1,LENGTH(hbJBoxDocument::cFullPathName) - 3).
            END.
            ELSE
              cAttachments = cAttachments + (IF cAttachments NE "" THEN "," ELSE "") + hbJBoxDocument::cFullPathName.
          END.
          ELSE IF SEARCH(SESSION:TEMP-DIR + hbJBoxDocument::cFileName) NE ? THEN
            cAttachments = cAttachments + (IF cAttachments NE "" THEN "," ELSE "") + SESSION:TEMP-DIR + hbJBoxDocument::cFileName.
        END.

        RUN JBoxSendBlatMail.p (
            cTo,
            hbJBoxEmailAccount::cEmailAddress,
            "",
            cSubject,
            "Fra: " + hbJBoxEmailInbox::cDisplayFrom + CHR(10)
          + "Emne: " + hbJBoxEmailInbox::cSubject,
            cAttachments,
            hbJBoxEmailAccount::cMailServer,
            hbJBoxEmailAccount::cEmailAddress,
            hbJBoxEmailAccount::cPassword,
            "",
            "",
            "",
            "",
            NO,
            NO,
            ?,
            OUTPUT obOK,
            OUTPUT ocReturn
            ).
      END.
    END.
  END.
  hQuery:GET-NEXT().
END.
  
obOk = ocReturn = "".                                                    

FINALLY:
  DELETE OBJECT hqDoc NO-ERROR.
  DELETE OBJECT hbJBoxProcessStepParam NO-ERROR.
  DELETE OBJECT hbJBoxEmailInbox NO-ERROR.
  DELETE OBJECT hbJBoxEmailAccount NO-ERROR.
  DELETE OBJECT hbJBoxDocument NO-ERROR.
  DELETE OBJECT hbJBoxDocRel NO-ERROR.
  DELETE OBJECT hQuery NO-ERROR.
END FINALLY.  