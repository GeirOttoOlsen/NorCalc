&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME KONSULENT
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS KONSULENT 
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 09/08/95 -  8:27 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER konsulentnrParam AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER konsulentnvnParam AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VAR linjePeker AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME KONSULENT
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKUNDE

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 NPKUNDE.kundenavn NPKUNDE.adresse1 ~
NPKUNDE.postnr NPKUNDE.poststed 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-5
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH NPKUNDE ~
      WHERE NPKUNDE.aktiv = TRUE ~
 AND NPKUNDE.er_konsulent = TRUE NO-LOCK ~
    BY NPKUNDE.kundenavn.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 NPKUNDE


/* Definitions for DIALOG-BOX KONSULENT                                 */
&Scoped-define OPEN-BROWSERS-IN-QUERY-KONSULENT ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_name BROWSE-5 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_name 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN_name AS CHARACTER FORMAT "X(30)":U 
     LABEL "Konsulent" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 38.08 BY 1.24
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 KONSULENT _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      NPKUNDE.kundenavn COLUMN-LABEL "Konsulent"
      NPKUNDE.adresse1
      NPKUNDE.postnr
      NPKUNDE.poststed
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SIZE 52.36 BY 7.84
         BGCOLOR 15 FGCOLOR 1 FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME KONSULENT
     FILL-IN_name AT ROW 1.64 COL 16.92 COLON-ALIGNED
     BROWSE-5 AT ROW 3.24 COL 2.12
     SPACE(2.65) SKIP(0.29)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Velg Konsulent":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX KONSULENT
                                                                        */
/* BROWSE-TAB BROWSE-5 FILL-IN_name KONSULENT */
ASSIGN 
       FRAME KONSULENT:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "norcalc.NPKUNDE"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPKUNDE.kundenavn|yes"
     _Where[1]         = "NPKUNDE.aktiv = TRUE
 AND NPKUNDE.er_konsulent = TRUE"
     _FldNameList[1]   > norcalc.NPKUNDE.kundenavn
"NPKUNDE.kundenavn" "Konsulent" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   = norcalc.NPKUNDE.adresse1
     _FldNameList[3]   = norcalc.NPKUNDE.postnr
     _FldNameList[4]   = norcalc.NPKUNDE.poststed
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 KONSULENT
ON ENTRY OF BROWSE-5 IN FRAME KONSULENT
DO:
  DEFINE VAR i AS INTEGER.
  DEFINE VAR rad AS LOGICAL.
  
  i = BROWSE-5:GET-REPOSITIONED-ROW().
  rad = BROWSE-5:SELECT-ROW(i).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 KONSULENT
ON GO OF BROWSE-5 IN FRAME KONSULENT
DO:
    konsulentnrParam = NPKUNDE.kundenr.
    konsulentnvnParam = NPKUNDE.kundenavn.
    APPLY "GO" TO  FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 KONSULENT
ON LEFT-MOUSE-DBLCLICK OF BROWSE-5 IN FRAME KONSULENT
DO:
    konsulentnrParam = NPKUNDE.kundenr.
    konsulentnvnParam = NPKUNDE.kundenavn.
      APPLY "GO" TO  FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 KONSULENT
ON RETURN OF BROWSE-5 IN FRAME KONSULENT
DO:
    konsulentnrParam = NPKUNDE.kundenr.
    konsulentnvnParam = NPKUNDE.kundenavn.
     APPLY "GO" TO  FRAME {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_name KONSULENT
ON LEAVE OF FILL-IN_name IN FRAME KONSULENT /* Konsulent */
OR RETURN OF FILL-IN_name DO:
  IF SELF:SCREEN-VALUE NE "":U THEN DO:
    FIND FIRST NPKUNDE WHERE NPKUNDE.kundenavn >=  SELF:SCREEN-VALUE
        AND NPKUNDE.aktiv AND NPKUNDE.er_konsulent
        USE-INDEX ndx_aktive_konsulenter   NO-LOCK NO-ERROR.
    IF NOT AVAILABLE NPKUNDE THEN
      FIND LAST NPKUNDE WHERE NPKUNDE.aktiv AND NPKUNDE.er_konsulent
       USE-INDEX ndx_aktive_konsulenter NO-LOCK NO-ERROR.
    IF AVAILABLE NPKUNDE THEN DO:
      REPOSITION {&BROWSE-NAME} TO ROWID ROWID(NPKUNDE).
      APPLY 'ENTRY' TO BROWSE-5.
      RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = "":U.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK KONSULENT 


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
  linjePeker = BROWSE-5:SELECT-ROW(1).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI KONSULENT _DEFAULT-DISABLE
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
  HIDE FRAME KONSULENT.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI KONSULENT _DEFAULT-ENABLE
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
  DISPLAY FILL-IN_name 
      WITH FRAME KONSULENT.
  ENABLE FILL-IN_name BROWSE-5 
      WITH FRAME KONSULENT.
  {&OPEN-BROWSERS-IN-QUERY-KONSULENT}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


