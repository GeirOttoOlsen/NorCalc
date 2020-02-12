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
/*DEFINE INPUT PARAMETER appdata AS CHARACTER.*/
DEFINE INPUT-OUTPUT PARAMETER  nyRecord AS LOGICAL.
/*DEFINE SHARED VAR Current-Rec AS ROWID.*/
def var Current-Rec as rowid.
/*DEFINE SHARED VAR prosjektIdParam LIKE NORPROSJEKT.prosjektid.*/
def var prosjektidparam like norprosjekt.prosjektid.
/* Local Variable Definitions ---                                       */
DEFINE VAR pointer AS LOGICAL.
def var hParent as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NORPROSJEKT

/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dialog-Frame NORPROSJEKT.prosjektid ~
NORPROSJEKT.reg_dato NORPROSJEKT.prosjekt_navn NORPROSJEKT.aggregater ~
NORPROSJEKT.shuntgrupper NORPROSJEKT.spirovent 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dialog-Frame NORPROSJEKT.prosjektid ~
NORPROSJEKT.reg_dato NORPROSJEKT.prosjekt_navn NORPROSJEKT.aggregater ~
NORPROSJEKT.shuntgrupper NORPROSJEKT.spirovent 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dialog-Frame NORPROSJEKT
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dialog-Frame NORPROSJEKT
&Scoped-define QUERY-STRING-Dialog-Frame FOR EACH NORPROSJEKT SHARE-LOCK
&Scoped-define OPEN-QUERY-Dialog-Frame OPEN QUERY Dialog-Frame FOR EACH NORPROSJEKT SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dialog-Frame NORPROSJEKT
&Scoped-define FIRST-TABLE-IN-QUERY-Dialog-Frame NORPROSJEKT


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NORPROSJEKT.prosjektid NORPROSJEKT.reg_dato ~
NORPROSJEKT.prosjekt_navn NORPROSJEKT.aggregater NORPROSJEKT.shuntgrupper ~
NORPROSJEKT.spirovent 
&Scoped-define ENABLED-TABLES NORPROSJEKT
&Scoped-define FIRST-ENABLED-TABLE NORPROSJEKT
&Scoped-Define ENABLED-OBJECTS RECT-31 Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NORPROSJEKT.prosjektid NORPROSJEKT.reg_dato ~
NORPROSJEKT.prosjekt_navn NORPROSJEKT.aggregater NORPROSJEKT.shuntgrupper ~
NORPROSJEKT.spirovent 
&Scoped-define DISPLAYED-TABLES NORPROSJEKT
&Scoped-define FIRST-DISPLAYED-TABLE NORPROSJEKT


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10.8 BY .86
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 8 BY .86
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY .86
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 66 BY 7.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dialog-Frame FOR 
      NORPROSJEKT SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     NORPROSJEKT.prosjektid AT ROW 1.67 COL 22 COLON-ALIGNED
          LABEL "Prosjektid"
          VIEW-AS FILL-IN 
          SIZE 10.6 BY 1
     NORPROSJEKT.reg_dato AT ROW 2.76 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 14 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NORPROSJEKT.prosjekt_navn AT ROW 3.76 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 41.4 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NORPROSJEKT.aggregater AT ROW 4.76 COL 22 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ja","Nei","Kanskje","Neppe" 
          DROP-DOWN-LIST
          SIZE 12.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NORPROSJEKT.shuntgrupper AT ROW 5.86 COL 22 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ja","Nei","Kanskje","Neppe" 
          DROP-DOWN-LIST
          SIZE 12.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     NORPROSJEKT.spirovent AT ROW 6.91 COL 22 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "Ja","Nei","Kanskje","Neppe" 
          DROP-DOWN-LIST
          SIZE 12.2 BY 1
          BGCOLOR 15 FGCOLOR 0 FONT 2
     Btn_OK AT ROW 8.57 COL 22
     Btn_Cancel AT ROW 8.57 COL 31
     Btn_Help AT ROW 8.57 COL 43
     RECT-31 AT ROW 1.29 COL 2.2
     SPACE(1.08) SKIP(1.55)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Prosjekt"
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
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NORPROSJEKT.prosjektid IN FRAME Dialog-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dialog-Frame
/* Query rebuild information for DIALOG-BOX Dialog-Frame
     _TblList          = "norcalc.NORPROSJEKT"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dialog-Frame */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Prosjekt */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dialog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dialog-Frame /* Cancel */
DO:
    nyRecord = FALSE.
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
    IF nyRecord THEN
    DO:
       define var ip_neste_id as integer.

       run neste_id.p ('norprosjekt', output ip_neste_id).
       ASSIGN  NORPROSJEKT.prosjektid =  ip_neste_id.
       Current-Rec = ROWID(NORPROSJEKT).
       dynamic-function('setCurrentRec' in hParent,current-rec).
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
  pointer = SESSION:SET-WAIT-STATE("").
  hParent = source-procedure.
  current-rec = dynamic-function('getCurrentRec' in hParent).
    IF nyRecord THEN
       RUN nyttProsjekt.
    ELSE
         RUN endreProsjekt.
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

  {&OPEN-QUERY-Dialog-Frame}
  GET FIRST Dialog-Frame.
  IF AVAILABLE NORPROSJEKT THEN 
    DISPLAY NORPROSJEKT.prosjektid NORPROSJEKT.reg_dato NORPROSJEKT.prosjekt_navn 
          NORPROSJEKT.aggregater NORPROSJEKT.shuntgrupper NORPROSJEKT.spirovent 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-31 NORPROSJEKT.prosjektid NORPROSJEKT.reg_dato 
         NORPROSJEKT.prosjekt_navn NORPROSJEKT.aggregater 
         NORPROSJEKT.shuntgrupper NORPROSJEKT.spirovent Btn_OK Btn_Cancel 
         Btn_Help 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreProsjekt Dialog-Frame 
PROCEDURE endreProsjekt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NORPROSJEKT WHERE ROWID(NORPROSJEKT) = Current-Rec EXCLUSIVE-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE NORPROSJEKT THEN
      DO:
         DISPLAY NORPROSJEKT.prosjektId   WITH FRAME Dialog-Frame.
         UPDATE  NORPROSJEKT.reg_dato NORPROSJEKT.prosjekt_navn 
              NORPROSJEKT.aggregater NORPROSJEKT.shuntgrupper NORPROSJEKT.spirovent 
              Btn_OK Btn_Cancel Btn_Help 
          WITH FRAME Dialog-Frame.
    END.
ELSE
    DO:
    MESSAGE 'Tabellen for Prosjekter er opptatt. Prøv igjen om en liten stund' VIEW-AS ALERT-BOX
        TITLE 'STOPP'.
    RETURN.
    END.
  
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttProsjekt Dialog-Frame 
PROCEDURE nyttProsjekt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     create norprosjekt.
     NORPROSJEKT.reg_dato = TODAY.
     DISPLAY NORPROSJEKT.reg_dato WITH FRAME  {&FRAME-NAME}.
     UPDATE  NORPROSJEKT.reg_dato NORPROSJEKT.prosjekt_navn 
         NORPROSJEKT.aggregater NORPROSJEKT.shuntgrupper NORPROSJEKT.spirovent 
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dialog-Frame.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

