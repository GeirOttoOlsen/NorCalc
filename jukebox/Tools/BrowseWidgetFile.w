&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/*------------------------------------------------------------------------

  File: 

  Description:        Container for a JukeBox window program

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author:            brynjar@chemistry.no

  Created:           18.oct.2006

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&IF "{1}" = "Developer_Studio_is_Running" &THEN
  &SCOPED-DEFINE UIB_is_Running 1 
&ENDIF   
/* Uncomment to enable use of .Net components: */
/* &SCOPED-DEFINE AdvGuiWin */ 

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

DEF VAR bOk         AS LOG    NO-UNDO.
DEF VAR ix          AS INT    NO-UNDO.
DEF VAR oBrowse     AS JBoxBrowse NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

DEF TEMP-TABLE ttWidget
    FIELD LEVEL_ AS INT 
    FIELD TYPE_ AS  CHAR FORMAT "x(12)"
    FIELD NAME_ AS  CHAR FORMAT "x(30)"
    FIELD FRAME_ AS CHAR
    FIELD X_ AS     INT
    FIELD AbsX_ AS  INT
    FIELD Y_ AS     INT
    FIELD AbsY_ AS  INT
    FIELD WIDTH-PIXELS_ AS INT
    FIELD HEIGHT-PIXELS_ AS INT
    FIELD TAB-POSITION_ AS INT
    FIELD VISIBLE_ AS CHAR
    FIELD VIRTUAL-WIDTH-PIXELS_ AS INT
    FIELD VIRTUAL-HEIGHT-PIXELS_ AS INT
    FIELD SCROLLABLE_ AS CHAR
    FIELD PARENT_ AS CHAR
    FIELD HANDLE_ AS CHAR
    FIELD PROCEDURE_ AS CHAR FORMAT "x(60)"
    FIELD LABEL_ AS CHAR FORMAT "x(30)"
    .


DEF VAR otbWidget AS JBoxToolbar NO-UNDO.


DEF VAR opopupWidget AS JBoxPopupMenu NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brwWidget tbWidget searchoBrowse ~
filter_tbWidget browseconfig_tbWidget excel_tbWidget 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON browseconfig_tbWidget 
     IMAGE-UP FILE "bmp/table.bmp":U
     LABEL "Column setup" 
     SIZE 4.57 BY 1.12 TOOLTIP "Column setup (ALT-C)".

DEFINE BUTTON excel_tbWidget 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 4.57 BY 1.12 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE BUTTON filter_tbWidget 
     IMAGE-UP FILE "gif/filter.gif":U
     LABEL "Filter" 
     SIZE 4.57 BY 1.12 TOOLTIP "Filter (CTRL-F)".

DEFINE RECTANGLE brwWidget
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61.86 BY 9.42.

DEFINE RECTANGLE searchoBrowse
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 12 BY .77.

DEFINE RECTANGLE tbWidget
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 48 BY 1.31.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     filter_tbWidget AT ROW 1.27 COL 15.14 WIDGET-ID 6
     browseconfig_tbWidget AT ROW 1.27 COL 19.86 WIDGET-ID 12
     excel_tbWidget AT ROW 1.27 COL 24.43 WIDGET-ID 8
     brwWidget AT ROW 2.62 COL 1.72 WIDGET-ID 2
     tbWidget AT ROW 1.15 COL 15 WIDGET-ID 4
     searchoBrowse AT ROW 1.38 COL 2 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 62.86 BY 11.38 WIDGET-ID 100.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Widget list"
         HEIGHT             = 11.35
         WIDTH              = 63.43
         MAX-HEIGHT         = 23.54
         MAX-WIDTH          = 114.14
         VIRTUAL-HEIGHT     = 23.54
         VIRTUAL-WIDTH      = 114.14
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB C-Win 
/* ************************* Included-Libraries *********************** */
&IF "{&WINDOW-SYSTEM}" EQ "TTY" &THEN
  IF C-Win = ? THEN
    CREATE FRAME C-Win
           ASSIGN HIDDEN = YES.
&ENDIF

