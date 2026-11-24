/* Copy user settings to a set of users
   Parameter string:
   <SourceFile>¤<ObjectName>¤<Context>¤<SettingNameList>¤<rowidlist(JBoxUser)
   Created 29 june 10 by brynjar@chemistry.no
-----------------------------------------------------------------------*/
DEF INPUT  PARAM icParam     AS CHAR NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG NO-UNDO.

DEFINE VARIABLE cContext         AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cObjectName      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cRowIdList       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSettingNameList AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSourceFile      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cSourceUser      AS CHARACTER   NO-UNDO.
DEFINE VARIABLE ix               AS INTEGER     NO-UNDO.
DEF VAR hbJBoxUserSetting        AS HANDLE      NO-UNDO.
DEF VAR bJBoxUserSetting         AS HANDLE      NO-UNDO.
DEF VAR hbJBoxUser               AS HANDLE      NO-UNDO.
DEF VAR hqUserSetting            AS HANDLE      NO-UNDO.
DEF VAR bFound                   AS LOG         NO-UNDO.

{incl/validatecaller.i}

IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUser",OUTPUT hbJBoxUser) THEN RETURN.
IF NOT JBoxServerSide:Instance:getTableBuffer("JBoxUserSetting",OUTPUT hbJBoxUserSetting) THEN RETURN.

CREATE BUFFER bJBoxUserSetting FOR TABLE "JBoxUserSetting".

ASSIGN cSourceFile      = ENTRY(1,icParam,"¤")
       cObjectName      = ENTRY(2,icParam,"¤")
       cContext         = ENTRY(3,icParam,"¤")
       cSettingNameList = ENTRY(4,icParam,"¤")
       cRowIdList       = ENTRY(5,icParam,"¤")
       cSourceUser      = DYNAMIC-FUNCTION("getASuserId")
       NO-ERROR.

IF ERROR-STATUS:ERROR THEN DO:
  ocReturn = "Error in parameters to server procedure " + PROGRAM-NAME(1) + CHR(10) 
           + ERROR-STATUS:GET-MESSAGE(1).
  RETURN.
END.

UpdateUserSettings:
DO TRANSACTION ON ERROR UNDO,LEAVE:
  bFound = bJBoxUserSetting:FIND-FIRST("WHERE JBoxUserSetting.cJBoxUserId = '" + cSourceUser + "'"
                                     + " AND JBoxUserSetting.cSourceFile  = '" + cSourceFile + "'"
                                     + " AND JBoxUserSetting.cObjectName  = '" + cObjectName + "'"
                                     + " AND JBoxUserSetting.cContext     = '" + cContext + "'"
                                     + " AND CAN-DO('" + cSettingNameList + "',cSettingName)",NO-LOCK) NO-ERROR.
  IF bFound THEN DO:
    CREATE QUERY hqUserSetting.
    hqUserSetting:SET-BUFFERS(bJBoxUserSetting).
    hqUserSetting:QUERY-PREPARE("FOR EACH JBoxUserSetting NO-LOCK"
                              + " WHERE JBoxUserSetting.cJBoxUserId = '" + cSourceUser + "'"
                              + " AND JBoxUserSetting.cSourceFile   = '" + cSourceFile + "'"
                              + " AND JBoxUserSetting.cObjectName   = '" + cObjectName + "'"
                              + " AND JBoxUserSetting.cContext      = '" + cContext + "'"
                              + " AND CAN-DO('" + cSettingNameList + "',cSettingName)").
    hqUserSetting:QUERY-OPEN ().
    REPEAT WHILE hqUserSetting:GET-NEXT():
      DO ix = 1 TO NUM-ENTRIES(cRowIdList):
        bFound = hbJBoxUser:FIND-FIRST("WHERE ROWID(JBoxUser) = TO-ROWID('" + ENTRY(ix,cRowIdList) + "')",NO-LOCK)
                                       NO-ERROR.
        IF bFound AND hbJBoxUser::cJBoxUserId NE cSourceUser THEN DO:
          bFound = hbJBoxUserSetting:FIND-FIRST("WHERE JBoxUserSetting.cJBoxUserId = '" + hbJBoxUser::cJBoxUserId + "'"
                                              + " AND JBoxUserSetting.cSourceFile  = '" + cSourceFile + "'"
                                              + " AND JBoxUserSetting.cObjectName  = '" + cObjectName + "'"
                                              + " AND JBoxUserSetting.cContext     = '" + cContext + "'"
                                              + " AND JBoxUserSetting.cSettingName = '" + bJBoxUserSetting::cSettingName + "'",EXCLUSIVE-LOCK,NO-WAIT)
                   NO-ERROR.
  
          IF hbJBoxUserSetting:LOCKED THEN DO:
            ocReturn = "Usersettings are locked for update" + PROGRAM-NAME(1).
            UNDO, LEAVE UpdateUserSettings.
          END.
          ELSE IF NOT bFound THEN DO:
            hbJBoxUserSetting:BUFFER-CREATE().
            ASSIGN hbJBoxUserSetting::cJBoxUserId  = hbJBoxUser::cJBoxUserId
                   hbJBoxUserSetting::dCreated     = TODAY
                   hbJBoxUserSetting::cCreatedBy   = cSourceUser
                   hbJBoxUserSetting::cSourceFile  = cSourceFile
                   hbJBoxUserSetting::cObjectName  = cObjectName
                   hbJBoxUserSetting::cContext     = cContext
                   hbJBoxUserSetting::cSettingName = bJBoxUserSetting::cSettingName
                   .
          END.
          ELSE
            ASSIGN hbJBoxUserSetting::dModified   = TODAY
                   hbJBoxUserSetting::cModifiedBy = cSourceUser.

          hbJBoxUserSetting::cSetting = bJBoxUserSetting::cSetting. 
        END.
      END.
    END.
  END.
  ELSE 
    DO ix = 1 TO NUM-ENTRIES(cRowIdList):
      bFound = hbJBoxUser:FIND-FIRST("WHERE ROWID(JBoxUser) = TO-ROWID('" + ENTRY(ix,cRowIdList) + "')",NO-LOCK)
                                     NO-ERROR.
      IF bFound AND hbJBoxUser::cJBoxUserId NE cSourceUser THEN DO:
        CREATE QUERY hqUserSetting.
        hqUserSetting:SET-BUFFERS(bJBoxUserSetting).
        hqUserSetting:QUERY-PREPARE("FOR EACH JBoxUserSetting EXCLUSIVE-LOCK"
                                  + " WHERE JBoxUserSetting.cJBoxUserId = '" + hbJBoxUser::cJBoxUserId + "'"
                                  + " AND JBoxUserSetting.cSourceFile   = '" + cSourceFile + "'"
                                  + " AND JBoxUserSetting.cObjectName   = '" + cObjectName + "'"
                                  + " AND JBoxUserSetting.cContext      = '" + cContext + "'"
                                  + " AND CAN-DO('" + cSettingNameList + "',cSettingName)").
        hqUserSetting:QUERY-OPEN ().
        REPEAT WHILE hqUserSetting:GET-NEXT():
          hbJBoxUserSetting:BUFFER-DELETE ().
        END.
      END.  
    END.
END.

FINALLY:
  DELETE OBJECT hqUserSetting     NO-ERROR.
  DELETE OBJECT bJBoxUserSetting  NO-ERROR.
  DELETE OBJECT hbJBoxUserSetting NO-ERROR.
  DELETE OBJECT hbJBoxUser        NO-ERROR.
  obOK = ocReturn = "".
END.  
