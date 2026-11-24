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
DEF VAR hBrowse     AS HANDLE NO-UNDO. /* placeholder */
DEF VAR hBuffer     AS HANDLE NO-UNDO.
DEF VAR hBrwOther   AS HANDLE NO-UNDO.
DEF VAR hBuffOther  AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btnSplitBarY brwField brwOther searchField ~
rectToolbar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btnSplitBarY 
     IMAGE-UP FILE "bmp/tabup.bmp":U NO-FOCUS FLAT-BUTTON
     LABEL "Button 1" 
     SIZE 129 BY .43.

DEFINE RECTANGLE brwField
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 128 BY 11.67.

DEFINE RECTANGLE brwOther
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 128 BY 6.19.

DEFINE RECTANGLE rectToolbar
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 18 BY .91.

DEFINE RECTANGLE searchField
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.4 BY .91.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     btnSplitBarY AT ROW 14.52 COL 1 WIDGET-ID 6
     brwField AT ROW 2.67 COL 2 WIDGET-ID 2
     brwOther AT ROW 15.05 COL 2 WIDGET-ID 4
     searchField AT ROW 1.33 COL 2.6 WIDGET-ID 8
     rectToolbar AT ROW 1.33 COL 23 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 130.4 BY 20.43 WIDGET-ID 100.


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
         TITLE              = "Serialize name"
         HEIGHT             = 20.43
         WIDTH              = 130.4
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 130.4
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 130.4
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
       FRAME DEFAULT-FRAME:HEIGHT           = 20.43
       FRAME DEFAULT-FRAME:WIDTH            = 130.4.

ASSIGN 
       btnSplitBarY:MOVABLE IN FRAME DEFAULT-FRAME          = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Serialize name */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Serialize name */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btnSplitBarY
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btnSplitBarY C-Win
ON END-MOVE OF btnSplitBarY IN FRAME DEFAULT-FRAME /* Button 1 */
DO:
  DYNAMIC-FUNCTION("setSplitBarY",THIS-PROCEDURE:CURRENT-WINDOW,btnSplitBarY:HANDLE IN FRAME {&FRAME-NAME},NO).
/*  apply "window-resized" to {&window-name}.*/
/*   RUN MoveToTop. */
/*   DYNAMIC-FUNCTION("MoveTabToTop" IN hTabFolder,OrderFolder:HANDLE). */
/*   RUN MoveToTop IN hCurrTabProc NO-ERROR.                            */
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
  &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN  
    DELETE OBJECT oContainer.
  &ENDIF
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DisplayRecord C-Win 
PROCEDURE DisplayRecord :
IF dynamic-function("getCurrentObject") = hBrowse AND hBuffer:avail THEN DO WITH FRAME {&FRAME-NAME}:
    dynamic-function("setAttribute",hBrwOther,"queryJoin",",FIRST _file OF _field NO-LOCK WHERE _tbl-type = 't' AND _file-name NE '" + hBuffer::_file-name + "'").
  END.
  RUN SUPER.

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
  ENABLE btnSplitBarY brwField brwOther searchField rectToolbar 
      WITH FRAME DEFAULT-FRAME IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportRecord C-Win 
PROCEDURE ExportRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cFileName AS CHAR NO-UNDO.

SYSTEM-DIALOG GET-FILE cFileName.
IF cFileName NE "" THEN DO:
  OUTPUT TO VALUE(cFileName).
  hBrowse:QUERY:GET-FIRST ().
  REPEAT WHILE NOT hBrowse:QUERY:QUERY-OFF-END:
    IF hBuffer::_user-misc NE ? THEN 
      PUT UNFORMATTED hBuffer::_file-name "|" hBuffer::_field-name "|" hBuffer::_user-misc SKIP.
    hBrowse:QUERY:GET-NEXT().
  END.
  OUTPUT CLOSE.
END.  
OS-COMMAND NO-WAIT VALUE("notepad " + cFileName).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FillDownRecord C-Win 
PROCEDURE FillDownRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR bCommit AS LOG NO-UNDO.

hBrwOther:QUERY:GET-FIRST ().
REPEAT WHILE NOT hBrwOther:QUERY:QUERY-OFF-END:
  bCommit = YES.
  JBoxServerAPI:Instance:Update("_field", hBuffOther::RowIdent1,"_user-misc", hBuffer::_user-misc,"","",NO).
  hBrwOther:QUERY:GET-NEXT ().
END.
IF bCommit THEN DO:
  DYNAMIC-FUNCTION("DoCommit",YES).
  APPLY "value-changed" TO hBrowse.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ImportRecord C-Win 
PROCEDURE ImportRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF VAR cFileName AS CHAR NO-UNDO.
DEF VAR cInput    AS CHAR NO-UNDO.
DEF VAR bCommit   AS LOG  NO-UNDO.

