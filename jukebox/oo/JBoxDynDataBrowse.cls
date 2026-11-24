 
 /*------------------------------------------------------------------------
    File        : JBoxDynDataBrowse
    Purpose     : Dynamic databrowse with drill-down capabilities
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Tue Oct 25 12:43:22 CEST 2016
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS JBoxDynDataBrowse:
  {incl/tt_viewds.i}
 
  DEF TEMP-TABLE ttFieldBufferRef NO-UNDO // To identify correct table for fields in sql query  
      FIELD BufferName AS CHAR            // Buffer-ref is added as pipe-entry 6 in buffersandfield ref
      FIELD FieldName  AS CHAR                
      INDEX idxField FieldName 
      .
  
  DEF VAR hToolbarRect                  AS HANDLE NO-UNDO.
  DEF PUBLIC PROPERTY BROWSE-OBJECT     AS JBoxBrowse GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY TOOLBAR-OBJECT    AS JBoxToolbar GET. PROTECTED SET.
  DEF PUBLIC PROPERTY POPUP-MENU-OBJECT AS JBoxPopupMenu GET. PROTECTED SET.
  DEF PUBLIC PROPERTY DataBrwProc       AS HANDLE GET. SET.
  DEF PUBLIC PROPERTY ParentProc        AS HANDLE GET. SET. 
  DEF PUBLIC PROPERTY BrowseRect        AS HANDLE GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY getInitialRecordCount AS LOG INIT YES GET. SET. 
  DEF PUBLIC PROPERTY getBatchQueryId   AS character no-undo 
    GET():
      return DYNAMIC-FUNCTION("getBatchQueryId" IN DataBrwProc).      
    END GET. SET. 
  
  DEF PUBLIC PROPERTY EnableSaveQuery AS LOG 
      PROTECTED GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setEnableSaveQuery" IN DataBrwProc,ibSetting).
      END SET.

  DEF PUBLIC PROPERTY TotalFields AS CHAR 
      PROTECTED GET. 
      SET(icSetting AS CHAR): 
        DYNAMIC-FUNCTION("setTotalFields" IN DataBrwProc,icSetting).
      END SET.

  DEF PUBLIC PROPERTY QueryCanBeScheduled AS LOG GET():
        RETURN THIS-OBJECT:BROWSE-OBJECT:getJBoxAttribute("canSchedule") NE "no".
      END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BrowseRect,"canSchedule",STRING(ibSetting)).
      END SET.

  DEF PUBLIC PROPERTY QueryCanBeShared AS LOG GET():
        RETURN THIS-OBJECT:BROWSE-OBJECT:getJBoxAttribute("canShare") NE "no".
      END GET. 
      SET(ibSetting AS LOG): 
        DYNAMIC-FUNCTION("setAttribute",BrowseRect,"canShare",STRING(ibSetting)).
      END SET.

  DEF PUBLIC PROPERTY CalcFieldProc AS CHAR GET. 
      SET(icSetting AS CHAR):
        IF VALID-OBJECT(THIS-OBJECT:BROWSE-OBJECT) THEN
          THIS-OBJECT:BROWSE-OBJECT:calcFieldProc = icSetting.
      END SET. 
  
  DEF PUBLIC PROPERTY userSettingContext AS CHAR  
      GET(): RETURN THIS-OBJECT:BROWSE-OBJECT:userSettingContext. END GET. 
      SET(icSetting AS CHAR):
        IF VALID-OBJECT(THIS-OBJECT:BROWSE-OBJECT) THEN
          THIS-OBJECT:BROWSE-OBJECT:userSettingContext = icSetting.
      END SET. 

  DEF PUBLIC PROPERTY userSettingName AS CHAR GET. SET. /* query1,query2.. - unique within context */ 

  DEF PUBLIC PROPERTY userSettingId  AS CHAR 
      GET(): IF JBoxServerAPI:Instance:Find("JBoxUserSetting",
                                               "WHERE cSourceFile  = '" + DataBrwProc:FILE-NAME + "'"
                                             + " AND cObjectName  = 'userquery'"
                                             + " AND cContext     = '" + THIS-OBJECT:userSettingContext + "'"
                                             + " AND cSettingName = '" + THIS-OBJECT:userSettingName + "'") THEN
               RETURN JBoxServerAPI:Instance:FieldValue("iJBoxUserSettingId").
             ELSE RETURN "".   
      END GET.
      PROTECTED SET. 

  DEF PUBLIC PROPERTY queryName AS CHAR GET. SET. /* query1,query2.. - unique within context */ 

  DEF PUBLIC PROPERTY myQuery AS LOG  
      GET(): RETURN JBoxServerAPI:Instance:Find("JBoxUserSetting",
                                               "WHERE cSourceFile  = '" + DataBrwProc:FILE-NAME + "'"
                                             + " AND cObjectName  = 'userquery'"
                                             + " AND cContext     = '" + THIS-OBJECT:userSettingContext + "'"
                                             + " AND cSettingName = '" + THIS-OBJECT:userSettingName + "'"
                                             + " AND cJBoxUserId  = cCreatedBy"). 
      END GET.
      PROTECTED SET. 

  DEF PUBLIC PROPERTY contentDelimiter AS CHAR NO-UNDO INIT "~t" GET. SET.

  def public property Content as longchar
    get():
      if valid-handle(this-object:BROWSE-OBJECT:BUFFER-HANDLE) then do:
        def var qh as handle no-undo.
        def var bh as handle no-undo.
        def var lc as longchar no-undo.

        create query qh.
        bh = this-object:BROWSE-OBJECT:BUFFER-HANDLE.
        qh:set-buffers(bh).
        qh:QUERY-PREPARE ('for each ' + bh:name).
        qh:query-open().
        qh:get-first().
        JBoxLogHandling:addLog('buffer',JBoxLogHandling:getBufferLabelList(bh,contentDelimiter)).
        do while not qh:QUERY-OFF-END:
          JBoxLogHandling:addLog('buffer',JBoxLogHandling:getBufferContentList(bh,contentDelimiter)).
          qh:get-next(). 
        end.
        lc = JBoxLogHandling:writeLogType('buffer',true).
        delete object qh.
        return lc.
      end.
    end get. protected set.
    
  DEF PUBLIC PROPERTY ViewDsId           AS CHAR NO-UNDO GET. SET.  
  DEF PUBLIC PROPERTY hViewDsUserSetting AS HANDLE NO-UNDO GET.
      SET(ihUserSetting AS HANDLE):
        IF VALID-HANDLE(ihUserSetting) THEN DO:
          EMPTY TEMP-TABLE ttJBoxUserSetting.
          TEMP-TABLE ttJBoxUserSetting:COPY-TEMP-TABLE (ihUserSetting).
          hViewDsUserSetting = ihUserSetting.
        END.  
      END SET. 
  DEF PUBLIC PROPERTY ViewDsRunQueryId AS CHAR NO-UNDO GET. SET.    
  
  DEF PUBLIC PROPERTY BatchMode AS LOG NO-UNDO GET. SET.
    
  CONSTRUCTOR PUBLIC JBoxDynDataBrowse(INPUT iDataBrwProc  AS HANDLE
                                      ,INPUT iParentProc      AS HANDLE
                                      ,INPUT ihBrowseRect  AS HANDLE
                                      ,INPUT ihToolbarRect AS HANDLE
                                      ,INPUT ihSearchRect  AS HANDLE):
    ASSIGN DataBrwProc  = iDataBrwProc
           ParentProc   = iParentProc
           hToolbarRect = ihToolbarRect
           BrowseRect   = ihBrowseRect
           .
    
