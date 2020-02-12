&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dilaog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dilaog-Frame 
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
DEFINE INPUT PARAMETER anleggsNavnParam AS CHAR.
DEFINE INPUT PARAMETER nyRecord AS LOGICAL.
DEFINE SHARED VARIABLE anleggsnrParam LIKE NPAGANLG.anleggsnr.
DEFINE SHARED VARIABLE Current-Rec as ROWID.
DEFINE NEW SHARED VARIABLE systemnrParam LIKE NPAGSYST.systemnr.
DEFINE VAR syst# LIKE NPAGSYST.systemnr.
DEFINE VAR p_batteri_hastighet AS DECIMAL.
DEFINE VAR p_kabinett_hastighet AS DECIMAL.
DEFINE VAR p_type LIKE NPAGTYPE.aggregattype.


/* Local Variable Definitions ---                                       */
DEFINE VARIABLE Current-Widget AS WIDGET-HANDLE.
DEFINE VAR pointer AS LOGICAL. 
DEFINE VAR i AS INTEGER.
DEFINE VAR temp-string AS CHAR.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dilaog-Frame

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPAGSYST

/* Definitions for DIALOG-BOX Dilaog-Frame                              */
&Scoped-define FIELDS-IN-QUERY-Dilaog-Frame NPAGSYST.systembetegnelse ~
NPAGSYST.plassering NPAGSYST.smb_maal NPAGSYST.funksjonsdeler ~
NPAGSYST.anmerkninger NPAGSYST.standardpris NPAGSYST.systemvekt 
&Scoped-define ENABLED-FIELDS-IN-QUERY-Dilaog-Frame ~
NPAGSYST.systembetegnelse NPAGSYST.plassering NPAGSYST.smb_maal ~
NPAGSYST.funksjonsdeler NPAGSYST.anmerkninger NPAGSYST.standardpris ~
NPAGSYST.systemvekt 
&Scoped-define ENABLED-TABLES-IN-QUERY-Dilaog-Frame NPAGSYST
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-Dilaog-Frame NPAGSYST

&Scoped-define FIELD-PAIRS-IN-QUERY-Dilaog-Frame~
 ~{&FP1}systembetegnelse ~{&FP2}systembetegnelse ~{&FP3}~
 ~{&FP1}smb_maal ~{&FP2}smb_maal ~{&FP3}~
 ~{&FP1}standardpris ~{&FP2}standardpris ~{&FP3}~
 ~{&FP1}systemvekt ~{&FP2}systemvekt ~{&FP3}
&Scoped-define OPEN-QUERY-Dilaog-Frame OPEN QUERY Dilaog-Frame FOR EACH NPAGSYST SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-Dilaog-Frame NPAGSYST
&Scoped-define FIRST-TABLE-IN-QUERY-Dilaog-Frame NPAGSYST


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPAGSYST.systembetegnelse NPAGSYST.plassering ~
NPAGSYST.smb_maal NPAGSYST.funksjonsdeler NPAGSYST.anmerkninger ~
NPAGSYST.standardpris NPAGSYST.systemvekt 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}systembetegnelse ~{&FP2}systembetegnelse ~{&FP3}~
 ~{&FP1}smb_maal ~{&FP2}smb_maal ~{&FP3}~
 ~{&FP1}standardpris ~{&FP2}standardpris ~{&FP3}~
 ~{&FP1}systemvekt ~{&FP2}systemvekt ~{&FP3}
&Scoped-define ENABLED-TABLES NPAGSYST
&Scoped-define FIRST-ENABLED-TABLE NPAGSYST
&Scoped-Define ENABLED-OBJECTS RECT-1 Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPAGSYST.systembetegnelse ~
NPAGSYST.plassering NPAGSYST.smb_maal NPAGSYST.funksjonsdeler ~
NPAGSYST.anmerkninger NPAGSYST.standardpris NPAGSYST.systemvekt 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 10.6 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help" 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY 1
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 95.2 BY 10.14.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY Dilaog-Frame FOR 
      NPAGSYST SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dilaog-Frame
     NPAGSYST.systembetegnelse AT ROW 1.86 COL 26.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 41.4 BY 1
     NPAGSYST.plassering AT ROW 3.1 COL 26.6 COLON-ALIGNED
          VIEW-AS COMBO-BOX 
          LIST-ITEMS "","Sammenbygd","Stablet","Hver for seg" 
          SIZE 16.2 BY 1
     NPAGSYST.smb_maal AT ROW 3.1 COL 74.8 COLON-ALIGNED
          LABEL "Sammenbygningsmål"
          VIEW-AS FILL-IN NATIVE 
          SIZE 8.4 BY 1
          BGCOLOR 8 FGCOLOR 1 
     NPAGSYST.funksjonsdeler AT ROW 4.38 COL 28.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 59.8 BY 2.05
     NPAGSYST.anmerkninger AT ROW 6.57 COL 28.6 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 59.8 BY 2.14
     NPAGSYST.standardpris AT ROW 8.91 COL 26.6 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 13.4 BY 1
     NPAGSYST.systemvekt AT ROW 8.91 COL 56.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 9.4 BY 1
     Btn_OK AT ROW 12.05 COL 36.8
     Btn_Cancel AT ROW 12.05 COL 46.2
     Btn_Help AT ROW 12.05 COL 58.6
     RECT-1 AT ROW 1.33 COL 2.2
     "Funksjonsdeler:" VIEW-AS TEXT
          SIZE 19.4 BY .62 AT ROW 4.29 COL 8.2
     "Anmerkninger:" VIEW-AS TEXT
          SIZE 17.6 BY 1.1 AT ROW 6.14 COL 10
     SPACE(71.19) SKIP(6.46)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Aggregatsystem - Systeminfo"
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
/* SETTINGS FOR DIALOG-BOX Dilaog-Frame
                                                                        */
