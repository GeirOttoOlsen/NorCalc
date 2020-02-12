&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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

/* Parameters Definitions ---                                            */
DEFINE INPUT PARAMETER p_standard_utbygd AS CHAR.
DEFINE INPUT PARAMETER p_nom_kapasitet LIKE NPAGSYST.fraluft_nom_kapasitet.
DEFINE INPUT PARAMETER tittelParam AS CHAR. 
DEFINE INPUT PARAMETER c_rortype AS CHAR.
DEFINE OUTPUT PARAMETER p_batteri_hastighet AS DECIMAL.
DEFINE OUTPUT PARAMETER p_kabinett_hastighet AS DECIMAL.
DEFINE OUTPUT PARAMETER p_type LIKE NPAGTYPE.aggregattype.

IF tittelParam = "" THEN
    tittelParam = "(Tittel)".

/* Local Variable Definitions ---                                       */
DEFINE VAR Current-Rec AS ROWID.
DEFINE SHARED VARIABLE anleggsnrParam LIKE NPSHSYST.anleggsnr.
DEFINE VAR c_bruksomraade LIKE NPAGANLG.bruksomraade.
DEFINE VAR selectedRow AS LOGICAL.
DEFINE VAR  c_anbefalt  AS ROWID.
DEFINE VAR pointer AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DLGCLOSE
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NORTYPE_TABLE NPKPA_Table

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 NORTYPE_TABLE.aggregattype ~
NORTYPE_TABLE.fronthast_batteri NORTYPE_TABLE.fronthast_kabinett 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define ENABLED-TABLES-IN-QUERY-BROWSE-1 
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH NORTYPE_TABLE NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 NORTYPE_TABLE
&Scoped-define TABLES-IN-QUERY-BROWSE-1 NORTYPE_TABLE

/* Definitions for DIALOG-BOX DLGCLOSE                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DLGCLOSE ~
    ~{&OPEN-QUERY-BROWSE-1}
&Scoped-define OPEN-QUERY-DLGCLOSE OPEN QUERY DLGCLOSE FOR EACH NPKPA_Table NO-LOCK.
&Scoped-define FIRST-TABLE-IN-QUERY-DLGCLOSE NPKPA_Table
&Scoped-define TABLES-IN-QUERY-DLGCLOSE NPKPA_Table

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      NORTYPE_TABLE SCROLLING.

DEFINE QUERY DLGCLOSE FOR 
      NPKPA_Table SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 DLGCLOSE _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      NORTYPE_TABLE.aggregattype COLUMN-LABEL "Aggregat"
      NORTYPE_TABLE.fronthast_batteri COLUMN-LABEL "Fronthast. Batteri"
      NORTYPE_TABLE.fronthast_kabinett COLUMN-LABEL "Fronthast. Kabinett"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH SEPARATORS SIZE 53.29 BY 7.58
         BGCOLOR 15 FGCOLOR 4 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DLGCLOSE
     BROWSE-1 AT ROW 1.08 COL 1.29
     SPACE(0.41) SKIP(0.02)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         BGCOLOR 8 
         TITLE BGCOLOR 8 tittelParam.

 

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
ASSIGN 
       FRAME DLGCLOSE:SCROLLABLE       = FALSE
       FRAME DLGCLOSE:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "norcalc.NORTYPE_TABLE"
     _Options          = "NO-LOCK"
     _FldNameList[1]   > norcalc.NORTYPE_TABLE.aggregattype
"NORTYPE_TABLE.aggregattype" "Aggregat" ? "character" ? ? ? ? ? ? no ?
     _FldNameList[2]   > norcalc.NORTYPE_TABLE.fronthast_batteri
"NORTYPE_TABLE.fronthast_batteri" "Fronthast. Batteri" ? "decimal" ? ? ? ? ? ? no ?
     _FldNameList[3]   > norcalc.NORTYPE_TABLE.fronthast_kabinett
"NORTYPE_TABLE.fronthast_kabinett" "Fronthast. Kabinett" ? "decimal" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX DLGCLOSE
/* Query rebuild information for DIALOG-BOX DLGCLOSE
     _TblList          = "norcalc.NPKPA_Table"
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* DIALOG-BOX DLGCLOSE */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON GO OF BROWSE-1 IN FRAME DLGCLOSE
DO:
    Current-Rec = ROWID(NORTYPE_TABLE).
    FIND NORTYPE_TABLE WHERE ROWID (NORTYPE_TABLE) = Current-Rec.
    p_batteri_hastighet = NORTYPE_TABLE.fronthast_batteri.
    p_kabinett_hastighet = NORTYPE_TABLE.fronthast_kabinett.
    p_type = NORTYPE_TABLE.aggregattype.
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON LEFT-MOUSE-DBLCLICK OF BROWSE-1 IN FRAME DLGCLOSE
DO:
    Current-Rec = ROWID(NORTYPE_TABLE).
    FIND NORTYPE_TABLE WHERE ROWID (NORTYPE_TABLE) = Current-Rec.
    p_batteri_hastighet = NORTYPE_TABLE.fronthast_batteri.
    p_kabinett_hastighet = NORTYPE_TABLE.fronthast_kabinett.
    p_type = NORTYPE_TABLE.aggregattype.
  APPLY "GO" TO SELF.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 DLGCLOSE
