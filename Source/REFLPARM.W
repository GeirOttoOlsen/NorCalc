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
DEFINE INPUT-OUTPUT PARAMETER cAnleggsnavn  AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER cProdukttype  AS CHAR.
DEFINE INPUT-OUTPUT PARAMETER iDistrikt  AS int.
DEFINE INPUT-OUTPUT PARAMETER dFraDato AS DATE.
DEFINE INPUT-OUTPUT PARAMETER dTilDato AS DATE.
DEFINE INPUT-OUTPUT PARAMETER iReturVerdi AS INTEGER.
DEFINE INPUT-OUTPUT PARAMETER visPris AS INTEGER.

/* Local Variable Definitions ---                                       */
DEFINE VAR temp-string AS CHAR.
DEFINE VAR i AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-32 FILL-IN-anleggsnavn ~
COMBO-BOX_produkttype COMBO-BOX_distrikt FILL-IN-fra-dato FILL-IN-til-dato ~
TOGGLE-vispris Btn_OK Btn_Cancel 
&Scoped-Define DISPLAYED-OBJECTS FILL-IN-anleggsnavn COMBO-BOX_produkttype ~
COMBO-BOX_distrikt FILL-IN-fra-dato FILL-IN-til-dato TOGGLE-vispris 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON Btn_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 11.8 BY 1.1
     BGCOLOR 8 .

DEFINE BUTTON Btn_OK AUTO-GO 
     LABEL "OK" 
     SIZE 8 BY 1.1
     BGCOLOR 8 .

DEFINE VARIABLE COMBO-BOX_distrikt AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Distrikt" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "",1
     DROP-DOWN-LIST
     SIZE 34.4 BY 1.05
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE VARIABLE COMBO-BOX_produkttype AS CHARACTER FORMAT "X(3)" 
     LABEL "Produkttype" 
     VIEW-AS COMBO-BOX 
     LIST-ITEMS "FM","MS" 
     DROP-DOWN-LIST
     SIZE 13.6 BY 1
     BGCOLOR 2 FGCOLOR 1 FONT 2.

DEFINE VARIABLE FILL-IN-anleggsnavn AS CHARACTER FORMAT "X(30)" 
     LABEL "Anlegg" 
     VIEW-AS FILL-IN NATIVE 
     SIZE 38.6 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-fra-dato AS DATE FORMAT "99.99.9999":U 
     LABEL "Lev. dato f.o.m." 
     VIEW-AS FILL-IN NATIVE 
     SIZE 16.4 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE VARIABLE FILL-IN-til-dato AS DATE FORMAT "99.99.9999":U 
     LABEL "t.o.m." 
     VIEW-AS FILL-IN NATIVE 
     SIZE 15.6 BY 1
     BGCOLOR 2 FGCOLOR 1  NO-UNDO.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 65.8 BY 6.24.

DEFINE VARIABLE TOGGLE-vispris AS LOGICAL INITIAL no 
     LABEL "Vis pris" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.4 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     FILL-IN-anleggsnavn AT ROW 1.62 COL 20.6 COLON-ALIGNED
     COMBO-BOX_produkttype AT ROW 2.76 COL 20.6 COLON-ALIGNED
     COMBO-BOX_distrikt AT ROW 3.95 COL 20.6 COLON-ALIGNED
     FILL-IN-fra-dato AT ROW 5.05 COL 27 COLON-ALIGNED
     FILL-IN-til-dato AT ROW 5.05 COL 48.6 COLON-ALIGNED
     TOGGLE-vispris AT ROW 6.29 COL 22.6
     Btn_OK AT ROW 8.24 COL 26
     Btn_Cancel AT ROW 8.24 COL 34.4
     RECT-32 AT ROW 1.33 COL 2
     SPACE(0.99) SKIP(2.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 2
         TITLE "Utskrift av Referanselister"
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
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE
       FRAME Dialog-Frame:PRIVATE-DATA     = 
                "DLGCLOSE".

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Utskrift av Referanselister */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Btn_OK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Btn_OK Dialog-Frame
ON CHOOSE OF Btn_OK IN FRAME Dialog-Frame /* OK */
DO:
  /* Legg verdier i variabler */
  ASSIGN
      cAnleggsnavn = FILL-IN-anleggsnavn:SCREEN-VALUE
      cProdukttype = COMBO-BOX_produkttype:SCREEN-VALUE
      iDistrikt = int(COMBO-BOX_distrikt:SCREEN-VALUE)
      dFraDato = DATE(FILL-IN-fra-dato:SCREEN-VALUE)
      dTilDato = DATE(FILL-IN-til-dato:SCREEN-VALUE)
      iReturVerdi = 1.
   IF TOGGLE-vispris:CHECKED = TRUE THEN
        visPris = 1.
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
  RUN enable_UI.
  assign 
    COMBO-BOX_distrikt:DELIMITER       = '|'
    COMBO-BOX_distrikt:LIST-ITEM-PAIRS = JBoxServerAPI:Instance:FieldList("NPkundedistrikt;Kundedistriktnr|KundeDistriktNavn;KundeDistriktNr","WHERE true" + ' BY KundedistriktNr')
  .
  MESSAGE COMBO-BOX_distrikt:LIST-ITEM-PAIRS
  VIEW-AS ALERT-BOX.
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
  DISPLAY FILL-IN-anleggsnavn COMBO-BOX_produkttype COMBO-BOX_distrikt 
          FILL-IN-fra-dato FILL-IN-til-dato TOGGLE-vispris 
      WITH FRAME Dialog-Frame.
  ENABLE RECT-32 FILL-IN-anleggsnavn COMBO-BOX_produkttype COMBO-BOX_distrikt 
         FILL-IN-fra-dato FILL-IN-til-dato TOGGLE-vispris Btn_OK Btn_Cancel 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