ASSIGN 
       FRAME Dilaog-Frame:SCROLLABLE       = FALSE
       FRAME Dilaog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN NPAGSYST.smb_maal IN FRAME Dilaog-Frame
   EXP-LABEL                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX Dilaog-Frame
/* Query rebuild information for DIALOG-BOX Dilaog-Frame
     _TblList          = "norcalc.NPAGSYST"
     _Options          = "SHARE-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX Dilaog-Frame */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dilaog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dilaog-Frame Dilaog-Frame
ON WINDOW-CLOSE OF FRAME Dilaog-Frame /* Aggregatsystem - Systeminfo */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Cancel Dilaog-Frame
ON CHOOSE OF Btn_Cancel IN FRAME Dilaog-Frame /* Cancel */
DO:
  nyRecord = FALSE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help Dilaog-Frame
ON CHOOSE OF Btn_Help IN FRAME Dilaog-Frame /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dilaog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dilaog-Frame /* OK */
DO:
    Current-Rec = ROWID(NPAGSYST).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPAGSYST.smb_maal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPAGSYST.smb_maal Dilaog-Frame
ON ENTRY OF NPAGSYST.smb_maal IN FRAME Dilaog-Frame /* Sammenbygningsmål */
DO:
  Return No-Apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dilaog-Frame 


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
   IF nyRecord THEN
        RUN nyttSystem.
   ELSE
        RUN endreSystem.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dilaog-Frame _DEFAULT-DISABLE
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
  HIDE FRAME Dilaog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dilaog-Frame _DEFAULT-ENABLE
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

  {&OPEN-QUERY-Dilaog-Frame}
  GET FIRST Dilaog-Frame.
  IF AVAILABLE NPAGSYST THEN 
    DISPLAY NPAGSYST.systembetegnelse NPAGSYST.plassering NPAGSYST.smb_maal 
          NPAGSYST.funksjonsdeler NPAGSYST.anmerkninger NPAGSYST.standardpris 
          NPAGSYST.systemvekt 
      WITH FRAME Dilaog-Frame.
  ENABLE RECT-1 NPAGSYST.systembetegnelse NPAGSYST.plassering NPAGSYST.smb_maal 
         NPAGSYST.funksjonsdeler NPAGSYST.anmerkninger NPAGSYST.standardpris 
         NPAGSYST.systemvekt Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME Dilaog-Frame.
  VIEW FRAME Dilaog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dilaog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreSystem Dilaog-Frame 
PROCEDURE endreSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND NPAGSYST WHERE ROWID(NPAGSYST) = Current-Rec EXCLUSIVE-LOCK
   NO-ERROR NO-WAIT.
  IF AVAILABLE NPAGSYST THEN
    DO:
        UPDATE 
            NPAGSYST.systembetegnelse   NPAGSYST.smb_maal 
            NPAGSYST.plassering
             NPAGSYST.funksjonsdeler   NPAGSYST.anmerkninger 
            NPAGSYST.standardpris NPAGSYST.systemvekt   
              Btn_OK Btn_Cancel Btn_Help
           WITH FRAME {&FRAME-NAME}.
    END.
 ELSE DO:
        MESSAGE 'KUNNE IKKE FINNE POSTEN' VIEW-AS ALERT-BOX.
         RETURN.
    END.
 END. /* TRANSACTION */      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttSystem Dilaog-Frame 
PROCEDURE nyttSystem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  FIND LAST NPAGSYST WHERE NPAGSYST.anleggsnr = anleggsnrParam NO-LOCK 
    NO-ERROR NO-WAIT.
  IF AVAILABLE(NPAGSYST) THEN
      /* Det er opprettet system for dette anlegget tidligere */
          syst# = NPAGSYST.systemnr  + 1.
  ELSE
    DO:
      IF LOCKED NPAGSYST THEN
         DO:
            /* Andre registrerer spiroventsystem på dette anlegget nå */
             MESSAGE 'Andre registrerer aggregatsystem på dette anlegget nå. Prøv igjen senere' VIEW-AS ALERT-BOX 
                 TITLE 'STOPP'.
            RETURN.
         END.
    ELSE            
      syst# = 1.  
    END.
  CREATE NPAGSYST.
  NPAGSYST.anleggsnr  = anleggsnrParam.
  NPAGSYST.systemnr = syst#.
  systemnrParam = syst#.
 UPDATE 
    NPAGSYST.systembetegnelse NPAGSYST.plassering
    NPAGSYST.funksjonsdeler   NPAGSYST.anmerkninger
    NPAGSYST.standardpris   NPAGSYST.systemvekt     
      Btn_OK Btn_Cancel Btn_Help
      WITH FRAME {&FRAME-NAME}.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


