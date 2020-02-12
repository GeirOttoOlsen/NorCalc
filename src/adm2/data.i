&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
/* Procedure Description
"Method Library for SmartDataObjects."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library     : data.i - Basic include file for the V9 SmartData object

    Syntax      : {src/adm2/data.i}

    Modified    : January 17, 2000 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
   &GLOB ADMClass data
&ENDIF

 DEFINE VARIABLE grCurrentRow AS ROWID   NO-UNDO. /* Row to return to after upd.*/
 DEFINE VARIABLE ghDataQuery  AS HANDLE  NO-UNDO. /* Temp-Table query hdl */
 DEFINE VARIABLE giRowNum     AS INTEGER NO-UNDO INIT 0.

/* Added or Changed RowIdent temp-table */
DEFINE TEMP-TABLE ModRowIdent NO-UNDO
    FIELD RowIdent AS CHARACTER
    INDEX RowIdent IS PRIMARY RowIdent.

&IF "{&ADMClass}":U = "data":U &THEN
  {src/adm2/dataprop.i}
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-canFindModRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD canFindModRow Method-Library 
FUNCTION canFindModRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Commit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD Commit Method-Library 
FUNCTION Commit RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


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
         HEIGHT             = 6.33
         WIDTH              = 49.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

  {src/adm2/query.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

  RUN start-super-proc("adm2/data.p":U).
  RUN start-super-proc("adm2/dataext.p":U).
  /* dataext.p is merely a simple "extension" of data.p.  This was necessary
     because functions don't have there own action segement and data.p got
     too big and had to be broken up.  All of the functions in dataext.p
     are "vanilla" get and set property functions.  In this case vanilla
     means "no processing", just retrieve and store the value into the
     appropriate ADMProps field.                                            */

/* The prepreprocessor check involving DATA-FIELD-DEFS is used to provide
   backward compatibility with how Beta 2 code defined the preprocessor.
   It got changed for final release to support spaces in the include file's
   path or name. For final release, the preprocessor is a quoted file name. */
 DEFINE TEMP-TABLE RowObject
  /* Allow users to ommit the hardcoded RCODE-INFORMATION and put it in the 
     include instead. 
     This makes it possible to manually maintain the include using LIKE 
     and thus avoid -inp and -tok limitations 
   ----------------------------------------    
    LIKE  CUSTOMER {&TEMP-TABLE-OPTIONS}  
   --------------------------------------*/
 &IF '{&TEMP-TABLE-OPTIONS}' = '' &THEN
     RCODE-INFORMATION
 &ENDIF
  
 &IF '{&DATA-FIELD-DEFS}' BEGINS '"' &THEN
   {{&DATA-FIELD-DEFS}}
 &ELSE
   {&DATA-FIELD-DEFS}
 &ENDIF
   {src/adm2/robjflds.i}.
 
 DEFINE TEMP-TABLE RowObjUpd    NO-UNDO LIKE RowObject
   FIELD ChangedFields AS CHARACTER.
 DEFINE QUERY    qDataQuery           FOR RowObject SCROLLING.
 DEFINE VARIABLE cColumns             AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cContainerType       AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cAppService          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cASDivision          AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cServerOperatingMode AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hRowObject           AS HANDLE     NO-UNDO.

 /* NOTE: If the SOURCE-PROCEDURE is undefined, we are running on an 
    AppServer, so ignore the AppService (partition) value, which is 
    meaningful only to the client. Also set the ASDivision property to
    Server; otherwise just leave it blank -- note that it may be set to
    Client in initializeObject if this is the client side of a split SDO.  */
  IF SOURCE-PROCEDURE = ? THEN
  DO:
    ASSIGN cAppService          = '':U
           cASDivision          = 'Server':U
           cServerOperatingMode = CAPS(SESSION:SERVER-OPERATING-MODE).
  END.
  ELSE /* Not running on an AppServer */
    ASSIGN cAppService  = '{&APPLICATION-SERVICE}':U.

  &IF '{&DB-REQUIRED}':U = 'FALSE':U &THEN
    /* If this is a client proxy, set the Division property to reflect this. 
       Note that if we are running AppServer, but not from a proxy SDO,
       ASDivision will be set from initializeObject upon Connect.         */
    ASSIGN cASDivision  = 'Client':U.
  &ENDIF
  IF cASDivision = '':U THEN
    cServerOperatingMode = 'NONE':U.

  {set AppService cAppService}.
  {set ASDivision cASDivision}.
  {set ServerOperatingMode cServerOperatingMode}.
  {set QueryObject yes}.             /* All DataObjects are query objects.*/
  ghDataQuery = QUERY qDataQuery:HANDLE.  /* Temp-Table query */
  {set DataHandle ghDataQuery}.
  /* Set up the RowObject query to be opened dynamically. */
  ghDataQuery:QUERY-PREPARE('FOR EACH RowObject INDEXED-REPOSITION':U).  

  hRowObject = BUFFER RowObject:HANDLE.
  {set RowObject hRowObject}.  /* Handle of RowObject buffer.*/
  hRowObject = BUFFER RowObjUpd:HANDLE.
  {set RowObjUpd hRowObject}. /* Row Update buffer handle. */
  
   /* Overrides query object setting */
  {set DataSourceEvents 'dataAvailable,confirmContinue':U}.

  /* Don't let this object be an Update-Target if its fields are not updatable*/
  {get UpdatableColumns cColumns}.   /* Fetch this prop, set in query.i */
  IF cColumns = "":U THEN
    RUN modifyListProperty(THIS-PROCEDURE, 'REMOVE':U, 'SupportedLinks':U,
        'Update-Target':U).

  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/datacustom.i}
  /* _ADM-CODE-BLOCK-END */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-clientSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clientSendRows Method-Library 
