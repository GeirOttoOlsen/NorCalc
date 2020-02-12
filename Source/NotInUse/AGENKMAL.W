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
&Scoped-define INTERNAL-TABLES NPAGKABMAAL

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NPAGKABMAAL.fundament_hoyde ~
NPAGKABMAAL.isolasjon NPAGKABMAAL.innv_hoyde_litenh ~
NPAGKABMAAL.innv_hoyde_storH NPAGKABMAAL.bredde NPAGKABMAAL.hoyde ~
NPAGKABMAAL.standard_vifte NPAGKABMAAL.fratrekksmaal ~
NPAGKABMAAL.hoydereduksjon 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame ~
NPAGKABMAAL.fundament_hoyde NPAGKABMAAL.isolasjon ~
NPAGKABMAAL.innv_hoyde_litenh NPAGKABMAAL.innv_hoyde_storH ~
NPAGKABMAAL.bredde NPAGKABMAAL.hoyde NPAGKABMAAL.standard_vifte ~
NPAGKABMAAL.fratrekksmaal NPAGKABMAAL.hoydereduksjon 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NPAGKABMAAL
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NPAGKABMAAL

&Scoped-define FIELD-PAIRS-IN-QUERY-Dialog-Frame~
 ~{&FP1}fundament_hoyde ~{&FP2}fundament_hoyde ~{&FP3}~
 ~{&FP1}innv_hoyde_litenh ~{&FP2}innv_hoyde_litenh ~{&FP3}~
 ~{&FP1}innv_hoyde_storH ~{&FP2}innv_hoyde_storH ~{&FP3}~
 ~{&FP1}bredde ~{&FP2}bredde ~{&FP3}~
 ~{&FP1}hoyde ~{&FP2}hoyde ~{&FP3}~
 ~{&FP1}standard_vifte ~{&FP2}standard_vifte ~{&FP3}~
 ~{&FP1}fratrekksmaal ~{&FP2}fratrekksmaal ~{&FP3}~
 ~{&FP1}hoydereduksjon ~{&FP2}hoydereduksjon ~{&FP3}
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NPAGKABMAAL SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NPAGKABMAAL
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NPAGKABMAAL


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGKABMAAL.fundament_hoyde ~
NPAGKABMAAL.isolasjon NPAGKABMAAL.innv_hoyde_litenh ~
NPAGKABMAAL.innv_hoyde_storH NPAGKABMAAL.bredde NPAGKABMAAL.hoyde ~
NPAGKABMAAL.standard_vifte NPAGKABMAAL.fratrekksmaal ~
NPAGKABMAAL.hoydereduksjon 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}fundament_hoyde ~{&FP2}fundament_hoyde ~{&FP3}~
 ~{&FP1}innv_hoyde_litenh ~{&FP2}innv_hoyde_litenh ~{&FP3}~
 ~{&FP1}innv_hoyde_storH ~{&FP2}innv_hoyde_storH ~{&FP3}~
 ~{&FP1}bredde ~{&FP2}bredde ~{&FP3}~
 ~{&FP1}hoyde ~{&FP2}hoyde ~{&FP3}~
 ~{&FP1}standard_vifte ~{&FP2}standard_vifte ~{&FP3}~
 ~{&FP1}fratrekksmaal ~{&FP2}fratrekksmaal ~{&FP3}~
 ~{&FP1}hoydereduksjon ~{&FP2}hoydereduksjon ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGKABMAAL
