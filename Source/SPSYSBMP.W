&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
/*DEFINE INPUT PARAMETER systembetParam LIKE NPSPSYST.systembetegnelse.*/
/*DEFINE INPUT PARAMETER anleggsNavnParam LIKE NPSPANLG.anlegg.        */
/*DEFINE INPUT PARAMETER varenrParam LIKE NPSPVARELISTE.varenr.        */

/* Local Variable Definitions ---                                       */
DEFINE VAR tegningBmp AS CHAR. 
DEFINE VAR tegningOK AS LOGICAL.
DEFINE VAR pointer AS LOGICAL.
def var systembetParam LIKE NPSPSYST.systembetegnelse.
def var anleggsNavnParam LIKE NPSPANLG.anlegg.
def var varenrParam LIKE NPSPVARELISTE.varenr.
def var hParent as handle no-undo.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-30 IMAGE-spiro FILL-IN_systembetegnelse ~
FILL-IN_produktnavn Btn_Lukk 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN_systembetegnelse ~
FILL-IN_produktnavn 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Lukk AUTO-GO 
     LABEL "Lukk" 
     SIZE 11.2 BY 1
     BGCOLOR 8 FONT 2.

DEFINE VARIABLE FILL-IN_produktnavn AS CHARACTER FORMAT "X(35)" 
     LABEL "Produktnavn" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 43.2 BY 1.24
     BGCOLOR 8 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN_systembetegnelse AS CHARACTER FORMAT "X(40)" 
     LABEL "System" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 47.4 BY 1.24
     BGCOLOR 8 FGCOLOR 1  NO-UNDO.

DEFINE IMAGE IMAGE-spiro
     STRETCH-TO-FIT
     SIZE 67.8 BY 16.95.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.8 BY 17.52.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     FILL-IN_systembetegnelse AT ROW 1.48 COL 21 COLON-ALIGNED
     FILL-IN_produktnavn AT ROW 2.91 COL 21 COLON-ALIGNED
     Btn_Lukk AT ROW 20.86 COL 79.2
     RECT-30 AT ROW 4.48 COL 4.6
     IMAGE-spiro AT ROW 4.76 COL 5.4
     SPACE(19.59) SKIP(0.61)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Spiroventtegning"
         DEFAULT-BUTTON Btn_Lukk.


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

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Spiroventtegning */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_produktnavn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_produktnavn Dialog-Frame
ON ENTRY OF FILL-IN_produktnavn IN FRAME Dialog-Frame /* Produktnavn */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FILL-IN_systembetegnelse
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FILL-IN_systembetegnelse Dialog-Frame
ON ENTRY OF FILL-IN_systembetegnelse IN FRAME Dialog-Frame /* System */
DO:
    RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

 FRAME {&FRAME-NAME}:TITLE = 'Spirovent til anlegg: ' + anleggsNavnParam.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   pointer = SESSION:SET-WAIT-STATE("").
  varenrparam = int(dynamic-function('getAttribute',hParent,'VareNr')).
  anleggsnavnparam = JBoxSession:Instance:getJBoxAttribute('SPAnleggsNavn').
  systembetparam = dynamic-function('getAttribute',hParent,'SystemBetegnelse').
  RUN enable_UI.
  RUN prc_visTegning.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
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
  DISPLAY FILL-IN_systembetegnelse FILL-IN_produktnavn 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-30 IMAGE-spiro FILL-IN_systembetegnelse FILL-IN_produktnavn 
         Btn_Lukk 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prc_visTegning Dialog-Frame 
PROCEDURE prc_visTegning :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /* Basert på varenr, finn produktnavn og tegningsreferanse */
    FIND FIRST NPSPVARELISTE WHERE NPSPVARELISTE.varenr = varenrParam NO-LOCK NO-WAIT NO-ERROR.
    IF  AVAIL NPSPVARELISTE THEN
        DO:
            tegningBmp = NPSPVARELISTE.tegnings_ref + ".BMP".
            FILL-IN_produktnavn = NPSPVARELISTE.produktnavn.
            /* Vis riktig tekst */
           FILL-IN_systembetegnelse = systembetParam.
           DISPLAY FILL-IN_produktnavn FILL-IN_systembetegnelse  WITH FRAME Dialog-Frame.   
        END.
    ELSE
           tegningBmp = 'admin.bmp'.

    DO WITH FRAME Dialog-Frame:
       tegningOK = IMAGE-spiro:LOAD-IMAGE (tegningBmp,0,0,330,350).
       DISPLAY IMAGE-spiro.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