PROCEDURE clientSendRows :
/*------------------------------------------------------------------------------
  Purpose:     Calls across the AppServer boundary to serverSendRows to fetch
               a batch of RowObject temp-table records.  When the 
               SmartDataObject is split between client and AppServer, 
               this client-side procedure is run from the generic sendRows 
               procedure.  It simply turns around and runs a server-side 
               version which returns the RowObject temp-table records.

  Parameters:  
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
  
  Notes:       All of the parameters are simply received from the caller and
               passed through to serverSendRows on the AppServer.
               If piStartRow is not 0 or ? then pcRowIdent is ignored.
               plNext is ignored if pcRowIdent is "FIRST" or "LAST".
               The most common use of piRowsReturned is to indicate that the
               entire result list has been returned when it is less than 
               piRowToReturn.
------------------------------------------------------------------------------*/

 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO.
 
 DEFINE VARIABLE hAppServer     AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hDataQuery     AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowNum        AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowIdent      AS HANDLE            NO-UNDO.
 DEFINE VARIABLE hRowObject     AS HANDLE            NO-UNDO.
 DEFINE VARIABLE lAdded         AS LOGICAL INIT TRUE NO-UNDO.
 DEFINE VARIABLE nextPosition   AS ROWID             NO-UNDO.
 DEFINE VARIABLE cLastResult    AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cOperatingMode AS CHARACTER         NO-UNDO.
 DEFINE VARIABLE cContext       AS CHARACTER         NO-UNDO. 
  
  {get DataHandle hDataQuery}.

  IF piStartRow = ? OR piStartRow = 0 THEN DO:
    /* If the query is already open then we need to get last in order to 
       save the rowid of the last RowObject in the batch so that we can 
       reposition appropriately after retrieving another batch below. */
    IF hDataQuery:IS-OPEN THEN DO:
        hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
        hDataQuery:GET-LAST().
        IF hRowObject:AVAILABLE THEN DO:
          hRowNum = hRowObject:BUFFER-FIELD('RowNum':U).
          /* If the last record has a row number that is greater than
             9000000 then this is a newly added record and not part of
             the batch that was retrieved so we do not want to save off
             this rowid.  We want to keep getting previous records until
             we get to the rowid of the last RowObject in the last batch 
             that was retrieved - that is the rowid we want to save off.  */  
          DO WHILE lAdded:
             /* The hard-coded 9000000 number is actually a preprocessor 
                value in data.p that is used to set the row number for 
                newly added records, this must be kept in sync with that 
                number - we don't want to make this a property because 
                using row number like this will likely change in a future 
                release so we will just hardcode this for now. */
            IF hRowNum:BUFFER-VALUE > 9000000 THEN
              hDataQuery:GET-PREV().
            ELSE lAdded = FALSE.
          END.  /* Do while lAdded */
          nextPosition = hRowObject:ROWID.
        /* If we are running stateless we need to re-assign the LastResultRow
           to be the RowNum and RowIdent of the RowObject record which is the 
           last record of the batch (excluding newly added records).  This is
           to handle cases where the last row in the batch may have been 
           deleted.  LastResultRow is used in sendRows (when fetchNext is done) 
           to determine which record to start at when retrieving records for 
           the next batch.  */
          {get serverOperatingMode cOperatingMode}.                     
          IF cOperatingMode = "STATELESS":U THEN DO:                    
            ASSIGN hRowIdent   = hRowObject:BUFFER-FIELD('RowIdent':U)
                   cLastResult = hRowNum:BUFFER-VALUE + ";":U + hRowIdent:BUFFER-VALUE. 
            {set LastResultRow cLastResult}.                                            
          END.  /* If Stateless */
        END.  /* If hRowObject Available */
    END.  /* If Query is open */
  END.  /* If piStartRow = ? or 0 */
  
  {get ASHandle hAppServer}.
  IF VALID-HANDLE(hAppServer) THEN DO:
    RUN serverSendRows IN hAppServer (piStartRow, pcRowIdent, plNext, 
      piRowsToReturn, OUTPUT piRowsReturned, OUTPUT TABLE RowObject APPEND).
    {get ServerOperatingMode cOperatingMode}.
    IF cOperatingMode = "STATELESS":U THEN DO:
      RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
      RUN setPropertyList IN TARGET-PROCEDURE (cContext).
    END.  /* If Stateless */
  END.  /* If valid hAppServer */
  
  hDataQuery:QUERY-OPEN(). /* Re-open the Temp-Table query. */
  
  IF nextPosition = ? AND (piStartRow = ? OR piStartRow = 0) THEN
  DO:               /* This was our first fetch. Position BEFORE the first row. */
    hDataQuery:GET-FIRST().
    hDataQuery:GET-PREV().
  END.

  ELSE IF piRowsReturned > 0 THEN DO:
    /* When piStartRow is > 0 then this was called from refreshRow and 
       we need to reposition to the same row. We don't know anything but the 
       rownum, because the rowobject is deleted in refreshRow we cannot use
       the old ROWID, so for now (9.1a) we just do a find since this is in 
       an include. */
    IF piStartRow > 0 THEN DO:
      FIND RowObject WHERE RowObject.RowNum = piStartRow NO-ERROR.
      nextposition = ROWID(RowObject).
      hDataQuery:REPOSITION-TO-ROWID(nextposition) NO-ERROR.
    END.  /* If piStartRow > 0 */
    ELSE DO:
      /* If piRowsToReturn is negative - we are navigating backwards, we need to 
       reposition to the last record in the new batch. */
      IF piRowsToReturn < 0 THEN
          hDataQuery:REPOSITION-TO-ROW(piRowsReturned).
      ELSE DO:
      /* We need to reposition to the last row in the previous batch and
         depending on plNext, we may need to move one additional row forward. */
        hDataQuery:REPOSITION-TO-ROWID(nextPosition).
        IF plNext THEN hDataQuery:REPOSITION-FORWARD(1).
      END.  /* Else do - piRowsToReturn is positive */
    END.  /* Else do - piStartRow = 0 or ? */
  END.  /* If piRowsReturned > 0 */

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doBuildUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doBuildUpd Method-Library 
PROCEDURE doBuildUpd :
/*------------------------------------------------------------------------------
  Purpose:     Transfers changed rows into the Update Temp-Table and returns
               it to the caller (the Commit function).

  Parameters:
    OUTPUT RowObjUpd - table containing updated records

  Notes:       This code, and other "do" procedures, need to be in the 
               SmartDataObject itself to allow the BUFFER-COPY operations. 
               They can be specialized by defining like-named procedures 
               in another support procedure. 
               For each existing row to be updated, there is already a "before"
               copy in the RowObjUpd table, so we create an "after" row.
               There is already a row in RowObjUpd for each Added/Copied row, 
               so we just update it with the latest values.
               There is already a row in RowObjUpd for each Deleted row, so
               we don't need to do anything for these rows.
------------------------------------------------------------------------------*/

  DEFINE OUTPUT PARAMETER TABLE FOR RowObjUpd.
 
  FOR EACH RowObject WHERE RowObject.RowMod = "U":U:   
    CREATE RowObjUpd.
    BUFFER-COPY RowObject TO RowObjUpd.
  END.
  FOR EACH RowObject WHERE RowObject.RowMod = "A":U OR
    RowObject.RowMod = "C":U:   
    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum.
    BUFFER-COPY RowObject TO RowObjUpd.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doCreateUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doCreateUpdate Method-Library 
