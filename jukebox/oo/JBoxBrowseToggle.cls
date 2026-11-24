 
 /*------------------------------------------------------------------------
    File        : JBoxBrowseToggle
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Thu Aug 21 12:43:22 CEST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
/*USING oo.* FROM PROPATH.*/

CLASS JBoxBrowseToggle:
  DEF VAR hSourceProc AS HANDLE NO-UNDO.
  DEF PUBLIC PROPERTY ToggleBoxHandle AS HANDLE NO-UNDO GET. PROTECTED SET.

  DEF PUBLIC PROPERTY SCREEN-VALUE  AS CHAR 
      GET(): RETURN ToggleBoxHandle:SCREEN-VALUE. 
      END GET. 
      SET(icScreenValue AS CHAR):
        ToggleBoxHandle:SCREEN-VALUE = icScreenValue.
      END SET.


  
  CONSTRUCTOR PUBLIC JBoxBrowseToggle (ioBrowse            AS JBoxBrowse
                                      ,icBrowseColumn      AS CHAR
                                      ,ibRefreshRow        AS LOG):
      SUPER ().

    hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icBrowseColumn,ibRefreshRow).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowseToggle (ioBrowse            AS JBoxBrowse
                                      ,icBrowseColumn      AS CHAR
                                      ,ihSourceProc        AS HANDLE
                                      ,ibRefreshRow        AS LOG):
      SUPER ().

    hSourceProc = ihSourceProc.

    InitializeComponent(ioBrowse,icBrowseColumn,icBrowseColumn,ibRefreshRow).                 
      
  END CONSTRUCTOR.
      
  METHOD PRIVATE VOID initializeComponent(ioBrowse              AS JBoxBrowse
                                         ,icBrowseColumn        AS CHAR
                                         ,icTableColumn         AS CHAR
                                         ,ibRefreshRow          AS LOG):
           
    
    DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).  

    ToggleBoxHandle  = DYNAMIC-FUNCTION("NewBrowseToggle",ioBrowse:BROWSE-HANDLE,icBrowseColumn,icTableColumn,"").
                 
    DYNAMIC-FUNCTION("CreateOverlayLink",ioBrowse:BROWSE-HANDLE,ToggleBoxHandle,icBrowseColumn).
    
    IF ibRefreshRow THEN
      DYNAMIC-FUNCTION("setAttribute",ToggleBoxHandle,"refreshRow","yes").
      
    ioBrowse:registerOverlay(THIS-OBJECT,"JBoxBrowseToggle",icBrowseColumn,ToggleBoxHandle).               
                   
  END METHOD.                                       

END CLASS.