 
 /*------------------------------------------------------------------------
    File        : JBoxUltraFormattedText
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : meg
    Created     : Thu Aug 19 13:09:39 CEST 2021
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING Progress.Windows.UserControl.
USING Progress.Windows.Form.
USING uc.* FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS uc.JBoxUltraFormattedText INHERITS uc.JBoxUCbase: 
  
    DEFINE PRIVATE VARIABLE m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top AS Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea NO-UNDO.
    DEFINE PRIVATE VARIABLE m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right AS Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea NO-UNDO.
    DEFINE PRIVATE VARIABLE m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left AS Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea NO-UNDO.
    DEFINE PRIVATE VARIABLE m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom AS Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea NO-UNDO.
    DEFINE PRIVATE VARIABLE components AS System.ComponentModel.IContainer NO-UNDO.
    DEFINE PUBLIC PROPERTY ultraFormattedTextEditor1 AS Infragistics.Win.FormattedLinkLabel.UltraFormattedTextEditor NO-UNDO GET. PROTECTED SET.
    DEFINE PRIVATE VARIABLE JBoxUltraFormattedText_Fill_Panel AS Infragistics.Win.Misc.UltraPanel NO-UNDO.
    DEFINE PUBLIC PROPERTY ultraToolbarsManager1 AS Infragistics.Win.UltraWinToolbars.UltraToolbarsManager NO-UNDO GET. PROTECTED SET.

    
  CONSTRUCTOR PUBLIC JBoxUltraFormattedText (INPUT ihWinProc     AS HANDLE,
                                             INPUT ihPlaceHolder AS HANDLE ):
    
        SUPER(?,ihWinProc,ihPlaceHolder,0).
/*        THIS-OBJECT:ComponentsCollection:ADD(THIS-OBJECT:components).*/

  END CONSTRUCTOR.

  METHOD PUBLIC OVERRIDE VOID InitializeComponent(  ):
    
        /* NOTE: The following method is automatically generated.
        
        We strongly suggest that the contents of this method only be modified using the
        Visual Designer to avoid any incompatible modifications.
        
        Modifying the contents of this method using a code editor will invalidate any support for this file. */
        THIS-OBJECT:components = NEW System.ComponentModel.Container().
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE ultraToolbar1 AS Infragistics.Win.UltraWinToolbars.UltraToolbar NO-UNDO.
        ultraToolbar1 = NEW Infragistics.Win.UltraWinToolbars.UltraToolbar("UltraToolbar1").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE buttonTool7 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonTool7 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Bold").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE buttonTool8 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonTool8 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Italic").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE buttonTool9 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonTool9 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Underline").
        @VisualDesigner.FormMember (NeedsInitialize="true").
/*        DEFINE VARIABLE buttonTool1 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.*/
/*        buttonTool1 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Save").             */
        DEFINE VARIABLE buttonTool1 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonTool1 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Hyperlink").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE buttonTool10 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonTool10 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Bold").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE buttonTool11 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonTool11 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Italic").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE buttonTool12 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonTool12 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Underline").
        @VisualDesigner.FormMember (NeedsInitialize="true").
        DEFINE VARIABLE buttonTool2 AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
