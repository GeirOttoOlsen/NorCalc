&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
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
/*          This .W file was created with the Progress AppBuilder.       */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{utilities/concat/pdftk.i "SHARED"}

/* Parameters Definitions ---                                           */

DEFINE INPUT  PARAMETER phCaller   AS HANDLE    NO-UNDO.
DEFINE OUTPUT PARAMETER plModified AS LOGICAL   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Dialog-Box
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiFileName btnOK fiPageCount btnCancel ~
fiPagesToCopy fiPagesTitles coRotateInPage coPageRotate 
&Scoped-Define DISPLAYED-OBJECTS fiFileName fiPageCount fiPagesToCopy ~
fiPagesTitles coRotateInPage coPageRotate 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD PagesToCopy_is_valid Dialog-Frame 
FUNCTION PagesToCopy_is_valid RETURNS LOGICAL
  ( piPages AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnCancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE BUTTON btnOK AUTO-GO 
     LABEL "OK" 
     SIZE 15 BY 1.14
     BGCOLOR 8 .

DEFINE VARIABLE coPageRotate AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Page rotate" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "         0","        90","       180","       270" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE coRotateInPage AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Rotate in page" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     LIST-ITEMS "         0","        90","       180","       270" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fiFileName AS CHARACTER FORMAT "X(256)":U 
     LABEL "File" 
     VIEW-AS FILL-IN 
     SIZE 86 BY 1 NO-UNDO.

DEFINE VARIABLE fiPageCount AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Page count" 
     VIEW-AS FILL-IN 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fiPagesTitles AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pages titles" 
     VIEW-AS FILL-IN 
     SIZE 86 BY 1 TOOLTIP "Title(s) for the pages to be added in the header." NO-UNDO.

DEFINE VARIABLE fiPagesToCopy AS CHARACTER FORMAT "X(256)":U 
     LABEL "Pages to copy" 
     VIEW-AS FILL-IN 
     SIZE 86 BY 1 TOOLTIP "Page ranges separated by ~",~". E.g. -4,6,8,10-12,16-" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     fiFileName AT ROW 1.48 COL 20 COLON-ALIGNED WIDGET-ID 4 NO-TAB-STOP 
     btnOK AT ROW 1.48 COL 114
     fiPageCount AT ROW 2.67 COL 20 COLON-ALIGNED WIDGET-ID 6 NO-TAB-STOP 
     btnCancel AT ROW 2.71 COL 114
     fiPagesToCopy AT ROW 4.57 COL 20 COLON-ALIGNED WIDGET-ID 8
     fiPagesTitles AT ROW 5.76 COL 20 COLON-ALIGNED WIDGET-ID 18
     coRotateInPage AT ROW 6.95 COL 20 COLON-ALIGNED WIDGET-ID 12
     coPageRotate AT ROW 8.14 COL 20 COLON-ALIGNED WIDGET-ID 10
     "Rotates all the page, including header, footer, watermark..." VIEW-AS TEXT
          SIZE 89 BY .62 AT ROW 8.38 COL 39 WIDGET-ID 14
     "Rotates only the source pdf file in the page" VIEW-AS TEXT
          SIZE 89 BY .62 AT ROW 7.19 COL 39 WIDGET-ID 16
     "~; separated" VIEW-AS TEXT
          SIZE 19 BY .62 AT ROW 6 COL 109 WIDGET-ID 20
     SPACE(2.59) SKIP(2.71)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "File properties"
         DEFAULT-BUTTON btnOK CANCEL-BUTTON btnCancel WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Dialog-Box
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME                                                           */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       fiFileName:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

ASSIGN 
       fiPageCount:READ-ONLY IN FRAME Dialog-Frame        = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* File properties */
DO:
    plModified = NO.
    APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnCancel Dialog-Frame
ON CHOOSE OF btnCancel IN FRAME Dialog-Frame /* Cancel */
DO:
    plModified = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnOK Dialog-Frame
ON CHOOSE OF btnOK IN FRAME Dialog-Frame /* OK */
DO:
    IF NOT PagesToCopy_is_valid(fiPageCount) THEN DO:
        /* fiPagesToCopy:FGCOLOR = 12. */
        fiPagesToCopy:BGCOLOR = 14.
        APPLY "ENTRY" TO fiPagesToCopy.
        RETURN NO-APPLY.
    END.

    ASSIGN fiPagesToCopy fiPagesTitles coRotateInPage coPageRotate.

    ASSIGN
        ttPdfFiles.pages_to_copy = fiPagesToCopy
        ttPdfFiles.pageRotate    = coPageRotate
        ttPdfFiles.rotateInPage  = coRotateInPage
        ttPdfFiles.pageTitle     = fiPagesTitles.

    plModified = YES.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiPagesToCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiPagesToCopy Dialog-Frame
ON ANY-KEY OF fiPagesToCopy IN FRAME Dialog-Frame /* Pages to copy */
DO:
    /* fiFileName:SCREEN-VALUE = KEYLABEL(LASTKEY). */
    /* limit field content to 0-9 - or , */
    IF NOT (   LASTKEY = KEYCODE(",")
            OR LASTKEY = KEYCODE("-")
            OR LASTKEY = KEYCODE("0")
            OR LASTKEY = KEYCODE("1")
            OR LASTKEY = KEYCODE("2")
            OR LASTKEY = KEYCODE("3")
            OR LASTKEY = KEYCODE("4")
            OR LASTKEY = KEYCODE("5")
            OR LASTKEY = KEYCODE("6")
            OR LASTKEY = KEYCODE("7")
            OR LASTKEY = KEYCODE("8")
            OR LASTKEY = KEYCODE("9")
            OR LASTKEY = KEYCODE("CURSOR-LEFT")
            OR LASTKEY = KEYCODE("CURSOR-RIGHT")
            OR LASTKEY = KEYCODE("SHIFT-CURSOR-LEFT")
            OR LASTKEY = KEYCODE("SHIFT-CURSOR-RIGHT")
            OR LASTKEY = KEYCODE("BACKSPACE")
            OR LASTKEY = KEYCODE("DEL")
            OR LASTKEY = KEYCODE("ENTER")
            OR LASTKEY = KEYCODE("GO")
            OR LASTKEY = KEYCODE("HOME")
            OR LASTKEY = KEYCODE("END")
            OR LASTKEY = KEYCODE("SHIFT-HOME")
            OR LASTKEY = KEYCODE("SHIFT-END")
            OR LASTKEY = KEYCODE("TAB")
           ) THEN
        RETURN NO-APPLY.

    IF (   LASTKEY = KEYCODE("CURSOR-LEFT")
        OR LASTKEY = KEYCODE("CURSOR-RIGHT")
       ) THEN
        APPLY KEYLABEL(LASTKEY) TO SELF.

    IF LASTKEY = KEYCODE("SHIFT-CURSOR-LEFT") THEN
        APPLY "CURSOR-LEFT" TO SELF.
    IF LASTKEY = KEYCODE("SHIFT-CURSOR-RIGHT") THEN
        APPLY "CURSOR-RIGHT" TO SELF.
    IF LASTKEY = KEYCODE("SHIFT-HOME") THEN
        APPLY "HOME" TO SELF.
    IF LASTKEY = KEYCODE("SHIFT-END") THEN
        APPLY "END" TO SELF.
           
    IF LASTKEY = KEYCODE("ENTER") THEN
        APPLY "CHOOSE" TO btnOK.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

/* Get the current ttPdfFiles buffer */
RUN getCurrentRecord IN phCaller (BUFFER ttPdfFiles).

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN initialize.
    RUN enable_UI.
    fiPagesTitles:TOOLTIP = "Title(s) for the pages to be added in the header, separated by ~";~".~nIf there are less titles than pages, then the last one will be use for all subsequent pages.~nIn particular, if there is only one then it will be used for all pages.".
    fiPagesToCopy:TOOLTIP = "Page ranges separated by ~",~". E.g. -4,6,8,10-12,16-~nThis means: pages up to 4, then page 6, page 8, pages 10 to 12, then all pages starting at 16.".
    APPLY "ENTRY" TO fiPagesToCopy IN FRAME {&FRAME-NAME}.
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
  DISPLAY fiFileName fiPageCount fiPagesToCopy fiPagesTitles coRotateInPage 
          coPageRotate 
      WITH FRAME Dialog-Frame.
  ENABLE fiFileName btnOK fiPageCount btnCancel fiPagesToCopy fiPagesTitles 
         coRotateInPage coPageRotate 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize Dialog-Frame 
PROCEDURE initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN
    fiFileName     = ttPdfFiles.file_name
    fiPageCount    = ttPdfFiles.page_count
    fiPagesToCopy  = ttPdfFiles.pages_to_copy
    coPageRotate   = ttPdfFiles.pageRotate
    coRotateInPage = ttPdfFiles.rotateInPage
    fiPagesTitles  = ttPdfFiles.pageTitle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION PagesToCopy_is_valid Dialog-Frame 
FUNCTION PagesToCopy_is_valid RETURNS LOGICAL
  ( piPages AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  validate fiPagesToCopy
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE cEntry AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i      AS INTEGER     NO-UNDO.
DEFINE VARIABLE iFrom  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iTo    AS INTEGER     NO-UNDO.


DO WITH FRAME {&FRAME-NAME}:
    ASSIGN fiPagesToCopy.
END.

/* validate pages to copy */
IF fiPagesToCopy = "" THEN RETURN FALSE.
DO i = NUM-ENTRIES(fiPagesToCopy) TO 1 BY -1:
    cEntry = ENTRY(i, fiPagesToCopy).
    IF cEntry = "" THEN RETURN FALSE.
    IF NUM-ENTRIES(cEntry, "-") > 2 THEN RETURN FALSE.
    iFrom = IF ENTRY(1, cEntry, "-") = "" THEN 1 ELSE INTEGER(ENTRY(1, cEntry, "-")).
    iTo = IF NUM-ENTRIES(cEntry, "-") = 2
          THEN (IF ENTRY(2, cEntry, "-") = "" THEN ttPdfFiles.page_count ELSE INTEGER(ENTRY(2, cEntry, "-")))
          ELSE iFrom.
    IF iFrom > piPages OR iTo > piPages OR iFrom > iTo THEN RETURN FALSE.
END.

RETURN TRUE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

