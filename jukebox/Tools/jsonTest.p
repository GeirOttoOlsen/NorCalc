/******** Paste DS definition here: */

DEFINE TEMP-TABLE jsonresultatForsikring
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE ExternalAgreements
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE ExternalAgreements_ExternalAgree SERIALIZE-NAME 'ExternalAgreements'
    FIELD id AS CHARACTER FORMAT "x(7)"
    FIELD status_ AS CHARACTER FORMAT "x(6)" SERIALIZE-NAME 'status'
    FIELD agreementStartDate AS CHARACTER FORMAT "x(10)"
    FIELD agreementEndDate AS CHARACTER FORMAT "x(10)"
    FIELD basicRisk AS CHARACTER FORMAT "x(11)"
    FIELD aggregateInsuranceCostYearly AS DECIMAL
    FIELD sumInsurancesMonthly AS CHARACTER FORMAT "x(12)"
    FIELD cancelledBeforeEndDate AS LOGICAL
    FIELD sumInsurancesTFAYearly AS CHARACTER FORMAT "x(11)"
    FIELD sumInsurancesTFAYearlyAmount AS DECIMAL
    FIELD sumInsurancesYearly AS CHARACTER FORMAT "x(13)"
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE agreementProperties
    FIELD key AS CHARACTER FORMAT "x(18)"
    FIELD value_ AS CHARACTER FORMAT "x(23)" SERIALIZE-NAME 'value'
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE customer
    FIELD id AS CHARACTER FORMAT "x(9)"
    FIELD firstName AS CHARACTER FORMAT "x(8)"
    FIELD lastName AS CHARACTER FORMAT "x(6)"
    FIELD cellNumber AS CHARACTER FORMAT "x(11)"
    FIELD emailAddress AS CHARACTER FORMAT "x(14)"
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE listOfProducts
    FIELD id AS CHARACTER FORMAT "x(3)"
    FIELD productIdentifier AS CHARACTER FORMAT "x(55)"
    FIELD productName AS CHARACTER FORMAT "x(33)"
    FIELD productPriceMonthly AS CHARACTER FORMAT "x(12)"
    FIELD productPriceYearly AS CHARACTER FORMAT "x(13)"
    FIELD productType AS CHARACTER FORMAT "x(2)"
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE listOfInsuredObjects
    FIELD id AS CHARACTER FORMAT "x(43)"
    FIELD sequenceNo AS CHARACTER FORMAT "x(6)"
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE insuredObjectDisplayProperties
    FIELD sortOrder AS CHARACTER FORMAT "x(4)"
    FIELD name AS CHARACTER FORMAT "x(48)"
    FIELD value_ AS CHARACTER FORMAT "x(78)" SERIALIZE-NAME 'value'
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE location
    FIELD id AS CHARACTER FORMAT "x(1)"
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE locationProperties
    FIELD key AS CHARACTER FORMAT "x(23)"
    FIELD value_ AS CHARACTER FORMAT "x(20)" SERIALIZE-NAME 'value'
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE listOfCoverages
    FIELD id AS CHARACTER FORMAT "x(16)"
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE TEMP-TABLE coverageProperties
    FIELD key AS CHARACTER FORMAT "x(25)"
    FIELD value_ AS CHARACTER FORMAT "x(48)" SERIALIZE-NAME 'value'
    FIELD JBoxRowIdent AS INTEGER
    FIELD JBoxParentRowIdent AS INTEGER
INDEX idxJBoxRowIdent JBoxRowIdent
INDEX idxJBoxParentRowIdent JBoxParentRowIdent
.

DEFINE DATASET jsonresultatForsikring FOR jsonresultatForsikring, ExternalAgreements, ExternalAgreements_ExternalAgree, agreementProperties, customer, listOfProducts, listOfInsuredObjects, insuredObjectDisplayProperties, location, locationProperties, listOfCoverages, coverageProperties
    DATA-RELATION ExternalAgreements FOR jsonresultatForsikring, ExternalAgreements RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION ExternalAgreements_ExternalAgree FOR ExternalAgreements_ExternalAgree, ExternalAgreements_ExternalAgree RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION agreementProperties FOR ExternalAgreements_ExternalAgree, agreementProperties RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION customer FOR ExternalAgreements_ExternalAgree, customer RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION listOfProducts FOR ExternalAgreements_ExternalAgree, listOfProducts RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION listOfInsuredObjects FOR listOfProducts, listOfInsuredObjects RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION insuredObjectDisplayProperties FOR listOfInsuredObjects, insuredObjectDisplayProperties RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION location FOR listOfInsuredObjects, location RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION locationProperties FOR location, locationProperties RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION listOfCoverages FOR listOfInsuredObjects, listOfCoverages RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
    DATA-RELATION coverageProperties FOR listOfCoverages, coverageProperties RELATION-FIELDS ( JBoxRowIdent, JBoxParentRowIdent ) NESTED
.



/******** start kode: */



DEF VAR cJsonFile   AS CHAR NO-UNDO.
DEF VAR lcJson      AS LONGCHAR NO-UNDO.
DEF VAR oJboxParser AS JBoxJsonParser NO-UNDO.

FIX-CODEPAGE(lcJson) = "UTF-8".

oJboxParser = NEW JBoxJsonParser().

oJboxParser:LoadPredefinedDS(DATASET jsonresultatForsikring:HANDLE).

cJsonFile = 'C:\temp\json\jsonresultatForsikring.json'.
COPY-LOB FROM FILE cJsonFile TO lcJson.

oJboxParser:appendData(lcJson).



/******** FOR EACH template: */

FOR EACH jsonresultatForsikring
   ,EACH ExternalAgreements WHERE ExternalAgreements.JBoxParentRowIdent = jsonresultatForsikring.JBoxRowIdent
    :
END.

