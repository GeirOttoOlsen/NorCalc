&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : viewer.p
    Purpose     : Super procedure for PDO SmartViewer objects

    Syntax      : adm2/viewer.p

    Modified    : September 29, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell viewattr.i that this is the Super procedure. */
   &SCOP ADMSuper viewer.p

  {src/adm2/custom/viewerexclcustom.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/viewprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-addRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE addRecord Procedure 
PROCEDURE addRecord :
/*------------------------------------------------------------------------------
  Purpose:     Gets initial values, enables fields, and allows entry of
               values for a new record.     
  Parameters:  <none>
  Notes:       addRow creates the RowObject temp-table record and returns the 
               initial values for the new row.
------------------------------------------------------------------------------*/
   
   DEFINE VARIABLE cColValues         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hUpdateTarget      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cTarget            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cFields            AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hSource            AS HANDLE    NO-UNDO.
   
      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
      
      /* Note: SUPER (datavis.p) verifies that UpdateTarget is present. */
      {get UpdateTarget cTarget}.
      hUpdateTarget = WIDGET-HANDLE(cTarget).
      /* If we're a GroupAssign-Target, then our Source has already done 
         the add; in that case just get the column values we want
         from our DataSource. Otherwise we invoke addRow in the UpdateTarget. */
               
      {get DisplayedFields cFields}.
      IF VALID-HANDLE(hUpdateTarget) THEN
         cColValues = dynamic-function ("addRow":U IN hUpdateTarget, cFields). 
      ELSE DO:
        {get GroupAssignSource hSource}. 
        IF hSource NE ? THEN
        DO:
          {get DataSource hSource}.
          cColValues = dynamic-function("colValues":U IN hSource, cFields) 
            NO-ERROR.
        END.  /* END DO hSource */
      END.    /* END ELSE DO */
      RUN displayFields IN TARGET-PROCEDURE(cColValues).
      
      PUBLISH 'addRecord' FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
      IF VALID-HANDLE(hUpdateTarget) THEN
          RUN applyEntry IN TARGET-PROCEDURE (?).
    RETURN.
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     Cancels the add, update or copy operation for the current row.
  Parameters:  <none>
  Notes:       cancelRecord in datavis.p (invoked by RUN SUPER) actually 
               cancels the update and for an add or copy, deletes the temp-table 
               record.  This version of cancelRecord gets a list of displayed 
               fields and re-displays their current values.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cFields       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cResult       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  RUN SUPER.
  IF RETURN-VALUE EQ "ADM-ERROR":U THEN RETURN "ADM-ERROR":U. 

  {get DataSource hDataSource}.
  {get DisplayedFields cFields}.
  RUN displayFields IN TARGET-PROCEDURE
    (dynamic-function ("colValues":U IN hDataSource, cFields)).  
  {get UpdateTarget cResult}.
  hUpdateTarget = WIDGET-HANDLE(cResult).
  IF VALID-HANDLE(hUpdateTarget) THEN
    RUN applyEntry IN TARGET-PROCEDURE (?).  
  {set NewRecord 'No':U}.
  PUBLISH 'cancelRecord':U FROM TARGET-PROCEDURE.   /* In case GroupAssign */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new RowObject with initial values equal to the
               current record, enables fields, and allows entry of
               values for a new record.
  Parameters:  <none>
  Notes:       When this is a Group-Assign target, the copy has already been
               done for the row so we do not need to invoke copyRow and run
               displayFields.  
------------------------------------------------------------------------------*/
   
   DEFINE VARIABLE cColValues    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cUpdateFn     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hSource       AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cTarget       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cFields       AS CHARACTER NO-UNDO.
   
     RUN SUPER.
     IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
     
     /* If we're a GroupAssign-Target, then our Source has already done 
        the copyRow to the UpdateTarget -- we don't do anything. */
     {get GroupAssignSource hSource}.
     IF hSource = ? THEN
     DO:
       {get UpdateTarget cTarget}.
       {get DisplayedFields cFields}.
       cColValues = dynamic-function ("copyRow":U IN 
           WIDGET-HANDLE(cTarget), cFields).  
     /* Even though the displayed values are already in the screen buffer,
        we run displayFields to get the new RowIdent value for the new row. */
       RUN displayFields IN TARGET-PROCEDURE(cColValues).
      
       PUBLISH 'copyRecord':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
     END.   /* END DO IF not GroupAssign */
     
     RUN applyEntry IN TARGET-PROCEDURE (?).
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields Procedure 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Disables fields in the ENABLED-FIELDS list (AppBuilder generated
               preprocessor).
  Parameters:  INPUT pcFieldType AS CHARACTER -- 'All' or 'Create'
  Notes:       At present at least, this takes an argument which may be
               "All" or "Create" to allow, e.g., cancelRecord to disable just
               ADM-CREATE-FIELDS.
               "Create" is currently not supported. 
               When a frame field is a SmartObject itself (for example, a 
               SmartField), disableField is run in the SmartObject to disable
               it.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFieldType AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cEnableFields AS CHARACTER NO-UNDO.  /* List of handles. */
  DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled      AS LOGICAL   NO-UNDO.
  
  {get FieldsEnabled lEnabled}.
  IF lEnabled THEN
  DO:  
      /* CreateFields not yet supported
       IF pcFieldType = "Create":U THEN     /* Disable just Create-only fields */
        {get CreateHandles cEnableFields}.
      ELSE 
      */
      IF pcFieldType = "All":U THEN
      DO:
        {get EnabledHandles cEnableFields}.
        /*
        {get CreateHandles cCreateFields}.
          IF cCreateFields NE "":U THEN
            cEnableFields = cEnableFields + ",":U + cCreateFields.
        */
      END.
      DO iField = 1 TO NUM-ENTRIES(cEnableFields):
         hField = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
         /* "Frame Field" May be a SmartObject procedure handle */
         IF hField:TYPE = "PROCEDURE":U THEN
           RUN disableField IN hField NO-ERROR.
         ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
         DO:
           IF hField:TYPE = "EDITOR":U THEN /* Editors must be sensitive, not R-O*/
             hField:READ-ONLY = yes.  
           ELSE hField:SENSITIVE = no.     
         END.  /* END DO NOT HIDDEN */
      END.     /* END DO iField     */
      
      {set fieldsEnabled no}.
  END.
  
  PUBLISH 'disableFields':U FROM TARGET-PROCEDURE 
      (pcFieldType). /* In case there's a GroupAssign */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     "Displays" the current row values by moving them to the frame's
               screen-values.
  Parameters:  INPUT pcColValues AS CHARACTER -- CHR(1) - delimited list of the
               BUFFER-VALUEs of the requested columns; the first entry in the
               list is the RowIdent code.
  Notes:       When a frame field is a SmartObject (for example, a
               SmartField), setDataValue is invoked in the SmartObject to set 
               its value.
------------------------------------------------------------------------------*/

 DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.
 
 DEFINE VARIABLE hFrameField   AS HANDLE    NO-UNDO.
 DEFINE VARIABLE iValue        AS INTEGER   NO-UNDO.
 DEFINE VARIABLE iColCount     AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cFieldHandles AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cValue        AS CHARACTER NO-UNDO.
 
  {get FieldHandles cFieldHandles}.
  iColCount = NUM-ENTRIES(cFieldHandles). 
  /* Save off the row number, which is always the first value returned. */
  cRowIdent = ENTRY(1, pcColValues, CHR(1)).
  {set RowIdent cRowIdent}.
  IF cFieldHandles NE "":U THEN
  DO iValue = 1 TO iColCount:
    cValue = TRIM(ENTRY(iValue + 1, pcColValues, CHR(1))).
    /* A "Frame Field" may be a SmartObject procedure handle. */
    hFrameField = WIDGET-HANDLE(ENTRY(iValue,cFieldHandles)).
    IF hFrameField:TYPE = "PROCEDURE":U THEN
    DO:
      {set DataValue cValue hFrameField}.
      {set DataModified no hFrameField}.
    END.
    ELSE DO:
      hFrameField:SCREEN-VALUE = 
        IF pcColValues NE ? THEN cValue
        ELSE IF hFrameField:DATA-TYPE NE "LOGICAL" THEN "":U ELSE "no".
      hFrameField:MODIFIED = no.       /* This will be checked by update code. */
    END.
  END.
  RUN displayObjects IN TARGET-PROCEDURE NO-ERROR.
  RETURN.
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableFields Procedure 
PROCEDURE enableFields :
/*------------------------------------------------------------------------------
  Purpose:     Enables fields in the ENABLED-FIELDS list (AppBuilder generated
               preprocessor.
  Parameters:  <none>
  Notes:       When the frame field is a SmartObject (for example, a 
               SmartField), enableField is run in the SmartObject.  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEnableFields AS CHARACTER NO-UNDO.  /* List of handles. */
  DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cState        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cNewRecord    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUpdateTarget AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hGASource     AS HANDLE    NO-UNDO.
  
  {get FieldsEnabled lEnabled}.
  {get RecordState cState}.
  {get NewRecord cNewRecord}.
  {get UpdateTarget cUpdateTarget}.
  {get GroupAssignSource hGASource}.
  
  /* Enable the fields only if not already enabled and if there's
     either a record available or we're adding a new record. 
     Also, don't enable fields if there's no Update-Target, unless
     we have a GroupAssign-Source, in which case *it's* got the
     Update-Target. */
  IF (NOT lEnabled) AND 
     (cState = "RecordAvailable":U OR cNewRecord NE "No":U) AND
      (cUpdateTarget NE "":U OR VALID-HANDLE(hGASource)) THEN
  DO:  
      {get EnabledHandles cEnableFields}.
      /* CreateFields not yet supported.
      IF cNewRecord NE "No":U THEN
        {get CreateHandles cCreateFields}. 
      IF cCreateFields NE "":U THEN
        cEnableFields = cEnableFields + ",":U + cCreateFields.
      */
      DO iField = 1 TO NUM-ENTRIES(cEnableFields):
         hField = WIDGET-HANDLE(ENTRY(iField, cEnableFields)).
         /* "Frame Field" May be a SmartObject procedure handle */
         IF hField:TYPE = "PROCEDURE":U THEN
           RUN enableField IN hField NO-ERROR.
         ELSE IF NOT hField:HIDDEN THEN /* Skip fields hidden for multi-layout */
         DO:
           hField:SENSITIVE = yes.
           IF hField:TYPE = "EDITOR":U THEN /* Ed's must be sensitive, not R-O*/
             hField:READ-ONLY = no.     
         END.
      END.
      
      /* If the list of enabled field handles isn't set, it may because this
         object hasn't been fully initialized yet. So don't set the enabled
         flag because we may be through here again. */
      IF cEnableFields NE "":U THEN
        {set FieldsEnabled yes}.
  END.
  
  PUBLISH 'enableFields':U FROM TARGET-PROCEDURE.  /* In case of GroupAssign */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Initialization code specific to SmartDataViewers. 
  Parameters:  <none>
  Notes:       Reads through list of enabled and displayed fields and
               gets their handles to store in FieldHandles and EnabledHandles
               properties.
------------------------------------------------------------------------------*/

 DEFINE VARIABLE hFrameField      AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cFieldHandles    AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cEnabledHandles  AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cEnabledFields   AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cDisplayedFields AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cCreateHandles   AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE hUpdateTarget    AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cTarget          AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hContainerHandle AS HANDLE    NO-UNDO.
 DEFINE VARIABLE lSaveSource      AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE iField           AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cFieldName       AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hFrameProc       AS HANDLE    NO-UNDO.
    
  RUN SUPER.            /* Invoke the standard behavior first. */
  IF RETURN-VALUE = "ADM-ERROR":U
    THEN RETURN "ADM-ERROR":U.      
  
  {get UpdateTarget cTarget}.
  hUpdateTarget = WIDGET-HANDLE(cTarget).
  
  /* Initialize the list of handles of the frame fields that are for
     database fields, for displayFields and update-record to use. 
     Also set a similar list of the field names for update-record to use. 
     Also a list of Enabled Field handles for enable/disableFields,
       and a list of any fields to be enabled for Create. */
  /*   Note: CreateFields not yet supported. 
  IF VALID-HANDLE(hUpdateTarget) THEN
    {get CreateFields cCreateFields hUpdateTarget}.  
  */ 
  {get ContainerHandle hContainerHandle}.
  {get EnabledFields cEnabledFields}.
  {get DisplayedFields cDisplayedFields}.
  ASSIGN hFrameField = hContainerHandle  
         hFrameField = hFrameField:FIRST-CHILD    /* Field Group */
         hFrameField = hFrameField:FIRST-CHILD.   /* First actual field. */
         
  /* A "Frame Field" may in fact be a SmartObject procedure handle. Check this
     and retrieve the object's FieldName property. */
     
  DO WHILE VALID-HANDLE(hFrameField):
    IF hFrameField:TYPE = "FRAME":U THEN
      /* get the procedure handle for the frame, which has been saved away. */
      ASSIGN hFrameProc = WIDGET-HANDLE(hFrameField:PRIVATE-DATA)
            cFieldName = dynamic-function('getFieldName' IN hFrameProc) NO-ERROR.
    ELSE
      ASSIGN hFrameProc = ?   /* Signal no SMo here */
             cFieldName = hFrameField:NAME.
    IF cFieldName NE ? AND
       LOOKUP(cFieldName, cDisplayedFields) NE 0 THEN
    DO:
      cFieldHandles = cFieldHandles + 
        (IF cFieldHandles NE "":U THEN "," ELSE "":U) + 
          (IF hFrameProc = ? THEN STRING(hFrameField) ELSE STRING(hFrameProc)).
      IF LOOKUP(cFieldName, cEnabledFields) NE 0 THEN
        cEnabledHandles = cEnabledHandles + 
          (IF cEnabledHandles NE "":U THEN ",":U ELSE "":U) + 
            (IF hFrameProc = ? THEN STRING(hFrameField) ELSE STRING(hFrameProc)).
    END.    /* END DO IF LOOKUP */
    hFrameField = hFrameField:NEXT-SIBLING.
  END.      /* END DO WHILE     */
  {set EnabledHandles cEnabledHandles}.
  {set CreateHandles cCreateHandles}.
  {set FieldHandles cFieldHandles}.
  
  RUN dataAvailable IN TARGET-PROCEDURE (?). /* See if there's a rec waiting. */

  /* If we have an UpdateTarget AND a Tableio-Source in Save mode 
     OR a GroupAssign-Source that is already enabled, then enable this object.*/
  {get SaveSource lSaveSource}.
  IF (VALID-HANDLE(hUpdateTarget) AND lSaveSource) OR
     dynamic-function('linkProperty':U IN TARGET-PROCEDURE,
       'GroupAssign-Source':U, 'FieldsEnabled':U) = 'Yes':U THEN   
    RUN enableFields IN TARGET-PROCEDURE.
  ELSE DO:
    /* If we're not enabling all fields, we must at least set editors to
       be Sensitive so they can be viewed and scrolled. */
    DO iField = 1 TO NUM-ENTRIES(cFieldHandles):
      hFrameField = WIDGET-HANDLE(ENTRY(iField, cFieldHandles)).
      IF hFrameField:TYPE = "EDITOR":U AND
         NOT hFrameField:HIDDEN THEN   /* Skip fields hidden for multi-layout */
           ASSIGN hFrameField:SENSITIVE = yes
                  hFrameField:READ-ONLY = yes.
    END.       /* END DO iField */
  END.         /* END ELSE DO IF not enableFields */
      
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     Receives state messages for updates
  Parameters:  pcState AS CHARACTER -- update state: can include 'UpdateBegin',
               'UpdateComplete'
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState  AS CHARACTER NO-UNDO.
  CASE pcState:
    WHEN 'UpdateBegin':U THEN 
    DO:
      RUN enableFields IN TARGET-PROCEDURE.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE 
        /* In case enable fails for some reason.*/
        (IF RETURN-VALUE = "ADM-ERROR":U THEN 'UpdateComplete':U
           ELSE 'Update':U).   /* Tell others (Data Object, Nav Panel) */
    END.
    WHEN 'UpdateComplete':U THEN
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE 
        ('UpdateComplete':U). /* Tell others... */
    OTHERWISE RUN SUPER(INPUT pcState).  /* Let datavis deal with it. */
  END CASE.
  
  RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