SYSTEM-DIALOG GET-FILE cFileName.
IF cFileName NE "" THEN DO:
  INPUT FROM VALUE(cFileName).
  REPEAT:
    IMPORT UNFORMATTED cInput.
    hBuffer:FIND-FIRST("WHERE _file-name = '" + ENTRY(1,cInput,"|") + "' AND _field-name = '" + ENTRY(2,cInput,"|") + "'") NO-ERROR.
    IF hBuffer:AVAIL THEN DO:
      JBoxServerAPI:Instance:Update("_field",hBuffer::RowIdent1,"_user-misc",ENTRY(3,cInput,"|"),"","",NO).
      bCommit = YES.
    END.
  END.
  INPUT CLOSE.
  IF bCommit THEN DO:
    JBoxServerAPI:Instance:Commit().
    RUN InvokeMethod(hBrowse,"OpenQuery").
  END.      
END.  


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

DEF VAR hSearchField AS HANDLE NO-UNDO.
DEF VAR hSerialize   AS HANDLE NO-UNDO.
DEF VAR hSerialize2  AS HANDLE NO-UNDO.

DO WITH FRAME {&FRAME-NAME}:
  hBrowse = DYNAMIC-FUNCTION("NewBrowse",
                    BrwField:HANDLE,
                    1000,
                    "",
                    "_Field"
                    + ";_field-name"
                    + ";_label"
                    + ";_user-misc|SerializeName (_user-misc)|x(40)"
                    + ";_data-type"
                    + ";_format"
                 + ",_file"   
                    + ";_file-name@1"
                    ,"WHERE true,FIRST _file OF _field NO-LOCK WHERE _tbl-type = 't'"
                    ,"sort|_file-name").

  hBuffer = hBrowse:QUERY:GET-BUFFER-HANDLE (1).

  hSearchField = DYNAMIC-FUNCTION("NewBrowseSearchField",SearchField:HANDLE,hBrowse,1).
  IF VALID-HANDLE(hSearchField) THEN 
    DYNAMIC-FUNCTION("CreateObjectLink",hSearchField,hBrowse).

  hSerialize  = DYNAMIC-FUNCTION("NewBrowseFillIn",hBrowse,"_user-misc","_user-misc","","","","").
  DYNAMIC-FUNCTION("CreateOverlayLink",hBrowse,hSerialize,"_user-misc").
  DYNAMIC-FUNCTION("setAttribute",hBrowse,"enableOnDblClick","yes").

  DYNAMIC-FUNCTION("NewMenuBand",
                   hBrowse,
                   "MultiSortBrowse;Sort on multiple columns"
                   + ",FillDown;Fill down serialize name"
                  ,"").

  hBrwOther = DYNAMIC-FUNCTION("NewBrowse",
                    brwOther:HANDLE,
                    1000,
                    "",
                    "_Field"
                    + ";_field-name"
                    + ";_label"
                    + ";_user-misc|SerializeName (_user-misc)|x(40)"
                    + ";_data-type"
                    + ";_format"
                 + ",_file"   
                    + ";_file-name@1"
                    ,"WHERE false,FIRST _file OF _field NO-LOCK WHERE _tbl-type = 't'"
                    ,"sort|_file-name").

  hBuffOther = hBrwOther:QUERY:GET-BUFFER-HANDLE(1).

  dynamic-function("setAttribute",hBrwOther,"viewRecordCount","no").
  dynamic-function("createParentLink",hBrwOther,hBrowse,"_field-name").

  hSerialize2  = DYNAMIC-FUNCTION("NewBrowseFillIn",hBrwOther,"_user-misc","_user-misc","","","","").
  DYNAMIC-FUNCTION("CreateOverlayLink",hBrwOther,hSerialize2,"_user-misc").
  DYNAMIC-FUNCTION("setAttribute",hBrwOther,"enableOnDblClick","yes").


  hToolbar = DYNAMIC-FUNCTION("NewToolbar",
                             rectToolbar:HANDLE,      
                             "File",
                             "filter,excel,export,import",
                             "maxborder").
  dynamic-function("CreateObjectLink",hBrowse,hToolbar).                                   
                    
  oContainer:setSplitBarY(btnSplitBarY:HANDLE).
  oContainer:setSplitBarYlimits(btnSplitBarY:HANDLE,100,50). /* 200 pixels from the top, 300 pixels from the bottom */
  oContainer:setFollowSplitBarY(string(hBrowse) + "," + string(hBrwOther)).
  oContainer:setNoResizeY("BrwField," + hBrowse:NAME).
  
  APPLY "value-changed" TO hBrowse.
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

