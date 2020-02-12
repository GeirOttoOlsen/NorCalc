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
DEFINE VAR Current-Rec AS RECID.
/*DEFINE INPUT-OUTPUT PARAMETER dimm_verdi LIKE NPSHMSEGR.storrelse.*/
DEFINE INPUT-OUTPUT PARAMETER dimm_verdi as char no-undo.
DEFINE INPUT PARAMETER c_kapasitet AS DECIMAL.
DEFINE INPUT PARAMETER c_grunnlag AS CHAR.
DEFINE VAR selectedRow AS LOGICAL.
DEFINE VAR  i  AS INTEGER  INITIAL 1.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGCLOSE
&Scoped-define BROWSE-NAME BROWSE-5

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHGruppe

/* Definitions for BROWSE BROWSE-5                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-5 NPSHGruppe.storrelse NPSHGruppe.nedre ~
NPSHGruppe.ovre NPSHGruppe.grunnlag 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-5 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-5
&Scoped-define OPEN-QUERY-BROWSE-5 OPEN QUERY BROWSE-5 FOR EACH NPSHGruppe NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-5 NPSHGruppe
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-5 NPSHGruppe


/* Definitions for DIALOG-BOX DLGCLOSE                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DLGCLOSE ~
    ~{&OPEN-QUERY-BROWSE-5}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-5 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-5 FOR 
      NPSHGruppe SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-5 DLGCLOSE _STRUCTURED
  QUERY BROWSE-5 NO-LOCK DISPLAY
      NPSHGruppe.storrelse format "x(3)"
      NPSHGruppe.nedre
      NPSHGruppe.ovre
      NPSHGruppe.grunnlag
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 99.68 BY 7.43
         BGCOLOR 15 FGCOLOR 4 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     BROWSE-5 AT ROW 1 COL 1.84
     SPACE(1.32) SKIP(0.74)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 
         TITLE BGCOLOR 8 "Shunt - dimmensjoner for MSE":L.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX DLGCLOSE
   EXP-POSITION UNDERLINE                                               */
/* BROWSE-TAB BROWSE-5 1 DLGCLOSE */
ASSIGN 
       FRAME DLGCLOSE:SCROLLABLE       = FALSE
       FRAME DLGCLOSE:ROW              = 5.95
       FRAME DLGCLOSE:COLUMN           = 6.6
       FRAME DLGCLOSE:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-5
/* Query rebuild information for BROWSE BROWSE-5
     _TblList          = "norcalc.NPSHGruppe"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = norcalc.NPSHGruppe.storrelse
     _FldNameList[2]   = norcalc.NPSHGruppe.nedre
     _FldNameList[3]   = norcalc.NPSHGruppe.ovre
     _FldNameList[4]   = norcalc.NPSHGruppe.grunnlag
     _Query            is OPENED
*/  /* BROWSE BROWSE-5 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-5
&Scoped-define SELF-NAME BROWSE-5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 DLGCLOSE
ON GO OF BROWSE-5 IN FRAME DLGCLOSE
DO:
  Current-Rec = RECID(NPSHGruppe).
  FIND NPSHGruppe WHERE RECID (NPSHGruppe) = Current-Rec.
  dimm_verdi = NPSHGruppe.storrelse.
  APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 DLGCLOSE
ON LEFT-MOUSE-DBLCLICK OF BROWSE-5 IN FRAME DLGCLOSE
DO:
  Current-Rec = RECID(NPSHGruppe).
  FIND NPSHGruppe WHERE RECID (NPSHGruppe) = Current-Rec.
  dimm_verdi = NPSHGruppe.storrelse.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-5 DLGCLOSE
ON RETURN OF BROWSE-5 IN FRAME DLGCLOSE
DO:
  Current-Rec = RECID(NPSHGruppe).
  FIND NPSHGruppe WHERE RECID (NPSHGruppe) = Current-Rec.
  dimm_verdi = NPSHGruppe.storrelse.
  APPLY "GO":U TO FRAME {&FRAME-NAME}.

/*  APPLY "CLOSE":U TO THIS-PROCEDURE.*/
  
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
/*  RUN enable_UI.*/
    find first NPSHGruppeType where NPSHGruppeType.NPSHGruppeTypeNavn = 'MSE' no-error.
    if error-status:error then MESSAGE 'MSE - gruppen finnes ikke, kontakt administrator'
                               VIEW-AS ALERT-BOX.            
   ENABLE BROWSE-5 WITH FRAME DLGCLOSE.
   OPEN QUERY BROWSE-5 FOR EACH NPSHGruppe where NPSHGruppe.iNPSHGruppeTypeId = NPSHGruppeType.iNPSHGruppeTypeId NO-LOCK.
   selectedRow = BROWSE-5:SELECT-ROW(1).            
    FOR EACH NPSHGruppe where NPSHGruppe.iNPSHGruppeTypeId = NPSHGruppeType.iNPSHGruppeTypeId no-lock:
      IF  (NPSHGruppe.nedre  <  c_kapasitet  AND
          NPSHGruppe.ovre  >= c_kapasitet) AND NPSHGruppe.grunnlag = c_grunnlag THEN         
          DO:                       
              dimm_verdi = NPSHGruppe.storrelse.
              LEAVE.
          END.
      ELSE
            selectedRow = BROWSE-5:SELECT-NEXT-ROW().          

    END.

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
  ENABLE BROWSE-5 
      WITH FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


