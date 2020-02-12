&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : browser.p
    Purpose     : Super procedure for PDO SmartBrowser objects

    Syntax      : adm2/browser.p

    Modified    : September 29, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell brsattr.i that this is the Super procedure. */
   &SCOP ADMSuper browser.p

  {src/adm2/custom/browserexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getActionEvent Procedure 
FUNCTION getActionEvent RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getApplyActionOnExit Procedure 
FUNCTION getApplyActionOnExit RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getApplyExitOnAction Procedure 
FUNCTION getApplyExitOnAction RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getBrowseHandle Procedure 
FUNCTION getBrowseHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCalcWidth Procedure 
FUNCTION getCalcWidth RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSignature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSignature Procedure 
FUNCTION getDataSignature RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMaxWidth Procedure 
FUNCTION getMaxWidth RETURNS DECIMAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumDown Procedure 
FUNCTION getNumDown RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSearchField Procedure 
FUNCTION getSearchField RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setActionEvent Procedure 
FUNCTION setActionEvent RETURNS LOGICAL
  ( pcEvent AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setApplyActionOnExit Procedure 
FUNCTION setApplyActionOnExit RETURNS LOGICAL
  ( plApply AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setApplyExitOnAction Procedure 
FUNCTION setApplyExitOnAction RETURNS LOGICAL
  ( plApply AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCalcWidth Procedure 
FUNCTION setCalcWidth RETURNS LOGICAL
  ( plCalcWidth AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( lModified AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setMaxWidth Procedure 
FUNCTION setMaxWidth RETURNS LOGICAL
  ( pdMaxWidth AS DECIMAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNumDown Procedure 
FUNCTION setNumDown RETURNS LOGICAL
  ( piNumDown AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSearchField Procedure 
FUNCTION setSearchField RETURNS LOGICAL
  ( pcField AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 14.76
         WIDTH              = 54.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/brsprop.i}

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
  Purpose:     SmartDataBrowser version of addRecord which inserts a new blank 
               row after the currently selected one if any.
  Parameters:  <none>
  Notes:       Initial values are not displayed here but from ROW-ENTRY trigger 
               (see brsentry.i).
------------------------------------------------------------------------------*/
   
   DEFINE VARIABLE hBrowse      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hFrame       AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hSearchField AS HANDLE    NO-UNDO.
      
      RUN SUPER.
      IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
      
      /* Open up a slot for the new row. */
      {get BrowseHandle hBrowse}.
      {get TableIOSource hSource}.
      {get SearchHandle hSearchField}.
      /* If the Browse was not enabled (perhaps because it was empty),
         enable it. */
      IF hBrowse:READ-ONLY THEN
      DO:
        {get ContainerHandle hFrame}.
        APPLY "ENTRY":U TO hFrame.
        hBrowse:READ-ONLY = no.
      END.
      ASSIGN
        hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField).
      hBrowse:INSERT-ROW("AFTER":U).
      {set BrowseInitted no}.    /* Signal for ROW-ENTRY trigger code */
      
    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyCellEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyCellEntry Procedure 
PROCEDURE applyCellEntry :
/*------------------------------------------------------------------------------
  Purpose:     Applies "ENTRY" to the first enabled column 
               in the browse (unless pcCellName is specified).
  Parameters:  pcCellName AS CHARACTER -- optional fieldname; if specified,
               the browse column of that name will be positioned to.
------------------------------------------------------------------------------*/

   DEFINE INPUT PARAMETER pcCellName   AS CHARACTER NO-UNDO.

   DEFINE VARIABLE hBrowse     AS HANDLE NO-UNDO. 
   DEFINE VARIABLE hCell       AS HANDLE NO-UNDO.

    {get BrowseHandle hBrowse}.
    ASSIGN hCell   = hBrowse:FIRST-COLUMN.
    
    DO WHILE VALID-HANDLE(hCell):
        IF NOT hCell:READ-ONLY AND (pcCellName = ? OR hCell:NAME = pcCellName) THEN DO:
            APPLY "ENTRY":U TO hCell.
            RETURN.
        END. 
        ASSIGN hCell = hCell:NEXT-COLUMN.
    END.

    RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEntry Procedure 
PROCEDURE applyEntry :
/*------------------------------------------------------------------------------
  Purpose:     Applies "ENTRY" to the first enabled column in the browse 
               (unless pcField is specified) if columns are enabled in the 
               browse, or in the first child of the SmartDataBrowser's frame.
  Parameters:  pcField AS CHARACTER -- optional fieldname; if specified,
               the column field of that name will be positioned to.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcField  AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cEnabledFields  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFieldsEnabled  AS LOGICAL    NO-UNDO.
 
  {get FieldsEnabled lFieldsEnabled}.
  {get EnabledFields cEnabledFields}.
  IF LOOKUP(pcField,cEnabledFields) NE 0 AND lFieldsEnabled THEN
    RUN applyCellEntry IN TARGET-PROCEDURE (pcField).
  ELSE RUN SUPER(pcField).  

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-calcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calcWidth Procedure 
PROCEDURE calcWidth :
/*------------------------------------------------------------------------------
  Purpose:     Calculates the exact width of the browse based on the columns in 
               the browse.
  Parameters:  <none>
  Notes:       Called from initializeObject for dynamic SmartDataBrowsers
------------------------------------------------------------------------------*/
DEFINE VARIABLE cColLabel     AS CHARACTER NO-UNDO.
DEFINE VARIABLE dMaxWidth     AS DECIMAL   NO-UNDO.
DEFINE VARIABLE dWidth        AS DECIMAL   NO-UNDO.
DEFINE VARIABLE hColumn       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hBrowse       AS HANDLE    NO-UNDO.
DEFINE VARIABLE iNumDown      AS INTEGER   NO-UNDO.
DEFINE VARIABLE lCalcWidth    AS LOGICAL   NO-UNDO.

  {get BrowseHandle hBrowse}.
  
  /* We need to make the browse visible in order to get the width for its columns */
  hBrowse:HIDDEN = FALSE.
  hColumn = hBrowse:FIRST-COLUMN.
  IF hBrowse:ROW-MARKERS THEN dWidth = 2.
  DO WHILE VALID-HANDLE(hColumn):
    dWidth     = dWidth + hColumn:WIDTH + 1.
    hColumn = hColumn:NEXT-COLUMN.
  END.  /* Do While */

  /* We must use the minimum of the calculated width or the Max Width property
     value */
  {get MaxWidth dMaxWidth}.
  dWidth = MIN(dWidth, dMaxWidth).

  RUN resizeObject IN TARGET-PROCEDURE (hBrowse:HEIGHT, dWidth + 3.5).
  ASSIGN hBrowse:WIDTH = dWidth NO-ERROR.
  RUN resizeObject IN TARGET-PROCEDURE (hBrowse:HEIGHT, dWidth + 3.5).
                                                                                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelRecord Procedure 
PROCEDURE cancelRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of cancelRecord which cancels the 
               add/copy of a new row or update of a current row.
               Depending on if the action comes after an add/copy 
               or an update, it deletes the newly added row (add/copy) 
               or redisplays the current record (update).
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cNew          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFields       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSelfQuery    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cResult       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.  
  ELSE DO:
    {get QueryObject lSelfQuery}.
    {get NewRecord cNew}.
    IF cNew NE 'No':U THEN        /* Could be Add or Copy or No */
    DO:
     {get BrowseHandle hBrowse}.
     IF hBrowse:NUM-SELECTED-ROWS = 1 THEN  /* Delete the cancelled new row. */
        hBrowse:DELETE-CURRENT-ROW().
    END.  /* END DO IF cNew */
    ELSE DO:
        IF NOT lSelfQuery THEN DO:
          {get DataSource hDataSource}.
          {get DisplayedFields cFields}.
          RUN displayFields IN TARGET-PROCEDURE
            (dynamic-function ("colValues":U IN hDataSource, cFields)).
          {get UpdateTarget cResult}.
          hUpdateTarget = WIDGET-HANDLE(cResult).
          IF VALID-HANDLE(hUpdateTarget) THEN
            RUN applyEntry IN TARGET-PROCEDURE (?).  
        END. /* IF NOT lSelfQuery ... */
        ELSE
          RUN displayFields IN TARGET-PROCEDURE (?).                
    END.
    {set NewRecord 'No':U}.    /* Note: this is character 'no', not logical*/
  END.    /* END IF NOT ADM-ERROR */
 
RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyRecord Procedure 
PROCEDURE copyRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of copyRecord which inserts a new 
               blank row after the currently selected one if any.
  Parameters:  <none>
  Notes:       Initial values are not displayed here but from ROW-ENTRY trigger 
               (see brsentry.i).
------------------------------------------------------------------------------*/
   
   DEFINE VARIABLE hBrowse      AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
   DEFINE VARIABLE hSearchField AS HANDLE  NO-UNDO.
   DEFINE VARIABLE lQueryObject AS LOGICAL NO-UNDO.

     /* Set the RowIdent before copyRow gets invoked because it needs to 
        copy the initial values out of the current record.  */ 
     {get QueryObject lQueryObject}.
     IF NOT lQueryObject THEN
     DO:
       {get BrowseHandle hBrowse}.
       hDataQuery = hBrowse:QUERY.
       hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
       {set RowIdent STRING(hRowObject:ROWID)}.
     END.
 
     RUN SUPER.
     IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U.
     
     /* Open up a slot for the new row. */
     {get BrowseHandle hBrowse}.
     {get SearchHandle hSearchField}.
      ASSIGN
        hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField).
     hBrowse:INSERT-ROW("AFTER":U).
     {set BrowseInitted no}.    /* Signal for ROW-ENTRY trigger code */
      
   RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-defaultAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE defaultAction Procedure 
PROCEDURE defaultAction :
/*------------------------------------------------------------------------------
  Purpose:  runs persistently from default action   
  Parameters:  <none>
  Notes:    The trigger is defined in setActionEvent. 
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cActionEvent AS CHAR NO-UNDO.
   DEFINE VARIABLE lExit        AS LOG    NO-UNDO.
   {get ActionEvent cActionEvent}. 
   
   IF cActionEvent <> "":U THEN
     PUBLISH cActionEvent FROM TARGET-PROCEDURE.

   /* Is the default action supposed to close the browse ? */
   {get ApplyExitOnAction lExit}.
 
   IF lExit THEN 
   DO:
     /* There's an opposite property that dictates that the exit is to 
        behave as defaultAction, (mainly to do the publish above)
        which is not needed in this case and also would create loop  */ 
     {set ApplyActionOnExit FALSE}.
     RUN exitObject IN TARGET-PROCEDURE.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteComplete) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteComplete Procedure 
PROCEDURE deleteComplete :
/*------------------------------------------------------------------------------
  Purpose:     Deletes the currently selected row from the Browse's viewport.
  Parameters:  <none>
  Notes:       If the SmartDataBrowser is updateable and has its own query it 
               will be invoked from deleteRecord which in this case does 
               nothing as the row has already been deleted.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse           AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hDataSource       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cForeignFields    AS CHARACTER  NO-UNDO.    
  DEFINE VARIABLE lSelfQuery        AS LOGICAL    NO-UNDO.  
  
  {get BrowseHandle hBrowse}.
  {get QueryObject lSelfQuery}.
  IF lSelfQuery THEN DO:
    {get DataSource hDataSource}.
    {get ForeignFields cForeignFields TARGET-PROCEDURE}.    
  END.
  IF lSelfQuery THEN
    IF cForeignFields NE "":U AND hDataSource = SOURCE-PROCEDURE THEN RETURN.   
  IF hBrowse:NUM-SELECTED-ROWS EQ 1 THEN 
    hBrowse:DELETE-CURRENT-ROW().
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteRecord Procedure 
PROCEDURE deleteRecord :
/*------------------------------------------------------------------------------
  Purpose:    SmartDataBrowser version of deleteRecord.  
  Parameters:  <none>
  Notes:      The record deletion is actually done up the chain. 
              Invokes deleteComplete when the SDBrowser has its own query.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE cErrors     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent   AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE hBrowse     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowIdent   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCnt        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lQueryObj   AS LOGICAL   NO-UNDO.
  
  {get BrowseHandle hBrowse}.
  IF hBrowse:NUM-SELECTED-ROWS NE 1 THEN
  DO:
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "1":U).  
     /* Must select a single row for deletion. */
     RETURN "ADM-ERROR":U.
  END.
  
  hBrowse:SELECT-FOCUSED-ROW().  /* In case it's not yet explicitly selected.*/
  hQuery = hBrowse:QUERY.  /* Whether DB or RowObject query */
  {get QueryObject lQueryObj}.
  IF lQueryObj THEN
  DO:
    /* For a database query, leave the first entry in RowIdent blank and
       set the rest of it to the database record ROWID(s). */
    DO iCnt = 1 TO hQuery:NUM-BUFFERS:
      ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
             cRowIdent = cRowIdent + ",":U +  STRING(hBuffer:ROWID).
    END.    /* END DO iCnt */
  END.      /* END DO QueryObject = Yes */
  ELSE DO:     /* QueryObject = No */
    ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(1)
           cRowIdent = STRING(hBuffer:ROWID).
    {get DataSource hDataSource}.
    {get QueryPosition cQueryPos hDataSource}.
  END.  /* Else Do - QueryObject = No */
  {set RowIdent cRowIdent}.
  
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN RETURN "ADM-ERROR":U. 
  IF lQueryObj THEN
    RUN deleteComplete IN TARGET-PROCEDURE.

  /* If we have just deleted the last record in the query then we need
     to set LastRowNum and LastDbRowIdent appropriately.  */
  IF cQueryPos = 'LastRecord':U AND NOT lQueryObj THEN DO:
    ASSIGN hRowNum   = hBuffer:BUFFER-FIELD('RowNum':U)
           hRowIdent = hBuffer:BUFFER-FIELD('RowIdent':U).
    {set LastRowNum hRowNum:BUFFER-VALUE hDataSource}.
    {set LastDbRowIdent hRowIdent:BUFFER-VALUE hDataSource}.
  END.  /* If LastRecord */

  /* If the number of entries in the browse is less than the number of
     rows that can be displayed in the browse then we have either 
     deleted the last record (in the query) or we have deleted the last 
     row of a batch.  If the db rowid for the row we are deleting is not 
     equal to the LastDbRowIdent then we want to run fetchNext because we 
     have deleted the last row in a batch and need to fetch more rows.  */
  IF hBrowse:NUM-ENTRIES < hBrowse:DOWN AND NOT lQueryObj THEN 
    IF cQueryPos NE "LastRecord":U THEN RUN fetchNext IN hDataSource.

  APPLY "ENTRY":U TO hBrowse.

  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of destroyObject which lets its
               Data source know that it is no longer being browsed.
  Parameters:  <none>
  Notes:       This is needed because only one browser may browse a
               SmartDataObject query at a time.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lQueryObject AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hDataSource  AS HANDLE   NO-UNDO.
  DEFINE VARIABLE lAction      AS LOG    NO-UNDO.
 
  {get QueryObject lQueryObject}.
  /* Do this only if the object does not have its own database query. */
  IF NOT lQueryObject THEN
  DO:
    {get DataSource hDataSource}.
    {set DataQueryBrowsed no hDataSource} NO-ERROR.
  END.

  /* Is the exit supposed to behave as a double-click or return?
    (publish the ActionEvent) */
  {get ApplyActionOnExit lAction}.
  IF lAction THEN 
  DO:
    /* There's an opposite property that dictates that defaultAction calls
       exit, which is not needed in this case and also would create loop  */ 
    {set ApplyExitOnAction FALSE}.
    RUN defaultAction IN TARGET-PROCEDURE.
  END. /* if lAction */
  RUN SUPER.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disableFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disableFields Procedure 
PROCEDURE disableFields :
/*------------------------------------------------------------------------------
  Purpose:     Makes the Browse control read-only.
  Parameters:  pcFields AS CHARACTER -- 'All' or 'Create'
  Notes:       'Create' is not supported yet.
               Move away focus from the Browse before turning off the
               READ-ONLY attribute.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcFields   AS CHARACTER NO-UNDO. 
  
  DEFINE VARIABLE hBrowse   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSelected AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hColumn   AS HANDLE    NO-UNDO.

  {get BrowseHandle hBrowse}.
  /* NOTE: No specific support yet for just disabling 'Create' fields. */
  IF VALID-HANDLE(hBrowse) AND pcFields = 'All':U THEN
  DO:
    {get EnabledFields cFields}.
    {get FieldsEnabled lEnabled}.
    IF cFields NE "":U AND lEnabled   /* There are enabled fields to disable */
    THEN DO:
      {get ContainerHandle hFrame}.
      
      /* Was a row selected? */
      lSelected = hBrowse:NUM-SELECTED-ROWS > 0. 
      APPLY "ENTRY":U TO hFrame.
      /* Setting each column to read-only avoids problems with the column 
         remaining visually enabled when this procedure is called without  
         row-leave/leave been fired (for example the toolbar which has no focus). */
      hBrowse:READ-ONLY = TRUE.      
      hColumn = hBrowse:FIRST-COLUMN.
      DO WHILE VALID-HANDLE(hColumn):
        IF CAN-DO(cFields,hColumn:NAME) THEN 
          hColumn:READ-ONLY = TRUE.
        hColumn = hColumn:NEXT-COLUMN.
      END.      
      IF lSelected THEN 
         hBrowse:SELECT-FOCUSED-ROW().
      {set FieldsEnabled no}.
    END.
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-displayFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayFields Procedure 
PROCEDURE displayFields :
/*------------------------------------------------------------------------------
  Purpose:     Displays the current row values by moving them to the browse's
               screen-values.
  Parameters:  pcColValues AS CHARACTER -- CHR(1) delimited list of 
               BUFFER-VALUES of the requested fields; the first value in the
               list is the RowIdent value.
------------------------------------------------------------------------------*/
 DEFINE INPUT PARAMETER pcColValues AS CHARACTER NO-UNDO.
 
 DEFINE VARIABLE hFrameField       AS HANDLE    NO-UNDO.
 DEFINE VARIABLE iValue            AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cRowIdent         AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iColCount         AS INTEGER   NO-UNDO.
 DEFINE VARIABLE cFieldHandles     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lSelfQuery        AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE hQuery             AS HANDLE       NO-UNDO.
 DEFINE VARIABLE hBuffer           AS HANDLE       NO-UNDO.
 DEFINE VARIABLE hField            AS HANDLE       NO-UNDO.  
 DEFINE VARIABLE cBufferHandles    AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE cBufferList       AS CHARACTER    NO-UNDO.
 DEFINE VARIABLE cNewRecord        AS CHARACTER    NO-UNDO.
  
 {get QueryObject lSelfQuery}.
 {get NewRecord cNewRecord}.
 
 IF NOT lSelfQuery OR (lSelfQuery AND cNewRecord NE 'no':U) THEN DO:
    iColCount = NUM-ENTRIES(pcColValues,CHR(1)).
    /* Save off the row ident string, which is always the first value returned. */
    cRowIdent = ENTRY(1, pcColValues, CHR(1)).
    {set RowIdent cRowIdent}.
    {get FieldHandles cFieldHandles}.
    IF cFieldHandles NE "":U THEN
    DO iValue = 2 TO iColCount:
        ASSIGN hFrameField = WIDGET-HANDLE(ENTRY(iValue - 1,cFieldHandles))
               hFrameField:SCREEN-VALUE = 
                 IF pcColValues NE ? THEN
                   TRIM(ENTRY(iValue, pcColValues, CHR(1)))
                 ELSE IF hFrameField:DATA-TYPE NE "LOGICAL":U THEN "":U
                 ELSE ?
               hFrameField:MODIFIED = no  /* Checked by update code. */
               NO-ERROR.
    END.
  END. /* IF NOT lSelfQuery ... */
  
  ELSE DO:
      {get QueryHandle hQuery}.
      IF NOT hQuery:IS-OPEN THEN RETURN.

      DO iValue = 1 TO hQuery:NUM-BUFFERS:
        ASSIGN 
            hBuffer        = hQuery:GET-BUFFER-HANDLE(iValue)
            cBufferHandles = cBufferHandles + ",":U + STRING(hBuffer)
            cBufferList    = cBufferList + ",":U + hBuffer:NAME
            .
      END.   
      ASSIGN 
          cBufferHandles = LEFT-TRIM(cBufferHandles,",":U)      
          cBufferList    = LEFT-TRIM(cBufferList,",":U)
          .
      
      hQuery:GET-CURRENT().
      hBuffer =  hQuery:GET-BUFFER-HANDLE(1).
      IF hBuffer:AVAILABLE THEN DO:
          {get FieldHandles cFieldHandles}.
          IF cFieldHandles NE "":U THEN
          DO iValue = 1 TO NUM-ENTRIES(cFieldHandles):
            ASSIGN hFrameField = WIDGET-HANDLE(ENTRY(iValue,cFieldHandles)).
            IF hFrameField:TABLE NE ? THEN
                ASSIGN
                   hBuffer = WIDGET-HANDLE(ENTRY(LOOKUP(hFrameField:TABLE,cBufferList),cBufferHandles))
                   hField  = hBuffer:BUFFER-FIELD(hFrameField:NAME)
                   hFrameField:SCREEN-VALUE = IF hField:BUFFER-VALUE NE ? THEN hField:BUFFER-VALUE
                                        ELSE IF hField:DATA-TYPE NE "LOGICAL":U THEN "":U
                                        ELSE ?
                   hFrameField:MODIFIED = no
               .
          END. /* DO iValue = 1 TO ... */  
      END. /* IF hBuffer:AVAILABLE ... */    
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
  Purpose:     Makes the Browse control updatable.
  Parameters:  <none>
  Notes:       The Browse is made updateable only if some field are enabled
               and the SmartDataBrowser is link to an Update target.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lSelected AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hBrowse   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lEnabled  AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTarget   AS CHARACTER NO-UNDO.
  
  {get BrowseHandle hBrowse}.
  IF VALID-HANDLE(hBrowse) THEN
  DO:
    {get EnabledFields cFields}.
    {get FieldsEnabled lEnabled}.
    {get RecordState cState}.
    {get UpdateTarget cTarget}.
    
    IF cFields NE "":U AND (NOT lEnabled) /* There are fields to enable */
         AND cTarget NE "":U              /* and an Update-Target */
    THEN DO:
      lSelected = hBrowse:NUM-SELECTED-ROWS = 1.  /* Was a row selected? */
      {get ContainerHandle hFrame}.
      
      APPLY "ENTRY":U TO hFrame.
      
      /* Turn off read-only for each column 
         See comments in disable fields why read-only is true */
      hColumn = hBrowse:FIRST-COLUMN.
      DO WHILE VALID-HANDLE(hColumn):
        IF CAN-DO(cFields,hColumn:NAME) THEN 
           hColumn:READ-ONLY = FALSE.
        hColumn = hColumn:NEXT-COLUMN.
      END.
      hBrowse:READ-ONLY = no.
      IF lSelected THEN hBrowse:SELECT-FOCUSED-ROW().
      {set FieldsEnabled yes}.
    END.
    
    IF cState = 'NoRecordAvailable':U THEN DO:
      {get ContainerHandle hFrame}.
      APPLY "ENTRY":U TO hFrame.
    END.  /* if no record available */    
  END.
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDataSet) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDataSet Procedure 
PROCEDURE fetchDataSet :
/*------------------------------------------------------------------------------
  Purpose:     Changes/Resets Browse's states depending on action which occurs.
  Parameters:  pcState AS CHARACTER 
               Possible values are: 'BatchStart', 'BatchEnd', 'NextStart'
               'NextEnd', 'PrevStart', 'PrevEnd'.
  Notes:       Used internally.
------------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER pcState      AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE hBrowse             AS HANDLE NO-UNDO.    

  {get BrowseHandle hBrowse}.
  CASE pcState :
    WHEN 'BatchStart':U OR WHEN 'LastStart':U THEN
      ASSIGN hBrowse:REFRESHABLE = no.
    WHEN 'BatchEnd':U OR WHEN 'LastEnd':U THEN
      ASSIGN hBrowse:REFRESHABLE = yes.
    WHEN 'PrevStart':U THEN
      hBrowse:SET-REPOSITIONED-ROW(1,"ALWAYS":U).
    WHEN 'NextStart':U THEN
      hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN - 1,"ALWAYS":U).    
    WHEN 'NextEnd':U OR WHEN 'PrevEnd':U THEN
      hBrowse:SET-REPOSITIONED-ROW(hBrowse:DOWN,"CONDITIONAL":U).
  END CASE.  
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of initializeObject which executes 
               code mainly to set properties values.
  Parameters:  <none>
  Notes:       May create a dynamic 'Search' FILL-IN if the SearchField
               property is set.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataSource      AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBrowse          AS HANDLE NO-UNDO.
  DEFINE VARIABLE hFrameField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cFieldHandles    AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cEnabledHandles  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cEnabledFields   AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cCreateHandles   AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cRowIdent        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSaveSource      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lQueryObject     AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cTarget          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryBrowsed    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cFields          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hTableio         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iField           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField           AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lResult          AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hField           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFrame           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSearchField     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cSearchLabel     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSearchLabel     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSearchField     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssigns         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iEntry           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSortField       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lDynamic         AS LOGICAL   NO-UNDO INIT no.
  DEFINE VARIABLE lHideOnInit      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cValidation      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE lCalcWidth       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iNumDown         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColumn          AS CHARACTER NO-UNDO.
  
  {get UIBMode cUIBMode}.

  /* First determine whether this is a "dynamic" browser (actually an
     empty static browser to be filled in at runtime). */
  {get DataSource hDataSource}.   /* Proc. handle of our SDO. */
  {get BrowseHandle hBrowse}.     /* Handle of the browse widget. */
  IF hBrowse:NUM-COLUMNS = 0 THEN
  DO:
    lDynamic = yes.            /* Signal to code below. */
    /* Get Displayed and Enabled fields at runtime. */
    IF NOT VALID-HANDLE(hDataSource) THEN
      RETURN ERROR.                 /* Can't do anything without it. */
 
    {get DataHandle hDataQuery hDataSource}.  /* Handle of the SDO's query. */
    hBrowse:QUERY = hDataQuery.               /* Attach this to the Browse. */
    hDataBuffer = hDataQuery:GET-BUFFER-HANDLE(1).  /* SDO Buffer handle.   */
      
    {get EnabledFields cEnabledFields}.
    {get DisplayedFields cFields}.

    /* If DisplayedFields is blank, this means take all fields from the SDO.
       If EnabledFields is blank, this means take all updatable fields
       from the SDO, IF there is a Tableio-Source. */
    IF cFields = "":U THEN
    DO:
      {get DataColumns cFields hDataSource}.
      {set DisplayedFields cFields}.         /* Set the property. */
    END.    /* END DO IF cFields "" */

    DO iField = 1 TO NUM-ENTRIES(cFields):
      /* Add the requested columns to the browse. */
      hField = hDataBuffer:BUFFER-FIELD(ENTRY(iField, cFields)).
      IF hField:VALIDATE-EXPRESSION NE ? THEN DO: 
          cValidation = hField:VALIDATE-EXPRESSION.
          hField:VALIDATE-EXPRESSION = "":U.
          hBrowse:ADD-LIKE-COLUMN(hField).
          hField:VALIDATE-EXPRESSION = cValidation.
      END.  /* if vaildate-expression ne ? */
      ELSE hBrowse:ADD-LIKE-COLUMN(hField).
    END.  /* END DO iField */
         
    IF cEnabledFields = "":U THEN
    DO:
      {get TableIOSource hTableIO}.
      IF VALID-HANDLE(hTableIO) THEN
      DO:
        {get UpdatableColumns cEnabledFields hDataSource}.
        /* If the Display list was specified, but the Enabled list wasn't,
           make sure we remove any fields from the Enable list which
           weren't in the Display list. */
        DO iField = 1 TO NUM-ENTRIES(cEnabledFields):
          cField = ENTRY(iField, cEnabledFields).
          IF LOOKUP(cField, cFields) = 0 THEN
            ASSIGN cEnabledFields = REPLACE(',':U + cEnabledFields + ',':U, 
                     ',':U + cField + ',':U, ',':U)
                   cEnabledFields = 
                     SUBSTR(cEnabledFields, 2, LENGTH(cEnabledFields) - 2,
                     "CHARACTER":U).
        END. /* END DO iField */
        {set EnabledFields cEnabledFields}.
      END.   /* END DO IF TableIOSource */
    END.     /* END DO IF cEnabledFields "" */
         
    /* If there are any enabled fields, set the enabled prop to yes,
       because they will be explitly disabled by initializeObject if needed. */
    IF cEnabledFields NE "":U THEN
    DO:
      /* Now enable the appropriate columns. 
         The Browse must be made updatable first. */
      hBrowse:READ-ONLY = no.    
      hField = hBrowse:FIRST-COLUMN.
      DO WHILE VALID-HANDLE(hField):
        IF LOOKUP(hField:NAME,cEnabledFields) NE 0 THEN
          hField:READ-ONLY = no.
        hField = hField:NEXT-COLUMN.
      END. /* END DO WHILE hField */
      {set FieldsEnabled yes}.
    END. /* END DO IF cEnabledFields */   
  END.   /* END DO IF NUM-COLUMNS = 0 -- "dynamic" browser */

  /* We need to set expandable to TRUE here when CalcWidth is TRUE before
     the browse is viewed so that calcWidth can calculate column widths
     correctly. */
  {get CalcWidth lCalcWidth}.
  IF NOT (cUIBMode BEGINS "Design":U) AND lCalcWidth THEN hBrowse:EXPANDABLE = FALSE.

  {get QueryObject lQueryObject}.
  /* We need to set CheckLastOnOpen to TRUE so that LastDBRowIdent is set
     when the query is opened, we can then check the value of LastDBRowIdent
     in fetchNext to determine if we have just moved to the last row in 
     the query, if we have then QueryPosition can be set properly */
  IF lQueryObject THEN
    {set CheckLastOnOpen TRUE}. 

  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN
    RETURN "ADM-ERROR":U.
  
  /* If this object or its parent is in design mode, then we don't need to
     open the query or do any of the rest of this initialization code. */
  
  IF cUIBMode BEGINS "Design":U
    THEN RETURN.
  
  /* If we have no TableIO-Source, or if it's an Update panel in "Update" mode,
     or if there's no Update-Target, then the Browse should be disabled. */
  {get SaveSource lSaveSource}.
  {get UpdateTarget cTarget}.
  IF (NOT lSaveSource) OR (cTarget = "":U) THEN
    RUN disableFields IN TARGET-PROCEDURE('All':U).
    
  {get DataSource hDataSource}.
  {get BrowseHandle hBrowse}.
  {get QueryObject lQueryObject}.
  hBrowse:CREATE-ON-ADD = TRUE.
  hBrowse:SET-REPOSITIONED-ROW (INT(hBrowse:DOWN / 2),"CONDITIONAL":U).
  
  IF lQueryObject THEN
  DO:
    {get ForeignFields cFields}.
    /* This browser is browsing its own db query. If there's no other DataSource
       dependency and we're not in design mode, open that query. */
    IF (NOT VALID-HANDLE(hDataSource) AND (NOT cUIBMode BEGINS "Design":U))
        OR cFields = "":U
      THEN {fn openQuery}.
    /* Otherwise if there's a DataSource, find out if there's a row waiting
       for us; if there is, dataAvailable will open our dependent query. */
    ELSE IF VALID-HANDLE(hDataSource) THEN
      RUN dataAvailable In TARGET-PROCEDURE ("DIFFERENT":U).
    hDataQuery = hBrowse:QUERY.
    IF hDataQuery:NUM-RESULTS > 0 THEN
      {set RecordState 'RecordAvailable':U}.
  END.   /* END Do for QueryObject */ 
  ELSE IF VALID-HANDLE(hDataSource) THEN
  DO:
    /* Reassign the Browse to use the Data Object's query. */
    {get DataHandle hdataQuery hDataSource} NO-ERROR.  /* NO-ERROR for design*/
    IF VALID-HANDLE(hDataQuery) THEN
    DO:
      {get DataQueryBrowsed lQueryBrowsed hDataSource}.
      IF lQueryBrowsed THEN
      DO:
        DYNAMIC-FUNCTION("showMessage":u IN TARGET-PROCEDURE,
          "SDO query cannot be browsed by more than one SmartDataBrowser.":U).
        RETURN "ADM-ERROR":U.
      END.

      /* Else go ahead and attach the query and set the source's property.*/
      IF NOT lDynamic THEN       /* If dynamic, this has been done above. */
        hBrowse:QUERY = hDataQuery.
      {set DataQueryBrowsed yes hDataSource}. 
      
      RUN 'dataAvailable':U IN TARGET-PROCEDURE ('DIFFERENT':U).
    END.     /* END DO IF VALID-HANDLE */
  END.       /* END DO for non-QueryObject */
  
  /* Initialize the list of handles of the browse fields, 
     for displayFields and updateRecord to use. 
     Also set a similar list of the field names for updateRecord to use. 
     Also a list of Enabled Field handles for enable/disableFields,
       and a list of any fields to be enabled for Create. */
  IF VALID-HANDLE(hBrowse) THEN
  DO:           /* SKip all this at design time or when there's no query yet. */
    {get EnabledFields cEnabledFields}.
    ASSIGN hFrameField = hBrowse:FIRST-COLUMN.
         
    DO WHILE VALID-HANDLE(hFrameField):
      cFieldHandles = cFieldHandles + 
        (IF cFieldHandles NE "":U THEN "," ELSE "":U) + STRING(hFrameField).
      IF LOOKUP(hFrameField:NAME, cEnabledFields) NE 0 THEN
        cEnabledHandles = cEnabledHandles + 
          (IF cEnabledHandles NE "":U THEN ",":U ELSE "":U) 
            + STRING(hFrameField).
      hFrameField = hFrameField:NEXT-COLUMN.
    END.
    {set EnabledHandles cEnabledHandles}.
    {set CreateHandles cCreateHandles}.
    {set FieldHandles cFieldHandles}.
    
    /* If there is a SearchField, then allocate the first line of the frame
       to it and define the label and fill-in for it. */   
    {get SearchField cSearchField}.
    IF cSearchField NE "":U AND cSearchField NE ? THEN
    DO:
      {get ContainerHandle hFrame}.    /* Frame handle to put the widgets in. */
      /* NOTE: This resorts the query by the SearchField. */
      cColumn = {fnarg columnDbColumn cSearchField hDataSource}.
      cSortField = ENTRY(NUM-ENTRIES(cColumn, ".":U), cColumn, ".":U).
      {set QuerySort cSortField hDataSource}.
      {fn openQuery hDataSource}.
      
      ASSIGN hBrowse:HEIGHT = hBrowse:HEIGHT - 1  /* Shorten the browse */
             hBrowse:ROW = 2                     /* and place at row 2 */ 
             cSearchLabel = {fnarg columnLabel cSearchfield hDataSource}
                            + ": ":U.          
      CREATE TEXT hSearchLabel            /* Label for the field */ 
        ASSIGN 
         SCREEN-VALUE = cSearchLabel
         FORMAT = "X(":U + STRING(LENGTH(cSearchLabel)) + ")":U
         ROW     = 1
         WIDTH   = FONT-TABLE:GET-TEXT-WIDTH(cSearchLabel)
         HEIGHT  = 1
         COL     = 2
         FRAME   = hFrame
         SCREEN-VALUE = cSearchLabel
         HIDDEN       = FALSE.

      CREATE FILL-IN hSearchField
        ASSIGN DATA-TYPE = dynamic-function('columnDataType':U IN hDataSource, 
          cSearchField)
         FORMAT = dynamic-function('columnFormat':U IN hDataSource, 
                                    cSearchField)
         ROW = 1 
         COL = hSearchLabel:COL + hSearchLabel:WIDTH 
         FRAME = hFrame
         VISIBLE = yes 
         SENSITIVE = yes
         SIDE-LABEL-HANDLE = hSearchLabel
         TRIGGERS: 
           ON ANY-PRINTABLE
           PERSISTENT RUN searchTrigger IN TARGET-PROCEDURE. 
         END TRIGGERS.
      {set SearchHandle hSearchField}.
      /* When there is a SearchField, opening the query visualizes the 
         browse due to code in DataAvailable (browse.i) that applies "home"
         to the browse.  If HideOnInit is true, we need to hide the object */
      {get HideOnInit lHideOnInit}.
      IF lHideOnInit THEN RUN hideObject IN TARGET-PROCEDURE.
    END.      /* END IF SearchField */
     
    IF lCalcWidth THEN RUN calcWidth IN TARGET-PROCEDURE.
    {get NumDown iNumDown}.
     IF iNumDown > 0 THEN RUN setDown IN TARGET-PROCEDURE (INPUT iNumDown).

    /* If this browse is dynamic we need to select the first row because it 
       isn't done automatically and the first row needs to be selected when
       working with navigation panels.  We need the NO-ERROR in case the
       SDO is initialized after the browser to avoid errors about not being
       able to select-row when there are no rows in the browser.  */
    IF lDynamic THEN hBrowse:SELECT-ROW(1) NO-ERROR.

  END.        /* END IF VALID-HANDLE(hBrowse) */
  
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resetRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resetRecord Procedure 
PROCEDURE resetRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of resetRecord.
               Redisplays the original field values retrieved from the 
               Data Object or directly from the query associated with
               the SmartDataBrowser.
  Parameters:  <none>
  Notes:       Invoked when the Reset button is pressed on an Update SmartPanel.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lSelfQuery AS LOGICAL NO-UNDO.

  {get QueryObject lSelfQuery}.
  IF NOT lSelfQuery THEN
    RUN SUPER.
  ELSE DO:  
      RUN displayFields IN TARGET-PROCEDURE (?).
      {set DataModified ?}.
      PUBLISH 'resetRecord':U FROM TARGET-PROCEDURE.  /* In case GroupAssign */
      RUN applyEntry IN TARGET-PROCEDURE (?).
  END.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeBrowse Procedure 
PROCEDURE resizeBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Changes the size of the browse widget in a SmartDataBrowser   
  Parameters:  pd_height AS DECIMAL -- The desired height (in rows)
               pd_width  AS DECIMAL -- The desired width (in columns)     
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE hBrowse     AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFieldGroup AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFrame      AS HANDLE           NO-UNDO.
  DEFINE VARIABLE htmpWidget  AS HANDLE           NO-UNDO.
  DEFINE VARIABLE otherWidget AS LOGICAL          NO-UNDO.

  /* Assure that it doesn't get too small */
  ASSIGN pd_height = MAX(pd_height, 2.0)
         pd_width  = MAX(pd_width, 2.0).
  /* Get the handles of the browse and its frame */
  {get BrowseHandle hBrowse}.
  ASSIGN hFieldGroup = hBrowse:PARENT           /* Field Group */
         hFrame      = hFieldGroup:PARENT.       /* The frame ! */
  
  IF pd_width + hBROWSE:COLUMN <= hFrame:WIDTH THEN
    hBrowse:WIDTH = pd_width. 
  IF pd_height + hBrowse:ROW <= hFrame:HEIGHT THEN 
    hBrowse:HEIGHT = pd_height. 
           
  hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-resizeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE resizeObject Procedure 
PROCEDURE resizeObject :
/*------------------------------------------------------------------------------
  Purpose:     Changes the size of a SmartDataBrowser.
  Parameters:  pd_height AS DECIMAL -- The desired height (in rows)
               pd_width  AS DECIMAL -- The desired width (in columns)
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pd_height AS DECIMAL NO-UNDO.
  DEFINE INPUT PARAMETER pd_width  AS DECIMAL NO-UNDO.
  
  DEFINE VARIABLE dSearchSize  AS DECIMAL          NO-UNDO.
  DEFINE VARIABLE hBrowse      AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFieldGroup  AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hFrame       AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hSearchField AS HANDLE           NO-UNDO.
  DEFINE VARIABLE hSearchLabel AS HANDLE           NO-UNDO.
  DEFINE VARIABLE htmpWidget   AS HANDLE           NO-UNDO.
  DEFINE VARIABLE otherWidget  AS LOGICAL          NO-UNDO.

  /* Assure that it doesn't get too small */
  ASSIGN pd_height = MAX(pd_height, 2.0)
         pd_width  = MAX(pd_width, 2.0).
  /* Get the handles of the browse and its frame */
  {get BrowseHandle hBrowse}.
  ASSIGN hFieldGroup = hBrowse:PARENT           /* Field Group */
         hFrame      = hFieldGroup:PARENT       /* The frame ! */
         htmpWidget  = hFieldGroup:FIRST-CHILD. /* 1st Child   */

  /* If the frame is NOT size-to-fit then we don't allow anything to
     be resized.  We can tell if size-to-fit has been turned off
     because SCROLLABLE is turned on.                                    */
  IF hFrame:SCROLLABLE THEN RETURN.

  /* We need to get the handles of the SearchField and its label.  We do this 
     so that the browse is resized even though we have a SearchField.  And we
     do this so that the mininum width of the frame takes the SearchField into 
     account.  */
  {get SearchHandle hSearchField}.
  IF VALID-HANDLE(hSearchField) THEN
    ASSIGN hSearchLabel = hSearchField:SIDE-LABEL-HANDLE
           dSearchSize  = hSearchField:COLUMN + hSearchField:WIDTH.

  /* While we will resize the frame, we won't change the size of the
     browse if there are other widgets in the frame (except for the affordance
     button and a SearchField).  So we have to determine if there are any widgets 
     other than the browse in the frame.                                                */
  Search-For-Siblings:
  REPEAT WHILE VALID-HANDLE(htmpWidget):
    IF htmpWidget NE hBrowse THEN DO:
      IF htmpWidget:TYPE NE "BUTTON":U OR
         htmpWidget:X    NE 4          OR
         htmpWidget:Y    NE 4          OR
         htmpWidget:TOOLTIP NE "SmartObject Options" THEN DO: 
        IF htmpWidget NE hSearchLabel AND
           htmpWidget NE hSearchField THEN DO:
            otherWidget = TRUE.
            LEAVE Search-For-Siblings.
        END.  /* If SearchField */
      END.  /* If not affordance button */
    END.
    htmpWidget = htmpWidget:NEXT-SIBLING.
  END. /* While looking for siblings */
  
  /* If the width is getting smaller, do the browse first else the frame */
  IF pd_width < hBrowse:WIDTH THEN
    ASSIGN hBrowse:WIDTH = pd_width - (hBrowse:COLUMN - 1) WHEN NOT otherWidget
           hFrame:WIDTH  = MAX(pd_width,dSearchSize)       NO-ERROR.
  ELSE
    ASSIGN hFrame:WIDTH  = MAX(pd_width,dSearchSize)
           hBrowse:WIDTH = pd_width - (hBrowse:COLUMN - 1) WHEN NOT otherWidget
                                                           NO-ERROR.
           
  /* If the height is getting smaller, do the browse first else the frame */
  IF pd_height < hBrowse:HEIGHT THEN
    ASSIGN hBrowse:HEIGHT = pd_height - (hBrowse:ROW - 1) WHEN NOT otherWidget
           hFrame:HEIGHT  = pd_height                     NO-ERROR.
  ELSE
    ASSIGN hFrame:HEIGHT  = pd_height
           hBrowse:HEIGHT = pd_height - (hBrowse:ROW - 1) WHEN NOT otherWidget
                                                          NO-ERROR.
           
  hBrowse:SET-REPOSITIONED-ROW (hBrowse:DOWN,"CONDITIONAL":U).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-searchTrigger) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE searchTrigger Procedure 
PROCEDURE searchTrigger :
/*------------------------------------------------------------------------------
  Purpose:     This is the procedure run from the trigger on the SearchField
               for the SmartDataBrowser, if one has been defined. It repositions 
               the query to the first row GE the value requested 
               (SearchValue property).
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cSearchField AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent    AS CHARACTER NO-UNDO.
  
  /* First we must capture the keystroke which fired the trigger. */
  APPLY LAST-KEY.
  
  {get DataSource hSource}.
  {get SearchField cSearchField}.
  cDataType = dynamic-function('columnDataType':U IN hSource, cSearchField).
  cRowIdent = dynamic-function('rowidWhere':U In hSource,
    cSearchField + ' >= ':U + 
      (IF cDataType BEGINS "CHAR":U OR cDataType = "DATE":U THEN "'":U ELSE "":U)
      + SELF:SCREEN-VALUE + 
      (IF cDataType BEGINS "CHAR":U OR cDataType = "DATE":U THEN "'":U ELSE "":U)).
  IF cRowIdent NE ? THEN
    dynamic-function('fetchRowIdent' IN hSource, cRowIdent, '':U).
  
  /* Now we must throw away the krystroke event to avoid getting double
     characters in the fill-in. */
  RETURN NO-APPLY.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setDown Procedure 
PROCEDURE setDown :
/*------------------------------------------------------------------------------
  Purpose:     Sets the down attribute for the browse and resizes the browse 
               appropriately.
  Parameters:  piNumDown AS INTEGER
  Notes:       Called from initializeObject for dynamic SmartDataBrowsers.
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER piNumDown AS INTEGER NO-UNDO.

DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.

  {get BrowseHandle hBrowse}.
  hBrowse:VISIBLE = TRUE.

  
  RUN resizeObject IN TARGET-PROCEDURE ((piNumDown * (hBrowse:ROW-HEIGHT + 0.2)) + 2,
                                        hBrowse:WIDTH).
  /* There is a core bug where if down is already set to the number we are trying to 
     set it to then setting down doesn't have any affect on height - which is what
     we need to have adjusted to get rid of any extra space at the bottom.  So when 
     down is equal to what we are about to set it to then we need to set it twice for
     it to have the correct affect. */
  IF hBrowse:DOWN = piNumDown THEN hBrowse:DOWN = piNumDown - 1 NO-ERROR.
  hBrowse:DOWN = piNumDown NO-ERROR.
  RUN resizeObject IN TARGET-PROCEDURE (hBrowse:ROW - 1 + hBrowse:HEIGHT, hBrowse:WIDTH).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateRecord) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateRecord Procedure 
PROCEDURE updateRecord :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of updateRecord.
               If the SmartDataBrowser is browsing a DataObject query and not 
               its own, this sets the RowIdent property to the RowObject 
               ROWID, because the DataObject will be looking for it to 
               identify which row is being updated. 
               Otherwise the RowIndent property is set to the ROWID(s)
               of the database record(s).
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBrowse    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hParent    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iBuffer    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowIdent  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cNewRecord AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lQueryObj  AS LOGICAL   NO-UNDO.
  
  {get BrowseHandle hBrowse}.
  hQuery = hBrowse:QUERY.
  {get NewRecord cNewRecord}.   /* save to check at very end */
  {get QueryObject lQueryObj}.
  IF NOT lQueryObj THEN
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
  ELSE DO:
    /* If it's a new record (Add/Copy) then RowIdent will be set correctly. */
    IF cNewRecord = 'No':U THEN   /* RowIdent is the db ROWIDs. */
    DO:
      DO iBuffer = 1 TO hQuery:NUM-BUFFERS:
        hBuffer = hQuery:GET-BUFFER-HANDLE(iBuffer).
        cRowIdent = cRowIdent + ",":U +  /* Leave first element blank - no TT */
          IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U.
      END.    /* END DO iBuffer */
      {set RowIdent cRowIdent}.
    END.      /* END DO IF not NewRecord */
  END.      /* END DO QueryObject NE No */
  
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN DO:
    ASSIGN hParent = FOCUS:PARENT WHEN VALID-HANDLE(FOCUS).
    IF hParent NE hBrowse THEN RUN applyEntry IN TARGET-PROCEDURE (?).
    RETURN "ADM-ERROR":U.
  END.
  
  /* If this was an Add or Copy, then re-open the local db query if 
     there is one. */
  ELSE IF lQueryObj AND cNewRecord NE 'No':U THEN
  DO:
    {fn openQuery}.
    APPLY "END":U TO hBrowse.  /* NOTE: Presumes new record is at the end. */
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataBrowser version of updateState.
  Parameters:  pcState AS CHARACTER
               Possible values are:
               UpdateBegin      - Enables columns in the browse and passes
                                  updateState to other objects
               Update           - Disables the browse. It means that some other
                                  object has just started an update
               UpdateComplete   - Enables the browse
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE hBrowse        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hSearchField   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lModified      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord     AS CHARACTER NO-UNDO.
  
  {get DataModified lModified}. 
  {get NewRecord cNewRecord}.   
  IF lModified OR cNewRecord NE 'no':U THEN RETURN.
    
  CASE pcState:
    WHEN 'UpdateBegin':U THEN 
    DO:
      RUN enableFields IN TARGET-PROCEDURE.
      PUBLISH 'updateState':U FROM TARGET-PROCEDURE 
        /* In case enable fails for some reason.*/
        (IF RETURN-VALUE = "ADM-ERROR":U THEN 'UpdateComplete':U
           ELSE 'Update':U).   /* Tell others (Data Object, Nav Panel) */
    END.
    WHEN 'Update':U THEN
    DO:
      /* Update means some other object just started an update. Disable the 
         browser until the update completes to prevent the user from changing
         records in the middle of the update. */
      {get BrowseHandle hBrowse}.
      {get SearchHandle hSearchField}.
      ASSIGN
        hSearchField:SENSITIVE = NO WHEN VALID-HANDLE(hSearchField)
        hBrowse:SENSITIVE       = NO
        .
    END.
    WHEN 'UpdateComplete':U THEN
    DO:
      {get BrowseHandle hBrowse}.
      {get SearchHandle hSearchField}.
      ASSIGN
        hSearchField:SENSITIVE = YES WHEN VALID-HANDLE(hSearchField)
        hBrowse:SENSITIVE      = YES
        .
    END.
  END CASE.
  
  RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Formats a row of formatted values from the current row of the
            SmartDataBrowser query for the specified column list.
   Params:  pcViewColList AS CHARACTER -- comma-separated list of 
            requested columns.
    Notes:  Only applies for a SmartDataBrowser with its own query.
            Passes back a CHR(1) delimited list with the RowIdent as the 
            first value in all cases and fields values 
            (in the order they are requested).
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iArray     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cName      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent  AS CHARACTER NO-UNDO.
           
  iColCount = NUM-ENTRIES(pcViewColList).
  /* NOTE: This function is valid only if the Browser has its own db query,
     in which case it will include the Query super procedure and this will
     be defined. Otherwise we don't do anything with this request. */
  hQuery = dynamic-function("getQueryHandle":U IN TARGET-PROCEDURE) NO-ERROR.
  IF NOT VALID-HANDLE(hQuery) THEN
    RETURN ?.

  /* Construct the RowIdent "cookie" which is passed to the requesting object.*/
  /* Start with a blank to signal this is not a RowObject TT */
  DO iTable = 1 TO hQuery:NUM-BUFFERS:
    hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
    cRowIdent = cRowIdent + ",":U + STRING(hBuffer:ROWID).
  END.
  cColValues = cColValues + cRowIdent + CHR(1).

  iColLoop:
  DO iCol = 1 TO iColCount:
    /* Cycle through tables till column found.*/
    DO iTable = 1 TO hQuery:NUM-BUFFERS: 
      cName  = ENTRY(iCol,pcViewColList).
      iArray = IF NUM-ENTRIES(cName,"[") > 1 
               THEN INT(ENTRY(1,ENTRY(2,cName,"["),"]"))
               ELSE 0.
      cName  = ENTRY(1,cName,"[":U).
      hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
      hColumn = hBuffer:BUFFER-FIELD(cName) NO-ERROR.
      IF VALID-HANDLE(hColumn) THEN
      DO:
        cColValues = cColValues + 
          RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE(iArray))) +
          (IF iCol NE iColCount THEN CHR(1) ELSE "":U).
        NEXT iColLoop.                   
      END.    /* END DO for hColumn */
    END.      /* END DO iTable      */
    DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, 
      "Column ":U + ENTRY(iCol, pcViewColList) + "not found in Browser.":U).
    RETURN ?.
  END.        /* END DO iCol        */
  RETURN cColValues.       

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getActionEvent Procedure 
FUNCTION getActionEvent RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: return the event to publish on Default-action of the browse. 
Parameter: 
    Notes: setActionEvent(pcEvent) defines the persistent trigger that runs 
           defaultAction and also subscribes the source-procedure.  
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ActionEvent':U).
  
  RETURN ghProp:BUFFER-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getApplyActionOnExit Procedure 
