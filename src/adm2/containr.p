&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*--------------------------------------------------------------------------
    File        : containr.p
    Purpose     : Code common to all containers, including WIndows and Frames

    Syntax      : adm2/containr.p

    Modified    : January 6, 2000 Version 9.1A
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* Tell cntnattr.i that this is the Super Procedure */
&SCOP ADMSuper containr.p

  {src/adm2/custom/containrexclcustom.i}

DEFINE VARIABLE giPrevPage AS INTEGER NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-getContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerTarget Procedure 
FUNCTION getContainerTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getContainerTargetEvents Procedure 
FUNCTION getContainerTargetEvents RETURNS CHARACTER
  (   )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getCurrentPage Procedure 
FUNCTION getCurrentPage RETURNS INTEGER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataTarget Procedure 
FUNCTION getDataTarget RETURNS CHARACTER
  ( )  FORWARD.

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

&IF DEFINED(EXCLUDE-getPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageNTarget Procedure 
FUNCTION getPageNTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPageSource Procedure 
FUNCTION getPageSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRunMultiple Procedure 
FUNCTION getRunMultiple RETURNS LOGICAL
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateTarget Procedure 
FUNCTION getUpdateTarget RETURNS CHARACTER
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pageNTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD pageNTargets Procedure 
FUNCTION pageNTargets RETURNS CHARACTER
  ( phTarget AS HANDLE, piPageNum AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setContainerTarget Procedure 
FUNCTION setContainerTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataTarget Procedure 
FUNCTION setDataTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER )  FORWARD.

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

&IF DEFINED(EXCLUDE-setPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageNTarget Procedure 
FUNCTION setPageNTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPageSource Procedure 
FUNCTION setPageSource RETURNS LOGICAL
  ( phObject AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRunMultiple Procedure 
FUNCTION setRunMultiple RETURNS LOGICAL
  ( plMultiple AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( phSource AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateTarget Procedure 
FUNCTION setUpdateTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER )  FORWARD.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/adm2/cntnprop.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignPageProperty) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignPageProperty Procedure 
PROCEDURE assignPageProperty :
/*------------------------------------------------------------------------------
  Purpose:  Sets the specified property in all objects on the CurrentPage of
            calling SmartContainer.
   Params:  INPUT pcProp AS CHARACTER -- property to set.
            INPUT pcValue AS CHARACTER -- value to assign to that property. 
                This is specified in CHARACTER form but can be used to
                assign values to non-character properties.
    Notes:  This variation on assignLinkProperty is necessary because 
            the notion of paging does not fit well with PUBLISH/SUBSCRIBE. 
            All objects in a Container will subscribe to initializeObject, etc., 
            but the paging performs the operation on subsets of those objects 
            at a time. That is, the container will not publish 'iniializeObject'
            to objects on a page other than zero until that page is first 
            viewed.  So properties such as HideOnInit which are set as part 
            of initialization must be set page-by-page.
            
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProp  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcValue AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iVar     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cObjects AS CHARACTER NO-UNDO.
  
  {get CurrentPage iVar}.
  cObjects = pageNTargets(TARGET-PROCEDURE, iVar).
  
  DO iVar = 1 TO NUM-ENTRIES(cObjects):
    dynamic-function("set":U + pcProp IN WIDGET-HANDLE(ENTRY(iVar, cObjects)),
      pcValue) NO-ERROR.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePage Procedure 
PROCEDURE changePage :
/*------------------------------------------------------------------------------
  Purpose:     Hides and views (and creates if necessary) objects in
               a Container when CurrentPage is reset
  Parameters:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cObjects    AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE iPageNum    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lInitted    AS LOGICAL   NO-UNDO.
  
  /* Let folder know, if any*/
  PUBLISH 'changeFolderPage':U FROM TARGET-PROCEDURE.  /* IN page-source */
  {get CurrentPage iPageNum}.

  /* If changing to page 0, don't look for PAGE0 links (there won't be any)
     or try to re-run create-objects for it. */
  IF iPageNum NE 0 THEN
  DO:
    {get ObjectInitialized lInitted}.
    cObjects = pageNTargets(TARGET-PROCEDURE, iPageNum).
    
    IF cObjects = "":U THEN 
    DO:                            /* Page hasn't been created yet: */
      RUN changeCursor IN TARGET-PROCEDURE('WAIT':U) NO-ERROR.
      
      /* Get objects on the new page created. */
      RUN createObjects IN TARGET-PROCEDURE.
      
      /* If the current container object has been initialized already,
         then initialize the new objects. Otherwise wait to let it happen
         when the container is init'ed. */
      IF lInitted THEN
          RUN notifyPage IN TARGET-PROCEDURE ("initializeObject":U).
      RUN changeCursor IN TARGET-PROCEDURE("":U) NO-ERROR.
    END.    /* END DO if page not created yet */
    ELSE 
    DO:
      /* If the container has been init'ed, then view its contents.
         If not, 'view' will have no effect yet, so just mark the
         contents to be viewed when the container *is* init'ed. */
      IF lInitted THEN
        RUN notifyPage IN TARGET-PROCEDURE ("viewObject":U).
      ELSE
        RUN assignPageProperty IN TARGET-PROCEDURE ('HideOnInit':U, 'No':U). 
    END.     /* END DO if page had been created */
  END.       /* END DO if PageNum NE 0 */

  /* Hide and view Page 0 (the default frame) of the window for character
     mode if switching to/from a page which is another window in GUI. */
  &IF "{&WINDOW-SYSTEM}":U = "TTY":U /*AND "{&FRAME-NAME}":U NE "":U */ &THEN
    DEFINE VARIABLE prevPageHdl     AS HANDLE  NO-UNDO.
    DEFINE VARIABLE newPageHdl      AS HANDLE  NO-UNDO.
    DEFINE VARIABLE prevPageIsWin   AS LOGICAL NO-UNDO.
    DEFINE VARIABLE newPageIsWin    AS LOGICAL NO-UNDO.
    DEFINE VARIABLE parentWinHdl    AS HANDLE  NO-UNDO.
    DEFINE VARIABLE defaultFrameHdl AS HANDLE  NO-UNDO.
    DEFINE VARIABLE procHdl         AS HANDLE  NO-UNDO.

    cObjects = pageNTargets(TARGET-PROCEDURE, iPageNum).
    IF cObjects NE "":U THEN DO:
      procHdl    = WIDGET-HANDLE(ENTRY(1,cObjects)).
      
      /* Is the new page a window? */
      {get ContainerHandle newPageHdl procHdl}.
    END.
  
    cObjects = pageNTargets(TARGET-PROCEDURE, giPrevPage).
    IF cObjects NE "":U THEN DO:
      procHdl     = WIDGET-HANDLE(ENTRY(1,cObjects)).

      /* Is the new page a window? */
      {get ContainerHandle prevPageHdl procHdl}.
    END.
    
    /* If both the prev and new pages are other windows, then do nothing. 
       Else if going to another window then HIDE page 0 of current window,
       or if coming *from* another window then VIEW page 0. */
    {get ContainerHandle parentWinHdl}.
    
    IF VALID-HANDLE(parentWinHdl) THEN
        defaultFrameHdl = parentWinHdl:FIRST-CHILD.
    IF VALID-HANDLE(defaultFrameHdl) THEN /* Sanity check that there is */
    DO:                                   /* a default frame in the caller. */
        IF VALID-HANDLE(newPageHdl) AND newPageHdl:TYPE = "WINDOW":U THEN
          newPageIsWin = yes.
        IF VALID-HANDLE(prevPageHdl) AND prevPageHdl:TYPE = "WINDOW":U THEN
          prevPageIsWin = yes.
          
        IF newPageIsWin AND NOT prevPageIsWin THEN
          HIDE defaultFrameHdl.         
        ELSE IF prevPageIsWin AND NOT newPageIsWin THEN
          VIEW defaultFrameHdl.
    END.
  &ENDIF

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-confirmExit) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE confirmExit Procedure 
PROCEDURE confirmExit :
/*------------------------------------------------------------------------------
  Purpose:     Passes this event on to its descendents, to check whether
               it is OK to exit (no unsaved changes, e.g.).
  Parameters:  INPUT-OUTPUT plCancel AS LOGICAL -- error flag which if set by
               any object will abort the destroy.
       Notes:  Invoked at the top by destroyObject.
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER plCancel AS LOGICAL NO-UNDO.
  
  PUBLISH 'confirmExit':U FROM TARGET-PROCEDURE
    (INPUT-OUTPUT plCancel).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructObject Procedure 
PROCEDURE constructObject :
/*------------------------------------------------------------------------------
  Purpose:     RUN from adm-create-objects to RUN a SmartObject,
               and to establish its parent and initial property settings.
  Parameters:  pcProcName AS CHARACTER -- the procedure name to run, 
               phParent   AS HANDLE    -- handle to parent its visualization to,
               pcPropList AS CHARACTER -- property list to set, 
               phObject   AS OUTPUT HANDLE -- the new procedure handle.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER  pcProcName   AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER  phParent     AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER  pcPropList   AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER phObject     AS HANDLE    NO-UNDO.

  DEFINE VARIABLE         hTemp         AS HANDLE    NO-UNDO.
  DEFINE VARIABLE         iCurrentPage  AS INTEGER   NO-UNDO.
  DEFINE VARIABLE         cVersion      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         iEntry        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE         cEntry        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cProperty     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cValue        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cSignature    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         iDB           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE         cDBList       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE         cDotRFile     AS CHARACTER NO-UNDO.
 
  IF NUM-ENTRIES(pcProcName, CHR(3)) > 1 THEN DO:
    /* This is a DB-AWARE object: 
       Determine if the appropriate DB's are connected. */
    
    /* First get the raw procname to run.  This is the "fall-back" if no .r is
       found.  It is also the file to run if all required DBs are connected. */
    ASSIGN pcProcName          = ENTRY(1, pcProcName, CHR(3))
    
    /* Find the .r file */
           FILE-INFO:FILE-NAME = ENTRY(1, pcProcName, ".":U) + ".r"
           cDotRFile           = FILE-INFO:FULL-PATHNAME.
    
    IF cDotRFile NE ? THEN DO:  /* We have found the .r */
      ASSIGN RCODE-INFO:FILE-NAME = cDotRFile
             cDBList              = RCODE-INFO:DB-REFERENCES.

      DB-CHECK:
      DO iDB = 1 TO NUM-ENTRIES(TRIM(cDBList)):   /* Remove blank when no db */
        IF NOT CONNECTED(ENTRY(iDB,cDBList)) THEN DO:
          ASSIGN pcProcName = ENTRY(1, pcProcName, ".":U) + "_cl.":U +
                              ENTRY(2, pcProcName, ".":U).
          LEAVE DB-CHECK.
        END.  /* Found a DB that needs to be connected that isn't */
      END.  /* Do for each required DB */
    END.  /* If we have the .r */
    ELSE /* Unable to locate the .r file - give the user a warning */
      DYNAMIC-FUNCTION("showmessage":U IN TARGET-PROCEDURE, "9,":U + pcProcName).
  END.  /* This object is DB-AWARE */
 
  RUN VALUE(pcProcName) PERSISTENT SET phObject.
  /* Verify that the object was created successfully. */
  IF NOT VALID-HANDLE (phObject) THEN RETURN ERROR.  

  /* Check to make sure that the object version is ADM2.0 or higher.
     If this isn't an "ADM2" object, then getObjectVersion won't be
     there and won't return anything. */
  {get ObjectVersion cVersion phObject} NO-ERROR.
  IF cVersion = ? OR cVersion LT "{&ADM-VERSION}":U THEN DO:
      dynamic-function("showMessage":U IN TARGET-PROCEDURE,
       "SmartObject ":U + phObject:FILE-NAME + " with Version ":U  + cVersion
              + " cannot be run by the {&ADM-VERSION} support code.":U).
      IF cVersion >= "ADM2.0":U THEN
        RUN destroyObject IN phObject NO-ERROR.
      ELSE RUN dispatch IN phObject ('destroy':U) NO-ERROR.
      STOP.
  END.
  
  /* For character mode, don't attempt to parent a new window procedure. */
  &IF "{&WINDOW-SYSTEM}":U = "TTY":U &THEN
  IF phParent:TYPE NE "WINDOW" THEN 
  &ENDIF
    {set ObjectParent phParent phObject}.

  /* Set any Instance Properties specified. The list is in the same format
     as returned to the function instancePropertyList, with CHR(3) between
     entries and CHR(4) between the property name and its value in each entry. 
     NOTE: we must get the datatype for each property in order to set it. */
  DO iEntry = 1 TO NUM-ENTRIES(pcPropList, CHR(3)):
    cEntry = ENTRY(iEntry, pcPropList, CHR(3)).
    cProperty = ENTRY(1, cEntry, CHR(4)).
    cValue = ENTRY(2, cEntry, CHR(4)).
    /* Get the datatype from the return type of the get function. */
    cSignature = dynamic-function
      ("Signature":U IN phObject, "get":U + cProperty).
    IF cSignature EQ "":U THEN    /* Blank means it wasn't found anywhere */
      dynamic-function("showMessage":U IN TARGET-PROCEDURE,
       "Property ":U  + cProperty + " not defined.":U). 
    ELSE CASE ENTRY(2,cSignature):
      WHEN "INTEGER":U THEN
        dynamic-function("set":U + cProperty IN phObject, INT(cValue)).
      WHEN "DECIMAL":U THEN
        dynamic-function("set":U + cProperty IN phObject, DEC(cValue)).
      WHEN "CHARACTER":U THEN
        dynamic-function("set":U + cProperty IN phObject, cValue).
      WHEN "LOGICAL":U THEN
        dynamic-function("set":U + cProperty IN phObject,
          IF cValue = "yes":U THEN yes ELSE no).
    END CASE.
  END.
      
  /* Now create the default link to the containing object. */
  RUN addLink IN TARGET-PROCEDURE(INPUT TARGET-PROCEDURE, INPUT "CONTAINER":U, INPUT phObject).     
  
  /* If the current "page" is not 0, then this object is part
     of a paging control. Setup a page link for it, and set its ObjectPage 
     property. */
  
  {get CurrentPage iCurrentPage}.
  IF iCurrentPage <> 0 THEN
  DO:
    RUN addLink IN TARGET-PROCEDURE(INPUT TARGET-PROCEDURE, INPUT "PAGE":U + STRING(iCurrentPage), 
          INPUT phObject). 
    {set ObjectPage iCurrentPage phObject}.
  END.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-createObjects) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createObjects Procedure 
PROCEDURE createObjects :
/*------------------------------------------------------------------------------
  Purpose:    Standard code for running the objects in a Container. It runs
              the AppBuilder-generated procedure named adm-create-objects 
              for compatibility with V8. 
  Parameters:  <none>
------------------------------------------------------------------------------*/

  RUN adm-create-objects IN TARGET-PROCEDURE NO-ERROR.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deletePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deletePage Procedure 
PROCEDURE deletePage :
/*------------------------------------------------------------------------------
  Purpose:  Deletes all the objects on the specified page.
   Params:  piPageNum AS INTEGER
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE iCurrentPage   AS INTEGER   NO-UNDO.
  
    {get CurrentPage iCurrentPage}. 
    /* Temporarily reset the current page, to tell the folder */  
    {set CurrentPage piPageNum}.
    /* Also tell the folder or other paging visualization, if any. */
    PUBLISH 'deleteFolderPage':U FROM TARGET-PROCEDURE.  
    RUN notifyPage IN TARGET-PROCEDURE ("destroyObject":U).
        
    {set CurrentPage iCurrentPage}.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     Does container-specific initialization.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lHideOnInit      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lDisableOnInit   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cType            AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iStartPage       AS INTEGER   NO-UNDO.
 
  {get ContainerType cType}.
  {get StartPage iStartPage}.
  IF cType = "FRAME":U OR cType = "VIRTUAL":U THEN
  DO:
    /* A SmartFrame or non-visual container does not RUN its own 
       create-objects. It's postponed until the SmartFrame is actually 
       initialized by its container (or by the UIB in design mode). */
    RUN createObjects IN TARGET-PROCEDURE. /* This will run adm-create-objects*/
    /* If there was a StartPage in the Frame, initializing that page has been
       postponed until createObjects for page 0 is done; so do it now. */
    IF iStartPage NE ? AND iStartPage NE 0 THEN
      RUN selectPage IN TARGET-PROCEDURE (iStartPage).
  END.   /* END DO IF cType */

  IF cType NE "VIRTUAL":U THEN    /* Skip for non-visual contaioners. */
  DO:
    {get HideOnInit lHideOnInit} NO-ERROR.
    {get DisableOnInit lDisableOnInit} NO-ERROR.  
  END.
  
  /* For containers, we need to propogate the HideOnInit and
     DisableOnInit attributes to children before initializing them. */   
  IF lHideOnInit OR lDisableOnInit THEN
  DO:
     /* Tell all the objects on the page to come up hidden,
        so the page doesn't flash on the screen. */
     IF lHideOnInit THEN  
        dynamic-function ("assignLinkProperty":U IN TARGET-PROCEDURE,
          'CONTAINER-TARGET':U, 'HideOnInit':U, 'yes':U).
     IF lDisableOnInit THEN   
        dynamic-function ("assignLinkProperty":U IN TARGET-PROCEDURE,
          'CONTAINER-TARGET':U, 'DisableOnInit':U, 'yes':U).
     /* For containers, whether DISABLE is explicitly set or not, we
        need to set it for the container itself if HideOnInit is true,
        because otherwise the 'enable' below will force the container
        to be viewed if it contains any simple objects. */
     lDisableOnInit = yes.
  END.    
  PUBLISH 'initializeObject':U FROM TARGET-PROCEDURE.

  /* Set StartPage to 0 so selectPage() will do the right thing. */
  IF iStartPage = ? THEN
    {set StartPage 0}.
 
  /* Do our own visualization last, after all contents are initialized. */
  RUN SUPER.
  IF RETURN-VALUE = "ADM-ERROR":U THEN 
    RETURN "ADM-ERROR":U.
 
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initPages) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initPages Procedure 
PROCEDURE initPages :
/*------------------------------------------------------------------------------
  Purpose:  Initializes one or more pages which are not yet being viewed, in
            order to establish links or to prepare for the pages being viewed.
   Params:  pcPageList AS CHARACTER -- comma-separated list of page numbers
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcPageList AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iPage        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iCurrentPage AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPageObjects AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iCnt         AS INTEGER   NO-UNDO.
  DEFINE VARIABLE lInitted     AS LOGICAL   NO-UNDO.
    
    {get CurrentPage iCurrentPage}. 
    
    DO iCnt = 1 TO NUM-ENTRIES(pcPageList): 
        iPage = INT(ENTRY(iCnt,pcPageList)).     
        {set CurrentPage iPage}.
        IF iPage NE 0 THEN 
        DO:                     /* Shouldn't be called for page 0 */
            cPageObjects = pageNTargets(TARGET-PROCEDURE, iPage).
            IF cPageObjects = "":U THEN
            DO:
                /* Page hasn't been created yet:
                   Get all objects on page init'd*/
                RUN createObjects IN TARGET-PROCEDURE.
                /* Tell the objects not to view themselves when they
                   are init'ed; wait until that page is actually selected.*/
                RUN assignPageProperty IN TARGET-PROCEDURE 
                  ('HideOnInit':U, 'Yes':U).
                /* If the current container object has been initialized already,
                   then initialize the new objects. Otherwise wait to let it 
                   happen when the container is init'ed. */
                {get ObjectInitialized lInitted}.
                IF lInitted THEN
                    RUN notifyPage IN TARGET-PROCEDURE ("initializeObject":U).
            END.
        END.
    END.

    {set CurrentPage iCurrentPage}.
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-notifyPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE notifyPage Procedure 
PROCEDURE notifyPage :
/*------------------------------------------------------------------------------
  Purpose:  Invokes the specified procedure in all objects on the CurrentPage of
            Container TARGET-PROCEDURE.
   Params:  pcProc AS CHARACTER -- internal procedure to run
    Notes:  This vestige of "notify" is necessary because the notion of paging
            does not fit well with PUBLISH/SUBSCRIBE. All objects in a Container
            will subscribe to initialize, etc., but the paging performs the
            operation on subsets of those objects at a time.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcProc AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE iVar     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cObjects AS CHARACTER NO-UNDO.
  
  {get CurrentPage iVar}.
  cObjects = pageNTargets(TARGET-PROCEDURE, iVar).
  
  DO iVar = 1 TO NUM-ENTRIES(cObjects):
    RUN VALUE(pcProc) IN WIDGET-HANDLE(ENTRY(iVar, cObjects)) NO-ERROR.
  END.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-passThrough) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE passThrough Procedure 
PROCEDURE passThrough :
/*------------------------------------------------------------------------------
  Purpose:     Acts as an intermediary for dynamic links which need the
               pass-through mechanism, to get an event from an object outside
               a container to one inside it, or vice-versa.
  Parameters:  pcLinkName AS CHARACTER -- the link (event) name to be passed on;
               pcArgument AS CHARACTER -- a single character string argument.
  Notes:       To use this for single pass-through events, define a PassThrough
               link from the Source to the intermediate container, and define
               the actual dynamic link from the container to the Target. 
               Then PUBLISH 'PassThrough' (LinkName, Argument) to send the event.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER pcLinkName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pcArgument AS CHARACTER NO-UNDO.
  
  PUBLISH pcLinkName FROM TARGET-PROCEDURE (pcArgument).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removePageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removePageNTarget Procedure 
PROCEDURE removePageNTarget :
/*------------------------------------------------------------------------------
  Purpose:     Removes an object from the list of Targets on a page.
  Parameters:  phTarget AS HANDLE -- handle of the object being removed;
               piPage   AS INTEGER -- page number the object is on.
  Notes:       Run from removeAllLinks for objects not on Page 0.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER phTarget AS HANDLE  NO-UNDO.
  DEFINE INPUT PARAMETER piPage   AS INTEGER NO-UNDO.
  
  /* The format of the PageNTargets list is <handle>|<page>[,...] */
  RUN modifyListProperty IN TARGET-PROCEDURE (TARGET-PROCEDURE, 'REMOVE':U, "PageNTarget":U,
    STRING(phTarget) + "|":U + STRING(piPage)).
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-selectPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE selectPage Procedure 
PROCEDURE selectPage :
/*------------------------------------------------------------------------------
  Purpose:  Changes the currently selected page. If the previous current page
            is not page 0 (the background page which is always visible), then 
            hideObject is run in all the objects on the CurrentPage. Then
            the CurrentPage is changed to the new page number of piPageNum, and
            the changePage procedure is run to view, and if necessary, create
            the objects on the new page.
   Params:  INPUT piPageNum AS INTEGER
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE iCurrentPage    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPageList       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iStartPage      AS INTEGER   NO-UNDO.
  
  /* If this property has its initial value of unknown, then we are
     in the middle of createObjects and want to postpone this selectPage
     until that is done. */
  {get StartPage iStartPage}.
  IF iStartPage = ? THEN
  DO:
    {set StartPage piPageNum}.
    RETURN.
  END.   /* END DO IF iStartPage = ? */

  {get CurrentPage iCurrentPage}. 
  IF iCurrentPage EQ piPageNum THEN 
  /* Don't reselect the same page unless the object(s) on that page
     have since been destroyed (a SmartWindow that was closed, e.g.). */
  DO:                   
      cPageList = pageNTargets(TARGET-PROCEDURE, iCurrentPage).
      IF cPageList NE "":U THEN 
        RETURN.
  END.

  IF iCurrentPage NE 0 THEN
      RUN notifyPage IN TARGET-PROCEDURE ("hideObject":U).
  /* Save old page for TTY change-page */
  giPrevPage = iCurrentPage. 
  {set CurrentPage piPageNum}.
  RUN changePage IN TARGET-PROCEDURE.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewObject Procedure 
