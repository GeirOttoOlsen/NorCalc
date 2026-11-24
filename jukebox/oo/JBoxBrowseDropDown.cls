 
 /*------------------------------------------------------------------------
    File        : JBoxBrowseDropDown
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Thu Aug 21 12:43:22 CEST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
/*USING oo.* FROM PROPATH.*/

CLASS JBoxBrowseDropDown:
  DEF VAR hSourceProc AS HANDLE NO-UNDO.
  DEF PUBLIC PROPERTY DropDownHandle AS HANDLE NO-UNDO GET. PROTECTED SET.

  DEF PUBLIC PROPERTY SCREEN-VALUE  AS CHAR 
      GET(): RETURN DropDownHandle:SCREEN-VALUE. 
      END GET. 
      SET(icScreenValue AS CHAR):
        DropDownHandle:SCREEN-VALUE = icScreenValue.
      END SET.

  CONSTRUCTOR PUBLIC JBoxBrowseDropDown (ioBrowse              AS JBoxBrowse
                                        ,icBrowseColumn        AS CHAR
                                        ,icTableColumn         AS CHAR
                                        ,icDropDownTblsAndFlds AS CHAR
                                        ,icDropDownCriteria    AS CHAR
                                        ,icValueList           AS CHAR
                                        ,ibRefreshRow          AS LOG):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icTableColumn,icDropDownTblsAndFlds,icDropDownCriteria,icValueList,ibRefreshRow).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowseDropDown (ioBrowse              AS JBoxBrowse
                                        ,icBrowseColumn        AS CHAR
                                        ,icTableColumn         AS CHAR
                                        ,icDropDownTblsAndFlds AS CHAR
                                        ,icDropDownCriteria    AS CHAR
                                        ,ibRefreshRow          AS LOG):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icTableColumn,icDropDownTblsAndFlds,icDropDownCriteria,"",ibRefreshRow).                 
      
  END CONSTRUCTOR.
   
  CONSTRUCTOR PUBLIC JBoxBrowseDropDown (ioBrowse              AS JBoxBrowse
                                        ,icBrowseColumn        AS CHAR
                                        ,icTableColumn         AS CHAR
                                        ,icDropDownTblsAndFlds AS CHAR
                                        ,icDropDownCriteria    AS CHAR):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icTableColumn,icDropDownTblsAndFlds,icDropDownCriteria,"",YES).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowseDropDown (ioBrowse              AS JBoxBrowse
                                        ,icBrowseColumn        AS CHAR
                                        ,icDropDownTblsAndFlds AS CHAR
                                        ,icDropDownCriteria    AS CHAR
                                        ,ibRefreshRow          AS LOG):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icBrowseColumn,icDropDownTblsAndFlds,icDropDownCriteria,"",ibRefreshRow).                 
      
  END CONSTRUCTOR.
  
  CONSTRUCTOR PUBLIC JBoxBrowseDropDown (ioBrowse            AS JBoxBrowse
                                        ,icBrowseColumn      AS CHAR
                                        ,icValueList         AS CHAR
                                        ,ibRefreshRow        AS LOG):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icBrowseColumn,"","",icValueList,ibRefreshRow).                 
      
  END CONSTRUCTOR.
  
  CONSTRUCTOR PUBLIC JBoxBrowseDropDown (ioBrowse              AS JBoxBrowse
                                        ,icBrowseColumn        AS CHAR
                                        ,icDropDownTblsAndFlds AS CHAR
                                        ,icDropDownCriteria    AS CHAR):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icBrowseColumn,icDropDownTblsAndFlds,icDropDownCriteria,"",YES).                 
      
  END CONSTRUCTOR.

  CONSTRUCTOR PUBLIC JBoxBrowseDropDown (ioBrowse            AS JBoxBrowse
                                        ,icBrowseColumn      AS CHAR
                                        ,icValueList         AS CHAR):
      SUPER ().

    IF PROVERSION < "11" THEN hSourceProc = DYNAMIC-FUNCTION ("getProcedureHandle",PROGRAM-NAME(2)).
    ELSE hSourceProc = SOURCE-PROCEDURE.

    InitializeComponent(ioBrowse,icBrowseColumn,icBrowseColumn,"","",icValueList,YES).                 
      
  END CONSTRUCTOR.
    
  METHOD PRIVATE VOID initializeComponent(ioBrowse              AS JBoxBrowse
                                         ,icBrowseColumn        AS CHAR
                                         ,icTableColumn         AS CHAR
                                         ,icDropDownTblsAndFlds AS CHAR
                                         ,icDropDownCriteria    AS CHAR
                                         ,icValueList           AS CHAR
                                         ,ibRefreshRow          AS LOG):
           
    
    DYNAMIC-FUNCTION("setObjectSourceProc",hSourceProc).  

    IF icValueList NE "" THEN   
      DropDownHandle  = DYNAMIC-FUNCTION("NewBrowseDropDown",ioBrowse:BROWSE-HANDLE,icBrowseColumn,icTableColumn
                 ,"","",icValueList).
    ELSE
      DropDownHandle  = DYNAMIC-FUNCTION("NewBrowseDropDown",ioBrowse:BROWSE-HANDLE,icBrowseColumn,icTableColumn
                 ,icDropDownTblsAndFlds,icDropDownCriteria,"").
                 
    DYNAMIC-FUNCTION("CreateOverlayLink",ioBrowse:BROWSE-HANDLE,DropDownHandle,icBrowseColumn).
    
    IF ibRefreshRow THEN
      DYNAMIC-FUNCTION("setAttribute",DropDownHandle,"refreshRow","yes").
      
    ioBrowse:registerOverlay(THIS-OBJECT,"JBoxBrowseDropDown",icBrowseColumn,DropDownHandle).               
                   
  END METHOD.                                       

END CLASS.