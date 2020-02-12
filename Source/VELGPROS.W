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
DEFINE OUTPUT PARAMETER prosjektIdParam LIKE NORPROSJEKT.prosjektid.
DEFINE INPUT PARAMETER produktParam AS CHAR.

/* Local Variable Definitions ---                                       */
DEFINE VAR linjePeker AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGCLOSE
&Scoped-define BROWSE-NAME BROWSE-Prosjekt

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NORPROSJEKT

/* Definitions for BROWSE BROWSE-Prosjekt                               */
&Scoped-define FIELDS-IN-QUERY-BROWSE-Prosjekt NORPROSJEKT.prosjekt_navn ~
NORPROSJEKT.reg_dato NORPROSJEKT.aggregater NORPROSJEKT.shuntgrupper ~
NORPROSJEKT.spirovent NORPROSJEKT.aktivt NORPROSJEKT.prosjektid 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-Prosjekt 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-Prosjekt
&Scoped-define OPEN-QUERY-BROWSE-Prosjekt OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK ~
    BY NORPROSJEKT.reg_dato DESCENDING.
&Scoped-define TABLES-IN-QUERY-BROWSE-Prosjekt NORPROSJEKT
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-Prosjekt NORPROSJEKT


/* Definitions for DIALOG-BOX DLGCLOSE                                  */

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FILL-IN_name BROWSE-Prosjekt 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_name 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE VARIABLE FILL-IN_name AS CHARACTER FORMAT "X(30)":U 
     LABEL "Prosjektnavn (Inneholder)" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 43.12 BY 1.24
     BGCOLOR 2 FGCOLOR 1 FONT 2 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-Prosjekt FOR 
      NORPROSJEKT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-Prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-Prosjekt DLGCLOSE _STRUCTURED
  QUERY BROWSE-Prosjekt NO-LOCK DISPLAY
      NORPROSJEKT.prosjekt_navn FORMAT "X(43)" COLUMN-FONT 2
      NORPROSJEKT.reg_dato COLUMN-FONT 2
      NORPROSJEKT.aggregater COLUMN-FONT 2
      NORPROSJEKT.shuntgrupper COLUMN-LABEL "Shunter" COLUMN-FONT 2
      NORPROSJEKT.spirovent COLUMN-FONT 2
      NORPROSJEKT.aktivt COLUMN-FONT 2
      NORPROSJEKT.prosjektid COLUMN-FONT 2
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 124.6 BY 11.97
         BGCOLOR 15 FGCOLOR 1 FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     FILL-IN_name AT ROW 1.36 COL 43.8 COLON-ALIGNED
     BROWSE-Prosjekt AT ROW 3.01 COL 1
     SPACE(2.40) SKIP(0.58)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 FONT 2
         TITLE BGCOLOR 8 "Velg Prosjekt":L.


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
/* BROWSE-TAB BROWSE-Prosjekt FILL-IN_name DLGCLOSE */
ASSIGN 
       FRAME DLGCLOSE:SCROLLABLE       = FALSE
       FRAME DLGCLOSE:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-Prosjekt
