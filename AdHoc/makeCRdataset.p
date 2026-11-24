
/*------------------------------------------------------------------------
    File        : makeCRdataset.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Wed Jan 24 16:41:08 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
def var ods as oo.datasetHelper no-undo.

def var oCmd as JBoxCMD no-undo.
def var filskjema as char no-undo.
def var filXML as char no-undo.
def var oParam as oo.parameter no-undo.

assign
  oParam    = new oo.parameter()
  filskjema = 'e:\temp\rapport.xsd'
  filXML    = 'e:\temp\rapport.xml'
  .

oDS = new oo.datasetHelper().
oDS:addTable('norcalc','norprosjekt').
oDS:addTable('norcalc','npshanlg').
oDS:addTable('norcalc','npkunde').
oDS:addTable('norcalc','npkundedistrikt').
oDS:addTable('norcalc','npshTilbud').


oDS:addRelation('norprosjekt','npshanlg','prosjektid,prosjektid').
oDS:addRelation('npshanlg','npkunde','kundenr,kundenr').
oDS:addRelation('npshanlg','npkundedistrikt','kundedistriktnr,kundedistriktnr').
oDS:addRelation('npshanlg','npshtilbud','anleggsnr,anleggsnr').
oDS:addRelation('npshanlg','npshtilbud','anleggsnr,anleggsnr').
oDS:buildDataset().

oParam:addParameter('ReportName','norprosjekt01').
oParam:addParameter('ProsjektId',string(3)).

jboxserverapi:Instance:DatasetReplace = false.
if not jboxserverapi:Instance:CallServerProc('datasetrapport.p',oParam:getParameters(),oDS:dsh) then  
  undo, throw new Progress.Lang.AppError(jboxserverapi:Instance:getCallMessage(),0).

oDS:writeXMLSchema(filSkjema).
oDS:writeXML(filXML).

oCmd = new JBoxCMD(filskjema).
oCmd = new JBoxCMD(filXML).

CATCH eAny AS Progress.Lang.Error :
  MESSAGE eAny:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.