&Scoped-define FIRST-ENABLED-TABLE NPAGKABMAAL
&Scoped-Define ENABLED-OBJECTS RECT-36 COMBO-BOX-AGGTYPE Btn_OK Btn_Cancel ~
Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGKABMAAL.fundament_hoyde ~
NPAGKABMAAL.isolasjon NPAGKABMAAL.innv_hoyde_litenh ~
NPAGKABMAAL.innv_hoyde_storH NPAGKABMAAL.bredde NPAGKABMAAL.hoyde ~
NPAGKABMAAL.standard_vifte NPAGKABMAAL.fratrekksmaal ~
NPAGKABMAAL.hoydereduksjon 
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
     SIZE 10.8 BY 1
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
     SIZE 16 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 73.6 BY 8.43.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NPAGKABMAAL SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     COMBO-BOX-AGGTYPE AT ROW 1.86 COL 20.4 COLON-ALIGNED
     NPAGKABMAAL.fundament_hoyde AT ROW 1.86 COL 60.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.4 BY 1.24
     NPAGKABMAAL.isolasjon AT ROW 3.1 COL 20.4 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "30","50","100" 
          SIZE 7.2 BY 1
     NPAGKABMAAL.innv_hoyde_litenh AT ROW 3.1 COL 60.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.4 BY 1.24
     NPAGKABMAAL.innv_hoyde_storH AT ROW 4.33 COL 60.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.4 BY 1.24
     NPAGKABMAAL.bredde AT ROW 4.38 COL 20.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.4 BY 1
     NPAGKABMAAL.hoyde AT ROW 5.52 COL 20.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.4 BY 1
     NPAGKABMAAL.standard_vifte AT ROW 5.57 COL 60.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.6 BY 1.24
     NPAGKABMAAL.fratrekksmaal AT ROW 6.71 COL 20.4 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.4 BY 1
     NPAGKABMAAL.hoydereduksjon AT ROW 7.95 COL 20.4 COLON-ALIGNED
          LABEL "Høydered."
          VIEW-AS FILL-IN 
          SIZE 6.4 BY 1
     Btn_OK AT ROW 10.14 COL 23.4
     Btn_Cancel AT ROW 10.14 COL 32.4
     Btn_Help AT ROW 10.14 COL 44.2
     RECT-36 AT ROW 1.33 COL 1.8
     SPACE(2.99) SKIP(2.09)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Endre kabinettmål"
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

/* SETTINGS FOR FILL-IN NPAGKABMAAL.hoydereduksjon IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NPAGKABMAAL"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Endre kabinettmål */
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
            Current-Rec = RECID(NPAGKABMAAL).
            nyRecord = TRUE.
            ASSIGN NPAGKABMAAL.aggregattype = COMBO-BOX-AGGTYPE:SCREEN-VALUE.  
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
  RUN endre_aggtype.
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
  IF AVAILABLE NPAGKABMAAL THEN 
    DISPLAY NPAGKABMAAL.fundament_hoyde NPAGKABMAAL.isolasjon 
          NPAGKABMAAL.innv_hoyde_litenh NPAGKABMAAL.innv_hoyde_storH 
          NPAGKABMAAL.bredde NPAGKABMAAL.hoyde NPAGKABMAAL.standard_vifte 
          NPAGKABMAAL.fratrekksmaal NPAGKABMAAL.hoydereduksjon 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-36 COMBO-BOX-AGGTYPE NPAGKABMAAL.fundament_hoyde 
         NPAGKABMAAL.isolasjon NPAGKABMAAL.innv_hoyde_litenh 
         NPAGKABMAAL.innv_hoyde_storH NPAGKABMAAL.bredde NPAGKABMAAL.hoyde 
         NPAGKABMAAL.standard_vifte NPAGKABMAAL.fratrekksmaal 
         NPAGKABMAAL.hoydereduksjon Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endre_aggtype Dialog-Frame 
PROCEDURE endre_aggtype :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPAGKABMAAL WHERE RECID(NPAGKABMAAL) = Current-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NPAGKABMAAL THEN
      DO:
            /* Set combo-box til feltverdi for ventiltype */
            DEFINE VAR aggType AS CHAR.
            DEFINE VAR finnesIListe AS INTEGER.
            
            aggType = NPAGKABMAAL.aggregattype.
           DO WITH FRAME Dialog-Frame:
               finnesIListe = LOOKUP(aggType, temp-string).
               IF finnesIListe > 0 THEN
                    COMBO-BOX-AGGTYPE:SCREEN-VALUE = aggType.
              UPDATE COMBO-BOX-AGGTYPE 
                NPAGKABMAAL.isolasjon NPAGKABMAAL.bredde 
                 NPAGKABMAAL.hoyde NPAGKABMAAL.fratrekksmaal
                 NPAGKABMAAL.hoydereduksjon 
                 NPAGKABMAAL.fundament_hoyde 
                 NPAGKABMAAL.innv_hoyde_litenh 
                 NPAGKABMAAL.innv_hoyde_storH 
                 NPAGKABMAAL.standard_vifte        
                 Btn_OK Btn_Cancel Btn_Help 
              WITH FRAME Dialog-Frame.
            END.
       END.
    END.
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


