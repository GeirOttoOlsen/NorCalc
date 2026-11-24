
/*------------------------------------------------------------------------
    File        : exportJboxMenu.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : brynj
    Created     : Wed Dec 13 17:52:18 CET 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF VAR cDir AS CHAR NO-UNDO.
SYSTEM-DIALOG GET-DIR cDir.

IF cDir = "" THEN RETURN.

OUTPUT TO VALUE(cDir + "\jboxmenu.d").
FOR EACH JBoxMenu NO-LOCK:
  EXPORT JBoxMenu.
END.
OUTPUT CLOSE.
OUTPUT TO VALUE(cDir + "\jbmetome.d").
FOR EACH JBoxMenuToMenu NO-LOCK:
  EXPORT JBoxMenuToMenu.
END.
OUTPUT CLOSE.
MESSAGE "Finito"
VIEW-AS ALERT-BOX.
    
