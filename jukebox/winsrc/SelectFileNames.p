DEF INPUT PARAM FilterList AS CHAR NO-UNDO.
DEF INPUT PARAM InitialDirectory AS CHAR NO-UNDO.
DEF INPUT PARAM DialogTitle AS CHAR NO-UNDO.
DEF OUTPUT PARAM FileNames        AS CHARACTER NO-UNDO.

DEF VAR iOK              AS INTEGER   NO-UNDO.
 
DEF VAR ds AS CLASS System.Windows.Forms.OpenFileDialog NO-UNDO.
DEF VAR dr AS CLASS System.Windows.Forms.DialogResult NO-UNDO.
DEF VAR objFiles AS "System.String[]" NO-UNDO.                                                                                                                                                                                                                                        
DEF VAR ix       AS INTEGER NO-UNDO. 
  
 
ds = new System.Windows.Forms.OpenFileDialog().
/*  dr = new System.Windows.Forms.DialogResult().*/
ds:Multiselect = YES.
IF FilterList NE "" THEN
  ds:FIlter = FilterList.   /*  "PDF|*.pdf|Dokumenter (*.doc;*.xls)|*.doc;*.xls|All files (*.*)|*.*". */
IF InitialDirectory NE "" THEN
  ds:InitialDirectory = InitialDirectory.
IF DialogTitle NE "" THEN
  ds:Title = DialogTitle. 
     
     
WAIT-FOR ds:ShowDialog(). /* SET dr. */

/*MESSAGE valid-object(dr) skip dr:ToString()*/
/*VIEW-AS ALERT-BOX.                         */
/*  IF dr:ToString() = "OK" THEN DO:*/

  objFiles = cast(ds:FileNames,"System.String[]").      

  DO ix = 0 to objFiles:LENGTH - 1:
    FileNames = FileNames + (IF FileNames NE "" THEN ";" ELSE "") + objFiles:GetValue(ix):ToString().
  END.
/*  END.*/

/*  MESSAGE           */
/*  VIEW-AS ALERT-BOX.*/

DELETE OBJECT ds NO-ERROR.