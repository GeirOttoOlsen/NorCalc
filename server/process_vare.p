&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : 
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEF INPUT  PARAM icParam     AS CHAR   NO-UNDO.
DEF INPUT  PARAM ihBuffer    AS HANDLE NO-UNDO.
DEF INPUT  PARAM icSessionId AS CHAR   NO-UNDO.
DEF OUTPUT PARAM ocReturn    AS CHAR   NO-UNDO.
DEF OUTPUT PARAM obOK        AS LOG    NO-UNDO.

DEF VAR produktnavnParam AS CHAR NO-UNDO.
DEF VAR kapasitetParam   AS DEC  NO-UNDO.
DEF VAR faktorParam      AS DEC  NO-UNDO.
DEF VAR innl_hastParam   AS DEC  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

MESSAGE icParam
  VIEW-AS ALERT-BOX INFO BUTTONS OK.
ASSIGN 
  produktnavnParam = ENTRY(1,icParam,'|')
  kapasitetParam   = DEC(ENTRY(2,icParam,'|'))
  faktorParam      = DEC(ENTRY(3,icParam,'|'))
  innl_hastParam   = DEC(ENTRY(4,icParam,'|'))
.

RUN BeregnKPA.

/**************
DEFINE INPUT PARAMETER tittelParam AS CHAR. 
DEFINE INPUT PARAMETER produktnavnParam LIKE NPSPSYST.produktnavn.
DEFINE INPUT PARAMETER kapasitetParam LIKE NPSPSYST.spiroventkapasitet.
/*DEFINE INPUT PARAMETER anslutningParam LIKE NPSPSYST.anslutning.*/
DEFINE INPUT PARAMETER anbefaltMaxParam AS DECIMAL.
DEFINE INPUT PARAMETER faktorParam LIKE NPSPSYST.faktor.
DEFINE OUTPUT PARAMETER varenrParam LIKE NPSPVARELISTE.varenr.
DEFINE OUTPUT PARAMETER nrfnrParam LIKE NPSPVARELISTE.nrf_nr.
DEFINE OUTPUT PARAMETER innl_hastParam LIKE NPSPSYST.innl_hast.
DEFINE OUTPUT PARAMETER trykkfallParam LIKE NPSPSYST.trykkfall.
               ****************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-BeregnKPA) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeregnKPA Procedure 
PROCEDURE BeregnKPA :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR c_nedre AS DECIMAL NO-UNDO.
  DEFINE VAR c_ovre AS DECIMAL NO-UNDO.
  DEFINE VAR c_nevner_kpa AS DECIMAL NO-UNDO.
  DEFINE VAR c_utregnet_kpa AS DECIMAL NO-UNDO.
  DEFINE VAR teller AS INTEGER INITIAL 1 NO-UNDO.
  DEFINE VAR  pi as decimal initial 3.14 NO-UNDO.
  DEFINE VAR v_indre_diameter AS DECIMAL NO-UNDO.
  DEF VAR i AS INT NO-UNDO.

 /* Hent valgte produktnavn fra vareliste */
  FOR EACH NPSPVARELISTE WHERE NPSPVARELISTE.produktnavn MATCHES produktnavnParam NO-LOCK:
    ihBuffer:BUFFER-CREATE().
    ASSIGN 
      i = i + 1
      ihBuffer:BUFFER-FIELD('Id'):BUFFER-VALUE = i
      ihBuffer:BUFFER-FIELD('varenr'):BUFFER-VALUE  = npspvareliste.varenr
      ihBuffer:BUFFER-FIELD('produktnavn'):BUFFER-VALUE  = npspvareliste.produktnavn
      ihBuffer:BUFFER-FIELD('dimmensjon'):BUFFER-VALUE  = npspvareliste.dimmensjon
      ihBuffer:BUFFER-FIELD('anslutning'):BUFFER-VALUE  = npspvareliste.anslutning
      ihBuffer:BUFFER-FIELD('materialkvaliteter'):BUFFER-VALUE  = npspvareliste.materialkvalitet
      c_utregnet_kpa = IF faktorParam > 0 THEN (c_utregnet_kpa *  faktorParam) ELSE EXP((((kapasitetParam * 60) * 0.6) /  NPSPVARELISTE.kv_verdi), 2)
      ihBuffer:BUFFER-FIELD('KPA'):BUFFER-VALUE  = c_utregnet_kpa
      v_indre_diameter = NPSPVARELISTE.ror_dim - (NPSPVARELISTE.vegg_tykkelse * 2)
      innl_hastParam = kapasitetParam * 1000 /  ((v_indre_diameter * v_indre_diameter * pi) / 4)
      ihBuffer:BUFFER-FIELD('innl_hastighet'):BUFFER-VALUE  = innl_hastparam
    .
  END.
  
  ASSIGN 
    obOk = TRUE
    ocReturn = ''
  .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

