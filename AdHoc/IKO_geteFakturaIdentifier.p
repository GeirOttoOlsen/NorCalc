
/*------------------------------------------------------------------------
    File        : IKO_geteFakturaIdentifier.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Wed Feb 28 15:57:13 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE GetEfakturaIdentifiers NO-UNDO
  NAMESPACE-URI "https://efaktura-services.nets.no/invoicing-nets-submitter/v1/" 
  FIELD returnOnlyMatchingKeyParams AS LOGICAL .

DEFINE TEMP-TABLE auditInformation NO-UNDO
  NAMESPACE-URI "" 
  FIELD messageIdentifier AS CHARACTER 
  FIELD GetEfakturaIdentifiers_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE getEfakturaIdentifiersKey NO-UNDO
  NAMESPACE-URI "" 
  FIELD GetEfakturaIdentifiers_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE efakturaIdentifierKey NO-UNDO
  NAMESPACE-URI "" 
  FIELD id AS INT64 
  FIELD efakturaIdentifier AS CHARACTER 
  FIELD socialSecurityNumber AS CHARACTER 
  FIELD organizationNumber AS CHARACTER 
  FIELD telephoneAlias AS CHARACTER 
  FIELD emailAlias AS CHARACTER 
  FIELD invoiceIssuer AS CHARACTER 
  FIELD dateOfBirth AS DATE 
  FIELD getEfakturaIdentifiersKey_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE name NO-UNDO
  NAMESPACE-URI "" 
  FIELD firstName AS CHARACTER 
  FIELD lastName AS CHARACTER 
  FIELD efakturaIdentifierKey_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE address NO-UNDO
  NAMESPACE-URI "" 
  FIELD addressLine1 AS CHARACTER 
  FIELD addressLine2 AS CHARACTER 
  FIELD postalCode AS CHARACTER 
  FIELD city AS CHARACTER 
  FIELD countryCode AS CHARACTER 
  FIELD efakturaIdentifierKey_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE eFakturaReferenceAndContentProvi NO-UNDO
  NAMESPACE-URI "" 
  XML-NODE-NAME "eFakturaReferenceAndContentProvider" 
  FIELD eFakturaReference AS CHARACTER 
  FIELD contentProviderId AS CHARACTER 
  FIELD efakturaIdentifierKey_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE DATASET GetEfakturaIdentifiersDset NAMESPACE-URI "https://efaktura-services.nets.no/invoicing-nets-submitter/v1/" 
  XML-NODE-TYPE "HIDDEN" 
  FOR GetEfakturaIdentifiers, auditInformation, getEfakturaIdentifiersKey, efakturaIdentifierKey, name, address, eFakturaReferenceAndContentProvi
  PARENT-ID-RELATION RELATION1 FOR efakturaIdentifierKey, name
    PARENT-ID-FIELD efakturaIdentifierKey_id
    PARENT-FIELDS-BEFORE (id,efakturaIdentifier,socialSecurityNumber,organizationNumber,telephoneAlias,emailAlias)
  PARENT-ID-RELATION RELATION2 FOR efakturaIdentifierKey, address
    PARENT-ID-FIELD efakturaIdentifierKey_id
    PARENT-FIELDS-AFTER (invoiceIssuer,dateOfBirth)
  PARENT-ID-RELATION RELATION3 FOR efakturaIdentifierKey, eFakturaReferenceAndContentProvi
    PARENT-ID-FIELD efakturaIdentifierKey_id
  PARENT-ID-RELATION RELATION4 FOR getEfakturaIdentifiersKey, efakturaIdentifierKey
    PARENT-ID-FIELD getEfakturaIdentifiersKey_id
  PARENT-ID-RELATION RELATION5 FOR GetEfakturaIdentifiers, auditInformation
    PARENT-ID-FIELD GetEfakturaIdentifiers_id
  PARENT-ID-RELATION RELATION6 FOR GetEfakturaIdentifiers, getEfakturaIdentifiersKey
    PARENT-ID-FIELD GetEfakturaIdentifiers_id
    PARENT-FIELDS-AFTER (returnOnlyMatchingKeyParams).
/*
DEFINE DATASET GetEfakturaIdentifiersDset NAMESPACE-URI "https://efaktura-services.nets.no/invoicing-nets-submitter/v1/" 
  XML-NODE-TYPE "HIDDEN" 
  FOR GetEfakturaIdentifiers, auditInformation, getEfakturaIdentifiersKey, efakturaIdentifierKey, name, address, eFakturaReferenceAndContentProvi
  PARENT-ID-RELATION RELATION1 FOR efakturaIdentifierKey, name
    PARENT-ID-FIELD efakturaIdentifierKey_id
    PARENT-FIELDS-BEFORE (id,efakturaIdentifier,socialSecurityNumber,organizationNumber,telephoneAlias,emailAlias)
  PARENT-ID-RELATION RELATION2 FOR efakturaIdentifierKey, address
    PARENT-ID-FIELD efakturaIdentifierKey_id
    PARENT-FIELDS-AFTER (invoiceIssuer,dateOfBirth)
  PARENT-ID-RELATION RELATION3 FOR efakturaIdentifierKey, eFakturaReferenceAndContentProvi
    PARENT-ID-FIELD efakturaIdentifierKey_id
  PARENT-ID-RELATION RELATION4 FOR getEfakturaIdentifiersKey, efakturaIdentifierKey
    PARENT-ID-FIELD getEfakturaIdentifiersKey_id
  PARENT-ID-RELATION RELATION5 FOR GetEfakturaIdentifiers, auditInformation
    PARENT-ID-FIELD GetEfakturaIdentifiers_id
  PARENT-ID-RELATION RELATION6 FOR GetEfakturaIdentifiers, getEfakturaIdentifiersKey
    PARENT-ID-FIELD GetEfakturaIdentifiers_id
    PARENT-FIELDS-AFTER (returnOnlyMatchingKeyParams).
*/

