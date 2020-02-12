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
DEFINE INPUT PARAMETER current-rec AS RECID.

/* Local Variable Definitions ---                                       */
DEFINE VAR pointer AS LOGICAL.
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
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
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH NPSHMKVS SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPSHMKVS SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPSHMKVS
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPSHMKVS


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi 
&Scoped-define ENABLED-TABLES NPSHMKVS
&Scoped-define FIRST-ENABLED-TABLE NPSHMKVS
&Scoped-Define ENABLED-OBJECTS RECT-35 Btn_OK COMBO-BOX-VENTILTYPE ~
Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSHMKVS.shunt_dimmensjon ~
NPSHMKVS.kvs_verdi 
&Scoped-define DISPLAYED-TABLES NPSHMKVS
&Scoped-define FIRST-DISPLAYED-TABLE NPSHMKVS
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
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 12 BY 1.1
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX-VENTILTYPE AS CHARACTER FORMAT "X(256)":U 
     LABEL "Ventiltype" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20.8 BY 1
     FONT 2 NO-UNDO.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 47.8 BY 4.86.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPSHMKVS SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     Btn_OK AT ROW 1.52 COL 52
     COMBO-BOX-VENTILTYPE AT ROW 1.86 COL 23.8 COLON-ALIGNED
     Btn_Cancel AT ROW 2.67 COL 52
     NPSHMKVS.shunt_dimmensjon AT ROW 3.14 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 7.4 BY 1
          FONT 2
     NPSHMKVS.kvs_verdi AT ROW 4.43 COL 23.8 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 12.8 BY 1
          FONT 2
     Btn_Help AT ROW 4.52 COL 52
     RECT-35 AT ROW 1.29 COL 2
     SPACE(15.33) SKIP(0.84)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Endre MS - Ventil"
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
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
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Endre MS - Ventil */
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
    IF  COMBO-BOX-VENTILTYPE:SCREEN-VALUE = ""  THEN    
        APPLY 'CHOOSE' TO Btn_Cancel.
    ELSE
        DO:
            Current-Rec = RECID(NPSHMKVS).
            ASSIGN NPSHMKVS.ventiltype = COMBO-BOX-VENTILTYPE:SCREEN-VALUE.  
        ASSIGN NPSHMKVS.sorteringsDimmensjon = 
             INTEGER(NPSHMKVS.shunt_dimmensjon:SCREEN-VALUE).
        END.
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
  RUN endre_ventil.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endre_ventil Dialog-Frame 
PROCEDURE endre_ventil :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPSHMKVS WHERE RECID(NPSHMKVS) = Current-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NPSHMKVS THEN
      DO:
            /* Set combo-box til feltverdi for ventiltype */
            DEFINE VAR ventilType AS CHAR.
            DEFINE VAR finnesIListe AS INTEGER.
            
            ventilType = NPSHMKVS.ventiltype.
           DO WITH FRAME Dialog-Frame:
               finnesIListe = LOOKUP(ventilType, temp-string).
               IF finnesIListe > 0 THEN
                    COMBO-BOX-VENTILTYPE:SCREEN-VALUE = ventilType.

                 UPDATE 
                     COMBO-BOX-VENTILTYPE NPSHMKVS.shunt_dimmensjon NPSHMKVS.kvs_verdi
                        Btn_OK  Btn_Cancel  Btn_Help.
          END.
        END.
    END.
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

