&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : data.p
    Purpose     : Super Procedure for all SmartDataObjects

    Syntax      : adm2/data.p

    Modified    : January 14, 2000 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell dataattr.i that this is the Super procedure. */
   &SCOP ADMSuper data.p
   
  {src/adm2/custom/dataexclcustom.i}

  DEFINE VARIABLE ghRowObject AS HANDLE    NO-UNDO. /* Handle of current TT rec.*/

/* The AddStartRow number, 9000000, must be kept in sync with a hard-coded
   reference to this number in data.i's clientSendRows.  We don't want to 
   make this a property because using row number like this will likely 
   change in a future release so we will just hardcode this in clientSendRows
   for now.  */
&SCOP  xiAddStartRow 9000000 /* high # for new rows*/
  DEFINE VARIABLE giAddRowNum  AS INTEGER NO-UNDO 
    INIT {&xiAddStartRow}. /* tmp row num for add */

  /* Include the file which defines AppServerConnect procedures. */
  {adecomm/appserv.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnColumnLabel Procedure 
FUNCTION assignColumnColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcLabel AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcFormat AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcHelp AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcLabel AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnMandatory Procedure 
FUNCTION assignColumnMandatory RETURNS LOGICAL
  ( pcColumn AS CHARACTER, plMandatory AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnPrivateData Procedure 
FUNCTION assignColumnPrivateData RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcData AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnValExp Procedure 
FUNCTION assignColumnValExp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcValExp AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD assignColumnValMsg Procedure 
FUNCTION assignColumnValMsg RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcValMsg AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnExtent Procedure 
FUNCTION columnExtent RETURNS INTEGER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
  (pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnProps Procedure 
FUNCTION columnProps RETURNS CHARACTER
  ( pcColList AS CHARACTER, pcPropList AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchRow Procedure 
FUNCTION fetchRow RETURNS CHARACTER
  (piRow AS INTEGER, pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fetchRowIdent Procedure 
FUNCTION fetchRowIdent RETURNS CHARACTER
  (pcRowIdent AS CHARACTER, pcViewColList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findRowObjUpd Procedure 
FUNCTION findRowObjUpd RETURNS HANDLE PRIVATE
  ( phRowObject AS HANDLE,
    phRowObjUpd AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASHandle Procedure 
FUNCTION getASHandle RETURNS WIDGET-HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentRowModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentRowModified Procedure 
FUNCTION getCurrentRowModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
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

&IF DEFINED(EXCLUDE-getMandatoryColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getMandatoryColumns Procedure 
FUNCTION getMandatoryColumns RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  (  )  FORWARD.

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

&IF DEFINED(EXCLUDE-getRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRebuildOnRepos Procedure 
FUNCTION getRebuildOnRepos RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObject Procedure 
FUNCTION getRowObject RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowObjUpd Procedure 
FUNCTION getRowObjUpd RETURNS HANDLE
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD newRowObject Procedure 
FUNCTION newRowObject RETURNS LOGICAL PRIVATE
  (pcMode AS CHARACTER)  FORWARD.

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

&IF DEFINED(EXCLUDE-rowidWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD rowidWhere Procedure 
FUNCTION rowidWhere RETURNS CHARACTER
  ( pcWhere AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  ( pcPartition AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASHandle Procedure 
FUNCTION setASHandle RETURNS LOGICAL
  ( phASHandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plFlag AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataQueryBrowsed Procedure 
FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  ( plBrowsed AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowObjectState Procedure 
FUNCTION setRowObjectState RETURNS LOGICAL
  ( pcState AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( piRows AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER, pcValueList AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD updateQueryPosition Procedure 
FUNCTION updateQueryPosition RETURNS LOGICAL PRIVATE
  ( )  FORWARD.

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
         HEIGHT             = 12.57
         WIDTH              = 53.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/dataprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-batchServices) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE batchServices Procedure 
PROCEDURE batchServices :
/*------------------------------------------------------------------------------
  Purpose:     To group a sequence of SDO service requests into a single request
               and thereby minimize network messaging and improve performance.
  
  Parameters:
    INPUT pcServices - A character string containing a CHR(1) delimitted list of
                       SDO internal procedures and functions to be executed.  
                       Each entry consists of a CHR(2) delimitted list of INPUT
                       PARAMETER values with the first entry being the NAME of
                       the procedure or function to be executed.
    OUTPUT pcValues  - A character string containing a CHR(1) delimitted list of
                       CHR(2) delimitted strings of output values that result 
                       from the execution of the services listed in pcServices
                       (above).  There is a one-to-one correspondence between
                       the CHR(1) delimitted list of Services in pcServices 
                       (above) and the CHR(1) delimitted list in pcValues.  
                       Procedures with no output paramters have a NULL entry.
                       The return value of functions appear as the first entry 
                       of the corresponding CHR(2) delimitted list, followed
                       by any output parameters.
  
  Notes:       As shipped, batchServices only supports a limited list of services.
               This list consists of all "get" and "set" functions that don't
               require processing other than getting and setting the property in
               the ADMprops temp-table record as well as columnProps,
               initializeObject, openQuery and synchronizeProperties. The list of
               cases will be extended from release to release.  Developers can
               extend the list by overriding batchServices with a local version
               that has an extended list then running SUPER.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcServices AS CHARACTER                         NO-UNDO.
DEFINE OUTPUT PARAMETER pcValues   AS CHARACTER                         NO-UNDO.

  DEFINE VARIABLE iService         AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE numServices      AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE iValue           AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE cRequest         AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cService         AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cDataType        AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE cValue           AS CHARACTER                         NO-UNDO.

  numServices = NUM-ENTRIES(pcServices, CHR(1)).
  DO iService = 1 TO numServices:  /* FOR EACH Service */

    ASSIGN cRequest = ENTRY(iService, pcServices, CHR(1))
           cService = ENTRY(1, cRequest, CHR(2)).

    CASE cService:

      WHEN "columnProps" THEN DO:
        pcValues = pcValues +
                      columnProps(INPUT ENTRY(2,cRequest,CHR(2)),
                                  INPUT ENTRY(3,cRequest,CHR(2))).
      END.

      WHEN "initializeObject" THEN DO:
        RUN initializeObject IN TARGET-PROCEDURE.
      END.
  
      WHEN "openQuery" THEN DO:
        pcValues = pcValues + STRING({fn openQuery}).
      END.

      WHEN "synchronizeProperties" THEN DO:
        RUN synchronizeProperties IN TARGET-PROCEDURE
                                 (INPUT ENTRY(2, cRequest, CHR(2)),
                                  OUTPUT cValue).
        pcValues = pcValues + cValue.
      END.

      OTHERWISE DO:
        /* See if it is a get- or set- property function */
        IF (cService BEGINS "get" AND NUM-ENTRIES(cRequest,CHR(2)) = 1) OR
           (cService BEGINS "set" AND NUM-ENTRIES(cRequest,CHR(2)) = 2) THEN DO:

          /* Get the datatype of the property */
          cDataType = DYNAMIC-FUNCTION("propertyType":U IN TARGET-PROCEDURE,
                                        SUBSTRING(cService,4)).
          IF cDataType EQ ? THEN  /* It wasn't found */
            RUN addMessage IN TARGET-PROCEDURE ("Function ":U + cService + " not defined.":U, ?, ?).
          ELSE IF cService BEGINS "s":U THEN DO:
            CASE cDataType:
              WHEN "CHARACTER":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                                     ENTRY(2,cRequest,CHR(2)) )).
              WHEN "INTEGER":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                             INTEGER(ENTRY(2,cRequest,CHR(2))) )).
              WHEN "LOGICAL":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                                     ENTRY(2,cRequest,CHR(2)) = "yes" )).
              WHEN "DECIMAL":U THEN
                pcValues = pcValues +
                           STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE,
                                             DECIMAL(ENTRY(2,cRequest,CHR(2))) )).
            END CASE.  /* Case on Signature */
          END.  /* setProperty case */
          ELSE DO:  /* getProperty case */
            pcValues = pcValues + STRING( DYNAMIC-FUNCTION (cService IN TARGET-PROCEDURE)).
          END.  /* getProperty case */
        END. /* If cService begins get or set */
        ELSE  /* Not a get or set function */
          RUN addMessage IN TARGET-PROCEDURE ("Function ":U + cService + " not defined.":U, ?, ?).
      END.  /* Otherwise do: */

    END CASE.  /* CASE on cService */

    IF iService NE numServices THEN
      ASSIGN pcValues = pcValues + CHR(1).

  END. /* DO iService = 1 TO numServices */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-commitTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE commitTransaction Procedure 
PROCEDURE commitTransaction :
/*------------------------------------------------------------------------------
  Purpose:     This event procedure receives the Commit "command" from a
               Commit panel or other Commit-Source. It then invokes the Commit
               function to actually commit the changes.  After the commit
               function finishes, commitTransaction handles any error messages 
               by calling showDataMessages.
 
  Parameters:  <none>
 
  Notes:       A transaction block is opened in serverCommit (called by the
               commit function) only if the SDO is running C/S.  That is no
               transaction block occurs occurs on the client side of a split
               SDO.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cErrorMessages AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iMsgNum        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lDataModified  AS LOGICAL   NO-UNDO INIT no.
  
  /* If they have made record changes they haven't saved, they must
     do that before they Commit. Make this check if it came from the
     Commit Panel, but skip if it came locally, because in that case
     DataModified isn't turned off until the whole thing completes. */
  
  {get CommitSource hSource}.
  IF hSource = SOURCE-PROCEDURE THEN
  DO:
    {get DataModified lDataModified}.
    IF lDataModified THEN
      /* Must Save before Commit. */
      RUN addMessage IN TARGET-PROCEDURE(DYNAMIC-FUNCTION("messageNumber":U IN TARGET-PROCEDURE, 4), ?, ?).
  END.    /* END IF hSource  */
  
  IF NOT lDataModified THEN  /* Continue only if no unsaved changes. */
    lSuccess = {fn Commit}. 
  ELSE lSuccess = no.
  
  /* If this object has a CommitTarget of its own, then if our own commit
       produces no errors, propogate the commit within our transaction block. 
     Note that this is not yet supported. */
  /*  IF lSuccess THEN
 *     DO:
 *        PUBLISH 'commitTransaction':U FROM TARGET-PROCEDURE.
 *        lSuccess = NOT DYNAMIC-FUNCTION("anyMessage":U IN TARGET-PROCEDURE).
 *     END. /* END DO IF lSuccess */
 * */
    
  /* IF no errors, signal to Commit Panel to disable itself again. */
  IF lSuccess THEN
    {set RowObjectState 'NoUpdates':U}.
  ELSE DO:
    /* If there were errors, get the Update-Source to deal with them. */
    {get UpdateSource hSource}.
    IF VALID-HANDLE (hSource) THEN      /* sanity check */
      {fn showDataMessages hSource}.
    RETURN "ADM-ERROR":U.               /* Signal error to caller. */
  END.  /* END ELSE DO IF Not lSuccess */
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE copyColumns Procedure 
PROCEDURE copyColumns :
/*------------------------------------------------------------------------------
  Purpose:     Called from copyRow to move column values to the new row.
  
  Parameters:
    INPUT pcViewColList - Comma delimited list of column names
    INPUT phDataQuery   - Handle to the RowObject query.
  
  Notes:       copyColumns exists primarily to remove code from the function
               copyRow, to reduce the size of the r-code action segment.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcViewColList   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER phDataQuery     AS HANDLE    NO-UNDO.
  
  DEFINE VARIABLE cVals      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hCol       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iValue     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cArrayVal  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
 
  hRowObject= phDataQuery:GET-BUFFER-HANDLE(1).
  IF phDataQuery:IS-OPEN THEN  /* Don't copy from RowObject if not used.*/
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hCol = hRowObject:BUFFER-FIELD(iCol).
    /* Copy arrays a value at a time, into a CHR(1) - delimited list,
       with array elements separated by CHR(2). */
    IF hCol:EXTENT NE 0 THEN DO:
      cArrayVal = "":U.
      DO iValue = 1 TO hCol:EXTENT:
        cArrayVal = cArrayVal +
                    (IF iValue > 1 THEN CHR(2) ELSE "":U) +
                    IF hCol:BUFFER-VALUE(iValue) = ? THEN "":U
                    ELSE hCol:STRING-VALUE[iValue].
      END.   /* END DO iValue */
      cVals = cVals + (IF iCol > 1 THEN CHR(1) ELSE "":U) + cArrayVal.
    END.     /* END DO for EXTENT */
    ELSE cVals = cVals + (IF iCol > 1 THEN CHR(1) ELSE "":U) +
                 IF hCol:BUFFER-VALUE = ? THEN "":U ELSE hCol:STRING-VALUE.
  END.       /* END DO iCol */
  ELSE    /* DO IF NOT IS-OPEN - get current vals from db rec */
    cVals = {fnarg colValues pcViewColList}.
      
  /* Now create the new record */
  hRowObject:BUFFER-CREATE().
  
  /* Move all the copied values into it. */
  IF phDataQuery:IS-OPEN THEN
  DO iCol = 1 TO hRowObject:NUM-FIELDS:
    hCol = hRowObject:BUFFER-FIELD(iCol).
    IF hCol:EXTENT NE 0 THEN DO:
      cArrayVal = ENTRY(iCol, cVals, CHR(1)).
      DO iValue = 1 TO hCol:EXTENT:
        hCol:BUFFER-VALUE[iValue] = ENTRY(iValue, cArrayVal, CHR(2)).
      END.   /* END DO iValue */
    END.     /* END DO Extent */
    ELSE hCol:BUFFER-VALUE = ENTRY(iCol, cVals, CHR(1)) NO-ERROR. 
  END.       /* END DO iCol   */
  /* If we're not using the RowObject temp-table for data reads, move values
     by name into the new Copy record. */
  ELSE DO iCol = 1 TO NUM-ENTRIES(pcViewColList):
    hCol = hRowObject:BUFFER-FIELD(ENTRY(iCol, pcViewColList)).
    hCol:BUFFER-VALUE = ENTRY(iCol + 1  /* First entry is RowIdent */ ,
                              cVals, CHR(1)).
  END.        /* END DO iCol IF RowsToBatch is 0 */
  
  /* set RowNum, RowIdent and navigation Properties etc*/  
  {fnarg newRowObject 'Copy':U}.
 
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dataAvailable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dataAvailable Procedure 
PROCEDURE dataAvailable :
/*------------------------------------------------------------------------------
  Purpose:     To set the QueryPosition property for the SDO when a "new" 
               rowObject record has been made available.  Possible settings for
               the QueryPosition property are FirstRecord (the new record is the
               first record of the rowObject dataset), LastRecord (the new record
               is the last record of the rowObject dataset, NotFirstOrLast,
               NoRecordAvailable or OnlyRecord.
  
  Parameters:
    INPUT pcRelative - A flag to indicate something about the "new" current record
                       that can be one of the following:
                SAME      - Don't change anything because the new record is the 
                            same as the old current record.
                DIFFERENT - There is a new record, determine if it is first or
                            last or NotFirstOrLast
                FIRST     - Treated the same as DIFFERENT
                NEXT      - Treated the same as DIFFERENT
                PREV      - Treated the same as DIFFERENT
                LAST      - Treated the same as DIFFERENT
                ?         - A super procedure has published DataAvailable so
                            RUN SUPER to let it set the QueryPosition property.
  
  Notes: This version of dataAvailable only sets the QueryPosition property to 
         FirstRecord, LastRecord or NotFirstOrLast.  It relies on other procedures
         to set the other possible values.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcRelative AS CHARACTER NO-UNDO.

  DEFINE VARIABLE hRowObject   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cPosition    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFirstRow    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRow     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cFields      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCurrent     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cNewPos      AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE hSource      AS HANDLE    NO-UNDO.
  
  IF pcRelative = "SAME":U THEN RETURN.  /* updated row requires no reset.*/
  
  /* If this is a request to reopen the query based on new key fields,
     then let our super procedure deal with it. Otherwise we reset
     the QueryPosition property if necessary. To determine
     this, we see if there are key fields we use to open a dependent
     query, and also if this event came from our data source, as opposed
     to a data target that just wants us to reposition the current query. 
     If pcRelative is unknown, then the event came from our super proc
     during initialization, so that also goes back to the super proc. */
  {get ForeignFields cFields}.
  {get DataSource hSource}.
  IF cFields NE "":U AND 
    ((hSource = SOURCE-PROCEDURE) OR (pcRelative = ?)) THEN
      RUN SUPER(pcRelative).
  ELSE DO:
     /* Update query position */  
     {fn updateQueryPosition}.
      
      /* Finally just republish dataAvailable to let other Data-Targets
       know about the reposition. */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE(pcRelative).
  END.    /* END DO IF cFields = "" */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject Procedure 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:     SmartDataObject version of destroyObject which disconnects an 
               AppServer connection if present before invoking the 
               standard destroy code.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  RUN disconnectObject IN TARGET-PROCEDURE.  /* Disc. from AppServer if present. */
  
  RUN SUPER.     /* No point in checking return code because we'll be dead... */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-disconnectObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disconnectObject Procedure 
PROCEDURE disconnectObject :
/*------------------------------------------------------------------------------
  Purpose:     To disconnect from the AppServer if there is one.
 
  Parameters:  <none>
  
  Notes:       First disconnectObject does an explicit destroyObject on the
               AppServer to give that object an opportunity to clean up. This 
               procedure is invoked from destroyObject or can be run directly 
               to disconnect without exiting.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppService    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hASHandle      AS HANDLE    NO-UNDO.
  
  {get AppService cAppService}.
  IF cAppService NE "":U THEN 
  DO:
    {get ASHandle hASHandle}.
    IF VALID-HANDLE(hASHAndle) AND hASHandle NE TARGET-PROCEDURE THEN
    DO:
      RUN destroyObject IN hASHandle.
      RUN appServerDisconnect(cAppService).
    END.   /* END DO VALID-HANDLE */
  END.     /* END DO cAppService  */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchBatch Procedure 
PROCEDURE fetchBatch :
/*------------------------------------------------------------------------------
  Purpose:     To transfer another "batch" of rows from the database query to 
               the RowObject Temp-Table query, without changing the current 
               record position.
  Parameters:
    INPUT plForwards - TRUE if we should retrieve a batch of rows after the current rows,
                       FALSE if before.
  Notes:       Run from a Browser to get another batch of rows from the database
               query appended to the RowObject temp-table query (when the 
               browser scrolls to the end).
               fetchBatch does some checking and sets up the proper parameters
               to sendRows, but sendRows is called to do the actual work.  
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER plForwards  AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hObject       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPosition     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rCurrentRow   AS ROWID     NO-UNDO.

  {get RowObjectState cRowState}.
  IF cRowState = 'RowUpdated':U THEN DO: /* if updates are in progress, can not continue */
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
     RETURN.
  END.
  
  {get LastRowNum iLastRow}.
  IF iLastRow NE ? AND plForwards THEN DO:
    {get QueryPosition cPosition}.  /* IF not already set, set it.*/
    IF cPosition NE 'LastRecord':U THEN
      {set QueryPosition 'LastRecord':U}.      
    RETURN.      /* We're already at the end of the db query. */
  END.     /* END DO IF iLastRow */
  
  {get DataHandle hDataQuery}.
  IF NOT hDataQuery:IS-OPEN           /* sanity check. */
    THEN RETURN.
   
  {get RowsToBatch iRowsToBatch}.
  RUN sendRows IN TARGET-PROCEDURE 
      (?, /* Don't repos., just get more rows. */
       ?,  /* no RowIdent specified to repos to */
       true,   /* Do a Next before getting more rows */
         /* Signal whether to move forward or back */
       IF plForwards THEN iRowsToBatch ELSE - iRowsToBatch, 
       OUTPUT iRowsReturned).
       
  IF iRowsReturned NE 0 THEN DO:  
    IF iRowsReturned < iRowsToBatch AND plForwards THEN DO:
      ASSIGN hObject   = hDataQuery:GET-BUFFER-HANDLE(1)
             hRowNum   = hObject:BUFFER-FIELD('RowNum':U)
             hRowIdent = hObject:BUFFER-FIELD('RowIdent':U) 
             .
      rCurrentRow = hObject:ROWID.  /* save its ROWID to repos to */
      hDataQuery:GET-LAST().
      {set LastRowNum hRowNum:BUFFER-VALUE}.
      {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
      hDataQuery:REPOSITION-TO-ROWID(rCurrentRow).
    END.   /* END DO IF < iRowsToBatch */
  END. /* IF iReturnRows NE 0 ... */
    
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchFirst) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchFirst Procedure 
PROCEDURE fetchFirst :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject temp-table to the first record, or
               to the row matching the QueryRowIdent property (if it has been
               set.)  If the first record has not been fetched (from the db) 
               yet, then calls sendRows to get the first batch of RowObject 
               records of the SDO and then reposition the RowObject Temp-Table
               to the first row.
 
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnRows AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER  NO-UNDO.
  DEFINE VARIABLE cRowIdent   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lRowIdent   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lRebuild    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iFirstRow   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cRowState   AS CHARACTER NO-UNDO.
  
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. In order to let through the case where
       fetchFirst is invoked from openQuery, e.g. during initialization,
       we check to see if we're being called from query.p.
       NOTE: This is not reliable and needs looking at later. */
    {get ObjectHidden lHidden}.
    IF SOURCE-PROCEDURE:FILE-NAME NE "adm2/query.p":U AND lHidden THEN 
      RETURN.
      
    /* If we're the server side of a divided DataObject, just return and
       wait for the client to invoke sendRows itself. */
    {get ASDivision cASDivision}.
    
    IF cASDivision = 'Server':U THEN
      RETURN.
      
    {get DataHandle hDataQuery}.
    {get RowObject hRowObject}.
    {get FirstRowNum iRowNum}.
    
    IF iRowNum = ? THEN       /* First row hasn't been retrieved yet. */      
    DO:
      {get RowsToBatch iRowsToBatch}.
      /* If there are already rows in the temp-table, then
         the query has already been opened and repositioned. In that case,
         pass the special value of "First" to sendRows to get it to flush
         the temp-table and restart from the beginning. Otherwise if
         QueryRowIdent is set, then start at that row. Otherwise just
         start at the beginning. */
      IF NOT hRowObject:AVAILABLE THEN 
      DO: /* First time through. */
        {get QueryRowIdent cRowIdent}.     /* See if there's a special start row.*/
        IF cRowIdent NE ? AND cRowIdent NE "":U THEN DO:
          lRowIdent = yes.
          {set QueryRowIdent ?}.   /* Reset once we have the value. */
        END.   /* END DO IF cRowIdent has a valid value */
      END.   /* END DO IF there is no RowObject available */
      ELSE cRowIdent = "First":U.  /* Else signal restart at beginning. */
      
      RUN sendRows IN TARGET-PROCEDURE 
        (?                  /* Start at the first row if RowIdent is not set */, 
         cRowIdent          /* or use this RowIdent key if its set. */,
         FALSE              /* Don't next initially */, 
         iRowsToBatch       /* how many rows to retrieve */, 
         OUTPUT iReturnRows /* how many rows were actually returned */ ).
      
      IF NOT hDataQuery:IS-OPEN THEN
        hDataQuery:QUERY-OPEN(). /* Query on the Temp-Table. */

      ASSIGN hColumn = hRowObject:BUFFER-FIELD('RowNum':U).
      IF iReturnRows NE 0 THEN 
      DO:
        IF iReturnRows < iRowsToBatch THEN 
        DO:
          /* If we got something back, but fewer rows than we asked for, 
             then we have the whole dataset, so set LastRowNum 
             as well as First. */
          hDataQuery:GET-LAST().
          {set LastRowNum hColumn:BUFFER-VALUE}.
        END.   /* END DO IF < iRowsToBatch */
        
        hDataQuery:GET-FIRST().
        
        IF NOT lRowIdent THEN /* If there was no QueryRowIdent prop then we */
          {set FirstRowNum hColumn:BUFFER-VALUE}.
      END.     /* END DO IF iReturnRows NE 0 */
      ELSE DO:
        {get RebuildOnRepos lRebuild}.      
        IF lRebuild THEN DO:
           /* See if fetch failed due to an update in progress */
          {get FirstRowNum iFirstRow}.
          {get RowObjectState cRowState}.
          IF cRowState = 'RowUpdated':U AND iFirstRow eq ?
          THEN DO:
            DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
            {set FirstRowNum ?}.
            RETURN.
          END.   /* If in a commit */
        END.  /* Rebuild On Reposition is set */
        hRowObject:BUFFER-RELEASE().
      END. /* END ELSE DO IF no rows returned */
    END.   /* END IF iRowNum = ? */
    ELSE hDataQuery:GET-FIRST().
    
    /* set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    {fn updateQueryPosition}.

    /* Send dataAvail whether's a record or not; if not, the recipients
       will close queries or clear frames. */
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
  Purpose:     To reposition the RowObject query to the last row of the dataset.
               If the last row has not yet been retrieved from the DB, then
               fetchLast gets the last batch of RowObject records for the SDO 
               and then repositions the RowObject query to the last row.
  
  Parameters:  <none>

  Notes:       IF the SDO property RebuildOnReposition is false and the last row
               from the db query has not been fetch yet, fetchLast keeps asking
               for batches of rows till the last batch is recieved. This is 
               required, because otherwise there would be a discontinuous set of
               rows in the RowObject temp-table, and also, the RowNum of the last
               record, which is the key value, can be known by the db query only
               by walking all the way to the end.
               If RebuildOnReposition is true and the last row from the db query
               has not been fetch yet, all RowObject records are discarded and
               just the last batch is fetched. In this case the RowNum of the
               last row becomes 2000000 and all other records have smaller numbers
               (except for additions.)
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.
  DEFINE VARIABLE lHidden       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHARACTER NO-UNDO.
  
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
    
    {get DataHandle hDataQuery}.
    {get RowObject hRowObject}.
     hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U).
             
    {get LastRowNum iLastRow}.
    IF iLastRow = ? THEN        /* Last row not been retrieved yet.*/
    DO:
      RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
      {get RowsToBatch iRowsToBatch}.
      {get RebuildOnRepos lRebuild}.
      IF lRebuild THEN   /* Jump direct to Last and rebuilt temp-table */
        RUN sendRows IN TARGET-PROCEDURE 
          (?,            /* No particular rownum to start at */
           'Last':U,     /* special value for pcRowIdent */
           FALSE,        /* No need to "next" after repositioning */
           iRowsToBatch, /* sendRows knows to go backwards from Last */
           OUTPUT iRowsReturned).
      ELSE DO:           /* No Rebuild on Reposition */
        /* Keep asking for rows until we get fewer than we asked for. */
        iRowsReturned = iRowsToBatch.
        /* Set the cursor first in case this takes a while. */
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE 
            ('LastStart':U).
        DO WHILE iRowsReturned = iRowsToBatch:
          RUN sendRows IN TARGET-PROCEDURE 
            (?, ?, TRUE, iRowsToBatch, OUTPUT iRowsReturned).
        END.
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('LastEnd':U).   
      END.    /* END ELSE DO IF NOT lRebuild */
      
      IF NOT hDataQuery:IS-OPEN THEN
       hDataQuery:QUERY-OPEN(). /* Query on the Temp-Table. */

      IF iRowsReturned = 0 THEN
      DO:
        /* See if fetch failed due to an update in progress */
        {get LastRowNum iLastRow}.
        {get RowObjectState cRowState}.
        IF cRowState = 'RowUpdated':U AND iLastRow eq ?
        THEN DO:
          DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
          {set LastRowNum ?}.
          RETURN.
        END.   /* If in a commit */
      END.  /* iRowsReturned = 0 */
      
      RUN changeCursor IN TARGET-PROCEDURE('':U).
    END.
    
    hDataQuery:GET-LAST().
     
    IF hRowObject:AVAILABLE THEN
    DO:
      hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U).
      {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
      {set LastRowNum hRowNum:BUFFER-VALUE}.
    END.
    
     /* set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    {fn updateQueryPosition}.

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
  Purpose:     To reposition the RowObject query to the next row.  If a new 
               batch is required to do so, then sendRows is called to get the
               new batch.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iRowNum      AS INTEGER NO-UNDO.
  DEFINE VARIABLE iReturnRows  AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO. 
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cLastDbRowId AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE iFirstRow    AS INTEGER  NO-UNDO.
  DEFINE VARIABLE iLastRow     AS INTEGER  NO-UNDO.
  DEFINE VARIABLE rCurrentRow  AS ROWID    NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReposAvail  AS LOG    NO-UNDO.
    
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
   
    {get DataHandle hDataQuery}.
    IF NOT hDataQuery:IS-OPEN        
      THEN RETURN.
      
    ASSIGN hRowObject = hDataQuery:GET-BUFFER-HANDLE(1)
           hRowNum   = hRowObject:BUFFER-FIELD('RowNum':U)
           hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U).

    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get LastRowNum iRow}.
      {get LastDbRowIdent cLastDbRowId}. 

      /* Already on the last row. */
      IF iRow          =  hRowNum:BUFFER-VALUE 
      OR (cLastDbRowid <> "":U AND cLastDbRowId = hRowIdent:BUFFER-VALUE) THEN 
        RETURN.
    END. /* if hRowObject:available */
    
    hDataQuery:GET-NEXT().
    
    IF NOT hRowObject:AVAILABLE THEN
    DO:                                 /* No data so ask the Query. */
      {get RowsToBatch iRowsToBatch}.
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextStart':U).
      
      RUN sendRows IN TARGET-PROCEDURE
        (?, /* sendRows will know what row to start at */
         ?, /* No pcRowIdent */
         TRUE /* start with next row */, iRowsToBatch, OUTPUT iReturnRows).
      
      PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextEnd':U).
      IF iReturnRows NE 0 THEN
      DO:
        IF iReturnRows < iRowsToBatch THEN
        DO:
          /* If we got something back, but fewer rows than we asked for, 
             then we have the whole dataset, so set LastRowNum. 
             First save off the current position so we can get back to it. 
             Don't next if available (reposition with browse) */
          IF NOT hRowObject:AVAILABLE THEN 
            hDataQuery:GET-NEXT().  
          
          rCurrentRow = hRowObject:ROWID.  /* save its ROWID to repos to. */
          hDataQuery:GET-LAST().
          {set LastRowNum hRowNum:BUFFER-VALUE}.
          {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
          hDataQuery:REPOSITION-TO-ROWID(rCurrentRow).
        END.   /* END DO IF < iRowsToBatch */
        /* Set ReposAvail flag if avail after reposition above or in sendRows
           (will be avail if we browse) so we can pass right parameter to the
           browser when we publish dataAvailable further down */  
        lReposAvail = hRowObject:AVAILABLE. 
        IF NOT lReposAvail THEN 
          hDataQuery:GET-NEXT().           
      END.     /* END DO IF ReturnRows NE 0 */
      ELSE DO:
        hDataQuery:GET-LAST().
        {get LastRowNum iLastRow}.
        
        /* See if fetch failed due to an update in progress */
        {get RowObjectState cRowState}.
        IF cRowState = 'RowUpdated':U AND iLastRow eq ? THEN 
        DO:
          DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
          {set LastRowNum ?}.
          /* Signal row change in any case, even if NoRecordAvail. */
          PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("NEXT":U). 
          RETURN.
        END.   /* If in a commit */

        IF NOT hRowObject:AVAILABLE THEN
        DO:
          {set LastRowNum ?}.
          RUN fetchLast IN TARGET-PROCEDURE.         
        END. /* if not hRowObject:available */
        ELSE DO:
          iRowNum = hRowNum:BUFFER-VALUE.
          {set LastRowNum iRowNum}.
          {set LastDbRowIdent hRowIdent:BUFFER-VALUE}.
        END.  /* If there is a last record */
      END.     /* END ELSE DO IF ReturnRows = 0 */
    END.       /* END DO IF no next record AVAILABLE  */
    
    /* set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    {fn updateQueryPosition}.
    
    /* Signal row change in any case, even if NoRecordAvail. 
       If REPOSITION-TO-ROWID made the record available it must be browsed 
       so we pass 'REPSOTIONED' to make sure dataAvailable doesn't select-next- */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
           (IF lReposAvail THEN "REPOSITIONED":U ELSE "NEXT":U). 
    
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchPrev) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fetchPrev Procedure 
PROCEDURE fetchPrev :
/*------------------------------------------------------------------------------
  Purpose:     To reposition the RowObject query to the previous row.  If a new
               batch is needed to do so, then sendRows is called to get the new
               batch.  (Getting a new batch will only be necessary when the 
               RebuildOnReposition property is set to true.)
 
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iReturnRows  AS INTEGER NO-UNDO.
  DEFINE VARIABLE hDataQuery   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lHidden      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE iRow         AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch AS INTEGER NO-UNDO.
  DEFINE VARIABLE lAutoCommit  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE rCurrentRow  AS ROWID    NO-UNDO.
  DEFINE VARIABLE lRebuild     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cRowState    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lReposAvail  AS LOG    NO-UNDO.
    /* IF this object is currently hidden, then just return. This effectively
       makes the link inactive. */
    {get ObjectHidden lHidden}.
    IF lHidden THEN RETURN.
   
    {get DataHandle hDataQuery}.

    IF NOT hDataQuery:IS-OPEN        
      THEN RETURN.
      
    ASSIGN hRowObject = hDataQuery:GET-BUFFER-HANDLE(1)
           hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U).
        
    IF hRowObject:AVAILABLE THEN   /* Make sure we're positioned to some row. */
    DO:
      {get FirstRowNum iRow}.
      IF iRow = hRowNum:BUFFER-VALUE THEN 
        RETURN.
    END.
    
    hDataQuery:GET-PREV().
    
    IF NOT hRowObject:AVAILABLE THEN
    DO:                        
      /* If we are rebuilding the query from the end or some middle point,
         then we have to check to see if there are more rows in the dataset.*/      
      {get RebuildOnRepos lRebuild}.

      IF lRebuild  THEN
      DO:
        {get RowsToBatch iRowsToBatch}.
        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevStart':U).
        RUN sendRows IN TARGET-PROCEDURE
         (?, /* sendRows will know what row to start at */
          ?, /* No pcRowIdent */
          TRUE, /* start with previous row */
          - iRowsToBatch, /* Negative rows means move backwards */
          OUTPUT iReturnRows).

        PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevEnd':U).
        
        IF iReturnRows NE 0 THEN
        DO:
          IF iReturnRows < iRowsToBatch THEN
          DO:
          /* If we got something back, but fewer rows than we asked for, 
             then we have the whole dataset, so set FirstRowNum. 
             First save off the current position so we can get back to it.
           (if the REPOSITION in sendRows made it available it's browsed so
            don't get-next) */
            IF NOT hRowObject:AVAILABLE THEN
              hDataQuery:GET-NEXT().         
            rCurrentRow = hRowObject:ROWID.  /* save its ROWID to repos to. */
            hDataQuery:GET-FIRST().
            {set FirstRowNum hRowNum:BUFFER-VALUE}.
            hDataQuery:REPOSITION-TO-ROWID(rCurrentRow).
          END.   /* END DO IF < iRowsToBatch */
          /* Set ReposAvail flag if avail after reposition above or in sendRows
             (will be avail if we browse) so we can pass right parameter to the
             browser when we publish dataAvailable further down */  
          lReposAvail = hRowObject:AVAILABLE.

          /* Reposition to the record we were on before this was called and 
             then get the now previous record */
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevStart':U).
          
          IF NOT lReposAvail THEN /* get the row that we have repositioned to */
            hDataQuery:GET-NEXT(). 
          
          PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('PrevEnd':U).
        END.     /* END DO IF ReturnRows NE 0 */
      END. /* if lRebuild */

      /* ReturnsRow = 0 indicates either 
         NOT RebuildOnRepos OR RebuildonRepos, but no more records */
      IF iReturnRows = 0 THEN
      DO:
        hDataQuery:GET-FIRST().        
         
        /* See if fetch failed due to an update in progress */ 
        IF lRebuild THEN
        DO:
          {get FirstRowNum iRow}. 
          {get RowObjectState cRowState}.
          IF cRowState = 'RowUpdated':U AND iRow eq ? THEN 
          DO:
            DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "17":U).
            {set FirstRowNum ?}.
            RETURN.
          END. /* If in a commit */
        END. /* lRebuild */
        
        IF hRowObject:AVAIL THEN
          {set FirstRowNum hRowNum:BUFFER-VALUE}.
        ELSE 
          {set FirstRowNum ?}.

      END. /* IF ReturnRows = 0 */
    END. /* IF not hRowObject:available */
    
    /* set QueryPosition from FirstRowNum, LastRowNum and DbLastDbRowIdent */
    {fn updateQueryPosition}.
   
    /* Signal row change in any case, even if NoRecordAvail. 
       If REPOSITION-TO-ROWID made the record available it must be browsed 
       so we pass 'REPSOTIONED' to make sure dataAvailable doesn't select-prev- */
    PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE 
           (IF lReposAvail THEN "REPOSITIONED":U ELSE "PREV":U). 
           
  RETURN.  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-genContextList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE genContextList Procedure 
PROCEDURE genContextList :
/*------------------------------------------------------------------------------
  Purpose:     To generate a list of properties and their values needed to save
               (and restore) the context of a stateless SDO between invocations. 
   
  Parameters:
    OUTPUT pcContext - The context string to be returned. pcContext is a CHR(3) 
                       delimited list of propertyCHR(4)Value pairs.
 
  Notes:       Currently there are only 5 properties needed to restore the
               context: CheckCurrentChanged, RowObjectState, FirstResultRow,
               LastResultRow and QueryRowIdent.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcContext     AS CHARACTER                   NO-UNDO.

  DEFINE VARIABLE lCheckCurrentChanged  AS LOGICAL                     NO-UNDO.
  DEFINE VARIABLE cRowObjectState       AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE cFirstResultRow       AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE cLastResultRow        AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE cQueryWhere           AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE cQueryRowIdent        AS CHARACTER                   NO-UNDO.

  {get CheckCurrentChanged lCheckCurrentChanged}.
  {get RowObjectState cRowObjectState}.
  {get FirstResultRow cFirstResultRow}.
  {get LastResultRow cLastResultRow}.
  {get QueryRowIdent cQueryRowIdent}.

  /* Rebuild the context string to look like:
     prop1 CHR(4) val1 CHR(3) prop2 CHR(4) val2 CHR(3) ...                  */
          
  ASSIGN pcContext = "CheckCurrentChanged":U + CHR(4) +
                         (IF lCheckCurrentChanged THEN "Yes":U ELSE "No":U) + CHR(3) +
                     "RowObjectState":U + CHR(4) + cRowObjectState + CHR(3) +
                     "FirstResultRow":U + CHR(4) + cFirstResultRow + CHR(3) +
                     "LastResultRow":U + CHR(4) + cLastResultRow + CHR(3) +
                     "QueryRowIdent":U + CHR(4) + cQueryRowIdent.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     To performs SmartDataObject-specific initialization. Specifically,
               to start the server-side copy of this object if the AppService
               (partition) is defined.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cAppService    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppService    AS HANDLE    NO-UNDO. /* *Connection* handle */
  DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO. /* pers. *proc* hdl */
  DEFINE VARIABLE cSvrFileName   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lASUsePrompt   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cASInfo        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cUIBMode       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hSource        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cQuerySource   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataSource    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lCheck         AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE iProp          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cSignature     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProp          AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cValue         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cServerOperatingMode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPropertiesForClient AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cPropertiesForServer AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cServerState   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContext       AS CHARACTER NO-UNDO.
  
  /* If the object has a Partition named, then connect to it. */
  /* Skip all this if we're in design mode. */
  {get UIBMode cUIBMode}.
  IF cUIBMode = "":U THEN
  DO:
    {get AppService cAppService}.
    {get ASDivision cASDivision}.
    IF cAppService = "(None)":U THEN
    DO:
      cAppService = "":U.
      {set AppService '':U}.
    END.
    IF cAppService NE "":U THEN
    DO:
      /* The values for the parameters to appServerConnect can be specified
         in the AppBuilder's Service table. So we pass ? for the parameters
         to the let the Connect procedure fill in the values from the table,
         unless they have been specifically set to some value for this object.*/
      {get ASUsePrompt lASUsePrompt}.
      {get ASInfo cASInfo}.
      RUN appServerConnect(cAppService, 
        IF NOT lASUsePrompt THEN ? ELSE lASUsePrompt,
        IF cASInfo NE "":U THEN cASInfo ELSE ?, OUTPUT hAppService).                                       
    /* If the AppServer handle is the SESSION:HANDLE and we are running the
       client proxy - (ASDivision = "Client") then the user doesn't have the
       right databases connected and needs an error message.                  */
      IF (hAppService = SESSION:HANDLE OR RETURN-VALUE = "ERROR":U) AND
          cASDivision = 'CLIENT':U THEN DO:
        DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, cAppService +
            " partition is running locally without the proper database connection(s).").
        hAppService = SESSION:HANDLE.
        RETURN ERROR.
      END.

    /* If we got a bonifide AppServer conn., then start a copy of this object
       on the AppServer. Save its handle for use by later procedure calls.
       Otherwise, if we just got the SESSION handle back, this means that
       the AppService is "local", so there's no need to run a second copy
       of the DataObject. In this case we just set the AppServer handle to the
       client TARGET-PROCEDURE. */
      IF hAppService NE ? and hAppService NE SESSION:HANDLE THEN
      DO:
        cASDivision = "Client":U.
        {set ASDivision cASDivision}.  /* Signal this is client of a split DO. */
        cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.w":U, ".w":U).
        IF cSvrFileName = TARGET-PROCEDURE:FILE-NAME THEN
          cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.r":U, ".w":U).
        RUN VALUE(cSvrFileName) ON hAppService PERSISTENT 
          SET hAppServer.  /* NOTE: NO-ERROR and error check? */
        IF NOT VALID-HANDLE(hAppServer) THEN
        DO:
          DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE,
            "AppServer startup failed for ":U + TARGET-PROCEDURE:FILE-NAME).
          RETURN ERROR.
        END.  /* END IF NOT VALID-HANDLE */
        ELSE DO:  /* The Appserver Handle is valid */
          {set ASHandle hAppServer}.

          /* Initialize the server object because there's no container on that
             side of the connection to do it for us. */
          RUN initializeObject IN hAppServer.

          /* Set the CheckCurrentChanged property on the server and get back
             the AppServer Operating mode                                    */
          {get CheckCurrentChanged lCheck}.
          {get ServerOperatingMode cServerState}.
          cPropertiesForServer = "CheckCurrentChanged" + CHR(4) +
                                                IF lCheck THEN "Yes" ELSE "No".
          RUN synchronizeProperties IN hAppServer (cPropertiesForServer,
              OUTPUT cPropertiesForClient).
          RUN setPropertyList IN TARGET-PROCEDURE (cPropertiesForClient).
          /* Override the actual state if the instance property is to force stateful */
          IF cServerState = "STATE-RESET" THEN
            {set ServerOperatingMode cServerState}.
          
        END.  /* END ELSE DO (Have a valid AppServer Handle)  */
      END.    /* END DO IF NOT SESSION HANDLE */
      ELSE {set ASHandle TARGET-PROCEDURE}.
    END.      /* END DO IF AppService NE "":U */
    ELSE
    DO:
      /* If no AppService defined, check if the user is running the client
         proxy. If so, there can't be any required databases connected for
         the object to show data. Probably an AppServer setup problem. */
      IF TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.w':U OR
         TARGET-PROCEDURE:FILE-NAME MATCHES '*_cl.r':U THEN
      DO:
        cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.w":U, ".w":U).
        IF cSvrFileName = TARGET-PROCEDURE:FILE-NAME THEN
          cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.r":U, ".w":U).
        DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, cSvrFileName + 
        " SmartDataObject has no AppServer partition defined and is ":U +
        "running locally without proper database connection(s).":U).
        RETURN "ADM-ERROR":U.
      END.
    END.   /* ELSE DO IF AppService EQ "":U */
    
    /* If this SDO is just being used to update a SDBrowser with its own
       database query, then turn its QueryObject property off and don't
       have the query opened. */
    /* In case our Update-Source is an object such as a SDViewer, we
       may have to ask whether it in turn has a Data-Source. If that
       is the case and it is not the current object, also suppress
       opening the query. */
    cQuerySource = dynamic-function('linkProperty':U IN TARGET-PROCEDURE, 
      'Update-Source':U, 'QueryObject':U).
    IF cQuerySource NE "Yes":U THEN
      /* Does the Update-Source have a Data-Source that isn't us? */
      cDataSource = dynamic-function('linkProperty':U IN TARGET-PROCEDURE, 
        'Update-Source':U, 'DataSource':U).
    IF cQuerySource = "Yes":U OR 
       (VALID-HANDLE(WIDGET-HANDLE(cDataSource)) AND
        WIDGET-HANDLE(cDataSource) NE TARGET-PROCEDURE) THEN
    DO:
      cQuerySource = "Yes":U.      /* Set positively for check below. */
      {set QueryObject no}.
      {set OpenOnInit no}.
    END.   /* END DO IF QuerySource */
    
    /* If this object has a Commit-Source (a Commit Panel or the like) then
       we set the AutoCommit flag off. If this object is just being used
       to update another QueryObject, then this is an error. */
    {get CommitSource hSource}.
    IF hSource NE ? THEN
    DO:
      IF cQuerySource = "Yes":U THEN
      DO:
         DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE,
           "Commit Source may not be used in this configuration.":U).
         RETURN "ADM-ERROR":U.
      END.   /* END DO IF QuerySource */
      ELSE {set AutoCommit no}.
    END.     /* END DO IF hSource */
  END.       /* END IF not UIBMode   */
   
  RUN SUPER.     /* NOTE: This should really happen first; check later. */

  IF cASDivision = 'CLIENT':U THEN DO:  /* Shutdown Server side SDO if stateless */
    {get ServerOperatingMode cServerOperatingMode}.
    IF cServerOperatingMode = 'STATELESS':U THEN DO:
      {get ASHandle hAppServer}.
      RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
      RUN setPropertyList IN TARGET-PROCEDURE (cContext).
    END.
  END.
  IF RETURN-VALUE = "ADM-ERROR":U THEN
     RETURN "ADM-ERROR":U.
  ELSE RETURN.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-refreshRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refreshRow Procedure 
