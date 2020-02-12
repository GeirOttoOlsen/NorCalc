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
&Scoped-define INTERNAL-TABLES NPSHMKVS

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NPSHMKVS.shunt_dimmensjon ~
NPSHMKVS.kvs_verdi 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NPSHMKVS
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NPSHMKVS

&Scoped-define FIELD-PAIRS-IN-QUERY-Dialog-Frame~
 ~{&FP1}shunt_dimmensjon ~{&FP2}shunt_dimmensjon ~{&FP3}~
 ~{&FP1}kvs_verdi ~{&FP2}kvs_verdi ~{&FP3}
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPSHMKVS SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPSHMKVS
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPSHMKVS


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}shunt_dimmensjon ~{&FP2}shunt_dimmensjon ~{&FP3}~
 ~{&FP1}kvs_verdi ~{&FP2}kvs_verdi ~{&FP3}
&Scoped-define ENABLED-TABLES NPSHMKVS
&Scoped-define FIRST-ENABLED-TABLE NPSHMKVS
&Scoped-Define ENABLED-OBJECTS RECT-35 Btn_OK COMBO-BOX-VENTILTYPE ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSHMKVS.shunt_dimmensjon ~
NPSHMKVS.kvs_verdi 
&Scoped-Define DISPLAYED-OBJECTS COMBO-BOX-VENTILTYPE 

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

DEFINE VARIABLE COMBO-BOX-VENTILTYPE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "","" 
     SIZE 22.4 BY 1
     FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 64.4 BY 6.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPSHMKVS SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.62 COL 72.4
     COMBO-BOX-VENTILTYPE AT ROW 2.38 COL 28.4 COLON-ALIGNED
     Btn_Cancel AT ROW 3.05 COL 72.4
     NPSHMKVS.shunt_dimmensjon AT ROW 3.62 COL 28.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 10.4 BY 1.24
          FONT 2
     NPSHMKVS.kvs_verdi AT ROW 5 COL 28.4 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 18 BY 1.24
          FONT 2
     Btn_Help AT ROW 5.38 COL 72.4
     RECT-35 AT ROW 1.38 COL 2.4
     SPACE(23.99) SKIP(1.04)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Ny MS - Ventil"
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
     _TblList          = "norcalc.NPSHMKVS"
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Ny MS - Ventil */
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
    Current-Rec = RECID(NPSHMKVS).
    nyRecord = TRUE.
    ASSIGN NPSHMKVS.ventiltype = COMBO-BOX-VENTILTYPE:SCREEN-VALUE.  
    ASSIGN NPSHMKVS.sorteringsDimmensjon = 
        INTEGER(NPSHMKVS.shunt_dimmensjon:SCREEN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME COMBO-BOX-VENTILTYPE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE Dialog-Frame
ON ANY-PRINTABLE OF COMBO-BOX-VENTILTYPE IN FRAME Dialog-Frame /* Ventiltype */
DO:
  seek-item:
  DO i = 1 TO SELF:NUM-ITEMS:
    IF SELF:ENTRY(i) BEGINS LAST-EVENT:FUNCTION
    THEN DO:
        SELF:SCREEN-VALUE = SELF:ENTRY(i).
        LEAVE seek-item.
    END.
  END.
  IF i > SELF:NUM-ITEMS
  THEN BELL.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE Dialog-Frame
ON CURSOR-DOWN OF COMBO-BOX-VENTILTYPE IN FRAME Dialog-Frame /* Ventiltype */
DO:
  i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i < SELF:NUM-ITEMS
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i + 1).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL COMBO-BOX-VENTILTYPE Dialog-Frame
ON CURSOR-UP OF COMBO-BOX-VENTILTYPE IN FRAME Dialog-Frame /* Ventiltype */
DO:
   i = SELF:LOOKUP(SELF:SCREEN-VALUE).
  IF i > 1
  THEN SELF:SCREEN-VALUE = SELF:ENTRY(i - 1).
  
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
  pointer = SESSION:SET-WAIT-STATE("").   
  RUN fyll_ventiltype_combo.
  RUN ny_ventil.
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
  DISPLAY COMBO-BOX-VENTILTYPE 
      WITH FRAME Dialog-Frame.
  IF AVAILABLE NPSHMKVS THEN 
    DISPLAY NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-35 Btn_OK COMBO-BOX-VENTILTYPE Btn_Cancel 
         NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyll_ventiltype_combo Dialog-Frame 
PROCEDURE fyll_ventiltype_combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    temp-string = "".
    FOR EACH NPSHVENTILTYPE:
         IF temp-string = ""
        THEN temp-string = NPSHVENTILTYPE.ventiltype.
        ELSE temp-string = temp-string + "," + NPSHVENTILTYPE.ventiltype.
    END.

    ASSIGN COMBO-BOX-VENTILTYPE:LIST-ITEMS IN FRAME {&FRAME-NAME} = temp-string.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ny_ventil Dialog-Frame 
PROCEDURE ny_ventil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    CREATE NPSHMKVS.
    UPDATE 
        COMBO-BOX-VENTILTYPE NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi
           Btn_OK  Btn_Cancel  Btn_Help 
      WITH FRAME Dialog-Frame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


