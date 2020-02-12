&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME DLGCLOSE
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DLGCLOSE 
/*------------------------------------------------------------------------

  File: dlgclose.w

  Description: General use dialog box 
    template with Close and Help buttons

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/08/94 -  9:14 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER kundenrParam LIKE NPKUNDE.kundenr.
DEFINE INPUT-OUTPUT PARAMETER kundenavnParam LIKE NPKUNDE.kundenavn.
DEFINE OUTPUT PARAMETER rabattParam AS DECIMAL.

/* Local Variable Definitions ---                                       */
DEFINE VAR linjePeker AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGCLOSE
&Scoped-define BROWSE-NAME BROWSE-6

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPKUNDE

/* Definitions for BROWSE BROWSE-6                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-6 NPKUNDE.kundenavn NPKUNDE.poststed ~
NPKUNDE.kundekategori NPKUNDE.rabatt%_1 NPKUNDE.adresse1 NPKUNDE.postnr ~
NPKUNDE.kundenr NPKUNDE.kilde 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-6 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-6
&Scoped-define OPEN-QUERY-BROWSE-6 OPEN QUERY BROWSE-6 FOR EACH NPKUNDE ~
      WHERE NPKUNDE.tilbudsmottager = TRUE NO-LOCK ~
    BY NPKUNDE.kundenavn ~
       BY NPKUNDE.kundenr.
&Scoped-define TABLES-IN-QUERY-BROWSE-6 NPKUNDE
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-6 NPKUNDE


/* Definitions for DIALOG-BOX DLGCLOSE                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DLGCLOSE ~
    ~{&OPEN-QUERY-BROWSE-6}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_name BROWSE-6 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_name 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN_name AS CHARACTER FORMAT "X(30)":U 
     LABEL "Kundenavn" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 43.12 BY 1.24
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-6 FOR 
      NPKUNDE SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-6 DLGCLOSE _STRUCTURED
  QUERY BROWSE-6 NO-LOCK DISPLAY
      NPKUNDE.kundenavn
      NPKUNDE.poststed
      NPKUNDE.kundekategori
      NPKUNDE.rabatt%_1
      NPKUNDE.adresse1
      NPKUNDE.postnr
      NPKUNDE.kundenr
      NPKUNDE.kilde
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 99.4 BY 11.55
         BGCOLOR 15 FGCOLOR 1 FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     FILL-IN_name AT ROW 1.59 COL 19.44 COLON-ALIGNED
     BROWSE-6 AT ROW 3.6 COL 1.84
     SPACE(0.75) SKIP(0.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 FONT 2
         TITLE BGCOLOR 8 "Velg Kunde":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGCLOSE
   UNDERLINE                                                            */
/* BROWSE-TAB BROWSE-6 FILL-IN_name DLGCLOSE */
ASSIGN 
       FRAME DLGCLOSE:SCROLLABLE       = FALSE
       FRAME DLGCLOSE:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-6
/* Query rebuild information for BROWSE BROWSE-6
     _TblList          = "norcalc.NPKUNDE"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NPKUNDE.kundenavn|yes,norcalc.NPKUNDE.kundenr|yes"
     _Where[1]         = "NPKUNDE.tilbudsmottager = TRUE"
     _FldNameList[1]   = norcalc.NPKUNDE.kundenavn
     _FldNameList[2]   = norcalc.NPKUNDE.poststed
     _FldNameList[3]   = norcalc.NPKUNDE.kundekategori
     _FldNameList[4]   = NORCALC.NPKUNDE.rabatt%_1
     _FldNameList[5]   = norcalc.NPKUNDE.adresse1
     _FldNameList[6]   = norcalc.NPKUNDE.postnr
     _FldNameList[7]   = norcalc.NPKUNDE.kundenr
     _FldNameList[8]   = norcalc.NPKUNDE.kilde
     _Query            is OPENED
*/  /* BROWSE BROWSE-6 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-6
&Scoped-define SELF-NAME BROWSE-6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 DLGCLOSE
ON ENTRY OF BROWSE-6 IN FRAME DLGCLOSE
DO:
  DEFINE VAR i AS INTEGER.
  DEFINE VAR rad AS LOGICAL.
  
  i = BROWSE-6:GET-REPOSITIONED-ROW().
  rad = BROWSE-6:SELECT-ROW(i).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 DLGCLOSE
ON GO OF BROWSE-6 IN FRAME DLGCLOSE
DO:
  kundenrParam = NPKUNDE.kundenr.
  kundenavnParam = NPKUNDE.kundenavn.
  rabattParam = NPKUNDE.rabatt%_1.
  APPLY "GO" TO  FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 DLGCLOSE
ON LEFT-MOUSE-DBLCLICK OF BROWSE-6 IN FRAME DLGCLOSE
DO:
  kundenrParam = NPKUNDE.kundenr.
  kundenavnParam = NPKUNDE.kundenavn.
  rabattParam = NPKUNDE.rabatt%_1.
  APPLY "GO" TO  FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-6 DLGCLOSE
ON RETURN OF BROWSE-6 IN FRAME DLGCLOSE
DO:
  kundenrParam = NPKUNDE.kundenr.
  kundenavnParam = NPKUNDE.kundenavn.
  rabattParam = NPKUNDE.rabatt%_1.
  APPLY "GO" TO  FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_name DLGCLOSE
ON LEAVE OF FILL-IN_name IN FRAME DLGCLOSE /* Kundenavn */
OR RETURN OF FILL-IN_name DO:
  IF SELF:SCREEN-VALUE NE "":U THEN DO:
    FIND FIRST NPKUNDE WHERE NPKUNDE.kundenavn >=  SELF:SCREEN-VALUE
    AND NPKUNDE.tilbudsmottager = TRUE
        USE-INDEX ndx_kundenavn   NO-LOCK NO-ERROR.
    IF NOT AVAILABLE NPKUNDE THEN
      FIND LAST NPKUNDE WHERE NPKUNDE.tilbudsmottager = TRUE
        USE-INDEX ndx_kundenavn NO-LOCK NO-ERROR.
    IF AVAILABLE NPKUNDE THEN DO:
      REPOSITION {&BROWSE-NAME} TO ROWID ROWID(NPKUNDE).
      APPLY 'ENTRY' TO BROWSE-6.
      RETURN NO-APPLY.
    END.
    SELF:SCREEN-VALUE = "":U.
  END.
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DLGCLOSE 


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
  linjePeker = BROWSE-6:SELECT-ROW(1).
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI DLGCLOSE _DEFAULT-DISABLE
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
  HIDE FRAME DLGCLOSE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI DLGCLOSE _DEFAULT-ENABLE
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
      WITH FRAME DLGCLOSE.
  ENABLE FILL-IN_name BROWSE-6 
      WITH FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