PROCEDURE refreshRow :
/*------------------------------------------------------------------------------
  Purpose:     To retrieve the current database values for a row already
               in the RowObject table.

  Parameters:  <none>
  
  Notes:       PUBLISHes dataAvailable ('SAME') to cause a SDViewer or
               Browser to display the latest values. Since the database 
               records are never locked on read, this procedure can fetch the
               latest values but cannot guarantee that they will not change
               before an update is done.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataQuery      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iRows           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hField          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowIdent       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowState       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iRowNum         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lNewRow         AS LOG       NO-UNDO.

  {get RowObjectState cRowState}.
  IF cRowState = 'RowUpdated':U THEN DO: /* if updates are in progress, can not continue */
     DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "24":U).
     RETURN.
  END.  /* if cRowState = rowupdated */
  
  /* Nothing to refresh ..  */
  {get NewRow lNewRow}.    
  IF lNewRow THEN 
     RETURN.
  
  {get DataHandle hDataQuery}.
  {get RowObject  hRowObject}.
  
  IF NOT hRowObject:AVAILABLE THEN
    RETURN.

  /* Save off the current RowIdent to pass to sendRows. It will re-retrieve
     that row from the database. */
  ASSIGN hField    = hRowObject:BUFFER-FIELD('RowIdent':U)
         cRowIdent = hField:BUFFER-VALUE
         hField    = hRowObject:BUFFER-FIELD('RowNum':U)
         iRowNum   = hField:BUFFER-VALUE.
  
  hRowObject:BUFFER-DELETE().      /* remove the old copy of the row. */
  /* This special calling sequence tells sendRows to retrieve a new copy
     of the record pointed to by cRowIdent, give it the number iRowNum,
     and add it to the existing RowObject table. */
  
  RUN sendRows IN TARGET-PROCEDURE
                (iRowNum, 
                 cRowIdent, 
                 false /* no Next */, 
                 1 /* Get just 1 row */, 
                 OUTPUT iRows).  
  /* sendRows has re-opened the query and repositioned to the newly
     retrieved row; so if the row is not available we do a Next to 
     move onto the row itself. We check whether the record is available
     in order NOT to do this on a browser, which of course fetches the record
     when the query is repositioned.  */  
  IF NOT hRowObject:AVAILABLE THEN
     hDataQuery:GET-NEXT().          
  
  /* Tell everyone we have a new copy of the same row. */
  PUBLISH 'dataAvailable' FROM TARGET-PROCEDURE ('SAME':U).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-restartServerObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE restartServerObject Procedure 