{incl/devmode.i}
{incl/custdevmode.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   FRAME-NAME                                                           */
ASSIGN 
       FRAME DEFAULT-FRAME:HEIGHT           = 11.38
       FRAME DEFAULT-FRAME:WIDTH            = 62.8.

ASSIGN 
       searchoBrowse:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "multiSortBrowse;Sorter på flere kolonner,ApplyChoose;Apply choose,ApplyValueChanged;Apply value-changed".

ASSIGN 
       tbWidget:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "filter;Filter,browseconfig;Column setup,excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Widget list */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Widget list */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
&ENDIF

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  RUN disable_UI.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
{incl/wintrigg.i}
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */
&ENDIF

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  &IF DEFINED(UIB_is_Running) NE 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
  &ENDIF

  IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
    &IF DEFINED(UIB_is_Running) = 0 &THEN
    RUN InitializeObject.
    RUN MoveToTop.
    APPLY "WINDOW-RESIZED" TO {&WINDOW-NAME}.
    SESSION:SET-WAIT-STATE("").
    IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
      RUN WaitForForm NO-ERROR.
    ELSE 
    &ENDIF
      WAIT-FOR CLOSE OF THIS-PROCEDURE.
  END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ApplyChooseRecord C-Win 
PROCEDURE ApplyChooseRecord :
DEF VAR hWidget AS HANDLE NO-UNDO.
DEF VAR bOk     AS LOG    NO-UNDO.

hWidget = WIDGET-HANDLE(ttWidget.HANDLE_) NO-ERROR.
IF VALID-HANDLE(hWidget) THEN DO:
  MESSAGE "Apply CHOOSE to " hWidget:NAME
  VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE bOK.
  IF bOK THEN
    APPLY "CHOOSE" TO hWidget.
END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ApplyValueChangedRecord C-Win 
PROCEDURE ApplyValueChangedRecord :
DEF VAR hWidget AS HANDLE NO-UNDO.
DEF VAR bOk     AS LOG    NO-UNDO.

hWidget = WIDGET-HANDLE(ttWidget.HANDLE_) NO-ERROR.
IF VALID-HANDLE(hWidget) THEN DO:
  MESSAGE "Apply VALUE-CHANGED to " hWidget:NAME
  VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL UPDATE bOK.
  IF bOK THEN
    APPLY "value-changed" TO hWidget.
END.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
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
  ENABLE brwWidget tbWidget searchoBrowse filter_tbWidget browseconfig_tbWidget 
         excel_tbWidget 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InitializeObject C-Win 
PROCEDURE InitializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Refer to the <jukebox>\winsrc\samples for working examples for Sports2000
------------------------------------------------------------------------------*/
&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  RUN enable_UI.

  oContainer = NEW JBoxContainer().
  oContainer:addStatusBar().
&ENDIF

DO WITH FRAME {&FRAME-NAME}:

  oBrowse = NEW JBoxBrowse(brwWidget:HANDLE,      /* handle to place-holder rectangle */
                           YES,                       /* multiple-select? */
                           "",                        /* title */
                           NO,                        /* row-markers (if multiple) */
                           BUFFER ttWidget:HANDLE). /* The BUFFER ttCust.. parameter tells the browse that it is a local temp-table */

/*  oBrowse:buffersAndFields = "ttCustomer;name;custNum". /* Visible fields - optional setting */*/
  otbWidget = NEW JBoxToolbar(tbWidget:HANDLE).

  oBrowse:TOOLBAR-OBJECT = otbWidget.
  oBrowse:setSearchField(searchoBrowse:HANDLE,"level_").
  opopupWidget = NEW JBoxPopupMenu().
  opopupWidget:AddToolGroup("multiSortBrowse;Sort on multiple columns"
                          + ",CopyBrowseRows;Copy rows to clipboard"
                          + ",ApplyChoose;Apply choose"
                          + ",ApplyValueChanged;Apply value-changed"
                          + ",setBgColor;Set BG color"
                          + ",setHIDDEN;Set HIDDEN"
                            ).

  oBrowse:POPUP-MENU-OBJECT = opopupWidget.
END.

&IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
  oContainer:initResize().
&ELSE
  DYNAMIC-FUNCTION("setASlibBehaviour",
                    "QueryLogFile|ServerQuery.log," +   
                    "TransLogFile|ServerTrans.log").
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MoveToTop C-Win 
PROCEDURE MoveToTop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
THIS-PROCEDURE:CURRENT-WINDOW:HIDDEN = NO.
IF DYNAMIC-FUNCTION("getAttribute",THIS-PROCEDURE,"advGuiWin") = "YES" THEN
  RUN ShowForm("").
THIS-PROCEDURE:CURRENT-WINDOW:WINDOW-STATE = 3.
THIS-PROCEDURE:CURRENT-WINDOW:MOVE-TO-TOP().
DYNAMIC-FUNCTION("DoLockWindow",?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBgColorRecord C-Win 
PROCEDURE setBgColorRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hWidget AS HANDLE NO-UNDO.

hWidget = WIDGET-HANDLE(ttWidget.HANDLE_) NO-ERROR.
IF VALID-HANDLE(hWidget) AND CAN-QUERY(hWidget,"BGCOLOR") THEN DO:
  JBoxSession:Instance:PromptForValue("BGCOLOR number", "INTEGER").
  IF JBoxSession:Instance:PromptValueOk THEN
    hWidget:BGCOLOR = INT(JBoxSession:Instance:PromptValue).
END.
ELSE IF VALID-HANDLE(hWidget) THEN 
  MESSAGE "BGCOLOR attr not supported for " hWidget:TYPE
          VIEW-AS ALERT-BOX.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFile C-Win 
PROCEDURE setFile :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icFileName AS CHAR NO-UNDO.

DEF VAR hWidget AS HANDLE NO-UNDO.
INPUT FROM VALUE(icFileName).
SET ^.
REPEAT:
  CREATE ttWidget.
  IMPORT DELIMITER ";" ttWidget.
END.
INPUT CLOSE.

FOR EACH ttWidget:
  hWidget = WIDGET-HANDLE(ttWidget.HANDLE_) NO-ERROR.
  IF VALID-HANDLE(hWidget) AND CAN-QUERY(hWidget,"LABEL") THEN
    ttWidget.LABEL_ = hWidget:LABEL.
END.    
  
oBrowse:openQuery().



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setHIDDENrecord C-Win 
PROCEDURE setHIDDENrecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR hWidget AS HANDLE NO-UNDO.

hWidget = WIDGET-HANDLE(ttWidget.HANDLE_) NO-ERROR.
IF VALID-HANDLE(hWidget) AND CAN-QUERY(hWidget,"HIDDEN") THEN DO:
  JBoxSession:Instance:PromptForValue("Set HIDDEN", "LOGICAL").
  IF JBoxSession:Instance:PromptValueOk THEN
    hWidget:HIDDEN = LOGICAL(JBoxSession:Instance:PromptValue).
END.
ELSE IF VALID-HANDLE(hWidget) THEN 
  MESSAGE "HIDDEN attr not supported for " hWidget:TYPE
          VIEW-AS ALERT-BOX.    


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

