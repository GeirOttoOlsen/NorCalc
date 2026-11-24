USING Progress.Lang.*.
USING Progress.Windows.UserControl.
USING Progress.Windows.Form.
USING uc.* FROM PROPATH.


ROUTINE-LEVEL ON ERROR UNDO, THROW.

CLASS uc.JBoxTelerikReportView INHERITS uc.JBoxUCbase: 
  DEFINE PRIVATE VARIABLE components      AS class System.ComponentModel.IContainer           NO-UNDO.
  DEFINE PUBLIC VARIABLE oReportViewer    AS class Telerik.ReportViewer.WinForms.ReportViewer NO-UNDO.
  DEFINE PUBLIC VARIABLE oUriReportSource AS class Telerik.Reporting.UriReportSource          NO-UNDO.

    def var oReportPacker as class Telerik.Reporting.ReportPackager no-undo.
    def var oReportStream as class System.IO.FileStream no-undo.
    def var oDataStream as class System.IO.FileStream no-undo.
    def var oReport as class Telerik.Reporting.Report no-undo.
    def var oCsvDataSource as Telerik.Reporting.CsvDataSource no-undo.
    def var oJsonDataSource as Telerik.Reporting.JsonDataSource no-undo.
    def var oInstanceReportSource as Telerik.Reporting.InstanceReportSource no-undo.
    
  CONSTRUCTOR PUBLIC JBoxTelerikReportView (INPUT ihWinSuper    AS HANDLE, /* Window super proc - unknown if object created from window */
                                     INPUT ihWinProc     AS HANDLE,
                                     INPUT ihPlaceHolder AS HANDLE, /* Design widget (rectangle, field, etc) */
                                     INPUT iiDeltaWidth  AS INTEGER):
     SUPER(ihWinSuper,ihWinProc,ihPlaceHolder,iiDeltaWidth).
   
  END CONSTRUCTOR.
  
  
  CONSTRUCTOR PUBLIC JBoxTelerikReportView (INPUT ihWinProc     AS HANDLE,
                                     INPUT ihPlaceHolder AS HANDLE ): /* Design widget (rectangle, field, etc) */
                                   
     SUPER(?,ihWinProc,ihPlaceHolder,0).
   
  END CONSTRUCTOR.


		METHOD PUBLIC OVERRIDE VOID InitializeComponent():

/*        THIS-OBJECT:components = NEW System.ComponentModel.Container().*/
   /* NOTE: The following method is automatically generated.
    
    We strongly suggest that the contents of this method only be modified using the
    Visual Designer to avoid any incompatible modifications.
    
    Modifying the contents of this method using a code editor will invalidate any support for this file. */
    THIS-OBJECT:oReportViewer = NEW Telerik.ReportViewer.WinForms.ReportViewer().
    THIS-OBJECT:SuspendLayout().
    /*  */
    /* oReportViewer */
    /*  */
    THIS-OBJECT:oReportViewer:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:oReportViewer:Location = NEW System.Drawing.Point(0, 0).
    THIS-OBJECT:oReportViewer:Name = "reportViewer1".
    THIS-OBJECT:oReportViewer:Size = NEW System.Drawing.Size(551, 460).
    THIS-OBJECT:oReportViewer:TabIndex = 0.
    this-object:oReportViewer:AutoSize = true.
    /*  */

    THIS-OBJECT:ClientSize = NEW System.Drawing.Size(551, 460).    
    THIS-OBJECT:Controls:Add(THIS-OBJECT:oReportViewer).
    THIS-OBJECT:Name = "myReport".
    THIS-OBJECT:Text = "myReport".    
    THIS-OBJECT:ResumeLayout(FALSE).

    SUPER:InitializeComponent().
    
    THIS-OBJECT:ComponentsCollection:ADD(THIS-OBJECT:components).
    CATCH e AS Progress.Lang.Error:
      UNDO, THROW e.
    END CATCH.

  END METHOD.