//        buttonTool2 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Save").
        buttonTool2 = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Hyperlink").
        DEFINE VARIABLE buttonToolFont AS Infragistics.Win.UltraWinToolbars.ButtonTool NO-UNDO.
        buttonToolFont = NEW Infragistics.Win.UltraWinToolbars.ButtonTool("Font").
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel = NEW Infragistics.Win.Misc.UltraPanel().
        THIS-OBJECT:ultraFormattedTextEditor1 = NEW Infragistics.Win.FormattedLinkLabel.UltraFormattedTextEditor().
        THIS-OBJECT:ultraToolbarsManager1 = NEW Infragistics.Win.UltraWinToolbars.UltraToolbarsManager(THIS-OBJECT:components).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left = NEW Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right = NEW Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top = NEW Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom = NEW Infragistics.Win.UltraWinToolbars.UltraToolbarsDockArea().
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:ClientArea:SuspendLayout().
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:SuspendLayout().
        CAST(THIS-OBJECT:ultraToolbarsManager1, System.ComponentModel.ISupportInitialize):BeginInit().
        THIS-OBJECT:SuspendLayout().
        /*  */
        /* JBoxUltraFormattedText_Fill_Panel */
        /*  */
        /*  */
        /* JBoxUltraFormattedText_Fill_Panel.ClientArea */
        /*  */
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:ClientArea:Controls:Add(THIS-OBJECT:ultraFormattedTextEditor1).
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:Cursor = System.Windows.Forms.Cursors:Default.
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:Location = NEW System.Drawing.Point(0, 25).
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:Name = "JBoxUltraFormattedText_Fill_Panel".
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:Size = NEW System.Drawing.Size(446, 273).
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:TabIndex = 0.
        /*  */
        /* ultraFormattedTextEditor1 */
        /*  */
        THIS-OBJECT:ultraFormattedTextEditor1:Dock = System.Windows.Forms.DockStyle:Fill.
        THIS-OBJECT:ultraFormattedTextEditor1:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:ultraFormattedTextEditor1:Name = "ultraFormattedTextEditor1".
        THIS-OBJECT:ultraFormattedTextEditor1:Size = NEW System.Drawing.Size(446, 273).
        THIS-OBJECT:ultraFormattedTextEditor1:TabIndex = 0.
        THIS-OBJECT:ultraFormattedTextEditor1:Value = "This is a test".
        /*  */
        /* ultraToolbarsManager1 */
        /*  */
        THIS-OBJECT:ultraToolbarsManager1:DesignerFlags = 1.
        THIS-OBJECT:ultraToolbarsManager1:DockWithinContainer = THIS-OBJECT.
        THIS-OBJECT:ultraToolbarsManager1:DockWithinContainerBaseType = Progress.Util.TypeHelper:GetType("Progress.Windows.Form").
        ultraToolbar1:DockedColumn = 0.
        ultraToolbar1:DockedRow = 0.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar0 AS Infragistics.Win.UltraWinToolbars.ToolBase EXTENT 5 NO-UNDO.
        arrayvar0[1] = buttonTool7.
        arrayvar0[2] = buttonTool8.
        arrayvar0[3] = buttonTool9.
        arrayvar0[4] = buttonToolFont.
        arrayvar0[5] = buttonTool1.
        ultraToolbar1:NonInheritedTools:AddRange(arrayvar0).
        ultraToolbar1:Text = "UltraToolbar1".
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar1 AS Infragistics.Win.UltraWinToolbars.UltraToolbar EXTENT 1 NO-UNDO.
        arrayvar1[1] = ultraToolbar1.
        THIS-OBJECT:ultraToolbarsManager1:Toolbars:AddRange(arrayvar1).
        buttonTool10:SharedPropsInternal:Caption = "Bold".
        buttonTool10:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        buttonTool11:SharedPropsInternal:Caption = "Italic".
        buttonTool11:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        buttonTool12:SharedPropsInternal:Caption = "Underline".
        buttonTool12:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
