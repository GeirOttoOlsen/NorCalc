&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : dvisprop.i
    Purpose     : Property Include file for Data Visualization Objects 

    Syntax      : src\adm2\dvisprop.i

    Description :

    Modified    : May 19, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/datavisdefscustom.i}

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
  {src/adm2/dvisprto.i}
&ENDIF

  /* These preprocessors tell at compile time which properties can be
     retrieved directly from the property temp-table. */
  &GLOB xpFieldsEnabled         
  &GLOB xpNewRecord             
  &GLOB xpRowIdent              
  &GLOB xpDisplayedFields       
  &GLOB xpEnabledHandles        
  &GLOB xpCreateHandles         
  &GLOB xpEnabledFields         
  &GLOB xpFieldHandles          
  &GLOB xpTableIOSource         
  &GLOB xpTableIOSourceEvents   
  &GLOB xpSaveSource            
  &GLOB xpRecordState           
  &GLOB xpUpdateTarget          
  &GLOB xpGroupAssignSource     
  &GLOB xpGroupAssignTarget     
  &GLOB xpGroupAssignSourceEvents 
  &GLOB xpGroupAssignTargetEvents 

  /* Include the next property file up the chain; we will add our field
     definitions to its list. As of 9.1A, if this visual object is also
     a SmartContainer, we include container properties as well. */

&IF DEFINED(ADM-CONTAINER) NE 0 &THEN
  {src/adm2/cntnprop.i}
&ELSE
  {src/adm2/visprop.i}
&ENDIF

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('FieldsEnabled':U, 'LOGICAL':U, 0, ?, no). 
  ghADMProps:ADD-NEW-FIELD('DataModified':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('NewRecord':U, 'CHAR':U, 0, ?, 'No':U). /* Values: Add, Copy, No */
  ghADMProps:ADD-NEW-FIELD('RowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DisplayedFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('EnabledHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CreateHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('EnabledFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('TableIOSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('TableIOSourceEvents':U, 'CHAR':U, 0, ?, 
    'addRecord,updateRecord,copyRecord,deleteRecord,resetRecord,cancelRecord,updateMode':U).
  ghADMProps:ADD-NEW-FIELD('SaveSource':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RecordState':U, 'CHAR':U, 0, ?, 'NoRecordAvailable':U).
  ghADMProps:ADD-NEW-FIELD('UpdateTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignSourceEvents':U, 'CHAR':U, 0, ?, 
    'addRecord,copyRecord,updateRecord,resetRecord,cancelRecord,enableFields,disableFields,collectChanges,validateFields':U).
  ghADMProps:ADD-NEW-FIELD('GroupAssignTargetEvents':U, 'CHAR':U, 0, ?, 'updateState':U).
&ENDIF

  {src/adm2/custom/dvispropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


