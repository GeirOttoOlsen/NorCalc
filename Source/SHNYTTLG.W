&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          norcalc          PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME NYTT-TILLEGG
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS NYTT-TILLEGG 
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
/*DEFINE SHARED VAR nyRecord AS LOGICAL.              */
/*DEFINE SHARED VAR tilbudsIdParam LIKE NPSHTILBUD.id.*/

/* Local Variable Definitions ---                                       */
def var hParent as handle no-undo.
def var current-rec as rowid no-undo.
def var nyRecord as log no-undo.
def var TilbudsIdParam like NPSHTilbud.id.
def var current-tilbud-rec as rowid no-undo.

DEFINE VAR iNextTilleggsnr AS INTEGER.
DEFINE VAR artikkelnrParam AS CHAR.
DEFINE VAR artikkelnvnParam AS CHAR.
DEFINE VAR kostprisParam AS DECIMAL.
DEFINE VAR rabattParam AS DECIMAL.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME NYTT-TILLEGG

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS NPSHTILLEGG.antall NPSHTILLEGG.paaslag_faktor 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}antall ~{&FP2}antall ~{&FP3}~
 ~{&FP1}paaslag_faktor ~{&FP2}paaslag_faktor ~{&FP3}
&Scoped-define ENABLED-TABLES NPSHTILLEGG
&Scoped-define FIRST-ENABLED-TABLE NPSHTILLEGG
&Scoped-Define ENABLED-OBJECTS FILL-IN_artikkelnr Btn_OK Btn_Cancel ~
Btn_Help 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 12.32 BY 1.41
     BGCOLOR 8 .

DEFINE BUTTON Btn_Help 
     LABEL "&Help":L 
     SIZE 12.32 BY 1.41
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK":L 
     SIZE 12.32 BY 1.41
     BGCOLOR 8 .

DEFINE VARIABLE FILL-IN_artikkelnavn AS CHARACTER FORMAT "X(8)" 
     LABEL "Artikkelnavn" 
     VIEW-AS FILL-IN 
     SIZE 43.68 BY 1.24
     BGCOLOR 8 FGCOLOR 1 FONT 2.

DEFINE VARIABLE FILL-IN_artikkelnr AS CHARACTER FORMAT "X(8)" 
     LABEL "Artikkelnr" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 17.08 BY 1.24
     FONT 2.

DEFINE VARIABLE FILL-IN_kostpris AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Kostpris" 
     VIEW-AS FILL-IN 
     SIZE 17.64 BY 1.24
     BGCOLOR 8 FGCOLOR 1 FONT 2.

DEFINE RECTANGLE RECT-33
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69.44 BY 9.79.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME NYTT-TILLEGG
     FILL-IN_artikkelnr AT ROW 1.94 COL 23.92 COLON-ALIGNED
     FILL-IN_artikkelnavn AT ROW 3.36 COL 23.92 COLON-ALIGNED
     FILL-IN_kostpris AT ROW 4.84 COL 23.92 COLON-ALIGNED
     NPSHTILLEGG.antall AT ROW 6.31 COL 23.92 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 6.44 BY 1.24
          FONT 2
     NPSHTILLEGG.paaslag_faktor AT ROW 7.72 COL 23.92 COLON-ALIGNED
          VIEW-AS FILL-IN NATIVE 
          SIZE 8.12 BY 1.24
          FONT 2
     NPSHTILLEGG.pris AT ROW 9.13 COL 23.92 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.64 BY 1.24
          FONT 2
     Btn_OK AT ROW 12.74 COL 20.88
     Btn_Cancel AT ROW 12.74 COL 34.32
     Btn_Help AT ROW 12.74 COL 48.04
     RECT-33 AT ROW 1.41 COL 4.92
     SPACE(3.83) SKIP(3.98)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS THREE-D  SCROLLABLE 
         FONT 2
         TITLE BGCOLOR 8 "Nytt Tillegg til Tilbud":L
         DEFAULT-BUTTON Btn_OK CANCEL-BUTTON Btn_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX NYTT-TILLEGG
   UNDERLINE                                                            */
ASSIGN 
       FRAME NYTT-TILLEGG:SCROLLABLE       = FALSE.

/* SETTINGS FOR FILL-IN NPSHTILLEGG.antall IN FRAME NYTT-TILLEGG
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN FILL-IN_artikkelnavn IN FRAME NYTT-TILLEGG
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN_artikkelnr IN FRAME NYTT-TILLEGG
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN FILL-IN_kostpris IN FRAME NYTT-TILLEGG
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN NPSHTILLEGG.paaslag_faktor IN FRAME NYTT-TILLEGG
   NO-DISPLAY                                                           */