PROCEDURE restartServerObject :
/*------------------------------------------------------------------------------
  Purpose:    When a SmartDataObject is split and running Statelessly on an
              AppServer, it is shutdown after each use and then restarted for
              the next.  restartServerObject is run on the client to restart
              the SmartDataObject on the server.
 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cAppService           AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE hAppService           AS HANDLE                      NO-UNDO.
  DEFINE VARIABLE cSvrFileName          AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE hAppServer            AS HANDLE                      NO-UNDO.
  DEFINE VARIABLE cPropertiesForServer  AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE cPropertiesForClient  AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE cQueryString          AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE iByClause             AS INTEGER                     NO-UNDO.
  DEFINE VARIABLE cQueryWhere           AS CHARACTER                   NO-UNDO.
  DEFINE VARIABLE cQuerySort            AS CHARACTER                   NO-UNDO.

  {get AppService cAppService}.
  
  /* Retrieve the AppServer handle.  Note: appServerConnect will return the
     handle since cAppService is already connected.                          */
  RUN appServerConnect(cAppService, ?, ?,OUTPUT hAppService).

  cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.w":U, ".w":U).
  IF cSvrFileName = TARGET-PROCEDURE:FILE-NAME THEN
    cSvrFileName = REPLACE(TARGET-PROCEDURE:FILE-NAME, "_cl.r":U, ".w":U).

  RUN VALUE(cSvrFileName) ON hAppService PERSISTENT 
          SET hAppServer.  /* NOTE: NO-ERROR and error check? */

  IF NOT VALID-HANDLE(hAppServer) THEN DO:
    DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE,
      "AppServer startup failed for ":U + TARGET-PROCEDURE:FILE-NAME).
    RETURN ERROR.
  END.  /* END IF NOT VALID-HANDLE */

  ELSE DO:  /* The Appserver Handle is valid */
    {set ASHandle hAppServer}.

    /* Initialize the server object because there's no container on that
       side of the connection to do it for us. */
    RUN initializeObject IN hAppServer.

    {get QueryString cQueryString}.
    
    RUN genContextList IN TARGET-PROCEDURE (OUTPUT cPropertiesForServer).

    /* Set QueryWhere on the server from QueryString on the client.
       This includes BY phrases. */
    IF cQueryString <> "":U THEN
      cPropertiesForServer = (IF cPropertiesForServer  <> ? 
                              AND cPropertiesForServer <> "":U 
                              THEN cPropertiesForServer + CHR(3)
                              ELSE "":U) 
                              + "QueryWhere":U + CHR(4) + cQueryString.
    
    RUN synchronizeProperties IN hAppServer (cPropertiesForServer,
                                             OUTPUT cPropertiesForClient).
  END.  /* END ELSE DO (Have a valid AppServer Handle)  */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rowObjectState Procedure 
PROCEDURE rowObjectState :
/*------------------------------------------------------------------------------
  Purpose:     To pass on the flag which indicates when a SmartDataObject row 
               has been changed locally but not committed. This gets passed on 
               until it reaches the Commit Panel or other first Commit-Source.
 
  Parameters:
    INPUT pcState - the new state
  
  Notes:       This SamrtDataObject version doesn't do anything itself with 
               the state setting, but simply passes it on up the chain, except
               when we get 'NoUpdates' from another SDO with a Commit Panel;
               in that case we have suppressed any 'UpdateComplete' events
               we have received until they were committed, so we send that
               event now.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lCommit AS LOG    NO-UNDO INIT ?.

  IF pcState = 'NoUpdates':U AND SOURCE-PROCEDURE NE TARGET-PROCEDURE THEN
  DO:
      lCommit = dynamic-function('getAutoCommit':U IN SOURCE-PROCEDURE) NO-ERROR.
      IF lCommit = NO THEN
          PUBLISH 'updateState':U FROM TARGET-PROCEDURE 
            ('UpdateComplete':U).
  END.
   
  PUBLISH 'rowObjectState':U FROM TARGET-PROCEDURE (pcState).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-saveContextAndDestroy) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveContextAndDestroy Procedure 
PROCEDURE saveContextAndDestroy :
/*------------------------------------------------------------------------------
  Purpose:     To save the context of the server-side SDO and then destroy it.
    
  Parameters:  
    OUTPUT pcContext - The context string to be returned
 
  Notes:       saveContextAndDestroy is invoked from the client side of the
               SmartDataObject and executed on the server side.
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER pcContext     AS CHARACTER                   NO-UNDO.

  RUN genContextList IN TARGET-PROCEDURE (OUTPUT pcContext).
  RUN destroyObject IN TARGET-PROCEDURE.  /* Disc. from AppServer if present. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-sendRows) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sendRows Procedure 
PROCEDURE sendRows :
/*------------------------------------------------------------------------------
  Purpose:     To fetch the requested number of rows (views) from the DB Query
               and to create corresponding records in the Row Object Temp-Table.
               The batch will typically start at row indicated by the pcRowIdent
               parameter, but may start on the row indicated by the piStartRow
               parameter.

  Parameters:
    INPUT piStartRow      - RowNum to start on. (? indicates that pcRowIdent
                            will determine the start of the batcvh to be 
                            returned.) 
    INPUT pcRowIdent      - An alternative to StartRow. pcRowIdent is either
                            "FIRST", "LAST" or a comma delimited list of DB
                            ROWIDs.  If it is "FIRST" (or "LAST") then the 
                            first (or last) batch of records in the data set
                            are retrieved and piStartRow is forced to ?. If
                            pcRowIdent is a comma delimited list of DB ROWIDs
                            then the batch will start with a RowObject
                            comprised of those records.
    INPUT plNext          - TRUE if query should perform NEXT/PREV (depending
                            on the direction of navigation) before starting
                            to return more rows.  In otherwords, "SKIP" to 
                            the next record at the start of the batch. 
    INPUT piRowsToReturn  - Maximum number of rows to be returned (negative
                            to move backwards in the result set).
    OUTPUT piRowsReturned - Actual number of rows returned.
    
  Notes:       Before returning, sendRows repositions the RowObject query to
               what was the current row when it started. The pcRowIdent
               argument is used by fetchRowIdent to allow query repositioning
               to a specific db query row.
------------------------------------------------------------------------------*/

 DEFINE INPUT  PARAMETER piStartRow     AS INTEGER   NO-UNDO.
 DEFINE INPUT  PARAMETER pcRowIdent     AS CHARACTER NO-UNDO.
 DEFINE INPUT  PARAMETER plNext         AS LOGICAL   NO-UNDO.
 DEFINE INPUT  PARAMETER piRowsToReturn AS INTEGER   NO-UNDO.
 DEFINE OUTPUT PARAMETER piRowsReturned AS INTEGER   NO-UNDO INIT 0.
 
 DEFINE VARIABLE hQuery        AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hBuffer       AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hFirstBuffer  AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hRowObject    AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hFldRowIdent  AS HANDLE  NO-UNDO.
 DEFINE VARIABLE hAppServer    AS HANDLE  NO-UNDO.
 DEFINE VARIABLE cASDivision   AS CHARACTER NO-UNDO.
 DEFINE VARIABLE rRowIDs       AS ROWID   EXTENT 10 NO-UNDO.
 DEFINE VARIABLE lOK           AS LOGICAL NO-UNDO.
 DEFINE VARIABLE iCnt          AS INTEGER NO-UNDO.
 DEFINE VARIABLE rCurrentRow   AS ROWID   NO-UNDO.
 DEFINE VARIABLE cStartRow     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cFirstRow     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cLastRow      AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cStartRowIds  AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cCurrentRow   AS CHARACTER NO-UNDO INIT "":U.
 DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
 DEFINE VARIABLE iRowNum       AS INTEGER   NO-UNDO.
 DEFINE VARIABLE lNexting      AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE hRowNum       AS HANDLE    NO-UNDO.
 DEFINE VARIABLE lRefresh      AS LOGICAL   NO-UNDO.
 DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
 DEFINE VARIABLE cContext      AS CHARACTER NO-UNDO.
 

  /* The RowObjectState property signals whether there are uncommitted
     changes. If so, we cannot get more rows from the database until
     changes are committed. */
  {get RowObjectState cStartRow}.
  IF cStartRow = 'RowUpdated':U THEN
    RETURN.

  /* Filter out invalid input parameters */
  IF piStartRow = 0 THEN piStartRow = ?.
  IF LOOKUP(pcRowIdent,"FIRST,LAST":U) > 0 THEN
    ASSIGN piStartRow = ?
           plNext     = no.

  /* Find out whether we're running with a query on an AppServer.
     If so then run a special client-to-server version of sendRows. 
     Or, if we are *on* the server, being run from serverSendRows,
     skip any references to the RowObject query. */
  {get ASDivision cASDivision}.
  {get RowObject hRowObject}.
  IF cASDivision = 'Client':U THEN
  DO:
    {get ServerOperatingMode cOperatingMode}.
    RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
    IF LOOKUP(pcRowIdent,"FIRST,LAST":U) > 0 THEN DO:
      hRowObject:EMPTY-TEMP-TABLE().
      {set FirstRowNum ?}.
      {set LastRowNum ?}.
      {set FirstResultRow ?}.
      {set LastResultRow ?}.
      {get ServerOperatingMode cOperatingMode}.
      {get ASHandle hAppServer}.
      IF VALID-HANDLE(hAppServer) THEN
        RUN doEmptyModTable IN hAppServer.
    END.  /* If first or last */
    RUN clientSendRows IN TARGET-PROCEDURE
      (piStartRow, pcRowIdent, plNext, piRowsToReturn, OUTPUT piRowsReturned).
    RUN changeCursor IN TARGET-PROCEDURE('':U).
    RETURN.
  END.
  ELSE IF cASDivision = 'Server':U THEN  /* Always empty RowObject on Server */
     hRowObject:EMPTY-TEMP-TABLE().
  
  /* If we're running locally or on a server, continue on... */
  {get QueryHandle hQuery}.
  IF NOT hQuery:IS-OPEN THEN
    {fn openQuery}.
  IF hQuery:IS-OPEN THEN 
  DO:
    RUN changeCursor IN TARGET-PROCEDURE('WAIT':U).
    {get DataHandle hDataQuery}.
    {get LastResultRow cLastRow}.
    {get FirstResultRow cFirstRow}.
    ASSIGN lNexting = (piRowsToReturn > 0)
           piRowsToReturn = ABS(piRowsToReturn).
        
    /* Check the RowIdent argument first; if this is set, it overrides the
       RowNum argument. */
    IF pcRowIdent NE ? AND pcRowIdent NE "":U THEN
    DO:
            
      /* First close the RowObject query and empty the current temp-table. 
         Reset all the associated properties and variables.
         NOTE: Check for transaction? Note also that this will be done
         later for skipping to an unrelated rownum too, yes? */
      /* Special case: If RowNum is also specified, then
         the caller wants to *refresh* one or more rows starting with
         pcRowIdent, and to give them numbers starting with
         piStartRow, so in that case, don't empty the current temp-table. */
      IF piStartRow EQ ? THEN
      DO:
        IF cASDivision NE "Server":U THEN DO:
          hDataQuery:QUERY-CLOSE().
          RUN doEmptyModTable IN TARGET-PROCEDURE.
        END.  /* IF Local (NOT Server and we don't get here if Client) */
        hRowObject:EMPTY-TEMP-TABLE().
        {set FirstRowNum ?}.
        {set LastResultRow ?}.
        {set LastRowNum ?}.
        {set FirstResultRow ?}.
        ASSIGN cFirstRow = ? cLastRow = ? lRefresh = no.
      END.  /* END plNext or Return > 1 */
      ELSE lRefresh = yes.   /* IF StartRow also there, signal refresh. */
      
      IF pcRowIdent = "Last":U THEN   /* Special signal for fetchLast */
      DO:
        ASSIGN lNexting = no           /* Last means work backwards */
               iRowNum = 2000000       /* All Rows will have high numbers */
                                       /* We know to go backwards whether */
               piRowsToReturn = ABS(piRowsToReturn).  /* Rows is + or - */
        hQuery:GET-LAST().
      END.  /* END DO IF 'Last' */
      ELSE IF pcRowIdent = "First":U THEN  /* Re-starting the query */
      DO:
        ASSIGN lNexting = yes
               iRowNum = 0.
        hQuery:GET-FIRST().
      END.  /* END DO IF 'First' */
      ELSE DO:           /* Reposition to a specific RowIdent */
        /* If StartRow is specified, use that
           RowNum as a starting number. */
        ASSIGN iRowNum = IF piStartRow NE ? THEN 
                    IF lNexting THEN piStartRow - 1
                    ELSE piStartRow + 1    /* Allow for incr/decr below. */
                  ELSE 2000000    /* Start with a high row num.*/
               rRowIDs = ?.       /* Fill in this array with the rowids. */
        DO iCnt = 1 TO NUM-ENTRIES(pcRowIdent):
          rRowIDs[iCnt] = TO-ROWID(ENTRY(iCnt, pcRowIdent)).
        END.        /* END DO iCnt */
        lOK = hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.
        IF lOK THEN
          hQuery:GET-NEXT().
        ELSE DO: /* This shouldn't be necessary but is a work around for
                   19990803-033  */
          hBuffer = hQuery:GET-BUFFER-HANDLE(1).
          hBuffer:BUFFER-RELEASE().
        END.  /* ELSE DO work-around */
      END.  /* END ELSE DO IF real RowIdent */
    END.    /* END DO pcRowIdent */
    ELSE DO:
      /* Starting in 9.0B, piStartRow of ? means either start at the
         beginning if no rows have been retrieved yet, or start at the
         current end of the retrieved rows (if RowsToReturn > 0) or the
         beginning of the retrieved rows (if RowsToReturn < 0). */
      cStartRow = IF lNexting THEN cLastRow ELSE cFirstRow.
      IF cStartRow = ? AND (piStartRow = 0 OR piStartRow = ?) THEN
        /* means no rows have been retrieved yet. */
      DO:
        hQuery:GET-FIRST().
        iRowNum = 0.                 /* Starting at the beginning. */
      END.    /* END DO IF No StartRow */
      ELSE DO:
        /* Reposition to the right starting point unless we're already there.*/
        DO iCnt = 1 TO hQuery:NUM-BUFFERS:  /* Assemble the list of rowids */
          ASSIGN hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt)
                 cCurrentRow = cCurrentRow + 
                  (IF cCurrentRow NE "":U THEN ",":U ELSE "":U)
                    + (IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U).
        END.   /* END DO iCnt */
        /* Format of First/LastResultRow is "RowNum;ROWID1[,...]ROWIDn" */
        cStartRowIds = ENTRY(2, cStartRow, ";":U).
        /* Restrict piStartRow to the same first or last
           RowNum that sendRows would have calculated on its own. If some
           other row is wanted which is already in RowObject, fetchRow
           will reposition to it. Otherwise RowNum is not meaningful. */
        iRowNum = INT(ENTRY(1, cStartRow, ";":U)).
        IF piStartRow NE ? AND piStartRow NE iRowNum THEN
        DO:
          RUN addMessage IN TARGET-PROCEDURE("Invalid RowNum argument to procedure sendRows.":U,
            ?, ?).
          RETURN ERROR.
        END.  /* END TEMPORARY error block. */

        IF cCurrentRow NE cStartRowIds THEN  /* If not already on right row. */
        DO:
          rRowIDs = ?.       /* Fill in this array with all the rowids. */
          DO iCnt = 1 TO NUM-ENTRIES(cStartRowIds):
            rRowIDs[iCnt] = TO-ROWID(ENTRY(iCnt, cStartRowIds)).
          END.        /* END DO iCnt */
          lOK = hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.
          IF lOK THEN hQuery:GET-NEXT().
        END.  /* END DO IF Not on StartRowIds */
      END.    /* END ELSE DO IF cStartRow NOT ? */
    END.      /* END ELSE DO IF no pcRowIdent */

    IF plNext THEN DO:
      IF lNexting THEN
        hQuery:GET-NEXT().
      ELSE hQuery:GET-PREV().
    END.  /* If plNext */
    
    ASSIGN hFirstBuffer = hQuery:GET-BUFFER-HANDLE(1)
           piRowsReturned = 0.
    Generate-Record-Blk:
    DO WHILE hFirstBuffer:AVAILABLE AND piRowsReturned < piRowsToReturn:
      hRowObject:BUFFER-CREATE().
      iRowNum = IF lNexting THEN iRowNum + 1
        ELSE iRowNum - 1.
      RUN transferDBRow IN TARGET-PROCEDURE
        ("":U /* Signal to use the current db row */, iRowNum).
      IF RETURN-VALUE = "ADM-ERROR":U          
      THEN DO:
        piRowsReturned = 0. /* NOTE: Error conditions? Do the right thing here. */
        RUN changeCursor IN TARGET-PROCEDURE('':U).
        RETURN.
      END.  /* END DO on error */

      /* Check to see if this record is already on the client */
      ASSIGN hFldRowIdent = hRowObject:BUFFER-FIELD("RowIdent")
             cRowIdent    = hFldRowIdent:BUFFER-VALUE.

      IF NOT lRefresh AND {fnarg canFindModRow cRowIdent} THEN 
      DO:
        /* Back out of this */
        hRowObject:BUFFER-DELETE().
        iRowNum = IF lNexting THEN iRowNum - 1
          ELSE iRowNum + 1.
        IF lNexting THEN hQuery:GET-NEXT().
        ELSE hQuery:GET-PREV().
        NEXT Generate-Record-Blk.
      END.  /* If record is all ready on the client */

      IF piRowsReturned = 0 THEN
      DO:               
        /* At the *start* of the loop, save off the rownum & id
           if we're Nexting and FirstResult isn't set, or vice versa. 
           Don't bother in the special "refresh" case where both RowNum and
           RowIdent are specified. */
        IF (NOT lRefresh) AND 
           ((lNexting AND cFirstRow = ?) OR
            ((NOT lNexting) AND cLastRow = ?)) THEN
        DO:
          cStartRow = STRING(iRowNum) + ';':U.
          DO iCnt = 1 TO hQuery:NUM-BUFFERS:
            hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt).
            cStartRow = cStartRow + 
              (IF iCnt > 1 THEN ",":U ELSE "":U) + 
                (IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U).
          END.  /* END DO iCnt */
          IF lNexting THEN
             {set FirstResultRow cStartRow}.
          ELSE {set LastResultRow cStartRow}.
        END.    /* END DO IF lNexting */
        /* We want to save off the Rowid of the first newly created
           RowObject row to reposition to before returning. */
        rCurrentRow = hRowObject:ROWID.
      END.  /* END DO IF RowsReturned = 0 */
      piRowsReturned = piRowsReturned + 1.
      IF piRowsReturned < piRowsToReturn THEN
      DO:
        IF lNexting THEN hQuery:GET-NEXT().
        ELSE hQuery:GET-PREV().
      END.      /* END DO IF not last RowToReturn */
    END.        /* END DO WHILE hFirstBuffer:AVAILABLE... */
    
    IF piRowsReturned > 0 THEN /* Repos. to where we were before we started. */
    DO:
      /* At the *end* of the loop, save off the final rownum & id.
         To do this, we must be prepared to go back to the first/last
         row if we've gone off the end. Again, don't bother if we're
         refreshing existing rows. */
      IF (NOT lRefresh) THEN
      DO:
        cStartRow = STRING(iRowNum) + ';':U.     
        DO iCnt = 1 TO hQuery:NUM-BUFFERS:
          hBuffer = hQuery:GET-BUFFER-HANDLE(iCnt).
          IF iCnt = 1 AND NOT hBuffer:AVAILABLE THEN
            IF lNexting THEN hQuery:GET-PREV().
            ELSE hQuery:GET-NEXT().
          cStartRow = cStartRow + 
            (IF iCnt > 1 THEN ",":U ELSE "":U) + 
              (IF hBuffer:AVAILABLE THEN STRING(hBuffer:ROWID) ELSE "":U).
        END.  /* END DO iCnt */
        IF lNexting THEN
          {set LastResultRow cStartRow}.
        ELSE {set FirstResultRow cStartRow}.
      END.    /* END DO IF NOT lRefresh */
      
      IF cASDivision NE "Server":U THEN
      DO:
        hDataQuery:QUERY-OPEN(). /* Re-open the Temp-Table query. */
        IF rCurrentRow = ? THEN
        DO:       /* This was our first fetch. Position BEFORE the first row. */
          hDataQuery:GET-FIRST().
          hDataQuery:GET-PREV().
        END.  /* END DO IF rCurrentRow = ? */
        ELSE hDataQuery:REPOSITION-TO-ROWID(rCurrentRow).
      END.    /* END DO IF NOT Server */
    END.      /* END DO IF RowsReturned > 0 */
    
    RUN changeCursor IN TARGET-PROCEDURE('':U).
  END.    /* END IF query IS-OPEN */
 
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPropertyList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPropertyList Procedure 
PROCEDURE setPropertyList :
/*------------------------------------------------------------------------------
  Purpose:     To set a list of properties taken from a CHR(3) delimitted list
               of "propCHR(4)value" pairs.
  
  Parameters:  
    INPUT pcProperties - the CHR(3) delimitted list of "propCHR(4)value" pairs
                         to be set.
  
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcProperties AS CHARACTER                    NO-UNDO.
  
  DEFINE VARIABLE iProp        AS INTEGER                             NO-UNDO.
  DEFINE VARIABLE cProp        AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cValue       AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE cSignature   AS CHARACTER                           NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER                             NO-UNDO.

  iCnt = NUM-ENTRIES(pcProperties,CHR(3)).
  DO iProp = 1 TO iCnt:
    /* Process Prop<->Value pairs */
    ASSIGN cProp  = ENTRY(iProp,pcProperties,CHR(3))
           cValue = ENTRY(2,cProp,CHR(4))
           cProp  = ENTRY(1,cProp,CHR(4)).

    /* Get the datatype of the property */
    cSignature = DYNAMIC-FUNCTION("Signature":U IN TARGET-PROCEDURE, "get":U + cProp).
    IF cSignature EQ "":U THEN  /* It wasn't found */
      DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "Property ":U + cProp + " not defined.":U).
    ELSE CASE ENTRY(2, cSignature):
      WHEN "CHARACTER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, cValue).
      WHEN "INTEGER":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, INT(cValue)).
      WHEN "LOGICAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE,
                         IF cValue = "YES" THEN yes ELSE no).
      WHEN "DECIMAL":U THEN
        DYNAMIC-FUNCTION("set":U + cProp IN TARGET-PROCEDURE, DEC(cValue)).
    END.  /* CASE on property type */
  END.  /* DO iProp = 1 TO NUM-ENTRIES */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitCommit Procedure 