PROCEDURE doCreateUpdate :
/*------------------------------------------------------------------------------
  Purpose:     FINDs the specified row to be updated and creates a "backup" 
               (a before-image) copy of it in the RowObjUpd table, to support
               Undo.  Run from submitRow when it receives a set of value 
               changes from a UI object.

  Parameters:
    INPUT  pcRowIdent  - encoded "key" of the row to be updated.
    INPUT  pcValueList - the list of changes made.  A CHR(1) delimited list
                         of FieldName/NewValue pairs.
    OUTPUT plReopen    - true if the row was new (either a copy or an add),
                         so reopen RowObject query.
    OUTPUT pcMessage   - error messages.
 
  Notes:       Run from submitRow.  Returns error message or "". 
               If the row is not available in the RowObject temp-table
               (this would be because the SmartDataObject was not the 
               DataSource) this routine FINDs the database record(s) using 
               the RowIdent key before applying the changes, unless it's a 
               new row.
------------------------------------------------------------------------------*/

  DEFINE INPUT  PARAMETER pcRowIdent  AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pcValueList AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plReopen    AS LOGICAL   NO-UNDO INIT no.
  DEFINE OUTPUT PARAMETER pcMessage   AS CHARACTER NO-UNDO.
 
  DEFINE VARIABLE rRowObject    AS ROWID     NO-UNDO.
  DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
  
  ASSIGN rRowObject = TO-ROWID(ENTRY(1, pcRowIdent)) NO-ERROR.

  /* If the "Data" (Temp-Table) query is empty, re-FIND the db rec(s),
      unless it's a newly added row (no db rowids in RowIdent). */
  IF (NOT ghDataQuery:IS-OPEN OR ghDataQuery:NUM-RESULTS = 0) AND
      NUM-ENTRIES(pcRowIdent) > 1 AND ENTRY(2, pcRowIdent) NE "":U THEN
  DO:
    /* Now create a RowObject record and assign a RowNum to it. */
    CREATE RowObject.
    ASSIGN giRowNum = giRowNum + 1
           RowObject.RowNum = giRowNum.
    /* This creates a temp-table row from the db recs. */
    RUN transferDBRow In TARGET-PROCEDURE(pcRowIdent, giRowNum). 
  END.       /* END DO if no query */
        
  ELSE IF NOT AVAILABLE (RowObject) OR rRowObject NE ROWID(RowObject) THEN 
  DO:
    FIND RowObject WHERE ROWID(RowObject) = rRowObject NO-ERROR.
    IF NOT AVAILABLE(RowObject) THEN
    DO:
      pcMessage = "Invalid Row ID  encountered in doCreateUpdate.":U.
      RETURN.
    END.
  END.
  
  /* First check to see if there's already a saved pre-change version 
     of the record; this would be so if the same row is changed 
     multiple times before commit. */
  DO TRANSACTION:
    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum NO-ERROR.
    IF NOT AVAILABLE RowObjUpd THEN
    DO:
      CREATE RowObjUpd.
      BUFFER-COPY RowObject TO RowObjUpd.
    END.

    IF RowObject.RowMod NE "A":U AND /* If this isn't an add/copy then */
       RowObject.RowMod NE "C":U
      THEN RowObject.RowMod = "U":U. /*  flag it as update. NOTE: double-chk*/
    ELSE plReopen = true.            /* Tell caller to reopen query. */
  END.
  
  pcMessage = "".   /* "Success" output value. */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doEmptyModTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEmptyModTable Method-Library 
PROCEDURE doEmptyModTable :
/*------------------------------------------------------------------------------
  Purpose:     Empties the temp-table (ModRowIdent) that keeps track of added
               and modified records since the last openQuery().
 
  Parameters:  <none>
  
  Notes:       The ModRowIdent temp-table contains the rowIdents of records 
               already on the client process and its purpose is to prevent 
               sending duplicate records in upcoming batches.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hModRowIdent AS HANDLE NO-UNDO.
  hModRowIdent = BUFFER ModRowIdent:HANDLE.
  hModRowIdent:EMPTY-TEMP-TABLE().
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doEmptyTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doEmptyTempTable Method-Library 
PROCEDURE doEmptyTempTable :
/*------------------------------------------------------------------------------
  Purpose:     Empties the RowObject temp-table when the database query is 
               being re-opened.
 
  Parameters:  <none>
  
  Notes:       Normally this is not necessary -- the EMPTY-TEMP-TABLE
               method can be used, which is faster. However, this must
               be used when a transaction is active, because EMPTY-TEMP-TABLE
               will not work in that case.
------------------------------------------------------------------------------*/

  DO TRANSACTION:
    FOR EACH RowObject:
      DELETE RowObject.
    END.
  END.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doReturnUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doReturnUpd Method-Library 
