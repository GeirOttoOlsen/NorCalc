&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : query.p
    Purpose     : Super procedure for ADM objects which retrieve data from
                  database tables.

    Syntax      : adm2/query.p

    Modified    : January 4, 2000 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
  /* Tell qryprop.i that this is the query super procedure. */
&SCOP ADMSuper query.p

  {src/adm2/custom/queryexclcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  (pcWhere  AS CHARACTER,
   pcBuffer AS cHARACTER,
   pcAndOr  AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,   
   pcValues    AS CHARACTER,    
   pcOperators AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferCompareDBToRO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD bufferCompareDBToRO Procedure 
FUNCTION bufferCompareDBToRO RETURNS LOGICAL
  ( INPUT phRowObjUpd AS HANDLE,
    INPUT phBuffer    AS HANDLE,
    INPUT pcExcludes  AS CHARACTER,
    INPUT pcAssigns   AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  (pcColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbColumnDataName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dbColumnDataName Procedure 
FUNCTION dbColumnDataName RETURNS CHARACTER
  (pcDbColumn AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excludeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD excludeColumns Procedure 
FUNCTION excludeColumns RETURNS CHARACTER
  (iTable AS INTEGER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstBufferName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD firstBufferName Procedure 
FUNCTION firstBufferName RETURNS CHARACTER PRIVATE
  (pcExpression AS CHAR)  /* expression */  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAssignList Procedure 
FUNCTION getAssignList RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCheckLastOnOpen Procedure 
FUNCTION getCheckLastOnOpen RETURNS LOGICAL
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTarget Procedure 
FUNCTION getDataTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQuerySort Procedure 
FUNCTION getQuerySort RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryString Procedure 
FUNCTION getQueryString RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDbQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseDbQualifier Procedure 
FUNCTION getUseDbQualifier RETURNS LOGICAL
 (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER PRIVATE
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD mappedEntry Procedure 
FUNCTION mappedEntry RETURNS CHARACTER PRIVATE
  (pcEntry AS CHAR,
   pcList  AS CHAR,
   plFirst AS LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER PRIVATE
  (pcBuffer     AS CHAR,   
   pcExpression AS char,  
   pcWhere      AS CHAR,
   pcAndOr      AS CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,
   pcOperators AS CHARACTER) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowidWhere Procedure 
FUNCTION rowidWhere RETURNS CHARACTER
  ( pcWhere AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCheckLastOnOpen Procedure 
FUNCTION setCheckLastOnOpen RETURNS LOGICAL
 (pCheck AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataTarget Procedure 
FUNCTION setDataTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataTargetEvents Procedure 
FUNCTION setDataTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpen AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setOpenQuery Procedure 
FUNCTION setOpenQuery RETURNS LOGICAL
  (pcQuery AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryPosition Procedure 
FUNCTION setQueryPosition RETURNS LOGICAL
  ( pcPosition AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQuerySort Procedure 
FUNCTION setQuerySort RETURNS LOGICAL
  ( pcSort AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  (pcQueryString AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  ( pcWhere AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-whereClauseBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-EXTERNAL whereClauseBuffer Procedure 
FUNCTION whereClauseBuffer RETURNS CHARACTER PRIVATE
  (pcWhere AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the buffername of a where clause expression. 
               This function avoids problems with leading or double blanks in 
               where clauses.
  Parameters:
    pcWhere - Complete where clause for ONE table with or without the FOR 
              keyword. The buffername must be the second token in the
              where clause as in "EACH order OF Customer" or if "FOR" is
              specified the third token as in "FOR EACH order".
  
  Notes:       PRIVATE, used internally in query.p only.
------------------------------------------------------------------------------*/
  pcWhere = LEFT-TRIM(pcWhere).
  
  /* Remove double blanks */
  DO WHILE INDEX(pcWhere,"  ":U) > 0:
    pcWhere = REPLACE(pcWhere,"  ":U," ":U).
  END.
  
  RETURN ENTRY(IF pcWhere BEGINS "FOR ":U THEN 3 ELSE 2,pcWhere," ":U).
  
END.

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
         HEIGHT             = 13.38
         WIDTH              = 52.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/qryprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignDBRow Procedure 
PROCEDURE assignDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Copies modified values from the RowObject row to the database
               records (which for an Update have already been retrieved 
               and locked).
               If the RowMod field is "A" for Add or "C" for Copy, the procedure
               creates the database record(s) first and then does the assign.

  Parameters:
    INPUT phRowObjUpd - handle of the buffer to copy from.
  
  Notes:       The procedure copies over only those fields whose values were
               actually modified, unless this is a copied record, in which
               case we want to save all the fields that were enabled for update.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phRowObjUpd  AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE hRowObjUpd    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUpdatable    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObjFld    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDBField      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cChangedFlds  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iField        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iTable        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cFromField    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cToField      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffers      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssignList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iAssigns      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iEntry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iBracket      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExtent       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowMod       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDBRecs       AS HANDLE    NO-UNDO EXTENT 10.
  
  {get RowObjUpd hRowObjUpd}.    /* This is the "before" rec w/ changed fields. */
  /* This will get the list of Updatable Columns with CHR(1) delimiters between
     columns from different tables. */
  {get UpdatableColumnsByTable cUpdatable}.
  {get BufferHandles cBuffers}.    /* handles of database record buffers */
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    hDBRecs[iTable] = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
  END.   /* END DO iTable */
  {get Tables cTables}.            /* names of database tables */
  {get AssignList cAssignList}.    /* assign syntax for modified field names */
    
  hRowMod = hRowObjUpd:BUFFER-FIELD('RowMod':U).
  IF hRowMod:BUFFER-VALUE = "C":U THEN
    cChangedFlds = REPLACE(cUpdatable, CHR(1), ",":U).
  ELSE 
    ASSIGN hRowObjFld = hRowObjUpd:BUFFER-FIELD('ChangedFields':U)
           cChangedFlds = hRowObjFld:BUFFER-VALUE.
  
  /* If this is an Add or a Copy then create the DB records first. */
  IF hRowMod:BUFFER-VALUE = "A":U OR hRowMod:BUFFER-VALUE = "C":U THEN
  DO:
    DO iTable = 1 TO NUM-ENTRIES(cBuffers):
      hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
      IF ENTRY(iTable, cUpdatable, CHR(1)) NE "":U THEN
        /* This table has enabled fields, so create a record for it. */
        hBuffer:BUFFER-CREATE().
      /* If there aren't enabled fields in the table, in the case of
         an outer join, for example, we need to release the record
         from the buffer because a record is not being added to the
         table and we don't want an incorrect ROWID being stored in 
         the RowIdent below. */       
      ELSE hBuffer:BUFFER-RELEASE() NO-ERROR.
      /* Generate a RowIdent field for the RowObj row. Note that if this is
         a join of both enabled and non-enabled tables, this may be a 
         combination of new Rowids and existing ones. */
      cRowIdent = IF iTable = 1 THEN STRING(hBuffer:ROWID)
                  ELSE cRowIdent + ",":U + 
                       (IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U).
    END.     /* END DO iTable */
    ASSIGN hRowObjFld = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
           hRowObjFld:BUFFER-VALUE = cRowIdent.
  END.       /* END DO IF "A" or "C" */
  
  DO iField = 1 TO NUM-ENTRIES(cChangedFlds):
    /* This is the field name in the RowObject. */
    ASSIGN cFromField = ENTRY(iField, cChangedFlds).
    /* Find which table the field came from, and copy it to the 
       corresponding db field. */
    DO iTable = 1 TO NUM-ENTRIES(cBuffers):
      /* In the case of an outer join the application may have allowed
         a row to be updated for which there is no db record; ignore
         those silently, to allow user code to handle the add/update. */
      IF NOT hDBRecs[iTable]:AVAILABLE THEN
          NEXT.
      IF LOOKUP(cFromField, ENTRY(iTable, cUpdatable, CHR(1))) NE 0 THEN
      DO:
        /* The field name in the db record might be different;
           look for it in the list of assignments of changed fieldnames.
           These assignments are of the form:
        ROfield,DBfield[,...][CHR(1)...]   -- CHR(1) between tables */
        cToField = mappedEntry(cFromField, 
                               ENTRY(iTable, cAssignList, CHR(1)),
                               TRUE /* lookup first of the pair */).
        IF cToField = "":U THEN 
           cTofield = cFromField.
    
        /* Now we've got the field name(s) -- copy the buffer value
           from RowObjUpd to the db table record. */
        /* If there's an extent subscript, remove it from the name
           and save it to use as the BUFFER-VALUE argument. */
        iBracket = INDEX(cToField, '[':U).
        IF iBracket NE 0 THEN
        DO:
          ASSIGN iExtent = INT(SUBSTR(cToField, iBracket + 1,
                    INDEX(cToField,']':U) - iBracket - 1))
                 cToField = SUBSTR(cToField, 1, iBracket - 1).
        END.   /* END DO IF iBracket NE 0 */
        ELSE iExtent = 0.
        ASSIGN hRowObjFld = phRowObjUpd:BUFFER-FIELD(cFromField)
               hDBField   = hDBRecs[iTable]:BUFFER-FIELD(cToField).
        IF iExtent > 0 THEN
          hDBField:BUFFER-VALUE(iExtent) = 
            hRowObjFld:BUFFER-VALUE NO-ERROR.
        ELSE
          hDBField:BUFFER-VALUE = hRowObjFld:BUFFER-VALUE NO-ERROR.
        IF ERROR-STATUS:ERROR THEN   /* just in case something's bad */
          RETURN ENTRY(iTable, cTables).
      END.      /* END DO IF LOOKUP in current table found it */
    END.        /* END DO iTable */
  END.          /* END DO iField for each field */

  RETURN.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferCopyDBToRO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE bufferCopyDBToRO Procedure 
PROCEDURE bufferCopyDBToRO :
/*------------------------------------------------------------------------------
  Purpose:     Perform a BUFFER-COPY of a database buffer to a row object buffer.
               In particular, if an assign-list is used to map individual array
               elements from the database buffer to the row object buffer, this
               procedure will ensure that the values are copied properly.
  Parameters:  INPUT phRowObj AS HANDLE - Handle to the row object buffer that
                 is to be the target of the BUFFER-COPY.
               INPUT phBuffer AS HANDLE - Handle to the database buffer that is
                 to be the source of the BUFFER-COPY.
               INPUT pcExcludes AS CHARACTER - Comma-delimited list of fields to be
                 excluded from the BUFFER-COPY.
               INPUT pcAssigns AS CHARACTER - Comma-delimited list of field pairs to
                 be individually copied; The field pairs are mappings of fields 
                 from the target/source buffers where the field names differ.
  Notes:       The primary purpose of this procedure is to detect when individual
               array fields are referenced in the assign-list (pcAssigns) from 
               the database buffer and to ensure that they are copied properly.
               It is assumed that the database buffer is always the source of the
               BUFFER-COPY, so that the second field in the assign-list field pair
               is always where the individual array reference will be found 
               (e.g., pcAssigns = "ROfld1,DBfld[1]").
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER phRowObj   AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER phBuffer   AS HANDLE    NO-UNDO.              
  DEFINE INPUT PARAMETER pcExcludes AS CHARACTER NO-UNDO.  
  DEFINE INPUT PARAMETER pcAssigns  AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE hField  AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE hField2 AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTemp   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCtr    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExt    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos    AS INTEGER   NO-UNDO.

      /* If the assign-list (cAssigns) contains any individual array fields, we
         can not use BUFFER-COPY.  We must assign each field (pair) manually. */
      IF INDEX(pcAssigns, "[":U) NE 0 THEN
      DO:
        /* Copy everything but the assign-list fields. */
        phRowObj:BUFFER-COPY(phBuffer, pcExcludes).
        /* Manually assign the assign-list fields. */
        DO iCtr = 2 TO NUM-ENTRIES(pcAssigns) BY 2:
          ASSIGN cTemp = ENTRY(iCtr, pcAssigns)  /* DB field */
                 iPos = INDEX(cTemp, "[":U).        /* Position of left bracket */
          IF iPos > 0 THEN  /* Get extent value and base name for array field */
            ASSIGN iExt = INTEGER(ENTRY(1, SUBSTR(cTemp, iPos + 1), "]":U))
                   cTemp = SUBSTR(cTemp, 1, iPos - 1).
          ELSE
            ASSIGN iExt = 0.  /* non-array field */
          /* Assign field */
          ASSIGN hField = phRowObj:BUFFER-FIELD(ENTRY(iCtr - 1, pcAssigns))
                 hField2 = phBuffer:BUFFER-FIELD(cTemp)
                 hField:BUFFER-VALUE = hField2:BUFFER-VALUE(iExt).
        END.
      END.
      ELSE
        phRowObj:BUFFER-COPY(phBuffer, pcExcludes, pcAssigns).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compareDBRow Procedure 
PROCEDURE compareDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Does a buffer-compare of the current RowObjUpd row to the
               database records it is derived from. If any fields have been
               changed the the name of the first table with changed fields
               is returned in the RETURN-VALUE of the procedure.

  Parameters:  <none>

  Notes:       The dynamic buffer-compare does not return the names of fields
               which were changed, so this information is not available to put
               into a message. The procedure returns the first table name which
               has fields which don't match.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTable     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObjUpd AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjFld AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssigns   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSame      AS LOGICAL   NO-UNDO.
  
  {get BufferHandles cBuffers}.       /* DB buffer handles */
  {get AssignList cAssigns}.          /* List of fields whose names were changed */
  {get RowObjUpd hRowObjUpd}.
  
  ASSIGN hRowObjFld = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
         cRowIdent = hRowObjFld:BUFFER-VALUE.

  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    IF ENTRY(iTable, cRowIdent) NE "":U THEN /* allow for outer join w/ no rec */
    DO:
      ASSIGN
        hBuffer  = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
        /* don't compare with field form other tables that have the same 
           name, but are not used */ 
        cExclude = {fnarg excludeColumns iTable}.
      
      IF INDEX(cAssigns, "[":U) = 0 THEN 
        lSame = hBuffer:BUFFER-COMPARE(hRowObjUpd, 
                                       'case-sensitive':U,
                                       cExclude, 
                                       ENTRY(iTable, cAssigns, CHR(1))).
      ELSE    /* If array elements are present, we must assign them manually. */
        lSame = bufferCompareDBToRO(hRowObjUpd, 
                                   hBuffer, 
                                   cExclude, 
                                   ENTRY(iTable, cAssigns, CHR(1))).
      IF NOT lSame THEN
      DO:
        {get Tables cBuffers}.
        RETURN ENTRY(iTable, cBuffers).
      END.  /* END DO IF AVAILABLE */
    END.    /* END DO IF cRowIdent NE "" */
  END.      /* END DO iTable */
  RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmContinue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmContinue Procedure 
PROCEDURE confirmContinue :
/*------------------------------------------------------------------------------
  Purpose: Checks the state of all data-targets too se if it's ok to continue.
           It's not OK to continue if a data-target is Modified or the 
           RowUpdateState equals 'rowUpdated', in these case the I-O parameter 
           should return cancel = TRUE. The visual objects (visual.p) 
           will, however, offer the user the opportunity to save/cancelRecord or 
           commit/undo in order to be able to continue.   
                  
Parameters: INPUT-OUTPUT  pioCancel (logical) 
                 Will return true if it's NOT ok to continue.  
  Notes:   This method should be called from any method that may change the 
           result set somewhere in the data-source chain like openQuery or 
           navigation actions.
           Currently called from the filter-source to see if new criteria can 
           be applied.        
           (Currently the Navigation actions are disabled whenever a state
            that may disallow continuation is set to true, but if a less modal 
            dialog could be achieved by calling this from fetch* methods.)
------------------------------------------------------------------------------*/
   DEFINE INPUT-OUTPUT PARAMETER pioCancel AS LOGICAL NO-UNDO.  
   
   /* don't ask data-targets if already cancelled */  
   IF NOT pioCancel THEN
     PUBLISH "confirmContinue":U FROM TARGET-PROCEDURE (INPUT-OUTPUT pioCancel).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     dataAvailable is an event procedure that generates a dependent 
               query dynamically based on the ForeignFields property.  This 
               event occurs when a Data-Source publishes "dataAvailable" because
               it has new data available and a dependant object need to react.
 
  Parameters:
    INPUT pcRelative - a flag decribing the newly available record.
                       Valid values are:
                       "SAME"          - The current record is being resent 
                                         because it has been updated.  This
                                         procedure ignores this type.
                       "VALUE-CHANGED" - A target SmartDataObject has changed
                                         its query position.  This procedure
                                         needs to set the QueryPosition
                                         property then change pcRelative to 
                                         "DIFFERENT" before passing it along
                                         to other target procedures so as to 
                                         appear as if the change occured in
                                         this procedure.
                       "DIFFERENT"     - The RowObject record has changed
                       "FIRST"         - 
                       "NEXT"          -
                       "PREV"          -
                       "LAST"          -
  
  Notes:       This is a special version of DataAvailable for SmartDataObjects
               with a dependency on another SmartDataObject. So the code is 
               different from that for a Viewer, for example. If there are no 
               ForeignFields, then it is being run because of a reposition in 
               one of its targets (a SmartDataBrowser, normally), in which 
               case it just passes on the event to other targets.
------------------------------------------------------------------------------*/

 DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.
 
 DEFINE VARIABLE cForeignFields AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cSourceFields  AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cLocalFields   AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cValues        AS CHARACTER NO-UNDO.
 DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
 DEFINE VARIABLE iField         AS INTEGER   NO-UNDO.      
 DEFINE VARIABLE iValue         AS INTEGER   NO-UNDO.      
 DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.  
 DEFINE VARIABLE lCharacter     AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE cFieldName     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cFieldType     AS CHARACTER NO-UNDO.  
 DEFINE VARIABLE cQuery         AS CHARACTER NO-UNDO.  
 DEFINE VARIABLE hQuery         AS HANDLE    NO-UNDO.
 DEFINE VARIABLE cPosition      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iCurrent       AS INTEGER   NO-UNDO.  
 DEFINE VARIABLE cNewPos        AS CHARACTER NO-UNDO.
 DEFINE VARIABLE lNewSource     AS LOG    NO-UNDO.
 /* If the same row is being resent because of an update, we don't want to react 
    to that, so just skip it if it's not a different row. */
 IF pcRelative = "SAME":U THEN RETURN.
 
  /* Get the foreign fields, which map the Data Source's RowObject fields
     to this object's database fields and prepare the Query
     using that value. setQueryWhere will open the query. */
  {get ForeignFields cForeignFields}.
  IF cForeignFields = "":U OR pcRelative = "VALUE-CHANGED":U THEN
  DO:
    /* If there were no ForeignFields, a Browser has repositioned the query.
       Just pass along the event to other targets. Set QueryPosition
       property first if that has changed. */
    {get QueryHandle hQuery}.   /* Points to the database query */
    {get QueryPosition cPosition}. /* current First/Last etc. before repos */
    iCurrent = hQuery:CURRENT-RESULT-ROW.  /* *new* current row. */
    
    IF cPosition EQ 'FirstRecord':U AND /* moved away from first */
      iCurrent NE 1 THEN  
        cNewPos = IF pcRelative = "Last":U THEN 'LastRecord':U     
                  ELSE 'NotFirstOrLast':U.   
    ELSE IF cPosition EQ 'NotFirstOrLast':U THEN    /* moved to first/last */
      cNewPos = IF iCurrent EQ 1 THEN 'FirstRecord':U
                ELSE IF pcRelative = "Last":U THEN 'LastRecord':U  
                ELSE "":U.       /* Moved to some other row */
    ELSE IF cPosition EQ 'LastRecord':U AND   /* moved away from last */
      pcRelative NE "Last":U AND pcRelative NE "Next":U THEN
        cNewPos = IF iCurrent = 1 THEN 'FirstRecord':U
                  ELSE 'NotFirstOrLast':U.   
       
    IF cNewPos NE "":U THEN    /* We changed relative position...*/
      {set QueryPosition cNewPos}.
    
    ASSIGN pcRelative = "DIFFERENT":U WHEN pcRelative = "VALUE-CHANGED":U.    
   /* Now let other targets (if any) know about the new position. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE (pcRelative).
    RETURN.
  END.  /* END DO IF FF = "" */
  
  {get DataSource hDataSource}.
  
  IF VALID-HANDLE(hDataSource) THEN
    {get NewRow lNewSource hDataSource}.

  IF NOT lNewSource THEN
  DO:
    DO iField = 1 TO NUM-ENTRIES(cForeignFields) BY 2:
      cLocalFields = cLocalFields +  /* 1st of each pair is local db query fld  */
      (IF cLocalFields NE "":U THEN ",":U ELSE "":U) +
        ENTRY(iField, cForeignFields).
      cSourceFields = cSourceFields +   /* 2nd of pair is source RowObject fld */
      (IF cSourceFields NE "":U THEN ",":U ELSE "":U) +
        ENTRY(iField + 1, cForeignFields).
    END.
    
    cValues = {fnarg colValues cSourceFields hDataSource} NO-ERROR.
  
    /* Throw away the RowIdent entry returned by colValues*/
    IF cValues NE ? THEN cValues = SUBSTR(cValues, INDEX(cValues, CHR(1)) + 1).
  
    {set ForeignValues cValues}.  /* Save FF values for later querying. */
  END. /* not lNewSource  */

 /* NOTE: NOT (lNewSoure = FALSE) because lNewSource = ? when source closed */
  IF NOT (lNewSource = FALSE) OR cValues = ? THEN 
  DO:                     /* No row available in the Source. */
    {fn closeQuery}.      /* Close the previous query. */
    RETURN.
  END.
  
  DYNAMIC-FUNCTION("assignQuerySelection":U IN TARGET-PROCEDURE, 
                    cLocalFields,
                    cValues,
                    '':U).   
                    
  {fn openQuery}.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchDBRowForUpdate) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchDBRowForUpdate Procedure 
PROCEDURE fetchDBRowForUpdate :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves with EXCLUSIVE-LOCK the database records associated 
               with the current RowObjUpd record, as identified by a list of 
               RowIds in the RowIdent field of that record.
               IF the RowMod field is "D" for Delete, deletes the DB record(s).
 
  Parameters:  <none>
 
  Notes:       If one or more of the database records cannot be locked (for any
               reason - most likely because it is locked by another user, but
               perhaps because it has been deleted), the table name of the 
               first unlockable record is returned as the return value.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iTable           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObjUpd       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowid           AS ROWID     NO-UNDO.
  DEFINE VARIABLE hBuffer          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowIdent        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowMod          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lDelSuccess      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hQuery           AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUpdTbls         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iDelCnt          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lFirstRecDeleted AS LOGICAL   NO-UNDO.
  
  {get BufferHandles cBuffers}.    /* DB Buffer handles. */
  {get RowObjUpd hRowObjUpd}.
  {get Tables cTables}.            /* DB Table names. */
  {get QueryHandle hQuery}.
  {get UpdatableColumnsByTable cUpdTbls}.
  
  ASSIGN hRowIdent = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
         cRowIdent = hRowIdent:BUFFER-VALUE
         hRowMod   = hRowObjUpd:BUFFER-FIELD('RowMod':U).
  DO iTable = 1 TO NUM-ENTRIES(cRowIdent):
    hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
    IF ENTRY(iTable, cRowIdent) NE "":U THEN  /* allow for outer-join w/ no rec*/
    DO:
      rRowid = TO-ROWID(ENTRY(iTable, cRowIdent)).
      IF NOT hBuffer:FIND-BY-ROWID(rRowid, EXCLUSIVE-LOCK, NO-WAIT) THEN
        RETURN ENTRY(iTable, cTables).
      IF hRowMod:BUFFER-VALUE = "D":U THEN
      DO:
        IF ENTRY(iTable, cUpdTbls, CHR(1)) = "":U THEN
          /* Table has no enabled fields, so it's not updatable
             and can't be deleted. */
          NEXT.
        ELSE DO ON ERROR UNDO, LEAVE:
          lDelSuccess =  /*hBuffer:BUFFER-DELETE()*/
            /* This is a replacement for the above statement, which does not
            ** support schema delete validation.  We can restore the above
            ** statement if/when there is core support for schema validation.
            */
            DYNAMIC-FUNCTION("deleteRecordStatic":U IN TARGET-PROCEDURE, iTable). 
        END.
        IF NOT lDelSuccess THEN
          /* Signal that Delete failed. */
          RETURN ENTRY(iTable, cTables) + ",Delete":U.  
        ELSE DO:
          IF iTable = 1 THEN
            /* If you delete the first record in a join, then you must
               always delete the result list entry and remove the row
               from the query. */
            lFirstRecDeleted = yes.
          iDelCnt = iDelCnt + 1.
        END.
      END.  /* END DO IF "D"elete */
    END.    /* END DO IF RowIdent NE "" */
    /* If there is no record for this buffer then do a release to clear
       out any leftover record in case code looks at it later. */
    ELSE hBuffer:BUFFER-RELEASE() NO-ERROR.
  END.      /* END DO iTable */

  /* Only delete result list entry if all records in the row are deleted,
     or if the first record in the row is deleted. */
  IF lFirstRecDeleted OR (iDelCnt = NUM-ENTRIES(cRowIdent)) THEN
    /* We need to delete the result list entry.  If this happens to be
       the last record in a batch this is necessary so that sendRows
       does not find this row in the result list when determining
       where to start retrieving records for the next batch. */
    hQuery:DELETE-RESULT-LIST-ENTRY().

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:      Repositions the database query to the first row.
  
  Parameterss:  <none>
  
  Notes:        Requests rows to be transferred from the database query
                if the RowObject query is empty.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRowIdent   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rRowIDs     AS ROWID EXTENT 10 NO-UNDO.
  DEFINE VARIABLE iRow        AS INTEGER NO-UNDO.
  DEFINE VARIABLE lOK         AS LOGICAL NO-UNDO.
  
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */

/* NOTE: THIS IS temporarily removed because fetchFirst is invoked from
   openQuery before the browser is first viewed, so this makes it fail.
   I have to refine this logic, which is here to simulate the deactivation
   of the Navigation link.
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
*/
    
    {get QueryHandle hQuery}.
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).
    IF NOT hQuery:IS-OPEN THEN    /* NOTE: This points to the database Query */
      hQuery:QUERY-OPEN().     /* After an openQuery we must open T-T. */ 
    /* Check the RowIdent property first; if this is set, it means to set the
       initial position to that rowid. */
    {get QueryRowIdent cRowIdent}.
    {set QueryRowIdent ?}.   /* Immediately reset once we have the value. */
    IF cRowIdent NE ? AND cRowIdent NE "":U THEN
    DO:
      rRowIDs = ?.       /* Fill in this array with all the rowids. */
      DO iRow = 1 TO NUM-ENTRIES(cRowIdent):
        rRowIDs[iRow] = TO-ROWID(ENTRY(iRow, cRowIdent)).
      END.        /* END DO iRow */
      lOK = hQuery:REPOSITION-TO-ROWID(rRowIDs).
      IF lOK THEN
        hQuery:GET-NEXT().
    END.    /* END DO cRowIdent */
    ELSE hQuery:GET-FIRST() NO-ERROR.
    IF hBuffer:AVAILABLE THEN  /*  ...unless no records satisfy the query. */
      {set QueryPosition 'FirstRecord':U}.   
    ELSE 
      {set QueryPosition 'NoRecordAvailable':U}.
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("FIRST":U).    
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchLast) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchLast Procedure 
PROCEDURE fetchLast :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the database query to the last row.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden    AS LOGICAL NO-UNDO.
  
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
 
    {get QueryHandle hQuery}.
    IF NOT hQuery:IS-OPEN THEN RETURN. 
    ASSIGN hBuffer    = hQuery:GET-BUFFER-HANDLE(1).
    
    hQuery:GET-LAST().
    IF hBuffer:AVAILABLE THEN
      {set QueryPosition 'LastRecord':U}.
    
    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("LAST":U).
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchNext) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchNext Procedure 
PROCEDURE fetchNext :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the database query to the next row.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRow    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRow     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cLastDbRowId AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRow         AS CHARACTER NO-UNDO.

   /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
 
    {get QueryHandle hQuery}.
    IF NOT hQuery:IS-OPEN         
      THEN RETURN.
      
    hBuffer = hQuery:GET-BUFFER-HANDLE(1).  
    
    {get QueryPosition cQueryPos}.  /* Return if already at end. */
    IF cQueryPos = 'LastRecord':U THEN 
      RETURN.
    
    hQuery:GET-NEXT().
    IF NOT hBuffer:AVAILABLE THEN
    DO:                                 /* No data so reget the last row. */
      hQuery:GET-LAST().
      {set QueryPosition 'LastRecord':U}.
    END.
    ELSE DO:
      /* We need to get the rowids set when the query was opened for the 
         last row of the query, we then need to compare that to this row
         to determine if we are on the last row.  If we are on the last
         row we need to set QueryPosition to 'LastRecord' */
      {get LastDbRowIdent cLastDbRowId}.
      DO iCnt = 1 TO hQuery:NUM-BUFFERS:  /* Assemble the list of rowids */
        ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
               cRow   = cRow + 
                    (IF cRow NE "":U THEN ",":U ELSE "":U)
                      + STRING(hBuffer:ROWID).      
      END.  /* do iCnt 1 to num-buffers */
      IF cLastDbRowId = cRow THEN 
        {set QueryPosition 'LastRecord':U}.
      ELSE IF cQueryPos = 'FirstRecord':U THEN
        {set QueryPosition 'NotFirstOrLast':U}.
    END.  /* else do */
 
    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("NEXT":U).
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the database query to the previous row.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lHidden    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cQueryPos  AS CHARACTER NO-UNDO.
    
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN 
      RETURN.
 
    {get QueryHandle hQuery}.
    ASSIGN hBuffer    = hQuery:GET-BUFFER-HANDLE(1).
    IF (NOT hQuery:IS-OPEN)      
        THEN RETURN.
        
    hQuery:GET-PREV().
    
    /* If we have moved to the first record or away from the last, then
       signal a change of record position state. */
    IF hQuery:QUERY-OFF-END THEN
    DO:
      hQuery:GET-FIRST().
      {set QueryPosition 'FirstRecord':U}.
    END.
    ELSE DO:
      {get QueryPosition cQueryPos}.
      IF cQueryPos = 'LastRecord':U THEN
        {set QueryPosition 'NotFirstOrLast':U}.
      IF hQuery:CURRENT-RESULT-ROW = 1 THEN
        {set QueryPosition 'FirstRecord':U}.
    END.   /* ELSE DO IF NOT OFF-END */
        
    /* Signal row change in any case. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("PREV":U).
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Initialization code for query objects.
  
  Parameters:  <none>
  
  Notes:       The query is not opened if we have a DataSource. This is because
               a DataSource means the object is dependent on data from another
               object. In this case the Data-Target (this procedure) waits
               until the dataAvailable event tells it to open its query. 
               Instead, this procedure RUNs dataAvailable to see if its 
               DataSource is already running with a row available for it;
               in that case the dataAvailable will open the query.
  ------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataSource   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cUIBMOde      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOpenOnInit   AS LOGICAL   NO-UNDO.

  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U 
   THEN RETURN "ADM-ERROR":U.
   
  /* Don't open query in design mode or if there's an 
     external data dependency.  */
  {get UIBMode cUIBMode}.
  {get DataSource hDataSource}.
  {get OpenOnInit lOpenOnInit}.  /* Suppress normal automatic openQuery */
  IF hDataSource = ? AND
    (NOT cUIBMode BEGINS "Design":U) AND
    (lOpenOnInit) THEN
      {fn openQuery}.
  ELSE IF hDataSource NE ? THEN
    RUN dataAvailable IN TARGET-PROCEDURE (?).  /* Don't know if different row. */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refetchDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refetchDBRow Procedure 
PROCEDURE refetchDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Re-reads the current database record(s) to get any field values
               which may have been changed by update triggers, and repopulates 
               the RowObjUpd row with those values.
  
  Parameters:
    INPUT phRowObjUpd - handle of the Update temp-table buffer to be used. Note 
                        that this is required because the caller uses two 
                        different buffers in some cases.
------------------------------------------------------------------------------*/
  
  DEFINE INPUT PARAMETER phRowObjUpd    AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cBuffers       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE rRowid         AS ROWID     NO-UNDO.
  DEFINE VARIABLE hRowIdent      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAssigns       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lFound         AS LOG    NO-UNDO.
  
  {get BufferHandles cBuffers}.      /* Database buffer handles */
  
  /* This is the list of fields whose RowObject names are different from
     the database names. */
  {get AssignList cAssigns}.
  
  ASSIGN hRowIdent   = phRowObjUpd:BUFFER-FIELD('RowIdent':U)
         cRowIdent   = hRowIdent:BUFFER-VALUE.
             
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    IF ENTRY(iTable, cRowIdent) NE "":U THEN
    DO:
      ASSIGN hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers))
             rRowid = TO-ROWID(ENTRY(iTable, cRowIdent)).
      
      lFound = hBuffer:FIND-BY-ROWID(rRowid).
      
      /* This will fire triggers when called from the transaction block,
         if the trigger returns ERROR find-by-rowid will return false
         A return-value will be returned to the user thru adm messaging */ 
      IF NOT lFound THEN 
        RETURN ERROR RETURN-VALUE.

      cExclude = {fnarg excludecolumns iTable}.
      IF INDEX(cAssigns, "[":U) = 0 THEN
        phRowObjUpd:BUFFER-COPY(hBuffer, cExclude /* exclude-list */,
          ENTRY(iTable, cAssigns, CHR(1))).  /* Get changed fld names if any */
      ELSE  /* If array elements are present, we must assign them manually. */
        RUN BufferCopyDBToRO(phRowObjUpd, hBuffer, cExclude,
          ENTRY(iTable, cAssigns, CHR(1))).
    END.   /* END DO RowIdent NE "" */
  END.    /* END DO iTable */
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-releaseDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE releaseDBRow Procedure 
PROCEDURE releaseDBRow :
/*------------------------------------------------------------------------------
  Purpose:     Releases the database records following an update.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cBuffers AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable   AS INTEGER   NO-UNDO.
  
  {get BufferHandles cBuffers}.
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
    IF hBuffer:AVAILABLE THEN hBuffer:BUFFER-RELEASE().
  END.   /* END DO iTable */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-startFilter) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startFilter Procedure 
PROCEDURE startFilter :
/*------------------------------------------------------------------------------
  Purpose:     View/Start the filter-source
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE VARIABLE hFilterSource    AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hWindow          AS HANDLE    NO-UNDO.
   DEFINE VARIABLE lHide            AS LOGICAL   NO-UNDO.
   DEFINE VARIABLE hFilterContainer AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hMyContainer     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cFilterWindow    AS CHARACTER NO-UNDO.
      
   {get FilterSource hFilterSource}.
   
   IF VALID-HANDLE(hFilterSource) THEN DO:
     {get ContainerSource hFilterContainer hFilterSource}.
     {set FilterWindow hFilterContainer:FILE-NAME}.
     {get hideoninit lhide hFilterContainer}. 
     
      /* Workaround to make it visible if it's hideoninit */
      IF lHide THEN 
         RUN destroyObject in hFilterContainer.
   END.
   
   IF NOT VALID-HANDLE(hFilterContainer) THEN DO:
     {get FilterWindow cFilterWindow}.
     {get ContainerSource hMyContainer}.
    
     {get ContainerHandle hWindow}.
      
      RUN constructObject IN hMyContainer (
             INPUT  cFilterWindow,
             INPUT  hWindow,
             INPUT  'HideOnInitnoDisableOnInitnoObjectLayout',
             OUTPUT hFilterContainer).
      RUN addLink IN TARGET-PROCEDURE ( hFilterContainer , 'Filter':U , TARGET-PROCEDURE  ).
   END.    
   
   RUN initializeObject IN hFilterContainer.  
    
   RUN viewObject IN hFilterContainer.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-transferDBRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE transferDBRow Procedure 
PROCEDURE transferDBRow :
/*------------------------------------------------------------------------------
  Purpose:     This procedure buffer-copies the database record(s) for the
               current query row into the RowObject temp-table.
               
  Parameters:
    INPUT pcRowIdent - comma-separated list consisting of the RowId of the 
                       RowObject record followed by the RowIds of the
                       database record(s); if unknown or blank, then the 
                       database records have already been retrieved.
    INPUT piRowNum   - integer value to assign to the RowNum
                       field in the RowObject temp-table record.
     
  Notes:       This procedure replaces the transferRowFromDB function from V9.0.
               It can be localized to perform additional custom operations
               each time a row is tramsferred from the database to the 
               RowObject table.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER piRowNum   AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE iTable          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cBuffers        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowid          AS ROWID     NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cAssigns        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cExclude        AS CHARACTER NO-UNDO.
  
  {get BufferHandles cBuffers}.   /* List of DB Buffer Handles */
  {get RowObject hRowObject}.     /* Buffer handle for the RowObject table. */
  
  IF pcRowIdent = ? THEN
     pcRowIdent = "":U.
  IF pcRowIdent NE "":U THEN
    /* In this case (called from doCreateUpdate, e.g.), we need to
       re-retrieve a row that is no longer in the RowObject table.
       The RowIds if the db records are passed in to us. 
       Note that the first entry in pcRowIdent is ignored because it
       the RowId of the RowObject record itself. */
  DO iTable = 2 TO NUM-ENTRIES(pcRowIdent):
    ASSIGN hBuffer = WIDGET-HANDLE(ENTRY(iTable - 1, cBuffers)).
           rRowid = TO-ROWID(ENTRY(iTable, pcRowIdent)).
    hBuffer:FIND-BY-ROWID(rRowid) NO-ERROR.
  END.   /* END DO iTable */
   
  /* Buffer-Copy the database record(s) into the RowObject buffer. */
  pcRowIdent = "":U.
  /* First assign the RowNum and RowMod fields. */
  ASSIGN hField = hRowObject:BUFFER-FIELD('RowNum':U)
         hField:BUFFER-VALUE = piRowNum
         hField = hRowObject:BUFFER-FIELD('RowMod':U)
         hField:BUFFER-VALUE = "":U.
  
  /* This is the list of fields whose RowObject names are different from
     the database names. */
  {get AssignList cAssigns}.
  
  /* If there is more than one table in the query, we build an exclude list 
     in order to guarantee that buffer-copy only copies fields from the 
     intentional source. Excluding all fieldnames from all other tables 
     prevents a potential overwrite from an unintentional table. */
  
  DO iTable = 1 TO NUM-ENTRIES(cBuffers):
    IF iTable NE 1 THEN
      pcRowIdent = pcRowIdent + ",":U.
    hBuffer = WIDGET-HANDLE(ENTRY(iTable, cBuffers)).
    /* Allow for an outer join without a rec in every buffer. */
    IF hBuffer:AVAILABLE THEN
    DO:
      /* Exclude all fieldnames from all other tables to prevent a potential 
         overwrite from an unintentional table. */ 
      cExclude = {fnarg excludeColumns iTable}.
      IF INDEX(cAssigns, "[":U) = 0 THEN
        hRowObject:BUFFER-COPY
                     (hBuffer,
                      cExclude,
                      ENTRY(iTable, cAssigns, CHR(1))).
      ELSE  /* If array elements are present, we must assign them manually. */
        RUN BufferCopyDBToRO
                   (hRowObject, 
                    hBuffer,
                    cExclude,
                    ENTRY(iTable, cAssigns, CHR(1))).
      pcRowIdent = pcRowIdent + STRING(hBuffer:ROWID).
    END.    /* END DO IF AVAILABLE */
  END.      /* END DO iTable */
  ASSIGN hField = hRowObject:BUFFER-FIELD('RowIdent':U)
         hField:BUFFER-VALUE = pcRowIdent.

  /* If there are calculated fields in the SDO definition, this procedure
     will assign their values. */
  RUN Data.Calculate IN TARGET-PROCEDURE NO-ERROR.
  
  RETURN.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addQueryWhere Procedure 
FUNCTION addQueryWhere RETURNS LOGICAL
  (pcWhere  AS CHARACTER,
   pcBuffer AS cHARACTER,
   pcAndOr  AS CHARACTER):
/*------------------------------------------------------------------------------
   Purpose:    Adds any string-expression to the query's where clause and stores
               the result in the QueryString property.  Returns TRUE if
               successful, FALSE if an appropriate buffer name for the 
               where-clause can't be located.
 
   Parameters: 
     pcWhere     - Expression to add (may also be an "OF" phrase)  
     pcBuffer    - optional buffer specification
     pcAndOr     - Specifies the operator that is used to add the new
                   expression to existing expression(s)
                   - AND (default) 
                   - OR         
   Notes:      This procedure is designed to run on the client in order to be 
               called several times before it is used and will operate on the
               attribute QueryString.
               openQuery takes care of the preparation of the QueryString 
               attribute.
               Returns False if it can't find get a buffer name to associate
               with the Where-Clause.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTables      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.

   /* The QueryString contains data if the query is being currently worked on 
     by this method or assignQuerySelection over many calls. */
  {get QueryString cQueryString}.      
  /* If no QueryString find the current query */ 
  IF cQueryString = "":U OR cQueryString = ? THEN
  DO:
    {get QueryWhere cQueryString}.    
     /* If no current Query find the defined base query */ 
     IF cQueryString = "":U OR cQueryString = ? THEN
       {get OpenQuery cQueryString}.       
  END. /* cQueryString = "":U */

  /* If buffer is unknown try the first buffer reference in the expression */
  IF pcBuffer = ? OR pcBuffer = "":U THEN 
    pcBuffer = firstBufferName(pcWhere).
     
  /* If buffer is still unknown, use the last buffer in the query */   
  IF pcBuffer = ? THEN
  DO:
    {get Tables cTables}.
    pcBuffer = ENTRY(NUM-ENTRIES(cTables),cTables).
    
    IF pcBuffer = ? THEN 
      RETURN FALSE.   
  
  END. /* if cbuffer = ? */
                
  cQueryString  = newWhereClause(pcBuffer,pcWhere,cQueryString,pcAndOr).
 
  {set QueryString cQueryString}.
 
  RETURN TRUE.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignQuerySelection Procedure 
FUNCTION assignQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,   
   pcValues    AS CHARACTER,    
   pcOperators AS CHARACTER):
/*------------------------------------------------------------------------------   
   Purpose: Assigns selection criteria to the query and distributes the 
            column/value pairs to the corresponding buffer's where-clause. 
            Each buffer's expression will always be embedded in parenthesis.
   Parameters: 
     pcColumns   - Column names (Comma separated) 
                   
                   Fieldname of a table in the query in the form of 
                   TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                   (RowObject.FLDNM should be used for SDO's)  
                   If the fieldname isn't qualified it checks the tables in 
                   the TABLES property and assumes the first with a match.
                   
     pcValues    - corresponding Values (CHR(1) separated)
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value       
   Notes:   This procedure is designed to run on the client and to be 
            called several times to build up the the query's where clause 
            (storing intermediate results in the QueryString property) before 
            it is finally used in a Query-Prepare method. 
            openQuery takes care of the preparation of the QueryString property.
            The QueryColumns property is used to ensure that each column and 
            operator only will be added once to the QueryString. The property is 
            also used to store the offset and length of the corresponding values.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE cBufferList    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
  
  /* We need the columns name and the parts */  
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cUsedNums      AS CHAR      NO-UNDO.
  
  /* Used to builds the column/value string expression */
  DEFINE VARIABLE cBufWhere      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType      AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQuote         AS CHAR      NO-UNDO.    
  DEFINE VARIABLE cValue         AS CHAR      NO-UNDO.  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cAndOr         AS CHAR      NO-UNDO.
  
  /* Used if the database query is present (for example a server side SDO)*/ 
  DEFINE VARIABLE cColumnDb      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumnBuf     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn        AS HANDLE    NO-UNDO.
  
  /* A client SDO may need these to get the data-type */
  DEFINE VARIABLE cDataColumn    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
        
  /* Used to store and maintain offset and length */    
  DEFINE VARIABLE iValLength     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iExpPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iDiff          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cQueryColumns  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryBufCols  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryColOp    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cChangedValues AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cChangedList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iOldEntries    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLowestChanged AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cBufferDiffs   AS CHAR      NO-UNDO.
  DEFINE VARIABLE iBufPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iWhereBufPos   AS INTEGER   NO-UNDO.
          
  {get Tables cBufferList}.    
   
  /* The QueryString contains data if the query is being currently worked on 
     by this method or addQuerywhere over many calls. */
  {get QueryString cQueryString}.      
  /* If no QueryString find the current query */ 
  IF cQueryString = "":U OR cQueryString = ? THEN
  DO:
    {get QueryWhere cQueryString}.    
     /* If no current Query find the defined base query */ 
     IF cQueryString = "":U OR cQueryString = ? THEN
       {get OpenQuery cQueryString}.       
  END. /* cQueryString = "":U */

  {get QueryColumns cQueryColumns}.
  /* cQueryColumns has the form of:
        BufName1:columns_of_buf1:BufName2:columns_of_buf2...
      
        Each columns_of_buf has the form of:
        ColumnName.Operator,ValuePosition,ValueLength
        
        The Operator is one of: ">=", "<=","<", ">", "=", "BEGINS", etc.
        The ValuePosition refers to the character position of the value
        in an expression: ColumnName Opr Value
        (The quote is considered part of the value)
        The length of the value is the number of characters in the string
        that represents the value (including quotes) */
  
  ASSIGN 
    cAndOr       = "AND":U. /* We only support and */
    cBufferDiffs = LEFT-TRIM(FILL(",0",NUM-ENTRIES(cBufferList)),","). 
  
  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):  
    ASSIGN
      cBufWhere      = "":U
      cBuffer        = ENTRY(iBuffer,cBufferList)
      iBufPos        = LOOKUP(cBuffer,cQueryColumns,":":U)
      cQueryBufCols  = IF iBufPos > 0 
                       THEN ENTRY(iBufPos + 1,cQueryColumns,":":U) 
                       ELSE "":U
      iOldEntries    = NUM-ENTRIES(cQueryBufCols) / 3    
      cChangedValues = FILL(CHR(1),iOldEntries - 1)
      cChangedList   = "":U
      iLowestChanged = 0.
      
    ColumnLoop:    
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
             
      IF CAN-DO(cUsedNums,STRING(iColumn)) THEN 
        NEXT ColumnLoop.      
        
      cColumn     = ENTRY(iColumn,pcColumns).
      
      /* Convert rowObject reference to db reference */
      IF cColumn BEGINS "RowObject" + "." THEN        
        cColumn =  DYNAMIC-FUNCTION("columnDBColumn":U IN TARGET-PROCEDURE,
                                    ENTRY(2,cColumn,".":U)) NO-ERROR.                                      
      
      /* Unqualified fields will use the first buffer that has a match
         because the columnDataType below searches all buffers in the query */           
      ELSE IF INDEX(cColumn,".":U) = 0 THEN       
        cColumn = cBuffer + ".":U + cColumn.
      
      /* Wrong buffer? */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN 
      DO: 
        /* If the column db qualification does not match the query's we do 
           an additionl check to see if it is the correct table after all */                                
        IF NUM-ENTRIES(cColumn,".":U) - NUM-ENTRIES(cBuffer,".":U) <> 1 THEN
        DO:
          IF {fnarg columnTable cColumn} <> cBuffer THEN 
            NEXT ColumnLoop.  
        END.
        ELSE
          NEXT ColumnLoop.
      END.

      ASSIGN
        /* Get the operator for this valuelist. 
           Be forgiving and make sure we handle '',? and '/begins' as default */                                                  
        cOperator   = IF pcOperators = "":U 
                      OR pcOperators BEGINS "/":U 
                      OR pcOperators = ?                       
                      THEN "=":U 
                      ELSE IF NUM-ENTRIES(pcOperators) = 1 
                           THEN ENTRY(1,pcOperators,"/":U)                                                 
                           ELSE ENTRY(iColumn,pcOperators)
                                           
        /* Look for optional string operator if only one entry in operator */          
        cStringOp   = IF NUM-ENTRIES(pcOperators) = 1 
                      AND NUM-ENTRIES(pcOperators,"/":U) = 2  
                      THEN ENTRY(2,pcOperators,"/":U)                                                 
                      ELSE cOperator                    
        cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U)              
        cDataType   = {fnarg columnDataType cColumn}.

      IF cDataType <> ? THEN
      DO:
        ASSIGN          
          cQuote     = (IF cDataType = "CHARACTER":U AND cValue = "?" 
                        THEN "":U 
                        ELSE "'":U)
          cValue     = ENTRY(iColumn,pcValues,CHR(1))                         
          cValue     = IF CAN-DO("INTEGER,DECIMAL":U,cDataType) AND cValue = "":U 
                       THEN "0":U 
                       ELSE IF cDataType = "DATE":U and cValue = "":U
                       THEN "?":U 
                       ELSE IF cValue = ? /*This could happen if only one value*/
                       THEN "?":U 
                       ELSE cValue
          cValue     = (IF cValue <> "":U 
                       THEN REPLACE(cValue,"'","~~~'")
                       ELSE " ":U) 
          
          cUsedNums  = cUsedNums
                      + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                      + STRING(iColumn) 
          
          /* The Column and operator are unique entries so we must mak sure that  
             that blank or different styles doesn't get misinterpreted  */
          cQueryColOp = cOperator
          cQueryColOp = cStringOp WHEN cDataType = "CHARACTER"            
          cQueryColOp = TRIM(     IF cQueryColOp = "GE":U THEN ">=":U
                             ELSE IF cQueryColOp = "LE":U THEN "<=":U
                             ELSE IF cQueryColOp = "LT":U THEN "<":U
                             ELSE IF cQueryColOp = "GT":U THEN ">":U
                             ELSE IF cQueryColOp = "EQ":U THEN "=":U
                             ELSE    cQueryColOp)
                        
          /* Have the column and operator been added to the querystring
             (by this function) */  
          iPos        = LOOKUP(cColumnName + ".":U + cQueryColOp,cQueryBufCols).
      
        /* If the column + operator was found in the list
           we build a list of the new values to use when we insert the data
           into the QueryString further down.
           We also build a list of the changed numbers, to check if any change 
           has occured. (The list of new values cannot be checked because any 
           data may be new data and we don't know the old value) */         
        IF iPos > 0 THEN
        DO:        
          ASSIGN
            ENTRY(INT((iPos - 1) / 3 + 1),cChangedValues,CHR(1)) = cValue           
            iLowestChanged = MIN(iPos,IF iLowestChanged = 0 
                                      THEN iPos 
                                      ELSE iLowestChanged)
            cChangedList  = cChangedList 
                          + (IF cChangedList = "":U THEN "":U ELSE ",":U)
                          + STRING(INT((iPos - 1) / 3 + 1)).     
        END. /* IF ipos > 0 */   
        ELSE DO: /* This is a new column + operator so we build the new 
                    expression and add the column and offset info to the list 
                    that will be stored as a part of QueryColumns */   
          ASSIGN          
            cBufWhere  = cBufWhere 
                      + (If cBufWhere = "":U 
                         THEN "":U 
                         ELSE " ":U + cAndOr + " ":U)
                      + cColumn 
                      + " ":U
                      + (IF cDataType = "CHARACTER":U  
                         THEN cStringOp
                         ELSE cOperator)
                      + " ":U
                      + cQuote  
                      + cValue
                      + cQuote
                                             
           /* Calculate the temporary offset of this columns value. 
              We (Who are we?) will justify it after the expression has been 
              added to the whereclause, because even if we know the buffer's 
              position, the expression may or may not need and/where */
           iValPos   = LENGTH(cBufWhere) - (LENGTH(cQuote) + LENGTH(cValue))         
                    
           /* Store the ColumName and operator with period as delimiter and 
              add the position and length as separate entries*/
           cQueryBufCols = cQueryBufCols 
                       + (IF cQueryBufCols <> "":U THEN ",":U ELSE "":U)
                       + cColumnName 
                       + ".":U 
                       + cQueryColOp 
                       + ",":U
                       + STRING(iValPos)  
                       + ",":U
                       + STRING(LENGTH(cValue))
           
           /* Ensure that the list used to log changes have correct number of
              entries (Probably only necessary if the SAME column and operator
                       appears a second time in the same call, which is unlikely)
                       */                
           cChangedValues = cChangedValues + CHR(1).                
        END. /* else do =(ipos = 0) */
      END. /* if cDatatype <> ? */          
    END. /* do iColumn = 1 to num-entries(pColumns) */  
    
    /* Get the buffers position in the where clause (always the
       first entry in a dynamic query because there's no 'of <external>')*/ 
    ASSIGN
      iWhereBufPos = INDEX(cQueryString + " "," ":U + cBuffer + " ":U)
      iPos         = INDEX(cQueryString,      " ":U + cBuffer + ",":U)
      iWhereBufPos = (IF iWhereBufPos > 0 AND iPos > 0
                      THEN MIN(iPos,iWhereBufPos) 
                      ELSE MAX(iPos,iWhereBufPos))
                      + 1
      iDiff        = 0.                          

    /* We have a new expression */                               
    IF cBufWhere <> "":U THEN
    DO: 
      
      ASSIGN 
        cQueryString = newWhereClause(cBuffer,cBufWhere,cQueryString,"AND":U) 
        /* get the offset of the new expression */
        iExpPos      = INDEX(cQuerystring,cBufwhere,iWhereBufPos).
      
      /* Store the offset from the buffer's offset */  
      DO iColumn =((iOldEntries + 1) * 3) - 2 TO NUM-ENTRIES(cQueryBufCols) BY 3:
        ENTRY(iColumn + 1,cQueryBufCols) = 
                            STRING(INT(ENTRY(iColumn + 1,cQueryBufCols)) 
                                   + (iExpPos - iWhereBufPos)
                                   ).                 
      END. /* do icolumn = 1 to num-entries */        
    END. /* if cbufwhere <> '' do */  
    
    IF iLowestChanged > 0 THEN 
    DO iColumn = iLowestChanged TO NUM-ENTRIES(cQueryBufCols) BY 3:       
      ASSIGN
        iValPos    = INT(ENTRY(iColumn + 1,cQueryBufCols))
        iValLength = INT(ENTRY(iColumn + 2,cQueryBufCols))
        iValPos    = iValPos + iDiff.                    
                     
      IF CAN-DO(cChangedList,STRING(INT((iColumn - 1) / 3 + 1))) THEN       
      DO:
        ASSIGN
          cValue     = ENTRY(INT((iColumn - 1) / 3 + 1),cChangedValues,CHR(1)) 
          SUBSTR(cQueryString,iValPos + iWhereBufPos,iValLength) = cValue
          idiff      = iDiff + (LENGTH(cValue) - iValLength)
          iValLength = LENGTH(cValue).   
      END. /* can-do(changelist,string(..) */          
      ASSIGN      
        ENTRY(iColumn + 1,cQueryBufCols) = STRING(iValPos)
        ENTRY(iColumn + 2,cQueryBufCols) = STRING(iVallength).      
    END. /* else if ilowestchanged do icolumn = ilowestChanged to num-entries */  
    
    /* If the buffer has no entry in QueryColumns we append the new entry 
       The order in Querycolumns is NOT dependent of the order in the query */              
    IF cQueryBufCols <> "":U THEN
    DO:    
      IF iBufPos = 0 THEN   
         cQueryColumns = cQueryColumns 
                         + (IF cQueryColumns = "":U THEN "":U ELSE ":":U)
                         + cBuffer + ":" + cQueryBufCols.
      
      ELSE /* There is already a entry for this buffer */
        ENTRY(iBufPos + 1,cQueryColumns,":":U) = cQueryBufCols.        
    END. /* cQueryBufCols <> '' */

  END. /* do iBuffer = 1 to hQuery:num-buffers */
  
  {set QueryColumns cQueryColumns}.
  {set QueryString cQueryString}.
  
  RETURN TRUE. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-bufferCompareDBToRO) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION bufferCompareDBToRO Procedure 
FUNCTION bufferCompareDBToRO RETURNS LOGICAL
  ( INPUT phRowObjUpd AS HANDLE,
    INPUT phBuffer    AS HANDLE,
    INPUT pcExcludes  AS CHARACTER,
    INPUT pcAssigns   AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Perform a BUFFER-COMPARE of a database buffer to a RowObjectUpd 
              buffer.  In particular, if an assign-list is used to map 
              individual array elements from the database buffer to the 
              RowObjectUpd buffer, this procedure will ensure that the values 
              are compared correctly.
  Parameters: INPUT phRowObjUpd AS HANDLE - Handle to the RowObjectUpd buffer
              INPUT phBuffer    AS HANDLE - Handle to the database buffer
              INPUT pcExcludes  AS CHAR   - Comma-delimited list of fields to 
                                            be excluded from the BUFFER-COMPARE
              INPUT pcAssigns   AS CHAR   - Comma-delimited list of field pairs
                                            to be individually compared; The 
                                            field pairs are mappings of fields
                                            from the target/source buffers where
                                            the field names differ.
    Notes:    The primary purpose of this procedure is to detect when 
              individual array fields are referenced in the assign-list 
              (pcAssigns) from the database buffer and the ensure that they
              are compared properly.  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cTemp    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hField   AS HANDLE    NO-UNDO.
DEFINE VARIABLE hField2  AS HANDLE    NO-UNDO.
DEFINE VARIABLE iCtr     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iExt     AS INTEGER   NO-UNDO.
DEFINE VARIABLE iPos     AS INTEGER   NO-UNDO.
DEFINE VARIABLE lSame    AS LOGICAL   NO-UNDO.

  IF INDEX(pcAssigns, "[":U) NE 0 THEN
  DO:
    lSame = phBuffer:BUFFER-COMPARE(phRowObjUpd,
                                    'case-sensitive':U,
                                    pcExcludes).
    IF lSame THEN DO:
      CompareAssigns:
      DO iCtr = 2 TO NUM-ENTRIES(pcAssigns) BY 2:
        ASSIGN cTemp = ENTRY(iCtr, pcAssigns)
               iPos  = INDEX(cTemp, "[":U).
        IF iPos > 0 THEN
            ASSIGN iExt = INTEGER(ENTRY(1, SUBSTR(cTemp, iPos + 1), "]":U))
                   cTemp = SUBSTR(cTemp, 1, iPos - 1).
        ELSE ASSIGN iExt = 0.
        ASSIGN hField = phRowObjUpd:BUFFER-FIELD(ENTRY(iCtr - 1, pcAssigns))
               hField2 = phBuffer:BUFFER-FIELD(cTemp).
        lSame = hField:BUFFER-VALUE = hField2:BUFFER-VALUE(iExt).
        IF NOT lSame THEN LEAVE CompareAssigns.
      END.  /* Do iCtl to Num-Entries(pcAssigns) */
    END.  /* If lSame */
  END.  /* If array fields are present */
  ELSE lSame = phBuffer:BUFFER-COMPARE(phRowObjUpd, 
                                       'case-sensitive':U,
                                       pcExcludes, 
                                       pcAssigns).

  RETURN lSame.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Closes the database query.

  Parameters:  <none>
  
  Notes:       closeQuery should not be executed on the client side of a 
               split SmartDataObject because the database query only exists
               on the server side.  No harm will be done, but nothing will
               be closed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  
  {get QueryHandle hQuery}.
  IF VALID-HANDLE (hQuery) THEN
  DO:
    hQuery:QUERY-CLOSE().
    RETURN TRUE.
  END.
  ELSE RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the data-type of a database column.  
   Parameters:  pcColumn - Database fieldname.  
               Can be in the form of: DB.TBL.FLDNM, TBL.FLDNM or FLDNM.  
               (If not qualifed the FIRST ref in query will be used)
  Notes:       Is capable of processing a pcColumn specified with brackets.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE NO-UNDO.
  
  hField = {fnarg columnHandle pccolumn}.       
  RETURN IF VALID-HANDLE(hField) THEN hField:DATA-TYPE ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDbColumn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDbColumn Procedure 
FUNCTION columnDbColumn RETURNS CHARACTER
  (pcColumn AS CHAR):
/*----------------------------------------------------------------------------
  Purpose:   Returns the qualified database name ([DB.]TBL.FLDNM) mapped to 
             the RowObject column specified in pcColumn
  Parameter: pcColumn - Rowobject name to look up
-----------------------------------------------------------------------------*/
   DEFINE VARIABLE cName               AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssignList         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cDataColumnsByTable AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTables             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iTable              AS INTEGER   NO-UNDO.
   
   {get Tables cTables}.   /* List of database tables in the object */
   
   /* If the RowObject name is different from dbname it's in the assign-list,
      which is in the form RowObjectfield,DBField[,...]CHR(1)... --
      with each CHR(1)-delimited group corresponding to a Table. */  
   {get AssignList cAssignList}.
   
   /* comma-separated list of Rowobject columns delimited by CHR(1)
      corresponding to a Table.*/  
   {get DataColumnsByTable cDataColumnsByTable}.
   
   DO iTable = 1 TO NUM-ENTRIES(cTables):
     /* If the RowObject name is different from dbname it's in the assignList*/
     cName = mappedEntry
                   (pcColumn,
                    ENTRY(iTable, cAssignList, CHR(1)), /*Flds for one table */
                    TRUE /* lookup first of pair */).  
     
     IF cName NE "":U THEN
       RETURN ENTRY(iTable, cTables) /* [db.]tablename */
              + ".":U
              + cName.               /* database field name */
     /* Is the column in this table's part of DataColumnsByTable? */
     ELSE IF CAN-DO(ENTRY(iTable, cDataColumnsByTable, CHR(1)),pcColumn) THEN
       RETURN ENTRY(iTable, cTables)  /* [db.]tablename */
              + ".":U
              + pcColumn.             /* field name is column name */
   END.     /* END DO iTable... */
   
   RETURN "":U.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHandle Procedure 
FUNCTION columnHandle RETURNS HANDLE
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of a database column.
  Parameters: 
    pcColumn - Database fieldname.  Can be in the form of: DB.TBL.FLDNM,
               TBL.FLDNM or FLDNM. Find first field if not qualified. 
  Notes:       Is capable of processing a pcColumn specified with brackets.
               Used by columnDataType and ColumnValMsg 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cDbName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldName AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hField     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLBracket  AS INT       NO-UNDO.
       
  {get QueryHandle hQuery}.
     
  /* Sanity check */
  IF pcColumn = "":U THEN
    RETURN ?.

  ASSIGN 
    cDBName    = IF NUM-ENTRIES(pcColumn,".":U) = 3 
                 THEN ENTRY(1,pcColumn,".":U)
                 ELSE ? 
    cBuffer    = IF NUM-ENTRIES(pcColumn,".":U) > 1 
                 THEN ENTRY(NUM-ENTRIES(pcColumn,".":U) - 1,pcColumn,".":U)
                 ELSE ?
    cFieldName = ENTRY(NUM-ENTRIES(pcColumn,".":U),pcColumn,".":U)
    iLBracket  = R-INDEX(cFieldName,'[':U)
                 /* Remove extent bracket from fieldname */ 
    cFieldName = IF iLBracket > 0 
                 THEN SUBSTR(cFieldName,1,iLBracket - 1)  
                 ELSE cFieldName.
    
  DO i = 1 TO hQuery:NUM-BUFFERS:
    hBuffer = hQuery:GET-BUFFER-HANDLE(i). 
     
    IF cBuffer <> ? AND hBuffer:NAME   <> cBuffer THEN NEXT.    
    IF cDbName <> ? AND hBuffer:DBNAME <> cDbName THEN NEXT.  
    
    ASSIGN
      hField = hBuffer:BUFFER-FIELD(cFieldName) NO-ERROR.    
   
    IF VALID-HANDLE(hField) THEN RETURN hField.
    
  END. /* do i = 1 to hQuery:num-buffers */
  RETURN ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(1) separated string with ALL operators and values 
               that has been added to the Query for this column using the 
               assignQuerySelection method. 
               
               Example: If the query contains 'custnum > 5 and custnum < 9' 
                        this function will return (chr(1) is shown as '|'): 
                        '>|5|<|9'    
                              
  Parameters:
   INPUT pcColumn - Fieldname of a table in the query in the form of 
                    TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db),
                    If the fieldname isn't qualified it checks the tables in 
                    the TABLES property and assumes the first with a match.
 
  Notes:       The data returned reflects the QueryString/QueryColumns properties, 
               which is maintained by the assignQuerySelection. These values
               may not have been used in an openQuery yet.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBufferList    AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER  NO-UNDO.  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
        
  /* Used to store and maintain offset and length */    
  DEFINE VARIABLE iValLength     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cString        AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryColumns  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryBufCols  AS CHAR      NO-UNDO.
  DEFINE VARIABLE iBufPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iNumEnt        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSelection     AS CHAR      NO-UNDO.
  DEFINE VARIABLE iWhereBufPos   AS INTEGER   NO-UNDO.
  
  {get QueryString cQueryString}.  
  {get QueryColumns cQueryColumns}.
  
  /* If the properties are blank we return immediately with blank */
  IF cQueryString = "":U OR cQueryColumns = "":U THEN 
    RETURN "":U.

  iNumEnt  = NUM-ENTRIES(pcColumn,".":U).
  
  /* If the column is qualified add the buffer part of it to the bufferlist
     which then will be the only entry in the list for the loop below */ 
  
  IF iNumEnt > 1 THEN
    ASSIGN
      cBufferList = {fnarg columnTable pcColumn}
      cColumn     = ENTRY(iNumEnt,pcColumn,".":U).
  
  ELSE DO:         
    cColumn = pcColumn.     
    {get Tables cBufferList}.    
  END.
  
  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):    
    ASSIGN
      cBuffer        = ENTRY(iBuffer,cBufferList)
      iBufPos        = LOOKUP(cBuffer,cQueryColumns,":":U)
      cQueryBufCols  = IF iBufPos > 0 
                       THEN ENTRY(iBufPos + 1,cQueryColumns,":":U) 
                       ELSE "":U
      iWhereBufPos   = INDEX(cQueryString + " ":U," ":U + cBuffer + " ":U)
      iPos           = INDEX(cQueryString,      " ":U + cBuffer + ",":U)
      iWhereBufPos   = (IF iWhereBufPos > 0 AND iPos > 0
                        THEN MIN(iPos,iWhereBufPos) 
                        ELSE MAX(iPos,iWhereBufPos))
                        + 1
      iColPos = 1.
      
    DO WHILE icolPos > 0:
      /* Add comma to cQueryBufCols to find first entry and search for ,column.*/
      iColPos = INDEX(",":U + cQueryBufCols,",":U + cColumn + ".":U,icolPos).
      IF iColpos > 0 THEN
      DO:
        ASSIGN
          iColPos    = iColPos + LENGTH(cColumn) + 1
          cString    = SUBSTR(cQueryBufCols,iColPos)
          cOperator  = ENTRY(1,cString)
          iValPos    = INT(ENTRY(2,cString))
          iValLength = INT(ENTRY(3,cString))
          cValue     = SUBSTR(cQueryString,iValPos + iWhereBufPos,iValLength)
          cSelection = cSelection 
          
                       + CHR(1)
                       + cOperator
                       + CHR(1)
                       + cValue.                       
      END.  /* if icolpos > 0 */
    END. /* do while icolpos > 0 */    
    IF cSelection <> "":U THEN LEAVE.
  END. /* do ibuffer = 1 to num-entries */      
  
  RETURN LEFT-TRIM(cSelection,CHR(1)). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns [dbname.]table of a database column.  
  Parameters:  pcColumn - Database fieldname.  
               Can be in the form of: DB.TBL.FLDNM, TBL.FLDNM or FLDNM.  
               (If not qualifed the FIRST ref in query will be used)
  Notes:     - Use to ensure and fix a column reference according to 
               the query's use of database qualification. 
               (See columnHandle for rules). 
             - Data.p overrides this for unqualified (RowObject) columns, but
               calls this for qualified fields.   
             - Is capable of processing a pcColumn specified with brackets.              
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE NO-UNDO.
  DEFINE VARIABLE lUseDbQual   AS LOGICAL   NO-UNDO.

 {get UseDbQualifier lUseDbQual}.

  hField = {fnarg columnHandle pccolumn}.       
  RETURN IF VALID-HANDLE(hField)
         THEN (IF lUseDbQual THEN hField:DBNAME + ".":U ELSE "":U) 
               + hField:TABLE 
         ELSE "":U.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  (pcColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Returns the validation message of a database column.  
  Parameters:  pcColumn - Database fieldname.  
               Can be in the form of: DB.TBL.FLDNM, TBL.FLDNM or FLDNM.  
               (If not qualifed the FIRST ref in query will be used)
  Notes:       Is capable of processing a pcColumn specified with brackets.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hField AS HANDLE NO-UNDO.
  
  hField = {fnarg columnHandle pccolumn}.       
  RETURN IF VALID-HANDLE(hField) THEN hField:VALIDATE-MESSAGE ELSE ?.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Formats into character strings (using the field format 
               specification) a row of values from the current row of the 
               database Query for the specified column list.

  Parameters:
    pcViewColList- comma-separated list of column names whose values are to be
                   returned.
  
  Notes:       Passes back a CHR(1)-separated list of formatted values preceded
               by the RowIdent code (a comma-separated list) as the first value 
               in all cases.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iTable     AS INTEGER   NO-UNDO.
  
  iColCount = NUM-ENTRIES(pcViewColList).
  {get QueryHandle hQuery}.
  hBuffer = hQuery:GET-BUFFER-HANDLE(1).
  
  IF hBuffer:AVAILABLE THEN 
  DO:
    /* First pass back a list of the buffer ROWIDs from the db rec(s);
       note that this always begins with a comma to indicate that there
       is no temp-table ROWID (since the temp-table is not being used. */
    DO iTable = 1 TO hQuery:NUM-BUFFERS:
      hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
      cColValues = cColValues + ",":U + STRING(hBuffer:ROWID).
    END.
    
    columnLoop:
    DO iCol = 1 TO iColCount:
      cColValues = cColValues + CHR(1).
      DO iTable = 1 TO hQuery:NUM-BUFFERS:  /* Search buffers until the column found. */
        hBuffer = hQuery:GET-BUFFER-HANDLE(iTable).
        hColumn = hBuffer:BUFFER-FIELD(ENTRY(iCol, pcViewColList)) NO-ERROR.
        IF VALID-HANDLE(hColumn) THEN
        DO:
          cColValues = cColValues + RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE)).
          NEXT columnLoop.
        END. /* END DO IF VALID-HANDLE */
      END.   /* END DO iTable          */
    END.     /* END DO iCol            */
    RETURN cColValues.       
  END.
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbColumnDataName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dbColumnDataName Procedure 
FUNCTION dbColumnDataName RETURNS CHARACTER
  (pcDbColumn AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:   Returns the RowObject fieldname of a database fieldname  
  Parameter: pcDbColumn - Qualified database fieldname (In the form of either
                          DB.TBL.FLDNM or TBL.FLDNM or FLDNM.)
  Notes:     
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cName               AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssignList         AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cDataColumnsByTable AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cAssign             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTables             AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cTable              AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iTable              AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cColumn             AS CHARACTER NO-UNDO.
   
   {get Tables cTables}.
   
   {get AssignList cAssignList}.
   IF NUM-ENTRIES(pcDbColumn, ".":U) = 1 THEN
   DO:
     /* comma-separated list of Rowobject columns delimited by CHR(1)
        corresponding to a Table.*/  
     {get DataColumnsByTable cDataColumnsByTable}.

     /* No Table qualifier so search all entries in AssignList. */
     DO iTable = 1 TO NUM-ENTRIES(cTables):
       ASSIGN
         cAssign = ENTRY(iTable, cAssignList, CHR(1)) /* Flds for 1 table */
         /* Check first to see if this column is in the Assign List, meaning 
            that it has been given a new name in the RowObject table. 
            FALSE = lookup second entry of pair which is the db field */
         cName   = mappedEntry (pcDbColumn, cAssign, FALSE).
       
       IF cName NE "":U THEN
         RETURN cName.
       
       /* If the column is in this table's part of DataColumnsByTable,
          and it isn't a RowObject column that is mapped to another dbfield
          the RowObject column name is the same as the database field name. */
       ELSE 
       IF CAN-DO(ENTRY(iTable, cDataColumnsByTable, CHR(1)),pcDbColumn)
       AND mappedEntry(pcDbColumn, cAssign, TRUE) = "":U   THEN
         RETURN pcDbColumn.

     END.  /* END DO iTable */ 
   END.    /* END DO IF NUM-ENTRIES = 1 */
   ELSE DO:
     ASSIGN
       cTable  = {fnarg columnTable pcDbColumn} /* ensures correct db qual*/
       iTable  = LOOKUP(cTable, cTables). /* Get the entry in AssignList */
     
     IF iTable NE 0 THEN                    /* sanity check */
     DO:    
       ASSIGN
         cColumn = ENTRY(NUM-ENTRIES(pcDbColumn, ".":U), pcDbColumn, ".":U)
         cName = mappedEntry
                   (cColumn,
                    ENTRY(iTable, cAssignList, CHR(1)),  /* Flds for 1 table */
                    FALSE /* lookup second entry of pair */).  
       IF cName NE "":U THEN
         RETURN cName. 
       ELSE 
         RETURN cColumn.
     END.  /* END DO IF itable NE 0 */
   END. /* else (pcDbColumn is qualified)  */

   RETURN "":U.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-excludeColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION excludeColumns Procedure 
FUNCTION excludeColumns RETURNS CHARACTER
  (iTable AS INTEGER) :   
/*-----------------------------------------------------------------------------
  Purpose: Returns a comma separated list of columns that should be used
           as the exclude parameter for BUFFER-COPY and BUFFER-COMPARE from
           the database.
Parameter: The number of the table in the query. 
    Notes: This protects the Target from being unintentionally overwritten 
           by unmapped not used columns with the same name, but are supposed 
           to be referencing a previously copyed or compared table or not at 
           all. We simply remove all the columns that represents the table 
           that we are copying comparing to from the chr(1) separated 
           DataColumnsByTable. 
           DataColumnsByTable stores calculated fields in the last entry, 
           so we always exclude those.  
           Used by refetchDbRow, transferDbRow and compareDbRow 
-----------------------------------------------------------------------------*/
  DEFINE VARIABLE cExclude AS CHAR   NO-UNDO.
    
  {get DataColumnsByTable cExclude}.
    
  /* Remove the columns from the iTable table from the excludelist */
  ENTRY(iTable,cExclude,CHR(1)) = "":U.
     
  RETURN TRIM(REPLACE(cExclude,CHR(1),",":U),",":U).      

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-firstBufferName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION firstBufferName Procedure 
FUNCTION firstBufferName RETURNS CHARACTER PRIVATE
  (pcExpression AS CHAR)  /* expression */ :
/*------------------------------------------------------------------------------
  Purpose:     Returns the first buffer reference in a where-clause expression.
  Parameters:
    pcExpression - a string expression
  Notes:       In order to be recognized as a buffer name, it must contain at
               least one ".", otherwise the return value is ?.
------------------------------------------------------------------------------*/
 DEF VAR i     AS INTEGER NO-UNDO.
 DEF VAR cWord AS CHAR NO-UNDO.
   
 IF NUM-ENTRIES(pcExpression,".") = 1 THEN RETURN ?.
 
 ASSIGN
  pcExpression = REPLACE(pcExpression,"(":U," ":U)
  pcExpression = REPLACE(pcExpression,"=":U," ":U).
  
 DO i = 1 TO num-entries(pcExpression," "): 
   cWord = ENTRY(i,pcExpression," ":U).
   
   IF NUM-ENTRIES(cWord,".":U) = 2 THEN 
      RETURN ENTRY(1,cWord,".":U). 
   
   IF NUM-ENTRIES(cWord,".":U) = 3 THEN
      RETURN ENTRY(1,cWord,".":U) + ".":U + ENTRY(2,cWord,".":U).     
 END.
 RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAssignList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAssignList Procedure 
FUNCTION getAssignList RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the list of updatable columns whose names have been 
              modified in the SmartDataObject.

  Parameters: <none>

  Notes:      This string is of the form:
              <RowObjectFieldName>,<DBFieldName>[,...][CHR(1)...]
              with a comma separated list of pairs of fields for each db table,
              and CHR(1) between the lists of pairs.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cList AS CHARACTER NO-UNDO.
  
  {get AssignList cList}.
  
  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCheckLastOnOpen Procedure 
FUNCTION getCheckLastOnOpen RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the flag indicating whether a get-last should be performed 
              on an open in order for fetchNext to be able to detect that we are 
              on the last row. This is necessary to make the QueryPosition 
              attribute reliable.   

  Parameters: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lCheck AS LOGICAL NO-UNDO.
  {get CheckLastOnOpen lCheck}.
  RETURN lCheck.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataColumns Procedure 
FUNCTION getDataColumns RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-delimited list of the columnNames for the 
               SmartDataObject. 
  Parameters:  
       Notes:  Uses the DataColumsByTable property that stores in different 
               tables delimited by CHR(1) instead of comma in order to identify 
               which columns are from which table in the event of a join. 
               For example, if the query is a join of customer and order and 
               the Name field from customer and the OrderNum and OrderData field 
               from Order are selected, then the property value will be equal to
               "Name<CHR(1)>OrderNum,OrderDate".
               This function replaces CHR(1) with "," to return just a 
               comma-delimited list. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER NO-UNDO.
  {get DataColumnsByTable cColumns}.
    
  IF NUM-ENTRIES(cColumns,CHR(1)) > 1 THEN
    cColumns = REPLACE(cColumns,CHR(1),",":U).

  /* There might be empty entries */
  DO WHILE INDEX(cColumns,",,":U) > 0:
    cColumns = REPLACE(cColumns,",,":U,",":U).
  END.
  
  /* There's may also be commas at the ends */ 
  RETURN TRIM(cColumns,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTarget Procedure 
FUNCTION getDataTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of query object's data target as a
               CHARACTER string.

  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get DataTarget cTarget}.
  RETURN cTarget. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTargetEvents Procedure 
FUNCTION getDataTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the list of events (comma delimited) this query object 
               subscribes to in its Data Target.

  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.

  {get DataTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignFields Procedure 
FUNCTION getForeignFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the property which holds the mapping of field's in 
               another DataSource to fields in this SMartDataObject's RowObject 
               temp-table, to open a dependent query.
  
  Parameters:  <none>
  
  Notes:       The property format is a comma-separated list, consisting of the
               first local db fieldname, followed by the matching source 
               temp-table field name, followed by more pairs if there is more 
               than one field to match.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.
  {get ForeignFields cFields}.
  RETURN cFields.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getForeignValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getForeignValues Procedure 
FUNCTION getForeignValues RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the values of the most recently received ForeignField
               values received by dataAvailable.  The values are character
               strings formatted according to the field format specification and
               they are separated by the CHR(1) character.

  Parameters:  <none>
  
  Notes:
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cValues AS CHARACTER NO-UNDO.
  {get ForeignValues cValues}.
  RETURN cValues.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSource Procedure 
FUNCTION getNavigationSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the query object's Navigation source.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get NavigationSource hSource}.
  RETURN hSource. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNavigationSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNavigationSourceEvents Procedure 
FUNCTION getNavigationSourceEvents RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-separated list of the events this object 
               needs to subscribe to in its NavigationSource.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get NavigationSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenOnInit Procedure 
FUNCTION getOpenOnInit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns TRUE if the query should be opened automatically when 
              the object is initialized.

  Parameters: <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lOpen AS LOGICAL NO-UNDO.
  {get OpenOnInit lOpen}.
  RETURN lOpen.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the OPEN-QUERY preprocessor value, to allow it to be
              manipulated by setQueryWhere, for example

  Parameters: <none>
  
  Notes:      This is important because no matter how the query is dynamically
              modified, it can be reset to its original state using this return
              value in a QUERY-PREPARE method.
            - getOpenQuery is called from the client on AppServer, so we are not
              using the xp preprocessor.
------------------------------------------------------------------------------*/
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('OpenQuery':U).

  RETURN ghProp:BUFFER-VALUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryHandle Procedure 
FUNCTION getQueryHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the handle of the database query.

  Parameters: <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  {get QueryHandle hQuery}.
  RETURN hQuery.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryOpen Procedure 
FUNCTION getQueryOpen RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the Query Object's database query is currently 
               open.

  Parameters:  <none>
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  
  {get QueryHandle hQuery}.
  RETURN hQuery:IS-OPEN.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryPosition Procedure 
FUNCTION getQueryPosition RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the QueryPosition property.

  Parameters:  <none>
  
  Notes:       Valid return values are:
                 FirstRecord, LastRecord, NotFirstOrLast or NoRecordAvailable
------------------------------------------------------------------------------*/

  /* The property does not have a field preprocessor to prevent it from being
     "set" directly, because it must also publish an event. So the code below
     must not use the {get} syntax. */

  DEFINE VARIABLE cPosition AS CHARACTER NO-UNDO.
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('QueryPosition':U)
         cPosition = ghProp:BUFFER-VALUE.
  RETURN cPosition.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQuerySort Procedure 
FUNCTION getQuerySort RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the sort phrase.   
    Notes: If a query is under work in the QueryString property this will 
           return this BY-phrase, otherwise it will return the BY-phrase in the 
           current or design query. 
           This should make this property safe to use in qbf objects that 
           may or may not have done query manipulation and may or may not 
           have opened the query. 
           It can also be used to retrieve the BY phrase before a setQueryWhere 
           (which overrides setQuerySort) and reset it after. 
           Does NOT return the first BY keyword.      
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryText AS CHAR NO-UNDO.
  DEFINE VARIABLE iByPos     AS INT  NO-UNDO.
  
  /* If a query is under work, use that. */  
  {get QueryString cQueryText}.  

  /* If not use the actual query */ 
  IF cQueryText = "":U THEN 
    {get QueryWhere cQueryText}.
  
  /* If not found so far use the designed query */ 
  IF cQueryText = "":U THEN 
    {get OpenQuery cQueryText}.
  
  /* Any BY ? */ 
  iByPos = INDEX(cQueryText," BY ":U) + 3.

  RETURN IF iByPos <> 0  /* trim away blanks and period */
         THEN TRIM(SUBSTR(cQueryText,iByPos)," .":U) 
         ELSE "":U.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryString Procedure 
FUNCTION getQueryString RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the QueryString attribute used as working storage for 
               all query manipulation methods.
  Parameters:  <none>
  Notes:     - The method will always return a whereclause 
               If the QueryString property has not been set it will use 
               the current where clause - QueryWhere.
               If there's no current use the design where clause - OpenQuery. 
             - The openQuery will call prepareQuery with this property.     
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  {get QueryString cQueryString}.
  RETURN cQueryString. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryWhere Procedure 
FUNCTION getQueryWhere RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the current where-clause for the database query.
               Returns ? if the query handle is undefined.

  Parameters:  <none>
------------------------------------------------------------------------------*/    
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  {get QueryHandle hQuery}.
  
  RETURN IF VALID-HANDLE(hQuery) 
         THEN hQuery:PREPARE-STRING
         ELSE ?.  
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
   Purpose:  Returns a comma delimited list of tables in the Query Objects
Parameters:  <none>
     Notes: Qualifed with database name if the query is defined with dbname.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTableList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iTbl         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lUseDbQual   AS LOGICAL   NO-UNDO.
  
  {get QueryHandle hQuery}.
  {get UseDbQualifier lUseDbQual}.

  DO iTbl = 1 TO hQuery:NUM-BUFFERS:
    hBuffer = hQuery:GET-BUFFER-HANDLE(iTbl).
   
    IF iTbl > 1 THEN cTableList = cTableList + ",":U.
    cTableList = cTableList 
                 + (IF lUseDbQual THEN hBuffer:DBNAME + ".":U ELSE "":U) 
                 +  hBuffer:TABLE.
  END.
  RETURN cTableList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdatableColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdatableColumns Procedure 
FUNCTION getUpdatableColumns RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma delimited list of the Updatable Columns for this
               SmartDataObject.
  Parameters:  <none>
  Notes:       Uses the UpdatableColumnsByTable property which stores the
               the columns in different tables delimited by CHR(1) instead of 
               comma in order to identify which columns are from which table 
               in the event of a join. For example, if the query is a join of 
               customer and order and the Name field from customer and the
               OrderNum and OrderData field from Order are Updatable, then the 
               property value will be equal to "Name<CHR(1)>OrderNum,OrderDate".
               This function replaces CHR(1) with "," to return just a 
               comma-delimited list. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColumns AS CHARACTER NO-UNDO.
  {get UpdatableColumnsByTable cColumns}.
  
  IF NUM-ENTRIES(cColumns,CHR(1)) > 1 THEN
    cColumns = REPLACE(cColumns,CHR(1),",":U).

  /* There might be empty entries */
  DO WHILE INDEX(cColumns,",,":U) > 0:
    cColumns = REPLACE(cColumns,",,":U,",":U).
  END.
  
  /* There's may also be commas at the ends  */ 
  RETURN TRIM(cColumns,",":U).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUseDbQualifier) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseDbQualifier Procedure 
FUNCTION getUseDbQualifier RETURNS LOGICAL
 (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return true if table references are qualified with db. 
    Notes: 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  
  {get QueryHandle hQuery}.
  
  {get QueryWhere cQueryString}. 
  
  IF cQueryString = "":U OR cQueryString = ? THEN
    {get OpenQuery cQueryString}.       
  
  RETURN NUM-ENTRIES(whereClauseBuffer(cQueryString),".":U) > 1.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return a comma separated list of word indexed fields 
    Notes: Qualified with database and table name.
           We return database name from dynamic methods as all column* 
           methods are able to respond to that.
           This dbname is returned also if qualify with db name is false.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.
  DEFINE VARIABLE hBuff  AS HANDLE NO-UNDO.
  DEFINE VARIABLE iBuff  AS INT    NO-UNDO.
  DEFINE VARIABLE iIdx   AS INT    NO-UNDO.
  DEFINE VARIABLE cInfo  AS CHAR   NO-UNDO.
  DEFINE VARIABLE cList  AS CHAR   NO-UNDO.

  {get QueryHandle hQuery}.
  IF VALID-HANDLE(hQuery)THEN 
  DO iBuff = 1 TO hQuery:NUM-BUFFERS:
    ASSIGN
      hBuff = hQuery:GET-BUFFER-HANDLE(iBuff)
      iIdx  = 0.
    DO WHILE TRUE:
      ASSIGN
        iIdx  = iIdx + 1
        cInfo = hBuff:INDEX-INFORMATION(iIdx).
      IF cInfo = ? THEN LEAVE.
      
      IF ENTRY(4,cInfo) = "1":U THEN
         cList = cList 
                 + (IF cList = "":U THEN "":U ELSE ",":U)
                 + hBuff:DBNAME + ".":U + hBuff:NAME + ".":U + ENTRY(5,cInfo).

    END. /* do while true */
  END. /* do ibuff = 1 to num-buffers */
  RETURN cList.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertExpression) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION insertExpression Procedure 
FUNCTION insertExpression RETURNS CHARACTER PRIVATE
  (pcWhere      AS CHAR,   
   pcExpression AS CHAR,     
   pcAndOr      AS CHAR):                         
/*------------------------------------------------------------------------------
 Purpose:     Inserts an expression into ONE buffer's where-clause.
 Parameters:  
      pcWhere      - Complete where clause with or without the FOR keyword,
                     but without any comma before or after.
      pcExpression - New expression OR OF phrase (Existing OF phrase is replaced)
      pcAndOr      - Specifies what operator is used to add the new expression 
                     to existing ones.
                     - AND (default) 
                     - OR         
 Notes:       The new expression is embedded in parenthesis, but no parentheses
              are placed around the existing one.  
              Lock keywords must be unabbreviated or without -lock (i.e. SHARE
              or EXCLUSIVE.)   
              Any keyword in comments may cause problems.
              This is PRIVATE to query.p.   
------------------------------------------------------------------------------*/  
  DEFINE VARIABLE cTable        AS CHAR NO-UNDO.  
  DEFINE VARIABLE cRelTable     AS CHAR NO-UNDO.  
  DEFINE VARIABLE cJoinTable    AS CHAR NO-UNDO.  
  DEFINE VARIABLE cWhereOrAnd   AS CHAR NO-UNDO.  
  DEFINE VARIABLE iTblPos       AS INT  NO-UNDO.
  DEFINE VARIABLE iWherePos     AS INT  NO-UNDO.
  DEFINE VARIABLE lWhere        AS LOG  NO-UNDO.
  DEFINE VARIABLE iOfPos        AS INT  NO-UNDO.
  DEFINE VARIABLE iRelTblPos    AS INT  NO-UNDO.  
  DEFINE VARIABLE iInsertPos    AS INT  NO-UNDO.    
  
  DEFINE VARIABLE iUseIdxPos    AS INT  NO-UNDO.        
  DEFINE VARIABLE iOuterPos     AS INT  NO-UNDO.        
  DEFINE VARIABLE iLockPos      AS INT  NO-UNDO.      
  
  DEFINE VARIABLE iByPos        AS INT  NO-UNDO.        
  DEFINE VARIABLE iIdxRePos     AS INT  NO-UNDO.        
           
  ASSIGN 
    cTable        = whereClauseBuffer(pcWhere)
    iTblPos       = INDEX(pcWhere,cTable) + LENGTH(cTable,"CHARACTER":U)
    
    iWherePos     = INDEX(pcWhere," WHERE ":U) + 6    
    iByPos        = INDEX(pcWhere," BY ":U)    
    iUseIdxPos    = INDEX(pcWhere," USE-INDEX ":U)    
    iIdxRePos     = INDEX(pcWhere + " ":U," INDEXED-REPOSITION ":U)    
    iOuterPos     = INDEX(pcWhere + " ":U," OUTER-JOIN ":U)     
    iLockPos      = MAX(INDEX(pcWhere + " ":U," NO-LOCK ":U),
                        INDEX(pcWhere + " ":U," SHARE-LOCK ":U),
                        INDEX(pcWhere + " ":U," EXCLUSIVE-LOCK ":U),
                        INDEX(pcWhere + " ":U," SHARE ":U),
                        INDEX(pcWhere + " ":U," EXCLUSIVE ":U)
                        )    
    iInsertPos    = LENGTH(pcWhere) + 1 
                    /* We must insert before the leftmoust keyword,
                       unless the keyword is Before the WHERE keyword */ 
    iInsertPos    = MIN(
                      (IF iLockPos   > iWherePos THEN iLockPos   ELSE iInsertPos),
                      (IF iOuterPos  > iWherePos THEN iOuterPos  ELSE iInsertPos),
                      (IF iUseIdxPos > iWherePos THEN iUseIdxPos ELSE iInsertPos),
                      (IF iIdxRePos  > iWherePos THEN iIdxRePos  ELSE iInsertPos),
                      (IF iByPos     > iWherePos THEN iByPos     ELSE iInsertPos)
                       )                                                        
    lWhere        = INDEX(pcWhere," WHERE ":U) > 0 
    cWhereOrAnd   = (IF NOT lWhere          THEN " WHERE ":U 
                     ELSE IF pcAndOr = "":U OR pcAndOr = ? THEN " AND ":U 
                     ELSE " ":U + pcAndOr + " ":U) 
    iOfPos        = INDEX(pcWhere," OF ":U).
  
  IF LEFT-TRIM(pcExpression) BEGINS "OF ":U THEN 
  DO:   
    /* If there is an OF in both the join and existing query we replace the 
       table unless they are the same */      
    IF iOfPos > 0 THEN 
    DO:
      ASSIGN
        /* Find the table in the old join */               
        cRelTable  = ENTRY(1,LEFT-TRIM(SUBSTRING(pcWhere,iOfPos + 4))," ":U)      
        /* Find the table in the new join */       
        cJoinTable = SUBSTRING(LEFT-TRIM(pcExpression),3).
      
      IF cJoinTable <> cRelTable THEN
        ASSIGN 
         iRelTblPos = INDEX(pcWhere + " ":U," ":U + cRelTable + " ":U) 
                      + 1                            
         SUBSTRING(pcWhere,iRelTblPos,LENGTH(cRelTable)) = cJointable. 
    END. /* if iOfPos > 0 */ 
    ELSE 
      SUBSTRING(pcWhere,iTblPos,0) = " ":U + pcExpression.                                                                
  END. /* if left-trim(pcExpression) BEGINS "OF ":U */
  ELSE             
    SUBSTRING(pcWhere,iInsertPos,0) = cWhereOrAnd 
                                      + "(":U 
                                      + pcExpression 
                                      + ")":U. 
                                            
  RETURN RIGHT-TRIM(pcWhere).
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-mappedEntry) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION mappedEntry Procedure 
FUNCTION mappedEntry RETURNS CHARACTER PRIVATE
  (pcEntry AS CHAR,
   pcList  AS CHAR,
   plFirst AS LOG) :
/*------------------------------------------------------------------------------
  Purpose: Return the 'other' entry in a comma separated list of paired entries.
           This function's purpose is to avoid potential errors which 
           may occur if a simple lookup finds the wrong part of the pair.     
Parameters:  INPUT pcEntry  - entry to lookup.  
             INPUT pcList   - comma separated list with paired entries. 
             INPUT plFirst  - TRUE  - lookup first and return second.
                              FALSE - lookup second and return first.
    Notes: PRIVATE 
          - Used to find mapped RowObject or database column in assignList.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iLookUp AS INT  NO-UNDO.
  DEFINE VARIABLE cList   AS CHAR NO-UNDO.

  /* We use a work list because we remove the wrong entries */
  cList = pcList.
  DO WHILE TRUE:
    iLookup = LOOKUP(pcEntry,cList).
    IF iLookup = 0 OR iLookup = ? THEN 
      RETURN "":U.

    /* if the right part of the pair return the other part 
       from the original list */
    IF iLookup MODULO 2 = (IF plFirst THEN 1 ELSE 0) THEN
      RETURN ENTRY(IF plFirst THEN (iLookup + 1) ELSE (iLookup - 1),pcList).
    
    /* Remove this entry from the work list because it's not the right
       half of the pair */ 
    ENTRY(iLookup,cList) = "":U.   
  END. /* do while true */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newWhereClause) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newWhereClause Procedure 
FUNCTION newWhereClause RETURNS CHARACTER PRIVATE
  (pcBuffer     AS CHAR,   
   pcExpression AS char,  
   pcWhere      AS CHAR,
   pcAndOr      AS CHAR):
/*------------------------------------------------------------------------------
  Purpose:     Inserts a new expression to query's prepare string for a specified 
               buffer.
  Parameters:  pcBuffer     - Which buffer.
               pcExpression - The new expression. 
               pcWhere      - The current query prepare string.
               pcAndOr      - Specifies what operator is used to add the new
                              expression to existing expression(s)
                              - AND (default) 
                              - OR                                                
  Notes:       PRIVATE to query.p             
------------------------------------------------------------------------------*/
 DEFINE VARIABLE iComma      AS INT    NO-UNDO. 
 DEFINE VARIABLE iCount      AS INT    NO-UNDO.
 DEFINE VARIABLE iStart      AS INT    NO-UNDO.
 DEFINE VARIABLE iLength     AS INT    NO-UNDO.
 DEFINE VARIABLE iEnd        AS INT    NO-UNDO.
 DEFINE VARIABLE cWhere      AS CHAR   NO-UNDO.
 DEFINE VARIABLE cString     AS CHAR   NO-UNDO.
 DEFINE VARIABLE cFoundWhere AS CHAR   NO-UNDO.
 DEFINE VARIABLE cNextWhere  AS CHAR   NO-UNDO.
 DEFINE VARIABLE hQuery      AS HANDLE NO-UNDO.

 ASSIGN
   cString = pcWhere
   iStart  = 1.          

 DO WHILE TRUE:
   
   iComma  = INDEX(cString,","). 
   
   /* If a comma was found we split the string into cFoundWhere and cNextwhere */  
   IF iComma <> 0 THEN 
     ASSIGN
       cFoundWhere = cFoundWhere + SUBSTR(cString,1,iComma)
       cNextWhere  = SUBSTR(cString,iComma + 1)     
       iCount      = iCount + iComma.       
   ELSE 
     
     /* cFoundWhere is blank if this is the first time or if we have moved on 
        to the next buffers where clause
        If cFoundwhere is not blank the last comma that was used to split 
        the string into cFoundwhere and cNextwhere was not a join, 
        so we must set them together again.   
     */     
     cFoundWhere = IF cFoundWhere = "":U 
                   THEN cString
                   ELSE cFoundWhere + cNextwhere.
          
   /* We have a complete table whereclause if there are no more commas
      or the next whereclause starts with each,first or last */    
   IF iComma = 0 
   OR CAN-DO("EACH,FIRST,LAST":U,ENTRY(1,TRIM(cNextWhere)," ":U)) THEN
   DO:
     /* Remove comma or period before inserting the new expression */
     ASSIGN
       cFoundWhere = RIGHT-TRIM(cFoundWhere,",.":U) 
       iLength     = LENGTH(cFoundWhere).
     
     IF whereClauseBuffer(cFoundWhere) = pcBuffer  THEN
     DO:   
       SUBSTR(pcWhere,iStart,iLength) = insertExpression(cFoundWhere,
                                                         pcExpression,
                                                         pcAndOr).           
       LEAVE.
     END.
     ELSE
       /* We're moving on to the next whereclause so reset cFoundwhere */ 
       ASSIGN      
         cFoundWhere = "":U                     
         iStart      = iCount + 1.      
     
     /* No table found and we are at the end so we need to get out of here */  
     IF iComma = 0 THEN 
     DO:
       /* (Buffer is not in query) Is this a run time error ? */.
       LEAVE.    
     END.
   END. /* if iComma = 0 or can-do(EACH,FIRST,LAST */
   cString = cNextWhere.  
 END. /* do while true. */
 RETURN pcWhere.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:    General logic for opening the database query either for a 
              SmartDataObject or for another query object.
  Parameters: <none>
  Notes:      The getQueryString will either return the actual property if any
              query manipulation methods has been used. 
              Otherwise it will return the current or design-time query.               assignQuerySelection and setQuerySort methods will be used (if 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lCheckLast   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lError       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hBuffer      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRow         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReturn      AS LOG    NO-UNDO.

  {get QueryHandle hQuery}.
  hQuery:QUERY-CLOSE().

  /* Is there an unprepared query string? */ 
  {get QueryString cQueryString}. 
  
  IF cQueryString <> "":U THEN    
    lError = NOT {fnarg prepareQuery cQueryString}.
  
  IF lError OR NOT hQuery:QUERY-OPEN() THEN 
    lReturn = FALSE. /* NOTE: WHEN would this fail? error? */
  
  ELSE DO:
     /* CheckLastOnOpen specifies that LastDbRowIdent should be set.
        This Property will be checked against the current records Rowident
        in fetch* procedures in order to set the QueryPosition correctly. 
        Otherwise the QueryPosition will be set to 'LastRecord' to late;
        the SECOND time its been read */

     {get CheckLastOnOpen lCheckLast}.     
     IF lCheckLast THEN 
     DO:
       hQuery:GET-LAST.
       DO iCnt = 1 TO hQuery:NUM-BUFFERS:  /* Assemble the list of rowids */
         ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
                cRow   = cRow + 
                    (IF cRow NE "":U THEN ",":U ELSE "":U)
                      + STRING(hBuffer:ROWID).      
         {set LastDbRowIdent cRow}.         
       END.
     END. 
     ELSE 
       {set LastDbRowIdent cRow}. /* blank*/ 
     
     RUN fetchFirst IN TARGET-PROCEDURE. 
      
     lReturn = TRUE.  
  END.   /* END DO IF QUERY-OPEN */                       
  
  /* Some visual objects that shows more than one record may need to know 
     that the query changed, this cannot be detected through the ordinary
     publish "dataAvailable" from hte navigation methods. 
     The SmartSelect populates its list on this event and OCX objects
     like lists and Tree-views may also need to subscribe to this event. */
  PUBLISH "queryOpened":U FROM TARGET-PROCEDURE.
  
  RETURN lReturn.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
     Purpose: Prepare the database query either for a SmartDataObject or 
              for another query object.              
  Parameters: pcQuery  - Complete query expression 
       Notes: The main purpose for this is to be able to do this on an 
              AppServer.
              Intended for INTERNAL use only!  
              The developer has two alternative ways to use this: 
              1: addQueryWhere, assignQuerywhere manipulates a clinet side
                 property that openQuery will check and use as input to this 
                 method.                
              2: setQueryWhere will call this method and blank properties 
                 used by 1 in order to make openQuery NOT call this.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery AS HANDLE NO-UNDO.         
  {get QueryHandle hQuery}.
  RETURN hQuery:QUERY-PREPARE(pcQuery).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION removeQuerySelection Procedure 
FUNCTION removeQuerySelection RETURNS LOGICAL
  (pcColumns   AS CHARACTER,
   pcOperators AS CHARACTER):
/*------------------------------------------------------------------------------
  Purpose:     Remove field expression(s) for specified column(s) and operator(s) 
               added by assignQuerySelection from the query. 
  Parameters: 
     pcColumns   - Column names (Comma separated)                    
                   Fieldname of a table in the query in the form of 
                   TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db is specified),
                   (RowObject.FLDNM should be used for SDO's)  
                   If the fieldname isn't qualified it checks the tables in 
                   the TABLES property and assumes the first with a match.              
     pcOperators - Operator - one for all columns
                              - blank - defaults to (EQ)  
                              - Use slash to define alternative string operator
                                EQ/BEGINS etc..
                            - comma separated for each column/value

  Notes:       This procedure modifies the QueryString property and is designed 
               to run on the client and called several times before QueryString
               is used in a QUERY-PREPARE method to modify the database query.
               
               openQuery will prepare the query using the QueryString property.
               
               The removal of the actual field expression is done by the help 
               of the position and length stored in the QueryColumns property. 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBufferList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
  
  /* We need the columns name and the parts */  
  DEFINE VARIABLE cColumn        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColumnName    AS CHARACTER NO-UNDO.
    
  DEFINE VARIABLE iBuffer        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColumn        AS INTEGER   NO-UNDO.
  
  DEFINE VARIABLE cUsedNums      AS CHAR      NO-UNDO.
  
  DEFINE VARIABLE cOperator      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cStringOp      AS CHARACTER NO-UNDO.
          
  /* Used to store and maintain offset and length */    
  DEFINE VARIABLE iValLength     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPos           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iDiff          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cQueryColumns  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryBufCols  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cNewCols       AS CHAR      NO-UNDO.
  DEFINE VARIABLE cQueryColOp    AS CHAR      NO-UNDO.
  DEFINE VARIABLE cRemoveList    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iOldEntries    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLowestChanged AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iBufPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColPos        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iWhereBufPos   AS INTEGER   NO-UNDO.

  DEFINE VARIABLE cQuerySplit1   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQuerySplit2   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iNumWords      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cWord          AS CHARACTER NO-UNDO.

  {get Tables cBufferList}.    
  {get QueryString cQueryString}.
  {get QueryColumns cQueryColumns}.
    
  /* If no QueryString or QueryColumns just return now */ 
  IF cQueryString = "":U OR cQueryColumns = "":U THEN
    RETURN FALSE.
  
  DO iBuffer = 1 TO NUM-ENTRIES(cBufferList):
    ASSIGN
      cBuffer        = ENTRY(iBuffer,cBufferList)
      iBufPos        = LOOKUP(cBuffer,cQueryColumns,":":U)
      cQueryBufCols  = IF iBufPos > 0 
                       THEN ENTRY(iBufPos + 1,cQueryColumns,":":U) 
                       ELSE "":U
      iOldEntries    = NUM-ENTRIES(cQueryBufCols) / 3    
      cRemoveList    = "":U
      iLowestChanged = 0.
    
    ColumnLoop:    
    DO iColumn = 1 TO NUM-ENTRIES(pcColumns):
      IF CAN-DO(cUsedNums,STRING(iColumn)) THEN 
        NEXT ColumnLoop.      
      
      ASSIGN
        cColumn     = ENTRY(iColumn,pcColumns).
      
      /* Get the operator for this valuelist. 
         Make sure we handle '',? and '/begins' as default */                                                  
        cOperator   = IF pcOperators = "":U 
                      OR pcOperators BEGINS "/":U 
                      OR pcOperators = ?                       
                      THEN "=":U 
                      ELSE IF NUM-ENTRIES(pcOperators) = 1 
                           THEN ENTRY(1,pcOperators,"/":U)                                                 
                           ELSE ENTRY(iColumn,pcOperators).
        
         
      /* Convert rowObject reference to db reference */
      IF cColumn BEGINS "RowObject" + "." THEN        
        cColumn =  DYNAMIC-FUNCTION("columnDBColumn":U IN TARGET-PROCEDURE,
                                    ENTRY(2,cColumn,".":U)) NO-ERROR.                                      
      
      /* Unqualified fields will use the first buffer that has a match
         because the columnDataType below searches all buffers in the query */           
      ELSE IF INDEX(cColumn,".":U) = 0 THEN       
        cColumn = cBuffer + ".":U + cColumn.  
     
      /* Wrong buffer */
      IF NOT (cColumn BEGINS cBuffer + ".":U) THEN 
      DO: 
        /* If the column db qualification does not match the query's we do 
           an additionl check to see if it is the correct table after all */                                
        IF NUM-ENTRIES(cColumn,".":U) - NUM-ENTRIES(cBuffer,".":U) <> 1 THEN
        DO:
          IF {fnarg columnTable cColumn} <> cBuffer THEN 
            NEXT ColumnLoop.  
        END.
        ELSE
          NEXT ColumnLoop.
      END.

      cColumnName = ENTRY(NUM-ENTRIES(cColumn,".":U),cColumn,".":U).
      
        
      cQueryColOp = cOperator.
      
      cQueryColOp = TRIM(     IF cQueryColOp = "GE":U THEN ">=":U
                             ELSE IF cQueryColOp = "LE":U THEN "<=":U
                             ELSE IF cQueryColOp = "LT":U THEN "<":U
                             ELSE IF cQueryColOp = "GT":U THEN ">":U
                             ELSE IF cQueryColOp = "EQ":U THEN "=":U
                             ELSE    cQueryColOp).
      
      cStringOp   = IF NUM-ENTRIES(pcOperators) = 1 
                    AND NUM-ENTRIES(pcOperators,"/":U) = 2  
                    THEN ENTRY(2,pcOperators,"/":U)
                    ELSE "":U.                                                 
      
      /* First check if this was a string with stringoperator */  
      IF cStringOp <> "":U THEN  
        iPos        = LOOKUP(cColumnName + ".":U + cStringOp,cQueryBufCols).
      ELSE iPos = 0.
      
      IF iPos = 0 THEN
        iPos        = LOOKUP(cColumnName + ".":U + cQueryColOp,cQueryBufCols).
      
    
        /* If the column + operator was found in the list
           we build a list of the columns to remove from the QueryString further 
           down.
           We also build a list of the numbers to remove. */         
      IF iPos > 0 THEN
      DO:        
        ASSIGN
            iLowestChanged = MIN(iPos,IF iLowestChanged = 0 
                                      THEN iPos 
                                      ELSE iLowestChanged)
            cRemoveList   = cRemoveList 
                            + (IF cRemoveList = "":U THEN "":U ELSE ",":U)
                            + STRING(INT((iPos - 1) / 3 + 1))     
             cUsedNums     = cUsedNums
                            + (IF cUsedNums = "":U THEN "":U ELSE ",":U)
                            + STRING(iColumn). 
     
      END. /* IF ipos > 0 */           
    END. /* do icolumn = 1 to  */ 
    
    /* Get the buffers position in the where clause (always the
       first entry in a dynamic query because there's no 'of <external>')*/ 
    ASSIGN
      iWhereBufPos = INDEX(cQueryString + " "," ":U + cBuffer + " ":U)
      iPos         = INDEX(cQueryString,      " ":U + cBuffer + ",":U)
      iWhereBufPos = (IF iWhereBufPos > 0 AND iPos > 0
                      THEN MIN(iPos,iWhereBufPos) 
                      ELSE MAX(iPos,iWhereBufPos))
                      + 1
      iDiff        = 0
      cNewCols     = "":U.                          

    IF iLowestChanged > 0 THEN 
    DO iColumn = 1 TO NUM-ENTRIES(cQueryBufCols) - 2 BY 3:       
      
      ASSIGN
        iValPos      = INT(ENTRY(iColumn + 1,cQueryBufCols))
        iValLength   = INT(ENTRY(iColumn + 2,cQueryBufCols))
        iValPos      = iValPos - iDiff.
      
      /* Remove value, operator, columnname and eventual AND in the
         parenthesized expression. If it's the last expression in the parenthesis
         we also remove it and any AND/OR after or WHERE/AND/OR before. */
           
      IF CAN-DO(cRemoveList,STRING(INT((iColumn - 1) / 3 + 1))) THEN       
      DO:
         ASSIGN 
          /*Split query in two, remove value quotes and blanks */
          cQuerySplit1 = 
     RIGHT-TRIM(SUBSTR(cQueryString,1,iValPos + iWhereBufPos - 1)," '~"":U) 
          cQuerySplit2 =
     LEFT-TRIM(SUBSTR(cQueryString,iValPos + iWhereBufPos + iVallength)," '~"":U) 

          /* Count words in left part */
          iNumWords   = NUM-ENTRIES(cQuerySplit1," ":U)
         
          /* Remove Operator */ 
          ENTRY(iNumWords,cQuerySplit1," ":U) = "":U
           
          cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U)
          
          /* find columnname */
          cWord       = ENTRY(iNumWords - 1,cQuerySplit1," ":U).
             
         /* if columnname has parenthesis this is the beginning of an exp */
         IF cWord BEGINS "(":U THEN
         DO:
           /* We are removing the first column/value pair in the parenthesis*/
           IF cQuerySplit2 BEGINS "AND":U THEN
           DO:
             /* Remove the previous word (columnname), but keep parenthesis */
             ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "(":U.
             
             /* Remove AND in right part */
             ENTRY(1,cQuerySplit2," ":U) = "":U.
             cQuerySplit2 = LEFT-TRIM(cQuerySplit2," ":U).
           END.  /* if cquerysplit2 begins and */
           ELSE IF cQuerySplit2 BEGINS ") ":U THEN
           DO:
             /* Remove columnname and parenthesises around the expression */
             ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "":U.
             cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U).
             cQuerySplit2 = LEFT-TRIM(SUBSTR(cQuerySplit2,2)," ":U).
             
             cWord = ENTRY(iNumWords - 2,cQuerySplit1," ":U).
             
             /* Now remove AND or OR used to join an eventual expression */ 
             IF cQuerySplit2 BEGINS "AND ":U OR cQuerySplit2 BEGINS "OR ":U THEN
               ENTRY(1,cQuerySplit2," ":U) = "":U.
             
             /* There were no and after, so remove WHERE,AND or OR before */  
             ELSE IF CAN-DO("WHERE,AND,OR":U,cWord) THEN
               ENTRY(iNumWords - 2,cQuerySplit1," ":U) = "":U.                                  
             
             /* No where/and/or or and/or removed so add a blank before we join
                the splitted query  */
             ELSE cQuerySplit2 = " ":U + cQuerySplit2.
           
           END.             
         END. /* word begins '(' */ 
         ELSE 
         DO: 
           /* Now remove the prev word (columnname) */
           ENTRY(iNumWords - 1,cQuerySplit1," ":U) = "":U.
           
           /* Remove blanks in order to find the prev word */
           cQuerySplit1 = RIGHT-TRIM(cQuerySplit1," ":U).
           
           /* Now remove AND */
           ENTRY(iNumWords - 2,cQuerySplit1," ":U) = "":U.          
           
           /* If we removed the last column/value pair,
              we leave no space between the parenthesis */
           IF cQuerySplit2 BEGINS ")":U THEN 
             cQuerySplit1 = RIGHT-TRIM(cQuerySplit1).  
         END.  
         /* Keep track of shrinkage */          
         iDiff = iDiff + (LENGTH(cQueryString) 
                           - LENGTH(cQuerySplit1 + cQuerySplit2)).   
         
         cQueryString = cQuerySplit1 + cQuerySplit2.  
      END. /* if can-do(cRemoveList,... */       
      
      ELSE  /* not removed, store the position adjusted for shrinkage  */
        cNewCols = cNewCols 
                   + (IF cNewCols = "":U THEN "":U ELSE ",":U)
                   + ENTRY(icolumn,cQueryBufCols)
                   + ",":U
                   + STRING(iValPos)
                   + ",":U
                   + (ENTRY(iColumn + 2,cQueryBufCols)).
    
    END. /* else if ilowestchanged do icolumn = ilowestChanged to num-entries */  
    
    IF cNewCols <> "" THEN 
    DO:
      ENTRY(iBufPos + 1,cQueryColumns,":":U) = cNewCols.        
    END.
    ELSE IF iLowestChanged > 0 THEN
      ASSIGN
        ENTRY(iBufPos,cQueryColumns,":":U) = "":U
        ENTRY(iBufPos + 1,cQueryColumns,":":U) = "":U
        cQueryColumns = TRIM(REPLACE(cQueryColumns,":::":U,":":U),":":U).
  END.  
  {set QueryColumns cQueryColumns}.
  {set QueryString cQueryString}.
  
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowidWhere Procedure 
FUNCTION rowidWhere RETURNS CHARACTER
  ( pcWhere AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Returns the ROWID (converted to a character string) of the first 
              database query row satisfying the where clause.  In the case of a 
              join, only the rowid of the first table in the join will be 
              returned and the expression in pcWhere can only reference that 
              table.
 
  Parameters:
    pcWhere - The where clause to apply to the database query to fetch the
              first record whose ROWID will be returned.
  
  Notes:      The ROWID is returned as a string both in anticipation of it
              being used as an argument to fetchRowIdent, and also to allow
              this function to be invoked from outside Progress.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowQuery  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQueryText AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cBuffer    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lDbQualify AS LOG    NO-UNDO.
    
  DEFINE VARIABLE cRowId     AS CHARACTER NO-UNDO INIT ?.
  
    {get QueryHandle hQuery}.
    {get UseDbQualifier lDbQualify}.

    IF NOT hQuery:IS-OPEN THEN RETURN ?.
    
    {get QueryWhere cQueryText}.  

    CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
    /* Create buffers and add to the query. 
       we must create buffers to avoid conflict with the original query
       in case it's PRESELECT (non-indexed sort) */
    DO i = 1 TO hQuery:NUM-BUFFERS:
      ASSIGN
        hBuffer = hQuery:GET-BUFFER-HANDLE(i)
        cBuffer = hBuffer:NAME.
       
      CREATE BUFFER hBuffer FOR TABLE cBuffer BUFFER-NAME cBuffer.
      lOK = hRowQuery:ADD-BUFFER(hBuffer).
      
      /* Add the where clause to the first buffer's existing query */  
      IF lOK AND i = 1 THEN
        ASSIGN
          cBuffer =  (IF lDbQualify THEN hBuffer:DBNAME + ".":U ELSE "":U)  
                      + cBuffer 
          cQueryText = newWhereClause(cBuffer,pcWhere,cQueryText,"":U).
    END.  /* do i = 1 */

    IF lOK THEN
    DO:
      lOK = hRowQuery:QUERY-PREPARE(cQueryText) NO-ERROR.
      
      IF lOK THEN lOK = hRowQuery:QUERY-OPEN().
      IF lOK THEN lOK = hRowQuery:GET-FIRST().
      
      ASSIGN hBuffer = hRowQuery:GET-BUFFER-HANDLE(1)
             cRowId  = IF lOK AND hBuffer:AVAILABLE 
                       THEN STRING(hBuffer:ROWID) 
                       ELSE ?.        
    END. /* END DO IF lOK */
    
    /* delete the temporary buffers */
    DO i = 1 TO hRowQuery:NUM-BUFFERS:
      ASSIGN
        hBuffer = hRowQuery:GET-BUFFER-HANDLE(i).
      DELETE OBJECT hBuffer. 
    END. /* do i = 1 to hRowQuery:num-buffers */ 
    DELETE OBJECT hRowQuery.  
    RETURN cRowid.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plCommit AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Passes along a "set AutoCommit" to the object's Update-Target.
  
  Parameters:
    plCommit - True or False to be set in the Update-Target procedure.

  Notes:       There is no AutoCommit property in a query object, but the 
               AutoCommit setting may be passed from a SmartDataObject to its 
               Data-Targets. If one of those targets is a query object that 
               isn't also a SmartDataObject (e.g., a SmartDataBrowser that has 
               its own db query), then the setting must be passed to the 
               Update-Target, which is the actual DataObject. 
               In a SmartDataObject the version of setAutoCommit in data.p
               will be found in preference to this one and will set the 
               actual property.
------------------------------------------------------------------------------*/

  dynamic-function("assignLinkProperty":U IN TARGET-PROCEDURE,
    'Update-Target':U, 'AutoCommit':U, IF plCommit THEN 'yes':U ELSE 'No':U).

  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCheckLastOnOpen) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCheckLastOnOpen Procedure 
FUNCTION setCheckLastOnOpen RETURNS LOGICAL
 (pCheck AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the flag indicating whether a get-last should be performed on 
              an open in order for fetchNext to be able to detect that we are on 
              the last row. This is necessary to make the QueryPosition 
              attribute reliable.
 
  Parameters:
    pCheck - True or False depending on whether the check should be done or not.
------------------------------------------------------------------------------*/
  
  {set CheckLastOnOpen pCheck}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataTarget Procedure 
FUNCTION setDataTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the DataTarget link value with a comma delimited string 
               containing the handle(s) of the query object's target object(s).

  Parameters:
    pcObject - Procedure handle(s) in CHARACTER form of the SmartObject(s)
               which should be made DataTarget(s) of this query object.
  
  Notes:       Because this can be a list, it should normally be changed using
               modifyListProperty.
------------------------------------------------------------------------------*/

  {set DataTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataTargetEvents Procedure 
FUNCTION setDataTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Resets the list of events this object subscribes to in its
               DataTarget.
  Parameters:  
    pcEvents - A comma-separated list of events to subscribe to.
  
  Notes:       Normally modifyListProperty should be used to ADD or REMOVE 
               events from this list.
------------------------------------------------------------------------------*/

  {set DataTargetEvents pcEvents}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setForeignFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setForeignFields Procedure 
FUNCTION setForeignFields RETURNS LOGICAL
  ( pcFields AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Foreign Fields property of the object.
  
  Parameters:
    pcFields - comma-separated paired list of db fields and the RowObject 
               fields they map to.
------------------------------------------------------------------------------*/
  {set ForeignFields pcFields}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNavigationSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNavigationSource Procedure 
FUNCTION setNavigationSource RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the NavigationSource link value.
  
  Parameters:  
    pcObject - procedure handle (as a character string) of the object which 
               should be made this object's Navigation-Source.
------------------------------------------------------------------------------*/

  {set NavigationSource pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenOnInit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOpenOnInit Procedure 
FUNCTION setOpenOnInit RETURNS LOGICAL
  ( plOpen AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the flag indicating whether the object's database query 
               should be opened automatically when the object is initialized -
               yes by default.
  
  Parameters:
    plOpen - True if the database query should be opened at initialization.
------------------------------------------------------------------------------*/

  {set OpenOnInit plOpen}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setOpenQuery Procedure 
FUNCTION setOpenQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the design Query value, to allow it to be manipulated 
              by setQueryWhere, for example

  Parameters: pcQuery - Query expression without open query <name>.
    Notes:    getOpenQuery is called from the client on AppServer, so we are not
              using the xp preprocessor.
------------------------------------------------------------------------------*/
 ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
        ghProp = ghProp:BUFFER-FIELD('OpenQuery':U)
        ghProp:BUFFER-VALUE = pcQuery.
  
  RETURN TRUE.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryPosition Procedure 
FUNCTION setQueryPosition RETURNS LOGICAL
  ( pcPosition AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Query Position property, and publishes an event to 
               tell others.
  
  Parameters:
    pcPosition - query position possible values are:
                 'FirstRecord', 'LastRecord', 'NotFirstOrLast' and 
                 'NoRecordAvailable'
------------------------------------------------------------------------------*/

    /* The property name does not have a property preprocessor
       to prevent it from being "set" directly, so that the event will 
       always be published, so the {set} syntax is not used. */

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('QueryPosition':U)
         ghProp:BUFFER-VALUE = pcPosition.
  PUBLISH 'queryPosition':U FROM TARGET-PROCEDURE (pcPosition).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQuerySort) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQuerySort Procedure 
FUNCTION setQuerySort RETURNS LOGICAL
  ( pcSort AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets or resets the sorting criteria (BY phrase) of the database
               query and stores the result in the QueryString property.
  Parameters:
    pcSort - new sort (BY) clause.
  
  Notes:     - setQueryWhere wipes out anything done in setQuerySort.
             - addQuerywhere does not. 
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryText   AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iByPos       AS INTEGER   NO-UNDO.
 DEFINE VARIABLE hQuery       AS HANDLE    NO-UNDO.
 DEFINE VARIABLE iIdxPos      AS INTEGER   NO-UNDO.
 DEFINE VARIABLE iLength      AS INTEGER   NO-UNDO.
 DEFINE VARIABLE lOk          AS LOGICAL   NO-UNDO.

  /* If a query is under work, use that. */  
  {get QueryString cQueryText}.
  
  IF cQueryText = "":U THEN 
  DO:
    {get QueryWhere cQueryText}.
  END. /* no query under work */
  
  IF cQueryText <> '':U THEN
  DO:
    
    ASSIGN    /* Remove BY */ 
      pcSort  = IF pcSort BEGINS "BY ":U 
                THEN TRIM(SUBSTRING(pcSort,3)) 
                ELSE pcSort

      /* check for indexed-reposition */
      iIdxPos = INDEX(RIGHT-TRIM(cQueryText,". ") + " ":U,
                      " INDEXED-REPOSITION ":U)          

      /* If there was no INDEX-REPOS we set the iLlength (where to end insert)
         to the end of where-clause. (right-trim periods and blanks to find 
         the true end of the expression)
         Otherwise iLength is the position of INDEX-REPOS. */
      iLength = (IF iIdxPos = 0 
                 THEN LENGTH(RIGHT-TRIM(cQueryText,". ":U)) + 1     
                 ELSE iIdxPos)    
      
      /* Any By ? */ 
      iByPos  = INDEX(cQueryText," BY ":U)             
      
      /* Now find where we should start the insert; 
         We might have both a BY and an INDEXED-REPOSITION 
         or only one of them or none. 
         Just make sure we use the MINIMUM of whichever of those if they
         are <> 0. */

      iByPos  = MIN(IF iByPos  = 0 THEN iLength ELSE iByPos,
                    IF iIdxPos = 0 THEN iLength ELSE iIdxPos) 
      
      SUBSTR(cQueryText,iByPos,iLength - iByPos) = " BY ":U + pcSort.
      
    {set QueryString cQueryText}.

  END. /* if cQuerytext = '' */

  RETURN cQueryText <> '':U.
    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryString) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryString Procedure 
FUNCTION setQueryString RETURNS LOGICAL
  (pcQueryString AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the QueryString property used as working storage for the
               addQueryString, assignQuerySelection, removeQuerySelection, 
               setQueryWhere, setQuerySort etc.   
  Parameters:  pcQueryString - The string to store
        Note:  NEVER set this directly. It should only be maintained by other
               query manipulation methods.  
------------------------------------------------------------------------------*/
  {set QueryString pcQueryString}.
  RETURN TRUE. 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryWhere Procedure 
FUNCTION setQueryWhere RETURNS LOGICAL
  ( pcWhere AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:    Append a WHERE clause to the basic static database query 
              definition (on client or server side) or modifes the complete 
              where clause.  
 
  Parameters:
    INPUT pcWhere - new WHERE clause (a logical expression without the 
                    leading WHERE keyword). 
  
  Notes:      NOTE that we always start with the base query definition 
              to do this. If the where-clause parameter is blank, we simply 
              reprepare the original query.
              Criteria appended with the other query manipulation methods 
              will be removed, INCLUDED sort criteria added with setQuerySort. 
  Parameters:
    pcWhere - new query expression or complete new where clause.  
              - An expression without the leading WHERE keyword.
                Will be added to the base query, if the base query has an 
                expression the new expression wil be appended with AND 
              - blank - reprepare the base query.
              - a complete query with the FOR keyword.
              
   Notes:      If pcWhere starts with "For " or "Preselect " then the existing 
               where clause is completely replaced with pcWhere.
               If pcWhere is blank, then the existing where clause is replaced
               with the design-time where clause.
               Otherwise pcWhere is added to the design-time where clause.
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE cQueryText     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQuery         AS  CHARACTER NO-UNDO.
  DEFINE VARIABLE cBlank         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cTables        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cBuffer        AS CHARACTER NO-UNDO.
       
  IF pcWhere BEGINS "FOR ":U OR pcWhere BEGINS "PRESELECT ":U THEN
    cQuery = pcWhere.
  
  ELSE DO:     
    {get OpenQuery cQueryText}.
    IF pcWhere <> "":U THEN
    DO:   
        /* get the first buffer reference in the expression */
      cBuffer = firstBufferName(pcWhere).
      IF cBuffer = ? THEN
      DO:
       {get Tables cTables}.
        cBuffer = ENTRY(NUM-ENTRIES(cTables),cTables). 
        /* add the passed where clause to the existing one */  
      END.
         /* add the passed where clause to the existing one */  
      cQuery  = newWhereClause(cBuffer,pcWhere,cQueryText,"":U).
    END. /* if pcWhere <> '' */
    ELSE /* If they passed a blank argument, just use the original query. */
      cQuery = cQueryText.
  END. /* else do (no "FOR ") */
   /* This overrides manipulations made by other methods, so make sure 
     the properties set by these other methods and used by openQuery are blank.  */
  {set QueryString cBlank}.  
  {set QueryColumns cBlank}.

  /* prepares the query with the new string */ 
   RETURN {fnarg prepareQuery cQuery}. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

