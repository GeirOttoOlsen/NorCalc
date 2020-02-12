/*************************************************************/
/* Copyright (c) 1984-1998 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/*----------------------------------------------------------------------------

File: _qaredat.p

Description:
   Display _Area and Extent information for the quick index report.  It will go to 
   the currently set output device (e.g., a file, the printer).
 
Input Parameters:
   p_DbId - Id of the _Db record for this database.
   p_area  - The name of the area we're showing or "ALL".

Author: Donna L. McMann

Date Created: 1/5/98
    Modified: 04/09/98 D. McMann changed the area type from a number to the name. 


----------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p_DbId AS RECID NO-UNDO.


DEFINE SHARED STREAM rpt.

Define variable Etype    as logical format "Variable/Fixed" NO-UNDO.
DEFINE VARIABLE esize    AS CHARACTER  FORMAT "X(10)"       NO-UNDO.
DEFINE VARIABLE atype    AS CHARACTER  FORMAT "x(20)"       NO-UNDO.
DEFINE VARIABLE areatype AS CHARACTER EXTENT 7              NO-UNDO.
ASSIGN areatype[1] = "Invalid"
       areatype[2] = "Control Recovery"
       areatype[3] = "Before-image"
       areatype[4] = "Transaction Log"
       areatype[5] = "Event Log"
       areatype[6] = "Data"
       areatype[7] = "After-image".

FORM
    _area._area-number label "Area Number"            
    atype  label  "Type" SPACE (5)
    _area-blocksize format ">>>>>9" label "Block Size" SKIP space (5)
     _area-extents format ">>>9" label "Total Extents in Area" SPACE (5)
    _area-name label "Name"
   SKIP
   WITH FRAME areahdr WIDTH 80 USE-TEXT SIDE-LABELS STREAM-IO.

FORM
  space (5)
   _extent-number Label "Extent #"
   etype  Label "Type"
   esize  Label "Size" 
   _extent-path format "x(30)" label "Name"
  WITH FRAME shoextent 
  DOWN USE-TEXT STREAM-IO.

FORM
  SKIP(1) 
  SPACE(3) _Area._Area-name LABEL "Working on" FORMAT "x(32)" SPACE
  SKIP(1)
  WITH FRAME working_on SIDE-LABELS VIEW-AS DIALOG-BOX 
  TITLE "Generating Report".


/*----------------------------Mainline code--------------------------------*/

SESSION:IMMEDIATE-DISPLAY = yes.

FOR EACH _Area NO-LOCK :
       
   PAGE STREAM rpt.

      DISPLAY _Area._Area-name 
          WITH FRAME working_on.
   
   IF _area-type = 0 THEN
     DISPLAY STREAM rpt _Area._Area-name _area._area-number 
        areatype[_area-type + 1 ] @ atype _area-blocksize _area-extents
        WITH FRAME areahdr.

   ELSE
     DISPLAY STREAM rpt _Area._Area-name _area._area-number 
        areatype[_area-type] @ atype _area-blocksize _area-extents
        WITH FRAME areahdr.
   
   FOR EACH _AreaExtent OF _Area NO-LOCK
     BREAK BY _AreaExtent._Extent-path:
     
     /* Currently you can only have fixed and variable length area extents
        but there is also a raw type.  When this is available this code
        has to change to handle three types FIXED,VARIABLE,RAW
     */   
      IF _extent-size = 0 then 
        assign etype = true
               esize = "N/A".
               
       else 
         assign etype = false
                esize = STRING(_extent-size).


      DISPLAY STREAM rpt
        _AreaExtent._extent-number
        etype 
        esize   
        _AreaExtent._extent-path 
        WITH FRAME shoextent.

	DOWN STREAM rpt WITH FRAME shoExtent.
        
     /* Put an extra line in between each Area. */
     IF LAST-OF(_AreaExtent._Extent-path) THEN 
        DOWN STREAM rpt 1 WITH FRAME shoExtent.
   END.
END.


   HIDE FRAME working_on NO-PAUSE.
   SESSION:IMMEDIATE-DISPLAY = no.

