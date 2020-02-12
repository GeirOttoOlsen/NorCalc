&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DIALOG-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DIALOG-1 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 08/17/95 -  4:00 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---   */
Define output parameter  v_valid_user as logical init false.

/* Local Variable Definitions ---                                       */
Define variable id       like _User._Userid.
Define variable password like _User._Password.
Define variable tries    as integer init 0 NO-UNDO.

/*
Define variable  v_valid_user as logical init false.
*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DIALOG-1

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fi_userid fi_password btn_ok btn_cancel ~
btn_help 
&Scoped-Define DISPLAYED-OBJECTS fi_userid fi_password 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_cancel 
     LABEL "Cancel" 
     SIZE 10.2 BY 1.

DEFINE BUTTON btn_help 
     LABEL "Help" 
     SIZE 9 BY 1.

DEFINE BUTTON btn_ok 
     LABEL "OK" 
     SIZE 9 BY 1.

DEFINE VARIABLE fi_password AS CHARACTER FORMAT "X(25)":U 
     LABEL "Password" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1.1 NO-UNDO.

DEFINE VARIABLE fi_userid AS CHARACTER FORMAT "X(25)":U 
     LABEL "Userid" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DIALOG-1
     fi_userid AT ROW 1.76 COL 14 COLON-ALIGNED
     fi_password AT ROW 3.24 COL 14 COLON-ALIGNED BLANK 
     btn_ok AT ROW 5.24 COL 3
     btn_cancel AT ROW 5.24 COL 13
     btn_help AT ROW 5.24 COL 33
     SPACE(1.42) SKIP(0.54)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Logon Voyage Registration System"
         DEFAULT-BUTTON btn_ok CANCEL-BUTTON btn_cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DIALOG-1
                                                                        */
ASSIGN 
       FRAME DIALOG-1:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME btn_cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_cancel DIALOG-1
ON CHOOSE OF btn_cancel IN FRAME DIALOG-1 /* Cancel */
DO:
  
    APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_help DIALOG-1
ON CHOOSE OF btn_help IN FRAME DIALOG-1 /* Help */
DO:

    Message
        "You must enter a valid Userid, Password pair" skip
        "to log on to the Voyage Registration System." skip
        "You are only allowed 3 tries.  Passwords are" skip
        "not written to the screen." skip
        "Buttons:" skip
        "    OK: Your Userid, Password pair will be validated." skip
        "    Cancel: Aborts logon." skip
        "    Help: Displays this message."
        view-as alert-box.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_ok DIALOG-1
ON CHOOSE OF btn_ok IN FRAME DIALOG-1 /* OK */
DO:

  Assign 
      id = fi_userid:screen-value
      password = fi_password:screen-value.

  IF SETUSERID(id,password,"DICTDB") = TRUE THEN DO:
      v_valid_user = true.
      APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.
  END.

  tries = tries + 1.
      
  IF tries > 2 then do:    /* only allow 3 tries*/
      MESSAGE "Beklager, feil passord for denne bruker." skip 
      "Du har bare 3 forsøk." view-as alert-box.
      APPLY "WINDOW-CLOSE" TO FRAME {&FRAME-NAME}.
  end.
  else
      MESSAGE "Beklager, feil passord for denne bruker." view-as alert-box.
    
  Assign 
      fi_userid:screen-value  = ""
      fi_password:screen-value = "".
      
  Apply "entry" to fi_userid.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DIALOG-1 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Add Trigger to equate WINDOW-CLOSE to END-ERROR                      */
ON WINDOW-CLOSE OF FRAME {&FRAME-NAME} APPLY "END-ERROR":U TO SELF.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  RUN enable_UI.


  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DIALOG-1 _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME DIALOG-1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DIALOG-1 _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY fi_userid fi_password 
      WITH FRAME DIALOG-1.
  ENABLE fi_userid fi_password btn_ok btn_cancel btn_help 
      WITH FRAME DIALOG-1.
  {&OPEN-BROWSERS-IN-QUERY-DIALOG-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


