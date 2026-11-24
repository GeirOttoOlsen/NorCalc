 
 /*------------------------------------------------------------------------
    File        : TreeView
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Brynjar
    Created     : Fri Sep 22 16:06:33 CEST 2017
    Notes       : Remember to set AllowDrop for drag/drop function 
  ----------------------------------------------------------------------*/



ROUTINE-LEVEL ON ERROR UNDO, THROW.

USING System.Convert FROM ASSEMBLY.
USING System.Windows.Forms.DataFormats FROM ASSEMBLY.
USING System.IO.Path FROM ASSEMBLY.

CLASS uc.JBoxMsTreeView INHERITS uc.JBoxUCbase: 

  DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
  DEFINE PRIVATE VARIABLE imageList1  AS System.Windows.Forms.ImageList NO-UNDO.

  DEF VAR idxNode AS INT NO-UNDO. 
  DEF VAR oDefaultContextMenuStrip AS System.Windows.Forms.ContextMenuStrip NO-UNDO.
  DEF VAR draggedNode AS System.Windows.Forms.TreeNode NO-UNDO.
    		    		
  DEF TEMP-TABLE ttNode NO-UNDO 
      FIELD cNodeName       AS CHAR 
      FIELD cParentNodeName AS CHAR 
      FIELD cNodeText       AS CHAR 
      FIELD cNodeType       AS CHAR
      FIELD cNodeImage      AS CHAR
      FIELD iNodeIdx        AS INT 
      FIELD oNodeObj        AS Progress.Lang.Object
      FIELD iChildIdx       AS INT
      FIELD iImageIdx       AS INT
      FIELD iSelImageIdx    AS INT
      INDEX idxNodeIdx IS PRIMARY UNIQUE iNodeIdx
      .

  DEF TEMP-TABLE ttContextMenu NO-UNDO 
      FIELD cMenuName       AS CHAR 
      FIELD cMenuType       AS CHAR
      FIELD oMenuObj        AS Progress.Lang.Object
      FIELD cParentMenuName AS CHAR
      FIELD cNodeType       AS CHAR
      .

  DEF TEMP-TABLE ttDroppedFiles NO-UNDO
      FIELD FileName AS CHAR.
      		
  DEFINE PUBLIC PROPERTY treeView1 AS System.Windows.Forms.TreeView NO-UNDO GET. PRIVATE SET.
  DEFINE PUBLIC PROPERTY ttNodeBuffer AS HANDLE GET(): RETURN BUFFER ttNode:HANDLE. END GET. PROTECTED SET.
  DEFINE PUBLIC PROPERTY ttContextBuffer AS HANDLE GET(): RETURN BUFFER ttContextMenu:HANDLE. END GET. PROTECTED SET.
    
  CONSTRUCTOR PUBLIC JBoxMsTreeView (INPUT ihWinSuper    AS HANDLE, /* Window super proc - unknown if object created from window */
                                     INPUT ihWinProc     AS HANDLE,
                                     INPUT ihPlaceHolder AS HANDLE, /* Design widget (rectangle, field, etc) */
                                     INPUT iiDeltaWidth  AS INTEGER):

     SUPER(ihWinSuper,ihWinProc,ihPlaceHolder,iiDeltaWidth).

     THIS-OBJECT:InitializeComponent("").   
  END CONSTRUCTOR.
  
  
  CONSTRUCTOR PUBLIC JBoxMsTreeView ( INPUT ihWinProc     AS HANDLE,
                                      INPUT ihPlaceHolder AS HANDLE ): /* Design widget (rectangle, field, etc) */
                                   
    SUPER(?,ihWinProc,ihPlaceHolder,0).
   
    InitializeComponent(""). 
  END CONSTRUCTOR.


  CONSTRUCTOR PUBLIC JBoxMsTreeView ( INPUT ihWinProc     AS HANDLE,
                                      INPUT ihPlaceHolder AS HANDLE, /* Design widget (rectangle, field, etc) */
                                      INPUT icImageList   AS CHAR  ):
  
    SUPER(?,ihWinProc,ihPlaceHolder,0).
  
    InitializeComponent(icImageList). 
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID ExpandNodes(INPUT icNodeName AS CHAR  ):
    DEF VAR ix AS INT NO-UNDO.
    
    IF icNodeName = "" THEN
      THIS-OBJECT:treeView1:ExpandAll().
    ELSE DO ix = 1 TO NUM-ENTRIES(icNodeName,"|"):
      FIND FIRST ttNode
           WHERE ttNode.cNodeName = TRIM(ENTRY(ix,icNodeName,"|"))
           NO-ERROR.
      IF AVAIL ttNode THEN 
        CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):Expand().
    END.
        
    RETURN.

  END METHOD.

  METHOD PUBLIC VOID CollapseNodes(INPUT icNodeName AS CHAR  ):
    
    IF icNodeName = "" THEN
      THIS-OBJECT:treeView1:CollapseAll().
    ELSE DO:
      FIND FIRST ttNode
           WHERE ttNode.cNodeName = icNodeName
           NO-ERROR.
      IF AVAIL ttNode THEN 
        CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):Collapse().
    END.
        
    RETURN.

  END METHOD.

  METHOD PUBLIC LOGICAL isThisMyNode (INPUT ioTreeNode AS System.Windows.Forms.TreeNode):
    DEF VAR oAblNode AS Progress.Lang.Object NO-UNDO.
    
    oAblNode = CAST(ioTreeNode,"Progress.Lang.Object") NO-ERROR.
    IF VALID-OBJECT(oAblNode) THEN DO:
      FIND FIRST ttNode 
           WHERE ttNode.oNodeObj = oAblNode
           NO-ERROR.
      RETURN AVAIL ttNode.     
    END.  
    RETURN NO.
  END METHOD.  

  METHOD PUBLIC VOID InitializeComponent( INPUT icImageList AS CHAR ):
		
    DEF VAR ix             AS INT NO-UNDO.
    DEF VAR cImgFile       AS CHAR NO-UNDO.
    
    PUBLISH "setContainerMsTreeViewObject" FROM CONTAINER-HANDLE (CONTAINER-HANDLE,THIS-OBJECT). 
    
    DEFINE VARIABLE treeNode1 AS System.Windows.Forms.TreeNode NO-UNDO.
    treeNode1 = NEW System.Windows.Forms.TreeNode("Rot").
    THIS-OBJECT:components = NEW System.ComponentModel.Container().
    THIS-OBJECT:treeView1 = NEW System.Windows.Forms.TreeView().

    IF icImageList NE "" THEN DO:
      THIS-OBJECT:imageList1 = NEW System.Windows.Forms.ImageList(THIS-OBJECT:components).
      icImageList = REPLACE(icImageList,",",";").
      DO ix = 1 TO NUM-ENTRIES(icImageList,";"):
        cImgFile = REPLACE(ENTRY(ix,icImageList,";"),"\","/").
        IF SEARCH(cImgFile) NE ? THEN DO:
          FILE-INFO:FILE-NAME = cImgFile.
          imageList1:Images:Add(System.Drawing.Image:FromFile(FILE-INFO:FULL-PATHNAME)).
          imageList1:Images:SetKeyName(ix - 1, ENTRY(NUM-ENTRIES(cImgFile,"/"),cImgFile,"/")).
        END.    
      END.  
      THIS-OBJECT:treeView1:ImageIndex = 0.
      THIS-OBJECT:treeView1:ImageList = THIS-OBJECT:imageList1.
      THIS-OBJECT:treeView1:SelectedImageIndex = 1.
      
    END.
    
    THIS-OBJECT:SuspendLayout().
    /*  */
    /* treeView1 */
    /*  */
    THIS-OBJECT:treeView1:Location = NEW System.Drawing.Point(0, 0).
    THIS-OBJECT:treeView1:Name = "treeView1".
/*    THIS-OBJECT:treeView1:Size = NEW System.Drawing.Size(211, 136).*/
    THIS-OBJECT:treeView1:TabIndex = 0.
    THIS-OBJECT:treeView1:AllowDrop = YES.
    THIS-OBJECT:treeView1:DragDrop:Subscribe(THIS-OBJECT:DropNode).
    THIS-OBJECT:treeView1:ItemDrag:Subscribe(THIS-OBJECT:DragNode).
    THIS-OBJECT:treeView1:DragEnter:Subscribe(THIS-OBJECT:DragEnter).
    THIS-OBJECT:treeView1:DragOver:Subscribe(THIS-OBJECT:DragOver).
    THIS-OBJECT:treeView1:DoubleClick:Subscribe(THIS-OBJECT:NodeDoubleClick).
    THIS-OBJECT:treeView1:AfterSelect:Subscribe(THIS-OBJECT:SelectChange).
    THIS-OBJECT:treeView1:KeyPress:Subscribe(THIS-OBJECT:OnKeyPress).
    THIS-OBJECT:treeView1:BeforeExpand:Subscribe(THIS-OBJECT:BeforeExpandNode).
    THIS-OBJECT:treeView1:AfterExpand:Subscribe(THIS-OBJECT:AfterExpandNode).
    THIS-OBJECT:treeView1:HideSelection = NO.
    /*  */
    /* MsTVForm */
    /*  */
    THIS-OBJECT:ClientSize = NEW System.Drawing.Size(357, 326).
    THIS-OBJECT:Controls:Add(THIS-OBJECT:treeView1).
    THIS-OBJECT:Name = "JBoxMsTreeView".
    THIS-OBJECT:Text = "JBoxMsTreeView".
    THIS-OBJECT:ResumeLayout(FALSE).
    CATCH e AS Progress.Lang.Error:
      UNDO, THROW e.
    END CATCH.
END METHOD.

/* Mandatory methods: */
  METHOD PUBLIC System.Windows.Forms.TreeView getDotNetWidget():
    RETURN TreeView1.
  END METHOD.

  METHOD PUBLIC CHARACTER getDotNetWidgetType():
    RETURN STRING(TreeView1:GetType()).
  END METHOD.

  METHOD PUBLIC CHARACTER DEFAULT():
    RETURN DYNAMIC-INVOKE(THIS-OBJECT,ENTRY(1,PROGRAM-NAME(2)," ")).
  END METHOD.

/* TreeView methods: */
  METHOD PUBLIC INTEGER AddNode (icParentNodeName     AS CHAR 
                                ,icNodeName           AS CHAR 
                                ,icNodeText           AS CHAR
                                ,icNodeType           AS CHAR
                                ,iiImageIndex         AS INT
                                ,iiSelectedImageIndex AS INT
                                 ):
                                     
    DEFINE VARIABLE treeNode1 AS System.Windows.Forms.TreeNode NO-UNDO.
    
    FIND FIRST ttNode 
         WHERE ttNode.cNodeName = icParentNodeName
         NO-ERROR.
        
    IF AVAIL ttNode THEN
      treeNode1 = CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):Nodes:Add(icNodeText).
    ELSE 
      treeNode1 = treeView1:Nodes:Add(icNodeText).
    
    IF iiImageIndex GE 0 THEN  
      treeNode1:ImageIndex = iiImageIndex.  
    IF iiSelectedImageIndex GE 0 THEN  
      treeNode1:SelectedImageIndex = iiSelectedImageIndex.  
    
    idxNode = idxNode + 1.

    CREATE ttNode.
    ASSIGN ttNode.iNodeIdx        = idxNode
           ttNode.cNodeName       = icNodeName
           ttNode.cParentNodeName = icParentNodeName
           ttNode.cNodeText       = icNodeText
           ttNode.cNodeType       = icNodeType
           ttNode.oNodeObj        = CAST(treeNode1,"Progress.Lang.Object")
           ttNode.iChildIdx       = treeNode1:Index
           ttNode.iImageIdx       = iiImageIndex
           ttNode.iSelImageIdx    = iiSelectedImageIndex
           .
    
    treeNode1:Name = icNodeName.
    
    RETURN idxNode.                              
  END METHOD.                            

  METHOD PUBLIC CHARACTER AddContextMenuStrip (icNodeName  AS CHAR
                                              ,icNodeType  AS CHAR):
                                         
    DEFINE VARIABLE contextMenuStrip1 AS CLASS System.Windows.Forms.ContextMenuStrip NO-UNDO.
    contextMenuStrip1 = NEW System.Windows.Forms.ContextMenuStrip().
  
    IF NOT VALID-OBJECT(oDefaultContextMenuStrip) THEN oDefaultContextMenuStrip = contextMenuStrip1.
    
    IF icNodeName NE "" THEN DO:
      FIND FIRST ttNode
           WHERE ttNode.cNodeName = icNodeName
           NO-ERROR
           .
      IF AVAIL ttNode THEN
        ASSIGN CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):ContextMenuStrip = contextMenuStrip1
               contextMenuStrip1:Name = icNodeName.     
    END.
    ELSE DO:
      FOR EACH ttNode
          WHERE (IF icNodeType NE "" THEN ttNode.cNodeType = icNodeType ELSE TRUE)
          :
        CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):ContextMenuStrip = contextMenuStrip1.    
      END.
      contextMenuStrip1:Name = IF icNodeType NE "" THEN icNodeType ELSE STRING(TIME).
    END.  
    
    CREATE ttContextMenu.
    ASSIGN ttContextMenu.cMenuName = contextMenuStrip1:Name
           ttContextMenu.cMenuType = "PopupMenu"
           ttContextMenu.oMenuObj  = CAST(contextMenuStrip1,"Progress.Lang.Object")
           ttContextMenu.cNodeType = icNodeType
           .
    
    RETURN contextMenuStrip1:Name.                                 
  END.
  
  METHOD PUBLIC CHARACTER AddContextMenuStrip (icNodeTypeList  AS CHAR):
                                         
    DEFINE VARIABLE contextMenuStrip1 AS CLASS System.Windows.Forms.ContextMenuStrip NO-UNDO.
    contextMenuStrip1 = NEW System.Windows.Forms.ContextMenuStrip().
  
    IF NOT VALID-OBJECT(oDefaultContextMenuStrip) THEN oDefaultContextMenuStrip = contextMenuStrip1.
    
    FOR EACH ttNode
        WHERE LOOKUP(ttNode.cNodeType,icNodeTypeList) > 0
        :
      CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):ContextMenuStrip = contextMenuStrip1.    
    END.
    contextMenuStrip1:Name = STRING(TIME).
    
    CREATE ttContextMenu.
    ASSIGN ttContextMenu.cMenuName = contextMenuStrip1:Name
           ttContextMenu.cMenuType = "PopupMenu"
           ttContextMenu.oMenuObj  = CAST(contextMenuStrip1,"Progress.Lang.Object")
           ttContextMenu.cNodeType = icNodeTypeList
           .
    
    RETURN contextMenuStrip1:Name.                                 
  END.

  METHOD PUBLIC VOID AppyContextMenuStrip (icNodeType AS CHAR):
                   
                                         
    FOR EACH ttContextMenu 
        WHERE ttContextMenu.cNodeType = icNodeType
        :
      FOR EACH ttNode
          WHERE ttNode.cNodeType = icNodeType
        :
        CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):ContextMenuStrip = CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ContextMenuStrip").
      END.     
    END.
  END.

  METHOD PUBLIC CHARACTER AddContextMenuStrip ():
                                         
    DEFINE VARIABLE contextMenuStrip1 AS CLASS System.Windows.Forms.ContextMenuStrip NO-UNDO.
    contextMenuStrip1 = NEW System.Windows.Forms.ContextMenuStrip().
  
    IF NOT VALID-OBJECT(oDefaultContextMenuStrip) THEN oDefaultContextMenuStrip = contextMenuStrip1.
    
    FOR EACH ttNode
        :
      CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode"):ContextMenuStrip = contextMenuStrip1.    
    END.
    contextMenuStrip1:Name = STRING(TIME).
    
    CREATE ttContextMenu.
    ASSIGN ttContextMenu.cMenuName = contextMenuStrip1:Name
           ttContextMenu.cMenuType = "PopupMenu"
           ttContextMenu.oMenuObj  = CAST(contextMenuStrip1,"Progress.Lang.Object")
           .
    
    RETURN contextMenuStrip1:Name.                                 
  END.
  
  METHOD PUBLIC System.Windows.Forms.ContextMenuStrip getContextMenuStrip (icMenuName  AS CHAR):

    FIND FIRST ttContextMenu
         WHERE ttContextMenu.cMenuName = icMenuName
           AND ttContextMenu.cMenuType = "PopupMenu"
         NO-ERROR.
    
    RETURN IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ContextMenuStrip") ELSE ?.
  END.         

  METHOD PUBLIC LOGICAL setContextMenuStripEnabled (icMenuStrip AS CHAR, INPUT ibEnabled AS LOG):

    FIND ttContextMenu
         WHERE ttContextMenu.cMenuName = icMenuStrip
           AND ttContextMenu.cMenuType = "PopupMenu"
         NO-ERROR.
    
    IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ContextMenuStrip"):Enabled = ibEnabled.

    RETURN AVAIL ttContextMenu.
    
  END.         
                    
  METHOD PUBLIC CHARACTER AddContextSubMenu (icMenuStrip  AS CHAR
                                            ,icSubMenu    AS CHAR
                                            ,icName       AS CHAR
                                            ,icText       AS CHAR
                                            ,icImageFile  AS CHAR
                                             ):
  
    DEF VAR contextMenuItem1 AS System.Windows.Forms.ToolStripMenuItem NO-UNDO.
          
    contextMenuItem1 = NEW System.Windows.Forms.ToolStripMenuItem().       
    ASSIGN contextMenuItem1:Name = icName
           contextMenuItem1:Text = icText
           .
  
    IF icSubMenu NE "" THEN DO:
      FIND FIRST ttContextMenu 
           WHERE ttContextMenu.cMenuName = icSubMenu
             AND ttContextMenu.cMenuType = "SubMenu"
           NO-ERROR.
      IF AVAIL ttContextMenu THEN
        CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripMenuItem"):DropDownItems:Add(contextMenuItem1).
    END.    
    ELSE DO:    
      FIND FIRST ttContextMenu 
           WHERE ttContextMenu.cMenuName = icMenuStrip
             AND ttContextMenu.cMenuType = "PopupMenu"
           NO-ERROR.
      IF AVAIL ttContextMenu THEN
        CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ContextMenuStrip"):Items:Add(contextMenuItem1).
    END.
    
    IF icImageFile NE "" AND SEARCH(icImageFile) NE ? THEN DO:
      FILE-INFO:FILE-NAME = SEARCH(icImageFile).
      contextMenuItem1:Image = System.Drawing.Image:FromFile(FILE-INFO:FULL-PATHNAME).
    END.  
    
    CREATE ttContextMenu.
    ASSIGN ttContextMenu.cMenuName = contextMenuItem1:Name
           ttContextMenu.cMenuType = "SubMenu"
           ttContextMenu.oMenuObj  = CAST(contextMenuItem1,"Progress.Lang.Object")
           .
    RETURN contextMenuItem1:Name.     
  END.

  METHOD PUBLIC System.Windows.Forms.ToolStripMenuItem getContextSubMenu (icSubMenu AS CHAR):

    FIND FIRST ttContextMenu
         WHERE ttContextMenu.cMenuName = icSubMenu
           AND ttContextMenu.cMenuType = "SubMenu"
         NO-ERROR.
    
    RETURN IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripMenuItem") ELSE ?.
  END.         

  METHOD PUBLIC LOGICAL setContextSubMenuEnabled (icSubMenu AS CHAR, INPUT ibEnabled AS LOG):

    FIND ttContextMenu
         WHERE ttContextMenu.cMenuName = icSubMenu
           AND ttContextMenu.cMenuType = "SubMenu"
         NO-ERROR.
    
    IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripMenuItem"):Enabled = ibEnabled.

    RETURN AVAIL ttContextMenu.
    
  END.         
    
  METHOD PUBLIC VOID AddContextMenuItem (icMenuStrip  AS CHAR
                                        ,icSubMenu    AS CHAR
                                        ,icProcedure  AS CHAR
                                        ,icText       AS CHAR
                                        ,icImageFile  AS CHAR
                                         ):
  
    DEF VAR contextMenuItem1 AS System.Windows.Forms.ToolStripItem NO-UNDO.
    DEF VAR ix               AS INT NO-UNDO.

    IF icSubMenu NE "" THEN DO ix = 1 TO NUM-ENTRIES(icSubMenu):
      FIND FIRST ttContextMenu 
           WHERE ttContextMenu.cMenuName = ENTRY(ix,icSubMenu)
             AND ttContextMenu.cMenuType = "SubMenu"
           NO-ERROR.
      IF AVAIL ttContextMenu THEN DO: 
        contextMenuItem1 = CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripMenuItem"):DropDownItems:Add(icText).
        IF icImageFile NE "" AND SEARCH(icImageFile) NE ? THEN DO:
          FILE-INFO:FILE-NAME = SEARCH(icImageFile).
          contextMenuItem1:Image = System.Drawing.Image:FromFile(FILE-INFO:FULL-PATHNAME).
        END.  
                
        CREATE ttContextMenu.
        ASSIGN contextMenuItem1:Name    = icProcedure
               ttContextMenu.cMenuName  = contextMenuItem1:Name
               ttContextMenu.cMenuType  = "MenuItem"
               ttContextMenu.oMenuObj   = CAST(contextMenuItem1,"Progress.Lang.Object")
               ttContextMenu.cParentMenuName = ENTRY(ix,icSubMenu)
               .
        contextMenuItem1:Click:Subscribe(THIS-OBJECT:MenuItemClick).
      END.  
      ELSE DO:
        MESSAGE "Submenu " ENTRY(ix,icSubMenu) "not defined"
                VIEW-AS ALERT-BOX ERROR.
        RETURN.
      END.
    END.    
    ELSE DO ix = 1 TO NUM-ENTRIES(icMenuStrip):    
      FIND FIRST ttContextMenu 
           WHERE ttContextMenu.cMenuName = ENTRY(ix,icMenuStrip)
             AND ttContextMenu.cMenuType = "PopupMenu"
           NO-ERROR.
      IF AVAIL ttContextMenu THEN
        contextMenuItem1 = CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ContextMenuStrip"):Items:Add(icText).
      ELSE DO:
        MESSAGE "Context menu strip (popup menu)" ENTRY(ix,icMenuStrip) "not defined"
                VIEW-AS ALERT-BOX ERROR.
        RETURN.
      END.    
    
      IF icImageFile NE "" AND SEARCH(icImageFile) NE ? THEN DO:
        FILE-INFO:FILE-NAME = SEARCH(icImageFile).
        contextMenuItem1:Image = System.Drawing.Image:FromFile(FILE-INFO:FULL-PATHNAME).
      END.  
              
      CREATE ttContextMenu.
      ASSIGN contextMenuItem1:Name    = icProcedure
             ttContextMenu.cMenuName  = contextMenuItem1:Name
             ttContextMenu.cMenuType  = "MenuItem"
             ttContextMenu.oMenuObj   = CAST(contextMenuItem1,"Progress.Lang.Object")
             ttContextMenu.cParentMenuName = ENTRY(ix,icMenuStrip)
             .
      contextMenuItem1:Click:Subscribe(THIS-OBJECT:MenuItemClick).
    END.
  END.

  METHOD PUBLIC System.Windows.Forms.ToolStripItem getContextMenuItem (icMenuName AS CHAR):

    FIND ttContextMenu
         WHERE ttContextMenu.cMenuName = icMenuName
           AND ttContextMenu.cMenuType = "MenuItem"
         NO-ERROR.
    
    RETURN IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripItem") ELSE ?.
  END.         

  METHOD PUBLIC System.Windows.Forms.ToolStripItem getContextMenuItem (icMenuName AS CHAR,icParentMenu AS CHAR):

    FIND FIRST ttContextMenu
         WHERE ttContextMenu.cMenuName       = icMenuName
           AND ttContextMenu.cParentMenuName = icParentMenu
           AND ttContextMenu.cMenuType       = "MenuItem"
         NO-ERROR.
    
    RETURN IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripItem") ELSE ?.
  END.         

  METHOD PUBLIC LOGICAL setContextMenuItemEnabled (icMenuName AS CHAR, INPUT ibEnabled AS LOG):

    FIND ttContextMenu
         WHERE ttContextMenu.cMenuName = icMenuName
           AND ttContextMenu.cMenuType = "MenuItem"
         NO-ERROR.
    
    IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripItem"):Enabled = ibEnabled.

    RETURN AVAIL ttContextMenu.
    
  END.         

  METHOD PUBLIC LOGICAL setContextMenuItemEnabled (icMenuName AS CHAR,INPUT icParentMenu AS CHAR, INPUT ibEnabled AS LOG):

    FIND FIRST ttContextMenu
         WHERE ttContextMenu.cMenuName       = icMenuName
           AND ttContextMenu.cParentMenuName = icParentMenu
           AND ttContextMenu.cMenuType       = "MenuItem"
         NO-ERROR.
    IF NOT AVAIL ttContextMenu THEN     
      FIND FIRST ttContextMenu
           WHERE ttContextMenu.cMenuName       = icMenuName
             AND ttContextMenu.cParentMenuName = icParentMenu
             AND ttContextMenu.cMenuType       = "MenuItem"
           NO-ERROR.
    
    IF AVAIL ttContextMenu THEN CAST(ttContextMenu.oMenuObj,"System.Windows.Forms.ToolStripItem"):Enabled = ibEnabled.
    
    RETURN AVAIL ttContextMenu.
    
  END.         

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID SelectNode( icNodeName AS CHAR ):
    
    FIND FIRST ttNode
         WHERE ttNode.cNodeName = icNodeName
         NO-ERROR.
    IF AVAIL ttNode THEN DO: 
      THIS-OBJECT:treeView1:SelectedNode = CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode").
      IF NOT THIS-OBJECT:treeView1:HideSelection THEN
        THIS-OBJECT:treeView1:Select().
      IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"TreeNodeSelectedRecord") THEN 
        RUN TreeNodeSelectedRecord IN hWinProc(treeView1:selectedNode:Name). 
    END.
    RETURN.

  END METHOD.

  METHOD PUBLIC LOGICAL setAllowDrop (ibAllowDrop AS LOG):
    THIS-OBJECT:treeView1:AllowDrop = ibAllowDrop.
  END METHOD.  

  METHOD PUBLIC VOID setVisible (ibVisible AS LOG):
    ASSIGN THIS-OBJECT:treeView1:Visible = ibVisible
           THIS-OBJECT:hPlaceHolder:Visible = ibVisible.
  END METHOD.  

  METHOD PUBLIC LOGICAL clearNodes ():
    EMPTY TEMP-TABLE ttNode.
    EMPTY TEMP-TABLE ttContextMenu.
    idxNode = 0.
    THIS-OBJECT:treeView1:Nodes:Clear().
    THIS-OBJECT:treeView1:ImageList = THIS-OBJECT:imageList1.
  END.  

  METHOD PUBLIC CHARACTER getNodeType (INPUT icNodeName AS CHAR):
    FIND FIRST ttNode WHERE ttNode.cNodeName = icNodeName NO-ERROR.
    IF AVAIL ttNode THEN
      RETURN ttNode.cNodeType.
    ELSE 
      RETURN "".
  END.  
  
  METHOD PUBLIC CHARACTER getNodeText (INPUT icNodeName AS CHAR):
    FIND FIRST ttNode WHERE ttNode.cNodeName = icNodeName NO-ERROR.
    IF AVAIL ttNode THEN
      RETURN ttNode.cNodeText.
    ELSE 
      RETURN "".
  END.  

  METHOD PUBLIC LOGICAL setNodeText (INPUT icNodeName AS CHAR,INPUT icNodeText AS CHAR):
    DEFINE VARIABLE treeNode1 AS System.Windows.Forms.TreeNode NO-UNDO.

    DEF BUFFER bttParentNode FOR ttNode.

    FIND FIRST ttNode WHERE ttNode.cNodeName = icNodeName NO-ERROR.
    IF AVAIL ttNode THEN DO:
      FIND FIRST bttParentNode
           WHERE bttParentNode.cNodeName = ttNode.cParentNodeName
           NO-ERROR.
      IF AVAIL bttParentNode THEN DO:
        CAST(bttParentNode.oNodeObj,"System.Windows.Forms.TreeNode"):Nodes:RemoveAt(ttNode.iChildIdx).
        treeNode1 = CAST(bttParentNode.oNodeObj,"System.Windows.Forms.TreeNode"):Nodes:Insert(ttNode.iChildIdx,icNodeName,icNodeText,ttNode.iImageIdx,ttNode.iSelImageIdx).
      END.
      ELSE DO:       
        THIS-OBJECT:treeView1:Nodes:RemoveAt(ttNode.iChildIdx).
        treeNode1 = THIS-OBJECT:treeView1:Nodes:Insert(ttNode.iChildIdx,icNodeName,icNodeText,ttNode.iImageIdx,ttNode.iSelImageIdx).
      END.  
      ttNode.cNodeText = icNodeText.
      ttNode.oNodeObj  = CAST(treeNode1,"Progress.Lang.Object").
      THIS-OBJECT:SelectNode(icNodeName).
      RETURN YES.
    END.  
    ELSE 
      RETURN NO.
  END.  

  METHOD PUBLIC System.Windows.Forms.TreeNode getNodeObject (INPUT iiNodeIdx AS INT):
    FIND FIRST ttNode WHERE ttNode.iNodeIdx = iiNodeIdx NO-ERROR.
    IF AVAIL ttNode THEN
      RETURN CAST(ttNode.oNodeObj,"System.Windows.Forms.TreeNode").
    ELSE 
      RETURN ?.
  END.  

  METHOD PUBLIC CHARACTER getParentNodeName( icNodeName AS CHAR ):
    
    FIND FIRST ttNode
         WHERE ttNode.cNodeName = icNodeName
         NO-ERROR.
    IF AVAIL ttNode THEN  
      RETURN ttNode.cParentNodeName.
    ELSE
      RETURN ?.  

  END METHOD.

  METHOD PRIVATE VOID BeforeExpandNode( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.TreeViewCancelEventArgs ):
    DEF VAR bCancel AS LOG NO-UNDO.
    
    IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"TreeNodeBeforeExpandRecord") THEN DO:
      RUN TreeNodeBeforeExpandRecord IN hWinProc(e:Node:Name,OUTPUT bCancel).
      e:Cancel = bCancel. 
    END.  
       
    RETURN.

  END METHOD.

  METHOD PRIVATE VOID MenuItemClick( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
        
    DEF VAR oMenuItem AS System.Windows.Forms.ToolStripItem NO-UNDO. 
    
    oMenuItem = CAST(sender,"System.Windows.Forms.ToolStripItem").

    FIND FIRST ttContextMenu 
         WHERE ttContextMenu.cMenuName = oMenuItem:Name
           AND ttContextMenu.cMenuType = "MenuItem"
         NO-ERROR.
    IF AVAIL ttContextMenu 
       AND CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,ttContextMenu.cMenuName) THEN 
      RUN VALUE(ttContextMenu.cMenuName) IN hWinProc(treeView1:SelectedNode:Name).    
    ELSE IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"TreeMenuItemRecord") THEN 
      RUN TreeMenuItemRecord IN hWinProc(oMenuItem:Name,treeView1:SelectedNode:Name). 
       
    RETURN.

  END METHOD.

  METHOD PRIVATE VOID SelectChange( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):
        
    
    IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"TreeNodeSelectedRecord") THEN 
      RUN TreeNodeSelectedRecord IN hWinProc(treeView1:selectedNode:Name). 
       
    RETURN.

  END METHOD.
  
  METHOD PRIVATE VOID DropNode( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.DragEventArgs ):
    
    DEF VAR targetPoint AS System.Drawing.Point NO-UNDO. 
    DEF VAR targetNode  AS System.Windows.Forms.TreeNode NO-UNDO.
    DEF VAR DropFiles   AS "System.String[]" NO-UNDO.
    DEF VAR ix          AS INT NO-UNDO.
    DEF VAR cFileNames  AS CHAR NO-UNDO.
    DEF VAR sourceNode  AS System.Windows.Forms.TreeNode NO-UNDO.
    DEF VAR bUseTT      AS LOG NO-UNDO. 
    DEF VAR hbttDrop    AS HANDLE NO-UNDO.

    hbttDrop = BUFFER ttDroppedFiles:HANDLE.
    
    If e:Data:GetDataPresent(System.Windows.Forms.DataFormats:FileDrop) THEN DO:
      DropFiles = CAST(e:Data:GetData(System.Windows.Forms.DataFormats:FileDrop),"System.String[]").
      bUseTT = CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"TreeDropFilesTT").
      IF bUseTT THEN EMPTY TEMP-TABLE ttDroppedFiles. 
      DO ix = 0 TO DropFiles:Length - 1:
        IF bUseTT THEN DO:
          CREATE ttDroppedFiles.
          ttDroppedFiles.FileName = DropFiles:GetValue(ix):ToString().
        END.
        ELSE          
          cFileNames = cFileNames + (IF cFileNames NE "" THEN "|" ELSE "") + DropFiles:GetValue(ix):ToString().
      END.
      IF bUseTT THEN
        RUN TreeDropFilesTT IN hWinProc(hbttDrop,IF VALID-OBJECT(targetNode) THEN targetNode:Name ELSE "").
      ELSE IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"TreeDropFiles") THEN 
        RUN TreeDropFiles IN hWinProc(cFileNames,IF VALID-OBJECT(targetNode) THEN targetNode:Name ELSE "").
    END.
    ELSE IF e:Data:GetDataPresent("System.Windows.Forms.TreeNode",true) THEN DO:
      sourceNode = CAST(e:Data:GetData("System.Windows.Forms.TreeNode",true),"System.Windows.Forms.TreeNode").
      /*  Retrieve the client coordinates of the drop location.*/
      targetPoint = treeView1:PointToClient(NEW System.Drawing.Point(e:X, e:Y)).
      /*  Retrieve the node at the drop location.*/
      targetNode = treeView1:GetNodeAt(targetPoint).

      IF sourceNode = draggedNode THEN DO: // Drag-drop within same tree
        IF targetNode:Name = draggedNode:Name THEN RETURN.
    
        IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"TreeDropNode") THEN 
          RUN TreeDropNode IN hWinProc(draggedNode:Name,targetNode:Name).
      END.  
      ELSE  
        PUBLISH "TreeNodeDropped" FROM hWinProc (THIS-OBJECT,sourceNode,targetNode).
    END.     

    RETURN.

  END METHOD.  
  
  METHOD PRIVATE VOID DragNode( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.ItemDragEventArgs ):
    
    draggedNode = CAST(e:Item,"System.Windows.Forms.TreeNode").
    THIS-OBJECT:DoDragDrop(e:Item, System.Windows.Forms.DragDropEffects:Move).

  END METHOD.
  
  METHOD PRIVATE VOID DragOver( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.DragEventArgs ):

    DEF VAR targetPoint AS System.Drawing.Point NO-UNDO. 
    // Retrieve the client coordinates of the mouse position.
    targetPoint = treeView1:PointToClient(new System.Drawing.Point(e:X, e:Y)).

    // Select the node at the mouse position.
    treeView1:SelectedNode = treeView1:GetNodeAt(targetPoint).
    
    RETURN.

  END METHOD.
  
  METHOD PRIVATE VOID DragEnter( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.DragEventArgs ):
    
    e:Effect = e:AllowedEffect.
    RETURN.

  END METHOD.

  METHOD PRIVATE VOID NodeDoubleClick( INPUT sender AS System.Object, INPUT e AS System.EventArgs ):

    IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"NodeDoubleClickRecord") THEN

      RUN NodeDoubleClickRecord IN hWinProc(treeView1:SelectedNode:Name). 

  END METHOD.
  
  METHOD PRIVATE VOID OnKeyPress( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.KeyPressEventArgs ):
    IF e:KeyChar = Convert:ToChar(System.Windows.Forms.Keys:Enter) THEN DO:
      IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"ReturnOfTreeNode") THEN
        RUN ReturnOfTreeNode IN hWinProc (treeView1:SelectedNode:Name).
    END.  
    ELSE IF e:KeyChar = Convert:ToChar(System.Windows.Forms.Keys:Escape) THEN DO:
      IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"EscapeOfTreeNode") THEN
        RUN EscapeOfTreeNode IN hWinProc (treeView1:SelectedNode:Name).
    END.  
  END METHOD.  
  
 
  METHOD PRIVATE VOID AfterExpandNode( INPUT sender AS System.Object, INPUT e AS System.Windows.Forms.TreeViewEventArgs ):

    IF CAN-DO(THIS-OBJECT:hWinProc:INTERNAL-ENTRIES,"AfterExpandNodeRecord") THEN
      RUN AfterExpandNodeRecord IN hWinProc(CAST(e:Node,"System.Windows.Forms.TreeNode"):Name).

  END METHOD.
  
	DESTRUCTOR PUBLIC JBoxMsTreeView ( ):

		IF VALID-OBJECT(components) THEN DO:
			CAST(components, System.IDisposable):Dispose().
		END.

	END DESTRUCTOR.

END CLASS.