ON RETURN OF BROWSE-1 IN FRAME DLGCLOSE
DO:
    Current-Rec = ROWID(NORTYPE_TABLE).
    FIND NORTYPE_TABLE WHERE ROWID (NORTYPE_TABLE) = Current-Rec.
    p_batteri_hastighet = NORTYPE_TABLE.fronthast_batteri.
    p_kabinett_hastighet = NORTYPE_TABLE.fronthast_kabinett.
    p_type = NORTYPE_TABLE.aggregattype.
  APPLY "GO" TO SELF.
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
    pointer = SESSION:SET-WAIT-STATE("").

    /* Bereg kpa og legg i tabell, tøm først */
    FOR EACH NORTYPE_TABLE:
        DELETE NORTYPE_TABLE.
    END.
    RUN beregnType.
    RUN enable_UI.

     REPOSITION BROWSE-1 TO ROWID c_anbefalt.
     selectedRow = BROWSE-1:SELECT-FOCUSED-ROW(). 
   
 WAIT-FOR GO OF FRAME {&FRAME-NAME}.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beregnType DLGCLOSE 
PROCEDURE beregnType :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE VAR c_teller AS DECIMAL INITIAL 0.
  DEFINE VAR c_nevner AS DECIMAL INITIAL 0.
  DEFINE VAR c_hastighet AS DECIMAL INITIAL 0.
  DEFINE  VAR c_hoyde AS DECIMAL INITIAL 0.
  DEFINE VAR c_bredde AS DECIMAL INITIAL 0.
  DEFINE VAR c_type AS CHAR.
     
 /* Finn bruksområde for aggregatet */
 FIND NPAGANLG WHERE NPAGANLG.anleggsnr = anleggsnrParam 
    NO-LOCK NO-ERROR NO-WAIT.
 IF AVAILABLE NPAGANLG THEN
    DO:
        IF NPAGANLG.bruksomraade BEGINS 'Skip' THEN
             c_bruksomraade = 'Skip'.
         ELSE 
             c_bruksomraade = 'Land'.
    END.
 ELSE
             c_bruksomraade = 'Land'.

  c_teller = (p_nom_kapasitet * 1000) * 1000.
  /* Regn ut batterimål */
  FOR EACH NPAGBATMAAL WHERE NPAGBATMAAL.batteritype = c_rortype
    NO-LOCK BY NPAGBATMAAL.aggregattype:
    c_bredde= NPAGBATMAAL.bredde_a.
    c_hoyde = NPAGBATMAAL.hoyde_t.
    c_type = NPAGBATMAAL.aggregattype.
     CREATE NORTYPE_TABLE.
     ASSIGN NORTYPE_TABLE.aggregattype = c_type.
     IF c_rortype = 'P3012' THEN
          c_nevner = c_bredde * c_hoyde * 30 * 3600.
      ELSE
          c_nevner = c_bredde * c_hoyde * 60 * 3600.
      ASSIGN NORTYPE_TABLE.fronthast_batteri = c_teller / c_nevner.
   END.
  /* Regn ut kabinettmål */
  FOR EACH NPAGKABMAAL NO-LOCK,
    EACH NORTYPE_TABLE OF NPAGKABMAAL BY NPAGKABMAAL.aggregattype:
    c_bredde= NPAGKABMAAL.bredde.
    c_hoyde = NPAGKABMAAL.hoyde.
    c_nevner = c_bredde * c_hoyde * 3600.
     ASSIGN NORTYPE_TABLE.fronthast_kabinett = c_teller / c_nevner.
   END.

/*Tilordne rett anbefalt verdi */
IF c_bruksomraade = 'Land' THEN
DO:
    FOR EACH NORTYPE_TABLE 
        WHERE NORTYPE_TABLE.aggregattype  BEGINS 'NOR'  
        BY NORTYPE_TABLE.fronthast_batteri DESC:
          IF NORTYPE_TABLE.fronthast_batteri <= 2.5 THEN     
              DO:
                    c_anbefalt = ROWID(NORTYPE_TABLE).
                    LEAVE.            
               END.
    END.
END.
ELSE
DO:
    FOR EACH NORTYPE_TABLE 
        WHERE NORTYPE_TABLE.aggregattype  BEGINS 'NM'  
          BY NORTYPE_TABLE.fronthast_batteri DESC:
          IF NORTYPE_TABLE.fronthast_batteri <= 2.5 THEN            
              DO:
                    c_anbefalt = ROWID(NORTYPE_TABLE).
                    LEAVE.            
               END.
    END.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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

  {&OPEN-QUERY-DLGCLOSE}
  GET FIRST DLGCLOSE.
  ENABLE BROWSE-1 
      WITH FRAME DLGCLOSE.
  {&OPEN-BROWSERS-IN-QUERY-DLGCLOSE}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


