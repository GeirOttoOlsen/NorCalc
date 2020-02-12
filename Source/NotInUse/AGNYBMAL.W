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
DEFINE INPUT PARAMETER appdata AS CHARACTER.
DEFINE SHARED VAR Current-Rec AS RECID.
DEFINE SHARED VAR nyRecord AS LOGICAL.

/* Local Variable Definitions ---                                       */
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPAGBATMAAL

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NPAGBATMAAL.hoyde_h ~
NPAGBATMAAL.batteritype NPAGBATMAAL.lengde_l NPAGBATMAAL.hoyde_t ~
NPAGBATMAAL.a NPAGBATMAAL.bredde_a NPAGBATMAAL.diam_max NPAGBATMAAL.VBb1 ~
NPAGBATMAAL.VBb2 NPAGBATMAAL.KBb1 NPAGBATMAAL.KBb2 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame NPAGBATMAAL.hoyde_h ~
NPAGBATMAAL.batteritype NPAGBATMAAL.lengde_l NPAGBATMAAL.hoyde_t ~
NPAGBATMAAL.a NPAGBATMAAL.bredde_a NPAGBATMAAL.diam_max NPAGBATMAAL.VBb1 ~
NPAGBATMAAL.VBb2 NPAGBATMAAL.KBb1 NPAGBATMAAL.KBb2 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NPAGBATMAAL
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NPAGBATMAAL

&Scoped-define FIELD-PAIRS-IN-QUERY-Dialog-Frame~
 ~{&FP1}hoyde_h ~{&FP2}hoyde_h ~{&FP3}~
 ~{&FP1}lengde_l ~{&FP2}lengde_l ~{&FP3}~
 ~{&FP1}hoyde_t ~{&FP2}hoyde_t ~{&FP3}~
 ~{&FP1}a ~{&FP2}a ~{&FP3}~
 ~{&FP1}bredde_a ~{&FP2}bredde_a ~{&FP3}~
 ~{&FP1}VBb1 ~{&FP2}VBb1 ~{&FP3}~
 ~{&FP1}VBb2 ~{&FP2}VBb2 ~{&FP3}~
 ~{&FP1}KBb1 ~{&FP2}KBb1 ~{&FP3}~
 ~{&FP1}KBb2 ~{&FP2}KBb2 ~{&FP3}
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPAGBATMAAL SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPAGBATMAAL
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPAGBATMAAL


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGBATMAAL.hoyde_h NPAGBATMAAL.batteritype ~
NPAGBATMAAL.lengde_l NPAGBATMAAL.hoyde_t NPAGBATMAAL.a NPAGBATMAAL.bredde_a ~
NPAGBATMAAL.diam_max NPAGBATMAAL.VBb1 NPAGBATMAAL.VBb2 NPAGBATMAAL.KBb1 ~
NPAGBATMAAL.KBb2 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}hoyde_h ~{&FP2}hoyde_h ~{&FP3}~
 ~{&FP1}lengde_l ~{&FP2}lengde_l ~{&FP3}~
 ~{&FP1}hoyde_t ~{&FP2}hoyde_t ~{&FP3}~
 ~{&FP1}a ~{&FP2}a ~{&FP3}~
 ~{&FP1}bredde_a ~{&FP2}bredde_a ~{&FP3}~
 ~{&FP1}VBb1 ~{&FP2}VBb1 ~{&FP3}~
 ~{&FP1}VBb2 ~{&FP2}VBb2 ~{&FP3}~
 ~{&FP1}KBb1 ~{&FP2}KBb1 ~{&FP3}~
 ~{&FP1}KBb2 ~{&FP2}KBb2 ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGBATMAAL
&Scoped-define FIRST-ENABLED-TABLE NPAGBATMAAL
&Scoped-Define ENABLED-OBJECTS RECT-36 COMBO-BOX-AGGTYPE Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGBATMAAL.hoyde_h NPAGBATMAAL.batteritype ~
NPAGBATMAAL.lengde_l NPAGBATMAAL.hoyde_t NPAGBATMAAL.a NPAGBATMAAL.bredde_a ~
NPAGBATMAAL.diam_max NPAGBATMAAL.VBb1 NPAGBATMAAL.VBb2 NPAGBATMAAL.KBb1 ~
NPAGBATMAAL.KBb2 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-AGGTYPE 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10.2 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-AGGTYPE AS CHARACTER FORMAT "X(15)":U 
     LABEL "Aggregattype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 20.4 BY 1.14 NO-UNDO.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68 BY 11.33.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPAGBATMAAL SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     COMBO-BOX-AGGTYPE AT ROW 1.86 COL 19.2 COLON-ALIGNED
     NPAGBATMAAL.hoyde_h AT ROW 1.91 COL 52.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     NPAGBATMAAL.batteritype AT ROW 3.05 COL 21.2 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "P3012", "P3012":U,
