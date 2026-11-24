 
/*------------------------------------------------------------------------
   File        : Members
   Purpose     : 
   Syntax      : 
   Description : 
   Author(s)   : 
   Created     : Mon Sep 16 14:49:16 CEST 2019
   Notes       : 
 ----------------------------------------------------------------------*/

USING Progress.Lang.*.


/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    
BLOCK-LEVEL ON ERROR UNDO, THROW.

  
CLASS Members: 

  /*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

  DEFINE PUBLIC PROPERTY JsonResult AS Progress.Json.ObjectModel.JsonArray NO-UNDO GET. SET.
  DEFINE PUBLIC PROPERTY MessageStatus AS CHARACTER NO-UNDO GET. PRIVATE SET.
  DEFINE PUBLIC PROPERTY MessageCode AS int NO-UNDO GET. SET.
  
  DEFINE PUBLIC PROPERTY RecordCount AS INTEGER NO-UNDO GET. PRIVATE SET.
  
  DEF TEMP-TABLE ttMedlem
    FIELD fnavn AS character FORMAT 'x(30)' LABEL 'Fornavn'
    FIELD enavn AS character FORMAT 'x(30)' LABEL 'Etternavn'
    FIELD Innmeldt AS date FORMAT '99.99.9999' LABEL 'Innmeldt'
    FIELD Utmeldt AS date FORMAT '99.99.9999' LABEL 'Utmeldt'
    FIELD e-post AS character FORMAT 'X(60)' LABEL 'E-post'
    FIELD jobb-e-post AS character FORMAT 'X(60)' LABEL 'Jobb e-post'
    FIELD Kontonr AS character FORMAT 'XXXX.XX.XXXXX' LABEL 'Kontonr'
    FIELD Kategori AS character FORMAT 'x(32)' LABEL 'Kategori'
    FIELD Medlemsnr AS integer FORMAT '>>>>>9' LABEL 'Medlemsnr'
    FIELD Mobil AS decimal FORMAT '>>>>>>>>>9' 
    FIELD SistKontingent AS integer FORMAT '999999' LABEL 'SistKontingent'
    FIELD Studentkulltil AS integer FORMAT '>>>9' LABEL 'Studentkull til'
    FIELD AvdNr AS integer FORMAT '999' LABEL 'Avd.nr'
    FIELD Distrikt-navn AS character FORMAT 'X(32)' LABEL 'Distrikt'
    .
/*    FIELD Fritekst AS character FORMAT 'x(50)'                                                       */
/*    FIELD Adresse AS character FORMAT 'x(32)' LABEL 'Adresse'                                        */
/*    FIELD Aktivitet AS character FORMAT 'X(20)'                                                      */
/*    FIELD Allergi AS character FORMAT 'x(40)'                                                        */
/*    FIELD Almanakk AS logical FORMAT 'J/N' LABEL 'Ønsker almanakk'                                   */
/*    FIELD AntallBlad AS integer FORMAT '9' LABEL 'Blad'                                              */
/*    FIELD AntallPrivatSkade AS integer FORMAT '->,>>>,>>9'                                           */
/*    FIELD AvsenderEpost AS character FORMAT 'x(8)'                                                   */
/*    FIELD BetaleForsikring AS logical FORMAT 'J/N' LABEL 'Betale forsikring'                         */
/*    FIELD BIPstilling AS character FORMAT 'x(32)' LABEL 'Stilling'                                   */
/*    FIELD BIPtype AS character FORMAT 'x(32)' LABEL 'Type'                                           */
/*    FIELD BringDato AS date FORMAT '99.99.9999' LABEL 'Bring dato'                                   */
/*    FIELD BringKode AS character FORMAT 'x(40)' LABEL 'Bring kode'                                   */
/*    FIELD Brukererklering AS date FORMAT '99.99.9999' LABEL 'Brukererklæring'                        */
/*    FIELD Dnr AS decimal FORMAT '>>>>>>>>>>>'                                                        */
/*    FIELD Einnmeldt AS logical FORMAT 'J/N' LABEL 'E-innmeldt'                                       */
/*    FIELD EmneOrd AS character FORMAT 'x(8)'                                                         */
/*    FIELD Enhet AS character FORMAT 'x(8)'                                                           */
/*    FIELD EpostPurrAdr AS logical FORMAT 'Privat/Jobb' LABEL 'Bruk denne e-postadr. for giro/purring'*/
/*    FIELD Eresmedlem AS integer FORMAT '99' LABEL 'Æresmedlem'                                       */
/*    FIELD Faktura12Mnd AS logical FORMAT 'yes/no' LABEL '12 mnd. faktura'                            */
/*    FIELD FakturaFom AS integer FORMAT '>>>>>>' LABEL 'Faktura fom'                                  */
/*    FIELD FakturaTom AS integer FORMAT '>>>>>>' LABEL 'Faktura tom'                                  */
/*    FIELD FDato AS date FORMAT '99.99.9999' LABEL 'Fødselsnr'                                        */
/*    FIELD FeilSMSsvar AS integer FORMAT '->,>>>,>>9' LABEL 'Svarer feil ifm SMS'                     */
/*    FIELD FiktivtOrgNr AS character FORMAT 'x(20)' LABEL 'Fiktivt org.nr'                            */
/*    FIELD FlyttefullmaktPSAvgitt AS datetime FORMAT '99.99.9999 HH:MM:SS' LABEL 'Flyttefullmakt PS'  */
/*    FIELD FlyttefullmaktPSValg AS logical FORMAT 'Ja/Nei' LABEL 'Flyttefullmakt PS'                  */
/*    FIELD FolgMedlem AS logical FORMAT 'J/N' LABEL 'Følg medlem'                                     */
/*    FIELD Forbundet AS character FORMAT 'X(1)' LABEL 'Forbundet'                                     */
/*    FIELD FTittel AS character FORMAT 'X(32)' LABEL 'Funksjonstittel'                                */
/*    FIELD FunkBedrift AS character FORMAT 'x(8)'                                                     */
/*    FIELD Fusjon AS character FORMAT 'x(8)'                                                          */
/*    FIELD HalvKontFom AS integer FORMAT '999999' LABEL 'Halv kont. fom.'                             */
/*    FIELD HalvKontTom AS integer FORMAT '999999' LABEL 'Halv kont. tom.'                             */
/*    FIELD Hederstegn AS integer FORMAT '99' LABEL 'Hederstegn'                                       */
/*    FIELD Initialer AS character FORMAT 'x(8)' LABEL 'Initialer'                                     */
/*    FIELD Kjonn AS character FORMAT 'X(1)' LABEL 'Kjønn'                                             */
/*    FIELD Kommentar AS character FORMAT 'X(8)'                                                       */
/*    FIELD Kommunenr AS integer FORMAT '9999'                                                         */
/*    FIELD Kontingent AS character FORMAT 'x(32)' LABEL 'Kontingent'                                  */
/*    FIELD KostEnhet AS character FORMAT 'x(8)'                                                       */
/*    FIELD Kostnadssted AS int64 FORMAT '>>>>>>>>>9'                                                  */
/*    FIELD LafiBrev AS date FORMAT '99.99.9999' LABEL 'Trekkbrev'                                     */
/*    FIELD LafiPunkt AS character FORMAT 'x(30)' LABEL 'Vedr.'                                        */
/*    FIELD Landkode AS integer FORMAT '>>>>'                                                          */
/*    FIELD LonnsNr AS integer FORMAT '9999' LABEL 'Lønnsnr'                                           */
/*    FIELD Medarbeidergruppe AS character FORMAT 'x(16)' LABEL 'Medarb.gr.'                           */
/*    FIELD MedarbUGr AS character FORMAT 'x(32)' LABEL 'Medarbeiderundergruppe'                       */
/*    FIELD MeldingKontDato AS date FORMAT '99.99.9999'                                                */
/*    FIELD MeldingKontingent AS character FORMAT 'X(1)' LABEL 'Melding kontingent'                    */
/*    FIELD Navn AS character FORMAT 'x(60)' LABEL 'Navn'                                              */
/*    FIELD NPL AS character FORMAT 'x(10)'                                                            */
/*    FIELD NyttAvdNr AS integer FORMAT '>9' LABEL 'Nytt avd.nr'                                       */
/*    FIELD OnskerIkkePPFmedlemskap AS logical FORMAT 'yes/no' LABEL 'Ønsker ikke PPF medlemskap'      */
/*    FIELD OrgEnhAvd AS character FORMAT 'x(30)' LABEL 'Org.enh (avdeling)'                           */
/*    FIELD OrgEnhet AS character FORMAT 'x(32)' LABEL 'Org.enhet'                                     */
/*    FIELD OrgEnhSek AS character FORMAT 'x(30)' LABEL 'Org.enh (seksjon)'                            */
/*    FIELD OrgNr AS character FORMAT 'x(20)' LABEL 'Org.nr'                                           */
/*    FIELD OverfDato AS date FORMAT '99.99.9999' LABEL 'Overført'                                     */
/*    FIELD Passord AS character FORMAT 'X(20)'                                                        */
/*    FIELD PassordEndret AS date FORMAT '99.99.9999' LABEL 'Endret'                                   */
/*    FIELD PassordHist AS character FORMAT 'X(8)'                                                     */
/*    FIELD PensjForb AS logical FORMAT 'J/N' LABEL 'Pensjonist forbundet'                             */
/*    FIELD PensjonistFra AS date FORMAT '99.99.9999' LABEL 'Pensjonist fra'                           */
/*    FIELD PeriodeTilsettingsforhold AS character FORMAT 'x(8)' LABEL 'Periode tilsettingsforhold'    */
/*    FIELD PersDataSlettet AS date FORMAT '99.99.9999' LABEL 'Personopplysninger slettet'             */
/*    FIELD PFPLkarantene AS logical FORMAT 'J/N' LABEL 'PFPL karantene'                               */
/*    FIELD PNr AS integer FORMAT '99999' LABEL 'Personnr'                                             */
/*    FIELD Postnummer AS character FORMAT 'x(32)'                                                     */
/*    FIELD Poststed AS character FORMAT 'x(32)'                                                       */
/*    FIELD PPFlokallag AS character FORMAT 'x(40)' LABEL 'PPF lokallag'                               */
/*    FIELD PPFmedlemsnr AS integer FORMAT '>>>>>>9' LABEL 'PPF medlemsnr'                             */
/*    FIELD RegDataTS AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS' LABEL 'Tidsfrist'                   */
/*    FIELD ResAlmanakk AS date FORMAT '99.99.9999' LABEL 'Reservert dato'                             */
/*    FIELD ReservertSMSSign AS character FORMAT 'x(8)' LABEL 'Reservert mot SMS sign.'                */
/*    FIELD ReservertSMSTS AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS' LABEL 'Reservert mot SMS'      */
/*    FIELD Riksans AS integer FORMAT '9999' LABEL 'Riksansiennitet'                                   */
/*    FIELD RRfilter AS character FORMAT 'x(16)'                                                       */
/*    FIELD RRvarsel AS logical FORMAT 'J/N' LABEL 'Motta varsel om endring'                           */
/*    FIELD Samtykke11 AS date FORMAT '99.99.9999'                                                     */
/*    FIELD SE-Adresse AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS'                                    */
/*    FIELD SE-e-post AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS' LABEL 'E-post'                      */
/*    FIELD SE-jobb-e-post AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS' LABEL 'Jobb-e-post'            */
/*    FIELD SE-Kontonr AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS' LABEL 'Kontonr'                    */
/*    FIELD SE-Mobil AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS' LABEL 'Mobil'                        */
/*    FIELD SEA-Adresse AS character FORMAT 'x(8)'                                                     */
/*    FIELD SEA-e-post AS character FORMAT 'x(8)' LABEL 'E-post'                                       */
/*    FIELD SEA-jobb-e-post AS character FORMAT 'x(8)' LABEL 'Jobb-e-post'                             */
/*    FIELD SEA-kontonr AS character FORMAT 'x(8)' LABEL 'Kontonr'                                     */
/*    FIELD SEA-Mobil AS character FORMAT 'x(8)' LABEL 'Mobil'                                         */
/*    FIELD SendtTilPPF AS date FORMAT '99.99.9999' LABEL 'Sendt til PPF'                              */
/*    FIELD SFSOadr AS character FORMAT 'x(60)' LABEL 'SFSØ adr.'                                      */
/*    FIELD SFSOpostnr AS integer FORMAT '9999' LABEL 'SFSØ postnr'                                    */
/*    FIELD SistBruktMS AS date FORMAT '99.99.9999' LABEL 'Sist brukt MS'                              */
/*    FIELD SisteLTrinn AS integer FORMAT '->>>>9'                                                     */
/*    FIELD SistEndretAv AS character FORMAT 'x(8)'                                                    */
/*    FIELD SistEndretTS AS datetime FORMAT '99.99.9999 HH:MM:SS.SSS'                                  */
/*    FIELD Sist_MS_Endret AS date FORMAT '99.99.9999' LABEL 'Sist Endret MS'                          */
/*    FIELD SkjemaBehandlet AS character FORMAT 'X(1)' LABEL 'Skjema behandlet'                        */
/*    FIELD SKO AS integer FORMAT '>>>9' LABEL 'SKO'                                                   */
/*    FIELD SluttvederlagFom AS date FORMAT '99.99.9999' LABEL 'Sluttvederlag fom'                     */
/*    FIELD SluttvederlagTom AS date FORMAT '99.99.9999' LABEL 'Sluttvederlag tom'                     */
/*    FIELD SpesStillingDato AS date FORMAT '99.99.9999'                                               */
/*    FIELD SpesStillingNr AS integer FORMAT '->,>>>,>>9'                                              */
/*    FIELD SpesStillingSign AS character FORMAT 'x(8)'                                                */
/*    FIELD SSUferdig AS date FORMAT '99.99.9999' LABEL 'SSU ferdig'                                   */
/*    FIELD SSUneste AS date FORMAT '99.99.9999' LABEL 'SSU neste'                                     */
/*    FIELD SSUsendt AS date FORMAT '99.99.9999' LABEL 'SSU sendt'                                     */
/*    FIELD StoppBladet AS date FORMAT '99.99.9999' LABEL 'Stopp'                                      */
/*    FIELD StudentBetalt AS date FORMAT '99.99.9999' LABEL 'Student betalt'                           */
/*    FIELD StudentkullFra AS integer FORMAT '>>>9' LABEL 'Studentkull fra'                            */
/*    FIELD Studentkulltil AS integer FORMAT '>>>9' LABEL 'Studentkull til'                            */
/*    FIELD Studiested AS character FORMAT 'X(4)' LABEL 'Studiested'                                   */
/*    FIELD Tilsettingsforhold AS character FORMAT 'x(40)'                                             */
/*    FIELD TjGjorAvdNr AS integer FORMAT '>>9' LABEL 'Tj.gjør i avdeling'                             */
/*    FIELD TjSted-Navn AS character FORMAT 'X(32)' LABEL 'Tjenestested'                               */
/*    FIELD Trekkvarsel AS character FORMAT 'x(8)'                                                     */
/*    FIELD UnderAvd AS integer FORMAT '>9' LABEL 'Underavdeling'                                      */
/*    FIELD UnderKat AS character FORMAT 'X(32)' LABEL 'Underkategori'                                 */
/*    FIELD Utland AS character FORMAT 'x(32)'                                                         */
/*    FIELD ValgAdresse AS character FORMAT 'X(1)'                                                     */
/*    FIELD VarselEinnmeldt AS logical FORMAT 'Ja/Nei' LABEL 'Varsel E-innmeldt'                       */
/*    FIELD VarselEutmeldt AS logical FORMAT 'Ja/Nei' LABEL 'Varsel E-utmeldt'                         */
/*    FIELD VarselMelding AS logical FORMAT 'yes/no' LABEL 'Varsel melding'                            */
/*    FIELD VarselRR-MS-Levert AS logical FORMAT 'yes/no'                                              */
/*    FIELD VarselRR-SMS-Levert AS logical FORMAT 'yes/no'                                             */
/*    FIELD VarsleDForum1 AS logical FORMAT 'Ja/Nei'                                                   */
/*    FIELD VarsleDForum2 AS logical FORMAT 'Ja/Nei'                                                   */
/*    FIELD VarsleRRAvvist AS character FORMAT 'x(8)'                                                  */
/*    FIELD VarsleRRmangler AS character FORMAT 'x(8)'                                                 */
/*    FIELD VarsleRRUtbet AS character FORMAT 'x(8)'                                                   */
      
  def temp-table ttSoknadTransType no-undo
    field iSoknadTransTypeId as int
    field SoknadTransType as char
    .
  def temp-table ttSoknadType no-undo
    field iSoknadTypeId as int
    field SoknadTypeTekst as char
    field SoknadTypeMerknad as char
    .
  def temp-table ttSoknadStatus no-undo
    field iSoknadStatusId as int
    field SoknadStatus as char
    .
  def temp-table ttSoknadTrans no-undo
    field iSoknadTransId as int
    field iSoknadId as int
    field medlemsnr as int
    field iSoknadTransTypeId as int
    field iSoknadTransBelop as dec
    field SoknadTransNotat as char
    field SoknadInnvilgetBelop as dec
    .
  def temp-table ttSoknad no-undo
    field iSoknadId as int
    field iSoknadTypeId as int
    field SoknadDato as date
    field SoknadTekst as char
    field SoknadFormaal as char
    field medlemsnr as int
    field SoknadAktiv as log
    field iSoknadStatusId as int
    field harUtgifterDekket as log
    field UtgifterDekketNotat as char
    .

  var longchar data.
    
  var handle bhMedlem.
  var int memberid.
  var class oo.Toolbox oTool.  
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  CONSTRUCTOR PUBLIC Members ():
    fix-codepage(Data) = 'UTF-8'.
    bhMedlem = temp-table ttMedlem:default-buffer-handle.
    oTool = new oo.Toolbox().
    
  END CONSTRUCTOR.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  CONSTRUCTOR PUBLIC Members (input ipMemberId as int):
    fix-codepage(Data) = 'UTF-8'.
    oTool = new oo.Toolbox().

    bhMedlem = temp-table ttMedlem:default-buffer-handle.

    memberid = ipMemberId.
    getMembers().

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN 
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH. 
  END CONSTRUCTOR.