DEFINE TEMP-TABLE GetEfakturaIdentifiersResponse NO-UNDO
  NAMESPACE-URI "https://efaktura-services.nets.no/invoicing-nets-submitter/v1/" 
  FIELD messageIdentifier AS CHARACTER .

DEFINE TEMP-TABLE getEfakturaIdentifiersResponse2 NO-UNDO
  NAMESPACE-URI "" 
  XML-NODE-NAME "getEfakturaIdentifiersResponse" 
  FIELD GetEfakturaIdentifiersRespons_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE efakturaIdentifierResponse NO-UNDO
  NAMESPACE-URI "" 
  FIELD responseResult AS CHARACTER 
  FIELD hasAutoAcceptAgreements AS LOGICAL 
  FIELD efakturaIdentifier AS CHARACTER 
  FIELD getEfakturaIdentifiersRespons_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE efakturaIdentifierKey1 NO-UNDO
  NAMESPACE-URI "" 
  XML-NODE-NAME "efakturaIdentifierKey" 
  FIELD id AS INT64 
  FIELD efakturaIdentifier AS CHARACTER 
  FIELD socialSecurityNumber AS CHARACTER 
  FIELD organizationNumber AS CHARACTER 
  FIELD telephoneAlias AS CHARACTER 
  FIELD emailAlias AS CHARACTER 
  FIELD invoiceIssuer AS CHARACTER 
  FIELD dateOfBirth AS DATE 
  FIELD efakturaIdentifierResponse_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE name1 NO-UNDO
  NAMESPACE-URI "" 
  XML-NODE-NAME "name" 
  FIELD firstName AS CHARACTER 
  FIELD lastName AS CHARACTER 
  FIELD efakturaIdentifierKey1_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE address1 NO-UNDO
  NAMESPACE-URI "" 
  XML-NODE-NAME "address" 
  FIELD addressLine1 AS CHARACTER 
  FIELD addressLine2 AS CHARACTER 
  FIELD postalCode AS CHARACTER 
  FIELD city AS CHARACTER 
  FIELD countryCode AS CHARACTER 
  FIELD efakturaIdentifierKey1_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE eFakturaReferenceAndContentProv1 NO-UNDO
  NAMESPACE-URI "" 
  XML-NODE-NAME "eFakturaReferenceAndContentProvider" 
  FIELD eFakturaReference AS CHARACTER 
  FIELD contentProviderId AS CHARACTER 
  FIELD efakturaIdentifierKey1_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE issuerResponse NO-UNDO
  NAMESPACE-URI "" 
  FIELD blockedByReceiver AS LOGICAL 
  FIELD hasEfakturaAgreement AS LOGICAL 
  FIELD efakturaIdentifierResponse_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE TEMP-TABLE efakturaReferences NO-UNDO
  NAMESPACE-URI "" 
  FIELD efakturaReferences_Text AS CHARACTER 
    XML-NODE-TYPE "TEXT" 
  FIELD issuerResponse_id AS RECID 
    XML-NODE-TYPE "HIDDEN" .

