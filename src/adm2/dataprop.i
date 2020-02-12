&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : dataprop.i
    Purpose     : Starts data.p Super procedure and defines Basic DataObject
                  properties.
    Syntax      : {src/adm2/dataprop.i}

    Description :

    Modified    : October 4, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/datadefscustom.i}

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
AppService,ASUsePrompt,ASInfo,ForeignFields,RowsToBatch,CheckCurrentChanged,RebuildOnRepos,ServerOperatingMode,DestroyStateless,DisconnectAppServer

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/datad.w
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
  {src/adm2/dataprto.i}
&ENDIF
 
 /* Preprocessor definitions which tell at compile time which
    properties can be retrieved directly from the property temp-table. */
 &GLOB xpRowObject
 &GLOB xpRowObjUpd
 &GLOB xpFirstRowNum            
 &GLOB xpLastRowNum             
 &GLOB xpEnabledTables          
 &GLOB xpAutoCommit             
 &GLOB xpDataHandle             
 &GLOB xpCurrentRowid           
 &GLOB xpAppService             
 &GLOB xpASUsePrompt            
 &GLOB xpASInfo                 
 &GLOB xpASDivision             
 &GLOB xpUpdateSource           
 &GLOB xpCommitSource           
 &GLOB xpCommitSourceEvents     
 &GLOB xpCommitTarget           
 &GLOB xpCommitTargetEvents     
 &GLOB xpDataModified
 &GLOB xpRowsToBatch
 &GLOB xpCheckCurrentChanged
 &GLOB xpFirstResultRow
 &GLOB xpLastResultRow
 &GLOB xpRebuildOnRepos
 &GLOB xpServerOperatingMode
 &GLOB xpStatelessSavedProperties
 &GLOB xpDestroyStateless
 &GLOB xpDisconnectAppserver

{src/adm2/qryprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('RowObject':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RowObjUpd':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FirstRowNum':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LastRowNum':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('EnabledTables':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('AutoCommit':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('DataHandle':U, 'HANDLE':U).   
  ghADMProps:ADD-NEW-FIELD('CurrentRowid':U, 'ROWID':U).
  ghADMProps:ADD-NEW-FIELD('AppService':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ASUsePrompt':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('ASInfo':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ASHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('ASDivision':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdateSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('CommitSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('CommitSourceEvents':U, 'CHAR':U, 0, ?, 
    'commitTransaction,undoTransaction':U).
  ghADMProps:ADD-NEW-FIELD('CommitTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CommitTargetEvents':U, 'CHAR':U, 0, ?, 'rowObjectState':U).
  ghADMProps:ADD-NEW-FIELD('DataModified':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('RowsToBatch':U, 'INT':U, 0, ?, 200).  /* Rows per AppServer xfer */
  ghADMProps:ADD-NEW-FIELD('CheckCurrentChanged':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('DataQueryBrowsed':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('FirstResultRow':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LastResultRow':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RebuildOnRepos':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('RowObjectState':U, 'CHAR':U, 0, ?, 'NoUpdates':U).
  ghADMProps:ADD-NEW-FIELD('ServerOperatingMode':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('StatelessSavedProperties':U, 'CHAR':U, 0, ?, 
    'CheckCurrentChanged,RowObjectState,LastResultRow,FirstResultRow,QueryRowIdent':U).
  ghADMProps:ADD-NEW-FIELD('DestroyStateless':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('DisconnectAppServer':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('ServerSubmitValidation':U, 'LOGICAL':U, 0, ?, no).
&ENDIF

  {src/adm2/custom/datapropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


