&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*-------------------------------------------------------------------------
    Library     : containr.i  
    Purpose     : Default V9 Main Block code and Method Procedures
                  for ADM Container procedures.
  
    Syntax      : {src/adm2/containr.i}

    Modified    : October 7, 1999 Version 9.1A 
-------------------------------------------------------------------------*/
/***********************  DEFINITIONS  ***********************************/


&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass containr
&ENDIF

/* If this is a SmartFrame with no Frame, then re-identify it as a 'virtual'
   -- i.e, non-visual -- container. */
&IF "{&ADM-CONTAINER}":U = "FRAME":U AND "{&FRAME-NAME}":U = "":U &THEN
  &SCOP ADM-CONTAINER VIRTUAL
&ENDIF

&IF "{&ADMClass}":U = "containr":U &THEN
  {src/adm2/cntnprop.i}
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
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

/* If this container has no visualization 
   -- is either defined to be 'virtual' or is a SmartFrame with no frame --
   then it is simply a container for non-visual objects; so skip visual.i,
   and reset the preprocessor which becomes the ContainerType property.
   This can be used simply by opening a SmartFrame and deleting the frame. */

&IF "{&ADM-CONTAINER}":U = "VIRTUAL":U &THEN
  {src/adm2/smart.i}
&ELSE
  {src/adm2/visual.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  RUN start-super-proc("adm2/containr.p":U).

/* Best default for GUI applications - this will apply to the whole session: */
PAUSE 0 BEFORE-HIDE.

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/containrcustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


