&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : dataext.p
    Purpose     : Support procedure for Data Object.  This is an extension
                  of data.p.  The extension is necessary to avoid an overflow
                  of the action segment.  This extension file contains all of
                  the "standard" get and set property functions.  These
                  functions will be rolled back into data.p when segment size
                  increases.

    Syntax      : adm2/dataext.p

    Modified    : December 27, 1999 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Tell dataprop.i that this is the Super procedure */
  &SCOP ADMSuper dataext.p

  DEFINE VARIABLE ghRowObject AS HANDLE    NO-UNDO. /* Handle of current TT rec.*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASInfo Procedure 
FUNCTION getASInfo RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getASUsePrompt Procedure 
FUNCTION getASUsePrompt RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCheckCurrentChanged Procedure 
FUNCTION getCheckCurrentChanged RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
(  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDestroyStateless Procedure 
FUNCTION getDestroyStateless RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDisconnectAppServer Procedure 
FUNCTION getDisconnectAppServer RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getEnabledTables Procedure 
FUNCTION getEnabledTables RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterSource Procedure 
FUNCTION getFilterSource RETURNS HANDLE
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFilterWindow Procedure 
FUNCTION getFilterWindow RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstResultRow Procedure 
FUNCTION getFirstResultRow RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFirstRowNum Procedure 
FUNCTION getFirstRowNum RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastResultRow Procedure 
FUNCTION getLastResultRow RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastRowNum Procedure 
FUNCTION getLastRowNum RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getQueryRowIdent Procedure 
FUNCTION getQueryRowIdent RETURNS CHARACTER
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

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerOperatingMode Procedure 
FUNCTION getServerOperatingMode RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getServerSubmitValidation Procedure 
FUNCTION getServerSubmitValidation RETURNS LOGICAL
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS HANDLE
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-setASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASInfo Procedure 
FUNCTION setASInfo RETURNS LOGICAL
  ( pcInfo AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setASUsePrompt Procedure 
FUNCTION setASUsePrompt RETURNS LOGICAL
  ( plFlag AS LOGICAL )  FORWARD.

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

&IF DEFINED(EXCLUDE-setCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCheckCurrentChanged Procedure 
FUNCTION setCheckCurrentChanged RETURNS LOGICAL
  ( plCheck AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientProxyHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setClientProxyHandle Procedure 
FUNCTION setClientProxyHandle RETURNS LOGICAL
  ( pcClientProxy AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitSourceEvents Procedure 
FUNCTION setCommitSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDestroyStateless Procedure 
FUNCTION setDestroyStateless RETURNS LOGICAL
  (plDestroy AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisconnectAppserver) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDisconnectAppserver Procedure 
FUNCTION setDisconnectAppserver RETURNS LOGICAL
  (plDisconnect AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterSource Procedure 
FUNCTION setFilterSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFilterWindow Procedure 
FUNCTION setFilterWindow RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFirstResultRow Procedure 
FUNCTION setFirstResultRow RETURNS LOGICAL
  ( pcFirstResultRow AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastDbRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastDbRowIdent Procedure 
FUNCTION setLastDbRowIdent RETURNS LOGICAL
  ( pcLastDbRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastResultRow Procedure 
FUNCTION setLastResultRow RETURNS LOGICAL
  ( pcLastResultRow AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLastRowNum Procedure 
FUNCTION setLastRowNum RETURNS LOGICAL
  ( piLastRowNum AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setQueryRowIdent Procedure 
FUNCTION setQueryRowIdent RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRebuildOnRepos Procedure 
FUNCTION setRebuildOnRepos RETURNS LOGICAL
  ( plRebuild AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerOperatingMode Procedure 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  ( pcServerOperatingMode AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setServerSubmitValidation Procedure 
FUNCTION setServerSubmitValidation RETURNS LOGICAL
  ( plVal AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

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
         HEIGHT             = 11.19
         WIDTH              = 53.6.
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


/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAppService Procedure 
FUNCTION getAppService RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Partition name which this object 
            will run on, if any.
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cAppService AS CHARACTER NO-UNDO.
  {get AppService cAppService}.
  RETURN cAppService.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASDivision) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASDivision Procedure 
FUNCTION getASDivision RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the "Division" property for a Data Object, whether it is
            the "Client" side of a divided object, the "Server" side, or both,
            in which case its value could be "Both" or blank.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cASDivision AS CHARACTER NO-UNDO.
  {get ASDivision cASDivision}.
  RETURN cASDivision.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASInfo Procedure 
FUNCTION getASInfo RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the AppServer Information string, if any,
            used as a parameter when this object connects to its 
            Partition.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cASInfo AS CHARACTER NO-UNDO.
  {get ASInfo cASInfo}.
  RETURN cASInfo.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getASUsePrompt Procedure 
FUNCTION getASUsePrompt RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns (LOGICAL) a flag indicating whether the supporting code
            should prompt for a Username and Password, when connecting to
            its Application Partition.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lASUse AS LOGICAL NO-UNDO.
  {get ASUsePrompt lASuse}.
  RETURN lASUse.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getAutoCommit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getAutoCommit Procedure 
FUNCTION getAutoCommit RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether a Commit happens on every 
            Record update.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lAuto AS LOGICAL NO-UNDO.
  {get AutoCommit lAuto}.
  RETURN lAuto.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCheckCurrentChanged Procedure 
FUNCTION getCheckCurrentChanged RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether the DataObject code should check
            whether the database row(s) being updated have been changed since read.
   Params:  <none>
    Notes:  TRUE by default.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lCheck AS LOGICAL NO-UNDO.
  {get CheckCurrentChanged lCheck}.
  RETURN lCheck.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSource Procedure 
FUNCTION getCommitSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's CommitSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get CommitSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitSourceEvents Procedure 
FUNCTION getCommitSourceEvents RETURNS CHARACTER
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events this object subscribes to in its
            Commit-Source
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitSourceEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTarget Procedure 
FUNCTION getCommitTarget RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's CommitTarget, in character form.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get CommitTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCommitTargetEvents Procedure 
FUNCTION getCommitTargetEvents RETURNS CHARACTER
(  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of events this object subscribes to in its
            Commit-Target
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get CommitTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataHandle Procedure 
FUNCTION getDataHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle to the temp-table query
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hData AS HANDLE NO-UNDO.
  {get DataHandle hData}.
  RETURN hData.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataModified Procedure 
FUNCTION getDataModified RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a flag indicating whether some DataTarget of this object
            has unsaved changes. This value may be queried by other DataTargets
            to enable them to set their own state properly.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lModified AS LOGICAL NO-UNDO.
  {get DataModified lModified}.
  RETURN lModified.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDestroyStateless Procedure 
FUNCTION getDestroyStateless RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose: Defines if the persistent sdo should be destroyed on stateless requests
    Notes: This is only possible to set to false in WebSpeed (default). 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDestroy AS LOGICAL NO-UNDO.
  {get DestroyStateless lDestroy}.
  RETURN lDestroy.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDisconnectAppServer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDisconnectAppServer Procedure 
FUNCTION getDisconnectAppServer RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: Should the persistent sdo disconnect the AppServer.  
    Notes: This is only used for stateless WebSpeed SDO's that never are destroyed 
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lDisconnect AS LOGICAL NO-UNDO.
  {get DisconnectAppServer lDisconnect}.
  RETURN lDisconnect.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getEnabledTables) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getEnabledTables Procedure 
FUNCTION getEnabledTables RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the database tables which have enabled fields.
   Params:  <none>
    Notes:  NOTE: Is this really needed?
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTables AS CHARACTER NO-UNDO.
  {get EnabledTables cTables}.
  RETURN cTables. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterSource Procedure 
FUNCTION getFilterSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's FilterSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get FilterSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterWindow Procedure 
FUNCTION getFilterWindow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Partition name which this object 
            will run on, if any.
   Params:  none
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFilterWindow AS CHARACTER NO-UNDO.
  {get FilterWindow cFilterWindow}.
  RETURN cFilterWindow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstResultRow Procedure 
FUNCTION getFirstResultRow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the FirstResultRow (unknown if first row hasn't been
            fetched, 1 concatinated with the rowid if it has.)
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cFirstResultRow AS CHARACTER NO-UNDO.
  {get FirstResultRow cFirstResultRow}.
  RETURN cFirstResultRow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFirstRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFirstRowNum Procedure 
FUNCTION getFirstRowNum RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the temp-table row number of the first row.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRow AS INTEGER NO-UNDO.
  {get FirstRowNum iRow}.
  RETURN iRow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastResultRow Procedure 
FUNCTION getLastResultRow RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the LastResultRow (unknown if last row hasn't been
            fetched, RowNum concatinated with the rowid if it has.)
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cLastResultRow AS CHARACTER NO-UNDO.
  {get LastResultRow cLastResultRow}.
  RETURN cLastResultRow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastRowNum Procedure 
FUNCTION getLastRowNum RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the temp-table row number of the last row.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRow AS INTEGER NO-UNDO.
  {get LastRowNum iRow}.
  RETURN iRow.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getQueryRowIdent Procedure 
FUNCTION getQueryRowIdent RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the property which holds a RowIdent to be used to
            position an SDO query when it if first opened.
    Params: <none>
    Notes:  Generally used to save the position of a query when it is
            closed so that position can be restored on re-open.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cRowIdent AS CHARACTER NO-UNDO.
  {get QueryRowIdent cRowIdent}.
  RETURN cRowIdent.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRebuildOnRepos Procedure 
FUNCTION getRebuildOnRepos RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the flag indicating whether the RowObject temp-table
            should be rebuilt if a fetchLast or other reposition is done
            which is outside the bounds of the current dataset.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE lRebuild AS LOGICAL NO-UNDO.
  {get RebuildOnRepos lRebuild}.
  RETURN lRebuild.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRowsToBatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRowsToBatch Procedure 
FUNCTION getRowsToBatch RETURNS INTEGER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the number of rows to be transferred from the database
            query into the RowObject temp-table at a time.
   Params:  <none>
    Notes:  set to 200 by default.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iRows AS INTEGER NO-UNDO.
  {get RowsToBatch iRows}.
  RETURN iRows.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerOperatingMode Procedure 
FUNCTION getServerOperatingMode RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the operating mode of the server.  Possible values are 
            STATE-RESET, STATE-AWARE, STATELESS and ? (Hasn't been queried yet.)
   Params:  <none>
    Notes:  The instance property can be forced to STATE-RESET.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cServerOperatingMode AS CHARACTER NO-UNDO.
  {get ServerOperatingMode cServerOperatingMode}.
  RETURN cServerOperatingMode.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getServerSubmitValidation Procedure 
FUNCTION getServerSubmitValidation RETURNS LOGICAL
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the value of the property which signals whether the
            column and RowObject Validation procedures done as part of
            client validation are to be executed on the server side. 
            If *yes*, normally when the SDO is being run through the 
            open client interface, then serverCommit will execute 
            SubmitValidation itself.
    Notes:  Because the set function verifies that the property is not
            reset from *yes* to *no* (for security purposes),
            the property value is always accessed through the
            set and get functions.
------------------------------------------------------------------------------*/
  