PROCEDURE doReturnUpd :
/*------------------------------------------------------------------------------
  Purpose:     RUN from Commit on the client side to get back the Update 
               (RowObjUpd) table (from the server side) and undo any failed 
               changes or return final versions of record values to the client.
 
  Parameters:  
    INPUT cUndoIds - list of any RowObject ROWIDs whose changes were
                     rejected by a commit. Delimited list of the form:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."
            
  Notes:       If the error string in cUndoIds is "ADM-FIELDS-CHANGED", then
               another user has changed at least one field value.  In this 
               case, RowObjUpd fields will contain the refreshed db values 
               and we pass those values back to the client.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER cUndoIds AS CHARACTER NO-UNDO.

  DEFINE BUFFER bRowObjUpd FOR RowObjUpd.
  DEFINE VARIABLE lAutoCommit     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE lRefreshBrowse  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE hDataQuery      AS HANDLE   NO-UNDO.

  {get AutoCommit lAutoCommit}.
  {get DataQueryBrowsed lBrowsed}.
  
  /* Commit successful. */
  IF NOT anyMessage() AND (cUndoIds = "":U) THEN
  DO:
    /* Move updated versions of records, including any values assigned by CREATE
       or WRITE triggers, back into the RowObject table for the client to see. 
       Adds and Copies are marked with an "A" or "C", Updates with "U". */
    FOR EACH RowObjUpd: 
      IF LOOKUP(RowObjUpd.RowMod, "A,C,U":U) NE 0 THEN
      DO:    
        FIND RowObject WHERE RowObject.RowNum = RowObjUpd.RowNum.
        BUFFER-COPY RowObjUpd TO RowObject 
          ASSIGN RowObject.RowMod = "":U.
        RUN Data.Calculate IN THIS-PROCEDURE NO-ERROR.
        /* Display any refreshed values to the current row only. */
        IF (ROWID(RowObject) = grCurrentRow) THEN
        DO:
          IF RowObjUpd.RowMod = "U":U THEN
            PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("SAME":U).
          ELSE /* A or C : Add or Copy */
            PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
        END.
      END.
      /* Empty the update table. */
      DELETE RowObjUpd.
    END. /* for each RowObjUpd */
  END.  /* Commit successful. */
  ELSE DO:  /* Commit not successful. */
    /* Refresh fields from db values for updates only. */
    IF INDEX(cUndoIds, "ADM-FIELDS-CHANGED":U) > 0 THEN
    FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod, "U":U) NE 0:
      /* Skip refreshing the update record if not required. */
      IF INDEX(cUndoIds, STRING(RowObjUpd.RowNum) + CHR(3) + 
               "ADM-FIELDS-CHANGED":U) = 0
      THEN NEXT.

      /* Copy the refreshed db field values to row object. */
      FIND RowObject WHERE RowObject.RowNum = RowObjUpd.RowNum.
      BUFFER-COPY RowObjUpd EXCEPT RowMod TO RowObject.

      /* Copy the refreshed db field values to the pre-commit row.
         Don't copy over the RowMod (that could change what the
         record is used for). And don't copy over ChangedFields. Leave
         that as the client set it. */
      FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum
                        AND bRowObjUpd.RowMod = "":U.
      BUFFER-COPY RowObjUpd EXCEPT RowMod ChangedFields TO bRowObjUpd.
      /* Display any refreshed values to the current row only. */
      IF (ROWID(RowObject) = grCurrentRow) THEN
        PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("SAME":U).
    END. /* ADM-FIELDS-CHANGED */
    /* The pre-commit update record (RowMod = "") contains the right values for
       an undo, so we no longer need the commit copy (RowMod = "U") of
       the update record. A failed AutoCommit Delete should also be removed.
       Don't delete the Add/Copy records or non-AutoCommit Delete records
       because they are needed for Undo. */
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "U":U:
        DELETE RowObjUpd.
    END. /* FOR EACH */
    IF lAutoCommit THEN
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U:
        DELETE RowObjUpd.
    END. /* FOR EACH */

  END. /* Commit not successful */
  
  /* If data object is being browsed and changes can be to more than one
     record (AutoCommit is no), then ensure all records in the displayed
     browser(s) are refreshed correctly by reopening the temp-table query.
     Then position query to current row again. */
  IF lBrowsed AND NOT lAutoCommit THEN
  DO:
    {get DataHandle hDataQuery}.
    lRefreshBrowse = (hDataQuery:IS-OPEN ) AND (grCurrentRow NE ?).
    IF lRefreshBrowse THEN
    DO:
      hDataQuery:QUERY-OPEN(). /* Re-open the Temp-Table query. */
      REPOSITION qDataQuery TO ROWID grCurrentRow.
    END.
  END.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoTrans) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoTrans Method-Library 
PROCEDURE doUndoTrans :
/*------------------------------------------------------------------------------
  Purpose:     Does the buffer delete and copy operations to restore the
               RowObject temp-table when an Undo occurs.  New RowObject records
               (added or copied) are deleted, modified records are restored to 
               their original states and deleted records are recreated.  The
               RowObjUpd table is emptied.

  Parameters:  <none>
 
  Notes:       Invoked from the event procedure undoTransaction.
               doUndoTrans is run on the client side.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iFirstRowNum    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRowNum     AS INTEGER   NO-UNDO.
  
  /* Restore RowObject to its original state. To do this:
     delete any added/copied rows (RowObject.RowMod = "A"/"C"); 
     copy any updated rows (RowObject.RowMod = "U") back from RowObjUpd;
     and restore any deleted rows (RowObjUpd.RowMod = "D"). */
  FOR EACH RowObject WHERE RowObject.RowMod = "A":U OR
                           RowObject.RowMod = "C":U:
    DELETE RowObject.
  END.
  
  FOR EACH RowObject WHERE RowObject.RowMod = "U":U:
    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum AND
                         RowObjUpd.RowMod = "":U.    /* before copy */
    BUFFER-COPY RowObjUpd TO RowObject.
  END.
  
  FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U:
    CREATE RowObject.
    BUFFER-COPY RowObjUpd TO RowObject.
    RowObject.RowMod = "":U.
    
    /* Reset the first or last num values if the undeleted record falls outside
       the current batch range. */
    {get FirstRowNum iFirstRowNum}.
    IF RowObjUpd.RowNum < iFirstRowNum THEN
      {set FirstRowNum RowObjUpd.RowNum}.
    {get LastRowNum iLastRowNum}.
    IF RowObjUpd.RowNum >= iLastRowNum THEN DO:
      {set LastRowNum RowObjUpd.RowNum}.
      {set LastDbRowIdent RowObjUpd.RowIdent}.
    END.  /* If RowNum >= LastRowNum */
  END.

  /* For repositioning, locate the first Update or Delete record thats being undone
     and position there. If there aren't any, then we are undoing an Add. In that
     case, position to the first record in the batch. */
  FIND FIRST RowObjUpd WHERE RowObjUpd.RowMod = "":U OR
                             RowObjUpd.RowMod = "D":U
                       USE-INDEX RowNum NO-ERROR.
  IF AVAILABLE RowObjUpd THEN
    FIND RowObject WHERE RowObject.RowNum = RowObjUpd.RowNum NO-ERROR.
  ELSE
    FIND FIRST RowObject NO-ERROR.
  IF AVAILABLE RowObject THEN
  DO:
    {get FirstRowNum iFirstRowNum}.
    {get LastRowNum iLastRowNum}.
    IF RowObject.RowNum = iFirstRowNum THEN
      {set QueryPosition 'FirstRecord':U}.
    ELSE IF RowObject.RowNum >= iLastRowNum THEN
      {set QueryPosition 'LastRecord':U}.
    ELSE
      {set QueryPosition 'NotFirstOrLast':U}.
  END.
  ELSE
  DO: /* There were no records in the batch to begin with. */
    {set FirstRowNum ?}.
    {set LastRowNum ?}.
    {set QueryPosition 'NoRecordAvailable':U}.
  END.
    
  EMPTY TEMP-TABLE RowObjUpd.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-doUndoUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE doUndoUpdate Method-Library 
