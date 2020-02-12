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

DEF VAR anleggsnrParam AS INT NO-UNDO.
DEF VAR systemnrParam  AS INT NO-UNDO.
DEF VAR autoritetParam AS DEC NO-UNDO.
DEF VAR kpa            AS DEC NO-UNDO.
DEF VAR kvs            AS DEC NO-UNDO.
DEF VAR parameter1     AS DEC NO-UNDO.
DEF VAR parameter2     AS DEC NO-UNDO.

DEFINE VAR koblingsAlternativ AS CHAR INITIAL '  ' NO-UNDO.
DEFINE VAR selectedRow        AS LOGICAL NO-UNDO.
DEFINE VAR  i                 AS INTEGER NO-UNDO.
DEFINE VAR cMSVentilType      AS CHAR NO-UNDO.

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
ASSIGN 
  anleggsnrParam = INT(ENTRY(1,icParam,'|'))
  systemnrParam  = INT(ENTRY(2,icParam,'|'))
  parameter1     = INT(ENTRY(3,icParam,'|'))
  parameter2     = INT(ENTRY(4,icParam,'|'))
.

RUN BeregnKPA.
/*
/*Tilordne rett anbefalt verdi */
CASE koblingsAlternativ:    
    WHEN '1' OR WHEN '5'  OR WHEN  '7A' THEN RUN beregn1_5.
    WHEN '2' THEN                            RUN beregn2.
    WHEN '3' OR WHEN '4' THEN                RUN beregn3_4.
    WHEN '6' THEN                            RUN beregn6.
    WHEN '7'  THEN                           RUN beregn7.
