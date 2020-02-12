&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description:        Container for a JukeBox window program

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            brynjar@chemistry.no

  Created:           18.oct.2006

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.


/* ***************************  Definitions  ************************** */
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   
/* Uncomment to enable use of .Net components: */
/* &SCOPED-DEFINE AdvGuiWin */ 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEFINE VARIABLE bOk            AS LOG           NO-UNDO.
DEFINE VARIABLE ix             AS INTEGER       NO-UNDO.
DEFINE VARIABLE hBrowse        AS HANDLE        NO-UNDO.
DEFINE VARIABLE hQuery         AS HANDLE        NO-UNDO.
DEFINE VARIABLE hToolbar       AS HANDLE        NO-UNDO.
DEFINE VARIABLE hFieldMap      AS HANDLE        NO-UNDO.
DEFINE VARIABLE oContainer     AS JBoxContainer NO-UNDO.

DEFINE VARIABLE oCMD           AS JBoxCMD       NO-UNDO.

DEFINE VARIABLE cFirmaLogo  AS CHARACTER INIT ".\img\norshuntlogo.jpg" NO-UNDO.  
def var iLeftColumn as int no-undo.

/*** Start instance property definitions for JBoxBrowse object oBrwNPSPTILBUD ***/
DEFINE VARIABLE oBrwNPSPTILBUD AS JBoxBrowse    NO-UNDO.
DEFINE TEMP-TABLE NPSPTILBUD
  FIELD anleggsnr            AS INTEGER
  FIELD avgittpris           AS DECIMAL
  FIELD bet_bet              AS CHARACTER
  FIELD deres_ref            AS CHARACTER
  FIELD gyldighetstid        AS INTEGER
  FIELD id                   AS INTEGER
  FIELD kundenr              AS CHARACTER
  FIELD lev_bet              AS CHARACTER
  FIELD opplysninger         AS CHARACTER
  FIELD pris                 AS DECIMAL
  FIELD rabatt%              AS DECIMAL
  FIELD tilbudsdato          AS DATE
  FIELD tilbudsid            AS INTEGER
  FIELD tilbudsnr            AS CHARACTER
  FIELD vaar_ref             AS CHARACTER
  FIELD aktivt               AS LOGICAL
  FIELD anbudsfrist          AS DATE
  FIELD anlegg               AS CHARACTER
  FIELD anleggsnr2           AS INTEGER
  FIELD arkivnr              AS CHARACTER
  FIELD beskrevet            AS CHARACTER
  FIELD byggestart           AS DATE
  FIELD dato                 AS DATE
  FIELD endrings_laas        AS LOGICAL
  FIELD entreprise           AS CHARACTER
  FIELD konsulentens_saksbeh AS CHARACTER
  FIELD konsulentid          AS INTEGER
  FIELD kundenr2             AS CHARACTER
  FIELD leveringsdato        AS DATE
  FIELD leveringstid         AS CHARACTER
  FIELD oppf_aar             AS INTEGER
  FIELD oppf_uke             AS INTEGER
  FIELD opplysninger2        AS CHARACTER
  FIELD ordre                AS LOGICAL
  FIELD prosjektid           AS INTEGER
  FIELD referanse_tekst      AS CHARACTER
  FIELD saksbehandler        AS CHARACTER
  FIELD salgsdistrikt        AS CHARACTER
  FIELD selger               AS CHARACTER
  FIELD sikker               AS LOGICAL
  FIELD standardpris         AS DECIMAL
  FIELD adresse1             AS CHARACTER
  FIELD adresse2             AS CHARACTER
  FIELD aktiv                AS LOGICAL
  FIELD avdeling             AS CHARACTER
  FIELD avtale               AS CHARACTER
  FIELD dm_kode              AS CHARACTER
  FIELD er_konsulent         AS LOGICAL
  FIELD fax                  AS CHARACTER
  FIELD fylke                AS CHARACTER
  FIELD katalog_np_antall    AS INTEGER
  FIELD katalog_np_dato      AS DATE
  FIELD katalog_np_oppdatert AS DATE
  FIELD katalog_np_type      AS CHARACTER
  FIELD katalog_nt_antall    AS INTEGER
  FIELD katalog_nt_dato      AS DATE
  FIELD katalog_nt_oppdatert AS DATE
  FIELD katalog_nt_type      AS CHARACTER
  FIELD kilde                AS CHARACTER
  FIELD konsulentnr          AS INTEGER
  FIELD kontaktperson_np     AS CHARACTER
  FIELD kontaktperson_nt     AS CHARACTER
  FIELD kontor_type          AS CHARACTER
  FIELD kundedistrikt        AS CHARACTER
  FIELD kundekategori        AS CHARACTER
  FIELD kundenavn            AS CHARACTER
  FIELD kundenr3             AS CHARACTER
  FIELD kundenr_de           AS CHARACTER
  FIELD kundenr_i            AS INTEGER
  FIELD kundenr_sp           AS CHARACTER
  FIELD land                 AS CHARACTER
  FIELD mobil                AS CHARACTER
  FIELD organisasjon         AS CHARACTER
  FIELD postnr               AS CHARACTER
  FIELD poststed             AS CHARACTER
  FIELD rabatt%_1            AS DECIMAL
  FIELD rabatt%_2            AS DECIMAL
  FIELD sist_oppdatert       AS DATE
  FIELD telefon              AS CHARACTER
  FIELD tilbudsmottager      AS LOGICAL
  FIELD bVAT                 AS LOGICAL
  FIELD cAddress1            AS CHARACTER
  FIELD cAddress2            AS CHARACTER
  FIELD cBankAccount         AS CHARACTER
  FIELD cCity                AS CHARACTER
  FIELD cCompanyLogo         AS CHARACTER
  FIELD cCompanyName         AS CHARACTER
  FIELD cCountry             AS CHARACTER
  FIELD cCreatedBy           AS CHARACTER
  FIELD cEmail               AS CHARACTER
  FIELD cEmail2              AS CHARACTER
  FIELD cFax                 AS CHARACTER
  FIELD cModifiedBy          AS CHARACTER
  FIELD cPostalCode          AS CHARACTER
  FIELD cState               AS CHARACTER
  FIELD cTlfHome             AS CHARACTER
  FIELD cTlfMob              AS CHARACTER
  FIELD cTlfWrk              AS CHARACTER
  FIELD cURL                 AS CHARACTER
  FIELD cURL2                AS CHARACTER
  FIELD cVat                 AS CHARACTER
  FIELD dCreated             AS DATE
  FIELD dModified            AS DATE
  FIELD iJBoxCompanyId       AS INTEGER
  FIELD RowIdent1            AS CHARACTER 
  FIELD RowIdent2            AS CHARACTER 
  FIELD RowIdent3            AS CHARACTER 
  FIELD RowIdent4            AS CHARACTER 
  FIELD RowCount             AS INTEGER
  FIELD jbCountDistinct      AS INTEGER   FORMAT '>>>,>>>,>>9' INIT 1
  FIELD jbAverage            AS DECIMAL   FORMAT '->>>,>>>,>>9.99'
  INDEX idxRowids RowIdent1 RowIdent2 RowIdent3 RowIdent4
  .
DEFINE BUFFER v_NPSPTILBUD FOR TEMP-TABLE NPSPTILBUD.




/* ************************  Function Implementations ***************** */
FUNCTION getBuffersAndFieldsBrwNPSPTILBUD RETURNS CHARACTER():
  RETURN
    'NPSPTILBUD'
    + ';anleggsnr'
    + ';avgittpris'
    + ';bet_bet'
    + ';deres_ref'
    + ';gyldighetstid'
    + ';id'
    + ';kundenr'
    + ';lev_bet'
    + ';opplysninger'
    + ';pris'
    + ';rabatt%'
    + ';tilbudsdato'
    + ';tilbudsid'
    + ';tilbudsnr'
    + ';vaar_ref'
    + ',NPSPANLG'
    + ';aktivt'
    + ';anbudsfrist'
    + ';anlegg'
    + ';anleggsnr'
    + ';arkivnr'
    + ';beskrevet'
    + ';byggestart'
    + ';dato'
    + ';endrings_laas'
    + ';entreprise'
    + ';konsulentens_saksbeh'
    + ';konsulentid'
    + ';kundenr'
    + ';leveringsdato'
    + ';leveringstid'
    + ';oppf_aar'
    + ';oppf_uke'
    + ';opplysninger'
    + ';ordre'
    + ';prosjektid'
    + ';referanse_tekst'
    + ';saksbehandler'
    + ';salgsdistrikt'
    + ';selger'
    + ';sikker'
    + ';standardpris'
    + ',NPKUNDE'
    + ';adresse1'
    + ';adresse2'
    + ';aktiv'
    + ';avdeling'
    + ';avtale'
    + ';dm_kode'
    + ';er_konsulent'
    + ';fax'
    + ';fylke'
    + ';katalog_np_antall'
    + ';katalog_np_dato'
    + ';katalog_np_oppdatert'
    + ';katalog_np_type'
    + ';katalog_nt_antall'
    + ';katalog_nt_dato'
    + ';katalog_nt_oppdatert'
    + ';katalog_nt_type'
    + ';kilde'
    + ';konsulentnr'
    + ';kontaktperson_np'
    + ';kontaktperson_nt'
    + ';kontor_type'
    + ';kundedistrikt'
    + ';kundekategori'
    + ';kundenavn'
    + ';kundenr'
    + ';kundenr_de'
    + ';kundenr_i'
    + ';kundenr_sp'
    + ';land'
    + ';mobil'
    + ';organisasjon'
    + ';postnr'
    + ';poststed'
    + ';rabatt%_1'
    + ';rabatt%_2'
    + ';sist_oppdatert'
    + ';telefon'
    + ';tilbudsmottager'
    + ',JBoxCompany'
    + ';bVAT'
    + ';cAddress1'
    + ';cAddress2'
    + ';cBankAccount'
    + ';cCity'
    + ';cCompanyLogo'
    + ';cCompanyName'
    + ';cCountry'
    + ';cCreatedBy'
    + ';cEmail'
    + ';cEmail2'
    + ';cFax'
    + ';cModifiedBy'
    + ';cPostalCode'
    + ';cState'
    + ';cTlfHome'
    + ';cTlfMob'
    + ';cTlfWrk'
    + ';cURL'
    + ';cURL2'
    + ';cVat'
    + ';dCreated'
    + ';dModified'
    + ';iJBoxCompanyId'
    .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPTILBUD RETURNS CHARACTER():
  RETURN 'EACH NPSPANLG OF NPSPTILBUD NO-LOCK,EACH NPKUNDE OF NPSPTILBUD NO-LOCK,EACH JBoxCompany  WHERE iJboxCompanyId = 1 NO-LOCK'.
END FUNCTION.

FUNCTION setBaseQuery RETURNS LOGICAL 
  ( ipWhere AS CHARACTER ):
  /*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  oBrwNPSPTILBUD:baseQuery = ipWhere.
  oBrwNPSPTILBUD:openQuery().
END FUNCTION.
        
DEFINE VARIABLE otbNPSPTILBUD AS JBoxToolbar NO-UNDO.


/*** Start instance property definitions for JBoxBrowse object oBrwNPSPSYST ***/
DEFINE VARIABLE oBrwNPSPSYST  AS JBoxBrowse  NO-UNDO.
DEF TEMP-TABLE NPSPSYST
    FIELD anbefalt_max_kap AS DECIMAL
    FIELD anb_max_innl_hast AS CHARACTER
    FIELD anleggsnr AS INTEGER
    FIELD anslutning AS CHARACTER
    FIELD antall AS INTEGER
    FIELD avstand_flotor AS INTEGER
    FIELD beregnet_anvendelse AS CHARACTER
    FIELD dimmensjon AS CHARACTER
    FIELD faktor AS DECIMAL
    FIELD glykoltype AS CHARACTER
    FIELD innl_hastighet AS DECIMAL
    FIELD innmat AS CHARACTER
    FIELD isolasjon AS CHARACTER
    FIELD konsentrasjon AS CHARACTER
    FIELD kuleventil_ja_nei AS LOGICAL
    FIELD kuleventil_verdi AS CHARACTER
    FIELD listepris AS DECIMAL
    FIELD materialkvaliteter AS CHARACTER
    FIELD max_temp AS INTEGER
    FIELD max_trykk AS DECIMAL
    FIELD medietemperatur AS CHARACTER
    FIELD motflenser AS LOGICAL
    FIELD nrf_nr AS INTEGER
    FIELD produktnavn AS CHARACTER
    FIELD produkttype AS CHARACTER
    FIELD refill AS LOGICAL
    FIELD ror_dim AS DECIMAL
    FIELD spiroventkapasitet AS DECIMAL
    FIELD systembetegnelse AS CHARACTER
    FIELD systemnr AS INTEGER
    FIELD trykkfall AS DECIMAL
    FIELD utv_gjengeventil AS LOGICAL
    FIELD varenr AS INTEGER
    FIELD vegg_tykkelse AS DECIMAL
    FIELD anslutning2 AS character
    FIELD avstand_flotor2 AS integer
    FIELD avt_plugg AS character
    FIELD bredde AS integer
    FIELD df_diameter AS integer
    FIELD diameter AS decimal
    FIELD dimmensjon2 AS character
    FIELD dybde AS integer
    FIELD fast_tekst AS character
    FIELD H AS integer
    FIELD H1 AS integer
    FIELD H2 AS integer
    FIELD hoyde AS integer
    FIELD hurtigventil AS logical
    FIELD h_0 AS integer
    FIELD h_1 AS integer
    FIELD h_2 AS integer
    FIELD innmat2 AS character
    FIELD kapasitet AS decimal
    FIELD kuleventil AS character
    FIELD kv_verdi AS decimal
    FIELD L AS integer
    FIELD LF AS integer
    FIELD l_lufteventil AS integer
    FIELD materialkvaliteter2 AS character
    FIELD max_temp2 AS integer
    FIELD max_trykk2 AS decimal
    FIELD nrf_nr2 AS integer
    FIELD pris AS decimal
    FIELD produktnavn2 AS character
    FIELD ror_dim2 AS decimal
    FIELD service_plass_over AS integer
    FIELD service_plass_under AS integer
    FIELD tegnings_ref AS character
    FIELD utv_volum AS decimal
    FIELD varenr2 AS integer
    FIELD vegg_tykkelse2 AS decimal
    FIELD vekt AS decimal
    FIELD volum AS decimal
    FIELD RowIdent1 AS CHARACTER 
    FIELD RowIdent2 AS CHARACTER 
    FIELD RowCount AS INTEGER
    FIELD jbCountDistinct AS INTEGER FORMAT '>>>,>>>,>>9' INIT 1
    FIELD jbAverage AS DECIMAL FORMAT '->>>,>>>,>>9.99'
    INDEX idxRowids  RowIdent1 RowIdent2
  .