/* Mandatory methods: */
  METHOD PUBLIC Telerik.ReportViewer.WinForms.ReportViewer getDotNetWidget():
    RETURN oReportViewer.
  END METHOD.

  METHOD PUBLIC CHARACTER getDotNetWidgetType():
    RETURN STRING(oReportViewer:GetType()).
  END METHOD.

  METHOD PUBLIC CHARACTER DEFAULT():
    RETURN DYNAMIC-INVOKE(THIS-OBJECT,ENTRY(1,PROGRAM-NAME(2)," ")).
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID loadReportFromFile(ipReportFile as char, ipDataFile as char):
    def var oReportFile as System.IO.FileInfo no-undo.
    def var oDataFile   as System.IO.FileInfo no-undo.
    def var ReportData  as longchar no-undo.
    
    fix-codepage(ReportData) = 'UTF-8'.
    
    assign 
      oReportFile = new System.IO.FileInfo(ipReportFile)
      oDataFile   = new System.IO.FileInfo(ipDataFile)
      .
    if not oReportFile:Exists then 
      undo, throw new Progress.Lang.AppError('Rapporten: ' + ipReportFile + ' ble ikke funnet.',0).
    
    if not oDataFile:Exists then 
      undo, throw new Progress.Lang.AppError('Datauttrekket: ' + ipDataFile + ' ble ikke funnet.',0).

    oReportPacker = new Telerik.Reporting.ReportPackager().
    oReportStream = System.IO.File:OpenRead(oReportFile:FullName).   

    oReport = cast(oReportPacker:UnpackageDocument(oReportStream),Telerik.Reporting.Report).
    
    case oDataFile:Extension:
      when '.Json' then do:
        copy-lob from file oDataFile:FullName to ReportData NO-CONVERT.
        oJsonDataSource = cast(oReport:DataSource,Telerik.Reporting.JsonDataSource).
        oJsonDataSource:Source = ReportData.
      end.
      when '.csv' then do:
        oDataStream   = System.IO.File:OpenRead(oDataFile:FullName).   
        oCsvDataSource = cast(oReport:DataSource,Telerik.Reporting.CsvDataSource).
        oCsvDataSource:Source = oDataStream.
      end.
      otherwise do:
        undo, throw new Progress.Lang.AppError('Externsion ikke støttet:' + oDataFile:Extension,0).
      end.
    end case.
    
    oInstanceReportSource                = new Telerik.Reporting.InstanceReportSource().
    oInstanceReportSource:ReportDocument = oReport.
    oReportViewer:ReportSource           = oInstanceReportSource. 

    oReportViewer:refreshreport().
    if valid-object(oReportFile) then oReportStream:Close() no-error.
    if valid-object(oDataStream) then oDataStream:Close() no-error. 
    RETURN.

  END METHOD.