/* Query rebuild information for BROWSE BROWSE-Prosjekt
     _TblList          = "norcalc.NORPROSJEKT"
     _Options          = "NO-LOCK"
     _OrdList          = "norcalc.NORPROSJEKT.reg_dato|no"
     _FldNameList[1]   > norcalc.NORPROSJEKT.prosjekt_navn
"NORPROSJEKT.prosjekt_navn" ? "X(43)" "character" ? ? 2 ? ? ? no ?
     _FldNameList[2]   > norcalc.NORPROSJEKT.reg_dato
"NORPROSJEKT.reg_dato" ? ? "date" ? ? 2 ? ? ? no ?
     _FldNameList[3]   > norcalc.NORPROSJEKT.aggregater
"NORPROSJEKT.aggregater" ? ? "character" ? ? 2 ? ? ? no ?
     _FldNameList[4]   > norcalc.NORPROSJEKT.shuntgrupper
"NORPROSJEKT.shuntgrupper" "Shunter" ? "character" ? ? 2 ? ? ? no ?
     _FldNameList[5]   > norcalc.NORPROSJEKT.spirovent
"NORPROSJEKT.spirovent" ? ? "character" ? ? 2 ? ? ? no ?
     _FldNameList[6]   > norcalc.NORPROSJEKT.aktivt
"NORPROSJEKT.aktivt" ? ? "logical" ? ? 2 ? ? ? no ?
     _FldNameList[7]   > norcalc.NORPROSJEKT.prosjektid
"NORPROSJEKT.prosjektid" ? ? "integer" ? ? 2 ? ? ? no ?
     _Query            is NOT OPENED
*/  /* BROWSE BROWSE-Prosjekt */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DLGCLOSE
/* Query rebuild information for DIALOG-BOX DLGCLOSE
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX DLGCLOSE */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-Prosjekt
&Scoped-define SELF-NAME BROWSE-Prosjekt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Prosjekt DLGCLOSE
ON ENTRY OF BROWSE-Prosjekt IN FRAME DLGCLOSE
DO:
  DEFINE VAR i AS INTEGER.
  DEFINE VAR rad AS LOGICAL.
  
  i = BROWSE-Prosjekt:GET-REPOSITIONED-ROW().
  rad = BROWSE-Prosjekt:SELECT-ROW(i).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Prosjekt DLGCLOSE
ON GO OF BROWSE-Prosjekt IN FRAME DLGCLOSE
DO:
  prosjektIdParam = NORPROSJEKT.prosjektid.
  APPLY "GO" TO  FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Prosjekt DLGCLOSE
ON LEFT-MOUSE-DBLCLICK OF BROWSE-Prosjekt IN FRAME DLGCLOSE
DO:
  prosjektIdParam = NORPROSJEKT.prosjektid.
  APPLY "GO" TO  FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-Prosjekt DLGCLOSE
ON RETURN OF BROWSE-Prosjekt IN FRAME DLGCLOSE
DO:
  prosjektIdParam = NORPROSJEKT.prosjektid.
  APPLY "GO" TO  FRAME {&FRAME-NAME}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_name DLGCLOSE
ON LEAVE OF FILL-IN_name IN FRAME DLGCLOSE /* Prosjektnavn (Inneholder) */
OR RETURN OF FILL-IN_name DO:
   OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
         WHERE NORPROSJEKT.prosjekt_navn MATCHES "*" + SELF:SCREEN-VALUE + "*"
          AND NORPROSJEKT.aktivt  = TRUE
         BY NORPROSJEKT.prosjekt_navn.
    IF AVAILABLE NORPROSJEKT THEN DO:
       APPLY "ENTRY" TO BROWSE-prosjekt.
       RETURN NO-APPLY.
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
  RUN fyllBrowser.
  linjePeker = BROWSE-prosjekt:SELECT-ROW(1).
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
  ENABLE FILL-IN_name BROWSE-Prosjekt 
      WITH FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE fyllBrowser DLGCLOSE 
PROCEDURE fyllBrowser :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE produktParam:
    WHEN 'Aggregat' THEN
        OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
            WHERE NORPROSJEKT.aggregater = 'Ja'  BY NORPROSJEKT.reg_dato DESCENDING.
    WHEN 'Shunt' THEN
        OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
            WHERE NORPROSJEKT.shuntgrupper = 'Ja'  BY NORPROSJEKT.reg_dato DESCENDING.
    WHEN 'Spiro' THEN
        OPEN QUERY BROWSE-Prosjekt FOR EACH NORPROSJEKT NO-LOCK 
            WHERE NORPROSJEKT.spirovent = 'Ja'  BY NORPROSJEKT.reg_dato DESCENDING.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