PROCEDURE submitCommit :
/*------------------------------------------------------------------------------
  Purpose:     Called by submitRow to commit changes to the database.
  
  Parameters:  
    INPUT pcRowIdent - Identifier of the row to commit.  It is a comma delimited
                       list of ROWIDS.  The first entry is the ROWID of the 
                       RowObject Temp-Table containing the record to commit.
                       Subsequent entries (of the comma delimited list) are the
                       DB ROWIDs of the records to be modified.
    INPUT plReopen   - TRUE if the RowObject query is to be reopened and
                       repositioned to the RowObject record identified by 
                       pcRowIdent.
  
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcRowIdent AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER plReopen   AS LOGICAL   NO-UNDO.
  
  DEFINE VARIABLE lAutoCommit   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cReturn       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowObject    AS ROWID     NO-UNDO.
  DEFINE VARIABLE cQuery        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lBrowsed      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE hColumn       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER   NO-UNDO.


  IF DYNAMIC-FUNCTION("anyMessage":U IN TARGET-PROCEDURE) THEN
    RETURN "ADM-ERROR":U.    /* If there were any Data messages */
  
  ELSE DO:
    /* Tell others the update is done and to redisplay the rec if appropriate */
    RUN dataAvailable IN TARGET-PROCEDURE ("SAME":U).  /* not a different row. */    
    {get AutoCommit lAutoCommit}.
    IF lAutoCommit THEN DO:
      /* Go ahead with the DB transaction now. */
      RUN commitTransaction IN TARGET-PROCEDURE.
      cReturn = RETURN-VALUE.
    END.   /* END DO IF lAutoCommit */
    ELSE DO:
      cReturn = "":U.                /* success pending final Commit */
      {set RowObjectState 'RowUpdated':U}.
    END.  /* END ELSE DO IF Not AutoCommit */

    {get DataQueryBrowsed lBrowsed}.
    /* If doCreateUpdate told us to reopen (because a new record was added to the
       RowObject table), re-open the RowObject Query and reposition to the
       newly added row. */
    IF plReopen AND cReturn = "":U THEN DO:
      {get DataHandle hDataQuery}.
      hDataQuery:QUERY-CLOSE().
      hDataQuery:QUERY-OPEN().
      rRowObject = TO-ROWID(ENTRY(1,pcRowIdent)).
      IF lBrowsed THEN PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('NextEnd':U).
      hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
      
      IF NOT lBrowsed THEN /* Make this RowObject available */
        hDataQuery:GET-NEXT().

      /* Tell everybody about a potential change of QueryPosition. */
      {get QueryPosition cQuery}.
      
      IF cQuery = 'NoRecordAvailable':U THEN
        {set QueryPosition 'OnlyRecord':U}.
      /* NOTE: Otherwise we expect this new row to be at the end. */
      ELSE DO: 
        {get RowObject hRowObject}.
        {get LastRowNum iLastRow}.
        
        hColumn = hRowObject:BUFFER-FIELD('RowNum':U).
        IF hColumn:BUFFER-VALUE = iLastRow THEN
          {set QueryPosition 'LastRecord':U}.
        ELSE
          {set QueryPosition 'NotFirstOrLast':U}.
      END. /*else do (records was available) */

    END.   /* END DO IF lReopen and successfull */
  END.  /* END DO IF no validation errors */
       
  RETURN cReturn.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitForeignKey) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitForeignKey Procedure 
PROCEDURE submitForeignKey :
/*------------------------------------------------------------------------------
  Purpose:     Called from submitRow to define Foreign Key values for a new row.
  
  Parameters:
    INPUT pcRowIdent          - The RowIdent (a comma delimited list of ROWIDs
                                that uniquely identify the RowObject record) of
                                the new RowObject record to be stored in the
                                database.  Since this is a new record, only the
                                first ROWID (that of the RowObject itself) is
                                valid.  There are no DB ROWIDs because they
                                have not yet been created.
    INPUT-OUTPUT pcValueList  - A CHR(1) delimited list of ForeignField column
                                and value pairs to be set in the RowObject 
                                record identified by pcRowIdent.  On input it is
                                a list that has been set before submitForeignKey
                                was called.  On output it is the now current list
                                of foreign fields that have been set.
    INPUT-OUTPUT pcUpdColumns - A comma delimited list of column names that are
                                updatable in the SDO.
                                
    Notes:     The list of udpdatable fields (pcUpdColumns - derived from the
               UpdatableColumns property in submitRow) usually doesn't
               contain key fields.  However, because submitForiegnKey is called
               when creating a new RowObject record, key fields need to be 
               populated so pcUpdColumns is expanded to allow for this.  
               However, only the variable pcUpdColumns is expanded, the 
               UpdatableColumns property remains unchanged.
------------------------------------------------------------------------------*/
 
  DEFINE INPUT        PARAMETER pcRowIdent   AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcValueList  AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pcUpdColumns AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cForFields   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForValues   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataColumns AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cField       AS CHARACTER NO-UNDO.
  
  /* If this is a newly Added row (no db rowids in pcRowIdent, 
     and there are Foreign Fields, assign those values to the 
     RowObject columns. */
  IF NUM-ENTRIES(pcRowIdent) = 1 OR ENTRY(2, pcRowIdent) = "":U THEN
  DO:
    {get ForeignFields cForFields}.
    IF cForFields NE "":U THEN
    DO:
      {get ForeignValues cForValues}.
      {get DataColumns cDataColumns}.
      DO iCol = 1 TO NUM-ENTRIES(cForFields) By 2:
        cField = ENTRY(2, ENTRY(iCol, cForFields), ".":U).
        IF LOOKUP(cField, cDataColumns) NE 0 AND /* It's in the SDO, and */
           LOOKUP(cField, pcValueList, CHR(1)) = 0  /* not already assigned */
        THEN DO:
          ASSIGN pcValueList = cField + CHR(1) + 
                   ENTRY(INT((iCol + 1) / 2), cForValues, CHR(1)) 
                   + (IF pcValueList = "":U THEN "":U ELSE CHR(1)) 
                   + pcValueList
                 /* Make it updatable for Add if not already */
                 pcUpdColumns = cField + ",":U + pcUpdColumns.
        END.   /* END DO IF LOOKUP... */
      END.     /* END DO iCol         */
    END.       /* END DO IF cForFields NE "" */
  END.         /* END DO IF "Add"     */
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE submitValidation Procedure 
PROCEDURE submitValidation :
/*------------------------------------------------------------------------------
  Purpose:     To do validation on each of the columns of the a new RowObject 
               record, and on the record as a whole,  before committing it 
               to the database.

  Parameters:
    INPUT pcValueList  - A CHR(1) delimited list of Column Name<->value pairs
                         that need validation before committing a transaction.
    INPUT pcUpdColumns - A comma delimited list of the SmartDataObject columns
                         that are updatable.

  Notes:       There are three types of validation performed:
                 1) Newly entered data meets the format criteria.
                 2) Newly entered data is in an updatable field.
                 3) Any developer defined validation in the form of a
                    (FieldName)Validation procedure.
                 4) Any developer defined validation in the form of a
                    RowObjectValidation procedure for the whole row.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcValueList    AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcUpdColumns   AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iColNum     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColName    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hCol        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHAR   NO-UNDO.
  
  {get RowObject hRowObject}.
  
  DO iColNum = 1 TO NUM-ENTRIES(pcValueList,CHR(1)) BY 2:
    cColName = ENTRY(iColNum, pcValueList,CHR(1)).
    hCol = hRowObject:BUFFER-FIELD(cColName) NO-ERROR.
    IF hCol = ? THEN 
       RUN addMessage IN TARGET-PROCEDURE ("Column name ":U + cColName + 
         " not found in the SmartDataObject.":U, cColName, ?).
    ELSE DO:
      /* Verify that they're not trying to update a non-enabled field. */
      IF LOOKUP(cColName, pcUpdColumns) = 0 THEN
          RUN addMessage IN TARGET-PROCEDURE ("Column ":U + cColName + 
            " may not be updated.":U, cColName, ?).
      ELSE DO:
         cValue = ENTRY(iColNum + 1, pcValueList,CHR(1)).
         /* Check for unknown values in the list of changes. */
         hCol:BUFFER-VALUE = IF cValue = "?":U THEN ?
             ELSE cValue NO-ERROR.
        /* Allow for the possibility that the value they entered in the 
           View object may be completely invalid for the format associated 
           with the Frame field. */
        IF ERROR-STATUS:ERROR THEN
         RUN addMessage IN TARGET-PROCEDURE (? /* Use GET-MESSAGE */ , cColName, ?).
        ELSE DO:
          /* If there's a field validation procedure, run it. */
          RUN VALUE(hCol:NAME + 'Validate':U) IN TARGET-PROCEDURE 
            (hCol:BUFFER-VALUE) NO-ERROR. 
          /* The expectation is that such a procedure will return an error 
             message if there is one; we will log it for the column. 
             Otherwise the code assumes that an error-status simply means 
             there wasn't a validate procedure for this column. 
             We keep going even if there's a field error. */
          IF NOT ERROR-STATUS:ERROR AND   /* procedure was found and executed */
            /* NOTE: No longer checked? -> ERROR-STATUS:GET-NUMBER(1) NE 6456 THEN 
               (proc not found) - here and below */
            RETURN-VALUE NE "":U THEN
              RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, hCol:NAME, ?).
        END. /* END DO Validate procedure. */
      END.   /* END DO all column validation */
    END.     /* END DO check that column is updatable */
  END.       /* END DO for each updated column */
  
  /* If there's a user-defined validation procedure for the entire row,
     run that now. */
  RUN RowObjectValidate IN TARGET-PROCEDURE NO-ERROR.   
  IF NOT ERROR-STATUS:ERROR AND      /* Procedure was found and executed. */
    RETURN-VALUE NE "":U THEN
     RUN addMessage IN TARGET-PROCEDURE (RETURN-VALUE, ?, ?).

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-synchronizeProperties) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE synchronizeProperties Procedure 
PROCEDURE synchronizeProperties :
/*------------------------------------------------------------------------------
  Purpose:    To synchronize certain properties on both the client side of
              a SmartDataObject with its server side.
  
  Parameters:
    INPUT pcPropertiesForServer  - a CHR(3) delimitted list of "propCHR(4)value" 
                                   pairs to be set on the server half of the
                                   SmartDataObject.
    OUTPUT pcPropertiesForClient - a CHR(3) delimitted list of "propCHR(4)value"
                                   pairs to be set on the client half of the 
                                   SmartDataObject.

  Notes:      synchronizeProperties is designed to be invocated from the client
              side, but executed on the server half of a SmarttDataObject.
              While executing on the server side it calls setPropertiesList to
              set the properties in pcPropertiesForServer, then accumulates
              properties to be sent back to the client so that the client can
              set them.  Currently, the only property sent back is the
              ServerOperatingMode property.
              The form of both pcPropertiesForServer and pcPropertiesForClient
              is designed to work with the setPropertyList method.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcPropertiesForServer AS CHARACTER            NO-UNDO.
  DEFINE OUTPUT PARAMETER pcPropertiesForClient AS CHARACTER            NO-UNDO.
  
  DEFINE VARIABLE cServerOperatingMode AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE cLastRow             AS CHARACTER                     NO-UNDO.
  DEFINE VARIABLE iCnt                 AS INTEGER                       NO-UNDO.
  DEFINE VARIABLE rRowIDs              AS ROWID     EXTENT 10           NO-UNDO.
  DEFINE VARIABLE lOK                  AS LOGICAL                       NO-UNDO.
  DEFINE VARIABLE hQuery               AS HANDLE                        NO-UNDO.
  
  RUN setPropertyList IN TARGET-PROCEDURE (pcPropertiesForServer).
  
  /* Reposition the database query if this is part of a stateless restart */
  IF INDEX(pcPropertiesForServer,"LastResultRow") > 0 THEN DO:
    {get LastResultRow cLastRow}.
    IF cLastRow NE ? THEN DO:
      cLastRow = ENTRY(2,cLastRow,";").
      DO iCnt = 1 TO NUM-ENTRIES(cLastRow):
        rRowIDs[iCnt] = TO-ROWID(ENTRY(iCnt, cLastRow)).
      END.        /* END DO iCnt */
      {fn openQuery}.
      {get QueryHandle hQuery}.
      lOK = hQuery:REPOSITION-TO-ROWID(rRowIDs) NO-ERROR.
    END. /* If last row is a valid RowIdent */
  END.

  {get ServerOperatingMode cServerOperatingMode}
  pcPropertiesForClient = "ServerOperatingMode":U + CHR(4) + cServerOperatingMode.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-undoTransaction) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE undoTransaction Procedure 
