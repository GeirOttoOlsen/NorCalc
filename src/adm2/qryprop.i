&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : qryprop.i
    Purpose     : Starts query.p Super procedure and defines Basic Query Object
                  properties.
    Syntax      : {src/adm2/qryprop.i}

    Description :

    Modified    : January 3, 2000 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/querydefscustom.i}

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
         HEIGHT             = 7.48
         WIDTH              = 42.8.
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
  {src/adm2/qryprto.i}
&ENDIF

 /* Preprocessors to define properties that can be retrieved
    directly from the property temp-table. */

 &GLOB xpDataColumnsByTable                
 &GLOB xpKeyFields              
 &GLOB xpDataTarget             
 &GLOB xpDataTargetEvents
 &GLOB xpNavigationSource       
 &GLOB xpNavigationSourceEvents 
 &GLOB xpForeignFields          
 &GLOB xpBufferHandles          
 &GLOB xpFilterSource           
 &GLOB xpFilterWindow           
 &GLOB xpQueryHandle            
 &GLOB xpQueryRowIdent
 &GLOB xpOpenOnInit
 &GLOB xpForeignValues
 &GLOB xpCheckLastOnOpen
 &GLOB xpQueryString
 &GLOB xpQueryColumns
 &GLOB xpLastDBRowIdent
 &GLOB xpAssignList
 &GLOB xpUpdatableColumnsByTable                
  /* Include the property temp-table definition and then add query's
     properties to its fields. */
 &IF DEFINED(BrowserQueryObject) NE 0 &THEN
  /* If this is a browser with its own query, then include the browse 
     properties (and everything up the class tree) from here. */
  {src/adm2/brsprop.i}
 &ELSE
  {src/adm2/smrtprop.i}
 &ENDIF

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('DataColumnsByTable':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('KeyFields':U, 'CHAR':U, 0, ?, '{&KEY-FIELDS}':U).
  ghADMProps:ADD-NEW-FIELD('DataTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DataTargetEvents':U, 'CHAR':U, 0, ?, 'updateState,rowObjectState':U).
  ghADMProps:ADD-NEW-FIELD('NavigationSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('NavigationSourceEvents':U, 'CHAR':U, 0, ?, 
    'fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter':U).
  ghADMProps:ADD-NEW-FIELD('FilterWindow':U, 'CHAR':U).
  ghADMProps:ADD-NEW-FIELD('FilterSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('ForeignFields':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryPosition':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BufferHandles':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('OpenQuery':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryRowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('OpenOnInit':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('ForeignValues':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CheckLastOnOpen':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('QueryString':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryColumns':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LastDBRowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('AssignList':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdatableColumnsByTable':U, 'CHAR':U, 0, ?, '':U).
&ENDIF

  {src/adm2/custom/qrypropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


