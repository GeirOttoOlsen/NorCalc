 
 /*------------------------------------------------------------------------
    File        : JBoxPopupMenu
    Purpose     : 
    Syntax      : 
    Description : ABL popup menu for use with browse, button, frame, etc
    Author(s)   : brynjar
    Created     : Fri Oct 04 18:07:12 CEST 2013
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS JBoxPopupMenu: 
	/*------------------------------------------------------------------------------
	 Purpose:
	 Notes:
	------------------------------------------------------------------------------*/
  DEF VAR hSourceProc   AS HANDLE NO-UNDO.
  DEF VAR bOk           AS LOG    NO-UNDO.
  DEF VAR ix            AS INT    NO-UNDO.
  DEF VAR cOptions      AS CHAR   NO-UNDO.
  DEF VAR hParentMenu   AS HANDLE NO-UNDO.
      
  DEF PUBLIC PROPERTY POPUP-MENU-HANDLE    AS HANDLE GET. PROTECTED SET.
		
	CONSTRUCTOR PUBLIC JBoxPopupMenu (  ):
		SUPER ().
		
    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.
    
    CREATE MENU POPUP-MENU-HANDLE.
    POPUP-MENU-HANDLE:POPUP-ONLY = yes.
	END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxPopupMenu (ihSourceProc AS HANDLE):
    SUPER ().
    
    hSourceProc = ihSourceProc.
    
    CREATE MENU POPUP-MENU-HANDLE.
    POPUP-MENU-HANDLE:POPUP-ONLY = yes.
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxPopupMenu (ihPopup      AS HANDLE
                                   ,ihSourceProc AS HANDLE):
    SUPER ().
    
    hSourceProc = ihSourceProc.
    
    POPUP-MENU-HANDLE = ihPopup.
  END CONSTRUCTOR.
		
  METHOD PUBLIC VOID addTool (icTool            AS CHAR
                             ,icLabel           AS CHAR
                             ,icParentMenuLabel AS CHAR
                             ,ibAlwaysEnabled   AS LOG
                             ,ibToggle          AS LOG
                             ,ibToggleChecked   AS LOG
                             ,icMethod          AS CHAR
                              ).
    
    if icTool = "" then do:
      MESSAGE "Invalid definition: No Tool is defined for addTool"
              VIEW-AS ALERT-BOX.
      return.        
    end.                                    
    IF icParentMenuLabel NE "" THEN DO:
      hParentMenu = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"sub-menu" + icParentMenuLabel)) NO-ERROR.
      IF NOT VALID-HANDLE(hParentMenu) THEN DO:
        MESSAGE "Invalid parent menu " + icParentMenuLabel
                 VIEW-AS ALERT-BOX.
        RETURN.
      END.         
    END.                          

    IF ibAlwaysEnabled THEN icMethod = icMethod + "¤enable".
    DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).  
    DYNAMIC-FUNCTION("NewMenuBand",IF VALID-HANDLE(hParentMenu) THEN hParentMenu ELSE POPUP-MENU-HANDLE
                                  ,icTool + ";" + icLabel + ";" + icMethod                                  
                                  ,cOptions
                                  ).
                                                               
    hParentMenu = ?.                            
  END METHOD.
  METHOD PUBLIC VOID addTool (icTool AS CHAR):
    addTool(icTool,"","",NO,NO,NO,"").
  END METHOD.
  METHOD PUBLIC VOID addTool (icTool  AS CHAR
                             ,icLabel AS CHAR):
    addTool(icTool,icLabel,"",NO,NO,NO,"").
  END METHOD.
  METHOD PUBLIC VOID addTool (icTool       AS CHAR
                             ,icLabel      AS CHAR
                             ,icParentMenuLabel AS CHAR):
    addTool(icTool,icLabel,icParentMenuLabel,NO,NO,NO,"").
  END METHOD.
  METHOD PUBLIC VOID addTool (icTool       AS CHAR
                             ,icLabel      AS CHAR
                             ,ibAlwaysEnabled   AS LOG):
    addTool(icTool,icLabel,"",ibAlwaysEnabled,NO,NO,"").
  END METHOD.


  METHOD PUBLIC VOID addRule ():
    addTool("-","","",NO,NO,NO,"").
  END METHOD.
  
  /* Toolgroup implementations */
  METHOD PUBLIC VOID addToolGroup (icGroup           AS CHAR
                                  ,icParentMenuLabel AS CHAR
                                  ,ibAlwaysEnabled   AS LOG
                                  ,ibRule            AS LOG):
    def var cMenuItems   as char no-undo.
    def var cTool      as char no-undo.
    def var cToolsList as char no-undo.
        
    cMenuItems = DYNAMIC-FUNCTION("getAttribute",SESSION,icGroup).
    if cMenuItems = "" then cMenuItems = icGroup.
    do ix = 1 to num-entries(cMenuItems):
      cTool = entry(ix,cMenuItems).
      if ibAlwaysEnabled and (num-entries(cTool,"¤") = 1 or (num-entries(cTool,"¤") > 1 and not entry(2,cTool,"¤") matches "*enable*")) then 
        cTool = cTool + "¤enable".
      cToolsList = cToolsList + (if cToolsList ne "" then "," else "") + cTool.
    end.
    if ibRule and not can-do("-,rule",entry(1,cToolsList)) then cToolsList = "-," + cToolsList.
     
    IF icParentMenuLabel NE "" THEN DO:
      hParentMenu = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"sub-menu" + icParentMenuLabel)) NO-ERROR.
      IF NOT VALID-HANDLE(hParentMenu) THEN DO:
        MESSAGE "Invalid parent menu " + icParentMenuLabel
                 VIEW-AS ALERT-BOX.
        RETURN.
      END.         
    END.                          

    DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).  
    DYNAMIC-FUNCTION("NewMenuBand",IF VALID-HANDLE(hParentMenu) THEN hParentMenu ELSE POPUP-MENU-HANDLE
                                  ,cToolsList                                  
                                  ,cOptions
                                  ).
                                                               
    hParentMenu = ?.                            
      
  END METHOD.
  METHOD PUBLIC VOID addToolGroup (icGroup AS CHAR):
    addToolGroup(icGroup,"",NO,NO).
  END METHOD.
  METHOD PUBLIC VOID addToolGroup (icGroup AS CHAR
                                  ,icMenu  AS CHAR):
    addToolGroup(icGroup,icMenu,NO,NO).
  END METHOD.
  METHOD PUBLIC VOID addToolGroup (icGroup         AS CHAR
                                  ,icMenu          AS CHAR
                                  ,ibAlwaysEnabled AS LOG):
    addToolGroup(icGroup,icMenu,ibAlwaysEnabled,NO).
  END METHOD.
  /*
  METHOD PUBLIC VOID addToolGroup (icGroup         AS CHAR
                                  ,ibAlwaysEnabled AS LOG):
    addToolGroup(icGroup,"",ibAlwaysEnabled,NO).
  END METHOD.
  METHOD PUBLIC VOID addToolGroup (icGroup         AS CHAR
                                  ,ibAlwaysEnabled AS LOG
                                  ,ibRule          AS LOG):
    addToolGroup(icGroup,"",ibAlwaysEnabled,ibRule).
  END METHOD. 
  */

  /* Sub-menu implementations: */
  METHOD PUBLIC VOID addSubMenu (icSubMenu         AS CHAR
                                ,icParentMenuLabel AS CHAR):
                                  
    if icSubMenu = "" then do:
      MESSAGE "Invalid definition: No Sub-menu is defined for addSubMenu"
              VIEW-AS ALERT-BOX.
      return.        
    end.                                                         
    addTool("|" + icSubMenu,"",icParentMenuLabel,NO,NO,NO,"").
  END METHOD.
  METHOD PUBLIC VOID addSubMenu (icSubMenu AS CHAR):
    addSubMenu(icSubMenu,"").
  END METHOD.

  METHOD PUBLIC VOID applyTool (icTool AS CHARACTER):
    DEFINE VARIABLE hWidget AS HANDLE NO-UNDO.
    
    hWidget = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"menu-item" + icTool)).
    IF VALID-HANDLE(hWidget) THEN 
      RUN InvokeMethod(POPUP-MENU-HANDLE,DYNAMIC-FUNCTION("getEventMethod",POPUP-MENU-HANDLE,hWidget)).
  END METHOD.

  METHOD PUBLIC HANDLE getMenuItemHandle (icTool  as char):
    def var hWidget as handle no-undo.
    hWidget = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"menu-item" + icTool)) NO-ERROR.
    return hWidget.
  end method.

  METHOD PUBLIC HANDLE getSubMenuHandle (icTool  as char):
    def var hWidget as handle no-undo.
    hWidget = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"sub-menu" + icTool)) NO-ERROR.
    return hWidget.
  end method.

  METHOD PUBLIC VOID setTools(icState  AS CHARACTER):
    DYNAMIC-FUNCTION("setToolbar",POPUP-MENU-HANDLE,icState).
  END METHOD.

  METHOD PUBLIC VOID setTools ():
    THIS-OBJECT:setTools("avail"). /* same as property objectState */
  END METHOD.
  
  METHOD PUBLIC VOID setJBoxAttribute(icAttribute AS CHAR
                                     ,icValue AS CHAR):
    DYNAMIC-FUNCTION("setAttribute",POPUP-MENU-HANDLE,icAttribute,icValue).
  END METHOD.
  METHOD PUBLIC CHARACTER getJBoxAttribute(icAttribute AS CHAR):
    RETURN  DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,icAttribute).
  END METHOD.

  METHOD PUBLIC VOID setDisabledTools (icToolList AS CHARACTER):
    DYNAMIC-FUNCTION("setAttribute",POPUP-MENU-HANDLE,"disabledEvents",icToolList).
  END METHOD.

  METHOD PUBLIC VOID addDisabledTools (icToolList AS CHARACTER):
    setJBoxAttribute("disabledEvents",TRIM(getJBoxAttribute("disabledEvents") + "," + icToolList,",")). 
  END METHOD.

  METHOD PUBLIC VOID setToolDisabled (icTool AS CHARACTER):
    DEFINE VARIABLE cEnaEvents AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDisEvents AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cTools     AS CHARACTER NO-UNDO.
 
    IF icTool = "" THEN 
    DO:
      THIS-OBJECT:setDisabledTools("").
      RETURN.
    END.  
    
    cDisEvents = DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"disabledEvents").
    cEnaEvents = DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"enabledEvents").

    cTools = icTool.  
    DO ix = 1 TO NUM-ENTRIES(cTools):
      icTool = ENTRY(ix,cTools).

      IF NOT CAN-DO(cDisEvents,icTool) THEN 
      DO:
        cDisEvents = cDisEvents + (IF cDisEvents NE "" THEN "," ELSE "") + icTool.
        DYNAMIC-FUNCTION("setAttribute",POPUP-MENU-HANDLE,"disabledEvents",cDisEvents).
      END.  
      IF CAN-DO(cEnaEvents,icTool) THEN 
      DO:
        cEnaEvents = DYNAMIC-FUNCTION("DeleteListItem",cEnaEvents,icTool,0,"").
        DYNAMIC-FUNCTION("setAttribute",POPUP-MENU-HANDLE,"enabledEvents",cEnaEvents).
      END.
    END.    
  END METHOD.

  METHOD PUBLIC VOID setEnabledTools (icToolList AS CHARACTER):
    DYNAMIC-FUNCTION("setAttribute",POPUP-MENU-HANDLE,"enabledEvents",icToolList).
  END METHOD.

  METHOD PUBLIC VOID addEnabledTools (icToolList AS CHARACTER):
    setJBoxAttribute("enabledEvents",TRIM(getJBoxAttribute("enabledEvents") + "," + icToolList,",")). 
  END METHOD.
  
  METHOD PUBLIC VOID setToolEnabled (icTool AS CHARACTER):
    DEFINE VARIABLE cEnaEvents AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDisEvents AS CHARACTER NO-UNDO.
    DEFINE VARIABLE ix         AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cTools     AS CHARACTER NO-UNDO.
    
    IF icTool = "" THEN 
    DO:
      THIS-OBJECT:setEnabledTools("").
      RETURN.
    END.
    cDisEvents = DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"disabledEvents").
    cEnaEvents = DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"enabledEvents").
    
    cTools = icTool.  
    DO ix = 1 TO NUM-ENTRIES(cTools):
      icTool = ENTRY(ix,cTools).
      IF NOT CAN-DO(cEnaEvents,icTool) THEN 
      DO:
        cEnaEvents = cEnaEvents + (IF cEnaEvents NE "" THEN "," ELSE "") + icTool.
        DYNAMIC-FUNCTION("setAttribute",POPUP-MENU-HANDLE,"enabledEvents",cEnaEvents).
      END.
      IF CAN-DO(cDisEvents,icTool) THEN 
      DO:
        cDisEvents = DYNAMIC-FUNCTION("DeleteListItem",cDisEvents,icTool,0,"").
        DYNAMIC-FUNCTION("setAttribute",POPUP-MENU-HANDLE,"disabledEvents",cDisEvents).
      END.
    END.    
  END METHOD.
  
  METHOD PUBLIC VOID setSubMenuSensitive (icSubMenu AS CHARACTER,ibSensitive AS LOG):
    DEFINE VARIABLE hWidget AS HANDLE NO-UNDO.
    hWidget = getSubMenuHandle(icSubMenu).
    IF VALID-HANDLE(hWidget) THEN hWidget:SENSITIVE = ibSensitive.
  END METHOD.

  METHOD PUBLIC VOID setToolLabel (icTool AS CHARACTER
    ,icLabel  AS CHARACTER):
    DEFINE VARIABLE hWidget AS HANDLE NO-UNDO.
    hWidget = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"menu-item" + icTool)) NO-ERROR.
    IF VALID-HANDLE(hWidget) THEN
      hWidget:LABEL = icLabel.                                  
  END METHOD.

  METHOD PUBLIC LOGICAL setToolMethod (icTool    AS CHARACTER
    ,icMethod  AS CHARACTER):
    DEFINE VARIABLE hWidget AS HANDLE NO-UNDO.
    DEFINE VARIABLE bReturn AS LOG    NO-UNDO.
    hWidget = WIDGET-HANDLE(DYNAMIC-FUNCTION("getAttribute",POPUP-MENU-HANDLE,"menu-item" + icTool)) NO-ERROR.
    IF VALID-HANDLE(hWidget) THEN 
    DO:
      DYNAMIC-FUNCTION("setEventMethod",POPUP-MENU-HANDLE,hWidget,icMethod).
      bReturn = YES.
    END.  
  END METHOD.


  METHOD PUBLIC LOGICAL getActionPermission(INPUT icAction AS CHAR):
    hSourceProc = SOURCE-PROCEDURE.

    RUN JBoxLogFuncToMeth.p ("getActionPermission"
                            ,"CHARACTER,CHARACTER,CHARACTER"
                            ,hSourceProc:FILE-NAME + CHR(1) + POPUP-MENU-HANDLE:NAME + CHR(1) + icAction
                            ,?
                            ,OUTPUT bOk).
    RETURN bOk.                        
  END.

	DESTRUCTOR PUBLIC JBoxPopupMenu ( ):

	END DESTRUCTOR.

END CLASS.