/* brsscrl.i - trigger code for SCROLL-NOTIFY trigger of SmartDataBrowse - 10/19/99 */

/* If the number of rows currently displayed in the browse is less than the  
   number than can be displayed in the browse then we may have gotten to the
   end of a batch and need to get more rows to display*/                                 
IF BROWSE {&BROWSE-NAME}:NUM-ENTRIES < BROWSE {&BROWSE-NAME}:DOWN THEN DO:
  {src/adm2/brsoffnd.i}
END.  /* if num-entries < down */