END CASE.
  */

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
/*  DEFINE VAR c_storrelse LIKE NPSHFMGR.storrelse NO-UNDO.*/
  def c_storrelse as char no-undo.
  DEFINE VAR c_nedre AS DECIMAL NO-UNDO.
  DEFINE VAR c_ovre AS DECIMAL NO-UNDO.
  DEFINE VAR c_nevner_kpa AS DECIMAL NO-UNDO.
  DEFINE VAR c_utregnet_kpa AS DECIMAL NO-UNDO.
  DEFINE VAR c_element2_nevner_autoritet AS DECIMAL NO-UNDO.
  DEFINE VAR c_nevner_autoritet AS DECIMAL NO-UNDO.
  DEFINE VAR c_utregnet_autoritet  AS DECIMAL INITIAL 0.00000 NO-UNDO.
  DEFINE VAR c_konstant AS INTEGER NO-UNDO.
  DEFINE VAR c_kap_prim LIKE NPSHSYST.prim_kapasitet NO-UNDO.
  DEFINE VAR c_kap_sek LIKE NPSHSYST.sek_kapasitet NO-UNDO.
  DEFINE VAR c_type LIKE NPSHSYST.type NO-UNDO.

  /* Hent dimmensjon fra System - type er både FM og MS*/
  FIND NPSHSYST WHERE NPSHSYST.anleggsnr = anleggsnrParam AND NPSHSYST.systemnr = systemnrParam NO-LOCK NO-WAIT NO-ERROR.
  IF AVAILABLE(NPSHSYST) THEN
    DO:
      c_storrelse        = NPSHSYST.shunt_dimmensjon.
      c_kap_prim         = NPSHSYST.prim_kapasitet.
      c_kap_sek          = NPSHSYST.sek_kapasitet.
      koblingsAlternativ = NPSHSYST.koblings_alternativ.   
      cMSVentilType      = NPSHSYST.ms_ventiltype.
    END.
     
    /*Regn ut KPA for alle KVS - verdier */
    CASE c_storrelse:
        WHEN '25'  THEN c_konstant = 15.
        WHEN '32'  THEN c_konstant = 28.
        WHEN '40'  THEN c_konstant = 36.
        WHEN '50'  THEN c_konstant = 45.
        WHEN '65'  THEN c_konstant = 120.
        WHEN '80'  THEN c_konstant = 195.
        WHEN '100' THEN c_konstant = 230.
        WHEN '125' THEN c_konstant = 290.
        WHEN '150' THEN c_konstant = 485.
    END CASE.

    c_Type = NPSHSYST.type.
    IF c_type = 'FM' THEN
    DO:     
      FOR EACH NPSHFKVS NO-LOCK BY NPSHFKVS.kvs_verdi:
        IF NPSHFKVS.shunt_dimmensjon = c_storrelse THEN
        DO:
            ihBuffer:BUFFER-CREATE().
            ASSIGN 
              i = i + 1
              ihBuffer:BUFFER-FIELD('Id'):BUFFER-VALUE = i
              ihBuffer:BUFFER-FIELD('KVS'):BUFFER-VALUE  = NPSHFKVS.kvs_verdi
            .
            CASE koblingsAlternativ:
                WHEN '5' OR WHEN '7' THEN c_utregnet_kpa = EXP((((c_kap_prim * 60) * 0.6) / NPSHFKVS.kvs_verdi), 2).               
                OTHERWISE                 c_utregnet_kpa = EXP((((c_kap_sek * 60) * 0.6) / NPSHFKVS.kvs_verdi), 2).               
            END CASE.
            ASSIGN ihBuffer:BUFFER-FIELD('KPA'):BUFFER-VALUE  = c_utregnet_kpa. 
            
            /* Regn ut autoritet ihht. valgt koblingsalternativ */               
            CASE koblingsAlternativ:
                WHEN '5' OR WHEN '7' THEN c_element2_nevner_autoritet =  EXP((((c_kap_prim * 60) * 0.6) / c_konstant), 2).
                OTHERWISE                 c_element2_nevner_autoritet =  EXP((((c_kap_sek * 60) * 0.6) / c_konstant), 2).
            END CASE.
            CASE koblingsAlternativ:
                 WHEN '1' OR WHEN '5'  OR WHEN  '7A' THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet.
                 WHEN '2' OR WHEN '3' OR WHEN '7'  THEN   c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1.
                 WHEN '4'  OR WHEN '6' THEN               c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1 + parameter2.
            END CASE.                                           
            ASSIGN 
              c_utregnet_autoritet = c_utregnet_kpa / c_nevner_autoritet.
              ihBuffer:BUFFER-FIELD('Autoritet'):BUFFER-VALUE  = c_utregnet_autoritet.
        END.
      END.
    END.
    ELSE
    DO:     
      FOR EACH NPSHMKVS NO-LOCK WHERE NPSHMKVS.ventiltype = cMSVentiltype BY NPSHMKVS.kvs_verdi:
        IF NPSHMKVS.shunt_dimmensjon = c_storrelse THEN
        DO:
          ihBuffer:BUFFER-CREATE().

          ASSIGN 
            i = i + 1
            ihBuffer:BUFFER-FIELD('Id'):BUFFER-VALUE = i
            ihBuffer:BUFFER-FIELD('KVS'):BUFFER-VALUE  = NPSHMKVS.kvs_verdi
            .
          CASE koblingsAlternativ:
            WHEN '5' OR WHEN '7' THEN c_utregnet_kpa = EXP((((c_kap_prim * 60) * 0.6) / NPSHMKVS.kvs_verdi), 2).               
            OTHERWISE                 c_utregnet_kpa = EXP((((c_kap_sek * 60) * 0.6) / NPSHMKVS.kvs_verdi), 2).               
          END CASE.
          ihBuffer:BUFFER-FIELD('KPA'):BUFFER-VALUE  = c_utregnet_kpa. 
      
            /* Regn ut autoritet ihht. valgt koblingsalternativ */               
          CASE koblingsAlternativ:
            WHEN '5' OR WHEN '7' THEN c_element2_nevner_autoritet =  EXP((((c_kap_prim * 60) * 0.6) / c_konstant), 2).
            OTHERWISE                 c_element2_nevner_autoritet =  EXP((((c_kap_sek * 60) * 0.6) / c_konstant), 2).
          END CASE.
      
          CASE koblingsAlternativ:
            WHEN '1' OR WHEN '5'  OR WHEN  '7A' THEN c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet.
            WHEN '2' OR WHEN '3' OR WHEN '7'  THEN   c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1.
            WHEN '4'  OR WHEN '6' THEN               c_nevner_autoritet = c_utregnet_kpa + c_element2_nevner_autoritet + parameter1 + parameter2.
          END CASE.                                          
          ASSIGN 
            c_utregnet_autoritet = c_utregnet_kpa / c_nevner_autoritet
            ihBuffer:BUFFER-FIELD('Autoritet'):BUFFER-VALUE =  c_utregnet_autoritet
          .
        END.
      END.
    END.   
    ASSIGN 
      obOk = TRUE
      ocReturn = ''
      .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

