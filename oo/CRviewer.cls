 
 /*------------------------------------------------------------------------
    File        : CRviewer
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : goo
    Created     : Fri Jan 12 11:07:44 CET 2024
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS oo.CRviewer INHERITS Progress.Windows.UserControl   : 
  DEFINE TEMP-TABLE ttCR NO-UNDO
    FIELD cLoadFile AS CHARACTER 
    FIELD oCRobject AS CLASS     Progress.Lang.Object
    INDEX cLoadFile IS PRIMARY cLoadFile.
 
  DEFINE PRIVATE VARIABLE components           AS CLASS     System.ComponentModel.IContainer no-undo.
  DEFINE PRIVATE VARIABLE crystalReportViewer1 AS CLASS     CrystalDecisions.Windows.Forms.CrystalReportViewer    NO-UNDO.
  DEFINE public  VARIABLE crwReport            AS CLASS     CrystalDecisions.CrystalReports.Engine.ReportDocument NO-UNDO.

  DEFINE         VARIABLE ReportFile           AS CHARACTER NO-UNDO.

  def var oConnectionInfo as CrystalDecisions.Shared.ConnectionInfo no-undo.
  def var oTableLogonInfo as CrystalDecisions.Shared.TableLogOnInfo no-undo.

  DEFINE PUBLIC  VARIABLE PageOrientation      AS CHARACTER NO-UNDO.
  DEFINE PUBLIC  VARIABLE TempPath             AS CHARACTER NO-UNDO.
          
  CONSTRUCTOR PUBLIC CRviewer (  ):
 
    SUPER().
    InitializeComponent().
    CATCH e AS Progress.Lang.Error:
      UNDO, THROW e.
    END CATCH.
 
  END CONSTRUCTOR.
   
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  
      oPFDs = crwReport:DataDefinition:ParameterFields.
    oEnum = CAST(oPFDs, System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset() .
    DO WHILE oEnum:MoveNext() ON ERROR UNDO, THROW:
      i = i + 1.
      if i gt extent(ipParam) then leave. 
      ASSIGN 
        oPFD = CAST(oEnum:Current,"CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition") .
        oPVs  = oPFD:CurrentValues.
        oDV:Value = ipParam[i].
        oPVs:Clear().
        oPVs:Add(oDV).
        oPFD:ApplyCurrentValues(oPVs).
    END.   
  
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID ConnectInfo(input ipServername as char, input ipDatabasename as char, input ipUserid as char, input ipPassword as char):
    DEFINE         VARIABLE oTables           AS CLASS     CrystalDecisions.CrystalReports.Engine.Tables NO-UNDO.
    DEFINE         VARIABLE oTable            AS CLASS     CrystalDecisions.CrystalReports.Engine.Table NO-UNDO.
    def var oEnum as class System.Collections.IEnumerator no-undo.
    def var ix as int no-undo.
    
    oConnectionInfo = new CrystalDecisions.Shared.ConnectionInfo().
    oConnectionInfo:ServerName   = ipServername.
    oConnectionInfo:DatabaseName = ipDatabasename.
    oConnectionInfo:UserID       = ipUserid.
    if ipPassword <> '' and ipPassword <> ? then oConnectionInfo:Password     = ipPassword.
    oTableLogonInfo = new CrystalDecisions.Shared.TableLogOnInfo().
    oTables = crwReport:Database:Tables.
    
    oEnum = cast(oTables,System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset().
    do while oEnum:MoveNext() on error undo, throw:
      oTable = cast(oEnum:Current,CrystalDecisions.CrystalReports.Engine.Table).
      oTableLogonInfo = oTable:LogOnInfo.
      oTableLogonInfo:ConnectionInfo = oConnectionInfo.
      oTable:ApplyLogOnInfo(oTableLogonInfo).  
    end. 
  END METHOD.

  METHOD PRIVATE VOID InitializeComponent(  ):
    THIS-OBJECT:crystalReportViewer1 = NEW CrystalDecisions.Windows.Forms.CrystalReportViewer().           
    /*        THIS-OBJECT:SuspendLayout().*/
      
