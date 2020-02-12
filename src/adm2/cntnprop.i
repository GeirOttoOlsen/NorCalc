&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : cntnprop.i
    Purpose     : Starts containr.p super procedure and defines general
                  SmartContainer properties and other values.
    Syntax      : {src/adm2/cntnprop.i}

    Description :

    Modified    : October 7, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/containrdefscustom.i}

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
  {src/adm2/cntnprto.i}
&ENDIF

  /* Preprocs to identify to compiler which properties are in the temp-table.*/
  &GLOB xpCurrentPage
  &GLOB xpContainerTarget
  &GLOB xpContainerTargetEvents
  &GLOB xpPageNTarget
  &GLOB xpPageSource
  &GLOB xpFilterSource
  &GLOB xpDataTarget
  &GLOB xpUpdateSource
  &GLOB xpUpdateTarget
  &GLOB xpStartPage
  &GLOB xpRunMultiple

  /* Now include the next-level-up property include file. This builds up
     the property temp-table definition, which we will then add our 
     field definitions to. If this is a non-visual ('virtual') container,
     then skip the visual properties and just go for the smrt ones. */  
&IF "{&ADM-CONTAINER}":U = "VIRTUAL":U &THEN
    {src/adm2/smrtprop.i}
&ELSE
    {src/adm2/visprop.i}
&ENDIF

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('CurrentPage':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('ContainerTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerTargetEvents':U, 'CHAR':U, 0, ?,
    'exitObject':U).
  ghADMProps:ADD-NEW-FIELD('PageNTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('PageSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('FilterSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('DataTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdateSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('UpdateTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('StartPage':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RunMultiple':U, 'LOGICAL':U, 0, ?, NO).
&ENDIF

  {src/adm2/custom/cntnpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