PROCEDURE undoTransaction :
/*------------------------------------------------------------------------------
  Purpose:     To undo any uncommitted changes to the RowObject table when the
               "Undo" button is pressed in the commit panel.

  Parameters:  <none>

  Notes:       undoTransaction calls doUndoTrans to restore the RowObject 
               Temp-Table and empty the RowObjUpd Temp-Table.
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE rRowObject  AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE  NO-UNDO.
  
  /* NOTE: Perhaps there should be a "Are You Sure" message for this. */
  
  /* Restore the RowObject Temp-Table and empty the RowObjUpd Temp-Table.
     This is done in a separate procedure in data.i for simplicity, and
     to support the needed BUFFER-COPY statements. */
  
  RUN doUndoTrans IN TARGET-PROCEDURE.
     
  /* Now reopen the RowObject query, in order to refresh any dependent 
     SmartDataBrowser, reposition to the previously current row, and do
     dataAvailable to refresh that row in SmartDataViewers and other objects. */
    
  {get DataHandle hDataQuery}.
  hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
  rRowObject = hRowObject:ROWID.
  hDataQuery:QUERY-CLOSE().
  hDataQuery:QUERY-OPEN().
  hDataQuery:REPOSITION-TO-ROWID(rRowObject) NO-ERROR.
  IF NOT hRowObject:AVAILABLE THEN
    hDataQuery:GET-NEXT().   /* next if needed (for Viewer, not Browser target)*/
  
  PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
 
  {set RowObjectState 'NoUpdates':U}.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateState Procedure 
PROCEDURE updateState :
/*------------------------------------------------------------------------------
  Purpose:     To passes along update-related messages (to its 
               Navigation-Source, e.g) and to adjust the DataModified property.
               
  Parameters:  
    INPUT pcState - A indicator of the state of a an updatable record. Valid
                    values are:
                      'UpdateBegin'    -  The user has indicated that an update
                                          will take place (either by pressing
                                          the Update button in a panel, or by
                                          entering an updatable field in a
                                          browser.)
                      'Update'         -  An update is in progress in another
                                          object (a viewer or browser.)
                      'UpdateEnd'      -  A save has completed (same as
                                          'UpdateComplete'.)
                      'UpdateComplete' -  Any changes to the RowObject
                                          Temp-Table have either been 
                                          committed or backed out.
               
  Notes:       The SmartDataObject also saves its own "copy" of the 
               DataModified property, set true when updateState is 'Update' 
               and false when updateState is 'UpdateComplete', so that it 
               can be queried by other objects (such as other dataTargets).  
               If we get the 'UpdateComplete' state from another SDO
               (not our own TARGET-PROCEDURE), then we wait until we get
               the rowObjectState of 'NoUpdates' before passing it on,
               if there's a Commit Panel for that other object.    
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pcState AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE lModified AS LOGICAL NO-UNDO INIT ?.
  DEFINE VARIABLE lCommit   AS LOG     NO-UNDO INIT ?.

  IF pcState = 'UpdateComplete':U AND 
    SOURCE-PROCEDURE NE TARGET-PROCEDURE THEN
  DO:
    /* Find out if the event came from an object with AutoCOmmit turned
       off, and suppress passing it on in that case. Do this NO-ERROR
       because the event may come from a dvis object with no AutoCommit. */
    lCommit = DYNAMIC-FUNCTION('getAutoCommit':U IN SOURCE-PROCEDURE) NO-ERROR.
    IF lCommit = NO THEN
        RETURN.
  END.
       

  IF pcState = 'Update':U THEN
    lModified = yes.
  ELSE IF pcState = 'UpdateComplete':U THEN
    lModified = no.
  {set DataModified lModified}.
  
  PUBLISH 'updateState':U FROM TARGET-PROCEDURE (pcState).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-addRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION addRow Procedure 
FUNCTION addRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new RowObject temp-table record, initializes it, and
               returns a list of ColumnName<->Value pairs to be displayed by
               the SmartDataViewer that called this procedure.
  
  Parameters:
    INPUT pcViewColList - comma-separated list of columns names that are to
                          be displayed in the SmartDataViewer that called
                          addRow.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cColList   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowid     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cForFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForValues AS CHARACTER NO-UNDO.

      {get RowObject hRowObject}.
    /* Save off the "current" rowid in case the add is cancelled. 
       If there's no RowObject record available, it's because we're
       being browsed from outside, so use the Browser's RowIdent. */
    IF hRowObject:AVAILABLE THEN
      {set CurrentRowid hRowObject:ROWID}.
    ELSE DO:
      /* ... or it might just be because we're adding multiple new
         rows at a time or for some other reason, so SOURCE-PROC may not be
         a SmartObject. In that case RowIdent will come back Unknown. 
         Use dynamic-function in case the object has no such property. */
      cRowid = DYNAMIC-FUNCTION('getRowIdent':U IN SOURCE-PROCEDURE) NO-ERROR.
      cRowid = ENTRY(1, cRowid).
      IF cRowid = ? THEN cRowid = "":U.  /* NOTE: On 2nd txn add. Is this OK? */
      {set CurrentRowid TO-ROWID(cRowid)}.
    END.   /* END No RowObject Available */  
    
    hRowObject:BUFFER-CREATE().

    {get DataColumns cColList}.
    iColCount = NUM-ENTRIES(cColList).
    DO iCol = 1 TO iColCount:
      hColumn = hRowObject:BUFFER-FIELD(iCol).
      hColumn:BUFFER-VALUE = 
        IF hColumn:INITIAL = ? THEN "":U
        ELSE IF hColumn:DATA-TYPE = "DATE":U AND hColumn:INITIAL = "TODAY":U THEN
          STRING(TODAY)
        ELSE hColumn:INITIAL NO-ERROR.   /* INITIAL is always CHARACTER. */
    END.

    /* If there are Foreign Fields, assign their values as initial
       values for those columns. */
    {get ForeignFields cForFields}.
    IF cForFields NE "":U THEN
    DO:
      {get ForeignValues cForValues}.
      /* Each ForField pair is db name, RowObject name */
      DO iCol = 1 TO NUM-ENTRIES(cForFields) BY 2:
        hColumn = hRowObject:BUFFER-FIELD(ENTRY(2, ENTRY(iCol, cForFields), ".":U))
          NO-ERROR.
        IF VALID-HANDLE(hColumn) THEN  /* might not be in SDO */
          hColumn:BUFFER-VALUE = ENTRY(INT((iCol + 1) / 2), cForValues, CHR(1)).
      END.  /* END DO iCol */
    END.    /* END DO IF cForFields NE "" */
    
    /* set RowNum and first last status */  
    {fnarg newRowObject 'Add':U}.

    RETURN {fnarg colValues pcViewColList}.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnColumnLabel Procedure 
FUNCTION assignColumnColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcLabel AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Column Label text of a specified column.

  Parameters:  
    INPUT pcColumn - The name of the column that will have its Column Label
                     changed.
    INPUT pcLabel  - The new Column Label text
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol NE ? THEN hCol:COLUMN-LABEL = pcLabel.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnFormat Procedure 
FUNCTION assignColumnFormat RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcFormat AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Format text of a specified column.

  Parameters:  
    INPUT pcColumn - The name of the column that will have its FORMAT string
                     changed.
    INPUT pcFormat - The new format string
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol NE ? THEN hCol:FORMAT = pcFormat.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnHelp Procedure 
FUNCTION assignColumnHelp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcHelp AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Help text of a specified column.

  Parameters:  
    INPUT pcColumn - The name of the column that will have its HELP text changed.
    INPUT pcHelp   - The new help text
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol NE ? THEN hCol:HELP = pcHelp.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnLabel Procedure 
FUNCTION assignColumnLabel RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcLabel AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Label text of a specified column.

  Parameters:  
    INPUT pcColumn - The name of the column that will have its Label
                     changed.
    INPUT pcLabel  - The new Label text
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol NE ? THEN hCol:LABEL = pcLabel.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnMandatory Procedure 
FUNCTION assignColumnMandatory RETURNS LOGICAL
  ( pcColumn AS CHARACTER, plMandatory AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Mandatory attribute of a specified column.

  Parameters:  
    INPUT pcColumn    - The name of the column that will have its Mandatory 
                        attribute changed.
    INPUT plMandatory - The new mandatory setting: yes/no
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol = ? THEN RETURN FALSE.
  ELSE DO:
    hCol:MANDATORY = plMandatory. 
    RETURN TRUE.
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnPrivateData Procedure 
FUNCTION assignColumnPrivateData RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcData AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Private-data attribute of a specified column.

  Parameters:  
    INPUT pcColumn - The name of the column that will have its Private-data string
                     changed.
    INPUT pcData   - The new Private-data string
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol NE ? THEN hCol:PRIVATE-DATA = pcData.
  RETURN IF hCol = ? THEN FALSE ELSE TRUE.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnValExp Procedure 
FUNCTION assignColumnValExp RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcValExp AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Validation Expression of a specified column.

  Parameters:  
    INPUT pcColumn - The name of the column that will have its Validation
                     Expression changed.
    INPUT pcValExp - The new Validation Expression.
    
  Notes:       This will not actually change the column's validation which
               gets irrevocably set at compile time.  However, it can be 
               retrieved by an object and then used to generate validation 
               code for the column.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol = ? THEN RETURN FALSE.
  ELSE DO:
    hCol:VALIDATE-EXPRESSION = pcValExp. 
    RETURN TRUE.
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-assignColumnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION assignColumnValMsg Procedure 
FUNCTION assignColumnValMsg RETURNS LOGICAL
  ( pcColumn AS CHARACTER, pcValMsg AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the Progress Validation Message text of a specified column.

  Parameters:  
    INPUT pcColumn - The name of the column that will have its Validation
                     Message changed.
    INPUT pcValMsg - The new Validation Message text.
    
  Notes:       This will not actually change the column's message which
               gets irrevocably set at compile time.  However, it can be 
               retrieved by an object and then used to generate a
               message on some sort of dynamic validation.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn).
  IF hCol = ? THEN RETURN FALSE.
  ELSE DO:
    hCol:VALIDATE-MESSAGE = pcValMsg. 
    RETURN TRUE.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-cancelRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cancelRow Procedure 
FUNCTION cancelRow RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Cancels an Add, Copy, or Save operation.
  
  Parameters:  <none>
  
  Notes:       cancelRow calls doUndoUpdate which restores the original values
               of a modified row from the RowObjUpd record then deletes the
               RowObjUdp record.  In the cases of an Add or a Copy, both the
               new RowObject and the RowObjUpd records are deleted.  After all
               of this work has been done, doUndoUpdate repositions the 
               RowObject temp-table to what was previously the current row.
               This is all done in doUndoUpd because direct access to the 
               tables in the data.i include file greatly simplifies the code.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hField        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE rRowObject    AS ROWID     NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cError        AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE lNew          AS LOG       NO-UNDO.

 {get NewRow lNew}.
 RUN doUndoUpdate IN TARGET-PROCEDURE.

 /* Tell the data-targets that we're back in business */
 IF lNew THEN
   PUBLISH "dataAvailable":U FROM TARGET-PROCEDURE ('DIFFERENT':U).

 RETURN cError.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-closeQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION closeQuery Procedure 
FUNCTION closeQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Closes the RowObject temp-table query on both the client side
               and the server side (if the SmartDataObject is split.)  Then
               calls SUPER (which resolves to closeQuery in query.p) to close
               the database query.
 
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataQuery  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hAppServer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lReturnCode AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContext    AS CHARACTER NO-UNDO.
  
  {get DataHandle hDataQuery}.  /* Close the RowObject query. */
  IF VALID-HANDLE(hDataQuery) THEN
  DO:
    hDataQuery:QUERY-CLOSE().
    {set FirstRowNum ?}.
    {set LastRowNum ?}.
    {set FirstResultRow ?}.
    {set LastResultRow ?}.
    hRowObject = hdataQuery:GET-BUFFER-HANDLE(1).
    hRowObject:BUFFER-RELEASE().
    /* Don't do QueryPosition and dataAvailable if we're just closing
       a query to re-open it, because these cause unnecessary flashing. */
    IF ENTRY(1, PROGRAM-NAME(2), " ":U) NE 'openQuery':U AND
       ENTRY(1, PROGRAM-NAME(3), " ":U) NE 'openQuery':U THEN
    DO:
      {set QueryPosition 'NoRecordAvailable'}.
      PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE("DIFFERENT":U).
    END.

   /* Empty the current RowObject table.  Note that the buffer method works 
      only if there is no transaction active, so do it "by hand" if there is 
      one. */
    IF NOT TRANSACTION THEN
    DO:
      hBuffer = hDataQuery:GET-BUFFER-HANDLE(1).
      hBuffer:EMPTY-TEMP-TABLE().
    END.  /* END IF NOT TRANS */
    ELSE
      RUN doEmptyTempTable IN TARGET-PROCEDURE. 

    /* Empty the modification record temp-table */
    RUN doEmptyModTable IN TARGET-PROCEDURE.
  END.  /* If valid-handle */
  
  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO:           /* If we're just the client then tell the AppServer to close. */
    {get ASHandle hAppServer}.
    IF VALID-HANDLE(hAppServer) THEN DO:
      lReturnCode = {fn closeQuery hAppServer}.
      {get ServerOperatingMode cOperatingMode}.
      IF cOperatingMode = 'STATELESS':U THEN DO:
        RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
        RUN setPropertyList IN TARGET-PROCEDURE (cContext).
      END.  /* If Stateless */
      RETURN(lReturnCode).
    END. /* If a valid hAppServer */
    ELSE RETURN FALSE.
  END.    /* END DO IF Client */
  ELSE RETURN SUPER(). /* Get query.p's version of this to close the db query. */
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnColumnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnColumnLabel Procedure 
FUNCTION columnColumnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Column Label of a specified column.
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.  
  Note:        If no Column Label have been specified, then the Label 
               is returned.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  IF NOT VALID-HANDLE(hCol) THEN
    RETURN ?.

  RETURN IF hCol:COLUMN-LABEL = ? 
         THEN {fnarg columnLabel pcColumn}
         ELSE hCol:COLUMN-LABEL.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnDataType) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnDataType Procedure 
FUNCTION columnDataType RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress datatype of a specified column.
  
  Parameters:
    INPUT pcColumn - a column name, either a RowObject fieldname or a
                     qualified DB fieldname of a table in the DB query.
  
  Note:        columnDataType recognizes that pcColumn is a qualified DB
               fieldname based on the presence of a period (".").
               If pcColumn is a qualified DB fieldname and columnDataType is
               called on the client side of the SmartDataObject, an attempt is 
               made to resolve this on the client. First by using the mapped 
               SmartDataObject name in a recursive call to columnDataType.  If
               this fails, and there is a ForeignFields property, the 
               corresponding data source field is queried via this function.
               As a last resort columnDataType is called on the Server side.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol           AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE NO-UNDO.
  DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataColumn    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cDataType      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cForeignFields AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContext       AS CHARACTER NO-UNDO.
 
  /* If not Qualified check the RowObject */
  IF INDEX(pcColumn,".":U) = 0 THEN
  DO:         
    {get RowObject hRowObject}.
    hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
    RETURN IF hCol = ? THEN ? ELSE hCol:DATA-TYPE.     
  END. /* if index(pccolumn,".") = 0 ie RowObject */
  ELSE DO:  
    {get ASDivision cASDivision}.
    IF cASDivision = 'Client':U THEN
    DO:
      ASSIGN
        cDataType = ?
        /* get the mapped RowObject column */
        cDataColumn = {fnarg dbColumnDataName pcColumn}.            
      IF cDataColumn <> "":U THEN 
        cDataType   = {fnarg columnDataType cDataColumn}. 
            
      /* The database field was not defined in the sdo so we will try to get the
         datatype from other sources */            
      IF cDataType = ? THEN
      DO:              
        /* If we have a linked DataSource we can get the data-type from the 
           ForeignFields property's source entry */                            
        {get DataSource hDataSource}.                     
        IF VALID-HANDLE(hDataSource) THEN
        DO:             
          {get ForeignFields cForeignFields}.                  
          IF LOOKUP(pcColumn,cForeignFields) > 0 THEN 
            ASSIGN 
              /* 2nd of pair is source RowObject fld */
              cDataColumn = ENTRY(LOOKUP(pcColumn,cForeignfields) + 1,
                                  cForeignFields)                           
              cDataType = {fnarg columnDataType cDataColumn hDataSource}.
        END. /* if valid-handle(hDataSource) */
                         
        /* If data-type still is unknown, the field is not mapped in the SDO 
           and not found in the datasource so we pass the call to the server.*/
        IF cDataType = ? THEN
        DO: 
          {get ASHandle hAppServer}.                  
          cDataType = {fnarg columnDataType pcColumn hAppServer}.
          {get ServerOperatingMode cOperatingMode}.
          IF cOperatingMode = 'STATELESS':U THEN DO:
            RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
            RUN setPropertyListIN TARGET-PROCEDURE (cContext).
          END.  /* If Stateless */
        END. /* END DO cDatatype = ? */        
      END.  /* END DO cDatatype = ? */
      RETURN cDataType.       
    END. /* END DO client */
    ELSE 
      RETURN SUPER(pcColumn). 
  END. /* qualified column */
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
 Notes:       We run this on AppServer because it calls more than one 
              AppServer function. ( getTables, getAssignList ) 
              and we assume that one call that returns one field is more 
              efficient than two calls that returns a list.  
              getTables() and getAssignList both currently need to be called 
              on the server (may be changed in the future):  
                getTables() currently gets it's data directly form the query.
                AssignList is only on the server because it uses getTables when 
                it's buildt. 
 -----------------------------------------------------------------------------*/

  /* Determine where to direct this request - client or server */
  {src/adm2/cltorsvr.i columnDbColumn Char pccolumn}

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnExtent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnExtent Procedure 
FUNCTION columnExtent RETURNS INTEGER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress extent of a specified column.
  
  Parameters:  
    INPUT pcColumn - column name of the RowObject field being queried.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:EXTENT.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnFormat) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnFormat Procedure 
FUNCTION columnFormat RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress format of a specified column.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:FORMAT.   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnHelp Procedure 
FUNCTION columnHelp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Help text of a specified column.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:HELP.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnInitial) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnInitial Procedure 
FUNCTION columnInitial RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the initial value for a specified field as a character
               string with the field FORMAT applied.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
  
  Notes:       Example: If the value of a numeric field is 123456789 and the
                        format is "999-99-9999", columnInitial would return
                        a character string containing "123-45-6789".
-----------------------------------------------------------------------------*/

  DEFINE VARIABLE hColumn    AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
    {get RowObject hRowObject}.
    hColumn = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
    
    IF VALID-HANDLE(hColumn) THEN
    DO:
      IF hColumn:INITIAL = ? THEN 
        RETURN "":U.
      ELSE IF hColumn:DATA-TYPE = "DATE":U AND hColumn:INITIAL = "TODAY":U THEN
        RETURN STRING(TODAY).
      ELSE 
        RETURN hColumn:INITIAL.   /* INITIAL is always CHARACTER. */
    END. /* valid-handle(hcolumn) */
    RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnLabel) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnLabel Procedure 
