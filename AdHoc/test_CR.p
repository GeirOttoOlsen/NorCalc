
/*------------------------------------------------------------------------
    File        : test_CR.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Fri Jan 12 11:23:00 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var ipReportFile as char no-undo.
def var ipXmlFile as char no-undo.
def var oCmd as jboxCmd no-undo.
def var filnavn as char no-undo.
/*def var crwReport as class CrystalDecisions.CrystalReports.Engine.ReportDocument no-undo.*/
/*def var oDataSet as class System.Data.DataSet no-undo.                                   */
/*                                                                                         */
  assign 
    ipReportFile = 'e:\temp\rapport.rpt'
    filnavn = 'e:\temp\slettes.pdf'
    .
/*  ipReportFile = "C:\Users\goo\OneDrive\Desktop\norcalc_sql.rpt".*/
/*  crwReport = NEW CrystalDecisions.CrystalReports.Engine.ReportDocument().               */
/*  crwReport:Load(ipReportFile).                                                          */
/*                                                                                         */
/*  oDataSet = new System.Data.DataSet().                                                  */
/*  oDataSet:ReadXml(ipXmlFile).                                                           */
/*  crwReport:SetDataSource(oDataSet).                                                     */
/*                                                                                         */


def var oCRview as oo.CRviewer no-undo.

oCRview = new oo.CRviewer().

oCRview:LoadReport(ipReportFile).
oCRview:PrintReport(Filnavn).

oCmd = new JBoxCMD(filnavn).