FUNCTION getApplyActionOnExit RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if exit is suppoesed to select the row in the browse.
    Notes: Currently used by the SmartSelect.
------------------------------------------------------------------------------*/
   DEF VAR lApply AS LOG NO-UNDO.
  {get ApplyActionOnExit lApply}.
  RETURN lApply.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getApplyExitOnAction Procedure 
FUNCTION getApplyExitOnAction RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns TRUE if DEFAULT-ACTION is to exit the browse.
    Notes: Currently used by the SmartSelect.
           The logic is not performed in the trigger, but in the defaultAction
           procedure that gets defined as a persitent DEFAULT-ACTION event
           when setActionEvent is defined. 
           Local DEFAULT-ACTION events could be set up to run defaultAction.            
------------------------------------------------------------------------------*/
   DEF VAR lApply AS LOG NO-UNDO.
   {get ApplyExitOnAction lApply}.
   RETURN lApply.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBrowseHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getBrowseHandle Procedure 
FUNCTION getBrowseHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the browse control.
   Params:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.
  {get BrowseHandle hBrowse} NO-ERROR.
  RETURN hBrowse.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCalcWidth Procedure 
FUNCTION getCalcWidth RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns logical value that determines whether the width of the browse
            is calculated to the exact width it should be for the fields it contains
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCalcWidth AS LOGICAL NO-UNDO.
  {get CalcWidth lCalcWidth} NO-ERROR.
  RETURN lCalcWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSignature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSignature Procedure 
