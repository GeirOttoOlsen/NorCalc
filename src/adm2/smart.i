&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : smart.i - NEW V9 version of top-level SmartObject include

    Modified    : May 19, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .i file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  /* If smart.i has already been included, skip everything 
      (matching ENDIF is at the end of the file). */
&IF DEFINED(adm-smart) = 0 &THEN
  &GLOB adm-smart yes
  
  /* Define the preprocessor that identifies the basic "class" of the object;
     ADMClass will remain undefined here only if the object uses no sub-class
     include files. */
  &IF "{&ADMClass}":U = "":U &THEN
    &GLOB ADMClass smart
  &ENDIF

 DEFINE VARIABLE ghContainer    AS HANDLE NO-UNDO.  /* Window or Frame handle */

  /* If this object is of type "smart", i.e., uses no lower class include
     files, then include the property file here. Otherwise this will be
     done in the class include file of the base class of the object. */

&IF "{&ADMClass}":U = "smart":U &THEN
  {src/adm2/smrtprop.i}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */


  /* Now create the one record in this property temp-table, and store its
     handle in ADM-DATA. The CHR(1) delimiters are to set aside spots
     for UserProperties and UserLinks. */
  ghADMProps:TEMP-TABLE-PREPARE('ADMProps':U).
  ghADMPropsBuf = ghADMProps:DEFAULT-BUFFER-HANDLE.
  ghADMPropsBuf:BUFFER-CREATE().
  THIS-PROCEDURE:ADM-DATA = STRING(ghADMPropsBuf) + CHR(1) + CHR(1).
  
  RUN start-super-proc ("adm2/smart.p":U).

&IF "{&ADM-CONTAINER}":U NE "":U &THEN
  &IF "{&ADM-CONTAINER}":U = "WINDOW":U &THEN
    ghContainer    =   {&WINDOW-NAME}.
  &ELSEIF "{&ADM-CONTAINER}":U = "VIRTUAL":U OR "{&FRAME-NAME}":U = "":U &THEN
    ghContainer    = ?. /* Container has no vis. */
  &ELSEIF "{&ADM-CONTAINER}":U = "FRAME":U OR 
    "{&ADM-CONTAINER}":U = "DIALOG-BOX":U 
  &THEN
    ghContainer = FRAME {&FRAME-NAME}:HANDLE. 
  &ENDIF
&ELSE
  &IF "{&FRAME-NAME}":U NE "":U &THEN
      ghContainer = FRAME {&FRAME-NAME}:HANDLE.
  &ENDIF
&ENDIF

  {set ContainerHandle ghContainer}.

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/smartcustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-repositionObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionObject Method-Library 
PROCEDURE repositionObject :
/* -----------------------------------------------------------
  Purpose:     Moves an object to a specified position.
  Parameters:  ROW and COLUMN AS DECIMAL
-------------------------------------------------------------*/
  
    DEFINE INPUT PARAMETER pdRow    AS DECIMAL NO-UNDO.
    DEFINE INPUT PARAMETER pdCol    AS DECIMAL NO-UNDO.
    
    DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
    
    {get ContainerHandle hContainer}.

    IF VALID-HANDLE(hContainer) THEN
    DO:     
      /* If this is a Window or a Dialog box which is being positioned,
         then the special value 0 means to center the object in that
         dimension (0,0 means center on the screen - 0 can be used to
         signal this because 0 is an invalid row or column position). */
      &IF "{&ADM-CONTAINER}":U NE "":U &THEN
        DEFINE VARIABLE hParent AS HANDLE NO-UNDO.
        IF hContainer:TYPE = "WINDOW":U THEN
        DO:
          IF pdRow = 0 THEN pdRow = 
            (SESSION:HEIGHT-CHARS - hContainer:HEIGHT-CHARS) / 2.
          IF pdCol = 0 THEN pdCol = 
            (SESSION:WIDTH-CHARS - hContainer:WIDTH-CHARS) / 2.
        END.
        /* A Dialog naturally centers on its parent and positions relative
           to its parent, so we must adjust for that. */
        ELSE IF hContainer:TYPE = "DIALOG-BOX":U THEN
        DO:
          hParent = hContainer:PARENT.
          IF pdRow = 0 THEN pdRow = 
            ((SESSION:HEIGHT-CHARS - hContainer:HEIGHT-CHARS) / 2) -
              hParent:ROW.
          IF pdCol = 0 THEN pdCol = 
            ((SESSION:WIDTH-CHARS - hContainer:WIDTH-CHARS) / 2) -
              hParent:COL.
        END.
        /* If the row or column wound up being between 0 and 1 after the 
           calculation, change it, because otherwise Progress will complain. */
        IF pdRow GE 0 AND pdRow < 1 THEN pdRow = 1.
        IF pdCol GE 0 AND pdCol < 1 THEN pdCol = 1.
      &ENDIF
      /* Set object's position */
      ASSIGN hContainer:ROW    =   pdRow 
             hContainer:COLUMN =   pdCol.
    END.  
    RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-start-super-proc) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE start-super-proc Method-Library 
PROCEDURE start-super-proc :
/*------------------------------------------------------------------------------
  Purpose:     Procedure to start a super proc if it's not already running, 
               and to add it as a super proc in any case.
  Parameters:  Procedure name to make super.
  Notes:       NOTE: This presumes that we want only one copy of an ADM
               super procedure running per session, meaning that they are 
               stateless and "multi-threaded". This is intended to be the case
               for ours, but may not be true for all super procs.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProcName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE        hProc      AS HANDLE    NO-UNDO.

  hProc = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(hProc) AND hProc:FILE-NAME NE pcProcName:
    hProc = hProc:NEXT-SIBLING.
  END.
  IF NOT VALID-HANDLE(hProc) THEN
    RUN VALUE(pcProcName) PERSISTENT SET hProc.
  THIS-PROCEDURE:ADD-SUPER-PROCEDURE(hProc, SEARCH-TARGET).
  
  RETURN.
  
END PROCEDURE.

/* Note: This ENDIF matches the adm-smart definition at the top of file.
   Do not delete it and if another procedure or function is defined which
   occurs later in the file, move it to the end of that. */
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