/*    BROWSE-OBJECT = NEW JBoxBrowse(ihBrowseRect,iParentProc,YES).*/
  END CONSTRUCTOR.
                               
  METHOD PUBLIC LOGICAL InitializeQuery (icBuffersAndFields AS CHAR
                                        ,icQuery            AS CHAR
                                        ,icInitialSort      AS CHAR
                                        ,ibRecordCount      AS LOG
                                        ,ihTempTable        AS HANDLE):
                                          
    DEF VAR cNoDisplayFields AS CHAR NO-UNDO.
    DEF VAR ix               AS INT  NO-UNDO.
    DEF VAR hBuffer          AS HANDLE NO-UNDO.
    DEF VAR cFieldList       AS CHAR NO-UNDO.
    DEF VAR iy               AS INT  NO-UNDO.

    IF VALID-HANDLE(ihTempTable) THEN DO:
      
      IF icBuffersAndFields NE "" THEN DO:
        IF ihTempTable:TYPE = "buffer" THEN
          hBuffer = ihTempTable.
        ELSE
          hBuffer = ihTempTable:DEFAULT-BUFFER-HANDLE.
        
        IF NUM-ENTRIES(icBuffersAndFields,";") > 1 THEN DO:
          DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
            DO iy = 2 TO NUM-ENTRIES(ENTRY(ix,icBuffersAndFields),";"):
              cFieldList = cFieldList + (IF cFieldList NE "" THEN "," ELSE "") + ENTRY(1,ENTRY(iy,ENTRY(ix,icBuffersAndFields),";"),"|").
            END.
          END.  
          DO ix = 1 TO hBuffer:NUM-FIELDS:
            IF LOOKUP(hBuffer:BUFFER-FIELD (ix):NAME,cFieldList) = 0 AND NOT CAN-DO("jbCountDistinct,jbAverage",hBuffer:BUFFER-FIELD (ix):NAME) THEN
              cNoDisplayFields = cNoDisplayFields + (IF cNoDisplayFields NE "" THEN "," ELSE "") + hBuffer:BUFFER-FIELD (ix):NAME.
          END.     
          DYNAMIC-FUNCTION("setAttribute",BrowseRect,"NoDisplayFields",cNoDisplayFields).
        END.
      END.  
      /* Creates the browse placeholder object. Actual browse widget is created in InitializeObject in DataBrwProc */ 
      DYNAMIC-FUNCTION("setAttribute",BrowseRect,"dataBrowseObject","yes"). /* <- until the actual browse is created the rectangle holds internal attr.settings */
      BROWSE-OBJECT = NEW JBoxBrowse(BrowseRect,ParentProc,YES,ihTempTable,YES). /* Last parameter: set dataBrowseObject type */
      BROWSE-OBJECT:useLocalData = YES.
      BROWSE-OBJECT:setJBoxAttribute("bufferlist",ihTempTable:NAME).
    END.  
    ELSE DO:
      IF icQuery = "," THEN icQuery = "WHERE false".
      ELSE IF icQuery BEGINS "," THEN icQuery = "WHERE false" + icQuery.     
      BROWSE-OBJECT = NEW JBoxBrowse(BrowseRect,ParentProc,YES).
    END.        
    
    BROWSE-OBJECT:calcFieldProc = THIS-OBJECT:CalcFieldProc.
    BROWSE-OBJECT:userSettingContext = THIS-OBJECT:userSettingContext.            
    
    DYNAMIC-FUNCTION("setBrowseObject" IN DataBrwProc,BROWSE-OBJECT).
                
    DYNAMIC-FUNCTION("setObjectSourceProc",DataBrwProc).
    
    RUN InitializeObject IN DataBrwProc (icBuffersAndFields,icQuery,icInitialSort,ibRecordCount AND getInitialRecordCount).
                                          
    THIS-OBJECT:BROWSE-OBJECT:setBrowseHandle(DYNAMIC-FUNCTION("getBrowseHandle" IN DataBrwProc)).
    THIS-OBJECT:BROWSE-OBJECT:setJBoxAttribute("keepsearchvalue","yes").
    
    DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields,";"):
      IF NUM-ENTRIES(ENTRY(ix,icBuffersAndFields,";"),"|") > 3 AND ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|") NE "" THEN
        THIS-OBJECT:BROWSE-OBJECT:setJBoxAttribute("calcProc" + SUBSTR(ENTRY(1,ENTRY(ix,icBuffersAndFields,";"),"|"),2),ENTRY(1,ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|"),"(")).
    END.
    IF VALID-HANDLE(ihTempTable) AND icBuffersAndFields = "" THEN
      THIS-OBJECT:BROWSE-OBJECT:setJBoxAttribute("bufferlist",ihTempTable:NAME).    
    
    DYNAMIC-FUNCTION("setObjectSourceFileHandle",DYNAMIC-FUNCTION("getBrowseHandle" IN DataBrwProc),DataBrwProc).
    TOOLBAR-OBJECT = NEW JBoxToolbar(hToolbarRect,ParentProc).
    BROWSE-OBJECT:TOOLBAR-OBJECT = TOOLBAR-OBJECT.
    &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    POPUP-MENU-OBJECT = NEW JBoxPopupMenu(THIS-OBJECT:BROWSE-OBJECT:BROWSE-HANDLE:POPUP-MENU,ParentProc).
    BROWSE-OBJECT:POPUP-MENU-OBJECT = POPUP-MENU-OBJECT. 
    DYNAMIC-FUNCTION("NewObject",DataBrwProc:CURRENT-WINDOW,BROWSE-OBJECT:BROWSE-HANDLE:POPUP-MENU,"popupMenu").
    DYNAMIC-FUNCTION("createObjectLink",BROWSE-OBJECT:BROWSE-HANDLE:POPUP-MENU,BROWSE-OBJECT:BROWSE-HANDLE).
    &ENDIF    
    PUBLISH "SizeToFitTab" FROM DataBrwProc (DataBrwProc:CURRENT-WINDOW).
    
  END METHOD.

  METHOD PUBLIC LOGICAL InitializeQuery (icBuffersAndFields AS CHAR
                                        ,icQuery            AS CHAR
                                        ,icInitialSort      AS CHAR
                                        ,ibRecordCount      AS LOG
                                        ,icSQLdb            AS CHAR):
                                          
    DEF VAR cField                AS CHAR   NO-UNDO.
    DEF VAR cBuffersAndFields     AS CHAR   NO-UNDO.
    DEF VAR cViewBuffersAndFields AS CHAR   NO-UNDO.
    DEF VAR ix                    AS INT    NO-UNDO.
    DEF VAR hBuffer               AS HANDLE NO-UNDO.
    DEF VAR hTT                   AS HANDLE NO-UNDO. 
    DEF VAR cCalcFlds             AS CHAR   NO-UNDO.
    DEF VAR cCalcParams           AS CHAR   NO-UNDO.    
    DEF VAR cBufferList           AS CHAR   NO-UNDO.   
    DEF VAR cQueryJoin            AS CHAR   NO-UNDO.     
//    DEF VAR cDataSourceType       AS CHAR   NO-UNDO.  
    DEF VAR cBufferDef            AS CHAR   NO-UNDO.
    DEF VAR cBufferFields         AS CHAR   NO-UNDO.
    DEF VAR cFieldDef             AS CHAR   NO-UNDO.
    DEF VAR iy                    AS INT    NO-UNDO.
    DEF VAR iFieldSeq             AS INT    NO-UNDO.
    DEF VAR cNotExist             AS CHAR   NO-UNDO.
    
    DO ix = 2 TO NUM-ENTRIES(icBuffersAndFields,";"):
      IF NUM-ENTRIES(ENTRY(ix,icBuffersAndFields,";"),"|") > 3 AND ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|") NE "" THEN
        ASSIGN cCalcFlds   = cCalcFlds + (IF cCalcFlds NE "" THEN "," ELSE "") + TRIM(ENTRY(1,ENTRY(ix,icBuffersAndFields,";"),"|"),"+")
               cCalcParams = cCalcParams + (IF cCalcParams NE "" THEN "," ELSE "") + ENTRY(4,ENTRY(ix,icBuffersAndFields,";"),"|")
               .
    END.

    EMPTY TEMP-TABLE ttFieldBufferRef.

    DO ix = 1 TO NUM-ENTRIES(icBuffersAndFields):
      cBufferDef = ENTRY(1,ENTRY(ix,icBuffersAndFields),";").
      IF cBufferDef BEGINS "NOT EXIST " THEN 
        ASSIGN cBufferDef = TRIM(SUBSTR(cBufferDef,11))
               cNotExist = cNotExist + (IF cNotExist NE "" THEN "," ELSE "") 
                         + ENTRY(NUM-ENTRIES(cBufferDef,"."),cBufferDef,".") 
               .
      cBufferFields = ENTRY(ix,icBuffersAndFields).
      IF NUM-ENTRIES(cBufferDef,".") > 1 THEN cBufferDef = ENTRY(2,cBufferDef,".").
      cBufferList = cBufferList + (IF cBufferList NE "" THEN "," ELSE "") + cBufferDef.
      DO iy = 2 TO NUM-ENTRIES(cBufferFields,";"):
        cFieldDef = ENTRY(1,ENTRY(iy,cBufferFields,";"),"@").
        FIND FIRST ttFieldBufferRef
             WHERE ttFieldBufferRef.FieldName = LEFT-TRIM(ENTRY(1,cFieldDef,"|"),"!")
             NO-ERROR. 
        IF NOT AVAIL ttFieldBufferRef THEN DO:     
          CREATE ttFieldBufferRef.
          ASSIGN ttFieldBufferRef.BufferName = cBufferDef
                 ttFieldBufferRef.FieldName  = LEFT-TRIM(ENTRY(1,cFieldDef,"|"),"!")
                 .
        END.   
        ELSE DO:
          CREATE ttFieldBufferRef.
          ASSIGN ttFieldBufferRef.BufferName = cBufferDef
                 ttFieldBufferRef.FieldName  = LEFT-TRIM(ENTRY(1,cFieldDef,"|"),"!") + STRING(ix)
                 .
        END.         
      END.  
    END.
    
/*    def var hh as handle no-undo.       */
/*    hh = buffer ttFieldBufferRef:handle.*/
/*    run toexcelviafile.p (hh,-2).       */
    
/*    IF JBoxServerAPI:Instance:CallServerProc("jbserv_get_datasource_type.p",icSQLdb) THEN DO:*/
/*      cDataSourceType = JBoxServerAPI:Instance:getCallReturnParam().                         */
      hTT = JBoxSqlSchemaHelper:Instance:getTtDef (icSQLdb,icBuffersAndFields).
      DYNAMIC-FUNCTION("setAttribute",BrowseRect,"sqlDbname",icSQLdb).

      THIS-OBJECT:InitializeQuery(icBuffersAndFields,icQuery,icInitialSort,ibRecordCount,hTT).
  
      BROWSE-OBJECT:setJBoxAttribute("sqlDbname",icSQLdb).
      BROWSE-OBJECT:setJBoxAttribute("numbuffers",STRING(NUM-ENTRIES(icBuffersAndFields))).
  
      hBuffer = BROWSE-OBJECT:BUFFER-HANDLE.

      cBuffersAndFields = hBuffer:NAME.
      cViewBuffersAndFields = hBuffer:NAME.
      DO ix = 1 TO hBuffer:NUM-FIELDS:
        IF NOT hBuffer:BUFFER-FIELD(ix):NAME BEGINS "RowIdent" AND NOT hBuffer:BUFFER-FIELD(ix):NAME BEGINS "RowCount" THEN DO:
          cField = hBuffer:BUFFER-FIELD(ix):NAME + "|" 
                 + hBuffer:BUFFER-FIELD(ix):DATA-TYPE + "|"
                 + REPLACE(DYNAMIC-FUNCTION("getBrowseColumnFormat",BROWSE-OBJECT:BROWSE-HANDLE,hBuffer:BUFFER-FIELD(ix):NAME),",","<")
                 + "|"
                 + (IF CAN-DO(cCalcFlds,hBuffer:BUFFER-FIELD (ix):NAME) THEN ENTRY(LOOKUP(hBuffer:BUFFER-FIELD (ix):NAME,cCalcFlds),cCalcParams) ELSE "")  
                 + "|"
                 + DYNAMIC-FUNCTION("getBrowseColumnLabel",BROWSE-OBJECT:BROWSE-HANDLE,hBuffer:BUFFER-FIELD(ix):NAME)
                 .
          FIND FIRST ttFieldBufferRef
               WHERE ttFieldBufferRef.FieldName = hBuffer:BUFFER-FIELD(ix):NAME
               NO-ERROR.         
          IF AVAIL ttFieldBufferRef THEN
            cField = cField + "|"
                   + (IF CAN-DO(cNotExist,ttFieldBufferRef.BufferName) THEN "NOT EXIST " ELSE "") 
                   + ttFieldBufferRef.BufferName.
          ELSE IF CAN-DO(cCalcFlds,hBuffer:BUFFER-FIELD (ix):NAME) THEN DO:
            FIND FIRST ttFieldBufferRef
                 WHERE ttFieldBufferRef.FieldName = "+" + hBuffer:BUFFER-FIELD (ix):NAME
                 NO-ERROR.         
            IF AVAIL ttFieldBufferRef THEN
              cField = cField + "|" + ttFieldBufferRef.BufferName.
          END.
          IF AVAIL ttFieldBufferRef THEN
            BROWSE-OBJECT:setJBoxAttribute("fieldbuffer" + hBuffer:BUFFER-FIELD(ix):NAME,ttFieldBufferRef.BufferName).
                         
          cBuffersAndFields = cBuffersAndFields + ";" + cField.
               
          IF NOT cField BEGINS "jbCount" AND NOT cField BEGINS "jbAverage" THEN 
            cViewBuffersAndFields = cViewBuffersAndFields + ";" + cField.
        END.                    
      END.   
      cQueryJoin = DYNAMIC-FUNCTION("getAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"queryjoin").    
      DYNAMIC-FUNCTION("setAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"buffersAndFields",cBuffersAndFields). 
      DYNAMIC-FUNCTION("setAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"queryjoin",CHR(1) + (IF cQueryJoin NE "" THEN cQueryJoin ELSE icQuery)).
      DYNAMIC-FUNCTION("setAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"viewbuffersandfields",cViewBuffersAndFields).
      DYNAMIC-FUNCTION("setAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"tempTableHandle",STRING(hBuffer:TABLE-HANDLE)).
 //     DYNAMIC-FUNCTION("setAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"basetablefields","").
      DYNAMIC-FUNCTION("setAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"basetablefilterfields","").
      DYNAMIC-FUNCTION("setAttribute",BROWSE-OBJECT:BROWSE-HANDLE,"bufferlist",cBufferList).
  
      BROWSE-OBJECT:useLocalData = NO.
      RETURN YES.  
/*    END.                                       */
/*    ELSE DO:                                   */
/*      JBoxServerAPI:Instance:viewCallMessage().*/
/*      RETURN NO.                               */
/*    END.                                       */
  END METHOD.

  METHOD PUBLIC LOGICAL InitializeQuery (icBuffersAndFields AS CHAR
                                        ,icQuery            AS CHAR
                                        ,icInitialSort      AS CHAR
                                        ,ibRecordCount      AS LOG):
    DEF VAR hTT AS HANDLE NO-UNDO.                                            
    THIS-OBJECT:InitializeQuery(icBuffersAndFields,icQuery,icInitialSort,ibRecordCount,hTT).
  END METHOD.

  METHOD PUBLIC LOGICAL InitializeQuery (icBuffersAndFields AS CHAR
                                        ,icQuery            AS CHAR
                                        ,ibRecordCount      AS LOG):
    DEF VAR hTT AS HANDLE NO-UNDO.                                            
    THIS-OBJECT:InitializeQuery(icBuffersAndFields,icQuery,"",ibRecordCount,hTT).
  END METHOD.
  
  METHOD PUBLIC LOGICAL InitializeQuery (icBuffersAndFields AS CHAR
                                        ,icQuery            AS CHAR
                                        ,icInitialSort      AS CHAR):
    DEF VAR hTT AS HANDLE NO-UNDO.                                            
    THIS-OBJECT:InitializeQuery(icBuffersAndFields,icQuery,icInitialSort,NO,hTT).
  END METHOD.

  METHOD PUBLIC LOGICAL InitializeQuery (icBuffersAndFields AS CHAR
                                        ,icQuery            AS CHAR):
    DEF VAR hTT AS HANDLE NO-UNDO.                                            
    THIS-OBJECT:InitializeQuery(icBuffersAndFields,icQuery,"",NO,hTT).
  END METHOD.
  
  METHOD PUBLIC LOGICAL InitializeQuery (icBuffersAndFields AS CHAR
                                        ,icInitialSort      AS CHAR
                                        ,ihTempTable        AS HANDLE):
    THIS-OBJECT:InitializeQuery(icBuffersAndFields,"",icInitialSort,YES,ihTempTable).
  END METHOD.

  METHOD PUBLIC LOGICAL InitializeQuery (ihTempTable        AS HANDLE):
    THIS-OBJECT:InitializeQuery("","","",YES,ihTempTable).
  END METHOD.

   
  METHOD PUBLIC LOGICAL StartQuery (INPUT icFilterFields    AS CHAR,
                                    INPUT icFilterOperators AS CHAR,
                                    INPUT icFilterValues    AS CHAR,
                                    INPUT icInitSort        AS CHAR,
                                    INPUT icDistinctCols    AS CHAR,
                                    INPUT icAccumFields     AS CHAR):
      
    DYNAMIC-FUNCTION("StartQueryCls" IN DataBrwProc
                     ,icFilterFields   /* Filter fields (comma sep) */
                     ,icFilterOperators   /* Filter operators (comma sep) */
                     ,icFilterValues   /* Filter values (pipe sep) */
                     ,icInitSort   /* Initial sort column(s) (comma sep) */
                     ,icDistinctCols   /* Distinct columns (comma sep) */
                     ,icAccumFields   /* Columns to accumulate (comma sep) */
                     ).
  END METHOD.
      
  METHOD PUBLIC VOID MoveToTop():
    RUN MoveToTop IN DataBrwProc.
  END.    
      
  // Methods for handling user settings in view-definition file used with JBoxViewDsDef.w

  // Called from JBoxViewDsDef to initiate user query menu (THIS-OBJECT:ViewDsId must be set):
  METHOD PUBLIC CHARACTER setViewDsUserQueryMenu():
    DYNAMIC-FUNCTION("setMyQueriesMenu" IN DataBrwProc).
  END METHOD.      
  
  // Called (callback) from JBoxDataBrw, setMyQueriesMenu. Returns Id|Label|Id|..    
  METHOD PUBLIC CHARACTER getViewDsUserQueryMenu():
    DEF VAR cIdLabel AS CHAR NO-UNDO.
    
    FOR EACH ttJBoxUserSetting
        WHERE ttJBoxUserSetting.ViewDsId = THIS-OBJECT:ViewDsId
          AND ttJBoxUserSetting.cObjectName = "userquery"
          AND ttJBoxUserSetting.cSettingName NE "":
      cIdLabel = cIdLabel + (IF cIdLabel NE "" THEN "|" ELSE "") + ttJBoxUserSetting.cSettingName + "|" + ttJBoxUserSetting.cSetting.
    END.  
    RETURN cIdLabel.
    
  END METHOD.
  
  METHOD PUBLIC CHARACTER getNextViewDsUserQueryId():
    DEF VAR cUserQueryId AS CHAR NO-UNDO.
    FOR EACH ttJBoxUserSetting
        WHERE ttJBoxUserSetting.ViewDsId = THIS-OBJECT:ViewDsId
          AND ttJBoxUserSetting.cObjectName = "userquery"
        BY INT(SUBSTR(ttJBoxUserSetting.cSettingName,6)):
      cUserQueryId = ttJBoxUserSetting.cSettingName.     
    END.
    IF cUserQueryId NE "" THEN cUserQueryId = "query" + STRING(INT(SUBSTR(cUserQueryId,6)) + 1).
    ELSE cUserQueryId = "query1".
    
    RETURN cUserQueryId.
  END.      
  
  METHOD PUBLIC CHARACTER getViewDsUserSetting(INPUT icObjectName  AS CHAR
                                              ,INPUT icSettingName AS CHAR):
    
    DEF VAR ix AS INT NO-UNDO.
    DEF VAR cNameList AS CHAR NO-UNDO.
    DEF VAR cValueList AS CHAR NO-UNDO.
    
    IF NUM-ENTRIES(icSettingName) > 1 THEN DO:
      DO ix = 1 TO NUM-ENTRIES(icSettingName):
        FIND FIRST ttJBoxUserSetting
             WHERE ttJBoxUserSetting.ViewDsId = THIS-OBJECT:ViewDsId 
               AND ttJBoxUserSetting.cSettingName = ENTRY(ix,icSettingName)
               AND ttJBoxUserSetting.cObjectName  = icObjectName  
             NO-ERROR.
        IF AVAIL ttJBoxUserSetting THEN
          ASSIGN cNameList = cNameList + ttJBoxUserSetting.cSettingName + ","
                 cValueList = cValueList + ttJBoxUserSetting.cSetting + CHR(1)
                 .    
      END.           
    END.  
    ELSE 
      FOR EACH ttJBoxUserSetting
          WHERE ttJBoxUserSetting.ViewDsId = THIS-OBJECT:ViewDsId
            AND ttJBoxUserSetting.cObjectName  = icObjectName
            AND (IF icSettingName = "*" THEN TRUE 
                 ELSE ttJBoxUserSetting.cSettingName = icSettingName)
          :  
        ASSIGN cNameList = cNameList + ttJBoxUserSetting.cSettingName + ","
               cValueList = cValueList + ttJBoxUserSetting.cSetting + CHR(1)
               .    
      END.          
     
     RETURN SUBSTR(cNameList,1,LENGTH(cNameList) - 1) + "|" + SUBSTR(cValueList,1,LENGTH(cValueList) - 1).  
  END METHOD.                                                
  
  METHOD PUBLIC LOGICAL setViewDsUserSetting(INPUT icObjectName  AS CHAR  
                                            ,INPUT icSettingName AS CHAR
                                            ,INPUT icSetting     AS CHAR):
    DEF VAR ix AS INT NO-UNDO.
    DO ix = 1 TO NUM-ENTRIES(icSettingName):
      FIND FIRST ttJBoxUserSetting
           WHERE ttJBoxUserSetting.ViewDsId = THIS-OBJECT:ViewDsId 
             AND ttJBoxUserSetting.cSettingName = ENTRY(ix,icSettingName)
             AND ttJBoxUserSetting.cObjectName  = icObjectName  
           NO-ERROR.
     IF AVAIL ttJBoxUserSetting AND icSetting = "delete_setting" THEN DELETE ttJBoxUserSetting.
     ELSE IF icSetting NE "delete_setting" AND ENTRY(ix,icSetting,CHR(1)) NE "" THEN DO:
       IF NOT AVAIL ttJBoxUserSetting THEN CREATE ttJBoxUserSetting.
       ASSIGN ttJBoxUserSetting.ViewDsId     = THIS-OBJECT:ViewDsId
              ttJBoxUserSetting.cObjectName  = icObjectName
              ttJBoxUserSetting.cSettingName = ENTRY(ix,icSettingName)
              ttJBoxUserSetting.cSetting     = ENTRY(ix,icSetting,CHR(1))
              .
     END.
   END.       
   hViewDsUserSetting:EMPTY-TEMP-TABLE().
   hViewDsUserSetting:COPY-TEMP-TABLE (BUFFER ttJBoxUserSetting:HANDLE).                                              
  
   PUBLISH "replaceViewDs" FROM DataBrwProc.
  
  END METHOD.                                            

  METHOD PUBLIC VOID startViewDsUserQuery(INPUT icUserQueryId AS CHAR):
    THIS-OBJECT:ViewDsRunQueryId = icUserQueryId.
    RUN StartUserQuery IN DataBrwProc.
    THIS-OBJECT:ViewDsRunQueryId = "".
  END.                                        
                                              
      
  DESTRUCTOR PUBLIC JBoxDynDataBrowse ( ):
  END DESTRUCTOR.
END CLASS.
