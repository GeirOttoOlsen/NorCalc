/* Update table-to-table link
   Parameters:  <parentid>|<childid-list>

   Created: 01/04/19 by brynj
-----------------------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEF VAR ix                 AS INT    NO-UNDO.
DEF VAR iUserSettingId     AS INT    NO-UNDO.
DEF VAR hAsLib 	           AS HANDLE NO-UNDO.

hAsLib = DYNAMIC-FUNCTION("startASlib" IN SOURCE-PROCEDURE).

/* To make the lib available to a sub-procedure: */
FUNCTION startASlib RETURNS HANDLE():
  RETURN hAsLib.
END FUNCTION.

ASSIGN iUserSettingId = INT(ENTRY(1,icParam,";"))
       icParam        = ENTRY(2,icParam,";")
       .

DEF BUFFER bJUS FOR JBoxUserSetting.     

FIND JBoxUserSetting NO-LOCK 
     WHERE JBoxUserSetting.iJBoxUserSettingId = iUserSettingId
     NO-ERROR.

IF AVAIL JBoxUserSetting THEN DO TRANSACTION:     

  FOR EACH bJUS EXCLUSIVE-LOCK
      WHERE bJUS.cSourceFile  = JBoxUserSetting.cSourceFile
        AND bJUS.cObjectName  = JBoxUserSetting.cObjectName
        AND bJUS.cContext     = JBoxUserSetting.cContext
        AND bJUS.cSettingName = JBoxUserSetting.cSettingName 
        AND bJUS.cCreatedBy NE bJUS.cJBoxUserId
      :
    FIND FIRST JBoxUser NO-LOCK
         OF bJUS NO-ERROR.
    IF NOT AVAIL JBoxUser OR (AVAIL JBoxUser AND LOOKUP(STRING(ROWID(JBoxUser)),icParam) = 0) THEN
      DELETE bJUS.
  END.
  DO ix = 1 TO NUM-ENTRIES(icParam):
    FIND JBoxUser NO-LOCK
         WHERE ROWID(JBoxUser) = TO-ROWID(ENTRY(ix,icParam))
         NO-ERROR.
    IF AVAIL JBoxUser AND NOT CAN-FIND(FIRST bJUS OF JBoxUser
                                       WHERE bJUS.cSourceFile  = JBoxUserSetting.cSourceFile
                                         AND bJUS.cObjectName  = JBoxUserSetting.cObjectName
                                         AND bJUS.cContext     = JBoxUserSetting.cContext
                                         AND bJUS.cSettingName = JBoxUserSetting.cSettingName) THEN DO:
      CREATE bJUS.
      BUFFER-COPY JBoxUserSetting EXCEPT iJBoxUserSettingId cJBoxUserId TO bJUS.  
      ASSIGN bJUS.cJBoxUserId = JBoxUser.cJBoxUserId
             bJUS.cCreatedBy  = DYNAMIC-FUNCTION("getASuserId")
             bJUS.dCreated    = TODAY.
    END.
  END.                                                       
END.

FINALLY:
  obOk = ocReturn = "".
END FINALLY.
