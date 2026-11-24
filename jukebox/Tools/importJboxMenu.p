
/*------------------------------------------------------------------------
    File        : importJboxMenu.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : brynj
    Created     : Fri Dec 08 17:52:18 CET 2023
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
DEF VAR cDir AS CHAR NO-UNDO.
SYSTEM-DIALOG GET-DIR cDir.

IF cDir = "" THEN RETURN.

IF SEARCH(cDir + "\jboxmenu.d") NE ? AND SEARCH(cDir + "\jbmetome.d") NE ? THEN DO:
  DISABLE TRIGGERS FOR LOAD OF JBoxMenu.
  INPUT FROM VALUE(cDir + "\jboxmenu.d").
  REPEAT:
    CREATE JBoxMenu.
    IMPORT JBoxMenu.
  END.
  INPUT CLOSE.
  INPUT FROM VALUE(cDir + "\jbmetome.d").
  REPEAT:
    CREATE JBoxMenuToMenu.
    IMPORT JBoxMenuToMenu.
  END.
  INPUT CLOSE.
  MESSAGE "Finito"
  VIEW-AS ALERT-BOX.
END.
ELSE MESSAGE ".d files not found"
             VIEW-AS ALERT-BOX.
    
