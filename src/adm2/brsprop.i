&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : brsprop.i
    Purpose     : Basic Property definition include file for 
                  SmartDataBrowse Objects

    Syntax      : {src/adm2/brsprop.i}

    Description :

    Modified    : August 18, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/browserdefscustom.i}

/* SearchField is added as a property for non-DB browsers.
   ForeignFields is added for DB Browsers. */
&IF DEFINED(INTERNAL-TABLES) EQ 0 &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}SearchField,NumDown,CalcWidth,MaxWidth
&ELSEIF "{&INTERNAL-TABLES}":U NE "RowObject":U &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}ForeignFields
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */



  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/brsprto.i}
&ENDIF

  &GLOB xpBrowseHandle        
  &GLOB xpBrowseInitted   
  &GLOB xpCalcWidth
  &GLOB xpMaxWidth 
  &GLOB xpModifiedFields
  &GLOB xpNumDown
  &GLOB xpSearchField
  &GLOB xpSearchHandle
  &GLOB xpApplyActionOnExit
  &GLOB xpApplyExitOnAction
  {src/adm2/dvisprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('BrowseHandle':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('BrowseInitted':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('CalcWidth':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('MaxWidth':U, 'DECIMAL':U, 0, ?, 80).
  ghADMProps:ADD-NEW-FIELD('ModifiedFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('NumDown':U, 'INTEGER':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('SearchField':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('SearchHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('ActionEvent':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('ApplyActionOnExit':U, 'LOG':U).
  ghADMProps:ADD-NEW-FIELD('ApplyExitOnAction':U, 'LOG':U).
&ENDIF

  {src/adm2/custom/brspropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


