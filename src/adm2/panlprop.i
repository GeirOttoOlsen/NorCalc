&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : panlprop.i
    Purpose     : Starts panel.p Super procedure and defines Basic SmartPanel
                  properties.
    Syntax      : {src/adm2/panlprop.i}

    Description :

    Modified    : July 8, 1998
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/paneldefscustom.i}

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
EdgePixels,PanelType

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
     procedure's entry points. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/panlprto.i}
&ENDIF

 /* These preprocessors tell us at compile time what properties can be
    retrieved directly from the temp-table. */

 &GLOB xpPanelType
 &GLOB xpButtonCount
 &GLOB xpPanelFrame
 &GLOB xpMarginPixels
 &GLOB xpBoxRectangle
 &GLOB xpPanelLabel

&IF  ('{&ADM-Panel-Type}':U BEGINS 'Nav':U) 
OR   ('{&ADM-Panel-Type}' = 'Toolbar')     &THEN
/* Navigation-Panel-specific properties */
 &GLOB xpNavigationTarget
 &GLOB xpNavigationTargetEvents
 &GLOB xpRightToLeft
 &SCOP PanelDefined 
&ENDIF

&IF  ('{&ADM-Panel-Type}':U BEGINS 'Upd':U) 
OR   ('{&ADM-Panel-Type}':U BEGINS 'Sav':U) 
OR   ('{&ADM-Panel-Type}' = 'Toolbar')     &THEN

/* Update/Save panel-specific properties */
 &GLOB xpTableIOTarget
 &GLOB xpTableIOTargetEvents
 &GLOB xpAddFunction
 &GLOB xpUpdatingRecord
 &SCOP PanelDefined 
&ENDIF

&IF ('{&ADM-Panel-Type}':U BEGINS 'Commit':U) 
OR  ('{&ADM-Panel-Type}' = 'Toolbar') &THEN
/* Commit-Panel-specific properties */
 &GLOB xpCommitTarget       
 &GLOB xpCommitTargetEvents 
 &SCOP PanelDefined 
&ENDIF
    
  {src/adm2/visprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('PanelType':U, 'CHAR':U, 0, ?, '{&ADM-Panel-Type}':U).
  ghADMProps:ADD-NEW-FIELD('ButtonCount':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('PanelFrame':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('MarginPixels':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('BoxRectangle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('PanelLabel':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('PanelState':U, 'CHAR':U, 0, ?, '':U).          

    &IF ('{&ADM-Panel-Type}':U BEGINS 'Nav':U) 
    OR  ('{&ADM-Panel-Type}' = 'Toolbar') &THEN
  /* Navigation-Panel-specific properties */
  ghADMProps:ADD-NEW-FIELD('NavigationTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('NavigationTargetEvents':U, 'CHAR':U, 0, ?, 'queryPosition,updateState,linkState,filterState':U).
  ghADMProps:ADD-NEW-FIELD('RightToLeft':U, 'CHAR':U, 0, ?, '':U).
    &ENDIF

    &IF ('{&ADM-Panel-Type}':U BEGINS 'Upd':U) 
    OR  ('{&ADM-Panel-Type}':U BEGINS 'Sav':U) 
    OR  ('{&ADM-Panel-Type}' = 'Toolbar') &THEN
  /* Update/Save panel-specific properties */
  ghADMProps:ADD-NEW-FIELD('TableioTarget':U, 'CHAR':U, 0, ?, '':U).  
  ghADMProps:ADD-NEW-FIELD('TableioTargetEvents':U, 'CHAR':U, 0, ?, 'queryPosition,updateState,linkState':U).  
  ghADMProps:ADD-NEW-FIELD('AddFunction':U, 'CHAR':U, 0, ?, 'One-Record':U).
  ghADMProps:ADD-NEW-FIELD('UpdatingRecord':U, 'LOGICAL':U, 0, ?, FALSE).
    &ENDIF

    &IF ('{&ADM-Panel-Type}':U BEGINS 'Commit':U) 
     OR ('{&ADM-Panel-Type}' = 'Toolbar') &THEN
  ghADMProps:ADD-NEW-FIELD('CommitTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CommitTargetEvents':U, 'CHAR':U, 0, ?, 'rowObjectState':U).  
    &ENDIF

    &IF DEFINED(PanelDefined) = 0 AND '{&ADM-Panel-Type}':U NE '':U  &THEN
  /* If Panel-Type is anything else at all, look for p + type + prop.i,
     which should contain FIELD definitions *only*. */
  {src/adm2/p{&ADM-Panel-Type}prop.i}
     &ENDIF
&ENDIF

  {src/adm2/custom/panlpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