/*  /*------------------------------------------------------------------------------                */
/*   Purpose:                                                                                       */
/*   Notes:                                                                                         */
/*  ------------------------------------------------------------------------------*/                */
/*  CONSTRUCTOR PUBLIC Members (input ipJsonObject as Progress.Json.ObjectModel.JsonObject):        */
/*    getMembers(ipJsonObject).                                                                     */
/*                                                                                                  */
/*    CATCH eAny AS Progress.Lang.Error :                                                           */
/*      ASSIGN                                                                                      */
/*        MessageCode   = eAny:GetMessageNum(1)                                                     */
/*        MessageStatus = eAny:GetMessage(1)                                                        */
/*        .                                                                                         */
/*      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').*/
/*    END CATCH.                                                                                    */
/*  END CONSTRUCTOR.                                                                                */

/*  /*------------------------------------------------------------------------------                */
/*   Purpose:                                                                                       */
/*   Notes:                                                                                         */
/*  ------------------------------------------------------------------------------*/                */
/*  METHOD PUBLIC VOID getMembers():                                                                */
/*    var CLASS JboxJSON oJS.                                                                       */
/*    var class parameter oParam.                                                                   */
/*                                                                                                  */
/*    var int i.                                                                                    */
/*                                                                                                  */
/*    def buffer medlem for medlem.                                                                 */
/*                                                                                                  */
/*    log-manager:write-message(subst('getMembers:memberid: &1',memberid),'debug').                 */
/*    for each medlem no-lock where Medlem.Medlemsnr = memberid: leave. end.                        */
/*                                                                                                  */
/*    buffer ttMedlem:buffer-create().                                                              */
/*    buffer ttMedlem:buffer-copy(buffer medlem:handle).                                            */
/*                                                                                                  */
/*    buffer ttMedlem:write-json('longchar',data).                                                  */
/*    oJS = NEW JboxJSON().                                                                         */
/*    oJS:buildJSON(Data).                                                                          */
/*    IF LENGTH(Data) GT 0 THEN DO:                                                                 */
/*      oJS:getArrayByField('ttMedlem').                                                            */
/*      JsonResult = oJS:oArray.                                                                    */
/*      RecordCount = oJS:oArray:Length.                                                            */
/*    END.                                                                                          */
/*                                                                                                  */
/*    CATCH eAny AS Progress.Lang.Error :                                                           */
/*      ASSIGN                                                                                      */
/*        MessageCode   = eAny:GetMessageNum(1)                                                     */
/*        MessageStatus = eAny:GetMessage(1)                                                        */
/*        .                                                                                         */
/*      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').*/
/*    END CATCH.                                                                                    */
/*                                                                                                  */
/*  END METHOD.                                                                                     */

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getMembers(input ipBody as Progress.Json.ObjectModel.JsonObject):
    var CLASS JboxJSON oJS.
    var class parameter oParam.
    var CLASS JBoxQuery oQuery.
    var date fdatoFra,fdatoTil.

    var int i.

    assign
      fdatoFra = ipBody:GetDate('fdatoFra')
      fdatoTil = ipBody:GetDate('fdatoTil')
      .
    oQuery = NEW JBoxQuery(subst('Medlem;&1',oTool:getBufferFields(buffer ttMedlem:handle,';') + ',avdeling;nr;navn,webbruker;medlemsnr;rr-mg-rolle')).
    oQuery:queryJoin = 'first avdeling no-lock where avdeling.nr = medlem.avdnr, first webbruker outer-join no-lock where webbruker.medlemsnr = medlem.medlemsnr'.
    if memberid gt 0 then 
      oQuery:setFilter('medlemsnr','=',string(memberid)).
    else 
      oQuery:setFilter('innmeldt,innmeldt','ge,le',string(fdatoFra) + '|' + string(fdatoTil)).

    oQuery:rowsToBatch = 0. /** Number in batch*/
    oQuery:getRecordCount = TRUE.
   
    oQuery:openQuery().
    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen medlemmer funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

