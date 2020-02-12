/* brsoffnd.i - trigger code for OFF-END trigger of SmartdataBrowse - 08/23/99 */
  DEFINE VARIABLE hDataSource AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hFocus      AS HANDLE    NO-UNDO.
  DEFINE VARIABLE lQuery      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lModified   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord  AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE iLastRowNum AS INTEGER   NO-UNDO.
  
  /* If this object is browsing a DataObject query, then when we scroll 
     to the end, see if there are more rows in the database query 
     to be transferred to the RowObject query. */
  {get QueryObject lQuery}.
  IF NOT lQuery THEN
  DO:
    iLastRowNum = DYNAMIC-FUNCTION('linkProperty':U,
                                   INPUT 'DATA-SOURCE':U,
                                   INPUT 'LastRowNum':U).
    IF iLastRowNum NE ? THEN RETURN. /* If we have already fetched the last row then return */
    {get DataModified lModified}.
    IF lModified THEN DO:                   
      {get NewRecord cNewRecord}.    
      showMessage(IF cNewRecord = 'no':U THEN '12':U ELSE IF cNewRecord = 'add':U THEN '13':U ELSE '14':U).
      RUN applyEntry (?).
      RETURN NO-APPLY.
    END.

     ASSIGN hFocus  = FOCUS.               
     RUN fetchDataSet ('BatchStart':U).     
    
    IF LOOKUP(KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)),"CURSOR-DOWN,TAB":U) NE 0 THEN
        {&BROWSE-NAME}:SET-REPOSITIONED-ROW({&BROWSE-NAME}:DOWN,"ALWAYS":U).
    ELSE IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "PAGE-DOWN":U THEN
        {&BROWSE-NAME}:SET-REPOSITIONED-ROW(1,"ALWAYS":U).
        
    {get DataSource hDataSource}.
    IF VALID-HANDLE(hDataSource) THEN      /* sanity check */
      RUN fetchBatch IN hDataSource(yes).  /* yes -- move forwards */
      
    RUN fetchDataSet ('BatchEnd':U).      
    
   {&BROWSE-NAME}:SELECT-ROW({&BROWSE-NAME}:NUM-ITERATIONS).      
   {&BROWSE-NAME}:SET-REPOSITIONED-ROW ({&BROWSE-NAME}:DOWN,"CONDITIONAL":U). 
   
   RUN dataAvailable IN hDataSource ("DIFFERENT":U) NO-ERROR. 
   
   IF VALID-HANDLE(hFocus) THEN        
     IF hFocus:PARENT = {&BROWSE-NAME}:HANDLE THEN      
      RUN applyCellEntry (IF KEYFUNCTION(KEYCODE(LAST-EVENT:LABEL)) = "TAB":U THEN ? ELSE hFocus:Name).
   
    
  END.