PROCEDURE viewObject :
/*------------------------------------------------------------------------------
  Purpose:     (Visual) Container-specific code for viewObject. If the
                HideOnInit property has been set during initialization,
                to allow this object and its contents to be initialized
                without being viewed, turn that off here and explicitly
                view all contents.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  
  DEFINE VARIABLE lHide AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hContainer AS HANDLE NO-UNDO.
  DEFINE VARIABLE cUIBMode AS CHAR NO-UNDO.
  DEFINE VARIABLE cType    AS CHAR NO-UNDO.
  
  {get ContainerHandle hContainer}.
  {get ContainerType cType}.
  IF cType NE "VIRTUAL":U THEN   /* Non-visual container; nothing to view. */
  DO:
    {get UIBMode cUIBMode}.
    {get HideOnInit lHide}.
    IF lHide THEN
    DO:
      IF cUIBMode = "":U THEN DO:
        {set HideOnInit no}.
        DYNAMIC-FUNCTION('assignLinkProperty':U IN TARGET-PROCEDURE,
         INPUT 'Container-Target':U,
         INPUT 'HideOnInit':U,
         INPUT 'no':U ).
      END.   /* END DO IF UIBMODE = "" */
      PUBLISH 'viewObject':U FROM TARGET-PROCEDURE.
    END.     /* END IF lHide */
  END.       /* END OF NOT virtual container */
  
  RUN SUPER.
  IF VALID-HANDLE(hContainer) AND hContainer:TYPE = "WINDOW":U THEN
  DO:
    APPLY "ENTRY" TO hContainer.
    &IF "{&WINDOW-SYSTEM}":U <> "TTY":U &THEN
    hContainer:MOVE-TO-TOP().
    &ENDIF
  END.
     
  RETURN.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-viewPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE viewPage Procedure 