MESSAGE 'filter:' 'innmeldt,innmeldt' 'ge,le' string(fdatoFra) + '|' + string(fdatoTil) 'medlemsnr:' memberid
VIEW-AS ALERT-BOX.
    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('Medlem').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getMembers():
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.
    var int i.

      if log-manager:logfile-name <> ? then log-manager:write-message('-->1','debug').
    oQuery = NEW JBoxQuery(subst('Medlem;&1',oTool:getBufferFields(buffer ttMedlem:handle,';') + ',avdeling;nr;navn,webbruker;medlemsnr;rr-mg-rolle')).
    oQuery:queryJoin = 'first avdeling no-lock where avdeling.nr = medlem.avdnr, first webbruker outer-join no-lock where webbruker.medlemsnr = medlem.medlemsnr'.
    if memberid gt 0 then 
      oQuery:setFilter('medlemsnr','=',string(memberid)).
    else 
      oQuery:setFilter('innmeldt,utmeldt','le,=',string(add-interval(today,24,'months')) + '|?').

    oQuery:rowsToBatch = 0. /** Number in batch*/
    oQuery:getRecordCount = TRUE.
   
/*      if log-manager:logfile-name <> ? then log-manager:write-message('-->1','debug').*/
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen medlemmer funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('Medlem').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getPositions():
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.

    var int i.

    oQuery = NEW JBoxQuery('Verv;Tekst;Gruppe;Sortering;VismaRolle;Til07;Send;RolleAktivitetModul;RollePFPL;RolleLafi;RolleLsi;Aktiv;RolleDiskusjon;Diskusjonsforum;VervNr;IntDForumForAvd;RolleKursmodulen;RolleRR;RolleKommunikasjon;RolleSivil;TilgangRessursDB;Viktighet;Kontaktperson;TilgangLokalRDB;RolleCovid;Stemmemodul;FS-protokoll;Rettighetsverv').
      oQuery:rowsToBatch = 0. /** Number in batch*/
      oQuery:getRecordCount = TRUE.
    oQuery:setFilter('aktiv','=','true').
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen verv funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('Verv').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getSoknadTransType():
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.

    var int i.

    oQuery = NEW JBoxQuery('SoknadTransType;iSoknadTransTypeId;SoknadTransType').
      oQuery:rowsToBatch = 0. /** Number in batch*/
      oQuery:getRecordCount = TRUE.
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen SoknadTransType funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadTransType').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getSoknadType():
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.

    var int i.

    oQuery = NEW JBoxQuery('SoknadType;iSoknadTypeId;SoknadTypeTekst;SoknadTypeMerknad').
      oQuery:rowsToBatch = 0. /** Number in batch*/
      oQuery:getRecordCount = TRUE.
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen SoknadType funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadType').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getSoknadStatus():
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.

    var int i.

    oQuery = NEW JBoxQuery('SoknadStatus;iSoknadStatusId;SoknadStatus').
      oQuery:rowsToBatch = 0. /** Number in batch*/
      oQuery:getRecordCount = TRUE.
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen SoknadStatus funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadStatus').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getSoknadTrans(input ipMemberId as int):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.

    var int i.

    oQuery = NEW JBoxQuery('SoknadTrans;iSoknadTransId;iSoknadId;medlemsnr;iSoknadTransTypeId;SoknadTransBelop;SoknadTransNotat;SoknadInnvilgetBelop').
    oQuery:setFilter('medlemsnr','=',string(ipMemberId)).
      oQuery:rowsToBatch = 0. /** Number in batch*/
      oQuery:getRecordCount = TRUE.
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen SoknadTrans funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadTrans').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getSoknad(input ipMemberId as int):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.

    var int i.

    oQuery = NEW JBoxQuery('Soknad;iSoknadId;iSoknadTypeId;SoknadDato;SoknadTekst;SoknadFormaal;medlemsnr;SoknadAktiv;iSoknadStatusId;harUtgifterDekket;UtgifterDekketNotat').
    oQuery:setFilter('medlemsnr','=',string(ipMemberId)).
    
      oQuery:rowsToBatch = 0. /** Number in batch*/
      oQuery:getRecordCount = TRUE.
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError('Ingen Soknad funnet',int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('Soknad').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID getPositions(input ipMemberId as int):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.
    var int i.
    
    memberid = ipMemberId.
    
//;Tekst;Gruppe;Sortering;VismaRolle;Til07;Send;RolleAktivitetModul;RollePFPL;RolleLafi;RolleLsi;Aktiv;RolleDiskusjon;Diskusjonsforum;VervNr;IntDForumForAvd;RolleKursmodulen;RolleRR;RolleKommunikasjon;RolleSivil;TilgangRessursDB;Viktighet;Kontaktperson;TilgangLokalRDB;RolleCovid;Stemmemodul;FS-protokoll;Rettighetsverv
    oQuery = NEW JBoxQuery('VervHist;Medlemsnr;Endret;Sign;Lagret;Tekst;FraDato;TilDato;Gruppe;AvdNr;SlettetAv;SlettetDato;Kommentar;Brukerdeklerasjon,verv;rettighetsverv').
    oQuery:queryJoin = 'first verv where verv.gruppe = vervhist.gruppe and verv.tekst = vervhist.tekst'.
    oQuery:setFilter('medlemsnr,tilDato,rettighetsverv','=,ge,=',string(memberid) + '|' + string(today,'99/99/9999') + '|false').
      oQuery:rowsToBatch = 0. /** Number in batch*/
      oQuery:getRecordCount = TRUE.
   
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError(subst('Ingen verv funnet for medlem: &1',memberid),int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('VervHist').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID putSoknadTransType(input ipBody as Progress.Json.ObjectModel.JsonObject):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.
    var int ii,iSoknadTransTypeId.
    
    empty temp-table ttSoknadTransType.

    do ii = 1 to ipBody:GetJsonArray('SoknadTransType'):Length:
      create ttSoknadTransType.
      buffer ttSoknadTransType:read-json('jsonobject',ipBody:GetJsonArray('SoknadTransType'):GetJsonObject(ii)).
    end.         
    for each ttSoknadTransType transaction:
      if ttSoknadTransType.SoknadTransType = '' then next.
      
      if ttSoknadTransType.iSoknadTransTypeId gt 0 then do:
        find first SoknadTransType where SoknadTransType.iSoknadTransTypeId = ttSoknadTransType.iSoknadTransTypeId no-error.
      end.
      else do:
      MESSAGE 'her1..' ttSoknadTransType.iSoknadTransTypeId ttSoknadTransType.SoknadTransType 
      VIEW-AS ALERT-BOX. 
        find first soknadtranstype where SoknadTransType.SoknadTransType = ttSoknadTransType.SoknadTransType no-error.
        if not avail SoknadTransType then 
          create SoknadTransType.
      end.        
      buffer-copy ttSoknadTransType except iSoknadTransTypeId to SoknadTransType.   
    end.
    
    oQuery = NEW JBoxQuery('SoknadTransType;iSoknadTransTypeId;SoknadTransType').

    oQuery:rowsToBatch = 0. /** Number in batch*/
    oQuery:getRecordCount = TRUE.
   
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError(subst('Ingen SoknadTransType funnet',''),int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadTransType').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID putSoknadType(input ipBody as Progress.Json.ObjectModel.JsonObject):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.
    var int ii,iSoknadTypeId.

    empty temp-table ttSoknadType.
    do ii = 1 to ipBody:GetJsonArray('SoknadType'):Length:
      create ttSoknadType.
      buffer ttSoknadType:read-json('jsonobject',ipBody:GetJsonArray('SoknadType'):GetJsonObject(ii)).
    end.         
    for each ttSoknadType transaction:
      if ttSoknadType.SoknadTypeTekst = '' then next.

      if ttSoknadType.iSoknadTypeId gt 0 then do:
        find first SoknadType where SoknadType.iSoknadTypeId = ttSoknadType.iSoknadTypeId no-error.
      end.
      else do:
        find first soknadtype where SoknadType.SoknadTypeTekst = ttSoknadType.SoknadTypeTekst no-error.
        if not avail SoknadType then 
          create SoknadType.
      end.        
      buffer-copy ttSoknadType except iSoknadTypeId to SoknadType.   
      CATCH eAny AS Progress.Lang.Error :
        MESSAGE 'feilet...' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.  
      END CATCH.
    end.
    
    oQuery = NEW JBoxQuery('SoknadType;iSoknadTypeId;SoknadTypeTekst;SoknadTypeMerknad').

    oQuery:rowsToBatch = 0. /** Number in batch*/
    oQuery:getRecordCount = TRUE.
   
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError(subst('Ingen SoknadType funnet',''),int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadType').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID putSoknadStatus(input ipBody as Progress.Json.ObjectModel.JsonObject):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.
    var int ii,iSoknadStatusId.

    empty temp-table ttSoknadStatus.
    do ii = 1 to ipBody:GetJsonArray('SoknadStatus'):Length:
      create ttSoknadStatus.
      buffer ttSoknadStatus:read-json('jsonobject',ipBody:GetJsonArray('SoknadStatus'):GetJsonObject(ii)).
    end.         
    for each ttSoknadStatus transaction:
      if ttSoknadStatus.SoknadStatus = '' then next.
            
      if ttSoknadStatus.iSoknadStatusId gt 0 then do:
        find first SoknadStatus where SoknadStatus.iSoknadStatusId = ttSoknadStatus.iSoknadStatusId no-error.
      end.
      else do:
        find first soknadStatus where SoknadStatus.SoknadStatus = ttSoknadStatus.SoknadStatus no-error.
        if not avail SoknadStatus then 
          create SoknadStatus.
      end.        
      if not avail Soknadstatus then next.
      buffer-copy ttSoknadStatus except iSoknadStatusId to SoknadStatus.   
      CATCH eAny AS Progress.Lang.Error :
        MESSAGE 'feilet...' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.  
      END CATCH.
    end.
    
    oQuery = NEW JBoxQuery('SoknadStatus;iSoknadStatusId;SoknadStatus').

    oQuery:rowsToBatch = 0. /** Number in batch*/
    oQuery:getRecordCount = TRUE.
   
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError(subst('Ingen SoknadStatus funnet',''),int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadStatus').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID putSoknadTrans(input ipBody as Progress.Json.ObjectModel.JsonObject):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.
    var int ii,iSoknadTransId.

    empty temp-table ttSoknadTrans.
    do ii = 1 to ipBody:GetJsonArray('SoknadTrans'):Length:
      create ttSoknadTrans.
      buffer ttSoknadTrans:read-json('jsonobject',ipBody:GetJsonArray('SoknadTrans'):GetJsonObject(ii)).
    end.         
    for each ttSoknadTrans transaction:
      if ttSoknadTrans.iSoknadId = 0 then next.
      
      if ttSoknadTrans.iSoknadTransId gt 0 then do:
        find first SoknadTrans where SoknadTrans.iSoknadTransId = ttSoknadtrans.iSoknadTransId no-error.
      end.
      else do:
        for each soknadTrans where SoknadTrans.iSoknadId = ttSoknadTrans.iSoknadId
                               and SoknadTrans.iSoknadTransTypeId = ttSoknadTrans.iSoknadTransTypeId: leave. end.
        if not avail SoknadTrans then 
          create SoknadTrans.
      end.        
      if not avail SoknadTrans then next.
      buffer-copy ttSoknadTrans except iSoknadTransId to SoknadTrans.   
      CATCH eAny AS Progress.Lang.Error :
        MESSAGE 'feilet...' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.  
      END CATCH.
    end.
    
    oQuery = NEW JBoxQuery('SoknadTrans;iSoknadTransId;iSoknadId;medlemsnr;iSoknadTransTypeId;SoknadTransBelop;SoknadTransNotat;SoknadInnvilgetBelop').

    oQuery:rowsToBatch = 0. /** Number in batch*/
    oQuery:getRecordCount = TRUE.
   
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError(subst('Ingen SoknadTranss funnet',''),int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('SoknadTrans').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  METHOD PUBLIC VOID putSoknad(input ipBody as Progress.Json.ObjectModel.JsonObject):
    var CLASS JboxJSON oJS.
    var CLASS JBoxQuery oQuery.
    var class parameter oParam.
    var int ii,iSoknadId.

    empty temp-table ttSoknad.
    do ii = 1 to ipBody:GetJsonArray('Soknad'):Length:
      create ttSoknad.
      buffer ttSoknad:read-json('jsonobject',ipBody:GetJsonArray('Soknad'):GetJsonObject(ii)).
    end.         
    for each ttSoknad transaction:
      if ttSoknad.medlemsnr = 0 then next.

      if ttSoknad.iSoknadId gt 0 then do:
        find first Soknad where Soknad.iSoknadId = ttSoknad.iSoknadId no-error.
      end.
      else do:
        for each soknad where soknad.medlemsnr  = ttSoknad.medlemsnr
                          and soknad.SoknadDato = ttSoknad.SoknadDato: leave. end. 
        if not avail soknad then
          create Soknad.
      end.        
      if not avail Soknad then next.
      buffer-copy ttSoknad except iSoknadId to Soknad.   
      CATCH eAny AS Progress.Lang.Error :
        MESSAGE 'feilet...' eAny:GetMessage(1)
        VIEW-AS ALERT-BOX.  
      END CATCH.
    end.
    
    oQuery = NEW JBoxQuery('Soknad;iSoknadId;iSoknadTypeId;SoknadDato;SoknadTekst;SoknadFormaal;medlemsnr;SoknadAktiv;iSoknadStatusId;harUtgifterDekket;UtgifterDekketNotat').

    oQuery:rowsToBatch = 0. /** Number in batch*/
    oQuery:getRecordCount = TRUE.
   
    oQuery:openQuery().

    if not oQuery:BUFFER-HANDLE:avail then
      undo, throw new Progress.Lang.AppError(subst('Ingen Soknad funnet',''),int(OpenEdge.Net.HTTP.StatusCodeEnum:NotFound)).

    oQuery:buffer-handle:write-json('longchar',Data).

    oJS = NEW JboxJSON().
    oJS:buildJSON(Data).
    IF LENGTH(Data) GT 0 THEN DO:
      oJS:getArrayByField('Soknad').
      JsonResult = oJS:oArray.
      RecordCount = oJS:oArray:Length.
      
      if log-manager:logfile-name <> ? then log-manager:write-message(subst('lengde...&1',RecordCount),'debug').
    END.

    CATCH eAny AS Progress.Lang.Error :
      ASSIGN
        MessageCode   = eAny:GetMessageNum(1)
        MessageStatus = eAny:GetMessage(1)
        .
      
      if log-manager:logfile-name <> ? then log-manager:write-message(eAny:GetMessage(1),'ERROR').
    END CATCH.

  END METHOD.

END CLASS.

