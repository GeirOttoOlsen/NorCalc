&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME ENDRE-TILLEGG
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ENDRE-TILLEGG 
/*------------------------------------------------------------------------

  File: dlgokcan.w

  Description: General use dialog box
    template witth OK, Cancel, and
    Help buttons

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 03/03/94 -  5:03 pm

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
/*DEFINE SHARED VAR Current-Tilbuds-Rec AS ROWID.     */
/*DEFINE SHARED VAR Current-Tilleggs-Rec AS ROWID.    */
/*DEFINE SHARED VAR tilbudsIdParam LIKE NPSHTILBUD.id.*/

/* Local Variable Definitions ---                                       */
def var hParent as handle no-undo.
def var nyRecord as log no-undo.
def var TilbudsIdParam like NPSHTILBUD.id.
def var current-rec as rowid no-undo.
def var current-tilbud-rec as rowid no-undo.
DEFINE VAR artikkelnrParam AS CHAR.
DEFINE VAR artikkelnvnParam AS CHAR.
DEFINE VAR kostprisParam AS DECIMAL.
DEFINE VAR pointer AS LOGICAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME ENDRE-TILLEGG

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES NPSHTILLEGG

/* Definitions for DIALOG-BOX ENDRE-TILLEGG                             */
&Scoped-define FIELDS-IN-QUERY-ENDRE-TILLEGG NPSHTILLEGG.artikkelnr ~
NPSHTILLEGG.artikkelnavn NPSHTILLEGG.kostpris NPSHTILLEGG.antall ~
NPSHTILLEGG.paaslag_faktor NPSHTILLEGG.pris 
&Scoped-define ENABLED-FIELDS-IN-QUERY-ENDRE-TILLEGG NPSHTILLEGG.artikkelnr ~
NPSHTILLEGG.antall NPSHTILLEGG.paaslag_faktor 
&Scoped-define ENABLED-TABLES-IN-QUERY-ENDRE-TILLEGG NPSHTILLEGG
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-ENDRE-TILLEGG NPSHTILLEGG
&Scoped-define QUERY-STRING-ENDRE-TILLEGG FOR EACH NPSHTILLEGG ~
      WHERE ROWID(NPSHTILLEGG) = Current-Rec SHARE-LOCK
&Scoped-define OPEN-QUERY-ENDRE-TILLEGG OPEN QUERY ENDRE-TILLEGG FOR EACH NPSHTILLEGG ~
      WHERE ROWID(NPSHTILLEGG) = Current-Rec SHARE-LOCK.
&Scoped-define TABLES-IN-QUERY-ENDRE-TILLEGG NPSHTILLEGG
&Scoped-define FIRST-TABLE-IN-QUERY-ENDRE-TILLEGG NPSHTILLEGG


/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHTILLEGG.artikkelnr NPSHTILLEGG.antall ~
NPSHTILLEGG.paaslag_faktor 
&Scoped-define ENABLED-TABLES NPSHTILLEGG
&Scoped-define FIRST-ENABLED-TABLE NPSHTILLEGG
&Scoped-Define ENABLED-OBJECTS Btn_OK Btn_Cancel Btn_Help 
&Scoped-Define DISPLAYED-FIELDS NPSHTILLEGG.artikkelnr ~
NPSHTILLEGG.artikkelnavn NPSHTILLEGG.kostpris NPSHTILLEGG.antall ~
NPSHTILLEGG.paaslag_faktor NPSHTILLEGG.pris 
&Scoped-define DISPLAYED-TABLES NPSHTILLEGG
&Scoped-define FIRST-DISPLAYED-TABLE NPSHTILLEGG


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 10 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 8.8 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK":L 
     SIZE 8.8 BY 1.14
     BGCOLOR 8 .

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 7.91.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY ENDRE-TILLEGG FOR 
      NPSHTILLEGG SCROLLING.
