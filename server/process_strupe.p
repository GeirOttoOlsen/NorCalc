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

DEF VAR c_kapasitet AS DEC NO-UNDO.
DEF VAR cFabrikat   AS CHAR NO-UNDO.

DEF VAR i AS INTEGER NO-UNDO.

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
  cFabrikat   = ENTRY(1,icParam,'|')
  c_kapasitet = DEC(ENTRY(2,icParam,'|'))
.
RUN beregnMotstand.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-beregnMotstand) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnMotstand Procedure 
PROCEDURE beregnMotstand :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VAR c_id AS INTEGER NO-UNDO.
  DEFINE VAR c_anbefalt AS DECIMAL NO-UNDO.  
  DEF VAR c_delta_Pstr AS DEC NO-UNDO.
  DEF VAR fKVS AS DEC NO-UNDO.
  
  FOR EACH NPSHSDIM BY dimm_id:
      ihBuffer:BUFFER-CREATE().
      IF cFabrikat = 'TA'      THEN fKVS = ta_kvs. 
      ELSE IF cFabrikat = 'DA' THEN fKVS = da_kvs. 
      ELSE IF cFabrikat = 'HM' THEN fKVS = hm_kvs.
      ELSE 
      DO:
        ASSIGN 
          ocReturn = 'Feil fabrikat verdi:' + cFabrikat
          obOk     = FALSE.
        RETURN.
      END.
      ASSIGN 
        c_id = c_id + 1          
        c_delta_Pstr  = EXP((((c_kapasitet * 60) * 0.6) / fKVS),2)
      .
      ASSIGN
          ihBuffer:BUFFER-FIELD('dimm_id'):BUFFER-VALUE     = c_id
          ihBuffer:BUFFER-FIELD('dimmensjon'):BUFFER-VALUE = Dimmensjon
          ihBuffer:BUFFER-FIELD('kvs'):BUFFER-VALUE         = fKVS
          ihBuffer:BUFFER-FIELD('motstand'):BUFFER-VALUE    = c_delta_Pstr
          obOk = TRUE.
          .

   END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