FUNCTION getDataSignature RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a character string value which is a list of integers 
            corresponding to the datatypes of the fields in the object 
            Temp-Table, for use in comparing objects for equivalence.
   Params:  <none>
    Notes:  A SmartDataObject and a SmartDataBrowser which have the same 
            DataSignature will be compatible; the SDO's query can be used 
            by the SmartDataBrowser. The integer values are the same codes 
            used in the _dtype field in the schema. 
            In the case where the SmartDataBrowser has its own db query, 
            this function will return Unknown.
            Used internally.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQueryObj  AS LOGICAL   NO-UNDO.
  
  {get QueryObject lQueryObj}. 
  IF lQueryObj THEN
    RETURN ?.

  {get RowObject hRowObject} NO-ERROR.
  IF VALID-HANDLE(hRowObject) THEN
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hColumn = hRowObject:BUFFER-FIELD(iCol).
    cDataType = hColumn:DATA-TYPE.
    cSignature = cSignature +
      (IF     cDataType = 'CHARACTER':U THEN '1':U
      ELSE IF cDataType = 'DATE':U      THEN '2':U
      ELSE IF cDataType = 'LOGICAL':U   THEN '3':U
      ELSE IF cDataType = 'INTEGER':U   THEN '4':U
      ELSE IF cDataType = 'DECIMAL':U   THEN '5':U
      /* Note: Float/Double reserved for possible future use. */
      ELSE IF cDataType = 'FLOAT':U OR 
              cDataType = 'DOUBLE':U    THEN '6':U
      ELSE IF cDataType = 'RECID':U     THEN '7':U
      ELSE IF cDataType = 'RAW':U       THEN '8':U
      ELSE IF cDataType = 'ROWID':U     THEN '9':U  
      ELSE '0':U).
  END.
  ELSE cSignature = ?.     /* No RowObject means dynamic browse. */
  
  RETURN cSignature.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMaxWidth Procedure 