"P60", "P60":U
          SIZE 20.4 BY .76
     NPAGBATMAAL.lengde_l AT ROW 3.05 COL 52.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     NPAGBATMAAL.hoyde_t AT ROW 4.1 COL 19.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     NPAGBATMAAL.a AT ROW 4.1 COL 52.8 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     NPAGBATMAAL.bredde_a AT ROW 5.19 COL 19.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY 1
     NPAGBATMAAL.diam_max AT ROW 5.19 COL 52.8 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "½~"","¾~"","1~"","1¼~"","1½~"","2~"","2½~"","3~"","4~"" 
          SIZE 8.8 BY 1.14
     NPAGBATMAAL.VBb1 AT ROW 6.48 COL 19.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.8 BY 1
     NPAGBATMAAL.VBb2 AT ROW 7.67 COL 19.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.8 BY 1
     NPAGBATMAAL.KBb1 AT ROW 8.81 COL 19.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.8 BY 1
     NPAGBATMAAL.KBb2 AT ROW 9.95 COL 19.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.8 BY 1
     Btn_OK AT ROW 13.19 COL 24.6
     Btn_Cancel AT ROW 13.19 COL 33.6
     Btn_Help AT ROW 13.19 COL 45.2
     RECT-36 AT ROW 1.33 COL 1.8
     "Batteritype:" VIEW-AS TEXT
          SIZE 14.2 BY .62 AT ROW 3.05 COL 7.2
     SPACE(48.79) SKIP(11.08)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Nytt batterimål"
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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NPAGBATMAAL"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Nytt batterimål */
DO:
  APPLY "END-ERROR":U TO SELF.
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
    IF  COMBO-BOX-AGGTYPE:SCREEN-VALUE = ""  THEN    
        APPLY 'CHOOSE' TO Btn_Cancel.
    ELSE
        DO:
            Current-Rec = RECID(NPAGBATMAAL).
            nyRecord = TRUE.
            ASSIGN NPAGBATMAAL.aggregattype = COMBO-BOX-AGGTYPE:SCREEN-VALUE.  
        END.  
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
  RUN fyll_aggtype_combo.
  RUN ny_aggtype.
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
  DISPLAY COMBO-BOX-AGGTYPE 
      WITH FRAME Dialog-Frame.
  IF AVAILABLE NPAGBATMAAL THEN 
    DISPLAY NPAGBATMAAL.hoyde_h NPAGBATMAAL.batteritype NPAGBATMAAL.lengde_l 
          NPAGBATMAAL.hoyde_t NPAGBATMAAL.a NPAGBATMAAL.bredde_a 
          NPAGBATMAAL.diam_max NPAGBATMAAL.VBb1 NPAGBATMAAL.VBb2 
          NPAGBATMAAL.KBb1 NPAGBATMAAL.KBb2 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-36 COMBO-BOX-AGGTYPE NPAGBATMAAL.hoyde_h NPAGBATMAAL.batteritype 
         NPAGBATMAAL.lengde_l NPAGBATMAAL.hoyde_t NPAGBATMAAL.a 
         NPAGBATMAAL.bredde_a NPAGBATMAAL.diam_max NPAGBATMAAL.VBb1 
         NPAGBATMAAL.VBb2 NPAGBATMAAL.KBb1 NPAGBATMAAL.KBb2 Btn_OK Btn_Cancel 
         Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_aggtype_combo Dialog-Frame 
PROCEDURE fyll_aggtype_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    temp-string = "".
    FOR EACH NPAGTYPE:
         IF temp-string = ""
        THEN temp-string = NPAGTYPE.aggregattype.
        ELSE temp-string = temp-string + "," + NPAGTYPE.aggregattype.
    END.

    ASSIGN COMBO-BOX-AGGTYPE:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ny_aggtype Dialog-Frame 
PROCEDURE ny_aggtype :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CREATE NPAGBATMAAL.
      UPDATE COMBO-BOX-AGGTYPE NPAGBATMAAL.batteritype 
         NPAGBATMAAL.hoyde_t  NPAGBATMAAL.bredde_a
         NPAGBATMAAL.VBb1  NPAGBATMAAL.VBb2
         NPAGBATMAAL.KBb1 NPAGBATMAAL.KBb2         
         NPAGBATMAAL.hoyde_h  NPAGBATMAAL.lengde_l 
         NPAGBATMAAL.a   NPAGBATMAAL.diam_max   
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