DEFINE BUFFER v_NPSPSYST FOR TEMP-TABLE NPSPSYST.


FUNCTION getBuffersAndFieldsBrwNPSPSYST RETURNS CHARACTER():
  RETURN
    'NPSPSYST'
     + ';anbefalt_max_kap'
     + ';anb_max_innl_hast'
     + ';anleggsnr'
     + ';anslutning'
     + ';antall'
     + ';avstand_flotor'
     + ';beregnet_anvendelse'
     + ';dimmensjon'
     + ';faktor'
     + ';glykoltype'
     + ';innl_hastighet'
     + ';innmat'
     + ';isolasjon'
     + ';konsentrasjon'
     + ';kuleventil_ja_nei'
     + ';kuleventil_verdi'
     + ';listepris'
     + ';materialkvaliteter'
     + ';max_temp'
     + ';max_trykk'
     + ';medietemperatur'
     + ';motflenser'
     + ';nrf_nr'
     + ';produktnavn'
     + ';produkttype'
     + ';refill'
     + ';ror_dim'
     + ';spiroventkapasitet'
     + ';systembetegnelse'
     + ';systemnr'
     + ';trykkfall'
     + ';utv_gjengeventil'
     + ';varenr'
     + ';vegg_tykkelse'
  + ',NPSPVARELISTE'
     + ';anslutning'
     + ';avstand_flotor'
     + ';avt_plugg'
     + ';bredde'
     + ';df_diameter'
     + ';diameter'
     + ';dimmensjon'
     + ';dybde'
     + ';fast_tekst'
     + ';H'
     + ';H1'
     + ';H2'
     + ';hoyde'
     + ';hurtigventil'
     + ';h_0'
     + ';h_1'
     + ';h_2'
     + ';innmat'
     + ';kapasitet'
     + ';kuleventil'
     + ';kv_verdi'
     + ';L'
     + ';LF'
     + ';l_lufteventil'
     + ';materialkvaliteter'
     + ';max_temp'
     + ';max_trykk'
     + ';nrf_nr'
     + ';pris'
     + ';produktnavn'
     + ';ror_dim'
     + ';service_plass_over'
     + ';service_plass_under'
     + ';tegnings_ref'
     + ';utv_volum'
     + ';varenr'
     + ';vegg_tykkelse'
     + ';vekt'
     + ';volum'
     .
END FUNCTION.
FUNCTION getQueryJoinBrwNPSPSYST RETURNS CHARACTER():
  RETURN 'EACH NPSPVARELISTE OF NPSPSYST NO-LOCK'.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BrwNPSPSYST

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSPSYST NPSPTILBUD

/* Definitions for BROWSE BrwNPSPSYST                                   */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPSYST NPSPSYST.anbefalt_max_kap ~
NPSPSYST.anb_max_innl_hast NPSPSYST.anleggsnr NPSPSYST.anslutning ~
NPSPSYST.antall NPSPSYST.avstand_flotor NPSPSYST.beregnet_anvendelse ~
NPSPSYST.dimmensjon NPSPSYST.faktor NPSPSYST.glykoltype ~
NPSPSYST.innl_hastighet NPSPSYST.innmat NPSPSYST.isolasjon ~
NPSPSYST.konsentrasjon NPSPSYST.kuleventil_ja_nei NPSPSYST.kuleventil_verdi ~
NPSPSYST.listepris NPSPSYST.materialkvaliteter NPSPSYST.max_temp ~
NPSPSYST.max_trykk NPSPSYST.medietemperatur NPSPSYST.motflenser ~
NPSPSYST.nrf_nr NPSPSYST.produktnavn NPSPSYST.produkttype NPSPSYST.refill ~
NPSPSYST.ror_dim NPSPSYST.spiroventkapasitet NPSPSYST.systembetegnelse ~
NPSPSYST.systemnr NPSPSYST.trykkfall NPSPSYST.utv_gjengeventil ~
NPSPSYST.varenr NPSPSYST.vegg_tykkelse NPSPSYST.anslutning2 ~
NPSPSYST.avstand_flotor2 NPSPSYST.avt_plugg NPSPSYST.bredde ~
NPSPSYST.df_diameter NPSPSYST.diameter NPSPSYST.dimmensjon2 NPSPSYST.dybde ~
NPSPSYST.fast_tekst NPSPSYST.H NPSPSYST.H1 NPSPSYST.H2 NPSPSYST.hoyde ~
NPSPSYST.hurtigventil NPSPSYST.h_0 NPSPSYST.h_1 NPSPSYST.h_2 ~
NPSPSYST.innmat2 NPSPSYST.kapasitet NPSPSYST.kuleventil NPSPSYST.kv_verdi ~
NPSPSYST.L NPSPSYST.LF NPSPSYST.l_lufteventil NPSPSYST.materialkvaliteter2 ~
NPSPSYST.max_temp2 NPSPSYST.max_trykk2 NPSPSYST.nrf_nr2 NPSPSYST.pris ~
NPSPSYST.produktnavn2 NPSPSYST.ror_dim2 NPSPSYST.service_plass_over ~
NPSPSYST.service_plass_under NPSPSYST.tegnings_ref NPSPSYST.utv_volum ~
NPSPSYST.varenr2 NPSPSYST.vegg_tykkelse2 NPSPSYST.vekt NPSPSYST.volum 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPSYST ~
NPSPSYST.anbefalt_max_kap 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSPSYST NPSPSYST
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSPSYST NPSPSYST
&Scoped-define QUERY-STRING-BrwNPSPSYST FOR EACH NPSPSYST NO-LOCK, ~
    EACH NPSPVARELISTE OF NPSPSYST NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPSYST OPEN QUERY BrwNPSPSYST FOR EACH NPSPSYST NO-LOCK, ~
    EACH NPSPVARELISTE OF NPSPSYST NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPSYST NPSPSYST
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPSYST NPSPSYST


/* Definitions for BROWSE BrwNPSPTILBUD                                 */
&Scoped-define FIELDS-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD.anleggsnr ~
NPSPTILBUD.avgittpris NPSPTILBUD.bet_bet NPSPTILBUD.deres_ref ~
NPSPTILBUD.gyldighetstid NPSPTILBUD.id NPSPTILBUD.kundenr ~
NPSPTILBUD.lev_bet NPSPTILBUD.opplysninger NPSPTILBUD.pris ~
NPSPTILBUD.rabatt% NPSPTILBUD.tilbudsdato NPSPTILBUD.tilbudsid ~
NPSPTILBUD.tilbudsnr NPSPTILBUD.vaar_ref NPSPTILBUD.aktivt ~
NPSPTILBUD.anbudsfrist NPSPTILBUD.anlegg NPSPTILBUD.anleggsnr2 ~
NPSPTILBUD.arkivnr NPSPTILBUD.beskrevet NPSPTILBUD.byggestart ~
NPSPTILBUD.dato NPSPTILBUD.endrings_laas NPSPTILBUD.entreprise ~
NPSPTILBUD.konsulentens_saksbeh NPSPTILBUD.konsulentid NPSPTILBUD.kundenr2 ~
NPSPTILBUD.leveringsdato NPSPTILBUD.leveringstid NPSPTILBUD.oppf_aar ~
NPSPTILBUD.oppf_uke NPSPTILBUD.opplysninger2 NPSPTILBUD.ordre ~
NPSPTILBUD.prosjektid NPSPTILBUD.referanse_tekst NPSPTILBUD.saksbehandler ~
NPSPTILBUD.salgsdistrikt NPSPTILBUD.selger NPSPTILBUD.sikker ~
NPSPTILBUD.standardpris NPSPTILBUD.adresse1 NPSPTILBUD.adresse2 ~
NPSPTILBUD.aktiv NPSPTILBUD.avdeling NPSPTILBUD.avtale NPSPTILBUD.dm_kode ~
NPSPTILBUD.er_konsulent NPSPTILBUD.fax NPSPTILBUD.fylke ~
NPSPTILBUD.katalog_np_antall NPSPTILBUD.katalog_np_dato ~
NPSPTILBUD.katalog_np_oppdatert NPSPTILBUD.katalog_np_type ~
NPSPTILBUD.katalog_nt_antall NPSPTILBUD.katalog_nt_dato ~
NPSPTILBUD.katalog_nt_oppdatert NPSPTILBUD.katalog_nt_type NPSPTILBUD.kilde ~
NPSPTILBUD.konsulentnr NPSPTILBUD.kontaktperson_np ~
NPSPTILBUD.kontaktperson_nt NPSPTILBUD.kontor_type NPSPTILBUD.kundedistrikt ~
NPSPTILBUD.kundekategori NPSPTILBUD.kundenavn NPSPTILBUD.kundenr3 ~
NPSPTILBUD.kundenr_de NPSPTILBUD.kundenr_i NPSPTILBUD.kundenr_sp ~
NPSPTILBUD.land NPSPTILBUD.mobil NPSPTILBUD.organisasjon NPSPTILBUD.postnr ~
NPSPTILBUD.poststed NPSPTILBUD.rabatt%_1 NPSPTILBUD.rabatt%_2 ~
NPSPTILBUD.sist_oppdatert NPSPTILBUD.telefon NPSPTILBUD.tilbudsmottager ~
NPSPTILBUD.bVAT NPSPTILBUD.cAddress1 NPSPTILBUD.cAddress2 ~
NPSPTILBUD.cBankAccount NPSPTILBUD.cCity NPSPTILBUD.cCompanyLogo ~
NPSPTILBUD.cCompanyName NPSPTILBUD.cCountry NPSPTILBUD.cCreatedBy ~
NPSPTILBUD.cEmail NPSPTILBUD.cEmail2 NPSPTILBUD.cFax NPSPTILBUD.cModifiedBy ~
NPSPTILBUD.cPostalCode NPSPTILBUD.cState NPSPTILBUD.cTlfHome ~
NPSPTILBUD.cTlfMob NPSPTILBUD.cTlfWrk NPSPTILBUD.cURL NPSPTILBUD.cURL2 ~
NPSPTILBUD.cVat NPSPTILBUD.dCreated NPSPTILBUD.dModified ~
NPSPTILBUD.iJBoxCompanyId 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD.anleggsnr 
&Scoped-define ENABLED-TABLES-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD
&Scoped-define QUERY-STRING-BrwNPSPTILBUD FOR EACH NPSPTILBUD NO-LOCK, ~
    EACH NPSPANLG OF NPSPTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSPTILBUD NO-LOCK, ~
    EACH JBoxCompany WHERE iJboxCompanyId = 1 NO-LOCK INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-BrwNPSPTILBUD OPEN QUERY BrwNPSPTILBUD FOR EACH NPSPTILBUD NO-LOCK, ~
    EACH NPSPANLG OF NPSPTILBUD NO-LOCK, ~
    EACH NPKUNDE OF NPSPTILBUD NO-LOCK, ~
    EACH JBoxCompany WHERE iJboxCompanyId = 1 NO-LOCK INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD
&Scoped-define FIRST-TABLE-IN-QUERY-BrwNPSPTILBUD NPSPTILBUD