PROCEDURE viewPage :
/*------------------------------------------------------------------------------
  Purpose:  Views a new page without hiding the current page. This is
            intended to be run from application code which wants to view
            a new page which is a separate SmartWindow. viewPage will run
            changePage to view (and if necessary create) the new SmartWindow,
            but will not hide the objects on the current page, since they
            are in a separate window which can be viewed at the same time.
           
   Params:  INPUT piPageNum AS INTEGER
    Notes:  because the previous page is not hidden, the CurrentPage property
            is reset only temporarily so that changePage knows the new
            page number; then it is reset to its previous value.
------------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER piPageNum AS INTEGER NO-UNDO.
  
  DEFINE VARIABLE iCurrentPage    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cPageList       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iPrevPage       AS INTEGER   NO-UNDO.
  
  {get CurrentPage iCurrentPage}. 
  IF iCurrentPage EQ piPageNum THEN 
  /* Don't reselect the same page unless the object(s) on that page
     have since been destroyed (a SmartWindow that was closed, e.g.). */
  DO:                   
      cPageList = pageNTargets (TARGET-PROCEDURE, iCurrentPage).
      IF cPageList NE "":U THEN 
        RETURN.
  END.

  iPrevPage = iCurrentPage.
  /* Reset the current page temporarily for changePage */
  {set CurrentPage piPageNum}.
  RUN changePage IN TARGET-PROCEDURE.
  /* Now restore the currently selected page */
  {set CurrentPage iPrevPage}.

  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-getContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerTarget Procedure 