PROCEDURE doUndoUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Supports a cancelRow by copying the current RowObjUpd record back 
               to the current RowObject record.
 
  Parameters:  <none>
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hDataQuery  AS HANDLE                NO-UNDO.
   DEFINE VARIABLE rRowObject  AS ROWID                 NO-UNDO.
   DEFINE VARIABLE lAutoCommit AS LOGICAL               NO-UNDO.
   DEFINE VARIABLE lBrowsed    AS LOGICAL               NO-UNDO.

    FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum
      AND RowObjUpd.RowMod = "":U NO-ERROR.
    IF AVAILABLE (RowObjUpd) THEN
    DO:                               /* may not be there if never saved */
      BUFFER-COPY RowObjUpd TO RowObject.
      DELETE RowObjUpd. 
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("SAME":U). 
      RETURN.
    END.   /* END DO IF AVAILABLE */
    
    IF RowObject.RowMod = "A":U OR RowObject.RowMod = "C":U THEN
    DO:
      /* If a save was attempted, clean out the Update table. */
      FIND RowObjUpd WHERE RowObjUpd.RowNum = RowObject.RowNum NO-ERROR.
      IF AVAILABLE (RowObjUpd) THEN
        DELETE RowObjUpd.
      DELETE RowObject.  
      /* Re-establish the current row */
      {get DataHandle hDataQuery}.
      {get CurrentRowid rRowObject}.
      IF hDataQuery:IS-OPEN THEN 
      DO:
        IF DYNAMIC-FUNCTION('linkProperty':U,
                            INPUT 'Update-Source':U,
                            INPUT 'BrowseHandle':U) = ? THEN /* only if UpdateSource is not a SDBrowser */          
          hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
        {get DataQueryBrowsed lBrowsed}.
        IF NOT lBrowsed THEN    /* No Next needed for a browser */
          hDataQuery:GET-NEXT() NO-ERROR.
      END.  /* IF the query is open */
    END. /* DO IF "A"/"C" */
    
    RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareErrorsForReturn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prepareErrorsForReturn Method-Library 
