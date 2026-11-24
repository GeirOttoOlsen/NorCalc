
/*------------------------------------------------------------------------
    File        : testmelding.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : goo
    Created     : Sun Feb 11 14:57:25 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

MESSAGE 'her..'
VIEW-AS ALERT-BOX.

DEF VAR hServer AS HANDLE NO-UNDO.
DEF VAR bOk     AS LOG    NO-UNDO INIT YES.
/*def var username as char no-undo.*/
def var username as char no-undo.

assign 
  username = System.Environment:UserName
  .
CREATE SERVER hServer.

MESSAGE 'Test..1 -param:' ENTRY(1,SESSION:PARAM,";") view-as alert-box.

delete object hServer.

MESSAGE 'her...ut'
VIEW-AS ALERT-BOX.

quit.