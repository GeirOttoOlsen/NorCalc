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
DEF VAR hBrowse     AS HANDLE NO-UNDO.
DEF VAR hQuery      AS HANDLE NO-UNDO.
DEF VAR hToolbar    AS HANDLE NO-UNDO.
DEF VAR hFieldMap   AS HANDLE NO-UNDO.
DEF VAR oContainer  AS JBoxContainer NO-UNDO.
def var hParent     as handle no-undo.

DEF VAR oBrowse AS JBoxBrowse.

DEF TEMP-TABLE ttRecord
    FIELD FieldWeight  as int 
    FIELD FieldName    AS CHAR FORMAT "x(30)"  LABEL "Field name"
    FIELD FieldValue   AS CHAR FORMAT "x(256)" LABEL "Value"
    FIELD TableName    AS CHAR
    FIELD DatabaseName AS CHAR
    FIELD RowIdent1    AS CHAR
    FIELD RowCount     AS INT
    .


DEF VAR otbRecord AS JBoxToolbar NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS brwRecord tbRecord excel_tbRecord 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setFieldWeight C-Win 
FUNCTION setFieldWeight RETURNS integer
  ( INPUT iphBufferField as handle,
    input ipExtent as int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON excel_tbRecord 
     IMAGE-UP FILE "gif/afexcel.gif":U
     LABEL "Eksporter til E&xcel" 
     SIZE 6 BY 1.52 TOOLTIP "Eksporter til E&xcel (ALT-X)".

DEFINE RECTANGLE brwRecord
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 61 BY 17.62.

DEFINE RECTANGLE tbRecord
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL  GROUP-BOX  ROUNDED 
     SIZE 60.8 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     excel_tbRecord AT ROW 1.33 COL 2.2 WIDGET-ID 6
     brwRecord AT ROW 3.14 COL 2 WIDGET-ID 2
     tbRecord AT ROW 1.24 COL 2 WIDGET-ID 4
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SCROLLABLE SIZE 62.8 BY 20.1 WIDGET-ID 100.


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
         TITLE              = "<Insert window title>"
         HEIGHT             = 20.1
         WIDTH              = 63.2
         MAX-HEIGHT         = 23.52
         MAX-WIDTH          = 114.2
         VIRTUAL-HEIGHT     = 23.52
         VIRTUAL-WIDTH      = 114.2
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
       FRAME DEFAULT-FRAME:HEIGHT           = 20.1
       FRAME DEFAULT-FRAME:WIDTH            = 62.8.

ASSIGN 
       tbRecord:PRIVATE-DATA IN FRAME DEFAULT-FRAME     = 
                "excel;Eksporter til E&xcelmaxborder".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* <Insert window title> */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* <Insert window title> */
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

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE DO:
  IF NOT DYNAMIC-FUNCTION("DoCleanUpObjects",THIS-PROCEDURE:CURRENT-WINDOW) THEN RETURN NO-APPLY.
  DYNAMIC-FUNCTION("SetCleanUpResize",THIS-PROCEDURE:CURRENT-WINDOW).
  PUBLISH "InvalidateHandle" (THIS-PROCEDURE).
  IF CAN-DO(hParent:INTERNAL-ENTRIES,"MoveToTop") THEN DO:
    RUN MoveToTop in hParent NO-ERROR.
    IF VALID-HANDLE(hParent:CURRENT-WINDOW) THEN DO:
      hParent:CURRENT-WINDOW:SENSITIVE = TRUE.
      JBoxSession:Instance:setDelayedFocus(hParent).
    END.  
  END.  
  RUN disable_UI.
END.

{incl/wintrigg.i}
/*{incl/conttrigg.i oBrw<>:BROWSE-HANDLE} */

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
   hParent = source-procedure.
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
  ENABLE brwRecord tbRecord excel_tbRecord 
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
RUN enable_UI.

oContainer = NEW JBoxContainer().
oContainer:addStatusBar().

DO WITH FRAME {&FRAME-NAME}:
  oBrowse = NEW JBoxBrowse(brwRecord:HANDLE,      /* handle to place-holder rectangle */
                           YES,                       /* multiple-select? */ 
                           "",                        /* title */
                           NO,                        /* row-markers (if multiple) */
                           BUFFER ttRecord:HANDLE). /* The BUFFER ttCust.. parameter tells the browse that it is works on a local temp-table */
  
  /* Set visible fields by (optionally - sequence doesn't matter) */                         
  oBrowse:buffersAndFields = "ttRecord;!FieldWeight;FieldName;FieldValue".
  oBrowse:setQuerySort('FieldWeight;Desc').
  
  oBrowse:enabledColumns = "FieldName,FieldValue".
  oBrowse:enableOnDblClick = YES. 

  otbRecord = NEW JBoxToolbar(tbRecord:HANDLE).

  otbRecord:BROWSE-OBJECT = oBrowse.

END.


oContainer:initResize().

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE receiveTTRecord C-Win 
PROCEDURE receiveTTRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM hTT AS handle NO-UNDO.

IF VALID-HANDLE(hTT) THEN DO:
  hTT:DEFAULT-BUFFER-HANDLE:FIND-FIRST ("WHERE true").
  RUN ViewTtRecord(hTT:DEFAULT-BUFFER-HANDLE).
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewDbRecord C-Win 
PROCEDURE ViewDbRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM icTable AS CHAR NO-UNDO.
DEF INPUT PARAM icRowId AS CHAR NO-UNDO.

DEF VAR httDbRecord AS HANDLE NO-UNDO.

httDbRecord = JBoxServerAPI:Instance:GetDbTable(icTable,"WHERE ROWID(" + icTable + ") = TO-ROWID('" + icRowId + "')").
IF VALID-HANDLE(httDbRecord) THEN DO:
  httDbRecord:DEFAULT-BUFFER-HANDLE:FIND-FIRST ("WHERE true").
  RUN ViewTtRecord(httDbRecord:DEFAULT-BUFFER-HANDLE).
END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ViewTtRecord C-Win 
PROCEDURE ViewTtRecord :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
DEF INPUT PARAM ihBuffer AS HANDLE NO-UNDO.
def var iy as int no-undo.
def var hField as handle no-undo.

EMPTY TEMP-TABLE ttRecord.

IF ihBuffer:AVAIL THEN DO:
  oBrowse:BROWSE-HANDLE:HELP = ihBuffer:NAME.
  DO ix = 1 TO ihBuffer:NUM-FIELDS:
      if ihBuffer:buffer-field(ix):extent gt 0 then do iy = 1 to ihBuffer:buffer-field(ix):extent:
      CREATE ttRecord.
      ASSIGN ttRecord.FieldName   = ihBuffer:BUFFER-FIELD(ix):NAME + (if iy gt 0 then ' [' + string(iy) + ']' else '')
             ttRecord.FieldValue  = STRING(ihBuffer:BUFFER-FIELD(ix):BUFFER-VALUE(iy))
             ttRecord.FieldWeight = setFieldWeight(ihBuffer:buffer-field(ix),iy)
             .
    end.
    else do:
      CREATE ttRecord.
      ASSIGN ttRecord.FieldName   = ihBuffer:BUFFER-FIELD(ix):NAME 
             ttRecord.FieldValue  = STRING(ihBuffer:BUFFER-FIELD(ix):BUFFER-VALUE)
             ttRecord.FieldWeight = setFieldWeight(ihBuffer:buffer-field(ix),0)
             .
    end.
    
  END.    
END.
oBrowse:openQuery().

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setFieldWeight C-Win 
FUNCTION setFieldWeight RETURNS integer
  ( INPUT iphBufferField AS handle,
    input ipExtent as int ) :
/*------------------------------------------------------------------------------
  Purpose:
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:  
    if ipExtent gt 0 then   
    case iphBufferField:data-type:
      when 'integer'     then if iphBufferField:buffer-value(ipExtent) gt 0 and iphBufferField:buffer-value(ipExtent) ne ? then return 1. else return 0.
      when 'character'   then if iphBufferField:buffer-value(ipExtent) ne '' and iphBufferField:buffer-value(ipExtent) ne ? then return 1. else return 0.
      when 'date'        then if iphBufferField:buffer-value(ipExtent) ne ? then return 1. else return 0.
      when 'datetime'    then if iphBufferField:buffer-value(ipExtent) ne ? then return 1. else return 0.
      when 'datetime-tz' then if iphBufferField:buffer-value(ipExtent) ne ? then return 1. else return 0.
      when 'logical'     then if iphBufferField:buffer-value(ipExtent) and iphBufferField:buffer-value(ipExtent) ne ? then return 1. else return 0.
      when 'decimal'     then if iphBufferField:buffer-value(ipExtent) gt 0 and iphBufferField:buffer-value(ipExtent) ne ? then return 1. else return 0.
      otherwise return 0.
    end case.
    else     
      case iphBufferField:data-type:
        when 'integer'     then if iphBufferField:buffer-value gt 0 and iphBufferField:buffer-value ne ? then return 1. else return 0.
        when 'character'   then if iphBufferField:buffer-value ne '' and iphBufferField:buffer-value ne ? then return 1. else return 0.
        when 'date'        then if iphBufferField:buffer-value ne ? then return 1. else return 0.
        when 'datetime'    then if iphBufferField:buffer-value ne ? then return 1. else return 0.
        when 'datetime-tz' then if iphBufferField:buffer-value ne ? then return 1. else return 0.
        when 'logical'     then if iphBufferField:buffer-value and iphBufferField:buffer-value ne ? then return 1. else return 0.
        when 'decimal'     then if iphBufferField:buffer-value gt 0 and iphBufferField:buffer-value ne ? then return 1. else return 0.
        otherwise return 0.
      end case.
      
  END.
  CATCH eAny AS Progress.Lang.Error :
    MESSAGE 'herxx:' eAny:GetMessage(1) skip ipExtent skip iphBufferField:name
    VIEW-AS ALERT-BOX.  
  END CATCH.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

