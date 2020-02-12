/* Main Block code for ADM2 SmartDialogs. 
   Checks to be sure the Dialog Box has not been run persistent;
   creates any SmartObjects contained in the Dialog Box;
   sets up standard Dialog initialization and termination.
*/

DEFINE VARIABLE iStartPage AS INTEGER NO-UNDO.

IF THIS-PROCEDURE:PERSISTENT THEN DO:
    MESSAGE "A SmartDialog is not intended to be run ":U SKIP
            "Persistent or to be placed in another ":U SKIP
            "SmartObject at AppBuilder design time.":U
            VIEW-AS ALERT-BOX ERROR.
    RUN disable_UI.
    DELETE PROCEDURE THIS-PROCEDURE.
    RETURN.
END.

RUN createObjects.
{get StartPage iStartPage}.
IF iStartPage NE ? AND iStartPage NE 0 THEN
  RUN selectPage(iStartPage).

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN initializeObject.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN destroyObject.