FUNCTION columnLabel RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Label of a specified column.

  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
  
  Note:       If no label have been specified, then the column name is return.
              Use ColumnColumnLabel to get the column-label (for browsers) 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  
  IF NOT VALID-HANDLE(hCol) THEN
    RETURN ?.

  RETURN IF hCol:LABEL = ? THEN hCol:NAME ELSE hCol:LABEL.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnMandatory) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnMandatory Procedure 
FUNCTION columnMandatory RETURNS LOGICAL
  (pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:      Returns a flag (True or False) indicating whether a specified
                column is Mandatory or not.
  Parameters:   
    INPUT pcColumn - the column name of the RowObject field being queried.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:MANDATORY.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnModified Procedure 
FUNCTION columnModified RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns true if a specified column has been modified in the 
               RowObject record.
  
  Parameters:  
    INPUT pcColumn - column name of the RowObject field being queried.
  
  Notes:       NOTE: The only way to do this is to see if the row has been
               modified and then compare the changed and unchanged copies; 
               there's no MODIFIED attribute on the BUFFER-FIELD.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowQuery  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowNum    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lChanged   AS LOGICAL   NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT hRowObject:AVAILABLE THEN
      RETURN ?.
  hColumn = hRowObject:BUFFER-FIELD('RowMod':U).
  IF hColumn:BUFFER-VALUE = "U":U THEN
  DO:
    /* The row has been changed; now get the unchanged copy and see if this
       *column* has been changed. This requires defining a query for that row. */
      hColumn = hRowObject:BUFFER-FIELD(pcColumn).
      cValue = hColumn:STRING-VALUE.  /* Save off the value from the updated row. */
      hColumn = hRowObject:BUFFER-FIELD('RowNum':U).
      cRowNum = hColumn:STRING-VALUE. /* ...also the row number of the row. */
      {get RowObjUpd hRowObject}.
      CREATE QUERY hRowQuery.
      hRowQuery:SET-BUFFERS(hRowObject).
      hRowQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U + 
         cRowNum).
      hRowQuery:QUERY-OPEN().
      hRowQuery:GET-FIRST().
      hColumn = hRowObject:BUFFER-FIELD(pcColumn).
      lChanged = (hColumn:STRING-VALUE <> cValue).
      DELETE WIDGET hRowQuery.
  END. /* if hColumn:BUFFER-VALUE = "U" */
  
  RETURN lChanged.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnPrivateData) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnPrivateData Procedure 
FUNCTION columnPrivateData RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Private-Data attribute of a specified column.
  
  Parameters:  
    INPUT pcColumn - column name of the RowObject field being queried.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:PRIVATE-DATA.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnProps) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnProps Procedure 
FUNCTION columnProps RETURNS CHARACTER
  ( pcColList AS CHARACTER, pcPropList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of all requested properties for all the requested
               columns of the RowObject table.  If the pcColList parameter is 
               "*", then all the columns in the RowObject Column List.
  
  Parameters:
    INPUT pcColList  - comma-seperated list of column names for which properties
                       are to be returned.  "*" indicates all of the columns in
                       the DataObject.
    INPUT pcPropList - comma-separated list of properties to be returned.
                       Valid list items are: DataType, Extent, Format, Help,
                       Initial, Label, Mandatory, Modified, PrivateData,
                       QuerySelection, ReadOnly, StringValue,ValExp, ValMsg
                       and Width.
  
  Notes:       Returns a character string of <col1Props> CHR(3) <col2Props> ...
               where each <colnProps> is of the form:
                  <columnName> CHR(4) Prop1Value> CHR(4) Prop2Value ... 
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iProp      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iColCount  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iPropCount AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cColumn    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cProp      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cColProps  AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cPropValue AS CHARACTER NO-UNDO.
  
  IF pcColList = "*":U THEN
    {get DataColumns pcColList}.
  
  ASSIGN iColCount  = NUM-ENTRIES(pcColList)
         iPropCount = NUM-ENTRIES(pcPropList).
         
  DO iCol = 1 TO iColCount:
    cColumn = TRIM(ENTRY(iCol, pcColList)).
    cColProps = cColProps + cColumn + CHR(4).
    DO iProp = 1 TO iPropCount:
      cProp = TRIM(ENTRY(iProp, pcPropList)).
      /* Note that for now at least we suppress errors and leave it up
       to the caller to make sure that all column names and properties 
       are valid.*/
      cPropValue = STRING(dynamic-function 
          ("column":U + cProp IN TARGET-PROCEDURE, cColumn)) NO-ERROR.
      cColProps = cColProps + 
        (IF cPropValue = ? THEN "" ELSE cPropValue) +
          (IF iProp < iPropCount THEN CHR(4) ELSE "":U).
    END.  /* END DO iProp */
    cColProps = cColProps + (IF iCol < iColCount THEN CHR(3) ELSE "":U).
  END.    /* END DO iCol  */
  
  RETURN cColProps.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnQuerySelection) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnQuerySelection Procedure 
FUNCTION columnQuerySelection RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
 Purpose:      Returns a CHR(1) separated string with ALL operators and values 
               that has been added to the Query for this column using the 
               assignQuerySelection method. 
               
               Example: If the query contains 'custnum > 5 and custnum < 9' 
                        this function will return (chr(1) is shown as '|'): 
                        '>|5|<|9'    
                              
  Parameters:
   INPUT pcColumn - A column in the RowObject. 
                    - unqualifed or qualified with RowObject.                       
                    Qualified field names will be passed directly to the
                    super procedure:   
                    - TBL.FLDNM or DB.TBL.FLDNM (only if qualified with db),
 
  Notes:       This override is needed to take a rowobject column as input and 
               pass the mapped database column to the super procedure in query.p   
               The data returned reflects the QueryString/QueryColumns properties, 
               which is maintained by the assignQuerySelection. These values
               may not have been used in an openQuery yet.               
------------------------------------------------------------------------------*/
  IF pcColumn BEGINS "RowObject." THEN
    pcColumn = ENTRY(2,pcColumn,".":U).
  
  /* Find the mapped database column */
  IF INDEX(pcColumn,".":U) = 0 THEN
    pcColumn = {fnarg columnDBColumn pcColumn}.            
   
    /* Call the query version */  
  RETURN SUPER(pcColumn). 
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnReadOnly Procedure 
FUNCTION columnReadOnly RETURNS LOGICAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if a specified column is READ-ONLY in the 
               SmartDataObject, that is, if it is not in the list of Updatable
               Columns.

  Parameters:
    INPUT pcColumn - column name of the RowObject temp-table that is being
                     queried.
  
  Notes:       A visualization may use this dynamically to determine whether 
               the field should be updatable on the screen.  Even still, there
               may be circumstances where it is desirable to have it updatable
               on the screen but if it is READ-ONLY in the SmartDataObject any
               changes sent back to the SmartDataObject will not be made in
               the RowObject temp-table and, therefore, in the database.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cUpdatable   AS CHARACTER NO-UNDO.
  
  {get UpdatableColumns cUpdatable}.
  RETURN LOOKUP(pcColumn, cUpdatable) = 0.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnStringValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnStringValue Procedure 
FUNCTION columnStringValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the STRING-VALUE of a specified column in the 
               SmartDataObject RowObject buffer.  The STRING-VALUE is the value
               of a field expressed as a character string formatted according
               to the columns FORMAT expression.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  IF NOT hRowObject:AVAILABLE THEN
      RETURN ?.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? 
    ELSE hCol:STRING-VALUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnTable Procedure 
FUNCTION columnTable RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*-----------------------------------------------------------------------------
  Purpose:     Returns the database table name of the column mapped to a
               SmartDataObjects RowObject column or the correct .               
  Parameters: INPUT pcColumn 
              - column name of the RowObject field being queried
                or a qualified database column.                   
      Notes: For a qualified databasecolumn the return table may remove or
             add database name according to the queries db qualification.       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDbColumn AS CHAR   NO-UNDO.
  DEFINE VARIABLE cTable    AS CHAR   NO-UNDO.
  
  IF NUM-ENTRIES(pcColumn,".":U) = 1 THEN
  DO:
    cDbColumn = {fnarg columnDbColumn pcColumn}.
    
    IF cDbColumn <> "":U THEN 
    DO:
      /* Remove the field part */  
      ENTRY(NUM-ENTRIES(cDbColumn,".":U),cDbColumn,".":U) = "":U.
      RETURN RIGHT-TRIM(cDbColumn,".":U). 
    END. /* if cDbColumn  <> '' */
    ELSE 
      RETURN "":U.   /* For readability and clarity. We might as well 
                        have returned the right-trim(cDbcolumn,".") */ 
  END. /* unqualified pcColumn */ 

  /* qualified columns must be checked against the query in order to verify 
     that a database reference in the column is correct when the query is 
     unqualified or to add correct database if column is unqualifed  */

  {src/adm2/cltorsvr.i columnTable Char pcColumn}
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValExp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValExp Procedure 
FUNCTION columnValExp RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Validation expression for a specified column
               in the SmartDataObjects RowObject Temp-table.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:VALIDATE-EXPRESSION.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValMsg) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValMsg Procedure 
FUNCTION columnValMsg RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the Progress Validation message for a specified column
               of the SmartDataObjects RowObject temp-table.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject temp-table field being
                     queried.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:VALIDATE-MESSAGE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnValue) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnValue Procedure 
FUNCTION columnValue RETURNS CHARACTER
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the UNFORMATTED character value of a specified column 
               in the SmartDataObject RowObject buffer.  
Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
     Note:     This is different from columnStringValue which returns the 
               formatted value.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE STRING(hCol:BUFFER-VALUE).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-columnWidth) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION columnWidth Procedure 
FUNCTION columnWidth RETURNS DECIMAL
  ( pcColumn AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the width (in character units) of a specified column in
               the SmartDataObjects RowObject temp-table.
  
  Parameters:
    INPUT pcColumn - column name of the RowObject field being queried.
  
  Notes:       The width is setable inside of the column editor when editing
               the fields of the SmartDataObject.  However, its default is
               based on the numbers of characters needed to satisfy the
               FORMAT expression assigned to the field.
               The width may be used as a reference by the visualization, but
               the visualization doesn't necessarily use the same width.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hCol       AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.

  {get RowObject hRowObject}.
  hCol = hRowObject:BUFFER-FIELD(pcColumn) NO-ERROR.
  RETURN IF hCol = ? THEN ? ELSE hCol:WIDTH-CHARS.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-colValues) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION colValues Procedure 
FUNCTION colValues RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a CHR(1) delimited list of values for the requested
               columns (in pcViewColList) of the current row of the RowObject.
               The first value is the RowObect ROWID and RowIdent separated 
               with a comma.  Subsequent values are formatted according to the
               columns FORMAT expression.
   
  Parameters:
    INPUT pcViewColList - Comma delimited list of RowObject column names
  
  Notes:       The form of the first value is:
                 <RowObject ROWID>,<DB Buffer1 ROWID>,<DB Buffer2 ROWID>,...
               This is used as a key to uniquely identify the row and its
               origins in the optimistic locking system.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cColValues  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCol        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hColumn     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iColCount   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER NO-UNDO.
  
  {get RowObject hRowObject}.     

   IF hRowObject:AVAILABLE THEN 
   DO:    
     /* The first value passed back is always a "key" consisting of the RowObject
        ROWID plus the ROWIDs of the individual db records which make up the row. */
     ASSIGN 
       cColValues = STRING(hRowObject:ROWID) + ",":U
       hColumn    = hRowObject:BUFFER-FIELD('RowIdent':U)
       cColvalues = cColValues + hColumn:BUFFER-VALUE + CHR(1)
       iColCount  = NUM-ENTRIES(pcViewColList).

     DO iCol = 1 TO iColCount:
       hColumn = hRowObject:BUFFER-FIELD(ENTRY(iCol, pcViewColList)) NO-ERROR.
       IF NOT VALID-HANDLE(hColumn) THEN
       DO:
         /* If the column was not found in this object, look to see
            if this object has a parent that can supply it. */
         {get DataSource hDataSource}.
         IF VALID-HANDLE(hDataSource) THEN
         DO:
           cValue = DYNAMIC-FUNCTION('colValues':U IN hDataSource,
                                      ENTRY(iCol, pcViewColList)).
           IF cValue NE ? THEN
              cColValues = cColValues + ENTRY(2, cValue, CHR(1)).
           ELSE RETURN ?.
         END.   /* IF cValue */
         ELSE RETURN ?.
       END.       /* IF NOT VALID-HANDLE */
       ELSE DO:
          cColValues = cColValues 
                       + IF hColumn:BUFFER-VALUE = ? 
                         THEN "?":U 
                         ELSE RIGHT-TRIM(STRING(hColumn:BUFFER-VALUE)). 
      END.       /* END ELSE DO if hColumn found locally */

      IF iCol NE iColCount THEN cColValues = cColValues + CHR(1).
    END.  /* END iCol */
      
    RETURN cColValues.       
  END.
   
  RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-copyRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION copyRow Procedure 
FUNCTION copyRow RETURNS CHARACTER
  ( pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Creates a new RowObject temp-table record, copies all of the 
               current row values to it.  The return value of this function is 
               a CHR(1) delimited list of the values of the current row as 
               specified in the input parameter pcViewColList.  The first value 
               of this return value is the RowIdent of the newly created row.
               
  Parameters:  
    INPUT pcViewColList - comma-separated list of columns whose values are to
                          be returned for the newly created row.
 ------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cRowid     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE rRowObject AS ROWID     NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lBrowsed   AS LOGICAL   NO-UNDO.
    
    {get RowObject hRowObject}.
    {get DataHandle hDataQuery}.
    /* Save off the "current" rowid in case the add is cancelled. 
       If there's no RowObject record available, it's because we're
       being browsed from outside, so use the Browser's RowIdent. */
    /* NOTE: Here and in addRow just checking AVAILABLE is not really a reliable
       way to tell whether the record that happens to be current in the DO is the
       one the client wants to COpy. */
    IF hRowObject:AVAILABLE THEN
      {set CurrentRowid hRowObject:ROWID}.
    ELSE DO:
      IF hDataQuery:IS-OPEN THEN    /* not open means not using temp-table */
      DO:
        {get RowIdent cRowid SOURCE-PROCEDURE}.
        cRowid = ENTRY(1, cRowid).
        {set CurrentRowid TO-ROWID(cRowid)}.
        rRowObject = TO-ROWID(cRowid).
        {get DataQueryBrowsed lBrowsed}.
        IF lBrowsed THEN
          hRowObject:FIND-BY-ROWID(rRowObject).
        ELSE DO:
            hDataQuery:REPOSITION-TO-ROWID(rRowObject).
            IF NOT hRowObject:AVAILABLE THEN
              hDataQuery:GET-NEXT().      /* To move onto the row itself. */
        END. /* END Not Browsed */
      END.   /* END DO IF IS-OPEN */
    END.     /* END No RowObject Available */  
           
    RUN copyColumns IN TARGET-PROCEDURE (pcViewColList, hDataQuery).
    
  RETURN {fnarg colValues pcViewColList}.

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
  Notes:       We run this on AppServer because it calls more than one 
               AppServer function. (columnTable, getTables, getAssignList ) 
               and we assume that one call that returns one field is more 
               efficient than two calls that returns a list.  
               getTables() and getAssignList both currently need to be called 
               on the server (may be changed in the future):  
                getTables() currently gets it's data directly form the query.
                AssignList is only on the server because it uses getTables when 
                it's buildt. 
 -----------------------------------------------------------------------------*/

  /* Determine where to direct this request - client or server */
  {src/adm2/cltorsvr.i dbColumnDataName Char pcDbColumn}
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION deleteRow Procedure 
FUNCTION deleteRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Submits a row for deletion. Returns FALSE if an error occurs.
  
  Parameters:
    INPUT pcRowIdent - RowIdent of the RowObject temp-table to delete.
  
  Notes:       If auto-commit is on, the row will immediately be sent back 
               to the db for deletion.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cMessages      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cQueryPos      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowObject     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowNum        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjUpd     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowObjField   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hRowUpdField   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hUpdRowMod     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hDataQuery     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iCol           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iValue         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lAutoCommit    AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lBrowsed       AS LOGICAL   NO-UNDO.  
  DEFINE VARIABLE lNextNeeded    AS LOGICAL   NO-UNDO INIT no.
  DEFINE VARIABLE lSuccess       AS LOGICAL   NO-UNDO INIT yes.
  DEFINE VARIABLE rDataQuery     AS ROWID     NO-UNDO.
    
    {get RowObject hRowObject}.
    {get RowObjUpd hRowObjUpd}.
    {get DataHandle hDataQuery}.
    {get DataQueryBrowsed lBrowsed}.
     
    IF pcRowIdent = ? THEN     /* sanity check. */
    DO:
       RUN addMessage IN TARGET-PROCEDURE("No row available; row cannot be deleted.":U, ?, ?).
       RETURN FALSE.
    END.
    /* Extract the RowObject ROWID from the RowIdent passed. If it's
       a valid ROWID and found in the Temp-Table, delete that row.
       If that entry isn't defined, then we're doing a delete for
       a query this object isn't managing. Create a RowObjUpd record
       for it (no data needed, just the RowIdent field) and delete it. */
    IF ENTRY(1, pcRowIdent) NE "":U THEN
    DO:
      rDataQuery = TO-ROWID(ENTRY(1, pcRowIdent)) NO-ERROR.
      IF lBrowsed THEN
        hRowObject:FIND-BY-ROWID(rDataQuery).
      ELSE DO:
        hDataQuery:REPOSITION-TO-ROWID(rDataQuery) NO-ERROR.
 
        /* If a Viewer is handling the delete, then we must Next on the query
           to make the row available. If the query's being browsed, though,
           this is not necessary, so check if the row is already available. 
           Also, save this information so that we know whether to skip the
           fetchNext below. */
        IF NOT hRowObject:AVAILABLE THEN
          lNextNeeded = yes.
        IF NOT ERROR-STATUS:ERROR AND lNextNeeded THEN
          hDataQuery:GET-NEXT().           /* Position to the row itself. */
      END. /* NOT lBrowsed */

      /* We need to try to find a RowObjUpd record for this row before 
         creating a new one.  findRowObjUpd takes the RowObject and RowObjUpd
         buffers and returns RowObjUpd buffer. */
      hRowObjUpd = DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                                    hRowObject, hRowObjUpd).
      IF hRowObjUpd:AVAILABLE THEN 
        ASSIGN hUpdRowMod = hRowObjUpd:BUFFER-FIELD('RowMod':U)
               hUpdRowMod:BUFFER-VALUE = "D".
      ELSE DO:
        /* Copy the record to the Update table to be able to 
           restore it if UNDOne. */
        hRowObjUpd:BUFFER-CREATE().
        DO iCol = 1 TO hRowObject:NUM-FIELDS:
          ASSIGN hRowObjField = hRowObject:BUFFER-FIELD(iCol)
                 hRowUpdField = hRowObjUpd:BUFFER-FIELD(iCol).
          IF hRowUpdField:EXTENT NE 0 THEN   /* Copy arrays a value at a time.*/
          DO iValue = 1 TO hRowUpdField:EXTENT:
            hRowUpdField:BUFFER-VALUE[iValue] = 
              hRowObjField:BUFFER-VALUE[iValue].
          END.   /* END DO iValue */
          ELSE hRowUpdField:BUFFER-VALUE = hRowObjField:BUFFER-VALUE.
        END.     /* END DO iCol */
        ASSIGN hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowNum':U)
               hRowObjField = hRowObject:BUFFER-FIELD('RowNum':U)
               hRowUpdField:BUFFER-VALUE = hRowObjField:BUFFER-VALUE
               hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
               hRowObjField = hRowObject:BUFFER-FIELD('RowIdent':U)
               hRowUpdField:BUFFER-VALUE = hRowObjField:BUFFER-VALUE
               hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowMod':U)
               hRowUpdField:BUFFER-VALUE = "D":U.
      END.  /* Else do - if RowObjUpd not avail */
    END.     /* END DO IF ENTRY(1) */
    ELSE DO:
      /* We need to try to find a RowObjUpd record for this row before 
         creating a new one.  findRowObjUpd takes the RowObject and RowObjUpd
         buffers and returns RowObjUpd buffer. */
      hRowObjUpd = DYNAMIC-FUNCTION('findRowObjUpd':U IN TARGET-PROCEDURE,
                                    hRowObject, hRowObjUpd).
      IF hRowObjUpd:AVAILABLE THEN 
        ASSIGN hUpdRowMod = hRowObjUpd:BUFFER-FIELD('RowMod':U)
               hUpdRowMod:BUFFER-VALUE = "D".
      ELSE DO:
       /* IF first entry in RowIdent is blank, use the rest to create
           a row to delete on behalf of a query managed elsewhere. */
        hRowObjUpd:BUFFER-CREATE().
        ASSIGN hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowIdent':U)
               hRowUpdField:BUFFER-VALUE = 
                 SUBSTR(pcRowIdent, INDEX(pcRowIdent, ",":U) + 1)
               hRowUpdField = hRowObjUpd:BUFFER-FIELD('RowMod':U)
               hRowUpdField:BUFFER-VALUE = "D":U.
        /* Make sure we do a Next (in the db query) following the delete,
           if there's no RowObject record. */
      END.  /* Else do - if RowObjUpd not avail */
    END.     /* END DO IF no ENTRY(1) */

  {get AutoCommit lAutoCommit}.
  IF lAutoCommit THEN 
  DO:  /* Go ahead with the DB transaction now. */
    RUN commitTransaction IN TARGET-PROCEDURE.
    lSuccess = RETURN-VALUE NE "ADM-ERROR":U.
    /* If there were no errors, delete the RowObject copy of the row. */
  END.  /* END DO IF AutoCommit */
  /* If we returned successfully from the Delete, or we have a Commit Panel
     so the delete has been done only locally for now, delete the RowObject. */
  IF (NOT lAutoCommit) OR lSuccess THEN
  DO:
    {get QueryPosition cQueryPos}.  /* Were we on the first/last record? */
    
    IF ENTRY(1, pcRowIdent) NE "":U THEN
    /* if the object has its own query, there's no temp-table rec to delete.*/
    DO:
      IF NOT hRowObject:AVAILABLE THEN
      DO:
        IF lBrowsed THEN
          hRowObject:FIND-BY-ROWID(rDataQuery).
        ELSE
          hDataQuery:REPOSITION-TO-ROWID(rDataQuery).
      END.

      hRowObject:BUFFER-DELETE().
    END.  /* END DO IF pcRowIdent */
      /* If there is a Commit-Source, signal that a row has been changed. */
      IF NOT lAutoCommit THEN
        {set RowObjectState 'RowUpdated':U}.
      
      /* If we're being browsed (detected above) then we don't need the
         Next operation here; it just results in the wrong rec being deleted
         from the browse viewport. */
      
      IF lNextNeeded THEN
        RUN fetchNext IN TARGET-PROCEDURE.
      
      /* If we deleted the first record, then fetchNext have reset
         QueryPosition without detecting that it is actually on the 
         "new" first record. */
      IF cQueryPos = 'FirstRecord':U AND hRowObject:AVAILABLE THEN
      DO:
        hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U).
        {set FirstRowNum hRowNum:BUFFER-VALUE}.        
      END.  /* IF First */
      
      {fn updateQueryPosition}.

      PUBLISH 'deleteComplete':U FROM TARGET-PROCEDURE. /* Tell Browser, e.g */
  END.    /* END DO IF NOT AutoCommit OR Success from Commit */
  /* In the event of a failed delete, doreturnUpd has deleted the
     Update temp-table row. */
  /* Return false if there were any error messages returned. */
  RETURN lSuccess.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchRow Procedure 