PROCEDURE prepareErrorsForReturn PRIVATE :
/*------------------------------------------------------------------------------
  Purpose:  This appends the RETURN-VALUE from the user-defined transaction
            validation procedure or other update-related error to the list
            of any errors already in the log, and formats this string to
            prepare for returning it to the client.
    Notes:  invoked internally from serverCommit.
------------------------------------------------------------------------------*/
 DEFINE INPUT        PARAMETER pcReturnValue AS CHARACTER NO-UNDO.
 DEFINE INPUT        PARAMETER pcASDivision  AS CHARACTER NO-UNDO.
 DEFINE INPUT-OUTPUT PARAMETER pcMessages    AS CHARACTER NO-UNDO.  
 
  IF pcReturnValue NE "":U THEN
    RUN addMessage IN TARGET-PROCEDURE (pcReturnValue, ?, ?).
  IF pcASDivision = 'Server':U THEN
     pcMessages = LEFT-TRIM(pcMessages + CHR(3) + fetchMessages(),CHR(3)).
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverCommit Method-Library 
PROCEDURE serverCommit :
/*------------------------------------------------------------------------------
  Purpose:     Server-side update procedure. serverCommit is executed on the
               server side of a split SmartDataObject but is called from the
               Commit function which is executed on the client side. Commit
               passes to serverCommit a set up RowObjUpdate records that have
               both the changes to be committed as well as their pre-change 
               copies (before-images).  serverCommit verifies that the records 
               have not been changed since they were read, and then commits the 
               changes to the database.
  
  Parameters:
    INPUT-OUTPUT TABLE RowObjUpd - The Update version of the RowObject 
                                   Temp-Table
    OUTPUT cMessages - a CHR(3) delimited string of accumulated messages from
                       server.
    OUTPUT cUndoIds  - list of any RowObject ROWIDs whose changes need to be 
                       undone as the result of errors in the form of:
               "RowNumCHR(3)ADM-ERROR-STRING,RowNumCHR(3)ADM-ERROR-STRING,..."

  Notes:       Returns false if any update errors are detected.
               If serverCommit determines that another user has modified the
               database records since the original read, the new values from
               the database are copied into the RowObjUpd record and returned
               to Commit so that the new values can be displayed in the UI 
               object.
------------------------------------------------------------------------------*/

  DEFINE INPUT-OUTPUT  PARAMETER TABLE FOR RowObjUpd.
  DEFINE OUTPUT PARAMETER cMessages AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER cUndoIds  AS CHARACTER NO-UNDO INIT "":U.
  
  DEFINE VARIABLE iRowNum       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lCheck        AS LOGICAL   NO-UNDO.
  DEFINE BUFFER   bRowObjUpd    FOR RowObjUpd.
  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjFld    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lKillTrans    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lSubmitVal    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iChange       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cChanged      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedFlds  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cChangedVals  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdatable    AS CHARACTER NO-UNDO.
 
 &IF DEFINED(OPEN-QUERY-{&QUERY-NAME}) NE 0 &THEN  /* Skip when compiling templ*/
  
  /*  
     Starting in 9.1A there are more validation hooks; TransactionValidate is
     maintained for backward compatibility; the new procedure for this slot
     before the transaction begins is preTransactionValidate. 
     These procedures are run here before ChangedFields is calculated so that
     any fields changed by the validation procedure will be picked up. 
     NOTE: Here as with fieldValidate and rowobjectValidate the principle
     is that this application object returns an error message if there is one;
     trigger errors get captured below. */
  RUN TransactionValidate IN THIS-PROCEDURE NO-ERROR. 
  IF NOT ERROR-STATUS:ERROR AND  
     RETURN-VALUE NE "":U THEN
  DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                   INPUT-OUTPUT cMessages).
      RETURN.      /* Bail out if application code rejected the txn. */
  END.   /* END DO IF RETURN-VALUE NE "" */
  RUN preTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
  IF NOT ERROR-STATUS:ERROR AND  
     RETURN-VALUE NE "":U THEN
  DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                   INPUT-OUTPUT cMessages).
      RETURN.      /* Bail out if application code rejected the txn. */
  END.   /* END DO IF RETURN-VALUE NE "" */

  /* Now we must construct the changed value list. This list is actually
           stored in the Before version of the record for an update. */
  {get UpdatableColumns cUpdatable}.
  hRowObjUpd = BUFFER RowObjUpd:HANDLE.

  FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod,"A,C,U":U) NE 0:
     IF RowObjUpd.RowMod = "U":U THEN
        DO:
          FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum AND
            bRowObjUpd.RowMod = "":U.
          /* As of 9.1A, we no longer rely on ChangedFields being set
             before this point. Calculate it here so it includes any
             application-generated values. */
          BUFFER-COMPARE RowObjUpd EXCEPT ChangedFields RowMod RowIdent RowNum
              TO bRowObjUpd CASE-SENSITIVE SAVE cChangedFlds.
        END.    /* END DO IF RowMod = U */
        ELSE IF RowObjUpd.RowMod = "A":U THEN
          DO:
            /* For an Add, set ChangedFields to all fields no longer
               equal to their defined INITIAL value. Determine this by
               creating a RowObject record to compare against. */
            IF NOT AVAILABLE(RowObject) THEN
                CREATE RowObject.
            BUFFER-COMPARE RowObjUpd EXCEPT ChangedFields RowMod RowIdent RowNum
              TO RowObject CASE-SENSITIVE SAVE cChangedFlds. 
          END.      /* END DO If "A" for Add */
        ELSE                 /* use all enabled fields for a Copy. */
          cChangedFlds = cUpdatable.
        /* Now assign the list of fields into the ROU record. 
           (Put it in the before record as well for an Update.) 
           This list will be used by query.p code to ASSIGN changes
           back to the database. */
        IF RowObjUpd.RowMod = "U":U THEN
            bRowObjUpd.ChangedFields = cChangedFlds.
        RowObjUpd.ChangedFields = cChangedFlds.
  END.     /* END FOR EACH */

  /* if a row was temporarily created to supply initial values for the
     Add operation BUFFER-COMPARE, delete it now. */
  IF AVAILABLE(RowObject) THEN
      DELETE RowObject. 

  /* If this is the server side and the ServerSubmitValidation property
     has been set to *yes*, then we execute that normally client side 
     validation here to make sure that it has been done. */
  {get ASDivision cASDivision}.
  IF cASDivision = "Server":U THEN 
  DO:
    {get ServerSubmitValidation lSubmitVal}.
    IF lSubmitVal THEN
    DO:
      
      FOR EACH RowObjUpd WHERE LOOKUP(RowObjUpd.RowMod, "A,C,U":U) NE 0:
        /* Validation procs look at RowObject, so we have to create a row
           temporarily for it to use. This will be deleted below. */
        DO TRANSACTION:
          CREATE RowObject.     
        END.
        BUFFER-COPY RowObjUpd TO RowObject.
        
        cChangedFlds = RowObjUpd.ChangedFields.
        DO iChange = 1 TO NUM-ENTRIES(cChangedFlds):
          ASSIGN cChanged = ENTRY(iChange, cChangedFlds)
                 hRowObjFld = hRowObjUpd:BUFFER-FIELD(cChanged)
                 cChangedVals = cChangedVals +
                   (IF cChangedVals NE "":U THEN CHR(1) ELSE "":U) +
                   cChanged + CHR(1) + STRING(hRowObjFld:BUFFER-VALUE).
        END.    /* END DO iChange */

        /* Now pass the values and column list to the client validation. */
        RUN submitValidation (INPUT cChangedVals, cUpdatable).
        DO TRANSACTION:
          DELETE RowObject. 
        END.
      END.      /* END FOR EACH RowObjUpd */
  
      /* Now exit if any error messages were generated. This means that
         all messages associated with the "client" SubmitValidation will
         be accumulated, but the update transaction will not be attempted
         if there are any prior errors. */
      IF anyMessage() THEN
      DO:
        RUN prepareErrorsForReturn(INPUT "":U, INPUT cASDivision, 
                                   INPUT-OUTPUT cMessages).
        RETURN.
      END.   /* END IF anyMessage */
    END.     /* END DO IF SUbMitVal */
  END.       /* END DO IF Server */

  
  TRANS-BLK:
  DO TRANSACTION ON ERROR UNDO, LEAVE:
    /* This user-defined validation hook is for code to be executed
       inside the transaction, but before any updates occur. */
    RUN beginTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND  
       RETURN-VALUE NE "":U THEN
    DO:
        RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                     INPUT-OUTPUT cMessages).
        UNDO, RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */
    
    /* First locate each pre-change record. Find corresponding database record
       and do a buffer-compare to make sure it hasn't been changed. */
    Process-Update-Records-Blk:
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "":U:
      /* For each table in the join, update its fields if on the enabled list.
         NOTE: at present at least we don't check whether fields in this table
         have actually been modified in this record. */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        RUN addMessage In TARGET-PROCEDURE
          (messageNumber(18), ?, RETURN-VALUE).
        ASSIGN lKillTrans = yes
               cUndoIds = cUndoIds + STRING(iRowNum) + CHR(3) + ",":U.
        UNDO Process-Update-Records-Blk, NEXT Process-Update-Records-Blk.
      END.

      DO:     /* If we didn't bail because record wasn't found, do the update.*/
        /* Check first whether we care if the database record has been
           changed by another user. This is a settable instance property. */
        {get CheckCurrentChanged lCheck}.
        IF lCheck THEN
        DO:
          RUN compareDBRow In TARGET-PROCEDURE.
          IF RETURN-VALUE NE "":U THEN /* Table name that didn't compare is returned. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE
             (SUBSTITUTE(messageNumber(8), '':U /* No field names available. */) , ?, 
              RETURN-VALUE  /* Table name that didn't compare */).
            cUndoIds = cUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + "ADM-FIELDS-CHANGED":U + ",":U.
            /* Get the changed version of the record in order to copy
               the new database values into it to pass back to the client.*/
            FIND bRowObjUpd WHERE bRowObjUpd.RowNum = RowObjUpd.RowNum
                              AND bRowObjUpd.RowMod = "U":U.
            DO ON ERROR UNDO, RETRY:
              IF NOT RETRY THEN
                RUN refetchDBRow IN TARGET-PROCEDURE
                  (INPUT BUFFER bRowObjUpd:HANDLE).
              ELSE DO:
                RUN addMessage IN TARGET-PROCEDURE (?, ?, ?).
                lKillTrans = yes.
                cUndoIds = cUndoIds + STRING(bRowObjUpd.RowNum) + CHR(3) + ",":U.
              END.  /* END ELSE DO */
            END.    /* END DO ON ERROR */

            IF cASDivision = 'Server':U THEN
              cMessages = LEFT-TRIM(cMessages + CHR(3) + DYNAMIC-FUNCTION('fetchMessages':U),CHR(3)).
              
            /* Don't try and write values to db. Just process next update record. */
            NEXT Process-Update-Records-Blk.
          END.  /* END DO IF compareDBRow returned a table value */
        END.    /* END DO IF CheckCurrentChanged */
        
        DO:   /* If we haven't 'next'ed because of an error, do the update. */
          /* Now find the changed version of the record, move its fields to the
             database record(s) which were found above, and report any errors
             (which would be database triggers at this point). */
          iRowNum = RowObjUpd.RowNum.
          FIND bRowObjUpd WHERE bRowObjUpd.RowNum = iRowNum AND 
                                bRowObjUpd.RowMod = "U":U.
          /* Copy the ChangedFields to this buffer too */
          ASSIGN bRowObjUpd.ChangedFields = RowObjUpd.ChangedFields
                 hRowObjUpd               = BUFFER bRowObjUpd:HANDLE.
          RUN assignDBRow IN TARGET-PROCEDURE (INPUT hRowObjUpd).
          IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
          DO:
            RUN addMessage IN TARGET-PROCEDURE (?, ?, RETURN-VALUE).
            lKillTrans = yes.
            cUndoIds = cUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
            UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
          END.   /* END DO IF RETURN-VALUE NE "" */
          
          /* Pass back the final values to the client. Note - because we
             want to get values changed by the db trigger, we copy *all*
             fields, not just the ones that are enabled in the Data Object. */
          DO ON ERROR UNDO, RETRY:
            IF NOT RETRY THEN
              RUN refetchDBRow IN TARGET-PROCEDURE
                (INPUT BUFFER bRowObjUpd:HANDLE).
            ELSE DO:
              RUN addMessage IN TARGET-PROCEDURE (?, ?, ?).
              lKillTrans = yes.
              cUndoIds = cUndoIds + STRING(bRowObjUpd.RowNum) + CHR(3) + ",":U.
            END.  /* END ELSE DO */
          END.    /* END DO ON ERROR */
          
          /* Add a record to the ModRowIdent table */
          IF NOT CAN-FIND(FIRST ModRowIdent WHERE
                                ModRowIdent.RowIdent = bRowObjUpd.RowIdent) THEN
          DO:
            CREATE ModRowIdent.
            ASSIGN ModRowIdent.RowIdent = bRowObjUpd.RowIdent.
          END.  /* DO if ModRowIdent is already there */
        END.   /* END DO the update for this row if no error */

        /* RELEASE the database record(s). */
        RUN releaseDBRow IN TARGET-PROCEDURE.
         
      END.    /* END DO if not no-rec-avail */
    END.      /* END FOR EACH RowObjUpd */

    /* This code to handle ADD/COPY operations: */

    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "A":U OR
                             RowObjUpd.RowMod = "C":U:  

      /* This procedure will do the record Create (looking at RowMod) */
      RUN assignDBRow IN TARGET-PROCEDURE (INPUT BUFFER RowObjUpd:HANDLE).
      IF RETURN-VALUE NE "":U THEN  /* returns table name in error. */
      DO:
        /* If the add failed then we need to clear the rowident field 
           because the rowid assigned to it after the BUFFER-CREATE in 
           assignDBRow is now invalid due to the failure. */
        RowObjUpd.RowIdent = "".
        RUN addMessage IN TARGET-PROCEDURE (?, ?, RETURN-VALUE).
        lKillTrans = yes.
        cUndoIds = cUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
        UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.   /* END DO IF RETURN-VALUE NE "" */
      
      /* Pass back the final values to the client. Note - because we
         want to get values changed by the db trigger, we copy *all*
         fields, not just the ones that are enabled in the Data Object. */
      RUN refetchDBRow In TARGET-PROCEDURE
        (INPUT BUFFER RowObjUpd:HANDLE) NO-ERROR.      
      /* if a database trigger returns error it will be catched here */
      IF ERROR-STATUS:ERROR THEN
      DO:
        lKillTrans = yes.
        cUndoIds = cUndoIds + STRING(RowObjUpd.RowNum) + CHR(3) + ",":U.
        IF RETURN-VALUE <> "":U THEN
           RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).
        UNDO, NEXT. /* The FOR EACH block is undone and nexted. */
      END.


      /* Add a record to the ModRowIdent table */
      IF NOT CAN-FIND(FIRST ModRowIdent WHERE
                            ModRowIdent.RowIdent = RowObjUpd.RowIdent) THEN
      DO:
        CREATE ModRowIdent.
        ASSIGN ModRowIdent.RowIdent = RowObjUpd.RowIdent.
      END.  /* DO if ModRowIdent is already there */

      /* RELEASE the database record(s). */
      RUN releaseDBRow IN TARGET-PROCEDURE.
         
    END.  /* END FOR EACH block for Adds. */

    /* This code to handle DELETE operations: */
    
    FOR EACH RowObjUpd WHERE RowObjUpd.RowMod = "D":U:
      /* This will procedure will do the Delete (looking at RowMod) */
      RUN fetchDBRowForUpdate IN TARGET-PROCEDURE.
      IF RETURN-VALUE NE "":U THEN
      DO:
        /* fetchRow will return "Delete" as second element of the return-value
           if it was the Delete, not the FIND EXCLUSIVE-LOCK, which failed. */
        RUN addMessage In TARGET-PROCEDURE
          (IF NUM-ENTRIES(RETURN-VALUE) = 2 THEN messageNumber(23) ELSE
           messageNumber(18), ?, ENTRY(1,RETURN-VALUE)).
        ASSIGN lKillTrans = yes
               cUndoIds = cUndoIds + STRING(iRowNum) + CHR(3) + ",":U.
      END.      /* END DO IF RETURN-VALUE NE "" */
    END.        /* END FOR EACH block */

    /* If errors of any kind, undo the transaction and leave. */
    IF cUndoIds NE "":U OR lKillTrans THEN
      UNDO Trans-Blk, LEAVE Trans-Blk.

    /* This user-defined validation hook is for code to be executed
       inside the transaction, but after all updates occur. */
    RUN endTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND  
       RETURN-VALUE NE "":U THEN
    DO:
        RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                     INPUT-OUTPUT cMessages).
        UNDO, RETURN.      /* Bail out if application code rejected the txn. */
    END.   /* END DO IF RETURN-VALUE NE "" */

  END.          /* END transaction block. */      