/* Definitions for FRAME DEFAULT-FRAME                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS tbNPSPTILBUD refresh_tbNPSPTILBUD ~
filter_tbNPSPTILBUD browseconfig_tbNPSPTILBUD excel_tbNPSPTILBUD ~
PrintPDFteknisk_tbNPSPTILBUD PrintPDF_tbNPSPTILBUD BrwNPSPTILBUD ~
BrwNPSPSYST 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/table.ico":U
     LABEL "Column setup" 
     SIZE 7.8 BY 1.95 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON excel_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/excel.ico":U
     LABEL "Excel" 
     SIZE 7.8 BY 1.95 TOOLTIP "Excel (ALT-E)".

DEFINE BUTTON filter_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_find.ico":U
     LABEL "Filter" 
     SIZE 7.8 BY 1.95 TOOLTIP "Filter (CTRL-F)".

DEFINE BUTTON PrintPDFteknisk_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/purchase_order.ico":U
     LABEL "Teknisk PDF" 
     SIZE 7.8 BY 1.95.

DEFINE BUTTON PrintPDF_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/print_layout_single.ico":U
     LABEL "Print PDF" 
     SIZE 7.8 BY 1.95.

DEFINE BUTTON refresh_tbNPSPTILBUD 
     IMAGE-UP FILE "img/ico/document_refresh.ico":U
     LABEL "Refresh" 
     SIZE 7.8 BY 1.95 TOOLTIP "Refresh (F5)".

DEFINE RECTANGLE tbNPSPTILBUD
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 126 BY 2.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BrwNPSPSYST FOR 
      NPSPSYST SCROLLING.

DEFINE QUERY BrwNPSPTILBUD FOR 
      NPSPTILBUD SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BrwNPSPSYST
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPSYST C-Win _STRUCTURED
  QUERY BrwNPSPSYST NO-LOCK DISPLAY
      NPSPSYST.anbefalt_max_kap COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSPSYST.anb_max_innl_hast COLUMN-LABEL "Anb. max innl. hast." FORMAT "X(5)":U
      NPSPSYST.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPSYST.anslutning COLUMN-LABEL "Anslutning" FORMAT "X(18)":U
      NPSPSYST.antall COLUMN-LABEL "Antall" FORMAT ">>9":U
      NPSPSYST.avstand_flotor COLUMN-LABEL "Avstand flotør" FORMAT ">>9":U
      NPSPSYST.beregnet_anvendelse COLUMN-LABEL "Anvendelse" FORMAT "X(18)":U
      NPSPSYST.dimmensjon COLUMN-LABEL "Dimm." FORMAT "X(45)":U
      NPSPSYST.faktor COLUMN-LABEL "Faktor" FORMAT "9.999":U
      NPSPSYST.glykoltype COLUMN-LABEL "Glyk.type" FORMAT "X(20)":U
      NPSPSYST.innl_hastighet COLUMN-LABEL "Innl.hast." FORMAT "9.99":U
      NPSPSYST.innmat COLUMN-LABEL "Innmat" FORMAT "X(25)":U
      NPSPSYST.isolasjon COLUMN-LABEL "Mantel/Isolasjon" FORMAT "X(18)":U
      NPSPSYST.konsentrasjon COLUMN-LABEL "Kons." FORMAT "X(8)":U
      NPSPSYST.kuleventil_ja_nei COLUMN-LABEL "Kuleventil" FORMAT "ja/nei":U
      NPSPSYST.kuleventil_verdi COLUMN-LABEL "Kuleventil" FORMAT "X(5)":U
      NPSPSYST.listepris COLUMN-LABEL "Listepris" FORMAT ">>,>>>,>>9.99":U
      NPSPSYST.materialkvaliteter COLUMN-LABEL "Materialkval." FORMAT "X(25)":U
      NPSPSYST.max_temp COLUMN-LABEL "Max temp." FORMAT ">>9":U
      NPSPSYST.max_trykk COLUMN-LABEL "Max trykk" FORMAT ">>>9.9<":U
      NPSPSYST.medietemperatur COLUMN-LABEL "Med. temp" FORMAT "X(5)":U
      NPSPSYST.motflenser COLUMN-LABEL "Motflenser" FORMAT "ja/nei":U
      NPSPSYST.nrf_nr COLUMN-LABEL "NRF" FORMAT "9999999":U
      NPSPSYST.produktnavn COLUMN-LABEL "Produktnavn" FORMAT "X(45)":U
      NPSPSYST.produkttype COLUMN-LABEL "Produkttype" FORMAT "X(45)":U
      NPSPSYST.refill COLUMN-LABEL "Refill" FORMAT "ja/nei":U
      NPSPSYST.ror_dim COLUMN-LABEL "Rørdim." FORMAT ">>9.99":U
      NPSPSYST.spiroventkapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSPSYST.systembetegnelse COLUMN-LABEL "Syst.bet." FORMAT "X(40)":U
      NPSPSYST.systemnr COLUMN-LABEL "Systemnr" FORMAT ">>>>>9":U
      NPSPSYST.trykkfall COLUMN-LABEL "Trykkfall" FORMAT ">,>>9.99":U
      NPSPSYST.utv_gjengeventil COLUMN-LABEL "Utv. gjenget lufteventil" FORMAT "ja/nei":U
      NPSPSYST.varenr COLUMN-LABEL "Varenr" FORMAT "9999999":U
      NPSPSYST.vegg_tykkelse COLUMN-LABEL "Veggtykkelse" FORMAT ">9.99":U
      NPSPSYST.anslutning2 COLUMN-LABEL "Anslutning" FORMAT "X(14)":U
      NPSPSYST.avstand_flotor2 COLUMN-LABEL "Avstand flotør" FORMAT ">>9":U
      NPSPSYST.avt_plugg COLUMN-LABEL "Avt.plugg" FORMAT "X(8)":U
      NPSPSYST.bredde COLUMN-LABEL "Bredde" FORMAT ">>>9":U
      NPSPSYST.df_diameter COLUMN-LABEL "DFØ" FORMAT ">>>9":U
      NPSPSYST.diameter COLUMN-LABEL "DØ" FORMAT ">>9.9":U
      NPSPSYST.dimmensjon2 COLUMN-LABEL "Dimm." FORMAT "X(45)":U
      NPSPSYST.dybde COLUMN-LABEL "Dybde" FORMAT ">>>9":U
      NPSPSYST.fast_tekst COLUMN-LABEL "Fast Tekst" FORMAT "A(255)":U
      NPSPSYST.H COLUMN-LABEL "H" FORMAT ">>>9":U
      NPSPSYST.H1 COLUMN-LABEL "H1" FORMAT ">>>9":U
      NPSPSYST.H2 COLUMN-LABEL "H2" FORMAT ">>>9":U
      NPSPSYST.hoyde COLUMN-LABEL "Høyde" FORMAT ">>>9":U
      NPSPSYST.hurtigventil COLUMN-LABEL "Hurtigventil" FORMAT "ja/nei":U
      NPSPSYST.h_0 COLUMN-LABEL "h" FORMAT ">>>9":U
      NPSPSYST.h_1 COLUMN-LABEL "h1" FORMAT ">>>9":U
      NPSPSYST.h_2 COLUMN-LABEL "h2" FORMAT ">>>9":U
      NPSPSYST.innmat2 COLUMN-LABEL "Innmat" FORMAT "X(25)":U
      NPSPSYST.kapasitet COLUMN-LABEL "Kapasitet" FORMAT "->>9.999":U
      NPSPSYST.kuleventil COLUMN-LABEL "Kuleventil" FORMAT "X(5)":U
      NPSPSYST.kv_verdi COLUMN-LABEL "KV-verdi" FORMAT ">,>>9.99":U
      NPSPSYST.L COLUMN-LABEL "L" FORMAT ">>9":U
      NPSPSYST.LF COLUMN-LABEL "LF" FORMAT ">>>9":U
      NPSPSYST.l_lufteventil COLUMN-LABEL "L lufteventil" FORMAT ">9":U
      NPSPSYST.materialkvaliteter2 COLUMN-LABEL "Materialkval." FORMAT "X(25)":U
      NPSPSYST.max_temp2 COLUMN-LABEL "Max temp." FORMAT ">>9":U
      NPSPSYST.max_trykk2 COLUMN-LABEL "Max trykk" FORMAT ">>9.9<":U
      NPSPSYST.nrf_nr2 COLUMN-LABEL "NRF" FORMAT "9999999":U
      NPSPSYST.pris COLUMN-LABEL "Pris" FORMAT ">>>,>>9.99":U
      NPSPSYST.produktnavn2 COLUMN-LABEL "Produktnavn" FORMAT "X(45)":U
      NPSPSYST.ror_dim2 COLUMN-LABEL "Rørdim." FORMAT ">>9.99":U
      NPSPSYST.service_plass_over COLUMN-LABEL "Serv.sp.over" FORMAT ">>>9":U
      NPSPSYST.service_plass_under COLUMN-LABEL "Serv.sp.under" FORMAT ">>>9":U
      NPSPSYST.tegnings_ref COLUMN-LABEL "Tegning" FORMAT "X(60)":U
      NPSPSYST.utv_volum COLUMN-LABEL "Utv. volum" FORMAT ">>9.99":U
      NPSPSYST.varenr2 COLUMN-LABEL "Varenr" FORMAT "9999999":U
      NPSPSYST.vegg_tykkelse2 COLUMN-LABEL "Veggtykkelse" FORMAT ">9.99":U
      NPSPSYST.vekt COLUMN-LABEL "Vekt" FORMAT ">,>>9.99":U
      NPSPSYST.volum COLUMN-LABEL "Volum" FORMAT ">>>9.99":U
  ENABLE
      NPSPSYST.anbefalt_max_kap
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 7.57 FIT-LAST-COLUMN.

DEFINE BROWSE BrwNPSPTILBUD
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BrwNPSPTILBUD C-Win _STRUCTURED
  QUERY BrwNPSPTILBUD NO-LOCK DISPLAY
      NPSPTILBUD.anleggsnr COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPTILBUD.avgittpris COLUMN-LABEL "Avgitt pris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.bet_bet COLUMN-LABEL "Bet. bet." FORMAT "X(20)":U
      NPSPTILBUD.deres_ref COLUMN-LABEL "Deres ref." FORMAT "X(30)":U
      NPSPTILBUD.gyldighetstid COLUMN-LABEL "Gyldighetstid" FORMAT ">99":U
      NPSPTILBUD.id COLUMN-LABEL "Id" FORMAT ">>>>>>":U
      NPSPTILBUD.kundenr COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSPTILBUD.lev_bet COLUMN-LABEL "Lev. bet." FORMAT "X(8)":U
      NPSPTILBUD.opplysninger COLUMN-LABEL "Opplysninger" FORMAT "X(1024)":U
      NPSPTILBUD.pris COLUMN-LABEL "Pris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.rabatt% COLUMN-LABEL "Rabatt%" FORMAT "->>9.99":U
      NPSPTILBUD.tilbudsdato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSPTILBUD.tilbudsid COLUMN-LABEL "tilbudsid" FORMAT "9999":U
      NPSPTILBUD.tilbudsnr COLUMN-LABEL "Tilbudsnr." FORMAT "X(20)":U
      NPSPTILBUD.vaar_ref COLUMN-LABEL "Vår ref." FORMAT "X(25)":U
      NPSPTILBUD.aktivt COLUMN-LABEL "Aktivt" FORMAT "ja/nei":U
      NPSPTILBUD.anbudsfrist COLUMN-LABEL "Anbudsfrist" FORMAT "99.99.9999":U
      NPSPTILBUD.anlegg COLUMN-LABEL "Anlegg" FORMAT "X(45)":U
      NPSPTILBUD.anleggsnr2 COLUMN-LABEL "Anleggsnr" FORMAT ">>>>>9":U
      NPSPTILBUD.arkivnr COLUMN-LABEL "Arkivnr" FORMAT "X(10)":U
      NPSPTILBUD.beskrevet COLUMN-LABEL "Beskrevet" FORMAT "X(15)":U
      NPSPTILBUD.byggestart COLUMN-LABEL "Byggestart" FORMAT "99.99.9999":U
      NPSPTILBUD.dato COLUMN-LABEL "Dato" FORMAT "99.99.9999":U
      NPSPTILBUD.endrings_laas COLUMN-LABEL "Låst" FORMAT "ja/nei":U
      NPSPTILBUD.entreprise COLUMN-LABEL "Entreprise" FORMAT "X(6)":U
      NPSPTILBUD.konsulentens_saksbeh COLUMN-LABEL "v/" FORMAT "X(25)":U
      NPSPTILBUD.konsulentid COLUMN-LABEL "Konsulent" FORMAT ">>>9":U
      NPSPTILBUD.kundenr2 COLUMN-LABEL "kundenr" FORMAT "X(8)":U
      NPSPTILBUD.leveringsdato COLUMN-LABEL "Leveringsdato" FORMAT "99.99.9999":U
      NPSPTILBUD.leveringstid COLUMN-LABEL "Leveringstid" FORMAT "X(15)":U
      NPSPTILBUD.oppf_aar COLUMN-LABEL "Oppf. år" FORMAT "9999":U
      NPSPTILBUD.oppf_uke COLUMN-LABEL "Oppf. uke" FORMAT "99":U
      NPSPTILBUD.opplysninger2 COLUMN-LABEL "Opplysninger" FORMAT "X(3072)":U
      NPSPTILBUD.ordre COLUMN-LABEL "ordre" FORMAT "ja/nei":U
      NPSPTILBUD.prosjektid COLUMN-LABEL "prosjektid" FORMAT ">>>>>>>9":U
      NPSPTILBUD.referanse_tekst COLUMN-LABEL "referanse_tekst" FORMAT "X(80)":U
      NPSPTILBUD.saksbehandler COLUMN-LABEL "Saksbehandler" FORMAT "X(25)":U
      NPSPTILBUD.salgsdistrikt COLUMN-LABEL "Salgsdistrikt" FORMAT "X(30)":U
      NPSPTILBUD.selger COLUMN-LABEL "Selger" FORMAT "X(25)":U
      NPSPTILBUD.sikker COLUMN-LABEL "sikker" FORMAT "ja/nei":U
      NPSPTILBUD.standardpris COLUMN-LABEL "Standardpris" FORMAT ">>,>>>,>>9.99":U
      NPSPTILBUD.adresse1 COLUMN-LABEL "Adresse 1" FORMAT "X(30)":U
      NPSPTILBUD.adresse2 COLUMN-LABEL "Adresse 2" FORMAT "X(30)":U
      NPSPTILBUD.aktiv COLUMN-LABEL "Aktiv" FORMAT "ja/nei":U
      NPSPTILBUD.avdeling COLUMN-LABEL "Avd." FORMAT "X(30)":U
      NPSPTILBUD.avtale COLUMN-LABEL "Avtale" FORMAT "X(6)":U
      NPSPTILBUD.dm_kode COLUMN-LABEL "DM kode" FORMAT "X(15)":U
      NPSPTILBUD.er_konsulent COLUMN-LABEL "Konsulent" FORMAT "yes/no":U
      NPSPTILBUD.fax COLUMN-LABEL "Fax" FORMAT "X(15)":U
      NPSPTILBUD.fylke COLUMN-LABEL "Fylke" FORMAT "X(18)":U
      NPSPTILBUD.katalog_np_antall COLUMN-LABEL "antall" FORMAT ">9":U
      NPSPTILBUD.katalog_np_dato COLUMN-LABEL "Katalog NP" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_np_oppdatert COLUMN-LABEL "oppdatert" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_np_type COLUMN-LABEL "type" FORMAT "X(4)":U
      NPSPTILBUD.katalog_nt_antall COLUMN-LABEL "antall" FORMAT ">9":U
      NPSPTILBUD.katalog_nt_dato COLUMN-LABEL "Katalog NP" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_nt_oppdatert COLUMN-LABEL "oppdatert" FORMAT "99.99.9999":U
      NPSPTILBUD.katalog_nt_type COLUMN-LABEL "type" FORMAT "X(4)":U
      NPSPTILBUD.kilde COLUMN-LABEL "Kilde" FORMAT "X(10)":U
      NPSPTILBUD.konsulentnr COLUMN-LABEL "konsulentnr" FORMAT ">>>>>>>9":U
      NPSPTILBUD.kontaktperson_np COLUMN-LABEL "Kontaktperson - NP" FORMAT "X(25)":U
      NPSPTILBUD.kontaktperson_nt COLUMN-LABEL "Kontaktperson - NT" FORMAT "X(25)":U
      NPSPTILBUD.kontor_type COLUMN-LABEL "Kontortype" FORMAT "X(15)":U
      NPSPTILBUD.kundedistrikt COLUMN-LABEL "Distrikt" FORMAT "X(30)":U
      NPSPTILBUD.kundekategori COLUMN-LABEL "Kategori" FORMAT "X(6)":U
      NPSPTILBUD.kundenavn COLUMN-LABEL "Kundenavn" FORMAT "X(30)":U
      NPSPTILBUD.kundenr3 COLUMN-LABEL "Kundenr" FORMAT "X(8)":U
      NPSPTILBUD.kundenr_de COLUMN-LABEL "Knr. d.ease" FORMAT "X(8)":U
      NPSPTILBUD.kundenr_i COLUMN-LABEL "Kundenr" FORMAT ">>>>>>9":U
      NPSPTILBUD.kundenr_sp COLUMN-LABEL "Knr. spektra" FORMAT "X(8)":U
      NPSPTILBUD.land COLUMN-LABEL "Land" FORMAT "X(20)":U
      NPSPTILBUD.mobil COLUMN-LABEL "Mobil" FORMAT "x(15)":U
      NPSPTILBUD.organisasjon COLUMN-LABEL "Organisasjon" FORMAT "X(1024)":U
      NPSPTILBUD.postnr COLUMN-LABEL "Postnr." FORMAT "X(8)":U
      NPSPTILBUD.poststed COLUMN-LABEL "Poststed" FORMAT "X(22)":U
      NPSPTILBUD.rabatt%_1 COLUMN-LABEL "Rabatt 1" FORMAT ">>9.99":U
      NPSPTILBUD.rabatt%_2 COLUMN-LABEL "Rabatt 2" FORMAT ">>9.99":U
      NPSPTILBUD.sist_oppdatert COLUMN-LABEL "Sist oppd." FORMAT "99.99.9999":U
      NPSPTILBUD.telefon COLUMN-LABEL "Telefon" FORMAT "X(15)":U
      NPSPTILBUD.tilbudsmottager COLUMN-LABEL "Tilbud" FORMAT "ja/nei":U
      NPSPTILBUD.bVAT COLUMN-LABEL "Momsregistrert" FORMAT "ja/nei":U
      NPSPTILBUD.cAddress1 COLUMN-LABEL "Adresse" FORMAT "x(50)":U
      NPSPTILBUD.cAddress2 COLUMN-LABEL "Adresse" FORMAT "x(40)":U
      NPSPTILBUD.cBankAccount COLUMN-LABEL "Konto" FORMAT "x(50)":U
      NPSPTILBUD.cCity COLUMN-LABEL "Poststed" FORMAT "x(40)":U
      NPSPTILBUD.cCompanyLogo COLUMN-LABEL "Logo" FORMAT "x(40)":U
      NPSPTILBUD.cCompanyName COLUMN-LABEL "Navn" FORMAT "X(40)":U
      NPSPTILBUD.cCountry COLUMN-LABEL "Land" FORMAT "x(40)":U
      NPSPTILBUD.cCreatedBy COLUMN-LABEL "Av" FORMAT "X(8)":U
      NPSPTILBUD.cEmail COLUMN-LABEL "Epost" FORMAT "x(60)":U
      NPSPTILBUD.cEmail2 COLUMN-LABEL "Epost2" FORMAT "x(60)":U
      NPSPTILBUD.cFax COLUMN-LABEL "Fax" FORMAT "x(15)":U
      NPSPTILBUD.cModifiedBy COLUMN-LABEL "Av" FORMAT "X(8)":U
      NPSPTILBUD.cPostalCode COLUMN-LABEL "Postnr" FORMAT "x(8)":U
      NPSPTILBUD.cState COLUMN-LABEL "State" FORMAT "x(20)":U
      NPSPTILBUD.cTlfHome COLUMN-LABEL "Tlf.priv" FORMAT "x(15)":U
      NPSPTILBUD.cTlfMob COLUMN-LABEL "Mobil" FORMAT "x(15)":U
      NPSPTILBUD.cTlfWrk COLUMN-LABEL "Tlf.jobb" FORMAT "x(15)":U
      NPSPTILBUD.cURL COLUMN-LABEL "Webside" FORMAT "x(40)":U
      NPSPTILBUD.cURL2 COLUMN-LABEL "Webside2" FORMAT "x(40)":U
      NPSPTILBUD.cVat COLUMN-LABEL "Org.nr" FORMAT "x(12)":U
      NPSPTILBUD.dCreated COLUMN-LABEL "Opprettet" FORMAT "99/99/9999":U
      NPSPTILBUD.dModified COLUMN-LABEL "Endret" FORMAT "99/99/9999":U
      NPSPTILBUD.iJBoxCompanyId COLUMN-LABEL "CompanyId" FORMAT "->,>>>,>>9":U
  ENABLE
      NPSPTILBUD.anleggsnr
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 128 BY 5.71 FIT-LAST-COLUMN.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     refresh_tbNPSPTILBUD AT ROW 1.1 COL 2.2 WIDGET-ID 4
     filter_tbNPSPTILBUD AT ROW 1.1 COL 10.2 WIDGET-ID 6
     browseconfig_tbNPSPTILBUD AT ROW 1.1 COL 18 WIDGET-ID 8
     excel_tbNPSPTILBUD AT ROW 1.1 COL 25.8 WIDGET-ID 10
     PrintPDFteknisk_tbNPSPTILBUD AT ROW 1.1 COL 33.6 WIDGET-ID 12
     PrintPDF_tbNPSPTILBUD AT ROW 1.1 COL 41.4 WIDGET-ID 14
     BrwNPSPTILBUD AT ROW 2.91 COL 1 WIDGET-ID 200
     BrwNPSPSYST AT ROW 9.1 COL 1 WIDGET-ID 300
     tbNPSPTILBUD AT ROW 1 COL 2 WIDGET-ID 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 128 BY 15.67 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "<Insert window title>"
         HEIGHT             = 15.67
         WIDTH              = 128
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 128
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 128
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */

  {incl/devmode.i}
  {incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
/* BROWSE-TAB BrwNPSPTILBUD PrintPDF_tbNPSPTILBUD DEFAULT-FRAME */
/* BROWSE-TAB BrwNPSPSYST BrwNPSPTILBUD DEFAULT-FRAME */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 15.67
       FRAME DEFAULT-FRAME:WIDTH            = 128.

ASSIGN 
       tbNPSPTILBUD:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "refresh;Refresh,filter;Filter,browseconfig;Column setup,excel;Excel,PrintPDFteknisk;Teknisk PDF,PrintPDF;Print PDFmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPSYST
/* Query rebuild information for BROWSE BrwNPSPSYST
     _TblList          = "norcalc.NPSPSYST"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSPSYST.anbefalt_max_kap
"NPSPSYST.anbefalt_max_kap" "Kapasitet" "->>9.999" "DECIMAL" ? ? ? ? ? ? yes "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSPSYST.anb_max_innl_hast
"NPSPSYST.anb_max_innl_hast" "Anb. max innl. hast." "X(5)" "CHARACTER" ? ? ? ? ? ? no "" no no "18.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSPSYST.anleggsnr
"NPSPSYST.anleggsnr" "Anleggsnr" ">>>>>9" "INTEGER" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSPSYST.anslutning
"NPSPSYST.anslutning" "Anslutning" "X(18)" "CHARACTER" ? ? ? ? ? ? no "" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSPSYST.antall
"NPSPSYST.antall" "Antall" ">>9" "INTEGER" ? ? ? ? ? ? no "" no no "5.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSPSYST.avstand_flotor
"NPSPSYST.avstand_flotor" "Avstand flotør" ">>9" "INTEGER" ? ? ? ? ? ? no "" no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSPSYST.beregnet_anvendelse
"NPSPSYST.beregnet_anvendelse" "Anvendelse" "X(18)" "CHARACTER" ? ? ? ? ? ? no "Velg anvendelsesområde" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSPSYST.dimmensjon
"NPSPSYST.dimmensjon" "Dimm." "X(45)" "CHARACTER" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSPSYST.faktor
"NPSPSYST.faktor" "Faktor" "9.999" "DECIMAL" ? ? ? ? ? ? no "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSPSYST.glykoltype
"NPSPSYST.glykoltype" "Glyk.type" "X(20)" "CHARACTER" ? ? ? ? ? ? no "Velg glykoltype" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSPSYST.innl_hastighet
"NPSPSYST.innl_hastighet" "Innl.hast." "9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "8.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSPSYST.innmat
"NPSPSYST.innmat" "Innmat" "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSPSYST.isolasjon
"NPSPSYST.isolasjon" "Mantel/Isolasjon" "X(18)" "CHARACTER" ? ? ? ? ? ? no "" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSPSYST.konsentrasjon
"NPSPSYST.konsentrasjon" "Kons." "X(8)" "CHARACTER" ? ? ? ? ? ? no "Oppgi glykoltype konsentrasjon" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSPSYST.kuleventil_ja_nei
"NPSPSYST.kuleventil_ja_nei" "Kuleventil" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSPSYST.kuleventil_verdi
"NPSPSYST.kuleventil_verdi" "Kuleventil" "X(5)" "CHARACTER" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSPSYST.listepris
"NPSPSYST.listepris" "Listepris" ">>,>>>,>>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSPSYST.materialkvaliteter
"NPSPSYST.materialkvaliteter" "Materialkval." "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSPSYST.max_temp
"NPSPSYST.max_temp" "Max temp." ">>9" "INTEGER" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSPSYST.max_trykk
"NPSPSYST.max_trykk" "Max trykk" ">>>9.9<" "DECIMAL" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSPSYST.medietemperatur
"NPSPSYST.medietemperatur" "Med. temp" "X(5)" "CHARACTER" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSPSYST.motflenser
"NPSPSYST.motflenser" "Motflenser" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSPSYST.nrf_nr
"NPSPSYST.nrf_nr" "NRF" "9999999" "INTEGER" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSPSYST.produktnavn
"NPSPSYST.produktnavn" "Produktnavn" "X(45)" "CHARACTER" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSPSYST.produkttype
"NPSPSYST.produkttype" "Produkttype" "X(45)" "CHARACTER" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSPSYST.refill
"NPSPSYST.refill" "Refill" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "4.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSPSYST.ror_dim
"NPSPSYST.ror_dim" "Rørdim." ">>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSPSYST.spiroventkapasitet
"NPSPSYST.spiroventkapasitet" "Kapasitet" "->>9.999" "DECIMAL" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > NPSPSYST.systembetegnelse
"NPSPSYST.systembetegnelse" "Syst.bet." "X(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > NPSPSYST.systemnr
"NPSPSYST.systemnr" "Systemnr" ">>>>>9" "INTEGER" ? ? ? ? ? ? no "" no no "8.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > NPSPSYST.trykkfall
"NPSPSYST.trykkfall" "Trykkfall" ">,>>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > NPSPSYST.utv_gjengeventil
"NPSPSYST.utv_gjengeventil" "Utv. gjenget lufteventil" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "21.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > NPSPSYST.varenr
"NPSPSYST.varenr" "Varenr" "9999999" "INTEGER" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > NPSPSYST.vegg_tykkelse
"NPSPSYST.vegg_tykkelse" "Veggtykkelse" ">9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > NPSPSYST.anslutning2
"NPSPSYST.anslutning2" "Anslutning" "X(14)" "character" ? ? ? ? ? ? no "" no no "14" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > NPSPSYST.avstand_flotor2
"NPSPSYST.avstand_flotor2" "Avstand flotør" ">>9" "integer" ? ? ? ? ? ? no "" no no "13" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > NPSPSYST.avt_plugg
"NPSPSYST.avt_plugg" "Avt.plugg" "X(8)" "character" ? ? ? ? ? ? no "" no no "9" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > NPSPSYST.bredde
"NPSPSYST.bredde" "Bredde" ">>>9" "integer" ? ? ? ? ? ? no "" no no "6.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > NPSPSYST.df_diameter
"NPSPSYST.df_diameter" "DFØ" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > NPSPSYST.diameter
"NPSPSYST.diameter" "DØ" ">>9.9" "decimal" ? ? ? ? ? ? no "" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[41]   > NPSPSYST.dimmensjon2
"NPSPSYST.dimmensjon2" "Dimm." "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[42]   > NPSPSYST.dybde
"NPSPSYST.dybde" "Dybde" ">>>9" "integer" ? ? ? ? ? ? no "" no no "6.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[43]   > NPSPSYST.fast_tekst
"NPSPSYST.fast_tekst" "Fast Tekst" "A(255)" "character" ? ? ? ? ? ? no "" no no "255" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[44]   > NPSPSYST.H
"NPSPSYST.H" "H" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[45]   > NPSPSYST.H1
"NPSPSYST.H1" "H1" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[46]   > NPSPSYST.H2
"NPSPSYST.H2" "H2" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[47]   > NPSPSYST.hoyde
"NPSPSYST.hoyde" "Høyde" ">>>9" "integer" ? ? ? ? ? ? no "" no no "6.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[48]   > NPSPSYST.hurtigventil
"NPSPSYST.hurtigventil" "Hurtigventil" "ja/nei" "logical" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[49]   > NPSPSYST.h_0
"NPSPSYST.h_0" "h" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[50]   > NPSPSYST.h_1
"NPSPSYST.h_1" "h1" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[51]   > NPSPSYST.h_2
"NPSPSYST.h_2" "h2" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[52]   > NPSPSYST.innmat2
"NPSPSYST.innmat2" "Innmat" "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[53]   > NPSPSYST.kapasitet
"NPSPSYST.kapasitet" "Kapasitet" "->>9.999" "decimal" ? ? ? ? ? ? no "" no no "8.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[54]   > NPSPSYST.kuleventil
"NPSPSYST.kuleventil" "Kuleventil" "X(5)" "character" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[55]   > NPSPSYST.kv_verdi
"NPSPSYST.kv_verdi" "KV-verdi" ">,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[56]   > NPSPSYST.L
"NPSPSYST.L" "L" ">>9" "integer" ? ? ? ? ? ? no "" no no "3.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[57]   > NPSPSYST.LF
"NPSPSYST.LF" "LF" ">>>9" "integer" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[58]   > NPSPSYST.l_lufteventil
"NPSPSYST.l_lufteventil" "L lufteventil" ">9" "integer" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[59]   > NPSPSYST.materialkvaliteter2
"NPSPSYST.materialkvaliteter2" "Materialkval." "X(25)" "character" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[60]   > NPSPSYST.max_temp2
"NPSPSYST.max_temp2" "Max temp." ">>9" "integer" ? ? ? ? ? ? no "" no no "9.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[61]   > NPSPSYST.max_trykk2
"NPSPSYST.max_trykk2" "Max trykk" ">>9.9<" "decimal" ? ? ? ? ? ? no "" no no "9.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[62]   > NPSPSYST.nrf_nr2
"NPSPSYST.nrf_nr2" "NRF" "9999999" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[63]   > NPSPSYST.pris
"NPSPSYST.pris" "Pris" ">>>,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[64]   > NPSPSYST.produktnavn2
"NPSPSYST.produktnavn2" "Produktnavn" "X(45)" "character" ? ? ? ? ? ? no "" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[65]   > NPSPSYST.ror_dim2
"NPSPSYST.ror_dim2" "Rørdim." ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[66]   > NPSPSYST.service_plass_over
"NPSPSYST.service_plass_over" "Serv.sp.over" ">>>9" "integer" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[67]   > NPSPSYST.service_plass_under
"NPSPSYST.service_plass_under" "Serv.sp.under" ">>>9" "integer" ? ? ? ? ? ? no "" no no "13.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[68]   > NPSPSYST.tegnings_ref
"NPSPSYST.tegnings_ref" "Tegning" "X(60)" "character" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[69]   > NPSPSYST.utv_volum
"NPSPSYST.utv_volum" "Utv. volum" ">>9.99" "decimal" ? ? ? ? ? ? no "" no no "10.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[70]   > NPSPSYST.varenr2
"NPSPSYST.varenr2" "Varenr" "9999999" "integer" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[71]   > NPSPSYST.vegg_tykkelse2
"NPSPSYST.vegg_tykkelse2" "Veggtykkelse" ">9.99" "decimal" ? ? ? ? ? ? no "" no no "12.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[72]   > NPSPSYST.vekt
"NPSPSYST.vekt" "Vekt" ">,>>9.99" "decimal" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[73]   > NPSPSYST.volum
"NPSPSYST.volum" "Volum" ">>>9.99" "decimal" ? ? ? ? ? ? no "" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPSYST */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BrwNPSPTILBUD
/* Query rebuild information for BROWSE BrwNPSPTILBUD
     _TblList          = "norcalc.NPSPTILBUD"
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _FldNameList[1]   > NPSPTILBUD.anleggsnr
"NPSPTILBUD.anleggsnr" "Anleggsnr" ">>>>>9" "INTEGER" ? ? ? ? ? ? yes "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[2]   > NPSPTILBUD.avgittpris
"NPSPTILBUD.avgittpris" "Avgitt pris" ">>,>>>,>>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[3]   > NPSPTILBUD.bet_bet
"NPSPTILBUD.bet_bet" "Bet. bet." "X(20)" "CHARACTER" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[4]   > NPSPTILBUD.deres_ref
"NPSPTILBUD.deres_ref" "Deres ref." "X(30)" "CHARACTER" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[5]   > NPSPTILBUD.gyldighetstid
"NPSPTILBUD.gyldighetstid" "Gyldighetstid" ">99" "INTEGER" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[6]   > NPSPTILBUD.id
"NPSPTILBUD.id" "Id" ">>>>>>" "INTEGER" ? ? ? ? ? ? no "" no no "7.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[7]   > NPSPTILBUD.kundenr
"NPSPTILBUD.kundenr" "Kundenr" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[8]   > NPSPTILBUD.lev_bet
"NPSPTILBUD.lev_bet" "Lev. bet." "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[9]   > NPSPTILBUD.opplysninger
"NPSPTILBUD.opplysninger" "Opplysninger" "X(1024)" "CHARACTER" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[10]   > NPSPTILBUD.pris
"NPSPTILBUD.pris" "Pris" ">>,>>>,>>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[11]   > NPSPTILBUD.rabatt%
"NPSPTILBUD.rabatt%" "Rabatt%" "->>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[12]   > NPSPTILBUD.tilbudsdato
"NPSPTILBUD.tilbudsdato" "Dato" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[13]   > NPSPTILBUD.tilbudsid
"NPSPTILBUD.tilbudsid" "tilbudsid" "9999" "INTEGER" ? ? ? ? ? ? no "" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[14]   > NPSPTILBUD.tilbudsnr
"NPSPTILBUD.tilbudsnr" "Tilbudsnr." "X(20)" "CHARACTER" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[15]   > NPSPTILBUD.vaar_ref
"NPSPTILBUD.vaar_ref" "Vår ref." "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[16]   > NPSPTILBUD.aktivt
"NPSPTILBUD.aktivt" "Aktivt" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "5.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[17]   > NPSPTILBUD.anbudsfrist
"NPSPTILBUD.anbudsfrist" "Anbudsfrist" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[18]   > NPSPTILBUD.anlegg
"NPSPTILBUD.anlegg" "Anlegg" "X(45)" "CHARACTER" ? ? ? ? ? ? no "Anleggets navn" no no "45" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[19]   > NPSPTILBUD.anleggsnr2
"NPSPTILBUD.anleggsnr2" "Anleggsnr" ">>>>>9" "INTEGER" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[20]   > NPSPTILBUD.arkivnr
"NPSPTILBUD.arkivnr" "Arkivnr" "X(10)" "CHARACTER" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[21]   > NPSPTILBUD.beskrevet
"NPSPTILBUD.beskrevet" "Beskrevet" "X(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[22]   > NPSPTILBUD.byggestart
"NPSPTILBUD.byggestart" "Byggestart" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[23]   > NPSPTILBUD.dato
"NPSPTILBUD.dato" "Dato" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[24]   > NPSPTILBUD.endrings_laas
"NPSPTILBUD.endrings_laas" "Låst" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[25]   > NPSPTILBUD.entreprise
"NPSPTILBUD.entreprise" "Entreprise" "X(6)" "CHARACTER" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[26]   > NPSPTILBUD.konsulentens_saksbeh
"NPSPTILBUD.konsulentens_saksbeh" "v/" "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[27]   > NPSPTILBUD.konsulentid
"NPSPTILBUD.konsulentid" "Konsulent" ">>>9" "INTEGER" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[28]   > NPSPTILBUD.kundenr2
"NPSPTILBUD.kundenr2" "kundenr" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[29]   > NPSPTILBUD.leveringsdato
"NPSPTILBUD.leveringsdato" "Leveringsdato" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "13.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[30]   > NPSPTILBUD.leveringstid
"NPSPTILBUD.leveringstid" "Leveringstid" "X(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[31]   > NPSPTILBUD.oppf_aar
"NPSPTILBUD.oppf_aar" "Oppf. år" "9999" "INTEGER" ? ? ? ? ? ? no "Oppgi år for neste oppfølging" no no "7.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[32]   > NPSPTILBUD.oppf_uke
"NPSPTILBUD.oppf_uke" "Oppf. uke" "99" "INTEGER" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[33]   > NPSPTILBUD.opplysninger2
"NPSPTILBUD.opplysninger2" "Opplysninger" "X(3072)" "CHARACTER" ? ? ? ? ? ? no "" no no "3072" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[34]   > NPSPTILBUD.ordre
"NPSPTILBUD.ordre" "ordre" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[35]   > NPSPTILBUD.prosjektid
"NPSPTILBUD.prosjektid" "prosjektid" ">>>>>>>9" "INTEGER" ? ? ? ? ? ? no "" no no "9.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[36]   > NPSPTILBUD.referanse_tekst
"NPSPTILBUD.referanse_tekst" "referanse_tekst" "X(80)" "CHARACTER" ? ? ? ? ? ? no "" no no "80" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[37]   > NPSPTILBUD.saksbehandler
"NPSPTILBUD.saksbehandler" "Saksbehandler" "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[38]   > NPSPTILBUD.salgsdistrikt
"NPSPTILBUD.salgsdistrikt" "Salgsdistrikt" "X(30)" "CHARACTER" ? ? ? ? ? ? no "Velg distrikt" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[39]   > NPSPTILBUD.selger
"NPSPTILBUD.selger" "Selger" "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[40]   > NPSPTILBUD.sikker
"NPSPTILBUD.sikker" "sikker" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "5.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[41]   > NPSPTILBUD.standardpris
"NPSPTILBUD.standardpris" "Standardpris" ">>,>>>,>>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "13.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[42]   > NPSPTILBUD.adresse1
"NPSPTILBUD.adresse1" "Adresse 1" "X(30)" "CHARACTER" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[43]   > NPSPTILBUD.adresse2
"NPSPTILBUD.adresse2" "Adresse 2" "X(30)" "CHARACTER" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[44]   > NPSPTILBUD.aktiv
"NPSPTILBUD.aktiv" "Aktiv" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "4.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[45]   > NPSPTILBUD.avdeling
"NPSPTILBUD.avdeling" "Avd." "X(30)" "CHARACTER" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[46]   > NPSPTILBUD.avtale
"NPSPTILBUD.avtale" "Avtale" "X(6)" "CHARACTER" ? ? ? ? ? ? no "" no no "6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[47]   > NPSPTILBUD.dm_kode
"NPSPTILBUD.dm_kode" "DM kode" "X(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[48]   > NPSPTILBUD.er_konsulent
"NPSPTILBUD.er_konsulent" "Konsulent" "yes/no" "LOGICAL" ? ? ? ? ? ? no "" no no "9.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[49]   > NPSPTILBUD.fax
"NPSPTILBUD.fax" "Fax" "X(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[50]   > NPSPTILBUD.fylke
"NPSPTILBUD.fylke" "Fylke" "X(18)" "CHARACTER" ? ? ? ? ? ? no "Velg fylke" no no "18" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[51]   > NPSPTILBUD.katalog_np_antall
"NPSPTILBUD.katalog_np_antall" "antall" ">9" "INTEGER" ? ? ? ? ? ? no "" no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[52]   > NPSPTILBUD.katalog_np_dato
"NPSPTILBUD.katalog_np_dato" "Katalog NP" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[53]   > NPSPTILBUD.katalog_np_oppdatert
"NPSPTILBUD.katalog_np_oppdatert" "oppdatert" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[54]   > NPSPTILBUD.katalog_np_type
"NPSPTILBUD.katalog_np_type" "type" "X(4)" "CHARACTER" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[55]   > NPSPTILBUD.katalog_nt_antall
"NPSPTILBUD.katalog_nt_antall" "antall" ">9" "INTEGER" ? ? ? ? ? ? no "" no no "5" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[56]   > NPSPTILBUD.katalog_nt_dato
"NPSPTILBUD.katalog_nt_dato" "Katalog NP" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[57]   > NPSPTILBUD.katalog_nt_oppdatert
"NPSPTILBUD.katalog_nt_oppdatert" "oppdatert" "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[58]   > NPSPTILBUD.katalog_nt_type
"NPSPTILBUD.katalog_nt_type" "type" "X(4)" "CHARACTER" ? ? ? ? ? ? no "" no no "4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[59]   > NPSPTILBUD.kilde
"NPSPTILBUD.kilde" "Kilde" "X(10)" "CHARACTER" ? ? ? ? ? ? no "" no no "10" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[60]   > NPSPTILBUD.konsulentnr
"NPSPTILBUD.konsulentnr" "konsulentnr" ">>>>>>>9" "INTEGER" ? ? ? ? ? ? no "" no no "11" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[61]   > NPSPTILBUD.kontaktperson_np
"NPSPTILBUD.kontaktperson_np" "Kontaktperson - NP" "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[62]   > NPSPTILBUD.kontaktperson_nt
"NPSPTILBUD.kontaktperson_nt" "Kontaktperson - NT" "X(25)" "CHARACTER" ? ? ? ? ? ? no "" no no "25" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[63]   > NPSPTILBUD.kontor_type
"NPSPTILBUD.kontor_type" "Kontortype" "X(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[64]   > NPSPTILBUD.kundedistrikt
"NPSPTILBUD.kundedistrikt" "Distrikt" "X(30)" "CHARACTER" ? ? ? ? ? ? no "Velg distrikt" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[65]   > NPSPTILBUD.kundekategori
"NPSPTILBUD.kundekategori" "Kategori" "X(6)" "CHARACTER" ? ? ? ? ? ? no "Velg kundekategori" no no "7.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[66]   > NPSPTILBUD.kundenavn
"NPSPTILBUD.kundenavn" "Kundenavn" "X(30)" "CHARACTER" ? ? ? ? ? ? no "" no no "30" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[67]   > NPSPTILBUD.kundenr3
"NPSPTILBUD.kundenr3" "Kundenr" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[68]   > NPSPTILBUD.kundenr_de
"NPSPTILBUD.kundenr_de" "Knr. d.ease" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[69]   > NPSPTILBUD.kundenr_i
"NPSPTILBUD.kundenr_i" "Kundenr" ">>>>>>9" "INTEGER" ? ? ? ? ? ? no "" no no "8.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[70]   > NPSPTILBUD.kundenr_sp
"NPSPTILBUD.kundenr_sp" "Knr. spektra" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "11.4" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[71]   > NPSPTILBUD.land
"NPSPTILBUD.land" "Land" "X(20)" "CHARACTER" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[72]   > NPSPTILBUD.mobil
"NPSPTILBUD.mobil" "Mobil" "x(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[73]   > NPSPTILBUD.organisasjon
"NPSPTILBUD.organisasjon" "Organisasjon" "X(1024)" "CHARACTER" ? ? ? ? ? ? no "" no no "1024" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[74]   > NPSPTILBUD.postnr
"NPSPTILBUD.postnr" "Postnr." "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[75]   > NPSPTILBUD.poststed
"NPSPTILBUD.poststed" "Poststed" "X(22)" "CHARACTER" ? ? ? ? ? ? no "" no no "22" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[76]   > NPSPTILBUD.rabatt%_1
"NPSPTILBUD.rabatt%_1" "Rabatt 1" ">>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "8.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[77]   > NPSPTILBUD.rabatt%_2
"NPSPTILBUD.rabatt%_2" "Rabatt 2" ">>9.99" "DECIMAL" ? ? ? ? ? ? no "" no no "8.2" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[78]   > NPSPTILBUD.sist_oppdatert
"NPSPTILBUD.sist_oppdatert" "Sist oppd." "99.99.9999" "DATE" ? ? ? ? ? ? no "" no no "10.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[79]   > NPSPTILBUD.telefon
"NPSPTILBUD.telefon" "Telefon" "X(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[80]   > NPSPTILBUD.tilbudsmottager
"NPSPTILBUD.tilbudsmottager" "Tilbud" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "Denne kunden kan motta tilbud (J/N)" no no "5.8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[81]   > NPSPTILBUD.bVAT
"NPSPTILBUD.bVAT" "Momsregistrert" "ja/nei" "LOGICAL" ? ? ? ? ? ? no "" no no "13.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[82]   > NPSPTILBUD.cAddress1
"NPSPTILBUD.cAddress1" "Adresse" "x(50)" "CHARACTER" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[83]   > NPSPTILBUD.cAddress2
"NPSPTILBUD.cAddress2" "Adresse" "x(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[84]   > NPSPTILBUD.cBankAccount
"NPSPTILBUD.cBankAccount" "Konto" "x(50)" "CHARACTER" ? ? ? ? ? ? no "" no no "50" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[85]   > NPSPTILBUD.cCity
"NPSPTILBUD.cCity" "Poststed" "x(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[86]   > NPSPTILBUD.cCompanyLogo
"NPSPTILBUD.cCompanyLogo" "Logo" "x(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[87]   > NPSPTILBUD.cCompanyName
"NPSPTILBUD.cCompanyName" "Navn" "X(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[88]   > NPSPTILBUD.cCountry
"NPSPTILBUD.cCountry" "Land" "x(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[89]   > NPSPTILBUD.cCreatedBy
"NPSPTILBUD.cCreatedBy" "Av" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[90]   > NPSPTILBUD.cEmail
"NPSPTILBUD.cEmail" "Epost" "x(60)" "CHARACTER" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[91]   > NPSPTILBUD.cEmail2
"NPSPTILBUD.cEmail2" "Epost2" "x(60)" "CHARACTER" ? ? ? ? ? ? no "" no no "60" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[92]   > NPSPTILBUD.cFax
"NPSPTILBUD.cFax" "Fax" "x(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[93]   > NPSPTILBUD.cModifiedBy
"NPSPTILBUD.cModifiedBy" "Av" "X(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[94]   > NPSPTILBUD.cPostalCode
"NPSPTILBUD.cPostalCode" "Postnr" "x(8)" "CHARACTER" ? ? ? ? ? ? no "" no no "8" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[95]   > NPSPTILBUD.cState
"NPSPTILBUD.cState" "State" "x(20)" "CHARACTER" ? ? ? ? ? ? no "" no no "20" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[96]   > NPSPTILBUD.cTlfHome
"NPSPTILBUD.cTlfHome" "Tlf.priv" "x(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[97]   > NPSPTILBUD.cTlfMob
"NPSPTILBUD.cTlfMob" "Mobil" "x(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[98]   > NPSPTILBUD.cTlfWrk
"NPSPTILBUD.cTlfWrk" "Tlf.jobb" "x(15)" "CHARACTER" ? ? ? ? ? ? no "" no no "15" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[99]   > NPSPTILBUD.cURL
"NPSPTILBUD.cURL" "Webside" "x(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[100]   > NPSPTILBUD.cURL2
"NPSPTILBUD.cURL2" "Webside2" "x(40)" "CHARACTER" ? ? ? ? ? ? no "" no no "40" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[101]   > NPSPTILBUD.cVat
"NPSPTILBUD.cVat" "Org.nr" "x(12)" "CHARACTER" ? ? ? ? ? ? no "" no no "12" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[102]   > NPSPTILBUD.dCreated
"NPSPTILBUD.dCreated" "Opprettet" "99/99/9999" "DATE" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[103]   > NPSPTILBUD.dModified
"NPSPTILBUD.dModified" "Endret" "99/99/9999" "DATE" ? ? ? ? ? ? no "" no no "11.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _FldNameList[104]   > NPSPTILBUD.iJBoxCompanyId
"NPSPTILBUD.iJBoxCompanyId" "CompanyId" "->,>>>,>>9" "INTEGER" ? ? ? ? ? ? no "" no no "10.6" yes no no "U" "" "" "" "" "" "" 0 no 0 no no
     _Query            is NOT OPENED
*/  /* BROWSE BrwNPSPTILBUD */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <Insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE 
  DO:
    /* This case occurs when the user presses the "Esc" key.
       In a persistently run window, just ignore this.  If we did not, the
       application would exit. */
    IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <Insert window title> */
DO:
    /* This event will close the window and terminate the procedure.  */
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN NO-APPLY.
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BrwNPSPSYST
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
  DO:
    IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
    DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
    PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
    RUN disable_UI.
  END.

{incl/wintrigg.i}
{incl/conttrigg.i oBrwNPSPTILBUD:BROWSE-HANDLE}
{ pdf_inc.i}

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
  ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
  RUN InitializeObject.
  RUN MoveToTop.
  IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
    RUN WaitForForm NO-ERROR.
  &ENDIF

  IF NOT THIS-PROCEDURE:PERSISTENT THEN 
  DO:
    &IF DEFINED(UIB_is_Running) = 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
    SESSION:SET-WAIT-STATE("").
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
    ELSE 
    &ENDIF
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE tbNPSPTILBUD refresh_tbNPSPTILBUD filter_tbNPSPTILBUD 
         browseconfig_tbNPSPTILBUD excel_tbNPSPTILBUD 
         PrintPDFteknisk_tbNPSPTILBUD PrintPDF_tbNPSPTILBUD BrwNPSPTILBUD 
         BrwNPSPSYST 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       Refer to the <jukebox>\winsrc\samples for working examples for Sports2000
  ------------------------------------------------------------------------------*/
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().

  DO WITH FRAME {&FRAME-NAME}:

    oBrwNPSPTILBUD = NEW JBoxBrowse(brwNPSPTILBUD:HANDLE).
    oBrwNPSPTILBUD:setNoResizeY().
    
    oBrwNPSPSYST = NEW JBoxBrowse(brwNPSPSYST:HANDLE).
    oBrwNPSPSYST:setParentBrowseObject(oBrwNPSPTILBUD,'anleggsnr').
    
    otbNPSPTILBUD = NEW JBoxToolbar(tbNPSPTILBUD:HANDLE).

  oBrwNPSPTILBUD:TOOLBAR-OBJECT = otbNPSPTILBUD.
END.
/*  oBrwNPSPSYST:OpenQuery().*/
  oBrwNPSPTILBUD:OpenQuery().

  oContainer:initResize().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop C-Win 
PROCEDURE MoveToTop :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
  ------------------------------------------------------------------------------*/
  THIS-PROCEDURE:CURRENT-WINDOW:HIDDEN = NO.
  IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
    RUN ShowForm("").
  THIS-PROCEDURE:CURRENT-WINDOW:WINDOW-STATE = 3.
  THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
  DYNAMIC-FUNCTION("DoLockWindow",?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrintPDFRecord C-Win 
PROCEDURE PrintPDFRecord :
/*------------------------------------------------------------------------------
   Purpose:
   Notes:
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE result      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFilename   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE yPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLeftMargin AS INTEGER   INIT 20 NO-UNDO.
  DEFINE VARIABLE iMaxWidth   AS INTEGER   INIT 105 NO-UNDO.
  def var cText as char no-undo.
  def var bFlag as log  no-undo.
  def var bFlag2 as log no-undo.
  def var cTegning as char no-undo.
  
  def var iColumn as int extent 5 no-undo.
  
  def var hQ as handle no-undo.
  
  assign 
    iColumn[1] = 60
    iColumn[2] = 90
    iColumn[3] = 180
    .
  
  cFilename = "./Tilbudsbrev.pdf".
  RUN pdf_new ("Spdf",cFilename).

  RUN pdf_set_Orientation ("Spdf","Portrait").
  RUN pdf_set_PaperType ("Spdf","A4").
  RUN pdf_set_VerticalSpace("Spdf",10).
  RUN pdf_set_TopMargin("Spdf",50).
  RUN pdf_set_LeftMargin("Spdf",iLeftMargin). 
  iLeftColumn = 2.
  
  RUN pdf_set_font("Spdf", "Helvetica",8).
  
  RUN pdf_new_page("Spdf").
  /*LOGO**/
  IF SEARCH(cFirmaLogo) NE ? THEN
  DO:
    RUN pdf_load_image ("Spdf","NorShuntLogo",cFirmalogo).
    RUN pdf_place_image ("Spdf","NorShuntLogo",380,40,200,30).
  END.

  RUN pdf_text_at ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::kundenavn,iLeftColumn).
  RUN pdf_text_to ("Spdf",oBrwNPSPTILBUD:BUFFER-HANDLE::cCompanyName,iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_at ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::adresse1,iLeftColumn).
  RUN pdf_text_to ("Spdf",ENTRY(1,oBrwNPSPTILBUD:BUFFER-HANDLE::cAddress1,','),iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_at ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::adresse2,iLeftColumn).
  RUN pdf_text_to ("Spdf",ENTRY(2,oBrwNPSPTILBUD:BUFFER-HANDLE::cAddress1,','),iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_at ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::postnr + ' ' + oBrwNPSPTilbud:BUFFER-HANDLE::poststed,iLeftColumn).
  RUN pdf_text_to ("Spdf",oBrwNPSPTILBUD:BUFFER-HANDLE::cAddress2,iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_at ("Spdf", 'Telefon',iLeftColumn).
  RUN pdf_text_at ("Spdf", 'Faks',20).
  RUN pdf_text_to ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::cPostalCode + ' ' + oBrwNPSPTilbud:BUFFER-HANDLE::cCity,iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_at ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::telefon,iLeftColumn).
  RUN pdf_text_at ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::fax,20).
  RUN pdf_text_to ("Spdf", 'NO' + oBrwNPSPTilbud:BUFFER-HANDLE::cVAT + 'MVA',iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_to ("Spdf", 'Sparebanken Sør AS',iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_to ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::cBankAccount,iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_to ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::cEmail,iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_to ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::cTlfWrk,iMaxWidth).
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_color("Spdf",.7,.0,.5).
  RUN pdf_text_to ("Spdf", oBrwNPSPTilbud:BUFFER-HANDLE::cURL,iMaxWidth).
  RUN pdf_link ("Spdf",pdf_TextX("Spdf"),840,400,830,"http://" + oBrwNPSPTilbud:BUFFER-HANDLE::cURL, 0, 0, 0, 0, "I").
  RUN pdf_skip    ("Spdf").
  RUN pdf_text_color("Spdf",.0,.0,.0).
  RUN pdf_skipn ("Spdf",2).

  RUN pdf_text_to ("Spdf", "Tvedestrand," + string(TODAY,'99.99.9999'),70).
  RUN pdf_skipn ("Spdf",6).
  RUN pdf_set_font ("Spdf","Helvetica-Bold",15.0).
  RUN pdf_text_color("Spdf",0.1,0.1,0.1). 
  RUN pdf_text_at ("Spdf", "TILBUD " + string(oBrwNPSPTilbud:BUFFER-HANDLE::tilbudsnr),iLeftColumn).
  RUN pdf_text_color("Spdf",0.0,0.0,0.0). 
  RUN pdf_set_font ("Spdf","Helvetica",8.0).
  RUN pdf_skipn ("Spdf",2).
  RUN pdf_text_at ("Spdf", "Deres ref.: " + oBrwNPSPTilbud:BUFFER-HANDLE::deres_ref,iLeftColumn).
  RUN pdf_text ("Spdf", "   Vår ref.: " + oBrwNPSPTilbud:BUFFER-HANDLE::vaar_ref).
  RUN pdf_skipn ("Spdf",3).

  RUN pdf_text_at ("Spdf", "Prosjektnr:",iLeftColumn).
  RUN pdf_text_at ("Spdf", STRING(oBrwNPSPTilbud:BUFFER-HANDLE::prosjektid),iColumn[1]).
  RUN pdf_skipn ("Spdf",1).
  RUN pdf_text_at ("Spdf", "Tilbudsnr:",iLeftColumn).
  RUN pdf_text_at ("Spdf", STRING(oBrwNPSPTilbud:BUFFER-HANDLE::tilbudsnr),iColumn[1]).
  RUN pdf_text_at ("Spdf", "Avdeling: ",iColumn[2]).
  RUN pdf_text ("Spdf", QUOTER("Nor-Term")).
  RUN pdf_skipn ("Spdf",1).
  RUN pdf_text_at ("Spdf", "Anlegg/Sak:",iLeftColumn).
  RUN pdf_text_at ("Spdf", STRING(oBrwNPSPTilbud:BUFFER-HANDLE::anlegg),iColumn[1]).
  RUN pdf_skipn ("Spdf",2).
  RUN pdf_wrap_text ("Spdf", STRING("Vi viser til forespørsel fra Dem, og har førnøyelsen av å tilby utstyr i h.h.t. vedlagt oppstilling."),iLeftColumn,iMaxWidth,'left',OUTPUT yPos).
  RUN pdf_skipn ("Spdf",2).
  RUN pdf_text_at ("Spdf", STRING("Samlet nettopris eks m.v.a kr.: "),iLeftColumn).
  RUN pdf_text_at("Spdf", STRING(ROUND(oBrwNPSPTilbud:BUFFER-HANDLE::avgittpris,1)) + ',-',iColumn[1]).
  RUN pdf_skipn ("Spdf",2).
  RUN pdf_text_at ("Spdf", STRING("Betalingsbetingelser:"),iLeftColumn).
  RUN pdf_text_at("Spdf", STRING(oBrwNPSPTilbud:BUFFER-HANDLE::bet_bet) + ',-',iColumn[1]).
  RUN pdf_skipn ("Spdf",1).
  RUN pdf_text_at ("Spdf", STRING("Leveringsbetingelser:"),iLeftColumn).
  RUN pdf_text_at("Spdf", STRING(oBrwNPSPTilbud:BUFFER-HANDLE::lev_bet) + ',-',iColumn[1]).
  RUN pdf_skipn ("Spdf",1).
  RUN pdf_text_at ("Spdf", STRING("Etter forfall beregnes morarenter."),iLeftColumn).
  RUN pdf_skipn ("Spdf",2).
  RUN pdf_text_at ("Spdf", STRING("Leveringstid:"),iLeftColumn).
  RUN pdf_text_at("Spdf", STRING(oBrwNPSPTilbud:BUFFER-HANDLE::leveringstid) + ',-',iColumn[1]).
  RUN pdf_skipn ("Spdf",2).
  cText = "Tilbudet er gyldig i &1 dager fra d.d., og er basert på våre standard salgs- og leveringsbetingelser,"
          + "samt NL92 om ikke annet avtales og bekreftes av oss. Forhold om endring i leveringstid/mellomsalg avhengig av kapasitet på bestillingstidspunktet".
  RUN pdf_wrap_text ("Spdf", SUBSTITUTE(cText,oBrwNPSPTilbud:BUFFER-HANDLE::gyldighetstid),iLeftColumn,iMaxWidth,'left',OUTPUT yPos).
  RUN pdf_skipn ("Spdf",2).
  bFlag = oBrwNPSPTILBUD:BUFFER-HANDLE::opplysninger = "".
  if bFlag then 
  do:
    RUN pdf_text_at ("Spdf", STRING("Spesielle opplysninger:"),iLeftColumn).
    RUN pdf_wrap_text ("Spdf",oBrwNPSPTILBUD:BUFFER-HANDLE::opplysninger,iLeftColumn,iMaxWidth,'left',OUTPUT yPos).
    RUN pdf_skipn ("Spdf",2).
  end.
  cText = "Vi håper tilbudet er i h.h.t. Deres ønske. Dersom noe er uklart i forhold til Deres forespørsel eller i forhold til beskrvelsen, ber vi Dem kontakte oss.".
  RUN pdf_wrap_text ("Spdf",cText,iLeftColumn,iMaxWidth,'left',OUTPUT yPos).
  cText = "Det skulle glede oss å motta Deres ordre, som vil ha vår største oppmerksomhet".
  RUN pdf_skipn ("Spdf",1).
  RUN pdf_wrap_text ("Spdf",cText,iLeftColumn,iMaxWidth,'left',OUTPUT yPos).
  
  RUN pdf_skipn ("Spdf",3).
  cText = "Med vennlig hilsen".
  RUN pdf_text_at("Spdf",cText,iLeftColumn).
  RUN pdf_line("Spdf",21,pdf_TextY("Spdf") - 1,pdf_text_width("Spdf",cText) * 1.4,pdf_TextY("Spdf") - 1, 1).
  
  RUN pdf_skipn ("Spdf",2).
  RUN pdf_text_at("Spdf",oBrwNPSPTILBUD:BUFFER-HANDLE::cCompanyName,iLeftColumn).

  RUN pdf_skipn ("Spdf",1).
  RUN pdf_text_at("Spdf",oBrwNPSPTILBUD:BUFFER-HANDLE::saksbehandler,iLeftColumn).

  /* Change the text color back to black */
  RUN pdf_text_color("Spdf",.0,.0,.0).
  
  /*  /* Change the Rectangle border to red and the fill to white */                              */
  /*  RUN pdf_stroke_color("Spdf",1.0,.0,.0).                                                     */
  /*  RUN pdf_stroke_fill("Spdf",1.0,1.0,1.0).                                                    */
  /*                                                                                              */
  /*  /* Display a boxed text string */                                                           */
  /*  RUN pdf_text_boxed_xy ("Spdf",                                                              */
  /*                     "This is BOXED text placed using XY coordinates",                        */
  /*                     100,                                                                     */
  /*                     450,                                                                     */
  /*                     pdf_text_width("Spdf", "This is BOXED text placed using XY coordinates"),*/
  /*                     10,"Left",1).                                                            */
  
  run PrintPDFsystem.
    
  RUN pdf_close("Spdf").

  oCMD = NEW JBoxCMD('C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe',cFilename).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrintPDFsystem C-Win 
PROCEDURE PrintPDFsystem :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
 DEFINE VARIABLE yPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLeftMargin AS INTEGER   INIT 20 NO-UNDO.
  DEFINE VARIABLE iMaxWidth   AS INTEGER   INIT 94 NO-UNDO.
  def var cText as char no-undo.
  def var bFlag as log  no-undo.
  def var bFlag2 as log no-undo.
  def var cTegning as char no-undo.
  
  def var iColumn as int extent 5 no-undo.
  
  def var hQ as handle no-undo.
  
  assign 
    iColumn[1] = iLeftColumn + 40
    iColumn[2] = 150
    iColumn[3] = 180
    .
   
  RUN pdf_new_page("Spdf").
  /*LOGO**/
  IF SEARCH(cFirmaLogo) NE ? THEN
  DO:
    RUN pdf_load_image ("Spdf","NorShuntLogo",cFirmalogo).
    RUN pdf_place_image ("Spdf","NorShuntLogo",380,40,200,30).
  END.

  RUN pdf_set_font("Spdf", "Helvetica-Bold",10).
  RUN pdf_text_at ("Spdf", "Spesifikasjoner i henhold til tilbud " + string(oBrwNPSPTilbud:BUFFER-HANDLE::tilbudsnr),iLeftColumn).
  RUN pdf_skipn    ("Spdf",2).
  RUN pdf_set_font("Spdf", "Helvetica",10).
  RUN pdf_text_at("Spdf","Anleggsnr: ",iLeftColumn).
  RUN pdf_text("Spdf",string(oBrwNPSPTILBUD:BUFFER-HANDLE::anleggsnr)).
  RUN pdf_text_at("Spdf",string(oBrwNPSPTILBUD:BUFFER-HANDLE::anlegg),48).
  RUN pdf_line("Spdf",pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") - 5, pdf_PageWidth("Spdf") - 20 , pdf_TextY("Spdf") - 5, 1).
  
  hQ = oBrwNPSPSYST:QUERY-HANDLE.
  
  hQ:get-first().
  RUN pdf_set_font("Spdf", "Helvetica",10).
  RUN pdf_skipn ("Spdf",2).
  do while not hQ:query-off-end:
    RUN pdf_text_at("Spdf","System: ",iLeftColumn).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSyst:BUFFER-HANDLE::systemnr) + ' - ' + oBrwNPSPSYST:BUFFER-HANDLE::systembetegnelse,iColumn[1]).
    RUN pdf_skipn ("Spdf",1).
   
    RUN pdf_text_at("Spdf","Varenr./NRF nr.:",iLeftColumn).
    RUN  pdf_text_color("Spdf",0.0,0.0,1.0).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::varenr),iColumn[1]).
    RUN pdf_link ("Spdf",pdf_TextX("Spdf") - 45,pdf_TextY("Spdf") - 5, 85,pdf_TextY("Spdf") + 13,"http://10.10.99.190/sb/norshunt.sh/vareinfo.r?varenr=" + string(oBrwNPSPSYST:BUFFER-HANDLE::varenr), 0.0, 0.0, 0.3, 0, "O").
    RUN  pdf_text_color("Spdf",0.0,.0,.0).
    RUN pdf_text("Spdf",' / ' + string(oBrwNPSPSYST:BUFFER-HANDLE::nrf_nr)).
    RUN pdf_skipn ("Spdf",1).
   
    RUN pdf_text_at("Spdf","Produkttype:",iLeftColumn).
    RUN pdf_text_at("Spdf",oBrwNPSPSYST:BUFFER-HANDLE::Produkttype,iColumn[1]).
    RUN pdf_skipn ("Spdf",1).
   
    RUN pdf_text_at("Spdf","Produktnavn:",iLeftColumn).
    RUN pdf_text_at("Spdf",oBrwNPSPSYST:BUFFER-HANDLE::Produktnavn,iColumn[1]).
    RUN pdf_skipn ("Spdf",2).
   
    hQ:get-next().
  end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE PrintPDFtekniskRecord C-Win 
