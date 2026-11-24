 /*------------------------------------------------------------------------
    File        : JBoxContainer
    Purpose     : Help manage the content, resize settings and such
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Fri Feb 13 12:43:22 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
/*USING oo.* FROM PROPATH.*/

CLASS JBoxContainer:
  DEF TEMP-TABLE ttChildWin 
      FIELD hChildWin AS HANDLE
      FIELD hDataBrw  AS HANDLE.

  DEF TEMP-TABLE ttSubContainer 
      FIELD oSubContainer AS Progress.Lang.Object
      FIELD hContainer AS HANDLE 
      FIELD cProcName  AS CHAR 
      .
      
  DEF VAR bNoMoveToTop        AS LOG    NO-UNDO.
  DEF VAR bNewDataBrw         AS LOG    NO-UNDO.
  DEF VAR bNoOpenDataBrwQuery AS LOG    NO-UNDO.

  
  DEF PUBLIC PROPERTY ChildDataBrowseHandle  AS HANDLE NO-UNDO GET. PROTECTED SET.
  DEF PUBLIC PROPERTY ChildDataBrowseObject  AS JBoxDynDataBrowse NO-UNDO 
      GET: 
        IF VALID-HANDLE(ChildDataBrowseHandle) THEN
          RETURN DYNAMIC-FUNCTION("getDynDataBrowseObject" IN ChildDataBrowseHandle).
        ELSE
          RETURN ?.
      END GET. PROTECTED SET.
 
  DEF PUBLIC PROPERTY CONTAINER-HANDLE AS HANDLE GET. PROTECTED SET.
  DEF PUBLIC PROPERTY CONTAINER-HELPER-HANDLE AS HANDLE GET. PROTECTED SET.

  DEF PUBLIC PROPERTY WrapperFormObject  AS JBoxWrapperForm NO-UNDO
      GET:
        DEF VAR oForm AS PROGRESS.Lang.Object NO-UNDO.
        DEF VAR oWrapper AS JBoxWrapperForm NO-UNDO.
        oForm = DYNAMIC-FUNCTION("getWindowForm" IN CONTAINER-HANDLE).
        oWrapper = CAST(oForm,"JBoxWrapperForm") NO-ERROR.
        RETURN oWrapper.
      END GET.   
      PROTECTED SET.

  DEF PUBLIC PROPERTY CURRENT-WINDOW AS HANDLE GET:
      IF CURRENT-WINDOW NE CONTAINER-HANDLE:CURRENT-WINDOW THEN CURRENT-WINDOW = CONTAINER-HANDLE:CURRENT-WINDOW. 
      RETURN CURRENT-WINDOW.
      END GET.
      PROTECTED SET.
  DEF PUBLIC PROPERTY myCURRENT-WINDOW AS HANDLE GET. PROTECTED SET.

  DEF PUBLIC PROPERTY FRAME-HANDLE AS HANDLE GET. 
      SET(ihFrame AS HANDLE): 
        FRAME-HANDLE = ihFrame. 
      END SET.
      
  DEF PUBLIC PROPERTY PARENT-CONTAINER-OBJECT AS JBoxContainer GET. SET.
  DEF PUBLIC PROPERTY BROWSE-OBJECT AS JBoxBrowse GET. SET.    
  DEF PUBLIC PROPERTY QUERY-OBJECT AS JBoxQuery GET. SET.    
  DEF PUBLIC PROPERTY TOOLBAR-OBJECT AS JBoxToolbar GET. SET.    
  DEF PUBLIC PROPERTY FIELDMAP-OBJECT AS JBoxFieldMap GET. SET.    
  DEF PUBLIC PROPERTY TABFOLDER-OBJECT AS JBoxMsTabs GET. SET.   
  DEF PUBLIC PROPERTY TREEVIEW-OBJECT AS uc.JBoxMsTreeView GET. SET. 
  DEF PUBLIC PROPERTY BROWSE-HANDLE AS HANDLE 
    GET:
      IF VALID-HANDLE(BROWSE-HANDLE) THEN RETURN BROWSE-HANDLE.
      ELSE IF VALID-OBJECT(BROWSE-OBJECT) THEN RETURN BROWSE-OBJECT:BROWSE-HANDLE.
      ELSE RETURN ?. 
    END GET. SET.    
  DEF PUBLIC PROPERTY QUERY-HANDLE AS HANDLE
    GET:
      IF VALID-HANDLE(QUERY-HANDLE) THEN RETURN BROWSE-HANDLE.
      ELSE IF VALID-OBJECT(QUERY-OBJECT) THEN RETURN QUERY-OBJECT:QUERY-HANDLE.
      ELSE RETURN ?. 
    END GET. SET.    
  DEF PUBLIC PROPERTY BUFFER-HANDLE AS HANDLE
    GET:
      IF VALID-HANDLE(BUFFER-HANDLE) THEN RETURN BUFFER-HANDLE.
      ELSE IF VALID-OBJECT(BROWSE-OBJECT) THEN RETURN BROWSE-OBJECT:BUFFER-HANDLE.
      ELSE IF VALID-OBJECT(QUERY-OBJECT) THEN RETURN QUERY-OBJECT:BUFFER-HANDLE.
      ELSE RETURN ?. 
    END GET. SET.    
  DEF PUBLIC PROPERTY SplitBarX AS HANDLE GET. PROTECTED SET.    
  DEF PUBLIC PROPERTY SplitBarY AS HANDLE GET. PROTECTED SET.
  DEF PUBLIC PROPERTY WrapperForm AS JBoxWrapperForm GET. SET.
  DEF PUBLIC PROPERTY statusBar AS JBoxStatusbar GET. PROTECTED SET.
  DEF PUBLIC PROPERTY X AS INT
      GET():
        IF VALID-OBJECT(WrapperForm) THEN RETURN WrapperForm:Location:X.
        ELSE DO:
          IF VALID-HANDLE(myCURRENT-WINDOW) THEN
            RETURN myCURRENT-WINDOW:X.
          ELSE DO:
            MESSAGE "Error when positioning window in X-direction. Window may not get initialized properly"
            VIEW-AS ALERT-BOX.
            RETURN 0.
          END.    
        END.  
      END GET.
      SET(iiX AS INT):
        DEF VAR oLoc AS System.Drawing.Point NO-UNDO.
        DEF VAR bHideAgain AS LOG NO-UNDO.  
        IF VALID-OBJECT(WrapperForm) THEN DO:
          IF NOT WrapperForm:Visible THEN
            ASSIGN WrapperForm:Visible = YES
                   bHideAgain = YES.
          oLoc = NEW System.Drawing.Point(iiX,THIS-OBJECT:Y).
          WrapperForm:Location = oLoc.
          IF bHideAgain THEN WrapperForm:Visible = NO.
        END.
        ELSE IF VALID-HANDLE(myCURRENT-WINDOW) THEN myCURRENT-WINDOW:X = iiX.  
      END SET.  
      
  DEF PUBLIC PROPERTY Y AS INT
      GET():
        IF VALID-OBJECT(WrapperForm) THEN RETURN WrapperForm:Location:Y.
        ELSE DO:
          IF VALID-HANDLE(myCURRENT-WINDOW) THEN
            RETURN myCURRENT-WINDOW:Y.
          ELSE DO:
            MESSAGE "Error when positioning window in Y-direction. Window may not get initialized properly"
            VIEW-AS ALERT-BOX.
            RETURN 0.
          END.    
        END.  
      END GET.
      SET(iiY AS INT):
        DEF VAR oLoc AS System.Drawing.Point NO-UNDO.
        DEF VAR bHideAgain AS LOG NO-UNDO.  
        IF VALID-OBJECT(WrapperForm) THEN DO:
          IF NOT WrapperForm:Visible THEN
            ASSIGN WrapperForm:Visible = YES
                   bHideAgain = YES.
          oLoc = NEW System.Drawing.Point(THIS-OBJECT:X,iiY).
          WrapperForm:Location = oLoc.
          IF bHideAgain THEN WrapperForm:Visible = NO.
        END.
        ELSE IF VALID-HANDLE(myCURRENT-WINDOW) THEN myCURRENT-WINDOW:Y = iiY.  
      END SET.  

  CONSTRUCTOR PUBLIC JBoxContainer ():
      SUPER ().

    IF PROVERSION < "11" THEN CONTAINER-HANDLE = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE CONTAINER-HANDLE = SOURCE-PROCEDURE.

    DYNAMIC-FUNCTION("setObjectSourceProc",CONTAINER-HANDLE).    
    DYNAMIC-FUNCTION("NewObject",CONTAINER-HANDLE:CURRENT-WINDOW,CONTAINER-HANDLE,"Container").
    CURRENT-WINDOW = CONTAINER-HANDLE:CURRENT-WINDOW NO-ERROR.
    myCURRENT-WINDOW = CONTAINER-HANDLE:CURRENT-WINDOW NO-ERROR.
    IF VALID-HANDLE(CURRENT-WINDOW) THEN
      FRAME-HANDLE = CURRENT-WINDOW:FIRST-CHILD.
      
    RUN JBoxContainerHelper.p PERSIST SET CONTAINER-HELPER-HANDLE (THIS-OBJECT).  
      
    PUBLISH "setWindowContainerObject" FROM CONTAINER-HANDLE (CONTAINER-HANDLE,THIS-OBJECT).

  END CONSTRUCTOR.
  
   METHOD PUBLIC LOGICAL bringContainerToFront():
    IF VALID-HANDLE(CONTAINER-HANDLE) THEN DO:
      PUBLISH "ViewTabProcHandle" FROM CONTAINER-HANDLE (CONTAINER-HANDLE).
      THIS-OBJECT:unFreezeContainer().
      RETURN YES.
    END.
    ELSE IF VALID-HANDLE(CURRENT-WINDOW) THEN CURRENT-WINDOW:MOVE-TO-TOP().
    ELSE RETURN NO.  
  END METHOD.  
  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID DeleteUserControlByPlaceholder( INPUT ihPlaceholder AS HANDLE ):
    
    DYNAMIC-FUNCTION("DeleteUserControlByPlaceholder" IN CONTAINER-HANDLE,ihPlaceholder).

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC JBoxContainer getChildContainer( INPUT ihChildHandle AS HANDLE ):
    
    FIND ttSubContainer 
         WHERE ttSubContainer.hContainer = ihChildHandle NO-ERROR.
    IF AVAIL ttSubContainer THEN RETURN CAST(ttSubContainer.oSubContainer,"JBoxContainer").
    ELSE RETURN ?.     

  END METHOD.

  METHOD PUBLIC JBoxContainer getChildContainer( INPUT icProcName AS CHAR ):
    
    FOR EACH ttSubContainer 
        WHERE ttSubContainer.cProcName = icProcName:
      IF VALID-HANDLE(ttSubContainer.hContainer) THEN RETURN CAST(ttSubContainer.oSubContainer,"JBoxContainer").
      ELSE DELETE ttSubContainer.
    END.  
    RETURN ?.     

  END METHOD.

  METHOD PUBLIC VOID MoveToTop():
    RUN MoveToTop IN CONTAINER-HANDLE.
    IF VALID-OBJECT(WrapperForm) THEN WrapperForm:BringToFront().
  END.

  METHOD PUBLIC LOGICAL freezeContainer():
    IF VALID-OBJECT(PARENT-CONTAINER-OBJECT) THEN PARENT-CONTAINER-OBJECT:freezeContainer().
    IF VALID-HANDLE(CURRENT-WINDOW) THEN DO:
      DYNAMIC-FUNCTION("DoLockWindow",CURRENT-WINDOW).
      DYNAMIC-FUNCTION("setAttribute",SESSION,"userKeepsWindowLocked","yes").
      RETURN YES.
    END.
    ELSE RETURN NO.  
  END METHOD.  

  METHOD PUBLIC LOGICAL unFreezeContainer():
    DYNAMIC-FUNCTION("setAttribute",SESSION,"userKeepsWindowLocked","").
    IF VALID-HANDLE(myCURRENT-WINDOW) THEN 
      DYNAMIC-FUNCTION("DoRedrawWindow",myCURRENT-WINDOW).
    ELSE  
      DYNAMIC-FUNCTION("DoLockWindow",?).
    RETURN YES.
  END METHOD.  
  
  METHOD PUBLIC JBoxStatusbar addStatusBar():
    THIS-OBJECT:statusBar = NEW JBoxStatusbar(CONTAINER-HANDLE).
  END METHOD.

  METHOD PUBLIC JBoxStatusbar addStatusBar(icPixelList AS CHAR):
    THIS-OBJECT:statusBar = NEW JBoxStatusbar(icPixelList,CONTAINER-HANDLE).
  END METHOD.

  METHOD PUBLIC HANDLE StartChildWindow (icProcName     AS CHAR
                                        ,icWinTitle     AS CHAR
                                        ,ibNew          AS LOG).
    DEF VAR ohWinHandle     AS HANDLE NO-UNDO.
    DEF VAR oChildContainer AS JBoxContainer NO-UNDO.
    DEF VAR oObj            AS Progress.Lang.Object NO-UNDO.
  
    IF NOT ibNew THEN
      FOR EACH ttChildWin:
        IF VALID-HANDLE(ttChildWin.hChildWin) AND hChildWin:FILE-NAME = icProcName THEN RETURN ttChildWin.hChildWin. 
      END.

    IF bNewDataBrw THEN DO:        
      RUN VALUE(icProcName) PERSIST SET ohWinHandle (ChildDataBrowseHandle).
      DYNAMIC-FUNCTION("setParent" IN ChildDataBrowseHandle,ohWinHandle).
      SUBSCRIBE PROCEDURE ohWinHandle TO "InvalidateHandle" IN ChildDataBrowseHandle.
    END.  
    ELSE 
      RUN VALUE(icProcName) PERSIST SET ohWinHandle.
    
    IF CAN-DO(ohWinHandle:INTERNAL-ENTRIES,"InitializeObject") THEN DO:
      IF CAN-DO(CONTAINER-HANDLE:INTERNAL-ENTRIES,"InitializeChild") THEN RUN InitializeChild IN CONTAINER-HANDLE (ohWinHandle).
      IF CAN-DO(ohWinHandle:INTERNAL-ENTRIES,"setParent") THEN DYNAMIC-FUNCTION("setParent" IN ohWinHandle,CONTAINER-HANDLE).
      IF icProcName = "JBoxDataBrw.w" THEN DO:
        IF NOT CAN-DO(CONTAINER-HANDLE:INTERNAL-ENTRIES,"myDataBrowseObject") THEN
          MESSAGE "Warning: Caller must have the myDataBrowseObject callback procedure for initialization of the query"
          VIEW-AS ALERT-BOX.
        DYNAMIC-FUNCTION("setAttribute",ohWinHandle,"childwindow","yes").  
      END.   
      ELSE 
        RUN InitializeObject IN ohWinHandle.
      
      oObj = SESSION:LAST-OBJECT.
      DO WHILE VALID-OBJECT(oObj):
        IF TYPE-OF(oObj,JBoxContainer) THEN DO:
          oChildContainer = CAST(oObj,JBoxContainer).
          IF oChildContainer:CONTAINER-HANDLE = ohWinHandle THEN DO:
            oChildContainer:PARENT-CONTAINER-OBJECT = THIS-OBJECT.
            THIS-OBJECT:AddSubContainer(oChildContainer).
            SUBSCRIBE PROCEDURE oChildContainer:CONTAINER-HELPER-HANDLE TO "InvalidateHandle" IN THIS-OBJECT:CONTAINER-HANDLE.
            LEAVE.
          END.  
        END.  
        oObj = oObj:PREV-SIBLING.
      END.
    END.  
    IF CAN-DO(ohWinHandle:INTERNAL-ENTRIES,"setWinTitle") THEN
      DYNAMIC-FUNCTIOn("setWinTitle" IN ohWinHandle,icWinTitle).
    ELSE   
      ohWinHandle:CURRENT-WINDOW:TITLE = icWinTitle.
    IF NOT bNoMoveToTop THEN DO:
      IF CAN-DO(ohWinHandle:INTERNAL-ENTRIES,"MoveToTop") THEN RUN MoveToTop IN ohWinHandle.
      ELSE IF bNewDataBrw THEN 
        RUN MoveToTop IN ChildDataBrowseHandle.
    END.
    
    bNoMoveToTop = NO.
    
    FIND FIRST ttChildWin WHERE ttChildWin.hChildWin = ohWinHandle
         NO-ERROR.
    IF NOT AVAIL ttChildWin THEN DO:
      CREATE ttChildWin.
      ttChildWin.hChildWin = ohWinHandle.
      IF bNewDataBrw THEN
        ttChildWin.hDataBrw = ChildDataBrowseHandle.
    END.       
    RETURN ohWinHandle.
    
  END METHOD.

  METHOD PUBLIC HANDLE StartChildWindowNoView (icProcName     AS CHAR
                                              ,icWinTitle     AS CHAR
                                              ,ibNew          AS LOG).
    bNoMoveToTop = YES.
    RETURN THIS-OBJECT:StartChildWindow(icProcName, icWinTitle, ibNew).                                          
  END METHOD.                                             

  METHOD PUBLIC HANDLE StartChildDataBrowse (icProcName     AS CHAR
                                            ,icWinTitle    AS CHAR
                                            ,ibNew         AS LOG).

    IF NOT ibNew THEN
      FOR EACH ttChildWin:
        IF VALID-HANDLE(ttChildWin.hChildWin) AND hChildWin:FILE-NAME = icProcName THEN DO:
          RUN MoveToTop IN ttChildWin.hDataBrw.
          RETURN ttChildWin.hChildWin.
        END.   
      END.
    
    RUN JBoxDataBrw.w PERSISTE SET ChildDataBrowseHandle.
    ChildDataBrowseHandle:CURRENT-WINDOW:TITLE = icWinTitle.
    
    bNewDataBrw = YES.

    RETURN THIS-OBJECT:StartChildWindow(icProcName, icWinTitle, ibNew).                                          
  END METHOD.                                             