DEFINE DATASET GetEfakturaIdentifiersResponDset NAMESPACE-URI "https://efaktura-services.nets.no/invoicing-nets-submitter/v1/" 
  XML-NODE-TYPE "HIDDEN" 
  FOR GetEfakturaIdentifiersResponse, getEfakturaIdentifiersResponse2, efakturaIdentifierResponse, efakturaIdentifierKey1, name1, address1, eFakturaReferenceAndContentProv1, issuerResponse, efakturaReferences
  PARENT-ID-RELATION RELATION1 FOR efakturaIdentifierKey1, name1
    PARENT-ID-FIELD efakturaIdentifierKey1_id
    PARENT-FIELDS-BEFORE (id,efakturaIdentifier,socialSecurityNumber,organizationNumber,telephoneAlias,emailAlias)
  PARENT-ID-RELATION RELATION2 FOR efakturaIdentifierKey1, address1
    PARENT-ID-FIELD efakturaIdentifierKey1_id
    PARENT-FIELDS-AFTER (invoiceIssuer,dateOfBirth)
  PARENT-ID-RELATION RELATION3 FOR efakturaIdentifierKey1, eFakturaReferenceAndContentProv1
    PARENT-ID-FIELD efakturaIdentifierKey1_id
  PARENT-ID-RELATION RELATION4 FOR efakturaIdentifierResponse, efakturaIdentifierKey1
    PARENT-ID-FIELD efakturaIdentifierResponse_id
  PARENT-ID-RELATION RELATION5 FOR issuerResponse, efakturaReferences
    PARENT-ID-FIELD issuerResponse_id
  PARENT-ID-RELATION RELATION6 FOR efakturaIdentifierResponse, issuerResponse
    PARENT-ID-FIELD efakturaIdentifierResponse_id
  PARENT-ID-RELATION RELATION7 FOR getEfakturaIdentifiersResponse2, efakturaIdentifierResponse
    PARENT-ID-FIELD getEfakturaIdentifiersRespons_id
  PARENT-ID-RELATION RELATION8 FOR GetEfakturaIdentifiersResponse, getEfakturaIdentifiersResponse2
    PARENT-ID-FIELD GetEfakturaIdentifiersRespons_id.


DEFINE VARIABLE hWebService AS HANDLE NO-UNDO.
DEFINE VARIABLE hEfakturaNetsSubmitterPortType AS HANDLE NO-UNDO.
DEFINE VARIABLE cOptions AS CHAR INIT "-sslprotocols TLSv1.2 -sslciphers ECDHE-RSA-AES256-GCM-SHA384". 
def var ConStreng as char no-undo.

conStreng = subst("-WSDL 'file:///E:/ws_norshunt/norcalc/AdHoc/ikoWSDL.wsdl' &1",cOptions).
/*MESSAGE ConStreng                       */
/*VIEW-AS ALERT-BOX.                      */
/*CREATE SERVER hWebService.              */
/*hWebService:CONNECT(conStreng).         */
/*                                        */
/*MESSAGE hWebService:CLIENT-CONNECTION-ID*/
/*VIEW-AS ALERT-BOX.                      */
create GetEfakturaIdentifiers.

create getEfakturaIdentifiersKey.
assign 
  getEfakturaIdentifiersKey.GetEfakturaIdentifiers_id = buffer GetEfakturaIdentifiers:recid
  .
create efakturaIdentifierKey.
assign
  efakturaIdentifierKey.getEfakturaIdentifiersKey_id = buffer getEfakturaIdentifiersKey:recid 
  efakturaIdentifierKey.telephoneAlias = '95076989'
  efakturaIdentifierKey.emailAlias = 'goo@thinc.no' 
  .

def var myDataset as longchar no-undo.
def var oCmd as jboxcmd no-undo.

fix-codepage(myDataset) = 'utf-8'.

dataset GetEfakturaIdentifiersDset:WRITE-XML ('longchar',myDataset,true). 
oCmd = new jboxcmd('notepad.exe',myDataset,'xml').

/*RUN EfakturaNetsSubmitterPortType SET hEfakturaNetsSubmitterPortType ON hWebService.                                                                    */
/*                                                                                                                                                        */
/*RUN getEfakturaIdentifiers IN hEfakturaNetsSubmitterPortType(INPUT DATASET GetEfakturaIdentifiersDset, OUTPUT DATASET GetEfakturaIdentifiersResponDset).*/

for each efakturaReferences:
  MESSAGE efakturaReferences.efakturaReferences_Text
  VIEW-AS ALERT-BOX.  
end.

CATCH eAny AS Progress.Lang.Error :
  MESSAGE eAny:GetMessage(1)
  VIEW-AS ALERT-BOX.  
END CATCH.
FINALLY:
  hWebService:DISCONNECT () no-error.
  delete object hWebService no-error.
  delete object hEfakturaNetsSubmitterPortType no-error.      
END FINALLY.