PROCEDURE PrintPDFtekniskRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
  DEFINE VARIABLE yPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLeftMargin AS INTEGER   INIT 20 NO-UNDO.
  DEFINE VARIABLE iMaxWidth   AS INTEGER   INIT 94 NO-UNDO.
  def var cText as char no-undo.
  def var bFlag as log  no-undo.
  def var bFlag2 as log no-undo.
  def var cTegning as char no-undo.
  
  def var iColumn as int extent 5 no-undo.
  
  def var hQ as handle no-undo.
  
  assign 
    iColumn[1] = iLeftColumn + 40
    iColumn[2] = 150
    iColumn[3] = 180
    .
   
  RUN pdf_new_page("Spdf").
  /*LOGO**/
  IF SEARCH(cFirmaLogo) NE ? THEN
  DO:
    RUN pdf_load_image ("Spdf","NorShuntLogo",cFirmalogo).
    RUN pdf_place_image ("Spdf","NorShuntLogo",380,40,200,30).
  END.

  RUN pdf_skipn    ("Spdf",2).
  RUN pdf_stroke_fill ("Spdf",1.0,1.0,1.0).
  //RUN pdf_text_boxed_xy ("Spdf", cText, 2,pdf_TextY("Spdf"), pdf_Text_Width("Spdf",cText), 20, "Left",1).
  cText = "SPIRO - Saksmappens kontrollkopi".
  RUN pdf_rect ("Spdf",15,pdf_TextY('SPDF') - 5,PDF_Text_Width("Spdf",cText) + iLeftColumn + 15, 20,0.1).  
  RUN pdf_text_at("Spdf", "SPIRO - Saksmappens kontrollkopi",iLeftColumn).
  RUN pdf_text_at("Spdf","Anleggsnr: ",80).
  RUN pdf_text("Spdf",string(oBrwNPSPTILBUD:BUFFER-HANDLE::anleggsnr)).
  RUN pdf_text("Spdf","  Utarbeidet: " + string(oBrwNPSPTILBUD:BUFFER-HANDLE::dato,"99.99.9999")).
  RUN pdf_skipn ("Spdf",2).
  RUN pdf_text("Spdf","Teknisk spesifikasjon for:").
  RUN pdf_text_at("Spdf",string(oBrwNPSPTILBUD:BUFFER-HANDLE::anlegg),48).
  RUN pdf_line("Spdf",pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") - 5, pdf_PageWidth("Spdf") - 20 , pdf_TextY("Spdf") - 5, 2).
  
  hQ = oBrwNPSPSYST:QUERY-HANDLE.
  
  hQ:get-first().
  RUN pdf_set_font("Spdf", "Helvetica",6).
  do while not hQ:query-off-end:
    RUN pdf_skipn ("Spdf",2).
    RUN pdf_text_at("Spdf","System:",iLeftColumn).
    RUN pdf_text_at("Spdf",oBrwNPSPSYST:BUFFER-HANDLE::systembetegnelse,iColumn[1]).
    RUN pdf_text_at("Spdf",'Nr:' + string(oBrwNPSPSyst:BUFFER-HANDLE::systemnr),iColumn[2]).
    RUN pdf_skipn ("Spdf",1).
   
    RUN pdf_text_at("Spdf","Varenr./NRF nr.:",iLeftColumn).
    RUN  pdf_text_color("Spdf",0.0,0.0,1.0).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::varenr),iColumn[1]).
    RUN pdf_link ("Spdf",pdf_TextX("Spdf") - 45,pdf_TextY("Spdf") - 5, 85,pdf_TextY("Spdf") + 10,"http://10.10.99.190/sb/norshunt.sh/vareinfo.r?varenr=" + string(oBrwNPSPSYST:BUFFER-HANDLE::varenr), 0.0, 0.0, 0.3, 0, "O").
    RUN  pdf_text_color("Spdf",0.0,.0,.0).
    RUN pdf_text("Spdf",' / ' + string(oBrwNPSPSYST:BUFFER-HANDLE::nrf_nr)).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*') .
    cText = if bFlag then 'Innmat' else ''. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if bFlag then string(oBrwNPSPSYST:BUFFER-HANDLE::innmat) else '',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
   
    RUN pdf_text_at("Spdf","Produkttype:",iLeftColumn).
    RUN pdf_text_at("Spdf",oBrwNPSPSYST:BUFFER-HANDLE::Produkttype,iColumn[1]).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Dirt*') .
    cText = if bFlag then 'Avstand flotør' else ''. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_to("Spdf",if bFlag then string(oBrwNPSPSYST:BUFFER-HANDLE::avstand_flotor) + ' mm' else '',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
   
    RUN pdf_text_at("Spdf","Produktnavn:",iLeftColumn).
    RUN pdf_text_at("Spdf",oBrwNPSPSYST:BUFFER-HANDLE::Produktnavn,iColumn[1]).
    cText = 'Max trykk:'. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::max_trykk) + ' bar',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
   
    RUN pdf_text_at("Spdf","Anslutning:",iLeftColumn).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::dimmensjon) + ' ' + string(oBrwNPSPSYST:BUFFER-HANDLE::anslutning),iColumn[1]).
    cText = 'Max temp:'. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::max_temp) + ' °C',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    RUN pdf_text_at("Spdf","Materialkvalitet:",iLeftColumn).
    RUN pdf_text_at("Spdf",oBrwNPSPSYST:BUFFER-HANDLE::materialkvaliteter,iColumn[1]).
    cText = 'Medietemp:'. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if oBrwNPSPSYST:BUFFER-HANDLE::medietemperatur = '' then "UKJENT" else string(oBrwNPSPSYST:BUFFER-HANDLE::medietemperatur) + ' °C',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    
    RUN pdf_text_at("Spdf","Beregnet av:",iLeftColumn).
    RUN pdf_text_at("Spdf",oBrwNPSPSYST:BUFFER-HANDLE::beregnet_anvendelse,iColumn[1]).
    cText = 'Frostvæske:'. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if oBrwNPSPSYST:BUFFER-HANDLE::glykoltype = '' then "ingen" else string(oBrwNPSPSYST:BUFFER-HANDLE::glykoltype),iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*').
    cText = if bFlag then 'Hurtigluftventil' else ''. 
    RUN pdf_text_at("Spdf",cText + ':',iLeftColumn).
    RUN pdf_text_at("Spdf",if bFlag then string(oBrwNPSPSYST:BUFFER-HANDLE::hurtigventil,'Ja/Nei') else '',iColumn[1]).
    cText = 'Konsentrasjon:'. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::konsentrasjon),iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    
    cText = if (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*') then 'Utv. gjenget lufteventil' else ''. 
    RUN pdf_text_at("Spdf",cText,iLeftColumn).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*').
    cText = if bFlag then 'Korreksjon' else ''. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if bFlag then (if oBrwNPSPSYST:BUFFER-HANDLE::faktor = 0 then '0' else string(oBrwNPSPSYST:BUFFER-HANDLE::faktor,'>9.999')) else '',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*'). 
    cText = if bFlag then 'Avt.plugg' else ''. 
    RUN pdf_text_at("Spdf",cText,iLeftColumn).
    RUN pdf_text_at("Spdf",
    if bFlag then (if oBrwNPSPSYST:BUFFER-HANDLE::avt_plugg = '' or oBrwNPSPSYST:BUFFER-HANDLE::avt_plugg = ? then "nei" else string(oBrwNPSPSYST:BUFFER-HANDLE::avt_plugg)) else '' ,iColumn[1]).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*').
    cText = if bFlag then 'Kapasitet' else ''. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if bFlag then (if oBrwNPSPSYST:BUFFER-HANDLE::spiroventkapasitet = 0 then 'Ukjent' else string(oBrwNPSPSYST:BUFFER-HANDLE::Spiroventkapasitet,'->>9.9') + ' l/s') else '',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    
    cText = if (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*') then 'Kuleventil' else ''. 
    RUN pdf_text_at("Spdf",cText,iLeftColumn).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*').
    cText = if bFlag then 'Trykkfall' else ''. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if bFlag then (if oBrwNPSPSYST:BUFFER-HANDLE::trykkfall = 0 or oBrwNPSPSYST:BUFFER-HANDLE::trykkfall = ? then 'Ukjent' else string(oBrwNPSPSYST:BUFFER-HANDLE::Trykkfall,'->>>9.999') + ' kPa') else '',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    
    cText = if (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*') then 'Isolasjon/Mantel' else ''. 
    RUN pdf_text_at("Spdf",cText,iLeftColumn).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*').
    cText = if bFlag then 'Innløpshastighet' else ''. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if bFlag then (if oBrwNPSPSYST:BUFFER-HANDLE::innl_hastighet = 0 or oBrwNPSPSYST:BUFFER-HANDLE::innl_hastighet = ? then 'Ukjent' else string(oBrwNPSPSYST:BUFFER-HANDLE::Innl_hastighet,'->>>9.999') + ' kPa') else '',iColumn[3]).    
    RUN pdf_skipn ("Spdf",1).
    
    cText = if (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn2 matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*') then 'Motlfenser' else ''. 
    RUN pdf_text_at("Spdf",cText,iLeftColumn).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Superior*' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*').
    cText = if bFlag then 'Anb.max innl. hast' else ''. 
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if bFlag then (if oBrwNPSPSYST:BUFFER-HANDLE::anb_max_innl_hast = 0 or oBrwNPSPSYST:BUFFER-HANDLE::anb_max_innl_hast = ? then 'Ukjent' else string(oBrwNPSPSYST:BUFFER-HANDLE::anb_max_innl_hast,'->>>9.999') + ' m/s') else '',iColumn[3]).
    RUN pdf_skipn ("Spdf",1).
    bFlag = (oBrwNPSPSYST:BUFFER-HANDLE::produktnavn = 'Spirotop' or oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches '*Refill*').
    bFlag2 = oBrwNPSPSYST:BUFFER-HANDLE::produktnavn matches "*Superior*".
    cText = if bFlag then '' else (if bFlag2 then 'Max vannvolum' else (if oBrwNPSPSYST:BUFFER-HANDLE::spiroventkapasitet = 0 then 'Anb. max. kap.' else '')).  
    RUN pdf_text_at("Spdf",cText,iColumn[2]).
    RUN pdf_text_at("Spdf",if bFlag then '' else (if bFlag2 then 'm3' else if oBrwNPSPSYST:BUFFER-HANDLE::spiroventkapasitet = 0 then 'm3/t' else ''),iColumn[3]).
    RUN pdf_skipn ("Spdf",1).

    RUN pdf_text_at("Spdf","Pris pr. stk:",iLeftColumn).
    RUN pdf_text_at("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::listepris,'NKr ->>,>>>,>>9.99'),iColumn[1]).
    RUN pdf_text_at("Spdf","Antall:",iLeftColumn + 80).
    RUN pdf_text("Spdf",string(oBrwNPSPSYST:BUFFER-HANDLE::antall)).
    RUN pdf_text_to("Spdf",'Pris for system: ' + string(oBrwNPSPSYST:BUFFER-HANDLE::listepris * oBrwNPSPSYST:BUFFER-HANDLE::antall,'Nkr ->,>>>,>>>,>>9.99'),70).
    RUN pdf_line("Spdf",pdf_LeftMargin("Spdf"), pdf_TextY("Spdf") - 5, pdf_PageWidth("Spdf") - 20 , pdf_TextY("Spdf") - 5, 1).
    RUN pdf_skipn ("Spdf",2).
    
    cTegning = './bmp/' + oBrwNPSPSYST:BUFFER-HANDLE::tegnings_ref + '.jpg'.
    if cTegning = './bmp/.BMP/' then cTegning = './bmp/kobling2.jpg'.
    IF SEARCH(cTegning) NE ? THEN
    DO:
      file-info:FILE-NAME = cTegning.
      MESSAGE file-info:FULL-PATHNAME
      VIEW-AS ALERT-BOX.
      MESSAGE cTegning
      VIEW-AS ALERT-BOX.
      RUN pdf_load_image ("Spdf","Tegning",file-info:FULL-PATHNAME).
      RUN pdf_place_image ("Spdf","Tegning",20,600,200,40).
    END.
    
    hQ:get-next().
  end.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

