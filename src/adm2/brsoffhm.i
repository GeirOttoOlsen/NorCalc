/* brsoffhm.i - trigger code for OFF-HOME trigger of SmartdataBrowse - 08/24/99 */
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFocus      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQuery      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lModified   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE hCell       AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hCellEntry  AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE iCount      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE iFirstRowNum AS INTEGER   NO-UNDO.
   
  /* If this object is browsing a DataObject query, then when we scroll 
     to the end, see if there are more rows in the database query 
     to be transferred to the RowObject query. */
  {get QueryObject lQuery}.
  IF NOT lQuery THEN
  DO:
    iFirstRowNum = DYNAMIC-FUNCTION('linkProperty':U,
                                   INPUT 'DATA-SOURCE':U,
                                   INPUT 'FirstRowNum':U).
    IF iFirstRowNum NE ? THEN RETURN. /* If we have already fetched the first row then return */
    {get DataModified lModified}.
    IF lModified THEN DO:                     
      {get NewRecord cNewRecord}.    
      showMessage(IF cNewRecord = 'no':U THEN '12':U ELSE IF cNewRecord = 'add':U THEN '13':U ELSE '14':U).
      RUN applyEntry (?).
      RETURN NO-APPLY.
    END.

    ASSIGN hFocus  = FOCUS.                
    RUN fetchDataSet ('BatchStart':U).     
    
    IF LOOKUP(KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)),"CURSOR-UP,BACK-TAB":U) NE 0 THEN
        {&BROWSE-NAME}:SET-REPOSITIONED-ROW(1,"ALWAYS":U).
    ELSE IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "PAGE-UP":U THEN
        {&BROWSE-NAME}:SET-REPOSITIONED-ROW({&BROWSE-NAME}:DOWN,"ALWAYS":U).
        
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN      /* sanity check */
      RUN fetchBatch IN hDataSource(no).   /* no -- move backwards */
      
     RUN fetchDataSet ('BatchEnd':U).      
    
   {&BROWSE-NAME}:SELECT-ROW(1).
   {&BROWSE-NAME}:SET-REPOSITIONED-ROW ({&BROWSE-NAME}:DOWN,"CONDITIONAL":U). 
   RUN dataAvailable IN hDataSource ("DIFFERENT":U) NO-ERROR. 
   
   IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "BACK-TAB":U THEN DO:
        ASSIGN
        hCell = {&BROWSE-NAME}:FIRST-COLUMN.
        DO iCount = 1 TO {&BROWSE-NAME}:NUM-COLUMNS:
            ASSIGN 
            hCellEntry = hCell WHEN NOT hCell:READ-ONLY 
            hCell      = hCell:NEXT-COLUMN
            .
        END.
   END. /* IF "BACK-TAB" ... */
   ELSE IF VALID-HANDLE(hFocus) THEN        
            IF hFocus:PARENT = {&BROWSE-NAME}:HANDLE THEN hCellEntry = hFOCUS.      

   IF VALID-HANDLE(hCellEntry) THEN
       RUN applyCellEntry (hCellEntry:Name).
    
  END.