/*        buttonTool2:SharedPropsInternal:Caption = "Save".                                                              */
/*        buttonTool2:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.*/
        buttonTool2:SharedPropsInternal:Caption = "Hyperlink".
        buttonTool2:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        buttonToolFont:SharedPropsInternal:Caption = "Font".
        buttonToolFont:SharedPropsInternal:DisplayStyle = Infragistics.Win.UltraWinToolbars.ToolDisplayStyle:ImageAndText.
        @VisualDesigner.FormMember (NeedsInitialize="false", InitializeArray="true").
        DEFINE VARIABLE arrayvar2 AS Infragistics.Win.UltraWinToolbars.ToolBase EXTENT 4 NO-UNDO.
        arrayvar2[1] = buttonTool10.
        arrayvar2[2] = buttonTool11.
        arrayvar2[3] = buttonTool12.
        arrayvar2[4] = buttonTool2.
        THIS-OBJECT:ultraToolbarsManager1:Tools:AddRange(arrayvar2).
        THIS-OBJECT:ultraToolbarsManager1:ToolClick:Subscribe(THIS-OBJECT:ultraToolbarsManager1_ToolClick_1).
        /*  */
        /* m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left */
        /*  */
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:BackColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Left.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:ForeColor = System.Drawing.SystemColors:ControlText.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:Location = NEW System.Drawing.Point(0, 25).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:Name = "m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left".
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:Size = NEW System.Drawing.Size(0, 273).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left:ToolbarsManager = THIS-OBJECT:ultraToolbarsManager1.
        /*  */
        /* m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right */
        /*  */
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:BackColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Right.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:ForeColor = System.Drawing.SystemColors:ControlText.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:Location = NEW System.Drawing.Point(446, 25).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:Name = "m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right".
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:Size = NEW System.Drawing.Size(0, 273).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right:ToolbarsManager = THIS-OBJECT:ultraToolbarsManager1.
        /*  */
        /* m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top */
        /*  */
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:BackColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Top.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:ForeColor = System.Drawing.SystemColors:ControlText.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:Location = NEW System.Drawing.Point(0, 0).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:Name = "m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top".
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:Size = NEW System.Drawing.Size(446, 25).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top:ToolbarsManager = THIS-OBJECT:ultraToolbarsManager1.
        /*  */
        /* m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom */
        /*  */
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:AccessibleRole = System.Windows.Forms.AccessibleRole:Grouping.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:BackColor = System.Drawing.SystemColors:Control.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:DockedPosition = Infragistics.Win.UltraWinToolbars.DockedPosition:Bottom.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:ForeColor = System.Drawing.SystemColors:ControlText.
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:Location = NEW System.Drawing.Point(0, 298).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:Name = "m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom".
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:Size = NEW System.Drawing.Size(446, 0).
        THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom:ToolbarsManager = THIS-OBJECT:ultraToolbarsManager1.
        /*  */
        /* JBoxUltraFormattedText */
        /*  */
        THIS-OBJECT:ClientSize = NEW System.Drawing.Size(446, 298).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Left).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Right).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Bottom).
        THIS-OBJECT:Controls:Add(THIS-OBJECT:m_JBoxUltraFormattedText_Toolbars_Dock_Area_Top).
        THIS-OBJECT:Name = "JBoxUltraFormattedText".
        THIS-OBJECT:Text = "Simple HTML Editor".
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:ClientArea:ResumeLayout(FALSE).
        THIS-OBJECT:JBoxUltraFormattedText_Fill_Panel:ResumeLayout(FALSE).
        CAST(THIS-OBJECT:ultraToolbarsManager1, System.ComponentModel.ISupportInitialize):EndInit().
        THIS-OBJECT:ResumeLayout(FALSE).
        CATCH e AS Progress.Lang.Error:
            UNDO, THROW e.
        END CATCH.
  END METHOD.
  
/* Mandatory methods: */
  METHOD PUBLIC Infragistics.Win.FormattedLinkLabel.UltraFormattedTextEditor getDotNetWidget():
    RETURN ultraFormattedTextEditor1.
  END METHOD.

  METHOD PUBLIC CHARACTER getDotNetWidgetType():
    RETURN STRING(ultraFormattedTextEditor1:GetType()).
  END METHOD.

  METHOD PUBLIC CHARACTER DEFAULT():
    RETURN DYNAMIC-INVOKE(THIS-OBJECT,ENTRY(1,PROGRAM-NAME(2)," ")).
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  @VisualDesigner.
  METHOD PRIVATE VOID ultraToolbarsManager1_ToolClick_1( INPUT sender AS System.Object, INPUT e AS Infragistics.Win.UltraWinToolbars.ToolClickEventArgs ):
    
    CASE e:Tool:Key:
        WHEN "Bold" THEN 
            ultraFormattedTextEditor1:EditInfo:PerformAction(Infragistics.Win.FormattedLinkLabel.FormattedLinkEditorAction:ToggleBold).
        WHEN "Italic" THEN
            ultraFormattedTextEditor1:EditInfo:PerformAction(Infragistics.Win.FormattedLinkLabel.FormattedLinkEditorAction:ToggleItalics).
        WHEN "Underline" THEN            
            ultraFormattedTextEditor1:EditInfo:PerformAction(Infragistics.Win.FormattedLinkLabel.FormattedLinkEditorAction:ToggleUnderline).
        WHEN "Save" THEN
            MESSAGE ultraFormattedTextEditor1:Value
            VIEW-AS ALERT-BOX.              
        WHEN "Left" OR WHEN "Center" OR WHEN "Right" OR WHEN "Justify" THEN
            ultraFormattedTextEditor1:EditInfo:ApplyStyle("Text-align: " + e:Tool:Key, True).
        WHEN "URL" THEN
           ultraFormattedTextEditor1:TreatValueAs = Infragistics.Win.FormattedLinkLabel.TreatValueAs:URL.    
        WHEN "Hyperlink" THEN
           ultraFormattedTextEditor1:EditInfo:ShowLinkDialog().
        WHEN "Font" THEN
           ultraFormattedTextEditor1:EditInfo:ShowFontDialog().       