FUNCTION getContainerTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a list of the handles of the object's contained objects.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get ContainerTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getContainerTargetEvents) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getContainerTargetEvents Procedure 
FUNCTION getContainerTargetEvents RETURNS CHARACTER
  (   ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the events this object 
            wants to subscribe to in its ContainerTarget.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cEvents AS CHARACTER NO-UNDO.
  {get ContainerTargetEvents cEvents}.
  RETURN cEvents.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getCurrentPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getCurrentPage Procedure 
FUNCTION getCurrentPage RETURNS INTEGER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the current page number of the Container
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE iPage AS INTEGER NO-UNDO.
  {get CurrentPage iPage}.
  RETURN iPage.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataTarget Procedure 
FUNCTION getDataTarget RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Data Target (in CHARACTER form, because it may be
            a comma-separated list), normally for Pass-through support.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get DataTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFilterSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFilterSource Procedure 
FUNCTION getFilterSource RETURNS HANDLE
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the Filter Source for Pass-through support.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get FilterSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageNTarget Procedure 
FUNCTION getPageNTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the list of objects which are on some page other than 0.
   Params:  <none>
    Notes:  This property has a special format of "handle|page#' for each entry,
            and should not be manipulated directly. Use addLink.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget AS CHARACTER NO-UNDO.
  {get PageNTarget cTarget}.
  RETURN cTarget.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPageSource Procedure 
FUNCTION getPageSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's Page Source (folder), if any.
   Params:  <none>
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource AS HANDLE NO-UNDO.
  {get PageSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRunMultiple Procedure 
FUNCTION getRunMultiple RETURNS LOGICAL
  ( ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  def vAR plMultiple AS LOGICAL no-undo.  
  {get RunMultiple plMultiple}.
  RETURN plMultiple.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateSource Procedure 
FUNCTION getUpdateSource RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's Update-Source.
   Params:  <none>
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE hSource   AS HANDLE NO-UNDO.
  
  {get UpdateSource hSource}.
  RETURN hSource.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateTarget Procedure 
FUNCTION getUpdateTarget RETURNS CHARACTER
  (  ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns the handle of the object's Update-Target.
   Params:  <none>
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTarget   AS CHARACTER NO-UNDO.
  
  {get UpdateTarget cTarget}.
  RETURN cTarget.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-pageNTargets) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION pageNTargets Procedure 
FUNCTION pageNTargets RETURNS CHARACTER
  ( phTarget AS HANDLE, piPageNum AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns a comma-separated list of the objects on the 
            specified page for this container.
   Params:  <none>
    Notes:  This attribute is stored as a comma-separated list of entries, where
            each entry consists of an object handle (in string form) and its
            page number, separated by a vertical bar.
            The Target-Procedure is passed as a parameter because this function
            is only invoked locally, not IN the Target-procedure.
            This function is intended to be used only internally by the ADM
            paging code.
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cPageN   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE iObj     AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cTargets AS CHARACTER NO-UNDO INIT "":U.
  DEFINE VARIABLE cEntry   AS CHARACTER NO-UNDO.
  
  {get PageNTarget cPageN phTarget}.
  DO iObj = 1 TO NUM-ENTRIES(cPageN):
    cEntry = ENTRY(iObj, cPageN).
    IF INT(ENTRY(2, cEntry, "|":U)) = piPageNum THEN
      cTargets = cTargets + (IF cTargets = "":U THEN "":U ELSE ",":U)
        + ENTRY(1, cEntry, "|":U).
  END.
  
  RETURN cTargets.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setContainerTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setContainerTarget Procedure 
FUNCTION setContainerTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the ContainerTarget link value.
   Params:  pcObject AS CHARACTER -- handle or handles of the objects which
              should be made Container-Targets of this object.
    Notes:  Because the value can be a list, it should be modified using
             modifyListProperty, and is normally maintained by addLink.
------------------------------------------------------------------------------*/

  {set ContainerTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setDataTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataTarget Procedure 
FUNCTION setDataTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DataTarget object handle, normally for pass-through 
            support.
   Params:  pcTarget AS CHARACTER -- DataTarget procedure handle.
------------------------------------------------------------------------------*/

  {set DataTarget pcTarget}.
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
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set FilterSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageNTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageNTarget Procedure 
FUNCTION setPageNTarget RETURNS LOGICAL
  ( pcObject AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the PageNTarget link value.
   Params:  pcObject AS CHARACTER -- specially formatted list of objects and
              the pages they are on.
------------------------------------------------------------------------------*/

  {set PageNTarget pcObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setPageSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPageSource Procedure 
FUNCTION setPageSource RETURNS LOGICAL
  ( phObject AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the PageSource link value.
   Params:  phObject AS HANDLE
------------------------------------------------------------------------------*/

  {set PageSource phObject}.
  RETURN TRUE.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setRunMultiple) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRunMultiple Procedure 
FUNCTION setRunMultiple RETURNS LOGICAL
  ( plMultiple AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the DataTarget property that decides 
   Params:  plMultiple AS LOGICAL
------------------------------------------------------------------------------*/

  {set RunMultiple plMultiple}.
  RETURN TRUE.


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateSource) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateSource Procedure 
FUNCTION setUpdateSource RETURNS LOGICAL
  ( phSource AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the handle of the object's Update-Source
   Params:  phSource AS HANDLE
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
------------------------------------------------------------------------------*/

  {set UpdateSource phSource}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setUpdateTarget) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateTarget Procedure 
FUNCTION setUpdateTarget RETURNS LOGICAL
  ( pcTarget AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the handle of the object's Update-Target.
   Params:  pcTarget AS CHARACTER -- handle in character form
    Notes:  This is used for pass-through links, to connect an object
            inside the container with an object outside the container.
------------------------------------------------------------------------------*/

  {set UpdateTarget pcTarget}.
  RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

