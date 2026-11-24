
CLASS oo.IKOwebclient INHERITS oo.HTTPclient:
/*  DEFINE PRIVATE VARIABLE oCrypto AS JBoxCrypto NO-UNDO.*/
  DEFINE PUBLIC PROPERTY StatusMessage        AS CHARACTER   NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY RequestMethod AS CHARACTER NO-UNDO GET. SET.
  
  DEFINE PUBLIC PROPERTY ResponseContent AS LONGCHAR NO-UNDO GET. PRIVATE SET.

  CONSTRUCTOR IKOwebclient ():
    SUPER().
/*    oCrypto  = NEW JBoxCrypto().*/
    
  END CONSTRUCTOR.

  CONSTRUCTOR IKOwebclient (INPUT ipCert AS CHARACTER, INPUT ipSecretKey AS CHARACTER ):
    SUPER(ipCert,ipSecretKey).
/*    oCrypto  = NEW JBoxCrypto().*/
    
  END CONSTRUCTOR.
  
  METHOD PUBLIC LOGICAL callAPI (INPUT ipParam AS CHARACTER):
    DEFINE VARIABLE Uri AS CHARACTER NO-UNDO.
    DEFINE VARIABLE oParam AS oo.parameter NO-UNDO.
    DEFINE VARIABLE soapEnvelope AS CHARACTER NO-UNDO.
    DEFINE VARIABLE soapAction AS CHARACTER NO-UNDO.
    DEF VAR XMLdoc AS System.Xml.XmlDocument NO-UNDO.

    oParam = NEW oo.parameter().
    oParam:addParameters(ipParam).
    
    ASSIGN
      requestMethod = oParam:getParameter('RequestMethod') 
      Uri           = oParam:getParameter('RequestURI')
      soapEnvelope  = oParam:getParameter('RequestBody')
      soapAction    = oParam:getParameter('soapAction')
      . 
    oURI  = NEW System.Uri(Uri).
    .    
    Initialize().
    
    AddHeader('Content-Type','text/xml','Content').
    AddHeader('SOAPAction',soapAction,'').
    setBody(soapEnvelope, System.Text.Encoding:UTF8).
    
    oURI = NEW System.Uri(Uri).
    
    IF executeRequest(requestMethod) THEN DO:
      ResponseContent = CopyToLongchar(oResponse:Content).
      
      /*Return XML if soap*/
      if ResponseContent begins '<soap' then     
        ResponseContent = '<?xml version="1.0" encoding="utf-8"?>' + ResponseContent.

      do on error undo, throw:
        XMLdoc = new System.Xml.XmlDocument().
        XMLdoc:LoadXml(ResponseContent).
    
        CATCH eXML AS System.Xml.XmlException:
          MESSAGE 'feil' eXML:GetMessage(1)
          VIEW-AS ALERT-BOX.
          return false.
        END CATCH.
      end.
      ResponseContent = System.Xml.Linq.XElement:Parse(XMLdoc:OuterXml):ToString().
    END.     
    
    CATCH eWeb AS System.Net.WebException :
      DEFINE VARIABLE StrReader AS System.IO.StreamReader NO-UNDO.
      DEFINE VARIABLE errMsg AS LONGCHAR NO-UNDO.
      MESSAGE eWeb:CallStack
      VIEW-AS ALERT-BOX.
      FIX-CODEPAGE(errMsg) = 'UTF-8'.
      strReader = NEW System.IO.StreamReader(eWeb:Response:GetResponseStream()).
      IF VALID-OBJECT(strReader) THEN DO: 
        errMsg = strReader:ReadToEnd().
        MESSAGE "status message > " STRING (errMsg).
        RETURN FALSE.
      END.
    END CATCH.
    
    CATCH eAny AS Progress.Lang.Error :
      DEFINE VARIABLE ix AS INTEGER NO-UNDO.
      DO ix = 1 TO eAny:NumMessages:
        MESSAGE 'error:---' eAny:GetMessage(ix).
        RETURN FALSE.
      END.
    END CATCH.  
  END METHOD.

  METHOD PUBLIC LONGCHAR getSoapEnvelopSchema_eFakturaIdentifiers ():
    DEFINE VARIABLE soapEnvelope AS LONGCHAR NO-UNDO.
    fix-codepage(soapEnvelope) = 'utf-8'.
     
    soapEnvelope = 
      '<?xml version="1.0" encoding="utf-8"?>
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="https://efaktura-services.nets.no/invoicing-nets-submitter/v1/">
       <soapenv:Header>
         <wsse:Security soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">
            <wsse:UsernameToken>
              <wsse:Username>[username]</wsse:Username>
              <wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">[password]</wsse:Password>
            </wsse:UsernameToken>
         </wsse:Security>
       </soapenv:Header>
       <soapenv:Body>
        [soapBody]                       
       </soapenv:Body>
     </soapenv:Envelope>'
      .  
    
    RETURN soapEnvelope.
  END METHOD.

  /************************************************************************************************
  
  <GetEfakturaIdentifiers xmlns="https://efaktura-services.nets.no/invoicing-nets-submitter/v1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <getEfakturaIdentifiersKey xmlns="">
      <efakturaIdentifierKey xmlns="">
        <id>0</id>
        <efakturaIdentifier/>
        <socialSecurityNumber/>
        <organizationNumber/>
        <telephoneAlias>95076989</telephoneAlias>
        <emailAlias>goo@thinc.no</emailAlias>
        <invoiceIssuer/>
        <socialSecurityNumber>string-value</socialSecurityNumber>
        <organizationNumber>string-value</organizationNumber>
        <dateOfBirth xsi:nil="true"/>
        <name>
          <firstName>string-value</firstName>
          <lastName>string-value</lastName>
        </name>
        <address>
          <addressLine1>string-value</addressLine1>
          <addressLine2>string-value</addressLine2>
          <postalCode>string-value</postalCode>
          <city>string-value</city>
          <countryCode>string-value</countryCode>
        </address>
      </efakturaIdentifierKey>
    </getEfakturaIdentifiersKey>
    <returnOnlyMatchingKeyParams>false</returnOnlyMatchingKeyParams>
  </GetEfakturaIdentifiers>
  
  
  Ser du har definert namespace i Envelope som v1. Da skal du ikke definere nytt namespace senere i xml for det som allerede er definert av namespace v1. 
  Du må legge til namespace på de elementene som er definert. 
  Slik som det er gjort for eksempel for Envelope som skrives med namespace som <soapenv:Envelope>.
  Da skal 
  <GetEfakturaIdentifiers> skrives som <v1:getEfakturaIdentifiers>.
  
  ***************************************************************************************************/

  METHOD PUBLIC LONGCHAR getBodySchema_eFakturaIdentifiers ():
    DEFINE VARIABLE soapBody AS LONGCHAR NO-UNDO.
    
    fix-codepage(soapBody) = 'utf-8'.
     
    soapBody =
      '<v1:GetEfakturaIdentifiers>
        <auditInformation>
          <messageIdentifier>[MessageIdentifier]</messageIdentifier>
        </auditInformation>
          <getEfakturaIdentifiersKey xmlns="">
            [soapBodyRows]
          </getEfakturaIdentifiersKey>
          <returnOnlyMatchingKeyParams>false</returnOnlyMatchingKeyParams>
     </v1:GetEfakturaIdentifiers>' 
      .  
    RETURN soapBody.
  END METHOD.

  METHOD PUBLIC LONGCHAR getBodySchema_eFakturaIdentifiersKey ():
    DEFINE VARIABLE soapBodyRow AS LONGCHAR NO-UNDO.
    
    fix-codepage(soapBodyRow) = 'utf-8'.
     
    soapBodyRow =
         '<efakturaIdentifierKey xmlns="">
            <id>[eFakturaIdentifier]</id>
            <telephoneAlias>[telefon]</telephoneAlias>
            <emailAlias>[epost]</emailAlias>
            <name>
              <firstName>[Firstname]</firstName>
              <lastName>[Lastname]</lastName>
            </name>
            <address>
              <addressLine1>[AdressLine1]</addressLine1>
              <addressLine2>[AdressLine2]</addressLine2>
              <postalCode>[Postalcode]</postalCode>
              <city>[City]</city>
              <countryCode>[CountryCode]</countryCode>
            </address>
          </efakturaIdentifierKey>'
      .  
    RETURN soapBodyRow.
  END METHOD.

  DESTRUCTOR IKOwebclient ():
  END DESTRUCTOR.
END CLASS.
