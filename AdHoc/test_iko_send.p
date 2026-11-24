/*------------------------------------------------------------------------
     File        : TestCreateOrder.p
     Purpose     :

     Syntax      :

     Description :

     Author(s)   : eli
     Created     : Sat Dec 08 12:07:22 CET 2012
     Notes       :
----------------------------------------------------------------------*/
DEFINE TEMP-TABLE ttOppslag NO-UNDO
  FIELD seqId AS INTEGER FORMAT ">>>>9" LABEL 'Id'
  FIELD telefon AS CHARACTER FORMAT "x(11)" LABEL 'Telefon'
  FIELD epost AS CHARACTER FORMAT "x(60)" LABEL 'Epost'
  FIELD eFakturaIdentifier AS CHARACTER FORMAT "x(30)" LABEL 'Kundenr'
  .

DEFINE VARIABLE oIKOwebclient AS CLASS oo.IKOwebclient NO-UNDO.

DEFINE VARIABLE oCmd AS jboxCmd NO-UNDO.
DEFINE VARIABLE soapEnvelope AS LONGCHAR NO-UNDO.
DEFINE VARIABLE soapBody AS LONGCHAR NO-UNDO.
DEFINE VARIABLE soapBodyRow AS LONGCHAR NO-UNDO.
DEFINE VARIABLE soapBodyRowTemplate AS LONGCHAR NO-UNDO.
DEFINE VARIABLE soapRows AS LONGCHAR NO-UNDO.

DEFINE VARIABLE soapAction AS CHARACTER NO-UNDO.
DEFINE VARIABLE soapURI AS CHARACTER NO-UNDO.

DEFINE VARIABLE certPFX AS CHARACTER NO-UNDO.
DEFINE VARIABLE secretKeyPFX AS CHARACTER NO-UNDO.
DEFINE VARIABLE username AS CHARACTER NO-UNDO.
DEFINE VARIABLE password AS CHARACTER NO-UNDO.
DEFINE VARIABLE msgIdentifier as char no-undo.

DEFINE VARIABLE cnt AS INTEGER NO-UNDO.

DEFINE VARIABLE oParam AS oo.parameter NO-UNDO.
DEFINE VARIABLE oParser AS JBoxJsonParser NO-UNDO.

def var oSetup as JBoxJsonParser no-undo.
def var oSetupFile as JBoxFileHelper no-undo.


FUNCTION addOppslag RETURNS LOG (INPUT iptelefon AS CHARACTER,
  INPUT ipepost AS CHARACTER,
  INPUT ipeFaktIdent AS CHARACTER) FORWARD.

fix-codepage(soapEnvelope) = 'utf-8'.
fix-codepage(soapBody)     = 'utf-8'.
fix-codepage(soapRows)     = 'utf-8'.
fix-codepage(soapBodyRow)  = 'utf-8'.
fix-codepage(soapBodyRowTemplate)  = 'utf-8'.

oSetupFile = new JBoxFileHelper('./adhoc/mastercard_prod.json').
oSetup = new JBoxJsonParser().
oSetup:createSchema(oSetupFile:FileContent,'Setup').

ASSIGN 
  soapURI       = oSetup:getResultFirstFieldValue('JBoxDatasource','URI')
  certPFX       = oSetup:getResultFirstFieldValue('JBoxDatasource','CertPFX')
  secretKeyPFX  = oSetup:getResultFirstFieldValue('JBoxDatasource','CertSecretKey')
  username      = oSetup:getResultFirstFieldValue('JBoxDatasource','User_')
  password      = oSetup:getResultFirstFieldValue('JBoxDatasource','Pwd')

  msgIdentifier = guid 
  soapAction    = 'https://efaktura-services.nets.no/invoicing-nets-submitter/v1/getEfakturaIdentifiers'
  .
/*Fill ttOppslagg*/
addOppslag('+4795076989','goo@thinc.no','678').
/*addOppslag('+4711915541','nichlas19@mpstest.no','12345678').*/
//addOppslag('+4721622259','trude16@mpstest.no','123334').

oIKOwebclient = NEW oo.IKOwebclient(certPFX,secretKeyPFX).

/*Henter templates fra klassen*/
soapEnvelope = oIKOwebclient:getSoapEnvelopSchema_eFakturaIdentifiers().
soapBody     = oIKOwebclient:getBodySchema_eFakturaIdentifiers().

/*Initierer innhold i soapEnvelope*/
ASSIGN
  soapEnvelope = REPLACE(soapEnvelope,'[username]',username)
  soapEnvelope = REPLACE(soapEnvelope,'[password]',password)
  .

/*Fyller rows via template*/    
soapBodyRowTemplate  = oIKOwebclient:getBodySchema_eFakturaIdentifiersKey().
FOR EACH ttOppslag:
  ASSIGN 
    soapBodyRow = soapBodyRowTemplate
    soapBodyRow = REPLACE(soapBodyRow,'[telefon]',ttOppslag.telefon)
    soapBodyRow = REPLACE(soapBodyRow,'[epost]',ttOppslag.epost)
    soapBodyRow = REPLACE(soapBodyRow,'[eFakturaIdentifier]',ttOppslag.eFakturaIdentifier)
    soapRows = soapRows + (IF soapRows = '' THEN '' ELSE CHR(10)) + soapBodyRow
    .
END.

/*Fyller data i templatene*/
soapBody     = REPLACE(soapBody,'[soapBodyRows]',soapRows). 
soapBody     = REPLACE(soapBody,'[MessageIdentifier]',msgIdentifier).
soapEnvelope = REPLACE(soapEnvelope,'[soapBody]',soapBody).

/*Overfører data for reques header og body og utfører */
oParam = NEW oo.parameter().
oParam:addParameter('RequestURI',soapURI).
oParam:addParameter('RequestMethod','POST').
oParam:addParameter('soapAction',soapAction).
oParam:addParameter('RequestBody',STRING(soapEnvelope)).

IF NOT oIKOwebclient:callAPI(oParam:getParameters()) THEN 
  UNDO, THROW NEW Progress.Lang.AppError('CallAPI error:' + oIKOwebclient:StatusMessage,0).
/*Legger inn tag for XML da soap leveres uten*/

oParser = NEW JBoxJsonParser().
oParser:createXMLSchema(oIKOwebclient:ResponseContent,'resultat').
oParser:viewResultDS().

IF oIKOwebclient:StatusMessage <> '' THEN
  UNDO, THROW NEW Progress.Lang.AppError(oIKOwebclient:StatusMessage,0). 
//oCmd = new JBoxCmd('notepad.exe',soapEnvelope,'xml').
/*copy-lob from object soapEnvelope to file 'e:\temp\soapIKO#1.xml'.*/

CATCH eAny AS Progress.Lang.Error :
  def var ii as int no-undo.
  do ii = 1 to eAny:NumMessages:
    MESSAGE eAny:GetMessage(ii)
    VIEW-AS ALERT-BOX.  
  end.    
END CATCH.

FUNCTION addOppslag RETURNS LOG (INPUT iptelefon AS CHARACTER,
  INPUT ipepost AS CHARACTER,
  INPUT ipeFaktIdent AS CHARACTER):

  CREATE ttOppslag.
  ASSIGN
    cnt = cnt + 1
    ttOppslag.seqId             = cnt
    ttOppslag.telefon           = ipTelefon
    ttOppslag.epost             = ipepost
    ttOppslag.eFakturaIdentifier= ipeFaktIdent
    .                                
                                     
END FUNCTION.                                   