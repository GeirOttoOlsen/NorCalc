 
 /*------------------------------------------------------------------------
    File        : JBoxDynSelector
    Purpose     : Perform dynamic selection
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Tue May 19 12:43:22 CEST 2015
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

CLASS JBoxDynSelector:
  DEF PUBLIC PROPERTY SELECTOR-PROCEDURE    AS HANDLE NO-UNDO GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY PARENT-PROCEDURE      AS HANDLE NO-UNDO GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY SELECTOR-PANEL-HANDLE AS HANDLE GET. PROTECTED SET.
  DEF PUBLIC PROPERTY SOURCE-BROWSE-OBJECT  AS JBoxBrowse GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY TARGET-BROWSE-OBJECT  AS JBoxBrowse GET. PROTECTED SET. 
  DEF PUBLIC PROPERTY TOOLBAR-OBJECT AS JBoxToolbar GET. PROTECTED SET.
  DEF PUBLIC PROPERTY NAME           AS CHARACTER GET. SET.
  DEF PUBLIC PROPERTY TITLE          AS CHARACTER 
      GET: RETURN SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:WINDOW:TITLE. END GET.
      SET (INPUT icTitle AS CHAR): SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:WINDOW:TITLE = icTitle. END SET.
  
                   
  CONSTRUCTOR PUBLIC JBoxDynSelector (INPUT ihParent    AS HANDLE
                                     ,INPUT ihLookup    AS HANDLE
                                     ,INPUT ihBrwSource AS HANDLE
                                     ,INPUT ihBrwTarget AS HANDLE
                                     ,INPUT ihToolbar   AS HANDLE 
                                    ):

    ASSIGN SELECTOR-PROCEDURE   = SOURCE-PROCEDURE
           PARENT-PROCEDURE     = ihParent
           SOURCE-BROWSE-OBJECT = NEW JBoxBrowse(ihBrwSource,ihParent)
           TARGET-BROWSE-OBJECT = NEW JBoxBrowse(ihBrwTarget,ihParent)
           NAME = SOURCE-BROWSE-OBJECT:BUFFER-HANDLE:NAME
           .
    IF VALID-HANDLE(ihToolbar) THEN DO:      
      TOOLBAR-OBJECT = NEW JBoxToolbar(ihToolbar,ihParent).
      SOURCE-BROWSE-OBJECT:TOOLBAR-OBJECT = TOOLBAR-OBJECT.
    END.  
        
  END CONSTRUCTOR.

  METHOD PUBLIC VOID ExpandSelectorDialog (iiPixelsX AS INT,iiPixelsY AS INT):
    RUN ExpandSelectorDialog IN SELECTOR-PROCEDURE (SOURCE-BROWSE-OBJECT:BROWSE-HANDLE,iiPixelsX,iiPixelsY).
  END METHOD.
                               
  METHOD PUBLIC VOID ExpandSelectorDialogX (iiPixels AS INT):
    RUN ExpandSelectorDialog IN SELECTOR-PROCEDURE (SOURCE-BROWSE-OBJECT:BROWSE-HANDLE,iiPixels,0).
  END METHOD.

  METHOD PUBLIC VOID ExpandSelectorDialogY (iiPixels AS INT):
    RUN ExpandSelectorDialog IN SELECTOR-PROCEDURE (SOURCE-BROWSE-OBJECT:BROWSE-HANDLE,0,iiPixels).
  END METHOD.

  METHOD PUBLIC VOID setSelectedRowidList (icRowIdList AS CHAR):
    icRowIdList = TRIM(icRowIdList,",") + ",".
    DYNAMIC-FUNCTION("setSelectedRowids" IN SELECTOR-PROCEDURE,icRowIdList).
  END METHOD.
      
  METHOD PUBLIC VOID OpenQuerySource():
    DYNAMIC-FUNCTION("setCurrentObject",THIS-OBJECT:SOURCE-BROWSE-OBJECT:BROWSE-HANDLE).
    RUN OpenQuerySource IN SELECTOR-PROCEDURE.
  END METHOD.    

  METHOD PUBLIC VOID OpenQueryTarget():
    DYNAMIC-FUNCTION("setCurrentObject",THIS-OBJECT:TARGET-BROWSE-OBJECT:BROWSE-HANDLE).
    RUN OpenQueryTarget IN SELECTOR-PROCEDURE.
  END METHOD.    
      
  METHOD PUBLIC LOGICAL LoadPanel(icPanelProc AS CHAR):
    DEF VAR hPanelFrame  AS HANDLE NO-UNDO.
    DEF VAR hSelectorWin AS HANDLE NO-UNDO.
    
    IF CAN-DO(SELECTOR-PROCEDURE:INTERNAL-ENTRIES,"LoadPanel") THEN 
      RUN LoadPanel IN SELECTOR-PROCEDURE (icPanelProc,OUTPUT SELECTOR-PANEL-HANDLE).
    ELSE RETURN NO.  
    
    IF VALID-HANDLE(SELECTOR-PANEL-HANDLE) THEN DO:
      
      JBoxServerAPI:Instance:SELECTOR-PANEL-HANDLE = SELECTOR-PANEL-HANDLE. 
      
      /* Make room for and position the panel frame: */
      hPanelFrame = DYNAMIC-FUNCTION("getFrameHandle" IN SELECTOR-PANEL-HANDLE) NO-ERROR.
      IF NOT ERROR-STATUS:ERROR THEN DO:
        ASSIGN hSelectorWin               = SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:WINDOW
               hSelectorWin:HEIGHT-PIXELS = hSelectorWin:HEIGHT-PIXELS + hPanelFrame:HEIGHT-PIXELS
               .
        APPLY "window-resized" TO hSelectorWin.
        DYNAMIC-FUNCTION("adjustBrowseHeight" IN SELECTOR-PROCEDURE,hPanelFrame:HEIGHT-PIXELS * -1).
        hPanelFrame:Y = SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:Y + SOURCE-BROWSE-OBJECT:BROWSE-HANDLE:HEIGHT-PIXELS. 
      END.
      ELSE DO:
        MESSAGE 'Missing function "getFrameHandle" in selector panel' icPanelProc SKIP "Programmers mistake"
                VIEW-AS ALERT-BOX.
        RETURN NO.        
      END.          
    END.
    ELSE RETURN NO.
    
    RETURN YES.
  END.
        
  METHOD PUBLIC VOID CloseSelector ():
    APPLY "CLOSE" TO SELECTOR-PROCEDURE.  
  END METHOD.
      
  DESTRUCTOR PUBLIC JBoxDynSelector ( ):
  END DESTRUCTOR.
END CLASS.
  