/* Må pønske ut en lur måte for å stanse første openquery
  METHOD PUBLIC HANDLE StartChildDataBrwNoOpenQuery (icProcName     AS CHAR
                                                    ,icWinTitle    AS CHAR
                                                    ,ibNew         AS LOG).
    bNoOpenDataBrwQuery = YES.                                                    
    RETURN THIS-OBJECT:StartChildDataBrw(icProcName, icWinTitle, ibNew).                                          
  END.                                        
*/

  METHOD PUBLIC JBoxDynDataBrowse getChildDataBrwObject (INPUT ihProcHandle AS HANDLE):
    FOR EACH ttChildWin:
      IF VALID-HANDLE(ttChildWin.hChildWin) AND ttChildWin.hChildWin = ihProcHandle THEN DO:
        IF VALID-HANDLE(ttChildWin.hDataBrw) THEN
          RETURN DYNAMIC-FUNCTION("getDynDataBrowseObject" IN ttChildWin.hDataBrw).
      END.   
    END.
  END.  

  METHOD PUBLIC JBoxDynDataBrowse getChildDataBrwObject (INPUT icProcName AS CHAR):
    FOR EACH ttChildWin:
      IF VALID-HANDLE(ttChildWin.hChildWin) AND ttChildWin.hChildWin:FILE-NAME = icProcName THEN DO:
        IF VALID-HANDLE(ttChildWin.hDataBrw) THEN
          RETURN DYNAMIC-FUNCTION("getDynDataBrowseObject" IN ttChildWin.hDataBrw).
      END.   
    END.
  END.  
  
  METHOD CHARACTER getFrameFields (INPUT ihFrame      AS HANDLE
                                  ,INPUT icNameFilter AS CHAR
                                  ,INPUT icTypeFilter AS CHAR
                                  ,INPUT icScreenValueFilter AS CHAR
                                  ,INPUT icTrimPrefix AS CHAR).
    RETURN DYNAMIC-FUNCTION("getFrameFields",ihFrame,icNameFilter,icTypeFilter,icScreenValueFilter,icTrimPrefix).
  END METHOD.                                

  METHOD CHARACTER getFunction (INPUT icFunctionName AS CHAR).
    IF VALID-HANDLE(CONTAINER-HANDLE) AND CAN-DO(CONTAINER-HANDLE:INTERNAL-ENTRIES,icFunctionName) THEN
      RETURN STRING(DYNAMIC-FUNCTION(icFunctionName IN CONTAINER-HANDLE)).
    ELSE IF NOT VALID-HANDLE(CONTAINER-HANDLE) THEN
      MESSAGE "Container-handle not set"
      VIEW-AS ALERT-BOX.  
    ELSE
      MESSAGE "Function " icFunctionName "is missing in container"
      VIEW-AS ALERT-BOX.  
  END METHOD.                                

  METHOD PUBLIC HANDLE StartChildTab (icProcName     AS CHAR
                                     ,icTabTitle     AS CHAR
                                     ,ibNew          AS LOG
                                     ,ibKeepOpen     AS LOG).
    DEF VAR ohWinHandle    AS HANDLE NO-UNDO.
  
    PUBLISH "StartChildTab" FROM CONTAINER-HANDLE(icProcName,icTabTitle,CONTAINER-HANDLE,ibNew,ibKeepOpen,"",OUTPUT ohWinHandle).
    RETURN ohWinHandle.
    
  END METHOD.

  METHOD PUBLIC HANDLE StartTabDataBrowse (icProcName     AS CHAR
                                          ,icTabTitle     AS CHAR
                                          ,ibNew          AS LOG
                                          ,ibKeepOpen     AS LOG).
    DEF VAR ohWinHandle    AS HANDLE NO-UNDO.
  
    PUBLISH "StartTabDataBrowse" FROM CONTAINER-HANDLE(icProcName,icTabTitle,CONTAINER-HANDLE,ibNew,ibKeepOpen,OUTPUT ohWinHandle).
    
    RETURN ohWinHandle.
    
  END METHOD.
  
  METHOD PUBLIC HANDLE StartTabWindow (icProcName     AS CHAR
                                      ,icTabTitle     AS CHAR
                                      ,ibNew          AS LOG
                                      ,ibKeepOpen     AS LOG).
    DEF VAR ohWinHandle    AS HANDLE NO-UNDO.
  
    PUBLISH "StartTabWindow" FROM CONTAINER-HANDLE(icProcName,icTabTitle,CONTAINER-HANDLE,ibNew,ibKeepOpen,OUTPUT ohWinHandle).
    
    RETURN ohWinHandle.
    
  END METHOD.

  METHOD PUBLIC JBoxContainer AddSubContainer (ioSubContainer AS JBoxContainer).
  
    CREATE ttSubContainer.
    ASSIGN ttSubContainer.oSubContainer = CAST(ioSubContainer,"Progress.Lang.Object")
           ttSubContainer.hContainer = ioSubContainer:CONTAINER-HANDLE
           ttSubContainer.cProcName  = ttSubContainer.hContainer:FILE-NAME
           . 
    RETURN THIS-OBJECT.
    
  END METHOD.


  METHOD PUBLIC VOID initResize():
    DYNAMIC-FUNCTION("setOrgWinSize",CONTAINER-HANDLE:CURRENT-WINDOW,1600,1200,0,0).
  END METHOD.
                                 
  METHOD PUBLIC VOID initResize(iMinXmove AS INT
                               ,iMinYmove AS INT):
    DYNAMIC-FUNCTION("setOrgWinSize",CONTAINER-HANDLE:CURRENT-WINDOW,iMinXmove,iMinYmove,0,0).
  END METHOD.
                                 
  METHOD PUBLIC VOID initResize(iMinXmove AS INT
                               ,iMinYmove AS INT
                               ,iMinXsize AS INT
                               ,iMinYsize AS INT):
    DYNAMIC-FUNCTION("setOrgWinSize",CONTAINER-HANDLE:CURRENT-WINDOW,iMinXmove,iMinYmove,iMinXsize,iMinYsize).
  END METHOD.    

  METHOD PUBLIC VOID setNoResizeX(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setNoResizeY(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddResizeX(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddResizeY(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.

  METHOD PUBLIC VOID setNoResizeX(INPUT ihFrame AS HANDLE
                                 ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setNoResizeY(INPUT ihFrame AS HANDLE
                                 ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddResizeX(INPUT ihFrame AS HANDLE
                                  ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddResizeY(INPUT ihFrame AS HANDLE
                                  ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.

  METHOD PUBLIC VOID setNoMoveX(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setNoMoveY(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddMoveX(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddMoveY(INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,icWidgetNameList).
  END METHOD.
  
  METHOD PUBLIC VOID setNoMoveX(INPUT ihFrame AS HANDLE
                               ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setNoMoveY(INPUT ihFrame AS HANDLE
                               ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddMoveX(INPUT ihFrame AS HANDLE
                                ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setAddMoveY(INPUT ihFrame AS HANDLE
                                ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeSetting" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,icWidgetNameList).
  END METHOD.
  
  METHOD PUBLIC VOID setSplitBarX(INPUT ihSplitBarBtn AS HANDLE):
    SplitBarX = ihSplitBarBtn.
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihSplitBarBtn,"",0,0).
  END METHOD.
  METHOD PUBLIC VOID setFollowSplitBarX(INPUT ihSplitBarBtn AS HANDLE
                                       ,INPUT icWidgetList  AS CHAR):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihSplitBarBtn,icWidgetList,0,0).
  END METHOD.
  METHOD PUBLIC VOID setFollowSplitBarX(INPUT icWidgetList  AS CHAR):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),SplitBarX,icWidgetList,0,0).
  END METHOD.
  METHOD PUBLIC VOID setSplitBarXlimits(INPUT ihSplitBarBtn AS HANDLE
                                       ,INPUT iMinX         AS INT
                                       ,INPUT iMaxX         AS INT):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihSplitBarBtn,"",iMinX,iMaxX).
  END METHOD.
  METHOD PUBLIC VOID setSplitBarXlimits(INPUT iMinX         AS INT
                                       ,INPUT iMaxX         AS INT):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),SplitBarX,"",iMinX,iMaxX).
  END METHOD.

  METHOD PUBLIC VOID setSplitBarY(INPUT ihSplitBarBtn AS HANDLE):
    SplitBarY = ihSplitBarBtn.
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihSplitBarBtn,"",0,0).
  END METHOD.
  METHOD PUBLIC VOID setFollowSplitBarY(INPUT ihSplitBarBtn AS HANDLE
                                       ,INPUT icWidgetList  AS CHAR):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihSplitBarBtn,icWidgetList,0,0).
  END METHOD.
  METHOD PUBLIC VOID setFollowSplitBarY(INPUT icWidgetList  AS CHAR):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),SplitBarY,icWidgetList,0,0).
  END METHOD.
  METHOD PUBLIC VOID setSplitBarYlimits(INPUT ihSplitBarBtn AS HANDLE
                                       ,INPUT iMinY         AS INT
                                       ,INPUT iMaxY         AS INT):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihSplitBarBtn,"",iMinY,iMaxY).
  END METHOD.
  METHOD PUBLIC VOID setSplitBarYlimits(INPUT iMinY         AS INT
                                       ,INPUT iMaxY         AS INT):
    PUBLISH "DoSplitBar" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),SplitBarY,"",iMinY,iMaxY).
  END METHOD.

  METHOD PUBLIC VOID setResizeXgroup(INPUT ifPercent        AS DEC
                                    ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,ifPercent,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setResizeYgroup(INPUT ifPercent        AS DEC
                                    ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,ifPercent,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setMoveXgroup(INPUT ifPercent        AS DEC
                                  ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,ifPercent,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setMoveYgroup(INPUT ifPercent        AS DEC
                                    ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),FRAME-HANDLE,ifPercent,icWidgetNameList).
  END METHOD.

  METHOD PUBLIC VOID setResizeXgroup(INPUT ihFrame 	    AS HANDLE
                                    ,INPUT ifPercent        AS DEC
                                    ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,ifPercent,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setResizeYgroup(INPUT ihFrame 	    AS HANDLE
                                    ,INPUT ifPercent        AS DEC
                                    ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,ifPercent,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setMoveXgroup(INPUT ihFrame 	  AS HANDLE
                                  ,INPUT ifPercent        AS DEC
                                  ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,ifPercent,icWidgetNameList).
  END METHOD.
  METHOD PUBLIC VOID setMoveYgroup(INPUT ihFrame 	  AS HANDLE
                                  ,INPUT ifPercent        AS DEC
                                  ,INPUT icWidgetNameList AS CHAR):
    PUBLISH "DoResizeGroup" FROM CONTAINER-HANDLE (ENTRY(1,PROGRAM-NAME(1)," "),ihFrame,ifPercent,icWidgetNameList).
  END METHOD.

  METHOD PUBLIC VOID adjustFrameToWindowSize(INPUT ihFrame AS HANDLE):
    DYNAMIC-FUNCTION("setWidgetResize",ihFrame,ihFrame:WINDOW,"adjust","").
  END METHOD.  

  DESTRUCTOR PUBLIC JBoxContainer ( ):
    DELETE PROCEDURE CONTAINER-HELPER-HANDLE NO-ERROR.
    FOR EACH ttChildWin:
      IF VALID-HANDLE(ttChildWin.hChildWin) THEN 
        APPLY "close" TO ttChildWin.hChildWin.
    END.  
    FOR EACH ttSubContainer:
      DELETE OBJECT ttSubContainer.oSubContainer NO-ERROR.
    END.
  END DESTRUCTOR.
END CLASS.
  