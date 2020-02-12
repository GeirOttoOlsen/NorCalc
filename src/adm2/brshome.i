/* brshome.i - include file for SmartDataBrowser ON HOME trigger*/
 
  DEFINE VARIABLE lQuery  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE hSource AS HANDLE  NO-UNDO.
  
  /* Reposition flag means ignore this event because it occured
     as a side-effect of another reposition event. */
  IF NOT glReposition THEN
  DO:
  /* If this Browser does not manage its own db query,
     then tell the DataSource to reposition to the
     last row in the dataset, even if that means
     getting additional batches of rows from the db.
     Otherwise, if this *is* a db browser, run it locally
     to set FirstRowNum and other effects of fetchFirst. */
     
  /* Refreshable off to prevent flashing while
     batches of rows are being retrieved. */
     BROWSE {&BROWSE-NAME}:REFRESHABLE = no.
  /* We need to set cLastEvent = "HOME" here so that when dataAvailable
     is published from fetchFirst we can use this to determine whether
     home should be applied */
     ASSIGN cLastEvent = "HOME":U.
     {get QueryObject lQuery}.
     IF lQuery THEN 
       RUN fetchFirst IN THIS-PROCEDURE.   
     ELSE DO:
       {get DataSource hSource}.
       IF VALID-HANDLE(hSource) THEN
         RUN fetchFirst IN hSource.
     END.    /* END DO IF NOT lQuery   */
     BROWSE {&BROWSE-NAME}:REFRESHABLE = yes.
  END.   /* END IF NOT Reposition */

