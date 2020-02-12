&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : datavis.i
    Purpose     : Basic Data Visualization object methods for the ADM

    Syntax      : {src/adm2/datavis.i}

    Description :

    Modified    : May 19, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass datavis
&ENDIF

&IF "{&ADMClass}":U = "datavis":U &THEN
  {src/adm2/dvisprop.i}
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

/* If this object is also a SmartContainer, then we must include containr
   in the chain of basic includes. New for 9.1A */
&IF DEFINED(ADM-CONTAINER) NE 0 &THEN
  {src/adm2/containr.i}
&ELSE
  {src/adm2/visual.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  RUN start-super-proc("adm2/datavis.p":U).

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/dataviscustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-displayObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayObjects Method-Library 
PROCEDURE displayObjects :
/*------------------------------------------------------------------------------
  Purpose:     This procedure is run during initialization to display initial
               values for non-database-related fields, and is also run from
               displayFields in case those values change with each new record.
  Parameters:  <none>
  Notes:       This procedure is in the include file rather than the super 
               procedure because it is easiest to display the fields in the
               DISPLAYED-OBJECTS list from the object itself. 
------------------------------------------------------------------------------*/

  &IF "{&DISPLAYED-OBJECTS}":U NE "":U &THEN
    DISPLAY {&UNLESS-HIDDEN} {&DISPLAYED-OBJECTS} WITH FRAME {&FRAME-NAME}.
  &ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