&ENDIF          /* ENDIF QUERY defined */

  /* This user-defined validation hook is for code to be executed
       outside the transaction, after all updates occur. */
  RUN postTransactionValidate IN THIS-PROCEDURE NO-ERROR. 
    IF NOT ERROR-STATUS:ERROR AND  
     RETURN-VALUE NE "":U THEN
  DO:
      RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                   INPUT-OUTPUT cMessages).
      RETURN.      /* Bail out if application code rejected the txn. */
  END.   /* END DO IF RETURN-VALUE NE "" */
  
  /* Otherwise add a message to indicate the update has been cancelled. */
  IF cUndoIds NE "":U OR lKillTrans THEN
    RUN addMessage IN TARGET-PROCEDURE (messageNumber(15),?,?).

  /* If we're not on an AppServer, the messages will be available to the
     caller, so don't "fetch" them (which would also delete them). */
  RUN prepareErrorsForReturn(INPUT RETURN-VALUE, INPUT cASDivision, 
                                     INPUT-OUTPUT cMessages).
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-serverSendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE serverSendRows Method-Library 
PROCEDURE serverSendRows :
/*------------------------------------------------------------------------------
  Purpose:     server-side intermediary for sendRows. serverSendRows is only
               called by clientSendRows and only if the SmartDataObject is 
               split across an AppServer boundary.  It does no processing
               but simply runs sendRows passing all parameters on to it and
               returning the RowObject table as an output parameter back to
               the client which now has the new batch of records created in
               sendRows.
 
  Parameters:  
    INPUT  piStartRow     - The RowNum value of the record to start the batch
                            to return.  Typically piStartRow is ? as a flag to 
                            use pcRowIdent instead of piStartRow.
    INPUT  pcRowIdent     - The RowIdent of the first record of the batch to
                            to return.  Can also be "FIRST" or "LAST" to force
                            the retrieval of the first (or last) batch of 
                            RowObject records.
    INPUT  plNext         - True if serverSendRows is to start on the "next"
                            record from what is indicated by piStartRow or
                            piRowIdent.
    INPUT  piRowsToReturn - The number of rows in a batch.
    OUTPUT piRowsReturned - The actual number of rows returned. This number
                            will either be the same as piRowsToReturn or
                            less when there are not enough records to fill
                            up the batch.
  
  Notes:       If piStartRow is not 0 or ? then pcRowIdent is ignored.
               plNext is ignored if pcRowIdent is "FIRST" or "LAST".
               The most common use of piRowsReturned is to indicate that the
               entire result list has been returned when it is less than 
               piRowToReturn.
------------------------------------------------------------------------------*/

 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER NO-UNDO.
 DEFINE OUTPUT PARAMETER TABLE          FOR RowObject.
 
 RUN sendRows IN TARGET-PROCEDURE (piStartRow, pcRowIdent, plNext,
   piRowsToReturn, OUTPUT piRowsReturned).
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-canFindModRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION canFindModRow Method-Library 
FUNCTION canFindModRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Looks up a rowIdent value in the ModRowIdent temp-table and 
               returns TRUE if it is found or false if is isn't.
  
  Parameters:  pcRowIdent - The RowIdent value to look up.