&ANALYZE-RESUME

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME ENDRE-TILLEGG
     NPSHTILLEGG.artikkelnr AT ROW 1.95 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 12.2 BY 1
          FONT 2
     NPSHTILLEGG.artikkelnavn AT ROW 3 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.2 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHTILLEGG.kostpris AT ROW 4.05 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.6 BY 1
          BGCOLOR 8 FGCOLOR 1 FONT 2
     NPSHTILLEGG.antall AT ROW 5.24 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 4.6 BY 1
          FONT 2
     NPSHTILLEGG.paaslag_faktor AT ROW 6.38 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8.8 BY 1
          FONT 2
     NPSHTILLEGG.pris AT ROW 7.52 COL 23.2 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.6 BY 1
          FONT 2
     Btn_OK AT ROW 10.38 COL 19.2
     Btn_Cancel AT ROW 10.38 COL 29.2
     Btn_Help AT ROW 10.38 COL 40.6
     RECT-33 AT ROW 1.24 COL 3
     SPACE(3.79) SKIP(3.41)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Endre Tillegg til Tilbud":L
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX ENDRE-TILLEGG
   FRAME-NAME UNDERLINE                                                 */
ASSIGN 
       FRAME ENDRE-TILLEGG:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPSHTILLEGG.artikkelnavn IN FRAME ENDRE-TILLEGG
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHTILLEGG.kostpris IN FRAME ENDRE-TILLEGG
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN NPSHTILLEGG.pris IN FRAME ENDRE-TILLEGG
   NO-ENABLE                                                            */
/* SETTINGS FOR RECTANGLE RECT-33 IN FRAME ENDRE-TILLEGG
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX ENDRE-TILLEGG
/* Query rebuild information for DIALOG-BOX ENDRE-TILLEGG
     _TblList          = "norcalc.NPSHTILLEGG"
     _Options          = "SHARE-LOCK"
     _Where[1]         = "ROWID(NPSHTILLEGG) = Current-Tilleggs-Rec"
     _Query            is OPENED
*/  /* DIALOG-BOX ENDRE-TILLEGG */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME NPSHTILLEGG.artikkelnavn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILLEGG.artikkelnavn ENDRE-TILLEGG
ON ENTRY OF NPSHTILLEGG.artikkelnavn IN FRAME ENDRE-TILLEGG /* Artikkelnavn */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTILLEGG.artikkelnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILLEGG.artikkelnr ENDRE-TILLEGG
ON LEAVE OF NPSHTILLEGG.artikkelnr IN FRAME ENDRE-TILLEGG /* Artikkelnr */
DO:
   FIND NPAGART WHERE NPAGART.artikkelnr = NPSHTILLEGG.Artikkelnr:SCREEN-VALUE NO-ERROR.
   IF NOT AVAILABLE(NPAGART) THEN
   DO:
       artikkelnrParam = "".
       artikkelnvnParam = "".
       RUN VELGART.W (INPUT-OUTPUT artikkelnrParam, INPUT-OUTPUT artikkelnvnParam,
           OUTPUT kostprisParam) NO-ERROR.

       IF artikkelnrParam = "" THEN
           RETURN.
       ELSE 
           DO:
                NPSHTILLEGG.artikkelnr = artikkelnrParam.
                NPSHTILLEGG.artikkelnavn = artikkelnvnParam.
                NPSHTILLEGG.kostpris = kostprisParam.
               DISPLAY 
                    NPSHTILLEGG.artikkelnr
                    NPSHTILLEGG.artikkelnavn
                    NPSHTILLEGG.kostpris 
               WITH FRAME  {&FRAME-NAME}.
/*                    APPLY "ENTRY" TO NPSHTILLEGG.antall.*/
           END.
    END.
   ELSE
   DO:
       NPSHTILLEGG.kostpris = NPAGART.kostpris.
       DISPLAY 
                NPSHTILLEGG.artikkelnavn
                NPSHTILLEGG.kostpris
       WITH FRAME  {&FRAME-NAME}.