/*
            Case "InsertPicture"
                Me.ultraFormattedTextEditor1.EditInfo.ShowImageDialog()

            Case "Hyperlink"
                Me.ultraFormattedTextEditor1.EditInfo.ShowLinkDialog()

            Case "ColorSchemeList"
                Dim item As ListToolItem = CType(e.Tool, ListTool).SelectedItem
                If Not (item Is Nothing) Then
                    Office2007ColorTable.ColorScheme = CType(item.Value, Office2007ColorScheme)
                End If

            Case "Paste"
                Me.ultraFormattedTextEditor1.EditInfo.PerformAction(FormattedLinkEditorAction.Paste)

            Case "Font Dialog"
                Me.ultraFormattedTextEditor1.EditInfo.ShowFontDialog()

            Case "FullSpellCheck"
                Me.ultraSpellChecker1.ShowSpellCheckDialog(Me, Me.ultraFormattedTextEditor1)

            Case "Check Selection"
                Dim selectedText As String = Me.ultraFormattedTextEditor1.EditInfo.Editor.SelectedText
                Dim errors As ErrorCollection = Me.ultraSpellChecker1.CheckText(selectedText)
*/
      END.
    
    RETURN.

  END METHOD.

  
  METHOD PUBLIC OVERRIDE CHARACTER dotNetDisplay():
    ultraFormattedTextEditor1:Value = IF hBuffer:AVAIL THEN hBuffer:BUFFER-FIELD(cBufferDisplay):BUFFER-VALUE ELSE "".
  END.  

  METHOD PUBLIC OVERRIDE CHARACTER dotNetNew():
    IF CAN-QUERY(hPlaceholder,"initial") THEN
      ultraFormattedTextEditor1:Value = hPlaceholder:INITIAL.
    ELSE ultraFormattedTextEditor1:Value = hBuffer:BUFFER-FIELD(cBufferDisplay):INITIAL.
  END METHOD.
  
  METHOD PUBLIC OVERRIDE CHARACTER dotNetPreSave():
         /* Invoked from jboxuilib.SaveRecord before record i saved so input data from the dot.net control
            may be added to the dynamic save operation. */
    DEF VAR hWidget          AS HANDLE NO-UNDO.
    DEF VAR cScreenUpdFields AS CHAR   NO-UNDO.

    cScreenUpdFields = DYNAMIC-FUNCTION("getAttribute",hBuffer,"screenUpdateFields").

    IF CAN-DO(cScreenUpdFields,cBufferDisplay) THEN DO:
      hWidget = WIDGET-HANDLE(ENTRY(LOOKUP(cBufferDisplay,cScreenUpdFields),DYNAMIC-FUNCTION("getAttribute",hBuffer,"screenUpdateWidgets"))) NO-ERROR.
      IF VALID-HANDLE(hWidget) THEN hWidget:SCREEN-VALUE = ultraFormattedTextEditor1:Value.
    END.

  END METHOD.

  DESTRUCTOR PUBLIC JBoxUltraFormattedText ( ):

  END DESTRUCTOR.

END CLASS.