------------------------------------------------------------------------------*/
  RETURN CAN-FIND(FIRST ModRowIdent WHERE ModRowIdent.RowIdent = pcRowIdent).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-Commit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION Commit Method-Library 
FUNCTION Commit RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Client-side part of the Commit function. Copies changed records
            into an update temp-table and sends it to the serverCommit (the
            server-side commit procedure.)
    
  Notes:    The code in submitRow (which calls commitTransaction, which calls
            Commit) has already created a pre-change copy of each changed 
            record in the update temp-table.
            This function invokes procedures in the SmartDataObject itself to 
            manipulate the RowObject Temp-Tables.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRowNum         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCnt            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cUndoIds        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cMessages       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cASDivision     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lBrowsed        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cOperatingMode  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContext        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFirstUndoId    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iUndoId         AS INTEGER   NO-UNDO.

  DEFINE BUFFER bRowObject FOR RowObject.

  /* First save off the current row number, so we can reposition to it after
     the update is all done. */
  IF AVAILABLE RowObject THEN
    grCurrentRow = ROWID(RowObject).
  ELSE grCurrentRow = ?.
  
  /* Transfer modified and added rows to the update table. */
  RUN doBuildUpd (OUTPUT TABLE RowObjUpd).
  
  /* If we're running across an AppServer connection, run serverCommit
     in that other object. Otherwise just run it in ourself. */
  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
    {get ASHandle hAppServer}.
  ELSE hAppServer = THIS-PROCEDURE.
  RUN serverCommit in hAppServer
    (INPUT-OUTPUT TABLE RowObjUpd, OUTPUT cMessages, OUTPUT cUndoIds).

  {get ServerOperatingMode cOperatingMode}.
  IF cOperatingMode = 'STATELESS':U THEN DO:
    RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
    RUN setPropertyList IN TARGET-PROCEDURE (cContext).
  END.  /* If Stateless */

  /* If we're running with a separate AppServer DataObject, then we must
     append any error messages returned to the message log. Otherwise they
     are already there. */
  IF cASDivision = 'Client':U AND cMessages NE "" THEN
    RUN addMessage IN TARGET-PROCEDURE (cMessages, ?, ?).

  /* We need to get the Rowid for the first row (by RowNum) that has failed
     in order to reposition to that row.  */
  IF cUndoIds NE "":U THEN DO:
    DO iCnt = 1 TO NUM-ENTRIES(cUndoIds, ",":U):
      iUndoId = INTEGER(ENTRY(1, ENTRY(iCnt, cUndoIds, ",":U), CHR(3))).
      IF iUndoId > 0 THEN iFirstUndoId = IF iCnt = 1 THEN iUndoId 
                                         ELSE MIN(iFirstUndoId, iUndoId).
    END.  /* Do i to Num entries */
    FIND bRowObject WHERE bRowObject.RowNum = iFirstUndoId NO-ERROR.
    IF AVAILABLE bRowObject THEN grCurrentRow = ROWID(bRowObject).
  END.  /* If cUndoIds NE blank */
  
  /* Return any rows to the client that have been changed by the server. */
  RUN doReturnUpd (INPUT cUndoIds).
  {get DataQueryBrowsed lBrowsed}.   

  /* Now that we're all done, reposition to where we were 
     before we did the commit, but only if there's an active query. */
  IF ghDataQuery:IS-OPEN AND grCurrentRow NE ? AND NOT lBrowsed THEN
  DO:
    REPOSITION qDataQuery TO ROWID grCurrentRow.
    IF NOT AVAILABLE(RowObject) THEN  /* If not being browsed, then this is*/
      GET NEXT qDataQuery.    /* needed to move onto the row itself. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
  END.
   
  RETURN NOT anyMessage().  /* return success if no error msgs. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

