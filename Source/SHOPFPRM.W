&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER fomUkeParam AS INTEGER.
DEFINE INPUT-OUTPUT PARAMETER tomUkeParam AS INTEGER.
DEFINE INPUT-OUTPUT PARAMETER maanedParam AS INTEGER.
DEFINE INPUT-OUTPUT PARAMETER selgerParam AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER aarParam AS INTEGER.
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHANLG

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPSHANLG SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPSHANLG
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPSHANLG


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-22 Btn_OK Btn_Cancel FILL-IN-uke_tom ~
FILL-IN-aar Btn_Help 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-maaned FILL-IN-uke_fom ~
FILL-IN-uke_tom FILL-IN-aar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 16.8 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 16.8 BY 1.38
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 16.8 BY 1.38
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX_selger AS CHARACTER FORMAT "X(20)" 
     LABEL "For selger" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "Håkon A. Pedersen","Arne Svensson","Ronny Svensson","Arne Terkelsen","Steinar Aune" 
     SIZE 33.8 BY 1.14
     FONT 2.

DEFINE VARIABLE FILL-IN-aar AS INTEGER FORMAT "9999":U INITIAL 0 
     LABEL "År" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 8.4 BY 1.24 NO-UNDO.

DEFINE VARIABLE FILL-IN-maaned AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Månedsnr." 
     VIEW-AS FILL-IN 
     SIZE 5.6 BY 1.24
     FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-uke_fom AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Uke fom" 
     VIEW-AS FILL-IN 
     SIZE 5.6 BY 1.24
     FONT 2 NO-UNDO.

DEFINE VARIABLE FILL-IN-uke_tom AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "tom" 
     VIEW-AS FILL-IN 
     SIZE 5.6 BY 1.24 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 58.8 BY 8.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPSHANLG SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 2.38 COL 64
     Btn_Cancel AT ROW 3.86 COL 64
     FILL-IN-maaned AT ROW 4.67 COL 18 COLON-ALIGNED
     FILL-IN-uke_fom AT ROW 6 COL 18 COLON-ALIGNED
     FILL-IN-uke_tom AT ROW 6 COL 31.2 COLON-ALIGNED
     FILL-IN-aar AT ROW 6 COL 42.4 COLON-ALIGNED
     Btn_Help AT ROW 6.1 COL 64
     COMBO-BOX_selger AT ROW 7.38 COL 18 COLON-ALIGNED
     RECT-22 AT ROW 1.62 COL 2.4
     "Utskrift av oppfølgingsliste." VIEW-AS TEXT
          SIZE 36.4 BY 1.38 AT ROW 2 COL 5.2
     "Oppgi uke/månedsnummer eller selger" VIEW-AS TEXT
          SIZE 50.4 BY .76 AT ROW 3.29 COL 5.2
     SPACE(29.19) SKIP(7.65)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Utskriftsparameter"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX COMBO-BOX_selger IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-maaned IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-uke_fom IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NPSHANLG"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Utskriftsparameter */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
DO:
  ASSIGN fomUkeParam = -1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dialog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dialog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
    ASSIGN
    maanedParam = INTEGER(FILL-IN-maaned:SCREEN-VALUE)
    fomUkeParam = INTEGER(FILL-IN-uke_fom:SCREEN-VALUE)
    tomUkeParam = INTEGER(FILL-IN-uke_tom:SCREEN-VALUE)
    selgerParam = COMBO-BOX_selger:SCREEN-VALUE
    aarParam = INTEGER (FILL-IN-aar:SCREEN-VALUE).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX_selger
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_selger Dialog-Frame
ON DELETE-CHARACTER OF COMBO-BOX_selger IN FRAME Dialog-Frame /* For selger */
DO:
  COMBO-BOX_selger = "".
  DISPLAY COMBO-BOX_selger  WITH FRAME Dialog-Frame.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX_selger Dialog-Frame
ON VALUE-CHANGED OF COMBO-BOX_selger IN FRAME Dialog-Frame /* For selger */
DO:
ASSIGN
    selgerParam = COMBO-BOX_selger:SCREEN-VALUE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
/*  RUN enable_UI.*/
  RUN startDialog.
/*  WAIT-FOR GO OF FRAME {&FRAME-NAME}.*/
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  DISPLAY FILL-IN-maaned FILL-IN-uke_fom FILL-IN-uke_tom FILL-IN-aar 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-22 Btn_OK Btn_Cancel FILL-IN-uke_tom FILL-IN-aar Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE startDialog Dialog-Frame 
PROCEDURE startDialog :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Dette vindu kan brukes til † skrive ut oppf›lginsliste for:
    M†ned       selgerParam = False
    Uke             selgerParam = True og aarParam = True
    Selger         selgerParam = True
    Uke/Selger selgerParam = True
*/

IF selgerParam = 'False' THEN
  UPDATE    FILL-IN-maaned    Btn_OK Btn_Cancel  Btn_Help  WITH FRAME Dialog-Frame.
ELSE IF selgerParam = 'True' THEN
    DO:
        FILL-IN-aar = aarParam.
        UPDATE   FILL-IN-uke_fom FILL-IN-uke_tom  FILL-IN-aar  COMBO-BOX_selger  
            Btn_OK Btn_Cancel  Btn_Help  WITH FRAME Dialog-Frame.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