/* SETTINGS FOR FILL-IN NPSHTILLEGG.pris IN FRAME NYTT-TILLEGG
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR RECTANGLE RECT-33 IN FRAME NYTT-TILLEGG
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX NYTT-TILLEGG
/* Query rebuild information for DIALOG-BOX NYTT-TILLEGG
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX NYTT-TILLEGG */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Btn_Help
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_Help NYTT-TILLEGG
ON CHOOSE OF Btn_Help IN FRAME NYTT-TILLEGG /* Help */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  /* Call Help Function (or a simple message). */
  MESSAGE "Help for File: {&FILE-NAME}" VIEW-AS ALERT-BOX INFORMATION.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK NYTT-TILLEGG
ON CHOOSE OF Btn_OK IN FRAME NYTT-TILLEGG /* OK */
DO:
    Current-Rec = ROWID(NPSHTILLEGG).
     nyRecord = TRUE.

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


&Scoped-define SELF-NAME FILL-IN_artikkelnavn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_artikkelnavn NYTT-TILLEGG
ON ENTRY OF FILL-IN_artikkelnavn IN FRAME NYTT-TILLEGG /* Artikkelnavn */
DO:
    RETURN NO-APPLY.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_artikkelnr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_artikkelnr NYTT-TILLEGG
ON LEAVE OF FILL-IN_artikkelnr IN FRAME NYTT-TILLEGG /* Artikkelnr */
DO:
   FIND NPAGART WHERE NPAGART.artikkelnr = FILL-IN_Artikkelnr:SCREEN-VALUE NO-ERROR.
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
                    FILL-IN_Artikkelnavn = artikkelnvnParam.
                    FILL-IN_Artikkelnr = artikkelnrParam.
                    FILL-IN_Kostpris = kostprisParam.
                    NPSHTILLEGG.artikkelnr = artikkelnrParam.
                    NPSHTILLEGG.artikkelnavn = artikkelnvnParam.
                    NPSHTILLEGG.kostpris = kostprisParam.
                   DISPLAY FILL-IN_Artikkelnr FILL-IN_Artikkelnavn FILL-IN_Kostpris
                   WITH FRAME  {&FRAME-NAME}.
/*                    APPLY "ENTRY" TO NPSHTILLEGG.antall.*/
               END.
        END.
   ELSE
       DO:
           FILL-IN_Artikkelnavn = artikkelnvnParam.
           FILL-IN_Kostpris = kostprisParam.
           NPSHTILLEGG.kostpris = kostprisParam.
           DISPLAY FILL-IN_Artikkelnavn FILL-IN_Kostpris
           WITH FRAME  {&FRAME-NAME}.
/*           APPLY "ENTRY" TO NPSHTILLEGG.antall.*/
       END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_kostpris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_kostpris NYTT-TILLEGG
ON ENTRY OF FILL-IN_kostpris IN FRAME NYTT-TILLEGG /* Kostpris */
DO:
    RETURN NO-APPLY.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME NPSHTILLEGG.paaslag_faktor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL NPSHTILLEGG.paaslag_faktor NYTT-TILLEGG
ON LEAVE OF NPSHTILLEGG.paaslag_faktor IN FRAME NYTT-TILLEGG /* Påslag */
DO:
  NPSHTILLEGG.pris = (NPSHTILLEGG.kostpris * 
      INTEGER(NPSHTILLEGG.antall:SCREEN-VALUE)) *
      DECIMAL(NPSHTILLEGG.paaslag_faktor:SCREEN-VALUE).
  DISPLAY NPSHTILLEGG.pris WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK NYTT-TILLEGG 


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
  current-rec = dynamic-function('getCurrentRec' in hParent).
  nyRecord    = logical(dynamic-function('getNyRecord' in hParent)).
  tilbudsidparam = int(dynamic-function('getAttribute',hParent,'TilbudsIdParam')).
  current-tilbud-rec = to-rowid(dynamic-function('getAttribute',hParent,'current-tilbud-rec')).
  RUN nyttTillegg.

END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI NYTT-TILLEGG _DEFAULT-DISABLE
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
  HIDE FRAME NYTT-TILLEGG.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI NYTT-TILLEGG _DEFAULT-ENABLE
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
  ENABLE FILL-IN_artikkelnr NPSHTILLEGG.antall NPSHTILLEGG.paaslag_faktor 
         Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME NYTT-TILLEGG.
  {&OPEN-BROWSERS-IN-QUERY-NYTT-TILLEGG}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nyttTillegg NYTT-TILLEGG 
PROCEDURE nyttTillegg :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/     
     create npshtillegg.
     NPSHTILLEGG.id = tilbudsIdParam.

 UPDATE 
    FILL-IN_Artikkelnr NPSHTILLEGG.antall NPSHTILLEGG.paaslag_faktor 
    NPSHTILLEGG.pris
        Btn_OK Btn_Cancel Btn_Help 
      WITH FRAME NYTT-TILLEGG.
  dynamic-function('setCurrentRec' in hParent, rowid(npshtillegg)).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