/*    RapportPath = getSysReg(25) + '\CR\'.*/
    /*    DSN = "DRIVER=" + ODBC               */
    /*      + ";Server=" + getSysReg(82)       */
    /*      + ";DB=" + getSysReg(84)           */
    /*      + ";UID=" + getSysReg(85)          */
    /*      .                                  */
    
    /*  */
    /* crystalReportViewer1 */
    /*  */
    THIS-OBJECT:crystalReportViewer1:ActiveViewIndex = -1.
    THIS-OBJECT:crystalReportViewer1:BorderStyle = System.Windows.Forms.BorderStyle:FixedSingle.
    THIS-OBJECT:crystalReportViewer1:Dock = System.Windows.Forms.DockStyle:Fill.
    THIS-OBJECT:crystalReportViewer1:Location = NEW System.Drawing.Point(0, 0).
    THIS-OBJECT:crystalReportViewer1:Name = "crystalReportViewer1".
    THIS-OBJECT:crystalReportViewer1:SelectionFormula = "".
    THIS-OBJECT:crystalReportViewer1:Size = NEW  System.Drawing.Size(20, 20).
    THIS-OBJECT:crystalReportViewer1:TabIndex = 0.
    THIS-OBJECT:crystalReportViewer1:ViewTimeSelectionFormula = "".         
    THIS-OBJECT:crystalReportViewer1:ToolPanelView = CrystalDecisions.Windows.Forms.ToolPanelViewType:NONE.
    /*  */
    /* ReportViewer */
    /*  */
    /* THIS-OBJECT:AutoScaleDimensions = NEW System.Drawing.SizeF(6, 13). */
    THIS-OBJECT:AutoSize = TRUE.        
    THIS-OBJECT:BackColor = System.Drawing.SystemColors:Desktop.        
    THIS-OBJECT:Controls:Add(THIS-OBJECT:crystalReportViewer1).        
    THIS-OBJECT:Name = "ReportViewer".
    THIS-OBJECT:Size = NEW System.Drawing.Size(30, 30).
    THIS-OBJECT:ResumeLayout(FALSE).
    CATCH e AS Progress.Lang.Error:
      UNDO, THROW e.
    END CATCH.
  END METHOD. 

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC LOGICAL LoadReport( INPUT ipReportFile AS CHARACTER):
    DEFINE VARIABLE myFOpts AS INTEGER.
    
    FILE-INFO:FILE-NAME = ipReportFile.
    IF FILE-INFO:FILE-SIZE = ? THEN DO:
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':Rapportfilen er tom eller finnes ikke: ' + ipReportFile + ', avslutter','ERROR').
      RETURN FALSE.
    END.
    
    FIND FIRST ttCR WHERE ttCR.cLoadFile = ipReportFile NO-ERROR.
    IF NOT AVAILABLE ttCR THEN DO:
      CREATE ttCR.
      ASSIGN 
        ttCR.cLoadFile = ipReportFile
        .

      crwReport = NEW CrystalDecisions.CrystalReports.Engine.ReportDocument(). 
      crwReport:Load(ipReportFile).
      myFOpts =
  /*         INTEGER(CrystalDecisions.Shared.ViewerExportFormats:RptFormat:value__) +  */
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:PdfFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:XLSXFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:ExcelFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:ExcelRecordFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:RptrFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:CsvFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:EditableRtfFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:RtfFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:WordFormat:value__) +
        INTEGER(CrystalDecisions.Shared.ViewerExportFormats:XmlFormat:value__) +
        /*         INTEGER(CrystalDecisions.Shared.ViewerExportFormats:AllFormats:value__) +*/
        0. 
      crystalReportViewer1:AllowedExportFormats = myFOpts.
      PageOrientation = STRING(crwReport:PrintOptions:PaperOrientation).              
      ttCR.oCRobject = CAST(crwReport,Progress.Lang.Object).
    END.
    ELSE 
      crwReport = CAST(ttCR.oCRobject,CrystalDecisions.CrystalReports.Engine.ReportDocument).
        
    RETURN TRUE.
  
    CATCH eCRLoad AS CrystalDecisions.CrystalReports.Engine.LoadSaveReportException:
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':Feilet med rapportfil: ' + ReportFile + ' :' + eCRLoad:GetMessage(1),'ERROR').
      RETURN FALSE.
    END CATCH.

    CATCH eCRLoad2 AS System.Runtime.InteropServices.COMException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':Feilet med rapportfil: ' + ReportFile + ' :' + eCRLoad2:GetMessage(1),'ERROR').
      RETURN FALSE.
    END CATCH.

    CATCH eCRLoad3 AS CrystalDecisions.CrystalReports.Engine.LogOnException:
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':Feilet med rapportfil: ' + ReportFile + ' :' + eCRLoad3:GetMessage(1),'ERROR').
      RETURN FALSE.
    END CATCH.
    
    CATCH eCR AS CrystalDecisions.CrystalReports.Engine.FormulaException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':Feilet med rapportfil: ' + ipReportFile + ' :' + eCR:GetMessage(1),'ERROR').
      RETURN FALSE.
    END CATCH.
  END METHOD.
    
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID PrintReport(INPUT PDFFileName AS CHARACTER):
       
    crystalReportViewer1:ReportSource = THIS-OBJECT:crwReport.
    /*        crystalReportViewer1:RefreshReport().*/
    crystalReportViewer1:Refresh().

    /*        crwReport = NEW CrystalDecisions.CrystalReports.Engine.ReportDocument().*/
    /*    crwReport:Load(ttCR.cLoadFile).*/
        
    crwReport:ExportToDisk(CrystalDecisions.Shared.ExportFormatType:PortableDocFormat,  PDFFileName).
      
    RETURN.
    
    CATCH eCRPrint AS CrystalDecisions.CrystalReports.Engine.InternalException:
      def var ix as int no-undo.
      do ix = 1 to eCRPrint:NumMessages:
        LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':' + ttCR.cLoadFile + ' :' + eCRPrint:GetMessage(ix),'ERROR').
      end.
    END CATCH.
    
    CATCH eCRLoad AS CrystalDecisions.CrystalReports.Engine.LoadSaveReportException:
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':Load/Save:' + ttCR.cLoadFile + ' :' + eCRLoad:GetMessage(1),'ERROR').
    END CATCH.

    CATCH eSystem AS System.ArgumentException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':PrintFile:' + PDFFileName + ' :' + eSystem:GetMessage(1),'ERROR').
    END CATCH.

    CATCH eCR AS CrystalDecisions.CrystalReports.Engine.FormulaException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':PrintFile:' + PDFFileName + ' :' + eCR:GetMessage(1),'ERROR').
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setParameter(input ipParam as int extent):
    DEFINE VARIABLE i     AS INTEGER NO-UNDO.
    DEFINE VARIABLE oPFDs AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinitions NO-UNDO.
    DEFINE VARIABLE oPFD  AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition  NO-UNDO.
    DEFINE VARIABLE oPVs  AS CLASS   CrystalDecisions.Shared.ParameterValues                          NO-UNDO.
    DEFINE VARIABLE oPV   AS CLASS   CrystalDecisions.Shared.ParameterValue                           NO-UNDO.
    DEFINE VARIABLE oDV   AS CLASS   CrystalDecisions.Shared.ParameterDiscreteValue                   NO-UNDO.
    
    DEFINE VARIABLE oPFs  AS CLASS   CrystalDecisions.Shared.ParameterFields                          NO-UNDO.  
    DEFINE VARIABLE oPF   AS CLASS   CrystalDecisions.Shared.ParameterField                           NO-UNDO.   

    DEFINE VARIABLE oEnum AS CLASS   System.Collections.IEnumerator                                   NO-UNDO.

    i = 0.
    
    oPVs = NEW CrystalDecisions.Shared.ParameterValues().
    oDV = NEW CrystalDecisions.Shared.ParameterDiscreteValue().

    oPFDs = crwReport:DataDefinition:ParameterFields.
    oEnum = CAST(oPFDs, System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset() .
    DO WHILE oEnum:MoveNext() ON ERROR UNDO, THROW:
      i = i + 1.
      if i gt extent(ipParam) then leave. 
      ASSIGN 
        oPFD = CAST(oEnum:Current,"CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition") .
        oPVs  = oPFD:CurrentValues.
        oDV:Value = ipParam[i].
        oPVs:Clear().
        oPVs:Add(oDV).
        oPFD:ApplyCurrentValues(oPVs).
    END.   
  end method.
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
    /*    case oPFD:ValueType:ToString():                                        */
    /*      when 'numberfield'   then oDV:Value = int(ipValue).                  */
    /*      when 'stringfield'   then oDV:Value = ipValue.                       */
    /*      when 'booleanfield'  then oDV:Value = logical(ipValue).              */
    /*      when 'datefield'     then oDV:Value = date(ipValue).                 */
    /*      when 'datetimefield' then oDV:Value = datetime(ipValue).             */
    /*      when 'currencyfield' then oDV:Value = DECIMAL(ipValue).              */
    /*      otherwise do:                                                        */
    /*        MESSAGE 'Feil type:' + oPFD:ValueType:ToString() ', ikke definert '*/
    /*        VIEW-AS ALERT-BOX.                                                 */
    /*        return.                                                            */
    /*      end.                                                                 */
    /*    end case.                                                              */
+  IF h-FlereParam = TRUE THEN DO:
+    chReport:ParameterFields:ITEM(2):ClearCurrentValueAndRange() NO-ERROR.
+    chReport:ParameterFields:ITEM(3):ClearCurrentValueAndRange() NO-ERROR.
+  END.
+  
+  /* Sets new value of parameter */
+  chReport:ParameterFields:ITEM(1):SetCurrentValue(h-jobbnr) NO-ERROR.
+
+  IF h-FlereParam = TRUE THEN DO:
+    /* 15.05.07. EL. Vis alle fakturaene i jobben */
+    chReport:ParameterFields:ITEM(2):SetCurrentValue(-99999999) NO-ERROR. /* 15.11.11. Var 0, men satt til minus pga "Tilbud" og arkivering */     
+    chReport:ParameterFields:ITEM(3):SetCurrentValue(99999999) NO-ERROR.
+  END.

  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setParameter(INPUT ipName AS CHARACTER, INPUT ipValue AS CHARACTER ):
    DEFINE VARIABLE i     AS INTEGER NO-UNDO.
    DEFINE VARIABLE oPFDs AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinitions NO-UNDO.
    DEFINE VARIABLE oPFD  AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition  NO-UNDO.
    DEFINE VARIABLE oPVs  AS CLASS   CrystalDecisions.Shared.ParameterValues                          NO-UNDO.
    DEFINE VARIABLE oPV   AS CLASS   CrystalDecisions.Shared.ParameterValue                           NO-UNDO.
    DEFINE VARIABLE oDV   AS CLASS   CrystalDecisions.Shared.ParameterDiscreteValue                   NO-UNDO.
    
    DEFINE VARIABLE oPFs  AS CLASS   CrystalDecisions.Shared.ParameterFields                          NO-UNDO.  
    DEFINE VARIABLE oPF   AS CLASS   CrystalDecisions.Shared.ParameterField                           NO-UNDO.   

    DEFINE VARIABLE oEnum AS CLASS   System.Collections.IEnumerator                                   NO-UNDO.
    
    oPVs = NEW CrystalDecisions.Shared.ParameterValues().
    oDV = NEW CrystalDecisions.Shared.ParameterDiscreteValue().

    oPFDs = crwReport:DataDefinition:ParameterFields.
    
    oEnum = CAST(oPFDs, System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset() .
    
    DO WHILE oEnum:MoveNext() ON ERROR UNDO, THROW:
      ASSIGN 
        oPFD = CAST(oEnum:Current,"CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition") .
      IF ipName = oPFD:Name THEN 
      DO:
/*        MESSAGE 'CHAR: name:' ipName*/
/*          VIEW-AS ALERT-BOX.        */
        oPVs  = oPFD:CurrentValues.
        oDV:Value = ipValue.
        oPVs:Clear().
        oPVs:Add(oDV).
        oPFD:ApplyCurrentValues(oPVs).
      END.
    END.   

    CATCH eAny1 AS System.Runtime.InteropServices.COMException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eAny1:GetMessage(1),'ERROR').
    END CATCH.

    CATCH eCR AS CrystalDecisions.CrystalReports.Engine.FormulaException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eCR:GetMessage(1),'ERROR').
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setParameter(INPUT ipName AS CHARACTER, INPUT ipValue AS INTEGER ):
    DEFINE VARIABLE i     AS INTEGER NO-UNDO.
    DEFINE VARIABLE oPFDs AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinitions NO-UNDO.
    DEFINE VARIABLE oPFD  AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition  NO-UNDO.
    DEFINE VARIABLE oPVs  AS CLASS   CrystalDecisions.Shared.ParameterValues                          NO-UNDO.
    DEFINE VARIABLE oPV   AS CLASS   CrystalDecisions.Shared.ParameterValue                           NO-UNDO.
    DEFINE VARIABLE oDV   AS CLASS   CrystalDecisions.Shared.ParameterDiscreteValue                   NO-UNDO.
    
    DEFINE VARIABLE oPFs  AS CLASS   CrystalDecisions.Shared.ParameterFields                          NO-UNDO.  
    DEFINE VARIABLE oPF   AS CLASS   CrystalDecisions.Shared.ParameterField                           NO-UNDO.   

    
    DEFINE VARIABLE oEnum AS CLASS   System.Collections.IEnumerator                                   NO-UNDO.
    
    oPVs = NEW CrystalDecisions.Shared.ParameterValues().
    oDV = NEW CrystalDecisions.Shared.ParameterDiscreteValue().

    oPFDs = crwReport:DataDefinition:ParameterFields.
    
    oEnum = CAST(oPFDs, System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset() .
    
    DO WHILE oEnum:MoveNext() ON ERROR UNDO, THROW:
      ASSIGN 
        oPFD = CAST(oEnum:Current,"CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition") .
      IF ipName = oPFD:Name THEN 
      DO:
/*        MESSAGE 'INT: name:' ipName*/
/*          VIEW-AS ALERT-BOX.       */
        oPVs  = oPFD:CurrentValues.
        oDV:Value = ipValue.
        oPVs:Clear().
        oPVs:Add(oDV).
        oPFD:ApplyCurrentValues(oPVs).
      END.
    END.   

    CATCH eAny1 AS System.Runtime.InteropServices.COMException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eAny1:GetMessage(1),'ERROR').
    END CATCH.

    CATCH eCR AS CrystalDecisions.CrystalReports.Engine.FormulaException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eCR:GetMessage(1),'ERROR').
    END CATCH.
       
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setParameter(INPUT ipName AS CHARACTER, INPUT ipValue AS DATETIME ):
    DEFINE VARIABLE i     AS INTEGER NO-UNDO.
    DEFINE VARIABLE oPFDs AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinitions NO-UNDO.
    DEFINE VARIABLE oPFD  AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition  NO-UNDO.
    DEFINE VARIABLE oPVs  AS CLASS   CrystalDecisions.Shared.ParameterValues                          NO-UNDO.
    DEFINE VARIABLE oPV   AS CLASS   CrystalDecisions.Shared.ParameterValue                           NO-UNDO.
    DEFINE VARIABLE oDV   AS CLASS   CrystalDecisions.Shared.ParameterDiscreteValue                   NO-UNDO.
    
    DEFINE VARIABLE oPFs  AS CLASS   CrystalDecisions.Shared.ParameterFields                          NO-UNDO.  
    DEFINE VARIABLE oPF   AS CLASS   CrystalDecisions.Shared.ParameterField                           NO-UNDO.   

    
    DEFINE VARIABLE oEnum AS CLASS   System.Collections.IEnumerator                                   NO-UNDO.
    
    oPVs = NEW CrystalDecisions.Shared.ParameterValues().
    oDV = NEW CrystalDecisions.Shared.ParameterDiscreteValue().

    oPFDs = crwReport:DataDefinition:ParameterFields.
    
    oEnum = CAST(oPFDs, System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset() .
    
    DO WHILE oEnum:MoveNext() ON ERROR UNDO, THROW:
      ASSIGN 
        oPFD = CAST(oEnum:Current,"CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition") .
      IF ipName = oPFD:Name THEN 
      DO:
/*        MESSAGE 'DATETIME: name:' ipName*/
/*          VIEW-AS ALERT-BOX.            */
        oPVs  = oPFD:CurrentValues.
        oDV:Value = ipValue.
        oPVs:Clear().
        oPVs:Add(oDV).
        oPFD:ApplyCurrentValues(oPVs).
      END.
    END.   

    CATCH eAny1 AS System.Runtime.InteropServices.COMException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eAny1:GetMessage(1),'ERROR').
    END CATCH.

    CATCH eCR AS CrystalDecisions.CrystalReports.Engine.FormulaException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eCR:GetMessage(1),'ERROR').
    END CATCH.
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC VOID setParameter(INPUT ipName AS CHARACTER, INPUT ipValue AS DATE ):
    DEFINE VARIABLE i     AS INTEGER NO-UNDO.
    DEFINE VARIABLE oPFDs AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinitions NO-UNDO.
    DEFINE VARIABLE oPFD  AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition  NO-UNDO.
    DEFINE VARIABLE oPVs  AS CLASS   CrystalDecisions.Shared.ParameterValues                          NO-UNDO.
    DEFINE VARIABLE oPV   AS CLASS   CrystalDecisions.Shared.ParameterValue                           NO-UNDO.
    DEFINE VARIABLE oDV   AS CLASS   CrystalDecisions.Shared.ParameterDiscreteValue                   NO-UNDO.
    
    DEFINE VARIABLE oPFs  AS CLASS   CrystalDecisions.Shared.ParameterFields                          NO-UNDO.  
    DEFINE VARIABLE oPF   AS CLASS   CrystalDecisions.Shared.ParameterField                           NO-UNDO.   

    DEFINE VARIABLE oEnum AS CLASS   System.Collections.IEnumerator                                   NO-UNDO.
    
    oPVs = NEW CrystalDecisions.Shared.ParameterValues().
    oDV  = NEW CrystalDecisions.Shared.ParameterDiscreteValue().

    oPFDs = crwReport:DataDefinition:ParameterFields.
    
    oEnum = CAST(oPFDs, System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset() .
    
    DO WHILE oEnum:MoveNext() ON ERROR UNDO, THROW:
      ASSIGN 
        oPFD = CAST(oEnum:Current,"CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition") .
      IF ipName = oPFD:Name THEN 
      DO:
/*        MESSAGE 'DATE: name:' ipName*/
/*          VIEW-AS ALERT-BOX.        */
        oPVs  = oPFD:CurrentValues.
        oDV:Value = ipValue.
        oPVs:Clear().
        oPVs:Add(oDV).
        oPFD:ApplyCurrentValues(oPVs).
      END.
    END.   

    CATCH eAny1 AS System.Runtime.InteropServices.COMException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eAny1:GetMessage(1),'ERROR').
    END CATCH.

    CATCH eCR AS CrystalDecisions.CrystalReports.Engine.FormulaException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eCR:GetMessage(1),'ERROR').
    END CATCH.
       
  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/

  METHOD PUBLIC character getParameter(INPUT ipName AS CHARACTER):
    DEFINE VARIABLE i     AS INTEGER NO-UNDO.
    DEFINE VARIABLE oPFDs AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinitions NO-UNDO.
    DEFINE VARIABLE oPFD  AS CLASS   CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition  NO-UNDO.
    DEFINE VARIABLE oPVs  AS CLASS   CrystalDecisions.Shared.ParameterValues                          NO-UNDO.
    DEFINE VARIABLE oPV   AS CLASS   CrystalDecisions.Shared.ParameterValue                           NO-UNDO.
    DEFINE VARIABLE oDV   AS CLASS   CrystalDecisions.Shared.ParameterDiscreteValue                   NO-UNDO.
    
    DEFINE VARIABLE oPFs  AS CLASS   CrystalDecisions.Shared.ParameterFields                          NO-UNDO.  
    DEFINE VARIABLE oPF   AS CLASS   CrystalDecisions.Shared.ParameterField                           NO-UNDO.   

    
    DEFINE VARIABLE oEnum AS CLASS   System.Collections.IEnumerator                                   NO-UNDO.
    def var cReturn as char no-undo.
    
    oPVs = NEW CrystalDecisions.Shared.ParameterValues().
    oDV = NEW CrystalDecisions.Shared.ParameterDiscreteValue().

    oPFDs = crwReport:DataDefinition:ParameterFields.
    
    oEnum = CAST(oPFDs, System.Collections.IEnumerable):GetEnumerator().
    oEnum:Reset() .
    
    DO WHILE oEnum:MoveNext() ON ERROR UNDO, THROW:
      ASSIGN 
        oPFD = CAST(oEnum:Current,"CrystalDecisions.CrystalReports.Engine.ParameterFieldDefinition") .
      IF ipName = oPFD:Name THEN 
      DO:
/*        MESSAGE 'INT: name:' ipName*/
/*          VIEW-AS ALERT-BOX.       */
        oPVs  = oPFD:CurrentValues.
        
/*        oDV:Value = ipValue.          */
/*        oPVs:Clear().                 */
/*        oPVs:Add(oDV).                */
/*        oPFD:ApplyCurrentValues(oPVs).*/
      END.
    END.   
    return cReturn.

    CATCH eAny1 AS System.Runtime.InteropServices.COMException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eAny1:GetMessage(1),'ERROR').
    END CATCH.

    CATCH eCR AS CrystalDecisions.CrystalReports.Engine.FormulaException :
      LOG-MANAGER:WRITE-MESSAGE (PROGRAM-NAME(1) + ':parameternavn:' + ipName + eCR:GetMessage(1),'ERROR').
    END CATCH.
       
  END METHOD.
 
  DESTRUCTOR PUBLIC CRviewer ( ):
    empty temp-table ttCR.
        
    if valid-object(crwReport) then do:
      crwReport:Close().
    end.

  END DESTRUCTOR.
 
END CLASS.