FUNCTION getMaxWidth RETURNS DECIMAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns maximum value used for setting the width of the browse when
            CalcWidth is TRUE.  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE dMaxWidth AS DECIMAL NO-UNDO.
  {get MaxWidth dMaxWidth} NO-ERROR.
  RETURN dMaxWidth.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumDown Procedure 
FUNCTION getNumDown RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of rows that are displayed DOWN in the browse   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iNumDown AS INTEGER NO-UNDO.
  {get NumDown iNumDown} NO-ERROR.
  RETURN iNumDown.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSearchField Procedure 
FUNCTION getSearchField RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the name of a field on which searching is enabled; if
            set, space is allocated for a fill-in to accept a value to be
            repositioned to.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cField   AS CHARACTER NO-UNDO.
  
  {get SearchField cField}.
  RETURN cField.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setActionEvent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setActionEvent Procedure 
FUNCTION setActionEvent RETURNS LOGICAL
  ( pcEvent AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: subscribe an event to Default-action in the browse. 
Parameter: pcEvent - event that will be published on default-action of the 
                     browse. The caller must also subscribe to the 
                     event.
   Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hBrowse AS HANDLE NO-UNDO.
  {get BrowseHandle hBrowse}.
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ActionEvent':U)
         ghProp:BUFFER-VALUE = pcEvent.
  
  ON 'default-action':U OF hBrowse 
      PERSISTENT RUN defaultAction IN TARGET-PROCEDURE.
  
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyActionOnExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setApplyActionOnExit Procedure 
FUNCTION setApplyActionOnExit RETURNS LOGICAL
  ( plApply AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set to TRUE if exit is to perform the same action as the 
           DEFAULT-ACTION.  
    Notes: Currently used by the SmartSelect.  
------------------------------------------------------------------------------*/
  {set ApplyActionOnExit plApply}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setApplyExitOnAction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setApplyExitOnAction Procedure 
FUNCTION setApplyExitOnAction RETURNS LOGICAL
  ( plApply AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set to TRUE if DEFAULT-ACTION is to exit the browse.
    Notes: Currently used by the SmartSelect.
------------------------------------------------------------------------------*/
  {set ApplyExitOnAction plApply}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCalcWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCalcWidth Procedure 
FUNCTION setCalcWidth RETURNS LOGICAL
  ( plCalcWidth AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose: Sets logical value that determines whether the width of the browse
           is calculated to the exact width it should be for the fields it contains
   Params: plCalcWidth AS LOGICAL   
    Notes:  
------------------------------------------------------------------------------*/
    
  {set CalcWidth plCalcWidth}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataModified Procedure 
FUNCTION setDataModified RETURNS LOGICAL
  ( lModified AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  SmartDataBrowser version of setDataModified.
   Params:  lModified AS LOGICAL -- TRUE or FALSE 
    Notes:  The purpose of this version is to enable/disable the search 
            field (if defined) to disable the search capability while there 
            are updates in progress in the SmartDataBrowser.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hSearchField  AS HANDLE NO-UNDO.
  {get SearchHandle hSearchField}.

  ASSIGN hSearchField:SENSITIVE = NOT lModified 
        WHEN VALID-HANDLE(hsearchField) AND lModified NE ?
        .
  RETURN SUPER( INPUT lModified).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setMaxWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setMaxWidth Procedure 
FUNCTION setMaxWidth RETURNS LOGICAL
  ( pdMaxWidth AS DECIMAL ) :
/*------------------------------------------------------------------------------
  Purpose: Ssets maximum value used for setting the width of the browse when
           CalcWidth is TRUE.   
   Params: pdMaxWidth AS DECIMAL
    Notes:  
------------------------------------------------------------------------------*/
    
  {set MaxWidth pdMaxWidth}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNumDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNumDown Procedure 
FUNCTION setNumDown RETURNS LOGICAL
  ( piNumDown AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the number of rows that are displayed DOWN in the browse
   Params: piNumDown AS INTEGER 
    Notes:  
------------------------------------------------------------------------------*/
    
  {set NumDown piNumDown}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setSearchField) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSearchField Procedure 
FUNCTION setSearchField RETURNS LOGICAL
  ( pcField AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the name of a field which can be searched on for repositioning
            the query the browse is attached to.
   Params:  pcField AS CHARACTER -- SmartDataObject Field Name
   Notes:   The field name passed as parameter is the actual field name in 
            the SmartDataObject not the one referenced in the Data Dictionnary.
------------------------------------------------------------------------------*/

  {set SearchField pcField}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