DEFINE VARIABLE lVal       AS LOGICAL NO-UNDO.

  /* "No" in this include means don't do SUPER(). */
  {src/adm2/cltorsvr.i getServerSubmitValidation LOG '' NO}
  ELSE DO:
    /* If there's no client/server division or this is the server,
       then execute the function here. */
    ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
           ghProp = ghProp:BUFFER-FIELD('ServerSubmitValidation':U)
           lVal    = ghProp:BUFFER-VALUE NO-ERROR.
    RETURN lVal.   /* Function return value. */
  END.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's UpdateSource.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get UpdateSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setAppService) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setAppService Procedure 
FUNCTION setAppService RETURNS LOGICAL
  ( pcPartition AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the AppService property which names the Partition
            this object will run on, if any.
   Params:  pcPartition -- Partition name
    Notes:  The default value is the APPLICATION-PARTITION preprocessor value 
            which can be defined in the procedure settings dialog in the 
            AppBuilder.
------------------------------------------------------------------------------*/
  {set AppService pcPartition}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASInfo) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASInfo Procedure 
FUNCTION setASInfo RETURNS LOGICAL
  ( pcInfo AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the AppServer Information string 
            which is passed to the AppServer connection as a parameter.
   Params:  pcInfo -- information string 
------------------------------------------------------------------------------*/
  {set ASInfo pcInfo}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setASUsePrompt) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setASUsePrompt Procedure 