/*	/*------------------------------------------------------------------------------                                                                  */
/*	 Purpose:                                                                                                                                         */
/*	 Notes:                                                                                                                                           */
/*	------------------------------------------------------------------------------*/                                                                  */
/*                                                                                                                                                   */
/*	METHOD PUBLIC VOID loadReportFromFile(ipReportFilename as char, ipDataFile as char):                                                              */
/*	  def var oReportFile as System.IO.FileInfo no-undo.                                                                                              */
/*	  def var dsh as handle no-undo.                                                                                                                  */
/*	  def var oXML as class Chilkat.Xml no-undo.                                                                                                      */
/*    def var oXMLSource as class Chilkat.Xml no-undo.                                                                                               */
/*    def var ix as int no-undo.                                                                                                                     */
/*    def var cTest as char no-undo.                                                                                                                 */
/*    def var xSearchRoot as class ChilKat.Xml no-undo.                                                                                              */
/*    def var xBeginAfter as class Chilkat.Xml no-undo.                                                                                              */
/*    def var xSearch     as class Chilkat.Xml no-undo.                                                                                              */
/*    def var xUri as class Chilkat.Xml no-undo.                                                                                                     */
/*    def var Success as log no-undo.                                                                                                                */
/*    	                                                                                                                                                   */
/*	  assign                                                                                                                                          */
/*	    oReportFile = new System.IO.FileInfo(ipReportFilename)                                                                                        */
/*	    ipDatafile  = if index(ipDatafile,'.json') gt 0 or index(ipDatafile,'.csv') gt 0 then 'file:///' + replace(ipDatafile,'\','/') else ipDataFile*/
/*	    .                                                                                                                                             */
/*                                                                                                                                                   */
/*    if not oReportFile:Exists then                                                                                                                 */
/*      undo, throw new Progress.Lang.AppError('Rapporten: ' + ipReportFilename + ' ble ikke funnet.',0).                                            */
/*                                                                                                                                                   */
/*    oXML = new Chilkat.Xml().                                                                                                                      */
/*    oXml:EmitBom = true.                                                                                                                           */
/*    oXML:LoadXmlFile(oReportFile:FullName).                                                                                                        */
/*                                                                                                                                                   */
/*    xSearchRoot = oXML:FindChild('DataSources').                                                                                                   */
/*    xBeginAfter = xSearchRoot:GetSelf().                                                                                                           */
/*    xSearch     = xSearchRoot:GetSelf().                                                                                                           */
/*    success = xSearch:Searchfortag2(xBeginAfter,'Uri').                                                                                            */
/*    if success then                                                                                                                                */
/*      xSearch:UpdateAttribute('Path',ipDataFile).                                                                                                  */
/*                                                                                                                                                   */
/*    xSearchRoot = oXML:FindChild('DataSources').                                                                                                   */
/*    xBeginAfter = xSearchRoot:GetSelf().                                                                                                           */
/*    xSearch     = xSearchRoot:GetSelf().                                                                                                           */
/*    success = xSearchRoot:Searchfortag2(xBeginAfter,'CsvDataSource').                                                                              */
/*                                                                                                                                                   */
/*    if success then                                                                                                                                */
/*      xSearch:UpdateAttribute('RecordSeparators',"&#xD;&#xA;").                                                                                    */
/*                                                                                                                                                   */
/*    oXML:SaveXml(oReportFile:FullName).                                                                                                            */
/*    oXML:LoadXmlFile(oReportFile:FullName).                                                                                                        */
/*                                                                                                                                                   */
/*/*    xSearchRoot = oXML:FindChild('DataSources').                     */                                                                          */
/*/*    xBeginAfter = xSearchRoot:GetSelf().                             */                                                                          */
/*/*    success = xSearchRoot:Searchfortag2(xBeginAfter,'CsvDataSource').*/                                                                          */
/*                                                                                                                                                   */
/*/*                                                                         */                                                                      */
/*/*    do while Success:                                                    */                                                                      */
/*/*     xBeginAfter:CopyRef(xSearch).                                       */                                                                      */
/*/*     xSearch:CopyRef(xSearchRoot).                                       */                                                                      */
/*/*     success = xSearch:SearchForTag2(xBeginAfter,'Uri').                 */                                                                      */
/*/*    end.                                                                 */                                                                      */
/*/*    xSearch:GetSelf().                                                   */                                                                      */
/*/*    MESSAGE xSearch:Content skip xSearch:Tag xSearch:GetAttrValue('Path')*/                                                                      */
/*/*    VIEW-AS ALERT-BOX.                                                   */                                                                      */
/*/*    oXMLSource = oXML:GetChildWithTag('Sources').                                                                     */                         */
/*/*    if not oXMLDataSource:LastMethodSuccess then undo, throw new Progress.Lang.AppError('Fant ikke XML tag: "Uri"',0).*/                         */
/*/*    else                                                                                                              */                         */
/*/*    MESSAGE oXMLDataSource:Tag oXMLDataSource:Content                                                                 */                         */
/*/*    VIEW-AS ALERT-BOX.                                                                                                */                         */
/*                                                                                                                                                   */
/*    oUriReportSource = new Telerik.Reporting.UriReportSource().                                                                                    */
/*    oUriReportSource:Uri = oReportFile:FullName.                                                                                                   */
/*    oReportViewer:ReportSource = oUriReportSource.                                                                                                 */
/*                                                                                                                                                   */
/*    oReportViewer:refreshreport().                                                                                                                 */
/*	                                                                                                                                                   */
/*		RETURN.                                                                                                                                          */
/*                                                                                                                                                   */
/*	END METHOD.                                                                                                                                       */

  DESTRUCTOR PUBLIC JBoxTelerikReportView ( ):
    
    IF VALID-OBJECT(components) THEN 
    DO:
      CAST(components, System.IDisposable):Dispose().
    END.

  END DESTRUCTOR.

END CLASS.