FUNCTION fetchRow RETURNS CHARACTER
  (piRow AS INTEGER, pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the Row Object's query to the desired row (indicated
               by piRow) and returns that row's values (as specified in 
               pcViewColList).  The return value is CHR(1) delimited list of
               values (formatted according to each columns FORMAT expression.)
               The first value in the list is the RowIdent of the fetched row.
 
  Parameters:
    INPUT piRow         - desired row number within the result set
    INPUT pcViewColList - comma-separated list of names of columns to be 
                          returned.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE iRowNum    AS INTEGER NO-UNDO INIT ?.
  DEFINE VARIABLE rRowId     AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE cLastDbRowId  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hRowQuery  AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRow       AS INTEGER NO-UNDO.
  DEFINE VARIABLE lOK        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRow       AS CHAR    NO-UNDO INIT ?.
  DEFINE VARIABLE lBrowsed   AS LOGICAL NO-UNDO.
  
    {get DataQueryBrowsed lBrowsed}.   
    {get DataHandle hDataQuery}.
    IF NOT hDataQuery:IS-OPEN THEN hDataQuery:QUERY-OPEN().
    
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
       
    IF hRowObject:AVAILABLE THEN
      ASSIGN hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U)
             hRowIdent  = hRowObject:BUFFER-FIELD('RowIdent':U)
             iRowNum    = hRowNum:BUFFER-VALUE.  /* Save off for comparison.*/
    CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
    lOK = hRowQuery:SET-BUFFERS(hRowObject).
    IF lOK THEN
      lOK = hRowQuery:QUERY-PREPARE
         ('FOR EACH RowObject WHERE RowObject.RowNum = ':U + STRING(piRow)).
    IF lOK THEN lOK = hRowQuery:QUERY-OPEN().
    IF lOK THEN lOK = hRowQuery:GET-FIRST().
    IF hRowObject:AVAILABLE THEN
    DO:
        rRowId = hRowObject:ROWID.
        lOK = hDataQuery:REPOSITION-TO-ROWID(rRowId).
        IF lOK AND (NOT lBrowsed) THEN hDataQuery:GET-NEXT().
        IF lOK THEN
        DO:
          IF VALID-HANDLE(hRowNum) THEN
          DO:  /* If we were previously positioned on some actual record... */
            {get LastRowNum iRow}.            
            {get LastDbRowIdent cLastDbRowId}.                              
            IF iRow = hRowNum:BUFFER-VALUE 
            OR cLastDbRowId = hRowIdent:BUFFER-VALUE THEN  
              {set QueryPosition 'LastRecord':U}.
            ELSE IF hRowNum:BUFFER-VALUE = 1 THEN
              {set QueryPosition 'FirstRecord':U}.
            ELSE IF iRowNum = 1 OR iRowNum = iRow THEN
              {set QueryPosition 'NotFirstOrLast':U}.
          END.   /* END DO IF VALID-HANDLE */
          /* Signal row change in any case. */
          PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
          /* This will return ? if not AVAILABLE. */
          cRow = {fnarg colValues pcViewColList}.
        END.     /* END DO IF lOK */
    END. /* if hRowObject:availabel */
    DELETE WIDGET hRowQuery.

    RETURN cRow. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-fetchRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fetchRowIdent Procedure 
FUNCTION fetchRowIdent RETURNS CHARACTER
  (pcRowIdent AS CHARACTER, pcViewColList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Repositions the RowObject's query to the desired row, based on
               the corresponding database record rowid(s) (specified by 
               pcRowIdent), and returns that row's values (as specified in 
               pcViewColList).  The return value is CHR(1) delimited list of
               values (formatted according to each columns FORMAT expression.)
               The first value in the list is the RowIdent of the fetched row.
               If that row is not in the RowObject table, it repositions the 
               database query to that row and resets the RowObject table.
 
  Parameters:
    INPUT pcRowIdent    - desired rowid(s) within the result set, expressed 
                          as a comma-separated list of db rowids;
    INPUT pcViewColList - comma-separated list of names of columns to be 
                          returned.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE rRowId        AS ROWID   NO-UNDO.
  DEFINE VARIABLE hDataQuery    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hDBQuery      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowObject    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowQuery     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowNum       AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent     AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iRowNum       AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsReturned AS INTEGER NO-UNDO.
  DEFINE VARIABLE iLastRow      AS INTEGER NO-UNDO.
  DEFINE VARIABLE cLastDbRowId  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iFirstRow     AS INTEGER NO-UNDO.
  DEFINE VARIABLE iRowsToBatch  AS INTEGER NO-UNDO.
  DEFINE VARIABLE lOK           AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRow          AS CHAR    NO-UNDO INIT ?.
  DEFINE VARIABLE lBrowsed      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE lRebuild      AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cRowState     AS CHAR    NO-UNDO.
    {get RowObjectState cRowState}.
    {get RowsToBatch iRowsToBatch}.
    {get DataHandle hDataQuery}.
    hRowObject = hDataQuery:GET-BUFFER-HANDLE(1).
    IF hRowObject:AVAILABLE THEN
      ASSIGN hRowNum    = hRowObject:BUFFER-FIELD('RowNum':U)
             hRowIdent  = hRowObject:BUFFER-FIELD('RowIdent':U)
             iRowNum    = hRowNum:BUFFER-VALUE.  /* Save off for comparison.*/

    /* Determines if this SDO is being browsed by a SmartDataBrowser */
    {get DataQueryBrowsed lBrowsed}.
     
    CREATE QUERY hRowQuery.     /* Get a query to do the "FIND" */
    lOK = hRowQuery:SET-BUFFERS(hRowObject).
    IF lOK THEN
      /* Note that the where clause uses 'BEGINS' because the caller
         may have specified a partial RowIdent (first table of a join). */
      lOK = hRowQuery:QUERY-PREPARE
          ('FOR EACH RowObject WHERE RowObject.RowIdent BEGINS "':U 
            + pcRowIdent + '"':U).
    IF lOK THEN
      lOK = hRowQuery:QUERY-OPEN().
    IF lOK THEN
      lOK = hRowQuery:GET-FIRST().

    /* If update in progress and record not in the current batch */    
    IF cRowState = 'RowUpdated':U AND NOT hRowObject:AVAILABLE THEN DO:
      DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "16":U).
      DELETE WIDGET hRowQuery.
      RETURN ?.
    END.   
    
    /* If it's not in the current RowObject set, keep getting batches of
       rows until we get to it, unless the RebuildOnRepos property is set,
       in which case we get sendRows to jump right to that record. */
    {get RebuildOnRepos lRebuild}.

    /* If RebuildOnReposition is true and the row we are looking for isn't in the
       current batch and we have a valid ID to look for, flush out the current set
       of RowObject records and reset the associated flags. */
    IF lRebuild AND NOT hRowObject:AVAILABLE and pcRowIdent NE "" THEN DO:
      hRowObject:EMPTY-TEMP-TABLE().
      {set FirstRowNum ?}.
      {set LastRowNum ?}.
      {set FirstResultRow ?}.
      {set LastResultRow ?}.
    END.
    iRowsReturned = iRowsToBatch.
    IF lBrowsed THEN PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchStart':U).
    DO WHILE (NOT hRowObject:AVAILABLE) AND
              iRowsReturned EQ iRowsToBatch:
      RUN sendRows IN TARGET-PROCEDURE 
            (?,    /* No RowNum specified */
             IF lRebuild THEN pcRowIdent ELSE ?, 
             /* If we are cycling through until we locate the desired row,
                (Rebuild = no), then nextflag is True; otherwise, if
                we are jumping to that rec as a starting point, it is
                the first row returned, so Nextflag is False. */
             NOT lRebuild,  
             iRowsToBatch, OUTPUT iRowsReturned).
      IF iRowsReturned = 0 THEN DO: /* No rows returned */
        hRowObject:EMPTY-TEMP-TABLE().
        hDataQuery:QUERY-CLOSE().
        {set FirstRowNum ?}.
        {set LastRowNum ?}.
        {set FirstResultRow ?}.
        {set LastResultRow ?}.
        IF lBrowsed THEN PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).
        DYNAMIC-FUNCTION("showMessage":U IN TARGET-PROCEDURE, "Unable to locate record in current query.").
        DELETE WIDGET hRowQuery.
        RETURN ?.
      END.  /* If no rows were returned */
      hRowQuery:QUERY-OPEN().     /* reopen the query on the one row. */
      hRowQuery:GET-FIRST().      /* see if that row is now AVAILABLE */
      IF lRebuild THEN            /* Force us out of the loop. */
        iRowsReturned = 0.
    END.   /* END DO WHILE */
    
    IF hRowObject:AVAILABLE THEN
    DO:
        rRowId = hRowObject:ROWID.
        lOK = hDataQuery:REPOSITION-TO-ROWID(rRowId).

        IF lOK AND (NOT lBrowsed) THEN lOK = hDataQuery:GET-NEXT().
        IF lOK THEN
        DO:
          IF VALID-HANDLE(hRowNum) THEN
          DO:  /* If we were previously positioned on some actual record... */
            {get LastRowNum iLastRow}.
            {get LastDbRowIdent cLastDbRowId}.
            IF iLastRow     = hRowNum:BUFFER-VALUE 
            OR cLastDbRowId = hRowIdent:BUFFER-VALUE THEN  
              {set QueryPosition 'LastRecord':U}.
            ELSE DO:
              {get FirstRowNum iFirstRow}.
              IF hRowNum:BUFFER-VALUE = iFirstRow THEN
                {set QueryPosition 'FirstRecord':U}.
              ELSE {set QueryPosition 'NotFirstOrLast':U}.
            END.  /* END ELSE DO IF Not Last */
          END.   /* END DO IF VALID-HANDLE */
          /* Signal row change in any case. */
          PUBLISH 'dataAvailable':U FROM TARGET-PROCEDURE ("DIFFERENT":U).
 
          /* This will return ? if not AVAILABLE. */
          cRow = {fnarg colValues pcViewColList}.
        END.     /* END DO IF lOK */
    END.         /* END DO IF AVAILABLE */
    IF lBrowsed THEN PUBLISH 'fetchDataSet':U FROM TARGET-PROCEDURE ('BatchEnd':U).
    DELETE WIDGET hRowQuery.
 
    RETURN cRow.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-findRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findRowObjUpd Procedure 
FUNCTION findRowObjUpd RETURNS HANDLE PRIVATE
  ( phRowObject AS HANDLE,
    phRowObjUpd AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose: Returns the handle for RowObjUpd buffer for the RowObjUpd record that 
           corresponds to the RowObject record being passed to this function.
   Params: phRowObject AS HANDLE
           phRowObjUpd AS HANDLE  
    Notes: Called from deleteRow to check for a RowObjUpd for a row being deleted
           before creating a new one. 
------------------------------------------------------------------------------*/
DEFINE VARIABLE cRowNum    AS CHARACTER NO-UNDO.
DEFINE VARIABLE hRowNum    AS HANDLE    NO-UNDO.
DEFINE VARIABLE hRowQuery  AS HANDLE NO-UNDO.

  ASSIGN hRowNum = phRowObject:BUFFER-FIELD('RowNum':U)
         cRowNum = hRowNum:BUFFER-VALUE.

  CREATE QUERY hRowQuery.
  hRowQuery:SET-BUFFERS(phRowObjUpd).
  hRowQuery:QUERY-PREPARE('FOR EACH RowObjUpd WHERE RowObjUpd.RowNum = ':U + cRowNum).
  hRowQuery:QUERY-OPEN().
  hRowQuery:GET-FIRST().
  DELETE WIDGET hRowQuery.

  RETURN phRowObjUpd.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASHandle Procedure 
FUNCTION getASHandle RETURNS WIDGET-HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle to this SmartDataObject's companion procedure 
               (the copy of itself) running on the AppServer.
  
  Parameters:  <none>
  
  Notes:       Note that what is returned is *not* the handle of the connection,
               but rather the persistent procedure handle in which internal 
               procedures and functions can be invoked.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hAS            AS HANDLE                           NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER                        NO-UNDO.

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ASHandle':U)
         hAS    = ghProp:BUFFER-VALUE NO-ERROR.

  IF NOT VALID-HANDLE(hAS) THEN DO: /* Perhaps it needs to be re-established */        
    {get ServerOperatingMode cOperatingMode}.
    IF cOperatingMode = "STATELESS":U THEN DO:
      RUN restartServerObject IN TARGET-PROCEDURE.
      ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
             ghProp = ghProp:BUFFER-FIELD('ASHandle':U)
             hAS    = ghProp:BUFFER-VALUE NO-ERROR.
    END.  /* If stateless */
  END.  /* If it needs to be re-established */

  RETURN hAS.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentRowModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentRowModified Procedure 
FUNCTION getCurrentRowModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if any values in the current RowObject row
               have been modified.  If there is no current Rowobject record,
               then getCurrentRowModified returns ?.
   
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRowMod    AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT hRowObject:AVAILABLE THEN RETURN ?.
  ELSE DO:
    hRowMod = hRowObject:BUFFER-FIELD('RowMod':U).
    RETURN hRowMod:BUFFER-VALUE = "U":U.  /* This means newly added rows return NO? */
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataQueryBrowsed Procedure 
FUNCTION getDataQueryBrowsed RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:      Returns TRUE if this SmartDataObject's Query is being browsed 
                by a SmartDataBrowser.
  
  Parametrers:  <none>
  
  Notes:        This is used to prevent two SmartDataBrowsers from attempting 
                to browse the same query, which is not allowed because 
                conflicts would occur.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lBrowsed AS LOGICAL NO-UNDO.
 
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataQueryBrowsed':U)
         lBrowsed = ghProp:BUFFER-VALUE NO-ERROR.
 
  RETURN lBrowsed.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataSignature) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSignature Procedure 
FUNCTION getDataSignature RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a character string value which is a list of integers 
               corresponding to the datatypes of the fields in the RowObject 
               Temp-Table, for use in comparing objects for equivalence.

  Parameters:  <none>
  
  Notes:       A SmartDataObject and a SmartDataBrowser which have the same 
               DataSignature will be compatible; the SmartDataObject's query 
               can be used by the Browser.  The integer values are the same 
               codes used in the _dtype field in the schema:
                               1 = CHARACTER
                               2 = DATE
                               3 = LOGICAL
                               4 = INTEGER
                               5 = DECIMAL
                               6 = Reserved for FLOAT OR DOUBLE in the future
                               7 = RECID
                               8 = RAW
                               9 = Reserved for IMAGE in the future
                              10 = HANDLE
                              13 = ROWID
                                  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cSignature AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cDataType  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE    NO-UNDO.
  
  {get RowObject hRowObject}.
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
      ELSE IF cDataType = 'HANDLE':U    THEN '10':U
      ELSE IF cDataType = 'ROWID':U     THEN '13':U 
      ELSE '0':U).
  END.
  
  RETURN cSignature.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getMandatoryColumns) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getMandatoryColumns Procedure 
FUNCTION getMandatoryColumns RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a comma-separated list of Data-Field names in the 
               RowObject temp-table which are derived from fields marked as
               mandatory in the dictionary.
   
  Parameters:  <none>
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cMandatory AS CHARACTER NO-UNDO INIT "":U.
    DEFINE VARIABLE iCol       AS INTEGER   NO-UNDO.
    DEFINE VARIABLE hRowObject AS HANDLE    NO-UNDO.
    DEFINE VARIABLE hCol       AS HANDLE    NO-UNDO.
    
    {get RowObject hRowObject}.
    DO iCol = 1 TO hRowObject:NUM-FIELDS:
      hCol = hRowObject:BUFFER-FIELD(iCol).
      IF hCol:MANDATORY THEN cMandatory = cMandatory +
        (IF cMandatory NE "":U THEN ",":U ELSE "":U) + hCol:NAME.
    END.
  RETURN cMandatory.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getNewRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNewRow Procedure 
FUNCTION getNewRow RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the current RowObject record is new - (an added
               record or a copy of an existing record has never been written to
               the database.)  Returns ? if there is no current RowObject.

  Parameters:  <none>
  
  Notes:       This uses the RowMod field in the Temp-Table to see if the 
               row's new.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  DEFINE VARIABLE hColumn    AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  IF NOT hRowObject:AVAILABLE THEN
    RETURN ?.   
  ELSE DO:
    hColumn = hRowObject:BUFFER-FIELD('RowMod':U).
    IF hColumn:BUFFER-VALUE = "A":U OR
       hColumn:BUFFER-VALUE = "C":U THEN
      RETURN TRUE.
    ELSE RETURN FALSE.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getOpenQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOpenQuery Procedure 
FUNCTION getOpenQuery RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the original design where-clause for the database query.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/
  /* Determine where to direct this request - client or server */
  {src/adm2/cltorsvr.i getOpenQuery Char}

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
  Parameters:  <none>
  Notes:       (See getOpenQuery for the original where clause.) 
------------------------------------------------------------------------------*/

  /* Determine where to direct this request - client or server */
  {src/adm2/cltorsvr.i getQueryWhere Char " "}

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRebuildOnRepos Procedure 
FUNCTION getRebuildOnRepos RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns TRUE if the RowObject temp-table should be rebuilt if a 
               fetchLast or other reposition is done which is outside the bounds 
               of the current dataset.
            
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lRebuild AS LOGICAL NO-UNDO.
  {get RebuildOnRepos lRebuild}.
  RETURN lRebuild.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowIdent Procedure 
