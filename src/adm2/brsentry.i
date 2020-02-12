/* brsentry.i - trigger code for ROW-ENTRY trigger of SmartDataBrowse - 02/17/99 */
/* Retrieves and displays initial values for Add or Copy. */
  DEFINE VARIABLE cColValues    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cRowIdent     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE hUpdateTarget AS HANDLE    NO-UNDO.
  DEFINE VARIABLE cTarget       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lInitted      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cNewRecord    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cFields       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lModified       AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE cModifiedFields AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE hCell           AS HANDLE    NO-UNDO.  
  DEFINE VARIABLE hQuery          AS HANDLE    NO-UNDO.
  DEFINE VARIABLE hBuffer         AS HANDLE    NO-UNDO.    
  DEFINE VARIABLE iCnt            AS INTEGER   NO-UNDO.  

  {get DataModified lModified}. 
  {get BrowseInitted lInitted}.
  IF {&BROWSE-NAME}:NEW-ROW AND (NOT lInitted) THEN
  DO:
    /* Prevents initial values from being displaued twice
       if focus leaves the row (NOTE: still needed ) */
    {get UpdateTarget cTarget}.
    hUpdateTarget  = WIDGET-HANDLE(cTarget).
    IF VALID-HANDLE(hUpdateTarget) THEN
    DO:
      {get NewRecord cNewRecord}.
      {get DisplayedFields cFields}.
      IF cNewRecord = 'Add':U THEN   /* if it's Add, not Copy */
        cColValues = dynamic-function 
          ("addRow":U IN hUpdateTarget, cFields). 
      ELSE cColValues = dynamic-function 
        ("copyRow":U IN hUpdateTarget, cFields).  
      cRowIdent = ENTRY(1, cColValues, CHR(1)).  /* save off for Save */
      {set RowIdent cRowIdent}.  /* save off for Save */
      RUN displayFields IN TARGET-PROCEDURE(cColValues).
        {set BrowseInitted yes}.
    END.  /* END DO IF VALID-HANDLE */
    ELSE dynamic-function('showMessage':U,
     "No UpdateTarget present for Add/Copy operation.":U).
  END.    /* END DO IF NEW-ROW */
  
  ELSE IF lModified THEN DO:    
    {get ModifiedFields cModifiedFields}.
    ASSIGN 
        hQuery    = {&BROWSE-NAME}:QUERY
        hBuffer   = hQuery:GET-BUFFER-HANDLE(1)
        cRowIdent = IF STRING(hBuffer:ROWID) NE ? THEN STRING(hBuffer:ROWID) ELSE '':U
        .
    IF cRowIdent = ENTRY(1,cModifiedFields) THEN
        DO iCnt = 2 TO NUM-ENTRIES(cModifiedFields):
            ASSIGN
                hCell = WIDGET-HANDLE(ENTRY(iCnt,cModifiedFields))
                hCell:modified  = yes
                .
        END. /* DO iCnt = 2 TO ... */
  END. /* END IF lModified */