FUNCTION setASUsePrompt RETURNS LOGICAL
  ( plFlag AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the flag on or off which indicates whether the support code 
            should prompt for a Username and Password when connecting to an
            AppServer session.
   Params:  plFlag AS LOGICAL  -- If true, the code will prompt.
------------------------------------------------------------------------------*/

  {set ASUsePrompt plFlag}.
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
  Purpose:  Sets the AutoCommit flag on or off; when On, every call to submitRow
            will result in a Commit.
   Params:  plFlag AS LOGICAL  -- If true, AutoCommit is set On.
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

&IF DEFINED(EXCLUDE-setCheckCurrentChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCheckCurrentChanged Procedure 
FUNCTION setCheckCurrentChanged RETURNS LOGICAL
  ( plCheck AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets a flag indicating whether the DataObject should check 
            if database record(s) have been changed since read, before 
            doing an update.
   Params:  plCheck AS LOGICAL -- YES if the code should check that the record
            has not been changed by another user and reject the change (default).
------------------------------------------------------------------------------*/

  {set CheckCurrentChanged plCheck}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setClientProxyHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setClientProxyHandle Procedure 
FUNCTION setClientProxyHandle RETURNS LOGICAL
  ( pcClientProxy AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: To store the character version of the client-side SDO handle
   Params: The string containing the client-side SDO procedure handle
    Notes:  
------------------------------------------------------------------------------*/

  {set ClientProxyHandle pcClientProxy}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSource Procedure 
FUNCTION setCommitSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the CommitSource link value.
   Params:  phObject AS HANDLE -- procedure handle of this object's CommitSource 
------------------------------------------------------------------------------*/

  {set CommitSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitSourceEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitSourceEvents Procedure 
FUNCTION setCommitSourceEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events that this object wants to subscribe to
            in its Commit-Source.
   Params:  pcEvents AS CHARACTER -- list of events. Note that because it is
            a list, modifyListProperty should normally be used to add items. 
------------------------------------------------------------------------------*/

  {set CommitSourceEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTarget Procedure 
FUNCTION setCommitTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the CommitTarget link value.
   Params:  pcObject AS CHARACTER -- string form of procedure handle of this
              object's CommitTarget
------------------------------------------------------------------------------*/

  {set CommitTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCommitTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCommitTargetEvents Procedure 
FUNCTION setCommitTargetEvents RETURNS LOGICAL
  ( pcEvents AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the list of events that this object wants to subscribe to
            in its Commit-Target.
   Params:  pcEvents AS CHARACTER -- list of events. Note that because it is
            a list, modifyListProperty should normally be used to add items. 
------------------------------------------------------------------------------*/

  {set CommitTargetEvents pcEvents}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDestroyStateless) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDestroyStateless Procedure 
FUNCTION setDestroyStateless RETURNS LOGICAL
  (plDestroy AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Defines if the persistent sdo should be destroyed on stateless requests
    Notes: This is only possible to set to false in WebSpeed (default). 
------------------------------------------------------------------------------*/
  {set DestroyStateless plDestroy}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDisconnectAppserver) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDisconnectAppserver Procedure 
FUNCTION setDisconnectAppserver RETURNS LOGICAL
  (plDisconnect AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose: Defines if the persistent sdo should disconnect the AppServer.  
    Notes: This is only used for stateless WebSpeed SDO's that never are destroyed 
------------------------------------------------------------------------------*/
  {set DisconnectAppServer plDisconnect}.
  RETURN TRUE.
  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterSource Procedure 
FUNCTION setFilterSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FilterSource link value.
   Params:  phObject AS HANDLE -- procedure handle of this object's FilterSource 
------------------------------------------------------------------------------*/

  {set FilterSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFilterWindow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFilterWindow Procedure 
FUNCTION setFilterWindow RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FilterWindow property which is the name of the filter 
            container.
   Params:  pcObject -- Procedure name
    Notes:  
------------------------------------------------------------------------------*/
  {set FilterWindow pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFirstResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFirstResultRow Procedure 
FUNCTION setFirstResultRow RETURNS LOGICAL
  ( pcFirstResultRow AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the FirstResultRow property which is unknow if the first
            row has not been fetched, otherwise 1 concatinated with the
            rowid if it has
   Params:  pcFirstResultRow -- Row-num:RowId of the first row
    Notes:  
------------------------------------------------------------------------------*/
  {set FirstResultRow pcFirstResultRow}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastDbRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastDbRowIdent Procedure 
FUNCTION setLastDbRowIdent RETURNS LOGICAL
  ( pcLastDbRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the LastDbRowIdent property which is unknown if the last
           row has not been fetched, otherwise it is the database rowid(s)
           for the last row
   Params: pcLastDbRowIdent -- database RowId(s) of the last row
    Notes:   
    Notes:  
------------------------------------------------------------------------------*/
  {set LastDbRowIdent pcLastDbRowIdent}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastResultRow) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastResultRow Procedure 
FUNCTION setLastResultRow RETURNS LOGICAL
  ( pcLastResultRow AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the LastResultRow property which is unknown if the last
            row has not been fetched, otherwise its rownum concatinated
            with the rowid if it has
   Params:  pcLastResultRow -- Row-num:RowId of the last row
    Notes:  
------------------------------------------------------------------------------*/
  {set LastResultRow pcLastResultRow}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLastRowNum) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLastRowNum Procedure 
FUNCTION setLastRowNum RETURNS LOGICAL
  ( piLastRowNum AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Sets the LastRowNum property which is unknown if the last
           row has not been fetched, otherwise it is the rownum of the 
           last row
   Params: pcLastRowNum -- Rownum of the last row
    Notes:   
    Notes:  
------------------------------------------------------------------------------*/
  {set LastRowNum piLastRowNum}.
  RETURN TRUE.
                              
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setQueryRowIdent) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setQueryRowIdent Procedure 
FUNCTION setQueryRowIdent RETURNS LOGICAL
  ( pcRowIdent AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the property which holds a RowIdent to be used to
            position an SDO query when it if first opened.
    Params: pcRowIdent AS CHARACTER -- Rowid or comma-separated list of
            Rowids of the database record(s) to be positioned to.
    Notes:  Generally used to save the position of a query when it is
            closed so that position can be restored on re-open.
------------------------------------------------------------------------------*/

  {set QueryRowIdent pcRowIdent}.
  RETURN true.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRebuildOnRepos) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRebuildOnRepos Procedure 
FUNCTION setRebuildOnRepos RETURNS LOGICAL
  ( plRebuild AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Rebuild-On-Reposition flag
   Params:  plRebuild AS LOGICAL; if true, the RowObject temp-table will
            be rebuilt when a reposition is done which is outside the bounds
            of the current result set.
------------------------------------------------------------------------------*/
  {set RebuildOnRepos plRebuild}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerOperatingMode) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerOperatingMode Procedure 
FUNCTION setServerOperatingMode RETURNS LOGICAL
  ( pcServerOperatingMode AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cCurrentMode AS CHAR NO-UNDO.
  DEFINE VARIABLE cAsDivision  AS CHAR NO-UNDO.
  
  {get ServerOperatingMode cCurrentMode}.
  
  /* 'Stateless' is set from the AppServer, it can be forced to 'state-reset',
      but must NOT be set to NONE when this is a 'client' */

  IF  CAN-DO("STATELESS,STATE-RESET":U,cCurrentMode)  
  AND pcServerOperatingMode = "NONE":U 
  AND SOURCE-PROCEDURE <> TARGET-PROCEDURE THEN
  DO:
    {get ASDivision cASDivision}.
    IF cASDivision = 'Client':U THEN
      RETURN FALSE.
  END. /* if changing 'stateless' to 'none' */

  {set ServerOperatingMode pcServerOperatingMode}.

  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setServerSubmitValidation) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setServerSubmitValidation Procedure 
FUNCTION setServerSubmitValidation RETURNS LOGICAL
  ( plVal AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the value of the property which signals whether the
            column and RowObject Validation procedures done as part of
            client validation should be executed on the server. 
            It is *no* by default; an SDO which uses client
            validation and which may be run from the open client interface
            should set it to *yes*, either in the SDO itself or at runtime.
            If it is *no* when serverCommit executes, then serverCommit 
            will execute SubmitValidation itself.
   Params:  plVal AS LOGICAL  -- yes if client validation should be executed
              in the server SDO.
   Notes:   As a security measure, if the property has been set to *yes*,
            it cannot be reset to *no*.
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE lVal AS LOGICAL NO-UNDO.
  
  /* "No" in this include means don't do SUPER(). */
  {src/adm2/cltorsvr.i setServerSubmitValidation LOG plVal NO}
  ELSE DO:
    {get ServerSubmitValidation lVal}.
    IF lVal = YES THEN
      RETURN plVal.   /* Cannot be reset from yes value to no. */
    ELSE DO:
      ASSIGN ghProp = WIDGET-HANDLE(ENTRY(1, TARGET-PROCEDURE:ADM-DATA, CHR(1)))
             ghProp = ghProp:BUFFER-FIELD('ServerSubmitValidation':U)
             ghProp:BUFFER-VALUE = plVal NO-ERROR.
      RETURN TRUE.      /* signal that the property was reset successfully. */
    END.
  END.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the UpdateSource link value.
   Params:  phObject AS HANDLE -- procedure handle of this object's UpdateSource 
------------------------------------------------------------------------------*/

  {set UpdateSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