/*           APPLY "ENTRY" TO NPSHTILLEGG.antall.*/
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help ENDRE-TILLEGG
ON CHOOSE OF Btn_Help IN FRAME ENDRE-TILLEGG /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK ENDRE-TILLEGG
ON CHOOSE OF Btn_OK IN FRAME ENDRE-TILLEGG /* OK */
DO:
    Current-Rec = ROWID(NPSHTILLEGG).
    
    /* Oppdater tilleggspris for dette tilbudet */
    DEFINE VAR c_tilleggspris AS DECIMAL INITIAL 0.
    DEFINE VAR c_pris AS DECIMAL INITIAL 0.
    DEFINE VAR c_avgittpris AS DECIMAL INITIAL 0.
    FOR EACH NPSHTILLEGG WHERE NPSHTILLEGG.id = tilbudsIdParam:
         c_tilleggspris = c_tilleggspris + NPSHTILLEGG.pris.
     END.      
     /* Tilbake til den nye record */
     FIND NPSHTILLEGG WHERE ROWID(NPSHTILLEGG) = Current-Rec.
     /* Oppdater tilbuds summer */            
     FIND NPSHTILBUD WHERE ROWID(NPSHTILBUD) = Current-Tilbud-Rec 
           EXCLUSIVE-LOCK NO-ERROR.                       
     c_pris = NPSHTILBUD.pris + c_tilleggspris.
     c_avgittpris = c_pris - ((c_pris *  NPSHTILBUD.rabatt%) / 100).            
     ASSIGN NPSHTILBUD.pris_tillegg  = c_tilleggspris
                       NPSHTILBUD.pris = c_pris
                       NPSHTILBUD.avgittpris =  c_avgittpris.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTILLEGG.kostpris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILLEGG.kostpris ENDRE-TILLEGG
ON ENTRY OF NPSHTILLEGG.kostpris IN FRAME ENDRE-TILLEGG /* Kostpris */
DO:
    RETURN NO-APPLY.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTILLEGG.paaslag_faktor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILLEGG.paaslag_faktor ENDRE-TILLEGG
ON LEAVE OF NPSHTILLEGG.paaslag_faktor IN FRAME ENDRE-TILLEGG /* Påslag */
DO:
  NPSHTILLEGG.pris = (NPSHTILLEGG.kostpris * 
      INTEGER(NPSHTILLEGG.antall:SCREEN-VALUE)) *
      DECIMAL(NPSHTILLEGG.paaslag_faktor:SCREEN-VALUE).
  DISPLAY NPSHTILLEGG.pris WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ENDRE-TILLEGG 


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
  SESSION:SET-WAIT-STATE("").   
  hParent = source-procedure.
  current-rec    = dynamic-function('getCurrentRec' in hParent).
  TilbudsIdParam = int(dynamic-function('getAttribute',hParent,'TilbudsIdParam')).
  current-tilbud-rec = to-rowid(dynamic-function('getAttribute',hParent,'current-tilbud-rec')).
  
  RUN endreTillegg.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI ENDRE-TILLEGG  _DEFAULT-DISABLE
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
  HIDE FRAME ENDRE-TILLEGG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI ENDRE-TILLEGG  _DEFAULT-ENABLE
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

  {&OPEN-QUERY-ENDRE-TILLEGG}
  GET FIRST ENDRE-TILLEGG.
  IF AVAILABLE NPSHTILLEGG THEN 
    DISPLAY NPSHTILLEGG.artikkelnr NPSHTILLEGG.artikkelnavn NPSHTILLEGG.kostpris 
          NPSHTILLEGG.antall NPSHTILLEGG.paaslag_faktor NPSHTILLEGG.pris 
      WITH FRAME ENDRE-TILLEGG.
  ENABLE NPSHTILLEGG.artikkelnr NPSHTILLEGG.antall NPSHTILLEGG.paaslag_faktor 
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME ENDRE-TILLEGG.
  {&OPEN-BROWSERS-IN-QUERY-ENDRE-TILLEGG}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE endreTillegg ENDRE-TILLEGG 
PROCEDURE endreTillegg :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
FIND NPSHTILLEGG WHERE ROWID(NPSHTILLEGG) = Current-Rec EXCLUSIVE-LOCK
    NO-WAIT NO-ERROR.
IF AVAILABLE NPSHTILLEGG THEN
    UPDATE
        norcalc.NPSHTILLEGG.artikkelnr norcalc.NPSHTILLEGG.artikkelnavn 
        norcalc.NPSHTILLEGG.kostpris norcalc.NPSHTILLEGG.antall 
        norcalc.NPSHTILLEGG.paaslag_faktor norcalc.NPSHTILLEGG.pris 
       Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME ENDRE-TILLEGG.
ELSE
    DO:
        MESSAGE 'Tabellen er opptatt. Prøv senere.' VIEW-AS ALERT-BOX TITLE 'STOPP'.
        RETURN.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