FUNCTION getRowIdent RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the value of the RowIdent field for the current RowObject
               temp-table row. This is a comma delimited character string 
               containing first the ROWID of the RowObject Record followed by
               the ROWID(s) of the database record(s) that are the source of the
               RowObject record.
  
  Parameters:  <none>
  
  Notes:       This RowIdent key can be used to reposition to that row using
               fetchRowIdent.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hDataQuery AS HANDLE NO-UNDO.
  DEFINE VARIABLE hRow       AS HANDLE NO-UNDO.
  
  {get DataHandle hDataQuery}.
  IF VALID-HANDLE(hDataQuery) THEN
  DO:
    hRow = hDataQuery:GET-BUFFER-HANDLE(1).
    IF VALID-HANDLE(hRow) AND hRow:AVAILABLE THEN
    DO:
      hRow = hRow:BUFFER-FIELD('RowIdent':U).
      RETURN hRow:BUFFER-VALUE.
    END.   /* END DO hRow */
    ELSE RETURN ?.
  END.     /* END DO hdataQuery */
  ELSE RETURN ?.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObject Procedure 
FUNCTION getRowObject RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the RowObject Temp-Table buffer.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
  
  {get RowObject hRowObject}.
  RETURN hRowObject.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjectState Procedure 
FUNCTION getRowObjectState RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Retrieves the property value which signals whether there are
               uncommitted updates in the object.  
 
  Parameters:  <none>
  
  Note:        The two possible return values are: 'NoUpdates' and 'RowUpdated'
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cState   AS CHARACTER NO-UNDO.
  
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('RowObjectState':U)
         cState = ghProp:BUFFER-VALUE NO-ERROR.
 
  RETURN cState.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowObjUpd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowObjUpd Procedure 
FUNCTION getRowObjUpd RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the handle of the RowObjUpd Temp-Table buffer where 
               Updates are stored.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hRowObjUpd AS HANDLE NO-UNDO.
  
  {get RowObjUpd hRowObjUpd}.
  RETURN hRowObjUpd.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTables Procedure 
FUNCTION getTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns a list of the database tables in the database Query 
               Object.

  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Determine where to direct the request - client or server */
  {src/adm2/cltorsvr.i getTables Char " "}

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getWordIndexedFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getWordIndexedFields Procedure 
FUNCTION getWordIndexedFields RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Returns a list of RowObject fields that are mapped to database
           fields that has a word indexed.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hAppServer  AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cASDivision AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFieldList  AS CHAR      NO-UNDO.
  DEFINE VARIABLE cField      AS CHAR      NO-UNDO.
  DEFINE VARIABLE iField      AS INT       NO-UNDO.

  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO:
    {get ASHandle hAppServer}.
    IF VALID-HANDLE(hAppServer) AND hAppServer NE TARGET-PROCEDURE THEN 
    DO:
      {get WordIndexedFields cFieldList hAppServer}. 
    END.
  END. /* do if client */
  ELSE cFieldList = SUPER().
  
  DO iField = 1 TO NUM-ENTRIES(cFieldList):
     ASSIGN
       cField = ENTRY(iField,cFieldList)
       cField = {fnarg dbColumnDataName cField} 
       ENTRY(iField,cFieldList) = IF cField <> ? THEN cField ELSE '':U.
  END. /* do ifield = 1 to num-entries */

  RETURN cFieldList.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-newRowObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION newRowObject Procedure 
FUNCTION newRowObject RETURNS LOGICAL PRIVATE
  (pcMode AS CHARACTER) :
/*------------------------------------------------------------------------------
   Purpose: Assign some general RowObject fields and update LastRowNum,
            FirstRowNum when a new RowObject has been created . 
Parameters: pcMode - char  - A(dd) or C(opy)     
     Notes: The main purpose for this procedure is to ensure that copy and add
            behaves similar. 
            The buffer must be created first.  
            Currently defined as PRIVATE. 
            Used in procedure copyColumns and function addRow().  
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cQueryPos  AS CHAR   NO-UNDO.
 DEFINE VARIABLE hColumn    AS HANDLE NO-UNDO.
 DEFINE VARIABLE hRowObject AS HANDLE NO-UNDO.
 DEFINE VARIABLE iLastRow   AS INT    NO-UNDO.
 DEFINE VARIABLE cBlank     AS CHAR   NO-UNDO.

 {get RowObject hRowObject}.
 
 ASSIGN hColumn = hRowObject:BUFFER-FIELD('RowIdent':U)
        hColumn:BUFFER-VALUE = "":U
        giAddRowNum = giAddRowNum + 1  /* Assign high temp row number */
        hColumn = hRowObject:BUFFER-FIELD('RowNum':U)
        hColumn:BUFFER-VALUE = giAddRowNum
        hColumn = hRowObject:BUFFER-FIELD('RowMod':U)
        hColumn:BUFFER-VALUE = SUBSTR(pcMode,1,1).  

  /* If we had previously retrieved the last row of the query, 
     then reset that indicator. 
     If the query was empty we must also set the last properties. */
 {get LastRowNum iLastRow}.
 {get QueryPosition cQueryPos}.
 
 IF iLastRow NE ? OR cQueryPos = "NoRecordAvailable":U THEN
 DO:
   /* Both these properties are checked to see if last record is retrieved
      We don't need lastDbRowident when LastRowNum is set and as we don't 
      know the rowids yet we just set DbLastrowIdent to blank.  */
   {set LastRowNum     giAddRowNum}.
   {set LastDbRowIdent cBlank}.  
 END. /* lastrow <> ? or NoRecordAvailable */

 /* Set the first flag if the query was empty */
 IF cQueryPos = "NoRecordAvailable":U THEN
   {set FirstRowNum giAddRowNum}.

 /* Notify dataSources. They will check NewRow and close the query */ 
 PUBLISH "dataAvailable" FROM TARGET-PROCEDURE ('DIFFERENT').    

 RETURN TRUE. 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-openQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION openQuery Procedure 
FUNCTION openQuery RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:     Opens the SmartDataObject's database query based on the current 
               WHERE clause.
  
  Parameters:  <none>
------------------------------------------------------------------------------*/    
   DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE hDataQuery     AS HANDLE    NO-UNDO.
   DEFINE VARIABLE cQueryString   AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cContext       AS CHARACTER NO-UNDO.
   DEFINE VARIABLE iByClause      AS INTEGER   NO-UNDO.
   DEFINE VARIABLE cQueryWhere    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cQuerySort     AS CHARACTER NO-UNDO.
   DEFINE VARIABLE lOk            AS LOG       NO-UNDO.
   /* Close the RowObject query and empty the current RowObject table. */
   {get DataHandle hDataQuery}.
   IF hDataQuery:IS-OPEN THEN
     {fn closeQuery}.

   /* NOTE: How to do this without actually repreparing the temp-table query twice.
   {set DataSort '':U}.           /* Reset these qualifiers on the Temp-Table */
   {set DataWhere '':U}.          /*  in case the data has been filtered. */
   */
   
   /* If this is the client half of a divided DataObject, fetchFirst will
      retrieve the Temp-table across the connection. */
   {get ASDivision cASDivision}.
   IF cASDivision = 'Client':U THEN
   DO:
     /* Reset this last-record flag on the client */ 
     {set LastRowNum ?}.
     {get ASHandle hAppServer}.
     IF VALID-HANDLE(hAppServer) THEN 
     DO:
       /* The getQueryString will return the client side QueryString 
         if query manipulation methods has been used. */ 
       {get QueryString cQueryString}. 
       IF cQueryString <> "":U THEN
          {fnarg prepareQuery cQueryString}. /* will be sendt to server. */
       
       IF {fn openQuery hAppServer} THEN 
       DO:
         RUN fetchFirst IN TARGET-PROCEDURE.
         RETURN TRUE.
       END. /* If successfully opened the query */
       
       IF cOperatingMode = "STATELESS" THEN 
       DO:
         RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
         RUN setPropertyList IN TARGET-PROCEDURE (cContext).
       END.  /* If Stateless */
       RETURN lOk.

     END. /* If a valid appserver handle */
     ELSE RETURN FALSE.
   END.   /* END DO client */
   ELSE DO:  /* This is not the client */
     /**  
     IF cASDivision = 'SERVER':U THEN DO:
       {set FirstRowNum ?}.
       {set LastRowNum ?}.
       {set FirstResultRow ?}.
       {set LastResultRow ?}.
       RUN doEmptyModTable IN TARGET-PROCEDURE.
     END.  /* If on the server */
     **/
     RETURN SUPER().
   END.  /* ELSE DO: Not the client */
  
  END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-prepareQuery) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION prepareQuery Procedure 
FUNCTION prepareQuery RETURNS LOGICAL
  (pcQuery AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Prepare the SmartDataObject's database query based with the
            passed parameter  
            The main purpose of this procedure is to isolate the query 
            preparation for client server, thus keeping that away from the 
            logic needed to clean up and keep track of the QueryString property.
Parameters: Complete query expression. 
     Notes: History of client and server query manipulation:            
            9.0A setQueryWhere    - prepares immediately   (data and query)
                 setQuerySort     - prepares immediately   (data and query
                 openQuery        - just open              (data and query)
            9.0B addQueryWhere    - stored in queryString prop on client (query)
                 assignQueryWhere - stored in queryString prop on client (query)
                 openQuery        - prepares if queryString is set, open
            The logic added in setQueryWhere and openQuery to make sure that  
            setQueryWhere did blank the QueryString property, but NOT when it 
            was used to pass the queryString to the server, was rather 
            "difficult". This function simplifies this and setQueryWhere
            now only exists in query.p.    
------------------------------------------------------------------------------*/
   DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
   
   /* If this is the client half of a divided DataObject prepare the query
      on the server. */                                   
   {get ASDivision cASDivision}.
   IF cASDivision = 'Client':U THEN
   DO:
     {get ASHandle hAppServer}.
     IF VALID-HANDLE(hAppServer) THEN 
       RETURN {fnarg prepareQuery pcQuery hAppServer}.
     ELSE
      RETURN FALSE. /* No hAppServer (should we have a lost contact message?)*/

   END.   /* If client */
   ELSE  /* This is not the client */
     RETURN SUPER(pcQuery).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rowidWhere) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION rowidWhere Procedure 
FUNCTION rowidWhere RETURNS CHARACTER
  ( pcWhere AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Returns the ROWID of the first db query row satisfying the
               where clause specified in pcWhere.
  Parameters:
    INPUT pcWhere - The where clause to be satisfied.
    
  Note:        The actual work is done in the query.p SUPER procedure.
               Only the first database buffer is supported.  That is, in the
               case of a join, the where clause only effects the first buffer.
               The pcWhere clause is appended to the current where clause and
               the combination becomes the new where clause of the query until
               explicitly changed again.  For example: if the original where
               clause was: State = "NY" and pcWhere is Balance > 10000 the
               new clause becomes: State = "NY" AND Balance > 10000.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cASDivision    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hAppServer     AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cOperatingMode AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cContext       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowid         AS CHARACTER NO-UNDO.
  /* Determine where to direct the request - client or server.
     The actual code for the function is in query.p. */
  {get ASDivision cASDivision}.
  IF cASDivision = 'Client':U THEN
  DO: 
    /* If we're just the client then do this on the AppServer. */
    {get ASHandle hAppServer}.
    IF VALID-HANDLE(hAppServer) AND hAppServer NE TARGET-PROCEDURE THEN 
    DO:
      cRowid = DYNAMIC-FUNCTION("rowidWhere":U IN hAppServer, pcWhere).
      {get ServerOperatingMode cOperatingMode}.
      IF cOperatingMode = "STATELESS":U THEN 
      DO:
        RUN saveContextAndDestroy IN hAppServer (OUTPUT cContext).
        RUN setPropertyList IN TARGET-PROCEDURE (cContext).
      END.  /* If Stateless */

    END. /* valid Appserver */
    ELSE 
      cRowid = ?.
    
    RETURN cRowid. 

  END.  /* END DO IF Client */
  ELSE RETURN SUPER(pcWhere).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  ( pcPartition AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the AppService property which names the Partition that this 
               SmartDataObject has been registered to run on.

  Parameters:
    INPUT pcPartition - Partition name that this SmartDataObject has registered.
  
  Notes:       The default value is the APPLICATION-PARTITION preprocessor value 
               which can be defined in the procedure settings dialog in the 
               AppBuilder.
               This property can also be set in the instance properties dialog
               of the SmartDataObject.
------------------------------------------------------------------------------*/
  {set AppService pcPartition}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASHandle Procedure 
FUNCTION setASHandle RETURNS LOGICAL
  ( phASHandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:    This function stores the procedure handle of the server-side
              SmartDataObject in the ADMProps temp-table.
  Parameters: 
    INPUT phASHandle - The procedure handle of the server side SmartDataObject
------------------------------------------------------------------------------*/

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('ASHandle':U)
         ghProp:BUFFER-VALUE = phASHandle.
         
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAutoCommit Procedure 
FUNCTION setAutoCommit RETURNS LOGICAL
  ( plFlag AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:    Sets the AutoCommit flag on or off; when On, every call to 
              submitRow will result in a Commit.
            
  Parameters:
    INPUT plFlag - If true, AutoCommit is set On.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE lQuery AS LOGICAL NO-UNDO.
  /* IF The QueryObject property has been set off, then this object is just
     being used for update of another object's data. AutoCommit must be true
     because there is no temp-table to store uncommitted changes in. */
  IF NOT plFlag THEN
  DO:
    {get QueryObject lQuery}.
    IF NOT lQuery THEN 
      RETURN FALSE.
  END.   /* END IF NOT plFlag */
  {set AutoCommit plFlag}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataQueryBrowsed) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataQueryBrowsed Procedure 
FUNCTION setDataQueryBrowsed RETURNS LOGICAL
  ( plBrowsed AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets a property flag indicating that this object's DataQuery
               is being browsed by a SmartDataBrowser.
 
  Parameters:
    INPUT plBrowsed - True if a SmartDataBrowser uses this SmartDataObject
                      as a Data-Source.
    
  Notes:       This is set by a SmartDataBrowser which is a Data-Target.
               The property is used to prevent multiple SmartDataBrowsers 
               from attempting to browse the same query, which is not 
               allowed.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lAlreadyBrowsed AS LOGICAL NO-UNDO.
  
  /* If the flag is already set, return false. */
  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('DataQueryBrowsed':U).
         
  IF plBrowsed THEN
  DO:
    lAlreadyBrowsed = ghProp:BUFFER-VALUE NO-ERROR.
    IF lAlreadyBrowsed THEN
      RETURN FALSE.
  END.   /* END DO IF plBrowsed */
 
  ASSIGN ghProp:BUFFER-VALUE = plBrowsed.
 
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowObjectState) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowObjectState Procedure 
FUNCTION setRowObjectState RETURNS LOGICAL
  ( pcState AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the RowObjectState property, which keeps track of whether
            there are uncommitted updates in the object.
 
  Parameters:
    INPUT pcState - Can only be 'RowUpdated' OR 'NoUpdates'
------------------------------------------------------------------------------*/

  ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
         ghProp = ghProp:BUFFER-FIELD('RowObjectState':U)
         ghProp:BUFFER-VALUE = pcState.
  PUBLISH 'rowObjectState':U FROM TARGET-PROCEDURE (pcState).
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRowsToBatch Procedure 
FUNCTION setRowsToBatch RETURNS LOGICAL
  ( piRows AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the number of rows to be transferred from the database query
               into the RowObject temp-table at a time.
 
  Parameters:
    INPUT piRows - The desired number of RowObject records in a batch (default 
                   is 200)
  
  Notes:       Setting RowsToBatch to 0 causes the RowObject temp-table
               not to be used at all. Data is browsed directly from the
               database query. This cannot be done if there is an AppServer
               connection for this object or if there is a Commit-Source
               (Commit/Undo Panel).
------------------------------------------------------------------------------*/
 
  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  DEFINE VARIABLE cDivision AS CHARACTER NO-UNDO.
  
  IF piRows = 0 THEN
  DO:
    /* Don't allow the RowObject table not to be used if there's a Commit 
       Panel or an AppServer connection. */
    /* NOTE: For the first 9.0A release, this special convention of 
       setting RowsToBatch to 0 is not supported.
    {get CommitSource hSource}.
    {get ASDivision cDivision}.
    IF (VALID-HANDLE(hSource)) OR (cDivision NE "":U) THEN
    */
      RETURN FALSE.
  END.   /* END DO IF FALSE */
  {set RowsToBatch piRows}.
  RETURN TRUE.
   
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-submitRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION submitRow Procedure 
FUNCTION submitRow RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER, pcValueList AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:     Accepts a list of changed values for a row and ASSIGNs them,
               returning FALSE if any errors occur. 
               This is done only to the RowObject Temp-Table; 
               committing the changes back to the database is 
               a separate step, which will be invoked from here if 
               AutoCommit is set on.
 
  Parameters:
    INPUT pcRowIdent  - "key" with row number to update, plus a list of the 
                        ROWID(s) of the db record(s) the RowObject is derived 
                        from.
    INPUT pcValueList - CHR(1) delimited list of alternating column names 
                        and values to be assigned.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lReopen        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cErrorMessages AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cUpdColumns    AS CHARACTER NO-UNDO.
   
  {get UpdatableColumns cUpdColumns}.
  
  /* Assign Foreign Key values if needed for new records. */
  RUN submitForeignKey IN TARGET-PROCEDURE(INPUT pcRowIdent,
    INPUT-OUTPUT pcValueList, INPUT-OUTPUT cUpdColumns).

  /* Create a "before" row in the Update table for an Update, or create a new
     row in the RowObject table for an Add. */
  RUN doCreateUpdate IN TARGET-PROCEDURE (INPUT pcRowIdent, INPUT pcValueList,
    OUTPUT lReopen, OUTPUT cErrorMessages).
  IF cErrorMessages NE "":U THEN
    RETURN FALSE.  

  /* Perform any validation on individual columns. */
  RUN submitValidation In TARGET-PROCEDURE (pcValueList, cUpdColumns).
  
  /* Undo the update if there are errors; else commit if AutoCommit. */
  RUN submitCommit In TARGET-PROCEDURE (pcRowIdent, lReopen).
  
  RETURN RETURN-VALUE NE "ADM-ERROR":U.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateQueryPosition) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION updateQueryPosition Procedure 
FUNCTION updateQueryPosition RETURNS LOGICAL PRIVATE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Reset the QueryPosition property after a record navigation.  
           The main purpose of this function is to eliminate duplication, 
           errors and minimalize messaging (setQueryPosition PUBLISHes)
           in fetchFirst, fetchPrev, fetchNext and fetchLast.   
    Notes: data.p should update LastRowNum, FirstRowNum and LastDbRowIdent
           properties and call this. 
         - The properties LastRowNum and FirstRowNum stores the 
           RowObject.RowNum of the first and last record in the database query. 
         - The LastDbRowIdent is updated at openQuery() if CheckLastOnOpen is 
           true and enables identification of the last record in cases where 
           LastRowNum has not yet been updated. 
          - currently PRIVATE for data.p only   
------------------------------------------------------------------------------*/
  DEFINE VARIABLE hRowObject   AS HANDLE  NO-UNDO.
  DEFINE VARIABLE iLastRowNum  AS INT     NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INT     NO-UNDO.  
  DEFINE VARIABLE cLastDbRowId AS CHAR    NO-UNDO.  
  DEFINE VARIABLE hRowNum      AS HANDLE  NO-UNDO.
  DEFINE VARIABLE hRowIdent    AS HANDLE  NO-UNDO.
  DEFINE VARIABLE lLast        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE cQueryPos    AS CHAR    NO-UNDO.

  {get RowObject hRowObject}.
  
  IF hRowObject:AVAILABLE THEN
  DO:
    {get FirstRowNum iFirstRowNum}.
    {get LastRowNum iLastRowNum}.
    {get LastDbRowIdent cLastDbRowId}.
    
    ASSIGN
      hRowNum   = hRowObject:BUFFER-FIELD('RowNum':U)
      hRowIdent = hRowObject:BUFFER-FIELD('RowIdent':U)
      /* Are we on the last record?  */
      lLast     = hRowNum:BUFFER-VALUE   = iLastRowNum
                  OR
                 (hRowIdent:BUFFER-VALUE <> "":U AND  
                  hRowIdent:BUFFER-VALUE = cLastDbRowId) 
      cQueryPos = IF hRowNum:BUFFER-VALUE = iFirstRowNum                   
                  THEN (IF NOT lLast 
                        THEN 'FirstRecord':U 
                        ELSE 'OnlyRecord':U) /* first AND last is ONLY */
                  ELSE (IF NOT lLast 
                        THEN 'NotFirstOrLast':U /* not first and not last */ 
                        ELSE 'LastRecord':U).   
  END. /* If hRowObject:available */
  ELSE cQueryPos = 'NoRecordAvailable':U.
  
  {set QueryPosition cQueryPos}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

